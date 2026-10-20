// Tema T1 — Teoría de la electricidad, el electromagnetismo y la radio
// Fuente: páginas físicas 37–48 (teoría y preguntas) y 329–332 (soluciones D.1).
// Modo EXPAND: se conserva todo el original y se añaden motivación, figuras,
// ejemplos y trampas de examen.
#import "/lib/template.typ": *
#import "/lib/falstad-custom.typ": fc
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Utilidades locales de dibujo (prefijo _t1-)
// ---------------------------------------------------------------------
#let _t1-t(c, ..a) = text(size: 8pt, ..a, c)
#let _t1-flecha = (mark: (end: ">", fill: black, scale: 0.6), stroke: 0.5pt)
#let _t1-flecha-i = (mark: (end: ">", fill: col.senal2, scale: 0.6), stroke: 0.7pt + col.senal2)
#let _t1-cota = (mark: (start: ">", end: ">", fill: black, scale: 0.6), stroke: 0.5pt)
#let _t1-guia = (stroke: (paint: col.gris, thickness: 0.4pt, dash: "dotted"))
#let _t1-panel(etq, cuerpo) = align(center + bottom, stack(spacing: 0.6em, cuerpo, text(size: 8.5pt, etq)))
#let _t1-borne(p) = cetz.draw.circle(p, radius: 0.07, fill: white, stroke: 0.6pt)

#tema("T1", "Teoría de la electricidad, el electromagnetismo y la radio", alcance: [Conductividad y leyes fundamentales (Ohm, Kirchhoff) · fuentes de alimentación · campos eléctrico, magnético y electromagnético · señales sinusoidales y no sinusoidales · señales moduladas (CW, AM, SSB, FM y modulación digital) · potencia, energía y decibelios · procesado digital de señales (DSP).])

#motivacion(titulo: [Por qué empieza aquí el temario])[
Todo lo que pasa en una estación de radio se describe con media docena de magnitudes: la fuente que alimenta el equipo (tensión, corriente), el cable que la lleva (resistencia), lo que consume y lo que radia (potencia), y la señal que sale por la antena (frecuencia, amplitud, fase). Este tema las fija con precisión, porque el resto del temario las da por sabidas. Las preguntas son casi siempre directas: una unidad, una fórmula, un cálculo de una línea. Lo que penaliza el examen es confundir dos cosas parecidas: valor eficaz y valor medio, 3 dB y 6 dB, serie y paralelo. Si quieres la versión larga e intuitiva de los campos y las ondas, léela en #ver(<sec-em>).
]

== Unidades y leyes fundamentales <t1-sec-unidades>

#motivacion[
Un transceptor de HF de 100 W se alimenta con 13,8 V y pide unos 20 A al transmitir. ¿Qué cable hace falta? ¿Cuánto calor se pierde por el camino? ¿Qué tensión llega de verdad al equipo? Para responder solo hacen falta tres magnitudes —tensión, corriente y resistencia— y la ley que las une.
]

=== Carga, corriente y tensión

La magnitud primitiva es la *carga* $q$, medida en culombios (C). Una corriente es carga en movimiento: $I = d q slash d t$, y un amperio es un culombio por segundo. En un *conductor* hay electrones libres que se desplazan bajo un campo aplicado; en un *aislante* no los hay, y un *semiconductor* está a medio camino, con una conductividad que además se puede dopar y controlar — de ahí toda la electrónica del tema T2.

La *tensión* entre dos puntos es energía por unidad de carga: $V = W slash q$, en julios por culombio, es decir, voltios. La *ley de Ohm* establece que en un conductor óhmico la corriente es proporcional a la tensión aplicada,
$ V = I dot R, $
donde $R$ (ohmios, Ω) es la resistencia.

#analogia[
Piensa en un circuito de agua. La pila es una bomba que crea una *diferencia de presión*: la tensión. El caudal de agua que circula es la *corriente*. Una tubería estrecha frena el paso: es la *resistencia*. Con más presión pasa más caudal; con una tubería más estrecha, menos. Eso es exactamente $I = V slash R$. Y la carga es el agua misma: la bomba no la crea ni la gasta, solo la empuja en círculo. Lo que la bomba entrega es *energía*, y la tubería estrecha la convierte en calor.
]

#circuito(caption: [Cómo se mide la ley de Ohm. El amperímetro (A) va *en serie*, para que lo atraviese la misma corriente que a la resistencia; el voltímetro (V) va *en paralelo*, para medir la tensión entre sus extremos. Con 12 V y $R = 6 "Ω"$, el amperímetro marca 2 A.], sim: "ohms.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    bateria("b1", (0, 3), (0, 0))
    content((-0.4, 1.5), anchor: "east", _t1-t[12 V])
    wire((0, 3), (0.8, 3))
    medidor("am", (0.8, 3), (2.6, 3), letra: "A")
    wire((2.6, 3), (3.4, 3))
    resistor("r1", (3.4, 3), (3.4, 0), label: $R = 6 "Ω"$)
    wire((3.4, 0), (0, 0))
    wire((3.4, 3), (6.0, 3))
    medidor("vm", (6.0, 3), (6.0, 0), letra: "V")
    wire((6.0, 0), (3.4, 0))
    node("n1", (3.4, 3))
    node("n2", (3.4, 0))
    line((1.2, 2.55), (2.2, 2.55), .._t1-flecha-i)
    content((1.7, 2.45), anchor: "north", _t1-t(fill: col.senal2)[$I = 2$ A])
  })
] <t1-fig-ohm>

#porque[
- La pila mantiene una diferencia de potencial $V$ entre sus bornes: cada culombio que sale por el borne $+$ lleva 12 julios de energía.
- La corriente solo circula si el camino está cerrado: borne $+$, amperímetro, resistencia y vuelta al borne $-$. Abre el circuito en cualquier punto y la corriente es cero en todo él.
- En la resistencia los electrones chocan con la red del metal y ceden esa energía en forma de calor. La corriente se ajusta sola hasta que la caída en $R$ iguala la tensión de la pila: $I = V slash R = 12 slash 6 = 2$ A.
- Un amperímetro ideal tiene resistencia nula (no altera la corriente que mide) y un voltímetro ideal, resistencia infinita (no desvía corriente). Por eso un amperímetro conectado directamente entre los bornes de la pila es un cortocircuito: no lo hagas nunca.
]

=== Resistencia y resistividad

Para un conductor concreto, esa resistencia vale $R = rho l slash S$: crece con la longitud $l$, decrece con la sección $S$, y la resistividad $rho$ es una propiedad de cada material — un hilo largo y fino opone más resistencia que uno corto y grueso.

#ptitulo[Por qué la longitud multiplica y la sección divide] Un hilo el doble de largo es como dos hilos iguales puestos uno tras otro: el doble de resistencia. Un hilo de doble sección es como dos hilos iguales puestos uno al lado del otro: la corriente tiene dos caminos y la resistencia se queda en la mitad. La resistividad del cobre es $rho approx 0,0172 "Ω" dot "mm"^2 slash "m"$; la del aluminio, unos $0,028$; la de un buen aislante, billones de veces mayor. La *conductividad* $sigma = 1 slash rho$ es la misma propiedad vista al revés: cuánto deja pasar el material, en lugar de cuánto se opone.

#ejemplo(titulo: [El cable de alimentación del transceptor])[
El transceptor que pide 20 A está a 3 m de la fuente, así que la corriente recorre 6 m de cobre entre ida y vuelta. Con cable de 4 mm²:
$ R = rho l / S = 0,0172 dot 6 / 4 approx 0,026 "Ω", quad V_"cable" = I R = 20 dot 0,026 approx 0,52 "V". $
Con cable de 1 mm², $R approx 0,10 "Ω"$ y la caída sube a 2,1 V: de los 13,8 V de la fuente llegan solo 11,7 V al equipo, y el cable disipa $I^2 R approx 41$ W. Cuatro veces menos sección, cuatro veces más resistencia y cuatro veces más pérdida. Es la pregunta T1.37 en la vida real.
]

=== Potencia

De la ley de Ohm y de la definición de potencia ($P = W slash t = V dot q slash t$) salen las tres formas equivalentes de la *potencia disipada*, que conviene saber reconstruir y no solo memorizar:
$ P = V I = I^2 R = V^2 / R, $
las dos últimas sustituyendo $V = I R$ o $I = V slash R$. Obsérvese que la fórmula $P = E^2 dot R$ que aparece como distractor en el examen tiene la resistencia multiplicando donde debería dividir.

Las unidades confirman la primera forma: la tensión son julios por culombio y la corriente, culombios por segundo; su producto son julios por segundo, es decir, vatios.

#truco(titulo: [El triángulo de Ohm])[
Escribe $V$ arriba y $I dot R$ abajo. Tapa con el dedo la magnitud que buscas y lee lo que queda: $V = I R$, $I = V slash R$, $R = V slash I$. El mismo triángulo con $P$ arriba y $V dot I$ abajo da $P = V I$, $I = P slash V$ y $V = P slash I$.
]

#ejemplo(titulo: [Una carga artificial de 50 Ω])[
Un transmisor entrega 100 W a una carga artificial de 50 Ω. ¿Qué tensión eficaz hay en ella y qué corriente la recorre? De $P = V^2 slash R$: $V = sqrt(P R) = sqrt(100 dot 50) approx 70,7$ V. De $P = I^2 R$: $I = sqrt(P slash R) = sqrt(2) approx 1,41$ A. Comprobación: $V I = 70,7 dot 1,41 approx 100$ W. Elige la forma de la potencia según los dos datos que tengas.
]

#figure(
  table(
    columns: (auto, auto, auto, 1fr),
    align: (left, center, left, left),
    table.header([Magnitud], [Símbolo], [Unidad], [Equivale a]),
    [Carga], [$q$, $Q$], [culombio (C)], [1 C = 1 A · 1 s],
    [Corriente], [$I$], [amperio (A)], [1 A = 1 C/s],
    [Tensión, fem], [$V$, $E$, $epsilon$], [voltio (V)], [1 V = 1 J/C = 1 W/A],
    [Resistencia], [$R$], [ohmio (Ω)], [1 Ω = 1 V/A],
    [Potencia], [$P$], [vatio (W)], [1 W = 1 J/s = 1 V · A],
    [Energía], [$W$], [julio (J)], [1 J = 1 W · s],
    [Campo eléctrico], [$E$], [voltio por metro (V/m)], [diferencia de potencial por metro],
    [Frecuencia], [$f$], [hercio (Hz)], [1 Hz = 1 ciclo por segundo],
  ),
  caption: [Las unidades que pregunta el examen. Ojo: el banco escribe la tensión como $E$, la misma letra que el campo eléctrico.],
) <t1-tab-unidades>

#figure(
  table(
    columns: 7,
    align: center,
    table.header([pico (p)], [nano (n)], [micro (μ)], [mili (m)], [kilo (k)], [mega (M)], [giga (G)]),
    [$10^(-12)$], [$10^(-9)$], [$10^(-6)$], [$10^(-3)$], [$10^3$], [$10^6$], [$10^9$],
  ),
  caption: [Prefijos del Sistema Internacional: 10 mA = 0,01 A; 1 kΩ = 1000 Ω; 145 MHz = $145 times 10^6$ Hz.],
) <t1-tab-prefijos>

#ojo[
- Prefijos primero, fórmula después: 10 mA son 0,01 A y 1 kΩ son 1000 Ω (T1.3, T1.6). Casi todos los fallos de cálculo del tema vienen de aquí.
- La fórmula falsa que el examen usa de cebo es $P = E^2 dot R$: la resistencia debe *dividir* (T1.9).
- 1 C = 1 A · 1 s, y 1 A = 1 C/s (T1.4, T1.47). El «amperio dividido por segundo» y el «vatio por segundo» son cebos.
- La potencia crece con el *cuadrado* de la corriente: con doble corriente en la misma resistencia, cuádruple calor (T1.8, T1.38).
]

=== Las leyes de Kirchhoff

Las *leyes de Kirchhoff* son conservación pura: la de corrientes (en un nudo, la suma de corrientes entrantes es igual a la de salientes; la carga no se acumula) y la de tensiones (la suma de caídas de tensión a lo largo de una malla cerrada es cero; la energía por carga es una función de punto). De ellas se deducen las reglas de asociación: en *serie* circula la misma $I$ y las tensiones se suman, luego $R_"serie" = R_1 + R_2 + dots.c$; en *paralelo* la tensión es común y las corrientes se suman, luego $1 slash R_"par" = 1 slash R_1 + 1 slash R_2 + dots.c$ — siempre menor que la más pequeña.

#analogia[
La ley de corrientes es la de un empalme de tuberías: el agua que entra tiene que salir por algún sitio, porque no se acumula en el empalme. La de tensiones es la de un paseo por la montaña: subas y bajes lo que subas y bajes, si vuelves al punto de partida tu cambio total de altura es cero. La pila «sube» la energía de las cargas, las resistencias la «bajan», y la vuelta completa suma cero.
]

Merece la pena ver de dónde sale la fórmula del paralelo. Con tensión común $V$, cada rama toma $I_k = V slash R_k$ y el generador entrega la suma; la resistencia equivalente es la que reproduce esa corriente total:
$ I = V (1 / R_1 + 1 / R_2) quad ==> quad R_"par" = V / I = (R_1 R_2) / (R_1 + R_2), $
la regla «producto entre suma» para dos resistencias.

#ejemplo[
$R_1 = 6 "Ω"$ y $R_2 = 3 "Ω"$. En serie: $6 + 3 = 9 "Ω"$. En paralelo: $6 dot 3 slash (6 + 3) = 2 "Ω"$ — menor que la más pequeña, como debe ser. Conectado el paralelo a 12 V, cada rama toma su corriente (2 y 4 A) y el total, 6 A, cuadra con $12 slash 2$: las dos leyes de Kirchhoff a la vez.
]

#circuito(caption: [Las dos asociaciones del ejemplo, con $R_1 = 6 "Ω"$, $R_2 = 3 "Ω"$ y una pila de 12 V. (a) En serie, la misma corriente (1,33 A) recorre las dos resistencias, y la tensión se reparte en proporción a cada una: 8 V + 4 V = 12 V. (b) En paralelo, las dos ven los 12 V, y las corrientes de rama (2 A y 4 A) se suman en el nudo: 6 A.], sim: "resistors.txt")[
  #grid(
    columns: 2,
    column-gutter: 1.4cm,
    _t1-panel([(a) En serie], esquema({
      import zap: *
      import cetz.draw: content, line
      bateria("b", (0, 3), (0, 0))
      content((-0.4, 1.5), anchor: "east", _t1-t[12 V])
      resistor("r1", (0, 3), (3, 3), label: $R_1 = 6 "Ω"$)
      resistor("r2", (3, 3), (3, 0), label: $R_2 = 3 "Ω"$)
      wire((3, 0), (0, 0))
      content((1.5, 2.55), anchor: "north", _t1-t[8 V])
      content((2.6, 1.5), anchor: "east", _t1-t[4 V])
      line((2.2, 0.3), (0.8, 0.3), .._t1-flecha-i)
      content((1.5, 0.4), anchor: "south", _t1-t(fill: col.senal2)[$I = 1,33$ A])
    })),
    _t1-panel([(b) En paralelo], esquema({
      import zap: *
      import cetz.draw: content, line
      bateria("b", (0, 3), (0, 0))
      content((-0.4, 1.5), anchor: "east", _t1-t[12 V])
      wire((0, 3), (5, 3))
      wire((0, 0), (5, 0))
      resistor("r1", (2.2, 3), (2.2, 0), label: $R_1 = 6 "Ω"$)
      resistor("r2", (5, 3), (5, 0), label: $R_2 = 3 "Ω"$)
      node("n1", (2.2, 3))
      node("n2", (2.2, 0))
      line((0.4, 3.3), (1.7, 3.3), .._t1-flecha-i)
      content((1.05, 3.35), anchor: "south", _t1-t(fill: col.senal2)[6 A])
      line((1.85, 2.65), (1.85, 1.75), .._t1-flecha-i)
      content((1.75, 2.2), anchor: "east", _t1-t(fill: col.senal2)[2 A])
      line((4.65, 2.65), (4.65, 1.75), .._t1-flecha-i)
      content((4.55, 2.2), anchor: "east", _t1-t(fill: col.senal2)[4 A])
    })),
  )
] <t1-fig-serie-paralelo>

#porque[
- *Serie* (@t1-fig-serie-paralelo a). Solo hay un camino, así que la carga que pasa por $R_1$ es la misma que pasa por $R_2$ (ley de corrientes): $I = 12 slash 9 approx 1,33$ A. Cada resistencia «se come» $I R$ voltios, y la suma de esas caídas tiene que devolver los 12 V de la pila (ley de tensiones): $1,33 dot 6 + 1,33 dot 3 = 8 + 4 = 12$ V. La resistencia mayor se queda con la mayor parte de la tensión. Este *divisor de tensión* #falstad("voltdivide.txt") reaparece en la polarización de los transistores (#ver(<sec-polarizacion>)).
- *Paralelo* (@t1-fig-serie-paralelo b). Las dos resistencias están conectadas a los mismos dos puntos, así que las dos ven 12 V. Cada una toma su corriente por separado, $12 slash 6 = 2$ A y $12 slash 3 = 4$ A, y en el nudo se juntan: 6 A. Añadir una rama en paralelo abre un camino más y nunca cierra ninguno. Por eso $R_"par"$ siempre es menor que la menor de las resistencias.
- Si $R_2$ se cortocircuita, en (a) la corriente sube a $12 slash 6 = 2$ A y $R_1$ recibe toda la tensión. En (b) la pila queda en cortocircuito, y la corriente solo la limita su resistencia interna (#ver(<t1-sec-fuentes>)).
]

#idea[
Serie: la misma corriente; las tensiones y las resistencias se suman. Paralelo: la misma tensión; las corrientes se suman y la resistencia equivalente baja. Con dos resistencias iguales en paralelo, $R slash 2$; con $n$ iguales, $R slash n$.
]

=== La ley de Coulomb

Por último, la *ley de Coulomb* da la fuerza entre dos cargas puntuales:
$ F = k (q_1 q_2) / d^2, quad quad k = 1 / (4 pi epsilon_0) approx 9 times 10^9 thin "N m"^2 slash "C"^2 : $
directamente proporcional al _producto_ de las cargas e inversamente proporcional al _cuadrado_ de la distancia.

Tiene la misma forma que la gravitación de Newton: a doble distancia, la cuarta parte de fuerza. La diferencia es que las cargas tienen signo: las del mismo signo se repelen y las de signo contrario se atraen. Esa fuerza a distancia es la que se describe con el *campo eléctrico* del apartado de ondas y señales.

#ojo[
Coulomb (T1.10): *producto* de las cargas (no la suma) y *cuadrado* de la distancia dividiendo. Las opciones «independiente de la distancia» o «inversamente proporcional al producto» son cebos.
]

#q("T1.1", "c",
  [La unidad de medida de la resistencia eléctrica es:],
  ([el amperio], [el vatio], [el ohmio], [el voltio]),
  sol: [La resistencia se mide en ohmios (Ω). El amperio mide la intensidad, el voltio la tensión y el vatio la potencia: cuarteto que cae de forma recurrente.],
)

#q("T1.2", "b",
  [Un voltio es:],
  ([la unidad de intensidad de campo eléctrico], [la diferencia de potencial que se origina entre los extremos de una resistencia de un ohmio al circular por ella un amperio], [la frecuencia de un ciclo por segundo], [la unidad de carga eléctrica]),
  sol: [Definición operativa del voltio a partir de la ley de Ohm: si por una resistencia de 1 Ω circula 1 A, entre sus extremos hay 1 V. El distractor (a) confunde con el V/m del campo eléctrico.],
)

#q("T1.3", "a",
  [Un kiloohmio equivale a:],
  ([mil ohmios], [cien ohmios], [un millón de ohmios], [una milésima de ohmio]),
  sol: [El prefijo kilo- es mil: 1 kΩ = 1000 Ω. El distractor (c) es el megaohmio.],
)

#q("T1.4", "d",
  [Un culombio es igual a:],
  ([un voltio dividido por un ohmio], [un vatio por segundo], [un amperio dividido por un segundo], [el producto de un amperio por un segundo]),
  sol: [El culombio es la carga transportada por una corriente de un amperio durante un segundo: $Q = I dot t$.],
)

#q("T1.5", "b",
  [Al aplicar una tensión de 12 V entre los extremos de una resistencia circula por ella una corriente de 2 A. El valor de la resistencia es:],
  ([24 Ω], [6 Ω], [0,17 Ω], [10 Ω]),
  sol: [Ley de Ohm: $R = V slash I = 12 slash 2 = 6 "Ω"$. El distractor de 24 Ω es el producto $V dot I$ (la potencia, 24 W) y el de 0,17 el cociente invertido.],
)

#q("T1.6", "c",
  [Por una resistencia de 1 kΩ circula una corriente continua de 10 mA. La diferencia de potencial entre sus extremos es de:],
  ([100 V], [1 V], [10 V], [0,1 V]),
  sol: [$V = I dot R = 0,01 dot 1000 = 10$ V. Cuidado con los prefijos: 10 mA son 0,01 A.],
)

#q("T1.7", "a",
  [El producto de 13 voltios por 1 amperio son:],
  ([13 vatios], [13 ohmios], [13 julios], [13 hercios]),
  sol: [$P = V dot I = 13 dot 1 = 13$ W.],
)

#q("T1.8", "b",
  [La potencia disipada en una resistencia de 30 ohmios por la que circula una corriente de 2 amperios es de:],
  ([60 vatios], [120 vatios], [15 vatios], [240 vatios]),
  sol: [$P = I^2 R = 2^2 dot 30 = 120$ W. La corriente entra al cuadrado: doblarla cuadruplica la potencia disipada.],
)

#q("T1.9", "b",
  [Según las leyes básicas de la electricidad, señale la fórmula incorrecta:],
  ([$E = I dot R$], [$P = E^2 dot R$], [$P = I^2 dot R$], [$P = E dot I$]),
  sol: [Las fórmulas correctas de la potencia son $P = E dot I = I^2 R = E^2 slash R$. La opción (b) multiplica en lugar de dividir: la correcta con tensión es $E^2 slash R$.],
)

#q("T1.10", "d",
  [La ley de Coulomb establece que la fuerza entre dos cargas eléctricas es:],
  ([independiente de la distancia entre ellas], [inversamente proporcional al producto de las cargas], [proporcional a la suma de las cargas], [directamente proporcional al producto de las cargas]),
  sol: [Ley de Coulomb: $F = k q_1 q_2 slash d^2$, directamente proporcional al producto de las cargas e inversamente proporcional al cuadrado de la distancia.],
)

== Fuentes y energía <t1-sec-fuentes>

#motivacion[
Conectas el transceptor a una batería, pulsas el micrófono y el equipo se reinicia. La batería marcaba 12,6 V en reposo: ¿por qué no los mantiene? Porque ninguna fuente real es ideal. Por dentro también tiene resistencia, y cada amperio que le pides se paga con tensión perdida dentro de ella.
]

Una fuente real no es un generador ideal: se modela como una *fuerza electromotriz* $epsilon$ (la energía por carga que la reacción química o el generador aportan) en serie con una *resistencia interna* $r$. La tensión en bornes con carga conectada es
#destacada($ V = epsilon - I r, $)
menor que $epsilon$ cuanta más corriente se pida; en circuito abierto ($I = 0$) se mide la fem completa, y en cortocircuito la corriente queda limitada solo por la resistencia interna: $I_"cc" = epsilon slash r$.

#circuito(caption: [(a) Modelo de una fuente real: una fem ideal $epsilon$ en serie con su resistencia interna $r$. Solo los bornes A y B son accesibles desde fuera. (b) Tensión en bornes frente a la corriente pedida: una recta que parte de $epsilon$ en circuito abierto y llega a cero en cortocircuito, $I_"cc" = epsilon slash r$. En cada punto, la diferencia con $epsilon$ es la caída interna $I r$.])[
  #grid(
    columns: 2,
    column-gutter: 1.2cm,
    _t1-panel([(a) Fuente real con carga], esquema({
      import zap: *
      import cetz.draw: content, line, rect
      rect((-1.0, -0.45), (2.25, 3.8), stroke: (paint: col.gris, dash: "dashed", thickness: 0.6pt))
      content((0.62, -0.45), anchor: "north", padding: 2pt, _t1-t(fill: col.gris)[fuente real])
      bateria("eps", (0, 2.2), (0, 0.6))
      content((-0.35, 1.4), anchor: "east", $epsilon$)
      wire((0, 2.2), (0, 3))
      resistor("r", (0, 3), (1.9, 3), label: $r$)
      wire((1.9, 3), (2.9, 3))
      wire((0, 0.6), (0, 0))
      wire((0, 0), (2.9, 0))
      wire((2.9, 3), (4.2, 3))
      resistor("rl", (4.2, 3), (4.2, 0), label: $R_L$)
      wire((4.2, 0), (2.9, 0))
      _t1-borne((2.9, 3))
      _t1-borne((2.9, 0))
      content((2.9, 3.12), anchor: "south", _t1-t[A])
      content((2.9, -0.12), anchor: "north", _t1-t[B])
      line((3.45, 0.35), (3.45, 2.65), .._t1-flecha)
      content((3.5, 1.5), anchor: "west", _t1-t[$V$])
      line((3.1, 3.3), (3.9, 3.3), .._t1-flecha-i)
      content((3.5, 3.35), anchor: "south", _t1-t(fill: col.senal2)[$I$])
    })),
    _t1-panel([(b) Tensión en bornes], cetz.canvas({
      import cetz.draw: *
      ejes(0, 4.6, 0, 3.6, etq-x: $I$, etq-y: $V$)
      line((0, 2.6), (3.6, 0), stroke: 1.2pt + col.senal1)
      line((0, 2.6), (2.2, 2.6), .._t1-guia)
      content((-0.08, 2.6), anchor: "east", _t1-t[$epsilon$])
      content((0.1, 2.72), anchor: "south-west", _t1-t[circuito abierto])
      content((3.6, -0.08), anchor: "north", _t1-t[$I_"cc" = epsilon slash r$])
      content((3.75, 0.2), anchor: "south-west", _t1-t[cortocircuito])
      let ip = 1.5
      let vp = 2.6 - 2.6 / 3.6 * ip
      line((ip, 0), (ip, vp), .._t1-guia)
      line((0, vp), (ip, vp), .._t1-guia)
      circle((ip, vp), radius: 0.06, fill: col.senal2, stroke: none)
      content((ip, -0.08), anchor: "north", _t1-t[$I$])
      content((-0.08, vp), anchor: "east", _t1-t[$V$])
      line((ip, vp), (ip, 2.6), .._t1-cota)
      content((ip + 0.08, (vp + 2.6) / 2), anchor: "west", _t1-t[$I r$])
    })),
  )
] <t1-fig-fuente-real>

#porque[
- Dentro de la caja, la reacción química (o el generador) eleva cada culombio $epsilon$ voltios. Pero la corriente atraviesa también los materiales de la propia fuente —electrolito, placas, devanados—, y eso es $r$.
- Con la carga $R_L$ conectada circula $I = epsilon slash (r + R_L)$, y la ley de tensiones de Kirchhoff reparte la fem: $I r$ se queda dentro, calentando la fuente, y el resto, $V = epsilon - I r$, llega a la carga.
- En vacío ($R_L$ infinita, $I = 0$) no cae nada en $r$ y el voltímetro lee la fem completa. En cortocircuito ($R_L = 0$) toda la fem cae en $r$: la corriente es enorme y toda la potencia se disipa dentro de la propia batería. Por eso las baterías de la estación llevan fusible junto al borne.
]

#ejemplo[
Una batería con $epsilon = 12,6$ V y $r = 0,05 "Ω"$ alimenta un transceptor. En recepción (1 A): $V = 12,6 - 1 dot 0,05 approx 12,55$ V. Transmitiendo (20 A): $V = 12,6 - 20 dot 0,05 = 11,6$ V. Se ha perdido 1 V dentro de la batería, que disipa $I^2 r = 20$ W, y el equipo queda en el límite de lo que admiten muchos transceptores (13,8 V ± 15 %, es decir, unos 11,7 V como mínimo). En cortocircuito, $I_"cc" = 12,6 slash 0,05 = 252$ A.
]

Al conectar fuentes en serie se suman las fems (y las resistencias internas); en paralelo la tensión es la de una y se reparte la corriente — por eso se paralelan baterías para dar más amperios.

#circuito(caption: [Cuatro pilas de 1,5 V. (a) En serie, el borne $+$ de cada una se une al $-$ de la siguiente: las fems se suman (6 V), pero la misma corriente atraviesa las cuatro. (b) En paralelo, todos los $+$ juntos y todos los $-$ juntos: la tensión es la de una sola (1,5 V), y cada pila aporta una parte de la corriente total.])[
  #grid(
    columns: 2,
    column-gutter: 1.4cm,
    _t1-panel([(a) En serie: 6 V], esquema({
      import zap: *
      import cetz.draw: content, line
      for i in range(4) {
        bateria("s" + str(i), (1.2 * (i + 1), 0), (1.2 * i, 0))
        content((1.2 * i + 0.6, 0.55), anchor: "south", _t1-t[1,5 V])
      }
      _t1-borne((0, 0))
      _t1-borne((4.8, 0))
      content((-0.15, 0), anchor: "east", _t1-t[$-$])
      content((4.95, 0), anchor: "west", _t1-t[$+$])
      line((0, -0.75), (4.8, -0.75), .._t1-cota)
      content((2.4, -0.85), anchor: "north", _t1-t[$4 times 1,5 = 6$ V])
    })),
    _t1-panel([(b) En paralelo: 1,5 V], esquema({
      import zap: *
      import cetz.draw: content, line
      for i in range(4) {
        bateria("p" + str(i), (1.1 * i, 1.6), (1.1 * i, 0))
      }
      wire((0, 1.6), (4.3, 1.6))
      wire((0, 0), (4.3, 0))
      for i in range(1, 4) {
        node("na" + str(i), (1.1 * i, 1.6))
        node("nb" + str(i), (1.1 * i, 0))
      }
      _t1-borne((4.3, 1.6))
      _t1-borne((4.3, 0))
      content((4.45, 1.6), anchor: "west", _t1-t[$+$])
      content((4.45, 0), anchor: "west", _t1-t[$-$])
      content((4.45, 0.8), anchor: "west", _t1-t[1,5 V])
    })),
  )
] <t1-fig-pilas>

#porque[
- En serie, cada pila eleva 1,5 V la energía de la carga que la atraviesa, y la carga pasa por las cuatro una tras otra: $4 times 1,5 = 6$ V. Pero solo hay un camino, así que la corriente que puede dar el conjunto es la que aguanta una pila sola, y las resistencias internas también se suman.
- En paralelo, cada carga pasa por *una* de las cuatro pilas, no por todas: la tensión no se suma. Lo que se reparte es la corriente: cada pila da un cuarto del total, así que el conjunto puede dar cuatro veces más corriente, o durar cuatro veces más con la misma.
- Para ponerlas en paralelo, las pilas deben ser iguales e ir igual de cargadas. Si una tiene más fem que otra, circula corriente de la una a la otra aunque no haya nada conectado.
]

La capacidad de una batería se expresa en amperios-hora: es carga (1 Ah = 3600 C). Una batería de $C$ amperios-hora sostiene idealmente una corriente $I$ durante $t = C slash I$ horas.

#ptitulo[Carga no es energía] Los amperios-hora miden carga. La energía es carga por tensión: una batería de 7 Ah y 12 V guarda unos $7 dot 12 = 84$ Wh, es decir, $84 dot 3600 approx 302$ kJ.

#ejemplo[
La batería de 7 Ah de la pregunta T1.12: a 0,5 A dura $t = 7 slash 0,5 = 14$ h. El mismo equipo transmitiendo a 20 A la vaciaría, idealmente, en $7 slash 20 = 0,35$ h, unos 21 minutos. En la práctica dura menos: la capacidad nominal se mide con corriente pequeña, y con corrientes altas una batería entrega menos amperios-hora.
]

#ptitulo[La fuente de alimentación de red] En casa, la batería suele cambiarse por una fuente que convierte los 230 V alternos de la red en 13,8 V continuos: transformador, rectificador, filtro y regulador. Para el equipo se describe con el mismo modelo: una tensión de salida y una resistencia interna, muy baja en una buena fuente regulada, que mantiene los 13,8 V casi sin caída hasta su corriente máxima. Cómo está construida por dentro se explica en #ver(<sec-fuente>).

#ojo[
- Una batería convierte energía *química* en eléctrica (T1.11, T1.41). La dinamo convierte energía mecánica; la célula solar, luminosa.
- En serie se suman las *tensiones*, y la corriente es la de una pila (T1.13, T1.42). En paralelo es al revés.
- Lo que caracteriza a un generador es su *fuerza electromotriz* (T1.45), junto con su resistencia interna.
- Horas = amperios-hora ÷ amperios (T1.12): a mitad de corriente, doble de horas.
]

#q("T1.11", "c",
  [Una batería eléctrica es un dispositivo que convierte:],
  ([energía mecánica en energía eléctrica], [energía eléctrica en energía luminosa], [energía química en energía eléctrica], [energía térmica en energía química]),
  sol: [La batería convierte energía química en eléctrica (y al cargarla, a la inversa). De ahí que se agote: la reacción química se consume.],
)

#q("T1.12", "c",
  [Una batería con una capacidad de 7 amperios-hora puede suministrar una corriente de 0,5 A durante aproximadamente:],
  ([3,5 horas], [7 horas], [14 horas], [28 horas]),
  sol: [$t = Q slash I = 7 "Ah" slash 0,5 "A" = 14$ horas: a mitad de corriente, doble de horas.],
)

#q("T1.13", "a",
  [Si se conectan varias pilas iguales en serie:],
  ([la tensión del conjunto es la suma de las tensiones y la intensidad la de una sola pila], [la tensión del conjunto es la de una sola pila], [la intensidad del conjunto es la suma de las intensidades], [tensión e intensidad se reducen a la mitad]),
  sol: [En serie se suman las tensiones y la corriente que atraviesa el conjunto es la de una sola pila. Para sumar corrientes habría que conectarlas en paralelo.],
)

== Ondas y señales <t1-sec-ondas>

#motivacion[
La emisora tiene que llevar energía hasta un receptor a cientos de kilómetros, sin ningún cable. Lo que viaja es una onda electromagnética. Lo que la describe —frecuencia, longitud de onda, amplitud, fase— es el vocabulario de todo el resto del temario.
]

=== Campos y ondas electromagnéticas

Antes de la onda, los campos. Una carga en reposo crea a su alrededor un *campo eléctrico* $arrow(E)$, medido en voltios por metro (entre dos placas separadas una distancia $d$ a tensión $V$, $E = V slash d$); una corriente crea un *campo magnético* que rodea al conductor en circunferencias, tanto más intenso cuanto mayor es la corriente y menor la distancia. Apantallarlos pide estrategias distintas: el campo eléctrico se detiene con cualquier superficie conductora puesta a tierra (jaula de Faraday), pero el magnético de baja frecuencia solo se desvía con materiales ferromagnéticos. Cuando ambos campos oscilan, cada uno regenera al otro y el conjunto se independiza de la fuente: eso es la onda electromagnética.

Una carga acelerada radia. El resultado es una *onda electromagnética*: un campo eléctrico $arrow(E)$ (V/m) y uno magnético $arrow(B)$, perpendiculares entre sí y a la dirección de propagación, que se sostienen mutuamente y viajan en el vacío a
$ c = 3 times 10^8 "m/s" = 300.000 "km/s". $
La *polarización* de la onda es, por convenio, la dirección del campo eléctrico. En un ciclo de la oscilación la onda avanza una *longitud de onda* $lambda$, y como hay $f$ ciclos por segundo,
$ c = lambda f quad ==> quad lambda ("m") approx 300 / (f ("MHz")). $

#circuito(caption: [Onda electromagnética. El campo eléctrico $arrow(E)$ (vertical) y el magnético $arrow(B)$ (horizontal) oscilan en fase, perpendiculares entre sí y a la dirección de avance. En una longitud de onda $lambda$ el dibujo se repite. Esta onda tiene polarización *vertical*, porque su campo eléctrico es vertical; es la que radia una antena vertical.])[
  #cetz.canvas({
    import cetz.draw: *
    let largo = 8.0
    let k = 2 * calc.pi / 4.0
    let ae = 1.25
    let ab = 1.1
    // proyección oblicua: el eje z (hacia el lector) se dibuja hacia abajo e izquierda
    let pz(x, z) = (x - 0.28 * z, -0.5 * z)
    let bp(x) = pz(x, ab * calc.sin(k * x))
    // planos de referencia
    rect((0, -ae), (largo, ae), fill: col.senal1.lighten(93%), stroke: 0.3pt + col.senal1.lighten(70%))
    line(pz(0, ab), pz(largo, ab), pz(largo, -ab), pz(0, -ab), close: true, fill: col.senal2.lighten(92%), stroke: 0.3pt + col.senal2.lighten(70%))
    for j in range(33) {
      let x = j * 0.25
      line((x, 0), (x, ae * calc.sin(k * x)), stroke: 0.35pt + col.senal1.lighten(40%))
      line((x, 0), bp(x), stroke: 0.35pt + col.senal2.lighten(40%))
    }
    line((-0.7, 0), (largo + 0.9, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((largo + 0.9, 0), anchor: "west", padding: 3pt, _t1-t[propagación ($c$)])
    onda(x => ae * calc.sin(k * x), 0, largo, n: 200, stroke: 1.3pt + col.senal1)
    line(..range(201).map(j => bp(largo * j / 200)), stroke: 1.3pt + col.senal2)
    line((1, ae), (1, ae + 0.55), .._t1-guia)
    line((5, ae), (5, ae + 0.55), .._t1-guia)
    line((1, ae + 0.45), (5, ae + 0.45), .._t1-cota)
    content((3, ae + 0.5), anchor: "south", _t1-t[$lambda$])
    content((largo + 0.08, ae - 0.2), anchor: "west", text(size: 8pt, fill: col.senal1)[$arrow(E)$ (plano vertical)])
    content((largo - 0.28 * ab + 0.08, -0.5 * ab), anchor: "west", text(size: 8pt, fill: col.senal2)[$arrow(B)$ (plano horizontal)])
  })
] <t1-fig-onda-em>

La fórmula $c = lambda f$ es la de cualquier fenómeno periódico que avanza: en un período $T = 1 slash f$ la onda recorre una longitud de onda, así que su velocidad es $lambda slash T = lambda f$. El 300 de la regla práctica sale de dividir $c = 3 times 10^8$ m/s entre $10^6$, los hercios que tiene un megahercio. La historia física completa —cómo un campo que cambia crea el otro y por qué eso deja que la onda se suelte de la antena— está en #ver(<sec-em>).

#truco[
La regla $lambda approx 300 slash f ("MHz")$ resuelve media docena de preguntas del banco: 144 MHz → 2 m; 7 MHz → 40 m; 430 MHz → 70 cm; 3,5 MHz → 80 m.
]

#ejemplo[
145 MHz: $lambda = 300 slash 145 approx 2,07$ m, la banda de 2 m (T1.17). 7,1 MHz: $lambda approx 42$ m, y un dipolo de media onda para esa banda mide algo menos de 21 m (#ver(<sec-antena>)).
]

#ptitulo[Las bandas por su nombre] Cada década de frecuencias tiene un nombre, y el examen lo pregunta (T1.29):

#figure(
  table(
    columns: (auto, auto, auto, 1fr),
    align: (center, left, left, left),
    table.header([Banda], [Frecuencias], [Longitud de onda], [Ejemplos]),
    [MF], [300 kHz – 3 MHz], [1 km – 100 m], [onda media de AM; banda de 160 m],
    [HF], [3 – 30 MHz], [100 – 10 m], [bandas de 80, 40, 20 y 10 m],
    [VHF], [30 – 300 MHz], [10 – 1 m], [FM comercial (87,5–108 MHz); banda de 2 m],
    [UHF], [300 MHz – 3 GHz], [1 m – 10 cm], [banda de 70 cm (430–440 MHz); 23 cm],
    [SHF], [3 – 30 GHz], [10 – 1 cm], [satélites, enlaces de microondas],
  ),
  caption: [Denominación de las bandas de frecuencia. Los límites son potencias de 10 multiplicadas por 3, así que $lambda$ cae en potencias de 10 exactas.],
) <t1-tab-bandas>

=== La señal sinusoidal

La señal básica es la *sinusoide* $v(t) = V_0 sin(2 pi f t + phi)$, con amplitud de pico $V_0$, frecuencia $f$ (Hz), período $T = 1 slash f$ y fase $phi$. Dos sinusoides de igual frecuencia pueden estar *desfasadas*: su _diferencia de fase_ $Delta phi$ (en grados o radianes) mide el adelanto o el retraso de una respecto a la otra — en fase si $Delta phi = 0$, en oposición si $Delta phi = 180 degree$ —, y reaparece en las reactancias de los temas T2 y T3. De la sinusoide se definen tres valores que el examen confunde adrede. El *valor eficaz* es el que produce la misma disipación que una continua; elevando al cuadrado y promediando un período,
$ V_"ef"^2 = 1 / T integral_0^T V_0^2 sin^2(omega t) dif t = V_0^2 / 2 quad ==> quad V_"ef" = V_0 / sqrt(2) approx 0,707 V_0, $
usando que $sin^2$ promedia $1/2$. El *valor medio* de una semionda es $2 V_0 slash pi approx 0,637 V_0$ (integral del seno en medio período); el de la sinusoide completa es cero, porque las dos semiondas se cancelan — el $0,637 V_0$ es solo el de la señal rectificada. Y la *amplitud*, tal como la define el banco, es la diferencia entre el valor máximo y el valor medio de la señal: con valor medio nulo, coincide con el valor de pico $V_0$.

#circuito(caption: [Los parámetros de una sinusoide. $V_0$ es el valor de pico y $V_"pp" = 2 V_0$ el de pico a pico. El valor eficaz (línea verde) está al 70,7 % del pico. El período $T$ es el tiempo entre dos máximos consecutivos. La curva roja discontinua tiene la misma frecuencia pero llega a sus máximos un poco más tarde: va retrasada $Delta phi$ (aquí, 45°).])[
  #cetz.canvas({
    import cetz.draw: *
    let a = 1.5
    let per = 4.0
    ejes(0, 8.0, -2.15, 2.5, etq-x: $t$, etq-y: $v(t)$)
    // valor eficaz
    line((0, a * 0.707), (7.2, a * 0.707), stroke: (paint: col.verde, dash: "dashed", thickness: 0.8pt))
    content((3.0, a * 0.707 + 0.06), anchor: "south", _t1-t(fill: col.verde)[$V_"ef" approx 0,707 V_0$])
    // señal retrasada
    onda(x => 0.9 * calc.sin(2 * calc.pi * (x - 0.5) / per), 0, 7.2, stroke: (paint: col.senal2, thickness: 0.9pt, dash: "dashed"))
    onda(x => a * calc.sin(2 * calc.pi * x / per), 0, 7.2, stroke: 1.2pt + col.senal1)
    // pico
    line((1, 0), (1, a), .._t1-flecha)
    content((0.95, 0.75), anchor: "east", _t1-t[$V_0$])
    // período
    line((1, a), (1, a + 0.55), .._t1-guia)
    line((5, a), (5, a + 0.55), .._t1-guia)
    line((1, a + 0.45), (5, a + 0.45), .._t1-cota)
    content((3, a + 0.5), anchor: "south", _t1-t[$T = 1 slash f$])
    // pico a pico
    line((5, a), (7.4, a), .._t1-guia)
    line((7, -a), (7, a), .._t1-cota)
    content((7.1, 0.25), anchor: "west", _t1-t[$V_"pp" = 2 V_0$])
    // desfase
    line((5, a), (5, -1.85), .._t1-guia)
    line((5.5, 0.9), (5.5, -1.85), .._t1-guia)
    line((5, -1.75), (5.5, -1.75), .._t1-cota)
    content((5.25, -1.85), anchor: "north", _t1-t[$Delta phi$])
  })
] <t1-fig-sinusoide>

#ptitulo[Por qué $sin^2$ promedia $1/2$] $sin^2$ y $cos^2$ son la misma curva desplazada un cuarto de período, así que en un período completo tienen el mismo promedio. Como $sin^2 + cos^2 = 1$ en todo instante, cada una promedia la mitad. Y el cuadrado no es un capricho: la potencia en una resistencia es $v^2 slash R$, así que el valor que «calienta igual» es el que tiene el mismo cuadrado medio.

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, center),
    table.header([Valor], [Fórmula], [Red de 230 V]),
    [Pico (máximo)], [$V_0$], [325 V],
    [Pico a pico], [$2 V_0$], [650 V],
    [Eficaz], [$V_0 slash sqrt(2) approx 0,707 V_0$], [230 V],
    [Medio de una semionda], [$2 V_0 slash pi approx 0,637 V_0$], [207 V],
    [Medio del ciclo completo], [0], [0],
  ),
  caption: [Los valores de una sinusoide. Los 230 V de la red son eficaces: el resto se obtiene del pico, $230 dot sqrt(2) approx 325$ V.],
) <t1-tab-valores>

#ejemplo[
La red de 50 Hz tiene un período de $1 slash 50 = 20$ ms. Una señal de 25 Hz tiene $T = 1 slash 25 = 40$ ms (T1.19); una de 7 MHz, $T approx 143$ ns. Una sinusoide de 100 V de pico tiene $100 dot 0,707 = 70,7$ V eficaces (T1.20).
]

#ojo[
- Eficaz = 0,707 × pico; medio de la semionda = 0,637 × pico. Con 100 V de pico, el eficaz es 70,7 V (T1.20), y 63,7 V es el cebo.
- El *valor eficaz* se define por el calor: es la continua que calienta igual (T1.39). No es la media aritmética (que en la sinusoide completa vale cero), ni el pico, ni el pico a pico.
- *Período*: el tiempo entre dos máximos consecutivos (T1.18). *Frecuencia*: los ciclos por segundo. *Amplitud*, según el banco: el máximo menos el valor medio (T1.21).
- Una señal radioeléctrica queda caracterizada por su amplitud y su frecuencia (T1.22).
]

=== Señales no sinusoidales y ruido

Una señal _no_ sinusoidal (una onda cuadrada, la voz) se descompone por *Fourier* en una componente continua, una sinusoide a la frecuencia *fundamental* y *armónicos* a sus múltiplos enteros. Esta idea reaparece por todo el temario: los armónicos de un transmisor (T5) son exactamente los términos de esta serie que el filtro de salida debe atenuar.

#circuito(caption: [Una onda cuadrada (gris) se construye sumando sinusoides: la fundamental $f$, más el tercer armónico $3 f$ con un tercio de su amplitud, más el quinto $5 f$ con un quinto, y así sucesivamente. La curva azul suma solo esos tres términos y ya se parece mucho. Los flancos bruscos son los armónicos altos: si un filtro los quita, la onda se redondea.])[
  #cetz.canvas({
    import cetz.draw: *
    let w = 6.4
    let om = 2 * calc.pi / 3.2
    let a = 1.0
    ejes(0, 6.7, -1.55, 1.7, etq-x: $t$)
    line((0, a), (1.6, a), (1.6, -a), (3.2, -a), (3.2, a), (4.8, a), (4.8, -a), (6.4, -a), stroke: 1.4pt + col.gris.lighten(30%))
    onda(x => 4 / calc.pi * calc.sin(om * x), 0, w, stroke: (paint: col.senal2, thickness: 0.9pt, dash: "dashed"))
    onda(x => 4 / (3 * calc.pi) * calc.sin(3 * om * x), 0, w, n: 240, stroke: 0.7pt + col.verde)
    onda(x => 4 / calc.pi * (calc.sin(om * x) + calc.sin(3 * om * x) / 3 + calc.sin(5 * om * x) / 5), 0, w, n: 320, stroke: 1.2pt + col.senal1)
    content((7.0, 1.05), anchor: "west", _t1-t(fill: col.gris)[onda cuadrada])
    content((7.0, 0.55), anchor: "west", _t1-t(fill: col.senal2)[fundamental, $f$])
    content((7.0, 0.05), anchor: "west", _t1-t(fill: col.verde)[3.#super[er] armónico, $3 f$])
    content((7.0, -0.45), anchor: "west", _t1-t(fill: col.senal1)[suma $f + 3 f + 5 f$])
  })
] <t1-fig-fourier>

Por eso una etapa final que deforma la sinusoide emite también en $2 f$, $3 f$…: un transmisor en 7 MHz con armónicos mal filtrados se oye también en 14 y 21 MHz.

Al ruido se le aplica el mismo lenguaje espectral. El *ruido térmico* de una resistencia entrega una potencia disponible $P = k T B$ ($k$ la constante de Boltzmann, $T$ la temperatura absoluta y $B$ el ancho de banda del receptor): por eso un receptor de banda estrecha «oye» menos ruido. El *ruido blanco* tiene densidad de potencia constante — es independiente de la frecuencia, como la luz blanca contiene todos los colores.

#ejemplo(titulo: [Por qué se estrecha el filtro en CW])[
A temperatura ambiente ($T approx 290$ K), $k T = 1,38 times 10^(-23) dot 290 approx 4 times 10^(-21)$ W por cada hercio de ancho de banda. Con el filtro de SSB (2,7 kHz) entran $P approx 1,1 times 10^(-17)$ W de ruido; con un filtro de CW de 500 Hz, $2 times 10^(-18)$ W: unas cinco veces menos, o 7 dB en el lenguaje de #ver(<t1-sec-potencia>). La señal de CW cabe entera en los 500 Hz, así que estrechar el filtro mejora la relación señal/ruido sin perder nada de la señal.
]

#ptitulo[Analógico y digital] Una señal analógica, como la tensión que da un micrófono, puede tomar cualquier valor dentro de su margen: infinitos valores posibles (T1.24). Una señal digital solo toma valores de un conjunto finito, dos en binario. Pasar de una a otra es lo que hace el conversor A/D de un DSP (@t1-fig-cuantificacion).

#q("T1.14", "b",
  [Las ondas de radio son de naturaleza:],
  ([acústica], [electromagnética], [mecánica], [gravitatoria]),
  sol: [Las ondas de radio son ondas electromagnéticas: campos eléctrico y magnético oscilantes que se propagan sin necesidad de medio material.],
)

#q("T1.15", "c",
  [La velocidad de propagación de las ondas electromagnéticas en el vacío es de:],
  ([340 m/s], [30.000 km/s], [300.000 km/s], [3.000.000 km/s]),
  sol: [$c = 3 times 10^8$ m/s = 300.000 km/s, la velocidad de la luz (que es también una onda electromagnética).],
)

#q("T1.16", "a",
  [La velocidad de propagación de una onda electromagnética es siempre igual a:],
  ([la longitud de onda multiplicada por la frecuencia], [la longitud de onda dividida por la frecuencia], [la frecuencia dividida por la longitud de onda], [la amplitud multiplicada por el período]),
  sol: [$v = lambda dot f$: la relación fundamental entre velocidad, longitud de onda y frecuencia. De ahí sale la regla $lambda approx 300 slash f ("MHz")$.],
)

#q("T1.17", "b",
  [La longitud de onda correspondiente a una frecuencia de 145 MHz es aproximadamente:],
  ([0,5 m], [2 m], [20 m], [70 cm]),
  sol: [$lambda = c slash f = (3 times 10^8) slash (145 times 10^6) approx 2,07$ m: la banda de 2 metros. El distractor de 70 cm corresponde a 430 MHz.],
)

#q("T1.18", "d",
  [El período de una señal alterna sinusoidal es:],
  ([la amplitud máxima que alcanza la señal], [el número de ciclos en un segundo], [la mitad de la duración de un ciclo], [el tiempo que transcurre entre dos valores máximos consecutivos]),
  sol: [El período es la duración de un ciclo completo: el tiempo entre dos máximos (o dos mínimos) consecutivos. Su inverso es la frecuencia.],
)

#q("T1.19", "a",
  [El período de una señal sinusoidal de 25 Hz de frecuencia es:],
  ([40 ms], [4 ms], [25 ms], [400 ms]),
  sol: [$T = 1 slash f = 1 slash 25 = 0,04$ s = 40 ms.],
)

#q("T1.20", "c",
  [El valor eficaz de una tensión sinusoidal cuyo valor máximo es 100 V es aproximadamente:],
  ([50 V], [63,7 V], [70,7 V], [100 V]),
  sol: [$V_"ef" = V_"máx" slash sqrt(2) approx 70,7$ V. El distractor de 63,7 V es el valor medio de la semionda ($2 V_"máx" slash pi$) — el examen juega a intercambiarlas.],
)

#q("T1.21", "b",
  [Se entiende por «amplitud» de una señal sinusoidal:],
  ([el tiempo que dura un ciclo completo], [la diferencia entre el valor máximo y el valor medio de la señal], [el número de ciclos por segundo], [la potencia disipada en cada ciclo]),
  sol: [Tal como la define el banco de preguntas, la amplitud es la diferencia entre el valor máximo y el valor medio de la señal (para una sinusoide centrada en cero, el valor de pico).],
)

#q("T1.22", "a",
  [Una señal radioeléctrica se puede caracterizar por su:],
  ([amplitud y frecuencia], [peso y volumen], [color y temperatura], [resistencia y capacidad]),
  sol: [Una señal radioeléctrica queda caracterizada por su amplitud y su frecuencia (y, si se quiere completar, su fase).],
)

#q("T1.23", "d",
  [En un sistema de radiocomunicación, el llamado «ruido blanco»:],
  ([solo aparece en las bandas bajas], [aumenta con la frecuencia], [desaparece de noche], [es independiente de la frecuencia]),
  sol: [El ruido blanco debe su nombre a la luz blanca: contiene todas las frecuencias con la misma densidad de potencia, es decir, es independiente de la frecuencia.],
)

#q("T1.24", "c",
  [En los sistemas de transmisión analógicos, las señales:],
  ([solo pueden tomar dos valores], [se representan siempre en binario], [pueden tomar infinitos valores], [no transportan información]),
  sol: [Una señal analógica puede tomar infinitos valores dentro de su margen; la digital solo un conjunto discreto (dos, en binario).],
)

== Señales moduladas <t1-sec-moduladas>

#motivacion[
La voz ocupa de 300 a 3000 Hz. Radiarla tal cual no funciona: a 3 kHz la longitud de onda es de 100 km, y todas las emisoras del mundo ocuparían las mismas frecuencias, sin forma de separarlas. Por eso cada emisora usa una *portadora* de radiofrecuencia en su propio canal. Pero una portadora sola no dice nada: es un tono constante. Hay que hacer que la voz cambie algún parámetro de la portadora —amplitud, frecuencia o fase—. Eso es *modular*, y su objeto es que la portadora transporte la información (T1.46). El receptor sintoniza esa portadora y deshace el cambio.
]

Aquí se fija lo que pregunta el examen. La explicación intuitiva larga, con los circuitos que modulan y demodulan, está en #ver(<sec-am>), #ver(<sec-fm>) y #ver(<sec-modulador>).

=== CW y AM

Una portadora pura no transporta información: hay que *modularla*, haciendo que la señal de baja frecuencia (la moduladora) altere alguno de sus parámetros. El caso límite es la *onda continua* (CW, clase A1A): no hay moduladora analógica, sino que se conmuta la portadora on/off al ritmo del código Morse. Su anchura de banda no la fija ninguna frecuencia moduladora, sino la _velocidad de manipulación_ y la brusquedad de los flancos, que se redondean para no ensanchar la emisión con chasquidos (_key clicks_).

#circuito(caption: [Manipulación en CW de la letra N (raya, punto). Arriba, flancos bruscos: la conmutación instantánea crea componentes lejos de la portadora, que se oyen como chasquidos en los canales vecinos. Abajo, flancos redondeados en unos milisegundos: la misma información, en una emisión mucho más estrecha.])[
  #cetz.canvas({
    import cetz.draw: *
    let brusca(t) = if (t >= 0.6 and t <= 3.6) or (t >= 4.6 and t <= 5.6) { 1 } else { 0 }
    let rampa(t, a, b, r) = if t < a or t > b { 0 } else if t < a + r { 0.5 - 0.5 * calc.cos(calc.pi * (t - a) / r) } else if t > b - r { 0.5 - 0.5 * calc.cos(calc.pi * (b - t) / r) } else { 1 }
    let suave(t) = calc.max(rampa(t, 0.6, 3.6, 0.35), rampa(t, 4.6, 5.6, 0.35))
    let y2 = -2.3
    for y0 in (0, y2) {
      line((0, y0), (6.8, y0), mark: (end: ">", fill: black), stroke: 0.5pt + col.gris)
      content((6.8, y0), anchor: "north-east", padding: 3pt, _t1-t[$t$])
    }
    onda(t => 0.8 * brusca(t) * calc.sin(2 * calc.pi * 5 * t), 0, 6.4, n: 1600, stroke: 0.7pt + col.senal1)
    onda(t => y2 + 0.8 * suave(t) * calc.sin(2 * calc.pi * 5 * t), 0, 6.4, n: 1600, stroke: 0.7pt + col.senal1)
    onda(t => 0.85 * brusca(t), 0, 6.4, n: 640, stroke: (paint: col.naranja, thickness: 0.7pt, dash: "dashed"))
    onda(t => y2 + 0.85 * suave(t), 0, 6.4, n: 640, stroke: (paint: col.naranja, thickness: 0.7pt, dash: "dashed"))
    content((6.5, 0.45), anchor: "west", _t1-t(fill: col.naranja)[envolvente])
    content((-0.2, 0), anchor: "east", _t1-t[flancos bruscos])
    content((-0.2, y2), anchor: "east", _t1-t[flancos suaves])
    content((2.1, 0.95), anchor: "south", _t1-t[raya])
    content((5.1, 0.95), anchor: "south", _t1-t[punto])
  })
] <t1-fig-cw>

A velocidades normales (unas 25 palabras por minuto) una emisión de CW bien manipulada ocupa del orden de 100 Hz. Es la emisión más estrecha que usa el radioaficionado, y por eso los filtros de CW son de 250 a 500 Hz.

En *AM* altera la amplitud. Con moduladora $cos(omega_m t)$ y portadora $cos(omega_c t)$,
$ s(t) = A [1 + m cos(omega_m t)] cos(omega_c t), $
donde $m$ es el *índice de modulación*. Desarrollando el producto con $cos a cos b = 1/2 [cos(a - b) + cos(a + b)]$:
$ s(t) = A cos(omega_c t) + (m A) / 2 cos[(omega_c - omega_m) t] + (m A) / 2 cos[(omega_c + omega_m) t]. $
El espectro son tres rayas: la portadora y dos *bandas laterales* en $f_c plus.minus f_m$ (@t1-fig-am-espectro), ambas con la misma información. La anchura de banda es $B = 2 f_(m, "máx")$ (unos 6 kHz para voz). Si $m > 1$ hay *sobremodulación*: la envolvente se recorta y aparecen distorsión y _splatter_ (@t1-fig-am-envolvente).

#ptitulo[De dónde salen las bandas laterales] Multiplicar dos sinusoides produce la suma y la diferencia de sus frecuencias: es la identidad de arriba, y es lo mismo que hace un mezclador (#ver(<sec-mezclador>)). Una portadora de 7,100 MHz modulada por un tono de 1 kHz da rayas en 7,099, 7,100 y 7,101 MHz. Con voz, cada frecuencia de la voz produce su pareja de rayas, y el resultado son dos *bandas* (@t1-fig-voz-am-ssb). Un modulador en anillo hace exactamente ese producto: en #falstad("ringmod.txt") se ven las frecuencias suma y diferencia.

#circuito(caption: [Espectro de una emisión de AM con moduladora sinusoidal: portadora y dos bandas laterales de amplitud $m A slash 2$. La SSB (J3E) suprime la portadora y una de las bandas: misma información en la mitad de anchura y con toda la potencia útil.])[
  #cetz.canvas({
    import cetz.draw: *
    ejes(0, 9.0, 0, 3.1, etq-x: $f$, etq-y: [amplitud])
    line((4.5, 0), (4.5, 2.3), stroke: 1.8pt + col.senal1)
    line((2.7, 0), (2.7, 1.15), stroke: 1.8pt + col.naranja)
    line((6.3, 0), (6.3, 1.15), stroke: 1.8pt + col.naranja)
    content((4.5, 2.35), anchor: "south", _t1-t(fill: col.senal1)[portadora ($f_c$)])
    content((2.7, 1.22), anchor: "south", _t1-t(fill: col.naranja)[banda lateral inferior])
    content((6.3, 1.22), anchor: "south", _t1-t(fill: col.naranja)[banda lateral superior])
    content((2.7, -0.1), anchor: "north", _t1-t[$f_c - f_m$])
    content((4.5, -0.1), anchor: "north", _t1-t[$f_c$])
    content((6.3, -0.1), anchor: "north", _t1-t[$f_c + f_m$])
    line((2.7, -0.6), (6.3, -0.6), .._t1-cota)
    content((4.5, -0.68), anchor: "north", _t1-t[$B = 2 f_m$])
  })
] <t1-fig-am-espectro>

#circuito(sim: fc.at("modulacion-am"), caption: [Emisión de AM con índice de modulación $m = (A_"máx" - A_"mín") slash (A_"máx" + A_"mín") = 0,5$. La envolvente reproduce la señal moduladora; si $m$ supera el 100 % (sobremodulación) la envolvente se recorta y aparecen distorsión y emisiones fuera del canal.])[
  #cetz.canvas({
    import cetz.draw: *
    let s = 1.1
    let env(t) = 1 + 0.5 * calc.cos(2 * calc.pi * (t - 2) / 8)
    ejes(0, 8.9, -2.2, 2.3, etq-x: $t$, etq-y: $v(t)$)
    onda(t => s * env(t) * calc.cos(4 * calc.pi * t), 0, 8.4, n: 900, stroke: 0.8pt + col.senal1)
    onda(t => s * env(t), 0, 8.4, stroke: (paint: col.naranja, thickness: 0.9pt, dash: "dashed"))
    onda(t => -s * env(t), 0, 8.4, stroke: (paint: col.naranja, thickness: 0.9pt, dash: "dashed"))
    line((2, 0), (2, 1.5 * s), .._t1-flecha)
    content((2.1, 1.5 * s + 0.08), anchor: "south-west", _t1-t[$A_"máx"$])
    line((6, 0), (6, 0.5 * s), .._t1-flecha)
    content((6, 0.5 * s + 0.12), anchor: "south", _t1-t[$A_"mín"$])
    content((8.7, 1.28), anchor: "south-east", _t1-t(fill: col.naranja)[envolvente (moduladora, BF)])
    content((0.2, -1.8), anchor: "north-west", _t1-t(fill: col.senal1)[portadora modulada en amplitud (RF)])
  })
] <t1-fig-am-envolvente>

#circuito(caption: [(a) Con $m = 1$ la envolvente llega justo a cero en sus mínimos: es el máximo sin distorsión. (b) Con $m = 1,5$ la moduladora pediría una amplitud negativa (línea de puntos), que el transmisor no puede dar: la portadora se corta durante parte del ciclo, la envolvente deja de ser una sinusoide y sus armónicos ensanchan la emisión (_splatter_).])[
  #let _t1-am(m) = cetz.canvas({
    import cetz.draw: *
    let w = 5.4
    let sc = 0.62
    let env(t) = calc.max(0, 1 + m * calc.cos(2 * calc.pi * t / w))
    ejes(0, w + 0.3, -1.7, 1.85, etq-x: $t$)
    onda(t => sc * env(t) * calc.sin(2 * calc.pi * 4 * t), 0, w, n: 900, stroke: 0.7pt + col.senal1)
    onda(t => sc * env(t), 0, w, stroke: (paint: col.naranja, thickness: 0.9pt, dash: "dashed"))
    onda(t => -sc * env(t), 0, w, stroke: (paint: col.naranja, thickness: 0.9pt, dash: "dashed"))
    if m > 1 {
      onda(t => sc * (1 + m * calc.cos(2 * calc.pi * t / w)), 1.6, 3.8, stroke: (paint: col.gris, thickness: 0.7pt, dash: "dotted"))
      content((w / 2, -0.45), anchor: "north", _t1-t[portadora cortada])
    }
  })
  #grid(
    columns: 2,
    column-gutter: 1cm,
    _t1-panel([(a) $m = 1$ (100 %)], _t1-am(1)),
    _t1-panel([(b) $m = 1,5$: sobremodulación], _t1-am(1.5)),
  )
] <t1-fig-sobremodulacion>

La energía también se reparte entre esas rayas. La portadora transporta $P_c$; cada banda lateral, $(m^2 slash 4) P_c$ (su amplitud es $m A slash 2$ y la potencia va con el cuadrado de la amplitud). En total,
$ P_t = P_c (1 + m^2 / 2), $
lo que dice algo incómodo: incluso al 100 % de modulación ($m = 1$), dos tercios de la potencia se van en la portadora — que no lleva información — y cada banda lateral se queda con un sexto. Es el argumento cuantitativo de la SSB: suprimir lo redundante e invertir todo en la única raya útil.

#ejemplo[
Portadora de 100 W modulada al 100 %: cada banda lateral lleva $(1^2 slash 4) dot 100 = 25$ W y el total es $100 (1 + 1 slash 2) = 150$ W. De esos 150 W, solo los 25 W de una banda son imprescindibles para llevar la voz. Con $m = 0,5$, más típico con voz, cada banda baja a 6,25 W.
]

=== Banda lateral única (SSB)

La observación clave: la portadora (que se lleva la mayor parte de la potencia) y una de las bandas son redundantes. La *banda lateral única* (SSB, clase J3E) suprime ambas y transmite solo una banda lateral: misma información, la mitad de anchura ($tilde 2,7$ kHz) y toda la potencia concentrada en lo útil. A cambio, el receptor debe reinsertar la portadora (oscilador BFO y detector de producto, tema T4; #ver(<sec-detector>)).

#ptitulo[USB y LSB] Se puede transmitir la banda superior (USB) o la inferior (LSB): las dos llevan la misma voz. Por costumbre, en HF se usa LSB por debajo de 10 MHz (bandas de 160, 80 y 40 m) y USB por encima, y también en VHF y UHF.

#circuito(caption: [Espectro de una emisión con voz (300–3000 Hz). (a) AM (A3E): portadora y dos bandas laterales, cada una imagen especular de la otra; ocupa 6 kHz. (b) SSB de banda superior (J3E): solo queda una banda; ocupa unos 2,7 kHz y toda la potencia va a la información.])[
  #cetz.canvas({
    import cetz.draw: *
    let s = 0.85
    let c = 4 * s
    let banda(y0, signo, ..estilo) = line((c + signo * 0.3 * s, y0), (c + signo * 0.3 * s, y0 + 1.0), (c + signo * 3 * s, y0 + 0.45), (c + signo * 3 * s, y0), close: true, ..estilo)
    let relleno = (fill: col.naranja.lighten(70%), stroke: 0.8pt + col.naranja)
    let hueco = (fill: none, stroke: (paint: col.gris, thickness: 0.6pt, dash: "dashed"))
    // (a) AM
    let ya = 3.2
    line((0, ya), (8 * s + 0.4, ya), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((8 * s + 0.4, ya), anchor: "north-east", padding: 3pt, _t1-t[$f$])
    banda(ya, -1, ..relleno)
    banda(ya, 1, ..relleno)
    line((c, ya), (c, ya + 1.6), stroke: 1.6pt + col.senal1)
    content((0, ya + 1.8), anchor: "west", _t1-t[*(a)* AM, A3E])
    content((c - 3 * s, ya - 0.08), anchor: "north", _t1-t[$f_c - 3$ kHz])
    content((c, ya - 0.08), anchor: "north", _t1-t[$f_c$])
    content((c + 3 * s, ya - 0.08), anchor: "north", _t1-t[$f_c + 3$ kHz])
    content((c - 1.65 * s, ya + 1.0), anchor: "south", _t1-t(fill: col.naranja)[LSB])
    content((c + 1.65 * s, ya + 1.0), anchor: "south", _t1-t(fill: col.naranja)[USB])
    line((c - 3 * s, ya - 0.6), (c + 3 * s, ya - 0.6), .._t1-cota)
    content((c + 3.1 * s, ya - 0.6), anchor: "west", _t1-t[$B = 6$ kHz])
    // (b) SSB
    let yb = 0
    line((0, yb), (8 * s + 0.4, yb), mark: (end: ">", fill: black), stroke: 0.6pt)
    content((8 * s + 0.4, yb), anchor: "north-east", padding: 3pt, _t1-t[$f$])
    banda(yb, -1, ..hueco)
    banda(yb, 1, ..relleno)
    line((c, yb), (c, yb + 1.6), stroke: (paint: col.gris, thickness: 0.8pt, dash: "dashed"))
    content((0, yb + 1.8), anchor: "west", _t1-t[*(b)* SSB (USB), J3E])
    content((c + 0.12, yb + 1.45), anchor: "west", _t1-t(fill: col.gris)[portadora suprimida])
    content((c - 1.65 * s, yb + 1.0), anchor: "south", _t1-t(fill: col.gris)[banda suprimida])
    content((c, yb - 0.08), anchor: "north", _t1-t[$f_c$])
    line((c + 0.3 * s, yb - 0.6), (c + 3 * s, yb - 0.6), .._t1-cota)
    content((c + 3.1 * s, yb - 0.6), anchor: "west", _t1-t[$B approx 2,7$ kHz])
  })
] <t1-fig-voz-am-ssb>


=== FM y PM

En *FM* la amplitud es constante y lo que varía es la frecuencia instantánea, con una *desviación* máxima $Delta f$ proporcional a la amplitud de la moduladora. El índice de modulación es
$ m = (Delta f) / f_m, $
y la anchura de banda se estima con la regla de Carson, $B approx 2(Delta f + f_m)$. La envolvente constante hace a la FM inmune al ruido de amplitud y permite amplificadores no lineales de alto rendimiento.

#ejemplo(titulo: [La regla de Carson con números])[
FM de banda estrecha de radioaficionado: desviación $Delta f = 2,5$ kHz y voz hasta $f_m = 3$ kHz. $B approx 2 (2,5 + 3) = 11$ kHz: cabe en un canal de 12,5 kHz. La FM comercial usa $Delta f = 75$ kHz y audio hasta 15 kHz: $B approx 2 (75 + 15) = 180$ kHz, y por eso cada emisora necesita un canal de unos 200 kHz. Los índices son $m = 2,5 slash 3 approx 0,83$ en el primer caso y $m = 75 slash 15 = 5$ en el segundo.
]

El precio de la FM es espectral: en rigor, una portadora modulada en frecuencia genera _infinitas_ bandas laterales espaciadas $f_m$, con amplitudes que siguen las funciones de Bessel de orden creciente evaluadas en $m$; la regla de Carson funciona porque más allá de $Delta f + f_m$ las componentes son ya despreciables. A cambio aparece el _efecto captura_: de dos señales de FM en el mismo canal, el receptor engancha casi por completo la más fuerte y suprime la débil — al contrario que en AM, donde ambas se oyen mezcladas.

#circuito(sim: fc.at("modulacion-fm"), caption: [(a) FM en el tiempo: la amplitud no cambia; la frecuencia instantánea sube cuando la moduladora (arriba) es positiva y baja cuando es negativa. (b) Espectro de FM con $m = 2$: rayas separadas $f_m$, con alturas $|J_n (2)|$ dadas por las funciones de Bessel. Más allá de $plus.minus 3 f_m$ (la anchura de Carson, $2 (Delta f + f_m) = 6 f_m$) las rayas son ya despreciables.])[
  #grid(
    columns: 1,
    row-gutter: 0.9em,
    _t1-panel([(a) Señal de FM y su moduladora], cetz.canvas({
      import cetz.draw: *
      line((0, 2.0), (8.2, 2.0), stroke: 0.4pt + col.gris)
      onda(x => 2.0 + 0.45 * calc.cos(2 * calc.pi * x / 8), 0, 8, stroke: 1pt + col.senal2)
      content((-0.15, 2.0), anchor: "east", _t1-t(fill: col.senal2)[moduladora])
      line((0, 0), (8.2, 0), stroke: 0.4pt + col.gris)
      onda(x => calc.sin(2 * calc.pi * 3 * x + 12 * calc.sin(2 * calc.pi * x / 8)), 0, 8, n: 1400, stroke: 0.7pt + col.senal1)
      content((-0.15, 0), anchor: "east", _t1-t(fill: col.senal1)[señal de FM])
      content((0.6, -1.12), anchor: "north", _t1-t[$f$ alta])
      content((4, -1.12), anchor: "north", _t1-t[$f$ baja])
      content((7.4, -1.12), anchor: "north", _t1-t[$f$ alta])
    })),
    _t1-panel([(b) Espectro con $m = 2$], cetz.canvas({
      import cetz.draw: *
      let jn = (0.2239, 0.5767, 0.3528, 0.1289, 0.0340, 0.0070)
      let c = 3.6
      let d = 0.6
      ejes(0, 7.4, 0, 1.9, etq-x: $f$)
      for k in range(-5, 6) {
        let h = jn.at(calc.abs(k)) * 2.6
        line((c + d * k, 0), (c + d * k, h), stroke: 1.6pt + (if k == 0 { col.senal1 } else { col.naranja }))
      }
      content((c, -0.08), anchor: "north", _t1-t[$f_c$])
      line((c + d, 1.75), (c + 2 * d, 1.75), .._t1-cota)
      content((c + 1.5 * d, 1.8), anchor: "south", padding: 1pt, _t1-t[$f_m$])
      line((c - 3 * d, -0.6), (c + 3 * d, -0.6), .._t1-cota)
      content((c, -0.68), anchor: "north", _t1-t[$B approx 2 (Delta f + f_m) = 6 f_m$])
    })),
  )
] <t1-fig-fm>

La *modulación de fase* (PM) completa la familia: aquí es la fase de la portadora la que sigue a la moduladora, también con amplitud constante. Su parentesco con la FM es estrecho — la fase es la integral de la frecuencia —, hasta el punto de que un modulador de fase alimentado con la moduladora previamente integrada produce FM. Es la llamada _FM indirecta_, que permite modular después de un oscilador a cristal, estable pero imposible de desviar en frecuencia directamente. En la práctica, FM y PM se agrupan bajo el nombre común de *modulación angular*.

=== Modulación digital

En *modulación digital* la moduladora es un tren de símbolos: FSK salta entre frecuencias, PSK entre fases (2PSK: dos fases; 4PSK: cuatro) y QAM combina amplitud y fase. Si cada símbolo transporta $log_2 M$ bits ($M$ estados), la velocidad binaria es esa cantidad por la *velocidad de símbolo*; la anchura de banda la fija la velocidad de símbolo, no la de bit: lo que ocupa espectro es la rapidez con que cambia la forma de onda, y meter más bits en cada símbolo (más estados $M$) sube la velocidad binaria sin acelerar esos cambios — por eso QAM transporta más bits en el mismo ancho. Para proteger los datos se añade detección de errores (*CRC*) o corrección directa (*FEC*).

#ejemplo[
A 2400 símbolos por segundo (2400 baudios), 2PSK lleva 1 bit por símbolo: 2400 bit/s. 4PSK lleva $log_2 4 = 2$ bits: 4800 bit/s. 16QAM lleva $log_2 16 = 4$ bits: 9600 bit/s. Los tres ocupan aproximadamente el mismo ancho de banda, porque su forma de onda cambia al mismo ritmo. El precio es que los estados están más juntos y el ruido los confunde antes.
]

#circuito(caption: [Los mismos bits (1 0 1 1 0) con dos modulaciones digitales. En FSK un 1 es una frecuencia y un 0 otra. En 2PSK la frecuencia no cambia: cada 0 se transmite con la fase de la portadora invertida 180°, y se ve el salto en las transiciones.])[
  #cetz.canvas({
    import cetz.draw: *
    let tb = 1.4
    let bits = (1, 0, 1, 1, 0)
    let bit(x) = bits.at(calc.min(int(x / tb), 4))
    let t0(x) = calc.min(int(x / tb), 4) * tb
    for i in range(6) {
      line((i * tb, 1.15), (i * tb, -4.1), .._t1-guia)
    }
    for (i, b) in bits.enumerate() {
      content((i * tb + tb / 2, 1.0), anchor: "south", _t1-t[*#b*])
    }
    // datos
    let pts = ()
    for (i, b) in bits.enumerate() {
      let y = if b == 1 { 0.8 } else { 0 }
      pts.push((i * tb, y))
      pts.push(((i + 1) * tb, y))
    }
    line((0, 0), (7.2, 0), stroke: 0.4pt + col.gris)
    line(..pts, stroke: 1.1pt + col.senal2)
    content((-0.2, 0.4), anchor: "east", _t1-t[datos])
    // FSK
    let yf = -1.7
    line((0, yf), (7.2, yf), stroke: 0.4pt + col.gris)
    onda(x => yf + 0.6 * calc.sin(2 * calc.pi * (if bit(x) == 1 { 4 } else { 2 }) * (x - t0(x)) / tb), 0, 7, n: 900, stroke: 0.8pt + col.senal1)
    content((-0.2, yf), anchor: "east", _t1-t[FSK])
    // PSK
    let yp = -3.4
    line((0, yp), (7.2, yp), stroke: 0.4pt + col.gris)
    onda(x => yp + 0.6 * calc.sin(2 * calc.pi * 3 * (x - t0(x)) / tb + (if bit(x) == 1 { 0 } else { calc.pi })), 0, 7, n: 900, stroke: 0.8pt + col.senal1)
    content((-0.2, yp), anchor: "east", _t1-t[2PSK])
  })
] <t1-fig-digital>


#figure(
  {
  set par(justify: false)
  table(
    columns: (auto, auto, 1.3fr, auto, 1.2fr),
    align: (left, center, left, center, left),
    table.header([Modo], [Clase], [Qué lleva la información], [Ancho típico], [Cómo se demodula]),
    [CW], [A1A], [portadora encendida o apagada], [≈ 100 Hz], [BFO + detector de producto],
    [AM], [A3E], [amplitud; portadora + 2 bandas], [6 kHz], [detector de envolvente (diodo)],
    [SSB], [J3E], [una banda lateral, sin portadora], [2,7 kHz], [BFO + detector de producto],
    [FM], [F3E], [frecuencia], [11–16 kHz \ (banda estrecha)], [discriminador de FM],
    [Digital], [—], [símbolos (frecuencia, fase, amplitud)], [según la velocidad \ de símbolo], [demodulador o DSP],
  )
  },
  caption: [Resumen de las emisiones del tema. El receptor de cada una se estudia en el tema T4; la cadena completa de una emisora, en #ver(<sec-radio-entera>).],
) <t1-tab-modos>

#ojo[
- AM varía la *amplitud* (T1.25); FM, la frecuencia; PM, la fase.
- Sobremodulación: $m > 1$, es decir, más del 100 % (T1.26). No significa «demasiada potencia».
- SSB: *una* banda lateral y *sin* portadora (T1.27); su anchura es de unos 2,7 kHz (T1.28). 6 kHz es la AM completa, 500 Hz un filtro de CW y 12,5 kHz un canal de FM.
- Portadora central y dos bandas simétricas: AM (T1.34). La FM daría muchas rayas; la SSB, una sola banda.
- La FM comercial (87,5–108 MHz) está en VHF (T1.29).
- Modular sirve para que la portadora lleve la información (T1.46): no aumenta la potencia ni acorta la antena.
]

#q("T1.25", "a",
  [En la modulación de amplitud (AM), la señal moduladora hace variar:],
  ([la amplitud de la portadora], [la frecuencia de la portadora], [la fase de la portadora], [la impedancia de la antena]),
  sol: [En AM la información va en la amplitud de la portadora: la envolvente reproduce la señal moduladora (#ref(<t1-fig-am-envolvente>, supplement: [figura])). En FM lo que varía es la frecuencia.],
)

#q("T1.26", "d",
  [Decimos que una emisión de AM está sobremodulada cuando:],
  ([la potencia de salida es excesiva], [la anchura de banda es menor que la necesaria], [la portadora está suprimida], [el índice de modulación es superior al 100 %]),
  sol: [Hay sobremodulación cuando el índice $m$ supera el 100 % ($m > 1$): la envolvente se recorta y aparecen distorsión y _splatter_ en los canales adyacentes.],
)

#q("T1.27", "b",
  [En una emisión de banda lateral única (SSB):],
  ([se transmiten las dos bandas laterales sin portadora], [se transmite una sola banda lateral sin portadora], [se transmite solo la portadora], [se transmite la portadora con las dos bandas laterales]),
  sol: [En SSB se suprime la portadora y una de las dos bandas laterales: toda la potencia se concentra en la banda lateral restante, que es la que lleva la información.],
)

#q("T1.28", "a",
  [La anchura de banda de una emisión de telefonía en banda lateral única con portadora suprimida (J3E) es aproximadamente:],
  ([2,7 kHz], [500 Hz], [6 kHz], [12,5 kHz]),
  sol: [La anchura de banda de J3E es la de la voz útil: $tilde 2,7$ kHz (300–3000 Hz). Los 6 kHz del distractor corresponden a AM completa (A3E).],
)

#q("T1.29", "c",
  [La radiodifusión sonora con modulación de frecuencia (FM comercial) utiliza la banda de:],
  ([HF], [MF], [VHF], [SHF]),
  sol: [La radiodifusión de FM comercial ocupa 87,5–108 MHz, dentro de la banda de VHF (30–300 MHz).],
)

== Potencia, decibelios y DSP <t1-sec-potencia>

=== El decibelio

#motivacion[
El transmisor entrega 100 W. Una señal que llega a un receptor lejano puede ser de $10^(-13)$ W. Entre medias hay una línea que pierde, una antena que gana y un trayecto que atenúa billones de veces. Multiplicar y dividir números así es incómodo y es fácil equivocarse en un cero. El decibelio convierte cada multiplicación en una suma.
]

El *decibelio* comprime relaciones de potencia en una escala logarítmica:
$ G ("dB") = 10 log_10 P_2 / P_1, $
(con tensiones sobre la misma impedancia, $20 log_10 (V_2 slash V_1)$, porque $P prop V^2$). Su gracia es que las ganancias encadenadas se _suman_: un amplificador de 20 dB tras un atenuador de $-6$ dB son $+14$ dB netos. Las referencias que hay que dominar:
$ times 2 = +3 "dB", quad quad times 4 = +6 "dB", quad quad times 10 = +10 "dB", quad quad times 100 = +20 "dB". $

#ptitulo[Por qué se suman] El logaritmo de un producto es la suma de los logaritmos: $log(a b) = log a + log b$. Una ganancia de ×100 seguida de una pérdida de ×1/4 da ×25 neto; en decibelios, $20 - 6 = 14$ dB. Y $times 2 = 3$ dB porque $log_10 2 approx 0,301$. Con tensiones el factor es 20 porque la potencia va con el cuadrado de la tensión, y el logaritmo de un cuadrado es el doble del logaritmo: doblar la tensión es cuadruplicar la potencia, $+6$ dB.

#figure(
  table(
    columns: (1fr, auto, 1fr),
    align: center,
    table.header([Relación de potencias], [dB], [Relación de tensiones (misma impedancia)]),
    [× 1,26], [+1], [× 1,12],
    [× 2], [+3], [× 1,41],
    [× 4], [+6], [× 2],
    [× 5], [+7], [× 2,24],
    [× 8], [+9], [× 2,83],
    [× 10], [+10], [× 3,16],
    [× 100], [+20], [× 10],
    [× 1000], [+30], [× 31,6],
    [× 1/2], [−3], [× 0,707],
    [× 1/10], [−10], [× 0,316],
    [× 1/100], [−20], [× 0,1],
  ),
  caption: [Tabla de decibelios. La columna de tensiones es la raíz cuadrada de la de potencias: el mismo número de decibelios.],
) <t1-tab-db>

#truco(titulo: [Decibelios de cabeza])[
Descompón la relación en factores 10 y 2: cada × 10 suma 10 dB y cada × 2 suma 3 dB; dividir resta.
- × 40 = 10 × 2 × 2: $10 + 3 + 3 = 16$ dB.
- × 50 = 100 ÷ 2: $20 - 3 = 17$ dB.
- × 0,25 = ÷ 2 ÷ 2: $-6$ dB.
- Al revés: 23 dB = 20 + 3, es decir, × 200; 27 dB = 30 − 3, es decir, × 500; 13 dB, × 20.
- En dBm: 5 W = 10 W ÷ 2, es decir, $40 - 3 = 37$ dBm; y 46 dBm = 40 + 6, es decir, 40 W.
]

Con un subíndice, el decibelio pasa de relación a valor absoluto: *dBm* referido a 1 mW y *dBW* referido a 1 W. Así, 1 W = 30 dBm = 0 dBW, y 100 W = 50 dBm.

#ejemplo[
Un transmisor de 10 W (40 dBm) alimenta, a través de una línea que pierde 3 dB, una antena de 6 dB de ganancia. Potencia efectiva radiada: $40 - 3 + 6 = 43$ dBm = 20 W. En decibelios, el balance completo de un enlace se reduce a sumas y restas.
]

#circuito(caption: [El balance del ejemplo, bloque a bloque. Debajo de cada flecha, la potencia en ese punto: los decibelios se suman al pasar por cada bloque.])[
  #set text(size: 8.5pt)
  #diagram(
    node-stroke: 0.7pt,
    node-corner-radius: 2pt,
    spacing: (19mm, 6mm),
    node((0, 0), [Transmisor \ 10 W], shape: rect),
    edge("-|>", [40 dBm \ (10 W)], label-side: right),
    node((1, 0), [Línea \ −3 dB], shape: rect),
    edge("-|>", [37 dBm \ (5 W)], label-side: right),
    node((2, 0), [Antena \ +6 dB], shape: rect),
    edge("-|>", [43 dBm \ (20 W)], label-side: right),
    node((3, 0), [potencia \ radiada], stroke: none),
  )
] <t1-fig-balance>

#ptitulo[Del transmisor al receptor] La escala abarca todo: 100 W son +50 dBm, y una señal de intensidad S9 en HF son −73 dBm (unos 50 μV en 50 Ω). Entre una y otra hay 123 dB, una relación de potencias de unos $2 times 10^12$, que en decibelios se escribe con tres cifras.

#ojo[
- Duplicar la potencia: +3 dB (T1.30). +6 dB es cuadruplicar la potencia, o duplicar la *tensión*.
- dBm y dBW se diferencian en 30 dB: 0 dBW = 30 dBm = 1 W.
- Los decibelios de ganancias y pérdidas se suman y se restan; los vatios, no.
]

=== Máxima transferencia de potencia

#motivacion[
El transmisor tiene una resistencia de salida y la antena, una de entrada. ¿Qué antena saca más potencia del transmisor: una de resistencia muy baja, que deja pasar mucha corriente, o una muy alta, que recibe mucha tensión? Ni una ni otra.
]

La *máxima transferencia de potencia* de una fuente a una carga se produce cuando sus impedancias están adaptadas (en resistivo, $R_L = R_g$) — con una carga muy grande apenas circula corriente y con una muy pequeña apenas cae tensión en ella; el producto $P = V I$ que recibe la carga es máximo en el punto intermedio $R_L = R_g$ —; es el motivo de que transmisor, línea y antena compartan los 50 Ω (temas T5 y T6).

#circuito(caption: [(a) Un generador de fem $epsilon$ y resistencia interna $R_g$ alimenta una carga $R_L$. (b) Potencia en la carga, relativa a la máxima, según $R_L slash R_g$: el máximo está en $R_L = R_g$. A la mitad o al doble del valor adaptado se pierde poco (un 11 %); muy lejos de él, casi todo.])[
  #grid(
    columns: 2,
    column-gutter: 1.2cm,
    _t1-panel([(a) Generador y carga], esquema({
      import zap: *
      import cetz.draw: content, rect
      rect((-0.95, -0.45), (2.25, 3.8), stroke: (paint: col.gris, dash: "dashed", thickness: 0.6pt))
      content((0.65, -0.45), anchor: "north", padding: 2pt, _t1-t(fill: col.gris)[generador])
      acvsource("g", (0, 0.4), (0, 2.4))
      content((-0.55, 1.4), anchor: "east", $epsilon$)
      wire((0, 2.4), (0, 3))
      resistor("rg", (0, 3), (1.9, 3), label: $R_g$)
      wire((1.9, 3), (3.8, 3))
      wire((0, 0.4), (0, 0))
      wire((0, 0), (3.8, 0))
      resistor("rl", (3.8, 3), (3.8, 0), label: $R_L$)
      _t1-borne((2.8, 3))
      _t1-borne((2.8, 0))
    })),
    _t1-panel([(b) Potencia en la carga], cetz.canvas({
      import cetz.draw: *
      let sy = 2.3
      ejes(0, 5.9, 0, 3.0, etq-x: $R_L slash R_g$, etq-y: $P_L slash P_"máx"$)
      onda(x => sy * 4 * x / calc.pow(1 + x, 2), 0, 5.0, n: 200, stroke: 1.2pt + col.senal1)
      line((1, 0), (1, sy), .._t1-guia)
      line((0, sy), (1, sy), .._t1-guia)
      for x in (1, 2, 3, 4) {
        line((x, 0), (x, -0.06), stroke: 0.5pt)
        content((x, -0.1), anchor: "north", _t1-t[#x])
      }
      content((-0.08, sy), anchor: "east", _t1-t[1])
      content((-0.08, sy / 2), anchor: "east", _t1-t[0,5])
      line((0, sy / 2), (-0.06, sy / 2), stroke: 0.5pt)
      content((1.12, sy + 0.08), anchor: "south-west", _t1-t[máximo: $R_L = R_g$])
    })),
  )
] <t1-fig-maxima-potencia>

#porque[
- La corriente es $I = epsilon slash (R_g + R_L)$, y la potencia en la carga, $P_L = I^2 R_L = epsilon^2 R_L slash (R_g + R_L)^2$.
- Si $R_L$ es muy pequeña, la corriente es grande, pero casi toda la tensión se queda en $R_g$. Si $R_L$ es muy grande, casi toda la tensión cae en la carga, pero apenas circula corriente. En los dos extremos el producto $V I$ de la carga es pequeño.
- El máximo está en $R_L = R_g$ y vale $P_"máx" = epsilon^2 slash (4 R_g)$. En este modelo, en ese punto se disipa la misma potencia dentro del generador que en la carga: la adaptación hace máxima la potencia *transferida*, no el rendimiento. Un amplificador de RF no es una resistencia que se calienta así: sus «50 Ω» son la carga para la que está diseñado, y su rendimiento depende de la clase de la etapa.
]

#ejemplo[
Con $epsilon = 10$ V y $R_g = 50 "Ω"$. Si $R_L = 50 "Ω"$: $I = 10 slash 100 = 0,1$ A y $P_L = 0,1^2 dot 50 = 0,5$ W. Si $R_L = 25 "Ω"$: $I approx 0,133$ A y $P_L approx 0,44$ W. Si $R_L = 100 "Ω"$: $I approx 0,067$ A y $P_L approx 0,44$ W. El máximo está en el centro, con $R_L = R_g$.
]

Qué es la impedancia se explica en #ver(<sec-impedancia>). Cómo se adapta una antena que no presenta 50 Ω —con redes en L, en pi o en T— se explica en #ver(<sec-redes-adaptacion>).

=== Potencia de pico, rendimiento y factor de potencia

En AM interesa además distinguir la potencia media de la *potencia en la cresta de la envolvente* (p.c.e.): la de pico en el máximo de modulación, siempre mayor que la media. El *rendimiento* de una etapa relaciona sus potencias de salida y de alimentación, $eta = P_"sal" slash P_"cc"$: la fracción de la potencia consumida que se convierte en señal útil, y el resto se disipa en calor (de ahí las clases de amplificación C y AB de T3, de mayor $eta$).

#ejemplo(titulo: [Potencia de pico en AM])[
Portadora de AM de 100 W con $m = 1$: en la cresta de la envolvente la amplitud es el doble, $A (1 + m) = 2 A$, y la potencia, el cuádruple: p.c.e. = 400 W, frente a 150 W de media. En SSB no hay portadora: sin voz no sale nada, y con voz la potencia media es solo una fracción de la p.c.e.
]

#ejemplo(titulo: [Rendimiento de un transceptor])[
Un transceptor que da 100 W de RF tomando 20 A a 13,8 V consume $13,8 dot 20 = 276$ W: $eta = 100 slash 276 approx 36$ %. Los 176 W restantes son calor que el disipador tiene que evacuar. Las clases de amplificación y sus rendimientos típicos se explican en #ver(<sec-clases>).
]

#ptitulo[Potencia en alterna y factor de potencia] En alterna, la potencia instantánea es $p(t) = v(t) dot i(t)$. En una resistencia la corriente sigue a la tensión sin retraso: las dos están *en fase* (T1.44), su producto nunca es negativo, y la potencia media es $V_"ef" thin I_"ef"$ (@t1-fig-potencia-alterna a). Con una bobina o un condensador ideales, la corriente va desfasada 90°. Durante un cuarto de ciclo el componente toma energía y la guarda en su campo, y durante el siguiente la devuelve (@t1-fig-potencia-alterna b): la potencia media es cero. En general, con un desfase $phi$ entre tensión y corriente,
$ P = V_"ef" thin I_"ef" cos phi, $
y el *factor de potencia* $cos phi$ (T1.35) es la fracción de la potencia aparente $S = V_"ef" thin I_"ef"$, en voltamperios, que se convierte de verdad en trabajo o en calor. Vale 1 en un circuito resistivo y 0 en uno puramente reactivo. Las reactancias que producen ese desfase se explican en #ver(<sec-reactancia>). En el simulador puedes ver cómo la corriente se retrasa respecto a la tensión en una bobina: #falstad("inductac.txt")

#circuito(caption: [Tensión $v$ (azul), corriente $i$ (roja discontinua) y potencia instantánea $p = v i$ (verde, sombreada). (a) En una resistencia, $v$ e $i$ van en fase: $p$ nunca es negativa y su media (línea de puntos) es $V_"ef" thin I_"ef"$. (b) Con una reactancia pura, desfase de 90°: $p$ es positiva y negativa a partes iguales; la energía va y vuelve, y la media es cero.])[
  #let _t1-fase(desfase) = cetz.canvas({
    import cetz.draw: *
    let w = 5.2
    let k = 4 * calc.pi / w
    let v(x) = calc.sin(k * x)
    let i(x) = 0.65 * calc.sin(k * x - desfase)
    let p(x) = v(x) * i(x)
    let pts = range(201).map(j => {
      let x = w * j / 200
      (x, p(x))
    })
    line((0, 0), ..pts, (w, 0), close: true, fill: col.verde.transparentize(70%), stroke: none)
    ejes(0, w + 0.35, -1.2, 1.4, etq-x: $t$)
    onda(p, 0, w, stroke: 0.8pt + col.verde)
    onda(i, 0, w, stroke: (paint: col.senal2, thickness: 1pt, dash: "dashed"))
    onda(v, 0, w, stroke: 1.1pt + col.senal1)
    let media = 0.65 / 2 * calc.cos(desfase)
    line((0, media), (w, media), stroke: (paint: col.verde.darken(20%), thickness: 0.7pt, dash: "dotted"))
  })
  #grid(
    columns: 2,
    column-gutter: 1cm,
    _t1-panel([(a) Resistencia: en fase], _t1-fase(0)),
    _t1-panel([(b) Reactancia pura: 90°], _t1-fase(calc.pi / 2)),
  )
] <t1-fig-potencia-alterna>

=== Procesado digital de señales

#motivacion[
Un filtro de 500 Hz para CW hecho con cristales de cuarzo es caro y solo sirve para eso. Si la señal se convierte en números, el mismo procesador puede ser hoy un filtro de 500 Hz, mañana uno de 2,7 kHz, un demodulador de FM o un reductor de ruido: basta cambiar el programa. Es lo que hace el DSP de los equipos modernos y de los receptores SDR.
]

El *procesado digital de señales* muestrea la señal analógica y opera con números. El *teorema de muestreo (Nyquist)* exige
$ f_s >= 2 f_"máx" : $
el factor 2 no es arbitrario: hacen falta al menos dos muestras por período para fijar una sinusoide, y con menos los mismos puntos encajan también en otra de frecuencia más baja. Por eso, por debajo del límite, las frecuencias altas se disfrazan de bajas (_aliasing_), y por eso todo conversor A/D va precedido de un filtro *antisolapamiento* (y todo D/A seguido de uno de reconstrucción).

#circuito(caption: [La cadena de un procesado digital. El filtro antisolapamiento quita todo lo que esté por encima de $f_s slash 2$ antes de muestrear; el conversor A/D convierte la señal en números; el DSP los procesa con un programa; el D/A y el filtro de reconstrucción devuelven una señal analógica.])[
  #set text(size: 8pt)
  #diagram(
    node-stroke: 0.7pt,
    node-corner-radius: 2pt,
    spacing: (6mm, 6mm),
    node((0, 0), [señal \ analógica], stroke: none),
    edge("-|>"),
    node((1, 0), [Filtro anti- \ solapamiento], shape: rect),
    edge("-|>"),
    node((2, 0), [A/D], shape: rect),
    edge("-|>"),
    node((3, 0), [DSP \ (programa)], shape: rect, fill: col.acento-claro),
    edge("-|>"),
    node((4, 0), [D/A], shape: rect),
    edge("-|>"),
    node((5, 0), [Filtro de \ reconstrucción], shape: rect),
    edge("-|>"),
    node((6, 0), [señal \ analógica], stroke: none),
  )
] <t1-fig-cadena-dsp>

#circuito(caption: [Aliasing. Una señal de 7 kHz (azul) muestreada a 8 kHz, por debajo de su Nyquist (14 kHz): las muestras (puntos) caen exactamente sobre una sinusoide de $8 - 7 = 1$ kHz (roja discontinua). Después de muestrear, nadie puede saber cuál de las dos era: el filtro antisolapamiento tiene que haber quitado los 7 kHz antes.])[
  #cetz.canvas({
    import cetz.draw: *
    let s = 0.9
    ejes(0, 8 * s + 0.4, -1.3, 1.5, etq-x: $t$)
    onda(x => calc.sin(2 * calc.pi * 7 / 8 * x / s), 0, 8 * s, n: 500, stroke: 0.9pt + col.senal1)
    onda(x => -calc.sin(2 * calc.pi / 8 * x / s), 0, 8 * s, stroke: (paint: col.senal2, thickness: 1.2pt, dash: "dashed"))
    for n in range(9) {
      let y = -calc.sin(2 * calc.pi * n / 8)
      line((n * s, 0), (n * s, y), stroke: 0.5pt + col.gris)
      circle((n * s, y), radius: 0.07, fill: black, stroke: none)
    }
    content((8 * s + 0.6, 0.9), anchor: "west", _t1-t(fill: col.senal1)[señal real: 7 kHz])
    content((8 * s + 0.6, 0.4), anchor: "west", _t1-t(fill: col.senal2)[alias: 1 kHz])
    content((8 * s + 0.6, -0.1), anchor: "west", _t1-t[• muestras a 8 kHz])
  })
] <t1-fig-aliasing>

#ejemplo[
Para voz hasta 3 kHz hacen falta al menos 6 kHz de muestreo (T1.32); la telefonía digital usa 8 kHz para dejar margen al filtro antisolapamiento. El audio de un CD llega a 20 kHz y se muestrea a 44,1 kHz. Si un tono de 5 kHz se cuela en un sistema que muestrea a 8 kHz, aparece en $8 - 5 = 3$ kHz: un tono que no existía.
]

La *cuantificación* redondea cada muestra a uno de $2^n$ niveles; cada bit añadido mejora la relación señal/ruido de cuantificación en unos 6 dB ($"SNR" approx 6,02 n + 1,76$ dB).

#circuito(caption: [Cuantificación con 3 bits: $2^3 = 8$ niveles, cada uno con su código binario (a la derecha). Cada muestra de la señal analógica (azul) se redondea al nivel más próximo y se mantiene hasta la siguiente (escalera roja). El error nunca pasa de medio escalón; con más bits, los escalones se estrechan y la escalera se pega a la curva.])[
  #cetz.canvas({
    import cetz.draw: *
    let s = 0.9
    let vy = 0.38
    let codigos = ("000", "001", "010", "011", "100", "101", "110", "111")
    for k in range(8) {
      let lv = -3.5 + k
      line((0, lv * vy), (8 * s, lv * vy), stroke: (paint: col.gris.lighten(30%), thickness: 0.3pt, dash: "dotted"))
      content((8 * s + 0.55, lv * vy), anchor: "west", text(size: 6.5pt, fill: col.gris, codigos.at(k)))
    }
    ejes(0, 8 * s + 0.2, -1.6, 1.75, etq-x: $t$)
    let y(t) = 3.4 * calc.sin(2 * calc.pi * t / 8)
    let q(t) = calc.min(3.5, calc.max(-3.5, calc.floor(y(t)) + 0.5))
    let pts = ()
    for n in range(16) {
      let ta = n * 0.5
      pts.push((ta * s, q(ta) * vy))
      pts.push(((ta + 0.5) * s, q(ta) * vy))
    }
    line(..pts, stroke: 1.1pt + col.senal2)
    onda(t => y(t / s) * vy, 0, 8 * s, stroke: 1pt + col.senal1)
    for n in range(16) {
      circle((n * 0.5 * s, y(n * 0.5) * vy), radius: 0.05, fill: black, stroke: none)
    }
  })
] <t1-fig-cuantificacion>

La cifra de los 6 dB por bit sale de un cálculo corto: el error de cuantificación se reparte uniformemente en $plus.minus q slash 2$ (con $q$ el tamaño del escalón), y una distribución uniforme de anchura $q$ tiene potencia media $q^2 slash 12$. Añadir un bit divide $q$ por 2 y la potencia de error por 4 — y 4 veces en potencia son $10 log_10 4 approx 6$ dB.

#ejemplo[
Un conversor de 8 bits da $6,02 dot 8 + 1,76 approx 50$ dB de relación señal/ruido de cuantificación; uno de 16 bits, unos 98 dB. Los receptores SDR de radioaficionado suelen usar conversores de 14 o 16 bits: entre 86 y 98 dB, suficiente para oír una señal débil junto a una muy fuerte.
]

#ojo[
- La frecuencia de muestreo mínima es el *doble* de la máxima de la señal: para 3 kHz, 6 kHz (T1.32). 1,5 kHz y 3 kHz son cebos.
- Un DSP es un procesador (hardware y software) optimizado para tratar señales digitalizadas a gran velocidad (T1.33): no es un filtro de cuarzo, ni un amplificador, ni una fuente.
- Cada bit del conversor añade unos 6 dB de relación señal/ruido de cuantificación.
- Factor de potencia: el *coseno* del desfase entre tensión y corriente (T1.35). En un circuito resistivo, tensión y corriente van en fase (T1.44).
- La transferencia máxima de potencia exige *adaptación* de impedancias (T1.31), no una impedancia mucho mayor que la otra.
]

#q("T1.30", "b",
  [Si la potencia de salida de un transmisor se duplica, el aumento expresado en decibelios es de:],
  ([2 dB], [3 dB], [6 dB], [10 dB]),
  sol: [$10 log_10 (2) approx 3$ dB. Referencias de memoria: doble = +3 dB, cuádruple = +6 dB, diez veces = +10 dB.],
)

#q("T1.31", "d",
  [La transferencia máxima de potencia entre dos circuitos se produce cuando:],
  ([la impedancia de salida es mucho mayor que la de entrada], [la frecuencia de trabajo es máxima], [ambos circuitos están desacoplados], [existe adaptación entre sus impedancias]),
  sol: [Con la carga adaptada ($R_L = R_g$) la potencia entregada es máxima: si fuese mucho mayor apenas circularía corriente, y si fuese mucho menor apenas caería tensión en ella; el óptimo está en el punto medio. Es el fundamento de que estación, línea y antena trabajen a 50 Ω.],
)

#q("T1.32", "c",
  [Para digitalizar sin pérdida de información una señal de audio cuya frecuencia máxima es de 3 kHz, la frecuencia de muestreo mínima debe ser de:],
  ([1,5 kHz], [3 kHz], [6 kHz], [12 kHz]),
  sol: [Criterio de Nyquist: $f_s >= 2 f_"máx" = 6$ kHz — hacen falta al menos dos muestras por período para fijar una sinusoide. Muestrear por debajo produce _aliasing_ (una frecuencia alta se confunde con una baja), que evita el filtro antisolapamiento previo al conversor A/D.],
)

#q("T1.33", "a",
  [Se entiende por «procesador digital de señal» (DSP):],
  ([un sistema con hardware y software optimizados para procesar digitalmente la señal a muy alta velocidad], [un amplificador de audio de gran fidelidad], [un filtro pasivo de cristal de cuarzo], [una fuente de alimentación conmutada]),
  sol: [Un DSP es un procesador (hardware más software) especializado en ejecutar operaciones de tratamiento de señal (filtros, FFT, demodulación) a muy alta velocidad.],
)

#q("T1.34", "b",
  [Un espectro como el de la #ref(<t1-fig-am-espectro>, supplement: [figura]) — una portadora central con dos bandas laterales simétricas — a la salida de un transmisor corresponde a una señal con modulación de:],
  ([frecuencia], [amplitud], [fase], [banda lateral única]),
  sol: [Portadora central más dos bandas laterales simétricas es la firma espectral de la modulación de amplitud (así se dedujo matemáticamente en la teoría del tema). La FM mostraría muchas bandas laterales y la SSB una sola raya.],
)

#q("T1.35", "c",
  [En una instalación de corriente alterna, el llamado «factor de potencia» o $cos phi$ es:],
  ([la relación entre la tensión y la corriente (la impedancia)], [el número de ciclos por segundo de la corriente], [el coseno del ángulo de desfase entre la tensión y la corriente], [la proporción de armónicos de la señal]),
  sol: [En alterna, si hay reactancias la corriente no va al compás de la tensión, y solo la parte en fase produce potencia útil. El factor de potencia es el coseno del ángulo de desfase $phi$ (no el desfase mismo): $cos phi = P slash S$, cociente entre la potencia activa (la que se consume) y la aparente ($V I$). Vale 1 en un circuito resistivo puro y baja según crece la componente reactiva. La relación tensión/corriente es la impedancia.],
)

#q("T1.36", "a",
  [La resistencia eléctrica de un conductor es directamente proporcional a:],
  ([su resistividad y su longitud], [su sección y su longitud], [su resistividad y su sección], [la tensión aplicada y la corriente]),
  sol: [$R = rho l slash S$: a doble longitud, doble resistencia, y un material de mayor resistividad la aumenta en la misma proporción. La sección aparece dividiendo, así que con ella la relación es inversa.],
)

#q("T1.37", "d",
  [Si se reduce la sección de un conductor manteniendo su longitud, su resistencia eléctrica:],
  ([no varía], [disminuye], [se anula], [aumenta]),
  sol: [La sección está en el denominador de $R = rho l slash S$: estrechar el conductor es como estrechar una tubería, cuesta más hacer pasar la corriente. Por eso los cables de alta corriente son gruesos.],
)

#q("T1.38", "b",
  [La potencia disipada en una resistencia $R$ recorrida por una corriente de intensidad $I$ vale:],
  ([$P = R slash I$], [$P = R I^2$], [$P = I slash R^2$], [$P = R I$]),
  sol: [De $P = V I$ y $V = R I$ sale $P = R I^2$. Es la forma más útil cuando se conoce la corriente, y la que explica que la disipación se dispare al doblar la intensidad: cuatro veces más calor.],
)

#q("T1.39", "c",
  [Se llama valor eficaz de una corriente alterna:],
  ([el valor máximo que alcanza en cada ciclo], [la media aritmética de todos sus valores instantáneos], [el de la corriente continua que produciría el mismo efecto calorífico], [el valor que marca un osciloscopio entre pico y pico]),
  sol: [El valor eficaz se define por su efecto: es la continua equivalente en producción de calor. Para una senoide vale $V_"máx" slash sqrt(2)$, y es lo que miden los instrumentos y lo que significan los 230 V de la red.],
)

#q("T1.40", "a",
  [En una onda electromagnética, la polarización queda determinada por:],
  ([la dirección del campo eléctrico], [la dirección del campo magnético], [la dirección de propagación], [la frecuencia de la onda]),
  sol: [Por convenio, la polarización es la del campo eléctrico. Una antena vertical radia con polarización vertical porque su campo eléctrico lo es, y conviene que emisor y receptor coincidan: cruzar polarizaciones cuesta bastantes decibelios.],
)

#q("T1.41", "d",
  [Una batería almacena energía eléctrica mediante un proceso:],
  ([mecánico], [magnético], [térmico], [químico]),
  sol: [En una batería la energía se guarda como energía química y se recupera mediante una reacción de oxidación-reducción. El condensador la guarda en un campo eléctrico y la bobina, en uno magnético.],
)

#q("T1.42", "b",
  [Si se conectan en serie cuatro pilas iguales:],
  ([la tensión y la intensidad se multiplican por cuatro], [la tensión se cuadruplica y la intensidad es la de una sola pila], [la tensión es la de una sola pila y la intensidad se cuadruplica], [tanto la tensión como la intensidad son las de una sola pila]),
  sol: [En serie las tensiones se suman porque las pilas se encadenan, pero la corriente atraviesa a todas por igual: la capacidad de entregar corriente sigue siendo la de una. Para aumentar la corriente habría que ponerlas en paralelo, y entonces la tensión sería la de una sola.],
)

#q("T1.43", "c",
  [La intensidad del campo eléctrico se expresa en unidades de:],
  ([vatios por metro cuadrado], [amperios por metro], [voltios por metro], [julios por segundo]),
  sol: [El campo eléctrico es una diferencia de potencial por unidad de distancia, luego voltios/metro; en radio se maneja habitualmente en microvoltios por metro o en dBμV/m. Los amperios por metro corresponden al campo magnético.],
)

#q("T1.44", "a",
  [En un circuito puramente resistivo recorrido por corriente alterna, la tensión y la intensidad:],
  ([están en fase], [están desfasadas 90°], [están en oposición de fase], [tienen frecuencias distintas]),
  sol: [Sin reactancias no hay desfase: la corriente sigue instantáneamente a la tensión y ambas pasan a la vez por cero y por sus máximos. El desfase de 90° aparece con bobinas o condensadores puros.],
)

#q("T1.45", "b",
  [La característica principal que define a un generador eléctrico es:],
  ([su peso], [la fuerza electromotriz que produce], [el número de terminales de que dispone], [su temperatura de trabajo]),
  sol: [Un generador se caracteriza por la fuerza electromotriz que es capaz de mantener entre sus bornes, es decir, por la energía que comunica a cada unidad de carga. Su resistencia interna es el otro parámetro que lo describe.],
)

#q("T1.46", "c",
  [En una emisión radioeléctrica, la modulación tiene por objeto:],
  ([aumentar la potencia del transmisor], [reducir la longitud de la antena], [que la portadora transporte la información], [mejorar el rendimiento de la etapa final]),
  sol: [La portadora, sola, no dice nada: hay que hacerle variar la amplitud, la frecuencia o la fase al ritmo de la señal que se quiere transmitir. Eso es modular. Ni aumenta la potencia ni acorta la antena.],
)

#q("T1.47", "a",
  [Un amperio corresponde al paso por un conductor de una carga de:],
  ([un culombio por segundo], [un voltio por segundo], [un julio por segundo], [un faradio por segundo]),
  sol: [El amperio se define como el paso de un culombio por segundo: 1 A = 1 C/s. El julio por segundo es el vatio, y el voltio y el faradio miden magnitudes distintas.],
)
