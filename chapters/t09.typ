#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Utilidades locales del tema T9
// ---------------------------------------------------------------------
#let _t9-chico(c) = text(size: 7.5pt, c)

/// Raya de un espectro: frecuencia x, altura h (en cm), etiqueta debajo.
#let _t9-raya(x, h, etq: none, color: col.senal1, grosor: 1.6pt) = {
  import cetz.draw: *
  line((x, 0), (x, h), stroke: grosor + color)
  if etq != none { content((x, -0.08), anchor: "north", text(size: 6.5pt, etq)) }
}

/// Amplitudes de los armónicos de una sinusoide recortada solo por arriba (nivel `techo`).
#let _t9-armonicos(techo, n: 5, muestras: 720) = {
  let y(t) = calc.min(calc.sin(t), techo)
  range(1, n + 1).map(k => {
    let (a, b) = (0.0, 0.0)
    for i in range(muestras) {
      let t = 2 * calc.pi * i / muestras
      a += y(t) * calc.cos(k * t)
      b += y(t) * calc.sin(k * t)
    }
    2 * calc.sqrt(a * a + b * b) / muestras
  })
}

#tema("T9", "Interferencia e inmunidad", alcance: [Interferencia en equipos electrónicos y compatibilidad electromagnética · bloqueo, intermodulación y detección en circuitos de audio · causas: intensidad de campo, emisiones no esenciales y fuera de banda, acoplo por antena, por líneas o por radiación directa · medidas correctoras: filtrado, desacoplo y apantallamiento.])

== Causas de interferencia <t9-sec-causas>

#motivacion[El vecino llama a la puerta: cada vez que transmites, su equipo de música habla con tu voz y su televisor se llena de rayas. ¿Emite tu estación donde no debe, o escuchan sus equipos lo que no deben? Las dos cosas ocurren, tienen remedios distintos y el examen pregunta por ambas. Para no dar palos de ciego hace falta un método: saber *qué* sale de tu estación, *por dónde* llega al vecino y *qué* le hace a su equipo.]

Todo problema de *compatibilidad electromagnética* se descompone en tres piezas: una fuente, una víctima y un camino de acoplo. La fuente puede ser la propia estación — su campo intenso, sus armónicos y espurias, la sobreexcitación de un amplificador lineal —; la víctima, cualquier equipo electrónico cercano; y el camino, la antena de la víctima, las líneas que le llegan (red eléctrica, altavoces, televisión por cable) o la *radiación directa* sobre sus circuitos. Los mecanismos de daño tienen nombre propio: la *desensibilización o bloqueo* (un campo fuerte satura la entrada de un receptor aunque esté sintonizado lejos), la *intermodulación* (dos señales se mezclan en cualquier elemento no lineal — incluso una mala soldadura — y generan productos donde nadie transmite) y la *detección en circuitos de audio* (una unión semiconductora de un amplificador de baja frecuencia rectifica la RF y la voz del radioaficionado aparece por los altavoces del vecino).

#circuito(caption: [Fuente, caminos y víctimas. La RF de la estación llega a los equipos del vecino por tres caminos: (1) la antena de la víctima, (2) la radiación directa sobre sus circuitos y sus cables, y (3) la red eléctrica. En cada víctima actúa un mecanismo distinto.])[
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (14mm, 9mm),
    node((0, 0), [Antena de la estación], shape: rect, name: <ant>),
    node((0, 1), [Transmisor], shape: rect, fill: col.naranja-claro, name: <tx>),
    node((0, 2.4), [Red eléctrica de la casa], shape: rect, stroke: (dash: "dashed"), name: <red>),
    node((2.6, 0), align(center)[Antena y televisor\ #_t9-chico[bloqueo · armónicos · intermodulación]], shape: rect, fill: col.acento-claro, name: <tv>),
    node((2.6, 1.2), align(center)[Amplificador de audio y altavoces\ #_t9-chico[detección en audio]], shape: rect, fill: col.acento-claro, name: <audio>),
    edge(<tx>, <ant>, "-", label: _t9-chico[coaxial], label-side: left),
    edge(<ant>, <tv>, "--|>", stroke: col.senal2, label: _t9-chico[(1) por su antena], label-side: left),
    edge(<ant>, <audio>, "--|>", stroke: col.senal2, label: _t9-chico[(2) radiación directa], label-side: right, bend: -10deg),
    edge(<tx>, <red>, "-|>", label: _t9-chico[alimentación], label-side: left),
    edge(<red>, (2.6, 2.4), <audio>, "-|>", stroke: col.senal3, label: _t9-chico[(3) conducción por la red], label-pos: 0.3, label-side: right),
  )
] <t9-fig-caminos>

Cada mecanismo tiene su física, y de ella sale su remedio. Conviene tenerlos ordenados antes de entrar en detalle:

#figure(kind: table, caption: [Los mecanismos de interferencia, uno a uno.],
{
  set par(justify: false)
  set text(size: 9pt)
  table(
    columns: (auto, 1fr, auto, 1fr),
    align: (left, left, left, left),
    [*Mecanismo*], [*Qué ocurre físicamente*], [*¿Problema de…?*], [*Remedio típico*],
    [Armónicos y espurias], [El transmisor emite energía en múltiplos de su frecuencia o en otras frecuencias ajenas], [emisión], [Filtro paso bajo a la salida; no sobreexcitar],
    [Emisiones fuera de banda], [La modulación excesiva ensancha la emisión más allá de la anchura necesaria], [emisión], [Ajustar la ganancia de micrófono y la excitación],
    [Bloqueo (desensibilización)], [La señal fundamental, aunque limpia, satura la entrada de la víctima], [inmunidad], [Filtro en la entrada de la víctima (paso alto, rechazo)],
    [Intermodulación], [Dos señales fuertes se mezclan en un elemento no lineal y crean frecuencias nuevas], [según dónde ocurra], [Filtrar o atenuar la entrada; reparar uniones oxidadas],
    [Detección en audio], [Una unión semiconductora rectifica la RF y recupera la modulación], [inmunidad], [Ferritas y condensadores de desacoplo en los cables],
  )
},
) <t9-tab-mecanismos>

=== Armónicos: por qué un transmisor los fabrica

#motivacion[Ajustas tu transmisor en 7 MHz y alguien se queja de que le molestas en 21 MHz, donde no estás. No es magia: cualquier deformación de la sinusoide fabrica señales en múltiplos exactos de la frecuencia.]

Una sinusoide pura solo contiene una frecuencia. Pero si pasa por un circuito que no es perfectamente lineal — un amplificador sobreexcitado que recorta los picos, una etapa de clase C, un transistor al límite — sale deformada. Y toda onda periódica deformada es, matemáticamente, la suma de una sinusoide en la frecuencia original $f_0$ (la *fundamental*) y de otras en $2 f_0$, $3 f_0$, $4 f_0$… (los *armónicos*). Cuanto más deformada, más fuertes los armónicos.

#circuito(caption: [Un amplificador que recorta los picos positivos. (a) La sinusoide de salida aplastada por arriba. (b) Su espectro: además de la fundamental $f_0$ aparecen rayas en los múltiplos enteros $2 f_0$, $3 f_0$…, con su nivel en dB por debajo de la fundamental.])[
  #grid(
    columns: (1fr, 1fr),
    align: center + bottom,
    cetz.canvas({
      import cetz.draw: *
      ejes(0, 6.8, -1.3, 1.5, etq-x: $t$, etq-y: $v$)
      onda(x => calc.sin(x * 2), 0, 6.28, stroke: (paint: col.gris, thickness: 0.5pt, dash: "dashed"))
      onda(x => calc.min(calc.sin(x * 2), 0.55), 0, 6.28, n: 300, stroke: 1.2pt + col.senal1)
      content((3.4, -1.75), text(size: 8pt)[(a) forma de onda])
    }),
    cetz.canvas({
      import cetz.draw: *
      let amps = _t9-armonicos(0.55)
      let db = amps.map(a => 20 * calc.log(a / amps.first()))
      let alto(d) = calc.max(0.05, 2.6 * (1 + d / 50))
      ejes(0, 6.8, 0, 3.0, etq-x: $f$, etq-y: [dB])
      for (k, d) in db.enumerate() {
        let x = 1.1 * (k + 1)
        _t9-raya(x, alto(d), etq: if k == 0 { $f_0$ } else { $#str(k + 1) f_0$ })
        content((x, alto(d) + 0.05), anchor: "south", text(size: 6pt, fill: col.gris, str(calc.round(d)).replace("-", "−")))
      }
      content((3.4, -0.75), text(size: 8pt)[(b) espectro])
    }),
  )
] <t9-fig-armonicos>

#porque[
  - La línea discontinua de (a) es la sinusoide que debería salir; la continua, la que sale de verdad cuando la etapa no da más de sí. La diferencia entre ambas no desaparece: se emite, repartida en los armónicos de (b).
  - Los armónicos están *siempre por encima* de la fundamental y en múltiplos *enteros*: nunca en la mitad ni en otros submúltiplos (T9.11). Por eso un filtro que deja pasar lo bajo y corta lo alto los elimina sin tocar la señal útil (T9.12).
  - Un recorte simétrico (arriba y abajo por igual) produce sobre todo armónicos impares (3, 5…); uno asimétrico como el de la figura produce también los pares. Puedes ver cómo un recortador deforma la onda en #falstad("diodelimit.txt").
]

#ejemplo[Emitiendo en 7,05 MHz, los armónicos caen en 14,1 MHz, 21,15 MHz, 28,2 MHz… Emitiendo en 145 MHz, el segundo armónico cae en 290 MHz y el tercero en 435 MHz, en plena banda de servicios ajenos. Con 50 W y un segundo armónico a −50 dBc, en 290 MHz salen $50 dot 10^(-5) = 0,5$ mW: poco, pero suficiente para molestar a un receptor cercano.]

Junto a los armónicos están las demás *emisiones no esenciales* (espurias: restos del oscilador local, mezclas internas, oscilaciones parásitas) y las *emisiones fuera de banda*: las «faldas» que quedan a los lados de la emisión, justo fuera de la anchura de banda necesaria, por culpa del propio proceso de modulación (T9.13). Una SSB con el micrófono demasiado alto o un amplificador lineal sobreexcitado ensanchan la señal y salpican a los canales vecinos. Por eso un amplificador lineal, sobre todo si se excita de más, es una fuente frecuente de interferencias (T9.2).

=== Bloqueo o desensibilización

#analogia[Por la noche, un coche te da las largas. Durante unos segundos no ves nada, ni siquiera lo que está a un lado de la carretera, lejos del foco: tus ojos están deslumbrados. El receptor bloqueado está igual: no recibe la señal que quiere, aunque esté sintonizado lejos de tu frecuencia, porque tu señal le ha saturado la entrada.]

La primera etapa de un receptor (el amplificador de RF, el mezclador) está pensada para señales de microvoltios. Un transmisor de 100 W a unos metros induce en su antena *voltios*: con el campo de un dipolo a 10 m, $E approx sqrt(30 dot 100 dot 1\,64) slash 10 approx 7$ V/m. Esa etapa se satura: sus transistores no pueden seguir a la vez la señal grande y la pequeña, y la ganancia para la pequeña se desploma. Además, el control automático de ganancia reacciona ante la señal fuerte y reduce la ganancia de todo el receptor (T9.4). El resultado: la emisora que el vecino quería ver se debilita o desaparece mientras tú transmites.

Ojo: el bloqueo lo causa la *fundamental*, la señal que tienes derecho a emitir. Un filtro en tu transmisor no lo arregla, porque no puede quitar la señal útil. El remedio está en la víctima: un filtro en su entrada que rechace tu frecuencia antes de que llegue a la primera etapa (T9.17).

=== Intermodulación

La intermodulación merece el detalle matemático. Toda no linealidad añade a su salida términos en $v^2$, $v^3$…; con dos tonos $f_1$ y $f_2$ a la entrada, el término cúbico genera los productos de *tercer orden* $2 f_1 - f_2$ y $2 f_2 - f_1$. Su maldad es doble: caen _pegados_ a las señales que los engendran — dos emisoras en 145,0 y 145,2 MHz fabrican productos en 144,8 y 145,4 MHz, dentro de la banda — y crecen con el cubo de la amplitud: subir 3 dB las señales sube 9 dB la intermodulación.

#circuito(caption: [Intermodulación de dos emisoras de 2 m. Las señales de 145,0 y 145,2 MHz, al mezclarse en un elemento no lineal, crean productos de tercer orden a la misma distancia (200 kHz) a cada lado: 144,8 y 145,4 MHz. Los de quinto orden, más débiles, caen 200 kHz más afuera.])[
  #cetz.canvas({
    import cetz.draw: *
    let x(f) = (f - 144.4) * 6
    ejes(0, 8.4, 0, 3.1, etq-x: [MHz], etq-y: [nivel])
    _t9-raya(x(145.0), 2.6, etq: [145,0])
    _t9-raya(x(145.2), 2.6, etq: [145,2])
    _t9-raya(x(144.8), 1.2, etq: [144,8], color: col.senal2)
    _t9-raya(x(145.4), 1.2, etq: [145,4], color: col.senal2)
    _t9-raya(x(144.6), 0.45, etq: [144,6], color: col.senal4, grosor: 1.2pt)
    _t9-raya(x(145.6), 0.45, etq: [145,6], color: col.senal4, grosor: 1.2pt)
    content((x(145.1), 2.85), text(size: 7.5pt)[$f_1$ y $f_2$])
    content((x(144.8), 1.35), anchor: "south", text(size: 7pt, fill: col.senal2)[$2 f_1 - f_2$])
    content((x(145.4), 1.35), anchor: "south", text(size: 7pt, fill: col.senal2)[$2 f_2 - f_1$])
    content((x(145.6) + 0.15, 0.6), anchor: "west", text(size: 6.5pt, fill: col.senal4)[5.º orden])
  })
] <t9-fig-intermod>

#porque[
  - ¿De dónde sale el $2 f_1 - f_2$? Al elevar al cubo la suma de las dos señales, $(a cos omega_1 t + b cos omega_2 t)^3$, aparece el término $3 a^2 b cos^2 omega_1 t cos omega_2 t$, y las identidades trigonométricas lo convierten en componentes de frecuencias $f_2$, $2 f_1 + f_2$ y $2 f_1 - f_2$. La última es la peligrosa.
  - Los productos de *segundo orden* ($f_1 + f_2 = 290,2$ MHz y $f_2 - f_1 = 0,2$ MHz) caen lejísimos y cualquier filtro los elimina. Los de *tercer orden* caen dentro de la banda, a la misma distancia que separa las dos señales: no hay filtro que los separe de las señales útiles. Por eso el tercer orden es el que importa.
  - Como dependen del cubo de la amplitud, los productos de tercer orden suben 3 dB por cada dB que suben las señales: si las señales suben 3 dB, los productos suben 9 dB (T9.14: hacen falta señales *intensas*).
  - La mezcla más simple, el producto de dos señales, crea ya frecuencias suma y diferencia: puedes verlo en #falstad("cs-multiplier.txt").
]

La no linealidad puede estar en el transmisor (una etapa final sobreexcitada que recibe la RF de otro transmisor cercano), en el receptor (una entrada saturada) o en ningún aparato: una unión oxidada entre dos metales — un canalón, una valla, el propio mástil — se comporta como un diodo, mezcla las señales que la atraviesan y vuelve a radiar los productos. Es el famoso efecto del «tornillo oxidado».

=== Detección en circuitos de audio

#motivacion[Un amplificador de audio no está sintonizado a ninguna frecuencia de radio y no tiene antena. ¿Cómo es posible que reproduzca tu voz?]

#circuito(caption: [Detección de RF en la primera etapa de un amplificador de audio. (a) El cable de entrada hace de antena y lleva la RF hasta la base. (b) La unión base-emisor rectifica la RF modulada, y lo que queda, la envolvente, es audio que el amplificador amplifica como si fuera música.])[
  #grid(
    columns: (1.1fr, 1fr),
    align: center + horizon,
    esquema({
      import zap: *
      import cetz.draw: content
      antenna("ant", (0, 2.4))
      content((-0.1, 4.05), anchor: "south", _t9-chico[cable de entrada:\ hace de antena])
      capacitor("c1", (0, 2.4), (1.8, 2.4), label: $C_1$)
      resistor("r1", (1.8, 5), (1.8, 2.4), label: $R_1$)
      resistor("r2", (1.8, 2.4), (1.8, 0), label: $R_2$)
      node("nb", (1.8, 2.4))
      npn("q1", (3.0, 2.4))
      wire((1.8, 2.4), "q1.b")
      resistor("rc", (3.0, 5), (3.0, 3.4), label: $R_C$)
      wire((3.0, 3.4), "q1.c")
      wire("q1.e", (3.0, 0))
      wire((1.8, 5), (3.0, 5))
      wire((1.8, 0), (3.0, 0))
      wire((3.0, 3.4), (4.2, 3.4))
      node("ns", (4.2, 3.4), fill: false)
      node("nc", (3.0, 3.4))
      content((4.25, 3.75), anchor: "south", _t9-chico[al altavoz])
      vcc("vcc", (2.4, 5))
      ground("g", (2.4, 0))
      content((1.2, -0.75), text(size: 8.5pt)[(a)])
    }),
    cetz.canvas({
      import cetz.draw: *
      let env(t) = 0.55 + 0.4 * calc.sin(t * 1.1)
      // RF modulada en la base
      ejes(0, 5.6, -1.2, 1.3, etq-x: $t$, etq-y: [base])
      onda(t => env(t) * calc.sin(t * 30), 0, 5.4, n: 900, stroke: 0.5pt + col.senal1)
      // tras la unión: solo semiciclos positivos y su envolvente
      set-origin((0, -3.0))
      ejes(0, 5.6, -0.3, 1.3, etq-x: $t$, etq-y: [tras la unión])
      onda(t => calc.max(0, env(t) * calc.sin(t * 30)), 0, 5.4, n: 900, stroke: 0.5pt + col.senal1)
      onda(t => env(t) * 0.64, 0, 5.4, n: 120, stroke: 1.3pt + col.senal2)
      content((5.6, 0.6), anchor: "west", text(size: 7pt, fill: col.senal2)[audio])
      content((2.7, -0.95), text(size: 8.5pt)[(b)])
    }),
  )
] <t9-fig-deteccion>

#porque[
  - Los cables de un equipo de audio (entrada, altavoces, red) miden metros: a las frecuencias de HF y VHF son antenas bastante buenas. La RF que captan llega hasta los transistores.
  - El amplificador no puede amplificar 7 MHz — es demasiado lento —, pero la unión base-emisor de su primer transistor es un *diodo*, y un diodo rectifica: deja pasar los semiciclos positivos y corta los negativos. Es exactamente el detector de un receptor de AM (#ver(<sec-detector>); #falstad("amdetect.txt")).
  - Al rectificar, la RF desaparece promediada y queda su *envolvente*, que en AM o SSB sigue a tu voz. Esa envolvente es audio, cae dentro de la banda del amplificador y sale por los altavoces.
  - Con AM se entiende la voz; con SSB sale una voz deformada e ininteligible; con FM o con la portadora continua de CW, cuya amplitud no varía, se oyen sobre todo chasquidos al empezar y al terminar cada transmisión.
]

#q("T9.1", "b",
  [De los siguientes fenómenos, puede ser causa de generación de interferencias:],
  ([la resonancia de la antena], [la intermodulación], [la selectividad del receptor], [la puesta a tierra de los equipos]),
  sol: [La intermodulación mezcla señales en elementos no lineales y genera productos en frecuencias nuevas: interferencia pura.],
)

#q("T9.2", "a",
  [Las interferencias son más frecuentes si en la estación se emplean:],
  ([amplificadores lineales de potencia], [filtros paso bajo a la salida], [antenas resonantes bien adaptadas], [líneas coaxiales cortas]),
  sol: [Los amplificadores lineales de potencia elevan también armónicos y espurias; sobreexcitados, mucho más.],
)

#q("T9.3", "b",
  [Una desadaptación de impedancias entre el transmisor y la antena puede producir:],
  ([una mejora del rendimiento], [interferencias], [un aumento de la sensibilidad del receptor], [una reducción de los armónicos]),
  sol: [La desadaptación eleva la ROE y provoca onda reflejada y radiación por la línea, que se acopla a los equipos cercanos; de ahí la recomendación de trabajar siempre con la ROE lo más baja posible.],
)

#q("T9.4", "b",
  [Un nivel elevado de intensidad de campo eléctrico en las inmediaciones puede producir en los equipos electrónicos cercanos:],
  ([un aumento de su selectividad], [desensibilización o bloqueo], [una mejora de la relación señal/ruido], [la carga de sus baterías]),
  sol: [Un campo intenso satura las etapas de entrada de los equipos próximos: desensibilización o bloqueo.],
)

== Medidas correctoras <t9-sec-correctoras>

#motivacion[Ya sabes qué sale de la estación y por dónde viaja. Ahora hay que cortar el camino. No existe un remedio universal: un filtro en el transmisor no cura un bloqueo, y una ferrita en el televisor no quita un armónico. Cada remedio ataca un camino concreto, y hay que saber cuál.]

Contra cada camino de acoplo hay un remedio, y son los tres verbos del temario. *Filtrar*: paso bajo a la salida del transmisor (mata armónicos), filtro de línea de desacoplo en la alimentación (impide que la RF entre — o salga — por la red eléctrica), filtros en las entradas de la víctima. *Desacoplar*: condensadores y ferritas que cortan la RF que viaja por cables que no son antenas. *Apantallar*: encerrar el circuito en una caja metálica, eléctricamente estanca y conectada a tierra — una jaula de Faraday que funciona en los dos sentidos, limitando lo que sale del equipo y protegiéndolo de lo que llega. A ello se suman las buenas prácticas de la estación: ROE baja, potencia justa y equipos conformes con las directivas europeas — entre ellas la de compatibilidad electromagnética (EMC) —, conformidad que acredita el marcado *CE*.

El apantallamiento tiene su letra pequeña: una caja solo es jaula de Faraday si sus aberturas son pequeñas frente a la longitud de onda (regla práctica: menores que $lambda slash 20$), y de poco sirve si los cables entran y salen sin filtrar — cada cable es una antena que cruza la muralla. De ahí los pasamuros con condensador y las ferritas de modo común abrazando los cables: dejan pasar la señal diferencial y estrangulan la RF que viaja por el conjunto del cable.

#circuito(caption: [Dónde va cada remedio. En la estación se filtra lo que *sale* (paso bajo, filtro de red); en la víctima se filtra lo que *entra* (paso alto o de rechazo en la antena, ferritas y condensadores en los cables).])[
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (8mm, 8mm),
    node((0, 0), [Transmisor], shape: rect, fill: col.naranja-claro),
    edge("-|>"),
    node((1, 0), align(center)[Filtro\ paso bajo], shape: rect, fill: col.verde-claro),
    edge("-|>"),
    node((2, 0), [Antena], shape: rect),
    edge((0, 0), (0, 1), "-|>"),
    node((0, 1), align(center)[Filtro\ de red], shape: rect, fill: col.verde-claro),
    edge("-|>"),
    node((1, 1), [Red eléctrica], shape: rect, stroke: (dash: "dashed")),
    edge((2, 0), (3, 0), "--|>", stroke: col.senal2),
    node((3, 0), align(center)[Filtro paso alto\ o de rechazo], shape: rect, fill: col.verde-claro),
    edge("-|>"),
    node((4, 0), [Televisor], shape: rect, fill: col.acento-claro),
    edge((1, 1), (3, 1), "-|>"),
    node((3, 1), align(center)[Ferritas y\ condensadores], shape: rect, fill: col.verde-claro),
    edge("-|>"),
    node((4, 1), align(center)[Equipo\ de audio], shape: rect, fill: col.acento-claro),
  )
] <t9-fig-remedios>

=== En la estación: el filtro paso bajo

#motivacion[Los armónicos salen de tu transmisor por el mismo cable que la señal útil. Como están todos *por encima* de la frecuencia de trabajo, basta un filtro que deje pasar lo bajo y frene lo alto, colocado justo antes de la antena (T9.12).]

#circuito(caption: [Filtro paso bajo en $pi$ para la salida de un transmisor de HF (50 Ω, corte hacia 30 MHz). (a) Esquema. (b) Respuesta: deja pasar las bandas de HF y atenúa cada vez más por encima del corte. Los filtros comerciales usan más elementos y cortan con más pendiente.], sim: "butter10lo.txt")[
  #grid(
    columns: (1fr, 1fr),
    align: center + bottom,
    esquema({
      import zap: *
      import cetz.draw: content
      wire((0, 2), (1, 2))
      node("ent", (0, 2), fill: false)
      content((0, 2.35), anchor: "south", _t9-chico[del TX])
      capacitor("c1", (1, 2), (1, 0), label: (content: [106 pF], anchor: "south"))
      inductor("l1", (1, 2), (3.4, 2), label: [0,53 μH])
      capacitor("c2", (3.4, 2), (3.4, 0), label: [106 pF])
      wire((3.4, 2), (4.4, 2))
      node("sal", (4.4, 2), fill: false)
      content((4.4, 2.35), anchor: "south", _t9-chico[a la antena])
      wire((1, 0), (3.4, 0))
      node("n1", (1, 2))
      node("n2", (3.4, 2))
      ground("g", (2.2, 0))
      content((2.2, -0.95), text(size: 8.5pt)[(a)])
    }),
    cetz.canvas({
      import cetz.draw: *
      let xf(f) = f / 25
      let atn(f) = 10 * calc.log(1 + calc.pow(f / 30, 6))
      let yd(d) = 2.7 - d / 16
      rect((xf(1.8), 0), (xf(29.7), 2.75), fill: col.verde-claro, stroke: none)
      content((xf(15.5), 1.6), text(size: 6.5pt, fill: col.verde)[HF])
      ejes(0, 5, -0.2, 3.2, etq-x: [MHz], etq-y: [dB])
      onda(f => yd(calc.min(atn(f * 25), 40)), 0, 4.6, n: 200, stroke: 1.2pt + col.senal1)
      for (f, e) in ((30, [30]), (60, [60]), (90, [90])) {
        line((xf(f), 0), (xf(f), -0.08), stroke: 0.5pt)
        content((xf(f), -0.12), anchor: "north", text(size: 6.5pt, e))
      }
      for d in (0, 20, 40) {
        content((-0.08, yd(d)), anchor: "east", text(size: 6.5pt, str(-d).replace("-", "−")))
        line((0, yd(d)), (0.08, yd(d)), stroke: 0.5pt)
      }
      content((2.5, -0.95), text(size: 8.5pt)[(b)])
    }),
  )
] <t9-fig-pasobajo>

#porque[
  - *La bobina* está en serie: su reactancia $X_L = 2 pi f L$ crece con la frecuencia. A la frecuencia de trabajo apenas estorba; a la de los armónicos es un freno.
  - *Los condensadores* van a masa: su reactancia $X_C = 1 slash (2 pi f C)$ baja con la frecuencia. A la frecuencia de trabajo son casi un circuito abierto; a la de los armónicos son un atajo a masa por el que se van.
  - Juntos forman un *divisor que depende de la frecuencia*: lo bajo pasa entero y lo alto se pierde a masa. Y como los valores están calculados para 50 Ω, el filtro es «invisible» para la señal útil: no estropea la ROE.
  - Sin el filtro, todos los armónicos que fabrica la etapa final llegarían a la antena y se radiarían.
]

#ejemplo[
  Con los valores de la @t9-fig-pasobajo:
  - en 7 MHz, $X_C = 1 slash (2 pi dot 7 dot 10^6 dot 106 dot 10^(-12)) approx 214$ Ω y $X_L = 2 pi dot 7 dot 10^6 dot 0\,53 dot 10^(-6) approx 23$ Ω: frente a 50 Ω, el condensador casi no deriva nada y la bobina casi no frena. La señal pasa;
  - en 84 MHz (el tercer armónico de 28 MHz), $X_C approx 18$ Ω y $X_L approx 280$ Ω: la bobina frena y los condensadores derivan. Este filtro sencillo atenúa ahí unos 27 dB.

  Fíjate en que un filtro de 30 MHz no quita el segundo armónico de 7 MHz (14 MHz), que también está en HF. Por eso los transceptores llevan dentro un filtro paso bajo para cada grupo de bandas, que se conmuta al cambiar de banda; el filtro externo de 30 MHz protege sobre todo la VHF y la UHF (radiodifusión, televisión).
]

=== En la víctima: filtros paso alto y de rechazo

#motivacion[Si tu emisión está limpia y aun así el televisor del vecino se bloquea, el problema es de *inmunidad*: su entrada admite una señal que no le corresponde (T9.17). El filtro tiene que ir en *su* lado, en la entrada de antena del televisor, para rechazar tu frecuencia y dejar pasar la suya.]

#circuito(caption: [Filtro paso alto en la entrada de antena de un televisor. La televisión digital terrestre (470 a 694 MHz) está muy por encima de las bandas de HF y de la de 2 m: un paso alto que corte por debajo de unos 400 MHz deja pasar la televisión y rechaza las señales del aficionado.], sim: "butter10hi.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content
    node("ent", (-0.6, 2), fill: false)
    content((-0.75, 2), anchor: "east", _t9-chico[de la antena\ de TV])
    capacitor("c1", (-0.6, 2), (2, 2), label: $C$)
    inductor("l1", (2, 2), (2, 0), label: $L$)
    capacitor("c2", (2, 2), (4.6, 2), label: $C$)
    node("sal", (4.6, 2), fill: false)
    content((4.75, 2), anchor: "west", _t9-chico[al televisor])
    node("n1", (2, 2))
    ground("g", (2, 0))
  })
] <t9-fig-pasoalto>

#porque[
  Es el filtro paso bajo dado la vuelta: los condensadores, ahora en serie, cierran el paso a lo bajo (su reactancia es grande a baja frecuencia) y lo dejan libre a lo alto; la bobina, ahora a masa, es un atajo para lo bajo (su reactancia es pequeña a baja frecuencia) e invisible para lo alto. Las señales de HF y de 2 m se van a masa o se quedan en los condensadores; la televisión pasa.
]

Cuando la señal que molesta está más cerca de la que se quiere recibir, un paso alto no basta y se usa un *filtro de rechazo de banda* («notch» o trampa): hace justo lo contrario que un paso banda, y en vez de dejar pasar una banda estrecha, la suprime (T9.16).

#circuito(caption: [Trampa de rechazo: un circuito $L C$ serie entre la línea y masa, sintonizado a la frecuencia que molesta (aquí 145 MHz). En su resonancia serie es un cortocircuito y la señal interferente se va a masa; a las demás frecuencias apenas carga la línea.], sim: "notch.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content
    wire((0, 2.4), (4, 2.4))
    node("ent", (0, 2.4), fill: false)
    node("sal", (4, 2.4), fill: false)
    content((0, 2.75), anchor: "south", _t9-chico[de la antena])
    content((4, 2.75), anchor: "south", _t9-chico[al receptor])
    node("n1", (2, 2.4))
    inductor("l1", (2, 2.4), (2, 1.2), label: [$L$ = 0,1 μH])
    capacitor("c1", (2, 1.2), (2, 0), label: [$C$ = 12 pF])
    ground("g", (2, 0))
  })
] <t9-fig-notch>

#porque[
  - En un circuito $L C$ serie, a la frecuencia de resonancia las reactancias de la bobina y del condensador son iguales y opuestas, y se anulan: la rama es casi un cortocircuito (solo queda la pequeña resistencia de pérdidas). La señal de 145 MHz encuentra un atajo a masa y no llega al receptor.
  - Por debajo de la resonancia manda el condensador y por encima la bobina: en ambos casos la rama tiene una reactancia alta y apenas carga la línea. Las demás frecuencias pasan.
  - Es la idea inversa del circuito resonante paralelo, que en resonancia es casi un circuito abierto. Una trampa paralela se pone *en serie* con la línea para bloquear una frecuencia; una trampa serie se pone *en derivación* para cortocircuitarla.
]

#ejemplo[
  Para 145 MHz con $L = 0,1$ μH: $C = 1 slash ((2 pi f)^2 L) = 1 slash ((2 pi dot 145 dot 10^6)^2 dot 10^(-7)) approx 12$ pF. A 600 MHz (un canal de TDT), la rama vale $X_L - X_C approx 377 - 22 = 355$ Ω, mucho más que los 75 Ω de la línea de televisión: la carga apenas se nota y la imagen no sufre.
]

=== Ferritas: frenar la corriente de modo común

#motivacion[El cable de un altavoz lleva el audio por un hilo y lo devuelve por el otro. Pero la RF que el cable capta como antena viaja por *los dos hilos a la vez, en el mismo sentido*, como si fueran uno solo. ¿Se puede frenar esa corriente sin tocar el audio?]

#circuito(caption: [Un cable de dos hilos que atraviesa una ferrita. (a) Modo diferencial: la señal útil va por un hilo y vuelve por el otro; los campos magnéticos de las dos corrientes se anulan dentro de la ferrita, que no actúa. (b) Modo común: la RF captada recorre los dos hilos en el mismo sentido; sus campos se suman, la ferrita se comporta como una bobina y la frena.])[
  #grid(
    columns: (1fr, 1fr),
    align: center + bottom,
    ..for (titulo, sentido) in (([(a) modo diferencial (audio)], -1), ([(b) modo común (RF captada)], 1)) {
      (cetz.canvas({
        import cetz.draw: *
        rect((1.6, -0.15), (3.4, 1.15), radius: 0.12, fill: col.gris.lighten(55%), stroke: 0.6pt + col.gris)
        content((2.5, 1.4), text(size: 7pt, fill: col.gris)[ferrita])
        line((0, 0.7), (5, 0.7), stroke: 1pt)
        line((0, 0.3), (5, 0.3), stroke: 1pt)
        let c1 = col.senal1
        let c2 = if sentido == 1 { col.senal1 } else { col.senal2 }
        line((0.4, 0.85), (1.3, 0.85), mark: (end: ">", fill: c1), stroke: 0.8pt + c1)
        line((3.7, 0.85), (4.6, 0.85), mark: (end: ">", fill: c1), stroke: 0.8pt + c1)
        if sentido == 1 {
          line((0.4, 0.15), (1.3, 0.15), mark: (end: ">", fill: c2), stroke: 0.8pt + c2)
          line((3.7, 0.15), (4.6, 0.15), mark: (end: ">", fill: c2), stroke: 0.8pt + c2)
        } else {
          line((1.3, 0.15), (0.4, 0.15), mark: (end: ">", fill: c2), stroke: 0.8pt + c2)
          line((4.6, 0.15), (3.7, 0.15), mark: (end: ">", fill: c2), stroke: 0.8pt + c2)
        }
        content((2.5, -0.5), text(size: 8pt, titulo))
      }),)
    }
  )
] <t9-fig-ferrita>

#porque[
  - Una ferrita es un material magnético que, alrededor de un conductor, multiplica su inductancia y además disipa energía en RF. Pero solo «ve» la corriente *neta* que la atraviesa.
  - En modo diferencial (a), por un hilo va $I$ y por el otro vuelve $I$: la corriente neta es cero, el campo magnético neto también, y la ferrita es invisible para el audio (o para la señal que viaja por dentro de un coaxial).
  - En modo común (b), los dos hilos llevan la RF en el mismo sentido: la corriente neta no es cero y la ferrita se comporta como una bobina en serie con todo el cable. Le añade una impedancia que frena la RF antes de que llegue al equipo (T9.15).
  - Dar varias vueltas del cable a un toroide de ferrita multiplica esa impedancia, aproximadamente con el cuadrado del número de vueltas, hasta que la capacidad entre espiras lo limita. Con un material adecuado para la frecuencia se consiguen fácilmente cientos o miles de ohmios en HF.
]

=== Condensadores de desacoplo

#circuito(caption: [Entrada de un amplificador de audio protegida contra la RF: la ferrita frena la corriente de modo común del cable, y la red $R C$ forma un paso bajo que deja pasar el audio y deriva la RF a masa antes de que llegue a la unión base-emisor.], sim: "filt-lopass.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content
    node("ent", (0, 2), fill: false)
    content((-0.15, 2), anchor: "east", _t9-chico[cable\ de entrada])
    inductor("fe", (0, 2), (1.8, 2), label: _t9-chico[ferrita])
    resistor("r", (1.8, 2), (3.8, 2), label: [$R$ = 1 kΩ])
    capacitor("c", (3.8, 2), (3.8, 0), label: [$C$ = 1 nF])
    ground("g", (3.8, 0))
    node("n", (3.8, 2))
    wire((3.8, 2), (5.2, 2))
    node("sal", (5.2, 2), fill: false)
    content((5.35, 2), anchor: "west", _t9-chico[a la base del\ primer transistor])
  })
] <t9-fig-desacoplo>

#porque[
  - *El condensador* es un camino corto a masa para la RF y un circuito abierto para el audio, porque su reactancia baja con la frecuencia. Se pone lo más cerca posible del transistor o del conector, para que la RF no tenga tiempo de llegar a la unión.
  - *La resistencia* (o la ferrita) en serie impide que el condensador cortocircuite directamente el cable: juntos forman un divisor que solo deja pasar lo bajo, el filtro $R C$ de #ver(<sec-filtros-rc>).
  - En los equipos sensibles se usan *pasamuros*: un condensador construido alrededor del cable que atraviesa la pared de la caja metálica, de modo que la RF se va a masa justo en la «puerta».
]

#ejemplo[Con $C = 1$ nF: en 7 MHz, $X_C = 1 slash (2 pi dot 7 dot 10^6 dot 10^(-9)) approx 23$ Ω, casi un cortocircuito frente a 1 kΩ, y la RF que llega a la base se reduce unas 40 veces (más de 30 dB); en 3 kHz, $X_C approx 53$ kΩ, y el audio pasa casi sin pérdida.]

=== El filtro de red

#circuito(caption: [Filtro de red (filtro de línea de desacoplo). La bobina doble de modo común frena la RF que viaja por los dos conductores en el mismo sentido; los condensadores $C_X$, entre fase y neutro, y $C_Y$, de cada conductor a tierra, derivan la que queda. Funciona en los dos sentidos: ni la RF del transceptor sale a la red, ni la de la red entra en el equipo.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    // fase (arriba) y neutro (abajo)
    node("f1", (0, 3.2), fill: false)
    node("n1", (0, 0.4), fill: false)
    content((-0.15, 3.2), anchor: "east", _t9-chico[fase])
    content((-0.15, 0.4), anchor: "east", _t9-chico[neutro])
    content((-0.3, 1.8), anchor: "east", _t9-chico[red])
    wire((0, 3.2), (1.7, 3.2))
    wire((0, 0.4), (1.7, 0.4))
    capacitor("cx1", (0.8, 3.2), (0.8, 0.4), label: $C_X$)
    node("a1", (0.8, 3.2))
    node("a2", (0.8, 0.4))
    inductor("l1", (1.7, 3.2), (3.5, 3.2))
    inductor("l2", (1.7, 0.4), (3.5, 0.4))
    line((1.9, 1.7), (3.3, 1.7), stroke: 0.8pt)
    line((1.9, 1.9), (3.3, 1.9), stroke: 0.8pt)
    content((2.6, 2.15), anchor: "south", _t9-chico[núcleo común])
    wire((3.5, 3.2), (7.6, 3.2))
    wire((3.5, 0.4), (7.6, 0.4))
    capacitor("cx2", (4.2, 3.2), (4.2, 0.4), label: $C_X$)
    node("b1", (4.2, 3.2))
    node("b2", (4.2, 0.4))
    capacitor("cy1", (5.5, 3.2), (5.5, 1.8), label: $C_Y$)
    capacitor("cy2", (5.5, 0.4), (5.5, 1.8), label: (content: $C_Y$, anchor: "south"))
    node("c1", (5.5, 3.2))
    node("c2", (5.5, 0.4))
    wire((5.5, 1.8), (6.8, 1.8))
    earth("t", (6.8, 1.8))
    content((7.05, 1.45), anchor: "west", _t9-chico[tierra])
    node("f2", (7.6, 3.2), fill: false)
    node("n2", (7.6, 0.4), fill: false)
    content((7.8, 1.8), anchor: "west", _t9-chico[al equipo])
  })
] <t9-fig-red>

#porque[
  - La RF que se cuela por la red viaja casi siempre en *modo común*: por la fase y por el neutro a la vez. Las dos bobinas, devanadas en el mismo núcleo, son para ella una impedancia alta (sus campos se suman), mientras que los 50 Hz, que van por la fase y vuelven por el neutro, no notan nada: es la misma idea que la ferrita.
  - Los condensadores, de capacidad pequeña, son un atajo para la RF y casi un circuito abierto para los 50 Hz.
  - Por eso el filtro de red impide que el transceptor introduzca RF en la instalación eléctrica (T9.7), y también protege al equipo del ruido que llega por ella.
]

=== Apantallar: la jaula de Faraday y su letra pequeña

#motivacion[Un circuito que funciona como oscilador o como amplificador de RF radia; un circuito sensible capta lo que le llega. Si se encierra en metal, ni sale ni entra nada. ¿Por qué funciona el metal, y por qué no vale cualquier caja?]

Cuando un campo de RF llega a una pared metálica, induce en ella corrientes que crean un campo opuesto: el campo se refleja y lo poco que penetra se pierde en el metal. Por eso la caja de un equipo es una jaula de Faraday en los dos sentidos: limita lo que sale y protege de lo que llega (T9.5). Para que funcione hacen falta tres condiciones (T9.6):
- *Metálica*: el plástico, la madera o el cristal son aislantes; los atraviesa el campo como si no estuvieran.
- *Eléctricamente estanca*: las tapas deben hacer buen contacto en todo su perímetro y las aberturas (rejillas, ranuras) deben ser pequeñas frente a la longitud de onda. Una ranura larga es, para la RF, una antena de ranura.
- *Conectada a tierra*: la caja da a las corrientes inducidas un camino de retorno y queda a un potencial fijo.

#align(center, block(breakable: false, table(
  columns: 5,
  align: center,
  [*Frecuencia*], [7 MHz], [145 MHz], [435 MHz], [1296 MHz],
  [$lambda$], [43 m], [2,1 m], [69 cm], [23 cm],
  [*Abertura máxima* ($lambda slash 20$)], [2 m], [10 cm], [3,4 cm], [1,2 cm],
)))

En HF casi cualquier caja metálica cerrada apantalla bien; en UHF, una rejilla de ventilación de unos centímetros ya deja escapar la señal. Y por la misma razón la *fibra óptica* es el medio de transmisión más inmune: lleva luz por un dieléctrico, sin metal, y los campos radiados no se acoplan a ella (T9.9). El coaxial, con su malla, es mucho mejor que el cable de pares paralelos, pero su malla sigue siendo un conductor que puede llevar corriente de modo común.

=== Tierra de RF y buenas prácticas

#motivacion[Muchas interferencias no las causa un aparato estropeado, sino una estación mal montada: una antena desadaptada, más potencia de la necesaria o una toma de tierra que no existe. Son los remedios más baratos.]

- *Una buena tierra* (T9.18). Si la RF no encuentra un camino corto a tierra, vuelve por donde puede — los chasis, el cable del micrófono, los cables de alimentación — y desde ahí se acopla a todo lo que hay cerca. Un conductor corto y grueso desde los chasis a la toma de tierra le da ese camino. Cuidado: si el cable de tierra mide un cuarto de onda (unos 5 m en la banda de 20 m), en el extremo de la estación presenta una impedancia altísima y no sirve de nada en esa banda.
- *ROE baja* (T9.3, T9.22). Con la antena desadaptada, parte de la energía rebota por la línea, sube la tensión en el coaxial y la malla lleva corriente de modo común: el propio cable radia dentro de casa. Con la antena bien adaptada, la potencia se va por donde debe.
- *La mínima potencia necesaria* (T9.10, T9.19). El campo crece con la raíz de la potencia; cada armónico y cada espuria crecen con ella. Bajar de 100 a 10 W reduce el campo a menos de la tercera parte ($sqrt(10) approx 3,2$) y todas las emisiones no deseadas en 10 dB. Además, es una obligación reglamentaria.
- *Equipos con marcado CE* (T9.8). Que un equipo declare conformidad con la directiva EMC significa que cumple las directivas de la Unión Europea sobre compatibilidad electromagnética (T9.21): no molesta por encima de ciertos límites y soporta cierto nivel de campo sin fallar.

#truco(titulo: [La prueba de la carga artificial])[Ante una queja, lo primero es comprobar tu propia estación (T9.20). Conecta el transmisor a la carga artificial y transmite. Si la interferencia *desaparece*, el camino era la radiación de tu antena: revisa armónicos, ROE y potencia, y luego la inmunidad del equipo afectado. Si *sigue*, aunque no radias, el camino es la conducción por la red o por los cables: filtro de red y ferritas.]

#figure(kind: table, caption: [Del síntoma al remedio.],
{
  set par(justify: false)
  set text(size: 9pt)
  table(
    columns: (1fr, 1fr, 1fr),
    align: left,
    [*Síntoma*], [*Causa probable*], [*Remedio*],
    [Te oyen en otra banda, en múltiplos de tu frecuencia], [Armónicos del transmisor], [Filtro paso bajo a la salida; no sobreexcitar],
    [Te oyen en canales vecinos al tuyo], [Emisión fuera de banda (sobremodulación)], [Bajar la ganancia del micrófono y la excitación],
    [El televisor pierde la imagen solo mientras transmites], [Bloqueo de su entrada], [Filtro paso alto o de rechazo en su entrada de antena],
    [Tu voz sale por los altavoces del vecino], [Detección en el amplificador de audio], [Ferritas y condensadores en sus cables],
    [Aparecen señales donde nadie transmite, cerca de dos emisoras fuertes], [Intermodulación], [Atenuar la entrada; revisar uniones oxidadas],
    [La interferencia sigue con la carga artificial], [Conducción por la red], [Filtro de red; ferritas en la alimentación],
  )
},
) <t9-tab-sintomas>

#q("T9.5", "a",
  [Los equipos radioeléctricos se montan en cajas metálicas para:],
  ([limitar las radiaciones indeseadas], [mejorar la refrigeración], [aumentar la potencia de salida], [reducir su peso]),
  sol: [La caja metálica es una jaula de Faraday en ambos sentidos: limita lo que sale y protege de lo que llega.],
)

#q("T9.6", "d",
  [Para que un campo electromagnético externo no interfiera a un circuito electrónico, este se puede apantallar en una caja:],
  ([de plástico rígido], [de madera tratada], [de cristal templado], [metálica, eléctricamente estanca y conectada a tierra]),
  sol: [Apantallamiento eficaz: caja metálica, eléctricamente estanca y conectada a tierra.],
)

#q("T9.7", "c",
  [Para evitar que un transceptor introduzca señales de radiofrecuencia en la red de suministro eléctrico se emplea:],
  ([un transformador elevador], [un diodo zéner], [un filtro de línea de desacoplo], [un atenuador de antena]),
  sol: [El filtro de línea bloquea la RF que el equipo inyectaría en la red eléctrica.],
)

#q("T9.8", "c",
  [Si un equipo declara su conformidad con la directiva «EMC», significa que:],
  ([es de máxima categoría comercial], [solo puede usarse en Europa continental], [cumple las directivas de la Unión Europea sobre compatibilidad electromagnética], [está exento de inspección técnica]),
  sol: [El marcado EMC acredita conformidad con las directivas europeas de compatibilidad electromagnética.],
)

#q("T9.9", "c",
  [El medio de transmisión más inmune a las interferencias radiadas es:],
  ([el cable de pares paralelos], [el cable coaxial], [la fibra óptica], [el hilo de cobre desnudo]),
  sol: [La fibra óptica transmite luz por un dieléctrico: los campos radiados no se acoplan a ella.],
)

#q("T9.10", "c",
  [Si aumentamos la potencia de transmisión, el riesgo de producir interferencias es:],
  ([menor], [el mismo], [mayor], [nulo si la antena es resonante]),
  sol: [A más potencia, más intensidad de campo en el entorno y más nivel en cada espuria y armónico: el riesgo de interferir crece.],
)

#q("T9.11", "a",
  [Los armónicos de una emisión son señales cuya frecuencia es:],
  ([un múltiplo entero de la frecuencia fundamental], [un submúltiplo de la frecuencia fundamental], [la mitad de la frecuencia fundamental], [independiente de la frecuencia fundamental]),
  sol: [Emitiendo en 7 MHz, el segundo armónico cae en 14 MHz, el tercero en 21 y el cuarto en 28 — y todos ellos, casualmente, en bandas de aficionado o muy cerca de servicios ajenos. Los produce cualquier no linealidad, y por eso el filtro de salida es obligado.],
)

#q("T9.12", "c",
  [En la salida de un transmisor, justo antes de la toma de antena, debería encontrarse siempre:],
  ([un condensador de desacoplo a masa], [un transformador elevador], [un filtro de paso bajo], [un atenuador resistivo]),
  sol: [Los armónicos están siempre _por encima_ de la frecuencia de trabajo, así que un filtro que deje pasar lo bajo y corte lo alto los elimina sin tocar la señal útil. Un atenuador rebajaría también la potencia deseada.],
)

#q("T9.13", "b",
  [Las emisiones fuera de banda de un transmisor están constituidas por:],
  ([las señales que el receptor capta fuera de la banda de aficionados], [las emisiones inmediatamente exteriores a la anchura de banda necesaria, resultantes del proceso de modulación], [exclusivamente los armónicos de la frecuencia fundamental], [las emisiones realizadas con potencia superior a la autorizada]),
  sol: [Son las «faldas» que quedan a los lados de la emisión por culpa del propio proceso de modulación. Junto con las emisiones no esenciales (espurias, entre ellas los armónicos) forman las emisiones no deseadas.],
)

#q("T9.14", "d",
  [La intermodulación se produce cuando:],
  ([una sola señal muy débil satura el receptor], [la antena está perfectamente adaptada a la línea], [se emplea una potencia de transmisión muy reducida], [dos o más señales intensas se mezclan en una etapa no lineal]),
  sol: [De esa mezcla salen sumas y diferencias que no estaban en ninguna de las dos señales originales y que pueden caer justo encima de la frecuencia que escuchamos. Ocurre tanto en la etapa final de un transmisor sobreexcitado como en la entrada de un receptor saturado.],
)

#q("T9.15", "a",
  [Para evitar que la radiofrecuencia de una estación se cuele en un amplificador de audio cercano, resulta eficaz:],
  ([colocar núcleos de ferrita y condensadores de desacoplo en sus cables], [aumentar el volumen del amplificador], [alargar los cables de altavoz], [desconectar la toma de tierra del amplificador]),
  sol: [Los cables de altavoz y de red hacen de antena y llevan la RF hasta donde se detecta y se oye. La ferrita añade impedancia a esa corriente parásita y el condensador la deriva a masa, sin afectar al audio. Alargar los cables o quitar la tierra empeora las cosas.],
)

#q("T9.16", "c",
  [Un filtro de rechazo de banda (filtro «notch») se emplea para:],
  ([amplificar selectivamente la señal deseada], [dejar pasar por igual todas las frecuencias], [eliminar una frecuencia o una banda estrecha concreta que interfiere], [ensanchar la banda de paso del receptor]),
  sol: [Hace justo lo contrario que el paso banda: en lugar de dejar pasar una banda, la suprime. Es lo que permite quitar de en medio una portadora molesta o un tono concreto sin tocar el resto de la señal.],
)

#q("T9.17", "b",
  [Una interferencia a la recepción de televisión (TVI) provocada por una señal fuerte fuera de su banda se combate eficazmente:],
  ([aumentando la potencia del transmisor de aficionado], [instalando un filtro de rechazo en la entrada de antena del televisor], [cambiando la polarización de la antena del televisor], [sustituyendo el cable de red del televisor]),
  sol: [Si la estación cumple con sus emisiones no deseadas, el problema es de _inmunidad_ del televisor: su entrada admite una señal que no le corresponde. El remedio está en el lado del receptor afectado, con un filtro que rechace la banda del aficionado.],
)

#q("T9.18", "d",
  [Una buena instalación de tierra en la estación contribuye a:],
  ([aumentar la ganancia de la antena], [elevar la potencia de salida del transmisor], [mejorar la selectividad del receptor], [reducir la radiofrecuencia presente en los chasis y las interferencias asociadas]),
  sol: [Una tierra deficiente deja que la RF vuelva por donde puede —los chasis, los cables de alimentación, el micrófono— y desde ahí se acople a todo lo que haya cerca. La tierra le da un camino corto y directo. De paso, es la misma tierra que protege al operador (tema T10).],
)

#q("T9.19", "b",
  [Para reducir al mínimo el riesgo de causar interferencias, un radioaficionado debe:],
  ([emplear siempre la potencia máxima autorizada], [utilizar la mínima potencia necesaria para el enlace], [transmitir preferentemente en horas nocturnas], [prescindir del filtro de salida del transmisor]),
  sol: [Es además una obligación reglamentaria, no solo una buena práctica: se debe emplear la potencia mínima necesaria para mantener la comunicación. Menos potencia significa menos campo en el entorno y menos nivel en cada emisión no deseada.],
)

#q("T9.20", "c",
  [Ante una queja fundada de interferencias procedente de un vecino, lo primero que debe hacer el radioaficionado es:],
  ([negar cualquier responsabilidad, si su estación está autorizada], [aumentar la potencia para comprobar el efecto], [comprobar que su estación no produce emisiones no deseadas y colaborar en localizar la causa], [cambiar de banda sin más comprobaciones]),
  sol: [Estar autorizado no exime de comprobar la propia instalación. Y aunque el problema resulte ser de inmunidad del equipo afectado, la colaboración es lo que resuelve el conflicto — y lo que la responsabilidad social del radioaficionado (tema R7) espera de él.],
)

#q("T9.21", "b",
  [Se denomina compatibilidad electromagnética a la capacidad de un equipo para:],
  ([funcionar con cualquier tensión de alimentación], [funcionar sin producir perturbaciones a su entorno y sin verse afectado por él], [emitir en varias bandas simultáneamente], [soportar descargas atmosféricas directas]),
  sol: [La definición tiene dos caras y el examen suele dar solo una: _no molestar_ y _no ser molestado_. Un equipo compatible convive con su entorno electromagnético en ambos sentidos.],
)

#q("T9.22", "d",
  [Además de emplear la potencia mínima necesaria, para reducir el riesgo de interferencias conviene que la instalación tenga:],
  ([una ROE lo más alta posible], [la antena lo más cerca posible de la vivienda], [los cables de alimentación lo más largos posible], [una ROE baja, con la antena bien adaptada]),
  sol: [Una ROE alta significa energía rebotando por la línea, tensiones elevadas en el coaxial y radiación por el propio cable, que actúa de antena justo dentro de casa. Con la antena bien adaptada, la potencia se va por donde debe.],
)
