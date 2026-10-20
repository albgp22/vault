#import "/lib/template.typ": *
#import "/lib/falstad-custom.typ": fc
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Utilidades locales de intro-2a (prefijo _i2a-)
// ---------------------------------------------------------------------
// Colores del capítulo: la continua en ámbar (col.ambar), la señal en azul (col.senal1).

// Flecha de corriente coloreada con etiqueta opcional.
#let _i2a-flecha(a, b, color: col.ambar, etq: none, anchor: "south", dist: 2pt) = {
  import cetz.draw: line, content
  line(a, b, stroke: 0.9pt + color, mark: (end: ">", fill: color, scale: 0.55))
  if etq != none {
    content((a, 50%, b), anchor: anchor, padding: dist, text(size: 7pt, fill: color, etq))
  }
}

// Texto pequeño para rótulos de figuras.
#let _i2a-t(c, color: col.tinta, size: 7.5pt) = text(size: size, fill: color, c)

El capítulo anterior siguió a la señal desde el micrófono hasta el altavoz sin abrir la tapa de los equipos. Este capítulo la abre. Vamos a construir, pieza a pieza, una radio sencilla pero completa —~sintonía, amplificador de RF, detector, amplificador de audio y la fuente de alimentación que lo sostiene todo~— deteniéndonos en cada componente el tiempo que haga falta para entender _qué hace con la corriente que lo atraviesa_ y por qué está donde está. Los temas T2 y T3 vuelven después sobre cada pieza con el detalle y las preguntas del examen; el objetivo de este capítulo es otro: que al llegar a la última sección seas capaz de mirar el esquema completo de la radio y seguir cada corriente con el dedo, sabiendo qué está haciendo en cada tramo.

#nota[En casi todos los circuitos de este capítulo conviven _dos_ corrientes superpuestas en los mismos cables: la *continua* de alimentación, que pone a cada componente en su punto de trabajo, y la *señal*, el pequeño vaivén que transporta la información. Cuando las dibujemos, la continua irá siempre en #text(fill: col.ambar, weight: "bold")[ámbar] y la señal en #text(fill: col.senal1, weight: "bold")[azul]. Separarlas mentalmente es la mitad de saber leer un esquema.]

== El plano de trabajo y cómo leer un esquema <sec-esquemas>

#ptitulo[Nuestra radio] Trabajaremos sobre el receptor de la @i2a-fig-radio: un receptor de _radiofrecuencia sintonizada_ (TRF, del _tuned radio frequency_), a veces llamado de _amplificación directa_ —~no lo confundas con el receptor de _conversión directa_ que aparecerá en T4, que es otro esquema~—, el más sencillo que suena bien. Un circuito sintonizado elige la emisora entre todo lo que entrega la antena; un transistor amplifica esa señal de RF, todavía diminuta; un diodo extrae la envolvente —~la voz~—; otro transistor la amplifica hasta mover un auricular; y una fuente de alimentación convierte la red de 230 V en la tensión continua que los transistores necesitan. No es el superheterodino del capítulo anterior (no hay mezclador ni FI), pero contiene _todos_ los componentes del temario trabajando, y esa es su virtud: cada sección de este capítulo tomará una de estas piezas y la abrirá en canal.

#circuito(caption: [La radio de trabajo de este capítulo, en bloques. En azul, el camino de la señal; en ámbar, la alimentación continua —~los +12 V que fija el estabilizador de la fuente, #ver(<sec-fuente>)~— repartida a las etapas activas. Cada bloque se abrirá en las secciones siguientes hasta llegar al esquema completo, componente a componente, de #ver(<sec-radio-entera>).])[
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (7mm, 9mm),
    node((0, 0), text(size: 8pt)[antena], stroke: none, name: <ant>),
    node((1, 0), align(center, text(size: 8pt)[tanque LC \ (sintonía)]), shape: rect, inset: 5pt, name: <tq>),
    node((2, 0), align(center, text(size: 8pt)[amplificador \ de RF]), shape: rect, inset: 5pt, name: <arf>),
    node((3, 0), align(center, text(size: 8pt)[detector \ de diodo]), shape: rect, inset: 5pt, name: <det>),
    node((4, 0), align(center, text(size: 8pt)[amplificador \ de BF]), shape: rect, inset: 5pt, name: <abf>),
    node((5, 0), text(size: 8pt)[auricular], stroke: none, name: <aur>),
    node((2.5, 1.25), align(center, text(size: 8pt)[fuente de \ alimentación]), shape: rect, inset: 5pt, fill: col.ambar-claro, name: <fte>),
    node((1, 1.25), text(size: 8pt)[red 230 V∼], stroke: none, name: <red>),
    edge(<ant>, <tq>, "-|>", stroke: 0.9pt + col.senal1),
    edge(<tq>, <arf>, "-|>", stroke: 0.9pt + col.senal1),
    edge(<arf>, <det>, "-|>", stroke: 0.9pt + col.senal1),
    edge(<det>, <abf>, "-|>", stroke: 0.9pt + col.senal1),
    edge(<abf>, <aur>, "-|>", stroke: 0.9pt + col.senal1),
    edge(<red>, <fte>, "-|>", stroke: 0.7pt),
    edge(<fte>, <arf>, "-|>", stroke: 0.9pt + col.ambar, label: text(size: 7pt, fill: col.ambar)[+12 V], label-side: left),
    edge(<fte>, <abf>, "-|>", stroke: 0.9pt + col.ambar, label: text(size: 7pt, fill: col.ambar)[+12 V], label-side: right),
  )
] <i2a-fig-radio>

#motivacion(titulo: [cada pieza está ahí porque resuelve un problema])[
  Un esquema intimida porque parece un montón de símbolos sin orden. No lo es: cada componente está puesto para resolver un problema concreto de la radio, y casi siempre el mismo problema en todos los equipos. Si al mirar un componente te preguntas _«¿qué problema arregla aquí?»_, el esquema se ordena solo. La @i2a-tab-mapa es el mapa del capítulo: el problema que resuelve cada pieza y la sección donde la abrimos.
]

#figure(
  table(
    columns: (auto, 3fr, 2fr),
    align: (left, left, left),
    [*Pieza*], [*Problema de la radio que resuelve*], [*Dónde*],
    [Resistencia], [Desde un único raíl de +12 V, fijar la corriente de cada camino y fabricar las tensiones intermedias que pide cada etapa.], [#ver(<sec-resistencia>)],
    [Condensador], [Pasar la señal de una etapa a la siguiente _sin_ su continua; tirar a masa la RF que sobra; guardar energía entre las crestas de la red.], [#ver(<sec-condensador>)],
    [Bobina], [Dejar pasar la continua y frenar la RF; junto con un condensador, quedarse con _una_ emisora entre cientos.], [#ver(<sec-bobina>)],
    [Transformador], [Bajar los 230 V de la red, aislar la radio de la red y cambiar impedancias.], [#ver(<sec-transformador>)],
    [Diodo], [Convertir la alterna en continua, sacar la voz de la RF (detector) y clavar una tensión (zéner).], [#ver(<sec-diodo>)],
    [Redes L, pi y T], [Entregar toda la potencia a una antena que no es de 50 Ω y, de paso, quitar los armónicos.], [#ver(<sec-redes-adaptacion>)],
    [Transistor], [Amplificar: convertir los microvoltios de la antena en los voltios que mueven el auricular.], [#ver(<sec-transistor>)],
  ),
  caption: [Mapa del capítulo: una pieza, un problema.],
) <i2a-tab-mapa>

#ptitulo[Las reglas del esquema] Antes de abrir el primer bloque, cuatro convenios que convierten cualquier esquema en legible:

- *La corriente siempre vuelve.* No existe corriente sin circuito _cerrado_: todo amperio que sale del terminal positivo de la fuente regresa al negativo. Si al seguir una corriente no encuentras el camino de vuelta, no has terminado de leer.
- *Masa* es el punto de referencia común (0 V) y, a la vez, el camino de retorno que comparten todas las etapas: en lugar de dibujar docenas de cables de vuelta, cada uno se conecta al símbolo de masa y se sobreentiende que todos son el mismo nudo (el chasis, en un equipo real).
- *Los raíles*: los esquemas se dibujan con la alimentación positiva como una línea horizontal arriba y masa abajo, de modo que la corriente continua «cae» de arriba a abajo a través de cada etapa. Las señales, mientras tanto, viajan de izquierda a derecha.
- *Un punto es un nudo*: dos cables que se cruzan _con_ punto están conectados; sin punto, simplemente pasan uno sobre otro (lo verás en el puente rectificador de #ver(<sec-fuente>)).

#circuito(caption: [Los convenios, dibujados. Izquierda: el raíl de +12 V arriba y masa abajo; la continua (ámbar) cae por cada etapa y la señal (azul) avanza de izquierda a derecha; los tres símbolos de masa son un mismo cable. Derecha: un cruce con punto es una conexión; un cruce sin punto (o con el pequeño salto) no lo es.])[
  #grid(
    columns: (auto, auto),
    column-gutter: 1.2cm,
    align: horizon,
    esquema({
      import zap: *
      import cetz.draw: content, line
      wire((0, 3), (6, 3))
      content((6.1, 3), anchor: "west", _i2a-t[+12 V])
      for (i, x) in (1, 3, 5).enumerate() {
        resistor("r" + str(i), (x, 3), (x, 0.5), label: _i2a-t[etapa #(i + 1)])
        ground("g" + str(i), (x, 0.5))
        node("n" + str(i), (x, 3))
        _i2a-flecha((x - 0.35, 2.4), (x - 0.35, 1.1), color: col.ambar)
      }
      _i2a-flecha((0.4, -0.6), (5.6, -0.6), color: col.senal1, etq: [señal: de izquierda a derecha], anchor: "north")
      content((3, 3.35), anchor: "south", _i2a-t(color: col.ambar)[la continua cae de arriba abajo])
    }),
    esquema({
      import zap: *
      import cetz.draw: content, line, arc
      // cruce con punto: conectado
      wire((0, 2.6), (2, 2.6))
      wire((1, 3.4), (1, 1.8))
      node("a", (1, 2.6))
      content((1, 1.5), anchor: "north", _i2a-t[conectados])
      // cruce sin punto: no conectado
      wire((3, 2.6), (5, 2.6))
      wire((4, 3.4), (4, 1.8))
      content((4, 1.5), anchor: "north", _i2a-t[no conectados])
      // cruce con salto
      wire((0, 0.3), (0.82, 0.3))
      arc((0.82, 0.3), start: 180deg, stop: 0deg, radius: 0.18, stroke: 0.6pt)
      wire((1.18, 0.3), (2, 0.3))
      wire((1, 1.1), (1, -0.5))
      content((3.6, 0.3), anchor: "center", _i2a-t[salto: tampoco \ conectados])
    }),
  )
] <i2a-fig-convenios>

#ptitulo[Los símbolos] La @i2a-fig-simbolos reúne los símbolos que usa este capítulo. Ya los conoces casi todos de nombre; aquí aprenderás qué hace cada uno con la corriente.

#let _i2a-celda(nombre, dibujo) = align(center, stack(spacing: 4pt, box(height: 1.5cm, align(center + horizon, esquema(dibujo))), _i2a-t(size: 7pt, nombre)))

#circuito(caption: [Los símbolos de este capítulo. El electrolítico tiene polaridad: su placa curva va al lado negativo. La flecha del diodo apunta en el sentido en que _sí_ deja pasar la corriente convencional, hacia el cátodo.])[
  #grid(
    columns: 6,
    column-gutter: 0.35cm,
    row-gutter: 0.4cm,
    _i2a-celda([resistencia], { import zap: *; resistor("r", (0, 0), (2, 0)) }),
    _i2a-celda([condensador], { import zap: *; capacitor("c", (0, 0), (1.6, 0)) }),
    _i2a-celda([electrolítico], {
      import zap: *
      import cetz.draw: content
      pcapacitor("c", (0, 0), (1.6, 0))
      content((1.05, 0.45), _i2a-t(size: 7pt)[+])
    }),
    _i2a-celda([condensador variable], { import zap: *; capacitor("c", (0, 0), (1.6, 0), variable: true) }),
    _i2a-celda([bobina], { import zap: *; inductor("l", (0, 0), (2, 0)) }),
    _i2a-celda([transformador], { import zap: *; trafo("t", (0, 0), espiras: (3, 3)) }),
    _i2a-celda([diodo], {
      import zap: *
      import cetz.draw: content
      diode("d", (0, 0), (1.8, 0))
      content((0.1, 0.3), _i2a-t(size: 6pt)[ánodo])
      content((1.7, 0.3), _i2a-t(size: 6pt)[cátodo])
    }),
    _i2a-celda([diodo zéner], { import zap: *; zener("d", (0, 0), (1.8, 0)) }),
    _i2a-celda([LED], { import zap: *; led("d", (0, 0), (1.8, 0)) }),
    _i2a-celda([transistor NPN], { import zap: *; npn("q", (0, 0)) }),
    _i2a-celda([masa], { import zap: *; import cetz.draw: line; line((0, 0.5), (0, 0), stroke: 0.6pt); ground("g", (0, 0)) }),
    _i2a-celda([antena], { import zap: *; antenna("a", (0, 0)) }),
  )
] <i2a-fig-simbolos>

== La resistencia: frenar y repartir <sec-resistencia>

#motivacion[
  La fuente de nuestra radio da _una sola_ tensión: +12 V. Pero el LED piloto quiere 10 mA y se quema con más; la base de cada transistor quiere estar a unos 2 V, no a 12; el colector necesita una corriente concreta y no otra. Hace falta una pieza que, desde ese único raíl, *fije cuánta corriente pasa por cada camino* y *fabrique las tensiones intermedias*. Esa pieza es la resistencia, y por eso es el componente más abundante de cualquier esquema.
]

#ptitulo[Qué le pasa a la corriente por dentro] Un conductor es una red de iones fijos bañada en un mar de electrones libres. Al aplicar tensión, los electrones son empujados y avanzan… a trompicones: chocan sin parar con la red, ceden en cada choque la energía que acababan de ganar, y esa energía queda en el material como vibración —~calor. Eso es una resistencia: fricción eléctrica. Dos sorpresas útiles: los electrones avanzan lentísimos (fracciones de milímetro por segundo), pero la corriente se establece en todo el circuito casi a la velocidad de la luz, porque el empujón —~el campo~— se propaga por el cable como el golpe por un tubo lleno de canicas: la canica que entra por un extremo hace salir _otra_ por el opuesto al instante. Y como el frenado es proporcional al empujón, corriente y tensión guardan proporción fija: la ley de Ohm, $V = I R$, con la potencia disipada $P = V I = I^2 R$ convertida íntegra en calor.

#analogia[
  Piensa en una tubería con un tramo estrechado. La presión del depósito (la tensión) empuja el agua; el estrechamiento (la resistencia) decide el caudal (la corriente): más estrecho, menos caudal para la misma presión. Y toda la presión «se gasta» en el estrechamiento: a la salida queda menos. Por eso una resistencia sirve para dos cosas, que son los dos oficios de esta sección: *limitar el caudal* y *repartir la presión*.
]

#ptitulo[Sub-circuito 1: la limitadora] El empleo más simple de una resistencia es _proteger_: fijar cuánta corriente va a circular por un camino. En la @i2a-fig-resistencia (izquierda), un LED —~que necesita unos 10 mA y cae unos 2 V, #ver(<sec-diodo>)~— se conecta a una batería de 12 V. Directamente se destruiría; con la resistencia en serie, la corriente queda decidida por ella: en la malla, la resistencia se lleva $12 - 2 = 10$ V, y para que circulen 10 mA hace falta $R = 10 slash 0,01 = 1$ kΩ. Sigue la corriente en ámbar: sale del polo positivo, atraviesa resistencia y LED (los mismos 10 mA por ambos: están en serie) y vuelve a la batería. Un solo bucle, una sola corriente —~la _convencional_, que por convenio va de + a − aunque los electrones viajen justo al revés; salvo aviso, es la que usaremos en todo el libro.

#ptitulo[Sub-circuito 2: el divisor] El segundo empleo es _repartir_: fabricar, a partir del raíl de alimentación, una tensión intermedia. Dos resistencias en serie entre +12 V y masa (@i2a-fig-resistencia, derecha) son atravesadas por la misma corriente, y cada una se queda la parte de tensión proporcional a su valor: en el nudo central aparece
$ V = 12 dot R_2 / (R_1 + R_2) = 12 dot 10 / (47 + 10) approx 2,1 "V". $
La corriente que baja en ámbar por el divisor, $12 slash 57 thin 000 approx 0,21$ mA, no «hace» nada —~se gasta entera en mantener ese nudo a 2,1 V~— y ese es precisamente su oficio: cuando el transistor de #ver(<sec-polarizacion>) necesite su base sostenida a 2,1 V, será este divisor quien la sostenga.

#ojo[Un divisor solo mantiene su tensión si lo que se conecta al nudo central pide _poca_ corriente comparada con la que baja por él. Si la carga chupa una corriente comparable, la tensión del nudo se hunde. La regla práctica del diseñador: por el divisor debe circular al menos diez veces la corriente que tomará la carga. Guarda esta idea para el amplificador de #ver(<sec-polarizacion>).]

#circuito(caption: [Los dos oficios de la resistencia. Izquierda: limitadora —~la resistencia decide la corriente del bucle (10 mA) y protege al LED; fíjate en que la corriente es la misma en todos los puntos del lazo, incluida la vuelta a la batería. Derecha: divisor —~dos resistencias reparten los 12 V en proporción a su valor y fabrican los 2,1 V que necesitará la base del transistor de #ver(<sec-polarizacion>).], sim: "voltdivide.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    // --- limitadora ---
    bateria("b", (0, 2.4), (0, 0), label: (content: [12 V], anchor: "south"))
    wire((0, 2.4), (0.9, 2.4))
    resistor("r", (0.9, 2.4), (3.1, 2.4), label: (content: $R = 1 "kΩ"$, anchor: "south"))
    wire((3.1, 2.4), (4, 2.4))
    led("d", (4, 2.4), (4, 0), label: (content: [LED], anchor: "south"))
    wire((4, 0), (0, 0))
    _i2a-flecha((1.4, 2.8), (2.6, 2.8), etq: [10 mA])
    _i2a-flecha((4.75, 1.5), (4.75, 0.7))
    _i2a-flecha((2.6, -0.3), (1.4, -0.3), etq: [la misma corriente vuelve], anchor: "north")
    // --- divisor ---
    node("vcc", (7.5, 3.4), fill: false, label: (content: [+12 V], anchor: "north"))
    resistor("r1", (7.5, 3.4), (7.5, 1.6), label: $R_1 space 47 "kΩ"$)
    resistor("r2", (7.5, 1.6), (7.5, -0.2), label: $R_2 space 10 "kΩ"$)
    ground("g", (7.5, -0.2))
    node("m", (7.5, 1.6))
    wire((7.5, 1.6), (9.4, 1.6))
    node("o", (9.4, 1.6), fill: false, label: (content: [2,1 V], anchor: "east"))
    _i2a-flecha((7.0, 3.0), (7.0, 2.0), etq: [0,21 mA], anchor: "east")
  })
] <i2a-fig-resistencia>

#porque[
  - *Limitadora.* La batería pone 12 V en el bucle. El LED, como todo diodo, se queda una tensión casi fija (unos 2 V) sea cual sea la corriente; la resistencia se lleva el resto, 10 V, y con ellos la ley de Ohm fija la corriente: $I = 10 "V" slash 1 "kΩ" = 10$ mA. Sin la resistencia, nada limitaría la corriente salvo la resistencia interna de la batería: cientos de miliamperios, y el LED se funde en un instante.
  - *Divisor.* $R_1$ y $R_2$ están en serie: la misma corriente (0,21 mA) atraviesa las dos. $R_2$ es 10/57 de la resistencia total y se queda 10/57 de los 12 V. Eliges la tensión del nudo eligiendo el _cociente_ de las dos resistencias: con $R_2 = 22$ kΩ el nudo sube a $12 dot 22 slash 69 approx 3,8$ V.
]

#ejemplo(titulo: [el divisor que se hunde])[
  Conecta al nudo de 2,1 V una carga de 10 kΩ. Ahora, por debajo del nudo, hay $R_2$ en paralelo con la carga: $10 "kΩ" parallel 10 "kΩ" = 5$ kΩ, y el nudo cae a $12 dot 5 slash (47 + 5) approx 1,15$ V. La carga pedía unos 0,2 mA, tanto como el propio divisor: se rompe la regla del diez. Con una carga de 1 MΩ, en cambio, el paralelo vale 9,9 kΩ y el nudo apenas se mueve (2,09 V). La base de un transistor pide poco, pero no nada: por eso el divisor de polarización se calcula para que su corriente sea unas diez veces la de base.
]

#ptitulo[Sub-circuito 3: la carga y la polarización] Los dos oficios básicos se combinan en la pieza central de la radio, la etapa amplificadora (@i2a-fig-etapa). El transistor (lo abrimos en #ver(<sec-transistor>)) es un grifo de corriente: deja pasar entre colector y emisor una corriente que sigue a la señal. Pero la etapa siguiente necesita una _tensión_ que varíe, no una corriente. Una resistencia de *carga* $R_C$ entre el raíl y el colector hace la conversión: la tensión del colector es $V_C = 12 - I_C R_C$, y si $I_C$ sube y baja, $V_C$ baja y sube. Con $R_C = 4,7$ kΩ, una variación de corriente de ±0,5 mA se convierte en ±2,35 V de señal. Alrededor, otras tres resistencias: el divisor $R_1$–$R_2$ de antes, que *polariza* la base a 2,1 V, y $R_E$, que fija la corriente de reposo como una limitadora.

#circuito(caption: [Las cuatro resistencias de una etapa amplificadora. El divisor $R_1$–$R_2$ sostiene la base a 2,1 V (polarización); $R_E$ fija la corriente de reposo, 1 mA; $R_C$ es la carga que convierte las variaciones de corriente del colector en variaciones de tensión. En ámbar, la continua que baja del raíl; en azul, la señal de salida en el colector.], sim: "ceamp.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    wire((0, 5), (5.2, 5))
    content((5.3, 5), anchor: "west", _i2a-t[+12 V])
    wire((0, -0.2), (5.2, -0.2))
    content((5.3, -0.2), anchor: "west", _i2a-t[masa])
    resistor("r1", (1, 5), (1, 2.4), label: (content: $R_1 space 47 "kΩ"$, anchor: "south"))
    resistor("r2", (1, 2.4), (1, -0.2), label: (content: $R_2 space 10 "kΩ"$, anchor: "south"))
    node("n1", (1, 5))
    node("n2", (1, -0.2))
    node("nb", (1, 2.4))
    npn("q", (3.2, 2.4))
    wire((1, 2.4), "q.b")
    resistor("rc", (3.2, 5), (3.2, 3.6), label: $R_C space 4,7 "kΩ"$)
    wire((3.2, 3.6), "q.c")
    resistor("re", (3.2, 1.2), (3.2, -0.2), label: $R_E space 1,5 "kΩ"$)
    wire("q.e", (3.2, 1.2))
    node("n3", (3.2, 5))
    node("n4", (3.2, -0.2))
    node("nc", (3.2, 3.6))
    wire((3.2, 3.6), (4.8, 3.6))
    node("o", (4.8, 3.6), fill: false)
    content((1.6, 2.65), anchor: "south", _i2a-t(color: col.ambar)[2,1 V])
    content((3.7, 3.25), anchor: "west", _i2a-t(color: col.ambar)[7,3 V])
    content((2.75, 1.2), anchor: "east", _i2a-t(color: col.ambar)[1,5 V])
    _i2a-flecha((2.75, 4.7), (2.75, 3.9), etq: [1 mA], anchor: "east")
    // señal en el colector
    cetz.draw.group({
      cetz.draw.translate((5.2, 3.6))
      onda(x => 0.25 * calc.sin(x * 2 * calc.pi / 0.8), 0, 1.6, stroke: 0.9pt + col.senal1)
    })
    content((6, 3.05), anchor: "north", _i2a-t(color: col.senal1)[salida])
  })
] <i2a-fig-etapa>

#porque[
  - $R_1$ y $R_2$ forman el divisor: la base queda a 2,1 V. La base pide poca corriente, así que el nudo no se hunde (la regla del diez).
  - El emisor está unos 0,6 V por debajo de la base (el peaje del diodo base-emisor, #ver(<sec-diodo>)): 1,5 V. Sobre $R_E = 1,5$ kΩ eso fija $I_E = 1$ mA. $R_E$ es una limitadora: decide la corriente de reposo, y la decide aunque el transistor se caliente o se cambie por otro.
  - Casi toda esa corriente sube por el colector y cruza $R_C$: cae $1 "mA" dot 4,7 "kΩ" = 4,7$ V, y el colector queda a $12 - 4,7 = 7,3$ V, a medio camino entre el raíl y masa. Desde ahí la señal puede subir y bajar sin chocar con ninguno de los dos.
  - Sin $R_C$ el colector estaría pegado a +12 V: la corriente variaría, pero la tensión no, y no habría señal que pasar a la etapa siguiente.
  Los detalles (por qué 2,1 V y no otro valor, cuánto amplifica) están en #ver(<sec-polarizacion>) y #ver(<sec-amplificador-ec>).
]

#ptitulo[La potencia: el tamaño de la resistencia] Toda la potencia $P = I^2 R$ se convierte en calor, y la resistencia tiene que poder evacuarlo. Por eso cada resistencia tiene, además de su valor en ohmios, una *potencia máxima*: 1/4 W para las pequeñas de un receptor, varios vatios para las de una fuente. En el transmisor la resistencia toma su papel más grande: la *carga artificial*, una resistencia de 50 Ω que sustituye a la antena para hacer pruebas sin radiar. Recibe toda la potencia del equipo y la convierte en calor.

#ejemplo[
  La limitadora de la @i2a-fig-resistencia disipa $P = 10 "V" dot 10 "mA" = 0,1$ W: una resistencia de 1/4 W va sobrada. Una carga artificial para un transmisor de 100 W tiene que disipar 100 W; en sus bornes hay $V = sqrt(P R) = sqrt(100 dot 50) approx 71$ V eficaces. Por eso es un cilindro con aletas o un bote lleno de aceite, y no una resistencia de las que caben en una placa.
]

== El condensador: el depósito <sec-condensador>

#motivacion[
  En nuestra radio, la señal y la continua viajan por los mismos cables, y eso crea tres problemas. *Uno*: la señal tiene que pasar del colector de una etapa (a 7,3 V) a la base de la siguiente (a 2,1 V) sin que las dos continuas se mezclen. *Dos*: la RF que una etapa deja en el raíl de alimentación no debe llegar a las demás por ese raíl. *Tres*: la fuente entrega la energía a golpes, cien veces por segundo, y la radio la quiere continua. Los tres se resuelven con la misma pieza, que deja pasar lo que cambia y retiene lo constante: el condensador.
]

#ptitulo[Qué le pasa a la corriente por dentro] Dos placas enfrentadas y un aislante en medio. La corriente _jamás_ cruza el aislante; lo que ocurre es más fino: cada electrón que la fuente empuja hacia una placa repele, a través del hueco, a un electrón de la placa opuesta, que sale por el otro terminal. Visto desde el circuito es _como si_ la corriente atravesara el condensador; visto por dentro, es carga acumulándose en una placa y vaciándose de la otra, con un campo eléctrico creciendo en medio —~ahí queda almacenada la energía. La consecuencia es la que explotamos en el capítulo anterior: mientras la tensión _cambia_, hay corriente; cuando la tensión se estanca, la corriente cesa. El condensador conduce el cambio y bloquea lo constante.

#analogia[
  Una tubería cortada por una membrana elástica. El agua no puede cruzar la membrana. Si empujas siempre en el mismo sentido (continua), la membrana se estira un poco y se queda quieta: el caudal se para. Si empujas y tiras alternativamente (alterna), la membrana va y viene, y el agua del otro lado también va y viene: el movimiento pasa aunque el agua no cruce. Y cuanto más rápido es el vaivén, menos tiene que estirarse la membrana en cada ida: el condensador estorba menos a las frecuencias altas.
]

#ptitulo[El transitorio que hay que ver una vez] ¿Qué pasa al conectar un condensador descargado a una batería a través de una resistencia (@i2a-fig-rc)? En el primer instante el condensador está vacío (0 V): toda la tensión cae en $R$ y la corriente arranca al máximo, $V slash R$ —~el condensador se comporta como un cable. Según se llena, su tensión sube, le va quitando tensión a $R$ y la corriente decae. El proceso se autoestrangula: cuanto más lleno, más despacio se llena, en la curva exponencial de la figura. El ritmo lo fija la *constante de tiempo*
$ tau = R C, $
el tiempo en alcanzar el 63 % de la tensión final (a $5 tau$ se da por terminado). Con $R = 10$ kΩ y $C = 100$ μF, $tau = 1$ s: se ve a ojo. Con los valores de un circuito de RF, $tau$ son nanosegundos. Esta curva es la madre de muchas cosas del temario: del filtro de la fuente (#ver(<sec-fuente>)), de la descarga del detector, de los tiempos de un temporizador.

#circuito(caption: [Carga de un condensador a través de una resistencia. Al cerrar el interruptor la corriente arranca al máximo (condensador vacío = cable) y decae según el condensador se llena y «devuelve» tensión. En $t = tau = R C$ la tensión ha cubierto el 63 % del camino; en $5 tau$, prácticamente todo.], sim: "cap.txt")[
  #grid(
    columns: (auto, auto),
    column-gutter: 1cm,
    align: horizon,
    esquema({
      import zap: *
      bateria("b", (0, 2), (0, 0), label: (content: $V$, anchor: "south"))
      wire((0, 2), (0.6, 2))
      switch("s", (0.6, 2), (1.6, 2))
      resistor("r", (1.6, 2), (3.4, 2), label: $R$)
      wire((3.4, 2), (4, 2))
      capacitor("c", (4, 2), (4, 0), label: $C$)
      wire((4, 0), (0, 0))
    }),
    cetz.canvas({
      import cetz.draw: *
      ejes(0, 6.2, 0, 2.6, etq-x: $t$, etq-y: $v_C$)
      line((0, 2), (5.2, 2), stroke: (dash: "dashed", thickness: 0.5pt, paint: col.gris))
      content((-0.1, 2), anchor: "east", text(size: 8pt, $V$))
      onda(x => 2 * (1 - calc.exp(-x / 1)), 0, 5.2, stroke: 1.2pt + col.senal1)
      line((1, 0), (1, 2 * (1 - calc.exp(-1))), stroke: (dash: "dotted", thickness: 0.6pt))
      line((0, 2 * (1 - calc.exp(-1))), (1, 2 * (1 - calc.exp(-1))), stroke: (dash: "dotted", thickness: 0.6pt))
      content((-0.1, 2 * (1 - calc.exp(-1))), anchor: "east", text(size: 7pt)[63 %])
      content((1, -0.1), anchor: "north", text(size: 7.5pt, $tau = R C$))
      content((5, -0.1), anchor: "north", text(size: 7.5pt, $5 tau$))
      line((5, 0), (5, 0.08), stroke: 0.6pt)
    }),
  )
] <i2a-fig-rc>

#porque[
  - Al cerrar el interruptor, el condensador está vacío: entre sus placas hay 0 V, así que los $V$ voltios de la batería caen enteros en $R$ y la corriente vale $V slash R$.
  - Cada culombio que llega sube la tensión del condensador ($v_C = q slash C$). Esa tensión se resta de la de la batería: a $R$ le queda menos, la corriente baja y el llenado se frena.
  - Cuando $v_C = V$, en $R$ no cae nada y la corriente es cero: el condensador cargado es un circuito abierto para la continua.
  - $R$ grande frena la corriente; $C$ grande pide más carga para la misma tensión. Por eso el tiempo de carga va con el producto $R C$.
]

#ejercicio(sol: [$tau = R C = 2200 dot 47 times 10^(-6) approx 0,1$ s; carga completa en $5 tau approx 0,5$ s.])[
  Calcula la constante de tiempo de $C = 47$ μF con $R = 2,2$ kΩ. ¿Cuánto tarda ese condensador en cargarse «del todo» (regla de los $5 tau$)?
]

#ptitulo[Dónde lo verás trabajar] Los tres papeles del condensador en una radio ya salieron en el capítulo anterior —~acoplar etapas (en serie), desacoplar a masa (en paralelo) y formar tanques con una bobina~— y en este capítulo lo verás además en su papel de músculo: el condensador de filtro de la fuente de alimentación (#ver(<sec-fuente>)), un depósito grande que sostiene la tensión entre cresta y cresta de la red. La regla para leerlos en un esquema es siempre la misma pregunta: _¿qué frecuencia pretende dejar pasar o retener este condensador, visto desde donde está puesto?_

#ptitulo[La clave de todos los oficios: la reactancia] Para responder a esa pregunta hace falta un número: cuánto se opone el condensador a una alterna de frecuencia $f$. Es su *reactancia* (#ver(<sec-reactancia>)):
#destacada($ X_C = 1 / (2 pi f C) $, nota: [en ohmios; baja cuando sube la frecuencia o la capacidad])
La @i2a-tab-xc muestra lo que eso significa para un mismo condensador de 10 nF. Para la continua es un circuito abierto; para la red, casi; para la RF de 40 m, un cable. Cada oficio del condensador sale de elegir su valor para que sea «cable» a unas frecuencias y «abierto» a otras. #falstad("capmultfreq.txt", texto: [La reactancia baja con la frecuencia])

#figure(
  table(
    columns: 4,
    align: center,
    [*Frecuencia*], [*0 Hz (continua)*], [*50 Hz (red)*], [*7 MHz (40 m)*],
    [$X_C$ de 10 nF], [infinita], [318 kΩ], [2,3 Ω],
    [Se comporta como], [abierto], [casi abierto], [casi un cable],
  ),
  caption: [Un condensador de 10 nF a tres frecuencias.],
) <i2a-tab-xc>

=== Los oficios del condensador en la radio

#ptitulo[Oficio 1: acoplar] Un condensador en _serie_ entre dos etapas (@i2a-fig-acoplo) deja pasar la señal y bloquea la continua. A la izquierda, el colector de la primera etapa: 7,3 V de continua con la señal encima. A la derecha, la base de la segunda, que su propio divisor mantiene a 2,1 V. El condensador se carga una vez a la diferencia (5,2 V) y se queda así: para la continua es un muro. La señal, que cambia, lo cruza como si fuera un cable, y aparece a la derecha montada sobre los 2,1 V de la segunda etapa.

#circuito(caption: [El condensador de acoplo. La señal (azul) cruza; la continua (ámbar) no: cada etapa conserva su punto de trabajo. Arriba, la tensión a cada lado del condensador: la misma señal montada sobre dos continuas distintas.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line, group, translate
    // tensión a la izquierda
    group({
      translate((0, 2.1))
      ejes(0, 2.4, 0, 1.7, etq-x: $t$, etq-y: $v$)
      line((0, 1.1), (2.2, 1.1), stroke: (dash: "dashed", thickness: 0.5pt, paint: col.ambar))
      onda(x => 1.1 + 0.35 * calc.sin(x * 2 * calc.pi / 1.0), 0, 2.2, stroke: 1pt + col.senal1)
      content((2.3, 1.1), anchor: "west", _i2a-t(color: col.ambar)[7,3 V])
    })
    group({
      translate((5.2, 2.1))
      ejes(0, 2.4, 0, 1.7, etq-x: $t$, etq-y: $v$)
      line((0, 0.4), (2.2, 0.4), stroke: (dash: "dashed", thickness: 0.5pt, paint: col.ambar))
      onda(x => 0.4 + 0.35 * calc.sin(x * 2 * calc.pi / 1.0), 0, 2.2, stroke: 1pt + col.senal1)
      content((2.3, 0.4), anchor: "west", _i2a-t(color: col.ambar)[2,1 V])
    })
    // circuito
    node("i", (0, 1.2), fill: false)
    content((0, 0.9), anchor: "north", _i2a-t[colector \ etapa 1])
    capacitor("c", (0, 1.2), (3.6, 1.2), label: (content: $C_"acoplo"$, anchor: "south"))
    wire((3.6, 1.2), (5.4, 1.2))
    node("o", (5.4, 1.2), fill: false)
    content((5.4, 0.9), anchor: "north", _i2a-t[base \ etapa 2])
    node("m", (4.5, 1.2))
    resistor("r4", (4.5, 1.2), (4.5, -1.2), label: (content: $R_4$, anchor: "south"))
    ground("g", (4.5, -1.2))
  })
] <i2a-fig-acoplo>

#porque[
  - La continua no puede cruzar: el dieléctrico es aislante. Cada lado conserva la suya, y por eso el divisor de la segunda etapa ($R_3$–$R_4$, del que aquí solo se ve $R_4$) no nota el colector de la primera.
  - La señal sí cruza, porque es un _cambio_: cuando el colector sube, empuja carga a la placa izquierda, y la placa derecha expulsa la misma carga hacia la base.
  - El valor se elige para que $X_C$ sea pequeña a la frecuencia de la señal: 10 nF son 2,3 Ω a 7 MHz (un cable para la RF), pero 53 kΩ a 300 Hz. Para audio se usan microfaradios: 10 μF son 53 Ω a 300 Hz.
  - Sin el condensador, el colector (7,3 V) tiraría de la base de la segunda etapa hacia arriba y la sacaría de su punto de trabajo: la segunda etapa se saturaría.
]

#ptitulo[Oficio 2: desacoplar] Un condensador en _paralelo_, de un punto a masa, hace lo contrario: es un atajo a masa para la alterna y no existe para la continua. El caso más común está en el raíl de alimentación (@i2a-fig-desacoplo). Cada etapa toma corriente del raíl, y esa corriente lleva la señal dentro: si nada lo impide, la RF de la segunda etapa viaja por el raíl hasta la primera, se amplifica otra vez, vuelve… y la radio silba u oscila. Un condensador de 100 nF junto a cada etapa (con una resistencia o una bobina pequeña en serie con el raíl) devuelve la RF a masa _allí mismo_, por un camino corto, y el raíl queda limpio. El condensador $C_E$ que verás en el emisor del amplificador (#ver(<sec-amplificador-ec>)) es el mismo oficio: pone el emisor a masa para la señal sin tocar su continua.

#circuito(caption: [Desacoplo del raíl de alimentación. La continua (ámbar) llega a la etapa a través de $R_d$; la corriente de RF que la etapa produce (azul) vuelve a masa por $C_d$, por un camino corto, en lugar de viajar por el raíl hasta las demás etapas.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line, rect
    content((-0.1, 2.5), anchor: "east", _i2a-t[+12 V \ de la fuente])
    wire((0, 2.5), (0.6, 2.5))
    resistor("rd", (0.6, 2.5), (2.6, 2.5), label: (content: $R_d space 100 Omega$, anchor: "south"))
    wire((2.6, 2.5), (5.8, 2.5))
    node("n", (3.6, 2.5))
    capacitor("cd", (3.6, 2.5), (3.6, 0.4), label: (content: $C_d space 100 "nF"$, anchor: "south"))
    ground("g", (3.6, 0.4))
    rect((5.8, 1.4), (7.8, 3.0), stroke: 0.8pt, fill: white)
    content((6.8, 2.2), align(center, _i2a-t[etapa \ de RF]))
    wire((6.8, 1.4), (6.8, 0.4))
    ground("g2", (6.8, 0.4))
    _i2a-flecha((0.9, 2.95), (2.3, 2.95), etq: [continua])
    // RF: sale de la etapa, cruza Cd, vuelve por masa
    _i2a-flecha((5.6, 2.2), (3.9, 2.2), color: col.senal1)
    _i2a-flecha((3.95, 2.0), (3.95, 0.9), color: col.senal1, etq: [RF a masa], anchor: "west")
  })
] <i2a-fig-desacoplo>

#porque[
  - Para la continua, $C_d$ es un abierto: los 12 V llegan a la etapa a través de $R_d$, que solo pierde unas décimas de voltio con la pequeña corriente de la etapa.
  - Para la RF, $C_d$ es casi un cable (0,23 Ω a 7 MHz), mientras que $R_d$ ofrece 100 Ω: la corriente de RF elige el camino fácil, el condensador, y vuelve a masa sin salir de la etapa.
  - Sin $C_d$, la RF recorrería el raíl común y entraría en las demás etapas. Si llega a una etapa anterior y en la fase adecuada, la realimentación convierte el amplificador en un oscilador: silbidos, o el «petardeo» de los amplificadores de audio mal desacoplados.
]

#ptitulo[Oficio 3: filtrar] Una resistencia en serie y un condensador a masa forman un *filtro paso bajo* (@i2a-fig-paso-bajo; la teoría está en #ver(<sec-filtros-rc>)). A frecuencias bajas el condensador es casi un abierto y la señal pasa entera; a frecuencias altas el condensador es casi un cable a masa y se la lleva. La frontera es la frecuencia de corte $f_c = 1 slash (2 pi R C)$. En la salida del detector de nuestra radio, $R = 10$ kΩ y $C = 4,7$ nF dan $f_c approx 3,4$ kHz: la voz (hasta unos 3 kHz) pasa, y los restos de RF de 1 MHz quedan unas 300 veces más débiles. Cambia el orden (condensador en serie, resistencia a masa) y tienes el paso alto: el acoplo del oficio 1 es, en el fondo, un paso alto.

#circuito(caption: [Filtro RC paso bajo. Entra la voz con restos de RF encima; sale solo la voz: el condensador envía a masa lo rápido.], sim: "filt-lopass.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line, group, translate
    group({
      translate((-0.4, 1.6))
      ejes(0, 2.4, -0.9, 0.9)
      onda(x => 0.5 * calc.sin(x * 2 * calc.pi / 1.1) + 0.18 * calc.sin(x * 2 * calc.pi / 0.07), 0, 2.2, n: 400, stroke: 0.8pt + col.senal1)
      content((1.1, -0.95), anchor: "north", _i2a-t[entrada])
    })
    group({
      translate((5.6, 1.6))
      ejes(0, 2.4, -0.9, 0.9)
      onda(x => 0.48 * calc.sin(x * 2 * calc.pi / 1.1 - 0.3), 0, 2.2, stroke: 1pt + col.senal1)
      content((1.1, -0.95), anchor: "north", _i2a-t[salida])
    })
    node("i", (0.4, -0.4), fill: false)
    resistor("r", (0.4, -0.4), (3, -0.4), label: $R$)
    wire((3, -0.4), (5.6, -0.4))
    node("n", (4.2, -0.4))
    capacitor("c", (4.2, -0.4), (4.2, -2.2), label: $C$)
    ground("g", (4.2, -2.2))
    node("o", (5.6, -0.4), fill: false)
  })
] <i2a-fig-paso-bajo>

#porque[
  - $R$ y $C$ forman un divisor de tensión, igual que $R_1$–$R_2$, pero uno de sus dos «brazos» cambia con la frecuencia.
  - A 300 Hz, $X_C$ de 4,7 nF vale unos 113 kΩ, mucho más que $R$: el condensador apenas toma corriente y casi toda la señal llega a la salida.
  - A 1 MHz, $X_C$ vale 34 Ω, nada frente a los 10 kΩ de $R$: en la salida queda una parte en 300 de la RF.
  - Sin el condensador no hay filtro: la RF llegaría al amplificador de audio, que la rectificaría y la mezclaría con la voz.
]

#ptitulo[Oficio 4: temporizar] El mismo RC, mirado en el tiempo en vez de en la frecuencia, es un *reloj*: tarda $tau = R C$ en cargarse o descargarse. En el detector, $tau = 10 "kΩ" dot 4,7 "nF" = 47$ μs, un valor elegido entre dos límites: mucho mayor que un ciclo de RF (1 μs a 1 MHz), para que el condensador no se descargue entre cresta y cresta; mucho menor que un ciclo de voz (333 μs a 3 kHz), para que pueda seguir la envolvente (#ver(<sec-detector>)). Lo mismo decide cuánto tarda el control automático de ganancia en reaccionar o cuánto tiempo sigue transmitiendo un equipo con VOX después de que dejes de hablar. Filtro y temporizador son el mismo circuito, visto desde la frecuencia o visto desde el reloj.

#ptitulo[Oficio 5: sintonizar] Con una bobina en paralelo, un condensador _variable_ forma el circuito tanque que elige la emisora. Lo verás en cuanto conozcamos la bobina (@i2a-fig-sintonia).

#ojo[
  El examen insiste en dos ideas: el condensador *bloquea la continua y deja pasar la alterna*, y su reactancia *baja al subir la frecuencia* ($X_C = 1 slash (2 pi f C)$: doble frecuencia, mitad de reactancia). Para leer un esquema: en serie en la línea de señal, es un acoplo; de un punto a masa, un desacoplo o un filtro; junto a una bobina, un tanque.
]

== La bobina y el transformador <sec-bobina>

#motivacion[
  Tres problemas más de nuestra radio. *Uno*: el colector de un amplificador de RF necesita la continua del raíl, pero su señal de RF no debe escaparse hacia el raíl. *Dos*: la antena entrega a la vez cientos de emisoras, y hay que quedarse con _una_. *Tres*: la red da 230 V y la radio quiere unos 15; el altavoz tiene 8 Ω y el amplificador quiere ver centenares. El primero lo resuelve la bobina sola; el segundo, la bobina junto al condensador; el tercero, dos bobinas que comparten un núcleo: el transformador.
]

#ptitulo[Qué le pasa a la corriente por dentro] La bobina es el componente con _inercia_. Su corriente crea un campo magnético en el núcleo; cambiar la corriente es cambiar ese campo, y el campo cambiante induce en las propias espiras una tensión que se opone al cambio (Lenz). El resultado es el espejo exacto del condensador: al conectar una bobina, la corriente _no puede_ pegar un salto —~arranca de cero y crece con una exponencial gemela a la de la @i2a-fig-rc, con constante de tiempo $tau = L slash R$~—, y una vez establecida, la bobina no estorba nada. Lo delicado es _cortarla_: si abres bruscamente el circuito de una bobina con corriente, obligas a un cambio casi instantáneo, y la tensión inducida $v = L thin d i slash d t$ se dispara a cientos de voltios —~la chispa del interruptor, el chasquido en el receptor. Por eso todo relé lleva un _diodo volante_ en paralelo que ofrece a esa corriente un camino de escape suave (@i2a-fig-volante), y por eso las bobinas «muerden» al desconectar.

#analogia[
  El agua de una tubería larga y pesada. Cuesta ponerla en marcha (la corriente crece despacio) y, una vez en marcha, sigue sola. Si cierras de golpe el grifo, la masa de agua en movimiento golpea la válvula: el golpe de ariete. La bobina es esa masa de agua; la chispa del interruptor es su golpe de ariete. Guarda la imagen: bobina = masa (inercia), condensador = muelle (depósito). Una masa colgada de un muelle oscila a su propio ritmo, y eso será el circuito tanque.
]

#circuito(caption: [El diodo volante de un relé. Con el transistor conduciendo, la corriente (ámbar) baja por la bobina. Al cortarlo, la bobina quiere mantener su corriente: sin el diodo, la tensión del colector se dispararía a cientos de voltios; con él, la corriente gira por el diodo (rojo) y se apaga suavemente.], sim: "inductkick-block.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    wire((0, 4), (3, 4))
    content((-0.1, 4), anchor: "east", _i2a-t[+12 V])
    inductor("l", (1.5, 4), (1.5, 2))
    content((0.8, 3.0), anchor: "east", _i2a-t[bobina \ del relé])
    node("n1", (1.5, 4))
    wire((3, 4), (3, 3.6))
    diode("d", (3, 2.2), (3, 3.6), label: (content: _i2a-t[diodo \ volante], anchor: "south"))
    wire((3, 2.2), (3, 2))
    wire((1.5, 2), (3, 2))
    node("n2", (1.5, 2))
    npn("q", (1.5, 0.9))
    wire((1.5, 2), "q.c")
    ground("g", "q.e")
    content((0.3, 0.9), anchor: "east", _i2a-t[orden])
    wire((0.3, 0.9), "q.b")
    _i2a-flecha((1.05, 3.6), (1.05, 2.4))
    _i2a-flecha((2.55, 2.4), (2.55, 3.6), color: col.senal2)
  })
] <i2a-fig-volante>

#porque[
  - Mientras el transistor conduce, el colector está casi a masa y el diodo, con su cátodo en +12 V y su ánodo más abajo, está en inversa: no hace nada.
  - Al cortar el transistor, la bobina mantiene su corriente un instante y, para empujarla, invierte su tensión: el extremo de abajo sube por encima de +12 V. Entonces el diodo queda en directa y le ofrece a esa corriente un lazo cerrado (bobina → diodo → bobina) donde extinguirse.
  - Sin el diodo, la corriente no tendría por dónde seguir: $d i slash d t$ enorme, cientos de voltios en el colector y el transistor perforado al primer disparo.
]

#ptitulo[La clave: la reactancia inductiva] Igual que el condensador, la bobina se opone a la alterna con una *reactancia*, pero al revés: crece con la frecuencia.
#destacada($ X_L = 2 pi f L $, nota: [en ohmios; sube con la frecuencia y con la inductancia])
Una bobina de 100 μH ofrece 0,03 Ω a la red de 50 Hz —~un cable~— y 4,4 kΩ a 7 MHz —~casi un muro. Es el condensador puesto del revés, y de ahí salen sus oficios. #falstad("indmultfreq.txt", texto: [La reactancia sube con la frecuencia])

=== Los oficios de la bobina en la radio

#ptitulo[Oficio 1: el choque de RF] Una bobina en serie con la alimentación (@i2a-fig-choque) deja llegar la continua al colector y le cierra el paso a la RF hacia el raíl. Se llama _choque_ (RFC, _radio frequency choke_). Trabaja en equipo con un condensador de desacoplo: el choque frena la RF y el condensador se la lleva a masa. Es la versión de RF del desacoplo de la @i2a-fig-desacoplo, con una ventaja: la bobina no pierde continua, porque su resistencia para la continua es casi cero.

#circuito(caption: [Alimentación de un amplificador de RF a través de un choque. La continua (ámbar) baja del raíl por el choque; la RF (azul) del colector no puede subir por él y sale, por el condensador de acoplo, hacia la etapa siguiente.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    wire((0, 4.4), (3, 4.4))
    content((-0.1, 4.4), anchor: "east", _i2a-t[+12 V])
    node("n", (0.8, 4.4))
    capacitor("cd", (0.8, 4.4), (0.8, 2.6), label: (content: $C_d$, anchor: "south"))
    ground("g1", (0.8, 2.6))
    inductor("rfc", (3, 4.4), (3, 2.4), label: (content: _i2a-t[RFC \ 100 μH], anchor: "south"))
    npn("q", (3, 1.3))
    wire((3, 2.4), "q.c")
    node("nc", (3, 2.4))
    ground("g2", "q.e")
    capacitor("cs", (3, 2.4), (5, 2.4), label: $C_"acoplo"$)
    node("o", (5, 2.4), fill: false)
    content((5.1, 2.4), anchor: "west", _i2a-t[a la etapa \ siguiente])
    content((1.6, 1.3), anchor: "east", _i2a-t[señal])
    wire((1.6, 1.3), "q.b")
    _i2a-flecha((3.45, 4.3), (3.45, 3.5), etq: [continua], anchor: "west")
    _i2a-flecha((3.4, 1.55), (4.6, 1.55), color: col.senal1, etq: [RF], anchor: "north")
  })
] <i2a-fig-choque>

#porque[
  - Para la continua, el choque es un trozo de hilo: el colector recibe los 12 V casi enteros.
  - Para la RF de 7 MHz, el choque de 100 μH opone 4,4 kΩ: la señal del colector no sube hacia el raíl y solo le queda salir por $C_"acoplo"$, que para ella es un cable.
  - La poca RF que aún se cuela por el choque la recoge $C_d$ y la manda a masa. Sin el choque, el raíl (desacoplado a masa por $C_d$) sería un cortocircuito para la RF del colector: la etapa no daría señal.
]

#ptitulo[Oficio 2: el circuito sintonizado, la pareja que elige emisora] Ahora juntamos las dos piezas con inercia de signo contrario. Una bobina y un condensador en paralelo forman un *circuito tanque*. La energía va y viene entre los dos: el condensador se descarga por la bobina, la bobina lanza la corriente y recarga el condensador al revés, y vuelta a empezar, como la masa colgada del muelle. Ese vaivén tiene un ritmo propio, la *frecuencia de resonancia*:
#destacada($ f_0 = 1 / (2 pi sqrt(L C)) $, nota: [la frecuencia a la que $X_L = X_C$])
A esa frecuencia, y solo a esa, el tanque presenta una impedancia muy alta: la señal de la emisora que oscila a $f_0$ crea en él una tensión grande, y todas las demás encuentran en el tanque un camino fácil a masa (por la bobina las lentas, por el condensador las rápidas). Si el condensador es *variable*, girar su mando cambia $C$, cambia $f_0$ y cambia la emisora elegida: eso es sintonizar (@i2a-fig-sintonia). La teoría completa de la resonancia, con el factor de calidad $Q$ y el ancho de banda, está en #ver(<sec-resonancia>). #falstad("res-par.txt", texto: [Resonancia en paralelo])

#circuito(caption: [El circuito sintonizado de nuestra radio. Izquierda: la bobina $L$ y el condensador variable $C_v$ en paralelo, entre la antena y masa. Derecha: la tensión en el tanque frente a la frecuencia; la antena entrega muchas emisoras (barras) y solo la que cae en $f_0$ produce una tensión grande. Girar $C_v$ desplaza la campana.], sim: "bandpass.txt")[
  #grid(
    columns: (auto, auto),
    column-gutter: 0.9cm,
    align: horizon,
    esquema({
      import zap: *
      import cetz.draw: content, line
      antenna("ant", (0, 3))
      wire((0, 3), (0, 2.6), (2.8, 2.6))
      node("a", (1.2, 2.6))
      node("b", (2.6, 2.6))
      inductor("l", (1.2, 2.6), (1.2, 0.4), label: (content: $L$, anchor: "south"))
      capacitor("cv", (2.6, 2.6), (2.6, 0.4), variable: true, label: $C_v$)
      wire((1.2, 0.4), (2.6, 0.4))
      node("c", (1.9, 0.4))
      ground("g", (1.9, 0.4))
      wire((2.8, 2.6), (3.6, 2.6))
      node("o", (3.6, 2.6), fill: false)
      content((3.75, 2.6), anchor: "west", _i2a-t[al amplificador \ de RF])
    }),
    cetz.canvas({
      import cetz.draw: *
      ejes(0, 6.4, 0, 3.2, etq-x: $f$, etq-y: $v$)
      for (x, h) in ((0.7, 0.35), (1.5, 0.35), (2.3, 0.35), (3.9, 0.35), (4.7, 0.35), (5.6, 0.35)) {
        line((x, 0), (x, h), stroke: 2pt + col.gris.lighten(30%))
      }
      onda(x => 2.6 / calc.sqrt(1 + 30 * calc.pow(x / 3.1 - 3.1 / calc.max(x, 0.05), 2)), 0.3, 6.2, stroke: 1.2pt + col.senal1)
      line((3.1, 0), (3.1, 2.6), stroke: 2pt + col.senal2)
      content((3.1, -0.1), anchor: "north", text(size: 8pt, $f_0$))
      content((3.25, 2.75), anchor: "west", text(size: 7pt, fill: col.senal2)[la emisora elegida])
      content((5.2, 0.6), anchor: "south", text(size: 7pt, fill: col.gris)[las demás])
    }),
  )
] <i2a-fig-sintonia>

#porque[
  - La antena entrega a la vez todas las emisoras que le llegan: microvoltios de cada una, en cientos de frecuencias.
  - Para las frecuencias muy por debajo de $f_0$, la bobina tiene poca reactancia y las cortocircuita a masa; para las muy por encima, es el condensador quien lo hace.
  - A $f_0$, las corrientes de $L$ y de $C$ son iguales y opuestas: se cancelan hacia fuera, el tanque se comporta como una resistencia muy alta, y la emisora de esa frecuencia desarrolla en él toda su tensión.
  - Sin el tanque, el amplificador de RF amplificaría todo a la vez y el detector daría una mezcla ininteligible de emisoras.
]

#ejemplo(titulo: [sintonizar la banda de 40 m])[
  Con una bobina de $L = 2,2$ μH, ¿qué capacidad sintoniza 7,1 MHz? Despejando $C$ de la fórmula de resonancia: $C = 1 slash ((2 pi f_0)^2 L) = 1 slash ((2 pi dot 7,1 times 10^6)^2 dot 2,2 times 10^(-6)) approx 228$ pF. Un condensador variable de 150 a 400 pF con esa bobina recorre de unos 8,8 a 5,4 MHz. Fíjate en la raíz: para doblar la frecuencia hay que dividir la capacidad por cuatro.
]

#ptitulo[Oficio 3: filtrar sin perder] Una bobina en serie y un condensador a masa forman un filtro paso bajo como el RC de la @i2a-fig-paso-bajo, pero mejor: la bobina, a diferencia de la resistencia, frena la alterna _sin calentarse_ y deja pasar la continua sin perder tensión. Por eso los filtros que manejan potencia (el de la fuente, #ver(<sec-fuente>); el de la salida de un transmisor) son LC y no RC. Con un condensador a cada lado de la bobina, el filtro se llama *en pi*: lo encontrarás dos veces más en este capítulo, alisando la fuente y adaptando la antena (#ver(<sec-redes-adaptacion>)).

#ojo[
  La bobina es el espejo del condensador: *deja pasar la continua y frena la alterna*, y su reactancia *sube con la frecuencia* ($X_L = 2 pi f L$). En resonancia $X_L = X_C$; un tanque LC paralelo tiene impedancia _máxima_ en $f_0$ y un LC serie, _mínima_. Si dudas cuál es cuál, piensa en el oficio: el tanque de sintonía paralelo «acepta» su emisora porque es ahí donde se resiste a ponerla a masa.
]

=== El transformador: dos bobinas y un puente de flujo <sec-transformador>

Arrolla dos bobinas sobre el mismo núcleo (@i2a-fig-trafo) y el campo de una abraza a la otra. Aplica alterna al *primario*: su corriente magnetizante crea un flujo alterno en el núcleo; ese flujo atraviesa el *secundario* e induce en cada una de sus espiras la misma tensión por espira que en las del primario. De ahí la relación fundamental —~todo va en proporción al número de espiras:
$ V_2 / V_1 = N_2 / N_1 , $
y como el transformador ideal no crea ni consume potencia ($V_1 I_1 = V_2 I_2$), las corrientes van en proporción _inversa_: lo que multiplicas en tensión lo divides en corriente. Cuando el secundario entrega corriente a una carga, esa corriente crea un flujo que tendería a desmontar el del núcleo, y el primario responde tomando de la red justo la corriente extra necesaria para sostenerlo: así es como la energía cruza el núcleo sin que haya un solo cable de cobre entre los dos devanados —~y por eso el transformador, de paso, _aísla_ galvánicamente la radio de la red, que no es poca virtud de seguridad.

#ptitulo[El tercer truco: transformar impedancias] Visto desde el primario, una carga $R$ en el secundario parece
$ R' = R (N_1 / N_2)^2 $
—~la tensión se divide por la relación y la corriente se multiplica, así que el cociente $V slash I$ cambia con el _cuadrado_. Un transformador es un adaptador de impedancias sin pérdidas: con relación 2:1 conviertes 50 Ω en 200; con 15:1, el altavoz de 8 Ω parece 1800 Ω. El capítulo anterior explicó por qué adaptar importa (máxima transferencia de potencia); el transformador es una de las tres herramientas para lograrlo, junto a las redes LC y las tomas de bobina.

#circuito(caption: [El transformador de la fuente de nuestra radio: 230 V de red en el primario, unos 15 V en el secundario porque tiene unas 15 veces menos espiras. La energía cruza por el flujo magnético del núcleo, sin contacto eléctrico entre devanados: el transformador también aísla. Las corrientes van en proporción inversa a las tensiones, y las impedancias, con el cuadrado de la relación de espiras.], sim: "transformerdown.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    trafo("t", (0, 0), espiras: (5, 3))
    wire("t.p1", (-1.8, 1))
    wire("t.p2", (-1.8, -1))
    node("a", (-1.8, 1), fill: false)
    node("b", (-1.8, -1), fill: false)
    wire("t.s1", (1.8, 0.6))
    wire("t.s2", (1.8, -0.6))
    node("c", (1.8, 0.6), fill: false)
    node("d", (1.8, -0.6), fill: false)
    content((-2.1, 0), anchor: "east", align(right, _i2a-t[red \ 230 V∼]))
    content((2.1, 0), anchor: "west", _i2a-t[unos 15 V∼ \ (relación ≈15:1)])
    content((-0.75, 0), anchor: "east", $N_1$)
    content((0.75, 0), anchor: "west", $N_2$)
    content((0, 1.25), anchor: "south", _i2a-t(color: col.gris)[flujo común])
    content((-0.6, -1.25), anchor: "north", _i2a-t[primario])
    content((0.8, -1.25), anchor: "north", _i2a-t[secundario])
  })
] <i2a-fig-trafo>

#porque[
  - La alterna del primario crea un flujo alterno en el núcleo de hierro, que lo concentra y lo lleva entero hasta el secundario.
  - Cada espira, sea del primario o del secundario, abraza el mismo flujo y tiene la misma tensión inducida. El secundario, con 15 veces menos espiras, suma 15 veces menos tensión: de 230 V a unos 15 V.
  - La potencia que entra es la que sale (salvo pérdidas pequeñas): con 15 veces menos tensión, el secundario puede dar 15 veces más corriente.
  - Solo funciona con alterna: una continua en el primario crea un flujo fijo, que no induce nada, y el primario (casi sin resistencia) se quemaría. #falstad("transformerdc.txt", texto: [Transformador con continua])
]

#ejercicio(sol: [Relación $230 slash 11,5 = 20 : 1$. El primario toma $2 slash 20 = 0,1$ A: veinte veces menos corriente a veinte veces más tensión, misma potencia (23 W).])[
  Un transformador reduce 230 V a 11,5 V. ¿Cuál es su relación de espiras? Si el secundario entrega 2 A, ¿qué corriente toma el primario de la red (supón el transformador ideal)?
]

==== Los oficios del transformador en la radio

#ptitulo[Oficio 1: cambiar la tensión] Es el de la @i2a-fig-trafo: bajar los 230 V de la red a los 15 V que rectificará la fuente. En un transmisor de válvulas hace lo contrario: sube la red a los centenares de voltios de placa.

#ptitulo[Oficio 2: cambiar la impedancia] El amplificador de audio de una radio de transistores rinde al máximo cuando su carga es de unos centenares de ohmios; el altavoz tiene 8. Conectado directamente, el altavoz sería casi un cortocircuito para el amplificador. Un transformador de salida (@i2a-fig-trafo-z) hace que los 8 Ω parezcan los ohmios que el amplificador quiere. Lo mismo hacen en RF los *baluns* y transformadores de banda ancha: un 4:1 de impedancia convierte, por ejemplo, los 200 Ω de una antena en los 50 Ω del cable.

#circuito(caption: [Transformador de salida de audio. Con 10 veces más espiras en el primario, el altavoz de 8 Ω se ve desde el amplificador como $8 dot 10^2 = 800$ Ω. La continua del colector (ámbar) recorre solo el primario: el altavoz no la recibe.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    wire((-2.4, 2.6), (0.4, 2.6))
    content((0.5, 2.6), anchor: "west", _i2a-t[+12 V])
    trafo("t", (0, 0.6), espiras: (5, 2))
    wire("t.p1", (-1.6, 1.6), (-1.6, 2.6))
    wire("t.p2", (-1.6, -0.4))
    npn("q", (-1.6, -1.3))
    wire((-1.6, -0.4), "q.c")
    ground("g", "q.e")
    content((-3.2, -1.3), anchor: "east", _i2a-t[audio])
    wire((-3.2, -1.3), "q.b")
    wire("t.s1", (1.6, 1.0))
    wire("t.s2", (1.6, 0.2))
    altavoz("sp", (1.75, 0.6))
    wire((1.6, 1.0), (1.6, 0.9))
    wire((1.6, 0.2), (1.6, 0.3))
    content((2.6, 0.6), anchor: "west", _i2a-t[8 Ω])
    content((-0.6, 1.95), anchor: "south", _i2a-t[$N_1$ = 10 · $N_2$])
    content((-2.0, 0.6), anchor: "east", _i2a-t(color: col.gris)[ve 800 Ω])
    _i2a-flecha((-2.05, 2.3), (-2.05, 1.5), etq: [continua], anchor: "east")
  })
] <i2a-fig-trafo-z>

#porque[
  - La señal del colector varía la corriente del primario; el flujo la lleva al secundario, que mueve el altavoz.
  - El secundario tiene 10 veces menos espiras: da 10 veces menos tensión y 10 veces más corriente. El altavoz, de 8 Ω, «tira» de una corriente grande con poca tensión; visto desde el primario eso parece una carga de $8 dot 100 = 800$ Ω.
  - La continua de polarización del colector circula por el primario y no pasa al secundario (es continua: no induce nada): el altavoz no recibe continua, que lo calentaría y desplazaría su cono.
]

#ptitulo[Oficio 3: aislar] Entre primario y secundario no hay cobre: solo flujo. La red de 230 V queda separada de todo lo que puedes tocar en la radio. El mismo aislamiento sirve entre etapas: cada devanado tiene su propia continua.

#ptitulo[Oficio 4: el transformador de FI, que sintoniza y adapta a la vez] Si se pone un condensador en paralelo con el primario, el primario es además un circuito tanque: el transformador solo deja pasar con fuerza las frecuencias cercanas a su resonancia. Es el *transformador de frecuencia intermedia* (FI) de los superheterodinos: la cajita metálica con un núcleo de ferrita roscado, que se ajusta con un destornillador. En una sola pieza filtra (tanque), acopla (sin continua compartida) y adapta (el secundario, con pocas espiras, da la impedancia baja que pide la base siguiente). Lo verás trabajar en #ver(<sec-amp-sintonizado>).

#circuito(caption: [Transformador de FI. El primario con su condensador forma un tanque sintonizado a la FI (por ejemplo 455 kHz); el núcleo de ferrita (líneas a trazos) es ajustable. El secundario, de pocas espiras, entrega la señal a la etapa siguiente con impedancia baja.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    wire((-2.6, 2.4), (0.6, 2.4))
    content((0.7, 2.4), anchor: "west", _i2a-t[+12 V])
    trafo("t", (0, 0.4), nucleo: false, espiras: (4, 2))
    line((-0.07, -0.5), (-0.07, 1.3), stroke: (dash: "dashed", thickness: 0.7pt))
    line((0.07, -0.5), (0.07, 1.3), stroke: (dash: "dashed", thickness: 0.7pt))
    wire("t.p1", (-1, 2.4))
    node("n1", (-1, 2.4))
    node("n1b", (-1, 1.2))
    node("n2", (-1, -0.4))
    capacitor("c", (-2, 1.2), (-2, -0.4), label: (content: $C$, anchor: "south"))
    wire((-2, 1.2), (-1, 1.2))
    wire((-2, -0.4), (-1, -0.4))
    wire((-1, -0.4), (-1, -0.9))
    npn("q", (-1, -1.8))
    wire((-1, -0.9), "q.c")
    ground("g", "q.e")
    content((-2.6, -1.8), anchor: "east", _i2a-t[FI])
    wire((-2.6, -1.8), "q.b")
    wire("t.s1", (2, 0.8))
    wire("t.s2", (2, 0))
    node("o1", (2, 0.8), fill: false)
    node("o2", (2, 0), fill: false)
    content((2.2, 0.4), anchor: "west", _i2a-t[a la etapa \ siguiente])
  })
] <i2a-fig-fi>

#porque[
  - $C$ y el primario resuenan a la FI: a esa frecuencia el primario presenta una impedancia alta, el colector desarrolla mucha señal y el flujo la lleva al secundario. Fuera de la FI, el tanque es casi un cortocircuito y apenas pasa nada: el transformador es un filtro.
  - La continua del colector va por el primario; la etapa siguiente recibe solo la señal, por el secundario.
  - Pocas espiras en el secundario: menos tensión, menos impedancia; justo lo que pide la entrada de un transistor, que es de impedancia baja.
]

#ptitulo[Los límites del transformador en RF] El hierro de un transformador de red se calienta a 50 Hz y sería un desastre a 7 MHz: en RF se usan núcleos de ferrita o de aire. Y aun así, el transformador de RF tiene límites: solo da relaciones fijas (las de un número entero de espiras), funciona bien en un margen de frecuencias limitado por su inductancia de dispersión y la capacidad entre espiras, y no puede cancelar la _reactancia_ que tenga la carga. Cuando hace falta ajustar con finura, en una sola banda, o cancelar reactancia, entran las redes LC de #ver(<sec-redes-adaptacion>).

#ojo[
  Tres reglas que el examen mezcla a propósito: la *tensión* va con la relación de espiras ($V_2 slash V_1 = N_2 slash N_1$); la *corriente*, con la relación inversa; la *impedancia*, con el _cuadrado_ ($R' = R (N_1 slash N_2)^2$). Una relación de espiras 3:1 da una relación de impedancias 9:1. Y el transformador no funciona con continua.
]

== El diodo: la válvula antirretorno (y con él, la fuente entera) <sec-diodo>

#motivacion[
  La red eléctrica empuja la corriente hacia un lado y hacia el otro, cien veces por segundo. Los transistores de nuestra radio necesitan una corriente que vaya _siempre en el mismo sentido_: con alterna, la mitad del tiempo estarían polarizados al revés. El detector de AM tiene el mismo problema en pequeño: de la RF quiere quedarse solo con una mitad. Y el relé de la @i2a-fig-volante necesita una salida de emergencia que solo se abra en un sentido. Las tres cosas las hace la misma pieza: una válvula que deja pasar la corriente en un sentido y la bloquea en el otro.
]

#ptitulo[La unión PN por dentro] Un diodo es un cristal semiconductor con dos regiones de dopado distinto (@i2a-fig-pn): la zona *P*, sembrada de impurezas que aportan _huecos_ (ausencias de electrón que se comportan como cargas positivas móviles), y la zona *N*, con impurezas que aportan electrones libres. En la frontera ocurre algo decisivo: los electrones de N se difunden hacia P y los huecos de P hacia N, se recombinan, y dejan tras de sí una franja _sin portadores móviles_ —~la *zona de deplexión*~— donde quedan al descubierto los iones fijos de las impurezas: negativos en el lado P, positivos en el lado N. Esa doble capa de carga crea un campo interno, una barrera de unos 0,6–0,7 V (en silicio; en las cuentas de este capítulo, 0,6 V) que detiene la difusión. El diodo en reposo es un equilibrio armado.

#circuito(caption: [La unión PN en reposo. La difusión inicial de portadores a través de la frontera deja una franja vacía de cargas móviles (deplexión) con los iones fijos al descubierto; el campo de esa doble capa forma la barrera de 0,6 V que la tensión externa tendrá que vencer —~o reforzar.])[
  #cetz.canvas({
    import cetz.draw: *
    rect((0, 0), (3, 1.8), fill: col.senal2.lighten(88%), stroke: 0.6pt)
    rect((3, 0), (4, 1.8), fill: col.ambar-claro, stroke: 0.6pt)
    rect((4, 0), (7, 1.8), fill: col.senal1.lighten(88%), stroke: 0.6pt)
    line((-0.9, 0.9), (0, 0.9), stroke: 0.6pt)
    line((7, 0.9), (7.9, 0.9), stroke: 0.6pt)
    content((-0.95, 0.9), anchor: "east", text(size: 7.5pt)[ánodo])
    content((7.95, 0.9), anchor: "west", text(size: 7.5pt)[cátodo])
    content((1.5, 1.95), anchor: "south", text(size: 8pt, fill: col.senal2)[zona P: huecos móviles])
    content((5.5, 1.95), anchor: "south", text(size: 8pt, fill: col.senal1)[zona N: electrones móviles])
    for (x, y) in ((0.5, 1.3), (1.3, 0.55), (2.1, 1.25), (0.8, 0.4), (2.5, 0.6), (1.7, 1.5)) {
      content((x, y), text(size: 9pt, fill: col.senal2)[⊕])
    }
    for (x, y) in ((4.6, 1.2), (5.4, 0.5), (6.3, 1.35), (4.9, 0.4), (6.5, 0.6), (5.7, 1.45)) {
      content((x, y), text(size: 9pt, fill: col.senal1)[⊖])
    }
    for y in (0.35, 0.9, 1.45) {
      content((3.3, y), text(size: 8pt)[−])
      content((3.7, y), text(size: 8pt)[+])
    }
    content((3.5, -0.15), anchor: "north", align(center, text(size: 7.5pt, fill: col.gris)[zona de deplexión: sin portadores; \ barrera interna ∼0,6 V]))
  })
] <i2a-fig-pn>

#ptitulo[Cómo fluye (o no) la corriente] Aplica tensión externa con el positivo en el ánodo (zona P): tu tensión _empuja contra la barrera_, la estrecha, y en cuanto superas los ∼0,6 V la desmonta: huecos y electrones vuelven a cruzar en masa y la corriente crece de forma explosiva —~exponencial~— con la tensión (@i2a-fig-curva-diodo). Es la *polarización directa*. Invierte ahora la batería: tu tensión _refuerza_ la barrera, la zona de deplexión se ensancha, y no cruza (casi) nadie: solo una *corriente de fuga* de microamperios. Es la *polarización inversa*. Si te pasas con la tensión inversa llega la *ruptura*: la barrera cede en avalancha y el diodo conduce bruscamente hacia atrás —~destructivo en un diodo normal, _el modo de trabajo_ en un zéner, como veremos. En una frase: el diodo es una válvula antirretorno con un peaje de 0,6 V.

#circuito(caption: [La curva del diodo. En directa no conduce nada apreciable hasta el codo de ∼0,6–0,7 V y a partir de ahí la corriente crece exponencialmente (la limita el circuito, no el diodo). En inversa solo pasa una fuga minúscula, hasta la tensión de ruptura, donde conduce en avalancha: ahí vive el diodo zéner.], sim: "diodecurve.txt")[
  #cetz.canvas({
    import cetz.draw: *
    line((-4.2, 0), (2.6, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    line((0, -1.9), (0, 2.8), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((2.6, -0.05), anchor: "north-east", text(size: 8pt, $V$))
    content((0.05, 2.8), anchor: "north-west", text(size: 8pt, $I$))
    onda(x => calc.min(0.012 * (calc.exp(8 * x) - 1), 2.6), 0, 0.92, stroke: 1.2pt + col.senal1)
    line((-3.2, -0.08), (0, -0.02), stroke: 1.2pt + col.senal1)
    line((-3.2, -0.08), (-3.25, -1.8), stroke: 1.2pt + col.senal2)
    line((0.6, 0), (0.6, -0.1), stroke: 0.6pt)
    content((0.6, -0.15), anchor: "north", text(size: 7pt)[0,6 V])
    content((1.0, 2.2), anchor: "west", text(size: 7.5pt, fill: col.senal1)[directa: conduce \ a partir del codo])
    content((-1.6, 0.15), anchor: "south", text(size: 7.5pt, fill: col.senal1)[inversa: solo fuga (μA)])
    content((-3.35, -1.2), anchor: "east", text(size: 7.5pt, fill: col.senal2)[ruptura: \ zona zéner])
  })
] <i2a-fig-curva-diodo>

#analogia[
  Una válvula antirretorno de fontanería: una clapeta sujeta por un muelle. Empujando en el sentido bueno, en cuanto la presión vence al muelle (los 0,6 V) la clapeta se abre del todo y el agua pasa a chorro. Empujando al revés, la presión aprieta la clapeta contra su asiento y no pasa nada… hasta que la presión es tan bestia que revienta el asiento: la ruptura. El zéner es una válvula diseñada para «reventar» siempre a la misma presión, sin romperse.
]

=== La fuente de alimentación, etapa a etapa <sec-fuente>

#motivacion[
  La red da 230 V de alterna a 50 Hz. La radio quiere 12 V de continua, limpios: sin vaivén, sin zumbido, y los mismos aunque la red baje un poco o la radio suba el volumen. Ninguna pieza sola hace ese milagro. La fuente es una cadena de cuatro etapas, y cada etapa corrige _un_ defecto de la anterior (@i2a-fig-cadena-fuente): el transformador baja la tensión y aísla; el rectificador hace que la corriente vaya en un solo sentido; el filtro rellena los huecos entre jorobas; el regulador quita el rizado que queda y clava la tensión.
]

#circuito(caption: [La fuente de alimentación, etapa a etapa (formas de onda no a escala). Debajo de cada flecha, la tensión que hay en ese punto: la alterna de la red, la alterna reducida, las jorobas del rectificador, la continua con rizado del filtro y los 12 V limpios del regulador.])[
  #cetz.canvas({
    import cetz.draw: *
    let cajas = ((1.4, [transfor-\ mador]), (4.5, [rectifi-\ cador]), (7.6, [filtro]), (10.7, [regulador]))
    for (x, t) in cajas {
      rect((x, 0), (x + 1.7, 1), stroke: 0.7pt, radius: 2pt, fill: white)
      content((x + 0.85, 0.5), align(center, text(size: 7.5pt, t)))
    }
    for (x0, x1) in ((0, 1.4), (3.1, 4.5), (6.2, 7.6), (9.3, 10.7), (12.4, 13.6)) {
      line((x0, 0.5), (x1, 0.5), mark: (end: ">", fill: black), stroke: 0.7pt)
    }
    content((-0.05, 0.5), anchor: "east", text(size: 7.5pt)[red])
    content((13.65, 0.5), anchor: "west", text(size: 7.5pt)[la radio])
    // formas de onda, centradas bajo cada flecha
    let ventana(cx, f, etq, color: col.senal1) = {
      group({
        translate((cx - 0.75, -1.4))
        line((0, 0), (1.5, 0), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dotted"))
        onda(f, 0, 1.5, n: 200, stroke: 1pt + color)
        content((0.75, -0.75), anchor: "north", text(size: 7pt, etq))
      })
    }
    let s(x) = calc.sin(x * 2 * calc.pi / 0.75)
    ventana(0.7, x => 0.65 * s(x), [230 V∼])
    ventana(3.8, x => 0.4 * s(x), [15 V∼])
    ventana(6.9, x => 0.55 * calc.abs(s(x)), [jorobas], color: col.ambar)
    let riz(x) = {
      let fase = calc.rem(x, 0.375) / 0.375
      0.55 - 0.12 * fase
    }
    ventana(10.0, riz, [∼20 V con rizado], color: col.ambar)
    ventana(13.1, x => 0.4, [12 V], color: col.ambar)
  })
] <i2a-fig-cadena-fuente>

#ptitulo[Paso 1: el transformador] Ya lo conoces (@i2a-fig-trafo): baja los 230 V a unos 15 V eficaces y aísla la radio de la red. Sin él, el rectificador trabajaría directamente sobre la red: unos 325 V de pico donde la radio quiere 12, y cualquier punto del chasis conectado a la red. Es lo único de la fuente que trabaja con alterna «de verdad».

#ptitulo[Paso 2, sub-circuito 1: el rectificador de media onda] Pon el diodo en serie entre un generador de alterna y una carga (@i2a-fig-media-onda). Durante el semiciclo positivo el diodo está en directa: conduce, y la tensión (menos el peaje) aparece en la carga. Durante el semiciclo negativo queda en inversa: la corriente se corta del todo, y la carga ve cero. A la salida quedan solo las _jorobas_ positivas: alterna convertida en corriente _pulsante_ de un solo sentido. Es el primer paso de toda fuente de alimentación —~y es exactamente el mismo gesto que hace el detector de AM del capítulo anterior, solo que allí el botín no eran las jorobas, sino su envolvente.

#circuito(caption: [Rectificador de media onda: el diodo deja pasar los semiciclos que lo polarizan en directa y corta los contrarios. La salida ya no cambia de sentido, pero desperdicia medio ciclo: por eso las fuentes reales usan el puente de la @i2a-fig-puente.], sim: "rectify.txt")[
  #grid(
    columns: (auto, auto),
    column-gutter: 1cm,
    align: horizon,
    esquema({
      import zap: *
      acvsource("v", (0, 0), (0, 2), label: (content: $v$, anchor: "south"))
      wire((0, 2), (0, 2.6), (0.8, 2.6))
      diode("d", (0.8, 2.6), (2.6, 2.6))
      wire((2.6, 2.6), (3.4, 2.6), (3.4, 2.2))
      resistor("rl", (3.4, 2.2), (3.4, 0.4), label: [carga])
      wire((3.4, 0.4), (3.4, -0.4), (0, -0.4), (0, 0))
    }),
    cetz.canvas({
      import cetz.draw: *
      line((0, 1.4), (4, 1.4), mark: (end: ">", fill: black), stroke: 0.5pt)
      onda(x => 1.4 + 0.5 * calc.sin(x * 2 * calc.pi / 1.7), 0, 3.6, stroke: 1.1pt + col.senal1)
      content((1.8, 2.0), anchor: "south", text(size: 7pt, fill: col.gris)[entrada])
      content((4, 1.35), anchor: "north-east", text(size: 7pt, $t$))
      line((0, 0), (4, 0), mark: (end: ">", fill: black), stroke: 0.5pt)
      onda(x => calc.max(0, 0.5 * calc.sin(x * 2 * calc.pi / 1.7)), 0, 3.6, stroke: 1.1pt + col.verde)
      content((1.8, 0.62), anchor: "south", text(size: 7pt, fill: col.gris)[salida: solo los semiciclos positivos])
      content((4, -0.05), anchor: "north-east", text(size: 7pt, $t$))
    }),
  )
] <i2a-fig-media-onda>

#porque[
  - Semiciclo positivo: el extremo superior del generador está a más tensión; el ánodo del diodo queda por encima del cátodo, el diodo conduce y la corriente recorre el lazo pasando por la carga de arriba abajo.
  - Semiciclo negativo: el ánodo queda por debajo del cátodo; el diodo está en inversa y el lazo se abre. La carga no recibe nada.
  - La carga ve siempre la corriente en el mismo sentido: es continua, aunque a golpes. Sin el diodo, la carga recibiría la alterna entera, cuya media es cero: un transistor alimentado así no funcionaría.
]

#ptitulo[Onda completa con toma central] Una primera forma de aprovechar los dos semiciclos usa un transformador con el secundario partido en dos mitades iguales y dos diodos (@i2a-fig-toma-central). La toma central es la masa. En un semiciclo, el extremo superior está en positivo y conduce $D_1$; en el otro, el positivo está abajo y conduce $D_2$. Las dos mitades se turnan y la carga recibe una joroba en cada semiciclo. El precio: el secundario necesita el doble de espiras, y cada diodo aguanta en inversa casi el doble de la tensión de pico de la salida.

#circuito(caption: [Rectificador de onda completa con toma central. Cada mitad del secundario trabaja en un semiciclo, con su propio diodo; las dos corrientes atraviesan la carga en el mismo sentido.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    trafo("t", (0, 0), espiras: (4, 6))
    wire("t.p1", (-1.8, 0.8))
    wire("t.p2", (-1.8, -0.8))
    node("a", (-1.8, 0.8), fill: false)
    node("b", (-1.8, -0.8), fill: false)
    content((-2.0, 0), anchor: "east", _i2a-t[red])
    // toma central
    line((0.42, 0), (1, 0), stroke: 0.6pt)
    wire((1, 0), (2.2, 0))
    ground("g", (2.2, 0))
    wire("t.s1", (1.6, 1.2))
    diode("d1", (1.6, 1.2), (3.2, 1.2), label: $D_1$)
    wire("t.s2", (1.6, -1.2))
    diode("d2", (1.6, -1.2), (3.2, -1.2), label: (content: $D_2$, anchor: "south"))
    wire((3.2, 1.2), (3.6, 1.2), (3.6, 1.8), (4.8, 1.8))
    wire((3.2, -1.2), (3.6, -1.2), (3.6, 1.2))
    node("np", (3.6, 1.2))
    resistor("rl", (4.8, 1.8), (4.8, -0.2), label: [carga])
    ground("g2", (4.8, -0.2))
    content((1.15, 0.15), anchor: "south-west", _i2a-t(size: 6.5pt)[toma central])
  })
] <i2a-fig-toma-central>

#porque[
  - La toma central está a masa y los dos extremos del secundario están siempre en oposición: cuando uno sube, el otro baja lo mismo.
  - Semiciclo con el extremo de arriba en positivo: $D_1$ conduce, la corriente baja por la carga y vuelve por masa a la toma central. $D_2$, con el extremo de abajo en negativo, está en inversa.
  - Semiciclo contrario: los papeles se cambian, y la corriente atraviesa la carga en el mismo sentido que antes.
  - Si se abre un diodo, la fuente vuelve a ser de media onda: el rizado se duplica y pasa de 100 a 50 Hz.
]

#ptitulo[Sub-circuito 2: el puente de diodos] Tirar medio ciclo es un desperdicio. El *puente* de cuatro diodos (@i2a-fig-puente) lo evita con una idea elegante: según el semiciclo, conducen dos diodos u otros dos, y ambos caminos atraviesan la carga _en el mismo sentido_. Sigue las corrientes en la figura: en el semiciclo positivo (izquierda) conducen $D_1$ y $D_4$; en el negativo (derecha), $D_2$ y $D_3$; la carga recibe joroba tras joroba, cien al segundo con red de 50 Hz. Es rectificación de _onda completa_, con un secundario normal, sin toma central.

// Puente rectificador. activo: "pos", "neg" o none. color: color del camino.
#let _i2a-puente(activo, color) = esquema({
  import zap: *
  import cetz.draw: content, line, arc
  let gris = col.gris.lighten(55%)
  let k = if activo == none { black } else { color }
  let w = (stroke: 1pt + k)
  let (a, t, b, bo) = ((0.3, 0), (1.5, 1.2), (2.7, 0), (1.5, -1.2))
  let st(d) = if activo == none { (:) } else if (activo == "pos" and d in ("d1", "d4")) or (activo == "neg" and d in ("d2", "d3")) { (:) } else { (stroke: 0.8pt + gris) }
  diode("d1", a, t, ..st("d1"))
  diode("d2", b, t, ..st("d2"))
  diode("d3", bo, a, ..st("d3"))
  diode("d4", bo, b, ..st("d4"))
  content((0.6, 0.95), anchor: "east", text(size: 7.5pt, $D_1$))
  content((2.4, 0.95), anchor: "west", text(size: 7.5pt, $D_2$))
  content((0.6, -0.95), anchor: "east", text(size: 7.5pt, $D_3$))
  content((2.4, -0.95), anchor: "west", text(size: 7.5pt, $D_4$))
  // generador
  acvsource("v", (-0.9, -1.3), (-0.9, 0))
  wire((-0.9, 0), a, ..w)
  wire((-0.9, -1.3), (-0.9, -2.3), (3.3, -2.3), (3.3, 0), b, ..w)
  // carga
  wire(t, (1.5, 1.8), (4.4, 1.8), (4.4, 1.5), ..w)
  resistor("rl", (4.4, 1.5), (4.4, -0.6), label: text(size: 7.5pt)[carga])
  wire((4.4, -0.6), (4.4, -1.7), (3.48, -1.7), ..w)
  arc((3.48, -1.7), start: 0deg, stop: 180deg, radius: 0.18, stroke: 1pt + k)
  wire((3.12, -1.7), (1.5, -1.7), bo, ..w)
  if activo == "pos" {
    _i2a-flecha((-0.6, 0.25), (0.0, 0.25), color: color)
    _i2a-flecha((2.4, 2.05), (3.4, 2.05), color: color)
    _i2a-flecha((4.75, 0.9), (4.75, 0.0), color: color)
    _i2a-flecha((2.2, -2.55), (1.0, -2.55), color: color)
  } else if activo == "neg" {
    _i2a-flecha((0.0, 0.25), (-0.6, 0.25), color: color)
    _i2a-flecha((2.4, 2.05), (3.4, 2.05), color: color)
    _i2a-flecha((4.75, 0.9), (4.75, 0.0), color: color)
    _i2a-flecha((1.0, -2.55), (2.2, -2.55), color: color)
  }
})

#circuito(caption: [El puente rectificador, semiciclo a semiciclo (en gris, la pareja de diodos que no conduce). Cambia la pareja activa, pero la corriente atraviesa la carga _siempre de arriba a abajo_: rectificación de onda completa. El pequeño salto del cable de retorno indica que cruza sobre otro _sin_ conectarse —~el convenio de #ver(<sec-esquemas>).], sim: "fullrect.txt")[
  #grid(
    columns: (auto, auto),
    column-gutter: 1.2cm,
    row-gutter: 0.3cm,
    _i2a-puente("pos", col.ambar), _i2a-puente("neg", col.verde),
    align(center, text(size: 8pt)[semiciclo positivo: $D_1$ y $D_4$]), align(center, text(size: 8pt)[semiciclo negativo: $D_2$ y $D_3$]),
  )
] <i2a-fig-puente>

#porque[
  - Semiciclo positivo (el borne de arriba del generador en +): la corriente sale hacia el nudo izquierdo y solo puede seguir por $D_1$, que la lleva al vértice de arriba. Baja por la carga, llega al vértice de abajo y vuelve al generador por $D_4$ y el nudo derecho. $D_2$ y $D_3$ quedan en inversa.
  - Semiciclo negativo: la corriente sale por el borne de abajo, entra por el nudo derecho, sube por $D_2$ al mismo vértice de arriba, baja por la carga _en el mismo sentido_ y vuelve por $D_3$.
  - El vértice de arriba solo recibe cátodos: siempre es el positivo de la salida. El de abajo solo tiene ánodos: siempre es el negativo.
  - En cada semiciclo la corriente cruza _dos_ diodos en serie: el puente pierde $2 times 0,6 = 1,2$ V.
]

#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr),
    align: (left, center, center, center),
    [], [*Media onda*], [*Toma central*], [*Puente*],
    [Diodos], [1], [2], [4],
    [Frecuencia del rizado (red de 50 Hz)], [50 Hz], [100 Hz], [100 Hz],
    [Caída en los diodos], [0,6 V], [0,6 V], [1,2 V],
    [Transformador], [normal], [doble secundario con toma central], [normal],
    [Aprovecha los dos semiciclos], [no], [sí], [sí],
  ),
  caption: [Los tres rectificadores, comparados.],
) <i2a-tab-rectificadores>

#ptitulo[Paso 3, sub-circuito 3: el filtro y la fuente completa] Las jorobas del puente son corriente de un solo sentido, pero aún suben y bajan cien veces por segundo: inservibles para alimentar un transistor. Entra el condensador de #ver(<sec-condensador>), en su versión musculosa (@i2a-fig-fuente): un electrolítico grande en paralelo con la salida. En cada cresta el puente lo carga; entre cresta y cresta, el condensador _sostiene_ la tensión descargándose sobre la radio —~es un depósito que se rellena a golpes y vacía suave. No lo sostiene perfecto: la tensión decae un poco hasta la cresta siguiente, y ese diente de sierra residual es el *rizado* (@i2a-fig-rizado), que se combate con más capacidad, y sus restos se rematan con un *estabilizador*: un zéner (ahora mismo) o un regulador integrado.

#ejemplo[
  El rizado se estima con la ley del depósito: el condensador entrega una carga $Delta q = I Delta t$ entre crestas, y su tensión baja $Delta v = I Delta t slash C$. Tomemos $I = 0,5$ A —~el consumo de un equipo mayor que esta radio, que pide bastante menos; el número redondo sirve para ver el orden de magnitud~—, crestas cada $Delta t = 10$ ms (100 Hz tras el puente) y $C = 2200$ μF: $Delta v = 0,5 dot 0,01 slash 0,0022 approx 2,3$ V de rizado sobre los ∼20 V de continua. Duplicar el condensador lo deja en la mitad; el estabilizador se encarga del resto.
]

#circuito(sim: fc.at("fuente-completa"), caption: [La fuente de alimentación completa: el transformador baja la red a 15 V y aísla; el puente rectifica los dos semiciclos; el electrolítico sostiene la tensión entre crestas. La «radio» que cuelga a la derecha es todo lo demás de este capítulo. En un equipo real seguiría un regulador (zéner o integrado) para dejar los 12 V limpios.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line, arc
    trafo("t", (-2.2, 0), espiras: (5, 4))
    wire("t.p1", (-3.8, 1))
    wire("t.p2", (-3.8, -1))
    node("a", (-3.8, 1), fill: false)
    node("b", (-3.8, -1), fill: false)
    content((-4.0, 0), anchor: "east", align(right, _i2a-t[red \ 230 V∼]))
    let (a, t, b, bo) = ((0.3, 0), (1.5, 1.2), (2.7, 0), (1.5, -1.2))
    diode("d1", a, t)
    diode("d2", b, t)
    diode("d3", bo, a)
    diode("d4", bo, b)
    wire("t.s1", (-0.6, 0.8), (-0.6, 0), a)
    wire("t.s2", (-0.6, -0.8), (-0.6, -2.0), (1.32, -2.0))
    arc((1.32, -2.0), start: 180deg, stop: 0deg, radius: 0.18, stroke: 0.6pt)
    wire((1.68, -2.0), (3.3, -2.0), (3.3, 0), b)
    wire(t, (1.5, 2.0), (7.0, 2.0))
    wire(bo, (1.5, -2.6), (7.0, -2.6))
    content((7.1, 2.0), anchor: "west", _i2a-t[+∼20 V])
    content((7.1, -2.6), anchor: "west", _i2a-t[masa])
    node("n1", (4.6, 2.0))
    node("n2", (4.6, -2.6))
    pcapacitor("c", (4.6, -2.6), (4.6, 2.0))
    content((4.3, 0.9), anchor: "east", $C space 2200 "μF"$)
    content((4.85, 0.05), anchor: "west", _i2a-t(size: 7pt)[+])
    node("n3", (6.1, 2.0))
    node("n4", (6.1, -2.6))
    resistor("rl", (6.1, 2.0), (6.1, -2.6), label: [la radio])
    content((1.5, -2.85), anchor: "north", _i2a-t(size: 6.5pt, color: col.gris)[salto: cruce sin conexión])
  })
] <i2a-fig-fuente>

#porque[
  - El transformador entrega unos 15 V eficaces, es decir, unos 21 V de pico ($15 dot sqrt(2)$). El puente les quita 1,2 V: las crestas de salida rondan los 20 V.
  - En cada cresta, la tensión del puente supera la del condensador: los diodos conducen un instante y lo rellenan. Entre crestas, la tensión del puente cae por debajo de la del condensador; los diodos quedan en inversa y el condensador, aislado del puente, alimenta él solo a la radio.
  - Sin el condensador, la radio recibiría las jorobas: su tensión bajaría a cero cien veces por segundo y el auricular daría un zumbido de 100 Hz. Un electrolítico seco (que ha perdido capacidad con los años) produce el mismo síntoma, más suave: el típico zumbido de una fuente vieja.
  - La polaridad del electrolítico importa: su borne + va al raíl positivo. Al revés, se calienta y puede reventar.
]

#circuito(caption: [El trabajo del condensador de filtro. En azul claro, las jorobas que entrega el puente; en verde, la tensión sostenida por el condensador, que se recarga en cada cresta y baja suavemente entre ellas. El diente de sierra residual es el rizado, que disminuye al aumentar la capacidad o reducir el consumo.], sim: "fullrectf.txt")[
  #cetz.canvas({
    import cetz.draw: *
    ejes(0, 7, 0, 2.6, etq-x: $t$, etq-y: $v$)
    let amp = 2
    let n = 600
    let tau = 6.0
    let pts-j = ()
    let pts-c = ()
    let vc = 0
    for i in range(n + 1) {
      let x = 6.3 * i / n
      let th = x * calc.pi / 1.8
      let r = calc.abs(calc.sin(th))
      vc = calc.max(r, vc * calc.exp(-(6.3 / n) / tau * 4.2))
      pts-j.push((x, amp * r))
      pts-c.push((x, amp * vc))
    }
    line(..pts-j, stroke: 0.9pt + col.senal1.lighten(45%))
    line(..pts-c, stroke: 1.3pt + col.verde)
    content((1.0, 2.25), anchor: "south-west", text(size: 7pt, fill: col.verde)[con condensador: carga en la cresta, descarga suave])
    content((0.6, -0.1), anchor: "north-west", text(size: 7pt, fill: col.senal1)[salida del puente])
    // rizado
    line((6.45, 2.0), (6.45, 1.55), mark: (start: ">", end: ">", fill: black, scale: 0.4), stroke: 0.5pt)
    content((6.55, 1.78), anchor: "west", text(size: 7pt)[rizado $Delta v$])
  })
] <i2a-fig-rizado>

#ptitulo[El filtro en pi: condensador, bobina, condensador] Cuando el rizado de un solo condensador es demasiado, se añade una segunda etapa de filtrado: una bobina en serie y otro condensador a masa (@i2a-fig-pi-fuente). El conjunto $C_1$–$L$–$C_2$ dibuja una letra griega $pi$ (dos patas a masa y un travesaño), y por eso se llama *filtro en pi*. $C_1$ hace el trabajo de antes y deja su rizado; la bobina, que no se opone a la continua, frena con fuerza la componente de 100 Hz del rizado; $C_2$, para esa frecuencia, es casi un cortocircuito a masa. Bobina y $C_2$ forman un divisor de tensión _para el rizado_ que deja pasar la continua entera.

#circuito(sim: fc.at("filtro-pi-fuente"), caption: [Filtro en pi (CLC) tras el puente. Arriba, la tensión en cada condensador: el rizado de $C_1$ (2,3 V con los valores del ejemplo) llega a $C_2$ reducido a unas tres décimas de voltio. La continua (ámbar) cruza la bobina sin pérdida.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line, group, translate
    let diente(x, a) = 0.5 + a * (0.5 - calc.rem(x, 0.4) / 0.4)
    group({
      translate((0.6, 1.6))
      ejes(0, 1.9, 0, 1.2)
      onda(x => diente(x, 0.3), 0, 1.7, n: 300, stroke: 1pt + col.ambar)
      content((0.9, 1.25), anchor: "south", _i2a-t[en $C_1$: rizado grande])
    })
    group({
      translate((4.2, 1.6))
      ejes(0, 1.9, 0, 1.2)
      onda(x => diente(x, 0.04), 0, 1.7, n: 300, stroke: 1pt + col.ambar)
      content((0.9, 1.25), anchor: "south", _i2a-t[en $C_2$: casi nada])
    })
    content((-0.1, 0.8), anchor: "east", _i2a-t[del puente])
    wire((0, 0.8), (1.4, 0.8))
    node("n1", (1.4, 0.8))
    pcapacitor("c1", (1.4, -1.4), (1.4, 0.8), label: $C_1$)
    ground("g1", (1.4, -1.4))
    inductor("l", (1.4, 0.8), (4.0, 0.8), label: $L$)
    wire((4.0, 0.8), (6.4, 0.8))
    node("n2", (5.0, 0.8))
    pcapacitor("c2", (5.0, -1.4), (5.0, 0.8), label: $C_2$)
    ground("g2", (5.0, -1.4))
    node("o", (6.4, 0.8), fill: false)
    content((6.5, 0.8), anchor: "west", _i2a-t[a la radio])
    _i2a-flecha((2.1, 0.35), (3.3, 0.35), etq: [continua], anchor: "north")
  })
] <i2a-fig-pi-fuente>

#porque[
  - Para la continua, la bobina es un hilo: la tensión media de $C_1$ llega entera a $C_2$.
  - Para el rizado de 100 Hz, con $L = 10$ mH y $C_2 = 2200$ μF: $X_L = 2 pi dot 100 dot 0,01 approx 6,3$ Ω y $X_(C_2) approx 0,72$ Ω. El rizado se reparte entre los dos como en un divisor: a $C_2$ le llega $0,72 slash (6,3 - 0,72) approx 0,13$ del rizado de $C_1$, unos 0,3 V de los 2,3.
  - Sin la bobina, $C_1$ y $C_2$ estarían simplemente en paralelo: más capacidad, sí, pero el rizado solo bajaría a la mitad. La bobina multiplica el efecto porque se opone _más_ cuanto más rápido es el vaivén.
  - En las fuentes de válvulas, de cientos de voltios y poca corriente, el filtro en pi con un choque de varios henrios era lo normal. En una fuente de transistores de 12 V y medio amperio, la bobina sería grande y cara, y casi siempre se prefiere el regulador que viene ahora.
]

Guarda la forma de esta red: un condensador a masa, una bobina en serie y otro condensador a masa. Volverá a aparecer en el transmisor, con otro oficio, en #ver(<sec-redes-adaptacion>).

#ptitulo[Paso 4, sub-circuito 4: el zéner, la ruptura domesticada] El diodo *zéner* se fabrica para que su ruptura inversa ocurra a una tensión precisa (5,6 V, 12 V…) y la soporte sin daño. Su gracia: en ruptura, la tensión en sus bornes se queda _clavada_ en ese valor aunque la corriente varíe mucho. Conectado en inversa tras una resistencia (@i2a-fig-zener), reparte el trabajo así: la resistencia deja pasar una corriente aproximadamente fija; la carga toma la que necesita, y el zéner se _come la diferencia_ para mantener sus 12 V exactos. Si la carga pide más, el zéner cede parte de su ración; si la entrada sube, el zéner engulle el exceso. Un regulador integrado de tres terminales (78xx) hace lo mismo con más finura, pero el principio es este. #falstad("zeneriv.txt", texto: [La curva del zéner])

#circuito(caption: [Estabilizador con zéner. La resistencia trae unos 53 mA ($(20 - 12) slash 150$); la carga toma sus 30 mA y el zéner, trabajando en ruptura, absorbe los 23 mA sobrantes para dejar la tensión clavada en 12 V. Si la entrada sube o la carga varía, es la ración del zéner la que se ajusta.], sim: "zenerref.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    node("i1", (0, 2), fill: false)
    node("i2", (0, 0), fill: false)
    content((-0.2, 1), anchor: "east", align(right, _i2a-t[∼20 V con \ rizado, de la fuente]))
    wire((0, 2), (0.8, 2))
    resistor("r", (0.8, 2), (2.8, 2), label: $R space 150 Omega$)
    wire((2.8, 2), (8.0, 2))
    node("n1", (3.8, 2))
    zener("dz", (3.8, 0), (3.8, 2), label: _i2a-t[zéner 12 V])
    node("n2", (6.6, 2))
    resistor("rl", (6.6, 2), (6.6, 0), label: _i2a-t[carga])
    wire((0, 0), (8.0, 0))
    node("n3", (3.8, 0))
    node("n4", (6.6, 0))
    node("o1", (8.0, 2), fill: false)
    node("o2", (8.0, 0), fill: false)
    content((8.2, 1), anchor: "west", _i2a-t[12 V estables])
    _i2a-flecha((2.95, 2.3), (3.65, 2.3), etq: [53 mA])
    _i2a-flecha((4.2, 1.4), (4.2, 0.6), etq: [23 mA], anchor: "west")
    _i2a-flecha((6.15, 1.4), (6.15, 0.6), etq: [30 mA], anchor: "east")
  })
] <i2a-fig-zener>

#porque[
  - La resistencia y el zéner forman un divisor muy especial: el zéner no deja que su tensión pase de 12 V. Todo lo que sobra (8 V) cae en la resistencia, que por eso fija la corriente total: $8 "V" slash 150 Omega approx 53$ mA.
  - El nudo de salida reparte esa corriente: la carga toma lo que pide (30 mA) y el zéner, el resto. La tensión no cambia porque el zéner, en ruptura, mantiene 12 V con 5 mA o con 50.
  - Cuando el rizado baja la entrada a su valle (unos 17,7 V con el rizado del ejemplo), la resistencia trae solo $5,7 slash 150 approx 38$ mA: la carga sigue con sus 30 y al zéner le quedan 8. Mientras le quede algo, la salida no se mueve: el rizado se ha quedado en la resistencia.
  - El límite: si la carga pide más de lo que trae la resistencia, el zéner se queda sin corriente, sale de la ruptura y la tensión cae. Y en vacío el zéner tiene que absorber los 53 mA enteros.
]

#ejemplo(titulo: [dimensionar el zéner y la resistencia])[
  Sin carga, el zéner se traga los 53 mA: disipa $12 "V" dot 0,053 "A" approx 0,64$ W. Hace falta un zéner de 1 W; uno de 0,5 W se quemaría si se desconecta la radio. La resistencia disipa $8 "V" dot 0,053 "A" approx 0,42$ W: de 1/2 W como mínimo. Fíjate en el precio de la sencillez: en vacío, la fuente quema 1 W para no alimentar nada. Por eso el zéner solo se usa para consumos pequeños.
]

#ptitulo[El regulador integrado: un zéner con músculo] Los reguladores de tres terminales de la serie *78xx* (@i2a-fig-regulador) son la solución habitual: entrada, masa y salida. Las dos últimas cifras dan la tensión de salida: el 7805 da 5 V; el 7812, los 12 V de nuestra radio; la serie 79xx hace lo mismo con tensiones negativas. Por dentro llevan un zéner de referencia, un amplificador que compara la salida con esa referencia y un transistor de potencia en serie que deja pasar justo la corriente necesaria. Es el zéner del apartado anterior, pero con un transistor que hace el trabajo pesado: la referencia no tiene que absorber la corriente de la carga, y la fuente no gasta nada en vacío.

#circuito(caption: [Regulador integrado 7812. Entra la continua con rizado del filtro (∼20 V, con valles de unos 17,7 V) y sale una tensión fija de 12 V. Los condensadores pequeños junto a sus patas evitan que el regulador oscile y mejoran su respuesta a los cambios rápidos de consumo.], sim: "opamp-regulator.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line, rect, group, translate
    group({
      translate((0.2, 1.7))
      ejes(0, 1.9, 0, 1.2)
      onda(x => 0.75 + 0.15 * (0.5 - calc.rem(x, 0.4) / 0.4), 0, 1.7, n: 300, stroke: 1pt + col.ambar)
      content((0.9, 1.25), anchor: "south", _i2a-t[entrada: ∼20 V con rizado])
    })
    group({
      translate((5.0, 1.7))
      ejes(0, 1.9, 0, 1.2)
      onda(x => 0.5, 0, 1.7, stroke: 1pt + col.ambar)
      content((0.9, 1.25), anchor: "south", _i2a-t[salida: 12 V fijos])
    })
    node("i", (0, 1), fill: false)
    wire((0, 1), (2.8, 1))
    node("n1", (1.4, 1))
    capacitor("ci", (1.4, 1), (1.4, -0.8), label: (content: [330 nF], anchor: "south"))
    ground("g1", (1.4, -0.8))
    rect((2.8, 0.4), (4.4, 1.6), stroke: 0.9pt, fill: white)
    content((3.6, 1.1), text(size: 8pt, weight: "bold")[7812])
    content((3.0, 0.75), anchor: "west", text(size: 5.5pt)[IN])
    content((4.2, 0.75), anchor: "east", text(size: 5.5pt)[OUT])
    content((3.6, 0.55), text(size: 5.5pt)[GND])
    wire((3.6, 0.4), (3.6, -0.8))
    ground("g2", (3.6, -0.8))
    wire((4.4, 1), (7.4, 1))
    node("n2", (5.8, 1))
    capacitor("co", (5.8, 1), (5.8, -0.8), label: [100 nF])
    ground("g3", (5.8, -0.8))
    node("o", (7.4, 1), fill: false)
    content((7.5, 1), anchor: "west", _i2a-t[+12 V \ a la radio])
  })
] <i2a-fig-regulador>

#porque[
  - El transistor interno, en serie entre la entrada y la salida, se comporta como una resistencia que se ajusta sola: si la salida baja de 12 V, el amplificador lo abre más; si sube, lo cierra.
  - El rizado de la entrada se queda en ese transistor: cuando la entrada está en su cresta (20 V), cae en él 8 V; en el valle (17,7 V), 5,7 V. La salida no se entera.
  - Necesita margen: un 78xx deja de regular si la entrada baja a menos de unos 2 V por encima de la salida. Con 12 V de salida, los valles de la entrada no deben bajar de unos 14 V. Por eso el condensador de filtro sigue haciendo falta: el regulador remata el rizado, no lo sustituye.
  - La diferencia de tensión por la corriente se convierte en calor: con 0,5 A, $(20 - 12) dot 0,5 = 4$ W. El regulador va atornillado a un radiador.
]

#figure(
  table(
    columns: (auto, 1fr),
    align: (left, left),
    [*Si falta o falla…*], [*…lo que notas*],
    [el transformador], [No hay salida. Y sin él (la radio conectada a la red directamente) el chasis estaría a tensión de red: peligro de muerte.],
    [un diodo del puente, abierto], [La fuente trabaja en media onda: el rizado se duplica y baja a 50 Hz; el zumbido se hace más grave.],
    [un diodo del puente, en cortocircuito], [En el semiciclo en que debía bloquear, cortocircuita el secundario a través de otro diodo: se funde el fusible.],
    [el condensador de filtro (seco o abierto)], [Rizado grande: zumbido de 100 Hz en el auricular; con consumo alto, la radio «ronca».],
    [el regulador o el zéner], [La tensión sigue a la red y al consumo: la radio cambia de tono al subir el volumen y el rizado que quedaba llega a los transistores.],
  ),
  caption: [La fuente, pieza a pieza: el síntoma de cada avería.],
) <i2a-tab-averias>

#ejercicio(sol: [Con puente, el condensador se recarga a 100 Hz (dos crestas por ciclo de red); con media onda, a 50 Hz. La media onda deja al condensador sosteniendo el doble de tiempo entre crestas, luego necesita el doble de capacidad para el mismo rizado —~segundo motivo, tras el aprovechamiento, para preferir el puente.])[
  En la fuente de la @i2a-fig-fuente, ¿a qué frecuencia se recarga el condensador de filtro con red de 50 Hz? ¿Y si en vez del puente usáramos el rectificador de media onda? ¿Cuál de los dos casos necesita más capacidad para el mismo rizado?
]

#ojo[
  Las preguntas de fuentes giran en torno a cuatro ideas: el puente usa *cuatro diodos* y rectifica *onda completa*; tras el puente, el rizado tiene el *doble* de la frecuencia de red (100 Hz); el rizado *baja* al aumentar la capacidad o al reducir el consumo ($Delta v = I Delta t slash C$); y el zéner trabaja en *inversa*, en su zona de ruptura. El orden de las etapas tampoco falla: transformador → rectificador → filtro → regulador.
]

=== La familia del diodo

La misma unión PN, explotada por sus distintos talentos, da toda una familia que el temario pregunta (@i2a-fig-familia): el *LED*, donde cada recombinación en directa emite un fotón (la corriente se convierte en luz); el *varicap*, que trabaja en inversa usando la zona de deplexión como aislante de un condensador cuyo espesor crece con la tensión —~más tensión inversa, menos capacidad: un condensador _gobernado por tensión_, que es quien sintoniza los receptores modernos y desvía los VCO de FM del capítulo anterior~—; y el diodo *detector* que ya conoces, escogido rápido y de bajo codo (germanio o Schottky) para rectificar señales de microvatios. Una sola física, cuatro oficios. #falstad("varactor.txt", texto: [El varicap en Falstad])

#let _i2a-varicap(x0, y0) = {
  import zap: *
  import cetz.draw: line, rect, on-layer
  diode("dv", (x0, y0), (x0 + 1.8, y0))
  on-layer(2, {
    rect((x0 + 1.135, y0 - 0.05), (x0 + 1.215, y0 + 0.05), fill: white, stroke: none)
    line((x0 + 1.225, y0 - 0.25), (x0 + 1.225, y0 + 0.25), stroke: 0.8pt)
  })
}

#circuito(caption: [La familia del diodo. El LED y el detector trabajan en directa; el varicap y el zéner, en inversa. El varicap es un condensador cuya capacidad baja al subir la tensión inversa; el zéner, una tensión fija.])[
  #grid(
    columns: 4,
    column-gutter: 0.9cm,
    _i2a-celda([*LED* \ directa: luz], { import zap: *; led("d", (0, 0), (1.8, 0)) }),
    _i2a-celda([*varicap* \ inversa: capacidad variable], _i2a-varicap(0, 0)),
    _i2a-celda([*zéner* \ inversa en ruptura: tensión fija], { import zap: *; zener("d", (0, 0), (1.8, 0)) }),
    _i2a-celda([*detector* (Schottky) \ directa, codo bajo], { import zap: *; schottky("d", (0, 0), (1.8, 0)) }),
  )
] <i2a-fig-familia>

== Redes de adaptación: L, pi y T <sec-redes-adaptacion>

#motivacion(titulo: [«Las redes en pi y en T: ¿qué son?»])[
  Son la respuesta al último problema de la cadena del transmisor. El amplificador final de tu equipo está hecho para entregar sus 100 W a una carga de 50 Ω exactos. La antena casi nunca es de 50 Ω exactos: un dipolo usado fuera de su frecuencia de resonancia puede presentar unos 20 Ω con una gran reactancia; un hilo largo alimentado por un extremo, miles de ohmios; y cada antena cambia al cambiar de banda. Entre el transmisor y la antena hace falta un traductor que, a la frecuencia de trabajo, haga que la antena _parezca_ de 50 Ω. Con bobinas y condensadores se puede construir un traductor así, sin pérdidas y ajustable. Y, ya que está ahí, que quite los armónicos.
]

=== Por qué todo es de 50 Ω

#ptitulo[La máxima transferencia de potencia] Todo generador tiene una resistencia interna $R_g$. La potencia que llega a una carga $R_L$ es
$ P_L = V^2 R_L / (R_g + R_L)^2 . $
Si la carga es muy pequeña, circula mucha corriente, pero casi toda la potencia se queda en $R_g$; si es muy grande, la corriente es tan pequeña que llega poco. Entre los dos extremos hay un máximo, y está justo en $R_L = R_g$ (@i2a-fig-maxpot): es la condición de *máxima transferencia de potencia* que el capítulo anterior presentó (#ver(<sec-impedancia>)). Con reactancias en juego, la condición completa es que la carga tenga la misma resistencia y la reactancia _opuesta_: por eso una red de adaptación tiene que hacer dos cosas, transformar la resistencia y cancelar la reactancia.

#circuito(caption: [Potencia entregada a la carga, relativa a la máxima, frente al cociente $R_L slash R_g$. El máximo está en $R_L = R_g$. Con la carga al doble o a la mitad se pierde solo un 11 %; a la cuarta parte o al cuádruple, un 36 %.])[
  #cetz.canvas({
    import cetz.draw: *
    ejes(0, 7.2, 0, 2.9, etq-x: $R_L slash R_g$, etq-y: $P_L slash P_"máx"$)
    let f(x) = 4 * x / calc.pow(1 + x, 2)
    onda(x => 2.4 * f(x), 0.01, 6.8, n: 300, stroke: 1.3pt + col.senal1)
    line((1, 0), (1, 2.4), stroke: (dash: "dotted", thickness: 0.6pt))
    line((0, 2.4), (6.8, 2.4), stroke: (dash: "dashed", thickness: 0.4pt, paint: col.gris))
    for x in (1, 2, 4, 6) {
      line((x, 0), (x, -0.08), stroke: 0.6pt)
      content((x, -0.12), anchor: "north", text(size: 7pt, str(x)))
    }
    content((-0.08, 2.4), anchor: "east", text(size: 7pt)[1])
    content((1.1, 2.55), anchor: "south-west", text(size: 7pt, fill: col.senal1)[máximo: $R_L = R_g$])
  })
] <i2a-fig-maxpot>

#ptitulo[Por qué precisamente 50 Ω] Un amplificador de potencia no se construye con una resistencia interna de 50 Ω: se diseña para dar su potencia nominal, con buen rendimiento, _cuando su carga es de 50 Ω_. El número sale del cable coaxial: un coaxial con aislante de aire pierde menos señal hacia los 77 Ω y aguanta más potencia hacia los 30 Ω; 50 Ω es el compromiso. Una vez elegido, toda la estación se fabrica para él: la salida del transceptor, el cable, el medidor de ROE, el amplificador lineal, la carga artificial y la entrada del acoplador. Así cualquier pieza se conecta a cualquier otra sin cálculos (es la pregunta T6.19: la línea debe tener la misma impedancia que el transmisor y que la antena).

#ptitulo[Qué pasa si la antena no es de 50 Ω] Que no toda la potencia entra en ella: parte se *refleja* y vuelve por el cable hacia el transmisor. La fracción reflejada se calcula con el coeficiente de reflexión $Gamma = (Z_L - Z_0) slash (Z_L + Z_0)$: se refleja $abs(Gamma)^2$ de la potencia, y la onda que va y la que vuelve forman en el cable una onda estacionaria, que se mide como *ROE* $= (1 + abs(Gamma)) slash (1 - abs(Gamma))$ (todo ello en el tema T6). Para el transmisor, el problema es que ya no ve los 50 Ω para los que está diseñado. Con una carga alta, las tensiones en los transistores de salida (o en la placa de la válvula) suben por encima de lo previsto; con una carga baja, suben las corrientes. En los dos casos, el final se calienta y puede averiarse. Por eso los transceptores modernos miden la ROE y reducen la potencia solos cuando sube: si tu equipo «no da potencia» en una banda, mira la antena.

#ejemplo(titulo: [una antena de 200 Ω en un cable de 50 Ω])[
  $Gamma = (200 - 50) slash (200 + 50) = 0,6$. Se refleja $0,6^2 = 0,36$: el 36 % de la potencia que llega a la antena vuelve hacia el transmisor. La ROE es $(1 + 0,6) slash (1 - 0,6) = 4$, es decir, 4:1. Muchos transceptores empiezan a reducir la potencia a partir de 2:1 o 3:1, según el modelo: con esta antena, el equipo se protegería y daría bastante menos de sus 100 W.
]

#ptitulo[La primera herramienta: el transformador] El transformador cambia impedancias con el cuadrado de la relación de espiras (#ver(<sec-transformador>)): para que 200 Ω parezcan 50, basta una relación de espiras 2:1 (impedancias 4:1). En RF se usa mucho, con núcleo de ferrita: los *baluns* y los transformadores de banda ancha de los amplificadores de transistores. Pero tiene tres límites: solo da relaciones fijas, no cancela la reactancia de la antena, y no quita armónicos. Cuando la antena cambia con la banda y tiene reactancia, hace falta algo ajustable: una red de bobinas y condensadores. Las bobinas y los condensadores ideales no disipan potencia, se pueden hacer variables, cancelan reactancias y, bien colocados, filtran.

=== La red en L: la más sencilla

#analogia[
  Una palanca. Con el brazo largo en un lado y el corto en el otro, poca fuerza con mucho recorrido se convierte en mucha fuerza con poco recorrido: la potencia es la misma, cambia la relación entre fuerza y movimiento. La red en L hace lo mismo con la tensión y la corriente: en el lado de 200 Ω hay más tensión y menos corriente; en el de 50 Ω, menos tensión y más corriente; la potencia pasa entera. La diferencia con la palanca es que esta «palanca» está afinada a _una_ frecuencia: en otra banda hay que reajustarla.
]

#ptitulo[La idea] Dos elementos: uno en *paralelo* con la resistencia alta y otro en *serie* con la baja (@i2a-fig-red-l). El elemento en paralelo «rebaja» la resistencia alta: a una frecuencia dada, una resistencia con una reactancia en paralelo equivale a una resistencia _menor_ con una reactancia en serie. Si se elige bien el elemento en paralelo, esa resistencia menor es justo la baja (50 Ω), y solo sobra la reactancia en serie, que el segundo elemento, de tipo contrario, cancela. El cálculo cabe en tres fórmulas:
#destacada($ Q = sqrt(R_"alta" / R_"baja" - 1), quad X_s = Q R_"baja", quad X_p = R_"alta" / Q $, nota: [$X_s$: reactancia del elemento en serie; $X_p$: la del elemento en paralelo])
$Q$ mide cuánto se «estira» la palanca: cuanto mayor es la relación entre las dos resistencias, mayor es $Q$.

#circuito(caption: [Red en L que adapta un transmisor de 50 Ω a una antena de 200 Ω a 7 MHz. El elemento en paralelo ($C$) va en el lado de la resistencia alta; el elemento en serie ($L$), en el de la baja. Con la bobina en serie y el condensador a masa, la red es además un paso bajo.], sim: ((fc.at("red-L"), [esta red L]), ("tlmatch1.txt", [otra red L, 75 → 300 Ω])))[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    acvsource("v", (0, 0), (0, 2))
    wire((0, 2), (0, 2.6), (0.4, 2.6))
    resistor("rg", (0.4, 2.6), (2.2, 2.6), label: $50 Omega$)
    wire((2.2, 2.6), (2.8, 2.6))
    inductor("l", (2.8, 2.6), (4.8, 2.6), label: $L space 1,97 "μH"$)
    wire((4.8, 2.6), (7.2, 2.6))
    node("n", (5.8, 2.6))
    capacitor("c", (5.8, 2.6), (5.8, 0), label: (content: $C space 197 "pF"$, anchor: "south"))
    resistor("ra", (7.2, 2.6), (7.2, 0), label: [antena \ 200 Ω])
    wire((7.2, 0), (0, 0))
    node("n2", (5.8, 0))
    content((-0.7, 1.0), anchor: "east", _i2a-t[transmisor])
    line((2.5, -0.3), (2.5, 3.2), stroke: (paint: col.senal2, thickness: 0.6pt, dash: "dashed"))
    content((2.5, -0.35), anchor: "north", _i2a-t(color: col.senal2)[mirando a la derecha desde aquí: 50 Ω])
  })
] <i2a-fig-red-l>

#ejemplo(titulo: [50 Ω → 200 Ω a 7 MHz])[
  $Q = sqrt(200 slash 50 - 1) = sqrt(3) approx 1,73$.
  Elemento en serie: $X_s = 1,73 dot 50 approx 86,6$ Ω; como bobina, $L = X_s slash (2 pi f) = 86,6 slash (2 pi dot 7 times 10^6) approx 1,97$ μH.
  Elemento en paralelo: $X_p = 200 slash 1,73 approx 115,5$ Ω; como condensador, $C = 1 slash (2 pi f X_p) approx 197$ pF.
  Comprobación: 200 Ω en paralelo con −j115,5 Ω equivalen a $50 - j 86,6$ Ω; la bobina suma $+j 86,6$ Ω y quedan 50 Ω justos.
]

#porque[
  - El condensador, en paralelo con los 200 Ω, se lleva parte de la corriente desfasada 90°: visto desde la bobina, el conjunto ya no es 200 Ω, sino 50 Ω con una reactancia capacitiva de 86,6 Ω en serie.
  - La bobina, en serie, tiene la reactancia opuesta (+86,6 Ω) y la cancela: el transmisor ve una resistencia pura de 50 Ω.
  - Solo a 7 MHz: a otra frecuencia, las reactancias cambian, la cancelación falla y la ROE sube. Por eso un acoplador se reajusta en cada banda.
  - Si se cambian los papeles (condensador en serie y bobina en paralelo), la adaptación es la misma, pero la red pasa a ser un paso alto. Y el elemento en paralelo siempre va en el lado de la resistencia _alta_: en el otro lado no hay solución.
]

#ptitulo[El límite de la L: no eliges Q] En la red en L, $Q$ lo dicta la relación de resistencias. Para pasar de 50 a 55 Ω, $Q approx 0,32$: la red es casi transparente y apenas filtra armónicos. Para pasar de 50 a 2500 Ω, $Q = 7$: la red es estrecha y crítica, y las corrientes que circulan por sus elementos son grandes. A veces se querría un $Q$ distinto del que impone la relación: más alto para filtrar mejor, más bajo para tener más ancho de banda y menos pérdidas. Para eso hace falta un tercer elemento.

=== La red en pi: dos condensadores a masa y una bobina en serie

#ptitulo[Dos L espalda con espalda] Imagina dos redes en L puestas en cadena. La primera baja la resistencia alta del final hasta una resistencia intermedia _virtual_ $R_v$, más baja que las de los dos extremos; la segunda sube esa $R_v$ hasta los 50 Ω de la antena. Las dos L ponen su elemento en paralelo hacia fuera (en los extremos, donde la resistencia es mayor) y sus dos bobinas en serie quedan juntas en el centro: se suman en una sola. El resultado es la *red en pi* (@i2a-fig-red-pi): condensador a masa, bobina en serie, condensador a masa. Y aquí está la ganancia: $R_v$ la eliges tú, y con ella eliges $Q$, independientemente de la relación de resistencias.

#circuito(sim: fc.at("red-pi"), caption: [Red en pi a la salida de un final de válvula: adapta los 2500 Ω de placa a 50 Ω a 7 MHz con $Q = 12$. La bobina se ha dibujado partida en dos para ver las dos redes en L que la forman: en el punto central la resistencia vista es la virtual $R_v approx 17$ Ω, más baja que las de los extremos. $C_1$ es el mando de sintonía (TUNE o PLATE) y $C_2$, el de carga (LOAD).])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    node("i", (0, 2.4), fill: false)
    content((-0.15, 2.4), anchor: "east", align(right, _i2a-t[del final \ 2500 Ω]))
    wire((0, 2.4), (1.2, 2.4))
    node("n1", (1.2, 2.4))
    capacitor("c1", (1.2, 2.4), (1.2, 0.2), variable: true, label: (content: [$C_1$ 109 pF \ sintonía], anchor: "south"))
    ground("g1", (1.2, 0.2))
    inductor("l1", (1.2, 2.4), (3.4, 2.4), label: $L_1$)
    inductor("l2", (3.6, 2.4), (5.4, 2.4), label: $L_2$)
    wire((3.4, 2.4), (3.6, 2.4))
    line((3.5, 1.9), (3.5, 3.3), stroke: (paint: col.senal2, thickness: 0.6pt, dash: "dashed"))
    content((3.5, 1.85), anchor: "north", _i2a-t(color: col.senal2)[$R_v approx 17 Omega$])
    wire((5.4, 2.4), (6.8, 2.4))
    node("n2", (5.9, 2.4))
    capacitor("c2", (5.9, 2.4), (5.9, 0.2), variable: true, label: [$C_2$ 627 pF \ carga])
    ground("g2", (5.9, 0.2))
    node("o", (6.8, 2.4), fill: false)
    content((6.95, 2.4), anchor: "west", _i2a-t[a la antena \ 50 Ω])
    content((3.4, 3.35), anchor: "south", _i2a-t[$L = L_1 + L_2 approx 5,2 "μH"$])
  })
] <i2a-fig-red-pi>

#porque[
  - $C_1$ y $L_1$ forman una L que baja los 2500 Ω a $R_v = 2500 slash (1 + 12^2) approx 17$ Ω. Con $Q = 12$, $X_(C_1) = 2500 slash 12 approx 208$ Ω, es decir, 109 pF a 7 MHz.
  - $L_2$ y $C_2$ forman otra L que sube esos 17 Ω a 50 Ω, con su propio $Q$ pequeño ($sqrt(50 slash 17 - 1) approx 1,4$). $C_2$ es mucho mayor que $C_1$ (627 pF) porque trabaja en el lado de baja impedancia.
  - Las dos bobinas, en serie y juntas, son una sola de unos 5,2 μH.
  - Para los armónicos, la red es un paso bajo: al doble de frecuencia, los condensadores tienen la mitad de reactancia (desvían más a masa) y la bobina el doble (frena más). Con estos valores, el cálculo da el segundo armónico unos 30 dB más débil y el tercero unos 42 dB.
]

#ptitulo[Por qué la pi es la red del transmisor] Porque hace dos trabajos a la vez: adapta y filtra. Un amplificador de RF potente, sobre todo en clase B o C (#ver(<sec-clases>)), genera armónicos: a 7 MHz, también algo de señal en 14, 21, 28 MHz, que caerían en otras bandas y en otros servicios. La pi deja pasar la fundamental y frena los armónicos (@i2a-fig-armonicos). En los equipos de válvulas es la red de salida clásica, con sus dos mandos en el frontal: se ajusta _sintonía_ ($C_1$) buscando el mínimo («dip») de la corriente de placa y luego _carga_ ($C_2$) hasta la corriente correcta, y se repite. En los equipos de transistores, que trabajan con impedancias de pocos ohmios, un transformador de banda ancha hace la mayor parte de la relación de impedancias y tras él va un filtro paso bajo con la misma forma en pi (normalmente varios en cadena, conmutados por banda) para limpiar los armónicos.

#circuito(caption: [Respuesta de una red en pi (paso bajo): deja pasar la frecuencia de trabajo $f_0$ y atenúa cada vez más los armónicos $2 f_0$, $3 f_0$… (curva cualitativa).])[
  #cetz.canvas({
    import cetz.draw: *
    ejes(0, 6.6, 0, 2.6, etq-x: $f$, etq-y: [salida])
    let h(x) = 2.1 / calc.sqrt(1 + calc.pow(x / 1.9, 6))
    onda(h, 0, 6.2, n: 300, stroke: 1.3pt + col.senal1)
    for (k, c) in ((1, col.senal3), (2, col.senal2), (3, col.senal2), (4, col.senal2)) {
      let x = 1.4 * k
      line((x, 0), (x, h(x)), stroke: 2pt + c)
      content((x, -0.1), anchor: "north", text(size: 7.5pt, if k == 1 { $f_0$ } else { $#k f_0$ }))
    }
    content((1.55, 2.2), anchor: "south-west", text(size: 7pt, fill: col.senal3)[pasa])
    content((3.0, 0.9), anchor: "south-west", text(size: 7pt, fill: col.senal2)[armónicos atenuados])
  })
] <i2a-fig-armonicos>

#ptitulo[La misma forma, otro oficio] Fíjate en que el filtro en pi de la fuente (@i2a-fig-pi-fuente) tiene _exactamente_ la misma forma: condensador a masa, bobina en serie, condensador a masa. Allí, la frecuencia que se quiere conservar es 0 Hz (la continua) y la que se quiere eliminar, el rizado de 100 Hz; aquí, se conservan 7 MHz y se eliminan 14, 21 y 28 MHz. En los dos casos es un paso bajo: lo que cambian son los valores y, por tanto, la frecuencia de corte.

=== La red en T: dos condensadores en serie y una bobina a masa

#ptitulo[La L doble, al revés] Si las dos redes en L se ponen al revés, con una resistencia virtual _más alta_ que las de los extremos, los elementos en serie quedan fuera y los dos elementos en paralelo se juntan en el centro: es la *red en T* (@i2a-fig-red-t). La versión que usan los radioaficionados tiene dos condensadores variables en serie y una bobina variable a masa (a menudo una bobina «de rodillo», con un contacto que se desliza por las espiras): es el *acoplador en T* (_T-match_), el más común de los acopladores de antena manuales.

#circuito(sim: fc.at("red-T"), caption: [Acoplador de antena en T. Dos condensadores variables en serie y una bobina variable a masa: con tres mandos, adapta a 50 Ω antenas de impedancias muy distintas. Es un paso alto: no quita armónicos.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    node("i", (0, 2.4), fill: false)
    content((-0.15, 2.4), anchor: "east", align(right, _i2a-t[del transmisor \ (50 Ω)]))
    capacitor("c1", (0, 2.4), (2.4, 2.4), variable: true, label: $C_1$)
    wire((2.4, 2.4), (3.2, 2.4))
    node("n", (3.2, 2.4))
    inductor("l", (3.2, 2.4), (3.2, 0.2), label: [$L$ \ (de rodillo)])
    ground("g", (3.2, 0.2))
    wire((3.2, 2.4), (4.0, 2.4))
    capacitor("c2", (4.0, 2.4), (6.4, 2.4), variable: true, label: $C_2$)
    node("o", (6.4, 2.4), fill: false)
    content((6.55, 2.4), anchor: "west", _i2a-t[a la antena \ (casi cualquier Z)])
  })
] <i2a-fig-red-t>

#porque[
  - Es una L doble: $C_1$ y $L$ suben los 50 Ω hasta una resistencia virtual alta; $L$ y $C_2$ la bajan hasta la impedancia de la antena. Como en la pi, la resistencia virtual (y con ella $Q$) la decides tú con los mandos.
  - Con tres elementos variables cubre un margen enorme de impedancias, de pocos ohmios a miles, y con valores de componentes razonables: por eso es la favorita de los acopladores manuales.
  - Los condensadores en serie bloquean la continua entre el transmisor y la antena.
  - Su punto débil: es un paso alto (condensadores en serie, bobina a masa), así que no ayuda contra los armónicos; el filtro paso bajo del transmisor sigue haciendo falta. Y hay muchas combinaciones de mandos que dan ROE 1:1; algunas con $Q$ muy alto, corrientes grandes y pérdidas que calientan la bobina. La regla práctica: de las combinaciones que adaptan, quédate con la que usa _más_ capacidad, que es la de menor $Q$ y menores pérdidas.
]

#ptitulo[Q: ancho de banda contra limpieza] El tercer elemento, en la pi o en la T, existe para poder elegir $Q$. Un $Q$ alto da una red estrecha: filtra mejor los armónicos y lo que esté lejos de la frecuencia de trabajo, pero hay que reajustarla en cuanto te mueves por la banda, y las corrientes que circulan entre bobina y condensadores son grandes (más pérdidas, más calor, más tensión en los condensadores). Un $Q$ bajo da una red ancha, cómoda y de pocas pérdidas, que filtra poco. En las redes en pi de los finales de válvulas se trabaja con un $Q$ de 10 a 12, un compromiso clásico entre las dos cosas.

=== Dónde trabaja cada una

#circuito(caption: [Las tres redes en una estación. En la fuente, un filtro en pi (paso bajo para el rizado). A la salida del amplificador final, la red en pi (o un filtro paso bajo en pi): adapta y quita armónicos. Fuera del transceptor, en orden: medidor de ROE, acoplador de antena (normalmente en T; los automáticos suelen ser redes en L conmutadas con relés) y antena. Entre bloques, cable coaxial de 50 Ω.])[
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (9mm, 9mm),
    node((0, 1), align(center, text(size: 7.5pt)[fuente \ (filtro en pi CLC)]), shape: rect, inset: 5pt, fill: col.ambar-claro, name: <f>),
    node((0, 0), align(center, text(size: 7.5pt)[amplificador \ final]), shape: rect, inset: 5pt, name: <pa>),
    node((1, 0), align(center, text(size: 7.5pt)[red en pi \ (paso bajo)]), shape: rect, inset: 5pt, fill: col.acento-claro, name: <pi>),
    node((2, 0), align(center, text(size: 7.5pt)[medidor \ de ROE]), shape: rect, inset: 5pt, name: <roe>),
    node((3, 0), align(center, text(size: 7.5pt)[acoplador \ en T]), shape: rect, inset: 5pt, fill: col.acento-claro, name: <t>),
    node((4, 0), text(size: 7.5pt)[antena], stroke: none, name: <ant>),
    node((0.5, -0.75), text(size: 7pt, fill: col.gris)[dentro del transceptor], stroke: none),
    edge(<f>, <pa>, "-|>", stroke: 0.9pt + col.ambar, label: text(size: 6.5pt, fill: col.ambar)[continua], label-side: left),
    edge(<pa>, <pi>, "-|>", stroke: 0.9pt + col.senal1),
    edge(<pi>, <roe>, "-|>", stroke: 0.9pt + col.senal1, label: text(size: 6.5pt)[50 Ω]),
    edge(<roe>, <t>, "-|>", stroke: 0.9pt + col.senal1, label: text(size: 6.5pt)[50 Ω]),
    edge(<t>, <ant>, "-|>", stroke: 0.9pt + col.senal1),
  )
] <i2a-fig-estacion>

#figure(
  table(
    columns: (auto, 1.5fr, 0.9fr, 0.9fr, 1.5fr),
    align: (left, left, left, left, left),
    [*Red*], [*Elementos*], [*Filtro*], [*Q*], [*Dónde la encuentras*],
    [L], [uno en serie y uno en paralelo (en el lado de mayor resistencia)], [paso bajo o paso alto], [fijado por la relación], [adaptaciones sencillas; acopladores automáticos],
    [pi], [C a masa, L en serie, C a masa], [paso bajo], [elegible], [salida del final; filtros de armónicos; filtro de la fuente (CLC)],
    [T], [C en serie, L a masa, C en serie], [paso alto], [elegible], [acoplador de antena manual (T-match)],
  ),
  caption: [Las tres redes de adaptación, comparadas.],
) <i2a-tab-redes>

#idea[
  Una red de adaptación es un traductor de impedancias hecho con bobinas y condensadores: a una frecuencia, hace que la antena parezca de 50 Ω para que el final entregue toda su potencia sin sufrir. La L es la mínima (dos elementos, $Q$ impuesto); la pi y la T añaden un tercer elemento para poder elegir $Q$. La pi, además, es un paso bajo y limpia los armónicos; la T es un paso alto y no los limpia.
]

#ojo[
  - *Pi = paso bajo = atenúa armónicos.* El esquema con un condensador variable a masa, una bobina en serie y otro condensador variable a masa, entre transmisor y antena, es la «red en pi» del acoplador o de la salida del final (pregunta T6.23).
  - *T = acoplador de antena* manual: dos condensadores en serie y una bobina a masa; es paso alto.
  - El acoplador *no mejora la antena*: mejora la transferencia de potencia entre el final y la línea (T6.15). La antena sigue siendo la misma; el cable entre el acoplador y la antena sigue teniendo ROE.
  - El orden de la estación: transceptor → medidor de ROE → acoplador → antena (T6.17). Entre el final y la antena van una red de adaptación y un filtro paso bajo (C-T5.3).
  - En una red en L, el elemento en paralelo va en el lado de la resistencia más alta.
]
