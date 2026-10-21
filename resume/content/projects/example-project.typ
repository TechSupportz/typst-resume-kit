#import "../../../template/template.typ": entry

#let example-project = entry(
  title: link("https://example.com")[Example Project],
  date: [Jan 2025 -- Present],
  subtitle: [
    Short Plain-Language Descriptor |
    #link("https://example.com")[#underline[Website]]
  ],
  meta: [Swift, Python],
  bullets: (
    [Built an app that solves a real problem for a named group of users,
     growing to *a real number of active users*.],
    [Designed the main screen around what users need first, explaining the
     judgement behind the choice rather than listing features.],
  ),
)
