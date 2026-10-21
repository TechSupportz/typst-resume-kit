# Resume repo — guidance for agents

**First-time setup:** while `resume/base.typ` still says `Your Name`, follow
`SETUP.md` before anything else.

Build, file layout and variants are in `README.md`. This file is the **voice**:
how every entry under `resume/content/` should read. Match it when writing or
editing any bullet.

## Voice

<!-- Empty until setup: SETUP.md step 3 writes this section with the owner. -->

## Entry fields

- `subtitle`: a short plain-language descriptor, then a `| Website` or
  `| GitHub` link where one exists.
- `meta`: the two or three technologies that matter most.
- `date`: `Mon YYYY -- Mon YYYY` or `-- Present`.
- `*...*` renders semibold; `*Label:*` opens a bullet like `*Technologies:*`.

Every claim is grounded in the owner's real history — dates, metrics and
features come from them, never from you.

After editing, run `./build.sh` and confirm every variant still fits one page.
