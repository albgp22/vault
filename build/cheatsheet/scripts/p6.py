PAIRS = [
(r'''  margin: (x: 0.95cm, top: 1.0cm, bottom: 1.15cm),''', r'''  margin: (x: 0.85cm, top: 0.95cm, bottom: 1.1cm),'''),
(r'''#set columns(gutter: 0.45cm)''', r'''#set columns(gutter: 0.42cm)'''),
(r'''El porcentaje de cada tema es su peso aproximado en el banco de preguntas. Los botones''', r'''El % de cada tema es su peso aproximado en el banco de preguntas. Los botones'''),
(r'''#tema("R6", [Planes de bandas de la IARU], [])''', r'''#tema("R6 · R7", [Planes de bandas IARU · procedimientos], [])'''),
(r'''#tema("R7", [Procedimientos operativos], [])
- Escuchar antes''', r'''- #k[Procedimiento (R7)]: escuchar antes'''),
# sinusoid smaller
(r'''  let A = 1.15
  let T = 5.0''', r'''  let A = 1.0
  let T = 5.0'''),
# resonance smaller
(r'''  let sx = 1.35
  let sy = 2.0''', r'''  let sx = 1.35
  let sy = 1.75'''),
(r'''#let fig-ionosfera = cetz.canvas(length: 0.9cm, {''', r'''#let fig-ionosfera = cetz.canvas(length: 0.86cm, {'''),
(r'''  let W = 9.5
  let capa(y1, y2, c, txt) = {''', r'''  let W = 10.0
  let capa(y1, y2, c, txt) = {'''),
]
