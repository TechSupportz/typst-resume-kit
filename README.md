# Résumé (Typst)

A one-page résumé template in [Typst](https://typst.app). Content lives in small
files, each résumé *variant* picks which entries to show, and the build shrinks
type and spacing just enough to keep everything on one page.

## Quick start

```bash
brew install typst      # the only dependency; fonts are bundled
./build.sh              # -> out/resume-general.pdf
```

The repo ships with placeholder content. To make it yours, open it in Claude
Code, Codex or another coding agent and say:

> Set up this résumé for me.

The agent follows `SETUP.md`: it asks for your details and existing résumé,
writes your entries, learns how you want them to sound and records that in
`AGENTS.md`, so later edits stay in your voice.

## Build

```bash
./build.sh                  # every variant, one page each
./build.sh acme             # just one (or several) variants
MAX_PAGES=2 ./build.sh      # allow two pages
FIT=0.95 ./build.sh         # skip the search, force a scale
PHONE=1 ./build.sh general  # add the number in private/phone.txt -> private/out/ (gitignored)
```

Live preview while editing:

```bash
typst watch --root . --font-path template/fonts resume/variants/general.typ out/resume-general.pdf
```

## Files

```
resume/                 the content — the only directory you normally edit
  variants/             one file per résumé: picks projects + activities
  base.typ              shared header, Education, Experience and Skills
  components.typ        imports every component, so variants need one import
  contact.typ           the contact line under your name
  content/
    education/          one file per school
    experience/         one file per job
    projects/           one file per project
    extras/             activities and other non-project entries
    skills.typ          the skills block
  cover-letters/        <variant>.typ builds beside that variant's résumé
out/
  resume-<name>.pdf     each generic variant (listed in GENERIC in build.sh)
  company/<company>/    a job-specific variant, its cover letter, and
                        SUBMITTED.md once sent, which freezes the folder
template/
  template.typ          layout engine: `section`, `entry`, `code`
  theme.typ             every visual knob: margins, fonts, sizes, gaps
  fonts/                Source Sans Pro + Source Code Pro (vendored)
build.sh                compiles with the one-page auto-fit search
AGENTS.md               how entries should read — the agent's voice guide
SETUP.md                first-time setup, for the agent
```

## Variants

Each file in `resume/variants/` is one résumé. Education, Experience and Skills
come from `resume/base.typ`; a variant picks its projects and activities, in
order:

```typ
#import "../base.typ": variant
#import "../components.typ": *

#show: variant.with(
  projects: (example-project,),
  activities: (example-club,),
)
```

To tailor for a job, copy a variant to `resume/variants/acme.typ`, swap the
projects and run `./build.sh acme`; it builds to `out/company/acme/`. Once the
application is sent, add `out/company/acme/SUBMITTED.md`: the build then skips
that variant, so later edits to shared content never overwrite what you sent.

## Writing a component

```typ
#import "../../../template/template.typ": entry, code

#let acme = entry(
  title: [Acme Corp],                   // bold, left
  date: [Apr 2023 -- Apr 2024],         // bold, right
  subtitle: [Software Engineer Intern], // italic, left
  meta: [City],                         // italic, right
  bullets: (
    [Did a thing. Use *bold* for emphasis and #code[Identifier] for code.],
    [Another thing.],
  ),
)
```

Put it in its own file under `resume/content/`, add its import to
`resume/components.typ`, and use the name in a variant or `base.typ`.

* Omit `subtitle`/`meta` for a one-row entry; omit `bullets` for none.
* Links: `link("https://…")[Text]`, underlined with `#underline[Text]`.
* `--` renders as an en dash, `---` as an em dash.
* Spacing between sections and entries is automatic.

## How the one-page fit works

`template/template.typ` reads a `fit` multiplier and scales every font size and
vertical gap by it. `build.sh` binary-searches for the largest `fit` in
`[0.80, 1.00]` that still compiles to `MAX_PAGES` pages. If the content
overflows even at `0.80`, the build fails loudly instead of producing an
unreadable page.

## Licence

The template, build script and placeholder content are under the [MIT License](LICENSE).
The bundled Source Sans Pro and Source Code Pro fonts are Adobe's, under the SIL
Open Font License 1.1 ([`template/fonts/OFL.txt`](template/fonts/OFL.txt)).
