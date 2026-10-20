// Capítulo de ejemplo: muestra TODAS las piezas de la plantilla.
// Compílalo con:  tools/check.sh tools/demo-capitulo.typ T3
#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

#tema("T3", "Circuitos (demostración)", alcance: [Asociación de componentes · resonancia · amplificadores.])

== El amplificador de emisor común <demo-sec-ec>

#motivacion[La señal que llega a la antena tiene microvoltios. Un altavoz necesita voltios. Hace falta un circuito que copie la señal *más grande*, sacando la energía de la pila.]

#ptitulo[La idea] Un transistor deja pasar entre colector y emisor una corriente $beta$ veces mayor que la de base. Si la corriente de base sigue a la señal, la de colector también, pero $beta$ veces mayor.

#circuito(caption: [Amplificador de emisor común con polarización por divisor.], sim: "ceamp.txt")[
  #esquema({
    import zap: *
    import cetz.draw: content
    // raíl de alimentación y masa
    wire((2, 6), (6.6, 6))
    wire((2, 0), (6.6, 0))
    node("vcc", (4, 6), label: (content: $+V_"CC"$, anchor: "north"))
    ground("gnd", (4, 0))
    // divisor de base
    resistor("r1", (2, 6), (2, 3), label: $R_1$)
    resistor("r2", (2, 3), (2, 0), label: $R_2$)
    // transistor
    npn("q1", (4.2, 3))
    wire((2, 3), "q1.b")
    resistor("rc", (4.2, 6), (4.2, 4.3), label: $R_C$)
    wire((4.2, 4.3), "q1.c")
    resistor("re", (4.2, 2.1), (4.2, 0), label: $R_E$)
    wire("q1.e", (4.2, 2.1))
    // condensador de desacoplo del emisor
    wire((4.2, 2.1), (5.5, 2.1))
    capacitor("ce", (5.5, 2.1), (5.5, 0), label: $C_E$)
    // acoplos de entrada y salida
    capacitor("cin", (0, 3), (2, 3), label: $C_"ent"$, n: "o-*")
    wire((4.2, 4.3), (5.6, 4.3))
    capacitor("cout", (5.6, 4.3), (7.4, 4.3), label: $C_"sal"$, n: "-o")
    content((-0.1, 3.5), text(size: 8pt)[entrada])
    content((7.4, 4.8), text(size: 8pt)[salida])
  })
] <demo-fig-ec>

#porque[
  - $R_1$ y $R_2$ fijan la base en una tensión continua fija: el transistor queda *a medio abrir* y puede seguir la señal hacia arriba y hacia abajo.
  - $C_"ent"$ y $C_"sal"$ dejan pasar la señal alterna y bloquean la continua: cada etapa conserva su punto de trabajo.
  - $C_E$ pone el emisor a masa para la señal; la ganancia sube de $R_C slash R_E$ a casi $beta$.
]

Como se ve en @demo-fig-ec, la salida sale del colector. La sección #ver(<demo-sec-ec>) lo explica.

#destacada($A_v approx - R_C / R_E$, nota: [sin $C_E$; con $C_E$ la ganancia es mucho mayor])

#idea[Polarizar es elegir el punto de reposo; la señal oscila alrededor de él.]
#ojo[El amplificador de emisor común *invierte* la fase 180°.]
#analogia[El transistor es un grifo: la mano (base) mueve poco; el caudal (colector) es grande.]
#ejemplo[Con $R_C = 4,7 "kΩ"$ y $R_E = 1 "kΩ"$: $A_v approx -4,7$.]

#circuito(caption: [Diagrama de bloques del superheterodino.])[
  #diagram(
    node-stroke: 0.7pt, node-corner-radius: 2pt, spacing: (9mm, 8mm),
    node((0, 0), [Antena], stroke: none),
    edge("-|>"),
    node((1, 0), [Amp. RF]),
    edge("-|>"),
    node((2, 0), [Mezclador]),
    edge("-|>"),
    node((3, 0), [FI]),
    edge("-|>"),
    node((4, 0), [Detector]),
    node((2, 1), [Oscilador local]),
    edge((2, 1), (2, 0), "-|>"),
  )
]

#circuito(caption: [Curva de resonancia: la corriente es máxima en $f_0$.])[
  #cetz.canvas({
    import cetz.draw: *
    ejes(0, 6.4, 0, 3.4, etq-x: $f$, etq-y: $I$)
    onda(x => 3 / calc.sqrt(1 + 16 * calc.pow(x / 3 - 3 / calc.max(x, 0.05), 2)), 0.3, 6.2, stroke: 1.2pt + col.senal1)
    onda(x => 3 / calc.sqrt(1 + 2 * calc.pow(x / 3 - 3 / calc.max(x, 0.05), 2)), 0.3, 6.2, stroke: (paint: col.senal2, thickness: 1pt, dash: "dashed"))
    line((3, 0), (3, 3), stroke: (dash: "dotted", thickness: 0.5pt))
    content((3, -0.1), anchor: "north", text(size: 8pt, $f_0$))
  })
]

#ejercicio(sol: [Sin $C_E$, $A_v approx -R_C slash R_E = -4,7$.])[Quita $C_E$ en @demo-fig-ec. ¿Qué ganancia queda?]

#q("T3.1", "b", [En un amplificador de emisor común, la señal de salida respecto a la de entrada está:], ([en fase], [desfasada 180°], [desfasada 90°], [desfasada 45°]), sol: [El aumento de corriente de colector hace caer la tensión en el colector: la salida se invierte.])

#q("T3.2", "c", [¿Qué clase de amplificador conduce durante menos de medio ciclo, y por qué esta clase necesita un circuito tanque en la salida para que la señal vuelva a ser una sinusoide?], ([Clase A, porque su rendimiento es bajo], [Clase B, porque conduce medio ciclo], [Clase C, porque el tanque LC restaura la sinusoide por el efecto volante], [Clase AB, porque elimina la distorsión de cruce]), sol: [Clase C: conduce < 180°.])

#soluciones-ejercicios()

