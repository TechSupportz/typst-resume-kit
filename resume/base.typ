// ===========================================================================
// base.typ — the parts every variant shares: header, Education, Experience and
// Skills. A variant only chooses its projects and activities:
//
//   #import "../base.typ": variant
//   #import "../components.typ": *
//   #show: variant.with(projects: (example-project,), activities: (example-club,))
// ===========================================================================

#import "../template/template.typ": resume, section
#import "components.typ": *
#import "contact.typ": contact

#let variant(projects: (), activities: (), body) = {
  show: resume.with(
    name: [Your Name],
    contact: contact,
  )

  section[Education]
  example-school

  section[Experience]
  example-job

  if projects.len() > 0 {
    section[Projects]
    projects.join()
  }

  if activities.len() > 0 {
    section[Co-Curricular Activities]
    activities.join()
  }

  section[Skills]
  skills

  body
}
