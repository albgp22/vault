#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Ayudantes locales de este archivo (prefijo _t5-)
// ---------------------------------------------------------------------
#let _t5-t(t) = text(font: fuente-sans, size: 7.5pt, t)
#let _t5-f(t) = text(font: fuente-sans, size: 6.5pt, fill: col.naranja, t)
#let _t5-e(t, color: col.gris) = text(font: fuente-sans, size: 7pt, fill: color, t)
#let _t5-diagrama(..args) = diagram(
  node-stroke: 0.7pt + col.acento,
  node-fill: col.acento-claro,
  node-corner-radius: 2pt,
  edge-stroke: 0.6pt,
  spacing: (8mm, 8mm),
  ..args,
)
// Bloques que ya trabajan en radiofrecuencia (cadena de audio)
#let _t5-rf = (stroke: 0.7pt + col.naranja, fill: col.naranja-claro)
#let _t5-ant = box(cetz.canvas(length: 1em, {
  import cetz.draw: *
  line((0, 0), (0, 2.1), stroke: 0.7pt)
  line((-0.5, 2.2), (0, 1.5), (0.5, 2.2), stroke: 0.7pt)
}))
#let _t5-mic = box(cetz.canvas(length: 1em, {
  import cetz.draw: *
  circle((0, 0), radius: 0.75, stroke: 0.7pt)
  line((0.75, -0.75), (0.75, 0.75), stroke: 1.4pt)
  line((0, -0.75), (0, -1.3), stroke: 0.7pt)
  line((-0.5, -1.3), (0.5, -1.3), stroke: 0.7pt)
}))
#let _t5-preg(pos, ..args) = node(
  pos,
  text(font: fuente-sans, size: 11pt, weight: "bold", fill: col.naranja)[?],
  shape: rect,
  stroke: (paint: col.naranja, thickness: 0.7pt, dash: "dashed"),
  fill: col.naranja-claro,
  width: 13mm,
  height: 7mm,
  ..args,
)
// Mini-espectro de voz: trapecio entre fa y fb (alturas ha en fa y hb en fb)
#let _t5-banda(xa, xb, ha, hb, color) = cetz.draw.line(
  (xa, 0), (xa, ha), (xb, hb), (xb, 0), close: true,
  fill: color.lighten(60%), stroke: 0.8pt + color,
)

#tema("T5", "Transmisores", alcance: [Transmisores con y sin conversión de frecuencia · diagramas de bloques (CW, SSB, FM) · etapas: mezclador, oscilador, excitador, multiplicador, amplificador de potencia, filtro de salida, moduladores (de SSB, de frecuencia y de fase) · características: estabilidad, anchura de banda, margen de audiofrecuencia, desviación de frecuencia e índice de modulación, impedancia y potencia de salida, rendimiento, emisiones no deseadas, radiación por la estructura · transceptores y repetidores en VHF/UHF y su ubicación.])

// =====================================================================
== Arquitecturas y características generales <t5-sec-arquitecturas>

#motivacion(titulo: [cuatro encargos])[
  A un transmisor se le piden cuatro cosas, de menos a más difícil: generar una frecuencia *exacta y estable*; poner encima la información —el morse, la voz— *sin ensancharla* más de lo necesario; subir la potencia de milivatios a cien vatios *sin deformarla*; y entregarla a la antena de 50 Ω *sin nada más*: ni armónicos, ni productos de mezcla, ni chasquidos. Cada bloque de un transmisor existe para uno de esos cuatro encargos, y casi todas las preguntas del examen consisten en reconocer cuál.
]

El transmisor más simple es el de *CW*: un oscilador estable, etapas amplificadoras y un manipulador que corta la portadora al ritmo del Morse (clase A1A). El de *SSB* (@t5-fig-ssb) trabaja más fino: el *modulador balanceado* multiplica voz y portadora cancelando la portadora a la salida (queda la doble banda lateral), un *filtro de cristal* deja una sola banda — ya es J3E, pero a una frecuencia fija baja — y un *mezclador* con el VFO la traslada a la frecuencia de trabajo; como la envolvente de la SSB transporta la información, el amplificador final debe ser *lineal* (clase AB). El de *FM* modula un oscilador (un varicap sobre el VCO desvía la frecuencia al ritmo de la voz) y, al ser una señal de *envolvente constante*, admite multiplicadores y amplificadores en clase C, mucho más eficientes.

Dos detalles de diseño completan el cuadro. La SSB admite una segunda vía además del filtro: el _método de fase_, que genera dos versiones de la señal en cuadratura (90°) y las suma de modo que una banda lateral se refuerza y la otra se cancela. Y en FM las etapas multiplicadoras multiplican _todo_: si una cadena ×12 lleva el oscilador de 12 MHz a 144 MHz, la desviación — y con ella el índice de modulación — se multiplica también por 12, así que el modulador puede trabajar con desviaciones diminutas y cómodas de generar.

#circuito(caption: [Transmisor de banda lateral única. El modulador balanceado suprime la portadora, el filtro de cristal elimina una banda lateral y el mezclador traslada la señal a la frecuencia de trabajo; el final lineal y el filtro paso bajo la entregan limpia a la antena.])[
  #_t5-diagrama(
    spacing: (7mm, 9mm),
    node((0, 0), [], shape: circle, radius: 1.3mm, fill: white, stroke: 0.7pt),
    node((0, -0.45), _t5-e[BF], stroke: none, fill: none),
    node((1, 0), _t5-t[modulador\ balanceado], shape: rect),
    node((2, 0), _t5-t[filtro de\ cristal], shape: rect),
    node((3, 0), _t5-t[mezclador], shape: rect),
    node((4, 0), _t5-t[ampl. lineal\ (clase AB)], shape: rect),
    node((5, 0), _t5-t[filtro\ paso bajo], shape: rect),
    node((6, 0), _t5-ant, stroke: none, fill: none),
    node((1, 1), _t5-t[oscilador de\ portadora], shape: rect),
    node((3, 1), _t5-t[VFO /\ sintetizador], shape: rect),
    edge((0, 0), (1, 0), "-|>"),
    edge((1, 0), (2, 0), "-|>"),
    edge((2, 0), (3, 0), "-|>"),
    edge((3, 0), (4, 0), "-|>"),
    edge((4, 0), (5, 0), "-|>"),
    edge((5, 0), (6, 0), "-|>"),
    edge((1, 1), (1, 0), "-|>"),
    edge((3, 1), (3, 0), "-|>"),
  )
] <t5-fig-ssb>

#porque[
  - *Oscilador de portadora y modulador balanceado.* El modulador multiplica la voz por la portadora (por ejemplo, de 9 MHz). Su simetría hace que la portadora se cancele en la salida y solo queden las dos bandas laterales (#ver(<sec-modulador>)). Un modulador en anillo de diodos es el caso clásico: #falstad("ringmod.txt")
  - *Filtro de cristal.* Deja pasar solo una de las dos bandas: unos 2,4 kHz, con flancos muy abruptos. Solo es posible construirlo a una frecuencia fija; por eso la SSB se genera siempre a la misma frecuencia.
  - *Mezclador y VFO.* Trasladan la SSB ya hecha a la frecuencia de trabajo, igual que el superheterodino traslada la señal recibida a la FI, pero al revés.
  - *Amplificador lineal (clase AB).* La envolvente de la SSB _es_ la voz: un amplificador que la deformara (clase C) la distorsionaría y ensancharía la emisión.
  - *Filtro paso bajo.* Elimina los armónicos que genera el amplificador antes de que lleguen a la antena.
]

=== La SSB por el método del filtro, paso a paso

Sigue el espectro de la voz por cada bloque de @t5-fig-ssb (@t5-fig-ssb-espectros). La portadora de 9 MHz y el VFO de 5,2 MHz son los del receptor de 14,200 MHz del tema T4: un transceptor usa el mismo filtro y los mismos osciladores para recibir y para transmitir.

#circuito(caption: [El espectro en cada punto del transmisor de SSB. La voz (a) sale del modulador balanceado como dos bandas laterales sin portadora (b); el filtro de cristal deja solo la superior (c); el mezclador la sube a 14,2 MHz (d). La pendiente de cada trapecio indica el orden de las frecuencias de la voz: la banda inferior sale invertida.])[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    let eje(x0, y0, etq) = {
      line((x0, y0), (x0 + 6.6, y0), mark: (end: ">", fill: black), stroke: 0.6pt)
      content((x0 + 6.6, y0 - 0.1), anchor: "north-east", text(size: 6.5pt, etq))
    }
    let tit(x0, y0, t) = content((x0, y0 + 1.75), anchor: "west", text(font: fuente-sans, size: 7pt, weight: "bold", t))
    let etq(x, y0, t) = content((x, y0 - 0.1), anchor: "north", text(font: fuente-sans, size: 6pt, t))
    // (a) audio: 0–4 kHz → 0,3–6,3 cm
    group({
      translate((0, 2.6))
      eje(0, 0, [kHz])
      let x(k) = 0.3 + k * 1.5
      _t5-banda(x(0.3), x(3.0), 0.6, 1.1, col.senal3)
      etq(x(0), 0, [0]); etq(x(0.3), 0, [0,3]); etq(x(3), 0, [3])
      tit(0, 0, [(a) voz del micrófono])
    })
    // (b) DSB sin portadora en torno a 9 MHz: ±4 kHz → 0,3–6,3 cm
    group({
      translate((7.4, 2.6))
      eje(0, 0, [MHz])
      let x(k) = 3.3 + k * 0.75
      _t5-banda(x(0.3), x(3.0), 0.6, 1.1, col.senal1)
      _t5-banda(x(-0.3), x(-3.0), 0.6, 1.1, col.senal1)
      line((x(0), 0), (x(0), 1.3), stroke: (paint: col.gris, dash: "dashed", thickness: 0.7pt))
      content((x(0), 1.45), text(font: fuente-sans, size: 6pt, fill: col.gris)[portadora suprimida])
      etq(x(-3), 0, [8,997]); etq(x(0), 0, [9,000]); etq(x(3), 0, [9,003])
      tit(0, 0, [(b) salida del modulador balanceado])
    })
    // (c) solo la banda superior
    group({
      translate((0, 0))
      eje(0, 0, [MHz])
      let x(k) = 3.3 + k * 0.75
      rect((x(0.2), 0), (x(3.1), 1.35), stroke: (paint: col.naranja, dash: "dashed", thickness: 0.6pt))
      _t5-banda(x(0.3), x(3.0), 0.6, 1.1, col.senal1)
      line((x(0), 0), (x(0), 1.3), stroke: (paint: col.gris, dash: "dashed", thickness: 0.7pt))
      content((x(1.65), 1.5), text(font: fuente-sans, size: 6pt, fill: col.naranja)[filtro de cristal])
      etq(x(0), 0, [9,000]); etq(x(3), 0, [9,003])
      tit(0, 0, [(c) salida del filtro de cristal])
    })
    // (d) tras el mezclador: 14,2 MHz
    group({
      translate((7.4, 0))
      eje(0, 0, [MHz])
      let x(k) = 3.3 + k * 0.75
      _t5-banda(x(0.3), x(3.0), 0.6, 1.1, col.senal2)
      line((x(0), 0), (x(0), 1.3), stroke: (paint: col.gris, dash: "dashed", thickness: 0.7pt))
      etq(x(0), 0, [14,200]); etq(x(3), 0, [14,203])
      tit(0, 0, [(d) salida del mezclador: $9 + 5,2$ MHz])
    })
  })
] <t5-fig-ssb-espectros>

#ejemplo(titulo: [una SSB en 14,200 MHz])[
  La voz, de 300 a 3000 Hz, entra al modulador balanceado con una portadora de 9,000 MHz. Salen 8,997–8,9997 MHz (banda inferior) y 9,0003–9,003 MHz (banda superior), sin nada en 9,000 MHz. El filtro de cristal se queda con la superior. El mezclador la combina con un VFO de 5,200 MHz y entrega la suma, 14,2003–14,203 MHz —la SSB en 20 m—, pero también la diferencia, 3,8 MHz, ¡dentro de la banda de 80 m! Un filtro paso banda tras el mezclador elimina la diferencia y los restos de 5,2 y 9 MHz antes de amplificar.
]

#ojo[
  La SSB *no* se puede amplificar en clase C: la clase C aplasta la envolvente, y en SSB la envolvente es la información. Solo los modos de envolvente constante (CW y FM) admiten finales en clase C. Las preguntas T5.27 y T5.28 reparten el trabajo: el modulador equilibrado quita la *portadora*; el filtro quita *una banda lateral*.
]

=== El método de fase

El filtro de cristal es caro y fija la frecuencia. El *método de fase* elimina la banda indeseada por cancelación, sin filtro (@t5-fig-fase).

#circuito(caption: [Generación de SSB por el método de fase. Dos moduladores balanceados reciben la voz y la portadora; en la rama inferior las dos están desfasadas 90°. Al sumar, una banda lateral se refuerza y la otra se anula.])[
  #_t5-diagrama(
    spacing: (9mm, 7mm),
    node((0, 0), _t5-t[voz], stroke: none, fill: none),
    node((2.2, 0), _t5-t[modulador\ balanceado 1], shape: rect),
    node((2.2, 1.6), _t5-t[modulador\ balanceado 2], shape: rect),
    node((1.1, 1.6), _t5-t[desfasador\ 90° (audio)], shape: rect),
    node((2.2, -1.1), _t5-t[portadora (0°)], shape: rect),
    node((2.2, 2.7), _t5-t[portadora (90°)], shape: rect),
    node((3.5, 0.8), text(size: 11pt)[$Sigma$], shape: circle, radius: 3.5mm, fill: white),
    node((4.6, 0.8), _t5-t[SSB], stroke: none, fill: none),
    edge((0, 0), (2.2, 0), "-|>"),
    edge((0.45, 0), (0.45, 1.6), (1.1, 1.6), "-|>"),
    edge((1.1, 1.6), (2.2, 1.6), "-|>"),
    edge((2.2, -1.1), (2.2, 0), "-|>"),
    edge((2.2, 2.7), (2.2, 1.6), "-|>"),
    edge((2.2, 0), (3.5, 0), (3.5, 0.8), "-|>"),
    edge((2.2, 1.6), (3.5, 1.6), (3.5, 0.8), "-|>"),
    edge((3.5, 0.8), (4.6, 0.8), "-|>"),
  )
] <t5-fig-fase>

#porque[
  - El modulador 1 entrega $cos omega_c t dot cos omega_m t$: las dos bandas laterales, $1/2 [cos(omega_c - omega_m) t + cos(omega_c + omega_m) t]$.
  - El modulador 2, con voz y portadora desfasadas 90°, entrega $sin omega_c t dot sin omega_m t = 1/2 [cos(omega_c - omega_m) t - cos(omega_c + omega_m) t]$: las mismas bandas, pero la superior con el signo cambiado.
  - Al *sumar*, la banda superior se cancela y queda $cos(omega_c - omega_m) t$: la inferior. Al *restar*, queda la superior. Cambiar de LSB a USB es invertir un signo.
  - La dificultad está en el desfasador de audio: debe dar 90° exactos en toda la banda de 300 a 3000 Hz. Con 1° de error, la banda indeseada solo baja unos 40 dB. Hoy lo hace un DSP con precisión matemática: es la base de los transmisores SDR.
]

=== El transmisor de CW

#circuito(caption: [Transmisor de CW. El manipulador actúa sobre una etapa de bajo nivel, nunca sobre el oscilador. Sobre las flechas, potencias típicas de un equipo de 100 W.])[
  #_t5-diagrama(
    spacing: (10mm, 9mm),
    node((0, 0), _t5-t[oscilador\ (VFO)], shape: rect),
    node((1, 0), _t5-t[separador], shape: rect),
    node((2, 0), _t5-t[excitador], shape: rect),
    node((3, 0), _t5-t[ampl. potencia\ (clase C)], shape: rect),
    node((4, 0), _t5-t[filtro\ paso bajo], shape: rect),
    node((5, 0), _t5-ant, stroke: none, fill: none),
    node((2, 1), _t5-t[manipulador], shape: rect),
    edge((0, 0), (1, 0), "-|>", _t5-f[1 mW], label-side: left),
    edge((1, 0), (2, 0), "-|>", _t5-f[1 mW], label-side: left),
    edge((2, 0), (3, 0), "-|>", _t5-f[5 W], label-side: left),
    edge((3, 0), (4, 0), "-|>", _t5-f[100 W], label-side: left),
    edge((4, 0), (5, 0), "-|>", _t5-f[100 W], label-side: left),
    edge((2, 1), (2, 0), "-|>"),
  )
] <t5-fig-cw>

#porque[
  - *Oscilador.* Fija la frecuencia; todo lo demás solo la amplifica. Debe ser estable: una deriva de unos hercios ya se nota en CW (#ver(<sec-oscilador>)).
  - *Separador.* Aísla el oscilador de las etapas siguientes. Sin él, cada vez que se manipula cambia la carga, la frecuencia del oscilador se mueve y la nota «pía» (_chirp_) (T5.25).
  - *Excitador.* Sube la señal al nivel que necesita el final (T5.20). Es la etapa que se manipula: cortarla y restablecerla no toca al oscilador.
  - *Amplificador de potencia en clase C.* La CW solo tiene dos estados, portadora o nada: no hay envolvente que conservar y se puede usar la clase más eficiente (#ver(<sec-clases>)). A cambio, la clase C deforma mucho la onda y produce armónicos.
  - *Filtro paso bajo.* Quita esos armónicos (#ver(<t5-sec-no-deseadas>)).
]

=== El transmisor de AM

// FALSTAD-CUSTOM: modulacion-am
#circuito(caption: [Transmisor de AM con modulación de alto nivel: el amplificador de audio varía la tensión de alimentación del final al ritmo de la voz. Abajo, el espectro: portadora y dos bandas laterales, $2 f_m$ de anchura.])[
  #stack(
    dir: ttb,
    spacing: 4mm,
    _t5-diagrama(
      spacing: (9mm, 8mm),
      node((0, 0), _t5-t[oscilador], shape: rect),
      node((1, 0), _t5-t[excitador], shape: rect),
      node((2, 0), _t5-t[ampl. final\ (clase C)], shape: rect),
      node((3, 0), _t5-t[filtro\ paso bajo], shape: rect),
      node((4, 0), _t5-ant, stroke: none, fill: none),
      node((0, 1), _t5-mic, stroke: none, fill: none),
      node((1, 1), _t5-t[ampl. de audio\ (modulador)], shape: rect),
      edge((0, 0), (1, 0), "-|>"),
      edge((1, 0), (2, 0), "-|>"),
      edge((2, 0), (3, 0), "-|>"),
      edge((3, 0), (4, 0), "-|>"),
      edge((0, 1), (1, 1), "-|>"),
      edge((1, 1), (2, 1), (2, 0), "-|>", _t5-e[alimentación\ del final], label-side: right, label-pos: 0.75),
    ),
    cetz.canvas(length: 1cm, {
      import cetz.draw: *
      line((0, 0), (7, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
      content((7.1, 0), anchor: "west", text(size: 7pt)[$f$])
      rect((3.45, 0), (3.55, 1.6), fill: col.senal1, stroke: none)
      _t5-banda(3.8, 5.2, 0.5, 0.7, col.senal2)
      _t5-banda(3.2, 1.8, 0.5, 0.7, col.senal2)
      content((3.5, -0.1), anchor: "north", text(font: fuente-sans, size: 6.5pt)[$f_c$])
      content((1.8, -0.1), anchor: "north", text(font: fuente-sans, size: 6.5pt)[$f_c - f_m$])
      content((5.2, -0.1), anchor: "north", text(font: fuente-sans, size: 6.5pt)[$f_c + f_m$])
      content((3.5, 1.8), text(font: fuente-sans, size: 6.5pt, fill: col.senal1)[portadora])
      content((5.9, 0.6), anchor: "west", text(font: fuente-sans, size: 6.5pt, fill: col.senal2)[BLS])
      content((1.1, 0.6), anchor: "east", text(font: fuente-sans, size: 6.5pt, fill: col.senal2)[BLI])
    }),
  )
] <t5-fig-am>

La AM no está entre los diagramas de bloques del temario, pero ayuda a entender los otros dos. La información va en la envolvente, como en la SSB. Si se modula el propio final («alto nivel»), este puede trabajar en clase C, porque la envolvente se le impone por la alimentación; si se modula una etapa de poca potencia («bajo nivel»), todas las siguientes deben ser lineales. La emisión ocupa el doble de la frecuencia de audio más alta: unos 6 kHz para voz, frente a los 2,7 kHz de la SSB, y dos tercios de la potencia, como mínimo, se van en la portadora, que no lleva información (#ver(<sec-am>)).

=== El transmisor de FM

// FALSTAD-CUSTOM: modulacion-fm
#circuito(caption: [Transmisor de FM para 2 m con multiplicación ×12. Debajo de cada etapa, la frecuencia y la desviación de pico de su salida: los multiplicadores multiplican las dos.])[
  #_t5-diagrama(
    spacing: (5mm, 4mm),
    node((0, 0), _t5-mic, stroke: none, fill: none),
    node((1, 0), _t5-t[ampl. de\ audio], shape: rect),
    node((2, 0), _t5-t[oscilador\ con varicap], shape: rect),
    node((3, 0), _t5-t[×3], shape: rect),
    node((4, 0), _t5-t[×2], shape: rect),
    node((5, 0), _t5-t[×2], shape: rect),
    node((6, 0), _t5-t[excitador y\ PA (clase C)], shape: rect),
    node((7, 0), _t5-t[filtro\ paso bajo], shape: rect),
    node((8, 0), _t5-ant, stroke: none, fill: none),
    node((2, 0.75), _t5-f[12 MHz\ ±0,42 kHz], stroke: none, fill: none),
    node((3, 0.75), _t5-f[36 MHz\ ±1,25 kHz], stroke: none, fill: none),
    node((4, 0.75), _t5-f[72 MHz\ ±2,5 kHz], stroke: none, fill: none),
    node((5, 0.75), _t5-f[144 MHz\ ±5 kHz], stroke: none, fill: none),
    node((6, 0.75), _t5-f[144 MHz\ ±5 kHz], stroke: none, fill: none),
    edge((0, 0), (1, 0), "-|>"),
    edge((1, 0), (2, 0), "-|>"),
    edge((2, 0), (3, 0), "-|>"),
    edge((3, 0), (4, 0), "-|>"),
    edge((4, 0), (5, 0), "-|>"),
    edge((5, 0), (6, 0), "-|>"),
    edge((6, 0), (7, 0), "-|>"),
    edge((7, 0), (8, 0), "-|>"),
  )
] <t5-fig-fm>

El corazón del transmisor es el modulador: un *varicap* —un diodo polarizado en inversa cuya capacidad depende de la tensión— colgado del circuito resonante del oscilador (@t5-fig-varicap).

#circuito(sim: "varactorvco.txt", caption: [Modulador de FM con varicap. El circuito resonante $L$–$C$ fija la frecuencia del oscilador; el varicap $D_V$, unido a él a través de $C_b$, añade una capacidad que sigue a la tensión de audio.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    // circuito resonante del oscilador
    wire((0.4, 3), (3.2, 3))
    node("osc", (0.4, 3), fill: false)
    inductor("l", (2, 3), (2, 0), label: $L$)
    capacitor("c", (3.2, 3), (3.2, 0), label: $C$)
    wire((0.4, 0), (5.8, 0))
    node("osc2", (0.4, 0), fill: false)
    ground("g", (4.5, 0))
    // acoplo al varicap
    capacitor("cb", (3.2, 3), (5.8, 3), label: $C_b$)
    diode("dv", (5.8, 0), (5.8, 3), label: (content: $D_V$, anchor: "east"))
    // polarización + audio
    resistor("r", (5.8, 3), (8.2, 3), label: $R$)
    node("in", (8.2, 3), fill: false)
    node("n1", (3.2, 3))
    node("n2", (5.8, 3))
    content((0.4, 3.45), text(size: 7.5pt)[al oscilador])
    content((8.4, 3), anchor: "west", text(size: 7.5pt)[polarización\ + audio])
  })
] <t5-fig-varicap>

#porque[
  - *$L$ y $C$* forman el circuito resonante que fija la frecuencia del oscilador, $f_0 = 1 slash (2 pi sqrt(L C_"total"))$.
  - *$D_V$*, el varicap, está polarizado en inversa: su cátodo (arriba) recibe la tensión positiva a través de $R$. En inversa no conduce y se comporta como un condensador cuya capacidad baja cuando sube la tensión (#ver(<sec-diodo>)). La voz suma y resta tensión a la polarización: la capacidad sube y baja, y con ella la frecuencia. Eso es FM (#ver(<sec-fm>)).
  - *$C_b$* bloquea la continua. Sin él, la polarización iría a masa a través de la bobina $L$, que en continua es un cortocircuito.
  - *$R$* deja pasar la polarización y el audio, pero aísla el circuito resonante de la fuente de audio. Sin ella, la baja impedancia de la fuente amortiguaría el circuito y el oscilador dejaría de oscilar.
]

#ejemplo(titulo: [lo poco que tiene que moverse el varicap])[
  Con multiplicación ×12, para tener ±5 kHz de desviación en 144 MHz basta una desviación de $5000 slash 12 approx 417$ Hz en el oscilador de 12 MHz. Como $f_0$ va con $1 slash sqrt(C)$, un cambio relativo pequeño de capacidad da la mitad de cambio relativo de frecuencia: $Delta f slash f = -Delta C slash (2 C)$. Con $C_"total" approx 176$ pF (por ejemplo, $L = 1$ µH a 12 MHz): $Delta C = 2 dot 176 dot 417 slash (12 dot 10^6) approx 0,012$ pF. ¡Una centésima de picofaradio! Por eso el modulador puede trabajar «con desviaciones diminutas y cómodas de generar». Con un tono de 3 kHz, el índice de modulación es $m = 0,417 slash 3 approx 0,14$ en el oscilador y $5 slash 3 approx 1,7$ en la salida: también se ha multiplicado por 12.
]

#ojo[
  Los multiplicadores multiplican la frecuencia *y* la desviación (y el índice de modulación), pero *no* la frecuencia moduladora: la voz sigue siendo de 3 kHz. En la otra variante, la *FM indirecta*, un modulador de fase actúa detrás de un oscilador de cristal, que no se toca (#ver(<t5-sec-etapas>)).
]

=== Con y sin conversión de frecuencia

El temario distingue dos familias. En los transmisores *sin conversión de frecuencia* la señal de salida es el propio oscilador, o un múltiplo suyo: los de CW y FM de las figuras anteriores. En los transmisores *con conversión de frecuencia* la señal se fabrica a una frecuencia fija y luego un mezclador con un VFO la lleva a la de trabajo: el de SSB. La ventaja es la misma que la del superheterodino: un solo filtro de cristal sirve para todas las bandas, y en un transceptor ese filtro y esos osciladores sirven también para recibir. El precio es que el mezclador produce productos indeseados que hay que filtrar.

=== Tres convenios generales

Tres convenios generales. La *impedancia de salida* estándar es de 50 Ω (52 en textos antiguos), común a línea y antena para máxima transferencia. Las *clases de emisión* de la UIT se leen letra a letra — modulación, tipo de señal, contenido —: A1A (CW), A3E (AM), J3E (SSB con portadora suprimida), F3E (FM de fonía). Y el *índice de modulación* de FM es $m = Delta f slash f_m$, la desviación máxima entre la frecuencia moduladora; el *rendimiento* es la relación entre la potencia entregada al sistema radiante y la consumida de la fuente.

#ejemplo(titulo: [el rendimiento de un transceptor de 100 W])[
  Un transceptor de HF que entrega 100 W consume unos 20 A a 13,8 V: $13,8 dot 20 = 276$ W. El rendimiento global es $100 slash 276 approx 36$ %. Los otros 176 W se convierten en calor: por eso los finales llevan radiador y ventilador. Con un final en clase C (CW o FM), que supera el 70 %, el mismo calor permitiría sacar bastante más potencia.
]

#q("T5.1", "b",
  [La impedancia de salida típica de los transmisores de radioaficionado es de:],
  ([300 Ω], [50 Ω], [600 Ω], [75 Ω]),
  sol: [El estándar es 50 Ω (52 en algunos textos): transmisor, línea y antena se diseñan para esa impedancia común.],
)

#q("T5.2", "a",
  [Según la nomenclatura de clases de emisión de la UIT, el símbolo F3E corresponde a:],
  ([telefonía con modulación de frecuencia], [telegrafía de onda continua], [telefonía de banda lateral única], [telefonía con modulación de amplitud de doble banda lateral]),
  sol: [Nomenclatura UIT: F = modulación de frecuencia, 3 = un canal analógico, E = telefonía. Otras: A3E (AM), J3E (SSB), A1A (CW).],
)

#q("T5.3", "c",
  [En un transmisor de FM con una desviación máxima de frecuencia de 25 kHz y una frecuencia moduladora de 10 kHz, el índice de modulación vale:],
  ([0,4], [250], [2,5], [35]),
  sol: [$m = Delta f slash f_m = 25 slash 10 = 2,5$, adimensional.],
)

#q("T5.4", "d",
  [El filtro de salida de un transmisor tiene como misión:],
  ([aumentar la potencia radiada], [estabilizar la frecuencia del oscilador], [amplificar la señal moduladora], [eliminar las frecuencias no deseadas]),
  sol: [El filtro de salida (paso bajo en HF) atenúa armónicos y productos no deseados antes de la antena.],
)

#q("T5.5", "a",
  [El rendimiento de un transmisor es la relación entre:],
  ([la potencia entregada al sistema radiante y la potencia consumida], [la potencia directa y la potencia reflejada], [la tensión de salida y la tensión de entrada], [la frecuencia emitida y la frecuencia moduladora]),
  sol: [Rendimiento = $P_"radiada" slash P_"consumida"$; un final en clase C supera el 70 %, la clase A queda muy por debajo.],
)

// =====================================================================
== Emisiones no deseadas <t5-sec-no-deseadas>

Toda etapa no lineal deforma la señal, y una señal deformada contiene, por Fourier, *armónicos*: componentes en los múltiplos enteros de la fundamental ($2 f$, $3 f$…). Un transmisor de 7 MHz mal filtrado reaparece en 14 y 21 MHz — dentro de otras bandas de aficionado, o peor, fuera de ellas. Contra esto trabajan el *filtro de salida* (paso bajo tras el amplificador final) y el *ALC*, el lazo que limita la excitación del final para que nunca entre en la zona de saturación donde la intermodulación dispara el _splatter_ sobre los canales vecinos.

No toda la energía indeseada sale por la antena: la *radiación por la estructura* es la que escapa por el propio chasis del equipo y por sus cables — alimentación, micrófono, línea —, que actúan de antenas involuntarias. Se combate con un buen apantallado de la caja y con el filtrado de cada cable que entra o sale de ella.

La reglamentación lo cuantifica: por debajo de 30 MHz, las *emisiones no esenciales* (espurias) deben quedar al menos 40 dB por debajo de la potencia media sin superar los 50 mW (Anexo I, 4.1.1 de la Orden IET/1311/2013). Por encima de 30 MHz el límite depende además de la potencia del transmisor (@t5-tab-espurias); en todos los casos hay que cumplir a la vez el valor relativo (en dB) y el tope absoluto, es decir, el más restrictivo. La SETSI puede exigir límites más estrictos para proteger la radioastronomía y los servicios espaciales. El vocabulario oficial distingue el *ancho de banda necesario* (el justo para la calidad requerida), el *ocupado* (entre los límites real inferior y superior de la emisión), las emisiones *fuera de banda* (pegadas al canal, fruto de la modulación) y las *no esenciales* (lejos de él: armónicos, productos parásitos); estas dos últimas suman las *emisiones no deseadas*. En AM, además, la *potencia de pico* (en la cresta de la envolvente) siempre supera a la media: con modulación del 100 %, la envolvente dobla su amplitud en la cresta y —como la potencia va con el cuadrado de la amplitud— la potencia de pico es cuatro veces la de la *portadora* (y unas 2,7 veces la potencia media).

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: left,
    [*Frecuencias*], [*Potencia sobre el umbral*], [*Potencia igual o inferior*],
    [Menos de 30 MHz], table.cell(colspan: 2)[40 dB por debajo de la potencia media, sin exceder de 50 mW],
    [30 a 235 MHz], [si $P > 25$ W: 60 dB, sin exceder de 1 mW], [si $P <= 25$ W: 40 dB, sin exceder de 25 µW],
    [235 a 960 MHz], [si $P > 25$ W: 60 dB, sin exceder de 20 mW], [si $P <= 25$ W: 40 dB, sin exceder de 25 µW],
    [960 MHz a 17,7 GHz], [si $P > 10$ W: 50 dB, sin exceder de 100 mW], [si $P <= 10$ W: 50 dB, sin exceder de 100 µW],
  ),
  caption: [Límite de las emisiones no esenciales (Anexo I, 4.1.1 a 4.1.4 de la Orden IET/1311/2013): atenuación mínima respecto a la potencia media dentro de la anchura de banda necesaria y tope absoluto; vale el más restrictivo.],
  supplement: [Cuadro],
) <t5-tab-espurias>

#ejemplo[
  Con 100 W de potencia media en HF, el criterio «40 dB por debajo» da 10 mW, menos que el tope absoluto: mandan los 10 mW. Con 1 kW, 40 dB por debajo serían 100 mW, y entonces manda el tope de 50 mW. El reglamento aplica siempre el más restrictivo de los dos límites.

  Por encima de 30 MHz la cuenta es la misma. Un transmisor de FM de 50 W en 2 m ($P > 25$ W): 60 dB por debajo son 50 µW, menos que el tope de 1 mW, y mandan los 50 µW. Un portátil de 5 W en la misma banda: 40 dB por debajo serían 500 µW, pero el tope de 25 µW es más estricto (equivale a unos 53 dB) y es el que manda.
]

=== Potencia de pico y potencia media

La potencia de pico de la AM se ve en la envolvente (@t5-fig-am100). Sin modulación, la portadora tiene una amplitud $A$ y una potencia $P_c$. Al 100 % de modulación la envolvente sube hasta $2A$ en las crestas y baja a cero en los valles.

#circuito(caption: [Señal de AM modulada al 100 %. En la cresta la amplitud es el doble de la de la portadora: la potencia de pico es $2^2 = 4$ veces la de la portadora.])[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    ejes(0, 9.2, -2.3, 2.5, etq-x: $t$, etq-y: $v$)
    onda(t => 0.95 * (1 + calc.sin(t * 0.7 - 1.57)) * calc.sin(t * 14), 0, 9, n: 900, stroke: 0.6pt + col.senal1)
    onda(t => 0.95 * (1 + calc.sin(t * 0.7 - 1.57)), 0, 9, n: 200, stroke: (paint: col.senal2, dash: "dashed", thickness: 0.7pt))
    line((0, 0.95), (9, 0.95), stroke: (paint: col.gris, dash: "dotted", thickness: 0.5pt))
    line((0, 1.9), (9, 1.9), stroke: (paint: col.gris, dash: "dotted", thickness: 0.5pt))
    content((-0.1, 0.95), anchor: "east", text(size: 7pt)[$A$])
    content((-0.1, 1.9), anchor: "east", text(size: 7pt)[$2 A$])
    content((4.6, 2.15), text(font: fuente-sans, size: 6.5pt, fill: col.senal2)[envolvente: cresta de pico])
  })
] <t5-fig-am100>

#ejemplo(titulo: [portadora, media y pico])[
  Portadora de 100 W modulada al 100 % con un tono:
  - potencia de portadora (sin modulación): $P_c = 100$ W;
  - potencia media con modulación: $P_c (1 + m^2 slash 2) = 100 dot 1,5 = 150$ W (los 50 W de más van en las bandas laterales);
  - potencia de pico de envolvente: la amplitud se dobla y la potencia va con su cuadrado, $(2A)^2 = 4 A^2$, así que $P_"PEP" = 4 P_c = 400$ W, unas 2,7 veces la media.
  En SSB no hay portadora y la potencia sigue a la voz: por eso se especifica la *PEP*, la potencia en la cresta de la envolvente (T5.30). La *potencia de portadora* es la media durante un ciclo de RF sin modulación (T5.33).
]

=== Cada emisión indeseada, con su causa y su remedio

#motivacion[
  Cada emisión indeseada es la interferencia de otro: tus armónicos de 7 MHz caen en 14 y 21 MHz, sobre los colegas de esas bandas; tu _splatter_ tapa el comunicado del canal de al lado; una oscilación parásita en 150 MHz puede caer en servicios de seguridad. Por eso el reglamento las limita, y por eso cada una tiene su remedio.
]

==== Armónicos: el filtro paso bajo en pi

#circuito(caption: [Armónicos de un final en clase C de 7 MHz antes (barras grises) y después (barras azules) de un filtro paso bajo de 7 elementos con corte en 8 MHz (curva discontinua). Tras el filtro, todos quedan por debajo del límite de −40 dB.])[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    // x: 0–32 MHz → 0–9,6 cm; y: 0…−90 dB → 3,6…0 cm
    let x(f) = f * 0.3
    let y(db) = calc.max(0, 3.6 + db / 25)
    let lpf(f) = -10 * calc.log(1 + calc.pow(f / 8, 14))
    line((0, 0), (10, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((10.1, 0), anchor: "west", text(size: 7pt)[$f$ (MHz)])
    line((0, 0), (0, 3.9), mark: (end: ">", fill: black), stroke: 0.6pt)
    for db in (0, -20, -40, -60, -80) {
      line((-0.08, y(db)), (0, y(db)), stroke: 0.5pt)
      content((-0.12, y(db)), anchor: "east", text(font: fuente-sans, size: 6.5pt)[#db dB])
    }
    // límite reglamentario
    line((0, y(-40)), (9.8, y(-40)), stroke: (paint: col.naranja, dash: "dashed", thickness: 0.6pt))
    content((0.15, y(-40) + 0.08), anchor: "south-west", text(font: fuente-sans, size: 6.5pt, fill: col.naranja)[límite: −40 dB])
    // respuesta del filtro
    onda(f => y(lpf(f / 0.3)), 0, 9.6, n: 300, stroke: (paint: col.senal3, dash: "dashed", thickness: 0.8pt))
    // fundamental y armónicos
    for (n, antes) in ((1, 0), (2, -15), (3, -20), (4, -28)) {
      let f = 7 * n
      rect((x(f) - 0.2, 0), (x(f) - 0.02, y(antes)), fill: col.gris.lighten(55%), stroke: none)
      let despues = antes + lpf(f)
      rect((x(f) + 0.02, 0), (x(f) + 0.2, calc.max(0.03, y(despues))), fill: col.senal1, stroke: none)
      content((x(f), -0.12), anchor: "north", text(font: fuente-sans, size: 6.5pt)[#f])
    }
    content((x(7) + 0.3, y(-8)), anchor: "west", text(font: fuente-sans, size: 6.5pt)[fundamental])
  })
] <t5-fig-armonicos>

// FALSTAD-CUSTOM: red-pi
#circuito(caption: [Filtro paso bajo en pi (C–L–C) a la salida del amplificador final. Valores para un corte de unos 10 MHz en 50 Ω, adecuado para la banda de 40 m.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    wire((0, 2), (1.5, 2))
    node("e1", (0, 2), fill: false)
    capacitor("c1", (1.5, 2), (1.5, 0), label: $C_1$)
    inductor("l", (1.5, 2), (4.5, 2), label: $L$)
    capacitor("c2", (4.5, 2), (4.5, 0), label: $C_2$)
    wire((4.5, 2), (6, 2))
    node("s1", (6, 2), fill: false)
    wire((0, 0), (6, 0))
    node("e2", (0, 0), fill: false)
    node("s2", (6, 0), fill: false)
    node("na", (1.5, 2))
    node("nb", (4.5, 2))
    ground("g", (3, 0))
    content((0, 2.45), text(size: 7.5pt)[del final])
    content((6, 2.45), text(size: 7.5pt)[a la antena (50 Ω)])
    content((1.5, -0.75), text(size: 7pt)[318 pF])
    content((3, 2.85), text(size: 7pt)[1,59 µH])
    content((4.5, -0.75), text(size: 7pt)[318 pF])
  })
] <t5-fig-pi>

#porque[
  - *Los condensadores en paralelo* ($C_1$, $C_2$) ofrecen a la RF un camino a masa cuya reactancia, $X_C = 1 slash (2 pi f C)$, baja al subir la frecuencia: a los armónicos les abren un atajo.
  - *La bobina en serie* ($L$) tiene una reactancia $X_L = 2 pi f L$ que sube con la frecuencia: a los armónicos les pone un muro.
  - A 7 MHz, $X_C approx 72$ Ω y $X_L approx 70$ Ω: valores del orden de los 50 Ω del sistema, y la señal pasa. A 21 MHz (tercer armónico), $X_C approx 24$ Ω y $X_L approx 210$ Ω: el armónico encuentra un camino fácil a masa y uno difícil hacia la antena.
  - El mismo esquema en pi sirve también para *adaptar* impedancias (#ver(<sec-redes-adaptacion>)): en los finales de válvulas, los mandos de sintonía y carga (T5.34) son los dos condensadores de una red en pi. Una escalera más larga del mismo tipo, con 10 elementos: #falstad("butter10lo.txt")
]

#ejemplo(titulo: [cuánto atenúa un pi])[
  Con los valores de @t5-fig-pi ($C = 1 slash (2 pi dot 10^7 dot 50) approx 318$ pF, $L = 2 dot 50 slash (2 pi dot 10^7) approx 1,59$ µH, el filtro Butterworth de 3 elementos), el tercer armónico (21 MHz) baja solo unos 19 dB. Cada elemento añadido hace la caída más abrupta: con 5 elementos, unos 32 dB; con 7, unos 45 dB. Por eso los equipos comerciales usan 5 o 7 elementos —a menudo de tipo Chebyshev o elíptico, aún más abruptos— y un filtro distinto para cada grupo de bandas, que se conmuta al cambiar de banda. Un final en contrafase (_push-pull_) ayuda además porque cancela los armónicos pares.
]

==== Espurias de mezcla

En un transmisor con conversión de frecuencia, el mezclador entrega la suma *y* la diferencia, más restos de sus dos entradas: en el ejemplo de la SSB, además de 14,2 MHz salen 3,8 MHz, 5,2 MHz y 9 MHz. Si no se filtran, el amplificador lineal los amplifica igual que a la señal buena. El remedio es un filtro paso banda tras el mezclador, mezcladores balanceados (que suprimen sus entradas) y un buen blindaje entre etapas.

==== _Splatter_: el ALC

#circuito(caption: [Espectro de una SSB limpia (azul) y de la misma señal con el final sobreexcitado (rojo, discontinuo). Los productos de intermodulación de la saturación ensanchan la emisión varios kHz a cada lado: es el _splatter_.])[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    // x: −10…+12 kHz respecto a la portadora suprimida → 0…8,8 cm
    let x(k) = (k + 10) * 0.4
    let y(db) = calc.max(0, 3.2 + db / 25)
    let limpia(k) = if k < 0.3 { -10 * calc.log(1 + calc.pow((0.3 - k) / 0.12, 8)) } else if k > 2.7 { -10 * calc.log(1 + calc.pow((k - 2.7) / 0.12, 8)) } else { 0 }
    let sucia(k) = calc.max(limpia(k), if k < 1.5 { -25 - 4 * (1.5 - k) } else { -25 - 4 * (k - 1.5) })
    line((0, 0), (9.2, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((9.3, 0), anchor: "west", text(size: 7pt)[$Delta f$ (kHz)])
    line((0, 0), (0, 3.5), mark: (end: ">", fill: black), stroke: 0.6pt)
    for db in (0, -20, -40, -60) {
      line((-0.08, y(db)), (0, y(db)), stroke: 0.5pt)
      content((-0.12, y(db)), anchor: "east", text(font: fuente-sans, size: 6.5pt)[#db dB])
    }
    for k in (-10, -5, 0, 5, 10) {
      content((x(k), -0.12), anchor: "north", text(font: fuente-sans, size: 6.5pt)[#k])
    }
    onda(k => y(sucia((k / 0.4) - 10)), 0, 8.8, n: 600, stroke: (paint: col.senal2, dash: "dashed", thickness: 1pt))
    onda(k => y(limpia((k / 0.4) - 10)), 0, 8.8, n: 600, stroke: 1.2pt + col.senal1)
    content((x(1.5), y(0) + 0.15), anchor: "south", text(font: fuente-sans, size: 6.5pt, fill: col.senal1)[canal propio (2,4 kHz)])
    content((x(7.5), y(-28)), anchor: "west", text(font: fuente-sans, size: 6.5pt, fill: col.senal2)[_splatter_ sobre los vecinos])
  })
] <t5-fig-splatter>

El _splatter_ aparece cuando el final (o cualquier etapa) se excita más allá de su zona lineal: recorta las crestas de la envolvente, y una envolvente recortada contiene productos de intermodulación que caen a ambos lados del canal. El remedio es no sobreexcitar, y de eso se encarga el *ALC* (@t5-fig-alc).

#circuito(caption: [El lazo de ALC. Un detector mide la potencia de salida y, cuando se acerca al máximo, reduce la ganancia de una etapa de bajo nivel (aquí, la FI).])[
  #_t5-diagrama(
    spacing: (7mm, 9mm),
    node((0, 0), _t5-mic, stroke: none, fill: none),
    node((1, 0), _t5-t[ampl. de\ micrófono], shape: rect),
    node((2, 0), _t5-t[modulador\ y filtro SSB], shape: rect),
    node((3, 0), _t5-t[ampl. FI\ (ganancia\ variable)], shape: rect),
    node((4, 0), _t5-t[mezclador y\ excitador], shape: rect),
    node((5, 0), _t5-t[ampl.\ potencia], shape: rect),
    node((6, 0), _t5-ant, stroke: none, fill: none),
    node((4.5, 1.1), _t5-t[detector de ALC\ (rectificador + RC)], shape: rect, stroke: 0.7pt + col.verde, fill: col.verde-claro),
    edge((0, 0), (1, 0), "-|>"),
    edge((1, 0), (2, 0), "-|>"),
    edge((2, 0), (3, 0), "-|>"),
    edge((3, 0), (4, 0), "-|>"),
    edge((4, 0), (5, 0), "-|>"),
    edge((5, 0), (6, 0), "-|>"),
    edge((5.5, 0), (5.5, 1.1), (4.5, 1.1), "-|>", stroke: 0.6pt + col.verde),
    edge((4.5, 1.1), (3, 1.1), (3, 0), "-|>", stroke: 0.6pt + col.verde, dash: "dashed"),
    node((3.6, 1.45), _t5-e(color: col.verde)[tensión de ALC], stroke: none, fill: none),
  )
] <t5-fig-alc>

#porque[
  - *Mide.* Un diodo rectifica una muestra de la salida: una tensión continua proporcional a la potencia.
  - *Compara y corrige.* Mientras la potencia está por debajo del máximo, el ALC no hace nada. Cuando la voz empuja hacia el máximo, la tensión de ALC reduce la ganancia de la FI justo lo necesario: la envolvente no llega a recortarse.
  - *Por qué en una etapa de bajo nivel.* Controlar unos milivatios es fácil y no disipa nada; recortar en el final sería producir precisamente la distorsión que se quiere evitar.
  - Es el mismo lazo que el CAG del receptor (#ver(<t4-sec-caracteristicas>)), pero en el transmisor: allí se mantiene constante el audio de salida; aquí, se impide que la potencia pase del máximo.
]

==== Chasquidos de manipulación: flancos suaves

#circuito(caption: [Arriba, la envolvente de un punto de morse con flancos verticales (rojo) y con flancos redondeados de unos 5 ms (azul). Abajo, sus espectros: el escalón brusco reparte energía muchos kHz a cada lado —los _key clicks_—; el flanco suave la concentra en unos cientos de hercios.])[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    // envolventes: t 0–80 ms → 0–8 cm
    let brusco(t) = if t > 15 and t < 65 { 1 } else { 0 }
    let suave(t) = if t <= 12 or t >= 68 { 0 } else if t < 18 { 0.5 - 0.5 * calc.cos((t - 12) / 6 * 180deg) } else if t > 62 { 0.5 + 0.5 * calc.cos((t - 62) / 6 * 180deg) } else { 1 }
    group({
      translate((0, 2.6))
      ejes(0, 8.4, 0, 1.7, etq-x: [$t$ (ms)], etq-y: [envolvente])
      line((0, 0), (1.5, 0), (1.5, 1.25), (6.5, 1.25), (6.5, 0), (8, 0), stroke: (paint: col.senal2, thickness: 1pt, dash: "dashed"))
      onda(t => 1.2 * suave(t * 10), 0, 8, n: 400, stroke: 1.2pt + col.senal1)
      for t in (0, 20, 40, 60) {
        content((t / 10, -0.1), anchor: "north", text(font: fuente-sans, size: 6pt)[#t])
      }
    })
    // espectros: ±1,5 kHz → 0–8 cm, y en dB 0…−80 → 1,8…0 cm
    let x(k) = (k + 1.5) / 3 * 8
    let y(db) = calc.max(0, 1.8 + db / 44.4)
    line((0, 0), (8.4, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((8.5, 0), anchor: "west", text(size: 7pt)[$Delta f$ (kHz)])
    onda(u => y(-20 * calc.log(1 + calc.abs(u / 8 * 3 - 1.5) / 0.02)), 0, 8, n: 500, stroke: (paint: col.senal2, thickness: 1pt, dash: "dashed"))
    onda(u => y(-60 * calc.pow(calc.abs(u / 8 * 3 - 1.5) / 0.25, 2)), 0, 8, n: 500, stroke: 1.2pt + col.senal1)
    for k in (-1.5, -1, -0.5, 0, 0.5, 1, 1.5) {
      content((x(k), -0.1), anchor: "north", text(font: fuente-sans, size: 6pt)[#str(k).replace(".", ",").replace("-", "−")])
    }
  })
] <t5-fig-clicks>

Un escalón de cero a plena portadora en un instante es, por Fourier, una suma de frecuencias muy altas: la portadora queda modulada por ellas y la emisión se ensancha a ambos lados (T5.29). Se oye en los receptores vecinos como un «clic» en cada flanco. El remedio es redondear la subida y la bajada de la envolvente, con tiempos de 3 a 5 ms: un circuito RC en la línea del manipulador, que hace que la etapa manipulada se abra y se cierre de forma gradual. Una señal bien conformada, a 25 palabras por minuto, ocupa del orden de 100 Hz.

==== Oscilaciones parásitas: los supresores

Un amplificador con mucha ganancia es un oscilador en potencia: basta que una parte de su salida vuelva a la entrada con la fase adecuada. Las inductancias de los hilos y las capacidades del propio transistor forman, sin que nadie los haya puesto ahí, circuitos resonantes en VHF, y el final puede ponerse a oscilar por su cuenta a 100 o 200 MHz: una *oscilación parásita*, que no tiene nada que ver con la frecuencia de trabajo.

#circuito(caption: [Supresor de oscilaciones parásitas: una bobina de pocas espiras ($L_p$) en paralelo con una resistencia ($R_p$), en serie con el colector del final. $L_"ch"$ es el choque de alimentación.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    npn("q", (4, 2))
    wire((1.2, 2), "q.b")
    node("ex", (1.2, 2), fill: false)
    content((1.2, 2.4), text(size: 7.5pt)[excitación])
    wire("q.e", (4, 0.8))
    ground("g", (4, 0.8))
    wire("q.c", (4, 3.0))
    inductor("lp", (4, 3.0), (4, 4.6))
    content((3.4, 3.8), text(size: 8pt)[$L_p$])
    wire((4, 3.0), (5.2, 3.0))
    resistor("rp", (5.2, 3.0), (5.2, 4.6))
    content((5.8, 3.8), text(size: 8pt)[$R_p$])
    wire((5.2, 4.6), (4, 4.6))
    node("n1", (4, 3.0))
    node("n2", (4, 4.6))
    wire((4, 4.6), (4, 5.2))
    node("n3", (4, 5.2))
    inductor("lch", (4, 5.2), (4, 6.8))
    content((3.35, 6.0), text(size: 8pt)[$L_"ch"$])
    vcc("v", (4, 6.8), label: $+V_"CC"$)
    capacitor("cs", (4, 5.2), (6.6, 5.2), label: $C_s$)
    node("sal", (6.6, 5.2), fill: false)
    content((6.6, 5.65), text(size: 7.5pt)[a la red de salida])
  })
] <t5-fig-parasitas>

#porque[
  - A la frecuencia de trabajo, la bobina $L_p$ (por ejemplo, 0,1 µH) apenas presenta reactancia: a 7 MHz, $X_L = 2 pi dot 7 dot 10^6 dot 0,1 dot 10^(-6) approx 4,4$ Ω. La señal útil pasa por ella y la resistencia ($R_p approx 47$ Ω) casi no recibe corriente ni se calienta.
  - A 150 MHz, la misma bobina presenta unos 94 Ω: la corriente parásita tiene que repartirse con $R_p$, que la convierte en calor. El lazo parásito pierde ganancia y no puede mantener la oscilación.
  - Otros remedios: perlas de ferrita en los terminales, desacoplo cuidadoso de la alimentación y conexiones cortas. Si el amplificador tiende a oscilar a la _propia_ frecuencia de trabajo (realimentación por la capacidad interna entre salida y entrada), el remedio es la *neutralización*: devolver a la entrada una muestra igual y en contrafase.
]

==== Radiación por la estructura

La radiación por la estructura se combate cerrando el camino a la RF: caja metálica continua y bien conectada a masa, condensadores pasantes en cada cable que entra o sale, choques de ferrita en los cables de alimentación y de micrófono, y la malla del coaxial bien unida al chasis.

#figure(
  table(
    columns: (auto, 1fr, auto, 1fr),
    align: left,
    [*Emisión*], [*Qué la causa*], [*Dónde cae*], [*Remedio*],
    [Armónicos], [etapa no lineal (clase C, saturación)], [$2 f$, $3 f$…], [filtro paso bajo de salida; contrafase],
    [Espurias de mezcla], [suma, diferencia y restos del mezclador], [lejos del canal], [filtro paso banda tras el mezclador; blindaje],
    [_Splatter_], [sobreexcitación o sobremodulación], [canales contiguos], [ALC; ganancia de micrófono correcta; final lineal],
    [Chasquidos], [manipulación brusca], [kHz alrededor], [flancos de 3 a 5 ms (red RC)],
    [Parásitas], [realimentación por elementos parásitos], [sin relación con $f$], [supresores, ferritas, neutralización],
    [Por la estructura], [chasis y cables que radian], [—], [apantallado, filtros pasantes, ferritas],
  ),
  caption: [Las emisiones no deseadas, su causa y su remedio.],
  supplement: [Cuadro],
) <t5-tab-remedios>

#ojo[
  - Armónicos = múltiplos *enteros* de la fundamental (T5.6). Nunca la mitad ni frecuencias inferiores.
  - El ALC evita las emisiones interferentes *alrededor* de la frecuencia de trabajo (T5.7): no aumenta la potencia ni la modulación.
  - Espurias por debajo de 30 MHz: *40 dB* por debajo de la potencia media y *50 mW* como máximo (T5.9).
  - Emisiones no deseadas = no esenciales + fuera de banda (T5.14).
]

#q("T5.6", "b",
  [Los armónicos generados por un transmisor son señales cuya frecuencia es:],
  ([la mitad de la frecuencia fundamental], [un múltiplo entero de la frecuencia fundamental], [independiente de la frecuencia fundamental], [siempre inferior a la frecuencia fundamental]),
  sol: [Los armónicos son múltiplos enteros de la fundamental: un transmisor de 7 MHz mal filtrado puede aparecer en 14 y 21 MHz.],
)

#q("T5.7", "c",
  [El control automático de nivel (ALC) de un transmisor permite:],
  ([aumentar la profundidad de modulación], [elevar la potencia de salida por encima de la nominal], [evitar emisiones interferentes alrededor de la frecuencia de trabajo], [reducir el consumo del amplificador final]),
  sol: [El ALC limita la excitación del final para que no se sobrecargue: evita distorsión y splatter alrededor de la frecuencia.],
)

#q("T5.8", "a",
  [En un transmisor con modulación de amplitud, la potencia de pico es:],
  ([siempre superior a la potencia media], [siempre igual a la potencia media], [siempre inferior a la potencia media], [nula si la modulación es del 100 %]),
  sol: [La potencia instantánea sigue el cuadrado de la envolvente. Al 100 % de modulación la envolvente llega a valer el doble de la portadora en la cresta, y como la potencia va con el cuadrado de la amplitud, la de pico es $2^2 = 4$ veces la de la portadora. Frente a la media $P_c (1 + m^2 slash 2) = 1,5 P_c$, son $4 slash 1,5 approx 2,7$ veces: por eso la de pico supera siempre a la media.],
)

#q("T5.9", "d",
  [Para frecuencias inferiores a 30 MHz, las emisiones no esenciales (espurias) de un transmisor de aficionado deben estar atenuadas al menos:],
  ([10 dB por debajo de la potencia media, sin exceder de 1 W], [20 dB por debajo de la potencia media, sin exceder de 500 mW], [60 dB por debajo de la potencia media, sin exceder de 1 mW], [40 dB por debajo de la potencia media, sin exceder de 50 mW]),
  sol: [Límite del Anexo I, 4.1.1 de la Orden IET/1311/2013 para $f < 30$ MHz: espurias al menos 40 dB por debajo de la potencia media sin exceder de 50 mW. Por encima de 30 MHz los límites son otros y dependen de la potencia (@t5-tab-espurias).],
)

#q("T5.10", "b",
  [El ancho de banda ocupado por una emisión es:],
  ([el doble de la frecuencia moduladora máxima, en todos los casos], [el comprendido entre los límites superior e inferior de la señal modulada], [la separación entre canales adyacentes], [la frecuencia máxima transmitida]),
  sol: [El ancho de banda ocupado va del límite inferior al superior del espectro de la señal modulada.],
)

// =====================================================================
== Etapas y definiciones <t5-sec-etapas>

Entre el oscilador y la antena median varias etapas con papeles precisos: el *excitador* amplifica la señal del oscilador hasta el nivel que el final necesita; el *multiplicador* aprovecha los armónicos de una etapa no lineal para multiplicar la frecuencia del oscilador (×2, ×3) — así los equipos de VHF/UHF parten de cristales de frecuencia modesta —; el *amplificador de potencia* eleva la señal a su nivel final; el *filtro de salida* la limpia; y el *modulador de fase*, dispuesto tras un oscilador a cristal, produce FM _indirecta_ sin renunciar a la estabilidad del cristal (la modulación de fase se definió en el tema T1). Un *transceptor* integra transmisor y receptor compartiendo oscilador y sintonía, y un *repetidor* (VHF/UHF) recibe en una frecuencia y retransmite simultáneamente en otra desde un punto elevado: en la banda de 2 m la entrada va 600 kHz por debajo de la salida, el «desplazamiento del repetidor». Para no abrirlo con cualquier señal espuria, muchos repetidores exigen que la portadora lleve un *subtono* (CTCSS): un tono de baja frecuencia, inaudible en la conversación, que actúa de llave de acceso.

=== La cadena de etapas, con números

#circuito(caption: [Cadena de un transmisor de 2 m a partir de un cristal de 48 MHz. Sobre las flechas, frecuencia y potencia de cada salida.])[
  #_t5-diagrama(
    spacing: (12mm, 8mm),
    node((0, 0), _t5-t[oscilador\ de cristal], shape: rect),
    node((1, 0), _t5-t[separador], shape: rect),
    node((2, 0), _t5-t[multipli-\ cador ×3], shape: rect),
    node((3, 0), _t5-t[excitador], shape: rect),
    node((4, 0), _t5-t[ampl. de\ potencia], shape: rect),
    node((5, 0), _t5-t[filtro de\ salida], shape: rect),
    node((6, 0), _t5-ant, stroke: none, fill: none),
    edge((0, 0), (1, 0), "-|>", _t5-f[48 MHz\ 1 mW], label-side: left),
    edge((1, 0), (2, 0), "-|>", _t5-f[48 MHz\ 1 mW], label-side: left),
    edge((2, 0), (3, 0), "-|>", _t5-f[144 MHz\ 5 mW], label-side: left),
    edge((3, 0), (4, 0), "-|>", _t5-f[144 MHz\ 1 W], label-side: left),
    edge((4, 0), (5, 0), "-|>", _t5-f[144 MHz\ 25 W], label-side: left),
    edge((5, 0), (6, 0), "-|>"),
  )
] <t5-fig-cadena>

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: left,
    [*Etapa*], [*Qué hace*], [*Qué falla sin ella*],
    [Oscilador], [genera la frecuencia], [no hay señal],
    [Separador (_buffer_)], [aísla el oscilador de la carga variable de las etapas siguientes (T5.25)], [la frecuencia se mueve al manipular o al cambiar la potencia],
    [Multiplicador], [toma un armónico (×2, ×3) de una etapa no lineal (T5.11)], [haría falta un oscilador estable directamente en VHF, mucho más difícil],
    [Excitador (_driver_)], [lleva la señal al nivel que necesita el final (T5.20)], [el final no llega a su potencia],
    [Amplificador de potencia], [da la potencia final], [solo saldrían unos milivatios],
    [Filtro de salida / red de acoplo], [quita armónicos y adapta a 50 Ω (T5.4)], [armónicos al aire y mala adaptación],
  ),
  caption: [Las etapas de un transmisor.],
  supplement: [Cuadro],
) <t5-tab-etapas>

=== Un multiplicador por dentro

#motivacion[
  Un oscilador de cristal es muy estable hasta unas decenas de megahercios, pero no hay cristales fundamentales prácticos de 144 MHz. ¿Cómo se consigue una portadora de 2 m con la estabilidad de un cristal de 48 MHz?
]

// FALSTAD-CUSTOM: clase-c
#circuito(caption: [Doblador de frecuencia: un transistor en clase C con el circuito resonante del colector sintonizado a $2 f$.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    // entrada y polarización de base (sin polarización directa: clase C)
    npn("q", (4.6, 2))
    capacitor("cin", (0.4, 2), (2.6, 2), label: $C_"ent"$)
    node("e", (0.4, 2), fill: false)
    content((0.4, 2.45), text(size: 7.5pt)[entrada $f$])
    node("nb", (2.6, 2))
    wire((2.6, 2), "q.b")
    resistor("rb", (2.6, 2), (2.6, 0.5))
    content((2.05, 1.25), text(size: 8pt)[$R_B$])
    ground("gb", (2.6, 0.5))
    wire("q.e", (4.6, 0.5))
    ground("ge", (4.6, 0.5))
    // circuito resonante en 2f entre +V y colector
    wire("q.c", (4.6, 3.4))
    wire((4.0, 3.4), (5.2, 3.4))
    wire((4.0, 5.0), (5.2, 5.0))
    inductor("lt", (4.0, 5.0), (4.0, 3.4))
    capacitor("ct", (5.2, 5.0), (5.2, 3.4))
    content((3.45, 4.2), text(size: 8pt)[$L_T$])
    content((5.75, 4.2), text(size: 8pt)[$C_T$])
    node("nc", (4.6, 3.4))
    node("nv", (4.6, 5.0))
    wire((4.6, 5.0), (4.6, 5.6))
    vcc("v", (4.6, 5.6), label: $+V_"CC"$)
    // salida
    capacitor("cs", (5.2, 3.4), (7.4, 3.4))
    content((6.3, 2.9), text(size: 8pt)[$C_"sal"$])
    node("s", (7.4, 3.4), fill: false)
    content((7.4, 3.85), text(size: 7.5pt)[salida $2 f$])
  })
] <t5-fig-doblador>

#circuito(caption: [Las señales del doblador. La base recibe $f$ (arriba); el transistor solo conduce en las crestas, a impulsos (centro); el circuito resonante, sintonizado a $2 f$, devuelve una sinusoide del doble de frecuencia (abajo).])[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    let fila(dy, etq) = {
      line((0, dy), (8.4, dy), mark: (end: ">", fill: black), stroke: 0.5pt)
      content((-0.15, dy), anchor: "east", text(font: fuente-sans, size: 7pt, etq))
    }
    fila(3.2, [$v_"base"$ ($f$)])
    onda(t => 3.2 + 0.6 * calc.sin(t * 1.5708), 0, 8, n: 300, stroke: 1pt + col.senal1)
    fila(1.6, [$i_C$])
    onda(t => 1.6 + calc.max(0, calc.sin(t * 1.5708) - 0.75) * 3, 0, 8, n: 600, stroke: 1pt + col.senal2)
    fila(0, [$v_"sal"$ ($2 f$)])
    onda(t => 0.55 * calc.sin(t * 3.1416 - 1.5708 + 3.1416), 0, 8, n: 400, stroke: 1pt + col.senal3)
  })
] <t5-fig-doblador-ondas>

#porque[
  - *Clase C.* La base no tiene polarización directa: $R_B$ la deja a 0 V en reposo. El transistor solo conduce cuando la señal de entrada supera unos 0,6 V, es decir, en un trocito de cada cresta. La corriente de colector son impulsos estrechos (#ver(<sec-clases>)).
  - *Impulsos ricos en armónicos.* Un tren de impulsos estrechos se descompone, por Fourier, en la fundamental y muchos armónicos de amplitud parecida.
  - *El circuito resonante elige.* $L_T$ y $C_T$ resuenan en $2 f$: presentan alta impedancia (y por tanto tensión) solo a esa frecuencia; para $f$ y los demás armónicos son casi un cortocircuito (#ver(<sec-amp-sintonizado>)).
  - *Efecto volante.* El circuito recibe un impulso cada dos ciclos suyos y, entre impulso e impulso, sigue oscilando solo por la energía guardada: la salida es una sinusoide continua.
  - *Límites.* Cuanto más alto el armónico, menos energía lleva: ×2 y ×3 son prácticos; para ×12 se encadenan etapas (×3 · ×2 · ×2). Un multiplicador también multiplica la deriva del cristal y la desviación de FM.
]

=== Qué clase de final pide cada modo

#figure(
  table(
    columns: (auto, auto, 1fr, auto),
    align: left,
    [*Modo*], [*¿Envolvente constante?*], [*Final adecuado*], [*Rendimiento típico*],
    [CW (A1A)], [sí (todo o nada)], [clase C, con flancos suaves], [70–80 %],
    [FM (F3E)], [sí], [clase C], [70–80 %],
    [AM (A3E)], [no], [lineal, o clase C modulada en la alimentación], [según el montaje],
    [SSB (J3E)], [no], [lineal: clase AB (o A)], [AB: 50–60 %; A: 25–35 %],
  ),
  caption: [Qué amplificador final admite cada modo.],
  supplement: [Cuadro],
) <t5-tab-clases>

#idea[
  La regla es una sola: *si la información va en la envolvente, el final tiene que ser lineal.* Los modos de envolvente constante (CW, FM) pueden usar la clase C y ahorrar energía; los de envolvente variable (AM de bajo nivel, SSB) no.
]

=== Transceptores y repetidores

#circuito(caption: [Funcionamiento de un repetidor de 2 m. Recibe en 145,000 MHz y retransmite a la vez en 145,600 MHz: la entrada va 600 kHz por debajo de la salida. Solo se abre si la portadora de entrada lleva su subtono CTCSS.])[
  #_t5-diagrama(
    spacing: (22mm, 8mm),
    node((0, 0), _t5-t[estación A\ transmite en 145,000], shape: rect),
    node((1, 0), _t5-t[*repetidor* (en un monte)\ RX 145,000 · TX 145,600\ duplexor y una antena], shape: rect, stroke: 0.7pt + col.naranja, fill: col.naranja-claro),
    node((2, 0), _t5-t[estación B\ escucha en 145,600], shape: rect),
    edge((0, 0), (1, 0), "-|>", _t5-f[145,000 MHz\ + CTCSS], label-side: left),
    edge((1, 0), (2, 0), "-|>", _t5-f[145,600 MHz], label-side: left),
  )
] <t5-fig-repetidor>

En VHF y UHF las ondas viajan prácticamente en línea recta: dos estaciones portátiles separadas por una colina no se oyen. Un repetidor colocado en un punto alto —un monte, una torre— ve a las dos y hace de puente. Como recibe y transmite *a la vez*, no puede usar la misma frecuencia: su propio transmisor taparía lo que recibe. Por eso trabaja en *dúplex*, con 600 kHz de separación en 2 m, y usa un *duplexor*: un juego de cavidades resonantes de $Q$ muy alto que deja pasar el transmisor hacia la antena y lo bloquea hacia el receptor, a solo 600 kHz de distancia. Tu equipo hace el resto: al elegir el modo repetidor, transmite automáticamente 600 kHz por debajo de la frecuencia que escuchas y añade el subtono.

#q("T5.11", "c",
  [El multiplicador de frecuencia de un transmisor se emplea para:],
  ([reducir el consumo del equipo], [filtrar la señal moduladora], [incrementar la frecuencia generada por un oscilador], [estabilizar la tensión de alimentación]),
  sol: [El multiplicador toma la salida de un oscilador estable y la multiplica (×2, ×3…) para alcanzar la frecuencia de trabajo, típico en equipos de VHF/UHF.],
)

#q("T5.12", "a",
  [El «índice de modulación» es un parámetro que caracteriza a:],
  ([la modulación de frecuencia], [la telegrafía de onda continua], [la potencia de alimentación], [la ganancia de la antena]),
  sol: [El índice de modulación ($m = Delta f slash f_m$) es el parámetro característico de la FM; en AM se habla de porcentaje o profundidad de modulación.],
)

#q("T5.13", "b",
  [La anchura de banda necesaria de un transmisor es:],
  ([siempre la máxima que permita el equipo], [la suficiente para permitir la transmisión a la velocidad y con la calidad requeridas], [la mitad de la anchura del canal], [independiente del tipo de emisión]),
  sol: [La anchura de banda necesaria es la justa para transmitir con la velocidad y calidad requeridas: ni más (desperdicia espectro e interfiere) ni menos (degrada la señal).],
)

#q("T5.14", "d",
  [Se denomina «emisiones no deseadas» al conjunto de:],
  ([las emisiones de los repetidores], [las señales recibidas fuera de la banda de aficionados], [las emisiones con potencia inferior a la autorizada], [las emisiones no esenciales y las emisiones fuera de banda]),
  sol: [Definición reglamentaria: emisiones no deseadas = emisiones no esenciales (espurias) + emisiones fuera de banda.],
)

// =====================================================================
== La cadena de audio y la inteligibilidad <t5-sec-audio>

Antes de que haya radiofrecuencia que modular hay una cadena de audio, y de ella depende que al otro lado se entienda o no lo que decimos (@t5-fig-audio).

Empieza en el *micrófono*, que convierte las variaciones de presión del aire —el sonido— en una señal eléctrica de unos pocos milivoltios. Es tan pequeña que necesita un *preamplificador* antes de servir para nada. Y lo primero que se hace con ella es recortarla: a la voz humana le sobra casi todo su margen para _entenderse_, y basta con la banda de 300 a 3000 Hz. Todo lo que quede fuera solo aportaría anchura de banda — espectro robado a los vecinos de frecuencia — sin mejorar la *inteligibilidad*.

Después viene un truco que separa una emisión que se oye de otra que no. La voz tiene picos muy altos y valles muy bajos; el transmisor está limitado por el _pico_, así que si dejamos la señal tal cual, la potencia media —la que de verdad llega al corresponsal— resulta ridícula comparada con la de pico. Un *compresor* de audio sube los valles sin tocar los picos y con ello eleva la potencia media sin pasarse del límite: la señal «pega» más con el mismo equipo. Pasarse en la otra dirección, gritando al micrófono o abriendo demasiado la ganancia, produce *sobremodulación*: la envolvente se recorta, aparecen productos de intermodulación y la emisión ensancha e interfiere a los canales contiguos — es el _splatter_.

En SSB la señal de audio llega por fin al *modulador equilibrado*, que la mezcla con la portadora y —esa es su gracia— la cancela, dejando solo las dos bandas laterales; un *filtro de banda lateral* elimina después una de ellas. Lo que sale de ahí ya es la señal que las etapas de RF amplificarán.

#circuito(caption: [La cadena de audio de un transmisor de SSB. Hasta el modulador todo es audiofrecuencia; a partir de él, radiofrecuencia. Limitar la banda a 300–3000 Hz conserva la inteligibilidad y no desperdicia espectro.])[
  #_t5-diagrama(
    spacing: (9mm, 8mm),
    node((0, 0), _t5-mic, stroke: none, fill: none),
    node((0, 0.62), _t5-e[micrófono], stroke: none, fill: none),
    node((1, 0), _t5-t[preamplificador], shape: rect),
    node((2, 0), _t5-t[compresor\ y limitador], shape: rect),
    node((3, 0), _t5-t[modulador\ equilibrado], shape: rect, .._t5-rf),
    node((4, 0), _t5-t[filtro de\ banda lateral], shape: rect, .._t5-rf),
    node((5, 0), _t5-e[a las etapas de RF], stroke: none, fill: none),
    node((3, 1), _t5-t[oscilador], shape: rect, .._t5-rf),
    edge((0, 0), (1, 0), "-|>"),
    edge((1, 0), (2, 0), "-|>"),
    edge((2, 0), (3, 0), "-|>"),
    edge((3, 0), (4, 0), "-|>"),
    edge((4, 0), (5, 0), "-|>"),
    edge((3, 1), (3, 0), "-|>"),
    edge((0.6, -0.75), (2.45, -0.75), "|-|", stroke: 0.5pt + col.gris, _t5-e[banda de voz: 300–3000 Hz], label-side: left),
  )
] <t5-fig-audio>

=== Por qué basta con 300–3000 Hz

La energía de la voz está en las vocales, por debajo de 1 kHz; la inteligibilidad, en las consonantes, entre 1 y 3 kHz. Por debajo de 300 Hz solo hay «cuerpo» y zumbido; por encima de 3 kHz, brillo. En SSB la emisión ocupa tanto como la frecuencia de audio más alta que se transmite: con 3 kHz de audio, unos 2,7 kHz de espectro útil (de 300 a 3000 Hz); con audio de alta fidelidad, 20 kHz. Recortar la banda no es un sacrificio: es lo que permite que quepan siete veces más estaciones en el mismo trozo de banda.

=== El compresor, visto en la señal

#circuito(caption: [Una frase, sin y con compresor. El límite de pico (líneas discontinuas) es el mismo; el compresor sube las sílabas débiles, y la potencia media —el área que ocupa la señal— crece.])[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    let env(t) = 0.95 * calc.exp(-calc.pow((t - 0.8) / 0.3, 2)) + 0.35 * calc.exp(-calc.pow((t - 1.9) / 0.35, 2)) + 0.6 * calc.exp(-calc.pow((t - 2.9) / 0.25, 2)) + 0.18 * calc.exp(-calc.pow((t - 3.7) / 0.3, 2))
    let comp(t) = calc.pow(env(t) / 0.95, 0.5) * 0.95
    let panel(dx, f, titulo) = {
      line((dx, 0), (dx + 4.4, 0), stroke: 0.4pt + col.gris)
      line((dx, 1.0), (dx + 4.4, 1.0), stroke: (paint: col.naranja, dash: "dashed", thickness: 0.5pt))
      line((dx, -1.0), (dx + 4.4, -1.0), stroke: (paint: col.naranja, dash: "dashed", thickness: 0.5pt))
      onda(t => f(t - dx) * calc.sin((t - dx) * 70), dx, dx + 4.4, n: 900, stroke: 0.5pt + col.senal1)
      content((dx + 2.2, 1.35), text(font: fuente-sans, size: 7pt, weight: "bold", titulo))
    }
    panel(0, env, [sin compresor])
    panel(5.2, comp, [con compresor])
    content((9.7, 1.0), anchor: "west", text(font: fuente-sans, size: 6.5pt, fill: col.naranja)[límite de pico])
  })
] <t5-fig-compresor>

#ejemplo(titulo: [lo que gana el compresor])[
  La voz tiene una relación entre potencia de pico y potencia media de unos 10 dB. Un equipo de 100 W PEP, con voz sin procesar, da de media unos 10 W. Un compresor bien ajustado sube la media 3–6 dB —hasta 20–40 W— sin pasar de los 100 W de pico. Al otro lado, 6 dB son un punto S entero: la señal se oye como si el equipo tuviera cuatro veces más potencia media, sin ensanchar la emisión.
]

#ojo[
  - El compresor sube la potencia *media* sin superar la de *pico* (T5.17); no ensancha la banda ni elimina ruido.
  - La sobremodulación es un exceso de *audio*: se corrige bajando la ganancia de micrófono o el nivel al modulador (T5.19, T5.31, T5.32), no tocando la alimentación del final.
  - El modulador equilibrado quita la portadora (T5.27); el filtro de banda lateral quita una banda (T5.28).
]

=== Siglas que se confunden

#figure(
  table(
    columns: (auto, auto, 1fr),
    align: left,
    [*Sigla*], [*Dónde*], [*Qué controla*],
    [CAG (AGC)], [receptor], [la ganancia, para que la salida de audio sea constante (T4.7)],
    [ALC], [transmisor], [el nivel de excitación del final, para que no sature (T5.7, T5.36)],
    [CAF (AFC)], [oscilador], [la frecuencia, para corregir la deriva (T5.23)],
    [VOX], [transceptor], [pasa a transmisión al detectar voz (T5.26)],
    [PTT], [micrófono], [pulsador para transmitir (_push to talk_)],
    [RIT], [receptor], [la frecuencia de recepción sola (T4.21)],
  ),
  caption: [Siglas de control que el examen mezcla en los distractores.],
  supplement: [Cuadro],
) <t5-tab-siglas>

=== El orden de los equipos en la estación

#circuito(caption: [Orden de conexión de una estación con amplificador lineal (T5.22). El medidor de ROE lee lo que de verdad sale hacia la antena, y el acoplador va lo más cerca posible de ella.])[
  #_t5-diagrama(
    spacing: (9mm, 8mm),
    node((0, 0), _t5-t[transceptor], shape: rect),
    node((1, 0), _t5-t[amplificador\ lineal], shape: rect),
    node((2, 0), _t5-t[medidor\ de ROE], shape: rect),
    node((3, 0), _t5-t[acoplador], shape: rect),
    node((4, 0), _t5-ant, stroke: none, fill: none),
    edge((0, 0), (1, 0), "-|>"),
    edge((1, 0), (2, 0), "-|>"),
    edge((2, 0), (3, 0), "-|>"),
    edge((3, 0), (4, 0), "-|>"),
  )
] <t5-fig-estacion>

Sigue la misma lógica que el orden interno del transmisor (T5.21): primero se genera y se modula a bajo nivel, luego se amplifica, y lo último antes de la línea es la adaptación a la antena. El lineal va justo después del transceptor porque necesita sus pocos vatios de excitación; el medidor de ROE, después del lineal, para medir la potencia real; el acoplador, junto a la antena, porque su trabajo es adaptar lo que la línea le presenta.

=== Decibelios referidos a una potencia

#figure(
  table(
    columns: (auto, auto, auto),
    align: (right, right, right),
    [*Potencia*], [*dBm* (ref. 1 mW)], [*dBW* (ref. 1 W)],
    [1 mW], [0 dBm], [−30 dBW],
    [1 W], [30 dBm], [0 dBW],
    [10 W], [40 dBm], [10 dBW],
    [100 W], [50 dBm], [20 dBW],
    [1 kW], [60 dBm], [30 dBW],
  ),
  caption: [Equivalencias de dBm y dBW (T5.24). «dB» a secas no es una potencia, sino una relación.],
  supplement: [Cuadro],
) <t5-tab-dbm>

=== Ajustar sin molestar: la carga artificial

Para ajustar un transmisor no hace falta radiar: se conecta en lugar de la antena una *carga artificial*, una resistencia no inductiva de 50 Ω capaz de disipar la potencia del equipo (T5.35). Para el transmisor es una antena perfecta, con ROE 1:1; toda la energía se convierte en calor y nadie en la banda se entera. En los finales de válvulas se ajustan así los dos mandos de la red en pi de salida: *sintonía* (_tune_), que lleva el circuito a resonancia —mínimo de corriente de placa—, y *carga* (_load_), que ajusta el acoplo a la antena hasta obtener la potencia deseada (T5.34).

#q("T5.15", "c",
  [Un micrófono es un dispositivo que convierte:],
  ([las señales eléctricas en ondas sonoras], [la corriente continua en corriente alterna], [las ondas sonoras en una señal eléctrica], [la radiofrecuencia en audiofrecuencia]),
  sol: [Es un transductor de presión: recoge las variaciones de presión del aire y las entrega como tensión. El que hace el camino contrario —de señal eléctrica a sonido— es el altavoz.],
)

#q("T5.16", "a",
  [El preamplificador de micrófono de un transmisor tiene por objeto:],
  ([elevar el bajo nivel de la señal que entrega el micrófono], [suprimir la portadora de la emisión], [adaptar la impedancia de la antena], [multiplicar la frecuencia del oscilador]),
  sol: [El micrófono entrega unos pocos milivoltios, insuficientes para atacar las etapas siguientes. Suprimir la portadora es cosa del modulador equilibrado, y adaptar la antena, del acoplador.],
)

#q("T5.17", "d",
  [El compresor de audio de un transmisor de SSB sirve para:],
  ([ensanchar la banda de audio transmitida], [aumentar la potencia de pico del equipo], [suprimir el ruido de fondo del micrófono], [elevar la potencia media de la emisión sin superar la potencia de pico]),
  sol: [La voz tiene picos altos y valles bajos, y el transmisor está limitado por el pico. El compresor sube los valles sin tocar los picos: sube la potencia media, que es la que se oye al otro lado, con el mismo equipo y sin sobremodular.],
)

#q("T5.18", "b",
  [Para una emisión de fonía, la banda de audiofrecuencias que basta transmitir para conservar la inteligibilidad es aproximadamente:],
  ([de 20 a 20 000 Hz], [de 300 a 3000 Hz], [de 3 a 30 kHz], [de 50 a 150 Hz]),
  sol: [Es la banda telefónica clásica: con ella la voz se entiende perfectamente. Transmitir más solo ensancharía la emisión sin mejorar la inteligibilidad — y el espectro que sobra se lo quitamos a los vecinos de frecuencia. Los 20 Hz a 20 kHz son el margen de la alta fidelidad.],
)

#q("T5.19", "c",
  [Hablar demasiado fuerte al micrófono, o abrir en exceso la ganancia de micrófono, produce:],
  ([una mejora de la inteligibilidad], [un aumento del alcance de la estación], [sobremodulación, con ensanchamiento de la emisión e interferencias], [una reducción de la potencia de pico]),
  sol: [La envolvente se recorta, aparecen productos de intermodulación y la emisión invade los canales contiguos: es el splatter. Se oye peor, no mejor, y molesta a los demás. Para evitarlo está el ALC.],
)

#q("T5.20", "a",
  [En un transmisor, el excitador tiene la misión de:],
  ([suministrar la potencia necesaria a la etapa amplificadora final], [excitar la etapa osciladora], [alimentar en continua todo el transmisor], [sumar las frecuencias de los dos osciladores]),
  sol: [El excitador es la etapa intermedia que eleva el nivel de la señal hasta lo que el amplificador final necesita a su entrada. Un lineal externo, por ejemplo, se «excita» con los pocos vatios que le entrega el transceptor.],
)

#q("T5.21", "b",
  [El orden correcto de los bloques funcionales de un equipo emisor es:],
  ([amplificador final, red de acoplo, modulador y cadena de amplificación], [modulador, cadena de amplificación y traslación de frecuencia, amplificador final y red de acoplo], [cadena de amplificación, modulador, red de acoplo y amplificador final], [red de acoplo, amplificador final, modulador y cadena de amplificación]),
  sol: [Se sigue el camino de la señal: primero se modula a bajo nivel, después se amplifica y se traslada a la frecuencia de trabajo, luego se sube la potencia y por último se adapta a la antena. La red de acoplo es siempre lo último antes de la línea.],
)

#q("T5.22", "d",
  [El orden en que deben conectarse los equipos de una estación es:],
  ([transceptor, acoplador, amplificador lineal, medidor de ROE y antena], [transceptor, medidor de ROE, acoplador, amplificador lineal y antena], [transceptor, acoplador, medidor de ROE, amplificador lineal y antena], [transceptor, amplificador lineal, medidor de ROE, acoplador y antena]),
  sol: [El acoplador va lo más cerca posible de la antena, porque su trabajo es adaptar lo que la línea presenta. Y el medidor de ROE debe leer la potencia real que sale hacia la antena, es decir, después del lineal.],
)

#q("T5.23", "c",
  [Las siglas CAF corresponden a:],
  ([cuadripolo adaptador final], [circuito adaptado en frecuencia], [control automático de frecuencia], [control automático de fidelidad]),
  sol: [Es el lazo que corrige la deriva del oscilador para mantener el equipo en la frecuencia deseada. No confundir con el CAG (control automático de ganancia, del receptor) ni con el ALC (control automático de nivel, del transmisor).],
)

#q("T5.24", "a",
  [Una potencia de 1 vatio equivale a:],
  ([30 dBm], [30 dBW], [30 dB], [3 dBm]),
  sol: [El dBm se refiere a 1 mW, y 1 W son 1000 mW: $10 log_10 (1000) = 30$ dBm. En dBW, 1 W es exactamente 0 dBW. Y «30 dB» a secas no es una potencia, sino una relación.],
)

#q("T5.25", "b",
  [La etapa separadora que se intercala entre el oscilador y el amplificador de un transmisor sirve para:],
  ([elevar la frecuencia del oscilador], [aislar el oscilador de las variaciones de carga de las etapas siguientes], [modular la señal en amplitud], [rectificar la señal del oscilador]),
  sol: [Un oscilador es sensible a lo que tenga colgado: si la carga varía, su frecuencia se mueve. La separadora lo desacopla y le deja ver siempre la misma carga, con lo que la emisión no deriva al variar la potencia.],
)

#q("T5.26", "d",
  [El dispositivo VOX de un transceptor permite:],
  ([comprimir la señal de audio], [ajustar automáticamente la frecuencia], [variar la desviación de frecuencia en FM], [pasar automáticamente a transmisión al hablar ante el micrófono]),
  sol: [Del inglés _voice operated exchange_: detecta que hay voz en el micrófono y conmuta el equipo a transmisión sin tocar el PTT, volviendo a recepción tras una breve espera al callarse.],
)

#q("T5.27", "c",
  [En un transmisor de banda lateral única, el modulador equilibrado tiene la propiedad de:],
  ([duplicar la frecuencia de la portadora], [amplificar la señal de audio], [suprimir la portadora y dejar solo las dos bandas laterales], [eliminar los armónicos de la etapa final]),
  sol: [Su simetría hace que la portadora se cancele a la salida y solo sobrevivan los productos de mezcla, es decir, las dos bandas laterales. Un filtro posterior se queda con una sola: eso ya es SSB.],
)

#q("T5.28", "a",
  [El filtro de banda lateral de un transmisor de SSB se encarga de:],
  ([eliminar una de las dos bandas laterales], [eliminar la señal de audio residual], [adaptar la impedancia de salida], [suprimir la portadora]),
  sol: [Las dos bandas laterales llevan la misma información, así que transmitir una sola ahorra la mitad del espectro y concentra toda la potencia en ella. Suprimir la portadora ya lo hizo antes el modulador equilibrado.],
)

#q("T5.29", "b",
  [Una manipulación demasiado brusca en una emisión de telegrafía produce:],
  ([una reducción de la velocidad de transmisión], [chasquidos de manipulación que ensanchan la emisión], [la desaparición de la portadora], [un aumento del rendimiento del transmisor]),
  sol: [Cortar y restablecer la portadora de golpe equivale a un escalón, y un escalón contiene frecuencias muy altas: son los _key clicks_, que se oyen a ambos lados de la frecuencia. Por eso los equipos redondean los flancos de la manipulación.],
)

#q("T5.30", "d",
  [Las siglas PEP, con que se expresa la potencia de un transmisor de SSB, significan:],
  ([potencia entregada permanente], [potencia eficaz promediada], [potencia específica de portadora], [potencia de pico de envolvente]),
  sol: [Del inglés _peak envelope power_. En SSB la potencia varía continuamente con la voz, así que no tiene sentido dar un valor medio: se especifica la potencia en la cresta de la envolvente, que es la que limita el equipo y la que la reglamentación acota.],
)

#q("T5.31", "d",
  [Se dice que un transmisor de amplitud modulada está sobremodulando cuando:],
  ([la potencia de salida supera la nominal], [la frecuencia se aparta de la asignada], [la portadora desaparece por completo], [el índice de modulación supera el 100 %]),
  sol: [Con índice mayor que 1 la envolvente intenta hacerse negativa, la portadora se recorta y aparecen productos de distorsión que ensanchan la emisión. Es el mismo fenómeno que produce el splatter en SSB.],
)

#q("T5.32", "b",
  [Para evitar la sobremodulación de un transmisor hay que actuar sobre:],
  ([la tensión de alimentación de la etapa final], [el nivel de la señal de baja frecuencia aplicada al modulador], [la longitud de la línea de transmisión], [la frecuencia del oscilador]),
  sol: [La sobremodulación es un exceso de audio, no de radiofrecuencia: se corrige bajando la ganancia de micrófono o el nivel de entrada al modulador. Tocar la alimentación de la etapa final cambiaría la potencia, no el índice de modulación.],
)

#q("T5.33", "c",
  [Se denomina potencia de portadora de un transmisor a la que entrega a la línea de alimentación de la antena:],
  ([durante la cresta de modulación], [promediada a lo largo de un minuto], [durante un ciclo de radiofrecuencia, en ausencia de modulación], [con la antena desconectada]),
  sol: [Es la definición del Reglamento de Radiocomunicaciones: potencia media durante un ciclo de radiofrecuencia, sin modulación. Junto con la potencia de pico de envolvente y la potencia media, es una de las tres formas reglamentarias de expresar la potencia de un transmisor.],
)

#q("T5.34", "b",
  [En un transmisor valvular, el mando de control de carga (_load_) sirve para:],
  ([variar la frecuencia de emisión], [ajustar el acoplo de la etapa final a la antena], [modificar la ganancia de micrófono], [conmutar entre transmisión y recepción]),
  sol: [En los finales valvulares hay dos mandos que se manejan juntos: sintonía, que busca el mínimo de corriente de placa, y carga, que ajusta el acoplo a la antena hasta obtener la potencia deseada. Uno resuena, el otro adapta.],
)

#q("T5.35", "b",
  [Al sintonizar un emisor empleando una antena artificial:],
  ([la señal se radia con la misma intensidad que con la antena real], [la mayor parte de la energía del emisor se disipa en forma de calor], [se obtiene mayor potencia de salida], [se produce una lectura de ROE muy elevada]),
  sol: [La carga artificial es una resistencia no inductiva que sustituye a la antena: acepta toda la potencia y la convierte en calor en lugar de radiarla. Por eso permite ajustar sin ocupar la banda ni molestar a nadie.],
)

// =====================================================================
== Preguntas sobre esquemas <t5-sec-esquemas>

#q("T5.36", "b",
  [En el esquema de un transmisor de banda lateral única de la figura, el bloque señalado con una interrogación toma muestra de la salida y actúa sobre las etapas anteriores para evitar la sobreexcitación. Se trata de:
  #circuito[
    #_t5-diagrama(
      spacing: (10mm, 8mm),
      node((0, 0), _t5-t[micrófono], shape: rect),
      node((1, 0), _t5-t[modulador\ equilibrado], shape: rect),
      node((2, 0), _t5-t[mezclador], shape: rect),
      node((3, 0), _t5-t[ampl.\ potencia], shape: rect),
      node((4, 0), _t5-e[antena], stroke: none, fill: none),
      _t5-preg((2.2, 1)),
      edge((0, 0), (1, 0), "-|>"),
      edge((1, 0), (2, 0), "-|>"),
      edge((2, 0), (3, 0), "-|>"),
      edge((3, 0), (4, 0), "-|>"),
      edge((3, 0), (3, 1), (2.2, 1), "-"),
      edge((2.2, 1), (1, 1), (1, 0), "-|>"),
    )
  ]],
  ([el control automático de frecuencia], [el control automático de nivel (ALC)], [el oscilador de batido], [el silenciador]),
  sol: [Ese lazo desde la salida hacia las etapas anteriores es el control automático de nivel: recorta la excitación cuando el final se acerca a su límite, evitando el recorte de la envolvente y el splatter que provocaría. Es la protección contra la sobremodulación en SSB.],
)
