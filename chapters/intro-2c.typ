#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Macros locales de intro-2c (prefijo _i2c-)
// ---------------------------------------------------------------------

// Texto pequeño para rótulos dentro de las figuras
#let _i2c-t(c, fill: col.tinta) = text(size: 8pt, fill: fill, c)

// Número en un círculo, para los bloques de los diagramas y sus tablas
#let _i2c-n(n) = box(baseline: 25%, width: 11pt, height: 11pt, radius: 5.5pt, stroke: 0.6pt + col.acento, align(center + horizon, text(size: 6.5pt, weight: "bold", fill: col.acento, str(n))))

// Flecha de corriente para los esquemas (ámbar = continua, azul = señal)
#let _i2c-flecha(a, b, c) = cetz.draw.line(a, b, stroke: 1.4pt + c, mark: (end: ">", fill: c, scale: 0.8))

// Diodo varicap: diodo con una placa de condensador junto al cátodo.
#let _i2c-varicap(name, node, ..params) = {
  import cetz.draw: *
  let style = (radius: .3, width: .25)
  let draw(ctx, position, style) = {
    let r = style.radius
    translate((-r / 4, 0))
    zap.interface((-r / 2, -r), (r + .14, r), io: position.len() < 2)
    polygon((0, 0), 3, radius: r, fill: white, ..style)
    line((0deg, r), (180deg, r / 2), ..style.at("wires"))
    line((r, -style.width), (r, style.width), ..style)
    line((r + .14, -style.width), (r + .14, style.width), ..style)
  }
  zap.component("varicap", name, node, draw: draw, style: style, ..params)
}

// Colpitts completo en colector común. `xtal: true` cambia la bobina por un cristal.
#let _i2c-colpitts(xtal: false) = esquema({
  import zap: *
  import cetz.draw: content, line
  // raíles
  wire((1.6, 6), (5.4, 6))
  content((1.6, 6), anchor: "east", padding: 3pt, _i2c-t[+12 V])
  // condensador de desacoplo del colector (colector a masa para la RF)
  capacitor("cd", (5.4, 6), (5.4, 4.6), label: $C_D$)
  ground("gd", (5.4, 4.6))
  // divisor de base
  resistor("r1", (2.0, 6), (2.0, 3.4), label: $R_1$)
  resistor("r2", (2.0, 3.4), (2.0, 0.6), label: $R_2$)
  ground("g2", (2.0, 0.6))
  // transistor
  npn("q1", (4.4, 3.4))
  wire((2.0, 3.4), "q1.b")
  wire("q1.c", (4.4, 6))
  // C1 entre base y emisor, C2 de emisor a masa
  capacitor("c1", (2.9, 3.4), (2.9, 2.2), label: $C_1$)
  wire((2.9, 2.2), (4.4, 2.2))
  wire("q1.e", (4.4, 2.2))
  resistor("re", (4.4, 2.2), (4.4, 0.6), label: (content: $R_E$, anchor: "south"))
  ground("ge", (4.4, 0.6))
  wire((4.4, 2.2), (5.6, 2.2))
  capacitor("c2", (5.6, 2.2), (5.6, 0.6), label: $C_2$)
  ground("gc2", (5.6, 0.6))
  // salida ligera desde el emisor
  capacitor("cs", (5.6, 2.2), (7.0, 2.2), label: $C_"sal"$, n: "*-o")
  content((7.1, 2.2), anchor: "west", _i2c-t[RF a $f_0$])
  // resonador
  if xtal {
    wire((0.2, 3.4), (2.0, 3.4))
    cristal("x1", (0.2, 3.4), (0.2, 0.6), label: (content: [X], anchor: "south"))
    ground("gx", (0.2, 0.6))
  } else {
    capacitor("cb", (0.2, 3.4), (1.4, 3.4), label: $C_B$)
    wire((1.4, 3.4), (2.0, 3.4))
    inductor("l1", (0.2, 3.4), (0.2, 0.6), label: (content: $L$, anchor: "south"))
    ground("gl", (0.2, 0.6))
  }
  zap.node("nb", (2.0, 3.4))
  zap.node("nb2", (2.9, 3.4))
  zap.node("ne", (4.4, 2.2))
})

// =====================================================================
== El cristal y el oscilador: el corazón que late <sec-oscilador>

#motivacion[Toda radio necesita fabricar, ella misma, sinusoides puras y estables. El transmisor necesita la *portadora*: la onda sobre la que cabalga la voz (#ver(<sec-am>)). El receptor superheterodino necesita un *oscilador local* que, mezclado con la emisora, la traslade a la frecuencia intermedia. El receptor de SSB y de CW necesita un tercer oscilador, el *BFO*, que repone la portadora que el transmisor suprimió. Nada de eso llega por la antena: hay que fabricarlo dentro, a partir de la corriente continua de la fuente. Un oscilador es exactamente eso, una máquina que convierte continua en alterna de una frecuencia elegida (la pregunta T3.27 lo dice con estas palabras).]

#ptitulo[Oscilar es un columpio] Toda radio necesita fabricar su portadora: una sinusoide pura, estable, incansable. La receta tiene dos ingredientes que ya tienes. Uno: el circuito tanque LC de #ver(<sec-resonancia>), que si lo cargas y lo sueltas oscila solo a su $f_0 = 1 slash (2 pi sqrt(L C))$… pero cada ciclo pierde un poco en las resistencias y la oscilación muere. Dos: el amplificador de #ver(<sec-amplificador-ec>), capaz de reponer energía. Un *oscilador* es la unión de ambos: se toma una muestra de la oscilación del tanque, se amplifica y se _devuelve al tanque en fase_ — como el empujón al columpio, dado siempre en el momento justo. Si el empujón repone al menos lo que se pierde por vuelta (ganancia de lazo $gt.eq 1$) y llega en fase, la oscilación se sostiene sola; el recorte natural del transistor la estabiliza en amplitud, y del colector sale una sinusoide continua a $f_0$. Todo oscilador — y también todo amplificador que _no debería_ oscilar y lo hace por un acoplo indeseado — responde a esta condición (tema T3).

=== Un amplificador que se escucha a sí mismo

#analogia(titulo: [El pitido de la megafonía])[Acerca un micrófono al altavoz de su propio amplificador y sonará un pitido agudo y sostenido: el *acople* (o efecto Larsen). Nadie lo ha pedido, y sin embargo el sistema genera un tono puro. El micrófono recoge el ruido de la sala, el amplificador lo agranda, el altavoz lo devuelve al micrófono más fuerte de lo que salió, y la vuelta se repite miles de veces por segundo. De todas las frecuencias del ruido gana una sola: la que da la vuelta completa con más ganancia y llega _en fase_ consigo misma. Un oscilador de radio es ese mismo acople, pero provocado a propósito y con un circuito tanque que decide qué frecuencia gana.]

La @i2c-fig-lazo dibuja la idea con dos bloques. Un amplificador de ganancia $A$ entrega su salida; una parte $beta$ de esa salida vuelve, a través de una red de realimentación, a su propia entrada. No hay señal de entrada exterior: la entrada es la propia salida, devuelta.

#circuito(caption: [El oscilador como lazo. El amplificador multiplica por $A$; la red de realimentación devuelve a la entrada una fracción $beta$ de la salida. Si al dar la vuelta completa la señal vuelve igual de grande ($|A beta| = 1$) y en fase (desfase total 0° o 360°), se sostiene sola. La red contiene el tanque LC: solo a $f_0$ cumple la condición de fase.])[
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (14mm, 11mm),
    node((1, 0), align(center)[Amplificador \ ganancia $A$], shape: rect, inset: 7pt, name: <i2c-amp>),
    node((1, 1), align(center)[Red de realimentación $beta$ \ (el tanque LC: elige $f_0$)], shape: rect, inset: 7pt, name: <i2c-beta>),
    node((2.4, 0), [salida], stroke: none),
    edge(<i2c-amp>, (2.4, 0), "-|>"),
    edge((1.9, 0), (1.9, 1), <i2c-beta>, "-|>"),
    edge(<i2c-beta>, (0.1, 1), (0.1, 0), <i2c-amp>, "-|>", label: text(size: 8pt)[la salida vuelve a la entrada], label-side: left),
  )
] <i2c-fig-lazo>

#ptitulo[Las dos condiciones de Barkhausen] Para que el lazo se sostenga solo hacen falta dos cosas, que en el examen llevan el nombre de *condición de Barkhausen*:

+ *Ganancia de lazo igual a 1.* Lo que el amplificador gana ($A$) tiene que compensar exactamente lo que la red pierde ($beta$, menor que 1): $|A beta| = 1$. Si el producto es menor que 1, cada vuelta la señal sale más pequeña y se apaga. Si es mayor que 1, cada vuelta crece.
+ *Fase total de 0° (o 360°).* La señal tiene que volver a la entrada _en fase_ consigo misma, para sumarse y no restarse: el empujón del columpio llega cuando el columpio ya va en ese sentido. Si el amplificador invierte la señal (180°, como el emisor común), la red tiene que aportar otros 180°.

#destacada($|A beta| = 1 quad "y" quad phi_A + phi_beta = 0° " (o 360°)"$, nota: [condición de Barkhausen: ganancia de lazo unidad y fase total nula])

#ptitulo[Cómo arranca y por qué no se desboca] Si la ganancia de lazo fuera _exactamente_ 1 desde el principio, el oscilador nunca arrancaría: no hay nada que amplificar. Por eso se diseña con una ganancia de lazo algo mayor que 1 (típicamente entre 2 y 3). Al conectar la alimentación, el ruido térmico de las resistencias y el propio salto de la tensión contienen un poco de todas las frecuencias. La componente a $f_0$ da la vuelta con ganancia mayor que 1 y crece, vuelta tras vuelta. Las demás frecuencias no cumplen la condición de fase y se extinguen. La oscilación crece hasta que el transistor empieza a recortar en los extremos (corte y saturación): con la señal recortada, la ganancia _media_ baja, y el crecimiento se detiene justo en el punto donde la ganancia de lazo vale 1. El propio transistor hace de regulador de amplitud (@i2c-fig-arranque). El recorte genera armónicos, pero el tanque, que solo resuena a $f_0$, los filtra: es el mismo efecto volante del amplificador de clase C (#ver(<sec-amp-sintonizado>)).

#circuito(sim: "eclosc.txt", caption: [Arranque de un oscilador. Con ganancia de lazo mayor que 1, una perturbación diminuta crece vuelta a vuelta. Cuando la amplitud llega a los límites del transistor, el recorte reduce la ganancia media hasta 1 justo, y la amplitud queda fija.])[
  #cetz.canvas({
    import cetz.draw: *
    ejes(0, 12.4, -1.5, 1.7, etq-x: $t$, etq-y: $v$)
    let env(x) = 1.1 / (1 + 60 * calc.exp(-0.95 * x))
    onda(x => env(x) * calc.sin(6 * x), 0, 12, n: 900, stroke: 1pt + col.senal1)
    onda(x => env(x), 0, 12, n: 200, stroke: (paint: col.senal2, thickness: 0.6pt, dash: "dashed"))
    line((6.3, -1.45), (6.3, 1.45), stroke: (paint: col.gris, thickness: 0.5pt, dash: "dotted"))
    content((3.1, 1.45), _i2c-t[arranque: $|A beta| > 1$, crece])
    content((9.3, 1.45), _i2c-t[régimen: recorte, $|A beta| = 1$])
  })
] <i2c-fig-arranque>

#ojo[El examen pregunta la misma física desde el lado contrario. Un amplificador que *no* debería oscilar oscila si una parte de su salida vuelve a su entrada con ganancia de lazo mayor que 1 y en fase: por un cable de salida que pasa junto al de entrada, una masa mal hecha o la capacidad interna del transistor. Es la respuesta de la pregunta T2.51 («existe un acoplamiento excesivo entre su salida y su entrada»). Los remedios — blindar, separar, desacoplar la alimentación, neutralizar — rompen el lazo.]

=== El tanque decide la frecuencia

¿Por qué hace falta un tanque LC y no basta con cualquier red? Porque la condición de fase debe cumplirse a _una sola_ frecuencia. Recuerda #ver(<sec-resonancia>): un tanque LC paralelo, en su frecuencia de resonancia, presenta impedancia máxima y _resistiva pura_, sin desfase. Un poco por encima, la impedancia es capacitiva y desfasa en un sentido; un poco por debajo, inductiva y desfasa en el otro. Solo en $f_0$ el tanque devuelve la señal sin girarla. Por eso el oscilador «elige» la $f_0$ del tanque: es la única frecuencia que da la vuelta en fase. Y cuanto mayor es el $Q$ del tanque, más rápido cambia la fase al alejarse de $f_0$, y más clavada queda la frecuencia. Esta idea, «la fase cambia muy deprisa junto a $f_0$», es la que hará del cristal el resonador perfecto.

#idea[Un oscilador es un amplificador más un tanque LC en un lazo de realimentación positiva. El amplificador repone la energía que se pierde en cada ciclo; el tanque fija la frecuencia, porque solo a $f_0$ la señal vuelve en fase. Ganancia de lazo algo mayor que 1 para arrancar; el recorte del transistor la deja en 1.]

=== El Colpitts: el tanque con divisor capacitivo

Hay muchas maneras de sacar la muestra del tanque y devolverla en fase. Las dos clásicas, que el examen nombra, se distinguen por _dónde está la toma_ del tanque. La primera parte en dos el condensador.

#circuito(sim: "colpitts.txt", caption: [Oscilador Colpitts, esquemático (polarización omitida por claridad). El tanque lo forman $L$ con $C_1$ y $C_2$ en serie; el punto medio del divisor capacitivo devuelve al emisor una fracción de la oscilación, en fase: el transistor repone en cada ciclo la energía perdida y el tanque no deja nunca de sonar. Con $L = 2,5 thin mu"H"$ y $C_1 = C_2 = 200 "pF"$ (100 pF en serie), oscila en los 10 MHz del ejemplo de #ver(<sec-resonancia>).])[
  #esquema({
    import zap: *
    import cetz.draw: content, line, bezier
    // transistor y colector
    npn("q1", (4, 3.4))
    wire("q1.c", (4, 4.6))
    inductor("ch", (4, 4.6), (4, 6.2), label: [choque])
    content((4, 6.2), anchor: "south", padding: 3pt, _i2c-t[+12 V])
    wire((4, 4.6), (5.2, 4.6))
    capacitor("cs", (5.2, 4.6), (6.6, 4.6), label: $C_"sal"$, n: "-o")
    content((6.75, 4.6), anchor: "west", _i2c-t[RF a $f_0$])
    // tanque
    wire((0, 4.4), (2.6, 4.4))
    wire((2.6, 4.4), (2.6, 3.4))
    wire((2.6, 3.4), "q1.b")
    inductor("l", (0, 4.4), (0, 0.6), label: (content: $L$, anchor: "south"))
    ground("gl", (0, 0.6))
    capacitor("c1", (1.4, 4.4), (1.4, 2.2), label: (content: $C_1$, anchor: "south"))
    capacitor("c2", (1.4, 2.2), (1.4, 0.6), label: (content: $C_2$, anchor: "south"))
    ground("gc", (1.4, 0.6))
    wire((1.4, 2.2), (4, 2.2))
    wire("q1.e", (4, 2.2))
    zap.node("n1", (1.4, 4.4))
    zap.node("n2", (1.4, 2.2))
    // flecha de realimentación
    bezier((1.75, 1.85), (3.7, 2.0), (2.7, 1.3), stroke: 0.9pt + col.acento, mark: (end: ">", fill: col.acento))
    content((2.9, 0.95), align(center, _i2c-t(fill: col.acento)[realimentación: \ el empujón, en fase]))
  })
] <i2c-fig-colpitts>

#porque(titulo: [el Colpitts de la @i2c-fig-colpitts])[
  - *El tanque* es $L$ en paralelo con la pareja $C_1$–$C_2$ en serie. Su frecuencia es la de Thomson con la capacidad serie: $C = C_1 C_2 slash (C_1 + C_2)$.
  - *La toma capacitiva.* El punto medio entre $C_1$ y $C_2$ es un divisor de tensión hecho con condensadores: allí aparece una fracción fija de la oscilación del tanque, $C_1 slash (C_1 + C_2)$ (la mitad si son iguales), en fase con ella. Ese punto va al emisor.
  - *El transistor* tiene la base en lo alto del tanque y el emisor en la toma. Cuando la tensión del tanque sube, la base sube más que el emisor, el transistor conduce más y empuja corriente hacia la toma: corriente en fase con la tensión, es decir, energía que entra en el tanque. Es el empujón del columpio en el momento justo.
  - *El choque* (una bobina grande) lleva la continua al colector pero frena la RF: la corriente de RF del colector sale por $C_"sal"$ hacia la etapa siguiente en lugar de perderse en la fuente.
  - *Sin $C_2$* la toma seguiría exactamente a lo alto del tanque: base y emisor subirían a la vez, el transistor no notaría nada y el lazo quedaría abierto. *Con $C_2$ enorme* la toma quedaría casi a masa y el transistor apenas podría entregar energía por ese punto: la ganancia de lazo bajaría de 1. Funciona con un reparto equilibrado; lo habitual es $C_1$ y $C_2$ iguales o del mismo orden.
]

#ejemplo(titulo: [la frecuencia de un Colpitts])[Con $L = 2,5 thin mu"H"$ y $C_1 = C_2 = 200 "pF"$, la capacidad serie es $200 dot 200 slash 400 = 100 "pF"$, y
$ f_0 = 1 / (2 pi sqrt(2\,5 dot 10^(-6) dot 100 dot 10^(-12))) = 1 / (2 pi dot 1,58 dot 10^(-8) "s") approx 10 "MHz". $
La toma está a $C_1 slash (C_1 + C_2) = 1 slash 2$ de la tensión del tanque. Para bajar a 7 MHz sin tocar la bobina hay que multiplicar la capacidad por $(10 slash 7)^2 approx 2$: unos 200 pF en serie, es decir, $C_1 = C_2 approx 400 "pF"$. Si además pones un condensador variable en paralelo con $L$, mueves $f_0$ a voluntad: ya tienes un VFO.]

=== El Hartley: el tanque con bobina con toma

La segunda manera de sacar la muestra parte en dos la _bobina_ en lugar del condensador. La bobina tiene una toma intermedia (una conexión a unas espiras del extremo), y esa toma va al emisor. La @i2c-fig-hartley lo dibuja con la misma disposición que el Colpitts, para que veas que lo único que cambia es la toma.

#circuito(sim: "hartley.txt", caption: [Oscilador Hartley, esquemático (polarización omitida, como en la @i2c-fig-colpitts). El tanque es la bobina completa $L_a + L_b$ con el condensador $C$; la toma de la bobina devuelve al emisor la fracción de la oscilación que cae en $L_b$. Un mismo transistor, una misma idea: solo cambia el componente que se parte en dos.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line, bezier
    npn("q1", (4, 3.4))
    wire("q1.c", (4, 4.6))
    inductor("ch", (4, 4.6), (4, 6.2), label: [choque])
    content((4, 6.2), anchor: "south", padding: 3pt, _i2c-t[+12 V])
    wire((4, 4.6), (5.2, 4.6))
    capacitor("cs", (5.2, 4.6), (6.6, 4.6), label: $C_"sal"$, n: "-o")
    content((6.75, 4.6), anchor: "west", _i2c-t[RF a $f_0$])
    // tanque
    wire((-1.4, 4.4), (2.6, 4.4))
    wire((2.6, 4.4), (2.6, 3.4))
    wire((2.6, 3.4), "q1.b")
    capacitor("c", (-1.4, 4.4), (-1.4, 0.6), label: (content: $C$, anchor: "south"))
    ground("gc", (-1.4, 0.6))
    inductor("la", (0, 4.4), (0, 2.2), label: (content: $L_a$, anchor: "south"))
    inductor("lb", (0, 2.2), (0, 0.6), label: (content: $L_b$, anchor: "south"))
    ground("gl", (0, 0.6))
    wire((0, 2.2), (4, 2.2))
    wire("q1.e", (4, 2.2))
    zap.node("n1", (0, 4.4))
    zap.node("n2", (0, 2.2))
    content((0.55, 2.45), _i2c-t[toma])
    bezier((0.5, 1.85), (3.7, 2.0), (2.1, 1.2), stroke: 0.9pt + col.acento, mark: (end: ">", fill: col.acento))
    content((2.4, 0.85), align(center, _i2c-t(fill: col.acento)[realimentación por \ la toma de la bobina]))
  })
] <i2c-fig-hartley>

#porque(titulo: [el Hartley de la @i2c-fig-hartley])[
  - *El tanque* es la bobina entera ($L_a + L_b$, más su inductancia mutua) con $C$. Girar $C$ sintoniza.
  - *La toma inductiva.* La bobina con toma es un autotransformador: en las espiras de abajo ($L_b$) aparece una fracción de la tensión de todo el tanque, en fase con ella, proporcional a su número de espiras. Esa fracción va al emisor.
  - *El transistor* se comporta igual que en el Colpitts: base arriba, emisor en la toma, corriente empujada hacia el tanque en el momento justo.
  - *La toma demasiado arriba* devuelve mucha señal: arranca con facilidad pero recorta mucho y da una onda sucia. *Demasiado abajo*: no arranca. Lo típico es una toma a una cuarta parte, más o menos, de las espiras desde masa.
  - *En el circuito real* la toma, unida a masa por $L_b$ para la continua, cortocircuitaría el emisor: se intercala un condensador de paso entre la toma y el emisor. Por eso el Hartley se monta con más gusto con un FET, que se polariza sin necesitar continua en ese punto.
]

#ojo(titulo: [Colpitts o Hartley])[*Colpitts = divisor capacitivo* (dos condensadores en serie con toma en el centro). *Hartley = bobina con toma*. Es la pregunta típica de reconocimiento: busca qué componente del tanque está partido en dos. Una variante del Colpitts, el *Clapp*, añade un condensador pequeño en serie con la bobina: las capacidades del transistor, que cambian con la temperatura, pesan menos y la frecuencia deriva menos.]

=== El circuito de verdad: un Colpitts completo

Los esquemas anteriores omiten la polarización para que se vea el lazo. La @i2c-fig-colpitts-real es el Colpitts que montarías de verdad, con todos sus componentes. Es una de las versiones más usadas en los VFO de aficionado: el transistor trabaja en *colector común* (seguidor de emisor, #ver(<sec-configuraciones>)) y $C_1$ va de base a emisor, que es lo mismo que «de lo alto del tanque a la toma», porque la base está unida al tanque.

#circuito(caption: [Oscilador Colpitts completo, en colector común. $R_1$–$R_2$–$R_E$ fijan el punto de trabajo; $C_B$ une el tanque a la base sin tocar su continua; $C_D$ pone el colector a masa para la RF. Valores para 10 MHz: $L = 2,5 thin mu"H"$, $C_1 = C_2 = 200 "pF"$, $C_B = 1 "nF"$, $R_1 = 33 "kΩ"$, $R_2 = 22 "kΩ"$, $R_E = 2,2 "kΩ"$, $C_D = 100 "nF"$, $C_"sal" = 10 "pF"$.], sim: "colpitts.txt")[
  #_i2c-colpitts()
] <i2c-fig-colpitts-real>

#porque(titulo: [componente a componente])[
  - *$R_1$ y $R_2$* fijan la base en $12 dot 22 slash (33 + 22) = 4,8 "V"$, como el divisor de #ver(<sec-polarizacion>). El emisor queda a $4,8 - 0,6 = 4,2 "V"$, y sobre $R_E = 2,2 "kΩ"$ circulan unos 1,9 mA.
  - *$C_B$* (1 nF, unos 16 Ω a 10 MHz) es transparente para la RF pero bloquea la continua: sin él, la bobina pondría la base a 0 V de continua y el transistor no conduciría.
  - *$L$, $C_1$ y $C_2$* forman el tanque. Para la RF, la base está en lo alto del tanque y el emisor en la toma, igual que en la @i2c-fig-colpitts.
  - *El transistor* en colector común copia en el emisor la tensión de la base (ganancia de tensión casi 1, sin inversión), pero con mucha más corriente: es el músculo. El divisor $C_1$–$C_2$ eleva esa copia al doble en lo alto del tanque. Ganancia de lazo: casi $1 times 2 approx 2$, menos las pérdidas del tanque. Fase: 0°, porque nadie invierte. Las dos condiciones de Barkhausen se cumplen.
  - *$C_D$* (100 nF) une el colector a masa para la RF: el colector es el terminal común.
  - *$C_"sal"$* es pequeño (10 pF) a propósito. Saca la señal sin cargar el tanque: un tanque muy cargado pierde $Q$ y la frecuencia se vuelve sensible a lo que se conecte detrás. Un oscilador estable debe estar *débilmente cargado* (pregunta C-T3.3; el banco público da como clave «fuertemente cargado», justo lo contrario de lo que pasa en la práctica), y por eso le sigue siempre una *etapa separadora* (buffer, pregunta T5.25).
]

#ojo(titulo: [la versión en emisor común])[Muchos libros dibujan el Colpitts con el transistor en emisor común: $C_1$ del colector a masa, $L$ del colector a la base y $C_2$ de la base a masa. Entonces el transistor invierte (180°) y la red $C_1$–$L$–$C_2$, que es una red en pi (#ver(<sec-redes-adaptacion>)), invierte otra vez (otros 180°): 360° en total. Es la misma condición de Barkhausen contada de otra manera. Si el examen pregunta qué desfase aporta la red de realimentación de un oscilador con amplificador inversor, la respuesta es 180°.]

=== El cristal de cuarzo: el tanque perfecto <sec-cristal>

#motivacion[Un VFO de bobina y condensador se mueve. Al calentarse, el hilo de la bobina se dilata y los condensadores cambian de valor; en un montaje sencillo eso son decenas de partes por millón (ppm) por grado. A 7 MHz, 20 ppm/°C durante una subida de 10 °C son $7 dot 10^6 dot 20 dot 10^(-6) dot 10 = 1400 "Hz"$: tu emisión de SSB se desplaza más de un kilohercio mientras hablas, y tu corresponsal tiene que perseguirte con el dial. Para la telegrafía, la SSB o los modos digitales, que exigen precisiones de unos pocos hercios, hace falta otra cosa.]

Un tanque LC de bobina y condensador tiene un problema: su $f_0$ se mueve — con la temperatura, con las vibraciones, con los años —, y un $Q$ de unas pocas centenas como mucho. El *cristal de cuarzo* lo resuelve por un camino inesperado: la _piezoelectricidad_. Una lámina de cuarzo se deforma al aplicarle tensión y genera tensión al deformarse; tiene además una frecuencia de vibración _mecánica_ propia, fijada por su tamaño con precisión de relojería. Eléctricamente se comporta exactamente como un circuito resonante (@i2c-fig-cristal-eq) — la inercia mecánica hace de bobina, la elasticidad de condensador — pero con valores inalcanzables para componentes de verdad (henrios de inductancia equivalente, femtofaradios de capacidad) y un $Q$ de decenas o centenas de miles: una campana milimétricamente estrecha y estable. Sustituye el tanque LC del oscilador por un cristal y la frecuencia queda _anclada_: son los osciladores «a cristal» de los transmisores, y la razón de que tu transceptor caiga en la frecuencia exacta ciclo tras ciclo. (Los filtros de FI de gran $Q$ del capítulo anterior son también cristales, en equipo.)

#circuito(caption: [El efecto piezoeléctrico, en los dos sentidos. Izquierda: una tensión entre los electrodos deforma la lámina (en trazo discontinuo, exagerado: en realidad son nanómetros). Derecha: si la lámina se deforma, aparece una tensión entre los electrodos. Una lámina que vibra es, por tanto, una tensión alterna; y una tensión alterna a la frecuencia justa la hace vibrar.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line, rect
    // --- izquierda: tensión → deformación
    rect((0, 0), (2.6, 0.7), fill: col.acento-claro, stroke: 0.6pt)
    line((0, 0), (2.6, 0), (2.95, 0.7), (0.35, 0.7), close: true, stroke: (paint: col.senal2, dash: "dashed", thickness: 0.8pt))
    line((0, 0.7), (2.6, 0.7), stroke: 2pt)
    line((0, 0), (2.6, 0), stroke: 2pt)
    wire((1.3, 0.7), (1.3, 1.5), (-0.6, 1.5), (-0.6, 0.85))
    wire((1.3, 0), (1.3, -0.7), (-0.6, -0.7), (-0.6, -0.15))
    bateria("b1", (-0.6, 0.85), (-0.6, -0.15))
    content((1.3, -1.15), _i2c-t[aplicas tensión → se deforma])
    // --- derecha: deformación → tensión
    rect((5.4, 0), (8.0, 0.7), fill: col.acento-claro, stroke: 0.6pt)
    line((5.4, 0.7), (8.0, 0.7), stroke: 2pt)
    line((5.4, 0), (8.0, 0), stroke: 2pt)
    line((4.9, 0.35), (5.35, 0.35), stroke: 1pt + col.senal2, mark: (end: ">", fill: col.senal2))
    line((8.5, 0.35), (8.05, 0.35), stroke: 1pt + col.senal2, mark: (end: ">", fill: col.senal2))
    wire((6.7, 0.7), (6.7, 1.5), (9.1, 1.5), (9.1, 0.85))
    wire((6.7, 0), (6.7, -0.7), (9.1, -0.7), (9.1, -0.15))
    medidor("m1", (9.1, 0.85), (9.1, -0.15), letra: "V")
    content((6.9, -1.15), _i2c-t[la deformas → aparece tensión])
  })
] <i2c-fig-piezo>

#circuito(caption: [El cristal y su circuito equivalente: una rama resonante serie ($L_m$, $C_m$, $r$) que modela la vibración mecánica, en paralelo con la capacidad $C_0$ de sus electrodos. Los valores equivalentes son extraordinarios — henrios y femtofaradios — y el $Q$ resultante, de decenas de miles: por eso el cristal fija la frecuencia como ningún LC puede.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    cristal("x", (0, 0.6), (2.2, 0.6), n: "o-o")
    content((1.1, 1.35), _i2c-t[cristal de cuarzo])
    content((3.2, 0.6), text(size: 14pt)[$equiv$])
    // equivalente
    wire((4.0, 0.6), (4.6, 0.6))
    wire((4.6, 0), (4.6, 1.4))
    wire((9.4, 0), (9.4, 1.4))
    wire((9.4, 0.6), (10.0, 0.6))
    zap.node("a", (4.0, 0.6), fill: false)
    zap.node("b", (10.0, 0.6), fill: false)
    zap.node("a2", (4.6, 0.6))
    zap.node("b2", (9.4, 0.6))
    capacitor("c0", (4.6, 1.4), (9.4, 1.4), label: $C_0$)
    resistor("r", (4.6, 0), (6.2, 0), label: (content: $r$, anchor: "south"))
    inductor("lm", (6.2, 0), (7.8, 0), label: (content: $L_m$, anchor: "south"))
    capacitor("cm", (7.8, 0), (9.4, 0), label: (content: $C_m$, anchor: "south"))
  })
] <i2c-fig-cristal-eq>

#analogia(titulo: [una campana de cuarzo])[El cristal es una campana diminuta. La masa de la lámina es su inercia (la bobina $L_m$: se resiste a cambiar de velocidad); su rigidez es el muelle (el condensador $C_m$: almacena la energía de la deformación); el rozamiento interno, minúsculo, es $r$. Una campana de buen bronce suena mucho tiempo tras un solo golpe: pierde muy poca energía por ciclo, es decir, tiene un $Q$ altísimo. El cuarzo es un bronce mucho mejor, y además apenas cambia de tamaño con la temperatura.]

#ejemplo(titulo: [los números de un cristal de 10 MHz])[Un cristal típico de 10 MHz (corte AT, modo fundamental) tiene, aproximadamente, $C_m = 20 "fF"$ ($20 dot 10^(-15)$ F), $r = 10 Ω$ y $C_0 = 5 "pF"$. La inductancia equivalente sale de la fórmula de Thomson:
$ L_m = 1 / ((2 pi f)^2 C_m) = 1 / ((6,28 dot 10^7)^2 dot 20 dot 10^(-15)) approx 12,7 "mH". $
Compara: la bobina del Colpitts de la @i2c-fig-colpitts tenía 2,5 μH, cinco mil veces menos. A cristales de frecuencia más baja les corresponden inductancias equivalentes de henrios. El factor de calidad es
$ Q = (2 pi f L_m) / r = (6,28 dot 10^7 dot 0,0127) / 10 approx 80 thin 000, $
y el ancho de banda de la campana, $B = f slash Q = 10^7 slash 80 thin 000 approx 125 "Hz"$. Un tanque LC con $Q = 200$ en la misma frecuencia tendría una campana de 50 kHz, cuatrocientas veces más ancha.]

#ptitulo[Dos resonancias muy juntas] El circuito equivalente tiene dos caminos, y por eso dos resonancias (@i2c-fig-cristal-x):

- *Resonancia serie*, $f_s = 1 slash (2 pi sqrt(L_m C_m))$. La rama $L_m$–$C_m$ resuena: sus reactancias se anulan y el cristal es, de borne a borne, solo la pequeña $r$. *Impedancia mínima.*
- *Resonancia paralelo*, $f_p$, un poco por encima. Por encima de $f_s$ la rama serie se vuelve inductiva, y a $f_p$ esa «bobina» resuena en paralelo con $C_0$, como un tanque. *Impedancia máxima.* La separación es diminuta: $f_p approx f_s (1 + C_m slash (2 C_0))$. Con los números del ejemplo, $C_m slash 2 C_0 = 0,002$: $f_p - f_s approx 20 "kHz"$ sobre 10 MHz.

Entre $f_s$ y $f_p$, y _solo_ allí, el cristal se comporta como una bobina. Fuera de esa franja es un condensador.

#circuito(caption: [Reactancia de un cristal frente a la frecuencia (separación entre $f_s$ y $f_p$ muy exagerada). Por debajo de $f_s$ y por encima de $f_p$ es capacitivo. En $f_s$ su impedancia es mínima (resonancia serie); en $f_p$, máxima (resonancia paralelo). En la estrecha franja entre ambas es inductivo: ahí trabaja como la bobina de un Colpitts.])[
  #cetz.canvas({
    import cetz.draw: *
    // X(w) = -(w^2 - ws^2) / (w C0 (w^2 - wp^2)), ws = 1, wp^2 = 1.6, C0 = 1
    let X(w) = -(w * w - 1) / (w * (w * w - 1.6))
    let sx = 4.0
    let x0 = 0.55
    let pts1 = range(0, 301).map(i => {
      let w = x0 + (1.2649 - x0) * i / 300
      ((w - x0) * sx + 0.3, X(w))
    }).filter(p => calc.abs(p.at(1)) <= 2.2)
    let pts2 = range(0, 301).map(i => {
      let w = 1.2649 + (1.9 - 1.2649) * i / 300
      ((w - x0) * sx + 0.3, X(w))
    }).filter(p => calc.abs(p.at(1)) <= 2.2)
    ejes(0, 6.2, -2.3, 2.5, etq-x: $f$, etq-y: $X$)
    line(..pts1, stroke: 1.2pt + col.senal1)
    line(..pts2, stroke: 1.2pt + col.senal1)
    let xs = (1 - x0) * sx + 0.3
    let xp = (1.2649 - x0) * sx + 0.3
    line((xp, -2.3), (xp, 2.3), stroke: (paint: col.gris, dash: "dotted", thickness: 0.5pt))
    content((xs, -0.12), anchor: "north-east", _i2c-t[$f_s$])
    content((xp + 0.05, -0.12), anchor: "north-west", _i2c-t[$f_p$])
    circle((xs, 0), radius: 0.06, fill: col.senal2, stroke: none)
    content((1.4, -1.6), _i2c-t[capacitivo])
    content((xs + 0.55, 2.05), anchor: "east", _i2c-t[inductivo])
    content((5.4, -1.6), _i2c-t[capacitivo])
    content((3.7, 1.9), anchor: "west", text(size: 7pt, fill: col.gris)[$X > 0$: como una bobina])
    content((3.7, 1.5), anchor: "west", text(size: 7pt, fill: col.gris)[$X < 0$: como un condensador])
  })
] <i2c-fig-cristal-x>

#ptitulo[Por qué es tan estable] Tres razones se suman. Primera, el _tamaño_: la frecuencia la fija la geometría de una lámina de cuarzo, un material duro que apenas se dilata. Con el corte AT, el más usado, la frecuencia varía solo unas pocas ppm en todo el margen de temperaturas de un equipo; a 7 MHz, alrededor de la temperatura ambiente, una subida de 10 °C mueve un cristal unas decenas de hercios como mucho, frente al kilohercio largo del VFO del ejemplo de arriba. Segunda, el _Q_: como la fase de un cristal gira bruscamente en cuanto la frecuencia se separa un poco de su resonancia, cualquier desfase que añada el resto del circuito (un transistor que se calienta, una tensión que varía) se corrige con un cambio de frecuencia minúsculo. Tercera, la _pureza_: una campana tan estrecha deja pasar muy poco ruido, y la señal sale limpia, con poco ruido de fase.

#circuito(sim: "crystalosc2.txt", caption: [Oscilador Colpitts a cristal: el circuito de la @i2c-fig-colpitts-real con el cristal X en lugar de la bobina (sobra $C_B$: el cristal ya bloquea la continua). Oscila en la frecuencia, entre $f_s$ y $f_p$, en que el cristal es la bobina que resuena con $C_1$ y $C_2$ en serie.])[
  #_i2c-colpitts(xtal: true)
] <i2c-fig-osc-cristal>

#porque[
  - *El cristal hace de bobina.* Solo es inductivo entre $f_s$ y $f_p$ (@i2c-fig-cristal-x). A cualquier otra frecuencia es un condensador, el «tanque» queda hecho solo de condensadores y no puede resonar: el oscilador _solo puede_ oscilar en esa franja de unos kilohercios.
  - *Dentro de la franja* la reactancia del cristal sube vertiginosamente con la frecuencia. Se oscila donde esa reactancia inductiva cancela la de $C_1$ y $C_2$ en serie: es la *capacidad de carga* del cristal. Si esa capacidad cambia 1 pF, con los valores de la figura la frecuencia se mueve unos 10 Hz; el mismo picofaradio en el tanque LC de la @i2c-fig-colpitts (100 pF a 10 MHz) la movería 50 kHz. El cristal es miles de veces menos sensible al resto del circuito.
  - *El resto del circuito* es el Colpitts de siempre: el transistor en colector común repone la energía, $C_1$–$C_2$ dan la toma, $R_1$–$R_2$–$R_E$ polarizan.
  - *Un trimmer en serie con el cristal* permite «tirar» de la frecuencia unos cientos de hercios o pocos kilohercios: es el VXO, el oscilador de cristal ligeramente variable de muchos transmisores sencillos de QRP.
]

#ptitulo[Sobretonos] Para frecuencias por encima de unos 20–30 MHz, la lámina para el modo fundamental tendría que ser tan fina que se rompería. Se usa entonces un cristal de *sobretono*: la misma lámina vibra en su tercer o quinto modo mecánico, cerca de 3 o 5 veces la frecuencia fundamental (solo los sobretonos _impares_). El oscilador lleva entonces un circuito LC sintonizado al sobretono para que el cristal no arranque en su fundamental.

#ojo(titulo: [lo que el examen pregunta del cristal])[
  - El resonador de cuarzo funciona por *piezoelectricidad* (T3.8, T3.46). No almacena carga, no amplifica, no rectifica.
  - Un oscilador a cristal da una señal de *frecuencia muy estable* (T3.45), pero *no fácilmente ajustable*: para cambiar de frecuencia hay que cambiar de cristal (o usar un VXO, que se mueve muy poco).
  - La temperatura es la gran enemiga de la estabilidad de cualquier oscilador (C-T3.16); el cristal es la respuesta.
  - Los filtros de FI de SSB son de cuarzo por su $Q$ altísimo: banda estrecha y estable (F-T3.49).
]

=== VFO, cristal, PLL y DDS: quién decide la frecuencia

Un transmisor moderno necesita las dos virtudes a la vez: la *estabilidad* del cristal y la *sintonía* del VFO. Cuatro soluciones se han ido sucediendo.

#ptitulo[El VFO] Un oscilador LC (Colpitts, Hartley, Clapp) con un condensador variable o un varicap en el tanque: sintonía continua y barata, y una señal de bajo ruido. Su punto débil es la deriva térmica: exige componentes de buena calidad, montaje rígido y una etapa separadora. Fue el corazón de los equipos de aficionado hasta los años ochenta.

#ptitulo[El oscilador a cristal] Estabilidad excelente, pero una sola frecuencia por cristal. Sirve para todo lo que no se mueve: la portadora de un modulador de SSB, el BFO, el oscilador de referencia de un sintetizador, el reloj de un DDS.

#ptitulo[El PLL] El *lazo de enganche de fase* (@i2c-fig-pll) consigue un VFO con la estabilidad de un cristal. Un VCO (un oscilador LC cuya frecuencia se gobierna con la tensión de un varicap) genera la salida. Un divisor programable divide esa frecuencia por $N$. Un comparador de fase compara el resultado con una referencia de cristal y produce una tensión de error, que un filtro paso bajo alisa y aplica al varicap del VCO. Si el VCO se adelanta, la tensión lo frena; si se retrasa, lo acelera. Enganchado, las dos entradas del comparador tienen exactamente la misma frecuencia, así que $f_"sal" = N dot f_"ref"$: la salida hereda la estabilidad del cristal, y cambiar $N$ es cambiar de canal. Su precio: la frecuencia avanza a saltos de $f_"ref"$ y el lazo añade algo de ruido de fase.

#circuito(sim: "pll.txt", caption: [Sintetizador PLL. El comparador de fase compara la salida del VCO, dividida por $N$, con una referencia de cristal; la tensión de error, filtrada, corrige el VCO hasta que las dos frecuencias coinciden. Entonces $f_"sal" = N dot f_"ref"$.])[
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (8mm, 9mm),
    node((0, 0), align(center)[Referencia \ (cristal) \ $f_"ref"$], shape: rect, name: <i2c-ref>),
    node((1, 0), align(center)[Comparador \ de fase], shape: rect, name: <i2c-cf>),
    node((2, 0), align(center)[Filtro \ paso bajo], shape: rect, name: <i2c-fpb>),
    node((3, 0), align(center)[VCO \ (varicap)], shape: rect, name: <i2c-vco>),
    node((4.1, 0), [$f_"sal" = N dot f_"ref"$], stroke: none, name: <i2c-sal>),
    node((2, 1), align(center)[Divisor programable $div N$], shape: rect, name: <i2c-div>),
    edge(<i2c-ref>, <i2c-cf>, "-|>"),
    edge(<i2c-cf>, <i2c-fpb>, "-|>", label: text(size: 7pt)[error], label-side: left),
    edge(<i2c-fpb>, <i2c-vco>, "-|>", label: text(size: 7pt)[control], label-side: left),
    edge(<i2c-vco>, <i2c-sal>, "-|>"),
    edge(<i2c-vco>, (3, 1), <i2c-div>, "-|>"),
    edge(<i2c-div>, (1, 1), <i2c-cf>, "-|>", label: text(size: 7pt)[$f_"sal" slash N$], label-side: left, label-pos: 0.3),
  )
] <i2c-fig-pll>

#ejemplo(titulo: [un PLL de 2 metros])[Con una referencia de 25 kHz y $N = 5800$, el VCO se engancha en $5800 dot 25 "kHz" = 145,000 "MHz"$. Con $N = 5801$, en 145,025 MHz: cada unidad del divisor es un canal de 25 kHz. Para pasos de 12,5 kHz basta con una referencia de 12,5 kHz (y $N$ doble).]

#ptitulo[El DDS] El *sintetizador digital directo* fabrica la onda con números. Un acumulador de fase suma, en cada impulso de un reloj de cristal, una palabra de sintonía $M$; el resultado señala en una tabla el valor del seno que toca; un conversor digital-analógico lo convierte en tensión y un filtro paso bajo alisa los escalones. La frecuencia de salida es $f = M dot f_"reloj" slash 2^n$, con $n$ los bits del acumulador. Con un reloj de 125 MHz y 32 bits, cada paso de $M$ mueve la salida $125 dot 10^6 slash 2^32 approx 0,03 "Hz"$: sintonía prácticamente continua, cambios de frecuencia instantáneos y estabilidad de cristal. Su punto débil son las señales espurias que dejan los escalones digitales. Muchos equipos combinan DDS y PLL.

#ojo(titulo: [sintetizadores en el examen])[Los bloques del PLL son *comparador de fase, filtro paso bajo y VCO* (más el divisor y la referencia), pregunta F-T3.24. La cuenta es siempre $f_"sal" = N dot f_"ref"$ (F-T3.27, F-T3.28). El DDS es un *oscilador variable de gran precisión* (T3.10) cuya salida se cambia con la palabra de sintonía, con el reloj fijo (F-T3.31 a F-T3.33).]

// =====================================================================
== El mezclador: cambiar de frecuencia <sec-mezclador>

#motivacion[Quieres escuchar la banda de 20 metros en SSB. Las emisoras están a 3 kHz unas de otras, y para quedarte con una necesitas un filtro de unos 2,7 kHz de ancho con flancos muy empinados. A 14,2 MHz eso pide un $Q = f slash B = 14,2 "MHz" slash 2,7 "kHz" approx 5300$: imposible con bobinas y condensadores, que se quedan en unos cientos. Y aunque lo consiguieras, tendría que moverse con el dial sin cambiar de forma, junto con todas las demás etapas sintonizadas del receptor. Los primeros receptores lo intentaban con condensadores variables de varias secciones en el mismo eje, y era una pesadilla de ajuste. La salida es darle la vuelta al problema: *dejar el filtro quieto y llevar la emisora hasta él*. Un buen filtro de cuarzo a una frecuencia fija (9 MHz, por ejemplo) es estrecho, estable y barato. Lo que hace falta es una pieza que traslade cualquier emisora a esa frecuencia: el *mezclador*.]

=== Multiplicar para trasladar

#ptitulo[Sumar no basta] Un circuito lineal — resistencias, condensadores, bobinas, un amplificador que no recorta — nunca crea frecuencias nuevas. Si le entran 14,2 MHz y 23,2 MHz, por su salida salen 14,2 MHz y 23,2 MHz, más grandes o más pequeños, y nada más. Para fabricar una frecuencia que no estaba hace falta *multiplicar* las dos señales. Y el producto de dos sinusoides es, por la misma identidad trigonométrica de la AM (#ver(<sec-am>)), la suma de otras dos:

#destacada($cos(2 pi f_1 t) dot cos(2 pi f_2 t) = 1/2 cos[2 pi (f_1 - f_2) t] + 1/2 cos[2 pi (f_1 + f_2) t]$, nota: [un multiplicador convierte dos frecuencias en su diferencia y su suma])

#ejemplo(titulo: [de 14,2 MHz a la FI de 9 MHz])[La emisora está en $f_s = 14,2 "MHz"$ y el receptor tiene su FI en 9 MHz. Se pone el oscilador local en $f_"OL" = 14,2 + 9 = 23,2 "MHz"$. El mezclador entrega $23,2 - 14,2 = 9,0 "MHz"$ y $23,2 + 14,2 = 37,4 "MHz"$ (@i2c-fig-mezcla). El filtro de FI, de 9 MHz, se queda con la diferencia y tira la suma. Para escuchar 14,3 MHz basta con subir el oscilador local a 23,3 MHz: la nueva emisora cae otra vez en 9 MHz, y el filtro no se ha movido. *Sintonizar es mover el oscilador local.*]

// FALSTAD-CUSTOM: mezclador
#circuito(caption: [Lo que hace un mezclador, visto en el espectro. Arriba, lo que entra: la emisora (14,2 MHz) y el oscilador local (23,2 MHz). Abajo, lo que sale: la diferencia (9 MHz, la FI) y la suma (37,4 MHz). En gris, restos de las dos entradas que un mezclador sencillo deja pasar y uno equilibrado suprime. El filtro de FI elige la raya de 9 MHz.])[
  #cetz.canvas({
    import cetz.draw: *
    let sx = 0.27
    let raya(f, h, y0, c, etq) = {
      line((f * sx, y0), (f * sx, y0 + h), stroke: 2pt + c)
      content((f * sx, y0 + h + 0.05), anchor: "south", text(size: 7.5pt, fill: c, etq))
    }
    // entrada
    line((0, 2.6), (42 * sx, 2.6), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((42 * sx + 0.1, 2.6), anchor: "west", _i2c-t[$f$ (MHz)])
    content((-0.1, 3.3), anchor: "east", _i2c-t[entrada])
    raya(14.2, 0.9, 2.6, col.senal1, [señal 14,2])
    raya(23.2, 1.2, 2.6, col.senal4, [OL 23,2])
    // salida
    line((0, 0), (42 * sx, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((42 * sx + 0.1, 0), anchor: "west", _i2c-t[$f$ (MHz)])
    content((-0.1, 0.7), anchor: "east", _i2c-t[salida])
    raya(9.0, 1.55, 0, col.senal2, [FI: 23,2 − 14,2 = 9,0])
    raya(37.4, 0.9, 0, col.senal3, [23,2 + 14,2 = 37,4])
    raya(14.2, 0.3, 0, col.gris, [])
    raya(23.2, 0.4, 0, col.gris, [])
    // filtro de FI
    let campana(x) = 1.2 / (1 + calc.pow((x - 9.0) / 1.0, 2) * 6)
    line(..range(0, 81).map(i => {
      let f = 6 + 6 * i / 80
      (f * sx, campana(f))
    }), stroke: (paint: col.senal2, thickness: 0.6pt, dash: "dashed"))
    content((6.6 * sx, 0.55), anchor: "east", text(size: 7pt, fill: col.senal2)[filtro de FI])
    for f in (0, 10, 20, 30, 40) {
      line((f * sx, -0.06), (f * sx, 0.06), stroke: 0.5pt)
      content((f * sx, -0.1), anchor: "north", text(size: 7pt)[#f])
    }
  })
] <i2c-fig-mezcla>

#ptitulo[La modulación viaja entera] La identidad vale para cada una de las frecuencias que forman la señal. Si la emisora de 14,2 MHz lleva la voz en una banda lateral de 14,2003 a 14,2027 MHz, cada una de sus componentes se traslada igual, y en la FI aparece la misma voz, ocupando los mismos 2,4 kHz, alrededor de 9 MHz. El mezclador no toca la información: la cambia de sitio. Un matiz: cuando la salida es $f_"OL" - f_s$ (oscilador por encima de la señal), lo que estaba arriba queda abajo, y la banda lateral superior sale como inferior. El receptor lo tiene en cuenta al colocar el BFO (#ver(<sec-detector>)).

#ptitulo[Cómo se multiplica con componentes reales] No existe una pieza que multiplique tal cual, pero sí piezas *no lineales*: las que no responden en proporción a lo que reciben. La corriente de un diodo (o de la unión base-emisor de un transistor) cerca del codo crece aproximadamente con el cuadrado de la tensión: $i approx a v + b v^2$. Si le aplicas la suma de las dos señales, $v = v_1 + v_2$, el término cuadrático es
$ b (v_1 + v_2)^2 = b v_1^2 + 2 b thin v_1 v_2 + b v_2^2. $
Ahí está el producto, $2 b thin v_1 v_2$: suma y diferencia. El resto son restos indeseados — las propias entradas, sus armónicos ($2 f_1$, $2 f_2$) y una componente continua — que un filtro a la salida tiene que eliminar. Por eso el temario resume el superheterodino como «un oscilador y una etapa no lineal».

#idea[Mezclar es multiplicar. Una etapa no lineal que recibe dos frecuencias entrega su suma y su diferencia (y restos). Con un oscilador local que se mueve y un filtro de FI que no se mueve, cualquier emisora acaba en la FI.]

=== Mezcladores reales

#ptitulo[Un diodo o un transistor] El mezclador más simple es un solo diodo, o un transistor polarizado cerca del codo, al que llegan las dos señales a la vez: la señal en la base, el oscilador local en la base o en el emisor, y un tanque sintonizado a la FI en el colector, que deja en la salida solo la diferencia. El transistor aporta además ganancia. Su defecto: a la salida llegan también la señal, el oscilador local y muchos productos más, y todo eso tiene que quitarlo el filtro. (El detector de envolvente de un receptor de galena, por cierto, es un mezclador de un diodo: multiplica la portadora por sus propias bandas laterales, y la diferencia que sale es la voz.)

#ptitulo[El mezclador doblemente equilibrado de diodos] La solución de los equipos serios es el *anillo de diodos* de la @i2c-fig-anillo: cuatro diodos y dos transformadores con toma central. Es *equilibrado* porque, por simetría, la señal del oscilador local se anula en las puertas de RF y de FI; *doblemente equilibrado* porque la señal de RF también se anula en la puerta de FI. A la salida quedan, casi solas, la suma y la diferencia.

#circuito(sim: "ringmod.txt", caption: [Mezclador doblemente equilibrado en anillo de diodos. El oscilador local (OL) entra por $T_1$; la señal de RF, por $T_2$; la FI sale por la toma central del devanado de $T_2$ que da al anillo. Las dos diagonales se cruzan sin conectarse. El pequeño salto en el cable de abajo indica que el de la FI pasa por encima sin conexión.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line, arc
    // T1 (oscilador local) y T2 (RF)
    trafo("t1", (0, 0), nucleo: false, espiras: (6, 6))
    trafo("t2", (7.4, 0), nucleo: false, espiras: (6, 6))
    // puertas
    wire("t1.p1", (-1.8, 1.2))
    zap.node("pol", (-1.8, 1.2), fill: false)
    content((-1.95, 1.2), anchor: "east", _i2c-t[OL])
    wire("t1.p2", (-1.4, -1.2))
    ground("g1", (-1.4, -1.2))
    wire("t2.s1", (9.2, 1.2))
    zap.node("prf", (9.2, 1.2), fill: false)
    content((9.35, 1.2), anchor: "west", _i2c-t[RF])
    wire("t2.s2", (8.8, -1.2))
    ground("g2", (8.8, -1.2))
    // anillo: A=(2.6,1.2) B=(4.8,1.2) C=(2.6,-1.2) D=(4.8,-1.2)
    wire("t1.s1", (2.6, 1.2))
    wire("t1.s2", (2.6, -1.2))
    wire("t2.p1", (4.8, 1.2))
    // cable de T2.p2 a D con salto sobre la FI
    line((6.4, -1.2), (5.75, -1.2), stroke: 0.6pt)
    arc((5.75, -1.2), start: 0deg, stop: 180deg, radius: 0.15, stroke: 0.6pt)
    line((5.45, -1.2), (4.8, -1.2), stroke: 0.6pt)
    diode("d1", (2.6, 1.2), (4.8, 1.2))
    diode("d3", (2.6, -1.2), (4.8, -1.2))
    diode("d2", (4.8, 1.2), (2.6, -1.2), position: 28%)
    diode("d4", (4.8, -1.2), (2.6, 1.2), position: 28%)
    for (nm, pt) in (("na", (2.6, 1.2)), ("nb", (4.8, 1.2)), ("nc", (2.6, -1.2)), ("nd", (4.8, -1.2))) {
      zap.node(nm, pt)
    }
    // toma central de T1 a masa
    wire((0.42, 0), (1.5, 0))
    ground("gct", (1.5, 0))
    // toma central de T2 → FI
    wire((6.98, 0), (5.6, 0), (5.6, -2.3))
    zap.node("pfi", (5.6, -2.3), fill: false)
    content((5.6, -2.45), anchor: "north", _i2c-t[FI])
    content((0, 1.75), _i2c-t[$T_1$])
    content((7.4, 1.75), _i2c-t[$T_2$])
  })
] <i2c-fig-anillo>

#porque(titulo: [el anillo como conmutador])[
  - *El oscilador local manda.* Se inyecta fuerte (unos 5 mW, +7 dBm, en los mezcladores comerciales). En su semiciclo positivo conducen los dos diodos de un lado del anillo, y unen uno de los extremos del devanado de $T_2$ con la toma central de $T_1$, que está a masa. En el semiciclo negativo conducen los otros dos y unen a masa el _otro_ extremo.
  - *La señal de RF se invierte a ritmo de OL.* La toma central de $T_2$ ve la mitad de la tensión de RF con un signo en un semiciclo del oscilador y con el signo contrario en el siguiente. Es como multiplicar la RF por una onda cuadrada de $plus.minus 1$ a la frecuencia del oscilador local: un multiplicador, es decir, suma y diferencia.
  - *Por qué se cancela el OL.* La corriente del oscilador local se reparte por igual entre las dos mitades del devanado de $T_2$ en sentidos opuestos: su efecto en la toma central (FI) y en la puerta de RF se anula. Lo mismo ocurre con la RF en la puerta de FI. Por eso no hace falta tanto filtrado.
  - *Es pasivo*: pierde unos 6 dB en la conversión (la FI sale cuatro veces más débil en potencia que la RF), pero aguanta señales fuertes sin saturarse, que es lo que más se agradece en un receptor de HF con antenas grandes.
]

#ptitulo[La célula de Gilbert: el NE602 y el SA612] Lo mismo puede hacerse con transistores. La *célula de Gilbert* usa dos pares diferenciales cruzados: el oscilador local conmuta la corriente de un par al otro, como los diodos del anillo, y la señal de RF gobierna cuánta corriente hay que conmutar. Es también doblemente equilibrada, pero además _amplifica_. El circuito integrado NE602 (hoy SA612) mete en un chip de 8 patas una célula de Gilbert y el transistor de un oscilador, que se completa por fuera con un tanque o un cristal: es el corazón de miles de receptores y transceptores sencillos de QRP (@i2c-fig-sa612 a).

#ptitulo[El MOSFET de doble puerta] Un MOSFET con dos puertas en serie a lo largo del canal (#ver(<sec-fet>)) deja pasar una corriente de drenador que depende de las dos tensiones a la vez, casi como su producto. La señal entra por la puerta 1, el oscilador local por la puerta 2, y un tanque de FI en el drenador recoge la diferencia (@i2c-fig-sa612 b). Las dos puertas están bien aisladas entre sí: el oscilador local apenas se escapa hacia la antena. Fue el mezclador clásico de los conversores de VHF.

#circuito(sim: "gilbertcell.txt", caption: [Dos mezcladores activos. (a) El SA612 (NE602) por dentro, en bloques: una célula de Gilbert (el multiplicador, ⊗) con entradas de RF en las patas 1 y 2 y salidas en las 4 y 5, y un oscilador cuyo transistor se completa por fuera en las patas 6 y 7. (b) Mezclador con MOSFET de doble puerta, polarización omitida: RF en la puerta 1, oscilador local en la puerta 2 y tanque sintonizado a la FI en el drenador.])[
  #grid(columns: 2, column-gutter: 8mm, align: horizon,
  cetz.canvas({
    import cetz.draw: *
    rect((0, 0), (4.6, 3.4), fill: col.gris-claro, stroke: 0.8pt)
    content((2.3, 3.15), text(size: 7.5pt, weight: "bold")[SA612])
    // multiplicador
    circle((2.3, 2.1), radius: 0.42, fill: white, stroke: 0.8pt)
    content((2.3, 2.1), text(size: 12pt)[$times$])
    // oscilador
    rect((1.7, 0.45), (2.9, 1.15), fill: white, stroke: 0.8pt)
    content((2.3, 0.8), text(size: 7.5pt)[oscilador])
    line((2.3, 1.15), (2.3, 1.68), stroke: 0.8pt, mark: (end: ">", fill: black))
    // patas de RF (izquierda)
    line((-0.6, 2.4), (1.95, 2.4), stroke: 0.6pt)
    line((-0.6, 1.8), (1.95, 1.8), stroke: 0.6pt)
    content((-0.1, 2.55), text(size: 7pt)[1])
    content((-0.1, 1.95), text(size: 7pt)[2])
    content((-0.7, 2.1), anchor: "east", text(size: 7.5pt)[RF])
    // salidas (derecha)
    line((2.65, 2.4), (5.2, 2.4), stroke: 0.6pt)
    line((2.65, 1.8), (5.2, 1.8), stroke: 0.6pt)
    content((4.75, 2.55), text(size: 7pt)[4])
    content((4.75, 1.95), text(size: 7pt)[5])
    content((5.3, 2.1), anchor: "west", text(size: 7.5pt)[FI])
    // oscilador (abajo)
    line((2.0, 0.45), (2.0, -0.6), stroke: 0.6pt)
    line((2.6, 0.45), (2.6, -0.6), stroke: 0.6pt)
    content((1.85, -0.2), anchor: "east", text(size: 7pt)[6])
    content((2.75, -0.2), anchor: "west", text(size: 7pt)[7])
    content((2.3, -0.85), text(size: 7.5pt)[al tanque o al cristal])
    // alimentación y masa
    line((3.9, 3.4), (3.9, 3.9), stroke: 0.6pt)
    content((3.9, 4.05), anchor: "south", text(size: 7pt)[8: +6 V])
    line((0, 0.6), (-0.5, 0.6), stroke: 0.6pt)
    content((-0.6, 0.6), anchor: "east", text(size: 7pt)[3: masa])
    content((2.3, -1.6), text(size: 8pt)[(a)])
  }),
  esquema({
    import zap: *
    import cetz.draw: content, line, circle
    // MOSFET de doble puerta dibujado a mano, centro del canal en (3, 2.4)
    let x = 3.0
    let y = 2.4
    line((x, y - 0.6), (x, y + 0.6), stroke: 1.2pt)
    line((x - 0.18, y + 0.1), (x - 0.18, y + 0.55), stroke: 1pt)
    line((x - 0.18, y - 0.55), (x - 0.18, y - 0.1), stroke: 1pt)
    line((x, y + 0.45), (x + 0.5, y + 0.45), (x + 0.5, y + 1.0), stroke: 0.6pt)
    line((x, y - 0.45), (x + 0.5, y - 0.45), (x + 0.5, y - 1.0), stroke: 0.6pt)
    line((x + 0.5, y), (x + 0.04, y), stroke: 0.6pt, mark: (end: ">", fill: black))
    line((x + 0.5, y), (x + 0.5, y - 0.45), stroke: 0.6pt)
    content((x + 0.62, y + 0.75), anchor: "west", text(size: 7pt)[D])
    content((x + 0.62, y - 0.75), anchor: "west", text(size: 7pt)[S])
    content((x - 0.3, y + 0.62), anchor: "east", text(size: 7pt)[G2])
    content((x - 0.3, y - 0.62), anchor: "east", text(size: 7pt)[G1])
    // puertas
    capacitor("cg1", (0.6, y - 0.32), (x - 0.18, y - 0.32), label: (content: [RF], anchor: "south"), n: "o-")
    capacitor("cg2", (0.6, y + 0.32), (x - 0.18, y + 0.32), label: [OL], n: "o-")
    // fuente a masa
    ground("gs", (x + 0.5, y - 1.0))
    // drenador: tanque de FI
    wire((x + 0.5, y + 1.0), (x + 0.5, y + 1.2))
    inductor("lfi", (x + 0.5, y + 1.2), (x + 0.5, y + 2.6), label: $L_"FI"$)
    capacitor("cfi", (x + 1.6, y + 1.2), (x + 1.6, y + 2.6), label: (content: $C_"FI"$, anchor: "south"))
    wire((x + 0.5, y + 1.2), (x + 1.6, y + 1.2))
    wire((x + 0.5, y + 2.6), (x + 1.6, y + 2.6))
    wire((x + 1.05, y + 2.6), (x + 1.05, y + 3.0))
    content((x + 1.05, y + 3.05), anchor: "south", text(size: 7pt)[+12 V])
    capacitor("cs", (x + 1.6, y + 1.2), (x + 2.8, y + 1.2), n: "*-o")
    content((x + 2.9, y + 1.2), anchor: "west", text(size: 7.5pt)[FI])
    content((2.6, -0.2), text(size: 8pt)[(b)])
  }))
] <i2c-fig-sa612>

#porque(titulo: [los dos mezcladores activos])[
  - *SA612, entradas.* La RF entra por las patas 1 y 2, una entrada equilibrada: si la señal llega por un solo cable, la otra pata se pone a masa para la RF con un condensador. Las dos se polarizan por dentro, así que se acoplan con condensadores.
  - *SA612, oscilador.* El transistor del oscilador está dentro, con la base en la pata 6 y el emisor en la 7. Por fuera se completa con un cristal o con un tanque LC y el divisor capacitivo de un Colpitts (@i2c-fig-conv-directa).
  - *SA612, salidas.* Las patas 4 y 5 entregan la suma y la diferencia, con la RF y el oscilador local muy atenuados, porque la célula de Gilbert es doblemente equilibrada. Gana unos 15 dB y consume solo unos 2,4 mA a 6 V.
  - *MOSFET, puertas.* La corriente del canal la gobiernan $G_1$ (la RF) y $G_2$ (el oscilador local) a la vez: la corriente de drenador contiene su producto. En el circuito real, $G_2$ lleva además una polarización continua de unos voltios y la fuente una resistencia con su condensador de desacoplo.
  - *MOSFET, drenador.* El tanque $L_"FI"$–$C_"FI"$ solo presenta impedancia alta a la FI: de todos los productos, solo la diferencia desarrolla tensión, y esa es la que sale.
]

=== La frecuencia imagen: el precio del superheterodino

El truco del superheterodino tiene una trampa. El filtro de FI acepta cualquier cosa que salga del mezclador a 9 MHz, y la diferencia con el oscilador local de 23,2 MHz vale 9 MHz para *dos* frecuencias de entrada: la emisora que quieres, en $23,2 - 9 = 14,2 "MHz"$, y otra, en $23,2 + 9 = 32,2 "MHz"$. El mezclador no sabe distinguirlas: las dos salen a 9 MHz y se oyen a la vez. Esa segunda frecuencia es la *frecuencia imagen*: está al otro lado del oscilador local, *a dos veces la FI* de la frecuencia sintonizada (@i2c-fig-imagen).

#destacada($f_"imagen" = f_s plus.minus 2 dot "FI"$, nota: [signo + si el oscilador local está por encima de la señal; − si está por debajo])

#circuito(caption: [La frecuencia imagen. Con el oscilador local en 23,2 MHz, tanto la emisora de 14,2 MHz como cualquier señal de 32,2 MHz dan 9 MHz a la salida del mezclador. La única defensa está *antes* del mezclador: un preselector sintonizado (curva discontinua) que deje pasar 14,2 MHz y atenúe 32,2 MHz.])[
  #cetz.canvas({
    import cetz.draw: *
    let sx = 0.32
    line((0, 0), (38 * sx, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((38 * sx, 0), anchor: "north-east", padding: 3pt, _i2c-t[$f$ (MHz)])
    let raya(f, h, c, etq) = {
      line((f * sx, 0), (f * sx, h), stroke: 2pt + c)
      content((f * sx, h + 0.05), anchor: "south", align(center, text(size: 7.5pt, fill: c, etq)))
    }
    raya(9.0, 0.8, col.senal2, [FI \ 9,0])
    raya(14.2, 1.3, col.senal1, [señal \ 14,2])
    raya(23.2, 1.9, col.senal4, [OL \ 23,2])
    raya(32.2, 1.0, col.naranja, [imagen \ 32,2])
    // flechas de 9 MHz a cada lado
    line((14.2 * sx, -0.45), (23.2 * sx, -0.45), mark: (start: ">", end: ">", fill: black), stroke: 0.5pt)
    content((18.7 * sx, -0.5), anchor: "north", text(size: 7pt)[9 MHz])
    line((23.2 * sx, -0.45), (32.2 * sx, -0.45), mark: (start: ">", end: ">", fill: black), stroke: 0.5pt)
    content((27.7 * sx, -0.5), anchor: "north", text(size: 7pt)[9 MHz])
    line((14.2 * sx, -1.15), (32.2 * sx, -1.15), mark: (start: ">", end: ">", fill: black), stroke: 0.5pt)
    content((23.2 * sx, -1.2), anchor: "north", text(size: 7pt)[$2 dot "FI" = 18 "MHz"$])
    // preselector
    let pre(f) = 2.4 / (1 + calc.pow((f - 14.2) / 4.0, 2) * 3)
    line(..range(0, 121).map(i => {
      let f = 2 + 34 * i / 120
      (f * sx, pre(f))
    }), stroke: (paint: col.senal1, thickness: 0.7pt, dash: "dashed"))
    content((5.0 * sx, 2.2), text(size: 7pt, fill: col.senal1)[preselector])
  })
] <i2c-fig-imagen>

#ptitulo[Cómo se defiende un receptor] Una vez dentro del mezclador, la imagen ya no tiene remedio: hay que frenarla antes. Por eso:

- *Preselector.* Un filtro sintonizado (o un amplificador de RF sintonizado, #ver(<sec-amp-sintonizado>)) antes del mezclador deja pasar la banda que escuchas y atenúa la imagen. Es la respuesta de la pregunta T4.11: «un filtro».
- *FI alta.* Cuanto mayor es la FI, más lejos queda la imagen ($2 dot "FI"$) y más fácil es que el preselector la rechace. Con FI de 455 kHz la imagen está a solo 910 kHz de la señal; con 9 MHz, a 18 MHz.
- *Doble conversión.* Pero una FI alta complica el filtro estrecho. La solución es convertir dos veces: una primera FI alta, que aleja la imagen, y una segunda FI baja, donde es fácil filtrar con mucha selectividad (pregunta T4.16). Muchos transceptores modernos de HF suben primero la señal a una FI de 45 a 70 MHz: la imagen queda por encima de 90 MHz y un simple filtro paso bajo la elimina.

#ejemplo(titulo: [la imagen en 2 metros])[Un receptor de 145 MHz con FI de 10,7 MHz y el oscilador local por encima (155,7 MHz) tiene su imagen en $145 + 2 dot 10,7 = 166,4 "MHz"$. Con el oscilador local por debajo (134,3 MHz), la imagen está en $145 - 21,4 = 123,6 "MHz"$, en plena banda aérea: allí la oiría si el preselector no la frena.]

#ojo(titulo: [mezcladores e imagen en el examen])[
  - A la salida de un mezclador están, entre otras, *la suma y la diferencia* de las frecuencias de entrada (T3.9). Con 14 MHz y 4 MHz: 10 MHz y 18 MHz (T3.13). Nunca su producto ni su cociente numéricos.
  - Mezclar dos frecuencias se llama *heterodinar* (C-T3.11); de ahí el nombre del receptor *superheterodino*.
  - La frecuencia imagen está *a dos veces la FI* de la sintonizada (T4.12), aparece en los *receptores superheterodinos* (C-T4.7) y se combate con un *filtro* antes del mezclador (T4.11).
  - Para sintonizar $f_s$ con una FI dada, el oscilador local va a $f_s + "FI"$ o a $|f_s - "FI"|$ (T4.4).
]

// =====================================================================
== El detector: recuperar la voz <sec-detector>

#motivacion[A la salida de la FI la señal ya es fuerte (del orden de un voltio) y está bien filtrada, pero sigue siendo radio: una oscilación de 455 kHz o de 9 MHz. Si la llevas tal cual a un auricular, no oyes nada. La membrana no puede moverse millones de veces por segundo, y además la RF sube y baja simétricamente: su valor medio es cero. Hay que extraer la información que lleva encima. En AM está en la _envolvente_; en SSB y CW falta la portadora, y hay que reponerla; en FM está en la _frecuencia_, y hay que convertirla en tensión. Son tres detectores distintos.]

=== El detector de envolvente: un diodo y un RC

El detector de AM es el circuito más sencillo de la radio, y ya lo conoces de la radio de galena (#ver(<sec-am>)): un diodo y una pareja RC (@i2c-fig-det-env). La @i2c-fig-det-ondas muestra lo que le pasa a la señal en cada punto.

#circuito(sim: "amdetect.txt", caption: [Detector de envolvente a la salida de la última FI (455 kHz). El diodo deja pasar las crestas positivas; $C$ se carga en cada cresta y se descarga poco a poco por $R$ entre una y otra; $C_"ac"$ entrega la envolvente al amplificador de audio sin la continua. Valores típicos: $R = 10 "kΩ"$, $C = 3,3 "nF"$ ($R C = 33 thin mu"s"$), $C_"ac" = 1 thin mu"F"$.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    trafo("tfi", (0, 1.2), nucleo: false, espiras: (4, 4))
    content((-1.2, 1.2), anchor: "east", align(center, _i2c-t[de la \ última FI]))
    wire("tfi.s1", (1.6, 2.0))
    diode("d", (1.6, 2.0), (3.0, 2.0), label: $D$)
    wire((3.0, 2.0), (6.0, 2.0))
    capacitor("c", (3.0, 2.0), (3.0, 0.4), label: (content: $C$, anchor: "south"))
    resistor("r", (4.4, 2.0), (4.4, 0.4), label: (content: $R$, anchor: "south"))
    wire("tfi.s2", (4.4, 0.4))
    ground("g", (3.7, 0.4))
    capacitor("cac", (5.6, 2.0), (7.0, 2.0), label: $C_"ac"$, n: "-o")
    content((7.15, 2.0), anchor: "west", align(left, _i2c-t[audio, al \ amplificador de BF]))
    zap.node("n1", (3.0, 2.0))
    zap.node("n2", (4.4, 2.0))
    zap.node("n3", (3.0, 0.4))
    zap.node("n4", (3.7, 0.4))
  })
] <i2c-fig-det-env>

#circuito(caption: [Las tres caras de la señal en el detector (portadora y rizado muy exagerados para que se vean). (1) La señal de AM que llega de la FI: la portadora rápida dentro de la envolvente (discontinua). (2) Lo que deja pasar el diodo: solo los semiciclos positivos. (3) La tensión en $C$: sube con cada cresta y baja despacio por $R$ hasta la siguiente; sigue la envolvente con un pequeño diente de sierra. Quitada la continua, es la voz.])[
  #cetz.canvas({
    import cetz.draw: *
    let env(t) = 1 + 0.7 * calc.sin(2 * calc.pi * t / 6)
    let vin(t) = env(t) * calc.sin(2 * calc.pi * 4 * t)
    let n = 1400
    let dt = 12 / n
    let ys = (0, -2.6, -5.0)
    let sy = 0.62
    // (1) señal de AM
    ejes(0, 12.6, -1.25, 1.35, etq-x: $t$)
    onda(t => sy * vin(t), 0, 12, n: n, stroke: 0.7pt + col.senal1)
    onda(t => sy * env(t), 0, 12, stroke: (paint: col.senal2, thickness: 0.6pt, dash: "dashed"))
    onda(t => -sy * env(t), 0, 12, stroke: (paint: col.senal2, thickness: 0.6pt, dash: "dashed"))
    content((-0.2, 0), anchor: "east", _i2c-t[(1)])
    // (2) tras el diodo
    group({
      translate((0, ys.at(1)))
      ejes(0, 12.6, -0.3, 1.35, etq-x: $t$)
      onda(t => sy * calc.max(0, vin(t)), 0, 12, n: n, stroke: 0.7pt + col.senal1)
      content((-0.2, 0.4), anchor: "east", _i2c-t[(2)])
    })
    // (3) tensión en C
    group({
      translate((0, ys.at(2)))
      ejes(0, 12.6, -0.3, 1.35, etq-x: $t$)
      let pts = ()
      let v = 0.0
      for i in range(n + 1) {
        let t = i * dt
        v = calc.max(vin(t), v * calc.exp(-dt / 0.9))
        pts.push((t, sy * v))
      }
      onda(t => sy * calc.max(0, vin(t)), 0, 12, n: n, stroke: 0.4pt + col.gris.lighten(40%))
      line(..pts, stroke: 1.1pt + col.senal3)
      onda(t => sy * env(t), 0, 12, stroke: (paint: col.senal2, thickness: 0.6pt, dash: "dashed"))
      content((-0.2, 0.4), anchor: "east", _i2c-t[(3)])
    })
  })
] <i2c-fig-det-ondas>

#porque(titulo: [el detector de envolvente])[
  - *El diodo* es la válvula antirretorno de #ver(<sec-diodo>): solo deja pasar corriente cuando la señal supera la tensión del condensador. Así carga $C$ hasta cada cresta positiva y nunca lo descarga.
  - *$C$* guarda la tensión de la última cresta: es un pequeño depósito, como el condensador de filtro de la fuente (#ver(<sec-fuente>)), pero a 455 kHz.
  - *$R$* lo vacía poco a poco entre cresta y cresta. Sin $R$, el condensador se quedaría cargado con la cresta más alta y no seguiría a la envolvente cuando baja.
  - *El resultado* es una tensión que sigue a la envolvente: la voz, montada sobre una continua proporcional a la amplitud de la portadora. $C_"ac"$ quita esa continua antes del amplificador de audio, pero no se tira: filtrada, es la tensión del *control automático de ganancia* (CAG), que mide lo fuerte que llega la emisora y baja la ganancia de la FI si llega muy fuerte.
  - *El codo del diodo* (0,6 V en silicio) haría desaparecer las señales débiles. Por eso se usa un diodo de germanio o Schottky (0,2–0,3 V) y por eso el detector va después de toda la ganancia de la FI.
]

#ptitulo[Cómo se elige el RC] Es un compromiso entre dos ritmos. Entre dos crestas de la portadora, el condensador no debe vaciarse apenas: $R C$ tiene que ser mucho mayor que el periodo de la RF. Pero cuando la envolvente baja, el condensador tiene que bajar con ella: $R C$ tiene que ser bastante menor que el periodo del audio más agudo.

#destacada($1 / f_"FI" lt.double R C lt.double 1 / f_"audio máx"$, nota: [el RC del detector: lento para la RF, rápido para la voz])

#ejemplo(titulo: [el RC de un detector de 455 kHz])[El periodo de la FI es $1 slash 455 "kHz" approx 2,2 thin mu"s"$. El del audio más agudo, a 3 kHz, es $333 thin mu"s"$. Con $R = 10 "kΩ"$ y $C = 3,3 "nF"$, $R C = 33 thin mu"s"$: quince periodos de RF (el condensador apenas se vacía entre crestas) y diez veces menos que un periodo de audio. Si pones $C = 100 "pF"$ ($R C = 1 thin mu"s"$), el condensador se vacía en cada ciclo de RF y a la salida queda mucha RF. Si pones $C = 100 "nF"$ ($R C = 1 "ms"$), el condensador no puede bajar tan deprisa como la envolvente en los agudos: la salida se queda «colgada» de las crestas y la voz se distorsiona (recorte diagonal). Una cuenta más fina da, para $m = 0,8$ y 3 kHz, un máximo de unos 40 μs: el valor elegido cumple.]

#ojo[El detector de envolvente es *asíncrono*: no necesita ninguna referencia del transmisor ni sincronizarse con él (T3.12). Se usa para *AM* (T3.38). No sirve para FM (no hay envolvente que seguir) ni para SSB (no hay portadora).]

=== El detector de producto y el BFO: SSB y CW

¿Por qué no basta un diodo para la SSB? Piensa en la SSB más simple: un tono de 1 kHz transmitido en banda lateral superior sobre 14,200 MHz. Lo que sale por la antena es *una sola sinusoide* de 14,201 MHz, de amplitud constante. Su envolvente es plana: el detector de envolvente entrega una continua y ningún tono. Con la voz es peor: la envolvente de una señal de SSB no se parece a la voz, y se oye un farfulleo ininteligible. Con la CW pasa algo parecido: la portadora aparece y desaparece, y el detector de envolvente solo da chasquidos.

La solución es reponer lo que el transmisor quitó. Un oscilador local del receptor, el *BFO* (oscilador de batido, del inglés _beat frequency oscillator_), fabrica una portadora en la frecuencia exacta donde estaba la suprimida, y un *mezclador* multiplica la señal por ella. La diferencia es el audio original (@i2c-fig-producto). El detector de producto *es un mezclador*: el anillo de diodos o el SA612 de #ver(<sec-mezclador>), con la salida en audio en lugar de en FI.

#circuito(caption: [Detector de producto. La señal de SSB en la FI (banda lateral superior entre 9,0003 y 9,0027 MHz, sin portadora) se multiplica por el BFO, colocado en 9,000 MHz, justo donde estaba la portadora suprimida. La diferencia es el audio original, de 300 a 2700 Hz; la suma, en torno a 18 MHz, la quita un paso bajo RC.])[
  #cetz.canvas({
    import cetz.draw: *
    let caja(a, b, t) = {
      rect(a, b, radius: 0.08, stroke: 0.7pt, fill: white)
      content(((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2), align(center, text(size: 8pt, t)))
    }
    caja((0, 3.2), (2.6, 4.2), [FI de SSB \ (9 MHz)])
    circle((3.8, 3.7), radius: 0.42, stroke: 0.8pt)
    content((3.8, 3.7), text(size: 12pt)[$times$])
    caja((2.7, 1.9), (4.9, 2.7), [BFO 9,000 MHz])
    caja((5.2, 3.2), (7.2, 4.2), [paso bajo \ (RC)])
    line((2.6, 3.7), (3.38, 3.7), mark: (end: ">", fill: black), stroke: 0.7pt)
    line((3.8, 2.7), (3.8, 3.28), mark: (end: ">", fill: black), stroke: 0.7pt)
    line((4.22, 3.7), (5.2, 3.7), mark: (end: ">", fill: black), stroke: 0.7pt)
    line((7.2, 3.7), (8.0, 3.7), mark: (end: ">", fill: black), stroke: 0.7pt)
    content((8.1, 3.7), anchor: "west", text(size: 8pt)[audio])
    content((3.8, 4.35), anchor: "south", text(size: 7.5pt)[detector de producto])
    // espectro de la FI
    line((0, 0), (4.2, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((4.25, 0), anchor: "west", text(size: 7pt)[MHz])
    let fx(f) = 0.4 + (f - 8.996) * 400   // 1 kHz = 0.4
    line((fx(9.0003), 0), (fx(9.0003), 0.7), (fx(9.0027), 0.4), (fx(9.0027), 0), close: true, fill: col.acento-claro, stroke: 0.7pt + col.senal1)
    line((fx(9.0), 0), (fx(9.0), 1.1), stroke: (paint: col.senal4, thickness: 1.2pt, dash: "dashed"))
    content((fx(9.0), 1.15), anchor: "south", text(size: 7pt, fill: col.senal4)[BFO])
    content((fx(9.0015), 0.85), anchor: "south", text(size: 7pt, fill: col.senal1)[BLS])
    content((fx(9.0), -0.1), anchor: "north", text(size: 7pt)[9,000])
    content((fx(9.0027), -0.1), anchor: "north", text(size: 7pt)[9,0027])
    content((2.0, -0.6), anchor: "north", text(size: 7.5pt)[en la FI])
    // espectro de audio
    let ax(f) = 5.2 + f * 0.8   // kHz
    line((5.2, 0), (8.2, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((8.25, 0), anchor: "west", text(size: 7pt)[kHz])
    line((ax(0.3), 0), (ax(0.3), 0.7), (ax(2.7), 0.4), (ax(2.7), 0), close: true, fill: col.verde-claro, stroke: 0.7pt + col.senal3)
    content((ax(0.3), -0.1), anchor: "north", text(size: 7pt)[0,3])
    content((ax(2.7), -0.1), anchor: "north", text(size: 7pt)[2,7])
    content((6.6, -0.6), anchor: "north", text(size: 7.5pt)[a la salida: la voz])
  })
] <i2c-fig-producto>

#ejemplo(titulo: [el BFO, en números])[*SSB.* La FI tiene la portadora suprimida en 9,000 MHz y la banda lateral superior encima. Un tono de 1 kHz de la voz llega a la FI como 9,001 MHz. Con el BFO en 9,000 MHz, el detector entrega $9,001 - 9,000 = 1 "kHz"$: el tono original. *CW.* La portadora de telegrafía cae en el centro del filtro, por ejemplo en 9,000 MHz. Con el BFO en 8,9993 MHz, la diferencia es un pitido de 700 Hz que suena mientras el corresponsal tiene la llave pulsada: la CW se hace audible. *Error.* Si el BFO está 100 Hz desplazado, _todas_ las frecuencias de la voz se mueven 100 Hz: el tono de 1 kHz sale a 1,1 kHz y el de 300 Hz a 400 Hz. La voz se vuelve aguda y nasal («voz de pato»). Por eso el BFO es casi siempre un oscilador de cristal, y el mando de «clarificador» o RIT de los transceptores sirve para corregir esos hercios.]

#ojo[El detector de producto se usa en los receptores de *SSB y CW* (T4.10), y el BFO es imprescindible para recibir *telegrafía y banda lateral única* (T4.34). Para AM con portadora no hace falta: la portadora ya viene en la señal.]

=== Demodular la FM: de frecuencia a tensión

En FM la amplitud no lleva información: la voz está en cuánto se aparta la frecuencia de su centro (#ver(<sec-fm>)). El detector tiene que entregar una tensión proporcional a ese desvío. Antes de él, un *limitador* (un amplificador que recorta a propósito) iguala la amplitud de la señal y borra así el ruido de amplitud, que es la mayor parte del ruido. Luego, cualquiera de estos circuitos convierte frecuencia en tensión:

- *Detector de pendiente.* Un circuito sintonizado un poco fuera de la frecuencia de la FI, para que la señal caiga en uno de los flancos de su curva de resonancia: al subir la frecuencia, sube la amplitud, y un detector de envolvente la recoge. Es sencillo, pero poco lineal.
- *Discriminador (Foster-Seeley) y detector de relación.* Dos circuitos sintonizados simétricos, uno por encima y otro por debajo de la FI, cada uno con su diodo. Se resta lo que da cada uno, y la curva de salida tiene forma de S (@i2c-fig-discriminador), con un tramo central recto: mucho más lineal. El detector de relación es además poco sensible a la amplitud.
- *Detector de cuadratura.* Una red desfasadora sintonizada gira la fase de la señal en proporción al desvío de frecuencia, y un multiplicador compara la señal con su copia desfasada. Es el que llevan casi todos los circuitos integrados de FI de FM.
- *PLL.* El lazo de la @i2c-fig-pll, sin divisor, engancha su VCO a la señal de FI. Para seguirla, la tensión de control del VCO tiene que subir y bajar exactamente al ritmo del desvío: esa tensión de control _es_ el audio.

#circuito(caption: [Cómo un discriminador convierte frecuencia en tensión. La curva en S relaciona la frecuencia de entrada con la tensión de salida: es cero en la frecuencia central de la FI y crece en proporción al desvío en el tramo central. Abajo, la frecuencia de la señal de FM oscila a un lado y otro del centro al ritmo de la voz (el tiempo avanza hacia abajo); a la derecha, la tensión de salida reproduce ese vaivén (el tiempo avanza hacia la derecha): es el audio.])[
  #cetz.canvas({
    import cetz.draw: *
    let s(x) = 1.5 * x / (1 + calc.pow(x / 1.4, 4))
    ejes(-3.2, 3.4, -0.25, 1.8, etq-x: $f$, etq-y: $v_"sal"$)
    line((-3.2, 0), (0, 0), stroke: 0.6pt)
    onda(s, -3.1, 3.1, n: 200, stroke: 1.3pt + col.senal1)
    content((-0.08, 0.08), anchor: "south-east", _i2c-t[$f_"FI"$])
    // frecuencia de entrada (tiempo hacia abajo)
    let a = 0.8
    let k = 0.17
    line((-a, 0), (-a, -2.9), stroke: (paint: col.gris, dash: "dotted", thickness: 0.5pt))
    line((a, 0), (a, -2.9), stroke: (paint: col.gris, dash: "dotted", thickness: 0.5pt))
    line(..range(0, 201).map(i => {
      let tau = 4 * calc.pi * i / 200
      (a * calc.sin(tau), -0.35 - k * tau)
    }), stroke: 1pt + col.senal2)
    content((-1.1, -2.2), anchor: "east", align(right, _i2c-t[frecuencia \ de la señal]))
    content((a, -3.05), anchor: "north", _i2c-t[$f_"FI" + Delta f$])
    content((-a, -3.05), anchor: "north", _i2c-t[$f_"FI" - Delta f$])
    // tensión de salida (tiempo hacia la derecha)
    line((-a, s(-a)), (5.9, s(-a)), stroke: (paint: col.gris, dash: "dotted", thickness: 0.5pt))
    line((a, s(a)), (5.9, s(a)), stroke: (paint: col.gris, dash: "dotted", thickness: 0.5pt))
    line(..range(0, 201).map(i => {
      let tau = 4 * calc.pi * i / 200
      (3.7 + k * tau, s(a * calc.sin(tau)))
    }), stroke: 1pt + col.senal3)
    content((5.9, 1.35), anchor: "east", _i2c-t[audio])
  })
] <i2c-fig-discriminador>

#ojo[El discriminador convierte *variaciones de frecuencia en variaciones de tensión* (F-T3.15). El detector de pendiente usa *el flanco de un circuito sintonizado* (F-T3.16). El limitador que lo precede *suprime las variaciones de amplitud*, es decir, el ruido (F-T3.17). En el receptor de FM, tras el amplificador de FI vienen, por este orden, el limitador y el discriminador (F-T4.10).]

// =====================================================================
== El modulador: poner la voz en la portadora <sec-modulador>

#motivacion[El oscilador del transmisor entrega una portadora pura, y el micrófono unos milivoltios de audio. Una portadora sin modular no lleva ningún mensaje, y el audio solo no se puede radiar (#ver(<sec-am>)). El *modulador* es la pieza que los junta: hace que la voz mande sobre la amplitud de la portadora (AM), que deje solo una de sus bandas laterales (SSB) o que mande sobre su frecuencia (FM). Cada uno tiene su circuito típico, y los tres están hechos con piezas que ya conoces.]

=== AM: la voz en la alimentación del paso final

La idea más directa para la AM aprovecha una propiedad del amplificador de clase C (#ver(<sec-clases>)): el transistor trabaja casi como un interruptor que da un golpe de corriente en cada ciclo, y el tanque del colector convierte esos golpes en una sinusoide cuya amplitud es casi igual a la *tensión de alimentación*. Si alimentas el paso final con 13,8 V, en el colector hay una oscilación de unos 13,8 V de pico; con 6,9 V, la mitad. Basta entonces con que la alimentación siga a la voz: $V_"CC" + v_"audio"$. Es la *modulación de colector* (@i2c-fig-mod-colector), la forma clásica de la AM de *alto nivel*: se modula el último paso, el de potencia.

// FALSTAD-CUSTOM: modulacion-am
#circuito(caption: [Modulación de AM de colector. El paso final, en clase C, recibe la portadora del oscilador en la base. Su alimentación no es una continua fija: el secundario del transformador de modulación, en serie con los +13,8 V, le suma la tensión del audio. La amplitud de la RF en el tanque sigue a esa alimentación, es decir, a la voz.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line, rect
    // transistor final en clase C
    npn("q1", (6, 2))
    wire("q1.e", (6, 1.0))
    ground("ge", (6, 1.0))
    capacitor("cin", (3.6, 2), (4.8, 2), label: $C_"ent"$, n: "o-")
    content((3.45, 2), anchor: "east", align(right, _i2c-t[portadora del \ oscilador]))
    wire((4.8, 2), "q1.b")
    inductor("lb", (4.8, 2), (4.8, 0.5), label: (content: $L_B$, anchor: "south"))
    ground("gb", (4.8, 0.5))
    zap.node("nb", (4.8, 2))
    // tanque del colector
    wire("q1.c", (6, 2.9))
    inductor("lt", (6, 2.9), (6, 4.3), label: $L$)
    capacitor("ct", (7.2, 2.9), (7.2, 4.3), label: $C$)
    wire((6, 2.9), (7.2, 2.9))
    wire((6, 4.3), (7.2, 4.3))
    zap.node("nc", (7.2, 2.9))
    capacitor("cs", (7.2, 2.9), (8.8, 2.9), label: $C_"sal"$, n: "-o")
    content((8.95, 2.9), anchor: "west", align(left, _i2c-t[RF modulada: \ a la red pi \ y la antena]))
    // punto M: V_CC + v_audio, desacoplo de RF
    wire((6.6, 4.3), (6.6, 6.2))
    zap.node("nm", (6.6, 5.0))
    wire((6.6, 5.0), (4.4, 5.0))
    capacitor("cd", (4.4, 5.0), (4.4, 3.9), label: (content: $C_D$, anchor: "south"))
    ground("gd", (4.4, 3.9))
    content((6.75, 5.0), anchor: "west", _i2c-t(fill: col.ambar)[$V_"CC" + v_"audio"$])
    // transformador de modulación
    trafo("tm", (5.4, 7.0), espiras: (4, 4))
    wire("tm.s2", (6.6, 6.2))
    wire("tm.s1", (6.6, 7.8), (6.6, 8.4))
    content((6.6, 8.45), anchor: "south", _i2c-t[+13,8 V])
    ground("gp", "tm.p2")
    rect((0.2, 7.4), (3.4, 8.2), radius: 0.08, stroke: 0.7pt, fill: white)
    content((1.8, 7.8), align(center, text(size: 7pt)[amplificador de audio \ (el modulador)]))
    wire((3.4, 7.8), "tm.p1")
    content((6.8, 7.0), anchor: "west", align(left, _i2c-t[transformador \ de modulación]))
  })
] <i2c-fig-mod-colector>

#porque(titulo: [la modulación de colector])[
  - *El transistor en clase C*: su base no tiene polarización (la bobina $L_B$ la une a masa para la continua), así que solo conduce en las crestas de la portadora, cuando esta supera los 0,6 V. Rinde mucho, y la distorsión no importa: el tanque $L C$ reconstruye la sinusoide (el efecto volante).
  - *La amplitud la pone la alimentación.* En cada ciclo, el tanque oscila entre casi 0 V y casi el doble de la tensión que le llega. Si esa tensión cambia, cambia la amplitud de la RF en la misma proporción.
  - *El transformador de modulación* mete el audio en serie con los 13,8 V: a la alimentación del colector se le suma y se le resta la voz. Tiene que manejar potencia de verdad: el amplificador de audio que lo excita es el modulador.
  - *$C_D$* une a masa la RF en el punto de alimentación (para que no vuelva por el transformador), pero tiene que ser lo bastante pequeño para *no* cortocircuitar el audio: 10 nF son 2,3 Ω a 7 MHz y 5,3 kΩ a 3 kHz.
]

// FALSTAD-CUSTOM: modulacion-am
#circuito(caption: [Lo que sale del modulador de colector. La alimentación del colector (en ámbar) sube y baja con la voz alrededor de $V_"CC"$; la RF de salida (en azul) tiene en cada instante una amplitud igual a esa alimentación. La envolvente de la emisión es la voz.])[
  #cetz.canvas({
    import cetz.draw: *
    let env(t) = 1 + 0.75 * calc.sin(2 * calc.pi * t / 6)
    let sy = 0.85
    ejes(0, 12.6, -1.75, 1.95, etq-x: $t$, etq-y: $v$)
    onda(t => sy * env(t) * calc.sin(2 * calc.pi * 3 * t), 0, 12, n: 1000, stroke: 0.7pt + col.senal1)
    onda(t => sy * env(t), 0, 12, stroke: 1.4pt + col.ambar)
    onda(t => -sy * env(t), 0, 12, stroke: (paint: col.ambar, thickness: 0.6pt, dash: "dashed"))
    line((0, sy), (12, sy), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dotted"))
    content((12.1, sy), anchor: "west", _i2c-t[$V_"CC"$])
    content((3.2, 1.8), anchor: "south", _i2c-t(fill: col.ambar)[alimentación: $V_"CC" + v_"audio"$])
  })
] <i2c-fig-mod-ondas>

#ejemplo(titulo: [un modulador de colector de 13,8 V])[Para modular al 100 %, el audio tiene que llegar a 13,8 V de pico: la alimentación del colector sube hasta $2 dot 13,8 = 27,6 "V"$ en las crestas de la voz y baja a cero en los valles. Como el tanque oscila hasta el doble de su alimentación, el transistor ve picos de $2 dot 27,6 approx 55 "V"$: cuatro veces $V_"CC"$, y así hay que elegirlo. El audio, además, aporta potencia: con un tono al 100 %, el modulador tiene que entregar la *mitad* de la potencia de continua del paso final. Si el final consume 20 W de la fuente, hacen falta 10 W de audio, y la potencia total emitida sube a 1,5 veces la de la portadora sola. Si el audio supera los 13,8 V de pico, la alimentación intenta bajar de cero, la envolvente se recorta y la emisión salpica a los vecinos: *sobremodulación* (T5.31). Se evita bajando la ganancia del micrófono o del audio (T5.32).]

=== SSB: el modulador equilibrado y el filtro

La AM con portadora malgasta: dos tercios de la potencia van a la portadora, que no lleva información, y las dos bandas laterales dicen lo mismo (#ver(<sec-am>)). La SSB se queda con una sola banda lateral, y se fabrica en dos pasos (@i2c-fig-ssb):

+ *El modulador equilibrado* multiplica el audio por la portadora. Es un mezclador doblemente equilibrado (el anillo de la @i2c-fig-anillo o un SA612): la portadora entra por la puerta del oscilador local, el audio por la de FI, y por la de RF sale el producto, es decir, las dos bandas laterales, $f_c - f_"audio"$ y $f_c + f_"audio"$. La portadora no aparece, por la misma simetría que en el mezclador cancelaba el oscilador local. A esta señal se la llama *doble banda lateral* (DBL o DSB).
+ *El filtro de cuarzo* deja pasar una banda lateral y rechaza la otra. Es la tarea más delicada: entre las dos bandas solo hay 600 Hz de separación (de $f_c - 300 "Hz"$ a $f_c + 300 "Hz"$), y en ese hueco el filtro tiene que pasar de dejarlo todo a rechazarlo casi todo. Solo un filtro de cristal, de $Q$ altísimo, lo consigue (#ver(<sec-cristal>)).

#circuito(caption: [Cómo nace una señal de SSB. El modulador equilibrado multiplica el audio por la portadora de 9 MHz: salen las dos bandas laterales, sin portadora (DSB). El filtro de cuarzo, de unos 2,4 kHz de ancho, deja pasar solo la banda lateral superior (BLS). Debajo de cada flecha, el espectro de la señal en ese punto.])[
  #cetz.canvas({
    import cetz.draw: *
    let caja(a, b, t) = {
      rect(a, b, radius: 0.08, stroke: 0.7pt, fill: white)
      content(((a.at(0) + b.at(0)) / 2, (a.at(1) + b.at(1)) / 2), align(center, text(size: 7pt, t)))
    }
    caja((-0.3, 3.0), (2.5, 3.9), [micrófono y \ amplificador de audio])
    circle((3.5, 3.45), radius: 0.42, stroke: 0.8pt)
    content((3.5, 3.45), text(size: 12pt)[$times$])
    content((3.5, 4.0), anchor: "south", text(size: 7pt)[modulador equilibrado])
    caja((2.0, 1.6), (5.0, 2.5), [oscilador de portadora \ 9,000 MHz (cristal)])
    caja((5.7, 3.0), (7.9, 3.9), [filtro de cuarzo \ 2,4 kHz])
    line((2.5, 3.45), (3.08, 3.45), mark: (end: ">", fill: black), stroke: 0.7pt)
    line((3.5, 2.5), (3.5, 3.03), mark: (end: ">", fill: black), stroke: 0.7pt)
    line((3.92, 3.45), (5.7, 3.45), mark: (end: ">", fill: black), stroke: 0.7pt)
    line((7.9, 3.45), (9.0, 3.45), mark: (end: ">", fill: black), stroke: 0.7pt)
    content((9.1, 3.45), anchor: "west", align(left, text(size: 7.5pt)[SSB a 9 MHz: \ al mezclador]))
    content((4.8, 3.55), anchor: "south", text(size: 7pt)[DSB])
    // espectros
    let banda(x0, x1, h0, h1, c, f) = line((x0, 0), (x0, h0), (x1, h1), (x1, 0), close: true, fill: f, stroke: 0.7pt + c)
    // (1) audio
    line((0, 0), (2.4, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    banda(0.3, 2.0, 0.7, 0.4, col.senal3, col.verde-claro)
    content((0.3, -0.08), anchor: "north", text(size: 7pt)[0,3])
    content((2.0, -0.08), anchor: "north", text(size: 7pt)[2,7 kHz])
    content((1.2, -0.55), anchor: "north", text(size: 7.5pt)[audio])
    // (2) DSB
    let c2 = 5.0
    line((c2 - 2.3, 0), (c2 + 2.3, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    banda(c2 + 0.25, c2 + 1.95, 0.7, 0.4, col.senal1, col.acento-claro)
    banda(c2 - 0.25, c2 - 1.95, 0.7, 0.4, col.senal1, col.acento-claro)
    line((c2, 0), (c2, 0.9), stroke: (paint: col.senal4, thickness: 1pt, dash: "dashed"))
    content((c2, 0.95), anchor: "south", text(size: 7pt, fill: col.senal4)[sin portadora])
    content((c2 - 1.1, 0.75), anchor: "south", text(size: 7pt)[BLI])
    content((c2 + 1.1, 0.75), anchor: "south", text(size: 7pt)[BLS])
    content((c2, -0.08), anchor: "north", text(size: 7pt)[9,000])
    content((c2, -0.55), anchor: "north", text(size: 7.5pt)[DSB: dos bandas, sin portadora])
    // (3) SSB
    let c3 = 8.6
    line((c3 - 1.5, 0), (c3 + 2.6, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    line((c3 + 0.05, 0), (c3 + 0.3, 1.05), (c3 + 1.9, 1.05), (c3 + 2.15, 0), stroke: (paint: col.senal2, thickness: 0.6pt, dash: "dashed"))
    banda(c3 + 0.25, c3 + 1.95, 0.7, 0.4, col.senal1, col.acento-claro)
    line((c3, 0), (c3, 0.5), stroke: (paint: col.senal4, thickness: 1pt, dash: "dashed"))
    content((c3 + 1.1, 1.1), anchor: "south", text(size: 7pt, fill: col.senal2)[filtro])
    content((c3, -0.08), anchor: "north", text(size: 7pt)[9,000])
    content((c3 + 0.5, -0.55), anchor: "north", text(size: 7.5pt)[SSB: solo la BLS])
  })
] <i2c-fig-ssb>

#porque(titulo: [por qué el modulador equilibrado no deja pasar la portadora])[
  - *Es un multiplicador.* A su salida solo hay productos de la portadora por el audio: $f_c plus.minus f_"audio"$. Sin audio, el producto es cero: el transmisor de SSB callado no emite nada. Esa es la gran diferencia con la AM, que emite la portadora siempre.
  - *La simetría cancela la portadora.* Como en el anillo de la @i2c-fig-anillo, la corriente de la portadora recorre las dos mitades del transformador de salida en sentidos opuestos y se anula. En la práctica queda un pequeño resto, 40 o 50 dB por debajo, que se ajusta con un potenciómetro de equilibrado; el filtro posterior lo atenúa todavía más.
  - *Cambiar de banda lateral* no exige otro filtro: basta con mover el oscilador de portadora al otro lado del filtro (por ejemplo, de 9,0000 a 9,0030 MHz). Así, con un solo filtro, se elige BLS o BLI.
  - Después del filtro, un mezclador con el VFO lleva la señal de 9 MHz a la frecuencia de trabajo, y la amplifican etapas *lineales* (clase A o AB, nunca C: la envolvente de la SSB es la voz, y la clase C la destruiría).
]

#ojo[En un transmisor de SSB, el modulador equilibrado *suprime la portadora y deja solo las dos bandas laterales* (T5.27); la banda sobrante la quita el filtro. Otra forma de llegar a la SSB, el *método de fase*, usa dos moduladores equilibrados con la portadora y el audio desfasados 90°: las bandas no deseadas se cancelan entre sí, sin filtro de cuarzo. Es lo que hacen hoy, con números, las radios definidas por software.]

=== FM: un varicap en el tanque del oscilador

La frecuencia de un oscilador la fija su tanque, y la del tanque, su condensador: $f_0 = 1 slash (2 pi sqrt(L C))$. Si una parte de ese condensador se puede variar con una tensión, la frecuencia del oscilador obedece a esa tensión. Esa pieza existe: el *varicap* (#ver(<sec-diodo>)), un diodo polarizado en inversa cuya zona de deplexión hace de aislante, más ancha y con menos capacidad cuanto mayor es la tensión inversa. Pon un varicap en el tanque del Colpitts, suma la voz a su tensión de polarización, y la frecuencia sube y baja con la voz: *modulación de frecuencia directa* (@i2c-fig-mod-fm). El oscilador se ha convertido en un VCO.

#circuito(sim: "varactorvco.txt", caption: [Modulador de FM directo: el tanque de un oscilador (por ejemplo, el de la @i2c-fig-colpitts-real) con un varicap $D_V$ acoplado por $C_c$. $R$ lleva al varicap una tensión inversa fija (+4 V) con el audio sumado; al variar la tensión, varía su capacidad, y con ella la frecuencia del oscilador.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    wire((-1.4, 3.0), (2.6, 3.0))
    zap.node("osc", (-1.4, 3.0), fill: false)
    content((-1.55, 3.0), anchor: "east", align(right, _i2c-t[al transistor \ del oscilador]))
    inductor("l", (0, 3.0), (0, 0.6), label: (content: $L$, anchor: "south"))
    ground("gl", (0, 0.6))
    capacitor("c", (1.2, 3.0), (1.2, 0.6), label: $C$)
    ground("gc", (1.2, 0.6))
    capacitor("cc", (2.6, 3.0), (3.9, 3.0), label: $C_c$)
    wire((3.9, 3.0), (5.4, 3.0))
    _i2c-varicap("dv", (4.4, 0.6), (4.4, 3.0), label: (content: $D_V$, anchor: "south"))
    ground("gv", (4.4, 0.6))
    resistor("r", (5.4, 3.0), (7.2, 3.0), label: $R$, n: "-o")
    content((7.35, 3.0), anchor: "west", align(left, _i2c-t[+4 V \ más el audio]))
    zap.node("n0", (0, 3.0))
    zap.node("n1", (1.2, 3.0))
    zap.node("n2", (4.4, 3.0))
  })
] <i2c-fig-mod-fm>

#porque(titulo: [el modulador de varicap])[
  - *El varicap* está polarizado en inversa: cátodo (arriba) a +4 V, ánodo a masa. Nunca debe llegar a conducir, por eso la polarización fija es mayor que el pico del audio.
  - *Cuando la voz sube*, la tensión inversa crece, la zona de deplexión se ensancha, la capacidad baja y la frecuencia del oscilador sube. Cuando baja, al revés. La desviación de frecuencia es proporcional al volumen de la voz, y su ritmo, al tono: eso es la FM.
  - *$C_c$* separa la continua del varicap de la bobina (que está a masa para la continua) y, si es pequeño, hace que el varicap solo controle una parte del tanque: menos desviación, pero un oscilador más estable.
  - *$R$*, de valor alto (47 kΩ, por ejemplo), lleva la tensión al varicap sin cargar el tanque ni dejar que la RF vuelva hacia el amplificador de audio.
]

#ejemplo(titulo: [la desviación se multiplica])[Muchos transmisores de VHF generan la FM en un oscilador de unos 12 MHz y suben luego la frecuencia con multiplicadores (#ver(<sec-amp-sintonizado>)): por ejemplo, 12,1 MHz $times 12 = 145,2$ MHz. Un multiplicador de frecuencia multiplica _todo_ lo que lleva la frecuencia, también su desviación: si a la salida se quieren $plus.minus 2,5 "kHz"$ (canales de 12,5 kHz), el oscilador solo tiene que desviarse $2500 slash 12 approx 208 "Hz"$. Es la cuenta de la pregunta F-T5.10. En los equipos con sintetizador, el audio se aplica directamente al varicap del VCO del PLL.]

#ojo[Un VCO es un oscilador cuya *frecuencia depende de una tensión de control* (F-T3.18), y la voz actúa sobre él a través del *varicap* en la FM directa (F-T3.20, F-T5.11). El varicap es un diodo cuya capacidad varía con la tensión inversa aplicada (T2.25). La FM *indirecta* modula la fase de la portadora después del oscilador: su ventaja es que el oscilador puede ser un cristal, muy estable (F-T5.13).]

// =====================================================================
== La radio entera, cable a cable <sec-radio-entera>

Ha llegado el momento de juntarlo todo. La @i2c-fig-radio es la radio completa de bloques de #ver(<sec-esquemas>), ya sin cajas negras: cada componente es uno de los que acabas de abrir. Léela dos veces, una por corriente, como el amplificador de #ver(<sec-amplificador-ec>).

#ptitulo[Pasada en ámbar: la continua] Nace en la fuente de #ver(<sec-fuente>) — sus $tilde 20$ V, dejados en 12 limpios por el estabilizador zéner, quedan aquí resumidos en el raíl +12 V — y baja a masa por dos caminos gemelos: raíl → $R_C$ → transistor → $R_E$ → masa, en cada una de las dos etapas amplificadoras. Los divisores de base sangran su goteo para sostener las bases en su punto. Esta corriente no lleva información ninguna: es el _escenario_ — puntos de trabajo, grifos entreabiertos — sobre el que la señal va a actuar. Si la mides con un polímetro, la radio en silencio y la radio a pleno volumen consumen casi lo mismo: la continua está ahí, esperando.

#ptitulo[Pasada en azul: la señal] La onda de la emisora induce en la antena un vaivén de microvoltios. El tanque $L$–$C_v$ solo ofrece impedancia alta — solo _desarrolla tensión_ — a su frecuencia de resonancia: girar $C_v$ es elegir emisora, y las demás se van a masa por el propio tanque. La elegida entra por el condensador de acoplo a la base del primer transistor, que la devuelve amplificada (¡e invertida!) en su colector. El diodo y su RC — el detector del capítulo anterior, y el de envolvente de #ver(<sec-detector>) — tiran la RF y conservan la envolvente: a partir de aquí ya no viaja radio, viaja _audio_. ($R_p$ da al ánodo del diodo un camino de continua a masa: sin ella, el condensador de acoplo que lo precede se iría cargando con las crestas hasta dejar al diodo sin conducir.) El segundo transistor, idéntico en estructura al primero, lo sube de nivel, y el condensador de salida lo entrega al auricular sin la continua del colector. Microvoltios en la antena, voz en la oreja, y ni un solo componente que no sepas ya cómo funciona por dentro.

#circuito(caption: [La radio entera, componente a componente: tanque de sintonía, amplificador de RF en emisor común, detector de diodo con su filtro RC y amplificador de BF, entre el raíl de +12 V que entrega la fuente de #ver(<sec-fuente>) y masa. En ámbar, las corrientes continuas de polarización que bajan del raíl a masa por cada etapa; en azul, la señal abriéndose camino de la antena al auricular. Cada pieza está explicada en una sección de este capítulo.])[
  #esquema(escala: 0.93, {
    import zap: *
    import cetz.draw: content, line
    // raíles
    wire((1.4, 6), (13.9, 6))
    zap.node("vcc", (1.4, 6), fill: false)
    content((14.0, 6), anchor: "west", _i2c-t[+12 V])
    wire((1.8, 0), (13.9, 0))
    content((14.0, 0), anchor: "west", _i2c-t[masa])
    // sintonía
    antenna("ant", (1.1, 4.0))
    wire((1.1, 4.0), (3.3, 4.0))
    inductor("l", (1.8, 4.0), (1.8, 0), label: (content: $L$, anchor: "south"))
    capacitor("cv", (2.6, 4.0), (2.6, 0), variable: true)
    content((2.95, 3.25), _i2c-t[$C_v$])
    // amplificador de RF
    wire((3.3, 4.0), (3.3, 3.0))
    capacitor("ca1", (3.3, 3.0), (4.0, 3.0))
    resistor("r1", (4.0, 6), (4.0, 3.0), label: $R_1$)
    resistor("r2", (4.0, 3.0), (4.0, 0), label: $R_2$)
    npn("q1", (5.5, 3.0))
    wire((4.0, 3.0), "q1.b")
    resistor("rc1", (5.5, 6), (5.5, 4.3), label: $R_"C1"$)
    wire("q1.c", (5.5, 4.3))
    wire("q1.e", (5.5, 2.1))
    resistor("re1", (5.5, 2.1), (5.5, 0), label: (content: $R_"E1"$, anchor: "south"))
    wire((5.5, 2.1), (6.4, 2.1))
    capacitor("ce1", (6.4, 2.1), (6.4, 0), width: 0.5)
    // detector
    wire((5.5, 4.3), (5.9, 4.3))
    capacitor("ca2", (5.9, 4.3), (6.85, 4.3))
    wire((6.85, 4.3), (7.05, 4.3))
    resistor("rp", (7.05, 4.3), (7.05, 0))
    content((7.4, 3.05), _i2c-t[$R_p$])
    diode("d", (7.05, 4.3), (8.2, 4.3))
    resistor("rd", (8.2, 4.3), (8.2, 0))
    content((8.55, 3.05), _i2c-t[$R_d$])
    wire((8.2, 4.3), (9.1, 4.3))
    capacitor("cd", (9.1, 4.3), (9.1, 0), label: (content: $C_d$, anchor: "south"))
    // amplificador de BF
    wire((9.1, 4.3), (9.6, 4.3), (9.6, 3.2))
    capacitor("ca3", (9.6, 3.2), (10.4, 3.2))
    resistor("r3", (10.4, 6), (10.4, 3.2), label: $R_3$)
    resistor("r4", (10.4, 3.2), (10.4, 0), label: $R_4$)
    npn("q2", (11.9, 3.2))
    wire((10.4, 3.2), "q2.b")
    resistor("rc2", (11.9, 6), (11.9, 4.6), label: $R_"C2"$)
    wire("q2.c", (11.9, 4.6))
    wire("q2.e", (11.9, 2.3))
    resistor("re2", (11.9, 2.3), (11.9, 0), label: (content: $R_"E2"$, anchor: "south"))
    wire((11.9, 2.3), (12.8, 2.3))
    capacitor("ce2", (12.8, 2.3), (12.8, 0), width: 0.5)
    wire((11.9, 4.6), (12.2, 4.6))
    capacitor("cs", (12.2, 4.6), (13.0, 4.6))
    wire((13.0, 4.6), (13.7, 4.6), (13.7, 3.7))
    altavoz("aur", (13.7, 3.7), (13.7, 2.1))
    wire((13.7, 2.1), (13.7, 0))
    content((14.35, 3.0), anchor: "west", _i2c-t[auricular])
    // nudos
    for (nm, pt) in (("n1", (1.8, 4.0)), ("n2", (2.6, 4.0)), ("n1b", (1.8, 0)), ("n2b", (2.6, 0)), ("a", (4.0, 3.0)), ("b", (4.0, 6)), ("c", (4.0, 0)), ("d", (5.5, 6)), ("e", (5.5, 4.3)), ("f", (5.5, 2.1)), ("g", (5.5, 0)), ("h", (6.4, 0)), ("i", (7.05, 4.3)), ("j", (7.05, 0)), ("k", (8.2, 4.3)), ("m", (8.2, 0)), ("o", (9.1, 4.3)), ("p", (9.1, 0)), ("q", (10.4, 3.2)), ("r", (10.4, 6)), ("s", (10.4, 0)), ("t", (11.9, 6)), ("u", (11.9, 4.6)), ("v", (11.9, 2.3)), ("w", (11.9, 0)), ("x", (12.8, 0)), ("y", (13.7, 0))) {
      zap.node("nd" + nm, pt)
    }
    // corrientes
    _i2c-flecha((5.15, 5.8), (5.15, 4.9), col.ambar)
    _i2c-flecha((11.55, 5.8), (11.55, 5.0), col.ambar)
    _i2c-flecha((0.35, 3.6), (0.95, 3.6), col.acento)
    _i2c-flecha((8.35, 4.75), (8.95, 4.75), col.acento)
    _i2c-flecha((14.0, 4.45), (14.0, 3.85), col.acento)
    // rótulos de etapa
    for (x, t) in ((2.2, [sintonía]), (4.8, [amplificador de RF]), (8.1, [detector]), (11.4, [amplificador de BF])) {
      content((x, -0.45), anchor: "north", text(size: 7.5pt, fill: col.gris, t))
    }
  })
] <i2c-fig-radio>

#porque(titulo: [la radio entera, etapa a etapa])[
  - *Sintonía.* El tanque $L$–$C_v$ desarrolla tensión solo a su $f_0$ y manda a masa las demás emisoras (#ver(<sec-resonancia>)).
  - *Amplificador de RF.* El condensador de acoplo pasa la RF a la base sin tocar los 2,1 V del divisor $R_1$–$R_2$; $R_"C1"$, $R_"E1"$ y su condensador de desacoplo forman el emisor común de #ver(<sec-amplificador-ec>).
  - *Detector.* El segundo condensador de acoplo lleva la RF amplificada al diodo; $R_p$ da al ánodo su camino de continua; el diodo y $R_d$–$C_d$ son el detector de envolvente de #ver(<sec-detector>).
  - *Amplificador de BF.* Otro acoplo, otro divisor ($R_3$–$R_4$) y otro emisor común. Aquí el condensador de desacoplo del emisor tiene que ser grande (decenas de μF), porque lo que pasa ya es audio.
  - *Salida.* El condensador de salida deja pasar el audio al auricular y bloquea la continua del colector.
]

=== De la radio mínima al superheterodino

La radio de la @i2c-fig-radio funciona, pero tiene los límites de todo receptor TRF. Un solo tanque no separa dos emisoras de SSB a 3 kHz, su selectividad cambia al mover el dial y su amplificador de RF no puede dar mucha ganancia sin oscilar. El superheterodino de la @i2c-fig-superhet conserva todas sus piezas y añade las de este capítulo: el oscilador local, el mezclador, el filtro de FI de cuarzo y, para SSB y CW, el BFO. La @i2c-tab-superhet dice qué circuito hay dentro de cada bloque y dónde se explica.

#circuito(caption: [Receptor superheterodino completo. La señal (flechas continuas) va de la antena al altavoz; el oscilador local y el BFO son fabricados dentro del receptor; la línea discontinua es el control automático de ganancia (CAG), que lleva hacia atrás la continua del detector. Los números remiten a la @i2c-tab-superhet.])[
  #set text(size: 8pt)
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (5.5mm, 9mm), node-inset: 5pt,
    node((0, 0), [antena], stroke: none, name: <i2c-s-ant>),
    node((1, 0), align(center)[#_i2c-n(1) \ Preselector], shape: rect, name: <i2c-s-pre>),
    node((2, 0), align(center)[#_i2c-n(2) \ Amplificador \ de RF], shape: rect, name: <i2c-s-rf>),
    node((3, 0), align(center)[#_i2c-n(4) \ Mezclador], shape: rect, name: <i2c-s-mez>),
    node((4, 0), align(center)[#_i2c-n(5) \ Filtro de FI \ (cuarzo)], shape: rect, name: <i2c-s-fi>),
    node((5, 0), align(center)[#_i2c-n(6) \ Amplificador \ de FI], shape: rect, name: <i2c-s-afi>),
    node((3, -1), align(center)[#_i2c-n(3) Oscilador local (VFO, PLL o DDS)], shape: rect, name: <i2c-s-ol>),
    node((5, 1), align(center)[#_i2c-n(7) \ Detector], shape: rect, name: <i2c-s-det>),
    node((5, 2), align(center)[#_i2c-n(8) BFO (SSB, CW)], shape: rect, name: <i2c-s-bfo>),
    node((4, 1), align(center)[#_i2c-n(9) \ Amplificador \ de BF], shape: rect, name: <i2c-s-bf>),
    node((3, 1), [altavoz], stroke: none, name: <i2c-s-alt>),
    edge(<i2c-s-ant>, <i2c-s-pre>, "-|>"),
    edge(<i2c-s-pre>, <i2c-s-rf>, "-|>"),
    edge(<i2c-s-rf>, <i2c-s-mez>, "-|>"),
    edge(<i2c-s-mez>, <i2c-s-fi>, "-|>"),
    edge(<i2c-s-fi>, <i2c-s-afi>, "-|>"),
    edge(<i2c-s-ol>, <i2c-s-mez>, "-|>"),
    edge(<i2c-s-afi>, <i2c-s-det>, "-|>"),
    edge(<i2c-s-bfo>, <i2c-s-det>, "-|>"),
    edge(<i2c-s-det>, <i2c-s-bf>, "-|>"),
    edge(<i2c-s-bf>, <i2c-s-alt>, "-|>"),
    edge(<i2c-s-det>, (5.75, 1), (5.75, 0), <i2c-s-afi>, "--|>", stroke: col.ambar, label: text(size: 7pt, fill: col.ambar)[CAG], label-side: left, label-pos: 0.5),
  )
] <i2c-fig-superhet>

#show figure.where(kind: table): set block(breakable: true)
#figure(kind: table, caption: [Qué hay dentro de cada bloque del superheterodino de la @i2c-fig-superhet.],
  table(columns: (auto, 21%, 1fr, 29%), align: (center, left, left, left),
    table.header([*N.º*], [*Bloque*], [*Circuito*], [*Dónde se explica*]),
    _i2c-n(1), [Preselector], [Uno o dos tanques LC sintonizados a la banda: deja pasar la banda que escuchas y frena la frecuencia imagen.], [#ver(<sec-resonancia>), #ver(<sec-mezclador>)],
    _i2c-n(2), [Amplificador de RF], [Transistor en emisor común (o un FET) con un tanque en el colector: amplificador sintonizado.], [#ver(<sec-amp-sintonizado>)],
    _i2c-n(3), [Oscilador local], [VFO Colpitts, Hartley o Clapp; en los equipos modernos, PLL o DDS con referencia de cristal.], [#ver(<sec-oscilador>)],
    _i2c-n(4), [Mezclador], [Anillo de diodos, célula de Gilbert (SA612) o MOSFET de doble puerta.], [#ver(<sec-mezclador>)],
    _i2c-n(5), [Filtro de FI], [Filtro de cristales de cuarzo, de 2,4 kHz para SSB, 500 Hz para CW.], [#ver(<sec-cristal>)],
    _i2c-n(6), [Amplificador de FI], [Una o varias etapas sintonizadas a la FI, con la ganancia gobernada por el CAG.], [#ver(<sec-amp-sintonizado>)],
    _i2c-n(7), [Detector], [De envolvente (AM), de producto (SSB y CW) o discriminador tras un limitador (FM).], [#ver(<sec-detector>)],
    _i2c-n(8), [BFO], [Oscilador de cristal en la frecuencia de la portadora suprimida.], [#ver(<sec-cristal>)],
    _i2c-n(9), [Amplificador de BF], [Emisor común y un paso de salida en contrafase de clase AB.], [#ver(<sec-amplificador-ec>), #ver(<sec-clases>)],
    [—], [Fuente], [Transformador, puente, condensador de filtro y regulador; alimenta todas las etapas.], [#ver(<sec-fuente>)],
  )
) <i2c-tab-superhet>

#ptitulo[El CAG, el lazo que no se ve] La continua que entrega el detector de envolvente es proporcional a la intensidad de la emisora. Filtrada (con una constante de tiempo de décimas de segundo, para que no siga a la voz), vuelve hacia atrás y baja la ganancia de los amplificadores de FI y de RF cuando la señal llega fuerte. Así una emisora local y una lejana suenan con un volumen parecido, y el receptor no se satura. Es una realimentación, como la del oscilador, pero *negativa*: en lugar de reforzar, corrige. Esa misma tensión mueve la aguja del S-metro.

=== El transmisor de SSB, bloque a bloque

El transmisor es la misma cadena recorrida al revés (@i2c-fig-tx-ssb). La voz se modula a una frecuencia fija, donde están el oscilador de cristal y el filtro de cuarzo, y luego un mezclador la sube a la banda, exactamente como el receptor la bajaba. La @i2c-tab-tx-ssb recorre los bloques.

#circuito(caption: [Transmisor de SSB. La señal se fabrica a 9 MHz (modulador equilibrado y filtro de cuarzo), un mezclador la lleva a la banda con el VFO, y los amplificadores lineales la suben de potencia. El filtro paso bajo final quita los armónicos y adapta la impedancia a los 50 Ω de la antena. Los números remiten a la @i2c-tab-tx-ssb.])[
  #set text(size: 8pt)
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (5.5mm, 9mm), node-inset: 5pt,
    node((0, 0), [micrófono], stroke: none, name: <i2c-t-mic>),
    node((1, 0), align(center)[#_i2c-n(1) \ Amplificador \ de audio], shape: rect, name: <i2c-t-aa>),
    node((2, 0), align(center)[#_i2c-n(3) \ Modulador \ equilibrado], shape: rect, name: <i2c-t-mod>),
    node((3, 0), align(center)[#_i2c-n(4) \ Filtro \ de cuarzo], shape: rect, name: <i2c-t-fil>),
    node((4, 0), align(center)[#_i2c-n(6) \ Mezclador], shape: rect, name: <i2c-t-mez>),
    node((5, 0), align(center)[#_i2c-n(7) \ Filtro \ paso banda], shape: rect, name: <i2c-t-pb>),
    node((2, -1), align(center)[#_i2c-n(2) Oscilador de portadora (cristal)], shape: rect, name: <i2c-t-osc>),
    node((4, -1), align(center)[#_i2c-n(5) VFO o PLL], shape: rect, name: <i2c-t-vfo>),
    node((5, 1), align(center)[#_i2c-n(8) \ Excitador y \ final lineal], shape: rect, name: <i2c-t-pa>),
    node((4, 1), align(center)[#_i2c-n(9) \ Filtro paso bajo \ y red en pi], shape: rect, name: <i2c-t-lpf>),
    node((3, 1), [antena], stroke: none, name: <i2c-t-ant>),
    edge(<i2c-t-mic>, <i2c-t-aa>, "-|>"),
    edge(<i2c-t-aa>, <i2c-t-mod>, "-|>"),
    edge(<i2c-t-mod>, <i2c-t-fil>, "-|>", label: text(size: 7pt)[DSB], label-side: left),
    edge(<i2c-t-fil>, <i2c-t-mez>, "-|>", label: text(size: 7pt)[SSB], label-side: left),
    edge(<i2c-t-mez>, <i2c-t-pb>, "-|>"),
    edge(<i2c-t-osc>, <i2c-t-mod>, "-|>"),
    edge(<i2c-t-vfo>, <i2c-t-mez>, "-|>"),
    edge(<i2c-t-pb>, <i2c-t-pa>, "-|>"),
    edge(<i2c-t-pa>, <i2c-t-lpf>, "-|>"),
    edge(<i2c-t-lpf>, <i2c-t-ant>, "-|>"),
  )
] <i2c-fig-tx-ssb>

#figure(kind: table, caption: [Qué hay dentro de cada bloque del transmisor de SSB de la @i2c-fig-tx-ssb.],
  table(columns: (auto, 21%, 1fr, 29%), align: (center, left, left, left),
    table.header([*N.º*], [*Bloque*], [*Circuito*], [*Dónde se explica*]),
    _i2c-n(1), [Amplificador de audio], [Emisor común (o un amplificador operacional) que sube los milivoltios del micrófono.], [#ver(<sec-amplificador-ec>)],
    _i2c-n(2), [Oscilador de portadora], [Colpitts a cristal, a la frecuencia del borde del filtro.], [#ver(<sec-cristal>)],
    _i2c-n(3), [Modulador equilibrado], [Anillo de diodos o SA612: audio por portadora, sin portadora a la salida.], [#ver(<sec-modulador>)],
    _i2c-n(4), [Filtro de cuarzo], [El mismo filtro de FI del receptor: deja una sola banda lateral.], [#ver(<sec-cristal>)],
    _i2c-n(5), [VFO o PLL], [El mismo oscilador local del receptor.], [#ver(<sec-oscilador>)],
    _i2c-n(6), [Mezclador], [Anillo de diodos o SA612: lleva los 9 MHz a la frecuencia de trabajo.], [#ver(<sec-mezclador>)],
    _i2c-n(7), [Filtro paso banda], [Tanques acoplados: deja la suma (o la diferencia) que interesa y quita la otra y los restos.], [#ver(<sec-resonancia>)],
    _i2c-n(8), [Excitador y final], [Amplificadores *lineales* de clase A y AB, sintonizados o de banda ancha.], [#ver(<sec-clases>), #ver(<sec-amp-sintonizado>)],
    _i2c-n(9), [Filtro paso bajo y red pi], [Red LC en pi: quita los armónicos y adapta la impedancia del final a 50 Ω.], [#ver(<sec-redes-adaptacion>)],
    [—], [Fuente], [13,8 V capaces de dar la corriente de pico del final.], [#ver(<sec-fuente>)],
  )
) <i2c-tab-tx-ssb>

#ptitulo[El transceptor] Fíjate en las tablas: el filtro de cuarzo, el VFO, el oscilador de portadora (que en recepción hace de BFO) y los mezcladores aparecen en las dos. Un *transceptor* los comparte: un relé o unos diodos de conmutación, gobernados por el pulsador del micrófono (PTT), cambian el sentido del recorrido. Por eso transmites exactamente en la frecuencia que escuchas.

#idea[Un receptor y un transmisor de radio son cadenas de los mismos cinco o seis circuitos básicos: tanques LC, amplificadores, osciladores, mezcladores, detectores o moduladores y fuente. Cuando reconozcas cada bloque, cualquier diagrama del examen se lee como un mapa.]

=== Un receptor completo que puedes montar

La @i2c-fig-conv-directa es un receptor completo, de los que los radioaficionados montan en una tarde: un *receptor de conversión directa* para la banda de 40 m. Es un superheterodino al que le falta la FI: el oscilador local está en la misma frecuencia que la señal, y la diferencia que sale del mezclador ya es audio. El mezclador hace a la vez de detector de producto, y el oscilador local, de BFO.

#circuito(caption: [Receptor de conversión directa para 40 m. Tanque de entrada $L_1$–$C_1$ (unos 5 μH y 100 pF: 7,1 MHz), mezclador y oscilador en un SA612 (alimentado a +6 V, por ejemplo con un regulador 78L06 desde los 12 V), oscilador Colpitts con su tanque $L_2$–$C_V$ en las patas 6 y 7, filtro paso bajo $C_f$ (33 nF) y amplificador de audio LM386 (patas 6 a +12 V y 4 a masa, no dibujadas). Valores orientativos.])[
  #esquema(escala: 0.95, {
    import zap: *
    import cetz.draw: content, line, rect
    // antena y tanque de entrada
    antenna("ant", (0, 3.2))
    capacitor("ca", (0, 3.2), (1.2, 3.2), label: $C_a$)
    wire((1.2, 3.2), (4.6, 3.2))
    inductor("l1", (1.6, 3.2), (1.6, 0.6), label: (content: $L_1$, anchor: "south"))
    ground("gl1", (1.6, 0.6))
    capacitor("c1", (2.5, 3.2), (2.5, 0.6), variable: true, label: $C_1$)
    ground("gc1", (2.5, 0.6))
    capacitor("ce", (2.9, 3.2), (4.1, 3.2), label: $C_e$)
    zap.node("n1", (1.6, 3.2))
    zap.node("n2", (2.5, 3.2))
    // SA612
    rect((4.6, 0.8), (7.6, 4.0), fill: col.gris-claro, stroke: 0.8pt)
    content((6.1, 3.65), text(size: 7.5pt, weight: "bold")[SA612])
    content((6.1, 2.5), text(size: 12pt)[$times$])
    content((6.5, 1.25), text(size: 7pt)[osc.])
    for (t, pt, an) in (([1], (4.7, 3.35), "west"), ([2], (4.7, 2.15), "west"), ([4], (7.5, 3.35), "east"), ([5], (7.5, 2.15), "east"), ([3], (5.0, 0.9), "south"), ([6], (6.0, 0.9), "south"), ([7], (7.0, 0.9), "south"), ([8], (7.0, 3.9), "north")) {
      content(pt, anchor: an, text(size: 6.5pt)[#t])
    }
    // pata 2 a masa por C_p
    wire((4.6, 2.0), (3.6, 2.0))
    capacitor("cp", (3.6, 2.0), (3.6, 0.6), label: $C_p$, width: 0.5)
    ground("gcp", (3.6, 0.6))
    // pata 3 a masa
    ground("g3", (5.0, 0.8))
    // pata 8
    wire((7.0, 4.0), (7.0, 4.5))
    content((7.0, 4.55), anchor: "south", _i2c-t[+6 V])
    // oscilador: patas 6 y 7
    wire((6.0, 0.8), (6.0, -0.6))
    wire((7.0, 0.8), (7.0, -0.6))
    capacitor("co1", (6.0, -0.6), (7.0, -0.6), label: $C_2$)
    capacitor("co2", (7.0, -0.6), (7.0, -2.0), label: $C_3$)
    ground("gco2", (7.0, -2.0))
    capacitor("cb", (5.0, -0.6), (6.0, -0.6), label: (content: $C_B$, anchor: "south"))
    wire((5.0, -0.6), (3.0, -0.6))
    inductor("l2", (4.2, -0.6), (4.2, -2.0), label: $L_2$)
    ground("gl2", (4.2, -2.0))
    capacitor("cvo", (3.0, -0.6), (3.0, -2.0), variable: true, label: (content: $C_V$, anchor: "south"))
    ground("gcv", (3.0, -2.0))
    zap.node("n3", (6.0, -0.6))
    zap.node("n4", (7.0, -0.6))
    zap.node("n5", (4.2, -0.6))
    // salida: pata 4, paso bajo, LM386
    wire((7.6, 3.2), (9.6, 3.2))
    wire((7.6, 2.0), (7.9, 2.0))
    capacitor("cf", (8.4, 3.2), (8.4, 1.8), label: $C_f$)
    ground("gcf", (8.4, 1.8))
    zap.node("n6", (8.4, 3.2))
    capacitor("cac", (8.8, 3.2), (9.9, 3.2), label: $C_"ac"$)
    opamp("op", (11.0, 2.75), invert: true)
    content((11.0, 3.85), anchor: "south", _i2c-t[LM386])
    wire((9.9, 3.2), "op.plus")
    wire("op.minus", (9.8, 2.3))
    ground("gm", (9.8, 2.3))
    pcapacitor("co", (11.9, 2.75), (13.0, 2.75), label: $C_"sal"$)
    wire((13.0, 2.75), (13.4, 2.75))
    altavoz("aur", (13.4, 2.75), (13.4, 1.2))
    ground("gaur", (13.4, 1.2))
    content((13.85, 2.0), anchor: "west", _i2c-t[auricular])
  })
] <i2c-fig-conv-directa>

#porque(titulo: [el receptor de conversión directa, de la antena a la oreja])[
  - *$C_a$ y el tanque $L_1$–$C_1$* eligen la banda de 40 m y frenan las emisoras de radiodifusión fuertes que podrían saturar el mezclador. $C_a$, pequeño, acopla la antena sin cargar demasiado el tanque.
  - *$C_e$* lleva la señal a la pata 1 sin tocar su continua (el SA612 polariza sus entradas por dentro); $C_p$ pone la pata 2, la otra entrada, a masa para la RF.
  - *El oscilador* es el Colpitts de la @i2c-fig-colpitts-real, con el transistor dentro del chip: base en la pata 6, emisor en la 7, colector a la alimentación. $C_2$ (de base a emisor) y $C_3$ (de emisor a masa) son el divisor capacitivo; $L_2$ y el variable $C_V$, unidos por $C_B$, son el tanque y el dial.
  - *La célula de Gilbert* multiplica la señal por el oscilador local. Si escuchas una emisora de CW en 7,030 MHz con el oscilador en 7,0293 MHz, a la salida aparece un tono de 700 Hz (y una suma de 14 MHz que no interesa).
  - *$C_f$* forma, con la resistencia de salida del SA612 (1,5 kΩ), un paso bajo de unos 3 kHz: deja la voz y quita la suma y los restos de RF, como el RC del detector de #ver(<sec-detector>).
  - *El LM386* es un amplificador de audio integrado: ganancia 20 tal cual, 200 con un condensador de 10 μF entre sus patas 1 y 8. $C_"sal"$ (220 μF) entrega el audio al auricular sin la continua de su salida.
]

#ptitulo[Sus límites] Como no hay FI, toda la selectividad la pone el paso bajo de audio, y el receptor oye a la vez las dos bandas laterales: una emisora 1 kHz por encima del oscilador local y otra 1 kHz por debajo dan el mismo tono. Necesita además mucha ganancia de audio (de 80 a 100 dB para las señales débiles), que se consigue con un preamplificador antes del LM386. Por eso los receptores serios añaden la FI y su filtro de cuarzo, que es exactamente el paso de la @i2c-fig-radio a la @i2c-fig-superhet.

#ejercicio(sol: [Con el oscilador por encima, $f_"OL" = 3,7 + 0,455 = 4,155 "MHz"$; la imagen está en $3,7 + 2 dot 0,455 = 4,61 "MHz"$. Con FI de 9 MHz y oscilador por encima, la imagen se va a $3,7 + 18 = 21,7 "MHz"$, mucho más fácil de rechazar con el preselector.])[Un receptor superheterodino con FI de 455 kHz y oscilador local por encima de la señal está sintonizado en 3,7 MHz. ¿En qué frecuencia está el oscilador local? ¿Y la imagen? ¿Dónde quedaría la imagen con una FI de 9 MHz?]

#ejercicio(sol: [La capacidad serie es $470 dot 470 slash 940 = 235 "pF"$. $f_0 = 1 slash (2 pi sqrt(2\,2 dot 10^(-6) dot 235 dot 10^(-12))) = 1 slash (2 pi dot 2,27 dot 10^(-8)) approx 7,0 "MHz"$: banda de 40 m.])[Un oscilador Colpitts tiene $L = 2,2 thin mu"H"$ y $C_1 = C_2 = 470 "pF"$. ¿En qué frecuencia oscila, aproximadamente?]

#ejercicio(sol: [Su periodo es $1 slash 9 "MHz" approx 0,11 thin mu"s"$, y $R C = 10^4 dot 3,3 dot 10^(-9) = 33 thin mu"s"$, unos 300 periodos: sobra para no dejar pasar la RF y sigue siendo menor que los 40 μs que admite la voz hasta 3 kHz. El mismo RC vale. Lo que cambia es que a 9 MHz bastaría un condensador más pequeño.])[El detector de la @i2c-fig-det-env (RC = 33 μs) se usa ahora tras una FI de 9 MHz en lugar de 455 kHz. ¿Sigue sirviendo el mismo RC? Razónalo con los dos periodos.]

#ejercicio(sol: [Un transmisor de SSB callado no emite nada: el modulador equilibrado solo entrega productos de la portadora por el audio, y sin audio el producto es cero. Uno de AM emite la portadora completa aunque nadie hable.])[¿Qué potencia emite un transmisor de SSB mientras el operador no habla? ¿Y uno de AM? ¿Por qué?]

#ptitulo[Y de aquí, al temario] Esta radio mínima es el mapa para todo lo que viene. El tema T2 pregunta por cada componente de este capítulo, uno a uno; el T3, por las combinaciones — fuentes, filtros, amplificadores, osciladores, detectores — que aquí has visto trabajar juntas; el T4 monta con estos mismos bloques el receptor superheterodino del capítulo anterior (añade el mezclador: un oscilador y una etapa no lineal, #ver(<sec-mezclador>)); el T5, el transmisor, que es esta cadena recorrida al revés con el oscilador de #ver(<sec-oscilador>) como corazón. Cuando un esquema del examen te intimide, vuelve a la @i2c-fig-radio y busca las dos corrientes: la ámbar que baja y la azul que cruza. Siempre están.
