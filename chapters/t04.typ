#import "/lib/template.typ": *
#import "/lib/falstad-custom.typ": fc
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Ayudantes locales de este archivo (prefijo _t4-)
// ---------------------------------------------------------------------
// Texto de un bloque y etiqueta de frecuencia sobre una flecha
#let _t4-t(t) = text(font: fuente-sans, size: 7.5pt, t)
#let _t4-f(t) = text(font: fuente-sans, size: 6.5pt, fill: col.naranja, t)
#let _t4-e(t, color: col.gris) = text(font: fuente-sans, size: 7pt, fill: color, t)
// Diagrama de bloques con el estilo del libro
#let _t4-diagrama(..args) = diagram(
  node-stroke: 0.7pt + col.acento,
  node-fill: col.acento-claro,
  node-corner-radius: 2pt,
  edge-stroke: 0.6pt,
  spacing: (8mm, 8mm),
  ..args,
)
// Icono de antena y de altavoz para los diagramas de bloques
#let _t4-ant = box(cetz.canvas(length: 1em, {
  import cetz.draw: *
  line((0, 0), (0, 2.1), stroke: 0.7pt)
  line((-0.5, 2.2), (0, 1.5), (0.5, 2.2), stroke: 0.7pt)
}))
#let _t4-alt = box(cetz.canvas(length: 1em, {
  import cetz.draw: *
  rect((0, -0.35), (0.35, 0.35), stroke: 0.7pt)
  line((0.35, 0.35), (0.9, 0.8), (0.9, -0.8), (0.35, -0.35), stroke: 0.7pt)
}))
// Bloque «?» de las preguntas sobre esquemas
#let _t4-preg(pos, ..args) = node(
  pos,
  text(font: fuente-sans, size: 11pt, weight: "bold", fill: col.naranja)[?],
  shape: rect,
  stroke: (paint: col.naranja, thickness: 0.7pt, dash: "dashed"),
  fill: col.naranja-claro,
  width: 13mm,
  height: 7mm,
  ..args,
)
// Mezclador dibujado como círculo con aspa
#let _t4-mez(pos, ..args) = node(pos, text(size: 13pt)[×], shape: circle, radius: 3mm, fill: white, ..args)
// Respuesta (en dB) de un circuito sintonizado simple de factor Q centrado en f0
#let _t4-db-lc(f, f0, q) = -10 * calc.log(1 + calc.pow(q * (f / f0 - f0 / f), 2))

#tema("T4", "Receptores", alcance: [Receptores superheterodinos de simple y doble conversión y de conversión directa · diagramas de bloques (CW, AM, SSB, FM) · etapas: amplificador de RF, osciladores, mezclador, FI, limitador, detector, BFO, CAG, silenciador, amplificador de baja frecuencia · características: selectividad (también de canal adyacente), sensibilidad, estabilidad, figura de ruido, frecuencia imagen, desensibilización y bloqueo, intermodulación, modulación cruzada.])

// =====================================================================
== Arquitectura del receptor <t4-sec-arquitectura>

#motivacion(titulo: [un microvoltio entre gigantes])[
  Un dipolo de 40 metros entrega al receptor, a la vez, la estación lejana que buscas —quizá medio microvoltio— y emisoras de radiodifusión, a pocas decenas de kilohercios, que llegan con decenas de milivoltios: cien mil veces más tensión. El receptor tiene que hacer dos cosas a la vez: *amplificar* la señal débil unos dos millones de veces (más de 120 dB), hasta mover un altavoz, y *separarla* de las fuertes sin que se cuelen. Todo este tema son variaciones sobre esos dos verbos.
]

El problema del receptor es amplificar quizá un microvoltio hasta nivel de altavoz y, a la vez, separarlo de señales vecinas millones de veces más fuertes. Hacerlo con filtros sintonizables a cualquier frecuencia es inviable; la solución de Armstrong, el *superheterodino*, es trasladar _la señal_ a una frecuencia fija — la *frecuencia intermedia* (FI) — donde los filtros y amplificadores pueden ser óptimos de una vez para siempre. El traslado lo hace el *mezclador* con el *oscilador local* (OL): de los productos $f_"OL" plus.minus f_s$ se filtra el que cae en la FI,
$ f_"FI" = |f_"OL" - f_s|. $
Sintonizar es, simplemente, mover el oscilador local (@t4-fig-super).

=== Por qué no basta con sintonizar la RF

La idea obvia, y la que se usó en los primeros receptores, es la del receptor de *radiofrecuencia sintonizada* (TRF): varios amplificadores de RF en cadena, cada uno con su circuito resonante LC, y el detector al final (@t4-fig-trf). Cada circuito LC deja pasar su frecuencia de resonancia y atenúa las demás (#ver(<sec-resonancia>)); con tres en cadena, la selectividad se multiplica. Pero tiene tres problemas que no tienen arreglo:

+ *Sintonía sincronizada.* Para cambiar de emisora hay que mover los tres condensadores variables a la vez, montados en un mismo eje, y conseguir que los tres circuitos resuenen en la misma frecuencia en todo el recorrido. Con cada etapa añadida, peor.
+ *La anchura de banda cambia con la frecuencia.* Un circuito resonante deja pasar una banda $B = f_0 slash Q$. Con $Q = 100$, a 3,5 MHz son 35 kHz y a 28 MHz, 280 kHz. Ninguna de las dos cifras sirve para separar canales de SSB de menos de 3 kHz.
+ *Inestabilidad.* Mucha ganancia a una misma frecuencia en etapas vecinas acaba realimentándose: la cadena oscila.

#circuito(sim: "amdetect.txt", caption: [Receptor de radiofrecuencia sintonizada (TRF). Toda la selectividad la ponen circuitos LC que se mueven a la vez con un mismo mando; su anchura de banda cambia con la frecuencia sintonizada.])[
  #_t4-diagrama(
    spacing: (6mm, 7mm),
    node((0, 0), _t4-ant, stroke: none, fill: none),
    node((1, 0), _t4-t[ampl. RF\ sintonizado], shape: rect),
    node((2, 0), _t4-t[ampl. RF\ sintonizado], shape: rect),
    node((3, 0), _t4-t[ampl. RF\ sintonizado], shape: rect),
    node((4, 0), _t4-t[detector], shape: rect),
    node((5, 0), _t4-t[ampl.\ BF], shape: rect),
    node((6, 0), _t4-alt, stroke: none, fill: none),
    edge((0, 0), (1, 0), "-|>"),
    edge((1, 0), (2, 0), "-|>"),
    edge((2, 0), (3, 0), "-|>"),
    edge((3, 0), (4, 0), "-|>"),
    edge((4, 0), (5, 0), "-|>"),
    edge((5, 0), (6, 0), "-|>"),
    edge((1, 0), (1, 0.75), "--", stroke: 0.6pt + col.naranja),
    edge((2, 0), (2, 0.75), "--", stroke: 0.6pt + col.naranja),
    edge((3, 0), (3, 0.75), "--", stroke: 0.6pt + col.naranja),
    edge((1, 0.75), (3, 0.75), "--", stroke: 0.6pt + col.naranja, _t4-e(color: col.naranja)[un solo eje mueve los tres condensadores variables], label-side: right),
  )
] <t4-fig-trf>

La idea de Armstrong (1918) le da la vuelta al problema: *en lugar de mover los filtros, mueve la señal* hasta una frecuencia que no cambia nunca. Entonces el filtro de FI se diseña una sola vez, con la anchura exacta que pide el modo (unos 2,4 kHz para SSB, 500 Hz para CW); la ganancia se reparte entre frecuencias distintas —RF, FI y audio—, de modo que una etapa no se realimenta con la siguiente; y para sintonizar basta con mover _un_ oscilador.

#analogia[
  Piensa en un taller de pintura. Llevar las pistolas a cada rincón de la fábrica, coche por coche, es el receptor TRF. El superheterodino pone los coches en una cinta que los lleva siempre a la misma cabina: la cabina se diseña perfecta una vez, y lo único que cambia es qué coche entra. El oscilador local es el que decide qué coche sube a la cinta.
]

=== El superheterodino, bloque a bloque

#circuito(sim: fc.at("mezclador"), caption: [Diagrama de bloques del receptor superheterodino. El mezclador traslada la señal sintonizada a la FI fija, donde se filtra y amplifica; el CAG realimenta la ganancia para mantener la salida constante, y el BFO reinserta la portadora cuando se demodula SSB o CW.])[
  #_t4-diagrama(
    spacing: (7mm, 9mm),
    node((0, 0), _t4-ant, stroke: none, fill: none),
    node((1, 0), _t4-t[ampl.\ RF], shape: rect),
    node((2, 0), _t4-t[mezclador], shape: rect),
    node((3, 0), _t4-t[ampl.\ FI], shape: rect),
    node((4, 0), _t4-t[demodulador], shape: rect),
    node((5, 0), _t4-t[ampl.\ BF], shape: rect),
    node((6, 0), _t4-alt, stroke: none, fill: none),
    node((2, 1), _t4-t[oscilador\ local], shape: rect),
    node((4, 1), _t4-t[BFO\ (SSB/CW)], shape: rect, stroke: (paint: col.acento, thickness: 0.7pt, dash: "dashed")),
    edge((0, 0), (1, 0), "-|>"),
    edge((1, 0), (2, 0), "-|>"),
    edge((2, 0), (3, 0), "-|>"),
    edge((3, 0), (4, 0), "-|>"),
    edge((4, 0), (5, 0), "-|>"),
    edge((5, 0), (6, 0), "-|>"),
    edge((2, 1), (2, 0), "-|>"),
    edge((4, 1), (4, 0), "-|>", dash: "dashed"),
    edge((4, 0), (4, -0.8), (1, -0.8), (1, 0), "-|>", stroke: 0.6pt + col.verde, dash: "dashed"),
    edge((3, -0.8), (3, 0), "-|>", stroke: 0.6pt + col.verde, dash: "dashed"),
    node((2.5, -1.05), _t4-e(color: col.verde)[CAG], stroke: none, fill: none),
  )
] <t4-fig-super>

#porque[
  Sigue la señal de izquierda a derecha y pregunta, en cada bloque, qué pasaría si faltara:
  - *Amplificador de RF.* Da la primera ganancia con el menor ruido posible, y su filtro de entrada (el *preselector*) elimina la frecuencia imagen y las señales fuertes lejanas antes de que lleguen al mezclador. Sin él, el receptor es más sordo y la imagen entra.
  - *Mezclador y oscilador local.* El mezclador multiplica las dos señales y a su salida aparecen la suma y la diferencia, $f_"OL" + f_s$ y $|f_"OL" - f_s|$ (#ver(<sec-mezclador>)). Moviendo el oscilador, cualquier $f_s$ cae en la FI. Sin oscilador no hay conversión y no se oye nada.
  - *Amplificador de FI.* Aquí están los filtros que fijan la selectividad y casi toda la ganancia, a una frecuencia fija. Sin él, no hay forma de separar estaciones vecinas.
  - *Demodulador.* Recupera la información: detector de envolvente en AM, limitador y discriminador en FM, detector de producto con BFO en SSB y CW (#ver(<sec-detector>)).
  - *Amplificador de BF.* Da la potencia de audio para el altavoz.
  - *CAG (línea verde).* Mide el nivel detectado y reduce la ganancia de RF y FI cuando la señal es fuerte.
  - *BFO (caja discontinua).* Solo trabaja en SSB y CW: repone localmente la portadora que el transmisor no envió.
  Cómo encajan estos bloques con los de un transmisor, en un mismo equipo: #ver(<sec-radio-entera>).
]

=== Siguiendo la señal: 14,200 MHz con una FI de 9 MHz

La mejor manera de entender el superheterodino es apuntar la frecuencia en cada flecha (@t4-fig-14200).

#circuito(caption: [La señal de 14,200 MHz recorre un superheterodino de FI 9 MHz con el oscilador por debajo (frecuencias en MHz, salvo indicación). El mezclador entrega suma y diferencia; el filtro de FI se queda solo con la diferencia, 9,000 MHz.])[
  #_t4-diagrama(
    spacing: (11mm, 9mm),
    node((0, 0), _t4-ant, stroke: none, fill: none),
    node((1, 0), _t4-t[ampl.\ RF], shape: rect),
    node((2, 0), _t4-t[mezclador], shape: rect),
    node((2, 1), _t4-t[oscilador local\ *5,200 MHz*], shape: rect),
    node((3, 0), _t4-t[filtro\ FI 9 MHz], shape: rect),
    node((4, 0), _t4-t[ampl.\ FI], shape: rect),
    node((5, 0), _t4-t[detector de\ producto], shape: rect),
    node((5, 1), _t4-t[BFO\ *9,000 MHz*], shape: rect),
    node((6, 0), _t4-t[ampl.\ BF], shape: rect),
    edge((0, 0), (1, 0), "-|>", _t4-f[14,200], label-side: left),
    edge((1, 0), (2, 0), "-|>", _t4-f[14,200], label-side: left),
    edge((2, 0), (3, 0), "-|>", _t4-f[9,000\ 19,400], label-side: left),
    edge((3, 0), (4, 0), "-|>", _t4-f[9,000], label-side: left),
    edge((4, 0), (5, 0), "-|>", _t4-f[9,000], label-side: left),
    edge((5, 0), (6, 0), "-|>", _t4-f[0,3–3 kHz], label-side: left),
    edge((2, 1), (2, 0), "-|>"),
    edge((5, 1), (5, 0), "-|>"),
  )
] <t4-fig-14200>

#ejemplo(titulo: [una estación de SSB en 14,200 MHz])[
  El receptor tiene FI de 9 MHz y el oscilador local va _por debajo_ de la señal (es el esquema de la pregunta T4.20).
  + Oscilador local: $f_"OL" = f_s - f_"FI" = 14,200 - 9,000 = 5,200$ MHz.
  + A la salida del mezclador hay diferencia, $14,200 - 5,200 = 9,000$ MHz, y suma, $14,200 + 5,200 = 19,400$ MHz (y restos de las dos entradas).
  + El filtro de FI, de 9 MHz y 2,4 kHz de ancho, deja pasar 9,000 MHz y rechaza todo lo demás. Una estación en 14,210 MHz cae en 9,010 MHz: 10 kHz fuera del filtro, no se oye.
  + El detector de producto mezcla la FI con el BFO en 9,000 MHz —el lugar de la portadora suprimida— y entrega la voz, de 300 a 3000 Hz.
  + Para pasar a 14,250 MHz no se toca ningún filtro: el oscilador sube a 5,250 MHz y la nueva señal vuelve a caer en 9,000 MHz.
]

#ojo(titulo: [¿suma o resta?])[
  La FI es siempre la diferencia, pero el oscilador puede ir por encima o por debajo de la señal:
  - oscilador *por encima*: $f_s = f_"OL" - f_"FI"$ (preguntas T4.4 y T4.38);
  - oscilador *por debajo*: $f_s = f_"OL" + f_"FI"$ (pregunta T4.20).
  El enunciado siempre dice dónde va el oscilador. Los distractores suelen ser la otra operación o la frecuencia imagen.
]

=== El precio: la frecuencia imagen

La contrapartida es la *frecuencia imagen*. Si el oscilador va por encima de la señal, tanto $f_s = f_"OL" - f_"FI"$ como su simétrica $f_"im" = f_"OL" + f_"FI"$ producen exactamente la misma FI: una vez mezcladas son indistinguibles. La imagen está en
$ f_"im" = f_s + 2 f_"FI" $
(dos veces la FI por encima — o por debajo — de la sintonizada) y hay que eliminarla _antes_ del mezclador, con el filtro preselector de la etapa de RF. La imagen se ve en el espectro en #ver(<t4-sec-imagen>).

=== La doble conversión

De aquí el interés de la *doble conversión*: una primera FI alta aleja la imagen (fácil de filtrar) y una segunda FI baja da la selectividad fina; dos FI independientes, lo mejor de ambos mundos.

#ejemplo[
  Receptor con FI de 455 kHz sintonizando 7,000 MHz: oscilador en 7,455 MHz e imagen en 7,910 MHz — a solo 910 kHz de la señal, difícil de filtrar. Con una primera FI de 70 MHz la imagen se va a 147 MHz, y cualquier preselector la aniquila. Esa es la razón de ser de la doble conversión: imagen lejos (primera FI alta) y selectividad fina (segunda FI baja).
]

#circuito(caption: [Receptor de doble conversión sintonizando 7,000 MHz (frecuencias en MHz). La primera FI, alta, aleja la imagen hasta 147 MHz; la segunda, baja, permite un filtro estrecho de 2,4 kHz.])[
  #_t4-diagrama(
    spacing: (10.5mm, 9mm),
    node((0, 0), _t4-ant, stroke: none, fill: none),
    node((1, 0), _t4-t[ampl.\ RF], shape: rect),
    node((2, 0), _t4-t[mezclador\ 1], shape: rect),
    node((2, 1), _t4-t[OL 1\ *77,000*], shape: rect),
    node((3, 0), _t4-t[1.ª FI\ 70 MHz], shape: rect),
    node((4, 0), _t4-t[mezclador\ 2], shape: rect),
    node((4, 1), _t4-t[OL 2\ *70,455*], shape: rect),
    node((5, 0), _t4-t[2.ª FI 455 kHz\ (2,4 kHz)], shape: rect),
    node((6, 0), _t4-t[detector], shape: rect),
    edge((0, 0), (1, 0), "-|>", _t4-f[7,000], label-side: left),
    edge((1, 0), (2, 0), "-|>", _t4-f[7,000], label-side: left),
    edge((2, 0), (3, 0), "-|>", _t4-f[70,000], label-side: left),
    edge((3, 0), (4, 0), "-|>", _t4-f[70,000], label-side: left),
    edge((4, 0), (5, 0), "-|>", _t4-f[0,455], label-side: left),
    edge((5, 0), (6, 0), "-|>", _t4-f[0,455], label-side: left),
    edge((2, 1), (2, 0), "-|>"),
    edge((4, 1), (4, 0), "-|>"),
  )
] <t4-fig-doble>

#porque[
  - *Primera conversión.* El OL 1 va 70 MHz por encima de la señal: $77 - 7 = 70$ MHz. La imagen de esta conversión está en $77 + 70 = 147$ MHz, veinte veces más lejos que la señal: un simple filtro paso bajo de 30 MHz delante del mezclador la elimina.
  - *Filtro de la primera FI.* Es relativamente ancho (unos kHz), pero ya deja fuera las señales fuertes que no están cerca de la sintonizada.
  - *Segunda conversión.* El OL 2 lleva los 70 MHz a 455 kHz. Su imagen está en $70,455 + 0,455 = 70,910$ MHz, a 910 kHz de la primera FI: el filtro de 70 MHz que la precede ya la ha rechazado.
  - *Segunda FI.* A 455 kHz es fácil construir un filtro de 2,4 kHz con flancos muy abruptos: la selectividad fina.
]

=== La conversión directa

En el extremo opuesto está la *conversión directa*: oscilador a la propia frecuencia de la señal y el mezclador entrega directamente audio — simple y sin FI que filtrar ni imagen de RF como la del superheterodino, pero con su propia _imagen de audio_: como el oscilador cae sobre la señal, las frecuencias simétricas respecto a él (la otra banda lateral) producen el mismo audio y se superponen, salvo que se separen con un mezclador en cuadratura. Además paga otras servidumbres: fugas del oscilador hacia la antena, zumbido y ruido de baja frecuencia.

#circuito(caption: [Receptor de conversión directa para CW en 40 m (frecuencias en MHz). La «FI» es el propio audio: toda la selectividad la pone un filtro paso bajo de audio.])[
  #_t4-diagrama(
    spacing: (9mm, 9mm),
    node((0, 0), _t4-ant, stroke: none, fill: none),
    node((1, 0), _t4-t[ampl.\ RF], shape: rect),
    node((2, 0), _t4-t[mezclador], shape: rect),
    node((2, 1), _t4-t[oscilador\ *7,0300*], shape: rect),
    node((3, 0), _t4-t[filtro paso bajo\ de audio], shape: rect),
    node((4, 0), _t4-t[ampl.\ BF], shape: rect),
    node((5, 0), _t4-alt, stroke: none, fill: none),
    edge((0, 0), (1, 0), "-|>", _t4-f[7,0307], label-side: left),
    edge((1, 0), (2, 0), "-|>", _t4-f[7,0307], label-side: left),
    edge((2, 0), (3, 0), "-|>", _t4-f[700 Hz], label-side: left),
    edge((3, 0), (4, 0), "-|>", _t4-f[700 Hz], label-side: left),
    edge((4, 0), (5, 0), "-|>"),
    edge((2, 1), (2, 0), "-|>"),
  )
] <t4-fig-directa>

#circuito(caption: [La imagen de audio de la conversión directa. Con el oscilador en 7,0300 MHz, una estación en 7,0307 MHz y otra en 7,0293 MHz dan las dos un tono de 700 Hz: se oyen superpuestas.])[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    // eje de frecuencias: 7,0285–7,0315 MHz → 0–9 cm
    let x(f) = (f - 7.0285) * 3000
    line((0, 0), (9.3, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((9.3, -0.15), anchor: "north-east", text(size: 8pt, $f$))
    // oscilador
    line((x(7.0300), 0), (x(7.0300), 2.2), stroke: (paint: col.verde, thickness: 1.2pt), mark: (end: ">", fill: col.verde))
    content((x(7.0300), 2.45), text(font: fuente-sans, size: 7pt, fill: col.verde)[oscilador])
    content((x(7.0300), -0.15), anchor: "north", text(font: fuente-sans, size: 7pt)[7,0300])
    // estación A (deseada) y B (la «imagen»)
    rect((x(7.0307) - 0.08, 0), (x(7.0307) + 0.08, 1.5), fill: col.senal1, stroke: none)
    content((x(7.0307), 1.75), text(font: fuente-sans, size: 7pt, fill: col.senal1)[estación A])
    content((x(7.0307), -0.15), anchor: "north", text(font: fuente-sans, size: 7pt)[7,0307])
    rect((x(7.0293) - 0.08, 0), (x(7.0293) + 0.08, 1.2), fill: col.senal2, stroke: none)
    content((x(7.0293), 1.45), text(font: fuente-sans, size: 7pt, fill: col.senal2)[estación B])
    content((x(7.0293), -0.15), anchor: "north", text(font: fuente-sans, size: 7pt)[7,0293])
    // separaciones
    line((x(7.0300), 0.6), (x(7.0307), 0.6), mark: (start: ">", end: ">", fill: black), stroke: 0.5pt)
    content(((x(7.0300) + x(7.0307)) / 2, 0.82), text(font: fuente-sans, size: 7pt)[700 Hz])
    line((x(7.0293), 0.6), (x(7.0300), 0.6), mark: (start: ">", end: ">", fill: black), stroke: 0.5pt)
    content(((x(7.0293) + x(7.0300)) / 2, 0.82), text(font: fuente-sans, size: 7pt)[700 Hz])
  })
] <t4-fig-imagen-audio>

#porque[
  - El mezclador entrega $|f_s - f_"OL"|$: para él, 700 Hz por encima y 700 Hz por debajo del oscilador son lo mismo. Por eso las dos estaciones de la @t4-fig-imagen-audio se oyen a la vez.
  - El filtro paso bajo de audio (unos 3 kHz para SSB, menos para CW) es el único elemento selectivo; casi toda la ganancia está en el amplificador de audio, y por eso el zumbido de red y el ruido de baja frecuencia se notan tanto.
  - El oscilador trabaja justo en la frecuencia de la antena: una parte se escapa por ella, rebota y vuelve a entrar al mezclador.
  - Un mezclador en cuadratura (dos mezcladores con osciladores desfasados 90°) separa los dos lados del oscilador: es la base de los receptores SDR modernos.
]

#q("T4.1", "b",
  [En un receptor superheterodino, el orden correcto de las etapas desde la antena hasta el altavoz es:],
  ([mezclador, amplificador de RF, demodulador, FI, amplificador de audio], [amplificador de RF, mezclador, amplificador de FI, demodulador, amplificador de audio], [amplificador de FI, mezclador, amplificador de RF, demodulador, amplificador de audio], [demodulador, mezclador, amplificador de FI, amplificador de audio]),
  sol: [Cadena del superheterodino: amplificador de RF → mezclador → amplificador de FI → demodulador → amplificador de audio. El amplificador de RF va primero porque fija la figura de ruido (fórmula de Friis): lo que añadan las etapas siguientes entra dividido por su ganancia. El mezclador traslada luego la señal a la FI fija, donde el filtrado y la amplificación son óptimos, y solo al final se demodula. Invertir el orden no tiene sentido físico.],
)

#q("T4.2", "a",
  [Se denomina frecuencia intermedia (FI) a:],
  ([la frecuencia de valor constante empleada en los receptores superheterodinos, presente a la salida del mezclador], [la frecuencia media de la banda de trabajo], [la frecuencia del oscilador local], [la mitad de la frecuencia recibida]),
  sol: [La FI es una frecuencia fija a la que el mezclador traslada cualquier señal sintonizada; sus filtros pueden así optimizarse (455 kHz, 9 MHz, 10,7 MHz son valores típicos).],
)

#q("T4.3", "d",
  [Un receptor de conversión directa se caracteriza por:],
  ([emplear dos frecuencias intermedias independientes], [carecer de oscilador local], [amplificar la señal sin demodularla], [mezclar directamente la señal recibida para obtener la señal de audio]),
  sol: [El receptor de conversión directa mezcla la señal con un oscilador a (casi) la misma frecuencia y obtiene el audio directamente, sin FI. No tiene la imagen de RF del superheterodino, pero sí una imagen de audio: las frecuencias simétricas respecto al oscilador (la otra banda lateral) dan el mismo audio.],
)

#q("T4.4", "c",
  [Si se desea sintonizar una señal de 7 MHz en un receptor cuya frecuencia intermedia es de 9 MHz, el oscilador local deberá funcionar a:],
  ([2,5 MHz], [9 MHz], [16 MHz], [63 MHz]),
  sol: [$f_"OL" = f_"señal" + f_"FI" = 7 + 9 = 16$ MHz.],
)

// =====================================================================
== Características y controles <t4-sec-caracteristicas>

Cuatro cifras resumen un receptor. La *sensibilidad*: la señal mínima que produce una relación señal/ruido dada; su límite físico es el ruido térmico $k T B$ más lo que el propio receptor añade (su figura de ruido). La *selectividad*: la capacidad de separar señales próximas, dictada por la curva de los filtros de FI. La *estabilidad*: mantener la frecuencia sintonizada sin deriva. Y el *margen dinámico*: convivir con señales muy fuertes y muy débiles a la vez sin que las fuertes bloqueen o generen intermodulación — batalla que se juega, sobre todo, en el primer mezclador. La *relación señal/ruido*, en dB, es el índice global de calidad de la recepción. A esa lista el temario añade dos definiciones finas: la *selectividad de canal adyacente* —cuánto rechaza el receptor una emisión en el canal contiguo, cosa que fijan los faldones de los filtros de FI: es una propiedad lineal— y la *modulación cruzada* —esta sí, síntoma de no linealidad en las primeras etapas—, en la que la modulación de una señal fuerte e indeseada se traslada a la portadora que estamos escuchando. Pariente de ambas es la *desensibilización*: una señal fuerte fuera del canal reduce la ganancia aparente del receptor y las señales débiles se hunden; se desarrolla, junto al bloqueo, en el tema T9.

=== Las cuatro cifras, en palabras llanas

- *Sensibilidad: ¿cuál es la señal más débil que entiendo?* Se da en microvoltios o en dBm para una relación señal/ruido de 10 dB. Lo que la limita es el *ruido*, no la falta de ganancia: más ganancia amplifica el ruido igual que la señal. Por eso depende de la primera etapa (T4.30).
- *Selectividad: ¿oigo esa estación sin oír la de al lado?* Depende de la forma del filtro de FI (@t4-fig-selectividad): su anchura a −6 dB dice qué deja pasar, y su anchura a −60 dB, qué rechaza de verdad. El cociente entre las dos es el *factor de forma*: 1 sería un filtro ideal de paredes verticales; un buen filtro de cristal ronda 1,5–2.
- *Estabilidad: ¿sigo en la misma frecuencia dentro de una hora?* En SSB, un corrimiento de 50 Hz ya cambia el timbre de la voz, y unos cientos de hercios la vuelven ininteligible (T4.32).
- *Margen dinámico: ¿aguanto a la vez lo muy fuerte y lo muy débil?* Es la distancia, en dB, entre la señal más débil que se oye y la más fuerte que el receptor tolera sin fabricar señales falsas. Se explica con detalle en #ver(<t4-sec-imagen>).

#circuito(caption: [Curva de un filtro de FI para SSB. Pasa 2,4 kHz a −6 dB y 5,3 kHz a −60 dB (factor de forma 2,2). Una estación en el canal adyacente cae sobre el faldón y queda más de 60 dB por debajo: eso es la selectividad de canal adyacente.])[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    // eje x: −6…+6 kHz → −4,8…4,8 cm; eje y: 0…−80 dB → 3,2…0 cm
    let x(k) = k * 0.8
    let y(db) = 3.2 + db / 25
    let a(k) = calc.max(-80, -10 * calc.log(1 + calc.pow(k / 1.1208, 16)))
    line((x(-6.2), 0), (x(6.4), 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((x(6.4) + 0.1, 0), anchor: "west", text(size: 8pt)[$Delta f$ (kHz)])
    line((x(-6.2), 0), (x(-6.2), 3.5), mark: (end: ">", fill: black), stroke: 0.6pt)
    for db in (0, -20, -40, -60, -80) {
      line((x(-6.2) - 0.08, y(db)), (x(-6.2), y(db)), stroke: 0.5pt)
      content((x(-6.2) - 0.12, y(db)), anchor: "east", text(font: fuente-sans, size: 6.5pt)[#db dB])
    }
    for k in (-6, -3, 0, 3, 6) {
      content((x(k), -0.12), anchor: "north", text(font: fuente-sans, size: 6.5pt)[#k])
    }
    // señal deseada y canal adyacente (tal como llegan)
    rect((x(-1.1), y(0) - 0.02), (x(1.1), y(-6)), fill: col.senal1.lighten(70%), stroke: none)
    content((x(-3.4), y(0) + 0.05), anchor: "south", text(font: fuente-sans, size: 6.5pt, fill: col.senal1)[señal deseada])
    line((x(-2.3), y(0) + 0.1), (x(-1.0), y(-3)), stroke: 0.4pt + col.senal1)
    rect((x(3.3), y(0) - 0.02), (x(5.7), y(-6)), stroke: (paint: col.senal2, dash: "dashed", thickness: 0.6pt))
    content((x(4.5), y(0) + 0.05), anchor: "south", text(font: fuente-sans, size: 6.5pt, fill: col.senal2)[canal adyacente (tal como llega)])
    // curva del filtro
    onda(k => y(a(k)), -6, 6, n: 400, stroke: 1.2pt + col.senal1)
    // anchuras a −6 y −60 dB
    let w6 = 1.2
    let w60 = 2.655
    line((x(-w6), y(-6)), (x(w6), y(-6)), mark: (start: ">", end: ">", fill: black), stroke: 0.5pt)
    content((x(0), y(-6) - 0.08), anchor: "north", text(font: fuente-sans, size: 6.5pt)[2,4 kHz a −6 dB])
    line((x(-w60), y(-60)), (x(w60), y(-60)), mark: (start: ">", end: ">", fill: black), stroke: 0.5pt)
    content((x(0), y(-60) + 0.08), anchor: "south", text(font: fuente-sans, size: 6.5pt)[5,3 kHz a −60 dB])
  })
] <t4-fig-selectividad>

#ojo[
  No confundas las cuatro palabras: *sensibilidad* = señales débiles (T4.6, T4.30); *selectividad* = señales próximas (T4.5, T4.19, T4.31); *estabilidad* = no derivar en frecuencia (T4.14, T4.32); *fidelidad* = reproducir la modulación sin deformarla (aparece como distractor). La selectividad la fijan los filtros de FI, no la antena ni el audio.
]

=== El ruido pone el listón

El ruido pone el listón absoluto. Un receptor de ancho de banda $B$ parte del suelo térmico $k T_0 B$ — en dBm, $-174 + 10 log_10 B$ — al que añade su propia *figura de ruido* $F$; la señal mínima discernible queda en $"MDS" = -174 + 10 log_10 B + F$ dBm. Para los 2,7 kHz de la SSB y $F = 10$ dB salen unos −130 dBm: centésimas de microvoltio. En una cadena de etapas, la fórmula de Friis,
$ F_"total" = F_1 + (F_2 - 1) / G_1 + (F_3 - 1) / (G_1 G_2) + dots.c , $
— aquí $F$ y $G$ son cocientes, no decibelios: 10 dB de ganancia entran como $G = 10$ — enseña que el ruido lo fija casi en exclusiva la _primera_ etapa (las siguientes entran divididas por la ganancia acumulada): por eso el preamplificador se instala junto a la antena y no junto al receptor. Como referencia de niveles, el convenio veterano: S9 = 50 µV en HF y 6 dB por cada punto S del instrumento.

#analogia[
  El ruido es como el murmullo de un bar. Gritar más (más ganancia) no ayuda si el murmullo sube contigo: lo que cuenta es cuánto sobresale tu voz del murmullo. La figura de ruido mide cuánto murmullo _añade_ el propio receptor a lo que ya traía la antena.
]

#ejemplo(titulo: [de dBm a microvoltios])[
  Con $B = 2700$ Hz y $F = 10$ dB: $"MDS" = -174 + 10 log_10 2700 + 10 = -174 + 34,3 + 10 approx -130$ dBm, es decir, $10^(-13)$ mW $= 10^(-16)$ W. Sobre 50 Ω, $V = sqrt(P R) = sqrt(10^(-16) dot 50) approx 0,07$ µV. Si estrechas el filtro a 500 Hz para CW, $10 log_10 500 = 27$ dB: el MDS baja a −137 dBm. Un filtro más estrecho deja entrar menos ruido, y la señal débil sobresale más.
]

#ejemplo(titulo: [¿dónde va el preamplificador?])[
  En 2 m tienes un receptor de $F = 10$ dB (cociente 10), un coaxial con 3 dB de pérdidas (una atenuación de 3 dB tiene $F = 2$ y $G = 0,5$) y un preamplificador de $F = 1$ dB (cociente 1,26) y 20 dB de ganancia ($G = 100$).
  - *Preamplificador junto al receptor* (coaxial primero): $F = 2 + (1,26 - 1) / (0,5) + (10 - 1) / (0,5 dot 100) = 2 + 0,52 + 0,18 = 2,70$, es decir, *4,3 dB*.
  - *Preamplificador junto a la antena* (preamplificador primero): $F = 1,26 + (2 - 1) / 100 + (10 - 1) / (100 dot 0,5) = 1,26 + 0,01 + 0,18 = 1,45$, es decir, *1,6 dB*.
  El mismo aparato mejora la figura de ruido casi 3 dB solo por cambiarlo de sitio: delante de las pérdidas del cable, el ruido del cable entra dividido por la ganancia del preamplificador.
]

#ojo[
  En HF —sobre todo en 160, 80 y 40 m— el ruido atmosférico que llega por la antena (el QRN de T4.33) es muy superior al del receptor: un preamplificador apenas mejora la escucha y empeora la intermodulación. La figura de ruido es decisiva en VHF, UHF y microondas, donde el ruido exterior es bajo.
]

#ptitulo[Los puntos S] El S-meter da la señal en «puntos S» (@t4-tab-smeter). Cada punto son 6 dB, es decir, el doble de tensión; por encima de S9 se cuenta en dB («S9 + 20 dB» son 10 veces la tensión de S9, 500 µV). En VHF y UHF la IARU recomienda S9 = 5 µV (−93 dBm).

#figure(
  table(
    columns: (auto, auto, auto),
    align: (center, right, right),
    [*Lectura*], [*Tensión en 50 Ω*], [*Potencia*],
    [S9 + 20 dB], [500 µV], [−53 dBm],
    [S9], [50 µV], [−73 dBm],
    [S8], [25 µV], [−79 dBm],
    [S7], [12,5 µV], [−85 dBm],
    [S6], [6,3 µV], [−91 dBm],
    [S5], [3,1 µV], [−97 dBm],
    [S3], [0,8 µV], [−109 dBm],
    [S1], [0,2 µV], [−121 dBm],
  ),
  caption: [Escala del S-meter en HF (convenio S9 = 50 µV, 6 dB por punto S).],
  supplement: [Cuadro],
) <t4-tab-smeter>

=== Automatismos y detección

Alrededor de la cadena principal trabajan los automatismos: el *CAG* mide el nivel tras la detección y reajusta la ganancia de RF y FI para que la salida no fluctúe con el fading (el *S-meter* no es más que la lectura de ese lazo); el *silenciador* (_squelch_) corta el audio cuando no hay señal que supere el umbral; el *NB* recorta los picos de ruido impulsivo. En la detección, cada modo tiene su circuito: detector de envolvente para AM, limitador más discriminador para FM, y para SSB y CW el *detector de producto*, que mezcla la FI con el *oscilador de batido* (BFO) para reinsertar la portadora que el transmisor suprimió.

==== El CAG por dentro

#motivacion[
  En HF la señal sube y baja 20 o 30 dB en segundos (el _fading_), y al pasar de una estación local a otra lejana el nivel cambia 80 o 100 dB. Sin CAG tendrías que mover el volumen sin parar, y una estación fuerte saturaría el amplificador de FI hasta distorsionar.
]

#circuito(caption: [El lazo de CAG. Un detector propio rectifica la señal y la filtra con una red RC; la tensión que resulta reduce la ganancia de las etapas de FI y de RF. El S-meter es un voltímetro sobre esa misma tensión.])[
  #_t4-diagrama(
    spacing: (7mm, 9mm),
    node((0, 0), _t4-ant, stroke: none, fill: none),
    node((1, 0), _t4-t[ampl.\ RF], shape: rect),
    node((2, 0), _t4-t[mezclador], shape: rect),
    node((2, -1), _t4-t[oscilador\ local], shape: rect),
    node((3, 0), _t4-t[ampl.\ FI], shape: rect),
    node((4, 0), _t4-t[detector], shape: rect),
    node((5, 0), _t4-t[ampl.\ BF], shape: rect),
    node((6, 0), _t4-alt, stroke: none, fill: none),
    node((4, 1.1), _t4-t[detector de CAG\ (rectificador + RC)], shape: rect, stroke: 0.7pt + col.verde, fill: col.verde-claro),
    node((5.8, 1.1), _t4-t[S-meter], shape: rect, stroke: 0.7pt + col.verde, fill: col.verde-claro),
    edge((0, 0), (1, 0), "-|>"),
    edge((1, 0), (2, 0), "-|>"),
    edge((2, 0), (3, 0), "-|>"),
    edge((3, 0), (4, 0), "-|>"),
    edge((4, 0), (5, 0), "-|>"),
    edge((5, 0), (6, 0), "-|>"),
    edge((2, -1), (2, 0), "-|>"),
    edge((4, 0), (4, 1.1), "-|>", stroke: 0.6pt + col.verde),
    edge((4, 1.1), (3, 1.1), (3, 0), "-|>", stroke: 0.6pt + col.verde, dash: "dashed"),
    edge((3, 1.1), (1, 1.1), (1, 0), "-|>", stroke: 0.6pt + col.verde, dash: "dashed"),
    edge((4, 1.1), (5.8, 1.1), "-|>", stroke: 0.6pt + col.verde),
    node((2, 1.4), _t4-e(color: col.verde)[tensión de CAG], stroke: none, fill: none),
  )
] <t4-fig-cag>

#porque[
  - *Mide.* El detector de CAG rectifica la señal: obtiene una tensión continua proporcional a su amplitud.
  - *Promedia.* La red RC fija la constante de tiempo: el CAG debe reaccionar rápido cuando la señal sube (unos milisegundos, para no dejar pasar un golpe de volumen) y soltar despacio cuando baja (de 0,1 a 2 s), para no «bombear» entre sílaba y sílaba. Esa es la diferencia entre CAG rápido (FAST, para CW) y lento (SLOW, para SSB).
  - *Corrige.* La tensión de CAG reduce la ganancia de FI y, si la señal es muy fuerte, también la de RF. Es una realimentación negativa: más señal → más tensión → menos ganancia. La salida sube muy poco aunque la entrada suba mucho (@t4-fig-cag-curva).
  - *Por qué también la RF.* Con una señal muy fuerte, bajar solo la FI no basta: el mezclador ya estaría saturado. Reducir la ganancia delante lo protege.
  - *El S-meter.* Cuanto más fuerte llega la señal, más tensión de CAG hace falta para frenarla: medir esa tensión es medir la señal. En muchos equipos, el mando RF GAIN inyecta tensión en esa misma línea, y por eso la aguja sube al bajarlo.
]

#circuito(caption: [Nivel de salida frente a nivel de entrada. Sin CAG, la salida sigue a la entrada hasta saturar; con CAG, por encima del umbral, 100 dB de variación de entrada se quedan en unos 10 dB de salida.])[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    // x: entrada −120…−20 dBm → 0…8 cm ; y: salida 0…70 dB → 0…3,5 cm
    let x(p) = (p + 120) * 0.08
    let y(d) = d * 0.05
    line((0, 0), (8.6, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    line((0, 0), (0, 3.9), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((8.7, 0), anchor: "west", text(size: 7.5pt)[entrada (dBm)])
    content((0.1, 3.9), anchor: "west", text(size: 7.5pt)[salida (dB)])
    for p in (-120, -100, -80, -60, -40, -20) {
      line((x(p), 0), (x(p), -0.08), stroke: 0.5pt)
      content((x(p), -0.12), anchor: "north", text(font: fuente-sans, size: 6.5pt)[#p])
    }
    // sin CAG: pendiente 1 hasta saturar en 60 dB
    line((x(-120), y(0)), (x(-60), y(60)), (x(-20), y(62)), stroke: (paint: col.senal2, thickness: 1.1pt, dash: "dashed"))
    content((x(-45), y(66)), text(font: fuente-sans, size: 7pt, fill: col.senal2)[sin CAG (satura)])
    // con CAG: pendiente 1 hasta −100 dBm, después 0,1
    line((x(-120), y(0)), (x(-100), y(20)), (x(-20), y(28)), stroke: 1.2pt + col.senal1)
    content((x(-40), y(20)), text(font: fuente-sans, size: 7pt, fill: col.senal1)[con CAG])
    line((x(-100), 0), (x(-100), y(20)), stroke: (dash: "dotted", thickness: 0.5pt))
    content((x(-100) + 0.1, y(8)), anchor: "west", text(font: fuente-sans, size: 6.5pt)[umbral])
  })
] <t4-fig-cag-curva>

==== El BFO y el detector de producto

#motivacion[
  El transmisor de SSB quitó la portadora y una banda lateral (#ver(<t5-sec-arquitecturas>)). Un detector de envolvente necesita la portadora para «batir» contra ella: sin ella, la SSB suena como un pato ininteligible. Y una portadora de CW detectada por envolvente da solo un golpe sordo al empezar y al acabar cada raya: no hay tono que oír. Hay que reponer la portadora en el receptor.
]

#circuito(caption: [El detector de producto mezcla la FI con el BFO. La banda lateral superior, de 9,0003 a 9,003 MHz, sale como audio de 300 a 3000 Hz: la diferencia $f - f_"BFO"$.])[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    // espectro de FI: 8,9985–9,0045 MHz → 0–9 cm
    let x(f) = (f - 8.9985) * 1500
    line((0, 2.2), (9.3, 2.2), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((9.3, 2.05), anchor: "north-east", text(size: 7pt)[$f$ (MHz)])
    line((x(9.0000), 2.2), (x(9.0000), 3.9), stroke: (paint: col.verde, thickness: 1.2pt), mark: (end: ">", fill: col.verde))
    content((x(9.0000), 4.1), text(font: fuente-sans, size: 7pt, fill: col.verde)[BFO 9,000])
    line((x(9.0003), 2.2), (x(9.0003), 2.9), (x(9.0030), 3.3), (x(9.0030), 2.2), close: true, fill: col.senal1.lighten(60%), stroke: 0.8pt + col.senal1)
    content((x(9.00165), 3.55), text(font: fuente-sans, size: 7pt, fill: col.senal1)[banda lateral superior])
    content((x(9.0003), 2.05), anchor: "north", text(font: fuente-sans, size: 6.5pt)[9,0003])
    content((x(9.0030), 2.05), anchor: "north", text(font: fuente-sans, size: 6.5pt)[9,0030])
    content((x(8.9985) + 0.1, 3.4), anchor: "west", text(font: fuente-sans, size: 7.5pt, weight: "bold")[en la FI])
    // flecha de conversión
    line((4.5, 1.6), (4.5, 1.05), mark: (end: ">", fill: black), stroke: 0.7pt)
    content((4.65, 1.33), anchor: "west", text(font: fuente-sans, size: 7pt)[detector de producto: $f - f_"BFO"$])
    // espectro de audio: 0–4,5 kHz con la misma escala (1 kHz = 1,5 cm)
    let xa(k) = x(9.0000) + k * 1.5
    line((x(9.0000), 0), (9.3, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((9.3, -0.15), anchor: "north-east", text(size: 7pt)[$f$ (kHz)])
    line((xa(0.3), 0), (xa(0.3), 0.7), (xa(3.0), 1.1 - 0.0), (xa(3.0), 0), close: true, fill: col.senal3.lighten(60%), stroke: 0.8pt + col.senal3)
    content((xa(0), -0.15), anchor: "north", text(font: fuente-sans, size: 6.5pt)[0])
    content((xa(0.3), -0.15), anchor: "north", text(font: fuente-sans, size: 6.5pt)[0,3])
    content((xa(3.0), -0.15), anchor: "north", text(font: fuente-sans, size: 6.5pt)[3])
    content((x(8.9985) + 0.1, 0.6), anchor: "west", text(font: fuente-sans, size: 7.5pt, weight: "bold")[audio])
  })
] <t4-fig-producto>

#porque[
  - El detector de producto es un *mezclador* más: multiplica la FI por el BFO y a su salida aparecen la diferencia (el audio) y la suma (cerca de 18 MHz), que un filtro paso bajo elimina. Un modulador en anillo de diodos hace este trabajo: #falstad("ringmod.txt")
  - El BFO hace el papel de la portadora que no llegó. Si está bien colocado, en el lugar exacto de la portadora suprimida, cada componente de la voz recupera su frecuencia original.
  - Si el BFO (o la sintonía) se desvía 100 Hz, toda la voz sube o baja 100 Hz: suena aguda o grave, «de pato». Por eso hay que sintonizar la SSB con finura, y por eso existe el RIT.
  - En CW, la portadora de la estación cae en la FI a una distancia fija del BFO —por ejemplo, 700 Hz— y el detector la convierte en un tono de 700 Hz que suena y calla al ritmo del morse.
]

==== Los mandos del receptor: qué problema resuelve cada uno

Cada mando de un transceptor existe porque hay un problema concreto que resolver. Si recuerdas el problema, recuerdas el mando (@t4-tab-mandos).

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: left,
    [*Mando*], [*Problema que resuelve*], [*Qué hace y dónde actúa*],
    [AF GAIN (volumen)], [oír más o menos alto], [ganancia de audio, al final de la cadena],
    [RF GAIN (T4.22)], [una señal muy fuerte satura la entrada], [reduce la ganancia de las primeras etapas (RF y FI)],
    [ATT (atenuador)], [señales fuertes que producen intermodulación], [resistencias delante del ampl. de RF: −10 o −20 dB a todo],
    [PREAMP], [falta sensibilidad (VHF/UHF)], [amplificador de bajo ruido delante; en HF bajas suele sobrar],
    [AGC FAST/SLOW], [el CAG bombea o reacciona tarde], [cambia la constante de tiempo del CAG],
    [NB (T4.15, T4.23)], [ruido impulsivo: motores, vallas eléctricas], [detecta los pulsos cortos y silencia la FI durante ellos],
    [NR], [soplido continuo de fondo], [reducción de ruido por DSP en el audio],
    [NOTCH], [un silbido fijo (una portadora) sobre la SSB], [filtro de rechazo muy estrecho sobre ese tono],
    [Anchura del filtro (T4.26)], [estaciones vecinas], [estrecha o ensancha la banda de paso de FI],
    [RIT (T4.21)], [el corresponsal llega ligeramente desplazado], [mueve solo la frecuencia de recepción],
    [SQL (squelch) (T4.8)], [soplido de FM cuando no hay señal], [corta el audio por debajo de un umbral],
    [MODE (T4.25)], [cada modulación necesita su detector], [elige demodulador, filtro y banda lateral],
  ),
  caption: [Los mandos de un receptor y el problema que resuelve cada uno.],
  supplement: [Cuadro],
) <t4-tab-mandos>

#ojo[
  - El *NB* actúa sobre pulsos cortos e intensos (T4.15, T4.23); el *NR* sobre el ruido continuo; el *squelch* no reduce ningún ruido: simplemente corta el audio cuando no hay señal (T4.8).
  - *RF GAIN* actúa al principio de la cadena; el volumen (*AF GAIN*), al final (T4.22).
  - El *RIT* mueve la recepción y deja quieta la transmisión (T4.21); su pareja, el XIT, hace lo contrario.
  - El *BFO* solo hace falta para SSB y CW: ni la AM con portadora ni la FM lo necesitan (T4.10, T4.34, T4.40).
]

#q("T4.5", "c",
  [La selectividad de un receptor es su capacidad de:],
  ([amplificar señales muy débiles], [mantener la frecuencia sintonizada], [separar dos señales muy próximas en frecuencia], [eliminar el ruido atmosférico]),
  sol: [Selectividad: separar señales muy próximas en frecuencia; la fija la curva de los filtros de FI.],
)

#q("T4.6", "a",
  [La sensibilidad de un receptor se define como su capacidad de:],
  ([captar señales débiles y amplificarlas], [rechazar la frecuencia imagen], [separar canales adyacentes], [funcionar con baterías descargadas]),
  sol: [Sensibilidad: captar y amplificar señales débiles; se especifica como la entrada mínima para una relación señal/ruido dada.],
)

#q("T4.7", "d",
  [El control automático de ganancia (CAG) de un receptor tiene como objetivo:],
  ([aumentar la selectividad del receptor], [suprimir los ruidos impulsivos], [silenciar el altavoz en ausencia de señal], [mantener constante la amplitud de la señal de salida]),
  sol: [El CAG ajusta la ganancia según la señal recibida para que la salida se mantenga constante aunque la señal fluctúe (fading).],
)

#q("T4.8", "b",
  [El silenciador (_squelch_) de un receptor sirve para:],
  ([atenuar las señales demasiado fuertes], [suprimir la salida de audio cuando la señal recibida no supera un determinado nivel], [reducir la deriva de frecuencia], [proteger el altavoz de sobrecargas]),
  sol: [El squelch corta el audio cuando la señal no supera el umbral: elimina el soplido entre comunicados, imprescindible en FM.],
)

#q("T4.9", "a",
  [El instrumento del receptor conocido como _S-meter_ indica:],
  ([la intensidad de la señal recibida], [la potencia de salida del transmisor], [la tensión de alimentación del equipo], [la desviación de frecuencia]),
  sol: [El S-meter mide la intensidad de la señal recibida (puntos S y dB sobre S9).],
)

#q("T4.10", "c",
  [El detector de producto se emplea como etapa detectora en los receptores de:],
  ([FM de banda estrecha], [AM de doble banda lateral], [banda lateral única (SSB) y CW], [radiodifusión de onda media]),
  sol: [El detector de producto mezcla la FI con el oscilador de batido (BFO) para reinsertar la portadora suprimida: SSB y CW.],
)

// =====================================================================
== La frecuencia imagen y otras características <t4-sec-imagen>

#motivacion[
  El mezclador solo ve diferencias de frecuencia, y no sabe si la diferencia es «por arriba» o «por abajo». Con el oscilador en 7,455 MHz y una FI de 455 kHz, tanto 7,000 MHz como 7,910 MHz están a 455 kHz del oscilador. Si las dos llegan al mezclador, las dos salen por la FI, encima una de otra, y ya no hay filtro que las separe.
]

=== La imagen, vista en el espectro

En @t4-fig-imagen están las dos situaciones del ejemplo de la doble conversión. Arriba, con FI de 455 kHz, la imagen queda tan cerca de la señal que el preselector —un circuito sintonizado en 7 MHz— apenas la atenúa. Abajo, con FI de 9 MHz, el oscilador se va a 16 MHz y la imagen a 25 MHz, muy lejos de la curva del preselector.

#circuito(caption: [La frecuencia imagen y el preselector (un circuito sintonizado en 7 MHz con $Q = 50$, curva azul, en dB). Las dos señales llegan a la antena con el mismo nivel (barras discontinuas); al mezclador llega lo que deja el preselector. Con FI baja la imagen solo baja 22 dB; con FI de 9 MHz, 44 dB.])[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    // 0 dB → 2,4 cm sobre el eje; −60 dB → sobre el eje
    let y(db) = calc.max(0, 2.4 + db / 25)
    let panel(dy, f0, f1, fol, fim, titulo, eol, eim, atim, eat) = {
      let x(f) = (f - f0) / (f1 - f0) * 10
      // eje
      line((0, dy), (10.3, dy), mark: (end: ">", fill: black), stroke: 0.6pt)
      content((10.4, dy), anchor: "west", text(size: 7pt)[$f$ (MHz)])
      content((0, dy + 3.1), anchor: "west", text(font: fuente-sans, size: 7.5pt, weight: "bold", titulo))
      // curva del preselector
      let pts = range(501).map(i => {
        let f = f0 + (f1 - f0) * i / 500
        (x(f), dy + y(_t4-db-lc(f, 7, 50)))
      })
      line(..pts, stroke: 1.1pt + col.senal1)
      // las dos señales tal como llegan a la antena
      for f in (7, fim) {
        rect((x(f) - 0.1, dy), (x(f) + 0.1, dy + y(0)), stroke: (paint: col.gris, dash: "dashed", thickness: 0.5pt))
      }
      // señal deseada tras el preselector
      rect((x(7) - 0.1, dy), (x(7) + 0.1, dy + y(0)), fill: col.senal1, stroke: none)
      content((x(7), dy - 0.12), anchor: "north", text(font: fuente-sans, size: 6.5pt)[$f_s$ = 7])
      // imagen tras el preselector
      let h = calc.max(0.04, y(atim))
      rect((x(fim) - 0.1, dy), (x(fim) + 0.1, dy + h), fill: col.senal2, stroke: none)
      content((x(fim), dy - 0.12), anchor: "north", text(font: fuente-sans, size: 6.5pt)[$f_"im"$ = #eim])
      content((x(fim) + 0.18, dy + h + 0.12), anchor: "west", text(font: fuente-sans, size: 6.5pt, fill: col.senal2, eat))
      // oscilador local
      line((x(fol), dy), (x(fol), dy + 1.5), stroke: (paint: col.verde, thickness: 1pt), mark: (end: ">", fill: col.verde))
      content((x(fol), dy - 0.12), anchor: "north", text(font: fuente-sans, size: 6.5pt, fill: col.verde)[$f_"OL"$ = #eol])
      // separaciones de una FI
      line((x(7), dy + 2.65), (x(fol), dy + 2.65), mark: (start: ">", end: ">", fill: black), stroke: 0.45pt)
      line((x(fol), dy + 2.65), (x(fim), dy + 2.65), mark: (start: ">", end: ">", fill: black), stroke: 0.45pt)
      line((x(fol), dy + 1.5), (x(fol), dy + 2.65), stroke: (paint: col.verde, dash: "dotted", thickness: 0.5pt))
      content(((x(7) + x(fol)) / 2, dy + 2.85), text(font: fuente-sans, size: 6.5pt)[FI])
      content(((x(fol) + x(fim)) / 2, dy + 2.85), text(font: fuente-sans, size: 6.5pt)[FI])
    }
    panel(4.1, 6.4, 8.4, 7.455, 7.91, [FI = 455 kHz], [7,455], [7,910], _t4-db-lc(7.91, 7, 50), [−22 dB])
    panel(0, 4, 27, 16, 25, [FI = 9 MHz], [16], [25], _t4-db-lc(25, 7, 50), [−44 dB])
  })
] <t4-fig-imagen>

#ejemplo(titulo: [cuánto rechaza el preselector])[
  Un circuito sintonizado simple atenúa, a una frecuencia $f$, un factor $sqrt(1 + Q^2 (f slash f_0 - f_0 slash f)^2)$. Con $Q = 50$ en $f_0 = 7$ MHz:
  - FI de 455 kHz, imagen en 7,910 MHz: $f slash f_0 - f_0 slash f = 1,130 - 0,885 = 0,245$; factor $approx 12$, *−22 dB*;
  - FI de 9 MHz (oscilador por encima, 16 MHz), imagen en 25 MHz: factor $approx 165$, *−44 dB*;
  - primera FI de 70 MHz, imagen en 147 MHz: factor $approx 1050$, *−60 dB*.
  Con la imagen tan cerca como en el primer caso, haría falta un preselector de varios circuitos y de $Q$ muy alto; con una FI alta, un filtro sencillo basta.
]

=== El preselector

#circuito(sim: "bandpass.txt", caption: [Preselector: un circuito resonante paralelo entre la antena y el amplificador de RF. $L_1$ acopla la antena; $L_2$ y $C_V$ resuenan en la frecuencia sintonizada.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    antenna("ant", (0, 2.3))
    trafo("t1", (2, 1.5), nucleo: false)
    wire((0, 2.3), "t1.p1")
    wire("t1.p2", (1, 0.2))
    ground("g1", (1, 0.2))
    wire("t1.s1", (4.4, 2.3))
    capacitor("cv", (4.4, 2.3), (4.4, 0.7), variable: true)
    wire("t1.s2", (4.4, 0.7))
    wire((3, 0.7), (3, 0.2))
    ground("g2", (3, 0.2))
    wire((4.4, 2.3), (6.2, 2.3))
    node("sal", (6.2, 2.3), fill: false)
    content((1.25, 1.5), anchor: "east", text(size: 8pt)[$L_1$])
    content((2.75, 1.5), anchor: "west", text(size: 8pt)[$L_2$])
    content((4.95, 1.5), anchor: "west", text(size: 8pt)[$C_V$])
    content((6.2, 2.6), text(size: 7.5pt)[al ampl. de RF])
  })
] <t4-fig-preselector>

#porque[
  - $L_2$ y $C_V$ forman un circuito resonante paralelo (#ver(<sec-resonancia>)). En su frecuencia de resonancia, $f_0 = 1 slash (2 pi sqrt(L_2 C_V))$, su impedancia es muy alta y la señal llega entera al amplificador de RF.
  - Lejos de la resonancia —por ejemplo, en la frecuencia imagen— la bobina (por debajo de $f_0$) o el condensador (por encima) presentan poca reactancia y llevan la señal a masa: el circuito la cortocircuita.
  - $L_1$, con pocas espiras, acopla la antena de 50 Ω sin cargar demasiado el circuito: si la antena se conectara directamente, su resistencia bajaría el $Q$ y la curva se ensancharía.
  - $C_V$ variable permite seguir la sintonía. En los equipos modernos se usan filtros paso banda fijos, uno por banda, que se conmutan al cambiar de banda.
]

=== Margen dinámico, intermodulación y modulación cruzada

#motivacion[
  Fin de semana de concurso en 40 m: junto a la estación débil que intentas copiar hay señales de S9 + 40 dB a 10 kHz. El filtro de FI las eliminaría sin problema… si llegaran limpias hasta él. Pero antes del filtro estrecho están el amplificador de RF y el primer mezclador, que las ven todas a la vez y con todo su nivel.
]

Ninguna etapa real es perfectamente lineal. Cuando dos señales fuertes, $f_1$ y $f_2$, atraviesan una etapa no lineal, a la salida aparecen, además de ellas, productos de la forma $m f_1 plus.minus n f_2$. Los peores son los de *tercer orden*, $2 f_1 - f_2$ y $2 f_2 - f_1$, porque caen justo al lado de las señales originales, dentro de la banda y del preselector: ningún filtro anterior puede eliminarlos (@t4-fig-imd). Son señales que *no existen en el aire*: las fabrica tu receptor.

#circuito(caption: [Intermodulación de tercer orden. Dos estaciones fuertes en 7,100 y 7,110 MHz generan, en una etapa no lineal, productos falsos en 7,090 y 7,120 MHz (y otros menores más allá). El de 7,090 MHz tapa a una estación débil que sí está en el aire.])[
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    // 7,075–7,135 MHz → 0–9 cm
    let x(f) = (f - 7.075) * 150
    line((0, 0), (9.4, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((9.5, 0), anchor: "west", text(size: 7pt)[$f$ (MHz)])
    // suelo de ruido
    line((0, 0.3), (9.2, 0.3), stroke: (paint: col.gris, dash: "dotted", thickness: 0.6pt))
    content((9.2, 0.42), anchor: "south-east", text(font: fuente-sans, size: 6.5pt, fill: col.gris)[ruido])
    // señales fuertes
    for f in (7.100, 7.110) {
      rect((x(f) - 0.07, 0), (x(f) + 0.07, 3), fill: col.senal1, stroke: none)
    }
    content((x(7.105), 3.25), text(font: fuente-sans, size: 7pt, fill: col.senal1)[$f_1$ y $f_2$: S9 + 40 dB])
    // estación débil en 7,090 (tapada)
    rect((x(7.090) - 0.05, 0), (x(7.090) + 0.05, 0.55), fill: col.senal3, stroke: none)
    // productos de 3.er orden
    for f in (7.090, 7.120) {
      rect((x(f) - 0.09, 0), (x(f) + 0.09, 1.0), stroke: 0.9pt + col.senal2)
    }
    // productos de 5.º orden
    for f in (7.080, 7.130) {
      rect((x(f) - 0.07, 0), (x(f) + 0.07, 0.45), stroke: 0.7pt + col.senal2.lighten(30%))
    }
    content((x(7.090), 1.25), anchor: "south", text(font: fuente-sans, size: 6.5pt, fill: col.senal2)[$2 f_1 - f_2$])
    content((x(7.120), 1.25), anchor: "south", text(font: fuente-sans, size: 6.5pt, fill: col.senal2)[$2 f_2 - f_1$])
    content((x(7.084), 2.0), anchor: "east", text(font: fuente-sans, size: 6.5pt, fill: col.senal3)[estación débil en 7,090])
    line((x(7.084), 2.0), (x(7.090) - 0.06, 0.6), stroke: 0.4pt + col.senal3)
    for (f, t) in ((7.080, [7,080]), (7.090, [7,090]), (7.100, [7,100]), (7.110, [7,110]), (7.120, [7,120]), (7.130, [7,130])) {
      content((x(f), -0.12), anchor: "north", text(font: fuente-sans, size: 6.5pt, t))
    }
  })
] <t4-fig-imd>

- *Margen dinámico.* Es la distancia, en dB, entre la señal más débil que el receptor oye (su MDS) y el nivel de dos señales fuertes que empieza a producir productos de intermodulación por encima del ruido. Un buen receptor de HF supera los 90–100 dB. Lo decide sobre todo el *primer mezclador* (T4.17): es la etapa donde las señales fuertes llegan con más nivel y menos filtradas, porque delante solo hay un preselector ancho. Después del filtro de FI las vecinas ya no están. Por eso los buenos receptores ponen un filtro estrecho («filtro de techo», _roofing_) justo detrás del primer mezclador.
- *Por qué funciona el atenuador.* Los productos de tercer orden crecen 3 dB por cada dB que crecen las señales que los producen. Un atenuador de 10 dB baja la señal deseada 10 dB, pero los productos de intermodulación 30 dB: a menudo desaparecen bajo el ruido. En las bandas bajas, donde el ruido de banda ya es mayor que el del receptor, esos 10 dB de sensibilidad apenas se notan.
- *Modulación cruzada.* La no linealidad hace que la modulación de una señal fuerte (una emisora de AM, por ejemplo) se «pegue» a la portadora que escuchas: oyes la emisora de fondo aunque la sintonía esté lejos de ella.
- *Desensibilización y bloqueo.* Una señal muy fuerte fuera del canal comprime las primeras etapas: la ganancia baja y las señales débiles se hunden, aunque la fuerte no se oiga. Se estudian en el tema T9.

#ejemplo(titulo: [la regla de 3 a 1])[
  Dos estaciones de −30 dBm producen en tu receptor un producto de intermodulación de −110 dBm, que se oye 20 dB por encima de un ruido de −130 dBm. Activas el atenuador de 10 dB: las estaciones bajan a −40 dBm y el producto, $3 times 10 = 30$ dB, a −140 dBm: por debajo del ruido. La estación débil que querías, que llegaba con −110 dBm, baja a −120 dBm: sigue 10 dB por encima del ruido.
]

#ojo[
  - La imagen se rechaza *antes* del mezclador, con un filtro (T4.11); después ya es imposible.
  - La imagen está a *dos* veces la FI de la señal (T4.12), no a una: a una FI está el oscilador.
  - Selectividad de canal adyacente: problema *lineal* (filtros de FI). Modulación cruzada e intermodulación: problemas *no lineales* (primeras etapas). El margen dinámico se juega en el primer mezclador (T4.17).
]

#q("T4.11", "b",
  [En un receptor superheterodino, para rechazar la frecuencia imagen se emplea:],
  ([un atenuador de antena], [un filtro], [un amplificador de audio], [un limitador]),
  sol: [La frecuencia imagen se convierte a la misma FI que la señal deseada, así que una vez mezclada ya no se puede separar: hay que eliminarla antes del mezclador con un filtro (preselector).],
)

#q("T4.12", "d",
  [Se llama «frecuencia imagen» de un receptor superheterodino a la frecuencia situada:],
  ([en la mitad de la frecuencia sintonizada], [en el doble de la frecuencia sintonizada], [una FI por debajo de la frecuencia sintonizada], [dos veces la FI por encima (o por debajo) de la frecuencia sintonizada]),
  sol: [Con FI = $f_"FI"$ y oscilador por encima, la imagen está en $f_"señal" + 2 f_"FI"$: dos veces la FI por encima (o por debajo, si el oscilador va por debajo) de la sintonizada.],
)

#q("T4.13", "a",
  [La relación señal/ruido de un receptor:],
  ([es una característica indicativa de su calidad y se expresa en decibelios], [se mide en vatios], [solo importa en transmisión], [es independiente del propio receptor]),
  sol: [La relación señal/ruido, en dB, indica cuánto sobresale la señal del ruido del receptor: es una medida directa de la calidad del equipo.],
)

#q("T4.14", "c",
  [En un receptor, la capacidad de mantener la frecuencia sintonizada se denomina:],
  ([sensibilidad], [selectividad], [estabilidad], [fidelidad]),
  sol: [Estabilidad: capacidad de mantener la frecuencia sintonizada sin deriva (térmica o mecánica).],
)

#q("T4.15", "b",
  [El mando NB (_noise blanker_) de un transceptor sirve para:],
  ([aumentar el nivel de los graves], [suprimir ruidos impulsivos], [bloquear el transmisor], [activar la doble conversión]),
  sol: [El noise blanker recorta los picos de ruido impulsivo (encendidos de motores, tormentas próximas) antes de la detección.],
)

#q("T4.16", "a",
  [Se denomina receptor superheterodino de doble conversión al receptor que:],
  ([tiene dos frecuencias intermedias independientes], [usa dos antenas], [demodula dos veces la misma señal de audio], [duplica la frecuencia del oscilador local]),
  sol: [El superheterodino de doble conversión usa dos FI independientes: la primera alta (buen rechazo de imagen) y la segunda baja (buena selectividad).],
)

#q("T4.17", "d",
  [El margen dinámico de un receptor queda determinado fundamentalmente en:],
  ([el amplificador de audio], [el altavoz], [el filtro de red], [el primer mezclador de entrada]),
  sol: [El margen dinámico — la capacidad de tratar a la vez señales muy fuertes y muy débiles sin distorsión — lo limita sobre todo el primer mezclador de entrada.],
)

// =====================================================================
== Preguntas sobre esquemas <t4-sec-esquemas>

#ojo(titulo: [cómo leer un diagrama de bloques del examen])[
  Recorre el diagrama siguiendo la señal y comprueba tres parejas que nunca se separan: *mezclador ↔ oscilador local* (sin oscilador no hay FI), *detector de producto ↔ BFO* (SSB y CW) y *limitador ↔ discriminador* (FM). Un lazo que vuelve hacia atrás desde el detector es el CAG. Para las frecuencias, aplica la receta de @t4-fig-14200: con el oscilador por encima, $f_s = f_"OL" - f_"FI"$; por debajo, $f_s = f_"OL" + f_"FI"$.
]

#q("T4.18", "b",
  [En el diagrama de bloques de un receptor de FM de la figura, para que el conjunto funcione falta:
  #circuito[
    #_t4-diagrama(
      spacing: (6mm, 8mm),
      node((0, 0), _t4-ant, stroke: none, fill: none),
      node((1, 0), _t4-t[ampl. RF], shape: rect),
      node((2, 0), _t4-t[mezclador], shape: rect),
      node((3, 0), _t4-t[ampl. FI], shape: rect),
      node((4, 0), _t4-t[limitador], shape: rect),
      node((5, 0), _t4-t[discrimi-\ nador], shape: rect),
      node((6, 0), _t4-t[ampl. BF], shape: rect),
      _t4-preg((2, 1)),
      edge((0, 0), (1, 0), "-|>"),
      edge((1, 0), (2, 0), "-|>"),
      edge((2, 0), (3, 0), "-|>"),
      edge((3, 0), (4, 0), "-|>"),
      edge((4, 0), (5, 0), "-|>"),
      edge((5, 0), (6, 0), "-|>"),
      edge((2, 1), (2, 0), "-|>", stroke: 0.6pt + col.naranja, dash: "dashed"),
    )
  ]],
  ([un altavoz de graves], [un oscilador], [una segunda antena], [un amplificador de audio adicional]),
  sol: [Al mezclador de la cadena le falta su pareja obligada: el oscilador local. Sin él no hay conversión a la FI y el receptor no funciona.],
)

#q("T4.19", "a",
  [Dos receptores A y B tienen, a la frecuencia intermedia, las curvas de respuesta de la figura. Se puede afirmar que:
  #circuito[
    #cetz.canvas(length: 1cm, {
      import cetz.draw: *
      ejes(0, 8, 0, 3.4, etq-x: $f$, etq-y: [respuesta])
      onda(x => 2.2 * calc.exp(-calc.pow((x - 4) / 1.3, 2)), 0.3, 7.7, stroke: (paint: col.naranja, thickness: 1pt, dash: "dashed"))
      onda(x => 2.8 * calc.exp(-calc.pow((x - 4) / 0.35, 2)), 0.3, 7.7, stroke: 1.2pt + col.senal1)
      line((4, 0), (4, 2.8), stroke: (dash: "dotted", thickness: 0.5pt))
      content((4, 3.05), text(font: fuente-sans, size: 8pt, fill: col.senal1)[A])
      content((5.8, 1.35), text(font: fuente-sans, size: 8pt, fill: col.naranja)[B])
      content((4, -0.12), anchor: "north", text(font: fuente-sans, size: 7.5pt)[FI])
    })
  ]],
  ([el receptor A es más selectivo que el receptor B], [el receptor B es más selectivo que el receptor A], [ambos tienen la misma selectividad], [el receptor A no puede recibir señales]),
  sol: [La curva de A es más estrecha: separa mejor las señales próximas en frecuencia, que es exactamente la definición de selectividad. La curva ancha de B deja pasar también los canales adyacentes.],
)

#q("T4.20", "c",
  [En el esquema de la figura, con el oscilador local funcionando por debajo de la frecuencia de la señal, la frecuencia $F$ sintonizada por el receptor es:
  #circuito[
    #_t4-diagrama(
      spacing: (16mm, 8mm),
      node((0, 0), _t4-ant, stroke: none, fill: none),
      _t4-mez((1, 0)),
      node((2, 0), _t4-t[ampl. FI\ 9 MHz], shape: rect),
      node((1, 1), _t4-t[oscilador local\ 5,2 MHz], shape: rect),
      edge((0, 0), (1, 0), "-|>", _t4-t[$F = ?$], label-side: left),
      edge((1, 0), (2, 0), "-|>"),
      edge((1, 1), (1, 0), "-|>"),
    )
  ]],
  ([3,8 MHz], [9 MHz], [14,2 MHz], [46,8 MHz]),
  sol: [Con el oscilador por debajo de la señal, $F = f_"OL" + f_"FI" = 5,2 + 9 = 14,2$ MHz. El distractor de 3,8 MHz es la resta $9 - 5,2$: una señal de 3,8 MHz también caería en la FI de 9 MHz, pero por el producto suma del mezclador ($3,8 + 5,2 = 9$ MHz), con el oscilador por encima de la señal — la ambigüedad que resuelve el enunciado al fijar el oscilador por debajo.],
)

#q("T4.21", "c",
  [El mando RIT de un transceptor permite:],
  ([reducir el ruido de impulsos], [ajustar la ganancia de radiofrecuencia], [variar la frecuencia de recepción sin alterar la de transmisión], [conmutar entre banda lateral superior e inferior]),
  sol: [Del inglés _receiver incremental tuning_. Permite corregir a la estación corresponsal que llega ligeramente desplazada sin moverse uno de la frecuencia en que transmite, de modo que los demás nos sigan oyendo donde esperan.],
)

#q("T4.22", "a",
  [Actuando sobre el mando «RF GAIN» de un receptor se modifica:],
  ([la ganancia de las etapas de radiofrecuencia], [el volumen del altavoz], [la anchura del filtro de frecuencia intermedia], [la frecuencia del oscilador local]),
  sol: [Reduce la amplificación de las primeras etapas. Con señales muy fuertes conviene bajarlo para no saturar la entrada y evitar la intermodulación; el volumen, en cambio, actúa al final de la cadena, sobre el audio.],
)

#q("T4.23", "d",
  [El mando «NB» (_noise blanker_) de un receptor se emplea para:],
  ([aumentar la sensibilidad en las bandas altas], [estrechar el filtro de audio], [compensar la deriva del oscilador], [suprimir los ruidos producidos por impulsos]),
  sol: [Está pensado para el ruido impulsivo —encendido de un motor, una valla eléctrica, ciertos electrodomésticos—, que llega como pulsos muy cortos y de gran amplitud. El circuito los detecta y silencia el receptor durante ese instante.],
)

#q("T4.24", "b",
  [Para poder recibir señales de la banda de 2 metros con un receptor de decamétricas es necesario intercalar:],
  ([un atenuador de entrada], [un conversor], [un amplificador de audio], [un filtro de paso bajo]),
  sol: [El conversor traslada en bloque la banda de 144 MHz a una frecuencia que el receptor de HF sí sintoniza, mezclándola con un oscilador propio. Es la misma idea del superheterodino, aplicada por delante de un receptor que ya existe.],
)

#q("T4.25", "c",
  [Al pasar el mando de modo de un transceptor de LSB a USB se cambia:],
  ([de telegrafía a fonía], [de modulación de amplitud a modulación de frecuencia], [de banda lateral inferior a banda lateral superior], [de recepción a transmisión]),
  sol: [LSB y USB son las siglas inglesas de banda lateral inferior y superior. Por costumbre se emplea LSB en las bandas de 160, 80 y 40 metros y USB de 20 metros hacia arriba, además de en VHF y UHF.],
)

#q("T4.26", "a",
  [El filtro de selectividad variable de un receptor se ajusta a su anchura de banda más estrecha cuando se recibe:],
  ([telegrafía], [banda lateral única], [modulación de frecuencia], [una emisión de televisión]),
  sol: [Una emisión de telegrafía ocupa muy poco espectro, así que cuanto más se estreche el filtro menos ruido y menos estaciones vecinas entran. Para SSB hace falta unos 2,4 kHz y para FM bastante más: estrechar de más cortaría la propia señal.],
)

#q("T4.27", "b",
  [El empleo de procesadores digitales de señal (DSP) en un transceptor moderno permite, entre otras cosas:],
  ([aumentar la potencia de salida], [optimizar los filtros del equipo por medios digitales], [prescindir de la antena], [eliminar la etapa de frecuencia intermedia]),
  sol: [El DSP trabaja con la señal ya digitalizada, de modo que los filtros dejan de ser cristales físicos y pasan a ser cálculo: se puede variar su anchura y su forma sobre la marcha, cancelar ruido o suprimir un tono interferente sin tocar un solo componente.],
)

#q("T4.28", "c",
  [La etapa de frecuencia intermedia de un receptor superheterodino está compuesta básicamente por:],
  ([osciladores y mezcladores], [rectificadores y reguladores], [amplificadores y filtros], [detectores y altavoces]),
  sol: [Es donde el receptor hace la mayor parte de su trabajo: a frecuencia fija resulta mucho más fácil conseguir mucha ganancia y filtros muy selectivos que a la frecuencia variable de entrada. Esa es toda la idea del superheterodino.],
)

#q("T4.29", "d",
  [En la cadena de un receptor superheterodino, la etapa de frecuencia intermedia recibe la señal de:],
  ([la antena, directamente], [el detector], [el amplificador de audio], [el mezclador]),
  sol: [El orden de la cadena es antena, amplificador de RF, mezclador, frecuencia intermedia, detector y audio. La FI se alimenta de lo que el mezclador entrega tras batir la señal con el oscilador local.],
)

#q("T4.30", "a",
  [La sensibilidad de un receptor viene determinada fundamentalmente por:],
  ([su primera etapa de radiofrecuencia], [la potencia del amplificador de audio], [el tamaño del altavoz], [la tensión de alimentación]),
  sol: [El ruido que añade la primera etapa se amplifica después junto con la señal, así que su figura de ruido condiciona toda la cadena — es lo que expresa la fórmula de Friis. Mejorar etapas posteriores apenas sirve si la primera es ruidosa.],
)

#q("T4.31", "b",
  [La selectividad de un receptor superheterodino depende principalmente de:],
  ([la longitud de la línea de antena], [las etapas de frecuencia intermedia], [la ganancia del amplificador de audio], [la impedancia de salida]),
  sol: [Los filtros de FI son los que deciden qué anchura de banda pasa y con qué pendiente se cortan las señales vecinas. La sintonía de entrada apenas discrimina entre canales próximos.],
)

#q("T4.32", "c",
  [Se entiende por estabilidad de un receptor:],
  ([su capacidad para soportar sobrecargas], [la firmeza de su montaje mecánico], [que no se desintoniza con el tiempo ni con la temperatura], [la constancia de su consumo]),
  sol: [Un receptor estable mantiene la frecuencia sintonizada aunque pasen las horas y cambie la temperatura. Es especialmente crítico en SSB y CW, donde una deriva de pocos cientos de hercios ya hace ininteligible la señal.],
)

#q("T4.33", "a",
  [El llamado ruido estático que se percibe en un receptor está producido por:],
  ([las descargas eléctricas atmosféricas], [el propio amplificador de audio], [la resistencia de la antena], [la tensión de la red eléctrica]),
  sol: [Es el QRN: el crepitar de fondo que producen los rayos, incluso de tormentas muy lejanas, y que domina las bandas bajas en verano. No lo genera el receptor, sino que llega por la antena.],
)

#q("T4.34", "d",
  [En un receptor, el oscilador de frecuencia de batido (BFO) resulta imprescindible para recibir emisiones de:],
  ([modulación de frecuencia], [amplitud modulada con portadora], [televisión de aficionado], [telegrafía y banda lateral única]),
  sol: [Ni la telegrafía ni la banda lateral única llevan portadora, así que el receptor tiene que reponerla localmente para que el detector de producto entregue audio. En AM con portadora y en FM el BFO no hace falta.],
)

#q("T4.35", "c",
  [La anchura de banda típica de una emisión de FM de banda estrecha (NBFM), como la empleada en VHF, es del orden de:],
  ([2,4 kHz], [200 kHz], [12 kHz], [6 MHz]),
  sol: [Frente a los 200 kHz de la FM de radiodifusión, la FM de banda estrecha del servicio de aficionados ocupa unos 12 kHz, con una desviación de unos 5 kHz. Los 2,4 kHz corresponden a un canal de SSB.],
)

// =====================================================================
== Más preguntas sobre esquemas <t4-sec-mas-esquemas>

#q("T4.36", "a",
  [En el diagrama de bloques de la figura, correspondiente a un receptor superheterodino, el bloque señalado con una interrogación es:
  #circuito[
    #_t4-diagrama(
      spacing: (8mm, 8mm),
      node((0, 0), _t4-t[antena], stroke: none, fill: none),
      node((1, 0), _t4-t[ampl.\ RF], shape: rect),
      node((2, 0), _t4-t[mezclador], shape: rect),
      node((3, 0), _t4-t[FI], shape: rect, width: 13mm),
      node((4, 0), _t4-t[detector], shape: rect),
      node((5, 0), _t4-t[audio], shape: rect, width: 13mm),
      _t4-preg((2, 1)),
      edge((0, 0), (1, 0), "-|>"),
      edge((1, 0), (2, 0), "-|>"),
      edge((2, 0), (3, 0), "-|>"),
      edge((3, 0), (4, 0), "-|>"),
      edge((4, 0), (5, 0), "-|>"),
      edge((2, 1), (2, 0), "-|>"),
    )
  ]],
  ([el oscilador local], [el altavoz], [la fuente de alimentación], [el silenciador]),
  sol: [Lo que alimenta al mezclador junto con la señal de antena es el oscilador local: de su batido sale la frecuencia intermedia. Sin él no hay conversión y el superheterodino no funciona.],
)

#q("T4.37", "b",
  [En el diagrama de la figura, el bloque señalado con una interrogación toma muestra de la señal detectada y actúa sobre las etapas de radiofrecuencia y de frecuencia intermedia. Se trata de:
  #circuito[
    #_t4-diagrama(
      spacing: (10mm, 8mm),
      node((0, 0), _t4-t[ampl.\ RF], shape: rect),
      node((1, 0), _t4-t[FI], shape: rect, width: 13mm),
      node((2, 0), _t4-t[detector], shape: rect),
      node((3, 0), _t4-t[audio], shape: rect, width: 13mm),
      _t4-preg((1.5, 1)),
      edge((0, 0), (1, 0), "-|>"),
      edge((1, 0), (2, 0), "-|>"),
      edge((2, 0), (3, 0), "-|>"),
      edge((2, 0), (2, 1), (1.5, 1), "-"),
      edge((1.5, 1), (0, 1), (0, 0), "-|>"),
      edge((1, 1), (1, 0), "-|>"),
    )
  ]],
  ([el oscilador de batido], [el control automático de ganancia], [el limitador de ruido], [el filtro de paso bajo]),
  sol: [Ese lazo que va del detector hacia atrás es el control automático de ganancia: mide cuánta señal está llegando y reduce la amplificación de las primeras etapas cuando es fuerte, de modo que el volumen de salida se mantenga razonablemente constante.],
)

#q("T4.38", "d",
  [Con los datos del esquema de la figura, y trabajando el oscilador local por encima de la señal, la frecuencia $F$ sintonizada por el receptor es:
  #circuito[
    #_t4-diagrama(
      spacing: (14mm, 8mm),
      node((0, 0), _t4-t[antena ($F$?)], stroke: none, fill: none),
      node((1, 0), _t4-t[mezclador], shape: rect),
      node((2, 0), _t4-t[FI\ 455 kHz], shape: rect),
      node((1, 1), _t4-t[oscilador local\ 14,655 MHz], shape: rect),
      edge((0, 0), (1, 0), "-|>"),
      edge((1, 0), (2, 0), "-|>"),
      edge((1, 1), (1, 0), "-|>"),
    )
  ]],
  ([15,11 MHz], [14,655 MHz], [455 kHz], [14,2 MHz]),
  sol: [Con el oscilador local por encima de la señal, $F = f_"OL" - f_"FI" = 14,655 - 0,455 = 14,2$ MHz. Los 15,11 MHz son la frecuencia imagen, situada dos veces la FI por encima de la sintonizada.],
)

#q("T4.39", "b",
  [En el esquema de la figura, el bloque señalado con una interrogación es el que fija la anchura de banda que el receptor deja pasar. Se trata de:
  #circuito[
    #_t4-diagrama(
      spacing: (10mm, 8mm),
      node((0, 0), [], stroke: none, fill: none),
      node((1, 0), _t4-t[mezclador], shape: rect),
      _t4-preg((2, 0)),
      node((3, 0), _t4-t[ampl. FI], shape: rect),
      node((4, 0), _t4-t[detector], shape: rect),
      edge((0, 0), (1, 0), "-|>"),
      edge((1, 0), (2, 0), "-|>"),
      edge((2, 0), (3, 0), "-|>"),
      edge((3, 0), (4, 0), "-|>"),
    )
  ]],
  ([un amplificador de audio], [un filtro de frecuencia intermedia], [un multiplicador de frecuencia], [una fuente de alimentación]),
  sol: [Es el filtro de frecuencia intermedia, y de su anchura depende la selectividad del receptor: unos 2,4 kHz para SSB, mucho menos para telegrafía y bastante más para FM. Trabaja a frecuencia fija, que es lo que permite hacerlo tan selectivo.],
)

#q("T4.40", "d",
  [El tramo final de receptor representado en la figura permite recibir emisiones de tipo:
  #circuito[
    #_t4-diagrama(
      spacing: (10mm, 8mm),
      node((0, 0), [], stroke: none, fill: none),
      node((1, 0), _t4-t[ampl. FI], shape: rect),
      node((2, 0), _t4-t[detector de\ producto], shape: rect),
      node((3, 0), _t4-t[audio], shape: rect, width: 13mm),
      node((2, 1), _t4-t[oscilador de\ batido (BFO)], shape: rect),
      edge((0, 0), (1, 0), "-|>"),
      edge((1, 0), (2, 0), "-|>"),
      edge((2, 0), (3, 0), "-|>"),
      edge((2, 1), (2, 0), "-|>"),
    )
  ]],
  ([modulación de frecuencia], [televisión de aficionado], [amplitud modulada con portadora], [banda lateral única y telegrafía]),
  sol: [El detector de producto con su oscilador de batido repone la portadora que la emisión no lleva. Eso es exactamente lo que necesitan la banda lateral única y la telegrafía; para AM con portadora bastaría un detector de envolvente, y para FM haría falta un discriminador.],
)
