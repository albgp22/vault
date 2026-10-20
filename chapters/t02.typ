#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Macros locales del tema T2 (prefijo _t2-)
// ---------------------------------------------------------------------

// Símbolo pequeño en línea (opciones de las preguntas sobre símbolos)
#let _t2-sim(cuerpo) = box(baseline: 45%, inset: (y: 2pt), esquema(cuerpo))

// Colores del código de colores
#let _t2-colores = (
  negro: rgb("#1a1a1a"),
  marron: rgb("#7b4a26"),
  rojo: rgb("#c8352b"),
  naranja: rgb("#e67e22"),
  amarillo: rgb("#f4cf1c"),
  verde: rgb("#2e8b57"),
  azul: rgb("#2462b3"),
  violeta: rgb("#7d3c98"),
  gris: rgb("#8c8c8c"),
  blanco: rgb("#ffffff"),
  oro: rgb("#d4a017"),
  plata: rgb("#b8bcc2"),
)

// Muestra de color para tablas
#let _t2-muestra(c) = box(width: 1.6em, height: 0.8em, baseline: 10%, fill: _t2-colores.at(c), stroke: 0.4pt + black)

// Resistencia de cuatro bandas vista desde fuera (cuerpo, bandas y terminales).
// Devuelve las posiciones x de las bandas para poner las etiquetas.
#let _t2-cuerpo-bandas(bandas, x0: 0, y0: 0, largo: 3.2, alto: 0.8, banda: 0.11) = {
  import cetz.draw: *
  line((x0 - 1.3, y0), (x0 + 0.05, y0), stroke: 1.3pt + col.gris)
  line((x0 + largo - 0.05, y0), (x0 + largo + 1.3, y0), stroke: 1.3pt + col.gris)
  rect((x0, y0 - alto / 2), (x0 + largo, y0 + alto / 2), radius: 0.28, fill: rgb("#f0dfb4"), stroke: 0.6pt + rgb("#9a8458"))
  let xs = (0.55, 0.95, 1.35, 2.6).map(f => x0 + f * largo / 3.2)
  for (i, b) in bandas.enumerate() {
    rect((xs.at(i) - banda, y0 - alto / 2), (xs.at(i) + banda, y0 + alto / 2), fill: _t2-colores.at(b), stroke: 0.3pt + black)
  }
}

// Válvula termoiónica con ampolla redondeada.
//   rejillas: lista de (altura relativa en [-1, 1], lado "izq"/"der", color)
//   Anclas con nombre: <n>-placa, <n>-catodo, <n>-g0, <n>-g1… (extremos de los terminales)
#let _t2-valvula(n, centro, rejillas: (), escala: 1, catodo-tipo: "gancho", grueso: 0.9pt) = {
  import cetz.draw: *
  let (cx, cy) = centro
  let w = 0.62 * escala   // semiancho de la ampolla
  let h = 0.95 * escala   // semialto de la ampolla
  let st = grueso + black
  rect((cx - w, cy - h), (cx + w, cy + h), radius: w, stroke: st, fill: white)
  // placa (ánodo)
  let yp = cy + 0.5 * h
  line((cx - 0.32 * escala, yp), (cx + 0.32 * escala, yp), stroke: (grueso * 1.6) + black)
  line((cx, yp), (cx, cy + h + 0.35 * escala), stroke: st)
  anchor(n + "-placa", (cx, cy + h + 0.35 * escala))
  // rejillas
  for (i, r) in rejillas.enumerate() {
    let (yr, lado, color) = r
    let y = cy + yr * h
    line((cx - w * 0.82, y), (cx + w * 0.82, y), stroke: (paint: color, thickness: grueso * 1.2, dash: "densely-dotted"))
    if lado == "izq" {
      line((cx - w * 0.82, y), (cx - w - 0.35 * escala, y), stroke: grueso * 0.8 + color)
      anchor(n + "-g" + str(i), (cx - w - 0.35 * escala, y))
    } else {
      line((cx + w * 0.82, y), (cx + w + 0.35 * escala, y), stroke: grueso * 0.8 + color)
      anchor(n + "-g" + str(i), (cx + w + 0.35 * escala, y))
    }
  }
  // cátodo de caldeo indirecto: gancho
  let yk = cy - 0.55 * h
  let xk = cx - 0.22 * escala
  line((xk, cy - h - 0.35 * escala), (xk, yk), (cx + 0.26 * escala, yk), (cx + 0.26 * escala, yk - 0.12 * escala), stroke: st)
  anchor(n + "-catodo", (xk, cy - h - 0.35 * escala))
}

// Bobina dibujada como espiras (cicloide alargada), entre (x0, y) y (x1, y)
#let _t2-espiras(x0, x1, y: 0, vueltas: 4, alto: 0.16, trazo: 0.8pt) = {
  import cetz.draw: *
  let a = (x1 - x0) / (2 * calc.pi * vueltas + 2)   // avance por radián
  let b = alto
  let pts = range(161).map(i => {
    let t = 2 * calc.pi * vueltas * i / 160
    (x0 + a + a * t - b * 0.9 * calc.sin(t), y + b - b * calc.cos(t))
  })
  line((x0, y), pts.first(), stroke: trazo)
  line(..pts, stroke: trazo)
  line(pts.last(), (x1, y), stroke: trazo)
}

// Símbolo de varicap: diodo con una segunda placa (condensador) en el cátodo
#let _t2-varicap(x0, x1, y: 0, etiqueta: none) = {
  import cetz.draw: *
  let xm = (x0 + x1) / 2
  line((x0, y), (xm - 0.25, y), stroke: 0.6pt)
  line((xm - 0.25, y - 0.26), (xm - 0.25, y + 0.26), (xm + 0.12, y), close: true, stroke: 0.8pt, fill: white)
  line((xm + 0.12, y - 0.26), (xm + 0.12, y + 0.26), stroke: 0.8pt)
  line((xm + 0.26, y - 0.26), (xm + 0.26, y + 0.26), stroke: 0.8pt)
  line((xm + 0.26, y), (x1, y), stroke: 0.6pt)
  if etiqueta != none { content((xm, y + 0.45), anchor: "south", etiqueta) }
}

// JFET de canal N: canal vertical, puerta con flecha que TOCA el canal
#let _t2-jfet(cx, cy, canal: "n") = {
  import cetz.draw: *
  line((cx, cy - 0.55), (cx, cy + 0.55), stroke: 1.4pt)                // canal
  line((cx, cy + 0.4), (cx + 0.6, cy + 0.4), (cx + 0.6, cy + 0.9), stroke: 0.6pt)   // drenador
  line((cx, cy - 0.4), (cx + 0.6, cy - 0.4), (cx + 0.6, cy - 0.9), stroke: 0.6pt)   // surtidor
  line((cx - 0.8, cy - 0.4), (cx, cy - 0.4), stroke: 0.6pt,
    mark: if canal == "n" { (end: ">", fill: black, scale: 0.7) } else { (start: ">", fill: black, scale: 0.7) })
}

#tema("T2", "Componentes", alcance: [Resistencias (tipos, código de colores, disipación, PTC/NTC) · condensadores (capacidad, reactancia, dieléctricos) · bobinas (autoinducción, factor $Q$, efecto pelicular) · transformadores · diodos (rectificadores, zéner, LED, varicap) · transistores bipolares y de efecto campo · válvulas y circuitos integrados.])

#motivacion(titulo: [Un equipo de radio es un puñado de piezas que se repiten])[
  Si abres un receptor o un transmisor encuentras siempre las mismas pocas piezas, repetidas cientos de veces. Cada una existe porque resuelve un problema concreto: fijar una corriente, dejar pasar la señal y bloquear la continua, escoger una frecuencia, cambiar una tensión, dejar pasar la corriente en un solo sentido o *amplificar* una señal de microvoltios. Este tema presenta cada pieza por el problema que resuelve. La historia larga de cada una está en el capítulo «La radio por dentro»; aquí está lo que pide el examen, con el porqué.
]

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: (left, left, left),
    [Componente], [Qué hace], [Dónde lo encuentras en una radio],
    [Resistencia], [Fija corrientes y reparte tensiones (convierte energía en calor)], [Polarización de transistores, limitación de la corriente de un LED, carga artificial de 50 Ω],
    [Condensador], [Guarda carga; deja pasar la alterna y bloquea la continua], [Acoplo entre etapas, filtro de la fuente, sintonía con una bobina],
    [Bobina], [Guarda energía magnética; deja pasar la continua y frena la alterna], [Circuitos sintonizados, choques de RF, filtros],
    [Transformador], [Cambia tensiones e impedancias; aísla], [Fuente de alimentación, balun, acoplo entre etapas],
    [Diodo], [Deja pasar la corriente en un solo sentido], [Rectificador de la fuente, detector de AM, varicap del VCO],
    [Transistor (BJT, FET)], [Amplifica: una señal pequeña gobierna una corriente grande], [Amplificadores de RF, FI y audio; osciladores; mezcladores],
    [Válvula], [Lo mismo que el transistor, con electrones en el vacío], [Amplificadores lineales de potencia de HF],
    [Circuito integrado], [Un circuito completo en un chip], [Operacionales, sintetizadores, DSP],
  ),
  caption: [Mapa del tema: qué problema resuelve cada componente y dónde aparece.],
) <t2-tab-mapa>

== Resistencias <t2-sec-resistencias>

#motivacion[
  Un transistor necesita una corriente de reposo exacta para amplificar sin distorsión; un LED se quema si no se le limita la corriente; un transmisor necesita una carga de 50 Ω que se trague la potencia mientras lo ajustas sin radiar. Las tres cosas las resuelve la pieza más humilde: un componente que se opone al paso de la corriente en una cantidad conocida y estable. La explicación física completa está en #ver(<sec-resistencia>).
]

La resistencia de un conductor homogéneo es $R = rho l slash S$: crece con la longitud, decrece con la sección y depende del material a través de la resistividad $rho$. En los metales, $rho$ _aumenta_ con la temperatura (las vibraciones de la red dispersan a los electrones): todo conductor metálico es, de serie, un PTC suave. Los *termistores* exageran ese comportamiento a propósito: el *PTC* sube su resistencia con la temperatura y el *NTC* la baja (en los semiconductores el calor libera portadores, y ese efecto gana). El *varistor* (VDR) juega el mismo juego con la tensión: su valor óhmico depende de la tensión aplicada y se desploma al superar un umbral, lo que lo convierte en un protector natural contra sobretensiones. Además del valor nominal, una resistencia se especifica por su *tolerancia* y su máxima *disipación* ($P = I^2 R$): superarla la quema.

#analogia[
  Una resistencia es un tramo estrecho de tubería. Cuanto más largo ($l$) y más estrecho ($S$ pequeña), más le cuesta pasar al agua; y el material ($rho$) es la rugosidad de las paredes. El agua que roza pierde energía y la pared se calienta: eso es la disipación $P = I^2 R$.
]

#ejemplo[
  Una resistencia de 1 kΩ y $1/4$ W soporta como máximo $I = sqrt(P slash R) = sqrt(0\,25 slash 1000) approx 16$ mA — unos 16 V entre extremos. El mismo valor óhmico en un encapsulado de 2 W admite casi el triple de corriente: el valor no basta; hay que mirar la disipación.
]

=== Por qué hay tantos tipos de resistencia

Todas hacen lo mismo, pero cada fabricación resuelve un problema distinto. La potencia que aguanta se reconoce por el tamaño del cuerpo, no por los colores.

#figure(
  table(
    columns: (1fr, 1.25fr, 1.25fr), align: left,
    [Tipo], [Por qué existe], [Uso típico en la radio],
    [Película de carbón], [Barata y suficiente: tolerancia del 5 %], [Uso general, polarización],
    [Película metálica], [Precisa (1 %) y con poco ruido térmico], [Etapas de entrada, instrumentos, filtros],
    [Bobinada (hilo)], [Disipa mucha potencia; pero el hilo arrollado es una bobina], [Fuentes, cargas de baja frecuencia; *no* sirve en RF],
    [Carga no inductiva (película gruesa, carbón macizo)], [Disipa potencia sin inductancia parásita], [Carga artificial de 50 Ω para el transmisor],
    [Montaje superficial (SMD)], [Diminuta: casi sin inductancia ni capacidad parásitas], [Equipos modernos de VHF/UHF],
    [Potenciómetro, trimmer], [Valor ajustable a mano], [Volumen, ajustes de fábrica],
    [NTC, PTC, VDR, LDR], [El valor depende de la temperatura, la tensión o la luz], [Sensores y protecciones],
  ),
  caption: [Tipos de resistencia y su lugar en un equipo de radio.],
) <t2-tab-tipos-r>

#circuito(caption: [Símbolos de las resistencias (norma europea). La línea oblicua con un tramo horizontal marca un valor que cambia por sí solo con la magnitud indicada al lado.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    let et(x, t) = content((x, -0.75), anchor: "north", text(size: 7.5pt, t))
    resistor("r1", (0, 0), (2, 0))
    et(1, [fija])
    potentiometer("p1", (2.6, 0), (4.6, 0))
    et(3.6, [potenciómetro])
    rheostat("r2", (5.2, 0), (7.2, 0))
    et(6.2, [variable (reóstato)])
    for (i, (x0, t, n)) in ((7.8, $-t degree$, [NTC]), (10.4, $+t degree$, [PTC]), (13, $U$, [VDR (varistor)])).enumerate() {
      resistor("rx" + str(i), (x0, 0), (x0 + 2, 0))
      line((x0 + 0.45, -0.5), (x0 + 0.65, -0.5), (x0 + 1.55, 0.5), stroke: 0.7pt)
      content((x0 + 1.75, 0.55), anchor: "south-west", text(size: 7.5pt, t))
      et(x0 + 1, n)
    }
  })
] <t2-fig-simbolos-r>

=== El código de colores

El valor se marca con el *código de colores* (@t2-fig-colores): dos cifras significativas, multiplicador y tolerancia. La secuencia de valores 0–9 es: negro, marrón, rojo, naranja, amarillo, verde, azul, violeta, gris, blanco.

#circuito(caption: [Lectura del código de colores de una resistencia de cuatro bandas: las dos primeras son cifras significativas, la tercera es el multiplicador y la cuarta la tolerancia. Se lee empezando por la banda más próxima a un terminal.])[
  #cetz.canvas({
    import cetz.draw: *
    _t2-cuerpo-bandas(("marron", "negro", "rojo", "oro"), largo: 4.8, alto: 1.1, banda: 0.16)
    let xs = (0.55, 0.95, 1.35, 2.6).map(f => f * 4.8 / 3.2)
    let t = 8pt
    // sentido de lectura
    line((0.4, 0.85), (2.6, 0.85), stroke: 0.6pt + col.gris, mark: (end: ">", fill: col.gris, scale: 0.6))
    content((1.5, 0.95), anchor: "south", text(size: 7pt, fill: col.gris)[sentido de lectura])
    // 1.ª cifra
    line((xs.at(0), -0.55), (xs.at(0), -1.0), (0.2, -1.0), stroke: 0.5pt)
    content((0.15, -1.0), anchor: "east", align(right, text(size: t)[1.ª cifra\ marrón = 1]))
    // 2.ª cifra
    line((xs.at(1), -0.55), (xs.at(1), -2.05), (0.2, -2.05), stroke: 0.5pt)
    content((0.15, -2.05), anchor: "east", align(right, text(size: t)[2.ª cifra\ negro = 0]))
    // multiplicador
    line((xs.at(2), -0.55), (xs.at(2), -1.0), (2.9, -1.0), stroke: 0.5pt)
    content((2.95, -1.0), anchor: "west", text(size: t)[multiplicador\ rojo = $times 10^2$])
    // tolerancia
    line((xs.at(3), 0.55), (xs.at(3), 1.05), (4.4, 1.05), stroke: 0.5pt)
    content((4.45, 1.05), anchor: "west", text(size: t)[tolerancia\ oro = ±5 %])
    content((2.4, -2.75), anchor: "north", text(size: 9.5pt)[$R = 10 times 10^2 = 1000$ Ω = 1 kΩ ± 5 %])
  })
] <t2-fig-colores>

La tabla completa, que conviene saberse de memoria, es esta:

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, left, center, center, center),
    [], [Color], [Cifra], [Multiplicador], [Tolerancia],
    _t2-muestra("negro"), [negro], [0], [$times 1$], [—],
    _t2-muestra("marron"), [marrón], [1], [$times 10$], [±1 %],
    _t2-muestra("rojo"), [rojo], [2], [$times 10^2$], [±2 %],
    _t2-muestra("naranja"), [naranja], [3], [$times 10^3$], [—],
    _t2-muestra("amarillo"), [amarillo], [4], [$times 10^4$], [—],
    _t2-muestra("verde"), [verde], [5], [$times 10^5$], [±0,5 %],
    _t2-muestra("azul"), [azul], [6], [$times 10^6$], [±0,25 %],
    _t2-muestra("violeta"), [violeta], [7], [$times 10^7$], [±0,1 %],
    _t2-muestra("gris"), [gris], [8], [$times 10^8$], [±0,05 %],
    _t2-muestra("blanco"), [blanco], [9], [$times 10^9$], [—],
    _t2-muestra("oro"), [oro], [—], [$times 0,1$], [±5 %],
    _t2-muestra("plata"), [plata], [—], [$times 0,01$], [±10 %],
    [], [sin banda], [—], [—], [±20 %],
  ),
  caption: [Código de colores de resistencias (norma IEC 60062). En el examen basta con las cifras, el multiplicador y las tolerancias del oro y la plata.],
) <t2-tab-colores>

#truco[
  Entre el rojo (2) y el violeta (7) los colores siguen el orden del arco iris: rojo, naranja, amarillo, verde, azul, violeta. Delante van el negro (0, nada de luz) y el marrón (1); detrás, el gris (8) y el blanco (9, toda la luz). Y el multiplicador es simplemente *el número de ceros* que se añaden a las dos cifras.
]

#ejemplo[
  Bandas amarillo, violeta, naranja y oro. Cifras: amarillo = 4, violeta = 7 → 47. Multiplicador: naranja = $times 10^3$, es decir, tres ceros → 47 000 Ω = 47 kΩ. Oro: ±5 %, así que el valor real está entre 44,65 kΩ y 49,35 kΩ.
]

#ojo[
  La banda de tolerancia (oro o plata) *no* entra en el cálculo del valor: solo dice cuánto puede apartarse el valor real del nominal. Y no confundas el rojo multiplicador ($times 100$) con el rojo cifra (2). Lo preguntan T2.1, T2.2, T2.43 y T2.46.
]

#q("T2.1", "b",
  [Una resistencia con las bandas de color marrón, negro, rojo y oro tiene un valor nominal de:],
  ([100 Ω], [1 kΩ], [10 kΩ], [1 MΩ]),
  sol: [Marrón = 1, negro = 0, rojo = $times 10^2$: $10 times 100 = 1000$ Ω = 1 kΩ. El oro es la tolerancia y no interviene en el valor (@t2-fig-colores).],
)

#q("T2.2", "d",
  [En una resistencia de cuatro bandas, la tolerancia viene indicada por:],
  ([la primera banda de color], [la segunda banda de color], [la tercera banda de color], [la cuarta banda de color]),
  sol: [Dos primeras bandas: cifras; tercera: multiplicador; cuarta: tolerancia (oro ±5 %, plata ±10 %).],
)

=== Resistencias que cambian solas: PTC, NTC y VDR

En casi todos los circuitos se quiere que la resistencia *no* cambie. Pero a veces conviene lo contrario: una pieza que mida la temperatura del transistor final, que limite el pico de corriente al encender una fuente o que corte una sobretensión de la red. Para eso se fabrican resistencias cuyo valor depende, a propósito, de una magnitud externa.

#circuito(caption: [Cómo varía la resistencia con la temperatura. El metal es un PTC suave; el termistor PTC se dispara a partir de una temperatura de conmutación; el NTC baja de forma continua.])[
  #cetz.canvas({
    import cetz.draw: *
    ejes(0, 6.4, 0, 3.6, etq-x: [temperatura], etq-y: $R$)
    onda(x => 0.9 + 0.12 * x, 0.2, 6, stroke: 1.1pt + col.senal3)
    onda(x => 0.5 + 2.6 / (1 + calc.exp(-3.2 * (x - 4.2))), 0.2, 6, stroke: 1.1pt + col.senal2)
    onda(x => 3.2 * calc.exp(-0.45 * x) + 0.1, 0.2, 6, stroke: 1.1pt + col.senal1)
    content((6.05, 1.62), anchor: "west", text(size: 7.5pt, fill: col.senal3)[metal])
    content((5.2, 3.15), anchor: "west", text(size: 7.5pt, fill: col.senal2)[PTC])
    content((5.4, 0.42), anchor: "west", text(size: 7.5pt, fill: col.senal1)[NTC])
  })
] <t2-fig-rt>

- *PTC* (_positive temperature coefficient_): sube con la temperatura. Como fusible rearmable: si pasa demasiada corriente, se calienta, su resistencia se dispara y la corriente cae sola.
- *NTC* (_negative temperature coefficient_): baja con la temperatura. Es el sensor de temperatura del radiador del paso final y el limitador de arranque de las fuentes: fría, frena el pico de carga de los condensadores; caliente, casi desaparece.
- *VDR* o *varistor*: casi un aislante a la tensión normal, y casi un cortocircuito por encima de su umbral. Se pone en paralelo con la entrada de red: cuando llega un pico, el varistor conduce y lo recorta antes de que llegue al equipo; si la sobretensión se mantiene, la corriente que deriva funde el fusible.

#q("T2.3", "a",
  [Si aumenta la temperatura en un conductor:],
  ([aumenta también su resistencia eléctrica], [disminuye su resistencia eléctrica], [su resistencia no varía], [el conductor se convierte en aislante]),
  sol: [En un conductor metálico la resistencia crece con la temperatura: las vibraciones de la red dificultan el paso de los electrones.],
)

#q("T2.4", "c",
  [Un termistor de tipo PTC es aquel cuyo valor de resistencia:],
  ([no depende de la temperatura], [disminuye al aumentar la temperatura], [aumenta al aumentar la temperatura], [se anula por encima de 0 °C]),
  sol: [PTC (_positive temperature coefficient_): la resistencia aumenta con la temperatura. Su pareja NTC hace lo contrario.],
)

#q("T2.5", "b",
  [Un termistor de tipo NTC es una resistencia cuyo valor:],
  ([aumenta al aumentar la temperatura], [se reduce a medida que la temperatura aumenta], [depende de la luz que recibe], [depende de la tensión aplicada]),
  sol: [NTC (_negative temperature coefficient_): la resistencia se reduce al aumentar la temperatura. Se usan como sensores de temperatura y limitadores de arranque.],
)

=== Serie, paralelo y el divisor de tensión

#motivacion[
  En el cajón no hay todos los valores. ¿Cómo haces una carga de 50 Ω con resistencias de 100 Ω? ¿Y cómo sacas 2 V estables para la base de un transistor a partir de los 13,8 V de la fuente? Las dos respuestas salen de cómo se combinan las resistencias.
]

#circuito(caption: [Resistencias en serie (la corriente es la misma y las tensiones se suman) y en paralelo (la tensión es la misma y las corrientes se suman). A la derecha, el divisor de tensión: dos resistencias en serie reparten la tensión.], sim: "resistors.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content
    let t = 8pt
    // serie
    resistor("s1", (0, 0), (2, 0), n: "o-")
    resistor("s2", (2, 0), (4, 0), n: "-o")
    content((1, 0.55), text(size: t, $R_1$))
    content((3, 0.55), text(size: t, $R_2$))
    content((2, -1.0), text(size: t)[serie: $R = R_1 + R_2$])
    // paralelo
    wire((5, 0), (5.6, 0))
    wire((5.6, 0.75), (5.6, -0.75))
    resistor("p1", (5.6, 0.75), (7.6, 0.75))
    resistor("p2", (5.6, -0.75), (7.6, -0.75))
    wire((7.6, 0.75), (7.6, -0.75))
    wire((7.6, 0), (8.2, 0))
    node("pa", (5, 0), fill: false)
    node("pb", (8.2, 0), fill: false)
    content((6.6, 1.3), text(size: t, $R_1$))
    content((6.6, -1.3), text(size: t, $R_2$))
    content((6.6, -1.95), text(size: t)[paralelo: $1 slash R = 1 slash R_1 + 1 slash R_2$])
    // divisor
    resistor("d1", (10.6, 1.8), (10.6, 0))
    resistor("d2", (10.6, 0), (10.6, -1.8))
    node("dt", (10.6, 1.8), fill: false)
    content((10.35, 1.95), anchor: "east", text(size: t, $V_"ent"$))
    content((10.1, 0.9), anchor: "east", text(size: t, $R_1$))
    content((10.1, -0.9), anchor: "east", text(size: t, $R_2$))
    wire((10.6, 0), (11.6, 0))
    node("dm", (10.6, 0))
    node("ds", (11.6, 0), fill: false)
    content((11.75, 0), anchor: "west", text(size: t, $V_"sal"$))
    ground("dg", (10.6, -1.8))
    content((10.8, -2.75), text(size: t)[divisor])
  })
] <t2-fig-serie-paralelo>

#porque[
  - *En serie*, la misma corriente atraviesa las dos; cada una «gasta» su parte de tensión, así que las resistencias se suman: el total siempre es *mayor* que la mayor.
  - *En paralelo*, la corriente tiene dos caminos; abrir un camino más facilita el paso, así que el total siempre es *menor* que la menor. Para dos iguales, la mitad.
  - *En el divisor*, la corriente es $I = V_"ent" slash (R_1 + R_2)$ y la salida es la caída en $R_2$: $V_"sal" = V_"ent" dot R_2 slash (R_1 + R_2)$. Así se fija la tensión de base de un transistor (@t2-fig-ec). #falstad("voltdivide.txt", texto: [Divisor en Falstad])
]

#ejemplo[
  Dos resistencias no inductivas de 100 Ω y 5 W en paralelo dan $100 slash 2 = 50$ Ω y aguantan 10 W: una carga artificial para ajustar un transmisor QRP. Y un divisor con $R_1 = 56$ kΩ y $R_2 = 10$ kΩ alimentado con 13,8 V da $V_"sal" = 13,8 dot 10 slash 66 approx 2,1$ V, una tensión de base típica.
]

#ojo[
  En los condensadores las reglas se invierten: en paralelo se suman y en serie se combinan por inversas. Lo verás en la sección siguiente y lo pregunta T2.47.
]

== Condensadores <t2-sec-condensadores>

#motivacion[
  Entre dos etapas de un receptor, la señal de RF tiene que pasar, pero la tensión continua que polariza cada transistor no debe pasar de una etapa a la otra. A la salida del rectificador de la fuente la tensión llega a impulsos y hay que alisarla. Y para quedarte con una sola emisora necesitas una pieza que, con una bobina, resuene a una frecuencia. Las tres cosas las hace el condensador, gracias a una sola propiedad: guarda carga y se opone a que su tensión cambie de golpe. La explicación larga está en #ver(<sec-condensador>).
]

Un condensador son dos armaduras conductoras separadas por un *dieléctrico* (un aislante polarizable). Almacena carga en proporción a la tensión, y esa constante es la *capacidad*:
$ C = Q / V quad "(faradios)", wide C = epsilon S / d $
para el condensador plano: crece con la superficie $S$ de las placas y con la permitividad $epsilon$ del dieléctrico, y decrece con la separación $d$. La energía almacenada se obtiene integrando el trabajo de ir subiendo la carga ($dif W = v dif q = (q slash C) dif q$):
$ E = integral_0^Q q / C dif q = Q^2 / (2 C) = 1/2 C V^2. $
En alterna, el condensador se opone al paso de la corriente con una *reactancia capacitiva*
$ X_C = 1 / (2 pi f C), $
que _disminuye_ al subir la frecuencia (a más frecuencia, menos tiempo para cargarse: deja pasar mejor); la corriente adelanta 90° a la tensión. Según el dieléctrico hay tipos de aire, mica, plástico y cerámicos; los *electrolíticos* logran capacidades grandes con una capa de óxido finísima, a cambio de ser polarizados: conectados al revés se destruyen. Sus imperfecciones son la corriente de fuga y el coeficiente de temperatura. Al asociar condensadores, las reglas son las inversas que en las resistencias: en paralelo las capacidades se suman, y en serie se combinan por inversas, $1 slash C = 1 slash C_1 + 1 slash C_2$ — el resultado es siempre menor que la más pequeña.

#circuito(caption: [Condensador plano. Al aplicar la tensión $V$, una armadura se queda con carga $+Q$ y la otra con $-Q$; ninguna carga cruza el dieléctrico. Más superficie $S$ o menos separación $d$ dan más capacidad.])[
  #cetz.canvas({
    import cetz.draw: *
    // dieléctrico
    rect((0.25, 0), (1.15, 2.6), fill: col.ambar-claro, stroke: none)
    content((0.7, 1.3), angle: 90deg, text(size: 7.5pt, fill: col.ambar)[dieléctrico ($epsilon$)])
    // armaduras
    rect((0, 0), (0.25, 2.6), fill: col.senal2.lighten(70%), stroke: 0.7pt)
    rect((1.15, 0), (1.4, 2.6), fill: col.senal1.lighten(70%), stroke: 0.7pt)
    for i in range(6) {
      content((0.125, 0.25 + i * 0.42), text(size: 7pt, fill: col.senal2, weight: "bold")[+])
      content((1.275, 0.25 + i * 0.42), text(size: 7pt, fill: col.senal1, weight: "bold")[−])
    }
    // cota d
    line((0.25, -0.35), (1.15, -0.35), mark: (start: ">", end: ">", fill: black, scale: 0.5), stroke: 0.5pt)
    content((0.7, -0.4), anchor: "north", text(size: 8pt, $d$))
    content((-0.2, 2.75), anchor: "south", text(size: 8pt)[superficie $S$])
    // terminales y pila
    line((0.0, 1.3), (-1.0, 1.3), (-1.0, -1.2), (0.45, -1.2), stroke: 0.6pt)
    line((1.4, 1.3), (2.4, 1.3), (2.4, -1.2), (0.95, -1.2), stroke: 0.6pt)
    line((0.45, -0.95), (0.45, -1.45), stroke: 0.8pt)
    line((0.95, -1.08), (0.95, -1.32), stroke: 2pt)
    content((0.45, -1.55), anchor: "north", text(size: 7pt)[+])
    content((0.7, -1.75), anchor: "north", text(size: 8pt, $V$))
    content((-1.1, 0.4), anchor: "east", text(size: 8pt, $+Q$))
    content((2.5, 0.4), anchor: "west", text(size: 8pt, $-Q$))
  })
] <t2-fig-placas>

#analogia[
  Imagina una tubería cortada por una membrana elástica. El agua no puede atravesarla, así que una corriente *continua* se detiene en cuanto la membrana se ha estirado del todo. Pero si el agua va y viene (alterna), la membrana se estira hacia un lado y hacia el otro, y el vaivén se transmite: la alterna «pasa». Cuanto más rápido es el vaivén, menos llega a estirarse la membrana y menos se opone: la reactancia baja con la frecuencia.
]

Dos desarrollos cortos justifican lo dicho. La reactancia sale de la definición $i = C dif v slash dif t$: con $v = V_0 sin(omega t)$ resulta $i = omega C V_0 cos(omega t)$ — la corriente adelanta 90° a la tensión, y el cociente de amplitudes es $V_0 slash I_0 = 1 slash (omega C) = X_C$. Y en continua, un condensador se carga a través de una resistencia siguiendo la exponencial $v(t) = V (1 - e^(-t slash tau))$ con constante de tiempo $tau = R C$: al 63 % en un $tau$, cargado a efectos prácticos en $5 tau$. Ese transitorio es el corazón de los temporizadores y, visto desde el dominio de la frecuencia, de los filtros RC.

#circuito(caption: [Carga de un condensador a través de una resistencia. Al cerrar el interruptor, la corriente empieza siendo $V slash R$ y se va apagando; la tensión del condensador sube al 63 % en un $tau = R C$ y queda casi completa en $5 tau$.], sim: "cap.txt")[
  #grid(columns: 2, column-gutter: 1.2cm, align: horizon,
    esquema({
      import zap: *
      import cetz.draw: content
      bateria("b", (0, 2), (0, 0))
      content((-0.55, 1), text(size: 8pt, $V$))
      wire((0, 2), (0.6, 2))
      switch("s", (0.6, 2), (1.8, 2))
      resistor("r", (1.8, 2), (3.6, 2), label: $R$)
      capacitor("c", (3.6, 2), (3.6, 0), label: $C$)
      wire((3.6, 0), (0, 0))
    }),
    cetz.canvas({
      import cetz.draw: *
      ejes(0, 5.6, 0, 2.6, etq-x: $t$, etq-y: $v_C$)
      line((0, 2.0), (5.4, 2.0), stroke: (dash: "dashed", thickness: 0.5pt, paint: col.gris))
      content((5.4, 2.05), anchor: "south-east", text(size: 7pt)[$V$])
      onda(x => 2.0 * (1 - calc.exp(-x)), 0, 5.3, stroke: 1.2pt + col.senal1)
      line((1, 0), (1, 1.264), (0, 1.264), stroke: (dash: "dotted", thickness: 0.5pt))
      content((1, -0.05), anchor: "north", text(size: 7pt, $tau$))
      content((-0.05, 1.264), anchor: "east", text(size: 7pt)[63 %])
      line((5, 0), (5, 0.12), stroke: 0.5pt)
      content((5, -0.05), anchor: "north", text(size: 7pt, $5 tau$))
    }),
  )
] <t2-fig-rc>

#porque[
  - Al cerrar el interruptor, el condensador está descargado: su tensión es cero, así que toda la tensión $V$ cae en $R$ y la corriente arranca en $V slash R$.
  - A medida que entra carga, la tensión del condensador sube y le «quita» tensión a la resistencia: la corriente baja, y con ella la velocidad de carga. Por eso la curva sube rápido al principio y cada vez más despacio.
  - Con $R$ más grande la corriente es menor, y con $C$ más grande hace falta más carga: en los dos casos tarda más. Por eso el tiempo característico es el producto $tau = R C$.
]

#ejemplo(titulo: [El mismo condensador, dos frecuencias])[
  Un condensador de acoplo de 100 nF presenta a 50 Hz una reactancia $X_C = 1 slash (2 pi dot 50 dot 10^(-7)) approx 31,8$ kΩ, y a 7 MHz solo $X_C = 1 slash (2 pi dot 7 dot 10^6 dot 10^(-7)) approx 0,23$ Ω. Para la RF de 40 m es un cortocircuito; para la continua de polarización ($f = 0$), un circuito abierto. Eso es exactamente lo que se pide a un condensador de acoplo entre etapas. #falstad("capmultfreq.txt", texto: [Mismo condensador, tres frecuencias])
]

#ejemplo(titulo: [La energía de un condensador de alta tensión])[
  El filtro de la fuente de alta tensión de un amplificador lineal valvular puede tener 25 μF cargados a 3000 V: $E = 1/2 dot 25 dot 10^(-6) dot 3000^2 approx 112$ J. Es energía de sobra para matar, y queda guardada después de apagar el equipo. Una resistencia de descarga de 100 kΩ en paralelo da $tau = R C = 2,5$ s: en $5 tau approx 12$ s el condensador está prácticamente descargado.
]

=== Tipos de condensador y dónde se usa cada uno

El dieléctrico decide casi todo: cuánta capacidad cabe en poco espacio, cuánta tensión aguanta, cuánto pierde a alta frecuencia y cuánto varía con la temperatura. Por eso cada sitio de la radio usa un tipo distinto.

#figure(
  table(
    columns: (0.9fr, 1.3fr, 1.2fr), align: left,
    [Dieléctrico], [Ventaja (y precio)], [Dónde se usa],
    [Aire], [Pérdidas casi nulas, aguanta mucha tensión, fácil de hacer variable (y abulta)], [Condensador variable de sintonía, acopladores de antena],
    [Mica], [Muy estable y con pocas pérdidas en RF (caro)], [Osciladores y filtros de RF, etapas de potencia],
    [Cerámica], [Pequeño y barato, bueno en RF; los de tipo NP0/C0G no derivan con la temperatura], [Desacoplo de RF, osciladores],
    [Plástico (poliéster, polipropileno)], [Estable, valores medios (no es para VHF)], [Audio, temporizadores, filtros de baja frecuencia],
    [Electrolítico (óxido)], [Capacidad enorme en poco volumen (polarizado, con fugas, malo en RF)], [Filtro de la fuente de alimentación, audio],
  ),
  caption: [Tipos de condensador según el dieléctrico.],
) <t2-tab-tipos-c>

#circuito(caption: [Símbolos de condensador: fijo, electrolítico (la armadura curva es la negativa; la recta, marcada $+$, la positiva) y variable.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    let et(x, t) = content((x, -0.85), anchor: "north", text(size: 7.5pt, t))
    capacitor("c1", (0, 0), (2, 0))
    et(1, [fijo])
    pcapacitor("c2", (3, 0), (5, 0))
    content((4.35, 0.55), text(size: 7pt)[+])
    et(4, [electrolítico])
    capacitor("c3", (6, 0), (8, 0), variable: true)
    et(7, [variable])
  })
] <t2-fig-simbolos-c>

Los condensadores pequeños no llevan el valor escrito entero. Si van marcados con bandas de color, estas codifican capacidad, tolerancia y tensión máxima de trabajo (T2.12). Más frecuente hoy es un código de tres cifras en *picofaradios*: dos cifras y el número de ceros. «104» significa $10 dot 10^4$ pF = 100 000 pF = 100 nF; «471» son 470 pF.

#ojo[
  - $X_C$ *baja* al subir la frecuencia (T2.10); en la bobina ocurre lo contrario.
  - La energía del condensador es $1/2 C V^2$; la de la bobina, $1/2 L I^2$. El examen ofrece las dos en la misma pregunta (T2.13).
  - El electrolítico tiene polaridad (T2.11, T2.45) y su sitio es el filtro de la fuente, no la RF (T2.54).
]

#q("T2.6", "b",
  [La unidad de medida de la capacidad es:],
  ([el henrio], [el faradio], [el culombio], [el tesla]),
  sol: [La capacidad se mide en faradios; en la práctica, μF, nF y pF. El henrio es de la autoinducción y el culombio de la carga.],
)

#q("T2.7", "d",
  [Un condensador es un dispositivo que almacena:],
  ([corriente continua], [flujo magnético], [energía mecánica], [carga eléctrica]),
  sol: [El condensador almacena carga eléctrica (y con ella, energía en el campo eléctrico entre sus armaduras).],
)

#q("T2.8", "a",
  [La capacidad de un condensador depende de:],
  ([la geometría y disposición de sus placas y la naturaleza del dieléctrico], [la frecuencia de la señal aplicada], [el material del encapsulado], [la corriente que lo atraviesa]),
  sol: [$C = epsilon S slash d$: depende de la superficie de las placas, su separación y la permitividad del dieléctrico. No depende de la frecuencia ni de la corriente.],
)

#q("T2.9", "c",
  [Un dieléctrico es:],
  ([un buen conductor], [un semiconductor dopado], [un aislante], [un electrodo metálico]),
  sol: [Un dieléctrico es un aislante: no conduce, pero se polariza, y por eso multiplica la capacidad del condensador que lo usa entre placas.],
)

#q("T2.10", "c",
  [Al aumentar la frecuencia, la reactancia de un condensador:],
  ([aumenta], [no varía], [disminuye], [se hace infinita]),
  sol: [$X_C = 1 slash (2 pi f C)$: al aumentar $f$, la reactancia capacitiva disminuye. En la bobina ocurre lo contrario.],
)

#q("T2.11", "b",
  [Los condensadores electrolíticos:],
  ([pueden conectarse en cualquier posición], [deben conectarse respetando siempre la polaridad indicada], [solo funcionan en circuitos de alterna], [no admiten tensiones superiores a 1 V]),
  sol: [Los electrolíticos son polarizados: conectados al revés se degradan y pueden reventar. Siempre se respeta la marca de polaridad.],
)

#q("T2.12", "d",
  [Las bandas de colores de un condensador indican:],
  ([solo su tensión máxima], [su inductancia y su factor Q], [su fecha de fabricación], [su capacidad, su tolerancia y su tensión máxima de trabajo]),
  sol: [Cuando un condensador va marcado con bandas de color, estas codifican capacidad, tolerancia y tensión máxima de trabajo.],
)

#q("T2.13", "a",
  [La energía almacenada en un condensador de capacidad $C$ cargado a una tensión $V$ es:],
  ([$1/2 C V^2$], [$C V$], [$1/2 L I^2$], [$V^2 slash C$]),
  sol: [$E = 1/2 C V^2$. La opción (c) es la energía de la bobina ($1/2 L I^2$): el examen intercambia ambas fórmulas.],
)

=== Por qué en paralelo se suman y en serie no

Las reglas de asociación no hay que memorizarlas: salen de $C = epsilon S slash d$.

#circuito(caption: [Asociación de condensadores. En paralelo es como sumar superficie de placa; en serie, como alejar las placas.], sim: "capseries.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content
    let t = 8pt
    // paralelo
    wire((0, 0), (0.6, 0))
    wire((0.6, 0.75), (0.6, -0.75))
    capacitor("p1", (0.6, 0.75), (2.4, 0.75))
    capacitor("p2", (0.6, -0.75), (2.4, -0.75))
    wire((2.4, 0.75), (2.4, -0.75))
    wire((2.4, 0), (3, 0))
    node("a", (0, 0), fill: false)
    node("b", (3, 0), fill: false)
    content((1.5, 1.4), text(size: t, $C_1$))
    content((1.5, -1.4), text(size: t, $C_2$))
    content((1.5, -2.05), text(size: t)[paralelo: $C = C_1 + C_2$])
    // serie
    capacitor("s1", (5, 0), (6.8, 0), n: "o-")
    capacitor("s2", (6.8, 0), (8.6, 0), n: "-o")
    content((5.9, 0.7), text(size: t, $C_1$))
    content((7.7, 0.7), text(size: t, $C_2$))
    content((6.8, -1.0), text(size: t)[serie: $1 slash C = 1 slash C_1 + 1 slash C_2$])
  })
] <t2-fig-asoc-c>

#porque[
  - *En paralelo* las armaduras de un lado quedan unidas entre sí, y las del otro también: es como un solo condensador con la suma de las superficies. Más $S$, más capacidad: $C = C_1 + C_2$.
  - *En serie*, la carga tiene que atravesar los dos dieléctricos uno detrás de otro: es como un solo condensador con la suma de las separaciones. Más $d$, menos capacidad; el total es menor que el menor de los dos. #falstad("cappar.txt", texto: [En paralelo, en Falstad])
]

#ejemplo[
  Dos condensadores de 100 pF: en paralelo, 200 pF; en serie, $1 slash C = 1 slash 100 + 1 slash 100$, es decir, $C = 50$ pF. Con 100 pF y 10 pF en serie, $C = (100 dot 10) slash (100 + 10) approx 9,1$ pF: menos que el pequeño.
]

#nota[
  Un condensador puede guardar su carga durante horas. Para descargarlo con seguridad se unen sus dos armaduras a través de una resistencia y con un útil aislado, nunca con la mano ni con un destornillador a pelo (T2.59).
]

== Bobinas <t2-sec-bobinas>

#motivacion[
  El transistor final de un transmisor necesita recibir la continua de la fuente por el colector, pero la RF que produce no debe escaparse hacia la fuente. Hace falta lo contrario de un condensador: una pieza que deje pasar la continua sin oposición y frene la alterna de alta frecuencia. Y, junto a un condensador, esa misma pieza forma el circuito resonante que escoge una frecuencia entre todas. La explicación larga está en #ver(<sec-bobina>).
]

La bobina es el dual del condensador: donde aquel almacena energía en el campo eléctrico, esta la guarda en el campo *magnético* de la corriente que la recorre. Su *autoinducción* $L$ (henrios) mide el flujo generado por amperio, y por la ley de Faraday la bobina responde a los cambios de corriente con una fem opuesta, $e = -L dif i slash dif t$: se resiste a los cambios de corriente igual que el condensador se resiste a los cambios de tensión. Su energía es $E = 1/2 L I^2$ y su *reactancia inductiva*,
$ X_L = 2 pi f L, $
crece con la frecuencia (en continua, $f = 0 arrow.double X_L = 0$: un cortocircuito ideal); aquí es la tensión la que adelanta 90° a la corriente. La inductancia sube con el número de espiras (como $N^2$), el diámetro y el material del núcleo, y baja al alargar el devanado: para un solenoide $L = mu N^2 A slash ell$, de modo que a igualdad de espiras la bobina más apretada (menor $ell$) tiene mayor $L$. Dos pérdidas la degradan: la resistencia del hilo — agravada en RF por el *efecto pelicular*, que confina la corriente en la superficie del conductor — y las del núcleo; su cociente con la reactancia define el factor de calidad $Q = X_L slash R$.

#circuito(caption: [Bobina en solenoide: $N$ espiras de sección $A$ repartidas en una longitud $ell$. La corriente crea un campo magnético que atraviesa todas las espiras; un núcleo de ferrita o hierro concentra ese campo y multiplica $L$.])[
  #cetz.canvas({
    import cetz.draw: *
    // núcleo (gris, discontinuo)
    rect((-0.1, -0.33), (4.5, 0.33), fill: col.gris-claro, stroke: (paint: col.gris, dash: "dashed", thickness: 0.5pt))
    // campo dentro de la bobina
    line((0.3, 0), (4.1, 0), stroke: 0.8pt + col.senal1, mark: (end: ">", fill: col.senal1, scale: 0.6))
    // espiras: trazo delantero continuo, trasero punteado
    for i in range(8) {
      let x = 0.2 + i * 0.5
      line((x, -0.55), (x + 0.25, 0.55), stroke: 1.1pt + col.naranja)
      line((x + 0.25, 0.55), (x + 0.5, -0.55), stroke: (paint: col.naranja, thickness: 0.5pt, dash: "dotted"))
    }
    line((0.2, -0.55), (-0.7, -0.55), stroke: 1.1pt + col.naranja)
    line((4.2, -0.55), (5.0, -0.55), stroke: 1.1pt + col.naranja)
    // líneas de campo que se cierran por fuera
    bezier((4.7, 0.15), (-0.3, 0.15), (6.0, 1.7), (-1.6, 1.7), stroke: 0.6pt + col.senal1, mark: (end: ">", fill: col.senal1, scale: 0.5))
    bezier((4.9, 0.25), (-0.5, 0.25), (6.8, 2.5), (-2.4, 2.5), stroke: 0.6pt + col.senal1, mark: (end: ">", fill: col.senal1, scale: 0.5))
    content((2.2, 2.05), anchor: "south", text(size: 7.5pt, fill: col.senal1)[campo magnético $B$])
    // cotas
    line((0.2, -0.95), (4.2, -0.95), mark: (start: ">", end: ">", fill: black, scale: 0.5), stroke: 0.5pt)
    content((2.2, -1.05), anchor: "north", text(size: 8pt)[$ell$ ($N$ espiras)])
    line((-0.45, -0.33), (-0.45, 0.33), mark: (start: ">", end: ">", fill: black, scale: 0.4), stroke: 0.5pt)
    content((-0.55, 0), anchor: "east", text(size: 8pt, $A$))
  })
] <t2-fig-solenoide>

#analogia[
  La bobina es la *inercia* de la corriente. Piensa en el agua que llena una tubería larga y pesada: para ponerla en marcha hay que empujar un rato, y una vez en marcha no se para de golpe (el golpe de ariete de una llave que se cierra deprisa). Si el empuje va y viene muy rápido, el agua apenas llega a moverse: a alta frecuencia la bobina se opone mucho. Con un empuje constante, en cambio, el agua acaba fluyendo sin oposición: en continua la bobina ideal es un cable.
]

La simetría con el condensador es exacta: de $v = L dif i slash dif t$ sale, para corriente sinusoidal, una tensión que adelanta 90° y una reactancia $X_L = omega L$. En cuanto al efecto pelicular: la corriente alterna se autoexpulsa del interior del conductor y circula por una corteza cuyo espesor decrece como $1 slash sqrt(f)$ — a 10 MHz, unas decenas de micras. Por eso, a igual diámetro, un tubo hueco conduce la RF prácticamente tan bien como una barra maciza (el interior no aporta), y las bobinas de calidad se hacen con hilo plateado (la plata conduce mejor justo donde la corriente realmente circula).

#circuito(caption: [Efecto pelicular: sección de un hilo de cobre. En continua la corriente usa toda la sección; en RF se concentra en una corteza de espesor $delta$ (unos 21 μm a 10 MHz), y la resistencia efectiva sube.])[
  #cetz.canvas({
    import cetz.draw: *
    circle((0, 0), radius: 1, fill: col.naranja.lighten(45%), stroke: 0.7pt)
    content((0, -1.25), anchor: "north", text(size: 8pt)[continua: toda la sección])
    circle((3.4, 0), radius: 1, fill: col.naranja.lighten(45%), stroke: 0.7pt)
    circle((3.4, 0), radius: 0.8, fill: white, stroke: 0.4pt + col.gris)
    content((3.4, 0), text(size: 7pt, fill: col.gris)[casi sin\ corriente])
    line((3.4 + 0.8, 0.9), (3.4 + 0.8 * 0.72, 0.8 * 0.69), stroke: 0.4pt)
    content((4.25, 0.95), anchor: "south-west", text(size: 8pt, $delta$))
    content((3.4, -1.25), anchor: "north", text(size: 8pt)[RF: solo la corteza])
  })
] <t2-fig-pelicular>

#nota[
  Una fórmula útil para el cobre es $delta approx 66 slash sqrt(f)$ mm, con $f$ en hercios. A 10 MHz: $66 slash sqrt(10^7) approx 0,021$ mm = 21 μm. A 50 Hz son 9,3 mm: en la red el efecto apenas cuenta; en RF lo es todo.
]

#ejemplo(titulo: [Reactancia y factor de calidad])[
  Una bobina de 10 μH a 7 MHz: $X_L = 2 pi dot 7 dot 10^6 dot 10 dot 10^(-6) approx 440$ Ω. Si el hilo presenta a esa frecuencia una resistencia de 2 Ω, $Q = 440 slash 2 = 220$. La misma bobina a 50 Hz tiene $X_L approx 3$ mΩ: no frena nada. Y si doblas el número de espiras sin cambiar el tamaño, $L$ se multiplica por $2^2 = 4$, hasta 40 μH. #falstad("indmultfreq.txt", texto: [Misma bobina, tres frecuencias])
]

#circuito(caption: [Bobina y condensadores trabajando juntos en la alimentación del transistor final de un transmisor. El choque de RF ($L_"RFC"$) deja pasar la continua y frena la RF; los condensadores hacen lo contrario.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    let t = 8pt
    // alimentación y desacoplo
    node("vcc", (2.4, 5.2))
    content((2.4, 5.35), anchor: "south", text(size: t, $+13,8 "V"$))
    wire((2.4, 5.2), (2.4, 4.6))
    wire((0.6, 4.6), (2.4, 4.6))
    node("n1", (2.4, 4.6))
    capacitor("cd", (0.6, 4.6), (0.6, 3.2))
    content((0.15, 3.9), anchor: "east", text(size: t, $C_"desacoplo"$))
    ground("g1", (0.6, 3.2))
    // choque
    inductor("rfc", (2.4, 4.6), (2.4, 2.9))
    content((2.75, 3.75), anchor: "west", text(size: t, $L_"RFC"$))
    // transistor
    npn("q", (2.4, 2.2))
    wire((2.4, 2.9), "q.c")
    node("nc", (2.4, 2.9))
    wire("q.e", (2.4, 0.9))
    ground("g2", (2.4, 0.9))
    wire((-0.2, 2.2), "q.b")
    content((-0.3, 2.2), anchor: "east", text(size: t)[RF de\ excitación])
    // salida
    wire((2.4, 2.9), (3.6, 2.9))
    capacitor("cs", (3.6, 2.9), (5.2, 2.9), n: "-o")
    content((4.4, 3.55), text(size: t, $C_"acoplo"$))
    content((5.4, 2.9), anchor: "west", text(size: t)[a la antena\ (vía filtro)])
  })
] <t2-fig-rfc>

#porque[
  - *$L_"RFC"$* (choque de RF): para la continua es un cable ($X_L = 0$), así que el colector recibe los 13,8 V. Para la RF es una reactancia de miles de ohmios, así que la señal amplificada no se escapa hacia la fuente.
  - *$C_"acoplo"$*: para la RF es casi un cortocircuito y la deja salir hacia la antena; para la continua es un circuito abierto, así que los 13,8 V no llegan a la antena ni al filtro.
  - *$C_"desacoplo"$*: el poco de RF que pase el choque encuentra ahí un camino corto a masa y no viaja por el cable de alimentación hacia otras etapas. Sin él, el equipo podría autooscilar.
]

#figure(
  table(
    columns: (auto, 1fr, 1fr), align: left,
    [], [Condensador], [Bobina],
    [Guarda la energía en], [el campo eléctrico: $E = 1/2 C V^2$], [el campo magnético: $E = 1/2 L I^2$],
    [Se opone a los cambios de], [tensión], [corriente],
    [Reactancia], [$X_C = 1 slash (2 pi f C)$: baja con $f$], [$X_L = 2 pi f L$: sube con $f$],
    [En continua ($f = 0$)], [circuito abierto], [cortocircuito],
    [Desfase], [la corriente adelanta 90°], [la tensión adelanta 90°],
    [Unidad], [faradio (F)], [henrio (H)],
  ),
  caption: [Condensador y bobina son duales: todo lo que hace uno con la tensión lo hace la otra con la corriente.],
) <t2-tab-dual>

#circuito(caption: [Símbolos de bobina: con núcleo de aire, con núcleo de ferrita (línea discontinua) o de hierro (línea continua), y variable.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    let et(x, t) = content((x, -0.75), anchor: "north", text(size: 7.5pt, t))
    inductor("l1", (0, 0), (2, 0))
    et(1, [aire])
    inductor("l2", (3, 0), (5, 0))
    line((3.3, 0.5), (4.7, 0.5), stroke: (dash: "dashed", thickness: 0.8pt))
    et(4, [ferrita])
    inductor("l3", (6, 0), (8, 0))
    line((6.3, 0.5), (7.7, 0.5), stroke: 0.8pt)
    et(7, [hierro])
    inductor("l4", (9, 0), (11, 0))
    line((9.3, -0.4), (10.7, 0.75), stroke: 0.7pt, mark: (end: ">", fill: black, scale: 0.6))
    et(10, [variable])
  })
] <t2-fig-simbolos-l>

#ojo[
  - En continua, $X_L = 0$ (T2.16): la bobina ideal no frena la continua.
  - Un núcleo ferromagnético *aumenta* la autoinducción (T2.40).
  - La bobina se opone a las variaciones de *corriente* y el condensador a las de *tensión* (T2.41, T2.53). Es fácil cruzarlas.
]

#q("T2.14", "c",
  [La unidad de medida de la autoinducción de una bobina es:],
  ([el faradio], [el ohmio], [el henrio], [el weber]),
  sol: [La autoinducción se mide en henrios (H). El weber es la unidad del flujo magnético.],
)

#q("T2.15", "d",
  [El componente que almacena energía en forma de campo magnético es:],
  ([el condensador], [la resistencia], [el diodo], [la bobina]),
  sol: [La bobina almacena energía en su campo magnético ($E = 1/2 L I^2$); el condensador, en el eléctrico; la resistencia no almacena: disipa.],
)

#q("T2.16", "b",
  [La reactancia inductiva de una bobina, cuando la frecuencia de la corriente es cero (corriente continua):],
  ([es infinita], [vale cero], [es igual a su resistencia óhmica multiplicada por dos], [no puede calcularse]),
  sol: [$X_L = 2 pi f L$: con $f = 0$ (corriente continua), la reactancia es cero — la bobina ideal es un cortocircuito para la continua.],
)

#idea[
  Bobina y condensador juntos forman un *circuito resonante*: a una frecuencia $f_0 = 1 slash (2 pi sqrt(L C))$ sus reactancias se igualan y se cancelan, y la energía va y viene entre el campo eléctrico del condensador y el magnético de la bobina. Así se escoge una emisora entre todas las que recoge la antena. Lo estudia el tema T3; la explicación larga está en #ver(<sec-resonancia>).
]

== Transformadores <t2-sec-transformadores>

#motivacion[
  La red da 230 V y la emisora quiere 13,8 V. La antena dipolo plegada presenta 300 Ω y el cable coaxial, 75 Ω. Y por seguridad conviene que el equipo no esté unido eléctricamente a la red. Un mismo componente resuelve las tres cosas: dos bobinas que comparten el campo magnético. La explicación larga está en #ver(<sec-transformador>).
]

Dos bobinas acopladas por un flujo magnético común forman un transformador. Si el mismo flujo $Phi$ atraviesa las $N_p$ espiras del primario y las $N_s$ del secundario, Faraday da en cada devanado una tensión proporcional a su número de espiras, luego
$ V_s / V_p = N_s / N_p . $
En el transformador ideal no se pierde potencia ($V_p I_p = V_s I_s$), así que las corrientes van al revés: $I_s slash I_p = N_p slash N_s$. Combinando ambas, una carga $Z_s$ en el secundario se ve desde el primario como
$ Z_p = (N_p / N_s)^2 Z_s : $
el transformador también _adapta impedancias_, no solo tensiones (así funciona el balun de relación 4:1 del tema T6). Reducir tensión exige menos espiras en el secundario; elevarla, más.

#circuito(caption: [Transformador reductor con una carga $Z_s$. El primario tiene más espiras que el secundario: la tensión baja y la corriente sube en la misma proporción.], sim: "transformerdown.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content
    let t = 8pt
    trafo("t", (3, 1), espiras: (5, 2))
    acvsource("v", (0.6, 0), (0.6, 2))
    wire((0.6, 2), "t.p1")
    wire((0.6, 0), "t.p2")
    content((-0.1, 1), anchor: "east", text(size: t, $V_p$))
    wire("t.s1", (4.4, 1.4), (4.4, 2), (5.6, 2))
    wire("t.s2", (4.4, 0.6), (4.4, 0), (5.6, 0))
    resistor("z", (5.6, 2), (5.6, 0))
    content((6.05, 1), anchor: "west", text(size: t, $Z_s$))
    content((2.55, -0.4), text(size: t)[$N_p$ espiras])
    content((3.75, 0.2), anchor: "north-west", text(size: t)[$N_s$])
    content((4.95, 1), text(size: t, $V_s$))
    content((1.3, 2.3), text(size: t, $I_p arrow.r$))
    content((5.0, 2.3), text(size: t, $I_s arrow.r$))
  })
] <t2-fig-trafo>

#porque[
  - La corriente alterna del primario crea en el núcleo un flujo que cambia sin parar. Ese mismo flujo atraviesa cada espira del secundario y, por Faraday, induce en cada una la misma tensión que en cada espira del primario. Con menos espiras, la suma es menor: $V_s = V_p N_s slash N_p$.
  - La energía no se crea: si la tensión baja, la corriente sube en la misma proporción, y $V_p I_p = V_s I_s$.
  - Desde el primario, la carga parece $Z_p = V_p slash I_p = (N_p slash N_s) V_s slash ((N_s slash N_p) I_s) = (N_p slash N_s)^2 Z_s$. El cuadrado aparece porque la relación de espiras actúa *dos veces*: sobre la tensión y sobre la corriente.
  - En continua el flujo no cambia y no se induce nada: el transformador solo funciona con alterna.
]

#ejemplo[
  Adaptación por transformador: para presentar 75 Ω a la línea cuando la antena ofrece 300 Ω hace falta $N_p slash N_s = sqrt(Z_p slash Z_s) = sqrt(75 slash 300) = 1 slash 2$ — un transformador 1:2 en espiras, que es exactamente lo que hace un balun de relación 4:1 en impedancia.
]

#ejemplo(titulo: [El transformador de salida de un amplificador valvular])[
  Una válvula de audio quiere ver en su placa una carga de 5000 Ω, y el altavoz tiene 8 Ω. La relación de espiras necesaria es $N_p slash N_s = sqrt(5000 slash 8) = 25$. Con 25:1, el altavoz de 8 Ω «parece» desde la válvula $25^2 dot 8 = 5000$ Ω. Sin el transformador, la válvula entregaría casi toda su potencia en calor dentro de sí misma.
]

=== El núcleo y el autotransformador

El núcleo decide dónde sirve un transformador. Uno de *hierro* concentra el flujo y da mucha inductancia: es el de la red de 50 Hz; se hace de chapas delgadas aisladas entre sí para cortar las corrientes de Foucault, que lo calentarían. A frecuencias de radio las pérdidas del hierro serían enormes, y se usa *ferrita* (un material magnético que pierde poco en RF) o simplemente *aire*: sin pérdidas en el núcleo ni saturación, a cambio de mucha menos inductancia y, a baja frecuencia, de un factor de calidad pobre (T2.55).

#circuito(caption: [Autotransformador: un solo devanado con una toma intermedia. Las espiras de abajo pertenecen a la vez al primario y al secundario.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    inductor("la", (2, 3), (2, 1.5))
    inductor("lb", (2, 1.5), (2, 0))
    wire((0.4, 3), (2, 3))
    node("e1", (0.4, 3), fill: false)
    wire((0.4, 0), (4, 0))
    node("e2", (0.4, 0), fill: false)
    wire((2, 1.5), (4, 1.5))
    node("s1", (4, 1.5), fill: false)
    node("s2", (4, 0), fill: false)
    content((0, 1.5), text(size: 8pt)[entrada\ ($N_p$)])
    content((4.5, 0.75), text(size: 8pt)[salida\ ($N_s$)])
    node("tap", (2, 1.5))
  })
] <t2-fig-auto>

#porque[
  La tensión por espira es la misma en todo el devanado, así que la salida, tomada entre la toma y el extremo común, vale $V_p dot N_s slash N_p$, igual que en un transformador de dos devanados. Ahorra cobre y hierro, pero la entrada y la salida comparten un conductor: no hay aislamiento galvánico (T2.39).
]

#ojo[
  - La relación de transformación es $N_p slash N_s$, y la tensión del secundario es $V_p dot N_s slash N_p$. Con 20:1 y 230 V salen 11,5 V; el distractor de 4600 V multiplica en vez de dividir (T2.19).
  - Para reducir la tensión, el *secundario* tiene menos espiras (T2.20).
  - La impedancia va con el *cuadrado* de la relación de espiras (T2.60).
]

#q("T2.17", "a",
  [Un transformador está formado, como mínimo, por:],
  ([dos bobinas acopladas], [dos condensadores en serie], [una bobina y un diodo], [dos resistencias apareadas]),
  sol: [Un transformador son, como mínimo, dos bobinas acopladas magnéticamente (primario y secundario), normalmente sobre un núcleo común.],
)

#q("T2.18", "c",
  [En un transformador, se conoce como «relación de transformación»:],
  ([el cociente entre la potencia de entrada y la de salida], [el rendimiento del núcleo magnético], [la relación entre el número de espiras del primario y el del secundario], [la relación entre su peso y su volumen]),
  sol: [La relación de transformación es $N_p slash N_s$, el cociente entre las espiras del primario y del secundario, que fija la relación de tensiones.],
)

#q("T2.19", "c",
  [Un transformador ideal tiene una relación de espiras primario/secundario de 20:1. Si se aplican 230 V al primario, la tensión en el secundario es:],
  ([4600 V], [46 V], [11,5 V], [23 V]),
  sol: [$V_s = V_p dot N_s slash N_p = 230 slash 20 = 11,5$ V. El distractor de 4600 V invierte la relación.],
)

#q("T2.20", "b",
  [Para que un transformador reduzca la tensión, es necesario que:],
  ([el primario tenga menos espiras que el secundario], [el secundario tenga menos espiras que el primario], [ambos devanados tengan el mismo número de espiras], [el núcleo sea de aire]),
  sol: [Reductor de tensión $arrow.double$ menos espiras en el secundario ($V_s slash V_p = N_s slash N_p < 1$).],
)

== Semiconductores y otros componentes <t2-sec-semiconductores>

#motivacion[
  Las resistencias, los condensadores y las bobinas solo reparten, guardan o devuelven energía: ninguno puede hacer una señal *más grande*. Pero la señal de la antena tiene microvoltios y el altavoz necesita voltios. Hace falta una pieza en la que una señal pequeña gobierne una corriente grande, sacada de la fuente. Esa pieza es el transistor, y para entenderlo hay que empezar por un material que no es ni conductor ni aislante, y por la pieza más simple que se hace con él: el diodo.
]

=== De qué está hecho un semiconductor

El silicio y el germanio tienen cuatro electrones de valencia. En el cristal, cada átomo los comparte con sus cuatro vecinos y todos quedan sujetos en los enlaces: a temperatura ambiente casi no hay electrones libres, y el silicio puro conduce muy mal. Su gracia es que esa conductividad se puede *gobernar* añadiendo impurezas, lo que se llama *dopar*:

- *Tipo N*: se añade un poco de un elemento de cinco electrones de valencia (fósforo, arsénico). Cuatro forman enlaces y el quinto sobra: queda libre para moverse. Hay más electrones libres que huecos.
- *Tipo P*: se añade un elemento de tres electrones de valencia (boro, galio). A uno de los enlaces le falta un electrón: es un *hueco*. Un electrón vecino puede saltar a ese hueco y dejar otro detrás, de modo que el hueco «viaja» como una carga positiva. Hay más huecos que electrones libres.

#circuito(caption: [Red de silicio dopada. A la izquierda, un átomo de fósforo (5 electrones de valencia) deja un electrón libre: tipo N. A la derecha, un átomo de boro (3 electrones) deja un hueco en un enlace: tipo P.])[
  #cetz.canvas({
    import cetz.draw: *
    let red(ox, centro, extra) = {
      for i in range(3) {
        for j in range(3) {
          let p = (ox + i * 1.3, j * 1.3)
          if i < 2 { line((p.at(0) + 0.3, p.at(1) + 0.06), (p.at(0) + 1.0, p.at(1) + 0.06), stroke: 0.5pt + col.gris); line((p.at(0) + 0.3, p.at(1) - 0.06), (p.at(0) + 1.0, p.at(1) - 0.06), stroke: 0.5pt + col.gris) }
          if j < 2 { line((p.at(0) + 0.06, p.at(1) + 0.3), (p.at(0) + 0.06, p.at(1) + 1.0), stroke: 0.5pt + col.gris); line((p.at(0) - 0.06, p.at(1) + 0.3), (p.at(0) - 0.06, p.at(1) + 1.0), stroke: 0.5pt + col.gris) }
        }
      }
      for i in range(3) {
        for j in range(3) {
          let p = (ox + i * 1.3, j * 1.3)
          let es-centro = (i == 1 and j == 1)
          circle(p, radius: 0.3, fill: if es-centro { centro.at(1) } else { white }, stroke: 0.7pt)
          content(p, text(size: 7pt, weight: if es-centro { "bold" } else { "regular" }, if es-centro { centro.at(0) } else { [Si] }))
        }
      }
      extra
    }
    red(0, ([P], col.senal1.lighten(70%)), {
      circle((1.3 + 0.55, 1.3 + 0.55), radius: 0.09, fill: col.senal1, stroke: none)
      line((1.3 + 0.62, 1.3 + 0.62), (1.3 + 0.95, 1.3 + 0.95), stroke: 0.4pt + col.senal1, mark: (end: ">", fill: col.senal1, scale: 0.4))
      content((1.3, -0.65), text(size: 8pt)[tipo N: electrón libre])
    })
    red(4.6, ([B], col.senal2.lighten(70%)), {
      circle((4.6 + 1.3 + 0.65, 1.3 - 0.06), radius: 0.09, fill: white, stroke: 0.8pt + col.senal2)
      content((4.6 + 1.3, -0.65), text(size: 8pt)[tipo P: hueco])
    })
  })
] <t2-fig-dopado>

#ojo[
  El semiconductor tipo P tiene *más huecos* que electrones libres (T2.35); el hueco es la ausencia de un electrón, y se comporta como un portador de carga *positiva* (T2.36). Semiconductores clásicos: silicio y germanio (T2.37); el cobre y el aluminio son conductores, y la porcelana es un aislante.
]

=== La unión PN y el diodo

#motivacion[
  La fuente de alimentación recibe alterna de la red y tiene que entregar continua: hace falta una pieza que deje pasar la corriente en un sentido y la bloquee en el otro, como una válvula antirretorno en una tubería. El detector de AM necesita lo mismo para recuperar el sonido. La explicación larga está en #ver(<sec-diodo>).
]

La pieza básica es la *unión PN*: al juntar semiconductor dopado con huecos (P) y con electrones (N) se forma en la frontera una zona vacía de portadores — la *zona de deplexión* — que se estrecha al polarizar en directa (y el *diodo* conduce) y se ensancha en inversa (y bloquea, salvo una pequeña *corriente de fuga* que crece con la temperatura, hasta que al superar la *tensión inversa* máxima —el pico inverso de repetición— sobreviene la ruptura). De ese comportamiento asimétrico viven el rectificador y el detector.

#circuito(caption: [La unión PN. En la frontera, los electrones de N rellenan huecos de P y dejan una zona sin portadores (zona de deplexión) con iones fijos: negativos en el lado P y positivos en el lado N. En directa la zona se estrecha y pasa corriente; en inversa se ensancha y no pasa.])[
  #cetz.canvas({
    import cetz.draw: *
    let fila(y, mitad, titulo, pol) = {
      // P
      rect((0, y), (3 - mitad, y + 1), fill: col.senal2.lighten(82%), stroke: none)
      // N
      rect((3 + mitad, y), (6, y + 1), fill: col.senal1.lighten(82%), stroke: none)
      // zona
      rect((3 - mitad, y), (3 + mitad, y + 1), fill: white, stroke: none)
      rect((0, y), (6, y + 1), stroke: 0.6pt)
      line((3, y), (3, y + 1), stroke: (dash: "dotted", thickness: 0.4pt))
      // portadores
      for k in range(int((3 - mitad - 0.3) / 0.45) + 1) {
        let x = 0.3 + k * 0.45
        if x < 3 - mitad - 0.12 {
          circle((x, y + 0.32), radius: 0.08, fill: white, stroke: 0.6pt + col.senal2)
          circle((x + 0.22, y + 0.7), radius: 0.08, fill: white, stroke: 0.6pt + col.senal2)
        }
      }
      for k in range(int((3 - mitad - 0.3) / 0.45) + 1) {
        let x = 6 - 0.3 - k * 0.45
        if x > 3 + mitad + 0.12 {
          circle((x, y + 0.32), radius: 0.07, fill: col.senal1, stroke: none)
          circle((x - 0.22, y + 0.7), radius: 0.07, fill: col.senal1, stroke: none)
        }
      }
      // iones fijos
      if mitad > 0.15 {
        let n = calc.max(1, int(mitad / 0.25))
        for k in range(n) {
          let dx = 0.13 + k * (mitad - 0.1) / n
          content((3 - dx, y + 0.3), text(size: 7pt, fill: col.senal2)[−])
          content((3 - dx, y + 0.72), text(size: 7pt, fill: col.senal2)[−])
          content((3 + dx, y + 0.3), text(size: 7pt, fill: col.senal1)[+])
          content((3 + dx, y + 0.72), text(size: 7pt, fill: col.senal1)[+])
        }
      }
      content((-0.15, y + 0.5), anchor: "east", text(size: 8pt, weight: "bold")[P])
      content((6.15, y + 0.5), anchor: "west", text(size: 8pt, weight: "bold")[N])
      content((6.6, y + 0.5), anchor: "west", text(size: 8pt)[#titulo])
      if pol != none { content((3, y - 0.05), anchor: "north", text(size: 7pt, fill: col.gris, pol)) }
    }
    fila(4, 0.5, [sin tensión: equilibrio], none)
    fila(2.2, 0.18, [directa: la zona se estrecha → *conduce*], [$+$ al lado P, $-$ al lado N])
    fila(0.4, 1.0, [inversa: la zona se ensancha → *bloquea*], [$-$ al lado P, $+$ al lado N])
    // leyenda
    circle((0.3, -0.75), radius: 0.08, fill: white, stroke: 0.6pt + col.senal2)
    content((0.45, -0.75), anchor: "west", text(size: 7pt)[hueco])
    circle((1.75, -0.75), radius: 0.07, fill: col.senal1, stroke: none)
    content((1.9, -0.75), anchor: "west", text(size: 7pt)[electrón libre])
    content((3.75, -0.75), anchor: "west", text(size: 7pt)[$-$ $+$ : iones fijos de la zona de deplexión])
  })
] <t2-fig-pn>

#analogia[
  La zona de deplexión es un muro con una puerta que solo abre hacia un lado. En directa, la pila empuja los huecos de P y los electrones de N *hacia* la frontera: el muro adelgaza hasta desaparecer (hacen falta unos 0,6 V en el silicio) y los portadores lo cruzan en masa. En inversa, la pila los *aleja* de la frontera: el muro se hace más grueso y solo pasa un goteo, la corriente de fuga.
]

Para leer esquemas conviene retener unos pocos números. El diodo de silicio empieza a conducir hacia 0,6–0,7 V (en las cuentas de este libro, 0,6 V) — su característica real es la exponencial $I = I_s (e^(V slash V_T) - 1)$, con $V_T approx 25$ mV a temperatura ambiente — y la capacidad del varicap decrece con la tensión inversa aproximadamente como $1 slash sqrt(V)$.

#circuito(caption: [Curva característica de un diodo de silicio. En directa casi no pasa corriente hasta unos 0,6 V; luego crece de forma exponencial. En inversa solo hay una pequeña corriente de fuga, hasta la tensión de ruptura. El zéner trabaja a propósito en esa zona de ruptura.], sim: "diodecurve.txt")[
  #cetz.canvas({
    import cetz.draw: *
    ejes(-4.4, 3.4, -2.6, 3.0, etq-x: $V$, etq-y: $I$)
    // directa
    onda(x => calc.min(2.8, 0.0006 * calc.exp(x * 4.6)), 0, 1.85, stroke: 1.3pt + col.senal1)
    // inversa: fuga y ruptura
    line((0, 0), (-3.2, -0.12), stroke: 1.3pt + col.senal1)
    bezier((-3.2, -0.12), (-3.45, -2.4), (-3.35, -0.2), (-3.42, -1.0), stroke: 1.3pt + col.senal1)
    line((1.3, 0), (1.3, -0.12), stroke: 0.5pt)
    content((1.3, -0.15), anchor: "north", text(size: 7pt)[0,6 V])
    content((1.9, 2.4), anchor: "west", text(size: 7.5pt)[directa:\ conduce])
    content((-1.6, 0.35), anchor: "south", text(size: 7.5pt)[inversa: corriente de fuga])
    line((-3.3, -0.1), (-3.3, 0.6), stroke: (dash: "dotted", thickness: 0.4pt))
    content((-3.3, 0.65), anchor: "south", text(size: 7.5pt)[$-V_"R"$])
    content((-3.55, -1.6), anchor: "east", text(size: 7.5pt)[ruptura\ (zona del zéner)])
  })
] <t2-fig-curva-diodo>

#circuito(caption: [Símbolo del diodo y aspecto real. El triángulo señala el sentido en que pasa la corriente (de ánodo a cátodo); la barra del símbolo coincide con la franja pintada en el cuerpo, que marca el cátodo.])[
  #grid(columns: 2, column-gutter: 1.5cm, align: horizon,
    esquema({
      import zap: *
      import cetz.draw: content, line
      diode("d", (0, 0), (2.4, 0))
      content((0, 0.35), text(size: 8pt)[ánodo])
      content((2.4, 0.35), text(size: 8pt)[cátodo])
      line((0.5, -0.55), (1.9, -0.55), stroke: 0.5pt, mark: (end: ">", fill: black, scale: 0.5))
      content((1.2, -0.7), anchor: "north", text(size: 7.5pt)[sentido de paso])
    }),
    cetz.canvas({
      import cetz.draw: *
      line((-1, 0), (0, 0), stroke: 1.2pt + col.gris)
      line((2.2, 0), (3.2, 0), stroke: 1.2pt + col.gris)
      rect((0, -0.3), (2.2, 0.3), radius: 0.08, fill: col.tinta, stroke: none)
      rect((1.65, -0.3), (1.9, 0.3), fill: col.gris-claro, stroke: none)
      content((1.78, 0.45), anchor: "south", text(size: 7.5pt)[franja = cátodo])
    }),
  )
] <t2-fig-diodo-simbolo>

#circuito(caption: [Rectificador de media onda. El diodo solo deja pasar los semiciclos positivos; en la carga queda una corriente de un solo sentido, todavía a impulsos. El condensador de filtro que la alisa se estudia en las fuentes de alimentación del tema T3.], sim: "rectify.txt")[
  #grid(columns: 2, column-gutter: 1.0cm, align: horizon,
    esquema({
      import zap: *
      import cetz.draw: content
      acvsource("v", (0, 0), (0, 2))
      content((-0.55, 1), anchor: "east", text(size: 8pt, $v_"ent"$))
      wire((0, 2), (0.6, 2))
      diode("d", (0.6, 2), (2.4, 2))
      content((1.5, 2.5), text(size: 8pt, $D$))
      wire((2.4, 2), (3.2, 2))
      resistor("rl", (3.2, 2), (3.2, 0))
      content((2.75, 1), anchor: "east", text(size: 8pt, $R_L$))
      content((3.65, 1), anchor: "west", text(size: 8pt, $v_"sal"$))
      wire((3.2, 0), (0, 0))
    }),
    cetz.canvas({
      import cetz.draw: *
      ejes(0, 5.2, -1.2, 1.4, etq-x: $t$, etq-y: none)
      onda(x => calc.sin(2 * x), 0, 5, stroke: (paint: col.gris, thickness: 0.7pt, dash: "dashed"))
      onda(x => calc.max(0, 0.9 * calc.sin(2 * x)), 0, 5, stroke: 1.3pt + col.senal2)
      content((2.6, -1.35), anchor: "north", text(size: 7.5pt)[#text(fill: col.gris)[discontinua: $v_"ent"$] · #text(fill: col.senal2)[continua: $v_"sal"$]])
    }),
  )
] <t2-fig-rectificador>

#porque[
  - En el semiciclo positivo el ánodo está por encima del cátodo: el diodo está en directa y conduce; la tensión de la fuente aparece en $R_L$ (menos los 0,6 V del diodo).
  - En el semiciclo negativo el diodo queda en inversa y bloquea: por $R_L$ no pasa nada y la salida es cero.
  - La corriente en $R_L$ va siempre en el mismo sentido: es continua, aunque a impulsos. Un condensador grande en paralelo con $R_L$ la alisaría (#ver(<sec-fuente>)). El detector de AM usa el mismo principio a radiofrecuencia (#ver(<sec-detector>)).
]

=== Tres diodos especiales: zéner, LED y varicap

Tres diodos especiales recorren el temario: el *zéner*, que en inversa mantiene una tensión casi constante (estabilización); el *LED*, que emite luz al conducir; y el *varicap*, que aprovecha que la zona de deplexión es un condensador cuya anchura — y por tanto capacidad — depende de la tensión inversa: un condensador controlado por tensión, corazón de la sintonía electrónica y de los VCO (tema T3).

#circuito(caption: [Símbolos de los diodos del temario.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    let et(x, t) = content((x, -0.75), anchor: "north", text(size: 7.5pt, t))
    diode("d1", (0, 0), (2, 0))
    et(1, [rectificador])
    zener("d2", (3, 0), (5, 0))
    et(4, [zéner])
    led("d3", (6, 0), (8, 0))
    et(7, [LED])
    _t2-varicap(9, 11)
    et(10, [varicap])
  })
] <t2-fig-simbolos-d>

==== El zéner: una tensión fija

#motivacion[
  Un oscilador cambia de frecuencia si su tensión de alimentación cambia, y la batería de un coche varía entre 12 y 14,5 V. Hace falta una tensión que no se mueva aunque cambie la entrada o la carga.
]

#circuito(caption: [Estabilizador con diodo zéner. El zéner va en inversa (cátodo hacia el positivo) y mantiene en la carga su tensión de ruptura $V_Z$.], sim: "zenerref.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content
    let t = 8pt
    node("e", (0, 2), fill: false)
    content((0, 2.25), anchor: "south", text(size: t)[$V_"ent"$ = 13,8 V])
    resistor("r", (0, 2), (2.4, 2))
    content((1.2, 2.5), text(size: t, $R$))
    wire((2.4, 2), (4.4, 2))
    node("nz", (2.4, 2))
    zener("z", (2.4, 0), (2.4, 2))
    content((2.0, 1), anchor: "east", text(size: t)[$V_Z$ = 5,1 V])
    resistor("rl", (4.4, 2), (4.4, 0))
    content((4.85, 1), anchor: "west", text(size: t, $R_L$))
    node("s", (4.4, 2), fill: false)
    content((4.4, 2.25), anchor: "south", text(size: t, $V_"sal"$))
    wire((0, 0), (4.4, 0))
    node("e0", (0, 0), fill: false)
    ground("g", (2.4, 0))
  })
] <t2-fig-zener>

#porque[
  - El zéner en inversa no conduce hasta que su tensión llega a $V_Z$; a partir de ahí conduce tanto como haga falta para no pasar de $V_Z$ (la caída casi vertical de la @t2-fig-curva-diodo). #falstad("zeneriv.txt", texto: [Curva del zéner])
  - $R$ absorbe la diferencia entre la entrada y $V_Z$. Si la entrada sube, sube la corriente por $R$, pero ese exceso se lo traga el zéner; la tensión de salida casi no cambia.
  - Sin $R$, el zéner quedaría directamente sobre la fuente y conduciría una corriente enorme hasta quemarse.
]

#ejemplo[
  Se quieren 5,1 V para una carga de 10 mA a partir de 13,8 V, dejando otros 10 mA para el zéner. Por $R$ pasan 20 mA y caen $13,8 - 5,1 = 8,7$ V: $R = 8,7 slash 0,02 = 435$ Ω, es decir, 430 Ω normalizados. Disipa $8,7 dot 0,02 approx 0,17$ W: mejor de 1/2 W que de 1/4 W, para ir con margen.
]

==== El LED: luz al conducir

El LED (_light emitting diode_) es un diodo que, al conducir en directa, convierte parte de la energía de los portadores en luz. Su caída de tensión es mayor que la del silicio (de 1,8 V en un LED rojo a unos 3 V en uno azul o blanco) y, como todo diodo en directa, no limita por sí mismo su corriente: siempre lleva una resistencia en serie.

#ejemplo[
  Un LED rojo de 2 V y 10 mA como piloto de una fuente de 13,8 V: $R = (13,8 - 2) slash 0,01 = 1180$ Ω, es decir, 1,2 kΩ normalizados. Disipa $11,8^2 slash 1200 approx 0,12$ W: basta con 1/4 W.
]

==== El varicap: un condensador que se ajusta con una tensión

#motivacion[
  Para cambiar de frecuencia, las radios antiguas giraban un condensador variable de aire: grande, mecánico y imposible de mover desde un microprocesador. Un sintetizador o un barrido automático necesitan sintonizar con una *tensión*.
]

En inversa, la unión PN es un condensador de verdad: las zonas P y N, que conducen, son las armaduras, y la zona de deplexión, que no tiene portadores, es el dieléctrico. Al subir la tensión inversa, la zona se ensancha (@t2-fig-pn): es como separar las placas, y por $C = epsilon S slash d$ la capacidad baja. La anchura crece aproximadamente como $sqrt(V)$, y por eso la capacidad cae como $1 slash sqrt(V)$. #falstad("varactor.txt", texto: [Tres varactores en Falstad])

#circuito(caption: [A la izquierda, capacidad de un varicap frente a la tensión inversa. A la derecha, un varicap sintoniza el circuito resonante de un oscilador controlado por tensión (VCO).], sim: "varactorvco.txt")[
  #grid(columns: 2, column-gutter: 1.0cm, align: horizon,
    cetz.canvas({
      import cetz.draw: *
      ejes(0, 4.6, 0, 3.0, etq-x: [tensión inversa], etq-y: $C$)
      onda(x => 2.6 / calc.sqrt(1 + 2.2 * x), 0, 4.3, stroke: 1.3pt + col.senal1)
      content((2.4, 1.3), anchor: "west", text(size: 7.5pt)[$C prop 1 slash sqrt(V)$])
    }),
    esquema({
      import zap: *
      import cetz.draw: content
      let t = 8pt
      node("vt", (0, 3), fill: false)
      content((0, 3.25), anchor: "south", text(size: t, $V_"sint"$))
      resistor("r", (0, 3), (2, 3))
      content((1, 3.5), text(size: t, $R$))
      wire((2, 3), (2, 2.55))
      node("nv", (2, 2.55))
      // varicap vertical: cátodo (barras) arriba, ánodo abajo
      cetz.draw.line((2, 2.55), (2, 1.71), stroke: 0.6pt)
      cetz.draw.line((1.74, 1.71), (2.26, 1.71), stroke: 0.8pt)
      cetz.draw.line((1.74, 1.57), (2.26, 1.57), stroke: 0.8pt)
      cetz.draw.line((1.74, 1.2), (2.26, 1.2), (2, 1.57), close: true, stroke: 0.8pt, fill: white)
      cetz.draw.line((2, 1.2), (2, 0), stroke: 0.6pt)
      content((1.6, 1.45), anchor: "east", text(size: t, $C_V$))
      capacitor("cb", (2, 2.55), (3.8, 2.55))
      content((2.9, 3.1), text(size: t, $C_b$))
      inductor("l", (3.8, 2.55), (3.8, 0))
      content((4.25, 1.3), anchor: "west", text(size: t, $L$))
      wire((3.8, 2.55), (4.6, 2.55))
      content((5.1, 2.55), anchor: "west", text(size: 8pt)[al oscilador])
      wire((2, 0), (3.8, 0))
      ground("g", (2.9, 0))
    }),
  )
] <t2-fig-varicap>

#porque[
  - $V_"sint"$ es positiva y llega al cátodo del varicap $C_V$, cuyo ánodo está a masa: el varicap está en inversa, que es como debe trabajar.
  - $C_b$ bloquea la continua. Sin él, la bobina, que es un cortocircuito en continua, pondría a masa la tensión de sintonía. Se elige mucho mayor que $C_V$, así que para la RF es un cable y el varicap queda en paralelo con $L$.
  - $R$ (de unos 100 kΩ) lleva la tensión de sintonía sin cargar el circuito resonante: la fuente de $V_"sint"$ tiene impedancia baja y, conectada directamente, «se comería» la RF.
  - Subir $V_"sint"$ reduce $C_V$ y sube la frecuencia, $f_0 = 1 slash (2 pi sqrt(L C))$. Así sintoniza el VCO de un sintetizador (#ver(<sec-oscilador>)).
]

#ejemplo[
  Con $L = 1$ μH y un varicap que va de 80 pF (tensión baja) a 20 pF (tensión alta): $f = 1 slash (2 pi sqrt(10^(-6) dot 80 dot 10^(-12))) approx 17,8$ MHz y $f = 1 slash (2 pi sqrt(10^(-6) dot 20 dot 10^(-12))) approx 35,6$ MHz. Una variación de capacidad 4:1 da una variación de frecuencia 2:1, porque la frecuencia va con la raíz.
]

=== El transistor bipolar

#motivacion[
  Ahora sí: una pieza en la que una corriente pequeña gobierne otra grande. Se consigue poniendo *dos* uniones PN espalda con espalda, con una capa central muy fina. La explicación larga, con todos los dibujos, está en #ver(<sec-transistor>).
]

El *transistor bipolar* (BJT, tipos NPN y PNP) son dos uniones enfrentadas con tres terminales: *emisor, base y colector*. Una pequeña corriente de base controla una corriente de colector $beta$ veces mayor ($I_C = beta I_B$, con $beta$ típicamente 50–300): amplificación.

#circuito(caption: [Transistor NPN por dentro. La unión base-emisor está en directa (unos 0,6 V) y lanza electrones hacia la base; como la base es muy fina, casi todos la atraviesan y los recoge el colector, que está más positivo. Solo unos pocos salen por la base: esa es la corriente pequeña que gobierna la grande.])[
  #cetz.canvas({
    import cetz.draw: *
    rect((0, 0), (2.6, 1.6), fill: col.senal1.lighten(80%), stroke: 0.6pt)
    rect((2.6, 0), (3.2, 1.6), fill: col.senal2.lighten(80%), stroke: 0.6pt)
    rect((3.2, 0), (6, 1.6), fill: col.senal1.lighten(80%), stroke: 0.6pt)
    content((1.3, 1.3), text(size: 8pt, weight: "bold")[N (emisor)])
    content((2.9, 1.3), text(size: 8pt, weight: "bold")[P])
    content((4.6, 1.3), text(size: 8pt, weight: "bold")[N (colector)])
    // flechas de electrones
    for y in (0.35, 0.65, 0.95) {
      line((0.6, y), (5.5, y), stroke: 0.8pt + col.senal1, mark: (end: ">", fill: col.senal1, scale: 0.5))
    }
    line((2.75, 0.5), (2.9, -0.55), stroke: 0.6pt + col.senal1, mark: (end: ">", fill: col.senal1, scale: 0.45))
    // terminales
    line((0, 0.8), (-0.6, 0.8), stroke: 0.7pt)
    content((-0.7, 0.8), anchor: "east", text(size: 8pt)[E])
    line((6, 0.8), (6.6, 0.8), stroke: 0.7pt)
    content((6.7, 0.8), anchor: "west", text(size: 8pt)[C])
    line((2.9, 0), (2.9, -0.8), stroke: 0.7pt)
    content((2.9, -0.9), anchor: "north", text(size: 8pt)[B])
    content((3.2, -0.45), anchor: "west", text(size: 7pt, fill: col.senal1)[pocos electrones salen por la base])
    content((3, 1.85), anchor: "south", text(size: 7pt, fill: col.gris)[base muy fina])
  })
] <t2-fig-bjt-dentro>

#circuito(caption: [Símbolos y polaridades de trabajo. En el NPN el colector y la base están más positivos que el emisor; en el PNP, más negativos. La flecha del emisor señala el sentido de la corriente convencional: sale en el NPN y entra en el PNP. En los dos, $I_E = I_B + I_C$.], sim: "npn.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    // NPN
    npn("q1", (1.5, 1.5))
    wire("q1.b", (0.3, 1.5))
    wire("q1.c", (1.5, 2.8))
    wire("q1.e", (1.5, 0.2))
    content((0.2, 1.5), anchor: "east", text(size: 8pt)[B (+0,6 V)])
    content((1.65, 2.8), anchor: "west", text(size: 8pt)[C (+)])
    content((1.65, 0.2), anchor: "west", text(size: 8pt)[E (0 V)])
    content((0.45, 1.75), text(size: 7pt, fill: col.senal2)[$I_B arrow.r$])
    content((1.95, 2.35), text(size: 7pt, fill: col.senal2)[$I_C arrow.b$])
    content((1.95, 0.65), text(size: 7pt, fill: col.senal2)[$I_E arrow.b$])
    content((1.1, -0.4), text(size: 8pt, weight: "bold")[NPN])
    // PNP
    pnp("q2", (6.5, 1.5))
    wire("q2.b", (5.3, 1.5))
    wire("q2.c", (6.5, 0.2))
    wire("q2.e", (6.5, 2.8))
    content((5.2, 1.5), anchor: "east", text(size: 8pt)[B (−0,6 V)])
    content((6.65, 2.8), anchor: "west", text(size: 8pt)[E (0 V)])
    content((6.65, 0.2), anchor: "west", text(size: 8pt)[C (−)])
    content((5.45, 1.75), text(size: 7pt, fill: col.senal2)[$arrow.l I_B$])
    content((6.95, 2.35), text(size: 7pt, fill: col.senal2)[$I_E arrow.b$])
    content((6.95, 0.65), text(size: 7pt, fill: col.senal2)[$I_C arrow.b$])
    content((6.1, -0.4), text(size: 8pt, weight: "bold")[PNP])
  })
] <t2-fig-bjt-simbolos>

#truco[
  Para recordar la flecha: en el *PNP* la flecha «PiNcha» hacia dentro (P, N); en el *NPN*, «No PiNcha» (N, P, N): sale hacia fuera.
]

#analogia[
  El transistor es un grifo de un depósito a presión. La base es la maneta: moverla cuesta muy poco (la corriente de base, microamperios), pero gobierna un caudal grande (la corriente de colector, miliamperios) que no sale de la mano, sino del depósito: la fuente de alimentación. Amplificar no es crear energía, es *gobernar* la de la fuente al ritmo de la señal.
]

#ejemplo[
  Con $beta = 100$, una corriente de base de 20 μA gobierna una de colector de 2 mA: la señal minúscula de un micrófono, amplificada cien veces en corriente. Dos etapas encadenadas: $times 10^4$.
]

#ojo[
  - En el NPN el colector es *positivo* respecto del emisor (T2.48); en el PNP el colector es *negativo* respecto de la base y del emisor (T2.49). #falstad("pnp.txt", texto: [El PNP en Falstad])
  - $beta = I_C slash I_B$, colector entre base (T2.32).
  - El semiconductor es sensible al calor: si el transistor se calienta, su corriente crece, se calienta más y puede destruirse (*embalamiento térmico*). Por eso llevan radiador y por eso el examen lo da como el inconveniente frente a las válvulas (T2.42).
]

=== El transistor de efecto de campo

#motivacion[
  El bipolar necesita corriente de base: la etapa anterior tiene que entregarla, y eso la carga. En la primera etapa de un receptor, donde la señal de la antena es débil, o en un oscilador que debe ser estable, interesa un dispositivo que se gobierne con *tensión*, sin tomar casi corriente. La explicación larga está en #ver(<sec-fet>).
]

El *transistor de efecto campo* (FET: puerta, fuente y drenador) controla la corriente con la _tensión_ de puerta, casi sin consumir corriente.

#circuito(caption: [FET de unión (JFET) de canal N. La corriente va de surtidor a drenador por un canal N. La puerta es tipo P y se polariza en inversa: cuanto más negativa, más se ensanchan sus zonas de deplexión y más se estrecha el canal. La puerta no toma corriente: solo crea un campo.])[
  #cetz.canvas({
    import cetz.draw: *
    rect((0, 0), (6, 1.6), fill: col.senal1.lighten(80%), stroke: 0.6pt)
    // puertas P
    rect((2, 1.6), (4, 2.2), fill: col.senal2.lighten(75%), stroke: 0.6pt)
    rect((2, -0.6), (4, 0), fill: col.senal2.lighten(75%), stroke: 0.6pt)
    // zonas de deplexión (blancas)
    bezier((1.9, 1.6), (4.1, 1.6), (2.4, 1.0), (3.6, 1.0), fill: white, stroke: (dash: "dotted", thickness: 0.5pt))
    bezier((1.9, 0), (4.1, 0), (2.4, 0.6), (3.6, 0.6), fill: white, stroke: (dash: "dotted", thickness: 0.5pt))
    content((3, 1.9), text(size: 8pt, weight: "bold")[P])
    content((3, -0.3), text(size: 8pt, weight: "bold")[P])
    content((1, 0.8), text(size: 8pt)[canal N])
    line((1.6, 0.8), (5.4, 0.8), stroke: 0.9pt + col.senal1, mark: (end: ">", fill: col.senal1, scale: 0.5))
    // terminales
    line((0, 0.8), (-0.6, 0.8), stroke: 0.7pt)
    content((-0.7, 0.8), anchor: "east", text(size: 8pt)[S (surtidor)])
    line((6, 0.8), (6.6, 0.8), stroke: 0.7pt)
    content((6.7, 0.8), anchor: "west", text(size: 8pt)[D (drenador)])
    line((3, 2.2), (3, 2.7), stroke: 0.7pt)
    content((3, 2.75), anchor: "south", text(size: 8pt)[G (puerta)])
    line((3, -0.6), (3, -1.0), stroke: 0.7pt)
    content((3, -1.05), anchor: "north", text(size: 8pt)[G (unida a la de arriba)])
  })
] <t2-fig-jfet>

#circuito(caption: [Símbolos de los FET de canal N. En el JFET la flecha de la puerta toca el canal (es una unión PN). En el MOSFET la puerta está aislada del canal por una capa de óxido, y se dibuja separada; es el símbolo que usa el examen.], sim: "nmosfet.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content
    _t2-jfet(1.5, 1)
    content((0.6, 0.6), anchor: "south", text(size: 8pt)[G])
    content((2.25, 1.9), anchor: "west", text(size: 8pt)[D])
    content((2.25, 0.1), anchor: "west", text(size: 8pt)[S])
    content((1.6, -0.6), text(size: 8pt, weight: "bold")[JFET])
    nmos("m", (6, 1))
    wire("m.g", (4.4, 0.47))
    wire("m.d", (6, 1.9))
    wire("m.s", (6, 0.1))
    content((4.4, 0.6), anchor: "south", text(size: 8pt)[G])
    content((6.15, 1.9), anchor: "west", text(size: 8pt)[D])
    content((6.15, 0.1), anchor: "west", text(size: 8pt)[S])
    content((5.6, -0.6), text(size: 8pt, weight: "bold")[MOSFET])
  })
] <t2-fig-fet-simbolos>

#analogia[
  El FET es una manguera de agua que pisas con el pie. No hace falta que el pie se lleve agua (la puerta no toma corriente): basta con apretar para estrechar el paso. Cuanto más aprietas (más tensión negativa en la puerta del JFET), menos caudal pasa del surtidor al drenador. #falstad("jfetamp.txt", texto: [Amplificador con JFET])
]

Los tres dispositivos amplificadores del temario hacen lo mismo con nombres distintos. El examen cambia los nombres de un dispositivo a otro (T2.23, T2.27, T2.34), así que conviene tener la correspondencia a mano:

#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr), align: left,
    [], [Bipolar (BJT)], [Efecto de campo (FET)], [Válvula],
    [Emite los portadores], [emisor], [surtidor (o fuente)], [cátodo],
    [Controla], [base], [puerta], [rejilla],
    [Recoge los portadores], [colector], [drenador], [placa (ánodo)],
    [Se gobierna con], [corriente de base], [tensión de puerta], [tensión de rejilla],
  ),
  caption: [Correspondencia de terminales entre transistor bipolar, FET y válvula.],
) <t2-tab-terminales>

=== Configuraciones y polarización

Según qué terminal sea común a entrada y salida hay tres configuraciones (emisor/fuente común la más usada), con distintas impedancias y ganancias. De las tres configuraciones del transistor, el *emisor común* da ganancia de tensión y de corriente (la etapa amplificadora por defecto, inversora), la *base común* se prefiere en RF por su estabilidad (impedancia de entrada baja, no inversora) y el *colector común* — el seguidor de emisor — no amplifica tensión pero aísla: entrada de alta impedancia, salida de baja, un adaptador de impedancias activo.

// FALSTAD-CUSTOM: base-comun
#circuito(caption: [Las tres configuraciones, vistas solo para la señal: el terminal común va a masa. La entrada se aplica a uno de los otros dos y la salida se toma del tercero. En el colector común, el colector va a la alimentación, que para la señal es masa: un condensador de desacoplo la une a masa.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    let t = 7.5pt
    for (i, (tit, ent, sal, com)) in (
      ([Emisor común], "b", "c", "e"),
      ([Base común], "e", "c", "b"),
      ([Colector común], "b", "e", "c"),
    ).enumerate() {
      let x = i * 4.4
      let cx = x + 1.2
      let q = "q" + str(i)
      npn(q, (cx, 1.5))
      // terminal común
      if com == "e" { wire(q + ".e", (cx, 0.4)); ground("g" + str(i), (cx, 0.4)) }
      if com == "b" { wire(q + ".b", (x + 0.2, 1.5)); wire((x + 0.2, 1.5), (x + 0.2, 0.4)); ground("g" + str(i), (x + 0.2, 0.4)) }
      if com == "c" { wire(q + ".c", (cx, 2.6)); node("v" + str(i), (cx, 2.6)); content((cx, 2.75), anchor: "south", text(size: t)[$+V_"CC"$ (masa para la señal)]) }
      // entrada
      if ent == "b" { wire(q + ".b", (x - 0.3, 1.5)); node("ie" + str(i), (x - 0.3, 1.5), fill: false); content((x - 0.3, 1.8), text(size: t)[entrada]) }
      if ent == "e" { wire(q + ".e", (cx, 0.7)); wire((cx, 0.7), (x + 2.5, 0.7)); node("ie" + str(i), (x + 2.5, 0.7), fill: false); content((x + 2.5, 0.4), text(size: t)[entrada]) }
      // salida
      if sal == "c" { wire(q + ".c", (cx, 2.4)); wire((cx, 2.4), (x + 2.5, 2.4)); node("is" + str(i), (x + 2.5, 2.4), fill: false); content((x + 2.5, 2.7), text(size: t)[salida]) }
      if sal == "e" { wire(q + ".e", (cx, 0.7)); wire((cx, 0.7), (x + 2.5, 0.7)); node("is" + str(i), (x + 2.5, 0.7), fill: false); content((x + 2.5, 0.4), text(size: t)[salida]) }
      content((cx, -0.5), text(size: 8pt, weight: "bold", tit))
    }
  })
] <t2-fig-configuraciones>

#porque[
  - *Emisor común*: la señal entra por la base y sale del colector. Una pequeña variación de corriente de base produce una variación $beta$ veces mayor de corriente de colector, que la resistencia de colector convierte en una gran variación de tensión: gana tensión y corriente, e invierte la fase. #falstad("ceamp.txt", texto: [Emisor común])
  - *Base común*: la base está quieta (a masa para la señal) y la señal mueve el emisor. La corriente que entra por el emisor sale casi entera por el colector (ganancia de corriente algo menor que 1), pero sobre una carga mucho mayor que la impedancia de entrada: gana tensión. La base a masa separa la entrada de la salida, y por eso es estable en RF.
  - *Colector común* (seguidor de emisor): el emisor sigue a la base, 0,6 V por debajo; la tensión de salida es casi igual a la de entrada, pero la corriente que puede dar es $beta$ veces mayor que la que toma. Por eso adapta una fuente de alta impedancia a una carga de baja. #falstad("follower.txt", texto: [Seguidor de emisor])
]

#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr), align: left,
    [], [Emisor común], [Base común], [Colector común (seguidor)],
    [Entrada / salida], [base / colector], [emisor / colector], [base / emisor],
    [Ganancia de tensión], [alta], [alta], [≈ 1 (algo menos)],
    [Ganancia de corriente], [alta ($beta$)], [≈ 1 (algo menos)], [alta ($beta + 1$)],
    [Impedancia de entrada], [media], [baja], [alta],
    [Impedancia de salida], [media-alta], [alta], [baja],
    [Fase de la salida], [invertida (180°)], [en fase], [en fase],
    [Uso típico], [amplificador general], [amplificador de RF], [adaptador de impedancias],
  ),
  caption: [Las tres configuraciones del transistor bipolar. Con un FET se habla de fuente (surtidor), puerta y drenador común, con un comportamiento parecido.],
) <t2-tab-configuraciones>

Para que el transistor amplifique sin distorsión hay que *polarizarlo* en un punto de trabajo estable: el método habitual es el _divisor de tensión_ en la base con una resistencia en el emisor, que fija la corriente de reposo y la mantiene frente a las variaciones de $beta$ y de temperatura.

#circuito(caption: [Amplificador de emisor común con polarización por divisor de tensión. Con estos valores, la base queda a 2,1 V, el emisor a 1,5 V, la corriente de reposo es de 1,5 mA y el colector descansa a unos 6 V, en mitad de la alimentación.], sim: "ceamp.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content
    let t = 8pt
    wire((2, 6), (6.6, 6))
    wire((2, 0), (6.6, 0))
    content((4.2, 6.15), anchor: "south", text(size: t, $+12 "V"$))
    ground("gnd", (4.2, 0))
    resistor("r1", (2, 6), (2, 3))
    content((1.55, 4.5), anchor: "east", align(right, text(size: t)[$R_1$\ 47 kΩ]))
    resistor("r2", (2, 3), (2, 0))
    content((1.55, 1.5), anchor: "east", align(right, text(size: t)[$R_2$\ 10 kΩ]))
    npn("q1", (4.2, 3))
    wire((2, 3), "q1.b")
    node("nb", (2, 3))
    resistor("rc", (4.2, 6), (4.2, 4.3))
    content((3.75, 5.15), anchor: "east", align(right, text(size: t)[$R_C$\ 3,9 kΩ]))
    wire((4.2, 4.3), "q1.c")
    resistor("re", (4.2, 2.0), (4.2, 0))
    content((3.75, 1.0), anchor: "east", align(right, text(size: t)[$R_E$\ 1 kΩ]))
    wire("q1.e", (4.2, 2.0))
    wire((4.2, 2.0), (6.6, 2.0))
    node("ne", (4.2, 2.0))
    capacitor("ce", (6.6, 2.0), (6.6, 0))
    content((7.15, 1.0), anchor: "west", text(size: t, $C_E$))
    capacitor("cin", (0, 3), (2, 3), n: "o-")
    content((1.0, 3.55), text(size: t, $C_"ent"$))
    wire((4.2, 4.3), (6.0, 4.3))
    node("nc", (4.2, 4.3))
    capacitor("cout", (6.0, 4.3), (7.8, 4.3), n: "-o")
    content((6.9, 4.85), text(size: t, $C_"sal"$))
    content((-0.2, 3), anchor: "east", text(size: t)[entrada])
    content((7.95, 4.3), anchor: "west", text(size: t)[salida])
  })
] <t2-fig-ec>

#porque[
  - *$R_1$ y $R_2$* forman un divisor: $V_B = 12 dot 10 slash 57 approx 2,1$ V. El transistor queda «a medio abrir», listo para que la señal lo abra y lo cierre un poco alrededor de ese punto.
  - *$R_E$* fija la corriente: el emisor queda 0,6 V por debajo de la base, a 1,5 V, y $I_E = 1,5 slash 1000 = 1,5$ mA. Si el calor o un $beta$ mayor intentan subir la corriente, sube la tensión del emisor, baja la tensión base-emisor y la corriente vuelve atrás: es la estabilización.
  - *$R_C$* convierte la corriente de colector en tensión: $1,5 "mA" dot 3,9 "kΩ" approx 5,9$ V, y el colector descansa a unos 6 V. Cuando la señal aumenta la corriente, el colector *baja*: por eso la salida va invertida.
  - *$C_"ent"$ y $C_"sal"$* dejan pasar la señal y bloquean la continua, para no estropear la polarización de esta etapa ni la de las vecinas.
  - *$C_E$* pone el emisor a masa para la señal, pero no para la continua. Sin él la ganancia sería solo $R_C slash R_E approx 3,9$; con él sube hasta unas 200 veces.
]

La polarización y el amplificador están contados paso a paso en #ver(<sec-polarizacion>), #ver(<sec-amplificador-ec>) y #ver(<sec-configuraciones>); las clases de amplificador (A, B, AB, C) se estudian en el tema T3.

=== Válvulas, circuitos integrados y circuitos digitales

Las *válvulas* sobreviven en las etapas de gran potencia, y los *circuitos integrados* empaquetan circuitos completos, analógicos o digitales, en un solo chip; según el número de puertas que reúnen se habla de *escalas de integración*: SSI, MSI, LSI y VLSI (de _small_ a _very large scale integration_).

#figure(
  table(
    columns: (auto, 1fr, auto), align: left,
    [Sigla], [Nombre], [Puertas (orden de magnitud)],
    [SSI], [_Small Scale Integration_ (pequeña escala)], [hasta unas 10],
    [MSI], [_Medium Scale Integration_ (media escala)], [de 10 a 100],
    [LSI], [_Large Scale Integration_ (gran escala)], [de 100 a 10 000],
    [VLSI], [_Very Large Scale Integration_ (muy gran escala)], [más de 10 000],
  ),
  caption: [Escalas de integración. Cualquier otra sigla, como «CSI», no es una escala normalizada (T2.58).],
) <t2-tab-escalas>

Los *circuitos digitales* merecen su propia mención. Manejan la información con solo dos niveles lógicos — el 0 y el 1, dos rangos de tensión bien separados — y la procesan combinando *puertas* básicas (Y, O, inversor) por millares. Trabajar con dos niveles da una gran *inmunidad al ruido*: una perturbación pequeña no convierte un 0 en un 1, mientras que en un circuito analógico cualquier ruido que se suma a la señal ya se queda en ella. De ahí su dominio en el procesado digital de señales (DSP, tema T1) y en los sintetizadores de frecuencia (tema T3).

#circuito(caption: [Inmunidad al ruido. Arriba, una señal analógica con ruido: el ruido ya forma parte de la señal. Abajo, una señal digital con el mismo ruido: basta comparar con un umbral para recuperar los 0 y los 1 limpios.])[
  #cetz.canvas({
    import cetz.draw: *
    let ruido(x) = 0.11 * calc.sin(23 * x) + 0.08 * calc.sin(37 * x + 1) + 0.06 * calc.sin(53 * x + 2)
    // analógica
    ejes(0, 6.4, -1.1, 1.3, etq-x: $t$, etq-y: none)
    onda(x => calc.sin(1.3 * x) + ruido(x), 0, 6.1, n: 400, stroke: 1pt + col.senal1)
    content((6.6, 0.3), anchor: "west", text(size: 7.5pt)[analógica:\ el ruido se queda])
    // digital
    let dig(x) = if calc.rem(calc.floor(x / 1.0), 2) == 0 { 0.9 } else { 0.1 }
    let y0 = -3.4
    line((0, y0), (6.4, y0), stroke: 0.6pt, mark: (end: ">", fill: black))
    onda(x => y0 + dig(x) * 1.6 + ruido(x) * 1.2, 0, 6.1, n: 400, stroke: 1pt + col.senal2)
    line((0, y0 + 0.8), (6.2, y0 + 0.8), stroke: (dash: "dashed", thickness: 0.5pt, paint: col.gris))
    content((6.25, y0 + 0.8), anchor: "west", text(size: 7pt, fill: col.gris)[umbral])
    // salida regenerada
    let y1 = -5.6
    line((0, y1), (6.4, y1), stroke: 0.6pt, mark: (end: ">", fill: black))
    let pts = ()
    for k in range(7) {
      let v = if calc.rem(k, 2) == 0 { 1.2 } else { 0.15 }
      pts.push((k * 1.0, y1 + v))
      pts.push((calc.min(6.1, (k + 1) * 1.0), y1 + v))
    }
    line(..pts, stroke: 1.2pt + col.senal3)
    content((6.6, y0 + 1.75), anchor: "west", text(size: 7.5pt)[digital\ con ruido])
    content((6.6, y1 + 0.7), anchor: "west", text(size: 7.5pt)[tras el umbral:\ 1 0 1 0 1 0 limpios])
  })
] <t2-fig-ruido-digital>

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: center,
    [$A$], [$B$], [Y ($A$ y $B$)], [O ($A$ o $B$)], [Inversor ($"no" A$)],
    [0], [0], [0], [0], [1],
    [0], [1], [0], [1], [1],
    [1], [0], [0], [1], [0],
    [1], [1], [1], [1], [0],
  ),
  caption: [Tablas de verdad de las puertas básicas. La Y da 1 solo si las dos entradas valen 1; la O, si vale 1 cualquiera de ellas; el inversor da lo contrario de su entrada.],
) <t2-tab-puertas>

#q("T2.21", "d",
  [Se conoce con el nombre genérico de «diodo» a un dispositivo que:],
  ([amplifica la corriente eléctrica], [almacena carga eléctrica], [transforma tensiones alternas], [permite el paso de la corriente eléctrica en un único sentido]),
  sol: [El diodo conduce en un único sentido (de ánodo a cátodo en polarización directa); es la base de la rectificación y la detección.],
)

#q("T2.22", "b",
  [El diodo zéner se utiliza principalmente para:],
  ([amplificar señales débiles], [estabilizar una tensión], [emitir luz], [sintonizar un circuito resonante]),
  sol: [En inversa, el zéner fija una tensión prácticamente constante: referencia y estabilización en fuentes de alimentación.],
)

#q("T2.23", "c",
  [Los tres terminales de un transistor bipolar son:],
  ([puerta, fuente y drenador], [ánodo, cátodo y rejilla], [emisor, base y colector], [primario, secundario y núcleo]),
  sol: [El BJT tiene emisor, base y colector; puerta, fuente y drenador son del FET.],
)

#q("T2.24", "a",
  [Un transistor bipolar puede ser de tipo:],
  ([NPN], [PPN], [NNP], [PNN]),
  sol: [Los transistores bipolares son NPN o PNP, según el orden de las capas de semiconductor.],
)

#q("T2.25", "a",
  [Un diodo varicap es un diodo que:],
  ([varía su capacidad con la tensión inversa aplicada], [varía su resistencia con la luz que recibe], [ajusta su inductancia mediante un núcleo móvil], [se comporta como un condensador electrolítico]),
  sol: [El varicap se comporta como un condensador cuya capacidad se controla con la tensión inversa: sintonía electrónica en VCO y receptores.],
)

#q("T2.26", "c",
  [De las siguientes parejas unidad de medida/magnitud, señale la _incorrecta_:],
  ([voltio: diferencia de potencial], [amperio: corriente eléctrica], [faradio: cantidad de carga], [hercio: frecuencia]),
  sol: [El faradio mide la capacidad; la cantidad de carga se mide en culombios. Las otras tres parejas son correctas.],
)

== Válvulas termoiónicas <t2-sec-valvulas>

#motivacion[
  Antes del transistor, la única forma de amplificar era gobernar un chorro de electrones en el vacío. Hoy las válvulas siguen en los amplificadores lineales de HF de un kilovatio porque aguantan tensiones de miles de voltios, soportan sobrecargas breves y una ROE (relación de ondas estacionarias) alta que destruirían un transistor, y su alta impedancia de placa se adapta con facilidad a la antena mediante una red en pi. Cada electrodo que se fue añadiendo a la válvula resolvió un problema concreto del anterior.
]

Aunque el transistor las jubiló en casi todo, las válvulas siguen en los amplificadores de potencia de HF — y siguen cayendo en el examen. La idea es más simple de lo que su fama sugiere: son _válvulas de electrones_ en el vacío.

Caliente un metal y los electrones empiezan a escaparse de su superficie, como las moléculas de agua de un cazo al fuego: es la *emisión termoiónica*. Ese metal caliente es el *cátodo*. Ponga enfrente, dentro de la misma ampolla al vacío, una placa metálica y dele tensión _positiva_: los electrones —que son negativos— cruzan el vacío atraídos por ella y hay corriente. Invierta la polaridad y no pasa nada, porque la *placa* (o ánodo) está fría y no emite. Esa asimetría es todo lo que hace falta para rectificar: la válvula diodo.

Lo interesante llega al intercalar una rejilla metálica entre cátodo y placa, muy cerca del cátodo. Con una tensión ligeramente _negativa_ en esa *rejilla* se repelen los electrones que salen y se estrangula el chorro, sin que la rejilla llegue a recoger corriente apreciable. Una variación diminuta de tensión en la rejilla gobierna así una corriente grande en la placa: eso es amplificar, y ese es el *tríodo* (@t2-fig-triodo-pentodo).

El tríodo tiene un defecto: la capacidad entre rejilla y placa realimenta la señal hacia la entrada y, en radiofrecuencia, el amplificador se pone a oscilar. La cura es una segunda rejilla, la de *pantalla*, a tensión positiva fija, que hace de blindaje electrostático entre las otras dos — tenemos el tetrodo. Pero los electrones llegan a la placa con tanta energía que arrancan de ella electrones secundarios, y la pantalla se los queda; para devolverlos se añade una tercera rejilla, la *supresora*, al potencial del cátodo. Cinco electrodos en total: cátodo, tres rejillas y placa. Ese es el *pentodo*.

#circuito(caption: [Tríodo y pentodo. El cátodo caliente emite electrones, la placa positiva los atrae y las rejillas regulan el paso. En el pentodo, la pantalla apantalla la capacidad rejilla-placa y la supresora devuelve a la placa los electrones secundarios.])[
  #cetz.canvas({
    import cetz.draw: *
    let t = 7.5pt
    // tríodo
    _t2-valvula("a", (0, 0), rejillas: ((0, "izq", black),))
    line((0, 1.3), (0, 1.55), stroke: 0.6pt + col.naranja)
    content((0, 1.6), anchor: "south", text(size: t, fill: col.naranja)[placa (ánodo)])
    line((-0.97, 0), (-1.6, 0), stroke: 0.6pt + col.senal1)
    content((-1.65, 0), anchor: "east", text(size: t, fill: col.senal1)[rejilla])
    content((-0.22, -1.6), anchor: "north", text(size: t, fill: col.verde)[cátodo])
    content((0, -2.15), anchor: "north", text(size: 8pt, weight: "bold")[tríodo])
    // pentodo
    let x = 5
    _t2-valvula("b", (x, 0), rejillas: ((-0.12, "izq", col.senal1), (0.05, "der", col.naranja), (0.22, "izq", black)))
    line((x, 1.3), (x, 1.55), stroke: 0.6pt + col.naranja)
    content((x, 1.6), anchor: "south", text(size: t, fill: col.naranja)[placa])
    line((x - 0.97, 0.21), (x - 1.5, 0.75), stroke: 0.5pt + col.naranja)
    content((x - 1.55, 0.8), anchor: "east", text(size: t, fill: col.naranja)[supresora])
    line((x + 0.97, 0.05), (x + 1.5, 0.05), stroke: 0.5pt + col.naranja)
    content((x + 1.55, 0.05), anchor: "west", text(size: t, fill: col.naranja)[pantalla])
    line((x - 0.97, -0.11), (x - 1.5, -0.55), stroke: 0.5pt + col.senal1)
    content((x - 1.55, -0.6), anchor: "east", text(size: t, fill: col.senal1)[rejilla de control])
    content((x - 0.22, -1.6), anchor: "north", text(size: t, fill: col.verde)[cátodo])
    content((x, -2.15), anchor: "north", text(size: 8pt, weight: "bold")[pentodo])
  })
] <t2-fig-triodo-pentodo>

#ojo(titulo: [Seguridad])[
  Las tensiones de placa son de cientos o miles de voltios y los condensadores del filtro las retienen mucho después de apagar el equipo. Un amplificador valvular no se abre sin descargarlos: es el riesgo eléctrico del tema T10 en su versión más seria.
]

=== Cada rejilla nueva arregla un problema

#circuito(caption: [La familia de las válvulas, de izquierda a derecha: diodo, tríodo, tetrodo y pentodo. Cada una añade un electrodo para corregir el defecto de la anterior.])[
  #cetz.canvas({
    import cetz.draw: *
    let et(x, t) = content((x, -1.75), anchor: "north", text(size: 8pt, weight: "bold", t))
    _t2-valvula("d", (0, 0), escala: 0.8)
    et(0, [diodo])
    _t2-valvula("t", (2.8, 0), escala: 0.8, rejillas: ((-0.05, "izq", col.senal1),))
    et(2.8, [tríodo])
    _t2-valvula("q", (5.6, 0), escala: 0.8, rejillas: ((-0.12, "izq", col.senal1), (0.14, "der", col.naranja)))
    et(5.6, [tetrodo])
    _t2-valvula("p", (8.4, 0), escala: 0.8, rejillas: ((-0.12, "izq", col.senal1), (0.05, "der", col.naranja), (0.22, "izq", black)))
    et(8.4, [pentodo])
  })
] <t2-fig-familia-valvulas>

#figure(
  table(
    columns: (auto, 0.9fr, 1.2fr, 1.2fr), align: left,
    [Válvula], [Electrodos], [Qué consigue], [Problema que deja],
    [Diodo], [cátodo y placa], [Rectifica: solo pasa corriente con la placa positiva], [No amplifica],
    [Tríodo], [\+ rejilla de control], [Amplifica: la tensión de rejilla gobierna la corriente de placa], [La capacidad rejilla-placa realimenta la salida y hace oscilar en RF],
    [Tetrodo], [\+ rejilla de pantalla], [La pantalla, a tensión positiva fija, blinda la rejilla de la placa], [Los electrones secundarios que salen de la placa se van a la pantalla],
    [Pentodo], [\+ rejilla supresora], [La supresora, al potencial del cátodo, devuelve los secundarios a la placa], [—],
  ),
  caption: [Por qué se añadió cada rejilla. El nombre cuenta electrodos: tri-, tetra-, penta-.],
) <t2-tab-valvulas>

#nota[
  Muchos amplificadores de HF usan el *tetrodo de haz* (por ejemplo, la 6146 de los transceptores valvulares). En lugar de una rejilla supresora tiene unas placas que concentran los electrones en haces: la nube de carga que se forma ante la placa repele a los secundarios y hace el trabajo de la supresora.
]

#circuito(caption: [Amplificador de tensión con tríodo y polarización de cátodo. La rejilla está a 0 V en continua y el cátodo unos voltios por encima: para la válvula, la rejilla es negativa.], sim: "triodeamp.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    let t = 8pt
    _t2-valvula("v", (3.2, 2.8), rejillas: ((0, "izq", black),))
    // placa
    resistor("ra", (3.2, 6.2), (3.2, 4.5))
    node("ht", (3.2, 6.2))
    content((3.2, 6.35), anchor: "south", text(size: t)[+250 V])
    content((2.75, 5.35), anchor: "east", align(right, text(size: t)[$R_a$\ 100 kΩ]))
    wire((3.2, 4.5), (3.2, 4.1))
    node("np", (3.2, 4.5))
    // salida
    wire((3.2, 4.5), (4.4, 4.5))
    capacitor("cs", (4.4, 4.5), (6.0, 4.5), n: "-o")
    content((5.2, 5.05), text(size: t, $C_"sal"$))
    content((6.0, 4.75), anchor: "south", text(size: t)[salida])
    // rejilla
    wire((2.23, 2.8), (1.4, 2.8))
    node("ng", (1.4, 2.8))
    resistor("rg", (1.4, 2.8), (1.4, -0.6))
    content((0.95, 1.1), anchor: "east", align(right, text(size: t)[$R_g$\ 1 MΩ]))
    capacitor("ce", (-0.4, 2.8), (1.4, 2.8), n: "o-")
    content((0.5, 3.35), text(size: t, $C_"ent"$))
    content((-0.4, 3.05), anchor: "south", text(size: t)[entrada])
    // cátodo
    wire((2.98, 1.5), (2.98, 1.2), (3.8, 1.2))
    resistor("rk", (3.8, 1.2), (3.8, -0.6))
    content((4.25, 0.3), anchor: "west", text(size: t, $R_k$))
    wire((3.8, 1.2), (5.2, 1.2))
    node("nk", (3.8, 1.2))
    capacitor("ck", (5.2, 1.2), (5.2, -0.6))
    content((5.8, 0.3), anchor: "west", text(size: t, $C_k$))
    wire((1.4, -0.6), (5.2, -0.6))
    ground("g", (3.2, -0.6))
  })
] <t2-fig-amp-triodo>

#porque[
  - *El cátodo* se calienta (el filamento no se dibuja) y emite electrones; la placa, a +250 V a través de $R_a$, los atrae.
  - *$R_k$*: la corriente de placa pasa por ella y eleva el cátodo unos voltios sobre masa. Como la rejilla está a 0 V a través de $R_g$, queda *negativa respecto del cátodo*: es la tensión ligeramente negativa que estrangula el chorro sin que la rejilla recoja electrones.
  - *La señal* se suma a esa tensión de rejilla. Cuando la rejilla se hace un poco menos negativa, pasa más corriente, cae más tensión en $R_a$ y la placa *baja*: salida amplificada e invertida, igual que en el emisor común.
  - *$C_k$* pone el cátodo a masa para la señal (sin él, la ganancia bajaría), y *$C_"ent"$* y *$C_"sal"$* separan la continua de las etapas vecinas, igual que en el transistor.
]

#figure(
  table(
    columns: (auto, 1fr, 1fr), align: left,
    [], [Válvula], [Transistor],
    [Tamaño], [grande], [diminuto],
    [Alimentación], [filamento de caldeo y alta tensión], [baja tensión, sin caldeo],
    [Arranque], [necesita un tiempo de caldeo], [inmediato],
    [Calor], [trabaja al rojo sin problema], [sensible al calor: necesita radiador],
    [Sobrecargas], [las aguanta bien], [se destruye con facilidad],
  ),
  caption: [Válvula frente a transistor.],
) <t2-tab-valvula-transistor>

#ojo[
  - El prefijo cuenta *electrodos*, no patillas: el pentodo tiene cinco (T2.30).
  - La rejilla de *pantalla* reduce la capacidad rejilla-placa (T2.31); la *supresora* recoge los electrones secundarios.
  - Una válvula necesita su tiempo de caldeo antes de aplicar la alta tensión (T2.44).
]

#q("T2.27", "b",
  [Los tres electrodos básicos de una válvula tríodo son:],
  ([emisor, base y colector], [cátodo, rejilla y placa], [puerta, drenador y surtidor], [ánodo, dieléctrico y cátodo]),
  sol: [El cátodo emite los electrones, la placa (o ánodo) los recoge y la rejilla intercalada entre ambos regula el paso. Emisor, base y colector son del transistor bipolar; puerta, drenador y surtidor, del FET.],
)

#q("T2.28", "a",
  [Una válvula conduce corriente:],
  ([si se aplica una tensión positiva a la placa y negativa al cátodo], [si se aplica una tensión negativa a la placa y positiva al cátodo], [con cualquier polaridad, siempre que el filamento esté frío], [únicamente con corriente alterna aplicada a la rejilla]),
  sol: [Los electrones que el cátodo caliente emite son negativos, así que solo cruzan el vacío si la placa está a potencial positivo respecto a él. Con la polaridad invertida no hay corriente, porque la placa está fría y no emite: en eso consiste el efecto rectificador de la válvula.],
)

#q("T2.29", "c",
  [En una válvula termoiónica, el cátodo tiene la función de:],
  ([recoger los electrones emitidos], [regular el paso de los electrones], [emitir electrones al calentarse], [mantener el vacío dentro de la ampolla]),
  sol: [Es la emisión termoiónica: al calentarse, el metal del cátodo deja escapar electrones de su superficie. Recogerlos es tarea de la placa y regularlos, de la rejilla.],
)

#q("T2.30", "d",
  [Una válvula pentodo recibe ese nombre porque dispone de:],
  ([cinco placas conectadas en paralelo], [cinco filamentos de caldeo independientes], [cinco terminales de conexión al zócalo], [cinco electrodos: cátodo, tres rejillas y placa]),
  sol: [El prefijo cuenta electrodos, no terminales: cátodo, rejilla de control, rejilla de pantalla, rejilla supresora y placa. Con la misma lógica, el tríodo tiene tres y el tetrodo cuatro.],
)

#q("T2.31", "b",
  [En una válvula, la rejilla de pantalla se añade principalmente para:],
  ([aumentar la temperatura del cátodo], [reducir la capacidad entre la rejilla de control y la placa], [rectificar la corriente de placa], [sustituir al filamento de caldeo]),
  sol: [Esa capacidad realimenta señal de la placa a la rejilla y hace oscilar al amplificador en radiofrecuencia. La pantalla, a tensión positiva fija, se interpone como blindaje electrostático y corta la realimentación.],
)

=== Preguntas de repaso de todo el tema

Las preguntas que siguen mezclan todas las secciones del tema. Si fallas una, vuelve a la sección de su componente: resistencias, condensadores, bobinas, transformadores, semiconductores o válvulas.

#q("T2.32", "a",
  [La ganancia de corriente $beta$ de un transistor bipolar es la relación entre:],
  ([la corriente de colector y la corriente de base], [la corriente de emisor y la corriente de colector], [la corriente de drenador y la corriente de surtidor], [la tensión de colector y la tensión de base]),
  sol: [$beta = I_C slash I_B$: cuántas veces mayor es la corriente que gobierna respecto a la que la gobierna. Un $beta$ de 100 significa que 1 mA de base maneja 100 mA de colector. Drenador y surtidor son terminales del FET.],
)

#q("T2.33", "d",
  [Un diodo LED emite luz cuando:],
  ([se polariza inversamente], [se le aplica corriente alterna de alta frecuencia], [alcanza su tensión de avalancha], [se polariza directamente]),
  sol: [El LED es un diodo y, como tal, solo conduce en directa; es al circular esa corriente cuando emite. El que trabaja polarizado en inversa, en su tensión de avalancha, es el zéner.],
)

#q("T2.34", "c",
  [Los tres terminales de un transistor de efecto de campo (FET) se denominan:],
  ([emisor, base y colector], [cátodo, rejilla y ánodo], [puerta, drenador y surtidor], [primario, secundario y masa]),
  sol: [En el FET la tensión de puerta controla, mediante un campo eléctrico y sin apenas consumir corriente, el paso entre surtidor y drenador. Emisor, base y colector son del bipolar; cátodo, rejilla y ánodo, de la válvula.],
)

#q("T2.35", "b",
  [Un semiconductor de tipo P es aquel en el que:],
  ([la cantidad de electrones libres es mayor que la de huecos], [la cantidad de huecos es mayor que la de electrones libres], [no existen portadores de carga], [la conducción se debe únicamente a los iones]),
  sol: [Se obtiene dopando el silicio con un elemento de menos electrones de valencia, lo que deja huecos libres. En el tipo N ocurre lo contrario: sobran electrones. La unión de ambos es el diodo.],
)

#q("T2.36", "d",
  [En un semiconductor se denomina «hueco» a:],
  ([una impureza del cristal], [una zona sin dopar], [un defecto de fabricación], [un portador de carga positiva]),
  sol: [Es la ausencia de un electrón en un enlace, que se comporta a todos los efectos como una carga positiva móvil: los electrones vecinos van saltando a él y el hueco «viaja» en sentido contrario.],
)

#q("T2.37", "a",
  [De los siguientes materiales, es un semiconductor:],
  ([el germanio], [el cobre], [la porcelana], [el aluminio]),
  sol: [Germanio y silicio son los semiconductores clásicos: no conducen como un metal ni aíslan como la porcelana, y su conductividad se gobierna con impurezas. Cobre y aluminio son conductores.],
)

#q("T2.38", "c",
  [Una resistencia cuyo valor óhmico depende de la tensión aplicada entre sus extremos se denomina:],
  ([termistor], [potenciómetro], [varistor], [reóstato]),
  sol: [El varistor (o VDR) baja bruscamente su resistencia al superarse cierta tensión, y por eso se usa como protector contra sobretensiones. El termistor depende de la temperatura, y el potenciómetro se ajusta a mano.],
)

#q("T2.39", "b",
  [Un autotransformador es un transformador en el que:],
  ([el núcleo es de aire], [los devanados primario y secundario tienen una parte común], [la relación de transformación es siempre la unidad], [el secundario está cortocircuitado]),
  sol: [En vez de dos devanados aislados hay uno solo con una toma intermedia, de modo que parte del bobinado pertenece al primario y al secundario a la vez. Es más ligero y barato, pero no aísla galvánicamente la entrada de la salida.],
)

#q("T2.40", "d",
  [Al introducir un núcleo de material ferromagnético en el interior de una bobina, su autoinducción:],
  ([se anula], [disminuye], [no varía], [aumenta]),
  sol: [El núcleo ferromagnético concentra las líneas de campo y multiplica el flujo para la misma corriente, de modo que la autoinducción crece con la permeabilidad del material. Es lo que permite hacer bobinas de gran valor sin un número enorme de espiras.],
)

#q("T2.41", "a",
  [Un condensador intercalado en un circuito de corriente alterna tiende a:],
  ([oponerse a las variaciones de tensión entre sus armaduras], [oponerse a las variaciones de la corriente], [rectificar la corriente], [elevar la frecuencia de la señal]),
  sol: [Su tensión no puede cambiar bruscamente, porque hacerlo exigiría una corriente infinita ($i = C dif v slash dif t$). Es el dual de la bobina, que se opone a las variaciones de corriente. De ahí que el condensador alise la tensión en las fuentes de alimentación.],
)

#q("T2.42", "c",
  [Un inconveniente característico de los transistores frente a las válvulas es:],
  ([su mayor tamaño], [su elevado consumo en reposo], [su sensibilidad al calor], [la necesidad de un filamento de caldeo]),
  sol: [Las características del semiconductor derivan con la temperatura y, si el calor no se evacúa, la corriente y la temperatura se realimentan hasta destruir el componente. De ahí los radiadores y ventiladores de las etapas de potencia. Las válvulas, en cambio, trabajan al rojo sin inmutarse.],
)

#q("T2.43", "b",
  [Una resistencia con las bandas violeta, verde, rojo y oro tiene un valor de:],
  ([75 Ω con tolerancia del 10 %], [7500 Ω con tolerancia del 5 %], [570 Ω con tolerancia del 1 %], [75 kΩ con tolerancia del 5 %]),
  sol: [Violeta = 7, verde = 5, rojo = $times 10^2$ y oro = ±5 %: $75 times 100 = 7500$ Ω, es decir, 7,5 kΩ. El oro es la tolerancia y no interviene en el valor.],
)

#q("T2.44", "a",
  [Cuando la etapa final de un emisor es de válvulas, antes de poder transmitir es necesario:],
  ([esperar un tiempo de caldeo del filamento], [desconectar la toma de tierra], [cortocircuitar la rejilla de control], [enfriar previamente el equipo]),
  sol: [El cátodo tiene que alcanzar su temperatura de emisión antes de que la válvula conduzca. Aplicar tensión de placa con el filamento frío daña el tubo, y por eso los equipos valvulares llevan una posición de espera.],
)

#q("T2.45", "c",
  [En un condensador electrolítico, el dieléctrico está constituido por:],
  ([una lámina de mica], [aire a presión], [una finísima capa de óxido formada sobre la armadura metálica que hace de ánodo], [una película de plata]),
  sol: [No hay lámina aislante: el dieléctrico es una capa de óxido de espesor casi nulo formada eléctricamente sobre el ánodo, en contacto con el electrolito. Como $C = epsilon S slash d$ y $d$ es minúsculo, la capacidad resulta enorme — a cambio de la polaridad obligada.],
)

#q("T2.46", "d",
  [En el código de colores de un componente, una tolerancia del 5 % se representa con una franja de color:],
  ([plata], [rojo], [marrón], [oro]),
  sol: [Oro es ±5 % y plata ±10 %. Cuando la banda es marrón, la tolerancia es del 1 %, propia de componentes de precisión.],
)

#q("T2.47", "b",
  [La capacidad resultante de dos condensadores conectados en serie es:],
  ([la suma de ambas capacidades], [menor que la de cualquiera de ellos], [igual a la del mayor], [el doble de la del menor]),
  sol: [En serie los condensadores se combinan como las resistencias en paralelo: $1 slash C = 1 slash C_1 + 1 slash C_2$. El resultado es siempre menor que el menor de ellos, justo al revés de lo que ocurre en paralelo.],
)

#q("T2.48", "c",
  [En un transistor NPN empleado como amplificador, la polarización del colector respecto del emisor es:],
  ([negativa], [nula], [positiva], [alterna]),
  sol: [En un NPN la corriente convencional entra por el colector, que ha de estar a mayor potencial que el emisor. En el PNP todo se invierte, y de ahí que los circuitos con PNP lleven la alimentación negativa.],
)

#q("T2.49", "a",
  [En un transistor PNP empleado como amplificador, la tensión del colector respecto de la base es:],
  ([negativa], [positiva], [nula], [igual a la del emisor]),
  sol: [En el PNP el colector trabaja a potencial negativo respecto de la base y del emisor: es la imagen especular del NPN. Confundir ambos es garantía de destruir el transistor al alimentarlo.],
)

#q("T2.50", "b",
  [Reducir el espesor del dieléctrico de un condensador, manteniendo el resto de sus dimensiones, produce:],
  ([una disminución de su capacidad], [un aumento de su capacidad], [la anulación de su capacidad], [un aumento de su tensión máxima de trabajo]),
  sol: [De $C = epsilon S slash d$: la capacidad es inversamente proporcional a la separación entre armaduras. El precio es la tensión de trabajo, que baja al acercarlas — el dieléctrico acaba perforándose.],
)

#q("T2.51", "b",
  [Un amplificador puede llegar a oscilar de forma indeseada si:],
  ([su ganancia es demasiado baja], [existe un acoplamiento excesivo entre su salida y su entrada], [la señal de entrada es muy débil], [se alimenta con corriente continua]),
  sol: [Si parte de la salida vuelve a la entrada en fase, el amplificador se autoalimenta y arranca a oscilar: es realimentación positiva involuntaria. Contra eso están el apantallamiento, el buen desacoplo y, en los finales valvulares, la neutralización.],
)

#q("T2.52", "b",
  [Un electroimán atrae a los objetos de hierro:],
  ([de forma permanente], [solo mientras circula corriente por su bobina], [únicamente si se alimenta con corriente alterna], [solo cuando está frío]),
  sol: [Un electroimán es magnético solo mientras se le hace circular corriente: al cortarla, el campo desaparece (salvo un pequeño magnetismo remanente). Esa es precisamente su ventaja sobre el imán permanente — se gobierna.],
)

#q("T2.53", "a",
  [Una propiedad característica de la inductancia de un circuito es:],
  ([oponerse a las variaciones de la corriente], [oponerse a las variaciones de la tensión], [almacenar carga eléctrica], [rectificar la corriente alterna]),
  sol: [La bobina se opone a que la corriente cambie, porque toda variación induce en ella una fuerza contraelectromotriz que la frena. Es el dual exacto del condensador, que se opone a las variaciones de tensión.],
)

#q("T2.54", "c",
  [Los condensadores electrolíticos se emplean principalmente:],
  ([en los circuitos resonantes de radiofrecuencia], [en las antenas], [en el filtrado de las fuentes de alimentación], [como elemento de acoplo entre etapas de RF]),
  sol: [Su gran capacidad los hace idóneos para alisar el rizado tras el rectificador, donde además la polaridad es fija y conocida. En radiofrecuencia no sirven: su comportamiento a alta frecuencia es pésimo.],
)

#q("T2.55", "b",
  [Un transformador con núcleo de aire, comparado con uno de núcleo ferromagnético, presenta:],
  ([mayor inductancia], [un factor de calidad más bajo a baja frecuencia], [mayores pérdidas por corrientes de Foucault], [una relación de transformación variable]),
  sol: [Sin núcleo ferromagnético la inductancia es mucho menor y, a frecuencias bajas, el factor de calidad resulta pobre. A cambio, no hay pérdidas en el núcleo ni saturación, y por eso muchas bobinas de radiofrecuencia se hacen con núcleo de aire — o de ferrita, que sí es un núcleo magnético, pero diseñado para perder poco en RF.],
)

#q("T2.56", "c",
  [Una resistencia fija queda determinada por:],
  ([su valor óhmico únicamente], [su valor óhmico y su color], [su valor óhmico, la potencia que puede disipar y su tolerancia], [su valor óhmico y la frecuencia de trabajo]),
  sol: [Con el valor no basta: hay que saber cuánta potencia puede disipar sin quemarse y con qué precisión se cumple el valor nominal. El valor y la tolerancia figuran en el código de colores; la potencia se reconoce por el tamaño del cuerpo.],
)

#q("T2.57", "b",
  [Un megaohmio equivale a:],
  ([mil ohmios], [un millón de ohmios], [un millón de microohmios], [una milésima de ohmio]),
  sol: [Mega significa un millón: 1 MΩ = $10^6$ Ω. Mil ohmios son un kiloohmio, y la milésima de ohmio, un miliohmio.],
)

#q("T2.58", "d",
  [De las siguientes siglas referidas a la escala de integración de los circuitos integrados, _no_ corresponde a ninguna escala normalizada:],
  ([SSI], [MSI], [LSI], [CSI]),
  sol: [Las escalas normalizadas son SSI (pequeña), MSI (media), LSI (grande) y VLSI (muy grande), según el número de puertas integradas en la pastilla. CSI no designa ninguna escala de integración.],
)

#q("T2.59", "c",
  [Para descargar con seguridad un condensador se debe:],
  ([golpearlo suavemente], [esperar a que se descargue solo], [conectar sus dos armaduras a través de un elemento exterior], [invertir su polaridad]),
  sol: [Se cortocircuitan las armaduras a través de una resistencia adecuada, con un útil aislado y nunca con la mano. La descarga directa con un destornillador es brusca y puede dañar el condensador — y a quien lo sostiene.],
)

#q("T2.60", "a",
  [Además de elevar o reducir tensiones, los transformadores se emplean para:],
  ([la adaptación de impedancias entre dos circuitos], [la rectificación de la corriente alterna], [la generación de armónicos], [el almacenamiento de energía en continua]),
  sol: [Como la relación de tensiones va con el número de espiras y la de corrientes al revés, la impedancia vista desde el primario queda multiplicada por el cuadrado de la relación de transformación. Es lo que permite acoplar una etapa de salida a una carga de impedancia distinta.],
)

== Preguntas sobre símbolos <t2-sec-simbolos>

#motivacion[
  Un esquema es el idioma en el que se cuenta un circuito: cada componente tiene su dibujo, y el examen pregunta por ellos directamente. Casi todos los símbolos *dicen* lo que es la pieza: dos placas separadas para el condensador, unas espiras para la bobina, una flecha contra una barra para el diodo. La lectura de esquemas está explicada en #ver(<sec-esquemas>).
]

#let _t2-celda(simbolo, nombre) = box(width: 100%, align(center, stack(dir: ttb, spacing: 4pt, box(height: 1.55cm, align(center + horizon, simbolo)), text(size: 7.5pt, nombre))))

#circuito(caption: [Galería de símbolos de este tema (norma europea, con las variantes que aparecen en el examen).])[
  #grid(
    columns: (1fr,) * 5,
    row-gutter: 0.35cm,
    column-gutter: 0.2cm,
    _t2-celda(esquema({ import zap: *; resistor("r", (0, 0), (1.6, 0)) }), [resistencia]),
    _t2-celda(esquema({ import zap: *; resistor("r", (0, 0), (1.6, 0), variant: "ieee") }), [resistencia (americana)]),
    _t2-celda(esquema({ import zap: *; potentiometer("p", (0, 0), (1.6, 0)) }), [potenciómetro]),
    _t2-celda(esquema({ import zap: *; capacitor("c", (0, 0), (1.6, 0)) }), [condensador]),
    _t2-celda(esquema({ import zap: *; import cetz.draw: content; pcapacitor("c", (0, 0), (1.6, 0)); content((1.12, 0.5), text(size: 6pt)[+]) }), [electrolítico]),
    _t2-celda(esquema({ import zap: *; capacitor("c", (0, 0), (1.6, 0), variable: true) }), [condensador variable]),
    _t2-celda(esquema({ _t2-espiras(0, 1.6) }), [bobina (espiras)]),
    _t2-celda(esquema({ import zap: *; inductor("l", (0, 0), (1.6, 0)) }), [bobina]),
    _t2-celda(esquema({ import zap: *; inductor("l", (0, 0), (1.6, 0), variant: "iec") }), [bobina (rectángulo)]),
    _t2-celda(esquema({ trafo("t", (0, 0), espiras: (3, 3)) }), [transformador]),
    _t2-celda(esquema({ import zap: *; diode("d", (0, 0), (1.6, 0)) }), [diodo]),
    _t2-celda(esquema({ import zap: *; zener("d", (0, 0), (1.6, 0)) }), [zéner]),
    _t2-celda(esquema({ import zap: *; led("d", (0, 0), (1.6, 0)) }), [LED]),
    _t2-celda(esquema({ _t2-varicap(0, 1.6) }), [varicap]),
    _t2-celda(esquema({ cristal("x", (0, 0), (1.6, 0)) }), [cristal de cuarzo]),
    _t2-celda(esquema({ import zap: *; npn("q", (0, 0)); wire((-0.8, 0), "q.b"); wire("q.c", (rel: (0, 0.35))); wire("q.e", (rel: (0, -0.35))) }), [transistor NPN]),
    _t2-celda(esquema({ import zap: *; pnp("q", (0, 0)); wire((-0.8, 0), "q.b"); wire("q.c", (rel: (0, -0.35))); wire("q.e", (rel: (0, 0.35))) }), [transistor PNP]),
    _t2-celda(esquema({ import zap: *; nmos("m", (0, 0)); wire("m.g", (rel: (-0.5, 0))); wire("m.d", (rel: (0, 0.35))); wire("m.s", (rel: (0, -0.35))) }), [MOSFET canal N]),
    _t2-celda(esquema({ _t2-jfet(0, 0) }), [JFET canal N]),
    _t2-celda(cetz.canvas({ _t2-valvula("v", (0, 0), escala: 0.6, rejillas: ((0, "izq", black),)) }), [tríodo]),
    _t2-celda(esquema(escala: 0.55, { import zap: *; opamp("o", (0, 0)); wire("o.minus", (rel: (-0.5, 0))); wire("o.plus", (rel: (-0.5, 0))); wire("o.out", (rel: (0.5, 0))) }), [amplificador operacional]),
    _t2-celda(esquema({ bateria("b", (0, 0), (1.4, 0)) }), [pila]),
    _t2-celda(esquema({ import zap: *; wire((0, 0.5), (0, 0)); ground("g", (0, 0)) }), [masa]),
    _t2-celda(esquema({ import zap: *; antenna("a", (0, 0)) }), [antena]),
    _t2-celda(esquema({ import zap: *; fuse("f", (0, 0), (1.6, 0)) }), [fusible]),
  )
] <t2-fig-galeria>

#ojo[
  - En el diodo, la barra es el cátodo y el triángulo apunta en el sentido de paso de la corriente.
  - El transistor bipolar tiene la base *tocando* emisor y colector, y una flecha en el emisor. El MOSFET tiene la puerta *separada* del canal. El tríodo va dentro de una ampolla, y el operacional es un triángulo con las entradas $-$ y $+$.
  - En el JFET la flecha de la puerta sí toca el canal, porque la puerta es una unión PN; pero el FET que dibuja el examen (T2.65, T2.66) es el MOSFET, con la puerta separada.
  - La resistencia europea es un rectángulo; la americana, un zigzag. La bobina se dibuja como espiras; a veces, en la norma europea, como un rectángulo relleno.
]

// Símbolos de las opciones (como en la fuente)
#let _t2-o-res = _t2-sim({ import zap: *; resistor("r", (0, 0), (1.6, 0)) })
#let _t2-o-dio = _t2-sim({ import zap: *; diode("d", (0, 0), (1.6, 0)) })
#let _t2-o-bob = _t2-sim({ _t2-espiras(0, 1.6) })
#let _t2-o-con = _t2-sim({ import zap: *; capacitor("c", (0, 0), (1.6, 0)) })
#let _t2-o-bjt = _t2-sim({ import zap: *; npn("q", (0, 0)); wire((-0.9, 0), "q.b"); wire("q.c", (rel: (0, 0.45))); wire("q.e", (rel: (0, -0.45))) })
#let _t2-o-fet = _t2-sim({ import zap: *; nmos("m", (0, 0)); wire("m.g", (rel: (-0.6, 0))); wire("m.d", (rel: (0, 0.45))); wire("m.s", (rel: (0, -0.45))) })
#let _t2-o-val = box(baseline: 45%, inset: (y: 2pt), cetz.canvas({ _t2-valvula("v", (0, 0), escala: 0.62, rejillas: ((0, "izq", black),), grueso: 1.1pt) }))
#let _t2-o-amp = _t2-sim({ import zap: *; opamp("o", (0, 0)); wire("o.minus", (rel: (-0.4, 0))); wire("o.plus", (rel: (-0.4, 0))); wire("o.out", (rel: (0.4, 0))) })

#q("T2.61", "b",
  [De los siguientes símbolos, el que corresponde a un diodo es:],
  (_t2-o-res, _t2-o-dio, _t2-o-bob, _t2-o-con),
  sol: [El triángulo apoyado contra una barra transversal es el diodo, y la barra marca el cátodo: el triángulo apunta el sentido de paso, de ánodo a cátodo, así que en conducción la corriente sale por la barra. Las otras tres son resistencia, bobina y condensador.],
)

#q("T2.62", "c",
  [De los siguientes símbolos, el que corresponde a una resistencia es:],
  (_t2-o-con, _t2-o-bob, _t2-o-res, _t2-o-dio),
  sol: [El rectángulo alargado es la resistencia en la simbología europea (en la americana se dibuja en zigzag). Conviene reconocer ambas, porque los esquemas de origen anglosajón usan la segunda.],
)

#q("T2.63", "d",
  [De los siguientes símbolos, el que corresponde a un condensador es:],
  (_t2-o-bob, _t2-o-dio, _t2-o-res, _t2-o-con),
  sol: [Dos trazos paralelos enfrentados y sin tocarse: las dos armaduras separadas por el dieléctrico. El símbolo dice literalmente lo que es el componente.],
)

#q("T2.64", "c",
  [De los siguientes símbolos, el que corresponde a una bobina es:],
  (_t2-o-dio, _t2-o-res, _t2-o-bob, _t2-o-con),
  sol: [La sucesión de espiras representa el arrollamiento. En la simbología europea alternativa aparece a veces como un rectángulo, pero la forma de bobinado es la que el examen usa.],
)

#q("T2.65", "a",
  [De los siguientes símbolos, el que corresponde a un transistor bipolar es:],
  (_t2-o-bjt, _t2-o-fet, _t2-o-val, _t2-o-amp),
  sol: [El transistor bipolar se reconoce por la base recta, la flecha en el emisor —que marca el sentido de la corriente y distingue NPN de PNP— y el contacto directo de ambos con la base. El FET, en cambio, tiene la puerta separada por un hueco.],
)

#q("T2.66", "d",
  [De los siguientes símbolos, el que corresponde a un transistor de efecto de campo es:],
  (_t2-o-val, _t2-o-bjt, _t2-o-amp, _t2-o-fet),
  sol: [En el FET la puerta no toca el canal: se dibuja separada, porque controla por campo eléctrico y no por corriente. Esa separación es justo lo que explica su altísima impedancia de entrada.],
)
