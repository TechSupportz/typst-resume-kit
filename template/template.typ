// ---------------------------------------------------------------------------
// template/template.typ — the layout engine.
//
// Public API (this is all base.typ needs):
//   #show: resume.with(name: .., contact: (..))    document setup
//   #section[Education]                            heading + full-width rule
//   #entry(title: .., date: .., subtitle: .., meta: .., bullets: (..))
//   #code[UITabBar]                                inline monospace
//
// Spacing between sections/entries is inserted automatically, so the content
// file contains no manual \vspace-style fiddling.
//
// Auto-fit: pass `--input fit=0.95` to shrink type and spacing uniformly.
// `fit` defaults to 1.0, which reproduces the original LaTeX design exactly.
// build.sh finds the largest `fit` that still yields a single page.
// ---------------------------------------------------------------------------

#import "theme.typ": theme as t

#let fit = float(sys.inputs.at("fit", default: "1.0"))
#let sz(key) = t.at(key) * fit

// Layout state -------------------------------------------------------------
#let _started = state("resume-started", false) // any section emitted yet?
#let _in-section = state("resume-in-section", false) // entry emitted in this one?

// --- Public components ------------------------------------------------------

/// Inline monospace, e.g. #code[UITabBar].
#let code(body) = text(font: t.mono-font, size: t.mono-size, body)

/// A section heading followed by a full-width rule.
#let section(title) = {
  context if _started.get() { v(sz("gap-section"), weak: false) }
  _started.update(true)
  _in-section.update(false)

  text(size: sz("size-section"), weight: "bold", upper(title))
  parbreak()
  v(sz("gap-heading-rule"), weak: false)
  line(length: 100%, stroke: t.rule-stroke)
  v(sz("gap-rule-entry"), weak: false)
}

#let _row(lhs, rhs) = grid(
  columns: (1fr, auto),
  column-gutter: 1em,
  lhs,
  align(right, rhs),
)

/// A two-row entry: bold title + date on the first row, italic subtitle +
/// meta on the second, then an optional bullet list. Omit `subtitle`/`meta`
/// for a single-row entry.
#let entry(
  title: none,
  date: none,
  subtitle: none,
  meta: none,
  bullets: (),
) = {
  context if _in-section.get() { v(sz("gap-entry-entry"), weak: false) }
  _in-section.update(true)

  let big = text.with(size: sz("size-entry"), weight: "bold")
  let small = text.with(size: sz("size-entry"), style: "italic")

  _row(big(title), big(date))
  if subtitle != none or meta != none {
    v(sz("gap-entry-rows"), weak: false)
    _row(small(subtitle), small(meta))
  }
  if bullets != none and bullets.len() > 0 {
    v(sz("gap-entry-bullets"), weak: false)
    set strong(delta: 200) // regular 400 + 200 = semibold, not bold
    list(
      tight: false,
      spacing: sz("gap-bullets"),
      indent: 0pt,
      body-indent: 0pt,
      marker: box(width: t.bullet-indent * fit, align(left, t.bullet-marker)),
      ..bullets,
    )
  }
}

// --- Document setup ---------------------------------------------------------

#let resume(name: none, contact: (), title: none, body) = {
  set document(title: if title != none { title } else { name + " Resume" })
  set page(paper: t.paper, margin: t.margin)

  // A line box exactly 1em tall with zero leading reproduces LaTeX's
  // \fontsize{s}{s}: consecutive baselines sit exactly one font size apart.
  set text(
    font: t.font,
    size: sz("size-body"),
    lang: "en",
    hyphenate: t.hyphenate,
    top-edge: 0.75em,
    bottom-edge: -0.25em,
  )
  set par(leading: 0pt, spacing: 0pt, justify: t.justify)
  set block(spacing: 0pt)

  align(center, text(size: sz("size-name"), weight: "bold", name))
  v(sz("gap-name-contact"), weak: false)
  align(center, contact.join([ | ]))
  v(sz("gap-contact-body"), weak: false)

  body
}
