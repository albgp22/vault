BLOCKS = [
(r'''// --- Superheterodino: bloques''', r'''// --- Superheterodino: eje de frecuencias''', r'''// --- Superheterodino: bloques ---------------------------------------------
#let fig-superhet = {
  set text(size: 6.4pt, font: _sans)
  let cag = (paint: col.senal3, dash: "dashed", thickness: 0.6pt)
  diagram(
    node-stroke: 0.6pt + col.acento, node-fill: col.acento-claro, node-corner-radius: 2pt,
    spacing: (2.6mm, 4.5mm), node-inset: 3pt, edge-stroke: 0.6pt,
    node((0, 0), align(center)[Amp. RF \ (presel.)], shape: rect, name: <rf>),
    edge("-|>"),
    node((1, 0), [Mezclador], shape: rect, name: <mez>),
    edge("-|>"),
    node((2, 0), align(center)[Filtro y \ amp. FI], shape: rect, name: <fi>),
    edge("-|>"),
    node((3, 0), [Detector], shape: rect, name: <det>),
    edge("-|>"),
    node((4, 0), align(center)[Amp. \ BF], shape: rect),
    node((1, 1), align(center)[OL], shape: rect, name: <ol>),
    edge(<ol>, <mez>, "-|>"),
    node((3, 1), [BFO (CW, BLU)], shape: rect, name: <bfo>),
    edge(<bfo>, <det>, "-|>"),
    edge(<det>, (3, -0.7), (0, -0.7), <rf>, "-|>", stroke: cag),
    edge((2, -0.7), <fi>, "-|>", stroke: cag),
    node((1.5, -1.0), text(fill: col.senal3)[CAG (control automático de ganancia)], stroke: none, fill: none),
  )
}

'''),
(r'''// --- Amplificador en emisor común ---''', r'''// --- Clases de amplificador''', r'''// --- Amplificador en emisor común ---------------------------------------------
#let cnum(n) = box(baseline: 1.2pt, circle(radius: 4.2pt, fill: col.naranja, stroke: none, align(center + horizon, text(font: _sans, size: 5.6pt, weight: "bold", fill: white, str(n)))))
#let fig-ec = esquema(escala: 0.66, {
  import zap: *
  import cetz.draw: content, line
  let num(p, n) = content(p, cnum(n))
  let lab(t) = t6(t)
  wire((2, 6), (6.0, 6))
  wire((2, 0), (6.0, 0))
  content((3.9, 6.12), anchor: "south", lab[$+V_"CC"$ 12 V])
  ground("gnd", (3.4, 0))
  resistor("r1", (2, 6), (2, 3), label: (content: lab[$R_1$ \ 47 k], anchor: "east"))
  resistor("r2", (2, 3), (2, 0), label: (content: lab[$R_2$ \ 10 k], anchor: "east"))
  npn("q1", (4.4, 3))
  wire((2, 3), "q1.b")
  resistor("rc", (4.4, 6), (4.4, 4.1), label: (content: lab[$R_C$ \ 4,7 k], anchor: "east"))
  wire((4.4, 4.1), "q1.c")
  resistor("re", (4.4, 2.0), (4.4, 0), label: (content: lab[$R_E$ \ 1,5 k], anchor: "east"))
  wire("q1.e", (4.4, 2.0))
  wire((4.4, 2.0), (5.6, 2.0))
  capacitor("ce", (5.6, 2.0), (5.6, 0), label: (content: lab[$C_E$], anchor: "west"))
  capacitor("cin", (0.2, 3), (2, 3), label: (content: lab[$C_"ent"$], anchor: "north"), n: "o-*")
  wire((4.4, 4.1), (5.4, 4.1))
  capacitor("cout", (5.4, 4.1), (7.0, 4.1), label: (content: lab[$C_"sal"$], anchor: "north"), n: "-o")
  // señales de entrada y salida
  onda(x => 3.85 + 0.17 * calc.sin(2 * calc.pi * (x + 0.6) / 0.8), -0.6, 0.2, stroke: 0.8pt + col.senal1)
  content((-0.2, 4.15), anchor: "south", lab[entrada])
  onda(x => 5.0 - 0.42 * calc.sin(2 * calc.pi * (x - 6.4) / 0.8), 6.4, 7.2, stroke: 0.8pt + col.senal2)
  content((6.8, 5.55), anchor: "south", lab[salida \ invertida])
  num((2.75, 4.6), 1)
  num((2.75, 1.4), 1)
  num((3.85, 1.0), 2)
  num((6.25, 1.0), 3)
  num((3.85, 5.05), 4)
  num((1.1, 2.45), 5)
  num((6.2, 3.55), 5)
})

'''),
]
