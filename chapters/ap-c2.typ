// Apéndice C (parte 2): C.4 Tema T4 … C.15 Tema R7 del «Refuerzo del temario» (agente ap-c2, modo FIEL).
// Preguntas F-T4 … F-R7 con su clave y su solución razonada (D.21). No llama a #apendice (lo abre ap-c1).
#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// Código de llamada, grupos Q y abreviaturas: el original los compone en monoespaciada (local: ap-c2).
#let _apc2-m(t) = text(font: "DejaVu Sans Mono", size: 0.82em, t)

== Tema T4. Receptores <apc2-sec-t4>

#q("F-T4.1", "c",
  [En HF, una señal que marca S9 + 20 dB corresponde, en la entrada de antena de 50 Ω, a una tensión de aproximadamente:],
  ([50 μV], [100 μV], [500 μV], [5 mV]),
  sol: [El convenio para HF fija S9 en 50 μV sobre 50 Ω. Los 20 dB adicionales son una relación de tensiones de $10^(20 slash 20) = 10$, pues en tensión $"dB" = 20 log_10 (V_2 slash V_1)$; así, 50 μV × 10 = 500 μV. Los 5 mV salen de aplicar a la tensión la regla de las potencias (×100); 100 μV serían solo +6 dB, y 50 μV es el propio S9. #vease[(Véase tema T4, sección «Características y controles»; tema T8, sección «Más instrumentos y cálculos».)]],
)

#q("F-T4.2", "a",
  [Una señal que marca S6 en el S-meter es, respecto a otra que marca S9, más débil en:],
  ([18 dB], [3 dB], [12 dB], [36 dB]),
  sol: [Cada punto S equivale a 6 dB. De S6 a S9 hay tres puntos: 3×6 = 18 dB. Los 3 dB resultan de confundir puntos con decibelios; 12 dB son solo dos puntos (S7 frente a S9); y 36 dB sale de multiplicar 6 dB por el número del punto. En tensión, 18 dB son unas 8 veces menos ($10^(18 slash 20) approx 7,9$); en potencia, unas 63 veces menos. #vease[(Véase tema T4, sección «Características y controles»; tema T8, sección «Más instrumentos y cálculos».)]],
)

#q("F-T4.3", "d",
  [Un receptor de SSB tiene un ancho de banda de 2,7 kHz y una figura de ruido de 10 dB. Sabiendo que el ruido térmico es de −174 dBm en 1 Hz de ancho de banda, su señal mínima discernible (MDS, la que iguala el ruido del propio receptor) es de unos:],
  ([−174 dBm], [−164 dBm], [−140 dBm], [−130 dBm]),
  sol: [$"MDS" = -174 + 10 log_10 B + F$. Con $B = 2700$ Hz: $10 log_10 2700 approx 34$ dB y $F = 10$ dB, luego $"MDS" approx -174 + 34 + 10 = -130$ dBm. Los −140 dBm salen de olvidar la figura de ruido; los −164 dBm, de olvidar el ancho de banda; y los −174 dBm son solo el ruido térmico en 1 Hz. Un receptor más ancho o más ruidoso oye peor: cada vez que se duplica el ancho de banda se pierden 3 dB. #vease[(Véase tema T4, sección «Características y controles».)]],
)

#q("F-T4.4", "a",
  [Un receptor superheterodino con una FI de 9 MHz está sintonizado en 7,1 MHz, con el oscilador local por encima de la señal. La frecuencia imagen es:],
  ([25,1 MHz], [23,2 MHz], [16,1 MHz], [14,2 MHz]),
  sol: [El oscilador local está en $f_"OL" = 7,1 + 9 = 16,1$ MHz. La imagen queda al otro lado del oscilador, a una FI de él: $f_"im" = f_"OL" + f_"FI" = 16,1 + 9 = 25,1$ MHz, que equivale a $f_s + 2 f_"FI" = 7,1 + 18$. Esa frecuencia también produce 9 MHz al mezclarse con el oscilador, por lo que hay que rechazarla antes del mezclador, con el preselector. Los 16,1 MHz son el oscilador local; los 23,2 MHz, la suma de señal y oscilador; y los 14,2 MHz, el doble de la señal. #vease[(Véase tema T4, sección «Arquitectura del receptor».)]],
)

#q("F-T4.5", "d",
  [La desensibilización (bloqueo) de un receptor causada por una señal intensa próxima se manifiesta como:],
  ([un aumento de la sensibilidad del receptor], [la aparición de la frecuencia imagen], [una deriva de la frecuencia sintonizada], [una pérdida de ganancia aparente: las señales débiles dejan de oírse]),
  sol: [Una señal muy intensa, aunque no esté en el canal sintonizado, domina la entrada y hace que el receptor amplifique menos todo lo demás: la ganancia aparente cae y las señales débiles se hunden en el ruido. Es típico que la emisora que escuchabas casi desaparezca, y baje su lectura en el S-meter, cuando un vecino transmite. No mejora la sensibilidad, sino lo contrario. La frecuencia imagen es otro fenómeno, y la deriva de sintonía depende de la estabilidad del oscilador local, no del nivel de las señales vecinas. #vease[(Véase tema T4, sección «Características y controles»; tema T9, sección «Causas de interferencia».)]],
)

#q("F-T4.6", "a",
  [Una señal muy intensa, aunque esté fuera del canal sintonizado, puede bloquear un receptor porque:],
  ([satura las primeras etapas (amplificador de RF y mezclador), que dejan de trabajar linealmente], [modifica la frecuencia del oscilador local y descentra la sintonía], [atraviesa el filtro de FI, que no distingue unas frecuencias de otras], [eleva la tensión de alimentación del receptor]),
  sol: [El bloqueo ocurre en la entrada, antes de los filtros estrechos de la FI: la señal fuerte lleva al amplificador de RF y al mezclador a su zona de saturación, dejan de trabajar linealmente y su ganancia para las señales débiles cae. Por eso depende del nivel de la interferente y no de su frecuencia exacta. El oscilador local es independiente de la señal de antena; el filtro de FI sí distingue frecuencias, pues es un paso banda estrecho; y la alimentación no varía con la RF recibida. #vease[(Véase tema T9, sección «Causas de interferencia».)]],
)

#q("F-T4.7", "b",
  [Un remedio eficaz contra el bloqueo de un receptor por una señal fuerte es:],
  ([conectar un preamplificador en la entrada de antena], [reducir la ganancia de RF o intercalar un atenuador o un filtro en la entrada], [subir el volumen de audio], [ensanchar el filtro de FI]),
  sol: [El bloqueo es saturación de las primeras etapas, así que hay que rebajar el nivel de señal que llega a ellas: bajar el mando de ganancia de RF, intercalar un atenuador en la entrada o un filtro que rechace la señal interferente (paso banda o de rechazo). Un preamplificador da más ganancia y agrava la saturación; el volumen actúa después de la saturación y no recupera lo perdido; y ensanchar el filtro de FI deja pasar más señales sin arreglar la entrada. #vease[(Véase tema T9, sección «Medidas correctoras».)] #no-esta[Como el bloqueo es saturación del amplificador de RF y del mezclador, el remedio es reducir el nivel de la señal interferente que llega a ellos: bajar el mando de ganancia de RF (RF GAIN), intercalar un atenuador en la entrada de antena o un filtro (paso banda o de rechazo) que rechace esa señal. Añadir un preamplificador o más ganancia empeora el problema. También ayuda separar las antenas del transmisor que interfiere.]],
)

#q("F-T4.8", "d",
  [Dos señales de 7,050 MHz y 7,060 MHz llegan a una etapa no lineal de un receptor. Los productos de intermodulación de tercer orden que caen junto a ellas, dentro de la banda, aparecen en:],
  ([0,010 MHz y 14,110 MHz], [7,020 MHz y 7,090 MHz], [7,030 MHz y 7,080 MHz], [7,040 MHz y 7,070 MHz]),
  sol: [Los productos de tercer orden en banda son $2 f_1 - f_2$ y $2 f_2 - f_1$: $2 times 7,050 - 7,060 = 7,040$ MHz y $2 times 7,060 - 7,050 = 7,070$ MHz. Caen a 10 kHz por fuera de cada señal, dentro de la banda, y por eso no se pueden eliminar con un filtro. La diferencia y la suma (0,010 y 14,110 MHz) son productos de segundo orden; 7,030 y 7,080 MHz ($3 f_1 - 2 f_2$ y $3 f_2 - 2 f_1$) son de quinto orden, y 7,020 y 7,090 MHz, de séptimo: estos suelen ser más débiles. #vease[(Véase tema T9, sección «Causas de interferencia».)]],
)

#q("F-T4.9", "c",
  [Si se sube 3 dB el nivel de las dos señales que producen intermodulación, los productos de tercer orden aumentan:],
  ([3 dB], [6 dB], [9 dB], [27 dB]),
  sol: [Los productos de tercer orden crecen con el cubo de la amplitud de las señales que los generan; expresado en decibelios, cada decibelio que suben las señales sube tres el producto. Con +3 dB en las dos señales, los productos suben 3 × 3 = 9 dB. Los 3 dB serían un crecimiento lineal, propio de la señal útil; los 6 dB corresponderían a los productos de segundo orden (al cuadrado); y los 27 dB salen de elevar 3 al cubo como si fuesen decibelios. #vease[(Véase tema T9, sección «Causas de interferencia».)]],
)

#q("F-T4.10", "b",
  [En el diagrama de bloques de un receptor de FM, tras el amplificador de FI se sitúan, por este orden:],
  ([el detector de producto y el oscilador de batido (BFO)], [el limitador y el discriminador], [el discriminador y el limitador], [el mezclador y el oscilador local]),
  sol: [Tras la FI va primero el limitador, que recorta la amplitud y borra el ruido (en FM la información está en la frecuencia, no en la amplitud), y después el discriminador, que convierte las variaciones de frecuencia en tensión de audio. El orden inverso (c) es incorrecto: sin limitar antes, el discriminador dejaría pasar el ruido de amplitud. El detector de producto y el BFO (a) son de SSB y CW; el mezclador y el oscilador local (d) están antes de la FI. #vease[(Véase tema T4, sección «Características y controles».)]],
)

#q("F-T4.11", "c",
  [Un receptor de FM (F3E) se diferencia de uno de AM (A3E) en que, tras la FI, incorpora:],
  ([un oscilador de batido y un detector de producto], [un modulador balanceado y un filtro de banda lateral], [un limitador y un discriminador en lugar del detector de envolvente], [un amplificador de clase C y un multiplicador de frecuencia]),
  sol: [En AM la información va en la envolvente y la recupera el detector de envolvente. En FM la envolvente es constante y el mensaje está en la frecuencia: un limitador recorta las variaciones de amplitud (ruido) y un discriminador transforma la desviación de frecuencia en audio. El oscilador de batido y el detector de producto (a) son de SSB y CW; el modulador balanceado con su filtro (b) y el amplificador de clase C con el multiplicador (d) son etapas de transmisor, no de receptor. #vease[(Véase tema T4, sección «Características y controles».)]],
)

== Tema T5. Transmisores <apc2-sec-t5>

#q("F-T5.1", "b",
  [Un transmisor de 144 MHz con una estabilidad de frecuencia de ±1 ppm puede desviarse de su frecuencia, como máximo, en:],
  ([±1 Hz], [±144 Hz], [±1,44 kHz], [±144 kHz]),
  sol: [La estabilidad se da en partes por millón: 1 ppm es $10^(-6)$ de la frecuencia. Con $f = 144 dot 10^6$ Hz resulta $Delta f = 144 dot 10^6 times 10^(-6) = 144$ Hz, es decir, ±144 Hz. Los ±1 Hz (a) confunden ppm con hercios; ±1,44 kHz (c) serían 10 ppm y ±144 kHz (d) serían 1000 ppm (una milésima). Es el error máximo admitido: la deriva real depende de la temperatura y de la alimentación del equipo. #no-esta[La estabilidad de frecuencia de un transmisor mide cuánto se aparta su frecuencia de la nominal por la temperatura, la tensión de alimentación o el envejecimiento del cristal. Se expresa en partes por millón (ppm): 1 ppm equivale a $10^(-6)$ de la frecuencia. Como la deriva es proporcional a la frecuencia, el mismo cristal da más hercios de error en una banda alta: ±1 ppm son ±7 Hz a 7 MHz, pero ±144 Hz a 144 MHz. Una buena estabilidad evita salirse del canal o de la banda e interferir a las emisiones vecinas.]],
)

#q("F-T5.2", "c",
  [Entre 30 y 235 MHz, en un transmisor de potencia superior a 25 W, las emisiones no esenciales deben estar 60 dB por debajo de la potencia media, sin exceder de:],
  ([50 mW], [20 mW], [1 mW], [25 μW]),
  sol: [Anexo I, apartado 4.1.2 de la Orden IET/1311/2013: entre 30 y 235 MHz, con más de 25 W, las emisiones no esenciales deben quedar 60 dB por debajo de la potencia media sin exceder de 1 mW. Con 100 W, 60 dB por debajo son 100 μW y manda ese valor; el tope de 1 mW solo interviene a partir de 1 kW. Los 25 μW (d) son el tope para 25 W o menos; los 50 mW (a) rigen por debajo de 30 MHz y los 20 mW (b) entre 235 y 960 MHz. #vease[(Véase tema T5, sección «Emisiones no deseadas».)] #no-esta[La Orden IET/1311/2013 (Anexo I, 4.1) fija límites distintos por encima de 30 MHz. De 30 a 235 MHz: con más de 25 W, las no esenciales deben quedar 60 dB por debajo de la potencia media sin exceder de 1 mW; con 25 W o menos, 40 dB por debajo sin exceder de 25 μW. De 235 a 960 MHz es igual, pero el tope para más de 25 W es de 20 mW. De 960 MHz a 17,7 GHz: 50 dB, con topes de 100 mW (más de 10 W) o 100 μW. Vale el más restrictivo.]],
)

#q("F-T5.3", "a",
  [Entre 30 y 235 MHz, en un transmisor de 25 W o menos, las emisiones no esenciales deben estar 40 dB por debajo de la potencia media, sin exceder de:],
  ([25 μW], [1 mW], [25 mW], [50 mW]),
  sol: [Anexo I, apartado 4.1.2 de la Orden IET/1311/2013: con 25 W o menos, las emisiones no esenciales deben quedar 40 dB por debajo de la potencia media sin exceder de 25 μW. Con 10 W, 40 dB por debajo son 1 mW, pero el tope de 25 μW es más estricto y es el que vale. El 1 mW (b) es el tope con más de 25 W; los 50 mW (d) rigen por debajo de 30 MHz; los 25 mW (c) no figuran en la Orden y mezclan los 25 W con los 25 μW. #vease[(Véase tema T5, sección «Emisiones no deseadas».)] #no-esta[En los equipos de VHF y UHF de hasta 25 W (30 a 960 MHz) manda casi siempre el tope absoluto de 25 μW. Ejemplo: un transmisor de 10 W a 144 MHz; 40 dB por debajo son 10 W × $10^(-4)$ = 1 mW, pero el límite de 25 μW es más estricto, así que ese es el máximo admitido (unos 56 dB por debajo de la potencia media). Solo con menos de 0,25 W mandaría el criterio de los 40 dB.]],
)

#q("F-T5.4", "d",
  [Se denomina radiación por la estructura de un transmisor a:],
  ([los armónicos y espurios que se radian por la antena], [el campo magnético que produce el transformador de la fuente de alimentación], [la potencia que se pierde en forma de calor en el amplificador final], [la radiofrecuencia que escapa por el chasis y los cables del equipo sin pasar por la antena]),
  sol: [La radiación por la estructura es la radiofrecuencia que sale del equipo sin pasar por la antena: el chasis mal apantallado y los cables de alimentación, micrófono o manipulador actúan como antenas involuntarias. No es lo mismo que los armónicos y espurios radiados por la antena (a), que son emisiones no esenciales y salen por la línea de transmisión. Tampoco es el campo del transformador (b) ni el calor del amplificador final (c), que solo resta rendimiento. #vease[(Véase tema T5, sección «Emisiones no deseadas».)]],
)

#q("F-T5.5", "a",
  [La radiación por la estructura de un transmisor se reduce:],
  ([apantallando la caja del equipo y filtrando los cables que entran y salen de ella], [instalando un filtro de paso bajo más potente entre el transmisor y la antena], [reduciendo la anchura de banda de la emisión], [sustituyendo el cable coaxial por otro más grueso]),
  sol: [La RF se escapa por las rendijas de la caja y por los cables (alimentación, micrófono, manipulador), que radian como antenas. Se combate con una caja metálica bien cerrada y con ferritas y condensadores de desacoplo en cada cable. Un filtro de paso bajo a la salida (b) limpia los armónicos que van a la antena, pero no la fuga por el chasis; estrechar la emisión (c) o engrosar el coaxial (d) tampoco cierran la caja. #vease[(Véase tema T5, sección «Emisiones no deseadas».)]],
)

#q("F-T5.6", "a",
  [Un repetidor de VHF/UHF es una estación que:],
  ([recibe una señal en una frecuencia y la retransmite a la vez en otra], [emite de forma automática y continua solo su distintivo, para estudiar la propagación], [permite que dos estaciones se comuniquen directamente, sin equipo intermedio], [convierte la señal recibida a otra clase de emisión, por ejemplo de FM a SSB]),
  sol: [Según la Orden IET/1311/2013 (Anexo I, apartado 1), una estación repetidora retransmite automáticamente las emisiones que recibe, con el fin de ampliar el alcance de las comunicaciones. En VHF y UHF lo hace recibiendo en una frecuencia y emitiendo a la vez en otra (en 2 m, la entrada queda 600 kHz por debajo de la salida). La baliza (b) solo emite su distintivo; la comunicación directa sin intermediario (c) es lo contrario de un repetidor; y el cambio de clase de emisión (d) no es su función. #vease[(Véase tema T5, sección «Etapas y definiciones».)]],
)

#q("F-T5.7", "b",
  [Los repetidores se instalan preferentemente en lugares elevados (montañas, torres) porque:],
  ([así consumen menos energía de la red eléctrica], [así aumenta su alcance, al ver directamente más terreno], [así la ionosfera refleja mejor sus señales de VHF y UHF], [así se evitan las interferencias de las emisoras de HF y de onda media]),
  sol: [En VHF y UHF la onda viaja por visibilidad directa y su alcance lo marca el horizonte radioeléctrico, que crece con la raíz de la altura de las antenas. Un repetidor en una cumbre «ve» más terreno y llega a más estaciones sin aumentar la potencia. La ionosfera es transparente a esas frecuencias (c), el consumo eléctrico no depende de la altura (a) y la altura tampoco protege de las emisoras de HF o de onda media (d). #vease[(Véase tema T7, sección «La ionosfera y la onda de espacio».)]],
)

#q("F-T5.8", "b",
  [Para recibir y transmitir a la vez con una sola antena, un repetidor utiliza:],
  ([un balun 1:1, que adapta la línea coaxial a la antena], [un duplexor, conjunto de filtros que separa la frecuencia de entrada de la de salida], [un amplificador de clase C, que eleva la potencia en la etapa final], [un acoplador de antena en pi, que adapta impedancias]),
  sol: [El repetidor recibe y transmite simultáneamente en dos frecuencias próximas (en 2 m, separadas 600 kHz). Con una sola antena hace falta un duplexor: un conjunto de filtros, normalmente de cavidades, que envía cada frecuencia a su equipo y evita que el transmisor, con mucha más potencia, sature el receptor. El balun (a) pasa de línea asimétrica a antena simétrica; la clase C (c) es un modo de amplificación; el acoplador en pi (d) adapta impedancias. Ninguno separa entrada y salida. #no-esta[Un repetidor recibe y transmite a la vez, en frecuencias próximas y con una sola antena. Para ello usa un duplexor: un conjunto de filtros (normalmente de cavidades resonantes) que deja pasar la frecuencia de salida hacia la antena y la de entrada hacia el receptor. Sin él, la potencia del transmisor, enorme frente a la señal recibida, saturaría o ensordecería al receptor; la alternativa es usar dos antenas muy separadas.]],
)

#q("F-T5.9", "d",
  [Un transmisor de VHF parte de un oscilador de cristal de 12 MHz y una cadena formada por un triplicador y un cuadruplicador en cascada. Su frecuencia de salida es:],
  ([36 MHz], [48 MHz], [84 MHz], [144 MHz]),
  sol: [Las etapas multiplicadoras en cascada multiplican sus factores: 12 MHz × 3 × 4 = 144 MHz. El triplicador da 36 MHz y el cuadruplicador lleva esos 36 MHz hasta 144 MHz. Los 36 MHz (a) y los 48 MHz (b) saldrían con una sola de las dos etapas (solo el triplicador o solo el cuadruplicador), y los 84 MHz (c) resultan de sumar los factores (×7) en lugar de multiplicarlos. Así los equipos de VHF y UHF parten de cristales de frecuencia modesta. #vease[(Véase tema T5, sección «Etapas y definiciones».)]],
)

#q("F-T5.10", "c",
  [En un transmisor de FM, el oscilador de 12 MHz se desvía 250 Hz. Una cadena multiplicadora ×12 lleva la portadora a 144 MHz. La desviación a la salida es de:],
  ([21 Hz], [250 Hz], [3 kHz], [36 kHz]),
  sol: [La multiplicación de frecuencia multiplica también la desviación (y el índice de modulación $m = Delta f slash f_m$, porque la frecuencia moduladora no cambia): $Delta f = 250$ Hz × 12 = 3000 Hz = 3 kHz. Los 250 Hz (b) suponen que la desviación se conserva; los 21 Hz (a) resultan de dividir por 12 en vez de multiplicar, y los 36 kHz (d) de multiplicar por 144. Por eso el modulador puede trabajar con desviaciones pequeñas y cómodas de generar. #vease[(Véase tema T5, sección «Arquitecturas y características generales».)]],
)

#q("F-T5.11", "d",
  [En la modulación de frecuencia directa, la señal de audio actúa sobre:],
  ([el amplificador final, variando su tensión de alimentación], [un modulador balanceado que suprime la portadora], [un mezclador, que suma al oscilador la frecuencia del audio], [el oscilador, por ejemplo mediante un diodo varicap en su circuito resonante]),
  sol: [En la FM directa el audio cambia la frecuencia del propio oscilador: la tensión de audio varía la capacidad de un varicap del circuito resonante (un VCO) y con ella la frecuencia generada. Variar la tensión de alimentación del final (a) es modular en amplitud; el modulador balanceado (b) es de SSB; y el mezclador (c) traslada frecuencias, no las desvía al ritmo del audio. #vease[(Véase tema T5, sección «Arquitecturas y características generales».)]],
)

#q("F-T5.12", "a",
  [La FM indirecta se obtiene aplicando la señal de audio, previamente integrada, a:],
  ([un modulador de fase situado tras un oscilador a cristal], [un modulador balanceado seguido de un filtro de banda lateral], [un detector de pendiente situado a la salida del receptor], [un amplificador de clase A con realimentación]),
  sol: [La fase es la integral de la frecuencia, así que un modulador de fase alimentado con el audio previamente integrado produce FM: es la FM indirecta, que permite modular después de un oscilador a cristal. El modulador balanceado con filtro (b) produce SSB; el detector de pendiente (c) es un demodulador de FM, no un modulador; y la clase A (d) es un modo de amplificación, no un método de modulación. #vease[(Véase tema T1, sección «Señales moduladas».)]],
)

#q("F-T5.13", "c",
  [La ventaja de la FM indirecta (modulador de fase) es que:],
  ([permite grandes desviaciones sin necesidad de multiplicadores de frecuencia], [ocupa menos anchura de banda que la FM directa con la misma desviación], [la frecuencia de la portadora la fija un oscilador a cristal muy estable], [suprime la portadora y ahorra potencia en el transmisor]),
  sol: [En la FM indirecta la portadora sale de un oscilador a cristal, muy estable, y solo se modula su fase a continuación: no hay que desviar el cristal directamente. La contrapartida es que el modulador de fase da desviaciones pequeñas y obliga a usar multiplicadores (a). La anchura de banda la fijan la desviación y el audio (regla de Carson), igual en ambas (b). Suprimir la portadora (d) es propio de la SSB, no de la FM. #vease[(Véase tema T1, sección «Señales moduladas».)]],
)

== Tema T6. Antenas y líneas de transmisión <apc2-sec-t6>

#q("F-T6.1", "b",
  [Una antena tiene una ganancia de 7,85 dBi. Referida al dipolo de media onda, su ganancia es de:],
  ([10 dBd], [5,7 dBd], [7,85 dBd], [3,65 dBd]),
  sol: [El dipolo de media onda ya gana 2,15 dB sobre la antena isótropa, así que la cifra en dBd es 2,15 dB _menor_ que en dBi: $G_"dBd" = G_"dBi" - 2,15 = 7,85 - 2,15 = 5,7$ dBd. Los 10 dBd suman en vez de restar; los 7,85 dBd ignoran la conversión y confunden las dos referencias; y los 3,65 dBd salen de dividir entre 2,15, cuando los decibelios se suman y se restan, no se dividen. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]],
)

#q("F-T6.2", "d",
  [Una antena tiene una ganancia de 10 dBd. Referida a la antena isótropa, su ganancia es de:],
  ([7,85 dBi], [10 dBi], [4,65 dBi], [12,15 dBi]),
  sol: [La isótropa es la referencia más «baja»: el dipolo ya gana 2,15 dB sobre ella. Por eso la misma antena da siempre un número mayor en dBi: $G_"dBi" = G_"dBd" + 2,15 = 10 + 2,15 = 12,15$ dBi. La Orden IET/1311/2013 (anexo I) distingue así la ganancia isótropa y la relativa al dipolo. Restar (7,85) es el error inverso; 10 dBi no convierte; 4,65 sale de dividir entre 2,15, y los dB no se dividen. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]],
)

#q("F-T6.3", "a",
  [Una antena tiene una resistencia de radiación de 36 Ω y una resistencia de pérdidas de 4 Ω. Su eficiencia (rendimiento) es del:],
  ([90 %], [80 %], [10 %], [100 %]),
  sol: [La eficiencia es la fracción de la potencia entregada que se radia: $eta = R_r / (R_r + R_p) = 36 / (36 + 4) = 36 / 40 = 0,9$, es decir, el 90 %; el otro 10 % se convierte en calor. El 10 % es justo la parte perdida, $R_p slash (R_r + R_p)$, no la radiada. El 80 % sale de restar las resistencias en el numerador (36 − 4) y el 100 % solo se daría con $R_p = 0$. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]],
)

#q("F-T6.4", "c",
  [A igual ganancia, el área de captura de una antena receptora es mayor cuanto:],
  ([mayor es la frecuencia de trabajo], [mayor es la potencia de la estación corresponsal], [mayor es la longitud de onda (menor la frecuencia)], [mayor es la impedancia de la línea de transmisión]),
  sol: [El área de captura es la superficie equivalente con la que la antena recoge potencia de la onda: $A_e = lambda^2 / (4 pi) G$. A igual ganancia $G$, crece con el cuadrado de la longitud de onda: doblar $lambda$ (bajar la frecuencia a la mitad) multiplica el área por cuatro. Por eso, en las bandas bajas, una antena modesta capta bastante señal. Subir la frecuencia la reduce; la potencia del corresponsal y la impedancia de la línea no aparecen en la fórmula. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]],
)

#q("F-T6.5", "b",
  [A una frecuencia dada, el área de captura de una antena receptora es:],
  ([independiente de su ganancia], [proporcional a su ganancia], [inversamente proporcional a su ganancia], [igual siempre a la superficie física de sus elementos]),
  sol: [De $A_e = lambda^2 / (4 pi) G$, con $lambda$ fijada por la frecuencia, el área de captura es directamente proporcional a la ganancia: duplicar la ganancia (3 dB) duplica la superficie efectiva con que la antena capta la señal. No es inversa ni independiente. Tampoco tiene por qué coincidir con el tamaño físico: una antena de hilo apenas tiene superficie y su área de captura es, sin embargo, mucho mayor que la de sus conductores. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]],
)

#q("F-T6.6", "d",
  [Un transmisor de 10 W alimenta, mediante un cable que pierde 3 dB, una antena de 6 dBd de ganancia. La potencia efectiva radiada (p.r.e.) es aproximadamente de:],
  ([10 W], [40 W], [80 W], [20 W]),
  sol: [Se suman los decibelios: +6 − 3 = +3 dB netos, que equivale a multiplicar la potencia por 2. La p.r.e. (p.r.a. en la Orden IET/1311/2013, anexo I) es 10 W × 2 = 20 W. Los 40 W aparecen si se olvida el cable (+6 dB ≈ ×4); los 80 W, si se suman ganancia y pérdida (+9 dB ≈ ×8); y los 10 W, si se cree que el cable anula toda la ganancia. #vease[(Véase tema T6, sección «El dipolo y otras antenas» (y tema T1, sección «Potencia, decibelios y DSP»).)]],
)

#q("F-T6.7", "a",
  [Un transmisor de 100 W alimenta una antena de 10 dBd de ganancia mediante un cable que pierde 1 dB. La potencia efectiva radiada (p.r.e.) es aproximadamente de:],
  ([800 W], [900 W], [1000 W], [1260 W]),
  sol: [Balance en decibelios: +10 − 1 = +9 dB. Como 3 dB es ×2, 9 dB son tres veces ×2, es decir ×8 (con calculadora, $10^(0,9) approx 7,9$): 100 W × 7,9 ≈ 790 W, unos 800 W. Los 1000 W olvidan el cable; los 900 W tratan los dB como factores (10 − 1 = 9, ×9); los 1260 W suman la pérdida en vez de restarla (+11 dB ≈ ×12,6). #vease[(Véase tema T6, sección «El dipolo y otras antenas» (y tema T1, sección «Potencia, decibelios y DSP»).)]],
)

#q("F-T6.8", "c",
  [Para una misma antena y una misma potencia suministrada, la p.i.r.e. (referida a la antena isótropa) es, respecto a la p.r.e. (referida al dipolo de media onda):],
  ([2,15 dB menor], [3 dB mayor], [2,15 dB mayor], [igual]),
  sol: [La p.i.r.e. es la potencia suministrada por la ganancia respecto a la isótropa; la p.r.e. (p.r.a. en la Orden IET/1311/2013, anexo I), por la ganancia respecto al dipolo de media onda. Como el dipolo ya gana 2,15 dB sobre la isótropa, $G_"dBi" = G_"dBd" + 2,15$: la p.i.r.e. resulta siempre 2,15 dB _mayor_ (factor ≈ 1,64). «Menor» invierte el sentido, los 3 dB confunden con un factor 2 y «igual» solo valdría si ambas referencias coincidieran. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]],
)

#q("F-T6.9", "b",
  [Un tramo de cable coaxial con factor de velocidad 0,66 debe medir un cuarto de onda eléctrico para 7 MHz. Su longitud física es aproximadamente de:],
  ([10,7 m], [7 m], [16 m], [4,6 m]),
  sol: [En el aire, $lambda = 300 slash 7 approx 42,9$ m y $lambda slash 4 approx 10,7$ m. Dentro del cable la onda va más despacio, y la longitud física es la eléctrica por el factor de velocidad: $L_"fis" = 10,7 times 0,66 approx 7,1$ m, unos 7 m. Los 10,7 m olvidan el factor de velocidad; los 16 m lo dividen en lugar de multiplicar (el tramo real es más corto, no más largo); los 4,6 m lo aplican dos veces. #vease[(Véase tema T6, sección «Líneas de transmisión y adaptación».)]],
)

#q("F-T6.10", "d",
  [Una antena resistiva pura de 150 Ω se conecta a una línea de 50 Ω. La relación de ondas estacionarias (ROE) es de:],
  ([0,5], [1,5], [2], [3]),
  sol: [Coeficiente de reflexión: $rho = (Z_L - Z_0) / (Z_L + Z_0) = (150 - 50) / (150 + 50) = 0,5$. ROE: $(1 + rho) / (1 - rho) = (1,5) / (0,5) = 3$. Con carga resistiva basta dividir la impedancia mayor entre la menor: 150/50 = 3. El 0,5 es el coeficiente $rho$, no la ROE; el 1,5 es solo el numerador $1 + rho$; y el 2 sale de dividir 100 (la diferencia) entre 50. #vease[(Véase tema T6, sección «Líneas de transmisión y adaptación».)]],
)

#q("F-T6.11", "c",
  [Un vatímetro direccional indica 100 W de potencia directa y 25 W de potencia reflejada. La ROE de la instalación es de:],
  ([1,25], [4], [3], [2]),
  sol: [La potencia reflejada es $rho^2$ veces la directa, así que $rho = sqrt(25 slash 100) = 0,5$ y ROE $= (1 + 0,5) / (1 - 0,5) = 3$. Coincide con la escala de memoria: ROE 3:1, 25 % reflejado. El 4 sale de dividir las potencias (100/25) sin más; el 1,25 es (100 + 25)/100; y el 2 es la inversa de $rho$. Hay que extraer antes la raíz cuadrada: $rho$ es un cociente de tensiones, no de potencias. #vease[(Véase tema T6, sección «Líneas de transmisión y adaptación».)]],
)

#q("F-T6.12", "a",
  [Un cable coaxial de 3 dB de pérdidas une el transmisor con la antena. La potencia que llega a la antena es, aproximadamente:],
  ([la mitad de la del transmisor], [una cuarta parte de la del transmisor], [el 70 % de la del transmisor], [la del transmisor menos 3 W]),
  sol: [Una pérdida de 3 dB es una ganancia de −3 dB: la potencia se multiplica por $10^(-0,3) approx 0,5$, y llega la mitad (100 W se quedan en 50 W). Una cuarta parte corresponde a 6 dB. El 70 % es el factor de 3 dB en tensión o corriente, no en potencia. Y el decibelio es una relación, no una cantidad en vatios: no se restan 3 W. #vease[(Véase tema T1, sección «Potencia, decibelios y DSP».)]],
)

#q("F-T6.13", "c",
  [Las pérdidas de un cable coaxial, expresadas en decibelios:],
  ([disminuyen al aumentar la frecuencia y aumentan con la longitud], [aumentan con la frecuencia, pero no dependen de la longitud], [aumentan con la frecuencia y con la longitud], [no dependen de la frecuencia, solo de la potencia aplicada]),
  sol: [La atenuación se da en dB por unidad de longitud: es proporcional a la longitud (el doble de cable, el doble de dB) y crece con la frecuencia, por las pérdidas en los conductores y en el dieléctrico. Por eso un mismo coaxial apenas importa en HF y pesa mucho en VHF y UHF. No disminuyen con la frecuencia, no son independientes de la longitud y, en dB, no dependen de la potencia aplicada. #no-esta[Todo cable real atenúa la señal, y la atenuación se da en decibelios por unidad de longitud. Es proporcional a la longitud (si 10 m pierden 1 dB, 30 m pierden 3 dB, o sea, la mitad de la potencia) y crece con la frecuencia: un coaxial que apenas importa en HF puede comerse media potencia en VHF o UHF. A igual frecuencia, el cable grueso pierde menos que el fino, y la línea paralela («de escalera») es la de menores pérdidas.]],
)

#q("F-T6.14", "b",
  [En un cable coaxial real, al aumentar la ROE, las pérdidas totales de la línea:],
  ([disminuyen, porque parte de la potencia vuelve al transmisor], [aumentan, porque la onda reflejada recorre la línea otra vez y se disipa más potencia], [no varían, pues solo dependen de la longitud y del tipo de cable], [se anulan, ya que la potencia reflejada no se disipa]),
  sol: [Con desadaptación, la potencia reflejada vuelve hacia el transmisor por la misma línea y la onda estacionaria concentra corrientes y tensiones mayores en ciertos puntos: todo ello se disipa en el cable como calor. Las pérdidas totales crecen respecto a la línea adaptada, y más cuanto mayor es la atenuación propia del cable (VHF y UHF, tramos largos). Que parte de la potencia vuelva al transmisor no reduce las pérdidas ni las anula, y no son independientes de la adaptación. #vease[(Véase tema T6, sección «Líneas de transmisión y adaptación».)]],
)

#q("F-T6.15", "d",
  [En una antena de media onda alimentada por un extremo, la impedancia en el punto de alimentación es:],
  ([de unos 73 Ω], [de unos 300 Ω], [prácticamente cero], [muy elevada, del orden de miles de ohmios]),
  sol: [En el extremo de un conductor la corriente es forzosamente nula y la tensión máxima. Como la impedancia es $V slash I$, en el extremo de una media onda resulta muy alta, de miles de ohmios, y hace falta un adaptador de impedancias. Los 73 Ω corresponden a alimentar el dipolo en el centro, donde la corriente es máxima; los 300 Ω, al dipolo plegado; y una impedancia casi nula sería lo propio de un punto de corriente máxima y tensión mínima, justo lo contrario. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]],
)

#q("F-T6.16", "c",
  [Una antena de media onda alimentada por uno de sus extremos presenta en el punto de alimentación una impedancia:],
  ([de unos 73 Ω, igual que si se alimentara por el centro], [de unos 36 Ω, la mitad que alimentada por el centro], [muy alta, de varios miles de ohmios], [de unos 300 Ω, cuatro veces la del centro]),
  sol: [En los extremos de una antena de media onda la corriente es nula y la tensión máxima. La impedancia es el cociente $Z = V slash I$: mucha tensión y muy poca corriente dan un valor enorme, de miles de ohmios (en el centro ocurre lo contrario y salen $tilde.op$73 Ω). Por eso una media onda alimentada en un extremo no puede conectarse directamente a 50 Ω: necesita un adaptador de impedancias, como un circuito sintonizado o un transformador. Los 36 Ω son los de la vertical de cuarto de onda, y los 300 Ω, los del dipolo plegado. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]],
)

#q("F-T6.17", "a",
  [Si se conecta un cable coaxial directamente a un dipolo de media onda, sin balun, lo más probable es que:],
  ([circulen corrientes de RF por el exterior de la malla, que pasa a radiar y deforma el diagrama de la antena], [el coaxial deje de conducir la señal hasta la antena], [la ROE sea siempre 1:1, porque el dipolo ya es simétrico], [toda la potencia se refleje hacia el transmisor]),
  sol: [El coaxial es una línea asimétrica (la malla va a masa) y el dipolo es simétrico. Sin balun la corriente no se reparte por igual entre los dos brazos: parte vuelve por el exterior de la malla, que se comporta como un elemento más de la antena. El resultado es un cable que radia, un diagrama deformado e interferencias en equipos cercanos. Los otros efectos son falsos: el coaxial sí conduce la señal, la ROE depende de la adaptación de impedancias y no de la simetría, y la reflexión no es total. #vease[(Véase tema T6, sección «Líneas de transmisión y adaptación».)] #no-esta[Un dipolo es una antena simétrica: sus dos brazos deben llevar corrientes iguales y opuestas. El coaxial es asimétrico: la corriente del conductor central vuelve por el interior de la malla. Si se conecta sin balun, el conductor central va a un brazo y la malla al otro, y la corriente puede bajar también por el exterior de la malla, que pasa a ser parte de la antena. Ese cable radia, deforma el diagrama de radiación y causa interferencias en equipos cercanos. El balun impide esas corrientes.]],
)

#q("F-T6.18", "d",
  [Se quiere adaptar una antena de 200 Ω a una línea de 50 Ω con un tramo de cuarto de onda. La impedancia característica de ese tramo debe ser:],
  ([125 Ω], [150 Ω], [12,5 Ω], [100 Ω]),
  sol: [Un cuarto de onda transforma la carga $Z_L$ en $Z_"ent" = Z_0^2 slash Z_L$. Para que la entrada sea de 50 Ω con $Z_L = 200$ Ω: $Z_0 = sqrt(Z_"ent" Z_L) = sqrt(50 dot 200) = sqrt(10 thin 000) = 100$ Ω, la media geométrica. Comprobación: $100^2 slash 200 = 50$ Ω. Los 125 Ω salen de usar la media aritmética, los 150 Ω de restar las impedancias y los 12,5 Ω de invertir la fórmula ($50^2 slash 200$). #vease[(Véase tema T6, sección «Líneas de transmisión y adaptación».)]],
)

#q("F-T6.19", "b",
  [Un tramo de línea de cuarto de onda con impedancia característica de 75 Ω, terminado en una carga de 25 Ω, presenta en su entrada una impedancia de:],
  ([25 Ω], [225 Ω], [75 Ω], [8,3 Ω]),
  sol: [Con $Z_"ent" = Z_0^2 slash Z_L$ resulta $75^2 slash 25 = 5625 slash 25 = 225$ Ω. El cuarto de onda invierte la impedancia: una carga menor que $Z_0$ se ve como mayor que $Z_0$, y al revés; $Z_0$ es la media geométrica de ambas ($sqrt(25 dot 225) = 75$). Los 25 Ω serían el resultado sin transformación, los 75 Ω confunden la entrada con $Z_0$ y los 8,3 Ω salen de dividir al revés ($25^2 slash 75$). #vease[(Véase tema T6, sección «Líneas de transmisión y adaptación».)]],
)

#q("F-T6.20", "c",
  [Una línea de cuarto de onda cortocircuitada en su extremo se comporta, vista desde el otro extremo, como:],
  ([un circuito resonante serie, de impedancia muy baja], [una resistencia igual a la impedancia característica], [un circuito resonante paralelo, de impedancia muy alta], [un condensador puro]),
  sol: [La línea de cuarto de onda invierte la impedancia: $Z_"ent" = Z_0^2 slash Z_L$ y, con $Z_L -> 0$, $Z_"ent" -> infinity$. En el extremo cortocircuitado la tensión es nula y la corriente máxima; al desfasar 90°, en la entrada hay tensión máxima y corriente mínima. Un circuito resonante paralelo presenta justo eso en resonancia: impedancia máxima. Por eso un tramo así actúa como aislante metálico o como filtro. El comportamiento serie (impedancia mínima) es el de la línea abierta. #vease[(Véase tema T6, sección «Líneas de transmisión y adaptación».)]],
)

#q("F-T6.21", "a",
  [Una línea de cuarto de onda abierta en su extremo se comporta, vista desde el otro extremo, como:],
  ([un circuito resonante serie, de impedancia muy baja], [un circuito resonante paralelo, de impedancia muy alta], [un condensador puro, de reactancia capacitiva], [una impedancia igual a la característica de la línea]),
  sol: [El circuito abierto tiene corriente nula y tensión máxima. Al desfasar 90°, la línea de cuarto de onda cambia los papeles: en la entrada aparece corriente máxima y tensión mínima, es decir, un cortocircuito aparente ($Z_"ent" = Z_0^2 slash Z_L -> 0$). Eso es lo que presenta un circuito resonante serie en resonancia: impedancia mínima. No es un condensador puro (eso ocurriría en un tramo abierto más corto que $lambda slash 4$), y la impedancia característica solo se vería con una carga igual a $Z_0$. #vease[(Véase tema T6, sección «Líneas de transmisión y adaptación».)]],
)

#q("F-T6.22", "d",
  [Un tramo de línea cortocircuitada de longitud menor que un cuarto de onda se comporta en su entrada como:],
  ([un condensador (reactancia capacitiva)], [un circuito abierto], [una resistencia pura], [una bobina (reactancia inductiva)]),
  sol: [Partiendo del cortocircuito, con longitud casi nula la entrada es un simple corto. Al alargar el tramo aparece una reactancia inductiva que crece hasta hacerse infinita en $lambda slash 4$, donde la línea se ve como circuito abierto; pasado ese punto la reactancia cambia de signo y es capacitiva hasta $lambda slash 2$. Por debajo de $lambda slash 4$ el tramo se comporta, pues, como una bobina. No es un condensador (eso ocurre entre $lambda slash 4$ y $lambda slash 2$), ni un circuito abierto (solo a $lambda slash 4$), ni una resistencia pura. #vease[(Véase tema T6, sección «Líneas de transmisión y adaptación».)] #no-esta[Una línea cortocircuitada cuya longitud es menor que $lambda slash 4$ presenta en su entrada una reactancia inductiva que crece con la longitud: con longitud casi nula es un cortocircuito y a $lambda slash 4$ se vuelve un circuito abierto aparente. Entre $lambda slash 4$ y $lambda slash 2$ la reactancia es capacitiva. En VHF y UHF estos tramos cortos de línea sustituyen a bobinas y condensadores en circuitos sintonizados y filtros. Con la línea abierta ocurre lo contrario: capacitiva por debajo de $lambda slash 4$.]],
)

#q("F-T6.23", "b",
  [Un dipolo plegado de unos 300 Ω se alimenta con cable coaxial de 75 Ω. Para adaptar las impedancias y, a la vez, pasar de línea asimétrica a antena simétrica se emplea:],
  ([un balun de relación de impedancias 1:1], [un balun de relación de impedancias 4:1], [un transformador con relación de espiras 4:1], [un filtro paso bajo entre la línea y la antena]),
  sol: [La relación de impedancias es 300/75 = 4, y además la antena es simétrica y el coaxial asimétrico. Un balun 4:1 resuelve las dos cosas: transforma la impedancia y simetriza. Uno 1:1 solo simetriza y dejaría una ROE de 4:1. Ojo: un 4:1 de impedancias equivale a espiras 2:1, porque las impedancias se transforman con el cuadrado de la relación de espiras ($Z_p = (N_p slash N_s)^2 Z_s$); con espiras 4:1 la relación de impedancias sería 16:1. El filtro paso bajo no adapta impedancias. #vease[(Véase tema T2, sección «Transformadores».)]],
)

#q("F-T6.24", "c",
  [Respecto del dipolo simple de media onda, el dipolo plegado presenta:],
  ([la misma impedancia, pero mucha más ganancia], [una impedancia unas cuatro veces mayor y menor ancho de banda], [una impedancia unas cuatro veces mayor y mayor ancho de banda], [una impedancia cuatro veces menor y mayor ancho de banda]),
  sol: [El dipolo plegado son dos conductores paralelos unidos por los extremos. Cada uno lleva la mitad de la corriente necesaria para radiar la misma potencia, así que, por $P = I^2 R$, la impedancia se multiplica por cuatro (unos 300 Ω frente a 73). Además equivale a un circuito resonante de menor factor de calidad $Q$, y por tanto de mayor ancho de banda: la ROE se mantiene baja en una franja de frecuencias más amplia. La ganancia es la misma que la del dipolo simple, y la impedancia sube, no baja. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)] #no-esta[El dipolo plegado, además de multiplicar por cuatro la impedancia, tiene más ancho de banda que el dipolo simple: se comporta como un circuito resonante de menor factor de calidad $Q$, de modo que su ROE permanece baja en una franja de frecuencias más amplia alrededor de la resonancia. Su ganancia es la misma que la del dipolo simple (2,15 dBi): la ventaja está en el ancho de banda y en los 300 Ω, que coinciden con los de la línea bifilar.]],
)

#q("F-T6.25", "a",
  [La ganancia de una antena parabólica es tanto mayor cuanto:],
  ([mayor es su diámetro en comparación con la longitud de onda], [menor es su diámetro en comparación con la longitud de onda], [mayor es la potencia aplicada al alimentador], [mayor es la longitud de onda, para un mismo diámetro]),
  sol: [La ganancia de un reflector parabólico es $G = eta (pi D slash lambda)^2$, con $eta$ la eficiencia (entre 0,5 y 0,7): crece con el cuadrado de la relación entre el diámetro $D$ y la longitud de onda $lambda$. Un mismo plato gana más al subir la frecuencia (menor $lambda$), y por eso en microondas bastan platos pequeños. La potencia del transmisor no cambia la ganancia, solo la potencia radiada. Con mayor longitud de onda y el mismo diámetro, $D slash lambda$ baja y la ganancia baja. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)] #no-esta[Una antena de apertura radia o capta a través de una superficie: la boca de una bocina o el plato de una parábola. Su ganancia es $G = 4 pi A_e slash lambda^2$, donde $A_e$ es el área efectiva. En un reflector parabólico de diámetro $D$, con $A_e$ en torno al 60 % de su área, resulta $G approx 6 (D slash lambda)^2$: a mayor diámetro o mayor frecuencia, más ganancia.]],
)

#q("F-T6.26", "b",
  [Si se duplica el diámetro de un reflector parabólico, manteniendo la frecuencia y la eficiencia, su ganancia aumenta aproximadamente:],
  ([3 dB], [6 dB], [12 dB], [nada, porque solo depende de la frecuencia]),
  sol: [La ganancia es proporcional al área del plato, es decir, a $D^2$: al duplicar $D$, el área y la ganancia se multiplican por $2^2 = 4$. En decibelios, $10 log 4 approx 6$ dB. Los 3 dB corresponderían a tratar la ganancia como proporcional a $D$ (factor 2); los 12 dB saldrían de aplicar $20 log 4$ a una relación de potencias. Con la frecuencia pasa igual: duplicarla, con el mismo plato, también da +6 dB. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)] #no-esta[La ganancia de un reflector parabólico de diámetro $D$ y eficiencia $eta$ es $G = eta (pi D slash lambda)^2$: es proporcional al área del plato. Duplicar el diámetro multiplica el área, y la ganancia, por 4 (+6 dB); duplicar la frecuencia (mitad de $lambda$) produce el mismo aumento. Una parábola típica tiene $eta$ entre 0,5 y 0,7.]],
)

#q("F-T6.27", "d",
  [En una antena parabólica de foco primario, el elemento alimentador (bocina o dipolo) se sitúa:],
  ([en el vértice del reflector, pegado a su superficie], [en el borde del reflector], [detrás del reflector, para que no haga sombra], [en el foco del reflector, frente al plato]),
  sol: [La parábola refleja hacia un único punto, el foco, todos los rayos que llegan paralelos a su eje. En recepción el reflector concentra allí la onda captada; en emisión, el alimentador colocado en el foco ilumina el plato y este forma un haz estrecho con todos los rayos en fase. Situado en el vértice, en el borde o detrás del reflector, la onda no converge en el alimentador y se pierde ganancia. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)] #no-esta[Un reflector parabólico concentra en un punto, el foco, todos los rayos que llegan paralelos a su eje; y una fuente situada en el foco produce, tras reflejarse, un haz paralelo. Por eso el alimentador (una bocina o un dipolo, que ilumina el plato) se coloca en el foco, delante del reflector en las antenas de foco primario. Si se desplaza del foco, el haz se deforma y la ganancia disminuye.]],
)

== Tema T7. Propagación <apc2-sec-t7>

#q("F-T7.1", "c",
  [En un enlace en espacio libre, con la misma potencia transmitida y el mismo ruido en el receptor, al multiplicar por 10 la distancia la relación señal/ruido:],
  ([disminuye 10 dB], [no varía, porque la señal y el ruido se atenúan por igual], [disminuye 20 dB], [disminuye 40 dB]),
  sol: [En espacio libre la potencia recibida cae con $1 slash d^2$: la atenuación en decibelios crece como $20 log_10 d$. Al multiplicar la distancia por 10 son $20 log 10 = 20$ dB de señal menos (doblar la distancia son 6 dB). El ruido del receptor no depende de la distancia, así que la relación señal/ruido empeora esos mismos 20 dB. Los 10 dB saldrían de usar $10 log d$; los 40 dB corresponderían a una potencia que cayera como $1 slash d^4$; y el ruido no se atenúa con la señal, pues lo genera el propio receptor y el entorno. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]],
)

#q("F-T7.2", "a",
  [La propagación por esporádica-E se debe a:],
  ([nubes de ionización muy intensa que aparecen en la capa E], [inversiones de temperatura en la troposfera, que forman un conducto], [la reflexión de las ondas en la superficie de la Luna], [las estelas ionizadas que dejan los meteoros]),
  sol: [La esporádica-E (_Es_) aparece cuando se forman, de modo irregular, nubes de ionización intensa en la capa E, a unos 100 km de altura. Esas nubes reflejan señales de VHF (sobre todo 50 MHz y, a veces, 144 MHz) que normalmente atravesarían la ionosfera. La inversión de temperatura produce conductos troposféricos, la reflexión lunar es el EME y las estelas de los meteoros dan el meteor-scatter: son otros mecanismos, cada uno con su propia física. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]],
)

#q("F-T7.3", "c",
  [En un contacto por esporádica-E con un solo salto, las señales de VHF llegan a distancias típicas de:],
  ([10 a 50 km], [100 a 300 km], [1000 a 2000 km], [más de 10~000 km]),
  sol: [La nube de esporádica-E está a unos 100 km de altura. Un rayo que sale casi rasante y rebota en ella cae muy lejos: la geometría limita un único salto a poco más de 2000 km como máximo, y los contactos típicos son de 1000 a 2000 km. Distancias de decenas o pocos centenares de kilómetros corresponden a la onda directa o a los conductos troposféricos, y los 10~000 km o más quedan para HF con varios saltos por la capa F. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]],
)

#q("F-T7.4", "d",
  [En el hemisferio norte, la esporádica-E en VHF es más frecuente en:],
  ([los meses de invierno, con las noches más largas], [primavera y otoño, en los equinoccios], [todas las estaciones por igual], [los meses de verano]),
  sol: [La esporádica-E tiene una marcada estacionalidad. En el hemisferio norte su temporada principal es el verano (de mayo a agosto, con máximo hacia junio–julio), y existe un pico secundario y mucho más débil hacia diciembre–enero. Por eso en verano se abre con frecuencia la banda de 50 MHz y, a veces, la de 144 MHz. No es una cuestión de equinoccios (eso es más propio de la capa F2) ni es uniforme a lo largo del año. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]],
)

#q("F-T7.5", "d",
  [La reflexión auroral se produce en:],
  ([la superficie de la Luna], [las capas de aire cálido de la troposfera], [las estelas de los meteoros], [las cortinas de ionización de las auroras]),
  sol: [Las auroras boreales son zonas de la alta atmósfera, hacia los 100 km de altura y en latitudes altas, ionizadas con intensidad por partículas procedentes del Sol. Esas cortinas ionizadas reflejan las ondas de VHF como un espejo irregular y cambiante. La Luna es el reflector del EME, las capas de aire cálido forman conductos por inversión térmica y las estelas de los meteoros dan el meteor-scatter: ninguno tiene que ver con las auroras. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]],
)

#q("F-T7.6", "a",
  [Las señales que llegan por reflexión auroral se caracterizan por:],
  ([sonar ásperas y distorsionadas, con desvanecimientos rápidos; la telegrafía resulta la más eficaz], [sonar limpias y estables, pues la cortina auroral actúa como un reflector fijo], [desvanecerse muy despacio, en ciclos de varios minutos, con audio nítido], [ir mejor en fonía que en telegrafía, porque la aurora no afecta a la voz]),
  sol: [La cortina auroral es un reflector ionizado que se mueve y se agita sin parar. Cada rayo llega con desfases y desplazamientos de frecuencia distintos, así que el espectro de la señal se ensancha: la voz suena ronca y áspera y el desvanecimiento es rápido. La telegrafía tolera esa degradación mucho mejor que la fonía, por eso es el modo preferido. Un reflector fijo daría audio limpio y estable, y eso no ocurre con las auroras. #vease[(Véase tema T7, sección «Fenómenos de propagación».)] #no-esta[Las señales reflejadas en una aurora suenan roncas y distorsionadas (_raspy_): la cortina ionizada se mueve sin parar y ensancha el espectro de la señal, con desvanecimientos rápidos. La fonía pierde inteligibilidad y el modo más eficaz es la telegrafía. Se da en VHF, sobre todo en 50 y 144 MHz, cerca de las latitudes altas, y las dos estaciones apuntan sus antenas hacia el norte (hacia la aurora) y no hacia el corresponsal.]],
)

#q("F-T7.7", "b",
  [La propagación por meteor-scatter se basa en:],
  ([la reflexión de las ondas en la superficie de la Luna], [la reflexión en las estelas ionizadas que dejan los meteoros al entrar en la atmósfera], [el guiado de las ondas por conductos de la troposfera], [la reflexión en nubes de ionización intensa de la capa E]),
  sol: [Un meteoro que entra en la atmósfera a gran velocidad, hacia los 100 km de altura, deja una estela de gas ionizado que, durante un instante, refleja las ondas de VHF como un pequeño espejo. Eso permite enlaces de unos cientos a dos mil kilómetros en 50 y 144 MHz, sobre todo durante las lluvias de meteoros. La Luna es el reflector del EME, los conductos son cosa de la troposfera y las nubes de la capa E dan la esporádica-E. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]],
)

#q("F-T7.8", "d",
  [Los contactos por meteor-scatter se caracterizan porque las señales llegan:],
  ([de forma continua y estable durante horas], [solo durante el día, cuando hay más ionización], [con desvanecimientos muy lentos, de varios minutos], [en ráfagas breves, de fracciones de segundo a pocos segundos]),
  sol: [La estela ionizada de un meteoro se forma en un instante y se disipa enseguida: la señal llega en ráfagas que duran de fracciones de segundo a unos pocos segundos, separadas por silencios. Por eso se usan modos rápidos, como la telegrafía a alta velocidad o los modos digitales de ráfaga, capaces de aprovechar cada instante. No hay señal continua ni estable, y funciona a cualquier hora, con más ráfagas de madrugada y durante las lluvias de meteoros. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]],
)

#q("F-T7.9", "a",
  [El flujo solar medido a 10,7 cm es:],
  ([un índice de la actividad solar que sirve para estimar la ionización y la MUF], [el número de manchas solares contadas cada día en el disco del Sol], [la altura en kilómetros a la que se encuentra la capa F], [la intensidad del campo magnético terrestre, que se mide con el índice K]),
  sol: [El flujo solar de 10,7 cm es la intensidad de la radioemisión del Sol en esa longitud de onda ($f = 300 slash 0,107 approx 2800$ MHz). Se mide desde tierra y se correlaciona con las manchas solares y con la ionización de las capas: flujo alto, más ionización y MUF más alta. No es el número de manchas (otro índice, aunque relacionado), ni una altura, ni el campo magnético, que miden los índices geomagnéticos A y K. #vease[(Véase tema T7, sección «Cómo se nombran las bandas» (párrafo final sobre la predicción de propagación).)]],
)

#q("F-T7.10", "b",
  [Cuando aumenta la actividad solar (más manchas solares), la MUF suele:],
  ([bajar, porque el exceso de ionización deja de reflejar las ondas de HF], [subir, y bandas altas como la de 28 MHz se abren al DX con más frecuencia], [permanecer igual, pues solo depende de la hora del día], [subir, pero solo beneficia a las bandas bajas de 160 y 80 m]),
  sol: [Más manchas solares significan más radiación ultravioleta y X, luego más electrones libres y una frecuencia de plasma más alta ($f_p approx 9 sqrt(N_e)$). Con ello sube la MUF y la ionosfera refleja frecuencias mayores: en los máximos del ciclo de once años se abren con frecuencia 15, 12 y 10 m. No baja (más ionización no impide reflejar), no es independiente del Sol y no favorece a las bandas bajas, que dependen sobre todo de la absorción de la capa D y de la noche. #vease[(Véase tema T7, sección «Cómo se nombran las bandas» (párrafo final sobre la predicción de propagación).)]],
)

#q("F-T7.11", "a",
  [Un programa de predicción de propagación, como VOACAP, calcula a partir de los índices solares, la fecha y la hora:],
  ([la MUF de cada trayecto y qué bandas tienen probabilidad de estar abiertas], [la relación de ondas estacionarias de la antena en cada banda], [las pérdidas de los cables coaxiales en función de su longitud], [la potencia máxima autorizada en cada banda de aficionado]),
  sol: [Los programas de predicción (VOACAP y similares) toman los índices de actividad solar, la fecha, la hora y las posiciones de las dos estaciones, y simulan la ionosfera para obtener la MUF y la FOT del trayecto, y qué bandas y horas serán favorables. No calculan magnitudes de la estación como la ROE o las pérdidas del cable, que dependen del equipo, ni límites legales como la potencia autorizada, que fija la normativa. #vease[(Véase tema T7, sección «Cómo se nombran las bandas» (párrafo final sobre la predicción de propagación).)]],
)

#q("F-T7.12", "c",
  [A igual distancia, al pasar de 144 MHz a 432 MHz la pérdida en espacio libre aumenta aproximadamente:],
  ([4,8 dB], [6 dB], [9,5 dB], [19 dB]),
  sol: [La pérdida en espacio libre es $L = 32,4 + 20 log f + 20 log d$ (con $f$ en MHz y $d$ en km). Con la distancia fija solo cambia el término de la frecuencia: $Delta L = 20 log(432 slash 144) = 20 log 3 = 20 times 0,477 approx 9,5$ dB. Los 6 dB serían por doblar la frecuencia, no triplicarla; 4,8 dB resultan de usar 10 log en lugar de 20 log, y 19 dB de usar 40 log, es decir, de elevar al cuadrado de más. #vease[(Véase tema T7, sección «Fenómenos de propagación» (pérdida en espacio libre).)]],
)

#q("F-T7.13", "b",
  [Si la MUF de un trayecto es de 20 MHz, la frecuencia óptima de trabajo (FOT) es aproximadamente de:],
  ([12 MHz], [17 MHz], [20 MHz], [24 MHz]),
  sol: [La frecuencia óptima de trabajo es aproximadamente el 85 % de la MUF: FOT ≈ 0,85 × 20 = 17 MHz. Se trabaja algo por debajo de la MUF para tolerar las fluctuaciones de la ionosfera, que en un momento dado pueden bajarla y cortar el enlace. 20 MHz sería la propia MUF, sin margen; 24 MHz sale de dividir entre 0,85 en vez de multiplicar, y 12 MHz de aplicar un 60 % que no es el de la regla. #vease[(Véase tema T7, sección «La ionosfera y la onda de espacio».)]],
)

#q("F-T7.14", "b",
  [Dos estaciones de VHF, con las antenas a 9 m y a 16 m de altura sobre terreno llano, alcanzan por onda directa una distancia máxima aproximada de:],
  ([21 km], [29 km], [49 km], [103 km]),
  sol: [El horizonte radioeléctrico suma el de cada antena: $d approx 4,12 (sqrt(h_1) + sqrt(h_2)) = 4,12 (sqrt(9) + sqrt(16)) = 4,12 times (3 + 4) approx 29$ km. Los errores típicos son meter la raíz sobre la suma, $4,12 sqrt(25) approx 21$ km; sobre el producto, $4,12 sqrt(9 dot 16) approx 49$ km, o no sacar raíces, $4,12 times 25 approx 103$ km. Se suman las raíces de las alturas, no las alturas. #vease[(Véase tema T7, sección «La ionosfera y la onda de espacio».)]],
)

#q("F-T7.15", "c",
  [Al cuadruplicar la altura de una antena de VHF, la distancia hasta su horizonte radioeléctrico:],
  ([se multiplica por 16], [se cuadruplica], [se duplica], [aumenta solo un 41 %]),
  sol: [El alcance al horizonte crece con la raíz cuadrada de la altura: $d approx 4,12 sqrt(h)$. Si $h$ se multiplica por 4, $d$ se multiplica por $sqrt(4) = 2$: se duplica. Por ejemplo, de 10 m a 40 m pasa de unos 13 km a unos 26 km. Cuadruplicarse o multiplicarse por 16 supondría una relación lineal o cuadrática con la altura, que no existe; el 41 % ($sqrt(2)$) correspondería a duplicar la altura, no a cuadruplicarla. #vease[(Véase tema T7, sección «La ionosfera y la onda de espacio».)]],
)

#q("F-T7.16", "c",
  [En condiciones normales, el horizonte radioeléctrico es:],
  ([algo menor que el horizonte óptico, porque la troposfera absorbe parte de la señal], [exactamente igual al horizonte óptico, porque la onda viaja en línea recta], [algo mayor que el horizonte óptico, porque la troposfera curva el rayo hacia el suelo], [muy superior al óptico, porque la ionosfera devuelve la onda a tierra]),
  sol: [La densidad del aire disminuye con la altura, así que el índice de refracción de la troposfera también decrece y el rayo se curva ligeramente hacia el suelo, siguiendo a la Tierra. Resultado: el horizonte radioeléctrico supera al óptico en torno a un 15 % (la fórmula pasa de $3,57 sqrt(h)$ a $4,12 sqrt(h)$ kilómetros, con $h$ en metros). No es menor ni igual, y en VHF la ionosfera no interviene: es transparente. #vease[(Véase tema T7, sección «La ionosfera y la onda de espacio».)]],
)

#q("F-T7.17", "b",
  [La propagación por conducto troposférico se aprovecha sobre todo en:],
  ([HF, con contactos intercontinentales por reflexión en la capa F], [VHF y UHF, con alcances de cientos de kilómetros, muy superiores al horizonte visual], [MF, con un alcance limitado a la onda de superficie], [VHF y UHF, pero solo para comunicaciones locales de pocos kilómetros]),
  sol: [El conducto es una capa de aire en la que la onda queda atrapada y guiada, como en una guía de ondas natural. Funciona con VHF, UHF y frecuencias superiores, y permite contactos de varios cientos de kilómetros, bastante más allá del horizonte visual, aunque de forma esporádica. La HF (a) llega lejos por reflexión en la ionosfera, no en la troposfera; en MF (c) domina la onda de superficie; y el alcance de pocos kilómetros (d) es el normal sin conducto, justo el que este supera. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]],
)

#q("F-T7.18", "c",
  [Un conducto troposférico se forma cuando en la troposfera existe:],
  ([una capa de aire frío sobre otra de aire cálido, como ocurre habitualmente], [una nube de ionización intensa en la capa E], [una inversión de temperatura: una capa de aire cálido situada sobre aire más frío], [una intensa actividad de manchas solares]),
  sol: [En condiciones normales el aire se enfría con la altura. En una inversión de temperatura, una capa de aire cálido queda sobre aire más frío, y el cambio brusco del índice de refracción curva la onda hacia el suelo una y otra vez: queda atrapada entre la capa y la superficie, como en una guía de ondas. La situación habitual (a) no forma conductos. Las nubes de ionización de la capa E (b) son la esporádica-E, un fenómeno ionosférico, y las manchas solares (d) actúan sobre la ionosfera, no sobre la troposfera. #vease[(Véase tema T7, sección «Fenómenos de propagación».)] #no-esta[Una inversión de temperatura se da cuando, en vez de enfriarse con la altura, el aire se calienta: una capa de aire cálido queda sobre aire más frío, cerca del suelo. El cambio brusco en el índice de refracción del aire curva la onda hacia la Tierra y la mantiene atrapada entre la capa y la superficie, igual que en una guía de ondas. Así nace la propagación por conducto, que lleva las señales de VHF y UHF a cientos de kilómetros.]],
)

#q("F-T7.19", "a",
  [La propagación por conducto troposférico es más probable con:],
  ([tiempo anticiclónico estable, con altas presiones y poco viento], [borrascas con viento fuerte, que mezclan las capas de aire], [un máximo del ciclo solar, con abundantes manchas], [lluvia intensa y tormentas eléctricas]),
  sol: [La inversión de temperatura se forma y se mantiene cuando el aire está en calma: por eso los conductos aparecen con situaciones anticiclónicas estables (altas presiones y poco viento). Las borrascas y los temporales (b) mezclan el aire y destruyen las capas, y la lluvia intensa o las tormentas (d) no producen una inversión estable. El ciclo solar (c) influye en la ionosfera, es decir, en la propagación en HF, no en la troposfera. #vease[(Véase tema T7, sección «Fenómenos de propagación».)] #no-esta[Los conductos troposféricos aparecen con tiempo estable. En situaciones anticiclónicas (altas presiones y poco viento) el aire no se mezcla y se forman capas con inversión de temperatura, que pueden durar horas o días. Por eso el DX de VHF y UHF por conducto se da sobre todo con anticiclones persistentes, y desaparece cuando llega una borrasca con viento, que vuelve a mezclar las capas de aire.]],
)

== Tema T8. Medidas <apc2-sec-t8>

#q("F-T8.1", "d",
  [Un frecuencímetro digital cuenta los ciclos de la señal durante un tiempo de puerta de 0,1 s. Su resolución es de:],
  ([100 Hz], [1 Hz], [0,1 Hz], [10 Hz]),
  sol: [La resolución de un frecuencímetro es el inverso del tiempo de puerta, porque solo distingue ciclos enteros dentro de esa ventana: 1/0,1 s = 10 Hz. Con 1 s de puerta sería 1 Hz (b) y con 10 s, 0,1 Hz (c): más tiempo de puerta, más resolución, aunque la medida tarda más. Con 0,1 s se cuentan menos ciclos y se resuelve peor. Resultados como 100 Hz (a) salen de errar una potencia de diez al invertir. #vease[(Véase tema T8, sección «Instrumentos».)]],
)

#q("F-T8.2", "c",
  [En un osciloscopio con la base de tiempos ajustada a 0,5 ms/div, un ciclo completo de la señal ocupa 4 divisiones horizontales. Su frecuencia es de:],
  ([2 kHz], [250 Hz], [500 Hz], [8 kHz]),
  sol: [El período es $T = 4 "div" times 0,5 "ms/div" = 2 "ms"$, y la frecuencia es su inversa: $f = 1 slash T = 1 slash 0,002 "s" = 500$ Hz. Usar solo la base de tiempos, 1/0,5 ms = 2 kHz (a), olvida multiplicar por las divisiones; 4/0,5 ms = 8 kHz (d) multiplica en lugar de dividir; y 250 Hz (b) correspondería a un ciclo de 8 divisiones, no de 4. #vease[(Véase tema T8, sección «Instrumentos».)] #no-esta[En la pantalla del osciloscopio el eje horizontal es el tiempo, y cada división (div) de la cuadrícula equivale a un valor que se fija con la base de tiempos, en ms/div. Para hallar el período se cuentan las divisiones que ocupa un ciclo y se multiplican por ese valor: $T = "divisiones" times "base de tiempos"$. La frecuencia es la inversa del período, $f = 1 slash T$.]],
)

#q("F-T8.3", "a",
  [Con la sensibilidad vertical de un osciloscopio ajustada a 2 V/div, una sinusoide ocupa 6 divisiones de pico a pico. Su tensión de pico a pico es de:],
  ([12 V], [3 V], [6 V], [24 V]),
  sol: [La sensibilidad vertical es la tensión que corresponde a cada división, de modo que $V_"pp" = 6 "div" times 2 "V/div" = 12$ V. El valor de pico sería la mitad, 6 V (c). Los 3 V (b) resultan de dividir el número de divisiones entre la sensibilidad en lugar de multiplicar, y los 24 V (d) duplican otra vez el resultado al confundir el pico con el pico a pico. #vease[(Véase tema T8, sección «Instrumentos».)] #no-esta[El eje vertical del osciloscopio mide tensión, y cada división equivale a un valor que se fija con la sensibilidad vertical, en V/div. Para leer la tensión se cuentan las divisiones que ocupa la señal y se multiplican por ese valor. Medida de pico a pico da $V_"pp"$; la mitad es el valor de pico $V_"p"$, y en una sinusoide el valor eficaz es $V_"p" slash sqrt(2)$.]],
)

#q("F-T8.4", "d",
  [Con la sensibilidad vertical de un osciloscopio en 1 V/div, una sinusoide ocupa 4 divisiones de pico a pico. Su valor eficaz es aproximadamente de:],
  ([4 V], [2 V], [2,83 V], [1,41 V]),
  sol: [Primero el pico a pico: $V_"pp" = 4 "div" times 1 "V/div" = 4$ V. El valor de pico es la mitad, $V_"p" = 2$ V, y el eficaz de una sinusoide es $V_"p" slash sqrt(2) = 2 slash 1,414 approx 1,41$ V. Los 4 V (a) son el pico a pico y los 2 V (b), el pico. Los 2,83 V (c) salen de dividir el pico a pico entre $sqrt(2)$, olvidando pasar antes de pico a pico a pico. #vease[(Véase tema T8, sección «Instrumentos».)] #no-esta[En el eje vertical del osciloscopio, cada división equivale a un valor fijado con la sensibilidad vertical, en V/div: la tensión leída es el número de divisiones por ese valor. Si se mide de pico a pico se obtiene $V_"pp"$; el valor de pico es $V_"p" = V_"pp" slash 2$, y el valor eficaz de una sinusoide es $V_"ef" = V_"p" slash sqrt(2) approx 0,707 V_"p"$.]],
)

#q("F-T8.5", "b",
  [Un analizador de espectros, a diferencia de un osciloscopio, muestra en pantalla:],
  ([la tensión instantánea de la señal en función del tiempo, es decir, su forma de onda], [el nivel de cada componente de la señal (portadora, bandas laterales, armónicos) en función de su frecuencia], [la ROE de la antena en función de la longitud de la línea], [la resistencia y la capacidad de los componentes conectados a su entrada]),
  sol: [El analizador trabaja en el dominio de la frecuencia: descompone la señal y dibuja el nivel de cada componente (portadora, bandas laterales, armónicos, espurias) en su frecuencia. El osciloscopio trabaja en el dominio del tiempo y muestra la tensión instantánea, la forma de onda (a), que no separa con claridad los armónicos. La ROE (c) la mide un medidor de ROE o un vatímetro direccional, y la resistencia de un componente (d), un óhmetro o un puente. #vease[(Véase tema T8, sección «Instrumentos».)]],
)

#q("F-T8.6", "c",
  [Para medir el nivel de los armónicos y de las emisiones espurias de un transmisor se utiliza:],
  ([un vatímetro direccional], [un frecuencímetro], [un analizador de espectros], [un polímetro en la escala de tensión alterna]),
  sol: [Un armónico es una componente cuya frecuencia es múltiplo de la fundamental. El analizador de espectros dibuja cada componente en su frecuencia, con su nivel respecto de la portadora, y permite comprobar que armónicos y espurias quedan dentro de los límites. El vatímetro direccional (a) mide la potencia directa y reflejada de toda la señal, sin separar componentes. El frecuencímetro (b) cuenta ciclos y da la frecuencia de la portadora, no el nivel de los armónicos. El polímetro (d) no responde en radiofrecuencia. #vease[(Véase tema T8, sección «Instrumentos».)]],
)

#q("F-T8.7", "b",
  [Un divisor de tensión formado por dos resistencias de 10 kΩ se alimenta con 12 V. Si se mide la tensión de una de ellas con un voltímetro de 10 kΩ de resistencia interna, la lectura será de:],
  ([6 V], [4 V], [3 V], [8 V]),
  sol: [Sin voltímetro, cada resistencia tendría 6 V. El voltímetro se conecta en paralelo: 10 kΩ $parallel$ 10 kΩ = 5 kΩ, así que el total es 15 kΩ y la tensión en esa parte vale 12 × 5/15 = 4 V. Es el error de carga: el instrumento deriva corriente y falsea la medida, por eso un voltímetro debe tener resistencia interna mucho mayor que la del circuito. Los 6 V (a) serían la lectura de un voltímetro ideal; 8 V (d) es la tensión de la otra resistencia. #vease[(Véase tema T8, sección «Técnica de medida».)]],
)

#q("F-T8.8", "a",
  [Un polímetro convencional, calibrado para sinusoides y que no es de «verdadero valor eficaz» (_true RMS_), mide una tensión alterna de forma cuadrada. Su lectura:],
  ([puede ser errónea: rectifica, promedia y multiplica por el factor de forma de la sinusoide (1,11), que solo vale para esa forma de onda], [coincide siempre con el valor eficaz real, sea cual sea la forma de onda], [indica directamente el valor de pico a pico de la señal], [es siempre nula, porque la onda cuadrada no tiene componente alterna]),
  sol: [Un polímetro común no calcula el valor eficaz: rectifica la señal, promedia y multiplica por 1,11, el factor de forma de una sinusoide. Con una onda cuadrada simétrica el resultado sale un 11 % alto, porque el promedio rectificado ya coincide con el valor eficaz y no hace falta ningún factor. Solo un instrumento de verdadero valor eficaz mide bien formas de onda no sinusoidales (b es falsa). Tampoco da el pico a pico (c), y la onda cuadrada sí es alterna, con lo que la lectura no es cero (d). #vease[(Véase tema T8, sección «Técnica de medida».)]],
)

#q("F-T8.9", "d",
  [Un polímetro de uso general no es adecuado para medir tensiones de radiofrecuencia porque:],
  ([solo puede medir corriente continua], [su resistencia interna es tan baja que cortocircuita la señal], [la radiofrecuencia no produce ninguna tensión medible], [su respuesta en frecuencia en alterna es muy limitada (pocos llegan a decenas de kHz) y la lectura deja de ser fiable]),
  sol: [La escala de alterna de un polímetro común está pensada para la red y el audio: su respuesta en frecuencia es limitada y, al subir, la lectura pierde exactitud hasta dejar de tener sentido; pocos llegan siquiera a decenas de kHz. Para RF se usan sondas detectoras o voltímetros de RF específicos. Sí mide alterna (a), la RF produce tensiones perfectamente medibles (c) y su resistencia interna es alta, no baja (b), unos 10 MΩ en el digital. #vease[(Véase tema T8, sección «Técnica de medida».)]],
)

#q("F-T8.10", "b",
  [Con un osciloscopio se mide, en el máximo de la envolvente de una señal de SSB, una tensión de pico de 100 V sobre una carga artificial de 50 Ω. La potencia en la cresta de la envolvente (p.c.e.) es de:],
  ([200 W], [100 W], [141 W], [50 W]),
  sol: [La p.c.e. es la potencia media de un ciclo de RF en el máximo de la envolvente. Con tensión de pico $V_"p" = 100$ V, la eficaz es $V_"p" slash sqrt(2) = 70,7$ V y $P = V_"ef"^2 slash R = 70,7^2 slash 50 = 100$ W; equivale a $V_"p"^2 slash (2 R) = 10 thin 000 slash 100$. Los 200 W (a) resultan de usar el pico como si fuera eficaz ($V_"p"^2 slash R$), los 141 W (c) de mezclar pico y eficaz ($V_"p" dot I_"ef"$) y los 50 W (d) de dividir entre 2 dos veces. #vease[(Véase tema T8, sección «Técnica de medida».)] #no-esta[Para medir la p.c.e. con un osciloscopio se conecta el transmisor a una carga artificial de resistencia $R$ y se lee la tensión de pico $V_"p"$ en el máximo de la envolvente. Como la tensión eficaz de ese ciclo es $V_"p" slash sqrt(2)$, la p.c.e. vale $V_"p"^2 slash (2 R)$. Con la lectura de pico a pico, $V_"pp"^2 slash (8 R)$. Sobre 50 Ω, 100 V de pico son 100 W.]],
)

#q("F-T8.11", "c",
  [Un polímetro analógico tiene una sensibilidad de 20 kΩ/V. En la escala de 10 V, su resistencia de entrada es de:],
  ([2 kΩ], [20 kΩ], [200 kΩ], [10 MΩ]),
  sol: [La sensibilidad, en Ω/V, dice cuántos ohmios de resistencia de entrada hay por cada voltio de fondo de escala: $R_"ent" = 20 "kΩ/V" times 10 "V" = 200 "kΩ"$. Cambia con la escala (en 100 V serían 2 MΩ). Los 20 kΩ (b) son la sensibilidad, no la resistencia; los 2 kΩ (a) salen de dividir en vez de multiplicar; y los 10 MΩ (d) son la entrada fija típica de un polímetro digital, que carga mucho menos al circuito. #vease[(Véase tema T8, sección «Instrumentos».)] #no-esta[La sensibilidad de un polímetro analógico se da en ohmios por voltio (Ω/V): su resistencia de entrada en una escala de tensión es la sensibilidad multiplicada por el fondo de escala (20 kΩ/V en 10 V: 200 kΩ). Varía con la escala y, al ser relativamente baja, carga los circuitos de alta impedancia. El polímetro digital presenta una resistencia de entrada fija, típicamente 10 MΩ en todas las escalas de tensión, y por eso carga mucho menos.]],
)

== Tema T9. Interferencia e inmunidad <apc2-sec-t9>

#q("F-T9.1", "a",
  [Un receptor cercano a un transmisor potente pierde sensibilidad (las señales débiles se hunden) aunque esté sintonizado en otra frecuencia, y no aparecen señales nuevas en ninguna parte del dial. Este efecto se denomina:],
  ([bloqueo o desensibilización], [intermodulación de tercer orden], [detección en circuitos de audio], [recepción por la frecuencia imagen]),
  sol: [Es el bloqueo o desensibilización: el campo intenso del transmisor satura las primeras etapas del receptor, que reduce su ganancia efectiva y deja hundidas a las señales débiles, sin crear señales nuevas. La intermodulación (b) sí las crea: mezcla dos señales intensas en una etapa no lineal y genera productos como $2 f_1 - f_2$. La detección en audio (c) haría oír la voz del transmisor por el altavoz. Y la frecuencia imagen (d) es una emisora que entra por una frecuencia separada del doble de la FI de la sintonizada y se oye como si fuera la deseada. #vease[(Véase tema T9, sección «Causas de interferencia».)]],
)

#q("F-T9.2", "d",
  [Un receptor pierde sensibilidad (bloqueo) mientras transmite una estación próxima, aunque esté sintonizado en otra frecuencia. Una medida eficaz para reducir el problema es:],
  ([añadir un preamplificador de antena para recuperar la señal débil], [acercar la antena del receptor a la del transmisor para recibir más señal], [desconectar la toma de tierra del receptor], [intercalar en la entrada del receptor un filtro que atenúe la señal del transmisor próximo, o reducir la potencia de este]),
  sol: [El bloqueo aparece porque la señal intensa del transmisor próximo satura las primeras etapas del receptor (amplificador de RF y mezclador) y baja su ganancia para todas las demás, aunque estén lejos en frecuencia. El remedio es que esa señal llegue con menos nivel: un filtro en la entrada de antena (de rechazo o paso de banda), menos potencia en el transmisor o más separación entre antenas. El preamplificador y acercar las antenas suben el nivel de la señal fuerte y agravan la saturación. Quitar la tierra no atenúa nada de lo que entra por la antena; una buena tierra, al contrario, ayuda a reducir la RF en los chasis. #vease[(Véase tema T9, secciones «Causas de interferencia» y «Medidas correctoras».)] #no-esta[Síntoma del bloqueo: mientras transmite una estación próxima, aunque lo haga en otra frecuencia, el receptor pierde sensibilidad y las señales débiles se hunden; al cesar la emisión, todo vuelve a la normalidad. La causa es la saturación de las primeras etapas por un campo intenso. Remedios: un filtro de rechazo o de paso de banda en la entrada de antena del receptor, reducir la potencia del transmisor o aumentar la separación entre antenas. Más ganancia de RF o un preamplificador empeoran el bloqueo.]],
)

#q("F-T9.3", "b",
  [Dos señales de 14,100 MHz y 14,200 MHz entran en una etapa no lineal. Uno de los productos de intermodulación de tercer orden aparece en:],
  ([28,300 MHz], [14,000 MHz], [14,150 MHz], [0,100 MHz]),
  sol: [Los productos de tercer orden son $2 f_1 - f_2$ y $2 f_2 - f_1$. Con $f_1 = 14,100$ MHz y $f_2 = 14,200$ MHz: $2 f_1 - f_2 = 28,200 - 14,200 = 14,000$ MHz y $2 f_2 - f_1 = 28,400 - 14,100 = 14,300$ MHz. Caen a solo 100 kHz de las señales originales, por eso son tan molestos y casi imposibles de filtrar. Los 14,150 MHz son la media de las dos frecuencias, que no es producto de ningún orden. 28,300 MHz ($f_1 + f_2$) y 0,100 MHz ($f_2 - f_1$) son productos de segundo orden: caen lejos de las señales y se filtran con facilidad. #vease[(Véase tema T9, sección «Causas de interferencia».)]],
)

#q("F-T9.4", "a",
  [En espacio libre y lejos de una antena transmisora, al duplicar la distancia a ella la intensidad de campo eléctrico (V/m):],
  ([se reduce a la mitad], [se reduce a la cuarta parte], [se reduce a $1 slash sqrt(2)$ de su valor], [se duplica]),
  sol: [En el espacio libre la potencia se reparte sobre una superficie esférica: la densidad de potencia cae con $1 slash d^2$ y el campo, proporcional a la raíz cuadrada de esa densidad, cae con $1 slash d$. Con $d' = 2 d$ resulta $E' = E slash 2$ (6 dB menos). «La cuarta parte» es lo que le pasa a la densidad de potencia, no al campo. $1 slash sqrt(2)$ mezcla la raíz con los 3 dB de la potencia. Duplicarse sería lo contrario: el campo disminuye al alejarse. Por eso separar las antenas reduce el campo que recibe el equipo afectado. #vease[(Véase tema T7, introducción del capítulo (antes de la sección «La ionosfera y la onda de espacio»).)]],
)

#q("F-T9.5", "c",
  [Si se multiplica por 4 la potencia radiada por una antena, la intensidad de campo (V/m) a una distancia dada en espacio libre se:],
  ([cuadruplica], [multiplica por 16], [duplica], [multiplica por $sqrt(2)$]),
  sol: [A distancia fija, la densidad de potencia es $S = E^2 slash 377$, luego $E = sqrt(377 S)$: el campo es proporcional a la raíz cuadrada de la potencia radiada. Con potencia por 4: $E' = sqrt(4) E = 2 E$. En decibelios coincide: $10 log 4 approx 6$ dB en potencia y $20 log 2 approx 6$ dB en campo. «Se cuadruplica» confunde campo con potencia; «por 16» eleva al cuadrado en lugar de extraer la raíz; $sqrt(2)$ es el efecto de duplicar la potencia (3 dB), no de cuadruplicarla. #vease[(Véase tema T7, introducción del capítulo (antes de la sección «La ionosfera y la onda de espacio»).)] #no-esta[La densidad de potencia y el campo se relacionan por $S = E^2 slash 377$ (con $S$ en W/m² y $E$ en V/m), así que, a una distancia dada, el campo es proporcional a la raíz cuadrada de la potencia: en espacio libre $E = sqrt(30 P G) slash d$. Duplicar la potencia multiplica el campo por $sqrt(2)$ (3 dB); cuadruplicarla lo duplica (6 dB). Un campo mayor en las inmediaciones aumenta el riesgo de bloqueo en los equipos vecinos.]],
)

== Tema R2. Código Q <apc2-sec-r2>

#q("F-R2.1", "b",
  [El grupo #_apc2-m[QTR] se utiliza para dar o pedir:],
  ([la posición de la estación], [la hora exacta], [el nombre de la estación], [la distancia entre las estaciones]),
  sol: [#_apc2-m[QTR] es la hora exacta: con interrogación (#_apc2-m[QTR?]) se pregunta «¿cuál es la hora exacta?» y, como respuesta, se dice «la hora exacta es…». Los distractores son otros grupos de las tablas: #_apc2-m[QTH] es la posición o localidad de la estación, #_apc2-m[QRA] es el nombre de la estación y #_apc2-m[QRB] es la distancia entre estaciones. Para recordarlo: la R de #_apc2-m[QTR] es de «reloj». #vease[(Véase tema R2, tabla «Grupos del código Q más frecuentes en el Servicio de Aficionados».)]],
)

#q("F-R2.2", "c",
  [El grupo #_apc2-m[QRY], como pregunta, equivale a:],
  ([¿cuál es mi frecuencia exacta?], [¿está ocupada la frecuencia?], [¿cuál es mi turno en el orden de comunicación?], [¿a qué distancia nos encontramos?]),
  sol: [#_apc2-m[QRY?] significa «¿cuál es mi turno (en el orden de comunicación)?»; la respuesta es «su turno es el número…». No habla de frecuencias ni de distancias, sino de quién comunica antes. Los distractores son otros grupos de las tablas: #_apc2-m[QRG] (frecuencia exacta), #_apc2-m[QRL] (frecuencia ocupada) y #_apc2-m[QRB] (distancia entre estaciones). Mnemotecnia: #_apc2-m[QRY] es «¿cuándo me toca?». #no-esta[Las tablas no recogen todos los grupos Q de la lista internacional (Recomendación UIT-R M.1172). Uno de los que faltan es #_apc2-m[QRY]: «¿cuál es mi turno (en el orden de comunicación)?». Se contesta «su turno es el número…», con la cifra que corresponda. Sirve para saber en qué orden le toca a uno comunicar.]],
)

#q("F-R2.3", "d",
  [El grupo #_apc2-m[QSX], como pregunta, equivale a:],
  ([¿debo transmitir una serie de letras V?], [¿debo cambiar de frecuencia?], [¿ha escuchado a… en… kHz?], [¿quiere escuchar a… en… kHz?]),
  sol: [#_apc2-m[QSX?] es «¿quiere escuchar a… en… kHz?» y la respuesta, «escucho a… en… kHz». Cuidado con #_apc2-m[QSN], que mira al pasado («¿ha escuchado a…?»): #_apc2-m[QSX] mira al futuro («¿quiere escuchar…?»). Los otros distractores son #_apc2-m[QSV] (transmita una serie de V) y #_apc2-m[QSY] (cambie de frecuencia). #no-esta[Otro grupo Q que no figura en las tablas es #_apc2-m[QSX]: «¿quiere escuchar a… en… kHz?»; se responde «escucho a… en… kHz». Es un grupo de escucha: pide que se atienda a otra estación en una frecuencia. No lo confundas con #_apc2-m[QSN], de las tablas: #_apc2-m[QSN] pregunta si se ha oído (pasado) y #_apc2-m[QSX] si se quiere escuchar (futuro).]],
)

#q("F-R2.4", "a",
  [El grupo #_apc2-m[QSZ] se emplea para pedir que:],
  ([cada palabra o grupo se transmita dos veces (o las que se indiquen)], [se transmita más despacio], [se repita el último mensaje], [se anule el mensaje]),
  sol: [#_apc2-m[QSZ] pide que cada palabra o grupo se transmita dos veces (o las veces que se indiquen); con interrogación, «¿debo transmitir cada palabra o grupo más de una vez?». Los distractores son otros grupos de las tablas: #_apc2-m[QRS] (transmita más despacio), #_apc2-m[QSM] (repita el último mensaje) y #_apc2-m[QTA] (anule el mensaje). La diferencia con #_apc2-m[QSM]: este repite el mensaje ya enviado y #_apc2-m[QSZ] duplica cada palabra o grupo. #no-esta[Otro grupo Q que no figura en las tablas es #_apc2-m[QSZ]: «¿debo transmitir cada palabra o grupo más de una vez?». Como consigna significa «transmita cada palabra o grupo dos veces (o el número de veces que se indique)». No es #_apc2-m[QSM], que pide repetir el último mensaje ya enviado, ni #_apc2-m[QRS], que pide ir más despacio.]],
)

#q("F-R2.5", "b",
  [Las respuestas a #_apc2-m[QRK] (inteligibilidad), #_apc2-m[QSA] (fuerza de la señal) y #_apc2-m[QRI] (tono) son cifras. ¿Con qué escala se expresa cada una?],
  ([#_apc2-m[QRK], #_apc2-m[QSA] y #_apc2-m[QRI]: las tres de 1 a 9], [#_apc2-m[QRK] y #_apc2-m[QSA] de 1 a 5; #_apc2-m[QRI] de 1 a 3], [#_apc2-m[QRK] de 1 a 5; #_apc2-m[QSA] y #_apc2-m[QRI] de 1 a 9], [#_apc2-m[QRK], #_apc2-m[QSA] y #_apc2-m[QRI]: las tres de 1 a 5]),
  sol: [En la lista internacional del código Q, #_apc2-m[QRK] se responde con una cifra de 1 (mala) a 5 (excelente), #_apc2-m[QSA] de 1 (apenas perceptible) a 5 (muy buena) y #_apc2-m[QRI] de 1 a 3, con la escala al revés: 1 buena, 2 variable y 3 mala. Las opciones con 9 traen las escalas del informe #_apc2-m[RST], donde la intensidad y el tono sí llegan a 9, pero ese es otro código; la de las tres de 1 a 5 olvida que #_apc2-m[QRI] solo tiene tres valores. Y ojo con el sentido: en #_apc2-m[QRI] el número más alto es el peor. #vease[(Véase tema R2, tablas de grupos del código Q (#_apc2-m[QRK], #_apc2-m[QSA] y #_apc2-m[QRI]).)] #no-esta[Los grupos de calidad de la señal se contestan con una cifra. #_apc2-m[QRK] (inteligibilidad): de 1 (mala) a 5 (excelente). #_apc2-m[QSA] (fuerza de la señal): de 1 (apenas perceptible) a 5 (muy buena). #_apc2-m[QRI] (tono): de 1 a 3, con la escala al revés: 1 buena, 2 variable, 3 mala. Son escalas distintas de las del informe #_apc2-m[RST], que llega a 9 en intensidad y en tono.]],
)

#q("F-R2.6", "d",
  [El grupo #_apc2-m[QRU] significa:],
  ([espere; volveré a llamarle más tarde], [estoy dispuesto (a la escucha)], [cese la transmisión], [no tengo nada para usted]),
  sol: [#_apc2-m[QRU] es «no tengo nada para usted»; con interrogación, «¿tiene algo para mí?». Se parece en la forma a #_apc2-m[QRV] (estoy dispuesto) pero significa casi lo contrario. Los distractores son otros grupos de la tabla: #_apc2-m[QRX] (espere; volveré a llamar más tarde), #_apc2-m[QRV] (dispuesto, a la escucha) y #_apc2-m[QRT] (cese la transmisión). #vease[(Véase tema R2, tabla «Grupos del código Q más frecuentes en el Servicio de Aficionados».)]],
)

== Tema R3. Abreviaturas <apc2-sec-r3>

#q("F-R3.1", "a",
  [En el argot de los radioaficionados, un #_apc2-m[SWL] es:],
  ([un radioescucha: una persona aficionada a escuchar emisiones de onda corta], [un medidor de la relación de ondas estacionarias], [una estación que emite en banda lateral única con baja potencia], [la llamada general a todas las estaciones]),
  sol: [#_apc2-m[SWL] viene de _short wave listener_: es el radioescucha, la persona aficionada a escuchar emisiones de onda corta. Los distractores son confusiones típicas: la relación de ondas estacionarias se abrevia _SWR_ (ROE en español), no #_apc2-m[SWL]\; la banda lateral única es #_apc2-m[SSB] y la llamada general a todas las estaciones es #_apc2-m[CQ]. #no-esta[Entre las abreviaturas de uso corriente que no figuran en las tablas está #_apc2-m[SWL], de _short wave listener_: el radioescucha, es decir, la persona aficionada a escuchar emisiones de onda corta. La última letra importa: _SWR_, con R, es la relación de ondas estacionarias, que se mide en la línea de la antena.]],
)

#q("F-R3.2", "c",
  [La abreviatura #_apc2-m[GL] se emplea para desear al corresponsal:],
  ([buenos días], [buenas noches], [buena suerte], [buenas tardes]),
  sol: [#_apc2-m[GL] es _good luck_: «buena suerte». Los distractores son las otras abreviaturas en «G» de los saludos, todas del inglés: #_apc2-m[GM] (_good morning_, buenos días), #_apc2-m[GN] (_good night_, buenas noches) y #_apc2-m[GE] (_good evening_, buenas tardes). Fíjate en la segunda letra: M de _morning_, N de _night_, E de _evening_ y L de _luck_. #no-esta[Además de las abreviaturas de las tablas hay otras muy habituales. Los saludos se abrevian con la G de _good_ y la inicial de lo que se desea: #_apc2-m[GM] (_morning_, buenos días), #_apc2-m[GE] (_evening_, buenas tardes), #_apc2-m[GN] (_night_, buenas noches) y #_apc2-m[GL] (_luck_, buena suerte).]],
)

#q("F-R3.3", "c",
  [En el informe #_apc2-m[RST], la segunda cifra (la S) expresa:],
  ([la legibilidad, en una escala de 1 a 5], [el tono, en una escala de 1 a 9], [la intensidad de la señal, en una escala de 1 a 9], [la potencia del transmisor, en una escala de 1 a 9]),
  sol: [El informe #_apc2-m[RST] son tres cifras, en este orden: *R* (_readability_, legibilidad, de 1 a 5), *S* (_strength_, intensidad, de 1 a 9) y *T* (_tone_, tono, de 1 a 9, que se añade en telegrafía). La segunda cifra es, pues, la intensidad. Los distractores reordenan las escalas: la legibilidad es la primera cifra y solo llega a 5; el tono es la tercera. La potencia del transmisor no forma parte del informe. #vease[(Véase tema R3, tabla «Abreviaturas de procedimiento más habituales» (#_apc2-m[RST]).)] #no-esta[El informe #_apc2-m[RST] se da con tres cifras, en este orden: *R* (_readability_, legibilidad) de 1 a 5; *S* (_strength_, intensidad) de 1 a 9; y *T* (_tone_, tono) de 1 a 9, que se añade en telegrafía. En fonía se dan las dos primeras: el «59» es el informe máximo (legibilidad perfecta e intensidad máxima).]],
)

#q("F-R3.4", "a",
  [En fonía el informe de señal se da con dos cifras (por ejemplo, «59»); en telegrafía se añade una tercera («599»), que valora:],
  ([el tono de la señal], [la velocidad de manipulación], [el desvanecimiento de la señal], [la potencia del transmisor]),
  sol: [El informe #_apc2-m[RST] tiene tres cifras: legibilidad (R), intensidad (S) y tono (T). El tono solo tiene sentido en telegrafía, donde se escucha una nota que puede llevar zumbido o modulación (el 9 es el tono perfecto); por eso en fonía se dan solo R y S («59») y en telegrafía las tres («599»). La velocidad de manipulación se mide en palabras por minuto y no forma parte del informe; el desvanecimiento es #_apc2-m[QSB]\; y la potencia no la valora el corresponsal. #vease[(Véase tema R3, tabla «Abreviaturas de procedimiento más habituales» (#_apc2-m[RST]).)] #no-esta[Informe #_apc2-m[RST]: *R*, legibilidad (1 a 5); *S*, intensidad (1 a 9); *T*, tono (1 a 9). En fonía solo se dan las dos primeras cifras («59»); en telegrafía se añade el tono («599»), porque solo allí hay una nota que valorar. El 9 de tono significa tono perfecto, sin zumbido ni modulación. «599» es el informe máximo.]],
)

#q("F-R3.5", "d",
  [En la escala de legibilidad (R) del informe #_apc2-m[RST], el valor 5 significa que la señal es:],
  ([legible prácticamente sin dificultad], [ilegible], [legible con considerable dificultad], [perfectamente legible]),
  sol: [La legibilidad (R) va de 1 a 5: 1, ilegible; 2, apenas legible (se distingue alguna palabra suelta); 3, legible con considerable dificultad; 4, legible prácticamente sin dificultad; 5, perfectamente legible. El 5 es, pues, la nota máxima. Los distractores son otros escalones: ilegible es R1, con considerable dificultad es R3 y casi sin dificultad es R4. Por eso el «59» de fonía se lee «legibilidad perfecta, intensidad 9». #vease[(Véase tema R3, tabla «Abreviaturas de procedimiento más habituales» (#_apc2-m[RST]).)] #no-esta[Escala de legibilidad (R) del informe #_apc2-m[RST]: 1, ilegible; 2, apenas legible (se distingue alguna palabra suelta); 3, legible con considerable dificultad; 4, legible prácticamente sin dificultad; 5, perfectamente legible. Es la primera cifra del informe: en «59» el 5 es la legibilidad y el 9, la intensidad.]],
)

== Tema R4. Señales de socorro, urgencia y seguridad <apc2-sec-r4>

#q("F-R4.1", "b",
  [Según la Orden IET/1311/2013, si un radioaficionado capta una comunicación de socorro debe hacer lo posible para que llegue cuanto antes a:],
  ([la Jefatura Provincial de Inspección de Telecomunicaciones], [la Dirección General de Protección Civil y Emergencias, del Ministerio del Interior], [la asociación de radioaficionados más próxima], [la Secretaría de Estado de Telecomunicaciones]),
  sol: [El art. 30.5 de la Orden dice que quien capta una comunicación de socorro *deberá hacer lo posible* para que llegue cuanto antes a la Dirección General de Protección Civil y Emergencias, del Ministerio del Interior. Las otras opciones no figuran en ese artículo: las asociaciones de radioaficionados no son destinatarias; la Jefatura Provincial de Inspección de Telecomunicaciones es la ventanilla de trámites (por ejemplo, la notificación de estaciones portables, art. 17.1); y la Secretaría de Estado de Telecomunicaciones tiene facultades de aplicación y fija los modelos de solicitud (disp. final segunda). #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)] #no-esta[Según el art. 30.5 de la Orden IET/1311/2013, el radioaficionado que capta una comunicación de socorro debe hacer lo posible para que llegue cuanto antes a la Dirección General de Protección Civil y Emergencias, del Ministerio del Interior. Es la misma Dirección General que puede requerir la colaboración de los titulares de autorización en caso de catástrofe (art. 30.4).]],
)

#q("F-R4.2", "d",
  [Según la Orden IET/1311/2013, todo titular de una autorización de radioaficionado está obligado a colaborar con sus medios radioeléctricos en caso de catástrofe cuando se lo requiera:],
  ([la Unión de Radioaficionados Españoles], [el ayuntamiento de su localidad], [la Jefatura Provincial de Inspección de Telecomunicaciones], [la Dirección General de Protección Civil y Emergencias, del Ministerio del Interior]),
  sol: [El art. 30.4 de la Orden obliga a todo titular de una autorización a colaborar, a requerimiento de la Dirección General de Protección Civil y Emergencias, del Ministerio del Interior, con sus medios radioeléctricos y en las bandas atribuidas al servicio de radioaficionados, para atender las comunicaciones de socorro y seguridad en caso de catástrofes. Ni la Unión de Radioaficionados Españoles ni el ayuntamiento figuran en ese artículo, y la Jefatura Provincial de Inspección de Telecomunicaciones es la ventanilla de trámites (art. 17.1, por ejemplo), no quien requiere la colaboración. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]],
)

#q("F-R4.3", "c",
  [En el plan de bandas de la IARU para la Región 1, la frecuencia de 14300 kHz está señalada como centro de actividad de:],
  ([imagen (SSTV, fax)], [voz digital], [emergencia de ámbito mundial], [telefonía en banda lateral única de baja potencia (#_apc2-m[QRP])]),
  sol: [El plan de bandas de la IARU para la Región 1 señala en 20 m varios centros de actividad: voz digital en 14130 kHz, imagen en 14230 kHz, SSB de baja potencia en 14285 kHz y, en 14300 kHz, el centro de emergencia de ámbito mundial (_Global Emergency Centre of Activity_). Las otras tres opciones son centros reales de la banda, pero de otros modos y en otras frecuencias; por eso hay que asociar cada valor con su uso. Pista: en 15 m, 21360 kHz es también centro de emergencia global. #vease[(Véase tema R6, introducción del capítulo (reparto de cada banda en segmentos por modos, frecuencias de llamada).)] #no-esta[El plan de bandas de la IARU para la Región 1 marca en HF centros de actividad de emergencia: 3760 kHz (80 m), 7110 kHz (40 m), 14300 kHz (20 m), 18160 kHz (17 m) y 21360 kHz (15 m); los de 14300 y 21360 kHz se designan «globales». Son frecuencias de referencia señaladas por el plan para la actividad de emergencia. La Orden (Anexo I, 3.1) remite, como norma general, al plan de la IARU para la Región 1 en cuanto a los anchos de banda.]],
)

#q("F-R4.4", "b",
  [En el plan de bandas de la IARU para la Región 1, el centro de actividad de emergencia de la banda de 80 m está en:],
  ([3690 kHz], [3760 kHz], [3630 kHz], [3735 kHz]),
  sol: [En 80 m el plan de la IARU para la Región 1 señala estos centros de actividad: voz digital en 3630 kHz, SSB de baja potencia (#_apc2-m[QRP]) en 3690 kHz, imagen en 3735 kHz y emergencia de la Región 1 (_R1 Emergency Centre of Activity_) en 3760 kHz. Los otros tres valores son centros reales de la banda, pero de otros modos: por eso son buenos distractores. Regla de memoria: 3760 kHz en 80 m y 7110 kHz en 40 m son los centros de emergencia de la Región 1. #vease[(Véase tema R6, introducción del capítulo (reparto de cada banda en segmentos por modos, frecuencias de llamada).)] #no-esta[En la banda de 80 m (3500–3800 kHz) el plan de bandas de la IARU para la Región 1 marca estos centros de actividad: 3630 kHz, voz digital; 3690 kHz, SSB de baja potencia; 3735 kHz, imagen; y 3760 kHz, emergencia de la Región 1. En 40 m, el centro de emergencia es 7110 kHz. Un centro de actividad es la frecuencia de referencia que el plan señala para un modo o uso.]],
)

#q("F-R4.5", "d",
  [La frecuencia internacional de socorro, seguridad y llamada en radiotelefonía de la VHF marítima (canal 16) es:],
  ([121,5 MHz], [156,525 MHz], [243 MHz], [156,8 MHz]),
  sol: [El canal 16 de la VHF marítima, 156,8 MHz, es la frecuencia internacional de socorro, seguridad y llamada en radiotelefonía (nota 5.226 del Reglamento de Radiocomunicaciones). 156,525 MHz es el canal 70, dedicado a la llamada selectiva digital (DSC), no a la voz. 121,5 MHz es la frecuencia aeronáutica de emergencia (nota 5.200) y 243 MHz se destina a dispositivos de salvamento (nota 5.256). En MF, el equivalente de la voz es 2182 kHz. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)] #no-esta[En el servicio móvil marítimo, las frecuencias internacionales de socorro son: en MF, 2182 kHz para la voz y 2187,5 kHz para la alerta por llamada selectiva digital (DSC); en VHF, el canal 16 (156,8 MHz) para la voz y el canal 70 (156,525 MHz) para la alerta DSC. La aviación usa 121,5 MHz como frecuencia de emergencia y los dispositivos de salvamento, 243 MHz. Ninguna cae dentro de las bandas de aficionados.]],
)

#q("F-R4.6", "a",
  [En la Región 1 de la UIT, y por tanto en España, la banda de aficionados de 40 m comprende las frecuencias:],
  ([7000 a 7200 kHz], [7000 a 7300 kHz], [7100 a 7300 kHz], [6900 a 7100 kHz]),
  sol: [La UIT reparte el espectro por Regiones y los límites de 40 m no son iguales en todas. En la Región 1, España incluida, la banda de aficionados va de 7000 a 7200 kHz; el CNAF atribuye 7200–7300 kHz a radiodifusión. En la Región 2 (América) llega hasta 7300 kHz: es la opción más tentadora, pero no vale en España. «7100 a 7300» y «6900 a 7100» son la banda real desplazada: empieza en 7000 kHz y acaba en 7200 kHz. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)] #no-esta[Límites exactos de las bandas de HF en España (Cuadro Nacional de Atribución de Frecuencias): 160 m, 1810–1850 kHz; 80 m, 3500–3800 kHz; 40 m, 7000–7200 kHz; 20 m, 14000–14350 kHz; 15 m, 21000–21450 kHz; 10 m, 28–29,7 MHz. Varían por Regiones de la UIT: en la Región 1 los 7200–7300 kHz son de radiodifusión, mientras que en la Región 2 la banda de 40 m llega hasta 7300 kHz.]],
)

#q("F-R4.7", "c",
  [La banda de aficionados de 10 m (28 MHz) comprende, en España, las frecuencias:],
  ([27 a 28 MHz], [28 a 30 MHz], [28 a 29,7 MHz], [29,7 a 30 MHz]),
  sol: [El CNAF atribuye en España a los servicios de aficionados y de aficionados por satélite la banda de 28 a 29,7 MHz. «28 a 30 MHz» se pasa 0,3 MHz por arriba: de 29,7 a 30,005 MHz las atribuciones son de los servicios fijo y móvil. «29,7 a 30 MHz» es justo el tramo siguiente a la banda, fuera de ella. «27 a 28 MHz» queda por debajo: entre 27,5 y 28 MHz las atribuciones son ayudas a la meteorología, fijo y móvil. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)] #no-esta[La banda de 10 m (28 MHz) ocupa en España de 28 a 29,7 MHz, atribuida a aficionados y a aficionados por satélite. Por debajo, 27,5–28 MHz son de ayudas a la meteorología, fijo y móvil; por encima, 29,7–30,005 MHz son de fijo y móvil. Otras bandas de HF: 80 m, 3500–3800 kHz; 40 m, 7000–7200 kHz; 20 m, 14000–14350 kHz; 15 m, 21000– 21450 kHz.]],
)

#q("F-R4.8", "b",
  [De las siguientes frecuencias, la que está dentro de una banda atribuida al Servicio de Aficionados en España es:],
  ([3900 kHz], [14250 kHz], [7300 kHz], [14500 kHz]),
  sol: [En España los límites son: 80 m, 3500–3800 kHz; 40 m, 7000–7200 kHz; 20 m, 14000–14350 kHz. Solo 14250 kHz cae dentro de una banda (20 m). 3900 kHz queda por encima de los 3800 kHz de 80 m: de 3800 a 3900 hay otros servicios (entre ellos fijo y móvil). 7300 kHz supera los 7200 kHz de 40 m (valdría en la Región 2, no en España). 14500 kHz está por encima de 14350 kHz, ya en una atribución de fijo y móvil. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)] #no-esta[Para saber si una frecuencia cae en banda de aficionado en España hay que conocer los límites: 80 m, 3500–3800 kHz; 40 m, 7000–7200 kHz; 20 m, 14000–14350 kHz. Justo fuera hay otros servicios: 3800–3900 kHz son de fijo y móvil; 7200–7300 kHz, de radiodifusión; 14350–14990 kHz, de fijo y móvil. El límite de 7300 kHz de la Región 2 no vale en España.]],
)

#q("F-R4.9", "a",
  [En la banda de 70 cm, el segmento que el plan de bandas de la IARU para la Región 1 dedica al servicio de satélite es:],
  ([435 a 438 MHz], [430 a 432 MHz], [433 a 435 MHz], [438 a 440 MHz]),
  sol: [El plan de la IARU para la Región 1 reserva al servicio de satélite 435–438 MHz (435–436 y 436– 438 MHz), y la nota 5.282 del Reglamento de Radiocomunicaciones, recogida en el CNAF, admite ahí el servicio de aficionados por satélite. 430–432 MHz es de uso mixto y repetidores. 433–435 MHz incluye la banda ICM 433,050–434,790 MHz (Anexo I, 3.4, de la Orden) y segmentos de repetidores. 438–440 MHz es de «todos los modos» y salidas de repetidores. #vease[(Véase tema R6, introducción del capítulo (reparto de cada banda en segmentos por modos, frecuencias de llamada).)] #no-esta[El plan de bandas de la IARU para la Región 1 reserva al servicio de satélite: en 2 m, 145,806– 146,000 MHz (exclusivo); en 70 cm, 435–438 MHz; y en 23 cm, 1260–1270 MHz. El Reglamento de Radiocomunicaciones (nota 5.282) admite el servicio de aficionados por satélite en 435–438, 1260–1270 y 2400–2450 MHz, entre otras bandas.]],
)

#q("F-R4.10", "d",
  [En la banda de 2 m, el segmento que el plan de bandas de la IARU para la Región 1 reserva en exclusiva a los satélites es:],
  ([144,400 a 144,490 MHz], [145,575 a 145,7935 MHz], [144,150 a 144,400 MHz], [145,806 a 146,000 MHz]),
  sol: [El plan de la IARU para la Región 1 marca 145,806–146,000 MHz como «satélite, exclusivo»: es el último tramo de la banda de 2 m. 144,400–144,490 MHz es exclusivo de balizas; 145,575–145,7935 MHz, de salidas de repetidores; y 144,150–144,400 MHz, de SSB, telegrafía y modos digitales de señal débil. Hay otros tramos pequeños de comunicación espacial, pero solo el último es exclusivo de satélites. #vease[(Véase tema R6, introducción del capítulo (reparto de cada banda en segmentos por modos, frecuencias de llamada).)] #no-esta[En 2 m, el plan de bandas de la IARU para la Región 1 reparte así la parte alta: salidas de repetidores, 145,575–145,7935 MHz; comunicación espacial, 145,794–145,806 MHz; y satélites en exclusiva, 145,806–146,000 MHz, hasta el final de la banda. Las balizas ocupan 144,400–144,490 MHz, y en 144,000–144,025 MHz solo se admite enlace descendente de satélite.]],
)

#q("F-R4.11", "b",
  [Según la Orden IET/1311/2013, las emisiones del Servicio de Aficionados por Satélite quedan restringidas a:],
  ([cualquier banda atribuida al Servicio de Aficionados], [las bandas atribuidas al efecto en el CNAF], [las bandas de VHF y UHF únicamente], [las bandas que requieren autorización especial de la SETSI]),
  sol: [El art. 5.3 de la Orden habilita para emitir en las bandas del Servicio de Aficionados y del Servicio de Aficionados por Satélite, pero las emisiones de este último quedan restringidas a las bandas atribuidas al efecto en el CNAF. No toda banda de aficionado admite satélites: 80 m (3500–3800 kHz) no, mientras que 7000–7100 kHz, 14000–14250 kHz o 144–146 MHz sí; por eso «cualquier banda» es falso, y «VHF y UHF únicamente» también, pues el CNAF atribuye a satélite tramos de HF. La autorización especial (art. 16) es otra cosa: bandas secundarias con riesgo de interferencia. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)] #no-esta[Según el art. 5.3 de la Orden IET/1311/2013, la autorización de radioaficionado habilita para emitir en las bandas atribuidas al Servicio de Aficionados y al Servicio de Aficionados por Satélite, pero las emisiones de este último quedan restringidas a las bandas atribuidas al efecto en el CNAF. No toda banda de aficionado admite satélites: 80 m no; 7000–7100 kHz, 14000–14250 kHz y 144–146 MHz sí.]],
)

#q("F-R4.12", "a",
  [La banda de 2 m atribuida al Servicio de Aficionados en España (Región 1) comprende:],
  ([144 a 146 MHz], [144 a 148 MHz], [146 a 148 MHz], [140 a 144 MHz]),
  sol: [El Anexo I de la Orden (apartado 3.1, tabla de potencias) recoge la banda de 2 m como 144 a 146 MHz, y el CNAF la atribuye en España a aficionados y aficionados por satélite. Los 146–148 MHz son de aficionados en las Regiones 2 y 3, pero en la Región 1 son de fijo y móvil: por eso «144 a 148» es el error típico. «146 a 148» no incluye ni un solo megahercio de la banda, y «140 a 144» termina justo donde ella empieza. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]],
)

#q("F-R4.13", "c",
  [La banda de 70 cm atribuida al Servicio de Aficionados en España es:],
  ([420 a 450 MHz], [440 a 450 MHz], [430 a 440 MHz], [433 a 435 MHz]),
  sol: [El Anexo I de la Orden (apartado 3.1) recoge la banda de 70 cm como 430 a 440 MHz, y el CNAF la atribuye así en España. «420 a 450» es la banda de otros países: la nota 5.270 añade 420–430 y 440–450 MHz, a título secundario, en Australia, Estados Unidos, Jamaica y Filipinas. «440 a 450» queda fuera de la banda. «433 a 435» son solo 2 MHz del interior, donde además está la banda ICM 433,050–434,790 MHz. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]],
)

#q("F-R4.14", "d",
  [La banda de 23 cm atribuida al Servicio de Aficionados en España comprende:],
  ([1200 a 1400 MHz], [1300 a 1400 MHz], [1000 a 1240 MHz], [1240 a 1300 MHz]),
  sol: [El Anexo I de la Orden (apartado 3.1) recoge la banda de 23 cm como 1240 a 1300 MHz, y el CNAF la atribuye a los aficionados a título secundario. «1200 a 1400» es un rango demasiado ancho: la banda solo mide 60 MHz. «1300 a 1400» empieza donde ella acaba, y «1000 a 1240» termina donde ella empieza: ambas quedan fuera. Como es secundaria, los aficionados no deben causar interferencia a los servicios primarios ni reclamar protección frente a ellos. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]],
)

== Tema R5. Distintivos de llamada <apc2-sec-r5>

#q("F-R5.1", "b",
  [Según la Resolución de 29 de julio de 2026 de la Secretaría de Estado de Telecomunicaciones e Infraestructuras Digitales, la práctica internacional exigida para obtener un distintivo con sufijo de una letra se acredita con:],
  ([una #_apc2-m[QSL] por año durante quince años seguidos], [dos #_apc2-m[QSL] por año durante quince de los últimos veinte años], [dos #_apc2-m[QSL] por año durante diez de los últimos quince años], [tres #_apc2-m[QSL] por año durante los últimos cinco años]),
  sol: [El apartado segundo de la Resolución (BOE-A-2026-17504, en vigor desde el 19-09-2026) desarrolla el art. 27 de la Orden, que pide quince años de práctica internacional: se acreditan con dos tarjetas #_apc2-m[QSL] por cada año, durante quince de los últimos veinte, incluido el año de la solicitud. «Una por año» y «diez de quince» rebajan la exigencia. «Cinco años» recuerda la antigüedad mínima de la autorización, que es otro requisito distinto de la práctica internacional. #vease[(Véase tema R5, sección «Sufijos y usos temporales».)]],
)

#q("F-R5.2", "a",
  [En la solicitud de un distintivo con sufijo de una letra (Resolución de 29 de julio de 2026), el interesado puede incluir una relación de distintivos por orden de preferencia, hasta un máximo de:],
  ([diez distintivos], [tres distintivos], [cinco distintivos], [veinte distintivos]),
  sol: [El apartado cuarto de la Resolución permite relacionar, por orden de preferencia, hasta un máximo de diez distintivos de una letra; además, el solicitante puede indicar que desiste si no se le puede asignar ninguno de ellos. Si ninguno está disponible, o no indicó preferencias, se asigna por orden alfabético entre los libres de su distrito: serie EA, luego EB y luego EC (EA1A, EA1B…). Tres, cinco y veinte no figuran en el texto. #vease[(Véase tema R5, sección «Sufijos y usos temporales».)]],
)

#q("F-R5.3", "b",
  [En el procedimiento ordinario para asignar distintivos con sufijo de una letra, establecido por la Resolución de 29 de julio de 2026, la asignación se hace:],
  ([por sorteo público anual entre los solicitantes, y el nuevo distintivo se suma al anterior del titular], [por distritos y por estricto orden de presentación de las solicitudes, y el nuevo distintivo sustituye al anterior del titular], [en una lista única nacional, por antigüedad de la autorización, y el nuevo distintivo sustituye al anterior del titular], [por distritos y por orden de presentación, pero el titular conserva también su distintivo anterior]),
  sol: [La Resolución de 29 de julio de 2026 (BOE-A-2026-17504) desarrolla el art. 27 de la Orden, que encarga a la SETSI fijar el procedimiento para los sufijos de una letra. Asigna los distintivos por distritos y por estricto orden de presentación; el solicitante puede indicar hasta diez preferencias, y el nuevo distintivo sustituye al que tuviera asignado (coherente con el art. 28: el distintivo es único). La a habla de sorteo: la asignación es por orden de presentación. La c inventa una lista nacional por antigüedad. La d conserva el distintivo anterior, justo lo contrario de sustituirlo. Deroga la Resolución de 12 de julio de 2019. #vease[(Véase tema R5, sección «Sufijos y usos temporales».)]],
)

#q("F-R5.4", "d",
  [La Orden IET/1311/2013 admite, con carácter excepcional, sufijos de cuatro o más letras:],
  ([para las estaciones automáticas desatendidas de aficionado, analógicas o digitales], [para los radioaficionados con más de veinticinco años de antigüedad en la autorización], [con carácter permanente, para participar en concursos internacionales de alta competitividad], [para usos temporales ligados a eventos o conmemoraciones de relevancia especial]),
  sol: [El art. 27.3, en su último párrafo, dice que podrán autorizarse, con carácter excepcional, sufijos de cuatro o más letras para usos temporales relacionados con eventos o conmemoraciones de relevancia especial. La regla general son sufijos de hasta tres letras. La a falla: las desatendidas usan sufijos de tres letras que empiezan por Y (analógicas) o Z (digitales). La b inventa un privilegio por antigüedad: los sufijos de una y dos letras son los que exigen antigüedad y práctica internacional. La c confunde con el sufijo de una letra, reservado a concursos internacionales de alta competitividad. #vease[(Véase tema R5, sección «Sufijos y usos temporales».)] #no-esta[La Orden fija como regla general sufijos de hasta tres letras (art. 27.3). Como excepción, podrán autorizarse sufijos de cuatro o más letras, siempre con carácter excepcional y para usos temporales relacionados con eventos o conmemoraciones de relevancia especial. No deben confundirse con los sufijos de una y dos letras, que son escasos y se adjudican por méritos a titulares veteranos.]],
)

#q("F-R5.5", "a",
  [Un titular de licencia CEPT que transmite en telefonía desde el país visitado emite su distintivo nacional precedido del prefijo de ese país. Entre el prefijo y el distintivo se pronuncia la palabra:],
  ([_stroke_], [«portable»], [«móvil»], [«cambio»]),
  sol: [La Recomendación T/R 61-01 (apéndice I, punto 2.3) dice que el distintivo nacional va precedido del prefijo del país visitado y que ambos se separan con el carácter «/» en telegrafía o con la palabra _stroke_ en telefonía. Así, #_apc2-m[EA/M0BVM] se dice EA _stroke_ M0BVM, deletreando cada carácter. «Portable» y «móvil» no separan nada: en telefonía se añaden al final del distintivo de las estaciones portables y móviles (art. 29.2 de la Orden). «Cambio» se dice al ceder la palabra, no separa el distintivo. #vease[(Véase tema R5, introducción del capítulo (prefijo, distrito y sufijo).)] #no-esta[Con la licencia CEPT (T/R 61-01), el visitante emite su distintivo nacional precedido del prefijo del país visitado; en España, #_apc2-m[EA] y, opcionalmente, la cifra del distrito (art. 14.e de la Orden). En telegrafía se separan con «/» (#_apc2-m[EA/M0BVM]); en telefonía, el «/» se pronuncia _stroke_. No lo confundas con «portable» o «móvil», que se añaden al final del distintivo.]],
)

#q("F-R5.6", "c",
  [Según el artículo 27 de la Orden IET/1311/2013, las estaciones colectivas de las asociaciones de radioaficionados:],
  ([emiten con el distintivo personal del presidente de la asociación], [emiten con el distintivo del socio que las maneja en cada momento], [llevan asociado un distintivo de llamada específico para cada una de ellas], [quedan exentas de distintivo cuando emiten en VHF o UHF]),
  sol: [El primer párrafo del art. 27 dice que las estaciones colectivas llevan asociado un distintivo específico de llamada para cada una de ellas. El art. 18.8 añade que cada una precisa una autorización individualizada, a la que se asigna un distintivo según los arts. 27 y 28. La a y la b olvidan que el distintivo es propio de la estación, no del presidente ni de quien la opera. La d es falsa: toda emisión se identifica con el distintivo (art. 29.1), en cualquier banda. Por eso existen sufijos reservados, como #_apc2-m[UR], #_apc2-m[RC] y #_apc2-m[RK]. #vease[(Véase tema R5, sección «Sufijos y usos temporales».)] #no-esta[Las estaciones colectivas de asociaciones reconocidas (art. 18) llevan cada una su propio distintivo, con autorización individualizada, asignado con los criterios de los arts. 27 y 28. Para ellas se reservan los sufijos de tres letras que empiezan por #_apc2-m[UR] (asociaciones) y por #_apc2-m[RC] o #_apc2-m[RK] (radio clubes). No usan el distintivo del presidente ni el de los socios que las manejen.]],
)

#q("F-R5.7", "d",
  [Conforme al artículo 27 de la Orden IET/1311/2013, el distintivo de llamada asociado a una autorización de radioaficionado identifica:],
  ([al equipo transmisor, con independencia de quién lo utilice], [a la asociación de radioaficionados a la que pertenece el titular], [a su titular solo cuando emite desde el domicilio consignado en la autorización], [a su titular en las emisiones que efectúe desde cualquier punto del territorio nacional]),
  sol: [El primer párrafo del art. 27 dice que cada autorización lleva asociado un distintivo que identifica a su titular en las emisiones que efectúe desde cualquier punto del territorio nacional. No identifica al aparato (a): el distintivo va con la persona, no con el equipo. La asociación (b) no tiene distintivo personal; solo sus estaciones colectivas llevan uno propio. Tampoco está ligado al domicilio (c): es único y no puede modificarse (art. 28), así que no cambia al mudarse de distrito y vale en estación fija, móvil o portable. #vease[(Véase tema R5, sección «Asignación y uso del distintivo».)] #no-esta[El distintivo de llamada va asociado a la autorización y no al equipo: identifica a su titular en las emisiones que efectúe desde cualquier punto del territorio nacional (art. 27). Por eso es único, no cambia al mudarse de distrito (art. 28) y se transmite al comienzo y al final de cada emisión (art. 29.1). Solo las estaciones colectivas llevan un distintivo específico para cada una.]],
)

#q("F-R5.8", "b",
  [Un radioaficionado cuyo distintivo empieza por el prefijo #_apc2-m[CT] emite con un distintivo de:],
  ([Chile], [Portugal], [Canadá], [Croacia]),
  sol: [El prefijo #_apc2-m[CT] es el de Portugal (T/R 61-01, apéndice II; las Azores usan #_apc2-m[CU]). Las demás opciones son trampas por la inicial: Chile usa #_apc2-m[CE], Canadá #_apc2-m[VE] y Croacia #_apc2-m[9A]. El Reglamento de Radiocomunicaciones de la UIT reparte a cada país series de prefijos y cada Administración compone con ellas los distintivos: por eso el país se reconoce por las primeras letras, como #_apc2-m[EA] en España. #vease[(Véase tema R5, introducción del capítulo (prefijo, distrito y sufijo).)] #no-esta[Un distintivo empieza por un prefijo que identifica el país: la UIT atribuye a cada Estado series de prefijos (Reglamento de Radiocomunicaciones, apéndice 42). Los vecinos de España: Portugal #_apc2-m[CT] (Azores, #_apc2-m[CU]), Francia #_apc2-m[F] y Andorra #_apc2-m[C3]. Un mismo país puede usar varios prefijos: España emplea #_apc2-m[EA], #_apc2-m[EB] y #_apc2-m[EC] en las autorizaciones individuales.]],
)

#q("F-R5.9", "a",
  [Un distintivo de llamada cuyo prefijo es la letra #_apc2-m[F] corresponde a:],
  ([Francia], [Finlandia], [Alemania], [Bélgica]),
  sol: [El prefijo #_apc2-m[F] es el de Francia (T/R 61-01, apéndice II); Córcega y los territorios de ultramar usan prefijos propios, como #_apc2-m[TK] o #_apc2-m[FG]. Los otros países se confunden por la inicial o por la zona: Finlandia usa #_apc2-m[OH], Alemania #_apc2-m[DL] y Bélgica #_apc2-m[ON]. Conviene retener los prefijos de los vecinos de España: Francia #_apc2-m[F], Portugal #_apc2-m[CT] y Andorra #_apc2-m[C3]. #vease[(Véase tema R5, introducción del capítulo (prefijo, distrito y sufijo).)] #no-esta[El país de un distintivo se reconoce por su prefijo. Francia usa #_apc2-m[F], con prefijos propios en Córcega (#_apc2-m[TK]) y en ultramar (por ejemplo, #_apc2-m[FG] en Guadalupe); Portugal, #_apc2-m[CT]\; Andorra, #_apc2-m[C3]. Los prefijos nacionales los atribuye la UIT en su tabla de series de distintivos (Reglamento de Radiocomunicaciones, apéndice 42).]],
)

#q("F-R5.10", "c",
  [El prefijo #_apc2-m[C3] de un distintivo de llamada corresponde a:],
  ([Camerún], [Canadá], [Andorra], [Cuba]),
  sol: [#_apc2-m[C3] es la serie de Andorra, país vecino de España, en la tabla de series de distintivos de la UIT (Reglamento de Radiocomunicaciones, apéndice 42). Las otras opciones se confunden por la inicial: Camerún usa #_apc2-m[TJ], Canadá #_apc2-m[VE] y Cuba #_apc2-m[CM] o #_apc2-m[CO]. Fíjate en que un prefijo puede mezclar letra y cifra (#_apc2-m[C3], #_apc2-m[9A], #_apc2-m[3A]) y no solo letras. #vease[(Véase tema R5, introducción del capítulo (prefijo, distrito y sufijo).)] #no-esta[Los prefijos de los países vecinos de España: Francia #_apc2-m[F], Portugal #_apc2-m[CT] y Andorra #_apc2-m[C3]. Un prefijo puede combinar letras y cifras (#_apc2-m[C3] de Andorra, #_apc2-m[9A] de Croacia, #_apc2-m[3A] de Mónaco). Los atribuye la UIT a cada Estado en la tabla de series de distintivos del Reglamento de Radiocomunicaciones (apéndice 42).]],
)

#q("F-R5.11", "a",
  [El prefijo #_apc2-m[DL] de un distintivo de llamada corresponde a:],
  ([Alemania], [Dinamarca], [Países Bajos], [Letonia]),
  sol: [#_apc2-m[DL] es un prefijo de Alemania (T/R 61-01, apéndice II; la serie alemana va de DA a DR). La inicial D engaña con Dinamarca, que usa #_apc2-m[OZ]. Los Países Bajos usan #_apc2-m[PA] y Letonia #_apc2-m[YL]. Los prefijos no siguen la inicial del nombre del país, sino las series que la UIT atribuye a cada Estado. #vease[(Véase tema R5, introducción del capítulo (prefijo, distrito y sufijo).)] #no-esta[El país de un distintivo se reconoce por su prefijo. Algunos de Europa, según la T/R 61-01 y la tabla de series de la UIT: Alemania #_apc2-m[DL], Italia #_apc2-m[I], Bélgica #_apc2-m[ON], Países Bajos #_apc2-m[PA], Dinamarca #_apc2-m[OZ], Finlandia #_apc2-m[OH], Irlanda #_apc2-m[EI] y Reino Unido #_apc2-m[G] o #_apc2-m[M].]],
)

#q("F-R5.12", "b",
  [Un distintivo de llamada cuyo prefijo es la letra #_apc2-m[I] corresponde a:],
  ([Irlanda], [Italia], [India], [Islandia]),
  sol: [La letra #_apc2-m[I] es el prefijo de Italia (T/R 61-01, apéndice II; la serie italiana va de IAA a IZZ). Los otros países que empiezan por I en español usan prefijos distintos: Irlanda #_apc2-m[EI], India #_apc2-m[VU] (dentro de la serie VT a VW) e Islandia #_apc2-m[TF]. De nuevo, el prefijo no sigue la inicial del nombre del país. #vease[(Véase tema R5, introducción del capítulo (prefijo, distrito y sufijo).)] #no-esta[El prefijo de un distintivo identifica el país. Italia usa la letra #_apc2-m[I] sola (serie de IAA a IZZ). Otros prefijos europeos que conviene reconocer: Alemania #_apc2-m[DL], Bélgica #_apc2-m[ON], Países Bajos #_apc2-m[PA], Irlanda #_apc2-m[EI], Islandia #_apc2-m[TF] y Reino Unido #_apc2-m[G] o #_apc2-m[M]. La UIT los atribuye a cada Estado (Reglamento de Radiocomunicaciones, apéndice 42).]],
)

#q("F-R5.13", "d",
  [Un distintivo de llamada cuyo prefijo es #_apc2-m[M] o #_apc2-m[G] (por ejemplo, #_apc2-m[M0BVM]) corresponde a:],
  ([Irlanda], [Malta], [Mónaco], [Reino Unido]),
  sol: [Las series #_apc2-m[G] y #_apc2-m[M] son del Reino Unido (tabla de series de la UIT). La T/R 61-01, apéndice II, da #_apc2-m[M] para el Reino Unido y prefijos derivados para sus regiones, como #_apc2-m[MM] (Escocia) y #_apc2-m[MW] (Gales). Irlanda usa #_apc2-m[EI], Malta #_apc2-m[9H] y Mónaco #_apc2-m[3A]: la M de Malta y de Mónaco es solo una trampa por la inicial. #vease[(Véase tema R5, introducción del capítulo (prefijo, distrito y sufijo).)] #no-esta[El Reino Unido tiene las series #_apc2-m[G] y #_apc2-m[M] en la tabla de la UIT. Según la T/R 61-01, el visitante de esos países usa #_apc2-m[M], con prefijos propios para sus regiones: #_apc2-m[MM] Escocia, #_apc2-m[MW] Gales, #_apc2-m[MI] Irlanda del Norte. No lo confundas con Irlanda (#_apc2-m[EI]), Malta (#_apc2-m[9H]) ni Mónaco (#_apc2-m[3A]).]],
)

#q("F-R5.14", "c",
  [Además de en eventos relevantes de ámbito internacional, el prefijo #_apc2-m[AO] puede utilizarse, con carácter optativo, en las emisiones de radioaficionados españoles:],
  ([desde Ceuta y Melilla], [desde las islas Canarias], [desde zonas no adscritas a soberanías nacionales], [en eventos relevantes de ámbito nacional]),
  sol: [El art. 27.1.d asigna #_apc2-m[AO] a eventos relevantes de ámbito internacional y, con carácter optativo, a las emisiones de radioaficionados españoles desde zonas no adscritas a soberanías nacionales. Ceuta, Melilla y Canarias son territorio español y ya se identifican con las cifras de distrito 9 y 8 (#_apc2-m[EA9], #_apc2-m[EA8]); no necesitan prefijo especial. Los eventos relevantes de ámbito nacional corresponden a #_apc2-m[AM] y #_apc2-m[AN] (art. 27.1.c). #vease[(Véase tema R5, sección «Sufijos y usos temporales».)] #no-esta[El prefijo #_apc2-m[AO] tiene dos usos: eventos relevantes de ámbito internacional y, con carácter optativo, las emisiones de radioaficionados españoles desde zonas no adscritas a soberanías nacionales (art. 27.1.d). Para eventos relevantes de ámbito nacional se usan #_apc2-m[AM] y #_apc2-m[AN]. Como el resto de prefijos temporales, requiere autorización previa de la Jefatura Provincial.]],
)

#q("F-R5.15", "b",
  [Para los distintivos temporales, los períodos autorizados para un mismo sufijo y peticionario no son, como norma general, superiores a:],
  ([10 días al año], [30 días al año], [90 días al año], [un año natural completo]),
  sol: [El último párrafo del art. 28 fija el límite general en 30 días al año por sufijo y peticionario. Las opciones a y c son cifras plausibles, pero no figuran en la Orden. La d recuerda la excepción, que es distinta: los distintivos con sufijo de una letra usados exclusivamente para participar en concursos de alta competitividad pueden autorizarse al mismo titular por períodos de hasta dos años, a partir de la fecha de autorización. Además, cada evento exige una solicitud independiente (art. 28). #vease[(Véase tema R5, sección «Sufijos y usos temporales».)] #no-esta[Los distintivos temporales se piden con una solicitud independiente por cada evento (art. 28). Como norma general, los períodos autorizados para un mismo sufijo y peticionario no superan 30 días al año. Excepción: el sufijo de una letra usado solo en concursos de alta competitividad puede autorizarse al mismo titular hasta dos años, contados desde la fecha de autorización.]],
)

#q("F-R5.16", "a",
  [Según el artículo 27 de la Orden IET/1311/2013, la utilización de más de una cifra en el distintivo de llamada podrá ser autorizada para:],
  ([acontecimientos relevantes identificados por sus fechas de celebración, como los aniversarios], [radioaficionados que residan habitualmente en más de un distrito], [estaciones automáticas desatendidas que enlacen repetidores de distintos distritos], [la participación en concursos internacionales de alta competitividad]),
  sol: [El art. 27.2 lo permite para acontecimientos relevantes identificados por sus fechas de celebración, tales como acontecimientos periódicos o aniversarios. Es una excepción: el distintivo lleva normalmente una sola cifra, la del distrito de residencia en el momento del otorgamiento (b). Las desatendidas (c) se distinguen por el prefijo #_apc2-m[ED] y por los sufijos que empiezan por Y o Z, no por las cifras. A los concursos de alta competitividad (d) les corresponde el sufijo de una letra. #vease[(Véase tema R5, introducción del capítulo y tabla de distritos.)] #no-esta[Además del distrito 0 (solo para actos inaugurados o visitados por Su Majestad el Rey, y únicamente el día del acto), la Orden permite autorizar más de una cifra en el distintivo para acontecimientos relevantes identificados por sus fechas de celebración, como acontecimientos periódicos o aniversarios (art. 27.2). Es una excepción a la regla de una sola cifra: la del distrito de residencia.]],
)

== Tema R6. Planes de bandas de la IARU <apc2-sec-r6>

#q("F-R6.1", "a",
  [Según el plan de bandas HF de la IARU para la Región 1, no debe realizarse actividad de concurso en la banda de:],
  ([30 m (10 MHz)], [20 m (14 MHz)], [40 m (7 MHz)], [15 m (21 MHz)]),
  sol: [El plan HF de la Región 1 lo dice sin rodeos: la actividad de concurso no debe tener lugar en las bandas de 5, 10, 18 y 24 MHz, es decir, 60, 30, 17 y 12 m. De las cuatro opciones, solo los 30 m (10 MHz) figuran en esa lista. Las otras tres admiten concursos: en 80, 40 y 20 m el plan incluso marca tramos preferentes para concurso, en CW o en SSB. Además, recomienda a quien no concursa que use las bandas libres de concurso (30, 17 y 12 m) durante los grandes concursos internacionales. #no-esta[El plan de bandas HF de la IARU para la Región 1 (en vigor desde el 16 de octubre de 2020) establece que la actividad de concurso no debe tener lugar en las bandas de 5, 10, 18 y 24 MHz (60, 30, 17 y 12 m). También recomienda que quienes no concursan usen las bandas de 30, 17 y 12 m durante los grandes concursos internacionales. El resto de las bandas HF sí admite concursos; en 80, 40 y 20 m el plan marca incluso tramos preferentes para concurso en CW o en SSB.]],
)

#q("F-R6.2", "c",
  [En el plan de bandas de la IARU para la Región 1, la anchura de banda máxima que se fija para los segmentos de fonía en banda lateral única (SSB) es de:],
  ([200 Hz], [500 Hz], [2.700 Hz], [12 kHz]),
  sol: [Cada segmento del plan lleva una anchura máxima según el modo. En HF: 200 Hz en los de telegrafía (CW), 500 Hz en los de modos de banda estrecha y digimodos, y 2.700 Hz en los de «todos los modos», donde se hace la fonía SSB; en VHF y UHF los segmentos de SSB también tienen 2.700 Hz. Ese valor coincide con los 2,7 kHz de una emisión J3E. Con 200 o 500 Hz solo caben CW o modos estrechos. Los 12 kHz son el máximo de los segmentos de FM y voz digital de VHF (p. ej., 2 m), no de SSB. #vease[(Véase tema T1, sección «Señales moduladas» (anchura de banda de la SSB); tema R6, introducción del capítulo.)] #no-esta[Cada segmento del plan de bandas lleva una anchura de banda máxima según el modo. En el plan HF de la Región 1: 200 Hz en los segmentos de telegrafía (CW), 500 Hz en los de modos de banda estrecha y digimodos, y 2.700 Hz en los de «todos los modos» (fonía SSB). En VHF y UHF los segmentos de SSB también tienen 2.700 Hz; en VHF, los de FM y voz digital, 12 kHz. Así se evita que una emisión invada el segmento de otro modo.]],
)

#q("F-R6.3", "d",
  [En el plan de bandas HF de la IARU para la Región 1, las frecuencias de los segmentos se entienden como:],
  ([frecuencias del dial, es decir, de la portadora suprimida], [frecuencias de recepción, sin aplicación a la emisión], [frecuencias centrales del canal de 3 kHz de cada emisión], [frecuencias realmente transmitidas (las que ocupa la emisión), no la de la portadora suprimida]),
  sol: [La nota del plan HF es explícita: las frecuencias del plan son «frecuencias transmitidas», no las de la portadora suprimida. Lo que debe quedar dentro del segmento es toda la emisión, no solo el dial. Por eso en LSB, donde la banda lateral cuelga por debajo del dial, el plan fija el ajuste de dial mínimo para fonía: 1.843, 3.603 y 7.053 kHz, tres kilohercios por encima del borde inferior del segmento. En USB ocurre al revés: de 20 a 10 m el dial máximo queda 3 kHz por debajo del borde superior de la banda. La opción a) es justo lo que la nota descarta. #vease[(Véase tema T1, sección «Señales moduladas» (SSB con portadora suprimida).)] #no-esta[En SSB la portadora se suprime: la frecuencia del dial es la de esa portadora y la señal ocupa unos 2,7 kHz a un lado, por debajo en LSB y por encima en USB. El plan HF de la IARU para la Región 1 se refiere a las frecuencias realmente transmitidas, no a la del dial. Por eso indica ajustes de dial límite: en LSB, como mínimo 1.843, 3.603 y 7.053 kHz (3 kHz sobre el borde del segmento); en USB, de 20 a 10 m, como máximo 3 kHz por debajo del borde superior de la banda.]],
)

#q("F-R6.4", "b",
  [En la banda de 80 m, el plan de bandas HF de la IARU para la Región 1 marca como segmento de telegrafía (CW) el comprendido entre:],
  ([3.600–3.800 kHz], [3.500–3.570 kHz], [3.570–3.600 kHz], [3.700–3.800 kHz]),
  sol: [El plan divide los 80 m en tres bloques por modo: 3.500–3.570 kHz, telegrafía (200 Hz de anchura máxima); 3.570–3.600 kHz, modos de banda estrecha y digimodos; 3.600–3.800 kHz, «todos los modos», es decir, la fonía en SSB (LSB). Las opciones a) y d) caen en el bloque de fonía. La c) es el de los modos digitales estrechos: aunque el plan admite QSO en CW en toda la banda (salvo en segmentos de balizas), el tramo marcado como CW es el de 3.500–3.570 kHz. #no-esta[El plan de bandas HF de la IARU para la Región 1 reparte cada banda por modos. En 80 m: 3.500–3.570 kHz, telegrafía (CW); 3.570–3.600 kHz, modos de banda estrecha y digimodos; 3.600–3.800 kHz, todos los modos, con la fonía SSB en LSB. La telegrafía puede usarse en toda la banda, salvo en los segmentos de balizas, pero el plan marca el primer tramo como el propio de CW.]],
)

#q("F-R6.5", "d",
  [En la banda de 20 m, el segmento 14.070–14.099 kHz del plan de bandas HF de la IARU para la Región 1 está destinado a:],
  ([telegrafía (CW)], [fonía SSB], [balizas], [modos digitales de banda estrecha (digimodos)]),
  sol: [En 20 m el plan reparte así: 14.000–14.070 kHz, CW; 14.070–14.099 kHz, modos de banda estrecha y digimodos (hasta 500 Hz de anchura; RTTY, PSK, etc.); 14.099–14.101 kHz, balizas en exclusiva; 14.101–14.350 kHz, todos los modos, con la fonía SSB en USB. Por tanto, la telegrafía corresponde al tramo inferior, la fonía al superior y las balizas al estrecho segmento de 2 kHz que sigue al de digimodos. #no-esta[En 20 m el plan HF de la IARU para la Región 1 distribuye la banda así: 14.000–14.070 kHz, telegrafía (CW); 14.070–14.099 kHz, modos de banda estrecha y digimodos (p. ej., RTTY o PSK, hasta 500 Hz de ancho); 14.099–14.101 kHz, balizas exclusivamente; 14.101–14.350 kHz, todos los modos, incluida la fonía en USB.]],
)

#q("F-R6.6", "c",
  [El segmento 14.099–14.101 kHz del plan de bandas HF de la IARU para la Región 1 está reservado exclusivamente a:],
  ([comunicaciones de emergencia], [voz digital], [balizas del _International Beacon Project_], [telegrafía de baja potencia (QRP)]),
  sol: [El plan marca 14.099–14.101 kHz, con centro en 14.100 kHz, como «International Beacon Project: beacons exclusively». Solo balizas, y ni siquiera se acepta ahí un QSO en CW. Los otros usos tienen su centro de actividad en otra parte: emergencia mundial en 14.300 kHz, voz digital en 14.130 kHz y telegrafía QRP en 14.060 kHz. Esa exclusividad permite escuchar las balizas, que sirven para estudiar la propagación, sin interferencias. #vease[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)] #no-esta[Una radiobaliza es una estación automática desatendida que emite su identificación para estudiar la propagación. En HF, el plan de la IARU para la Región 1 les reserva en exclusiva segmentos de 2 kHz: 14.099–14.101, 18.109– 18.111, 21.149–21.151 y 24.929–24.931 kHz, además de varios tramos en 28 MHz. En esos segmentos no debe hacerse ningún otro tipo de comunicación, ni siquiera en CW.]],
)

#q("F-R6.7", "b",
  [El plan de bandas HF de la IARU para la Región 1 recomienda LSB en fonía por debajo de 10 MHz y USB por encima. Como excepción, en la banda de 60 m (5 MHz) recomienda para la fonía:],
  ([LSB], [USB], [AM], [FM]),
  sol: [La regla general del plan es LSB por debajo de 10 MHz (160, 80 y 40 m) y USB por encima (20, 17, 15, 12 y 10 m). La banda de 5 MHz es la excepción expresa: se recomienda USB para la voz, en el segmento 5.354– 5.366 kHz. La a) es lo que daría la regla general y por eso es el error típico. La AM y la FM ocupan más anchura que los 2.700 Hz máximos de ese segmento y no son los modos que recomienda el plan. #vease[(Véase tema T1, sección «Señales moduladas» (banda lateral única); tema R3, abreviaturas LSB y USB.)] #no-esta[Por convenio, en SSB se usa la banda lateral inferior (LSB) por debajo de 10 MHz (160, 80 y 40 m) y la superior (USB) por encima (20, 17, 15, 12 y 10 m). El plan de bandas HF de la IARU para la Región 1 lo recoge como recomendación y señala una excepción: la banda de 60 m (5 MHz, 5.351,5–5.366,5 kHz), donde se recomienda USB para la fonía.]],
)

#q("F-R6.8", "a",
  [En la banda de 2 m, el plan de bandas de la IARU para la Región 1 señala la frecuencia de 144,300 MHz como:],
  ([centro de actividad de SSB], [frecuencia de llamada de FM], [frecuencia de APRS], [segmento de balizas]),
  sol: [En el plan de 2 m, 144,300 MHz es el centro de actividad de SSB, dentro del segmento 144,150– 144,400 MHz (telegrafía, SSB y modos digitales, con 2.700 Hz de anchura máxima). La frecuencia de llamada de FM es 145,500 MHz, el APRS está en 144,800 MHz y las balizas ocupan en exclusiva 144,400–144,490 MHz, justo por encima del tramo de SSB. #no-esta[Plan de 2 m (144–146 MHz) de la IARU para la Región 1, frecuencias clave: 144,300 MHz, centro de actividad de SSB (segmento 144,150–144,400 MHz); 144,400–144,490 MHz, balizas en exclusiva; 144,800 MHz, APRS; 144,975– 145,194 MHz, entrada de repetidores, y 145,575–145,7935 MHz, su salida; 145,500 MHz, frecuencia de llamada de FM; 145,806– 146,000 MHz, satélites en exclusiva.]],
)

#q("F-R6.9", "b",
  [La frecuencia de llamada de FM en la banda de 2 m del plan de bandas de la IARU para la Región 1 es:],
  ([144,300 MHz], [145,500 MHz], [145,800 MHz], [146,000 MHz]),
  sol: [El plan de 2 m marca 145,500 MHz como «FM calling», en el segmento de FM y voz digital que va de 145,206 a 145,5625 MHz. Se llama allí y, al contestar, se pasa a otra frecuencia libre para el QSO. Los 144,300 MHz son el centro de actividad de SSB. Los 145,800 MHz caen en el segmento de comunicación espacial (145,794– 145,806 MHz), junto al de satélites. Los 146,000 MHz son el límite superior de la banda, no una frecuencia de llamada. #vease[(Véase tema R6, introducción del capítulo (frecuencias de llamada).)] #no-esta[Una frecuencia de llamada es un punto de encuentro: se llama allí (#_apc2-m[CQ]) y, al contestar, se pasa a otra frecuencia libre para el QSO. En 2 m, el plan de la IARU para la Región 1 fija 145,500 MHz como frecuencia de llamada de FM, en el segmento de FM y voz digital 145,206–145,5625 MHz; el centro de actividad de SSB es 144,300 MHz.]],
)

#q("F-R6.10", "d",
  [El desplazamiento (_shift_) entre la entrada y la salida de los repetidores de FM en 2 m, según el plan de bandas de la IARU para la Región 1, es de:],
  ([1,6 MHz], [7,6 MHz], [100 kHz], [600 kHz]),
  sol: [En 2 m la entrada de los repetidores empieza en 144,975 MHz y su salida en 145,575 MHz: 145,575 − 144,975 = 0,600 MHz, es decir, 600 kHz, con la salida por encima de la entrada. Los canales clásicos cumplen lo mismo: entrada 145,000 MHz y salida 145,600 MHz. Los 1,6 y 7,6 MHz son desplazamientos de los repetidores de 70 cm; los 100 kHz, los de 10 m (entrada 29,520 MHz, salida 29,620 MHz). #vease[(Véase tema R6, introducción del capítulo (la salida de los repetidores de 2 m va 600 kHz más arriba de la entrada).)]],
)

#q("F-R6.11", "a",
  [En la banda de 70 cm, la frecuencia de llamada de FM del plan de bandas de la IARU para la Región 1 es:],
  ([433,500 MHz], [432,200 MHz], [430,000 MHz], [434,500 MHz]),
  sol: [El plan de 70 cm sitúa la llamada de FM en 433,500 MHz, en el segmento de FM y voz digital 433,400–433,575 MHz, de canales simplex. Los 432,200 MHz son el centro de actividad de SSB. Los 430,000 MHz son el extremo inferior de la banda, no una frecuencia de llamada. Los 434,500 MHz caen en los canales de comunicaciones digitales 434,450–434,575 MHz. #no-esta[En 70 cm (430–440 MHz) el plan de la IARU para la Región 1 fija 433,500 MHz como frecuencia de llamada de FM y 432,200 MHz como centro de actividad de SSB (segmento 432,100–432,400 MHz). Las balizas están en exclusiva en 432,400–432,490 MHz, la entrada de un sistema de repetidores de FM en 433,000–433,375 MHz y los satélites en 435–438 MHz.]],
)

#q("F-R6.12", "d",
  [El centro de actividad de SSB de la banda de 70 cm, según el plan de bandas de la IARU para la Región 1, está en:],
  ([433,500 MHz], [435,000 MHz], [438,000 MHz], [432,200 MHz]),
  sol: [El plan dedica el tramo 432,000–432,400 MHz a la telegrafía, los modos digitales estrechos y la SSB. En él marca 432,050 MHz como centro de actividad de telegrafía y 432,200 MHz como centro de actividad de SSB. Los 433,500 MHz son la frecuencia de llamada de FM. Los 435 MHz marcan el comienzo del segmento de satélites (435–438 MHz) y los 438 MHz su final. #no-esta[El plan de 70 cm de la IARU para la Región 1 reserva el tramo 432,000–432,400 MHz a telegrafía, modos digitales de banda estrecha y SSB. En él, 432,050 MHz es el centro de actividad de telegrafía y 432,200 MHz el de SSB. La frecuencia de llamada de FM es otra, 433,500 MHz, y el tramo 435–438 MHz se dedica a satélites.]],
)

#q("F-R6.13", "c",
  [Un sistema de repetidores de FM de 70 cm del plan de bandas de la IARU para la Región 1 tiene su segmento de entrada a partir de 433,000 MHz y el de salida a partir de 434,600 MHz. Su desplazamiento es de:],
  ([600 kHz], [7,6 MHz], [1,6 MHz], [25 kHz]),
  sol: [El desplazamiento es la diferencia entre salida y entrada: 434,600 − 433,000 = 1,600 MHz, es decir, 1,6 MHz. Los 600 kHz son los de 2 m. Los 25 kHz son una separación entre canales, no un desplazamiento. Los 7,6 MHz corresponden a otro sistema de 70 cm que el plan también recoge (entradas en 431,050–431,9875 MHz, salidas en 438,650–439,5875 MHz), pero no a las frecuencias del enunciado. #vease[(Véase tema R6, introducción del capítulo (entrada y salida de los repetidores).)] #no-esta[En 70 cm el plan de la IARU para la Región 1 recoge varios sistemas de repetidores de FM. Con entrada en 433,000–433,375 MHz y salida a partir de 434,600 MHz, el desplazamiento es de 1,6 MHz. Otro sistema usa 2 MHz (entrada desde 432,600 MHz) y otro 7,6 MHz (entrada desde 431,050 MHz, salida desde 438,650 MHz). El desplazamiento es la diferencia entre la frecuencia de salida y la de entrada.]],
)

#q("F-R6.14", "b",
  [En la banda de 10 m, el canal de llamada de FM del plan de bandas HF de la IARU para la Región 1 es:],
  ([28,500 MHz], [29,600 MHz], [29,000 MHz], [29,300 MHz]),
  sol: [El plan de 10 m dedica el extremo alto a la FM: entradas de repetidores en 29,520–29,590 MHz (canales RH1 a RH8), salidas en 29,620–29,700 MHz (100 kHz más arriba) y, entre ambos grupos, 29,600 MHz como canal de llamada de FM. Los 29,300 MHz son el comienzo del segmento de enlaces de satélite (29,300– 29,510 MHz), y los 29,000 y 28,500 MHz caen en segmentos de todos los modos (SSB y digitales), sin función de llamada de FM. #no-esta[El plan HF de la IARU para la Región 1 dedica el extremo alto de los 10 m a la FM: 29,100– 29,200 MHz, FM simplex en canales de 10 kHz; 29,520–29,590 MHz, entradas de repetidores (canales RH1 a RH8); 29,600 MHz, canal de llamada de FM; 29,620–29,700 MHz, salidas de repetidores. Entre 29,300 y 29,510 MHz hay enlaces de satélite.]],
)

== Tema R7. Responsabilidad social y procedimientos operativos <apc2-sec-r7>

#q("F-R7.1", "c",
  [Según el artículo 31 de la Orden IET/1311/2013, si el titular de una autorización de radioaficionado observa en sus equipos o antenas una anomalía que afecte a su seguridad mecánica o eléctrica, debe:],
  ([comunicarla a la SETSI y esperar sus instrucciones antes de intervenir], [dejarla en manos del instalador de telecomunicaciones, que responde en todo caso de la seguridad de la estación], [subsanarla de forma inmediata, por ser el responsable del mantenimiento de equipos, antenas y elementos anejos], [esperar a la siguiente inspección, porque la SETSI responde del mantenimiento de las instalaciones]),
  sol: [El artículo 31 obliga al titular a cumplir la normativa de seguridad, a mantener adecuadamente equipos, antenas y elementos anejos y a subsanar de forma inmediata cualquier anomalía que afecte a su seguridad mecánica o eléctrica. No se espera a nadie: ni a las instrucciones de la SETSI (a) ni a una inspección (d). El instalador monta la instalación, pero no sustituye al titular en esta obligación (b). Además, la SETSI no es responsable, en ningún caso, del incumplimiento de esas normas. #vease[(Véase tema T10, sección «Fusibles y protecciones».)] #no-esta[El artículo 31 de la Orden IET/1311/2013 obliga al titular de la autorización a cumplir la normativa de seguridad de las distintas Administraciones, para evitar cualquier accidente derivado del uso de su estación. Los equipos, antenas y elementos anejos deben mantenerse adecuadamente, y cualquier anomalía que afecte a su seguridad, mecánica o eléctrica, se subsana de forma inmediata. La SETSI no es responsable, en ningún caso, de que se incumplan esas normas. Para las antenas, el RD 2623/1986 (art. 19) añade que se conserven en perfecto estado.]],
)

#q("F-R7.2", "a",
  [Según el «Código del Radioaficionado» (_Amateur’s Code_), el radioaficionado es considerado, leal, progresista, amistoso, equilibrado y:],
  ([patriota], [disciplinado], [competitivo], [altruista]),
  sol: [El Código del Radioaficionado (_Amateur’s Code_) es una adaptación, recogida en el manual de la IARU _Ethics and Operating Procedures for the Radio Amateur_, del que redactó P. M. Segal en 1928. Describe al radioaficionado como considerado, leal, progresista, amistoso, equilibrado y patriota: tiene su estación y sus conocimientos siempre dispuestos para servir al país y a la comunidad. Disciplinado, competitivo y altruista no figuran entre esos seis rasgos. #vease[(Véase tema R7, sección «Responsabilidad social y procedimientos operativos».)] #no-esta[El Código del Radioaficionado (_Amateur’s Code_, P. M. Segal, 1928) resume la conducta ideal en seis rasgos. Considerado: nunca opera de modo que reste placer a otros. Leal: apoya a los demás aficionados, a los radioclubes y a su asociación nacional. Progresista: estación bien construida y al día, y operación irreprochable. Amistoso: paciente con el principiante y dispuesto a ayudar. Equilibrado: la radio es una afición que no debe quitar tiempo a la familia, al trabajo, a los estudios ni a la comunidad. Patriota: estación y conocimientos siempre al servicio del país y de la comunidad.]],
)

#q("F-R7.3", "d",
  [Se dice que la comunidad radioaficionada es, en gran medida, «autorregulada» (_self-policing_). Esto significa que:],
  ([las asociaciones de radioaficionados pueden multar a los operadores que incumplan las normas], [la Administración renuncia a inspeccionar las estaciones, porque de eso se ocupan los propios aficionados], [cada operador decide por sí mismo qué bandas, frecuencias y potencias utiliza], [la buena conducta en las bandas descansa en la autodisciplina de cada aficionado, sin que la comunidad tenga una policía propia]),
  sol: [La idea procede del manual de la IARU _Ethics and Operating Procedures for the Radio Amateur_: la autodisciplina de cada uno es la base de la conducta, lo que no implica que la comunidad tenga servicios de policía propios. La inspección y las sanciones siguen siendo de la Administración (Orden IET/1311/2013, arts. 33 y 34), por lo que ni las asociaciones multan (a) ni la Administración renuncia a inspeccionar (b). Y las bandas, frecuencias y potencias las fija la reglamentación, no el operador (c). #vease[(Véase tema R7, sección «Responsabilidad social y procedimientos operativos».)] #no-esta[La radioafición se considera en gran medida autorregulada: las autoridades suelen fijarse solo en que se cumplan las normas legales, y por eso la base de la conducta en las bandas es la autodisciplina de cada aficionado. Eso no significa que la comunidad tenga policía propia: la inspección y las sanciones corresponden a la Administración (Orden IET/1311/2013, arts. 33 y 34). De ahí la importancia de conocer las normas de buena práctica y aplicarlas sin esperar a que nadie nos las exija.]],
)

#q("F-R7.4", "b",
  [En una llamada dirigida a una estación concreta, en radiotelefonía, el orden correcto de los distintivos es:],
  ([el propio distintivo, la palabra «de» y el distintivo de la estación llamada], [el distintivo de la estación llamada, la palabra «de» y el propio distintivo], [«#_apc2-m[CQ]», el distintivo de la estación llamada y el propio distintivo], [«#_apc2-m[QRZ]», el propio distintivo y el distintivo de la estación llamada]),
  sol: [En una llamada dirigida se da primero el distintivo de la estación a la que se llama y después el propio, unidos por «de» (en inglés, _from_): «#_apc2-m[EA4ABC] de #_apc2-m[EA5XYZ]». Invertir el orden es un error frecuente (a). #_apc2-m[CQ] es la llamada general a todas las estaciones, de modo que no se dirige a ninguna en particular (c). Y #_apc2-m[QRZ] pregunta «¿quién me llama?», así que tampoco sirve para llamar a nadie (d). #vease[(Véase tema R7, sección «Responsabilidad social y procedimientos operativos».)] #no-esta[Iniciar: en la llamada general se dice «#_apc2-m[CQ] de #_apc2-m[EA5XYZ]», con el distintivo repetido de dos a cuatro veces y «escuchando» al final; no se cierra con «cambio» (aún no hay a quién ceder la palabra) ni con #_apc2-m[QRZ] (que pregunta quién llama). En la llamada dirigida se da primero el distintivo de la estación llamada, luego «de» y el propio. Mantener: se responde igual y se cede la palabra con «cambio». Terminar: despedida (#_apc2-m[73]) e identificación al final de la emisión (Orden IET/1311/2013, art. 29).]],
)

#q("F-R7.5", "c",
  [El código de informe #_apc2-m[SINPO], usado sobre todo por los radioescuchas, valora cada parámetro en una escala de 1 a 5. Sus cinco letras corresponden a:],
  ([legibilidad, intensidad y tono de la señal], [potencia del transmisor, distancia, frecuencia, modulación y antena utilizada], [intensidad de la señal, interferencias, ruido, perturbación de la propagación y calidad global], [únicamente la legibilidad de la señal, de 1 (ilegible) a 5 (perfectamente legible)]),
  sol: [#_apc2-m[SINPO] es un código de informe de recepción (Recomendación UIT-R SM.1135) cuyas letras son las iniciales, en inglés, de _Signal_ (intensidad de la señal), _Interference_ (interferencias), _Noise_ (ruido), _Propagation_ (perturbación de la propagación, como el desvanecimiento) y _Overall_ (calidad global). Cada una se puntúa de 1 a 5. La legibilidad, la intensidad y el tono forman el informe #_apc2-m[RST], el habitual entre radioaficionados; la legibilidad sola es la R de ese informe. #vease[(Véase tema R3, sección «Abreviaturas».)] #no-esta[El informe #_apc2-m[RST] no es el único código de calidad. #_apc2-m[SINPO] lo emplean sobre todo los radioescuchas en sus informes de recepción. Son cinco letras, cada una de 1 a 5, donde 5 es lo mejor: intensidad de la señal (S), interferencias (I), ruido (N), perturbación de la propagación (P), como el desvanecimiento, y calidad global (O). Entre radioaficionados es más habitual el informe #_apc2-m[RS] en fonía y el #_apc2-m[RST] en telegrafía.]],
)
