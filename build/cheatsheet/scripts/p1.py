PAIRS = [
# global spacing
('#set par(justify: true, leading: 0.46em, spacing: 0.6em)', '#set par(justify: true, leading: 0.45em, spacing: 0.5em)'),
('#set list(indent: 0.1em, body-indent: 0.35em, spacing: 0.45em,', '#set list(indent: 0.1em, body-indent: 0.35em, spacing: 0.4em,'),
('#set table(inset: (x: 2.6pt, y: 2.1pt), stroke: 0.3pt + col.gris.lighten(55%))', '#set table(inset: (x: 2.4pt, y: 1.8pt), stroke: 0.3pt + col.gris.lighten(55%))'),
('radius: (right: 2pt), above: 0.55em, below: 0.55em, breakable: true,', 'radius: (right: 2pt), above: 0.45em, below: 0.45em, breakable: true,'),
('#let fml(f, cuerpo, ancho: auto) = block(width: 100%, above: 0.5em, below: 0.5em,', '#let fml(f, cuerpo, ancho: auto) = block(width: 100%, above: 0.42em, below: 0.42em,'),
('inset: (x: 7pt, y: 4pt), above: 0.5em, below: 0.5em, f))', 'inset: (x: 7pt, y: 3.5pt), above: 0.42em, below: 0.42em, f))'),
('radius: 1.5pt, above: 0.95em, below: 0.5em, sticky: true,', 'radius: 1.5pt, above: 0.8em, below: 0.45em, sticky: true,'),
('  above: 0.75em, below: 0.38em, sticky: true, width: 100%,', '  above: 0.6em, below: 0.32em, sticky: true, width: 100%,'),
('#let fig(cuerpo, cap: none, sim: none) = block(width: 100%, breakable: false, above: 0.6em, below: 0.65em, {', '#let fig(cuerpo, cap: none, sim: none) = block(width: 100%, breakable: false, above: 0.5em, below: 0.5em, {'),
# header
('text(font: _sans, size: 12pt, weight: "bold")[Examen de radioaficionado (HAREC) — hoja de conceptos clave],', 'text(font: _sans, size: 10.6pt, weight: "bold")[Examen de radioaficionado (HAREC) — hoja de conceptos clave],'),
# units table -> compact grid
('''#table(
  columns: (auto, auto, 1fr, auto, auto, 1fr),
  th[Magnitud][Unidad][][Magnitud][Unidad][],
  [resistencia $R$], [ohmio], [Ω], [carga $Q$], [culombio], [C = A·s],
  [intensidad $I$], [amperio], [A], [capacidad $C$], [faradio], [F],
  [tensión y fem $V$, $E$], [voltio], [V], [autoinducción $L$], [henrio], [H],
  [potencia $P$], [vatio], [W], [frecuencia $f$], [hercio], [Hz],
  [energía], [julio], [J], [campo eléctrico $E$], [—], [V/m],
)''', '''#table(
  columns: (auto, 1fr, auto, 1fr, auto, 1fr), stroke: none, inset: (x: 2pt, y: 1.4pt),
  fill: (x, y) => if calc.even(y) { col.gris-claro } else { none },
  [*Ω* ohmio], [resistencia], [*A* amperio], [intensidad], [*V* voltio], [tensión y fem],
  [*W* vatio], [potencia], [*J* julio], [energía], [*C* culombio], [carga (A·s)],
  [*F* faradio], [capacidad], [*H* henrio], [autoinducción], [*Hz* hercio], [frecuencia],
)
#k[Campo eléctrico:] V/m. '''),
('''#k[Prefijos:] M = 10#super[6]''', '''#k[Prefijos:] M = 10#super[6]'''),
# sinusoid: move Vpp arrow to the right edge
('''  onda(s, 0, T + 0.25, stroke: 1.1pt + col.senal1)''', '''  onda(s, 0, T + 0.08, stroke: 1.1pt + col.senal1)'''),
('''  line((3 * T / 4, -A), (3 * T / 4, A), mark: (start: ">", end: ">", fill: black, scale: 0.5), stroke: 0.45pt)
  content((3 * T / 4 + 0.08, -0.45 * A), anchor: "west", t7[$V_"pp" = 2 V_"max"$])''', '''  line((T + 0.2, -A), (T + 0.2, A), mark: (start: ">", end: ">", fill: black, scale: 0.5), stroke: 0.45pt)
  line((3 * T / 4, -A), (T + 0.3, -A), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dashed"))
  content((T + 0.32, -0.45 * A), anchor: "west", t7[$V_"pp" = 2 V_"max"$ \ (pico a pico)])'''),
# spectra: move "sin portadora"
('''  raya(x0 + 0.55, 1.0, c: col.gris, dash: "dotted")''', '''  raya(x0 + 0.55, 0.85, c: col.gris, dash: "dotted")'''),
('''  content((x0 + 0.55, 1.0), anchor: "south", padding: 1pt, t6[sin portadora])''', '''  content((x0 + 0.62, 0.82), anchor: "west", t6[sin portadora])'''),
# resonance labels
('''  content((3 * sx - 0.15, 0.98 * sy), anchor: "east", t6(text(fill: col.senal1)[$Q$ alta: \\ estrecha, selectiva]))
  content((5.25, 0.42 * sy), t6(text(fill: col.senal2)[$Q$ baja: ancha]))''', '''  content((0.15, 1.02 * sy), anchor: "west", t6(text(fill: col.senal1)[— $Q$ alta: estrecha, selectiva]))
  content((0.15, 0.86 * sy), anchor: "west", t6(text(fill: col.senal2)[- - $Q$ baja: ancha, poco selectiva]))'''),
# superhet: no edge labels, CAG as text node
('''    edge("-|>", [14,2]),
    node((2, 0), [Mezclador], shape: rect, name: <mez>),
    edge("-|>", [0,455]),''', '''    edge("-|>"),
    node((2, 0), [Mezclador], shape: rect, name: <mez>),
    edge("-|>"),'''),
('''    edge(<det>, (4, -0.75), (1, -0.75), <rf>, "-|>", stroke: (paint: col.senal3, dash: "dashed", thickness: 0.6pt), label: text(fill: col.senal3)[CAG: baja la ganancia de RF y FI], label-side: left, label-pos: 0.5),
    edge((3, -0.75), <fi>, "-|>", stroke: (paint: col.senal3, dash: "dashed", thickness: 0.6pt)),''', '''    edge(<det>, (4, -0.7), (1, -0.7), <rf>, "-|>", stroke: (paint: col.senal3, dash: "dashed", thickness: 0.6pt)),
    edge((3, -0.7), <fi>, "-|>", stroke: (paint: col.senal3, dash: "dashed", thickness: 0.6pt)),
    node((2.5, -1.05), text(fill: col.senal3)[CAG: el detector mide la señal y baja la ganancia de RF y FI], stroke: none, fill: none),'''),
]
