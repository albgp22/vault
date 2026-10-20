#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// Recuadro «NO ESTÁ EN EL TEXTO» de las soluciones del apéndice D.21 (local: ap-c1)
#let _apc1-noest(cuerpo) = no-esta(cuerpo)
// Mismo rótulo, en línea (texto de apertura)
#let _apc1-noest-ro = text(font: fuente-sans, size: 0.78em, tracking: 0.06em, fill: col.naranja, weight: "bold", upper[no está en el texto])

#apendice("C", "Refuerzo del temario")

Las preguntas de los bancos públicos no bastan para prepararse: el estudio de las diez convocatorias reales de papel (2007–2011) muestra que cada examen traía casi todas las preguntas nuevas, y los candidatos de los últimos años cuentan que la parte técnica del examen actual se parece poco a los tests públicos. La defensa razonable es cubrir _cada punto del temario oficial_ (Anexo II de la Orden IET/1311/2013) con el tipo de pregunta del examen. Con ese fin se descompuso el temario en 414 puntos evaluables (200 de la prueba primera y 214 de la segunda) y se comprobó, punto por punto, qué explica el cuaderno y cuántas preguntas lo evalúan.

El resultado fue favorable en la teoría (ningún punto de la prueba primera falta en el texto) pero irregular en las preguntas: las unidades, el código de colores, las clases de amplificación o la seguridad acumulaban decenas de preguntas, mientras que puntos enteros (cálculo de reactancias, frecuencia de resonancia y Q, impedancias, decibelios en cadena, ROE con números, p.r.e., horizonte radioeléctrico, modulación digital, PLL, DDS, ruido de fase, y en la normativa buena parte del Anexo I y de los artículos de la Orden) no tenían ninguna. Este apéndice recoge 410 preguntas de _elaboración propia_ que rellenan esos huecos. Cada una está resuelta y verificada (los cálculos, con números y unidades; la normativa, contra el texto consolidado de la Orden IET/1311/2013 y de la Ley 11/2022), y su solución indica si la materia está en el cuaderno (_«Véase…»_) o, si no lo está, la explica en un recuadro #_apc1-noest-ro.

#nota[La numeración es *F-T6.3*: pregunta de refuerzo 3 del tema T6. A diferencia de las del apéndice anterior, estas preguntas no salen de un banco público: proponen el tipo de pregunta que el examen podría hacer sobre cada punto del temario. Sirven para comprobar que dominas el punto, no para adivinar cuáles caerán.]


== Tema T1. Teoría de la electricidad, el electromagnetismo y la radio <apc1-sec-t1>

#q("F-T1.1", "c",
  [El campo magnético creado por un conductor rectilíneo largo recorrido por corriente es más intenso cuanto:],
  ([mayor es la corriente y mayor es la distancia al conductor], [menor es la corriente y menor es la distancia al conductor], [mayor es la corriente y menor es la distancia al conductor], [menor es la corriente y mayor es la distancia al conductor]),
  sol: [Para un hilo rectilíneo largo, $B = (mu_0 I)/(2 pi d)$: el campo es proporcional a la corriente $I$ e inversamente proporcional a la distancia $d$. Crece, pues, al aumentar la corriente y al acercarse al hilo: si se duplica $I$, se duplica $B$; si se duplica $d$, $B$ se reduce a la mitad. Cada una de las otras opciones invierte al menos uno de los dos factores, y la de menor corriente y mayor distancia da el campo más débil de todos. La resistencia del conductor no interviene. _(Véase tema T1, sección «Ondas y señales».)_],
)

#q("F-T1.2", "b",
  [Las líneas del campo magnético alrededor de un conductor rectilíneo con corriente son:],
  ([rectas paralelas al conductor], [circunferencias concéntricas con el conductor, en planos perpendiculares a él], [rectas radiales que salen del conductor, como las del campo eléctrico de una carga puntual], [espirales que se alejan del conductor]),
  sol: [Una corriente rodea su eje de campo magnético: las líneas son circunferencias cerradas, concéntricas con el hilo y contenidas en planos perpendiculares a él. El sentido lo da la regla de la mano derecha: con el pulgar en el sentido de la corriente, los demás dedos indican el giro del campo. Las líneas magnéticas no tienen principio ni fin. Las rectas radiales son el dibujo del campo eléctrico de una carga puntual, no del magnético de una corriente; ni las rectas paralelas ni las espirales describen el campo de un hilo recto. _(Véase tema T1, sección «Ondas y señales».)_],
)

#q("F-T1.3", "d",
  [Para apantallar un campo magnético de baja frecuencia (por ejemplo, el de 50 Hz de un transformador de red) conviene emplear:],
  ([una caja de plástico o de madera], [una malla de cobre conectada a tierra], [una chapa de aluminio delgada conectada a tierra (jaula de Faraday)], [una envolvente de material ferromagnético de alta permeabilidad, como el mu-metal o el hierro dulce]),
  sol: [El campo magnético de baja frecuencia atraviesa casi sin atenuación los materiales no magnéticos de poco espesor: hay que desviarlo, ofreciéndole un camino más fácil que el aire, y eso lo hace una envolvente de material ferromagnético de alta permeabilidad (mu-metal, hierro dulce). La jaula de Faraday y la malla de cobre a tierra detienen los campos eléctricos y las ondas de radio, pero a 50 Hz una chapa delgada apenas frena el campo magnético. El plástico y la madera no tienen ningún efecto. _(Véase tema T1, sección «Ondas y señales».)_],
)

#q("F-T1.4", "a",
  [La tensión de la red eléctrica es de 230 V eficaces. Su valor de pico es aproximadamente de:],
  ([325 V], [230 V], [163 V], [460 V]),
  sol: [$V_p = V_"ef" sqrt(2) = 230 times 1,414 approx 325$ V (y 650 V de pico a pico). Los 163 V resultan de aplicar la fórmula al revés, $230 slash sqrt(2)$; los 460 V, de multiplicar por 2 en lugar de por $sqrt(2)$; y los 230 V son precisamente el valor eficaz, el que disiparía en una resistencia la misma potencia que una tensión continua de 230 V. _(Véase tema T1, sección «Ondas y señales».)_],
)

#q("F-T1.5", "c",
  [Una señal sinusoidal de 20 V de pico a pico tiene un valor eficaz aproximado de:],
  ([10 V], [14,1 V], [7,07 V], [20 V]),
  sol: [De pico a pico hay el doble que de pico: $V_p = 20 slash 2 = 10$ V. El valor eficaz es $V_"ef" = V_p slash sqrt(2) = 10 slash 1,414 approx 7,07$ V. Los 10 V son el valor de pico, los 20 V el de pico a pico, y los 14,1 V resultan de dividir los 20 V entre $sqrt(2)$ sin partirlos antes por 2, es decir, de tomar el valor de pico a pico como si fuera el de pico. _(Véase tema T1, sección «Ondas y señales».)_],
)

#q("F-T1.6", "b",
  [Una señal sinusoidal de 1 kHz y otra idéntica retrasada 250 μs respecto a ella tienen entre sí un desfase de:],
  ([45°], [90°], [180°], [360°]),
  sol: [El período de 1 kHz es $T = 1 slash f = 1$ ms. Un ciclo completo equivale a $360°$, luego $Delta phi = 360° (Delta t)/T = 360° dot 250/1000 = 90°$: un cuarto de ciclo. Los 45° corresponderían a 125 μs; los 180° (oposición de fase), a 500 μs; y 360° equivale a 1 ms, un ciclo entero, tras el cual las dos señales vuelven a estar en fase. _(Véase tema T1, sección «Ondas y señales».)_

#_apc1-noest[La diferencia de fase también se puede expresar como un retardo en el tiempo. Un ciclo completo dura $T = 1 slash f$ y equivale a $360°$, así que $Delta phi = 360° dot Delta t slash T = 360° dot f dot Delta t$. A 1 kHz, $T = 1$ ms: un retraso de 250 μs es un cuarto de ciclo ($90°$) y uno de 500 μs es medio ciclo ($180°$, oposición de fase).]],
)

#q("F-T1.7", "d",
  [Un oscilador genera una onda cuadrada simétrica (ciclo de trabajo del 50 %, sin componente continua) de 7,05 MHz. Además de la fundamental, su espectro contiene componentes en:],
  ([14,10 MHz, 28,20 MHz, 42,30 MHz…(solo los múltiplos pares)], [14,10 MHz, 21,15 MHz, 28,20 MHz…(todos los múltiplos enteros)], [3,525 MHz, 2,35 MHz, 1,76 MHz…(los submúltiplos)], [21,15 MHz, 35,25 MHz, 49,35 MHz…(solo los múltiplos impares)]),
  sol: [Por Fourier, una onda cuadrada simétrica es una fundamental de 7,05 MHz más los armónicos _impares_, $3 f$, $5 f$, $7 f$…, con amplitudes 1/3, 1/5, 1/7… de la fundamental: $3 times 7,05 = 21,15$ MHz, $5 times 7,05 = 35,25$ MHz y $7 times 7,05 = 49,35$ MHz. Los armónicos pares (14,10, 28,20, 42,30 MHz) solo aparecen si la onda es asimétrica, con ciclo de trabajo distinto del 50 %. Los submúltiplos nunca son armónicos: estos son siempre múltiplos enteros de la fundamental. _(Véase tema T1, sección «Ondas y señales».)_

#_apc1-noest[Toda señal periódica no sinusoidal se descompone en una componente continua (su valor medio), una fundamental y armónicos múltiplos enteros de ella. En la onda cuadrada simétrica, sin componente continua, solo hay armónicos impares ($3 f$, $5 f$, $7 f$…), con amplitud $1 slash n$ de la fundamental; los pares desaparecen. Si el ciclo de trabajo no es del 50 % aparecen también los pares, y si la onda no está centrada en cero, una componente continua.]],
)

#q("F-T1.8", "a",
  [La potencia de ruido térmico disponible en una resistencia adaptada al receptor es proporcional:],
  ([a la temperatura absoluta y al ancho de banda], [solo a la frecuencia central de trabajo], [a la ganancia de la antena y a la frecuencia de trabajo], [al cuadrado de la frecuencia de trabajo]),
  sol: [La potencia de ruido térmico disponible es $P = k T B$, con $k$ la constante de Boltzmann, $T$ la temperatura absoluta (en kelvin) y $B$ el ancho de banda. Es proporcional a $T$ y a $B$, y no depende de la frecuencia central: es ruido blanco, de densidad de potencia constante. Ni la ganancia de la antena ni el cuadrado de la frecuencia intervienen; la ganancia de la antena amplifica señal y ruido externos, pero no fija el ruido térmico de la resistencia. _(Véase tema T1, sección «Ondas y señales».)_],
)

#q("F-T1.9", "c",
  [Si se reduce a la mitad el ancho de banda del filtro de un receptor, la potencia de ruido térmico que admite:],
  ([disminuye 6 dB], [aumenta 3 dB], [disminuye 3 dB], [no varía]),
  sol: [Como $P = k T B$, la potencia de ruido es proporcional al ancho de banda. Con la mitad de $B$, la potencia es la mitad: $10 log_10 (1/2) approx -3$ dB. Por eso un filtro estrecho «oye» menos ruido. Una caída de 6 dB exigiría dejar $B$ en la cuarta parte; +3 dB es lo que ocurre al _duplicar_ el ancho de banda; y «no varía» sería cierto solo para la densidad de ruido por hercio, no para la potencia total que entra por el filtro. _(Véase tema T1, sección «Ondas y señales».)_],
)

#q("F-T1.10", "b",
  [La potencia de ruido térmico en un ancho de banda de 1 kHz, a la temperatura de referencia de 290 K, es de aproximadamente:],
  ([−174 dBm], [−144 dBm], [−114 dBm], [−204 dBm]),
  sol: [El suelo térmico es $k T_0 = -174$ dBm por cada hercio. Para $B = 1$ kHz hay que sumar $10 log_10 (1000) = 30$ dB: $-174 + 30 = -144$ dBm. Los −174 dBm son el valor por hercio (se olvida el ancho de banda); −114 dBm corresponde a 1 MHz (+60 dB); y −204 dBm resta los 30 dB en lugar de sumarlos: un ancho de banda mayor siempre admite más ruido. _(Véase tema T4, sección «Características y controles».)_],
)

#q("F-T1.11", "d",
  [La anchura de banda típica de una emisión de telegrafía en onda continua (A1A) es del orden de:],
  ([2,7 kHz, como la de la SSB], [6 kHz, como la de la AM], [12,5 kHz, como la de la FM de banda estrecha], [100 a 500 Hz, según la velocidad de manipulación]),
  sol: [En CW no hay moduladora de audio: la anchura la fijan la velocidad de manipulación y la brusquedad de los flancos de los pulsos Morse. A velocidades normales de aficionado ocupa del orden de 100 a 500 Hz, muy por debajo de los 2,7 kHz de la SSB, los 6 kHz de la AM o los 12,5 kHz de la FM de banda estrecha. Por eso los receptores llevan filtros de CW de 250 a 500 Hz, y por eso caben muchas estaciones de telegrafía en pocos kilohercios. _(Véase tema T1, sección «Señales moduladas».)_

#_apc1-noest[La anchura de banda de una emisión de telegrafía en onda continua (A1A) no depende de ninguna frecuencia moduladora, sino de la velocidad de manipulación y de la forma de los flancos: cuanto más rápido se manipula y más bruscos son los flancos, más ancha es la emisión. A velocidades normales de aficionado es del orden de 100 a 500 Hz, mucho menos que los 2,7 kHz de la SSB o los 6 kHz de la AM. Por eso los receptores incorporan filtros de CW de 250 a 500 Hz.]],
)

#q("F-T1.12", "a",
  [Una emisión de AM (A3E) se modula con audio cuya frecuencia máxima es de 3 kHz. La anchura de banda que ocupa es aproximadamente de:],
  ([6 kHz], [3 kHz], [2,7 kHz], [12 kHz]),
  sol: [En AM hay dos bandas laterales, en $f_c plus.minus f_m$, así que $B = 2 f_"m,máx" = 2 times 3 = 6$ kHz, sea cual sea la frecuencia de la portadora. Los 3 kHz son la anchura de una sola banda lateral, como en SSB; los 2,7 kHz son la anchura típica de una emisión J3E (SSB de voz); y 12 kHz duplicaría el resultado sin motivo. _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.13", "b",
  [La envolvente de una emisión de AM oscila entre un máximo de 15 V y un mínimo de 5 V. El índice de modulación es de:],
  ([33 %], [50 %], [67 %], [100 %]),
  sol: [$m = (A_"máx" - A_"mín")/(A_"máx" + A_"mín") = (15 - 5)/(15 + 5) = 0,5$, es decir, 50 %. Equivale a una portadora de $A = (15 + 5)/2 = 10$ V con una variación de ±5 V: $5/10 = 0,5$. El 33 % sale de dividir el mínimo entre el máximo (5/15); el 67 %, de dividir entre el máximo en lugar de entre la suma (10/15); y el 100 % exigiría que la envolvente llegase a cero. _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.14", "d",
  [Un transmisor de AM tiene una potencia de portadora de 100 W. Modulado al 100 %, la potencia total de la emisión es de:],
  ([125 W], [100 W], [200 W], [150 W]),
  sol: [Con $m = 1$: $P_t = P_c (1 + m^2/2) = 100 times 1,5 = 150$ W. Se reparten así: 100 W en la portadora y $m^2/4 P_c = 25$ W en cada banda lateral (100 + 25 + 25). Los 200 W suponen que modular duplica la potencia; los 125 W cuentan una sola banda lateral; y los 100 W son solo la portadora, sin las bandas laterales que aparecen al modular. _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.15", "c",
  [Un condensador de 0,01 μF tiene una capacidad de:],
  ([10 pF], [1 nF], [10 nF], [100 nF]),
  sol: [1 μF = 1000 nF, luego 0,01 μF = 0,01 × 1000 = 10 nF (que son 10.000 pF). Los 1 nF equivalen a 0,001 μF; los 100 nF, a 0,1 μF; y los 10 pF son mil veces menos que 10 nF, error típico al confundir nano y pico. Se pasa de un prefijo al contiguo multiplicando o dividiendo por 1000. _(Véase tema T1, sección «Unidades y leyes fundamentales».)_
#_apc1-noest[Prefijos del SI: tera (T) $10^12$, giga (G) $10^9$, mega (M) $10^6$, kilo (k) $10^3$, mili (m) $10^(-3)$, micro (μ) $10^(-6)$, nano (n) $10^(-9)$ y pico (p) $10^(-12)$. Entre prefijos contiguos la relación es 1000: 1 μF = 1000 nF = 1.000.000 pF. Así, 0,01 μF = 10 nF = 10.000 pF.]],
)

#q("F-T1.16", "c",
  [Una frecuencia de 144,5 MHz expresada en kilohercios es:],
  ([14 450 kHz], [144 500 000 kHz], [144 500 kHz], [0,1445 kHz]),
  sol: [El prefijo mega vale $10^6$ y kilo vale $10^3$, luego 1 MHz = 1000 kHz. Se multiplica por 1000: 144,5 × 1000 = 144 500 kHz, es decir, la coma se corre tres lugares a la derecha. La cifra 144 500 000 es el valor en hercios, no en kHz. Dividir en lugar de multiplicar da 0,1445, que son los gigahercios (0,1445 GHz), no los kHz. La opción de 14 450 desplaza mal la coma. _(Véase tema T1, sección «Unidades y leyes fundamentales».)_
#_apc1-noest[Prefijos del SI habituales en radio: giga (G) = $10^9$, mega (M) = $10^6$, kilo (k) = $10^3$, mili (m) = $10^(-3)$, micro (μ) = $10^(-6)$, nano (n) = $10^(-9)$ y pico (p) = $10^(-12)$. Entre prefijos vecinos hay un factor 1000: 1 GHz = 1000 MHz = $10^6$ kHz; 0,01 μF = 10 nF = 10 000 pF; 10 mA = 0,01 A. A una unidad menor le corresponde un número mayor.]],
)

#q("F-T1.17", "d",
  [Un transmisor de FM con una desviación máxima de 5 kHz se modula con un tono de 3 kHz. Según la regla de Carson, la anchura de banda que ocupa es aproximadamente de:],
  ([6 kHz], [8 kHz], [10 kHz], [16 kHz]),
  sol: [Regla de Carson: $B approx 2(Delta f + f_m)$. Con $Delta f = 5$ kHz y $f_m = 3$ kHz: $B approx 2 (5 + 3) = 16$ kHz (el índice de modulación es $m = Delta f slash f_m approx 1,7$). Los 6 kHz son $2 f_m$, lo que ocuparía una AM con ese tono. Los 8 kHz olvidan el factor 2, pues la señal se extiende a ambos lados de la portadora. Los 10 kHz son $2 Delta f$ y se olvidan de la frecuencia moduladora. _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.18", "a",
  [La forma de onda de una portadora modulada en frecuencia se caracteriza porque:],
  ([su amplitud es constante y lo que varía es el espaciado de los ciclos (la frecuencia instantánea)], [su envolvente reproduce la señal moduladora], [aparecen y desaparecen trenes de portadora al ritmo del mensaje], [su amplitud es la suma de la portadora y de la señal moduladora]),
  sol: [En FM la información va en la frecuencia instantánea: los ciclos se juntan y se separan al ritmo de la moduladora, pero la amplitud no cambia y la envolvente es una línea recta. Una envolvente que copia la moduladora es la de la AM. Los trenes de portadora que aparecen y desaparecen son telegrafía (CW). Y sumar moduladora y portadora solo superpone ambas señales, sin modulación alguna. _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.19", "b",
  [Una emisión de telegrafía manual A1A, vista en un osciloscopio, consiste en:],
  ([una portadora cuya amplitud sigue la voz del operador], [trenes de portadora de amplitud constante que aparecen y desaparecen al ritmo de la manipulación], [una portadora que alterna entre dos frecuencias distintas], [una portadora de frecuencia variable y amplitud constante, sin interrupciones]),
  sol: [En A1A (CW) no hay moduladora analógica: se conecta y desconecta la portadora al ritmo del código Morse. En pantalla se ven trenes de portadora de amplitud constante (cortos para los puntos, largos para las rayas) separados por silencios. Una amplitud que sigue la voz es AM; dos frecuencias que se alternan son FSK; una portadora continua de frecuencia variable es FM. Los flancos se redondean para evitar chasquidos (_key clicks_). _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.20", "c",
  [En el osciloscopio, la envolvente de una portadora de AM con un índice de modulación inferior al 100 % se reconoce porque:],
  ([es constante, sin variaciones], [llega justo a cero en los mínimos de la moduladora], [copia la moduladora sin llegar nunca a anularse], [se recorta y deja tramos sin portadora en los valles]),
  sol: [Con $m < 1$ la amplitud oscila entre $A_"máx"$ y $A_"mín" > 0$, siendo $m = (A_"máx" - A_"mín") slash (A_"máx" + A_"mín")$: la envolvente es una réplica de la moduladora que nunca toca el eje. Una envolvente constante es una portadora sin modular. Si llega justo a cero, $m = 1$ (100 %). Si se recorta y aparecen tramos sin portadora hay sobremodulación ($m > 1$), con distorsión y _splatter_. _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.21", "d",
  [Una portadora de 3,700 MHz modulada en AM por un tono de 1 kHz produce un espectro con rayas en:],
  ([3,690, 3,700 y 3,710 MHz], [3,699 y 3,701 MHz solamente], [3,700 y 3,701 MHz], [3,699, 3,700 y 3,701 MHz]),
  sol: [El espectro de una AM tiene tres rayas: la portadora y dos bandas laterales en $f_c plus.minus f_m$. Aquí $f_m = 1$ kHz = 0,001 MHz, luego 3,700 − 0,001 = 3,699 MHz y 3,700 + 0,001 = 3,701 MHz, además de la portadora en 3,700 MHz. Con 3,690 y 3,710 MHz se confunde 1 kHz con 10 kHz. Sin portadora sería doble banda con portadora suprimida, no AM. Portadora más una sola banda se parece a la SSB con portadora, no a la AM. _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.22", "a",
  [El espectro de una emisión J3E en banda lateral superior (USB), con la portadora suprimida, contiene:],
  ([solo componentes por encima de la frecuencia de la portadora suprimida], [solo componentes por debajo de la frecuencia de la portadora suprimida], [una raya central, la portadora, y dos bandas laterales], [una única raya exactamente en la frecuencia de la portadora]),
  sol: [J3E es telefonía en banda lateral única con portadora suprimida. En USB se transmite la banda lateral superior, que se extiende desde $f_c$ hasta unos 3 kHz por encima (la anchura de voz ronda los 2,7 kHz): todo el espectro queda por encima de la frecuencia de la portadora suprimida. Por debajo quedaría la LSB. Una portadora con dos bandas laterales es una AM. Una sola raya en $f_c$ sería la portadora sin modular. _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.23", "b",
  [El espectro de una emisión de FM con un índice de modulación elevado presenta:],
  ([solo dos bandas laterales, como la AM], [numerosas bandas laterales separadas entre sí una distancia igual a la frecuencia moduladora], [una única banda lateral, sin portadora], [únicamente la portadora, sin bandas laterales]),
  sol: [Una portadora modulada en frecuencia genera bandas laterales en $f_c plus.minus n f_m$ ($n = 1, 2, 3, dots$), con amplitudes que siguen las funciones de Bessel. Cuanto mayor es $m = Delta f slash f_m$, más bandas son significativas y más ancho es el espectro, aproximadamente $2(Delta f + f_m)$ (regla de Carson). Solo con un índice muy bajo la FM se parece a la AM, con dos bandas. Una sola banda sin portadora es SSB. La portadora sola no transporta información. _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.24", "c",
  [En la modulación FSK, la información digital se transmite variando:],
  ([la amplitud de la portadora entre dos niveles], [solo la fase de la portadora], [la frecuencia de la portadora entre valores discretos], [la amplitud y la fase de la portadora a la vez]),
  sol: [FSK (_Frequency Shift Keying_) asigna a cada símbolo una frecuencia distinta: en el RTTY de aficionado, por ejemplo, una para «marca» y otra para «espacio», separadas 170 Hz. Variar la amplitud entre dos niveles es ASK. Variar solo la fase es PSK, como en PSK31. Variar amplitud y fase a la vez es QAM. _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.25", "d",
  [En la modulación 2PSK cada bit se representa mediante:],
  ([una de dos frecuencias distintas], [una de dos amplitudes distintas], [una de cuatro fases distintas], [una de dos fases de la portadora, por ejemplo 0° y 180°]),
  sol: [2PSK (o BPSK) emplea dos fases, normalmente 0° y 180°: un bit por símbolo. Dos frecuencias sería 2FSK. Dos amplitudes, ASK. Cuatro fases es 4PSK, donde cada símbolo lleva 2 bits. En general, con $M$ fases cada símbolo transporta $log_2 M$ bits, y por eso el número que precede a PSK indica cuántas fases se usan. _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.26", "a",
  [La modulación QAM se caracteriza porque la información digital se transmite variando:],
  ([la amplitud y la fase de la portadora a la vez], [solo la frecuencia de la portadora], [solo la amplitud de la portadora], [solo la fase de la portadora]),
  sol: [QAM (_Quadrature Amplitude Modulation_, modulación de amplitud en cuadratura) combina amplitud y fase: cada símbolo es un punto distinto de una «constelación». Con 16 puntos (16-QAM), cada símbolo lleva 4 bits. Variar solo la frecuencia es FSK, solo la amplitud es ASK y solo la fase es PSK. Por eso QAM transporta más bits por símbolo, y más velocidad binaria en el mismo ancho de banda. _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.27", "b",
  [Una modulación 4PSK transporta 2 bits por símbolo. Si la velocidad de símbolo es de 1200 baudios, la velocidad binaria es de:],
  ([600 bit/s], [2400 bit/s], [1200 bit/s], [4800 bit/s]),
  sol: [El baudio es un símbolo por segundo. La velocidad binaria es la de símbolo por los bits de cada símbolo: 1200 × 2 = 2400 bit/s. Los 1200 bit/s confunden baudios con bit/s, que solo coinciden si cada símbolo lleva 1 bit. Los 600 bit/s salen de dividir en lugar de multiplicar. Los 4800 bit/s multiplican por el número de estados ($M = 4$) en lugar de por los bits por símbolo ($log_2 4 = 2$). _(Véase tema T1, sección «Señales moduladas».)_
#_apc1-noest[Baudio: unidad de velocidad de símbolo, un símbolo por segundo. La velocidad binaria (bit/s) es la velocidad de símbolo (baudios) por los bits de cada símbolo, $log_2 M$. Solo coinciden si cada símbolo lleva 1 bit (2PSK, 2FSK). Ejemplos: 4PSK (2 bits por símbolo) a 1200 baudios da 2400 bit/s; 16-QAM (4 bits por símbolo) a 1200 baudios da 4800 bit/s. La anchura de banda depende de los baudios, no de los bit/s.]],
)

#q("F-T1.28", "c",
  [Cada símbolo de una modulación 16-QAM transporta un número de bits igual a:],
  ([16], [8], [4], [2]),
  sol: [Con $M = 16$ estados posibles, los bits por símbolo son $log_2 16 = 4$, porque $2^4 = 16$. El 16 es el número de estados, no de bits. El 8 sale de dividir $M$ entre 2, un error de cálculo típico. El 2 son los bits de un símbolo de 4PSK ($log_2 4 = 2$). A igual velocidad de símbolo, 16-QAM da el doble de velocidad binaria que 4PSK. _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.29", "d",
  [Al pasar de 2PSK a 4PSK manteniendo la misma velocidad de símbolo:],
  ([se duplican la velocidad binaria y la anchura de banda], [la velocidad binaria no cambia y la anchura de banda se reduce a la mitad], [la velocidad binaria se reduce a la mitad], [se duplica la velocidad binaria sin aumentar la anchura de banda]),
  sol: [La anchura de banda la fija la velocidad de símbolo, no la de bit. Con 2PSK cada símbolo lleva $log_2 2 = 1$ bit y con 4PSK lleva $log_2 4 = 2$ bits. A igual velocidad de símbolo, la velocidad binaria se duplica y el espectro ocupado es prácticamente el mismo. Por eso se usan más estados (4PSK, QAM) para ganar velocidad sin pedir más espectro; el precio es necesitar mejor relación señal/ruido. _(Véase tema T1, sección «Señales moduladas».)_],
)

#q("F-T1.30", "a",
  [En una transmisión digital, la diferencia esencial entre el CRC y el FEC es que:],
  ([el CRC solo detecta errores; el FEC añade redundancia para corregirlos sin retransmisión], [el CRC corrige errores sin retransmisión; el FEC solo sirve para detectarlos], [el CRC se usa en modulación analógica; el FEC, únicamente en modulación digital], [ambos corrigen errores, pero el FEC no añade bits redundantes a los datos]),
  sol: [El CRC es un código calculado sobre los datos: el receptor lo recalcula y, si no coincide, sabe que hubo error (no dónde), de modo que hay que pedir la repetición. El FEC (_Forward Error Correction_) añade redundancia suficiente para que el receptor corrija por sí mismo, sin retransmisión, a costa de una menor velocidad útil. Ambos son técnicas digitales y ambos exigen añadir bits. _(Véase tema T1, sección «Señales moduladas».)_
#_apc1-noest[Para combatir los errores de una transmisión digital se añaden bits redundantes. Con CRC (comprobación de redundancia cíclica) el emisor añade un código calculado sobre el bloque; el receptor lo recalcula y, si no coincide, descarta el bloque y puede pedir su repetición. Con FEC (corrección directa de errores) la redundancia es mayor y el receptor corrige sin retransmisión, útil en enlaces con mucho retardo o de un sentido; FT8 combina ambos. La redundancia reduce la velocidad útil.]],
)

#q("F-T1.31", "b",
  [En una transmisión digital, la diferencia entre la detección de errores (CRC) y la corrección directa (FEC) es que:],
  ([el CRC corrige los errores del bloque y la FEC solo avisa de que existen], [el CRC permite detectar que un bloque ha llegado con errores, y la FEC corregirlos sin pedir retransmisión], [la FEC exige siempre retransmitir el bloque y el CRC nunca], [el CRC añade bits de redundancia al mensaje y la FEC no necesita añadir ninguno]),
  sol: [El CRC es un código de comprobación calculado con los bits del bloque: si el receptor obtiene otro distinto, sabe que hubo errores, pero no cuáles; lo habitual es pedir que se repita el bloque. La FEC añade redundancia suficiente para que el receptor reconstruya por sí mismo los datos dañados, sin retransmisión. La opción a está invertida y la c dice lo contrario de lo que aporta la FEC, que precisamente evita repetir. La d es falsa: tanto el CRC como la FEC añaden bits redundantes (la FEC, muchos más). _(Véase tema T1, sección «Señales moduladas».)_

#_apc1-noest[Dos formas de proteger los datos digitales, ambas con bits redundantes que añade el emisor. El CRC (comprobación de redundancia cíclica) es un código calculado con los bits del bloque: si el receptor obtiene otro distinto, sabe que hubo errores, pero no puede repararlos; lo habitual es pedir que se repita el bloque. La FEC (_forward error correction_) añade redundancia suficiente para que el receptor corrija por sí mismo los errores, sin retransmisión, al precio de una menor velocidad de información útil.]],
)

#q("F-T1.32", "a",
  [Al añadir FEC a una transmisión digital sin cambiar la velocidad de bits por el canal, la velocidad de información útil:],
  ([disminuye, porque parte de los bits transmitidos son de redundancia], [aumenta, porque el receptor corrige los errores], [no varía: la FEC solo modifica los bits que llegan erróneos], [se reduce únicamente cuando hay errores que corregir]),
  sol: [Con FEC el emisor añade bits de redundancia a los datos; por ejemplo, 3 bits enviados por cada 2 de información. Esos bits ocupan el canal, así que, con la misma velocidad de bits, la velocidad de información útil baja (aquí a 2/3). A cambio, el receptor corrige errores y la transmisión aguanta mejor el ruido. Corregir errores no crea capacidad: cada bit enviado lleva menos información (b y c). La redundancia se envía siempre, haya o no errores, de modo que la d también es falsa. _(Véase tema T1, sección «Señales moduladas».)_
#_apc1-noest[La FEC tiene un precio: los bits de redundancia ocupan el canal. Se mide con la tasa de código $k slash n$: de cada $n$ bits transmitidos, solo $k$ son de información ($n > k$). Si la velocidad de bits por el canal no cambia, la velocidad de información útil se reduce en ese factor, siempre, haya o no errores. A cambio, el receptor corrige los errores por sí mismo y la transmisión resiste señales más débiles y ruidosas.]],
)

#q("F-T1.33", "c",
  [Un osciloscopio mide 200 V de pico a pico en una señal sinusoidal aplicada a una carga artificial de 50 Ω. La potencia disipada es de:],
  ([50 W], [200 W], [100 W], [400 W]),
  sol: [Pico a pico es el doble del pico: $V_p = 200 slash 2 = 100$ V. El valor eficaz es $V_"ef" = V_p slash sqrt(2) = 70,7$ V y $P = V_"ef"^2 slash R = 5000 slash 50 = 100$ W (equivale a $V_p^2 slash 2R$). Los 200 W salen de usar el pico como si fuera eficaz ($V_p^2 slash R$); los 400 W, de aplicar $V^2 slash 2R$ a los 200 V pico a pico; y los 50 W, de tomar como eficaz la cuarta parte de la tensión pico a pico. _(Véase tema T1, secciones «Unidades y leyes fundamentales» y «Ondas y señales».)_
#_apc1-noest[El valor pico a pico de una sinusoide es la distancia entre su máximo positivo y su máximo negativo: el doble del valor de pico, $V_(p p) = 2 V_p$. Para calcular la potencia que disipa una resistencia $R$ hay que pasar siempre a valor eficaz: $V_"ef" = V_p slash sqrt(2)$ y $P = V_"ef"^2 slash R = V_p^2 slash 2R$. Con 100 V de pico sobre 50 Ω, $P = 100$ W.]],
)

#q("F-T1.34", "b",
  [Una señal sinusoidal disipa 200 W en una carga de 50 Ω. Su tensión eficaz es de:],
  ([70,7 V], [100 V], [141 V], [283 V]),
  sol: [De $P = V^2 slash R$ se despeja $V = sqrt(P R) = sqrt(200 dot 50) = sqrt(10000) = 100$ V eficaces. Los demás valores son errores de conversión: 141 V es el valor de pico ($100 sqrt(2)$), 283 V el pico a pico (el doble del pico) y 70,7 V resulta de dividir entre $sqrt(2)$ una tensión que ya era eficaz. _(Véase tema T1, secciones «Unidades y leyes fundamentales» y «Ondas y señales».)_],
)

#q("F-T1.35", "d",
  [Una señal sinusoidal de 10 V de pico se aplica a una resistencia de 100 Ω. La potencia que disipa es de:],
  ([1 W], [2 W], [0,25 W], [0,5 W]),
  sol: [La potencia depende del valor eficaz: $V_"ef" = 10 slash sqrt(2) = 7,07$ V y $P = V_"ef"^2 slash R = 50 slash 100 = 0,5$ W (equivale a $V_p^2 slash 2R$). Se obtiene 1 W si se usa el pico como si fuera eficaz ($10^2 slash 100$); 2 W, si se multiplica por $sqrt(2)$ en lugar de dividir; y 0,25 W, si se divide la tensión entre 2 en lugar de entre $sqrt(2)$. _(Véase tema T1, secciones «Unidades y leyes fundamentales» y «Ondas y señales».)_],
)

#q("F-T1.36", "a",
  [Un preamplificador de 15 dB de ganancia alimenta un cable que pierde 3 dB, y este a un amplificador de 10 dB. La ganancia total del conjunto es de:],
  ([22 dB], [28 dB], [25 dB], [12 dB]),
  sol: [Las ganancias y las pérdidas en decibelios se suman y restan: 15 − 3 + 10 = 22 dB. Los 28 dB salen de sumar también la pérdida del cable, como si fuera ganancia; los 25 dB, de olvidar el cable; y los 12 dB, de olvidar el amplificador (15 − 3). Por eso con decibelios el balance de una cadena se reduce a sumas y restas, sin multiplicar relaciones de potencia. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_],
)

#q("F-T1.37", "d",
  [Un transmisor entrega 10 W a un cable coaxial que atenúa 3 dB. La potencia que llega a la antena es aproximadamente de:],
  ([7 W], [3,3 W], [2,5 W], [5 W]),
  sol: [Una pérdida de 3 dB divide la potencia entre 2 (al revés que una ganancia de +3 dB, que la duplica): $P = 10 slash 2 = 5$ W. Con la fórmula, $P_2 = 10 dot 10^(-3 slash 10) approx 5$ W. Los 7 W resultan de restar 3 W a 10 W, cuando los decibelios no se restan de los vatios; los 3,3 W, de dividir entre 3; y los 2,5 W corresponderían a una pérdida de 6 dB. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_],
)

#q("F-T1.38", "c",
  [A un amplificador de 10 dB de ganancia se aplican 2 W y su salida pasa por un atenuador de 6 dB. La potencia final es aproximadamente de:],
  ([20 W], [0,5 W], [5 W], [8 W]),
  sol: [Balance neto: +10 − 6 = +4 dB. Como +10 dB multiplican la potencia por 10 y −6 dB la dividen entre 4, $P = 2 dot 10 slash 4 = 5$ W (con la fórmula, $2 dot 10^(0,4) approx 5$ W). Los 20 W ignoran el atenuador; los 0,5 W, el amplificador (2/4); y los 8 W toman los +4 dB como si fueran ×4, cuando equivalen a multiplicar por unos 2,5. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_],
)

#q("F-T1.39", "b",
  [Un amplificador consume 200 W de la fuente de alimentación y entrega 120 W de RF. Su rendimiento es del:],
  ([40 %], [60 %], [120 %], [167 %]),
  sol: [El rendimiento es la relación entre la potencia de salida útil y la consumida: $eta = P_"sal" slash P_"cc" = 120 slash 200 = 0,6 = 60$ %. El 40 % es la fracción que se pierde en calor (80/200); el 167 % sale de invertir el cociente (200/120). Un rendimiento superior al 100 % es imposible, porque el amplificador entregaría más potencia de la que consume. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_],
)

#q("F-T1.40", "c",
  [Un amplificador entrega 50 W de RF con un rendimiento del 40 %. La potencia que se disipa en forma de calor es de:],
  ([20 W], [50 W], [75 W], [125 W]),
  sol: [De $eta = P_"sal" slash P_"cc"$ se obtiene la potencia consumida: $P_"cc" = 50 slash 0,4 = 125$ W. Lo que no sale como RF se convierte en calor: 125 − 50 = 75 W. Los 125 W son el consumo total, no el calor; los 50 W son la potencia útil; y los 20 W resultan de multiplicar $0,4 dot 50$ en lugar de dividir. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_],
)

#q("F-T1.41", "d",
  [Un transmisor de AM con 25 W de potencia de portadora se modula al 100 %. Su potencia en la cresta de la envolvente (p.c.e.) es de:],
  ([25 W], [37,5 W], [50 W], [100 W]),
  sol: [Al 100 % de modulación, en la cresta de la envolvente la tensión de pico se duplica y, como la potencia va con el cuadrado de la tensión, se multiplica por cuatro: 4 · 25 = 100 W. Los 25 W son la potencia de portadora, sin modulación; los 37,5 W, la potencia media con modulación al 100 % ($1,5 P_c$); y los 50 W resultarían de duplicar la potencia en lugar de la tensión. _(Véase tema T5, sección «Emisiones no deseadas».)_],
)

#q("F-T1.42", "a",
  [Un conversor A/D muestrea una señal a 8 kHz. La frecuencia máxima de la señal que se puede digitalizar sin aliasing es de:],
  ([4 kHz], [8 kHz], [16 kHz], [2 kHz]),
  sol: [El teorema de Nyquist exige $f_s >= 2 f_"máx"$, luego $f_"máx" <= f_s slash 2 = 8 slash 2 = 4$ kHz. Lo que supere los 4 kHz se plegaría sobre la banda útil (_aliasing_). Los 8 kHz confunden la frecuencia de muestreo con la máxima de la señal; los 16 kHz aplican el factor 2 en sentido contrario (es el muestreo el que debe ser el doble, no la señal); y los 2 kHz dividen entre 2 dos veces. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_],
)

#q("F-T1.43", "b",
  [Si una señal se muestrea a una frecuencia inferior al doble de su frecuencia máxima, se produce:],
  ([un ruido de cuantificación mayor, que desaparece empleando más bits por muestra], [aliasing: las componentes de frecuencia alta se confunden con otras más bajas y ya no pueden distinguirse de ellas], [la pérdida de las componentes más altas, que simplemente se cortan sin afectar al resto de la señal], [una distorsión que elimina después el filtro de reconstrucción]),
  sol: [Con $f_s < 2 f_"máx"$ faltan muestras para fijar las componentes más altas: los mismos puntos encajan en una sinusoide de frecuencia más baja, y esas componentes aparecen «disfrazadas» de bajas (_aliasing_), mezcladas con la señal útil. Ya no hay forma de separarlas, ni con más bits de cuantificación (a) ni con el filtro de reconstrucción (d), que actúa después del D/A. Tampoco se cortan limpiamente (c): se pliegan sobre la banda. Se previene con un filtro antisolapamiento antes del A/D. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_],
)

#q("F-T1.44", "c",
  [Un conversor analógico-digital de 10 bits cuantifica cada muestra en uno de:],
  ([10 niveles], [20 niveles], [1024 niveles], [100 niveles]),
  sol: [Con $n$ bits se forman $2^n$ combinaciones distintas y cada una es un nivel de cuantificación: $2^10 = 1024$ niveles. Cada bit añadido duplica el número de niveles y mejora unos 6 dB la relación señal/ruido de cuantificación. Los 10, 20 y 100 niveles son los errores típicos de tomar $n$, $2n$ o $n^2$ en lugar de $2^n$. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_],
)

#q("F-T1.45", "d",
  [El filtro antisolapamiento (anti-aliasing) de un sistema de procesado digital de señales se coloca:],
  ([después del conversor A/D, y es un filtro paso bajo], [antes del conversor A/D, y es un filtro paso alto], [después del conversor D/A, y es un filtro paso bajo], [antes del conversor A/D, y es un filtro paso bajo]),
  sol: [Lo que supere $f_s slash 2$ se plegaría sobre la banda útil al muestrear (_aliasing_) y, ya digitalizado, no se puede separar. Hay que eliminarlo antes del muestreo: el filtro antisolapamiento va delante del A/D y es paso bajo, con corte en torno a $f_s slash 2$. Un paso alto dejaría justo lo que hay que quitar. El filtro situado tras el D/A es el de reconstrucción: también paso bajo, pero elimina las réplicas del espectro y suaviza los escalones de la señal de salida. Es otro filtro, con otra función. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_
#_apc1-noest[En un sistema con DSP hay dos filtros paso bajo. El antisolapamiento va justo antes del conversor A/D: elimina lo que supera $f_s slash 2$, que al muestrear se confundiría con frecuencias bajas y no podría separarse después. El de reconstrucción va tras el conversor D/A: suaviza los escalones de la señal reconstruida y elimina las réplicas del espectro por encima de $f_s slash 2$. Ambos cortan en torno a $f_s slash 2$.]],
)

#q("F-T1.46", "b",
  [En un sistema de procesado digital de señales, el filtro antisolapamiento (anti-aliasing) se coloca:],
  ([antes del conversor A/D y es un filtro paso alto], [antes del conversor A/D y es un filtro paso bajo, con corte en torno a $f_s slash 2$], [después del conversor A/D y es un filtro paso bajo], [después del conversor D/A y es un filtro paso alto]),
  sol: [Las componentes de la señal por encima de $f_s slash 2$ no se pueden muestrear bien: al muestrear se «doblan» hacia frecuencias más bajas (_aliasing_) y ya no se distinguen de la señal útil. Por eso hay que eliminarlas antes, con un filtro paso bajo de corte próximo a $f_s slash 2$ a la entrada del A/D. Después del A/D el daño ya está hecho (c). Un paso alto (a, d) quitaría justo las frecuencias bajas que interesan. El filtro que sigue al D/A es el de reconstrucción, y también es paso bajo. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_
#_apc1-noest[El filtro antisolapamiento es un filtro paso bajo situado justo antes del conversor A/D: deja pasar la señal útil y elimina lo que supere $f_s slash 2$ (la frecuencia de Nyquist), porque esas componentes, una vez muestreadas, se confundirían con frecuencias más bajas y ya no se podrían separar. Por eso se filtra siempre antes de muestrear, nunca después.]],
)

#q("F-T1.47", "c",
  [El filtro de reconstrucción de un sistema digital se sitúa a la salida del conversor D/A y sirve para:],
  ([amplificar las muestras hasta el nivel que necesita la carga], [aumentar la frecuencia de muestreo de la señal], [suavizar la señal escalonada, eliminando las componentes de alta frecuencia que introduce el muestreo], [eliminar la componente continua que deja la conversión]),
  sol: [El D/A entrega una señal en escalones (mantiene cada muestra hasta la siguiente), y esos escalones llevan componentes de alta frecuencia: réplicas del espectro en torno a $f_s$, $2 f_s$, etc. Un filtro paso bajo las elimina y deja la señal analógica continua, por ejemplo el audio. No amplifica (a), no cambia la frecuencia de muestreo, que es cosa del procesador (b), y no se ocupa de la componente continua (d). _(Véase tema T1, sección «Potencia, decibelios y DSP».)_

#_apc1-noest[La salida de un conversor D/A es una señal en escalones: mantiene cada muestra hasta la siguiente, y esos escalones llevan componentes de alta frecuencia (réplicas de la señal en torno a $f_s$, $2 f_s$, etc.). El filtro de reconstrucción es un filtro paso bajo a la salida del D/A: elimina esas componentes y deja la señal analógica suave, por ejemplo el audio que llega al altavoz.]],
)

#q("F-T1.48", "a",
  [Un conversor analógico-digital (A/D) convierte:],
  ([una señal analógica en una secuencia de números binarios], [una secuencia de números binarios en una señal analógica], [una señal de RF en una señal de frecuencia intermedia], [una corriente alterna en corriente continua]),
  sol: [El A/D muestrea la señal analógica y cuantifica cada muestra en un código binario de $n$ bits, es decir, en uno de $2^n$ niveles. La operación inversa (b) la hace el conversor D/A. Pasar de RF a FI es tarea de un mezclador (c), y de alterna a continua, de un rectificador (d): ninguno de los dos convierte la señal en números. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_],
)

#q("F-T1.49", "d",
  [En la cadena de recepción de un receptor con DSP, el conversor D/A sirve para:],
  ([digitalizar la señal captada por la antena], [amplificar el audio hasta la potencia que necesita el altavoz], [eliminar el ruido impulsivo de la señal recibida], [convertir en señal analógica las muestras ya procesadas, por ejemplo el audio]),
  sol: [Un receptor con DSP digitaliza la señal (A/D), la filtra y la demodula como números y, al final, tiene que volver al dominio analógico para poder oírla: eso lo hace el D/A, que convierte las muestras del audio en una tensión analógica. Digitalizar es cosa del A/D (a). Amplificar hasta la potencia del altavoz lo hace el amplificador de audio (b). Reducir el ruido impulsivo lo hacen algoritmos del DSP o el _noise blanker_ (c). _(Véase tema T1, sección «Potencia, decibelios y DSP».)_

#_apc1-noest[En un equipo con DSP la señal se digitaliza en un conversor A/D, se procesa como números (filtrado, demodulación) y, para poder oírla, vuelve al dominio analógico en un conversor D/A: convierte la secuencia de muestras en una tensión analógica que, tras el filtro de reconstrucción y el amplificador de audio, mueve el altavoz. El D/A hace lo inverso del A/D.]],
)

#q("F-T1.50", "c",
  [La ley de Kirchhoff de las corrientes (ley de los nudos) establece que, en un nudo de un circuito:],
  ([la suma de las tensiones de las ramas que concurren en él es cero], [la corriente total es el producto de las corrientes de cada rama], [la suma de las corrientes que entran es igual a la suma de las que salen], [sale siempre menos corriente de la que entra, porque parte se pierde en calor]),
  sol: [Es la conservación de la carga: en un nudo no se acumula carga, luego la corriente total que llega es igual a la que sale (o, con signos, la suma algebraica es cero). En el nudo no hay pérdidas (d). La suma de tensiones igual a cero es la ley de las mallas (a), no la de los nudos. Y las corrientes de las ramas se suman, no se multiplican (b). _(Véase tema T1, sección «Unidades y leyes fundamentales».)_],
)

#q("F-T1.51", "b",
  [A un nudo llegan dos corrientes, de 3 A y de 2 A, y salen otras dos: una de 1,5 A y otra de valor $I$. El valor de $I$ es:],
  ([0,5 A], [3,5 A], [5 A], [6,5 A]),
  sol: [Ley de los nudos: lo que entra es igual a lo que sale. Entran 3 + 2 = 5 A y salen $1,5 + I$, luego $I = 5 - 1,5 = 3,5$ A. Los 6,5 A suman las tres corrientes conocidas (3 + 2 + 1,5). Los 5 A olvidan restar la salida de 1,5 A. Los 0,5 A salen de restar mal ($3 - 2 - 1,5 = -0,5$ y quitar el signo). _(Véase tema T1, sección «Unidades y leyes fundamentales».)_],
)

#q("F-T1.52", "a",
  [Una batería de 12 V alimenta tres resistencias en serie (resistencia interna despreciable). Si en dos de ellas caen 3 V y 5 V, en la tercera cae:],
  ([4 V], [7 V], [8 V], [20 V]),
  sol: [Ley de las mallas: la suma de las caídas de tensión a lo largo de la malla es igual a la fem de la batería, $12 = 3 + 5 + V_3$. Luego $V_3 = 12 - 8 = 4$ V. Los 8 V son la suma de las dos caídas conocidas. Los 7 V resultan de restar solo una de ellas (12 − 5). Los 20 V suman las tres cantidades (12 + 3 + 5). _(Véase tema T1, sección «Unidades y leyes fundamentales».)_],
)

#q("F-T1.53", "d",
  [La energía eléctrica consumida por una estufa de 2 kW que funciona durante 3 horas es de:],
  ([1,5 kWh], [5 kWh], [6 kW], [6 kWh]),
  sol: [La energía es potencia por tiempo: $E = P dot t = 2 "kW" times 3 "h" = 6 "kWh"$. Los «6 kW» serían una potencia, no una energía: es el error de unidades. Los 5 kWh suman (2 + 3) en lugar de multiplicar. Los 1,5 kWh dividen (3/2) en lugar de multiplicar. _(Véase tema T1, sección «Unidades y leyes fundamentales».)_

#_apc1-noest[La energía eléctrica es potencia por tiempo: $E = P dot t$. En el Sistema Internacional se mide en julios (1 J = 1 W·s), pero en la práctica se usan el vatio-hora (1 Wh = 3600 J) y el kilovatio-hora (1 kWh = 1000 Wh = 3,6 MJ), que es lo que factura la compañía eléctrica. No hay que confundir el kilovatio (potencia) con el kilovatio-hora (energía).]],
)

#q("F-T1.54", "b",
  [El julio, unidad de energía, equivale a:],
  ([un vatio dividido por un segundo], [un vatio multiplicado por un segundo], [un voltio multiplicado por un segundo], [un amperio multiplicado por un segundo]),
  sol: [De $P = W slash t$ se despeja la energía, $W = P dot t$: un vatio durante un segundo es un julio, 1 J = 1 W · s. Dividir por el tiempo (a) no da una energía. El voltio por segundo (c) no es una energía. El amperio por segundo (d) es un culombio, es decir, una carga. _(Véase tema T1, sección «Unidades y leyes fundamentales».)_

#_apc1-noest[La tensión es energía por carga y la potencia es energía por tiempo, $P = W slash t$. Despejando, la energía es $W = P dot t$. Por eso el julio, unidad de energía del Sistema Internacional, es un vatio durante un segundo: 1 J = 1 W · s. Como 1 h son 3600 s, un vatio-hora equivale a 3600 J.]],
)

#q("F-T1.55", "a",
  [Un equipo que consume 100 W permanece conectado 30 minutos. La energía que ha consumido es de:],
  ([50 Wh], [100 Wh], [200 Wh], [3000 Wh]),
  sol: [Hay que pasar los minutos a horas: 30 min son 0,5 h. Entonces $E = P dot t = 100 "W" times 0,5 "h" = 50 "Wh"$ (0,05 kWh). Los 100 Wh corresponderían a una hora entera. Los 200 Wh dividen entre 0,5 en lugar de multiplicar. Los 3000 Wh usan 30 como si fueran horas (100 × 30). _(Véase tema T1, sección «Unidades y leyes fundamentales».)_

#_apc1-noest[Energía = potencia × tiempo, $E = P dot t$, con el tiempo en horas si se quiere el resultado en vatios-hora (Wh). Antes hay que pasar los minutos a horas (30 min = 0,5 h). En una batería, la energía almacenada es la tensión por la capacidad: 12 V × 7 Ah = 84 Wh.]],
)

#q("F-T1.56", "b",
  [Una batería de 12 V de fuerza electromotriz y 0,5 Ω de resistencia interna entrega 4 A a una carga. La tensión en sus terminales es de:],
  ([8 V], [10 V], [12 V], [14 V]),
  sol: [La resistencia interna provoca una caída $I r = 4 times 0,5 = 2$ V dentro de la propia batería, y en los terminales queda $V = epsilon - I r = 12 - 2 = 10$ V. Los 12 V solo se miden en circuito abierto. Los 14 V suman la caída en lugar de restarla. Los 8 V restan $I = 4$ V olvidando multiplicar por $r$. _(Véase tema T1, sección «Fuentes y energía».)_],
)

#q("F-T1.57", "d",
  [La corriente de cortocircuito de una fuente de 12 V de fuerza electromotriz y 0,1 Ω de resistencia interna es de:],
  ([8,3 mA], [1,2 A], [12 A], [120 A]),
  sol: [En cortocircuito la carga es nula y solo limita la corriente la resistencia interna: $I_"cc" = epsilon slash r = 12 slash 0,1 = 120$ A. Los 8,3 mA invierten la fracción ($r slash epsilon$). Los 1,2 A multiplican en lugar de dividir. Los 12 A toman el valor numérico de $epsilon$ sin dividir por $r$ (saldrían con $r = 1$ Ω). _(Véase tema T1, sección «Fuentes y energía».)_],
)


== Tema T2. Componentes <apc1-sec-t2>

#q("F-T2.1", "c",
  [Una resistencia variable de tres terminales, con un cursor móvil entre dos extremos y empleada, por ejemplo, como control de volumen, se denomina:],
  ([varistor], [termistor NTC], [potenciómetro], [fotorresistencia]),
  sol: [El potenciómetro tiene dos terminales fijos en los extremos de la pista resistiva y un tercero unido al cursor móvil, que toma una fracción de la tensión aplicada (un divisor de tensión ajustable): por eso regula el volumen. El varistor varía con la tensión, el termistor NTC con la temperatura y la fotorresistencia con la luz, y ninguno tiene cursor. _(Véase tema T2, sección «Resistencias».)_
#_apc1-noest[El potenciómetro es una resistencia variable de tres terminales: dos en los extremos de la pista resistiva y otro unido a un cursor móvil. Según la posición del cursor toma una fracción de la tensión aplicada (divisor de tensión ajustable), y por eso se usa como control de volumen o de tono. Si solo se usan dos terminales para regular la corriente, hablamos de reóstato.]],
)

#q("F-T2.2", "d",
  [Las resistencias de hilo bobinado se emplean, frente a las de carbón, cuando se necesita:],
  ([trabajar en VHF y UHF sin efectos inductivos], [abaratar el coste en circuitos de muy baja potencia], [obtener valores de muchos megaohmios en poco espacio], [disipar potencias elevadas con buena estabilidad]),
  sol: [Una resistencia de hilo bobinado es un hilo metálico arrollado sobre un soporte cerámico: soporta mucha potencia y es muy estable con el tiempo y la temperatura. Su inconveniente es que, al ser una bobina, tiene inductancia y no sirve en RF (a). Las de carbón son más baratas y dan valores altos en poco espacio (b, c), pero disipan poca potencia. _(Véase tema T2, sección «Resistencias».)_
#_apc1-noest[Según su construcción, las resistencias fijas más comunes son: de carbón (baratas, para poca potencia), de película metálica (más estables y precisas, con poco ruido) y de hilo bobinado, un hilo metálico arrollado sobre un soporte cerámico. Estas últimas soportan mucha potencia y son muy estables, pero al ser una bobina tienen inductancia y no valen para radiofrecuencia.]],
)

#q("F-T2.3", "a",
  [Una resistencia cuyo valor óhmico depende de la luz que recibe se denomina:],
  ([fotorresistencia (LDR)], [varistor (VDR)], [termistor (NTC)], [potenciómetro]),
  sol: [La fotorresistencia o LDR (_light dependent resistor_) baja su resistencia cuando aumenta la luz que recibe. El varistor (VDR) cambia con la tensión aplicada, el termistor (NTC o PTC) con la temperatura y el potenciómetro con la posición de un cursor que se mueve a mano. _(Véase tema T2, sección «Resistencias».)_
#_apc1-noest[La fotorresistencia o LDR (_light dependent resistor_) es una resistencia cuyo valor depende de la luz que recibe: disminuye al aumentar la iluminación. Se usa en fotómetros, alarmas y automatismos de alumbrado. No hay que confundirla con el termistor (depende de la temperatura) ni con el varistor (depende de la tensión).]],
)

#q("F-T2.4", "b",
  [La reactancia inductiva de una bobina de 2 μH a 3,5 MHz es aproximadamente de:],
  ([7 Ω], [44 Ω], [440 Ω], [0,023 Ω]),
  sol: [Se aplica $X_L = 2 pi f L$: $X_L = 2 pi times 3,5 dot 10^6 times 2 dot 10^(-6) = 2 pi times 7 approx 44$ Ω. Si se olvida el $2 pi$ sale 7 Ω (a); 440 Ω (c) es un error de una potencia de diez al pasar de μH a H; y 0,023 Ω (d) es la inversa, $1/(2 pi f L)$, que no es la reactancia de una bobina. Recuerda que $X_L$ crece con la frecuencia y con la inductancia. _(Véase tema T2, sección «Bobinas», y capítulo «Cómo funciona una radio: de los campos a la voz», sección 2 (tabla de reactancias de bobina y condensador).)_],
)

#q("F-T2.5", "d",
  [En una bobina ideal recorrida por una corriente alterna sinusoidal, la tensión entre sus terminales:],
  ([está en fase con la corriente], [retrasa 90° respecto a la corriente], [está en oposición de fase (180° ) con la corriente], [adelanta 90° a la corriente]),
  sol: [Regla E-L-I: en la bobina (L) la tensión (E) va antes que la corriente (I), es decir, la tensión adelanta 90° a la corriente. Como $v = L (dif i)/(dif t)$, la tensión es máxima cuando la corriente cambia más deprisa, un cuarto de ciclo antes de que la corriente llegue a su máximo. La opción b describe el condensador (I-C-E: ahí es la corriente la que adelanta); la a solo se da en una resistencia pura; la c (180°) no corresponde a ninguna reactancia pura. _(Véase tema T2, sección «Bobinas», y capítulo «Cómo funciona una radio: de los campos a la voz», sección 2 (tabla de reactancias de bobina y condensador).)_],
)

#q("F-T2.6", "a",
  [Si se duplica la frecuencia de la corriente que recorre una bobina ideal, manteniendo su inductancia, su reactancia inductiva:],
  ([se duplica], [se reduce a la mitad], [se cuadruplica], [no varía]),
  sol: [$X_L = 2 pi f L$ es directamente proporcional a la frecuencia: con $L$ constante, al pasar de $f$ a $2 f$ la reactancia pasa de $X_L$ a $2 X_L$. Reducirse a la mitad (b) es lo que le ocurre a un condensador, cuya $X_C = 1/(2 pi f C)$ es inversamente proporcional a $f$; cuadruplicarse (c) exigiría una dependencia con $f^2$, que no existe; y no variar (d) solo vale para una resistencia pura. Por eso la bobina deja pasar la continua y frena la radiofrecuencia. _(Véase tema T2, sección «Bobinas», y capítulo «Cómo funciona una radio: de los campos a la voz», sección 2 (tabla de reactancias de bobina y condensador).)_],
)

#q("F-T2.7", "c",
  [Una bobina presenta, a su frecuencia de trabajo, una reactancia de 500 Ω y una resistencia de pérdidas, en serie, de 5 Ω. Su factor de calidad $Q$ es de:],
  ([0,01], [505], [100], [2500]),
  sol: [El factor de calidad de una bobina es el cociente entre su reactancia y su resistencia de pérdidas: $Q = X_L slash R = 500 slash 5 = 100$. El 0,01 (a) resulta de invertir el cociente; el 505 (b), de sumar las dos cantidades, lo que no tiene sentido físico; y el 2500 (d), de multiplicarlas. $Q$ no tiene unidades: cuanto menores son las pérdidas (hilo, efecto pelicular, núcleo), mayor es. _(Véase tema T2, sección «Bobinas», y capítulo «Cómo funciona una radio: de los campos a la voz», sección 2 (ejemplo $Q = 158 slash 5$); resonancia en tema T3, sección «Asociación de componentes y resonancia».)_],
)

#q("F-T2.8", "b",
  [El efecto pelicular hace que, en radiofrecuencia, la corriente alterna circule:],
  ([uniformemente por toda la sección del conductor], [principalmente por la superficie del conductor], [principalmente por el centro del conductor, dejando libre la superficie], [alternativamente por el centro y por la superficie, según el semiciclo]),
  sol: [El efecto pelicular (_skin effect_) confina la corriente alterna en una corteza superficial del conductor, cuyo espesor disminuye como $1 slash sqrt(f)$: a 10 MHz es de unas decenas de micras. El interior apenas conduce, por eso un tubo hueco sirve casi igual que una barra maciza y se platea el hilo de las bobinas de RF. La a describe la corriente continua; la c es justo lo contrario del efecto; la d no corresponde a ningún fenómeno real. _(Véase tema T2, sección «Bobinas».)_],
)

#q("F-T2.9", "d",
  [Como consecuencia del efecto pelicular, la resistencia de un conductor a frecuencias elevadas:],
  ([disminuye respecto a la que presenta en corriente continua], [no varía: depende solo del material, la longitud y la sección], [se anula a partir de cierta frecuencia], [aumenta respecto a la que presenta en corriente continua]),
  sol: [Al concentrarse la corriente en la corteza, la sección útil del conductor se reduce y su resistencia efectiva en RF crece respecto a la de continua; cuanto mayor es la frecuencia, más delgada es la corteza y mayores son las pérdidas. La a dice lo contrario; la b solo vale en continua, donde la corriente ocupa toda la sección; la c es falsa: no existen conductores de resistencia nula. Por eso se platea el hilo de las bobinas de RF. _(Véase tema T2, sección «Bobinas».)_],
)

#q("F-T2.10", "a",
  [Un transformador ideal con 1000 espiras en el primario y 100 en el secundario se conecta a la red de 230 V. Si el secundario alimenta una carga que consume 5 A, la corriente que toma el primario es de:],
  ([0,5 A], [5 A], [50 A], [0,05 A]),
  sol: [Relación de espiras $N_p slash N_s = 1000 slash 100 = 10$, luego $V_s = 230 slash 10 = 23$ V. En el transformador ideal la potencia no cambia ($V_p I_p = V_s I_s$): $P = 23 times 5 = 115$ W y $I_p = 115 slash 230 = 0,5$ A; dicho de otro modo, las corrientes van en proporción inversa a las tensiones, $I_p = I_s N_s slash N_p = 5 slash 10$. Los 50 A (c) salen de invertir la relación; los 5 A (b) ignoran el transformador; y los 0,05 A (d) dividen dos veces, aplicando el cuadrado de la relación, que vale para impedancias y no para corrientes. _(Véase tema T2, sección «Transformadores», y capítulo «La radio por dentro: componente a componente», apartado «El transformador: dos bobinas y un puente de flujo».)_],
)

#q("F-T2.11", "c",
  [Un transformador ideal debe adaptar un generador de 50 Ω, conectado al primario, a una carga de 450 Ω, conectada al secundario. La relación de espiras $N_p slash N_s$ debe ser:],
  ([9:1], [3:1], [1:3], [1:9]),
  sol: [Desde el primario, la carga del secundario se ve como $Z_p = (N_p slash N_s)^2 Z_s$. Para que valga 50 Ω con $Z_s = 450$ Ω: $(N_p slash N_s)^2 = 50 slash 450 = 1 slash 9$, luego $N_p slash N_s = 1 slash 3$ (1:3; el secundario tiene el triple de espiras). Comprobación: $(1 slash 3)^2 times 450 = 50$ Ω. La 3:1 (b) invierte la relación; la 9:1 y la 1:9 (a y d) olvidan la raíz cuadrada: la relación de impedancias es el cuadrado de la de espiras. _(Véase tema T2, sección «Transformadores», y capítulo «La radio por dentro: componente a componente», apartado «El transformador: dos bobinas y un puente de flujo».)_],
)

#q("F-T2.12", "d",
  [Un transformador ideal con una relación de espiras primario/secundario de 3:1 tiene en su secundario una carga de 8 Ω. La impedancia que presenta al generador conectado al primario es de:],
  ([24 Ω], [2,7 Ω], [0,89 Ω], [72 Ω]),
  sol: [$Z_p = (N_p slash N_s)^2 Z_s = 3^2 times 8 = 72$ Ω. La impedancia se multiplica por el cuadrado de la relación de espiras: la tensión del primario es 3 veces la del secundario y su corriente, 3 veces menor, así que $V slash I$ crece $3 times 3 = 9$ veces. Los 24 Ω (a) olvidan elevar al cuadrado; los 2,7 Ω (b) dividen entre 3 en lugar de multiplicar; y los 0,89 Ω (c) dividen entre 9. _(Véase tema T2, sección «Transformadores», y capítulo «La radio por dentro: componente a componente», apartado «El transformador: dos bobinas y un puente de flujo».)_],
)

#q("F-T2.13", "b",
  [Un balun de relación de impedancias 4:1 se construye como un transformador cuyos devanados guardan una relación de espiras de:],
  ([4:1], [2:1], [16:1], [1:1]),
  sol: [La relación de impedancias es el cuadrado de la de espiras: $Z_p slash Z_s = (N_p slash N_s)^2$. Con 4:1 en impedancias, $N_p slash N_s = sqrt(4) = 2$, es decir, 2:1 (o 1:2, según de qué lado se mire). Es el caso de adaptar 300 Ω a 75 Ω: $sqrt(300 slash 75) = 2$. La 4:1 (a) confunde ambas relaciones; la 16:1 (c) eleva al cuadrado en vez de extraer la raíz; y la 1:1 (d) es un balun que solo pasa de línea simétrica a asimétrica sin cambiar la impedancia. _(Véase tema T2, sección «Transformadores» (ejemplo 75/300 Ω y balun 4:1); tema T6, sección «Líneas de transmisión y adaptación».)_],
)

#q("F-T2.14", "a",
  [Un diodo zéner estabiliza una tensión, la suya nominal, cuando se conecta en serie con una resistencia y polarizado:],
  ([en inversa, con tensión suficiente para trabajar en la zona de ruptura], [en inversa, con una tensión inferior a la zéner, sin llegar a la ruptura], [en directa, como un diodo rectificador ordinario], [en alterna, sin polaridad definida]),
  sol: [El zéner se fabrica para que su ruptura inversa ocurra a una tensión precisa (5,6 V, 12 V, etc.) y la soporte sin daño: polarizado en inversa y en ruptura, su tensión queda casi constante aunque varíe la corriente, y la resistencia en serie limita esa corriente. Con una tensión inversa menor que la zéner (b) el diodo no conduce y no estabiliza nada; en directa (c) se comporta como un diodo normal, con una caída de unos 0,6 V; en alterna (d) no hay una tensión continua que fijar. _(Véase tema T2, sección «Semiconductores y otros componentes», y capítulo «La radio por dentro: componente a componente», sección 5.)_],
)

#q("F-T2.15", "c",
  [Un diodo zéner de 12 V, polarizado en inversa y trabajando en ruptura, se alimenta desde una fuente de 20 V a través de una resistencia en serie de 160 Ω. La corriente que circula por la resistencia es de:],
  ([125 mA], [75 mA], [50 mA], [200 mA]),
  sol: [Con el zéner en ruptura hay 12 V constantes en sus bornes; la resistencia soporta la diferencia, 20 − 12 = 8 V, y por ella circulan $I = V_R slash R = 8 slash 160 = 0,05$ A = 50 mA. Los 125 mA (a) usan toda la tensión de la fuente (20/160); los 75 mA (b), solo la del zéner (12/160); y los 200 mA (d) suman las dos tensiones (32/160). Esa corriente se reparte entre la carga y el zéner: el zéner absorbe lo que la carga no toma. _(Véase capítulo «La radio por dentro: componente a componente», sección 5, apartado «Sub-circuito 4: el zéner, la ruptura domesticada» (estabilizador con $R = 150$ Ω: $(20 - 12) slash 150 approx 53$ mA); tema T2, sección «Semiconductores y otros componentes».)_],
)

#q("F-T2.16", "d",
  [Un LED cae 2 V cuando por él circulan 20 mA. Para alimentarlo con esa corriente desde una fuente de 9 V, la resistencia en serie debe ser de:],
  ([450 Ω], [550 Ω], [35 Ω], [350 Ω]),
  sol: [La resistencia debe soportar la tensión sobrante: 9 − 2 = 7 V con 20 mA, luego $R = 7 slash 0,02 = 350$ Ω. Los 450 Ω (a) olvidan la caída del LED (9/0,02); los 550 Ω (b) la suman en vez de restarla (11/0,02); y los 35 Ω (c) resultan de confundir 20 mA con 0,2 A. Sin resistencia, la corriente solo la limitaría el propio LED y se destruiría. _(Véase capítulo «La radio por dentro: componente a componente», sección 2, apartado «Sub-circuito 1: la limitadora» (LED con 12 V y 10 mA: $R = 1$ kΩ); tema T2, sección «Semiconductores y otros componentes».)_],
)

#q("F-T2.17", "b",
  [La corriente de fuga de un diodo polarizado en inversa, por debajo de su tensión inversa máxima, es:],
  ([igual a la que conduce en directa], [muy pequeña y aumenta con la temperatura], [muy pequeña y disminuye al aumentar la temperatura], [nula en cualquier circunstancia]),
  sol: [En inversa la zona de deplexión se ensancha y el diodo bloquea casi por completo, pero no del todo: queda una corriente de fuga minúscula (microamperios o menos), debida a portadores generados térmicamente; por eso crece con la temperatura. La a describe la polarización directa; la d corresponde a un diodo ideal, que no existe; y la c invierte el efecto de la temperatura. _(Véase tema T2, sección «Semiconductores y otros componentes», y capítulo «La radio por dentro: componente a componente», sección 5.)_],
)

#q("F-T2.18", "a",
  [Si se aplica a un diodo rectificador ordinario una tensión inversa superior a su tensión inversa máxima:],
  ([entra en ruptura, conduce en sentido inverso y puede destruirse], [sigue bloqueando con normalidad: ese valor es solo orientativo], [pasa a funcionar como un zéner y estabiliza la tensión sin riesgo], [aumenta su resistencia y deja de conducir en directa]),
  sol: [Más allá de la tensión inversa máxima (el pico inverso de repetición) la barrera de la unión cede en avalancha y el diodo conduce bruscamente hacia atrás; si no se limita la corriente, el calor lo destruye. Un rectificador ordinario no está diseñado para trabajar en ruptura, a diferencia del zéner, que se fabrica para hacerlo a una tensión precisa y con la corriente limitada por una resistencia. Por eso la tensión inversa máxima del diodo debe superar el pico inverso que va a soportar. _(Véase tema T2, sección «Semiconductores y otros componentes», y capítulo «La radio por dentro: componente a componente», sección 5.)_],
)

#q("F-T2.19", "c",
  [Un transistor bipolar con $beta = 150$ recibe una corriente de base de 40 μA. La corriente de colector es aproximadamente de:],
  ([60 mA], [0,27 μA], [6 mA], [0,6 mA]),
  sol: [La ganancia de corriente $beta$ relaciona las dos corrientes: $I_C = beta I_B = 150 times 40$ μA = 6000 μA = 6 mA. Hay que cuidar el paso de microamperios a miliamperios: 6000 μA son 6 mA, no 60 ni 0,6. Dividir en lugar de multiplicar ($I_B slash beta approx 0,27$ μA) es el error típico: el transistor amplifica la corriente, no la atenúa. La base actúa así como un «mando» que gobierna un caudal 150 veces mayor que la corriente que ella misma consume. _(Véase tema T2, sección «Semiconductores y otros componentes».)_],
)

#q("F-T2.20", "a",
  [La base de un transistor se polariza con un divisor formado por $R_1 = 33$ kΩ (a +12 V) y $R_2 = 12$ kΩ (a masa). Si la base casi no toma corriente, su tensión respecto a masa es de:],
  ([3,2 V], [8,8 V], [4,4 V], [6 V]),
  sol: [Las dos resistencias forman un divisor: por ellas baja la misma corriente y la tensión se reparte en proporción a cada valor. $V_B = 12 times R_2/(R_1 + R_2) = 12 times 12/(33 + 12) = 3,2$ V. Los 8,8 V son la caída en $R_1$ (se puso $R_1$ en el numerador); los 4,4 V salen de olvidar $R_2$ en el denominador ($12 dot 12 slash 33$); 6 V solo sería cierto con dos resistencias iguales. Con una resistencia de emisor, el emisor queda unos 0,6 V por debajo de la base, y eso fija la corriente de reposo del transistor. _(Véase tema T2, sección «Semiconductores y otros componentes» (el divisor, con números, en el capítulo «La radio por dentro», apartados 2 y 6).)_],
)

#q("F-T2.21", "d",
  [En una puerta lógica AND (Y) de dos entradas, la salida vale 1 solo cuando:],
  ([alguna de las dos entradas vale 1], [las dos entradas valen 0], [las dos entradas son distintas], [las dos entradas valen 1]),
  sol: [La puerta AND (Y) entrega un 1 únicamente cuando todas sus entradas valen 1; en cualquier otra combinación la salida es 0 (se comporta como un producto: 1 · 1 = 1, y todo producto con un 0 da 0). «Alguna de las dos a 1» es la condición de la puerta OR (O), que solo da 0 cuando las dos entradas valen 0. «Las dos a 0» es la condición para que una NOR dé un 1, y «las dos distintas», la de una XOR (O exclusiva). Regla para recordarlo: Y = «todas», O = «alguna». _(Véase tema T2, sección «Semiconductores y otros componentes».)_
#_apc1-noest[Las puertas lógicas combinan niveles 0 y 1. La Y (AND) da 1 solo si todas sus entradas valen 1. La O (OR) da 1 si al menos una entrada vale 1, y 0 solo con todas a 0. El inversor (NOT) tiene una entrada y entrega el nivel contrario. Sus versiones con la salida invertida son la NAND (Y negada) y la NOR (O negada). La lista de salidas para cada combinación de entradas se llama tabla de verdad.]],
)

#q("F-T2.22", "b",
  [Una puerta inversora (NOT) se caracteriza porque:],
  ([repite en su salida el nivel de su entrada], [entrega en su salida el nivel lógico contrario al de su entrada], [entrega un 1 cuando alguna de sus entradas vale 1], [entrega un 1 solo cuando todas sus entradas valen 1]),
  sol: [Un inversor invierte el nivel: con un 0 en la entrada entrega un 1, y con un 1 entrega un 0 (de ahí que se le llame también «negador»). Es la puerta básica más simple, con una sola entrada. Repetir el nivel de entrada es lo que hace un separador (_buffer_), no un inversor. Dar un 1 cuando alguna entrada vale 1 es la puerta OR (O), y dar un 1 solo cuando todas valen 1 es la AND (Y). Un inversor colocado tras cada una de ellas da las puertas NOR y NAND. _(Véase tema T2, sección «Semiconductores y otros componentes».)_
#_apc1-noest[El inversor (NOT) es la puerta más simple: una entrada y una salida, que entrega el nivel contrario al que recibe (0 → 1 y 1 → 0). Un separador o _buffer_ hace lo contrario: repite el nivel sin cambiarlo y solo refuerza la corriente. Colocado tras una puerta Y o O, el inversor da las puertas NAND y NOR, muy usadas porque con solo una de ellas puede construirse cualquier circuito lógico.]],
)

#q("F-T2.23", "a",
  [El número binario 1010 equivale, en el sistema decimal, a:],
  ([10], [5], [12], [1010]),
  sol: [En binario cada cifra vale el doble que la de su derecha: los pesos, de derecha a izquierda, son 1, 2, 4 y 8. Así, 1010 = 1 × 8 + 0 × 4 + 1 × 2 + 0 × 1 = 10. El 5 sale de leer las cifras al revés (0101); el 12 de sumar mal los pesos (8 + 4); y 1010 es tratar las cifras como si fueran decimales, cuando el sistema binario solo usa 0 y 1 (cada cifra es un bit). Con cuatro bits hay 16 combinaciones, del 0 al 15. _(Véase tema T2, sección «Semiconductores y otros componentes».)_

#_apc1-noest[El sistema binario solo usa dos cifras, 0 y 1, que coinciden con los dos niveles lógicos de los circuitos digitales. Cada posición vale el doble que la de su derecha (1, 2, 4, 8, 16…), de modo que $1101_2 = 8 + 4 + 0 + 1 = 13$. Una cifra binaria es un bit; ocho bits forman un byte, que admite 256 valores. Con $n$ bits se representan $2^n$ combinaciones.]],
)

#q("F-T2.24", "b",
  [Al representar la corriente en función de la tensión aplicada, la característica de una resistencia óhmica ideal es:],
  ([una curva exponencial], [una recta que pasa por el origen], [una parábola], [una recta paralela al eje de tensiones]),
  sol: [En un conductor óhmico se cumple la ley de Ohm, $I = V slash R$, con $R$ constante: la corriente es proporcional a la tensión y la gráfica $I$–$V$ es una recta que pasa por el origen, con pendiente $1 slash R$ (a más pendiente, menos resistencia). La exponencial es la característica de un diodo, que no es óhmico. La parábola aparece al representar la potencia, $P = V^2 slash R$, no la corriente. Una recta paralela al eje de tensiones sería una corriente constante, independiente de la tensión, como la de una fuente de corriente ideal. _(Véase tema T1, sección «Unidades y leyes fundamentales».)_],
)

#q("F-T2.25", "d",
  [Un componente cuya característica corriente-tensión no es una recta, como el diodo, se dice que es:],
  ([óhmico], [reactivo], [ideal], [no lineal]),
  sol: [Un componente es lineal (u óhmico) si su corriente es proporcional a la tensión: gráfica recta y resistencia constante. El diodo no lo cumple: por debajo de unas décimas de voltio casi no conduce y después la corriente crece de forma exponencial. Es, por tanto, no lineal, como el varistor. «Óhmico» es justo lo contrario. «Reactivo» se dice de bobinas y condensadores, que desfasan la corriente respecto de la tensión; nada tiene que ver con la forma de la curva. «Ideal» tampoco la describe. _(Véase tema T2, sección «Semiconductores y otros componentes».)_
#_apc1-noest[Un componente es lineal cuando la corriente es proporcional a la tensión: su característica $I$–$V$ es una recta por el origen y su resistencia es constante (resistencia óhmica). Es no lineal cuando la curva no es una recta: el diodo, cuya corriente crece de forma exponencial a partir de unos 0,6 o 0,7 V, o el varistor, cuya resistencia cae al superar cierta tensión. Los circuitos con elementos no lineales generan armónicos y productos de intermodulación.]],
)

#q("F-T2.26", "c",
  [La tensión máxima que puede aplicarse a una resistencia de 100 Ω y 1 W, sin superar su potencia nominal, es de:],
  ([1 V], [100 V], [10 V], [0,1 V]),
  sol: [La disipación viene dada por $P = V^2 slash R$, de donde $V = sqrt(P R) = sqrt(1 times 100) = 10$ V. Comprobación: la corriente sería $I = V slash R = 0,1$ A y $P = V I = 10 times 0,1 = 1$ W. Los 100 V salen de multiplicar $P dot R$ sin extraer la raíz; los 0,1 V son la corriente en amperios tomada por tensión; y 1 V, la potencia en vatios tomada por voltios. Por encima de 10 V la resistencia disiparía más de 1 W y se calentaría hasta quemarse. _(Véase tema T2, sección «Resistencias».)_],
)

#q("F-T2.27", "b",
  [La reactancia de un condensador de 100 pF a 14 MHz es aproximadamente de:],
  ([714 Ω], [114 Ω], [11,4 Ω], [1,14 kΩ]),
  sol: [$X_C = 1/(2 pi f C) = 1/(2 pi times 14 dot 10^6 times 100 dot 10^(-12)) = 1/(8,8 dot 10^(-3)) approx 114$ Ω. Olvidar el factor $2 pi$ da 714 Ω; los errores de potencia de diez (pF, MHz) dan 11,4 Ω o 1,14 kΩ. Además, el resultado tiene sentido: al subir la frecuencia $X_C$ baja, y a 7 MHz el mismo condensador presentaría justo el doble (unos 227 Ω). Por eso un condensador pequeño deja pasar bien la radiofrecuencia y bloquea la continua. _(Véase tema T2, sección «Condensadores».)_],
)

#q("F-T2.28", "d",
  [En un condensador variable de aire de sintonía, formado por placas fijas y placas móviles, al girar el eje cambia:],
  ([la distancia entre las placas fijas y las móviles], [el material del dieléctrico que hay entre ellas], [la tensión máxima que soportan las placas], [la superficie de las placas que queda enfrentada]),
  sol: [La capacidad de un condensador plano es $C = epsilon S/d$. En el variable de aire, las placas móviles (rotor) se introducen más o menos entre las fijas (estátor): al girar el eje cambia la superficie $S$ enfrentada y, con ella, la capacidad. La distancia $d$ entre placas queda fija y el dieléctrico es siempre el aire, así que esas dos opciones no cambian con el giro. La tensión máxima depende de esa separación fija, no del giro. Es el mando de sintonía de los receptores antiguos y de los acopladores de antena. _(Véase tema T2, sección «Condensadores».)_
#_apc1-noest[El condensador variable de aire tiene dos juegos de placas: las fijas (estátor) y las móviles (rotor), unidas al eje de mando. Al girar el eje, las placas móviles se introducen más o menos entre las fijas, varía la superficie enfrentada $S$ y con ella la capacidad $C = epsilon S slash d$. El aire es un dieléctrico de pérdidas mínimas y aguanta tensiones altas si las placas están bien separadas: por eso se emplea para sintonizar en receptores y acopladores de antena.]],
)

#q("F-T2.29", "a",
  [Los condensadores de mica se caracterizan por:],
  ([su gran estabilidad y sus bajas pérdidas], [su gran capacidad en poco volumen], [ser siempre polarizados], [su elevada corriente de fuga]),
  sol: [La mica es un dieléctrico muy estable con el tiempo y la temperatura, y de pérdidas mínimas; por eso se usa en circuitos de radiofrecuencia exigentes (filtros, osciladores, etapas de potencia), con capacidades modestas y a un precio mayor que el de un cerámico. Las otras tres propiedades son las del condensador electrolítico: mucha capacidad en poco volumen, polaridad que hay que respetar y una corriente de fuga apreciable. El condensador de mica no es polarizado y su fuga es despreciable. _(Véase tema T2, sección «Condensadores».)_
#_apc1-noest[Cada dieléctrico orienta el uso del condensador. Mica: muy estable y de pérdidas mínimas, para RF exigente, con capacidades pequeñas. Cerámicos: pequeños y baratos, con poca inductancia propia; buenos para acoplo y desacoplo de RF. Plástico (poliéster y similares): estables y económicos, para audio y frecuencias bajas. Aire: variables de sintonía. Electrolíticos: mucha capacidad, polarizados y con fuga apreciable, para filtrar fuentes.]],
)

#q("F-T2.30", "c",
  [Para el desacoplo de radiofrecuencia, es decir, para llevar a masa la RF no deseada en un punto del circuito, se emplean habitualmente condensadores:],
  ([electrolíticos de aluminio], [variables de aire], [cerámicos], [de papel o plástico arrollado, de gran valor]),
  sol: [En RF interesa un condensador con muy poca inductancia propia: por encima de su frecuencia de autorresonancia, cualquier condensador se comporta como una bobina y deja de desacoplar. Los cerámicos, pequeños y de patillas cortas, cumplen bien y son los habituales en el desacoplo de RF. Los electrolíticos de aluminio y los de papel o plástico arrollado tienen mucha capacidad, pero su construcción enrollada les da una inductancia parásita que los inutiliza en RF (los electrolíticos filtran la fuente, donde se alisa una tensión de baja frecuencia). El variable de aire sirve para sintonizar, no para desacoplar. _(Véase tema T2, sección «Condensadores».)_
#_apc1-noest[Un condensador de desacoplo se conecta en paralelo, a masa, en un punto que debe quedar «tranquilo» (por ejemplo, una línea de alimentación): ofrece a la RF un camino fácil a masa y no afecta a la continua. Para ello necesita una inductancia propia muy pequeña, pues por encima de su frecuencia de autorresonancia cualquier condensador se comporta como bobina. Los cerámicos (patillas cortas, sin arrollar) son los habituales en RF; los electrolíticos, enrollados, se reservan para filtrar la fuente.]],
)

#q("F-T2.31", "b",
  [La corriente de fuga de un condensador es:],
  ([la corriente máxima que puede soportar sin dañarse], [la pequeña corriente continua que atraviesa su dieléctrico por no ser un aislante perfecto], [la corriente que circula por él mientras se carga al conectarlo a una fuente], [la corriente alterna que lo atraviesa cuando trabaja en un circuito de RF]),
  sol: [Un dieléctrico real no es un aislante perfecto: con el condensador cargado y en reposo, una pequeña corriente continua lo atraviesa y lo va descargando poco a poco. Esa es la corriente de fuga. Es despreciable en mica y cerámicos, pero notable en los electrolíticos, y crece con la temperatura. La corriente de carga es un transitorio que desaparece al alcanzar la tensión de la fuente; la corriente alterna que deja pasar un condensador es su funcionamiento normal, no una imperfección; y la corriente máxima admisible es otra especificación, sin relación con la calidad del dieléctrico. _(Véase tema T2, sección «Condensadores».)_
#_apc1-noest[Un condensador real tiene imperfecciones. La corriente de fuga es la pequeña corriente continua que atraviesa el dieléctrico, que no es un aislante perfecto, y que va descargando lentamente el condensador. Es despreciable en los de mica y en los cerámicos, y notable en los electrolíticos; además, aumenta con la temperatura. Por eso un condensador cargado y desconectado acaba perdiendo su carga, y por eso no conviene usar un electrolítico para mantener una tensión durante mucho tiempo.]],
)

#q("F-T2.32", "d",
  [El coeficiente de temperatura de un condensador indica:],
  ([la temperatura máxima que puede soportar sin dañarse], [cuánto se calienta al circular corriente por él], [la tensión máxima que admite según la temperatura], [cómo varía su capacidad cuando cambia la temperatura]),
  sol: [El coeficiente de temperatura expresa cuánto cambia la capacidad al variar la temperatura (por ejemplo, en partes por millón por grado). En un circuito sintonizado o en un oscilador, esa deriva de $C$ desplaza la frecuencia de resonancia, $f_0 = 1/(2 pi sqrt(L C))$; por eso en los osciladores se emplean condensadores de coeficiente muy pequeño, como los de mica o los cerámicos NP0. Las otras opciones son especificaciones distintas: temperatura máxima de trabajo, calentamiento por pérdidas y reducción de la tensión admisible. _(Véase tema T2, sección «Condensadores».)_

#_apc1-noest[El coeficiente de temperatura de un condensador mide cuánto varía su capacidad cuando cambia la temperatura; se da en partes por millón por grado y puede ser positivo, negativo o casi nulo. Importa en circuitos sintonizados y osciladores, donde una deriva de $C$ mueve la frecuencia $f_0 = 1 slash (2 pi sqrt(L C))$. Para frecuencias estables se eligen condensadores de coeficiente muy bajo, como los de mica o los cerámicos NP0 (prácticamente nulo).]],
)


== Tema T3. Circuitos <apc1-sec-t3>

#q("F-T3.1", "c",
  [Dos resistencias de 30 Ω y 60 Ω conectadas en paralelo equivalen a:],
  ([90 Ω], [45 Ω], [20 Ω], [15 Ω]),
  sol: [En paralelo, $1/R = 1/R_1 + 1/R_2$; para dos resistencias, $R = (R_1 R_2)/(R_1 + R_2) = (30 times 60)/(30 + 60) = 1800/90 = 20$ Ω. Comprobación: el resultado debe ser menor que la menor de las dos (30 Ω), porque al poner una rama más la corriente total aumenta. 90 Ω es la asociación en serie; 45 Ω es la media aritmética, que no corresponde a ninguna asociación; y 15 Ω es la mitad de la menor, resultado válido solo con dos resistencias iguales de 30 Ω. _(Véase tema T1, sección «Unidades y leyes fundamentales».)_],
)

#q("F-T3.2", "c",
  [Una resistencia de 10 Ω se conecta en serie con el conjunto en paralelo formado por una de 30 Ω y otra de 60 Ω. La resistencia equivalente es de:],
  ([100 Ω], [20 Ω], [30 Ω], [6,7 Ω]),
  sol: [Primero el paralelo: $30 dot 60 slash (30 + 60) = 1800 slash 90 = 20$ Ω. Ese bloque queda en serie con la resistencia de 10 Ω, luego $R = 10 + 20 = 30$ Ω. Los 100 Ω salen de sumar las tres como si todas estuvieran en serie. Los 20 Ω olvidan la resistencia en serie. Y 6,7 Ω es el resultado de poner las tres en paralelo: $1 slash R = 1/10 + 1/30 + 1/60 = 9/60$. _(Véase tema T1, sección «Unidades y leyes fundamentales».)_],
)

#q("F-T3.3", "b",
  [Tres resistencias de 10 Ω, 20 Ω y 20 Ω se conectan en paralelo. La resistencia equivalente es de:],
  ([50 Ω], [5 Ω], [16,7 Ω], [80 Ω]),
  sol: [En paralelo se suman las inversas: $1 slash R = 1/10 + 1/20 + 1/20 = 4/20$, luego $R = 5$ Ω, menor que la más pequeña (10 Ω), como debe ser. Los 50 Ω son la suma, es decir, la asociación en serie. Los 16,7 Ω son la media aritmética, que no corresponde a ninguna asociación. Y 80 Ω sale de extender a tres resistencias la regla «producto entre suma», válida solo para dos. _(Véase tema T1, sección «Unidades y leyes fundamentales».)_],
)

#q("F-T3.4", "d",
  [Un filtro digital, realizado con un procesador digital de señal (DSP), se caracteriza porque:],
  ([está formado por bobinas y condensadores de alta precisión], [aprovecha la resonancia piezoeléctrica de un cristal de cuarzo], [solo puede trabajar con señales de corriente continua], [opera con muestras numéricas de la señal y obtiene la salida mediante cálculos matemáticos]),
  sol: [En un filtro digital la señal se muestrea y cada muestra es un número. El DSP calcula la salida combinando muestras de entrada (y, en los IIR, también de salida) con unos coeficientes que fijan la respuesta del filtro. Los filtros de bobinas y condensadores o de cristal de cuarzo son analógicos. Y un filtro digital no se limita a la continua: procesa señales de audio o de FI, siempre que el muestreo sea suficiente. _(Véase tema T3, sección «Filtros, osciladores y mezcladores», y tema T1, sección «Potencia, decibelios y DSP».)_],
)

#q("F-T3.5", "a",
  [Una ventaja de un filtro digital frente a uno analógico de bobinas y condensadores es que:],
  ([su respuesta no deriva con la temperatura ni con el envejecimiento de componentes y puede modificarse cambiando el programa], [no introduce ningún retardo en la señal], [puede procesar señales de cualquier frecuencia sin depender de la velocidad de muestreo], [no necesita conversores A/D ni D/A para filtrar una señal analógica]),
  sol: [Sus coeficientes son números: no les afectan la tolerancia de los componentes, la temperatura ni el envejecimiento, y basta cambiar el programa para variar la frecuencia de corte o el ancho de banda. Los demás inconvenientes son reales: el filtro digital introduce retardo, solo procesa frecuencias por debajo de la mitad de la de muestreo (Nyquist) y, para una señal analógica, necesita un conversor A/D a la entrada y un D/A a la salida. _(Véase tema T3, sección «Filtros, osciladores y mezcladores» (filtros digitales FIR e IIR calculados en un DSP).)_

#_apc1-noest[Un filtro analógico depende de componentes reales: su frecuencia de corte se desplaza con la tolerancia, la temperatura y el envejecimiento, y cambiarla exige cambiar piezas. En un filtro digital la respuesta la fijan coeficientes numéricos almacenados en el DSP: no derivan y se modifican por programa, incluso durante el funcionamiento. A cambio, añade retardo y exige conversión A/D y D/A.]],
)

#q("F-T3.6", "c",
  [Para filtrar digitalmente una señal de audio analógica, el orden correcto del procesado es:],
  ([conversor D/A, filtro en el DSP y conversor A/D], [filtro en el DSP aplicado directamente a la tensión analógica, sin conversores], [conversor A/D, cálculo del filtro en el DSP y conversor D/A], [mezclador con el oscilador local, filtro de cuarzo y detector de envolvente]),
  sol: [El DSP solo entiende números. Primero el conversor A/D muestrea y cuantifica la señal (precedido de un filtro antisolapamiento); después el DSP calcula el filtro sobre las muestras; por último el conversor D/A devuelve una señal analógica (seguido de un filtro de reconstrucción). El orden D/A–DSP–A/D está invertido. Sin conversores, el DSP no puede procesar una tensión analógica, y la cadena de la última opción es un filtrado analógico. _(Véase tema T1, sección «Potencia, decibelios y DSP» (muestreo, A/D, antisolapamiento y D/A), y tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.7", "a",
  [Un rectificador de onda completa, por ejemplo un puente de diodos, se alimenta de la red de 50 Hz. La frecuencia del rizado a su salida es de:],
  ([100 Hz], [50 Hz], [25 Hz], [200 Hz]),
  sol: [Con onda completa se aprovechan los dos semiciclos de la red: hay dos crestas por ciclo, luego el rizado se repite $2 dot 50 = 100$ veces por segundo, es decir, 100 Hz. Los 50 Hz serían el rizado de un rectificador de media onda, con una sola cresta por ciclo. 25 Hz y 200 Hz no los produce ningún rectificador conectado a una red de 50 Hz. La frecuencia doble facilita el filtrado con el mismo condensador. _(Véase tema T3, sección «Fuentes de alimentación y amplificadores».)_],
)

#q("F-T3.8", "d",
  [Una fuente de 20 V alimenta, a través de una resistencia en serie de 150 Ω, un zéner de 12 V en paralelo con una carga que consume 30 mA. Con el zéner regulando a 12 V, la corriente que circula por él es aproximadamente de:],
  ([53 mA], [30 mA], [83 mA], [23 mA]),
  sol: [La resistencia en serie soporta 20 − 12 = 8 V y deja pasar $8 slash 150 approx 53$ mA. Esa corriente se reparte entre la carga (30 mA) y el zéner, que absorbe el resto: 53 − 30 ≈ 23 mA. Los 53 mA son la corriente total, no la del zéner; los 30 mA son los de la carga; y 83 mA saldría de sumar en lugar de restar. _(Véase tema T3, sección «Fuentes de alimentación y amplificadores», y capítulo «La radio por dentro», apartado «Sub-circuito 4: el zéner, la ruptura domesticada».)_],
)

#q("F-T3.9", "b",
  [Comparada con una fuente lineal de la misma potencia, una fuente conmutada presenta:],
  ([mayor peso y menor rendimiento], [menor peso y tamaño y mayor rendimiento], [ausencia total de ruido eléctrico], [un rizado más intenso a 100 Hz]),
  sol: [La fuente conmutada trocea la tensión a decenas o cientos de kHz, y a esa frecuencia bastan un transformador y unos filtros pequeños: pesa menos, ocupa menos y disipa menos calor. La lineal, con su transformador de 50 Hz, es pesada y gasta en el regulador la diferencia de tensión. La conmutada no está libre de ruido: genera ruido de RF. Y su rizado no es de 100 Hz, sino de la frecuencia de conmutación, mucho más fácil de filtrar. _(Véase tema T3, sección «Fuentes de alimentación y amplificadores».)_],
)

#q("F-T3.10", "d",
  [En una estación de radioaficionado, el principal riesgo de una fuente conmutada mal filtrada o mal apantallada es que:],
  ([no admite cargas de más de 1 A], [su transformador de alta frecuencia no aísla la salida de la red], [necesita un transformador de 50 Hz mayor que el de una fuente lineal], [genera ruido e interferencias de radiofrecuencia que se oyen como QRM en HF]),
  sol: [La conmutación rápida, con flancos muy abruptos, genera armónicos que llegan a HF y entran al receptor por el cable de red, por los de alimentación o por el aire. Se combate con filtros en la entrada y en la salida, ferritas, apantallado y cables cortos (compatibilidad electromagnética). No hay límite de 1 A: se construyen de decenas de amperios. El transformador de alta frecuencia sí aísla la salida de la red, y es pequeño, no un transformador de 50 Hz. _(Véase tema T3, sección «Fuentes de alimentación y amplificadores» (ruido de conmutación, filtrado y apantallamiento; ver también el tema T9).)_],
)

#q("F-T3.11", "c",
  [El transformador de una fuente de alimentación conmutada trabaja a una frecuencia de:],
  ([50 Hz, la de la red], [100 Hz, el doble de la red], [decenas o centenares de kHz, muy superior a la de la red], [unos pocos hercios, para reducir el rizado]),
  sol: [El circuito trocea la tensión rectificada a decenas o centenares de kHz y aplica esos impulsos al transformador. A esa frecuencia el flujo necesario por ciclo es mucho menor, y basta un núcleo pequeño y ligero, que sigue aislando la salida de la red. Los 50 Hz son la frecuencia del transformador de una fuente lineal, y los 100 Hz, la del rizado tras un puente. Unos pocos hercios exigirían un núcleo enorme. _(Véase tema T3, sección «Fuentes de alimentación y amplificadores».)_],
)

#q("F-T3.12", "b",
  [Un amplificador eleva una señal de 10 mV a 1 V, con la misma impedancia en la entrada y en la salida. Su ganancia de tensión, en decibelios, es de:],
  ([20 dB], [40 dB], [100 dB], [10 dB]),
  sol: [Con las dos tensiones en mV, $V_2 slash V_1 = 1000 slash 10 = 100$. Sobre la misma impedancia, $G = 20 log(V_2 slash V_1) = 20 log 100 = 40$ dB. Los 20 dB resultan de aplicar a una relación de tensiones la fórmula de potencias, $10 log$. Los 100 dB confunden la relación de tensiones con los decibelios. Y 10 dB corresponde a una relación de tensiones de solo 3,16. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_],
)

#q("F-T3.13", "a",
  [Dos bobinas de 10 μH y 15 μH, sin acoplamiento magnético entre ellas, se conectan en serie. La inductancia total es de:],
  ([25 μH], [6 μH], [12,5 μH], [150 μH]),
  sol: [Por ambas bobinas circula la misma corriente y las tensiones inducidas se suman, luego las inductancias en serie se suman como las resistencias: $L = L_1 + L_2 = 10 + 15 = 25$ μH. Los 6 μH serían las dos bobinas en paralelo ($10 dot 15 slash 25$). Los 12,5 μH son su media aritmética y los 150 μH su producto, que no corresponden a ninguna asociación. _(Véase tema T3, sección «Asociación de componentes y resonancia» (las impedancias en serie se suman; en paralelo, las admitancias), y tema T2, sección «Bobinas».)_

#_apc1-noest[Las bobinas se asocian como las resistencias (si no comparten flujo magnético). En serie las recorre la misma corriente y las tensiones inducidas se suman: $L = L_1 + L_2 + dots.c$. En paralelo soportan la misma tensión y las corrientes se suman: $1 slash L = 1 slash L_1 + 1 slash L_2 + dots.c$, o $L = L_1 L_2 slash (L_1 + L_2)$ para dos, siempre menor que la menor. Si comparten flujo hay que añadir la inductancia mutua $M$: en serie, $L = L_1 + L_2 plus.minus 2 M$.]],
)

#q("F-T3.14", "d",
  [Dos bobinas de 20 μH y 30 μH, sin acoplamiento magnético entre ellas, se conectan en paralelo. La inductancia resultante es de:],
  ([50 μH], [25 μH], [600 μH], [12 μH]),
  sol: [En paralelo las dos bobinas soportan la misma tensión y se combinan como resistencias en paralelo: $L = (L_1 L_2)/(L_1 + L_2) = (20 dot 30)/50 = 12$ μH, menor que la menor de las dos. Los 50 μH son la suma, propia de la asociación en serie. Los 25 μH son la media aritmética, y los 600 μH el producto, que olvida dividir por la suma. _(Véase tema T3, sección «Asociación de componentes y resonancia» (las impedancias en serie se suman; en paralelo, las admitancias), y tema T2, sección «Bobinas».)_

#_apc1-noest[Las bobinas se asocian como las resistencias (si no comparten flujo magnético). En serie las recorre la misma corriente y las tensiones inducidas se suman: $L = L_1 + L_2 + dots.c$. En paralelo soportan la misma tensión y las corrientes se suman: $1 slash L = 1 slash L_1 + 1 slash L_2 + dots.c$, o $L = L_1 L_2 slash (L_1 + L_2)$ para dos, siempre menor que la menor. Si comparten flujo hay que añadir la inductancia mutua $M$: en serie, $L = L_1 + L_2 plus.minus 2 M$.]],
)

#q("F-T3.15", "c",
  [El discriminador de un receptor de FM convierte:],
  ([las variaciones de amplitud de la señal en variaciones de frecuencia], [la frecuencia intermedia en una señal de radiofrecuencia], [las variaciones de frecuencia de la señal en variaciones de tensión, es decir, en audio], [la señal de audio en una portadora modulada en frecuencia]),
  sol: [Es el demodulador de FM: la información va en la desviación de frecuencia de la portadora, y el discriminador entrega una tensión proporcional a esa desviación instantánea, o sea, el audio. Va precedido de un limitador que borra las variaciones de amplitud (el ruido). Convertir audio en una portadora modulada es lo que hace el modulador del transmisor; subir la FI a RF lo haría un mezclador; y convertir amplitud en frecuencia no es detectar FM. _(Véase tema T3, sección «Clases de amplificación y detectores».)_],
)

#q("F-T3.16", "b",
  [El detector de pendiente para FM se basa en:],
  ([sintonizar un circuito resonante exactamente a la frecuencia de la portadora y medir su tensión máxima], [situar la portadora en el flanco de la curva de un circuito sintonizado, donde la amplitud de salida varía con la frecuencia], [comparar la fase de la señal con la de un oscilador de batido que reinserta la portadora], [rectificar la señal con un diodo y un filtro RC, sin ningún circuito sintonizado]),
  sol: [En la cima de la curva de resonancia la amplitud apenas cambia con la frecuencia, y no serviría. Por eso se sintoniza algo por encima o por debajo: la portadora queda en el flanco, donde al variar la frecuencia varía la amplitud, y un diodo detector recupera esa variación como audio. Es sencillo, pero poco lineal; de ahí que se prefieran el discriminador y el detector de relación. Un diodo con RC y sin circuito sintonizado detecta AM, no FM; el BFO reinserta la portadora en SSB y CW. _(Véase tema T3, sección «Clases de amplificación y detectores».)_],
)

#q("F-T3.17", "c",
  [En un receptor de FM, el limitador que precede al discriminador sirve para:],
  ([amplificar el audio hasta el nivel que necesita el altavoz], [reinsertar la portadora suprimida por el transmisor], [recortar las variaciones de amplitud, que son ruido y no información], [reducir la desviación de frecuencia para estrechar la banda]),
  sol: [En FM el mensaje va en la frecuencia y la amplitud es constante. El ruido eléctrico (chispas, motores, tormentas) y muchas interferencias alteran sobre todo la amplitud. El limitador recorta todo lo que sobresale y deja una señal de amplitud uniforme, de modo que el discriminador solo ve variaciones de frecuencia, que sí son información. No amplifica el audio (lo hace el amplificador de audio tras el detector), no reinserta la portadora (tarea del BFO en SSB y CW) y no modifica la desviación de frecuencia, que es el propio mensaje. _(Véase tema T3, sección «Clases de amplificación y detectores».)_],
)

#q("F-T3.18", "a",
  [Un oscilador controlado por tensión (VCO) es un oscilador cuya:],
  ([frecuencia de salida cambia al variar una tensión continua de control], [amplitud de salida cambia al variar la tensión de la red eléctrica], [frecuencia queda fijada por un cristal de cuarzo, sin posibilidad de ajuste], [tensión de alimentación se estabiliza mediante un diodo zéner]),
  sol: [VCO son las siglas inglesas de _voltage controlled oscillator_. Una tensión continua aplicada a su entrada de control desplaza la frecuencia de oscilación, normalmente mediante un varicap en el circuito resonante. Es la pieza básica del PLL y del modulador de FM. Lo que se controla es la frecuencia, no la amplitud. Un cristal fija la frecuencia con mucha precisión y deja muy poco margen de ajuste. Y estabilizar la alimentación con un zéner es buena práctica, pero no convierte a un oscilador en controlado por tensión. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.19", "d",
  [La frecuencia de un VCO se hace variar con la tensión de control mediante un componente situado en su circuito resonante. Normalmente es:],
  ([un diodo zéner, que mantiene constante su tensión en inversa], [un diodo LED, que emite luz cuando conduce], [una bobina de núcleo ajustable, que se regula con un destornillador], [un diodo varicap, cuya capacidad depende de la tensión inversa aplicada]),
  sol: [Un diodo polarizado en inversa se comporta como un condensador cuya capacidad depende de la tensión aplicada: es el varicap. Colocado en el circuito resonante del oscilador, al cambiar la tensión de control cambia $C$ y con ella $f_0 = 1/(2 pi sqrt(L C))$ (más tensión inversa, menos capacidad y más frecuencia). El zéner estabiliza tensiones y el LED emite luz: ninguno sirve de condensador variable. La bobina de núcleo ajustable se mueve a mano, no con una tensión. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.20", "b",
  [En un transmisor de FM con modulación directa, la señal de voz se aplica al VCO para que este:],
  ([amplifique la voz hasta el nivel que necesita la antena], [desvíe su frecuencia al ritmo de la voz], [suprima la portadora y una de las bandas laterales], [filtre los armónicos de la señal de salida]),
  sol: [En FM la información va en la frecuencia. Si la tensión de audio llega a la entrada de control del VCO (a su varicap), la frecuencia de salida sube y baja siguiendo la voz, y la desviación es proporcional al volumen: el VCO actúa como modulador de FM. Amplificar corresponde a otras etapas del transmisor. Suprimir la portadora y una banda lateral es propio de la SSB. Y los armónicos se atenúan con un filtro paso bajo a la salida del amplificador final. _(Véase tema T5, sección «Arquitecturas y características generales».)_],
)

#q("F-T3.21", "d",
  [El ruido de fase de un oscilador consiste en:],
  ([armónicos de la frecuencia fundamental presentes en su salida], [una deriva lenta de la frecuencia a medida que varía la temperatura ambiente], [un zumbido procedente de la red eléctrica que modula en amplitud la portadora], [pequeñas fluctuaciones aleatorias de la fase, que extienden ruido a ambos lados de la portadora]),
  sol: [El ruido de fase son pequeñas fluctuaciones aleatorias de la fase (y por tanto de la frecuencia) del oscilador. En el espectro aparecen como «faldones» de ruido a ambos lados de la portadora, en lugar de una raya limpia. No son armónicos, que caen en múltiplos de la frecuencia. Tampoco es la deriva térmica, que es lenta y sistemática, ni el zumbido de red, que es una modulación de amplitud. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.22", "b",
  [Un transmisor cuyo oscilador tiene mucho ruido de fase:],
  ([emite solo armónicos, en frecuencias múltiplos de la de trabajo], [ensucia el espectro con ruido en las frecuencias vecinas, que puede molestar a estaciones en canales próximos], [reduce su potencia de salida en proporción al ruido generado], [sufre una deriva permanente de frecuencia aunque no se toque el mando]),
  sol: [Los faldones de ruido del oscilador se amplifican y salen por la antena junto con la señal: el transmisor emite ruido de banda ancha a ambos lados de su frecuencia, aunque no genere armónicos ni otros espurios, y ese ruido puede llegar a canales vecinos. Por eso un buen transmisor exige un oscilador de bajo ruido de fase. No es un problema de potencia ni de deriva, que es un desplazamiento lento de la frecuencia y no una fluctuación rápida y aleatoria. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.23", "a",
  [El ruido de fase del oscilador local de un receptor provoca que:],
  ([una señal intensa cercana aporte ruido al canal deseado y empeore así la selectividad efectiva], [la frecuencia intermedia se desplace de forma permanente], [el receptor amplifique más la frecuencia imagen], [la ganancia de la FI aumente y el receptor gane sensibilidad]),
  sol: [Al mezclar, los faldones de ruido del oscilador local se mezclan también con las señales de entrada. Una emisora muy fuerte y cercana, aunque quede fuera del filtro de FI, se mezcla con los faldones y deja ruido dentro de la banda de FI: es la mezcla recíproca. El canal débil queda tapado y la selectividad efectiva es peor que la de los filtros. No desplaza la FI, no realza la imagen (que depende del filtrado previo al mezclador) ni aporta ganancia alguna. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_
#_apc1-noest[Mezcla recíproca: los faldones de ruido de fase del oscilador local se mezclan con las señales intensas próximas a la sintonizada, aunque estas queden fuera de la banda de paso, y trasladan ruido a la frecuencia intermedia. Así, un oscilador local ruidoso enmascara las señales débiles y limita la selectividad efectiva y el rango dinámico del receptor, por buenos que sean sus filtros.]],
)

#q("F-T3.24", "c",
  [Los bloques básicos de un lazo de enganche de fase (PLL) son:],
  ([un mezclador, un filtro de FI y un detector de envolvente], [un rectificador, un filtro de alisado y un regulador de tensión], [un comparador de fase, un filtro de paso bajo y un oscilador controlado por tensión], [un modulador, un amplificador de potencia y una antena]),
  sol: [El comparador de fase mide la diferencia de fase entre la referencia y la señal del VCO (dividida por $N$ en un sintetizador) y entrega una tensión de error. El filtro de paso bajo la alisa y la convierte en la tensión de control continua con la que el VCO corrige su frecuencia. Cerrado el lazo, el VCO queda «enganchado» a la referencia. Las otras opciones son cadenas de otros circuitos: el receptor superheterodino, una fuente de alimentación y un transmisor. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_
#_apc1-noest[Un PLL es un lazo cerrado de cuatro bloques: el comparador de fase, que compara la referencia con la salida del VCO (dividida por $N$ en un sintetizador) y entrega una tensión de error; el filtro de lazo, de paso bajo, que la alisa; el VCO, que cambia su frecuencia con esa tensión de control; y el divisor programable, que divide la salida del VCO antes del comparador.]],
)

#q("F-T3.25", "a",
  [Cuando un PLL está enganchado, las dos señales que llegan al comparador de fase tienen:],
  ([la misma frecuencia y una diferencia de fase constante], [frecuencias distintas, y su diferencia es la que mantiene la tensión de control], [la misma amplitud, aunque su frecuencia sea distinta], [frecuencias que son múltiplos enteros una de otra]),
  sol: [«Enganchado» significa que el lazo ha alcanzado el equilibrio: la señal del VCO (dividida por $N$ en un sintetizador) y la referencia tienen exactamente la misma frecuencia y su diferencia de fase permanece constante. Si las frecuencias fueran distintas, la fase relativa crecería sin parar y el comparador daría una tensión de error variable, que seguiría corrigiendo el VCO. La amplitud no interviene, porque el comparador mide fase. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_

#_apc1-noest[Un PLL está enganchado cuando la señal del VCO (dividida por $N$ en un sintetizador) y la de referencia tienen exactamente la misma frecuencia y una diferencia de fase constante: la tensión de error ya no varía y el lazo se mantiene estable. Fuera de enganche las frecuencias difieren, la fase relativa cambia continuamente y el lazo trabaja para recuperar el enganche.]],
)

#q("F-T3.26", "d",
  [En un PLL, la tensión de error que entrega el comparador de fase, una vez filtrada, se aplica al VCO para:],
  ([ajustar el divisor programable hasta alcanzar el canal deseado], [modificar la frecuencia del cristal de referencia hasta igualarla a la del VCO], [variar la amplitud de la señal de salida sin alterar su frecuencia], [corregir la frecuencia del VCO en el sentido que reduce el error respecto a la referencia]),
  sol: [El comparador de fase compara la referencia con la señal del VCO (dividida por $N$) y produce una tensión proporcional al error. Ya filtrada, llega a la entrada de control del VCO y mueve su frecuencia en el sentido que reduce ese error: es una realimentación negativa. Siempre cambia el VCO, nunca el cristal de referencia, que es fijo. El canal se elige cambiando el divisor, no con la tensión de error, y el VCO varía su frecuencia, no su amplitud. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.27", "b",
  [Un sintetizador PLL con referencia de 12,5 kHz debe generar 145,500 MHz. El divisor programable ha de valer:],
  ([5 820], [11 640], [11 600], [116 400]),
  sol: [La salida de un sintetizador con divisor programable es un múltiplo entero de la referencia: $f_"out" = N dot f_"ref"$, luego $N = f_"out"/f_"ref" = ("145 500 kHz")/("12,5 kHz") = "11 640"$. Comprobación: $"11 640" times 12,5$ kHz = 145 500 kHz. Es decir, basta dividir la frecuencia deseada entre la de referencia. Con $N = "11 600"$ saldrían 145,000 MHz. El valor 5 820 correspondería a una referencia de 25 kHz, y 116 400 es un error de coma decimal: daría 1 455 MHz. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.28", "c",
  [Un PLL con referencia de 25 kHz tiene su VCO enganchado en 145,500 MHz. Si se aumenta en 3 unidades el divisor programable, el VCO se engancha en:],
  ([145,503 MHz], [145,525 MHz], [145,575 MHz], [436,500 MHz]),
  sol: [Como $f_"out" = N dot f_"ref"$, cada unidad que se suma a $N$ desplaza la salida una frecuencia de referencia: 3 × 25 kHz = 75 kHz y 145,500 + 0,075 = 145,575 MHz. Por eso el paso mínimo de sintonía es la frecuencia de referencia. Los 145,503 MHz suponen 1 kHz por unidad; los 145,525 MHz, una sola unidad; y los 436,500 MHz multiplican por 3 la frecuencia en lugar de sumar tres pasos. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.29", "d",
  [Un filtro digital FIR (de respuesta finita al impulso) se caracteriza porque:],
  ([realimenta su propia salida hacia la entrada, por lo que su respuesta a un impulso se prolonga indefinidamente], [es un filtro analógico basado en un cristal de cuarzo, de banda muy estrecha], [solo puede construirse con bobinas y condensadores, nunca mediante un procesador digital], [calcula cada muestra de salida combinando un número finito de muestras de entrada, sin realimentar la salida]),
  sol: [FIR son las siglas de _finite impulse response_. Cada muestra de salida es una combinación de un número finito de muestras de entrada, sin volver a usar la salida; por eso un impulso deja de notarse pasado ese número de muestras. La opción que habla de realimentar la salida describe un filtro IIR. Los filtros FIR se calculan en un DSP: no son circuitos analógicos de cristal ni de bobinas y condensadores. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.30", "b",
  [Un filtro digital IIR (de respuesta infinita al impulso) se caracteriza porque:],
  ([combina solo un número finito de muestras de entrada, sin utilizar ninguna realimentación], [realimenta muestras de su propia salida y su respuesta a un impulso se prolonga, en teoría, indefinidamente], [su respuesta a un impulso dura una sola muestra], [solo puede funcionar como filtro de paso bajo]),
  sol: [IIR son las siglas de _infinite impulse response_. Cada salida se calcula con muestras de entrada y con salidas anteriores: hay realimentación. Un impulso sigue influyendo en las muestras siguientes y su efecto se prolonga, en teoría, indefinidamente (en un filtro estable va decayendo). Combinar un número finito de muestras sin realimentación es lo propio del FIR. Una respuesta de una sola muestra no define a ninguno de los dos, y ambos pueden ser paso bajo, paso alto, paso banda o de rechazo. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.31", "b",
  [Un sintetizador digital directo (DDS) tiene un reloj de 50 MHz y un acumulador de fase de 32 bits. El paso mínimo con que puede variar su frecuencia de salida es, aproximadamente, de:],
  ([0,023 Hz], [0,012 Hz], [1,56 MHz], [0,12 Hz]),
  sol: [La resolución de un DDS es el incremento mínimo de frecuencia: $Delta f = f_"clk" slash 2^n = 50 times 10^6 slash 2^32 = 50 times 10^6 slash "4 294 967 296" approx 0,0116$ Hz, es decir, unos 0,012 Hz. Los 0,023 Hz son el resultado con un reloj de 100 MHz: el doble de reloj, el doble de paso. Los 1,56 MHz salen de dividir entre el número de bits (32) en lugar de entre $2^32$, y 0,12 Hz es un error de un orden de magnitud: $2^32$ son más de 4000 millones. Más bits o menos reloj dan un paso más fino. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.32", "c",
  [En un DDS con el reloj de referencia fijo, la frecuencia de la señal de salida se cambia modificando:],
  ([la tensión aplicada a un diodo varicap], [el divisor programable de un lazo de enganche de fase (PLL)], [el incremento de fase que el acumulador suma en cada ciclo de reloj], [la tensión de referencia del conversor D/A]),
  sol: [En un DDS el reloj es fijo y lo que se programa es el incremento de fase $M$ que el acumulador suma en cada ciclo: con un $M$ grande la fase recorre el ciclo de seno en pocos pasos y la frecuencia de salida es alta; con uno pequeño, baja. La relación es $f_"out" = M f_"clk" slash 2^n$. El varicap y el divisor programable son las herramientas del VCO y del PLL, otra técnica de síntesis; la tensión de referencia del D/A solo escala la amplitud de la señal, no su frecuencia. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_
#_apc1-noest[El reloj de un DDS tiene frecuencia fija. En cada pulso, el acumulador de fase de $n$ bits suma a su contenido un número $M$ (palabra de control o incremento de fase) y, al desbordarse, vuelve a empezar: así recorre un ciclo completo cada $2^n slash M$ pulsos. La frecuencia de salida es $f_"out" = M f_"clk" slash 2^n$. Para cambiarla basta cargar otro $M$, y el salto es instantáneo: no hay que esperar al enganche de un lazo, como en el PLL.]],
)

#q("F-T3.33", "d",
  [Un sintetizador digital directo (DDS) genera la señal con los siguientes bloques:],
  ([comparador de fase, filtro de lazo, VCO y divisor programable], [mezclador, filtro de FI, detector y amplificador de audio], [transformador, rectificador, filtro y regulador], [acumulador de fase, tabla de seno, conversor D/A y filtro de paso bajo]),
  sol: [El DDS es una cadena digital hasta el último momento: el acumulador de fase cuenta en qué punto del ciclo estamos, la tabla de seno (una memoria) convierte esa fase en el valor de la senoide, el conversor D/A lo pasa a tensión y el filtro de paso bajo alisa los escalones. Comparador de fase, filtro de lazo, VCO y divisor programable son los bloques de un PLL, la otra síntesis; mezclador, filtro de FI y detector forman un receptor superheterodino; y transformador, rectificador, filtro y regulador, una fuente de alimentación. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_

#_apc1-noest[Bloque a bloque: el acumulador de fase suma en cada pulso de reloj un incremento y entrega la fase actual; esa fase direcciona una tabla de seno, una memoria que guarda los valores de un ciclo de senoide; el conversor D/A los convierte en una tensión escalonada, y un filtro de paso bajo de reconstrucción elimina los escalones y las componentes por encima de la mitad del reloj. No hay VCO ni lazo de realimentación: todo el trabajo es aritmética sobre números.]],
)

#q("F-T3.34", "a",
  [Un circuito serie formado por una resistencia de 15 Ω y una bobina de 20 Ω de reactancia presenta una impedancia de:],
  ([25 Ω], [35 Ω], [5 Ω], [300 Ω]),
  sol: [La resistencia y la reactancia están desfasadas 90°, así que no se suman aritméticamente: se combinan como los catetos de un triángulo rectángulo. $Z = sqrt(R^2 + X^2) = sqrt(15^2 + 20^2) = sqrt(625) = 25$ Ω. Los 35 Ω resultan de sumar $R$ y $X$ como si fueran dos resistencias; los 5 Ω, de restarlas; y los 300 Ω, de multiplicarlas. La impedancia queda siempre entre la mayor de las dos y su suma. _(Véase tema T3, sección «Asociación de componentes y resonancia».)_
#_apc1-noest[En el tema la impedancia se escribe $Z = R + j (X_L - X_C)$. Para obtener su valor en ohmios se usa el triángulo de impedancias: $R$ y $X$ son los catetos y $Z$ la hipotenusa, $Z = sqrt(R^2 + X^2)$, con $X = X_L - X_C$. Como $R$ y $X$ están a 90°, no se suman aritméticamente: $Z$ es menor que $R + X$ y mayor que cada uno de ellos por separado.]],
)

#q("F-T3.35", "c",
  [Un circuito serie, formado por una resistencia de 12 Ω y un condensador de 16 Ω de reactancia, se conecta a un generador de 100 V eficaces. La corriente que circula es de:],
  ([3,6 A], [6,25 A], [5 A], [8,3 A]),
  sol: [Primero la impedancia: $Z = sqrt(R^2 + X_C^2) = sqrt(12^2 + 16^2) = sqrt(400) = 20$ Ω. Después, la ley de Ohm con $Z$: $I = V slash Z = 100 slash 20 = 5$ A. Los demás valores son errores típicos: 3,6 A sale de dividir entre $R + X = 28$ Ω (sumando); 6,25 A, de usar solo la reactancia (100/16); y 8,3 A, de usar solo la resistencia (100/12). En alterna, la corriente la limita la impedancia total, no cada componente por separado. _(Véase tema T3, sección «Asociación de componentes y resonancia».)_

#_apc1-noest[La ley de Ohm sigue valiendo en alterna si se sustituye $R$ por la impedancia $Z$ y se usan valores eficaces: $I = V slash Z$. En un circuito serie, $Z$ no es la suma de $R$ y $X$, sino el módulo del triángulo de impedancias: $Z = sqrt(R^2 + X^2)$. La corriente es la misma en todos los elementos, pero las tensiones en $R$ y en la reactancia, desfasadas 90°, no se suman aritméticamente.]],
)

#q("F-T3.36", "d",
  [Una resistencia de 60 Ω, una bobina de 150 Ω de reactancia y un condensador de 70 Ω de reactancia se conectan en serie. La impedancia total del conjunto es de:],
  ([280 Ω], [176 Ω], [140 Ω], [100 Ω]),
  sol: [Las reactancias de bobina y condensador se oponen (sus tensiones están en oposición de fase), así que se restan: $X = X_L - X_C = 150 - 70 = 80$ Ω inductivos. Esa reactancia neta está a 90° de la resistencia: $Z = sqrt(R^2 + X^2) = sqrt(60^2 + 80^2) = 100$ Ω. Los 280 Ω suman todo sin más; los 176 Ω combinan las tres magnitudes en cuadratura sin restar las reactancias; y los 140 Ω restan las reactancias, pero suman aritméticamente el resultado con $R$. _(Véase tema T3, sección «Asociación de componentes y resonancia».)_
#_apc1-noest[Con bobina y condensador en serie, las reactancias tienen signo contrario y se restan: $X = X_L - X_C$ (inductiva si es positiva, capacitiva si es negativa). Después se combina con $R$ en cuadratura: $Z = sqrt(R^2 + X^2)$. En resonancia $X = 0$ y $Z = R$, el mínimo posible en un circuito serie.]],
)

#q("F-T3.37", "d",
  [En un receptor definido por software (SDR), tras digitalizar la señal con un conversor A/D, el filtrado y la demodulación se realizan mediante:],
  ([un filtro de cristal de cuarzo en la etapa de FI], [un detector de envolvente con diodo], [un discriminador con bobinas y condensadores], [un programa que procesa numéricamente las muestras]),
  sol: [En un SDR el conversor A/D convierte la señal en una sucesión de números, y todo lo que viene después (filtros, demodulación de AM, SSB o FM, control de ganancia) son cálculos que ejecuta un programa en un procesador: un DSP, una FPGA o un ordenador. Las tres opciones erróneas son soluciones analógicas del receptor clásico: el filtro de cristal de la FI, el detector de envolvente y el discriminador de FM. En un SDR esas piezas se sustituyen por algoritmos. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_
#_apc1-noest[Un receptor definido por software (SDR) digitaliza la señal de RF, o de una FI, con un conversor A/D rápido situado lo más cerca posible de la antena. A partir de ahí el filtrado, la demodulación, el control automático de ganancia e incluso la representación del espectro son programas que operan sobre muestras numéricas en un DSP, una FPGA o un ordenador. Lo analógico queda reducido a la antena, unos filtros y el conversor.]],
)

#q("F-T3.38", "a",
  [La función de reducción de ruido («NR») de un transceptor con DSP:],
  ([analiza numéricamente la señal y atenúa el ruido de fondo continuo], [suprime solo los impulsos breves, como los del encendido de un motor], [enmudece el audio cuando no hay señal, como un silenciador (squelch)], [amplifica la señal de antena antes del mezclador]),
  sol: [La reducción de ruido por DSP trabaja sobre las muestras numéricas: distingue lo que tiene estructura coherente (la voz, un tono de telegrafía) de lo que es aleatorio y atenúa esto último, de modo que baja el ruido de fondo continuo, que un filtro de ancho fijo no puede quitar sin recortar también la señal. No hay que confundirla con el «noise blanker» (b), que elimina impulsos breves, ni con el silenciador (c), que solo corta el audio cuando no hay señal; y un preamplificador (d) sube también el ruido. _(Véase tema T4, sección «Características y controles».)_

#_apc1-noest[Además de los automatismos clásicos (CAG, silenciador, NB), el DSP de un transceptor moderno ofrece la reducción de ruido (NR): el procesador analiza la señal y atenúa el ruido de fondo de banda ancha, que es aleatorio, conservando la voz o la telegrafía. A diferencia del NB, que recorta picos impulsivos, el NR actúa sobre el ruido continuo. También ofrece un filtro «notch» automático, que detecta y anula un tono interferente estrecho (un heterodino), y filtros de FI de anchura y forma ajustables.]],
)

#q("F-T3.39", "b",
  [¿Qué ventaja aporta demodular con un DSP en lugar de hacerlo con un detector analógico?],
  ([Elimina por completo el ruido atmosférico de la señal recibida], [El mismo hardware demodula AM, SSB, FM o modos digitales con solo cambiar el programa], [Hace innecesario el conversor analógico-digital], [Aumenta la potencia de la señal recibida]),
  sol: [Un detector analógico queda fijado por su circuito: el de envolvente sirve para AM, el discriminador para FM, el detector de producto para SSB. Un DSP hace la demodulación como un cálculo sobre las muestras, de modo que con el mismo hardware basta cambiar el programa para pasar de AM a SSB, FM o un modo digital. No elimina el ruido atmosférico (a), aunque pueda atenuarlo; necesita justamente un conversor A/D para pasar la señal a números (c); y no da ganancia: la señal recibida no gana potencia (d). _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_
#_apc1-noest[Un demodulador digital no tiene componentes que envejezcan ni deriven: su calidad depende de los algoritmos y de la resolución del conversor A/D, no de tolerancias. El mismo hardware sirve para varios modos: al elegir AM, SSB, FM o un modo digital, el procesador ejecuta otro programa (otros algoritmos y filtros), y las mejoras llegan con una actualización de firmware.]],
)

#q("F-T3.40", "c",
  [Por encima de su frecuencia de autorresonancia, un condensador real se comporta como:],
  ([un condensador ideal de mayor capacidad], [una resistencia pura], [una bobina], [un circuito abierto]),
  sol: [Las patas y las armaduras de un condensador real tienen inductancia en serie. A baja frecuencia domina su reactancia capacitiva $X_C = 1/(2 pi f C)$; al subir, $X_C$ disminuye y $X_L = 2 pi f L$ crece hasta igualarse: es la frecuencia de autorresonancia, donde el componente es casi una resistencia pura y muy pequeña. Por encima manda la inductancia y el condensador se comporta como una bobina, por lo que deja de desacoplar. El circuito abierto (d) es el comportamiento del condensador ideal en continua, no el de uno real por encima de su autorresonancia. _(Véase tema T3, sección «Asociación de componentes y resonancia».)_],
)

#q("F-T3.41", "d",
  [Una bobina real tiene una pequeña capacidad parásita entre sus espiras. A frecuencias elevadas, esa capacidad hace que la bobina:],
  ([siga aumentando su reactancia de forma proporcional a la frecuencia, como la bobina ideal], [deje de tener pérdidas y su factor de calidad se haga infinito], [se comporte como una resistencia pura de valor constante], [resuene consigo misma y, por encima de esa frecuencia, se comporte como un condensador]),
  sol: [La capacidad entre espiras queda en paralelo con la inductancia y forma con ella un circuito resonante: la bobina tiene su propia frecuencia de autorresonancia. Por debajo, la reactancia crece con la frecuencia como en la bobina ideal; en la autorresonancia la impedancia es máxima; por encima domina la capacidad y la bobina se comporta como un condensador. Por eso una bobina de choque de HF puede dejar de «chocar» en VHF. La reactancia no sigue creciendo indefinidamente (a), las pérdidas no desaparecen ni el $Q$ se hace infinito (b), y la bobina no se vuelve resistiva (c). _(Véase tema T3, sección «Asociación de componentes y resonancia».)_],
)

#q("F-T3.42", "a",
  [En VHF y UHF los componentes se montan con los terminales lo más cortos posible porque:],
  ([la inductancia de los terminales, que apenas importa en HF, presenta a esas frecuencias una reactancia apreciable], [la capacidad de los terminales crece con la frecuencia y llega a cortocircuitar el componente], [la resistencia óhmica de los terminales es lo único que limita el comportamiento del componente a esas frecuencias], [así disminuye la capacidad parásita entre las espiras de las bobinas]),
  sol: [Un terminal tiene una inductancia del orden de 10 nH por centímetro: inocua en HF, pero su reactancia $X_L = 2 pi f L$ crece con la frecuencia. A 145 MHz, 10 nH dan $2 pi dot 145 times 10^6 dot 10 times 10^(-9) approx 9$ Ω, suficiente para desacoplar mal un condensador o desajustar un circuito. Por eso en VHF y UHF se acortan las patas o se usan componentes de montaje superficial. La capacidad no crece con la frecuencia (b), la resistencia óhmica no es la limitación principal (c), y la capacidad entre espiras es cosa de la bobina, no de las patas (d). _(Véase tema T3, sección «Asociación de componentes y resonancia».)_],
)

#q("F-T3.43", "b",
  [La frecuencia de resonancia de un circuito LC formado por una bobina de 10 μH y un condensador de 50 pF es aproximadamente de:],
  ([14,2 MHz], [7,1 MHz], [44,7 MHz], [225 kHz]),
  sol: [Se aplica $f_0 = 1/(2 pi sqrt(L C))$. Con $L = 10 times 10^(-6)$ H y $C = 50 times 10^(-12)$ F: $L C = 5 times 10^(-16)$, $sqrt(L C) approx 2,236 times 10^(-8)$ s y $f_0 = 1 slash (2 pi dot 2,236 times 10^(-8)) approx 7,1 times 10^6$ Hz = 7,1 MHz. Los 44,7 MHz salen de olvidar el $2 pi$; los 14,2 MHz, de poner $pi$ en lugar de $2 pi$ (un factor 2); y los 225 kHz, de confundir las unidades (μH con mH, o pF con nF). _(Véase tema T3, sección «Asociación de componentes y resonancia».)_],
)

#q("F-T3.44", "c",
  [Un circuito resonante sintonizado a 455 kHz tiene un ancho de banda de 5 kHz. Su factor de calidad es, aproximadamente, de:],
  ([0,011], [182], [91], [2275]),
  sol: [El factor de calidad es el cociente entre la frecuencia de resonancia y el ancho de banda a −3 dB: $Q = f_0 slash B = 455 slash 5 = 91$. Si se invierte el cociente ($B slash f_0$) sale 0,011; si se multiplican las dos frecuencias, 2275; y 182 sale de tomar la mitad del ancho de banda (los ±2,5 kHz) en lugar de la banda completa. Un $Q$ de 91 es alto: cuanto mayor es $Q$, más estrecha es la curva y mejor selecciona el circuito su frecuencia. _(Véase tema T3, sección «Asociación de componentes y resonancia».)_],
)

#q("F-T3.45", "a",
  [Un circuito resonante serie sintonizado a 7 MHz presenta, en resonancia, una reactancia inductiva de 300 Ω y una resistencia de pérdidas de 6 Ω. Su ancho de banda a −3 dB es aproximadamente de:],
  ([140 kHz], [23 kHz], [280 kHz], [350 MHz]),
  sol: [En resonancia serie, $Q = X slash R = 300 slash 6 = 50$. El ancho de banda es $B = f_0 slash Q = 7000 "kHz" slash 50 = 140$ kHz. Los 23 kHz resultan de tomar $Q = X = 300$ sin dividir entre $R$; los 280 kHz, de entender $f_0 slash Q$ como la desviación a cada lado de $f_0$ y doblarla; y los 350 MHz, de invertir $Q$ ($R slash X = 0,02$), lo que daría un ancho de banda mayor que la propia frecuencia: absurdo. Con menos pérdidas, $Q$ sube y la curva se estrecha. _(Véase tema T3, sección «Asociación de componentes y resonancia».)_],
)

#q("F-T3.46", "b",
  [La frecuencia de corte de un filtro RC de paso bajo formado por una resistencia de 10 kΩ y un condensador de 10 nF es aproximadamente de:],
  ([160 Hz], [1,6 kHz], [10 kHz], [16 kHz]),
  sol: [Se aplica $f_c = 1/(2 pi R C)$ con $R = 10^4$ Ω y $C = 10^(-8)$ F: $f_c = 1/(2 pi times 10^4 times 10^(-8)) = 1/(6,28 times 10^(-4)) approx 1590$ Hz, es decir, 1,6 kHz. Los 10 kHz salen de olvidar el $2 pi$ ($1 slash R C$). Los 160 Hz y los 16 kHz son errores de una potencia de diez al pasar los nanofaradios a faradios. En $f_c$ la salida cae a −3 dB (el 70,7 % de la tensión) y, por encima, el filtro atenúa 6 dB por octava. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.47", "c",
  [Un filtro de paso bajo «en pi» está formado por:],
  ([una bobina a masa, un condensador en serie y otra bobina a masa], [dos bobinas en serie con un condensador a masa entre ellas], [un condensador a masa, una bobina en serie y otro condensador a masa], [dos condensadores en serie con una bobina a masa entre ellos]),
  sol: [El nombre viene de la forma del esquema: una rama en serie y dos ramas a masa dibujan la letra griega $pi$. En el paso bajo la bobina, que se opone a las frecuencias altas, va en serie, y los condensadores, que las desvían a masa, van en paralelo: C–L–C. La opción con bobinas a masa y condensador en serie es el pi de paso alto, pues los papeles se intercambian. Las opciones con dos elementos iguales en serie y uno a masa son filtros en T, no en pi. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.48", "a",
  [Un filtro de paso bajo «en T» está formado por:],
  ([dos bobinas en serie con un condensador a masa entre ellas], [dos condensadores en serie con una bobina a masa entre ellos], [un condensador a masa, una bobina en serie y otro condensador a masa], [una bobina a masa, un condensador en serie y otra bobina a masa]),
  sol: [La red en T tiene dos ramas en serie y una a masa, como la letra T. En el paso bajo las dos ramas en serie son bobinas, que frenan las frecuencias altas, y la rama a masa es un condensador, que las desvía: L–C–L. Si se intercambian bobinas y condensadores sale el T de paso alto. El esquema C–L–C es el pi de paso bajo, y el de bobina a masa, condensador en serie y bobina a masa es el pi de paso alto. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.49", "c",
  [En la FI de un receptor de SSB se emplea un filtro de cuarzo porque:],
  ([amplifica la FI más que un transistor y con menos ruido], [elimina la frecuencia imagen, que llega ya mezclada con la señal], [su factor de calidad $Q$ altísimo da una selectividad muy elevada, con un ancho de banda estrecho y estable], [sustituye al oscilador de batido para demodular la SSB]),
  sol: [El cuarzo es un resonador piezoeléctrico con un $Q$ de decenas o centenas de miles, muy superior al de cualquier bobina. Con él se construye un filtro paso banda de flancos abruptos y ancho estable, que deja pasar solo la señal de SSB deseada y recorta las vecinas; y se hace en la FI, donde la frecuencia es fija. No amplifica: es un elemento pasivo con pérdidas. No elimina la imagen, que tras el mezclador ya es indistinguible de la señal y se rechaza antes, con el preselector. Tampoco sustituye al BFO, necesario para reinsertar la portadora. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_],
)

#q("F-T3.50", "b",
  [El ancho de banda típico de un filtro de cuarzo de FI para recibir voz en SSB es de:],
  ([0,5 kHz], [2,4 a 2,7 kHz], [6 kHz], [15 kHz]),
  sol: [Una emisión de voz en SSB (J3E) ocupa unos 2,7 kHz, la mitad que una AM. El filtro de la FI se hace igual de ancho, entre 2,4 y 2,7 kHz: lo justo para dejar pasar la voz y rechazar las emisoras vecinas. Los 0,5 kHz corresponden a un filtro para telegrafía, aún más estrecho; los 6 kHz, a uno para AM; y los 15 kHz, a uno para FM de banda estrecha. Más ancho dejaría entrar ruido y estaciones próximas; más estrecho recortaría la voz. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_

#_apc1-noest[Un filtro de cristal de FI se elige tan ancho como la emisión que debe dejar pasar: de 2,4 a 2,7 kHz para voz en SSB (la señal ocupa unos 2,7 kHz), unos 500 Hz o menos para telegrafía, 6 kHz para AM y de 12 a 15 kHz para FM de banda estrecha. Muchos receptores llevan varios filtros conmutables. Un filtro más estrecho que la emisión recorta la voz; uno más ancho deja pasar ruido y emisoras vecinas.]],
)
