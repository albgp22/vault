# Hand-off: Typst edition of «Examen de Radioaficionado» + cheatsheet

Status date: 2026-10-20. This document lets a new Claude session continue the work.
Read it completely before you change any file.

## 1. What the user asked for

The user gave two PDFs (Spanish, ham-radio HAREC exam, Spain):

- `source/generated-radio.pdf` — a 488-page textbook with exam questions (LaTeX origin).
- `source/radio-cheatsheet.pdf` — a 3-page cheatsheet.

The request, in the user's words (Spanish, translated where needed):

1. «Genera un archivo en typst que genere este fichero (el estilo, up to you).» — Typst source
   that produces the book. The style is free.
2. «Usa agentes de forma efectiva para no saturar contexto.»
3. «Amplía todos los temas de la primera parte en las partes que no se entiendan bien.» The first
   part = the two intro chapters + Parte I (T1–T10). Their specific complaints:
   - «La sección de los transistores es árida, le faltan diagramas y no se entiende ni motiva bien.»
   - «No entiendo cómo estos componentes se entienden bien o la motivación de los circuitos
     resonantes y demás.»
   - «Tampoco entiendo los tipos de amplificadores, o en general cómo son los circuitos básicos
     para muchas de las piezas básicas de la radio. O un circuito amplificador.»
   - «Las redes en pi y en T. ¿Qué son? ¿Acaso se motiva?»
   - «Cuando muestres un circuito, explica por qué funciona y un enlace a Falstad si existe ese
     circuito para visualizarlo.»
   - «Busca lo que es, como eso, poco motivado o árido, y arréglalo.»
4. «Haz lo mismo con la cheatsheet. No se entiende bien. Incluso si toma un par de páginas más.»
5. Later instructions: let the running agents finish, **do not start new agents**, then bundle
   everything in a zip with this hand-off document.

User preferences that bind (from their global CLAUDE.md):
- Chat replies in ASD-STE100 Simplified Technical English. The book itself is Spanish (Spain),
  in the original voice (tú, close, precise).
- Verify empirically before you claim something (compile, render, count).
- Minimal, targeted changes. Do not add unrequested features. Ask before big changes.
- Do not start more sub-agents unless the user agrees (they said «don't add new ones»).

## 2. Layout

```
main.typ                 the book: front matter, intro chapters, Parte I, Parte II, appendices A–D
cheatsheet.typ           the cheatsheet (standalone document, own layout)
lib/template.typ         page style, headings, boxes, questions, solutions, Falstad badge
lib/circuits.typ         schematics: zap 0.4.0 + own parts (cristal, bateria, medidor, lampara,
                         altavoz, microfono, triodo, trafo) + onda()/ejes() for waveforms
lib/GUIA-AGENTES.md      the full writing guide the agents followed (macros, rules, labels)
lib/falstad-catalog.md   122 VERIFIED official Falstad examples (file, URL, what it shows)
lib/falstad-custom.md/.typ   custom Falstad circuits (only if the custom agent finished; see §6)
chapters/front.typ       cover, «El examen y este cuaderno», table of contents
chapters/intro-1.typ     «Cómo funciona una radio: de los campos a la voz» (expanded)
chapters/intro-2a/b/c    «La radio por dentro» (expanded; 2a components+supply+L/pi/T networks,
                         2b transistor+amplifiers, 2c oscillator/mixer/detector/full radio)
chapters/t01…t10.typ     Parte I temas (expanded)
chapters/r01…r09.typ     Parte II temas (faithful)
chapters/ap-a.typ        Apéndice A taller (faithful + circuit explanations)
chapters/ap-b1/b2.typ    Apéndice B preguntas complementarias (faithful)
chapters/ap-c1/c2/c3     Apéndice C refuerzo del temario (faithful)
chapters/ap-d.typ        Apéndice D: generated answer keys + reasoned solutions (see §3)
tools/check.sh           compile one chapter alone: tools/check.sh chapters/t03.typ T3
tools/verify-questions.py  compare question counts per group with the source PDF
tools/demo-capitulo.typ  a small chapter that uses every macro (reference example)
source/                  the two original PDFs and their pdftotext output
build/                   output and scratch; build/*/ hold the agents' generator scripts
```

## 3. How it works (read before you edit)

- **Build:** `tools/build.sh` (both PDFs), or by hand
  `typst compile --root . --font-path fonts main.typ build/examen-radioaficionado.pdf` and
  `typst compile --root . --font-path fonts cheatsheet.typ build/cheatsheet.pdf`. Typst 0.15.1.
  Always give `--font-path fonts`. Packages (downloaded once, cached): `@preview/zap:0.4.0`,
  `@preview/cetz:0.4.2`, `@preview/cetz-plot:0.1.3`, `@preview/fletcher:0.5.8` (they also pull
  `cetz:0.3.4`, `oxifmt:1.0.0`, `oxifmt:0.2.1`). If packages.typst.org is blocked, copy the
  folders from github.com/typst/packages into `~/.local/share/typst/packages/preview/`.
- **Fonts** (OFL, in `fonts/`, licences included): Charis SIL (the Charter design) for text,
  Source Sans 3 for headings and labels, STIX Two Math for math, DejaVu Sans Mono (built into
  Typst) for code. `fuente-texto/-sans/-mate/-mono` in `lib/template.typ`. The PDF is now the
  same on every machine.
- **Chapter numbering** is not typed by hand. `#tema("T5", …)` and `#apendice("B", …)` set the
  heading counter from the id list `ids-capitulos` and place a hidden numbered level-1 heading.
  Sections `==` then number as «T5.1.», «B.3.»; figures as «Figura T5.2». Intro chapters use
  `#capitulo(...)` (called in `main.typ`) and number sections 1., 2., … Never write `= …`.
- **Questions:** `#q("T1.8", "b", [stem], ([a], [b], [c], [d]), sol: [reasoning])`. Each call stores
  metadata; `#soluciones("T1")` in `ap-d.typ` builds the answer-key table and the reasoned
  solutions from it. The group is the id before the last dot (`C-T6`, `F-R8`, `C-H`).
  The answer letters were copied from the source keys and checked by script (0 mismatches).
- **Exercises:** `#ejercicio(sol: […])[…]`, collected per chapter by `#soluciones-ejercicios()`.
- **Boxes:** `motivacion` (El problema), `analogia` (Imagen mental), `idea`, `porque` (Por qué
  funciona — after every schematic), `ojo` (¡Ojo!), `ejemplo`, `nota`, `truco`, `destacada`,
  plus solution helpers `no-esta`, `vease`, `clave-bancos`.
- **Cross-references between files:** `#ver(<sec-transistor>)` renders «Title», p. N and never
  fails (an unknown label shows a red `[?? label]`). Shared section labels and their owners are in
  `lib/GUIA-AGENTES.md` §7. `@label` is used only inside one file. No file writes fixed section or
  figure numbers.
- **Falstad badge:** `#circuito(caption: [...], sim: "lrc.txt")[...]` or inline `#falstad("x.txt")`.
  The macro builds `https://www.falstad.com/circuit/circuitjs.html?startCircuit=<file>` and adds
  `&lang=es&euroResistors=true` (Spanish interface, IEC resistors). A full URL is also accepted.
  Only files from `lib/falstad-catalog.md` are used (all 122 were loaded in the real simulator).

## 4. Status

**Update 2026-10-21 — control mock exams (`simulacros-control.typ` → `build/simulacros-control.pdf`,
203 pages).** Same 13 × (30 + 30) structure and the same concepts as the study exams, but every one
of the 780 questions is new (written by 11 agents with `PROMPT-CONTROL.md` → `build/control/escritas/`;
not in the book nor in the study exams; checked by script: 780 keys after shuffling, 0 overlap).
Only R9 had an independent review (`PROMPT-VERIFICAR-CONTROL.md` → `build/control/verificadas/`);
the user ran short of credits, so the other batches rely on the writers' own checks — run the
verifier on them if credits allow. Rebuild: `planificar_control.py`, then
`generar.py build/control/plan.json simulacros-control.typ control`.

**Update 2026-10-21 — mock exams (`simulacros.typ` → `build/simulacros.pdf`, 223 pages).**
One document: 13 exams of 30 + 30 questions (780 questions, none repeated), key and reasoned
solution for each, Apéndice A (201 marginal concepts as question → answer) and Apéndice B (map of
all 949 concepts → where they are). Pipeline in `tools/simulacros/` (regenerate, never edit
`simulacros.typ` by hand):
1. `extract.py` → `build/simulacros/banco.json` (all 1467 `#q` of the book, raw Typst kept).
2. Concept inventory by 9 agents (`PROMPT-CONCEPTOS.md`) → `build/simulacros/conceptos/L*.json`:
   bank grouped into concepts with weight 1–3, best question chosen, 84 new questions for gaps.
   New questions checked by 3 independent agents (`PROMPT-VERIFICAR.md`) →
   `verificadas-*.json` (0 discarded, 11 corrected, no key changed). Cross-topic duplicates found
   by 2 agents (`PROMPT-DUPLICADOS.md`) → `duplicados-*.json` (70 groups merged).
   `excluir.json`: questions with dubious, imprecise or repealed-rule keys (C-H never used).
3. `planificar.py [N]` → `plan.json`: N = smallest number that fits every weight 3 and 2
   technical concept; priority weight 3 > 2 > second questions of weight 3 > weight 1; topics
   spread evenly; a concept's second question at least 4 exams away; the rest to Apéndice A.
4. `generar.py build/simulacros/plan.json simulacros.typ`: copies chapter-local macros
   (`macros.py`), shuffles options when safe and balances answer letters per test (7–8 each),
   writes intro (`intro.typ`) and page pieces (`cabecera.typ`).
Checks done: 780 keys verified after shuffling, every concept placed, 0 errors/warnings, no ink
outside the text block, no overlapping words.

**Update 2026-10-20 (second session, «completa la tarea»): all steps of §5 are done.**

- *Custom Falstad circuits:* `www.falstad.com` was blocked, so CircuitJS was compiled from its
  official source (`github.com/pfalstad/circuitjs1`, `gradle makeSite`) and served locally. The
  calibration circuit `resonancia-serie` gave exactly the live-site numbers. All 12 drafts were
  run headless (`tools/falstad-test/`) and pass: correct element count, no errors, and the
  measured behaviour (table in `lib/falstad-custom.md`). One bug was fixed: `mezclador` used
  element `213` (VCCS) instead of `212` (VCVS). All 13 links are in `lib/falstad-custom.typ` and
  used at 27 marked figures in the book and 6 places in the cheatsheet (two markers skipped on
  purpose, reasons in `lib/falstad-custom.md`). `circuito(sim: …)` now also takes a list of
  (file or URL, [button text]) pairs. No `FALSTAD-CUSTOM` markers remain.
- *Visual review:* all 306 figures of the intro chapters and T1–T10 were cropped and checked, and
  all 8 cheatsheet pages. Fixed: overlapping labels (intro-1 Fig. «reactancias», «filtros RC»,
  «superheterodino», «diagramas de radiación»; intro-2a «choque», «fuente completa»; t03 T3.19,
  T3.37; t08 T8.11; t09 T9.11; cheatsheet c = λf box), rail stubs in intro-2b «Dos maneras de
  polarizar», t03 «fuente conmutada» wider than the text (and «Transformador de AF» → «de
  ferrita»), cheatsheet BLU transmitter in the margin, cheatsheet 12 V example now uses the
  battery symbol. Automatic checks (ink outside the text block, overlapping words) are clean on
  both PDFs. Twelve worked examples were recomputed; all correct.
- *Small issues:* `altavoz` between two nodes now keeps the cone beside the wire.
- *Final numbers:* book 659 pages, 0 errors, 0 warnings, 0 open references, 0 missing
  solutions, 55 of 55 question groups ok; cheatsheet 8 pages.


**Update 2026-10-20 (layout pass, after the user said the PDFs looked "not clean"):**
fonts vendored (see §3); running headers without fake small caps; no header or page number on
the blank pages before odd-page chapter starts (`<fin-capitulo>` marker + `_pagina-en-blanco`);
boxes and table cells ragged-right (no wide justification gaps); table header rows filled;
long table figures may break across pages (no half-empty page before them); intro-2a Tabla 1
columns fixed; centred chapter and part titles not justified; answer-key tables have equal
columns (20 per row); cover list and table of contents redesigned (roman page numbers for the
front matter in the TOC); cheatsheet margins, gutter, leading and box spacing increased
(7 → 8 pages), justification off, plain bullets. New totals: book **659 pages**, 0 errors,
0 warnings, 0 open references, 55 of 55 question groups ok; cheatsheet **8 pages**.
The figures below are from the earlier build.

All sub-agents have finished. No agent is running. The last full build (2026-10-20):

- `typst compile --root . main.typ build/examen-radioaficionado.pdf` → **759 pages, 0 errors,
  0 warnings**, about 25 s.
- `[?? label]` open cross-references: **0**. «falta la solución»: **0**. Empty solution groups: **0**.
- `python3 -I tools/verify-questions.py` → **55 of 55 groups ok** (1 467 questions; every answer
  letter was checked by script against the source answer keys).
- 133 Falstad badges in the book. 40 `// FALSTAD-CUSTOM:` markers still open (see §5 step 3).
- `typst compile --root . cheatsheet.typ build/cheatsheet.pdf` → **7 pages** (original: 3), 0 errors.

Size of each part (PDF pages of the new book vs book pages of the original):

| Part | Original | New | Mode |
|---|---|---|---|
| Intro chapters (Cómo funciona una radio · La radio por dentro) | 26 | 134 | expanded |
| Parte I, T1–T10 | 96 | 242 | expanded |
| Parte II, R1–R9 | 70 | 59 | faithful |
| Apéndice A taller | 16 | 18 | faithful + circuit explanations |
| Apéndices B, C | 112 | 100 | faithful |
| Apéndice D soluciones | 160 | 197 | generated from the `#q` calls |

Per file (compile alone with `tools/check.sh chapters/<file>.typ <groups>`):

| File | Questions | Notes |
|---|---|---|
| intro-1 | — | 35 p. 9 source figures + 24 new; resonance «why», RC filters, antenna, AM/FM, full chain |
| intro-2a | — | 35 p. 11 + 22 figures; components as solutions to radio problems; supply step by step; NEW section «Redes de adaptación: L, pi y T» |
| intro-2b | — | 32 p. 2 + 22 figures; BJT physics, zones, biasing, CE amplifier piece by piece, CE/CC/CB, classes A–E, tuned RF amp, FET/MOSFET |
| intro-2c | — | 30 p. 3 + 23 figures; oscillators, crystal, mixer, detectors, modulators, full radio, direct-conversion receiver; 4 new exercises |
| t01–t10 | 47·66·57·40·36·46·27·30·22·40 | expanded, every schematic has `#porque`; see each file's header comment |
| r01–r09 | 40·34·38·16·49·17·18·88·32 | faithful |
| ap-a | — | 7 exercises; 8 + 2 figures; 4 `#porque` |
| ap-b1 / ap-b2 | 179 / 135 | faithful; 11 recreated figures in ap-b1 |
| ap-c1 / ap-c2 / ap-c3 | 139 / 146 / 125 | faithful |
| cheatsheet.typ | — | 7 p., 2 columns, 15 diagrams, all original facts kept |

Deliberate changes to the source that the user should know (all reported by the agents):

- **T3.55, T3.56, T3.57** (schematic questions): the source drawings had errors (an input shorted to
  the rail, side bars that short every capacitor, the battery + plate drawn at the bottom). The
  Typst figures are drawn correctly. The answers do not change.
- **intro-2c, figure «La radio entera»**: the source detector diode had no DC path to ground (it
  would stop conducting). A resistor R_p was added and explained.
- **Cheatsheet**: the image-frequency formula now states its condition (LO above the signal) and
  gives the LO-below case; «SSB = una sola raya» is qualified (true for one tone; voice = 2,7 kHz);
  «siempre tras un limitador» became «normalmente».
- **¡OJO! boxes** read «¡Ojo!» (some source boxes are safety warnings, not exam traps).
- Figure and section numbers changed everywhere because of the new material; all references are
  labels, so they stay correct.
- Doubtful source keys were kept as printed, with the source's own comment (e.g. C-T3.3, T6.33,
  C-R4.2, C-R5.12, C-R5.14, C-H.*).

Custom Falstad circuits: the custom agent was stopped on the user's request. **Only
`resonancia-serie` is verified** (in `lib/falstad-custom.typ`). The other 12 ids exist only as
drafts in `build/falstad-custom/<id>.txt` and `build/falstad-custom/urls.json` (generator:
`build/falstad-custom/circuits.py`, lz-string port: `lz.py`). They were NOT opened in the
simulator; their L/pi/T values were computed by hand. Do not link them before you test them
(open the URL in a browser, confirm it loads, runs without «singular matrix», and the scope shows
the promised behaviour).

## 5. Remaining work, in order

1. **Re-check the build** after you unzip: `typst compile --root . main.typ build/out.pdf` must give
   0 errors (packages download on the first run; fonts may fall back on a machine without Charter /
   Avenir Next). All files were complete when the zip was made.
2. **Full build** of `main.typ`. Search the text output for open references and gaps:
   `pdftotext build/examen-radioaficionado.pdf - | grep -o "\[?? [a-z0-9-]*\]" | sort | uniq -c`,
   and for «falta la solución» / «No hay preguntas del grupo». Run
   `python3 -I tools/verify-questions.py` — every group must say `ok` (1 467 questions in 55 groups).
3. **Custom Falstad links.** The authors put `// FALSTAD-CUSTOM: <id>` on the line before each
   figure that needs a circuit that Falstad has no official example for (39 markers; ids:
   resonancia-serie, tanque-paralelo, red-L, red-pi, red-T, filtro-pi-fuente, fuente-completa,
   clase-c, base-comun, clases-ab, modulacion-am, modulacion-fm, mezclador). If
   `lib/falstad-custom.typ` exists, import it (`#import "/lib/falstad-custom.typ": fc`) in those
   chapters and add `sim: fc.at("<id>")` to the next `#circuito(...)`. Use only ids that the
   custom file lists as verified (today only `resonancia-serie`, whose only marker is in
   `cheatsheet.typ`, on a figure that already links the official `res-series.txt`). Some marked
   figures already have an official `sim:` (e.g. the t03 configurations figure has `ceamp.txt` and
   the marker `base-comun`): choose one link, do not drop the official one without reason.
   Finishing the 12 drafts means testing each in the browser first. Ask the user before you start
   sub-agents for it. List the markers: `grep -rn "FALSTAD-CUSTOM" chapters cheatsheet.typ`.
4. **Visual review** of the expanded chapters (intro-1, intro-2a/b/c, t01–t10) and the cheatsheet:
   render pages (`pdftoppm -r 70 -png -f N -l N …`) and look for overlapping labels, figures wider
   than the text, wrong polarities, boxes split badly, empty half pages before large figures.
   Check numbers in worked examples (the agents computed them; spot checks so far were correct).
5. **Known small issues** (optional fixes; ask the user if unsure):
   - Local helper macros duplicate shared ones in some files (`_apa-altavoz`, `_t2-varicap`,
     `_i2a-varicap`, monospace helpers `_r6-cod`, `_apc2-m`, …). Harmless.
   - `altavoz` in `lib/circuits.typ` draws its cone across the wire when placed vertically;
     ap-a defines its own `_apa-altavoz`.
   - In math, a decimal comma inside a function call splits arguments: write
     `sqrt("2,5" times 10^(-16))` or `(1,5) / (0,5)`.
   - Charter has no small caps; `smallcaps` falls back. Headers still read well.
   - C-H solutions repeat the old-bank letter in the text on purpose (it is not the current answer).
   - The front matter says «una hoja de repaso resume los conceptos»: update it if the cheatsheet
     page count matters.
6. **Deliver:** compile both PDFs into `build/`, send them to the user, and summarise in STE.

## 6. Source page map (physical PDF pages = book page + 8)

| Part | Source pages | Solutions (appendix D) | Typst file |
|---|---|---|---|
| Intro 1 | 9–22 | (exercise solutions p. 18) | intro-1 |
| Intro 2 §1–5 | 23–30 | (exercises p. 34) | intro-2a |
| Intro 2 §6 transistor | 30–32 | (exercises p. 34) | intro-2b |
| Intro 2 §7–8 | 32–34 | — | intro-2c |
| T1 … T10 | 37–130 | 329–353 | t01 … t10 |
| R1 … R9 | 133–200 | 353–372 | r01 … r09 |
| A taller | 201–216 | (exercises p. 213) | ap-a |
| B.1–B.10 / B.11–B.19 | 217–244 / 244–266 | 372–400 / 400–424 | ap-b1 / ap-b2 |
| C.1–C.3 / C.4–C.15 / C.16–C.17 | 267–286 / 286–306 / 306–328 | 424–442 / 442–463 / 463–488 | ap-c1 / c2 / c3 |
| Cheatsheet | radio-cheatsheet.pdf p. 1–3 | — | cheatsheet.typ |

Text of a page range: `python3 -I -c "p=open('source/generated-radio.txt').read().split('\f');print('\f'.join(p[36:48]))"`
(pages 37–48). Image of a page: `pdftoppm -r 80 -png -f 37 -l 37 source/generated-radio.pdf build/x`.
