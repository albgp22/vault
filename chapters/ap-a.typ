#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Utilidades locales del apéndice A (prefijo _apa-)
// ---------------------------------------------------------------------
// Convenio de color del libro: la continua en ámbar, la señal en azul.
#let _apa-cc = col.ambar
#let _apa-se = col.senal1

// Texto pequeño para rótulos de figuras.
#let _apa-t(c, color: col.tinta, size: 7.5pt) = text(size: size, fill: color, c)

// Término de búsqueda (las líneas monoespaciadas de las tablas de compra).
#let _apa-busca(t) = block(above: 0.35em, below: 0em, text(size: 0.95em, fill: col.gris, raw(t)))

// Flecha coloreada con rótulo opcional.
#let _apa-flecha(a, b, color: col.ambar, etq: none, anchor: "south", dist: 2pt) = {
  import cetz.draw: line, content
  line(a, b, stroke: 0.9pt + color, mark: (end: ">", fill: color, scale: 0.55))
  if etq != none {
    content((a, 50%, b), anchor: anchor, padding: dist, text(size: 7pt, fill: color, etq))
  }
}

// Auricular piezoeléctrico «de cristal»: círculo con un arco grueso. Dos terminales.
#let _apa-auricular(name, node, ..params) = {
  import cetz.draw: *
  let style = (radius: .36)
  let draw(ctx, position, style) = {
    let r = style.radius
    zap.interface((-r, -r), (r, r), io: position.len() < 2)
    circle((0, 0), radius: r, fill: white, ..style)
    arc((0, r * 0.05), start: 200deg, stop: 340deg, radius: r * 0.78, anchor: "origin", stroke: 1.4pt)
  }
  zap.component("auricular", name, node, draw: draw, style: style, ..params)
}

// Altavoz: imán en línea con el cable y cono hacia un lado. Dos terminales.
#let _apa-altavoz(name, node, ..params) = {
  import cetz.draw: *
  let style = (width: .5, height: .26)
  let draw(ctx, position, style) = {
    zap.interface((-.25, -.13), (.25, .13), io: position.len() < 2)
    rect((-.25, -.13), (.25, .13), fill: white, stroke: 0.8pt)
    line((-.25, .13), (-.55, .55), (.55, .55), (.25, .13), close: true, fill: white, stroke: 0.8pt)
  }
  zap.component("altavoz-apa", name, node, draw: draw, style: style, ..params)
}

// Listados de código: fondo claro y letra algo menor.
#show raw.where(block: true): it => block(
  width: 100%,
  fill: col.gris-claro,
  stroke: (left: 1.5pt + col.gris.lighten(40%)),
  inset: (x: 9pt, y: 7pt),
  radius: (right: 2pt),
  text(size: 8.3pt, it),
)

#apendice("A", "Tu primera radio: taller práctico")

Este apéndice es la versión con soldador del tema T2 y del capítulo «La radio por dentro»: los mismos componentes que el examen pregunta en abstracto —~resistencias, condensadores, bobinas, diodos, transistores, circuitos integrados~— comprados, montados y sonando. Son tres montajes encadenados, de dificultad creciente, y los tres funcionan de verdad:

+ la *radio de galena*: cuatro componentes, cero pilas, y una emisora de onda media sonando en un auricular con la energía que llega por la antena;
+ el *amplificador*: primero un transistor —~el emisor común del capítulo introductorio (#ver(<sec-amplificador-ec>)), ahora en carne y hueso sobre una protoboard~— y después un circuito integrado (LM386) para mover un altavoz;
+ la *radio con Arduino*: un receptor DSP moderno (Si4732) que es, por dentro, el superheterodino del temario convertido en matemáticas, con el Arduino haciendo solo de panel frontal.

#ojo[Regla única e innegociable del taller: *aquí no se toca la red de 230 V*. Todo funciona con la energía de la propia emisora (montaje 1), con una pila de 9 V (montaje 2) o con los 5 V del puerto USB del ordenador (montaje 3). La fuente de alimentación con transformador del capítulo introductorio (#ver(<sec-fuente>)) está ahí para _entenderla_, no para construirla como primer proyecto. Y la antena, siempre lejos de líneas eléctricas y desconectada en tormenta: es el mismo sentido común que el tema T10 convierte en preguntas de examen.]

== La lista de la compra <apa-sec-compra>

Todo lo que sigue se encuentra en cualquier tienda de electrónica o en las plataformas habituales por unos pocos euros; el conjunto completo, Arduino incluido, cuesta menos que un manual de radio. La tercera columna es el motivo de que esta lista exista: _cada componente es un epígrafe del temario_.

#block(breakable: true, {
  set text(size: 9pt)
  set par(justify: false)
  table(
    columns: (1.25fr, 1fr, 1fr),
    align: left,
    table.header([Componente], [Papel en el taller], [Dónde lo estudia el temario]),
    [Diodo de germanio 1N34A u OA91 (o Schottky BAT85 / 1N5711) #_apa-busca("1N34A germanium diode")],
    [el detector de la galena: codo de 0,2–0,3 V],
    [unión PN y diodos, T2; detector, T3],

    [Auricular piezoeléctrico «de cristal», de alta impedancia #_apa-busca("crystal earphone")],
    [el transductor que suena sin amplificar],
    [piezoelectricidad, capítulo introductorio (#ver(<sec-cristal>))],

    [10 m de hilo de cobre esmaltado ø 0,4 mm + tubo de PVC ø 40 mm #_apa-busca("enameled copper wire 0.4 mm")],
    [la bobina de sintonía (la devanas tú)],
    [bobinas, T2],

    [Condensador variable ∼20–365 pF (de kit de galena o radio antigua) #_apa-busca("polyvaricon 365 pF")],
    [la sintonía: $C = epsilon S slash d$ con $S$ a voluntad],
    [condensadores, T2],

    [15–20 m de hilo para antena y unos metros para tierra (vale cualquier cable); de toma de tierra, una estaca metálica o el radiador],
    [el colector de energía],
    [antenas, T6; propagación, T7],

    [Resistencias de ¼ W: 10 Ω, 10 k, 47 k, 100 k, 4,7 k, 1,5 k #_apa-busca("resistor kit 1/4W")],
    [polarización y cargas],
    [resistencias, T2],

    [Condensadores: 2,2 nF, 47 nF, 100 nF, 1 μF, 10 μF, 47 μF, 100 μF, 220 μF #_apa-busca("capacitor assortment kit")],
    [acoplos, desacoplos y filtros],
    [T2 y T3],

    [Transistor BC547B #_apa-busca("BC547B TO-92")],
    [el amplificador de audio],
    [transistores, T2],

    [Circuito integrado LM386N + altavoz de 8 Ω #_apa-busca("LM386N DIP-8 · speaker 8 ohm 0.5W")],
    [el amplificador «de verdad»],
    [circuitos integrados, T2],

    [Protoboard, cables, pila de 9 V con clip #_apa-busca("breadboard 830 jumper wires")],
    [el banco de trabajo],
    [—],

    [Arduino Nano (o Uno) + módulo receptor SI4732 #_apa-busca("Arduino Nano V3 · SI4732 receiver board")],
    [la radio DSP],
    [receptores, T4; osciladores, T3],
  )
})

#truco[Las líneas monoespaciadas de la tabla son términos de búsqueda: pegados tal cual en el buscador o en la plataforma de turno, localizan cada pieza. Dos avisos de compra: el auricular tiene que ser piezoeléctrico —~uno dinámico de móvil, de 32 Ω, _no_ sirve para la galena~—, y el condensador variable aparece muchas veces por su nombre de kit japonés, _polyvaricon_. Y la fuente clásica de variable y diodo de germanio sigue siendo una radio de transistores vieja de un rastro, donada a la ciencia.]

#ptitulo[La caja de herramientas] Nada de esto es exótico, y es probable que ya tengas la mitad —~revisa antes de comprar:

#block(breakable: true, {
  set text(size: 9pt)
  set par(justify: false)
  table(
    columns: (1.25fr, 1fr, 1fr),
    align: left,
    table.header([Herramienta], [Para qué], [Dónde lo estudia el temario]),
    [Polímetro digital #_apa-busca("digital multimeter")],
    [medir tensiones y continuidad; verificar el punto de trabajo del montaje 2],
    [medidas e instrumentos, T8],

    [Juego de pinzas de cocodrilo #_apa-busca("alligator clip leads")],
    [conectar variable, auricular y antena sin soldar],
    [—],

    [Soldador de 25–40 W con soporte y estaño de 0,8 mm con fundente #_apa-busca("soldering iron kit")],
    [fijar hilos al variable y al auricular (con los cocodrilos puedes aplazarlo); siempre en su soporte, siempre cogido por el mango, y el estaño lejos de los dedos: 350 °C no avisan],
    [—],

    [Pelacables, alicate de corte y lija fina #_apa-busca("wire stripper cutter")],
    [pelar cable, cortar patillas y quitar el esmalte de la bobina],
    [—],

    [Cable USB del Nano (mini-B en casi todos los clones) #_apa-busca("USB mini-B cable")],
    [programar y alimentar el montaje 3],
    [—],

    [Cinta aislante y bridas],
    [sujetar bobina, antena y cableado],
    [—],

    [_Opcional:_ fuente de alimentación de laboratorio, 0–30 V / 3–5 A, con limitación de corriente #_apa-busca("bench power supply 30V 5A")],
    [sustituye a la pila y perdona errores],
    [fuente estabilizada, T3],
  )
})

#ptitulo[Sobre la fuente de laboratorio] Para este taller no es necesaria —~la galena no consume nada y la pila y el USB alimentan el resto~—, pero como compra de banco es la mejor herramienta general que existe, y no contradice la regla del taller: es un aparato comercial cerrado y tú trabajas solo con su salida de baja tensión. Sus dos mandos son puro temario. El de *tensión* entrega una salida estabilizada —~dentro de la caja están, hechos aparato, el transformador, el puente, el filtro y el regulador de la fuente del tema T3 (#ver(<sec-fuente>)). El de *limitación de corriente* la convierte en fuente de corriente constante en cuanto la carga pide más de lo ajustado: ponlo a 100 mA antes de conectar nada y un despiste —~un corto en la protoboard, un electrolítico al revés~— se queda en susto en vez de en humo. Para los montajes 2 y 3, ajusta 9 V con límite de 100 mA y olvídate de pilas gastadas; de propina, su amperímetro te dice el consumo real de cada montaje (compáralo con los 5 mA del ejercicio 5).

== Conocer lo comprado: patillas, marcas y protoboard <apa-sec-conocer>

#ptitulo[Cada componente, por fuera] El temario describe los componentes por dentro; el fabricante te los entrega por fuera, y hay que saber leerlos (@apa-fig-componentes). El transistor BC547 viene en cápsula plástica con una cara plana: mirándola de frente, con las patillas hacia abajo, el orden es *colector–base–emisor*. No es un convenio universal —~el americano 2N3904, misma función, usa el orden contrario (E–B–C)~—, así que ante cualquier transistor nuevo, hoja de datos. En el diodo, la *franja* pintada marca el cátodo: la barrita del símbolo, el lado por donde la corriente «no entra». En los electrolíticos, la franja lateral llena de signos − señala la pata negativa (que además es la corta): son los condensadores polarizados del tema T2 (#ver(<sec-condensador>)), y conectarlos al revés los destruye. Y en el LM386, el punto o la muesca marcan la pata 1, con la numeración corriendo en sentido antihorario visto desde arriba —~el convenio universal de los integrados.

#ptitulo[Las marcas de valor] Las resistencias llevan el código de colores del tema T2 (#ver(<t2-fig-colores>)); la lista de la compra entera está en el ejercicio 6, para leerla banda a banda. Los condensadores cerámicos usan el mismo sistema en cifras: dos significativas y un multiplicador, _en picofaradios_. Así, «104» es $10 times 10^4$ pF = 100 nF; «473» son 47 nF; «222», 2,2 nF. Los electrolíticos, con sitio de sobra en el cuerpo, escriben el valor y la tensión máxima tal cual.

#circuito(caption: [Los componentes, por fuera: el orden colector–base–emisor del BC547 con su cara plana de frente; la franja del diodo, que es la barrita del símbolo (cátodo); la franja de signos − del electrolítico y su pata larga positiva; y la numeración antihoraria del LM386 a partir de la muesca.])[
  #cetz.canvas({
    import cetz.draw: *
    let gris = col.gris
    let pata = 1.6pt + col.gris.darken(30%)
    // --- BC547 (TO-92, cara plana de frente) ---
    content((1.1, 3.55), _apa-t(color: gris, align(center)[BC547: cara plana\ hacia ti, patillas abajo]))
    merge-path(close: true, stroke: 0.9pt, fill: col.gris-claro.lighten(50%), {
      line((0.3, 1.5), (0.3, 2.45))
      arc((), start: 180deg, stop: 90deg, radius: 0.3)
      line((), (1.6, 2.75))
      arc((), start: 90deg, stop: 0deg, radius: 0.3)
      line((), (1.9, 1.5))
    })
    for (i, l) in ("C", "B", "E").enumerate() {
      let x = 0.7 + i * 0.4
      line((x, 1.5), (x, 0.55), stroke: pata)
      content((x, 0.3), text(size: 8.5pt, l))
    }
    // --- Diodo: cuerpo con franja y símbolo debajo ---
    content((4.6, 3.55), _apa-t(color: gris, align(center)[la franja marca el cátodo:\ la barrita del símbolo]))
    line((3.3, 2.3), (3.75, 2.3), stroke: pata)
    line((5.45, 2.3), (5.9, 2.3), stroke: pata)
    rect((3.75, 2.0), (5.45, 2.6), fill: col.gris-claro.lighten(50%), stroke: 0.9pt)
    rect((4.95, 2.0), (5.13, 2.6), fill: col.tinta, stroke: none)
    line((5.04, 1.95), (5.04, 1.15), stroke: (paint: gris, dash: "dashed", thickness: 0.6pt))
    line((3.6, 0.8), (4.55, 0.8), stroke: 0.6pt)
    line((4.55, 1.1), (4.55, 0.5), (5.04, 0.8), close: true, stroke: 0.7pt, fill: white)
    line((5.04, 1.1), (5.04, 0.5), stroke: 0.9pt)
    line((5.04, 0.8), (5.9, 0.8), stroke: 0.6pt)
    // --- Electrolítico ---
    content((7.7, 3.55), _apa-t(color: gris, align(center)[electrolítico: franja −;\ la pata larga es +]))
    rect((7.1, 1.25), (8.3, 2.95), radius: 0.12, fill: col.gris-claro.lighten(50%), stroke: 0.9pt)
    rect((7.95, 1.4), (8.2, 2.8), fill: col.gris.lighten(55%), stroke: none)
    for y in (2.45, 2.1, 1.75) { line((8.0, y), (8.15, y), stroke: 0.7pt + col.tinta) }
    line((7.4, 1.25), (7.4, 0.2), stroke: pata)
    line((7.95, 1.25), (7.95, 0.65), stroke: pata)
    content((7.4, -0.05), text(size: 8.5pt)[+])
    // --- LM386 visto desde arriba ---
    content((12.3, 3.55), _apa-t(color: gris, align(center)[LM386 desde arriba:\ la muesca, entre 1 y 8]))
    rect((11.6, 0.15), (13.0, 2.95), fill: col.gris-claro.lighten(50%), stroke: 0.9pt)
    arc((12.48, 2.95), start: 0deg, stop: -180deg, radius: 0.18, stroke: 0.8pt, fill: white)
    let izq = ("ganancia", "entrada −", "entrada +", "masa")
    let der = ("ganancia", "desacoplo", "+pila", "salida")
    for i in range(4) {
      let y = 2.5 - i * 0.68
      line((11.6, y), (11.3, y), stroke: pata)
      line((13.0, y), (13.3, y), stroke: pata)
      content((11.78, y), text(size: 7pt, str(i + 1)))
      content((12.82, y), text(size: 7pt, str(8 - i)))
      content((11.2, y), anchor: "east", _apa-t(izq.at(i)))
      content((13.4, y), anchor: "west", _apa-t(der.at(i)))
    }
  })
] <apa-fig-componentes>

#ptitulo[La letra pequeña] El tema T2 insiste en que un componente no es solo su valor nominal: es también su tolerancia y sus máximos. Los de este taller, en versión de bolsillo:

#align(center, {
  set text(size: 9pt)
  table(
    columns: 3,
    align: left,
    table.header([Componente], [Límite que importa], [Dato útil]),
    [BC547B], [45 V, 100 mA de colector], [$beta$ entre 200 y 450],
    [1N34A (germanio)], [decenas de mA como mucho], [codo ∼0,25 V],
    [LM386N], [alimentación de 4 a 12 V], [∼4 mA en reposo],
    [Módulo SI4732], [se alimenta a 3,3 V, no tolera 5 V], [habla I2C],
    [Resistencias ¼ W], [$I_"máx" = sqrt(P slash R)$], [tolerancia oro: ±5 %],
  )
})

Fíjate en la horquilla de $beta$ del transistor: entre 200 y 450 según el ejemplar que te toque. Por eso el montaje 2 polariza con divisor y resistencia de emisor —~para que el punto de trabajo no dependa de esa lotería, que es exactamente lo que el temario llama _estabilizar_ la polarización (#ver(<sec-polarizacion>)).

#ptitulo[La protoboard] La placa de inserción tiene truco interno (@apa-fig-protoboard): bajo cada columna de cinco taladros hay una tira metálica que los une —~cinco taladros, _un solo nudo_ del circuito~—, el canal central separa las tiras de arriba de las de abajo, y los raíles laterales corren enteros a lo largo de la placa (alimentación y masa). Con eso, montar un esquema es traducir nudos a tiras. El canal tiene además su porqué: está a la distancia exacta para que un integrado lo cabalgue, dejando cada patilla en una tira independiente.

#circuito(caption: [La protoboard por dentro. Cada columna de cinco taladros comparte una tira metálica (resaltada una, en cobre): es un único nudo eléctrico. Los raíles horizontales recorren la placa entera, y el canal central separa las dos mitades —~a la medida justa para que un circuito integrado lo cabalgue con las patillas en tiras independientes.])[
  #cetz.canvas({
    import cetz.draw: *
    let p = 0.38
    let nc = 20
    let s = 0.33
    let xs = range(nc).map(i => 0.3 + i * p)
    let filas-abajo = range(5).map(i => i * s)
    let canal = (1.5, 1.78)
    let filas-arriba = range(5).map(i => 1.98 + i * s)
    let (ymenos, ymas) = (3.85, 4.18)
    let cobre = col.naranja
    let gris = col.gris
    let flecha = (stroke: 0.6pt + gris, mark: (end: ">", fill: gris, scale: 0.5))
    // placa
    rect((-0.15, -0.3), (xs.last() + 0.35, 4.45), fill: rgb("#faf8f3"), stroke: 1pt)
    // raíles
    line((xs.first() - 0.1, ymas), (xs.last() + 0.1, ymas), stroke: 0.8pt + col.senal2.lighten(20%))
    line((xs.first() - 0.1, ymenos), (xs.last() + 0.1, ymenos), stroke: 0.8pt + col.senal1.lighten(20%))
    content((0.02, ymas + 0.13), text(size: 7.5pt, fill: col.senal2)[+])
    content((0.02, ymenos - 0.15), text(size: 7.5pt, fill: col.senal1)[−])
    for x in xs {
      circle((x, ymas), radius: 0.042, fill: col.tinta, stroke: none)
      circle((x, ymenos), radius: 0.042, fill: col.tinta, stroke: none)
    }
    // canal central
    rect((-0.15, canal.at(0)), (xs.last() + 0.35, canal.at(1)), fill: col.gris-claro, stroke: (paint: gris.lighten(40%), thickness: 0.5pt))
    // tira resaltada (columna 3, mitad superior)
    rect((xs.at(2) - 0.12, filas-arriba.first() - 0.12), (xs.at(2) + 0.12, filas-arriba.last() + 0.12), radius: 0.08, fill: cobre.lighten(80%), stroke: 0.8pt + cobre)
    // taladros
    for x in xs {
      for y in filas-arriba + filas-abajo { circle((x, y), radius: 0.042, fill: col.tinta, stroke: none) }
    }
    // integrado de 8 patas cabalgando el canal (columnas 13–16)
    let (c0, c1) = (xs.at(12), xs.at(15))
    for x in xs.slice(12, 16) {
      line((x, filas-arriba.first()), (x, canal.at(1) + 0.05), stroke: 1.4pt + gris)
      line((x, filas-abajo.last()), (x, canal.at(0) - 0.05), stroke: 1.4pt + gris)
    }
    rect((c0 - 0.2, canal.at(0) - 0.07), (c1 + 0.2, canal.at(1) + 0.07), fill: gris.lighten(60%), stroke: 0.9pt)
    arc((c0 - 0.2, (canal.at(0) + canal.at(1)) / 2 + 0.1), start: 90deg, stop: -90deg, radius: 0.1, stroke: 0.7pt)
    // rótulos
    let xr = xs.last() + 0.7
    content((xr, (ymas + ymenos) / 2), anchor: "west", _apa-t(color: gris, align(left)[raíles: cada uno es\ una única tira a lo\ largo de la placa]))
    line((xr - 0.05, (ymas + ymenos) / 2), (xs.last() + 0.12, (ymas + ymenos) / 2), ..flecha)
    let yc = (canal.at(0) + canal.at(1)) / 2
    content((xr, yc), anchor: "west", _apa-t(color: gris, align(left)[el integrado cabalga el\ canal: cada patilla cae\ en una tira distinta]))
    line((xr - 0.05, yc), (c1 + 0.25, yc), ..flecha)
    content((-0.45, filas-arriba.at(2)), anchor: "east", _apa-t(color: gris, align(right)[cinco taladros,\ una tira metálica:\ un solo nudo]))
    line((-0.4, filas-arriba.at(2)), (xs.at(2) - 0.15, filas-arriba.at(2)), ..flecha)
    content((-0.45, yc), anchor: "east", _apa-t(color: gris)[canal central])
    line((-0.4, yc), (xs.at(1), yc), ..flecha)
  })
] <apa-fig-protoboard>

== Montaje 1: la radio de galena <apa-sec-galena>

#ptitulo[Un poco de historia que es física] La _galena_ es sulfuro de plomo, un mineral que resulta ser un semiconductor natural. Los primeros oyentes de la radio apoyaban sobre el cristal un alambre finísimo —~el «bigote de gato»~— y tanteaban hasta dar con un punto sensible: sin saberlo, estaban formando una *unión metal–semiconductor* con una barrera interna, exactamente la física de la unión PN del tema T2 (#ver(<sec-diodo>)), con dos ventajas para RF: un codo de conducción bajo (∼0,2 V, frente a los 0,6–0,7 V del silicio) y un área de contacto minúscula, es decir, una capacidad parásita despreciable que no cortocircuita la señal de radio. El diodo Schottky moderno es, literalmente, el bigote de gato domesticado; el diodo de germanio, su primo de unión con el codo igual de bajo. Cualquiera de los dos hará de galena en tu montaje, sin tanteos.

#ptitulo[Por qué el codo importa tanto] El detector de la galena recibe la señal _tal cual llega de la antena_: décimas de voltio con una emisora local fuerte, milivoltios en general. Un diodo de silicio, con su peaje de 0,6–0,7 V, sencillamente no llega a abrirse —~la señal muere ante la barrera. El germanio, con 0,2 V, rectifica una señal unas tres veces menor; con emisoras potentes y buena antena, suficiente. (En la radio del capítulo introductorio (#ver(<sec-radio-entera>)) el diodo detector trabajaba _después_ de un amplificador de RF, y por eso allí el peaje no era crítico. Aquí no hay amplificador: el codo es la diferencia entre oír y no oír.)

#ptitulo[La bobina, espira a espira] Necesitamos unos 220 μH para cubrir la onda media con el condensador variable de 365 pF. Para un solenoide de una capa vale la fórmula empírica de Wheeler,
$ L ("μH") approx (d^2 N^2) / (45 d + 100 ell), wide d, ell "en cm," $
con $d$ el diámetro y $ell$ la longitud del devanado. Es la versión con números de lo que el tema T2 dice con letra (#ver(<sec-bobina>)): $L$ crece con el cuadrado de las espiras y con el diámetro, y baja al estirar el devanado. Receta concreta (@apa-fig-bobina): sobre el tubo de PVC de 40 mm, *90 espiras juntas* de hilo esmaltado de 0,4 mm ocupan unos 4 cm, y
$ L approx (4^2 dot 90^2) / (45 dot 4 + 100 dot 4,05) = (129 thin 600) / 585 approx 220 "μH". $
Sujeta los extremos con dos taladritos o cinta, deja 10 cm de rabo por cada lado y —~el error clásico del primer día~— *lija el esmalte* de las puntas antes de conectar: el esmalte es un aislante excelente, y una bobina perfecta con las puntas sin lijar es un circuito abierto perfecto.

#circuito(caption: [La bobina de sintonía: 90 espiras de hilo esmaltado de 0,4 mm, bien juntas, sobre tubo de PVC de 40 mm —~unos 220 μH según la fórmula de Wheeler. La toma intermedia es opcional; la lija, no.])[
  #cetz.canvas({
    import cetz.draw: *
    let cobre = col.naranja
    // tubo
    rect((0, 0), (9.2, 1.9), fill: rgb("#faf8f3"), stroke: 1pt)
    arc((0, 0.95), start: -90deg, stop: 90deg, radius: (0.22, 0.95), anchor: "origin", stroke: 0.7pt)
    content((1.35, 0.95), _apa-t(color: col.gris, align(center)[tubo de PVC\ ø 40 mm]))
    // espiras (dibujo esquemático: no están todas)
    let x0 = 2.6
    let x1 = 5.8
    let n = 36
    for i in range(n) {
      let x = x0 + (x1 - x0) * i / (n - 1)
      line((x, 0), (x, 1.9), stroke: 1.1pt + cobre)
    }
    // extremos y toma
    bezier((x0, 1.9), (2.0, 2.55), (2.4, 2.4), stroke: 1.2pt + cobre)
    bezier((x1, 1.9), (6.4, 2.55), (6.0, 2.4), stroke: 1.2pt + cobre)
    let xt = x0 + (x1 - x0) / 3
    bezier((xt, 1.9), (xt + 0.25, 2.85), (xt - 0.05, 2.5), stroke: 1.2pt + cobre)
    content((1.9, 2.6), anchor: "south-east", _apa-t(color: col.gris, align(right)[extremo A\ (lijar esmalte)]))
    content((6.5, 2.6), anchor: "south-west", _apa-t(color: col.gris, align(left)[extremo B\ (lijar esmalte)]))
    content((xt + 0.4, 2.9), anchor: "south", _apa-t(color: col.gris)[toma opcional (espira ∼30)])
    // cota
    line((x0, -0.4), (x1, -0.4), stroke: 0.6pt + col.gris, mark: (start: ">", end: ">", fill: col.gris, scale: 0.5))
    content(((x0 + x1) / 2, -0.7), _apa-t(color: col.gris)[90 espiras juntas ≈ 4 cm])
  })
] <apa-fig-bobina>

#ptitulo[La sintonía, con números] Bobina y condensador variable en paralelo forman el tanque LC del temario (#ver(<sec-resonancia>)), resonante en $f_0 = 1 slash (2 pi sqrt(L C))$. Girar el eje del variable es variar la superficie enfrentada de sus placas —~$C = epsilon S slash d$, tema T2~— y con ella la frecuencia elegida:
$ C = 385 "pF (máximo + parásitas)" quad => quad f_0 approx 547 "kHz"; wide C = 40 "pF" quad => quad f_0 approx 1,7 "MHz". $
Prácticamente toda la banda de onda media —~y los números reales bailan un poco, porque la antena, colgada del vivo del tanque, añade su propia capacidad y corre el margen hacia abajo. De todo lo que la antena entrega, el tanque solo desarrolla tensión apreciable a su frecuencia de resonancia: esa es toda la selectividad de esta radio, y funciona.

#ptitulo[El detector y el auricular] A partir del tanque, el circuito es el detector de envolvente del temario (@apa-fig-galena; la teoría, en #ver(<sec-detector>)): el diodo deja pasar solo los semiciclos positivos de la RF, y el condensador de 2,2 nF con la resistencia de 47 kΩ hace de depósito con fuga —~se carga en cada cresta de RF y se descarga lo bastante despacio para ignorar la portadora, pero lo bastante deprisa para seguir a la voz. Es la constante de tiempo del tema T2 en su papel estelar: $tau = R C approx 100 "μs"$, cómodamente entre el periodo de la portadora (∼1 μs) y el de la voz (∼1 ms). El auricular convierte esa envolvente en sonido, y aquí hay otra pieza de física del cuaderno: el auricular «de cristal» es *piezoeléctrico* —~una lámina que se deforma con la tensión aplicada, el fenómeno del cristal de cuarzo del capítulo introductorio (#ver(<sec-cristal>)), usado al revés. Al ser un condensador más que una resistencia, apenas consume: no carga el detector, y por eso suena donde un auricular dinámico de 32 Ω (un cortocircuito, a estos efectos) enmudecería la radio. Su capacidad, eso sí, cuenta: el auricular aporta 1 o 2 nF que se suman a los 2,2 nF del depósito y alargan la constante de tiempo —~recortan agudos, y son otro motivo para no pasarse con el condensador.

#circuito(sim: "amdetect.txt", caption: [La radio de galena completa: tanque LC de sintonía, diodo de germanio como detector, depósito con fuga (2,2 nF y 47 kΩ) y auricular piezoeléctrico. Sin pila: toda la energía viene de la antena. Debajo, la señal en tres puntos del circuito —~es la figura del detector de AM del temario, medida en tu mesa.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    // antena y nudo caliente
    antenna("ant", (0, 4))
    content((-0.45, 5.0), anchor: "east", _apa-t(color: col.gris, align(right)[antena: 15–20 m\ de hilo, alto]))
    wire((0, 4), (3.0, 4))
    _apa-flecha((-0.05, 3.45), (1.05, 3.45), color: _apa-se)
    content((-0.15, 3.45), anchor: "east", _apa-t(color: _apa-se)[mV de RF])
    // tanque
    inductor("l1", (1.4, 4), (1.4, 0), n: "*-*")
    content((0.95, 2), anchor: "east", text(size: 8.5pt)[$L$ 220 μH])
    capacitor("cv", (3.0, 4), (3.0, 0), variable: true, n: "*-*")
    content((3.5, 2.85), anchor: "north-west", text(size: 8.5pt)[$C_v$\ 20–365 pF])
    // detector
    diode("d1", (3.0, 4), (5.6, 4))
    content((4.3, 4.45), anchor: "south", text(size: 8.5pt)[germanio])
    capacitor("c1", (5.6, 4), (5.6, 0), n: "*-*")
    content((6.15, 2), anchor: "west", text(size: 8.5pt)[2,2 nF])
    wire((5.6, 4), (9.4, 4))
    resistor("r1", (7.4, 4), (7.4, 0), n: "*-*")
    content((7.8, 2), anchor: "west", text(size: 8.5pt)[47 kΩ])
    _apa-auricular("au", (9.4, 4), (9.4, 0))
    content((9.9, 2), anchor: "west", _apa-t(color: col.gris, align(left)[auricular\ de cristal]))
    // masa / tierra
    wire((1.4, 0), (9.4, 0))
    earth("tierra", (4.3, 0))
    node("", (4.3, 0))
    content((4.75, -0.45), anchor: "west", _apa-t(color: col.gris)[toma de tierra real: estaca, radiador])
  })
  #v(0.1em)
  #let am(x) = (1 + 0.6 * calc.sin(2 * calc.pi * x / 4)) * calc.sin(2 * calc.pi * 6 * x)
  #let env(x) = 1 + 0.6 * calc.sin(2 * calc.pi * x / 4)
  #let panel(f, color, rotulo) = box(width: 4.4cm, {
    cetz.canvas({
      import cetz.draw: *
      line((0, 0), (4.1, 0), stroke: 0.5pt + col.gris, mark: (end: ">", fill: col.gris, scale: 0.4))
      onda(f, 0, 4, n: 700, stroke: 0.6pt + color)
    })
    v(0.2em)
    align(center, _apa-t(color: col.gris, rotulo))
  })
  #grid(
    columns: 3, column-gutter: 0.8cm, align: bottom,
    panel(x => 0.34 * am(x), _apa-se, [en el tanque:\ RF modulada]),
    panel(x => 0.34 * calc.max(0, am(x)), _apa-se, [tras el diodo:\ solo semiciclos +]),
    panel(x => 0.34 * env(x), col.verde, [en el auricular:\ la envolvente (audio)]),
  )
] <apa-fig-galena>

#porque(titulo: [la galena, pieza a pieza])[
  - *Antena y tierra.* Son los dos bornes del «generador»: la onda induce una pequeña fem entre el hilo alto y el suelo, y la corriente de RF circula antena → tanque → tierra. Sin tierra el circuito no se cierra: la corriente no tiene por dónde volver y la radio enmudece.
  - *$L$ y $C_v$, el tanque.* En paralelo presentan una impedancia muy alta solo a $f_0$; a las demás frecuencias son casi un cortocircuito (las más bajas se van a tierra por la bobina, las más altas por el condensador). Por eso solo la emisora sintonizada desarrolla tensión entre los extremos del tanque. Sin tanque oirías a la vez todas las emisoras potentes, y con muy poca tensión: es la resonancia la que «hincha» la señal elegida.
  - *El diodo.* Corta la mitad negativa de la RF. Sin él la señal es simétrica, su valor medio es cero, y el auricular —~demasiado lento para seguir un megahercio~— no oye nada. Con media onda cortada, el valor medio de lo que queda sigue a la envolvente: la voz.
  - *2,2 nF.* Se carga en cada cresta de RF y sostiene la tensión de cresta a cresta: borra la portadora y deja la envolvente.
  - *47 kΩ.* Es la _fuga_ del depósito. El auricular piezoeléctrico casi no deja pasar continua; sin esta resistencia el condensador se quedaría cargado a la cresta más alta, el diodo dejaría de conducir y la salida solo seguiría las subidas de la envolvente, no las bajadas: audio débil y distorsionado. $tau = R C approx 100 "μs"$ es el compromiso: lento para la portadora, rápido para la voz.
  - *El auricular piezoeléctrico.* Es casi un condensador de 1–2 nF: no consume y no carga el detector. Un auricular dinámico de 32 Ω pondría casi un cortocircuito en paralelo con el depósito, y la tensión de audio caería a casi nada.

  En la simulación de Falstad (enlace al pie de la figura) el circuito es el mismo —~antena, tanque, diodo y filtro RC con 47 kΩ~—, pero las «emisoras» están en 2,4–3 kHz para que la animación se pueda seguir. Para sintonizar otra, cambia el valor de la $C$ del tanque (doble clic sobre el condensador).
]

#ptitulo[La antena y la tierra son la mitad de la radio] Sin amplificador, la antena no es un accesorio: es la fuente de alimentación. Cuanto más hilo y más alto —~15 o 20 m hacia un árbol o una ventana alta, aislado de la pared en los extremos~—, más energía capturas (tema T6, #ver(<sec-antena>)). Y el circuito debe _cerrarse_ por tierra, como toda corriente: una estaca metálica clavada en suelo húmedo o la tubería metálica de un radiador dan una tierra de verdad. Antena corta y sin tierra es, con diferencia, la primera causa de «no suena».

#ejemplo(titulo: [¿Cuánta energía llega?])[Una emisora de onda media de 50 kW a 100 km produce un campo del orden de $E approx sqrt(30 P) slash d approx 12$ mV/m. Tu hilo de 15 m, con una altura eficaz de unos 5 m, recoge del orden de 50 mV de fem —~y de ahí el detector extrae _microvatios_. Un auricular piezoeléctrico suena con décimas de microvatio: el balance sale, sin pila, porque la pila es la emisora. De paso queda claro por qué el codo del diodo y la impedancia del auricular no eran manías: con microvatios no hay margen para peajes.]

#ptitulo[Puesta en marcha] Móntalo en la protoboard, conecta antena y tierra, ponte el auricular y recorre el condensador variable _despacio_, de tope a tope. Mejor de noche: de día la onda de superficie solo trae las emisoras cercanas, pero al caer el sol desaparece la capa D que absorbe la onda media y la ionosfera empieza a devolver al suelo emisoras de media Europa —~es el tema T7 contado por tu propio receptor. Si no suena, en orden de probabilidad: puntas de bobina sin lijar; tierra que no es tierra; antena corta o baja; auricular dinámico en vez de piezoeléctrico; y diodo de silicio en vez de germanio.

#ptitulo[El efecto mano] Notarás que la sintonía se mueve al acercar la mano al tanque: tu cuerpo hace de armadura de un condensador de unos pocos picofaradios que, en paralelo con $C_v$, desintoniza el circuito —~con 365 pF apenas se aprecia, pero cerca del extremo de menor capacidad esos picofaradios son un buen bocado. Por eso el variable se maneja por el eje (aislante) y conviene conectar su chasis —~que suele ser el rotor, las placas móviles~— al lado de masa: así la mano queda siempre junto al electrodo frío. Si tu variable tiene dos secciones, empieza usando una; en paralelo suman capacidades (tema T3) y bajan la frecuencia mínima.

#truco[¿Las emisoras se pisan? La antena, conectada arriba del todo, _carga_ el tanque y le hunde el $Q$ (la selectividad, tema T3). Dos remedios que son puro temario: intercalar un condensador pequeño (100 pF) entre antena y tanque, o conectar la antena a la toma intermedia de la bobina —~una adaptación de impedancias por autotransformador, el mismo oficio que en la estación hace el acoplador de antena del tema T6 (#ver(<sec-redes-adaptacion>)).]

== Montaje 2: amplificar — del susurro al altavoz <apa-sec-amplificar>

La galena entrega la señal que la física da gratis: suficiente para un auricular piezoeléctrico en silencio, poco más. El paso siguiente es exactamente el que dio la historia de la radio: añadir ganancia. Dos opciones, y conviene hacer las dos.

#ptitulo[Opción A: un transistor] La @apa-fig-ec es el amplificador en emisor común del capítulo introductorio (#ver(<sec-amplificador-ec>)) montado en protoboard y alimentado con pila de 9 V —~mismos componentes, mismas dos corrientes superpuestas. La salida del detector (la envolvente de audio) entra por el condensador de acoplo, menea la base, y el auricular recibe la señal unas cien veces mayor. Merece la pena repetir aquí las cuentas del punto de trabajo con la pila de 9 V, porque son las del examen:

#ejemplo[Divisor de base: $V_B = 9 dot 10 slash (47 + 10) approx 1,6$ V. Peaje base–emisor: $V_E = 1,6 - 0,6 = 1,0$ V, luego $I_E = 1,0 slash 1500 approx 0,65$ mA. Caída en el colector: 0,65 mA · 4,7 kΩ ≈ 3,1 V, y el colector reposa a $9 - 3,1 approx 5,9$ V: a media altura, con margen para oscilar. Ganancia de tensión con el emisor desacoplado: $approx 40 thin I_C R_C approx 40 dot 0,00065 dot 4700 approx 120$. La pila cambió, el método no.]

#circuito(sim: "ceamp.txt", caption: [El amplificador en emisor común, versión de protoboard y pila de 9 V, colgado a la salida del detector de la galena. La resistencia de 100 kΩ da camino de retorno a la continua y define la carga del auricular piezoeléctrico. Compárese con el emisor común del capítulo introductorio (#ver(<sec-amplificador-ec>)): es la misma etapa, con la misma pasada en ámbar (continua) y la misma pasada en azul (señal).])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    let et(c) = text(size: 8.5pt, c)
    // raíles
    wire((0.6, 6), (10.0, 6))
    wire((0.6, 0), (10.0, 0))
    node("", (0.6, 6), fill: false)
    node("", (0.6, 0), fill: false)
    content((10.1, 6), anchor: "west", et[+9 V (pila)])
    content((10.1, 0), anchor: "west", et[masa])
    // entrada
    capacitor("cin", (0.6, 3), (2.4, 3), n: "o-*")
    content((1.5, 3.42), anchor: "south", et[1 μF])
    content((0.45, 3), anchor: "east", _apa-t(color: col.gris, align(right)[del detector\ de la galena]))
    _apa-flecha((-0.6, 3.75), (0.35, 3.75), color: _apa-se, etq: [audio])
    // divisor de base
    resistor("r1", (2.4, 6), (2.4, 3), n: "*-")
    content((2.85, 4.5), anchor: "west", et[$R_1$ 47 k])
    resistor("r2", (2.4, 3), (2.4, 0), n: "-*")
    content((2.85, 1.75), anchor: "west", et[$R_2$ 10 k])
    _apa-flecha((1.95, 5.35), (1.95, 4.45), color: _apa-cc)
    content((1.85, 4.9), anchor: "east", text(size: 7pt, fill: _apa-cc)[0,16 mA])
    // transistor
    npn("q1", (5.0, 3))
    wire((2.4, 3), "q1.b")
    content((5.35, 2.85), anchor: "west", _apa-t(color: col.gris)[BC547B])
    resistor("rc", (5.0, 6), (5.0, 4.3), n: "*-")
    content((4.6, 5.15), anchor: "east", et[$R_C$ 4,7 k])
    wire((5.0, 4.3), "q1.c")
    _apa-flecha((5.4, 5.7), (5.4, 4.7), color: _apa-cc)
    content((5.5, 5.2), anchor: "west", text(size: 7pt, fill: _apa-cc)[0,65 mA])
    wire("q1.e", (5.0, 2.1))
    resistor("re", (5.0, 2.1), (5.0, 0), n: "*-*")
    content((4.6, 0.85), anchor: "east", et[$R_E$ 1,5 k])
    // desacoplo de emisor (electrolítico: + arriba, hacia el emisor)
    wire((5.0, 2.1), (6.5, 2.1))
    pcapacitor("ce", (6.5, 0), (6.5, 2.1), n: "*-")
    content((7.0, 1.05), anchor: "west", et[47 μF])
    content((6.25, 1.45), text(size: 6.5pt)[+])
    // salida
    wire((5.0, 4.3), (6.9, 4.3))
    node("", (5.0, 4.3))
    capacitor("co", (6.9, 4.3), (8.2, 4.3))
    content((7.55, 4.72), anchor: "south", et[100 nF])
    wire((8.2, 4.3), (9.4, 4.3))
    resistor("rl", (8.6, 4.3), (8.6, 0), n: "*-*")
    content((8.2, 2.15), anchor: "east", et[100 k])
    _apa-auricular("au", (9.4, 4.3), (9.4, 0))
    node("", (9.4, 0))
    content((9.85, 2.15), anchor: "west", _apa-t(color: col.gris, align(left)[auricular\ de cristal]))
    _apa-flecha((8.35, 4.95), (9.35, 4.95), color: _apa-se, etq: [×120])
  })
] <apa-fig-ec>

#porque(titulo: [el emisor común, pieza a pieza])[
  - *$R_1$ y $R_2$, el divisor.* Fijan la base en $V_B approx 1,6$ V con 0,16 mA de corriente: unas setenta veces la corriente de base (≈ 2 μA con $beta approx 300$), así que la $beta$ del ejemplar apenas mueve $V_B$. Sin divisor, la base quedaría a 0 V: unos milivoltios de audio no superan el peaje de 0,6 V y el transistor no conduce. Silencio.
  - *$R_E$.* Fija la corriente: $I_E = V_E slash R_E$, sin $beta$ en la fórmula. Si un ejemplar «quiere» conducir más, sube $V_E$, baja $V_"BE"$ y la corriente se corrige sola: eso es estabilizar (#ver(<sec-polarizacion>)). Sin $R_E$ (emisor directo a masa), los 1,6 V de la base forzarían una corriente enorme y la etapa se iría a saturación, con el colector pegado a masa (ejercicio 7).
  - *$R_C$.* Convierte las variaciones de corriente de colector en variaciones de tensión: $Delta V_C = -Delta I_C dot R_C$. Sin ella, el colector estaría clavado a +9 V y no habría tensión de salida que aprovechar.
  - *47 μF sobre $R_E$.* Para el audio es un cortocircuito: el emisor queda quieto a 1,0 V y toda la señal actúa sobre la unión base–emisor; la ganancia es $approx 40 thin I_C R_C approx 120$. Sin él, $R_E$ también frena la señal y la ganancia cae a $R_C slash R_E approx 3$. Es electrolítico: el $+$ hacia el emisor, que está a +1 V.
  - *1 μF de entrada.* Deja pasar el audio y bloquea la continua: sin él, los 47 kΩ del detector quedarían en paralelo con $R_2$ y moverían el punto de trabajo.
  - *100 nF de salida y 100 kΩ.* El condensador impide que los 5,9 V de continua del colector lleguen al auricular; la resistencia da camino a masa a la continua del lado del auricular, que por sí solo —~un condensador~— no lo da, y fija la carga de la etapa.
  - *La pila.* Pone toda la energía de la señal amplificada: el transistor no crea potencia, solo dosifica la de la pila al ritmo de la base.

  La etapa de Falstad (enlace al pie de la figura) es la misma con otros valores —~divisor de 110 k y 10 k, $R_C = 10$ k, $R_E = 1$ k, 20 V~— y _sin_ condensador sobre $R_E$: es el caso «sin 47 μF» de arriba, con ganancia $approx R_C slash R_E = 10$. Mira en sus dos osciloscopios cómo la salida sale invertida y diez veces mayor.
]

#circuito(caption: [Lo que verías con un osciloscopio en la @apa-fig-ec. En la base, unos milivoltios de audio sobre los 1,6 V de continua (la amplitud está exagerada para que se vea). En el colector, la misma forma unas 120 veces mayor e _invertida_, oscilando alrededor de los 5,9 V de reposo: hay sitio para subir hacia el corte (9 V) y para bajar hacia la saturación (el colector no puede bajar de $V_E + 0,2$ V).])[
  #let panel(alto, base, amp, fase, limites, rotulo) = box(width: 6.4cm, {
    cetz.canvas({
      import cetz.draw: *
      let k = 0.36
      ejes(0, 5.6, 0, 10.6 * k, etq-x: $t$, etq-y: $v$)
      for (v, e) in limites {
        line((0, v * k), (5.4, v * k), stroke: (paint: col.gris, dash: "dashed", thickness: 0.5pt))
        content((5.45, v * k), anchor: "west", _apa-t(color: col.gris, size: 6.5pt, e))
      }
      line((0, base * k), (5.4, base * k), stroke: (paint: _apa-cc, thickness: 0.6pt, dash: "dotted"))
      onda(x => k * (base + amp * calc.sin(2 * calc.pi * x / 2.6 + fase)), 0, 5.4, n: 200, stroke: 1.1pt + _apa-se)
      content((-0.1, base * k), anchor: "east", _apa-t(color: _apa-cc, size: 6.5pt, str(base).replace(".", ",") + " V"))
    })
    v(0.1em)
    align(center, _apa-t(color: col.gris, rotulo))
  })
  #grid(
    columns: 2, column-gutter: 0.6cm,
    panel(3, 1.6, 0.35, 0, (), [en la base: 1,6 V + unos mV de audio]),
    panel(3, 5.9, 2.4, calc.pi, ((9, [corte]), (1.2, [saturación])), [en el colector: ≈120 veces mayor, invertida]),
  )
] <apa-fig-ec-ondas>

#ptitulo[Verifícalo con el polímetro] Antes de conectar el auricular, comprueba el punto de trabajo: polímetro en continua, punta negra a masa, y las tres tensiones de la etapa deben rondar lo calculado —~base 1,6 V, emisor 1,0 V, colector 5,9 V. Fíjate en cómo mides: el voltímetro se conecta _en paralelo_, sin abrir el circuito, y no perturba la medida porque su resistencia interna (unos 10 MΩ en un polímetro digital) es enorme comparada con las del montaje —~las dos ideas sobre el voltímetro que pregunta el tema T8, aplicadas. Si el colector aparece pegado al raíl o casi a masa, el ejercicio 7 tiene el diagnóstico.

#ptitulo[Opción B: el circuito integrado] Para un altavoz de 8 Ω hace falta _corriente_, y una sola etapa de pequeña señal no la tiene. El *LM386* (@apa-fig-lm386) es un amplificador de audio completo en un encapsulado de ocho patas: dentro hay una decena de transistores como tu BC547, ya polarizados, con la ganancia fijada en 20 por realimentación interna —~el mismo mecanismo por el que $R_E$ estabilizaba tu etapa: la ganancia depende de un cociente de resistencias internas, no de las $beta$ de los transistores. Eso _es_ un circuito integrado, tal como lo define el tema T2: el circuito entero, empaquetado y reproducible. Alimentado con la pila de 9 V entrega hasta medio vatio: la galena, en altavoz, para toda la habitación.

#circuito(caption: [El LM386 como amplificador de la galena: el potenciómetro dosifica la señal (volumen), la pata 5 entrega la salida a través del electrolítico de 220 μF que bloquea la continua, y la red de 10 Ω y 47 nF mantiene dócil al integrado en RF. El condensador de 100 μF sobre la pila hace de depósito local, como el filtro de toda fuente.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line, rect
    let et(c) = text(size: 8.5pt, c)
    let pn(c) = text(size: 6.5pt, c)
    // integrado
    rect((3.0, 1.4), (5.4, 4.4), stroke: 1pt, fill: white, radius: 0.08)
    content((4.2, 2.9), text(size: 9pt, weight: "bold")[LM386])
    // raíles
    wire((1.8, 5.4), (10.6, 5.4))
    node("", (1.8, 5.4), fill: false)
    content((1.65, 5.4), anchor: "east", et[+9 V (pila)])
    wire((0.6, 0), (10.6, 0))
    // pata 6: alimentación
    wire((4.2, 4.4), (4.2, 5.4))
    node("", (4.2, 5.4))
    content((4.35, 4.6), anchor: "west", pn[6])
    // pata 4: masa
    wire((4.2, 1.4), (4.2, 0))
    content((4.35, 1.2), anchor: "west", pn[4])
    ground("gnd", (4.2, 0))
    node("", (4.2, 0))
    // entrada y volumen
    node("", (-0.2, 4.3), fill: false)
    content((-0.35, 4.3), anchor: "east", _apa-t(color: col.gris)[del detector])
    wire((-0.2, 4.3), (0.6, 4.3))
    potentiometer("vr", (0.6, 4.3), (0.6, 0))
    content((0.15, 2.15), anchor: "east", _apa-t(color: col.gris, align(right)[10 k\ (volumen)]))
    wire("vr.a", (2.3, 2.15), (2.3, 3.7), (3.0, 3.7))
    content((2.85, 3.85), anchor: "south-east", pn[3])
    // pata 2 a masa
    wire((3.0, 2.0), (2.7, 2.0), (2.7, 0))
    node("", (2.7, 0))
    content((2.85, 2.15), anchor: "south-east", pn[2])
    // salida: pata 5
    wire((5.4, 2.9), (6.4, 2.9))
    content((5.55, 3.05), anchor: "south-west", pn[5])
    node("", (6.4, 2.9))
    // red de Zobel
    resistor("rz", (6.4, 2.9), (6.4, 1.3))
    content((6.8, 2.1), anchor: "west", et[10 Ω])
    capacitor("cz", (6.4, 1.3), (6.4, 0), n: "-*")
    content((6.95, 0.65), anchor: "west", et[47 nF])
    // condensador de salida (+ hacia el integrado)
    pcapacitor("co", (8.3, 2.9), (6.4, 2.9))
    content((7.35, 3.35), anchor: "south", et[220 μF])
    content((7.05, 3.15), text(size: 6.5pt)[+])
    wire((8.3, 2.9), (9.0, 2.9))
    _apa-flecha((7.9, 3.95), (8.8, 3.95), color: _apa-se, etq: [½ W])
    _apa-altavoz("sp", (9.0, 2.9), (9.0, 0))
    node("", (9.0, 0))
    content((9.0, -0.25), anchor: "north", _apa-t(color: col.gris, align(center)[altavoz\ 8 Ω]))
    // depósito sobre la pila
    pcapacitor("cf", (10.6, 0), (10.6, 5.4))
    content((11.1, 2.7), anchor: "west", et[100 μF])
    content((10.35, 3.1), text(size: 6.5pt)[+])
    content((4.6, -1.15), _apa-t(color: col.gris)[patas 1 y 8 al aire: ganancia 20 #h(0.6em)·#h(0.6em) con 10 μF entre ambas: ganancia 200])
  })
] <apa-fig-lm386>

#porque(titulo: [el LM386, pieza a pieza])[
  - *Potenciómetro de 10 k.* Es un divisor de tensión variable: el cursor toma una fracción de la señal del detector. Sin él, con la ganancia fija de 20, una emisora fuerte saturaría el integrado y no habría forma de bajar el volumen.
  - *Patas 2, 3, 4 y 6.* El LM386 amplifica la _diferencia_ entre sus entradas: la señal entra por la 3 (+) y la 2 (−) va a masa. La 4 es la masa y la 6 la alimentación de +9 V. Las patas 1 y 8 (ganancia) se dejan al aire: ganancia 20; un condensador de 10 μF entre ellas puentea para la señal una resistencia interna y la sube a 200. La 7 (desacoplo) puede quedar libre; con un condensador a masa filtra mejor el rizado de la alimentación.
  - *220 μF de salida.* La pata 5 reposa a la mitad de la alimentación (unos 4,5 V), para poder subir y bajar con la señal. Sin el condensador, esa continua empujaría $4,5 "V" slash 8 Omega approx 0,56$ A por el altavoz: el cono desplazado, la bobina caliente, la pila agotada y el integrado sobrecargado. Es grande porque la carga es pequeña: con 8 Ω, 220 μF dejan pasar el audio desde unos 90 Hz.
  - *10 Ω + 47 nF (red de Zobel).* A frecuencias muy altas la bobina del altavoz y sus cables ya no son una carga de 8 Ω, y el integrado, que tiene mucha ganancia, puede ponerse a oscilar. La red ofrece una carga resistiva de unos 10 Ω por encima de unos cientos de kilohercios y no hace nada en audio (47 nF a 1 kHz son unos 3,4 kΩ).
  - *100 μF sobre la pila.* Cada pico de audio pide un tirón de corriente; con la resistencia interna de la pila y de los cables, la alimentación «bajaría» en cada pico y esa caída volvería al circuito como zumbido o distorsión. El electrolítico, al lado del integrado, entrega esos tirones: es el condensador de filtro de toda fuente (#ver(<sec-fuente>)).
]

#nota[El orden de las patas del LM386, visto desde arriba con la muesca a la izquierda: 1–4 por la fila inferior (ganancia, entrada −, entrada +, masa) y 5–8 por la superior en sentido contrario (salida, alimentación, desacoplo, ganancia). El punto o muesca del encapsulado marca la pata 1 —~el convenio universal de los integrados.]

== Montaje 3: la radio con Arduino <apa-sec-arduino>

#ptitulo[Qué compra uno cuando compra un Si4732] El módulo receptor SI4732 (unos pocos euros) contiene la radio _entera_ en un chip de 16 patas (@apa-fig-si4732): amplificador de RF, mezclador, oscilador local, filtro de FI, detector y hasta el algoritmo de silenciamiento. Es —~literalmente~— el receptor superheterodino del tema T4 (#ver(<sec-mezclador>)), con una diferencia de época: tras el mezclador, la FI se digitaliza en un conversor analógico–digital y todo lo demás (filtrado, demodulación de AM, FM o SSB) lo hace un *DSP*, un procesador de señal: el detector ya no es un diodo, es una fórmula. El oscilador local tampoco es un tanque LC que deriva: es un *PLL* anclado a un cristal de cuarzo de 32 768 Hz —~el tanque perfecto del capítulo introductorio (#ver(<sec-cristal>))~—, y por eso el chip cae en la frecuencia exacta, ciclo tras ciclo. Nada de esto es magia nueva: es el temario completo, integrado.

#circuito(caption: [La radio DSP por dentro: el superheterodino del tema T4 con la FI digitalizada y demodulada por _software_, y el oscilador local anclado a cristal por un PLL. El Arduino no toca la señal en ningún momento: solo habla con el chip por el bus I2C, como un panel frontal con cables largos.])[
  #set text(size: 8pt)
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (5.5mm, 8mm),
    node((0, 0), align(center, _apa-t(color: col.gris)[1 m de hilo\ (FM) o tu\ antena larga]), stroke: none, name: <ant>),
    node((1.15, -0.62), text(weight: "bold", fill: col.gris)[módulo SI4732], stroke: none, name: <tit>),
    node((1, 0), align(center)[amplif.\ de RF], shape: rect, inset: 5pt, name: <rf>),
    node((2, 0), [mezclador], shape: rect, inset: 5pt, name: <mez>),
    node((3, 0), [ADC], shape: rect, inset: 5pt, name: <adc>),
    node((4, 0), align(center)[DSP:\ filtro FI +\ detector], shape: rect, inset: 5pt, name: <dsp>),
    node((5, 0), align(center)[amplif.\ de audio], shape: rect, inset: 5pt, name: <aud>),
    node((6.1, 0), align(center, _apa-t(color: col.gris)[auricular\ o LM386]), stroke: none, name: <sal>),
    node((2, 1), align(center)[oscilador local\ (PLL + cristal)], shape: rect, inset: 5pt, name: <ol>),
    node(enclose: (<tit>, <rf>, <aud>, <ol>), stroke: 1pt, inset: 7pt, corner-radius: 3pt, name: <mod>),
    node((4, 2.7), align(center)[Arduino Nano\ (el panel frontal: tu _sketch_)], shape: rect, inset: 6pt, fill: col.ambar-claro, name: <ard>),
    edge(<ant>, <rf>, "-|>", stroke: 0.9pt + _apa-se),
    edge(<rf>, <mez>, "-|>", stroke: 0.9pt + _apa-se),
    edge(<mez>, <adc>, "-|>", stroke: 0.9pt + _apa-se),
    edge(<adc>, <dsp>, "-|>", stroke: 0.9pt + _apa-se),
    edge(<dsp>, <aud>, "-|>", stroke: 0.9pt + _apa-se),
    edge(<aud>, <sal>, "-|>", stroke: 0.9pt + _apa-se),
    edge(<ol>, <mez>, "-|>"),
    edge((4.4, 2.7), (4.4, 1.2), "<|-|>", label: align(left, _apa-t[bus I2C (A4, A5): órdenes\ «sintoniza 95,8», «busca», «volumen»]), label-side: right, label-sep: 4pt, snap-to: (<ard>, <mod>)),
    edge((3.6, 2.7), (3.6, 1.2), "-|>", stroke: 0.9pt + _apa-cc, label: align(right, _apa-t(color: _apa-cc)[3,3 V del propio\ Nano al módulo]), label-side: left, label-sep: 4pt, snap-to: (<ard>, <mod>)),
  )
] <apa-fig-si4732>

#ptitulo[El papel del Arduino] La señal de radio nunca pasa por el Arduino. Su único trabajo es _mandar_: por el bus I2C —~dos hilos, datos y reloj~— le dice al chip a qué frecuencia ir, en qué modo demodular y a qué volumen entregar el audio. Podría sustituirse por cuatro botones y mucha paciencia; la gracia de ponerlo es que tu radio pasa a ser _programable_: memorias, búsqueda automática de emisoras, un mando por el puerto serie del ordenador.

#ptitulo[El cableado] Cinco hilos entre el Nano y el módulo, más una resistencia de 1 kΩ en la línea de reinicio (@apa-fig-cableado):

#align(center, {
  set text(size: 9pt)
  table(
    columns: 3,
    align: left,
    table.header([Módulo SI4732], [Arduino Nano], [Qué es]),
    [VCC], [3V3], [alimentación: *3,3 V, nunca 5 V*],
    [GND], [GND], [masa común],
    [RST], [D12, con 1 kΩ en serie], [reinicio del chip],
    [SDIO (SDA)], [A4], [datos I2C],
    [SCLK (SCL)], [A5], [reloj I2C],
  )
})

#circuito(caption: [El cableado de la tabla, dibujado: cinco hilos entre el Nano y el módulo, con la resistencia de 1 kΩ en serie en la línea de reinicio. La señal de radio entra por la antena del módulo y el audio sale de él directamente; el Arduino solo alimenta y da órdenes.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line, rect
    let et(c) = text(size: 8pt, c)
    let ys = (3.6, 2.9, 2.2, 1.5, 0.8)
    let nano = ("3V3", "GND", "D12", "A4", "A5")
    let modu = ("VCC", "GND", "RST", "SDIO", "SCLK")
    // Nano
    rect((0, 0.2), (2.2, 4.3), radius: 0.1, fill: col.ambar-claro, stroke: 0.9pt)
    content((1.0, 4.55), anchor: "south", text(size: 8.5pt, weight: "bold")[Arduino Nano])
    // módulo
    rect((7.6, 0.2), (9.8, 4.3), radius: 0.1, fill: col.gris-claro, stroke: 0.9pt)
    content((8.7, 4.55), anchor: "south", text(size: 8.5pt, weight: "bold")[Módulo SI4732])
    for i in range(5) {
      content((2.1, ys.at(i)), anchor: "east", et(raw(nano.at(i))))
      content((7.7, ys.at(i)), anchor: "west", et(raw(modu.at(i))))
    }
    let rojo = col.senal2
    line((2.2, ys.at(0)), (7.6, ys.at(0)), stroke: 1pt + rojo)
    wire((2.2, ys.at(1)), (7.6, ys.at(1)))
    wire((2.2, ys.at(2)), (4.2, ys.at(2)))
    resistor("rrst", (4.2, ys.at(2)), (5.6, ys.at(2)))
    content((4.9, ys.at(2) + 0.32), anchor: "south", et[1 kΩ])
    wire((5.6, ys.at(2)), (7.6, ys.at(2)))
    wire((2.2, ys.at(3)), (7.6, ys.at(3)))
    wire((2.2, ys.at(4)), (7.6, ys.at(4)))
    content((4.9, ys.at(0) + 0.1), anchor: "south", text(size: 7pt, fill: rojo)[3,3 V, nunca 5 V])
    content((4.9, ys.at(3) + 0.08), anchor: "south", _apa-t(color: col.gris, size: 7pt)[datos I2C])
    content((4.9, ys.at(4) + 0.08), anchor: "south", _apa-t(color: col.gris, size: 7pt)[reloj I2C])
    // USB, antena y audio
    _apa-flecha((-1.4, 2.25), (-0.05, 2.25), color: _apa-cc)
    content((-0.75, 2.4), anchor: "south", _apa-t(color: _apa-cc, size: 7pt, align(center)[USB:\ 5 V y datos]))
    antenna("ant", (9.4, 4.3))
    content((9.75, 5.2), anchor: "west", _apa-t(color: col.gris, size: 7pt)[antena])
    _apa-flecha((9.85, 1.5), (11.0, 1.5), color: _apa-se)
    content((11.1, 1.5), anchor: "west", _apa-t(color: _apa-se, size: 7pt, align(left)[audio: al auricular\ o al LM386]))
  })
] <apa-fig-cableado>

#porque(titulo: [cada hilo, y qué pasa si falta])[
  - *3V3 → VCC.* El chip a su tensión nominal. A 5 V se destruye (véase el recuadro siguiente).
  - *GND → GND.* La referencia común: cada tensión de datos, reloj y reinicio se mide respecto a masa. Sin masa común los niveles lógicos no significan nada y no hay comunicación.
  - *A4 → SDIO y A5 → SCLK.* En el Nano el bus I2C está fijado en el silicio: A4 es SDA (datos) y A5 es SCL (reloj). En otras patillas la biblioteca no encuentra el bus.
  - *D12 → 1 kΩ → RST.* Al arrancar, la biblioteca baja RST un instante para reiniciar el chip y lo vuelve a subir. En alto, D12 da 5 V; la resistencia limita a cerca de 1 mA la corriente que entra por las protecciones de esa entrada de 3,3 V. Sin ella, esa corriente solo la limita el propio Arduino y puede dañar el chip.
  - *Antena y audio.* Son del módulo, no del Arduino: la radio sigue funcionando aunque el Nano solo mire.
]

La salida de audio del módulo va a un auricular —~o, mejor, al LM386 del montaje 2: el taller se encadena. De antena, un metro de cable basta para FM; para onda media y corta, conecta tu antena de hilo del montaje 1. Y si tu placa trae más patillas (selección de dirección I2C, entradas de antena separadas para AM y FM), manda la serigrafía: para empezar bastan las cinco de la tabla y la salida de audio.

#ojo[El Si4732 es un chip de *3,3 V*: alimentado a 5 V se destruye. Es la versión práctica de un concepto que el temario aplica a cada componente: los valores máximos (la tensión inversa del diodo, la disipación de la resistencia) no son sugerencias. El bus I2C se salva porque sus líneas son de colector abierto: nadie impone tensión, cada chip solo _tira_ de la línea hacia masa, y las resistencias del módulo la suben a 3,3 V —~por eso Nano y Si4732 conviven sin traductor de niveles. La línea RST no goza de ese indulto: no es de colector abierto, y D12 impone sus 5 V cuando está en alto. De ahí la resistencia de 1 kΩ en serie de la tabla —~si tu módulo no la trae ya montada, ponla.]

#ptitulo[El _sketch_ mínimo] Instala la biblioteca `PU2CLR SI4735` desde el gestor de bibliotecas del IDE de Arduino y carga esto —~una radio FM completa gobernada desde el monitor serie (9600 baudios):

```cpp
#include <SI4735.h>

#define RESET_PIN 12           // RST del modulo -> D12

SI4735 radio;

void setup() {
  Serial.begin(9600);
  radio.setup(RESET_PIN, 0);    // 0 = arrancar en FM
  // banda 84,0-108,0 MHz, arrancar en 95,8, paso 100 kHz
  radio.setFM(8400, 10800, 9580, 10);
  radio.setSeekAmSpacing(9);    // busqueda en AM a pasos de 9 kHz
  radio.setVolume(50);          // 0..63
}

void loop() {
  if (Serial.available()) {
    switch (Serial.read()) {
      case '+': radio.seekStationUp();   break;
      case '-': radio.seekStationDown(); break;
      case 'f': radio.setFM(8400, 10800, 9580, 10); break;
      case 'a': radio.setAM(531, 1602, 810, 9);     break;
    }
    delay(300);
    Serial.print(F("Frecuencia: "));
    Serial.println(radio.getFrequency());
  }
}
```

Teclea `+` y `-` para saltar de emisora en emisora (la búsqueda automática la hace el DSP: barre y se detiene donde detecta portadora), `a` para pasar a onda media —~compara lo que oyes con tu galena, que está sintonizando _las mismas emisoras_ con noventa espiras de cobre~— y `f` para volver a FM. Las frecuencias se dan en unidades de 10 kHz en FM (9580 son 95,8 MHz) y en kHz en AM. Fíjate en los números de la orden de AM: 531–1602 kHz a pasos de 9 kHz, que es como está canalizada la onda media en Europa (Región 1). Los ejemplos americanos que circulan por la red usan 520–1710 a pasos de 10 —~la canalización de su región~—, y con ellos la búsqueda se detendría entre emisora y emisora.

#nota[Los dos tropiezos clásicos del primer día con un Nano clónico: el conversor serie es un CH340 (si el ordenador no ve el puerto, instala su controlador), y el cargador suele ser el antiguo —~en Herramientas elige placa «Arduino Nano» y procesador «ATmega328P (Old Bootloader)». Si el monitor serie muestra basura, revisa que esté a 9600 baudios, los mismos del `Serial.begin`.]

#truco[El paso siguiente sale solo: la misma biblioteca carga en el chip un parche de firmware que activa la demodulación de *SSB* (ejemplos `SI47XX_..._SSB` de la propia biblioteca). Con él, tu módulo de pocos euros resuelve la banda lateral única del tema T1 —~y podrás escuchar a los radioaficionados de los 40 m (7 MHz) meses antes de tener indicativo propio. Con pantalla OLED y un codificador rotatorio, el proyecto crece hasta un receptor de comunicaciones completo; los ejemplos de la biblioteca traen ambos.]

== Extra: el audio de la radio, en _streaming_ por casa <apa-sec-streaming>

#ptitulo[Primero, la mala noticia (que es una lección)] El Nano no puede hacer esto solo, y no es cuestión de empeño: el audio analógico nunca entra en el Arduino —~sale del Si4732 directo hacia el auricular~—, y aunque lo metieras por su conversor A/D, un ATmega328 tiene 2 KB de RAM y ninguna conexión de red: no hay dónde guardar las muestras ni por dónde enviarlas. Porque _streamear_ es digitalizar, y digitalizar es muestrear y cuantificar (tema T1): la voz de una emisora de AM ocupa hasta unos 4,5 kHz, así que Nyquist pide muestrear al menos al doble —~en la práctica 22 050 muestras por segundo de 16 bits, unos 350 kbit/s antes de comprimir. Fíjate en la ironía: es exactamente lo que el DSP del Si4732 ya hace _dentro_ del chip con la FI; tú vas a repetirlo fuera, con el audio, usando máquinas con red y memoria de sobra.

#circuito(caption: [La cadena de _streaming_ doméstico. A la izquierda de la tarjeta de sonido el audio aún es analógico (azul); a partir de su conversor A/D todo son bits: darkice los comprime, icecast los sirve por HTTP y Home Assistant los reparte por los altavoces de la casa.])[
  #set text(size: 8pt)
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (9mm, 8mm), node-fill: rgb("#faf8f3"),
    node((0, 0), align(center)[módulo\ SI4732], shape: rect, inset: 6pt, name: <m>),
    node((1, 0), align(center)[tarjeta de\ sonido USB], shape: rect, inset: 6pt, name: <t>),
    node((2, 0), align(center)[Raspberry Pi\ darkice → icecast], shape: rect, inset: 6pt, name: <p>),
    node((3, 0), align(center)[Home\ Assistant], shape: rect, inset: 6pt, name: <h>),
    node((4, 0), align(center)[altavoces\ de casa], shape: rect, inset: 6pt, name: <a>),
    edge(<m>, <t>, "-|>", stroke: 1pt + _apa-se, label: text(fill: _apa-se)[audio]),
    edge(<t>, <p>, "-|>", stroke: 1pt, label: [USB]),
    edge(<p>, <h>, "-|>", stroke: 1pt, label: [:8000]),
    edge(<h>, <a>, "-|>", stroke: 1pt, label: [WiFi]),
  )
] <apa-fig-streaming>

#ptitulo[Ruta A, la robusta: una Raspberry Pi como emisora de casa] Es la solución sin sorpresas (@apa-fig-streaming), con piezas que probablemente ya tienes. La salida de audio del módulo entra en una tarjeta de sonido USB (#raw("USB sound card"), unos pocos euros) pinchada en la Pi. Si la tarjeta solo trae entrada de micrófono, su sensibilidad es mucho mayor que el nivel del módulo: atenúa con un divisor de dos resistencias (10 k y 1 k —~el divisor de siempre, una vez más) y remata el ajuste con `alsamixer`. Identifica la tarjeta con `arecord -l` e instala la pareja de programas:

```bash
sudo apt install icecast2 darkice
```

`icecast2` es el servidor que publica el flujo por HTTP; `darkice` es quien lee la tarjeta, comprime y se lo entrega. Su configuración mínima, en `/etc/darkice.cfg`:

```ini
[general]
duration      = 0         # sin limite de tiempo
bufferSecs    = 2
reconnect     = yes

[input]
device        = hw:1,0    # la tarjeta USB (ver arecord -l)
sampleRate    = 22050     # Nyquist con margen para voz de AM
bitsPerSample = 16
channel       = 1         # mono: la radio es mono

[icecast2-0]
bitrateMode   = cbr
bitrate       = 64
format        = mp3
server        = localhost
port          = 8000
password      = hackme    # la de <source-password> de icecast
mountPoint    = galena.mp3
name          = La radio del taller
```

Arranca `darkice` y tu radio queda publicada en `http://<ip-de-la-pi>:8000/galena.mp3` —~cualquier reproductor de la casa puede abrirla. (Si tu `darkice` viniera compilado sin MP3, cambia `format` a `vorbis` y el punto de montaje a `.ogg`.)

#ptitulo[Y de ahí, a Home Assistant] Para Home Assistant ese flujo es una emisora de radio por internet más: dala de alta en Music Assistant como emisora con esa URL, o lánzala a cualquier altavoz con una acción:

```yaml
action: media_player.play_media
target:
  entity_id: media_player.altavoz_salon
data:
  media_content_type: music
  media_content_id: "http://192.168.1.50:8000/galena.mp3"
```

A partir de ahí es tu casa quien manda: una automatización que pone los 40 m en la cocina al hacer café, la radio del taller sonando en cualquier habitación. Cuenta con unos segundos de retardo —~icecast amortigua con búfer, y para radio es irrelevante.

#ptitulo[Ruta B, la integrada: sustituir el Nano por un ESP32] Un ESP32 (#raw("ESP32 DevKit"), precio similar al Nano) hace de panel frontal _y_ de emisora a la vez: la biblioteca PU2CLR SI4735 lo soporta oficialmente (mismo bus I2C, mismo _sketch_ con otros pines), es nativo de 3,3 V —~desaparece hasta la advertencia de niveles~— y trae WiFi y un conversor A/D que puede muestrear por DMA a decenas de kHz. El programa lee el audio del módulo con el ADC y lo sirve como flujo WAV por HTTP, que Home Assistant consume igual que en la ruta A; los proyectos tipo #raw("ESP32 WiFi microphone stream") traen ese servidor hecho, y con ESPHome el mismo chip se integra en Home Assistant como dispositivo nativo. Es la ruta elegante; también la que más depuración pide —~hazla cuando la A ya suene.

#nota[¿Y por USB desde el propio Nano? Como curiosidad, cabe: muestreando con su A/D a 8 kHz y 8 bits salen 64 kbit/s, que caben por el puerto serie a 115 200 baudios —~calidad telefónica volcada al ordenador. Es un juguete pedagógico (¡Nyquist en vivo!), no una solución: sin búfer y sin red, se queda en demostración. Y una nota de cordura sobre todo este invento: el flujo es para _tu_ casa; redistribuir emisoras fuera de casa ya no es uso doméstico.]

== Escuchar sí, transmitir todavía no <apa-sec-escuchar>

Los tres montajes de este taller _reciben_, y recibir es libre: para escuchar radiodifusión o las bandas de aficionados no hace falta autorización alguna (rige, eso sí, el secreto de las comunicaciones: lo que captes de comunicaciones que no te están destinadas no se divulga —~tema R9). *Transmitir* es otra historia: emitir en las bandas de aficionado exige la autorización y el indicativo que este cuaderno te prepara para obtener. Esa es, de hecho, la mejor manera de leer este apéndice: la física ya la tienes funcionando encima de la mesa; el examen es el trámite que falta para poder contestar a lo que oigas. Cuando llegue el indicativo, el mercado de kits te espera con transceptores QRP de 40 m para montar pieza a pieza —~la continuación natural de este taller, con las mismas herramientas.

#ejercicio(sol: [Para $f_0 = 7$ MHz con el variable cerca de su mínimo (∼50 pF): $L = 1 slash ((2 pi f_0)^2 C) approx 10$ μH. Con Wheeler y $ell = 0,045 thin N$ cm: $N = 13$ da $L = 16 dot 169 slash (180 + 58,5) approx 11$ μH. El margen con el recorrido completo del variable (40–385 pF, los mismos números del texto): de unos 2,4 a unos 7,6 MHz —~cae dentro la banda de 40 m y varias bandas de radiodifusión de onda corta.])[Rediseña la bobina del montaje 1 para onda corta: con el mismo condensador variable, ¿cuántas espiras necesitas para resonar alrededor de 7 MHz (banda de 40 m)? Usa la fórmula de Wheeler con el mismo tubo de 40 mm y calcula el margen de sintonía resultante.]

#ejercicio(sol: [El dedo es una resistencia de decenas de kΩ en paralelo con el tanque: disipa parte de la energía que la bobina y el condensador se intercambian cada ciclo. $Q$ baja, y con él las dos cosas que $Q$ mide: la tensión desarrollada en resonancia (volumen) y la estrechez de la campana (selectividad). Es la misma razón por la que la antena se acopla con condensador pequeño o toma intermedia, no directamente.])[Con la galena sonando, tocas con el dedo húmedo el nudo caliente del tanque (la unión bobina–variable) y la emisora casi desaparece, además de «ensancharse» la sintonía. Explícalo con el factor $Q$ del tema T3.]

#ejercicio(sol: [La base sigue al divisor: $V_B = V_"pila" dot 10 slash 57$; de ahí $V_E = V_B - 0,6$, $I_C approx V_E slash 1,5 "k"$ y $V_C = V_"pila" - 4,7 thin I_C$ (kΩ y mA). Basta tabular: a 9 V, margen $V_C - V_E = 5,9 - 1,0 = 4,9$ V; a 6 V, $V_B = 1,05$, $V_E = 0,45$, $I_C = 0,3$ mA, $V_C = 4,6$ V, margen 4,2 V; incluso a 5 V el margen ronda los 3,8 V. La respuesta es, pues, «nunca»: al bajar la pila bajan a la vez la base, la corriente y la caída en el colector, el punto de trabajo se recoloca solo, y el margen $V_C - V_E$ no baja de unos 2,5 V mientras el transistor conduzca —~el criterio de los 2 V no llega a violarse. Lo que mata la etapa es otra cosa: el _corte_, cuando con la pila por debajo de ∼3,4 V el divisor ya no da los 0,6 V de base. Esa es la moraleja del divisor con resistencia de emisor, lo que el temario llama estabilizar el punto de trabajo.])[En el amplificador del montaje 2, la pila se va gastando: ¿a qué tensión de pila deja el colector de estar «a media altura» si exigimos al menos 2 V de margen entre el colector (que baja con la pila) y la tensión de emisor (que también baja)? Toma los valores de la @apa-fig-ec y razona con el divisor.]

#ejercicio(sol: [En la galena, el detector recibe milivoltios: nunca alcanza el codo de 0,6–0,7 V del silicio y el diodo no llega a conducir. En la radio del capítulo introductorio la señal pasa antes por el amplificador de RF, que la sube por encima del codo: allí el 1N4148 rectifica sin queja. El codo no era una anécdota del tema T2: decide qué diodo va en cada sitio.])[¿Por qué un 1N4148 de silicio fracasa como detector en la galena pero funcionaría sin problema como detector en la radio del capítulo introductorio (#ver(<sec-radio-entera>))?]

#ejercicio(sol: [500 mAh / 5 mA = 100 h —~un fin de semana entero de radio encendida. La galena: infinitas, porque su «pila» es el transmisor de la emisora. No hay mejor resumen del taller.])[El montaje 2 consume unos 5 mA en reposo (0,65 mA la etapa del transistor, unos 4 mA el LM386 sin señal). Una pila alcalina de 9 V ronda los 500 mAh. ¿Cuántas horas de radio dan? ¿Y la galena?]

#ejercicio(sol: [Con la secuencia 0–9 (negro, marrón, rojo, naranja, amarillo, verde, azul, violeta, gris, blanco): 10 Ω marrón–negro–negro; 10 k marrón–negro–naranja; 47 k amarillo–violeta–naranja; 100 k marrón–negro–amarillo; 4,7 k amarillo–violeta–rojo; 1,5 k marrón–verde–rojo —~y la banda oro de tolerancia cerrando todas.])[Escribe las bandas de color (cuatro bandas, tolerancia oro) de las seis resistencias de la lista de la compra: 10 Ω, 10 kΩ, 47 kΩ, 100 kΩ, 4,7 kΩ y 1,5 kΩ. Es el código del tema T2, y en el examen cae.]

#ejercicio(sol: [$V_C = 9$ V significa que en $R_C$ no cae nada: $I_C = 0$, el transistor está en _corte_. Casi siempre la base se quedó sin polarizar: divisor mal pinchado en la protoboard, patillas C–B–E confundidas (¡la @apa-fig-componentes!) o el condensador de entrada donde iba un cable. Confírmalo midiendo $V_B$: si no hay ∼1,6 V, el fallo está antes del transistor. $V_C approx 0,2$ V es lo contrario, _saturación_: circula mucha más corriente de la prevista y el transistor ya no puede bajar más —~$V_"CE" approx 0$ es la firma de la saturación. Aquí la delatora vuelve a ser $V_E$, porque $V_C = V_E + V_"CE(sat)"$: con $R_E$ puenteada, $V_E = 0$ V —~el único fallo compatible con un colector a 0,2 V de masa~—; con una $R_E$ de valor muy bajo o una $R_C$ equivocada de década alta, medirás $V_E approx 0,3$–0,4 V con el colector apenas por encima. Y una $V_E$ muy por encima de 1 V apuntaría a otra avería distinta: un divisor de base mal montado. Depurar una etapa es esto: medir en paralelo, sin abrir nada, y comparar con el punto de trabajo calculado.])[Montas el amplificador del montaje 2 y el polímetro dice $V_C = 9$ V, clavado al raíl. ¿Diagnóstico? ¿Y si dijera $V_C approx 0,2$ V? ¿Qué otra tensión medirías para confirmarlo en cada caso?]

#soluciones-ejercicios()
