#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Utilidades locales del tema T6 (prefijo _t6-)
// ---------------------------------------------------------------------
// Etiqueta de texto pequeña en un lienzo
#let _t6-et(pos, cuerpo, anchor: "center", size: 8pt, fill: black) = cetz.draw.content(pos, anchor: anchor, text(size: size, fill: fill, cuerpo))
// Puntos de un diagrama polar r(a) entre los ángulos a0 y a1
#let _t6-pts(r, a0, a1, n: 180, cx: 0, cy: 0) = range(n + 1).map(i => {
  let a = a0 + (a1 - a0) * i / n
  let v = r(a)
  (cx + v * calc.cos(a), cy + v * calc.sin(a))
})
// Rejilla polar: circunferencias y radios cada 30°
#let _t6-rejilla(radios, rmax, cx: 0, cy: 0, paso: 30deg) = {
  import cetz.draw: *
  let st = 0.4pt + col.gris.lighten(60%)
  for rr in radios { circle((cx, cy), radius: rr, stroke: st) }
  for k in range(int(360deg / paso)) {
    let a = k * paso
    line((cx, cy), (cx + rmax * calc.cos(a), cy + rmax * calc.sin(a)), stroke: st)
  }
}
// Diagrama de dipolo de media onda: campo relativo a un ángulo a del eje del hilo
#let _t6-dip(a) = {
  let s = calc.abs(calc.sin(a))
  if s < 0.001 { 0 } else { calc.abs(calc.cos(calc.pi / 2 * calc.cos(a)) / s) }
}
// Hilo de antena
#let _t6-hilo = (stroke: 1.8pt + col.naranja)

#tema("T6", "Antenas y líneas de transmisión", alcance: [Tipos de antena: dipolo de media onda (alimentado en el centro o en un extremo), dipolo plegado, vertical de cuarto de onda, plano de tierra, Yagi, antenas de apertura, dipolo con trampas · características: impedancia, polarización, ganancia, directividad, potencia efectiva radiada · líneas de transmisión: paralela, coaxial, guiaondas, impedancia característica, ROE, pérdidas, balun, acopladores.])

#motivacion(titulo: [Tres problemas entre la caja y el cielo])[
  El transmisor fabrica cien vatios de radiofrecuencia dentro de una caja. Para que alguien los oiga a mil kilómetros hay que resolver tres problemas, y este tema los trata por orden:
  + *Lanzar* esa energía al espacio en forma de onda: es el trabajo de la *antena*.
  + *Llevarla* desde la caja hasta la antena, que suele estar en el tejado, sin perderla por el camino: es el trabajo de la *línea de transmisión*.
  + Conseguir que transmisor, línea y antena «se entiendan», es decir, que la energía no rebote en ninguna unión: es la *adaptación de impedancias*.
  Los fundamentos —cómo radia una corriente que oscila, qué son la impedancia y la resonancia— están en #ver(<sec-antena>), #ver(<sec-impedancia>) y #ver(<sec-resonancia>). Aquí se da el tratamiento de examen, con las cifras y las trampas que el banco de preguntas usa.
]

== El dipolo y otras antenas <t6-sec-dipolo>

Una antena es un conductor en el que la corriente de RF forma una *onda estacionaria*; cuando su longitud «encaja» con la frecuencia, la antena *resuena* y su impedancia de alimentación se vuelve resistiva pura. El patrón es el *dipolo de media onda*: en sus extremos la corriente es forzosamente nula y la tensión máxima, así que a $lambda\/2$ la corriente presenta un vientre justo en el centro (@t6-fig-dipolo[figura]). Alimentarlo ahí — mucha corriente, poca tensión — da una impedancia baja, ∼73 Ω; alimentarlo en un extremo, la situación opuesta, da impedancias de miles de ohmios. Si la antena es más corta de lo que la resonancia pide, presenta reactancia _capacitiva_; si es más larga, _inductiva_ — y de ahí la regla de taller: para bajar la frecuencia de resonancia, alargar.

=== Por qué el dipolo resuena a media onda

En un hilo abierto por los dos extremos, la corriente no tiene adónde ir cuando llega a la punta: la carga se amontona allí y la corriente vuelve hacia atrás. La onda que va y la que vuelve se superponen y forman una onda estacionaria, con puntos fijos de corriente nula (*nodos*) y puntos fijos de corriente máxima (*vientres*). El hilo impone una condición: en las dos puntas la corriente tiene que ser cero. El dibujo de la onda estacionaria va de nodo a nodo en media longitud de onda. Por eso la longitud más corta que «encaja», con un nodo en cada punta, es justo $lambda\/2$, con un único vientre de corriente en el centro.

#analogia[Una cuerda de guitarra está sujeta por los dos extremos y allí no puede moverse. Solo vibra con ganas a las frecuencias cuya media onda cabe un número entero de veces en la cuerda; la más baja —la nota fundamental— es la que cabe una sola vez. El dipolo hace lo mismo con la corriente: sus «puntos fijos» son las dos puntas, donde la corriente es nula. Y, como la cuerda, también resuena en los armónicos: alimentado en el centro, vuelve a dar una impedancia baja cuando mide $3 lambda\/2$, $5 lambda\/2$ y así sucesivamente. Por eso un dipolo de 40 m (7 MHz) sirve también en 15 m (21 MHz, el triple). Cuando mide una onda completa, en cambio, el centro cae en un nodo de corriente y la impedancia allí es altísima.]

#circuito(caption: [Dipolo de media onda alimentado en el centro: la corriente es máxima en el punto de alimentación y nula en los extremos, y la tensión al revés. Por eso la impedancia en el centro es baja (∼73 Ω, resistiva en resonancia) y muy alta en los extremos.])[
  #cetz.canvas({
    import cetz.draw: *
    // cota λ/2
    line((0, 0.15), (0, 2.45), stroke: 0.4pt + col.gris.lighten(40%))
    line((10, 0.15), (10, 2.45), stroke: 0.4pt + col.gris.lighten(40%))
    line((0, 2.3), (10, 2.3), mark: (start: ">", end: ">", fill: col.gris), stroke: 0.5pt + col.gris)
    _t6-et((5, 2.3), text(fill: col.gris, $lambda\/2$), anchor: "south")
    // corriente (verde) y tensión (roja discontinua)
    onda(x => 1.7 * calc.cos(calc.pi * (x - 5) / 10), 0, 10, stroke: 1.1pt + col.senal3)
    onda(x => 1.45 * calc.sin(calc.pi * (x - 5) / 10), 0, 10, stroke: (paint: col.senal2, thickness: 1pt, dash: "dashed"))
    // hilo del dipolo
    line((0, 0), (4.85, 0), .._t6-hilo)
    line((5.15, 0), (10, 0), .._t6-hilo)
    // punto de alimentación
    line((4.85, 0), (4.85, -0.75), stroke: 0.7pt)
    line((5.15, 0), (5.15, -0.75), stroke: 0.7pt)
    _t6-et((5, -0.85), [punto de alimentación (∼73 Ω)], anchor: "north")
    _t6-et((5, 1.75), text(fill: col.senal3)[$I_"máx"$], anchor: "south")
    _t6-et((10.1, 1.45), text(fill: col.senal2)[$+V_"máx"$], anchor: "west")
    _t6-et((-0.1, -1.45), text(fill: col.senal2)[$-V_"máx"$], anchor: "east")
    // leyenda
    line((1.2, -2.0), (1.9, -2.0), stroke: 1.1pt + col.senal3)
    _t6-et((2.0, -2.0), [corriente $I$ (máx. en el centro)], anchor: "west")
    line((5.8, -2.0), (6.5, -2.0), stroke: (paint: col.senal2, thickness: 1pt, dash: "dashed"))
    _t6-et((6.6, -2.0), [tensión $V$ (máx. en los extremos)], anchor: "west")
  })
] <t6-fig-dipolo>

#porque[
  - *En las puntas* la corriente no puede seguir: $I = 0$. Allí se acumula la carga, y por eso la tensión es máxima.
  - *En el centro* pasa toda la corriente que va y viene entre los dos brazos: $I$ es máxima y $V$ mínima. La impedancia es $Z = V\/I$: tensión pequeña dividida entre corriente grande da un valor bajo, unos 73 Ω.
  - *Por qué resistiva*: a la frecuencia de resonancia, la energía almacenada en el campo magnético (la corriente) y en el eléctrico (las cargas de las puntas) se pasan de uno a otro sin pedir nada al generador. Lo único que el generador «ve» es la energía que se escapa como onda, y eso se comporta como una resistencia.
]

#ptitulo[La longitud práctica] La longitud de onda en metros es $lambda = 300\/f$ (con $f$ en MHz), así que media onda mide $150\/f$. Un dipolo real de hilo se corta un 5 % más corto, porque la capacidad de las puntas lo alarga eléctricamente (el _factor de acortamiento_):

#destacada($display(L ("m") approx 143 / (f ("MHz")))$, nota: [longitud total de un dipolo de media onda de hilo, alimentado en el centro])

#ejemplo(titulo: [Dipolo para la banda de 40 m])[
  A 7,1 MHz: $lambda = 300\/7,1 approx 42,3$ m; media onda ideal, $21,1$ m; con el acortamiento, $L approx 143\/7,1 approx 20,1$ m, es decir, unos 10 m por brazo. Para 2 m (145 MHz): $L approx 143\/145 approx 0,99$ m. «40 m» es el nombre de la banda (la longitud de onda), no el de la antena: es la trampa de la pregunta T6.1.
]

=== Fuera de resonancia: el dipolo como circuito RLC

Cerca de su resonancia, un dipolo se comporta exactamente como un circuito RLC en serie (@t6-fig-rlc[figura]). La corriente que recorre el hilo crea un campo magnético: eso es una inductancia $L$. Los dos brazos, con cargas opuestas en las puntas, forman un condensador $C$. Y la energía que se va como onda, más la que se pierde en calor, es una resistencia. Con esta imagen, todo lo que el examen pregunta sobre resonancia sale de #ver(<sec-resonancia>).

#circuito(caption: [Circuito equivalente de una antena cerca de su resonancia: $R_r$ (radiación) y $R_p$ (pérdidas) en serie con la inductancia y la capacidad del hilo. En resonancia, $X_L = X_C$ y solo queda $R_r + R_p$.], sim: "res-series.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, rect
    acvsource("g", (0, 0), (0, 2.6))
    content((-0.75, 1.3), text(size: 8pt)[TX])
    wire((0, 2.6), (1.4, 2.6))
    wire((0, 0), (1.4, 0))
    node("b1", (1.4, 2.6), fill: false)
    node("b2", (1.4, 0), fill: false)
    wire((1.4, 2.6), (2.2, 2.6))
    resistor("rr", (2.2, 2.6), (4, 2.6), label: $R_r$)
    resistor("rp", (4, 2.6), (5.8, 2.6), label: $R_p$)
    inductor("l", (5.8, 2.6), (7.6, 2.6), label: $L$)
    wire((7.6, 2.6), (8.2, 2.6))
    capacitor("c", (8.2, 2.6), (8.2, 0), label: $C$)
    wire((8.2, 0), (1.4, 0))
    rect((1.9, -0.45), (9.0, 3.75), stroke: (dash: "dashed", paint: col.gris, thickness: 0.5pt))
    content((5.45, -0.75), text(size: 8pt, fill: col.gris)[la antena, vista desde sus bornes])
  })
] <t6-fig-rlc>

#porque[
  - *Antena demasiado corta* (frecuencia por debajo de su resonancia): manda la reactancia del condensador, $X_C = 1\/(2 pi f C)$, que es grande a frecuencia baja. La antena es *capacitiva*.
  - *Antena demasiado larga* (frecuencia por encima): manda $X_L = 2 pi f L$. La antena es *inductiva*.
  - *En resonancia*, $X_L = X_C$ y se anulan: el generador solo ve $R_r + R_p$, una *resistencia pura* (preguntas T6.2 y T6.21).
  - *Alargar el hilo* aumenta $L$ y $C$; como $f_0 = 1\/(2 pi sqrt(L C))$, la frecuencia de resonancia baja. Esa es la regla de taller: para bajar la frecuencia, alargar; para subirla, acortar.
]

#ejemplo(titulo: [Pasar de 29 900 kHz a 28 500 kHz])[
  La longitud va en proporción inversa a la frecuencia: $L_"nueva" = L dot 29,9\/28,5 approx 1,049 L$. Hay que *alargar* la antena un 5 %. En una vertical de cuarto de onda de $71,5\/29,9 approx 2,39$ m, son unos 12 cm más (pregunta T6.3).
]

=== La impedancia en el punto de alimentación

La impedancia en un punto del dipolo es el cociente entre la tensión y la corriente que hay en ese punto. La @t6-fig-dipolo[figura] lo dice todo: en el centro, poca tensión y mucha corriente; hacia las puntas, cada vez más tensión y menos corriente. Por eso la impedancia sube a medida que el punto de alimentación se aleja del centro:

- *En el centro*: unos 73 Ω en el espacio libre. Es un valor cómodo, porque un coaxial de 50 o de 75 Ω lo alimenta con una ROE baja.
- *Descentrado*: alimentado a un tercio de un extremo, el dipolo ronda los 200 Ω. Es el dipolo «Windom» o *OCF* (_off-centre fed_), que se alimenta con un balun 4:1 y resuena en varias bandas.
- *En un extremo*: varios miles de ohmios (de 2000 a 5000 Ω, según la altura y el diámetro del hilo). La antena de media onda alimentada por un extremo (_EFHW_) necesita un transformador de relación alta, típicamente 49:1, para bajar a 50 Ω.

#ptitulo[Por qué cambia con la altura] Los 73 Ω son el valor del dipolo *en el espacio libre*. Sobre el suelo, la onda que la antena envía hacia abajo se refleja y vuelve a la antena: el suelo actúa como un espejo que crea un dipolo «imagen» bajo tierra. La onda que vuelve induce en el hilo una corriente que se suma o se resta a la propia, según el tiempo que tarde en ir y volver (es decir, según la altura). Si la corriente sube con la misma tensión, la impedancia baja, y al revés. Muy cerca del suelo (por debajo de unos $lambda\/8$) la impedancia cae mucho; entre $lambda\/4$ y una longitud de onda de altura oscila por encima y por debajo de 73 Ω, aproximadamente entre 60 y 100 Ω; y a varias longitudes de onda se asienta en el valor del espacio libre. En la práctica, un dipolo de HF a una altura normal presenta entre 50 y 80 Ω.

#ptitulo[La V invertida] Si el dipolo cuelga de un único mástil central y los brazos caen hacia abajo, la impedancia baja a unos 50 Ω (justo lo que pide el coaxial) y el diagrama se vuelve más uniforme, casi omnidireccional. La ventaja principal es mecánica: un solo soporte en lugar de dos (pregunta T6.28).

#ojo[
  - T6.36 pregunta por el dipolo «en el espacio libre»: son *73 Ω*. Los 300 Ω son del dipolo *plegado*, los 600 Ω de una línea bifilar abierta, y los 50 Ω, del coaxial.
  - T6.1: el dipolo de media onda para 40 m mide unos *20 m*, no 40.
  - T6.2 y T6.21: resonancia = impedancia *resistiva pura*. No es «longitud múltiplo exacto de $lambda$» ni «ganancia máxima».
]

=== La resistencia de radiación y el rendimiento

Vista desde el generador, la antena es una impedancia con dos partes resistivas de origen muy distinto: la *resistencia de radiación* $R_r$ — una resistencia ficticia que contabiliza la potencia que escapa como onda, $P_"rad" = I^2 R_r$ — y la de pérdidas óhmicas $R_p$. El rendimiento es $eta = R_r \/ (R_r + R_p)$: en un dipolo de HF, con $R_r approx 73$ Ω, unas pérdidas de pocos ohmios apenas pesan; en una antena corta de móvil, con $R_r$ de un par de ohmios, la misma pérdida se come la mitad de la potencia.

#idea[La resistencia de radiación no calienta nada: es la forma de contar, con la fórmula de una resistencia, la potencia que *sale* de la antena como onda. Las dos resistencias están en serie y las recorre la misma corriente, así que la potencia se reparte en proporción a sus valores.]

#ejemplo(titulo: [Dipolo frente a antena corta de móvil, con 100 W])[
  - Dipolo de HF: $R_r = 73$ Ω, $R_p = 2$ Ω. $eta = 73\/75 approx 0,97$: radia 97 W y calienta 3 W.
  - Antena corta de móvil (látigo con bobina): $R_r = 2$ Ω, y entre la bobina y la masa del coche, $R_p = 2$ Ω. $eta = 2\/4 = 0,5$: radia 50 W y los otros 50 W calientan la bobina.
  Por eso, en una antena corta, cada ohmio de pérdidas cuenta: bobina de hilo grueso, buenas conexiones y una masa bien hecha.
]

=== Las variantes del temario

De esa base salen las variantes del temario. El *dipolo plegado* cierra el hilo sobre sí mismo: misma resonancia, pero los dos conductores se reparten la corriente y, como para radiar la misma potencia basta la mitad de corriente, y $P = I^2 R$ exige entonces cuadruplicar la resistencia, la impedancia se multiplica por cuatro (∼300 Ω). El *dipolo con trampas* intercala circuitos resonantes LC que, a su frecuencia, aíslan el tramo exterior de cada brazo: la longitud efectiva cambia con la banda y una sola antena resuena en varias. La *vertical de cuarto de onda* es medio dipolo puesto en pie: el suelo (o un juego de radiales, el _plano de tierra_) actúa de espejo y aporta la mitad que falta; como radia solo hacia el hemisferio superior, para la misma corriente entrega la mitad de potencia que el dipolo completo y su resistencia de radiación es la mitad, ∼36 Ω (justo 73/2); su polarización es vertical y radia con máximo en el plano horizontal. La *Yagi* añade al elemento alimentado *elementos parásitos* — un reflector algo más largo detrás y directores algo más cortos delante — que reirradian y, por interferencia, concentran la energía en una dirección. Y en microondas mandan las antenas de *apertura*: bocinas y reflectores parabólicos.

==== El dipolo plegado

Los dos conductores del dipolo plegado están muy juntos (a una fracción mínima de $lambda$) y las corrientes en los dos van en el mismo sentido: radian como un solo dipolo. El generador solo alimenta uno de los dos hilos, y la mitad de la corriente total pasa por el otro. Para radiar la misma potencia con la mitad de corriente en los bornes, la resistencia vista tiene que ser cuatro veces mayor: $4 times 73 approx 292 approx 300$ Ω. Además de casar con la línea bifilar de 300 Ω, tiene un ancho de banda algo mayor que el dipolo simple, y es el elemento alimentado de muchas Yagi, porque los elementos parásitos bajan su impedancia y el plegado la vuelve a subir.

==== Trampas y bobinas de carga

#motivacion[Un dipolo resuena en una sola banda (y en sus armónicos impares). Un aficionado quiere trabajar 40 y 20 m con un único hilo. ¿Cómo consigue que el mismo hilo «mida» 20 m en una banda y 10 m en la otra?]

#circuito(caption: [Dipolo con trampas para 7 y 14 MHz. Cada trampa es un circuito LC en paralelo que resuena a 14 MHz.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    // brazos interiores
    line((-0.25, 0), (-2.8, 0), .._t6-hilo)
    line((0.25, 0), (2.8, 0), .._t6-hilo)
    // trampa izquierda
    inductor("l1", (-2.8, 0), (-4.2, 0))
    wire((-2.8, 0), (-2.8, 0.75))
    capacitor("c1", (-2.8, 0.75), (-4.2, 0.75))
    wire((-4.2, 0.75), (-4.2, 0))
    // trampa derecha
    inductor("l2", (2.8, 0), (4.2, 0))
    wire((2.8, 0), (2.8, 0.75))
    capacitor("c2", (2.8, 0.75), (4.2, 0.75))
    wire((4.2, 0.75), (4.2, 0))
    // brazos exteriores
    line((-4.2, 0), (-6.4, 0), .._t6-hilo)
    line((4.2, 0), (6.4, 0), .._t6-hilo)
    // alimentación
    wire((-0.25, 0), (-0.25, -0.8))
    wire((0.25, 0), (0.25, -0.8))
    content((0, -1.05), text(size: 8pt)[alimentación])
    content((-3.5, -0.55), text(size: 8pt)[trampa])
    content((3.5, -0.55), text(size: 8pt)[trampa])
    // cotas
    line((-2.8, 1.45), (2.8, 1.45), mark: (start: ">", end: ">", fill: col.acento), stroke: 0.5pt + col.acento)
    content((0, 1.45), anchor: "south", padding: 2pt, text(size: 8pt, fill: col.acento)[en 14 MHz solo trabaja esta parte ($lambda\/2$)])
    line((-6.4, 2.25), (6.4, 2.25), mark: (start: ">", end: ">", fill: col.naranja), stroke: 0.5pt + col.naranja)
    content((0, 2.25), anchor: "south", padding: 2pt, text(size: 8pt, fill: col.naranja)[en 7 MHz trabaja el hilo entero (con las trampas como bobinas de carga)])
  })
] <t6-fig-trampas>

#porque[
  - *A 14 MHz*, cada trampa está en su resonancia. Un LC en paralelo resonante tiene una impedancia altísima (#ver(<sec-resonancia>)) y para la RF es como un interruptor abierto; lo puedes ver en #falstad("res-par.txt", texto: [resonancia en paralelo]). Los tramos exteriores quedan desconectados y la antena es un dipolo de media onda para 14 MHz.
  - *A 7 MHz*, la trampa está por debajo de su resonancia. Un LC en paralelo, por debajo de su resonancia, se comporta como una *bobina*. La corriente atraviesa la trampa y recorre el hilo entero.
  - *La bobina alarga eléctricamente* la antena. Por eso el hilo total es algo más corto que un dipolo normal de 40 m.
  - *Sin trampas*, el dipolo de 7 MHz en 14 MHz mediría una onda completa: centro en un nodo de corriente, impedancia de miles de ohmios. Inservible con coaxial.
]

#ejemplo(titulo: [Calcular una trampa para 14,1 MHz])[
  Con un condensador de 50 pF, la bobina debe cumplir $f_0 = 1\/(2 pi sqrt(L C))$, es decir, $L = 1\/((2 pi f_0)^2 C) = 1\/((2 pi dot 14,1 dot 10^6)^2 dot 50 dot 10^(-12)) approx 2,5$ μH. El condensador tiene que soportar la tensión de RF que hay en ese punto del hilo: en transmisión, cientos o miles de voltios.
]

La misma idea sin el condensador es la *bobina de carga*. Una antena más corta de lo que pide su frecuencia es capacitiva (@t6-fig-rlc[figura]). Una bobina en serie añade la reactancia inductiva que falta y la antena vuelve a resonar: eléctricamente «parece» más larga. Es el recurso de las antenas de móvil, cortas por necesidad (preguntas T6.39 y T6.45). El precio es el rendimiento: la $R_r$ de una antena corta es pequeña y las pérdidas de la bobina pesan mucho, como en el ejemplo del rendimiento.

==== La vertical de cuarto de onda y el plano de tierra

#circuito(caption: [Izquierda: la vertical de cuarto de onda y su imagen. El suelo actúa de espejo y aporta la mitad inferior del dipolo. Derecha: el plano de tierra artificial, con radiales de $lambda\/4$; si se inclinan hacia abajo, la impedancia sube de ∼36 Ω hacia ∼50 Ω.])[
  #cetz.canvas({
    import cetz.draw: *
    // --- panel izquierdo: monopolo e imagen
    line((-2.4, 0), (2.4, 0), stroke: 0.9pt + col.gris)
    for i in range(12) { line((-2.3 + i * 0.4, 0), (-2.5 + i * 0.4, -0.2), stroke: 0.4pt + col.gris) }
    line((0, 0.12), (0, 3.6), .._t6-hilo)
    line((0, -0.12), (0, -3.6), stroke: (paint: col.naranja, thickness: 1.4pt, dash: "dashed"))
    // corriente real e imagen
    line(..range(41).map(i => { let y = 3.6 * i / 40; (1.3 * calc.cos(calc.pi / 2 * y / 3.6), y) }), stroke: 1pt + col.senal3)
    line(..range(41).map(i => { let y = 3.6 * i / 40; (1.3 * calc.cos(calc.pi / 2 * y / 3.6), -y) }), stroke: (paint: col.senal3, thickness: 0.8pt, dash: "dashed"))
    _t6-et((1.35, 0.25), text(fill: col.senal3)[$I_"máx"$], anchor: "west")
    _t6-et((0.15, 3.65), [$I = 0$], anchor: "south-west")
    // cota λ/4
    line((-0.7, 0.12), (-0.7, 3.6), mark: (start: ">", end: ">", fill: col.gris), stroke: 0.5pt + col.gris)
    _t6-et((-0.8, 1.8), text(fill: col.gris, $lambda\/4$), anchor: "east")
    _t6-et((-2.4, -0.3), [suelo (espejo)], anchor: "north-west", fill: col.gris)
    _t6-et((-0.25, -2.0), text(fill: col.gris)[imagen], anchor: "east")
    _t6-et((1.5, -0.25), text(fill: col.gris)[alimentación en la base], anchor: "north-west")
    // --- panel derecho: plano de tierra
    let bx = 6.6
    let by = 0.6
    line((bx, by), (bx, by + 3.0), .._t6-hilo)
    line((bx, by), (bx - 2.0, by - 1.3), stroke: 1.4pt + col.naranja)
    line((bx, by), (bx + 2.0, by - 1.3), stroke: 1.4pt + col.naranja)
    line((bx - 2.3, by), (bx + 2.3, by), stroke: (paint: col.naranja, thickness: 0.8pt, dash: "dotted"))
    line((bx, by), (bx, by - 2.6), stroke: 2.2pt + col.gris)
    _t6-et((bx + 0.2, by - 2.3), [coaxial], anchor: "west")
    _t6-et((bx + 0.2, by + 2.6), [radiante $lambda\/4$], anchor: "west")
    _t6-et((bx + 2.2, by - 1.45), [radiales $lambda\/4$], anchor: "north")
    _t6-et((bx + 2.35, by + 0.05), text(fill: col.gris)[horizontales: ∼36 Ω], anchor: "south-west")
    _t6-et((bx - 2.1, by - 1.45), text(fill: col.gris)[a 45°: ∼50 Ω], anchor: "north")
  })
] <t6-fig-vertical>

#porque[
  - *El espejo*: la corriente del radiante induce corrientes en el suelo (o en los radiales) que producen el mismo campo que produciría la otra mitad de un dipolo, enterrada y simétrica. Sobre el suelo, el conjunto se comporta como un dipolo vertical de media onda.
  - *La mitad de resistencia*: el «dipolo» completo radiaría hacia arriba y hacia abajo; la vertical solo radia hacia arriba. Con la misma corriente, la mitad de potencia: $R_r approx 73\/2 approx 36$ Ω.
  - *Sin plano de tierra* no hay espejo: falta media antena, la impedancia se dispara y la corriente vuelve por el exterior de la malla del coaxial. El rendimiento se desploma (pregunta T6.35).
  - *Radiales inclinados*: al bajarlos unos 45°, la antena se parece un poco más a un dipolo y la impedancia sube a unos 50 Ω, justo lo que pide el coaxial (pregunta T6.27). Es un truco de adaptación, no de sintonía.
  - *Con suelo real*, mal conductor, las corrientes de retorno calientan la tierra: se pierde potencia. Por eso una vertical sobre el suelo lleva muchos radiales enterrados, y una elevada se conforma con dos o cuatro.
]

==== La Yagi: por qué funcionan el reflector y los directores

#motivacion[Un dipolo radia en dos direcciones opuestas por igual, y una vertical en todas. Si el corresponsal está en Japón, la mitad de la potencia o más se va hacia donde no hay nadie. ¿Se puede «empujar» la energía hacia un lado sin gastar más vatios?]

El truco es la *interferencia*. Dos ondas de la misma frecuencia que llegan a un punto en fase se suman; si llegan en oposición (desfasadas 180°) se anulan. Basta con colocar dos antenas de manera que sus ondas se sumen hacia delante y se anulen hacia atrás.

#ejemplo(titulo: [Dos antenas a $lambda\/4$, desfasadas 90°])[
  Pon dos verticales, A detrás y B delante, separadas $lambda\/4$, y alimenta B con un retraso de 90° (un cuarto de ciclo) respecto de A.
  - *Hacia delante*: la onda de A tarda un cuarto de ciclo en llegar hasta B (90° de camino). Cuando llega, B empieza a radiar con su propio retraso de 90°. Las dos ondas salen juntas, en fase: *se suman*.
  - *Hacia atrás*: la onda de B tarda 90° en llegar hasta A, y ya salió 90° tarde: en total, 180° de retraso respecto de la de A. Las dos ondas están en oposición: *se anulan*.
  El diagrama resultante es un corazón (cardioide): toda la potencia hacia delante, nada hacia atrás (@t6-fig-yagi[figura], derecha).
]

En la Yagi, la segunda antena no está alimentada por cable: es un *elemento parásito*. El campo del radiante induce en él una corriente, y el parásito la reirradia. La fase de esa corriente la decide su longitud, exactamente como en el circuito RLC de la @t6-fig-rlc[figura]:

- *El reflector* es algo más largo que el resonante: es *inductivo* y su corriente se retrasa. Colocado unos $0,15$ a $0,25 lambda$ detrás del radiante, su onda llega casi en oposición hacia atrás y casi en fase hacia delante: refuerza hacia el radiante y anula a su espalda.
- *Los directores* son algo más cortos: son *capacitivos* y su corriente se adelanta. Colocados delante, «tiran» del haz hacia ellos. Cada director más estrecha el lóbulo y sube la ganancia, cada vez un poco menos.

#circuito(caption: [Izquierda: Yagi de cuatro elementos vista desde arriba. Solo el radiante está alimentado; el reflector y los directores son parásitos. Derecha: diagrama de dos antenas separadas $lambda\/4$ y desfasadas 90° (el cardioide del ejemplo).])[
  #cetz.canvas({
    import cetz.draw: *
    // boom
    line((-0.3, 0), (5.6, 0), stroke: 2.2pt + col.gris.lighten(30%))
    // elementos
    line((0.3, -2.5), (0.3, 2.5), .._t6-hilo)
    line((1.8, -2.3), (1.8, -0.1), .._t6-hilo)
    line((1.8, 0.1), (1.8, 2.3), .._t6-hilo)
    line((3.3, -2.1), (3.3, 2.1), .._t6-hilo)
    line((4.8, -2.0), (4.8, 2.0), .._t6-hilo)
    // alimentación del radiante
    circle((1.8, 0), radius: 0.13, fill: col.acento, stroke: none)
    line((1.95, -0.1), (2.5, -0.75), stroke: 0.5pt + col.acento)
    _t6-et((2.5, -0.8), text(fill: col.acento)[alimentación], anchor: "north-west", size: 7pt)
    // rótulos
    _t6-et((0.3, 2.7), [reflector], anchor: "south")
    _t6-et((0.3, -2.7), text(fill: col.gris)[más largo], anchor: "north")
    _t6-et((1.8, 2.7), [radiante], anchor: "south")
    _t6-et((1.8, -2.7), text(fill: col.gris)[alimentado], anchor: "north")
    _t6-et((4.05, 2.7), [directores], anchor: "south")
    _t6-et((4.05, -2.7), text(fill: col.gris)[más cortos], anchor: "north")
    // separación
    line((0.3, 1.2), (1.8, 1.2), mark: (start: ">", end: ">", fill: col.gris), stroke: 0.5pt + col.gris)
    _t6-et((1.05, 1.2), text(fill: col.gris)[$approx 0,2 lambda$], anchor: "south", size: 7pt)
    // dirección
    line((5.3, 0.6), (6.6, 0.6), mark: (end: ">", fill: col.acento), stroke: 1pt + col.acento)
    _t6-et((5.95, 0.7), text(fill: col.acento)[máxima], anchor: "south", size: 7pt)
    // cardioide
    let cx = 9.4
    _t6-rejilla((0.7, 1.4), 1.6, cx: cx)
    line(.._t6-pts(a => 1.4 * calc.abs(calc.cos(calc.pi / 4 * (calc.cos(a) - 1))), 0deg, 360deg, n: 120, cx: cx), close: true, stroke: 1.1pt + col.acento, fill: col.acento-claro.transparentize(30%))
    circle((cx - 0.35, 0), radius: 0.07, fill: col.tinta)
    circle((cx + 0.35, 0), radius: 0.07, fill: col.tinta)
    _t6-et((cx - 0.35, -0.12), [A], anchor: "north", size: 7pt)
    _t6-et((cx + 0.35, -0.12), [B], anchor: "north", size: 7pt)
    _t6-et((cx + 1.5, 0.15), text(fill: col.acento)[se suman], anchor: "south-west", size: 7pt)
    _t6-et((cx - 1.0, 0.15), text(fill: col.naranja)[se anulan], anchor: "south-east", size: 7pt)
  })
] <t6-fig-yagi>

#porque[
  - *Solo el radiante recibe energía del cable*. Los parásitos la toman del campo del radiante y la devuelven con otra fase; por eso no necesitan conexión (preguntas T6.5 y T6.37).
  - *La longitud decide la fase*: más largo, inductivo, la corriente se retrasa (reflector); más corto, capacitivo, se adelanta (director).
  - *La separación decide el retraso del camino*. Fase propia más retraso del camino: si la suma da 0° hacia delante y 180° hacia atrás, el haz sale hacia delante.
  - *Precio*: los parásitos, tan cerca, bajan la impedancia del radiante a unos 20–30 Ω. Por eso el radiante de muchas Yagi es un dipolo plegado o lleva un adaptador (gamma, horquilla).
  - Valores típicos: una Yagi de tres elementos da unos 5–6 dBd de ganancia y una relación delante-atrás de unos 15–20 dB.
]

==== Antenas de apertura y helicoidales

En microondas la longitud de onda mide centímetros, y es fácil construir antenas de muchas longitudes de onda de ancho. Una *bocina* abre poco a poco una guía de ondas, como la trompeta abre el tubo de un instrumento; un *reflector parabólico* concentra en un foco, como un faro, la energía que llega en paralelo. Su ganancia depende del área de la «boca» medida en longitudes de onda:

#destacada($display(G approx eta (pi D / lambda)^2)$, nota: [$D$ = diámetro de la parábola; $eta approx 0,5$–$0,6$ es el rendimiento de apertura])

#ejemplo(titulo: [Parábola de 1,2 m a 10 GHz])[
  $lambda = 300\/10 000 = 0,03$ m. $pi D\/lambda = pi dot 1,2\/0,03 approx 126$; al cuadrado, unos 15 800; con $eta = 0,55$, $G approx 8700$, es decir, $10 log 8700 approx 39$ dBi. La misma parábola en 2 m (145 MHz) daría una ganancia insignificante: el tamaño se mide siempre en longitudes de onda.
]

La *antena helicoidal* es un hilo enrollado en hélice sobre un eje, con un plano reflector detrás. Si la circunferencia de cada espira mide una longitud de onda, radia a lo largo del eje con *polarización circular*. Cuantas más espiras, más larga la hélice y más estrecho el haz: la ganancia depende sobre todo del *número de espiras* (pregunta T6.41). Es la antena típica de los enlaces con satélites, que giran sobre sí mismos y cambian la orientación de su señal.

=== El diagrama de radiación, la ganancia y la polarización

Del diagrama de radiación (@t6-fig-diagrama[figura]) salen las cifras de mérito. La *directividad* mide cuánto concentra la antena la energía; la *ganancia* añade las pérdidas (y se expresa en dB respecto a la antena isótropa, dBi, o al dipolo, dBd). El *ancho de haz* es la apertura angular entre los puntos de media potencia (−3 dB) del lóbulo principal; la *relación adelante-atrás*, el cociente en dB entre el lóbulo principal y el trasero. La *potencia efectiva radiada* es la entregada multiplicada por la ganancia: 10 W en una antena de 10 dBd «parecen» 100 W en la dirección favorecida (la p.r.e. se refiere al dipolo; la PIRE, a la isótropa). La *polarización* es la orientación del campo eléctrico radiado, y conviene que coincida en los dos extremos del enlace.

Dos relaciones cierran la caja de herramientas. Entre las dos referencias de ganancia median siempre 2,15 dB — el dipolo ya «gana» eso sobre la isótropa —: $G ("dBi") = G ("dBd") + 2,15$. Y en recepción la ganancia se traduce en *área de captura*,
$ A_e = lambda^2 / (4 pi) G : $
a igual ganancia, una antena captura más señal cuanto más larga es la onda — una de las razones de que las bandas bajas perdonen antenas modestas.

#circuito(caption: [Diagrama de radiación de una antena directiva. El ancho de haz se mide entre las direcciones de media potencia (−3 dB) del lóbulo principal; la relación adelante-atrás compara, en decibelios, el lóbulo principal con el trasero.])[
  #cetz.canvas({
    import cetz.draw: *
    _t6-rejilla((1, 2, 3), 3.4)
    // lóbulo principal y trasero
    let lp = a => if calc.cos(a) > 0 { 3 * calc.pow(calc.cos(a), 3) } else { 0 }
    let lt = a => if calc.cos(a) < 0 { 0.55 * calc.pow(calc.cos(a), 2) } else { 0 }
    line(.._t6-pts(lp, -90deg, 90deg, n: 160), close: true, stroke: 1.2pt + col.acento, fill: col.acento-claro.transparentize(20%))
    line(.._t6-pts(lt, 90deg, 270deg, n: 100), close: true, stroke: 1pt + col.naranja)
    // ancho de haz
    let b = 37.5deg
    line((0, 0), (3.4 * calc.cos(b), 3.4 * calc.sin(b)), stroke: (paint: col.gris, thickness: 0.6pt, dash: "dashed"))
    line((0, 0), (3.4 * calc.cos(-b), 3.4 * calc.sin(-b)), stroke: (paint: col.gris, thickness: 0.6pt, dash: "dashed"))
    arc((2.7 * calc.cos(-b), 2.7 * calc.sin(-b)), start: -b, stop: b, radius: 2.7, mark: (start: ">", end: ">", fill: col.gris), stroke: 0.5pt + col.gris)
    _t6-et((2.9 * calc.cos(b), 2.9 * calc.sin(b) + 0.15), text(fill: col.gris)[ancho de haz (−3 dB)], anchor: "south-west")
    // máxima radiación
    line((0, 0), (4.1, 0), mark: (end: ">", fill: col.tinta), stroke: 0.8pt + col.tinta)
    _t6-et((4.2, 0), [máxima radiación], anchor: "west")
    _t6-et((0.9, 1.6), text(fill: col.acento)[lóbulo principal], anchor: "south")
    _t6-et((-1.3, -0.9), text(fill: col.naranja)[lóbulo trasero], anchor: "north-east")
  })
] <t6-fig-diagrama>

#ptitulo[Leer un diagrama] Un diagrama de radiación es un «mapa» de cuánta señal sale en cada dirección: la distancia de la curva al centro es la intensidad en esa dirección. Se dibuja en dos cortes: el *horizontal* (azimut, la antena vista desde arriba) y el *vertical* (elevación, vista de lado). La @t6-fig-diagramas[figura] compara las dos antenas básicas.

#circuito(caption: [Diagramas de las antenas básicas. (a) Dipolo horizontal visto desde arriba: máximo perpendicular al hilo y nulos en las puntas. (b) Vertical vista desde arriba: radia igual hacia todos los rumbos (omnidireccional). (c) Vertical vista de lado: máximo en el plano horizontal (bajo ángulo) y nulo hacia el cénit.])[
  #cetz.canvas({
    import cetz.draw: *
    // (a) dipolo, azimut
    _t6-rejilla((0.75, 1.5), 1.6, cx: 0)
    line(.._t6-pts(a => 1.5 * _t6-dip(a), 0deg, 360deg, n: 200, cx: 0), close: true, stroke: 1.1pt + col.acento, fill: col.acento-claro.transparentize(30%))
    line((-0.55, 0), (0.55, 0), stroke: 2pt + col.naranja)
    _t6-et((0, -1.9), [(a) dipolo: azimut], anchor: "north")
    // (b) vertical, azimut
    _t6-rejilla((0.75, 1.5), 1.6, cx: 4.4)
    circle((4.4, 0), radius: 1.3, stroke: 1.1pt + col.acento, fill: col.acento-claro.transparentize(30%))
    circle((4.4, 0), radius: 0.08, fill: col.naranja, stroke: none)
    _t6-et((4.4, -1.9), [(b) vertical: azimut], anchor: "north")
    // (c) vertical, elevación
    let cx = 8.8
    let cy = -0.9
    for rr in (0.9, 1.8) { arc((cx + rr, cy), start: 0deg, stop: 180deg, radius: rr, stroke: 0.4pt + col.gris.lighten(60%)) }
    for k in range(1, 6) { let a = k * 30deg; line((cx, cy), (cx + 1.9 * calc.cos(a), cy + 1.9 * calc.sin(a)), stroke: 0.4pt + col.gris.lighten(60%)) }
    line(.._t6-pts(a => 1.7 * _t6-dip(a - 90deg), 0deg, 180deg, n: 160, cx: cx, cy: cy), close: true, stroke: 1.1pt + col.acento, fill: col.acento-claro.transparentize(30%))
    line((cx - 2.1, cy), (cx + 2.1, cy), stroke: 0.9pt + col.gris)
    line((cx, cy), (cx, cy + 0.6), stroke: 2pt + col.naranja)
    _t6-et((cx, cy + 1.95), text(fill: col.gris)[cénit: nulo], anchor: "south")
    _t6-et((cx + 2.1, cy - 0.08), text(fill: col.gris)[horizonte], anchor: "north-east", size: 7pt)
    _t6-et((cx, -1.9), [(c) vertical: elevación], anchor: "north")
  })
] <t6-fig-diagramas>

Un elemento radiante emite al máximo perpendicularmente a su eje y nada a lo largo de él. De ahí salen las dos preguntas clásicas: la vertical tiene su máximo en el plano horizontal y su nulo hacia el cénit (T6.14); y es *omnidireccional* porque radia igual hacia todos los rumbos del plano horizontal, aunque en elevación no radie igual (T6.40).

#analogia(titulo: [La ganancia no crea energía])[
  Una bombilla desnuda ilumina toda la habitación por igual: es la antena *isótropa*, una referencia ideal que radia lo mismo en todas las direcciones. Mete la misma bombilla en una linterna con reflector: el haz deslumbra, pero detrás no hay luz. La bombilla no consume más; el reflector solo *redistribuye* la luz. La ganancia de una antena pasiva es eso: la potencia que falta en unas direcciones aparece en otras. Por eso la ganancia y la directividad van siempre juntas, y una antena con más ganancia tiene un haz más estrecho.
]

Una antena *pasiva* no lleva ningún amplificador (T6.30): no añade energía, solo la concentra. Además cumple el *principio de reciprocidad*: tiene el mismo diagrama y la misma ganancia emitiendo que recibiendo (T6.38). Apuntar una directiva sirve tanto para transmitir como para escuchar. Las antenas *activas* de recepción llevan un preamplificador incorporado y necesitan alimentación.

#ejemplo(titulo: [p.r.e. y PIRE de una estación de 2 m])[
  Transmisor de 100 W (50 dBm), 2 dB de pérdidas en el cable y una Yagi de 7 dBd. A la antena llegan $50 - 2 = 48$ dBm. La p.r.e. es $48 + 7 = 55$ dBm, unos 316 W. La PIRE añade los 2,15 dB del dipolo sobre la isótropa: $57,15$ dBm, unos 520 W. Es la misma emisión contada respecto de dos referencias distintas.
]

#ejemplo(titulo: [Área de captura en 40 m y en 2 m])[
  Un dipolo tiene $G = 1,64$ (2,15 dBi). A 7 MHz ($lambda approx 42,9$ m): $A_e = 42,9^2\/(4 pi) dot 1,64 approx 240 "m"^2$. A 145 MHz ($lambda approx 2,07$ m): $A_e approx 0,56 "m"^2$. El mismo tipo de antena, con la misma ganancia, «recoge» unas 430 veces más potencia de una onda de la misma intensidad en 40 m que en 2 m.
]

#ptitulo[La polarización] El campo eléctrico de la onda tiene la orientación del hilo que la radia: un dipolo horizontal emite con *polarización horizontal* y una vertical, con *polarización vertical* (T6.8). En visión directa (VHF/UHF), una antena receptora cruzada respecto de la emisora puede perder 20 dB o más; por eso la FM en 2 m usa antenas verticales, y la SSB y el trabajo de señal débil en VHF, horizontales. En HF importa menos, porque la ionosfera gira la polarización por el camino. Los satélites usan *polarización circular*, que gira con la onda y no depende de la orientación del satélite.

#ojo[
  - Ancho de haz: entre los puntos de *media potencia (−3 dB)*, no donde la radiación se anula (T6.9).
  - Relación adelante-atrás: diferencia en dB entre el lóbulo principal y el *trasero* (T6.16, T6.46). El ancho de haz es un ángulo, no una diferencia de nivel.
  - La ganancia se da en *dBi o dBd*, nunca en vatios (T6.34). dBi = dBd + 2,15.
]

#q("T6.1", "b",
  [La longitud total aproximada de un dipolo de media onda para la banda de 40 metros es de:],
  ([10 m], [20 m], [40 m], [80 m]),
  sol: [Las bandas se nombran por su longitud de onda: «40 m» significa $lambda approx 40$ m, luego el dipolo de media onda mide $lambda\/2 approx 20$ m (algo menos por el factor de acortamiento). El distractor de 40 m confunde la longitud de la antena con el nombre de la banda.],
)

#q("T6.2", "d",
  [Una antena está en resonancia cuando:],
  ([su longitud es exactamente un múltiplo de la longitud de onda], [su ganancia es máxima en todas las direcciones], [radia por igual en el plano vertical y en el horizontal], [la impedancia en su punto de alimentación es resistiva pura]),
  sol: [En resonancia la reactancia del punto de alimentación se anula: impedancia resistiva pura (@t6-fig-dipolo[figura]).],
)

#q("T6.3", "a",
  [Para que una antena que resuena en 29 900 kHz pase a resonar en 28 500 kHz, deberemos:],
  ([alargarla], [acortarla], [girarla 90 grados], [alimentarla en un extremo]),
  sol: [Frecuencia menor $arrow.r.double$ $lambda$ mayor $arrow.r.double$ antena más larga: para bajar de 29,9 a 28,5 MHz hay que alargar.],
)

#q("T6.4", "b",
  [Las antenas Yagi son antenas:],
  ([omnidireccionales], [directivas], [isótropas], [exclusivamente receptoras]),
  sol: [La Yagi concentra la radiación hacia los directores: la directiva por excelencia.],
)

#q("T6.5", "c",
  [En una antena Yagi, los llamados «elementos parásitos» son:],
  ([elementos defectuosos que deben sustituirse], [filtros contra interferencias], [elementos no alimentados directamente (no activos)], [aisladores del mástil]),
  sol: [Solo el radiante está alimentado; reflector y directores son parásitos: reirradian y moldean el diagrama por interferencia.],
)

#q("T6.6", "d",
  [En resonancia, el dipolo plegado (doblado) presenta, respecto del dipolo simple, una impedancia:],
  ([igual], [nula], [la mitad], [unas cuatro veces mayor (∼300 Ω)]),
  sol: [Los dos conductores del lazo se reparten la corriente; para radiar la misma potencia el generador entrega la mitad de corriente, y si en $P = I^2 R$ la corriente se reduce a la mitad, la resistencia debe cuadruplicarse: $tilde 4 times 73 approx 300$ Ω. De ahí su uso con línea bifilar de 300 Ω y como elemento excitado (alimentado) de muchas Yagi.],
)

#q("T6.7", "b",
  [En un dipolo con trampas, las trampas son:],
  ([condensadores de paso], [circuitos resonantes que permiten trabajar en varias bandas], [resistencias de carga], [contrapesos mecánicos]),
  sol: [Las trampas son circuitos resonantes LC que aíslan el tramo exterior del brazo a su frecuencia: la antena resuena en varias bandas.],
)

#q("T6.8", "c",
  [La polarización de una antena viene determinada por:],
  ([la potencia del transmisor], [la longitud de la línea de transmisión], [la orientación del campo eléctrico radiado], [la frecuencia de trabajo]),
  sol: [La polarización es la orientación del campo eléctrico radiado: vertical u horizontal según la antena.],
)

#q("T6.9", "a",
  [El ancho de haz del diagrama de radiación de una antena es la separación angular entre los dos puntos en los que la potencia radiada:],
  ([es la mitad de la máxima (−3 dB)], [se anula por completo], [es el doble de la media], [iguala a la potencia reflejada]),
  sol: [El ancho de haz se mide entre los puntos de media potencia (−3 dB) del lóbulo principal.],
)

== Líneas de transmisión y adaptación <t6-sec-lineas>

#motivacion(titulo: [¿Por qué no bastan dos cables cualesquiera?])[
  A 50 Hz la longitud de onda es de 6000 km: el cable de una lámpara mide una fracción ínfima de ella, y la tensión es la misma en todo el cable a la vez. A 14 MHz, $lambda approx 21$ m: el cable de 20 m que baja del tejado mide casi una longitud de onda, y en un mismo instante tiene puntos con tensión positiva y puntos con tensión negativa. La señal ya no «está» en el cable: *viaja* por él como una onda, tarda un tiempo en llegar, y lo que ocurre en el otro extremo (la antena) puede volver hacia el transmisor. Hace falta un cable construido para guiar esa onda sin radiarla ni deformarla: la línea de transmisión.
]

La energía viaja del transmisor a la antena por una *línea de transmisión*, caracterizada por su *impedancia característica* $Z_0$ — una propiedad puramente geométrica: separación y diámetro de los conductores, dieléctrico. El *coaxial* típico es de 50 Ω (75 en televisión), la *línea bifilar* de paralelos ronda los 300–600 Ω, y en microondas se usa la *guía de ondas*, que solo propaga por encima de su frecuencia de corte. En cualquier línea real la onda viaja más despacio que la luz: el *factor de velocidad* FV ($v\/c$, siempre menor que 1; del orden de 0,66 en coaxial de polietileno) hace que la longitud de onda dentro del cable sea más corta que en el aire. Para un mismo desfase, el tramo físico es, por tanto, _más corto_ que el eléctrico: $L_"fís" = L_"el" times "FV"$.

=== Por qué una línea «parece» una resistencia

Un trozo de línea tiene inductancia, porque la corriente de ida y la de vuelta crean un campo magnético, y tiene capacidad, porque los dos conductores, con un aislante entre ellos, forman un condensador. Las dos están repartidas a lo largo de toda la línea. Se pueden imaginar como una escalera de bobinas y condensadores muy pequeños (@t6-fig-escalera[figura]).

#circuito(caption: [Modelo de una línea de transmisión: cada trozo de línea de longitud $Delta x$ tiene una inductancia en serie ($L' Delta x$) y una capacidad entre los conductores ($C' Delta x$). La onda avanza cargando un condensador tras otro.], sim: "tl.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content
    acvsource("g", (0, 0), (0, 2))
    wire((0, 2), (0.6, 2))
    for k in range(4) {
      let x = 0.6 + 1.9 * k
      inductor("l" + str(k), (x, 2), (x + 1.3, 2), label: if k == 0 { $L' Delta x$ } else { none })
      wire((x + 1.3, 2), (x + 1.9, 2))
      capacitor("c" + str(k), (x + 1.6, 2), (x + 1.6, 0), label: if k == 0 { $C' Delta x$ } else { none })
      node("n" + str(k), (x + 1.6, 2))
      node("m" + str(k), (x + 1.6, 0))
    }
    wire((0, 0), (8.2, 0))
    content((8.75, 1), text(size: 11pt)[…])
    content((-0.8, 1), text(size: 8pt)[TX])
  })
] <t6-fig-escalera>

#porque[
  - *La onda avanza*: al conectar el generador, el primer condensador se carga a través de la primera bobina. La bobina frena el paso de la corriente, así que el segundo condensador se carga un poco después, el tercero más tarde aún, y así uno tras otro. Ese frente de carga que avanza es la onda.
  - *El generador ve una resistencia*: mientras la onda avanza, el generador tiene que entregar corriente sin parar para cargar el trozo nuevo de línea que alcanza el frente. Esa corriente es proporcional a la tensión, $I = V\/Z_0$, y está en fase con ella: es el comportamiento de una resistencia.
  - *Pero no se calienta nada*: la energía no se quema; queda almacenada en los campos de la línea y viaja hacia el otro extremo.
  - *La línea adaptada*: si al final hay una resistencia igual a $Z_0$, esta absorbe exactamente lo que llega. El generador no distingue esa línea de una línea infinita. En Falstad, el ejemplo de la figura es una línea de 75 Ω terminada en 75 Ω.
]

#ptitulo[La cuenta en dos líneas] Detrás del frente de onda, cada metro de línea guarda una carga $C' V$. El frente avanza $v$ metros por segundo, así que el generador entrega una corriente $I = C' V v$. Como en esta escalera $v = 1\/sqrt(L' C')$, queda $I = V sqrt(C'\/L')$:

#destacada($display(Z_0 = V / I = sqrt(L' / C'))$, nota: [$L'$ y $C'$ por metro de línea: $Z_0$ no depende de la longitud de la línea])

#analogia[Una manguera larguísima y vacía. Al abrir el grifo, el agua que entra por segundo depende solo de la presión y del grosor de la manguera, no de su longitud: el agua aún no ha llegado al final y «no sabe» qué hay allí. Una manguera más gruesa admite más caudal con la misma presión: es como una $Z_0$ más baja. Un coaxial de 50 Ω es una «manguera» que, empujada con 50 V, admite 1 A.]

Por eso $Z_0$ depende solo de la geometría y del aislante: el diámetro y la separación de los conductores fijan $L'$ y $C'$ (@t6-fig-cables[figura]).

#circuito(caption: [Las dos líneas de la radioafición. Izquierda: coaxial (asimétrico), con el campo encerrado dentro de la malla. Derecha: línea bifilar o de escalerilla (simétrica), con el campo alrededor de los dos hilos.])[
  #cetz.canvas({
    import cetz.draw: *
    // coaxial
    circle((0, 0), radius: 1.2, fill: col.gris.lighten(55%), stroke: 0.6pt + col.gris)
    circle((0, 0), radius: 0.98, fill: col.gris.lighten(20%), stroke: none)
    circle((0, 0), radius: 0.9, fill: col.ambar-claro, stroke: 0.4pt + col.gris)
    circle((0, 0), radius: 0.22, fill: col.naranja, stroke: none)
    line((-0.9, -1.55), (0.9, -1.55), mark: (start: ">", end: ">", fill: col.tinta), stroke: 0.5pt)
    line((-0.9, -1.0), (-0.9, -1.65), stroke: 0.3pt + col.gris)
    line((0.9, -1.0), (0.9, -1.65), stroke: 0.3pt + col.gris)
    _t6-et((0, -1.6), $D$, anchor: "north")
    _t6-et((0, 0.3), $d$, anchor: "south", size: 7pt)
    line((0.15, 0.05), (2.0, 0.9), stroke: 0.4pt + col.gris)
    _t6-et((2.05, 0.9), [conductor central], anchor: "west", size: 7.5pt)
    line((0.6, -0.3), (2.0, 0.3), stroke: 0.4pt + col.gris)
    _t6-et((2.05, 0.3), [dieléctrico ($epsilon_r$)], anchor: "west", size: 7.5pt)
    line((0.85, -0.55), (2.0, -0.3), stroke: 0.4pt + col.gris)
    _t6-et((2.05, -0.3), [malla], anchor: "west", size: 7.5pt)
    line((1.1, -0.65), (2.0, -0.9), stroke: 0.4pt + col.gris)
    _t6-et((2.05, -0.9), [cubierta], anchor: "west", size: 7.5pt)
    _t6-et((0.5, -2.2), [*coaxial*: 50 Ω (75 Ω en TV)], anchor: "north")
    // bifilar
    let x1 = 6.2
    let x2 = 8.6
    rect((x1, -0.16), (x2, 0.16), fill: col.gris.lighten(70%), stroke: 0.4pt + col.gris)
    circle((x1, 0), radius: 0.2, fill: col.naranja, stroke: none)
    circle((x2, 0), radius: 0.2, fill: col.naranja, stroke: none)
    line((x1, 0.65), (x2, 0.65), mark: (start: ">", end: ">", fill: col.tinta), stroke: 0.5pt)
    line((x1, 0.25), (x1, 0.75), stroke: 0.3pt + col.gris)
    line((x2, 0.25), (x2, 0.75), stroke: 0.3pt + col.gris)
    _t6-et(((x1 + x2) / 2, 0.7), $s$, anchor: "south")
    _t6-et((x2 + 0.3, 0), $d$, anchor: "west", size: 7pt)
    _t6-et(((x1 + x2) / 2, -0.35), text(fill: col.gris)[separador], anchor: "north", size: 7pt)
    _t6-et(((x1 + x2) / 2, -2.2), [*bifilar*: 300–600 Ω], anchor: "north")
  })
] <t6-fig-cables>

#destacada($display(Z_0 = 138 / sqrt(epsilon_r) log_10 D / d) wide wide display(Z_0 approx 276 log_10 (2 s) / d)$, nota: [coaxial (izquierda) y línea bifilar en el aire (derecha); $s$ = separación entre centros de los hilos])

#ejemplo(titulo: [De la geometría a los ohmios])[
  - Coaxial con aislante de polietileno ($epsilon_r = 2,3$) y $D\/d = 3,5$: $Z_0 = 138\/sqrt(2\,3) dot log_10 3,5 approx 91 dot 0,544 approx 50$ Ω.
  - Con el mismo aislante, para 75 Ω hace falta $log_10 (D\/d) = 75\/91 approx 0,82$, es decir, $D\/d approx 6,7$: el conductor central es más fino. Es el cable de televisión.
  - Línea abierta de hilo de 2 mm con separadores de 15 cm: $Z_0 approx 276 log_10 (300\/2) approx 600$ Ω.
]

El coaxial encierra el campo dentro de la malla: se puede tender junto a canalones, por paredes o enterrado sin que nada lo perturbe. La línea bifilar pierde mucho menos, pero su campo rodea los hilos y hay que separarla de cualquier objeto metálico. La primera es *asimétrica* (un conductor dentro del otro); la segunda, *simétrica* (dos conductores iguales). Esa diferencia es la razón de ser del balun, que se explica más abajo.

=== El factor de velocidad

En un aislante, una onda viaja más despacio que en el vacío: $v = c\/sqrt(epsilon_r)$. El factor de velocidad es, por tanto, $"FV" = 1\/sqrt(epsilon_r)$ (pregunta T6.42). Con polietileno macizo ($epsilon_r approx 2,3$), FV ≈ 0,66; con polietileno celular (espuma), unos 0,8; la escalerilla ronda 0,9 y la línea abierta en el aire, 0,97.

Como la onda va más despacio, dentro del cable la longitud de onda es más corta: $lambda_"cable" = "FV" dot lambda_"aire"$. Un tramo que debe medir «un cuarto de onda» o «media onda» se corta *más corto* que en el aire.

#ejemplo(titulo: [Un cuarto de onda de coaxial en 145 MHz])[
  En el aire, $lambda = 300\/145 approx 2,07$ m y $lambda\/4 approx 0,517$ m. En coaxial de polietileno (FV = 0,66): $0,517 dot 0,66 approx 0,34$ m. La longitud física (34 cm) es menor que la eléctrica (51,7 cm).
]

#ojo[T6.31: dentro de la línea la onda va *más despacio* que en el aire. T6.33: la longitud física es *menor* que la eléctrica. Solo serían iguales en el vacío (FV = 1). La potencia aplicada no interviene.]

=== La guía de ondas

En microondas, las pérdidas del coaxial se disparan. La alternativa es un tubo metálico hueco, de sección rectangular o circular: la *guía de ondas*. La onda viaja dentro rebotando en las paredes, sin conductor central y casi sin pérdidas. Pero solo cabe si la guía es lo bastante ancha: la anchura interior $a$ tiene que superar la mitad de la longitud de onda. De ahí la *frecuencia de corte*, $f_c = c\/(2 a)$: por debajo de ella la onda no puede propagarse y se atenúa muy deprisa (pregunta T6.18). Por ejemplo, la guía normalizada WR-90 tiene $a = 22,86$ mm, $f_c approx 6,56$ GHz, y se usa entre 8 y 12 GHz.

=== Reflexión, onda estacionaria y ROE

Si la carga no coincide con $Z_0$, parte de la onda se *refleja*. El coeficiente de reflexión es $rho = (Z_L - Z_0)\/(Z_L + Z_0)$, y la superposición de onda directa y reflejada crea sobre la línea máximos y mínimos fijos — una onda estacionaria — cuya razón es la *ROE*:
$ "ROE" = V_"máx" / V_"mín" = (1 + |rho|) / (1 - |rho|) . $

#ptitulo[Por qué se refleja] La onda que llega por la línea trae una tensión y una corriente en la proporción $V\/I = Z_0$. La carga exige otra proporción, $V\/I = Z_L$. Las dos condiciones solo se cumplen a la vez si nace en la carga una segunda onda que vuelve hacia el generador con la diferencia: la onda reflejada. Tres casos límite:
- *Carga adaptada* ($Z_L = Z_0$): la carga acepta la onda tal como llega. $rho = 0$: no vuelve nada.
- *Extremo abierto* ($Z_L = infinity$): la corriente tiene que ser cero. Vuelve una onda con la corriente opuesta y la misma tensión: $rho = +1$, y en el extremo la tensión se duplica.
- *Cortocircuito* ($Z_L = 0$): la tensión tiene que ser cero. Vuelve una onda con la tensión invertida: $rho = -1$.
Puedes ver los tres casos, con pulsos, en #falstad("tlterm.txt", texto: [terminaciones]).

#analogia[Agita el extremo de una cuerda larga atada a una pared: la onda llega a la pared y vuelve *invertida* (es el cortocircuito). Si el otro extremo está suelto, por ejemplo una anilla que corre por un palo, vuelve *sin invertir* (el extremo abierto). Si la cuerda está empalmada con otra idéntica y muy larga, la onda sigue y no vuelve nada (la carga adaptada). Si está empalmada con una cuerda más gruesa, vuelve una parte (la desadaptación).]

#circuito(caption: [Tensión máxima a lo largo de una línea, desde el transmisor (izquierda) hasta la carga (derecha); las distancias se cuentan desde la carga. Adaptada: tensión constante, ROE 1. Carga de 150 Ω en línea de 50 Ω: máximos de 1,5 y mínimos de 0,5, ROE 3. Extremo abierto: máximos y nulos, ROE infinita. Los máximos se repiten cada $lambda\/2$, y entre un máximo y un mínimo hay $lambda\/4$.], sim: "tlstand.txt")[
  #cetz.canvas({
    import cetz.draw: *
    let sx = 8.0 // unidades por longitud de onda
    let vrel = (rho, x) => calc.sqrt(1 + rho * rho + 2 * rho * calc.cos(4 * calc.pi * (sx - x) / sx))
    ejes(0, 8.7, 0, 2.9, etq-x: [posición], etq-y: $|V|$)
    // líneas guía de λ/4 desde la carga
    for k in range(1, 4) {
      let x = sx - k * sx / 4
      line((x, 0), (x, 2.5), stroke: (paint: col.gris.lighten(50%), thickness: 0.4pt, dash: "dotted"))
    }
    line((sx, 0), (sx, 2.6), stroke: 0.8pt + col.gris)
    _t6-et((sx, 2.65), [carga], anchor: "south")
    _t6-et((sx - 2, -0.08), $lambda\/4$, anchor: "north", size: 7.5pt)
    _t6-et((sx - 4, -0.08), $lambda\/2$, anchor: "north", size: 7.5pt)
    _t6-et((sx - 6, -0.08), $3 lambda\/4$, anchor: "north", size: 7.5pt)
    _t6-et((0, -0.08), [transmisor], anchor: "north", size: 7.5pt)
    // curvas (escala vertical 1 = 1 unidad)
    onda(x => vrel(0, x), 0, sx, stroke: 1.1pt + col.senal3)
    onda(x => vrel(0.5, x), 0, sx, n: 240, stroke: 1.2pt + col.senal1)
    onda(x => vrel(1, x), 0, sx, n: 240, stroke: (paint: col.senal2, thickness: 1pt, dash: "dashed"))
    // cotas de la curva ROE 3
    line((sx - 4, 1.5), (sx - 3.2, 2.3), stroke: 0.4pt + col.senal1)
    _t6-et((sx - 3.15, 2.3), text(fill: col.senal1)[$V_"máx" = 1,5$], anchor: "west", size: 7.5pt)
    line((sx - 2, 0.5), (sx - 1.2, 0.3), stroke: 0.4pt + col.senal1)
    _t6-et((sx - 1.15, 0.3), text(fill: col.senal1)[$V_"mín" = 0,5$], anchor: "west", size: 7.5pt)
    // leyenda
    line((0.6, -0.85), (1.2, -0.85), stroke: 1.1pt + col.senal3)
    _t6-et((1.3, -0.85), [adaptada (ROE 1)], anchor: "west", size: 7.5pt)
    line((3.5, -0.85), (4.1, -0.85), stroke: 1.2pt + col.senal1)
    _t6-et((4.2, -0.85), [150 Ω (ROE 3)], anchor: "west", size: 7.5pt)
    line((6.2, -0.85), (6.8, -0.85), stroke: (paint: col.senal2, thickness: 1pt, dash: "dashed"))
    _t6-et((6.9, -0.85), [abierta (ROE ∞)], anchor: "west", size: 7.5pt)
  })
] <t6-fig-estacionaria>

En los puntos donde la onda directa y la reflejada llegan en fase, sus tensiones se suman: $V_"máx" = V_d + V_r$. Un cuarto de onda más allá llegan en oposición y se restan: $V_"mín" = V_d - V_r$. Esos puntos no se mueven: la onda «está quieta», es *estacionaria*. Dividiendo arriba y abajo entre $V_d$, y como $rho = V_r\/V_d$, sale la fórmula de la ROE. El ejemplo de Falstad de la figura es una línea en cortocircuito (ROE infinita); una desadaptación parcial, entre una línea de 75 Ω y otra de 500 Ω, está en #falstad("tlmis1.txt", texto: [línea desadaptada]). Y al revés, a partir de la ROE o de las potencias que lee un vatímetro direccional:

#destacada($display(|rho| = ("ROE" - 1) / ("ROE" + 1) = sqrt(P_"refl" / P_"dir"))$, nota: [la potencia va con el cuadrado de la tensión: la fracción reflejada es $rho^2$])

#ejemplo(titulo: [Dos cargas distintas, la misma ROE])[
  - Carga de 25 Ω en línea de 50 Ω: $rho = (25 - 50)\/(25 + 50) = -1\/3$. $"ROE" = (1 + 1\/3)\/(1 - 1\/3) = 2$. Se refleja $rho^2 approx 11$ %.
  - Carga de 100 Ω: $rho = 50\/150 = +1\/3$. ROE = 2 otra vez. El medidor de ROE no dice si la carga está por encima o por debajo de 50 Ω: solo dice cuánto se aleja.
  - Vatímetro direccional que lee 100 W de directa y 4 W de reflejada: $|rho| = sqrt(4\/100) = 0,2$; $"ROE" = 1,2\/0,8 = 1,5$.
]

#figure(
  table(
    columns: 4,
    align: center,
    [*ROE*], [*$|rho|$*], [*Potencia reflejada*], [*Pérdida por desadaptación*],
    [1:1], [0], [0 %], [0 dB],
    [1,5:1], [0,2], [4 %], [0,18 dB],
    [2:1], [0,33], [11 %], [0,51 dB],
    [3:1], [0,5], [25 %], [1,25 dB],
    [5:1], [0,67], [44 %], [2,55 dB],
    [∞], [1], [100 %], [—],
  ),
  caption: [ROE, coeficiente de reflexión y fracción de potencia reflejada en la carga. La «pérdida por desadaptación» es $-10 log (1 - rho^2)$: la potencia que no entra en la carga a la primera.],
) <t6-tab-roe>

Con adaptación perfecta ($Z_L = Z_0$) no hay reflejada y la ROE vale *1*; a peor adaptación, más potencia devuelta, más pérdidas en la línea y más riesgo para el transmisor.

=== Las pérdidas de la línea

Incluso adaptada, una línea real pierde potencia por dos caminos. Los conductores tienen resistencia, y a radiofrecuencia la corriente solo circula por la piel del metal (efecto pelicular): la resistencia crece con la raíz de la frecuencia. El aislante también se calienta un poco en cada ciclo, y esa pérdida crece con la frecuencia. Por eso la atenuación de un cable, en dB por cada 100 m, sube mucho con la frecuencia (@t6-tab-perdidas).

#figure(
  table(
    columns: 4,
    align: (left, center, center, center),
    [*Línea*], [*10 MHz*], [*145 MHz*], [*435 MHz*],
    [RG-58 (coaxial fino, 5 mm)], [≈ 4,5], [≈ 20], [≈ 36],
    [RG-213 (coaxial grueso, 10 mm)], [≈ 2], [≈ 8], [≈ 15],
    [Escalerilla de 450 Ω], [≈ 0,5], [≈ 2], [—],
  ),
  caption: [Atenuación típica aproximada, en dB por cada 100 m de línea adaptada. Los valores exactos dependen del fabricante.],
) <t6-tab-perdidas>

#ejemplo(titulo: [30 m de cable hasta la antena de 2 m])[
  Con RG-58 en 145 MHz: $30 dot 20\/100 = 6$ dB. Llega a la antena la cuarta parte: de 100 W, 25 W. Con RG-213: $30 dot 8\/100 = 2,4$ dB, llegan unos 58 W. En HF (10 MHz) los mismos 30 m de RG-58 solo pierden 1,35 dB. En VHF y UHF, el cable importa tanto como la antena.
]

La ROE aumenta las pérdidas por dos motivos: en los máximos de corriente de la onda estacionaria la corriente es mayor y calienta más los conductores ($I^2 R$), y la energía reflejada recorre la línea varias veces, perdiendo en cada viaje.

#ojo(titulo: [Un cable malo «mejora» la ROE])[
  La onda reflejada se atenúa a la ida y a la vuelta. Antena con ROE 3 ($rho^2 = 25$ %) al final de una línea de 3 dB de pérdidas: la reflejada vuelve al transmisor atenuada 6 dB, es decir, $25 \/ 4 approx 6$ %; $|rho| approx 0,25$ y el medidor junto al equipo marca ROE ≈ 1,7. La antena no ha mejorado: el cable se come la diferencia. Una ROE excelente con un cable muy largo en UHF es sospechosa.
]

Dos piezas cierran el sistema: el *balun* (_balanced–unbalanced_), que hace de transición entre el coaxial asimétrico y la antena simétrica evitando corrientes por el exterior de la malla, y el *acoplador de antena*, que transforma la impedancia vista para presentar al transmisor sus 50 Ω.

=== El balun

#motivacion[El coaxial es asimétrico: un conductor dentro del otro. El dipolo es simétrico: dos brazos iguales. Si se conecta el uno al otro sin más, los dos brazos ya no reciben la misma corriente. ¿Adónde va la diferencia?]

#circuito(caption: [Dipolo alimentado directamente con coaxial. La corriente de la cara interior de la malla ($I_2$) se reparte entre el brazo izquierdo y la cara exterior de la malla ($I_3$). El balun de corriente (choque) frena $I_3$.])[
  #cetz.canvas({
    import cetz.draw: *
    // brazos
    line((-4.6, 3), (-0.45, 3), .._t6-hilo)
    line((0.45, 3), (4.6, 3), .._t6-hilo)
    // coaxial
    rect((-0.5, -0.9), (0.5, 2.5), fill: col.gris.lighten(70%), stroke: 1.4pt + col.gris)
    line((0, -0.9), (0, 2.5), stroke: 1.2pt + col.naranja)
    line((0, 2.5), (0.45, 3), stroke: 1.2pt + col.naranja)
    line((-0.5, 2.5), (-0.45, 3), stroke: 1.4pt + col.gris)
    // choque de ferrita
    rect((-0.75, -0.6), (0.75, -0.05), fill: col.tinta.lighten(25%), stroke: none)
    _t6-et((0.85, -0.33), [balun de corriente (choque de ferrita): frena $I_3$], anchor: "west", size: 7.5pt)
    // corrientes
    line((0.18, 0.5), (0.18, 1.8), mark: (end: ">", fill: col.senal1), stroke: 0.9pt + col.senal1)
    _t6-et((0.6, 1.5), text(fill: col.senal1)[$I_1$ (vivo)], anchor: "west", size: 7.5pt)
    line((-0.33, 1.8), (-0.33, 0.5), mark: (end: ">", fill: col.senal1), stroke: 0.9pt + col.senal1)
    _t6-et((0.6, 0.9), text(fill: col.senal1)[$I_2$ (cara interior de la malla)], anchor: "west", size: 7.5pt)
    line((-0.8, 2.3), (-0.8, 0.6), mark: (end: ">", fill: col.senal2), stroke: 1.1pt + col.senal2)
    _t6-et((-0.95, 1.4), text(fill: col.senal2)[$I_3$: exterior de la malla (radia)], anchor: "east", size: 7.5pt)
    line((1.4, 3.25), (3.0, 3.25), mark: (end: ">", fill: col.senal1), stroke: 0.9pt + col.senal1)
    _t6-et((2.2, 3.3), text(fill: col.senal1)[$I_1$], anchor: "south", size: 7.5pt)
    line((-1.4, 3.25), (-3.0, 3.25), mark: (end: ">", fill: col.senal1), stroke: 0.9pt + col.senal1)
    _t6-et((-2.2, 3.3), text(fill: col.senal1)[$I_2 - I_3$], anchor: "south", size: 7.5pt)
    _t6-et((0, -1.0), [al transmisor], anchor: "north", size: 7.5pt)
  })
] <t6-fig-balun>

#porque[
  - *Dentro del coaxial*, por el efecto pelicular, la corriente del vivo ($I_1$) y la de la malla ($I_2$) circulan por las caras que se miran: la cara exterior del conductor central y la cara *interior* de la malla. Son iguales y opuestas, y sus campos se anulan fuera del cable: el coaxial no radia.
  - *En el punto de alimentación*, el brazo derecho cuelga del vivo y recibe $I_1$. El brazo izquierdo cuelga de la malla, pero $I_2$ tiene allí dos caminos: el brazo y la cara *exterior* de la malla. Una parte, $I_3$, se escapa por fuera.
  - *Consecuencias de $I_3$*: el coaxial se convierte en parte de la antena. Radia, deforma el diagrama, mete RF en el cuarto de radio (micrófonos que «pican», interferencias en la televisión) y hace que la ROE cambie al tocar el cable.
  - *El balun de corriente* (anillos de ferrita alrededor del coaxial, o unas cuantas vueltas del propio coaxial) presenta una impedancia alta a la corriente que va por fuera, sin tocar las corrientes interiores, que se anulan entre sí. $I_3$ desaparece y los dos brazos reciben la misma corriente.
  - *Baluns transformadores*: además de simetrizar, cambian la impedancia. Un 4:1 baja a 50 Ω los ∼200 Ω de un dipolo OCF, o a 75 Ω los 300 Ω de un dipolo plegado. Cuando los dos lados son asimétricos, el mismo dispositivo se llama _unun_, como el 49:1 de la antena de media onda alimentada por un extremo.
]

La propia línea puede transformar: un *tramo de cuarto de onda* convierte $Z_L$ en $Z_0^2\/Z_L$. Al desfasar 90°, un máximo de tensión en un extremo cae a un mínimo en el otro —tensión y corriente intercambian su papel y la impedancia se invierte, de modo que un cortocircuito se ve como circuito abierto—; por eso adapta $Z_L$ a la línea con una sección de impedancia $Z_0 = sqrt(Z_"línea" Z_L)$, la media geométrica. Los tramos abiertos o en cortocircuito se comportan, además, como circuitos sintonizados.

=== El tramo de cuarto de onda

#circuito(caption: [Adaptador de cuarto de onda. Un tramo de $lambda\/4$ eléctrico de 87 Ω entre la línea de 50 Ω (de cualquier longitud) y una carga de 150 Ω: en su entrada se ve $87^2\/150 approx 50$ Ω.])[
  #cetz.canvas({
    import cetz.draw: *
    rect((-1.9, -0.55), (-0.3, 0.55), fill: col.acento-claro, stroke: 0.6pt + col.acento, radius: 0.1)
    _t6-et((-1.1, 0), [TX 50 Ω])
    // línea de 50 Ω
    line((-0.3, 0.25), (3.4, 0.25), stroke: 1pt + col.gris)
    line((-0.3, -0.25), (3.4, -0.25), stroke: 1pt + col.gris)
    _t6-et((1.55, 0.4), [línea de 50 Ω], anchor: "south", size: 7.5pt)
    _t6-et((1.55, -0.4), text(fill: col.verde)[aquí se ve ≈ 50 Ω: ROE 1], anchor: "north", size: 7.5pt)
    // tramo de λ/4
    line((3.4, 0.25), (3.4, 0.55), stroke: 1pt + col.gris)
    line((3.4, -0.25), (3.4, -0.55), stroke: 1pt + col.gris)
    line((3.4, 0.55), (6.6, 0.55), stroke: 1.2pt + col.acento)
    line((3.4, -0.55), (6.6, -0.55), stroke: 1.2pt + col.acento)
    _t6-et((5.0, 0.7), text(fill: col.acento)[tramo $lambda\/4$ de 87 Ω], anchor: "south", size: 7.5pt)
    line((3.4, -0.95), (6.6, -0.95), mark: (start: ">", end: ">", fill: col.gris), stroke: 0.5pt + col.gris)
    _t6-et((5.0, -1.05), text(fill: col.gris)[$lambda\/4 times "FV"$], anchor: "north", size: 7.5pt)
    // carga
    rect((6.6, -0.7), (8.2, 0.7), fill: col.naranja-claro, stroke: 0.6pt + col.naranja, radius: 0.1)
    _t6-et((7.4, 0), [antena \ 150 Ω])
  })
] <t6-fig-lambda4>

#porque[
  - *El ida y vuelta mide media onda*: la reflexión que nace en la carga recorre el tramo dos veces, $2 times lambda\/4 = lambda\/2$, y vuelve a la entrada desfasada 180°. Allí se suma con la reflexión que nace en la unión de las dos líneas, que es de signo contrario. Con $Z = sqrt(Z_"línea" Z_L)$, las dos reflexiones son iguales y se anulan: hacia el transmisor no vuelve nada.
  - *La inversión*: donde la carga pone tensión alta y corriente baja, a un cuarto de onda hay tensión baja y corriente alta. Por eso $Z_"entrada" = Z_0^2\/Z_L$: una carga alta se ve baja y al revés. En el límite, un cortocircuito se ve como un circuito abierto.
  - *Solo funciona en una banda*: a otra frecuencia, el tramo ya no mide $lambda\/4$ (aunque también funciona en los múltiplos impares: $3 lambda\/4$, $5 lambda\/4$…).
]

#ptitulo[Tramos como circuitos sintonizados] Un tramo de $lambda\/4$ en cortocircuito se ve en su entrada como un circuito *abierto*, igual que un LC en paralelo resonante. Conectado en paralelo con la línea, no molesta a la frecuencia fundamental. Pero a la frecuencia doble mide $lambda\/2$, repite el cortocircuito y cortocircuita el segundo armónico: es un filtro sencillo y robusto. Un tramo de $lambda\/4$ abierto hace lo contrario: se ve como un cortocircuito, como un LC en serie resonante.

#ejemplo[Antena de 150 Ω sobre línea de 50 Ω: $rho = (150 - 50)\/(150 + 50) = 0,5$ y $"ROE" = 1,5\/0,5 = 3$. Se refleja $rho^2 = 25$ % de la potencia. La escala merece memoria: ROE 1:1, 0 % reflejado; 1,5:1, 4 %; 2:1, 11 %; 3:1, 25 %. Para adaptarla con un tramo de cuarto de onda haría falta una línea de $Z = sqrt(50 dot 150) approx 87$ Ω.]

#truco[La ROE perfecta es *1:1* (toda la potencia va a la antena, nada se refleja). Cuanto mayor es la ROE, peor la adaptación. En el examen, «ROE» va siempre ligada a la palabra _adaptación de impedancias_: transmisor, línea y antena deben presentar la misma impedancia.]

#q("T6.10", "c",
  [El parámetro ROE de una estación transmisora es un indicador de:],
  ([la potencia máxima que soporta la antena], [la ganancia de la antena], [el grado de adaptación de impedancias entre el transmisor y la antena], [la altura efectiva de la antena]),
  sol: [La ROE mide el grado de adaptación de impedancias entre transmisor, línea y antena.],
)

#q("T6.11", "a",
  [Con un acoplamiento óptimo entre el transmisor y la antena, el medidor de ondas estacionarias indicará:],
  ([uno], [cero], [infinito], [cincuenta]),
  sol: [Adaptación perfecta $arrow.r.double$ sin onda reflejada $arrow.r.double$ ROE = 1 (1:1).],
)

#q("T6.12", "a",
  [El dispositivo que se emplea para conectar un cable coaxial (línea asimétrica) a un dipolo (antena simétrica) es:],
  ([un balun], [un atenuador], [un duplexor], [un preamplificador]),
  sol: [El balun (_balanced–unbalanced_) hace de transición entre el coaxial (asimétrico) y el dipolo (simétrico), evitando corrientes en la malla.],
)

== La estación y su adaptación <t6-sec-estacion>

#motivacion(titulo: [El transmisor quiere ver 50 Ω])[
  La etapa final del transmisor y su filtro de salida están diseñados para entregar la potencia nominal sobre 50 Ω. Con otra carga, la tensión o la corriente en los transistores de salida superan los límites de diseño. Por eso los equipos modernos miden la potencia reflejada y bajan la potencia por sí solos cuando la ROE pasa de 2:1, más o menos. Y la antena casi nunca presenta 50 Ω en todas las bandas. Entre los dos hace falta algo que «traduzca» la impedancia.
]

En la estación, los equipos se encadenan en un orden canónico: transceptor, (amplificador lineal si lo hay), medidor de ROE, acoplador de antena y antena. Con las tres impedancias iguales, el vatímetro direccional lee potencia reflejada nula; cualquier lectura de reflejada delata desadaptación. Es la traducción práctica de toda la teoría anterior — y la fuente de varias preguntas del banco.

#circuito(caption: [Cadena de una estación de HF, del equipo a la antena. El amplificador lineal es opcional; si lo hay, va antes del medidor, para que este lea la potencia real que sale hacia la antena.])[
  #set text(size: 8.5pt)
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (6mm, 8mm),
    node((0, 0), [Transceptor], shape: rect),
    edge("-|>"),
    node((1, 0), [Lineal \ (opcional)], shape: rect, stroke: (dash: "dashed", thickness: 0.7pt)),
    edge("-|>"),
    node((2, 0), [Medidor \ de ROE], shape: rect),
    edge("-|>"),
    node((3, 0), [Acoplador], shape: rect),
    edge("-"),
    node((4, 0), text(fill: col.gris)[línea \ coaxial], stroke: none),
    edge("-|>"),
    node((5, 0), [Balun], shape: rect),
    edge("-|>"),
    node((6, 0), [Antena], shape: rect),
  )
] <t6-fig-estacion>

#porque[
  - *El medidor de ROE* va justo a la salida del equipo (o del lineal): mide la potencia directa y la reflejada que ve el transmisor. Es la lectura que se usa para ajustar el acoplador.
  - *El acoplador* transforma la impedancia que presenta la línea con la antena en los 50 Ω que pide el transmisor. Con el acoplador bien ajustado, el medidor marca reflejada cero.
  - *La línea* lleva la energía hasta la antena; si la antena no es de 50 Ω, en ella hay onda estacionaria aunque el medidor marque 1:1 (el acoplador no la quita: solo «la esconde» al transmisor).
  - *El balun*, en el punto de alimentación, impide que la malla del coaxial radie cuando la antena es simétrica.
]

#ptitulo[El vatímetro direccional] Un acoplador direccional dentro del aparato toma una muestra minúscula de la onda que va hacia la antena y otra de la que vuelve, y las mide por separado. De las dos lecturas sale la ROE, con $|rho| = sqrt(P_"refl"\/P_"dir")$. Un medidor de ROE es lo mismo, con la escala ya calculada. Con todo adaptado, la reflejada es cero (pregunta T6.13).

=== El acoplador por dentro: redes en L, en pi y en T

#motivacion[El acoplador tiene que convertir, por ejemplo, 200 Ω en 50 Ω sin gastar potencia. Una resistencia no sirve: se quedaría con parte de la energía. ¿Cómo lo hacen unas bobinas y unos condensadores, que no disipan nada?]

La idea de fondo está en #ver(<sec-redes-adaptacion>). Una resistencia en paralelo con una reactancia equivale, a una frecuencia dada, a otra resistencia *más pequeña* en serie con una reactancia. Basta con anular después esa reactancia con otra de signo contrario: queda una resistencia pura, más pequeña que la original. Bobinas y condensadores solo almacenan y devuelven energía, así que, idealmente, la transformación no pierde nada.

#circuito(caption: [Red en L que adapta una antena de 200 Ω a un transmisor de 50 Ω en 7 MHz. El elemento en paralelo va siempre en el lado de impedancia alta.], sim: "tlmatch1.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content
    node("a", (0, 2), fill: false)
    inductor("l", (0, 2), (2.6, 2))
    content((1.3, 2.45), anchor: "south", text(size: 8.5pt)[$L = 1,97$ μH])
    wire((2.6, 2), (3.6, 2))
    capacitor("c", (3.6, 2), (3.6, 0))
    content((4.15, 1), anchor: "west", text(size: 8.5pt)[$C = 197$ pF])
    node("n1", (3.6, 2))
    wire((3.6, 2), (6.4, 2))
    resistor("ra", (6.4, 2), (6.4, 0))
    content((6.8, 1), anchor: "west", text(size: 8.5pt)[antena \ 200 Ω])
    wire((0, 0), (6.4, 0))
    node("b", (0, 0), fill: false)
    node("n2", (3.6, 0))
    content((-0.15, 1), anchor: "east", text(size: 8pt)[del TX \ (50 Ω)])
  })
] <t6-fig-redl>

#porque[
  - *$C$ en paralelo con los 200 Ω*: a 7 MHz su reactancia es de 115 Ω, comparable a la resistencia. La pareja equivale a 50 Ω en serie con una reactancia capacitiva de 86,6 Ω.
  - *$L$ en serie*: su reactancia de +86,6 Ω anula la capacitiva. El transmisor ve 50 Ω resistivos: ROE 1.
  - *Sin pérdidas*: ningún componente disipa; la bobina y el condensador se pasan la energía de uno a otro en cada ciclo.
  - *Solo a una frecuencia*: las reactancias cambian con $f$. Al cambiar de banda hay que reajustar: por eso el acoplador tiene mandos (o motores, si es automático).
  - El ejemplo de Falstad hace lo mismo para adaptar 75 Ω a 300 Ω a 90 MHz, con una copia sin adaptar al lado para comparar.
]

#ejemplo(titulo: [Calcular la red en L de 200 Ω a 50 Ω en 7 MHz])[
  El «factor de transformación» es $Q = sqrt(R_"alta"\/R_"baja" - 1) = sqrt(200\/50 - 1) = sqrt(3) approx 1,73$.
  - Reactancia en paralelo (lado de 200 Ω): $X_C = R_"alta"\/Q = 200\/1,73 approx 115$ Ω, es decir, $C = 1\/(2 pi dot 7 dot 10^6 dot 115) approx 197$ pF.
  - Reactancia en serie (lado de 50 Ω): $X_L = Q dot R_"baja" = 1,73 dot 50 approx 86,6$ Ω, es decir, $L = 86,6\/(2 pi dot 7 dot 10^6) approx 1,97$ μH.
  Comprobación: 200 Ω en paralelo con $-j 115$ Ω da $50 - j 86,6$ Ω; al sumar $+j 86,6$ Ω de la bobina quedan 50 Ω.
]

// FALSTAD-CUSTOM: red-pi
#circuito(caption: [Red en pi: condensador en paralelo, bobina en serie y condensador en paralelo. Es la red de salida de los amplificadores de válvulas y la de muchos acopladores.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    node("a", (0, 2), fill: false)
    wire((0, 2), (1.2, 2))
    capacitor("c1", (1.2, 2), (1.2, 0), variable: true)
    content((0.5, 1), anchor: "east", text(size: 8.5pt)[$C_1$ \ (sintonía)])
    node("n1", (1.2, 2))
    inductor("l", (1.2, 2), (3.8, 2))
    content((2.5, 2.45), anchor: "south", text(size: 8.5pt)[$L$])
    capacitor("c2", (3.8, 2), (3.8, 0), variable: true)
    content((4.55, 1), anchor: "west", text(size: 8.5pt)[$C_2$ \ (carga)])
    node("n2", (3.8, 2))
    wire((3.8, 2), (5, 2))
    node("b", (5, 2), fill: false)
    wire((0, 0), (5, 0))
    node("c", (0, 0), fill: false)
    node("d", (5, 0), fill: false)
    node("n3", (1.2, 0))
    node("n4", (3.8, 0))
    ground("g", (2.5, 0))
    content((-0.15, 2), anchor: "east", text(size: 8pt)[del TX])
    content((5.15, 2), anchor: "west", text(size: 8pt)[a la antena])
  })
] <t6-fig-redpi>

#porque[
  - *Dos redes en L espalda con espalda*: $C_1$ y la primera parte de $L$ bajan la impedancia hasta un valor intermedio; la segunda parte de $L$ y $C_2$ la vuelven a subir hasta la de la carga. Con tres mandos se elige, además de la transformación, el $Q$ de la red (su selectividad).
  - *Es un paso bajo*: los condensadores en paralelo derivan a masa las frecuencias altas y la bobina en serie las frena. Los armónicos del transmisor se atenúan: el acoplador en pi adapta y, de paso, filtra (pregunta T6.23).
  - *En los finales de válvulas*, $C_1$ es el mando de *sintonía* (se busca el mínimo de corriente de placa) y $C_2$ el de *carga* (se ajusta el acoplo hasta la potencia deseada).
]

// FALSTAD-CUSTOM: red-T
#circuito(caption: [Red en T: condensador en serie, bobina en paralelo y condensador en serie. Es la red de la mayoría de los acopladores manuales comerciales.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    node("a", (0, 2), fill: false)
    capacitor("c1", (0, 2), (2, 2), variable: true)
    content((1, 2.55), anchor: "south", text(size: 8.5pt)[$C_1$])
    node("n1", (2.5, 2))
    wire((2, 2), (3, 2))
    inductor("l", (2.5, 2), (2.5, 0))
    content((2.95, 1), anchor: "west", text(size: 8.5pt)[$L$])
    capacitor("c2", (3, 2), (5, 2), variable: true)
    content((4, 2.55), anchor: "south", text(size: 8.5pt)[$C_2$])
    node("b", (5, 2), fill: false)
    wire((0, 0), (5, 0))
    node("c", (0, 0), fill: false)
    node("d", (5, 0), fill: false)
    node("n2", (2.5, 0))
    ground("g", (3.6, 0))
    content((-0.15, 2), anchor: "east", text(size: 8pt)[del TX])
    content((5.15, 2), anchor: "west", text(size: 8pt)[a la antena])
  })
] <t6-fig-redt>

#porque[
  - *El mismo principio* que la pi, con los papeles cambiados: reactancias en serie a los lados y una en paralelo en el centro.
  - *Cubre un margen enorme* de impedancias con condensadores variables de tamaño razonable: por eso es la más común en los acopladores manuales.
  - *Es un paso alto*: deja pasar los armónicos, no filtra. Y en los ajustes extremos circula mucha corriente por la bobina y se pierde potencia. Regla práctica: de los ajustes que dan ROE 1, quedarse con el de *mayor capacidad*, que es el de menos pérdidas.
]

#ojo(titulo: [Lo que el acoplador no hace])[
  El acoplador no mejora la antena ni su ganancia (pregunta T6.15): solo hace que el transmisor vea 50 Ω. Entre el acoplador y la antena la desadaptación sigue ahí, con su onda estacionaria y sus pérdidas en el cable. Por eso, cuando se puede, el acoplador se coloca junto a la antena (acopladores automáticos remotos): así la desadaptación queda en unos centímetros de cable y no en treinta metros.
]

#q("T6.13", "b",
  [Si el transmisor, la línea de alimentación y la antena tienen la misma impedancia a la frecuencia de trabajo, un vatímetro direccional intercalado indicará que:],
  ([la potencia directa y la reflejada son iguales], [la potencia reflejada es cero], [la potencia directa es cero], [la ROE es infinita]),
  sol: [Con las tres impedancias iguales no hay onda reflejada: el vatímetro direccional marca potencia reflejada cero (y toda la directa va a la antena).],
)

#q("T6.14", "a",
  [El máximo de radiación del diagrama de una antena vertical se produce:],
  ([en el plano horizontal], [hacia el cénit], [a 45 grados de elevación], [hacia el suelo]),
  sol: [Un elemento radiante emite al máximo perpendicularmente a su eje y no a lo largo de él; puesta en vertical, la antena tiene su nulo hacia el cénit y su máximo en el plano horizontal —bajo ángulo—, justo lo que interesa para DX en las bandas bajas.],
)

#q("T6.15", "d",
  [El acoplador de antena se emplea para:],
  ([amplificar la señal recibida], [aumentar la ganancia de la antena], [filtrar el ruido atmosférico], [adaptar la impedancia de la etapa final a la línea de transmisión y la antena]),
  sol: [El acoplador transforma la impedancia que ve el final de potencia para adaptarla a la línea y la antena; no mejora la antena, mejora la transferencia.],
)

#q("T6.16", "c",
  [En el diagrama de radiación de una antena directiva, la diferencia en decibelios entre el lóbulo principal y el lóbulo trasero se denomina:],
  ([ancho de haz], [ganancia isótropa], [relación adelante-atrás], [pérdida de retorno]),
  sol: [La relación adelante-atrás compara, en dB, el lóbulo principal con el trasero: cuanto mayor, mejor rechaza la antena lo que llega por la espalda.],
)

#q("T6.17", "a",
  [El orden correcto de conexión de los equipos de una estación, desde el equipo hasta la antena, es:],
  ([transceptor, medidor de ROE, acoplador de antena, antena], [acoplador de antena, transceptor, medidor de ROE, antena], [medidor de ROE, acoplador de antena, transceptor, antena], [antena, transceptor, acoplador, medidor de ROE]),
  sol: [Orden canónico: transceptor → medidor de ROE → acoplador → antena (si hay amplificador lineal, va entre el transceptor y el medidor).],
)

#q("T6.18", "b",
  [Se conoce como «frecuencia de corte» de una guía de onda a la frecuencia:],
  ([máxima que soporta la guía sin fundirse], [por debajo de la cual no es posible la transmisión en la guía], [de resonancia del último modo], [a la que la atenuación es mínima]),
  sol: [La guía de onda solo propaga por encima de su frecuencia de corte; por debajo, el modo no puede existir y la señal se atenúa exponencialmente.],
)

#q("T6.19", "c",
  [Para un acoplamiento óptimo entre el transmisor y la antena, la línea de transmisión debe tener una impedancia:],
  ([el doble que la de la antena], [la mitad que la del transmisor], [igual a la de la antena y a la del transmisor], [lo más alta posible]),
  sol: [Adaptación total: la línea debe tener la misma impedancia que la antena y que el transmisor (los 50 Ω del sistema).],
)

#q("T6.20", "a",
  [La ROE de una instalación se puede expresar mediante la fórmula:],
  ([intensidad máxima / intensidad mínima (de la onda estacionaria)], [potencia directa × potencia reflejada], [tensión de pico / tensión eficaz], [ganancia / directividad]),
  sol: [$"ROE" = V_"máx" \/ V_"mín"$ (o $I_"máx" \/ I_"mín"$) de la onda estacionaria sobre la línea; con ROE 1:1 no hay máximos ni mínimos: la onda es viajera pura.],
)

#q("T6.21", "b",
  [El circuito eléctrico equivalente de una antena en resonancia es:],
  ([un condensador puro], [una resistencia pura], [una bobina pura], [un circuito abierto]),
  sol: [En resonancia las reactancias se cancelan y solo queda la parte resistiva (radiación más pérdidas): el equivalente es una resistencia pura.],
)

#q("T6.22", "c",
  [Un diagrama de radiación como el de la @t6-fig-diagrama[figura], con un lóbulo principal dominante, corresponde a una antena de tipo:],
  ([omnidireccional], [isótropa], [directiva], [de campo cercano]),
  sol: [Un lóbulo principal dominante significa energía concentrada en una dirección: antena directiva. La omnidireccional radiaría un círculo y la isótropa, una esfera ideal.],
)

#q("T6.23", "a",
  [El circuito de la figura, conectado entre el transmisor y la antena, se utiliza como:
    #align(center, esquema({
      import zap: *
      import cetz.draw: content
      node("a", (0, 2), fill: false)
      wire((0, 2), (5.2, 2))
      node("n1", (1.4, 2))
      node("n2", (3.8, 2))
      inductor("l", (2, 2), (3.2, 2))
      capacitor("c1", (1.4, 2), (1.4, 0.4), variable: true)
      capacitor("c2", (3.8, 2), (3.8, 0.4), variable: true)
      earth("g1", (1.4, 0.4))
      earth("g2", (3.8, 0.4))
      node("b", (5.2, 2), fill: false)
      content((-0.15, 2), anchor: "east", text(size: 8pt, fill: col.gris)[del transmisor])
      content((5.35, 2), anchor: "west", text(size: 8pt, fill: col.gris)[a la antena])
    }))
  ],
  ([acoplador de antena (red en pi)], [rectificador de onda completa], [modulador balanceado], [atenuador resistivo]),
  sol: [Condensador variable en derivación, bobina en serie y otro condensador en derivación: la red en pi clásica del acoplador de antena, que transforma impedancias y de paso filtra armónicos (es un paso bajo).],
)

== La conmutación de antena <t6-sec-conmutacion>

Un transceptor tiene una sola antena y dos usos incompatibles para ella: entregarle cien vatios cuando transmite y recoger de ella microvoltios cuando escucha. Quien reparte ese único cable es el *conmutador de antena* (@t6-fig-conmutador[figura]).

En los equipos es un *relé de transmisión-recepción* — el relé T-R — que conmuta al pulsar el PTT. Su papel no es solo de tráfico: mientras se transmite, el relé _desconecta_ la entrada del receptor y la deja a masa. Sin esa protección, los vatios del propio transmisor entrarían por la entrada de antena del receptor y destruirían su primera etapa, que está pensada para señales millones de veces menores. De ahí que el chasquido del relé al pasar a transmitir sea, en realidad, el ruido de un seguro cerrándose.

El otro conmutador de la estación es el *selector de antenas*, una llave de varias posiciones que permite que un mismo equipo ataque al dipolo de HF, a la vertical o a la Yagi de VHF sin andar cambiando conectores. En las posiciones que no se usan lo correcto es dejar las antenas a masa: así se derivan las cargas estáticas que el viento y la lluvia depositan en ellas, y se está más tranquilo en tormenta (tema T10).

#circuito(caption: [El conmutador de antena reparte una única antena entre transmisor y receptor. Al transmitir, la entrada del receptor queda desconectada: es lo que la protege de la potencia del propio equipo.])[
  #cetz.canvas({
    import cetz.draw: *
    let caja(c, t) = {
      rect((c.at(0) - 0.9, c.at(1) - 0.32), (c.at(0) + 0.9, c.at(1) + 0.32), fill: col.acento-claro, stroke: 0.6pt + col.acento, radius: 0.08)
      content(c, text(size: 8pt, t))
    }
    caja((0, 2), [transmisor])
    caja((0, 0), [receptor])
    line((0.9, 2), (2.8, 2), stroke: 0.7pt)
    line((0.9, 0), (2.8, 0), stroke: 0.7pt)
    circle((2.8, 2), radius: 0.05, fill: black)
    circle((2.8, 0), radius: 0.05, fill: black)
    // brazo del relé en posición de transmisión
    line((2.8, 2), (3.35, 1.0), stroke: 1.3pt + col.naranja)
    circle((3.35, 1.0), radius: 0.06, fill: black)
    line((3.35, 0.95), (3.35, 0.15), stroke: (paint: col.gris, thickness: 0.5pt, dash: "dotted"))
    line((3.35, 1.0), (6.4, 1.0), stroke: 0.9pt)
    _t6-et((4.85, 0.9), text(fill: col.gris)[coaxial], anchor: "north", size: 7.5pt)
    // antena
    line((6.4, -0.3), (6.4, 2.5), stroke: 1.2pt)
    for r in (0.3, 0.55, 0.8) {
      arc((6.6 + r * calc.cos(-40deg), 1.9 + r * calc.sin(-40deg)), start: -40deg, stop: 40deg, radius: r, stroke: 0.7pt + col.acento.lighten(30%))
    }
    _t6-et((6.4, -0.4), text(fill: col.gris)[antena], anchor: "north", size: 7.5pt)
    _t6-et((3.0, 2.45), text(fill: col.naranja)[posición de transmisión], anchor: "south", size: 7.5pt)
    _t6-et((3.0, -0.55), [*conmutador (relé T-R)*], anchor: "north")
  })
] <t6-fig-conmutador>

#porque[
  - *Al pulsar el PTT* se activa la bobina del relé y el contacto común pasa de la posición de recepción a la de transmisión: la antena queda unida al transmisor.
  - *El receptor se queda fuera*, y en los buenos equipos su entrada se pone a masa: la poca RF que se cuele entre los contactos se va a tierra en lugar de entrar en la primera etapa.
  - *Primero conmutar, después emitir*: el equipo espera unos milisegundos tras el PTT antes de sacar potencia. Si el relé conmutara con RF presente («en caliente»), saltaría una chispa que quema los contactos.
  - *Sin relé*, o con un relé averiado, los vatios del transmisor llegarían directamente a un amplificador diseñado para microvoltios.
]

#ejemplo(titulo: [¿Cuántas veces más potente es lo que sale que lo que entra?])[
  Transmitiendo, 100 W son +50 dBm. Una señal de S9 en HF son 50 μV sobre 50 Ω: $P = V^2\/R = (50 dot 10^(-6))^2\/50 = 5 dot 10^(-11)$ W, es decir, −73 dBm. La diferencia es de 123 dB: la potencia propia es unos dos billones ($2 dot 10^12$) de veces mayor que la señal que el receptor está hecho para manejar.
]

#ojo[T6.24: el conmutador *conecta la antena alternativamente* al transmisor o al receptor; adaptar impedancias es cosa del acoplador, y filtrar armónicos, del filtro de salida. T6.25: al transmitir, el relé *desconecta y protege* la entrada del receptor. T6.26: el selector de varias posiciones elige *qué antena* se usa; no reparte la potencia entre todas.]

#q("T6.24", "b",
  [El conmutador de antena de una estación permite:],
  ([adaptar la impedancia de la antena a la del transmisor], [conectar la antena alternativamente al transmisor o al receptor], [medir la relación de ondas estacionarias], [eliminar los armónicos de la emisión]),
  sol: [La antena es una sola y los usos son incompatibles: el conmutador decide en cada momento quién la tiene. Adaptar impedancias es cosa del acoplador y filtrar armónicos, del filtro de salida.],
)

#q("T6.25", "c",
  [Durante la transmisión, el relé de transmisión-recepción de un transceptor:],
  ([conecta el receptor en paralelo con la antena], [aumenta la ganancia de la etapa de entrada del receptor], [desconecta la entrada del receptor y la protege de la potencia emitida], [conmuta la polarización de la antena]),
  sol: [La primera etapa del receptor está diseñada para microvoltios; los vatios del propio transmisor la destruirían. Por eso el relé la desconecta —y normalmente la pone a masa— mientras se transmite.],
)

#q("T6.26", "a",
  [Un conmutador de antenas de varias posiciones se emplea para:],
  ([elegir, desde un mismo equipo, cuál de las antenas de la estación se usa], [repartir la potencia entre todas las antenas a la vez], [transformar una línea asimétrica en simétrica], [sintonizar la antena en varias bandas]),
  sol: [Evita andar cambiando conectores cada vez que se cambia de banda. Conviene que las posiciones libres queden a masa, para derivar la estática que se acumula en las antenas no usadas. Transformar simétrica en asimétrica es tarea del balun.],
)

#q("T6.27", "d",
  [En una antena vertical de cuarto de onda, inclinar los radiales hacia abajo produce:],
  ([una disminución de la frecuencia de resonancia], [un cambio de polarización a horizontal], [la desaparición del plano de tierra], [un aumento de la impedancia en el punto de alimentación]),
  sol: [Con los radiales horizontales la impedancia ronda los 36 ohmios; al inclinarlos unos 45° sube hasta las proximidades de 50 ohmios, que es justo lo que el coaxial habitual pide. Es un truco de adaptación, no de sintonía.],
)

#q("T6.28", "b",
  [La principal ventaja de un dipolo montado en V invertida es que:],
  ([radia exclusivamente en polarización horizontal], [necesita un solo soporte central en lugar de dos], [no requiere línea de transmisión], [duplica la ganancia del dipolo horizontal]),
  sol: [Se cuelga del centro y los extremos caen hacia abajo, así que con un único mástil se resuelve la instalación. A cambio, la radiación pierde algo de la horizontalidad pura del dipolo plano.],
)

#q("T6.29", "a",
  [El tamaño físico que debe tener una antena está en función de:],
  ([la longitud de onda de trabajo], [la potencia del transmisor], [la impedancia del cable coaxial], [el tipo de modulación empleada]),
  sol: [Una antena resuena cuando su longitud guarda una relación concreta con la longitud de onda —media onda el dipolo, un cuarto la vertical—, y por eso las antenas de HF son enormes y las de UHF caben en la mano. La potencia solo condiciona el grosor de los conductores y los aislantes.],
)

#q("T6.30", "c",
  [Se dice que una antena es pasiva cuando:],
  ([está construida con elementos no metálicos], [solo puede emplearse en recepción], [no incorpora ningún elemento amplificador], [carece de elementos directores]),
  sol: [Una antena pasiva no añade energía: su «ganancia» consiste en concentrar en una dirección la que ya tiene. Las activas llevan un preamplificador incorporado y necesitan alimentación.],
)

#q("T6.31", "d",
  [La velocidad de propagación de una onda por el interior de una línea de transmisión, comparada con su velocidad en el aire, es:],
  ([mayor], [la misma], [mayor o menor según la frecuencia], [menor]),
  sol: [El dieléctrico que separa los conductores frena la onda. Esa reducción es el factor de velocidad, típicamente 0,66 en un coaxial de polietileno macizo y hasta 0,8 en los de dieléctrico celular.],
)

#q("T6.32", "a",
  [En una línea de transmisión perfectamente adaptada a la antena, el coeficiente de reflexión vale:],
  ([cero], [uno], [infinito], [el mismo valor que la ROE]),
  sol: [Adaptación perfecta significa que la antena absorbe toda la potencia que le llega y no devuelve nada: no hay onda reflejada, luego el coeficiente es cero y la ROE vale 1. Ojo con confundir ambos números: la ROE en ese caso es 1, no 0.],
)

#q("T6.33", "b",
  [Comparadas entre sí, la longitud física y la longitud eléctrica de un tramo de cable coaxial cumplen que:],
  ([ambas son siempre iguales], [la longitud física es menor que la eléctrica], [la longitud física es mayor que la eléctrica], [su relación depende de la potencia aplicada]),
  sol: [Como la onda va más despacio dentro del cable, la longitud de onda allí es más corta: $L_"fís" = L_"el" times "FV"$, con FV < 1 (0,66 en un coaxial de polietileno). Para conseguir media onda eléctrica basta con menos cable del que haría falta en el aire: la longitud física es menor que la eléctrica. Solo serían iguales en el vacío (FV = 1), y la potencia aplicada no interviene. Ojo: alguna lista publicada da por buena la opción contraria («la física es mayor»); es un error.],
)

#q("T6.34", "c",
  [La ganancia de una antena se expresa normalmente en:],
  ([vatios radiados], [ohmios de impedancia], [decibelios respecto de una antena de referencia (dBi o dBd)], [metros de longitud de onda]),
  sol: [La ganancia es siempre una comparación, nunca una cantidad absoluta: dBi si se compara con el radiador isótropo teórico y dBd si se compara con un dipolo de media onda. Entre ambas escalas hay 2,15 dB de diferencia — el dipolo ya gana eso sobre el isótropo—, así que una misma antena tiene dos cifras según cómo se exprese.],
)

#q("T6.35", "d",
  [Una antena vertical de cuarto de onda necesita, para funcionar correctamente:],
  ([una línea de alimentación simétrica], [alimentarse siempre por su extremo superior], [una longitud igual a media longitud de onda], [un plano de tierra o un juego de radiales]),
  sol: [La vertical es, en el fondo, media antena: el plano de tierra hace de espejo y crea la otra mitad por imagen. Sin él no hay contra qué trabajar y el rendimiento se desploma.],
)

#q("T6.36", "b",
  [La impedancia que presenta en su punto de alimentación un dipolo de media onda en resonancia, situado en el espacio libre, es aproximadamente de:],
  ([300 ohmios], [73 ohmios], [50 ohmios], [600 ohmios]),
  sol: [Ese valor teórico de unos 73 ohmios es lo que hace que el coaxial de 50 o de 75 ohmios sea una elección razonable para alimentarlo. Los 300 ohmios son los del dipolo plegado, y los 600, los de una línea bifilar abierta.],
)

#q("T6.37", "b",
  [En una antena Yagi, los elementos parásitos:],
  ([van conectados a la línea de transmisión], [proporcionan directividad a la antena], [sustituyen al elemento radiante], [sirven únicamente de soporte mecánico]),
  sol: [No están conectados a la línea: reciben energía por inducción del elemento alimentado y la reirradian con una fase distinta, de modo que las ondas se refuerzan hacia delante y se cancelan hacia atrás. De ahí la directividad.],
)

#q("T6.38", "a",
  [En una antena pasiva puede afirmarse que:],
  ([su diagrama de radiación en transmisión y en recepción es el mismo], [radia mejor de lo que recibe], [recibe mejor de lo que radia], [su diagrama cambia con la potencia aplicada]),
  sol: [Es el principio de reciprocidad: una antena se comporta igual emitiendo que recibiendo, con el mismo diagrama y la misma ganancia. Por eso apuntar una directiva sirve tanto para transmitir como para escuchar.],
)

#q("T6.39", "c",
  [Las bobinas intercaladas en los brazos de un dipolo permiten:],
  ([aumentar la potencia admisible], [mejorar la relación delante-detrás], [incrementar su longitud eléctrica sin alargarla físicamente], [convertirlo en una antena vertical]),
  sol: [La bobina añade la reactancia inductiva que le falta a una antena más corta de lo que la resonancia pediría, de modo que eléctricamente «parece» más larga. Es el recurso de las antenas de móvil, cortas por necesidad.],
)

#q("T6.40", "d",
  [Se dice que una antena es omnidireccional cuando:],
  ([concentra la radiación en una única dirección], [no radia en absoluto], [solo funciona en recepción], [radia por igual en todas las direcciones del plano horizontal]),
  sol: [Radia lo mismo hacia todos los rumbos, que es lo propio de una vertical. No significa que radie igual en todas las direcciones del espacio: en elevación sí tiene un diagrama con máximos y mínimos.],
)

#q("T6.41", "c",
  [En una antena helicoidal, la ganancia depende fundamentalmente de:],
  ([el material del mástil], [la potencia aplicada], [el número de espiras], [el color del recubrimiento]),
  sol: [Cuantas más espiras, mayor longitud de la hélice y más concentrada queda la radiación en el eje. Es una antena de polarización circular, muy usada en enlaces con satélites.],
)

#q("T6.42", "b",
  [El factor de velocidad de un cable coaxial se relaciona con la constante dieléctrica $epsilon_r$ de su aislante mediante:],
  ([el producto por $epsilon_r$], [la inversa de la raíz cuadrada de $epsilon_r$], [la raíz cuadrada de $epsilon_r$], [una relación independiente del dieléctrico]),
  sol: [$v_f = 1\/sqrt(epsilon_r)$. Un polietileno macizo, con $epsilon_r approx 2,3$, da un factor de velocidad de unos 0,66: la onda viaja al 66 % de la velocidad de la luz.],
)

#q("T6.43", "d",
  [La máxima transferencia de energía del transmisor a la antena se produce cuando:],
  ([la antena es lo más larga posible], [la línea de transmisión es lo más corta posible], [se emplea la máxima potencia disponible], [las impedancias del emisor, de la línea y de la antena coinciden]),
  sol: [Es el teorema de la máxima transferencia de potencia aplicado a la estación: con las tres impedancias iguales no hay reflexión y toda la potencia disponible llega a la antena. Alargar la antena o subir la potencia no sustituye a la adaptación.],
)

== Preguntas sobre esquemas y casos prácticos <t6-sec-esquemas>

#q("T6.44", "d",
  [En la instalación de la figura, donde las tres impedancias coinciden, puede afirmarse que:
    #align(center, cetz.canvas({
      import cetz.draw: *
      for (x, t) in ((0, [transmisor]), (4, [línea]), (8, [antena])) {
        rect((x - 1, -0.38), (x + 1, 0.38), fill: col.acento-claro, stroke: 0.6pt + col.acento, radius: 0.08)
        content((x, 0.12), text(size: 7.5pt, t))
        content((x, -0.17), text(size: 7.5pt)[50 Ω])
      }
      line((1, 0), (3, 0), stroke: 0.7pt)
      line((5, 0), (7, 0), stroke: 0.7pt)
    }))
  ],
  ([la ROE resultante vale cero], [la potencia reflejada es la mitad de la directa], [se necesita un acoplador de antena], [la potencia reflejada es nula]),
  sol: [Con las tres impedancias iguales la línea está terminada en su impedancia característica: la antena absorbe toda la potencia y no devuelve nada. El coeficiente de reflexión es cero y la ROE vale 1 — no cero, que es el error clásico.],
)

#q("T6.45", "a",
  [Las bobinas intercaladas en los brazos del dipolo de la figura hacen que la antena resuene:
    #align(center, esquema({
      import zap: *
      import cetz.draw: content, line
      line((-6, 0), (-3.4, 0), .._t6-hilo)
      inductor("l1", (-3.4, 0), (-2.2, 0))
      wire((-2.2, 0), (-0.25, 0))
      wire((-0.25, 0), (-0.25, -0.75))
      wire((0.25, 0), (0.25, -0.75))
      wire((0.25, 0), (2.2, 0))
      inductor("l2", (2.2, 0), (3.4, 0))
      line((3.4, 0), (6, 0), .._t6-hilo)
      content((-2.8, 0.6), text(size: 7.5pt, fill: col.gris)[bobina])
      content((2.8, 0.6), text(size: 7.5pt, fill: col.gris)[bobina])
      content((0, -1.05), text(size: 7.5pt, fill: col.gris)[alimentación])
    }))
  ],
  ([a una frecuencia más baja que la que le correspondería por su longitud física], [a una frecuencia más alta que la que le correspondería por su longitud física], [exactamente a la frecuencia de su longitud física], [a dos frecuencias distintas simultáneamente]),
  sol: [La bobina añade la reactancia inductiva que le falta a una antena corta, de modo que el conjunto resuena por debajo de lo que su longitud física haría esperar. Dicho al revés: permite una antena más corta para la misma frecuencia, que es de lo que se trata en móvil.],
)

#q("T6.46", "c",
  [En el diagrama de radiación de la figura, la diferencia en decibelios entre los puntos 1 y 2 se denomina:
    #align(center, cetz.canvas({
      import cetz.draw: *
      for rr in (0.9, 1.8, 2.7) { circle((0, 0), radius: rr, stroke: 0.4pt + col.gris.lighten(60%)) }
      let lp = a => if calc.cos(a) > 0 { 1.8 * calc.pow(calc.cos(a), 3) } else { 0 }
      let lt = a => if calc.cos(a) < 0 { 0.4 * calc.pow(calc.cos(a), 2) } else { 0 }
      line(.._t6-pts(lp, -90deg, 90deg, n: 160), close: true, stroke: 1.1pt + col.acento, fill: col.acento-claro.transparentize(20%))
      line(.._t6-pts(lt, 90deg, 270deg, n: 100), close: true, stroke: 0.9pt + col.naranja)
      circle((1.8, 0), radius: 0.06, fill: black)
      circle((-0.4, 0), radius: 0.06, fill: black)
      content((1.9, 0), anchor: "west", text(size: 7.5pt, weight: "bold")[1])
      content((-0.5, 0), anchor: "east", text(size: 7.5pt, weight: "bold")[2])
    }))
  ],
  ([ancho de haz], [ganancia isótropa], [relación delante-atrás], [potencia efectiva radiada]),
  sol: [El punto 1 está en el máximo del lóbulo principal y el 2 en el trasero: su cociente en decibelios es la relación delante-atrás, que mide cuánto rechaza la antena lo que viene por detrás. El ancho de haz, en cambio, es una apertura angular, no una diferencia de nivel.],
)
