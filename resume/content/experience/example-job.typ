#import "../../../template/template.typ": entry, code

#let example-job = entry(
  title: [Example Company],
  date: [May 2025 -- Aug 2025],
  subtitle: [Software Engineer Intern],
  meta: [City],
  bullets: (
    [Built an internal dashboard that replaced manual spreadsheet updates for
     the support team, *cutting weekly reporting from hours to minutes*.],
    [Added validation to the #code[orders] API so malformed requests failed
     with clear errors instead of corrupting records.],
    [*Technologies:* TypeScript, React, PostgreSQL],
  ),
)
