# First-time setup

You are turning this template into one person's résumé. The repo holds
placeholder content (`Your Name`, `example-*` components). Work through the
steps in order; each ends on its **done when**.

## 1. Gather

Ask the owner for their existing résumé (PDF, text or a link) and anything it
leaves out: projects, metrics, links, roles they are targeting. Ask whether
they use British or American spelling.

**Done when** you hold every job, school, project, activity and skill they
want listed, each with dates, and you know their target roles.

## 2. Identity

- `resume/base.typ`: replace `Your Name`.
- `resume/contact.typ`: their city, email, site and any profile links (GitHub,
  LinkedIn) — whatever they want in the header.
- `build.sh`: set `PREFIX` to their name in `First_Last` form; it names the
  company PDFs.
- Phone number: if they want one on applications, write it to
  `private/phone.txt` (gitignored) — never into a tracked file.

**Done when** `grep -rn "Your Name\|Your_Name\|example.com" resume build.sh`
prints nothing.

## 3. Learn the voice

Read their existing résumé, then interview them until you can write the
**Voice** section of `AGENTS.md` in their terms:

- **Positioning** — what a reader should take away about them, and what each
  bullet leads with to show it.
- **Bullets** — verb and tense, length, bullets per entry, how concrete.
- **Spelling** — British or American; Oxford comma or not.
- **Emphasis** — whether to bold anything, and what.
- **Model bullet** — one bullet from their real history that sounds right to
  them, written out in the section.

Draft the section, show it to them, and revise from their feedback.

**Done when** the Voice section covers all five points above in the owner's
words and they have approved it.

## 4. Write the content

Create one component per entry under `resume/content/`, register each in
`resume/components.typ`, wire education/experience into `resume/base.typ` and
projects/activities into `resume/variants/general.typ`. Write every bullet to
the Voice section; any metric or claim comes from the owner, never from you.
Delete the `example-*` files and `resume/cover-letters/example.typ.sample` once
nothing imports them. If they target distinct roles, add a generic variant per
role and list its name in `GENERIC` in `build.sh`.

**Done when** no `example-` name remains under `resume/` and every bullet
traces to something the owner told you or a source you read.

## 5. Build and review

Run `./build.sh`. A WARNING about the minimum fit means the content overflows:
cut or tighten bullets rather than lowering `FIT_MIN`. Show the owner the PDF
and revise until they sign off.

**Done when** every variant builds to one page without warnings and the owner
has approved the PDF. Then delete this file and its pointer in `AGENTS.md`.
