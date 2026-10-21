#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# build.sh — compile each resume variant, shrinking type + spacing until it
# fits on one page.
#
# The template exposes a single `fit` multiplier (see template/template.typ) that
# scales every font size and every vertical gap together. This script binary-
# searches for the largest `fit` that still produces MAX_PAGES pages, so the
# resume stays as large and readable as it can while never spilling over.
#
#   ./build.sh                 -> every resume/variants/<name>.typ
#                                 to out/resume-<name>.pdf; job-specific
#                                 variants (not in GENERIC) go to
#                                 out/company/<name>/<PREFIX>_Resume.pdf,
#                                 with resume/cover-letters/<name>.typ beside
#                                 it as <PREFIX>_Cover_Letter.pdf;
#                                 an out/company/<name>/SUBMITTED.md freezes that
#                                 folder, and it is never rebuilt
#   ./build.sh mobile general  -> just those variants
#   MAX_PAGES=2 ./build.sh     -> allow two pages
#   FIT=0.92 ./build.sh        -> skip the search, force a scale
#   PHONE=1 ./build.sh general -> add the phone number from private/phone.txt;
#                                 output goes to the gitignored private/out/
#                                 instead of out/, and ignores SUBMITTED.md;
#                                 generic variants go to
#                                 private/out/<name>/<PREFIX>_Resume.pdf
#                                 Company variants always get this phone copy
#                                 too: a plain build of one re-runs itself with
#                                 PHONE=1 when private/phone.txt exists
# ---------------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")"

MAX_PAGES=${MAX_PAGES:-1}
FIT_MAX=${FIT_MAX:-1.00}   # 1.00 == the original design, untouched
FIT_MIN=${FIT_MIN:-0.80}   # below this the resume stops being readable
TOL=${TOL:-0.002}          # search precision
GENERIC=" general "   # everything else is a company variant
PREFIX=Your_Name   # set during setup: used in output file names

OUTDIR=out
EXTRA=()
if [[ -n "${PHONE:-}" ]]; then
  [[ -s private/phone.txt ]] || { echo "PHONE=1 needs private/phone.txt" >&2; exit 1; }
  EXTRA=(--input "phone=$(head -n1 private/phone.txt)")
  OUTDIR=private/out
fi

TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
mkdir -p "$OUTDIR"

compile() { # $1 = fit, $2 = output
  typst compile --root . --font-path template/fonts \
    --creation-timestamp 0 \
    --input "fit=$1" ${EXTRA[@]+"${EXTRA[@]}"} "$SRC" "$2"
}

pages() { # $1 = pdf
  if command -v pdfinfo >/dev/null 2>&1; then
    pdfinfo "$1" | awk '/^Pages:/ {print $2}'
  else
    # grep the page tree as a fallback when poppler isn't installed
    strings "$1" | grep -c '/Type[[:space:]]*/Page[^s]' || echo 1
  fi
}

build() { # $1 = source .typ, $2 = output pdf
  local SRC=$1 OUT=$2 lo hi mid
  if [[ -n "${FIT:-}" ]]; then
    compile "$FIT" "$OUT"
    echo "built $OUT at fit=$FIT ($(pages "$OUT") page(s))"
    return 0
  fi

  # Fast path: does the full-size version already fit?
  compile "$FIT_MAX" "$TMP/probe.pdf"
  if [[ "$(pages "$TMP/probe.pdf")" -le "$MAX_PAGES" ]]; then
    compile "$FIT_MAX" "$OUT"
    echo "built $OUT at fit=$FIT_MAX (fits in $MAX_PAGES page(s) at full size)"
    return 0
  fi

  # Does anything fit at all?
  compile "$FIT_MIN" "$TMP/probe.pdf"
  if [[ "$(pages "$TMP/probe.pdf")" -gt "$MAX_PAGES" ]]; then
    compile "$FIT_MIN" "$OUT"
    echo "WARNING: still $(pages "$OUT") page(s) at the minimum fit=$FIT_MIN." >&2
    echo "         Cut some content, or raise MAX_PAGES / lower FIT_MIN." >&2
    return 1
  fi

  # Binary search for the largest fit that still fits.
  lo=$FIT_MIN; hi=$FIT_MAX
  while (( $(echo "$hi - $lo > $TOL" | bc -l) )); do
    mid=$(echo "scale=4; ($lo + $hi) / 2" | bc -l)
    compile "$mid" "$TMP/probe.pdf"
    if [[ "$(pages "$TMP/probe.pdf")" -le "$MAX_PAGES" ]]; then lo=$mid; else hi=$mid; fi
  done

  compile "$lo" "$OUT"
  echo "built $OUT at fit=$lo (auto-shrunk to fit $MAX_PAGES page(s))"
}

if [[ $# -eq 0 ]]; then
  set -- resume/variants/*.typ
fi

status=0
company=()
for v in "$@"; do
  name=$(basename "$v" .typ)
  if [[ "$GENERIC" == *" $name "* ]]; then
    if [[ -n "${PHONE:-}" ]]; then
      mkdir -p "$OUTDIR/$name"
      build "resume/variants/$name.typ" "$OUTDIR/$name/${PREFIX}_Resume.pdf" || status=1
    else
      build "resume/variants/$name.typ" "$OUTDIR/resume-$name.pdf" || status=1
    fi
    continue
  fi
  if [[ -z "${PHONE:-}" && -f "out/company/$name/SUBMITTED.md" ]]; then
    echo "skipped out/company/$name/ (submitted; see SUBMITTED.md)"
    continue
  fi
  company+=("$name")
  mkdir -p "$OUTDIR/company/$name"
  build "resume/variants/$name.typ" "$OUTDIR/company/$name/${PREFIX}_Resume.pdf" || status=1
  letter="resume/cover-letters/$name.typ"
  if [[ -f "$letter" ]]; then
    typst compile --root . --font-path template/fonts --creation-timestamp 0 \
      ${EXTRA[@]+"${EXTRA[@]}"} "$letter" "$OUTDIR/company/$name/${PREFIX}_Cover_Letter.pdf" || status=1
    echo "built $OUTDIR/company/$name/${PREFIX}_Cover_Letter.pdf"
  fi
done

# Company applications go out with the phone number, so build that copy too.
if [[ -z "${PHONE:-}" && ${#company[@]} -gt 0 ]]; then
  if [[ -s private/phone.txt ]]; then
    PHONE=1 "$0" "${company[@]}" || status=1
  else
    echo "WARNING: no private/phone.txt, so no phone copy of: ${company[*]}" >&2
  fi
fi
exit $status
