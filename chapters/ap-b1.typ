// Apéndice B (parte 1): preguntas complementarias de los temas T1 a T10.
// Transcripción fiel del original. Las soluciones razonadas (apéndice D, «D.20») van en `sol:`.
#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Utilidades locales (prefijo _apb1-)
// ---------------------------------------------------------------------

/// Aviso «CLAVE DE LOS BANCOS PÚBLICOS» de las soluciones (no existe macro compartida).
#let _apb1-clave(cuerpo) = clave-bancos(cuerpo)

// Iconos pequeños para diagramas de bloques
#let _apb1-ant = cetz.canvas(length: 2.6mm, {
  import cetz.draw: *
  line((0, -1.4), (0, 0), stroke: 0.7pt)
  line((-0.8, 1.0), (0, 0), (0.8, 1.0), stroke: 0.7pt)
})
#let _apb1-alt = cetz.canvas(length: 2.6mm, {
  import cetz.draw: *
  rect((0, -0.5), (0.7, 0.5), stroke: 0.7pt)
  line((0.7, 0.5), (1.5, 1.1), (1.5, -1.1), (0.7, -0.5), stroke: 0.7pt)
})
#let _apb1-mic = cetz.canvas(length: 2.6mm, {
  import cetz.draw: *
  circle((0, 0), radius: 0.6, stroke: 0.7pt, fill: white)
})
#let _apb1-etq(t) = text(size: 6pt, fill: col.gris, t)

/// Bloque rectangular de un diagrama (texto pequeño, centrado)
#let _apb1-bq(pos, txt, ..args) = node(
  pos, align(center, text(size: 6.4pt, txt)),
  shape: rect, stroke: 0.6pt + col.acento, fill: col.acento-claro, inset: 3pt, corner-radius: 1.5pt, ..args,
)

/// Receptor básico de BLU (T4.15): antena → b1 → mezclador → b3 → b4 → BF → altavoz
#let _apb1-rx(b1, b3, b4, o1, o2) = box(baseline: 60%, diagram(
  node-stroke: 0.6pt, spacing: (4.2mm, 6mm), edge-stroke: 0.6pt, mark-scale: 70%,
  node((0, 0), stack(dir: ttb, spacing: 1pt, _apb1-ant, _apb1-etq[antena]), stroke: none),
  edge((0, 0), (1, 0), "-|>"),
  _apb1-bq((1, 0), b1),
  edge((1, 0), (2, 0), "-|>"),
  _apb1-bq((2, 0), [mezclador]),
  edge((2, 0), (3, 0), "-|>"),
  _apb1-bq((3, 0), b3),
  edge((3, 0), (4, 0), "-|>"),
  _apb1-bq((4, 0), b4),
  edge((4, 0), (5, 0), "-|>"),
  _apb1-bq((5, 0), [amplificador\ BF]),
  edge((5, 0), (6, 0), "-|>"),
  node((6, 0), stack(dir: ttb, spacing: 1pt, _apb1-alt, _apb1-etq[altavoz]), stroke: none),
  _apb1-bq((2, 1), o1),
  edge((2, 1), (2, 0), "-|>"),
  ..if o2 != none { (_apb1-bq((4, 1), o2), edge((4, 1), (4, 0), "-|>")) } else { () },
))

/// Transmisor básico de BLU (T5.31): micrófono → n1 → n2 → n3 → mezclador → n5 → antena
#let _apb1-tx(n1, n2, n3, n5) = box(baseline: 60%, diagram(
  node-stroke: 0.6pt, spacing: (4.2mm, 6mm), edge-stroke: 0.6pt, mark-scale: 70%,
  node((0, 0), stack(dir: ttb, spacing: 1pt, _apb1-mic, _apb1-etq[micrófono]), stroke: none),
  edge((0, 0), (1, 0), "-|>"),
  _apb1-bq((1, 0), n1),
  edge((1, 0), (2, 0), "-|>"),
  _apb1-bq((2, 0), n2),
  edge((2, 0), (3, 0), "-|>"),
  _apb1-bq((3, 0), n3),
  edge((3, 0), (4, 0), "-|>"),
  _apb1-bq((4, 0), [mezclador]),
  edge((4, 0), (5, 0), "-|>"),
  _apb1-bq((5, 0), n5),
  edge((5, 0), (6, 0), "-"),
  node((6, 0), stack(dir: ttb, spacing: 1pt, _apb1-ant, _apb1-etq[antena]), stroke: none),
  _apb1-bq((2, 1), [oscilador]),
  edge((2, 1), (2, 0), "-|>"),
  _apb1-bq((4, 1), [oscilador\ variable]),
  edge((4, 1), (4, 0), "-|>"),
))

/// Equipos de estación (T6.21, T6.22): cada tipo con su color
#let _apb1-eq(tipo, pos) = {
  let (txt, fg, bg) = if tipo == "tx" {
    ([Transceptor], col.naranja, col.naranja-claro)
  } else if tipo == "acop" {
    ([Acoplador\ de antena], col.acento, col.acento-claro)
  } else if tipo == "roe" {
    ([Medidor\ de ROE], col.verde, col.verde-claro)
  } else if tipo == "amp" {
    ([Amplificador\ lineal], col.ambar, col.ambar-claro)
  } else {
    ([Medidor\ de campo], col.tinta, white)
  }
  node(pos, align(center, text(size: 6.6pt, txt)), shape: rect, stroke: 0.6pt + fg, fill: bg, inset: 3.5pt, corner-radius: 1.5pt, width: 19mm)
}
#let _apb1-cadena(..tipos) = {
  let ts = ("tx",) + tipos.pos()
  let n = ts.len()
  diagram(
    node-stroke: 0.6pt, spacing: (6mm, 6mm), edge-stroke: 0.6pt,
    ..ts.enumerate().map(((i, t)) => _apb1-eq(t, (i, 0))),
    ..range(n - 1).map(i => edge((i, 0), (i + 1, 0), "-")),
    edge((n - 1, 0), (n, 0), "-"),
    node((n, 0), stack(dir: ttb, spacing: 1pt, _apb1-ant, _apb1-etq[antena]), stroke: none),
  )
}

/// Conexión de chasis (T10.8): tres equipos unidos por una barra que va a `fin`
#let _apb1-chasis(fin, grueso: true) = box(baseline: 55%, cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let blk(x, t) = {
    rect((x - 0.95, 0), (x + 0.95, 0.75), stroke: 0.6pt + col.acento, fill: col.acento-claro, radius: 0.08)
    content((x, 0.375), align(center, text(size: 6.6pt, t)))
  }
  rect((-1.7, -1.9), (9.0, 1.0), stroke: none)
  blk(1.0, [Transceptor])
  blk(4.0, [Medidor\ de ROE])
  blk(7.0, [Acoplador\ de antena])
  line((1.95, 0.375), (3.05, 0.375), stroke: 0.6pt)
  line((4.95, 0.375), (6.05, 0.375), stroke: 0.6pt)
  for x in (1.0, 4.0, 7.0) {
    line((x, 0), (x, -0.75), stroke: 0.6pt)
    circle((x, -0.75), radius: 0.03, fill: black, stroke: none)
  }
  line((-0.2, -0.75), (8.2, -0.75), stroke: if grueso { 1.6pt } else { 0.6pt })
  fin
}))

// Diagramas de radiación en 3D (T6.19): suelo en gris y lóbulos en azul
#let _apb1-donut(n) = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  circle((0, 0), radius: (1.5, 0.5), stroke: 0.4pt + col.gris.lighten(40%))
  for fi in (-1.3, -0.95, -0.55, -0.2, 0, 0.2, 0.55, 0.95, 1.3) {
    let r = calc.pow(calc.cos(fi), n)
    let rho = r * calc.cos(fi)
    let h = r * calc.sin(fi)
    circle((0, 0.9 * h), radius: (1.5 * rho, 0.5 * rho), stroke: 0.5pt + col.acento)
  }
})
#let _apb1-rosa = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  circle((0, 0), radius: (1.5, 0.5), stroke: 0.4pt + col.gris.lighten(40%))
  let petalos(k, sx, sy, fase, dy) = {
    let pts = range(0, 361, step: 3).map(i => {
      let t = i * 1deg
      let r = calc.abs(calc.cos(k * t + fase))
      (sx * r * calc.cos(t), dy + sy * r * calc.sin(t))
    })
    line(..pts, stroke: 0.5pt + col.acento)
  }
  petalos(3, 1.4, 0.5, 0deg, 0)
  petalos(3, 1.0, 1.0, 30deg, 0)
  petalos(2, 1.5, 0.3, 20deg, 0)
})
#let _apb1-yagi = cetz.canvas(length: 1cm, {
  import cetz.draw: *
  circle((0, 0), radius: (1.5, 0.5), stroke: 0.4pt + col.gris.lighten(40%))
  let lobulo(x) = 0.42 * calc.pow(calc.max(0.0, calc.sin(calc.pi * x / 1.4)), 0.8)
  for x in (0.2, 0.45, 0.75, 1.05, 1.3) {
    let r = lobulo(x)
    circle((x, 0), radius: (0.1 * r + 0.03, r), stroke: 0.5pt + col.acento)
  }
  let sup = range(0, 29).map(i => (i * 0.05, lobulo(i * 0.05)))
  line(..sup, stroke: 0.5pt + col.acento)
  line(..sup.map(p => (p.at(0), -p.at(1))), stroke: 0.5pt + col.acento)
  circle((-0.2, 0), radius: 0.07, stroke: 0.5pt + col.acento)
})

// Propagación (T7.13): tierra, ionosfera y tres señales
#let _apb1-iono = cetz.canvas(length: 0.9cm, {
  import cetz.draw: *
  let cy = -7.0
  let pol(r, a) = (r * calc.cos(a), cy + r * calc.sin(a))
  // tierra
  arc(pol(7.0, 62deg), start: 62deg, stop: 118deg, radius: 7.0, stroke: 7pt + col.gris.lighten(55%))
  // ionosfera
  arc(pol(9.4, 62deg), start: 62deg, stop: 118deg, radius: 9.4, stroke: 12pt + col.acento.lighten(75%))
  // antena
  let p0 = pol(7.0, 101deg)
  let p1 = pol(7.45, 101deg)
  line(p0, p1, stroke: 0.8pt)
  // señal 1: atraviesa la ionosfera
  line(p1, (1.6, 4.9), stroke: 0.9pt + col.senal1, mark: (end: ">", fill: col.senal1, scale: 0.7))
  // señal 2: se refleja en la ionosfera
  line(p1, (0.3, 2.35), (3.5, -0.75), stroke: 0.9pt + col.naranja, mark: (end: ">", fill: col.naranja, scale: 0.7))
  // señal 3: onda de superficie
  arc(pol(7.3, 98deg), start: 98deg, stop: 66deg, radius: 7.3, stroke: 0.9pt + col.verde, mark: (end: ">", fill: col.verde, scale: 0.7))
  content((1.6, 5.4), text(size: 8pt, weight: "bold", fill: col.senal1)[1])
  content((3.9, -0.4), text(size: 8pt, weight: "bold", fill: col.naranja)[2])
  content((4.3, -1.15), text(size: 8pt, weight: "bold", fill: col.verde)[3])
  content((-2.5, 0.0), text(size: 6.6pt)[antena])
  content((0.6, -0.55), text(size: 6.6pt)[Tierra])
  content((5.6, 2.1), text(size: 7pt, fill: col.senal1)[ionosfera])
})

// Medida de potencia (T8.12): dos conmutadores, amperímetro y voltímetro
#let _apb1-pot = esquema({
  import zap: *
  import cetz.draw: *
  let tr = 0.6pt
  // pila y cable inferior
  bateria("e", (0, 3), (0, 0), label: (content: $E$, anchor: "west"))
  line((0, 0), (10.8, 0), stroke: tr)
  // conmutador izquierdo: pivote, cuchilla y dos posiciones
  line((0, 3), (1.0, 3), stroke: tr)
  circle((1.0, 3), radius: 0.05, fill: black, stroke: none)
  line((1.0, 3), (2.0, 3), stroke: 1.2pt)
  circle((2.7, 3.9), radius: 0.07, fill: white, stroke: tr)
  circle((2.7, 2.1), radius: 0.07, fill: white, stroke: tr)
  content((2.35, 3.9), text(size: 8pt, weight: "bold", fill: col.naranja)[1])
  content((2.35, 2.1), text(size: 8pt, weight: "bold", fill: col.naranja)[2])
  line((2.77, 3.9), (3.4, 3.9), stroke: tr)
  medidor("a1", (3.4, 3.9), (5.0, 3.9), letra: "A")
  line((5.0, 3.9), (5.9, 3.9), (5.9, 3.0), stroke: tr)
  line((2.77, 2.1), (3.4, 2.1), stroke: tr)
  medidor("v1", (3.4, 2.1), (5.0, 2.1), letra: "V")
  line((5.0, 2.1), (5.9, 2.1), (5.9, 3.0), stroke: tr)
  circle((5.9, 3.0), radius: 0.04, fill: black, stroke: none)
  // rama de R
  line((5.9, 3.0), (9.9, 3.0), stroke: tr)
  circle((7.2, 3.0), radius: 0.04, fill: black, stroke: none)
  resistor("r", (7.2, 3.0), (7.2, 0), label: (content: $R$, anchor: "west"))
  circle((7.2, 0), radius: 0.04, fill: black, stroke: none)
  // conmutador derecho
  circle((9.9, 3.0), radius: 0.05, fill: black, stroke: none)
  line((9.9, 3.0), (9.9, 2.3), stroke: 1.2pt)
  circle((9.1, 2.05), radius: 0.07, fill: white, stroke: tr)
  circle((10.7, 2.05), radius: 0.07, fill: white, stroke: tr)
  content((8.75, 2.2), text(size: 8pt, weight: "bold", fill: col.naranja)[1])
  content((11.05, 2.2), text(size: 8pt, weight: "bold", fill: col.naranja)[2])
  line((9.1, 1.98), (9.1, 1.6), stroke: tr)
  medidor("v2", (9.1, 1.6), (9.1, 0.4), letra: "V")
  line((9.1, 0.4), (9.1, 0), stroke: tr)
  line((10.7, 1.98), (10.7, 1.6), stroke: tr)
  medidor("a2", (10.7, 1.6), (10.7, 0.4), letra: "A")
  line((10.7, 0.4), (10.7, 0), stroke: tr)
})

#apendice("B", "Preguntas complementarias")

Este apéndice reúne las preguntas de los bancos públicos de examen que el cuaderno #emph[no] cubría
de forma obvia. Para localizarlas se recopilaron todas las preguntas que circulan públicamente
(FEDI-EA, URE, URE Valencia, Radio Club Quijotes, los libros de Radio Club Utiel y otras fuentes
menores: unas 1 390 preguntas únicas) y cada una se comparó, una por una, con las 743 preguntas del
cuaderno: si alguna probaba exactamente el mismo dato, la pregunta se consideró cubierta; si probaba
un dato distinto, entra aquí. Una segunda revisión, más estricta, confirmó la cobertura del resto.
Quedan 275 preguntas, con el mismo formato que las de los temas: cuatro opciones y solución razonada
en el apéndice de soluciones.

#block(above: 1.2em, breakable: false, {
  show table.cell.where(y: 0): set text(font: fuente-texto, weight: "regular", size: 1em)
  set text(size: 9.5pt)
  table(
    columns: (auto, 1fr),
    stroke: none,
    inset: (x: 6pt, y: 2.5pt),
    table.hline(stroke: 0.7pt),
    [*C-T6.3*], [pregunta complementaria 3 del tema T6 (la numeración es independiente de la de los temas)],
    [*NO ESTÁ EN EL TEXTO*], [recuadro de la solución: la materia no se deduce del texto del cuaderno; aquí se explica],
    [*CLAVE DE LOS BANCOS PÚBLICOS*], [aviso en las 18 preguntas donde la clave publicada en los bancos es técnica o normativamente errónea],
    [*Preguntas heredadas*], [última sección: claves que dependen de normativa ya derogada],
    table.hline(stroke: 0.7pt),
  )
})

#ojo[Las claves públicas son fiables pero no infalibles. Donde una clave del banco es errónea, la
solución da la respuesta correcta #emph[y] dice cuál es la clave publicada, para que puedas decidir
con conocimiento si la misma pregunta aparece en el examen. Para la normativa, la fuente es el texto
consolidado de la Orden IET/1311/2013 y la Ley 11/2022.]

#nota[El análisis de las diez convocatorias reales de papel (2007–2011) muestra que cada examen repetía
solo entre el 4 % y el 10 % de las preguntas de los anteriores: no era un banco cerrado y pequeño.
Por eso este apéndice no es una «lista de preguntas que van a caer», sino el resto de los
#emph[hechos] que los bancos públicos evalúan y que el cuaderno no trataba. Lo que debe quedarte, al
terminarlo, es el dato y su porqué, no la letra.]

== Tema T1. Teoría de la electricidad, el electromagnetismo y la radio <apb1-t1>

#q("C-T1.1", "c",
  [En la teoría de electricidad, un ohmio equivale a:],
  (
    [1 amperio × 1 voltio],
    [1 amperio × 1 segundo],
    [1 voltio / 1 amperio],
    [1 amperio / 1 voltio],
  ),
  sol: [
    De la ley de Ohm, $V = I · R$, se despeja $R = V slash I$: un ohmio es la resistencia que deja
    pasar 1 A cuando se le aplica 1 V, es decir, 1 Ω = 1 V/1 A. Las otras opciones son unidades
    distintas: amperio × voltio es un vatio ($P = V · I$), amperio × segundo es un culombio (carga
    eléctrica) y amperio/voltio es la inversa del ohmio, la conductancia (siemens, antes «mho»).
    #vease[(Véase tema T1, sección «Unidades y leyes fundamentales».)]
  ],
)

#q("C-T1.2", "d",
  [La unidad de medida de intensidad eléctrica es el:],
  (
    [voltio],
    [vatio],
    [ohmio],
    [amperio],
  ),
  sol: [
    La intensidad de corriente es la carga que circula por unidad de tiempo, $I = q slash t$, y se
    mide en amperios: 1 A = 1 C/s. Las demás opciones son unidades de otras magnitudes: el voltio
    mide la tensión (diferencia de potencial), el vatio la potencia y el ohmio la resistencia.
    #vease[(Véase tema T1, sección «Unidades y leyes fundamentales».)]
  ],
)

#q("C-T1.3", "d",
  [La velocidad de propagación de las ondas electromagnéticas en el vacío es:],
  (
    [creciente],
    [decreciente],
    [directamente proporcional a la frecuencia de las ondas],
    [constante],
  ),
  sol: [
    En el vacío todas las ondas electromagnéticas, sea cual sea su frecuencia, viajan a la misma
    velocidad: $c ≈ 300.000$ km/s, la de la luz. No aumenta ni disminuye y no depende de la
    frecuencia. Lo que cambia con la frecuencia es la longitud de onda: como $c = λ f$, si $f$ sube,
    $λ$ baja en la misma proporción y el producto sigue valiendo $c$. Por eso la velocidad no puede
    ser proporcional a la frecuencia. #vease[(Véase tema T1, sección «Ondas y señales».)]
  ],
)

#q("C-T1.4", "d",
  [La velocidad de propagación de las ondas electromagnéticas:],
  (
    [en el vacío es menor que a través del aire],
    [aumenta con la frecuencia],
    [disminuye con la frecuencia],
    [es constante en un determinado medio],
  ),
  sol: [
    En un medio dado la velocidad de propagación es fija y, en los medios habituales en radio, no
    depende de la frecuencia: lo que varía al cambiar $f$ es la longitud de onda ($v = λ f$), no la
    velocidad. Por eso fallan b y c. La opción a es falsa porque el vacío es el medio en que las
    ondas van más rápido ($c ≈ 300.000$ km/s); en el aire la velocidad es prácticamente la misma,
    algo menor, nunca mayor. #vease[(Véase tema T1, sección «Ondas y señales»; factor de velocidad
    en tema T6, sección «Líneas de transmisión y adaptación».)]
    #no-esta[La velocidad de una onda electromagnética depende del medio, no de la frecuencia: en el vacío
    vale $c = 3 × 10^8$ m/s y en cualquier material es menor, $v = c slash n$, con $n ≥ 1$ el índice
    de refracción. En el aire $n ≈ 1,0003$, de modo que se toma $c$. En una línea de transmisión el
    cociente $v slash c$ es el factor de velocidad (0,66 en coaxial con polietileno). Con $v$ fija
    en el medio, la longitud de onda sigue a la frecuencia: $λ = v slash f$.]
  ],
)

#q("C-T1.5", "c",
  [En un circuito eléctrico de corriente continua:],
  (
    [la intensidad está en razón inversa a la tensión],
    [la resistencia es variable con la tensión],
    [la intensidad está en razón directa a la tensión],
    [la capacidad del circuito disminuye],
  ),
  sol: [
    Por la ley de Ohm, $I = V slash R$: con la resistencia constante, la intensidad es directamente
    proporcional a la tensión (si $V$ se duplica, $I$ se duplica). «Razón directa» significa eso, y
    la opción a dice justo lo contrario. La b es falsa: en un conductor óhmico la resistencia
    depende del material y de sus dimensiones ($R = ρ l slash S$), no de la tensión aplicada. La d
    no guarda relación con la pregunta. #vease[(Véase tema T1, sección «Unidades y leyes
    fundamentales».)]
  ],
)

#q("C-T1.6", "d",
  [La unidad de potencia eléctrica es:],
  (
    [el amperio],
    [el voltio],
    [el decibelio],
    [el vatio],
  ),
  sol: [
    La potencia eléctrica se mide en vatios (W): $P = V · I$, de modo que 1 W = 1 V × 1 A (equivale
    a un julio por segundo). El amperio es la unidad de intensidad y el voltio la de tensión. El
    decibelio no es una unidad de potencia, sino una forma logarítmica de comparar dos valores de
    una misma magnitud (solo con una referencia, dBW o dBm, expresa una potencia). #vease[(Véase
    tema T1, secciones «Unidades y leyes fundamentales» y «Potencia, decibelios y DSP».)]
    #no-esta[La potencia es la energía entregada o consumida por unidad de tiempo. Su unidad es el vatio (W):
    1 W = 1 julio por segundo = 1 voltio × 1 amperio. Múltiplos de uso corriente: el milivatio (mW,
    $10^(−3)$ W) y el kilovatio (kW, $10^3$ W). Resumen de unidades básicas: corriente, amperio (A);
    tensión, voltio (V); resistencia, ohmio (Ω); potencia, vatio (W); frecuencia, hercio (Hz).]
  ],
)

#q("C-T1.7", "c",
  [Para medir la intensidad del campo eléctrico se utilizan unidades de:],
  (
    [dBV],
    [dBW],
    [dBV/m],
    [dBW/m#super[2]],
  ),
  sol: [
    La intensidad de campo eléctrico es tensión por unidad de longitud y se mide en voltios por
    metro (V/m). En escala logarítmica, en decibelios referidos a una tensión por metro, resulta
    dBV/m (en la práctica se usa sobre todo dBμV/m, referido a 1 μV/m). Las demás opciones miden
    otras magnitudes: dBV es un nivel de tensión (sin «por metro»), dBW un nivel de potencia y
    dBW/m#super[2] una densidad de potencia (potencia por unidad de superficie). #vease[(Véase tema
    T1, sección «Potencia, decibelios y DSP»; medidor de campo en tema T8, sección «Instrumentos».)]
    #no-esta[Un decibelio con sufijo expresa un valor absoluto respecto de una referencia: dBW (1 W) y dBm (1
    mW) para potencia, dBV (1 V) para tensión, dBV/m (1 V/m) y dBμV/m (1 μV/m) para campo eléctrico.
    Como el campo es proporcional a una tensión, se usa $20 log_10$. La densidad de potencia
    (W/m#super[2]) es otra magnitud: se relaciona con el campo por $S = E^2 slash 377$, con $E$ en
    V/m.]
  ],
)

#q("C-T1.8", "a",
  [El decibelio es una unidad de medida utilizada para:],
  (
    [la comparación de niveles de potencia eléctrica],
    [medidas de reactancia],
    [comparar las frecuencias de dos circuitos],
    [comprobar la disipación de placa de una válvula],
  ),
  sol: [
    El decibelio expresa, en escala logarítmica, la relación entre dos valores de una misma
    magnitud, sobre todo de potencia: $G ("dB") = 10 log_10 (P_2 slash P_1)$. Sirve para comparar
    niveles de potencia: ganancias, atenuaciones y pérdidas. La reactancia se mide en ohmios, la
    frecuencia en hercios y la disipación de placa de una válvula en vatios; ninguna se mide en
    decibelios. #vease[(Véase tema T1, sección «Potencia, decibelios y DSP».)]
  ],
)

#q("C-T1.9", "a",
  [Una característica de la corriente alterna es su:],
  (
    [frecuencia],
    [conductividad],
    [valor uniforme],
    [velocidad de propagación],
  ),
  sol: [
    Una corriente alterna cambia de valor y de sentido de forma periódica, y lo que la caracteriza
    es su frecuencia: el número de ciclos que completa por segundo, en hercios (junto con su
    amplitud). Los distractores no sirven: la conductividad es una propiedad del material, no de la
    corriente; un valor uniforme (constante) es lo propio de la corriente continua, y la velocidad
    de propagación es una magnitud de las ondas en un medio. En la variante «la característica más
    importante», las otras opciones (aplicación, procedencia, finalidad) describen su uso, no la
    señal. #vease[(Véase tema T1, sección «Ondas y señales».)]
  ],
)

#q("C-T1.10", "b",
  [Las reactancias inductiva y capacitiva tienen propiedades:],
  (
    [similares],
    [opuestas],
    [alternativas],
    [poco fiables],
  ),
  sol: [
    Bobina y condensador se comportan de forma opuesta. $X_L = 2π f L$ crece con la frecuencia y
    $X_C = 1 slash (2π f C)$ disminuye. La corriente retrasa 90° respecto a la tensión en la bobina
    y la adelanta 90° en el condensador. Y puestas en serie, sus efectos se restan: cuando
    $X_L = X_C$ se anulan, que es la resonancia. «Similares» es falso, y «alternativas» y «poco
    fiables» no describen ninguna propiedad de una reactancia. #vease[(Véase tema T2, secciones
    «Condensadores» y «Bobinas»; resonancia en tema T3, sección «Asociación de componentes y
    resonancia».)]
  ],
)

#q("C-T1.11", "d",
  [La fuerza electromotriz de un generador se mide en:],
  (
    [ohmios],
    [vatios],
    [kilovatios],
    [voltios],
  ),
  sol: [
    La fuerza electromotriz (fem) es la energía que el generador da a cada unidad de carga, es
    decir, julios por culombio, que son voltios: se mide en voltios (V), como toda tensión. Aunque
    el nombre lleve la palabra «fuerza», no se mide en newtons. El ohmio es la unidad de
    resistencia; el vatio y el kilovatio (mil vatios) lo son de potencia. #vease[(Véase tema T1,
    secciones «Unidades y leyes fundamentales» y «Fuentes y energía».)]
  ],
)

#q("C-T1.12", "d",
  [Entre los siguientes materiales, es buen conductor:],
  (
    [papel seco],
    [vidrio],
    [agua destilada],
    [mercurio],
  ),
  sol: [
    Un buen conductor tiene abundantes electrones libres, como los metales, y el mercurio es un
    metal (líquido a temperatura ambiente). El papel seco y el vidrio son aislantes. El agua
    destilada, al no llevar sales disueltas, apenas tiene iones que transporten carga y conduce muy
    mal; el agua corriente sí conduce algo por las sales que contiene. #vease[(Véase tema T1,
    sección «Unidades y leyes fundamentales» (conductor, aislante y semiconductor).)]
    #no-esta[Por su conductividad, los materiales se clasifican en conductores (metales como la plata, el
    cobre, el oro, el aluminio o el mercurio, con electrones libres en abundancia), aislantes o
    dieléctricos (vidrio, porcelana, papel seco, plásticos, aire seco), casi sin cargas móviles, y
    semiconductores (silicio, germanio). La plata es el mejor conductor, seguida del cobre; el
    mercurio conduce peor que ellos, pero sigue siendo un metal conductor.]
  ],
)

#q("C-T1.13", "a",
  [La resistencia eléctrica de un conductor es la resistencia que ofrece:],
  (
    [a dejar pasar la corriente eléctrica],
    [a doblarse],
    [a calentarse],
    [a disponerlo en forma de espiral],
  ),
  sol: [
    La resistencia eléctrica mide la oposición de un conductor al paso de la corriente:
    $R = V slash I$, en ohmios, y en un hilo $R = ρ l slash S$. Cuanto mayor es, menos corriente
    circula con la misma tensión. Doblarse, enrollarse en espiral o calentarse no definen la
    resistencia; el calentamiento es una consecuencia del paso de la corriente (efecto Joule), no su
    definición. #vease[(Véase tema T1, sección «Unidades y leyes fundamentales».)]
  ],
)

#q("C-T1.14", "a",
  [Se define la corriente eléctrica diciendo que es:],
  (
    [la circulación de cargas eléctricas],
    [la iluminación que da una lámpara eléctrica],
    [la fuerza electromotriz del generador que produce la corriente],
    [el calor que produce al pasar por una estufa],
  ),
  sol: [
    La corriente eléctrica es el movimiento ordenado de cargas eléctricas (electrones, en un metal).
    Su intensidad es la carga que pasa por segundo, $I = q slash t$, y se mide en amperios. La luz
    de una lámpara y el calor de una estufa son efectos de la corriente, no su definición, y la
    fuerza electromotriz es la causa: el empuje que el generador aporta a las cargas para que
    circulen. #vease[(Véase tema T1, sección «Unidades y leyes fundamentales».)]
  ],
)

#q("C-T1.15", "b",
  [El número de veces por segundo que una corriente alterna completa un ciclo recibe el nombre de:],
  (
    [elongación],
    [frecuencia],
    [longitud de onda],
    [período],
  ),
  sol: [
    Es la frecuencia: $f$ ciclos por segundo, medida en hercios (1 Hz = 1 ciclo/s). El período es la
    magnitud inversa, el tiempo que dura un ciclo ($T = 1 slash f$); la longitud de onda es la
    distancia que avanza la onda en un ciclo ($λ = c slash f$), y la elongación es el valor
    instantáneo de la señal en cada momento, su separación respecto del cero. #vease[(Véase tema T1,
    sección «Ondas y señales».)]
  ],
)

#q("C-T1.16", "a",
  [Se dice que una pila se ha polarizado cuando:],
  (
    [su resistencia interna es muy grande],
    [tiene dos polos],
    [sus polos se hacen positivos y negativos],
    [cambia de polaridad],
  ),
  sol: [
    En una pila seca, la corriente que entrega libera hidrógeno sobre el electrodo positivo; las
    burbujas forman una película aislante que hace crecer mucho la resistencia interna y hunde la
    tensión en bornes ($V = ϵ −I r$). A eso se llama polarizarse, luego la correcta es la a. «Tiene
    dos polos» lo cumple toda pila, polarizada o no, y que sus polos sean positivo y negativo es su
    estado normal; la polaridad no se invierte. El banco da por buena la b: es un error de clave,
    corregido. #vease[(Véase tema T1, sección «Fuentes y energía» (fem y resistencia interna).)]
    #no-esta[La polarización de una pila es un fenómeno electroquímico. En la pila seca de zinc-carbono la
    reacción libera hidrógeno en el electrodo positivo (el carbón). Si no se elimina, el gas lo
    recubre, reduce su superficie útil y sube la resistencia interna $r$: con la misma carga, la
    tensión en bornes baja. Se combate con un despolarizante (dióxido de manganeso), que consume el
    hidrógeno según se forma. No debe confundirse con la polarización de una onda ni con la
    polaridad (positivo y negativo) de los bornes.]
    #_apb1-clave[«Tiene dos polos». Es la clave que dan las recopilaciones de exámenes reales (2007–2011):
    conviene conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea
    la técnicamente correcta.]
  ],
)

#q("C-T1.17", "b",
  [Las pilas se asocian en paralelo para:],
  (
    [Aumentar la diferencia de potencial en el circuito],
    [Aumentar la intensidad que circula por el circuito],
    [Disminuir su capacidad],
    [Aumentar su resistencia],
  ),
  sol: [
    Al conectar pilas iguales en paralelo todas comparten los mismos bornes: la tensión del conjunto
    es la de una sola pila, pero las corrientes que entrega cada una se suman y las capacidades en
    amperios-hora también. Por eso se paralelan para disponer de más intensidad (o de la misma
    durante más tiempo). Aumentar la diferencia de potencial es lo que se logra en serie, donde se
    suman las tensiones. En paralelo la capacidad crece y la resistencia interna equivalente baja,
    así que c) y d) son lo contrario de lo que ocurre. #vease[(Véase tema T1, sección «Fuentes y
    energía».)]
  ],
)

#q("C-T1.18", "c",
  [La diferencia entre un acumulador y una pila es:],
  (
    [Que el acumulador acumula energía],
    [Que la pila se descarga],
    [Que el acumulador se carga],
    [Que el acumulador no se descarga],
  ),
  sol: [
    Pila y acumulador guardan energía química y la transforman en eléctrica; lo que los distingue es
    que la reacción del acumulador es reversible: si se le hace pasar corriente en sentido inverso
    se recarga y puede volver a usarse, mientras que la pila no es recargable y se desecha al
    agotarse. Las demás opciones no separan a unos de otros: las dos almacenan energía, las dos se
    descargan al alimentar un circuito, y afirmar que el acumulador no se descarga es falso.
    #no-esta[Una #strong[pila] (célula primaria) produce electricidad mediante una reacción química
    irreversible: cuando se agota, se tira. Un #strong[acumulador] (célula secundaria, o batería
    recargable) usa una reacción reversible: conectado a un cargador, la corriente inversa regenera
    los reactivos y vuelve a estar disponible. Ejemplos: alcalinas y zinc-carbono (pilas);
    plomo-ácido, NiMH e ion-litio (acumuladores). En el habla corriente «batería» se usa para ambos,
    pero en rigor es un conjunto de celdas asociadas.]
  ],
)

#q("C-T1.19", "d",
  [Cuando se habla del colector nos referimos a:],
  (
    [Una pila],
    [Una batería],
    [Un acumulador],
    [Una dinamo],
  ),
  sol: [
    El colector es una parte de la dinamo (generador de corriente continua): el cilindro de láminas
    de cobre aisladas entre sí (delgas) sobre el que rozan las escobillas. En la bobina del rotor se
    induce una tensión alterna; el colector invierte las conexiones cada media vuelta y por las
    escobillas sale una tensión de un solo sentido. Pilas, baterías y acumuladores son fuentes
    químicas sin partes móviles, y no tienen colector. No lo confundas con el colector del
    transistor, que es uno de sus tres electrodos.
    #no-esta[Una #strong[dinamo] transforma energía mecánica en eléctrica (corriente continua) por inducción
    de Faraday: una espira que gira en un campo magnético genera una tensión alterna. El
    #strong[colector] (o conmutador) es el cilindro de delgas de cobre unido al eje; las
    #strong[escobillas] de carbón, fijas, lo rozan y recogen la corriente. Al cambiar cada media
    vuelta la delga con la que contactan, la salida mantiene siempre la misma polaridad. La palabra
    tiene otro sentido en electrónica (el colector del transistor), pero aquí se refiere a la
    máquina.]
  ],
)

#q("C-T1.20", "c",
  [Para que un electroimán almacene energía:],
  (
    [Es necesario aplicarle solamente corriente alterna],
    [Necesita una resistencia en paralelo],
    [Basta con pasar una corriente continua],
    [Hay que añadirle un condensador],
  ),
  sol: [
    Un electroimán es una bobina (normalmente con núcleo de hierro) y, como toda bobina, guarda
    energía en el campo magnético que crea la corriente que la recorre: $E = 1/2 L I^2$. Basta con
    hacer circular una corriente continua; mientras circula, el campo y la energía se mantienen. No
    hace falta alterna ni una resistencia en paralelo, y el condensador almacena energía en un campo
    eléctrico, no magnético, por lo que nada aporta a un electroimán. #vease[(Véase tema T2, sección
    «Bobinas».)]
  ],
)

#q("C-T1.21", "d",
  [La unidad de potencia eléctrica se denomina:],
  (
    [Amperio],
    [Ohmio],
    [Faradio],
    [Vatio],
  ),
  sol: [
    La potencia eléctrica se mide en vatios (W): como $P = V · I$, un vatio es la potencia de 1 V
    por 1 A, o también un julio por segundo. Las otras unidades pertenecen a otras magnitudes: el
    amperio mide la intensidad de corriente, el ohmio la resistencia y el faradio la capacidad.
    #vease[(Véase tema T1, sección «Unidades y leyes fundamentales».)]
  ],
)

#q("C-T1.22", "b",
  [Al flujo de electrones que circula por un conductor se le llama:],
  (
    [Fuerza electromotriz],
    [Corriente eléctrica],
    [Diferencia de potencial],
    [Electricidad estática],
  ),
  sol: [
    El movimiento ordenado de cargas (aquí, electrones) por un conductor es la corriente eléctrica,
    que se mide en amperios: $I = "d"q slash "d"t$, un culombio por segundo. La fuerza electromotriz
    y la diferencia de potencial no son flujo, sino la energía por unidad de carga que empuja a los
    electrones (la causa, no el movimiento) y se miden en voltios. La electricidad estática es lo
    contrario: cargas acumuladas en reposo. #vease[(Véase tema T1, sección «Unidades y leyes
    fundamentales».)]
  ],
)

#q("C-T1.23", "c",
  [La tensión de alimentación suministrada comúnmente es de 220 V, que es el valor:],
  (
    [Máximo de la tensión],
    [Medio de la tensión],
    [Eficaz de la tensión],
    [Trifásico de la tensión],
  ),
  sol: [
    La tensión de red se da por su valor eficaz: el de la continua que produciría en una resistencia
    el mismo calor. Los voltímetros de alterna miden valor eficaz, y los 220 V de la red doméstica
    lo son. El valor máximo (de pico) es mayor: $220 sqrt(2) ≈ 311$ V. El valor medio de una
    sinusoide completa es cero, porque las dos semiondas se anulan. «Trifásico» no es un valor de la
    tensión, sino un tipo de sistema de distribución con tres fases. #vease[(Véase tema T1, sección
    «Ondas y señales».)]
    #no-esta[El texto define el valor eficaz pero no dice que la red lo use. Toda tensión de red se
    especifica en valor eficaz: la nominal oficial es 230 V (antes 220 V). Como
    $V_("ef") = V_0 slash sqrt(2)$, el pico es $V_0 = V_("ef") sqrt(2)$: unos 311 V para 220 V y 325
    V para 230 V, y la tensión de pico a pico es el doble. Se prefiere el valor eficaz porque así la
    potencia en una resistencia se calcula con las mismas fórmulas que en continua.]
  ],
)

#q("C-T1.24", "a",
  [Un miliohmio equivale a:],
  (
    [0,001 Ω],
    [1000 Ω],
    [0,001 MΩ],
    [0,001 kΩ],
  ),
  sol: [
    El prefijo «mili» (m) significa una milésima, $10^(−3)$: 1 mΩ = 0,001 Ω. Las demás opciones son
    múltiplos: 1000 Ω es 1 kΩ (kilo = mil); 0,001 MΩ son $0,001 × 10^6 = 1000$ Ω (mega = millón); y
    0,001 kΩ son 0,001 × 1000 = 1 Ω. #vease[(Véase tema T1, sección «Unidades y leyes
    fundamentales».)]
    #no-esta[El texto usa mA, mV o mW y trata kilo y mega, pero no enumera los prefijos. Los del SI que hay
    que saber: mili (m) $= 10^(−3)$, micro $(μ) = 10^(−6)$, nano (n) $= 10^(−9)$, pico (p)
    $= 10^(−12)$; kilo (k) $= 10^3$, mega (M) $= 10^6$, giga (G) $= 10^9$. Para convertir, se
    multiplica por la potencia de diez del prefijo: 1 kΩ $= 10^3$ Ω equivale a un millón de
    miliohmios. Ojo con las mayúsculas: m = mili, M = mega.]
  ],
)

#q("C-T1.25", "b",
  [Di cuál es la sentencia correcta:],
  (
    [Una señal con modulación digital se obtiene al aplicar una señal analógica a un convertidor A/D.],
    [Una modulación digital se obtiene al aplicar una señal digital sobre un modulador digital.],
    [Una señal radio con modulación digital se obtiene poniendo un convertidor A/D a continuación de
un modulador analógico.],
    [Una señal analógica se obtiene al aplicar una señal radio con modulación digital sobre un
convertidor D/A.],
  ),
  sol: [
    En la modulación digital la moduladora es una señal digital (un tren de símbolos o bits) que
    actúa sobre la portadora en un modulador digital (FSK, PSK, QAM…): de ahí sale la señal de
    radio. Un convertidor A/D solo muestrea y cuantifica una señal analógica y entrega números; no
    modula ninguna portadora, por lo que a) y c) son falsas. La d) invierte el proceso: un
    convertidor D/A recupera una señal analógica a partir de datos digitales, no directamente de una
    señal de radio, que antes habría que demodular. #vease[(Véase tema T1, sección «Señales
    moduladas».)]
  ],
)

#q("C-T1.26", "c",
  [Di qué expresión convierte la potencia expresada en vatios a potencia expresada en dBm.],
  (
    [$P ("dBm") = (log P ("W")) / 10$],
    [$P ("dBm") = 10 − 3 · log P ("W")$],
    [$P ("dBm") = 10 · log lr([ (P ("W")) / 10^(−3) ])$],
    [$P ("dBm") = log lr([ (P ("W")) / 10 ])$],
  ),
  sol: [
    El dBm es el decibelio referido a 1 mW: $P ("dBm") = 10 log P / (10^(−3) "W")$. Es la opción c)
    (en el banco público aparece con el exponente perdido, «10 - 3»). Compruébala con $P = 1$ W:
    $10 log 1 / 10^(−3) = 10 log 1000 = 30$ dBm, valor que ya conoces. Las demás fallan esa prueba:
    a) da 0, b) da 10 y d) da −1; en a) y d) falta además el factor 10 propio del decibelio de
    potencia. #vease[(Véase tema T1, sección «Potencia, decibelios y DSP».)]
  ],
)

#q("C-T1.27", "d",
  [Cuando dos bobinados tienen sus espiras en la misma dirección:],
  (
    [Sus capacidades se suman.],
    [Sus inducciones se restan.],
    [Sus capacidades se restan.],
    [Sus inducciones se suman.],
  ),
  sol: [
    Dos bobinados arrollados en el mismo sentido y acoplados magnéticamente (conectados en serie)
    producen flujos que se refuerzan: las inducciones se suman, y la inductancia del conjunto es
    $L = L_1 + L_2 + 2M$, con $M$ la inductancia mutua. Si los sentidos fueran opuestos, los flujos
    se oponen y las inducciones se restarían ($L_1 + L_2 − 2M$), lo que descarta b). La capacidad es
    propiedad de los condensadores y no depende del sentido de arrollamiento, así que a) y c) no
    tienen sentido. #vease[(Véase tema T2, sección «Transformadores».)]
    #no-esta[Dos bobinas cercanas comparten parte de su flujo: es la #strong[inductancia mutua] $M$ (en
    henrios). Conectadas en serie con sus arrollamientos en el mismo sentido (flujos que se suman,
    conexión aditiva), $L = L_1 +L_2 +2M$; con sentidos opuestos (conexión sustractiva),
    $L = L_1 + L_2 − 2M$. Si están lejos o apantalladas ($M ≈ 0$), simplemente $L = L_1 +L_2$. Es el
    mismo principio del transformador: dos bobinas acopladas por un flujo común.]
  ],
)

#q("C-T1.28", "a",
  [Si un usuario tiene contratado un acceso a Internet «ADSL de 2 megas», esto significa que:],
  (
    [Dispone de un ancho de banda de 2 millones de bits por segundo.],
    [Tiene garantizada una velocidad mínima real de 2 Mbps en todo momento.],
    [Puede transmitir datos a una velocidad constante de 2 MHz.],
    [Dispone de una velocidad de descarga de 2 megabytes por segundo.],
  ),
  sol: [
    «2 megas» es la denominación comercial de 2 megabits por segundo (2 Mbps), es decir, 2 millones
    de bits por segundo; en este sentido informal, «ancho de banda» es la capacidad del enlace en
    bit/s (en rigor se mide en hercios). La b) es falsa: ADSL anuncia una velocidad máxima
    («hasta»), no garantizada, que depende de la distancia a la central y del estado de la línea. La
    c) es absurda: los MHz miden frecuencia, no velocidad de datos. La d) confunde bits con bytes: 2
    Mbps son 2/8 = 0,25 MB/s. #vease[(Véase tema T1, sección «Señales moduladas».)]
    #no-esta[Conviene no mezclar tres magnitudes: la #strong[velocidad binaria], en bit/s (1 Mbps $= 10^6$
    bit/s); el #strong[ancho de banda], en hercios, que es la anchura de espectro que ocupa la
    señal; y la #strong[cantidad de datos], en bytes (1 byte = 8 bits). En la jerga comercial, «2
    megas» son 2 Mbps y «ancho de banda» se usa como sinónimo de velocidad. Para pasar de Mbps a
    MB/s se divide entre 8. El ADSL es asimétrico: baja más velocidad de bajada que de subida.]
  ],
)

#q("C-T1.29", "d",
  [En un circuito con varias baterías conectadas en paralelo:],
  (
    [La corriente disponible disminuye.],
    [La tensión del conjunto es cero.],
    [La tensión total se suma.],
    [La resistencia interna equivalente del conjunto disminuye.],
  ),
  sol: [
    Con baterías iguales en paralelo la tensión del conjunto es la de una sola (no se suma, lo que
    descarta c; y desde luego no es cero, b), mientras que las corrientes de cada una se suman: la
    corriente disponible aumenta, no disminuye, y así se descarta a). Cada batería tiene una
    resistencia interna $r$ y las de $n$ baterías iguales quedan en paralelo, luego
    $r_("eq") = r slash n$: la resistencia interna equivalente disminuye, y la tensión cae menos al
    pedir corriente. #vease[(Véase tema T1, sección «Fuentes y energía».)]
    #no-esta[Cada batería real es una fuerza electromotriz $ϵ$ en serie con una resistencia interna $r$. Con
    $n$ baterías iguales en paralelo, las fems no se suman (los bornes son comunes) y las
    resistencias internas se asocian en paralelo: $r_("eq") = r slash n$. Ejemplo: 4 baterías de 1,5
    V y 0,5 Ω dan 1,5 V con 0,125 Ω y pueden entregar cuatro veces la corriente con la misma caída
    de tensión interna. En serie ocurre lo contrario: se suman las fems y también las resistencias
    internas.]
  ],
)

#q("C-T1.30", "b",
  [En electricidad, la letra $Z$ corresponde a:],
  (
    [Tensión.],
    [Impedancia.],
    [Resistencia.],
    [Reactancia.],
  ),
  sol: [
    $Z$ es el símbolo de la impedancia: lo que oponen a la corriente alterna la resistencia y las
    reactancias del circuito, en ohmios, $Z = V slash I$. En serie, $Z = sqrt(R^2 + X^2)$. Los demás
    símbolos son otros: la tensión es $V$ (o $E$), la resistencia $R$ y la reactancia $X$ (con $X_L$
    y $X_C$ para la inductiva y la capacitiva). #vease[(Véase tema T3, sección «Asociación de
    componentes y resonancia».)]
  ],
)

#q("C-T1.31", "b",
  [¿Qué tipo de comunicación ocupa un mayor ancho de banda?],
  (
    [Telegrafía],
    [Frecuencia modulada],
    [Amplitud modulada],
    [Banda lateral única],
  ),
  sol: [
    Hay que comparar las anchuras típicas: la telegrafía (CW) ocupa, como mucho, unos cientos de
    hercios según la velocidad de manipulación; la banda lateral única (SSB), unos 2,7 kHz; la AM de
    voz, $2f_m ≈ 6$ kHz, el doble que la SSB porque lleva dos bandas laterales; y la FM de banda
    estrecha (la de VHF), unos 12 kHz, según la regla de Carson, $B ≈ 2(Δ f + f_m)$. La FM es, pues,
    la que más ancho ocupa (la FM de radiodifusión llega a unos 200 kHz). #vease[(Véase tema T1,
    sección «Señales moduladas».)]
  ],
)

#q("C-T1.32", "c",
  [Un motor eléctrico funciona a 220 V y consume 10 A. ¿Cuál es su potencia eléctrica aproximada?],
  (
    [220 W],
    [22 W],
    [2.200 W],
    [22.000 W],
  ),
  sol: [
    La potencia eléctrica es el producto de la tensión por la intensidad: $P = V ·I = 220$ V × 10 A =
    2200 W. Las demás cifras son errores típicos: 220 W corresponde a 1 A, 22 W sale de dividir 220
    entre 10 en vez de multiplicar, y 22.000 W exigiría 100 A. El resultado es aproximado porque no
    tiene en cuenta el factor de potencia del motor, ni es la potencia mecánica del eje, menor por
    el rendimiento. #vease[(Véase tema T1, sección «Unidades y leyes fundamentales».)]
  ],
)

== Tema T2. Componentes <apb1-t2>

#q("C-T2.1", "d",
  [En un circuito electrónico, un transistor no se puede emplear como:],
  (
    [Amplificador.],
    [Oscilador.],
    [Mezclador.],
    [Balun.],
  ),
  sol: [
    El balun es un transformador (o un tramo de línea) que une una línea asimétrica, como el
    coaxial, con una antena simétrica: es un elemento pasivo, sin ganancia, y un transistor no puede
    hacer ese trabajo. En cambio, el transistor amplifica (su empleo principal), oscila si se le
    realimenta con un circuito resonante y mezcla dos señales; el FET también funciona como
    mezclador. Por eso solo la opción d no es un uso del transistor. #vease[(Véase tema T6, sección
    «Líneas de transmisión y adaptación» (balun); tema T3, sección «Filtros, osciladores y
    mezcladores»; tema T2, sección «Semiconductores y otros componentes».)]
  ],
)

#q("C-T2.2", "b",
  [Una relación de transformación de un transformador es el cociente que resulta de dividir:],
  (
    [La tensión en el secundario por la intensidad de corriente en el primario.],
    [La tensión en el secundario por la tensión en el primario.],
    [El peso de la bobina del primario por el peso de la bobina del secundario.],
    [La potencia eléctrica que se obtiene en el secundario por la que absorbe el primario.],
  ),
  sol: [
    Aquí la relación de transformación es el cociente de tensiones $V_s slash V_p$, que en el
    transformador ideal coincide con $N_s slash N_p$. La opción a divide una tensión entre una
    corriente: $V slash I$ es una impedancia, no una relación entre devanados. El peso de las
    bobinas (c) no interviene en ninguna ley del transformador. La opción d es el rendimiento
    (potencia de salida entre potencia de entrada), que vale 1 en el caso ideal y algo menos en uno
    real. #vease[(Véase tema T2, sección «Transformadores».)]
    #no-esta[La «relación de transformación» se define con dos convenciones inversas y conviene conocer
    ambas. Como cociente de tensiones (la de esta pregunta) es $V_s slash V_p = N_s slash N_p$:
    mayor que 1 en un elevador, menor que 1 en un reductor. Otros textos la dan al revés, como
    espiras del primario entre espiras del secundario, $N_p slash N_s$, que es la que usa la
    pregunta T2.18 del cuaderno. En el examen fíjate en lo que ofrecen las opciones: nunca será un
    cociente de potencias ni de pesos.]
  ],
)

#q("C-T2.3", "b",
  [El dieléctrico en los condensadores electrolíticos consiste en:],
  (
    [Aire],
    [Una capa de óxido en contacto con una pasta química (electrolito)],
    [Aceite],
    [Agua ionizada],
  ),
  sol: [
    En el banco oficial la opción b dice solo «Una pasta química» y es la que da por buena: es la
    única que alude a lo propio del electrolítico, mientras que el aire (condensadores variables) y
    el aceite (condensadores de alta tensión) son dieléctricos de otros tipos y el agua ionizada no
    se emplea. Con rigor, el dieléctrico es la finísima capa de óxido formada sobre la armadura
    metálica; la pasta química es el electrolito, que actúa de segunda armadura. Por eso se ha
    reescrito la opción b para que recoja ambas piezas; en el examen marca la que habla de la pasta
    química. #vease[(Véase tema T2, sección «Condensadores».)]
    #no-esta[Un condensador electrolítico tiene una armadura de aluminio (o de tántalo) sobre la que se forma
    electroquímicamente una capa de óxido finísima: ese óxido es el dieléctrico, y su poco espesor
    explica la gran capacidad. Sobre él se pone el electrolito, líquido o en pasta, que hace de
    segunda armadura. El óxido solo se mantiene con el positivo en el aluminio; por eso el
    componente está polarizado y se destruye si se conecta al revés.]
  ],
)

#q("C-T2.4", "d",
  [Un relevador o relé es un electroimán que se emplea para:],
  (
    [Mover grandes pesos],
    [Separar las sustancias metálicas de las no metálicas],
    [Separar las sustancias magnéticas de las no magnéticas],
    [Abrir y cerrar un circuito eléctrico],
  ),
  sol: [
    Un relé es un electroimán cuya bobina, al recibir corriente, atrae una pieza móvil (la armadura)
    que abre o cierra unos contactos. Con una corriente pequeña gobierna así otro circuito distinto,
    que puede manejar más tensión o más corriente y queda aislado del primero. Mover grandes pesos
    (a) es lo que hace el electroimán de una grúa, no un relé; y separar metales o sustancias
    magnéticas de las que no lo son (b, c) es el trabajo de un separador magnético. #vease[(Véase
    tema T2, sección «Bobinas» (electroimán); tema T6, sección «La conmutación de antena» (relé
    T-R).)]
    #no-esta[Un relé es un interruptor accionado por un electroimán: al circular corriente por la bobina, el
    campo atrae una armadura y los contactos cambian de posición; al cortar la corriente, un muelle
    los devuelve a su sitio. En la estación lo encuentras como relé T-R, que conmuta la antena entre
    transmisor y receptor al pulsar el PTT. Como la bobina es una inductancia, al cortarla produce
    una sobretensión; por eso se le pone en paralelo un diodo que la absorbe.]
  ],
)

#q("C-T2.5", "d",
  [Un transformador sirve para:],
  (
    [Transformar un acumulador en un motor],
    [Transformar una corriente continua en alterna],
    [Transformar una potencia eléctrica en calor],
    [Transformar una corriente alterna en otra también alterna],
  ),
  sol: [
    El transformador pasa energía de un devanado a otro mediante un flujo magnético variable, así
    que solo trabaja con corriente alterna y entrega otra corriente alterna de la misma frecuencia,
    con la tensión y la corriente cambiadas (si sube una, baja la otra). Convertir continua en
    alterna (b) es tarea de un oscilador o un inversor. Transformar potencia eléctrica en calor (c)
    lo hace una resistencia. Y transformar un acumulador en un motor (a) no tiene sentido físico.
    #vease[(Véase tema T2, sección «Transformadores», y capítulo «La radio por dentro», apartado «El
    transformador: dos bobinas y un puente de flujo».)]
  ],
)

#q("C-T2.6", "d",
  [En las dos primeras franjas que indican el valor de una resistencia, la cifra cinco está
representada por el color:],
  (
    [Azul],
    [Blanco],
    [Amarillo],
    [Verde],
  ),
  sol: [
    Las cifras del código de colores son: negro 0, marrón 1, rojo 2, naranja 3, amarillo 4, verde 5,
    azul 6, violeta 7, gris 8 y blanco 9. El cinco es, pues, el verde. Los distractores son cifras
    de la misma tabla: amarillo es el 4, azul el 6 y blanco el 9. Truco: del rojo al violeta, los
    colores siguen el orden del arco iris y las cifras van de 2 a 7 (rojo 2, naranja 3, amarillo 4,
    verde 5, azul 6, violeta 7). #vease[(Véase tema T2, sección «Resistencias».)]
  ],
)

#q("C-T2.7", "c",
  [Alimentando el primario de un transformador con corriente continua, en el circuito del secundario,
cargado con una resistencia:],
  (
    [Pasa una corriente mayor que por el primario],
    [Pasa la misma corriente que por el primario],
    [No hay paso de corriente],
    [La corriente que pasa es ligeramente inferior que la del primario],
  ),
  sol: [
    El transformador solo transfiere energía mediante un flujo magnético que varía. Con continua el
    flujo del núcleo es constante y, por la ley de Faraday, no se induce tensión en el secundario
    ($e = −N "d"φ slash "d"t = 0$): por la resistencia de carga no circula corriente. Las otras tres
    opciones describirían un transformador con alterna y dependerían de la relación de espiras
    ($I_s slash I_p = N_p slash N_s$). Solo en el instante de conectar o desconectar, mientras el
    flujo cambia, aparece un breve pulso en el secundario. #vease[(Véase tema T2, sección
    «Transformadores».)]
    #no-esta[El secundario solo recibe tensión cuando el flujo cambia, y la continua no lo hace. Además, con
    continua el primario opone únicamente la resistencia del hilo, que es pequeña (la reactancia
    inductiva vale cero, $X_L = 2π f L = 0$): circula una corriente alta que lo calienta y puede
    quemarlo sin transferir nada al secundario. Por eso un transformador de red nunca se alimenta
    con continua; para subir o bajar una tensión continua hay que convertirla antes en alterna.]
  ],
)

#q("C-T2.8", "b",
  [El transistor es:],
  (
    [Una bobina],
    [Un semiconductor],
    [Un rectificador de vacío],
    [Un dispositivo de dos terminales],
  ),
  sol: [
    El transistor es un dispositivo semiconductor: se fabrica con silicio o germanio, materiales
    semiconductores (ni aislantes ni conductores) dopados para formar uniones PN. No es una bobina
    (a), que es un arrollamiento de hilo, ni un rectificador de vacío (c), que es el diodo de
    válvula. Y un dispositivo de dos terminales (d) es un diodo; el transistor tiene tres (emisor,
    base y colector en el bipolar; puerta, fuente y drenador en el FET). Por la misma razón, si se
    pregunta a qué categoría pertenecen los materiales de los transistores, la respuesta es
    semiconductores. #vease[(Véase tema T2, sección «Semiconductores y otros componentes».)]
  ],
)

#q("C-T2.9", "d",
  [Una válvula diodo está compuesta por:],
  (
    [Placa, rejilla y cátodo],
    [Cátodo],
    [Rejilla y cátodo],
    [Placa y cátodo],
  ),
  sol: [
    El diodo de vacío tiene solo dos electrodos: el cátodo, que caliente emite electrones, y la
    placa (ánodo), que los recoge cuando está a tensión positiva. Con eso basta para rectificar,
    porque la corriente solo circula del cátodo a la placa (el filamento de caldeo es aparte y no
    cuenta como electrodo). Un cátodo solo (b) no forma circuito alguno. La rejilla es lo que
    caracteriza a las válvulas amplificadoras: cátodo, rejilla y placa forman el tríodo (a), y una
    rejilla sin placa (c) no recoge corriente. #vease[(Véase tema T2, sección «Válvulas
    termoiónicas».)]
  ],
)

#q("C-T2.10", "a",
  [Si en un transformador el primario tiene menos espiras que el secundario, este transformador es:],
  (
    [Elevador],
    [Mixto],
    [Reductor],
    [Igualador],
  ),
  sol: [
    La tensión sigue al número de espiras: $V_s slash V_p = N_s slash N_p$. Si el primario tiene
    menos espiras que el secundario ($N_p < N_s$), la tensión del secundario es mayor que la de
    entrada: el transformador es elevador. La definición vale también en sentido inverso: en un
    transformador elevador el secundario tiene más espiras que el primario, y no es indiferente la
    relación de espiras, porque de ella depende la tensión de salida. Reductor es el caso contrario;
    con igual número de espiras la tensión no cambia. «Mixto» e «igualador» no son tipos de
    transformador. Ejemplo: 12 V con 100 espiras en el primario y 500 en el secundario dan 12 ×
    500/100 = 60 V. #vease[(Véase tema T2, sección «Transformadores».)]
  ],
)

#q("C-T2.11", "b",
  [¿Qué ventaja tienen los transistores FET sobre los transistores clásicos?],
  (
    [Se pueden usar para señales de frecuencias más altas],
    [Tiene mayor impedancia de entrada],
    [Pueden amplificar señales a mayor nivel],
    [Producen mayor ganancia],
  ),
  sol: [
    El FET se gobierna con la tensión de puerta (campo eléctrico) y la puerta apenas toma corriente:
    su impedancia de entrada es altísima, mientras que un bipolar necesita corriente de base y
    presenta una entrada de baja impedancia. Esa es su ventaja característica (b): no carga la
    fuente de señal, y por eso se usa en las primeras etapas de los receptores. Las otras no son
    ventajas generales: el FET no suele dar más ganancia que un bipolar, no maneja señales de mayor
    nivel, y la frecuencia máxima depende del modelo concreto, no de que sea FET o bipolar.
    #vease[(Véase tema T2, sección «Semiconductores y otros componentes», y capítulo «La radio por
    dentro», apartado «Las otras vidas del transistor».)]
  ],
)

#q("C-T2.12", "b",
  [En un circuito donde se aplica corriente continua se cargarían los condensadores si los hubiese:],
  (
    [No porque el condensador presenta una resistencia muy grande a la corriente continua],
    [Si, todos, al principio],
    [No, sólo si se aplicase corriente alterna],
    [Si pero sólo el primero],
  ),
  sol: [
    Al conectar la continua, circula corriente un instante y carga cada condensador a través de las
    resistencias del circuito, con una exponencial de constante de tiempo $τ = R C$ (cargado a
    efectos prácticos en $5τ$). Cuando el condensador alcanza la tensión del punto al que está
    conectado, la corriente cesa y queda como un circuito abierto. Por eso se cargan todos, al
    principio (b). No es que no se carguen por oponer «una resistencia muy grande» (a): se cargan y
    luego bloquean la continua. Cargarse no exige alterna (c), ni es solo el primero (d): todos
    pasan por el transitorio. #vease[(Véase tema T2, sección «Condensadores».)]
  ],
)

#q("C-T2.13", "a",
  [Un diodo semiconductor:],
  (
    [Se utiliza en la detección],
    [Sirve para simplificar],
    [Es la base de los osciladores],
    [Aumenta la potencia del receptor],
  ),
  sol: [
    Un diodo deja pasar la corriente en un solo sentido, y de esa asimetría vive el detector:
    rectifica la señal modulada y, con un filtro RC, recupera la envolvente, que es la información
    (detección de AM). Por eso la respuesta es a. «Simplificar» no es función de ningún componente
    (y si se leyera «amplificar», tampoco: el diodo no tiene ganancia). Un oscilador necesita un
    elemento activo con ganancia, como un transistor o una válvula, más realimentación, no un diodo
    corriente (c). Y el diodo es pasivo: no aumenta la potencia de nada (d). #vease[(Véase tema T2,
    sección «Semiconductores y otros componentes»; tema T3, sección «Clases de amplificación y
    detectores».)]
  ],
)

#q("C-T2.14", "c",
  [La capacidad está dada por:],
  (
    [$C = I slash E$],
    [$C = W · V$],
    [$C = Q slash E$],
    [$C = R · I$],
  ),
  sol: [
    La capacidad es la carga que almacena un condensador por cada voltio aplicado: $C = Q slash V$.
    Aquí la tensión se escribe $E$, luego $C = Q slash E$ (c); en unidades, faradio = culombio /
    voltio. Las otras opciones son otras magnitudes: $I slash E$ es una conductancia ($1 slash R$),
    $R · I$ es una tensión (ley de Ohm) y $W ·V$ no define ninguna magnitud del condensador; la
    energía almacenada es $W = 1/2 C V^2$. #vease[(Véase tema T2, sección «Condensadores».)]
  ],
)

#q("C-T2.15", "a",
  [La inductancia que presenta una bobina aumenta:],
  (
    [Si aumenta su temperatura],
    [Si aumenta la amplitud de la corriente que por ella circula],
    [Si aumenta la frecuencia de la corriente que por ella circula],
    [Si aumenta el periodo de la corriente que por ella circula],
  ),
  sol: [
    La inductancia depende de cómo está construida la bobina —espiras, diámetro, longitud del
    devanado y núcleo, $L = μ N^2 A slash ell$— y no de la señal que la recorre. Por eso fallan las
    tres opciones que hablan de la corriente: su amplitud (b) no cambia $L$ en una bobina lineal; su
    frecuencia (c) hace crecer la reactancia $X_L = 2π f L$, no la inductancia; y el periodo (d) es
    la inversa de la frecuencia. La única opción que actúa sobre la propia bobina es la temperatura
    (a). El enunciado es poco preciso y se resuelve por eliminación: elige la que modifica la
    bobina. #vease[(Véase tema T2, sección «Bobinas».)]
    #no-esta[Al calentarse, el arrollamiento de una bobina se dilata (más diámetro y más longitud) y su
    inductancia aumenta ligeramente; si tiene núcleo, también varía su permeabilidad con la
    temperatura. Esa variación se mide con el coeficiente de temperatura de la inductancia y es la
    causa de que un oscilador de sintonía variable (VFO) derive en frecuencia mientras se calienta.
    Por eso las bobinas de los osciladores se construyen con hilo rígido sobre soportes cerámicos.]
  ],
)

#q("C-T2.16", "d",
  [El transistor se utiliza, entre otras cosas, como:],
  (
    [Atenuador],
    [Para sintonizar emisoras de radio],
    [Rectificador],
    [Amplificador],
  ),
  sol: [
    La aplicación principal del transistor es amplificar: una pequeña variación en la base (o en la
    puerta del FET) gobierna una corriente o una tensión mucho mayores. Además puede conmutar,
    oscilar y mezclar. Atenuar (a) se consigue con resistencias. Sintonizar emisoras (b) lo hace un
    circuito resonante (bobina y condensador, o varicap); el receptor en su conjunto es quien
    sintoniza, no el transistor. Y rectificar (c) es el trabajo del diodo. #vease[(Véase tema T2,
    sección «Semiconductores y otros componentes».)]
  ],
)

#q("C-T2.17", "d",
  [El valor y la tolerancia de las resistencias más habituales se indican mediante un código de
colores. Indique el valor de la resistencia cuyos colores son, por este orden: verde, rojo, rojo,
plata:],
  (
    [52 Ω y 5 % de tolerancia.],
    [No se puede calcular.],
    [520 Ω y 0,1 % de tolerancia.],
    [5,2 kΩ y 10 % de tolerancia.],
  ),
  sol: [
    Se lee de izquierda a derecha: verde = 5, rojo = 2, y el tercer color, rojo, es el multiplicador
    $10^2$; la cuarta banda, plata, es la tolerancia de ±10 %. Así, $R = 52 × 10^2 = 5200$ Ω = 5,2
    kΩ ± 10 %. La opción a y la c usan un multiplicador equivocado (×1 y × 10 en lugar de $×10^2$) y
    una tolerancia que no corresponde a la plata (el 5 % es el oro); la b es falsa: el valor siempre
    se calcula con la tabla. #vease[(Véase tema T2, sección «Resistencias».)]
    #no-esta[La cuarta banda indica la tolerancia: marrón ±1 %, rojo ±2 %, oro ±5 %, plata ±10 %; sin cuarta
    banda, ±20 %. El oro, más valioso, marca la tolerancia más estrecha (5 %) y la plata, menos, la
    más holgada (10 %). La tercera banda es el multiplicador: la cifra del color es el exponente de
    la potencia de diez (rojo, 2, significa $×10^2$).]
  ],
)

#q("C-T2.18", "b",
  [En el código de colores para la identificación de resistencias, el número cuatro está indicado por
el color:],
  (
    [Azul.],
    [Amarillo.],
    [Verde.],
    [Rojo.],
  ),
  sol: [
    Las cifras del código son: negro 0, marrón 1, rojo 2, naranja 3, amarillo 4, verde 5, azul 6,
    violeta 7, gris 8 y blanco 9. El cuatro es el amarillo (b). Los demás son cifras vecinas: rojo
    es el 2, verde el 5 y azul el 6. Del rojo al violeta los colores siguen el orden del arco iris
    (sin el añil): 2 rojo, 3 naranja, 4 amarillo, 5 verde, 6 azul, 7 violeta. #vease[(Véase tema T2,
    sección «Resistencias».)]
  ],
)

#q("C-T2.19", "c",
  [El Q de una bobina es:],
  (
    [Directamente proporcional a la resistencia],
    [Inversamente proporcional a la impedancia],
    [Inversamente proporcional a la resistencia],
    [Inversamente proporcional a la autoinducción],
  ),
  sol: [
    El factor de calidad de una bobina es el cociente entre su reactancia y su resistencia de
    pérdidas: $Q = X_L slash R = 2π f L slash R$. Es, por tanto, inversamente proporcional a la
    resistencia: cuanto menos pierde la bobina (hilo grueso, poco efecto pelicular), mayor es $Q$.
    Ejemplo: con $X_L = 300$ Ω y $R = 3$ Ω, $Q = 100$; si $R$ se duplica, $Q$ baja a 50. La a dice
    lo contrario. La d falla porque $Q$ crece con la autoinducción ($X_L$ sube con $L$). La b
    confunde $Q$ con $1 slash Z$: cuenta la reactancia frente a la resistencia, no la impedancia
    total. #vease[(Véase tema T2, sección «Bobinas».)]
  ],
)

#q("C-T2.20", "c",
  [¿Qué podemos afirmar de los transistores MOSFET?],
  (
    [Son elementos pasivos.],
    [Siempre dan más potencia que las válvulas.],
    [Tienen una puerta de control.],
    [Disponen de un filamento.],
  ),
  sol: [
    El MOSFET es un transistor de efecto de campo (FET): sus tres terminales son puerta, drenador y
    surtidor (fuente), y la tensión aplicada a la puerta controla la corriente entre drenador y
    surtidor casi sin consumir corriente; en el MOSFET la puerta está aislada del canal por una capa
    de óxido. La a es falsa: es un componente activo (amplifica y conmuta). La b también: «siempre»
    no se sostiene, pues las válvulas siguen usándose en etapas de gran potencia y la potencia
    depende del dispositivo concreto. La d describe las válvulas, cuyo filamento calienta el cátodo.
    #vease[(Véase tema T2, sección «Semiconductores y otros componentes» (el FET y su puerta).)]
    #no-esta[MOSFET son las siglas de #emph[Metal-Oxide-Semiconductor Field-Effect Transistor]: transistor de
    efecto de campo con la puerta aislada del canal por una capa de óxido. Como todo FET tiene
    puerta (#emph[gate]), drenador (#emph[drain]) y surtidor o fuente (#emph[source]); la tensión de
    puerta controla el canal y por ella casi no circula corriente, de modo que su impedancia de
    entrada es muy alta. Es un componente activo y no lleva filamento; se emplea desde los circuitos
    integrados hasta los amplificadores de potencia de los transceptores.]
  ],
)

#q("C-T2.21", "c",
  [¿Cuál de los siguientes símbolos es el de un transistor FET?],
  (
    [#box(baseline: 45%, esquema(escala: 0.75, {
      import zap: *
      import cetz.draw: *

      line((-1.2, 0), (0, 0), stroke: 0.8pt)
      line((0, 0.9), (0, -0.9), stroke: 0.8pt)
      line((0.8, -0.9), (0.8, 0.5), stroke: 0.8pt)
      line((0, 0.9), (0.8, 0.45), (0, 0), stroke: 0.8pt)
      line((0.8, 0), (0, -0.45), (0.8, -0.9), stroke: 0.8pt)
      line((0.8, 0), (1.9, 0), stroke: 0.8pt)
      line((0.8, 0.25), (1.4, 0.7), (1.4, 1.3), stroke: 0.8pt)

    }))],
    [#box(baseline: 45%, esquema(escala: 0.75, {
      import cetz.draw: *
      group({
        line((-1.1, 0), (0, 0), stroke: 0.8pt)
        line((0, -0.5), (0, 0.5), stroke: 2pt)
        line((0, 0.25), (0.55, 0.6), (0.55, 1.3), stroke: 0.8pt)
        line((0, -0.25), (0.55, -0.6), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))
        line((0.55, -0.6), (0.55, -1.3), stroke: 0.8pt)
      })
      group({
        translate((3.4, 0))
        line((-1.1, 0), (0, 0), stroke: 0.8pt)
        line((0, -0.5), (0, 0.5), stroke: 2pt)
        line((0, -0.25), (0.55, -0.6), (0.55, -1.3), stroke: 0.8pt)
        line((0.55, 0.6), (0, 0.25), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))
        line((0.55, 0.6), (0.55, 1.3), stroke: 0.8pt)
      })
    }))],
    [#box(baseline: 45%, esquema(escala: 0.75, {
      import cetz.draw: *
      group({
        translate((0, 0))

      line((0, -0.8), (0, 0.8), stroke: 2pt)
      line((0, 0.55), (0.7, 0.55), (0.7, 1.3), stroke: 0.8pt)
      line((0, -0.55), (0.7, -0.55), (0.7, -1.3), stroke: 0.8pt)
      line((0, 0.55), (-0.4, 0.55), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))
      line((-0.4, 0.55), (-1.1, 0.55), stroke: 0.8pt)

      })
      group({
        translate((3.4, 0))

      line((0, -0.8), (0, 0.8), stroke: 2pt)
      line((0, 0.55), (0.7, 0.55), (0.7, 1.3), stroke: 0.8pt)
      line((0, -0.55), (0.7, -0.55), (0.7, -1.3), stroke: 0.8pt)
      line((-1.1, 0.55), (0, 0.55), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))

      })
    }))],
    [#box(baseline: 45%, esquema(escala: 0.75, {
      import zap: *
      import cetz.draw: *
      diode("d1", (-1.2, 0), (1.2, 0))
    }))],
  ),
  sol: [
    El transistor de efecto de campo (FET) tiene tres terminales: puerta (G), fuente (S) y drenador
    (D). Se dibuja con una línea vertical gruesa, el canal, con el drenador y la fuente en sus
    extremos, y la puerta al lado con una flecha; la de la opción c) es la del FET de unión, en sus
    dos variantes: canal P (flecha saliendo de la puerta) y canal N (flecha entrando). La a) es un
    triac (dos diodos en antiparalelo y un terminal de puerta); la b) son dos transistores
    bipolares, NPN y PNP, con base, colector y emisor (flecha en el emisor, sin canal); la d) es un
    diodo, un triángulo y una barra. #vease[(Véase tema T2, sección «Semiconductores y otros
    componentes».)]
    #no-esta[Los símbolos que hay que saber distinguir en el examen son cuatro. El #strong[diodo]: triángulo
    contra una barra (el cátodo). El #strong[transistor bipolar]: una barra gruesa (la base) con dos
    terminales oblicuos, colector y emisor; la flecha está en el emisor y apunta hacia fuera en el
    NPN y hacia la base en el PNP. El #strong[FET]: un canal vertical con drenador y fuente en los
    extremos y la puerta al lado, con flecha hacia el canal en el de canal N y saliendo de él en el
    de canal P. El #strong[triac]: dos triángulos enfrentados en antiparalelo (conduce en ambos
    sentidos), con un terminal de puerta (T1, T2 y G).]
  ],
)

#q("C-T2.22", "b",
  [¿Cuál de los siguientes símbolos es el de la resistencia?],
  (
    [#box(baseline: 45%, esquema(escala: 0.75, {
      import zap: *
      import cetz.draw: *
      inductor("l1", (-1.1, 0), (1.1, 0))
      line((2.0, 0), (2.4, 0), stroke: 0.8pt)
      rect((2.4, -0.2), (3.6, 0.2), fill: black, stroke: none)
      line((3.6, 0), (4.0, 0), stroke: 0.8pt)
    }))],
    [#box(baseline: 45%, esquema(escala: 0.75, {
      import zap: *
      import cetz.draw: *
      line((-1.1, 0), (-0.8, 0), (-0.6, 0.35), (-0.2, -0.35), (0.2, 0.35), (0.6, -0.35), (0.8, 0), (1.1, 0), stroke: 0.8pt)
      resistor("r1", (2.0, 0), (4.0, 0))
    }))],
    [#box(baseline: 45%, esquema(escala: 0.75, {
      import zap: *
      import cetz.draw: *
      capacitor("c1", (-1.1, 0), (1.1, 0))
      pcapacitor("c2", (2.0, 0), (4.2, 0))
      content((3.45, 0.45), text(size: 7pt)[+])
    }))],
    [#box(baseline: 45%, esquema(escala: 0.75, {
      import zap: *
      import cetz.draw: *
      diode("d1", (-1.2, 0), (1.2, 0))
    }))],
  ),
  sol: [
    La resistencia tiene dos símbolos equivalentes: el zigzag de la norma americana y el rectángulo
    vacío de la europea (IEC); ambos aparecen en la opción b). La a) muestra dos bobinas: el muelle
    de espiras y el rectángulo relleno (las bobinas se dibujan con espiras o con un rectángulo
    macizo, no vacío). La c) son condensadores, dos placas paralelas (la segunda variante, con una
    placa rellena y un signo más, es el electrolítico, con polaridad). La d) es un diodo: un
    triángulo contra una barra. #vease[(Véase tema T2, sección «Resistencias» y «Preguntas sobre
    símbolos».)]
    #no-esta[Símbolos de los componentes pasivos: #strong[resistencia], zigzag (americano) o rectángulo vacío
    (europeo); #strong[condensador], dos placas paralelas (en el electrolítico, una placa rellena y
    un signo + que marca la polaridad); #strong[bobina], varias espiras en forma de muelle o, en la
    norma europea, un rectángulo relleno. El truco: rectángulo vacío, resistencia; rectángulo
    macizo, bobina.]
  ],
)

== Tema T3. Circuitos <apb1-t3>

#q("C-T3.1", "d",
  [¿Qué indica el factor de calidad $Q$ de un circuito resonante?],
  (
    [La calidad de los componentes eléctricos],
    [La facultad para estabilizar un circuito],
    [Relación entre el ancho de banda de entrada y salida],
    [Facultad para seleccionar una frecuencia eliminando las demás],
  ),
  sol: [
    El factor de calidad $Q = f_0 slash B$ mide la agudeza de la resonancia: cuanto mayor es $Q$,
    más estrecha es la curva de respuesta y mejor selecciona el circuito su frecuencia rechazando
    las demás. No mide «la calidad de los componentes» (unas pérdidas bajas dan un $Q$ alto, pero
    eso es una consecuencia, no la definición), ni estabiliza nada, y en un circuito resonante no
    hay un ancho de banda de entrada y otro de salida: solo un ancho de banda $B$, el medido entre
    los puntos de −3 dB. #vease[(Véase tema T3, sección «Asociación de componentes y resonancia».)]
  ],
)

#q("C-T3.2", "b",
  [Un rectificador de onda completa tiene como mínimo:],
  (
    [Un diodo],
    [Dos diodos],
    [Tres diodos],
    [Cuatro diodos],
  ),
  sol: [
    Con un transformador de toma media bastan dos diodos: cada uno conduce en un semiciclo y la
    corriente atraviesa la carga siempre en el mismo sentido, aprovechando los dos semiciclos. Un
    solo diodo da media onda, y tres no corresponden a ningún montaje habitual. Cuatro diodos hacen
    falta solo en el montaje en puente, sin toma media: es lo que pregunta la T3.35 del cuaderno,
    que dice expresamente «en puente». El banco público da «cuatro» como clave, pero sin precisar
    «en puente» el mínimo es dos. Si el enunciado del examen dice «en puente», responde cuatro.
    #vease[(Véase tema T3, sección «Fuentes de alimentación y amplificadores».)]
    #_apb1-clave[«Cuatro diodo». Es la clave que dan las recopilaciones de exámenes reales (2007–2011): conviene
    conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea la
    técnicamente correcta.]
  ],
)

#q("C-T3.3", "b",
  [Para que un oscilador sea estable debe tener, entre otras condiciones:],
  (
    [Fuertemente cargado],
    [Débilmente cargado],
    [Una realimentación por condensador],
    [Una realimentación por bobina],
  ),
  sol: [
    Un oscilador es más estable cuanto menos influye la carga sobre él. Si está fuertemente cargado,
    la carga absorbe energía, reduce el $Q$ del circuito resonante y #emph[arrastra] su frecuencia
    cada vez que varía; débilmente cargado, la frecuencia depende casi solo de su propio circuito.
    Por eso se extrae poca señal del oscilador y se le conecta una etapa separadora. La
    realimentación por condensador (Colpitts) o por bobina (Hartley) son dos montajes igualmente
    válidos: ninguno asegura por sí solo la estabilidad. El banco público da «fuertemente cargado»
    como clave, pero es lo contrario de lo que ocurre en la práctica. #vease[(Véase tema T5, sección
    «Etapas y definiciones» (etapa separadora); tema T3, sección «Filtros, osciladores y
    mezcladores».)]
    #no-esta[La frecuencia de un oscilador se desplaza cuando cambia la carga que se le conecta: una carga
    pesada baja el $Q$ del circuito resonante y reacciona sobre él. Para mantenerla estable se
    acopla la carga de forma floja (se extrae poca señal), se alimenta el oscilador con tensión
    estabilizada y se interpone una etapa separadora (#emph[buffer]) que lo aísla de las variaciones
    de carga de las etapas siguientes, como pregunta el tema T5.]
    #_apb1-clave[«Fuertemente cargado». Es la clave que dan las recopilaciones de exámenes reales (2007–2011):
    conviene conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea
    la técnicamente correcta.]
  ],
)

#q("C-T3.4", "d",
  [Los filtros de las fuentes de alimentación tienen generalmente:],
  (
    [Solamente condensadores],
    [Solamente bobinas (inductancias)],
    [Solamente resistencias],
    [Condensadores y bobinas],
  ),
  sol: [
    El filtro debe eliminar el rizado que deja el rectificador. El condensador en paralelo con la
    carga sostiene la tensión entre crestas, y la bobina (choque) en serie se opone a las
    variaciones de la corriente; combinados forman los filtros en L, en pi (C–L–C) o con choque a la
    entrada, que son los habituales. Las resistencias solas no filtran (solo reducen la tensión y
    disipan potencia) y una bobina sola no sostiene la tensión entre crestas. El banco público da
    «solamente condensadores» como clave: vale para una fuente sencilla de poca corriente con un
    único electrolítico, pero el filtro de una fuente, dicho en general, lleva bobinas y
    condensadores. #vease[(Véase tema T3, sección «Fuentes de alimentación y amplificadores».)]
    #no-esta[En un filtro LC de fuente, la bobina (choque) en serie presenta al rizado una reactancia
    $X_L = 2π f L$ alta y deja pasar casi sin oposición la corriente continua; el condensador en
    paralelo presenta $X_C = 1 slash 2π f C$ baja al rizado y lo desvía a masa. Juntos atenúan el
    rizado mucho más que cada uno por separado. Las configuraciones típicas son en L, en pi
    (condensador–bobina–condensador) y con choque a la entrada.]
    #_apb1-clave[«Solamente condensadores». Es la clave que dan las recopilaciones de exámenes reales
    (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la respuesta
    razonada arriba sea la técnicamente correcta.]
  ],
)

#q("C-T3.5", "d",
  [Se dice que dos circuitos están acoplados cuando:],
  (
    [Las dimensiones de ambos se adaptan perfectamente],
    [Tienen la misma frecuencia],
    [Las oscilaciones de ambos están en resonancia],
    [Las oscilaciones presentes en uno de ellos se transmiten al otro],
  ),
  sol: [
    Dos circuitos están acoplados cuando existe entre ellos un camino por el que la energía de las
    oscilaciones de uno pasa al otro: un campo magnético común (un transformador son dos bobinas
    acopladas), un condensador, una resistencia común o la radiación. No hace falta que tengan la
    misma frecuencia ni que estén en resonancia —aunque la transferencia es más eficaz si lo están—,
    y tampoco que sus dimensiones «se adapten»: lo que define el acoplo es que las oscilaciones de
    uno se transmiten al otro. #vease[(Véase tema T2, sección «Transformadores».)]
    #no-esta[El acoplo es la forma de pasar la señal de un circuito o etapa al siguiente. Puede ser por
    inductancia mutua (dos bobinas que comparten flujo, como en un transformador), capacitivo (un
    condensador en serie, el «condensador de acoplo») o directo (por una resistencia o un hilo).
    Cuanto más fuerte es el acoplo, más energía se transfiere; con acoplo flojo pasa poca y cada
    circuito conserva casi su frecuencia propia. El acoplo no deseado entre circuitos se llama
    acoplo parásito.]
  ],
)

#q("C-T3.6", "c",
  [En varias resistencias de diferente valor conectadas en serie, la intensidad de la corriente que
circula por cada una de ellas será:],
  (
    [Inversamente proporcional al valor de la resistencia],
    [Directamente proporcional al valor de la resistencia],
    [La misma],
    [Mayor en la primera y menor en la última],
  ),
  sol: [
    En un circuito serie no hay nudos intermedios donde la corriente pueda bifurcarse: lo que entra
    por una resistencia sale hacia la siguiente y, por la ley de Kirchhoff de las corrientes (la
    carga no se acumula), es la misma en todas, sea cual sea su valor. Lo que cambia de una a otra
    es la caída de tensión, $V = I R$, mayor en la de más ohmios. Las opciones «proporcional»
    confunden el caso con el paralelo, donde la tensión es común y la corriente de cada rama sí
    depende de $R$ (inversamente proporcional). #vease[(Véase tema T1, sección «Unidades y leyes
    fundamentales».)]
  ],
)

#q("C-T3.7", "d",
  [La neutralización se utiliza en:],
  (
    [Los relés para neutralizarlos],
    [Las baterías para evitar su polarización],
    [En los circuitos electrónicos para evitar el elemento neutro],
    [Los amplificadores para evitar que oscilen],
  ),
  sol: [
    En un amplificador de radiofrecuencia una parte de la salida vuelve a la entrada a través de las
    capacidades parásitas del propio dispositivo (rejilla-placa en un tríodo, base-colector en un
    transistor). Si esa realimentación es positiva y suficiente, el amplificador oscila por su
    cuenta. La neutralización aplica a la entrada una muestra de la salida en oposición de fase que
    cancela la realimentación parásita: así se evita que el amplificador oscile. No tiene relación
    con los relés, con la «polarización» de las baterías ni con ningún «elemento neutro».
    #vease[(Véase tema T2, sección «Válvulas termoiónicas».)]
    #no-esta[Neutralizar un amplificador es anular su realimentación parásita. Se toma una pequeña parte de
    la señal de salida, se invierte su fase 180° y se aplica a la entrada a través de un pequeño
    condensador (condensador de neutralización) de valor parecido a la capacidad parásita
    rejilla-placa o base-colector: las dos corrientes se cancelan y el amplificador deja de oscilar.
    Los tetrodos y pentodos, con su rejilla pantalla, apenas la necesitan.]
  ],
)

#q("C-T3.8", "a",
  [Cuando en un amplificador a transistor sea necesario reproducir la señal de entrada sin
distorsión, se debe funcionar:],
  (
    [En la parte lineal de su característica],
    [Con polarizaciones muy altas],
    [Con amplificación clase C],
    [Eliminando la resistencia de carga],
  ),
  sol: [
    La característica de transferencia de un transistor (corriente de salida frente a tensión de
    entrada) solo es una recta en un tramo. Si se polariza en el centro de ese tramo y la señal no
    lo abandona, la salida es una copia ampliada de la entrada: sin distorsión. Con polarizaciones
    muy altas el transistor se satura y recorta la señal; la clase C conduce menos de medio ciclo y
    deforma la señal (se reserva para CW y FM); y quitar la resistencia de carga no tiene sentido,
    pues sin ella no hay salida aprovechable. #vease[(Véase tema T2, sección «Semiconductores y
    otros componentes» (punto de trabajo); tema T3, sección «Clases de amplificación y
    detectores».)]
  ],
)

#q("C-T3.9", "d",
  [La función de un rectificador de corriente consiste en:],
  (
    [Limitar los máximos de corriente],
    [Transformar la corriente continua en alterna],
    [Cambiar la polaridad de la corriente],
    [Transformar la corriente alterna en continua],
  ),
  sol: [
    Un rectificador aprovecha que el diodo solo conduce en un sentido para convertir la corriente
    alterna, que cambia de sentido, en una corriente que circula siempre en el mismo: continua
    pulsante, que después el filtro alisa. Transformar continua en alterna es lo que hace un
    oscilador o un inversor; limitar los máximos de corriente es tarea de un limitador o de un
    fusible. «Cambiar la polaridad» no describe su función: el rectificador no invierte nada, hace
    que la salida tenga siempre la misma polaridad. #vease[(Véase tema T3, sección «Fuentes de
    alimentación y amplificadores».)]
  ],
)

#q("C-T3.10", "b",
  [En varias resistencias de diferente valor, conectadas en serie, la caída de tensión en cada una de
ellas, cuando circula una corriente, es:],
  (
    [Inversamente proporcional al valor de la resistencia],
    [Directamente proporcional al valor de la resistencia],
    [Igual en todas],
    [No hay caída de tensión],
  ),
  sol: [
    Por todas circula la misma corriente $I$, así que, por la ley de Ohm, la caída en cada una es
    $V = I R$: directamente proporcional a su resistencia. Con $I = 2$ mA, una resistencia de 1 kΩ
    cae 2 V y una de 4,7 kΩ cae 9,4 V. La caída solo sería igual en todas si las resistencias fueran
    iguales, y nunca es nula mientras circula corriente. Este reparto es el principio del divisor de
    tensión. #vease[(Véase tema T1, sección «Unidades y leyes fundamentales».)]
  ],
)

#q("C-T3.11", "a",
  [Cuando una alta frecuencia se mezcla con otra alta frecuencia, el fenómeno resultante es conocido
con el nombre de:],
  (
    [Heterodinación],
    [Histéresis],
    [Rectificación],
    [Impedancia],
  ),
  sol: [
    Al mezclar dos señales en un elemento no lineal aparecen, entre otras, las frecuencias suma y
    diferencia ($f_1 ± f_2$): es el batido o #strong[heterodinación], principio del mezclador del
    receptor superheterodino. Histéresis es la memoria magnética de los núcleos de hierro;
    rectificación, la conversión de alterna en continua; e impedancia, la oposición de un circuito
    al paso de la corriente alterna. Ninguna de las tres es una mezcla de frecuencias. #vease[(Véase
    tema T3, sección «Filtros, osciladores y mezcladores».)]
    #no-esta[Heterodinar es mezclar dos frecuencias para obtener su suma y su diferencia (batido). El nombre
    viene del griego (#emph[heteros], «otro», y #emph[dynamis], «fuerza»). El receptor
    «superheterodino» se llama así porque mezcla la señal recibida con la de un oscilador local para
    obtener una frecuencia intermedia fija, la diferencia. Ejemplo: 14 MHz mezclados con 4 MHz dan,
    entre otras, 18 MHz y 10 MHz.]
  ],
)

#q("C-T3.12", "c",
  [Un amplificador con transistor conectado con emisor común produce amplificación:],
  (
    [Solo de tensión],
    [Solo de corriente],
    [De potencia],
    [Depende de que sea del tipo PNP o NPN],
  ),
  sol: [
    El emisor común da ganancia de tensión y de corriente a la vez y, como la potencia es $P = V I$,
    da también ganancia de potencia: es la configuración que más amplifica de las tres (e invierte
    la fase de la señal). Por eso no son correctas «solo de tensión» ni «solo de corriente». Tampoco
    depende del tipo: un PNP funciona igual que un NPN con la polaridad de la alimentación
    invertida, sin cambiar su comportamiento. #vease[(Véase tema T2, sección «Semiconductores y
    otros componentes».)]
  ],
)

#q("C-T3.13", "b",
  [Debido a la distorsión:],
  (
    [La señal de salida disminuye],
    [La señal de salida no es igual a la de entrada],
    [La señal viene en decibelios],
    [El equipo se quema],
  ),
  sol: [
    La distorsión es cualquier alteración de la forma de onda: la señal de salida deja de ser una
    réplica fiel de la de entrada (aparte de estar ampliada o atenuada). Suele deberse a que el
    dispositivo trabaja fuera de su zona lineal y genera armónicos que no estaban en la entrada. No
    implica que la señal disminuya, no tiene que ver con expresarla en decibelios (una unidad de
    relación) y no quema el equipo; en un transmisor, el resultado son emisiones no deseadas.
    #vease[(Véase tema T3, sección «Fuentes de alimentación y amplificadores».)]
    #no-esta[La distorsión es la diferencia entre la forma de la señal de salida y la de la entrada, una vez
    descontada la ganancia. Se debe a la no linealidad del amplificador (recorte por saturación o
    por corte) y produce armónicos y productos de intermodulación. Se mide como distorsión armónica
    total, el porcentaje de armónicos respecto de la fundamental, y se reduce con realimentación
    negativa o con clases de amplificación más lineales, como la clase A.]
  ],
)

#q("C-T3.14", "d",
  [Los circuitos con «lazo enganchado de fase»:],
  (
    [Tienen un único cuarzo],
    [Tienen un cuarzo por canal],
    [Sirven para estabilizar la frecuencia de un oscilador a cristal],
    [Sirven para estabilizar la frecuencia de un oscilador controlado por tensión],
  ),
  sol: [
    El lazo enganchado de fase (#emph[PLL]) compara la fase del oscilador controlado por tensión
    (VCO) con la de una referencia y, con la tensión de error, corrige el VCO hasta engancharlo: el
    VCO hereda la estabilidad de la referencia. No sirve para estabilizar un oscilador a cristal,
    que ya es estable (es precisamente la referencia). Ni «un único cuarzo» ni «un cuarzo por canal»
    definen al lazo: un sintetizador PLL suele usar un solo cristal de referencia y cambia de canal
    variando el divisor, pero eso es un detalle del montaje, y el PLL también se emplea sin cristal,
    por ejemplo para demodular FM. #vease[(Véase tema T3, sección «Filtros, osciladores y
    mezcladores».)]
  ],
)

#q("C-T3.15", "a",
  [En un amplificador lineal con triodo en reja común:],
  (
    [La señal radio entra por cátodo y sale por ánodo.],
    [La señal radio entra por ánodo y sale por cátodo.],
    [La señal radio entra por reja y sale por ánodo.],
    [La señal radio entra por reja y sale por cátodo.],
  ),
  sol: [
    En el montaje de rejilla (reja) común, la rejilla está a masa para la señal y hace de pantalla
    entre cátodo y ánodo. La excitación se aplica entre cátodo y masa y la salida se toma entre
    ánodo y masa: es el equivalente valvular de la base común del transistor. Por eso la entrada es
    de baja impedancia y el amplificador es estable sin neutralizar. Entrar por el ánodo no tiene
    sentido (el ánodo es siempre la salida); entrar por la rejilla y salir por el ánodo es el
    montaje de cátodo común, y entrar por la rejilla y salir por el cátodo es el seguidor de cátodo.
    #vease[(Véase tema T2, sección «Válvulas termoiónicas».)]
    #no-esta[Un tríodo puede conectarse de tres maneras, según qué electrodo esté a masa para la señal:
    cátodo común (entra por rejilla, sale por ánodo: el montaje habitual), rejilla común (entra por
    cátodo, sale por ánodo) y seguidor de cátodo (entra por rejilla, sale por cátodo). En rejilla
    común, la rejilla a masa apantalla el ánodo respecto del cátodo y anula la realimentación por la
    capacidad rejilla-placa, de modo que no hace falta neutralizar: por eso es el montaje típico de
    los amplificadores lineales de potencia de RF. Su impedancia de entrada es baja.]
  ],
)

#q("C-T3.16", "b",
  [Los circuitos osciladores pueden sufrir variaciones apreciables de frecuencia al variar:],
  (
    [La luz ambiental],
    [La temperatura],
    [Las condiciones de propagación],
    [La densidad de electrones libres],
  ),
  sol: [
    La frecuencia de un oscilador depende de los valores de sus componentes, y estos cambian con la
    temperatura: la bobina se dilata, los condensadores varían su capacidad y los semiconductores
    modifican sus capacidades internas. Es la deriva térmica, principal causa de inestabilidad de un
    oscilador LC, y por eso se recurre al cristal de cuarzo o se estabiliza térmicamente el
    circuito. La luz ambiental no afecta a un circuito normal; las condiciones de propagación y la
    densidad de electrones libres (de la ionosfera) influyen sobre la onda en su recorrido, no sobre
    el oscilador. #vease[(Véase capítulo «La radio por dentro», apartado «El cristal de cuarzo: el
    tanque perfecto»; tema T2, sección «Condensadores».)]
  ],
)

#q("C-T3.17", "b",
  [La intensidad total a la salida de un circuito formado por varias resistencias conectadas en
paralelo:],
  (
    [Es inferior a la de entrada.],
    [Es igual a la de entrada.],
    [Es superior a la de entrada.],
    [Es superior o inferior a la de entrada según los casos.],
  ),
  sol: [
    La corriente que entra en el conjunto se reparte entre las ramas y vuelve a juntarse a la
    salida. Por la ley de Kirchhoff de las corrientes, la suma de las que llegan a un nudo es igual
    a la suma de las que salen (la carga no se acumula), así que la corriente total a la salida es
    igual a la de entrada, y es también la suma de las corrientes de las ramas. Ejemplo: con 12 V
    sobre 6 Ω y 3 Ω circulan 2 A y 4 A; entran 6 A y salen 6 A. Nunca es mayor ni menor.
    #vease[(Véase tema T1, sección «Unidades y leyes fundamentales».)]
  ],
)

#q("C-T3.18", "a",
  [Un circuito con un transistor montado en colector común se denomina también:],
  (
    [Seguidor emisor],
    [Colector mixto],
    [Colector par],
    [Colector seguidor.],
  ),
  sol: [
    En colector común la señal entra por la base y sale por el emisor, cuya tensión «sigue» a la de
    la base (menos unos 0,6 V): de ahí el nombre de seguidor de emisor. Tiene ganancia de tensión
    próxima a 1, ganancia de corriente alta, impedancia de entrada alta e impedancia de salida baja,
    por lo que se usa como adaptador de impedancias. «Colector mixto», «colector par» y «colector
    seguidor» no son denominaciones reales. #vease[(Véase tema T2, sección «Semiconductores y otros
    componentes».)]
  ],
)

#q("C-T3.19", "a",
  [Una de las características de las fuentes lineales de alta intensidad es:],
  (
    [Su elevado peso],
    [Su falta de filtrado en la salida],
    [Su inestabilidad frente a la radiofrecuencia],
    [Su bajo consumo],
  ),
  sol: [
    Una fuente lineal baja la tensión de red con un transformador que trabaja a 50 Hz: para dar
    mucha corriente necesita un núcleo de hierro grande y pesado, además de disipadores voluminosos
    para evacuar el calor del regulador (el rendimiento es bajo). De ahí su elevado peso. No carece
    de filtrado (lleva condensadores de filtro y su salida es muy limpia); la interferencia de RF es
    un problema de las fuentes conmutadas, no de las lineales; y tampoco es de bajo consumo, pues
    desperdicia como calor parte de la energía. #vease[(Véase tema T3, sección «Fuentes de
    alimentación y amplificadores».)]
  ],
)

== Tema T4. Receptores <apb1-t4>

#q("C-T4.1", "b",
  [La etapa de detección de un receptor se emplea para:],
  (
    [Mezclar la señal recibida.],
    [Demodular la señal recibida.],
    [Limitar la señal recibida.],
    [Amplificar la señal recibida.],
  ),
  sol: [
    Detectar es demodular: el detector recupera la información (voz, datos) que llevaba la
    portadora, es decir, extrae la información de la señal modulada. Mezclar es tarea del mezclador,
    que traslada la señal a la FI con el oscilador local; limitar, del limitador, propio de la FM;
    amplificar, de las etapas de RF, FI y BF. La misma idea se pregunta con otras palabras: «en la
    etapa detectora se efectúa un proceso de demodulación» (no de amplificación, neutralización ni
    alimentación) o «la detección sirve para extraer la información de la señal modulada». Mezclar
    la información con la portadora es lo contrario, modular, y se hace en el transmisor; convertir
    continua en alterna o multiplicar la frecuencia de la portadora son funciones de un inversor y
    de un multiplicador. #vease[(Véase tema T3, sección «Clases de amplificación y detectores»; tema
    T4, sección «Características y controles».)]
  ],
)

#q("C-T4.2", "a",
  [Un atenuador para proteger contra sobrecargas la entrada de un receptor estará formado por:],
  (
    [Resistencias (R).],
    [Bobinas (L).],
    [Condensadores (C).],
    [Resistencias, bobinas y condensadores (R, L, C).],
  ),
  sol: [
    Atenuar es disipar en forma de calor parte de la potencia de la señal, y eso solo lo hacen las
    resistencias. Una red de resistencias (en $π$ o en T) reduce la señal un número fijo de
    decibelios igual en todas las frecuencias y mantiene las impedancias de entrada y salida. Las
    bobinas y los condensadores ideales no disipan: almacenan energía y, combinados (R, L, C),
    forman circuitos resonantes y filtros, cuya respuesta depende de la frecuencia. Por eso un
    atenuador de entrada es resistivo.
    #no-esta[El atenuador es una red de resistencias que se intercala entre la antena y el receptor (mando
    «ATT», de 10 o 20 dB) para evitar sobrecargas, bloqueo e intermodulación cuando hay señales muy
    fuertes. Reduce el nivel una cantidad fija: 20 dB son un factor 100 en potencia y 10 en tensión.
    A diferencia de un filtro, atenúa por igual toda la banda. Las bobinas y los condensadores
    ideales no consumen potencia, solo la almacenan y devuelven.]
  ],
)

#q("C-T4.3", "b",
  [Cuando se pasa el modo de recepción de USB a LSB se cambia:],
  (
    [De recibir en A3E a recibir en J3E],
    [La frecuencia de batido],
    [El ancho de banda de la FI],
    [La sensibilidad del receptor],
  ),
  sol: [
    USB y LSB son la misma clase de emisión, J3E (banda lateral única con portadora suprimida; el
    «A3j» de las denominaciones antiguas): solo cambia cuál de las dos bandas laterales se demodula.
    El filtro de la FI sigue siendo el mismo, de unos 2,4 a 3 kHz, así que no cambian ni el ancho de
    banda ni la sensibilidad. Lo que se modifica es la frecuencia del oscilador de batido (BFO), que
    se sitúa al otro lado de la banda de paso del filtro para reinsertar la portadora por el lado
    que corresponde. #vease[(Véase tema T4, sección «Características y controles» (BFO y detector de
    producto).)]
    #no-esta[En SSB no se transmite la portadora y el receptor la repone con el BFO en el detector de
    producto. La frecuencia de batido se coloca a uno u otro lado de la banda de paso del filtro de
    FI según la banda lateral que se quiera recibir. Al pasar de USB a LSB, o al revés, el equipo
    solo desplaza el BFO unos kilohercios (algunos transceptores invierten en su lugar el oscilador
    local), sin tocar el filtro ni la ganancia.]
  ],
)

#q("C-T4.4", "a",
  [Cuando en un receptor actuamos el conmutador de canales estamos:],
  (
    [Variando la sintonía],
    [Disminuyendo el ancho de banda],
    [Variando la potencia de emisión],
    [Aumentando la sensibilidad en recepción],
  ),
  sol: [
    Cada posición del conmutador de canales selecciona una frecuencia distinta: cambia la sintonía
    del receptor. Por dentro se conmuta el cristal, o la división del sintetizador, que fija el
    oscilador local, de modo que el canal elegido caiga en la frecuencia intermedia. El ancho de
    banda lo fija el filtro de FI y es el mismo en todos los canales; la potencia de emisión tiene
    su propio mando y pertenece al transmisor; y la sensibilidad es una cualidad del receptor que
    este conmutador no modifica. #vease[(Véase tema T4, sección «Arquitectura del receptor»
    (sintonizar es mover el oscilador local).)]
    #no-esta[Un canal es una frecuencia fija y predeterminada. En un receptor superheterodino sintonizar
    consiste en mover el oscilador local, con $f_("FI") = |f_("OL") −f_s |$. En los equipos por
    canales (VHF en FM, CB, receptores de escucha) el conmutador elige el cristal o programa el
    divisor del sintetizador de frecuencia; en los de dial continuo se mueve un oscilador variable.
    No confundas el conmutador de canales, que elige una frecuencia concreta, con el de bandas, que
    elige un margen de frecuencias.]
  ],
)

#q("C-T4.5", "d",
  [La estabilidad de un receptor es función:],
  (
    [Del paso de radiofrecuencia],
    [Del mezclador],
    [De la etapa de radiofrecuencia],
    [Del oscilador local],
  ),
  sol: [
    La estabilidad es la capacidad de mantener la frecuencia sintonizada sin derivar. En un
    superheterodino esa frecuencia la fija el oscilador local ($f_s = f_("OL") ± f_("FI")$, según
    vaya el oscilador por debajo o por encima de la señal): si el oscilador deriva por temperatura,
    tensión o envejecimiento, el receptor se desintoniza la misma cantidad. La etapa de RF es un
    amplificador con filtro preselector y el mezclador solo combina dos señales; ninguno de los dos
    determina la frecuencia sintonizada. Por eso se cuida tanto el oscilador local (cristal,
    sintetizador, compensación de temperatura). #vease[(Véase tema T4, secciones «Características y
    controles» y «Arquitectura del receptor».)]
    #no-esta[Una deriva $Δ f$ del oscilador local desplaza exactamente $Δ f$ la señal que recibe el receptor,
    porque $f_s = f_("OL") ± f_("FI")$ y la FI es fija. Ejemplo: si el oscilador deriva 1 kHz, una
    emisora de SSB suena 1 kHz más aguda o más grave hasta que se retoca la sintonía. Por eso el
    oscilador local es el elemento que más condiciona la estabilidad y se estabiliza con cristal,
    sintetizador PLL o compensación térmica (TCXO).]
  ],
)

#q("C-T4.6", "a",
  [Si en un transceptor colocamos el mando «MODE» en posición SSB (BLU), ¿podremos recibir una señal
modulada en amplitud (AM)?],
  (
    [Se recibirá mezclada con un ruido de batido continuo],
    [Se recibirá perfectamente],
    [No entrará señal alguna],
    [Ese mando no influye para nada en la señal recibida],
  ),
  sol: [
    En SSB el receptor demodula con un detector de producto y un oscilador de batido (BFO), no con
    el detector de envolvente de la AM. La portadora de la señal AM, que en SSB no existe, bate con
    el BFO y produce un pitido continuo; además, el filtro estrecho de SSB (unos 2,4 kHz) deja fuera
    parte de una señal AM, que ocupa el doble. Con sintonía exacta se entiende la voz de una sola
    banda, pero cualquier desajuste produce el pitido y nunca es una recepción perfecta: la b, que
    es la clave que publica el banco, es falsa. La señal sí entra (c es falsa) y el mando de modo sí
    influye (d es falsa). #vease[(Véase tema T4, sección «Características y controles» (detector de
    producto y BFO).)]
    #no-esta[Un receptor de AM detecta la envolvente, que contiene la portadora. Uno de SSB o CW detecta por
    producto: mezcla la FI con el BFO, que sustituye a la portadora ausente. Si entra una AM, su
    portadora, de frecuencia constante, bate con el BFO y da un tono continuo de frecuencia igual a
    la diferencia: ese es el «ruido de batido». A la inversa, una SSB escuchada en modo AM resulta
    ininteligible (voz de pato), porque le falta la portadora.]
    #_apb1-clave[«Se recibirá perfectamente». Es la clave que dan las recopilaciones de exámenes reales
    (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la respuesta
    razonada arriba sea la técnicamente correcta.]
  ],
)

#q("C-T4.7", "c",
  [La frecuencia imagen puede aparecer en:],
  (
    [Un emisor superheterodino],
    [Una dinamo],
    [Un receptor superheterodino],
    [Un amplificador lineal],
  ),
  sol: [
    La frecuencia imagen es un defecto propio del receptor superheterodino: su mezclador convierte a
    la misma FI dos frecuencias, la sintonizada $f_s$ y la imagen $f_("im") = f_s + 2f_("FI")$ (o
    $f_s − 2f_("FI")$ si el oscilador va por debajo), y tras el mezclador ya no se pueden separar.
    Ejemplo: con FI de 455 kHz sintonizando 7 MHz, el oscilador va a 7,455 MHz y la imagen cae en
    7,910 MHz. Un emisor no recibe señales externas que puedan entrar por la imagen, y una dinamo
    (generador de corriente continua) o un amplificador lineal no tienen mezclador. #vease[(Véase
    tema T4, sección «Arquitectura del receptor».)]
  ],
)

#q("C-T4.8", "c",
  [El circuito de control automático de ganancia tiene un mando de gobierno que afecta a:],
  (
    [Su capacidad de ganancia],
    [Su capacidad de atenuación],
    [Su tiempo de respuesta],
    [Su conexión a la etapa RF o de FI],
  ),
  sol: [
    El mando del CAG (AGC FAST/SLOW/OFF en muchos equipos) fija su constante de tiempo, es decir, su
    tiempo de respuesta: lo rápido que baja la ganancia cuando aparece una señal fuerte y lo
    despacio que la recupera después. En SSB y AM suele usarse un tiempo largo, para que el nivel no
    siga las sílabas de la voz; en CW, uno corto. El CAG no cambia su capacidad de ganancia ni de
    atenuación, que dependen de las etapas controladas, ni se conecta o desconecta de la etapa de RF
    o de FI: siempre actúa sobre ellas, y con AGC OFF simplemente se anula. #vease[(Véase tema T4,
    sección «Características y controles» (CAG).)]
    #no-esta[El CAG toma el nivel de la señal detectada, lo filtra con una red RC y lo devuelve como tensión
    de control a las etapas de RF y FI. La constante de tiempo de esa red decide con qué rapidez
    actúa y con qué lentitud suelta. Con un tiempo demasiado corto el CAG sigue la propia modulación
    y distorsiona la voz; con uno demasiado largo, una señal fuerte y breve deja sordo al receptor
    unos instantes. Por eso se ofrece un mando de tiempo (rápido, lento).]
  ],
)

#q("C-T4.9", "a",
  [Un receptor de radio se llama superheterodino porque:],
  (
    [Usa frecuencia intermedia],
    [Mezcla las frecuencias sintonizadas],
    [Heterodina los armónicos],
    [Elimina los armónicos],
  ),
  sol: [
    «Superheterodino» describe el principio de funcionamiento: la señal recibida se mezcla (se
    heterodina) con la del oscilador local para convertirla en una frecuencia intermedia (FI) fija,
    por encima del audio («super» viene de supersónico), y allí se hace la amplificación y el
    filtrado. Por eso la respuesta es que usa frecuencia intermedia. El mezclador no «mezcla las
    frecuencias sintonizadas» sin más: traslada la señal a la FI con el oscilador local. Y el nombre
    no tiene nada que ver con los armónicos: ni se heterodinan ni se eliminan así; de eso se
    encargan los filtros. #vease[(Véase tema T4, sección «Arquitectura del receptor».)]
  ],
)

#q("C-T4.10", "c",
  [El mando de ganancia de radiofrecuencia en un transceptor:],
  (
    [Controla la potencia de salida de radiofrecuencia del emisor],
    [Actúa en los pasos de radiofrecuencia de recepción y emisión],
    [Controla la relación entre la señal entregada por la antena y la que se aplica al mezclador],
    [Sirve para aumentar el nivel de la señal en recepción y disminuir el nivel del ruido],
  ),
  sol: [
    El mando «RF GAIN» regula la ganancia de las etapas de RF (y, según el equipo, de FI) del
    receptor: dicho de otro modo, la proporción entre la señal que llega de la antena y la que se
    aplica al mezclador. Se baja para evitar la saturación con señales muy fuertes o para reducir el
    ruido de fondo. No actúa sobre el transmisor: la potencia de salida tiene su propio mando, luego
    a y b son falsas. El banco publicado marca la d, pero es imprecisa: más ganancia amplifica por
    igual señal y ruido y no mejora la relación señal/ruido, que la fija la primera etapa.
    #vease[(Véase tema T4, sección «Preguntas sobre esquemas» (mando «RF GAIN»).)]
    #_apb1-clave[«Sirve para aumentar el nivel de la señal en recepción y disminuir el nivel del ruido». Es la
    clave que dan las recopilaciones de exámenes reales (2007–2011): conviene conocerla por si
    aparece idéntica en el examen, aunque la respuesta razonada arriba sea la técnicamente correcta.]
  ],
)

#q("C-T4.11", "c",
  [El dial de presentación digital («#emph[digital display]») nos indica:],
  (
    [La interferencia],
    [Los decibelios],
    [La frecuencia de trabajo],
    [El volumen],
  ),
  sol: [
    El dial digital es la escala de sintonía de los equipos modernos: muestra la frecuencia a la que
    está trabajando el equipo (por ejemplo, 7,120 MHz), calculada a partir del oscilador local o del
    sintetizador. No indica la interferencia, que no se mide en el panel, ni el volumen, que tiene
    su propio mando; el nivel de la señal recibida lo da el #emph[S-meter], no el dial.
    #vease[(Véase tema T4, sección «Arquitectura del receptor» (sintonizar el dial).)]
    #no-esta[El dial es el elemento con el que se sintoniza: antes era una escala analógica ligada al
    condensador variable; hoy es un #emph[display] numérico que muestra la frecuencia con una
    resolución de unos pocos hercios, deducida del oscilador local o del sintetizador y de la FI.
    Los demás indicadores del panel son instrumentos distintos: el #emph[S-meter] (nivel de señal),
    el medidor de potencia o el de ROE.]
  ],
)

#q("C-T4.12", "b",
  [En los receptores de doble conversión:],
  (
    [La primera frecuencia intermedia es menor que la segunda],
    [La primera frecuencia intermedia es mayor que la segunda],
    [La segunda frecuencia intermedia es el doble que la primera],
    [La segunda frecuencia intermedia es la mitad de la primera],
  ),
  sol: [
    En la doble conversión la primera FI es alta (por ejemplo, 45 o 70 MHz) y la segunda, baja (por
    ejemplo, 455 kHz). Una primera FI alta aleja la frecuencia imagen, que está a $2f_("FI")$ de la
    señal, y el filtro preselector la elimina con facilidad; una segunda FI baja permite filtros muy
    estrechos y, por tanto, selectivos. Por eso la primera es mayor que la segunda, y la a está al
    revés. No hay una relación fija del doble o de la mitad: c y d son falsas, pues las FI
    habituales se diferencian en un factor de veinte o mucho más. #vease[(Véase tema T4, sección
    «Arquitectura del receptor».)]
  ],
)

#q("C-T4.13", "b",
  [La técnica de superheterodinación se emplea:],
  (
    [Porque se aumenta la seguridad de las comunicaciones],
    [Porque permite poner el CAG],
    [Porque los receptores son más sencillos],
    [Porque los emisores son más sencillos],
  ),
  sol: [
    Es una pregunta de enunciado pobre que se resuelve por eliminación. La ventaja del
    superheterodino es la frecuencia intermedia fija: permite concentrar en ella la ganancia y la
    selectividad con filtros y amplificadores optimizados, y además facilita aplicar el CAG sobre
    esas etapas; esa es la opción válida. La superheterodinación no aumenta la seguridad de las
    comunicaciones (a), no simplifica el receptor, que necesita mezclador y oscilador local frente a
    uno de amplificación directa (c), y no tiene que ver con la sencillez de los emisores (d).
    #vease[(Véase tema T4, sección «Arquitectura del receptor».)]
    #no-esta[Al trasladar la señal a una FI fija, casi toda la ganancia queda en un amplificador de
    frecuencia única, con filtros que se diseñan una sola vez. El CAG se apoya en ello: la tensión
    obtenida tras el detector controla la ganancia de esas etapas de FI (y de RF) y mantiene
    constante el nivel de salida, sea cual sea la frecuencia sintonizada. En un receptor de
    amplificación directa, con varios circuitos sintonizados que seguir, el control de ganancia
    sería más complicado.]
  ],
)

#q("C-T4.14", "d",
  [¿A cuál de estos circuitos de la parte receptora de un repetidor debe estar conectado el relé que
conecta la parte emisora?],
  (
    [Al paso de radiofrecuencia],
    [Al paso de baja frecuencia],
    [Al CAG],
    [Al silenciador],
  ),
  sol: [
    Un repetidor debe emitir solo mientras recibe una señal. Esa información la da el silenciador
    (#emph[squelch]) del receptor: se abre cuando detecta portadora (o el subtono CTCSS exigido) y
    se cierra en ausencia de señal. Su salida acciona el relé que pone en marcha el transmisor, como
    un PTT automático. Los pasos de RF y de BF solo amplifican y no distinguen una señal útil del
    ruido; el CAG solo regula la ganancia. Conectado a cualquiera de ellos, el transmisor emitiría
    sin motivo. #vease[(Véase tema T4, sección «Características y controles» (silenciador); tema T5,
    sección «Etapas y definiciones» (repetidor).)]
    #no-esta[Un repetidor es un receptor y un transmisor unidos: lo que recibe en una frecuencia lo
    retransmite en otra. Para que el transmisor se active solo cuando hay una señal, el silenciador
    del receptor, que corta el audio cuando no hay portadora, acciona el relé de control del
    transmisor (en la jerga, relé accionado por portadora, COR). Si el repetidor exige subtono
    CTCSS, el silenciador solo se abre con la portadora que lleva ese tono.]
  ],
)

#q("C-T4.15", "a",
  [El esquema de un receptor básico para banda lateral única se corresponde con la figura:],
  (
    [#_apb1-rx([etapa\ RF], [etapa\ FI], [detector de\ producto], [oscilador\ variable], [oscilador de\ batido])],
    [#_apb1-rx([etapa\ FI], [etapa\ RF], [detector de\ producto], [oscilador\ variable], [oscilador de\ batido])],
    [#_apb1-rx([etapa\ RF], [demodulador], [detector de\ producto], [oscilador\ fijo], [oscilador\ variable])],
    [#_apb1-rx([etapa\ RF], [etapa\ FI], [diodo\ detector], [oscilador\ variable], none)],
  ),
  sol: [
    La señal pasa de la antena a la etapa de RF y al mezclador, donde el oscilador variable la
    convierte en la frecuencia intermedia que amplifica la etapa de FI. En BLU no hay portadora, así
    que la detección exige un detector de producto que la reponga con un oscilador de batido (BFO);
    luego, el amplificador de BF excita el altavoz. Eso es la figura a. En la b la FI va antes del
    mezclador y la RF después, cuando la FI nace en el mezclador. En la c un demodulador ocupa el
    lugar de la FI y los osciladores están cambiados. En la d el diodo detector sirve para AM con
    portadora, no para BLU. #vease[(Véase tema T4, sección «Arquitectura del receptor».)]
  ],
)

#q("C-T4.16", "c",
  [En el siguiente diagrama de bloques, correspondiente a un receptor elemental de conversión directa, el bloque con interrogantes representa un:
    #circuito(caption: none)[
      #diagram(
        node-stroke: 0.6pt, spacing: (5mm, 8mm), edge-stroke: 0.6pt, mark-scale: 70%,
        node((0, 0), stack(dir: ttb, spacing: 1pt, _apb1-ant, _apb1-etq[antena]), stroke: none),
        edge((0, 0), (1, 0), "-|>"),
        _apb1-bq((1, 0), [mezclador]),
        edge((1, 0), (2, 0), "-|>"),
        _apb1-bq((2, 0), [filtro\ de audio]),
        edge((2, 0), (3, 0), "-|>"),
        _apb1-bq((3, 0), [amplificador\ de audio]),
        edge((3, 0), (4, 0), "-|>"),
        node((4, 0), stack(dir: ttb, spacing: 1pt, _apb1-alt, _apb1-etq[altavoz]), stroke: none),
        node((1, 1), text(size: 9pt, weight: "bold", fill: col.naranja)[?], shape: rect, stroke: (paint: col.naranja, dash: "dashed", thickness: 0.7pt), fill: col.naranja-claro, inset: 6pt),
        edge((1, 1), (1, 0), "-|>"),
      )
    ]],
  (
    [amplificador de RF],
    [filtro paso banda],
    [oscilador local],
    [variador de potencia],
  ),
  sol: [
    En un receptor de conversión directa no hay frecuencia intermedia: el mezclador multiplica la
    señal de la antena por la de un oscilador local sintonizado a su misma frecuencia (en BLU, la de
    la portadora suprimida) y a su salida aparece ya el audio, que el filtro de audio depura y el
    amplificador lleva al altavoz. El bloque señalado entra en el mezclador por abajo, como segunda
    señal a multiplicar: es el oscilador local. Un amplificador de RF o un filtro paso banda irían
    en la cadena de la señal, antes del mezclador, y el «variador de potencia» no es una etapa del
    receptor. #vease[(Véase tema T4, sección «Arquitectura del receptor».)]
    #no-esta[Receptor de conversión directa (homodino): el mezclador recibe la señal de la antena y la del
    oscilador local, sintonizado a la frecuencia de la emisora. La diferencia $f_s − f_("OL")$ cae
    ya en audio y un filtro de paso bajo de audio elimina el resto de productos, de modo que no hay
    FI ni frecuencia imagen clásica y el amplificador de audio aporta casi toda la ganancia. Se
    sintoniza moviendo el oscilador local; en CW se le desplaza unos 700 Hz de la señal y en BLU se
    coloca en el lugar de la portadora suprimida.]
  ],
)

== Tema T5. Transmisores <apb1-t5>

#q("C-T5.1", "b",
  [La clase de emisión A3E corresponde a:],
  (
    [Doble banda lateral con ausencia de señal moduladora.],
    [Doble banda lateral con un solo canal con información analógica.],
    [Modulación de frecuencia con dos o más canales.],
    [Banda lateral única con portadora reducida.],
  ),
  sol: [
    La designación A3E se lee símbolo a símbolo: A = amplitud modulada con doble banda lateral, 3 =
    un solo canal con información analógica y E = telefonía. Es, pues, la fonía en AM clásica. La
    opción a describiría un «0» en el segundo símbolo (portadora sin señal moduladora); la c es
    modulación de frecuencia (F) con varios canales (7 u 8 en el segundo símbolo); y la d es la
    banda lateral única con portadora reducida, clase R3E. #vease[(Véase tema T5, sección
    «Arquitecturas y características generales».)]
    #no-esta[La clase de emisión se escribe con tres símbolos (Apéndice 1 del Reglamento de
    Radiocomunicaciones de la UIT). Primero, el tipo de modulación: A doble banda lateral, J banda
    lateral única con portadora suprimida, R con portadora reducida, F frecuencia. Segundo, la señal
    moduladora: 1 un canal digital sin subportadora, 3 un canal analógico, 7 u 8 dos o más canales,
    0 ninguna. Tercero, la información: A telegrafía para recepción auditiva, E telefonía, N
    ninguna. Ejemplos: A1A = CW, A3E = AM, J3E = SSB, F3E = FM.]
  ],
)

#q("C-T5.2", "d",
  [Indique cuál de las siguientes respuestas es falsa:],
  (
    [Un amplificador es lineal cuando la señal de salida es fiel reflejo de la entrada, pero
amplificada.],
    [Los amplificadores pueden ser clase A, B o C.],
    [La carga de un amplificador de potencia debe ser del valor especificado por el fabricante.],
    [La salida de un amplificador de potencia nunca va seguida de filtros destinados a eliminar los
armónicos.],
  ),
  sol: [
    La falsa es la d: tras el amplificador de potencia siempre se coloca un filtro de paso bajo que
    atenúa los armónicos antes de llegar a la antena. Las otras tres son ciertas: un amplificador
    lineal entrega una copia fiel, solo que más grande, de la señal de entrada; los amplificadores
    se clasifican por su ángulo de conducción en clases A, AB, B y C; y la carga debe tener el valor
    indicado por el fabricante (normalmente 50 Ω), porque una carga distinta baja el rendimiento,
    distorsiona o puede averiar el paso final. #vease[(Véase tema T5, sección «Emisiones no
    deseadas» (filtro de salida), y tema T3, sección «Fuentes de alimentación y amplificadores»
    (clases A, B y C).)]
  ],
)

#q("C-T5.3", "c",
  [La antena estará acoplada al paso final de salida:],
  (
    [Directamente],
    [Por medio de una tierra intermedia],
    [Por adaptadores y filtros],
    [No se acopla],
  ),
  sol: [
    Entre el amplificador final y la antena se intercalan una red de acoplo (adaptador de
    impedancias, por ejemplo una red en pi o un acoplador de antena) y un filtro de paso bajo. El
    adaptador hace que el final vea la carga para la que está diseñado y entregue su máxima
    potencia; el filtro elimina los armónicos antes de la antena. Conectarla «directamente» no daría
    ni adaptación ni filtrado; una «tierra intermedia» no lleva la señal de radiofrecuencia a la
    antena; y si «no se acopla», no hay emisión. #vease[(Véase tema T5, sección «Emisiones no
    deseadas» (filtro de salida), y tema T6, sección «Líneas de transmisión y adaptación» (acoplador
    de antena).)]
  ],
)

#q("C-T5.4", "a",
  [Cuando se sobremodula:],
  (
    [Se distorsiona la modulación],
    [Aumenta el nivel de ruido],
    [Aparece un zumbido de motor en el receptor],
    [Mejora la modulación],
  ),
  sol: [
    Sobremodular es pasar del 100 % de modulación (índice $m > 1$): la envolvente se recorta y la
    señal queda distorsionada, con productos de intermodulación que ensanchan la emisión
    (#emph[splatter]) e interfieren a los canales vecinos. El efecto directo es, por tanto, la
    distorsión de la modulación. No se trata de ruido en sí (b), nada tiene que ver con un zumbido
    de motor (c) y, desde luego, la modulación no mejora (d): empeora. #vease[(Véase tema T1,
    sección «Señales moduladas», y tema T5, sección «La cadena de audio y la inteligibilidad».)]
  ],
)

#q("C-T5.5", "c",
  [La misión del conmutador «POWER ON/OFF» en un transceptor es:],
  (
    [Cambiar el ancho de banda],
    [Reponer el fusible de entrada],
    [Encender y apagar el equipo],
    [Aumentar o disminuir la potencia del emisor],
  ),
  sol: [
    POWER ON/OFF es el interruptor general de alimentación: en ON conecta el equipo a la fuente y lo
    enciende; en OFF lo apaga. No cambia el ancho de banda (eso lo hacen los filtros o el selector
    de modo), no repone el fusible (uno fundido se sustituye a mano) ni regula la potencia del
    emisor, que se ajusta con otro mando distinto (el de potencia de salida, #emph[RF power] o
    similar).
    #no-esta[En el panel de un transceptor, POWER (o PWR) es el interruptor de encendido: ON = equipo
    alimentado, OFF = apagado. No hay que confundirlo con el mando de potencia de salida (RF POWER u
    OUTPUT), que regula los vatios radiados. Otros mandos habituales: MODE (clase de emisión), BAND
    (banda), SEND-REC o PTT (paso de recepción a transmisión) y VOX-MAN (conmutación automática o
    manual).]
  ],
)

#q("C-T5.6", "c",
  [El conmutador «SEND-REC» se utiliza para:],
  (
    [Cambiar el modo de emisión],
    [Cambiar la banda],
    [Cambiar la emisión a recepción y viceversa],
    [Modificar la sintonía],
  ),
  sol: [
    SEND-REC (enviar-recibir) es el conmutador manual de transmisión-recepción: en SEND el equipo
    transmite (conecta la antena al transmisor y desconecta el receptor) y en REC vuelve a recibir.
    No cambia el modo de emisión (selector MODE), ni la banda (selector BAND), ni la sintonía (mando
    de frecuencia). #vease[(Véase tema T6, sección «La conmutación de antena».)]
    #no-esta[El conmutador SEND-REC (llamado también TX-RX, y sustituido en la práctica por el PTT del
    micrófono, del inglés #emph[push to talk]) gobierna el relé de transmisión-recepción: en SEND
    conecta la antena al transmisor y protege la entrada del receptor; en REC devuelve la antena al
    receptor. Con VOX la misma conmutación se hace sola, al hablar ante el micrófono.]
  ],
)

#q("C-T5.7", "b",
  [Si se dispone de un amperímetro a la salida del emisor, hacia la antena, en el ajuste óptimo de
emisión (máxima emisión) la lectura será:],
  (
    [Mínima],
    [Máxima],
    [Media],
    [No dará lectura],
  ),
  sol: [
    Un amperímetro intercalado en la línea hacia la antena mide la corriente de radiofrecuencia que
    recibe la antena, y es esa corriente la que produce la potencia radiada ($P = I^2R$). Cuando el
    paso final está bien sintonizado y acoplado, la potencia entregada es la máxima y la lectura
    también. La clave «mínima» que figura en algunos bancos confunde este instrumento con el
    amperímetro de corriente de placa (o de colector) del paso final, que sí cae a un mínimo («dip»)
    en resonancia. «Media» y «sin lectura» no son ningún ajuste óptimo: con lectura nula no sale
    nada hacia la antena. #vease[(Véase tema T8, sección «Más instrumentos y cálculos» (corriente de
    placa del final valvular).)]
    #no-esta[Al sintonizar un paso final hay dos lecturas de sentido opuesto. La corriente de placa (o de
    colector) del amplificador baja a un mínimo, el «dip», al poner en resonancia el circuito de
    salida. La corriente de RF en la línea de antena, medida con un amperímetro de radiofrecuencia,
    sube a un máximo cuando el acoplo a la carga es correcto, porque la potencia radiada crece con
    el cuadrado de la corriente. Se ajusta el mando de sintonía (#emph[tune]) hasta el dip y el de
    carga (#emph[load]) hasta el máximo de salida.]
    #_apb1-clave[«Mínima». Es la clave que dan las recopilaciones de exámenes reales (2007–2011): conviene
    conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea la
    técnicamente correcta.]
  ],
)

#q("C-T5.8", "a",
  [La modulación de banda lateral única:],
  (
    [Es una variante de la modulación de amplitud],
    [Es una modulación de frecuencia corregida],
    [Tiene una subportadora de fase],
    [Es una intermodulación sui generis],
  ),
  sol: [
    La banda lateral única (SSB) deriva de la AM: una emisión de AM contiene la portadora y dos
    bandas laterales con la misma información, y si se suprimen la portadora y una de las bandas
    queda la SSB. Sigue siendo, pues, una variante de la modulación de amplitud (la información va
    en la envolvente), no de frecuencia, y no lleva subportadora de fase. La intermodulación es un
    defecto de los circuitos no lineales, no un tipo de modulación. #vease[(Véase tema T1, sección
    «Señales moduladas».)]
  ],
)

#q("C-T5.9", "a",
  [Las frecuencias límite para una determinada anchura de banda son aquellas a partir de las cuales
se radia:],
  (
    [0,5 % de la potencia media total radiada],
    [2 % de la potencia media total radiada],
    [4 % de la potencia media total radiada],
    [5 % de la potencia media total radiada],
  ),
  sol: [
    Es la definición de anchura de banda ocupada de la UIT: la anchura de la banda de frecuencias
    tal que, por debajo de su límite inferior y por encima de su límite superior, se radia en cada
    lado el 0,5 % de la potencia media total de la emisión. Dentro de ella queda, por tanto, el 99 %
    de la potencia. Los demás porcentajes no se corresponden con esa definición. #vease[(Véase tema
    T5, sección «Emisiones no deseadas».)]
    #no-esta[Anchura de banda ocupada (UIT): banda de frecuencias tal que, por debajo de su límite inferior y
    por encima del superior, las potencias medias radiadas son, cada una, el 0,5 % de la potencia
    media total de la emisión; así, el 99 % de la potencia queda dentro. No es lo mismo que la
    anchura de banda necesaria, que es la mínima que permite transmitir con la calidad y la
    velocidad requeridas.]
  ],
)

#q("C-T5.10", "c",
  [Las medidas de compresión de un transceptor indican:],
  (
    [La anchura de banda de las señales de audio],
    [La ecualización selectiva de las señales de audio],
    [La amplificación de las señales de audio],
    [La atenuación de las señales de audio],
  ),
  sol: [
    El compresor (procesador de voz) del transceptor sube el nivel de los pasajes débiles del audio
    sin pasar de la potencia de pico permitida, de modo que aumenta la potencia media de la emisión.
    Lo que indica la compresión es, pues, cuánto se amplifica la señal de audio. No mide una anchura
    de banda (la fijan los filtros) ni una ecualización (eso son los controles de tono), y tampoco
    es una atenuación, porque el objetivo es elevar la potencia media. El enunciado es poco preciso,
    pero solo la c expresa el efecto buscado. #vease[(Véase tema T5, sección «La cadena de audio y
    la inteligibilidad».)]
  ],
)

#q("C-T5.11", "b",
  [Si el conmutador «modo de emisión» está en la posición CW se trabaja en:],
  (
    [A3E],
    [A1A],
    [R3E],
    [J3E],
  ),
  sol: [
    CW (#emph[continuous wave], telegrafía en onda continua) es la clase de emisión A1A: modulación
    de amplitud (A) por conexión y desconexión de la portadora, un solo canal digital sin
    subportadora (1) y telegrafía para recepción auditiva (A). El banco antiguo la llamaba A1, con
    la nomenclatura anterior al Apéndice 1 del Reglamento de Radiocomunicaciones (A3, A3A y A3J son
    hoy A3E, R3E y J3E). Las otras opciones son telefonía: A3E es AM, R3E es banda lateral única con
    portadora reducida y J3E, con portadora suprimida. La Orden IET/1311/2013 (Anexo II, apartados 4.2
    y 5.2) usa la nomenclatura actual. #vease[(Véase tema T5, sección «Arquitecturas y
    características generales».)]
  ],
)

#q("C-T5.12", "a",
  [En un transceptor, el conmutador «VOX-MAN» en la posición «MAN»:],
  (
    [Conecta el conmutador transmisor-receptor del micrófono],
    [Conecta el manipulador morse],
    [Conecta el mando de ganancia de radiofrecuencia],
    [Conmuta automáticamente recepción-transmisión],
  ),
  sol: [
    VOX-MAN elige cómo se pasa de recepción a transmisión. En VOX la conmutación es automática: el
    equipo transmite cuando detecta voz en el micrófono. En MAN (manual) la gobierna el operador con
    el conmutador transmisor-receptor del micrófono (el PTT). No conecta el manipulador Morse ni el
    mando de ganancia de RF, y la conmutación automática es precisamente la posición VOX.
    #vease[(Véase tema T5, sección «La cadena de audio y la inteligibilidad» (VOX), y tema T6,
    sección «La conmutación de antena» (PTT).)]
    #no-esta[VOX-MAN es el selector del modo de conmutación transmisión-recepción. En VOX (conmutación por
    voz) el equipo pasa a transmitir solo al detectar voz ante el micrófono. En MAN (manual) hay que
    pulsar el PTT del micrófono o el conmutador SEND-REC del panel: el operador decide cuándo se
    transmite. MAN es lo habitual con ruido ambiente, porque VOX podría dispararse con él.]
  ],
)

#q("C-T5.13", "b",
  [En un emisor de radio, los amplificadores se emplean para:],
  (
    [Multiplicar el valor de frecuencia],
    [Aumentar la potencia del emisor],
    [Disminuir el consumo],
    [Disminuir el calor],
  ),
  sol: [
    Un amplificador eleva el nivel de la señal, y en un emisor así se llega desde los milivatios del
    oscilador o del modulador hasta la potencia de salida deseada: aumenta la potencia del emisor.
    Multiplicar la frecuencia es tarea de las etapas multiplicadoras (a). Un amplificador consume
    energía de la alimentación y parte de ella la disipa en forma de calor, de modo que ni disminuye
    el consumo (c) ni el calor (d). #vease[(Véase tema T5, sección «Etapas y definiciones».)]
  ],
)

#q("C-T5.14", "d",
  [La estabilidad de la frecuencia de un emisor de radio proporciona la siguiente ventaja:],
  (
    [Mayor alcance],
    [Menores ruidos eléctricos en la recepción],
    [Mayor potencia de emisión],
    [Menor interferencia a otras emisiones de frecuencia próxima],
  ),
  sol: [
    Un emisor estable mantiene su frecuencia sin derivas por temperatura, tensión o envejecimiento,
    así que su señal se queda en su canal y dentro de la banda, y no invade las frecuencias vecinas:
    menos interferencia a otras emisiones próximas. La estabilidad no aumenta el alcance (que
    depende de la potencia, la antena y la propagación) ni la potencia emitida, y no reduce los
    ruidos eléctricos de la recepción, que tienen otro origen. #vease[(Véase tema T5, sección
    «Arquitecturas y características generales» (oscilador estable), y tema T4, sección
    «Características y controles» (estabilidad del receptor).)]
    #no-esta[La estabilidad de frecuencia es la capacidad de mantener la frecuencia generada sin deriva con
    el tiempo, la temperatura o la tensión de alimentación. En un emisor importa porque la señal no
    se desplaza a otro canal (menos interferencias a las estaciones próximas) ni se sale de los
    límites de la banda de aficionado. Se consigue con osciladores a cristal o sintetizadores y
    dejando calentar el equipo antes de transmitir.]
  ],
)

#q("C-T5.15", "d",
  [Antes del encendido de un emisor hay que prepararlo, pero de los siguientes controles y elementos,
el que no es necesario actuar para dicha preparación previa es:],
  (
    [El selector de la banda de emisión],
    [El mando de ajuste aproximado de la frecuencia de emisión],
    [El conmutador de clase de emisión],
    [El medidor de sensibilidad de la señal],
  ),
  sol: [
    Antes de encender el emisor se dejan listos los mandos que fijan qué y dónde se va a emitir: el
    selector de banda, el mando de ajuste aproximado de la frecuencia y el conmutador de clase de
    emisión. El «medidor de sensibilidad de la señal» es el medidor S, un instrumento de lectura que
    solo indica la intensidad de la señal recibida una vez encendido el equipo: no es un mando y no
    requiere preparación alguna. #vease[(Véase tema T8, sección «Más instrumentos y cálculos»
    (S-meter).)]
    #no-esta[Preparar un emisor antes de encenderlo consiste en dejar los mandos en una posición correcta y
    segura: seleccionar la banda, poner la frecuencia aproximada, elegir la clase de emisión (CW,
    SSB, FM…) y comprobar que hay antena o carga artificial conectada. El medidor S indica la
    intensidad de la señal recibida: es un indicador, no un control, y no hay nada que ajustar en
    él.]
  ],
)

#q("C-T5.16", "b",
  [En un emisor de potencia media, la alta tensión de placa del paso final se aplica:],
  (
    [Directamente con el encendido general],
    [En dos etapas; en la primera se aplica una tensión media; y después del primer ajuste, se aplica
toda la tensión],
    [Al insertar el micrófono],
    [Al seleccionar la banda de funcionamiento],
  ),
  sol: [
    Con el filamento ya caldeado, el paso final de válvulas se sintoniza primero con una tensión de
    placa reducida y se retoca después con la tensión completa. Mientras los circuitos de placa
    están desacordados, la corriente de placa es muy alta; a tensión plena la válvula disiparía más
    de lo que soporta y podría dañarse. Por eso la alta tensión no se aplica «directamente con el
    encendido» (a). Ni el micrófono (c) ni el selector de banda (d) tienen relación con la tensión
    de placa. #vease[(Véase tema T3 (sintonizar el final a plena potencia puede dañarlo) y tema T8
    (corriente de placa al sintonizar el final valvular).)]
    #no-esta[Procedimiento habitual de sintonía de un final valvular: 1) esperar el caldeo del filamento; 2)
    aplicar la alta tensión reducida (según el equipo, con un conmutador de tensión reducida o una
    toma intermedia del transformador); 3) ajustar la sintonía de placa hasta el mínimo de corriente
    de placa y el acoplo a la antena con el mando de carga (#emph[load]); 4) aplicar la tensión
    completa y retocar ambos mandos. Así la válvula no soporta la corriente ni la disipación máximas
    mientras el circuito está desacordado.]
  ],
)

#q("C-T5.17", "c",
  [La utilización de un transceptor como transmisor o como receptor de radio requiere:],
  (
    [Emplear una antena para emisión y otra para recepción],
    [Emplear dos unidades de alimentación, independientes, para emisión y para recepción],
    [Actuar un conmutador de paso de una a otra función],
    [Desconectar el micrófono y conectar en su lugar un altavoz],
  ),
  sol: [
    Un transceptor reúne transmisor y receptor en un mismo equipo, con una sola antena y una sola
    alimentación. Para pasar de una función a otra basta accionar un conmutador: el PTT o el mando
    de emisión/recepción, que activa el relé de transmisión-recepción y los circuitos de cada modo.
    No hacen falta dos antenas (a) ni dos fuentes (b), y el micrófono y el altavoz permanecen
    conectados en los dos modos (d). #vease[(Véase tema T6, sección «La conmutación de antena».)]
  ],
)

#q("C-T5.18", "d",
  [El conmutador SEND/REC se utiliza para:],
  (
    [Cambiar de banda],
    [Encender el transceptor],
    [Cambiar de modo de emisión],
    [Cambiar de emisión a recepción o viceversa],
  ),
  sol: [
    SEND/REC (del inglés #emph[send]/#emph[receive], enviar/recibir) es el conmutador que pasa el
    equipo de emisión a recepción y viceversa: activa el relé de transmisión-recepción y los
    circuitos de cada modo. No cambia de banda (eso lo hace el conmutador de bandas), no enciende el
    aparato (interruptor de alimentación) ni cambia la clase de emisión (selector de modo: LSB, USB,
    AM, FM, CW). #vease[(Véase tema T6, sección «La conmutación de antena».)]
    #no-esta[En muchos equipos el mando que pasa de recibir a transmitir se rotula SEND/REC o TX/RX; en los
    transceptores modernos esa misma función la cumple el pulsador PTT (#emph[push to talk]), y el
    VOX la automatiza con la voz. Conviene no confundirlo con el conmutador de bandas (tema T3) ni
    con el selector de modo (tema T4): cada mando hace una sola cosa.]
  ],
)

#q("C-T5.19", "a",
  [La clase de emisión A3E (antes designada A3) indica:],
  (
    [Telefonía de doble banda lateral, portadora completa],
    [Telegrafía sin modulación],
    [Telefonía de banda lateral única, portadora suprimida],
    [Telefonía, dos bandas laterales independientes],
  ),
  sol: [
    La clase A3E se lee letra a letra: A, modulación de amplitud con doble banda lateral y portadora
    completa; 3, un solo canal analógico; E, telefonía. Es la AM clásica. La telefonía de banda
    lateral única con portadora suprimida es J3E (opción c), la telegrafía (CW) es A1A (b) y las
    bandas laterales independientes son la clase B (d). El banco original escribía «A3»; la notación
    vigente añade la tercera letra. #vease[(Véase tema T5, sección «Arquitecturas y características
    generales»; tema T1, sección «Señales moduladas».)]
  ],
)

#q("C-T5.20", "a",
  [En un transceptor a válvulas, la alta frecuencia del paso final se aplica:],
  (
    [Al actuar sobre el conmutador emisión/recepción],
    [Al encender el equipo],
    [Después de pasar cierto tiempo desde el encendido del equipo],
    [Al conectar el micrófono],
  ),
  sol: [
    En recepción el paso final no recibe excitación: la radiofrecuencia del excitador solo le llega
    cuando se acciona el conmutador emisión/recepción (PTT o relé T-R). Al encender solo se
    calientan los filamentos: el tiempo de caldeo es una condición previa para transmitir, pero no
    aplica RF al final (b y c). Y conectar el micrófono no cambia el estado del equipo (d).
    #vease[(Véase tema T2, sección «Válvulas termoiónicas» (caldeo previo); tema T6, sección «La
    conmutación de antena».)]
    #no-esta[En un equipo a válvulas hay dos condiciones independientes. El caldeo del filamento empieza al
    encender y debe completarse antes de transmitir. La excitación es otra cosa: la señal de RF del
    oscilador y del excitador solo se dirige a la etapa final cuando el conmutador pasa a emisión, a
    la vez que el relé T-R conecta la antena al transmisor. En recepción el final queda sin
    excitación y en reposo.]
  ],
)

#q("C-T5.21", "b",
  [El índice de modulación de amplitud es:],
  (
    [La potencia de salida de las bandas laterales dividida por la portadora],
    [El porcentaje de la variación de amplitud que experimenta la portadora],
    [El porcentaje de la variación de amplitud que experimenta la moduladora],
    [La amplitud máxima de las variaciones de la portadora],
  ),
  sol: [
    El índice de modulación $m$ mide cuánto varía la amplitud de la portadora por efecto de la
    moduladora y se expresa en porcentaje: $m = (A_"máx" − A_"mín") / (A_"máx" + A_"mín")$. Con
    $m = 0,5$ (50 %) la amplitud oscila entre 0,5 y 1,5 veces la de la portadora sin modular; con
    $m = 1$ (100 %) llega a anularse y duplicarse, y más allá hay sobremodulación. No es una
    relación de potencias (a: las bandas laterales suman $m^2 slash 2$ de la potencia de la
    portadora) ni una amplitud absoluta (d). #vease[(Véase tema T1, sección «Señales moduladas».)]
  ],
)

#q("C-T5.22", "b",
  [Los amplificadores a cavidades resonantes se emplean en los transceptores que trabajan en las
bandas de:],
  (
    [28 MHz y superiores],
    [144 MHz y superiores],
    [432 MHz y superiores],
    [1215 MHz y superiores],
  ),
  sol: [
    Una cavidad resonante es una caja metálica que hace de circuito resonante de $Q$ muy alto y
    sustituye al circuito LC cuando este deja de ser práctico. Desde 144 MHz un cuarto de onda mide
    unos 52 cm ($λ slash 4 = 300 slash 144 slash 4 ≈ 0,52$ m), un tamaño manejable, y las
    capacidades parásitas de la válvula ya estorban a un circuito LC. A 28 MHz el cuarto de onda
    mediría unos 2,7 m, impracticable, y bastan bobinas y condensadores. Las opciones c) y d) fijan
    un límite demasiado alto: las cavidades ya se usan en 144 MHz.
    #no-esta[Una cavidad resonante (una línea resonante encerrada en una caja metálica) sustituye al circuito
    LC de placa o de rejilla en los amplificadores de potencia de VHF, UHF y microondas. Al subir la
    frecuencia, las bobinas y condensadores necesarios se hacen tan pequeños que dominan las
    capacidades parásitas de la válvula, mientras que las dimensiones de una línea de cuarto de onda
    se vuelven cómodas: unos 52 cm en 144 MHz y unos 17 cm en 432 MHz. Regla que recoge el examen:
    cavidades, de 144 MHz hacia arriba.]
  ],
)

#q("C-T5.23", "b",
  [Un transmisor:],
  (
    [Convierte una señal de frecuencia intermedia en otra de audiofrecuencia.],
    [Convierte una señal de frecuencia intermedia en otra de radiofrecuencia.],
    [Convierte una señal de radiofrecuencia en otra de baja frecuencia.],
    [Convierte una señal de baja frecuencia en otra de frecuencia intermedia para emitirla por
antena.],
  ),
  sol: [
    En un transmisor con conversión de frecuencia (el esquema habitual en SSB) la señal se modula y
    se filtra a una frecuencia fija y baja, la frecuencia intermedia, y un mezclador con el
    oscilador de sintonía (VFO) la traslada a la frecuencia de trabajo, ya en radiofrecuencia, para
    amplificarla y enviarla a la antena. Las opciones a) y c) describen el camino inverso, el del
    receptor, que lleva la FI a audio o la RF a baja frecuencia. La d) es imposible: lo que sale por
    la antena es radiofrecuencia, no FI. #vease[(Véase tema T5, sección «Arquitecturas y
    características generales» (transmisor de SSB con mezclador).)]
    #no-esta[En el transmisor, la «frecuencia intermedia» es la frecuencia fija y baja a la que se genera y
    filtra la señal modulada (por ejemplo, la banda lateral única que sale del filtro de cristal).
    El mezclador la combina con la señal del VFO o del sintetizador y da la señal en la frecuencia
    de trabajo. Es el recorrido inverso al del receptor superheterodino (RF → FI → audio): el
    transmisor sube de frecuencia y el receptor baja.]
  ],
)

#q("C-T5.24", "a",
  [Un transmisor suele tener entre sus subsistemas auxiliares:],
  (
    [Un sistema de refrigeración.],
    [Un dispositivo de posicionamiento GPS para dar a conocer su ubicación.],
    [Un compartimento con bandeja extraíble para alojar la documentación de su licencia.],
    [Un pararrayos con toma a tierra.],
  ),
  sol: [
    Los subsistemas auxiliares no generan ni modulan la señal, pero permiten que el transmisor
    funcione: fuente de alimentación, protecciones y, sobre todo en las etapas de potencia, la
    refrigeración (disipadores, ventiladores), porque parte de la energía consumida se convierte en
    calor. Un GPS o un cajón para la licencia no forman parte de un transmisor, y el pararrayos con
    su toma de tierra protege la instalación (mástil y antena), no el equipo. #vease[(Véase tema T5,
    sección «Arquitecturas y características generales» (rendimiento del transmisor).)]
    #no-esta[El rendimiento de un amplificador de RF nunca llega al 100 %: lo que no sale como potencia de RF
    se disipa en la etapa final en forma de calor. Por eso los transmisores de potencia llevan
    disipador y ventilador (y, en las válvulas de gran potencia, aire forzado o refrigeración
    líquida). La refrigeración se cuenta como subsistema auxiliar junto con la fuente de
    alimentación; la protección contra descargas atmosféricas es cosa de la instalación de antena
    (tema T10).]
  ],
)

#q("C-T5.25", "b",
  [Son características relevantes en un transmisor:],
  (
    [Potencia de emisión y factor de ruido.],
    [Frecuencia de emisión y su estabilidad en frecuencia.],
    [Emisión de espurios y su conectividad a redes Wi-Fi.],
    [Técnicas de modulación y sensibilidad a las interferencias.],
  ),
  sol: [
    Las características de un transmisor describen la señal que emite: frecuencia de emisión y
    estabilidad (que no derive), potencia, anchura de banda, emisiones no deseadas y rendimiento. El
    factor de ruido (a) y la sensibilidad (d) son características del receptor: miden cuán débil
    puede ser la señal que aún se recibe. La conectividad Wi-Fi (c) no tiene relación con un
    transmisor de aficionado. Solo la opción b) contiene dos magnitudes propias del transmisor.
    #vease[(Véase tema T5, sección «Arquitecturas y características generales».)]
    #no-esta[Estabilidad de frecuencia: capacidad del transmisor de mantener su frecuencia de emisión aunque
    cambien la temperatura, la tensión de alimentación o la carga; se logra con osciladores a
    cristal o con sintetizadores (tema T3). Importa porque una emisión que deriva puede salirse de
    la banda o pisar a otra estación. Factor de ruido y sensibilidad (tema T4) pertenecen al
    receptor.]
  ],
)

#q("C-T5.26", "d",
  [Llamamos unidad transceptora al conjunto formado por:],
  (
    [Transmisor y acoplador.],
    [Transmisor y duplexor.],
    [Transmisor y acoplador con medidor de ROE.],
    [Transmisor y receptor.],
  ),
  sol: [
    Una unidad transceptora (un transceptor) reúne en un solo equipo un transmisor y un receptor,
    que comparten elementos como el oscilador, la sintonía, la alimentación y la antena (con el relé
    de transmisión-recepción). Acopladores, duplexores y medidores de ROE son accesorios de la línea
    o de la antena: no son un receptor, y por eso ninguna de esas combinaciones forma una unidad
    transceptora. #vease[(Véase tema T5, sección «Etapas y definiciones».)]
  ],
)

#q("C-T5.27", "c",
  [Un modulador digital:],
  (
    [Convierte la señal de audio en estados discretos, bien sean de amplitud, fase, amplitud y fase,
frecuencia instantánea, etc., de una señal portadora de radiofrecuencia.],
    [Convierte una señal portadora de radiofrecuencia con estados discretos, bien sean de amplitud,
fase, amplitud y fase, frecuencia instantánea, etc., en señal de audio.],
    [Convierte niveles discretos de tensión en estados discretos, bien sean de amplitud, fase,
amplitud y fase, frecuencia instantánea, etc., de una señal portadora de radiofrecuencia.],
    [Convierte la voz en niveles discretos de tensión.],
  ),
  sol: [
    El modulador digital recibe datos ya digitales (niveles discretos de tensión, los bits) y los
    traduce en estados discretos de la portadora: amplitud, frecuencia (FSK), fase (PSK) o amplitud
    y fase a la vez (QAM). La opción a) se salta un paso: el audio es analógico y antes hay que
    digitalizarlo (conversor A/D, códec de voz). La b) describe el demodulador, que recorre el
    camino inverso, y la d) es el codificador de voz, no un modulador. #vease[(Véase tema T1,
    sección «Señales moduladas» (modulación digital: FSK, PSK, QAM).)]
  ],
)

#q("C-T5.28", "a",
  [¿Válvulas o transistores? Seleccionar la sentencia correcta.],
  (
    [Los amplificadores a válvulas son los preferidos por los radioaficionados amantes de lo retro en
radio.],
    [Los amplificadores a válvulas presentan mayor deriva en frecuencia que los amplificadores a
transistores.],
    [Las válvulas son energéticamente más eficientes que los transistores.],
    [Por encima de 200 vatios los amplificadores finales son a válvulas.],
  ),
  sol: [
    Es la única afirmación que no es falsa (recoge una preferencia, no un dato técnico). Las
    válvulas no son más eficientes que los transistores (c): hay que alimentar el filamento y se
    pierde mucha energía en calor. Un amplificador no fija la frecuencia —la fija el oscilador—, así
    que no hay una «deriva» propia de las válvulas (b). Y existen finales de transistores de más de
    un kilovatio: los 200 W no marcan ninguna frontera (d). #vease[(Véase tema T2, sección «Válvulas
    termoiónicas».)]
    #no-esta[Válvulas: necesitan caldeo del filamento y tensiones de placa de cientos o miles de voltios,
    rinden menos y ocupan más, pero aguantan sobrecargas y desadaptaciones y dan mucha potencia con
    circuitos sencillos; por eso perviven en algunos lineales y entre los aficionados a lo clásico.
    Transistores: baja tensión, arranque inmediato, tamaño reducido y mejor rendimiento, pero
    sensibles al calor. Hay finales de transistores de 1 kW o más. La frecuencia de emisión la fija
    el oscilador, no el tipo de amplificador.]
  ],
)

#q("C-T5.29", "b",
  [Un transmisor debe realizar al menos las siguientes funciones:],
  (
    [Generar la señal, demodular y amplificar.],
    [Generar la señal, modular y amplificar.],
    [Generar la señal, modular y demodular.],
    [Entregar una señal útil a partir de la recogida en la antena.],
  ),
  sol: [
    Un transmisor genera la señal de radiofrecuencia (oscilador), la modula con la información (voz,
    datos, manipulación Morse) y la amplifica hasta la potencia que entregará a la antena. Demodular
    es extraer la información de una señal modulada, y eso lo hace el receptor: por eso a) y c) son
    falsas. La opción d) describe justamente al receptor, que entrega una señal útil (audio) a
    partir de la captada por la antena. #vease[(Véase tema T5, sección «Arquitecturas y
    características generales».)]
  ],
)

#q("C-T5.30", "c",
  [En los equipos de radioaficionado, el modo de modulación NBFM (banda estrecha de frecuencia
modulada), ¿qué excursión de frecuencia máxima permite?],
  (
    [12 kHz],
    [±75 kHz],
    [Unos ±2,5 a ±5 kHz],
    [±25 kHz],
  ),
  sol: [
    La NBFM de las bandas de aficionado (VHF/UHF, con canales de 12,5 o 25 kHz) limita la excursión
    (desviación) a unos ±2,5 a ±5 kHz. Los 12 kHz que da el banco no son una excursión, sino la
    anchura de banda típica de la emisión (pregunta T4.35 del cuaderno): por la regla de Carson,
    $B ≈ 2(Δ f + f_m) = 2(2,5 + 3) ≈ 11$ kHz, es decir, unos 12 kHz. Los ±75 kHz son la excursión de
    la FM de radiodifusión (banda ancha). Se corrige la clave del banco: si en un examen aparece 12
    kHz como respuesta a esta pregunta, se está confundiendo excursión con anchura de banda.
    #vease[(Véase tema T5, sección «Arquitecturas y características generales» (desviación e índice
    de modulación de FM); la anchura de banda de la NBFM, en una pregunta del tema T4.)]
    #no-esta[La excursión o desviación $Δ f$ es lo que se aparta la portadora de su frecuencia central al
    ritmo de la voz: es la magnitud que controla la modulación en FM. En la FM de banda estrecha
    (NBFM) se limita a ±2,5 kHz (canales de 12,5 kHz) o ±5 kHz (canales de 25 kHz), frente a los ±75
    kHz de la FM comercial. No hay que confundirla con la anchura de banda, que estima la regla de
    Carson, $B ≈ 2(Δ f + f_m)$, y en NBFM es del orden de 12 kHz.]
    #_apb1-clave[«12 kHz.». Es la clave que dan las recopilaciones de exámenes reales (2007–2011): conviene
    conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea la
    técnicamente correcta.]
  ],
)

#q("C-T5.31", "b",
  [El esquema de un transmisor básico para banda lateral única se corresponde con la figura:],
  (
    [#_apb1-tx([etapa\ BF], [modulador\ de fase], [filtro], [amplificador\ RF])],
    [#_apb1-tx([etapa\ BF], [modulador\ balanceado], [filtro], [amplificador\ RF])],
    [#_apb1-tx([etapa\ BF], [modulador\ balanceado], [modulador\ de fase], [amplificador\ RF])],
    [#_apb1-tx([etapa\ RF], [modulador\ balanceado], [filtro], [amplificador\ BF])],
  ),
  sol: [
    Un transmisor de BLU amplifica en BF la voz del micrófono; un modulador balanceado, con el
    oscilador de portadora, suprime la portadora y deja las dos bandas laterales; un filtro elimina
    una de ellas; un mezclador con el oscilador variable traslada la banda restante a la frecuencia
    de trabajo y el amplificador de RF la lleva a la antena. Eso es la figura b. La a usa un
    modulador de fase, propio de la FM. En la c otro modulador de fase ocupa el puesto del filtro y
    las dos bandas siguen presentes. En la d están cambiadas las etapas: RF junto al micrófono y BF
    antes de la antena. #vease[(Véase tema T5, sección «Arquitecturas y características
    generales».)]
  ],
)

== Tema T6. Antenas y líneas de transmisión <apb1-t6>

#q("C-T6.1", "d",
  [¿Qué ventajas presenta la antena dipolo en V invertida?],
  (
    [Un valor de impedancia próximo a 75 Ω y polarización circular.],
    [Un valor de impedancia próximo a 75 Ω y un diagrama de radiación muy directivo.],
    [Un valor de impedancia constante y elevada ganancia.],
    [Un valor de impedancia próximo a 50 Ω y un diagrama de radiación prácticamente omnidireccional.],
  ),
  sol: [
    En la V invertida el centro (el punto de alimentación) va arriba, en el mástil, y los brazos
    caen inclinados hacia el suelo. Al inclinarlos, la impedancia baja desde los ∼73 Ω del dipolo
    horizontal hasta unos 50 Ω (con un ángulo entre brazos de 90 a 120 grados), que es justo la del
    coaxial de los equipos. Además, los brazos inclinados radian también algo de campo vertical y el
    diagrama se vuelve casi omnidireccional en el plano horizontal. No hay polarización circular
    (a), ni un diagrama muy directivo (b: eso es una Yagi), ni ganancia elevada ni impedancia
    «constante» (c): es un dipolo, de unos 2,15 dBi. #vease[(Véase tema T6, sección «El dipolo y
    otras antenas».)]
    #no-esta[Dipolo en V invertida: dipolo de media onda con el centro elevado, sujeto a un solo mástil, y
    los extremos caídos, formando entre los brazos un ángulo de unos 90 a 120 grados. Inclinar los
    brazos hacia el suelo reduce la impedancia del punto de alimentación, de ∼73 Ω a unos 50 Ω, y
    redondea el diagrama: aparece una componente vertical y se atenúan los nulos que el dipolo
    horizontal tiene en la dirección de sus extremos, de modo que se acerca a un diagrama
    omnidireccional en el plano horizontal.]
  ],
)

#q("C-T6.2", "c",
  [La antena de media onda:],
  (
    [Parte las ondas por medio],
    [Es directiva],
    [Es omnidireccional (en el plano perpendicular al hilo)],
    [Es una antena para las ondas decamétricas solamente],
  ),
  sol: [
    El dipolo de media onda radia por igual en todas las direcciones del plano perpendicular al hilo
    (en vertical, hacia todo el horizonte) y no radia en la dirección del propio hilo. Se le
    considera por eso omnidireccional, al contrario que una Yagi, que concentra la energía en una
    sola dirección: su directividad es de solo 2,15 dBi (b falsa). La media onda no es exclusiva de
    las decamétricas: se construye para cualquier frecuencia con $λ slash 2$ de hilo (d). Y «partir
    las ondas por medio» (a) no significa nada: la media onda es la longitud de la antena.
    #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]
    #no-esta[Diagrama del dipolo: como la corriente circula a lo largo del hilo, la radiación es máxima en
    las direcciones perpendiculares a él y nula en la dirección del hilo. En tres dimensiones es un
    toro (una rosquilla) con el hilo pasando por el agujero. Montado en vertical, el corte
    horizontal es un círculo: radia por igual hacia todo el horizonte (omnidireccional). Montado en
    horizontal, ese mismo corte es un «ocho». Omnidireccional se entiende, pues, siempre respecto de
    un plano.]
  ],
)

#q("C-T6.3", "b",
  [La relación de ondas estacionarias para un adecuado funcionamiento debe ser:],
  (
    [Mayor que 2,5],
    [Entre 2,5 y 1],
    [Entre 1 y 0,5],
    [Menor que 0,5],
  ),
  sol: [
    La ROE es el cociente entre el máximo y el mínimo de la onda estacionaria y, como el máximo
    nunca es menor que el mínimo, vale siempre 1 o más: los intervalos de c y d no existen. El valor
    ideal es 1 (nada se refleja). Hasta 2 o 2,5 la desadaptación es tolerable: con ROE 2,5,
    $ρ = 1,5 slash 3,5 ≈ 0,43$ y se refleja $ρ^2 ≈ 18$ % de la potencia. Por encima de 2,5 (a)
    crecen las pérdidas en la línea y el riesgo para el transmisor. #vease[(Véase tema T6, sección
    «Líneas de transmisión y adaptación».)]
    #no-esta[Margen útil de la ROE: por definición ROE ≥ 1 (1 es la adaptación perfecta; no tiene límite
    superior). En la práctica se considera buena por debajo de 1,5, aceptable hasta 2 y todavía
    utilizable hasta 2,5 o 3: con 2,5 se refleja el 18 % de la potencia. Más allá conviene ajustar
    la antena o usar un acoplador, porque suben las pérdidas en la línea y muchos equipos reducen la
    potencia para protegerse.]
  ],
)

#q("C-T6.4", "b",
  [Una antena helicoidal se usa:],
  (
    [Para poder emplear la misma antena para la banda de 144 y 432 MHz],
    [Para enlaces por satélites],
    [Porque permiten orientarlas con más facilidad que las colineales],
    [Porque son las más efectivas para hacer las ruedas de aficionados],
  ),
  sol: [
    La hélice, en su modo normal de trabajo (modo axial), radia con polarización circular y un
    lóbulo directivo a lo largo de su eje. La polarización circular es la adecuada para los enlaces
    por satélite: el satélite gira y cambia de orientación respecto de la estación y, además, la
    ionosfera rota la polarización de la onda, de modo que una polarización lineal fija se
    desvanecería por momentos. Las otras opciones son falsas: la hélice no está pensada para
    trabajar en dos bandas (a), al ser directiva hay que orientarla, y es más incómoda que una
    colineal omnidireccional (c), y para las ruedas locales bastan una vertical o una Yagi (d).
    #no-esta[Antena helicoidal: hilo arrollado en espiral (hélice) delante de un plano reflector. Trabajando
    en modo axial es directiva en la dirección de su eje y su polarización es circular (el campo
    eléctrico gira); su ganancia crece con el número de espiras. Esa polarización circular es la que
    se emplea en comunicaciones por satélite, porque no depende de cómo quede orientada la antena
    del satélite ni de la rotación de Faraday que introduce la ionosfera.]
  ],
)

#q("C-T6.5", "c",
  [Las antenas y las líneas de alimentación:],
  (
    [No pueden ser de distinta impedancia],
    [Necesitan siempre interconectarse por adaptadores],
    [Necesitan adaptadores o no según sus impedancias],
    [Forman un conjunto resonante],
  ),
  sol: [
    Si la impedancia de la antena coincide con la de la línea (por ejemplo, antena de 50 Ω y coaxial
    de 50 Ω) se conectan directamente: no hay reflexión y no hace falta adaptador. Si difieren mucho
    hay que intercalar un adaptador (transformador, tramo de cuarto de onda o acoplador de antena)
    para evitar la onda estacionaria, y un balun si además una es simétrica y la otra no. Una
    diferencia pequeña se tolera: un dipolo de 73 Ω con coaxial de 50 Ω da una ROE de 1,46. Por eso
    a y b son falsas. La opción d tampoco es una regla: lo esencial es la adaptación de impedancias,
    no que el conjunto resuene. #vease[(Véase tema T6, sección «Líneas de transmisión y
    adaptación».)]
  ],
)

#q("C-T6.6", "c",
  [Los elementos variables de que, generalmente, se dispone en serie en la base de una antena para
ajustar a la resonancia son:],
  (
    [Una resistencia y una bobina],
    [Dos reóstatos],
    [Una bobina y un condensador],
    [Un condensador y una resistencia],
  ),
  sol: [
    Ajustar a la resonancia es anular la reactancia de la antena. Una antena más corta que la
    resonante es capacitiva y se compensa con una bobina en serie; una más larga es inductiva y se
    compensa con un condensador en serie. Por eso en la base se dispone una bobina variable y un
    condensador variable, y se ajustan hasta que la corriente de antena es máxima. Las resistencias
    y los reóstatos no sirven: no cancelan reactancia, solo disipan potencia en forma de calor.
    Tampoco sirven interruptores, fusibles ni lámparas, que aparecen como distractores en otras
    versiones de la pregunta. #vease[(Véase tema T6, sección «El dipolo y otras antenas» (antena
    corta: reactancia capacitiva; larga: inductiva), y el apartado sobre adaptación del capítulo de
    fundamentos.)]
  ],
)

#q("C-T6.7", "b",
  [Para alargar y acortar la longitud de una antena para usarla como multibanda se conectan:],
  (
    [Circuitos L-C serie a determinadas distancias del centro],
    [Circuitos L-C paralelos a determinadas distancias del centro],
    [Circuitos L-C serie en la línea de alimentación de antena],
    [Circuitos L-C paralelos en la línea de alimentación de antena],
  ),
  sol: [
    Son las trampas: circuitos L-C en paralelo intercalados en cada brazo, a determinada distancia
    del centro. A su frecuencia de resonancia, un circuito paralelo presenta impedancia máxima y
    aísla el tramo exterior del brazo, de modo que la antena queda con la longitud propia de esa
    banda. En la banda más baja la trampa se comporta como una bobina y el hilo exterior sí
    participa, con lo que la antena se alarga. Un circuito serie tendría impedancia mínima en su
    resonancia y no aislaría nada (a), y colocados en la línea de alimentación (c y d) no cambiarían
    la longitud de la antena. La clave publicada suele dar la a: es un error. #vease[(Véase tema T6,
    sección «El dipolo y otras antenas».)]
    #no-esta[Resonancia paralelo: un circuito L-C en paralelo («tanque») presenta impedancia máxima a su
    frecuencia de resonancia —para ella es un muro— y uno en serie, mínima. Por eso las trampas son
    circuitos paralelos: intercaladas en los brazos de un dipolo, en la banda alta cortan el hilo
    exterior y dejan solo el tramo interior resonante; en la banda baja, por debajo de su
    resonancia, actúan como una bobina de carga y el tramo exterior vuelve a contar, con lo que la
    antena se alarga.]
    #_apb1-clave[«Circuitos L-C serie a determinadas distancias del centro». Es la clave que dan las
    recopilaciones de exámenes reales (2007–2011): conviene conocerla por si aparece idéntica en el
    examen, aunque la respuesta razonada arriba sea la técnicamente correcta.]
  ],
)

#q("C-T6.8", "d",
  [De los diversos procedimientos que a continuación se indican, para aumentar el alcance de una
emisora el primero al que hay que recurrir, si es factible, es el siguiente:],
  (
    [Aumentar la potencia de emisión],
    [Aumentar la anchura de banda],
    [Aumentar la tensión del paso final],
    [Aumentar la directividad de la antena],
  ),
  sol: [
    La antena es la forma más económica y eficaz de ganar alcance. Una antena más directiva
    concentra la energía en la dirección del corresponsal —equivale a radiar más potencia en ese
    sentido— y, por reciprocidad, capta también mejor sus señales. Duplicar la potencia del
    transmisor solo aporta 3 dB y exige un amplificador; una antena de 10 dBd multiplica por 10 la
    potencia efectiva radiada sin gastar un vatio más. Aumentar la anchura de banda (b) no da
    alcance, y subir la tensión del paso final (c) es otra manera de subir potencia, con los mismos
    inconvenientes que a. En la variante «se aumenta el alcance de una emisora si se aumenta…», la
    respuesta es igualmente la directividad de la antena: la reactancia, la polarización negativa de
    rejilla y la corriente inversa de pico no influyen en el alcance. #vease[(Véase tema T6, sección
    «El dipolo y otras antenas».)]
  ],
)

#q("C-T6.9", "a",
  [La influencia de un condensador en serie en la base de la antena es:],
  (
    [Aumentar su frecuencia de resonancia],
    [Disminuir su frecuencia de resonancia],
    [No influye en la frecuencia de resonancia],
    [Mejora la estabilidad de la frecuencia],
  ),
  sol: [
    Un condensador en serie añade reactancia capacitiva, que se resta de la reactancia inductiva que
    presenta el hilo por encima de su resonancia: la antena se comporta como si fuese más corta.
    Como una antena más corta resuena a una frecuencia más alta, el condensador sube la frecuencia
    de resonancia; es el efecto contrario al de una bobina de carga, que la baja (b falsa, c falsa).
    La estabilidad de la frecuencia (d) depende del oscilador del transmisor, no de la antena.
    #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]
    #no-esta[Bobina y condensador en serie con la antena. Una bobina añade reactancia inductiva: alarga
    eléctricamente la antena y baja su frecuencia de resonancia (bobinas de carga). Un condensador
    añade reactancia capacitiva, que compensa la inductiva de una antena demasiado larga para la
    banda: la acorta eléctricamente y sube su frecuencia de resonancia. Regla: bobina, alargar y
    bajar la frecuencia; condensador, acortar y subirla.]
  ],
)

#q("C-T6.10", "a",
  [Se ajustan los elementos de resonancia de la antena variándolos de modo que la corriente en la
misma:],
  (
    [Alcance un máximo],
    [Presente un mínimo],
    [Se mantenga invariable],
    [Haga saltar chispas en el condensador de antena],
  ),
  sol: [
    En resonancia se anula la reactancia del conjunto (antena más elementos de ajuste) y solo queda
    la resistencia: la impedancia es mínima y, con la misma tensión aplicada, la corriente es
    máxima. Por eso se ajustan la bobina o el condensador de antena mirando el amperímetro de antena
    hasta que marque el máximo. Una corriente mínima indica justo lo contrario, una antena muy
    desintonizada; una corriente que no cambia indica que el ajuste no actúa; y las chispas en el
    condensador serían síntoma de sobretensión o de mal aislamiento, nunca el objetivo del ajuste.
    #vease[(Véase tema T6, sección «El dipolo y otras antenas» (resonancia: impedancia resistiva
    pura), y resonancia serie en el capítulo de fundamentos (impedancia mínima, corriente máxima).)]
  ],
)

#q("C-T6.11", "a",
  [Para acortar la longitud eléctrica de una antena se puede proceder a:],
  (
    [Insertar un condensador, en serie, en la base],
    [Alargar la longitud del hilo de antena],
    [Aumentar la corriente de antena],
    [Modular menos profundamente],
  ),
  sol: [
    Un condensador en serie en la base añade reactancia capacitiva y hace que la antena se comporte
    como si tuviera menos hilo: su longitud eléctrica disminuye y resuena más alto. Alargar el hilo
    (b) hace justo lo contrario. La corriente de antena (c) y la profundidad de modulación (d) no
    cambian la longitud de la antena, solo la potencia radiada o la calidad de la señal. Ojo al
    sentido inverso: para que una antena físicamente corta resuene en una frecuencia más baja, lo
    que se añade es una bobina de carga, que la alarga eléctricamente. #vease[(Véase tema T6,
    sección «El dipolo y otras antenas».)]
    #no-esta[Longitud eléctrica de una antena: la que «ve» la señal, que puede diferir de la física al
    intercalar elementos reactivos en serie. Un condensador acorta eléctricamente la antena (sube su
    frecuencia de resonancia) y se usa cuando el hilo es demasiado largo para la banda. Una bobina
    la alarga (baja la frecuencia de resonancia) y se usa, como bobina de carga, cuando el hilo es
    demasiado corto.]
  ],
)

#q("C-T6.12", "c",
  [El cable que une la antena al emisor debe:],
  (
    [Ser aéreo],
    [Estar enterrado],
    [Estar apantallado],
    [No ser de acero ni estar enterrado],
  ),
  sol: [
    La línea de alimentación tiene que llevar la señal a la antena sin radiar ella misma y sin
    captar interferencias. Por eso se emplea cable apantallado (coaxial): el conductor central va
    rodeado de una malla, conectada a masa, que confina el campo dentro del cable. Que el cable sea
    aéreo o vaya enterrado (a y b) no es una condición: lo que se exige es el apantallado. La opción
    d tampoco recoge una exigencia de la línea de alimentación. #vease[(Véase tema T6, sección
    «Líneas de transmisión y adaptación» (coaxial y malla), y tema T9 (apantallamiento).)]
    #no-esta[Un cable coaxial consta de conductor central, dieléctrico y malla exterior. La malla encierra el
    campo electromagnético: el cable no radia, sus características no dependen de los metales ni del
    suelo que tenga cerca, y no capta ruido ni interferencias. Esa es la razón de usar cable
    apantallado entre el emisor y la antena. La línea bifilar abierta es la excepción, pero exige
    simetría y mantenerla alejada de objetos metálicos.]
  ],
)

#q("C-T6.13", "c",
  [El diagrama de radiación de una antena nos da:],
  (
    [La banda de frecuencias que puede radiar en las distintas direcciones],
    [El alcance de la radiación en función de la dirección],
    [La distribución de la energía radiada en el espacio],
    [La distribución de su adaptación en el espacio],
  ),
  sol: [
    El diagrama de radiación es la representación gráfica de cómo se reparte en el espacio la
    energía que radia la antena: muestra la intensidad relativa en cada dirección (lóbulo principal,
    lóbulos secundarios y nulos). Es una propiedad de la dirección, no de la banda de frecuencias
    (a) ni de la adaptación (d), que depende de la impedancia. El alcance (b) depende además de la
    potencia, de la propagación y del receptor; el diagrama solo lo condiciona de forma indirecta.
    #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]
    #no-esta[Diagrama de radiación: gráfica, polar o en tres dimensiones, de la intensidad radiada en cada
    dirección respecto de la antena. El lóbulo principal indica hacia dónde radia más; de él se leen
    el ancho de haz, la relación adelante-atrás y los nulos.]
  ],
)

#q("C-T6.14", "d",
  [Cuando se dice que una antena está sintonizada:],
  (
    [Cuando se sintonice con condensador],
    [Si está polarizada respecto a tierra],
    [Si la señal resuena en frecuencias altas],
    [Si la antena resuena a la frecuencia de la señal],
  ),
  sol: [
    Una antena está sintonizada cuando resuena a la frecuencia de la señal con la que se la
    alimenta: su longitud eléctrica es la adecuada y su impedancia es resistiva pura, sin
    reactancia. Sintonizar con un condensador (a) es solo una de las maneras de ajustar una antena,
    no su definición. La polarización respecto a tierra (b) es la orientación del campo radiado, y
    nada tiene que ver con la sintonía. Y quien resuena es la antena, no la señal, y no solo en
    frecuencias altas (c). #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]
  ],
)

#q("C-T6.15", "c",
  [En una línea de transmisión, la relación de onda estacionaria es:],
  (
    [Potencia del transmisor − atenuación del cable entre transmisor y antena],
    [Potencia máxima / potencia mínima],
    [$(|V_"máx"|) / (|V_"mín"|)$],
    [$(|V_"máx"| + |V_"mín"|) / (|V_"máx"| − |V_"mín"|)$],
  ),
  sol: [
    La onda estacionaria resulta de sumar la onda directa y la reflejada: sus máximos de tensión
    valen $V_d + V_r$ y sus mínimos $V_d − V_r$. La ROE es el cociente entre ambos, ROE
    $= V_"máx" slash V_"mín" = (1 + |ρ|) slash (1 − |ρ|)$, y sale lo mismo con las intensidades. La
    opción d da $2V_d slash 2V_r = 1 slash |ρ|$, que no es la ROE. La relación de potencias
    máxima/mínima (b) sería el cuadrado de la ROE, y la resta de a es simplemente la potencia que
    llega a la antena, sin ninguna onda estacionaria de por medio. #vease[(Véase tema T6, sección
    «Líneas de transmisión y adaptación».)]
  ],
)

#q("C-T6.16", "b",
  [¿Qué respuesta es cierta para una antena que radie en condiciones ideales de espacio libre?],
  (
    [Al aplicarle una potencia de 100 vatios la ROE estará por encima de 1,2.],
    [La potencia aplicada y la ROE medida no tendrán nada que ver.],
    [Al aplicarle una potencia de 1000 vatios la ROE estará entre 1,1 y 1,5.],
    [Al aplicarle una potencia de 10 vatios la ROE será de 1.],
  ),
  sol: [
    La ROE depende solo de cuánto difiere la impedancia de la antena de la de la línea:
    $ρ = (Z_L − Z_0) slash (Z_L + Z_0)$. En el espacio libre ideal (sin objetos cercanos, sin arcos
    ni calentamientos) la impedancia de la antena no cambia con la potencia aplicada, y la ROE es la
    misma con 10 W que con 1000 W. Las otras tres opciones ligan un valor concreto de ROE a una
    potencia concreta, cosa que no tiene fundamento: con 10 W la ROE valdrá 1 solo si la antena está
    perfectamente adaptada, y eso es independiente de la potencia. #vease[(Véase tema T6, sección
    «Líneas de transmisión y adaptación».)]
    #no-esta[La ROE mide la adaptación de impedancias, no la potencia: una antena lineal presenta la misma
    impedancia con 1 W que con 1000 W, y por tanto la misma ROE. Solo en casos no ideales (arcos,
    calentamiento de una trampa o de un núcleo de ferrita, cambios del entorno) la ROE varía con la
    potencia, y entonces es síntoma de avería o de instalación defectuosa.]
  ],
)

#q("C-T6.17", "c",
  [La relación entre la longitud física de un cable y su longitud eléctrica es:],
  (
    [Las dos longitudes son iguales],
    [La diferencia de las dos],
    [La longitud física es igual a la eléctrica, multiplicada por el factor de velocidad de
propagación],
    [La longitud física es mayor que la eléctrica],
  ),
  sol: [
    En un cable la onda avanza más despacio que en el aire: lo hace a la fracción FV $= v slash c$
    de la velocidad de la luz (factor de velocidad), siempre menor que 1 (0,66 en el coaxial de
    polietileno). Su longitud de onda dentro del cable es también FV veces menor, así que una
    longitud eléctrica dada (la que tendría en el aire) ocupa menos cable: $L_("fis") = L_("el")$ ×
    FV. Por ejemplo, un cuarto de onda a 14 MHz es 5,36 m en el aire y en coaxial de FV = 0,66 son
    5,36 × 0,66 ≈ 3,5 m. La física es, pues, menor que la eléctrica (d es falsa), y solo coinciden
    si FV = 1 (a). Una «relación» es un cociente, no una diferencia (b). Algunas listas publicadas
    dan por buena la d: es un error. #vease[(Véase tema T6, sección «Líneas de transmisión y
    adaptación».)]
    #no-esta[Longitud eléctrica: la que tendría en el aire el tramo que produce el mismo desfase. Como la
    onda va más lenta en el cable, el tramo físico necesario es más corto: $L_("fis") = L_("el")$ ×
    FV, con FV igual al inverso de la raíz cuadrada de la constante dieléctrica del aislante (≈0,66
    en polietileno, 1 en el vacío). Por eso un «cuarto de onda» de coaxial mide menos que el cuarto
    de onda en el aire.]
    #_apb1-clave[«La longitud física es mayor que la eléctrica». Es la clave que dan las recopilaciones de
    exámenes reales (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la
    respuesta razonada arriba sea la técnicamente correcta.]
  ],
)

#q("C-T6.18", "b",
  [Entre las antenas de apertura están:],
  (
    [Las yagis.],
    [Las de bocina.],
    [Las verticales.],
    [Los dipolos.],
  ),
  sol: [
    Las antenas de apertura radian a través de una abertura (una boca) por la que sale el campo: la
    bocina, el reflector parabólico con su alimentador, la guía ranurada. Se emplean en microondas,
    donde las dimensiones de la apertura son manejables. Las Yagis, las verticales y los dipolos
    son, en cambio, antenas de hilo, formadas por elementos lineales. #vease[(Véase tema T6, sección
    «El dipolo y otras antenas».)]
  ],
)

#q("C-T6.19", "d",
  [Señale el diagrama de radiación correspondiente a una antena Yagi:],
  (
    [#box(baseline: 45%, _apb1-donut(1))],
    [#box(baseline: 45%, _apb1-rosa)],
    [#box(baseline: 45%, _apb1-donut(2))],
    [#box(baseline: 45%, _apb1-yagi)],
  ),
  sol: [
    La Yagi es una antena directiva: el reflector y los directores, que son elementos parásitos,
    concentran la radiación hacia delante. Su diagrama es un lóbulo principal grande, con un lóbulo
    trasero y lóbulos laterales muy pequeños: la figura d). Las figuras a) y c) son toros, con
    máximo en todo el plano horizontal y nulo en el eje vertical, es decir, radiación
    omnidireccional, propia de una vertical o de un dipolo vertical (la a, más aplastada; la c, más
    redondeada). La b) reparte la energía en varios lóbulos de tamaño parecido y direcciones
    distintas, sin una dirección privilegiada, como en las antenas largas de varias longitudes de
    onda. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]
    #no-esta[Un diagrama de radiación en tres dimensiones es la superficie que une los puntos donde la antena
    radia con la misma intensidad relativa: cuanto más lejos del centro, más campo en esa dirección.
    Conviene reconocer tres formas. El #strong[toro] es el de un dipolo o una vertical: nulo en la
    dirección de su eje y máximo en todo el plano perpendicular, omnidireccional en ese plano. El
    #strong[lóbulo único] es el de una Yagi o una parabólica: una dirección de máxima radiación, más
    estrecha cuantos más directores lleva la antena, con un lóbulo trasero pequeño (la relación
    adelante-atrás). Los diagramas de #strong[muchos lóbulos] corresponden a antenas largas, de
    varias longitudes de onda. Para distinguir a la vista una antena directiva de una
    omnidireccional basta buscar un lóbulo que destaque claramente sobre los demás.]
  ],
)

#q("C-T6.20", "d",
  [¿Qué ventajas presenta la antena dipolo en V invertida?],
  (
    [Un valor de impedancia próximo a 75 Ω y polarización circular.],
    [Un valor de impedancia próximo a 75 Ω y un diagrama de radiación muy directivo.],
    [Un valor de impedancia constante y elevada ganancia.],
    [Un valor de impedancia próximo a 50 Ω y un diagrama de radiación prácticamente omnidireccional.],
  ),
  sol: [
    La V invertida es un dipolo con el centro arriba, en el mástil, y los brazos caídos hacia el
    suelo. Al inclinarlos, la impedancia en el punto de alimentación baja de ∼73 Ω a ∼50 Ω, justo la
    del coaxial de los equipos, y el diagrama se redondea: en el plano horizontal resulta casi
    omnidireccional. No hay polarización circular (a), ni diagrama muy directivo (b: eso es propio
    de una Yagi), ni impedancia «constante» y ganancia elevada (c): sigue siendo un dipolo, de unos
    2,15 dBi. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]
    #no-esta[#strong[Dipolo en V invertida.] Es un dipolo de media onda alimentado en el centro que se cuelga
    de un único mástil, con los brazos inclinados hacia el suelo y un ángulo entre ellos de unos 90
    a 120 grados. Al inclinar los brazos, la impedancia del punto de alimentación baja de los ∼73 Ω
    del dipolo horizontal hacia ∼50 Ω, la del coaxial habitual. El diagrama también cambia: los
    brazos inclinados añaden una componente de polarización vertical y los nulos que el dipolo
    horizontal tiene en la dirección de sus extremos se atenúan, de modo que en el plano horizontal
    se acerca a un diagrama omnidireccional. Sigue siendo un dipolo, con unos 2,15 dBi de ganancia:
    nada directivo.]
  ],
)

#q("C-T6.21", "c",
  [Señale la conexión correcta entre equipos:],
  (
    [#_apb1-cadena("acop", "roe", "amp")],
    [#_apb1-cadena("roe", "acop", "amp")],
    [#_apb1-cadena("amp", "roe", "acop")],
    [#_apb1-cadena("amp", "acop", "roe")],
  ),
  sol: [
    El orden canónico es transceptor, amplificador lineal, medidor de ROE, acoplador de antena y
    antena (opción c). El lineal va pegado al transceptor porque es éste quien lo excita; el medidor
    de ROE, a su salida, vigila la adaptación que ve el amplificador; y el acoplador, justo antes de
    la antena, se ajusta hasta que el medidor marca 1:1. En a) y b) el acoplador o el medidor quedan
    entre el transceptor y el lineal, de modo que el amplificador sale directo a la antena sin
    adaptar ni medir. En d) el acoplador precede al medidor: éste mide ya tras el ajuste y no
    muestra si el transmisor ve 50 Ω. #vease[(Véase tema T6, sección «La estación y su
    adaptación».)]
  ],
)

#q("C-T6.22", "c",
  [Señale la configuración de conexión de equipos correcta:],
  (
    [#_apb1-cadena("acop", "amp")],
    [#_apb1-cadena("acop", "roe")],
    [#_apb1-cadena("roe", "acop")],
    [#_apb1-cadena("campo", "amp")],
  ),
  sol: [
    Sin amplificador, el orden es transceptor, medidor de ROE, acoplador de antena y antena (opción
    c): el medidor, a la salida del transceptor, mide la adaptación que éste ve, y se retoca el
    acoplador hasta que marque 1:1. En b) el acoplador va antes del medidor, que solo vería la línea
    de antena y no indicaría si el transmisor está adaptado. En a) falta el medidor y el acoplador
    queda entre transceptor y amplificador, con el lineal conectado directo a la antena. En d) no
    hay acoplador, y el medidor de campo es un instrumento de recepción (mide la intensidad de campo
    radiada), que no se intercala en la línea. #vease[(Véase tema T6, sección «La estación y su
    adaptación».)]
  ],
)

== Tema T7. Propagación <apb1-t7>

#q("C-T7.1", "c",
  [Un enlace radioeléctrico entre España y Nueva Zelanda podría emplear:],
  (
    [una frecuencia de la banda HF por encima de la frecuencia crítica],
    [cualquier frecuencia múltiplo de la frecuencia crítica],
    [una frecuencia de la banda HF por debajo de la frecuencia crítica],
    [ninguna de las respuestas anteriores es correcta],
  ),
  sol: [
    España y Nueva Zelanda son casi antípodas (cerca de 20 000 km): solo se llega por HF, con la
    onda de espacio reflejada en la ionosfera a varios saltos. Una frecuencia #emph[por debajo] de
    la frecuencia crítica $f_c$ se refleja siempre, con cualquier ángulo de incidencia, así que el
    enlace es posible: es la respuesta del examen. La a) no sirve como regla, porque por encima de
    $f_c$ la onda solo regresa con incidencia oblicua y hasta la MUF; pasada esta, atraviesa la
    ionosfera y se pierde. La b) es falsa: un múltiplo cualquiera ($2f_c$, $10f_c$ …) puede rebasar
    la MUF. #vease[(Véase tema T7, sección «La ionosfera y la onda de espacio».)]
    #no-esta[La frecuencia crítica $f_c$ es la mayor frecuencia que la ionosfera refleja cuando la onda sube
    en vertical. Todo lo que está por debajo de $f_c$ vuelve a tierra con cualquier ángulo (aunque
    de día la capa D absorbe las más bajas). Lo que está por encima solo vuelve si incide de forma
    oblicua, y deja de volver al superar la MUF ($f_c slash cos θ$). Por eso, cuando una pregunta
    habla de la frecuencia crítica sin más precisiones, el examen da por buena la frecuencia
    #emph[por debajo] de $f_c$ y descarta la que queda por encima.]
  ],
)

#q("C-T7.2", "b",
  [Las reflexiones lunares se hacen principalmente en:],
  (
    [ondas decamétricas],
    [ondas métricas],
    [ondas decimétricas],
    [ondas milimétricas],
  ),
  sol: [
    El rebote lunar (EME) necesita una frecuencia que atraviese la ionosfera, lo que deja fuera en
    la práctica a las decamétricas (HF), y antenas de ganancia elevada pero manejables. La banda de
    EME por excelencia es la de 144 MHz (2 m): ondas métricas. También se usan 432 MHz
    (decimétricas) y las microondas, pero con mucha menos actividad. Las milimétricas (30–300 GHz)
    casi no se emplean: la atmósfera las atenúa mucho y el apuntado es muy crítico. #vease[(Véase
    tema T7, sección «Fenómenos de propagación».)]
    #no-esta[El rebote lunar (EME, #emph[Earth-Moon-Earth]) usa la Luna como reflector pasivo: 770 000 km de
    ida y vuelta y del orden de 250 dB de pérdidas a 144 MHz. La señal debe cruzar la ionosfera, así
    que hacen falta VHF o frecuencias superiores. La banda clásica y más concurrida es 144 MHz (2 m,
    ondas métricas); le siguen 432 y 1296 MHz y algunas microondas.]
  ],
)

#q("C-T7.3", "c",
  [La gama de frecuencias comprendida entre 300 y 3000 MHz corresponde a las:],
  (
    [ondas kilométricas],
    [ondas decamétricas],
    [ondas decimétricas],
    [ondas milimétricas],
  ),
  sol: [
    Es la banda UHF. Con $λ = c slash f$: a 300 MHz, $λ = 1$ m, y a 3000 MHz, $λ = 0,1$ m = 10 cm.
    Longitudes de onda de 10 a 100 cm, decenas de centímetros: ondas decimétricas. Las kilométricas
    son 30–300 kHz (LF), las decamétricas 3–30 MHz (HF) y las milimétricas 30–300 GHz (EHF).
    #vease[(Véase tema T7, sección «Cómo se nombran las bandas».)]
  ],
)

#q("C-T7.4", "b",
  [En condiciones normales, para una misma potencia radiada, las ondas que llegarían con más
intensidad a un punto alejado serían:],
  (
    [cualquiera de las superiores a 144 MHz],
    [las de 144 MHz],
    [las de 430 MHz],
    [las superiores a 430 MHz],
  ),
  sol: [
    Con la misma potencia radiada y antenas de igual ganancia, la atenuación crece con la
    frecuencia: $L = 32,4 + 20 log_10 f + 20 log_10 d$. Pasar de 144 a 430 MHz añade
    $20 log_10(430 slash 144) ≈ 9,5$ dB de pérdida, y a frecuencias aún mayores, más. Además la
    lluvia, la vegetación y los obstáculos atenúan más cuanto más alta es la frecuencia. Llega más
    fuerte la señal de menor frecuencia, la de 144 MHz; las otras tres opciones son frecuencias más
    altas. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]
  ],
)

#q("C-T7.5", "c",
  [La gama de frecuencias comprendida entre 30 y 300 MHz se conoce por el símbolo:],
  (
    [VLF],
    [HF],
    [VHF],
    [EHF],
  ),
  sol: [
    Cada banda UIT abarca una década: VLF 3–30 kHz, LF 30–300 kHz, MF 300 kHz–3 MHz, HF 3–30 MHz,
    VHF 30–300 MHz, UHF 300–3000 MHz, SHF 3–30 GHz y EHF 30–300 GHz. El margen de 30 a 300 MHz es
    VHF (#emph[Very High Frequency]), ondas métricas de 1 a 10 m; ahí está, por ejemplo, la banda de
    2 m. VLF queda varias décadas por debajo, HF una década por debajo y EHF muy por encima.
    #vease[(Véase tema T7, sección «Cómo se nombran las bandas».)]
  ],
)

#q("C-T7.6", "a",
  [La abreviatura HF indica la subdivisión métrica correspondiente a ondas:],
  (
    [decamétricas],
    [métricas],
    [kilométricas],
    [hectométricas],
  ),
  sol: [
    La «subdivisión métrica» es el nombre por longitud de onda que la UIT asigna a cada banda. HF
    (#emph[High Frequency]) va de 3 a 30 MHz, es decir, de 100 a 10 m: decenas de metros, ondas
    decamétricas. Las métricas corresponden a VHF (30–300 MHz), las hectométricas a MF (300 kHz–3
    MHz) y las kilométricas a LF (30–300 kHz). #vease[(Véase tema T7, sección «Cómo se nombran las
    bandas».)]
  ],
)

#q("C-T7.7", "a",
  [La banda de 430 a 440 MHz pertenece a las ondas:],
  (
    [UHF],
    [métricas],
    [VHF],
    [SHF],
  ),
  sol: [
    Los 430–440 MHz (la banda de 70 cm, $λ ≈ 300 slash 435 ≈ 0,7$ m) caen dentro del margen de 300 a
    3000 MHz, que es UHF: ondas decimétricas. «Métricas» y VHF son la misma banda, que termina en
    300 MHz; SHF (centimétricas) empieza en 3 GHz. #vease[(Véase tema T7, sección «Cómo se nombran
    las bandas».)]
  ],
)

#q("C-T7.8", "d",
  [La gama de frecuencias comprendida entre 30 y 300 kHz corresponde a las ondas:],
  (
    [decimétricas],
    [métricas],
    [centimétricas],
    [kilométricas],
  ),
  sol: [
    Es la banda LF. Con $λ ("m") = 300 thin 000 slash f$ (kHz): a 30 kHz resultan 10 000 m y a 300
    kHz, 1000 m. Longitudes de 1 a 10 km: ondas kilométricas. Las decimétricas (UHF), las métricas
    (VHF) y las centimétricas (SHF) están muy por encima, en MHz y GHz. #vease[(Véase tema T7,
    sección «Cómo se nombran las bandas».)]
  ],
)

#q("C-T7.9", "c",
  [La frecuencia de 144 MHz está incluida en las ondas:],
  (
    [milimétricas],
    [kilométricas],
    [métricas],
    [hectométricas],
  ),
  sol: [
    A 144 MHz, $λ = 300 slash 144 ≈ 2,08$ m (la banda de 2 m). Está entre 30 y 300 MHz: VHF, ondas
    métricas (1–10 m). Las milimétricas son EHF (30–300 GHz), las kilométricas LF (30–300 kHz) y las
    hectométricas MF (300 kHz–3 MHz). #vease[(Véase tema T7, sección «Cómo se nombran las bandas».)]
  ],
)

#q("C-T7.10", "d",
  [La onda que rebasa el horizonte y llega a la atmósfera se denomina:],
  (
    [onda de horizonte visto],
    [onda de transmisión directa],
    [onda especial indirecta],
    [onda espacial],
  ),
  sol: [
    La onda espacial (en este cuaderno, onda de espacio) sale de la antena hacia arriba, rebasa el
    horizonte, alcanza la ionosfera y regresa a tierra por refracción en ella; es la del DX en HF.
    La onda directa viaja en visión directa y no pasa del horizonte radioeléctrico. «Onda de
    horizonte visto» y «onda especial indirecta» no son tipos de propagación; ojo con «especial»,
    que no es «espacial». #vease[(Véase tema T7, sección «La ionosfera y la onda de espacio».)]
  ],
)

#q("C-T7.11", "b",
  [Si una onda electromagnética atraviesa un objeto, se produce un efecto de:],
  (
    [reflexión],
    [atenuación],
    [intermodulación],
    [amplificación],
  ),
  sol: [
    Al atravesar un objeto (un muro, un árbol, una persona), la onda cede parte de su energía y sale
    con menos intensidad: se atenúa. La reflexión ocurre en la superficie y devuelve parte de la
    onda sin atravesarla; la intermodulación es cosa de los elementos no lineales (amplificadores,
    mezcladores), no de un obstáculo pasivo; y un objeto pasivo no aporta energía, así que no puede
    amplificar. #vease[(Véase tema T7, introducción (atenuación de la señal).)]
    #no-esta[Cuando una onda encuentra un obstáculo pueden darse varios efectos: #strong[reflexión] (parte
    rebota en la superficie), #strong[refracción] (cambia de dirección al pasar de un medio a otro),
    #strong[difracción] (se curva al rodear bordes) y #strong[absorción o atenuación] (si lo
    atraviesa, pierde energía en forma de calor). La pérdida es tanto mayor cuanto más grueso o más
    conductor es el obstáculo.]
  ],
)

#q("C-T7.12", "b",
  [¿Qué ha pasado probablemente si en la frecuencia en la que llevabas media hora haciendo un QSO
aparecen hablando otras estaciones de otro QSO?],
  (
    [Se han puesto a comunicar encima de tu propia frecuencia.],
    [Ha variado la propagación y la distancia de salto.],
    [Se han desplazado desde otra frecuencia porque su frecuencia varía.],
    [No han preguntado si la frecuencia estaba ocupada y se han puesto a hablar sin más.],
  ),
  sol: [
    En HF, dos QSO pueden compartir frecuencia sin oírse: cada pareja queda en la zona de silencio
    de la otra, entre donde muere la onda de superficie y donde aterriza la onda reflejada. La
    ionosfera cambia con la hora, la estación y la actividad solar: al variar la frecuencia crítica
    y la MUF cambia la distancia de salto, y estaciones que antes no oías aparecen en tu frecuencia.
    Es lo más probable tras media hora de QSO. La a y la d suponen que alguien te oyó y transmitió
    encima (posible, pero mala práctica, y no explica por qué aparecen ahora); la c trata una deriva
    de frecuencia que nada tiene que ver con la propagación. #vease[(Véase tema T7, secciones «La
    ionosfera y la onda de espacio» (distancia de salto y zona de silencio) y «Fenómenos de
    propagación».)]
    #no-esta[La zona de silencio es la región entre el alcance de la onda de superficie y el punto donde cae
    la onda reflejada en la ionosfera: ahí no se recibe la señal. La distancia de salto depende de
    la frecuencia crítica, de la MUF y del ángulo de radiación, y estos varían con la hora del día,
    la estación del año y el ciclo solar; por eso el mapa de quién oye a quién cambia con el tiempo
    y puede aparecer de pronto otro QSO en tu frecuencia. Antes de llamar conviene preguntar si está
    ocupada («QRL?»).]
  ],
)

#q("C-T7.13", "b",
  [En el siguiente gráfico, si la antena emite tres señales en distintas frecuencias, ¿cuál de ellas tiene una frecuencia superior a la frecuencia crítica?
    #circuito(caption: none)[
      #_apb1-iono
    ]],
  (
    [Las señales 1 y 2.],
    [La señal 1.],
    [La señal 3.],
    [Las señales 1 y 3.],
  ),
  sol: [
    La frecuencia crítica $f_c$ es la más alta que la ionosfera refleja cuando la onda sube en
    vertical; lo que la supera atraviesa la capa y se pierde en el espacio. La señal 1 es la única
    que cruza la ionosfera y escapa: su frecuencia es mayor que $f_c$. La 2 se refleja y vuelve a
    tierra, luego está por debajo de $f_c$. La 3 ni siquiera sube: viaja pegada al suelo (onda de
    superficie), propia de las frecuencias más bajas. Las demás opciones incluyen la 2 o la 3, que
    no superan $f_c$. #vease[(Véase tema T7, sección «La ionosfera y la onda de espacio».)]
  ],
)

== Tema T8. Medidas <apb1-t8>

#q("C-T8.1", "d",
  [En la realización de medidas, usando un polímetro, indique la respuesta correcta:],
  (
    [para medidas de tensión, se conectan las puntas de prueba en serie con el elemento en el que
deseamos medir la tensión],
    [para medidas de corriente, se conectan las puntas de prueba en paralelo con el elemento a través
del cual circula la corriente que deseamos medir],
    [para medidas de resistencia, se conectan las puntas de prueba en serie con la resistencia que
deseamos medir],
    [ninguna de las respuestas anteriores es correcta],
  ),
  sol: [
    Las tres afirmaciones están al revés. La tensión se mide con las puntas en #emph[paralelo] con
    el elemento. La corriente se mide en #emph[serie]: se abre el circuito y se intercala el
    polímetro (en paralelo sería un cortocircuito casi directo). La resistencia se mide con el
    componente aislado y sin tensión, con las puntas aplicadas a sus terminales, es decir, en
    paralelo con ella y no en serie. Como las tres son falsas, la correcta es «ninguna de las
    anteriores». #vease[(Véase tema T8, sección «Técnica de medida».)]
    #no-esta[En la función de óhmetro, el polímetro inyecta por las puntas una pequeña corriente propia y
    mide la tensión resultante. Por eso las puntas van en los dos extremos de la resistencia (en
    paralelo con ella), con el componente fuera de tensión y, si está en un circuito, con al menos
    un extremo desconectado; si no, circula corriente de otros componentes y la lectura se falsea.
    Resumen: voltímetro en paralelo, amperímetro en serie, óhmetro en paralelo y sin tensión.]
  ],
)

#q("C-T8.2", "c",
  [Una resistencia en #emph[shunt] irá colocada:],
  (
    [en serie],
    [en mixto con otra en serie],
    [en paralelo],
    [nunca podrá conectarse una resistencia en #emph[shunt]],
  ),
  sol: [
    #emph[Shunt] significa derivación: una resistencia #emph[shunt] se conecta en paralelo con otro
    elemento (por ejemplo, con un amperímetro) y desvía por ella parte de la corriente. Por eso, si
    se pregunta qué indica un shunt, la respuesta es «una resistencia en paralelo con otro
    elemento». En serie no derivaría nada, solo limitaría la corriente; la conexión mixta no define
    un shunt; y sí puede conectarse: es el montaje habitual para ampliar el alcance de un
    amperímetro. #vease[(Véase tema T8, sección «Técnica de medida».)]
  ],
)

#q("C-T8.3", "a",
  [La unidad dBm corresponde a la magnitud:],
  (
    [potencia],
    [frecuencia],
    [tensión],
    [intensidad],
  ),
  sol: [
    El dBm es el decibelio referido a 1 mW: $P ("dBm") = 10 log_10 P / (1 "mW")$. Es, pues, una
    unidad de potencia (1 mW = 0 dBm; 1 W = 30 dBm). La frecuencia se mide en hercios y la
    intensidad en amperios; la tensión, si se expresa en decibelios, va en dBV o dBμV, no en dBm.
    #vease[(Véase tema T8, sección «Técnica de medida».)]
  ],
)

#q("C-T8.4", "c",
  [Para realizar medidas de intensidad de campo radiado por una antena se emplea:],
  (
    [un medidor de ondas estacionarias],
    [un frecuencímetro],
    [un medidor de campo],
    [un acoplador de antenas],
  ),
  sol: [
    La intensidad del campo radiado (en V/m o dBμV/m) se mide con un medidor de campo, un receptor
    calibrado con su antena de medida. El medidor de ondas estacionarias compara la potencia directa
    y la reflejada en la línea y mide la desadaptación de la antena; el frecuencímetro mide
    frecuencia; el acoplador de antenas adapta impedancias y no mide nada. #vease[(Véase tema T8,
    sección «Instrumentos».)]
  ],
)

#q("C-T8.5", "c",
  [Si queremos medir corrientes continuas con un amperímetro cuyo alcance máximo es inferior a las
corrientes a medir, tendremos que:],
  (
    [poner una resistencia en serie],
    [poner un condensador en serie],
    [poner una resistencia en paralelo],
    [no se puede utilizar],
  ),
  sol: [
    Se pone una resistencia #emph[shunt] en paralelo con el amperímetro: desvía la mayor parte de la
    corriente y deja pasar por el aparato solo una fracción conocida. Ejemplo: un instrumento de 1
    mA y 100 Ω con un shunt de 100/9 ≈ 11,1 Ω mide hasta 10 mA (1 mA por el instrumento y 9 mA por
    el shunt). Una resistencia en serie no amplía nada: toda la corriente sigue pasando por el
    instrumento. Un condensador en serie bloquearía la corriente continua. Y sí puede utilizarse,
    con el shunt. #vease[(Véase tema T8, sección «Técnica de medida».)]
  ],
)

#q("C-T8.6", "c",
  [Un medidor «S» típico evalúa la intensidad de señal de entrada a un receptor en:],
  (
    [microamperios],
    [milivatios],
    [microvoltios],
    [microohmios],
  ),
  sol: [
    El S-meter mide el nivel de la señal a la entrada del receptor y su escala está referida a la
    tensión en la antena: S9 = 50 μV sobre 50 Ω (HF), y cada punto S es la mitad (6 dB). Su unidad
    de referencia es, pues, el microvoltio. Aunque el nivel se pueda traducir a potencia (S9 = −73
    dBm), no se expresa en milivatios; los microamperios no son la magnitud de referencia; y los
    microohmios son una resistencia, no un nivel de señal. #vease[(Véase tema T4, sección
    «Características y controles».)]
  ],
)

#q("C-T8.7", "c",
  [El amperímetro de antena es del tipo:],
  (
    [de cuadro móvil],
    [de hierro móvil],
    [de radiofrecuencia],
    [de rectificador de selenio],
  ),
  sol: [
    El amperímetro de antena mide la corriente de radiofrecuencia y debe ser, por tanto, un
    instrumento de RF (normalmente térmico). El de cuadro móvil solo mide continua; el de hierro
    móvil está pensado para alterna de 50 Hz y a RF la reactancia de su bobina lo inutiliza; y el
    rectificador de selenio tiene demasiada capacidad parásita y solo sirve en baja frecuencia.
    #no-esta[El amperímetro de antena se intercala en la base de la antena o en la línea para medir la
    corriente de radiofrecuencia, de la que se deduce la potencia radiada ($P = I^2R$) y se
    comprueba el ajuste del acoplo. Los instrumentos de RF son térmicos (termopar o hilo caliente):
    la corriente calienta un elemento y se mide el calor, de modo que la lectura, en valor eficaz,
    no depende de la frecuencia.]
  ],
)

#q("C-T8.8", "a",
  [Di qué sentencia #strong[no] es cierta:],
  (
    [en un equipo de emisión se suele monitorizar la potencia transmitida y los decibelios con un
S-meter],
    [en un equipo de emisión se suele monitorizar la potencia transmitida y el nivel de compresión
aplicado sobre la señal moduladora antes de que esta module a la portadora],
    [en un equipo de emisión se suele monitorizar la potencia transmitida y la ROE],
    [en un equipo de emisión se suele monitorizar la potencia transmitida y el consumo de la unidad],
  ),
  sol: [
    El S-meter es un instrumento de recepción: su escala de puntos S y de decibelios sobre S9
    describe el nivel de las señales recibidas, no algo que se monitorice en emisión. En un
    transmisor sí se vigilan, junto a la potencia, la ROE (adaptación de la antena), el nivel de
    compresión del procesador de audio (antes de modular) y el consumo de corriente. Por eso la
    falsa es la a). #vease[(Véase tema T4, sección «Características y controles».)]
  ],
)

#q("C-T8.9", "c",
  [Una señal de radio que se recibe con indicación S9 en el S-meter corresponde a un voltaje rms
sobre los 50 Ω del terminal de antena de:],
  (
    [1 μV],
    [100 dBμV],
    [50 μV],
    [1 mV],
  ),
  sol: [
    El convenio de la IARU para HF fija S9 = 50 μV rms sobre 50 Ω, que equivale a 34 dBμV y a −73
    dBm: $P = (50 · 10^(−6))^2 slash 50 = 5 · 10^(−11)$ W. Cada punto S son 6 dB, es decir, el doble
    o la mitad de tensión. 1 μV queda unos 34 dB por debajo de S9 (algo más de S3); 1 mV es S9 + 26
    dB; y 100 dBμV son 0,1 V, unos 66 dB sobre S9. #vease[(Véase tema T4, sección «Características y
    controles».)]
  ],
)

#q("C-T8.10", "c",
  [Para medir la tensión (diferencia de potencial) eléctrica se emplea:],
  (
    [un amperímetro],
    [un óhmetro],
    [un voltímetro],
    [un vatímetro],
  ),
  sol: [
    La tensión o diferencia de potencial se mide en voltios con un voltímetro, conectado en paralelo
    con el elemento. El amperímetro mide corriente (amperios), el óhmetro resistencia (ohmios) y el
    vatímetro potencia (vatios). #vease[(Véase tema T8, sección «Técnica de medida».)]
  ],
)

#q("C-T8.11", "a",
  [Para medir la corriente eléctrica se emplea:],
  (
    [un amperímetro],
    [un óhmetro],
    [un vatímetro],
    [un voltímetro],
  ),
  sol: [
    La corriente se mide en amperios con un amperímetro, intercalado en serie para que toda la
    corriente lo atraviese. El óhmetro mide resistencia, el vatímetro potencia y el voltímetro
    tensión. #vease[(Véase tema T8, sección «Técnica de medida».)]
  ],
)

#q("C-T8.12", "a",
  [Para medir la potencia disipada en la resistencia del circuito de la figura, se deben seleccionar:
    #circuito(caption: none)[
      #_apb1-pot
    ]],
  (
    [Los conmutadores en la posición 1.],
    [Los conmutadores en la posición 2.],
    [Los conmutadores en la posición 1 ó 2, las dos posiciones son válidas.],
    [Ninguna de las anteriores, ya que la potencia solo se puede medir con un vatímetro.],
  ),
  sol: [
    En continua la potencia se mide de forma indirecta, $P = V · I$: hace falta el amperímetro en
    serie con $R$ y el voltímetro en paralelo con ella. El conmutador de la izquierda en 1 pone el
    amperímetro en serie con la fuente y la resistencia (en 2 pondría el voltímetro, que casi no
    deja pasar corriente). El de la derecha en 1 pone el voltímetro en paralelo con $R$ (en 2
    pondría ahí el amperímetro, que la dejaría en cortocircuito). Solo vale, pues, la posición 1 en
    ambos; y no hace falta vatímetro, porque basta multiplicar las dos lecturas. #vease[(Véase tema
    T8, sección «Técnica de medida» (y $P = V I$ en el tema T1, sección «Unidades y leyes
    fundamentales»).)]
  ],
)

== Tema T9. Interferencia e inmunidad <apb1-t9>

#q("C-T9.1", "d",
  [Los medios más comunes para proteger de interferencias a un receptor son:],
  (
    [Sobremodular la señal de entrada.],
    [Transformadores de tensión.],
    [Altavoces de alta impedancia.],
    [Tomas de tierra y condensadores.],
  ),
  sol: [
    Los remedios habituales para que la radiofrecuencia y los ruidos de la red no perturben a un
    receptor son la toma de tierra y los condensadores: la tierra descarga a masa las corrientes de
    RF inducidas en chasis y cables, y los condensadores de desacoplo desvían esa RF sin afectar a
    la señal útil. Sobremodular no protege de nada: solo deforma la señal. Los transformadores de
    tensión no sirven para este cometido, y el tipo de altavoz es irrelevante, porque la
    interferencia entra antes de llegar a él. #vease[(Véase tema T9, sección «Medidas
    correctoras».)]
  ],
)

#q("C-T9.2", "b",
  [¿Cómo se puede eliminar una interferencia generada por la fuente de alimentación de un transmisor?],
  (
    [Elevando el nivel de Squelch.],
    [Colocando un filtro apropiado.],
    [Poniendo una etapa adicional de potencia.],
    [Suprimiendo la portadora.],
  ),
  sol: [
    La fuente de alimentación, sobre todo si es conmutada, puede generar ruido de radiofrecuencia y
    armónicos que salen por los cables y se cuelan en otros equipos. Se combate cortando el camino
    de acoplo: un filtro apropiado (filtro de línea, condensadores y ferritas en los cables de
    alimentación) deja pasar la corriente de la red o la continua y detiene la RF. El Squelch es un
    ajuste del receptor y no actúa sobre un transmisor; una etapa de potencia adicional amplifica
    también la interferencia, y suprimir la portadora no elimina el ruido de la fuente.
    #vease[(Véase tema T9, sección «Medidas correctoras».)]
  ],
)

#q("C-T9.3", "d",
  [Para evitar interferencias en los altavoces de un equipo de baja frecuencia, se debe:],
  (
    [Utilizar para su conexión cable de igual longitud de onda que la señal interferente.],
    [Conectar a masa los terminales del altavoz.],
    [Conectar un diodo detector entre los terminales del altavoz.],
    [Utilizar para su conexión cable blindado.],
  ),
  sol: [
    El cable del altavoz se comporta como una antena: capta radiofrecuencia y el amplificador la
    detecta, de modo que la voz del transmisor sale por el altavoz. El remedio es el
    apantallamiento: un cable blindado lleva una malla metálica alrededor de los conductores que
    desvía a masa la RF inducida antes de que llegue a la señal de audio. Un cable de longitud igual
    a la longitud de onda de la interferencia haría lo contrario: sería una antena eficaz para ella.
    Poner a masa los terminales cortocircuitaría la salida de audio, y un diodo detector entre ellos
    distorsionaría la señal. #vease[(Véase tema T9, sección «Medidas correctoras».)]
    #no-esta[Un cable blindado (o apantallado) lleva, alrededor de sus conductores, una malla o cinta
    metálica conectada a masa. Esa pantalla actúa como una jaula de Faraday alargada: la RF exterior
    induce corriente en la malla y se descarga a masa sin alcanzar el conductor interior, y a la
    inversa el cable tampoco radia. Es la misma idea de apantallar una caja, aplicada a los cables.
    Un cable sin pantalla, como el del altavoz, es una antena que recoge la interferencia y la
    introduce en el circuito de audio.]
  ],
)

#q("C-T9.4", "c",
  [La emisión de señales armónicas y espurias:],
  (
    [Disminuye la posible producción de interferencias.],
    [Es necesaria en las bandas de HF.],
    [Implica la posible producción de interferencias.],
    [Solo hay que tenerla en cuenta en las bandas de VHF y superiores.],
  ),
  sol: [
    Los armónicos (múltiplos enteros de la fundamental) y las emisiones espurias son energía radiada
    fuera de la anchura de banda necesaria, que no aporta nada a la comunicación y puede caer sobre
    otro servicio. Por ejemplo, el tercer armónico de 29,5 MHz es 88,5 MHz, en plena banda de
    radiodifusión FM. Por eso implican riesgo de interferencia en cualquier banda, HF incluida: no
    son necesarias ni deseables en ninguna y se atenúan siempre con un filtro paso bajo a la salida
    del transmisor. La Orden IET/1311/2013 limita su nivel (anexo I, punto 4.1). #vease[(Véase tema
    T9, sección «Causas de interferencia».)]
  ],
)

== Tema T10. Seguridad <apb1-t10>

#q("C-T10.1", "a",
  [Es recomendable ante la previsión de una tormenta:],
  (
    [Desconectar los cables de bajada de antena.],
    [Proteger los cables con un fusible apropiado.],
    [Conectar la red eléctrica a la toma de tierra.],
    [Desconectar las antenas y la toma de tierra.],
  ),
  sol: [
    El mástil y la antena atraen el rayo y la sobretensión puede bajar por el cable hasta el equipo
    y la vivienda. Por eso, ante una tormenta se desconectan las bajadas de antena del transceptor
    (y conviene desenchufar también el equipo de la red). La toma de tierra del mástil y de los
    soportes, en cambio, nunca se desconecta: es la vía por la que debe descargarse el rayo, y esa
    es la trampa de la opción d. Un fusible no protege ante un rayo, y conectar la red eléctrica a
    tierra provocaría un cortocircuito y haría saltar el diferencial. #vease[(Véase tema T10,
    introducción (riesgo atmosférico).)]
  ],
)

#q("C-T10.2", "a",
  [De los siguientes elementos, indicar cuáles de ellos se consideran como de protección personal:],
  (
    [Guantes de goma.],
    [Fusibles calibrados.],
    [Fusibles sin calibrar.],
    [Interruptores automáticos.],
  ),
  sol: [
    El banco da como clave «Interruptores automáticos», pero no se sostiene. Un elemento de
    protección personal es el que usa la propia persona para aislarse de la corriente: el ejemplo
    claro son los guantes de goma (aislantes). Los fusibles, calibrados o no, y los interruptores
    automáticos (magnetotérmicos) protegen la instalación y los equipos frente a sobreintensidades,
    no a la persona. Es posible que el banco pensase en el interruptor diferencial, que sí protege a
    las personas de los contactos indirectos, pero sin ese apellido «interruptores automáticos» son
    los magnetotérmicos. #vease[(Véase tema T10, sección «Fusibles y protecciones».)]
    #no-esta[Se llaman equipos de protección individual (EPI) los que lleva puestos o utiliza la persona para
    protegerse directamente de un riesgo. En electricidad son los guantes aislantes de goma, el
    calzado aislante, las alfombrillas o banquetas aislantes, el casco y las gafas. No hay que
    confundirlos con las protecciones de la instalación (fusible y magnetotérmico, que vigilan la
    intensidad del circuito) ni con el diferencial, que desconecta la red ante una fuga. Los guantes
    se revisan antes de usarlos: un agujero o una grieta los inutiliza.]
    #_apb1-clave[«Interruptores automáticos». Es la clave que dan las recopilaciones de exámenes reales
    (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la respuesta
    razonada arriba sea la técnicamente correcta.]
  ],
)

#q("C-T10.3", "a",
  [En caso de incendio producido por electricidad:],
  (
    [No se debe aplicar el chorro del extintor a los conductores de alta tensión.],
    [Habrá que utilizar «espuma» en vez de agua.],
    [Se cortarán los cables incendiados.],
    [No se tomará ninguna medida hasta la llegada de los bomberos.],
  ),
  sol: [
    El banco da por buena la b, pero es errónea: la espuma de un extintor es una disolución acuosa y
    conduce la electricidad casi como el agua, así que dirigirla contra conductores en tensión puede
    electrocutar a quien la aplica. Ante un incendio de origen eléctrico, lo primero es cortar la
    corriente en el interruptor general y después emplear un extintor apto (CO#sub[2] o polvo). La
    única afirmación cierta es la a: el chorro del extintor no debe dirigirse a conductores de alta
    tensión, porque puede cerrar el circuito a través del usuario. Cortar los cables en llamas
    expone a partes en tensión, y esperar sin actuar deja crecer el fuego.
    #no-esta[Pasos ante un incendio en una instalación o equipo eléctrico: 1) cortar la corriente en el
    interruptor general, no cortando cables; 2) emplear un extintor apto para fuego eléctrico, de
    dióxido de carbono (CO#sub[2]) o de polvo; 3) no usar nunca agua ni espuma mientras pueda haber
    tensión, porque ambas conducen la corriente; 4) avisar a los bomberos; 5) mantenerse lejos de
    conductores de alta tensión caídos o en llamas, que no se combaten con un extintor.]
    #_apb1-clave[«Habrá que utiliza ”espuma” en vez de agua». Es la clave que dan las recopilaciones de exámenes
    reales (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la respuesta
    razonada arriba sea la técnicamente correcta.]
  ],
)

#q("C-T10.4", "d",
  [En cuanto a los rotores de las antenas directivas:],
  (
    [Cuando se pone un rotor ya no es posible poner vientos a la torreta o mástil.],
    [En caso de caída de rayo, el rotor aísla a la torreta o mástil del mismo.],
    [Se montan en la parte inferior del mástil o torreta para poder ser reparado o reemplazado con
facilidad.],
    [Por su tamaño y esfuerzo, se montan preferentemente en torretas.],
  ),
  sol: [
    Un rotor debe soportar el peso de la antena directiva, el empuje del viento y el par de giro;
    los rotores grandes y pesados encajan mejor en una torreta que en un mástil delgado, y por eso
    se montan preferentemente en torretas. Las otras son falsas: por debajo del rotor sí se colocan
    vientos (lo que no puede atarse es la parte superior, que gira); el rotor no aísla del rayo y
    probablemente resulte dañado; y se instala lo más cerca posible de la antena, no en la base.
    #no-esta[El rotor es el motor que hace girar una antena directiva. Se instala lo más cerca posible de la
    antena y debe dimensionarse para su peso, el empuje del viento y el par que soporta: los
    grandes, con antenas pesadas, se alojan en torretas y los pequeños en mástiles. Los vientos se
    atan al mástil por debajo del rotor, nunca por encima, porque esa parte gira. El cable de
    control del rotor va protegido y separado de la línea de RF. El rotor no sirve de aislante ni de
    protección frente al rayo.]
  ],
)

#q("C-T10.5", "b",
  [Un interruptor diferencial actúa cuando en el circuito que protege:],
  (
    [Se produce un cortocircuito.],
    [Se produce una derivación a tierra.],
    [Se produce una sobremodulación.],
    [Se aumenta la potencia.],
  ),
  sol: [
    El diferencial compara la corriente que entra por la fase con la que vuelve por el neutro. Si
    hay una derivación a tierra (por un aislamiento defectuoso o a través de una persona), parte de
    la corriente vuelve por tierra y no por el neutro: ida y retorno dejan de ser iguales y el
    aparato corta. En un cortocircuito entre fase y neutro, en cambio, toda la corriente vuelve por
    el neutro, ida y retorno siguen siendo iguales y el diferencial no lo detecta: de eso se encarga
    el magnetotérmico. La sobremodulación es un fenómeno de radiofrecuencia y un aumento de potencia
    no desequilibra ida y retorno. #vease[(Véase tema T10, sección «Fusibles y protecciones».)]
  ],
)

#q("C-T10.6", "c",
  [En relación a las tomas de tierra, una de las siguientes expresiones NO es correcta. ¿Cuál?],
  (
    [Nunca se deben hacer sobre cables coaxiales.],
    [No debemos emplear las instalaciones de gas ni de calefacción.],
    [Deben hacerse en sitios donde dé el sol, para así evitar los efectos perniciosos de la humedad.],
    [No debemos valernos de las conducciones de agua para hacerlas.],
  ),
  sol: [
    La falsa es la c: la toma de tierra se entierra en terreno húmedo, porque la humedad reduce la
    resistencia del terreno y mejora la derivación de corrientes; un suelo seco y soleado la
    empeora. Las demás son ciertas: no se aprovechan las instalaciones de gas ni de calefacción ni
    las tuberías de agua como toma de tierra (peligro de tensión en otras partes de la instalación
    y, en el gas, de chispa y explosión), ni se hace la tierra sobre un cable coaxial, cuya malla es
    la vía de retorno de la señal de RF y no un electrodo. #vease[(Véase tema T10, introducción
    (puesta a tierra).)]
    #no-esta[La toma de tierra es un electrodo (pica, placa o cable enterrado) que pone a potencial de tierra
    los chasis de los equipos, y debe tener muy poca resistencia: por eso se entierra en terreno
    húmedo y profundo, no en suelo seco. Los reglamentos de baja tensión prohíben usar como tierra
    las canalizaciones de agua, gas o calefacción: una chispa puede inflamar el gas, la tensión de
    fuga llegaría a otras personas y los tramos de plástico cortan la continuidad. Tampoco vale el
    coaxial. Lo correcto es una pica propia o la tierra del edificio, si está en buen estado.]
  ],
)

#q("C-T10.7", "c",
  [En relación con las medidas a adoptar en trabajos de instalaciones de equipos y antenas, una de
las siguientes medidas NO es correcta. Señálela:],
  (
    [Se ha de evitar el uso de aparatos móviles de luz en locales húmedos.],
    [Si se tienen las manos mojadas, se han de incrementar las precauciones.],
    [El cruzamiento de los conductores de línea de la red eléctrica no debe preocuparnos en absoluto.],
    [Si hemos de instalar conductores, se ha de emplear caucho vulcanizado con protección de algodón
y material aislante.],
  ),
  sol: [
    La falsa es la c: el cruce o contacto entre conductores de la red, o de estos con un cable de
    antena, sí debe preocuparnos, porque puede causar cortocircuitos y tensiones peligrosas; hay que
    evitarlo y mantener las distancias. Las otras son prudentes: las lámparas portátiles en locales
    húmedos favorecen derivaciones eléctricas; con las manos mojadas baja la resistencia de la piel
    y crece el riesgo de electrocución; y los conductores deben llevar buen aislamiento para evitar
    cortocircuitos (la fórmula del caucho vulcanizado con algodón es de instalaciones antiguas).
    #no-esta[Reglas de sentido común al instalar equipos y antenas. Humedad: el agua y la piel mojada reducen
    mucho la resistencia del cuerpo, así que en locales húmedos se evitan las lámparas portátiles
    alimentadas de la red y nunca se trabaja con las manos mojadas. Conductores: con aislamiento
    adecuado y en buen estado, sin empalmes al aire. Cruces y contactos: los conductores de la red
    no deben cruzarse ni tocarse entre sí ni con el cable de antena, y la antena se mantiene lejos
    de las líneas eléctricas aéreas, a una distancia mayor que la altura de mástil y antena.]
  ],
)

#q("C-T10.8", "a",
  [Señale la conexión correcta entre los chasis metálicos de los equipos:],
  (
    [#_apb1-chasis({
      import cetz.draw: *
      line((7.6, -0.75), (7.6, -1.3), stroke: 0.6pt)
      circle((7.6, -0.75), radius: 0.03, fill: black, stroke: none)
      line((7.2, -1.3), (8.0, -1.3), stroke: 1.2pt)
      line((7.3, -1.45), (7.9, -1.45), stroke: 1.0pt)
      line((7.4, -1.6), (7.8, -1.6), stroke: 0.8pt)
      content((8.7, -1.45), text(size: 6.6pt, fill: col.gris)[tierra])
    }, grueso: false)],
    [#_apb1-chasis({
      import cetz.draw: *
      content((-0.9, -1.1), align(center, text(size: 6.6pt, fill: col.gris)[230 V\ (fase)]))
    })],
    [#_apb1-chasis({
      import cetz.draw: *
      content((-0.9, -1.1), align(center, text(size: 6.6pt, fill: col.gris)[230 V\ (neutro)]))
    })],
    [#_apb1-chasis({
      import cetz.draw: *
      content((-0.9, -1.1), align(center, text(size: 6.6pt, fill: col.gris)[+12 V\ CC]))
    })],
  ),
  sol: [
    Los chasis metálicos de todos los equipos (transceptor, medidor de ROE y acoplador) se unen
    entre sí por una barra común, y esa barra va a la toma de tierra de la estación: es el esquema
    a). Así, si un aislamiento falla, la fuga se deriva a tierra y las carcasas no quedan con
    tensión. Las demás figuras unen la barra de chasis a un conductor activo: a la fase de la red
    (b), que dejaría todas las carcasas a 230 V; al neutro (c), que no es una tierra: por él circula
    la corriente de retorno y puede quedar con tensión; o al positivo de la alimentación de 12 V de
    continua (d), que tampoco es una tierra. #vease[(Véase tema T10, apertura del capítulo («puesta
    a tierra») y pregunta sobre la toma de tierra de la estación.)]
  ],
)

