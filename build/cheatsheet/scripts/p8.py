PAIRS = [
# title layout
(r'''  block(width: 100%, below: 3pt, stroke: (bottom: 1.2pt + col.acento), inset: (bottom: 3pt), grid(
    columns: (1fr, auto), align: (left + bottom, right + bottom),
    text(font: _sans, size: 10.6pt, weight: "bold")[Examen de radioaficionado (HAREC) — hoja de conceptos clave],
    text(font: _sans, size: 7.6pt, weight: "semibold", fill: col.gris)[15 aciertos de 30 en cada parte · 45 min por prueba · no restan errores],
  ))''', r'''  block(width: 100%, below: 3pt, stroke: (bottom: 1.2pt + col.acento), inset: (bottom: 3pt), grid(
    columns: (auto, 1fr), align: (left + bottom, right + bottom),
    text(font: _sans, size: 11pt, weight: "bold")[Examen de radioaficionado (HAREC) — hoja de conceptos clave],
    text(font: _sans, size: 7.4pt, weight: "semibold", fill: col.gris)[15 aciertos de 30 en cada parte · 45 min por prueba \ no restan errores],
  ))'''),
# prueba band on one line
(r'''  align(center, text(font: _sans, fill: white)[#text(size: 9.4pt, weight: "bold", tracking: 0.05em, upper(t)) \ #text(size: 7.2pt, sub)]),''', r'''  align(center, text(font: _sans, fill: white)[#text(size: 9pt, weight: "bold", tracking: 0.04em, upper(t)) #h(4pt) #text(size: 6.8pt, sub)]),'''),
(r'''#prueba[Prueba 1 · Electricidad y radioelectricidad][temas T1 a T10 · 30 preguntas · 45 min · aprobado con 15]''', r'''#prueba[Prueba 1 · Electricidad y radio][T1–T10 · 30 preguntas · 45 min · aprobado con 15]'''),
(r'''#prueba[Prueba 2 · Normativa reglamentaria][temas R1 a R9 · 30 preguntas · 45 min · aprobado con 15]''', r'''#prueba[Prueba 2 · Normativa][R1–R9 · 30 preguntas · 45 min · aprobado con 15]'''),
(r'''  [0,96–17,7 GHz], [> 10 W: 50 dB y ≤ 100 mW], [≤ 10 W: 50 dB y ≤ 100 μW],''', r'''  [0,96–17,7 GHz], [> 10 W: 50 dB, ≤ 100 mW], [≤ 10 W: 50 dB, ≤ 100 μW],'''),
(r'''  [30–235 MHz], [> 25 W: 60 dB y ≤ 1 mW], [≤ 25 W: 40 dB y ≤ 25 μW],
  [235–960 MHz], [> 25 W: 60 dB y ≤ 20 mW], [≤ 25 W: 40 dB y ≤ 25 μW],''', r'''  [30–235 MHz], [> 25 W: 60 dB, ≤ 1 mW], [≤ 25 W: 40 dB, ≤ 25 μW],
  [235–960 MHz], [> 25 W: 60 dB, ≤ 20 mW], [≤ 25 W: 40 dB, ≤ 25 μW],'''),
# estaciones table -> 2 pairs per row
(r'''#table(
  columns: (auto, 1fr),
  th[Estación][Qué es],
  [portable], [la fija usada temporalmente en otro sitio (sin distintivo temporal)],
  [portátil], [móvil con antena y fuente de alimentación propias],
  [móvil], [en movimiento o parada en un punto no determinado],
  [remota], [fija accionada a distancia],
  [digital], [emite con técnicas digitales],
)''', r'''#table(
  columns: (auto, 1fr),
  th[Estación][Qué es],
  [portable], [la fija usada temporalmente en otro sitio (sin distintivo temporal)],
  [portátil], [móvil con antena y fuente de alimentación propias],
  [móvil], [en movimiento o parada en un punto no determinado],
  [remota · digital], [fija accionada a distancia · emite con técnicas digitales],
)'''),
# diagrams spacing
(r'''    spacing: (3mm, 5mm), node-inset: 3.2pt, edge-stroke: 0.6pt,
    node((0, 0), [Micro], shape: rect),''', r'''    spacing: (3mm, 4mm), node-inset: 2.8pt, edge-stroke: 0.6pt,
    node((0, 0), [Micro], shape: rect),'''),
(r'''    spacing: (2.6mm, 4.5mm), node-inset: 3pt, edge-stroke: 0.6pt,''', r'''    spacing: (2.6mm, 4mm), node-inset: 2.8pt, edge-stroke: 0.6pt,'''),
]
