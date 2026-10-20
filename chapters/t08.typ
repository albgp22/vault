#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Utilidades locales del tema T8
// ---------------------------------------------------------------------

/// Pantalla de instrumento (osciloscopio o analizador): fondo y retícula.
#let _t8-pantalla(ancho, alto, nx, ny, fondo: rgb("#f1f7f3"), rejilla: rgb("#b9dcc7")) = {
  import cetz.draw: *
  rect((0, 0), (ancho, alto), fill: fondo, stroke: none)
  for i in range(1, nx) {
    line((i * ancho / nx, 0), (i * ancho / nx, alto), stroke: 0.4pt + rejilla)
  }
  for j in range(1, ny) {
    line((0, j * alto / ny), (ancho, j * alto / ny), stroke: 0.4pt + rejilla)
  }
  rect((0, 0), (ancho, alto), fill: none, stroke: 1.1pt + col.gris)
}

#let _t8-traza = rgb("#1e7a4c")
#let _t8-chico(c) = text(size: 7.5pt, c)

#tema("T8", "Medidas", alcance: [Medida de tensiones y corrientes continuas y alternas, errores e influencia de la frecuencia y de la resistencia interna del instrumento · medida de resistencia, de potencia (media y de cresta) y de ondas estacionarias · medidas de frecuencia y frecuencia de resonancia · equipos: polímetro, vatímetro de RF, medidor de ROE, frecuencímetro, osciloscopio, analizador de espectros.])

== Técnica de medida <t8-sec-tecnica>

#motivacion[Para saber cuánta corriente pasa por un cable, o qué tensión hay entre dos puntos, hay que _meter un aparato_ en el circuito. Pero ese aparato también es un circuito: tiene su propia resistencia, roba un poco de corriente o añade un poco de resistencia, y lo que lees ya no es exactamente lo que había antes de medir. Toda la técnica de medida gira alrededor de una pregunta: ¿cómo conecto el instrumento para que el circuito casi no note que está ahí?]

Medir es perturbar lo menos posible. El *amperímetro* se intercala *en serie* para que la corriente lo atraviese, y por eso su resistencia interna debe ser mínima; el *voltímetro* se conecta *en paralelo* y la suya debe ser máxima, para no robar corriente al punto medido. Cuando la corriente supera la escala se usa un *shunt*: una resistencia en paralelo que deriva la mayor parte y deja pasar por el instrumento una fracción conocida — que además lo protege. Toda medida arrastra *errores*: los del propio instrumento, los de carga (su resistencia interna) y, en alterna, los de la frecuencia y la forma de onda — un polímetro convencional calibrado para sinusoides miente ante una onda cuadrada, y pocos llegan siquiera a decenas de kHz.

=== Amperímetro en serie, voltímetro en paralelo

#analogia[Piensa en una tubería de agua. Para saber cuántos litros por segundo pasan (la *corriente*), tienes que cortar la tubería e intercalar un caudalímetro: toda el agua debe atravesarlo. Si el caudalímetro es estrecho, frena el agua y mide menos de lo que pasaba antes. Para saber la *presión* (la tensión) no cortas nada: conectas un manómetro entre dos puntos. Si el manómetro deja escapar agua por su tubito, baja la presión que querías medir. Un buen caudalímetro es ancho (resistencia casi nula); un buen manómetro es estanco (resistencia casi infinita).]

#circuito(caption: [Conexión correcta de los instrumentos. El amperímetro A se intercala en el circuito: toda la corriente $I$ lo atraviesa. El voltímetro V se pone «a caballo» entre los dos extremos de la resistencia, sin abrir nada.])[
  #esquema({
    import zap: *
    import cetz.draw: content
    bateria("b", (0, 3), (0, 0), label: $E$)
    wire((0, 3), (0.8, 3))
    medidor("a", (0.8, 3), (2.8, 3), letra: "A")
    wire((2.8, 3), (4.5, 3), i: $I$)
    resistor("r", (4.5, 3), (4.5, 0), label: $R$)
    wire((4.5, 3), (6.2, 3))
    medidor("v", (6.2, 3), (6.2, 0), letra: "V")
    wire((6.2, 0), (0, 0))
    node("n1", (4.5, 3))
    node("n2", (4.5, 0))
    content((1.8, 3.75), _t8-chico[en serie: $R_"int" approx 0$])
    content((7.5, 1.5), _t8-chico[en paralelo:\ $R_"int" -> infinity$])
  })
] <t8-fig-conexion>

#porque[
  - *El amperímetro* está en serie: la misma corriente pasa por la pila, por él y por $R$. Su resistencia interna se suma a la del circuito; si no fuera casi nula, la corriente bajaría al conectarlo y mediríamos menos de lo que había.
  - *El voltímetro* está en paralelo con $R$: tiene sus dos bornes en los mismos puntos que ella, así que ve su misma tensión. Pero abre un segundo camino a la corriente; si su resistencia interna no fuera muy grande, robaría corriente a $R$ y bajaría la tensión que quería medir.
  - *Si los cambias de sitio*, el voltímetro en serie corta casi toda la corriente (marca casi la tensión de la pila, y el circuito deja de funcionar), y el amperímetro en paralelo es un cortocircuito: pasa por él una corriente enorme que puede quemarlo. Por eso el amperímetro nunca se conecta directamente entre los bornes de una fuente.
]

#ejemplo(titulo: [El error de carga del voltímetro])[
  Dos resistencias de 100 kΩ en serie forman un divisor alimentado con 10 V; en el punto medio hay 5 V. Lo medimos con un voltímetro analógico cuya resistencia interna en esa escala es de 100 kΩ. El voltímetro queda en paralelo con la resistencia de abajo: $100 "kΩ" parallel 100 "kΩ" = 50 "kΩ"$, y el divisor da ahora $10 dot 50 slash (100 + 50) approx 3,3$ V. ¡El instrumento marca un 33 % menos de lo que había!

  Con un polímetro digital de 10 MΩ: $100 "kΩ" parallel 10 "MΩ" approx 99 "kΩ"$, y la lectura es de 4,97 V, un error de solo el 0,5 %. La regla práctica: la resistencia del voltímetro debe ser al menos cien veces mayor que la del circuito que mide.
]

#ojo[El examen pregunta lo mismo de tres maneras: cómo se conecta el amperímetro (en serie, T8.1), cómo se conecta el voltímetro (en paralelo, sin abrir el circuito, T8.17) y qué resistencia tendrían los ideales (nula el amperímetro, infinita el voltímetro, T8.19). Las tres salen de la misma idea: *perturbar lo mínimo*. Cuidado con el orden de las opciones en T8.19: «nula e infinita», no al revés.]

=== Ampliar la escala: shunt y resistencia en serie

#motivacion[El corazón de un instrumento analógico es un *galvanómetro*: una bobina que gira en el campo de un imán y mueve la aguja. Es delicadísimo: llega a fondo de escala con, por ejemplo, 1 mA, y su bobina tiene una resistencia de unos 100 Ω. Con él queremos medir 10 A en una fuente o 100 V en un circuito. ¿Cómo, sin quemarlo?]

#circuito(caption: [Los dos trucos para ampliar la escala de un galvanómetro G de resistencia interna $R_m$. (a) Amperímetro: el *shunt* $R_s$, en paralelo, desvía la mayor parte de la corriente. (b) Voltímetro: la resistencia multiplicadora $R_V$, en serie, limita la corriente que llega al galvanómetro.])[
  #grid(
    columns: (1fr, 1fr),
    align: center + bottom,
    esquema({
      import zap: *
      import cetz.draw: content
      wire((-0.6, 2), (1, 2), i: $I$)
      node("na", (-0.6, 2), fill: false)
      wire((1, 3), (1, 1))
      medidor("g", (1, 3), (3.4, 3), letra: "G", label: [$I_m$ #h(1.6em) $R_m$])
      resistor("rs", (1, 1), (3.4, 1), label: (content: [$R_s$, por él pasa $I_s = I - I_m$], anchor: "south"))
      wire((3.4, 3), (3.4, 1))
      wire((3.4, 2), (4.6, 2))
      node("nb", (4.6, 2), fill: false)
      node("n1", (1, 2))
      node("n2", (3.4, 2))
      content((2.2, -0.4), text(size: 8.5pt)[(a) amperímetro])
    }),
    esquema({
      import zap: *
      import cetz.draw: content, line
      resistor("rv", (0, 2), (2.2, 2), label: $R_V$, n: "o-")
      medidor("g2", (2.2, 2), (4.4, 2), letra: "G", label: $R_m$, n: "-o")
      line((0, 0.9), (4.4, 0.9), mark: (start: ">", end: ">", fill: black), stroke: 0.6pt)
      content((2.2, 0.55), _t8-chico[$V = I_m (R_V + R_m)$])
      content((2.2, -0.4), text(size: 8.5pt)[(b) voltímetro])
    }),
  )
] <t8-fig-shunt>

#porque[
  - *Shunt (a).* El galvanómetro y $R_s$ están en paralelo: tienen la misma tensión, $I_m R_m = I_s R_s$. Si $R_s$ es mucho menor que $R_m$, casi toda la corriente se va por el shunt y solo una fracción pequeña y *conocida* pasa por la aguja. Basta graduar la escala multiplicando. Y de paso el galvanómetro queda protegido: el grueso de la corriente nunca lo atraviesa (T8.11).
  - *Resistencia multiplicadora (b).* En serie con el galvanómetro, $R_V$ hace que, con la tensión máxima de la escala, circule justo la corriente de fondo de escala. Cuanto mayor es $R_V$, mayor es la resistencia total del voltímetro, y menos carga el circuito que mide.
]

#destacada($display(R_s = (I_m R_m) / (I - I_m) quad quad quad R_V = V / I_m - R_m)$, nota: [shunt para medir hasta $I$; resistencia en serie para medir hasta $V$])

#ejemplo[
  Galvanómetro de 1 mA a fondo de escala y $R_m = 100$ Ω.
  - Para medir hasta *1 A*: $R_s = (0,001 dot 100) / (1 - 0,001) approx 0,1$ Ω. Por la aguja pasa 1 mA y por el shunt, 999 mA. La caída en el instrumento es de solo 0,1 V: casi no perturba.
  - Para medir hasta *10 V*: $R_V = 10 slash 0,001 - 100 = 9900$ Ω. El voltímetro completo tiene 10 kΩ, es decir, *1000 Ω/V*: la «sensibilidad» que se lee en la esfera de los polímetros analógicos. Un polímetro de 20 000 Ω/V carga mucho menos el circuito.
]

=== El óhmetro: medir con la pila del propio instrumento

#circuito(caption: [Principio del óhmetro. La pila interna hace circular una corriente por la resistencia desconocida $R_x$; con los bornes en cortocircuito, el ajuste de cero $R_0$ lleva la aguja a fondo de escala.])[
  #esquema({
    import zap: *
    import cetz.draw: content, rect
    rect((-0.75, -0.4), (5.4, 3.5), radius: 0.15, stroke: (paint: col.gris, thickness: 0.5pt, dash: "dashed"))
    bateria("b", (0, 2.4), (0, 0), label: $E$)
    wire((0, 2.4), (0.6, 2.4))
    medidor("g", (0.6, 2.4), (2.4, 2.4), letra: "G")
    rheostat("r0", (2.4, 2.4), (4.4, 2.4), label: $R_0$)
    wire((4.4, 2.4), (5.4, 2.4))
    node("t1", (5.4, 2.4), fill: false)
    wire((0, 0), (5.4, 0))
    node("t2", (5.4, 0), fill: false)
    wire((5.4, 2.4), (6.6, 2.4))
    resistor("rx", (6.6, 2.4), (6.6, 0), label: $R_x$)
    wire((6.6, 0), (5.4, 0))
    content((2.3, -0.7), _t8-chico[interior del óhmetro])
    content((8.7, 1.2), _t8-chico[resistencia\ que se mide])
  })
] <t8-fig-ohmetro>

#porque[
  - La corriente vale $I = E slash (R_"int" + R_x)$, donde $R_"int"$ reúne la del galvanómetro y $R_0$. Con $R_x = 0$ la aguja va a fondo; con $R_x = R_"int"$ queda a media escala; con los bornes al aire no se mueve. Por eso la escala del óhmetro analógico va *al revés* y no es lineal. Los polímetros digitales hacen lo mismo de otra forma: inyectan una corriente conocida y miden la tensión que aparece.
  - *Consecuencia práctica:* el óhmetro pone su propia pila. Si el circuito tiene tensión propia, esa tensión se suma o se resta a la de la pila y la lectura no significa nada — y además puede dañarse el instrumento (T8.18). Por eso se mide siempre *sin tensión* y con los condensadores descargados (T8.24). Si la resistencia está soldada en el circuito, otros componentes en paralelo falsean la medida: se desuelda una pata.
]

=== Los errores de la medida

Ningún instrumento es perfecto, y conviene saber de dónde viene cada error:
- *Error del instrumento*: su precisión de fábrica, que en los analógicos se indica con la *clase* (un instrumento de clase 1,5 puede equivocarse en el 1,5 % del fondo de escala). Por eso se elige la escala en la que la aguja queda en el último tercio.
- *Error de carga*: el que acabas de ver; depende de la resistencia interna frente a la del circuito.
- *Error de frecuencia*: los circuitos de un polímetro corriente están pensados para los 50 Hz de la red. A unos kHz empiezan a fallar, y en RF no sirven: para medir RF hay sondas con diodo detector, vatímetros y osciloscopios.
- *Error de forma de onda*: lo trata el último párrafo de esta sección.

En radio, las potencias se manejan en *decibelios absolutos*: dBm (referidos a 1 mW) y dBW (a 1 W). Las conversiones del examen salen solas con dos anclas — 1 W = 30 dBm = 0 dBW — y las reglas de +3, +10 y +20 dB del tema T1. También conviene distinguir potencia *media* y potencia de *cresta de la envolvente* (p.c.e.): la media promedia a lo largo de la modulación; la p.c.e. es la potencia media de un ciclo de RF en el pico de la envolvente — el máximo que alcanza la señal al modular. En SSB no hay portadora y la potencia sube y baja con la voz, de modo que la media dice poco: la p.c.e. es la magnitud natural del modo, y en ella se expresan los límites legales y la potencia de los equipos. Con voz sin procesar, la media queda muy por debajo — del orden de la cuarta a la décima parte de la p.c.e.

=== Decibelios absolutos: dBm y dBW

#motivacion[En una estación conviven potencias absurdamente distintas: 100 W en la antena y $10^(-15)$ W en la entrada del receptor. Escribirlas en vatios llena todo de ceros. El decibelio las convierte en números manejables y, sobre todo, cambia las multiplicaciones por sumas: un amplificador de 20 dB *suma* 20 al nivel que recibe.]

Un nivel en dBm dice cuántos decibelios está una potencia por encima (o por debajo) de 1 mW; en dBW, por encima de 1 W:

#destacada($display(P_"dBm" = 10 log_10 P / (1 "mW") quad quad quad P_"dBW" = 10 log_10 P / (1 "W") = P_"dBm" - 30)$)

#align(center, block(breakable: false, table(
  columns: 8,
  align: center,
  [*Potencia*], [1 mW], [10 mW], [100 mW], [1 W], [10 W], [100 W], [1 kW],
  [*dBm*], [0], [10], [20], [30], [40], [50], [60],
  [*dBW*], [−30], [−20], [−10], [0], [10], [20], [30],
)))

#truco[Cada 10 dB, un cero más: 20 dB es ×100, 40 dB es ×10 000 (T8.12). Cada 3 dB, el doble: 2 W son 33 dBm y 200 W, 53 dBm. Con estas dos reglas y el ancla «1 W = 30 dBm» se resuelven casi todas las preguntas.]

#ejemplo[
  - 1000 mW = 1 W = *30 dBm* (T8.3).
  - Un amplificador de 20 dB recibe 0,2 W: 20 dB = ×100, sale $0,2 dot 100 = 20$ W (T8.4). En dBm: 0,2 W = 23 dBm; 23 + 20 = 43 dBm = 20 W. Las dos cuentas coinciden.
  - Un receptor con un preamplificador de 10 dB y un cable que pierde 3 dB: ganancia neta $10 - 3 = 7$ dB. En decibelios, ganancias y pérdidas simplemente se suman.
]

=== Potencia media y potencia de cresta de la envolvente

#circuito(caption: [Una señal de SSB modulada por la voz. La envolvente (línea discontinua) sube y baja con la palabra; la p.c.e. se mide en el pico más alto, donde la señal alcanza su máximo. La potencia media, promediada en todo el tiempo, es mucho menor.])[
  #cetz.canvas({
    import cetz.draw: *
    let env(x) = {
      let a = calc.max(0, calc.sin(x * 1.25)) * (0.55 + 0.45 * calc.sin(x * 0.33 + 1.2))
      let b = calc.max(0, calc.sin(x * 1.9 + 0.8)) * 0.35
      calc.min(1.0, a + b)
    }
    ejes(0, 11.4, -1.35, 1.45, etq-x: $t$, etq-y: $v$)
    onda(x => env(x) * calc.sin(x * 38), 0, 11, n: 1400, stroke: 0.45pt + col.senal1)
    onda(x => env(x), 0, 11, n: 300, stroke: (paint: col.senal2, thickness: 0.8pt, dash: "dashed"))
    let pico = range(0, 1101).map(i => env(i / 100)).fold(0, calc.max)
    line((0, pico), (11, pico), stroke: (paint: col.naranja, thickness: 0.6pt, dash: "dotted"))
    content((11.1, pico), anchor: "west", text(size: 7.5pt, fill: col.naranja)[pico de la\ envolvente → p.c.e.])
  })
] <t8-fig-pce>

La p.c.e. responde a la pregunta «¿cuánto se estira la señal en su momento más fuerte?». Es lo que tienen que aguantar sin distorsión los transistores del paso final, y por eso es la cifra que da el fabricante y la que limita la licencia.

- Con una *portadora sin modular* (CW con el manipulador apretado, o FM), la amplitud es constante: la media y la p.c.e. coinciden.
- En *AM* modulada al 100 %, la amplitud llega al doble de la de la portadora en los picos, y la potencia en el pico de la envolvente es $2^2 = 4$ veces la potencia de la portadora.
- En *SSB* con voz, la p.c.e. de 100 W corresponde a una potencia media de solo 10 a 25 W. Un procesador de voz comprime la señal y sube la media sin cambiar la p.c.e.

Un matiz de alterna que el examen roza: la mayoría de polímetros no miden el verdadero valor eficaz — rectifican, promedian y multiplican por el factor de forma de la sinusoide (1,11). Con ondas no sinusoidales (cuadradas, ruido, RF modulada) el resultado miente, y hacen falta instrumentos de _verdadero valor eficaz_ (true RMS).

=== Valor eficaz, valor medio y factor de forma

#circuito(caption: [Tres valores de una misma onda. En la sinusoide, el valor eficaz es $0,707 V_p$ y el valor medio de la onda rectificada, $0,637 V_p$: su cociente es el factor de forma, 1,11. En la onda cuadrada los tres valores coinciden con $V_p$.])[
  #grid(
    columns: (1fr, 1fr),
    align: center + bottom,
    cetz.canvas({
      import cetz.draw: *
      ejes(0, 6.6, -1.3, 1.5, etq-x: $t$, etq-y: $v$)
      onda(x => calc.sin(x), 0, 6.28, stroke: 1.1pt + col.senal1)
      line((0, 1), (6.3, 1), stroke: (paint: col.gris, thickness: 0.5pt, dash: "dotted"))
      line((0, 0.707), (6.3, 0.707), stroke: (paint: col.senal2, thickness: 0.8pt, dash: "dashed"))
      line((0, 0.637), (6.3, 0.637), stroke: (paint: col.senal3, thickness: 0.8pt, dash: "dotted"))
      content((-0.1, 1), anchor: "east", text(size: 7pt)[$V_p$])
      content((6.4, 0.80), anchor: "west", text(size: 7pt, fill: col.senal2)[eficaz 0,707])
      content((6.4, 0.52), anchor: "west", text(size: 7pt, fill: col.senal3)[medio 0,637])
    }),
    cetz.canvas({
      import cetz.draw: *
      ejes(0, 6.6, -1.3, 1.5, etq-x: $t$, etq-y: $v$)
      line((0, 1), (1.57, 1), (1.57, -1), (3.14, -1), (3.14, 1), (4.71, 1), (4.71, -1), (6.28, -1), stroke: 1.1pt + col.senal1)
      content((-0.1, 1), anchor: "east", text(size: 7pt)[$V_p$])
      content((3.2, 1.3), text(size: 7pt)[eficaz = medio = $V_p$])
    }),
  )
] <t8-fig-eficaz>

#porque[
  Un polímetro barato no mide el valor eficaz: rectifica la señal, mide el valor *medio* (que es lo fácil de medir con un circuito sencillo) y lo multiplica por 1,11, el factor que convierte el medio en eficaz *solo si la onda es una sinusoide*. Con otra forma de onda el factor es otro, y la lectura sale mal. Un instrumento _true RMS_ calcula de verdad el valor eficaz, que es el que da la potencia: $P = V_"ef"^2 slash R$.
]

#ejemplo[
  Una onda cuadrada de ±5 V tiene valor eficaz 5 V (en cada instante la tensión vale 5 V en valor absoluto). El polímetro de valor medio mide 5 V de media y lo multiplica por 1,11: marca *5,55 V*, un 11 % de más. Con ruido o con RF modulada el error puede ser mayor.
]

#q("T8.1", "a",
  [Para medir la corriente que circula por un circuito, el amperímetro debe conectarse:],
  ([en serie con el circuito], [en paralelo con el circuito], [entre el chasis y tierra], [indistintamente en serie o en paralelo]),
  sol: [El amperímetro va en serie (resistencia interna muy baja); el voltímetro, en paralelo.],
)

#q("T8.2", "b",
  [Una batería marcada como «DC 7,4 V – 1500 mAh» podrá suministrar:],
  ([7,4 A durante 15 horas], [1,5 A durante una hora], [15 A durante una hora], [1500 A durante un segundo]),
  sol: [1500 mAh = 1,5 Ah: 1,5 A durante una hora (o 0,15 A durante diez).],
)

#q("T8.3", "d",
  [A una potencia de 1000 mW le corresponde un nivel de:],
  ([10 dBm], [20 dBm], [3 dBm], [30 dBm]),
  sol: [$10 log_10 (1000 "mW" slash 1 "mW") = 30$ dBm. Referencias: 1 mW = 0 dBm; 1 W = 30 dBm; 100 W = 50 dBm.],
)

#q("T8.4", "c",
  [Un amplificador de 20 dB de ganancia, con impedancias de entrada y salida iguales, recibe una potencia de entrada de 0,2 W. Su potencia de salida es:],
  ([2 W], [4 W], [20 W], [40 W]),
  sol: [+20 dB = ×100: 0,2 × 100 = 20 W.],
)

== Instrumentos <t8-sec-instrumentos>

Cada instrumento responde a una pregunta distinta. El *polímetro*: tensión, corriente y resistencia (no la impedancia de una antena en RF, que exige un puente o analizador de antenas). El *vatímetro* de RF, casi siempre direccional: potencia directa y reflejada — y de su cociente, el *medidor de ROE* deduce la adaptación. El *frecuencímetro* cuenta ciclos contra una base de tiempos de cristal: la medida de frecuencia de precisión. El *osciloscopio* dibuja la señal en el _dominio del tiempo_ (@t8-fig-osc): amplitud, período, distorsión, envolvente de modulación. Su complementario es el *analizador de espectros*, que la descompone en el _dominio de la frecuencia_: portadora, bandas laterales, armónicos y espurias con sus niveles. El *generador de señal* entrega señales calibradas en frecuencia y nivel para caracterizar etapas y receptores, y el *medidor de campo* evalúa la intensidad de campo radiado, en V/m (o dBμV/m).

#circuito(caption: [La pantalla del osciloscopio muestra la señal en el dominio del tiempo: de la traza se leen directamente la amplitud $A$ y el período $T$ (y de este, la frecuencia $f = 1 slash T$).])[
  #cetz.canvas({
    import cetz.draw: *
    let d = 0.55
    let (an, al) = (10 * d, 8 * d)
    _t8-pantalla(an, al, 10, 8)
    line((0, al / 2), (an, al / 2), stroke: 0.6pt + rgb("#8cc3a5"))
    let x0 = 1.5 * d
    let per = 4 * d
    let amp = 3 * d
    onda(x => al / 2 + amp * calc.cos(2 * calc.pi * (x - x0) / per), 0, an, n: 240, stroke: 1.4pt + _t8-traza)
    line((x0, al / 2 + amp), (x0, al / 2), mark: (start: ">", end: ">", fill: black, scale: 0.7), stroke: 0.6pt)
    content((x0 + 0.12, al / 2 + amp / 2.2), anchor: "west", text(size: 8pt, $A$))
    line((x0, 0.3), (x0 + per, 0.3), mark: (start: ">", end: ">", fill: black, scale: 0.7), stroke: 0.6pt)
    content((x0 + per / 2, 0.3), anchor: "south", padding: 2pt, text(size: 8pt, $T$))
  })
] <t8-fig-osc>

#ejemplo(titulo: [Del vatímetro a la ROE, y dos reglas])[Del vatímetro direccional a la ROE: con 100 W directos y 11 W reflejados, $sqrt(P_r slash P_d) = 0,33$ y ROE $= (1 + 0,33) slash (1 - 0,33) approx 2$. Y dos reglas de instrumentación: la resolución de un frecuencímetro es el inverso de su tiempo de puerta (1 s de puerta → 1 Hz), y el tiempo de subida más rápido que un osciloscopio puede mostrar vale $t_r approx 0,35 slash B$ — un osciloscopio de 100 MHz no ve flancos por debajo de 3,5 ns.]

=== El polímetro

#motivacion[El 90 % de las averías de una estación se diagnostican con preguntas simples: ¿llega tensión?, ¿pasa corriente?, ¿este cable está cortado?, ¿esta resistencia tiene su valor? Un solo aparato barato las responde todas.]

El polímetro (o multímetro) reúne en una caja un voltímetro, un amperímetro y un óhmetro, para continua y para alterna de baja frecuencia, con un conmutador que elige la magnitud y la escala. Los digitales añaden prueba de continuidad (pitido), de diodos y a veces de condensadores.

Lo que *no* puede medir es la *impedancia de una antena* (T8.9). Esa impedancia es un número complejo (resistencia y reactancia) que solo existe a la frecuencia de trabajo, y el óhmetro mide con corriente continua. Un dipolo, por ejemplo, es un circuito abierto en continua — el óhmetro marca infinito —, y un dipolo plegado, un cortocircuito; en su frecuencia de resonancia los dos presentan decenas o cientos de ohmios. Para eso están el puente de impedancias y, hoy, el *analizador de antenas*: un pequeño generador más un puente que barre la banda y dibuja la ROE y la impedancia frecuencia a frecuencia.

=== El osciloscopio: la señal en función del tiempo

#motivacion[El voltímetro da un solo número. Pero una señal puede estar recortada, llevar ruido, tener la envolvente deformada… y el número no lo cuenta. Hace falta *ver* la forma de onda.]

El osciloscopio dibuja la tensión (eje vertical) en función del tiempo (eje horizontal). La pantalla tiene una retícula; dos mandos dicen cuánto vale cada cuadro (cada *división*): el de *voltios por división* (vertical) y el de *tiempo por división* (horizontal, la base de tiempos). Leer la pantalla es contar cuadros y multiplicar.

#ejemplo(titulo: [Leer la pantalla])[
  En la @t8-fig-osc la amplitud $A$ ocupa 3 divisiones y el período $T$, 4. Si el osciloscopio está en 2 V/div y 0,1 ms/div:
  - amplitud (de pico) $A = 3 dot 2 = 6$ V; tensión pico a pico, 12 V; valor eficaz $6 slash sqrt(2) approx 4,2$ V;
  - período $T = 4 dot 0,1 = 0,4$ ms; frecuencia $f = 1 slash T = 2500$ Hz.
]

El osciloscopio también tiene un límite de frecuencia, su *ancho de banda* $B$: por encima de él la traza se aplasta. El tiempo de subida más rápido que puede mostrar es $t_r approx 0,35 slash B$. En radio se usa para ver la forma de onda del audio, la envolvente de una señal de AM o SSB (y detectar si está recortada por exceso de modulación) o la salida de un oscilador.

=== El frecuencímetro: contar ciclos durante un tiempo exacto

#motivacion[Tu licencia te permite emitir dentro de una banda, y hay que saber con precisión dónde estás. La escala de un dial no basta. La manera más exacta de medir una frecuencia es la más sencilla: contar cuántos ciclos pasan en un segundo.]

#circuito(caption: [Diagrama de bloques del frecuencímetro. El oscilador de cristal abre la puerta durante un tiempo exacto (1 s, por ejemplo) y el contador cuenta los impulsos que pasan: el número contado es la frecuencia.])[
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (7mm, 9mm),
    node((0, 0), [Entrada], stroke: none),
    edge("-|>"),
    node((1, 0), align(center)[Amplificador y\ conformador], shape: rect),
    edge("-|>"),
    node((2, 0), [Puerta], shape: rect),
    edge("-|>"),
    node((3, 0), [Contador], shape: rect),
    edge("-|>"),
    node((4, 0), [Pantalla], shape: rect),
    node((2, 1), align(center)[Base de tiempos\ (cristal + divisores)], shape: rect),
    edge((2, 1), (2, 0), "-|>", label: text(size: 8pt)[abre 1 s], label-side: left),
  )
] <t8-fig-frecuencimetro>

#porque[
  - El *conformador* convierte la señal de entrada (senoidal, de cualquier nivel) en impulsos cuadrados limpios, uno por ciclo.
  - La *base de tiempos* es un oscilador de cristal de cuarzo (por ejemplo de 10 MHz) seguido de divisores: da un intervalo de tiempo muy exacto, que abre la *puerta*.
  - El *contador* suma los impulsos que pasan mientras la puerta está abierta. Con la puerta abierta 1 s, contar 7 050 123 impulsos significa 7 050 123 Hz.
  - La *resolución* es el inverso del tiempo de puerta: con 1 s se aprecia 1 Hz; con 0,1 s, solo 10 Hz. La *exactitud*, en cambio, la pone el cristal de referencia: si se desvía 10 partes por millón, en 145 MHz el error es de $145 dot 10^6 dot 10 dot 10^(-6) = 1450$ Hz, por muchos dígitos que tenga la pantalla.
]

=== El analizador de espectros: la señal en función de la frecuencia

#motivacion[Tu transmisor de 7 MHz emite también, débilmente, en 14 y en 21 MHz. En el osciloscopio apenas se nota: la sinusoide está un poco deformada y nada más. Pero esos armónicos pueden molestar a otros servicios, y necesitas saber *dónde* están y *cuánto* valen.]

#circuito(caption: [La misma señal vista por los dos instrumentos. (a) En el osciloscopio, una sinusoide ligeramente deformada. (b) En el analizador de espectros, cada componente es una raya: la fundamental y sus armónicos, con su nivel en dB por debajo de la portadora (dBc).])[
  #grid(
    columns: (1fr, 1fr),
    align: center + bottom,
    cetz.canvas({
      import cetz.draw: *
      let (an, al) = (4.8, 3.2)
      _t8-pantalla(an, al, 8, 6)
      onda(x => al / 2 + 1.05 * calc.sin(2 * calc.pi * x / 2.4) + 0.22 * calc.sin(4 * calc.pi * x / 2.4 + 0.6) + 0.1 * calc.sin(6 * calc.pi * x / 2.4), 0, an, n: 240, stroke: 1.3pt + _t8-traza)
      content((an / 2, -0.35), text(size: 8pt)[(a) dominio del tiempo])
    }),
    cetz.canvas({
      import cetz.draw: *
      let (an, al) = (4.8, 3.2)
      _t8-pantalla(an, al, 8, 8)
      let dy = al / 8
      // ruido de fondo
      onda(x => 0.18 + 0.06 * calc.sin(x * 37) + 0.05 * calc.sin(x * 91 + 1), 0.02, an - 0.02, n: 300, stroke: 0.5pt + _t8-traza)
      let raya(x, nivel, etq) = {
        line((x, 0.18), (x, al - nivel * dy), stroke: 1.4pt + _t8-traza)
        content((x, al - nivel * dy), anchor: "south", padding: 1.5pt, text(size: 6.5pt, etq))
      }
      raya(1.2, 0.3, [$f_0$])
      raya(2.4, 4.3, [$2 f_0$])
      raya(3.6, 5.6, [$3 f_0$])
      content((-0.08, al - 0.3 * dy), anchor: "east", text(size: 6.5pt)[0 dBc])
      content((-0.08, al - 4.3 * dy), anchor: "east", text(size: 6.5pt)[−40])
      content((-0.08, al - 5.6 * dy), anchor: "east", text(size: 6.5pt)[−53])
      content((an / 2, -0.35), text(size: 8pt)[(b) dominio de la frecuencia])
    }),
  )
] <t8-fig-espectro>

El analizador de espectros es, por dentro, un receptor superheterodino que barre una banda de frecuencias una y otra vez y dibuja el nivel que recibe en cada punto: el eje horizontal es la frecuencia y el vertical, la potencia en dB. Así se ven de un vistazo la portadora, las bandas laterales de la modulación, los armónicos y cualquier espuria (T8.8).

#ejemplo[
  Un transmisor de 100 W tiene su segundo armónico a −40 dBc. Cuarenta decibelios son un factor $10^4$: el armónico lleva $100 slash 10 000 = 10$ mW. Parece poco, pero 10 mW bien radiados se oyen a muchos kilómetros: por eso existen límites para las emisiones no esenciales y por eso se mide con el analizador.
]

=== El vatímetro direccional y el medidor de ROE

#motivacion[Cuando la antena no está adaptada, por el cable viajan dos ondas a la vez: la *directa*, del transmisor a la antena, y la *reflejada*, de vuelta. Un simple voltímetro de RF colgado del cable ve la suma de las dos, y esa suma cambia de un punto a otro del cable (es la onda estacionaria, que puedes ver formarse en #falstad("tlstand.txt")). Para saber cuánta potencia va y cuánta vuelve hace falta un instrumento que distinga el *sentido de la marcha*.]

#analogia[Es como contar coches en una autovía con un único sensor que no distingue carriles: sabrías cuánto tráfico hay, pero no cuánto va y cuánto vuelve. El acoplador direccional pone un contador en cada carril.]

#circuito(caption: [Principio del vatímetro direccional. Dos líneas de muestra discurren junto al conductor central. Cada una lleva en un extremo una resistencia de terminación $R$ y en el otro un detector (diodo y condensador) con su medidor. La de la izquierda solo responde a la onda directa; la de la derecha, solo a la reflejada.])[
  #esquema({
    import zap: *
    import cetz.draw: content, line
    // línea principal
    wire((0, 3), (10, 3), stroke: 1.6pt)
    node("tx", (0, 3), fill: false)
    node("ant", (10, 3), fill: false)
    content((0, 3.35), anchor: "south", _t8-chico[del transmisor])
    content((10, 3.35), anchor: "south", _t8-chico[a la antena])
    line((3.6, 3.85), (6.4, 3.85), mark: (end: ">", fill: col.senal1), stroke: 0.7pt + col.senal1)
    content((6.55, 3.85), anchor: "west", text(size: 7.5pt, fill: col.senal1)[onda directa])
    line((6.4, 3.4), (3.6, 3.4), mark: (end: ">", fill: col.senal2), stroke: 0.7pt + col.senal2)
    content((3.45, 3.4), anchor: "east", text(size: 7.5pt, fill: col.senal2)[onda reflejada])
    // línea de muestra de la directa
    wire((1.8, 2.45), (4.2, 2.45), stroke: 1.1pt)
    resistor("r1", (4.2, 2.45), (4.2, 0), label: $R$)
    ground("g1", (4.2, 0))
    diode("d1", (1.8, 2.45), (1.8, 1.2))
    capacitor("c1", (1.8, 1.2), (1.8, 0))
    ground("g2", (1.8, 0))
    wire((1.8, 1.2), (0.6, 1.2))
    medidor("m1", (0.6, 1.2), (0.6, 0), letra: "DIR")
    ground("g3", (0.6, 0))
    node("k1", (1.8, 1.2))
    // línea de muestra de la reflejada
    wire((5.8, 2.45), (8.2, 2.45), stroke: 1.1pt)
    resistor("r2", (5.8, 2.45), (5.8, 0), label: $R$)
    ground("g4", (5.8, 0))
    diode("d2", (8.2, 2.45), (8.2, 1.2))
    capacitor("c2", (8.2, 1.2), (8.2, 0))
    ground("g5", (8.2, 0))
    wire((8.2, 1.2), (9.4, 1.2))
    medidor("m2", (9.4, 1.2), (9.4, 0), letra: "REF")
    ground("g6", (9.4, 0))
    node("k2", (8.2, 1.2))
  })
] <t8-fig-direccional>

#porque[
  - Cada línea de muestra está tan cerca del conductor central que recoge de él *dos* muestras. Una, por la capacidad entre ambos, es proporcional a la *tensión* de la línea y empuja corriente hacia los dos extremos por igual. Otra, por inducción (como el secundario de un transformador), es proporcional a la *corriente* y empuja corriente en un solo sentido a lo largo de la línea de muestra.
  - En la onda directa, tensión y corriente marchan a la par ($V = 50 dot I$ en una línea de 50 Ω): en un extremo las dos muestras se suman y en el otro se cancelan. En la onda reflejada la corriente va al revés respecto a la tensión ($V = -50 dot I$), y la suma y la cancelación cambian de extremo.
  - Por eso cada línea de muestra lleva en un extremo el detector y en el otro una resistencia $R$ que absorbe lo que llega allí: la de la izquierda solo «oye» la onda directa y la de la derecha, solo la reflejada. El diodo rectifica la muestra de RF, el condensador la convierte en continua y el medidor da una lectura proporcional a cada potencia.
  - Si la antena está perfectamente adaptada no hay onda reflejada y el medidor REF marca cero (T8.25).
]

De las dos lecturas sale todo lo demás. El coeficiente de reflexión $rho$ es la raíz del cociente de potencias, y de él sale la ROE; la potencia que de verdad entrega el cable a la antena es la directa *menos* la reflejada:

#destacada($display(rho = sqrt(P_r / P_d) quad quad quad "ROE" = (1 + rho) / (1 - rho) quad quad quad P_"antena" = P_d - P_r)$)

#align(center, block(breakable: false, table(
  columns: 6,
  align: center,
  [*ROE*], [1], [1,5], [2], [3], [$infinity$],
  [*Potencia reflejada*], [0 %], [4 %], [11 %], [25 %], [100 %],
)))

#ojo[El medidor de ROE no mide la potencia que radia la antena, ni su ganancia, ni su frecuencia de resonancia: mide la relación entre la onda que llega a la antena y la que vuelve (T8.27). Y con 100 W directos y 25 W reflejados la antena no recibe 125 W, sino 75 W (T8.30). Muchos medidores de ROE llevan también una escala de vatios, pero su función es avisar de la desadaptación: por eso es el instrumento imprescindible de la estación (T8.14, T8.29).]

=== El generador de señal y el medidor de campo

El *generador de señal* es la pieza opuesta al receptor: produce una señal de frecuencia y nivel conocidos con exactitud. Inyectándola en la entrada de un receptor se mide su sensibilidad («¿qué señal mínima entiendo?»), y en una etapa, su ganancia o su respuesta en frecuencia (T8.15).

El *medidor de campo* responde a otra pregunta: ¿qué intensidad de campo eléctrico llega a un lugar? Lo da en voltios por metro (V/m), o en sus submúltiplos μV/m y dBμV/m (T8.10). En espacio libre, lejos de la antena, el campo vale aproximadamente

#destacada($display(E approx sqrt(30 P G) / d)$, nota: [$E$ en V/m, $P$ en W, $G$ ganancia de la antena respecto a la isotrópica (en veces), $d$ en m])

#ejemplo[
  Un dipolo ($G approx 1,64$) con 100 W, a 100 m: $E approx sqrt(30 dot 100 dot 1\,64) slash 100 approx 0,7$ V/m. Es un campo fortísimo comparado con las señales que capta un receptor (microvoltios por metro), y explica por qué una estación puede saturar los equipos de los vecinos (tema T9).
]

#q("T8.5", "c",
  [Para medir la potencia de una señal de radiofrecuencia se emplea:],
  ([un voltímetro de continua], [un óhmetro], [un vatímetro], [un galvanómetro]),
  sol: [La potencia se mide con un vatímetro; en RF, direccional (separa directa y reflejada).],
)

#q("T8.6", "b",
  [Para medir con precisión la frecuencia emitida por un transmisor se emplea:],
  ([un medidor de ROE], [un frecuencímetro de radiofrecuencia], [un polímetro], [un vatímetro]),
  sol: [El frecuencímetro cuenta ciclos contra una referencia de cristal: el instrumento de precisión para la frecuencia.],
)

#q("T8.7", "d",
  [La aplicación más importante del osciloscopio es:],
  ([medir resistencias con gran precisión], [medir la ROE de una antena], [contar los ciclos de una señal digital], [representar gráficamente las formas de onda en la pantalla]),
  sol: [El osciloscopio muestra la forma de onda en el dominio del tiempo: amplitud, período, distorsión, envolvente.],
)

#q("T8.8", "a",
  [Para observar las componentes espectrales de una emisión se emplea:],
  ([un analizador de espectros], [un osciloscopio de baja frecuencia], [un generador de señal], [un medidor de campo]),
  sol: [El analizador de espectros muestra el dominio de la frecuencia: portadora, bandas laterales, armónicos, espurias.],
)

#q("T8.9", "c",
  [Un polímetro (multímetro) NO sirve para medir:],
  ([tensiones continuas], [corrientes alternas], [la impedancia de la antena], [resistencias]),
  sol: [El polímetro mide tensión, corriente y resistencia; la impedancia de una antena en RF exige un puente o analizador de antenas.],
)

#q("T8.10", "a",
  [La intensidad de campo eléctrico radiado por una antena se mide con un medidor de campo y se expresa en:],
  ([voltios por metro (V/m)], [amperios por metro cuadrado], [vatios por hercio], [ohmios por metro]),
  sol: [El campo eléctrico se mide en V/m (en la práctica, μV/m o dBμV/m) con un medidor de campo.],
)

== Más instrumentos y cálculos <t8-sec-mas>

Tres instrumentos más completan el cuadro. El *S-meter* del receptor indica la intensidad de la señal recibida en «puntos S»: cada punto equivale a 6 dB y S9 es la referencia de señal fuerte — de ahí los informes del tipo «S7» o «S9 más 20 dB». El *dipmeter* o medidor de absorción es un oscilador de frecuencia ajustable con una bobina sonda: acercada esta al circuito que se estudia, cuando ambos coinciden en frecuencia el circuito absorbe energía del oscilador y la indicación del instrumento cae en picado — ese «dip» delata la frecuencia de resonancia sin necesidad de alimentar el circuito. Y la *carga artificial* o carga fantasma: una resistencia no inductiva de 50 Ω, capaz de disipar la potencia del transmisor, que ocupa el lugar de la antena durante los ajustes y las pruebas — el equipo trabaja como si transmitiera, pero sin radiar señal al exterior.

=== El S-meter

#motivacion[Cuando un corresponsal te pregunta «¿cómo me recibes?», necesitas una escala común para responder. El oído engaña; el S-meter da un número.]

El S-meter es la aguja (o la barra) del receptor que indica la intensidad de la señal sintonizada (T8.20). Suele leer la tensión del control automático de ganancia: cuanto más fuerte llega la señal, más tiene que reducir el receptor su ganancia, y eso se traduce en puntos S. La escala va de S1 a S9 y, por encima, en «dB sobre S9». Cada punto S son *6 dB*: el doble de tensión, el cuádruple de potencia (T8.21). La recomendación de la IARU fija S9 en 50 μV sobre 50 Ω en HF (−73 dBm) y en 5 μV en VHF (−93 dBm), aunque muchos receptores están lejos de cumplirla con precisión.

#align(center, block(breakable: false, table(
  columns: 7,
  align: center,
  [*Lectura (HF)*], [S5], [S6], [S7], [S8], [S9], [S9 + 20 dB],
  [*Tensión en la entrada*], [3,1 μV], [6,3 μV], [12,5 μV], [25 μV], [50 μV], [500 μV],
)))

#ejemplo[Pasar de S7 a S9 son dos puntos, 12 dB: hay que multiplicar la potencia por $4 dot 4 = 16$. Si tu corresponsal te recibe S7 con 100 W, necesitarías 1600 W para llegarle S9. Por eso subir potencia rinde tan poco en puntos S.]

=== El dipmeter: encontrar la resonancia sin conectar nada

#motivacion[Has montado una trampa para una antena, o un circuito sintonizado, y quieres saber a qué frecuencia resuena. No tiene alimentación, no puedes conectarle nada sin desafinarlo… ¿Cómo se lo preguntas?]

#circuito(caption: [El dipmeter. (a) Su bobina sonda se acerca, sin tocarlo, al circuito $L C$ que se quiere medir. (b) Al barrer la frecuencia del oscilador, la lectura del instrumento cae bruscamente en la frecuencia de resonancia $f_0$ del circuito: ese es el «dip».])[
  #grid(
    columns: (1.15fr, 1fr),
    align: center + bottom,
    esquema({
      import zap: *
      import cetz.draw: content, rect, line, arc
      rect((0, 0.2), (2.4, 2.6), radius: 0.12, fill: col.acento-claro, stroke: 0.7pt + col.acento)
      content((1.2, 1.9), align(center, text(size: 7.5pt)[oscilador\ variable]))
      medidor("m", (1.2, 0.9), letra: "μA")
      wire((2.4, 2.1), (3, 2.1))
      wire((2.4, 0.7), (3, 0.7))
      inductor("ls", (3, 2.1), (3, 0.7))
      content((3.1, 0.3), _t8-chico[sonda])
      // circuito bajo prueba
      inductor("l", (4.3, 2.1), (4.3, 0.7), label: $L$)
      wire((4.3, 2.1), (5.6, 2.1))
      wire((4.3, 0.7), (5.6, 0.7))
      capacitor("c", (5.6, 2.1), (5.6, 0.7), label: $C$)
      line((3.25, 2.55), (4.05, 2.55), mark: (start: ">", end: ">", fill: col.naranja, scale: 0.6), stroke: (paint: col.naranja, thickness: 0.6pt, dash: "dashed"))
      content((3.65, 2.75), anchor: "south", text(size: 7pt, fill: col.naranja)[acoplo magnético])
      content((4.95, 0.3), _t8-chico[circuito bajo prueba])
      content((2.8, -0.45), text(size: 8.5pt)[(a)])
    }),
    cetz.canvas({
      import cetz.draw: *
      ejes(0, 5, 0, 3.1, etq-x: $f$, etq-y: [lectura])
      onda(x => 2.2 - 1.6 / (1 + calc.pow((x - 2.5) / 0.18, 2)), 0.2, 4.8, n: 200, stroke: 1.2pt + col.senal1)
      line((2.5, 0), (2.5, 0.6), stroke: (dash: "dotted", thickness: 0.5pt))
      content((2.5, -0.1), anchor: "north", text(size: 8pt, $f_0$))
      content((2.5, -0.85), text(size: 8.5pt)[(b)])
    }),
  )
] <t8-fig-dip>

#porque[
  - El dipmeter es un oscilador cuya bobina queda fuera de la caja, como una sonda. Su campo magnético atraviesa la bobina del circuito que se mide: los dos quedan acoplados como el primario y el secundario de un transformador flojo.
  - Lejos de la resonancia, el circuito apenas absorbe nada. Cuando la frecuencia del oscilador coincide con la de resonancia del circuito, $f_0 = 1 slash (2 pi sqrt(L C))$ (#ver(<sec-resonancia>)), este empieza a oscilar con él y le *roba energía*: la amplitud del oscilador baja y el medidor (que mide la corriente de rejilla o de base del oscilador, o su tensión) cae de golpe (T8.22).
  - El circuito no necesita alimentación: la energía la pone el dipmeter. Con el oscilador apagado, el mismo aparato hace de *ondámetro de absorción*: su circuito sintonizado capta la RF de un transmisor cercano y señala su frecuencia.
]

#ejemplo[Una bobina de 10 μH con un condensador desconocido da el dip en 7 MHz. Despejando de $f_0 = 1 slash (2 pi sqrt(L C))$: $C = 1 slash ((2 pi f_0)^2 L) = 1 slash ((2 pi dot 7 dot 10^6)^2 dot 10^(-5)) approx 52$ pF. El dipmeter ha servido, de paso, para medir un condensador.]

La misma física explica el «dip» de la corriente de placa al sintonizar la etapa final de un transmisor de válvulas (T8.28): en resonancia, el circuito tanque de placa presenta su impedancia máxima, la válvula toma menos corriente de la fuente y el amperímetro de placa marca un mínimo. Ese mínimo señala la sintonía; luego se ajusta el acoplo a la carga.

=== La carga artificial y la medida de potencia

#motivacion[Para ajustar un transmisor hay que hacerlo trabajar a plena potencia, a veces durante minutos. Si lo haces sobre la antena, ocupas la frecuencia, molestas a todo el mundo y emites sin identificarte. Si lo haces sin nada conectado, el paso final no tiene dónde dejar su potencia y puede averiarse. Hace falta una «antena» que no radie.]

#circuito(caption: [Carga artificial con sonda de medida. La resistencia $R$ de 50 Ω, no inductiva y bien refrigerada, convierte toda la potencia en calor; el diodo y el condensador dan la tensión de pico, y de ella sale la potencia.])[
  #esquema({
    import zap: *
    import cetz.draw: content, rect
    rect((0.4, -0.35), (2.75, 2.65), radius: 0.15, fill: col.naranja-claro, stroke: (paint: col.naranja, thickness: 0.6pt, dash: "dashed"))
    content((1.55, 2.95), _t8-chico[disipador o baño de aceite])
    wire((-0.8, 2.2), (2.2, 2.2))
    node("tx", (-0.8, 2.2), fill: false)
    content((-0.8, 2.55), anchor: "south", _t8-chico[del transmisor])
    resistor("r", (2.2, 2.2), (2.2, 0), label: (content: [$R$ = 50 Ω], anchor: "south"))
    ground("g1", (2.2, 0))
    wire((2.2, 2.2), (3.3, 2.2))
    diode("d", (3.3, 2.2), (4.6, 2.2))
    node("k", (2.2, 2.2))
    capacitor("c", (4.6, 2.2), (4.6, 0), label: $C$)
    ground("g2", (4.6, 0))
    wire((4.6, 2.2), (6.2, 2.2))
    medidor("v", (6.2, 2.2), (6.2, 0), letra: "V", label: $V_p$)
    ground("g3", (6.2, 0))
    node("k2", (4.6, 2.2))
  })
] <t8-fig-carga>

#porque[
  - *La resistencia de 50 Ω* presenta al transmisor exactamente la impedancia de una antena bien adaptada: el equipo trabaja como si transmitiera, con ROE 1, pero toda su potencia se convierte en calor y no sale al exterior (T8.23).
  - *No inductiva*: una resistencia bobinada tiene inductancia; con solo 1 μH, a 14 MHz añadiría $X_L = 2 pi f L approx 88$ Ω de reactancia, y la carga dejaría de ser de 50 Ω. Por eso se hacen con resistencias de película o de carbón.
  - *Capaz de disipar*: 100 W durante un minuto calientan mucho. Las cargas de potencia van sobre un disipador grande o sumergidas en aceite.
  - *La sonda* (diodo y condensador) carga el condensador a la tensión de pico de la RF. Con ella, la carga artificial es también un vatímetro: $P = V_"ef"^2 slash R = V_p^2 slash (2 R)$.
]

#ejemplo[Con 100 W en 50 Ω, la tensión eficaz es $sqrt(P R) = sqrt(100 dot 50) approx 70,7$ V y la de pico, $70,7 dot sqrt(2) = 100$ V. Al revés: si la sonda marca 100 V de pico, la potencia es $100^2 slash (2 dot 50) = 100$ W.]

#q("T8.11", "b",
  [Una resistencia en «shunt» (en paralelo) se puede utilizar para:],
  ([aumentar la sensibilidad de un receptor], [proteger aparatos de medida], [elevar la tensión de una fuente], [filtrar armónicos]),
  sol: [El shunt deriva la mayor parte de la corriente y deja pasar por el instrumento solo una fracción conocida: amplía la escala y protege el aparato de medida.],
)

#q("T8.12", "c",
  [Una ganancia de 40 dB equivale a una relación de potencias de:],
  ([40], [400], [10.000], [1.000.000]),
  sol: [40 dB = $10^(40 slash 10) = 10^4$ = 10.000 en potencia.],
)

#q("T8.13", "a",
  [Cuando una cantidad se expresa en dBW, la magnitud a la que se refiere es:],
  ([la potencia], [la tensión], [la frecuencia], [la impedancia]),
  sol: [El dBW expresa potencia referida a 1 W, igual que el dBm la refiere a 1 mW (0 dBW = 30 dBm).],
)

#q("T8.14", "d",
  [Para determinar la desadaptación de impedancias entre el transmisor y la antena se usa:],
  ([un osciloscopio de audio], [un óhmetro], [un frecuencímetro], [un medidor de ROE]),
  sol: [La desadaptación se mide con el medidor de ROE intercalado entre transmisor y antena.],
)

#q("T8.15", "b",
  [Un generador de señal de radiofrecuencia se utiliza para:],
  ([alimentar la estación en caso de apagón], [caracterizar etapas de radiofrecuencia], [medir la resistencia de la toma de tierra], [amplificar señales débiles]),
  sol: [El generador de señal produce señales de RF calibradas en frecuencia y nivel: con él se caracterizan receptores y etapas (sensibilidad, respuesta, ganancia).],
)

#q("T8.16", "a",
  [En la pantalla del osciloscopio de la @t8-fig-osc, las magnitudes acotadas como $A$ y $T$ son, respectivamente:],
  ([la amplitud y el período de la señal], [el período y la amplitud de la señal], [la frecuencia y la fase de la señal], [la tensión eficaz y la frecuencia de la señal]),
  sol: [$A$ acota la distancia del eje al pico (la amplitud) y $T$ la distancia entre dos picos consecutivos (el período). De $T$ sale la frecuencia: $f = 1 slash T$.],
)

#q("T8.17", "c",
  [Para medir la diferencia de potencial entre dos puntos, el voltímetro debe conectarse:],
  ([en serie con el circuito], [intercalado tras abrir el circuito], [en paralelo con el elemento cuya tensión se quiere medir], [entre uno de los puntos y la toma de tierra]),
  sol: [La tensión es una diferencia _entre_ dos puntos, así que el instrumento se pone a caballo entre ellos, sin abrir nada. El que se intercala abriendo el circuito es el amperímetro, porque la corriente tiene que atravesarlo.],
)

#q("T8.18", "a",
  [Para medir el valor de una resistencia se emplea:],
  ([un óhmetro, con el componente sin tensión aplicada], [un amperímetro conectado en serie], [un vatímetro intercalado en la línea], [un medidor de intensidad de campo]),
  sol: [El óhmetro mide inyectando su propia corriente y viendo qué tensión aparece. Si el circuito tiene tensión propia, la lectura no significa nada — y además puede dañarse el instrumento.],
)

#q("T8.19", "d",
  [Un amperímetro ideal y un voltímetro ideal tendrían, respectivamente, una resistencia interna:],
  ([infinita y nula], [nula y nula], [infinita e infinita], [nula e infinita]),
  sol: [Cada uno debe perturbar lo mínimo el circuito que mide. El amperímetro va en serie, luego su resistencia debe ser nula para no reducir la corriente; el voltímetro va en paralelo, luego la suya debe ser infinita para no desviar corriente.],
)

#q("T8.20", "b",
  [El instrumento comúnmente denominado «S-meter» de un receptor indica:],
  ([la frecuencia de la señal sintonizada], [la intensidad de la señal recibida], [la relación de ondas estacionarias de la antena], [la potencia entregada por el transmisor]),
  sol: [Es el medidor de fuerza de señal, y de él sale el número que se da en el informe de recepción («me llegas 5 y 9»). Trabaja a partir de la tensión del control automático de ganancia.],
)

#q("T8.21", "c",
  [En la escala de un S-meter, la diferencia entre dos puntos S consecutivos equivale a:],
  ([1 dB], [3 dB], [6 dB], [20 dB]),
  sol: [Por convenio, cada punto S vale 6 dB, es decir, cuadruplicar la potencia o duplicar la tensión de la señal. Por eso pasar de S7 a S9 exige multiplicar la potencia por 16, y de ahí que subir un par de puntos S cueste tanto.],
)

#q("T8.22", "a",
  [El instrumento denominado «dipmeter» o medidor de absorción sirve para:],
  ([determinar la frecuencia de resonancia de un circuito sin alimentarlo], [medir la potencia de salida de un transmisor], [comprobar la continuidad de un cable coaxial], [medir la intensidad de campo de una antena]),
  sol: [Es un oscilador con una bobina exterior: al acercarla a un circuito resonante y barrer la frecuencia, en la resonancia el circuito le roba energía y la lectura cae bruscamente — ese «dip» es el que da nombre al aparato y señala la frecuencia buscada.],
)

#q("T8.23", "d",
  [La carga artificial (carga fantasma) de una estación se emplea para:],
  ([aumentar la potencia radiada por la antena], [adaptar la impedancia de la línea de transmisión], [proteger al receptor durante la transmisión], [ajustar y probar el transmisor sin radiar señal al exterior]),
  sol: [Es una resistencia no inductiva de la impedancia nominal —50 ohmios casi siempre— capaz de disipar en calor toda la potencia del equipo. Permite hacer ajustes sin ocupar la banda ni molestar a nadie.],
)

#q("T8.24", "b",
  [Antes de medir una resistencia con el polímetro dentro de un equipo, es imprescindible:],
  ([conectar el equipo a la máxima tensión de alimentación], [asegurarse de que el circuito está sin tensión y los condensadores descargados], [poner el instrumento en la escala de corriente alterna], [conectar previamente la antena]),
  sol: [Por la medida y por la seguridad. La lectura solo es válida sin tensión ajena, y los condensadores de filtro de una fuente —no digamos los de un equipo valvular— conservan carga peligrosa mucho después de desenchufar.],
)

#q("T8.25", "a",
  [Un vatímetro direccional intercalado entre transmisor y antena indica una potencia reflejada apreciable. Ello significa que:],
  ([el transmisor no está adaptado a la antena], [el transmisor entrega más potencia de la nominal], [la antena tiene una ganancia muy elevada], [el instrumento está averiado]),
  sol: [Toda potencia que vuelve es potencia que la antena no ha aceptado: la reflejada mide la desadaptación entre lo que el transmisor ve y lo que la antena presenta. Con adaptación perfecta la lectura de reflejada sería nula.],
)

#q("T8.26", "c",
  [Para medir la frecuencia de un transmisor _no_ puede emplearse:],
  ([un frecuencímetro digital], [un analizador de espectro], [un voltímetro de radiofrecuencia], [un receptor calibrado]),
  sol: [Un voltímetro de radiofrecuencia mide amplitud, no frecuencia: dice cuánta señal hay, no dónde está. Frecuencímetro, analizador de espectro y receptor calibrado sí permiten determinarla.],
)

#q("T8.27", "b",
  [Un medidor de relación de ondas estacionarias indica:],
  ([la potencia media entregada por el transmisor], [la relación entre la señal incidente en la antena y la reflejada por ella], [la ganancia de la antena en decibelios], [la frecuencia de resonancia de la antena]),
  sol: [De ese cociente sale la ROE: con adaptación perfecta no hay reflejada y la ROE vale 1. No mide potencia absoluta ni ganancia, aunque muchos instrumentos incorporen además una escala de vatios.],
)

#q("T8.28", "d",
  [Al sintonizar la etapa final de un transmisor valvular, la corriente de placa que marca su amperímetro alcanza en el punto de ajuste correcto un valor:],
  ([máximo], [igual al de reposo], [nulo], [mínimo]),
  sol: [Es el clásico «dip»: en resonancia el circuito de placa presenta su máxima impedancia, la etapa absorbe menos corriente de la fuente y el amperímetro cae bruscamente. Ese mínimo marca el punto de sintonía, y sobre él se ajusta después el acoplo a la carga.],
)

#q("T8.29", "a",
  [De los siguientes instrumentos, el más imprescindible en una estación de aficionado es:],
  ([el medidor de relación de ondas estacionarias], [el analizador de espectro], [el generador de barrido], [el puente de impedancias de laboratorio]),
  sol: [Es el instrumento que avisa de que algo va mal entre el equipo y la antena, que es de donde vienen la mayoría de los problemas —y de las averías del final de potencia—. Los demás son de laboratorio: útiles, pero no imprescindibles.],
)

== Preguntas sobre esquemas <t8-sec-esquemas>

#q("T8.30", "c",
  [El vatímetro direccional de la figura, intercalado entre el transmisor y la antena, presenta las lecturas indicadas. De ello se deduce que:
    #circuito[
      #cetz.canvas({
        import cetz.draw: *
        rect((0, 0), (1.9, 0.8), radius: 0.08, fill: col.acento-claro, stroke: 0.7pt + col.acento)
        content((0.95, 0.4), text(size: 8pt)[transmisor])
        line((1.9, 0.4), (3.0, 0.4), stroke: 0.7pt)
        rect((3.0, -0.6), (4.8, 1.4), radius: 0.08, fill: col.naranja-claro, stroke: 0.7pt + col.naranja)
        content((3.9, 1.65), text(size: 8pt, fill: col.naranja)[vatímetro])
        content((3.9, 0.4), align(center, text(size: 7.5pt)[directa\ 100 W\ reflejada\ 25 W]))
        line((4.8, 0.4), (6.8, 0.4), stroke: 0.7pt)
        line((6.8, -0.5), (6.8, 1.6), stroke: 1.6pt)
        content((6.8, -0.8), text(size: 8pt, fill: col.gris)[antena])
      })
    ]
  ],
  ([la antena radia 125 W], [el conjunto está perfectamente adaptado], [el transmisor no está adaptado a la antena], [el vatímetro está averiado]),
  sol: [Hay potencia volviendo, luego la antena no acepta todo lo que le llega. Con $P_d = 100$ W y $P_r = 25$ W el coeficiente de reflexión vale $rho = sqrt(25 slash 100) = 0,5$ y la ROE resulta $(1 + 0,5) slash (1 - 0,5) = 3$. La radiada tampoco es la suma: son 75 W.],
)
