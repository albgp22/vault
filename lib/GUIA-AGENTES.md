# Guide for the agents that write the book

Project root: `/Users/albertogarciaplanes/tmpradio`. Typst 0.15.1 is installed.
The book is the Typst version of `source/generated-radio.pdf` (488 pages, Spanish).
Its text is in `source/generated-radio.txt` (pages are separated by form feeds `\f`).

**Page numbers in this guide are PHYSICAL PDF pages** (book page + 8). To get the text of
physical pages 37–48:

```bash
python3 -I -c "import sys;p=open('/Users/albertogarciaplanes/tmpradio/source/generated-radio.txt').read().split('\f');print('\f'.join(p[36:48]))"
```

To SEE a page (formulas, figures, tables — the text extraction breaks superscripts such as
`3 × 108` for 3·10⁸, and loses all figure content):

```bash
pdftoppm -r 80 -png -f 37 -l 37 /Users/albertogarciaplanes/tmpradio/source/generated-radio.pdf /Users/albertogarciaplanes/tmpradio/build/src-<yourkey>
```

then open the PNG with the Read tool. Look at every page that has a figure, a table or
non-trivial math. Do not guess.

## 1. Files and ownership

- You write ONLY the files that your assignment names, inside `chapters/`.
- Do not edit `lib/`, `main.typ`, other chapters, or `source/`. If you need a new macro,
  define it locally at the top of your file with a `_<yourkey>-` prefix, and report it.
- Temporary files go in `build/` with your key in the name.

Every chapter file starts with:

```typst
#import "/lib/template.typ": *
#import "/lib/circuits.typ": *
```

Check your file often (it compiles the file alone with the book template):

```bash
cd /Users/albertogarciaplanes/tmpradio && tools/check.sh chapters/t01.typ T1
# arguments after the file = question groups whose answer key + solutions to append
PNG=1 PAGES=3-6 tools/check.sh chapters/t01.typ T1   # also renders pages to build/png/
```

The file must compile with **no errors**. Warnings about unresolved `#ver(...)` labels of
OTHER agents are fine (they show as red `[?? label]` until the full book compiles).
Use `@label` only for labels defined in YOUR file.

`tools/demo-capitulo.typ` is a working example of every macro below. Read it first.

## 2. Structure macros (from `lib/template.typ`)

| Need | Code |
|---|---|
| Intro chapter title | (written by the integrator in `main.typ` — you do not write it) |
| Exam topic (tema) | `#tema("T1", "Teoría de la electricidad, el electromagnetismo y la radio", alcance: [Conductividad … (DSP).])` |
| Appendix | `#apendice("B", "Preguntas complementarias")` (only the agent that owns the start) |
| Section (numbered T1.1., A.1., 1.) | `== Unidades y leyes fundamentales <t1-sec-unidades>` |
| Subsection (unnumbered) | `=== La ley de Ohm` |
| Small heading | `==== …` |
| Run-in paragraph title | `#ptitulo[La idea de Maxwell] Texto…` |

**Never write a level-1 heading (`= …`).** The macros make them.

## 3. Didactic boxes

```typst
#motivacion[…]   // "EL PROBLEMA": the problem the next idea solves. Put it BEFORE the idea.
#analogia[…]     // "IMAGEN MENTAL": mechanical / water analogy
#idea[…]         // "IDEA CLAVE": what the reader must keep
#porque[…]       // "POR QUÉ FUNCIONA": REQUIRED after every circuit diagram
#ojo[…]          // "¡OJO EN EL EXAMEN!": exam trap
#ejemplo[…]      // "EJEMPLO RESUELTO": numeric worked example
#nota[…]         // "NOTA": the source's NOTA boxes
#truco[…]        // "TRUCO": the source's TRUCO boxes (tips, mnemonics)
// the source's "¡OJO!" boxes → #ojo[…]
#destacada($ f_0 = 1 / (2 pi sqrt(L C)) $, nota: [frecuencia de resonancia])
```

All accept `titulo: [...]` for a short title after the label.

## 4. Exercises (intro chapters) and exam questions

```typst
#ejercicio(sol: [La reactancia es $X_C = 1/(2 pi f C) approx 227 Omega$.])[
  Calcula la reactancia de un condensador de 100 pF a 7 MHz.
]
```

Exercises are numbered per chapter automatically. Their solutions are collected at the end of
the chapter by `#soluciones-ejercicios()` (the integrator places it).

```typst
#q("T1.8", "b",
  [La potencia disipada en una resistencia de 30 ohmios por la que circula una corriente de 2 amperios es de:],
  ([60 vatios], [120 vatios], [15 vatios], [240 vatios]),
  sol: [$P = I^2 R = 2^2 dot 30 = 120$ W. La corriente entra al cuadrado: doblarla cuadruplica la potencia disipada.],
)
```

- `id` exactly as in the source (`T1.8`, `C-T6.3`, `F-R8.112`, `C-H.4`). Group = text before the
  last dot. Keep the source order. Never drop, merge, or renumber a question.
- `ans` = the letter from the source answer key / reasoned solution (appendix D of the PDF).
  Copy it; never "correct" it. If the source solution says the key is debatable, keep the
  source letter and keep its comment in `sol`.
- `sol` = the full reasoned solution text from appendix D, without the leading `T1.8 (b)`.
- Options are auto-laid out in 4, 2 or 1 columns. A question can contain a figure in its
  stem (schematic questions): put a `#circuito(...)` or `#figure(...)` inside the stem.
- The answer key tables of appendix D are generated from these calls. You do not write them.

## 5. Figures, schematics, plots

```typst
#circuito(caption: [Amplificador de emisor común.], sim: "<file from catalog>")[
  #esquema({
    import zap: *
    import cetz.draw: content, line, rect, circle   // only what you use
    resistor("r1", (2, 6), (2, 3), label: $R_1$)
    npn("q1", (4.2, 3))          // anchors: q1.b, q1.c, q1.e  (c is 0.5 above, e 0.5 below the node)
    wire((2, 3), "q1.b")
    capacitor("c1", (0, 3), (2, 3), label: $C_1$, n: "o-*")   // n: "o-" open terminal, "*" dot
    ground("g", (4, 0))
  })
] <t3-fig-ec>
```

- `#circuito` = `figure(kind: image)` with an optional Falstad badge (`sim:`). Use it for
  every schematic, plot or block diagram. Label it `<yourkey-fig-…>` and cite it with `@…`.
- zap components: `resistor potentiometer rheostat capacitor (variable: true = varicap/variable)
  pcapacitor inductor transformer diode zener led schottky photodiode npn pnp nmos pmos opamp
  vsource acvsource isource vcc vee ground earth frame antenna switch fuse node wire zwire swire`.
  Labels: `label: $R_1$` or `label: (content: [..], anchor: "south")`. Two-terminal parts take two
  points; one-terminal parts (npn, opamp, ground, antenna, vcc) take one point.
  Opamp anchors: `minus`, `plus`, `out`.
- Extra components (from `lib/circuits.typ`; call them by their plain name, e.g. `cristal(...)`, `trafo(...)` — `comp.cristal(...)` does NOT compile in Typst 0.15):
  `cristal`, `bateria`, `medidor` (`letra: "V"`), `lampara`, `altavoz`, `microfono`, `triodo`
  (one point; anchors `placa`, `rejilla`, `catodo`), `trafo` (one point; anchors `p1 p2 s1 s2`;
  `nucleo: false` for an air-core RF transformer; `espiras: (5, 2)` for a step-down ratio).
  Prefer `trafo` over zap's `transformer` (two circles, unclear for beginners).
- `#esquema(...)` sets the book style: IEC rectangles for resistors, coils drawn as loops,
  op-amps as triangles. Always draw schematics with `esquema`, not `zap.circuit`.
- Block diagrams: fletcher (`#diagram(node-stroke: .7pt, node-corner-radius: 2pt, spacing: (9mm, 8mm), node((0,0), [Mezclador], shape: rect), edge("-|>"), …)`).
  Always pass `shape: rect` for short labels (fletcher draws circles otherwise).
- Waveforms / curves: `cetz.canvas({ import cetz.draw: *; ejes(0, 6, -1.2, 1.4, etq-x: $t$, etq-y: $v$); onda(x => calc.sin(2*x), 0, 6, stroke: 1.1pt + col.senal1) })`.
  `cetz-plot` 0.1.3 is also imported in the template as `cetz-plot` if you need real axes.
  Colors: `col.senal1 … col.senal4`, `col.acento`, `col.naranja`, `col.verde`, `col.gris`.
- **Look at every figure you draw** (`PNG=1 PAGES=…`). Check: no overlapping labels, wires
  meet at the terminals, the circuit is electrically correct, polarities are right (electrolytic
  `+`, diode direction, NPN arrow out of the emitter), and it fits the text width.

## 6. Falstad links

The user wants: *each time the book shows a circuit, explain why it works, and add a link to
Falstad if that circuit exists there.*

- The verified list of Falstad example circuits is `lib/falstad-catalog.md` (another agent is
  building it now; it should exist within ~20 minutes of your start). Write your content first and
  add the `sim:` links near the end. Use ONLY entries from that catalog. Use `sim: "file.txt"`
  for catalog files, or the full URL the catalog gives.
- Link only when the Falstad circuit really shows the same idea (read the "what it shows" column).
  Never invent a file name. If the catalog does not exist when you finish, leave a comment
  `// FALSTAD-TODO: <what circuit>` next to the figure and report it.
- In running text you can also write `#falstad("file.txt")` to place the badge inline.

## 7. Cross-references between chapters

Use `#ver(<label>)` to cite a section of another file (renders «Title», p. N). These shared
labels are reserved; the OWNER must put the label on a `==` or `===` heading:

| Owner | Labels |
|---|---|
| intro-1 | `<sec-em>` `<sec-impedancia>` `<sec-reactancia>` `<sec-resonancia>` `<sec-filtros-rc>` `<sec-antena>` `<sec-am>` `<sec-fm>` `<sec-cuadro>` |
| intro-2a | `<sec-esquemas>` `<sec-resistencia>` `<sec-condensador>` `<sec-bobina>` `<sec-transformador>` `<sec-diodo>` `<sec-fuente>` `<sec-redes-adaptacion>` |
| intro-2b | `<sec-transistor>` `<sec-polarizacion>` `<sec-amplificador-ec>` `<sec-configuraciones>` `<sec-clases>` `<sec-amp-sintonizado>` `<sec-fet>` |
| intro-2c | `<sec-oscilador>` `<sec-cristal>` `<sec-mezclador>` `<sec-detector>` `<sec-modulador>` `<sec-radio-entera>` |
| temas | `<t1-sec-…>`, `<t3-sec-…>`, … (own prefix) |

All other labels you create must start with your file key (`t3-`, `i2b-`, `rb-` …).

## 8. Typst pitfalls (Typst 0.15)

- Inline math `$x$`; display math `$ x $` (spaces inside the dollars). Text inside math:
  `$V_"CC"$`, `$12 "V"$`. Decimal comma works in math: `$3,2$`.
- Units normally go in text: `3,2 kΩ`, `100 pF`, `7 MHz`. `μ` and `Ω` are plain Unicode.
- Escape in markup: `\*`, `\_`, `\#`, `\$`, `\@`, `\<`. A literal `<` before letters starts a label!
  Write `menor que` or `$<$` in math.
- `*bold*`, `_italic_`. A `*` or `_` inside a word may need escaping.
- Content blocks `[...]` cannot contain an unbalanced `]`.
- Lists: `- item`, numbered `+ item`. Tables: `#table(columns: 3, [*A*], [*B*], [*C*], …)`.
- Spanish quotes «…», dashes —, and the middle dot · are plain characters; keep them.
- Do not use `#set page`, `#set text(font…)` globally, or `#pagebreak()` (except where the
  source clearly starts a new page for a reason).

## 9. Language and voice

- The book is in **Spanish (Spain)**. Keep the voice of the original: close (tú), precise,
  explains the *why*, short examples. It is a textbook for adults with no electronics
  background who must pass the HAREC exam.
- Transcribe the source faithfully: all text, all questions, all options, all solutions, all
  tables. Fix only PDF-extraction damage (superscripts, broken lines, hyphenation, ligatures,
  odd small caps like "eneRgÍa"). Do not summarise.
- Recreate every figure of the source in Typst (zap / cetz / fletcher). Do not insert images
  of the PDF.

## 10. EXPANSION brief (only for agents whose assignment says "EXPAND")

The reader (the user) studied the original and reports that it is hard to follow. Their words:

1. *"La sección de los transistores es árida, le faltan diagramas y no se entiende ni motiva bien."*
2. *"Tampoco entiendo cómo estos componentes se entienden bien o la motivación de los circuitos
   resonantes y demás."* (how the components fit together; why resonant circuits exist).
3. *"Tampoco entiendo los tipos de amplificadores, o en general cómo son los circuitos básicos
   para muchas de las piezas básicas de la radio. O un circuito amplificador."*
4. *"Las redes en pi y en T. ¿Qué son? ¿Acaso se motiva?"*
5. *"Cuando muestres un circuito, explica por qué funciona y un enlace a Falstad si existe."*
6. General: *"Busca lo que es, como eso, poco motivado o árido, y arréglalo."*

How to expand (keep everything of the original; ADD around it):

- **Problem first.** Before each new component, circuit or formula, a `#motivacion[...]` box or
  paragraph says which real problem of a radio it solves ("la antena recoge cientos de emisoras a
  la vez: ¿cómo me quedo con una?" → resonance).
- **Picture second.** A `#analogia[...]` or a figure that shows what happens physically
  (current paths, waveforms before/after, energy flowing between L and C, …).
- **Circuit third, with a real schematic** drawn in Typst, component values where useful, and a
  `#porque[...]` box that walks through it component by component: what each part does, and
  what would go wrong without it.
- **Numbers fourth.** One `#ejemplo[...]` with realistic values (ham-radio bands, 50 Ω, 13,8 V…).
- **Exam link last.** `#ojo[...]` for the trap the exam uses; point to the questions that test it.
- Show signals: input vs output waveforms (e.g. class A/B/C conduction angles; rectifier output
  before/after the capacitor; AM envelope and the detector output).
- Explain how blocks connect: where each basic circuit sits in a real receiver/transmitter.
- Keep formulas, but derive or justify them in one or two lines when possible.
- Be correct. Electrical accuracy is more important than length. When you state a typical value
  (β, Vbe, Q, efficiency per class) use standard textbook values.
- Length: an expanded section can be 2–4 times the original. Do not pad: every paragraph must
  answer a "why" or "how".

## 11. When you finish

Reply with a short report:
- files written, page count from `tools/check.sh`, compile status;
- for each question group: number of `#q` calls (must equal the source count);
- figures recreated / figures added; Falstad links used (file names);
- list of expansions (one line each) if your assignment had EXPAND;
- anything uncertain (unreadable source, doubtful answer key, missing catalog).
