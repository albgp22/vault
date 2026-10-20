// =====================================================================
//  Examen de radioaficionado (HAREC) — hoja de conceptos clave, explicada
//  Documento independiente (no usa la página del libro).
//  Compilar:  cd /Users/albertogarciaplanes/tmpradio &&
//             typst compile --root . cheatsheet.typ build/cheatsheet.pdf
// =====================================================================
#import "/lib/template.typ": col, fuente-texto, fuente-sans, fuente-mate, fuente-mono, falstad, cetz, diagram, node, edge
#import "/lib/circuits.typ": esquema, zap, onda, ejes, bateria
#import "/lib/falstad-custom.typ": fc

#set document(title: "Examen de radioaficionado (HAREC) — hoja de conceptos clave", author: "")
#set page(
  paper: "a4",
  margin: (x: 1.25cm, top: 1.2cm, bottom: 1.35cm),
  columns: 2,
  footer-descent: 0.45cm,
  footer: context {
    set text(font: fuente-sans, size: 6.8pt, fill: col.gris)
    [Examen de radioaficionado (HAREC) · hoja de conceptos clave #h(1fr) Prueba 1: T1–T10 · Prueba 2: R1–R9 #h(1fr) #counter(page).display() / #counter(page).final().first()]
  },
)
#set columns(gutter: 0.75cm)
#set text(font: fuente-texto, size: 8.5pt, lang: "es", region: "es", hyphenate: true, fill: col.tinta)
#set par(justify: false, leading: 0.52em, spacing: 0.62em)
#show math.equation: set text(font: fuente-mate)
#show math.equation: it => { show ",": math.class("normal", ","); it }
#set list(indent: 0.1em, body-indent: 0.45em, spacing: 0.5em, marker: text(fill: col.acento)[•])
#set table(inset: (x: 3.2pt, y: 2.6pt), stroke: 0.3pt + col.gris.lighten(50%))
#show table.cell: set par(justify: false, leading: 0.45em)
#show table.cell: set text(size: 0.95em)
#show raw: set text(font: fuente-mono, size: 7.2pt, fill: col.acento)

// ---------------------------------------------------------------------
//  Piezas de la hoja
// ---------------------------------------------------------------------
#let _sans = fuente-sans

/// Término clave en línea.
#let k(t) = text(font: _sans, weight: "bold", size: 0.9em, fill: col.acento, t)

#let _caja(etq, color, fondo, cuerpo) = block(
  width: 100%, fill: fondo, stroke: (left: 2pt + color), inset: (x: 6pt, y: 4.5pt),
  radius: (right: 2pt), above: 0.7em, below: 0.7em, breakable: true,
  [#text(font: _sans, weight: "bold", size: 0.86em, fill: color, etq)#h(3pt)#cuerpo],
)
/// Trampa del examen.
#let ojo(c) = _caja("¡OJO!", col.naranja, col.naranja-claro, c)
/// Regla para memorizar.
#let recuerda(c) = _caja("Recuerda", col.ambar, col.ambar-claro, c)
/// Por qué funciona un circuito.
#let porque(c) = _caja("Por qué funciona", col.verde, col.verde-claro, c)
/// Número típico de examen.
#let ej(c) = [#text(font: _sans, size: 0.84em, weight: "bold", fill: col.gris)[Ej.]#h(2pt)#c]

/// Fórmula en recuadro con su explicación al lado.
#let fml(f, cuerpo, ancho: auto) = block(width: 100%, above: 0.65em, below: 0.65em, breakable: false, grid(
  columns: (ancho, 1fr), column-gutter: 7pt, align: (center + horizon, left + horizon),
  box(fill: col.acento-claro, stroke: 0.4pt + col.acento.lighten(45%), radius: 2pt, inset: (x: 4pt, y: 3.5pt), f),
  {
    set text(size: 0.95em)
    set par(justify: false, leading: 0.42em)
    cuerpo
  },
))

/// Fórmula centrada sola.
#let formula(f) = align(center, block(fill: col.acento-claro, stroke: 0.4pt + col.acento.lighten(45%), radius: 2pt, inset: (x: 7pt, y: 4pt), above: 0.65em, below: 0.65em, f))

/// Banda de prueba (naranja).
#let prueba(t, sub) = block(
  width: 100%, fill: col.naranja, inset: (x: 6pt, y: 4.5pt), radius: 2pt, above: 0.5em, below: 0.6em, sticky: true,
  align(center, text(font: _sans, fill: white)[#text(size: 9pt, weight: "bold", tracking: 0.04em, upper(t)) \ #v(-1.5pt) #text(size: 6.8pt, sub)]),
)

/// Banda de tema (azul): id, título y peso en el banco.
#let tema(id, t, peso) = block(
  width: 100%, fill: col.acento, inset: (x: 6pt, y: 4pt), radius: 1.5pt, above: 1.2em, below: 0.6em, sticky: true,
  text(font: _sans, size: 8.3pt, fill: white)[#text(weight: "bold", size: 9.2pt)[#id]#h(5pt)#text(weight: "bold", tracking: 0.03em, upper(t))#h(1fr)#text(size: 6.8pt)[#peso]],
)

/// Subtítulo dentro de un tema.
#let sub(t) = block(
  above: 0.95em, below: 0.45em, sticky: true, width: 100%,
  stroke: (bottom: 0.4pt + col.acento.lighten(55%)), inset: (bottom: 1.6pt),
  text(font: _sans, size: 8pt, weight: "bold", fill: col.acento, t),
)

/// Figura pequeña con pie. `sim` = archivo del catálogo de Falstad (o lista).
#let fig(cuerpo, cap: none, sim: none) = block(width: 100%, breakable: false, above: 0.8em, below: 0.8em, {
  align(center, cuerpo)
  if cap != none or sim != none {
    v(-0.5pt)
    set text(size: 7.1pt, fill: col.gris)
    set par(justify: false, leading: 0.38em)
    // sim: "archivo.txt", o lista de pares ("archivo.txt", [texto del botón])
    let badges = if sim == none { none } else if type(sim) == array {
      sim.map(((s, t)) => falstad(s, texto: t)).join(h(2pt))
    } else { falstad(sim, texto: [Simúlalo]) }
    block(width: 100%, [#cap #if badges != none { h(2pt); badges }])
  }
})

/// Cabecera de tabla en gris.
#let th(..c) = table.header(..c.pos().map(x => table.cell(fill: col.gris-claro, text(font: _sans, weight: "semibold", size: 0.9em, x))))

/// Texto pequeño en figuras.
#let t7(c) = text(size: 6.8pt, c)
#let t6(c) = text(size: 6.2pt, c)

// =====================================================================
//  FIGURAS (todas caben en una columna, unos 8,9 cm)
// =====================================================================

// --- Senoide: pico, eficaz, media, periodo -----------------------------
#let fig-senoide = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let A = 1.0
  let T = 5.0
  let s(x) = A * calc.sin(2 * calc.pi * x / T)
  line((0, 0), (T + 0.45, 0), mark: (end: ">", fill: black), stroke: 0.5pt)
  line((0, -A - 0.2), (0, A + 0.35), mark: (end: ">", fill: black), stroke: 0.5pt)
  content((T + 0.45, 0), anchor: "north-east", padding: 2pt, t7($t$))
  content((0.05, A + 0.35), anchor: "west", padding: 2pt, t7($v(t)$))
  // media de la semionda (solo bajo el primer lóbulo)
  rect((0, 0), (T / 2, 0.637 * A), fill: col.verde.lighten(85%), stroke: none)
  onda(s, 0, T + 0.08, stroke: 1.1pt + col.senal1)
  line((0, 0.637 * A), (T / 2, 0.637 * A), stroke: (paint: col.verde, thickness: 0.7pt, dash: "densely-dotted"))
  content((T / 4, 0.637 * A / 2), t6(text(fill: col.verde)[media ½ ciclo \ $0,637 V_"max"$]))
  // pico y eficaz
  line((T / 4, A), (T + 0.3, A), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dashed"))
  line((T / 2, 0.707 * A), (T + 0.3, 0.707 * A), stroke: (paint: col.senal2, thickness: 0.7pt, dash: "dashed"))
  content((T + 0.32, A), anchor: "west", t7[$V_"max"$ (pico)])
  content((T + 0.32, 0.707 * A), anchor: "west", t7(text(fill: col.senal2)[$V_"ef" = 0,707 V_"max"$]))
  // pico a pico
  line((T + 0.2, -A), (T + 0.2, A), mark: (start: ">", end: ">", fill: black, scale: 0.5), stroke: 0.45pt)
  line((3 * T / 4, -A), (T + 0.3, -A), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dashed"))
  content((T + 0.32, -0.45 * A), anchor: "west", t7[$V_"pp" = 2 V_"max"$ \ (pico a pico)])
  // periodo
  line((0, -A - 0.12), (T, -A - 0.12), mark: (start: ">", end: ">", fill: black, scale: 0.5), stroke: 0.45pt)
  content((T / 2, -A - 0.12), anchor: "north", padding: 2pt, t7[periodo $T = 1 slash f$])
})

// --- Espectros de CW, AM, BLU y FM -----------------------------------
#let fig-espectros = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let w = 2.05
  let gap = 0.22
  let raya(x, h, c: col.senal1, dash: none) = line((x, 0), (x, h), stroke: (paint: c, thickness: 1.3pt, dash: dash))
  let base(x0, titulo) = {
    line((x0, 0), (x0 + w, 0), mark: (end: ">", fill: black, scale: 0.5), stroke: 0.45pt)
    content((x0 + w / 2, 1.28), t7(text(weight: "bold", font: _sans, titulo)))
    content((x0 + w, 0), anchor: "north-east", padding: 1pt, t6($f$))
  }
  let llave(x1, x2, y, txt) = {
    line((x1, y), (x2, y), mark: (start: "|", end: "|", scale: 0.4), stroke: 0.4pt)
    content(((x1 + x2) / 2, y), anchor: "north", padding: 1.5pt, t6(txt))
  }
  // CW
  let x0 = 0
  base(x0, [A1A · CW])
  raya(x0 + w / 2, 1.0)
  content((x0 + w / 2, -0.12), anchor: "north", t6[una raya \ (portadora on/off)])
  // AM
  x0 = w + gap
  base(x0, [A3E · AM])
  raya(x0 + w / 2, 1.0)
  raya(x0 + w / 2 - 0.5, 0.5, c: col.senal2)
  raya(x0 + w / 2 + 0.5, 0.5, c: col.senal2)
  llave(x0 + w / 2 - 0.5, x0 + w / 2 + 0.5, -0.1, [$B = 2 f_m$ (6 kHz)])
  // BLU
  x0 = 2 * (w + gap)
  base(x0, [J3E · BLU/SSB])
  raya(x0 + 0.55, 0.85, c: col.gris, dash: "dotted")
  line((x0 + 0.62, 0), (x0 + 0.62, 0.55), (x0 + 1.75, 0.42), (x0 + 1.75, 0), close: true, fill: col.senal2.lighten(70%), stroke: 0.6pt + col.senal2)
  content((x0 + 0.62, 0.82), anchor: "west", t6[sin portadora])
  llave(x0 + 0.62, x0 + 1.75, -0.1, [1 banda, 2,7 kHz])
  // FM
  x0 = 3 * (w + gap)
  base(x0, [F3E · FM])
  let hs = (0.35, 0.6, 0.45, 0.25, 0.12)
  for (i, h) in hs.enumerate() {
    raya(x0 + w / 2 + i * 0.19, h, c: col.senal3)
    if i > 0 { raya(x0 + w / 2 - i * 0.19, h, c: col.senal3) }
  }
  llave(x0 + w / 2 - 0.85, x0 + w / 2 + 0.85, -0.1, [rayas cada $f_m$; \ $B approx 2(Delta f + f_m)$])
})

// --- Curva de resonancia ----------------------------------------------
#let fig-resonancia = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let sx = 1.35
  let sy = 1.75
  let r(x, Q) = 1 / calc.sqrt(1 + Q * Q * calc.pow(x / 3 - 3 / x, 2))
  line((0, 0), (6.4 * sx / 1.35 + 0.1, 0), mark: (end: ">", fill: black), stroke: 0.5pt)
  line((0, 0), (0, 1.25 * sy), mark: (end: ">", fill: black), stroke: 0.5pt)
  content((6.5, 0), anchor: "north-east", padding: 2pt, t7($f$))
  content((0.05, 1.25 * sy), anchor: "west", padding: 2pt, t7[$I$ (serie) o $Z$ (paralelo)])
  onda(x => sy * r(x / sx, 1.5), 0.25 * sx, 6.2, stroke: (paint: col.senal2, thickness: 0.9pt, dash: "dashed"))
  onda(x => sy * r(x / sx, 5), 0.25 * sx, 6.2, stroke: 1.2pt + col.senal1)
  // -3 dB
  line((0, 0.707 * sy), (6.0, 0.707 * sy), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dotted"))
  content((6.02, 0.707 * sy), anchor: "west", t6[−3 dB \ (×0,707)])
  // f0
  line((3 * sx, 0), (3 * sx, sy), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dotted"))
  content((3 * sx, 0), anchor: "north", padding: 2pt, t7($f_0$))
  // ancho de banda para Q = 5
  let xl = 2.7148 * sx
  let xh = 3.3148 * sx
  line((xl, 0.707 * sy), (xl, 0.2), stroke: 0.35pt + col.senal1)
  line((xh, 0.707 * sy), (xh, 0.2), stroke: 0.35pt + col.senal1)
  line((xl, 0.28), (xh, 0.28), mark: (start: ">", end: ">", fill: col.senal1, scale: 0.4), stroke: 0.45pt + col.senal1)
  content((xh + 0.05, 0.28), anchor: "west", t7(text(fill: col.senal1)[$B = f_0 slash Q$]))
  line((0.2, 1.08 * sy), (0.6, 1.08 * sy), stroke: 1.2pt + col.senal1)
  content((0.68, 1.08 * sy), anchor: "west", t6(text(fill: col.senal1)[$Q$ alta: estrecha, selectiva]))
  line((0.2, 0.93 * sy), (0.6, 0.93 * sy), stroke: (paint: col.senal2, thickness: 0.9pt, dash: "dashed"))
  content((0.68, 0.93 * sy), anchor: "west", t6(text(fill: col.senal2)[$Q$ baja: ancha]))
})

// --- Fuente lineal: bloques y forma de onda tras cada uno -------------
#let fig-fuente = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let w = 1.78
  let g = 0.5
  let nombres = ([Transformador], [Rectificador \ (puente)], [Filtro \ (condensador)], [Regulador \ (zéner o CI)])
  let notas = ([230 V~ → 15 V~], [pulsos de 100 Hz], [continua + rizado], [continua fija 13,8 V])
  for i in range(4) {
    let x = i * (w + g)
    rect((x, 1.0), (x + w, 1.75), radius: 0.06, stroke: 0.6pt + col.acento, fill: col.acento-claro)
    content((x + w / 2, 1.375), t6(align(center, text(font: _sans, nombres.at(i)))))
    if i < 3 { line((x + w, 1.375), (x + w + g, 1.375), mark: (end: ">", fill: black, scale: 0.6), stroke: 0.6pt) }
    // eje de la mini forma de onda
    line((x + 0.05, 0.2), (x + w - 0.05, 0.2), stroke: 0.3pt + col.gris)
    content((x + w / 2, -0.02), anchor: "north", t6(notas.at(i)))
  }
  let f0(x) = calc.sin(2 * calc.pi * x / 0.55)
  // transformador: senoide pequeña
  onda(x => 0.5 + 0.28 * f0(x - 0.1), 0.1, w - 0.1, stroke: 0.8pt + col.senal1)
  // rectificador: |sen|
  let x1 = w + g
  onda(x => 0.2 + 0.56 * calc.abs(f0(x - x1 - 0.1)), x1 + 0.1, x1 + w - 0.1, stroke: 0.8pt + col.senal1)
  // filtro: rizado (carga rápida, descarga lenta)
  let x2 = 2 * (w + g)
  onda(x => 0.2 + 0.56 * calc.abs(f0(x - x2 - 0.1)), x2 + 0.1, x2 + w - 0.1, stroke: 0.4pt + col.gris.lighten(55%))
  let riz(x) = {
    let p = 0.275
    let u = calc.rem(x - x2 - 0.1 + 0.07, p) / p
    0.2 + 0.56 - 0.1 * u
  }
  onda(riz, x2 + 0.15, x2 + w - 0.1, n: 220, stroke: 0.9pt + col.senal2)
  // regulador: recta
  let x3 = 3 * (w + g)
  line((x3 + 0.1, 0.62), (x3 + w - 0.1, 0.62), stroke: 1pt + col.senal3)
})

// --- Amplificador en emisor común ---------------------------------------------
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

// --- Clases de amplificador: ángulo de conducción -----------------------
#let fig-clases = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let w = 1.95
  let g = 0.3
  let h = 0.72
  let datos = (
    ([A], [360°], x => 0.5 + 0.42 * calc.sin(x)),
    ([AB], [180–360°], x => calc.max(0, calc.sin(x) + 0.3) * 0.75),
    ([B], [180°], x => calc.max(0, calc.sin(x)) * 0.85),
    ([C], [< 180°], x => calc.max(0, calc.sin(x) - 0.55) * 1.8),
  )
  for (i, d) in datos.enumerate() {
    let x0 = i * (w + g)
    let (nom, ang, f) = d
    line((x0, 0), (x0 + w, 0), stroke: 0.4pt)
    line((x0, 0), (x0, 1.0), stroke: 0.4pt)
    // entrada (gris) y corriente de colector (color)
    onda(x => 0.45 + 0.35 * calc.sin(2 * calc.pi * (x - x0) / (w / 2)), x0, x0 + w, stroke: (paint: col.gris.lighten(30%), thickness: 0.5pt, dash: "dotted"))
    onda(x => h * f(2 * calc.pi * (x - x0) / (w / 2)), x0, x0 + w, n: 200, stroke: 1.1pt + col.senal2)
    content((x0 + w / 2, 1.18), t7(text(font: _sans, weight: "bold")[Clase #nom · #ang]))
  }
  content((2 * w + 1.5 * g, -0.12), anchor: "north", t6[gris: señal de entrada · rojo: corriente de colector (el transistor solo conduce donde hay rojo)])
})

// --- Redes L, pi y T ------------------------------------------------------
#let fig-redes = esquema(escala: 0.62, {
  import zap: *
  import cetz.draw: content, line, rect
  let y = 1.6
  let caja(x1, x2, titulo, nota) = {
    content(((x1 + x2) / 2, y + 0.85), t7(text(font: _sans, weight: "bold", titulo)))
    content(((x1 + x2) / 2, -0.35), anchor: "north", t6(align(center, nota)))
  }
  // L: L serie + C a masa
  wire((0, 0), (3.2, 0), n: "o-o")
  inductor("la", (0, y), (2.0, y), n: "o-")
  wire((2.0, y), (3.2, y), n: "-o")
  capacitor("ca", (2.6, y), (2.6, 0))
  caja(0, 3.2, [Red en L], [2 elementos: \ adapta 2 impedancias])
  // pi: C – L – C
  let x = 4.2
  wire((x, 0), (x + 4.0, 0), n: "o-o")
  wire((x, y), (x + 0.7, y), n: "o-")
  inductor("lp", (x + 0.7, y), (x + 3.3, y))
  wire((x + 3.3, y), (x + 4.0, y), n: "-o")
  capacitor("cp1", (x + 0.6, y), (x + 0.6, 0))
  capacitor("cp2", (x + 3.4, y), (x + 3.4, 0))
  caja(x, x + 4.0, [Red en π (C–L–C)], [paso bajo: salida del TX \ (quita armónicos y adapta)])
  // T: L – C – L
  let x = 9.2
  wire((x, 0), (x + 4.2, 0), n: "o-o")
  inductor("lt1", (x, y), (x + 1.9, y), n: "o-")
  inductor("lt2", (x + 2.3, y), (x + 4.2, y), n: "-o")
  wire((x + 1.9, y), (x + 2.3, y))
  capacitor("ct", (x + 2.1, y), (x + 2.1, 0))
  caja(x, x + 4.2, [Red en T (L–C–L)], [paso bajo en T; en acopladores \ se usa la T «al revés»: C–L–C])
})

// --- Superheterodino: bloques ---------------------------------------------
#let fig-superhet = {
  set text(size: 6.4pt, font: _sans)
  let cag = (paint: col.senal3, dash: "dashed", thickness: 0.6pt)
  diagram(
    node-stroke: 0.6pt + col.acento, node-fill: col.acento-claro, node-corner-radius: 2pt,
    spacing: (2.6mm, 4mm), node-inset: 2.8pt, edge-stroke: 0.6pt,
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

// --- Superheterodino: eje de frecuencias e imagen ----------------------------
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
  content((0.05, 1.28), anchor: "west", t6(text(fill: col.senal3)[preselector]))
  let marca(f, h, c, txt) = {
    line((f2x(f), 0), (f2x(f), h), stroke: 1.5pt + c)
    content((f2x(f), h), anchor: "south", padding: 1.5pt, t6(align(center, txt)))
  }
  marca(14.2, 1.3, col.senal1, [señal 14,2])
  marca(14.655, 1.3, col.ambar, [OL 14,655])
  marca(15.11, 1.3, col.senal2, [imagen 15,11])
  let llave(a, b, txt) = {
    line((f2x(a), -0.2), (f2x(b), -0.2), mark: (start: "|", end: "|", scale: 0.4), stroke: 0.4pt)
    content(((f2x(a) + f2x(b)) / 2, -0.2), anchor: "north", padding: 1.5pt, t6(txt))
  }
  llave(14.2, 14.655, [FI = 455 kHz])
  llave(14.655, 15.11, [FI = 455 kHz])
})

// --- Dipolo de media onda --------------------------------------------------
#let fig-dipolo = cetz.canvas(length: 0.92cm, {
  import cetz.draw: *
  let L = 3.9
  // envolvente de corriente (arriba) y de tensión (abajo)
  onda(x => 0.85 * calc.cos(calc.pi * x / (2 * L)), -L, L, stroke: 1.1pt + col.senal1, fill: col.senal1.lighten(85%))
  onda(x => -0.75 * calc.abs(calc.sin(calc.pi * x / (2 * L))), -L, L, stroke: (paint: col.senal2, thickness: 1pt, dash: "dashed"))
  // conductor
  line((-L, 0), (-0.1, 0), stroke: 2pt + col.tinta)
  line((0.1, 0), (L, 0), stroke: 2pt + col.tinta)
  line((-0.1, 0), (-0.1, -0.95), stroke: 0.6pt)
  line((0.1, 0), (0.1, -0.95), stroke: 0.6pt)
  content((0, -0.97), anchor: "north", t6[alimentación: $Z approx 73 Omega$ (resistiva)])
  content((0, 0.9), anchor: "south", t7(text(fill: col.senal1)[$I$ máxima en el centro]))
  content((-L, -0.8), anchor: "north-west", t6(text(fill: col.senal2)[$V$ máx., $I = 0$; \ $Z$ de miles de Ω]))
  content((L, -0.8), anchor: "north-east", t6(text(fill: col.senal2)[$V$ máxima en \ los extremos]))
  // cota
  line((-L, 1.25), (L, 1.25), mark: (start: ">", end: ">", fill: black, scale: 0.5), stroke: 0.45pt)
  content((0, 1.25), anchor: "south", padding: 1.5pt, t7[$lambda slash 2$ (banda de 40 m → unos 20 m)])
})

// --- Ionosfera (alturas sin escala) ----------------------------------------------
#let fig-ionosfera = cetz.canvas(length: 0.86cm, {
  import cetz.draw: *
  let W = 10.0
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
  let tx = (4.0, 0)
  line(tx, (6.65, 2.45), (9.3, 0), stroke: 1pt + col.senal1)
  line(tx, (5.15, 3.15), stroke: (paint: col.senal2, thickness: 0.9pt, dash: "dashed"))
  content((5.2, 3.12), anchor: "west", t6(text(fill: col.senal2)[$f$ > MUF: atraviesa y se pierde]))
  line(tx, (5.0, 0.0), stroke: 1.4pt + col.verde, mark: (end: ">", fill: col.verde, scale: 0.4))
  content((4.0, 0), anchor: "north", padding: 1pt, t6[TX])
  content((9.3, 0), anchor: "north-east", padding: 1pt, t6[1.#super[er] salto])
  line((5.05, -0.3), (9.25, -0.3), mark: (start: "|", end: "|", scale: 0.4), stroke: 0.4pt)
  content((7.15, -0.3), anchor: "north", padding: 1pt, t6[zona de silencio])
  content((3.75, -0.08), anchor: "north-east", t6(text(fill: col.verde)[onda de superficie →]))
})

// --- Transmisor de BLU -------------------------------------------------------
#let fig-tx-blu = {
  set text(size: 6.4pt, font: _sans)
  diagram(
    node-stroke: 0.6pt + col.acento, node-fill: col.acento-claro, node-corner-radius: 2pt,
    spacing: (3mm, 4mm), node-inset: 2.8pt, edge-stroke: 0.6pt,
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
    edge(<pb>, (3, 1.6), (1.5, 1.6), (1.5, 1.08), "-|>", stroke: (paint: col.senal3, dash: "dashed", thickness: 0.6pt)),
    node((3.2, 1.95), align(center, text(fill: col.senal3)[ALC: muestra la salida \ y frena la excitación]), stroke: none, fill: none),
  )
}

// --- PLL ------------------------------------------------------------------------
#let fig-pll = {
  set text(size: 6.4pt, font: _sans)
  diagram(
    node-stroke: 0.6pt + col.acento, node-fill: col.acento-claro, node-corner-radius: 2pt,
    spacing: (4mm, 5mm), node-inset: 3.2pt, edge-stroke: 0.6pt,
    node((0, 0), align(center)[Referencia \ 12,5 kHz], shape: rect),
    edge("-|>"),
    node((1, 0), align(center)[Comparador \ de fase], shape: rect, name: <cf>),
    edge("-|>"),
    node((2, 0), align(center)[Filtro \ de lazo], shape: rect),
    edge("-|>", [tensión]),
    node((3, 0), align(center)[VCO \ (varicap)], shape: rect, name: <vco>),
    edge("-|>"),
    node((4, 0), align(center)[salida \ 145 MHz], stroke: none, fill: none),
    node((2, 0.95), [÷ N (11 600) → 12,5 kHz], shape: rect, name: <div>),
    edge(<vco>, (3, 0.95), <div>, "-|>"),
    edge(<div>, (1, 0.95), <cf>, "-|>"),
  )
}

// --- Código de colores: ejemplo ---------------------------------------------------
#let fig-resistencia(bandas, txt) = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  line((-1.05, 0), (-0.6, 0), stroke: 0.8pt + col.gris)
  line((0.6, 0), (1.05, 0), stroke: 0.8pt + col.gris)
  rect((-0.6, -0.2), (0.6, 0.2), radius: 0.12, fill: rgb("#e9dcc3"), stroke: 0.5pt)
  let xs = (-0.4, -0.22, -0.04, 0.33)
  for (i, c) in bandas.enumerate() {
    rect((xs.at(i) - 0.05, -0.2), (xs.at(i) + 0.05, 0.2), fill: c, stroke: none)
  }
  content((1.15, 0), anchor: "west", t7(txt))
})

// --- Condensador en continua: el examen de los 9 V ------------------------------
#let fig-c-cc = esquema(escala: 0.55, {
  import zap: *
  import cetz.draw: content
  bateria("v", (0, 2.4), (0, 0))
  resistor("r1", (0, 2.4), (2.6, 2.4))
  resistor("r2", (2.6, 2.4), (2.6, 0))
  wire((2.6, 2.4), (4.0, 2.4))
  capacitor("c", (4.0, 2.4), (4.0, 0))
  wire((0, 0), (4.0, 0))
  content((-0.45, 1.2), anchor: "east", t7[12 V])
  content((1.3, 2.75), anchor: "south", t7[1 kΩ])
  content((2.12, 1.2), anchor: "east", t7[3 kΩ])
  content((4.45, 1.2), anchor: "west", t7[$C$: 9 V])
})

// =====================================================================
//  CABECERA
// =====================================================================
#place(top, scope: "parent", float: true, clearance: 7pt, {
  block(width: 100%, below: 3pt, stroke: (bottom: 1.2pt + col.acento), inset: (bottom: 3pt), grid(
    columns: (auto, 1fr), align: (left + bottom, right + bottom),
    text(font: _sans, size: 13pt, weight: "bold")[Examen de radioaficionado (HAREC) — hoja de conceptos clave],
    text(font: _sans, size: 7.4pt, weight: "semibold", fill: col.gris)[15 aciertos de 30 en cada parte · 45 min por prueba \ no restan errores],
  ))
  set text(size: 7.4pt, fill: col.gris)
  set par(justify: false)
  [*Cómo leer esta hoja.* Cada fórmula lleva al lado qué es cada símbolo, su unidad y un número típico de examen (#text(font: _sans, size: 0.9em, weight: "bold")[Ej.]). Los recuadros #box(fill: col.naranja-claro, inset: (x: 2pt, y: 1pt), text(fill: col.naranja, font: _sans, weight: "bold")[¡OJO!]) marcan las trampas del examen; #box(fill: col.ambar-claro, inset: (x: 2pt, y: 1pt), text(fill: col.ambar, font: _sans, weight: "bold")[Recuerda]), las reglas para memorizar; #box(fill: col.verde-claro, inset: (x: 2pt, y: 1pt), text(fill: col.verde, font: _sans, weight: "bold")[Por qué funciona]), cómo trabaja cada circuito. El % de cada tema es su peso aproximado en el banco de preguntas. Los botones #box(fill: col.violeta-claro, inset: (x: 2pt, y: 1pt), text(fill: col.violeta, font: _sans, weight: "bold", size: 0.9em)[▶ Simúlalo]) abren el circuito en el simulador Falstad.]
})

// CUERPO

// =====================================================================
//  PRUEBA 1
// =====================================================================
#prueba[Prueba 1 · Electricidad y radioelectricidad][temas T1–T10 · 30 preguntas · 45 min · aprobado con 15 aciertos]

#tema("T1", [Electricidad, electromagnetismo y radio], [≈16 %])

#sub[Unidades y prefijos]
#table(
  columns: (auto, 1fr, auto, 1fr), stroke: none, inset: (x: 2pt, y: 1.4pt),
  fill: (x, y) => if calc.even(y) { col.gris-claro } else { none },
  [*Ω* ohmio], [resistencia $R$], [*C* culombio], [carga $Q$ (1 C = 1 A·s)],
  [*A* amperio], [intensidad $I$], [*F* faradio], [capacidad $C$],
  [*V* voltio], [tensión y fem $V$, $E$], [*H* henrio], [autoinducción $L$],
  [*W* vatio], [potencia $P$], [*Hz* hercio], [frecuencia $f$],
  [*J* julio], [energía], [*V/m*], [campo eléctrico $E$],
)

#k[Prefijos:] M = 10#super[6] · k = 10#super[3] · m = 10#super[−3] · μ = 10#super[−6] · n = 10#super[−9] · p = 10#super[−12]. #ej[100 pF = 100·10#super[−12] F = 0,1 nF.]

#sub[Ley de Ohm y potencia]
#fml($V = I R$)[$V$ tensión (V) · $I$ corriente (A) · $R$ resistencia (Ω). Despeja la que falte: $I = V slash R$, $R = V slash I$. #ej[2 A por 30 Ω → 60 V.]]
#fml($P = V I = I^2 R = V^2 / R$)[$P$ potencia (W). Elige la forma con los dos datos que te dan. #ej[2 A en 30 Ω → $P = 2^2 dot 30 = 120$ W. Doblar $I$ cuadruplica $P$.]]
#ojo[$P = E^2 R$ es la fórmula *falsa* que ponen de distractor: la $R$ *divide* ($P = E^2 slash R$).]
#fml($R = rho l / S$)[$rho$ resistividad del material (Ω·m) · $l$ longitud (m) · $S$ sección (m²). Más longitud o más resistividad → más $R$; más sección (hilo más gordo) → menos $R$. #ej[doble longitud → doble $R$.]]

#sub[Asociación de resistencias, Kirchhoff y fuentes]
#table(
  columns: (auto, 1fr, 1fr),
  th[][Serie (en fila)][Paralelo (lado a lado)],
  [es común], [la misma $I$], [la misma $V$],
  [total], [$R = R_1 + R_2 + …$ \ mayor que la mayor], [$1 slash R = 1 slash R_1 + 1 slash R_2 + …$; dos: producto/suma; $n$ iguales: $R slash n$. Siempre *menor que la menor*],
)
#ej[100 Ω ∥ 100 Ω = 50 Ω; 60 Ω ∥ 30 Ω = 1800/90 = 20 Ω.]

- #k[Kirchhoff.] Nudo: $sum I = 0$ (la corriente que entra, sale). Malla: $sum V = 0$ (lo que suben las fuentes, lo bajan las cargas).
- #k[Coulomb.] $F = k q_1 q_2 slash d^2$: $F$ fuerza (N), $q$ cargas (C), $d$ distancia (m), $k approx 9 dot 10^9$. Doblar $d$ → fuerza ÷ 4.
- #k[Fuente real.] $V = epsilon - I r$: $epsilon$ fem (V), $r$ resistencia interna (Ω). En cortocircuito: $I_"cc" = epsilon slash r$.
- #k[Pilas.] En serie suman tensión (misma corriente); en paralelo, misma tensión y más corriente. Batería: energía química → eléctrica.
- #k[Duración de una batería.] $t = C slash I$ ($C$ en Ah). #ej[7 Ah a 0,5 A → 14 h.]

#sub[Campos y onda electromagnética]
- #k[Campo eléctrico] $E = V slash d$ (V/m). Se apantalla con metal puesto a tierra. El *magnético* de baja frecuencia solo se apantalla con materiales ferromagnéticos.
- #k[Onda EM:] $arrow(E) perp arrow(B)$ (y los dos, perpendiculares al avance). *Polarización = dirección de $arrow(E)$*. Velocidad en el vacío constante: $c = 3 dot 10^8$ m/s (300 000 km/s).
#fml([$c = lambda f$ \ #v(0.25em) $lambda ("m") approx 300 / (f ("MHz"))$])[$lambda$ longitud de onda (m) · $f$ frecuencia. Úsala para pasar de frecuencia a nombre de banda. #ej[144 o 145 MHz → 2 m · 430 MHz → 70 cm · 7 MHz → 40 m · 3,5 MHz → 80 m.]]

#sub[Señal senoidal, fase y otras señales]
#fig(fig-senoide, cap: [Una senoide. El *eficaz* (RMS) da el mismo calor en una resistencia que una continua de ese valor. «Amplitud» = máximo − valor medio.])
#table(
  columns: (auto, auto, 1fr),
  th[Valor][Fórmula][Ej. con $V_"max" = 100$ V],
  [periodo], [$T = 1 slash f$], [25 Hz → $T$ = 40 ms],
  [eficaz], [$V_"ef" = V_"max" slash sqrt(2) = 0,707 V_"max"$], [70,7 V],
  [media de ½ ciclo], [$2 V_"max" slash pi = 0,637 V_"max"$], [63,7 V (senoide entera: 0)],
)
- #k[Fase.] En $R$: $V$ e $I$ en fase. En $L$: $V$ adelanta 90° a $I$. En $C$: $I$ adelanta 90° a $V$.
#recuerda[«CIVIL»: en *C*, la *I* va antes que la *V*; la *V* va antes que la *I* en *L*.]
- #k[Factor de potencia] $cos phi = P slash S$: $P$ potencia real (W), $S$ aparente (VA), $phi$ desfase entre $V$ e $I$.
- #k[Señal no senoidal] (Fourier) = continua + fundamental $f$ + armónicos $2f$, $3f$…
- #k[Ruido blanco:] igual a todas las frecuencias. #k[Ruido térmico:] $P = k T B$ ($k = 1,38 dot 10^(-23)$ J/K, $T$ en K, $B$ ancho en Hz): a más ancho de banda, más ruido. Señal *analógica*: infinitos valores posibles.

#sub[Modulación]
#fig(fig-espectros, cap: [Espectros típicos (la frecuencia menor, a la izquierda). Modulada con un solo tono, la BLU es *una sola raya*; con voz, una banda de 2,7 kHz.], sim: ((fc.at("modulacion-am"), [AM]), (fc.at("modulacion-fm"), [FM])))
#table(
  columns: (1.75cm, 1.6cm, 1fr),
  th[Clase][Varía][Lo que cae en el examen],
  [`A1A` CW], [on/off], [flancos bruscos ⇒ chasquidos (clics)],
  [`A3E` AM], [amplitud], [portadora + 2 bandas: $B = 2 f_m$ (6 kHz con voz de 3 kHz); $m > 100$ % = sobremodulación (distorsión, _splatter_)],
  [`J3E` BLU/SSB], [amplitud], [1 banda, sin portadora: 2,7 kHz],
  [`F3E` FM], [frecuencia], [amplitud constante; índice $m = Delta f slash f_m$; Carson $B approx 2(Delta f + f_m)$; FM comercial en VHF],
  [PM], [fase], [—],
)
#fml($P_t = P_c (1 + m^2 / 2)$)[$P_t$ potencia total de AM · $P_c$ de la portadora · $m$ índice (1 = 100 %). Al 100 %: $P_t = 1,5 P_c$, y la *portadora lleva 2/3* del total. #ej[$P_c$ = 100 W, $m$ = 1 → 150 W; 25 W en cada banda.]]
- #k[Digitales.] FSK varía la frecuencia; PSK, la fase; QAM, amplitud + fase. Bits por símbolo $= log_2 M$ ($M$ estados; 16-QAM → 4 bits). El ancho $B$ depende de la *velocidad de símbolo*. CRC *detecta* errores; FEC los *corrige*.

#sub[Decibelios]
#fml($G = 10 log P_2/P_1 = 20 log V_2/V_1$)[$G$ ganancia (dB; negativa = pérdida). Potencias: ×10; tensiones: ×20 (la potencia va con $V^2$).]
#table(
  columns: (auto,) * 7,
  th[×2][×4][×10][×100][×10#super[4]][÷2][÷10],
  [+3 dB], [+6 dB], [+10 dB], [+20 dB], [+40 dB], [−3 dB], [−10 dB],
)
En cadena, los dB *se suman*. #ej[0,2 W + 20 dB → ×100 → 20 W.] dBm: referencia 1 mW · dBW: referencia 1 W · dBμV: tensión, referencia 1 μV.
#ojo[1 W = 30 dBm = 0 dBW (no «30 dBW» ni «30 dB»). 100 W = 50 dBm.]

#sub[Adaptación y DSP]
- #k[Máxima transferencia de potencia:] $R_L = R_g$ (carga = resistencia interna del generador). Rendimiento $eta = P_"sal" slash P_"alim"$.
- #k[Nyquist:] muestrear a $f_s >= 2 f_"max"$. #ej[audio de 3 kHz → al menos 6 kHz.] Si no, *aliasing*: por eso va un filtro antisolapamiento (paso bajo) *antes* del A/D y uno de reconstrucción *tras* el D/A. Cada bit más ≈ +6 dB de margen dinámico.

#tema("T2", [Componentes], [≈10 %])

#sub[Resistencias]
#table(
  columns: (1fr,) * 10,
  align: center,
  ..("negro", "marrón", "rojo", "naranja", "amarillo", "verde", "azul", "violeta", "gris", "blanco").enumerate().map(((i, n)) => {
    let c = (black, rgb("#7b4a1e"), rgb("#c62828"), rgb("#ef7d00"), rgb("#f4d03f"), rgb("#2e8b3d"), rgb("#1f5fbf"), rgb("#7b3fa0"), rgb("#8a8a8a"), white).at(i)
    table.cell(fill: c, inset: (x: 0.5pt, y: 1.8pt), text(fill: if i in (3, 4, 9) { black } else { white }, font: _sans, size: 5.7pt, weight: "bold", hyphenate: false)[#i \ #n])
  }),
)
#k[Código de colores:] 1.ª y 2.ª banda = cifras; 3.ª = multiplicador $10^n$; 4.ª = tolerancia (marrón 1 %, oro 5 %, plata 10 %). Del rojo (2) al violeta (7), como el arco iris.
#grid(columns: (1fr, 1fr), column-gutter: 4pt,
  fig-resistencia((rgb("#7b4a1e"), black, rgb("#c62828"), rgb("#c9a227")), [1-0 ×10² = 1 kΩ 5 %]),
  fig-resistencia((rgb("#7b3fa0"), rgb("#2e8b3d"), rgb("#c62828"), rgb("#c9a227")), [7-5 ×10² = 7,5 kΩ 5 %]),
)
- Se elige por *valor, potencia* ($P = I^2 R$) y *tolerancia*.
- #k[PTC]: $R$ sube con la temperatura. #k[NTC]: $R$ baja. #k[Varistor]: $R$ depende de la tensión (protege de sobretensiones).

#sub[Condensador y bobina]
#table(
  columns: (auto, 1fr, 1fr),
  th[][Condensador $C$][Bobina $L$],
  [qué es], [$C = Q slash V = epsilon S slash d$ (placas separadas por un dieléctrico aislante)], [hilo arrollado; $L$ sube con espiras, diámetro y núcleo ferromagnético],
  [reactancia], [$X_C = 1 slash (2 pi f C)$: *baja* con $f$], [$X_L = 2 pi f L$: *sube* con $f$ (0 en continua)],
  [ej. a 7 MHz], [100 pF → 227 Ω], [10 μH → 440 Ω],
  [energía], [$E = 1/2 C V^2$], [$E = 1/2 L I^2$],
  [otros], [$tau = R C$ (s): en un $tau$ se carga al 63 %], [$Q = X_L slash R$; efecto pelicular: la RF va por la superficie],
)
- #k[Electrolítico]: polarizado, dieléctrico de óxido; filtrado de fuentes. Un condensador cargado se *descarga con una resistencia* antes de tocarlo.

#sub[Transformador]
#formula($V_s / V_p = N_s / N_p #h(1.2em) I_s / I_p = N_p / N_s #h(1.2em) Z_p = (N_p / N_s)^2 Z_s$)
$p$ primario, $s$ secundario, $N$ espiras. Ideal: $P_p = P_s$ (lo que gana en tensión lo pierde en corriente). #ej[20:1 con 230 V → 11,5 V.] #ej[$N_p slash N_s = 2$ → $Z_p = 4 Z_s$ (200 Ω ↔ 50 Ω).]
- Reductor = menos espiras en el secundario. Con *continua no transfiere* (solo transfiere variaciones de flujo).
- #k[Autotransformador]: un devanado común a primario y secundario. Los transformadores también *adaptan impedancias*.

#sub[Semiconductores]
- #k[Diodo]: conduce en un sentido; en directa «cuesta» ≈ 0,6–0,7 V (silicio). #k[Zéner]: estabiliza tensión trabajando *en inversa*. #k[LED]: luce en directa. #k[Varicap]: su $C$ depende de la tensión *inversa* (más tensión → menos $C$). Semiconductor *P*: portadores = *huecos* (N: electrones).
- #k[Transistor bipolar] NPN/PNP: emisor, base, colector. Una corriente pequeña de base controla una grande de colector: $beta = I_C slash I_B$. #ej[$I_B$ = 20 μA, $beta$ = 100 → $I_C$ = 2 mA.]
- #k[FET]: puerta, drenador, surtidor; se controla con *tensión*: $Z_"ent"$ muy alta.
#table(
  columns: (auto, auto, auto, auto, 1fr),
  th[Montaje][Gana en][$Z_"ent"$][$Z_"sal"$][Uso y fase],
  [emisor común], [$V$ e $I$], [media], [media/alta], [amplificador general; *invierte* (180°)],
  [base común], [$V$], [*baja*], [alta], [RF; no invierte],
  [colector común \ (seguidor de emisor)], [$I$ ($V approx 1$)], [*alta*], [*baja*], [adaptador de impedancias, separador],
)
#sub[Válvulas, integrados y símbolos]
- #k[Válvulas]: el cátodo caliente emite; la placa (+) recoge; la rejilla controla. Triodo: 3 electrodos; tetrodo: 4 (rejilla pantalla: menos capacidad rejilla-placa); pentodo: 5 (cátodo, 3 rejillas, placa). Esperar el *caldeo* antes de transmitir.
- #k[Integrados] por escala: SSI, MSI, LSI, VLSI (*«CSI» no existe*).
- #k[Símbolos]: diodo = triángulo y barra; $R$ = rectángulo; $C$ = dos trazos; $L$ = espiras. Faradio = capacidad (no carga); henrio = autoinducción.

#tema("T3", [Circuitos], [≈13 %])

#sub[Resonancia: cómo se elige una emisora entre cientos]
La antena recoge todas las emisoras a la vez. Un circuito $L C$ responde fuerte a *una* frecuencia: la de resonancia. Allí $X_L = X_C$, se anulan y solo queda $R$.
#fml($f_0 = 1 / (2 pi sqrt(L C))$)[$f_0$ (Hz) · $L$ (H) · $C$ (F). Más $L$ o más $C$ → menor $f_0$ (×4 la $C$ → $f_0$ ÷ 2). #ej[10 μH y 50 pF → ≈ 7,1 MHz.]]
#fml($Q = f_0 / B = X / R$)[$Q$ factor de calidad · $B$ ancho de banda a −3 dB (Hz) · $X$ reactancia de $L$ (o $C$) en resonancia · $R$ resistencia de pérdidas. #ej[7 MHz con $Q$ = 100 → $B$ = 70 kHz.]]
#fig(fig-resonancia, cap: [Curva de resonancia. $Q$ alta = curva estrecha = más selectivo.], sim: ((fc.at("resonancia-serie"), [serie]), (fc.at("tanque-paralelo"), [paralelo])))
#table(
  columns: (auto, 1fr, 1fr),
  th[En $f_0$][$L C$ serie][$L C$ paralelo («tanque»)],
  [impedancia], [*mínima* ($= R$): $I$ máxima], [*máxima*: $I$ de línea mínima],
  [uso], [en derivación a masa: *cortocircuito* a $f_0$ (el vatímetro marca mínimo); trampa de una frecuencia], [selecciona $f_0$ en receptores y osciladores; trampas de antena],
)
#porque[en resonancia la energía va y viene entre el campo magnético de $L$ y el eléctrico de $C$, como un columpio. Fuera de $f_0$ ese vaivén no se sincroniza y la respuesta cae.]
- En HF, por encima de su autorresonancia, un condensador real se porta como una *bobina* (por la inductancia de sus terminales).
#ojo[Condensadores: en *paralelo suman*; en serie, por inversas (al revés que las $R$). #ej[tres en paralelo suman 400 pF y dos son de 100 pF → el tercero es de 200 pF.] En régimen permanente (continua) un condensador es un *circuito abierto*:]
#grid(columns: (auto, 1fr), column-gutter: 6pt, align: horizon,
  fig-c-cc,
  text(size: 0.95em)[por $C$ no pasa corriente; queda el divisor 1 kΩ–3 kΩ: $V_C = 12 dot 3 slash (1 + 3) = 9$ V.],
)

#sub[Fuente de alimentación]
#fig(fig-fuente, cap: [Forma de onda a la salida de cada bloque.], sim: ((fc.at("fuente-completa"), [fuente completa]), ("fullrectf.txt", [puente + filtro]), ("zenerref.txt", [zéner])))
- #k[Rectificador.] Media onda: 1 diodo, rizado de 50 Hz. Onda completa: 2 diodos (con toma media) o *puente de 4*, rizado de *100 Hz* (más fácil de filtrar).
#porque[el condensador se carga en cada pico y se descarga despacio en la carga: rellena los huecos. Quita la *alterna residual (rizado)*, no la continua. El regulador mantiene fija la tensión aunque cambien la carga o la red.]
- #k[Conmutada]: trocea a decenas o cientos de kHz; ligera y de buen rendimiento, pero genera ruido de RF (hay que filtrarla).

#sub[Amplificador en emisor común: qué hace cada pieza]
#grid(columns: (auto, 1fr), column-gutter: 4pt, align: horizon,
  fig-ec,
  {
    set text(size: 0.93em)
    set par(justify: false, leading: 0.4em)
    [#cnum(1) $R_1$–$R_2$: divisor; fija la base a ≈ 2,1 V. El transistor queda «a medio abrir» y puede seguir la señal arriba y abajo.
    #parbreak() #cnum(2) $R_E$: $I_E approx (2,1 - 0,6) slash 1,5 "k" = 1$ mA. Estabiliza: si $I_C$ sube por calor, sube $V_E$, baja $V_"BE"$ y la corriente se corrige.
    #parbreak() #cnum(3) $C_E$: pone el emisor a masa *para la señal*: ganancia alta (sin él, $A approx -R_C slash R_E approx -3$).]
  },
)
#[
  #set text(size: 0.95em)
  #cnum(4) $R_C$: convierte la variación de $I_C$ en variación de tensión; en reposo el colector está a $12 - 4,7 dot 1 = 7,3$ V. Cuando la base sube, $I_C$ sube, cae más tensión en $R_C$ y el colector *baja*: por eso invierte 180°.
  #cnum(5) $C_"ent"$, $C_"sal"$: dejan pasar la señal alterna y bloquean la continua; cada etapa conserva su polarización. #falstad("ceamp.txt", texto: [Simúlalo])
]

#sub[Clases de amplificador]
#fig(fig-clases, cap: [Menos tiempo conduciendo = más rendimiento y peor copia.], sim: ((fc.at("clases-ab"), [B frente a AB]), (fc.at("clase-c"), [clase C])))
#table(
  columns: (auto, auto, auto, 1fr),
  th[Clase][Conduce][Rendimiento][Uso],
  [A], [360°], [25–50 %], [mínima distorsión],
  [AB], [180–360°], [medio], [lineal de BLU],
  [B], [180°], [hasta 78,5 %], [en contrafase (dos transistores, un semiciclo cada uno)],
  [C], [< 180°], [el mayor], [amplitud constante: CW y FM],
)
#porque[clase C: el transistor da solo pulsos; un circuito tanque $L C$ en el colector, sintonizado, «rellena» la senoide (efecto volante). Sirve si la amplitud no lleva información.]
#ojo[Clase C solo para CW o FM, *nunca* para BLU ni AM: menos conduce, más rinde y peor copia la señal.]

#sub[Realimentación y operacional]
- #k[Realimentación negativa]: menos ganancia, a cambio de más estabilidad, linealidad y ancho de banda. La *positiva* hace oscilar.
- #k[Operacional]: ganancia muy alta, $Z_"ent"$ alta, $Z_"sal"$ baja; entrada inversora (−) y no inversora (+). Inversor: $G = -R_2 slash R_1$. #ej[$R_1$ = 10 kΩ, $R_2$ = 100 kΩ → $G$ = −10.] #falstad("amp-invert.txt", texto: [Simúlalo])

#sub[Filtros y redes L, π y T]
- Tipos: *paso bajo* (salida del TX: quita armónicos), *paso alto*, *paso banda* (FI), *rechazo de banda*. $f_c$ = frecuencia de corte, a −3 dB. Pendiente: 6 dB/octava por polo (célula). RC simple: $f_c = 1 slash (2 pi R C)$. #ej[1 kΩ y 100 nF → 1,6 kHz.]
#fig(fig-redes, cap: [El nombre sale de la forma del dibujo (L, π, T).], sim: ((fc.at("red-L"), [red L]), (fc.at("red-pi"), [red π]), (fc.at("red-T"), [red T])))
#porque[en un paso bajo, la bobina va *en serie* (frena las frecuencias altas) y el condensador *a masa* (las desvía). En paso alto se cambian los papeles. Además de filtrar, la red *transforma la impedancia*: la red π del final adapta el transistor a 50 Ω y quita los armónicos. El acoplador de antena (red π o T) adapta final, línea y antena.]
#recuerda[π paso bajo = C–L–C; T paso bajo = L–C–L. Cuenta las ramas: π tiene *dos a masa*; T tiene *dos en serie*.]
- #k[Cuarzo]: piezoeléctrico, $Q$ de decenas de miles: filtros muy estrechos y osciladores estables. Filtros digitales: FIR sin realimentación; IIR con ella.

#sub[Osciladores, PLL, mezclador y detectores]
- #k[Oscilador] = amplificador + realimentación *positiva*; la ganancia del lazo compensa las pérdidas y la fase total es 360° (Barkhausen). Convierte continua en alterna. Cristal: muy estable (por encima de unos 20–30 MHz trabaja en sobretono). VCO: sintonizado con varicap; deriva con la temperatura. #falstad("colpitts.txt", texto: [Colpitts]) #falstad("crystalosc2.txt", texto: [cristal]) #falstad("varactorvco.txt", texto: [VCO])
#fig(fig-pll, cap: [PLL: el comparador corrige el VCO hasta que $f_"VCO" slash N$ iguala a la referencia. Cambiar $N$ cambia de canal.], sim: "pll.txt")
#fml($f_"out" = N f_"ref"$)[$N$ divisor programable. #ej[12,5 kHz × 11 600 = 145 MHz; $N$ + 1 → canal siguiente, 145,0125 MHz.]]
#fml($f_1 plus.minus f_2$)[salida de un *mezclador* (multiplica dos señales). #ej[14 y 4 MHz → 18 y 10 MHz.] #falstad(fc.at("mezclador"), texto: [mezclador])]
- #k[Detectores.] AM: de *envolvente* (diodo + RC; asíncrono). BLU y CW: de *producto* + BFO (reinyecta la portadora). FM: de pendiente, discriminador, detector de relación o PLL (normalmente tras un limitador). Diodo + $L C$ paralelo + auricular = receptor de AM («de galena»). #falstad("amdetect.txt", texto: [detector AM])

#tema("T4", [Receptores], [≈13 %])

#sub[El superheterodino]
#fig(fig-superhet, cap: [Cadena: antena → amp. RF → mezclador (con OL) → filtro y amp. FI → detector → amp. BF. El CAG toma la señal del detector y baja la ganancia de RF y FI; el BFO alimenta al detector de producto. En FM: FI → limitador → discriminador.])
#porque[el mezclador lleva *cualquier* emisora a una frecuencia fija, la FI. Así los filtros estrechos y los amplificadores se diseñan una sola vez, para una sola frecuencia. Precio: la *frecuencia imagen*.]
#fig(fig-imagen, cap: [Señal, OL e imagen quedan separadas por la FI; el OL, en medio. La imagen también da FI = 455 kHz: el preselector (verde) la atenúa *antes* del mezclador.])
#formula([$f_"FI" = |f_"OL" - f_s| #h(1.5em) f_"im" = f_s + 2 f_"FI"$ (OL por encima)])
Si el OL está por debajo de la señal, la imagen queda por debajo: $f_"im" = |f_s - 2 f_"FI"|$.
#table(
  columns: (1fr, 1fr),
  th[Datos][Resultado],
  [señal 7 MHz, FI 9 MHz], [OL a 16 MHz],
  [OL 5,2 MHz (debajo), FI 9 MHz], [señal de 14,2 MHz],
  [OL 14,655 MHz, FI 455 kHz], [señal 14,2 MHz; imagen 15,11 MHz],
)
#recuerda[OL arriba: $f_s = f_"OL" - f_"FI"$; OL abajo: $f_s = f_"OL" + f_"FI"$ (la resta es el distractor).]
- #k[Imagen]: se elimina *antes* del mezclador (filtro preselector). #k[Doble conversión]: 1.ª FI alta (aleja la imagen), 2.ª FI baja (da selectividad). #k[Conversión directa]: sin FI; el OL va a la frecuencia de la señal y sale audio.

#sub[Cualidades de un receptor]
#table(
  columns: (auto, 1fr),
  th[Cualidad][Qué es · de qué depende],
  [sensibilidad], [captar señales débiles · la 1.ª etapa],
  [selectividad], [separar señales próximas · filtros de FI],
  [estabilidad], [no derivar de frecuencia · oscilador local],
  [margen dinámico], [aguantar señales fuertes y débiles a la vez · lo fija el 1.#super[er] mezclador],
)
- Relación S/R en dB. Desensibilización y bloqueo; intermodulación y modulación cruzada (no linealidad); canal adyacente (lineal: faldones del filtro de FI). La *figura de ruido* la marca sobre todo la 1.ª etapa. Ruido estático = descargas atmosféricas (QRN).

#sub[Mandos]
#table(
  columns: (auto, 1fr),
  th[Mando][Qué hace],
  [`CAG` (AGC)], [mantiene constante la salida; su mando elige el tiempo de respuesta],
  [S-meter], [intensidad de señal: 6 dB por punto; S9 = 50 μV],
  [`squelch`], [silenciador: corta el audio cuando no hay señal],
  [`NB`], [supresor de ruido impulsivo],
  [`RIT`], [mueve la frecuencia de recepción sin tocar la de transmisión],
  [`RF GAIN`], [ganancia de RF],
  [LSB ↔ USB], [cambia la frecuencia del batido (BFO); el BFO es imprescindible en CW y BLU],
)
- LSB en 160, 80 y 40 m; USB de 20 m hacia arriba. El filtro de FI más estrecho es el de CW; el de BLU, ≈ 2,4 kHz (J3E ocupa ≈ 2,7 kHz). Para oír 2 m con un receptor de HF: un *conversor*.
#ojo[NBFM ocupa 12 kHz (la FM de difusión, 200 kHz; 2,4 kHz es BLU).]

#tema("T5", [Transmisores], [≈8 %])
#fig(fig-tx-blu, cap: [Transmisor de BLU. El modulador equilibrado quita la portadora; el filtro, una banda; el mezclador la sube a la frecuencia de trabajo. El ALC limita la excitación y evita el _splatter_.])
- #k[FM]: varicap en el VCO → multiplicadores (×$N$ multiplica *también la desviación*) → clase C. Modulador de fase tras un cristal = FM *indirecta*.
- #k[Orden general]: modulador → amplificación y traslación → final → red de acoplo. *Excitador*: excita al final. *Separadora*: aísla el oscilador de las etapas siguientes. `VOX`: pasa a transmisión al hablar. `CAF`: control automático de frecuencia. Salida: $Z_"sal"$ = 50 Ω.
- #k[Audio]: 300–3000 Hz. El compresor sube la potencia *media* sin pasar del pico. Sobremodulación (micro alto) → bajar la BF (ganancia de micro).
#fml($m_"FM" = (Delta f) / f_m$)[$Delta f$ desviación · $f_m$ frecuencia moduladora. #ej[25/10 = 2,5.] NBFM: desviación de ±2,5 a ±5 kHz.]

#sub[Potencias y rendimiento]
- #k[Potencia de portadora]: la media en un ciclo de RF, sin modular. #k[PEP] (p.c.e.) = la de la cresta de la envolvente (≥ media). AM al 100 %: pico = 4 × portadora.
- Rendimiento: $eta = P_"ant" slash P_"cons"$ (lo que llega a la antena entre lo que consume).

#sub[Emisiones no deseadas]
#k[No deseadas] = *no esenciales* (armónicos, espurias, intermodulación; lejos del canal) + *fuera de banda* (junto al canal, por la modulación). Se cumple a la vez la atenuación y el tope: vale el más restrictivo.
#table(
  columns: (auto, 1fr, 1fr),
  th[Frecuencia][$P$ alta][$P$ baja],
  [< 30 MHz], table.cell(colspan: 2)[≥ 40 dB bajo la potencia media, sin pasar de 50 mW],
  [30–235 MHz], [> 25 W: 60 dB, ≤ 1 mW], [≤ 25 W: 40 dB, ≤ 25 μW],
  [235–960 MHz], [> 25 W: 60 dB, ≤ 20 mW], [≤ 25 W: 40 dB, ≤ 25 μW],
  [0,96–17,7 GHz], [> 10 W: 50 dB, ≤ 100 mW], [≤ 10 W: 50 dB, ≤ 100 μW],
)
#ej[100 W en HF: −40 dB = 10 mW, menos que 50 mW → manda 10 mW.]
- #k[Radiación por la estructura]: sale por el chasis y los cables (apantallar y filtrar). Ancho *necesario*: el justo para la calidad pedida; *ocupado*: entre los límites inferior y superior reales.
- Ajustar siempre con *carga artificial*. Final valvular: sintonía (mínimo de corriente de placa) y carga.
- #k[Repetidor]: recibe y retransmite a la vez, en otra frecuencia, desde un punto alto; acceso con CTCSS (subtono). En 2 m, la entrada está 600 kHz *por debajo* de la salida.

#tema("T6", [Antenas y líneas de transmisión], [≈14 %])
#fig(fig-dipolo, cap: [Dipolo de media onda: onda estacionaria. $I$ (azul, arriba) máxima en el centro; $V$ (rojo, abajo) máxima en los extremos. Por eso se alimenta en el centro: allí $Z$ es baja y resistiva.])
#table(
  columns: (auto, 1fr),
  th[Antena][Lo que cae en el examen],
  [dipolo λ/2], [≈ 73 Ω en el centro (resistiva), miles de Ω en el extremo],
  [dipolo plegado], [≈ 300 Ω (4 × 73)],
  [vertical λ/4], [plano de tierra o radiales; ≈ 36 Ω (radiales inclinados: hacia 50 Ω); polarización vertical; máximo en el plano horizontal],
  [V invertida], [≈ 50 Ω; un solo mástil],
  [Yagi], [directiva: un elemento alimentado + *parásitos* (reflector más largo, detrás; directores más cortos, delante)],
  [con trampas], [$L C$ paralelo en los brazos: multibanda],
  [bobinas en brazos], [alargan la longitud eléctrica: resuena más bajo que por su longitud física],
  [helicoidal], [polarización circular (satélites); ganancia según el nº de espiras],
  [de apertura], [bocina, parabólica],
)
- #k[Resonancia]: $Z$ resistiva pura. Más corta → capacitiva; más larga → inductiva. *Bajar $f$ = alargar* (29,9 → 28,5 MHz). $C$ en serie acorta (eléctricamente); $L$ en serie alarga.
- #k[Ganancia] relativa: dBi (respecto a la isótropa), dBd (al dipolo); dBi = dBd + 2,15. #k[Ancho de haz]: entre los puntos de −3 dB. #k[Relación adelante-atrás]: dB entre el lóbulo principal y el trasero.
#fml($"p.r.e." "o" "p.i.r.e." = P dot G$)[p.r.e. (o p.r.a.) con $G$ respecto al dipolo; p.i.r.e. respecto a la isótropa. #ej[100 W y 10 dBd → p.r.a. 1000 W; p.i.r.e. ≈ 1640 W (12,15 dBi).]]
- Área efectiva $A_e = lambda^2 G slash 4 pi$. La antena es *pasiva* (no amplifica) y tiene el mismo diagrama al transmitir y al recibir.

#sub[Líneas y ROE]
- Coaxial 50 Ω (75 Ω en TV); línea paralela 300–600 Ω; guiaondas: no propaga por debajo de su frecuencia de corte.
#fml($"FV" = 1 / sqrt(epsilon_r) < 1$)[factor de velocidad (0,66 en coaxial de polietileno). $L_"fís" = L_"el" dot "FV"$: el tramo físico es *menor*. #ej[λ/4 a 145 MHz = 52 cm; en coaxial: 34 cm.]]
#formula($rho = (Z_L - Z_0) / (Z_L + Z_0) #h(1.5em) "ROE" = V_"max" / V_"min" = (1 + rho) / (1 - rho)$)
$rho$ coeficiente de reflexión · $Z_L$ carga · $Z_0$ línea. #ej[50 Ω cargada con 100 Ω: $rho = 1 slash 3$, ROE = 2.] Adaptada: $rho = 0$, ROE = 1 (1:1; *nunca menor que 1*; funcionamiento correcto entre 1 y 2,5). Si TX, línea y antena tienen la misma $Z$, no hay reflejada.
#table(
  columns: (auto,) + (1fr,) * 4,
  th[ROE][1][1,5][2][3],
  [reflejada $= rho^2$], [0 %], [4 %], [11 %], [25 %],
)
#ej[100 W directa y 25 W reflejada: $rho = 0,5$, ROE 3, radia 75 W.]
#fml($Z_"tramo" = sqrt(Z_"línea" Z_"carga")$)[transformador de λ/4. #ej[50 y 150 Ω → 87 Ω.] Un λ/4 *invierte*: cortocircuito al final → circuito abierto a la entrada. Tramos abiertos o en corto = circuitos sintonizados.]
- #k[Balun]: une coaxial (asimétrico) y dipolo (simétrico). #k[Acoplador] (red π: C–L–C): adapta final, línea y antena. #k[Relé T-R]: al transmitir desconecta (a masa) la entrada del receptor; las antenas sin uso, a masa. #falstad("tlstand.txt", texto: [onda estacionaria])
#recuerda[Orden: transceptor → (lineal) → medidor de ROE → acoplador → antena.]

#tema("T7", [Propagación], [≈8 %])
#table(
  columns: (auto, auto, 1fr, auto, auto, 1fr),
  th[Banda][Frecuencia][Ondas][Banda][Frecuencia][Ondas],
  [VLF], [3–30 kHz], [miriamétr.], [LF], [30–300 kHz], [kilométr.],
  [MF], [0,3–3 MHz], [hectométr.], [HF], [3–30 MHz], [*decamétricas*],
  [VHF], [30–300 MHz], [métricas], [UHF], [0,3–3 GHz], [decimétr.],
  [SHF], [3–30 GHz], [centimétr.], [EHF], [30–300 GHz], [milimétr.],
)
#recuerda[HF = decamétricas (10–100 m). Un escalón más en frecuencia, uno menos en tamaño de onda.]
#fig(fig-ionosfera, cap: [Capas de la ionosfera (alturas sin escala) y salto. Orden desde el suelo: troposfera, estratosfera, ionosfera.])
- #k[Capas]: D solo de día; absorbe las bandas bajas (3,5 MHz: de día, menos alcance). E: esporádica-E. F: F1 y F2 de día, una sola de noche. Ciclo solar de 11 años: más manchas → mejores bandas altas.
- #k[$f_c$] (frecuencia crítica): la máxima que se refleja en incidencia vertical. $"MUF" approx f_c slash cos theta$ ($theta$ = ángulo con la vertical). Frecuencia óptima ≈ 85 % de la MUF. #ej[$f_c$ = 7 MHz, $theta$ = 60° → MUF = 14 MHz; óptima ≈ 12 MHz.] Ángulo de radiación bajo → salto más largo; entre la onda de tierra y el primer salto queda la *zona de silencio*.
#table(
  columns: (auto, 1fr),
  th[Banda][Cómo llega],
  [MF], [onda de superficie],
  [HF], [reflexión ionosférica: DX (España–Nueva Zelanda)],
  [VHF, UHF], [onda directa: horizonte radioeléctrico algo mayor que el óptico; satélites en VHF y UHF; EME en VHF y superiores; a más $f$, menos alcance],
)
#fml($d approx 4,12 (sqrt(h_1) + sqrt(h_2))$)[$d$ horizonte radioeléctrico (km) · $h_1$, $h_2$ alturas de las antenas (m). #ej[9 m y 16 m → 4,12 × 7 ≈ 29 km.]]
- #k[Especiales]: esporádica-E (VHF, en verano); aurora; meteoritos; inversión térmica y conducto (VHF y UHF); troposcatter (pérdidas grandes).
- #k[Atenuación]: siempre existe. Campo ∝ $1 slash d$; potencia ∝ $1 slash d^2$. Sube con $d$ y con $f$.
#fml($L = 32,4 + 20 log f + 20 log d$)[pérdida en espacio libre (dB) · $f$ (MHz) · $d$ (km). Doblar $f$ o $d$ cuesta 6 dB. #ej[144 MHz a 100 km → ≈ 116 dB.]]
- #k[Difracción]: la onda bordea obstáculos. #k[Ruido]: atmosférico, galáctico, térmico. #k[Fading]: variación momentánea de la intensidad. En un espectro, la frecuencia menor va a la izquierda.

#tema("T8", [Medidas], [≈8 %])
#table(
  columns: (auto, 1fr),
  th[Aparato][Cómo se usa · qué mide],
  [amperímetro], [en *serie*; $R_i$ nula],
  [voltímetro], [en *paralelo*; $R_i$ infinita],
  [óhmetro], [sin tensión y con los condensadores descargados],
  [shunt], [en paralelo con el amperímetro: amplía la escala y lo protege],
  [medidor de ROE], [el más imprescindible de la estación],
  [frecuencímetro], [la frecuencia, con precisión],
  [osciloscopio], [dominio del *tiempo*: amplitud, $T$ y $f = 1 slash T$],
  [analizador], [dominio de la *frecuencia* (espectro): portadora, bandas, armónicos],
  [generador de RF], [señal calibrada para probar etapas],
  [medidor de campo], [V/m (dBμV/m)],
  [dipmeter], [resonancia de un circuito *sin alimentarlo*],
  [carga artificial], [50 Ω no inductiva: ajustar sin radiar],
)
- #k[Polímetro]: $V$, $I$, $R$; sin _true RMS_ falla con ondas no senoidales; no mide la impedancia de una antena.
- #k[Vatímetro direccional]: potencia directa $P_d$ y reflejada $P_r$; $rho = sqrt(P_r slash P_d)$. #ej[100 W y 25 W → $rho = 0,5$ → ROE 3; radia 75 W.] Reflejada apreciable = no adaptado.
- Cifras: 1000 mW = 30 dBm · 40 dB = ×10#super[4] · 1500 mAh = 1,5 A durante una hora · S-meter: 6 dB por punto.
- Final valvular: al sintonizar, corriente de placa *mínima*. Un voltímetro de RF *no* mide la frecuencia.

#tema("T9", [Interferencia e inmunidad], [≈7 %])
- #k[Fuente, camino, víctima.] Fuentes: campo intenso, armónicos y espurias, lineal sobreexcitado. Caminos: la antena, las líneas (red, cable del altavoz) y la radiación directa.
- #k[Bloqueo]: un campo intenso satura la entrada del receptor.
- #k[Intermodulación]: dos señales fuertes en una etapa no lineal crean $2 f_1 - f_2$ y $2 f_2 - f_1$. #ej[145,0 y 145,2 MHz → 144,8 y 145,4 MHz.] +3 dB a la entrada → +9 dB de producto (es de 3.#super[er] orden).
- #k[Detección en audio]: una unión semiconductora rectifica la RF y la voz sale por el altavoz del vecino.
#table(
  columns: (auto, 1fr),
  th[Dónde][Remedio: filtrar, desacoplar, apantallar],
  [salida del TX · red], [filtro paso bajo · filtro de línea en la red],
  [cables · televisor], [ferritas y condensadores; cable blindado al altavoz · filtro de rechazo en el televisor],
  [equipo], [caja metálica estanca y a tierra (jaula de Faraday: protege en los dos sentidos)],
  [estación], [buena tierra, ROE baja, potencia mínima, marcado CE (EMC); la fibra óptica es inmune],
)
#ojo[Más potencia, más riesgo; la desadaptación y el lineal sobreexcitado interfieren. Ante una queja: revisar la propia estación y colaborar. CEM (compatibilidad electromagnética) = no molestar y no ser molestado.]

#tema("T10", [Seguridad], [≈4 %])
#table(
  columns: (auto, 1fr),
  th[Protección][Qué hace],
  [fusible], [en serie; corta sobreintensidades; siempre del *mismo calibre* (nunca mayor ni un puente)],
  [magnetotérmico], [sobrecargas y cortocircuitos],
  [diferencial (30 mA)], [detecta que la corriente de ida ≠ la de vuelta: fugas y contactos indirectos; *protege a las personas*],
  [tierra], [a *cada* chasis; resistencia mínima; sin fusible ni interruptor; terreno húmedo],
)
- Interruptor general. Tormenta: desconectar antena y equipo. Antena transmitiendo: no tocar.
- #k[Mástil] propio (no el de la antena colectiva), lejos de líneas eléctricas (más que su altura), vientos repartidos y tensos por igual, con aisladores.
- Abrir un equipo: desenchufar y descargar los condensadores.
- #k[Accidente eléctrico]: cortar la corriente primero; apartar a la víctima con un aislante; respiración artificial; no darle de beber. Pesan la intensidad, el recorrido y el tiempo: 1 mA se nota, 10–20 mA agarrota (no puedes soltar), 30 mA puede fibrilar el corazón.
- Si interfieres a la seguridad de la vida humana, al servicio móvil aeronáutico o a la ICT del edificio (antenas colectivas): *dejar de emitir*. Incendio: cortar la corriente y usar el extintor adecuado (nunca agua sobre equipos con tensión).

// =====================================================================
//  PRUEBA 2
// =====================================================================
#prueba[Prueba 2 · Normativa reglamentaria][R1–R9 · Orden IET/1311/2013 · Ley 11/2022 · 45 min · aprobado con 15]

#tema("R1", [Alfabeto fonético internacional], [])
#{
  let letras = ("Alfa", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliett", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", "Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whiskey", "X-ray", "Yankee", "Zulu")
  set text(size: 7.5pt)
  grid(columns: (1fr,) * 6, row-gutter: 3.2pt, column-gutter: 3pt,
    ..letras.map(p => [#text(font: _sans, weight: "bold", fill: col.acento, p.first())#h(1.5pt)#p]))
}
#v(1pt)
Cifras: 0 Zero · 1 One · 2 Two · 3 Three · 4 Four · 5 Five · 6 Six · 7 Seven · 8 Eight · 9 Nine. #ej[`EA5SWJ` = Echo Alfa Five Sierra Whiskey Juliett.]
#ojo[Cifras *en inglés* (Five, no «Cinco»). Juliett (no Julio ni Juliet), Quebec (no Queen), Sierra (no Santiago), November (no Nancy), Alfa (no Able), X-ray con guion. El alfabeto viejo no vale: Able, Baker, Dog, Easy, Jig, Oboe, Peter, Roger, Sugar, Tare, Uncle.]

#tema("R2 · R3", [Código Q y abreviaturas], [])
#let qtab(..pares) = table(
  columns: (auto, 1fr, auto, 1fr), stroke: none, inset: (x: 2pt, y: 1.5pt), align: left + horizon,
  fill: (x, y) => if calc.even(y) { col.gris-claro } else { none },
  ..pares.pos().map(c => c),
)
#qtab(
  `QRM`, [interferencia humana], `QRN`, [ruido atmosférico],
  `QRO`, [aumente la potencia], `QRP`, [disminuya la potencia],
  `QRQ`, [transmita más deprisa], `QRS`, [más despacio],
  `QRT`, [cese la transmisión], `QRX`, [espere, le llamaré],
  `QRV`, [estoy dispuesto], `QRU`, [no tengo nada para usted],
  `QRG`, [frecuencia exacta], `QRH`, [su frecuencia varía],
  `QRK`, [inteligibilidad], `QSA`, [fuerza de las señales],
  `QRL`, [frecuencia ocupada], `QRZ`, [¿quién me llama?],
  `QSY`, [cambie de frecuencia], `QSB`, [desvanecimiento],
  `QSL`, [acuse de recibo], `QSO`, [comunicado entre dos],
  `QTH`, [mi posición], `QTR`, [hora exacta],
  `QRA`, [nombre de la estación], `QRB`, [distancia],
)
Otros: `QRI` tono · `QTC` tengo mensajes · `QSP` retransmitir gratis · `QSK` le oigo entre mis señales · `QSM` repita el último mensaje · `QSN` le oí en… kHz · `QSD` manipulación defectuosa · `QSV` emita una serie de V · `QRW` avise a… · `QTA` anule el mensaje. Con interrogante, el código pregunta (`QRL?` = ¿está ocupada?). `CQ` *no* es código Q.
#qtab(
  `CQ`, [llamada general], `CL`, [cierre de la estación],
  `CW`, [telegrafía Morse], `DX`, [larga distancia],
  [`RPT` · `AGN`], [repita · de nuevo], `SSB`, [banda lateral única],
  [`LSB` · `USB`], [inferior · superior], `AR`, [fin de transmisión],
  `SK`, [fin del contacto], `K`, [invitación a transmitir],
  `BK`, [interrupción (_break_)], [`73` · `88`], [saludos · besos],
  `OM`, [amigo], [`YL` · `XYL`], [operadora · esposa],
  `DE`, [de (quien llama)], `R`, [recibido],
  [`RIG` · `ANT`], [equipo · antena], [`PWR` · `OP`], [potencia · operador],
  `PSE`, [por favor], [`TNX` `TKS` `TU`], [gracias],
  [`WX` · `UR`], [tiempo · su], [`HR` · `ES`], [aquí · y],
  `NIL`, [nada], `CFM`, [confirmo],
)
Otras: `ABT` aproximadamente · `VY` muy · `HI` risa · `FB` buen trabajo · `CUL` hasta luego · `GM` `GE` `GN` buenos días, tardes, noches · `MSG` mensaje · `NR` número · `BUG` manipulador semiautomático.
- #k[RST] = legibilidad (1–5), intensidad (1–9) y tono (1–9, solo en CW). #ej[59 en fonía; 599 en CW.] #k[Split]: emitir y recibir en frecuencias distintas. #k[Locator]: cuadrícula Maidenhead.

#tema("R4", [Socorro, urgencia y seguridad · bandas], [])
#table(
  columns: (auto, 1fr, 1fr, 1fr), align: (left, center, center, center),
  th[Señal][Socorro][Urgencia][Seguridad],
  [fonía ×3], [MAYDAY], [PAN PAN], [SÉCURITÉ],
  [Morse ×3], [`SOS`], [`XXX`], [`TTT`],
)
- Prioridad: socorro > urgencia > seguridad. Llamada de socorro: Mayday ×3 + «aquí» o «de» + distintivo ×3. El mensaje lleva identificación, posición y naturaleza del peligro (nunca «Sécurité»). `SOS` se emite como *un solo signo*.
- Alarma radiotelefónica: tonos alternos de *2200 y 1300 Hz*. DSC (GMDSS): *2187,5 kHz* (MF); voz: 2182 kHz.
- Si oyes un socorro: silencio y escucha. Tras emitirlo: escuchar en la misma frecuencia. Ante un peligro grave e inminente vale cualquier medio. Decir «SOS» o «Mayday» sin peligro: infracción.
- Res. 640 (RR): uso de las bandas de aficionado en socorro por catástrofe natural; colaborar es obligatorio si lo pide la autoridad.

#sub[Bandas y potencias máximas (Anexo I de la Orden; caen en R4 y R8)]
#table(
  columns: (1fr, auto),
  th[Bandas][Potencia máxima],
  [137 kHz (2200 m) · 475 kHz (630 m)], [1 W p.i.r.e.],
  [160 m 1,8 · 80 m 3,5 · 40 m 7 · 30 m 10 · 20 m 14 · 17 m 18 · 15 m 21 · 12 m 24 · 10 m 28 MHz], [*1000 W* p.c.e.],
  [6 m 50 · 4 m 70 · 2 m 144–146 MHz], [*600 W* p.c.e.],
  [70 cm 430–440 MHz], [*300 W* p.c.e.],
  [23 cm 1240–1300 · 13 cm 2300–2450 · 6 cm 5650–5850 MHz; 10 · 24 · 47 · 75–250 GHz], [*1000 W* p.i.r.e.],
)
#recuerda[p.c.e. (potencia de cresta de la envolvente) hasta 440 MHz; p.i.r.e. ($P dot G_i$) en 137 y 475 kHz y desde 23 cm.]
- 630 m: hasta 5 W p.i.r.e. a más de 800 km de los países africanos. Banda *secundaria*: ≤ 50 % de la tabla (30 m: 500 W). EME y dispersión meteórica: hasta 1000 W p.c.e. (fuera del casco urbano). Densidad de potencia de RF < 3,5 mW/cm² donde haya personas.
- #k[Autorización especial]: 2300–2450 MHz (salvo 2316–2332), 5650–5850 MHz (salvo 5700–5720 y 5760–5762) y 24,050–24,250 GHz.
- #k[Bandas ICM] (industriales, científicas y médicas; el aficionado acepta su interferencia): 433,05–434,79 MHz; 2400–2450 MHz; 5725–5800 MHz; 24,00–24,25 GHz.
- #k[Servicio secundario]: no debe interferir al primario ni puede reclamarle protección.
- Nomenclatura UIT (tabla en T7): VHF 30–300 MHz = métricas, B.m, banda nº 8; UHF = nº 9. Clases (T1): A1A CW · A3E AM · J3E BLU · F3E FM.

#tema("R5", [Distintivos de llamada], [])
#formula[`EA` #h(1pt) `5` #h(1pt) `RCA` = prefijo + distrito + sufijo (máximo 6 caracteres)]
- #k[Prefijo]: series UIT de España EA–EH y AM–AO. `EA` `EB` `EC`: individuales y colectivas. `ED`: desatendidas. #k[Temporales] (los autoriza la Jefatura Provincial):
#table(
  columns: (auto, 1fr),
  th[Prefijo][Uso temporal],
  [`ED` `EE` `EF`], [eventos de ámbito local, regional, autonómico o nacional; *mantienen* el resto del distintivo (`EA4XYZ` → `EE4XYZ`)],
  [`EG` `EH`], [concursos, eventos internacionales y eventos relevantes locales, regionales o autonómicos; sufijo propio],
  [`AM` `AN`], [eventos relevantes de ámbito *nacional*; sufijo propio],
  [`AO`], [eventos relevantes de ámbito *internacional*; sufijo propio],
)
#table(
  columns: (auto, 1fr, auto, 1fr),
  th[][Distrito][][Distrito],
  [*1*], [Galicia, Asturias, Cantabria, Castilla y León, *La Rioja*], [*6*], [*Baleares*],
  [*2*], [País Vasco, Navarra, Aragón], [*7*], [Andalucía],
  [*3*], [Cataluña], [*8*], [*Canarias*],
  [*4*], [Madrid, Castilla-La Mancha *sin Albacete*, Extremadura], [*9*], [Ceuta y Melilla],
  [*5*], [C. Valenciana, Murcia, *Albacete*], [*0*], [actos del Rey],
)
- #k[Cifra] = distrito de residencia *al otorgar* el distintivo; el 0, solo el día del acto.
- #k[Sufijo]: hasta 3 letras, por orden alfabético y turno de expedición en cada distrito (series de 1, 2 y 3 letras; desde `AAA`). *Excluidos*: `DDD` `PAN` `SOS` `TTT` `XXX` y `QAA`–`QZZ`. *Reservados*: `Y..` desatendida analógica, `Z..` digital (`ED1YBD`, `ED5ZAA`); `UR..` asociaciones; `RC..` y `RK..` radioclubes.
- #k[Sufijo de 2 letras]: ≥ 5 años de autorización, 5 de práctica internacional y 5 sin expediente sancionador. #k[De 1 letra]: lo mismo con 15 años de práctica; también para concursos internacionales de alta competitividad.
- #k[Res. 29-07-2026] (BOE-A-2026-17504; vigente desde el 19-09-2026): procedimiento ordinario para el sufijo de 1 letra. Solicitud electrónica, por distrito y por orden de presentación, con hasta 10 preferentes; la práctica se acredita con QSL (2 por año en 15 de los últimos 20); el nuevo distintivo sustituye al anterior.
- El distintivo es *único e inmodificable*. Si te mudas, *lo conservas* (solo comunicas el domicilio). Se reasigna solo agotadas todas las combinaciones, salvo al anterior titular (nueva autorización) o a familiares de 1.#super[er] grado por fallecimiento (no los de 1 letra). Temporal: una solicitud por evento a la Administración; las asociaciones solo proponen.
- #k[Identificación]: al comienzo y al final; en contactos largos, cada 10 min. Móvil o portable (opcional): en Morse `/M` `/MM` `/MA` `/P`; en fonía «móvil», «móvil marítima», «móvil aeronáutica», «portable». Opcional: el distrito desde el que se emite: `EA7/EA4KLM/M` = móvil del distrito 4 que emite en el 7.
#ojo[Banco antiguo (si sale, es su clave): «al mudarse de distrito no mantiene el distintivo». `ED` sirve para desatendidas *y* como temporal. `/P` en grafía, «portable» en fonía; no existe `/AM`; `QRP` no se añade al distintivo.]

#tema("R6 · R7", [Planes de bandas IARU · procedimientos], [])
- #k[Plan de bandas] = reparto *recomendado* de cada banda por modo y anchura (CW, fonía, digitales, balizas, repetidores, satélites; frecuencias de llamada). Es voluntario, pero la Orden lo exige «como norma general»: el de la *Región 1* para todo aficionado en España.
- 2 m: entrada de repetidores *145,000–145,1875 MHz*, salida +600 kHz. 70 cm: *433,000–433,375 MHz* (entrada; salida +1,6 MHz). Balizas: 144,400–144,491 MHz.
- Convenio: LSB por debajo de 10 MHz; USB por encima.
#ojo[50 MHz: hasta 2010 no se podía emitir desde Ávila, Guadalajara, Madrid, Segovia, Soria, Toledo y Valladolid. El banco original pide «provincia desde la que se podrá emitir» = *Almería*.]

- #k[Procedimiento (R7)]: escuchar antes de transmitir (`QRL?`). Lenguaje claro, sin cifrar. Solo temas del servicio y observaciones personales (sin publicidad, fines lucrativos ni mensajes de terceros). Deletrear con el alfabeto internacional. Decir «cambio» es recomendable, no obligatorio. Nadie es dueño de una frecuencia.

#tema("R8", [Reglamentación nacional e internacional], [])
- #k[Marco]: UIT (Reglamento de Radiocomunicaciones, RR) > CEPT > España: Ley 11/2022 (Ley General de Telecomunicaciones), *Orden IET/1311/2013* («documento fundamental»), Ley 19/1983 + RD 2623/1986 (antenas). Competencia *exclusiva del Estado* (art. 149.1.21.ª de la Constitución). CNAF = Cuadro Nacional de Atribución de Frecuencias.

#sub[Plazos y cifras que más caen]
#table(
  columns: (auto, 1fr),
  th[Trámite][Plazo o cifra],
  [resolver la solicitud], [*6 semanas*; silencio = desestimada],
  [vigencia], [hasta renuncia o revocación; no se renueva],
  [autorización experimental], [pedirla *≥ 1 mes* antes; máximo *18 meses*, ampliable],
  [uso portable], [avisar *5 días* antes; usos no continuados de *≤ 15 días naturales*: sin aviso],
  [extranjero no CEPT], [autorización temporal *≤ 90 días*],
  [licencia de estación fija], [fin de obra: comunicarlo en *6 semanas*; la Jefatura tiene *≤ 30 días*; cambios experimentales *≤ 60 días*],
  [estación desatendida], [montarla en *6 meses*; parada *> 3 meses*: cancelable],
  [comunidad de propietarios], [alega en *2 meses*; obras: aviso *≥ 1 mes* antes],
  [repetidor y baliza], [Morse *≤ 10 palabras/min* cada *≤ 10 min*; baliza: distintivo cada *≤ 3 min*; alimentación ininterrumpida *≥ 6 h*],
  [distintivo temporal], [*≤ 30 días al año* por sufijo],
)

#sub[Autorización y estaciones]
- #k[Autorización] (la da la SETSI, hoy SETID): *personal e intransferible*; exige aprobar la prueba ⇒ HAREC; se otorga *con* el distintivo; habilita a emitir en las bandas del servicio con las características del Anexo I. Se revoca por fines comerciales, publicitarios o lucrativos (no tener estación no es causa); revocada, no se emite. *No obligan*: ser socio, tener estación fija, llevar libro de registro. *Sin edad mínima* (un menor: escrito de padres o tutores). Bilingüe si se pide.
- #k[Equipo de construcción propia]: sin autorización previa, bajo responsabilidad propia (cumpliendo el Anexo I). Hay que poder comprobar la banda y medir la potencia (no la ROE).
- #k[Estación fija]: licencia *asociada a la autorización*. Se cancela a petición, al revocar la autorización o si falta el *seguro de antenas*. Cancelada: *desmontar todo, antenas incluidas, a costa del titular* (banco antiguo: mantener solo recepción con permiso de la propiedad). Individual o *colectiva* (solo asociaciones reconocidas). Las móviles y portátiles no necesitan licencia.
- #k[Trámite de la fija]: solicitud + *memoria descriptiva* (no certificado de empadronamiento) → montaje por un *instalador de telecomunicaciones* inscrito → seguro de responsabilidad civil → licencia. Cambios permanentes: documentación a la SETSI. Mover la antena = como una primera instalación.
#table(
  columns: (auto, 1fr),
  th[Estación][Qué es],
  [portable], [la fija usada temporalmente en otro sitio (sin distintivo temporal)],
  [portátil], [móvil con antena y fuente de alimentación propias],
  [móvil], [en movimiento o parada en un punto no determinado],
  [remota · digital], [fija accionada a distancia · emite con técnicas digitales],
)
- #k[Autorizaciones especiales]: art. 16, bandas con riesgo de interferir; art. 17, experimental (memoria técnica; nominativa). Si interfiere (por ejemplo, a la TV): *suspender de inmediato*.
- #k[Estación ajena]: con permiso del titular; identificarse con el *propio* distintivo (banco antiguo: el propio precedido del del titular).

#sub[CEPT, HAREC y UIT]
#recuerda[T/R 61-0#strong[1]: #strong[visito] un país ⇒ licencia CEPT. T/R 61-0#strong[2]: #strong[me instalo] ⇒ HAREC.]
- #k[Licencia CEPT] (T/R 61-01): uso *temporal* en los países que la adoptan; equivale a la autorización nacional. Consta de: declaración, nombre y dirección, distintivo, validez y autoridad que la expide (*no* la asociación ni la fecha del examen). Permite *todas las bandas* atribuidas *en el país visitado*; hay que respetar su norma y el RR, mostrarla si la piden, y no tiene protección contra interferencias perjudiciales. Identificación: *prefijo del país visitado + distintivo propio*: `EA/M0BVM`, `EA3/OK2HM`.
- #k[HAREC] (T/R 61-02): acredita conocimientos (*no autoriza a emitir*); no caduca; sustituyó al diploma de operador; para examinarse *no* hace falta. Extranjero residente en España: residencia acreditada + HAREC de un país que aplique la 61-02 (sea CEPT o no) *o* convenio de reciprocidad; sin repetir el examen.
- #k[UIT]: servicio de aficionados = instrucción individual, intercomunicación y estudios técnicos, sin lucro (por satélite: estaciones espaciales). Radiocomunicación = telecomunicación por ondas radioeléctricas. Comunicados entre países: *permitidos salvo oposición* de uno de ellos (art. 25); sin codificar.
- #k[Regiones UIT] (atribuciones distintas en cada una): *1* Europa, África, Oriente Medio y norte de Asia (*España*) · *2* América · *3* resto de Asia y Oceanía.

#sub[Antenas, estaciones desatendidas y uso]
- #k[Antenas]: derecho a instalarlas en el exterior del inmueble si se está legitimado + *autorización administrativa*; *seguro de responsabilidad civil* obligatorio. La *comunidad no autoriza ni prohíbe*: se le informa y puede alegar. Obras: desmontaje temporal *sin indemnización*; luego se reinstala. Daños de instalación, mantenimiento y desmontaje: *del titular*. Azoteas: *señalizar anclajes y riostras*; soportes que no dañen la obra, de materiales resistentes (no «endebles»); respetar las otras antenas.
#table(
  columns: (auto, 1fr),
  th[Desatendida][],
  [qué es], [estación colectiva que funciona sin operador (el repetidor amplía el alcance); solo *asociaciones reconocidas*; su número, según cobertura y canales],
  [potencia], [VHF/UHF *10 W* en casco urbano · *50 W* fuera; HF *50 W*; ganancia de antena *≤ 6 dBd*],
  [acceso], [*libre* (repetidores analógicos y digitales finales); si hay código, debe ser público],
  [baliza], [para estudios de propagación; emite identificación, posición y estado],
)
- Emisiones *sin codificar*. Tráfico de *terceros solo en emergencia o desastre*. Colaborar con Protección Civil si lo requiere y hacerle llegar cualquier petición de socorro.
- #k[Interferencia perjudicial]: cesar → medidas técnicas *a su costa* → comunicarlo y reanudar → si persiste, la SETSI restringe bandas, potencia u horario. La estación está siempre sometida a inspección.

#tema("R9", [Inspección y régimen sancionador], [])
#table(
  columns: (auto, 1fr, auto),
  th[Grado][Conducta típica del examen][Multa hasta · prescribe],
  [*muy grave* \ art. 106], [interceptar y divulgar telecomunicaciones no públicas; interferir *deliberadamente*; no atender el requerimiento de cese], [*20 M€* \ 3 años],
  [*grave* \ art. 107], [*mera* producción de interferencias; negarse a la inspección u obstruirla; no dar datos (2.º requerimiento)], [*2 M€* \ 2 años],
  [*leve* \ art. 108], [comunicarse *utilizando* estaciones no autorizadas; no facilitar datos o retrasarlos; instalar una estación sin autorización], [*100 000 €* \ 1 año],
)
- Ley 11/2022: art. 105 clasifica; 106 muy graves, 107 graves, 108 leves (más gravedad, número menor); 109 sanciones; 113 prescripción (de infracciones y de sanciones).
- Sanciones accesorias: cese, *precintado o incautación* de equipos, clausura. Reiteración (2 o más sanciones firmes en 3 años): una leve pasa a grave.
- Inspecciona y sanciona *el Estado* (Jefaturas Provinciales de Inspección de Telecomunicaciones), no las comunidades autónomas, los ayuntamientos ni las asociaciones. Los inspectores son autoridad pública.
- *No* es infracción comunicar con una estación propia ni no llevar libro de registro. *Nunca*: interferir a propósito, emitir música, publicidad o tráfico comercial, salir de banda, usar un distintivo ajeno. Portadora sin modular: solo para ensayos breves.
#ojo[Banco antiguo: la identificación falsa era infracción *grave* (Ley 9/2014). Si sale con esa opción, es la clave.]
