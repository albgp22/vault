PAIRS = [
(r'''  content((0.15, 1.02 * sy), anchor: "west", t6(text(fill: col.senal1)[— $Q$ alta: estrecha, selectiva]))
  content((0.15, 0.86 * sy), anchor: "west", t6(text(fill: col.senal2)[- - $Q$ baja: ancha, poco selectiva]))''', r'''  line((0.2, 1.08 * sy), (0.6, 1.08 * sy), stroke: 1.2pt + col.senal1)
  content((0.68, 1.08 * sy), anchor: "west", t6(text(fill: col.senal1)[$Q$ alta: estrecha, selectiva]))
  line((0.2, 0.93 * sy), (0.6, 0.93 * sy), stroke: (paint: col.senal2, thickness: 0.9pt, dash: "dashed"))
  content((0.68, 0.93 * sy), anchor: "west", t6(text(fill: col.senal2)[$Q$ baja: ancha]))'''),
(r'''  align(center, text(font: _sans, fill: white)[#text(size: 9pt, weight: "bold", tracking: 0.04em, upper(t)) #h(4pt) #text(size: 6.8pt, sub)]),''', r'''  align(center, text(font: _sans, fill: white)[#text(size: 9pt, weight: "bold", tracking: 0.04em, upper(t)) \ #v(-1.5pt) #text(size: 6.8pt, sub)]),'''),
(r'''#prueba[Prueba 1 · Electricidad y radio][T1–T10 · 30 preguntas · 45 min · aprobado con 15]''', r'''#prueba[Prueba 1 · Electricidad y radioelectricidad][temas T1–T10 · 30 preguntas · 45 min · aprobado con 15 aciertos]'''),
(r'''#prueba[Prueba 2 · Normativa][R1–R9 · 30 preguntas · 45 min · aprobado con 15]''', r'''#prueba[Prueba 2 · Normativa reglamentaria][temas R1–R9 · Orden IET/1311/2013 · Ley 11/2022 · 30 preguntas · 45 min · aprobado con 15]'''),
(r'''  set text(size: 8pt)
  grid(columns: (1fr,) * 6, row-gutter: 3.2pt, column-gutter: 1pt,''', r'''  set text(size: 7.5pt)
  grid(columns: (1fr,) * 6, row-gutter: 3.2pt, column-gutter: 3pt,'''),
]
