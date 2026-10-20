#import "/lib/template.typ": *
#import "/lib/falstad-custom.typ": fc
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Utilidades locales de intro-2b (prefijo _i2b-)
//  Convenio del capítulo: la continua en ámbar, la señal en azul.
// ---------------------------------------------------------------------
#let _i2b-t(c, color: col.tinta, size: 7.5pt) = text(size: size, fill: color, c)
// Rótulo de componente (un poco menor que el texto, para que no se pisen).
#let _i2b-e(c) = text(size: 8.5pt, c)

// Flecha coloreada (corriente continua en ámbar, señal en azul) con rótulo opcional.
#let _i2b-flecha(a, b, color: col.ambar, etq: none, anchor: "south", dist: 2pt) = {
  import cetz.draw: line, content
  line(a, b, stroke: 0.9pt + color, mark: (end: ">", fill: color, scale: 0.55))
  if etq != none {
    content((a, 50%, b), anchor: anchor, padding: dist, text(size: 7pt, fill: color, etq))
  }
}

// JFET dibujado a mano (zap no lo trae). Un nodo: el centro del canal.
// Anclas: "d" (drenador, arriba), "s" (fuente, abajo), "g" (puerta, izquierda).
#let _i2b-jfet(nombre, pos, canal: "n") = {
  import cetz.draw: *
  group(name: nombre, {
    set-origin(pos)
    line((0, -0.5), (0, 0.5), stroke: 1.5pt)
    line((0, 0.35), (0.5, 0.35), (0.5, 0.75), stroke: 0.6pt)
    line((0, -0.35), (0.5, -0.35), (0.5, -0.75), stroke: 0.6pt)
    if canal == "n" {
      line((-0.75, -0.35), (-0.02, -0.35), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
    } else {
      line((-0.02, -0.35), (-0.75, -0.35), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
    }
    anchor("d", (0.5, 0.75))
    anchor("s", (0.5, -0.75))
    anchor("g", (-0.75, -0.35))
  })
}

// MOSFET dibujado a mano: canal N, de enriquecimiento ("enr"), de empobrecimiento ("emp")
// o de doble puerta ("doble"). Anclas: "d", "s", "g" (o "g1" y "g2").
#let _i2b-mosfet(nombre, pos, tipo: "enr") = {
  import cetz.draw: *
  group(name: nombre, {
    set-origin(pos)
    // canal
    if tipo == "enr" {
      for (a, b) in ((0.3, 0.55), (-0.12, 0.12), (-0.55, -0.3)) { line((0.18, a), (0.18, b), stroke: 1.5pt) }
    } else {
      line((0.18, -0.55), (0.18, 0.55), stroke: 1.5pt)
    }
    // drenador y fuente
    line((0.18, 0.42), (0.6, 0.42), (0.6, 0.85), stroke: 0.6pt)
    line((0.18, -0.42), (0.6, -0.42), (0.6, -0.85), stroke: 0.6pt)
    // sustrato unido a la fuente, flecha hacia el canal (canal N)
    line((0.6, 0), (0.2, 0), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.55))
    line((0.6, 0), (0.6, -0.42), stroke: 0.6pt)
    // puerta(s), separadas del canal por el óxido
    if tipo == "doble" {
      line((0, 0.1), (0, 0.55), stroke: 1pt)
      line((0, -0.1), (0, -0.55), stroke: 1pt)
      line((-0.7, 0.45), (0, 0.45), stroke: 0.6pt)
      line((-0.7, -0.45), (0, -0.45), stroke: 0.6pt)
      anchor("g2", (-0.7, 0.45))
      anchor("g1", (-0.7, -0.45))
    } else {
      line((0, -0.55), (0, 0.55), stroke: 1pt)
      line((-0.7, -0.42), (0, -0.42), stroke: 0.6pt)
      anchor("g", (-0.7, -0.42))
    }
    anchor("d", (0.6, 0.85))
    anchor("s", (0.6, -0.85))
  })
}

== El transistor: el grifo que amplifica <sec-transistor>

#motivacion(titulo: [microvoltios que tienen que convertirse en voltios])[
  La onda de una emisora lejana induce en la antena de nuestra radio unos pocos *microvoltios*. El auricular necesita del orden de un *voltio* para sonar, y un altavoz, vatios. En el transmisor pasa lo mismo al revés: el oscilador entrega milivatios y la antena pide 100 W. Entre la antena y el oído hay un factor de un millón en tensión.

  Ninguna de las piezas que conoces consigue eso. Resistencias, condensadores, bobinas, transformadores y diodos son componentes *pasivos*: reparten, guardan o pierden la energía que les llega, pero nunca añaden. El transformador sube la tensión, sí, pero baja la corriente en la misma proporción (#ver(<sec-transformador>)): la potencia que sale nunca supera la que entra. El tanque resonante multiplica la tensión por su $Q$, pero tampoco crea energía; solo la acumula. La señal de la antena trae una potencia minúscula, y con eso no se mueve ningún altavoz. Hace falta una pieza que *tome la energía de otro sitio* —~la fuente de alimentación~— y la entregue con la *forma* de la señal.
]

#ptitulo[La idea: una válvula gobernada por la señal] La pieza que buscamos tiene tres terminales: dos por los que pasa una corriente grande, que empuja la fuente de alimentación, y un tercero, el de *control*, por el que la señal débil decide _cuánta_ corriente pasa. Es lo que hace un grifo. La mano mueve la maneta casi sin esfuerzo, y el agua sale empujada por la presión de la red, no por la mano. La fuerza de la mano y el caudal no tienen nada que ver; lo único que la mano decide es la *forma* del chorro. Un amplificador es exactamente eso (@i2b-fig-valvula): la señal mueve la maneta y la fuente pone el agua. La energía de la salida sale de la fuente; de la señal solo sale la información.

#circuito(caption: [Qué hace un amplificador. La señal de entrada, minúscula, no aporta la energía de la salida: solo gobierna una válvula. La energía la pone la fuente de alimentación, y la parte que no llega a la salida se pierde en calor. A la salida aparece una copia grande de la forma de la entrada.])[
  #cetz.canvas({
    import cetz.draw: *
    // entrada
    onda(x => 0.13 * calc.sin(2 * calc.pi * x), 0, 3, stroke: 1.1pt + col.senal1)
    content((1.5, -0.45), anchor: "north", _i2b-t(color: col.senal1)[entrada: microvoltios])
    content((1.5, -0.85), anchor: "north", _i2b-t(color: col.gris)[(la información)])
    _i2b-flecha((3.2, 0), (4.3, 0), color: col.senal1)
    // válvula
    rect((4.4, -0.75), (7.4, 0.75), fill: col.acento-claro, stroke: 0.8pt + col.acento, radius: 3pt)
    content((5.9, 0.18), text(size: 8.5pt, weight: "bold", fill: col.acento)[amplificador])
    content((5.9, -0.3), _i2b-t[(una válvula)])
    // fuente
    _i2b-flecha((5.9, 2.0), (5.9, 0.8), color: col.ambar)
    content((5.9, 2.05), anchor: "south", _i2b-t(color: col.ambar)[fuente de alimentación: pone la energía])
    // pérdidas
    line((5.9, -0.8), (5.9, -1.55), stroke: (paint: col.gris, thickness: 0.8pt, dash: "dashed"), mark: (end: ">", fill: col.gris, scale: 0.55))
    content((5.9, -1.6), anchor: "north", _i2b-t(color: col.gris)[pérdidas: calor])
    // salida
    _i2b-flecha((7.5, 0), (8.6, 0), color: col.senal1)
    onda(x => 1.0 * calc.sin(2 * calc.pi * (x - 8.8)), 8.8, 11.8, stroke: 1.3pt + col.senal1)
    content((10.3, -1.1), anchor: "north", _i2b-t(color: col.senal1)[salida: voltios, la misma forma])
  })
] <i2b-fig-valvula>

#ptitulo[Del triodo al transistor] El primer grifo electrónico fue, literalmente, una válvula: en 1906 Lee de Forest colocó una rejilla metálica entre el cátodo y la placa de un diodo de vacío y obtuvo el *triodo*. Y las *válvulas* de los amplificadores de potencia veteranos son el mismo grifo con electrones volando en vacío desde un cátodo caliente, gobernados por la tensión de una rejilla. Funcionaron medio siglo, pero piden un filamento al rojo, cientos de voltios y mucho espacio. En 1947, en los laboratorios Bell, nació el *transistor*: el mismo grifo dentro de un cristal de silicio (al principio, de germanio), sin filamento, del tamaño de una lenteja y que funciona con 12 V. La @i2b-fig-triodo los pone uno al lado del otro.

#circuito(caption: [El mismo grifo en dos épocas. Izquierda: triodo; la tensión de la rejilla gobierna la corriente que va del cátodo a la placa. Derecha: transistor NPN; la corriente de la base gobierna la que entra por el colector y sale por el emisor. En los dos, la resistencia de carga convierte la corriente gobernada en una tensión de salida. Se omite la polarización (#ver(<sec-polarizacion>)).], sim: "triodeamp.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    // --- triodo ---
    triodo("v1", (2, 2.4))
    resistor("ra", (2, 5.4), (2, 3.9), label: _i2b-e($R_a$))
    wire((2, 3.9), "v1.placa")
    node("na", (2, 3.9))
    wire((2, 3.9), (3.4, 3.9))
    node("sa", (3.4, 3.9), fill: false)
    content((3.5, 3.9), anchor: "west", _i2b-t[salida])
    node("ta", (2, 5.4), fill: false, label: (content: _i2b-t[+250 V], anchor: "north"))
    wire("v1.catodo", (2, 0.9))
    ground("g1", (2, 0.9))
    wire((0.2, 2.4), "v1.rejilla")
    node("ea", (0.2, 2.4), fill: false)
    content((0.1, 2.4), anchor: "east", _i2b-t[entrada])
    content((2.85, 2.95), anchor: "west", _i2b-t(color: col.acento)[placa])
    content((1.15, 2.05), anchor: "north-east", _i2b-t(color: col.acento)[rejilla])
    content((2.15, 1.35), anchor: "west", _i2b-t(color: col.acento)[cátodo])
    // --- transistor ---
    npn("q1", (8, 2.4))
    resistor("rc", (8, 5.4), (8, 3.9), label: _i2b-e($R_C$))
    wire((8, 3.9), "q1.c")
    node("nc", (8, 3.9))
    wire((8, 3.9), (9.4, 3.9))
    node("sc", (9.4, 3.9), fill: false)
    content((9.5, 3.9), anchor: "west", _i2b-t[salida])
    node("tc", (8, 5.4), fill: false, label: (content: _i2b-t[+12 V], anchor: "north"))
    wire("q1.e", (8, 0.9))
    ground("g2", (8, 0.9))
    wire((6.2, 2.4), "q1.b")
    node("ec", (6.2, 2.4), fill: false)
    content((6.1, 2.4), anchor: "east", _i2b-t[entrada])
    content((8.15, 3.25), anchor: "west", _i2b-t(color: col.acento)[colector])
    content((7.3, 2.15), anchor: "north-east", _i2b-t(color: col.acento)[base])
    content((8.15, 1.45), anchor: "west", _i2b-t(color: col.acento)[emisor])
  })
] <i2b-fig-triodo>

#porque[
  - En los dos montajes la corriente grande sale de la fuente (+250 V o +12 V), baja por la resistencia de carga, cruza el dispositivo y vuelve por masa. La entrada no aporta esa corriente: solo decide cuánta pasa.
  - La *rejilla* del triodo está más cerca del cátodo que la placa: una variación pequeña de su tensión pesa más sobre los electrones que una grande de la placa. La *base* del transistor hace lo mismo con una corriente pequeña (lo vemos ahora mismo).
  - La resistencia de carga ($R_a$, $R_C$) es el traductor: la corriente que varía produce en ella una tensión que varía, $v = i R$. Sin ella la salida estaría clavada a la tensión de la fuente y no habría señal que entregar.
  - Las equivalencias valen para todo el temario: rejilla ↔ base, placa ↔ colector, cátodo ↔ emisor.
]

#ptitulo[La estructura y el truco] Un transistor bipolar NPN son dos uniones PN espalda contra espalda: *emisor* (N, muy dopado), *base* (P, finísima) y *colector* (N). Así polarizado (@i2b-fig-npn): la unión base-emisor en directa (su peaje de unos 0,6 V, como todo diodo de silicio) y la base-colector en inversa. El truco está en el espesor: el emisor inyecta electrones en la base a mansalva, pero la base es tan delgada que casi ninguno encuentra con quién recombinarse; antes de darse cuenta han llegado al borde de la unión de colector, cuyo campo —~intenso, en inversa~— los aspira. Resultado: de cada cien electrones que entran, unos noventa y nueve salen por el colector y solo uno por la base. La corriente de base es la _propina_; la de colector, el _caudal_ —~y aquí está todo: como la propina y el caudal van ligados por la física de la unión, una corriente de base pequeña gobierna una corriente de colector $beta$ veces mayor ($beta approx 100$–300, la *ganancia de corriente*). El transistor es un grifo: la señal débil mueve la maneta y la fuente de alimentación pone el agua.

#circuito(caption: [El transistor NPN por dentro. El emisor inyecta electrones; la base es tan fina que casi todos la atraviesan sin recombinarse y el colector los recoge. La pequeña fracción que sí escapa por la base es la corriente de control: gobernarla es gobernar el caudal completo, $beta$ veces mayor.])[
  #cetz.canvas({
    import cetz.draw: *
    rect((0, 0), (8, 2), fill: col.acento-claro, stroke: 0.8pt + col.tinta)
    rect((3.55, 0), (4.45, 2), fill: col.naranja-claro, stroke: 0.4pt + col.tinta)
    content((1.75, 2.1), anchor: "south", text(size: 8pt)[emisor (N)])
    content((6.25, 2.1), anchor: "south", text(size: 8pt)[colector (N)])
    content((4, -0.12), anchor: "north", text(size: 8pt, fill: col.senal2)[base (P)])
    line((0.4, 1.2), (7.2, 1.2), stroke: 1.8pt + col.senal1, mark: (end: ">", fill: col.senal1, scale: 0.8))
    content((6.25, 1.0), anchor: "north", align(center, _i2b-t(color: col.senal1)[∼99 % de los electrones \ cruza al colector]))
    line((4, 1.2), (4, 3.0), stroke: 1.2pt + col.senal2, mark: (end: ">", fill: col.senal2, scale: 0.6))
    content((4.15, 2.85), anchor: "west", _i2b-t(color: col.senal2)[∼1 % sale por la base: la corriente de control])
  })
] <i2b-fig-npn>

#ptitulo[Dos uniones con papeles opuestos] La @i2b-fig-uniones separa los dos «diodos» del transistor. La unión base-emisor está en *directa*: como en cualquier diodo (#ver(<sec-diodo>)), en cuanto su tensión pasa de unos 0,6 V la barrera se desmonta y el emisor lanza electrones hacia la base. La unión base-colector está en *inversa*: su zona de deplexión es ancha y el campo dentro de ella es intenso. Una unión en inversa no conduce porque no tiene portadores que la crucen. Aquí sí los tiene: el emisor se los deja en la misma puerta. Cada electrón que llega al borde de esa zona cae arrastrado por el campo hasta el colector, como una canica que encuentra un tobogán.

#circuito(caption: [Las dos uniones del NPN y su polarización. La unión base-emisor, en directa, tiene una zona de deplexión estrecha y deja pasar los electrones del emisor. La unión base-colector, en inversa, tiene una zona ancha con un campo intenso que arrastra al colector todo electrón que llega a su borde. El sentido de las corrientes convencionales es el contrario al de los electrones.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line, rect
    // bloques de semiconductor
    rect((0, 1.5), (3, 3.3), fill: col.acento-claro, stroke: 0.6pt)
    rect((3, 1.5), (3.8, 3.3), fill: col.naranja-claro, stroke: 0.6pt)
    rect((3.8, 1.5), (7.4, 3.3), fill: col.acento-claro, stroke: 0.6pt)
    // zonas de deplexión
    rect((2.86, 1.5), (3.1, 3.3), fill: col.gris.lighten(55%), stroke: none)
    rect((3.62, 1.5), (4.65, 3.3), fill: col.gris.lighten(55%), stroke: none)
    content((1.4, 2.95), text(size: 9pt, weight: "bold")[N#super[+]])
    content((3.35, 2.95), text(size: 9pt, weight: "bold", fill: col.senal2)[P])
    content((6.1, 2.95), text(size: 9pt, weight: "bold")[N])
    content((1.4, 1.75), _i2b-t[emisor: muy dopado])
    content((6.1, 1.75), _i2b-t[colector])
    // electrones
    line((0.35, 2.4), (6.9, 2.4), stroke: 1.6pt + col.senal1, mark: (end: ">", fill: col.senal1, scale: 0.7))
    content((5.5, 2.25), anchor: "north", _i2b-t(color: col.senal1)[electrones])
    // rótulos de las uniones
    line((2.98, 3.3), (1.5, 3.85), stroke: 0.4pt + col.gris)
    content((1.3, 3.9), anchor: "south", align(center, _i2b-t[unión base-emisor: directa \ (deplexión estrecha)]))
    line((4.15, 3.3), (5.9, 3.85), stroke: 0.4pt + col.gris)
    content((6.1, 3.9), anchor: "south", align(center, _i2b-t[unión base-colector: inversa \ (deplexión ancha, campo intenso)]))
    content((3.4, 1.25), anchor: "north-west", _i2b-t(color: col.senal2)[base: fina y poco dopada])
    // terminales y pilas
    wire((0, 2.4), (-0.7, 2.4), (-0.7, 0))
    wire((3.4, 1.5), (3.4, 0))
    wire((7.4, 2.4), (8.1, 2.4), (8.1, 0))
    content((-0.8, 2.4), anchor: "east", text(size: 8pt)[E])
    content((3.25, 0.6), anchor: "east", text(size: 8pt)[B])
    content((8.2, 2.4), anchor: "west", text(size: 8pt)[C])
    wire((-0.7, 0), (0.9, 0))
    bateria("vbe", (1.8, 0), (0.9, 0))
    wire((1.8, 0), (3.4, 0))
    wire((3.4, 0), (5.3, 0))
    bateria("vcb", (6.2, 0), (5.3, 0))
    wire((6.2, 0), (8.1, 0))
    content((1.35, -0.6), anchor: "north", _i2b-t[$V_"BE" approx 0,6$ V])
    content((5.75, -0.6), anchor: "north", _i2b-t[$V_"CB"$: varios voltios])
  })
] <i2b-fig-uniones>

#porque[
  - La pila $V_"BE"$ tiene el positivo en la base (P) y el negativo en el emisor (N): polariza la unión base-emisor en directa. Con unos 0,6 V la barrera se desmonta y el emisor inunda la base de electrones.
  - La pila $V_"CB"$ tiene el positivo en el colector (N): polariza la unión base-colector en inversa. Su zona de deplexión se ensancha y su campo empuja hacia el colector a todo electrón que llega desde la base.
  - Los electrones van de E a C; la corriente convencional, al revés: entra por el colector y sale por el emisor. Por el terminal B sale solo la pequeña fracción de electrones que se recombina en la base.
]

#ptitulo[Por qué la base es fina y poco dopada] Un electrón que entra en la base es allí un intruso: la base es P, llena de huecos, y cada hueco es una ocasión de recombinarse. Si la base fuera gruesa, la mayoría de los electrones se recombinaría por el camino y saldría por el terminal de base: tendríamos dos diodos sin más, sin ganancia. Para que casi todos crucen, la base se fabrica *finísima* (unas micras) y *poco dopada* (pocos huecos con los que tropezar). Y el emisor se dopa mucho para que la corriente de la unión base-emisor la formen casi solo electrones que salen del emisor, no huecos que salen de la base. Las tres decisiones de fabricación tienen un único fin: que la corriente de base sea una fracción *pequeña y fija* de la de colector.

#ptitulo[Las cuentas de las corrientes] El transistor es un nudo con tres cables, y lo que entra en un nudo es lo que sale. Con las corrientes convencionales de un NPN, la de base y la de colector entran y la de emisor sale:
$ I_E = I_B + I_C . $
La física de la base fija el reparto. Si el 99 % de los electrones cruza al colector, $I_C = 0,99 thin I_E$ e $I_B = 0,01 thin I_E$, y la de colector es $0,99 slash 0,01 = 99$ veces la de base. Ese cociente es la ganancia de corriente:

#destacada($I_C = beta thin I_B$, nota: [$beta$ (en las hojas de datos, $h_"FE"$) vale de 50 a 300 según el modelo; en las cuentas de este libro, 100])

Para que todo esto ocurra, la unión base-emisor tiene que estar en directa: $V_"BE" approx 0,6$ V en silicio (0,6–0,7 V en la práctica; 0,2–0,3 V en los viejos transistores de germanio). Esa tensión cambia poquísimo con la corriente, porque la corriente crece de forma *exponencial* con ella, como en el diodo: 60 mV más en la base multiplican $I_C$ por diez. Por eso, para la continua, se toma $V_"BE"$ fija en 0,6 V, y para la señal se usa la pendiente de esa exponencial (#ver(<sec-amplificador-ec>)).

#ejemplo[
  Un transistor con $beta = 150$ recibe una corriente de base de 40 μA. Su corriente de colector es $I_C = beta I_B = 150 dot 40 "μA" = 6000 "μA" = 6$ mA, y por el emisor sale $I_E = 6 + 0,04 = 6,04$ mA. La corriente de base es menos del 1 % de la de emisor: en casi todas las cuentas se puede tomar $I_E approx I_C$. Ojo con las unidades: 6000 μA son 6 mA, no 60 ni 0,6.
]

#ptitulo[NPN y PNP] Cambia N por P y P por N y tienes el *PNP*: emisor P, base N, colector P. Funciona igual, pero con todo al revés: los portadores que cruzan la base son huecos, todas las corrientes cambian de sentido y todas las tensiones cambian de signo. En el NPN el colector es positivo respecto al emisor y la base está 0,6 V _por encima_ del emisor; en el PNP el colector es negativo y la base está 0,6 V _por debajo_ del emisor (@i2b-fig-simbolos). La flecha del símbolo está siempre en el emisor y marca el sentido de la corriente convencional en la unión base-emisor, de P a N, igual que la flecha de un diodo: en el NPN sale del transistor; en el PNP entra.

#circuito(caption: [Símbolos y corrientes convencionales. En el NPN la corriente entra por la base y por el colector y sale, sumada, por el emisor. En el PNP todo va al revés. La flecha del emisor apunta en el sentido de la corriente de la unión base-emisor. A la derecha, lo que «ve» un polímetro en un NPN: dos diodos con los ánodos en la base; sirve para comprobar el transistor, pero dos diodos sueltos nunca amplifican, porque les falta la base fina común.], sim: "pnp.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    // NPN
    npn("q1", (1.6, 2))
    wire("q1.c", (1.6, 3.4))
    wire("q1.e", (1.6, 0.6))
    wire("q1.b", (0.1, 2))
    content((1.6, 3.5), anchor: "south", text(size: 8pt)[C])
    content((1.6, 0.5), anchor: "north", text(size: 8pt)[E])
    content((0, 2), anchor: "east", text(size: 8pt)[B])
    _i2b-flecha((1.9, 3.35), (1.9, 2.75), color: col.naranja, etq: $I_C$, anchor: "west")
    _i2b-flecha((1.9, 1.3), (1.9, 0.7), color: col.naranja, etq: $I_E$, anchor: "west")
    _i2b-flecha((0.2, 2.25), (0.75, 2.25), color: col.naranja, etq: $I_B$, anchor: "south")
    content((1.2, -0.3), anchor: "north", text(size: 8.5pt, weight: "bold")[NPN])
    content((1.2, -0.75), anchor: "north", _i2b-t[base 0,6 V por encima del emisor])
    // PNP
    pnp("q2", (6.2, 2))
    wire("q2.e", (6.2, 3.4))
    wire("q2.c", (6.2, 0.6))
    wire("q2.b", (4.7, 2))
    content((6.2, 3.5), anchor: "south", text(size: 8pt)[E])
    content((6.2, 0.5), anchor: "north", text(size: 8pt)[C])
    content((4.6, 2), anchor: "east", text(size: 8pt)[B])
    _i2b-flecha((6.5, 3.35), (6.5, 2.75), color: col.naranja, etq: $I_E$, anchor: "west")
    _i2b-flecha((6.5, 1.3), (6.5, 0.7), color: col.naranja, etq: $I_C$, anchor: "west")
    _i2b-flecha((5.35, 2.25), (4.8, 2.25), color: col.naranja, etq: $I_B$, anchor: "south")
    content((5.8, -0.3), anchor: "north", text(size: 8.5pt, weight: "bold")[PNP])
    content((5.8, -0.75), anchor: "north", _i2b-t[base 0,6 V por debajo del emisor])
    // modelo de dos diodos
    diode("dbc", (10.4, 2), (10.4, 3.4))
    diode("dbe", (10.4, 2), (10.4, 0.6))
    wire((10.4, 2), (9.3, 2))
    node("nb", (10.4, 2))
    content((10.4, 3.5), anchor: "south", text(size: 8pt)[C])
    content((10.4, 0.5), anchor: "north", text(size: 8pt)[E])
    content((9.2, 2), anchor: "east", text(size: 8pt)[B])
    content((10.1, -0.3), anchor: "north", text(size: 8.5pt, weight: "bold")[NPN visto por un polímetro])
  })
] <i2b-fig-simbolos>

#porque[
  - En el NPN la corriente convencional de base entra, cruza la unión base-emisor (de P a N, sentido de la flecha) y sale por el emisor. La de colector entra por arriba y sale por el mismo emisor: $I_E = I_B + I_C$.
  - En el PNP el emisor es P y la base N: para que la unión base-emisor quede en directa, el emisor tiene que estar 0,6 V por encima de la base. La corriente entra por el emisor y sale repartida por la base y el colector. Por eso, en un circuito con alimentación positiva, el PNP se dibuja «cabeza abajo», con el emisor hacia el positivo.
  - El modelo de dos diodos explica la prueba con polímetro: entre base y emisor, y entre base y colector, conduce en un sentido y no en el otro; entre colector y emisor no conduce en ninguno. No explica la ganancia: esta nace de que las dos uniones comparten una base finísima. Puedes ver las corrientes del NPN en #falstad("npn.txt").
]

#truco[Para recordar la flecha, busca las letras del nombre en una frase. *NPN*: «#strong[N]o #strong[P]e#strong[N]etra», la flecha sale del transistor. *PNP*: «#strong[P]e#strong[N]etra #strong[P]or dentro», la flecha entra.]

#ojo[
  El examen pregunta estos datos de forma directa. Los terminales del bipolar son *emisor, base y colector* (T2.23); puerta, fuente (surtidor) y drenador son del FET. Los tipos son *NPN y PNP* (T2.24): la base, la capa del medio, siempre es de tipo distinto al de sus vecinas, así que «PPN» o «NNP» no existen. $beta$ es el cociente $I_C slash I_B$ (T2.32), no $I_E slash I_C$; la cuenta del ejemplo es la de F-T2.19. Y las polaridades (T2.48, T2.49): en el NPN el colector es *positivo* respecto al emisor; en el PNP, *negativo* respecto a la base y al emisor.
]

== Corte, activa y saturación: las tres zonas de trabajo <i2b-sec-zonas>

#motivacion[El grifo tiene un recorrido limitado. ¿Qué pasa si la base recibe tan poca corriente que el grifo se cierra del todo, o tanta que se abre del todo? La respuesta divide la vida del transistor en tres zonas, y la radio usa las tres: la zona del medio para *amplificar* sin deformar la voz, y los dos extremos para *conmutar*: activar el relé de antena, pasar a transmisión con el PTT, llevar la cuenta en un sintetizador.]

#ptitulo[Las curvas de salida] La forma más útil de mirar un transistor es su familia de curvas (@i2b-fig-curvas). Cada curva corresponde a una corriente de base fija; en horizontal está la tensión entre colector y emisor, $V_"CE"$, y en vertical la corriente de colector. Fíjate en lo que dicen: en cuanto $V_"CE"$ pasa de unas décimas de voltio, las curvas son *horizontales*. La corriente de colector depende solo de la de base, $I_C = beta I_B$, y casi nada de la tensión del colector: el transistor se comporta como una *fuente de corriente gobernada por la base*. Es la consecuencia directa del truco de la unión base-colector: su campo recoge todos los electrones que le llegan, y da igual que tenga 3 V o 10 V.

#ptitulo[La recta de carga] El transistor nunca trabaja solo. En nuestra etapa (12 V, $R_C = 4,7$ kΩ y $R_E = 1,5$ kΩ; la verás completa en la @i2b-fig-ec) las resistencias imponen su propia regla: lo que no cae en ellas cae en el transistor,
$ V_"CE" = 12 - I_C (R_C + R_E) . $
Es una recta. Con $I_C = 0$ el transistor se queda los 12 V enteros; con $V_"CE" approx 0$ la corriente la limitan las resistencias, $12 slash 6,2 "kΩ" approx 1,9$ mA. El transistor tiene que estar a la vez sobre su curva y sobre la recta: el cruce es el *punto de trabajo* Q. Con $I_B = 10$ μA, Q cae en 1 mA y 5,8 V. Cuando la señal mueve la corriente de base arriba y abajo, Q resbala por la recta, y la tensión del colector con él: con ±5 μA de base, $V_"CE"$ va de 8,9 V a 2,7 V. Eso es la amplificación vista en la gráfica.

#circuito(caption: [Curvas de salida de un NPN con $beta = 100$ y recta de carga de la etapa de 12 V ($R_C + R_E = 6,2$ kΩ). Cada curva es una corriente de base. El punto de trabajo Q (10 μA, 1 mA, 5,8 V) está en el centro de la zona activa. Si la corriente de base baja a cero, el punto cae al extremo inferior de la recta (corte: interruptor abierto); si sube por encima de unos 19 μA, el punto sube al extremo superior (saturación: interruptor cerrado).], sim: "npn.txt")[
  #cetz.canvas({
    import cetz.draw: *
    let sx = 0.6
    let sy = 1.7
    // zonas
    rect((0, 0), (0.5 * sx, 2.3 * sy), fill: col.naranja-claro, stroke: none)
    rect((0, 0), (13 * sx, 0.07 * sy), fill: col.gris.lighten(60%), stroke: none)
    ejes(0, 15 * sx, 0, 2.45 * sy, etq-x: [$V_"CE"$ (V)], etq-y: [$I_C$ (mA)])
    for v in (2, 4, 6, 8, 10, 12) {
      line((v * sx, 0), (v * sx, -0.08), stroke: 0.5pt)
      content((v * sx, -0.12), anchor: "north", _i2b-t(size: 7pt)[#v])
    }
    for (i, t) in ((0.5, [0,5]), (1, [1]), (1.5, [1,5]), (2, [2])) {
      line((0, i * sy), (-0.08, i * sy), stroke: 0.5pt)
      content((-0.12, i * sy), anchor: "east", _i2b-t(size: 7pt, t))
    }
    // curvas
    for ib in (5, 10, 15, 20) {
      let ic = ib / 10
      onda(v => ic * sy * (1 - calc.exp(-v / sx / 0.2)), 0, 12.6 * sx, stroke: 1pt + col.senal1)
      content((12.7 * sx, ic * sy), anchor: "west", _i2b-t(color: col.senal1, size: 7pt)[#ib μA])
    }
    content((12.7 * sx, 2.32 * sy), anchor: "west", _i2b-t(color: col.senal1, size: 7pt)[$I_B$:])
    // recta de carga
    line((0, 1.935 * sy), (12 * sx, 0), stroke: 1.1pt + col.ambar)
    content((8.6 * sx, 0.72 * sy), anchor: "south-west", _i2b-t(color: col.ambar)[recta de carga])
    // punto Q
    circle((5.8 * sx, 1.0 * sy), radius: 0.09, fill: col.senal2, stroke: none)
    content((5.95 * sx, 1.07 * sy), anchor: "south-west", text(size: 8pt, weight: "bold", fill: col.senal2)[Q])
    line((5.8 * sx, 0), (5.8 * sx, 1.0 * sy), stroke: (dash: "dotted", thickness: 0.5pt))
    line((0, 1.0 * sy), (5.8 * sx, 1.0 * sy), stroke: (dash: "dotted", thickness: 0.5pt))
    // extremos
    circle((0.2 * sx, 1.9 * sy), radius: 0.07, fill: col.tinta, stroke: none)
    circle((12 * sx, 0), radius: 0.07, fill: col.tinta, stroke: none)
    // rótulos de zonas
    line((0.3 * sx, 2.1 * sy), (3.0 * sx, 2.28 * sy), stroke: 0.4pt + col.gris)
    content((3.1 * sx, 2.28 * sy), anchor: "west", _i2b-t(color: col.naranja)[saturación: $V_"CE" approx 0,2$ V])
    content((8.3 * sx, 1.75 * sy), anchor: "west", _i2b-t[zona activa: $I_C = beta I_B$])
    line((9.5 * sx, 0.03 * sy), (9.0 * sx, -0.6), stroke: 0.4pt + col.gris)
    content((9.0 * sx, -0.62), anchor: "north", _i2b-t(color: col.gris)[corte: $I_C approx 0$ ($I_B = 0$)])
  })
] <i2b-fig-curvas>

#figure(
  table(
    columns: (auto, 2.4cm, 1.7cm, 1fr, 2.5cm),
    align: (left, left, left, left, left),
    [*Zona*], [*Unión B-E*], [*Unión B-C*], [*Qué hace el transistor*], [*Para qué sirve*],
    [Corte], [no conduce ($V_"BE" < 0,6$ V)], [inversa], [$I_C approx 0$; toda la tensión cae en el transistor: interruptor abierto], [conmutar (apagado)],
    [Activa], [directa], [inversa], [$I_C = beta I_B$: grifo proporcional, fuente de corriente gobernada por la base], [amplificar],
    [Saturación], [directa], [directa], [$V_"CE" approx 0,2$ V; la corriente la fija el circuito y ya es menor que $beta I_B$: interruptor cerrado], [conmutar (encendido)],
  ),
  caption: [Las tres zonas de trabajo del transistor bipolar.],
) <i2b-tab-zonas>

#ptitulo[Las otras vidas del transistor] Llevado al extremo, el grifo es un *conmutador*: sin corriente de base, cerrado del todo (corte); con corriente de sobra, abierto del todo (saturación). Así se manejan relés, el PTT, los pasos de un sintetizador —~electrónica digital, al fondo, es esto a millones de veces por segundo. Cuidado con las palabras: el grifo _cerrado_ es el interruptor _abierto_, y al revés. La @i2b-fig-rele es el conmutador más típico de una estación: un transistor que activa un relé.

#circuito(caption: [El transistor como interruptor: gobierna un relé de 12 V (bobina de 400 Ω, 30 mA) desde una señal de control de 5 V. Con 0 V en el control, corte: el relé está suelto. Con 5 V, la base recibe casi 1 mA, mucho más de lo necesario, y el transistor se satura: el relé se activa. El diodo en paralelo con la bobina protege al transistor al cortar.], sim: "transswitch.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    wire((3, 5), (6.4, 5))
    node("v", (3, 5), fill: false, label: (content: _i2b-t[+12 V], anchor: "north"))
    inductor("rl", (4.2, 5), (4.2, 3.3), label: _i2b-e[relé 400 Ω])
    diode("dv", (6.4, 3.3), (6.4, 5), label: (content: _i2b-e[diodo volante], anchor: "south"))
    node("n1", (4.2, 5))
    node("n2", (4.2, 3.3))
    wire((4.2, 3.3), (6.4, 3.3))
    npn("q", (4.2, 2.4))
    wire((4.2, 3.3), "q.c")
    wire("q.e", (4.2, 1.2))
    ground("g", (4.2, 1.2))
    resistor("rb", (1.2, 2.4), "q.b", label: _i2b-e($R_B space 4,7 "kΩ"$))
    node("e", (1.2, 2.4), fill: false)
    content((1.1, 2.4), anchor: "east", align(right, _i2b-t[control \ 0 V / 5 V]))
    _i2b-flecha((3.75, 4.6), (3.75, 3.7), color: col.ambar, etq: [30 mA], anchor: "east")
    _i2b-flecha((1.9, 2.15), (2.9, 2.15), color: col.ambar, etq: [0,94 mA], anchor: "north")
  })
] <i2b-fig-rele>

#porque[
  - *Control a 0 V*: la unión base-emisor no llega a 0,6 V, no hay corriente de base y el transistor está en corte. Por la bobina no pasa corriente y el relé está suelto.
  - *Control a 5 V*: por $R_B$ pasan $(5 - 0,6) slash 4,7 "kΩ" approx 0,94$ mA. Con $beta = 100$, el transistor _podría_ conducir 94 mA, pero la bobina solo pide 30 mA: sobra corriente de base y el transistor se satura. Su tensión cae a unos 0,2 V y casi todos los 12 V quedan en la bobina.
  - Se diseña con corriente de base de sobra (aquí, tres veces la necesaria) para que el interruptor cierre del todo aunque $beta$ sea menor de lo previsto o el transistor esté frío.
  - El *diodo volante* está en inversa mientras el relé está activo y no hace nada. Al cortar, la bobina intenta mantener su corriente y su tensión se dispara (#ver(<sec-bobina>)); el diodo le da un camino y la tensión del colector no pasa de 12,6 V. Sin él, el pico de cientos de voltios destruiría el transistor.
]

#ejemplo(titulo: [por qué el interruptor apenas se calienta])[
  En corte, la corriente es cero: el transistor no disipa nada. En saturación, $P = V_"CE(sat)" I_C = 0,2 "V" dot 30 "mA" = 6$ mW. Si el mismo transistor estuviera a mitad de camino, en zona activa, con 6 V y 15 mA, disiparía $6 dot 0,015 = 90$ mW, quince veces más. Un interruptor que salta de un extremo a otro casi no pierde energía. Lo veremos otra vez en los amplificadores de clase D y E (#ver(<sec-clases>)).
]

#idea[Amplificar es trabajar en la *zona activa*, sin tocar los extremos. Conmutar es saltar de un extremo a otro: del *corte* (interruptor abierto) a la *saturación* (interruptor cerrado).]

== Polarizar: el punto de reposo <sec-polarizacion>

#motivacion(titulo: [la señal sube y baja, pero el transistor solo conduce hacia un lado])[
  La señal que queremos amplificar es alterna: sube por encima de cero y baja por debajo. El transistor, en cambio, solo conduce cuando su unión base-emisor tiene más de 0,6 V, y solo en un sentido. Si conectas los milivoltios de la antena directamente entre base y emisor, no pasa nada: ni las crestas positivas llegan a abrir la unión. Y si la señal fuera de varios voltios, el transistor solo copiaría las crestas positivas. Para que copie la onda entera hay que dejarlo *a medio abrir* antes de que llegue la señal: darle una corriente continua de reposo, de modo que la señal la aumente en un semiciclo y la reduzca en el otro.
]

#analogia[Piensa en el grifo entreabierto. Desde ahí la mano puede abrir más o cerrar más, y el chorro sigue cada movimiento. Si el grifo empieza cerrado del todo, la mano solo puede abrir: la mitad de sus movimientos, los de cerrar, no hacen nada. Si empieza abierto del todo, pasa lo contrario. *Polarizar* es elegir cuánto se entreabre el grifo antes de empezar.]

#ptitulo[El punto de reposo y el recorte] La corriente continua de reposo fija el punto Q sobre la recta de carga (@i2b-fig-curvas) y, con él, la tensión de reposo del colector. La señal mueve el colector hacia arriba y hacia abajo desde ahí, pero tiene dos topes: no puede subir por encima de los 12 V del raíl (el transistor ya estaría en corte, sin corriente) ni bajar hasta el emisor (saturación). El sitio sensato para Q es el centro, con el mismo margen hacia los dos lados. La @i2b-fig-recorte muestra qué pasa si no: la onda choca contra uno de los topes y sale *recortada*. Un recorte es distorsión: la onda deja de ser una sinusoide y aparecen armónicos que, en un transmisor, salpican otras frecuencias.

#circuito(caption: [La misma señal en el colector con tres puntos de reposo distintos. La tensión del colector solo puede moverse entre unos 1,7 V (saturación: el transistor ya no baja más) y los 12 V del raíl (corte: sin corriente, el colector se queda en el raíl). (a) Q en el centro: copia limpia. (b) Q demasiado bajo: los valles chocan con la saturación. (c) Q demasiado alto: las crestas chocan con el corte.])[
  #cetz.canvas({
    import cetz.draw: *
    let sy = 0.25
    let sat = 1.7
    let tope = 12
    for (k, (q, tit)) in ((7.3, [(a) Q en el centro]), (3.6, [(b) Q demasiado bajo]), (10.4, [(c) Q demasiado alto])).enumerate() {
      let ox = k * 5.3
      group({
        translate((ox, 0))
        line((0, 0), (0, 13.5 * sy), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
        line((0, 0), (4.4, 0), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
        content((4.4, -0.05), anchor: "north-east", _i2b-t(size: 7pt)[$t$])
        content((0.05, 13.5 * sy), anchor: "north-west", _i2b-t(size: 7pt)[$v_C$])
        line((0, tope * sy), (4.2, tope * sy), stroke: (paint: col.gris, dash: "dashed", thickness: 0.6pt))
        line((0, sat * sy), (4.2, sat * sy), stroke: (paint: col.gris, dash: "dashed", thickness: 0.6pt))
        line((0, q * sy), (4.2, q * sy), stroke: (paint: col.ambar, dash: "dotted", thickness: 0.7pt))
        content((-0.06, tope * sy), anchor: "east", _i2b-t(size: 6.5pt, color: col.gris)[12 V])
        content((-0.06, sat * sy), anchor: "east", _i2b-t(size: 6.5pt, color: col.gris)[1,7 V])
        content((-0.06, q * sy), anchor: "east", _i2b-t(size: 6.5pt, color: col.ambar)[Q])
        onda(t => calc.min(tope, calc.max(sat, q - 4 * calc.sin(2 * calc.pi * t / 2))) * sy, 0.1, 4.1, n: 200, stroke: 1.2pt + col.senal1)
        content((2.1, -0.35), anchor: "north", text(size: 7.5pt, weight: "bold")[#tit])
      })
    }
  })
] <i2b-fig-recorte>

#ptitulo[La polarización más simple, y por qué falla] La forma más directa de dar corriente de base es una resistencia desde el raíl (@i2b-fig-polarizaciones, izquierda). Con 1,1 MΩ pasan $(12 - 0,6) slash 1,1 "MΩ" approx 10$ μA, y con $beta = 100$ eso da 1 mA de colector: el punto Q de antes. El problema es $beta$. Dos transistores del mismo modelo pueden tener $beta = 100$ y $beta = 300$, y $beta$ sube además con la temperatura. Con $beta = 300$, los mismos 10 μA pedirían 3 mA, que en $R_C$ harían caer 14 V: más de lo que hay. El transistor se satura y la etapa deja de amplificar. La corriente de colector depende de un dato que nadie controla.

#ptitulo[El divisor y la resistencia de emisor] La solución de casi todos los equipos (@i2b-fig-polarizaciones, derecha) cambia la pregunta. El divisor $R_1$–$R_2$ fija la *tensión* de la base, 2,1 V, y la mantiene aunque la base tome algo de corriente, porque por el divisor baja una corriente unas veinte veces mayor (la regla del diez de #ver(<sec-resistencia>)). El emisor queda 0,6 V por debajo, a 1,5 V, y la resistencia de emisor convierte esa tensión en corriente:

#destacada($I_C approx I_E = (V_B - 0,6 "V") / R_E$, nota: [$beta$ no aparece: la corriente de reposo la fijan dos resistencias])

Con 2,1 V en la base y $R_E = 1,5$ kΩ, $I_E = 1,5 "V" slash 1,5 "kΩ" = 1$ mA, tenga el transistor la $beta$ que tenga.

#circuito(caption: [Dos maneras de polarizar la misma etapa. Izquierda: polarización por resistencia de base; la corriente de colector es $beta$ veces la de base y cambia con cada transistor. Derecha: divisor de tensión y resistencia de emisor; la corriente de colector la fijan $R_1$, $R_2$ y $R_E$, y casi no depende de $beta$.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    // (a) resistencia de base
    wire((0.8, 5), (3.2, 5))
    node("va", (0.8, 5), fill: false, label: (content: _i2b-t[+12 V], anchor: "north"))
    resistor("rb", (1.4, 5), (1.4, 2.5), label: (content: _i2b-e($R_B space 1,1 "MΩ"$), anchor: "south"))
    npn("qa", (3.2, 2.5))
    wire((1.4, 2.5), "qa.b")
    resistor("rca", (3.2, 5), (3.2, 3.7), label: _i2b-e($R_C space 4,7 "kΩ"$))
    wire((3.2, 3.7), "qa.c")
    wire("qa.e", (3.2, 0))
    ground("ga", (3.2, 0))
    node("na1", (1.4, 5))
    content((2.1, -0.75), anchor: "north", align(center, _i2b-t[$beta = 100$: $I_C = 1$ mA \ #text(fill: col.senal2)[$beta = 300$: saturado]]))
    // (b) divisor + R_E
    wire((6.6, 5), (9.2, 5))
    node("vb", (6.6, 5), fill: false, label: (content: _i2b-t[+12 V], anchor: "north"))
    resistor("r1", (7.2, 5), (7.2, 2.5), label: _i2b-e($R_1 space 47 "kΩ"$))
    resistor("r2", (7.2, 2.5), (7.2, 0), label: _i2b-e($R_2 space 10 "kΩ"$))
    npn("qb", (9.2, 2.5))
    wire((7.2, 2.5), "qb.b")
    node("nb", (7.2, 2.5))
    resistor("rcb", (9.2, 5), (9.2, 3.7), label: _i2b-e($R_C space 4,7 "kΩ"$))
    wire((9.2, 3.7), "qb.c")
    resistor("re", (9.2, 1.4), (9.2, 0), label: _i2b-e($R_E space 1,5 "kΩ"$))
    wire("qb.e", (9.2, 1.4))
    wire((7.2, 0), (9.2, 0))
    ground("gb", (8.2, 0))
    node("nb1", (7.2, 5))
    node("nb2", (9.2, 0))
    content((8.2, -0.75), anchor: "north", align(center, _i2b-t[$beta = 100$: $I_C = 0,95$ mA \ #text(fill: col.verde)[$beta = 300$: $I_C = 0,98$ mA]]))
    content((6.7, 2.5), anchor: "east", _i2b-t(color: col.ambar)[2,1 V])
    content((9.4, 1.75), anchor: "west", _i2b-t(color: col.ambar)[1,5 V])
  })
] <i2b-fig-polarizaciones>

#porque[
  - *Izquierda*: $R_B$ fija la corriente de base, no la de colector. La de colector es $beta I_B$, y $beta$ cambia de un transistor a otro y con la temperatura. Un circuito que depende de $beta$ es un circuito que cambia si cambias el transistor.
  - *Derecha*: el divisor fija la tensión de base. El emisor sigue a la base 0,6 V por debajo, y $R_E$ convierte esa tensión fija en una corriente fija. El transistor pone la corriente que haga falta para que se cumpla, y $beta$ solo decide cuánta corriente de base pide para ello, que es poca.
  - Si $R_E$ faltara en el montaje de la derecha, la base tendría 2,1 V directamente sobre la unión base-emisor: una corriente enorme que destruiría el transistor. Sin $R_E$, la base debería estar a 0,6–0,7 V exactos, y unos milivoltios de más multiplican la corriente (la exponencial): imposible de ajustar.
]

#ptitulo[Por qué $R_E$ estabiliza: realimentación negativa] Supón que el transistor se calienta. Con el calor, $V_"BE"$ baja unos 2 mV por grado y $beta$ sube: el transistor «quiere» conducir más. Si conduce más, cae más tensión en $R_E$ y el emisor sube. Pero la base está clavada por el divisor, así que la diferencia base-emisor *disminuye*, y la corriente vuelve a bajar. Cualquier intento de cambio crea la tensión que lo frena. Esto se llama *realimentación negativa*: una parte de la salida (la corriente, convertida en tensión por $R_E$) vuelve a la entrada y se resta de ella. Sin ella, en una etapa de potencia, el calor aumenta la corriente y la corriente aumenta el calor, y el transistor puede destruirse: es el *embalamiento térmico*.

#ejemplo(titulo: [la misma etapa con $beta = 100$ y con $beta = 300$])[
  Con la polarización por resistencia de base, $I_C = beta dot 10 "μA"$: 1 mA con $beta = 100$, y 3 mA (imposible: saturación) con $beta = 300$.

  Con el divisor y $R_E$, la cuenta exacta tiene en cuenta la poca corriente que toma la base. Visto desde la base, el divisor equivale a una fuente de 2,1 V con una resistencia interna $R_1 parallel R_2 = 47 parallel 10 approx 8,2$ kΩ; vista desde el emisor, esa resistencia se divide por $beta + 1$:
  $ I_E = (2,1 - 0,6 "V") / (R_E + 8,2 "kΩ" slash (beta + 1)) . $
  Con $beta = 100$: $1,5 slash (1500 + 82) approx 0,95$ mA. Con $beta = 300$: $1,5 slash (1500 + 27) approx 0,98$ mA. Triplicar $beta$ cambia la corriente menos de un 4 %: la etapa ni se entera.
]

#ojo[
  - Para reproducir la señal sin distorsión, el transistor debe trabajar en la *parte lineal* de su característica (C-T3.8): punto de reposo centrado y señal que no llegue a los topes. «Polarizaciones muy altas» llevan a la saturación y recortan.
  - La *realimentación negativa* reduce la ganancia pero mejora la estabilidad y la linealidad (T3.20). La que hace oscilar un circuito es la realimentación *positiva* (#ver(<sec-oscilador>)).
  - Las cuentas del divisor salen en el examen: con $R_1 = 33$ kΩ al raíl de 12 V y $R_2 = 12$ kΩ a masa, la base queda a $12 dot 12 slash (33 + 12) approx 3,2$ V (F-T2.20).
]

#idea[Polarizar es elegir el punto de reposo: la señal oscila alrededor de él. Un buen punto de reposo está en el centro (máximo margen sin recortar) y es estable (no depende de $beta$ ni de la temperatura). El divisor con resistencia de emisor consigue las dos cosas.]

== El amplificador de emisor común, pieza a pieza <sec-amplificador-ec>

#motivacion(titulo: [el amplificador que pide nuestra radio])[
  Ya tenemos todas las piezas: un grifo que copia la corriente de base multiplicada por $beta$, una zona activa donde la copia es fiel y un punto de reposo estable. Falta montarlas en un circuito que haga lo que la radio necesita: recibir unos milivoltios de la etapa anterior y entregar a la siguiente una copia cien o doscientas veces mayor, sin tocar la continua de ninguna de las dos. Lo construimos pieza a pieza, y en cada paso miramos qué falla si falta la pieza nueva (@i2b-fig-pasos).
]

#circuito(caption: [El amplificador de emisor común, montado por pasos. (a) Solo el transistor y su resistencia de carga: no funciona. (b) Con el divisor y $R_E$: el punto de reposo queda fijo y estable. (c) Con los condensadores de acoplo: la etapa ya se puede conectar a sus vecinas. El último paso, el condensador de emisor $C_E$, da el circuito completo de la @i2b-fig-ec.])[
  #esquema(escala: 0.8, {
    import zap: *
    import cetz.draw: content, line
    let panel(ox, divisor: false, acoplos: false) = {
      let xb = ox + 1.6
      let xq = ox + 3.4
      wire((ox + 0.2, 5), (xq + 0.6, 5))
      node("", (ox + 0.2, 5), fill: false)
      content((ox + 0.2, 5.3), anchor: "south-west", _i2b-t[+12 V])
      wire((ox + 0.2, 0), (xq + 0.6, 0))
      ground("", (xq - 0.8, 0))
      resistor("", (xq, 5), (xq, 3.6), label: _i2b-e($R_C$))
      npn("", (xq, 2.6))
      wire((xq, 3.6), (xq, 3.1))
      node("", (xq, 3.6))
      if divisor {
        resistor("", (xb, 5), (xb, 2.6), label: _i2b-e($R_1$))
        resistor("", (xb, 2.6), (xb, 0), label: _i2b-e($R_2$))
        node("", (xb, 2.6))
        resistor("", (xq, 1.5), (xq, 0), label: _i2b-e($R_E$))
        wire((xq, 2.1), (xq, 1.5))
      } else {
        wire((xq, 2.1), (xq, 0))
      }
      wire((xb, 2.6), (xq - 0.68, 2.6))
      if acoplos {
        capacitor("", (ox + 0.2, 2.6), (xb, 2.6), label: _i2b-e($C_"ent"$), n: "o-")
        wire((xq, 3.6), (xq + 0.4, 3.6))
        capacitor("", (xq + 0.4, 3.6), (xq + 1.6, 3.6), label: (content: _i2b-e($C_"sal"$), anchor: "south"), n: "-o")
      } else {
        wire((ox + 0.2, 2.6), (xb, 2.6))
        node("", (ox + 0.2, 2.6), fill: false)
        wire((xq, 3.6), (xq + 1.2, 3.6))
        node("", (xq + 1.2, 3.6), fill: false)
      }
    }
    panel(0)
    panel(6, divisor: true)
    panel(12, divisor: true, acoplos: true)
    for (ox, tit, mal, bien) in (
      (0, [(a) transistor y $R_C$], [los mV no abren la unión B-E; \ el colector se queda en 12 V], none),
      (6, [(b) + divisor y $R_E$], [la fuente de señal descoloca \ la continua de la base], [Q fijo: 1 mA y 7,3 V]),
      (12, [(c) + $C_"ent"$ y $C_"sal"$], [ganancia de solo \ $R_C slash R_E approx 3$], [cada etapa conserva \ su continua]),
    ) {
      content((ox + 2.6, -0.85), anchor: "north", align(center, {
        text(size: 8pt, weight: "bold", tit)
        if bien != none { linebreak(); _i2b-t(color: col.verde, size: 7pt)[✓ #bien] }
        linebreak()
        _i2b-t(color: col.senal2, size: 7pt)[✗ #mal]
      }))
    }
  })
] <i2b-fig-pasos>

#porque(titulo: [qué arregla cada paso])[
  #ptitulo[Paso (a): el transistor solo] Ponemos $R_C$ entre el raíl y el colector, el emisor a masa y la señal directamente en la base. No funciona. Los milivoltios de la señal no llegan a los 0,6 V que abren la unión base-emisor: no hay corriente de colector, no cae tensión en $R_C$, y el colector se queda clavado a 12 V. Al transistor le falta su punto de reposo.

  #ptitulo[Paso (b): el divisor y $R_E$] El divisor $R_1$–$R_2$ sube la base a 2,1 V y $R_E$ fija la corriente en 1 mA (#ver(<sec-polarizacion>)): el grifo está entreabierto y el colector reposa a 7,3 V, en el centro. Ahora sí, una señal que mueva la base unos milivoltios mueve la corriente de colector. Pero la señal llega por un cable que viene de otra etapa, y esa etapa tiene su propia continua: si su salida está a 7,3 V, conectarla directamente a nuestra base la arrastra a 7,3 V y el punto de reposo desaparece. Y lo mismo hace nuestro colector con la etapa siguiente.

  #ptitulo[Paso (c): los condensadores de acoplo] Un condensador en serie deja pasar la alterna y bloquea la continua (#ver(<sec-condensador>)). $C_"ent"$ conecta la señal a la base sin que las continuas de las dos etapas se toquen; $C_"sal"$ hace lo mismo a la salida. Para que la señal pase sin pérdida, su reactancia tiene que ser pequeña a la frecuencia de trabajo: unos 10 μF en audio, unos 10 nF en HF. La etapa ya funciona, pero amplifica poco: unas tres veces (lo explicamos enseguida). El último paso, $C_E$, recupera la ganancia.
]

#ptitulo[Sub-circuito: el amplificador en emisor común, con números] La @i2b-fig-ec es _la_ etapa de la electrónica: el amplificador en emisor común, con todos sus tornillos. Léela en dos pasadas, una por corriente.

_Pasada en ámbar (continua: el punto de trabajo)._ El divisor $R_1$–$R_2$ es el de #ver(<sec-resistencia>): sostiene la base a 2,1 V con sus 0,21 mA. La unión base-emisor cobra su peaje (0,6 V en las cuentas; 0,6–0,7 V en la práctica), así que el emisor queda a $2,1 - 0,6 = 1,5$ V; sobre $R_E = 1,5$ kΩ, esos 1,5 V significan $I_E = 1$ mA —~y como colector y emisor llevan casi la misma corriente, por $R_C$ bajan también ∼1 mA que le restan 4,7 V al raíl: el colector reposa a $12 - 4,7 = 7,3$ V, cómodamente a media altura, con margen para subir y bajar. Fíjate en la jugada de $R_E$: si el transistor calentara y quisiera conducir más, subiría la tensión de emisor, se estrecharía la diferencia base-emisor y la corriente volvería a bajar —~_realimentación_ que estabiliza el punto de trabajo por sí sola. La corriente de base necesaria es $I_C slash beta approx 10$ μA: veinte veces menos que la del divisor, que por eso ni se inmuta (la regla del _ojo_ de #ver(<sec-resistencia>)).

_Pasada en azul (la señal)._ La señal entra por $C_"ent"$ —~acoplo: pasa el vaivén, respeta la continua del divisor~— y menea la tensión de base unos milivoltios. Cada milivoltio de más en la base abre un poco el grifo; la corriente de colector copia el vaivén, ampliada; y al atravesar $R_C$, ese vaivén de corriente se convierte en un vaivén de _tensión_ grande en el colector ($v = i R$: la resistencia de colector es el traductor de corriente a tensión). $C_"sal"$ entrega el resultado a la etapa siguiente, otra vez sin la continua. ¿Cuánto amplifica? Sin $C_E$, la ganancia sería modesta, $approx R_C slash R_E approx 3$: todo vaivén de emisor roba vaivén a la base. Por eso está $C_E$, el _desacoplo de emisor_: para la señal, el emisor queda clavado a masa (el condensador es un cable a esas frecuencias) sin tocar la continua que estabiliza. Con él, la ganancia sube a $approx 40 thin I_C R_C approx 40 dot 0,001 dot 4700 approx 190$: milivoltios que entran, décimas de voltio que salen —~invertidas: cuando la base sube, el colector baja. El 40, por cierto, no cae del cielo: la física de la unión hace que $I_C$ crezca con la tensión de base a razón de $I_C slash 25$ mV —~la _transconductancia_~— y la ganancia es esa pendiente por $R_C$; el 40 es, simplemente, $1 slash (25 "mV")$, con unidades de V#super[−1].

#circuito(caption: [El amplificador en emisor común, con sus dos vidas superpuestas. En ámbar, la continua: el divisor fija la base a 2,1 V, $R_E$ convierte eso en 1 mA estables y $R_C$ deja el colector en reposo a 7,3 V. En azul, la señal: entra por $C_"ent"$, mueve el grifo, y el vaivén de corriente amplificado se convierte en tensión sobre $R_C$ —~unas 190 veces mayor e invertida~— que $C_"sal"$ entrega limpia de continua. $C_E$ pone el emisor a masa solo para la señal: estabilidad en continua, ganancia en alterna.], sim: "ceamp.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    // raíles
    wire((0.4, 6), (9.8, 6))
    node("v0", (0.4, 6), fill: false)
    content((9.9, 6), anchor: "west", _i2b-t[+12 V])
    wire((0.4, 0), (9.8, 0))
    node("m0", (0.4, 0), fill: false)
    content((9.9, 0), anchor: "west", _i2b-t[masa])
    // divisor
    resistor("r1", (2.4, 6), (2.4, 3.2), label: _i2b-e($R_1 space 47 "k"$))
    resistor("r2", (2.4, 3.2), (2.4, 0), label: _i2b-e($R_2 space 10 "k"$))
    node("n1", (2.4, 6))
    node("n2", (2.4, 3.2))
    node("n3", (2.4, 0))
    capacitor("cin", (0.4, 3.2), (2.4, 3.2), label: _i2b-e($C_"ent"$), n: "o-")
    // transistor
    npn("q", (5.4, 3.2))
    wire((2.4, 3.2), "q.b")
    resistor("rc", (5.4, 6), (5.4, 4.4), label: (content: _i2b-e($R_C space 4,7 "k"$), anchor: "south"))
    wire((5.4, 4.4), "q.c")
    node("n4", (5.4, 6))
    node("n5", (5.4, 4.4))
    resistor("re", (5.4, 2.0), (5.4, 0), label: (content: _i2b-e($R_E space 1,5 "k"$), anchor: "south"))
    wire("q.e", (5.4, 2.0))
    node("n6", (5.4, 2.0))
    node("n7", (5.4, 0))
    wire((5.4, 2.0), (7.2, 2.0))
    capacitor("ce", (7.2, 2.0), (7.2, 0), label: _i2b-e($C_E$))
    node("n8", (7.2, 0))
    wire((5.4, 4.4), (7.8, 4.4))
    capacitor("cout", (7.8, 4.4), (9.4, 4.4), label: _i2b-e($C_"sal"$), n: "-o")
    // continua (ámbar)
    _i2b-flecha((1.85, 5.4), (1.85, 4.0), etq: [0,21 mA], anchor: "east")
    _i2b-flecha((5.85, 5.75), (5.85, 4.95), etq: [1 mA], anchor: "west")
    _i2b-flecha((5.85, 1.7), (5.85, 0.4), etq: [1 mA], anchor: "west")
    content((3.3, 3.3), anchor: "south", _i2b-t(color: col.ambar, size: 7pt)[2,1 V])
    content((5.55, 2.1), anchor: "south-west", _i2b-t(color: col.ambar, size: 7pt)[1,5 V])
    content((5.55, 4.3), anchor: "north-west", _i2b-t(color: col.ambar, size: 7pt)[7,3 V])
    // señal (azul)
    _i2b-flecha((-0.4, 3.75), (0.5, 3.75), color: col.senal1, etq: [mV], anchor: "south")
    _i2b-flecha((8.9, 4.95), (9.9, 4.95), color: col.senal1, etq: [×190], anchor: "south")
  })
] <i2b-fig-ec>

#porque(titulo: [pieza a pieza, y qué falla sin cada una])[
  - $R_1$ y $R_2$ fijan la base a 2,1 V: el grifo queda entreabierto. Sin ellos, el transistor estaría en corte y los milivoltios no lo abrirían.
  - $R_E$ convierte los 1,5 V del emisor en 1 mA fijo y estabiliza el punto frente a $beta$ y a la temperatura. Sin ella, la unión base-emisor recibiría los 2,1 V del divisor y el transistor se destruiría.
  - $R_C$ traduce la corriente de colector en tensión. Sin ella el colector estaría pegado al raíl y no habría tensión de salida.
  - $C_"ent"$ y $C_"sal"$ dejan pasar la señal y bloquean la continua. Sin ellos, las continuas de la etapa anterior y de la siguiente descolocarían el punto de reposo.
  - $C_E$ pone el emisor a masa para la señal, pero no para la continua. Sin él la etapa funciona igual de estable, pero amplifica solo unas tres veces.
]

#ojo[El punto de trabajo no es un adorno: si la polarización deja el colector pegado al raíl o a masa, la señal amplificada _choca_ contra ese tope y sale recortada —~distorsión, armónicos, salpicaduras (las clases de amplificación A, B y C del tema T3 son precisamente distintas decisiones sobre dónde aparcar el punto de trabajo y cuánto recorte aceptar a cambio de rendimiento). Y la misma etapa recorta también si la señal de entrada es excesiva: es la _sobrecarga_ o saturación de una etapa amplificadora. (Los recortes se ven en la @i2b-fig-recorte; las clases, en #ver(<sec-clases>).)]

#ptitulo[Las dos señales, una al lado de la otra] La @i2b-fig-ec-ondas muestra lo que verías con un osciloscopio de dos canales. En la base, una sinusoide de 5 mV de pico. En el colector, la misma sinusoide, de casi 1 V de pico, sobre los 7,3 V de reposo, y *al revés*: cuando la base sube, más corriente cruza $R_C$, cae más tensión en ella y el colector baja. El emisor común *invierte la fase*: desfase de 180°.

#circuito(caption: [Entrada y salida del amplificador de la @i2b-fig-ec. Arriba, la señal en la base: 5 mV de pico. Abajo, la tensión del colector: la misma forma, unas 190 veces mayor (unos 0,95 V de pico) e invertida, alrededor de los 7,3 V de reposo. La línea de puntos marca el mismo instante: cresta en la entrada, valle en la salida.], sim: "ceamp.txt")[
  #cetz.canvas({
    import cetz.draw: *
    let T = 3.2
    // entrada
    group({
      translate((0, 3.7))
      line((0, 0), (7.4, 0), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
      line((0, -0.8), (0, 0.9), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
      onda(t => 0.5 * calc.sin(2 * calc.pi * t / T), 0, 7, stroke: 1.2pt + col.senal1)
      content((-0.08, 0.5), anchor: "east", _i2b-t(size: 7pt)[+5 mV])
      content((-0.08, -0.5), anchor: "east", _i2b-t(size: 7pt)[−5 mV])
      line((-0.05, 0.5), (0.05, 0.5), stroke: 0.5pt)
      line((-0.05, -0.5), (0.05, -0.5), stroke: 0.5pt)
      content((7.5, 0.35), anchor: "west", _i2b-t[entrada (base)])
    })
    // salida
    line((0, 0), (7.4, 0), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
    line((0, 0), (0, 2.4), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
    content((7.4, -0.05), anchor: "north-east", _i2b-t(size: 7pt)[$t$])
    line((0, 1.2), (7, 1.2), stroke: (paint: col.ambar, dash: "dashed", thickness: 0.6pt))
    onda(t => 1.2 - 0.95 * calc.sin(2 * calc.pi * t / T), 0, 7, stroke: 1.2pt + col.senal1)
    content((-0.08, 1.2), anchor: "east", _i2b-t(size: 7pt, color: col.ambar)[7,3 V])
    content((-0.08, 2.15), anchor: "east", _i2b-t(size: 7pt)[8,25 V])
    content((-0.08, 0.25), anchor: "east", _i2b-t(size: 7pt)[6,35 V])
    line((-0.05, 2.15), (0.05, 2.15), stroke: 0.5pt)
    line((-0.05, 0.25), (0.05, 0.25), stroke: 0.5pt)
    content((7.5, 1.55), anchor: "west", _i2b-t[salida (colector)])
    content((7.5, 1.15), anchor: "west", _i2b-t(color: col.gris)[×190, invertida])
    // mismo instante
    line((T / 4, 4.2), (T / 4, 0.25), stroke: (dash: "dotted", thickness: 0.6pt))
  })
] <i2b-fig-ec-ondas>

#ptitulo[De dónde sale la ganancia] Las dos ganancias de la pasada en azul salen de la misma idea. La señal que entra por la base se reparte entre la unión base-emisor y lo que haya entre el emisor y masa.

- *Sin $C_E$*, el emisor sigue a la base: la unión mantiene sus 0,6 V, así que cada milivoltio que sube la base lo sube también el emisor. Toda la tensión de entrada queda sobre $R_E$, y la corriente de señal es $i_e = v_"ent" slash R_E$. Esa misma corriente cruza $R_C$ y produce $v_"sal" = - i_c R_C$:
  #destacada($A_v = v_"sal" / v_"ent" approx - R_C / R_E$, nota: [sin $C_E$; el signo menos es la inversión de fase])
- *Con $C_E$*, el emisor está quieto para la señal. Toda la entrada cae sobre la propia unión, y la unión, por su curva exponencial, se comporta para la señal como una resistencia muy pequeña, $r_e = 25 "mV" slash I_E$: 25 Ω con 1 mA. Su inversa es la transconductancia de la pasada en azul, $g_m = I_C slash 25 "mV" = 40 thin I_C$:
  #destacada($A_v approx - g_m R_C = - R_C / r_e$, nota: [con $C_E$; $r_e = 25 "mV" slash I_E$])

Es la misma fórmula: $R_C$ dividida por la resistencia que la señal encuentra en el emisor, $R_E$ sin condensador y $r_e$ con él. Con nuestros valores, $4700 slash 1500 approx 3$ y $4700 slash 25 approx 190$.

#ptitulo[El término medio] Las dos versiones tienen un precio. Sin $C_E$, la ganancia es pequeña, pero fija (solo depende de dos resistencias), y la etapa admite señales de varios voltios sin deformarlas: es la realimentación negativa de $R_E$ actuando también sobre la señal. Con $C_E$, la ganancia es grande, pero depende de $I_C$ y de la temperatura, y la etapa solo es lineal con entradas de pocos milivoltios, porque la exponencial de la unión deja de parecer una recta. Los diseños reales parten $R_E$ en dos: un trozo pequeño sin desacoplar (por ejemplo 100 Ω) y el resto con $C_E$. La ganancia queda en $R_C slash (r_e + 100 thin Ω) = 4700 slash 125 approx 38$, estable y lineal, sin cambiar el punto de reposo.

#ptitulo[Lo que ven sus vecinas] La etapa anterior ve, mirando a $C_"ent"$, el divisor en paralelo con la base: $R_1 parallel R_2 parallel beta r_e approx 8,2 "kΩ" parallel 2,5 "kΩ" approx 1,9$ kΩ. Esa es la *impedancia de entrada*. La etapa siguiente ve, mirando a $C_"sal"$, aproximadamente $R_C$: 4,7 kΩ de *impedancia de salida*. Si la etapa siguiente tiene una entrada de 4,7 kΩ, queda en paralelo con $R_C$ (2,35 kΩ en total) y la ganancia baja a la mitad, unas 95. Las impedancias deciden cómo se encadenan las etapas: lo verás en las tres configuraciones de #ver(<sec-configuraciones>).

#ejemplo(titulo: [punto de trabajo y ganancia con $R_E = 1$ kΩ])[
  Cambiamos en la @i2b-fig-ec $R_E = 1,5$ kΩ por 1 kΩ; el resto queda igual (12 V, $R_1 = 47$ kΩ, $R_2 = 10$ kΩ, $R_C = 4,7$ kΩ, $beta = 100$).

  + *Base*: $V_B = 12 dot 10 slash (47 + 10) approx 2,1$ V. La corriente de base (unos 15 μA) es muy pequeña frente a los 0,21 mA del divisor: la cuenta vale.
  + *Emisor*: $V_E = 2,1 - 0,6 = 1,5$ V, e $I_E = 1,5 "V" slash 1 "kΩ" = 1,5$ mA.
  + *Colector*: en $R_C$ caen $1,5 "mA" dot 4,7 "kΩ" approx 7,05$ V, y $V_C = 12 - 7,05 approx 4,95$ V.
  + *Comprobación*: $V_"CE" = 4,95 - 1,5 = 3,45$ V, muy por encima de los 0,2 V de saturación y por debajo de los 12 V del corte: zona activa.
  + *Ganancia sin $C_E$*: $A_v approx - 4,7 slash 1 = -4,7$.
  + *Ganancia con $C_E$*: $g_m = 40 dot 0,0015 = 60$ mS, y $A_v approx - 0,06 dot 4700 approx -280$ (unos 49 dB). Una entrada de 2 mV sale como 0,56 V, invertida.

  El precio está en el margen. El colector, a 4,95 V, puede bajar unos 3,2 V antes de saturar (hasta unos 1,7 V) y subir 7 V antes del corte: la máxima salida sin recortar es de unos 3,2 V de pico. Con $R_E = 1,5$ kΩ, el colector a 7,3 V tenía 4,7 V de margen hacia arriba y 5,6 V hacia abajo: menos ganancia (190), pero más señal sin recortar.
]

#ojo[
  - El emisor común da ganancia de *tensión* y de *corriente* a la vez, y por tanto de *potencia* (C-T3.12): es la configuración que más amplifica.
  - Invierte la fase: la salida está *desfasada 180°* respecto a la entrada.
  - Las ganancias se dan también en decibelios: $20 log 190 approx 46$ dB. Una etapa que lleva 10 mV a 1 V gana $20 log 100 = 40$ dB (F-T3.12).
]

#ejercicio(sol: [Sin $C_E$, la ganancia cae a $approx R_C slash R_E = 4,7 slash 1,5 approx 3$. A cambio, la etapa gana estabilidad y linealidad: la realimentación de $R_E$ actúa también para la señal, y la ganancia depende solo del cociente de dos resistencias, no del transistor.])[
  En el amplificador de la @i2b-fig-ec, quita $C_E$ del circuito. ¿Qué ganancia queda, aproximadamente? ¿Y qué ventaja conserva la etapa a cambio de esa ganancia perdida?
]

#ejercicio(sol: [Con base gruesa, muchos electrones se recombinarían al atravesarla: más corriente de base para el mismo caudal de colector, es decir, $beta$ pequeña. La base delgada es literalmente lo que hace transistor al transistor.])[
  ¿Por qué la base de un transistor se fabrica lo más delgada posible? ¿Qué le pasaría a $beta$ con una base gruesa?
]

== Tres formas de conectarlo <sec-configuraciones>

#motivacion(titulo: [no siempre hace falta más tensión])[
  El emisor común amplifica mucho, pero no resuelve todos los problemas de una radio. A veces lo que falta no es tensión, sino *corriente*: un oscilador delicado tiene que alimentar un filtro o un cable sin que esa carga lo frene ni le cambie la frecuencia. Otras veces el problema es la *frecuencia*: a 145 MHz el emisor común se vuelve inestable y amplifica poco. El transistor tiene tres terminales; la señal entra por uno, sale por otro y el tercero queda *común* a la entrada y a la salida (unido a masa para la señal). Hay tres maneras de elegirlo, y cada una tiene su carácter (@i2b-fig-tres).
]

#circuito(caption: [Las tres configuraciones vistas por la señal (se omite la polarización). En naranja, el terminal común a la entrada y a la salida. El raíl +V cuenta como masa para la señal: la fuente de alimentación tiene condensadores enormes que ponen su salida a masa para cualquier alterna.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    let comun = 2.2pt + col.naranja
    // emisor común
    vcc("v1", (2.2, 4.4), label: _i2b-t[+V])
    resistor("rc1", (2.2, 4.4), (2.2, 3.2), label: (content: _i2b-e($R_C$), anchor: "south"))
    npn("q1", (2.2, 2.4))
    wire((2.2, 3.2), "q1.c")
    node("n1", (2.2, 3.2))
    wire((2.2, 3.2), (3.3, 3.2))
    node("o1", (3.3, 3.2), fill: false)
    content((3.3, 3.45), anchor: "south", _i2b-t(color: col.senal1)[salida])
    line("q1.e", (2.2, 1.0), stroke: comun)
    ground("g1", (2.2, 1.0))
    wire((0.5, 2.4), "q1.b")
    node("i1", (0.5, 2.4), fill: false)
    content((0.5, 2.65), anchor: "south", _i2b-t(color: col.senal1)[entrada])
    content((1.9, 0.1), anchor: "north", text(size: 8pt, weight: "bold")[emisor común])
    // colector común
    vcc("v2", (7.0, 4.4), label: _i2b-t[+V])
    npn("q2", (7.0, 3.0))
    line("q2.c", (7.0, 4.4), stroke: comun)
    wire("q2.e", (7.0, 2.1))
    resistor("re2", (7.0, 2.1), (7.0, 0.9), label: _i2b-e($R_E$))
    ground("g2", (7.0, 0.9))
    node("n2", (7.0, 2.1))
    wire((7.0, 2.1), (8.1, 2.1))
    node("o2", (8.1, 2.1), fill: false)
    content((8.1, 2.35), anchor: "south", _i2b-t(color: col.senal1)[salida])
    wire((5.3, 3.0), "q2.b")
    node("i2", (5.3, 3.0), fill: false)
    content((5.3, 3.25), anchor: "south", _i2b-t(color: col.senal1)[entrada])
    content((6.7, 0.1), anchor: "north", align(center, text(size: 8pt, weight: "bold")[colector común \ #text(weight: "regular")[(seguidor de emisor)]]))
    // base común
    npn("q3", (11.6, 2.6), scale: (-1.0, 1.0), rotate: -90deg)
    line("q3.b", (11.6, 1.0), stroke: comun)
    ground("g3", (11.6, 1.0))
    wire((10.0, 2.6), "q3.e")
    node("i3", (10.0, 2.6), fill: false)
    content((10.0, 2.85), anchor: "south", _i2b-t(color: col.senal1)[entrada])
    wire("q3.c", (12.8, 2.6))
    vcc("v3", (12.8, 4.4), label: _i2b-t[+V])
    resistor("rc3", (12.8, 4.4), (12.8, 2.6), label: _i2b-e($R_C$))
    node("n3", (12.8, 2.6))
    wire((12.8, 2.6), (13.8, 2.6))
    node("o3", (13.8, 2.6), fill: false)
    content((13.8, 2.85), anchor: "south", _i2b-t(color: col.senal1)[salida])
    content((11.9, 0.1), anchor: "north", text(size: 8pt, weight: "bold")[base común])
  })
] <i2b-fig-tres>

#porque[
  - *Emisor común*: entra por la base, sale por el colector; el emisor va a masa (en la @i2b-fig-ec, a través de $C_E$). La corriente pequeña de base gobierna la grande de colector, y $R_C$ la convierte en mucha tensión: gana tensión y corriente, e invierte.
  - *Colector común*: entra por la base, sale por el emisor; el colector va al raíl, que es masa para la señal. El emisor sigue a la base 0,6 V por debajo, así que la tensión de salida copia la de entrada sin ganancia, pero la corriente de salida es $beta + 1$ veces la de entrada.
  - *Base común*: entra por el emisor, sale por el colector; la base va a masa. La corriente que entra por el emisor sale casi entera por el colector (ganancia de corriente algo menor que 1), pero entra por una impedancia muy baja y sale por una muy alta: eso da ganancia de tensión.
]

=== Emisor común: el que más amplifica

Es la etapa que ya conoces (@i2b-fig-ec): ganancia de tensión de decenas a cientos, ganancia de corriente $beta$ y, por tanto, la mayor ganancia de potencia de las tres. Impedancia de entrada media (unos kilohmios), impedancia de salida media o alta ($approx R_C$), y salida invertida. Es la etapa por defecto en los amplificadores de RF, de FI y de audio.

=== Colector común: el seguidor de emisor

#ptitulo[El problema que resuelve] Un oscilador (#ver(<sec-oscilador>)) produce una sinusoide muy estable, pero solo mientras nadie le pida potencia: si le conectas directamente un filtro, un mezclador o una etapa de entrada de impedancia baja, su tanque se carga, pierde $Q$ y la frecuencia se mueve. Hace falta un intermediario que *mire* la señal sin tomar casi corriente y que, por el otro lado, sea capaz de entregar mucha. Es una *etapa separadora* (_buffer_), y el transistor en colector común es la más sencilla (@i2b-fig-seguidor).

#circuito(caption: [Seguidor de emisor (colector común) con polarización por divisor. La base está a 6 V y el emisor a 5,4 V: unos 0,96 mA de reposo. La señal sale por el emisor, con la misma amplitud y la misma fase que la de entrada, pero con una impedancia de salida de unas decenas de ohmios. En ámbar, la continua; en azul, la señal.], sim: "follower.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    wire((0.4, 5.6), (8.0, 5.6))
    node("v0", (0.4, 5.6), fill: false)
    content((8.1, 5.6), anchor: "west", _i2b-t[+12 V])
    wire((0.4, 0), (8.0, 0))
    node("m0", (0.4, 0), fill: false)
    content((8.1, 0), anchor: "west", _i2b-t[masa])
    resistor("r1", (2.4, 5.6), (2.4, 2.8), label: _i2b-e($R_1 space 47 "k"$))
    resistor("r2", (2.4, 2.8), (2.4, 0), label: _i2b-e($R_2 space 47 "k"$))
    node("n1", (2.4, 5.6))
    node("n2", (2.4, 2.8))
    node("n3", (2.4, 0))
    capacitor("cin", (0.4, 2.8), (2.4, 2.8), label: _i2b-e($C_"ent"$), n: "o-")
    npn("q", (5.0, 2.8))
    wire((2.4, 2.8), "q.b")
    wire("q.c", (5.0, 5.6))
    node("n4", (5.0, 5.6))
    wire("q.e", (5.0, 1.8))
    resistor("re", (5.0, 1.8), (5.0, 0), label: (content: _i2b-e($R_E space 5,6 "k"$), anchor: "south"))
    node("n5", (5.0, 1.8))
    node("n6", (5.0, 0))
    wire((5.0, 1.8), (5.8, 1.8))
    capacitor("cout", (5.8, 1.8), (7.2, 1.8), label: _i2b-e($C_"sal"$), n: "-*")
    resistor("rl", (7.2, 1.8), (7.2, 0), label: _i2b-e[carga 1 kΩ])
    node("n7", (7.2, 0))
    content((3.1, 2.9), anchor: "south", _i2b-t(color: col.ambar, size: 7pt)[6 V])
    content((5.15, 1.9), anchor: "south-west", _i2b-t(color: col.ambar, size: 7pt)[5,4 V])
    _i2b-flecha((5.45, 1.5), (5.45, 0.4), etq: [0,96 mA], anchor: "west")
    _i2b-flecha((-0.4, 3.35), (0.5, 3.35), color: col.senal1, etq: [1 V], anchor: "south")
    _i2b-flecha((7.45, 2.3), (8.4, 2.3), color: col.senal1, etq: [≈ 1 V], anchor: "south")
  })
] <i2b-fig-seguidor>

#porque[
  - La base está a 6 V (divisor de dos resistencias iguales) y el emisor, 0,6 V por debajo: 5,4 V sobre 5,6 kΩ son 0,96 mA. El colector va directo al raíl: no hace falta $R_C$, porque la salida no se toma ahí.
  - Si la base sube 1 V, el emisor sube 1 V (la unión mantiene sus 0,6 V): la salida *sigue* a la entrada, en fase y con ganancia de tensión algo menor que 1. De ahí el nombre.
  - La corriente que la carga toma del emisor la pone casi entera el raíl, a través del colector; la base solo aporta $1 slash (beta + 1)$ de ella. Por eso, vista desde la entrada, una carga $R$ en el emisor parece $beta$ veces mayor: con 1 kΩ de carga ($R_E parallel R_L approx 850$ Ω), el transistor presenta unos 85 kΩ. El divisor (23,5 kΩ) queda en paralelo y la entrada total es de unos 18 kΩ.
  - Visto desde la carga, el emisor es una fuente de impedancia muy baja: $r_e$ (unos 26 Ω) más la resistencia de la fuente dividida por $beta$. La carga casi no consigue mover la tensión del emisor.
]

#ejemplo(titulo: [un oscilador que alimenta una carga de 1 kΩ])[
  Un oscilador entrega su señal con una resistencia interna de 2 kΩ, y la etapa siguiente tiene una entrada de 1 kΩ. Conectados directamente, a la carga llega $1 slash (2 + 1) approx 33$ % de la tensión, y el oscilador «ve» 1 kΩ colgados de su tanque.

  Con el seguidor de la @i2b-fig-seguidor en medio, el oscilador ve 18 kΩ: a la base llega $18 slash (2 + 18) = 90$ % de la tensión. El emisor la copia con una resistencia de salida de unos $26 + 2000 slash 100 approx 45$ Ω, y la carga recibe $1000 slash 1045 approx 96$ % de lo que hay en el emisor. En total, el 86 % de la tensión, en lugar del 33 %, y el oscilador casi no nota la carga. La ganancia de tensión es menor que 1, pero la de potencia es grande.
]

=== Base común: el preamplificador de VHF y UHF

#ptitulo[El problema que resuelve] En el emisor común hay un condensador escondido: la capacidad de unos pocos picofaradios entre el colector y la base, dentro del propio transistor. Une la salida con la entrada, y como la salida es 190 veces mayor e invertida, esa capacidad «tira» de la entrada como si fuera 190 veces mayor: es el *efecto Miller*. Con 2 pF, la entrada ve unos 380 pF. En audio no importa; a 145 MHz esa capacidad es casi un cortocircuito a masa, la ganancia se hunde y la realimentación entre salida y entrada puede hacer oscilar la etapa. La base común lo evita: la base, unida a masa, queda entre la entrada (emisor) y la salida (colector) como una pantalla (@i2b-fig-basecomun).

#circuito(sim: fc.at("base-comun"), caption: [Amplificador en base común. La señal entra por el emisor y sale por el colector. La base está polarizada por el divisor $R_1$–$R_2$ y unida a masa para la señal por $C_B$. Con $R_E = 3,3$ kΩ, la corriente de reposo es de unos 0,46 mA y la impedancia de entrada, $r_e approx 55$ Ω, queda cerca de los 50 Ω de un coaxial. En un preamplificador real, $R_C$ sería un circuito sintonizado (#ver(<sec-amp-sintonizado>)).])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    wire((0.8, 6), (9.8, 6))
    node("v0", (0.8, 6), fill: false)
    content((9.9, 6), anchor: "west", _i2b-t[+12 V])
    wire((0.8, 0), (9.8, 0))
    node("m0", (0.8, 0), fill: false)
    content((9.9, 0), anchor: "west", _i2b-t[masa])
    // entrada y emisor
    capacitor("cin", (0.8, 3.0), (2.2, 3.0), label: _i2b-e($C_"ent"$), n: "o-")
    wire((2.2, 3.0), (3.2, 3.0))
    node("ne", (3.2, 3.0))
    resistor("re", (3.2, 3.0), (3.2, 0), label: (content: _i2b-e($R_E space 3,3 "k"$), anchor: "south"))
    node("ne0", (3.2, 0))
    // transistor girado: emisor a la izquierda, colector a la derecha, base abajo
    npn("q", (5.6, 3.0), scale: (-1.0, 1.0), rotate: -90deg)
    wire((3.2, 3.0), "q.e")
    wire("q.c", (7.2, 3.0))
    // colector
    resistor("rc", (7.2, 6), (7.2, 3.0), label: _i2b-e($R_C space 10 "k"$))
    node("nc", (7.2, 3.0))
    node("nc6", (7.2, 6))
    wire((7.2, 3.0), (8.0, 3.0))
    capacitor("cout", (8.0, 3.0), (9.6, 3.0), label: _i2b-e($C_"sal"$), n: "-o")
    // base
    wire("q.b", (5.6, 1.6))
    node("nb", (5.6, 1.6))
    resistor("r2", (5.6, 1.6), (5.6, 0), label: _i2b-e($R_2 space 10 "k"$))
    node("nb0", (5.6, 0))
    wire((5.6, 1.6), (4.6, 1.6))
    capacitor("cb", (4.6, 1.6), (4.6, 0), label: (content: _i2b-e($C_B$), anchor: "south"))
    node("ncb", (4.6, 0))
    resistor("r1", (5.6, 1.6), (8.0, 1.6), label: _i2b-e($R_1 space 47 "k"$))
    node("vr1", (8.0, 1.6), fill: false)
    content((8.1, 1.6), anchor: "west", _i2b-t[+12 V])
    // continua y señal
    content((5.5, 1.7), anchor: "south-east", _i2b-t(color: col.ambar, size: 7pt)[2,1 V])
    content((3.1, 3.15), anchor: "south-east", _i2b-t(color: col.ambar, size: 7pt)[1,5 V])
    content((7.35, 3.15), anchor: "south-west", _i2b-t(color: col.ambar, size: 7pt)[7,4 V])
    _i2b-flecha((0.0, 3.55), (0.9, 3.55), color: col.senal1, etq: [50 Ω], anchor: "south")
    _i2b-flecha((9.2, 3.55), (10.1, 3.55), color: col.senal1, etq: [×180], anchor: "south")
  })
] <i2b-fig-basecomun>

#porque[
  - La polarización es la del emisor común: el divisor deja la base a 2,1 V, el emisor queda a 1,5 V, y $R_E$ fija la corriente (1,5 V / 3,3 kΩ ≈ 0,46 mA). El colector reposa a $12 - 0,46 dot 10 approx 7,4$ V.
  - $C_B$ pone la base a masa para la señal. La señal ya no entra por la base: entra por el emisor. Subir el emisor equivale a bajar la base, así que la corriente de colector *baja* cuando la entrada sube, el colector *sube*, y la salida queda *en fase* con la entrada.
  - Entrar por el emisor es entrar por la unión sin nada delante: la impedancia de entrada es $r_e = 25 "mV" slash 0,46 "mA" approx 55$ Ω. Casi la de un coaxial de 50 Ω: el preamplificador se adapta casi solo a la antena.
  - Toda la corriente que entra por el emisor sale por el colector ($alpha approx 0,99$): no hay ganancia de corriente. Pero esa corriente entra por 55 Ω y sale por 10 kΩ: la tensión se multiplica por $R_C slash r_e approx 180$.
  - La base a masa separa la salida de la entrada. La capacidad colector-base va ahora del colector a masa, no a la entrada: no hay efecto Miller, y la etapa es estable a frecuencias muy altas sin trucos de neutralización.
]

=== Las tres, frente a frente

#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr),
    align: (left, left, left, left),
    [], [*Emisor común*], [*Colector común* \ (seguidor de emisor)], [*Base común*],
    [Entra por / sale por], [base / colector], [base / emisor], [emisor / colector],
    [Ganancia de tensión], [alta ($R_C slash r_e$: decenas a cientos)], [≈ 1 (algo menor)], [alta ($R_C slash r_e$)],
    [Ganancia de corriente], [alta ($beta$)], [alta ($beta + 1$)], [≈ 1 (algo menor: $alpha$)],
    [Ganancia de potencia], [la mayor], [media], [media],
    [Impedancia de entrada], [media (kΩ)], [alta (decenas o cientos de kΩ)], [muy baja (decenas de Ω)],
    [Impedancia de salida], [media-alta ($approx R_C$)], [muy baja (decenas de Ω)], [alta],
    [Fase], [invertida (180°)], [en fase (0°)], [en fase (0°)],
    [Uso típico en la radio], [ganancia general: RF, FI y audio], [separador tras el oscilador; excitar cargas de baja impedancia], [preamplificadores de VHF y UHF; entrada de 50 Ω],
  ),
  caption: [Las tres configuraciones del transistor bipolar.],
) <i2b-tab-configuraciones>

#ptitulo[El mismo trío en el FET y en la válvula] Las tres configuraciones existen en todo dispositivo de tres terminales, con nombres paralelos. En el FET (#ver(<sec-fet>)): *fuente común*, *drenador común* (el _seguidor de fuente_) y *puerta común*. En la válvula: cátodo común, placa común (el _seguidor de cátodo_) y rejilla común, que es la base común de las válvulas y por eso tiene, como ella, la entrada de baja impedancia.

#ojo[
  - El colector común se llama también *seguidor de emisor* (C-T3.18): ganancia de tensión casi 1, ganancia de corriente alta, impedancia de entrada alta y de salida baja.
  - La base común amplifica *tensión, pero no corriente* (T3.37): la corriente de salida es prácticamente la de entrada.
  - El emisor común amplifica tensión y corriente: el único de los tres que *invierte* la fase.
  - Si te preguntan qué montaje tiene la impedancia de entrada más alta, es el colector común; la más baja, la base común.
]

== Las clases de amplificador <sec-clases>

#motivacion(titulo: [en el transmisor, cada vatio que no sale por la antena es calor])[
  En el receptor la eficiencia casi no importa: las etapas manejan milivatios. En la etapa final del transmisor lo decide todo. Un equipo de 100 W que aprovecha la mitad de lo que consume toma 200 W de la fuente y convierte 100 W en calor dentro de sus transistores: radiador grande, ventilador y una batería que dura la mitad. El dato que importa es el *rendimiento*, $eta = P_"salida" slash P_"alimentación"$. Y aquí aparece un conflicto. El transistor más fiel es el grifo entreabierto de las secciones anteriores, que copia la onda entera pero gasta corriente aunque no haya señal. El más eficiente es el interruptor, que casi no disipa pero no copia nada. Las *clases* de amplificación son los puntos intermedios entre esos dos extremos.
]

#ptitulo[La clase la decide el punto de reposo] Todo depende de dónde se aparca el punto de trabajo, es decir, de cuánta tensión continua tiene la base respecto al umbral de conducción de 0,6 V. La @i2b-fig-clases lo muestra. A la izquierda, la tensión de la base: una sinusoide montada sobre la tensión de reposo; la línea de trazos es el umbral, y solo la parte de la onda que queda por encima hace conducir al transistor. A la derecha, la corriente de colector que resulta. La fracción del ciclo durante la cual el transistor conduce se mide en grados y se llama *ángulo de conducción*: 360° es el ciclo entero.

#circuito(sim: fc.at("clases-ab"), caption: [El ángulo de conducción de cada clase. A la izquierda, la tensión de la base (entrada) frente al umbral de conducción de unos 0,6 V (trazos): en rojo, la parte de la onda que hace conducir al transistor. A la derecha, la corriente de colector (salida). Cuanto más bajo se polariza la base, menos parte del ciclo conduce el transistor: menos se parece la salida a la entrada, y menos energía se pierde en calor.])[
  #cetz.canvas({
    import cetz.draw: *
    let T = 2.2
    let a = 0.45
    content((2.2, 1.3), anchor: "south", _i2b-t(color: col.gris)[tensión de base y umbral])
    content((7.7, 1.3), anchor: "south", _i2b-t(color: col.gris)[corriente de colector])
    for (k, (nombre, off, ang, rend)) in (
      ([Clase A], 0.55, [360°], [25–50 %]),
      ([Clase AB], 0.15, [entre 180° y 360°], [50–78,5 %]),
      ([Clase B], 0.0, [180°], [hasta 78,5 %]),
      ([Clase C], -0.25, [menos de 180°], [hasta 85–90 %]),
    ).enumerate() {
      let y0 = -k * 1.68
      content((-0.25, y0 + 0.2), anchor: "east", text(size: 8pt, weight: "bold", nombre))
      // entrada: sinusoide y umbral
      line((0, y0), (4.5, y0), stroke: (paint: col.gris, dash: "dashed", thickness: 0.6pt))
      onda(t => y0 + off + a * calc.sin(2 * calc.pi * t / T), 0, 4.4, n: 180, stroke: 0.9pt + col.gris)
      if off >= a {
        onda(t => y0 + off + a * calc.sin(2 * calc.pi * t / T), 0, 4.4, n: 180, stroke: 1.4pt + col.senal2)
      } else {
        // tramos en que la base supera el umbral
        let phi = calc.asin(-off / a).rad()
        for c in range(3) {
          let t1 = calc.max(0, (phi + 2 * calc.pi * c) * T / (2 * calc.pi))
          let t2 = calc.min(4.4, (calc.pi - phi + 2 * calc.pi * c) * T / (2 * calc.pi))
          if t2 > t1 {
            onda(t => y0 + off + a * calc.sin(2 * calc.pi * t / T), t1, t2, n: 60, stroke: 1.4pt + col.senal2)
          }
        }
      }
      content((4.55, y0), anchor: "west", _i2b-t(size: 6.5pt, color: col.gris)[0,6 V])
      // salida: corriente
      line((5.5, y0 - 0.45), (10, y0 - 0.45), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.5))
      line((5.5, y0 - 0.45), (5.5, y0 + 0.75), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.5))
      group({
        translate((5.5, 0))
        onda(t => y0 - 0.45 + calc.max(0, off + a * calc.sin(2 * calc.pi * t / T)), 0, 4.4, n: 180, stroke: 1.4pt + col.senal1)
      })
      content((10.3, y0 + 0.25), anchor: "west", _i2b-t[conduce #ang])
      content((10.3, y0 - 0.15), anchor: "west", _i2b-t(color: col.verde)[$eta_"máx"$: #rend])
    }
  })
] <i2b-fig-clases>

#ptitulo[Clase A: el grifo siempre abierto] Es el amplificador de las secciones anteriores. El punto de reposo está en el centro de la zona activa y la señal nunca llega a cortar el transistor: conduce los 360° del ciclo y la salida es una copia fiel. Es la clase de *mínima distorsión*. El precio: la corriente de reposo circula siempre, haya señal o no, y la fuente entrega $V_"CC" I_Q$ continuamente. Con una resistencia en el colector, la mayor sinusoide que cabe aprovecha como mucho el 25 % de esa potencia. Con una bobina de choque o un transformador en lugar de la resistencia, el colector puede oscilar entre casi cero y el doble de la tensión de alimentación, y el límite sube al 50 %. En la práctica, del 20 al 35 %. Es la clase de los preamplificadores, de las etapas de FI y de toda la pequeña señal, donde los milivatios perdidos no importan.

#ptitulo[Clase B: dos medios grifos] La base se polariza justo en el umbral, sin corriente de reposo. El transistor conduce solo en los semiciclos que lo abren: 180°. Media onda no es una copia, así que se usan *dos* transistores en *contrafase* (_push-pull_), uno para cada semiciclo (@i2b-fig-contrafase). Sin señal no consumen nada, y el rendimiento máximo teórico sube a $pi slash 4 approx 78,5$ %.

#ptitulo[Clase AB: el compromiso] Con la base un poco por encima del umbral, cada transistor tiene una pequeña corriente de reposo y conduce algo más de medio ciclo, entre 180° y 360° (por eso se dice que *combina* las clases A y B). Los dos transistores del contrafase se solapan un poco en el cruce por cero y eliminan la distorsión de cruce de la clase B. El rendimiento queda entre el de A y el de B, en la práctica del 50 al 65 %. Es la clase de los *amplificadores lineales* de los transceptores de SSB.

#ptitulo[Clase C: pulsos] La base se polariza *por debajo* del umbral (con tensión negativa, o simplemente a 0~V a través de una bobina de choque). El transistor solo conduce en las crestas de la excitación, menos de 180° (típicamente unos 120°), y la corriente de colector es un tren de pulsos estrechos que ya no se parece en nada a la entrada. Pero los pulsos llegan justo cuando la tensión del colector está en su mínimo, de modo que el transistor casi nunca tiene a la vez tensión y corriente: disipa muy poco. Rendimiento del 70 al 85 %, y más con ángulos más estrechos (con menos potencia de salida). ¿Cómo se convierte un tren de pulsos en una sinusoide? Con un circuito resonante en el colector: lo veremos en #ver(<sec-amp-sintonizado>).

#ptitulo[Clases D y E: el interruptor] Llevando la idea al extremo, el transistor trabaja como el interruptor de #ver(<i2b-sec-zonas>): o en corte o en saturación, sin pasar nunca por la zona activa. Idealmente no disipa nada; en la práctica el rendimiento pasa del 90 %. En *clase D* (audio) el interruptor se abre y se cierra a alta frecuencia con una duración proporcional a la señal, y un filtro LC reconstruye la onda (#falstad("classd.txt")). En *clase E* (RF) el interruptor trabaja sobre una red resonante calculada para que la tensión del transistor sea cero en el instante de conmutar. Como la clase C, solo valen para señales de amplitud constante, salvo que la amplitud se restituya por otro camino (variando la alimentación, por ejemplo).

#figure(
  table(
    columns: (auto, 2.7cm, 1.6cm, 2.5cm, 2.3cm, 1fr),
    align: (left, left, left, left, left, left),
    [*Clase*], [*Punto de reposo*], [*Conduce*], [*$eta$ máx.*], [*Linealidad*], [*Uso en la radio*],
    [A], [centro de la zona activa], [360°], [25 % (50 % con transformador)], [la mejor], [preamplificadores, FI, audio de pequeña señal],
    [AB], [algo por encima del umbral], [180°–360°], [50–78,5 %], [buena (en contrafase)], [finales lineales de SSB y AM],
    [B], [en el umbral], [180°], [78,5 %], [distorsión de cruce], [audio en contrafase],
    [C], [por debajo del umbral], [< 180°], [hasta 85–90 %], [nula: pulsos], [finales de CW y FM, multiplicadores de frecuencia],
    [D, E], [conmutación], [—], [> 90 %], [nula sin ayuda], [audio (D); RF de CW y FM, equipos modernos (E)],
  ),
  caption: [Las clases de amplificación.],
) <i2b-tab-clases>

#ejemplo(titulo: [100 W en la antena, tres facturas de calor])[
  Para entregar 100 W a la antena, la fuente tiene que dar $P_"alim" = 100 slash eta$, y la diferencia se queda en los transistores como calor:
  - Clase A con $eta = 25$ %: 400 W de la fuente, 300 W de calor.
  - Clase AB con $eta = 60$ %: unos 167 W de la fuente, 67 W de calor.
  - Clase C con $eta = 80$ %: 125 W de la fuente, 25 W de calor.
  La clase C calienta doce veces menos que la A para la misma potencia de salida. Por eso nadie construye un final de 100 W en clase A, y por eso los equipos de FM de mano, que funcionan con batería, usan finales en clase C.
]

=== El contrafase y la distorsión de cruce

#ptitulo[Dos transistores, un semiciclo cada uno] La @i2b-fig-contrafase (a) es la etapa de clase B más sencilla: un NPN arriba y un PNP abajo, los dos en colector común (seguidores de emisor), con los emisores unidos a la carga. En el semiciclo positivo conduce el NPN y empuja corriente desde $+V_"CC"$ hacia la carga; en el negativo conduce el PNP y la tira hacia $-V_"CC"$. Cada uno descansa mientras trabaja el otro.

#circuito(caption: [Etapas de salida en contrafase. (a) Clase B: las bases están unidas y los dos transistores están en corte sin señal. (b) Clase AB: dos diodos separan las bases unos 1,2 V, de modo que cada transistor queda justo en el umbral de conducción y la distorsión de cruce desaparece. En los dos casos los transistores trabajan como seguidores de emisor sobre una carga de baja impedancia, por ejemplo un altavoz de 8 Ω.], sim: "pushpull.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    for (ox, ab) in ((0, false), (6.4, true)) {
      let xq = ox + 2.6
      let xb = ox + 1.2
      npn("", (xq, 4.0))
      pnp("", (xq, 1.6))
      wire((xq, 4.5), (xq, 5.3))
      vcc("", (xq, 5.3), label: _i2b-t[$+V_"CC"$])
      wire((xq, 1.1), (xq, 0.3))
      vee("", (xq, 0.3), label: _i2b-t[$-V_"CC"$])
      wire((xq, 3.5), (xq, 2.1))
      node("", (xq, 2.8))
      wire((xq, 2.8), (xq + 1.3, 2.8))
      resistor("", (xq + 1.3, 2.8), (xq + 1.3, 0.9), label: _i2b-e[carga])
      ground("", (xq + 1.3, 0.9))
      wire((xb, 4.0), (xq - 0.68, 4.0))
      wire((xb, 1.6), (xq - 0.68, 1.6))
      if ab {
        resistor("", (xb, 5.3), (xb, 4.0), label: (content: _i2b-e($R_1$), anchor: "south"))
        vcc("", (xb, 5.3), label: _i2b-t[$+V_"CC"$])
        diode("", (xb, 4.0), (xb, 2.8), label: (content: _i2b-e($D_1$), anchor: "south"))
        diode("", (xb, 2.8), (xb, 1.6), label: (content: _i2b-e($D_2$), anchor: "south"))
        resistor("", (xb, 1.6), (xb, 0.3), label: (content: _i2b-e($R_2$), anchor: "south"))
        vee("", (xb, 0.3), label: _i2b-t[$-V_"CC"$])
        node("", (xb, 4.0))
        node("", (xb, 1.6))
        node("", (xb, 2.8))
        capacitor("", (ox - 0.6, 2.8), (xb, 2.8), n: "o-")
        content((ox - 0.6, 3.05), anchor: "south", _i2b-t(color: col.senal1)[entrada])
      } else {
        wire((xb, 4.0), (xb, 1.6))
        node("", (xb, 2.8))
        wire((ox, 2.8), (xb, 2.8))
        node("", (ox, 2.8), fill: false)
        content((ox, 3.05), anchor: "south", _i2b-t(color: col.senal1)[entrada])
      }
      content((xq + 0.15, 4.5), anchor: "west", _i2b-t(size: 7pt)[NPN])
      content((xq + 0.15, 1.1), anchor: "west", _i2b-t(size: 7pt)[PNP])
      content((ox + 2.6, -1.05), anchor: "north", text(size: 8pt, weight: "bold", if ab [(b) clase AB] else [(a) clase B]))
    }
  })
] <i2b-fig-contrafase>

#porque[
  - Cada transistor es un seguidor de emisor (#ver(<sec-configuraciones>)): copia la tensión de su base, 0,6 V más abajo (NPN) o más arriba (PNP), y entrega a la carga mucha corriente con poca corriente de base. Por eso el contrafase sirve para mover cargas de baja impedancia.
  - En (a), las bases están unidas. Mientras la entrada está entre −0,6 V y +0,6 V, ninguna de las dos uniones base-emisor llega al umbral: los dos transistores están en corte y la salida se queda en cero. Ese hueco es la *distorsión de cruce* (@i2b-fig-cruce).
  - En (b), $R_1$, $D_1$, $D_2$ y $R_2$ forman una escalera entre $+V_"CC"$ y $-V_"CC"$. Cada diodo conduce y cae unos 0,6 V, la misma tensión que la unión base-emisor: la base del NPN queda 0,6 V por encima del punto medio y la del PNP, 0,6 V por debajo. Los dos transistores esperan justo en el umbral, con una pequeña corriente de reposo, y el menor movimiento de la entrada hace conducir a uno u otro: clase AB.
  - Los diodos se montan pegados a los transistores. Si estos se calientan, la tensión de los diodos baja con la de las uniones (unos 2 mV por grado) y la corriente de reposo no se dispara: es otra vez la defensa contra el embalamiento térmico. En los montajes reales se añaden además resistencias pequeñas en serie con los emisores. Puedes ver el montaje sin diodos en #falstad("pushpullxover.txt").
]

#circuito(caption: [La distorsión de cruce. (a) En clase B, la salida (azul) se queda en cero mientras la entrada (trazos) no supera los 0,6 V que necesita cada unión base-emisor: un escalón muerto en cada paso por cero. Arriba trabaja el NPN; abajo, el PNP. (b) En clase AB los diodos dejan a los transistores en el umbral y la salida sigue a la entrada sin hueco.], sim: "pushpullxover.txt")[
  #cetz.canvas({
    import cetz.draw: *
    let T = 3.0
    let A = 1.0
    let u = 0.3
    for (k, ab) in ((0, false), (1, true)) {
      group({
        translate((k * 7.2, 0))
        rect((0, -u), (6.1, u), fill: col.gris-claro, stroke: none)
        line((0, 0), (6.4, 0), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
        line((0, -1.3), (0, 1.4), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
        content((6.4, -0.05), anchor: "north-east", _i2b-t(size: 7pt)[$t$])
        onda(t => A * calc.sin(2 * calc.pi * t / T), 0, 6.0, n: 200, stroke: (paint: col.gris, dash: "dashed", thickness: 0.8pt))
        if ab {
          onda(t => 0.95 * A * calc.sin(2 * calc.pi * t / T), 0, 6.0, n: 200, stroke: 1.3pt + col.senal1)
        } else {
          onda(t => {
            let v = A * calc.sin(2 * calc.pi * t / T)
            if v > u { v - u } else if v < -u { v + u } else { 0 }
          }, 0, 6.0, n: 300, stroke: 1.3pt + col.senal1)
          content((0.9, 1.1), anchor: "south", _i2b-t(size: 7pt, color: col.senal1)[NPN])
          content((2.4, -1.1), anchor: "north", _i2b-t(size: 7pt, color: col.senal1)[PNP])
          line((3.0, 0.08), (3.0, 1.42), stroke: 0.4pt + col.gris)
          content((3.0, 1.45), anchor: "south", _i2b-t(size: 7pt)[zona muerta: ±0,6 V])
        }
        content((3.0, -1.45), anchor: "north", text(size: 8pt, weight: "bold", if ab [(b) clase AB] else [(a) clase B]))
      })
    }
  })
] <i2b-fig-cruce>

#ptitulo[Por qué importa en una radio] La distorsión de cruce afecta sobre todo a las señales pequeñas, que pasan la mayor parte del tiempo cerca del cero: en audio suena áspera, y en un transmisor de SSB genera productos que ensanchan la señal. Los finales lineales de un transceptor de HF son, casi siempre, un contrafase en clase AB, con transformadores en lugar de la carga directa y una corriente de reposo ajustada en fábrica.

=== Qué modos admiten cada clase

La pregunta clave es *dónde viaja la información*.

- En *AM* y en *SSB* la información va en la *amplitud* de la señal de radio (#ver(<sec-am>)). El amplificador tiene que reproducir esa amplitud tal cual: hace falta un amplificador *lineal*, de clase A o AB (o B en contrafase). Un clase C no conserva la amplitud: aplasta la envolvente, destruye la información y genera productos espurios fuera del canal (las «salpicaduras» o _splatter_).
- En *FM* la información va en la frecuencia (#ver(<sec-fm>)), y en *CW* en la presencia o ausencia de la portadora. La amplitud es constante y no lleva nada: un clase C, con su tanque de salida, entrega una sinusoide de la misma frecuencia y no se pierde información. Se gana rendimiento sin perder nada.
- Un caso especial: la AM de alto nivel. Un transmisor de AM clásico usa un final en clase C y aplica la modulación _en la alimentación_ del colector: la amplitud de salida de una etapa en clase C saturada es proporcional a su tensión de alimentación, y así sigue a la voz. Lo que no se puede hacer es amplificar en clase C una señal de AM _ya modulada_.
- Un amplificador lineal sobreexcitado deja de serlo: recorta las crestas como un clase C y salpica. Por eso los transceptores limitan la excitación con el control automático de nivel (ALC).

#ojo[
  - La clase de *mínima distorsión* es la A (T3.6), y conduce los *360°* del ciclo (T3.21).
  - La clase B conduce *180°* (T3.22), y por eso se monta en contrafase.
  - La clase AB es una *combinación de las clases A y B* (T3.11): conduce entre 180° y 360°; es la de los finales lineales de SSB.
  - La de *mayor rendimiento* de las cuatro (A, AB, B, C) es la C (T3.23), que conduce menos de 180°.
  - Un amplificador de clase C solo puede emplearse con emisiones de *amplitud constante, como CW o FM* (T3.24); nunca en SSB, por mucho que se ajuste la polarización.
]

== El amplificador sintonizado de RF <sec-amp-sintonizado>

#motivacion(titulo: [amplificar solo lo que interesa, y rehacer la sinusoide])[
  El amplificador con $R_C$ tiene dos defectos en radiofrecuencia. El primero: amplifica _todo_ por igual. La antena entrega a la vez la emisora que quieres en 7 MHz, una de radiodifusión potentísima en 6 MHz, ruido de todas las frecuencias y lo que se cuele de otras bandas; una etapa de banda ancha los sube a todos, y la etapa siguiente se satura con lo que no querías. El segundo defecto aparece en el transmisor: la etapa de clase C entrega pulsos de corriente, no una sinusoide, y a la antena tiene que llegar una sinusoide limpia. Las dos cosas se arreglan con la misma pieza: cambiar $R_C$ por un *circuito resonante LC* sintonizado a la frecuencia de trabajo (#ver(<sec-resonancia>)).
]

#ptitulo[El tanque como carga] La ganancia del emisor común es $g_m$ por la impedancia que el colector tiene como carga. Con $R_C$, esa impedancia es la misma a todas las frecuencias. Con un *tanque* LC en paralelo es otra cosa. A la frecuencia de resonancia $f_0$, la bobina y el condensador se compensan y el tanque presenta una resistencia alta, la *resistencia dinámica* $R_D = Q X_L$, de miles de ohmios. Lejos de $f_0$, la bobina cortocircuita las frecuencias bajas y el condensador las altas, y la impedancia cae a unas decenas de ohmios. La ganancia sigue a la impedancia: es grande alrededor de $f_0$, en una banda de anchura $f_0 slash Q$, y casi nula fuera. La etapa amplifica y filtra a la vez (@i2b-fig-sintonizado).

#circuito(sim: fc.at("clase-c"), caption: [Amplificadores sintonizados. (a) De pequeña señal, en clase A: la polarización es la del emisor común, pero la carga del colector es el tanque $L$–$C_T$; un devanado secundario de pocas espiras saca la señal hacia la etapa siguiente sin cargar el tanque. (b) Final en clase C: la base vuelve a masa por una bobina de choque, sin polarización, y el transistor solo conduce en las crestas de la excitación; el tanque del colector restituye la sinusoide y la red de salida elimina los armónicos.])[
  #esquema(escala: 0.85, {
    import zap: *
    import cetz.draw: content, line
    // (a) clase A sintonizado
    wire((0.4, 6.2), (7.0, 6.2))
    node("v0", (0.4, 6.2), fill: false)
    content((0.4, 6.45), anchor: "south-west", _i2b-t[+12 V])
    wire((0.4, 0), (6.0, 0))
    node("m0", (0.4, 0), fill: false)
    resistor("r1", (2.0, 6.2), (2.0, 2.8), label: (content: _i2b-e($R_1$), anchor: "south"))
    resistor("r2", (2.0, 2.8), (2.0, 0), label: (content: _i2b-e($R_2$), anchor: "south"))
    node("n1", (2.0, 6.2))
    node("n2", (2.0, 2.8))
    node("n3", (2.0, 0))
    capacitor("cin", (0.4, 2.8), (2.0, 2.8), label: _i2b-e($C_"ent"$), n: "o-")
    npn("q", (4.4, 2.8))
    wire((2.0, 2.8), "q.b")
    wire("q.e", (4.4, 1.6))
    resistor("re", (4.4, 1.6), (4.4, 0), label: (content: _i2b-e($R_E$), anchor: "south"))
    node("n4", (4.4, 1.6))
    node("n5", (4.4, 0))
    wire((4.4, 1.6), (5.4, 1.6))
    capacitor("ce", (5.4, 1.6), (5.4, 0), label: _i2b-e($C_E$))
    node("n6", (5.4, 0))
    trafo("t", (5.4, 4.7), nucleo: false, espiras: (4, 2))
    wire("t.p1", (4.4, 6.2))
    wire("t.p2", "q.c")
    node("n7", (4.4, 6.2))
    node("n8", (4.4, 5.5))
    node("n9", (4.4, 3.9))
    wire((4.4, 5.5), (3.4, 5.5))
    wire((4.4, 3.9), (3.4, 3.9))
    capacitor("ct", (3.4, 5.5), (3.4, 3.9), label: (content: _i2b-e($C_T$), anchor: "south"))
    content((5.0, 5.75), anchor: "south", _i2b-t[$L$])
    wire("t.s1", (7.0, 5.1))
    node("o1", (7.0, 5.1), fill: false)
    content((7.05, 5.35), anchor: "south", _i2b-t(color: col.senal1)[a la etapa siguiente])
    wire("t.s2", (6.4, 3.9))
    ground("gs", (6.4, 3.9))
    content((3.6, -0.75), anchor: "north", text(size: 8pt, weight: "bold")[(a) clase A sintonizado])
    // (b) final en clase C
    let ox = 9.2
    wire((ox + 1.6, 6.2), (ox + 4.2, 6.2))
    node("v1", (ox + 1.6, 6.2), fill: false)
    content((ox + 1.6, 6.45), anchor: "south-west", _i2b-t[+12 V])
    wire((ox + 0.0, 0), (ox + 4.2, 0))
    node("m1", (ox + 0.0, 0), fill: false)
    capacitor("cinb", (ox + 0.0, 2.8), (ox + 1.4, 2.8), n: "o-")
    content((ox - 0.1, 2.8), anchor: "east", align(right, _i2b-t(color: col.senal1)[excita-\ ción]))
    node("nb", (ox + 1.4, 2.8))
    inductor("lb", (ox + 1.4, 2.8), (ox + 1.4, 0), label: (content: _i2b-e[choque], anchor: "south"))
    node("nb0", (ox + 1.4, 0))
    npn("qc", (ox + 3.0, 2.8))
    wire((ox + 1.4, 2.8), "qc.b")
    wire("qc.e", (ox + 3.0, 0))
    node("ne0", (ox + 3.0, 0))
    inductor("lt", (ox + 3.0, 6.2), (ox + 3.0, 4.2), label: _i2b-e($L$))
    node("nt1", (ox + 3.0, 6.2))
    node("nt2", (ox + 3.0, 4.2))
    wire((ox + 3.0, 4.2), "qc.c")
    wire((ox + 3.0, 6.2), (ox + 4.2, 6.2))
    capacitor("ctb", (ox + 4.2, 6.2), (ox + 4.2, 4.2), label: _i2b-e($C_T$))
    wire((ox + 4.2, 4.2), (ox + 3.0, 4.2))
    wire((ox + 3.0, 3.6), (ox + 4.6, 3.6))
    node("nc", (ox + 3.0, 3.6))
    capacitor("cs", (ox + 4.6, 3.6), (ox + 5.8, 3.6), label: (content: _i2b-e($C_"sal"$), anchor: "south"), n: "-o")
    content((ox + 5.85, 3.95), anchor: "south", align(center, _i2b-t(color: col.senal1)[a la red en pi \ y la antena]))
    content((ox + 2.4, -0.75), anchor: "north", text(size: 8pt, weight: "bold")[(b) final en clase C])
  })
] <i2b-fig-sintonizado>

#porque[
  - En (a) la polarización es la de siempre: divisor, $R_E$ y $C_E$. La bobina del tanque deja pasar la continua del colector (para la continua es un cable), así que el colector reposa casi a 12 V y puede subir por encima de ellos en los semiciclos positivos: la bobina devuelve la energía que guarda.
  - A $f_0$ el tanque presenta una resistencia de miles de ohmios y la ganancia es la de un emisor común con esa carga. A otras frecuencias la impedancia cae y la ganancia con ella.
  - La salida no se toma directamente del colector: una carga de impedancia baja colgada del tanque le quitaría $Q$, y con él la selectividad. El secundario de pocas espiras transforma la impedancia en la proporción del cuadrado de las espiras (#ver(<sec-transformador>)): el tanque apenas nota la etapa siguiente.
  - En (b) la base vuelve a masa por una bobina de choque, que deja pasar la continua y bloquea la RF. Sin polarización, el transistor solo conduce cuando la excitación supera los 0,6 V: clase C. El emisor va directo a masa y el tanque del colector convierte los pulsos en sinusoide (@i2b-fig-volante). $C_"sal"$ bloquea la continua hacia la red de salida.
]

#ejemplo(titulo: [un amplificador para 40 metros])[
  Queremos el tanque a 7,05 MHz con una bobina de 2 μH. El condensador sale de la frecuencia de resonancia: $C = 1 slash ((2 pi f_0)^2 L) approx 255$ pF. La reactancia de la bobina es $X_L = 2 pi f_0 L approx 89$ Ω y, con $Q = 50$, la resistencia dinámica vale $R_D = Q X_L approx 4,4$ kΩ.

  Con $I_C = 1$ mA ($g_m = 40$ mS), la ganancia a 7,05 MHz es $40 "mS" dot 4,4 "kΩ" approx 177$. A 14,1 MHz el mismo tanque solo presenta unos 59 Ω, y la ganancia baja a $0,04 dot 59 approx 2,4$; a 3,6 MHz, lo mismo. La etapa amplifica los 40 metros unas 75 veces más que las bandas vecinas. Su anchura de banda es $f_0 slash Q = 7,05 "MHz" slash 50 approx 140$ kHz: cubre la banda entera.
]

#ptitulo[El efecto volante] Un tanque cargado oscila solo: la energía va y viene entre el campo eléctrico del condensador y el magnético de la bobina (#ver(<sec-resonancia>)), y cada ciclo pierde solo una pequeña fracción, $2 pi slash Q$. Si en cada ciclo un pulso de corriente repone exactamente lo perdido, el tanque mantiene su oscilación sinusoidal aunque el pulso dure solo un tercio del ciclo. Es el *efecto volante*, por el volante de inercia de un motor, que recibe un empujón en cada explosión y gira suave entre una y otra (@i2b-fig-volante). Cuanto mayor es el $Q$, más energía guarda el tanque en relación con lo que pierde, y más pura sale la sinusoide.

#analogia[Un columpio. No lo empujas durante todo el recorrido: le das un empujón corto en el mismo punto de cada vaivén, y el columpio describe un arco suave y completo. El empujón es el pulso de corriente de la clase C; el columpio, el tanque; el arco, la sinusoide de salida.]

#circuito(caption: [El efecto volante en un final de clase C. Arriba, la corriente de colector: un pulso estrecho (unos 120°) por ciclo. Abajo, la tensión del colector: una sinusoide completa alrededor de los 12 V de alimentación, que el tanque mantiene entre pulso y pulso. Los pulsos llegan cuando el colector está en su mínimo: el transistor conduce justo cuando tiene poca tensión encima, y por eso disipa poco.])[
  #cetz.canvas({
    import cetz.draw: *
    let T = 2.4
    // corriente
    group({
      translate((0, 3.4))
      line((0, 0), (8.2, 0), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
      line((0, 0), (0, 1.3), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
      content((0.08, 1.3), anchor: "north-west", _i2b-t(size: 7pt)[$i_C$])
      onda(t => 2.0 * calc.max(0, calc.sin(2 * calc.pi * t / T) - 0.5), 0, 7.8, n: 400, stroke: 1.4pt + col.senal2)
      content((8.3, 0.5), anchor: "west", _i2b-t[pulsos de corriente])
    })
    // tensión del colector
    line((0, 0), (8.2, 0), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
    line((0, 0), (0, 2.9), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
    content((8.2, -0.05), anchor: "north-east", _i2b-t(size: 7pt)[$t$])
    content((0.08, 2.9), anchor: "north-west", _i2b-t(size: 7pt)[$v_C$])
    line((0, 1.3), (7.8, 1.3), stroke: (paint: col.ambar, dash: "dashed", thickness: 0.6pt))
    content((-0.08, 1.3), anchor: "east", _i2b-t(size: 7pt, color: col.ambar)[12 V])
    onda(t => 1.3 - 1.1 * calc.sin(2 * calc.pi * t / T), 0, 7.8, n: 300, stroke: 1.3pt + col.senal1)
    content((8.3, 1.3), anchor: "west", _i2b-t[tensión del tanque])
    for k in range(3) {
      let tp = T / 4 + k * T
      line((tp, 4.4), (tp, 0.2), stroke: (dash: "dotted", thickness: 0.5pt, paint: col.gris))
    }
  })
] <i2b-fig-volante>

#ptitulo[Los armónicos y el filtro de salida] Un tren de pulsos no es una sinusoide pura: por Fourier, contiene la fundamental $f_0$ y sus *armónicos*, $2 f_0$, $3 f_0$… El tanque los atenúa, pero no lo bastante: un final de 7 MHz con solo su tanque emitiría todavía armónicos audibles en 14 y 21 MHz, en otras bandas y en frecuencias de otros servicios. Por eso, entre el final y la antena, todo transmisor lleva un *filtro paso bajo*, a menudo la misma *red en pi* que adapta la baja impedancia del transistor a los 50 Ω de la antena (#ver(<sec-redes-adaptacion>)). La misma riqueza en armónicos tiene una ventaja: si el tanque se sintoniza a $2 f_0$ o a $3 f_0$ en lugar de a $f_0$, la etapa se convierte en un *multiplicador de frecuencia* (doblador, triplicador), con el que los transmisores de VHF parten de un oscilador de frecuencia más baja.

#ptitulo[Cómo se acoplan las etapas] Entre una etapa y la siguiente hay que pasar la señal sin pasar la continua y, si se puede, adaptando impedancias. Hay varias soluciones:

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: (left, left, left),
    [*Acoplo*], [*Cómo es*], [*Dónde se usa*],
    [Por condensador (RC)], [un condensador en serie y la polarización de cada etapa por separado; deja pasar una banda ancha], [audio; RF de banda ancha; la radio de este capítulo],
    [Por transformador], [primario en el colector y secundario en la etapa siguiente: aísla la continua, adapta impedancias con la relación de espiras y, si se sintoniza, filtra], [etapas de RF y FI; salida de los finales],
    [Transformador de FI], [un transformador pequeño en un bote metálico apantallado, con el primario (y a menudo el secundario) sintonizados y un núcleo de ferrita roscado para ajustarlo; dos circuitos sintonizados acoplados dan un paso banda de flancos rectos], [cadenas de FI de 455 kHz y 10,7 MHz del superheterodino],
    [Directo], [el colector de una etapa va a la base de la siguiente, sin condensador], [amplificadores de continua, circuitos integrados],
  ),
  caption: [Formas de acoplar dos etapas.],
) <i2b-tab-acoplos>

#ptitulo[El peligro: que oscile] Un amplificador sintonizado de mucha ganancia tiene todo lo que necesita un oscilador (#ver(<sec-oscilador>)): un circuito resonante y ganancia. Si una parte de la salida vuelve a la entrada en fase, por la capacidad colector-base, por el cableado o por el raíl de alimentación, la etapa oscila sola. Los remedios son los de las secciones anteriores: desacoplar el raíl, apantallar entre etapas, usar la base común o el MOSFET de doble puerta (#ver(<sec-fet>)), o *neutralizar*: devolver a la entrada, con un condensador pequeño, una muestra de la salida en oposición de fase que cancele la realimentación indeseada.

#ojo[
  - Un amplificador de clase C necesita un *circuito tanque* en la salida: el efecto volante restituye la sinusoide a partir de los pulsos.
  - Los armónicos son múltiplos enteros de la fundamental: el segundo armónico de 7 MHz está en 14 MHz (T3.47). Se eliminan con un *filtro paso bajo* a la salida del transmisor (T3.33).
  - El *multiplicador de frecuencia* sirve para aumentar la frecuencia generada por un oscilador (T5.11): es una etapa no lineal (clase C) con el tanque sintonizado a un armónico.
]

== El FET y el MOSFET <sec-fet>

#motivacion(titulo: [un grifo que no pida corriente para moverse])[
  El bipolar necesita corriente de base para gobernar la de colector, y esa corriente sale de la etapa anterior: su entrada es de unos pocos kilohmios (en el emisor común, $beta r_e approx 2,5$ kΩ con 1 mA). Para muchas fuentes de señal eso es una carga pesada: un cristal de cuarzo, un circuito sintonizado de $Q$ alto, una antena corta de impedancia alta o un micrófono de condensador pierden su señal (o su $Q$) en cuanto se les pide corriente. Lo ideal sería una válvula gobernada _solo por tensión_, como la rejilla del triodo, que no toma corriente. Es el transistor de efecto de campo.
]

El *transistor de efecto campo* (FET) logra lo mismo por otro camino: en lugar de una corriente de base, es la _tensión_ de su *puerta* la que estrangula, por campo eléctrico, un canal conductor —~no consume corriente de control, y de ahí su impedancia de entrada altísima (tema T2).

#ptitulo[El JFET por dentro] El FET de unión (JFET) de canal N es una barra de semiconductor N con dos contactos en los extremos, la *fuente* $S$ (o _surtidor_) y el *drenador* $D$: los electrones entran por la fuente y salen por el drenador (@i2b-fig-jfet). A los lados de la barra hay dos zonas P unidas entre sí, la *puerta* $G$. La unión puerta-canal se polariza siempre en *inversa* (puerta negativa respecto a la fuente): no pasa corriente por ella, pero su zona de deplexión, vacía de portadores, se mete dentro del canal y lo estrecha. Cuanto más negativa es $V_"GS"$, más ancha es la deplexión, más estrecho el canal y menor la corriente de drenador. Con $V_"GS" = 0$ el canal está abierto del todo y pasa la corriente máxima, $I_"DSS"$; a una tensión de *estrangulamiento* $V_P$ (unos −2 a −6 V) el canal se cierra y la corriente se anula. Es el grifo de nuevo, pero la maneta es una tensión.

#circuito(caption: [El JFET de canal N por dentro. Los electrones van de la fuente al drenador por el canal N. Las dos zonas P de la puerta, unidas entre sí, forman con el canal una unión en inversa; su zona de deplexión (gris) invade el canal. Al hacer la puerta más negativa, la deplexión crece y estrangula el canal: la tensión de la puerta gobierna la corriente sin que por la puerta pase corriente.])[
  #cetz.canvas({
    import cetz.draw: *
    rect((0, 0.8), (7, 1.8), fill: col.acento-claro, stroke: 0.6pt)
    rect((2.6, 1.8), (4.4, 2.5), fill: col.naranja-claro, stroke: 0.6pt)
    rect((2.6, 0.1), (4.4, 0.8), fill: col.naranja-claro, stroke: 0.6pt)
    line((2.5, 1.8), (2.8, 1.66), (3.3, 1.56), (3.9, 1.49), (4.35, 1.47), (4.55, 1.8), close: true, fill: col.gris.lighten(45%), stroke: none)
    line((2.5, 0.8), (2.8, 0.94), (3.3, 1.04), (3.9, 1.11), (4.35, 1.13), (4.55, 0.8), close: true, fill: col.gris.lighten(45%), stroke: none)
    content((3.5, 2.17), text(size: 8pt, weight: "bold", fill: col.senal2)[P])
    content((3.5, 0.45), text(size: 8pt, weight: "bold", fill: col.senal2)[P])
    content((1.2, 1.6), _i2b-t[canal N])
    line((0.35, 1.3), (6.65, 1.3), stroke: 1.4pt + col.senal1, mark: (end: ">", fill: col.senal1, scale: 0.6))
    content((5.7, 1.18), anchor: "north", _i2b-t(color: col.senal1)[electrones])
    // terminales
    line((0, 1.3), (-0.6, 1.3), stroke: 0.6pt)
    content((-0.7, 1.3), anchor: "east", align(right, _i2b-t[$S$ \ fuente]))
    line((7, 1.3), (7.6, 1.3), stroke: 0.6pt)
    content((7.7, 1.3), anchor: "west", _i2b-t[$D$ drenador])
    line((3.5, 2.5), (3.5, 2.95), stroke: 0.6pt)
    line((3.5, 0.1), (3.5, -0.35), stroke: 0.6pt)
    content((3.5, 3.0), anchor: "south", _i2b-t[$G$ puerta ($V_"GS" < 0$)])
    content((3.5, -0.4), anchor: "north", _i2b-t[$G$ (unida a la de arriba)])
    line((4.1, 1.52), (5.4, 2.55), stroke: 0.4pt + col.gris)
    content((5.45, 2.55), anchor: "west", align(left, _i2b-t[zona de deplexión: crece al hacer \ $V_"GS"$ más negativa]))
  })
] <i2b-fig-jfet>

#ptitulo[El MOSFET: una puerta aislada] El MOSFET (_metal-óxido-semiconductor_) va un paso más allá. Su puerta es una placa metálica separada del canal por una capa finísima de óxido aislante: no hay unión ninguna, solo un condensador. El campo de la puerta atrae o repele portadores en el semiconductor de debajo y crea o modifica el canal. Su impedancia de entrada es aún mayor que la del JFET (del orden de $10^12$ Ω frente a unos $10^9$ Ω). Hay dos variantes. En el de *enriquecimiento* no hay canal con $V_"GS" = 0$: se forma cuando la puerta supera una tensión umbral (unos 2–4 V en los de potencia), como el umbral de 0,6 V del bipolar pero más alto; es el que se usa como interruptor y en los amplificadores de potencia. En el de *empobrecimiento* el canal existe ya a 0 V y la puerta lo ensancha o lo estrecha, como en el JFET. El óxido es tan fino que la electricidad estática de una mano puede perforarlo: los MOSFET se manipulan con cuidado y llevan diodos de protección en la puerta.

#circuito(caption: [Símbolos de los transistores de efecto de campo. En el JFET la puerta toca el canal y lleva la flecha: hacia dentro en el canal N, hacia fuera en el canal P. En el MOSFET la puerta se dibuja *separada* del canal (el óxido aislante), y la flecha va en el sustrato. El canal discontinuo indica enriquecimiento (sin canal a 0 V); el continuo, empobrecimiento. El de doble puerta tiene dos puertas sobre el mismo canal: $G_1$, junto a la fuente, y $G_2$, junto al drenador.], sim: "nmosfet.txt")[
  #cetz.canvas({
    import cetz.draw: *
    let et(p, t, a) = content(p, anchor: a, _i2b-t(size: 7pt, t))
    for (k, (tipo, tit)) in (
      ("jn", [JFET \ canal N]),
      ("jp", [JFET \ canal P]),
      ("enr", [MOSFET canal N \ enriquecimiento]),
      ("emp", [MOSFET canal N \ empobrecimiento]),
      ("doble", [MOSFET \ de doble puerta]),
    ).enumerate() {
      let x = k * 3.0
      if tipo == "jn" { _i2b-jfet("f" + str(k), (x, 0), canal: "n") }
      else if tipo == "jp" { _i2b-jfet("f" + str(k), (x, 0), canal: "p") }
      else { _i2b-mosfet("f" + str(k), (x, 0), tipo: tipo) }
      let n = "f" + str(k)
      et(n + ".d", [$D$], "south")
      et(n + ".s", [$S$], "north")
      if tipo == "doble" {
        et(n + ".g1", [$G_1$], "east")
        et(n + ".g2", [$G_2$], "east")
      } else {
        et(n + ".g", [$G$], "east")
      }
      content((x + 0.1, -1.35), anchor: "north", align(center, text(size: 7.5pt, weight: "bold", tit)))
    }
  })
] <i2b-fig-simbolos-fet>

#ptitulo[Un amplificador con JFET] La @i2b-fig-fuente-comun es el equivalente del emisor común: el amplificador en *fuente común*. Las piezas son casi las mismas, con los nombres cambiados: puerta ↔ base, drenador ↔ colector, fuente ↔ emisor. La versión con MOSFET es igual, salvo por la polarización de la puerta (#falstad("mosfetamp.txt")).

#circuito(caption: [Amplificador en fuente común con JFET de canal N y autopolarización. La puerta está a 0 V a través de $R_G$; la corriente de drenador, al pasar por $R_S$, sube la fuente a 1,5 V, y la puerta queda 1,5 V por debajo de la fuente: la polarización negativa que necesita el JFET sale sola, sin fuente negativa. $C_S$ pone la fuente a masa para la señal.], sim: "jfetamp.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    wire((0.6, 5.6), (7.4, 5.6))
    node("v0", (0.6, 5.6), fill: false)
    content((7.5, 5.6), anchor: "west", _i2b-t[+12 V])
    wire((0.6, 0), (7.4, 0))
    node("m0", (0.6, 0), fill: false)
    content((7.5, 0), anchor: "west", _i2b-t[masa])
    _i2b-jfet("j", (3.9, 2.8))
    resistor("rd", (4.4, 5.6), (4.4, 3.9), label: (content: _i2b-e($R_D space 3,3 "k"$), anchor: "south"))
    wire((4.4, 3.9), "j.d")
    node("n1", (4.4, 5.6))
    node("n2", (4.4, 3.9))
    wire((4.4, 3.9), (5.6, 3.9))
    capacitor("cout", (5.6, 3.9), (7.0, 3.9), label: _i2b-e($C_"sal"$), n: "-o")
    wire("j.g", (2.2, 2.45))
    node("n3", (2.2, 2.45))
    resistor("rg", (2.2, 2.45), (2.2, 0), label: (content: _i2b-e($R_G space 1 "M"$), anchor: "south"))
    node("n4", (2.2, 0))
    capacitor("cin", (0.6, 2.45), (2.2, 2.45), label: _i2b-e($C_"ent"$), n: "o-")
    wire("j.s", (4.4, 1.6))
    node("n5", (4.4, 1.6))
    resistor("rs", (4.4, 1.6), (4.4, 0), label: (content: _i2b-e($R_S space 750$), anchor: "south"))
    node("n6", (4.4, 0))
    wire((4.4, 1.6), (5.6, 1.6))
    capacitor("cs", (5.6, 1.6), (5.6, 0), label: _i2b-e($C_S$))
    node("n7", (5.6, 0))
    content((4.6, 3.15), anchor: "west", _i2b-t[$D$])
    content((4.6, 2.3), anchor: "west", _i2b-t[$S$])
    content((3.05, 2.6), anchor: "south-east", _i2b-t[$G$])
    content((2.35, 2.55), anchor: "south-west", _i2b-t(color: col.ambar, size: 7pt)[0 V])
    content((4.55, 1.7), anchor: "south-west", _i2b-t(color: col.ambar, size: 7pt)[1,5 V])
    content((4.55, 3.8), anchor: "north-west", _i2b-t(color: col.ambar, size: 7pt)[5,4 V])
    _i2b-flecha((4.85, 5.4), (4.85, 4.4), etq: [2 mA], anchor: "west")
  })
] <i2b-fig-fuente-comun>

#porque[
  - *Polarización automática*: por $R_G$ no pasa corriente (la puerta no toma nada), así que la puerta está a 0 V. La corriente de drenador, 2 mA, cruza $R_S$ y sube la fuente a $2 "mA" dot 750 thin Ω = 1,5$ V. La puerta queda 1,5 V por debajo de la fuente: $V_"GS" = -1,5$ V, justo la tensión negativa que necesita el JFET, sin fuente negativa.
  - $R_S$ estabiliza como $R_E$: si la corriente subiera, subiría la fuente, $V_"GS"$ se haría más negativa y la corriente volvería a bajar.
  - $R_G$ puede ser de 1 MΩ o más, porque la puerta no pide corriente: la impedancia de entrada de la etapa es la propia $R_G$, cientos de veces la de un bipolar.
  - $R_D$ convierte las variaciones de corriente de drenador en tensión, como $R_C$. $C_"ent"$ y $C_"sal"$ acoplan; $C_S$ desacopla la fuente para la señal. La salida, como en el emisor común, sale invertida.
]

#ejemplo(titulo: [cuánto amplifica el JFET])[
  Para un JFET con $I_"DSS" = 8$ mA y $V_P = -3$ V, la corriente de 2 mA corresponde a $V_"GS" = -1,5$ V, y la transconductancia en ese punto es $g_m approx 2,7$ mS (2,7 mA de corriente de drenador por cada voltio de puerta). En el drenador caen $2 "mA" dot 3,3 "kΩ" = 6,6$ V, y el drenador reposa a $12 - 6,6 = 5,4$ V. La ganancia con $C_S$ es $A_v approx -g_m R_D = -0,0027 dot 3300 approx -9$.

  Un bipolar con la misma corriente tendría $g_m = 40 dot 0,002 = 80$ mS: treinta veces más. El FET amplifica menos por etapa, pero su entrada es de 1 MΩ en lugar de unos kilohmios. Se elige por lo que necesita la fuente de señal, no por la ganancia.
]

#ptitulo[El MOSFET de doble puerta: dos manetas en el mismo grifo] Este MOSFET tiene dos puertas una detrás de otra sobre el mismo canal. $G_1$, junto a la fuente, recibe la señal. $G_2$, junto al drenador, se suele dejar a una tensión continua fija y desacoplada a masa, y entonces hace de pantalla entre la entrada y la salida, igual que la base a masa en la base común: la capacidad de realimentación entre drenador y $G_1$ es diminuta (centésimas de picofaradio), y el preamplificador es estable en VHF y UHF sin neutralizar. Si se varía la tensión continua de $G_2$, cambia la ganancia: es una entrada cómoda para el control automático de ganancia. Y si a $G_1$ llega la señal de RF y a $G_2$ la del oscilador local, la corriente de drenador depende de las dos a la vez, casi como su producto: el MOSFET de doble puerta es un *mezclador* excelente, con las dos entradas bien aisladas entre sí (#ver(<sec-mezclador>)).

#ptitulo[El MOSFET de potencia] En los transceptores modernos, los finales de 100 W de HF y VHF y los amplificadores de un kilovatio son casi siempre MOSFET de potencia (los más potentes, alimentados a 50 V, son LDMOS: MOSFET de difusión lateral). Se gobiernan por tensión, conmutan muy deprisa (el corazón de las clases D y E y de las fuentes conmutadas) y se reparten bien la corriente cuando se montan varios en paralelo. Su polarización en clase AB necesita, como la del bipolar, una compensación de temperatura. Las válvulas sobreviven en los amplificadores de mayor potencia, donde soportan sin daño sobrecargas que destruirían un transistor.

#ojo[
  - Los tres terminales del FET son *puerta, drenador y surtidor* (o fuente) (T2.34). Emisor, base y colector son del bipolar; cátodo, rejilla y ánodo, de la válvula.
  - La ventaja del FET sobre el bipolar es su *mayor impedancia de entrada* (C-T2.11): se gobierna por tensión y la puerta apenas toma corriente.
  - El MOSFET es un FET: *tiene una puerta de control* (C-T2.20), no un filamento, y es un componente activo.
  - En los símbolos (T2.66), el FET se reconoce por la puerta: en el MOSFET se dibuja separada del canal, porque controla por campo eléctrico y no por corriente.
]

== Cada circuito en su sitio <i2b-sec-mapa>

#motivacion[Has visto muchos circuitos sueltos. ¿Dónde está cada uno en una radio de verdad? La @i2b-fig-mapa coloca cada etapa en un receptor superheterodino y en un transmisor, con la configuración y la clase que suele tener. Ningún bloque es nuevo: todos son combinaciones de las piezas de este capítulo.]

#circuito(caption: [Dónde trabaja cada circuito. Arriba, un receptor superheterodino; abajo, un transmisor. En cada bloque, el circuito típico de este capítulo. El amplificador de RF, la FI y la primera etapa de audio son emisores comunes (o sus versiones con FET y base común); el oscilador lleva detrás un seguidor que lo separa de la carga; el final del transmisor es un contrafase en clase AB para SSB o un clase C para CW y FM, siempre seguido de un filtro paso bajo.])[
  #let caja(t, d) = box(width: 2.2cm, {
    set par(justify: false, leading: 0.45em)
    align(center, [#text(size: 7.5pt, weight: "bold", t) \ #text(size: 6.5pt, fill: col.gris, d)])
  })
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (2mm, 7mm), node-inset: 3.5pt,
    node((0, 0), text(size: 7.5pt)[antena], stroke: none, name: <a1>),
    node((1, 0), caja[Preamplificador de RF][base común o MOSFET de doble puerta; clase A; sintonizado], shape: rect, name: <rf>),
    node((2, 0), caja[Mezclador][MOSFET de doble puerta, diodos], shape: rect, name: <mx>),
    node((3, 0), caja[Amplificador de FI][emisor común sintonizado; transformadores de FI], shape: rect, name: <fi>),
    node((4, 0), caja[Detector][diodo o detector de producto], shape: rect, name: <det>),
    node((5, 0), caja[Amplificador de BF][emisor común y contrafase AB], shape: rect, name: <bf>),
    node((6, 0), text(size: 7.5pt)[altavoz], stroke: none, name: <alt>),
    node((2, 1), caja[Oscilador local][oscilador y seguidor de emisor], shape: rect, name: <ol>),
    edge(<a1>, <rf>, "-|>", stroke: 0.8pt + col.senal1),
    edge(<rf>, <mx>, "-|>", stroke: 0.8pt + col.senal1),
    edge(<mx>, <fi>, "-|>", stroke: 0.8pt + col.senal1),
    edge(<fi>, <det>, "-|>", stroke: 0.8pt + col.senal1),
    edge(<det>, <bf>, "-|>", stroke: 0.8pt + col.senal1),
    edge(<bf>, <alt>, "-|>", stroke: 0.8pt + col.senal1),
    edge(<ol>, <mx>, "-|>", stroke: 0.8pt + col.senal1),
    node((0, 2.4), caja[Oscilador][cristal o VFO; sintetizador], shape: rect, name: <osc>),
    node((1, 2.4), caja[Separador][colector común], shape: rect, name: <sep>),
    node((2, 2.4), caja[Excitador][emisor común; clase A o AB], shape: rect, name: <exc>),
    node((3, 2.4), caja[Amplificador final][contrafase AB (SSB, AM) o clase C (CW, FM)], shape: rect, name: <pa>),
    node((4, 2.4), caja[Filtro de salida][paso bajo; red en pi], shape: rect, name: <lpf>),
    node((5, 2.4), text(size: 7.5pt)[antena], stroke: none, name: <a2>),
    edge(<osc>, <sep>, "-|>", stroke: 0.8pt + col.senal1),
    edge(<sep>, <exc>, "-|>", stroke: 0.8pt + col.senal1),
    edge(<exc>, <pa>, "-|>", stroke: 0.8pt + col.senal1),
    edge(<pa>, <lpf>, "-|>", stroke: 0.8pt + col.senal1),
    edge(<lpf>, <a2>, "-|>", stroke: 0.8pt + col.senal1),
  )
] <i2b-fig-mapa>

- *El preamplificador de RF* sube la señal de la antena antes de que el mezclador le añada su ruido. Se elige la base común o el MOSFET de doble puerta en VHF y UHF por su estabilidad, siempre con un tanque como carga para quedarse con la banda (#ver(<sec-amp-sintonizado>)).
- *El oscilador local* es un amplificador realimentado con un tanque o un cristal (#ver(<sec-oscilador>), #ver(<sec-cristal>)); lo sigue un separador en colector común para que la carga no le mueva la frecuencia.
- *El mezclador* es una etapa no lineal que multiplica dos señales; el MOSFET de doble puerta es uno de los clásicos (#ver(<sec-mezclador>)).
- *La FI* es una cadena de emisores comunes con transformadores de FI sintonizados entre ellos: la mayor parte de la ganancia y de la selectividad del receptor.
- *El detector* saca la información (#ver(<sec-detector>)), y *el amplificador de BF* la sube hasta el altavoz: un emisor común para la tensión y un contrafase en clase AB para la corriente.
- *En el transmisor* la cadena se recorre al revés: oscilador, separador, excitador y final, cada etapa algo más potente que la anterior, y un filtro paso bajo antes de la antena (#ver(<sec-redes-adaptacion>)).

La radio de este capítulo (#ver(<sec-radio-entera>)) usa solo dos de estas piezas: un emisor común de RF y un emisor común de audio, con un detector de diodo entre ellos. Cuando un esquema del examen te parezca nuevo, busca primero los transistores y pregúntate, para cada uno, por dónde entra la señal, por dónde sale y qué terminal va a masa. Con eso sabes ya qué configuración es y para qué está ahí.
