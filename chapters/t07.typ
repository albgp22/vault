#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------------
//  Utilidades locales del tema T7 (prefijo _t7-)
// ---------------------------------------------------------------------
// Etiqueta de texto pequeña en un lienzo
#let _t7-et(pos, cuerpo, anchor: "center", size: 8pt, fill: black, angle: 0deg) = cetz.draw.content(pos, anchor: anchor, angle: angle, text(size: size, fill: fill, cuerpo))
// Suelo plano con rayado
#let _t7-suelo(x0, x1, y: 0) = {
  import cetz.draw: *
  line((x0, y), (x1, y), stroke: 0.9pt + col.gris)
  let n = int((x1 - x0) / 0.35)
  for i in range(n) { line((x0 + 0.1 + i * 0.35, y), (x0 - 0.1 + i * 0.35, y - 0.18), stroke: 0.35pt + col.gris) }
}
// Capa ionosférica curvada (banda gruesa) entre x0 y x1 a la altura y
#let _t7-capa(x0, x1, y, alza: 0.35, grosor: 5pt, color: col.acento) = {
  import cetz.draw: *
  let xm = (x0 + x1) / 2
  bezier((x0, y), (x1, y), (x0 + (xm - x0) * 0.6, y + alza), (x1 - (x1 - xm) * 0.6, y + alza), stroke: (paint: color, thickness: grosor, cap: "round"))
}
// Antena vertical pequeña
#let _t7-antena(x, y, alto: 0.45) = {
  import cetz.draw: *
  line((x, y), (x, y + alto), stroke: 1.2pt + col.tinta)
}
// Ciclo solar esquemático: tramos coseno entre mínimos y máximos (t en años)
#let _t7-ciclo(t, pts) = {
  let v = pts.first().at(1)
  for i in range(pts.len() - 1) {
    let (t0, y0) = pts.at(i)
    let (t1, y1) = pts.at(i + 1)
    if t >= t0 and t <= t1 {
      let u = (t - t0) / (t1 - t0)
      v = y0 + (y1 - y0) * (1 - calc.cos(calc.pi * u)) / 2
    }
  }
  v
}

#tema("T7", "Propagación", alcance: [Propagación según la frecuencia · visión directa y espacio libre · atenuación de la señal y relación señal/ruido · capas de la ionosfera e influencia del sol · frecuencia crítica, MUF y frecuencia óptima de trabajo · onda de tierra y de espacio, distancia de salto, desvanecimiento · troposfera, inversión térmica y propagación por conducto · esporádica-E, auroral, meteor-scatter, rebote lunar (EME) · ruido atmosférico, galáctico y térmico · predicción de propagación.])

#motivacion(titulo: [La potencia no lo explica todo])[
  Con los mismos 100 W y la misma antena, un día a mediodía se habla con Australia en 14 MHz, y esa misma noche, en la misma banda, no se oye a nadie. En 144 MHz, con 10 W, se cruza la provincia, y alguna tarde de verano se habla con Italia. La potencia no explica nada de eso: lo explica el *camino* que sigue la onda entre las dos antenas. Este tema trata de esos caminos, de qué los abre y los cierra (el Sol, la hora, la estación del año, el tiempo atmosférico) y de por qué cada banda tiene su carácter. La antena que lanza la onda está en el tema T6; cómo se genera la onda, en #ver(<sec-em>).
]

Antes de los mecanismos concretos, el punto de partida. En el *espacio libre* — sin suelo, sin obstáculos, sin ionosfera — la onda se expande como un frente esférico, y la misma potencia debe repartirse sobre una superficie que crece con el cuadrado de la distancia: el campo recibido cae con $1\/d$ y la potencia con $1\/d^2$. Toda señal se *atenúa* al propagarse, sin necesidad de que nada la absorba, y la atenuación expresada en decibelios crece con la distancia y también con la frecuencia. Y el criterio de que un enlace funcione no es cuánta señal llega en términos absolutos, sino cuánto sobresale del ruido: manda la *relación señal/ruido*, la misma que limita al receptor (tema T4).

#circuito(caption: [Por qué la potencia cae con $1\/d^2$. La energía que pasa por una ventana a la distancia $d$ se reparte, a la distancia $2 d$, sobre una ventana el doble de alta y el doble de ancha: cuatro veces más área, la cuarta parte de potencia por metro cuadrado.])[
  #cetz.canvas({
    import cetz.draw: *
    circle((0, 0), radius: 0.12, fill: col.naranja, stroke: none)
    _t7-et((0, -0.25), [antena], anchor: "north")
    // rayos
    line((0, 0), (6.6, 1.65), stroke: (paint: col.gris, thickness: 0.5pt, dash: "dashed"))
    line((0, 0), (6.6, -1.65), stroke: (paint: col.gris, thickness: 0.5pt, dash: "dashed"))
    // frentes de onda
    for r in (1.0, 2.0, 4.5, 5.5) {
      arc((r * calc.cos(-25deg), r * calc.sin(-25deg)), start: -25deg, stop: 25deg, radius: r, stroke: 0.4pt + col.acento.lighten(50%))
    }
    // ventanas
    rect((3.0, -0.75), (3.12, 0.75), fill: col.acento, stroke: none)
    rect((6.0, -1.5), (6.12, 1.5), fill: col.acento.lighten(30%), stroke: none)
    _t7-et((3.06, 0.85), [área $A$], anchor: "south")
    _t7-et((6.06, 1.6), [área $4 A$], anchor: "south")
    line((0, -2.0), (3.06, -2.0), mark: (start: ">", end: ">", fill: col.gris), stroke: 0.5pt + col.gris)
    _t7-et((1.53, -2.05), $d$, anchor: "north")
    line((0, -2.6), (6.06, -2.6), mark: (start: ">", end: ">", fill: col.gris), stroke: 0.5pt + col.gris)
    _t7-et((3.03, -2.65), $2 d$, anchor: "north")
  })
] <t7-fig-espacio>

#ejemplo(titulo: [Cuánta señal llega a 10 km en 2 m])[
  Una estación emite 100 W de PIRE en 145 MHz. A 10 km la potencia se reparte sobre una esfera de área $4 pi d^2 = 4 pi (10^4)^2 approx 1,26 dot 10^9$ m²: la densidad de potencia es $100\/(1,26 dot 10^9) approx 80$ nW/m². Un dipolo en 145 MHz tiene un área de captura de unos 0,56 m² (tema T6), así que recoge unos 45 nW, es decir, unos −43 dBm. Es muchísima señal para un receptor de VHF: el S9 en VHF son −93 dBm. En la práctica, el terreno y los obstáculos se comen buena parte de ese margen.
]

== La ionosfera y la onda de espacio <t7-sec-ionosfera>

La radiación ultravioleta y X del Sol arranca electrones a los gases de la alta atmósfera y crea la *ionosfera*, un plasma tenue estratificado en capas: la *D* (60–90 km), presente solo de día, que apenas refleja pero _absorbe_ las bandas bajas de HF; la *E* (90–140 km), sede además de la esporádica-E; y la *F* (140–400 km), el gran espejo de HF, que de día se divide en F1 y F2 y de noche se funde en una sola capa que permanece horas sin sol. Todo el sistema respira con el día y la noche, con las estaciones y con el ciclo solar de once años: más manchas solares, más ionización, mejores bandas altas.

=== Por qué hay capas y por qué cambian del día a la noche

#ptitulo[Dónde se forma cada capa] Arriba del todo hay mucha radiación solar pero muy poco gas que ionizar; abajo hay mucho gas, pero la radiación ya se ha gastado por el camino. La ionización es máxima a una altura intermedia. Y como cada tipo de radiación (ultravioleta extremo, rayos X blandos, rayos X duros) penetra hasta una profundidad distinta, aparecen varios máximos: las capas.

#ptitulo[Por qué la D desaparece de noche y la F no] Un electrón libre acaba encontrando un ion y se recombina con él. En la capa D el aire es relativamente denso: los encuentros son frecuentes y, en cuanto se pone el sol, la capa se deshace en minutos. En la capa F el aire es tan tenue que un electrón puede tardar horas en encontrar pareja: la F sobrevive toda la noche, más débil y más alta (@t7-fig-capas[figura]).

#circuito(caption: [Las capas de la ionosfera de día y de noche. De día, el Sol mantiene cuatro capas; de noche, la D desaparece, la E casi se apaga y F1 y F2 se funden en una sola capa F. El color más intenso indica más ionización.])[
  #cetz.canvas({
    import cetz.draw: *
    let k = 0.01 // unidades por km
    let panel(x0, titulo, capas) = {
      rect((x0, 0), (x0 + 3.6, 450 * k), stroke: 0.4pt + col.gris.lighten(40%))
      for (y0, y1, intens, nombre) in capas {
        rect((x0, y0 * k), (x0 + 3.6, y1 * k), fill: col.acento.lighten(intens), stroke: none)
        _t7-et((x0 + 1.8, (y0 + y1) / 2 * k), nombre, size: 7.5pt, fill: if intens < 50% { white } else { col.tinta })
      }
      _t7-et((x0 + 1.8, 4.65), titulo, anchor: "south")
    }
    panel(0, [*De día* ☀], (
      (60, 90, 78%, [D (60–90 km): absorbe]),
      (90, 140, 62%, [E (90–140 km)]),
      (150, 220, 48%, [F1]),
      (220, 400, 22%, [F2: el gran espejo de HF]),
    ))
    panel(4.6, [*De noche* ☾], (
      (95, 130, 85%, [E residual]),
      (220, 400, 38%, [F (F1 + F2)]),
    ))
    rect((4.6, 60 * k), (8.2, 90 * k), stroke: (paint: col.gris, thickness: 0.5pt, dash: "dashed"))
    _t7-et((6.4, 75 * k), text(fill: col.gris)[D: desaparece], size: 7.5pt)
    // eje de alturas
    for h in (0, 100, 200, 300, 400) {
      line((-0.1, h * k), (0, h * k), stroke: 0.4pt)
      _t7-et((-0.15, h * k), [#h], anchor: "east", size: 7pt)
    }
    _t7-et((-0.75, 2.25), [altura (km)], angle: 90deg, size: 7.5pt)
    _t7-suelo(0, 8.2)
  })
] <t7-fig-capas>

#ptitulo[Por qué la D absorbe las frecuencias bajas] La onda hace oscilar a los electrones libres. En la capa D, donde el aire es denso, un electrón que oscila choca enseguida con moléculas neutras y les cede, en forma de calor, la energía que había tomado de la onda. Cuanto más baja es la frecuencia, más tiempo dura cada semiciclo y más lejos llega el electrón en su oscilación: más choques, más absorción (crece aproximadamente con $1\/f^2$). Por eso, de día, 160 y 80 m se quedan en contactos cercanos, mientras 20 m o 15 m atraviesan la D casi sin notarla y llegan a la F.

=== El Sol manda: el ciclo de once años

El número de manchas solares sube y baja en un ciclo de unos once años (@t7-fig-ciclo[figura]). Las manchas son zonas magnéticamente activas; cuantas más hay, más radiación ultravioleta y X emite el Sol, más ionizada está la capa F2 y más altas son las frecuencias que refleja. En el máximo del ciclo, 10, 12 y 15 m se abren a todo el mundo con unos pocos vatios; en el mínimo, de día manda 20 m y por la noche hay que bajar a 40 u 80 m.

#circuito(caption: [Número de manchas solares (valor suavizado, cifras aproximadas) en los tres últimos ciclos. El ciclo 25 alcanzó su máximo hacia finales de 2024; la línea discontinua es una previsión del descenso.])[
  #cetz.canvas({
    import cetz.draw: *
    let x = t => (t - 1995) * 0.33
    let y = v => v * 0.014
    let pts = ((1996.4, 11), (2001.9, 180), (2008.9, 2), (2014.3, 116), (2019.9, 2), (2024.8, 160), (2031, 8))
    ejes(0, x(2034.5), 0, y(215), etq-x: [año], etq-y: [manchas])
    for v in (50, 100, 150, 200) {
      line((-0.08, y(v)), (0, y(v)), stroke: 0.4pt)
      _t7-et((-0.12, y(v)), [#v], anchor: "east", size: 7pt)
      line((0, y(v)), (x(2032), y(v)), stroke: (paint: col.gris.lighten(60%), thickness: 0.3pt, dash: "dotted"))
    }
    for a in (2000, 2010, 2020, 2030) {
      line((x(a), 0), (x(a), -0.08), stroke: 0.4pt)
      _t7-et((x(a), -0.12), [#a], anchor: "north", size: 7pt)
    }
    line(..range(141).map(i => { let t = 1996.4 + i * (2025.8 - 1996.4) / 140; (x(t), y(_t7-ciclo(t, pts))) }), stroke: 1.2pt + col.naranja)
    line(..range(31).map(i => { let t = 2025.8 + i * (2031 - 2025.8) / 30; (x(t), y(_t7-ciclo(t, pts))) }), stroke: (paint: col.naranja, thickness: 1pt, dash: "dashed"))
    _t7-et((x(2001.9), y(180) + 0.08), [ciclo 23], anchor: "south", size: 7.5pt)
    _t7-et((x(2014.3), y(116) + 0.08), [ciclo 24], anchor: "south", size: 7.5pt)
    _t7-et((x(2024.8), y(160) + 0.08), [ciclo 25], anchor: "south", size: 7.5pt)
  })
] <t7-fig-ciclo>

Además del ciclo, el Sol tiene arrebatos. Una *fulguración* (erupción solar) lanza un golpe de rayos X que, en minutos, multiplica la ionización de la capa D en todo el hemisferio iluminado: la absorción se dispara y la HF enmudece durante minutos u horas (es el desvanecimiento súbito o efecto Dellinger). Una *eyección de masa coronal* llega a la Tierra uno o dos días después y provoca una *tormenta geomagnética*: la capa F2 se desorganiza, las bandas altas se cierran y aparecen auroras.

La física del espejo ionosférico cabe en dos fórmulas. Un plasma con $N_e$ electrones libres por metro cúbico oscila a su *frecuencia de plasma*, $f_p approx 9 sqrt(N_e)$ (en hercios), y presenta a una onda de frecuencia $f$ un índice de refracción
$ n = sqrt(1 - (f_p / f)^2) : $
si $f < f_p$, $n$ se hace imaginario y la onda no puede propagarse dentro del plasma — se refleja. La frecuencia crítica de una capa es simplemente la $f_p$ de su máximo de ionización: por eso sube de día y en los máximos del ciclo solar, y por eso las frecuencias altas atraviesan lo que refleja a las bajas.

#ejemplo(titulo: [La frecuencia crítica de una capa F2 diurna])[
  Con $N_e = 10^12$ electrones por metro cúbico, $f_p approx 9 sqrt(10^12) = 9 dot 10^6$ Hz: 9 MHz. Una onda de 7 MHz que suba en vertical se refleja; una de 14 MHz atraviesa la capa y se pierde. De noche, con diez veces menos electrones, $f_p approx 9 sqrt(10^11) approx 2,8$ MHz.
]

#analogia[El índice de refracción mide cómo de «lento» parece el medio a la onda. Un plasma es un medio extraño: cuanto más denso, más *rápida* parece la onda dentro ($n$ menor que 1). Al subir hacia zonas cada vez más ionizadas, el frente de onda avanza más deprisa por arriba que por abajo y se tuerce hacia el suelo, igual que una columna de soldados que gira cuando un extremo marcha más rápido que el otro. Si la ionización basta, el giro completo devuelve la onda a tierra. Si la frecuencia es muy alta, $f_p\/f$ es pequeño, $n approx 1$ y la onda apenas se tuerce: pasa de largo.]

Una onda que incide sobre ese plasma se refracta tanto más cuanto menor es su frecuencia. En incidencia vertical existe una frecuencia límite — la *frecuencia crítica* $f_c$ — por encima de la cual la onda atraviesa la ionosfera y se pierde. En incidencia oblicua basta con que la onda se curve un poco para devolverla al suelo, de modo que una frecuencia más alta —que la ionosfera desvía menos— todavía regresa: se consigue reflexión hasta la *máxima frecuencia utilizable* (MUF $approx f_c \/ cos theta$, mayor cuanto más rasante el ángulo $theta$ con la vertical), y en la práctica se trabaja algo por debajo, en la *frecuencia óptima de trabajo* (∼85 % de la MUF), para tolerar las fluctuaciones del medio. La onda reflejada — la *onda de espacio* — cae a tierra a la *distancia de salto*; entre donde muere la onda de superficie y donde aterriza la reflejada queda la *zona de silencio* (@t7-fig-salto[figura]), y con varios saltos sucesivos (tierra-ionosfera-tierra) se da la vuelta al planeta. La distancia de salto depende del *ángulo de radiación* de la antena: cuanto más rasante —menor ángulo sobre el horizonte—, más lejos aterriza la onda tras el rebote; por eso el DX en HF premia las antenas de ángulo de radiación bajo.

=== Por qué existe la zona de silencio

#circuito(caption: [Una misma frecuencia, mayor que la crítica, lanzada con distintos ángulos. Los rayos empinados atraviesan la capa y se pierden; a partir de cierto ángulo la capa ya los devuelve. El rayo más empinado que vuelve marca la distancia de salto: más cerca no llega ningún rayo reflejado.])[
  #cetz.canvas({
    import cetz.draw: *
    // capa
    rect((-0.3, 2.8), (10.6, 3.6), fill: col.acento.lighten(75%), stroke: none)
    _t7-et((10.55, 3.2), [capa F], anchor: "east", size: 7.5pt, fill: col.acento)
    _t7-suelo(-0.3, 10.6)
    _t7-antena(0, 0)
    _t7-et((0, -0.25), [TX], anchor: "north")
    // rayos que escapan
    line((0, 0.4), (1.0, 2.8), (1.35, 3.6), (1.6, 4.3), stroke: (paint: col.gris, thickness: 0.8pt))
    line((0, 0.4), (1.5, 2.8), (2.05, 3.6), (2.45, 4.25), stroke: (paint: col.gris, thickness: 0.8pt))
    _t7-et((2.0, 4.3), text(fill: col.gris)[se pierden], anchor: "south", size: 7.5pt)
    // rayo crítico: el primero que vuelve
    bezier((0, 0.4), (4.4, 0), (2.0, 3.9), (2.5, 3.9), stroke: 1.1pt + col.naranja)
    // rayos más bajos: más lejos
    bezier((0, 0.4), (7.0, 0), (3.2, 4.0), (3.9, 4.0), stroke: 1pt + col.naranja.lighten(25%))
    bezier((0, 0.4), (10.0, 0), (4.6, 4.1), (5.4, 4.1), stroke: 1pt + col.naranja.lighten(45%))
    // onda de superficie
    line((0.1, 0.12), (1.6, 0.12), stroke: 1.2pt + col.verde, mark: (end: ">", fill: col.verde))
    _t7-et((0.85, 0.2), text(fill: col.verde)[superficie], anchor: "south", size: 7pt)
    // zona de silencio
    line((1.6, -0.55), (4.4, -0.55), mark: (start: ">", end: ">", fill: col.naranja), stroke: 0.5pt + col.naranja)
    _t7-et((3.0, -0.6), text(fill: col.naranja)[zona de silencio], anchor: "north", size: 7.5pt)
    line((0, -1.25), (4.4, -1.25), mark: (start: ">", end: ">", fill: col.gris), stroke: 0.5pt + col.gris)
    _t7-et((2.2, -1.3), [distancia de salto], anchor: "north", size: 7.5pt)
    _t7-et((7.2, -0.3), [ángulos más bajos: más lejos], anchor: "north", size: 7.5pt)
  })
] <t7-fig-rayos>

#porque[
  - *El rayo vertical* necesita la máxima curvatura para volver: solo vuelve si $f < f_c$.
  - *Un rayo inclinado* solo tiene que torcerse un poco más para volver: lo consigue a frecuencias más altas que $f_c$. Cuanto más rasante, más alta la frecuencia que todavía vuelve: de ahí $"MUF" approx f_c\/cos theta$.
  - *A una frecuencia dada por encima de $f_c$*, los rayos más empinados que cierto ángulo escapan. El más empinado de los que vuelven aterriza a la distancia de salto, y ningún rayo reflejado cae más cerca.
  - *La onda de superficie*, en HF, se agota en pocas decenas de kilómetros. Entre su final y la distancia de salto no llega nada: es la *zona de silencio*. Una estación a 100 km puede no oírte mientras otra a 2000 km te oye perfectamente.
  - *Al bajar la frecuencia* por debajo de $f_c$, incluso el rayo vertical vuelve: la zona de silencio desaparece. Es lo que pasa en 40 m y 80 m con frecuencia, y lo que permite los contactos cercanos por la ionosfera (NVIS).
]

#circuito(caption: [Propagación ionosférica en HF. La onda de espacio se refleja en las capas ionizadas (sobre todo en la F) y regresa a tierra a la distancia de salto; entre donde muere la onda de superficie y donde cae la onda reflejada queda la zona de silencio. La capa D, presente de día, absorbe las bandas bajas de HF.])[
  #cetz.canvas({
    import cetz.draw: *
    _t7-capa(-0.6, 10.6, 3.6, grosor: 6pt, color: col.acento.lighten(35%))
    _t7-capa(-0.6, 10.6, 2.95, grosor: 5pt, color: col.acento.lighten(60%))
    _t7-capa(-0.6, 10.6, 2.4, grosor: 4pt, color: col.acento.lighten(78%))
    _t7-et((10.8, 3.6), text(fill: col.acento)[capa F (140–400 km)], anchor: "west", size: 7.5pt)
    _t7-et((10.8, 2.95), text(fill: col.acento.lighten(25%))[capa E (90–140 km)], anchor: "west", size: 7.5pt)
    _t7-et((10.8, 2.4), text(fill: col.acento.lighten(45%))[capa D (60–90 km)], anchor: "west", size: 7.5pt)
    _t7-suelo(-0.6, 10.6)
    _t7-antena(0.3, 0)
    _t7-antena(9.4, 0)
    _t7-et((0.3, -0.3), [TX], anchor: "north")
    _t7-et((9.4, -0.3), [RX], anchor: "north")
    // onda de espacio
    line((0.3, 0.45), (4.85, 3.75), (9.4, 0.45), stroke: 1.1pt + col.naranja)
    _t7-et((2.6, 2.3), text(fill: col.naranja)[onda de espacio], anchor: "east", size: 7.5pt)
    // onda de superficie
    bezier((0.35, 0.3), (3.2, 0.2), (1.2, 0.85), (2.4, 0.75), stroke: 1.1pt + col.verde, mark: (end: ">", fill: col.verde))
    _t7-et((1.6, 0.85), text(fill: col.verde)[onda de superficie], anchor: "south", size: 7.5pt)
    // cotas
    line((3.3, 0.25), (9.3, 0.25), mark: (start: ">", end: ">", fill: col.gris), stroke: 0.5pt + col.gris)
    _t7-et((6.3, 0.3), [zona de silencio], anchor: "south", size: 7.5pt)
    line((0.3, -0.9), (9.4, -0.9), mark: (start: ">", end: ">", fill: col.gris), stroke: 0.5pt + col.gris)
    _t7-et((4.85, -0.95), text(fill: col.gris)[distancia de salto], anchor: "north", size: 7.5pt)
  })
] <t7-fig-salto>

#ejemplo(titulo: [MUF, FOT y distancia de un salto por la F2])[
  Frecuencia crítica de la F2: $f_c = 7$ MHz, con la capa a unos 300 km.
  - Un rayo que sale a 15° sobre el horizonte llega a la capa con unos 67° respecto de la vertical (la curvatura de la Tierra cuenta) y vuelve al suelo a unos 1700 km. $"MUF" approx 7\/cos 67° approx 18$ MHz; $"FOT" approx 0,85 dot 18 approx 15$ MHz.
  - Un rayo que sale a 5° llega con unos 72°, vuelve a unos 2900 km, y $"MUF" approx 7\/cos 72° approx 23$ MHz; $"FOT" approx 19,5$ MHz.
  Más rasante: más lejos y frecuencias más altas. Un salto por la F2 cubre como mucho unos 4000 km; para ir más lejos hacen falta varios saltos. Nueva Zelanda, a unos 19 000 km de España, pide cinco o más (pregunta T7.10).
]

#ojo[
  - Frecuencia *crítica*: la máxima que se refleja en incidencia *vertical* (T7.6). *MUF*: la máxima que se refleja en un trayecto *oblicuo* concreto; siempre es mayor que la crítica.
  - La FOT (frecuencia óptima de trabajo) es *menor* que la MUF, alrededor del 85 %, para tener margen frente a las fluctuaciones.
  - *Nombres*: en este libro, como en el banco de preguntas, «onda de espacio» es la que vuelve de la ionosfera (onda ionosférica), y «onda de tierra», la de superficie. Algunos textos llaman «onda espacial» a la directa de VHF. Lee el enunciado entero: el resto de la frase aclara a cuál se refiere.
]

=== Cada banda, su camino

Cada rango de frecuencias tiene su mecanismo dominante. En *MF* y por debajo manda la *onda de superficie*, que viaja pegada al suelo siguiendo la curvatura terrestre (y se atenúa rápido al subir la frecuencia). En *HF*, la reflexión ionosférica: el DX intercontinental. En *VHF y UHF* la ionosfera ya es transparente y queda la *onda directa*, con un alcance algo mayor que el horizonte óptico — el _horizonte radioeléctrico_, que crece con la raíz de la altura de las antenas: elevar la antena es la forma más barata de llegar más lejos.

#circuito(caption: [Los tres caminos de la onda. La onda de superficie sigue la curvatura del suelo; la onda directa va en línea recta y se queda en el horizonte; la onda de espacio rebota en la ionosfera y llega mucho más allá.])[
  #cetz.canvas({
    import cetz.draw: *
    let R = 14.0
    let cy = -R
    let p = (a, r: R) => (r * calc.cos(a), cy + r * calc.sin(a))
    // tierra e ionosfera
    arc(p(113deg), start: 113deg, stop: 67deg, radius: R, stroke: 1pt + col.gris, fill: col.verde-claro)
    arc(p(113deg, r: R + 3.1), start: 113deg, stop: 67deg, radius: R + 3.1, stroke: (paint: col.acento.lighten(50%), thickness: 6pt))
    _t7-et((5.0, 2.45), text(fill: col.acento)[ionosfera], anchor: "south-west", size: 7.5pt)
    // antenas (verticales, 0,8 de alto)
    let tx = p(108deg)
    let rc = p(99deg)
    let rl = p(74deg)
    for b in (tx, rc, rl) { line(b, (b.at(0), b.at(1) + 0.8), stroke: 1.3pt + col.tinta) }
    let txt = (tx.at(0), tx.at(1) + 0.8)
    let rct = (rc.at(0), rc.at(1) + 0.8)
    let rlt = (rl.at(0), rl.at(1) + 0.8)
    _t7-et((tx.at(0) - 0.1, tx.at(1)), [TX], anchor: "east")
    _t7-et((rc.at(0) + 0.1, rc.at(1) - 0.05), [RX cercano], anchor: "north-west", size: 7.5pt)
    _t7-et((rl.at(0) + 0.1, rl.at(1) - 0.05), [RX lejano], anchor: "north-west", size: 7.5pt)
    // onda de superficie
    arc(p(107deg, r: R + 0.12), start: 107deg, stop: 100.5deg, radius: R + 0.12, stroke: 1.3pt + col.verde, mark: (end: ">", fill: col.verde))
    _t7-et((-2.75, -0.62), text(fill: col.verde)[onda de superficie], anchor: "north", size: 7.5pt)
    // onda directa
    line(txt, rct, stroke: 1.1pt + col.senal1)
    _t7-et((-3.15, 0.3), text(fill: col.senal1)[onda directa], anchor: "north", size: 7.5pt)
    // onda de espacio
    let top = p(91deg, r: R + 3.0)
    line(txt, top, rlt, stroke: 1.1pt + col.naranja)
    _t7-et((2.2, 1.6), text(fill: col.naranja)[onda de espacio], anchor: "west", size: 7.5pt)
  })
] <t7-fig-caminos>

#ptitulo[La onda de superficie] La onda de superficie induce corrientes en el suelo, y el suelo es un conductor mediocre: esas corrientes calientan la tierra y le roban energía. Las pérdidas crecen con la frecuencia, así que la onda de superficie llega a cientos de kilómetros en LF y MF (la radiodifusión de onda media de día) y se agota en pocas decenas de kilómetros en HF. Tiene que ir con *polarización vertical*: un campo eléctrico horizontal pegado al suelo quedaría cortocircuitado por él. Sobre el mar, que conduce mucho mejor, llega bastante más lejos.

#ptitulo[El horizonte radioeléctrico] Por la curvatura de la Tierra, desde una altura $h$ se ve hasta una distancia $d = sqrt(2 R h)$, con $R$ el radio terrestre. Con $R = 6370$ km y $h$ en metros, $d ("km") approx 3,57 sqrt(h)$: es el horizonte óptico. La troposfera es algo más densa abajo que arriba, y eso curva un poco el rayo de radio hacia el suelo. El efecto equivale a una Tierra más grande, de radio $4\/3$ del real, y el factor sube a 4,12 (@t7-fig-horizonte[figura]).

#circuito(caption: [Horizonte radioeléctrico entre dos antenas elevadas (alturas exageradas). El rayo directo roza la Tierra en el horizonte; cada antena aporta su propia distancia al horizonte, $d_1$ y $d_2$, que crecen con la raíz de su altura.])[
  #cetz.canvas({
    import cetz.draw: *
    let R = 9.0
    arc((R * calc.cos(120deg), -R + R * calc.sin(120deg)), start: 120deg, stop: 60deg, radius: R, stroke: 1pt + col.gris, fill: col.verde-claro)
    let th = 25deg
    let h = R * (1 - calc.cos(th)) / calc.cos(th)
    let base1 = (-R * calc.sin(th), -R + R * calc.cos(th))
    let top1 = (-(R + h) * calc.sin(th), -R + (R + h) * calc.cos(th))
    let base2 = (R * calc.sin(th), -R + R * calc.cos(th))
    let top2 = ((R + h) * calc.sin(th), -R + (R + h) * calc.cos(th))
    line(base1, top1, stroke: 1.6pt + col.tinta)
    line(base2, top2, stroke: 1.6pt + col.tinta)
    line(top1, top2, stroke: 1.1pt + col.senal1)
    circle((0, 0), radius: 0.06, fill: col.senal1, stroke: none)
    _t7-et((0, 0.1), text(fill: col.senal1)[horizonte], anchor: "south", size: 7.5pt)
    _t7-et((top1.at(0) - 0.1, (top1.at(1) + base1.at(1)) / 2), $h_1$, anchor: "east")
    _t7-et((top2.at(0) + 0.1, (top2.at(1) + base2.at(1)) / 2), $h_2$, anchor: "west")
    _t7-et((-1.9, 0.05), $d_1$, anchor: "south")
    _t7-et((1.9, 0.05), $d_2$, anchor: "south")
  })
] <t7-fig-horizonte>

#ejemplo[El horizonte radioeléctrico queda algo más lejos que el óptico porque la troposfera curva ligeramente el rayo hacia el suelo: $d ("km") approx 4,12 (sqrt(h_1) + sqrt(h_2))$, con las alturas en metros. Dos estaciones con antenas a 10 m se alcanzan a unos 26 km; subir una de ellas a un repetidor a 400 m estira el enlace hasta unos 95 km sin tocar la potencia.]

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: (left, left, left),
    [*Banda*], [*Mecanismo dominante*], [*Alcance típico*],
    [LF y MF], [Onda de superficie de día; de noche, también ionosférica (sin capa D)], [Cientos de km; de noche, miles],
    [HF (3–30 MHz)], [Reflexión en la ionosfera (sobre todo en la F2), con uno o varios saltos], [Mundial, según la hora y el ciclo solar],
    [VHF (30–300 MHz)], [Onda directa; a ratos, esporádica-E, conductos troposféricos, meteoros, aurora], [Decenas de km; en aperturas, cientos o miles],
    [UHF y SHF], [Onda directa con visión despejada; satélites y rebote lunar], [Hasta el horizonte radioeléctrico],
  ),
  caption: [Mecanismo de propagación dominante según la banda.],
) <t7-tab-mecanismos>

#q("T7.1", "b",
  [Las capas ionizadas de la atmósfera se denominan:],
  ([A, B y C], [D, E, F1 y F2], [alfa, beta y gamma], [troposfera y estratosfera]),
  sol: [Capas D, E, F1 y F2 (@t7-fig-capas[figura]); de noche la D desaparece y F1 y F2 se funden en una sola capa F.],
)

#q("T7.2", "c",
  [El modo de propagación por onda ionosférica predomina en la banda de:],
  ([UHF], [SHF], [HF], [EHF]),
  sol: [La reflexión ionosférica domina en HF (3–30 MHz): es lo que permite el DX intercontinental con potencias modestas.],
)

#q("T7.3", "a",
  [El modo de propagación por onda de superficie predomina en la banda de:],
  ([MF], [VHF], [UHF], [SHF]),
  sol: [La onda de superficie viaja guiada por el suelo, y el suelo es mal conductor: las pérdidas que induce crecen con la frecuencia. Por eso domina en MF y por debajo; en HF se agota en pocos kilómetros y solo sobrevive la propagación ionosférica.],
)

#q("T7.4", "d",
  [La propagación por onda de superficie se caracteriza porque la onda:],
  ([se refleja en la capa F de la ionosfera], [rebota en la superficie lunar], [solo existe con visión directa entre antenas], [se propaga siguiendo la curvatura terrestre]),
  sol: [La onda de superficie viaja pegada al suelo siguiendo la curvatura terrestre, superando el horizonte visual.],
)

#q("T7.5", "a",
  [La forma más común de propagación en VHF y UHF es por:],
  ([onda directa], [reflexión ionosférica en la capa D], [onda de superficie], [conducto troposférico permanente]),
  sol: [En VHF/UHF la ionosfera ya no refleja: propagación por onda directa, con alcance algo mayor que el horizonte óptico.],
)

#q("T7.6", "b",
  [Se llama frecuencia crítica a la frecuencia:],
  ([mínima que atraviesa la capa D], [por encima de la cual, en incidencia vertical, no hay reflexión en la ionosfera], [de resonancia de la antena receptora], [máxima que puede generar el transmisor]),
  sol: [La frecuencia crítica es la máxima que, en incidencia vertical, aún se refleja; por encima, la onda atraviesa la ionosfera.],
)

== Fenómenos de propagación <t7-sec-fenomenos>

El medio ionosférico es inestable, y esa inestabilidad tiene nombres. El *desvanecimiento* (fading) es la variación momentánea de la intensidad recibida: la señal llega por varios caminos que se suman unas veces en fase y otras en oposición, y la propia ionosfera fluctúa; el CAG del receptor lo disimula en parte. La absorción de la capa D explica el ritmo diario de las bandas bajas: a 3,5 MHz los alcances diurnos son menores que los nocturnos, y por eso 80 m es una banda de noche mientras las bandas altas viven del día.

=== El desvanecimiento, visto de cerca

#circuito(caption: [Desvanecimiento por multitrayecto. Izquierda: la señal llega por dos caminos de longitud distinta (un salto por la E y otro por la F). Derecha: como la ionosfera se mueve, la diferencia de fase entre los dos caminos cambia y el nivel recibido sube y baja.])[
  #cetz.canvas({
    import cetz.draw: *
    // caminos
    rect((-0.2, 2.6), (4.8, 3.1), fill: col.acento.lighten(70%), stroke: none)
    rect((-0.2, 1.6), (4.8, 1.95), fill: col.acento.lighten(82%), stroke: none)
    _t7-et((-0.25, 2.85), [F], anchor: "east", size: 7.5pt, fill: col.acento)
    _t7-et((-0.25, 1.78), [E], anchor: "east", size: 7.5pt, fill: col.acento)
    _t7-suelo(-0.2, 4.8)
    _t7-antena(0.2, 0)
    _t7-antena(4.4, 0)
    line((0.2, 0.45), (2.3, 2.7), (4.4, 0.45), stroke: 1pt + col.naranja)
    line((0.2, 0.45), (2.3, 1.7), (4.4, 0.45), stroke: 1pt + col.senal1)
    _t7-et((0.2, -0.25), [TX], anchor: "north", size: 7.5pt)
    _t7-et((4.4, -0.25), [RX], anchor: "north", size: 7.5pt)
    // nivel recibido
    let x0 = 6.2
    line((x0, 0), (x0 + 5.6, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
    line((x0, 0), (x0, 3.0), mark: (end: ">", fill: black), stroke: 0.6pt)
    _t7-et((x0 + 5.6, -0.05), [tiempo], anchor: "north-east", size: 7.5pt)
    _t7-et((x0 - 0.08, 3.0), [nivel], anchor: "east", size: 7.5pt)
    line(..range(201).map(i => {
      let t = 5.4 * i / 200
      let fi = 2 * calc.pi * (0.42 * t + 0.08 * calc.sin(1.3 * t))
      let a = calc.sqrt(1 + 0.64 + 1.6 * calc.cos(fi))
      (x0 + t, a * 1.45)
    }), stroke: 1.1pt + col.senal1)
    _t7-et((x0 + 2.7, -0.45), [#text(fill: col.verde)[picos: en fase, se suman] · #text(fill: col.senal2)[valles: en oposición, casi se anulan]], anchor: "north", size: 7pt)
  })
] <t7-fig-fading>

El multitrayecto es la causa más típica, pero no la única. La ionosfera también gira la polarización de la onda (por el campo magnético terrestre), y la antena receptora capta más o menos según la orientación con que llegue: *desvanecimiento de polarización*. Cuando la frecuencia está muy cerca de la MUF, pequeños cambios de la ionización hacen que la onda vuelva o no vuelva: *desvanecimiento de salto*. Y si el desvanecimiento afecta de forma distinta a frecuencias muy próximas (*desvanecimiento selectivo*), una señal ancha se distorsiona: en AM la portadora puede hundirse mientras las bandas laterales siguen, y el audio se vuelve ininteligible; la SSB, más estrecha y sin portadora, lo sufre menos.

Sobre los mecanismos regulares se montan los esporádicos, pan de cada día del DX en VHF: la *esporádica-E* (nubes de ionización intensa en la capa E que devuelven señales de VHF a 1000–2000 km, sobre todo en verano); la *reflexión auroral* en las cortinas ionizadas de las auroras; el *meteor-scatter* en las estelas ionizadas de los meteoros (ráfagas de segundos); la *inversión térmica* en la troposfera, que forma conductos capaces de guiar VHF/UHF a cientos de kilómetros; la *dispersión troposférica*, que rebasa ampliamente el horizonte a costa de enormes pérdidas; y el *rebote lunar* (EME), el enlace extremo: 770 000 km de ida y vuelta que exigen VHF o superiores, mucha potencia, antenas de gran ganancia y modos muy robustos. Completa el cuadro el *ruido* — atmosférico (tormentas, domina en HF baja), galáctico y térmico — que fija el suelo sobre el que toda señal debe sobresalir.

=== Los mecanismos esporádicos, uno a uno

#circuito(caption: [Dos caminos esporádicos de VHF. (a) Esporádica-E: una nube de ionización muy densa en la capa E devuelve a tierra señales de 50 o 144 MHz que normalmente atravesarían la ionosfera. (b) Conducto troposférico: bajo una inversión térmica, la onda queda atrapada entre el suelo y la capa de aire cálido y viaja cientos de kilómetros.])[
  #cetz.canvas({
    import cetz.draw: *
    // (a) esporádica E
    rect((-0.2, 2.3), (5.2, 2.75), fill: col.acento.lighten(85%), stroke: none)
    _t7-et((5.15, 2.52), text(fill: col.acento)[capa E], anchor: "east", size: 7pt)
    circle((2.5, 2.52), radius: (0.9, 0.2), fill: col.acento.lighten(25%), stroke: none)
    _t7-et((2.5, 2.8), [nube Es], anchor: "south", size: 7pt)
    _t7-suelo(-0.2, 5.2)
    _t7-antena(0.2, 0)
    _t7-antena(4.8, 0)
    line((0.2, 0.45), (2.5, 2.35), (4.8, 0.45), stroke: 1.1pt + col.naranja)
    line((0.2, 0.45), (1.0, 2.3), (1.45, 3.6), stroke: (paint: col.gris, thickness: 0.8pt, dash: "dashed"))
    _t7-et((1.5, 3.6), text(fill: col.gris)[sin Es: se pierde], anchor: "west", size: 7pt)
    _t7-et((2.5, -0.3), [(a) 1000–2000 km], anchor: "north", size: 7.5pt)
    // (b) conducto
    let x0 = 6.4
    _t7-suelo(x0, x0 + 5.6)
    line((x0, 1.1), (x0 + 5.6, 1.1), stroke: (paint: col.naranja, thickness: 0.8pt, dash: "dashed"))
    _t7-et((x0 + 5.6, 1.32), text(fill: col.naranja)[inversión térmica: aire cálido sobre aire frío], anchor: "south-east", size: 7pt)
    _t7-antena(x0 + 0.2, 0)
    _t7-antena(x0 + 5.4, 0)
    bezier((x0 + 0.2, 0.45), (x0 + 1.9, 0.02), (x0 + 0.9, 1.25), (x0 + 1.3, 1.25), stroke: 1.1pt + col.senal1)
    bezier((x0 + 1.9, 0.02), (x0 + 3.6, 0.02), (x0 + 2.5, 1.25), (x0 + 3.0, 1.25), stroke: 1.1pt + col.senal1)
    bezier((x0 + 3.6, 0.02), (x0 + 5.4, 0.4), (x0 + 4.2, 1.25), (x0 + 4.7, 1.25), stroke: 1.1pt + col.senal1)
    _t7-et((x0 + 2.8, -0.3), [(b) cientos de km], anchor: "north", size: 7.5pt)
  })
] <t7-fig-esporadicos>

- *Esporádica-E*. En la parte baja de la termosfera, los vientos cambian de dirección con la altura y arrastran los iones metálicos que dejan los meteoros. Donde dos corrientes opuestas se encuentran, los iones se apelotonan en láminas finas muy densas. Esas nubes llegan a reflejar 50 MHz y, alguna vez, 144 MHz. Como la capa E está baja (unos 100 km), un salto cubre de 1000 a 2000 km. Es típica de finales de primavera y del verano, de día y al atardecer.
- *Reflexión auroral*. En las tormentas geomagnéticas, las partículas solares ionizan cortinas cerca de los polos. Las señales de VHF rebotan en ellas con la antena apuntada hacia el norte, pero llegan con un tono áspero y zumbón, porque la aurora se mueve y ensancha la señal: se trabaja sobre todo en CW. Desde España solo ocurre en las tormentas más fuertes.
- *Meteor-scatter*. Cada meteoro deja a 80–120 km de altura una estela ionizada que dura desde fracciones de segundo hasta algunos segundos. Una señal de VHF rebota en ella y llega a 1000–2000 km en ráfagas cortas («pings»). Funciona mejor en las lluvias de meteoros (Perseidas en agosto, Gemínidas en diciembre) y con modos digitales pensados para ráfagas.
- *Conductos troposféricos*. Normalmente el aire es más cálido abajo y más frío arriba. Con tiempo estable (anticiclón), a veces se forma una *inversión térmica*: una capa de aire cálido y seco encima de aire frío y húmedo. El índice de refracción cae de golpe en esa frontera, el rayo se curva hacia el suelo más que la propia Tierra y queda atrapado, como la luz en una fibra óptica (@t7-fig-esporadicos[figura], b). VHF y UHF llegan a cientos de kilómetros, a veces a más de mil sobre el mar.
- *Dispersión troposférica*. Las irregularidades de la troposfera dispersan en todas direcciones una parte minúscula de la energía. Una pequeña fracción llega más allá del horizonte. Funciona siempre, pero con enormes pérdidas: hacen falta potencia y antenas de gran ganancia.
- *Rebote lunar (EME)*. La Luna, a unos 384 000 km, refleja un 7 % de lo que le llega. Hay que atravesar la ionosfera dos veces (VHF o más) y compensar unas pérdidas gigantescas con potencia, antenas enormes y modos digitales capaces de decodificar señales por debajo del ruido.

#ptitulo[El ruido] Toda señal tiene que sobresalir del ruido. El *atmosférico* lo producen los rayos de las tormentas de todo el planeta, que la ionosfera propaga igual que las señales: domina en las bandas bajas de HF y en verano. El *galáctico* llega del espacio (del centro de la Vía Láctea, sobre todo) y se nota entre unos 20 y 200 MHz. El *térmico* lo genera la agitación de los electrones en cualquier resistencia, también en la entrada del receptor: vale $k T B$, unos −174 dBm por cada hercio de ancho de banda a temperatura ambiente. Con un filtro de SSB de 2,4 kHz: $-174 + 10 log 2400 approx -140$ dBm. En HF, el ruido que entra por la antena suele estar muy por encima de ese suelo térmico; por eso en HF se gana poco con un receptor de ruido propio muy bajo, mientras que en VHF y UHF, donde el ruido exterior es menor, sí importa (tema T4).

Para calibrar la dureza de cada camino sirve la *pérdida en espacio libre*,
$ L ("dB") = 32,4 + 20 log_10 f ("MHz") + 20 log_10 d ("km") : $
doblar la distancia — o la frecuencia — cuesta 6 dB. Un enlace EME a 144 MHz acumula, entre la ida, la vuelta y la pobre reflectividad lunar, del orden de 250 dB de pérdidas: la razón de que exija antenas enormes, potencia y modos digitales capaces de excavar señales por debajo del ruido.

#ptitulo[De dónde sale la fórmula] Es la cuenta de la @t7-fig-espacio[figura] entre dos antenas isótropas: la potencia se reparte sobre la esfera de área $4 pi d^2$, y la antena receptora isótropa captura $lambda^2\/(4 pi)$. El cociente da $L = (4 pi d \/ lambda)^2$; pasado a dB y con $f$ en MHz y $d$ en km, salen la constante 32,4 y los dos términos de $20 log$. La frecuencia aparece porque la antena isótropa receptora es más pequeña cuanto más corta es la onda, no porque el espacio «absorba» más.

#ejemplo(titulo: [Enlace de 50 km en 2 m])[
  $L = 32,4 + 20 log_10 145 + 20 log_10 50 approx 32,4 + 43,2 + 34,0 approx 109,6$ dB. Con 25 W (44 dBm) y antenas de 2 dBi en los dos extremos, llegan $44 + 2 + 2 - 109,6 approx -62$ dBm: unos 30 dB por encima de S9 en VHF, *si hay visión directa*. Si un monte se interpone, la difracción y la absorción pueden restar fácilmente 30 o 40 dB más.
]

#ojo[
  - T7.7: el *fading* es la variación momentánea de la intensidad recibida.
  - T7.8: en 3,5 MHz, de día los alcances son *menores* que de noche (absorción de la D).
  - T7.9: para EME, *VHF y superiores*: hay que atravesar la ionosfera.
  - T7.14: las ondas *siempre* se atenúan al propagarse, aunque nada las absorba.
]

#q("T7.7", "c",
  [La variación momentánea de la intensidad de campo recibida se conoce como:],
  ([intermodulación], [efecto pelicular], [desvanecimiento o fading], [dispersión troposférica]),
  sol: [El fading es la variación momentánea de la intensidad recibida (cambios ionosféricos, multitrayecto); el CAG lo compensa en parte.],
)

#q("T7.8", "a",
  [En la banda de 3,5 MHz, los alcances por reflexión ionosférica durante el día, frente a los de la noche, son:],
  ([menores], [mayores], [iguales], [nulos en cualquier caso]),
  sol: [De día la capa D absorbe las bandas bajas de HF: alcances menores. Por eso 80 m es una banda nocturna.],
)

#q("T7.9", "d",
  [Las bandas más idóneas para la comunicación por rebote lunar (EME) son:],
  ([MF y LF], [HF exclusivamente], [MF y HF], [VHF y superiores]),
  sol: [El EME exige atravesar la ionosfera y apuntar con gran directividad: VHF, UHF y microondas.],
)

#q("T7.10", "b",
  [Un enlace radioeléctrico entre España y Nueva Zelanda podría establecerse empleando:],
  ([una frecuencia de UHF con visión directa], [una frecuencia de HF que se refleje en la ionosfera], [exclusivamente la onda de superficie en VHF], [una frecuencia de microondas por conducto troposférico]),
  sol: [$tilde 19 000$ km solo son viables por reflexión ionosférica múltiple en HF, con una frecuencia que la ionosfera refleje en ese momento (por debajo de la MUF del trayecto).],
)

== Otros fenómenos <t7-sec-otros>

Cuando una onda encuentra algo en su camino, le pueden pasar cuatro cosas (@t7-fig-fenomenos[figura]), y el examen las pregunta por su nombre:

#circuito(caption: [Lo que le puede pasar a una onda en su camino: rebotar (reflexión), torcerse al cambiar de medio (refracción), bordear un obstáculo (difracción) o perder energía en forma de calor (absorción).])[
  #cetz.canvas({
    import cetz.draw: *
    let et = (x, t) => _t7-et((x, -0.35), t, anchor: "north", size: 8pt)
    // reflexión
    line((0, -0.1), (2.6, -0.1), stroke: 1.2pt + col.gris)
    line((0.2, 1.6), (1.3, -0.05), (2.4, 1.6), stroke: 1.1pt + col.senal1, mark: (end: ">", fill: col.senal1))
    et(1.3, [reflexión])
    // refracción
    rect((3.2, -0.1), (5.8, 0.8), fill: col.acento.lighten(80%), stroke: none)
    line((3.4, 1.8), (4.4, 0.8), (4.85, -0.05), stroke: 1.1pt + col.senal1, mark: (end: ">", fill: col.senal1))
    line((4.4, 0.8), (5.4, -0.2), stroke: (paint: col.gris, thickness: 0.5pt, dash: "dotted"))
    et(4.5, [refracción])
    // difracción
    line((6.6, -0.1), (7.6, 1.2), (8.0, 1.2), (9.0, -0.1), stroke: 1pt + col.gris, fill: col.gris.lighten(70%))
    line((6.4, 1.55), (7.8, 1.55), stroke: 1.1pt + col.senal1)
    bezier((7.8, 1.55), (9.1, 0.15), (8.5, 1.5), (8.95, 0.9), stroke: 1.1pt + col.senal1, mark: (end: ">", fill: col.senal1))
    line((7.8, 1.55), (9.2, 1.55), stroke: (paint: col.senal1, thickness: 0.6pt, dash: "dashed"))
    _t7-et((9.05, 0.45), text(fill: col.gris)[sombra], anchor: "west", size: 7pt)
    et(7.8, [difracción])
    // absorción
    rect((10.4, -0.1), (11.4, 1.8), fill: col.ambar-claro, stroke: none)
    line((9.9, 0.85), (10.4, 0.85), stroke: 1.6pt + col.senal1)
    line((10.4, 0.85), (11.4, 0.85), stroke: (paint: col.senal1, thickness: 0.9pt))
    line((11.4, 0.85), (12.1, 0.85), stroke: 0.4pt + col.senal1, mark: (end: ">", fill: col.senal1))
    _t7-et((10.9, 1.4), text(fill: col.ambar)[calor], size: 7pt)
    et(11.0, [absorción])
  })
] <t7-fig-fenomenos>

- *Reflexión*: la onda rebota en una superficie conductora (el suelo, un edificio, el mar).
- *Refracción*: la onda cambia de dirección al pasar a un medio en el que viaja a otra velocidad. Es lo que hace la ionosfera con la HF y la troposfera con el horizonte radioeléctrico.
- *Difracción*: la onda bordea el borde de un obstáculo y llega, debilitada, a la zona de sombra. Es tanto mayor cuanto más larga es la onda comparada con el obstáculo: en HF se salva un monte que en UHF deja sombra (pregunta T7.21).
- *Absorción*: el medio convierte parte de la energía de la onda en calor (la capa D en HF, la lluvia en las microondas, los árboles en UHF).

La *dispersión troposférica* (troposcatter) es una mezcla de todo: las irregularidades de temperatura y humedad de la troposfera desvían en todas direcciones una fracción minúscula de la energía. Una parte de esa fracción cae más allá del horizonte. El alcance llega a cientos de kilómetros, pero las pérdidas son enormes (pregunta T7.11).

#q("T7.11", "b",
  [Con la dispersión troposférica (troposcatter) en la propagación de ondas se consigue:],
  ([comunicar únicamente por visión directa], [un alcance mayor que el meramente visual entre las antenas], [eliminar el desvanecimiento], [reflejar señales de MF en la ionosfera]),
  sol: [El troposcatter dispersa una pequeña parte de la energía en las irregularidades de la troposfera: alcances muy superiores al horizonte visual (cientos de km), a costa de grandes pérdidas.],
)

#q("T7.12", "a",
  [Los transmisores de VHF en radioafición se utilizan normalmente para:],
  ([distancias cortas], [contactos intercontinentales diarios], [comunicación submarina], [enlaces exclusivamente por satélite]),
  sol: [Por su propagación por onda directa, los transmisores de VHF sirven normalmente para distancias cortas (locales y provinciales).],
)

#q("T7.13", "d",
  [De los siguientes factores, influyen en una comunicación radioeléctrica:],
  ([la polarización de la señal radioeléctrica], [la potencia y la frecuencia de emisión], [la ubicación de las antenas transmisora y receptora], [todos los anteriores]),
  sol: [Polarización, potencia, frecuencia y ubicación de las antenas influyen todos en el resultado del enlace: la respuesta es «todos los anteriores».],
)

#q("T7.14", "c",
  [En una transmisión radioeléctrica, las ondas, al propagarse:],
  ([solo se atenúan si llueve], [mantienen su intensidad indefinidamente], [se atenúan siempre], [se amplifican en la ionosfera]),
  sol: [La atenuación con la distancia es inevitable: en espacio libre la densidad de potencia cae con $1\/d^2$, y el medio real añade absorción.],
)

== Cómo se nombran las bandas <t7-sec-bandas>

El espectro está dividido en bandas que la UIT numera y que todo el mundo conoce por dos nombres a la vez: unas siglas en inglés según la frecuencia y un adjetivo en castellano según la longitud de onda (@t7-fig-bandas[figura]). Conviene dominar la equivalencia porque el examen la pregunta indistintamente de las dos maneras.

La lógica es simple una vez vista. Cada banda abarca una *década* de frecuencia — de 3 a 30, de 30 a 300, y así — y como $lambda = c\/f$, a cada década de frecuencia le corresponde una década de longitud de onda, que es la que da el nombre. La banda de 3 a 30 MHz tiene longitudes de onda de 100 a 10 metros, es decir, decenas de metros: *decamétricas*. La de 300 kHz a 3 MHz va de 1000 a 100 metros, centenas de metros: *hectométricas*. Y así hacia arriba y hacia abajo.

#truco[Basta recordar un ancla y contar. HF = decamétricas (decenas de metros, de 10 a 100 m), que es donde vive casi toda la radioafición de onda corta. Un escalón hacia abajo en frecuencia es un escalón hacia arriba en tamaño: MF son hectométricas y LF, kilométricas. Un escalón hacia arriba en frecuencia: VHF son métricas, UHF decimétricas, SHF centimétricas.]

#circuito(caption: [Las bandas del espectro con su sigla y su nombre por longitud de onda. Cada casilla abarca una década: al subir un escalón en frecuencia se baja uno en tamaño de onda.])[
  #cetz.canvas({
    import cetz.draw: *
    let bandas = ("VLF", "LF", "MF", "HF", "VHF", "UHF", "SHF", "EHF")
    let nombres = ("miriamétricas", "kilométricas", "hectométricas", "decamétricas", "métricas", "decimétricas", "centimétricas", "milimétricas")
    let lams = ("10–100 km", "1–10 km", "100–1000 m", "10–100 m", "1–10 m", "10–100 cm", "1–10 cm", "1–10 mm")
    let fs = ("3 kHz", "30 kHz", "300 kHz", "3 MHz", "30 MHz", "300 MHz", "3 GHz", "30 GHz", "300 GHz")
    let tonos = (85%, 78%, 68%, 55%, 64%, 74%, 80%, 86%)
    let w = 1.8
    for (i, b) in bandas.enumerate() {
      let x = i * w
      rect((x, 0), (x + w, 0.75), fill: col.acento.lighten(tonos.at(i)), stroke: 0.5pt + col.acento.lighten(30%))
      content((x + w / 2, 0.375), text(font: fuente-sans, size: 8.5pt, weight: "bold", fill: col.tinta, b))
      content((x + w / 2, -0.6), angle: 22deg, text(size: 7.5pt, fill: col.gris, nombres.at(i)))
      content((x + w / 2, -1.25), text(size: 6.5pt, lams.at(i)))
    }
    for (i, f) in fs.enumerate() {
      line((i * w, 0.75), (i * w, 0.95), stroke: 0.4pt)
      content((i * w, 1.15), text(size: 6.5pt, f))
    }
    line((3 * w, -0.06), (4 * w, -0.06), stroke: 1.8pt + col.naranja)
    content((3.5 * w, -1.7), text(size: 7.5pt, fill: col.naranja)[la mayoría de las bandas de aficionado están aquí])
  })
] <t7-fig-bandas>

#figure(
  table(
    columns: (auto, auto, auto, auto, 1fr),
    align: (center, left, left, left, left),
    [*Sigla*], [*Frecuencias*], [*Longitud de onda*], [*Nombre*], [*Ejemplos*],
    [VLF], [3–30 kHz], [100–10 km], [miriamétricas], [comunicación con submarinos],
    [LF], [30–300 kHz], [10–1 km], [kilométricas], [radiofaros, señales horarias],
    [MF], [300 kHz–3 MHz], [1000–100 m], [hectométricas], [onda media de radiodifusión; banda de 160 m],
    [HF], [3–30 MHz], [100–10 m], [decamétricas], [bandas de 80, 40, 30, 20, 17, 15, 12 y 10 m],
    [VHF], [30–300 MHz], [10–1 m], [métricas], [bandas de 6 m y 2 m; FM comercial],
    [UHF], [300 MHz–3 GHz], [100–10 cm], [decimétricas], [bandas de 70 cm y 23 cm; telefonía móvil],
    [SHF], [3–30 GHz], [10–1 cm], [centimétricas], [banda de 3 cm (10 GHz); satélites de TV],
    [EHF], [30–300 GHz], [10–1 mm], [milimétricas], [enlaces experimentales de corto alcance],
  ),
  caption: [Nomenclatura de las bandas, con ejemplos de servicios y de bandas de aficionado.],
) <t7-tab-bandas>

#ejemplo(titulo: [¿A qué banda pertenece 3,5 MHz?])[
  $lambda = 300\/3,5 approx 86$ m. Está entre 10 y 100 m: decamétricas, es decir, HF (pregunta T7.20). Cuidado con la frontera: 3,5 MHz está muy cerca de los 3 MHz que separan HF de MF, pero por encima.
]

#q("T7.15", "c",
  [Según la nomenclatura de las bandas de frecuencia, el símbolo MF corresponde a las ondas:],
  ([miriamétricas], [kilométricas], [hectométricas], [decamétricas]),
  sol: [MF abarca de 300 kHz a 3 MHz, es decir, longitudes de onda de 1000 a 100 metros: centenas de metros, hectométricas. Es la banda de la radiodifusión en onda media.],
)

#q("T7.16", "a",
  [Las ondas decamétricas comprenden las frecuencias de:],
  ([3 a 30 MHz], [300 kHz a 3 MHz], [30 a 300 MHz], [30 a 300 kHz]),
  sol: [Decenas de metros —de 10 a 100 m— son, por $lambda = c\/f$, de 3 a 30 MHz: exactamente la banda HF, donde está la mayoría de las bandas de aficionado de onda corta.],
)

#q("T7.17", "d",
  [La banda designada como VHF está formada por las ondas:],
  ([decimétricas], [decamétricas], [centimétricas], [métricas]),
  sol: [VHF va de 30 a 300 MHz, o sea, de 10 a 1 metro de longitud de onda: métricas. La banda de 2 metros, la más usada en VHF, cae de lleno ahí.],
)

#q("T7.18", "b",
  [En la nomenclatura de las bandas de frecuencia, el símbolo LF corresponde a la banda de:],
  ([3 a 30 kHz], [30 a 300 kHz], [300 kHz a 3 MHz], [30 a 300 MHz]),
  sol: [Cada banda abarca una década y LF es la segunda desde abajo: de 30 a 300 kHz, con longitudes de onda de 10 a 1 kilómetro — de ahí que se llamen kilométricas. La de 3 a 30 kHz es VLF.],
)

#q("T7.19", "c",
  [Las ondas decimétricas se corresponden con la banda designada como:],
  ([VHF], [SHF], [UHF], [EHF]),
  sol: [Decímetros —de 10 a 100 cm— corresponden a 300 MHz a 3 GHz, que es UHF. Ahí están la banda de 70 cm de aficionado y buena parte de los servicios móviles.],
)

#q("T7.20", "a",
  [Una emisión en la frecuencia de 3,5 MHz pertenece a las ondas:],
  ([decamétricas], [hectométricas], [métricas], [kilométricas]),
  sol: [$lambda = 300\/3,5 approx 86$ metros, que está entre 10 y 100: decamétricas. Coincide con lo esperable, porque 3,5 MHz cae dentro de HF —la banda de 80 metros.],
)

#q("T7.21", "b",
  [La curvatura que experimenta una onda radioeléctrica al encontrar un obstáculo en su trayectoria se denomina:],
  ([reflexión], [difracción], [refracción], [absorción]),
  sol: [La difracción es la capacidad de la onda para bordear un obstáculo y llegar a la zona de sombra geométrica, y es tanto mayor cuanto más larga es la longitud de onda: por eso en HF se salva un monte que en UHF deja sombra. La reflexión rebota, la refracción curva al cambiar de medio y la absorción convierte la energía en calor.],
)

#q("T7.22", "c",
  [Ordenadas de menor a mayor altura, las capas de la atmósfera son:],
  ([ionosfera, troposfera y estratosfera], [estratosfera, troposfera e ionosfera], [troposfera, estratosfera e ionosfera], [troposfera, ionosfera y estratosfera]),
  sol: [De abajo arriba: troposfera (donde está el tiempo atmosférico y ocurre la propagación troposférica), estratosfera y, por encima, la ionosfera, que es la que refleja las ondas de HF.],
)

#q("T7.23", "a",
  [La región de la atmósfera cuyo estado varía con la actividad solar y de la que dependen las condiciones de propagación en HF es:],
  ([la ionosfera], [la troposfera], [la estratosfera], [la mesosfera]),
  sol: [Es la radiación solar la que ioniza esas capas altas, de modo que el ciclo solar de once años, las fulguraciones y el día y la noche cambian por completo las condiciones en HF. La troposfera influye en VHF y UHF, pero no en la reflexión ionosférica.],
)

#q("T7.24", "d",
  [Para las comunicaciones a través de satélites de aficionado se emplean preferentemente las bandas de:],
  ([onda media], [80 y 40 metros], [frecuencias inferiores a 3 MHz], [VHF y UHF]),
  sol: [Para atravesar la ionosfera en lugar de reflejarse en ella hace falta subir por encima de las frecuencias que esta devuelve: los satélites de aficionado trabajan en 2 metros, 70 centímetros y bandas superiores. En HF buena parte de la señal se reflejaría en la ionosfera en vez de atravesarla.],
)

#q("T7.25", "b",
  [En las comunicaciones terrestres en la banda de UHF, y en igualdad de condiciones, puede afirmarse que:],
  ([el alcance aumenta con la frecuencia], [a mayor frecuencia, menor alcance], [el alcance no depende de la frecuencia], [el alcance depende solo de la modulación empleada]),
  sol: [Al subir en frecuencia las pérdidas de propagación crecen, la onda difracta peor y cualquier obstáculo produce sombra. Por eso en UHF se trabaja esencialmente con visión directa y los alcances son más cortos que en VHF a igualdad de potencia y antenas.],
)

#q("T7.26", "c",
  [Las ondas centimétricas se designan con la abreviatura:],
  ([UHF], [EHF], [SHF], [VHF]),
  sol: [SHF va de 3 a 30 GHz, es decir, longitudes de onda de 10 a 1 centímetro. Un escalón por debajo está UHF (decimétricas) y uno por encima EHF (milimétricas).],
)

Queda el último punto que promete el temario: la *predicción de propagación*. La materia prima son los índices de actividad solar — el *número de manchas solares* y el *flujo solar* medido en la longitud de onda de 10,7 cm —, que anticipan cuánta ionización habrá disponible; con ellos, la hora, la estación del año y el punto del ciclo de once años se estiman la MUF y la FOT de cada trayecto. Los programas de predicción (VOACAP y similares) automatizan ese cálculo y publican qué bandas y horas serán favorables para cada ruta; para el examen basta la idea: más actividad solar, más ionización y mejores bandas altas.

#ptitulo[Los índices, en la práctica] El flujo solar en 10,7 cm se mide en unidades de flujo solar: ronda 65–70 en el mínimo del ciclo y supera 150 en el máximo. Los índices *K* (de 0 a 9, cada tres horas) y *A* (diario) miden la agitación del campo magnético terrestre: un K alto anuncia una tormenta geomagnética, bandas altas cerradas y, quizá, aurora. La comprobación directa son las *balizas*: la red internacional NCDXF/IARU tiene 18 balizas repartidas por el mundo que transmiten por turnos en 14 100, 18 110, 21 150, 24 930 y 28 200 kHz. Si se oye la baliza de un continente, el camino hacia él está abierto.

== Preguntas sobre esquemas <t7-sec-esquemas>

#q("T7.27", "a",
  [En el espectro de la figura, correspondiente a tres emisiones simultáneas, la señal de menor frecuencia es:
    #align(center, cetz.canvas({
      import cetz.draw: *
      ejes(0, 7.2, 0, 2.3, etq-x: $f$)
      content((0, 2.4), anchor: "south", text(size: 7.5pt, fill: col.gris)[amplitud])
      for (x, h, n) in ((1.4, 1.75, "1"), (3.6, 1.1, "2"), (5.6, 1.5, "3")) {
        line((x, 0), (x, h), stroke: 1.3pt + col.acento)
        content((x, h + 0.1), anchor: "south", text(size: 7.5pt, weight: "bold", fill: col.naranja, n))
      }
    }))
  ],
  ([la señal 1], [la señal 2], [la señal 3], [las tres tienen la misma frecuencia]),
  sol: [El eje horizontal es la frecuencia y crece hacia la derecha, así que la señal situada más a la izquierda es la de menor frecuencia. La altura de cada raya es su amplitud, que aquí no se pregunta — es la trampa del enunciado.],
)
