// contact.typ — the header's contact line, shared by resumes and cover letters.
// The phone number never lives in the repo: `PHONE=1 ./build.sh` reads it from
// the gitignored private/phone.txt and passes it in as `--input phone=…`.

#let phone = sys.inputs.at("phone", default: none)

#let contact = (
  [City],
  ..if phone != none { (link("tel:" + phone.replace(" ", ""))[#phone],) },
  link("mailto:you@example.com")[you\@example.com],
  link("https://example.com")[example.com],
)
