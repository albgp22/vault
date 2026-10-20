PAIRS = [
(r'''#prueba[Prueba 2 · Normativa reglamentaria][temas R1–R9 · Orden IET/1311/2013 · Ley 11/2022 · 30 preguntas · 45 min · aprobado con 15]''', r'''#prueba[Prueba 2 · Normativa reglamentaria][R1–R9 · Orden IET/1311/2013 · Ley 11/2022 · 45 min · aprobado con 15]'''),
(r'''  onda(x => 0.2 + 0.56 * calc.abs(f0(x - x2 - 0.1)), x2 + 0.1, x2 + w - 0.1, stroke: (paint: col.gris.lighten(40%), thickness: 0.5pt, dash: "dotted"))''', r'''  onda(x => 0.2 + 0.56 * calc.abs(f0(x - x2 - 0.1)), x2 + 0.1, x2 + w - 0.1, stroke: 0.4pt + col.gris.lighten(55%))'''),
# 12 V circuit: manual labels
(r'''#let fig-c-cc = esquema(escala: 0.55, {
  import zap: *
  import cetz.draw: content
  vsource("v", (0, 0), (0, 2.4), label: (content: t7[12 V], anchor: "east"))
  resistor("r1", (0, 2.4), (2.6, 2.4), label: (content: t7[1 kΩ], anchor: "south"))
  resistor("r2", (2.6, 2.4), (2.6, 0), label: (content: t7[3 kΩ], anchor: "east"))
  wire((2.6, 2.4), (4.0, 2.4))
  capacitor("c", (4.0, 2.4), (4.0, 0), label: (content: t7[$C$: 9 V], anchor: "west"))
  wire((0, 0), (4.0, 0))
})''', r'''#let fig-c-cc = esquema(escala: 0.55, {
  import zap: *
  import cetz.draw: content
  vsource("v", (0, 0), (0, 2.4))
  resistor("r1", (0, 2.4), (2.6, 2.4))
  resistor("r2", (2.6, 2.4), (2.6, 0))
  wire((2.6, 2.4), (4.0, 2.4))
  capacitor("c", (4.0, 2.4), (4.0, 0))
  wire((0, 0), (4.0, 0))
  content((-0.62, 1.2), anchor: "east", t7[12 V])
  content((1.3, 2.75), anchor: "south", t7[1 kΩ])
  content((2.12, 1.2), anchor: "east", t7[3 kΩ])
  content((4.45, 1.2), anchor: "west", t7[$C$: 9 V])
})'''),
# ALC arrow to the drive (edge between mixer and linear)
(r'''    edge(<pb>, (3, 1.6), (2, 1.6), <lin>, "-|>", stroke: (paint: col.senal3, dash: "dashed", thickness: 0.6pt)),''', r'''    edge(<pb>, (3, 1.6), (1.5, 1.6), (1.5, 1.08), "-|>", stroke: (paint: col.senal3, dash: "dashed", thickness: 0.6pt)),'''),
(r'''#fig(fig-ionosfera, cap: [Capas de la ionosfera y salto. Orden desde el suelo: troposfera, estratosfera, ionosfera.])''', r'''#fig(fig-ionosfera, cap: [Capas de la ionosfera (alturas sin escala) y salto. Orden desde el suelo: troposfera, estratosfera, ionosfera.])'''),
]
