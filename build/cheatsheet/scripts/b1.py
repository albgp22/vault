BLOCKS = [
(r'''// --- Superheterodino: eje de frecuencias e imagen''', r'''// --- Dipolo de media onda''', r'''// --- Superheterodino: eje de frecuencias e imagen ----------------------------
#let fig-imagen = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let f0 = 13.85
  let span = 1.45
  let f2x(f) = (f - f0) / span * 8.2
  let x2f(x) = f0 + x / 8.2 * span
  line((0, 0), (8.4, 0), mark: (end: ">", fill: black), stroke: 0.5pt)
  content((8.4, 0), anchor: "north-east", padding: 2pt, t7[$f$ (MHz)])
  // curva del preselector, centrada en la señal (Q ≈ 30)
  let fs = 14.2
  let resp(f) = 1 / calc.sqrt(1 + 900 * calc.pow(f / fs - fs / f, 2))
  onda(x => 1.2 * resp(x2f(x)), 0.05, 8.2, n: 260, stroke: (paint: col.senal3, thickness: 0.8pt, dash: "dashed"))
  content((f2x(fs) + 0.55, 1.18), anchor: "west", t6(text(fill: col.senal3)[preselector (RF): deja pasar la señal \ y atenúa la imagen antes del mezclador]))
  let marca(f, h, c, txt) = {
    line((f2x(f), 0), (f2x(f), h), stroke: 1.5pt + c)
    content((f2x(f), h), anchor: "south", padding: 1.5pt, t6(align(center, txt)))
  }
  marca(14.2, 0.55, col.senal1, [señal \ 14,2])
  marca(14.655, 0.4, col.ambar, [OL \ 14,655])
  marca(15.11, 0.4, col.senal2, [imagen \ 15,11])
  let llave(a, b, txt) = {
    line((f2x(a), -0.2), (f2x(b), -0.2), mark: (start: "|", end: "|", scale: 0.4), stroke: 0.4pt)
    content(((f2x(a) + f2x(b)) / 2, -0.2), anchor: "north", padding: 1.5pt, t6(txt))
  }
  llave(14.2, 14.655, [FI = 455 kHz])
  llave(14.655, 15.11, [FI = 455 kHz])
})

'''),
(r'''// --- Ionosfera ---''', r'''// --- Transmisor de BLU ---''', r'''// --- Ionosfera (alturas sin escala) ----------------------------------------------
#let fig-ionosfera = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let W = 8.6
  let capa(y1, y2, c, txt) = {
    rect((0, y1), (W, y2), fill: c, stroke: none)
    content((0.06, (y1 + y2) / 2), anchor: "west", t6(txt))
  }
  capa(0.42, 0.74, col.naranja-claro, [*D* 60–90 km · solo de día])
  capa(0.84, 1.2, col.ambar-claro, [*E* 90–140 km])
  capa(1.4, 1.8, col.acento-claro, [*F1* · de día])
  capa(1.95, 2.75, col.acento-claro.darken(7%), [*F2* · de noche F1 y F2 \ se funden en una: *F*])
  content((0.06, 3.0), anchor: "west", t6[*F* en total: 140–400 km])
  // suelo
  rect((0, -0.1), (W, 0), fill: col.verde.lighten(60%), stroke: none)
  line((0, 0), (W, 0), stroke: 0.7pt + col.verde)
  // rayos
  let tx = (3.65, 0)
  line(tx, (6.0, 2.45), (8.35, 0), stroke: 1pt + col.senal1)
  line(tx, (4.75, 3.15), stroke: (paint: col.senal2, thickness: 0.9pt, dash: "dashed"))
  content((4.8, 3.12), anchor: "west", t6(text(fill: col.senal2)[$f$ > MUF: atraviesa y se pierde]))
  line(tx, (4.6, 0.0), stroke: 1.4pt + col.verde, mark: (end: ">", fill: col.verde, scale: 0.4))
  content((3.65, 0), anchor: "north", padding: 1pt, t6[TX])
  content((8.35, 0), anchor: "north-east", padding: 1pt, t6[1.#super[er] salto])
  line((4.65, -0.3), (8.3, -0.3), mark: (start: "|", end: "|", scale: 0.4), stroke: 0.4pt)
  content((6.45, -0.3), anchor: "north", padding: 1pt, t6[zona de silencio])
  content((3.4, -0.08), anchor: "north-east", t6(text(fill: col.verde)[onda de superficie →]))
})

'''),
(r'''// --- Transmisor de BLU ---''', r'''// --- PLL ---''', r'''// --- Transmisor de BLU -------------------------------------------------------
#let fig-tx-blu = {
  set text(size: 6.4pt, font: _sans)
  diagram(
    node-stroke: 0.6pt + col.acento, node-fill: col.acento-claro, node-corner-radius: 2pt,
    spacing: (3mm, 5mm), node-inset: 3.2pt, edge-stroke: 0.6pt,
    node((0, 0), [Micro], shape: rect),
    edge("-|>"),
    node((1, 0), [Preamp.], shape: rect),
    edge("-|>"),
    node((2, 0), [Compresor], shape: rect),
    edge("-|>"),
    node((3, 0), align(center)[Modulador \ equilibrado], shape: rect, name: <mod>),
    node((4, 0), align(center)[OL \ (portadora)], shape: rect, name: <olp>),
    edge(<olp>, <mod>, "-|>"),
    edge(<mod>, (3, 0.55), (0, 0.55), (0, 1), "-|>"),
    node((0, 1), align(center)[Filtro de \ banda lateral], shape: rect),
    edge("-|>"),
    node((1, 1), [Mezclador], shape: rect, name: <mx>),
    node((1, 1.85), [VFO], shape: rect, name: <vfo>),
    edge(<vfo>, <mx>, "-|>"),
    edge(<mx>, (2, 1), "-|>"),
    node((2, 1), align(center)[Lineal \ clase AB], shape: rect, name: <lin>),
    edge("-|>"),
    node((3, 1), align(center)[Paso \ bajo], shape: rect, name: <pb>),
    edge("-|>"),
    node((4, 1), [Antena], stroke: none, fill: none),
    edge(<pb>, (3, 1.6), (2, 1.6), <lin>, "-|>", stroke: (paint: col.senal3, dash: "dashed", thickness: 0.6pt)),
    node((3.3, 1.85), text(fill: col.senal3)[ALC: muestra la salida y frena la excitación], stroke: none, fill: none),
  )
}

'''),
]
