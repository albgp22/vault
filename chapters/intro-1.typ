#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Capítulo de introducción «Cómo funciona una radio: de los campos a la voz»
//  (clave intro-1, etiquetas i1-). El título lo escribe el integrador.
//  Ayudas locales para las figuras (prefijo _i1-).
// ---------------------------------------------------------------------
#let _i1-t(x, c: black, s: 8pt) = text(size: s, fill: c, x)
// bloque de diagrama (fletcher) con texto pequeño
#let _i1-b(pos, cuerpo, ..args) = node(pos, text(size: 7.5pt, cuerpo), shape: rect, ..args)
// bloque sintonizado (resaltado)
#let _i1-bs(pos, cuerpo, ..args) = node(pos, text(size: 7.5pt, cuerpo), shape: rect, fill: col.ambar-claro, stroke: 0.8pt + col.ambar, ..args)
// respuesta normalizada de un circuito resonante: u = f/f0
#let _i1-res(u, q) = 1 / calc.sqrt(1 + q * q * calc.pow(u - 1 / u, 2))

Antes de estudiar el temario tema a tema conviene tener en la cabeza la película completa: qué le pasa a tu voz desde que entra por el micrófono hasta que sale por el altavoz del corresponsal, a cientos o miles de kilómetros. Todo el temario de la primera prueba —campos, señales, moduladores, antenas, propagación, receptores— son piezas de esa única cadena. Este capítulo la recorre entera y _despacio_, explicando el _porqué_ de cada eslabón; los temas T1 a T10 lo retoman luego con el detalle y las preguntas del examen.

El viaje tiene una simetría bonita: el transmisor convierte un sonido en una corriente, la corriente en una onda electromagnética y la lanza al espacio; el receptor hace exactamente el camino inverso. Para entenderlo hay que empezar por lo más básico de todo: por qué existen las ondas de radio. Y, justo después, detenerse con calma en el idioma que hablan todos los circuitos que las manejan: la corriente alterna y la impedancia (#ver(<sec-impedancia>)). Esa sección es la más larga del capítulo a propósito: es la base sobre la que se apoyan las antenas, las líneas, los filtros y medio temario, y merece construirse despacio, con circuitos de ejemplo y ejercicios.

== Electromagnetismo: de la carga a la onda <sec-em>

#motivacion[Tu voz tiene que cruzar cientos de kilómetros sin un solo cable, a veces a través del vacío. Antes de hablar de circuitos hay que responder a una pregunta muy básica: ¿qué hay en el espacio vacío que pueda transportar una señal? La respuesta son los _campos_, y la idea que lo hace posible es de Maxwell.]

#ptitulo[Cargas y campos] La magnitud primitiva de toda la electricidad es la *carga*. Una carga en reposo perturba el espacio a su alrededor: crea un *campo eléctrico* $arrow(E)$, una especie de «tensión por metro» que empujaría a otra carga si la pusiéramos cerca. No hace falta contacto; el campo es el intermediario. Cuando la carga se mueve —cuando hay una *corriente*— aparece además un *campo magnético* $arrow(B)$ que rodea al conductor en circunferencias. Son los dos campos de siempre: el eléctrico nace de las cargas, el magnético de las corrientes.

#ptitulo[La idea de Maxwell] Aquí está la clave de toda la radio, y merece detenerse. A mediados del siglo XIX se sabía que un campo magnético _variable_ induce un campo eléctrico (es la ley de Faraday, la de las dinamos). Maxwell añadió la mitad que faltaba: un campo eléctrico _variable_ induce, a su vez, un campo magnético. Junta las dos frases y mira lo que sale: si en algún punto un campo eléctrico cambia, engendra un campo magnético; pero ese campo magnético también está cambiando, así que engendra un campo eléctrico un poco más allá; que a su vez… Cada campo regenera al otro, y el conjunto *se desengancha de la carga que lo originó* y sale disparado por su cuenta. Eso es una *onda electromagnética*: campos que se sostienen mutuamente y ya no necesitan cables ni cargas para existir.

#analogia[Piensa en la «ola» de un estadio. Nadie se mueve de su asiento: cada espectador se levanta solo porque se ha levantado el de al lado, y sin embargo la ola recorre la grada entera. En la onda electromagnética no viaja ninguna materia: viaja un _cambio_. El cambio del campo eléctrico «levanta» al magnético de al lado, y este al eléctrico siguiente. Basta con empujar la primera fila (la antena); el resto se propaga solo.]

#ptitulo[Por qué hay que _agitar_ la carga] Una carga quieta solo tiene su campo eléctrico estático, que no viaja. Una corriente constante añade un campo magnético estático, que tampoco. Para que los campos empiecen a regenerarse uno a otro hace falta que _cambien_, y para que cambien rápido hay que mover las cargas _aceleradamente_, adelante y atrás, muchos millones de veces por segundo. La regla, en una frase: *solo una carga acelerada radia*. Una antena no es más que un sitio donde obligamos a los electrones a acelerar arriba y abajo al ritmo de la frecuencia de trabajo.

#ptitulo[La onda que resulta] Cuando los campos se sueltan y viajan, lo hacen con tres propiedades que hay que grabar:

- $arrow(E)$ y $arrow(B)$ son *perpendiculares* entre sí y ambos perpendiculares a la dirección de avance (una onda _transversal_).
- Viajan en el vacío a la *velocidad de la luz*, $c = 3 times 10^8$ m/s, porque la luz _es_ una onda electromagnética: solo cambia la frecuencia.
- En un ciclo completo de la oscilación la onda avanza una *longitud de onda* $lambda$. Como hay $f$ ciclos por segundo, $c = lambda f$, de donde la regla de bolsillo $lambda ("m") approx 300 slash f ("MHz")$.

La dirección de $arrow(E)$ define la *polarización* de la onda (vertical u horizontal, según cómo esté la antena), y la potencia se reparte al alejarse sobre una esfera cada vez mayor: por eso la señal cae con el cuadrado de la distancia.

#circuito(caption: [La onda electromagnética: los campos eléctrico y magnético, perpendiculares entre sí y a la dirección de avance, oscilan en fase y se regeneran mutuamente mientras viajan a la velocidad de la luz. En un ciclo la onda recorre una longitud de onda $lambda$.])[
  #cetz.canvas({
    import cetz.draw: *
    let lam = 4.8
    let x1 = 2 * lam
    let ef(x) = 1.05 * calc.sin(2 * calc.pi * x / lam)
    let bf(x) = 0.85 * calc.sin(2 * calc.pi * x / lam)
    // dirección oblicua (eje perpendicular al papel, en perspectiva)
    let dx = -0.42
    let dy = -0.5
    for i in range(0, 61) {
      let x = i * x1 / 60
      line((x, 0), (x, ef(x)), stroke: 0.3pt + col.senal1.lighten(45%))
      let b = bf(x)
      line((x, 0), (x + dx * b, dy * b), stroke: 0.3pt + col.naranja.lighten(45%))
    }
    line((-0.3, 0), (x1 + 1.1, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((x1 + 1.2, 0), anchor: "west", _i1-t(c: col.gris)[propagación, $c$])
    onda(ef, 0, x1, n: 240, stroke: 1.1pt + col.senal1)
    let pts = range(241).map(i => {
      let x = i * x1 / 240
      let b = bf(x)
      (x + dx * b, dy * b)
    })
    line(..pts, stroke: 1.1pt + col.naranja)
    // longitud de onda entre dos crestas
    line((lam / 4, 1.5), (lam / 4 + lam, 1.5), mark: (start: ">", end: ">", fill: black, scale: 0.7), stroke: 0.5pt)
    line((lam / 4, 1.1), (lam / 4, 1.62), stroke: (thickness: 0.4pt, dash: "dotted"))
    line((lam / 4 + lam, 1.1), (lam / 4 + lam, 1.62), stroke: (thickness: 0.4pt, dash: "dotted"))
    content((lam / 4 + lam / 2, 1.55), anchor: "south", _i1-t($lambda$))
    content((0.2, 1.2), anchor: "east", _i1-t(c: col.senal1)[campo eléctrico $arrow(E)$])
    content((-0.3, -0.75), anchor: "east", _i1-t(c: col.naranja)[campo magnético $arrow(B)$])
  })
] <i1-fig-onda>

#ejemplo(titulo: [Longitudes de onda de las bandas de aficionado])[
  Con $lambda approx 300 slash f$: en la banda de 40~m, a 7,1~MHz, $lambda approx 300 slash 7,1 approx 42$~m; en la de 2~m, a 145~MHz, $lambda approx 2,07$~m; en la de 70 cm, a 435~MHz, $lambda approx 0,69$~m. El nombre de cada banda es, redondeada, su longitud de onda. Y la caída con la distancia: a doble distancia la misma potencia se reparte sobre una esfera de superficie $4 pi d^2$ cuatro veces mayor, así que llega la cuarta parte (−6~dB).
]

#ojo[La regla $lambda = 300 slash f$ da metros solo si $f$ va en *megahercios*. Con la frecuencia en kilohercios es $lambda = 300 thin 000 slash f$; con hercios, $lambda = 3 times 10^8 slash f$. Casi todas las preguntas de longitud de onda del banco se resuelven con esta regla, siempre que vigiles las unidades.]

#idea[Un campo que cambia engendra el otro campo, y la pareja viaja sola a la velocidad de la luz. Para lanzarla hay que acelerar cargas: eso hace una antena. Todo lo que sigue en el capítulo sirve para que esa aceleración lleve la voz.]

== Corriente alterna: la impedancia sin misterio <sec-impedancia>

Todo lo que viene después habla el idioma de la impedancia: el dipolo «presenta 73 Ω», el cable coaxial «es de 50 Ω», el receptor «sintoniza» con circuitos resonantes, el acoplador «adapta» la antena. Y sin embargo la impedancia se suele contar al revés: como una fórmula con raíz cuadrada, en vez de como lo que es — la versión para corriente alterna de una idea de andar por casa: _cuánto le cuesta a la corriente pasar_. Esta sección construye esa intuición desde cero, con muchos circuitos de ejemplo y ejercicios con solución. Si ya la tienes, sáltala sin remordimientos; si no, es la mejor inversión del cuaderno.

#ptitulo[En continua todo es fácil] Con una pila y una resistencia la historia completa cabe en la ley de Ohm: $V = I R$, y la única forma de oponerse al paso de la corriente es la *resistencia*: fricción pura, que frena siempre por igual, convierte en calor la energía que frena, y a la que el tiempo no le importa en absoluto. Pero una señal de radio no es continua: es una sinusoide que cambia de valor y de sentido millones de veces por segundo. Y en cuanto las magnitudes _cambian con el tiempo_, despiertan dos personajes que en continua pasaban desapercibidos: el condensador y la bobina. Ninguno de los dos disipa energía; los dos la _almacenan y la devuelven_. Y la oposición de ambos depende de la frecuencia. Ahí — y solo ahí — está toda la novedad de la alterna.

#ptitulo[Los tres personajes] Conviene tener una imagen mecánica de cada uno antes que su fórmula:

- La *resistencia* es una tubería estrecha: se opone al paso del agua, siempre por igual, vaya el flujo en el sentido que vaya y cambie al ritmo que cambie. Disipa: la energía que frena se va en calor.
- El *condensador* es una membrana elástica que corta la tubería: un flujo continuo no puede atravesarla — la membrana se tensa y ahí se acaba —, pero un _vaivén_ sí se transmite: la membrana cede a un lado, empuja al otro. Cuanto más rápido el vaivén, mejor pasa. Almacena energía en su campo eléctrico y _se opone a los cambios de tensión_.
- La *bobina* es una turbina pesada intercalada en la tubería: al flujo constante, una vez arrancada, no le estorba nada; pero cada cambio de ritmo le cuesta, porque hay que acelerar o frenar su inercia. Cuanto más rápido el vaivén, más estorba. Almacena energía en su campo magnético y _se opone a los cambios de corriente_.

Fíjate en que condensador y bobina son *espejo* el uno del otro: lo que uno deja pasar, el otro lo bloquea. Esa simetría reaparecerá en cada fórmula de esta sección.

=== La reactancia: cuánto se opone cada componente <sec-reactancia>

#ptitulo[El condensador en alterna] Un condensador son dos placas separadas por un aislante. La corriente _no_ atraviesa el aislante, pero no le hace falta: la fuente empuja carga hacia una placa y la retira de la otra, y si la tensión aplicada cambia sin parar, esa carga va y viene sin parar — en los cables del circuito hay una corriente tan real como cualquiera. La regla del componente es que la corriente es proporcional a lo _deprisa_ que cambia la tensión (y al tamaño del depósito, la capacidad $C$): en símbolos, $i = C thin d v slash d t$. Dos consecuencias inmediatas. Con tensión constante (continua) la corriente es cero: el condensador cargado es un *circuito abierto*. Con tensión cambiando muy rápido (alta frecuencia) la corriente es enorme: el condensador es casi un *cable*. La medida numérica de su oposición es la *reactancia capacitiva*,
$ X_C = 1 / (2 pi f C), $
en ohmios, que _baja_ al subir la frecuencia o la capacidad. (El factor $2 pi f$ aparecerá tantas veces que tiene nombre propio: la _pulsación_ $omega = 2 pi f$, en radianes por segundo; con ella, $X_C = 1 slash omega C$.)

#ptitulo[La bobina en alterna] Una bobina es un hilo arrollado en espiras. Toda variación de la corriente que la recorre cambia su campo magnético, y ese cambio induce en las propias espiras una tensión que — ley de Lenz — _se opone_ a la variación que la creó: la bobina se resiste a que su corriente cambie, igual que un volante de inercia se resiste a cambiar de vueltas. La regla es la simétrica de la anterior: la tensión en bornes es proporcional a lo deprisa que cambia la corriente, $v = L thin d i slash d t$, con $L$ la inductancia en henrios. En continua (pasado el arranque) no se opone nada: la bobina ideal es un *cable* — solo queda la resistencia óhmica del hilo. A alta frecuencia se opone muchísimo: casi un *circuito abierto*. Su reactancia,
$ X_L = 2 pi f L = omega L, $
_sube_ con la frecuencia y con la inductancia: justo el espejo de $X_C$.

#nota(titulo: [De dónde salen las dos fórmulas])[
  No hace falta cálculo, basta mirar una sinusoide. La tensión $v = V sin(2 pi f t)$ cambia más deprisa al cruzar por cero, y allí su pendiente vale $2 pi f V$: cerca del cero, $sin x approx x$, así que $v approx V dot 2 pi f dot t$, una recta de pendiente $2 pi f V$. Como la corriente del condensador es $C$ por esa pendiente, su valor máximo es $I = C dot 2 pi f V$, y la oposición «voltios por amperio» resulta $X_C = V slash I = 1 slash (2 pi f C)$. En la bobina el razonamiento es el mismo con los papeles cambiados: la tensión máxima es $V = L dot 2 pi f I$, y $X_L = V slash I = 2 pi f L$. El $2 pi f$ no es más que _la rapidez con que cambia una sinusoide_: al doblar la frecuencia todo cambia el doble de rápido, el condensador deja pasar el doble de corriente y la bobina le opone el doble de tensión.
]

#ejemplo[
  Un mismo componente cambia de papel según quién lo atraviese. Toma un condensador de 100~nF y una bobina de 10~μH y calcula sus reactancias:

  #align(center, table(
    columns: 3,
    align: (left, right, right),
    stroke: none,
    table.hline(stroke: 0.6pt),
    [frecuencia], [$X_C$ (100~nF)], [$X_L$ (10~μH)],
    table.hline(stroke: 0.4pt),
    [50~Hz (red eléctrica)], [31,8~kΩ], [0,003~Ω],
    [1~kHz (audio)], [1,6~kΩ], [0,063~Ω],
    [7~MHz (banda de 40~m)], [0,23~Ω], [440~Ω],
    [145~MHz (banda de 2~m)], [0,011~Ω], [9,1~kΩ],
    table.hline(stroke: 0.6pt),
  ))

  Para el audio, ese condensador es un muro y la bobina un cable; para la RF de 2~m, el condensador es un cable y la bobina un muro. Todos los filtros del temario viven de este cambio de papeles.
]

#truco[Cuatro frases que resuelven media docena de preguntas del banco: el *condensador* bloquea la continua y deja pasar la alta frecuencia ($X_C$ _disminuye_ al aumentar $f$); la *bobina* deja pasar la continua y bloquea la alta frecuencia ($X_L$ _aumenta_ con $f$). Si en el examen dudas del sentido, piensa en la membrana y en el volante de inercia.]

#ojo[Dos preguntas del banco salen directamente de aquí: al aumentar la frecuencia, la reactancia de un condensador _disminuye_ (T2.10); y la reactancia de una bobina en corriente continua _vale cero_ (T2.16). Cuidado con la trampa de la segunda: la reactancia es cero, pero la bobina real conserva la pequeña resistencia de su hilo.]

En el simulador se ven las dos tendencias con tres ramas iguales alimentadas a tres frecuencias distintas: el condensador, al pie de la figura siguiente; la bobina, aquí: #falstad("indmultfreq.txt", texto: [bobina]). La @i1-fig-reactancias[figura] resume el comportamiento de ambas reactancias frente a la frecuencia — y adelanta un punto singular sobre el que volveremos: la frecuencia en que ambas se igualan.

#circuito(caption: [Las dos reactancias frente a la frecuencia: la de la bobina crece en línea recta, la del condensador cae en hipérbola. A la izquierda del todo (continua) la bobina es un cable y el condensador un circuito abierto; a la derecha (RF alta), al revés. En la frecuencia $f_0$ donde se cruzan, ambas valen lo mismo: es la resonancia, la protagonista del final de esta sección.], sim: "capmultfreq.txt")[
  #cetz.canvas({
    import cetz.draw: *
    ejes(0, 8.4, 0, 4.4, etq-x: $f$)
    content((0, 4.5), anchor: "south", _i1-t[reactancia (Ω)])
    onda(x => 0.5 * x, 0, 8, stroke: 1.2pt + col.naranja)
    onda(x => 8 / x, 1.85, 8, stroke: 1.2pt + col.senal1)
    let f0 = 4
    line((f0, 0), (f0, 2), stroke: (thickness: 0.5pt, dash: "dashed"))
    circle((f0, 2), radius: 0.06, fill: black)
    content((f0, -0.1), anchor: "north", _i1-t($f_0$))
    content((f0 + 0.15, 2.1), anchor: "south-west", _i1-t[aquí $X_L = X_C$: resonancia])
    content((6.9, 3.75), anchor: "east", _i1-t(c: col.naranja)[$X_L = 2 pi f L$ (bobina)])
    content((5.0, 0.6), anchor: "west", _i1-t(c: col.senal1)[$X_C = display(1 / (2 pi f C))$ (condensador)])
  })
] <i1-fig-reactancias>

#ptitulo[El desfase: quién va delante] La reactancia dice _cuánto_ se opone cada componente; falta el segundo rasgo de la alterna, el _cuándo_. En una resistencia, tensión y corriente son gemelas: la corriente es máxima justo cuando la tensión es máxima — van *en fase*. En el condensador no: acabamos de ver que su corriente es proporcional a la _pendiente_ de la tensión. Y en una sinusoide la pendiente es máxima en el cruce por cero y nula en la cresta: la corriente alcanza su máximo un cuarto de ciclo _antes_ que la tensión. Se dice que la corriente *adelanta* 90°. En la bobina ocurre lo simétrico: la tensión es proporcional a la pendiente de la corriente, así que es la tensión la que va un cuarto de ciclo por delante — la corriente *retrasa* 90° (@i1-fig-desfase[figura]). No hay que memorizarlo como un dogma: sale solo de «la corriente sigue a la pendiente» (condensador) y «la tensión sigue a la pendiente» (bobina). En el simulador, el condensador está al pie de la figura y la bobina, aquí: #falstad("inductac.txt", texto: [bobina]).

#circuito(caption: [Tensión y corriente en los tres componentes. En la resistencia van a la par. En el condensador la corriente va un cuarto de ciclo por delante (fíjate: $i$ es máxima donde $v$ cruza por cero subiendo, que es donde la pendiente de $v$ es mayor). En la bobina, un cuarto de ciclo por detrás.], sim: "capac.txt")[
  #cetz.canvas({
    import cetz.draw: *
    let w = 4.4
    let paneles = (
      (x => 0.8 * calc.sin(x), [*R*: $v$ e $i$ en fase]),
      (x => 0.8 * calc.cos(x), [*C*: $i$ adelanta 90°]),
      (x => -0.8 * calc.cos(x), [*L*: $i$ retrasa 90°]),
    )
    for (k, (fi, rot)) in paneles.enumerate() {
      group({
        set-origin((k * (w + 0.9), 0))
        ejes(0, w, -1.25, 1.35, etq-x: $t$)
        let s = 2 * calc.pi / (w - 0.4)
        onda(x => 1.1 * calc.sin(x * s), 0, w - 0.4, stroke: 1.1pt + col.senal1)
        onda(x => fi(x * s), 0, w - 0.4, stroke: (paint: col.naranja, thickness: 1pt, dash: "dashed"))
        content((w / 2, -1.45), anchor: "north", _i1-t(rot))
      })
    }
    content((1.6, 1.55), anchor: "south", _i1-t(c: col.senal1)[tensión $v$])
    content((2 * (w + 0.9) + 1.8, 1.55), anchor: "south", _i1-t(c: col.naranja)[corriente $i$ (a trazos)])
  })
] <i1-fig-desfase>

#truco[Para el examen y para siempre: *ELI–ICE*. En la bobina (L), la tensión E va antes que la corriente I: _E-L-I_. En el condensador (C), la corriente I va antes que la tensión E: _I-C-E_. (La E es de fuerza electromotriz, el nombre clásico de la tensión.)]

#ptitulo[Reactancia no es resistencia: la energía que va y vuelve] ¿Por qué inventar la palabra «reactancia» si se mide en ohmios, como la resistencia? Porque se comporta de otra manera con la energía. La potencia instantánea es el producto $p = v dot i$. En una resistencia, $v$ e $i$ tienen siempre el mismo signo (van en fase): el producto nunca es negativo y el componente _siempre_ absorbe energía — por eso calienta. En un condensador o una bobina puros, con sus 90° de desfase, el producto $v dot i$ es positivo la mitad del tiempo y negativo la otra mitad: el componente absorbe energía un cuarto de ciclo (la almacena en su campo) y la _devuelve_ al circuito el cuarto siguiente. En promedio no consume _nada_ (@i1-fig-potencia[figura]). Una reactancia limita la corriente sin gastar energía: la toma prestada y la devuelve, ciclo tras ciclo. De ahí una regla que usaremos sin parar: en un circuito con resistencia y reactancia, *solo la parte resistiva disipa potencia*; la potencia media real es $P = V I cos phi$, donde $phi$ es el desfase entre tensión y corriente (el famoso _factor de potencia_ $cos phi$ de la electricidad general).

#circuito(caption: [La potencia instantánea $p = v dot i$ (trazo grueso). En la resistencia (izquierda) es siempre positiva: el componente absorbe energía todo el tiempo y la convierte en calor. En el condensador (derecha) cambia de signo cada cuarto de ciclo: las zonas verdes son energía que entra en el campo eléctrico y las rojas, la misma energía que vuelve al generador. Su media es cero. En la bobina pasa lo mismo, con el campo magnético.])[
  #cetz.canvas({
    import cetz.draw: *
    let w = 6.4
    let s = 2 * calc.pi / (w - 0.6)
    let n = 120
    // panel de la resistencia
    group({
      ejes(0, w, -1.2, 1.5, etq-x: $t$)
      let pts = range(n + 1).map(i => { let x = i * (w - 0.6) / n; (x, 1.1 * calc.pow(calc.sin(x * s), 2)) })
      line((0, 0), ..pts, (w - 0.6, 0), close: true, fill: col.verde.lighten(70%), stroke: none)
      onda(x => calc.sin(x * s), 0, w - 0.6, stroke: 0.6pt + col.senal1)
      onda(x => 0.9 * calc.sin(x * s), 0, w - 0.6, stroke: (paint: col.naranja, thickness: 0.6pt, dash: "dashed"))
      onda(x => 1.1 * calc.pow(calc.sin(x * s), 2), 0, w - 0.6, stroke: 1.3pt + col.verde)
      content((w / 2, -1.35), anchor: "north", _i1-t[*R*: $p gt.eq 0$ siempre (calienta)])
    })
    // panel del condensador
    group({
      set-origin((w + 1.0, 0))
      ejes(0, w, -1.2, 1.5, etq-x: $t$)
      let pf(x) = 1.1 * calc.sin(x * s) * calc.cos(x * s) * 1.6
      for q in range(4) {
        let a = q * (w - 0.6) / 4
        let b = (q + 1) * (w - 0.6) / 4
        let pts = range(31).map(i => { let x = a + i * (b - a) / 30; (x, pf(x)) })
        let c = if calc.even(q) { col.verde.lighten(70%) } else { col.senal2.lighten(75%) }
        line((a, 0), ..pts, (b, 0), close: true, fill: c, stroke: none)
      }
      onda(x => calc.sin(x * s), 0, w - 0.6, stroke: 0.6pt + col.senal1)
      onda(x => 0.9 * calc.cos(x * s), 0, w - 0.6, stroke: (paint: col.naranja, thickness: 0.6pt, dash: "dashed"))
      onda(pf, 0, w - 0.6, stroke: 1.3pt + col.verde)
      content((0.74, 0.32), _i1-t(s: 6.5pt)[toma])
      content((2.21, -0.32), _i1-t(s: 6.5pt)[devuelve])
      content((w / 2, -1.35), anchor: "north", _i1-t[*C*: media de $p$ = 0 (no calienta)])
    })
  })
] <i1-fig-potencia>

#ojo[El banco pregunta qué es el factor de potencia (T1.35): es $cos phi$, la fracción de los «voltios por amperios» que se convierte de verdad en potencia. Con una carga resistiva pura $cos phi = 1$; con una reactancia pura $cos phi = 0$: hay corriente, pero no se consume nada.]

=== Fasores e impedancia <i1-sec-fasores>

#ptitulo[Fasores: la sinusoide como flecha] Sumar sinusoides desfasadas a base de trigonometría es un suplicio, y los ingenieros lo esquivan con un truco visual que conviene adoptar cuanto antes. Representa cada sinusoide de frecuencia $f$ como una *flecha que gira* dando $f$ vueltas por segundo: la longitud de la flecha es la amplitud y el ángulo del que parte, la fase (@i1-fig-fasor[figura]). En un circuito lineal todas las señales tienen la _misma_ frecuencia, así que todas las flechas giran al unísono: podemos congelar la foto y quedarnos solo con las longitudes y los _ángulos relativos_. Esa flecha congelada se llama *fasor*. Dos reglas lo son todo: sumar dos señales es poner sus flechas una a continuación de la otra (suma de vectores), y los 90° del condensador y la bobina se vuelven literales: sus tensiones son flechas _perpendiculares_ a la de la resistencia. La trigonometría se convierte en geometría de triángulos rectángulos.

#circuito(caption: [Un fasor es una flecha que gira. Su sombra sobre el eje vertical sube y baja describiendo exactamente una sinusoide: la longitud de la flecha es la amplitud, y su ángulo en cada instante, $omega t$, es la fase. Dos señales desfasadas 90° son dos flechas perpendiculares que giran juntas.])[
  #cetz.canvas({
    import cetz.draw: *
    let r = 1.3
    let a = 55deg
    circle((0, 0), radius: r, stroke: (paint: col.gris, thickness: 0.5pt, dash: "dotted"))
    line((-1.6, 0), (1.6, 0), stroke: 0.4pt + col.gris)
    line((0, -1.6), (0, 1.6), stroke: 0.4pt + col.gris)
    let tip = (r * calc.cos(a), r * calc.sin(a))
    line((0, 0), tip, stroke: 1.4pt + col.senal1, mark: (end: ">", fill: col.senal1))
    arc((0.45, 0), start: 0deg, stop: a, radius: 0.45, stroke: 0.5pt, mark: (end: ">", fill: black, scale: 0.5))
    content((0.62, 0.3), _i1-t($omega t$))
    content((-0.1, 1.85), _i1-t[gira $f$ vueltas por segundo])
    // sinusoide a la derecha
    let x0 = 2.4
    let w = 6.4
    line((x0, 0), (x0 + w + 0.4, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((x0 + w + 0.4, 0), anchor: "north-east", padding: 3pt, _i1-t($t$))
    onda(x => r * calc.sin((x - x0) / w * 2 * calc.pi), x0, x0 + w, stroke: 1.1pt + col.senal1)
    let xp = x0 + w * a / 360deg
    line(tip, (xp, tip.at(1)), stroke: (paint: col.gris, thickness: 0.5pt, dash: "dashed"))
    circle((xp, tip.at(1)), radius: 0.06, fill: col.senal1, stroke: none)
    circle(tip, radius: 0.05, fill: col.senal1, stroke: none)
    content((x0 + w / 2 + 0.4, -1.55), _i1-t[la sombra de la punta dibuja $v = V sin omega t$])
  })
] <i1-fig-fasor>

#nota[Si en otros libros ves escrito $Z = R + j X$: la «j» es la manera algebraica de decir «girado 90°». Los números complejos son la contabilidad de estas flechas, nada más — no hacen falta para el examen, pero si algún día los usas, ya sabes qué significan.]

#ptitulo[La impedancia: la ley de Ohm de la alterna] Ya podemos juntarlo todo. La *impedancia* $Z$ de un circuito es, por definición, lo que la ley de Ohm necesita para seguir siendo cierta en alterna: $Z = V slash I$, en ohmios — cuántos voltios hay que aplicar por cada amperio que circula —, acompañada del ángulo $phi$ que separa la tensión de la corriente. Para una resistencia y una reactancia *en serie* el cálculo es un triángulo. Por los dos pasa la _misma_ corriente; la tensión de la resistencia va en fase con ella (flecha horizontal) y la de la reactancia, a 90° (flecha vertical). La tensión total es la hipotenusa, y dividiendo todo por la corriente queda el *triángulo de impedancias*:
$ Z = sqrt(R^2 + X^2), quad quad tan phi = X / R. $
Con un convenio de signos que ya conoces sin saberlo: la reactancia inductiva apunta hacia _arriba_ (la tensión adelanta) y la capacitiva hacia _abajo_ (la tensión retrasa). Si en el circuito conviven ambas, primero se restan: $X = X_L - X_C$. Guárdate esa resta: es la puerta de la resonancia.

#ejemplo[
  El circuito de la @i1-fig-rl[figura]: un generador de 100~V eficaces (el equivalente en continua a efectos de potencia; en el tema T1 lo verás formalmente) alimenta, en serie, una resistencia de $R = 40$~Ω y una bobina cuya reactancia a la frecuencia de trabajo es $X_L = 30$~Ω. La impedancia del conjunto es
  $ Z = sqrt(40^2 + 30^2) = sqrt(1600 + 900) = sqrt(2500) = 50 thin Omega, $
  así que circula $I = 100 slash 50 = 2$~A. Las tensiones parciales: $V_R = 2 dot 40 = 80$~V y $V_L = 2 dot 30 = 60$~V. Y aquí llega el momento que separa la alterna de la continua: $80 + 60 = 140$~V… ¡pero el generador solo da 100! No hay contradicción: esas dos tensiones nunca son máximas a la vez — están a 90° — y se suman como vectores: $sqrt(80^2 + 60^2) = sqrt(6400 + 3600) = 100$~V. Kirchhoff sigue vivo, pero en versión geométrica.

  El desfase es $phi = arctan(30 slash 40) approx 37°$, con $cos phi = 0,8$; la potencia disipada es solo la de la resistencia, $P = I^2 R = 4 dot 40 = 160$~W, aunque el producto «voltios por amperios» del generador sea $100 dot 2 = 200$. Ojo: los voltamperios que faltan no salen restando. La energía de vaivén de la bobina tiene su propia medida, la *potencia reactiva* $Q = V I sin phi = 200 dot 0,6 = 120$ (voltamperios reactivos, var; también $I^2 X_L$), y vatios y voltamperios se componen en ángulo recto: $sqrt(160^2 + 120^2) = 200$ — el mismo triángulo que el de las tensiones de unas líneas más arriba.
]

#circuito(caption: [Circuito RL serie del ejemplo y su diagrama de fasores. La corriente (común a los dos componentes) va en fase con $V_R$; la tensión de la bobina está a 90°; la del generador es la hipotenusa: 80~V y 60~V «suman» 100~V. Dividiendo las tres flechas por la corriente, el mismo triángulo es el de impedancias: 40, 30 y 50~Ω.], sim: "impedance.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line, arc
    acvsource("v", (0, 0), (0, 2.6), label: [100~V])
    wire((0, 2.6), (0, 3), (1.2, 3))
    resistor("r", (1.2, 3), (3.4, 3), label: [$R$ = 40~Ω])
    wire((3.4, 3), (4.4, 3), (4.4, 2.6))
    inductor("l", (4.4, 2.6), (4.4, 0.4), label: [$X_L$ = 30~Ω])
    wire((4.4, 0.4), (4.4, 0), (0, 0))
    // fasores (escala 0,04 cm/V)
    let o = (7, 0.3)
    line(o, (10.2, 0.3), stroke: 1.3pt + col.senal1, mark: (end: ">", fill: col.senal1))
    line((10.2, 0.3), (10.2, 2.7), stroke: 1.3pt + col.naranja, mark: (end: ">", fill: col.naranja))
    line(o, (10.2, 2.7), stroke: 1.3pt + col.verde, mark: (end: ">", fill: col.verde))
    arc(o, start: 0deg, stop: 36.87deg, radius: 1.1, anchor: "origin", stroke: 0.5pt)
    content((8.45, 0.62), _i1-t[37°])
    content((8.6, 0.1), anchor: "north", _i1-t(c: col.senal1)[$V_R$ = 80~V])
    content((10.35, 1.5), anchor: "west", _i1-t(c: col.naranja)[$V_L$ = 60~V])
    content((8.4, 1.75), anchor: "south-east", _i1-t(c: col.verde)[$V$ = 100~V])
  })
] <i1-fig-rl>

#porque[
  - Por $R$ y por la bobina pasa _la misma_ corriente, porque están en serie: no hay otro camino. Esa corriente común es la referencia de todos los ángulos.
  - En $R$ la tensión sigue a la corriente (en fase): flecha horizontal de 80~V. En la bobina la tensión va 90° por delante (ELI): flecha vertical de 60~V.
  - El generador tiene que aportar en cada instante la suma de las dos tensiones; como sus máximos no coinciden, la suma es la diagonal (100~V) y no la suma aritmética (140~V).
  - Solo $R$ calienta: 160~W. La bobina toma y devuelve 120~var sin consumirlos.
]

#ejercicio(sol: [$X_C = 1 slash (2 pi dot 7 times 10^6 dot 10^(-10)) approx 227$~Ω; $X_L = 2 pi dot 145 times 10^6 dot 10^(-5) approx 9,1$~kΩ; en continua ($f = 0$), $X_L = 0$: la bobina ideal es un cable, y solo queda la resistencia óhmica del hilo.])[
  Calcula la reactancia de un condensador de 100~pF a 7~MHz. ¿Y la de una bobina de 10~μH a 145 MHz? ¿Qué reactancia presenta esa misma bobina a la corriente continua?
]

#ejercicio(sol: [$Z = sqrt(30^2 + 40^2) = 50$~Ω; $I = 10 slash 50 = 0,2$~A; la reactancia es capacitiva, así que la _corriente_ adelanta (ICE) unos 53°.])[
  En un circuito serie, $R = 30$~Ω y $X_C = 40$~Ω, alimentado con 10~V eficaces. Calcula la impedancia y la corriente, y di quién va por delante, la tensión o la corriente del generador.
]

#ejercicio(sol: [$Z = sqrt(60^2 + 80^2) = 100$~Ω; $I = 0,2$~A; $cos phi = R slash Z = 60 slash 100 = 0,6$.])[
  Una resistencia de 60~Ω en serie con una reactancia inductiva de 80~Ω, alimentadas con 20~V. Calcula $Z$, la corriente y el factor de potencia $cos phi$.
]

#ejercicio(sol: [Al subir $f$ crece $X_L = 2 pi f L$ y con ella $Z = sqrt(R^2 + X_L^2)$: circula menos corriente. En continua $X_L = 0$ y quedan solo los 40~Ω: $I = 100 slash 40 = 2,5$~A.])[
  En el ejemplo de la @i1-fig-rl[figura], ¿qué le pasa a la impedancia si la frecuencia del generador sube (sin tocar los componentes)? ¿Y si el generador pasara a dar corriente continua?
]

=== El filtro RC: un divisor que elige frecuencias <sec-filtros-rc>

#motivacion[En un mismo cable conviven a menudo cosas que hay que separar: la voz y el siseo agudo que la acompaña; la RF y la tensión continua de alimentación; el audio y los restos de portadora a la salida de un detector. Hace falta un circuito que deje pasar unas frecuencias y frene otras. El más sencillo de todos se hace con una resistencia y un condensador.]

#ptitulo[El divisor que elige frecuencias: el filtro RC] El circuito más rentable de toda la electrónica es el divisor de tensión: dos componentes en serie y la salida tomada del de abajo. Con dos resistencias, el reparto es fijo. Pero sustituye la de abajo por un condensador (@i1-fig-rc[figura]) y el reparto pasa a depender de la frecuencia: a frecuencias bajas $X_C$ es enorme comparada con $R$ — casi toda la tensión cae en el condensador, y la salida es casi igual que la entrada —; a frecuencias altas $X_C$ es minúscula — la señal muere en $R$ y apenas sale nada. Es un *filtro paso bajo*: deja pasar lo lento, ataja lo rápido. La frontera entre ambos regímenes es la *frecuencia de corte*, definida donde $X_C = R$:
$ f_c = 1 / (2 pi R C), $
y en ella la salida vale el 70,7~% de la entrada (los famosos −3~dB: la mitad de la _potencia_). Intercambia $R$ y $C$ y tienes el *paso alto*; hazlo con bobinas y los papeles se invierten. Y combinando bobinas _y_ condensadores salen los filtros de verdad del temario — paso banda, rechazo de banda, en pi, en T (tema T3; para qué sirven las redes en pi y en T lo verás en #ver(<sec-redes-adaptacion>)) —, pero la lógica no cambia nunca: _reactancias repartiéndose la señal según la frecuencia_.

#ptitulo[De dónde salen $f_c$ y el 70,7~%] La fórmula de $f_c$ no es más que la condición $R = 1 slash (2 pi f C)$ con $f$ despejada. Y el 70,7~% sale del triángulo de fasores: en $f_c$ la resistencia y el condensador se oponen igual y los recorre la misma corriente, así que sus tensiones son _iguales_ y están a 90°. Dos catetos iguales cuya hipotenusa es la entrada: cada uno vale $v_"in" slash sqrt(2) = 0,707 thin v_"in"$. La potencia va con el cuadrado de la tensión, $0,707^2 = 0,5$: la mitad. Muy por encima de $f_c$ la salida es aproximadamente $X_C slash R = f_c slash f$: se reduce a la mitad cada vez que la frecuencia se dobla (−6~dB por octava). Por eso un RC es un filtro _suave_: no corta en seco, va inclinando la balanza.

#nota[Primera aparición del *decibelio*, que ya no se irá: compara dos potencias en escala logarítmica, $"dB" = 10 log_10 (P_2 slash P_1)$. Bastan tres anclas: +3~dB duplica la potencia, +10~dB la multiplica por diez, y los valores negativos la reducen (por eso −3~dB es la mitad). Los apellidos que verás en las antenas — dBi, dBd — solo cambian la referencia $P_1$: la antena isótropa o el dipolo.]

#ejemplo[Con $R = 1,6$~kΩ y $C = 100$~nF, la frecuencia de corte es $f_c = 1 slash (2 pi dot 1600 dot 10^(-7)) approx 1$~kHz. Este filtro dejaría pasar la voz grave de un contacto y recortaría el siseo agudo: es, literalmente, un control de tono rudimentario. La selectividad seria del receptor superheterodino que veremos luego ya no se fía de las redes RC: se consigue con circuitos sintonizados LC y filtros de cristal, mucho más afilados (temas T3 y T4) — pero la lógica es la misma: reactancias repartiéndose la señal.]

#circuito(caption: [Filtro RC paso bajo: un divisor de tensión en el que el componente de abajo cambia de valor con la frecuencia. A la izquierda, el circuito; a la derecha, su respuesta: plana hasta las cercanías de $f_c$ y cayendo después. En $f_c$ (donde $X_C = R$) la salida es el 70,7~% de la entrada, −3~dB.], sim: "filt-lopass.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    acvsource("v", (0, 0), (0, 2.6), label: $v_"in"$)
    wire((0, 2.6), (0, 3), (0.6, 3))
    resistor("r", (0.6, 3), (2.6, 3), label: $R$)
    wire((2.6, 3), (4.8, 3))
    capacitor("c", (3.6, 3), (3.6, 0), label: $C$, n: "*-*")
    wire((0, 0), (4.8, 0))
    node("o1", (4.8, 3), fill: false)
    node("o2", (4.8, 0), fill: false)
    content((5.1, 1.5), anchor: "west", _i1-t($v_"out"$))
    // respuesta
    let x0 = 7.2
    let fc = 1.5
    line((x0, 0), (x0 + 6, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    line((x0, 0), (x0, 3.2), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((x0 + 6, -0.05), anchor: "north-east", _i1-t($f$))
    content((x0 + 0.1, 3.2), anchor: "north-west", _i1-t($v_"out" slash v_"in"$))
    let h = 2.4
    onda(x => h / calc.sqrt(1 + calc.pow((x - x0) / fc, 2)), x0, x0 + 5.7, stroke: 1.2pt + col.senal1)
    line((x0, h * 0.707), (x0 + fc, h * 0.707), (x0 + fc, 0), stroke: (thickness: 0.5pt, dash: "dashed"))
    content((x0 - 0.05, h), anchor: "east", _i1-t[1])
    content((x0 - 0.05, h * 0.707), anchor: "east", _i1-t[0,707])
    content((x0 + fc, -0.05), anchor: "north", _i1-t($f_c$))
    content((x0 + 4.1, 1.3), _i1-t(c: col.senal1)[lo rápido no pasa])
    content((x0 + 1.0, 2.75), anchor: "west", _i1-t(c: col.senal1)[lo lento pasa])
  })
] <i1-fig-rc>

#porque[
  - $R$ y $C$ forman un divisor: la entrada se reparte entre los dos en proporción a su oposición, y la salida es lo que le toca al condensador.
  - A baja frecuencia $X_C$ es enorme: el condensador «se lleva» casi toda la tensión y la salida copia la entrada.
  - A alta frecuencia $X_C$ es casi un cortocircuito a masa: la tensión cae entera en $R$ y a la salida no llega casi nada.
  - Sin $R$ no habría reparto: el condensador estaría conectado directamente al generador y tendría siempre toda su tensión. La resistencia es la que «da contra qué» repartir.
]

#circuito(caption: [El mismo divisor al revés: con el condensador en serie y la resistencia abajo sale un filtro paso alto. Ahora es la baja frecuencia la que se queda en el condensador; la salida crece con $f$ y vuelve a valer el 70,7~% en la misma $f_c = 1 slash (2 pi R C)$.], sim: "filt-hipass.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    acvsource("v", (0, 0), (0, 2.6), label: $v_"in"$)
    wire((0, 2.6), (0, 3), (0.8, 3))
    capacitor("c", (0.8, 3), (2.6, 3), label: $C$)
    wire((2.6, 3), (4.8, 3))
    resistor("r", (3.6, 3), (3.6, 0), label: $R$, n: "*-*")
    wire((0, 0), (4.8, 0))
    node("o1", (4.8, 3), fill: false)
    node("o2", (4.8, 0), fill: false)
    content((5.1, 1.5), anchor: "west", _i1-t($v_"out"$))
    let x0 = 7.2
    let fc = 1.5
    line((x0, 0), (x0 + 6, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    line((x0, 0), (x0, 3.2), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((x0 + 6, -0.05), anchor: "north-east", _i1-t($f$))
    content((x0 + 0.1, 3.2), anchor: "north-west", _i1-t($v_"out" slash v_"in"$))
    let h = 2.4
    onda(x => { let r = (x - x0) / fc; h * r / calc.sqrt(1 + r * r) }, x0, x0 + 5.7, stroke: 1.2pt + col.senal1)
    line((x0, h * 0.707), (x0 + fc, h * 0.707), (x0 + fc, 0), stroke: (thickness: 0.5pt, dash: "dashed"))
    line((x0, h), (x0 + 5.7, h), stroke: (thickness: 0.4pt, dash: "dotted", paint: col.gris))
    content((x0 - 0.05, h), anchor: "east", _i1-t[1])
    content((x0 - 0.05, h * 0.707), anchor: "east", _i1-t[0,707])
    content((x0 + fc, -0.05), anchor: "north", _i1-t($f_c$))
  })
] <i1-fig-pasoalto>

#porque[
  - Ahora el condensador está en el camino de la señal: a baja frecuencia su $X_C$ enorme se queda casi toda la tensión y a la salida ($R$) no llega nada. La continua ($f = 0$) no pasa en absoluto.
  - A alta frecuencia el condensador es casi un cable y la tensión entera aparece en $R$, es decir, en la salida.
  - Es el mismo reparto de antes con los papeles cambiados: por eso la frecuencia de corte es la misma fórmula.
]

#ejercicio(sol: [$f_c = 1 slash (2 pi dot 3200 dot 10^(-8)) approx 5$~kHz: por encima de los 3~kHz de la voz, así que la deja pasar entera (y recorta ruido más agudo).])[
  Calcula la frecuencia de corte de un paso bajo RC con $R = 3,2$~kΩ y $C = 10$~nF. ¿Ese filtro respeta la voz (300–3000~Hz) de una emisión de SSB?
]

#ptitulo[Tres empleos que verás en todos los esquemas] Con «el condensador corta lo lento y la bobina corta lo rápido» se leen de golpe la mitad de los esquemas del temario. Tres papeles se repiten sin parar:

- *Condensador de acoplo* (en serie con la señal): une dos etapas dejando pasar la señal alterna y bloqueando la tensión continua de polarización de cada una, para que no se molesten.
- *Condensador de desacoplo* (en paralelo, a masa): en un punto que debe estar «tranquilo» — una línea de alimentación, por ejemplo — ofrece a la RF un camino cómodo a masa y la elimina; a la continua ni la toca.
- *Choque de RF* (bobina en serie): deja entrar la alimentación continua a una etapa e impide que la RF se escape por el cable de alimentación.

Los dos primeros son, en el fondo, los dos filtros RC que acabas de ver, colocados en sitios concretos de un aparato real (@i1-fig-acoplo[figura]).

#circuito(caption: [Los filtros RC en un aparato real. (a) El condensador de acoplo $C_a$ y la resistencia de entrada de la etapa siguiente forman un paso alto: pasa todo el audio, pero no la tensión continua de la etapa anterior. (b) La resistencia $R_d$ y el condensador $C_d$ forman un paso bajo en la línea de alimentación: la continua llega a la etapa y el rizado, el audio o la RF que viajan por la línea se van a masa.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line, rect
    // (a) acoplo
    rect((0, 0.9), (1.7, 2.7), stroke: 0.7pt, radius: 0.08)
    content((0.85, 1.8), _i1-t[etapa 1])
    wire((1.7, 1.8), (2.1, 1.8))
    capacitor("ca", (2.1, 1.8), (3.5, 1.8), label: [$C_a$ = 10~μF])
    wire((3.5, 1.8), (4.6, 1.8))
    rect((4.0, -0.75), (7.0, 2.3), stroke: (thickness: 0.5pt, dash: "dashed", paint: col.gris), radius: 0.08)
    resistor("rent", (4.6, 1.8), (4.6, 0), label: [$R_"ent"$ = 10~kΩ], n: "*-")
    ground("g1", (4.6, 0))
    content((5.5, -1.0), _i1-t(c: col.gris, s: 7pt)[entrada de la etapa 2])
    content((2.4, -1.5), _i1-t[(a) acoplo: paso alto])
    // (b) desacoplo
    node("vin", (8.4, 2.2), fill: false)
    content((8.25, 2.2), anchor: "east", _i1-t[+13,8~V])
    resistor("rd", (8.4, 2.2), (10.0, 2.2), label: [$R_d$ = 100~Ω])
    wire((10.0, 2.2), (13.0, 2.2))
    pcapacitor("cd", (10.6, 0.2), (10.6, 2.2), label: [$C_d$ = 100~μF])
    content((10.88, 1.52), _i1-t(s: 7pt)[+])
    capacitor("cr", (11.8, 2.2), (11.8, 0.2), label: [100~nF], n: "*-")
    node("n9", (10.6, 2.2))
    wire((10.6, 0.2), (11.8, 0.2))
    ground("g2", (11.2, 0.2))
    node("vout", (13.0, 2.2), fill: false)
    content((13.0, 2.55), anchor: "south", _i1-t[a la etapa])
    content((10.7, -1.5), _i1-t[(b) desacoplo: paso bajo])
  })
] <i1-fig-acoplo>

#porque[
  - *(a)* $C_a$ y $R_"ent"$ son el paso alto de la @i1-fig-pasoalto[figura] con valores reales: $f_c = 1 slash (2 pi dot 10^4 dot 10^(-5)) approx 1,6$~Hz, muy por debajo de los 300~Hz de la voz. Todo el audio pasa; la tensión continua del colector de la etapa 1 (unos voltios) se queda a la izquierda del condensador y no descoloca la polarización de la etapa 2. Si $C_a$ fuera demasiado pequeño, $f_c$ subiría hasta el audio: el ejercicio que viene te pide adivinar qué se perdería.
  - *(b)* $R_d$ y $C_d$ son el paso bajo de la @i1-fig-rc[figura] puesto en la alimentación: $f_c = 1 slash (2 pi dot 100 dot 10^(-4)) approx 16$~Hz. La continua pasa (solo pierde $I R_d$ voltios), mientras que el rizado de 100~Hz de la fuente o la señal que otra etapa haya dejado en la línea se van a masa por $C_d$.
  - El cerámico de 100~nF en paralelo se ocupa de la RF: un electrolítico grande tiene demasiada inductancia propia para trabajar bien a varios megahercios (#ver(<i1-sec-reales>)).
  - Sin desacoplo, las etapas se hablarían entre ellas a través del cable de alimentación: la salida de una volvería a la entrada de otra, y un amplificador así acaba oscilando.
]

Los tres a la vez, trabajando en un truco clásico de radioaficionado: la @i1-fig-biast[figura] muestra un _bias-T_, el circuito con el que se alimenta un preamplificador situado junto a la antena _a través del propio cable coaxial_, sin tender un cable de corriente aparte. El condensador deja pasar la RF hacia el cable pero cierra el paso a los 12~V; la bobina inyecta los 12~V en el cable pero impide que la RF se cuele en la fuente de alimentación. Corriente y señal comparten cable sin verse.

#circuito(caption: [Un bias-T: los tres papeles de la sección en un solo circuito. Para la RF, el condensador es transparente y la bobina un muro; para la corriente continua, exactamente al revés. Resultado: la alimentación del preamplificador viaja por el mismo coaxial que la señal, y ninguna estorba a la otra.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    capacitor("c", (0, 2.2), (3.2, 2.2), label: [$C$ de acoplo], n: "o-")
    wire((3.2, 2.2), (6.6, 2.2))
    node("n", (4.4, 2.2))
    node("o", (6.6, 2.2), fill: false)
    inductor("l", (4.4, 2.2), (4.4, 0.2), label: (content: [$L$ de choque], anchor: "south"), n: "-o")
    content((-0.15, 2.2), anchor: "east", align(right, _i1-t[RF del\ transceptor]))
    content((6.8, 2.2), anchor: "west", _i1-t[al coaxial:\ RF + 12~V])
    content((4.4, -0.05), anchor: "north", _i1-t[+12~V para el preamplificador])
  })
] <i1-fig-biast>

#porque[
  - *El condensador* está en serie con la RF. A 145~MHz, un condensador de 1~nF presenta $X_C approx 1$~Ω: para la señal es un cable. Para los 12~V es un circuito abierto: la continua no puede entrar en el transceptor.
  - *La bobina* está en el camino de la continua. Para los 12~V es un cable (solo su pequeña resistencia de hilo). A 145~MHz, una bobina de 1~μH presenta $X_L approx 900$~Ω, unas veinte veces más que los 50~Ω de la línea: casi nada de RF se escapa hacia la fuente.
  - Junto a la antena hay otro bias-T idéntico que hace la separación contraria: su bobina saca los 12~V del coaxial para el preamplificador, y su condensador lleva la RF al preamplificador sin la continua.
  - Sin el condensador, los 12~V llegarían a la entrada de antena del transceptor; sin la bobina, la fuente de alimentación sería un camino a masa para la RF y se comería parte de la señal.
]

#ejercicio(sol: [Sufren los _graves_: al bajar $f$, la reactancia $X_C = 1 slash 2 pi f C$ del condensador de acoplo crece y forma un divisor cada vez más desfavorable con la impedancia de entrada de la etapa siguiente. Los agudos pasan sin enterarse.])[
  Un condensador de acoplo entre dos etapas de audio resulta demasiado pequeño. ¿Qué parte de la señal sufre, los graves o los agudos? ¿Por qué?
]

=== La resonancia: cómo se elige una frecuencia <sec-resonancia>

#motivacion[Dos problemas de cualquier radio piden lo mismo. *En recepción*, la antena no recoge una emisora: las recoge _todas_ a la vez — radiodifusión, colegas en la banda, ruido —, cientos de señales sumadas en el mismo hilo. ¿Cómo te quedas con una sola? *En transmisión*, el amplificador final no entrega una sinusoide limpia (uno de clase C da pulsos de corriente llenos de armónicos), y el oscilador necesita algo que fije _su_ frecuencia y no otra. Los tres casos piden un circuito con una *frecuencia favorita*: que responda mucho a ella y casi nada a las demás. Ese circuito existe, solo necesita una bobina y un condensador, y se llama *circuito resonante*.]

#analogia[Un columpio. Tiene un ritmo propio, fijado por la longitud de sus cuerdas: suéltalo y oscila siempre con el mismo periodo. Si lo empujas _a su ritmo_, un pequeño empujón por vuelta basta para que la amplitud crezca y crezca. Si lo empujas a otro ritmo, la mitad de los empujones llegan a contrapié y deshacen lo que hicieron los otros: apenas se mueve. El columpio _elige_ el ritmo de los empujones que aprovecha. Por dentro, su energía va y viene entre dos formas: altura en los extremos y velocidad al pasar por abajo. Un circuito LC es exactamente esto, con la energía yendo y viniendo entre el campo eléctrico del condensador y el campo magnético de la bobina.]

#ptitulo[Resonancia serie: las reactancias se anulan] Pon ahora en serie una bobina y un condensador (con la inevitable resistencia $R$ del hilo, @i1-fig-serie[figura]). Por los dos pasa la misma corriente, pero sus tensiones juegan en bandos contrarios: la de la bobina adelanta 90° y la del condensador retrasa 90° — están en _oposición_ perfecta, y se restan. A frecuencias bajas manda el condensador (recuerda la @i1-fig-reactancias[figura]); a frecuencias altas, la bobina. Y en la frecuencia exacta en que $X_L = X_C$ las dos tensiones se cancelan por completo: el generador solo ve la resistencia $R$. Es la *resonancia*: la impedancia del circuito serie es _mínima_ (vale $R$, pura, sin ángulo) y la corriente, _máxima_. Despejando $f$ de $2 pi f L = 1 slash (2 pi f C)$ sale la frecuencia propia del dúo,

#destacada($ f_0 = 1 / (2 pi sqrt(L C)) $)

(fórmula de Thomson), que no depende de $R$: solo de cuánta bobina y cuánto condensador hay. El despeje, paso a paso: multiplica los dos lados de $2 pi f L = 1 slash (2 pi f C)$ por $2 pi f C$ y queda $(2 pi f)^2 L C = 1$; es decir, $f^2 = 1 slash (4 pi^2 L C)$, y la raíz cuadrada da la fórmula. Más bobina o más condensador bajan la frecuencia de resonancia; menos, la suben.

#circuito(caption: [Circuito resonante serie del ejemplo. En $f_0 approx 10$~MHz las reactancias de bobina y condensador (unos 158~Ω cada una) se cancelan mutuamente y el generador solo ve los 5~Ω de pérdidas: corriente máxima. Al alejarse de la resonancia, la cancelación deja de ser perfecta y la impedancia crece.], sim: "res-series.txt")[
  #esquema({
    import zap: *
    acvsource("v", (0, 0), (0, 2.6), label: $v$)
    wire((0, 2.6), (0, 3), (0.6, 3))
    resistor("r", (0.6, 3), (2.6, 3), label: [$R$ = 5~Ω])
    inductor("l", (2.8, 3), (4.8, 3), label: [$L$ = 2,5~μH])
    wire((2.6, 3), (2.8, 3))
    wire((4.8, 3), (5.8, 3))
    capacitor("c", (5.8, 3), (5.8, 0), label: [$C$ = 100~pF])
    wire((5.8, 0), (0, 0))
  })
] <i1-fig-serie>

#porque[
  - La *misma corriente* recorre los tres componentes, porque están en serie. Las tensiones de $L$ y de $C$ apuntan en sentidos opuestos (una adelanta y otra retrasa 90° respecto a esa corriente).
  - En $f_0$ esas dos tensiones tienen el mismo tamaño y se anulan: para el generador, la pareja $L C$ «desaparece» y solo queda $R$. Por eso la corriente es máxima y está en fase con la tensión.
  - Por debajo de $f_0$ gana el condensador (el circuito se comporta como capacitivo y la corriente adelanta); por encima gana la bobina (inductivo, la corriente retrasa). En ambos casos sobra reactancia y la corriente baja.
  - $R$ no cambia $f_0$, pero decide lo _alta_ que es la corriente en resonancia y lo estrecho que es el pico: es la pérdida que limita el circuito.
]

#ejemplo[Con $L = 2,5$~μH y $C = 100$~pF: $sqrt(L C) = sqrt("2,5" times 10^(-16)) approx 1,58 times 10^(-8)$~s, y $f_0 = 1 slash (2 pi dot 1,58 times 10^(-8)) approx 10$~MHz. En resonancia cada reactancia vale $X = 2 pi f_0 L approx 158$~Ω. Si $R = 5$~Ω y el generador da 1~V, la corriente es $I = 1 slash 5 = 0,2$~A… y la tensión en el condensador, $V_C = 0,2 dot 158 approx 32$~V. ¡Treinta y dos voltios dentro de un circuito alimentado con uno! No hay magia: la bobina tiene otros 32~V en oposición exacta, y de puertas afuera se anulan. El factor de multiplicación es el *factor de calidad* del circuito, $Q = X slash R = 158 slash 5 approx 32$.]

#ojo[La sobretensión resonante es real y muerde: dentro de un acoplador de antena o de una antena con trampas, las tensiones internas pueden ser decenas de veces la aplicada — con 100~W pueden aparecer miles de voltios en los extremos de una bobina. Por eso los condensadores variables de los acopladores tienen esas separaciones de aire tan generosas, y por eso no se manipula un acoplador transmitiendo.]

#ejercicio(sol: [$sqrt(L C) = sqrt(10^(-16)) = 10^(-8)$~s; $f_0 = 1 slash (2 pi times 10^(-8)) approx 15,9$~MHz.])[
  Calcula la frecuencia de resonancia de un circuito con $L = 1$~μH y $C = 100$~pF.
]

#ejercicio(sol: [$C$ está dentro de la raíz: cuadruplicarla multiplica $sqrt(L C)$ por 2 y divide $f_0$ por 2: resuena en 5~MHz.])[
  Un circuito resuena en 10~MHz. Sin tocar la bobina, se cuadruplica la capacidad del condensador. ¿En qué frecuencia resuena ahora? (Pista: mira dónde está $C$ en la fórmula de Thomson.)
]

#ptitulo[Resonancia paralelo: el tanque que recuerda una frecuencia] Conecta ahora bobina y condensador _en paralelo_ y piensa en la energía. Carga el condensador y déjalo solo con la bobina: el condensador se descarga a través de ella creando corriente; esa corriente carga el campo magnético de la bobina; cuando el condensador se agota, la bobina — que se niega a que su corriente cese — sigue empujando y recarga el condensador con la polaridad contraria; y vuelta a empezar. La energía va y viene del campo eléctrico al magnético como un péndulo entre altura y velocidad, a un ritmo que es exactamente la misma $f_0$ de Thomson. Por eso al LC paralelo se le llama *circuito tanque*: almacena la oscilación. Visto desde fuera, su comportamiento es el contrario del serie: en $f_0$ apenas pide corriente al generador — la corriente ya circula por dentro, entre bobina y condensador — y presenta impedancia _máxima_; fuera de $f_0$, uno de los dos componentes ofrece camino fácil y la impedancia cae. Un tanque colocado entre la señal y masa deja en pie su frecuencia favorita (para ella es un muro: la tensión se desarrolla) y desvía a masa todas las demás. Eso es, ni más ni menos, *sintonizar*.

#circuito(caption: [Un ciclo de un circuito tanque, en cuatro fotos. (1) El condensador está cargado y la corriente es nula: toda la energía está en su campo eléctrico. (2) El condensador se ha vaciado y la corriente es máxima: toda la energía está en el campo magnético de la bobina. (3) La bobina, que no deja que su corriente se pare de golpe, ha recargado el condensador al revés. (4) La corriente vuelve a ser máxima, ahora en sentido contrario. Abajo, la tensión del condensador y la corriente: dos sinusoides desfasadas un cuarto de ciclo, como la altura y la velocidad de un columpio.], sim: "lrc.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line, circle
    let xs = (1.2, 4.6, 8.0, 11.4)
    let top = 4.9
    let bot = 3.3
    let ym = (top + bot) / 2
    let estados = (
      ("+", 0, [toda la energía en $C$\ (campo eléctrico)]),
      ("0", 1, [toda la energía en $L$\ (campo magnético)]),
      ("-", 0, [otra vez en $C$,\ con la polaridad invertida]),
      ("0", -1, [otra vez en $L$,\ con la corriente al revés]),
    )
    for (k, (sg, cur, txt)) in estados.enumerate() {
      let cx = xs.at(k)
      let xa = cx - 0.65
      let xb = cx + 0.65
      if sg != "0" {
        circle((xa, ym), radius: 0.5, fill: col.senal1.lighten(82%), stroke: none)
      } else {
        circle((xb, ym), radius: (0.48, 0.85), fill: col.naranja.lighten(85%), stroke: (paint: col.naranja, thickness: 0.5pt, dash: "dashed"))
      }
      wire((xa, top), (xb, top))
      wire((xa, bot), (xb, bot))
      capacitor("c" + str(k), (xa, top), (xa, bot))
      inductor("l" + str(k), (xb, top), (xb, bot))
      if sg == "+" {
        content((xa - 0.32, ym + 0.33), _i1-t(c: col.senal1)[*+*])
        content((xa - 0.32, ym - 0.33), _i1-t(c: col.senal1)[*−*])
      } else if sg == "-" {
        content((xa - 0.32, ym + 0.33), _i1-t(c: col.senal1)[*−*])
        content((xa - 0.32, ym - 0.33), _i1-t(c: col.senal1)[*+*])
      }
      if cur != 0 {
        let d = 0.3 * cur
        line((cx - d, top + 0.2), (cx + d, top + 0.2), stroke: 1pt + col.naranja, mark: (end: ">", fill: col.naranja, scale: 0.7))
        line((cx + d, bot - 0.2), (cx - d, bot - 0.2), stroke: 1pt + col.naranja, mark: (end: ">", fill: col.naranja, scale: 0.7))
        content((cx, top + 0.45), anchor: "south", _i1-t(c: col.naranja, s: 7pt)[$i$ máxima])
      } else {
        content((cx, top + 0.45), anchor: "south", _i1-t(c: col.gris, s: 7pt)[$i = 0$])
      }
      circle((cx - 1.2, top + 0.55), radius: 0.2, stroke: 0.5pt)
      content((cx - 1.2, top + 0.55), _i1-t(s: 7pt)[*#(k + 1)*])
      content((cx, bot - 0.42), anchor: "north", box(width: 3.2cm, align(center, _i1-t(s: 7pt, txt))))
    }
    // formas de onda alineadas con las fotos
    let y0 = 0.95
    let a = 0.8
    let xt(t) = 1.2 + 3.4 * t / (calc.pi / 2)
    line((0.8, y0), (15.5, y0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((15.5, y0), anchor: "north-east", padding: 3pt, _i1-t($t$))
    let pv = range(161).map(i => { let t = i * 2 * calc.pi / 160; (xt(t), y0 + a * calc.cos(t)) })
    let pi_ = range(161).map(i => { let t = i * 2 * calc.pi / 160; (xt(t), y0 + a * calc.sin(t)) })
    line(..pv, stroke: 1.1pt + col.senal1)
    line(..pi_, stroke: (paint: col.naranja, thickness: 1pt, dash: "dashed"))
    for k in range(4) {
      let t = k * calc.pi / 2
      line((xs.at(k), y0 - a - 0.1), (xs.at(k), y0 + a + 0.15), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dotted"))
      circle((xt(t), y0 + a * calc.cos(t)), radius: 0.055, fill: col.senal1, stroke: none)
      circle((xt(t), y0 + a * calc.sin(t)), radius: 0.055, fill: col.naranja, stroke: none)
    }
    content((14.9, y0 + a), anchor: "west", _i1-t(c: col.senal1)[$v_C$])
    content((13.5, y0 - a), anchor: "west", _i1-t(c: col.naranja)[$i$ (a trazos)])
  })
] <i1-fig-tanque>

#porque[
  - *El condensador* guarda la energía en su campo eléctrico, como carga en las placas. Solo, se descargaría de golpe por cualquier hilo.
  - *La bobina* guarda la energía en su campo magnético y, por su «inercia», no deja que la corriente cambie de golpe: cuando el condensador se ha vaciado, ella sigue empujando la corriente y lo recarga al revés. Sin bobina no habría oscilación, solo una descarga.
  - *Las pérdidas* (la resistencia del hilo, lo que se conecte al tanque) se llevan un poco de energía en cada vuelta: un tanque solo, sin nada que lo alimente, oscila cada vez menos hasta pararse.
]

#ptitulo[Por qué hay una sola frecuencia propia] Mira la @i1-fig-tanque[figura] y pregúntate qué decide la duración de cada foto. Un condensador _grande_ guarda mucha carga a una tensión dada: tarda más en vaciarse y en volver a llenarse. Una bobina _grande_ tiene mucha inercia: su corriente crece despacio y se resiste a pararse. Cuanto mayores son $L$ y $C$, más largo es el ciclo, y el cálculo da exactamente $T = 2 pi sqrt(L C)$, que es la fórmula de Thomson al revés ($f_0 = 1 slash T$). Es la misma cuenta que la de una masa colgada de un muelle: la bobina hace de _masa_ (inercia) y el condensador de _muelle blando_ (cuanto más capacidad, más «cede»). Una masa más pesada o un muelle más blando oscilan más despacio; una bobina mayor o un condensador mayor, también. Y como $L$ y $C$ no cambian durante la oscilación, el ritmo es uno y solo uno.

#ptitulo[Empujar al ritmo justo] Si un generador alimenta el tanque justo a $f_0$, cada empujón llega cuando la oscilación interna va en su mismo sentido: como el columpio empujado a tiempo, la energía se acumula ciclo a ciclo hasta que lo que se pierde en cada vuelta (en la resistencia del hilo) iguala lo que entra. Por eso dentro del circuito resonante circulan corrientes y tensiones $Q$ veces mayores que las aplicadas, como en el ejemplo de los 32~V. A cualquier otra frecuencia los empujones llegan unas veces a favor y otras en contra, y la oscilación nunca crece: el circuito «no se entera» de esa señal.

#circuito(caption: [La impedancia frente a la frecuencia (con $Q = 4$ para que se vea la forma). (a) El circuito serie tiene un mínimo en $f_0$, donde solo queda $R$: deja pasar mucha corriente a su frecuencia. (b) El tanque paralelo tiene un máximo en $f_0$: a su frecuencia es un muro, y sobre él se desarrolla tensión. Fuera de $f_0$ manda el componente de menor reactancia.], sim: "res-par.txt")[
  #cetz.canvas({
    import cetz.draw: *
    let w = 6.6
    let q = 4
    let uu(x) = 0.3 + x / (w - 0.4) * 1.9
    let x0 = (1 - 0.3) / 1.9 * (w - 0.4)
    // (a) serie
    group({
      ejes(0, w, 0, 3.3, etq-x: $f$)
      content((0, 3.35), anchor: "south", _i1-t($|Z|$))
      onda(x => { let u = uu(x); calc.min(3.0, 0.35 * calc.sqrt(1 + q * q * calc.pow(u - 1 / u, 2))) }, 0.32, w - 0.4, stroke: 1.2pt + col.senal1)
      line((x0, 0), (x0, 0.35), stroke: (thickness: 0.5pt, dash: "dashed"))
      content((x0, -0.05), anchor: "north", _i1-t($f_0$))
      content((x0 + 0.15, 0.25), anchor: "west", _i1-t[mínima: $Z = R$])
      content((0.95, 0.75), _i1-t(c: col.gris, s: 7pt)[capacitivo])
      content((4.9, 0.75), _i1-t(c: col.gris, s: 7pt)[inductivo])
      content((w / 2, -0.6), anchor: "north", _i1-t[(a) serie: mínimo en $f_0$])
    })
    // (b) paralelo
    group({
      set-origin((w + 1.2, 0))
      ejes(0, w, 0, 3.3, etq-x: $f$)
      content((0, 3.35), anchor: "south", _i1-t($|Z|$))
      onda(x => { let u = uu(x); 2.7 / calc.sqrt(1 + q * q * calc.pow(u - 1 / u, 2)) }, 0.2, w - 0.4, stroke: 1.2pt + col.naranja)
      line((x0, 0), (x0, 2.7), stroke: (thickness: 0.5pt, dash: "dashed"))
      content((x0, -0.05), anchor: "north", _i1-t($f_0$))
      content((x0 + 0.15, 2.85), anchor: "west", _i1-t[máxima])
      content((0.85, 2.2), _i1-t(c: col.gris, s: 7pt)[inductivo])
      content((5.0, 2.2), _i1-t(c: col.gris, s: 7pt)[capacitivo])
      content((w / 2, -0.6), anchor: "north", _i1-t[(b) paralelo (tanque): máximo en $f_0$])
    })
  })
] <i1-fig-serpar>

#align(center, table(
  columns: 3,
  align: (left, left, left),
  [], [*Circuito serie*], [*Circuito paralelo (tanque)*],
  [Impedancia en $f_0$], [mínima: vale $R$], [máxima],
  [Corriente del generador en $f_0$], [máxima], [mínima (la corriente circula dentro, entre $L$ y $C$)],
  [Por debajo de $f_0$], [capacitivo], [inductivo],
  [Por encima de $f_0$], [inductivo], [capacitivo],
  [Lo que se multiplica por $Q$], [las tensiones en $L$ y $C$], [las corrientes en $L$ y $C$],
  [Uso típico], [filtro de rechazo (atajo a masa para una frecuencia); la antena resonante], [sintonía; tanques de oscilador y de salida; trampas de antena],
))

#idea[En los dos casos la resonancia es lo mismo — $X_L = X_C$ y las reactancias se anulan, la impedancia se vuelve resistiva pura y la frecuencia la da la fórmula de Thomson —, pero el resultado visto desde fuera es el contrario. El serie es un *atajo* para su frecuencia; el paralelo, un *muro* para ella. Para sintonizar se usa casi siempre el muro: el tanque colocado entre la señal y masa.]

#circuito(caption: [El tanque como filtro de banda: una resistencia en serie (o la propia impedancia de la fuente) y el tanque $L C$ entre la señal y masa. A $f_0$ el tanque es un muro y toda la tensión aparece a la salida; a otras frecuencias es un atajo a masa y la salida cae. La salida en función de la frecuencia es la curva de respuesta de la @i1-fig-q[figura].], sim: "bandpass.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content
    acvsource("v", (0, 0), (0, 2.6), label: [señal])
    wire((0, 2.6), (0, 3), (0.6, 3))
    resistor("r", (0.6, 3), (2.6, 3), label: $R$)
    wire((2.6, 3), (6.2, 3))
    inductor("l", (3.6, 3), (3.6, 0), label: $L$, n: "*-*")
    capacitor("c", (5.0, 3), (5.0, 0), label: $C$, n: "*-*")
    wire((0, 0), (6.2, 0))
    node("o1", (6.2, 3), fill: false)
    node("o2", (6.2, 0), fill: false)
    content((6.45, 1.5), anchor: "west", align(left, _i1-t[salida:\ solo $f_0$]))
  })
] <i1-fig-tanque-filtro>

#porque[
  - $R$ y el tanque forman un divisor de tensión, como el filtro RC, pero ahora el componente de abajo es el tanque, cuya impedancia depende mucho de la frecuencia.
  - Por debajo de $f_0$ la bobina tiene poca reactancia y lleva la señal a masa; por encima, es el condensador el que la lleva a masa. En los dos casos casi toda la tensión se queda en $R$.
  - Justo en $f_0$ el tanque presenta su impedancia máxima: el divisor se inclina del lado de la salida y la señal pasa casi entera.
  - Sin $R$ no habría divisor: un tanque conectado directamente a un generador ideal tendría siempre la tensión del generador, a cualquier frecuencia. En una radio real ese papel lo hace la impedancia de la antena o de la etapa anterior.
]

La @i1-fig-galena[figura] lo muestra en el receptor más sencillo que funciona: la radio de galena, la más simple de todas — la montarás en el Taller —, que ya puedes leer entera. De todas las emisoras que la antena entrega a la vez, el tanque $L C$ solo desarrolla tensión para la que coincide con su $f_0$ — girar el condensador variable es mover $f_0$: es el _dial_ —; el diodo rectifica esa señal y el condensador de salida alisa los restos de RF (¡un paso bajo!: tercera aparición del mismo truco), dejando en el auricular la envolvente, que es la voz. Cuatro componentes, y los cuatro son de esta sección.

#circuito(caption: [La radio de galena completa, leída con las herramientas de esta sección: un circuito tanque que resuena en la emisora elegida (el condensador variable mueve $f_0$: es el dial), un diodo que rectifica y un filtro paso bajo que deja solo la envolvente en el auricular. No necesita pilas: toda la energía viene de la propia onda.], sim: "amdetect.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line, rect
    antenna("ant", (0, 3.2))
    content((0, 4.75), anchor: "south", _i1-t[antena])
    wire((0, 3.2), (0, 2.6), (4.4, 2.6))
    inductor("l", (0.9, 2.6), (0.9, 0), label: $L$, n: "*-")
    wire((0, 2.6), (0.9, 2.6))
    capacitor("c", (2.4, 2.6), (2.4, 0), variable: true, label: [$C$ (dial)], n: "*-")
    diode("d", (4.4, 2.6), (5.8, 2.6), label: (content: _i1-t(c: col.gris)[detector], anchor: "north"))
    wire((5.8, 2.6), (7.9, 2.6))
    capacitor("c2", (6.6, 2.6), (6.6, 0), n: "*-")
    rect((7.6, 0.85), (8.2, 1.75), stroke: 0.8pt, fill: white)
    wire((7.9, 2.6), (7.9, 1.75))
    wire((7.9, 0.85), (7.9, 0))
    content((8.35, 1.3), anchor: "west", _i1-t[auricular])
    wire((0.9, 0), (7.9, 0))
    ground("g", (0.9, 0))
    content((1.65, -0.85), anchor: "north", align(center, _i1-t(c: col.gris, s: 7pt)[tanque LC: elige la emisora\ (resonancia paralelo)]))
    content((6.9, -0.85), anchor: "north", align(center, _i1-t(c: col.gris, s: 7pt)[paso bajo: quita la RF,\ queda la envolvente (la voz)]))
  })
] <i1-fig-galena>

#porque[
  - *La antena* entrega a la vez la corriente de todas las emisoras que la alcanzan.
  - *El tanque $L C$* está entre la antena y masa. Para todas las frecuencias menos una es un camino fácil a masa (por la bobina las bajas, por el condensador las altas). Solo a su $f_0$ es un muro, y solo esa emisora deja tensión en lo alto del tanque. Girar $C$ cambia $f_0$: eso es sintonizar.
  - *El diodo* deja pasar solo los semiciclos positivos de esa RF: la señal deja de ser simétrica y su valor medio sigue a la envolvente.
  - *El condensador de salida* y el auricular forman un paso bajo: la RF (cientos de kHz) se va por el condensador; la voz (unos kHz) pasa al auricular. Sin él, el auricular recibiría pulsos de RF; sin el diodo, la media de la RF sería cero y no se oiría nada.
]

#ptitulo[El factor de calidad y el ancho de banda] Un tanque real no es infinitamente selectivo: su curva de respuesta es una campana centrada en $f_0$ cuya estrechez mide el mismo factor de calidad $Q$ de antes, ahora en su papel más útil: el *ancho de banda* entre los puntos de mitad de potencia es
$ B = f_0 / Q. $
Un $Q$ alto (pérdidas pequeñas) da una campana estrecha: mucha _selectividad_ para separar emisoras vecinas. El tema T3 vuelve sobre esta curva con detalle.

#circuito(caption: [(a) La curva de respuesta de un circuito sintonizado para dos factores de calidad. El ancho de banda $B$ se mide entre los puntos en que la tensión cae al 70,7~% (−3~dB): con $Q = 10$, $B$ es la décima parte de $f_0$; con $Q = 40$, cuatro veces más estrecho. (b) El mismo $Q$ visto en el tiempo: un tanque golpeado una vez sigue oscilando solo, y sus pérdidas lo van apagando. Con $Q$ alto «suena» muchos ciclos, como una campana buena; con $Q$ bajo se apaga enseguida.], sim: "ringing.txt")[
  #cetz.canvas({
    import cetz.draw: *
    let w = 6.5
    let h = 2.6
    let uu(x) = 0.8 + x / w * 0.4
    group({
      ejes(0, w + 0.3, 0, 3.4, etq-x: $f$)
      onda(x => h * _i1-res(uu(x), 10), 0.05, w, n: 240, stroke: 1.2pt + col.senal1)
      onda(x => h * _i1-res(uu(x), 40), 0.05, w, n: 400, stroke: (paint: col.senal2, thickness: 1pt, dash: "dashed"))
      line((0, h * 0.707), (w, h * 0.707), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dotted"))
      content((-0.05, h * 0.707), anchor: "east", _i1-t(s: 7pt)[0,707])
      content((-0.05, h), anchor: "east", _i1-t(s: 7pt)[1])
      let xa = (0.9512 - 0.8) / 0.4 * w
      let xb = (1.0512 - 0.8) / 0.4 * w
      line((xa, h * 0.707), (xb, h * 0.707), stroke: 0.6pt, mark: (start: ">", end: ">", fill: black, scale: 0.5))
      content((xb + 0.1, h * 0.707 + 0.08), anchor: "south-west", _i1-t[$B = f_0 slash Q$])
      line((w / 2, 0), (w / 2, h), stroke: (thickness: 0.4pt, dash: "dashed"))
      content((w / 2, -0.05), anchor: "north", _i1-t($f_0$))
      line((0.25, 3.15), (0.75, 3.15), stroke: 1.2pt + col.senal1)
      content((0.85, 3.15), anchor: "west", _i1-t[$Q = 10$])
      line((0.25, 2.8), (0.75, 2.8), stroke: (paint: col.senal2, thickness: 1pt, dash: "dashed"))
      content((0.85, 2.8), anchor: "west", _i1-t[$Q = 40$])
      content((w / 2, -0.55), anchor: "north", _i1-t[(a) curva de respuesta])
    })
    group({
      set-origin((w + 1.3, 0))
      let wr = 6.6
      let ncic = 10
      for (yb, q, etq) in ((2.45, 30, [$Q = 30$: sigue oscilando]), (0.75, 5, [$Q = 5$: se apaga enseguida])) {
        line((0, yb), (wr + 0.2, yb), stroke: 0.5pt, mark: (end: ">", fill: black, scale: 0.6))
        onda(x => { let n = x / wr * ncic; yb + 0.7 * calc.exp(-calc.pi * n / q) * calc.cos(2 * calc.pi * n) }, 0, wr, n: 500, stroke: 0.9pt + col.senal1)
        onda(x => { let n = x / wr * ncic; yb + 0.7 * calc.exp(-calc.pi * n / q) }, 0, wr, stroke: (paint: col.gris, thickness: 0.4pt, dash: "dashed"))
        content((wr, yb + 0.55), anchor: "east", _i1-t(s: 7pt, etq))
      }
      content((wr + 0.2, 0.75), anchor: "north-east", padding: 3pt, _i1-t($t$))
      content((wr / 2, -0.55), anchor: "north", _i1-t[(b) oscilación libre])
    })
  })
] <i1-fig-q>

#nota(titulo: [Qué mide exactamente $Q$])[
  $Q$ compara la energía que el circuito _guarda_ con la que _pierde_ en cada ciclo: $Q = 2 pi times ("energía almacenada") slash ("energía perdida por ciclo")$. Con $Q = 100$, en cada ciclo se pierde solo un 6~% de lo guardado, y el tanque golpeado sigue oscilando decenas de ciclos. En un circuito serie se calcula como $Q = X slash R$ (la reactancia de la bobina, o la del condensador, que en resonancia vale lo mismo, partida por la resistencia de pérdidas). Todo lo que se conecta a un tanque le roba energía y baja su $Q$: por eso las etapas que se le acoplan se conectan «flojas», con tomas en la bobina o con pocas espiras de acoplo. Una bobina de buena calidad en HF da $Q$ de 100 a 300; un cristal de cuarzo, de decenas a cientos de miles.
]

#ejercicio(sol: [$B = f_0 slash Q = 10^7 slash 100 = 100$~kHz. Vale (sobrado) para FM de 12~kHz; para SSB de 2,7~kHz es un portón: dejaría entrar varias emisoras a la vez — por eso las FI de SSB usan filtros de cuarzo, de $Q$ altísimo.])[
  El filtro de FI de un receptor está centrado en 10~MHz y tiene $Q = 100$. ¿Qué ancho de banda tiene? ¿Serviría para una emisión de SSB de 2,7 kHz? ¿Y para una de FM de 12 kHz?
]

#ejemplo(titulo: [Cuánto $Q$ hace falta en cada sitio])[
  - *Entrada del receptor de 40~m.* Un tanque a 7,1~MHz con $Q = 50$ deja pasar $B = 7,1 slash 50 approx 140$~kHz: toda la banda de 40~m (7,0 a 7,2~MHz) a la vez. No separa colegas, pero rechaza la radiodifusión potente de 6 o 9~MHz y otras señales fuera de banda. Es lo que se le pide: una preselección.
  - *Filtro de FI para SSB.* A 9~MHz y con $B = 2,7$~kHz hace falta $Q = 9 thin 000 slash 2,7 approx 3 thin 300$. Ninguna bobina llega a eso; un filtro de cristales de cuarzo, sí (#ver(<sec-cristal>)).
  - *Filtro de FI para FM de banda estrecha.* Con $B = 12$~kHz a 455~kHz basta $Q approx 38$: un par de tanques LC o un filtro cerámico.
  - La conclusión explica la arquitectura de todos los receptores: la selectividad fina se hace _una sola vez_, a una frecuencia fija (la FI), donde se puede usar el mejor filtro posible.
]

#ptitulo[Dónde viven los circuitos sintonizados] Con esta idea en la cabeza, abre cualquier transceptor y encontrarás circuitos resonantes en cuatro sitios (@i1-fig-sintonizados[figura]). Todos son la misma pareja $L C$ (o un cristal, que se comporta como una), con el $Q$ adecuado a su trabajo:

#circuito(caption: [Los circuitos sintonizados (en amarillo) dentro de un receptor superheterodino (arriba) y de un transmisor (abajo). Los números corresponden a la lista del texto: (1) entrada de RF, (2) filtro de FI, (3) tanque del oscilador y (4) tanque de salida del amplificador de potencia.])[
  #set text(size: 7.5pt)
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (3.2mm, 7mm),
    node((0, 0), text(size: 7.5pt)[Antena], stroke: none),
    edge("-|>"),
    _i1-bs((1, 0), [(1) Preselector\ LC]),
    edge("-|>"),
    _i1-bs((2, 0), [(1) Amp. RF\ sintonizado]),
    edge("-|>"),
    _i1-b((3, 0), [Mezclador]),
    edge("-|>"),
    _i1-bs((4, 0), [(2) Filtro FI\ (cristal)]),
    edge("-|>"),
    _i1-b((5, 0), [Amp. FI]),
    edge("-|>"),
    _i1-b((6, 0), [Detector]),
    edge("-|>"),
    _i1-b((7, 0), [Audio]),
    _i1-bs((3, 1), [(3) Oscilador local\ (tanque LC)]),
    edge((3, 1), (3, 0), "-|>"),
    _i1-bs((1, 2.5), [(3) Oscilador\ (VFO o cristal)]),
    edge("-|>"),
    _i1-b((2, 2.5), [Modulador\ y excitador]),
    edge("-|>"),
    _i1-b((3, 2.5), [Amp. de\ potencia]),
    edge("-|>"),
    _i1-bs((4, 2.5), [(4) Tanque de salida\ (red en pi)]),
    edge("-|>"),
    _i1-b((5, 2.5), [Filtro\ paso bajo]),
    edge("-|>"),
    node((6, 2.5), text(size: 7.5pt)[Antena], stroke: none),
  )
] <i1-fig-sintonizados>

+ *Entrada de RF* (preselector y amplificador de RF sintonizado). Deja pasar la banda que escuchas y rechaza las señales fuertes de otras bandas y la _frecuencia imagen_ del mezclador. $Q$ moderado, de unas decenas. Se construye en #ver(<sec-amp-sintonizado>).
+ *Filtro de FI*. La selectividad fina, a frecuencia fija: tanques LC para FM, filtros de cristal para SSB y CW. #ver(<sec-cristal>).
+ *Tanque del oscilador*. Fija la frecuencia del oscilador local del receptor y la de la portadora del transmisor; girar el condensador variable (o cambiar la tensión de un varicap) mueve el dial. #ver(<sec-oscilador>).
+ *Tanque de salida del amplificador de potencia*. Un amplificador de clase C entrega pulsos de corriente; el tanque los convierte otra vez en una sinusoide (el _efecto volante_: como el columpio, sigue oscilando entre empujón y empujón), deja fuera los armónicos y, de paso, adapta la impedancia a los 50~Ω de la antena. #ver(<sec-clases>) y #ver(<sec-redes-adaptacion>).

A estos cuatro se suman las _trampas_ de las antenas multibanda (tanques que aíslan un tramo del hilo a su frecuencia; es la pregunta T6.7) y, como verás enseguida, la propia antena: un dipolo es un circuito resonante hecho de un solo hilo.

#ojo[Lo que el banco pregunta de la resonancia cabe en cuatro frases. La condición de resonancia es $X_L = X_C$ (T3.1). En resonancia el circuito es *puramente resistivo* (T3.52) — mínimo en serie, máximo en paralelo, pero resistivo en los dos casos. El *cuadrado* de $f_0$ es inversamente proporcional a $L C$ (T3.30): más $L$ o más $C$ bajan la frecuencia. Y $Q = f_0 slash B$ (T3.2): a mayor $Q$, banda más estrecha.]

=== Adaptación: por qué todo es de 50~Ω <i1-sec-adaptacion>

#ptitulo[La máxima transferencia de potencia] Queda el último concepto del kit, y es el que más aparece en la práctica. Un generador real — un transmisor, una antena receptora, cualquier fuente — tiene una resistencia interna $R_g$ en serie con su fem. ¿A qué carga $R_L$ le sacamos el máximo partido? Los dos extremos fallan: con una carga enorme apenas circula corriente (mucha tensión, ningún amperio); con una carga minúscula la tensión se queda casi toda dentro, cayendo en $R_g$ (muchos amperios, ningún voltio en la carga). El máximo está en el punto medio exacto: *la carga recibe la máxima potencia cuando su resistencia iguala a la del generador*, $R_L = R_g$ (@i1-fig-maxpot[figura]). Es el teorema de máxima transferencia de potencia, y es el motivo de que exista un valor sagrado en radio: transmisor, cable y antena se diseñan todos para 50~Ω, de modo que cada eslabón entregue al siguiente toda la potencia posible (y, como se verá en el tema T6, para que la línea no sufra ondas estacionarias).

En alterna la adaptación tiene una segunda mitad: si la carga tiene parte reactiva, esa reactancia limita la corriente sin aprovechar nada (ya sabes: toma prestado y devuelve). Adaptar es entonces dos gestos: _cancelar la reactancia_ añadiendo la contraria — frente a una carga capacitiva, una bobina; frente a una inductiva, un condensador — y transformar la parte resistiva hasta los 50~Ω deseados. Eso, exactamente eso, es lo que hace un *acoplador de antena* con sus bobinas y condensadores ajustables. Y el ejemplo más bonito lo has visto ya sin saberlo: una antena más corta que su longitud de resonancia se comporta como resistencia _más condensador_ (le falta hilo para completar su vaivén); se corrige intercalando una bobina en serie que aporte la reactancia que falta — la *bobina de carga* que se ve a media altura en las antenas de coche. Una antena demasiado larga, al revés: parece inductiva y se compensa con capacidad (o cortando hilo).

#circuito(caption: [Máxima transferencia de potencia: la potencia que recibe la carga en función de su resistencia. Cargas muy pequeñas o muy grandes desperdician; el máximo está exactamente en $R_L = R_g$. De aquí nace el estándar de los 50~Ω de toda la cadena de radio.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    acvsource("e", (0, 0), (0, 2.6), label: $epsilon$)
    wire((0, 2.6), (0, 3), (0.8, 3))
    resistor("rg", (0.8, 3), (2.8, 3), label: [$R_g$ = 50~Ω])
    wire((2.8, 3), (4.2, 3))
    resistor("rl", (4.2, 3), (4.2, 0), label: $R_L$)
    wire((4.2, 0), (0, 0))
    line((3.5, -0.2), (3.5, 3.4), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dashed"))
    content((1.6, -0.3), anchor: "north", align(center, _i1-t(c: col.gris, s: 7pt)[generador con su\ resistencia interna]))
    content((4.3, -0.3), anchor: "north", _i1-t(c: col.gris, s: 7pt)[carga])
    // gráfica P(R_L)
    let x0 = 7.0
    let w = 6.2
    let sx = w / 6
    line((x0, 0), (x0 + w + 0.3, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    line((x0, 0), (x0, 3.2), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((x0 + w + 0.3, -0.05), anchor: "north-east", _i1-t($R_L$))
    content((x0 + 0.1, 3.2), anchor: "north-west", _i1-t[potencia en la carga])
    onda(x => { let r = (x - x0) / sx; 2.5 * 4 * r / calc.pow(1 + r, 2) }, x0, x0 + w, n: 200, stroke: 1.2pt + col.verde)
    line((x0 + sx, 0), (x0 + sx, 2.5), stroke: (thickness: 0.5pt, dash: "dashed"))
    content((x0 + sx, -0.05), anchor: "north", _i1-t[$R_L = R_g$])
    content((x0 + sx, 2.55), anchor: "south", _i1-t(c: col.verde)[máximo])
  })
] <i1-fig-maxpot>

#porque[
  - La corriente es $I = epsilon slash (R_g + R_L)$ y la potencia útil, $P = I^2 R_L$. Si $R_L$ es pequeña, la corriente es grande pero casi toda la tensión se queda en $R_g$; si es grande, la tensión llega a la carga, pero la corriente es minúscula.
  - El producto $I^2 R_L$ es máximo justo en el empate, $R_L = R_g$. En ese punto la carga recibe la mitad de la potencia que produce el generador; la otra mitad se queda en $R_g$.
  - Una reactancia en la carga solo resta: frena la corriente sin recibir potencia. Por eso adaptar empieza por anularla.
]

#ejemplo[Un generador de $epsilon = 10$~V con $R_g = 50$~Ω: con $R_L = 10$~Ω la carga recibe 0,28~W; con 25~Ω, 0,44~W; con 50~Ω, *0,50 W*; con 100~Ω, otra vez 0,44~W; con 200~Ω, 0,32~W. (Cuenta: con 50~Ω, $I = 10 slash 100 = 0,1$~A y $P = 0,1^2 dot 50 = 0,5$~W.) Fíjate en que equivocarse por un factor 2 en cualquier sentido cuesta solo un 11~%: la adaptación importa, pero no hace falta clavarla al ohmio.]

#nota[Un matiz, para no confundirse más adelante: el teorema habla de un generador con una resistencia interna fija. Un amplificador de potencia de transistores no es exactamente eso: se diseña para entregar su potencia nominal _a una carga de 50 Ω_, y no pierde la mitad dentro. La regla práctica es la misma: cada eslabón tiene que ver la carga para la que se diseñó. Las redes de bobinas y condensadores que hacen la transformación (en L, en pi, en T) se construyen en #ver(<sec-redes-adaptacion>). Una red en L que adapta 75~Ω a 300~Ω, en el simulador: #falstad("tlmatch1.txt").]

#ejercicio(sol: [Una _bobina en serie_ en la base (bobina de carga), con $X_L$ igual a la reactancia capacitiva que presenta la antena: se cancelan y la antena queda resonante, puramente resistiva de 20~Ω. Después aún hay que _transformar_ esos 20~Ω en los 50 del equipo — con un transformador, una red LC o las tomas de la propia bobina — para que la transferencia de potencia sea máxima.])[
  La antena de un vehículo, más corta que el cuarto de onda que le tocaría, presenta en su base 20~Ω de resistencia en serie con una reactancia capacitiva. ¿Qué componente añadirías, y cómo conectado, para llevarla a resonancia? ¿Qué queda por hacer después para que el transmisor de 50~Ω esté cómodo?
]

#ojo[La pregunta T1.31 del banco pide la condición de máxima transferencia de potencia: la impedancia de la carga igual a la del generador (en alterna, con las reactancias anuladas).]

=== En RF los componentes reales se desmandan <i1-sec-reales>

Un aviso final, que el temario pregunta como «comportamiento real de los componentes a altas frecuencias» (tema T3): ningún componente real es puro. Todo componente lleva de serie a los otros dos personajes: una resistencia tiene la inductancia de sus terminales y una pequeña capacidad entre sus extremos; una bobina tiene capacidad parásita entre espiras (que a cierta frecuencia la hace resonar ella sola); y un condensador tiene la inductancia de sus patas, de modo que por encima de su _frecuencia de autorresonancia_ se comporta… como una bobina (@i1-fig-creal[figura]). En HF estos matices apenas molestan; en VHF y UHF gobiernan el diseño: patas cortas, componentes pequeños, condensadores cerámicos específicos para RF. Cuando en el tema T3 leas estas advertencias, ya sabrás de dónde salen: de que $X_L = 2 pi f L$ crece con la frecuencia, y a 145~MHz hasta un centímetro de pata de componente tiene reactancia apreciable.

#circuito(caption: [Un condensador real: su capacidad $C$ va acompañada de la inductancia $L_s$ de las patas y de una pequeña resistencia de pérdidas $R_s$. Su impedancia (escalas logarítmicas) baja como la de un condensador hasta la frecuencia de autorresonancia $f_r$, donde $L_s$ y $C$ forman un circuito resonante serie y solo queda $R_s$; por encima, crece como la de una bobina. Valores del ejemplo: 100~nF y 5~nH.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    capacitor("c", (0, 1.6), (1.3, 1.6), label: $C$, n: "o-")
    inductor("l", (1.3, 1.6), (3.1, 1.6), label: $L_s$)
    resistor("r", (3.1, 1.6), (4.7, 1.6), label: $R_s$, n: "-o")
    content((2.35, 0.7), _i1-t(c: col.gris, s: 7pt)[lo que hay dentro de un «condensador»])
    // |Z| en escalas logarítmicas
    let x0 = 6.4
    let sx = 1.5
    let ly(z) = 1.4 + 0.95 * calc.log(z, base: 10)
    line((x0, 0), (x0 + 6.4, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    line((x0, 0), (x0, 3.3), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((x0 + 6.4, -0.05), anchor: "north-east", _i1-t($f$))
    content((x0 + 0.1, 3.3), anchor: "north-west", _i1-t($|Z|$))
    let zf(lf) = { let f = calc.pow(10, lf); let w = 2 * calc.pi * f; calc.sqrt(0.0025 + calc.pow(w * 5e-9 - 1 / (w * 1e-7), 2)) }
    onda(x => ly(zf(5 + (x - x0) / sx)), x0 + 0.05, x0 + 6.0, n: 300, stroke: 1.2pt + col.senal1)
    for (lf, t) in ((5, [100~kHz]), (6, [1~MHz]), (7, [10~MHz]), (8, [100~MHz]), (9, [1~GHz])) {
      let x = x0 + (lf - 5) * sx
      line((x, 0), (x, -0.08), stroke: 0.5pt)
      content((x, -0.12), anchor: "north", _i1-t(s: 6.5pt, t))
    }
    for (z, t) in ((0.1, [0,1~Ω]), (1, [1~Ω]), (10, [10~Ω])) {
      line((x0, ly(z)), (x0 - 0.08, ly(z)), stroke: 0.5pt)
      content((x0 - 0.12, ly(z)), anchor: "east", _i1-t(s: 6.5pt, t))
    }
    let xr = x0 + (calc.log(7.1e6, base: 10) - 5) * sx
    line((xr, 0), (xr, ly(0.05)), stroke: (thickness: 0.4pt, dash: "dashed"))
    content((xr + 0.1, 0.25), anchor: "west", _i1-t(s: 7pt)[$f_r approx 7$~MHz])
    content((x0 + 2.3, 2.9), _i1-t(c: col.senal1, s: 7pt)[se porta como condensador])
    content((x0 + 4.9, 2.9), _i1-t(c: col.senal1, s: 7pt)[como bobina])
  })
] <i1-fig-creal>

#porque[
  - $L_s$ y $R_s$ no son piezas añadidas: son la inductancia de las patas y de las placas, y las pérdidas del dieléctrico y de los contactos. Están dentro de cualquier condensador.
  - A baja frecuencia la reactancia de $C$ es grande y la de $L_s$ despreciable: manda el condensador.
  - En $f_r$, $L_s$ y $C$ forman un resonante serie y sus reactancias se anulan: el condensador es un cortocircuito casi perfecto, con solo $R_s$. Es la frecuencia a la que mejor desacopla.
  - Por encima de $f_r$ manda $X_L = 2 pi f L_s$, que crece con la frecuencia: el «condensador» ya es una bobina.
]

#ejemplo[Un condensador cerámico de 100~nF con patas normales tiene unos 5~nH de inductancia propia (como regla, un milímetro de hilo aporta del orden de 1~nH). Resuena en $f_r = 1 slash (2 pi sqrt(5 times 10^(-9) dot 10^(-7))) approx 7$~MHz. Como condensador de desacoplo en 2~m (145~MHz) ya no es un condensador: es una bobina de $X_L = 2 pi dot 145 times 10^6 dot 5 times 10^(-9) approx 4,6$~Ω, que encima crece con la frecuencia. Por eso en VHF se desacopla con condensadores pequeños (1~nF o 100~pF, que resuenan mucho más arriba) de patas cortísimas o de montaje superficial. Y un centímetro de pata, unos 10~nH, presenta a 145~MHz unos 9~Ω: ya no es «un cable».]

#soluciones-ejercicios()

Con esta caja de herramientas — reactancia, desfase, impedancia, resonancia, $Q$ y adaptación — el resto del capítulo se lee de otra manera: una antena es un circuito resonante hecho de un solo hilo, una línea de transmisión es una impedancia que hay que respetar, y sintonizar es elegir la $f_0$ de un tanque. Vamos con la antena.

== La antena: por qué un hilo radia <sec-antena>

#motivacion[Ya sabemos producir corriente de RF dentro de un equipo y llevarla por un cable. Pero un coaxial con 100~W de RF dentro apenas radia nada. ¿Qué tiene de especial un trozo de hilo para que él sí lo haga? ¿Y por qué las antenas tienen medidas tan concretas — unos 20~m de hilo para la banda de 40~m, medio metro para la de 2 m?]

#ptitulo[El puente entre el cable y el espacio] Dentro del equipo la señal viaja como corriente confinada en cables; en el espacio viaja como onda libre. La *antena* es la pieza que traduce lo uno en lo otro: obliga a los electrones a acelerar en un conductor abierto al aire, y esa aceleración radia (#ver(<sec-em>)). En recepción hace lo contrario: la onda que pasa mueve los electrones de la antena y genera una minúscula corriente que el receptor amplifica. Y aquí aparece un regalo de la física, el *principio de reciprocidad*: una antena _recibe_ igual de bien que _transmite_. Una buena antena de emisión es una buena antena de escucha; no hay que estudiarlas dos veces.

#ptitulo[De la línea a la antena] Una línea de transmisión no radia porque lleva dos corrientes iguales y opuestas muy juntas: en cada instante, lo que un conductor empuja hacia un lado el otro lo empuja hacia el contrario, y a cierta distancia sus campos se anulan. La energía viaja _guiada_ entre los dos hilos. Ahora abre el final de la línea: dobla cada hilo 90° hacia fuera, uno hacia arriba y otro hacia abajo (@i1-fig-dipolo-linea[figura]). En los tramos doblados las dos corrientes van en el _mismo_ sentido del espacio; sus campos ya no se anulan, se suman, y la energía se suelta como onda. Eso es un dipolo.

#circuito(caption: [(a) En una línea bifilar las corrientes de los dos hilos son opuestas y están muy juntas: sus campos se cancelan a distancia y la línea no radia. (b) Si se abre el último cuarto de onda de cada hilo, en los dos brazos la corriente va en el mismo sentido: los campos se suman y el conjunto radia. Los dos brazos de $lambda slash 4$ forman un dipolo de media onda.])[
  #cetz.canvas({
    import cetz.draw: *
    let fl(a, b, c) = line(a, b, stroke: 1pt + c, mark: (end: ">", fill: c, scale: 0.6))
    // (a)
    circle((0, 0), radius: 0.3, stroke: 0.7pt)
    onda(x => 0.1 * calc.sin(x * calc.pi / 0.18), -0.18, 0.18, stroke: 0.6pt)
    line((0, 0.3), (0, 0.35), (4.6, 0.35), stroke: 0.9pt)
    line((0, -0.3), (0, -0.35), (4.6, -0.35), stroke: 0.9pt)
    fl((1.6, 0.6), (2.5, 0.6), col.naranja)
    fl((2.5, -0.6), (1.6, -0.6), col.naranja)
    content((2.3, -1.0), anchor: "north", align(center, _i1-t(s: 7pt)[corrientes opuestas y juntas:\ los campos se anulan]))
    content((2.3, -2.3), anchor: "north", _i1-t[(a) línea: no radia])
    // (b)
    group({
      set-origin((7.4, 0))
      circle((0, 0), radius: 0.3, stroke: 0.7pt)
      onda(x => 0.1 * calc.sin(x * calc.pi / 0.18), -0.18, 0.18, stroke: 0.6pt)
      line((0, 0.3), (0, 0.35), (2.6, 0.35), (2.6, 2.4), stroke: 0.9pt)
      line((0, -0.3), (0, -0.35), (2.6, -0.35), (2.6, -2.4), stroke: 0.9pt)
      fl((2.9, 1.0), (2.9, 1.9), col.naranja)
      fl((2.9, -1.9), (2.9, -1.0), col.naranja)
      line((3.6, 0.35), (3.6, 2.4), stroke: 0.4pt, mark: (start: ">", end: ">", fill: black, scale: 0.4))
      line((3.6, -0.35), (3.6, -2.4), stroke: 0.4pt, mark: (start: ">", end: ">", fill: black, scale: 0.4))
      content((3.7, 1.4), anchor: "west", _i1-t($lambda slash 4$))
      content((3.7, -1.4), anchor: "west", _i1-t($lambda slash 4$))
      content((5.6, 0), anchor: "west", align(left, _i1-t(s: 7pt)[corrientes en el\ mismo sentido:\ los campos se suman\ y radian]))
      content((2.3, -2.6), anchor: "north", _i1-t[(b) dipolo: radia])
    })
  })
] <i1-fig-dipolo-linea>

#ptitulo[Por qué la longitud importa: resonancia] Si aplicas RF a un trozo de hilo, la corriente rebota en los extremos (no puede seguir, allí se acaba el metal) y se forma una *onda estacionaria*, igual que en una cuerda de guitarra. Cuando la longitud del hilo «encaja» con la longitud de onda, los rebotes se suman en fase y la antena *resuena*: acepta la energía con ganas y la radia con eficacia, y su impedancia se vuelve una resistencia pura, sin parte reactiva que estorbe — es la resonancia serie de #ver(<sec-resonancia>), hecha con un solo hilo cuya inductancia y capacidad están repartidas a lo largo del propio conductor. El caso patrón es el *dipolo de media onda* ($lambda slash 2$): en sus dos extremos la corriente está forzada a ser nula y en el centro alcanza su máximo, mientras la tensión hace justo lo contrario (@i1-fig-dipolo[figura]).

#ptitulo[Por qué precisamente media onda] Sigue a la corriente que sale del punto de alimentación hacia una punta. Recorre $lambda slash 4$, llega al final del hilo, rebota — y al rebotar cambia de signo, porque en un extremo abierto la corriente tiene que ser cero — y vuelve otros $lambda slash 4$. En total ha viajado media longitud de onda, es decir, medio ciclo de retraso; con el cambio de signo, un ciclo entero. La onda que vuelve llega al centro _en fase_ con la que el generador está empujando en ese momento, y las dos se suman. Es el columpio empujado a su ritmo: cada ciclo refuerza al anterior, y el generador solo tiene que reponer lo que se va radiado. Con otra longitud, la onda que vuelve llega desfasada, se opone en parte al generador, y en el punto de alimentación aparece una reactancia. (Una onda estacionaria se ve muy bien en el simulador, aunque en una línea en cortocircuito y no en una antena: #falstad("tlstand.txt").)

#circuito(caption: [Distribución de corriente y tensión a lo largo de un dipolo de media onda. La corriente (zona azul) es nula en las puntas y máxima en el centro; la tensión (a trazos) es máxima, y de signos opuestos, en las puntas, y casi nula en el centro. En el punto de alimentación hay mucha corriente y poca tensión: una impedancia baja, de unos 73~Ω.])[
  #cetz.canvas({
    import cetz.draw: *
    let L = 4.6
    let ip = range(81).map(i => { let x = -L + i * 2 * L / 80; (x, 1.25 * calc.cos(calc.pi * x / (2 * L))) })
    let im = ip.map(p => (p.at(0), -p.at(1))).rev()
    line(..ip, ..im, close: true, fill: col.senal1.lighten(80%), stroke: none)
    line(..ip, stroke: 1pt + col.senal1)
    line(..im, stroke: 1pt + col.senal1)
    onda(x => 1.15 * calc.sin(calc.pi * x / (2 * L)), -L, L, stroke: (paint: col.senal2, thickness: 1.1pt, dash: "dashed"))
    line((-L, 0), (-0.12, 0), stroke: 2pt)
    line((0.12, 0), (L, 0), stroke: 2pt)
    line((-0.12, 0), (-0.12, -1.7), stroke: 0.7pt)
    line((0.12, 0), (0.12, -1.7), stroke: 0.7pt)
    content((0.3, -1.6), anchor: "west", _i1-t(c: col.gris, s: 7pt)[a la línea])
    content((0, 1.35), anchor: "south", _i1-t(c: col.senal1)[$I$ máxima, $V approx 0$: $Z approx 73$~Ω])
    content((-L, 0.25), anchor: "south-east", align(right, _i1-t(s: 7pt)[$I = 0$\ $V$ máxima (−)]))
    content((L, 0.25), anchor: "south-west", align(left, _i1-t(s: 7pt)[$I = 0$\ $V$ máxima (+)]))
    content((L * 0.62, 1.15), anchor: "south-west", _i1-t(c: col.senal2, s: 7pt)[tensión])
    content((-L * 0.55, 1.0), anchor: "south-east", _i1-t(c: col.senal1, s: 7pt)[corriente])
    line((-L, -2.2), (L, -2.2), stroke: 0.5pt, mark: (start: ">", end: ">", fill: black, scale: 0.5))
    content((-L / 2, -2.25), anchor: "north", _i1-t($lambda slash 4$))
    content((L / 2, -2.25), anchor: "north", _i1-t($lambda slash 4$))
    line((0, -2.05), (0, -2.35), stroke: 0.5pt)
    content((0, -2.7), anchor: "north", _i1-t[longitud total $lambda slash 2$])
  })
] <i1-fig-dipolo>

#ptitulo[La antena como circuito resonante] Mírala con los ojos de #ver(<sec-resonancia>). La corriente que recorre el hilo crea campo magnético: el hilo tiene _inductancia_. Las dos puntas acumulan cargas opuestas: entre los dos brazos hay _capacidad_. Un dipolo es, por tanto, un circuito resonante serie con $L$ y $C$ repartidas, y su resistencia es la de radiación (más las pérdidas). Todo lo que ya sabes del circuito serie se traslada tal cual:

#align(center, table(
  columns: 3,
  align: (left, left, left),
  [*Longitud del dipolo*], [*Cómo se comporta*], [*Cómo se corrige*],
  [más corto que $lambda slash 2$], [capacitivo: $R$ pequeña más reactancia capacitiva (como un serie por debajo de $f_0$)], [bobina de carga en serie, o alargar],
  [exactamente resonante], [resistencia pura, unos 73~Ω], [nada: se conecta tal cual],
  [más largo que $lambda slash 2$], [inductivo (como un serie por encima de $f_0$)], [condensador en serie, o acortar],
))

#ptitulo[La resistencia que no calienta] Vista desde el transmisor, la antena parece una resistencia. Pero cuidado: la mayor parte de esa «resistencia» no disipa calor, sino que *contabiliza la potencia que escapa como onda*. Se la llama *resistencia de radiación* $R_r$ —para un dipolo de media onda vale unos 73~Ω—, y es una ficción utilísima: la potencia radiada es $P = I^2 R_r$, exactamente como si la antena fuera una resistencia normal. Junto a ella está la resistencia real de pérdidas $R_p$ (el hilo, la tierra), que sí se pierde en calor. El *rendimiento* de la antena es $eta = R_r slash (R_r + R_p)$: en un dipolo de HF, con $R_r approx 73$~Ω, unas pérdidas de pocos ohmios apenas cuentan; en una antena corta de coche, con $R_r$ de un par de ohmios, esas mismas pérdidas se comen media potencia.

#ptitulo[Por qué 73~Ω] La resistencia de radiación es, por definición, el número que hace cierta la cuenta $P = I^2 R_r$ con la corriente del punto de alimentación. Para conocerla hay que sumar lo que radia cada trocito de hilo con la corriente que lleva (la de la @i1-fig-dipolo[figura]); para un dipolo de media onda aislado en el espacio el resultado es 73~Ω. No hay atajo de bolsillo para ese número, pero sí para su tendencia: un hilo corto frente a $lambda$ radia poco por cada amperio, y su $R_r$ crece con el _cuadrado_ de la longitud. Una antena diez veces más corta que su media onda tiene una $R_r$ más o menos cien veces menor: por eso las antenas cortas de coche tienen solo unos ohmios. Cerca del suelo o con hilo grueso, el dipolo real se mueve entre unos 50 y 80~Ω; por eso se conecta directamente a un coaxial de 50~Ω con una desadaptación pequeña.

#ejemplo[
  - *Corriente en el centro.* Con 100~W en un dipolo resonante, $I = sqrt(P slash R_r) = sqrt(100 slash 73) approx 1,17$~A en el punto de alimentación.
  - *Rendimiento de una antena corta.* Con $R_r = 2$~Ω y 2~Ω de pérdidas (bobina, hilo, carrocería), $eta = 2 slash (2 + 2) = 50$~%: la mitad de la potencia calienta la antena.
  - *Medida real.* Para 7,1~MHz, $lambda slash 2 = 150 slash 7,1 approx 21,1$~m. En la práctica el dipolo resuena cortado un 5~% más corto, unos 20,1~m (la regla habitual es $L ("m") approx 143 slash f ("MHz")$), por el efecto de las puntas y el grosor del hilo.
]

#ptitulo[Alimentar donde conviene] Como la corriente es máxima en el centro del dipolo y la tensión máxima en los extremos, _dónde_ conectas la línea cambia la impedancia que ve el transmisor: en el centro, mucha corriente y poca tensión dan una impedancia baja (∼73~Ω, cómoda de adaptar a los 50~Ω de los equipos); en un extremo, poca corriente y mucha tensión dan miles de ohmios. Un *dipolo plegado* reparte la corriente en dos hilos y multiplica la impedancia por cuatro (∼300~Ω). Una *vertical de cuarto de onda* es medio dipolo puesto en pie: el suelo (o unos radiales) actúa de espejo y aporta la mitad que falta por reflexión, de modo que con solo $lambda slash 4$ de hilo se comporta como media onda, con una impedancia de unos 36~Ω y polarización vertical (@i1-fig-vertical[figura]).

#circuito(caption: [Vertical de cuarto de onda. El suelo conductor (o un juego de radiales) hace de espejo: la antena y su imagen forman juntas un dipolo de media onda. Pero solo radia la mitad de encima del suelo: con la misma corriente en la base, radia la mitad de potencia que el dipolo completo, y su resistencia de radiación es la mitad, unos 36~Ω.])[
  #cetz.canvas({
    import cetz.draw: *
    let h = 2.6
    let ip = range(41).map(i => { let y = i * h / 40; (0.8 * calc.cos(calc.pi * y / (2 * h)), y) })
    line((0, 0), ..ip, (0, h), close: true, fill: col.senal1.lighten(82%), stroke: none)
    line(..ip, stroke: 0.8pt + col.senal1)
    let im = ip.map(p => (p.at(0), -p.at(1)))
    line(..im, stroke: (paint: col.senal1, thickness: 0.6pt, dash: "dashed"))
    line((0, 0.25), (0, h), stroke: 2pt)
    line((0, -0.25), (0, -h), stroke: (thickness: 1.5pt, dash: "dashed", paint: col.gris))
    line((-2.6, 0), (2.6, 0), stroke: 1pt)
    for i in range(14) { let x = -2.5 + i * 0.38; line((x, 0), (x - 0.22, -0.22), stroke: 0.4pt) }
    circle((0, 0.12), radius: 0.12, fill: white, stroke: 0.6pt)
    content((1.0, -0.5), anchor: "west", _i1-t(s: 7pt)[alimentación en la base: $Z approx 36$~Ω])
    line((-1.0, 0.3), (-1.0, h), stroke: 0.4pt, mark: (start: ">", end: ">", fill: black, scale: 0.4))
    content((-1.1, h / 2 + 0.2), anchor: "east", _i1-t($lambda slash 4$))
    content((0.95, h * 0.55), anchor: "west", _i1-t(c: col.senal1, s: 7pt)[corriente])
    content((2.7, 0.15), anchor: "south-west", _i1-t(s: 7pt)[suelo o radiales: espejo])
    content((1.0, -h * 0.7), anchor: "west", _i1-t(c: col.gris, s: 7pt)[imagen: la mitad que «pone» el espejo])
  })
] <i1-fig-vertical>

#ptitulo[Concentrar el disparo: ganancia y directividad] Una antena sencilla radia parecido en muchas direcciones. Si añadimos elementos —como en la *Yagi*, con un reflector detrás y directores delante— la energía se reirradia y, por interferencia, se _concentra_ en una dirección a costa de las demás (@i1-fig-diagramas[figura]). Eso es la *directividad*. La *ganancia* es la directividad menos las pérdidas, y se cuenta en decibelios respecto a una referencia (dBi sobre la isótropa, dBd sobre el dipolo). Una antena no crea energía: con 10~W y 10~dBd de ganancia, en la dirección favorecida el enlace se comporta como si radiaras 100~W, pero a cambio de radiar mucho menos hacia los lados. Concentrar es el único modo honesto de «tener más potencia» sin encender un amplificador.

#circuito(caption: [Diagramas de radiación vistos desde arriba (dibujo esquemático). (a) El dipolo de media onda radia sobre todo perpendicular al hilo y nada a lo largo de él. (b) La Yagi concentra la energía en un lóbulo principal hacia los directores, a costa de los lados y de la parte de atrás. El círculo de puntos es la misma potencia radiada por igual en todas direcciones.])[
  #cetz.canvas({
    import cetz.draw: *
    let r0 = 1.6
    let polar(fr, cx, n: 180) = range(n + 1).map(i => { let a = i * 360deg / n; let r = fr(a); (cx + r * calc.cos(a), r * calc.sin(a)) })
    // (a) dipolo
    circle((0, 0), radius: 1.0, stroke: (paint: col.gris, thickness: 0.4pt, dash: "dotted"))
    let fdip(a) = { let s = calc.abs(calc.sin(a)); if s < 0.01 { 0 } else { r0 * calc.abs(calc.cos(calc.pi / 2 * calc.cos(a)) / s) } }
    line(..polar(fdip, 0), close: true, fill: col.senal1.lighten(80%), stroke: 1pt + col.senal1)
    line((-0.9, 0), (0.9, 0), stroke: 2pt)
    content((0, -1.95), anchor: "north", _i1-t[(a) dipolo: hilo horizontal en el dibujo])
    // (b) Yagi, máximo hacia la derecha
    let cx = 7.2
    circle((cx, 0), radius: 1.0, stroke: (paint: col.gris, thickness: 0.4pt, dash: "dotted"))
    let fy(a) = 2.6 * calc.pow((1 + calc.cos(a)) / 2, 4) + 0.35 * calc.pow((1 - calc.cos(a)) / 2, 4)
    line(..polar(fy, cx), close: true, fill: col.naranja.lighten(80%), stroke: 1pt + col.naranja)
    for (dx, l) in ((-0.45, 0.62), (0, 0.55), (0.4, 0.5), (0.8, 0.46)) { line((cx + dx, -l), (cx + dx, l), stroke: 1.4pt) }
    content((cx - 0.5, 0.8), anchor: "south", _i1-t(s: 6.5pt)[reflector])
    content((cx + 1.0, 0.65), anchor: "south-west", _i1-t(s: 6.5pt)[directores])
    content((cx + 2.6, 0.1), anchor: "south-west", _i1-t(s: 7pt)[lóbulo principal])
    content((cx + 0.3, -1.95), anchor: "north", _i1-t[(b) Yagi de cuatro elementos])
  })
] <i1-fig-diagramas>

#ojo[El banco insiste en tres ideas de esta sección. Una antena está en resonancia cuando la impedancia de su punto de alimentación es *resistiva pura* (T6.2), y por eso su circuito equivalente en resonancia es una resistencia (T6.21). El dipolo plegado tiene unas *cuatro veces* la impedancia del simple, unos 300~Ω (T6.6). Y la vertical de $lambda slash 4$ sobre buen suelo presenta unos 36~Ω, la mitad que el dipolo.]

Con esto ya tenemos las dos mitades del problema: sabemos hacer una onda (#ver(<sec-em>)) y sabemos lanzarla y capturarla (esta sección). Falta lo esencial: cómo montar la _información_ —la voz— sobre esa onda. Ahí entran la AM y la FM.

== AM: la voz en la amplitud <sec-am>

#ptitulo[Por qué no se radia la voz directamente] La voz humana son vibraciones de unos pocos kHz. Una antena que radiara 3~kHz de forma eficiente necesitaría kilómetros de largo ($lambda = 300 slash 0,003 = 100 thin 000$~m: ¡100~km — una antena de media onda mediría 50 km!), y además todo el mundo emitiría en la misma banda de audio y se pisarían. La solución es usar una onda de radio de frecuencia mucho más alta —la *portadora*— como caballo de carga, y hacer que la voz cabalgue sobre ella modificando alguno de sus parámetros. A eso se le llama *modular*. En la modulación de amplitud, la voz controla la *amplitud* de la portadora.

#ptitulo[Qué es exactamente una emisión de AM] Si la portadora es $cos(omega_c t)$ y la voz (para entenderlo, un tono puro) es $cos(omega_m t)$, la señal de AM es
$ s(t) = A [1 + m cos(omega_m t)] cos(omega_c t), $
donde $m$ (el *índice de modulación*) mide cuánto abre y cierra la voz la amplitud. El corchete es la *envolvente*: la silueta lenta que dibuja la voz sobre la portadora rápida (@i1-fig-am[figura]). _La envolvente es el mensaje_; todo lo demás es transporte.

// FALSTAD-CUSTOM: modulacion-am
#circuito(caption: [Una portadora modulada en amplitud por un tono, con tres índices de modulación. La envolvente (a trazos) copia el tono. Con $m = 0,5$ la amplitud oscila entre la mitad y vez y media de la portadora; con $m = 1$ (100~%) llega justo a cero en los valles; con $m > 1$ la envolvente ideal tendría que ser negativa, el transmisor la recorta, y la voz sale distorsionada.])[
  #cetz.canvas({
    import cetz.draw: *
    let w = 4.7
    let a = 0.55
    let nc = 16
    for (k, (m, etq)) in ((0.5, [$m = 0,5$]), (1.0, [$m = 1$ (100~%)]), (1.6, [$m = 1,6$: sobremodulación])).enumerate() {
      group({
        set-origin((k * (w + 0.55), 0))
        line((0, 0), (w + 0.15, 0), stroke: 0.4pt + col.gris)
        let env(x) = a * calc.max(0, 1 + m * calc.cos(2 * calc.pi * x / w))
        onda(x => env(x) * calc.cos(2 * calc.pi * nc * x / w), 0, w, n: 480, stroke: 0.7pt + col.senal1)
        onda(env, 0, w, stroke: (paint: col.senal2, thickness: 0.9pt, dash: "dashed"))
        onda(x => -env(x), 0, w, stroke: (paint: col.senal2, thickness: 0.9pt, dash: "dashed"))
        if m > 1 {
          onda(x => a * (1 + m * calc.cos(2 * calc.pi * x / w)), w * 0.25, w * 0.75, stroke: (paint: col.gris, thickness: 0.5pt, dash: "dotted"))
        }
        content((w / 2, -1.55), anchor: "north", _i1-t(etq))
      })
    }
  })
] <i1-fig-am>

#ptitulo[Cómo se mide $m$] En un osciloscopio se ve directamente la envolvente: llama $V_"máx"$ a la amplitud en sus crestas y $V_"mín"$ a la de sus valles. Como $V_"máx" = A(1 + m)$ y $V_"mín" = A(1 - m)$, restando y sumando sale
$ m = (V_"máx" - V_"mín") / (V_"máx" + V_"mín"). $
Por ejemplo, con crestas de 150~V y valles de 50~V, $m = 100 slash 200 = 0,5$: modulación del 50~%.

#ptitulo[Dónde vive la información: las bandas laterales] Desarrollando el producto con la identidad $cos a cos b = 1/2 [cos(a - b) + cos(a + b)]$ aparece algo revelador:
$ s(t) = underbrace(A cos(omega_c t), "portadora") + underbrace((m A) / 2 cos[(omega_c - omega_m) t], "banda lateral inferior") + underbrace((m A) / 2 cos[(omega_c + omega_m) t], "banda lateral superior"). $
El espectro son tres rayas: la portadora, que no lleva información ninguna, y dos *bandas laterales* a $f_c plus.minus f_m$, cada una con la voz completa (@i1-fig-espectro-am[figura]). La anchura ocupada es el doble de la frecuencia de audio más alta, $B = 2 f_m$ (unos 6~kHz para voz). Si empujamos $m$ por encima de 1 (*sobremodulación*) la envolvente se recorta, la voz se distorsiona y la emisión ensancha su espectro salpicando a los vecinos: por eso se vigila que $m$ no pase del 100~%.

#circuito(caption: [Espectros. (a) AM modulada por un tono: la portadora y dos rayas laterales a $f_c plus.minus f_m$, de amplitud $m A slash 2$ cada una (aquí $m = 1$). (b) AM modulada por la voz (300 a 3000~Hz): cada raya lateral se convierte en una banda; la inferior es la imagen invertida de la superior. (c) SSB (banda lateral superior): sin portadora y sin la banda inferior, la misma voz cabe en unos 2,7~kHz.])[
  #cetz.canvas({
    import cetz.draw: *
    let w = 4.6
    let base(etq) = {
      line((0, 0), (w, 0), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
      content((w, -0.05), anchor: "north-east", _i1-t($f$))
      content((w / 2, -0.75), anchor: "north", _i1-t(etq))
    }
    let c = w / 2
    // (a) tono
    group({
      base[(a) AM, un tono]
      line((c, 0), (c, 2.0), stroke: 2pt + col.senal1)
      line((c - 1.1, 0), (c - 1.1, 1.0), stroke: 2pt + col.senal2)
      line((c + 1.1, 0), (c + 1.1, 1.0), stroke: 2pt + col.senal2)
      content((c, 2.05), anchor: "south", _i1-t(s: 7pt)[portadora])
      content((c - 1.1, 1.05), anchor: "south", _i1-t(s: 7pt)[BLI])
      content((c + 1.1, 1.05), anchor: "south", _i1-t(s: 7pt)[BLS])
      content((c, -0.05), anchor: "north", _i1-t(s: 7pt)[$f_c$])
      content((c - 1.1, -0.05), anchor: "north", _i1-t(s: 6.5pt)[$f_c - f_m$])
      content((c + 1.1, -0.05), anchor: "north", _i1-t(s: 6.5pt)[$f_c + f_m$])
    })
    // (b) voz
    group({
      set-origin((w + 0.8, 0))
      base[(b) AM, voz]
      line((c, 0), (c, 2.0), stroke: 2pt + col.senal1)
      line((c + 0.15, 0), (c + 0.15, 0.25), (c + 1.5, 1.1), (c + 1.5, 0), close: true, fill: col.senal2.lighten(70%), stroke: 0.8pt + col.senal2)
      line((c - 0.15, 0), (c - 0.15, 0.25), (c - 1.5, 1.1), (c - 1.5, 0), close: true, fill: col.senal2.lighten(70%), stroke: 0.8pt + col.senal2)
      line((c - 1.5, 1.5), (c + 1.5, 1.5), stroke: 0.4pt, mark: (start: ">", end: ">", fill: black, scale: 0.4))
      content((c + 1.55, 1.5), anchor: "west", _i1-t(s: 7pt)[$B approx 6$~kHz])
      content((c, -0.05), anchor: "north", _i1-t(s: 7pt)[$f_c$])
    })
    // (c) SSB
    group({
      set-origin((2 * (w + 0.8), 0))
      base[(c) SSB (BLS)]
      line((c, 0), (c, 2.0), stroke: (paint: col.gris, thickness: 0.6pt, dash: "dotted"))
      content((c, 2.05), anchor: "south", _i1-t(c: col.gris, s: 7pt)[portadora suprimida])
      line((c + 0.15, 0), (c + 0.15, 0.25), (c + 1.5, 1.1), (c + 1.5, 0), close: true, fill: col.senal2.lighten(70%), stroke: 0.8pt + col.senal2)
      line((c + 0.15, 1.45), (c + 1.5, 1.45), stroke: 0.4pt, mark: (start: ">", end: ">", fill: black, scale: 0.4))
      content((c + 0.8, 1.5), anchor: "south", _i1-t(s: 7pt)[$approx 2,7$~kHz])
      content((c, -0.05), anchor: "north", _i1-t(s: 7pt)[$f_c$])
    })
  })
] <i1-fig-espectro-am>

#ptitulo[Cuánta potencia lleva cada raya] La potencia va con el cuadrado de la amplitud. Cada banda lateral tiene amplitud $m A slash 2$, así que lleva $m^2 slash 4$ de la potencia de la portadora; las dos juntas, $m^2 slash 2$. Incluso al 100~% ($m = 1$), las bandas laterales suman solo la mitad de la potencia de la portadora: de cada 150~W emitidos, 100~W van en la portadora y 25~W en cada banda.

#ojo[Un espectro con una portadora central y dos bandas laterales simétricas es la firma de la AM (T1.34): la FM tendría muchas bandas laterales y la SSB, una sola. Y cuidado con el nombre «índice de modulación»: en el banco (T5.12) se asocia a la FM, $m = Delta f slash f_m$; en AM se habla más bien de _porcentaje_ o _profundidad_ de modulación.]

#ptitulo[La cadena de transmisión] El transmisor de AM encadena: un *oscilador* estable que genera la portadora, un *modulador* donde la voz (amplificada) modula su amplitud, un *amplificador de potencia* que la sube al nivel de emisión y un *filtro de salida* que limpia los armónicos antes de entregarla a la antena (@i1-fig-tx-am[figura]). La antena la convierte en onda (#ver(<sec-antena>)) y la propagación la lleva al receptor (más de esto en los temas T5 y T7).

#circuito(caption: [Transmisor de AM por bloques. La voz, amplificada, controla en el modulador la amplitud de la portadora que fabrica el oscilador; el amplificador de potencia la sube de nivel y el filtro de salida quita los armónicos y adapta la impedancia a la antena.])[
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (5mm, 7mm),
    _i1-b((0, 0), [Micrófono]),
    edge("-|>"),
    _i1-b((1, 0), [Amp. de audio]),
    edge("-|>"),
    _i1-b((2, 0), [Modulador]),
    edge("-|>"),
    _i1-b((3, 0), [Amp. de potencia]),
    edge("-|>"),
    _i1-bs((4, 0), [Filtro de salida]),
    edge("-|>"),
    node((5, 0), text(size: 7.5pt)[Antena], stroke: none),
    _i1-bs((2, 1), [Oscilador (portadora)]),
    edge((2, 1), (2, 0), "-|>"),
  )
] <i1-fig-tx-am>

#porque[
  - *Oscilador*: un transistor que amplifica y se realimenta a sí mismo a través de un tanque LC o de un cristal; el tanque decide la frecuencia (#ver(<sec-oscilador>)).
  - *Modulador*: un circuito cuya ganancia depende de la tensión de audio, de modo que la amplitud de la RF sigue a la voz (#ver(<sec-modulador>)).
  - *Amplificador de potencia*: si la modulación se hace antes, en una etapa de poca potencia, todas las etapas siguientes tienen que ser _lineales_ (clase A o AB) para no deformar la envolvente; si se modula la propia etapa final (modulación de alto nivel), esa etapa puede trabajar en clase C (#ver(<sec-clases>)).
  - *Filtro de salida*: un paso bajo LC, normalmente una red en pi, que deja pasar $f_c$ y frena sus armónicos $2 f_c$, $3 f_c$… (#ver(<sec-redes-adaptacion>)).
]

#ptitulo[La cadena de recepción: el superheterodino] En el receptor la antena entrega una tensión diminuta —quizá un microvoltio— mezclada con miles de emisoras. Hay que hacer dos cosas: _elegir_ una y _amplificarla_ enormemente. Filtrar y amplificar con precisión a cualquier frecuencia es carísimo, así que Armstrong ideó un truco que gobierna casi todas las radios: el *superheterodino*. Un *oscilador local* y un *mezclador* trasladan la emisora elegida —sea cual sea su frecuencia— a una *frecuencia intermedia (FI)* fija, y allí, a una frecuencia siempre la misma, se ponen los mejores filtros y amplificadores de una vez para siempre. Sintonizar el dial no es más que mover el oscilador local para que la emisora deseada caiga en la FI.

// FALSTAD-CUSTOM: mezclador
#circuito(caption: [Receptor superheterodino por bloques, con los números de un receptor de HF típico. La emisora de 7,1~MHz y el oscilador local de 16,1~MHz entran en el mezclador; su diferencia, 9~MHz, es la FI, donde se hacen el filtrado fino y casi toda la amplificación. Para escuchar 7,15~MHz basta con subir el oscilador local a 16,15~MHz: la FI no cambia.])[
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (7.5mm, 8mm),
    node((0, 0), text(size: 7.5pt)[Antena], stroke: none),
    edge("-|>", label: text(size: 6.5pt)[7,1~MHz], label-side: left),
    _i1-bs((1, 0), [Amp. RF\ sintonizado]),
    edge("-|>"),
    _i1-b((2, 0), [Mezclador]),
    edge("-|>", label: text(size: 6.5pt)[9~MHz], label-side: left),
    _i1-bs((3, 0), [Filtro y\ amp. de FI]),
    edge("-|>"),
    _i1-b((4, 0), [Detector]),
    edge("-|>"),
    _i1-b((5, 0), [Amp. de\ audio]),
    edge("-|>"),
    _i1-b((6, 0), [Altavoz]),
    _i1-bs((2, 1), [Oscilador local]),
    edge((2, 1), (2, 0), "-|>", label: text(size: 6.5pt)[16,1~MHz], label-side: right),
  )
] <i1-fig-superhet>

#ptitulo[Qué hace el mezclador] La misma identidad trigonométrica de las bandas laterales: un mezclador _multiplica_ dos señales, y el producto de dos cosenos es la suma de otros dos, uno a la frecuencia diferencia y otro a la frecuencia suma. Con la emisora a 7,1~MHz y el oscilador a 16,1~MHz salen 9~MHz y 23,2~MHz; el filtro de FI se queda con los 9~MHz y la modulación viaja intacta, porque la envolvente no depende de la frecuencia que la lleve. La AM y el mezclador son, en el fondo, la misma operación. El circuito está en #ver(<sec-mezclador>). En el simulador, un modulador en anillo mezclando dos tonos: #falstad("ringmod.txt").

#ojo(titulo: [La frecuencia imagen])[Con el oscilador a 16,1~MHz, una señal a 25,1~MHz también da una diferencia de 9~MHz ($25,1 - 16,1 = 9$) y caería en la FI. Es la *frecuencia imagen*, a dos veces la FI de la deseada. El mezclador no la distingue: la tiene que rechazar antes el circuito sintonizado de la entrada. Otra vez la resonancia, haciendo de portero.]

#ptitulo[Recuperar la voz: el detector de envolvente] Ya amplificada la señal en la FI, falta deshacer la modulación. Y aquí la AM enseña su gran virtud: como _la envolvente es el mensaje_, basta con seguir esa envolvente. Un simple *diodo* deja pasar solo los semiciclos positivos (rectifica) y un condensador sigue las crestas: a la salida queda la silueta —la voz— sin la portadora (@i1-fig-detector[figura]). Es el *detector de envolvente*, y por eso una radio de galena funciona casi sin componentes. Un amplificador de audio la lleva al altavoz y se cierra el viaje: la voz ha vuelto a ser voz.

#circuito(caption: [El detector de envolvente y sus señales. El diodo deja pasar solo los semiciclos positivos; el condensador se carga hasta cada cresta y, entre una cresta y la siguiente, se descarga un poco a través de $R$. Su tensión sigue a la envolvente (a trazos), con un pequeño rizado de RF que el amplificador de audio ya no oye.], sim: "amdetect.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    node("in", (0, 2.6), fill: false)
    content((-0.1, 2.6), anchor: "east", _i1-t[FI])
    diode("d", (0, 2.6), (1.7, 2.6), label: $D$)
    wire((1.7, 2.6), (4.1, 2.6))
    capacitor("c", (2.4, 2.6), (2.4, 0.8), label: $C$, n: "*-*")
    resistor("r", (3.5, 2.6), (3.5, 0.8), label: $R$, n: "*-*")
    wire((0, 0.8), (4.1, 0.8))
    node("in2", (0, 0.8), fill: false)
    node("o1", (4.1, 2.6), fill: false)
    node("o2", (4.1, 0.8), fill: false)
    content((4.1, 2.85), anchor: "south", _i1-t[audio])
    ground("g", (1.2, 0.8))
    // señales
    let x0 = 7.0
    let w = 8.0
    let a = 0.55
    let m = 0.5
    let nc = 24
    let vin(t) = a * (1 + m * calc.cos(2 * calc.pi * t)) * calc.cos(2 * calc.pi * nc * t)
    let filas = ((4.0, [entrada (FI)]), (2.1, [tras el diodo]), (0.15, [en $C$: la voz]))
    for (yb, etq) in filas {
      line((x0, yb), (x0 + w + 0.2, yb), stroke: 0.4pt + col.gris)
      content((x0 - 0.1, yb + 0.3), anchor: "east", _i1-t(s: 7pt, etq))
    }
    onda(t => 4.0 + vin((t - x0) / w), x0, x0 + w, n: 900, stroke: 0.6pt + col.senal1)
    onda(t => 2.1 + calc.max(0, vin((t - x0) / w)), x0, x0 + w, n: 900, stroke: 0.6pt + col.senal1)
    let n = nc * 40
    let tau = 4 / nc
    let v = 0.0
    let pts = ()
    for i in range(n + 1) {
      let t = i / n
      let x = vin(t)
      if x > v { v = x } else { v = v * calc.exp(-(1 / n) / tau) }
      pts.push((x0 + t * w, 0.15 + v))
    }
    line(..pts, stroke: 1pt + col.verde)
    onda(t => 0.15 + a * (1 + m * calc.cos(2 * calc.pi * (t - x0) / w)), x0, x0 + w, stroke: (paint: col.senal2, thickness: 0.7pt, dash: "dashed"))
  })
] <i1-fig-detector>

#porque[
  - *El diodo* conduce solo cuando la tensión de entrada supera a la del condensador, es decir, cerca de cada cresta positiva. Sin él, el condensador se cargaría y descargaría con la RF y la media sería cero.
  - *El condensador* se carga rápidamente a través del diodo hasta el valor de la cresta y _guarda_ esa tensión entre una cresta y la siguiente: es lo que convierte una serie de picos en una curva continua.
  - *La resistencia* descarga poco a poco el condensador, para que la tensión pueda _bajar_ cuando baja la envolvente. Si $R C$ fuera demasiado grande, el condensador no podría seguir los valles de la voz; si fuera demasiado pequeño, se vaciaría entre ciclos de RF y quedaría mucho rizado.
  - El conjunto $R C$ es un paso bajo, como el de la @i1-fig-rc[figura]: deja pasar el audio y se come la RF.
]

#ejemplo[Con una FI de 455~kHz el periodo de la RF es de 2,2~μs, y la nota más aguda de la voz (3~kHz) tiene un periodo de 333~μs. La constante de tiempo $R C$ tiene que estar entre ambos, y no muy cerca de ninguno: con $R = 4,7$~kΩ y $C = 10$~nF, $R C = 47$~μs, unas veinte veces el periodo de la RF y unas siete veces menos que el de 3~kHz. El circuito con detalle está en #ver(<sec-detector>).]

#ojo[El detector de envolvente es el detector de la AM (T3.38) y no necesita ninguna referencia del transmisor: es *asíncrono* (T3.12). La SSB, en cambio, necesita que el receptor fabrique la portadora que falta.]

#ptitulo[La versión eficiente: SSB] La cuenta de la potencia incomoda: incluso al 100~% de modulación, dos tercios de la potencia se van en la portadora —que no lleva información— y el resto se reparte entre dos bandas laterales que dicen _lo mismo_. La *banda lateral única* (SSB, clase J3E) suprime la portadora y una de las bandas, y concentra toda la potencia en la única raya útil: misma información en la mitad de anchura (∼2,7~kHz) y con mucho mejor alcance. El precio es que el receptor, al faltarle la portadora, debe reinsertarla con un oscilador propio (el BFO) y un detector de producto. Por eso la SSB es la reina del DX en HF y la AM pura casi ha desaparecido de las bandas de aficionado.

#ptitulo[El detector de producto, por dentro] No es más que otro mezclador: multiplica la banda lateral por la señal del BFO, puesta donde estaba la portadora, y la diferencia de frecuencias devuelve la voz a su sitio, entre 300 y 3000~Hz. Si el BFO está desplazado unos cientos de hercios, la voz sale aguda o grave, como «de pato»: por eso los equipos de SSB tienen un mando fino de sintonía (#ver(<sec-mezclador>) y #ver(<sec-detector>)).

== FM: la voz en la frecuencia <sec-fm>

#ptitulo[La otra manera de montar la voz] En vez de mover la amplitud de la portadora, podemos dejarla constante y mover su *frecuencia instantánea* al ritmo de la voz: cuando la voz sube, la portadora se aparta un poco hacia arriba; cuando baja, hacia abajo (@i1-fig-fm[figura]). Es la *modulación de frecuencia*. Lo que la voz controla ahora es la *desviación* $Delta f$ —cuánto se aparta la portadora de su frecuencia central—, proporcional al volumen de la voz.

// FALSTAD-CUSTOM: modulacion-fm
#circuito(caption: [Modulación de frecuencia. Arriba, la señal moduladora (la voz, aquí un tono). Abajo, la portadora modulada: su amplitud no cambia nunca; lo que cambia es lo apretados que están los ciclos. Donde la moduladora es máxima, la frecuencia instantánea es $f_c + Delta f$; donde es mínima, $f_c - Delta f$.])[
  #cetz.canvas({
    import cetz.draw: *
    let w = 14.2
    let fc = 16
    let beta = 6
    line((0, 1.9), (w + 0.2, 1.9), stroke: 0.4pt + col.gris)
    onda(x => 1.9 + 0.55 * calc.sin(2 * calc.pi * x / w), 0, w, stroke: 1.1pt + col.senal2)
    content((0, 2.6), anchor: "west", _i1-t(c: col.senal2, s: 7pt)[señal moduladora (la voz)])
    line((0, 0), (w + 0.2, 0), stroke: 0.4pt + col.gris)
    onda(x => { let t = x / w; 0.7 * calc.cos(2 * calc.pi * fc * t - beta * calc.cos(2 * calc.pi * t)) }, 0, w, n: 1200, stroke: 0.7pt + col.senal1)
    content((w * 0.25, -0.85), anchor: "north", _i1-t(s: 7pt)[ciclos más juntos: $f_c + Delta f$])
    content((w * 0.75, -0.85), anchor: "north", _i1-t(s: 7pt)[ciclos más separados: $f_c - Delta f$])
    content((w + 0.25, 0.75), anchor: "south-east", _i1-t(c: col.senal1, s: 7pt)[amplitud constante])
  })
] <i1-fig-fm>

#ptitulo[Por qué la FM suena tan limpia] La mayoría del ruido eléctrico (chispas, motores, tormentas) contamina la _amplitud_ de las señales. En FM la información no está en la amplitud —que es constante—, así que el receptor puede recortar sin piedad todo lo que sobresalga, con un *limitador*, y borrar de un plumazo ese ruido antes de demodular. De ahí que la FM suene con ese silencio de fondo característico y sea la reina de la fonía local en VHF y UHF. Como añadido, al no importar la amplitud, el transmisor puede usar amplificadores no lineales de clase C, mucho más eficientes.

#ptitulo[El precio: anchura de banda] La FM no sale gratis. Una portadora modulada en frecuencia genera, en rigor, infinitas bandas laterales, y ocupa más espectro que la AM. La regla de Carson lo estima: $B approx 2 (Delta f + f_m)$. Por eso la FM de calidad vive en las bandas altas (VHF/UHF), donde el espectro sobra, y no en las estrechas bandas de HF.

#ptitulo[El índice de modulación de la FM] El cociente $beta = Delta f slash f_m$ es el *índice de modulación* de la FM, y decide cuántas bandas laterales importan (@i1-fig-espectro-fm[figura]). Con $beta$ pequeño (FM estrecha) solo cuentan la portadora y un par de rayas, y el espectro se parece al de la AM. Con $beta$ grande aparecen muchas rayas, separadas $f_m$ entre sí, y la potencia se reparte entre ellas: la amplitud total no cambia, solo se redistribuye.

#circuito(caption: [Espectro de una portadora modulada en FM por un tono. Las rayas están separadas $f_m$. (a) Con $beta = 0,5$ casi toda la potencia sigue en la portadora y solo cuentan dos bandas laterales. (b) Con $beta = 2$ la portadora ha perdido buena parte de su potencia a favor de varias rayas laterales; la regla de Carson, $B approx 2(Delta f + f_m) = 6 f_m$, abarca prácticamente todas las que importan.])[
  #cetz.canvas({
    import cetz.draw: *
    let w = 6.8
    let d = 0.62
    let espectro(js, etq, carson: false) = {
      let c = w / 2
      line((0, 0), (w, 0), stroke: 0.6pt, mark: (end: ">", fill: black, scale: 0.6))
      content((w, -0.05), anchor: "north-east", _i1-t($f$))
      for (n, j) in js.enumerate() {
        let col1 = if n == 0 { col.senal1 } else { col.senal2 }
        line((c + n * d, 0), (c + n * d, 2.4 * j), stroke: 2pt + col1)
        if n > 0 { line((c - n * d, 0), (c - n * d, 2.4 * j), stroke: 2pt + col1) }
      }
      content((c, -0.05), anchor: "north", _i1-t(s: 7pt)[$f_c$])
      if carson {
        line((c - 3 * d, 1.85), (c + 3 * d, 1.85), stroke: 0.4pt, mark: (start: ">", end: ">", fill: black, scale: 0.4))
        content((c + 3 * d + 0.08, 1.85), anchor: "west", _i1-t(s: 7pt)[Carson])
      }
      content((c, -0.55), anchor: "north", _i1-t(etq))
    }
    espectro((0.938, 0.242, 0.031), [(a) $beta = 0,5$: FM estrecha])
    group({
      set-origin((w + 0.9, 0))
      espectro((0.224, 0.577, 0.353, 0.129, 0.034), [(b) $beta = 2$], carson: true)
    })
  })
] <i1-fig-espectro-fm>

#ejemplo[
  - *FM de banda estrecha en 2~m.* Con desviación $Delta f = 2,5$~kHz y voz hasta $f_m = 3$~kHz, $B approx 2(2,5 + 3) = 11$~kHz: cabe en un canal de 12,5~kHz. (El índice es $beta = 2,5 slash 3 approx 0,8$.)
  - *Con $Delta f = 5$ kHz* (canales de 25~kHz): $B approx 2(5 + 3) = 16$~kHz.
  - *Radiodifusión de FM.* Con $Delta f = 75$~kHz y audio hasta 15~kHz: $B approx 2(75 + 15) = 180$~kHz, por eso cada emisora comercial necesita unos 200~kHz de espectro. Compáralo con los 6~kHz de la AM o los 2,7~kHz de la SSB.
]

#ptitulo[Las dos cadenas] En transmisión, la voz desvía un oscilador —típicamente un *VCO* con un varicap que cambia de frecuencia según la tensión de audio—, se amplifica y se radia. En recepción, tras el superheterodino (idéntico al de AM: mezclador, FI) viene primero el *limitador* que iguala la amplitud y borra el ruido, y luego el *discriminador* (o detector de FM), que convierte las variaciones de frecuencia otra vez en variaciones de tensión —en voz— (@i1-fig-cadenas-fm[figura]). Un detalle bonito de la FM es el *efecto captura*: si dos estaciones coinciden en el canal, el receptor engancha por completo la más fuerte y silencia la débil, en vez de oírlas mezcladas como haría la AM.

#circuito(caption: [Transmisor y receptor de FM por bloques. En el transmisor la voz mueve la frecuencia de un VCO y, como la amplitud no importa, el amplificador final puede ser de clase C. En el receptor, tras un superheterodino igual que el de AM, el limitador recorta la amplitud (y con ella el ruido) y el discriminador convierte la frecuencia en tensión.])[
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (4.2mm, 6mm),
    _i1-b((0, 0), [Micrófono]),
    edge("-|>"),
    _i1-b((1, 0), [Amp. de audio]),
    edge("-|>"),
    _i1-bs((2, 0), [VCO\ (tanque + varicap)]),
    edge("-|>"),
    _i1-b((3, 0), [Amp. clase C]),
    edge("-|>"),
    _i1-bs((4, 0), [Filtro de salida]),
    edge("-|>"),
    node((5, 0), text(size: 7.5pt)[Antena], stroke: none),
    node((0, 1), text(size: 7.5pt)[Antena], stroke: none),
    edge("-|>"),
    _i1-b((1, 1), [Superheterodino\ (amp. RF, mezclador, FI)]),
    edge("-|>"),
    _i1-b((2, 1), [Limitador]),
    edge("-|>"),
    _i1-bs((3, 1), [Discriminador]),
    edge("-|>"),
    _i1-b((4, 1), [Amp. de audio]),
    edge("-|>"),
    _i1-b((5, 1), [Altavoz]),
  )
] <i1-fig-cadenas-fm>

#ptitulo[Cómo se fabrica la FM: el VCO] Un oscilador LC oscila a la $f_0 = 1 slash (2 pi sqrt(L C))$ de su tanque. Si una parte de esa capacidad es un *varicap* — un diodo polarizado al revés cuya capacidad depende de la tensión que se le aplica —, la tensión de audio cambia $C$, y con ella la frecuencia. Como $f_0$ va con $1 slash sqrt(C)$, un cambio pequeño de capacidad mueve la frecuencia la mitad en proporción: si el audio varía $C$ un 0,1~%, un oscilador de 10~MHz se desvía un 0,05~%, es decir, 5~kHz. Otra vez la fórmula de Thomson, ahora como modulador. El circuito completo está en #ver(<sec-oscilador>) y #ver(<sec-modulador>). En el simulador, un VCO con varicaps: #falstad("varactorvco.txt").

#ptitulo[Cómo se deshace: el discriminador] La idea más sencilla vuelve a usar la resonancia. Sintoniza un tanque un poco _por encima_ de la portadora, de modo que esta caiga en el flanco de su curva de respuesta (@i1-fig-pendiente[figura]). Cuando la frecuencia sube, se acerca al pico y la salida crece; cuando baja, se aleja y la salida cae: las variaciones de frecuencia se han convertido en variaciones de amplitud, que un detector de envolvente ya sabe leer. Los discriminadores reales (de Foster-Seeley, de relación, de cuadratura, o un PLL) son refinamientos de esta idea con mejor linealidad; están en #ver(<sec-detector>).

#circuito(caption: [Detección de FM por pendiente. La portadora $f_c$ se coloca en el flanco de la curva de un circuito sintonizado a $f_0$. Cuando la frecuencia de entrada oscila $plus.minus Delta f$ (abajo), la amplitud de salida oscila arriba y abajo (izquierda): la curva convierte frecuencia en amplitud.])[
  #cetz.canvas({
    import cetz.draw: *
    let w = 7.0
    let h = 2.8
    let q = 8
    let uu(x) = 0.75 + x / w * 0.5
    let xu(u) = (u - 0.75) / 0.5 * w
    ejes(0, w + 0.3, 0, 3.4, etq-x: $f$, etq-y: [amplitud])
    onda(x => h * _i1-res(uu(x), q), 0.02, w, n: 300, stroke: 1.2pt + col.senal1)
    let uc = 0.92
    let u1 = 0.90
    let u2 = 0.94
    let xc = xu(uc)
    let x1 = xu(u1)
    let x2 = xu(u2)
    let y1 = h * _i1-res(u1, q)
    let y2 = h * _i1-res(u2, q)
    let yc = h * _i1-res(uc, q)
    line((xc, 0), (xc, yc), stroke: (thickness: 0.5pt, dash: "dashed"))
    line((x1, 0), (x1, y1), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dotted"))
    line((x2, 0), (x2, y2), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dotted"))
    line((x1, y1), (0, y1), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dotted"))
    line((x2, y2), (0, y2), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dotted"))
    circle((xc, yc), radius: 0.06, fill: col.senal2, stroke: none)
    line((x1, -0.45), (x2, -0.45), stroke: 0.7pt + col.senal2, mark: (start: ">", end: ">", fill: col.senal2, scale: 0.45))
    content((xc, -0.6), anchor: "north", _i1-t(c: col.senal2, s: 7pt)[$f_c plus.minus Delta f$ (entrada)])
    line((-0.35, y1), (-0.35, y2), stroke: 0.7pt + col.verde, mark: (start: ">", end: ">", fill: col.verde, scale: 0.45))
    content((-0.45, (y1 + y2) / 2), anchor: "east", align(right, _i1-t(c: col.verde, s: 7pt)[variación de\ amplitud (salida)]))
    line((w / 2, 0), (w / 2, h), stroke: (paint: col.gris, thickness: 0.4pt, dash: "dashed"))
    content((w / 2, -0.05), anchor: "north", _i1-t($f_0$))
    line((xc + 0.05, yc - 0.05), (xc + 1.3, 0.75), stroke: 0.4pt + col.senal2)
    content((xc + 1.35, 0.7), anchor: "north-west", _i1-t(c: col.senal2, s: 7pt)[portadora en el flanco])
  })
] <i1-fig-pendiente>

#ojo[De esta sección el banco toma sobre todo la anchura de banda (Carson, $B approx 2(Delta f + f_m)$), el índice de modulación $Delta f slash f_m$ (T5.12) y la ventaja frente al ruido: como la información no va en la amplitud, el limitador elimina el ruido de amplitud. Recuerda también el reparto de clases: la FM tolera amplificadores de clase C; la AM modulada antes del final y la SSB necesitan amplificadores lineales.]

== El cuadro completo <sec-cuadro>

Repasa ahora la cadena entera con los nombres puestos (@i1-fig-cadena[figura]). En el transmisor: la voz _modula_ (en amplitud para AM/SSB, en frecuencia para FM) una _portadora_ generada por un _oscilador_; un _amplificador_ la sube de nivel y un _filtro_ la limpia; la _antena_ convierte esa corriente de RF en una _onda electromagnética_ (campos $arrow(E)$ y $arrow(B)$ que se sostienen y viajan a $c$), que la _propagación_ —onda de tierra, visión directa o rebote en la ionosfera— lleva hasta el otro extremo. Allí, otra _antena_ recoge una parte diminuta; el _superheterodino_ la traslada a la _FI_ fija, donde se filtra y amplifica; y un _detector_ —de envolvente para AM, de producto para SSB, discriminador tras limitador para FM— recupera la voz, que un _amplificador de audio_ entrega al _altavoz_.

#circuito(caption: [La cadena completa, de la voz a la voz. Arriba, el transmisor; a la derecha, el viaje de la onda; abajo, el receptor, que se recorre de derecha a izquierda. En amarillo, los bloques que dependen de circuitos resonantes. La fuente de alimentación da a todos ellos su tensión continua.])[
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (4.5mm, 8mm),
    _i1-b((0, 0), [Micrófono]),
    edge("-|>"),
    _i1-b((1, 0), [Amp. de\ audio]),
    edge("-|>"),
    _i1-b((2, 0), [Modulador]),
    edge("-|>"),
    _i1-b((3, 0), [Amp. de\ potencia]),
    edge("-|>"),
    _i1-bs((4, 0), [Filtro y\ adaptación]),
    edge("-|>"),
    _i1-b((5, 0), [Antena TX]),
    _i1-bs((2, 1), [Oscilador]),
    edge((2, 1), (2, 0), "-|>"),
    edge((5, 0), (5, 2), "--|>", label: text(size: 7pt)[propagación:\ onda de tierra,\ visión directa,\ ionosfera], label-side: left),
    _i1-b((5, 2), [Antena RX]),
    edge("-|>"),
    _i1-bs((4, 2), [Amp. RF\ sintonizado]),
    edge("-|>"),
    _i1-b((3, 2), [Mezclador]),
    edge("-|>"),
    _i1-bs((2, 2), [Filtro y\ amp. de FI]),
    edge("-|>"),
    _i1-b((1, 2), [Detector]),
    edge("-|>"),
    _i1-b((0, 2), [Amp. de\ audio]),
    edge("-|>"),
    _i1-b((0, 3), [Altavoz]),
    _i1-bs((3, 3), [Oscilador local]),
    edge((3, 3), (3, 2), "-|>"),
    _i1-b((5, 3), [Fuente de alimentación\ (a todas las etapas)], stroke: (paint: col.gris, dash: "dashed", thickness: 0.7pt)),
  )
] <i1-fig-cadena>

Cada bloque de la figura es un circuito concreto que se construye, pieza a pieza, en el capítulo siguiente:

- *Amplificador de audio del transmisor*: sube la tensión del micrófono. Circuito: amplificador de emisor común, #ver(<sec-amplificador-ec>).
- *Oscilador*: fabrica la portadora, estable. Circuito: transistor realimentado a través de un tanque LC o de un cristal, #ver(<sec-oscilador>) y #ver(<sec-cristal>).
- *Modulador*: imprime la voz en la portadora. Circuito: modulador de AM, mezclador equilibrado (SSB) o VCO con varicap (FM), #ver(<sec-modulador>).
- *Amplificador de potencia*: sube la RF a decenas o cientos de vatios. Circuito: amplificador de clase A, AB o C según el modo, #ver(<sec-clases>).
- *Filtro y adaptación de salida*: quita los armónicos y presenta 50~Ω al cable. Circuito: red en pi o filtro paso bajo LC, #ver(<sec-redes-adaptacion>).
- *Antenas*: convierten corriente en onda y onda en corriente. Dipolo, vertical, Yagi: #ver(<sec-antena>).
- *Amplificador de RF sintonizado*: preselección y primera ganancia. Circuito: amplificador con un tanque LC en el colector, #ver(<sec-amp-sintonizado>).
- *Mezclador y oscilador local*: trasladan la emisora a la FI. Circuito: mezclador (un multiplicador), #ver(<sec-mezclador>).
- *Filtro y amplificador de FI*: selectividad y ganancia a frecuencia fija. Circuito: filtro de cristal y amplificador sintonizado, #ver(<sec-cristal>).
- *Detector*: recupera la voz. Circuito: diodo y RC (AM), detector de producto (SSB) o discriminador (FM), #ver(<sec-detector>).
- *Amplificador de audio del receptor*: da potencia para el altavoz. Circuito: amplificador de audio en clase AB, #ver(<sec-clases>).
- *Fuente de alimentación*: da a cada etapa su tensión continua. Circuito: transformador, rectificador, filtro y regulador, #ver(<sec-fuente>).

Y todas las piezas juntas, en una radio completa que se puede seguir con el dedo, en #ver(<sec-radio-entera>).

Tres decisiones de diseño resumen las diferencias:

- *AM* es la más sencilla de recibir (un diodo basta), pero derrocha potencia en la portadora y es sensible al ruido de amplitud.
- *SSB* exprime la AM: suprime portadora y una banda, gana alcance y estrecha la emisión; domina el DX en HF a cambio de un receptor más fino.
- *FM* cambia anchura de banda por inmunidad al ruido y buena calidad de audio; reina en VHF/UHF y en los repetidores locales.

Con este mapa en la cabeza, cada tema del programa deja de ser una lista suelta y se convierte en el zoom sobre una pieza concreta de esta misma cadena. Eso es exactamente lo que hacen los temas T1 a T10 que vienen a continuación.
