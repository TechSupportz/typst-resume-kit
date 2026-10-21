// ---------------------------------------------------------------------------
// template/theme.typ — every visual knob lives here.
//
// All the `gap-*` values are measured from the original LaTeX output, so the
// defaults reproduce it pt-for-pt. Tweak anything here to restyle the whole
// document; nothing else needs to change.
// ---------------------------------------------------------------------------

#let theme = (
  // --- Page --------------------------------------------------------------
  paper: "a4",
  margin: (
    left: 1.25cm,
    right: 1.25cm,
    // Tuned so the first baseline lands exactly where the LaTeX version put
    // it (LaTeX lets the name's ascender overshoot the nominal 0.5cm margin).
    top: 13.25pt,
    bottom: 0.5cm,
  ),

  // --- Fonts -------------------------------------------------------------
  font: "Source Sans Pro",
  mono-font: "Source Code Pro",
  // Computer Modern Typewriter (what LaTeX used) is narrower than most mono
  // faces; 0.875em makes Source Code Pro match its advance width.
  mono-size: 0.875em,

  // --- Type sizes --------------------------------------------------------
  size-body: 9.96pt, // LaTeX's "10pt" is really 9.96264pt
  size-name: 20.74pt, // \huge at 10pt
  size-section: 9.96pt,
  size-entry: 9.96pt,

  // --- Vertical rhythm ---------------------------------------------------
  // Each value is the gap between the *bottom* of the preceding line box and
  // the *top* of the following one. Line boxes are exactly 1em tall, so a gap
  // of 0pt means single spacing.
  gap-name-contact: 1.49pt, // name -> contact line
  gap-contact-body: 3.33pt, // contact line -> first section heading
  gap-heading-rule: 2.80pt, // section heading -> horizontal rule
  gap-rule-entry: 3.76pt, // horizontal rule -> first entry
  gap-entry-rows: 2.04pt, // entry title row -> subtitle row
  gap-entry-bullets: 1.62pt, // entry (last row) -> first bullet
  gap-bullets: 2.5pt, // between bullets
  gap-entry-entry: 2.43pt, // last bullet -> next entry in same section
  gap-section: 7.12pt, // last bullet -> next section heading

  // --- Section rule ------------------------------------------------------
  rule-stroke: 0.398pt,

  // --- Bullets -----------------------------------------------------------
  bullet-marker: [•],
  bullet-indent: 13pt, // left edge of bullet text, measured from the margin

  // --- Paragraphs --------------------------------------------------------
  justify: true,
  hyphenate: true,
)
