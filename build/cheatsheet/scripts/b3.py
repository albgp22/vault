BLOCKS = [
(r'''// --- Amplificador en emisor común ---''', r'''// --- Clases de amplificador''', r'''// --- Amplificador en emisor común ---------------------------------------------
#let cnum(n) = box(baseline: 0.9pt, circle(radius: 3.3pt, fill: col.naranja, stroke: none, inset: 0pt, align(center + horizon, text(font: _sans, size: 4.9pt, weight: "bold", fill: white, str(n)))))
#let fig-ec = esquema(escala: 0.66, {
  import zap: *
  import cetz.draw: content, line
  let lab(p, a, t) = content(p, anchor: a, t6(t))
  wire((2, 6), (6.0, 6))
  wire((2, 0), (6.0, 0))
  lab((3.9, 6.12), "south", [$+V_"CC"$ 12 V])
  ground("gnd", (3.4, 0))
  resistor("r1", (2, 6), (2, 3))
  resistor("r2", (2, 3), (2, 0))
  npn("q1", (4.4, 3))
  wire((2, 3), "q1.b")
  resistor("rc", (4.4, 6), (4.4, 4.1))
  wire((4.4, 4.1), "q1.c")
  resistor("re", (4.4, 2.0), (4.4, 0))
  wire("q1.e", (4.4, 2.0))
  wire((4.4, 2.0), (5.6, 2.0))
  capacitor("ce", (5.6, 2.0), (5.6, 0))
  capacitor("cin", (0.2, 3), (2, 3), n: "o-*")
  wire((4.4, 4.1), (5.4, 4.1))
  capacitor("cout", (5.4, 4.1), (7.0, 4.1), n: "-o")
  lab((1.62, 4.5), "east", [#cnum(1) $R_1$ \ 47 k])
  lab((1.62, 1.5), "east", [#cnum(1) $R_2$ \ 10 k])
  lab((4.02, 5.05), "east", [#cnum(4) $R_C$ \ 4,7 k])
  lab((4.02, 1.0), "east", [#cnum(2) $R_E$ \ 1,5 k])
  lab((5.95, 1.0), "west", [#cnum(3) $C_E$])
  lab((1.1, 2.55), "north", [#cnum(5) $C_"ent"$])
  lab((6.2, 3.65), "north", [#cnum(5) $C_"sal"$])
  // señales de entrada y salida
  onda(x => 3.85 + 0.17 * calc.sin(2 * calc.pi * (x + 0.6) / 0.8), -0.6, 0.2, stroke: 0.8pt + col.senal1)
  lab((-0.2, 4.15), "south", [entrada])
  onda(x => 5.0 - 0.42 * calc.sin(2 * calc.pi * (x - 6.4) / 0.8), 6.4, 7.2, stroke: 0.8pt + col.senal2)
  lab((6.8, 5.5), "south", [salida \ invertida])
})

'''),
]
