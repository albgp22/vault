#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Utilidades locales del tema T3 (prefijo _t3-)
// ---------------------------------------------------------------------
// Etiqueta pequeña en un esquema o gráfica
#let _t3-et(pos, cuerpo, anchor: "center", size: 8pt, fill: black) = cetz.draw.content(pos, anchor: anchor, text(size: size, fill: fill, cuerpo))

// Curva de resonancia normalizada: 1 en u = 1, cae con Q
#let _t3-res(u, q) = 1 / calc.sqrt(1 + q * q * calc.pow(u - 1 / u, 2))

#tema("T3", "Circuitos", alcance: [Combinación de componentes en serie y paralelo · comportamientos reales de resistencias, condensadores y bobinas a altas frecuencias · filtros y circuitos sintonizados (resonancia, factor de calidad, filtros en pi y en T, de cuarzo y digitales) · fuentes de alimentación (rectificadores, filtrado, estabilización, fuentes conmutadas) · amplificadores (clases A, A/B, B y C) · detectores y demoduladores · osciladores (LC, a cristal, VCO) · sintetizadores de frecuencia (PLL) · circuitos con DSP.])

Este tema junta las piezas sueltas del tema T2 —resistencias, condensadores, bobinas, diodos, transistores— y las convierte en los bloques con que se construye una estación: el circuito que elige una emisora, la fuente que alimenta el equipo, el amplificador que convierte microvoltios en vatios, el filtro que limpia los armónicos, el oscilador que crea la portadora, el mezclador que la traslada y el detector que recupera la voz. Para cada bloque verás primero qué problema resuelve, después el esquema y por qué funciona, y al final lo que pregunta el examen. Si una idea se te queda corta, las referencias del tipo «título», p. N te llevan a la explicación larga de la primera parte del libro.

== Asociación de componentes y resonancia <t3-sec-asociacion>

#motivacion[Un equipo de radio no tiene «una resistencia» o «un condensador»: tiene decenas de componentes unidos entre sí. Antes de entender cualquier bloque hay que saber qué hace un grupo de componentes visto desde fuera. Y hay un grupo, el de una bobina con un condensador, que resuelve el problema central de la radio: la antena recoge a la vez cientos de emisoras, y hay que quedarse con una.]

En alterna, resistencia y reactancias se combinan en la *impedancia* $Z = R + j (X_L - X_C)$: la parte reactiva es la _diferencia_ entre lo inductivo y lo capacitivo, porque las tensiones reactivas que producen están en oposición de fase — sobre la misma corriente, $V_L$ adelanta 90° y $V_C$ retrasa 90°, luego 180° entre sí. Las reglas de asociación calcan las de las resistencias — impedancias en serie se suman; en paralelo se suman las admitancias — con un cruce que el examen explota: los *condensadores en paralelo se suman* ($C = C_1 + C_2$, como resistencias en serie: a igual tensión, cada uno guarda su carga y las cargas se acumulan) y en serie se combinan como resistencias en paralelo (misma carga, y las tensiones se reparten).

=== Serie y paralelo, de un vistazo

Dos componentes están *en serie* cuando los recorre la misma corriente (uno detrás de otro, sin derivaciones entre ellos), y *en paralelo* cuando comparten los dos mismos nudos y, por tanto, la misma tensión. Con esa definición, todas las reglas salen de la ley de Ohm y de las dos leyes de Kirchhoff:

- *En serie* la corriente es común y las tensiones se suman: $V = V_1 + V_2 = I(R_1 + R_2)$, luego $R = R_1 + R_2$. El total siempre supera al mayor.
- *En paralelo* la tensión es común y las corrientes se suman (primera ley de Kirchhoff): $I = V slash R_1 + V slash R_2$, luego $1 slash R = 1 slash R_1 + 1 slash R_2$. El total siempre queda por debajo del menor, y por la rama de menor resistencia pasa más corriente ($I_k = V slash R_k$).
- *Las bobinas* (sin acoplamiento entre ellas) se asocian como las resistencias, porque su reactancia $X_L = 2 pi f L$ es proporcional a $L$.
- *Los condensadores* van al revés, porque su reactancia $X_C = 1 slash (2 pi f C)$ es _inversamente_ proporcional a $C$: en paralelo es como agrandar las placas, y las capacidades se suman; en serie es como separarlas, y la capacidad baja.

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: (left, center, center),
    [*Componente*], [*En serie*], [*En paralelo*],
    [Resistencias], [$R = R_1 + R_2 + dots$], [$1 slash R = 1 slash R_1 + 1 slash R_2 + dots$],
    [Bobinas], [$L = L_1 + L_2 + dots$], [$1 slash L = 1 slash L_1 + 1 slash L_2 + dots$],
    [Condensadores], [$1 slash C = 1 slash C_1 + 1 slash C_2 + dots$], [$C = C_1 + C_2 + dots$],
    [Dos iguales], [$2R$, $2L$ o $C slash 2$], [$R slash 2$, $L slash 2$ o $2C$],
  ),
  kind: table,
  caption: [Reglas de asociación. Los condensadores siguen la regla «cruzada»: lo que en las resistencias es serie, en ellos es paralelo.],
) <t3-tab-asociacion>

#circuito(caption: [Condensadores en paralelo (izquierda): comparten la tensión, cada uno guarda su carga y las capacidades se suman. En serie (derecha): comparten la carga, las tensiones se reparten y la capacidad total es menor que la menor.], sim: "cappar.txt")[
  #esquema({
    import zap: *
    // paralelo
    wire((0, 2), (3.2, 2))
    wire((0, 0), (3.2, 0))
    capacitor("cp1", (1, 2), (1, 0), label: $C_1$)
    capacitor("cp2", (3.2, 2), (3.2, 0), label: $C_2$)
    node("a1", (0, 2), fill: false)
    node("a2", (0, 0), fill: false)
    _t3-et((1.8, -0.6), [$C = C_1 + C_2$], size: 9pt)
    // serie
    wire((6, 1), (6.6, 1))
    capacitor("cs1", (6.6, 1), (8, 1), label: $C_1$)
    capacitor("cs2", (8, 1), (9.4, 1), label: $C_2$)
    wire((9.4, 1), (10, 1))
    node("b1", (6, 1), fill: false)
    node("b2", (10, 1), fill: false)
    _t3-et((8, -0.6), [$1 slash C = 1 slash C_1 + 1 slash C_2$], size: 9pt)
  })
] <t3-fig-asoc-c>

#porque[
  - En paralelo, los dos condensadores ven la misma tensión $V$. Cada uno guarda su carga, $Q_1 = C_1 V$ y $Q_2 = C_2 V$, y desde fuera se ve la suma: $Q = (C_1 + C_2) V$. Es como un solo condensador con más superficie de placa.
  - En serie, la carga que sale de una placa es la que llega a la siguiente: todos guardan la misma $Q$. Las tensiones se suman, $V = Q slash C_1 + Q slash C_2$, y de ahí sale la fórmula de los inversos. Es como un solo condensador con las placas más separadas. #falstad("capseries.txt")
]

#ejemplo[
  - Dos resistencias de 100 Ω en paralelo dan 50 Ω; tres de 300 Ω, 100 Ω ($R slash n$ para $n$ iguales).
  - 100 Ω en paralelo con 400 Ω: $R = (100 dot 400) slash (100 + 400) = 80$ Ω, menos que la menor. Con 12 V aplicados, por la de 100 Ω pasan 120 mA y por la de 400 Ω, 30 mA: la total es la suma, 150 mA $= 12 slash 80$.
  - Tres condensadores en paralelo suman 400 pF; si dos son de 100 pF, el tercero es de $400 - 100 - 100 = 200$ pF.
  - Dos condensadores de 100 pF en serie dan 50 pF.
]

#ojo[El examen alterna las dos trampas: aplicar a los condensadores la regla de las resistencias, y confundir qué es común en cada asociación. En paralelo es común la *tensión* y las corrientes se suman; en serie es común la *corriente* y las tensiones se suman. Lo prueban las preguntas T3.3, T3.4, T3.28, T3.29, T3.42, T3.43, T3.44 y T3.56.]

=== La resonancia: quedarse con una emisora

Como $X_L = 2 pi f L$ crece con la frecuencia y $X_C = 1 slash (2 pi f C)$ decrece, existe una única frecuencia en la que se igualan. Imponiendo $X_L = X_C$:
$ 2 pi f_0 L = 1 / (2 pi f_0 C) quad ==> quad f_0 = 1 / (2 pi sqrt(L C)), $
la *frecuencia de resonancia*. En ella las reactancias se cancelan y el circuito queda puramente resistivo: el RLC _serie_ presenta impedancia mínima (deja pasar $f_0$) y el _paralelo_, máxima. La agudeza de esa selección la mide el *factor de calidad*
$ Q = f_0 / B = X / R, $
donde $B$ es el ancho de banda entre los puntos de media potencia (−3 dB): a menos pérdidas ($R$ pequeña), mayor $Q$ y curva más estrecha (@t3-fig-curva). La impedancia máxima del paralelo tiene su porqué: sus dos ramas toman corrientes iguales y en oposición de fase que se cancelan a la entrada, de modo que el circuito apenas absorbe corriente de fuera aunque por dentro circule una $Q$ veces mayor (lo bloquea, o lo selecciona si se toma la tensión en él).

#ejemplo[$L = 10$ μH y $C = 100$ pF resuenan en $f_0 = frac(1, 2 pi sqrt(10^(-5) dot 10^(-10))) approx 5,03$ MHz. Si la resistencia de pérdidas es de 10 Ω, la reactancia en resonancia vale $X_L = 2 pi f_0 L approx 316$ Ω, luego $Q = 316 slash 10 approx 32$ y el ancho de banda $B = f_0 slash Q approx 160$ kHz.]

#circuito(caption: [Curva de respuesta de un circuito resonante. El ancho de banda $B$ se mide entre los puntos en que la respuesta cae 3 dB (la potencia se reduce a la mitad); a mayor factor de calidad $Q$, curva más estrecha y mejor selección de la frecuencia $f_0$.])[
  #cetz.canvas({
    import cetz.draw: *
    let q = 4
    let x0 = 3.2
    let h = 3
    let y = x => 0.25 + h * _t3-res(x / x0, q)
    ejes(0, 10, 0, 4, etq-x: $f$, etq-y: [respuesta])
    onda(y, 0.4, 9.6, n: 240, stroke: 1.2pt + col.senal1)
    let s = calc.sqrt(1 / (q * q) + 4)
    let xa = x0 * (-1 / q + s) / 2
    let xb = x0 * (1 / q + s) / 2
    let y3 = 0.25 + h / calc.sqrt(2)
    line((0, y3), (6.4, y3), stroke: (paint: col.naranja, dash: "dashed", thickness: 0.7pt))
    _t3-et((6.5, y3), text(fill: col.naranja)[−3 dB (mitad de potencia)], anchor: "west")
    line((xa, 0), (xa, y3), stroke: (dash: "dotted", thickness: 0.5pt))
    line((xb, 0), (xb, y3), stroke: (dash: "dotted", thickness: 0.5pt))
    line((x0, 0), (x0, 0.25 + h), stroke: (dash: "dotted", thickness: 0.5pt))
    line((xa, 0.5), (xb, 0.5), mark: (start: ">", end: ">", fill: black, scale: 0.6), stroke: 0.5pt)
    _t3-et((xb + 0.15, 0.5), $B$, anchor: "west")
    _t3-et((x0, -0.1), $f_0$, anchor: "north")
    _t3-et((7.4, 1.3), $Q = f_0 / B = X / R$, size: 9pt)
  })
] <t3-fig-curva>

=== Resonancia serie y resonancia paralelo

Las mismas $L$ y $C$ pueden montarse de dos maneras, y cada una hace lo contrario que la otra a la frecuencia de resonancia. Conviene tener las dos a la vista (@t3-fig-serie-paralelo y @t3-fig-z-f), porque el examen pregunta tanto por una como por otra. La explicación larga, con la energía yendo y viniendo, está en #ver(<sec-resonancia>).

#circuito(caption: [Circuito resonante serie (izquierda) y paralelo, o «tanque» (derecha). $R$ representa las pérdidas, sobre todo la resistencia del hilo de la bobina.], sim: "res-series.txt")[
  #esquema({
    import zap: *
    import cetz.draw: arc, line
    // serie
    acvsource("vs", (0, 0), (0, 2.4))
    wire((0, 2.4), (0.6, 2.4))
    resistor("rs", (0.6, 2.4), (2.2, 2.4), label: $R$)
    inductor("ls", (2.2, 2.4), (3.8, 2.4), label: $L$)
    wire((3.8, 2.4), (4.4, 2.4))
    capacitor("cs", (4.4, 2.4), (4.4, 0), label: $C$)
    wire((0, 0), (4.4, 0))
    _t3-et((2.2, -0.55), [serie: $Z$ mínima en $f_0$], size: 8.5pt)
    // paralelo
    acvsource("vp", (7, 0), (7, 2.4))
    resistor("rg", (7, 2.4), (8.8, 2.4), label: $R_g$)
    wire((8.8, 2.4), (11.6, 2.4))
    node("np", (9.6, 2.4))
    inductor("lp", (9.6, 2.4), (9.6, 0), label: $L$)
    capacitor("cp", (11.6, 2.4), (11.6, 0), label: $C$)
    wire((7, 0), (11.6, 0))
    node("np2", (9.6, 0))
    arc((10.95, 1.2), start: 0deg, stop: 300deg, radius: 0.35, mark: (end: ">", fill: black, scale: 0.6), stroke: 0.6pt + col.senal2)
    _t3-et((10.6, 1.2), text(fill: col.senal2)[$Q I$], size: 7.5pt)
    _t3-et((9.3, -0.55), [paralelo: $Z$ máxima en $f_0$], size: 8.5pt)
  })
] <t3-fig-serie-paralelo>

#porque[
  - *Serie.* La misma corriente atraviesa $L$ y $C$. Sus tensiones están en oposición de fase y, en $f_0$, son iguales: se anulan entre sí. Al generador solo le queda la resistencia de pérdidas $R$, que es pequeña: la corriente es máxima. Fuera de resonancia sobra reactancia (capacitiva por debajo de $f_0$, inductiva por encima) y la corriente cae.
  - *Paralelo.* $L$ y $C$ comparten la tensión. En $f_0$ sus corrientes son iguales y opuestas: la de la bobina va «hacia un lado» justo cuando la del condensador va «hacia el otro». Entre las dos forman una corriente que circula *dentro* del tanque ($Q I$ en la figura), mientras que de fuera solo entra la pequeña corriente $I$ que repone las pérdidas. Corriente de entrada mínima significa impedancia máxima. #falstad("res-par.txt")
  - Sin la resistencia de pérdidas, la impedancia del serie en $f_0$ sería cero y la del paralelo, infinita. Por eso $Q = X slash R$: cuanto menos pierde el circuito, más extremo es su comportamiento en resonancia.
]

#circuito(caption: [Módulo de la impedancia frente a la frecuencia. El serie tiene un mínimo en $f_0$ (vale $R$); el paralelo, un máximo. Fuera de resonancia, cada uno se comporta como la reactancia que domina.])[
  #cetz.canvas({
    import cetz.draw: *
    let q = 3
    let x0 = 2.6
    // serie
    ejes(0, 6, 0, 3.8, etq-x: $f$, etq-y: $|Z|$)
    onda(x => calc.min(3.4, 0.25 / _t3-res(x / x0, q)), 0.3, 5.8, n: 200, stroke: 1.2pt + col.senal1)
    line((x0, 0), (x0, 3.4), stroke: (dash: "dotted", thickness: 0.5pt))
    _t3-et((x0, -0.1), $f_0$, anchor: "north")
    _t3-et((x0 + 0.1, 0.45), $R$, anchor: "west", size: 7.5pt)
    _t3-et((1.2, 0.35), [capacitivo], size: 7.5pt, fill: col.gris)
    _t3-et((4.9, 0.35), [inductivo], size: 7.5pt, fill: col.gris)
    _t3-et((3, 4.3), [*serie*: mínimo en $f_0$], size: 8.5pt)
    // paralelo
    translate((7.5, 0))
    ejes(0, 6, 0, 3.8, etq-x: $f$, etq-y: $|Z|$)
    onda(x => 3.2 * _t3-res(x / x0, q), 0.3, 5.8, n: 200, stroke: 1.2pt + col.senal2)
    line((x0, 0), (x0, 3.2), stroke: (dash: "dotted", thickness: 0.5pt))
    _t3-et((x0, -0.1), $f_0$, anchor: "north")
    _t3-et((1.0, 2.9), [inductivo], size: 7.5pt, fill: col.gris)
    _t3-et((4.6, 2.9), [capacitivo], size: 7.5pt, fill: col.gris)
    _t3-et((3, 4.3), [*paralelo*: máximo en $f_0$], size: 8.5pt)
  })
] <t3-fig-z-f>

#ptitulo[Magnificación de tensión y de corriente] En resonancia, los componentes de dentro trabajan mucho más que lo que se ve desde fuera. En el *serie*, la tensión sobre la bobina (y la misma sobre el condensador) vale $V_L = I X_L = (V slash R) X_L = Q V$: el circuito multiplica la tensión de entrada por $Q$. En el *paralelo* es la corriente la que se multiplica: la que circula entre $L$ y $C$ es $Q$ veces la que entra. Por eso los condensadores de un circuito tanque de transmisor han de aguantar tensiones y corrientes muy superiores a las de la línea de alimentación.

#ejemplo[Con el circuito del ejemplo anterior ($Q approx 32$), un generador de 1 V en serie con él produce unos 32 V sobre el condensador en $f_0 approx 5,03$ MHz. A 4 MHz, ya muy fuera de la banda de 160 kHz, la tensión sobre el condensador baja a unos 2,7 V: el circuito ha «elegido» su frecuencia.]

#ptitulo[Por qué un tanque paralelo es la carga de las etapas de RF] La ganancia de un amplificador de transistor es, en esencia, la transconductancia por la impedancia de carga del colector: $A_v approx -g_m Z_"carga"$. Si esa carga es un tanque LC paralelo, la impedancia es muy alta en $f_0$ y muy baja fuera: la etapa *amplifica solo la frecuencia a la que está sintonizada* (@t3-fig-amp-sintonizado). Así trabajan el amplificador de RF y los de FI del receptor, y así trabaja la etapa final del transmisor, donde el tanque además reconstruye la sinusoide a partir de pulsos de corriente (clase C, efecto volante). Un oscilador es lo mismo con una parte de la salida devuelta a la entrada: el tanque decide a qué frecuencia oscila. La versión detallada del amplificador sintonizado está en #ver(<sec-amp-sintonizado>).

#circuito(caption: [Amplificador sintonizado: un emisor común cuya carga de colector es un tanque LC paralelo. Solo la frecuencia de resonancia ve una carga alta y sale amplificada.])[
  #esquema({
    import zap: *
    wire((1.6, 6), (5.2, 6))
    wire((1.6, 0), (5.0, 0))
    _t3-et((4.35, 6.35), $+V_"CC"$)
    ground("gnd", (4, 0))
    resistor("r1", (1.6, 6), (1.6, 3), label: $R_1$)
    resistor("r2", (1.6, 3), (1.6, 0), label: $R_2$)
    npn("q1", (3.5, 3))
    wire((1.6, 3), "q1.b")
    // tanque
    wire((3.5, 3.5), (3.5, 4.0))
    wire((3.5, 4.0), (5.2, 4.0))
    inductor("lt", (3.5, 6), (3.5, 4.0), label: $L$)
    capacitor("ct", (5.2, 6), (5.2, 4.0), label: $C$)
    node("nt", (3.5, 4.0))
    node("nt2", (5.2, 4.0))
    // emisor
    resistor("re", (3.5, 2.0), (3.5, 0), label: $R_E$)
    wire((3.5, 2.5), (3.5, 2.0))
    wire((3.5, 2.0), (5.0, 2.0))
    capacitor("ce", (5.0, 2.0), (5.0, 0), label: $C_E$)
    node("ne", (3.5, 2.0))
    // acoplos
    capacitor("cin", (0, 3), (1.6, 3), label: $C_"ent"$, n: "o-*")
    capacitor("cout", (5.2, 4.0), (6.8, 4.0), label: (content: $C_"sal"$, anchor: "south"), n: "-o")
    _t3-et((0, 3.45), [RF], size: 7.5pt)
    _t3-et((7.0, 4.4), [RF amplificada], size: 7.5pt)
  })
] <t3-fig-amp-sintonizado>

#porque[
  - $R_1$ y $R_2$ polarizan la base: el transistor queda a medio conducir, listo para seguir la señal en los dos sentidos. $R_E$ estabiliza ese punto de trabajo y $C_E$ la pone a masa para la señal.
  - El tanque $L C$ es la carga del colector. La corriente continua pasa sin problema por la bobina; para la señal, en $f_0$, el tanque presenta una impedancia de miles de ohmios y la tensión de salida es grande. A otras frecuencias el tanque es casi un cortocircuito y la salida es casi nula.
  - $C_"ent"$ y $C_"sal"$ dejan pasar la RF y bloquean la continua, de modo que cada etapa conserva su polarización (es lo que pregunta T3.49).
  - Sin el tanque (con una resistencia de colector) la etapa amplificaría todas las frecuencias por igual, también las emisoras que no queremos.
]

Físicamente, en resonancia la energía no se gasta en las reactancias: va y viene entre el campo eléctrico del condensador y el magnético de la bobina, dos veces por ciclo, y la resistencia solo repone lo disipado. De ahí la otra lectura del factor de calidad: $Q$ es $2 pi$ veces el cociente entre la energía almacenada y la disipada en cada ciclo — un circuito de $Q$ alto es un péndulo bien engrasado.

#analogia[Un columpio es un circuito resonante. Tiene su propia frecuencia de vaivén y, si lo empujas justo a ese ritmo, con empujones pequeños consigues oscilaciones enormes: es la magnificación por $Q$. Si empujas a otro ritmo, unas veces ayudas y otras frenas, y el columpio apenas se mueve: es la selectividad. El rozamiento del eje es la resistencia de pérdidas: cuanto menor, más alto sube el columpio y más exigente es con el ritmo (más $Q$, banda más estrecha).]

#idea[$f_0 = 1 slash (2 pi sqrt(L C))$: más $L$ o más $C$, frecuencia más baja (por eso se sintoniza hacia abajo «metiendo» capacidad del condensador variable). En $f_0$ el circuito es *puramente resistivo*: mínima impedancia en serie, máxima en paralelo. $Q = f_0 slash B = X slash R$.]

=== Los componentes reales en alta frecuencia

A frecuencias altas, además, ningún componente real se comporta como su símbolo: los terminales de una resistencia añaden inductancia en serie, entre las espiras de una bobina aparece capacidad parásita, y un condensador — con la inductancia de sus patas — acaba formando un circuito resonante serie: por encima de su frecuencia de *autorresonancia* se comporta, de hecho, como una bobina. Por eso en VHF y UHF se montan los componentes con terminales cortísimos (o sin ellos, en montaje superficial) y se emplean tipos específicos para RF.

#circuito(caption: [Circuitos equivalentes de los componentes reales. Cada uno esconde los otros dos: la resistencia, una inductancia y una capacidad parásitas; el condensador, la inductancia de sus patas ($L_s$) y una resistencia de pérdidas; la bobina, la resistencia del hilo y la capacidad entre espiras.])[
  #esquema(escala: 0.82, {
    import zap: *
    import cetz.draw: translate
    // resistencia real
    wire((0, 0), (0.4, 0))
    inductor("lr", (0.4, 0), (1.9, 0), label: $L_s$)
    resistor("rr", (1.9, 0), (3.5, 0), label: (content: $R$, anchor: "south"))
    wire((3.5, 0), (3.9, 0))
    wire((0.4, 0), (0.4, 1.3))
    wire((3.5, 0), (3.5, 1.3))
    capacitor("cr", (0.4, 1.3), (3.5, 1.3), label: $C_p$)
    node("r1", (0, 0), fill: false)
    node("r2", (3.9, 0), fill: false)
    _t3-et((1.95, -1.2), [resistencia], size: 9pt)
    // condensador real
    translate((5.2, 0))
    wire((0, 0), (0.3, 0))
    resistor("rc", (0.3, 0), (1.5, 0), label: $R_s$)
    inductor("lc", (1.5, 0), (2.9, 0), label: $L_s$)
    capacitor("cc", (2.9, 0), (3.9, 0), label: $C$)
    wire((3.9, 0), (4.2, 0))
    node("c1", (0, 0), fill: false)
    node("c2", (4.2, 0), fill: false)
    _t3-et((2.1, -1.2), [condensador], size: 9pt)
    // bobina real
    translate((5.6, 0))
    wire((0, 0), (0.4, 0))
    resistor("rl", (0.4, 0), (1.9, 0), label: (content: $R_s$, anchor: "south"))
    inductor("ll", (1.9, 0), (3.5, 0), label: (content: $L$, anchor: "south"))
    wire((3.5, 0), (3.9, 0))
    wire((0.4, 0), (0.4, 1.3))
    wire((3.5, 0), (3.5, 1.3))
    capacitor("cl", (0.4, 1.3), (3.5, 1.3), label: $C_p$)
    node("l1", (0, 0), fill: false)
    node("l2", (3.9, 0), fill: false)
    _t3-et((1.95, -1.2), [bobina], size: 9pt)
  })
] <t3-fig-reales>

#porque[
  - *Resistencia.* Sus patas y, en las bobinadas, el propio hilo forman una pequeña inductancia $L_s$; entre sus extremos hay una capacidad $C_p$. A pocos MHz no se notan; en VHF la reactancia de esos parásitos se acerca al valor de la resistencia y deja de ser «solo $R$». Las resistencias de RF son de película, cortas y sin bobinar.
  - *Condensador.* $C$ en serie con $L_s$ es un circuito resonante serie. Por debajo de su autorresonancia domina $C$ y se comporta como condensador; en la autorresonancia su impedancia es mínima (solo $R_s$); por encima domina $L_s$ y se comporta como una bobina. Un condensador de desacoplo solo es útil por debajo de esa frecuencia: por eso en las placas se ponen en paralelo uno grande (baja frecuencia) y uno pequeño de montaje superficial (RF).
  - *Bobina.* $L$ con su capacidad entre espiras $C_p$ es un circuito resonante paralelo: en su autorresonancia la bobina se comporta como una impedancia muy alta, y por encima, como un condensador. Las bobinas de choque de RF se diseñan para que esa resonancia caiga lejos de la banda de trabajo.
]

#ojo[Por encima de su frecuencia de autorresonancia, un condensador se comporta como una bobina, y una bobina como un condensador. Esa es la respuesta a las preguntas sobre «comportamiento real de los componentes a altas frecuencias».]

#q("T3.1", "a",
  [En un circuito resonante, la condición de resonancia se cumple cuando:],
  ([las reactancias inductiva y capacitiva se igualan], [la resistencia del circuito se anula], [la impedancia del circuito se hace infinita a cualquier frecuencia], [la frecuencia de la señal se duplica]),
  sol: [En resonancia $X_L = X_C$: las reactancias se cancelan y la impedancia queda puramente resistiva (mínima en el circuito serie; máxima en el paralelo, donde las corrientes de las dos ramas se cancelan a la entrada).],
)

#q("T3.2", "b",
  [El factor de calidad $Q$ de un circuito resonante, en función de su frecuencia de resonancia $f$ y de su ancho de banda $B$, se expresa como:],
  ([$Q = B slash f$], [$Q = f slash B$], [$Q = f dot B$], [$Q = f - B$]),
  sol: [$Q = f slash B$: a igual frecuencia, cuanto más estrecho el ancho de banda, mayor factor de calidad y mejor selección de una frecuencia frente a las demás.],
)

#q("T3.3", "c",
  [Al conectar varios condensadores en paralelo, la capacidad resultante del conjunto es:],
  ([menor que la más pequeña de las capacidades], [la media aritmética de las capacidades], [la suma de las capacidades individuales], [el producto de las capacidades individuales]),
  sol: [En paralelo las capacidades se suman ($C = C_1 + C_2 + C_3$): a igual tensión, cada condensador guarda su carga y las cargas se acumulan. Es el comportamiento inverso al de las resistencias, que se suman en serie.],
)

#q("T3.4", "b",
  [Al conectar dos resistencias en paralelo, la resistencia resultante es:],
  ([mayor que cualquiera de ellas], [menor que cualquiera de ellas], [igual a la suma de ambas], [igual a la diferencia de ambas]),
  sol: [Dos resistencias en paralelo dan siempre menos que la más pequeña; en serie, el total supera a cualquiera de ellas.],
)

== Fuentes de alimentación y amplificadores <t3-sec-fuentes>

#motivacion[El transceptor pide 13,8 V de continua, muy estables, y en transmisión puede tragar 20 A de golpe. El enchufe da 230 V de alterna a 50 Hz. La fuente de alimentación hace ese cambio sin que el rizado de la red se cuele en la señal (se oiría como un zumbido de 100 Hz) y sin que la tensión se hunda cuando pulsas el micrófono.]

Una fuente lineal encadena cuatro bloques: transformador (baja la tensión de red), *rectificador* (el diodo recorta la alterna: media onda con un diodo, onda completa con dos y toma media, o *puente* de cuatro), *filtrado* y *estabilización*. El rectificador entrega una tensión pulsante; el condensador de filtro la sostiene entre picos y reduce el *rizado* residual (a 100 Hz tras un puente en red de 50 Hz). Finalmente un zéner o un regulador integrado fija la tensión de salida frente a variaciones de red y de carga. Las *fuentes conmutadas* trocean la tensión a decenas o cientos de kHz y la reconstruyen: mucho más ligeras y eficientes — un transformador de alta frecuencia, minúsculo, sigue aislando galvánicamente el primario del secundario —, a cambio de generar ruido de conmutación que exige buen filtrado, también en la entrada para no verterlo a la red, y apantallamiento (compatibilidad electromagnética, tema T9).

// FALSTAD-CUSTOM: fuente-completa
#circuito(caption: [Los cuatro bloques de una fuente lineal y la forma de la tensión entre ellos. Cada bloque hace una sola cosa, y el orden no puede cambiarse: no se puede alisar el rizado antes de crearlo.])[
  #cetz.canvas({
    import cetz.draw: *
    let caja(x, t) = {
      rect((x, 0), (x + 2.2, 1.1), radius: 0.08, stroke: 0.7pt, fill: col.acento-claro)
      content((x + 1.1, 0.55), text(size: 8pt, t))
    }
    let flecha(x) = line((x, 0.55), (x + 0.9, 0.55), mark: (end: ">", fill: black, scale: 0.6), stroke: 0.6pt)
    caja(0.9, [Transformador])
    caja(4.0, [Rectificador])
    caja(7.1, [Filtro])
    caja(10.2, [Regulador])
    flecha(0)
    flecha(3.1)
    flecha(6.2)
    flecha(9.3)
    flecha(12.4)
    // formas de onda bajo cada flecha
    let base = -1.0
    let mini(x0, f, etq) = {
      line((x0, base), (x0 + 1.5, base), stroke: 0.3pt + col.gris)
      onda(t => base + f(t - x0), x0, x0 + 1.5, n: 90, stroke: 0.9pt + col.senal1)
      content((x0 + 0.75, base - 0.75), text(size: 7pt, fill: col.gris, etq))
    }
    let w = 2 * calc.pi / 0.75
    mini(-0.3, t => 0.45 * calc.sin(t * w * 1rad), [230 V~])
    mini(2.8, t => 0.3 * calc.sin(t * w * 1rad), [15 V~])
    mini(5.9, t => 0.45 * calc.abs(calc.sin(t * w * 1rad)), [pulsante])
    mini(9.0, t => 0.42 - 0.12 * calc.rem(t * 2 / 0.75, 1), [con rizado])
    mini(12.1, t => 0.35, [13,8 V])
  })
] <t3-fig-fuente-bloques>

#porque[
  - El *transformador* baja los 230 V a la tensión que necesita el equipo (unos 15–18 V de pico para obtener 13,8 V) y, de paso, aísla al operador de la red.
  - El *rectificador* hace que la corriente vaya siempre en el mismo sentido: sale una tensión de un solo signo, pero a pulsos.
  - El *filtro* (un condensador grande) se carga en los picos y sostiene la tensión entre ellos: queda una continua con un pequeño rizado.
  - El *regulador* absorbe ese rizado y las variaciones de la red y del consumo, y entrega una tensión fija. Sin él, la tensión bajaría cada vez que el equipo pasa a transmisión.
]

=== Tres maneras de rectificar

El diodo deja pasar la corriente en un solo sentido (#ver(<sec-diodo>)). Colocado entre el transformador y la carga, convierte la alterna en una corriente que va siempre hacia el mismo lado, aunque a pulsos. Hay tres montajes, de menos a más aprovechamiento (@t3-fig-rectificadores). La fuente completa, contada desde cero, está en #ver(<sec-fuente>).

#circuito(caption: [Rectificadores de media onda (un diodo), de onda completa con toma media (dos diodos) y en puente (cuatro diodos). En los tres, el borne $+$ de la carga es el que queda unido a los cátodos.], sim: "fullrect.txt")[
  #esquema(escala: 0.8, {
    import zap: *
    import cetz.draw: translate
    // media onda
    trafo("t1", (0, 0))
    diode("d1", (1, 0.8), (2.6, 0.8), label: $D$)
    wire((2.6, 0.8), (3.2, 0.8))
    resistor("rl1", (3.2, 0.8), (3.2, -0.8), label: $R_L$)
    wire((3.2, -0.8), (1, -0.8))
    _t3-et((3.65, 1.05), $+$, size: 8pt)
    _t3-et((1.6, -2.4), [media onda], size: 9pt)
    // toma media
    translate((5.4, 0))
    trafo("t2", (0, 0), espiras: (4, 6))
    wire((0.42, 0), (1.1, 0))
    ground("g2", (1.1, 0))
    diode("d2a", (1, 1.2), (2.6, 1.2), label: $D_1$)
    diode("d2b", (1, -1.2), (2.6, -1.2), label: (content: $D_2$, anchor: "south"))
    wire((2.6, 1.2), (3.0, 1.2))
    wire((2.6, -1.2), (3.0, -1.2))
    wire((3.0, -1.2), (3.0, 1.2))
    node("n2", (3.0, 1.2))
    wire((3.0, 1.2), (3.6, 1.2))
    resistor("rl2", (3.6, 1.2), (3.6, -0.6), label: $R_L$)
    ground("g2b", (3.6, -0.6))
    _t3-et((4.05, 1.45), $+$, size: 8pt)
    _t3-et((1.8, -2.4), [onda completa (toma media)], size: 9pt)
    // puente
    translate((6.0, 0))
    trafo("t3", (0, 0))
    let (cx, d) = (2.6, 0.95)
    wire((1, 0.8), (cx - d, 0.8), (cx - d, 0))
    wire((1, -0.8), (1.3, -0.8), (1.3, -1.45), (cx + d + 0.35, -1.45), (cx + d + 0.35, 0), (cx + d, 0))
    diode("p1", (cx - d, 0), (cx, d))
    diode("p2", (cx + d, 0), (cx, d))
    diode("p3", (cx, -d), (cx - d, 0))
    diode("p4", (cx, -d), (cx + d, 0))
    wire((cx, d), (cx, 1.4), (4.7, 1.4))
    wire((cx, -d), (cx, -1.85), (4.7, -1.85))
    resistor("rl3", (4.7, 1.4), (4.7, -1.85), label: $R_L$)
    _t3-et((5.15, 1.6), $+$, size: 8pt)
    _t3-et((5.15, -2.05), $-$, size: 8pt)
    _t3-et((2.4, -2.4), [puente], size: 9pt)
  })
] <t3-fig-rectificadores>

#porque[
  - *Media onda.* En el semiciclo positivo el diodo conduce y la carga recibe la tensión del secundario; en el negativo se bloquea y la carga no recibe nada. Se tira la mitad de la energía de la red y quedan huecos de medio ciclo: el rizado es de 50 Hz. #falstad("rectify.txt")
  - *Onda completa con toma media.* El secundario tiene el doble de espiras y una toma en el centro, que va a masa. En cada semiciclo, uno de los dos extremos es positivo respecto de la toma y su diodo conduce: $D_1$ en un semiciclo, $D_2$ en el otro. La corriente por la carga va siempre en el mismo sentido; el rizado pasa a 100 Hz.
  - *Puente.* Cuatro diodos en rombo. En cada semiciclo conducen dos, en diagonal: uno lleva la corriente del extremo positivo del secundario hacia el $+$ de la carga y el otro la devuelve desde el $-$ al extremo negativo. Aprovecha los dos semiciclos con un secundario sencillo, sin toma media; a cambio, la corriente atraviesa dos diodos y se pierden unos 1,4 V.
]

Con números: el rectificador de media onda entrega una tensión media de $V_p slash pi$ y rizado a la frecuencia de red (50 Hz); el de onda completa dobla ambas cosas ($2 V_p slash pi$ de media, rizado a 100 Hz) y por eso se filtra mejor con el mismo condensador. El rizado residual crece con la corriente de carga y decrece con $f$ y con $C$: la razón de los condensadores de miles de microfaradios en las fuentes de potencia.

#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr),
    align: (left, center, center, center),
    [], [*Media onda*], [*Toma media*], [*Puente*],
    [Diodos], [1], [2], [4],
    [Semiciclos aprovechados], [uno], [los dos], [los dos],
    [Tensión media (sin filtro)], [$V_p slash pi approx 0,32 V_p$], [$2 V_p slash pi approx 0,64 V_p$], [$2 V_p slash pi approx 0,64 V_p$],
    [Frecuencia del rizado (red de 50 Hz)], [50 Hz], [100 Hz], [100 Hz],
    [Secundario], [sencillo], [doble, con toma media], [sencillo],
  ),
  kind: table,
  caption: [Comparación de los tres rectificadores. $V_p$ es la tensión de pico del secundario (de cada mitad, en el de toma media).],
) <t3-tab-rectificadores>

=== El condensador de filtro y el rizado

#circuito(caption: [Salida de un rectificador de onda completa sin condensador (a trazos) y con condensador (trazo continuo). El condensador se carga en cada pico y se descarga poco a poco por la carga entre picos: queda una continua con un pequeño diente de sierra, el rizado $Delta V$.], sim: "fullrectf.txt")[
  #cetz.canvas({
    import cetz.draw: *
    ejes(0, 9.4, 0, 2.6, etq-x: $t$, etq-y: $v$)
    let vp = 2.0
    let w = calc.pi / 2  // un semiciclo cada 2 unidades
    let rect-f = x => vp * calc.abs(calc.sin(x * w * 1rad))
    onda(rect-f, 0, 8, n: 300, stroke: (paint: col.gris, dash: "dashed", thickness: 0.8pt))
    // simulación de la carga y descarga del condensador
    let n = 600
    let dt = 8 / n
    let pts = ()
    let v = 0.0
    for i in range(n + 1) {
      let x = i * dt
      let vr = rect-f(x)
      v = calc.max(vr, v * calc.exp(-dt / 12))
      pts.push((x, v))
    }
    line(..pts, stroke: 1.2pt + col.senal1)
    line((5.0, vp), (8.6, vp), stroke: (dash: "dotted", thickness: 0.5pt))
    let vmin = vp * calc.exp(-1.55 / 12)
    line((5.0, vmin), (8.6, vmin), stroke: (dash: "dotted", thickness: 0.5pt))
    line((8.5, vmin), (8.5, vp), mark: (start: ">", end: ">", fill: black, scale: 0.5), stroke: 0.5pt)
    content((8.65, (vp + vmin) / 2), anchor: "west", text(size: 8pt, $Delta V$))
    content((1, 2.35), text(size: 7.5pt, fill: col.gris)[sin $C$])
    content((3.2, 2.35), text(size: 7.5pt, fill: col.senal1)[con $C$])
  })
] <t3-fig-rizado>

Mientras el condensador se descarga, entrega a la carga la corriente $I$ durante casi todo el periodo del rizado, $T = 1 slash f_r$. Como $Delta Q = C Delta V$ y $Delta Q approx I T$:

#destacada($display(Delta V approx I / (f_r C))$, nota: [rizado pico a pico; $f_r = 100$ Hz en onda completa con red de 50 Hz])

La fórmula dice lo que el texto afirmaba: el rizado crece con la corriente y baja con la frecuencia del rizado y con la capacidad.

#ejemplo[Una fuente de onda completa entrega 2 A con un condensador de 10 000 μF: $Delta V approx 2 slash (100 dot 0,01) = 2$ V de rizado. Con un rectificador de media onda ($f_r = 50$ Hz) serían 4 V, el doble: por eso nadie usa media onda en una fuente de potencia. Si el equipo pidiera 20 A, harían falta 100 000 μF para el mismo rizado; de ahí que las fuentes grandes confíen la última limpieza al regulador.]

=== Estabilizar: el zéner y el regulador

Tras el filtro la tensión aún sube y baja con el rizado, con la red y con el consumo. El último bloque la fija. El regulador más sencillo es un diodo *zéner* polarizado en inverso: por encima de su tensión de ruptura $V_Z$ conduce lo que haga falta para que su tensión apenas cambie (@t3-fig-zener).

#circuito(caption: [Regulador con zéner (izquierda) y regulador integrado de tres terminales (derecha). En los dos, la entrada es la tensión filtrada, con rizado, y la salida es fija.], sim: "zenerref.txt")[
  #esquema({
    import zap: *
    import cetz.draw: rect, content, translate
    // zéner
    wire((0, 2), (0.4, 2))
    resistor("rs", (0.4, 2), (2.2, 2), label: $R_S$)
    wire((2.2, 2), (4.2, 2))
    zener("dz", (2.6, 0), (2.6, 2), label: (content: $V_Z$, anchor: "south"))
    resistor("rl", (4.2, 2), (4.2, 0), label: $R_L$)
    wire((0, 0), (4.2, 0))
    node("a", (0, 2), fill: false)
    node("b", (0, 0), fill: false)
    node("n1", (2.6, 2))
    node("n2", (2.6, 0))
    _t3-et((-0.1, 2.45), [$V_"ent"$ (con rizado)], size: 7.5pt)
    _t3-et((4.6, 2.35), $V_"sal" = V_Z$, size: 8pt)
    // regulador integrado
    translate((7.2, 0))
    wire((0, 2), (1.6, 2))
    rect((1.6, 1.4), (3.2, 2.4), stroke: 0.8pt, fill: white)
    content((2.4, 2.05), text(size: 8pt)[7812])
    content((2.4, 1.65), text(size: 6.5pt)[regulador])
    wire((3.2, 2), (4.8, 2))
    wire((2.4, 1.4), (2.4, 0))
    capacitor("c1", (0.8, 2), (0.8, 0), label: $C_1$)
    capacitor("c2", (4.0, 2), (4.0, 0), label: $C_2$)
    wire((0, 0), (4.8, 0))
    node("a2", (0, 2), fill: false)
    node("b2", (0, 0), fill: false)
    node("o2", (4.8, 2), fill: false)
    node("o3", (4.8, 0), fill: false)
    _t3-et((0.2, 2.45), [entrada], size: 7.5pt)
    _t3-et((4.6, 2.45), [12 V], size: 7.5pt)
  })
] <t3-fig-zener>

#porque[
  - *Zéner.* $R_S$ y el zéner forman un divisor muy especial: el zéner absorbe más o menos corriente para mantener su tensión en $V_Z$. Si la entrada sube, sube la corriente por $R_S$, la toma el zéner y la diferencia de tensión cae en $R_S$. Si la carga pide más corriente, el zéner cede parte de la suya. Sin $R_S$ el zéner estaría conectado directamente al filtro y se quemaría.
  - *Regulador integrado.* Dentro hay un zéner de referencia, un amplificador de error y un transistor de paso: el amplificador compara la salida con la referencia y abre o cierra el transistor para corregirla, miles de veces más deprisa que la variación. $C_1$ y $C_2$ son condensadores de desacoplo: evitan que el regulador oscile y absorben los transitorios, los picos bruscos que viajan por la alimentación (pregunta T3.51). #falstad("opamp-regulator.txt")
]

#ejemplo[Entrada de 18 V, zéner de 12 V y una carga de 50 mA. Si queremos que por el zéner circulen además unos 10 mA, por $R_S$ han de pasar 60 mA con $18 - 12 = 6$ V en sus bornes: $R_S = 6 slash 0,06 = 100$ Ω. Disipa $6 dot 0,06 = 0,36$ W: una resistencia de medio vatio.]

=== La fuente conmutada

#circuito(caption: [Fuente conmutada. La red se rectifica directamente; un transistor la trocea a decenas o cientos de kHz; un transformador pequeño baja la tensión y aísla; un segundo rectificador y un filtro dan la continua. El control compara la salida y ajusta la anchura de los pulsos.])[
  #diagram(
    node-stroke: .7pt, node-corner-radius: 2pt, spacing: (6mm, 9mm),
    node((0, 0), [Red\ 230 V~], stroke: none),
    edge("-|>"),
    node((1, 0), [Rectificador\ y filtro], shape: rect),
    edge("-|>"),
    node((2, 0), [Conmutador\ (100 kHz)], shape: rect),
    edge("-|>"),
    node((3, 0), [Transformador\ de AF], shape: rect),
    edge("-|>"),
    node((4, 0), [Rectificador\ y filtro], shape: rect),
    edge("-|>"),
    node((5, 0), [13,8 V], stroke: none),
    node((3, 1), [Control (anchura de pulso)], shape: rect),
    edge((4, 0), (4, 1), (3, 1), "-|>"),
    edge((3, 1), (2, 1), (2, 0), "-|>"),
  )
] <t3-fig-conmutada>

#porque[El tamaño de un transformador depende de la frecuencia: cuanto más alta, menos hierro y menos espiras hacen falta para la misma potencia. A 100 kHz, uno del tamaño de una caja de cerillas maneja lo que a 50 Hz pediría varios kilos. Además, el transistor trabaja como interruptor, todo abierto o todo cerrado, y casi no disipa: el rendimiento pasa del 50–60 % de una fuente lineal al 80–90 %. El precio son los flancos bruscos de la conmutación, ricos en armónicos que caen de lleno en HF: una fuente conmutada mal filtrada se oye como una serie de «pajaritos» repartidos por la banda. El principio del troceado, con una bobina y un condensador que alisan los pulsos, se ve en un convertidor reductor #falstad("conv-buck.txt").]

#ojo[El orden de una fuente lineal es siempre *transformador → rectificador → filtro → regulador* (pregunta T3.26). El filtro elimina la componente alterna que queda tras rectificar, no la continua (T3.36); el regulador mantiene la tensión aunque cambien la red y la carga (T3.32). Un puente necesita cuatro diodos (T3.35); la onda completa con toma media, dos.]

=== Amplificadores: tres maneras de conectar un transistor

#motivacion[La señal de la antena llega con microvoltios y el altavoz quiere voltios; el micrófono da milivoltios y la antena quiere cien vatios. Hace falta un circuito que copie la señal más grande, sacando la energía de la fuente de alimentación: el amplificador. Su pieza básica es el transistor, que con una corriente de base pequeña gobierna una corriente de colector $beta$ veces mayor (#ver(<sec-transistor>)).]

Un transistor tiene tres patas, y la señal entra por una y sale por otra. La tercera queda *común* a la entrada y a la salida (conectada a masa para la señal), y da nombre al montaje. Los tres montajes de la @t3-fig-configuraciones amplifican de forma distinta; el detalle de cada uno está en #ver(<sec-configuraciones>) y el del emisor común, con su polarización, en #ver(<sec-amplificador-ec>).

// FALSTAD-CUSTOM: base-comun
#circuito(caption: [Los tres montajes del transistor bipolar, dibujados solo para la señal (sin la red de polarización). El terminal común es el que queda unido a masa para la señal.], sim: "ceamp.txt")[
  #esquema(escala: 0.85, {
    import zap: *
    import cetz.draw: translate
    // emisor común
    wire((0, 3.6), (2.4, 3.6))
    _t3-et((1.2, 3.95), $+V_"CC"$, size: 8pt)
    resistor("rc1", (1.5, 3.6), (1.5, 2.3), label: $R_C$)
    npn("q1", (1.5, 1.8))
    wire("q1.e", (1.5, 0.6))
    ground("g1", (1.5, 0.6))
    wire((0, 1.8), "q1.b")
    node("i1", (0, 1.8), fill: false)
    wire((1.5, 2.3), (2.6, 2.3))
    node("o1", (2.6, 2.3), fill: false)
    _t3-et((-0.1, 1.8), [ent.], size: 7.5pt, anchor: "east")
    _t3-et((2.7, 2.3), [sal.], size: 7.5pt, anchor: "west")
    _t3-et((1.3, -1.6), [emisor común], size: 9pt)
    // base común
    translate((4.4, 0))
    wire((0.6, 3.6), (2.6, 3.6))
    _t3-et((1.5, 3.95), $+V_"CC"$, size: 8pt)
    resistor("rc2", (1.5, 3.6), (1.5, 2.3), label: $R_C$)
    npn("q2", (1.5, 1.8))
    wire("q2.b", (0.5, 1.8), (0.5, 1.4))
    ground("g2", (0.5, 1.4))
    wire("q2.e", (1.5, 0.5), (0, 0.5))
    node("i2", (0, 0.5), fill: false)
    wire((1.5, 2.3), (2.6, 2.3))
    node("o2", (2.6, 2.3), fill: false)
    _t3-et((-0.1, 0.5), [ent.], size: 7.5pt, anchor: "east")
    _t3-et((2.7, 2.3), [sal.], size: 7.5pt, anchor: "west")
    _t3-et((1.3, -1.6), [base común], size: 9pt)
    // colector común
    translate((4.4, 0))
    wire((0.6, 3.6), (2.6, 3.6))
    _t3-et((1.5, 3.95), $+V_"CC"$, size: 8pt)
    npn("q3", (1.5, 1.8))
    wire((1.5, 3.6), "q3.c")
    wire("q3.e", (1.5, 0.9))
    resistor("re3", (1.5, 0.9), (1.5, -0.6), label: $R_E$)
    ground("g3", (1.5, -0.6))
    wire((0, 1.8), "q3.b")
    node("i3", (0, 1.8), fill: false)
    wire((1.5, 0.9), (2.6, 0.9))
    node("o3", (2.6, 0.9), fill: false)
    node("n3", (1.5, 0.9))
    _t3-et((-0.1, 1.8), [ent.], size: 7.5pt, anchor: "east")
    _t3-et((2.7, 0.9), [sal.], size: 7.5pt, anchor: "west")
    _t3-et((1.3, -1.6), [colector común], size: 9pt)
  })
] <t3-fig-configuraciones>

#porque[
  - *Emisor común.* La señal mueve la base y sale por el colector. Una pequeña corriente de base produce una gran corriente de colector (ganancia de corriente $beta$), y esa corriente, al pasar por $R_C$, da una gran variación de tensión (ganancia de tensión). Cuando la base sube, el transistor conduce más, cae más tensión en $R_C$ y el colector *baja*: la salida está invertida 180°.
  - *Base común.* La señal entra por el emisor y sale por el colector; la base está a masa. La corriente de colector es casi la misma que la de emisor (ganancia de corriente algo menor que 1), pero la entrada tiene una impedancia muy baja y la salida, muy alta: la misma corriente produce mucha más tensión en la salida. Amplifica tensión, no corriente, y se porta muy bien a frecuencias altas.
  - *Colector común* o *seguidor de emisor*. La señal entra por la base y sale por el emisor, que la «sigue» unos 0,6 V por debajo: ganancia de tensión casi 1, en fase. Pero la corriente de salida es $beta + 1$ veces la de entrada, y la impedancia de entrada es muy alta y la de salida muy baja: es el adaptador de impedancias. #falstad("follower.txt")
]

#figure(
  {
  set par(justify: false)
  table(
    columns: (auto, 1fr, 1fr, 1fr),
    align: (left, center, center, center),
    [], [*Emisor común*], [*Base común*], [*Colector común*],
    [Entrada / salida], [base / colector], [emisor / colector], [base / emisor],
    [Ganancia de tensión], [alta], [alta], [≈ 1 (algo menor)],
    [Ganancia de corriente], [alta ($beta$)], [≈ 1 (algo menor)], [alta ($beta + 1$)],
    [Impedancia de entrada], [media], [muy baja], [alta],
    [Impedancia de salida], [media-alta], [alta], [muy baja],
    [Fase salida/entrada], [invertida 180°], [en fase], [en fase],
    [Uso típico], [amplificador general (FI, audio)], [RF y VHF, preamplificadores], [separador (_buffer_), adaptar impedancias],
  )
  },
  kind: table,
  caption: [Los tres montajes del transistor. El emisor común es el único que da a la vez ganancia de tensión y de corriente, y el único que invierte la fase.],
) <t3-tab-configuraciones>

#ojo[La pregunta T3.37 cae siempre igual: el montaje en *base común* amplifica *tensión, pero no corriente*. El seguidor de emisor (colector común) es su opuesto: amplifica corriente, no tensión. Entre etapas, el acoplamiento por condensador o transformador deja pasar la señal y separa las polarizaciones (T3.49).]

=== Las clases de amplificación

En los *amplificadores*, la clase indica qué fracción del ciclo conduce el dispositivo, y con ella se intercambian linealidad y rendimiento: *clase A* conduce los 360° (mínima distorsión, rendimiento máximo teórico del 25–50 %); *clase B*, medio ciclo (dos transistores en contrafase, hasta el 78,5 %); *clase AB*, el compromiso entre ambas que usan los finales de SSB; y *clase C*, menos de medio ciclo — el más eficiente y el más distorsionador, válido solo para señales de envolvente constante como FM o CW. Toda no linealidad genera *armónicos* y productos de *intermodulación*: por eso la sobreexcitación de un amplificador es fuente clásica de interferencias.

Los rendimientos máximos tienen su porqué. En clase A el transistor conduce siempre y disipa incluso sin señal: a la carga llega, como mucho, el 25 % de la potencia de alimentación (50 % con acoplo por transformador). En clase B cada transistor trabaja medio ciclo y el límite teórico sube a $pi slash 4 approx 78,5$ %. La clase C lo supera recortando aún más el ángulo de conducción, pero destroza la envolvente: solo vale para señales que no llevan información en ella (CW, FM). La @t3-fig-clases resume de un vistazo ese reparto del ciclo.

#circuito(caption: [Ángulo de conducción de las cuatro clases. En trazo grueso, la parte del ciclo en que el dispositivo conduce; a trazos, lo que no reproduce. Cuanto menos conduce, menos energía malgasta — y peor conserva la forma de la señal.])[
  #cetz.canvas({
    import cetz.draw: *
    let panel(x0, titulo, color, desde, hasta, l1, l2) = {
      let tp = 2 * calc.pi
      let sx = 3.0 / tp
      let f = t => 0.8 * calc.sin(t * 1rad)
      line((x0, 0), (x0 + 3.3, 0), mark: (end: ">", fill: black, scale: 0.5), stroke: 0.5pt)
      line((x0, -1.0), (x0, 1.2), mark: (end: ">", fill: black, scale: 0.5), stroke: 0.5pt)
      // parte no reproducida
      let pts = range(161).map(i => { let t = tp * i / 160; (x0 + t * sx, f(t)) })
      line(..pts, stroke: (paint: col.gris.lighten(30%), dash: "dashed", thickness: 0.6pt))
      // parte conducida
      let a = calc.max(desde, 0)
      let b = calc.min(hasta, tp)
      let pts2 = range(121).map(i => { let t = a + (b - a) * i / 120; (x0 + t * sx, f(t)) })
      line(..pts2, stroke: 1.5pt + color)
      if desde < 0 {
        let pts3 = range(41).map(i => { let t = tp + desde * (1 - i / 40); (x0 + t * sx, f(t)) })
        line(..pts3, stroke: 1.5pt + color)
      }
      content((x0 + 1.6, 1.5), text(size: 8.5pt, weight: "bold", titulo))
      content((x0 + 1.6, -1.35), text(size: 7pt, fill: col.gris, l1))
      content((x0 + 1.6, -1.7), text(size: 7pt, fill: col.gris, l2))
    }
    panel(0, [clase A], col.senal1, 0, 2 * calc.pi, [conduce los 360°], [rendimiento 25–50 %])
    panel(3.9, [clase AB], col.senal3, -0.45, calc.pi + 0.45, [conduce algo más de 180°], [rendimiento intermedio])
    panel(7.8, [clase B], col.senal4, 0, calc.pi, [conduce 180°], [rendimiento hasta 78,5 %])
    panel(11.7, [clase C], col.naranja, calc.pi / 2 - 0.75, calc.pi / 2 + 0.75, [conduce menos de 180°], [rendimiento el mayor])
  })
] <t3-fig-clases>

#ojo[De ahí la regla que el examen pregunta de mil maneras: los amplificadores lineales de SSB son de clase AB, nunca de clase C. En clase C la información que viaja en la amplitud se destruye.]

#q("T3.5", "c",
  [Los circuitos de filtrado a la salida de una fuente de alimentación sirven para:],
  ([aumentar el rizado de la tensión de salida], [elevar la tensión de salida], [reducir el rizado y obtener una tensión más constante], [limitar la corriente de arranque]),
  sol: [Tras el rectificador la tensión es pulsante; el filtrado (condensadores, bobinas) reduce el rizado y entrega una tensión casi constante.],
)

#q("T3.6", "a",
  [La clase de amplificador que reproduce la señal de entrada con la mínima distorsión es la:],
  ([clase A], [clase B], [clase C], [clase D]),
  sol: [La clase A conduce durante todo el ciclo: mínima distorsión y peor rendimiento. B y C recortan el ciclo a cambio de eficiencia.],
)

== Filtros, osciladores y mezcladores <t3-sec-filtros>

#motivacion[Un receptor tiene que dejar pasar la emisora que escuchas y rechazar la de al lado; un transmisor tiene que emitir su frecuencia y no sus armónicos; una fuente tiene que dar continua y no el zumbido de la red. Las tres cosas son el mismo problema: separar señales por su frecuencia. El circuito que lo hace es el filtro.]

Un *filtro* selecciona por frecuencia. Los cuatro tipos canónicos: paso bajo, paso alto, *paso banda* (deja su banda y atenúa por encima y por debajo: el filtro de la FI) y rechazo de banda. Con bobinas y condensadores se construyen las redes en *pi* y en *T*, bautizadas por la forma de su esquema: tres elementos, que en un paso bajo se ordenan condensador–bobina–condensador (pi) o bobina–condensador–bobina (T), y que intercambian sus papeles en el paso alto. Cuando hace falta una selectividad extrema se recurre al *cristal de cuarzo*, cuya resonancia piezoeléctrica alcanza $Q$ de decenas de miles, o a *filtros digitales* calculados en un DSP: los *FIR* (_finite impulse response_) combinan un número finito de muestras sin realimentación, mientras que los *IIR* (_infinite impulse response_) realimentan su propia salida, y su respuesta a un impulso se prolonga, en teoría, indefinidamente.

#circuito(caption: [Respuesta de los cuatro tipos de filtro: qué fracción de la señal sale a cada frecuencia. La *frecuencia de corte* $f_c$ separa la banda de paso de la de atenuación y se toma, por convenio, donde la salida ha caído 3 dB.])[
  #cetz.canvas({
    import cetz.draw: *
    let panel(x0, titulo, f, marcas) = {
      line((x0, 0), (x0 + 3.2, 0), mark: (end: ">", fill: black, scale: 0.5), stroke: 0.5pt)
      line((x0, 0), (x0, 1.7), mark: (end: ">", fill: black, scale: 0.5), stroke: 0.5pt)
      let pts = range(161).map(i => { let x = 0.05 + 2.95 * i / 160; (x0 + x, 1.3 * f(x)) })
      line(..pts, stroke: 1.2pt + col.senal1)
      for (m, etq) in marcas {
        line((x0 + m, 0), (x0 + m, 1.35), stroke: (dash: "dotted", thickness: 0.5pt))
        content((x0 + m, -0.08), anchor: "north", text(size: 7pt, etq))
      }
      content((x0 + 1.6, 2.0), text(size: 8.5pt, weight: "bold", titulo))
      content((x0 + 3.2, -0.08), anchor: "north-east", text(size: 7pt, $f$))
    }
    let fc = 1.4
    panel(0, [paso bajo], x => 1 / calc.sqrt(1 + calc.pow(x / fc, 4)), ((fc, $f_c$),))
    panel(4.0, [paso alto], x => calc.pow(x / fc, 2) / calc.sqrt(1 + calc.pow(x / fc, 4)), ((fc, $f_c$),))
    panel(8.0, [paso banda], x => _t3-res(x / 1.5, 2.5), ((1.5, $f_0$),))
    panel(12.0, [rechazo de banda], x => 1 - _t3-res(x / 1.5, 2.5), ((1.5, $f_0$),))
  })
] <t3-fig-tipos-filtro>

=== La célula RC y la pendiente

La pendiente con que corta un filtro se mide en decibelios por octava: cada «polo» (cada célula reactiva) aporta 6 dB/octava: en una célula RC, muy por encima del corte la salida decae como $1 slash f$, de modo que al doblar la frecuencia se divide por dos, y la mitad en tensión son 6 dB. Así, un paso bajo de tres células cae 18 dB al doblar la frecuencia. Para la célula RC más simple, la frecuencia de corte — el punto de −3 dB — es
$ f_c = 1 / (2 pi R C), $
la misma constante de tiempo $tau = R C$ del tema T2 vista desde el dominio de la frecuencia.

El filtro $R C$ explicado desde cero, con la reactancia del condensador como protagonista, está en #ver(<sec-filtros-rc>).

#circuito(caption: [Célula RC de paso bajo (izquierda) y de paso alto (derecha). Son los mismos dos componentes con los papeles cambiados.], sim: "filt-lopass.txt")[
  #esquema({
    import zap: *
    import cetz.draw: translate
    resistor("r1", (0, 1.6), (2, 1.6), label: $R$, n: "o-*")
    wire((2, 1.6), (3.2, 1.6))
    capacitor("c1", (2, 1.6), (2, 0), label: $C$)
    wire((0, 0), (3.2, 0))
    node("a", (0, 0), fill: false)
    node("b", (3.2, 1.6), fill: false)
    node("c", (3.2, 0), fill: false)
    node("d", (2, 0))
    _t3-et((-0.1, 0.8), [entrada], anchor: "east", size: 7.5pt)
    _t3-et((3.3, 0.8), [salida], anchor: "west", size: 7.5pt)
    _t3-et((1.6, -0.6), [paso bajo], size: 9pt)
    translate((6.4, 0))
    capacitor("c2", (0, 1.6), (2, 1.6), label: $C$, n: "o-*")
    wire((2, 1.6), (3.2, 1.6))
    resistor("r2", (2, 1.6), (2, 0), label: $R$)
    wire((0, 0), (3.2, 0))
    node("a2", (0, 0), fill: false)
    node("b2", (3.2, 1.6), fill: false)
    node("c2b", (3.2, 0), fill: false)
    node("d2", (2, 0))
    _t3-et((-0.1, 0.8), [entrada], anchor: "east", size: 7.5pt)
    _t3-et((3.3, 0.8), [salida], anchor: "west", size: 7.5pt)
    _t3-et((1.6, -0.6), [paso alto], size: 9pt)
  })
] <t3-fig-rc>

#porque[
  - El condensador es un «interruptor que depende de la frecuencia»: a frecuencias bajas su reactancia es enorme (casi un circuito abierto) y a frecuencias altas, muy pequeña (casi un cortocircuito).
  - *Paso bajo.* $R$ y $C$ forman un divisor de tensión. A baja frecuencia el condensador apenas conduce y casi toda la tensión llega a la salida; a alta frecuencia el condensador lleva la señal a masa. El corte está donde $X_C = R$: de ahí $f_c = 1 slash (2 pi R C)$.
  - *Paso alto.* El condensador está ahora en el camino de la señal: bloquea las frecuencias bajas (y la continua) y deja pasar las altas. Es el mismo condensador de acoplo que hay entre dos etapas amplificadoras. #falstad("filt-hipass.txt")
]

#ejemplo[Con $R = 10$ kΩ y $C = 10$ nF, $f_c = 1 slash (2 pi dot 10^4 dot 10^(-8)) approx 1,6$ kHz. Como paso bajo de audio deja pasar la voz grave y atenúa el siseo: a 3,2 kHz (una octava por encima) la salida es ya unos 7 dB menor, y a 6,4 kHz, unos 12 dB menor; muy por encima del corte, cada octava resta 6 dB.]

#nota[Los decibelios miden relaciones. Cuando se añade una referencia, el dB se convierte en una unidad: el dBμV toma como referencia 1 μV y expresa, por tanto, una *tensión* (pregunta T3.39); el dBm (referencia 1 mW) y el dBW (1 W) expresan potencias.]

=== Filtros con bobinas y condensadores

En radiofrecuencia las resistencias de un filtro RC gastarían la señal: se usan bobinas y condensadores, que no disipan. La bobina hace lo contrario que el condensador —deja pasar las frecuencias bajas y frena las altas—, y con las dos piezas se arman los cuatro tipos (@t3-fig-lc).

#circuito(caption: [Los cuatro filtros LC más sencillos. En el paso banda, el circuito resonante serie del camino de la señal solo conduce cerca de $f_0$; en el rechazo de banda, el mismo circuito, conectado a masa, cortocircuita justo esa frecuencia (es una «trampa»).], sim: "notch.txt")[
  #esquema(escala: 0.78, {
    import zap: *
    import cetz.draw: translate
    let marco(etq) = {
      wire((0, 0), (3.4, 0))
      node("x1", (0, 1.6), fill: false)
      node("x2", (0, 0), fill: false)
      node("x3", (3.4, 1.6), fill: false)
      node("x4", (3.4, 0), fill: false)
      _t3-et((1.7, -0.7), etq, size: 10pt)
    }
    // paso bajo
    inductor("l1", (0, 1.6), (2.2, 1.6), label: $L$)
    wire((2.2, 1.6), (3.4, 1.6))
    capacitor("c1", (2.2, 1.6), (2.2, 0), label: $C$)
    marco([paso bajo])
    translate((4.6, 0))
    capacitor("c2", (0, 1.6), (2.2, 1.6), label: $C$)
    wire((2.2, 1.6), (3.4, 1.6))
    inductor("l2", (2.2, 1.6), (2.2, 0), label: $L$)
    marco([paso alto])
    translate((4.6, 0))
    inductor("l3", (0, 1.6), (1.7, 1.6), label: $L$)
    capacitor("c3", (1.7, 1.6), (3.4, 1.6), label: $C$)
    marco([paso banda])
    translate((4.6, 0))
    wire((0, 1.6), (3.4, 1.6))
    inductor("l4", (1.7, 1.6), (1.7, 0.7), label: $L$)
    capacitor("c4", (1.7, 0.7), (1.7, 0), label: $C$)
    marco([rechazo de banda])
  })
] <t3-fig-lc>

#porque[
  - *Paso bajo.* La bobina en serie frena las frecuencias altas y el condensador a masa se las lleva; las bajas pasan por la bobina sin oposición y no «ven» el condensador. Es el filtro que va a la salida del transmisor, porque los armónicos están por encima de la frecuencia de trabajo (T3.33).
  - *Paso alto.* Los papeles se intercambian: el condensador en serie frena las bajas y la bobina a masa se las lleva.
  - *Paso banda.* $L$ y $C$ en serie se anulan en $f_0$ y dejan pasar esa frecuencia; lejos de ella, uno de los dos presenta mucha reactancia. Otra forma muy usada es un tanque paralelo a masa, que solo deja de cortocircuitar la señal en su resonancia #falstad("bandpass.txt").
  - *Rechazo de banda.* El circuito resonante serie a masa es casi un cortocircuito en $f_0$ y nada a las demás frecuencias: se traga una frecuencia concreta. Así funciona el circuito de la pregunta T3.16.
]

=== Las redes en pi y en T

#motivacion[La válvula o el transistor final de un transmisor rinde su potencia sobre una carga de cientos o miles de ohmios; la antena y el cable son de 50 Ω. Si se conectan sin más, la mayor parte de la potencia rebota y se queda en la etapa. Además, la salida lleva armónicos que no deben radiarse. Hace falta un circuito que haga dos cosas a la vez: *adaptar* la impedancia (presentar a la etapa la carga que necesita y entregar a la antena lo que ella espera) y *filtrar*. Esas son las redes en pi y en T.]

Una red en pi o en T es, sencillamente, un filtro LC de *tres* elementos. El nombre lo da el dibujo (@t3-fig-pi-t): en la *pi* hay dos elementos a masa y uno en serie entre ellos, como las dos patas y el travesaño de la letra griega $pi$; en la *T* hay dos elementos en serie y uno a masa en el centro, como la letra T tumbada al revés. Si los elementos en serie son bobinas y los de masa condensadores, la red es un paso bajo; si se intercambian, un paso alto. Las redes de adaptación en general se explican en #ver(<sec-redes-adaptacion>).

// FALSTAD-CUSTOM: red-T
#circuito(caption: [Redes de adaptación de dos y de tres elementos, en versión paso bajo (arriba) y paso alto (abajo). La red en L es la más sencilla; la pi y la T añaden un tercer elemento.])[
  #esquema(escala: 0.72, {
    import zap: *
    import cetz.draw: translate, group
    let marco(w, etq: none) = {
      wire((0, 0), (w, 0))
      node("x1", (0, 1.6), fill: false)
      node("x2", (0, 0), fill: false)
      node("x3", (w, 1.6), fill: false)
      node("x4", (w, 0), fill: false)
      if etq != none { _t3-et((w / 2, 3.3), etq, size: 11pt) }
    }
    // fila paso bajo
    group({
      translate((0, 3.4))
      inductor("a1", (0, 1.6), (2.0, 1.6), label: $L$)
      wire((2.0, 1.6), (2.8, 1.6))
      capacitor("a2", (2.0, 1.6), (2.0, 0), label: $C$)
      marco(2.8, etq: [en L])
      translate((4.4, 0))
      wire((0, 1.6), (0.7, 1.6))
      capacitor("b1", (0.7, 1.6), (0.7, 0), label: $C_1$)
      inductor("b2", (0.7, 1.6), (2.7, 1.6), label: $L$)
      capacitor("b3", (2.7, 1.6), (2.7, 0), label: $C_2$)
      wire((2.7, 1.6), (3.4, 1.6))
      marco(3.4, etq: [en pi ($pi$)])
      translate((5.0, 0))
      inductor("t1", (0, 1.6), (1.8, 1.6), label: $L_1$)
      inductor("t2", (1.8, 1.6), (3.6, 1.6), label: $L_2$)
      capacitor("t3", (1.8, 1.6), (1.8, 0), label: $C$)
      marco(3.6, etq: [en T])
      _t3-et((4.6, 0.8), [paso\ bajo], size: 9pt)
    })
    // fila paso alto
    group({
      capacitor("d1", (0, 1.6), (2.0, 1.6), label: $C$)
      wire((2.0, 1.6), (2.8, 1.6))
      inductor("d2", (2.0, 1.6), (2.0, 0), label: $L$)
      marco(2.8)
      translate((4.4, 0))
      wire((0, 1.6), (0.7, 1.6))
      inductor("e1", (0.7, 1.6), (0.7, 0), label: $L_1$)
      capacitor("e2", (0.7, 1.6), (2.7, 1.6), label: $C$)
      inductor("e3", (2.7, 1.6), (2.7, 0), label: $L_2$)
      wire((2.7, 1.6), (3.4, 1.6))
      marco(3.4)
      translate((5.0, 0))
      capacitor("f1", (0, 1.6), (1.8, 1.6), label: $C_1$)
      capacitor("f2", (1.8, 1.6), (3.6, 1.6), label: $C_2$)
      inductor("f3", (1.8, 1.6), (1.8, 0), label: $L$)
      marco(3.6)
      _t3-et((4.6, 0.8), [paso\ alto], size: 9pt)
    })
  })
] <t3-fig-pi-t>

#porque[
  - *Por qué adapta.* Una bobina y un condensador no disipan potencia: solo la almacenan y la devuelven. Una red hecha solo de ellos entrega a la salida toda la potencia que recibe, pero puede cambiar la relación entre tensión y corriente. Con los valores adecuados, la etapa «ve» en la entrada la impedancia que le conviene (por ejemplo 2000 Ω) aunque en la salida haya 50 Ω: la red trabaja como un transformador de impedancias.
  - *Por qué dos elementos no bastan.* La red en L ya adapta, pero no deja elegir nada: para pasar de $R_1$ a $R_2$, su factor de calidad queda fijado en $Q = sqrt(R_1 slash R_2 - 1)$. Para 2000 Ω a 50 Ω sale $Q approx 6$, y con él quedan fijados el ancho de banda y lo que se atenúan los armónicos.
  - *Para qué el tercero.* El tercer elemento da un grado de libertad más: se puede elegir el $Q$ de la red (más alto, mejor rechazo de armónicos; más bajo, más ancho de banda y menos pérdidas) y, con componentes variables, adaptar cargas muy distintas con la misma red. Además, tres elementos reactivos son tres polos: muy por encima del corte, 18 dB por octava.
  - *Pi o T.* La pi de paso bajo pone condensadores a masa en los dos extremos: absorben las capacidades parásitas de la válvula o del transistor y de la línea, y llevan los armónicos a masa. Por eso es *la* red de salida de los transmisores. La T de paso alto (condensador–bobina–condensador) es la base de muchos acopladores de antena.
]

// FALSTAD-CUSTOM: red-pi
#circuito(caption: [Red en pi a la salida de un paso final de válvula. $C_1$ (sintonía, o «placa») y $C_2$ (carga) son variables. Los valores son los de una red para 7,1 MHz que adapta 2000 Ω a 50 Ω con $Q = 10$.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    triodo("v1", (1.4, 2.0))
    wire("v1.catodo", (1.4, 0))
    wire("v1.rejilla", (0, 2.0))
    node("in", (0, 2.0), fill: false)
    _t3-et((0, 2.4), [excitación], size: 7.5pt)
    // alimentación de placa por choque
    wire("v1.placa", (1.4, 3.4))
    inductor("rfc", (1.4, 3.4), (1.4, 5.2), label: [choque])
    _t3-et((1.4, 5.55), $+V_"placa"$, size: 8pt)
    // red pi
    capacitor("cb", (1.4, 3.4), (3.0, 3.4), label: [bloqueo], n: "*-")
    wire((3.0, 3.4), (3.4, 3.4))
    capacitor("c1", (3.4, 3.4), (3.4, 0), variable: true, label: (content: [$C_1$\ 110 pF], distance: 10pt))
    inductor("lp", (3.4, 3.4), (5.8, 3.4), label: [$L$ 5 μH])
    capacitor("c2", (5.8, 3.4), (5.8, 0), variable: true, label: (content: [$C_2$\ 550 pF], distance: 10pt))
    wire((5.8, 3.4), (8.4, 3.4))
    resistor("ant", (8.4, 3.4), (8.4, 0), label: [antena\ 50 Ω])
    wire((1.4, 0), (8.4, 0))
    node("n1", (3.4, 3.4))
    node("n2", (5.8, 3.4))
    node("n3", (3.4, 0))
    node("n4", (5.8, 0))
    ground("g", (4.6, 0))
  })
] <t3-fig-pi-pa>

#porque[
  - La bobina de *choque* lleva la alta tensión continua a la placa y presenta una reactancia enorme a la RF, que así no se escapa hacia la fuente.
  - El condensador de *bloqueo* deja pasar la RF hacia la red y separa la alta tensión continua de los condensadores variables (y del operador que gira sus mandos).
  - $C_1$, $L$ y $C_2$ forman la pi. Con $C_1$ se sintoniza la red a la frecuencia de trabajo (se busca el mínimo de corriente de placa); con $C_2$ se ajusta la carga, es decir, cuánta potencia se extrae hacia la antena. Como es un paso bajo, el segundo y el tercer armónico se atenúan con fuerza.
  - El conmutador de bandas de un equipo selecciona otra toma de $L$ (y los filtros que correspondan) para cada banda: lo que «sitúa el equipo» en el margen de frecuencias deseado (T3.54).
]

#ejemplo[Para 7,1 MHz, adaptando una carga de placa de 2000 Ω a 50 Ω con $Q = 10$, las fórmulas de diseño (que no entran en el examen) dan $X_(C 1) = 200$ Ω, $X_(C 2) approx 40$ Ω y $X_L approx 222$ Ω, es decir, $C_1 approx 110$ pF, $C_2 approx 550$ pF y $L approx 5$ μH. Con la red en L, el $Q$ habría quedado fijado en 6,2, sin margen para elegir.]

#ojo[Sintonizar la etapa final a plena potencia puede dañar el paso final: mientras la red está desajustada, la potencia no sale hacia la antena y se disipa en la propia válvula o transistor. Se sintoniza a potencia reducida y después se sube (T3.53). Y recuerda que los armónicos son múltiplos enteros: el segundo armónico de 7 MHz cae en 14 MHz (T3.47).]

El mismo dibujo en pi aparece también en las fuentes de alimentación: condensador, bobina (o resistencia) y condensador después del rectificador forman un *filtro en pi* de paso bajo que deja pasar la continua y frena el rizado mucho mejor que un solo condensador.

// FALSTAD-CUSTOM: filtro-pi-fuente
#circuito(caption: [Filtro en pi de una fuente de alimentación: la misma forma de red, ahora para separar la continua (frecuencia cero) del rizado de 100 Hz.])[
  #esquema({
    import zap: *
    wire((0, 1.6), (0.8, 1.6))
    capacitor("c1", (0.8, 0), (0.8, 1.6), label: $C_1$)
    inductor("l", (0.8, 1.6), (3.0, 1.6), label: [choque $L$])
    capacitor("c2", (3.0, 0), (3.0, 1.6), label: $C_2$)
    wire((3.0, 1.6), (4.0, 1.6))
    wire((0, 0), (4.0, 0))
    node("a", (0, 1.6), fill: false)
    node("b", (0, 0), fill: false)
    node("c", (4.0, 1.6), fill: false)
    node("d", (4.0, 0), fill: false)
    _t3-et((-0.1, 0.8), [del rectificador], anchor: "east", size: 7.5pt)
    _t3-et((4.1, 0.8), [continua], anchor: "west", size: 7.5pt)
  })
] <t3-fig-pi-fuente>

#porque[$C_1$ se carga en los picos como el condensador de filtro normal. La bobina deja pasar la continua sin oposición, pero a 100 Hz presenta una reactancia alta y frena el rizado; $C_2$ cortocircuita a masa lo poco que pasa. Cada elemento añade atenuación al rizado, igual que en la pi de RF cada elemento añade atenuación a los armónicos.]

=== Filtros de cristal y cerámicos

El *cristal de cuarzo* es una lámina tallada entre dos electrodos. El cuarzo es *piezoeléctrico*: se deforma al aplicarle tensión y genera tensión al deformarse. Si se le aplica una alterna justo a la frecuencia a la que la lámina vibra mecánicamente, la vibración se hace grande y el cristal intercambia mucha corriente con el circuito: eléctricamente se comporta como un circuito resonante con un $Q$ altísimo (@t3-fig-cristal). La explicación larga está en #ver(<sec-cristal>).

#circuito(caption: [Cristal de cuarzo: símbolo, circuito equivalente y reactancia frente a la frecuencia. La rama $L_m C_m R_m$ representa la vibración mecánica; $C_0$, la capacidad de los electrodos. Hay una resonancia serie $f_s$ (reactancia nula) y, muy poco por encima, una paralelo $f_p$ (reactancia máxima).], sim: "crystalosc2.txt")[
  #esquema({
    import zap: *
    import cetz.draw: line, content, translate
    cristal("x", (0, 2.6), (0, 1.0))
    _t3-et((0, -0.5), [símbolo], size: 8pt)
    translate((1.6, 0))
    wire((0, 3.6), (2.6, 3.6))
    wire((0, 0), (2.6, 0))
    node("ta", (0, 3.6), fill: false)
    node("tb", (0, 0), fill: false)
    inductor("lm", (1.0, 3.6), (1.0, 2.4), label: $L_m$)
    capacitor("cm", (1.0, 2.4), (1.0, 1.6), label: $C_m$)
    resistor("rm", (1.0, 1.6), (1.0, 0), label: $R_m$)
    capacitor("c0", (2.6, 3.6), (2.6, 0), label: $C_0$)
    node("a", (1.0, 3.6))
    node("b", (1.0, 0))
    _t3-et((1.3, -0.5), [circuito equivalente], size: 8pt)
    // reactancia
    translate((4.4, 1.8))
    line((0, 0), (4.4, 0), mark: (end: ">", fill: black, scale: 0.5), stroke: 0.5pt)
    line((0, -1.4), (0, 1.5), mark: (end: ">", fill: black, scale: 0.5), stroke: 0.5pt)
    content((0.1, 1.5), anchor: "west", text(size: 7.5pt, $X$))
    content((4.4, -0.1), anchor: "north", text(size: 7.5pt, $f$))
    let fs = 1.8
    let fp = 2.6
    let xr = x => 0.25 * (x * x - fs * fs) / (x * (fp * fp - x * x))
    let pts1 = range(81).map(i => { let x = 0.6 + (fp - 0.09 - 0.6) * i / 80; (x, calc.max(-1.3, calc.min(1.4, xr(x) * 3))) })
    line(..pts1, stroke: 1.1pt + col.senal1)
    let pts2 = range(61).map(i => { let x = fp + 0.06 + (4.2 - fp - 0.06) * i / 60; (x, calc.max(-1.3, calc.min(1.4, xr(x) * 3))) })
    line(..pts2, stroke: 1.1pt + col.senal1)
    line((fp, -1.3), (fp, 1.4), stroke: (dash: "dotted", thickness: 0.5pt))
    content((fs, -0.1), anchor: "north-east", text(size: 7.5pt, $f_s$))
    content((fp + 0.05, -0.1), anchor: "north-west", text(size: 7.5pt, $f_p$))
    content((fs - 0.05, 1.15), anchor: "east", text(size: 7pt, fill: col.gris)[inductivo])
    content((1.0, -1.0), text(size: 7pt, fill: col.gris)[capacitivo])
    content((3.7, -1.0), text(size: 7pt, fill: col.gris)[capacitivo])
  })
] <t3-fig-cristal>

#porque[
  - Por debajo de $f_s$ manda $C_m$ (diminuta) y el cristal es capacitivo. En $f_s$, $L_m$ y $C_m$ resuenan en serie y solo queda $R_m$, de unos pocos ohmios: el cristal conduce muy bien. Un poco por encima, la rama mecánica es inductiva y resuena en paralelo con $C_0$ en $f_p$: impedancia máxima.
  - La bobina equivalente $L_m$ es enorme (milihenrios) y la pérdida $R_m$ muy pequeña, así que $Q = 2 pi f L_m slash R_m$ llega a decenas de miles. Una bobina de verdad rara vez pasa de 200–300.
  - La frecuencia la fija la geometría de la lámina, que apenas cambia con la temperatura: de ahí la estabilidad de los osciladores a cristal (T3.45, T3.46). A cambio, la frecuencia apenas puede moverse.
]

#ejemplo[Un cristal de 10 MHz típico tiene $L_m = 2,5$ mH, $C_m = 0,1$ pF, $R_m = 6,4$ Ω y $C_0 = 28,7$ pF. Su reactancia en resonancia es $X = 2 pi f L_m approx 158$ kΩ, luego $Q approx 158 000 slash 6,4 approx 25 000$. La resonancia paralelo cae solo unos 17 kHz por encima de la serie.]

Un solo cristal es demasiado estrecho para dejar pasar una emisión de voz. Encadenando varios en escalera, con condensadores a masa entre ellos, se consigue un *filtro de cristal* paso banda de flancos muy verticales y con justo la anchura necesaria: unos 2,4 kHz para SSB, 500 Hz o menos para CW (@t3-fig-escalera). Es el filtro típico de la FI (T3.50). La *anchura de banda necesaria* de una emisión es, por definición, la estrictamente suficiente para transmitir la información con la calidad requerida (T3.34): un filtro más ancho deja entrar ruido y estaciones vecinas, y uno más estrecho mutila la señal. Los *filtros cerámicos* se basan en el mismo efecto piezoeléctrico con resonadores de cerámica: más baratos y con menos $Q$, son los habituales en 455 kHz y 10,7 MHz.

#circuito(caption: [Filtro de cristal en escalera de cuatro cristales iguales, el típico de la FI de un receptor de SSB o CW. Los condensadores a masa fijan la anchura de la banda de paso.])[
  #esquema({
    import zap: *
    wire((0, 1.6), (0.4, 1.6))
    cristal("x1", (0.4, 1.6), (1.8, 1.6), label: $X_1$)
    cristal("x2", (1.8, 1.6), (3.4, 1.6), label: $X_2$)
    cristal("x3", (3.4, 1.6), (5.0, 1.6), label: $X_3$)
    cristal("x4", (5.0, 1.6), (6.4, 1.6), label: $X_4$)
    wire((6.4, 1.6), (6.8, 1.6))
    capacitor("c1", (1.8, 1.6), (1.8, 0), label: $C$)
    capacitor("c2", (3.4, 1.6), (3.4, 0), label: $C$)
    capacitor("c3", (5.0, 1.6), (5.0, 0), label: $C$)
    wire((0, 0), (6.8, 0))
    node("a", (0, 1.6), fill: false)
    node("b", (0, 0), fill: false)
    node("c", (6.8, 1.6), fill: false)
    node("d", (6.8, 0), fill: false)
    _t3-et((-0.1, 0.8), [del mezclador], anchor: "east", size: 7.5pt)
    _t3-et((6.9, 0.8), [a la FI], anchor: "west", size: 7.5pt)
  })
] <t3-fig-escalera>

#porque[Cada cristal en serie solo conduce bien cerca de su resonancia serie; fuera de ella presenta una reactancia muy alta, y los condensadores a masa terminan de desviar lo que se cuela. Al encadenar cuatro, las atenuaciones se suman y los flancos se hacen casi verticales. Los condensadores también «ensanchan» un poco la banda conjunta: con ellos se elige si el filtro es para SSB o para CW.]

=== Osciladores

#motivacion[Todo transmisor necesita crear su portadora, y todo superheterodino, su oscilador local. Hace falta un circuito que, alimentado con continua, entregue una alterna de frecuencia exacta y estable (pregunta T3.27): el oscilador. La historia completa, desde el columpio hasta el cristal, está en #ver(<sec-oscilador>).]

Un *oscilador* es un amplificador que se realimenta a sí mismo: oscila cuando la ganancia del lazo compensa las pérdidas y la fase total es múltiplo de 360° (condición de Barkhausen). El circuito LC fija la frecuencia en los osciladores clásicos; el *cristal* la fija con estabilidad excelente; el *VCO* la controla por tensión mediante un varicap. Sobre el VCO se montan las dos síntesis modernas: el *PLL*, un lazo que compara la fase del VCO dividida por $N$ con una referencia de cristal y lo corrige hasta engancharlo ($f_"out" = N dot f_"ref"$: cambiar el divisor programable cambia el canal), y el *DDS*, que genera la onda numéricamente con un acumulador de fase y un conversor D/A: precisión de cristal con resolución finísima.

#circuito(caption: [Un oscilador es un lazo: el amplificador (ganancia $A$) entrega su salida a una red selectiva (fracción $beta$) que la devuelve a la entrada. Oscila a la única frecuencia en la que la vuelta completa no pierde amplitud y llega en fase.])[
  #diagram(
    node-stroke: .7pt, node-corner-radius: 2pt, spacing: (14mm, 9mm),
    node((0, 0), [Amplificador\ ganancia $A$], shape: rect),
    edge("-|>"),
    node((1, 0), [salida], stroke: none),
    node((0, 1), [Red de realimentación $beta$\ (circuito LC o cristal)], shape: rect),
    edge((1, 0), (1, 1), (0, 1), "-|>"),
    edge((0, 1), (-1, 1), (-1, 0), (0, 0), "-|>"),
    node((-1, 0.5), text(size: 8pt)[$A beta >= 1$\ fase 360°], stroke: none),
  )
] <t3-fig-barkhausen>

#porque[
  - Al encender, el ruido del propio circuito contiene todas las frecuencias. La red LC solo devuelve con la fase correcta la de su resonancia; esa frecuencia vuelve a entrar sumándose a sí misma y crece en cada vuelta. Las demás llegan desfasadas y se anulan.
  - La amplitud no crece sin fin: al hacerse grande, el amplificador se acerca a sus límites, su ganancia baja y el lazo se estabiliza con $A beta = 1$ justo.
  - Es *realimentación positiva*: lo devuelto refuerza la entrada. La realimentación negativa, al revés, estabiliza el amplificador (T3.20, T3.25). Una realimentación positiva no buscada convierte un amplificador en un oscilador indeseado.
]

#circuito(caption: [Los tres osciladores clásicos, dibujados solo para la señal (sin polarización ni condensadores de paso). El transistor en emisor común invierte 180°; la red que va de colector a base, con su punto medio a masa, invierte otros 180°. Colpitts: divisor capacitivo. Hartley: bobina con toma. Pierce: el Colpitts con un cristal en lugar de la bobina.], sim: "colpitts.txt")[
  #esquema(escala: 0.8, {
    import zap: *
    import cetz.draw: translate
    let base-osc(etq, arriba, izq, der) = {
      npn("q", (2.6, 2.0))
      wire("q.e", (2.6, 0.4))
      wire((0.3, 0.4), (3.9, 0.4))
      ground("g", (2.0, 0.4))
      wire("q.b", (1.2, 2.0), (1.2, 3.6))
      wire("q.c", (2.6, 3.6))
      wire((0.3, 3.6), (1.2, 3.6))
      arriba
      wire((2.6, 3.6), (3.9, 3.6))
      izq
      der
      node("n1", (1.2, 3.6))
      node("n2", (2.6, 3.6))
      wire((3.9, 3.6), (4.6, 3.6))
      node("o", (4.6, 3.6), fill: false)
      _t3-et((4.6, 4.0), [salida], size: 7.5pt)
      _t3-et((2.1, -0.6), etq, size: 10pt)
    }
    base-osc([Colpitts],
      inductor("la", (1.2, 3.6), (2.6, 3.6), label: $L$),
      capacitor("ci", (0.3, 0.4), (0.3, 3.6), label: $C_2$),
      capacitor("cd", (3.9, 3.6), (3.9, 0.4), label: $C_1$))
    translate((6.4, 0))
    base-osc([Hartley],
      capacitor("ca", (1.2, 3.6), (2.6, 3.6), label: $C$),
      inductor("li", (0.3, 0.4), (0.3, 3.6), label: $L_2$),
      inductor("ld", (3.9, 3.6), (3.9, 0.4), label: $L_1$))
    translate((6.4, 0))
    base-osc([Pierce (a cristal)],
      cristal("xa", (1.2, 3.6), (2.6, 3.6), label: [cristal]),
      capacitor("ci3", (0.3, 0.4), (0.3, 3.6), label: $C_2$),
      capacitor("cd3", (3.9, 3.6), (3.9, 0.4), label: $C_1$))
  })
] <t3-fig-osciladores>

#porque[
  - *Colpitts.* La bobina $L$ resuena con $C_1$ y $C_2$ en serie. El punto medio de los dos condensadores está a masa, así que las tensiones en sus extremos (colector y base) son opuestas: la red invierte 180°, que se suman a los 180° del emisor común para dar los 360° de Barkhausen. El reparto $C_1 slash C_2$ decide cuánta señal vuelve a la base. #h(0.2em) $f_0 = 1 slash (2 pi sqrt(L C_1 C_2 slash (C_1 + C_2)))$.
  - *Hartley.* La misma idea con los papeles cambiados: el condensador $C$ resuena con una bobina con toma intermedia ($L_1$ y $L_2$ son las dos mitades) y la toma a masa hace de divisor. #h(0.2em) $f_0 approx 1 slash (2 pi sqrt((L_1 + L_2) C))$. #falstad("hartley.txt")
  - *Pierce.* Se sustituye la bobina del Colpitts por un cristal. El lazo solo cumple la condición de fase donde el cristal es inductivo, en una franja estrechísima entre $f_s$ y $f_p$: la frecuencia la fija el cuarzo, no los condensadores. #falstad("crystalosc.txt")
  - Si uno de los condensadores es un *varicap* (diodo cuya capacidad depende de la tensión inversa), la frecuencia se gobierna con una tensión: es un *VCO*. #falstad("varactorvco.txt")
]

#ejemplo[Un Colpitts con $L = 2$ μH y $C_1 = C_2 = 470$ pF: la capacidad en serie es 235 pF y $f_0 = 1 slash (2 pi sqrt(2 dot 10^(-6) dot 235 dot 10^(-12))) approx 7,3$ MHz. Con un condensador variable en paralelo con $L$ se tiene un VFO para la banda de 40 m: un oscilador de frecuencia variable, que es lo que permite moverse por la banda (T3.40).]

=== Síntesis de frecuencia: PLL y DDS

#ejemplo[Un PLL con referencia de 12,5 kHz y divisor programable $N = 11 600$ engancha su VCO en $N dot f_"ref" = 145,000$ MHz; sumar uno al divisor salta al canal siguiente, 145,0125 MHz. Y un DDS con reloj de 100 MHz y acumulador de fase de 32 bits resuelve $100 times 10^6 slash 2^32 approx 0,023$ Hz: la sintonía continua de los equipos modernos.]

#circuito(caption: [Arriba, el sintetizador PLL: el comparador mide la diferencia de fase entre la referencia y el VCO dividido por $N$ y corrige el VCO hasta que coinciden, de modo que $f_"out" = N f_"ref"$. Abajo, el DDS: un acumulador avanza la fase en cada ciclo de reloj, una tabla la convierte en muestras de la onda y el conversor D/A y un paso bajo dan la señal analógica.], sim: "pll.txt")[
  #diagram(
    node-stroke: .7pt, node-corner-radius: 2pt, spacing: (6mm, 8mm),
    node((0, 0), [Referencia\ de cristal], shape: rect),
    edge("-|>"),
    node((1, 0), [Comparador\ de fase], shape: rect),
    edge("-|>"),
    node((2, 0), [Filtro\ de lazo], shape: rect),
    edge("-|>"),
    node((3, 0), [VCO], shape: rect),
    edge("-|>"),
    node((4, 0), [$f_"out"$], stroke: none),
    node((2, 1), [Divisor $div N$\ (programable)], shape: rect),
    edge((3, 0), (3, 1), (2, 1), "-|>"),
    edge((2, 1), (1, 1), (1, 0), "-|>"),
    node((0, 2.2), [Reloj], shape: rect),
    edge("-|>"),
    node((1, 2.2), [Acumulador\ de fase], shape: rect),
    edge("-|>"),
    node((2, 2.2), [Tabla\ seno], shape: rect),
    edge("-|>"),
    node((3, 2.2), [D/A y\ paso bajo], shape: rect),
    edge("-|>"),
    node((4, 2.2), [salida], stroke: none),
  )
] <t3-fig-pll>

#porque[
  - *PLL.* Si el VCO se adelanta, su señal dividida llega antes que la referencia; el comparador da una tensión de error que, filtrada, baja la frecuencia del VCO, y al revés. El lazo se estabiliza solo cuando $f_"out" slash N = f_"ref"$, y entonces el VCO hereda la estabilidad del cristal. Cambiar $N$ es cambiar de canal en saltos de $f_"ref"$.
  - *DDS.* No hay ningún oscilador que corregir: la onda se calcula. Cuanto mayor es el número que se suma al acumulador en cada ciclo de reloj, antes da la vuelta la fase y mayor es la frecuencia. Con 32 bits, el paso mínimo es la frecuencia de reloj dividida por $2^32$ (T3.10).
]

Dos matices que el temario cita expresamente. Por encima de unos 20–30 MHz el cristal se hace vibrar en un *sobretono* (tercer o quinto armónico mecánico), porque el fundamental exigiría una lámina demasiado fina y frágil. Y todo oscilador real añade *ruido de fase*: pequeñas fluctuaciones aleatorias de su frecuencia que ensanchan la portadora en unos faldones de ruido y degradan tanto la pureza del transmisor como la selectividad del receptor.

=== El mezclador

El *mezclador* multiplica dos señales. Del producto de dos cosenos salen las frecuencias *suma y diferencia* ($f_1 plus.minus f_2$) — la misma identidad trigonométrica de la modulación AM. Es la pieza que traslada señales de una frecuencia a otra: en el receptor baja la señal a la FI y en el transmisor la sube a la frecuencia de trabajo.

La identidad, en una línea:
$ cos(2 pi f_1 t) dot cos(2 pi f_2 t) = 1/2 cos(2 pi (f_1 - f_2) t) + 1/2 cos(2 pi (f_1 + f_2) t). $
A la salida del multiplicador ya no están $f_1$ ni $f_2$ (en un mezclador ideal), sino dos frecuencias nuevas. Un mezclador real, hecho con diodos o transistores que no multiplican perfectamente, deja escapar también algo de $f_1$, de $f_2$ y de sus armónicos; un filtro a la salida se queda con el producto que interesa (@t3-fig-mezclador). La versión larga, con el receptor completo, está en #ver(<sec-mezclador>).

#circuito(caption: [Mezclador con 14 MHz y 4 MHz a la entrada. A la salida aparecen la diferencia (10 MHz) y la suma (18 MHz); un filtro elige una de las dos.], sim: "ringmod.txt")[
  #cetz.canvas({
    import cetz.draw: *
    // símbolo de mezclador
    circle((0, 1.2), radius: 0.45, stroke: 0.8pt)
    line((-0.32, 0.88), (0.32, 1.52), stroke: 0.8pt)
    line((-0.32, 1.52), (0.32, 0.88), stroke: 0.8pt)
    line((-2.4, 1.2), (-0.45, 1.2), mark: (end: ">", fill: black, scale: 0.6), stroke: 0.6pt)
    content((-2.4, 1.5), anchor: "west", text(size: 8pt)[$f_1 = 14$ MHz])
    line((0, -0.3), (0, 0.75), mark: (end: ">", fill: black, scale: 0.6), stroke: 0.6pt)
    content((-0.15, -0.1), anchor: "east", text(size: 8pt)[$f_2 = 4$ MHz\ (oscilador)])
    line((0.45, 1.2), (1.9, 1.2), mark: (end: ">", fill: black, scale: 0.6), stroke: 0.6pt)
    content((1.2, 1.5), text(size: 8pt)[$f_1 plus.minus f_2$])
    // espectro
    translate((2.8, 0))
    let sx = 0.48
    line((0, 0), (9.8, 0), mark: (end: ">", fill: black, scale: 0.5), stroke: 0.5pt)
    content((9.8, -0.1), anchor: "north-east", text(size: 7.5pt)[MHz])
    for (fr, h, c, etq) in ((4, 1.2, col.gris, [$f_2$]), (14, 1.2, col.gris, [$f_1$]), (10, 1.8, col.senal1, [$f_1 - f_2$]), (18, 1.8, col.senal2, [$f_1 + f_2$])) {
      line((fr * sx, 0), (fr * sx, h), stroke: 1.6pt + c)
      content((fr * sx, h + 0.25), text(size: 7.5pt, fill: c, etq))
      content((fr * sx, -0.1), anchor: "north", text(size: 7pt, str(fr)))
    }
    content((4.4, 2.5), text(size: 7pt, fill: col.gris)[en gris, las entradas: un mezclador ideal ya no las entrega])
  })
] <t3-fig-mezclador>

#porque[El mezclador es, en esencia, un multiplicador: un dispositivo no lineal (diodos en anillo, transistores) cuya salida depende del producto de sus dos entradas. Por la identidad de arriba, multiplicar dos frecuencias produce su suma y su diferencia. En el receptor, la emisora ($f_1$) se mezcla con el oscilador local ($f_2$) y el filtro de FI se queda con la diferencia; en el transmisor se hace lo contrario y se aprovecha la suma para subir la señal a la banda.]

#ejemplo[Con 14 MHz y 4 MHz, la salida contiene 10 MHz y 18 MHz (T3.13). En un receptor con FI de 9 MHz que escucha 14,2 MHz, el oscilador local está en 5,2 MHz: $14,2 - 5,2 = 9$ MHz pasa por el filtro de FI, y la suma, 19,4 MHz, se descarta.]

#q("T3.7", "d",
  [Con un filtro paso banda se consigue:],
  ([atenuar las frecuencias comprendidas dentro de la banda de paso], [dejar pasar únicamente las frecuencias inferiores a la de corte], [dejar pasar todas las frecuencias por igual], [atenuar las frecuencias superiores e inferiores a la banda de paso]),
  sol: [El paso banda deja pasar su banda y atenúa por encima y por debajo: es el filtro típico de la FI.],
)

#q("T3.8", "b",
  [Un resonador de cuarzo es un dispositivo que:],
  ([almacena carga eléctrica en un dieléctrico de cuarzo], [presenta un efecto de resonancia basado en la piezoelectricidad], [amplifica señales de radiofrecuencia], [rectifica la corriente alterna]),
  sol: [El cuarzo es piezoeléctrico y presenta una resonancia mecánica de altísimo $Q$: osciladores y filtros de gran estabilidad.],
)

#q("T3.9", "c",
  [Un mezclador combina dos frecuencias $f_1$ y $f_2$; a su salida se encuentra, entre otras, la frecuencia:],
  ([$f_1 - f_2$ únicamente], [$f_1 dot f_2$], [$f_1 + f_2$], [$f_1 slash f_2$]),
  sol: [El mezclador genera suma y diferencia ($f_1 plus.minus f_2$); el superheterodino aprovecha una de ellas como FI.],
)

#q("T3.10", "a",
  [Los sintetizadores digitales directos (DDS) se emplean como:],
  ([osciladores variables de gran precisión], [amplificadores de potencia], [filtros de rechazo de banda], [rectificadores controlados]),
  sol: [El DDS genera la forma de onda numéricamente: oscilador variable con precisión y estabilidad de cristal.],
)

== Clases de amplificación y detectores <t3-sec-clases>

De las clases de amplificación, lo que el examen exige tener fresco cabe en cuatro datos: la clase la fija el *ángulo de conducción* — cuánto ciclo conduce el dispositivo —, que es de 360° en clase A, está entre 180° y 360° en clase AB (por eso se dice que combina las clases A y B), vale 180° justos en clase B y es menor aún en clase C. Los amplificadores lineales, de clase A o AB, son los únicos aptos para SSB; la clase C, la de mayor rendimiento, queda reservada a emisiones de amplitud constante como CW o FM.

=== Qué decide la clase: el punto de reposo

#motivacion[El mismo transistor puede trabajar en clase A, B o C. Lo que cambia no es el componente, sino *dónde* lo dejamos en reposo, sin señal. Entender eso convierte las cuatro clases en una sola idea.]

Un transistor bipolar no conduce hasta que su tensión base-emisor supera unos 0,6 V; a partir de ahí, la corriente de colector crece con ella (@t3-fig-transferencia). La polarización fija el punto de reposo sobre esa curva, y la señal lo hace oscilar alrededor de él. La explicación larga de la polarización está en #ver(<sec-polarizacion>) y la de las clases, en #ver(<sec-clases>).

#circuito(caption: [Curva de transferencia del transistor y punto de reposo de cada clase. La señal mueve la tensión de base a uno y otro lado del punto de reposo; el dispositivo solo conduce mientras la tensión queda a la derecha del codo.])[
  #cetz.canvas({
    import cetz.draw: *
    let sx = 8.0
    let ic = v => 0.3 * calc.ln(1 + calc.exp((v - 0.62) / 0.03))
    ejes(0, 8.4, 0, 3.6, etq-x: $V_"BE"$, etq-y: $I_C$)
    onda(v => ic(v / sx), 0.2, 7.6, n: 200, stroke: 1.3pt + col.senal1)
    line((0.62 * sx, 0), (0.62 * sx, 3.3), stroke: (dash: "dashed", thickness: 0.5pt, paint: col.gris))
    content((0.62 * sx, 3.45), text(size: 7pt, fill: col.gris)[codo ≈ 0,6 V])
    let punto(v, etq, c) = {
      let x = v * sx
      let y = ic(v)
      circle((x, y), radius: 0.08, fill: c, stroke: none)
      content((x, y + 0.35), text(size: 8pt, weight: "bold", fill: c, etq))
      line((x, 0), (x, y), stroke: (dash: "dotted", thickness: 0.5pt, paint: c))
    }
    punto(0.40, [C], col.naranja)
    punto(0.62, [B], col.senal4)
    punto(0.70, [AB], col.senal3)
    punto(0.86, [A], col.senal1)
    // excursión de la señal en clase A
    line((0.86 * sx - 0.9, -0.35), (0.86 * sx + 0.9, -0.35), mark: (start: ">", end: ">", fill: black, scale: 0.5), stroke: 0.5pt + col.senal1)
    content((0.86 * sx, -0.65), text(size: 7pt, fill: col.senal1)[la señal en clase A])
    line((0.40 * sx - 2.2, -0.35), (0.40 * sx + 2.2, -0.35), mark: (start: ">", end: ">", fill: black, scale: 0.5), stroke: 0.5pt + col.naranja)
    content((0.40 * sx, -0.65), text(size: 7pt, fill: col.naranja)[la señal en clase C: solo la cresta pasa el codo])
    content((1.6, 0.9), text(size: 7pt, fill: col.gris)[corte: no conduce])
  })
] <t3-fig-transferencia>

#porque[
  - *Clase A.* El reposo está en mitad de la zona de conducción, con una corriente de colector considerable. La señal sube y baja sin llegar nunca al corte: el transistor conduce los 360° y la salida copia la entrada. Pero esa corriente de reposo circula siempre, haya o no señal, y se convierte en calor.
  - *Clase B.* El reposo está justo en el codo: corriente nula sin señal. Cada semiciclo positivo hace conducir al transistor; cada negativo lo deja cortado. Conduce 180°: un solo transistor daría media onda, así que se usan dos en contrafase.
  - *Clase AB.* Un poco por encima del codo: una pequeña corriente de reposo. Conduce algo más de 180° y elimina la distorsión de cruce de la clase B, gastando bastante menos que la A.
  - *Clase C.* Por debajo del corte (sin polarización, o con polarización inversa). Solo las crestas de la señal superan el codo: conduce en pulsos de menos de 180°. Es la que menos calienta, pero la salida ya no se parece a la entrada; un circuito tanque reconstruye la sinusoide.
]

#figure(
  {
  set par(justify: false)
  table(
    columns: (auto, auto, 1fr, 1fr, 1fr),
    align: (center, center, left, center, left),
    [*Clase*], [*Conduce*], [*Punto de reposo*], [*Rendimiento máximo*], [*Sirve para*],
    [A], [360°], [mitad de la zona lineal], [25 % (50 % con transformador)], [todo; etapas de bajo nivel, excitadores],
    [AB], [180°–360°], [algo por encima del corte], [intermedio, entre A y B], [finales lineales: SSB, AM, todos los modos],
    [B], [180°], [justo en el corte], [$pi slash 4 approx 78,5$ %], [en contrafase: audio, lineales],
    [C], [< 180°], [por debajo del corte], [el mayor (75–85 % en la práctica)], [solo amplitud constante: CW, FM],
  )
  },
  kind: table,
  caption: [Las cuatro clases de un vistazo. Cuanto menos conduce el dispositivo, más rinde y peor conserva la forma de la señal.],
) <t3-tab-clases>

#ptitulo[De dónde salen los rendimientos] En clase A, la fuente entrega siempre $P_"cc" = V_"CC" I_Q$; con la carga en el colector, la señal puede subir y bajar como mucho $V_"CC" slash 2$ y $I_Q$, y la potencia útil es $(V_"CC" slash 2)(I_Q) slash 2 = P_"cc" slash 4$: el 25 %. Con transformador, el colector puede oscilar entre 0 y $2 V_"CC"$, y la cuenta da el 50 %. En clase B, la corriente media de cada medio ciclo es $2 slash pi$ de su pico, y al hacer la cuenta con la excursión máxima sale $pi slash 4 approx 78,5$ %. En clase C, cuanto más estrecho es el pulso, más cerca está el transistor de conducir solo cuando su tensión colector-emisor es mínima, y menos disipa.

=== La clase B en contrafase

#circuito(caption: [Amplificador en contrafase (_push-pull_) con un NPN y un PNP. Cada transistor se encarga de un semiciclo. A la derecha, la distorsión de cruce: cerca de cero ninguno de los dos conduce y la salida (trazo continuo) se queda plana.], sim: "pushpullxover.txt")[
  #esquema({
    import zap: *
    import cetz.draw: line, content, translate
    npn("q1", (2.5, 3.0))
    pnp("q2", (2.5, 1.0))
    wire("q1.c", (2.5, 4.2))
    _t3-et((2.5, 4.5), $+V_"CC"$, size: 8pt)
    wire("q2.c", (2.5, -0.2))
    _t3-et((2.5, -0.5), $-V_"CC"$, size: 8pt)
    wire("q1.e", "q2.e")
    node("m", (2.5, 2.0))
    wire("q1.b", (1.3, 3.0), (1.3, 1.0), "q2.b")
    node("bi", (1.3, 2.0))
    wire((1.3, 2.0), (0.2, 2.0))
    node("in", (0.2, 2.0), fill: false)
    _t3-et((0.2, 2.35), [entrada], size: 7.5pt)
    wire((2.5, 2.0), (3.9, 2.0))
    resistor("rl", (3.9, 2.0), (3.9, 0.4), label: $R_L$)
    ground("g", (3.9, 0.4))
    _t3-et((3.4, 2.3), [salida], size: 7.5pt)
    // distorsión de cruce
    translate((6.0, 2.0))
    line((0, 0), (5.2, 0), mark: (end: ">", fill: black, scale: 0.5), stroke: 0.5pt)
    line((0, -1.5), (0, 1.6), mark: (end: ">", fill: black, scale: 0.5), stroke: 0.5pt)
    content((5.2, -0.1), anchor: "north-east", text(size: 7.5pt, $t$))
    let w = 2 * calc.pi / 2.5
    let vin = t => 1.2 * calc.sin(t * w * 1rad)
    let vout = t => { let v = vin(t); if v > 0.3 { v - 0.3 } else if v < -0.3 { v + 0.3 } else { 0 } }
    let pts1 = range(201).map(i => { let t = 5 * i / 200; (t, vin(t)) })
    line(..pts1, stroke: (paint: col.gris, dash: "dashed", thickness: 0.7pt))
    let pts2 = range(201).map(i => { let t = 5 * i / 200; (t, vout(t)) })
    line(..pts2, stroke: 1.2pt + col.senal2)
    content((0.6, 1.45), anchor: "west", text(size: 7pt, fill: col.gris)[entrada])
    content((2.1, -1.35), text(size: 7pt, fill: col.senal2)[salida: escalón en cada cruce por cero])
  })
] <t3-fig-pushpull>

#porque[
  - En el semiciclo positivo, la base sube: el NPN conduce y empuja corriente desde $+V_"CC"$ hacia la carga; el PNP está cortado. En el negativo, la base baja: conduce el PNP, que tira corriente de la carga hacia $-V_"CC"$, y el NPN se corta. Entre los dos reconstruyen la onda entera; cada uno trabaja en clase B.
  - Ninguno conduce hasta que la entrada supera unos 0,6 V en su sentido: alrededor del cero la salida se queda quieta. Es la *distorsión de cruce*. Se corrige polarizando las dos bases con un poco de corriente de reposo (dos diodos entre las bases): eso ya es clase AB #falstad("pushpull.txt").
  - En RF la contrafase se hace también con dos transistores iguales y transformadores con toma central. Otra forma de subir potencia es poner dos dispositivos *en paralelo*: se reparten la corriente y entregan más potencia que uno solo (T3.48).
]

=== La clase C y el efecto volante

// FALSTAD-CUSTOM: clase-c
#circuito(caption: [Amplificador de clase C. Sin polarización, el transistor solo conduce en las crestas positivas de la excitación y entrega pulsos de corriente; el tanque $L C$ del colector los convierte otra vez en una sinusoide completa.])[
  #esquema({
    import zap: *
    import cetz.draw: line, content, translate, rect
    wire((3.5, 6), (5.2, 6))
    _t3-et((4.35, 6.35), $+V_"CC"$, size: 8pt)
    npn("q1", (3.5, 3))
    wire("q1.e", (3.5, 0.6))
    ground("g", (3.5, 0.6))
    capacitor("cin", (0, 3), (2.0, 3), label: $C_"ent"$, n: "o-*")
    wire((2.0, 3), "q1.b")
    inductor("lb", (2.0, 0.6), (2.0, 3), label: [choque])
    ground("g2", (2.0, 0.6))
    wire("q1.c", (3.5, 4.0))
    wire((3.5, 4.0), (5.2, 4.0))
    inductor("lt", (3.5, 6), (3.5, 4.0), label: $L$)
    capacitor("ct", (5.2, 6), (5.2, 4.0), label: $C$)
    node("nt", (3.5, 4.0))
    node("nt2", (5.2, 4.0))
    capacitor("cout", (5.2, 4.0), (6.8, 4.0), label: (content: $C_"sal"$, anchor: "south"), n: "-o")
    _t3-et((0, 3.45), [excitación], size: 7.5pt)
    _t3-et((6.8, 4.45), [RF], size: 7.5pt)
    // formas de onda
    translate((8.2, 1.2))
    let w = 2 * calc.pi / 1.6
    line((0, 0), (5.2, 0), stroke: 0.4pt + col.gris)
    let ipulse = t => { let c = calc.cos((t - 0.4) * w * 1rad); if c > 0.7 { (c - 0.7) * 4 } else { 0 } }
    let pts1 = range(301).map(i => { let t = 5 * i / 300; (t, ipulse(t)) })
    line(..pts1, stroke: 1.2pt + col.naranja)
    content((5.2, 0.6), anchor: "west", text(size: 7pt, fill: col.naranja)[$i_C$])
    line((0, 2.6), (5.2, 2.6), stroke: 0.4pt + col.gris)
    let pts2 = range(301).map(i => { let t = 5 * i / 300; (t, 2.6 + 0.8 * calc.cos((t - 0.4) * w * 1rad)) })
    line(..pts2, stroke: 1.2pt + col.senal1)
    content((5.2, 2.6), anchor: "west", text(size: 7pt, fill: col.senal1)[$v$ tanque])
    content((2.6, 3.75), text(size: 7.5pt)[tensión en el tanque: sinusoide completa])
    content((2.6, -0.45), text(size: 7.5pt)[corriente de colector: pulsos en las crestas])
  })
] <t3-fig-clase-c>

#porque[
  - La bobina de choque de la base fija la continua de base a 0 V: sin señal, el transistor está cortado. Solo cuando la excitación supera unos 0,6 V conduce, y eso ocurre solo cerca de cada cresta positiva: pulsos de corriente de menos de 180°.
  - El tanque $L C$ funciona como un volante de inercia (o un columpio al que se empuja una vez por ciclo): cada pulso le repone la energía que ha entregado a la antena, y entre pulsos la energía sigue yendo y viniendo entre $L$ y $C$. La tensión en el tanque es una sinusoide completa a $f_0$. Es el *efecto volante*.
  - Los pulsos son muy ricos en armónicos; el tanque, y después el filtro paso bajo de salida, los atenúan. Si se sintoniza el tanque al doble o al triple de la frecuencia de entrada, el mismo circuito es un *multiplicador de frecuencia*.
  - La amplitud de salida no sigue fielmente a la de entrada: por eso la clase C destroza la AM y la SSB, y en cambio no estropea nada en CW o en FM, donde la amplitud es constante.
]

#nota[Los antiguos transmisores de AM sí usaban un paso final de clase C, pero no para *amplificar* una AM ya hecha: modulaban esa misma etapa variando su tensión de alimentación al ritmo del audio (modulación de placa). Una señal de AM o de SSB ya modulada solo puede amplificarse con un lineal (A, AB o B en contrafase).]

#ojo[Clase A: mínima distorsión (T3.6, T3.21). Clase B: 180° (T3.22). Clase AB: combinación de A y B, la de los lineales de SSB (T3.11). Clase C: la de mayor rendimiento (T3.23), solo para amplitud constante (T3.24). Un amplificador sobreexcitado o no lineal genera armónicos (múltiplos enteros de la frecuencia) e intermodulación.]

=== Detectores

#motivacion[La FI del receptor entrega la señal de la emisora, pero todavía «subida» a una portadora de radiofrecuencia que ningún altavoz puede reproducir. El detector (o demodulador) extrae de ella la información: la voz, el tono de CW o los datos.]

El *detector* recorre el camino inverso al modulador. El de *envolvente* — un diodo que rectifica y un RC que sigue los picos — recupera la moduladora de una señal de AM sin necesitar referencia alguna del transmisor: es _asíncrono_, y por eso tan simple. Para SSB y CW no basta, porque falta la portadora: el *detector de producto* la reinserta mezclando la señal con el oscilador de batido (BFO), como se verá en el tema T4.

#circuito(caption: [Detector de envolvente y sus señales. Arriba, la AM que llega de la FI; en medio, lo que deja pasar el diodo; abajo, la tensión del condensador, que sigue la envolvente: es el audio.], sim: "amdetect.txt")[
  #esquema({
    import zap: *
    import cetz.draw: line, content, translate
    wire((0, 2), (0.5, 2))
    diode("d", (0.5, 2), (2.0, 2), label: $D$)
    wire((2.0, 2), (4.0, 2))
    resistor("r", (2.6, 2), (2.6, 0), label: $R$)
    capacitor("c", (3.6, 2), (3.6, 0), label: $C$)
    wire((0, 0), (4.0, 0))
    node("a", (0, 2), fill: false)
    node("b", (0, 0), fill: false)
    node("c1", (4.0, 2), fill: false)
    node("c2", (4.0, 0), fill: false)
    node("n1", (2.6, 2))
    node("n2", (3.6, 2))
    node("n3", (2.6, 0))
    node("n4", (3.6, 0))
    _t3-et((0, 2.4), [FI (AM)], size: 7.5pt)
    _t3-et((4.0, 2.4), [audio], size: 7.5pt)
    // formas de onda
    translate((6.0, -0.6))
    let tf = 6.0
    let am = t => (1 + 0.6 * calc.sin(t * 2 * calc.pi / tf * 1rad)) * calc.sin(t * 2 * calc.pi / 0.3 * 1rad)
    let fila(y0, f, c, etq) = {
      line((0, y0), (tf, y0), stroke: 0.3pt + col.gris)
      let pts = range(601).map(i => { let t = tf * i / 600; (t, y0 + 0.45 * f(t)) })
      line(..pts, stroke: 0.8pt + c)
      content((tf + 0.15, y0), anchor: "west", text(size: 7pt, fill: c, etq))
    }
    fila(3.6, am, col.senal1, [entrada])
    fila(2.0, t => calc.max(0, am(t)), col.senal4, [tras el diodo])
    // detector: carga y descarga
    let n = 600
    let dt = tf / n
    let pts = ()
    let v = 0.0
    for i in range(n + 1) {
      let t = i * dt
      v = calc.max(calc.max(0, am(t)), v * calc.exp(-dt / 0.35))
      pts.push((t, 0.4 + 0.45 * v))
    }
    line((0, 0.4), (tf, 0.4), stroke: 0.3pt + col.gris)
    line(..pts, stroke: 1.1pt + col.senal2)
    content((tf + 0.15, 0.4), anchor: "west", text(size: 7pt, fill: col.senal2)[salida])
  })
] <t3-fig-envolvente>

#porque[
  - El *diodo* deja pasar solo los semiciclos positivos de la portadora: la señal deja de tener valor medio nulo y su valor medio sigue a la envolvente.
  - El *condensador* se carga en cada pico de RF y, entre picos, se descarga un poco a través de $R$. Su tensión «cabalga» sobre los picos y reproduce la envolvente, que es el audio.
  - La constante $R C$ es un compromiso: tiene que ser larga frente al periodo de la portadora (para alisar la RF) y corta frente al periodo del audio más agudo (para que la tensión pueda bajar cuando baja la envolvente). Si es demasiado larga, los agudos se pierden; si es demasiado corta, queda RF en la salida.
  - No necesita ninguna señal del transmisor: es *asíncrono*. Por eso es el detector de AM por excelencia, y la radio de galena es solo esto con un circuito sintonizado delante (T3.15).
]

#ejemplo[Con una FI de 455 kHz (periodo de unos 2,2 μs) y audio hasta 3 kHz (periodo de unos 330 μs), $R C$ debe estar entre esos dos valores, más cerca del pequeño: $R = 10$ kΩ y $C = 4,7$ nF dan $R C = 47$ μs, unas veinte veces el periodo de la FI y siete veces menos que el del audio más agudo.]

#circuito(caption: [Detector de producto: la señal de BLU o de CW se mezcla con el oscilador de batido (BFO), que hace de portadora; un paso bajo se queda con la diferencia, que ya es audio.])[
  #diagram(
    node-stroke: .7pt, node-corner-radius: 2pt, spacing: (10mm, 8mm),
    node((0, 0), [FI\ (BLU o CW)], stroke: none),
    edge("-|>"),
    node((1, 0), [Mezclador\ (detector de producto)], shape: rect),
    edge("-|>"),
    node((2, 0), [Paso bajo], shape: rect),
    edge("-|>"),
    node((3, 0), [audio], stroke: none),
    node((1, 1), [BFO], shape: rect),
    edge((1, 1), (1, 0), "-|>"),
  )
] <t3-fig-producto>

#porque[En BLU no se transmite la portadora: solo una banda lateral, que es el audio desplazado en frecuencia. El detector de producto es un mezclador: multiplica la señal por la del BFO y, de la suma y la diferencia, el paso bajo conserva la diferencia, que devuelve cada componente a su frecuencia de audio original. Si el BFO no está en el sitio exacto, la voz sale desplazada y suena «de pato».]

#ejemplo[Una FI de BLU superior centrada en 9,000 MHz: un tono de 1 kHz del micrófono llega como 9,001 MHz. Con el BFO en 9,000 MHz, la diferencia es $9,001 - 9,000$ MHz $= 1$ kHz: el tono original. En CW, el BFO se separa unos 700 Hz de la portadora y se oye un pitido de 700 Hz.]

Para *FM* el detector debe convertir las variaciones de frecuencia en variaciones de amplitud. El *detector de pendiente* usa el flanco de un circuito sintonizado, fuera de resonancia, donde a más frecuencia corresponde más amplitud: sencillo pero poco lineal. El *discriminador* (Foster-Seeley) y el *detector de relación* lo hacen con dos circuitos sintonizados simétricos, mucho más lineales, y un *PLL* demodula la FM leyendo la propia tensión de control que su VCO necesita para seguir a la portadora. Todos van precedidos de un *limitador* que borra el ruido de amplitud (tema T4).

#circuito(caption: [Detector de pendiente. La portadora de FM se sitúa en el flanco de un circuito resonante: cuando la frecuencia sube, la amplitud de salida sube; cuando baja, baja. La desviación de frecuencia se convierte en variación de amplitud, que un detector de envolvente lee después.])[
  #cetz.canvas({
    import cetz.draw: *
    let x0 = 5.0
    let y = x => 3.2 * _t3-res(x / x0, 4)
    ejes(0, 9, 0, 3.8, etq-x: $f$, etq-y: [amplitud])
    onda(y, 0.6, 8.8, n: 200, stroke: 1.2pt + col.senal1)
    let fc = 4.15
    let d = 0.35
    rect((fc - d, 0), (fc + d, y(fc + d)), fill: col.naranja-claro, stroke: none)
    onda(y, fc - d, fc + d, n: 30, stroke: 1.6pt + col.naranja)
    line((fc, 0), (fc, y(fc)), stroke: (dash: "dotted", thickness: 0.6pt))
    content((fc, -0.1), anchor: "north", text(size: 7.5pt, $f_c$))
    content((x0, -0.1), anchor: "north", text(size: 7.5pt, $f_0$))
    line((x0, 0), (x0, 3.2), stroke: (dash: "dotted", thickness: 0.4pt, paint: col.gris))
    line((fc - d, y(fc - d)), (0, y(fc - d)), stroke: (dash: "dotted", thickness: 0.5pt, paint: col.naranja))
    line((fc + d, y(fc + d)), (0, y(fc + d)), stroke: (dash: "dotted", thickness: 0.5pt, paint: col.naranja))
    line((0.35, y(fc - d)), (0.35, y(fc + d)), mark: (start: ">", end: ">", fill: col.naranja, scale: 0.45), stroke: 0.6pt + col.naranja)
    content((0.5, (y(fc - d) + y(fc + d)) / 2), anchor: "west", text(size: 7pt, fill: col.naranja)[variación de amplitud])
    line((fc - d, -0.55), (fc + d, -0.55), mark: (start: ">", end: ">", fill: col.naranja, scale: 0.45), stroke: 0.6pt + col.naranja)
    content((fc + d + 0.15, -0.55), anchor: "west", text(size: 7pt, fill: col.naranja)[desviación de FM])
  })
] <t3-fig-pendiente>

#porque[El flanco de la curva de resonancia es casi una recta en un tramo corto: dentro de él, cada kilohercio de desviación produce el mismo aumento de amplitud. Fuera de ese tramo la curva se dobla y la salida se distorsiona; por eso el detector de pendiente es «sencillo pero poco lineal». El discriminador usa dos circuitos sintonizados, uno a cada lado de la portadora, y resta sus salidas: los dos flancos se compensan y la respuesta es recta en un margen mucho mayor. El limitador previo recorta la amplitud a un valor fijo, para que el detector solo vea variaciones de frecuencia y no de ruido.]

#figure(
  {
  set par(justify: false)
  table(
    columns: (auto, 1fr, 1fr),
    align: (left, left, left),
    [*Modulación*], [*Detector*], [*Qué necesita*],
    [AM], [de envolvente (diodo + $R C$)], [nada del transmisor: es asíncrono],
    [BLU (SSB) y CW], [de producto (mezclador + BFO)], [un oscilador local que reponga la portadora],
    [FM], [de pendiente, discriminador Foster-Seeley, detector de relación, PLL], [un limitador delante que quite el ruido de amplitud],
  )
  },
  kind: table,
  caption: [Qué detector corresponde a cada modulación.],
) <t3-tab-detectores>

#ojo[El detector de envolvente sirve para AM (T3.38) y no necesita sincronización con el transmisor (T3.12). En SSB y CW no sirve, porque no hay portadora: hace falta el detector de producto con su BFO. La versión larga de los detectores está en #ver(<sec-detector>).]

#q("T3.11", "c",
  [De las clases de amplificadores A, B, AB y C, la clase AB:],
  ([es la de mayor rendimiento], [solo se usa en corriente continua], [es una combinación de las clases A y B], [recorta el ciclo completo de la señal]),
  sol: [La clase AB polariza el amplificador entre la A y la B: compromiso entre la linealidad de una y el rendimiento de la otra. Es la habitual en los finales de SSB.],
)

#q("T3.12", "b",
  [Los detectores de envolvente (por ejemplo, un diodo seguido de un filtro) tienen la particularidad de:],
  ([requerir sincronización exacta con el transmisor], [no requerir en el receptor sincronización con el transmisor, por ser asíncronos], [funcionar únicamente con señales de FM], [necesitar alimentación de alta tensión]),
  sol: [El detector de envolvente (un diodo y un filtro $R C$) sigue la envolvente de la señal sin necesitar ninguna referencia del transmisor: es asíncrono. Los detectores síncronos requieren reconstruir la portadora.],
)

#q("T3.13", "d",
  [Si a la entrada de un mezclador se aplican dos señales de 14 MHz y 4 MHz, a su salida encontraremos, entre otras, la frecuencia de:],
  ([3,5 MHz], [56 MHz], [7 MHz], [10 MHz]),
  sol: [El mezclador entrega $f_1 + f_2 = 18$ MHz y $f_1 - f_2 = 10$ MHz, entre otras. De las opciones, la única presente es 10 MHz.],
)

== Preguntas sobre esquemas <t3-sec-esquemas>

El examen enseña a veces un esquema y pregunta qué es o qué hace. El truco es buscar las piezas que delatan cada bloque: un transformador seguido de diodos y un condensador grande es una fuente; un circuito LC con un diodo y un auricular, un receptor; un diodo seguido de un $R C$, un detector; un LC a masa, una trampa. En cada caso, piensa qué hace cada componente con la señal, como en los recuadros «Por qué funciona» de este tema.

#q("T3.14", "c",
  [El esquema eléctrico de la figura corresponde a:

    #circuito(caption: [Esquema de la pregunta T3.14.], sim: "fullrectf.txt")[
      #esquema({
        import zap: *
        acvsource("red", (0, -0.8), (0, 0.8))
        _t3-et((-0.75, 0), [red], anchor: "east", size: 8pt)
        trafo("t", (2, 0))
        wire((0, 0.8), "t.p1")
        wire((0, -0.8), "t.p2")
        let (cx, d) = (5.0, 1.0)
        wire("t.s1", (cx - d, 0.8), (cx - d, 0))
        wire("t.s2", (3.4, -0.8), (3.4, -1.5), (cx + d + 0.4, -1.5), (cx + d + 0.4, 0), (cx + d, 0))
        diode("p1", (cx - d, 0), (cx, d))
        diode("p2", (cx + d, 0), (cx, d))
        diode("p3", (cx, -d), (cx - d, 0))
        diode("p4", (cx, -d), (cx + d, 0))
        wire((cx, d), (cx, 1.8), (8.4, 1.8))
        wire((cx, -d), (cx, -2.1), (8.4, -2.1))
        capacitor("cf", (7.4, 1.8), (7.4, -2.1))
        node("na", (7.4, 1.8))
        node("nb", (7.4, -2.1))
        node("o1", (8.4, 1.8), fill: false)
        node("o2", (8.4, -2.1), fill: false)
        _t3-et((8.65, 1.8), $+$, size: 9pt)
        _t3-et((8.65, -2.1), $-$, size: 9pt)
      })
    ] <t3-fig-q14>],
  ([un amplificador de potencia], [un oscilador a cristal], [una fuente de alimentación], [un filtro de audio]),
  sol: [Transformador que baja la tensión de red, puente de cuatro diodos que rectifica y condensador que filtra: los bloques canónicos de una fuente de alimentación, tal como se desarrollaron en la teoría.],
)

#porque[En la @t3-fig-q14 el transformador reduce la tensión de la red; el puente de cuatro diodos hace que la corriente salga siempre por el borne $+$, sea cual sea el semiciclo; y el condensador se carga en los picos y alisa el rizado. Es una fuente sin regulador: le faltaría solo el cuarto bloque.]

#q("T3.15", "a",
  [El circuito de la figura podrá emplearse como:
    #circuito(caption: [Esquema de la pregunta T3.15.], sim: "amdetect.txt")[
      #esquema({
        import zap: *
        wire((0, 2.0), (2.0, 2.0))
        antenna("ant", (1.0, 2.0))
        inductor("l", (0, 2.0), (0, 0.4))
        capacitor("cv", (2.0, 2.0), (2.0, 0.4), variable: true)
        wire((0, 0.4), (2.0, 0.4))
        ground("g1", (1.0, 0.4))
        diode("d", (2.0, 2.0), (3.8, 2.0))
        wire((3.8, 2.0), (6.3, 2.0), (6.3, 1.5))
        capacitor("c", (5.0, 2.0), (5.0, 0.4))
        altavoz("aur", (6.45, 1.2))
        wire((6.3, 0.9), (6.3, 0.4), (5.0, 0.4))
        ground("g2", (5.6, 0.4))
        node("n1", (1.0, 2.0))
        node("n2", (5.0, 2.0))
      })
    ] <t3-fig-q15>],
  ([receptor de AM a la frecuencia de resonancia del circuito LC], [transmisor de FM de baja potencia], [fuente de alimentación estabilizada], [frecuencímetro analógico]),
  sol: [Es la radio de galena: el circuito LC paralelo selecciona la emisora por resonancia, el diodo detecta la envolvente y el auricular la reproduce. Un receptor de AM completo sin alimentación externa.],
)

#porque[En la @t3-fig-q15 la antena entrega a la vez todas las emisoras; el tanque LC paralelo solo presenta impedancia alta, y por tanto tensión, a la de su frecuencia de resonancia, que se elige con el condensador variable. El diodo y el condensador forman el detector de envolvente, y el auricular convierte el audio en sonido. Toda la energía la pone la emisora: por eso no lleva pila.]

#q("T3.16", "d",
  [Si en el esquema de la figura el conjunto L-C en serie resuena a la frecuencia del transmisor, la potencia que medirá el vatímetro será:
    #circuito(caption: [Esquema de la pregunta T3.16.], sim: "notch.txt")[
      #esquema({
        import zap: *
        import cetz.draw: rect, content
        rect((0, 2.0), (1.6, 2.8), radius: 0.1, stroke: 0.7pt + col.acento, fill: col.acento-claro)
        content((0.8, 2.4), text(size: 8pt)[TX])
        wire((1.6, 2.4), (6.2, 2.4))
        node("n", (3.9, 2.4))
        rect((6.2, 2.0), (8.0, 2.8), radius: 0.1, stroke: 0.7pt + col.acento, fill: col.acento-claro)
        content((7.1, 2.4), text(size: 8pt)[vatímetro])
        wire((8.0, 2.4), (9.2, 2.4))
        antenna("ant", (9.2, 2.4))
        inductor("l", (3.9, 2.4), (3.9, 1.0))
        capacitor("c", (3.9, 1.0), (3.9, 0.2))
        ground("g", (3.9, 0.2))
      })
    ] <t3-fig-q16>],
  ([máxima], [la misma que sin el circuito L-C], [el doble], [mínima]),
  sol: [Un LC serie en resonancia presenta impedancia mínima (solo la resistencia de pérdidas): conectado en derivación se comporta como un cortocircuito a esa frecuencia y deriva la señal a masa — es una trampa. Al vatímetro llega la potencia mínima.],
)

#porque[En la @t3-fig-q16 la bobina y el condensador en serie, conectados entre la línea y masa, se anulan en resonancia: la rama queda reducida a la pequeña resistencia de pérdidas y se lleva a masa casi toda la potencia del transmisor a esa frecuencia. A otras frecuencias la rama presenta mucha reactancia y apenas influye. Es un filtro de rechazo de banda, como el de la @t3-fig-lc.]

#ojo[En la @t3-fig-q16 la trampa está *en derivación*, entre la línea y masa. Si el mismo LC serie estuviera *en serie* con la línea, en resonancia dejaría pasar toda la potencia. Fíjate siempre en cómo está conectado el circuito resonante, no solo en si es serie o paralelo: es lo que distingue un paso banda de un rechazo de banda.]

== El amplificador operacional <t3-sec-operacional>

Hay un bloque que aparece una y otra vez en la electrónica de la estación — en los filtros de audio, en el control automático de ganancia, en los medidores — y conviene tenerlo claro: el *amplificador operacional*.

De fábrica es un amplificador casi absurdo: amplifica la _diferencia_ entre sus dos entradas con una ganancia enorme, de cien mil o un millón, tiene una impedancia de entrada altísima (apenas toma corriente de lo que mide) y una impedancia de salida muy baja (entrega corriente sin hundirse). Tal cual, es inservible: con esa ganancia, unos microvoltios de diferencia lo llevan al tope. Sus dos entradas se llaman *inversora* (−) y *no inversora* (+), según si la salida se mueve en contra o a favor de ellas.

La gracia está en domarlo con *realimentación negativa*: devolver parte de la salida a la entrada inversora. El circuito se vuelve entonces un servomecanismo que hace lo que sea necesario para que sus dos entradas se igualen, y la ganancia deja de depender del operacional — que ya no sabemos ni cuánto amplifica — para depender solo de dos resistencias (@t3-fig-opamp). Ese es el gran negocio de la realimentación negativa en cualquier amplificador: se cambia ganancia sobrante, que es barata, por estabilidad, linealidad y ancho de banda, que son caros.

#circuito(caption: [Los dos montajes básicos del operacional. En ambos la ganancia la fijan $R_1$ y $R_2$, no el propio amplificador; el inversor además cambia el signo de la señal.], sim: "amp-invert.txt")[
  #esquema({
    import zap: *
    import cetz.draw: translate
    // inversor
    opamp("a1", (3.6, 0))
    resistor("r1", (0.2, 0.45), (2.0, 0.45), label: (content: $R_1$, anchor: "south"), n: "o-")
    wire((2.0, 0.45), "a1.minus")
    node("n1", (2.4, 0.45))
    wire((2.4, 0.45), (2.4, 1.6))
    resistor("r2", (2.4, 1.6), (4.9, 1.6), label: $R_2$)
    wire((4.9, 1.6), (4.9, 0))
    wire("a1.out", (5.6, 0))
    node("o1", (5.6, 0), fill: false)
    node("n1b", (4.9, 0))
    wire("a1.plus", (2.2, -0.45), (2.2, -0.9))
    ground("g1", (2.2, -0.9))
    _t3-et((0.1, 0.45), $v_"ent"$, anchor: "east", size: 8pt)
    _t3-et((5.7, 0), $v_"sal"$, anchor: "west", size: 8pt)
    _t3-et((2.9, -2.4), [*inversor:* $G = -R_2 slash R_1$], size: 9pt)
    // no inversor
    translate((7.6, 0))
    opamp("a2", (3.6, 0))
    wire("a2.minus", (1.0, 0.45))
    node("n2", (1.0, 0.45))
    resistor("r1b", (1.0, -1.3), (1.0, 0.45), label: $R_1$)
    ground("g2", (1.0, -1.3))
    wire((1.0, 0.45), (1.0, 1.6))
    resistor("r2b", (1.0, 1.6), (4.9, 1.6), label: $R_2$)
    wire((4.9, 1.6), (4.9, 0))
    wire("a2.out", (5.6, 0))
    node("o2", (5.6, 0), fill: false)
    node("n2b", (4.9, 0))
    wire((2.1, -0.45), "a2.plus")
    node("i2", (2.1, -0.45), fill: false)
    _t3-et((2.0, -0.45), $v_"ent"$, anchor: "east", size: 8pt)
    _t3-et((5.7, 0), $v_"sal"$, anchor: "west", size: 8pt)
    _t3-et((2.9, -2.4), [*no inversor:* $G = 1 + R_2 slash R_1$], size: 9pt)
  })
] <t3-fig-opamp>

#porque[
  - *Inversor.* Como la entrada $+$ está a masa y el operacional iguala sus entradas, la entrada $-$ queda también a 0 V aunque no esté conectada a masa: es una *masa virtual*. Por $R_1$ circula entonces $i = v_"ent" slash R_1$. Esa corriente no puede entrar en el operacional, así que sigue por $R_2$, y la salida queda en $v_"sal" = 0 - i R_2 = -(R_2 slash R_1) v_"ent"$. #falstad("amp-invert.txt")
  - *No inversor.* Ahora la señal va a la entrada $+$ y el operacional lleva la entrada $-$ a la misma tensión, $v_"ent"$. Pero la entrada $-$ recibe la salida a través del divisor $R_2$–$R_1$: $v_"ent" = v_"sal" R_1 slash (R_1 + R_2)$. Despejando, $v_"sal" = (1 + R_2 slash R_1) v_"ent"$: la ganancia es siempre mayor que 1 y sin cambio de signo. #falstad("amp-noninvert.txt")
  - Sin $R_2$ (sin realimentación), cualquier diferencia de microvoltios llevaría la salida a la tensión de alimentación: el operacional se *satura*. La realimentación es lo que lo hace útil.
]

=== Dos reglas para resolver cualquier montaje

#idea[Con realimentación negativa, un operacional ideal cumple dos reglas:
  + *No entra corriente* por sus entradas (impedancia de entrada infinita).
  + *Sus dos entradas están a la misma tensión*, $V_+ = V_-$. No porque estén unidas, sino porque la salida se mueve lo necesario para conseguirlo: con una ganancia de $10^5$, dar 10 V a la salida exige una diferencia de solo 0,1 mV entre las entradas.
Con estas dos reglas y la ley de Ohm se calcula la ganancia de cualquier montaje en dos líneas.]

#ejemplo[Un preamplificador de micrófono con $R_1 = 10$ kΩ y $R_2 = 100$ kΩ. En inversor, $G = -100 slash 10 = -10$: 10 mV de entrada dan $-100$ mV. En no inversor, $G = 1 + 100 slash 10 = 11$: los mismos 10 mV dan 110 mV, en fase. El no inversor tiene además una impedancia de entrada altísima (la de la propia entrada $+$), y el inversor, solo $R_1$.]

#circuito(caption: [Seguidor de tensión (izquierda) y sumador inversor (derecha). El seguidor copia la entrada con ganancia 1 pero con la impedancia de salida bajísima del operacional; el sumador entrega la suma de las entradas, cambiada de signo.], sim: "amp-follower.txt")[
  #esquema({
    import zap: *
    import cetz.draw: translate
    // seguidor
    opamp("a1", (1.8, 0))
    wire("a1.out", (3.1, 0))
    wire((3.1, 0), (3.1, 1.2), (0.6, 1.2), (0.6, 0.45), "a1.minus")
    node("o", (3.1, 0))
    wire((3.1, 0), (3.6, 0))
    node("o1", (3.6, 0), fill: false)
    wire((0.2, -0.45), "a1.plus")
    node("i1", (0.2, -0.45), fill: false)
    _t3-et((0.1, -0.45), $v_"ent"$, anchor: "east", size: 8pt)
    _t3-et((3.7, 0), $v_"sal"$, anchor: "west", size: 8pt)
    _t3-et((1.8, -2.0), [*seguidor:* $G = 1$], size: 9pt)
    // sumador
    translate((6.4, 0))
    opamp("a2", (3.6, 0))
    resistor("ra", (0.4, 0.45), (1.8, 0.45), label: (content: $R_1$, anchor: "south"), n: "o-")
    resistor("rb", (0.4, 1.55), (1.8, 1.55), label: $R_2$, n: "o-")
    resistor("rc", (0.4, 2.65), (1.8, 2.65), label: $R_3$, n: "o-")
    wire((1.8, 0.45), "a2.minus")
    wire((1.8, 1.55), (2.3, 1.55))
    wire((1.8, 2.65), (2.3, 2.65))
    wire((2.3, 2.65), (2.3, 0.45))
    node("s1", (2.3, 0.45))
    node("s2", (2.3, 1.55))
    node("s3", (2.3, 2.65))
    wire((2.3, 2.65), (2.3, 3.4))
    resistor("rf", (2.3, 3.4), (4.9, 3.4), label: $R_f$)
    wire((4.9, 3.4), (4.9, 0))
    wire("a2.out", (5.6, 0))
    node("o2", (5.6, 0), fill: false)
    node("o2b", (4.9, 0))
    wire("a2.plus", (2.4, -0.45), (2.4, -0.9))
    ground("g2", (2.4, -0.9))
    _t3-et((0.3, 0.45), $v_1$, anchor: "east", size: 8pt)
    _t3-et((0.3, 1.55), $v_2$, anchor: "east", size: 8pt)
    _t3-et((0.3, 2.65), $v_3$, anchor: "east", size: 8pt)
    _t3-et((5.7, 0), $v_"sal"$, anchor: "west", size: 8pt)
    _t3-et((2.9, -2.0), [*sumador:* $v_"sal" = -R_f (v_1 / R_1 + v_2 / R_2 + v_3 / R_3)$], size: 9pt)
  })
] <t3-fig-seguidor-sumador>

#porque[
  - *Seguidor.* Es el no inversor con $R_2 = 0$ y sin $R_1$: la salida va entera a la entrada $-$, y como $V_- = V_+$, $v_"sal" = v_"ent"$. No amplifica tensión, pero no carga a la fuente (no le pide corriente) y entrega toda la corriente que pida la carga: es un *separador* (_buffer_), como el seguidor de emisor del transistor.
  - *Sumador.* La entrada $-$ es masa virtual, así que cada entrada inyecta su propia corriente $v_k slash R_k$ sin estorbar a las demás. Las corrientes se suman en el nudo y salen por $R_f$: $v_"sal" = -R_f (v_1 slash R_1 + v_2 slash R_2 + v_3 slash R_3)$. Con todas las resistencias iguales, $v_"sal" = -(v_1 + v_2 + v_3)$: es el mezclador de audio de una mesa de sonido (que no hay que confundir con el mezclador de RF, que multiplica). #falstad("amp-sum.txt")
]

#circuito(caption: [Integrador (izquierda) y filtro activo paso bajo (derecha). Al poner un condensador en la realimentación, la ganancia depende de la frecuencia.], sim: "amp-integ.txt")[
  #esquema({
    import zap: *
    import cetz.draw: translate
    // integrador
    opamp("a1", (3.6, 0))
    resistor("r1", (0.2, 0.45), (2.0, 0.45), label: (content: $R$, anchor: "south"), n: "o-")
    wire((2.0, 0.45), "a1.minus")
    node("n1", (2.4, 0.45))
    wire((2.4, 0.45), (2.4, 1.6))
    capacitor("c1", (2.4, 1.6), (4.9, 1.6), label: $C$)
    wire((4.9, 1.6), (4.9, 0))
    wire("a1.out", (5.6, 0))
    node("o1", (5.6, 0), fill: false)
    node("n1b", (4.9, 0))
    wire("a1.plus", (2.2, -0.45), (2.2, -0.9))
    ground("g1", (2.2, -0.9))
    _t3-et((0.1, 0.45), $v_"ent"$, anchor: "east", size: 8pt)
    _t3-et((5.7, 0), $v_"sal"$, anchor: "west", size: 8pt)
    _t3-et((2.9, -2.0), [*integrador:* $v_"sal" = -1 / (R C) integral v_"ent" dif t$], size: 9pt)
    // filtro activo paso bajo
    translate((7.6, 0))
    opamp("a2", (3.6, 0))
    resistor("r1b", (0.2, 0.45), (2.0, 0.45), label: (content: $R_1$, anchor: "south"), n: "o-")
    wire((2.0, 0.45), "a2.minus")
    node("n2", (2.4, 0.45))
    wire((2.4, 0.45), (2.4, 2.5))
    resistor("r2b", (2.4, 1.5), (4.9, 1.5), label: (content: $R_2$, anchor: "south"))
    capacitor("c2b", (2.4, 2.5), (4.9, 2.5), label: $C$)
    wire((4.9, 2.5), (4.9, 0))
    node("n2c", (2.4, 1.5))
    node("n2d", (4.9, 1.5))
    wire("a2.out", (5.6, 0))
    node("o2", (5.6, 0), fill: false)
    node("n2b", (4.9, 0))
    wire("a2.plus", (2.2, -0.45), (2.2, -0.9))
    ground("g2", (2.2, -0.9))
    _t3-et((0.1, 0.45), $v_"ent"$, anchor: "east", size: 8pt)
    _t3-et((5.7, 0), $v_"sal"$, anchor: "west", size: 8pt)
    _t3-et((2.9, -2.0), [*paso bajo activo:* $G = -R_2 slash R_1$, $f_c = 1 / (2 pi R_2 C)$], size: 9pt)
  })
] <t3-fig-integrador-filtro>

#porque[
  - *Integrador.* La corriente $v_"ent" slash R$ de la entrada no puede entrar en el operacional: carga el condensador. La salida es la tensión del condensador cambiada de signo, que crece mientras haya corriente: $v_"sal" = -(1 slash R C) integral v_"ent" dif t$. Una onda cuadrada a la entrada da una triangular a la salida. Visto en frecuencia, es un paso bajo: la reactancia del condensador baja con la frecuencia y la ganancia cae 6 dB por octava.
  - *Paso bajo activo.* Es el inversor con un condensador en paralelo con $R_2$. A frecuencias bajas el condensador no conduce y la ganancia es $-R_2 slash R_1$; por encima de la frecuencia en que $X_C = R_2$, el condensador cortocircuita a $R_2$ y la ganancia cae. A diferencia de un filtro $R C$ pasivo, puede dar ganancia, y su salida de baja impedancia permite encadenar varias células sin que se carguen unas a otras. Montajes de segundo orden, como el Sallen-Key #falstad("filt-vcvs-lopass.txt"), dan 12 dB por octava con un solo operacional.
]

#ejemplo[Un filtro de audio para la salida de un receptor de SSB: $R_1 = 10$ kΩ, $R_2 = 100$ kΩ y $C = 680$ pF. En la banda de paso amplifica $-10$ (20 dB), y corta en $f_c = 1 slash (2 pi dot 10^5 dot 680 dot 10^(-12)) approx 2,3$ kHz: deja pasar la voz y atenúa el siseo agudo.]

#ojo[Un operacional tiene ganancia muy elevada, impedancia de entrada alta y de salida baja (T3.17). Sus entradas son inversora y no inversora (T3.19). Inversor: $G = -R_2 slash R_1$; no inversor: $G = 1 + R_2 slash R_1$ (T3.18). La realimentación negativa reduce la ganancia pero mejora la estabilidad y la linealidad; la positiva hace oscilar (T3.20, T3.25).]

#q("T3.17", "c",
  [Un amplificador operacional se caracteriza por tener:],
  ([ganancia baja e impedancia de entrada baja], [ganancia elevada e impedancia de salida elevada], [ganancia muy elevada, impedancia de entrada alta y de salida baja], [ganancia unidad y realimentación positiva]),
  sol: [Las tres cosas a la vez: amplifica muchísimo la diferencia entre sus entradas, apenas carga a lo que mide (entrada de alta impedancia) y entrega corriente sin hundirse (salida de baja impedancia). Es lo que permite encadenarlo con otras etapas sin que se estorben.],
)

#q("T3.18", "a",
  [En un amplificador operacional en montaje inversor, con $R_1$ a la entrada y $R_2$ de realimentación, la ganancia vale:],
  ([$-R_2 slash R_1$], [$R_1 slash R_2$], [$R_1 dot R_2$], [$1 + R_1 slash R_2$]),
  sol: [La realimentación negativa hace que la ganancia dependa solo de las dos resistencias, no del operacional. El signo menos recuerda que la salida se mueve en sentido contrario a la entrada. El montaje no inversor sería $1 + R_2 slash R_1$.],
)

#q("T3.19", "b",
  [Las dos entradas de un amplificador operacional se denominan:],
  ([primaria y secundaria], [inversora y no inversora], [directa y de realimentación], [de puerta y de surtidor]),
  sol: [Se marcan con $-$ y $+$ según si la salida se mueve en contra o a favor de la señal aplicada a cada una. Primario y secundario son de un transformador; puerta y surtidor, de un FET.],
)

#q("T3.20", "d",
  [La realimentación negativa aplicada a un amplificador:],
  ([aumenta la ganancia y la distorsión], [hace que el circuito oscile], [no altera ninguna característica del amplificador], [reduce la ganancia pero mejora la estabilidad y la linealidad]),
  sol: [Es el intercambio de siempre: se sacrifica ganancia — que sobra y es barata — a cambio de estabilidad, linealidad y ancho de banda. La que hace oscilar al circuito es la realimentación positiva, que es justo el principio del oscilador.],
)

#q("T3.21", "b",
  [Un amplificador que trabaja en clase A conduce durante:],
  ([180° del ciclo de la señal], [los 360° del ciclo de la señal], [menos de 180° del ciclo de la señal], [un cuarto del ciclo de la señal]),
  sol: [El dispositivo nunca se corta, así que reproduce el ciclo entero con la mínima distorsión. El precio es que disipa incluso sin señal, y de ahí su pobre rendimiento.],
)

#q("T3.22", "a",
  [Un amplificador que trabaja en clase B conduce durante:],
  ([180° del ciclo de la señal], [los 360° del ciclo de la señal], [90° del ciclo de la señal], [todo el ciclo menos los picos]),
  sol: [Medio ciclo exacto. Por eso la clase B se monta en contrafase: dos dispositivos que se reparten un semiciclo cada uno y entre los dos reconstruyen la onda completa.],
)

#q("T3.23", "d",
  [De las clases de amplificación A, AB, B y C, la de mayor rendimiento es la:],
  ([clase A], [clase AB], [clase B], [clase C]),
  sol: [El rendimiento crece según se acorta el ángulo de conducción, y la clase C es la que menos conduce. Es también la que peor conserva la forma de la señal: las dos cosas van siempre de la mano.],
)

#q("T3.24", "c",
  [Un amplificador de clase C únicamente puede emplearse con emisiones:],
  ([de banda lateral única], [de amplitud modulada], [de amplitud constante, como CW o FM], [de cualquier tipo, si se ajusta la polarización]),
  sol: [En clase C la envolvente se destroza. Si la información viaja en la amplitud — AM, SSB — se pierde y aparecen productos espurios; si la amplitud es constante y la información va en la frecuencia o en la presencia o ausencia de portadora, no hay nada que estropear.],
)

#q("T3.25", "d",
  [Se denomina realimentación al proceso de:],
  ([convertir una corriente alterna en continua], [separar la moduladora de la portadora], [sumar dos frecuencias en un mezclador], [tomar parte de la señal de salida de un circuito y devolverla a su entrada]),
  sol: [Si lo devuelto se opone a la entrada es realimentación negativa (estabiliza); si la refuerza, positiva, y el circuito acaba oscilando por sí solo. Las otras tres opciones describen la rectificación, la detección y la mezcla.],
)

#q("T3.26", "a",
  [El orden correcto de las etapas de una fuente de alimentación lineal es:],
  ([transformador, rectificador, filtro y regulador], [rectificador, transformador, regulador y filtro], [filtro, transformador, rectificador y regulador], [regulador, filtro, rectificador y transformador]),
  sol: [Se sigue el camino de la energía: primero se baja la tensión de red, después se rectifica la alterna, luego el condensador alisa el rizado y por último el regulador fija la tensión de salida. Cualquier otro orden no tendría sentido físico — no se puede filtrar el rizado antes de crearlo.],
)

#q("T3.27", "b",
  [Un oscilador es un dispositivo que:],
  ([reduce el ancho de banda de un transmisor], [convierte corriente continua en corriente alterna], [elimina los ruidos de la señal recibida], [adapta la impedancia de la antena]),
  sol: [Toma la energía continua de la alimentación y la entrega como una señal alterna de la frecuencia que fije su circuito resonante. Es el corazón de todo transmisor y el que genera la señal del oscilador local en el receptor.],
)

#q("T3.28", "c",
  [Tres condensadores conectados en paralelo suman 400 pF. Si dos de ellos son de 100 pF, el tercero tiene una capacidad de:],
  ([100 pF], [400 pF], [200 pF], [300 pF]),
  sol: [En paralelo las capacidades se suman: $C_3 = 400 - 100 - 100 = 200$ pF. Ojo con el reflejo de aplicar la fórmula de las resistencias en paralelo: en los condensadores es al revés.],
)

#q("T3.29", "d",
  [En un circuito con dos resistencias en paralelo, la intensidad total es:],
  ([la suma de las caídas de tensión en cada rama], [la que circula por la rama de mayor resistencia], [la que circula por la rama de menor resistencia], [la suma de las intensidades de cada una de las ramas]),
  sol: [Es la primera ley de Kirchhoff: en el nudo de entrada la corriente se reparte entre las ramas y en el de salida se vuelve a juntar. Lo que es común en paralelo es la tensión, no la intensidad.],
)

#q("T3.30", "c",
  [El cuadrado de la frecuencia de resonancia de un circuito $L C$ es:],
  ([directamente proporcional a la inductancia], [directamente proporcional a la capacidad], [inversamente proporcional al producto de la inductancia por la capacidad], [independiente de los valores de $L$ y de $C$]),
  sol: [De $f_0 = 1 slash (2 pi sqrt(L C))$ se sigue $f_0^2 = 1 slash (4 pi^2 L C)$. Al aumentar $L$ o $C$, la frecuencia de resonancia baja: por eso se sintoniza más bajo metiendo más capacidad.],
)

#q("T3.31", "b",
  [Un rectificador de onda completa, comparado con uno de media onda:],
  ([entrega una tensión continua de menor valor medio], [aprovecha los dos semiciclos y produce menos rizado], [necesita siempre el doble de tensión de entrada], [solo puede emplearse con corriente continua]),
  sol: [Al aprovechar los dos semiciclos, el valor medio se dobla ($2 V_p slash pi$ frente a $V_p slash pi$) y la frecuencia del rizado también (100 Hz en lugar de 50 Hz en una red de 50 Hz), de modo que el mismo condensador lo filtra mucho mejor.],
)

#q("T3.32", "a",
  [La misión del regulador de una fuente de alimentación es:],
  ([mantener constante la tensión de salida aunque varíen la carga y la red], [transformar la corriente alterna en continua], [elevar la tensión de la red], [aumentar la frecuencia de la corriente rectificada]),
  sol: [Es la última etapa y la que da la calidad final: absorbe tanto las variaciones de la tensión de red como los tirones de consumo del equipo — muy notables en un transceptor que pasa de recepción a transmisión.],
)

#q("T3.33", "c",
  [Un filtro de paso bajo deja pasar:],
  ([únicamente la frecuencia de corte], [las frecuencias superiores a la de corte], [las frecuencias inferiores a la de corte], [una banda estrecha centrada en la frecuencia de corte]),
  sol: [El nombre lo dice: pasa lo bajo. Es el filtro que se coloca a la salida de un transmisor para atenuar los armónicos, que están por encima de la frecuencia de trabajo.],
)

#q("T3.34", "b",
  [Se entiende por anchura de banda necesaria de una emisión:],
  ([la anchura total del margen de frecuencias del transmisor], [la anchura estrictamente suficiente para transmitir la información en las condiciones requeridas], [la separación entre dos canales consecutivos], [la anchura que la antena puede radiar sin acoplador]),
  sol: [Es la definición del Reglamento de Radiocomunicaciones: ni más ni menos de la que hace falta. Ocupar más espectro del necesario es, además de ineficaz, una fuente de interferencias a los vecinos de banda.],
)

#q("T3.35", "b",
  [Un rectificador de onda completa en puente necesita como mínimo:],
  ([dos diodos], [cuatro diodos], [un diodo], [seis diodos]),
  sol: [El puente los coloca en rombo, de modo que en cada semiciclo conducen dos en diagonal y la carga recibe siempre la misma polaridad: de ahí los cuatro diodos. Nota: el enunciado dice «en puente». Sin esa precisión, el mínimo de un rectificador de onda completa es de dos diodos (con un transformador de toma media en el secundario); con uno solo se rectifica media onda.],
)

#q("T3.36", "d",
  [El filtro que sigue al rectificador en una fuente de alimentación tiene por objeto eliminar:],
  ([la componente continua de la señal], [los armónicos de radiofrecuencia], [la corriente de fuga de los diodos], [la componente alterna que queda tras la rectificación]),
  sol: [A la salida del rectificador hay una tensión pulsante: continua con un fuerte rizado. El condensador sostiene la tensión entre picos y alisa esa componente alterna residual. Lo que no debe tocar es la continua, que es precisamente lo que se busca.],
)

#q("T3.37", "a",
  [Un amplificador con transistor montado en base común proporciona amplificación:],
  ([de tensión, pero no de corriente], [de corriente, pero no de tensión], [de ninguna de las dos magnitudes], [de corriente y de tensión por igual]),
  sol: [En base común la corriente de salida es prácticamente igual a la de entrada —la ganancia de corriente vale casi 1— pero la impedancia de salida es mucho mayor que la de entrada, y de ahí que la tensión sí se amplifique. Es un montaje habitual en radiofrecuencia por su buen comportamiento en alta frecuencia.],
)

#q("T3.38", "b",
  [El llamado detector de envolvente se emplea en receptores para señales con modulación de:],
  ([frecuencia], [amplitud], [fase], [impulsos]),
  sol: [En AM la información viaja en la envolvente, y un diodo con su filtro $R C$ la sigue directamente. Para FM haría falta un discriminador, y para SSB un detector de producto: el de envolvente no sirve donde no hay portadora.],
)

#q("T3.39", "b",
  [Una lectura expresada como «10 dBμV» corresponde a una magnitud de:],
  ([potencia], [tensión], [intensidad], [frecuencia]),
  sol: [El dBμV toma como referencia un microvoltio, así que expresa tensión. Con la misma lógica, el dBm y el dBW expresan potencia, y el dB a secas es una relación sin unidades.],
)

#q("T3.40", "a",
  [Para poder variar la frecuencia de emisión, los transceptores emplean:],
  ([un oscilador de frecuencia variable], [un oscilador de cuarzo de frecuencia fija], [un multiplicador de frecuencia], [un detector de producto]),
  sol: [El VFO es el que permite moverse por la banda de forma continua. Un cristal fija una sola frecuencia, y por eso los equipos antiguos de canales llevaban un cristal por canal.],
)

#q("T3.41", "c",
  [La frecuencia de corte de un filtro es:],
  ([la frecuencia a la que el filtro deja de funcionar], [la frecuencia de resonancia de su bobina], [la frecuencia que delimita la banda de paso de la de atenuación], [la frecuencia máxima que soporta sin dañarse]),
  sol: [Es la frontera del filtro, y por convenio se sitúa donde la respuesta ha caído 3 dB. Por encima o por debajo de ella —según el tipo— la señal empieza a atenuarse de verdad.],
)

#q("T3.42", "a",
  [La resistencia total de varias resistencias conectadas en serie es:],
  ([la suma de sus valores individuales], [menor que la más pequeña de ellas], [la media aritmética de sus valores], [el producto de sus valores]),
  sol: [En serie la misma corriente atraviesa todas y las caídas de tensión se suman, luego $R = R_1 + R_2 + dots$. El resultado es siempre mayor que la mayor de ellas, al revés que en paralelo.],
)

#q("T3.43", "c",
  [Dos resistencias iguales conectadas en paralelo presentan un valor resultante igual a:],
  ([el doble de una de ellas], [el mismo de una de ellas], [la mitad de una de ellas], [la suma de ambas]),
  sol: [$R_1 R_2 slash (R_1 + R_2)$ con $R_1 = R_2 = R$ da $R slash 2$. Es el caso particular que conviene tener memorizado: dos iguales en paralelo, la mitad; $n$ iguales, $R slash n$.],
)

#q("T3.44", "c",
  [En un circuito formado por tres resistencias de distinto valor conectadas en paralelo, la corriente que circula por cada una es:],
  ([la misma en todas ellas], [directamente proporcional a su resistencia], [inversamente proporcional a su resistencia], [independiente de su resistencia]),
  sol: [En paralelo todas soportan la misma tensión, así que por la ley de Ohm cada una toma $I = V slash R$: cuanto menor es la resistencia, más corriente pasa por ella. Por la de menor valor circula la mayor parte del total.],
)

#q("T3.45", "d",
  [Los osciladores controlados por un cristal de cuarzo se caracterizan por generar una señal:],
  ([de amplitud muy elevada], [de frecuencia fácilmente ajustable], [de gran contenido en armónicos], [de frecuencia muy estable]),
  sol: [Un cristal de cuarzo tiene un factor de calidad altísimo y una frecuencia propia que apenas deriva con la temperatura. Esa estabilidad es lo que se busca; a cambio, la frecuencia no puede moverse apenas.],
)

#q("T3.46", "a",
  [El efecto piezoeléctrico, en el que se basan los resonadores empleados en los osciladores, se produce en:],
  ([los cristales de cuarzo], [los núcleos de ferrita], [los condensadores electrolíticos], [los conductores de cobre]),
  sol: [El cuarzo deforma su geometría al aplicarle tensión y genera tensión al deformarse. Esa reciprocidad convierte al cristal en un resonador mecánico de altísimo $Q$, que es lo que estabiliza al oscilador.],
)

#q("T3.47", "b",
  [Un armónico de segundo orden generado por un circuito no lineal tiene una frecuencia:],
  ([igual a la mitad de la fundamental], [doble de la fundamental], [triple de la fundamental], [independiente de la fundamental]),
  sol: [Los armónicos son múltiplos enteros: el segundo es $2 f$, el tercero $3 f$, y así. Es la razón de que emitiendo en 7 MHz haya que vigilar los 14 MHz, y de que el filtro de salida sea de paso bajo.],
)

#q("T3.48", "c",
  [En la etapa final de un transmisor se conectan a veces dos válvulas en paralelo con objeto de:],
  ([mejorar la estabilidad de frecuencia], [reducir el consumo del equipo], [obtener mayor potencia de salida], [disminuir la anchura de banda]),
  sol: [Dos dispositivos en paralelo reparten la corriente y entregan a la carga más potencia de la que daría uno solo. Es la forma clásica de subir potencia en los finales valvulares, cuidando el reparto entre ambos.],
)

#q("T3.49", "b",
  [El circuito de acoplamiento intercalado entre dos etapas amplificadoras:],
  ([impide el paso de la señal entre ellas], [deja pasar la señal e independiza las polarizaciones de ambas etapas], [duplica la ganancia del conjunto], [convierte la señal en continua]),
  sol: [Cada etapa necesita su propio punto de trabajo en continua. El acoplamiento —por condensador o por transformador— deja pasar la señal alterna y bloquea la continua, de modo que la polarización de una no perturbe la de la siguiente.],
)

#q("T3.50", "c",
  [Los filtros empleados en las etapas de frecuencia intermedia de un receptor son de tipo:],
  ([paso bajo], [paso alto], [paso banda], [de rechazo de banda]),
  sol: [La FI trabaja a frecuencia fija, y lo que hace falta es dejar pasar solo la anchura de banda de la emisión y rechazar todo lo demás: eso es exactamente un paso banda. De su estrechez depende la selectividad.],
)

#q("T3.51", "a",
  [Los efectos de los transitorios en las líneas de alimentación se evitan generalmente:],
  ([con condensadores de desacoplo], [alargando los cables], [elevando la tensión de alimentación], [suprimiendo la toma de tierra]),
  sol: [Un condensador se opone a las variaciones bruscas de tensión, así que absorbe los picos y valles que viajan por la alimentación. Es la misma función que cumplen los condensadores de desacoplo repartidos por las placas.],
)

#q("T3.52", "d",
  [A la frecuencia de resonancia, un circuito $L C$ se comporta frente a la corriente como:],
  ([puramente inductivo], [puramente capacitivo], [un circuito abierto a cualquier frecuencia], [puramente resistivo]),
  sol: [En resonancia las reactancias inductiva y capacitiva se igualan y se cancelan, y solo queda la resistencia: tensión y corriente vuelven a estar en fase. Es la propiedad que se aprovecha para adaptar y para seleccionar.],
)

#q("T3.53", "b",
  [Efectuar la sintonización de la etapa final de un emisor a plena potencia puede producir:],
  ([una mejora del rendimiento], [daños en los dispositivos del paso final], [un aumento de la estabilidad], [una reducción de los armónicos]),
  sol: [Durante la sintonía el circuito de salida no está adaptado y buena parte de la potencia se disipa en el propio dispositivo en lugar de irse a la antena. Se sintoniza a potencia reducida y solo después se sube.],
)

#q("T3.54", "c",
  [Al actuar sobre el conmutador de bandas de un transceptor se consigue:],
  ([variar la potencia de salida], [conmutar entre transmisión y recepción], [situar el equipo en el margen de frecuencias deseado], [cambiar el modo de emisión]),
  sol: [El conmutador de bandas selecciona los circuitos sintonizados y los filtros correspondientes a la banda elegida. No cambia ni la potencia, ni el modo, ni el sentido de la comunicación.],
)

== Más preguntas sobre esquemas <t3-sec-esquemas2>

#q("T3.55", "b",
  [El circuito de la figura, empleado a la salida de la frecuencia intermedia de un receptor, se denomina:
    #circuito(caption: [Esquema de la pregunta T3.55.], sim: "amdetect.txt")[
      #esquema({
        import zap: *
        wire((0, 2), (0.8, 2))
        diode("d", (0.8, 2), (2.4, 2))
        wire((2.4, 2), (5.4, 2))
        resistor("r", (3.2, 2), (3.2, 0), label: $R$)
        capacitor("c", (4.4, 2), (4.4, 0), label: $C$)
        wire((0, 0), (5.4, 0))
        node("a", (0, 2), fill: false)
        node("b", (0, 0), fill: false)
        node("o1", (5.4, 2), fill: false)
        node("o2", (5.4, 0), fill: false)
        node("n1", (3.2, 2))
        node("n2", (4.4, 2))
        node("n3", (3.2, 0))
        node("n4", (4.4, 0))
        _t3-et((-0.1, 2), [entrada RF], anchor: "east", size: 8pt)
        _t3-et((5.5, 2), [salida AF], anchor: "west", size: 8pt)
      })
    ] <t3-fig-q55>],
  ([oscilador a cristal], [detector de envolvente], [multiplicador de frecuencia], [filtro de paso alto]),
  sol: [Un diodo que rectifica y un grupo $R C$ que sigue los picos: eso es un detector de envolvente. La constante $R C$ debe ser lo bastante lenta para alisar la radiofrecuencia y lo bastante rápida para seguir la moduladora. Es el detector de AM por excelencia.],
)

#porque[En la @t3-fig-q55 el diodo deja pasar solo los semiciclos positivos de la FI; el condensador se carga en cada pico y la resistencia lo descarga lo justo para que su tensión siga a la envolvente. Es el mismo circuito de la @t3-fig-envolvente, el de la radio de galena sin el circuito sintonizado.]

#q("T3.56", "c",
  [La capacidad resultante entre los terminales del circuito de la figura responde a la expresión:
    #circuito(caption: [Esquema de la pregunta T3.56.], sim: "cappar.txt")[
      #esquema({
        import zap: *
        wire((0, 2.0), (4.2, 2.0))
        wire((1.2, 0), (5.4, 0))
        capacitor("c1", (1.2, 2.0), (1.2, 0), label: $C_1$)
        capacitor("c2", (2.7, 2.0), (2.7, 0), label: $C_2$)
        capacitor("c3", (4.2, 2.0), (4.2, 0), label: $C_3$)
        node("t1", (0, 2.0), fill: false)
        node("t2", (5.4, 0), fill: false)
        node("n1", (1.2, 2.0))
        node("n2", (2.7, 2.0))
        node("n3", (2.7, 0))
        node("n4", (4.2, 0))
      })
    ] <t3-fig-q56>],
  ([$1 slash C = 1 slash C_1 + 1 slash C_2 + 1 slash C_3$], [$C = C_1 dot C_2 dot C_3$], [$C = C_1 + C_2 + C_3$], [$C = (C_1 + C_2 + C_3) slash 3$]),
  sol: [Los tres condensadores comparten los mismos dos nudos, luego están en paralelo y las capacidades se suman. La expresión de los inversos corresponde a la asociación en serie, que es la trampa habitual.],
)

#porque[En la @t3-fig-q56 todas las placas de arriba están unidas a un terminal y todas las de abajo al otro: los tres condensadores ven la misma tensión y cada uno guarda su carga. Desde fuera es como un solo condensador con la suma de las superficies. Para saber si dos componentes están en paralelo, no mires el dibujo: mira si comparten los dos mismos nudos.]

#q("T3.57", "d",
  [En el circuito de la figura, una vez alcanzado el régimen permanente, la tensión entre los bornes del condensador $C$ vale:
    #circuito(caption: [Esquema de la pregunta T3.57.], sim: "voltdivide.txt")[
      #esquema({
        import zap: *
        bateria("b", (0, 2.2), (0, 0))
        _t3-et((-0.35, 1.1), [12 V], anchor: "east", size: 8.5pt)
        wire((0, 2.2), (0.8, 2.2))
        resistor("r1", (0.8, 2.2), (2.4, 2.2), label: [1 kΩ])
        wire((2.4, 2.2), (4.8, 2.2))
        resistor("r2", (3.0, 2.2), (3.0, 0), label: [3 kΩ])
        capacitor("c", (4.8, 2.2), (4.8, 0), label: $C$)
        wire((0, 0), (4.8, 0))
        node("n1", (3.0, 2.2))
        node("n2", (3.0, 0))
      })
    ] <t3-fig-q57>],
  ([12 V], [3 V], [0 V], [9 V]),
  sol: [En régimen permanente el condensador está cargado y no circula corriente por su rama, así que el circuito se reduce al divisor de las dos resistencias: $V_C = 12 dot 3 slash (1 + 3) = 9$ V. El condensador queda a la tensión del punto al que está conectado.],
)

#porque[En la @t3-fig-q57, al conectar la pila el condensador está descargado y toma corriente; a medida que se carga, la corriente por su rama disminuye hasta anularse (en continua, un condensador cargado es un circuito abierto). A partir de ahí es como si no estuviera: las dos resistencias forman un divisor y el condensador queda a la tensión de la de 3 kΩ. Si después se desconectara la pila, el condensador se descargaría a través de la resistencia de 3 kΩ.]
