// =====================================================================
//  Simulacros de examen de radioaficionado — documento GENERADO.
//  No editar a mano: python3 -I tools/simulacros/generar.py build/simulacros/plan.json simulacros.typ
//  Compilar: typst compile --root . --font-path fonts simulacros.typ build/simulacros.pdf
// =====================================================================
#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

#show: libro
#set document(title: "Examen de Radioaficionado — Simulacros de examen con soluciones razonadas")
#set heading(numbering: none)
#set figure(numbering: "1")

// ---------------------------------------------------------------------
//  Piezas de los simulacros
// ---------------------------------------------------------------------
#let _titulo-prueba = (
  "1": [Prueba 1 · Electricidad y radioelectricidad],
  "2": [Prueba 2 · Normativa reglamentaria],
)

/// Abre un simulacro en página impar.
#let simulacro(n) = {
  _salto-capitulo()
  capitulo-actual.update("S" + str(n))
  counter(figure.where(kind: image)).update(0)
  place(hide(heading(level: 1)[Simulacro #n]))
  v(1.6cm)
  align(center, text(font: fuente-sans, size: 9pt, weight: "semibold", tracking: 0.14em, fill: col.acento, upper[Simulacro de examen]))
  v(0.2cm)
  align(center, text(font: fuente-sans, size: 30pt, weight: "bold", fill: col.tinta)[#n])
  v(0.3cm)
  align(center, line(length: 30%, stroke: 1.2pt + col.acento))
  v(0.5cm)
  align(center, block(width: 86%, {
    set par(justify: false)
    set text(size: 9.5pt, fill: col.gris)
    [Dos pruebas de 30 preguntas, 45 minutos cada una. Cada pregunta tiene una sola respuesta correcta y los errores no restan. Apruebas cada prueba por separado con 15 aciertos; apunta a 25 o más. Haz las dos pruebas sin mirar el libro y corrige después con las soluciones del final del simulacro.]
  }))
  v(0.4cm)
  align(center, table(
    columns: (auto, 2.4cm, 2.4cm),
    stroke: 0.5pt + col.gris.lighten(40%),
    inset: (x: 8pt, y: 6pt),
    fill: (x, y) => if y == 0 { col.gris-claro },
    [], [*Prueba 1*], [*Prueba 2*],
    [Aciertos], [#h(1fr) / 30], [#h(1fr) / 30],
    [Fecha], [], [],
  ))
  v(0.6cm)
}

/// Encabezado de una prueba (la prueba 2 empieza en página nueva).
#let prueba(n, p) = {
  if p == 2 { pagebreak(weak: true) }
  heading(level: 2, _titulo-prueba.at(str(p)))
  v(-0.6em)
  align(right, text(font: fuente-sans, size: 8.5pt, fill: col.gris)[Simulacro #n · 30 preguntas · 45 minutos])
  v(0.2em)
}

#let fin-prueba() = {
  v(0.6em)
  align(center, text(font: fuente-sans, size: 8pt, tracking: 0.2em, fill: col.gris)[— FIN DE LA PRUEBA —])
}

/// Pregunta de simulacro. `origen` = id de la pregunta en el libro ("" si es nueva).
#let pq(n, p, k, clave, origen, concepto, enunciado, opciones, sol: none) = {
  [#metadata((n: n, p: p, k: k, clave: clave, origen: origen, concepto: concepto, sol: sol)) <meta-sim>]
  block(width: 100%, breakable: false, above: 1.05em, below: 1.05em, {
    box(width: 1.7em, text(font: fuente-sans, weight: "bold", fill: col.acento)[#k.])
    enunciado
    v(0.15em)
    layout(tam => {
      let items = opciones.enumerate().map(((i, o)) => box[
        #text(font: fuente-sans, weight: "semibold", fill: col.acento)[#_letras.at(i))]
        #h(0.15em) #o
      ])
      let ancho = calc.max(..items.map(it => measure(it).width))
      let hueco = measure(h(1.2em)).width
      let cols = if ancho < tam.width / 4 - hueco { 4 } else if ancho < tam.width / 2 - hueco { 2 } else { 1 }
      pad(left: 1.7em, grid(columns: (1fr,) * cols, column-gutter: 1em, row-gutter: 0.55em, ..items))
    })
  })
}

/// Clave rápida y soluciones razonadas de las dos pruebas de un simulacro.
#let soluciones-simulacro(n) = {
  pagebreak(weak: true)
  heading(level: 2)[Soluciones del simulacro #n]
  context {
    let todas = query(<meta-sim>).map(m => m.value).filter(v => v.n == n)
    for p in (1, 2) {
      let qs = todas.filter(v => v.p == p)
      block(above: 1.2em, below: 0.6em, sticky: true, text(font: fuente-sans, size: 11pt, weight: "bold", fill: col.acento, _titulo-prueba.at(str(p))))
      clave-rapida(qs.map(v => (str(v.k), v.clave)), por-fila: 15)
      set text(size: 9.5pt)
      for v in qs {
        block(below: 0.8em, breakable: true, [
          #text(font: fuente-sans, weight: "bold", fill: col.acento)[#v.k] #text(weight: "bold")[(#v.clave)]
          #if v.concepto != "" { text(font: fuente-sans, size: 0.85em, fill: col.gris)[#v.concepto #if v.origen != "" [· libro: #v.origen] — ] } else if v.origen != "" { text(font: fuente-sans, size: 0.85em, fill: col.gris)[libro: #v.origen — ] }
          #v.sol
        ])
      }
    }
  }
}

// ---------------------------------------------------------------------
//  Apéndice A: repaso de conceptos marginales (pregunta → respuesta)
// ---------------------------------------------------------------------
#let repaso-inicio() = {
  _salto-capitulo()
  place(hide(heading(level: 1)[Apéndice A · Repaso de conceptos marginales]))
  v(1.2cm)
  align(center, text(font: fuente-sans, size: 9pt, weight: "semibold", tracking: 0.14em, fill: col.acento, upper[Apéndice A]))
  v(0.2cm)
  align(center, text(font: fuente-sans, size: 20pt, weight: "bold")[Repaso de conceptos marginales])
  v(0.5cm)
  block(width: 100%, {
    set par(justify: false)
    set text(size: 9.5pt)
    [Estos conceptos son de peso menor (casi todos de la prueba técnica): caen poco, pero caen. No ocupan sitio en los simulacros para no alargarlos; aquí están en formato rápido, pregunta y respuesta correcta, con el número de la pregunta del libro donde está el razonamiento. Léelos cuando domines los simulacros: cada uno se aprende en segundos.]
  })
  v(0.4cm)
}
#let repaso-tema(id, titulo) = {
  block(above: 1.1em, below: 0.6em, sticky: true, text(font: fuente-sans, size: 11pt, weight: "bold", fill: col.acento)[#id · #titulo])
}
#let rq(i, origen, enunciado, respuesta) = block(width: 100%, breakable: true, above: 0.55em, below: 0.55em, {
  set text(size: 9pt)
  set par(justify: false)
  grid(columns: (2.2em, 1fr), column-gutter: 0.3em,
    text(font: fuente-sans, weight: "bold", fill: col.gris, size: 8pt)[R#i],
    [#enunciado #h(0.3em) #text(fill: col.verde, weight: "bold")[→] #text(fill: col.verde)[#respuesta] #if origen != "" { h(0.4em); text(font: fuente-sans, size: 7.5pt, fill: col.gris)[(libro: #origen)] }],
  )
})

// ---------------------------------------------------------------------
//  Apéndice B: mapa de conceptos
// ---------------------------------------------------------------------
#let mapa-inicio() = {
  _salto-capitulo()
  place(hide(heading(level: 1)[Apéndice B · Mapa de conceptos]))
  v(1.2cm)
  align(center, text(font: fuente-sans, size: 9pt, weight: "semibold", tracking: 0.14em, fill: col.acento, upper[Apéndice B]))
  v(0.2cm)
  align(center, text(font: fuente-sans, size: 20pt, weight: "bold")[Mapa de conceptos])
  v(0.5cm)
  block(width: 100%, {
    set par(justify: false)
    set text(size: 9.5pt)
    [Todos los conceptos del temario que cubren estos simulacros, tema a tema, y dónde está cada uno. #text(font: fuente-sans, weight: "bold")[3·1·7] es el simulacro 3, prueba 1, pregunta 7; #text(font: fuente-sans, weight: "bold")[R57] es el número 57 del repaso del apéndice A. Úsalo para repasar un tema entero o para comprobar que no te queda nada por ver.]
  })
  v(0.3cm)
  set text(size: 8.3pt)
  set par(justify: false, leading: 0.5em)
}
#let mapa-tema(id, titulo) = {
  block(above: 1em, below: 0.45em, sticky: true, width: 100%, stroke: (bottom: 0.5pt + col.acento.lighten(50%)), inset: (bottom: 2pt),
    text(font: fuente-sans, size: 10pt, weight: "bold", fill: col.acento)[#id · #titulo])
}
#let mapa-item(concepto, donde) = block(above: 0.28em, below: 0.28em, breakable: false,
  grid(columns: (1fr, auto), column-gutter: 0.8em,
    text(size: 8.3pt, concepto),
    text(font: fuente-sans, size: 7.8pt, weight: "semibold", fill: col.acento, donde)))
#let mapa-cuerpo(c) = { set par(justify: false); columns(2, gutter: 0.7cm, c) }

// ---- macros locales copiadas de los capítulos del libro (generado) ----
// de chapters/ap-c1.typ
#let _apc1-noest(cuerpo) = no-esta(cuerpo)
// de chapters/t03.typ
#let _t3-et(pos, cuerpo, anchor: "center", size: 8pt, fill: black) = cetz.draw.content(pos, anchor: anchor, text(size: size, fill: fill, cuerpo))
// de chapters/ap-c2.typ
#let _apc2-m(t) = text(font: "DejaVu Sans Mono", size: 0.82em, t)
// de chapters/ap-c3.typ
#let _apc3-ver(cuerpo) = vease(cuerpo)
// de chapters/ap-c3.typ
#let _apc3-net(cuerpo) = no-esta(cuerpo)
// de chapters/ap-b2.typ
#let _apb2-clave(cuerpo) = clave-bancos(cuerpo)
// de chapters/r04.typ
#let _r4-sc(t) = {
  for c in t.clusters() {
    if lower(c) == c and upper(c) != c { text(size: 0.8em, upper(c)) } else { c }
  }
}
// de chapters/ap-b1.typ
#let _apb1-ant = cetz.canvas(length: 2.6mm, {
  import cetz.draw: *
  line((0, -1.4), (0, 0), stroke: 0.7pt)
  line((-0.8, 1.0), (0, 0), (0.8, 1.0), stroke: 0.7pt)
})
// de chapters/ap-b1.typ
#let _apb1-etq(t) = text(size: 6pt, fill: col.gris, t)
// de chapters/ap-b1.typ
#let _apb1-bq(pos, txt, ..args) = node(
  pos, align(center, text(size: 6.4pt, txt)),
  shape: rect, stroke: 0.6pt + col.acento, fill: col.acento-claro, inset: 3pt, corner-radius: 1.5pt, ..args,
)
// de chapters/ap-b1.typ
#let _apb1-alt = cetz.canvas(length: 2.6mm, {
  import cetz.draw: *
  rect((0, -0.5), (0.7, 0.5), stroke: 0.7pt)
  line((0.7, 0.5), (1.5, 1.1), (1.5, -1.1), (0.7, -0.5), stroke: 0.7pt)
})
// de chapters/ap-b1.typ
#let _apb1-rx(b1, b3, b4, o1, o2) = box(baseline: 60%, diagram(
  node-stroke: 0.6pt, spacing: (4.2mm, 6mm), edge-stroke: 0.6pt, mark-scale: 70%,
  node((0, 0), stack(dir: ttb, spacing: 1pt, _apb1-ant, _apb1-etq[antena]), stroke: none),
  edge((0, 0), (1, 0), "-|>"),
  _apb1-bq((1, 0), b1),
  edge((1, 0), (2, 0), "-|>"),
  _apb1-bq((2, 0), [mezclador]),
  edge((2, 0), (3, 0), "-|>"),
  _apb1-bq((3, 0), b3),
  edge((3, 0), (4, 0), "-|>"),
  _apb1-bq((4, 0), b4),
  edge((4, 0), (5, 0), "-|>"),
  _apb1-bq((5, 0), [amplificador\ BF]),
  edge((5, 0), (6, 0), "-|>"),
  node((6, 0), stack(dir: ttb, spacing: 1pt, _apb1-alt, _apb1-etq[altavoz]), stroke: none),
  _apb1-bq((2, 1), o1),
  edge((2, 1), (2, 0), "-|>"),
  ..if o2 != none { (_apb1-bq((4, 1), o2), edge((4, 1), (4, 0), "-|>")) } else { () },
))
// de chapters/r08.typ
#let _r8-cod(t) = text(font: fuente-mono, size: 0.88em, fill: col.acento, t)
// de chapters/r06.typ
#let _r6-cod(t) = text(font: fuente-mono, size: 0.88em, fill: col.acento, t)
// de chapters/r07.typ
#let _r7-cod(t) = text(font: fuente-mono, size: 0.88em, fill: col.acento, t)
// de chapters/ap-b1.typ
#let _apb1-mic = cetz.canvas(length: 2.6mm, {
  import cetz.draw: *
  circle((0, 0), radius: 0.6, stroke: 0.7pt, fill: white)
})
// de chapters/ap-b1.typ
#let _apb1-tx(n1, n2, n3, n5) = box(baseline: 60%, diagram(
  node-stroke: 0.6pt, spacing: (4.2mm, 6mm), edge-stroke: 0.6pt, mark-scale: 70%,
  node((0, 0), stack(dir: ttb, spacing: 1pt, _apb1-mic, _apb1-etq[micrófono]), stroke: none),
  edge((0, 0), (1, 0), "-|>"),
  _apb1-bq((1, 0), n1),
  edge((1, 0), (2, 0), "-|>"),
  _apb1-bq((2, 0), n2),
  edge((2, 0), (3, 0), "-|>"),
  _apb1-bq((3, 0), n3),
  edge((3, 0), (4, 0), "-|>"),
  _apb1-bq((4, 0), [mezclador]),
  edge((4, 0), (5, 0), "-|>"),
  _apb1-bq((5, 0), n5),
  edge((5, 0), (6, 0), "-"),
  node((6, 0), stack(dir: ttb, spacing: 1pt, _apb1-ant, _apb1-etq[antena]), stroke: none),
  _apb1-bq((2, 1), [oscilador]),
  edge((2, 1), (2, 0), "-|>"),
  _apb1-bq((4, 1), [oscilador\ variable]),
  edge((4, 1), (4, 0), "-|>"),
))
// de chapters/t04.typ
#let _t4-diagrama(..args) = diagram(
  node-stroke: 0.7pt + col.acento,
  node-fill: col.acento-claro,
  node-corner-radius: 2pt,
  edge-stroke: 0.6pt,
  spacing: (8mm, 8mm),
  ..args,
)
// de chapters/t04.typ
#let _t4-t(t) = text(font: fuente-sans, size: 7.5pt, t)
// de chapters/t04.typ
#let _t4-preg(pos, ..args) = node(
  pos,
  text(font: fuente-sans, size: 11pt, weight: "bold", fill: col.naranja)[?],
  shape: rect,
  stroke: (paint: col.naranja, thickness: 0.7pt, dash: "dashed"),
  fill: col.naranja-claro,
  width: 13mm,
  height: 7mm,
  ..args,
)
// de chapters/ap-b1.typ
#let _apb1-clave(cuerpo) = clave-bancos(cuerpo)
// de chapters/ap-b1.typ
#let _apb1-pot = esquema({
  import zap: *
  import cetz.draw: *
  let tr = 0.6pt
  // pila y cable inferior
  bateria("e", (0, 3), (0, 0), label: (content: $E$, anchor: "west"))
  line((0, 0), (10.8, 0), stroke: tr)
  // conmutador izquierdo: pivote, cuchilla y dos posiciones
  line((0, 3), (1.0, 3), stroke: tr)
  circle((1.0, 3), radius: 0.05, fill: black, stroke: none)
  line((1.0, 3), (2.0, 3), stroke: 1.2pt)
  circle((2.7, 3.9), radius: 0.07, fill: white, stroke: tr)
  circle((2.7, 2.1), radius: 0.07, fill: white, stroke: tr)
  content((2.35, 3.9), text(size: 8pt, weight: "bold", fill: col.naranja)[1])
  content((2.35, 2.1), text(size: 8pt, weight: "bold", fill: col.naranja)[2])
  line((2.77, 3.9), (3.4, 3.9), stroke: tr)
  medidor("a1", (3.4, 3.9), (5.0, 3.9), letra: "A")
  line((5.0, 3.9), (5.9, 3.9), (5.9, 3.0), stroke: tr)
  line((2.77, 2.1), (3.4, 2.1), stroke: tr)
  medidor("v1", (3.4, 2.1), (5.0, 2.1), letra: "V")
  line((5.0, 2.1), (5.9, 2.1), (5.9, 3.0), stroke: tr)
  circle((5.9, 3.0), radius: 0.04, fill: black, stroke: none)
  // rama de R
  line((5.9, 3.0), (9.9, 3.0), stroke: tr)
  circle((7.2, 3.0), radius: 0.04, fill: black, stroke: none)
  resistor("r", (7.2, 3.0), (7.2, 0), label: (content: $R$, anchor: "west"))
  circle((7.2, 0), radius: 0.04, fill: black, stroke: none)
  // conmutador derecho
  circle((9.9, 3.0), radius: 0.05, fill: black, stroke: none)
  line((9.9, 3.0), (9.9, 2.3), stroke: 1.2pt)
  circle((9.1, 2.05), radius: 0.07, fill: white, stroke: tr)
  circle((10.7, 2.05), radius: 0.07, fill: white, stroke: tr)
  content((8.75, 2.2), text(size: 8pt, weight: "bold", fill: col.naranja)[1])
  content((11.05, 2.2), text(size: 8pt, weight: "bold", fill: col.naranja)[2])
  line((9.1, 1.98), (9.1, 1.6), stroke: tr)
  medidor("v2", (9.1, 1.6), (9.1, 0.4), letra: "V")
  line((9.1, 0.4), (9.1, 0), stroke: tr)
  line((10.7, 1.98), (10.7, 1.6), stroke: tr)
  medidor("a2", (10.7, 1.6), (10.7, 0.4), letra: "A")
  line((10.7, 0.4), (10.7, 0), stroke: tr)
})
#let datos = (n: 13, preguntas: 780, conceptos: 949, repaso: 201, nuevas: 32, tecnicas: 390)

// =====================================================================
//  Portada, instrucciones e índice (fijo; los números salen de `datos`)
// =====================================================================
#page(header: none, footer: none, margin: (x: 2.2cm, y: 2.4cm))[
  #set align(center)
  #set par(justify: false)
  #v(2.2cm)
  #text(font: fuente-sans, size: 10pt, weight: "bold", tracking: 0.25em, fill: col.naranja)[EXAMEN DE RADIOAFICIONADO]
  #v(0.2cm)
  #text(font: fuente-sans, size: 8pt, tracking: 0.12em, fill: col.gris)[PRUEBA DE CAPACITACIÓN · ORDEN IET/1311/2013 · CERTIFICADO HAREC]
  #v(2.4cm)
  #text(font: fuente-sans, size: 34pt, weight: "bold", fill: col.tinta)[Simulacros de examen]
  #v(0.3cm)
  #text(size: 14pt)[#datos.n simulacros completos con soluciones razonadas]
  #v(0.5cm)
  #line(length: 40%, stroke: 0.8pt + col.acento)
  #v(0.6cm)
  #block(width: 78%, align(left, {
    set text(size: 10.5pt)
    set list(marker: text(fill: col.acento)[•], spacing: 0.8em, body-indent: 0.6em)
    [
      - #datos.n simulacros con el formato real: 30 preguntas de electricidad y radioelectricidad y 30 de normativa, 45 minutos cada prueba.
      - #datos.preguntas preguntas sin repetir conceptos: #datos.conceptos conceptos del temario, cada uno en su sitio.
      - Clave rápida y solución razonada de cada pregunta, con su referencia al libro.
      - Repaso final de #datos.repaso conceptos marginales y mapa de todos los conceptos.
    ]
  }))
  #v(1fr)
  #text(font: fuente-sans, size: 9pt, tracking: 0.2em, fill: col.gris)[COMPAÑERO DE «EXAMEN DE RADIOAFICIONADO» · OCTUBRE 2026]
]

#page(header: none, footer: none)[]

#counter(page).update(3)
#estilo-paginas.update("i")
#place(hide(heading(level: 1)[Cómo usar estos simulacros]))
#v(1.2cm)
#align(center, text(font: fuente-sans, size: 19pt, weight: "bold")[Cómo usar estos simulacros])
#v(0.6cm)

=== Qué son

El libro tiene unas 1400 preguntas. Muchas preguntan lo mismo con otras palabras o con otros números: saber responder una basta para responder las demás. Aquí se han agrupado en *conceptos*: un concepto es un hecho o una destreza que el examen puede preguntar con una sola pregunta. De cada concepto se ha elegido la mejor pregunta, la que se parece más al examen y cuyos distractores enseñan la trampa típica. Donde el banco no tenía ninguna pregunta para un punto del temario, se ha escrito una nueva y se ha revisado por separado.

Cada concepto sale *una sola vez*. Unos pocos salen dos veces porque la segunda pregunta prueba otro ángulo que el examen usa de verdad (el dato al revés, el cálculo en el otro sentido, otra trampa); esas dos preguntas están siempre al menos cuatro simulacros separadas. Ninguna pregunta se repite. Los temas se solapan (componentes y circuitos, receptores e interferencias, distintivos y reglamentación): cuando dos temas preguntaban lo mismo, el concepto sale una sola vez, en el tema donde mejor encaja.

=== Qué cubren

Cada concepto tiene un peso según lo que cae en el examen: *núcleo* (cae a menudo), *normal* y *marginal*. Los #datos.n simulacros contienen *todos* los conceptos de núcleo y normales de las dos pruebas y casi todos los marginales de normativa, donde el examen real se parece mucho a los bancos públicos y un dato suelto vale un punto. Los demás conceptos marginales, casi todos de la prueba técnica, caen poco: están en el apéndice A en formato rápido de pregunta y respuesta. Dentro de cada simulacro, cada tema tiene un número de preguntas parecido al del examen real, y las preguntas van en el orden del temario.

La idea: si entiendes —no solo recuerdas— todas las preguntas de los #datos.n simulacros y lees el repaso del apéndice A, has visto todo lo que el examen puede preguntar, y lo has visto con el tipo de pregunta del examen.

=== Cómo trabajarlos

+ *Haz cada simulacro en condiciones de examen*: 45 minutos por prueba, sin libro ni apuntes, anotando una letra por pregunta. Apunta los aciertos en la tabla de la portada del simulacro.
+ *Corrige con la clave* y lee después la solución razonada de *todas* las preguntas, también las acertadas: una pregunta acertada por descarte no está aprendida.
+ *Por cada fallo*, ve al libro. Debajo de cada solución está el número de la pregunta del libro (por ejemplo, _libro: T3.14_) y, en muchas, la sección del tema donde se explica.
+ *Vuelve a los fallos* una semana después. Puedes rehacer un simulacro entero: las respuestas no se pueden memorizar por la letra, porque se han reordenado.
+ El aprobado es 15 de 30 en cada prueba por separado. *Apunta a 25 o más*: ese margen absorbe las preguntas nuevas que el examen incorpora.

=== Dos avisos

#ojo(titulo: [claves de los bancos públicos])[Algunas preguntas de los bancos públicos tienen en las recopilaciones una clave que es técnicamente incorrecta o que corresponde a una norma ya derogada. Estos simulacros dan la respuesta correcta según la física y la norma vigente, y la solución avisa (_clave de los bancos públicos_) cuando el examen podría puntuar la otra. Aprende las dos.]

#nota[Las referencias a figuras o tablas «del libro» remiten al libro _Examen de Radioaficionado_, que desarrolla cada concepto. Los números como *3·1·7* del mapa de conceptos significan simulacro 3, prueba 1, pregunta 7.]

=== Registro de resultados

#align(center, table(
  columns: (auto, 2.6cm, 2.6cm, 3cm),
  inset: (x: 8pt, y: 4.5pt),
  stroke: 0.5pt + col.gris.lighten(40%),
  fill: (x, y) => if y == 0 { col.gris-claro },
  [*Simulacro*], [*Prueba 1*], [*Prueba 2*], [*Fecha*],
  ..range(1, datos.n + 1).map(i => ([#i], [#h(1fr) / 30], [#h(1fr) / 30], [])).flatten(),
))

#pagebreak(weak: true)
#{
  set par(justify: false)
  show heading.where(level: 1): it => {
    v(1.2cm)
    align(center, text(font: fuente-sans, size: 19pt, weight: "bold", it.body))
    v(0.6cm)
  }
  let pagina(it) = {
    let loc = it.element.location()
    numbering(estilo-paginas.at(loc), ..counter(page).at(loc))
  }
  show outline.entry.where(level: 1): it => {
    v(0.55em, weak: true)
    link(it.element.location(), it.indented(none, [#text(font: fuente-sans, weight: "semibold", it.body()) #box(width: 1fr, repeat(gap: 0.35em, text(fill: col.gris.lighten(40%))[.])) #text(fill: col.gris, pagina(it))]))
  }
  outline(title: [Índice], depth: 1)
}

// ------------------------------------------------ cuerpo
#_salto-capitulo()
#counter(page).update(1)
#estilo-paginas.update("1")

// ======================================================================
#simulacro(1)
#prueba(1, 1)
#pq(1, 1, 1, "a", "T1.4", "Carga y corriente: 1 C = 1 A · 1 s y 1 A = 1 C/s",
  [Un culombio es igual a:],
  ([el producto de un amperio por un segundo], [un vatio por segundo], [un voltio dividido por un ohmio], [un amperio dividido por un segundo],),
  sol: [El culombio es la carga transportada por una corriente de un amperio durante un segundo: $Q = I dot t$.])
#pq(1, 1, 2, "a", "T1.8", "Potencia eléctrica: P = V I = I² R = V² / R",
  [La potencia disipada en una resistencia de 30 ohmios por la que circula una corriente de 2 amperios es de:],
  ([120 vatios], [60 vatios], [240 vatios], [15 vatios],),
  sol: [$P = I^2 R = 2^2 dot 30 = 120$ W. La corriente entra al cuadrado: doblarla cuadruplica la potencia disipada.])
#pq(1, 1, 3, "d", "F-T1.7", "Señales no sinusoidales: fundamental y armónicos (onda cuadrada: solo impares)",
  [Un oscilador genera una onda cuadrada simétrica (ciclo de trabajo del 50 %, sin componente continua) de 7,05 MHz. Además de la fundamental, su espectro contiene componentes en:],
  ([14,10 MHz, 28,20 MHz, 42,30 MHz…(solo los múltiplos pares)], [14,10 MHz, 21,15 MHz, 28,20 MHz…(todos los múltiplos enteros)], [3,525 MHz, 2,35 MHz, 1,76 MHz…(los submúltiplos)], [21,15 MHz, 35,25 MHz, 49,35 MHz…(solo los múltiplos impares)],),
  sol: [Por Fourier, una onda cuadrada simétrica es una fundamental de 7,05 MHz más los armónicos _impares_, $3 f$, $5 f$, $7 f$…, con amplitudes 1/3, 1/5, 1/7… de la fundamental: $3 times 7,05 = 21,15$ MHz, $5 times 7,05 = 35,25$ MHz y $7 times 7,05 = 49,35$ MHz. Los armónicos pares (14,10, 28,20, 42,30 MHz) solo aparecen si la onda es asimétrica, con ciclo de trabajo distinto del 50 %. Los submúltiplos nunca son armónicos: estos son siempre múltiplos enteros de la fundamental. _(Véase tema T1, sección «Ondas y señales».)_

#_apc1-noest[Toda señal periódica no sinusoidal se descompone en una componente continua (su valor medio), una fundamental y armónicos múltiplos enteros de ella. En la onda cuadrada simétrica, sin componente continua, solo hay armónicos impares ($3 f$, $5 f$, $7 f$…), con amplitud $1 slash n$ de la fundamental; los pares desaparecen. Si el ciclo de trabajo no es del 50 % aparecen también los pares, y si la onda no está centrada en cero, una componente continua.]])
#pq(1, 1, 4, "b", "T1.30", "Referencias de decibelios: ×2 = +3 dB, ×4 = +6 dB, ×10 = +10 dB, ÷2 = −3 dB",
  [Si la potencia de salida de un transmisor se duplica, el aumento expresado en decibelios es de:],
  ([2 dB], [3 dB], [6 dB], [10 dB],),
  sol: [$10 log_10 (2) approx 3$ dB. Referencias de memoria: doble = +3 dB, cuádruple = +6 dB, diez veces = +10 dB.])
#pq(1, 1, 5, "d", "T2.46", "Código de colores: la cuarta banda es la tolerancia (oro ±5 %, plata ±10 %, marrón ±1 %)",
  [En el código de colores de un componente, una tolerancia del 5 % se representa con una franja de color:],
  ([rojo], [plata], [marrón], [oro],),
  sol: [Oro es ±5 % y plata ±10 %. Cuando la banda es marrón, la tolerancia es del 1 %, propia de componentes de precisión.])
#pq(1, 1, 6, "b", "F-T2.27", "Cálculo de la reactancia capacitiva X_C = 1/(2πfC)",
  [La reactancia de un condensador de 100 pF a 14 MHz es aproximadamente de:],
  ([714 Ω], [114 Ω], [11,4 Ω], [1,14 kΩ],),
  sol: [$X_C = 1/(2 pi f C) = 1/(2 pi times 14 dot 10^6 times 100 dot 10^(-12)) = 1/(8,8 dot 10^(-3)) approx 114$ Ω. Olvidar el factor $2 pi$ da 714 Ω; los errores de potencia de diez (pF, MHz) dan 11,4 Ω o 1,14 kΩ. Además, el resultado tiene sentido: al subir la frecuencia $X_C$ baja, y a 7 MHz el mismo condensador presentaría justo el doble (unos 227 Ω). Por eso un condensador pequeño deja pasar bien la radiofrecuencia y bloquea la continua. _(Véase tema T2, sección «Condensadores».)_])
#pq(1, 1, 7, "b", "T2.16", "La reactancia inductiva X_L = 2πfL crece con la frecuencia y es nula en continua",
  [La reactancia inductiva de una bobina, cuando la frecuencia de la corriente es cero (corriente continua):],
  ([es infinita], [vale cero], [no puede calcularse], [es igual a su resistencia óhmica multiplicada por dos],),
  sol: [$X_L = 2 pi f L$: con $f = 0$ (corriente continua), la reactancia es cero — la bobina ideal es un cortocircuito para la continua.])
#pq(1, 1, 8, "a", "C-T2.10", "Elevador o reductor según el número de espiras de primario y secundario",
  [Si en un transformador el primario tiene menos espiras que el secundario, este transformador es:],
  ([Elevador], [Reductor], [Igualador], [Mixto],),
  sol: [
    La tensión sigue al número de espiras: $V_s slash V_p = N_s slash N_p$. Si el primario tiene
    menos espiras que el secundario ($N_p < N_s$), la tensión del secundario es mayor que la de
    entrada: el transformador es elevador. La definición vale también en sentido inverso: en un
    transformador elevador el secundario tiene más espiras que el primario, y no es indiferente la
    relación de espiras, porque de ella depende la tensión de salida. Reductor es el caso contrario;
    con igual número de espiras la tensión no cambia. «Mixto» e «igualador» no son tipos de
    transformador. Ejemplo: 12 V con 100 espiras en el primario y 500 en el secundario dan 12 ×
    500/100 = 60 V. #vease[(Véase tema T2, sección «Transformadores».)]
  ])
#pq(1, 1, 9, "a", "T2.30", "El nombre de la válvula cuenta electrodos: pentodo = cátodo, tres rejillas y placa",
  [Una válvula pentodo recibe ese nombre porque dispone de:],
  ([cinco electrodos: cátodo, tres rejillas y placa], [cinco filamentos de caldeo independientes], [cinco placas conectadas en paralelo], [cinco terminales de conexión al zócalo],),
  sol: [El prefijo cuenta electrodos, no terminales: cátodo, rejilla de control, rejilla de pantalla, rejilla supresora y placa. Con la misma lógica, el tríodo tiene tres y el tetrodo cuatro.])
#pq(1, 1, 10, "b", "T3.57", "Condensador en continua, en régimen permanente: circuito abierto (queda el divisor resistivo)",
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
  ([12 V], [9 V], [0 V], [3 V],),
  sol: [En régimen permanente el condensador está cargado y no circula corriente por su rama, así que el circuito se reduce al divisor de las dos resistencias: $V_C = 12 dot 3 slash (1 + 3) = 9$ V. El condensador queda a la tensión del punto al que está conectado.])
#pq(1, 1, 11, "c", "C-T3.1", "Factor de calidad Q: mide la selectividad; Q = f0/B",
  [¿Qué indica el factor de calidad $Q$ de un circuito resonante?],
  ([Relación entre el ancho de banda de entrada y salida], [La facultad para estabilizar un circuito], [Facultad para seleccionar una frecuencia eliminando las demás], [La calidad de los componentes eléctricos],),
  sol: [
    El factor de calidad $Q = f_0 slash B$ mide la agudeza de la resonancia: cuanto mayor es $Q$,
    más estrecha es la curva de respuesta y mejor selecciona el circuito su frecuencia rechazando
    las demás. No mide «la calidad de los componentes» (unas pérdidas bajas dan un $Q$ alto, pero
    eso es una consecuencia, no la definición), ni estabiliza nada, y en un circuito resonante no
    hay un ancho de banda de entrada y otro de salida: solo un ancho de banda $B$, el medido entre
    los puntos de −3 dB. #vease[(Véase tema T3, sección «Asociación de componentes y resonancia».)]
  ])
#pq(1, 1, 12, "d", "C-T3.9", "Función del rectificador: convertir la alterna en continua (pulsante)",
  [La función de un rectificador de corriente consiste en:],
  ([Transformar la corriente continua en alterna], [Cambiar la polaridad de la corriente], [Limitar los máximos de corriente], [Transformar la corriente alterna en continua],),
  sol: [
    Un rectificador aprovecha que el diodo solo conduce en un sentido para convertir la corriente
    alterna, que cambia de sentido, en una corriente que circula siempre en el mismo: continua
    pulsante, que después el filtro alisa. Transformar continua en alterna es lo que hace un
    oscilador o un inversor; limitar los máximos de corriente es tarea de un limitador o de un
    fusible. «Cambiar la polaridad» no describe su función: el rectificador no invierte nada, hace
    que la salida tenga siempre la misma polaridad. #vease[(Véase tema T3, sección «Fuentes de
    alimentación y amplificadores».)]
  ])
#pq(1, 1, 13, "b", "T3.20", "Realimentación: devolver parte de la salida a la entrada; la negativa reduce la ganancia y mejora estabilidad y linealidad, la positiva hace oscilar",
  [La realimentación negativa aplicada a un amplificador:],
  ([hace que el circuito oscile], [reduce la ganancia pero mejora la estabilidad y la linealidad], [no altera ninguna característica del amplificador], [aumenta la ganancia y la distorsión],),
  sol: [Es el intercambio de siempre: se sacrifica ganancia — que sobra y es barata — a cambio de estabilidad, linealidad y ancho de banda. La que hace oscilar al circuito es la realimentación positiva, que es justo el principio del oscilador.])
#pq(1, 1, 14, "a", "F-T3.21", "Ruido de fase: fluctuaciones aleatorias de fase que crean faldones de ruido a ambos lados de la portadora (en TX, molestan a canales vecinos)",
  [El ruido de fase de un oscilador consiste en:],
  ([pequeñas fluctuaciones aleatorias de la fase, que extienden ruido a ambos lados de la portadora], [una deriva lenta de la frecuencia a medida que varía la temperatura ambiente], [armónicos de la frecuencia fundamental presentes en su salida], [un zumbido procedente de la red eléctrica que modula en amplitud la portadora],),
  sol: [El ruido de fase son pequeñas fluctuaciones aleatorias de la fase (y por tanto de la frecuencia) del oscilador. En el espectro aparecen como «faldones» de ruido a ambos lados de la portadora, en lugar de una raya limpia. No son armónicos, que caen en múltiplos de la frecuencia. Tampoco es la deriva térmica, que es lenta y sistemática, ni el zumbido de red, que es una modulación de amplitud. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_])
#pq(1, 1, 15, "d", "F-T4.4", "Frecuencia imagen: defecto del receptor superheterodino, situada a 2·FI de la sintonizada",
  [Un receptor superheterodino con una FI de 9 MHz está sintonizado en 7,1 MHz, con el oscilador local por encima de la señal. La frecuencia imagen es:],
  ([14,2 MHz], [16,1 MHz], [23,2 MHz], [25,1 MHz],),
  sol: [El oscilador local está en $f_"OL" = 7,1 + 9 = 16,1$ MHz. La imagen queda al otro lado del oscilador, a una FI de él: $f_"im" = f_"OL" + f_"FI" = 16,1 + 9 = 25,1$ MHz, que equivale a $f_s + 2 f_"FI" = 7,1 + 18$. Esa frecuencia también produce 9 MHz al mezclarse con el oscilador, por lo que hay que rechazarla antes del mezclador, con el preselector. Los 16,1 MHz son el oscilador local; los 23,2 MHz, la suma de señal y oscilador; y los 14,2 MHz, el doble de la señal. #vease[(Véase tema T4, sección «Arquitectura del receptor».)]])
#pq(1, 1, 16, "c", "T4.3", "Conversión directa: el OL a la frecuencia de la señal y el mezclador da directamente audio, sin FI",
  [Un receptor de conversión directa se caracteriza por:],
  ([emplear dos frecuencias intermedias independientes], [carecer de oscilador local], [mezclar directamente la señal recibida para obtener la señal de audio], [amplificar la señal sin demodularla],),
  sol: [El receptor de conversión directa mezcla la señal con un oscilador a (casi) la misma frecuencia y obtiene el audio directamente, sin FI. No tiene la imagen de RF del superheterodino, pero sí una imagen de audio: las frecuencias simétricas respecto al oscilador (la otra banda lateral) dan el mismo audio.])
#pq(1, 1, 17, "c", "F-T5.13", "FM indirecta: modulador de fase tras un oscilador a cristal (ventaja: estabilidad)",
  [La ventaja de la FM indirecta (modulador de fase) es que:],
  ([permite grandes desviaciones sin necesidad de multiplicadores de frecuencia], [ocupa menos anchura de banda que la FM directa con la misma desviación], [la frecuencia de la portadora la fija un oscilador a cristal muy estable], [suprime la portadora y ahorra potencia en el transmisor],),
  sol: [En la FM indirecta la portadora sale de un oscilador a cristal, muy estable, y solo se modula su fase a continuación: no hay que desviar el cristal directamente. La contrapartida es que el modulador de fase da desviaciones pequeñas y obliga a usar multiplicadores (a). La anchura de banda la fijan la desviación y el audio (regla de Carson), igual en ambas (b). Suprimir la portadora (d) es propio de la SSB, no de la FM. #vease[(Véase tema T1, sección «Señales moduladas».)]])
#pq(1, 1, 18, "c", "", "Límite de espurias: vale el más restrictivo entre la atenuación y el tope absoluto",
  [Un transmisor de HF entrega 100 W de potencia media. Cada emisión no esencial puede tener, como máximo, una potencia de:],
  ([1 mW], [50 mW], [10 mW], [100 mW],),
  sol: [Por debajo de 30 MHz hay que quedar 40 dB por debajo de la potencia media sin superar 50 mW, y vale el más restrictivo. 40 dB por debajo de 100 W son $100 dot 10^(-4) = 0,01$ W, es decir, 10 mW, menos que el tope de 50 mW: mandan los 10 mW. El tope de 50 mW solo manda por encima de 500 W.])
#pq(1, 1, 19, "a", "T5.29", "Manipulación brusca en CW: chasquidos que ensanchan la emisión",
  [Una manipulación demasiado brusca en una emisión de telegrafía produce:],
  ([chasquidos de manipulación que ensanchan la emisión], [un aumento del rendimiento del transmisor], [la desaparición de la portadora], [una reducción de la velocidad de transmisión],),
  sol: [Cortar y restablecer la portadora de golpe equivale a un escalón, y un escalón contiene frecuencias muy altas: son los _key clicks_, que se oyen a ambos lados de la frecuencia. Por eso los equipos redondean los flancos de la manipulación.])
#pq(1, 1, 20, "d", "T6.34", "La ganancia se expresa en dB respecto de una antena de referencia (dBi o dBd)",
  [La ganancia de una antena se expresa normalmente en:],
  ([ohmios de impedancia], [metros de longitud de onda], [vatios radiados], [decibelios respecto de una antena de referencia (dBi o dBd)],),
  sol: [La ganancia es siempre una comparación, nunca una cantidad absoluta: dBi si se compara con el radiador isótropo teórico y dBd si se compara con un dipolo de media onda. Entre ambas escalas hay 2,15 dB de diferencia — el dipolo ya gana eso sobre el isótropo—, así que una misma antena tiene dos cifras según cómo se exprese.])
#pq(1, 1, 21, "b", "T6.10", "La ROE indica el grado de adaptación de impedancias",
  [El parámetro ROE de una estación transmisora es un indicador de:],
  ([la potencia máxima que soporta la antena], [el grado de adaptación de impedancias entre el transmisor y la antena], [la ganancia de la antena], [la altura efectiva de la antena],),
  sol: [La ROE mide el grado de adaptación de impedancias entre transmisor, línea y antena.])
#pq(1, 1, 22, "a", "T6.25", "Relé T-R: al transmitir desconecta y protege la entrada del receptor",
  [Durante la transmisión, el relé de transmisión-recepción de un transceptor:],
  ([desconecta la entrada del receptor y la protege de la potencia emitida], [conecta el receptor en paralelo con la antena], [conmuta la polarización de la antena], [aumenta la ganancia de la etapa de entrada del receptor],),
  sol: [La primera etapa del receptor está diseñada para microvoltios; los vatios del propio transmisor la destruirían. Por eso el relé la desconecta —y normalmente la pone a masa— mientras se transmite.])
#pq(1, 1, 23, "b", "T7.23", "La ionosfera depende de la actividad solar y de ella dependen las condiciones en HF",
  [La región de la atmósfera cuyo estado varía con la actividad solar y de la que dependen las condiciones de propagación en HF es:],
  ([la estratosfera], [la ionosfera], [la troposfera], [la mesosfera],),
  sol: [Es la radiación solar la que ioniza esas capas altas, de modo que el ciclo solar de once años, las fulguraciones y el día y la noche cambian por completo las condiciones en HF. La troposfera influye en VHF y UHF, pero no en la reflexión ionosférica.])
#pq(1, 1, 24, "d", "F-T7.4", "Esporádica-E: más frecuente en verano",
  [En el hemisferio norte, la esporádica-E en VHF es más frecuente en:],
  ([los meses de invierno, con las noches más largas], [primavera y otoño, en los equinoccios], [todas las estaciones por igual], [los meses de verano],),
  sol: [La esporádica-E tiene una marcada estacionalidad. En el hemisferio norte su temporada principal es el verano (de mayo a agosto, con máximo hacia junio–julio), y existe un pico secundario y mucho más débil hacia diciembre–enero. Por eso en verano se abre con frecuencia la banda de 50 MHz y, a veces, la de 144 MHz. No es una cuestión de equinoccios (eso es más propio de la capa F2) ni es uniforme a lo largo del año. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]])
#pq(1, 1, 25, "c", "T8.27", "El medidor de ROE compara la onda incidente y la reflejada: mide la desadaptación",
  [Un medidor de relación de ondas estacionarias indica:],
  ([la potencia media entregada por el transmisor], [la frecuencia de resonancia de la antena], [la relación entre la señal incidente en la antena y la reflejada por ella], [la ganancia de la antena en decibelios],),
  sol: [De ese cociente sale la ROE: con adaptación perfecta no hay reflejada y la ROE vale 1. No mide potencia absoluta ni ganancia, aunque muchos instrumentos incorporen además una escala de vatios.])
#pq(1, 1, 26, "d", "C-T8.4", "Medidor de campo: intensidad de campo radiado, en V/m",
  [Para realizar medidas de intensidad de campo radiado por una antena se emplea:],
  ([un acoplador de antenas], [un frecuencímetro], [un medidor de ondas estacionarias], [un medidor de campo],),
  sol: [
    La intensidad del campo radiado (en V/m o dBμV/m) se mide con un medidor de campo, un receptor
    calibrado con su antena de medida. El medidor de ondas estacionarias compara la potencia directa
    y la reflejada en la línea y mide la desadaptación de la antena; el frecuencímetro mide
    frecuencia; el acoplador de antenas adapta impedancias y no mide nada. #vease[(Véase tema T8,
    sección «Instrumentos».)]
  ])
#pq(1, 1, 27, "b", "T9.7", "Filtro de red (de línea de desacoplo) en la alimentación",
  [Para evitar que un transceptor introduzca señales de radiofrecuencia en la red de suministro eléctrico se emplea:],
  ([un transformador elevador], [un filtro de línea de desacoplo], [un diodo zéner], [un atenuador de antena],),
  sol: [El filtro de línea bloquea la RF que el equipo inyectaría en la red eléctrica.])
#pq(1, 1, 28, "c", "T9.16", "Filtro de rechazo de banda (notch) para eliminar una frecuencia concreta",
  [Un filtro de rechazo de banda (filtro «notch») se emplea para:],
  ([amplificar selectivamente la señal deseada], [dejar pasar por igual todas las frecuencias], [eliminar una frecuencia o una banda estrecha concreta que interfiere], [ensanchar la banda de paso del receptor],),
  sol: [Hace justo lo contrario que el paso banda: en lugar de dejar pasar una banda, la suprime. Es lo que permite quitar de en medio una portadora molesta o un tono concreto sin tocar el resto de la señal.])
#pq(1, 1, 29, "c", "T10.11", "El diferencial protege a las personas frente a contactos indirectos y defectos de aislamiento",
  [El dispositivo que proporciona protección frente a los defectos de aislamiento y los contactos indirectos se denomina:],
  ([limitador de sobretensiones], [fusible], [interruptor diferencial], [magnetotérmico],),
  sol: [Fusible y magnetotérmico vigilan la _intensidad_ y protegen la instalación; el diferencial vigila el _desequilibrio_ y protege a las personas. Es la distinción que más se pregunta.])
#pq(1, 1, 30, "c", "C-T10.6", "La pica de tierra se entierra en terreno húmedo, no seco y soleado",
  [En relación a las tomas de tierra, una de las siguientes expresiones NO es correcta. ¿Cuál?],
  ([Nunca se deben hacer sobre cables coaxiales.], [No debemos emplear las instalaciones de gas ni de calefacción.], [Deben hacerse en sitios donde dé el sol, para así evitar los efectos perniciosos de la humedad.], [No debemos valernos de las conducciones de agua para hacerlas.],),
  sol: [
    La falsa es la c: la toma de tierra se entierra en terreno húmedo, porque la humedad reduce la
    resistencia del terreno y mejora la derivación de corrientes; un suelo seco y soleado la
    empeora. Las demás son ciertas: no se aprovechan las instalaciones de gas ni de calefacción ni
    las tuberías de agua como toma de tierra (peligro de tensión en otras partes de la instalación
    y, en el gas, de chispa y explosión), ni se hace la tierra sobre un cable coaxial, cuya malla es
    la vía de retorno de la señal de RF y no un electrodo. #vease[(Véase tema T10, introducción
    (puesta a tierra).)]
    #no-esta[La toma de tierra es un electrodo (pica, placa o cable enterrado) que pone a potencial de tierra
    los chasis de los equipos, y debe tener muy poca resistencia: por eso se entierra en terreno
    húmedo y profundo, no en suelo seco. Los reglamentos de baja tensión prohíben usar como tierra
    las canalizaciones de agua, gas o calefacción: una chispa puede inflamar el gas, la tensión de
    fuga llegaría a otras personas y los tramos de plástico cortan la continuidad. Tampoco vale el
    coaxial. Lo correcto es una pica propia o la tierra del edificio, si está en buen estado.]
  ])
#fin-prueba()
#prueba(1, 2)
#pq(1, 2, 1, "b", "C-R1.2", "Deletreo de distintivo EA5SWJ: E Echo, A Alfa, S Sierra, W Whiskey, J Juliett (no «Japón»), cifra en inglés",
  [El deletreo del indicativo EA5SWJ de acuerdo con el alfabeto fonético internacional sería:],
  ([Echo Alfa Cinco Sierra Whiskey Juliet.], [Echo Alfa Five Sierra Whiskey Juliett.], [Echo Alfa Five Sierra Whiskey Japón.], [Echo América Five Sierra Whiskey Juliet.],),
  sol: [E = Echo, A = Alfa, 5 = Five, S = Sierra, W = Whiskey, J = Juliett: la b es la única formada solo por palabras del alfabeto internacional, con la cifra en inglés. La a da la cifra en español (Cinco); la c sustituye Juliett por «Japón», que no pertenece al alfabeto; la d dice «América» para la A, que es Alfa. Recuerda la grafía oficial: Alfa, con f, y Juliett, con doble t. #vease[(Véase tema R1, tabla del alfabeto y nota sobre las cifras.)]])
#pq(1, 2, 2, "a", "C-R2.5", "QRG frecuencia exacta frente a QRH su frecuencia varía",
  [La abreviatura del código Q «QRG» tiene el significado de:],
  ([Su frecuencia exacta es… kHz], [Cese la transmisión], [Aumente la potencia], [Estoy ocupado. No interfiera],),
  sol: [QRG es la frecuencia exacta: «su frecuencia exacta es… kHz» y, con interrogación, «¿cuál es la frecuencia exacta de mi emisión?» (QRG?). Los distractores son otros grupos: «cese la transmisión» es QRT, «aumente la potencia» es QRO y «estoy ocupado, no interfiera» es QRL. Tampoco es QSY (cambie de frecuencia), QSB (las señales se desvanecen) ni QTR (la hora). #vease[(Véase tema R2, tabla «Grupos del código Q más frecuentes».)]])
#pq(1, 2, 3, "a", "R2.17", "QTC tengo mensajes para transmitir",
  [El grupo `QTC` se emplea para indicar:],
  ([que se tienen mensajes para transmitir], [el emplazamiento de la estación], [que se cesa la transmisión], [la potencia con que se transmite],),
  sol: [«¿Cuántos mensajes tiene para transmitir?» o «tengo $n$ mensajes». Cesar la transmisión es `QRT` y el emplazamiento, `QTH`.])
#pq(1, 2, 4, "d", "R2.25", "QRW avise a… de que le llamo en… kHz",
  [El grupo `QRW` se emplea para:],
  ([preguntar por la posición de la estación], [indicar que se va a permanecer a la escucha], [pedir que se aumente la velocidad de manipulación], [avisar a una tercera estación de que se la llama en una frecuencia],),
  sol: [«¿Quiere avisar a … de que le llamo en … kHz?». Se usa cuando no se consigue contacto directo y hay una estación intermedia que sí oye a las dos.])
#pq(1, 2, 5, "c", "R3.4", "DX contacto de larga distancia",
  [La abreviatura `DX` designa:],
  ([un duplexor de antena], [una emisión digital experimental], [un contacto de larga distancia], [una estación desatendida],),
  sol: [`DX`: contacto de larga distancia.])
#pq(1, 2, 6, "a", "R3.25", "RIG equipo, ANT antena, PWR potencia",
  [La abreviatura `RIG` se refiere a:],
  ([el equipo de radio de la estación], [el indicativo de la estación], [la ganancia de la antena], [la relación de ondas estacionarias],),
  sol: [Es la jerga habitual para el transceptor y, por extensión, para el conjunto de la estación: «mi `RIG` es un…» es de las frases más repetidas en un contacto.])
#pq(1, 2, 7, "d", "C-R3.7", "Trabajar en split: emitir en una frecuencia y recibir en otra",
  [¿Qué significa que una estación DX trabaja en «Split»?],
  ([Que utiliza una modalidad digital moderna llamada «Split».], [Que emite en doble banda lateral única.], [Que está operando en un país lejano y de categoría especial.], [Que emite en una frecuencia, pero recibe en otra diferente.],),
  sol: [Trabajar en #emph[split] es transmitir en una frecuencia y escuchar en otra. Lo hace la estación DX cuando tiene una avalancha de llamadas (#emph[pile-up]): si escuchara en su propia frecuencia de emisión, las llamadas se pisarían y no distinguiría a nadie. Anuncia, por ejemplo, «escucho arriba 5 kHz» y cada corresponsal llama en un punto distinto de la banda. Las demás opciones mezclan conceptos ajenos: «#emph[split]» no es un país, ni una modalidad digital, ni una clase de emisión con bandas laterales.

    #no-esta[#emph[Split]: modo de operación con frecuencia de transmisión distinta de la de recepción. Se usa sobre todo en DX y concursos para repartir las llamadas de un #emph[pile-up] (muchas estaciones llamando a la vez a una sola). El DX indica dónde escucha («#emph[up 5]» es 5 kHz por encima de su frecuencia de emisión) y tú ajustas el transceptor con los dos VFO: recibes en la frecuencia del DX y transmites en la de escucha. Es una técnica operativa, no una modalidad de emisión ni una categoría de estación.]])
#pq(1, 2, 8, "a", "R4.13", "Peligro grave e inminente: se puede usar cualquier medio y frecuencia",
  [En caso de peligro grave e inminente, una estación de aficionado:],
  ([puede emplear cualquier medio y frecuencia a su alcance para pedir auxilio], [debe limitarse a la banda de 20 metros], [debe esperar autorización expresa de la Administración], [solo puede emitir en las frecuencias de su autorización],),
  sol: [Es una excepción reconocida por el Reglamento de Radiocomunicaciones: ante un peligro grave e inminente, la vida humana está por encima de los límites de la autorización. Fuera de ese supuesto, las frecuencias asignadas son las que son.])
#pq(1, 2, 9, "c", "F-R4.10", "Segmento exclusivo de satélites en 2 m: 145,806–146,000 MHz",
  [En la banda de 2 m, el segmento que el plan de bandas de la IARU para la Región 1 reserva en exclusiva a los satélites es:],
  ([144,150 a 144,400 MHz], [145,575 a 145,7935 MHz], [145,806 a 146,000 MHz], [144,400 a 144,490 MHz],),
  sol: [El plan de la IARU para la Región 1 marca 145,806–146,000 MHz como «satélite, exclusivo»: es el último tramo de la banda de 2 m. 144,400–144,490 MHz es exclusivo de balizas; 145,575–145,7935 MHz, de salidas de repetidores; y 144,150–144,400 MHz, de SSB, telegrafía y modos digitales de señal débil. Hay otros tramos pequeños de comunicación espacial, pero solo el último es exclusivo de satélites. #vease[(Véase tema R6, introducción del capítulo (reparto de cada banda en segmentos por modos, frecuencias de llamada).)] #no-esta[En 2 m, el plan de bandas de la IARU para la Región 1 reparte así la parte alta: salidas de repetidores, 145,575–145,7935 MHz; comunicación espacial, 145,794–145,806 MHz; y satélites en exclusiva, 145,806–146,000 MHz, hasta el final de la banda. Las balizas ocupan 144,400–144,490 MHz, y en 144,000–144,025 MHz solo se admite enlace descendente de satélite.]])
#pq(1, 2, 10, "b", "R7.8", "Cuándo identificarse: al comienzo y al final de cada emisión, siempre, y en las largas al menos cada 10 min",
  [La transmisión del distintivo de llamada propio se efectuará:],
  ([solo cuando otro operador lo requiera], [al comienzo y al final de cada emisión y, en emisiones largas, a intervalos cortos], [una vez al día como máximo], [solo al solicitar la autorización],),
  sol: [El distintivo se transmite al comienzo y al final de cada emisión y a intervalos cortos si es larga (art. 25 del Reglamento de Radiocomunicaciones); la Orden concreta el intervalo: al menos cada diez minutos (art. 29).])
#pq(1, 2, 11, "c", "F-R5.5", "Licencia CEPT en telefonía: entre el prefijo y el distintivo se dice «stroke»",
  [Un titular de licencia CEPT que transmite en telefonía desde el país visitado emite su distintivo nacional precedido del prefijo de ese país. Entre el prefijo y el distintivo se pronuncia la palabra:],
  ([«portable»], [«móvil»], [_stroke_], [«cambio»],),
  sol: [La Recomendación T/R 61-01 (apéndice I, punto 2.3) dice que el distintivo nacional va precedido del prefijo del país visitado y que ambos se separan con el carácter «/» en telegrafía o con la palabra _stroke_ en telefonía. Así, #_apc2-m[EA/M0BVM] se dice EA _stroke_ M0BVM, deletreando cada carácter. «Portable» y «móvil» no separan nada: en telefonía se añaden al final del distintivo de las estaciones portables y móviles (art. 29.2 de la Orden). «Cambio» se dice al ceder la palabra, no separa el distintivo. #vease[(Véase tema R5, introducción del capítulo (prefijo, distrito y sufijo).)] #no-esta[Con la licencia CEPT (T/R 61-01), el visitante emite su distintivo nacional precedido del prefijo del país visitado; en España, #_apc2-m[EA] y, opcionalmente, la cifra del distrito (art. 14.e de la Orden). En telegrafía se separan con «/» (#_apc2-m[EA/M0BVM]); en telefonía, el «/» se pronuncia _stroke_. No lo confundas con «portable» o «móvil», que se añaden al final del distintivo.]])
#pq(1, 2, 12, "a", "R5.22", "Mudarse de distrito: se conserva el distintivo (único e inmodificable); solo se comunica el domicilio",
  [Un radioaficionado con distintivo del distrito 5 se traslada a vivir a una provincia del distrito 4. Conforme a la Orden IET/1311/2013:],
  ([conserva su distintivo, que es único y no puede modificarse, y solo debe comunicar a la SETSI su nuevo domicilio], [debe renunciar a su autorización y pedir otra en el nuevo distrito], [pierde su distintivo y tiene que solicitar otro nuevo], [debe sustituir la cifra de su distintivo por la 4],),
  sol: [Desde la Orden IET/1311/2013 el distintivo asociado a la autorización «será único y no podrá ser modificado» (art. 28); su cifra es la del distrito de residencia «en el momento del otorgamiento» (art. 27.2), y mudarse solo obliga a comunicar el nuevo domicilio a la SETSI (art. 7.3). Si se emite en móvil o portable desde otro distrito, puede añadirse opcionalmente el número de ese distrito (art. 29.2). Los bancos de preguntas antiguos dan como correcta la regla de la Orden ITC/1791/2006 y de sus Instrucciones de 2006 (derogadas): «no podrá mantener su distintivo si su nueva provincia de residencia pertenece a un distrito distinto». Si en el examen aparece con esa formulación, esa es la opción que dan por buena.])
#pq(1, 2, 13, "b", "C-R5.19", "Sufijos excluidos: DDD, PAN, SOS, TTT, XXX y la serie QAA–QZZ",
  [¿Se puede asignar el sufijo PAN a un distintivo de llamada de una estación de aficionado?],
  ([No, solamente a los distintivos de estaciones colectivas], [No se puede asignar en ningún caso], [Se puede asignar a cualquier estación], [No, solamente a los distintivos de estaciones automáticas desatendidas],),
  sol: [El artículo 27 de la Orden IET/1311/2013 excluye de la asignación de sufijos los grupos que expresan señales de socorro, urgencia y seguridad: DDD, PAN, SOS, TTT y XXX. PAN es la señal de urgencia en fonía, así que no se asigna a ningún distintivo, sea de la estación que sea. Nota: el enunciado original hablaba de la «clase A» y ofrecía las clases B y C, propias del régimen anterior; hoy esas clases no existen y la respuesta no cambia.

    #no-esta[Art. 27 de la Orden IET/1311/2013: los sufijos se asignan por orden alfabético, saltándose los grupos que expresan señales de socorro, urgencia y seguridad —DDD, PAN, SOS, TTT y XXX— y toda la serie QAA–QZZ. PAN es la señal de urgencia en fonía («PAN PAN»). Esos grupos no se adjudican a nadie.]])
#pq(1, 2, 14, "d", "R6.11", "Composición de las Regiones: 1 Europa y África; 2 América; 3 resto de Asia y Oceanía",
  [La Región 3 de la UIT está formada principalmente por:],
  ([África y Oriente Medio], [Europa oriental], [América del Sur], [Asia meridional y oriental junto con Oceanía],),
  sol: [Incluye Japón, China, la India, el sureste asiático, Australia y Nueva Zelanda. África y Oriente Medio quedan en la Región 1.])
#pq(1, 2, 15, "b", "F-R6.9", "Frecuencia de llamada de FM en 2 m: 145,500 MHz",
  [La frecuencia de llamada de FM en la banda de 2 m del plan de bandas de la IARU para la Región 1 es:],
  ([144,300 MHz], [145,500 MHz], [145,800 MHz], [146,000 MHz],),
  sol: [El plan de 2 m marca 145,500 MHz como «FM calling», en el segmento de FM y voz digital que va de 145,206 a 145,5625 MHz. Se llama allí y, al contestar, se pasa a otra frecuencia libre para el QSO. Los 144,300 MHz son el centro de actividad de SSB. Los 145,800 MHz caen en el segmento de comunicación espacial (145,794– 145,806 MHz), junto al de satélites. Los 146,000 MHz son el límite superior de la banda, no una frecuencia de llamada. #vease[(Véase tema R6, introducción del capítulo (frecuencias de llamada).)] #no-esta[Una frecuencia de llamada es un punto de encuentro: se llama allí (#_apc2-m[CQ]) y, al contestar, se pasa a otra frecuencia libre para el QSO. En 2 m, el plan de la IARU para la Región 1 fija 145,500 MHz como frecuencia de llamada de FM, en el segmento de FM y voz digital 145,206–145,5625 MHz; el centro de actividad de SSB es 144,300 MHz.]])
#pq(1, 2, 16, "a", "R7.6", "Decir «cambio» es recomendable, no obligatorio",
  [Utilizar la palabra «cambio» al finalizar cada transmisión en fonía es:],
  ([recomendable], [obligatorio por el Reglamento de Radiocomunicaciones], [exclusivo de las comunicaciones de emergencia], [una falta de procedimiento],),
  sol: [Decir «cambio» al ceder la palabra es recomendable como buena práctica, no una obligación.])
#pq(1, 2, 17, "d", "F-R8.66", "Desatendida terminada: se aplica el procedimiento de la licencia de estación fija (art. 20)",
  [Según el art. 26 de la Orden IET/1311/2013, finalizada la instalación de una estación automática desatendida será de aplicación el procedimiento establecido para:],
  ([el reconocimiento de la condición de asociación de radioaficionados (art. 18.7)], [el otorgamiento de la autorización de radioaficionado (arts. 5 a 7)], [la autorización especial de uso experimental (art. 17)], [la expedición de la licencia de estación fija (art. 20)],),
  sol: [Art. 26, segundo párrafo: terminada la instalación se aplica el procedimiento del art. 20, el de expedición de la licencia de estación fija. El interesado comunica a la Jefatura Provincial, en seis semanas, que ha terminado, justificando que la responsabilidad está cubierta con el seguro; la Jefatura dispone de un máximo de 30 días para verificar la idoneidad y expedir la licencia, que habilita a emitir. Las otras opciones son trámites distintos: la autorización personal, la experimental y el reconocimiento de la asociación, que ya debe tenerse para pedir la instalación. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 26, segundo párrafo, de la Orden IET/1311/2013: terminada la instalación de una estación automática desatendida se sigue el procedimiento del art. 20, el de la licencia de estación fija. El interesado comunica a la Jefatura Provincial, en seis semanas, que ha finalizado, justificando que la responsabilidad está cubierta con el seguro y aportando, en su caso, el boletín de instalación. La Jefatura dispone de 30 días para verificar la idoneidad y expedir la licencia, que habilita a empezar las emisiones.]])
#pq(1, 2, 18, "b", "F-R8.82", "Tolerancia de frecuencia: desviación entre la frecuencia asignada y el centro de la banda ocupada",
  [Según el Anexo I de la Orden IET/1311/2013, la tolerancia de frecuencia es la desviación máxima admisible entre la frecuencia asignada y:],
  ([la frecuencia de resonancia del último circuito sintonizado del transmisor], [la frecuencia situada en el centro de la banda ocupada por la emisión], [la frecuencia del límite inferior de la banda ocupada por la emisión], [la frecuencia del armónico más intenso de la emisión],),
  sol: [El Anexo I define la tolerancia de frecuencia como la desviación máxima admisible entre la frecuencia asignada (el valor nominal de la portadora sin modular o de la frecuencia de emisión) y la situada en el centro de la banda ocupada por la emisión. Se expresa en partes por millón o en hertzios. Ejemplo: ±10 ppm sobre 14 MHz son $14 times 10^6 times 10 times 10^(-6) = 140$ Hz. El límite inferior de la banda, el armónico más intenso y la resonancia del último circuito no son la referencia. #_apc3-ver[(Véase tema T5, sección «Etapas y definiciones» (junto a la pregunta sobre la anchura de banda necesaria).)]

#_apc3-net[Anexo I de la Orden IET/1311/2013: la frecuencia asignada es el valor nominal de la frecuencia portadora (sin modular) o de la frecuencia de emisión. La tolerancia de frecuencia es la desviación máxima admisible entre la frecuencia asignada y la situada en el centro de la banda de frecuencias ocupada por la emisión; se expresa en partes por millón (ppm) o en hertzios. Por ejemplo, ±10 ppm en 14 MHz equivalen a ±140 Hz.]])
#pq(1, 2, 19, "c", "C-R8.32", "Licencia CEPT: habilita temporalmente en los países T/R 61-01; no se concede «a través del HAREC»",
  [En relación con la licencia CEPT, señale la alternativa falsa:],
  ([Habilita a su titular a operar su estación de radioaficionado en el territorio de aquellos países que hayan adoptado la Recomendación CEPT T/R 61-01.], [La utilización a que habilita es de forma temporal.], [Se concede a través del certificado HAREC.], [En ella ha de constar, entre otros datos, el distintivo de llamada y su período de validez.],),
  sol: [Se pide la afirmación falsa. La a es el art. 11 de la Orden IET/1311/2013: la licencia CEPT habilita para operar en los países que han adoptado la T/R 61-01. La b es cierta: esa recomendación regula el uso #emph[temporal] de la estación en estancias en otro país (art. 13). La d es el art. 12: deben constar el distintivo de llamada y el período de validez. La falsa es la c: el HAREC es el certificado del #emph[examen] armonizado (T/R 61-02); solo permite solicitar la autorización, y la licencia CEPT la expide la Administración (la autorización española ya tiene esa consideración, art. 11). El banco da por falsa la b, pero contradice el art. 13: se corrige a la c. #vease[(Véase tema R8, introducción (recuadro sobre T/R 61-01 y T/R 61-02) y sección «Usos especiales y casos particulares».)]

    #no-esta[La licencia CEPT es la expedida por un país que ha adoptado la T/R 61-01; las autorizaciones españolas tienen esa consideración (art. 11 de la Orden IET/1311/2013). Según el art. 12 debe constar: la declaración que autoriza a usar la estación en cualquier país que aplique la recomendación, nombre y dirección del titular, distintivo de llamada, período de validez y autoridad que la expide. No se confunde con el HAREC (T/R 61-02): certificado que se obtiene al aprobar el examen y que permite solicitar la autorización (art. 10.3).]

    #_apb2-clave[«La utilización a que habilita es de forma temporal.». Es la clave que dan las recopilaciones de exámenes reales (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea la técnicamente correcta.]])
#pq(1, 2, 20, "d", "F-R8.32", "Licencia CEPT de otro país en España: equiparada, solo para no residentes en estancias temporales",
  [La licencia CEPT expedida por otro país que haya adoptado la Recomendación T/R 61-01 se equipara a la autorización española de radioaficionado y surte efectos:],
  ([para cualquier extranjero, residente o no, sin límite de tiempo], [solo para extranjeros procedentes de países de la Unión Europea], [para extranjeros residentes en España, siempre que además posean el certificado HAREC], [exclusivamente para extranjeros no residentes en España, durante sus estancias temporales],),
  sol: [El art. 13 equipara la licencia CEPT de otro país (T/R 61-01) a la autorización española, pero «exclusivamente» para extranjeros no residentes en territorio español y durante sus estancias temporales. Quien fija su residencia en España ya no puede amparar su actividad en la licencia CEPT: necesita la autorización española, que obtiene examinándose o, sin examen, con un HAREC o por convenio de reciprocidad (art. 5.2). No hay restricción por nacionalidad europea (b), ni vale sin límite de tiempo (a), y el HAREC del residente (c) es otra vía distinta. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Art. 13 de la Orden IET/1311/2013: la licencia CEPT expedida por un país extranjero que haya adoptado la T/R 61-01 equivale a la autorización española de radioaficionado, pero surte efectos exclusivamente para extranjeros no residentes en territorio español y durante sus estancias temporales. Quien se instala en España como residente ya no puede basarse en ella: necesita la autorización española, que obtiene superando la prueba o, sin examen, con un certificado HAREC o por convenio de reciprocidad (art. 5.2).]])
#pq(1, 2, 21, "c", "R8.73", "Ninguna estación tiene derecho preferente sobre una frecuencia",
  [Ninguna estación de aficionado puede reclamar el uso exclusivo de una frecuencia. Ello significa que:],
  ([quien llega primero conserva la frecuencia todo el día], [los concursos tienen prioridad sobre el resto del tráfico], [ninguna estación tiene derecho preferente sobre una frecuencia concreta], [las frecuencias se reservan por escrito ante la Administración],),
  sol: [El espectro es dominio público y su uso, compartido: nadie «posee» una frecuencia, ni por llegar antes ni por estar en concurso. De ahí que la única regla practicable sea la cortesía — preguntar si está ocupada y apartarse si lo está.])
#pq(1, 2, 22, "b", "F-R8.26", "Equipo de construcción propia: presentación optativa en la Jefatura con memoria (diagrama de bloques, esquemas)",
  [La presentación de un equipo de construcción propia en la Jefatura Provincial de Inspección de Telecomunicaciones, junto con su memoria descriptiva, es:],
  ([obligatoria antes de su primer uso: sin ella no puede utilizarse], [optativa: si supera las pruebas, el equipo recibe una autorización individual acreditativa de su correcto funcionamiento], [obligatoria únicamente para los transmisores de más de 100 W], [imposible: en la Jefatura solo se presentan equipos comerciales],),
  sol: [El art. 5.6 permite usar equipos de construcción propia sin autorización previa de la SETSI, bajo la responsabilidad del aficionado. Presentarlos en la Jefatura con una memoria es solo optativo: si superan las pruebas de comprobación de las características del anexo I, reciben una autorización individual acreditativa de su correcto funcionamiento. Por eso no es obligatoria antes del primer uso (a) ni según la potencia (c), y tampoco es imposible (d): la norma prevé expresamente esa presentación. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Art. 5.6 de la Orden IET/1311/2013: los equipos total o parcialmente de construcción propia se usan sin autorización previa de la SETSI, bajo la responsabilidad del radioaficionado, y deben cumplir las características técnicas del anexo I. Optativamente pueden presentarse en la Jefatura Provincial de Inspección de Telecomunicaciones con una memoria descriptiva; los que superen las pruebas reciben una autorización individual acreditativa de su correcto funcionamiento. Ese trámite no es obligatorio.]])
#pq(1, 2, 23, "c", "C-R8.41", "Estación fija: precisa licencia, asociada a la autorización de radioaficionado de su titular",
  [La instalación y funcionamiento de una estación fija de aficionado precisará de una licencia, la cual se considerará asociada a:],
  ([Una asociación legalizada de radioaficionados de la provincia correspondiente.], [La estación automática desatendida más cercana.], [La autorización de radioaficionado de su titular.], [Toda la gama de frecuencias que pueda utilizar.],),
  sol: [Es casi literal el art. 18.1 de la Orden IET/1311/2013: la instalación y el funcionamiento de cualquier estación fija precisan una licencia, que se considera asociada a la autorización de radioaficionado de su titular (y una misma licencia puede amparar varios equipos de la estación). De ahí que la licencia se cancele si la autorización se revoca o se extingue (art. 21). La a es falsa: no hace falta pertenecer a ninguna asociación; la b y la d no tienen sentido, porque la licencia no se liga a un repetidor ni a una gama de frecuencias. Ojo: hoy la licencia de estación solo se exige a las estaciones fijas, no a las móviles o portátiles. #vease[(Véase tema R8, sección «Autorización y licencia de estación».)]

    #no-esta[Art. 18.1 de la Orden IET/1311/2013: la instalación y funcionamiento de cualquier estación fija precisa una licencia, asociada a la autorización de radioaficionado de su titular; una misma licencia puede amparar los diferentes equipos de la estación. Art. 21: la licencia se cancela a petición del titular, por revocación o extinción de la autorización a la que está asociada, o automáticamente si no se mantiene el seguro de antenas; al cancelarla hay que desmontar las instalaciones, antenas incluidas.]])
#pq(1, 2, 24, "a", "F-R8.19", "Derechos del predio sirviente (art. 545 CC): la comunidad decide por mayoría simple",
  [Según la Ley 19/1983, los derechos que el artículo 545 del Código Civil reconoce al dueño del predio sirviente se ejercen, en su caso, por la comunidad de propietarios, bastando que la decisión se adopte por:],
  ([mayoría simple], [mayoría de tres quintos], [unanimidad de los propietarios], [mayoría de dos tercios],),
  sol: [El art. 2 de la Ley 19/1983, en su último párrafo, dice que los derechos del art. 545, párrafo 2, del Código Civil se ejercen, en su caso, por la comunidad de propietarios, «bastando que la decisión se adopte por mayoría simple». Esos derechos son los del dueño del predio sirviente: variar, a su costa, el lugar o la forma de la servidumbre cuando le resulte muy incómoda, ofreciendo otro igualmente cómodo. La ley no exige unanimidad ni mayorías reforzadas (tres quintos, dos tercios). El Real Decreto 2623/1986 (art. 9) remite al mismo art. 545 para los cambios de emplazamiento que promueva la propiedad. #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[Según el art. 2 de la Ley 19/1983, los derechos que el art. 545, párrafo 2, del Código Civil reconoce al dueño del predio sirviente se ejercen, en su caso, por la comunidad de propietarios, bastando mayoría simple. Esos derechos son variar, a su costa, el lugar o la forma de la servidumbre cuando le resulte muy incómoda o le impida hacer obras, reparos o mejoras importantes, ofreciendo otro igualmente cómodo y sin perjuicio para el titular. El Real Decreto 2623/1986 (art. 9) remite al art. 545 para los cambios de emplazamiento que promueva la propiedad.]])
#pq(1, 2, 25, "d", "R8.74", "Obras en el inmueble: aviso al titular con 1 mes de antelación",
  [Salvo casos de urgencia, la propiedad del inmueble que necesite el desmontaje de una antena autorizada para ejecutar obras debe requerirlo al titular con una antelación mínima de:],
  ([quince días], [una semana], [seis meses], [un mes],),
  sol: [Un mes de preaviso, salvo urgencia. El plazo existe para que el titular pueda organizar el desmontaje sin que la obra quede paralizada ni la instalación se retire de cualquier manera.])
#pq(1, 2, 26, "d", "F-R8.50", "Estatutos de la asociación reconocida: fines propios de la radioafición y obligación de cumplir el Reglamento",
  [Según el artículo 18.7 de la Orden IET/1311/2013, los estatutos de una asociación que solicita ser reconocida como asociación de radioaficionados deben contemplar:],
  ([la obligación de que todos los socios sean titulares de una autorización de radioaficionado], [un número mínimo de socios y una cuota anual mínima], [la gestión de al menos un repetidor en su provincia], [como finalidades específicas las propias de los radioaficionados y la obligación de cumplir lo dispuesto en el Reglamento],),
  sol: [El art. 18.7 exige dos cosas a los estatutos: que contemplen como finalidades específicas las propias de los radioaficionados y que recojan la obligación de cumplir lo dispuesto en el Reglamento (la Orden IET/1311/2013). No exige que todos los socios tengan autorización (a), ni un mínimo de socios o de cuota (b), ni gestionar repetidores (c). Instalar estaciones colectivas es una consecuencia del reconocimiento (art. 18.6), no un requisito para obtenerlo. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 18.7 de la Orden IET/1311/2013: para ser reconocida, la asociación debe estar legalmente constituida y registrada en el Ministerio del Interior y solicitar el reconocimiento a la SETSI con sus estatutos. Estos deben contemplar como finalidades específicas las propias de los radioaficionados y recoger la obligación de cumplir lo dispuesto en el Reglamento. El reconocimiento se concede por resolución de la SETSI.]])
#pq(1, 2, 27, "b", "C-R8.22", "Estación automática desatendida: estación colectiva que no requiere intervención directa del operador",
  [¿Definiría «Estación automática desatendida» como?:],
  ([Estación de mediciones de potencia.], [Estación colectiva de aficionado, que para su funcionamiento habitual no requiere la intervención directa del operador.], [Estación de emisiones no deseadas.], [Estación repetidora de poco uso.],),
  sol: [Es la definición literal del Anexo I de la Orden IET/1311/2013: estación colectiva de radioaficionado que, para su funcionamiento habitual, no requiere la intervención directa del operador (repetidores, radiobalizas…). Las otras opciones son inventadas: no tiene nada que ver con las emisiones no deseadas ni con medir potencia, y un repetidor sigue siéndolo aunque se use poco: lo que define a la estación es que funciona sin operador, no cuánto se use. Ojo al matiz: toda estación desatendida es colectiva, pero no toda estación colectiva es desatendida. #vease[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

    #no-esta[Anexo I de la Orden IET/1311/2013: #emph[estación colectiva] es la estación de radioaficionado cuya titularidad corresponde a una asociación de radioaficionados reconocida; #emph[estación automática desatendida] es una estación colectiva que para su funcionamiento habitual no requiere la intervención directa del operador. Según el art. 24, son desatendidas los repetidores analógicos y digitales, los repetidores de portadora o nodo, los repetidores finales y las radiobalizas. Solo las asociaciones reconocidas pueden instalarlas (art. 18.6), y por eso se consideran colectivas (art. 18.4).]])
#pq(1, 2, 28, "c", "F-R9.8", "Muy grave: la producción deliberada de interferencias",
  [La producción deliberada de interferencias a redes o servicios autorizados constituye, según la Ley 11/2022:],
  ([una infracción leve], [una infracción grave], [una infracción muy grave], [una infracción solo cuando la Administración ya ha requerido el cese],),
  sol: [El art. 106.7 tipifica como infracción muy grave la producción deliberada de interferencias a redes o servicios autorizados. La mera producción de interferencias, sin deliberación, es grave (art. 107.6): la diferencia está en la intención. No hace falta requerimiento previo para que haya infracción; no atender después el requerimiento de cese es otra infracción muy grave distinta (art. 106.8). «Leve» infravalora ambas conductas, y «solo tras el requerimiento» contradice el texto de la ley. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador» (tabla de grados de infracción).)]

#_apc3-net[Art. 106.7 de la Ley 11/2022: es infracción muy grave la producción deliberada, en España o en los países vecinos, de interferencias a redes o servicios autorizados. La mera producción de interferencias, sin deliberación, es infracción grave (art. 107.6), y no atender el requerimiento de cese de la Secretaría de Estado es de nuevo muy grave (art. 106.8).]])
#pq(1, 2, 29, "a", "R9.3", "Grave: negativa u obstrucción a la inspección",
  [También constituye infracción GRAVE según la Ley General de Telecomunicaciones:],
  ([la negativa o la obstrucción a ser inspeccionado y la no colaboración con la inspección], [transmitir observaciones de carácter personal], [usar potencia inferior a la autorizada], [cambiar de frecuencia sin anunciarlo],),
  sol: [Negarse u obstruir la inspección, o no colaborar con ella: también grave.])
#pq(1, 2, 30, "d", "R9.19", "El expediente se tramita por la LGT y el procedimiento administrativo común",
  [El expediente sancionador en materia de telecomunicaciones se tramita con arreglo a:],
  ([las recomendaciones de la CEPT], [los planes de banda de la IARU], [los estatutos de la asociación de radioaficionados], [la Ley General de Telecomunicaciones y la legislación de procedimiento administrativo común],),
  sol: [La Ley sectorial tipifica y gradúa; el procedimiento administrativo común aporta las garantías — audiencia, prueba, plazos— comunes a cualquier expediente. Recomendaciones de la CEPT y planes de la IARU no son normas sancionadoras.])
#fin-prueba()
#soluciones-simulacro(1)

// ======================================================================
#simulacro(2)
#prueba(2, 1)
#pq(2, 1, 1, "c", "T1.20", "Conversión entre valores de pico, pico a pico y eficaz de una sinusoide (V_ef = V_p / √2)",
  [El valor eficaz de una tensión sinusoidal cuyo valor máximo es 100 V es aproximadamente:],
  ([50 V], [63,7 V], [70,7 V], [100 V],),
  sol: [$V_"ef" = V_"máx" slash sqrt(2) approx 70,7$ V. El distractor de 63,7 V es el valor medio de la semionda ($2 V_"máx" slash pi$) — el examen juega a intercambiarlas.])
#pq(2, 1, 2, "d", "F-T1.17", "Regla de Carson: B ≈ 2 (Δf + f_m)",
  [Un transmisor de FM con una desviación máxima de 5 kHz se modula con un tono de 3 kHz. Según la regla de Carson, la anchura de banda que ocupa es aproximadamente de:],
  ([6 kHz], [8 kHz], [10 kHz], [16 kHz],),
  sol: [Regla de Carson: $B approx 2(Delta f + f_m)$. Con $Delta f = 5$ kHz y $f_m = 3$ kHz: $B approx 2 (5 + 3) = 16$ kHz (el índice de modulación es $m = Delta f slash f_m approx 1,7$). Los 6 kHz son $2 f_m$, lo que ocuparía una AM con ese tono. Los 8 kHz olvidan el factor 2, pues la señal se extiende a ambos lados de la portadora. Los 10 kHz son $2 Delta f$ y se olvidan de la frecuencia moduladora. _(Véase tema T1, sección «Señales moduladas».)_])
#pq(2, 1, 3, "c", "F-T1.38", "En una cadena, las ganancias y pérdidas en dB se suman y restan",
  [A un amplificador de 10 dB de ganancia se aplican 2 W y su salida pasa por un atenuador de 6 dB. La potencia final es aproximadamente de:],
  ([20 W], [8 W], [5 W], [0,5 W],),
  sol: [Balance neto: +10 − 6 = +4 dB. Como +10 dB multiplican la potencia por 10 y −6 dB la dividen entre 4, $P = 2 dot 10 slash 4 = 5$ W (con la fórmula, $2 dot 10^(0,4) approx 5$ W). Los 20 W ignoran el atenuador; los 0,5 W, el amplificador (2/4); y los 8 W toman los +4 dB como si fueran ×4, cuando equivalen a multiplicar por unos 2,5. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_])
#pq(2, 1, 4, "b", "F-T1.43", "Aliasing: las frecuencias por encima de f_s/2 se confunden con otras más bajas",
  [Si una señal se muestrea a una frecuencia inferior al doble de su frecuencia máxima, se produce:],
  ([un ruido de cuantificación mayor, que desaparece empleando más bits por muestra], [aliasing: las componentes de frecuencia alta se confunden con otras más bajas y ya no pueden distinguirse de ellas], [la pérdida de las componentes más altas, que simplemente se cortan sin afectar al resto de la señal], [una distorsión que elimina después el filtro de reconstrucción],),
  sol: [Con $f_s < 2 f_"máx"$ faltan muestras para fijar las componentes más altas: los mismos puntos encajan en una sinusoide de frecuencia más baja, y esas componentes aparecen «disfrazadas» de bajas (_aliasing_), mezcladas con la señal útil. Ya no hay forma de separarlas, ni con más bits de cuantificación (a) ni con el filtro de reconstrucción (d), que actúa después del D/A. Tampoco se cortan limpiamente (c): se pliegan sobre la banda. Se previene con un filtro antisolapamiento antes del A/D. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_])
#pq(2, 1, 5, "a", "T2.5", "Termistores: PTC sube y NTC baja su resistencia al aumentar la temperatura",
  [Un termistor de tipo NTC es una resistencia cuyo valor:],
  ([se reduce a medida que la temperatura aumenta], [depende de la tensión aplicada], [aumenta al aumentar la temperatura], [depende de la luz que recibe],),
  sol: [NTC (_negative temperature coefficient_): la resistencia se reduce al aumentar la temperatura. Se usan como sensores de temperatura y limitadores de arranque.])
#pq(2, 1, 6, "a", "", "Constante de tiempo τ = RC: 63 % de la carga en un τ, carga completa en unos 5τ",
  [Un condensador descargado se conecta a una fuente de continua a través de una resistencia. Al cabo de un tiempo igual a la constante de tiempo $tau = R C$, la tensión del condensador ha alcanzado aproximadamente:],
  ([el 63 % de la tensión de la fuente], [el 50 % de la tensión de la fuente], [el 37 % de la tensión de la fuente], [el 100 % de la tensión de la fuente],),
  sol: [La carga sigue la exponencial $v(t) = V (1 - e^(-t slash tau))$: en un $tau$ llega al 63 % y se da por completa hacia $5 tau$. El 37 % es lo que todavía le falta, y el 100 % no se alcanza en un solo $tau$.])
#pq(2, 1, 7, "d", "T2.33", "LED: emite luz polarizado en directa",
  [Un diodo LED emite luz cuando:],
  ([alcanza su tensión de avalancha], [se le aplica corriente alterna de alta frecuencia], [se polariza inversamente], [se polariza directamente],),
  sol: [El LED es un diodo y, como tal, solo conduce en directa; es al circular esa corriente cuando emite. El que trabaja polarizado en inversa, en su tensión de avalancha, es el zéner.])
#pq(2, 1, 8, "d", "C-T2.9", "Electrodos de la válvula diodo (cátodo y placa) y del tríodo (+ rejilla)",
  [Una válvula diodo está compuesta por:],
  ([Placa, rejilla y cátodo], [Cátodo], [Rejilla y cátodo], [Placa y cátodo],),
  sol: [
    El diodo de vacío tiene solo dos electrodos: el cátodo, que caliente emite electrones, y la
    placa (ánodo), que los recoge cuando está a tensión positiva. Con eso basta para rectificar,
    porque la corriente solo circula del cátodo a la placa (el filamento de caldeo es aparte y no
    cuenta como electrodo). Un cátodo solo (b) no forma circuito alguno. La rejilla es lo que
    caracteriza a las válvulas amplificadoras: cátodo, rejilla y placa forman el tríodo (a), y una
    rejilla sin placa (c) no recoge corriente. #vease[(Véase tema T2, sección «Válvulas
    termoiónicas».)]
  ])
#pq(2, 1, 9, "c", "T3.28", "Asociación de condensadores: en paralelo se suman; en serie, por inversas (al revés que las resistencias)",
  [Tres condensadores conectados en paralelo suman 400 pF. Si dos de ellos son de 100 pF, el tercero tiene una capacidad de:],
  ([400 pF], [100 pF], [200 pF], [300 pF],),
  sol: [En paralelo las capacidades se suman: $C_3 = 400 - 100 - 100 = 200$ pF. Ojo con el reflejo de aplicar la fórmula de las resistencias en paralelo: en los condensadores es al revés.])
#pq(2, 1, 10, "b", "T3.31", "Media onda frente a onda completa: la completa aprovecha los dos semiciclos, dobla el valor medio y da menos rizado",
  [Un rectificador de onda completa, comparado con uno de media onda:],
  ([entrega una tensión continua de menor valor medio], [aprovecha los dos semiciclos y produce menos rizado], [necesita siempre el doble de tensión de entrada], [solo puede emplearse con corriente continua],),
  sol: [Al aprovechar los dos semiciclos, el valor medio se dobla ($2 V_p slash pi$ frente a $V_p slash pi$) y la frecuencia del rizado también (100 Hz en lugar de 50 Hz en una red de 50 Hz), de modo que el mismo condensador lo filtra mucho mejor.])
#pq(2, 1, 11, "a", "T3.32", "Regulador: mantiene constante la tensión de salida aunque varíen la carga y la red",
  [La misión del regulador de una fuente de alimentación es:],
  ([mantener constante la tensión de salida aunque varíen la carga y la red], [transformar la corriente alterna en continua], [aumentar la frecuencia de la corriente rectificada], [elevar la tensión de la red],),
  sol: [Es la última etapa y la que da la calidad final: absorbe tanto las variaciones de la tensión de red como los tirones de consumo del equipo — muy notables en un transceptor que pasa de recepción a transmisión.])
#pq(2, 1, 12, "c", "C-T3.8", "Amplificar sin distorsión: trabajar en la parte lineal de la característica",
  [Cuando en un amplificador a transistor sea necesario reproducir la señal de entrada sin
distorsión, se debe funcionar:],
  ([Con amplificación clase C], [Eliminando la resistencia de carga], [En la parte lineal de su característica], [Con polarizaciones muy altas],),
  sol: [
    La característica de transferencia de un transistor (corriente de salida frente a tensión de
    entrada) solo es una recta en un tramo. Si se polariza en el centro de ese tramo y la señal no
    lo abandona, la salida es una copia ampliada de la entrada: sin distorsión. Con polarizaciones
    muy altas el transistor se satura y recorta la señal; la clase C conduce menos de medio ciclo y
    deforma la señal (se reserva para CW y FM); y quitar la resistencia de carga no tiene sentido,
    pues sin ella no hay salida aprovechable. #vease[(Véase tema T2, sección «Semiconductores y
    otros componentes» (punto de trabajo); tema T3, sección «Clases de amplificación y
    detectores».)]
  ])
#pq(2, 1, 13, "d", "C-T3.14", "PLL: estabiliza un VCO enganchándolo a una referencia; la tensión de error corrige el VCO",
  [Los circuitos con «lazo enganchado de fase»:],
  ([Tienen un cuarzo por canal], [Sirven para estabilizar la frecuencia de un oscilador a cristal], [Tienen un único cuarzo], [Sirven para estabilizar la frecuencia de un oscilador controlado por tensión],),
  sol: [
    El lazo enganchado de fase (#emph[PLL]) compara la fase del oscilador controlado por tensión
    (VCO) con la de una referencia y, con la tensión de error, corrige el VCO hasta engancharlo: el
    VCO hereda la estabilidad de la referencia. No sirve para estabilizar un oscilador a cristal,
    que ya es estable (es precisamente la referencia). Ni «un único cuarzo» ni «un cuarzo por canal»
    definen al lazo: un sintetizador PLL suele usar un solo cristal de referencia y cambia de canal
    variando el divisor, pero eso es un detalle del montaje, y el PLL también se emplea sin cristal,
    por ejemplo para demodular FM. #vease[(Véase tema T3, sección «Filtros, osciladores y
    mezcladores».)]
  ])
#pq(2, 1, 14, "b", "T4.5", "Selectividad: separar señales próximas en frecuencia (curva más estrecha = más selectivo)",
  [La selectividad de un receptor es su capacidad de:],
  ([mantener la frecuencia sintonizada], [separar dos señales muy próximas en frecuencia], [amplificar señales muy débiles], [eliminar el ruido atmosférico],),
  sol: [Selectividad: separar señales muy próximas en frecuencia; la fija la curva de los filtros de FI.])
#pq(2, 1, 15, "a", "T4.35", "Anchura de banda de la NBFM: unos 12 kHz (FM de difusión 200 kHz, SSB 2,4 kHz)",
  [La anchura de banda típica de una emisión de FM de banda estrecha (NBFM), como la empleada en VHF, es del orden de:],
  ([12 kHz], [2,4 kHz], [200 kHz], [6 MHz],),
  sol: [Frente a los 200 kHz de la FM de radiodifusión, la FM de banda estrecha del servicio de aficionados ocupa unos 12 kHz, con una desviación de unos 5 kHz. Los 2,4 kHz corresponden a un canal de SSB.])
#pq(2, 1, 16, "d", "T4.17", "El margen dinámico lo determina el primer mezclador",
  [El margen dinámico de un receptor queda determinado fundamentalmente en:],
  ([el filtro de red], [el amplificador de audio], [el altavoz], [el primer mezclador de entrada],),
  sol: [El margen dinámico — la capacidad de tratar a la vez señales muy fuertes y muy débiles sin distorsión — lo limita sobre todo el primer mezclador de entrada.])
#pq(2, 1, 17, "c", "T5.9", "Espurias por debajo de 30 MHz: 40 dB bajo la potencia media, sin exceder de 50 mW",
  [Para frecuencias inferiores a 30 MHz, las emisiones no esenciales (espurias) de un transmisor de aficionado deben estar atenuadas al menos:],
  ([10 dB por debajo de la potencia media, sin exceder de 1 W], [20 dB por debajo de la potencia media, sin exceder de 500 mW], [40 dB por debajo de la potencia media, sin exceder de 50 mW], [60 dB por debajo de la potencia media, sin exceder de 1 mW],),
  sol: [Límite del Anexo I, 4.1.1 de la Orden IET/1311/2013 para $f < 30$ MHz: espurias al menos 40 dB por debajo de la potencia media sin exceder de 50 mW. Por encima de 30 MHz los límites son otros y dependen de la potencia (la figura del libro).])
#pq(2, 1, 18, "a", "F-T5.6", "Repetidor: recibe en una frecuencia y retransmite a la vez en otra",
  [Un repetidor de VHF/UHF es una estación que:],
  ([recibe una señal en una frecuencia y la retransmite a la vez en otra], [emite de forma automática y continua solo su distintivo, para estudiar la propagación], [permite que dos estaciones se comuniquen directamente, sin equipo intermedio], [convierte la señal recibida a otra clase de emisión, por ejemplo de FM a SSB],),
  sol: [Según la Orden IET/1311/2013 (Anexo I, apartado 1), una estación repetidora retransmite automáticamente las emisiones que recibe, con el fin de ampliar el alcance de las comunicaciones. En VHF y UHF lo hace recibiendo en una frecuencia y emitiendo a la vez en otra (en 2 m, la entrada queda 600 kHz por debajo de la salida). La baliza (b) solo emite su distintivo; la comunicación directa sin intermediario (c) es lo contrario de un repetidor; y el cambio de clase de emisión (d) no es su función. #vease[(Véase tema T5, sección «Etapas y definiciones».)]])
#pq(2, 1, 19, "d", "T6.3", "Para bajar la frecuencia de resonancia hay que alargar la antena (29,9 → 28,5 MHz)",
  [Para que una antena que resuena en 29 900 kHz pase a resonar en 28 500 kHz, deberemos:],
  ([girarla 90 grados], [alimentarla en un extremo], [acortarla], [alargarla],),
  sol: [Frecuencia menor $arrow.r.double$ $lambda$ mayor $arrow.r.double$ antena más larga: para bajar de 29,9 a 28,5 MHz hay que alargar.])
#pq(2, 1, 20, "a", "T6.9", "Ancho de haz: entre los puntos de media potencia (−3 dB)",
  [El ancho de haz del diagrama de radiación de una antena es la separación angular entre los dos puntos en los que la potencia radiada:],
  ([es la mitad de la máxima (−3 dB)], [se anula por completo], [es el doble de la media], [iguala a la potencia reflejada],),
  sol: [El ancho de haz se mide entre los puntos de media potencia (−3 dB) del lóbulo principal.])
#pq(2, 1, 21, "b", "C-T6.3", "Margen de la ROE: siempre ≥ 1; funcionamiento adecuado entre 1 y 2,5",
  [La relación de ondas estacionarias para un adecuado funcionamiento debe ser:],
  ([Mayor que 2,5], [Entre 2,5 y 1], [Entre 1 y 0,5], [Menor que 0,5],),
  sol: [
    La ROE es el cociente entre el máximo y el mínimo de la onda estacionaria y, como el máximo
    nunca es menor que el mínimo, vale siempre 1 o más: los intervalos de c y d no existen. El valor
    ideal es 1 (nada se refleja). Hasta 2 o 2,5 la desadaptación es tolerable: con ROE 2,5,
    $ρ = 1,5 slash 3,5 ≈ 0,43$ y se refleja $ρ^2 ≈ 18$ % de la potencia. Por encima de 2,5 (a)
    crecen las pérdidas en la línea y el riesgo para el transmisor. #vease[(Véase tema T6, sección
    «Líneas de transmisión y adaptación».)]
    #no-esta[Margen útil de la ROE: por definición ROE ≥ 1 (1 es la adaptación perfecta; no tiene límite
    superior). En la práctica se considera buena por debajo de 1,5, aceptable hasta 2 y todavía
    utilizable hasta 2,5 o 3: con 2,5 se refleja el 18 % de la potencia. Más allá conviene ajustar
    la antena o usar un acoplador, porque suben las pérdidas en la línea y muchos equipos reducen la
    potencia para protegerse.]
  ])
#pq(2, 1, 22, "c", "T6.15", "Acoplador de antena: adapta la impedancia del final a la línea y la antena (no mejora la antena)",
  [El acoplador de antena se emplea para:],
  ([aumentar la ganancia de la antena], [filtrar el ruido atmosférico], [adaptar la impedancia de la etapa final a la línea de transmisión y la antena], [amplificar la señal recibida],),
  sol: [El acoplador transforma la impedancia que ve el final de potencia para adaptarla a la línea y la antena; no mejora la antena, mejora la transferencia.])
#pq(2, 1, 23, "b", "F-T7.14", "Horizonte radioeléctrico: d ≈ 4,12 (√h1 + √h2) km",
  [Dos estaciones de VHF, con las antenas a 9 m y a 16 m de altura sobre terreno llano, alcanzan por onda directa una distancia máxima aproximada de:],
  ([21 km], [29 km], [49 km], [103 km],),
  sol: [El horizonte radioeléctrico suma el de cada antena: $d approx 4,12 (sqrt(h_1) + sqrt(h_2)) = 4,12 (sqrt(9) + sqrt(16)) = 4,12 times (3 + 4) approx 29$ km. Los errores típicos son meter la raíz sobre la suma, $4,12 sqrt(25) approx 21$ km; sobre el producto, $4,12 sqrt(9 dot 16) approx 49$ km, o no sacar raíces, $4,12 times 25 approx 103$ km. Se suman las raíces de las alturas, no las alturas. #vease[(Véase tema T7, sección «La ionosfera y la onda de espacio».)]])
#pq(2, 1, 24, "b", "F-T7.2", "Esporádica-E: nubes de ionización intensa en la capa E que reflejan VHF",
  [La propagación por esporádica-E se debe a:],
  ([las estelas ionizadas que dejan los meteoros], [nubes de ionización muy intensa que aparecen en la capa E], [inversiones de temperatura en la troposfera, que forman un conducto], [la reflexión de las ondas en la superficie de la Luna],),
  sol: [La esporádica-E (_Es_) aparece cuando se forman, de modo irregular, nubes de ionización intensa en la capa E, a unos 100 km de altura. Esas nubes reflejan señales de VHF (sobre todo 50 MHz y, a veces, 144 MHz) que normalmente atravesarían la ionosfera. La inversión de temperatura produce conductos troposféricos, la reflexión lunar es el EME y las estelas de los meteoros dan el meteor-scatter: son otros mecanismos, cada uno con su propia física. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]])
#pq(2, 1, 25, "c", "F-T7.5", "Reflexión auroral: en las cortinas ionizadas de las auroras",
  [La reflexión auroral se produce en:],
  ([las capas de aire cálido de la troposfera], [las estelas de los meteoros], [las cortinas de ionización de las auroras], [la superficie de la Luna],),
  sol: [Las auroras boreales son zonas de la alta atmósfera, hacia los 100 km de altura y en latitudes altas, ionizadas con intensidad por partículas procedentes del Sol. Esas cortinas ionizadas reflejan las ondas de VHF como un espejo irregular y cambiante. La Luna es el reflector del EME, las capas de aire cálido forman conductos por inversión térmica y las estelas de los meteoros dan el meteor-scatter: ninguno tiene que ver con las auroras. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]])
#pq(2, 1, 26, "d", "T8.3", "Conversión entre vatios y dBm (1 mW = 0 dBm; 1 W = 30 dBm)",
  [A una potencia de 1000 mW le corresponde un nivel de:],
  ([10 dBm], [3 dBm], [20 dBm], [30 dBm],),
  sol: [$10 log_10 (1000 "mW" slash 1 "mW") = 30$ dBm. Referencias: 1 mW = 0 dBm; 1 W = 30 dBm; 100 W = 50 dBm.])
#pq(2, 1, 27, "a", "T8.25", "Potencia reflejada apreciable en el vatímetro direccional = desadaptación transmisor-antena",
  [Un vatímetro direccional intercalado entre transmisor y antena indica una potencia reflejada apreciable. Ello significa que:],
  ([el transmisor no está adaptado a la antena], [el transmisor entrega más potencia de la nominal], [la antena tiene una ganancia muy elevada], [el instrumento está averiado],),
  sol: [Toda potencia que vuelve es potencia que la antena no ha aceptado: la reflejada mide la desadaptación entre lo que el transmisor ve y lo que la antena presenta. Con adaptación perfecta la lectura de reflejada sería nula.])
#pq(2, 1, 28, "b", "T9.19", "A más potencia, más riesgo de interferencia: usar la mínima potencia necesaria",
  [Para reducir al mínimo el riesgo de causar interferencias, un radioaficionado debe:],
  ([emplear siempre la potencia máxima autorizada], [utilizar la mínima potencia necesaria para el enlace], [transmitir preferentemente en horas nocturnas], [prescindir del filtro de salida del transmisor],),
  sol: [Es además una obligación reglamentaria, no solo una buena práctica: se debe emplear la potencia mínima necesaria para mantener la comunicación. Menos potencia significa menos campo en el entorno y menos nivel en cada emisión no deseada.])
#pq(2, 1, 29, "c", "T10.26", "El conductor de tierra no lleva fusible ni interruptor",
  [El conductor que une la estación con la toma de tierra:],
  ([debe ser del mismo color que el conductor de fase], [debe llevar un fusible de protección], [no debe llevar fusible ni interruptor alguno], [debe llevar un interruptor para poder aislarlo],),
  sol: [El conductor de tierra tiene que estar disponible siempre y sin excepción. Un fusible o un interruptor en él lo dejaría abierto justo cuando más falta hace, dejando los chasis en tensión sin que nada corte.])
#pq(2, 1, 30, "a", "T10.30", "Antena en mástil propio, no en el de la antena colectiva",
  [La antena de la estación de aficionado debe fijarse:],
  ([a un mástil propio, independiente del de la antena colectiva del edificio], [al mismo mástil de la antena colectiva de televisión del edificio], [directamente a la barandilla de la terraza], [a la chimenea, por ser el punto más alto],),
  sol: [Compartir mástil con la antena colectiva del edificio es fuente segura de conflictos e interferencias, y además implica manipular una instalación que no es propia. La antena de aficionado va en su propio soporte.])
#fin-prueba()
#prueba(2, 2)
#pq(2, 2, 1, "c", "C-R1.1", "Deletreo de distintivo AN6BL: N November (no «Noviembre»), B Bravo, L Lima, 6 Six",
  [El deletreo del distintivo AN6BL según el alfabeto fonético internacional:],
  ([Alfa, Noviembre, Seis, Bravo, Lima.], [A, Ene, Seis, B, Ele.], [Alfa, November, Six, Bravo, Lima.], [El deletreo de distintivos no está permitido.],),
  sol: [Cada letra se deletrea con su palabra internacional (A = Alfa, N = November, B = Bravo, L = Lima) y la cifra con su nombre inglés: 6 = Six. La a pone en español «Noviembre» y «Seis», que no pertenecen al alfabeto internacional; la b usa los nombres españoles de las letras (Ene, Ele) en lugar de palabras de deletreo. La d es falsa: deletrear el distintivo es lo normal, y el propio temario oficial incluye el alfabeto fonético para deletrear letras y cifras. Aunque al hablar se oigan cifras en español, el deletreo internacional las da en inglés. #vease[(Véase tema R1, tabla del alfabeto y nota sobre las cifras.)]])
#pq(2, 2, 2, "a", "R2.27", "QTH posición o localidad (frente a QTR, QRA, QTC)",
  [El grupo del código Q con el que una estación comunica su posición o localidad es:],
  ([`QTH`], [`QTC`], [`QTR`], [`QRA`],),
  sol: [`QTH` es el emplazamiento. `QTR` es la hora, `QRA` el nombre de la estación y `QTC` los mensajes pendientes: los cuatro se confunden con facilidad porque todos «informan» de algo.])
#pq(2, 2, 3, "a", "C-R2.4", "QRA nombre de la estación (no la posición)",
  [La abreviatura QRA indica:],
  ([¿Cómo se llama su estación?], [¿Transmito más despacio?], [¿Qué frecuencia utiliza Vd.?], [¿Está Vd. ocupado?],),
  sol: [QRA se refiere al nombre de la estación: «¿cómo se llama su estación?» o «el nombre de mi estación es…». No es la posición (eso es QTH). Los distractores son otros grupos en forma de pregunta: la frecuencia es QRG, «¿está ocupado?» es QRL y «¿transmito más despacio?» es QRS. #vease[(Véase tema R2, tabla «Grupos del código Q más frecuentes».)]])
#pq(2, 2, 4, "c", "R3.14", "SK fin del contacto",
  [La abreviatura de procedimiento `SK` indica:],
  ([que se transmite en banda lateral], [que se solicita una tarjeta de confirmación], [el final del contacto entre las dos estaciones], [que la señal se recibe con interferencias],),
  sol: [Cierra la comunicación: ya no se espera respuesta. Si además se apaga la estación, se añade `CL`.])
#pq(2, 2, 5, "a", "R3.2", "CL cierre de la estación",
  [Entre las abreviaturas más usuales se encuentra `CL`, que significa:],
  ([cierre de la estación], [canal libre], [llamada local], [cambio de banda lateral],),
  sol: [`CL` (_closing_): cierre de la estación.])
#pq(2, 2, 6, "b", "R3.27", "OP operador",
  [La abreviatura `OP` se refiere a:],
  ([la potencia de salida], [el operador de la estación], [la frecuencia de operación], [la opción de modo],),
  sol: [De _operator_: la persona que está a los mandos, que no siempre coincide con el titular de la estación. Se usa para presentarse: «`OP` Alberto».])
#pq(2, 2, 7, "b", "R3.28", "HR aquí y ES y",
  [La abreviatura `HR` significa:],
  ([horizontal], [aquí], [hora], [he recibido],),
  sol: [Contracción de _here_: «aquí», referido al lugar desde donde se transmite. Aparece constantemente en expresiones como «`WX HR VY GUD`».])
#pq(2, 2, 8, "b", "C-R4.2", "SOS se transmite como un solo signo (sin separar las letras)",
  [La señal radiotelegráfica de socorro consiste en:],
  ([La palabra «Mayday»], [La abreviatura «SOS» transmitida como un solo signo], [La palabra «HELP»], [La abreviatura «S.O.S.» transmitida separando las tres letras],),
  sol: [La señal radiotelegráfica de socorro es el grupo SOS, que en Morse son tres puntos, tres rayas y tres puntos enviados seguidos, sin pausa entre letras: una sola señal, con las rayas algo alargadas para distinguirlas de los puntos. Por eso es correcta la b. La clave publicada en el banco marca la d, pero separar las tres letras contradice la norma internacional: en ese caso ya no sería el signo de socorro. «Mayday» es la señal radiotelefónica y «help» no es una señal reglamentaria. #vease[(Véase tema R4, tabla «Señales internacionales de socorro, urgencia y seguridad».)]

    #no-esta[El cuaderno dice que la señal de socorro en telegrafía es SOS, pero falta el detalle de cómo se envía. Según el Reglamento de Radiocomunicaciones de la UIT, es un único signo Morse: tres puntos, tres rayas y tres puntos transmitidos seguidos, sin los espacios que separarían las letras S, O y S, y con las rayas ligeramente alargadas para distinguirlas de los puntos. No son las siglas de ninguna frase: es solo una secuencia fácil de reconocer.]

    #_apb2-clave[«La abreviatura S.O.S. transmitida separando las tres letras». Es la clave que dan las recopilaciones de exámenes reales (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea la técnicamente correcta.]])
#pq(2, 2, 9, "a", "R4.6", "Seguridad en radiotelegrafía: TTT tres veces",
  [La abreviatura `TTT`, transmitida tres veces consecutivas, constituye la señal de:],
  ([seguridad], [urgencia], [socorro], [alarma],),
  sol: [`TTT` tres veces: seguridad telegráfica, equivalente a #_r4-sc("Sécurité").])
#pq(2, 2, 10, "c", "F-R4.7", "Banda de 10 m: 28–29,7 MHz",
  [La banda de aficionados de 10 m (28 MHz) comprende, en España, las frecuencias:],
  ([27 a 28 MHz], [28 a 30 MHz], [28 a 29,7 MHz], [29,7 a 30 MHz],),
  sol: [El CNAF atribuye en España a los servicios de aficionados y de aficionados por satélite la banda de 28 a 29,7 MHz. «28 a 30 MHz» se pasa 0,3 MHz por arriba: de 29,7 a 30,005 MHz las atribuciones son de los servicios fijo y móvil. «29,7 a 30 MHz» es justo el tramo siguiente a la banda, fuera de ella. «27 a 28 MHz» queda por debajo: entre 27,5 y 28 MHz las atribuciones son ayudas a la meteorología, fijo y móvil. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)] #no-esta[La banda de 10 m (28 MHz) ocupa en España de 28 a 29,7 MHz, atribuida a aficionados y a aficionados por satélite. Por debajo, 27,5–28 MHz son de ayudas a la meteorología, fijo y móvil; por encima, 29,7–30,005 MHz son de fijo y móvil. Otras bandas de HF: 80 m, 3500–3800 kHz; 40 m, 7000–7200 kHz; 20 m, 14000–14350 kHz; 15 m, 21000– 21450 kHz.]])
#pq(2, 2, 11, "d", "F-R5.4", "Sufijos de cuatro o más letras: excepcionales, para usos temporales en eventos de relevancia especial",
  [La Orden IET/1311/2013 admite, con carácter excepcional, sufijos de cuatro o más letras:],
  ([para las estaciones automáticas desatendidas de aficionado, analógicas o digitales], [para los radioaficionados con más de veinticinco años de antigüedad en la autorización], [con carácter permanente, para participar en concursos internacionales de alta competitividad], [para usos temporales ligados a eventos o conmemoraciones de relevancia especial],),
  sol: [El art. 27.3, en su último párrafo, dice que podrán autorizarse, con carácter excepcional, sufijos de cuatro o más letras para usos temporales relacionados con eventos o conmemoraciones de relevancia especial. La regla general son sufijos de hasta tres letras. La a falla: las desatendidas usan sufijos de tres letras que empiezan por Y (analógicas) o Z (digitales). La b inventa un privilegio por antigüedad: los sufijos de una y dos letras son los que exigen antigüedad y práctica internacional. La c confunde con el sufijo de una letra, reservado a concursos internacionales de alta competitividad. #vease[(Véase tema R5, sección «Sufijos y usos temporales».)] #no-esta[La Orden fija como regla general sufijos de hasta tres letras (art. 27.3). Como excepción, podrán autorizarse sufijos de cuatro o más letras, siempre con carácter excepcional y para usos temporales relacionados con eventos o conmemoraciones de relevancia especial. No deben confundirse con los sufijos de una y dos letras, que son escasos y se adjudican por méritos a titulares veteranos.]])
#pq(2, 2, 12, "d", "R5.14", "Prefijos EG y EH: concursos, eventos internacionales y eventos relevantes locales, regionales o autonómicos",
  [El prefijo `EG` de un distintivo de llamada se relaciona con:],
  ([las estaciones colectivas de asociaciones], [las radiobalizas de HF], [las estaciones móviles marítimas], [usos temporales de especial relevancia para eventos de carácter regional, autonómico o local],),
  sol: [EG: usos temporales para concursos, eventos internacionales y otros eventos relevantes de ámbito local, regional o autonómico (art. 27.1.b).])
#pq(2, 2, 13, "d", "R5.38", "Prefijo AO: eventos relevantes de ámbito internacional",
  [El prefijo AO se otorga para eventos temporales:],
  ([de ámbito estrictamente local], [de carácter deportivo], [organizados por las asociaciones], [especiales de relevancia internacional],),
  sol: [Los prefijos especiales se escalonan según la importancia del evento (`ED`/`EE`/`EF`, `EG`/`EH`, `AM`/`AN`) y `AO` queda para los de relevancia internacional (art. 27.1.d). Es un distintivo temporal: termina cuando termina el acontecimiento que lo motivó.])
#pq(2, 2, 14, "d", "R6.12", "Por qué hay Regiones: atribuir bandas por zonas; por eso las bandas difieren entre España y EE. UU.",
  [Que una banda de aficionado tenga límites distintos en España y en Estados Unidos se debe a que:],
  ([los planes de banda de la IARU son obligatorios en unos países y no en otros], [las bandas dependen de la potencia autorizada en cada país], [cada país fija libremente sus bandas sin coordinación], [pertenecen a regiones distintas de la UIT, con atribuciones diferentes],),
  sol: [España está en la Región 1 y Estados Unidos en la 2, y el Cuadro de atribuciones de la UIT asigna las bandas región por región. El caso más citado es el de 40 metros, con extensión distinta a uno y otro lado del Atlántico.])
#pq(2, 2, 15, "a", "F-R6.11", "Frecuencia de llamada de FM en 70 cm: 433,500 MHz",
  [En la banda de 70 cm, la frecuencia de llamada de FM del plan de bandas de la IARU para la Región 1 es:],
  ([433,500 MHz], [434,500 MHz], [432,200 MHz], [430,000 MHz],),
  sol: [El plan de 70 cm sitúa la llamada de FM en 433,500 MHz, en el segmento de FM y voz digital 433,400–433,575 MHz, de canales simplex. Los 432,200 MHz son el centro de actividad de SSB. Los 430,000 MHz son el extremo inferior de la banda, no una frecuencia de llamada. Los 434,500 MHz caen en los canales de comunicaciones digitales 434,450–434,575 MHz. #no-esta[En 70 cm (430–440 MHz) el plan de la IARU para la Región 1 fija 433,500 MHz como frecuencia de llamada de FM y 432,200 MHz como centro de actividad de SSB (segmento 432,100–432,400 MHz). Las balizas están en exclusiva en 432,400–432,490 MHz, la entrada de un sistema de repetidores de FM en 433,000–433,375 MHz y los satélites en 435–438 MHz.]])
#pq(2, 2, 16, "d", "R7.9", "Mensajes de terceros: no permitidos con carácter general (salvo emergencia)",
  [La transmisión de mensajes de cualquier naturaleza con destino a terceros ajenos al servicio de aficionados:],
  ([está permitida solo en fin de semana], [está siempre permitida], [está permitida previo pago de una tasa], [no está permitida con carácter general],),
  sol: [Con carácter general no se permite cursar tráfico con destino a terceros ajenos al servicio; la excepción son las emergencias y catástrofes.])
#pq(2, 2, 17, "c", "F-R8.93", "Modulaciones permitidas: dentro de las bandas y con anchos de banda del plan IARU Región 1",
  [Según el apartado 3.1 del anexo I, los radioaficionados pueden emplear la modulación de amplitud (con doble banda lateral o banda lateral única), la de frecuencia, la de fase y otras modulaciones digitales, siempre que la emisión resultante:],
  ([no ocupe más de 3 kHz de anchura de banda en ninguna banda], [haya sido autorizada expresamente por la SETSI para ese modo de emisión], [se ajuste a las bandas de frecuencias autorizadas y, como norma general, tenga un ancho de banda acorde con el plan de bandas de la IARU para la Región 1], [se ajuste a las bandas autorizadas y tenga un ancho de banda acorde con los planes de bandas de la IARU para la Región 2],),
  sol: [El apartado 3.1 autoriza la modulación de amplitud (doble banda lateral o banda lateral única, con distintos niveles de portadora), la de frecuencia o de fase y otras modulaciones digitales, con una condición: que la emisión quede dentro de las bandas autorizadas al servicio y con anchos de banda acordes, como norma general, al plan de bandas de la IARU para la Región 1 (u otros que se establezcan). No fija un máximo de 3 kHz (a) ni exige autorización para cada modo (b), y España está en la Región 1 (d). El artículo 2.2 de la Orden remite igualmente a ese plan. #_apc3-ver[(Véase tema R6, introducción del capítulo (el plan de bandas de la IARU para la Región 1).)]

#_apc3-net[El apartado 3.1 del anexo I autoriza la modulación de amplitud (doble banda lateral o banda lateral única, con distintos niveles de portadora), la de frecuencia o de fase y otras modulaciones digitales, con una sola condición: que la emisión resultante se ajuste a las bandas de frecuencias autorizadas al servicio de radioaficionados y tenga anchos de banda acordes, como norma general, con el plan de bandas de la IARU para la Región 1 (u otros que se establezcan).]])
#pq(2, 2, 18, "b", "F-R8.94", "Modulaciones digitales autorizadas: con señales de audio, datos o vídeo",
  [Los «otros tipos de modulaciones digitales» que autoriza el apartado 3.1 del anexo I, siempre que la emisión respete las bandas y los anchos de banda aplicables, pueden transportar señales de:],
  ([solo datos, como el RTTY o los paquetes], [audio, datos o vídeo], [audio y datos, pero no vídeo], [datos y vídeo, pero no audio],),
  sol: [El apartado 3.1 autoriza «otros tipos de modulaciones digitales con señales de audio, datos o vídeo», sin distinguir por el contenido: lo que importa es que la emisión quede dentro de las bandas autorizadas al servicio y con anchos de banda acordes, como norma general, al plan de bandas de la IARU para la Región 1. Valen, pues, la voz digital (audio), los modos de texto y de paquetes (datos) y la televisión digital (vídeo). Las otras tres opciones excluyen, sin apoyo en el texto, alguno de los tres tipos de señal.

#_apc3-net[Las modulaciones digitales que autoriza el apartado 3.1 del anexo I pueden llevar señales de audio, datos o vídeo: el anexo no limita el tipo de contenido, sino que exige que la emisión se ajuste a las bandas de frecuencias autorizadas y, como norma general, a anchos de banda acordes con el plan de bandas de la IARU para la Región 1.]])
#pq(2, 2, 19, "b", "F-R8.18", "Banda de 60 m: atribución secundaria y 15 W p.i.r.e.",
  [En España, la banda de 5351,5–5366,5 kHz (60 m) está atribuida al servicio de aficionados:],
  ([con carácter primario y una potencia máxima de 1000 W p.c.e.], [con carácter secundario y una potencia radiada máxima de 15 W p.i.r.e.], [con carácter secundario y una potencia máxima de 500 W p.c.e., el 50 % de la de HF], [con carácter primario y una potencia radiada máxima de 15 W p.i.r.e.],),
  sol: [En el CNAF vigente la banda de 5351,5 a 5366,5 kHz figura con el servicio «Aficionados» en caracteres normales, es decir, con carácter secundario, y con la nota 5.133B del Reglamento de Radiocomunicaciones, que limita la potencia radiada a 15 W (p.i.r.e.). Como secundario, no puede causar interferencia a los servicios primarios ni reclamar protección frente a ellos. La banda no figura en la tabla de potencias del anexo I, 3.1, de la Orden IET/1311/2013: por eso no valen los 1000 W p.c.e. de las bandas de HF (a) ni su 50 % (c), y primario (a, d) es falso. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[Además de las bandas de la tabla, en HF el servicio de aficionados dispone de la banda de 60 m, 5351,5–5366,5 kHz, atribuida con carácter secundario: no debe causar interferencia perjudicial a los servicios primarios ni puede reclamar protección frente a ellos. La nota 5.133B del Reglamento de Radiocomunicaciones, recogida en el CNAF, limita la potencia radiada a 15 W (p.i.r.e.). Esta banda no figura en la tabla de potencias del anexo I, 3.1, de la Orden IET/1311/2013.]])
#pq(2, 2, 20, "c", "R8.3", "T/R 61-01 = licencia CEPT (uso temporal); T/R 61-02 = certificado HAREC",
  [La Recomendación CEPT T/R 61-02 se refiere a:],
  ([el uso de repetidores transfronterizos], [las emisiones por satélite], [el certificado de examen armonizado HAREC], [la potencia máxima en HF],),
  sol: [T/R 61-02: certificado de examen armonizado HAREC.])
#pq(2, 2, 21, "c", "C-R8.2", "Contenido de la licencia CEPT (no consta la asociación ni la fecha del examen)",
  [En la licencia de estación de radioaficionado CEPT habrá de constar necesariamente una determinada información. Indique la respuesta incorrecta:],
  ([Autoridad que expide la licencia.], [Distintivo de llamada.], [Asociación de radioaficionados a la que pertenece.], [Periodo de validez.],),
  sol: [El art. 12 de la Orden IET/1311/2013 enumera lo que debe constar en la licencia CEPT: la declaración que autoriza al titular a usar su estación según la T/R 61-01 en cualquier país que la haya adoptado, nombre y dirección del titular, distintivo de llamada, periodo de validez y autoridad que la expide. La asociación a la que pertenece el titular no figura: ser socio de una asociación no es requisito para ser radioaficionado. Por eso la incorrecta, la que se pide, es la c.

    #no-esta[La licencia CEPT (Recomendación T/R 61-01; arts. 11 y 12 de la Orden IET/1311/2013) permite operar temporalmente en los países que la han adoptado. Debe contener cinco datos: la declaración de que autoriza a usar la estación conforme a la T/R 61-01, nombre y dirección del titular, distintivo de llamada, periodo de validez y autoridad que la expide. Regla práctica: quién eres, cómo te llamas en el aire, hasta cuándo vale y quién lo firma. En España, la autorización de radioaficionado vale a todos los efectos como licencia CEPT.]])
#pq(2, 2, 22, "a", "C-R8.29", "Comunidad de propietarios: no autoriza; la solicitud indica la dirección del presidente y la Administración le informa",
  [Para instalar una antena en un edificio en régimen de propiedad horizontal:],
  ([Se comunicará a la Administración la dirección del Presidente de la Comunidad de Propietarios.], [No será necesario tener en cuenta las características mecánicas de la misma.], [Se necesita autorización expresa de la Comunidad de Propietarios.], [No se precisa contratar un seguro para garantizar posibles responsabilidades.],),
  sol: [En la solicitud hay que hacer constar la dirección del presidente de la comunidad de propietarios (RD 2623/1986, art. 2.4): así la Administración, una vez aceptada la memoria de instalación, puede comunicársela para que alegue en dos meses sobre la idoneidad del emplazamiento o los perjuicios (art. 3). Las demás son falsas: la comunidad no concede la autorización, solo puede pronunciarse sobre la idoneidad de la instalación; el seguro de responsabilidad civil es obligatorio (art. 20); y las características mecánicas de la antena y sus elementos anejos deben responder a las normas de la buena construcción (art. 16). #vease[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

    #no-esta[Procedimiento con comunidad de propietarios (RD 2623/1986, arts. 2.4 y 3): el solicitante hace constar en la solicitud la dirección del presidente; aceptada la memoria, la Administración se lo comunica a la comunidad, que dispone de dos meses para alegar sobre la idoneidad del emplazamiento o los perjuicios a elementos privativos y comunes; si no contesta, se entiende que acepta tácitamente. La comunidad informa, no autoriza ni prohíbe.]])
#pq(2, 2, 23, "a", "F-R8.75", "Obras de indudable urgencia: desmontaje sin trámites, comunicándolo inmediatamente al titular",
  [Según el Real Decreto 2623/1986, cuando las obras necesarias en el inmueble tienen carácter de indudable urgencia, la propiedad puede desmontar las antenas de la estación de aficionado y sus elementos anejos:],
  ([sin los trámites ni los plazos de las obras ordinarias, pero comunicándolo inmediatamente al titular de la licencia], [sin comunicárselo a nadie, porque la urgencia exime de cualquier aviso], [solo tras avisar al titular de la licencia con un mes de antelación, como en cualquier otra obra], [previa autorización de la Jefatura Provincial de Inspección de Telecomunicaciones],),
  sol: [Art. 6 del Real Decreto 2623/1986: en las obras ordinarias la propiedad avisa de forma fehaciente al titular con un mes de antelación, para que desmonte él mismo la instalación o lo presencie. Art. 7: si las obras son de indudable urgencia, puede desmontar las antenas sin esos trámites y plazos, pero debe poner inmediatamente en conocimiento del titular la realización de las obras. La urgencia exime del plazo, no del aviso: por eso b es falsa. La c aplica la regla ordinaria y la d inventa una autorización que el Real Decreto no pide. #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[Real Decreto 2623/1986 (arts. 6 y 7): si la propiedad debe hacer obras necesarias que obliguen a desmontar y volver a montar la antena, lo comunica de forma fehaciente al titular de la licencia con un mes de antelación, para que desmonte él mismo o lo presencie. Si las obras son de indudable urgencia, puede desmontar sin esos trámites ni plazos, pero debe avisar inmediatamente al titular. Terminadas las obras, la instalación queda en condiciones similares a las anteriores y el titular no puede exigir indemnización (art. 6.2).]])
#pq(2, 2, 24, "d", "R8.76", "Daños: los que causa la antena (instalación, conservación, desmontaje) son del titular; los que causa la propiedad a la antena, de la propiedad",
  [Los daños y perjuicios que ocasione la antena de una estación de aficionado corren a cargo:],
  ([del seguro obligatorio de la vivienda], [de la comunidad de propietarios], [del fabricante de la antena], [del titular de la estación, incluidos los de instalación, mantenimiento y desmontaje],),
  sol: [La responsabilidad es del titular de la estación y abarca todo el ciclo de vida de la instalación: montarla, mantenerla y desmontarla. De ahí la exigencia de un seguro que cubra la responsabilidad civil.])
#pq(2, 2, 25, "d", "F-R8.38", "Autorizaciones del art. 16 (bandas secundarias): limitaciones geográficas o técnicas",
  [En las autorizaciones especiales del artículo 16 de la Orden IET/1311/2013 (bandas atribuidas con carácter secundario, con riesgo de interferir a servicios primarios), se establecen:],
  ([un plazo máximo inicial de dieciocho meses, ampliable si hace falta], [el uso exclusivo de la banda a favor del solicitante, sin compartirla con otros], [una tasa anual por cada banda cuyo uso se autoriza], [limitaciones geográficas o técnicas de uso que aseguren la compatibilidad con los servicios afectados],),
  sol: [El art. 16.2 dice que en estas autorizaciones especiales se establecen las limitaciones geográficas o técnicas de uso de la banda, para asegurar su compatibilidad con los servicios de radiocomunicaciones autorizados que puedan verse afectados (d). No hay uso exclusivo (b): la banda es secundaria y sus estaciones no deben causar interferencia perjudicial a las de un servicio primario. Los dieciocho meses (a) son los del art. 17.3 para las autorizaciones experimentales; el art. 16 no fija plazo. Y el artículo no menciona tasas por banda (c). #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[El art. 16 de la Orden IET/1311/2013 se refiere a las bandas atribuidas al servicio de aficionados con carácter secundario. Se usan según el Reglamento de Radiocomunicaciones, pero si hay riesgo de interferencia perjudicial a servicios primarios que comparten la banda, hace falta una autorización especial de la SETSI. En ella se fijan las limitaciones geográficas o técnicas de uso que garanticen la compatibilidad. La disposición adicional segunda enumera las bandas iniciales: 2300–2450 MHz, 5650–5850 MHz y 24,050–24,250 GHz, con algunas subbandas exceptuadas.]])
#pq(2, 2, 26, "b", "C-R8.37", "Estación móvil: en movimiento o detenida en puntos no determinados",
  [Estación móvil de aficionado:],
  ([Estación de aficionado instalada en vehículo o en segundo domicilio.], [Estación que puede ser utilizada en movimiento o mientras está detenida en puntos no determinados.], [Estación que se puede transportar para utilizarla solamente en puntos no determinados.], [Es toda estación de aficionado destinada a ser utilizada en movimiento.],),
  sol: [El anexo I de la Orden IET/1311/2013 define la estación móvil de radioaficionado como la destinada a ser utilizada en movimiento o mientras esté detenida en puntos no determinados: lo que la caracteriza es que carece de ubicación fija, esté o no en marcha. La a confunde la móvil con una estación instalada en un lugar (el segundo domicilio); la c omite el movimiento y añade «solamente»; la d es incompleta, porque también es móvil mientras está detenida en puntos no determinados. La misma definición aparece al revés en el banco: la estación «destinada a ser utilizada en un vehículo en movimiento o mientras está detenido en puntos no determinados» es una estación #emph[móvil], no una temporal, ni una fija, ni una fija/portable. #vease[(Véase tema R8, sección «Tipos de estación» (portátil, portable y fija remota).)]

    #no-esta[Definiciones del anexo I de la Orden IET/1311/2013. #strong[Móvil]: destinada a utilizarse en movimiento o detenida en puntos no determinados. #strong[Portátil]: móvil con antena y fuente de energía incorporadas al propio equipo. #strong[Portable]: fija utilizada con carácter temporal en una ubicación determinada distinta de la habitual. #strong[Fija]: emite y recibe desde una ubicación fija determinada. #strong[Temporal]: la usada en concursos y diplomas, expediciones, demostraciones en colegios, ferias y eventos similares. Regla: móvil = sin ubicación fija; portátil = móvil autosuficiente (antena y batería).]])
#pq(2, 2, 27, "b", "R8.87", "Estación digital: emite con técnicas digitales",
  [Se entiende por estación digital de aficionado aquella:],
  ([que carece de mandos analógicos], [dotada de dispositivos que permiten realizar emisiones con técnicas digitales], [cuyos equipos son de fabricación industrial], [que solo puede emplear telegrafía],),
  sol: [Lo que la define es la técnica de emisión, no el aspecto del equipo: transmisión de datos, modos digitales de fonía o de texto. Un transceptor con mandos convencionales puede operar perfectamente en digital.])
#pq(2, 2, 28, "c", "R8.36", "Potencia de las desatendidas: VHF/UHF 10 W en casco urbano y 50 W fuera; HF 50 W",
  [Como norma general, la potencia máxima de salida de los transmisores de las estaciones desatendidas en las bandas de VHF y UHF es de:],
  ([100 W en cualquier ubicación], [25 W dentro y fuera del casco urbano], [10 W en núcleos urbanos y 50 W fuera de ellos], [5 W en todos los casos],),
  sol: [Desatendidas en VHF/UHF: 10 W dentro del casco urbano, 50 W fuera.])
#pq(2, 2, 29, "d", "R9.9", "Leve: no facilitar los datos requeridos o retrasarlos",
  [No facilitar los datos requeridos por la Administración, o retrasar injustificadamente su aportación cuando resulte exigible, constituye una infracción:],
  ([grave], [muy grave], [no constituye infracción], [leve],),
  sol: [No facilitar los datos requeridos, o retrasar su aportación injustificadamente, es infracción leve (art. 108.12 de la Ley 11/2022). Pasa a grave si se exceden los plazos: una vez transcurrido un mes desde el fin del plazo del requerimiento o finalizado el del segundo requerimiento (art. 107.34).])
#pq(2, 2, 30, "c", "R9.32", "Cancelación de la autorización a petición del titular",
  [La autorización de radioaficionado se cancelará:],
  ([únicamente por fallecimiento del titular], [transcurridos diez años desde su concesión, sin excepción], [en cualquier momento, a petición de su titular], [solo mediante resolución sancionadora],),
  sol: [La autorización se mantiene mientras su titular quiera y cumpla; y como es un derecho y no una carga, puede renunciar a ella cuando lo desee. La revocación por incumplimiento es un supuesto distinto.])
#fin-prueba()
#soluciones-simulacro(2)

// ======================================================================
#simulacro(3)
#prueba(3, 1)
#pq(3, 1, 1, "b", "T1.42", "Asociación de pilas: en serie se suman las tensiones; en paralelo, las corrientes (y baja la resistencia interna)",
  [Si se conectan en serie cuatro pilas iguales:],
  ([la tensión y la intensidad se multiplican por cuatro], [la tensión se cuadruplica y la intensidad es la de una sola pila], [la tensión es la de una sola pila y la intensidad se cuadruplica], [tanto la tensión como la intensidad son las de una sola pila],),
  sol: [En serie las tensiones se suman porque las pilas se encadenan, pero la corriente atraviesa a todas por igual: la capacidad de entregar corriente sigue siendo la de una. Para aumentar la corriente habría que ponerlas en paralelo, y entonces la tensión sería la de una sola.])
#pq(3, 1, 2, "c", "T1.12", "Capacidad de una batería en amperios-hora: t = C / I",
  [Una batería con una capacidad de 7 amperios-hora puede suministrar una corriente de 0,5 A durante aproximadamente:],
  ([3,5 horas], [7 horas], [14 horas], [28 horas],),
  sol: [$t = Q slash I = 7 "Ah" slash 0,5 "A" = 14$ horas: a mitad de corriente, doble de horas.])
#pq(3, 1, 3, "a", "T1.25", "Parámetro que varía en cada modulación analógica (AM amplitud, FM frecuencia, PM fase)",
  [En la modulación de amplitud (AM), la señal moduladora hace variar:],
  ([la amplitud de la portadora], [la impedancia de la antena], [la fase de la portadora], [la frecuencia de la portadora],),
  sol: [En AM la información va en la amplitud de la portadora: la envolvente reproduce la señal moduladora (la figura del libro). En FM lo que varía es la frecuencia.])
#pq(3, 1, 4, "b", "F-T1.24", "FSK, PSK y QAM: qué parámetro de la portadora varía cada una",
  [En la modulación FSK, la información digital se transmite variando:],
  ([la amplitud y la fase de la portadora a la vez], [la frecuencia de la portadora entre valores discretos], [solo la fase de la portadora], [la amplitud de la portadora entre dos niveles],),
  sol: [FSK (_Frequency Shift Keying_) asigna a cada símbolo una frecuencia distinta: en el RTTY de aficionado, por ejemplo, una para «marca» y otra para «espacio», separadas 170 Hz. Variar la amplitud entre dos niveles es ASK. Variar solo la fase es PSK, como en PSK31. Variar amplitud y fase a la vez es QAM. _(Véase tema T1, sección «Señales moduladas».)_])
#pq(3, 1, 5, "d", "T2.3", "En un conductor metálico la resistencia aumenta con la temperatura",
  [Si aumenta la temperatura en un conductor:],
  ([el conductor se convierte en aislante], [su resistencia no varía], [disminuye su resistencia eléctrica], [aumenta también su resistencia eléctrica],),
  sol: [En un conductor metálico la resistencia crece con la temperatura: las vibraciones de la red dificultan el paso de los electrones.])
#pq(3, 1, 6, "c", "C-T2.14", "Capacidad: C = Q/V; el condensador almacena carga eléctrica",
  [La capacidad está dada por:],
  ([$C = I slash E$], [$C = W · V$], [$C = Q slash E$], [$C = R · I$],),
  sol: [
    La capacidad es la carga que almacena un condensador por cada voltio aplicado: $C = Q slash V$.
    Aquí la tensión se escribe $E$, luego $C = Q slash E$ (c); en unidades, faradio = culombio /
    voltio. Las otras opciones son otras magnitudes: $I slash E$ es una conductancia ($1 slash R$),
    $R · I$ es una tensión (ley de Ohm) y $W ·V$ no define ninguna magnitud del condensador; la
    energía almacenada es $W = 1/2 C V^2$. #vease[(Véase tema T2, sección «Condensadores».)]
  ])
#pq(3, 1, 7, "a", "F-T2.10", "Corrientes en el transformador ideal: van en proporción inversa a las tensiones (potencia constante)",
  [Un transformador ideal con 1000 espiras en el primario y 100 en el secundario se conecta a la red de 230 V. Si el secundario alimenta una carga que consume 5 A, la corriente que toma el primario es de:],
  ([0,5 A], [5 A], [50 A], [0,05 A],),
  sol: [Relación de espiras $N_p slash N_s = 1000 slash 100 = 10$, luego $V_s = 230 slash 10 = 23$ V. En el transformador ideal la potencia no cambia ($V_p I_p = V_s I_s$): $P = 23 times 5 = 115$ W y $I_p = 115 slash 230 = 0,5$ A; dicho de otro modo, las corrientes van en proporción inversa a las tensiones, $I_p = I_s N_s slash N_p = 5 slash 10$. Los 50 A (c) salen de invertir la relación; los 5 A (b) ignoran el transformador; y los 0,05 A (d) dividen dos veces, aplicando el cuadrado de la relación, que vale para impedancias y no para corrientes. _(Véase tema T2, sección «Transformadores», y capítulo «La radio por dentro: componente a componente», apartado «El transformador: dos bobinas y un puente de flujo».)_])
#pq(3, 1, 8, "a", "T2.32", "Ganancia de corriente β = I_C/I_B",
  [La ganancia de corriente $beta$ de un transistor bipolar es la relación entre:],
  ([la corriente de colector y la corriente de base], [la corriente de emisor y la corriente de colector], [la tensión de colector y la tensión de base], [la corriente de drenador y la corriente de surtidor],),
  sol: [$beta = I_C slash I_B$: cuántas veces mayor es la corriente que gobierna respecto a la que la gobierna. Un $beta$ de 100 significa que 1 mA de base maneja 100 mA de colector. Drenador y surtidor son terminales del FET.])
#pq(3, 1, 9, "c", "C-T2.21", "Símbolos de transistores: bipolar frente a FET",
  [¿Cuál de los siguientes símbolos es el de un transistor FET?],
  ([#box(baseline: 45%, esquema(escala: 0.75, {
      import zap: *
      import cetz.draw: *

      line((-1.2, 0), (0, 0), stroke: 0.8pt)
      line((0, 0.9), (0, -0.9), stroke: 0.8pt)
      line((0.8, -0.9), (0.8, 0.5), stroke: 0.8pt)
      line((0, 0.9), (0.8, 0.45), (0, 0), stroke: 0.8pt)
      line((0.8, 0), (0, -0.45), (0.8, -0.9), stroke: 0.8pt)
      line((0.8, 0), (1.9, 0), stroke: 0.8pt)
      line((0.8, 0.25), (1.4, 0.7), (1.4, 1.3), stroke: 0.8pt)

    }))], [#box(baseline: 45%, esquema(escala: 0.75, {
      import cetz.draw: *
      group({
        line((-1.1, 0), (0, 0), stroke: 0.8pt)
        line((0, -0.5), (0, 0.5), stroke: 2pt)
        line((0, 0.25), (0.55, 0.6), (0.55, 1.3), stroke: 0.8pt)
        line((0, -0.25), (0.55, -0.6), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))
        line((0.55, -0.6), (0.55, -1.3), stroke: 0.8pt)
      })
      group({
        translate((3.4, 0))
        line((-1.1, 0), (0, 0), stroke: 0.8pt)
        line((0, -0.5), (0, 0.5), stroke: 2pt)
        line((0, -0.25), (0.55, -0.6), (0.55, -1.3), stroke: 0.8pt)
        line((0.55, 0.6), (0, 0.25), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))
        line((0.55, 0.6), (0.55, 1.3), stroke: 0.8pt)
      })
    }))], [#box(baseline: 45%, esquema(escala: 0.75, {
      import cetz.draw: *
      group({
        translate((0, 0))

      line((0, -0.8), (0, 0.8), stroke: 2pt)
      line((0, 0.55), (0.7, 0.55), (0.7, 1.3), stroke: 0.8pt)
      line((0, -0.55), (0.7, -0.55), (0.7, -1.3), stroke: 0.8pt)
      line((0, 0.55), (-0.4, 0.55), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))
      line((-0.4, 0.55), (-1.1, 0.55), stroke: 0.8pt)

      })
      group({
        translate((3.4, 0))

      line((0, -0.8), (0, 0.8), stroke: 2pt)
      line((0, 0.55), (0.7, 0.55), (0.7, 1.3), stroke: 0.8pt)
      line((0, -0.55), (0.7, -0.55), (0.7, -1.3), stroke: 0.8pt)
      line((-1.1, 0.55), (0, 0.55), stroke: 0.8pt, mark: (end: ">", fill: black, scale: 0.6))

      })
    }))], [#box(baseline: 45%, esquema(escala: 0.75, {
      import zap: *
      import cetz.draw: *
      diode("d1", (-1.2, 0), (1.2, 0))
    }))],),
  sol: [
    El transistor de efecto de campo (FET) tiene tres terminales: puerta (G), fuente (S) y drenador
    (D). Se dibuja con una línea vertical gruesa, el canal, con el drenador y la fuente en sus
    extremos, y la puerta al lado con una flecha; la de la opción c) es la del FET de unión, en sus
    dos variantes: canal P (flecha saliendo de la puerta) y canal N (flecha entrando). La a) es un
    triac (dos diodos en antiparalelo y un terminal de puerta); la b) son dos transistores
    bipolares, NPN y PNP, con base, colector y emisor (flecha en el emisor, sin canal); la d) es un
    diodo, un triángulo y una barra. #vease[(Véase tema T2, sección «Semiconductores y otros
    componentes».)]
    #no-esta[Los símbolos que hay que saber distinguir en el examen son cuatro. El #strong[diodo]: triángulo
    contra una barra (el cátodo). El #strong[transistor bipolar]: una barra gruesa (la base) con dos
    terminales oblicuos, colector y emisor; la flecha está en el emisor y apunta hacia fuera en el
    NPN y hacia la base en el PNP. El #strong[FET]: un canal vertical con drenador y fuente en los
    extremos y la puerta al lado, con flecha hacia el canal en el de canal N y saliendo de él en el
    de canal P. El #strong[triac]: dos triángulos enfrentados en antiparalelo (conduce en ambos
    sentidos), con un terminal de puerta (T1, T2 y G).]
  ])
#pq(3, 1, 10, "d", "T3.7", "Filtro paso banda: deja pasar su banda y atenúa por encima y por debajo; es el de la FI",
  [Con un filtro paso banda se consigue:],
  ([atenuar las frecuencias comprendidas dentro de la banda de paso], [dejar pasar únicamente las frecuencias inferiores a la de corte], [dejar pasar todas las frecuencias por igual], [atenuar las frecuencias superiores e inferiores a la banda de paso],),
  sol: [El paso banda deja pasar su banda y atenúa por encima y por debajo: es el filtro típico de la FI.])
#pq(3, 1, 11, "b", "C-T3.19", "Fuente lineal frente a conmutada: la lineal pesa (transformador de 50 Hz) y rinde poco; la conmutada trabaja a decenas–cientos de kHz, ligera y eficiente",
  [Una de las características de las fuentes lineales de alta intensidad es:],
  ([Su bajo consumo], [Su elevado peso], [Su inestabilidad frente a la radiofrecuencia], [Su falta de filtrado en la salida],),
  sol: [
    Una fuente lineal baja la tensión de red con un transformador que trabaja a 50 Hz: para dar
    mucha corriente necesita un núcleo de hierro grande y pesado, además de disipadores voluminosos
    para evacuar el calor del regulador (el rendimiento es bajo). De ahí su elevado peso. No carece
    de filtrado (lleva condensadores de filtro y su salida es muy limpia); la interferencia de RF es
    un problema de las fuentes conmutadas, no de las lineales; y tampoco es de bajo consumo, pues
    desperdicia como calor parte de la energía. #vease[(Véase tema T3, sección «Fuentes de
    alimentación y amplificadores».)]
  ])
#pq(3, 1, 12, "b", "F-T3.12", "Ganancia de tensión en decibelios: 20·log(V2/V1)",
  [Un amplificador eleva una señal de 10 mV a 1 V, con la misma impedancia en la entrada y en la salida. Su ganancia de tensión, en decibelios, es de:],
  ([20 dB], [40 dB], [10 dB], [100 dB],),
  sol: [Con las dos tensiones en mV, $V_2 slash V_1 = 1000 slash 10 = 100$. Sobre la misma impedancia, $G = 20 log(V_2 slash V_1) = 20 log 100 = 40$ dB. Los 20 dB resultan de aplicar a una relación de tensiones la fórmula de potencias, $10 log$. Los 100 dB confunden la relación de tensiones con los decibelios. Y 10 dB corresponde a una relación de tensiones de solo 3,16. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_])
#pq(3, 1, 13, "a", "T3.27", "Oscilador: convierte la corriente continua en alterna",
  [Un oscilador es un dispositivo que:],
  ([convierte corriente continua en corriente alterna], [adapta la impedancia de la antena], [reduce el ancho de banda de un transmisor], [elimina los ruidos de la señal recibida],),
  sol: [Toma la energía continua de la alimentación y la entrega como una señal alterna de la frecuencia que fije su circuito resonante. Es el corazón de todo transmisor y el que genera la señal del oscilador local en el receptor.])
#pq(3, 1, 14, "d", "F-T3.27", "Sintetizador PLL: f_out = N·f_ref; el paso de canal es f_ref",
  [Un sintetizador PLL con referencia de 12,5 kHz debe generar 145,500 MHz. El divisor programable ha de valer:],
  ([11 600], [116 400], [5 820], [11 640],),
  sol: [La salida de un sintetizador con divisor programable es un múltiplo entero de la referencia: $f_"out" = N dot f_"ref"$, luego $N = f_"out"/f_"ref" = ("145 500 kHz")/("12,5 kHz") = "11 640"$. Comprobación: $"11 640" times 12,5$ kHz = 145 500 kHz. Es decir, basta dividir la frecuencia deseada entre la de referencia. Con $N = "11 600"$ saldrían 145,000 MHz. El valor 5 820 correspondería a una referencia de 25 kHz, y 116 400 es un error de coma decimal: daría 1 455 MHz. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_])
#pq(3, 1, 15, "b", "T4.1", "Orden de etapas del superheterodino: RF → mezclador → FI → detector → BF",
  [En un receptor superheterodino, el orden correcto de las etapas desde la antena hasta el altavoz es:],
  ([amplificador de FI, mezclador, amplificador de RF, demodulador, amplificador de audio], [amplificador de RF, mezclador, amplificador de FI, demodulador, amplificador de audio], [demodulador, mezclador, amplificador de FI, amplificador de audio], [mezclador, amplificador de RF, demodulador, FI, amplificador de audio],),
  sol: [Cadena del superheterodino: amplificador de RF → mezclador → amplificador de FI → demodulador → amplificador de audio. El amplificador de RF va primero porque fija la figura de ruido (fórmula de Friis): lo que añadan las etapas siguientes entra dividido por su ganancia. El mezclador traslada luego la señal a la FI fija, donde el filtrado y la amplificación son óptimos, y solo al final se demodula. Invertir el orden no tiene sentido físico.])
#pq(3, 1, 16, "a", "C-T4.15", "Diagrama de bloques del receptor de BLU (RF, mezclador con OL variable, FI, detector de producto con BFO)",
  [El esquema de un receptor básico para banda lateral única se corresponde con la figura:],
  ([#_apb1-rx([etapa\ RF], [etapa\ FI], [detector de\ producto], [oscilador\ variable], [oscilador de\ batido])], [#_apb1-rx([etapa\ FI], [etapa\ RF], [detector de\ producto], [oscilador\ variable], [oscilador de\ batido])], [#_apb1-rx([etapa\ RF], [demodulador], [detector de\ producto], [oscilador\ fijo], [oscilador\ variable])], [#_apb1-rx([etapa\ RF], [etapa\ FI], [diodo\ detector], [oscilador\ variable], none)],),
  sol: [
    La señal pasa de la antena a la etapa de RF y al mezclador, donde el oscilador variable la
    convierte en la frecuencia intermedia que amplifica la etapa de FI. En BLU no hay portadora, así
    que la detección exige un detector de producto que la reponga con un oscilador de batido (BFO);
    luego, el amplificador de BF excita el altavoz. Eso es la figura a. En la b la FI va antes del
    mezclador y la RF después, cuando la FI nace en el mezclador. En la c un demodulador ocupa el
    lugar de la FI y los osciladores están cambiados. En la d el diodo detector sirve para AM con
    portadora, no para BLU. #vease[(Véase tema T4, sección «Arquitectura del receptor».)]
  ])
#pq(3, 1, 17, "c", "T5.27", "SSB por filtro: el modulador equilibrado suprime la portadora; el filtro elimina una banda lateral",
  [En un transmisor de banda lateral única, el modulador equilibrado tiene la propiedad de:],
  ([duplicar la frecuencia de la portadora], [amplificar la señal de audio], [suprimir la portadora y dejar solo las dos bandas laterales], [eliminar los armónicos de la etapa final],),
  sol: [Su simetría hace que la portadora se cancele a la salida y solo sobrevivan los productos de mezcla, es decir, las dos bandas laterales. Un filtro posterior se queda con una sola: eso ya es SSB.])
#pq(3, 1, 18, "d", "F-T5.11", "FM directa: el audio actúa sobre el oscilador (varicap)",
  [En la modulación de frecuencia directa, la señal de audio actúa sobre:],
  ([el amplificador final, variando su tensión de alimentación], [un modulador balanceado que suprime la portadora], [un mezclador, que suma al oscilador la frecuencia del audio], [el oscilador, por ejemplo mediante un diodo varicap en su circuito resonante],),
  sol: [En la FM directa el audio cambia la frecuencia del propio oscilador: la tensión de audio varía la capacidad de un varicap del circuito resonante (un VCO) y con ella la frecuencia generada. Variar la tensión de alimentación del final (a) es modular en amplitud; el modulador balanceado (b) es de SSB; y el mezclador (c) traslada frecuencias, no las desvía al ritmo del audio. #vease[(Véase tema T5, sección «Arquitecturas y características generales».)]])
#pq(3, 1, 19, "a", "T5.33", "Potencia de portadora: media durante un ciclo de RF sin modulación",
  [Se denomina potencia de portadora de un transmisor a la que entrega a la línea de alimentación de la antena:],
  ([durante un ciclo de radiofrecuencia, en ausencia de modulación], [durante la cresta de modulación], [con la antena desconectada], [promediada a lo largo de un minuto],),
  sol: [Es la definición del Reglamento de Radiocomunicaciones: potencia media durante un ciclo de radiofrecuencia, sin modulación. Junto con la potencia de pico de envolvente y la potencia media, es una de las tres formas reglamentarias de expresar la potencia de un transmisor.])
#pq(3, 1, 20, "c", "C-T6.2", "Antena omnidireccional: radia igual en todo el plano horizontal (el dipolo, en el plano perpendicular al hilo)",
  [La antena de media onda:],
  ([Parte las ondas por medio], [Es directiva], [Es omnidireccional (en el plano perpendicular al hilo)], [Es una antena para las ondas decamétricas solamente],),
  sol: [
    El dipolo de media onda radia por igual en todas las direcciones del plano perpendicular al hilo
    (en vertical, hacia todo el horizonte) y no radia en la dirección del propio hilo. Se le
    considera por eso omnidireccional, al contrario que una Yagi, que concentra la energía en una
    sola dirección: su directividad es de solo 2,15 dBi (b falsa). La media onda no es exclusiva de
    las decamétricas: se construye para cualquier frecuencia con $λ slash 2$ de hilo (d). Y «partir
    las ondas por medio» (a) no significa nada: la media onda es la longitud de la antena.
    #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]
    #no-esta[Diagrama del dipolo: como la corriente circula a lo largo del hilo, la radiación es máxima en
    las direcciones perpendiculares a él y nula en la dirección del hilo. En tres dimensiones es un
    toro (una rosquilla) con el hilo pasando por el agujero. Montado en vertical, el corte
    horizontal es un círculo: radia por igual hacia todo el horizonte (omnidireccional). Montado en
    horizontal, ese mismo corte es un «ocho». Omnidireccional se entiende, pues, siempre respecto de
    un plano.]
  ])
#pq(3, 1, 21, "d", "T6.16", "Relación adelante-atrás: dB entre el lóbulo principal y el trasero",
  [En el diagrama de radiación de una antena directiva, la diferencia en decibelios entre el lóbulo principal y el lóbulo trasero se denomina:],
  ([ancho de haz], [pérdida de retorno], [ganancia isótropa], [relación adelante-atrás],),
  sol: [La relación adelante-atrás compara, en dB, el lóbulo principal con el trasero: cuanto mayor, mejor rechaza la antena lo que llega por la espalda.])
#pq(3, 1, 22, "c", "T6.8", "Polarización: orientación del campo eléctrico radiado",
  [La polarización de una antena viene determinada por:],
  ([la longitud de la línea de transmisión], [la frecuencia de trabajo], [la orientación del campo eléctrico radiado], [la potencia del transmisor],),
  sol: [La polarización es la orientación del campo eléctrico radiado: vertical u horizontal según la antena.])
#pq(3, 1, 23, "d", "C-T6.8", "Para aumentar el alcance, lo primero es aumentar la directividad de la antena",
  [De los diversos procedimientos que a continuación se indican, para aumentar el alcance de una
emisora el primero al que hay que recurrir, si es factible, es el siguiente:],
  ([Aumentar la potencia de emisión], [Aumentar la anchura de banda], [Aumentar la tensión del paso final], [Aumentar la directividad de la antena],),
  sol: [
    La antena es la forma más económica y eficaz de ganar alcance. Una antena más directiva
    concentra la energía en la dirección del corresponsal —equivale a radiar más potencia en ese
    sentido— y, por reciprocidad, capta también mejor sus señales. Duplicar la potencia del
    transmisor solo aporta 3 dB y exige un amplificador; una antena de 10 dBd multiplica por 10 la
    potencia efectiva radiada sin gastar un vatio más. Aumentar la anchura de banda (b) no da
    alcance, y subir la tensión del paso final (c) es otra manera de subir potencia, con los mismos
    inconvenientes que a. En la variante «se aumenta el alcance de una emisora si se aumenta…», la
    respuesta es igualmente la directividad de la antena: la reactancia, la polarización negativa de
    rejilla y la corriente inversa de pico no influyen en el alcance. #vease[(Véase tema T6, sección
    «El dipolo y otras antenas».)]
  ])
#pq(3, 1, 24, "b", "T7.24", "Los satélites de aficionado usan VHF y UHF (hay que atravesar la ionosfera)",
  [Para las comunicaciones a través de satélites de aficionado se emplean preferentemente las bandas de:],
  ([onda media], [VHF y UHF], [frecuencias inferiores a 3 MHz], [80 y 40 metros],),
  sol: [Para atravesar la ionosfera en lugar de reflejarse en ella hace falta subir por encima de las frecuencias que esta devuelve: los satélites de aficionado trabajan en 2 metros, 70 centímetros y bandas superiores. En HF buena parte de la señal se reflejaría en la ionosfera en vez de atravesarla.])
#pq(3, 1, 25, "b", "", "Ángulo de radiación bajo → distancia de salto más larga",
  [En la propagación ionosférica en HF, cuanto más bajo (más rasante) es el ángulo de radiación de la antena sobre el horizonte:],
  ([más corta es la distancia de salto], [más larga es la distancia de salto], [más baja es la MUF del trayecto], [la distancia de salto no cambia, porque solo depende de la frecuencia],),
  sol: [Un rayo rasante llega a la ionosfera muy inclinado y, tras reflejarse, cae a tierra mucho más lejos: la distancia de salto crece al bajar el ángulo de radiación. Además, cuanto más oblicua es la incidencia, más alta es la MUF ($f_c slash cos theta$), así que la c es falsa. Por eso el DX en HF premia las antenas de ángulo de radiación bajo.])
#pq(3, 1, 26, "d", "T8.19", "Resistencia interna ideal: amperímetro nula, voltímetro infinita",
  [Un amperímetro ideal y un voltímetro ideal tendrían, respectivamente, una resistencia interna:],
  ([infinita e infinita], [nula y nula], [infinita y nula], [nula e infinita],),
  sol: [Cada uno debe perturbar lo mínimo el circuito que mide. El amperímetro va en serie, luego su resistencia debe ser nula para no reducir la corriente; el voltímetro va en paralelo, luego la suya debe ser infinita para no desviar corriente.])
#pq(3, 1, 27, "c", "T8.7", "Osciloscopio: representa la forma de onda en el dominio del tiempo (amplitud y período)",
  [La aplicación más importante del osciloscopio es:],
  ([medir resistencias con gran precisión], [medir la ROE de una antena], [representar gráficamente las formas de onda en la pantalla], [contar los ciclos de una señal digital],),
  sol: [El osciloscopio muestra la forma de onda en el dominio del tiempo: amplitud, período, distorsión, envolvente.])
#pq(3, 1, 28, "a", "T9.20", "Ante una queja: comprobar la propia estación y colaborar",
  [Ante una queja fundada de interferencias procedente de un vecino, lo primero que debe hacer el radioaficionado es:],
  ([comprobar que su estación no produce emisiones no deseadas y colaborar en localizar la causa], [cambiar de banda sin más comprobaciones], [aumentar la potencia para comprobar el efecto], [negar cualquier responsabilidad, si su estación está autorizada],),
  sol: [Estar autorizado no exime de comprobar la propia instalación. Y aunque el problema resulte ser de inmunidad del equipo afectado, la colaboración es lo que resuelve el conflicto — y lo que la responsabilidad social del radioaficionado (tema R7) espera de él.])
#pq(3, 1, 29, "c", "T10.39", "Incendio en equipo eléctrico: cortar la corriente y extintor de CO2 o polvo, nunca agua ni espuma",
  [Ante un conato de incendio en un equipo eléctrico conectado a la red, lo correcto es:],
  ([desconectar únicamente la antena], [arrojar agua abundante sobre el equipo], [cortar la corriente y emplear un extintor adecuado para equipos eléctricos], [abrir el equipo para localizar el componente afectado],),
  sol: [Primero cortar la corriente, porque mientras haya tensión el fuego se realimenta y el agua conduce. Después, extintor apto para equipos eléctricos — de CO#text(size: 0.7em, baseline: 0.22em)[2] o de polvo—, nunca agua.])
#pq(3, 1, 30, "d", "T10.15", "Vientos del mástil: repartidos alrededor y tensados por igual",
  [Respecto de los vientos que sujetan un mástil de antena, es correcto afirmar que:],
  ([basta con uno, siempre que sea de acero], [deben quedar flojos para absorber las rachas], [conviene anclarlos al propio mástil], [deben repartirse alrededor del mástil y tensarse por igual],),
  sol: [Los vientos trabajan por oposición: repartidos alrededor y tensados por igual, mantienen el mástil vertical venga el viento de donde venga. Uno solo, o varios flojos, no sujetan nada; y anclarlos al propio mástil no sujeta absolutamente nada.])
#fin-prueba()
#prueba(3, 2)
#pq(3, 2, 1, "b", "R2.5", "QRZ ¿quién me llama? (la llamada general es CQ, que no es código Q)",
  [El grupo `QRZ` significa:],
  ([llamada general a todas las estaciones], [¿quién me llama?], [mi nombre es…], [la frecuencia está ocupada],),
  sol: [`QRZ`: «¿quién me llama?»; la llamada general es `CQ`, que no es un grupo Q.])
#pq(3, 2, 2, "c", "R2.18", "QRB distancia entre estaciones",
  [El grupo `QRB` se refiere a:],
  ([el número de mensajes pendientes], [la banda de frecuencias empleada], [la distancia que separa a las dos estaciones], [la calidad del tono de la emisión],),
  sol: [«¿A qué distancia se encuentra de mi estación?». De ahí que en concursos y en VHF se hable del _QRB_ de un contacto para referirse a los kilómetros cubiertos.])
#pq(3, 2, 3, "a", "R3.22", "R recibido (conforme)",
  [En telegrafía, la abreviatura `R` transmitida como respuesta significa:],
  ([recibido conforme], [repita el mensaje], [reduzca la potencia], [la estación está en reparación],),
  sol: [Del inglés _roger_: he recibido y entendido lo transmitido. Pedir repetición es `RPT` y reducir potencia, `QRP`.])
#pq(3, 2, 4, "d", "F-R3.5", "Escala de legibilidad: R5 = perfectamente legible (R1 ilegible…)",
  [En la escala de legibilidad (R) del informe #_apc2-m[RST], el valor 5 significa que la señal es:],
  ([ilegible], [legible prácticamente sin dificultad], [legible con considerable dificultad], [perfectamente legible],),
  sol: [La legibilidad (R) va de 1 a 5: 1, ilegible; 2, apenas legible (se distingue alguna palabra suelta); 3, legible con considerable dificultad; 4, legible prácticamente sin dificultad; 5, perfectamente legible. El 5 es, pues, la nota máxima. Los distractores son otros escalones: ilegible es R1, con considerable dificultad es R3 y casi sin dificultad es R4. Por eso el «59» de fonía se lee «legibilidad perfecta, intensidad 9». #vease[(Véase tema R3, tabla «Abreviaturas de procedimiento más habituales» (#_apc2-m[RST]).)] #no-esta[Escala de legibilidad (R) del informe #_apc2-m[RST]: 1, ilegible; 2, apenas legible (se distingue alguna palabra suelta); 3, legible con considerable dificultad; 4, legible prácticamente sin dificultad; 5, perfectamente legible. Es la primera cifra del informe: en «59» el 5 es la legibilidad y el 9, la intensidad.]])
#pq(3, 2, 5, "a", "C-R3.3", "GM buenos días (GA es «adelante»)",
  [Significa «buenos días» utilizando una abreviatura operacional:],
  ([GM], [GA], [BD], [GD],),
  sol: [GM viene del inglés #emph[good morning]: buenos días. GA no es un saludo matutino: en el material del examen significa «adelante» (#emph[go ahead]). BD y GD no son abreviaturas operacionales.

    #no-esta[Los saludos horarios se abrevian con las iniciales de la expresión inglesa: GM (#emph[good morning], buenos días), GE (#emph[good evening], buenas tardes) y GN (#emph[good night], buenas noches). La regla es la G de #emph[good] más la inicial de la parte del día. No figuran en las tablas del cuaderno.]])
#pq(3, 2, 6, "c", "R4.16", "Usar SOS o MAYDAY sin peligro real es infracción sancionable",
  [Emplear las señales de socorro «SOS» o «MAYDAY» sin que exista una situación de peligro constituye:],
  ([una práctica desaconsejada, pero sin consecuencias], [una conducta permitida a efectos de prueba], [una infracción sancionable], [una falta únicamente si se repite],),
  sol: [Las señales de socorro movilizan medios y silencian frecuencias: usarlas en falso está prohibido por la Constitución de la UIT (art. 47) y por el Reglamento de Radiocomunicaciones, es sancionable (la Ley 11/2022 no tiene un tipo específico para ello) y, si moviliza medios de socorro, puede llegar a ser delito (Código Penal, art. 561), además de gravemente irresponsable. Ni siquiera cabe «para probar el equipo».])
#pq(3, 2, 7, "a", "R4.10", "Resolución 640 del RR: bandas de aficionado en socorro por catástrofes naturales",
  [La Resolución 640 del Reglamento de Radiocomunicaciones se refiere al empleo de las bandas de aficionado:],
  ([en comunicaciones de socorro en caso de catástrofes naturales], [exclusivamente en telegrafía], [para enlaces con satélites meteorológicos], [para radiodifusión comercial],),
  sol: [La Res. 640 (CAMR-79, suprimida por la CMR-97) invitaba a las administraciones a prever el uso de las bandas de aficionado en las comunicaciones de socorro cuando una catástrofe natural inutiliza las redes normales. Hoy lo recogen el número 25.9A del Reglamento de Radiocomunicaciones y, para el tráfico de terceros en emergencia o desastre, el 25.3 y el art. 30.3 de la Orden IET/1311/2013. Sigue figurando en el temario (anexo II, parte segunda, punto 4).])
#pq(3, 2, 8, "d", "F-R4.1", "Socorro captado: hacer lo posible para que llegue a la DG de Protección Civil y Emergencias (art. 30.5)",
  [Según la Orden IET/1311/2013, si un radioaficionado capta una comunicación de socorro debe hacer lo posible para que llegue cuanto antes a:],
  ([la Secretaría de Estado de Telecomunicaciones], [la Jefatura Provincial de Inspección de Telecomunicaciones], [la asociación de radioaficionados más próxima], [la Dirección General de Protección Civil y Emergencias, del Ministerio del Interior],),
  sol: [El art. 30.5 de la Orden dice que quien capta una comunicación de socorro *deberá hacer lo posible* para que llegue cuanto antes a la Dirección General de Protección Civil y Emergencias, del Ministerio del Interior. Las otras opciones no figuran en ese artículo: las asociaciones de radioaficionados no son destinatarias; la Jefatura Provincial de Inspección de Telecomunicaciones es la ventanilla de trámites (por ejemplo, la notificación de estaciones portables, art. 17.1); y la Secretaría de Estado de Telecomunicaciones tiene facultades de aplicación y fija los modelos de solicitud (disp. final segunda). #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)] #no-esta[Según el art. 30.5 de la Orden IET/1311/2013, el radioaficionado que capta una comunicación de socorro debe hacer lo posible para que llegue cuanto antes a la Dirección General de Protección Civil y Emergencias, del Ministerio del Interior. Es la misma Dirección General que puede requerir la colaboración de los titulares de autorización en caso de catástrofe (art. 30.4).]])
#pq(3, 2, 9, "b", "R5.1", "Composición del distintivo: prefijo + distrito + sufijo",
  [El distintivo de llamada de una estación de radioaficionado está constituido, secuencialmente, por:],
  ([sufijo, distrito y prefijo], [prefijo, distrito y sufijo], [distrito, prefijo y sufijo], [prefijo, sufijo y distrito],),
  sol: [Prefijo + distrito + sufijo: `EA5RCA` = EA + 5 + RCA.])
#pq(3, 2, 10, "c", "R5.34", "Distritos insulares y ciudades autónomas: 6 Baleares, 8 Canarias, 9 Ceuta y Melilla",
  [Las ciudades de Ceuta y Melilla están identificadas por la cifra de distrito:],
  ([0], [6], [9], [8],),
  sol: [Ambas comparten el distrito 9. Junto con el 6 (Baleares) y el 8 (Canarias), son los que más se preguntan, precisamente por no seguir la lógica peninsular.])
#pq(3, 2, 11, "a", "F-R5.16", "Más de una cifra en el distintivo: acontecimientos relevantes identificados por sus fechas (aniversarios)",
  [Según el artículo 27 de la Orden IET/1311/2013, la utilización de más de una cifra en el distintivo de llamada podrá ser autorizada para:],
  ([acontecimientos relevantes identificados por sus fechas de celebración, como los aniversarios], [radioaficionados que residan habitualmente en más de un distrito], [estaciones automáticas desatendidas que enlacen repetidores de distintos distritos], [la participación en concursos internacionales de alta competitividad],),
  sol: [El art. 27.2 lo permite para acontecimientos relevantes identificados por sus fechas de celebración, tales como acontecimientos periódicos o aniversarios. Es una excepción: el distintivo lleva normalmente una sola cifra, la del distrito de residencia en el momento del otorgamiento (b). Las desatendidas (c) se distinguen por el prefijo #_apc2-m[ED] y por los sufijos que empiezan por Y o Z, no por las cifras. A los concursos de alta competitividad (d) les corresponde el sufijo de una letra. #vease[(Véase tema R5, introducción del capítulo y tabla de distritos.)] #no-esta[Además del distrito 0 (solo para actos inaugurados o visitados por Su Majestad el Rey, y únicamente el día del acto), la Orden permite autorizar más de una cifra en el distintivo para acontecimientos relevantes identificados por sus fechas de celebración, como acontecimientos periódicos o aniversarios (art. 27.2). Es una excepción a la regla de una sola cifra: la del distrito de residencia.]])
#pq(3, 2, 12, "b", "C-R5.3", "Solicitud de distintivo temporal: una por evento, a la Administración; las asociaciones solo proponen",
  [La utilización de distintivos temporales requerirá la presentación de una solicitud; señale la proposición errónea:],
  ([Indicando el nombre y distintivo de llamada del solicitante.], [Dirigida a la Asociación o Radio Club de aficionados correspondiente, que será la que autorice.], [Indicando el período de utilización.], [Indicando el distintivo de llamada solicitado.],),
  sol: [Los distintivos temporales los autoriza la Administración, no una asociación. El artículo 28 de la Orden IET/1311/2013 exige una solicitud independiente para cada evento, con el período de utilización, el distintivo solicitado, el nombre y distintivo del solicitante, el motivo y el tipo de estación; por eso las opciones a, c y d son correctas. La b es la errónea: las asociaciones reconocidas solo pueden preparar planes anuales de utilización y proponer asignaciones, que la Administración estudia y aprueba. #vease[(Véase tema R5, sección «Sufijos y usos temporales».)]

    #no-esta[Distintivos temporales (art. 28 de la Orden IET/1311/2013): cada evento necesita su propia solicitud a la Administración, con período, distintivo pedido, nombre y distintivo del solicitante (firmada por su representante si es una asociación o radio club), motivo y tipo de estación. Como norma general, el período no supera 30 días al año por sufijo y peticionario; los sufijos de una letra para concursos de alta competitividad pueden concederse hasta por dos años. Las asociaciones proponen, no autorizan.]])
#pq(3, 2, 13, "d", "R6.14", "Qué es un plan de bandas: reparto recomendado de cada banda por modo y anchura de banda; instrumento básico de ordenación",
  [Dentro de cada banda, los planes de banda de la IARU reparten los segmentos atendiendo principalmente a:],
  ([el país de procedencia de cada estación], [la potencia de salida de los equipos], [la antigüedad del distintivo de llamada de cada estación], [el modo de emisión y la anchura de banda ocupada],),
  sol: [Se agrupan los modos estrechos por un lado y los anchos por otro, de manera que una emisión de fonía no caiga encima de un segmento de telegrafía o de modos digitales. Es la única forma de que quepan todos.])
#pq(3, 2, 14, "b", "C-R6.1", "Repetidores de 70 cm: entrada 433,000–433,375 MHz, desplazamiento 1,6 MHz",
  [Los planes de banda de la IARU:],
  ([Tienen previstas frecuencias para repetidores digitales en la banda 91,5–95,0 MHz.], [Tienen previstas frecuencias para repetidores en la banda 433,000–433,375 MHz.], [No tienen previstas frecuencias para comunicaciones por satélite.], [No se aplican en países del Hemisferio Sur.],),
  sol: [En 70 cm, el plan de la IARU para la Región 1 reserva 433,000–433,375 MHz a repetidores de FM y de voz digital. La a) falla porque 91,5–95,0 MHz pertenece a la radiodifusión FM, no a una banda de aficionados. La c) es falsa: el plan prevé segmentos para satélites (145,806–146,000 MHz en 2 m, 435–438 MHz en 70 cm). La d) confunde región con hemisferio: los planes se organizan por Regiones de la UIT, y la Región 1 incluye Europa y toda África, también sus países australes, como Sudáfrica. #vease[(Véase tema R6, introducción del capítulo (qué es un plan de bandas y cómo reparte los segmentos).)]

    #no-esta[El cuaderno cita el segmento de repetidores de 2 m, pero no el de 70 cm (430–440 MHz). En esa banda, el plan de la IARU para la Región 1 dedica 433,000–433,375 MHz a repetidores de FM y de voz digital. Ese segmento es el de #emph[entrada] del repetidor, con canales de 25 kHz y un desplazamiento estándar de 1,6 MHz: la salida queda en 434,600–434,975 MHz. Para el examen basta recordar que los 433 MHz son de repetidores y que los 91,5–95,0 MHz, al ser de radiodifusión, no pueden serlo.]])
#pq(3, 2, 15, "a", "R7.18", "Autorización especial que causa interferencias: suspender de inmediato",
  [Si el titular de una autorización especial de emisión comprueba que está produciendo interferencias a otros sistemas, debe:],
  ([suspender de inmediato las transmisiones], [reducir la potencia a la mitad y seguir emitiendo], [continuar hasta agotar el plazo de la autorización], [comunicarlo al finalizar el periodo autorizado],),
  sol: [Las autorizaciones especiales no dan prioridad sobre otros servicios: si se comprueba que se interfiere, se suspende de inmediato y no se reanuda hasta corregir la causa. Es el mismo principio que rige toda la reglamentación de interferencias.])
#pq(3, 2, 16, "c", "F-R8.10", "Ley General de Telecomunicaciones vigente: Ley 11/2022",
  [La Ley General de Telecomunicaciones vigente es:],
  ([la Ley 19/1983, de 16 de noviembre], [la Ley 9/2014, de 9 de mayo], [la Ley 11/2022, de 28 de junio], [la Ley 32/2003, de 3 de noviembre],),
  sol: [La Ley 11/2022, de 28 de junio, derogó la Ley 9/2014 (disposición derogatoria única, apartado a, salvo unas pocas disposiciones residuales), que a su vez había derogado la Ley 32/2003 (disposición derogatoria única, apartado b, de la Ley 9/2014). La Ley 19/1983 no es una ley general de telecomunicaciones: es la «Ley de antenas», que regula el derecho a instalar antenas en el exterior de los inmuebles. Ojo: la Orden IET/1311/2013 cita la Ley 32/2003, y muchos bancos antiguos la 9/2014; eran las vigentes en su época. #_apc3-ver[(Véase tema R8, introducción del tema («tres pisos» normativos).)]])
#pq(3, 2, 17, "d", "C-R8.8", "Nomenclatura de bandas: números, símbolos (HF, VHF, SHF…), rangos y ondas (métricas, B.m.…)",
  [En la nomenclatura de las bandas de frecuencia las ondas métricas se relacionan con:],
  ([La gama de frecuencias de 3 a 30 GHz.], [El símbolo MF.], [La banda número 9.], [La abreviatura métrica B.m.],),
  sol: [Según el anexo I.2 de la Orden IET/1311/2013, las ondas métricas son la banda número 8, de símbolo VHF (30 a 300 MHz) y abreviatura métrica B.m. Las demás opciones son de otras bandas: 3 a 30 GHz es la SHF (centimétricas, B.cm); MF es la banda 6, de ondas hectométricas (B.hm); y la banda 9 es la UHF, de ondas decimétricas (B.dm). Solo la d corresponde a las métricas. #vease[(Véase tema T7, sección «Cómo se nombran las bandas».)]

    #no-esta[Anexo I.2 de la Orden: banda 4 VLF, miriamétricas (B.Mam); 5 LF, kilométricas (B.km); 6 MF, hectométricas (B.hm); 7 HF, decamétricas (B.dam); 8 VHF, métricas (B.m); 9 UHF, decimétricas (B.dm); 10 SHF, centimétricas (B.cm); 11 EHF, milimétricas (B.mm). Truco: la banda número $N$ va de #box[$0,3 times 10^N$] a #box[$3 times 10^N$] Hz (la 8: de 30 a 300 MHz). La abreviatura es B más el símbolo del múltiplo del metro que da nombre a la onda.]])
#pq(3, 2, 18, "d", "C-R8.20", "Extranjero residente: autorización sin examen con HAREC de un país T/R 61-02 o por reciprocidad (residencia acreditada)",
  [Los extranjeros que acrediten la condición de residentes en España podrán ser titulares de autorizaciones de radioaficionado españolas en los siguientes casos, indique la alternativa incorrecta:],
  ([Cuando sean titulares de un certificado HAREC expedido por cualquier país que haya aplicado la Recomendación CEPT T/R 61-02.], [Cuando exista Acuerdo o Convenio de reciprocidad en la materia con el país que otorgó su licencia de radioaficionado original.], [Cuando superen en España la prueba de capacitación para operar estaciones de radioaficionado.], [Siempre que el país de origen del radioaficionado aplique la Recomendación T/R 5000.],),
  sol: [Según el art. 5.2 de la Orden IET/1311/2013, un extranjero residente obtiene la autorización española sin repetir el examen si tiene un certificado HAREC expedido por un país que aplique la T/R 61-02 (opción a) o si hay acuerdo o convenio de reciprocidad con el país que le dio su licencia original (opción b); y, como cualquier aspirante, si supera en España la prueba de capacitación (opción c). La d es la incorrecta: que su país aplique una «Recomendación T/R 5000» no es ningún supuesto del art. 5.2. Las recomendaciones CEPT que cuentan son la T/R 61-01 (licencia CEPT) y la T/R 61-02 (HAREC). El enunciado original citaba el «diploma de operador», figura anterior que hoy equivale al HAREC; la incorrecta es la misma. #vease[(Véase tema R8, sección «Usos especiales y casos particulares».)]

    #no-esta[Art. 5.2 de la Orden IET/1311/2013: el extranjero debe acreditar documentalmente su condición de residente en España. Se le exime de superar la prueba solo en dos casos: a) es titular de un HAREC expedido por un país que haya aplicado la T/R 61-02; b) existe acuerdo o convenio de reciprocidad con el país que otorgó su licencia original. Fuera de esos casos, debe aprobar la prueba de capacitación como cualquier otro aspirante.]])
#pq(3, 2, 19, "b", "R8.61", "No es obligatorio ser socio de una asociación de radioaficionados",
  [Un radioaficionado no está obligado a:],
  ([respetar las bandas atribuidas al servicio], [ser socio de una asociación de radioaficionados], [permitir la inspección de su estación], [identificarse con su distintivo de llamada],),
  sol: [Las asociaciones prestan servicios muy útiles —tramitación, #_r8-cod[QSL], repetidores— pero pertenecer a ellas es voluntario. Identificarse, respetar las bandas y permitir la inspección sí son obligaciones.])
#pq(3, 2, 20, "a", "R8.51", "Se puede tener distintivo (autorización) sin licencia de estación; la licencia solo la necesita la estación fija",
  [La reglamentación vigente permite:],
  ([disponer de distintivo de llamada sin tener licencia de estación], [tener licencia de estación sin autorización de radioaficionado], [emitir sin distintivo de llamada], [usar el distintivo de otro titular sin su permiso],),
  sol: [Se puede tener distintivo (autorización) sin licencia de estación: la licencia solo hace falta para la estación fija con antenas.])
#pq(3, 2, 21, "a", "C-R8.23", "Revocación de la autorización: no se puede emitir; se cancelan el distintivo y la licencia de estación fija asociada",
  [En el Servicio de Aficionados, ¿cuál de las siguientes proposiciones es correcta?],
  ([La revocación de la autorización de radioaficionado lleva aparejada la cancelación de la licencia de la estación fija asociada.], [Todo radioaficionado deberá, como mínimo, esperar cinco años para poder solicitar la cancelación de su autorización.], [La normativa vigente en materia de radioaficionados contempla un límite de edad para poder ser titular de una autorización de radioaficionado.], [El titular de una licencia de estación fija de aficionado siempre precisa autorización previa administrativa para utilizarla como portable.],),
  sol: [Según el art. 21.1.b de la Orden IET/1311/2013, la licencia de estación fija se cancela por revocación o extinción de la autorización de radioaficionado a la que está asociada. Las demás son falsas: la autorización conserva su vigencia mientras el titular no renuncie (art. 5.4), sin plazo mínimo; no hay límite de edad, y el menor solo aporta el escrito fehaciente de sus padres o tutores (art. 19.f); y usar la estación como portable no exige autorización previa, solo notificarlo a la Jefatura Provincial con 5 días de antelación, y ni eso en los usos no continuados de hasta 15 días naturales (art. 17.1). El enunciado original hablaba de «licencias de los equipos»; hoy la licencia es de la estación fija. #vease[(Véase tema R8, secciones «Autorización y licencia de estación» y «Uso de la estación y otras cuestiones».)]

    #no-esta[Art. 21 de la Orden IET/1311/2013: la licencia de estación fija se cancela a) en cualquier momento a petición de su titular; b) por revocación o extinción de la autorización de radioaficionado a la que está asociada; c) automáticamente si no se mantiene vigente el seguro de antenas. Al cancelarse la licencia, el titular debe desmontar la instalación, antenas incluidas, con todos los gastos a su cargo.]])
#pq(3, 2, 22, "c", "R8.59", "Las estaciones están sometidas siempre a la inspección",
  [Las estaciones de aficionado quedan sometidas a la inspección de telecomunicaciones:],
  ([solo si media denuncia de un tercero], [únicamente si superan los 100 vatios], [siempre], [solo durante el primer año desde su autorización],),
  sol: [La sujeción a inspección es permanente y no depende de que haya denuncia, de la antigüedad ni de la potencia: forma parte de las condiciones de la autorización. Negarse u obstruirla constituye infracción grave.])
#pq(3, 2, 23, "b", "R8.26", "Usos experimentales con características distintas de las generales: requieren autorización especial",
  [Las utilizaciones de carácter experimental con características técnicas distintas de las especificadas en el Reglamento:],
  ([están prohibidas en todo caso], [requieren una autorización especial], [solo se permiten a las estaciones colectivas], [están permitidas sin trámite alguno],),
  sol: [Los usos experimentales con características distintas de las reglamentarias requieren autorización especial.])
#pq(3, 2, 24, "d", "R8.68", "Estación fija remota: accionada a distancia",
  [Se entiende por estación fija remota de aficionado aquella que:],
  ([funciona sin necesidad de autorización], [carece de antena exterior], [se instala en un vehículo], [puede ser accionada a distancia por su titular],),
  sol: [Es una estación fija normal salvo en un detalle: su titular la gobierna a distancia. Sigue siendo su responsabilidad cuanto se emita desde ella.])
#pq(3, 2, 25, "d", "F-R8.70", "Noveles: distintivo de la colectiva + 2 o 3 letras tras el sufijo",
  [Según el artículo 30.6 de la Orden IET/1311/2013, cuando personas noveles utilizan esporádicamente una estación colectiva con fines de divulgación, las emisiones se identifican mediante:],
  ([el distintivo personal del radioaficionado que supervisa, sin añadido alguno], [el distintivo de la estación colectiva, sin añadido alguno], [el distintivo de la estación colectiva seguido, tras el sufijo, de una cifra de libre elección], [el distintivo de la estación colectiva seguido, tras el sufijo, de dos o tres letras de libre elección],),
  sol: [El artículo 30.6.c dispone que las emisiones se identifiquen con el distintivo de la estación colectiva seguido, tras el sufijo, de dos o tres letras de libre elección. No basta el distintivo de la colectiva solo (b), ni se emite con el del supervisor (a), ni lo que se añade es una cifra (c): son letras, dos o tres, y van después del sufijo. #_apc3-ver[(Véase tema R8, sección «Uso de la estación y otras cuestiones».)]

#_apc3-net[Art. 30.6 de la Orden IET/1311/2013: las estaciones colectivas pueden usarse esporádicamente, con fines de divulgación, por personas noveles en demostraciones en centros de enseñanza, cursos organizados por la asociación titular y eventos similares sin ánimo de lucro y de corta duración. Condiciones: supervisión directa y presencial de un radioaficionado con al menos tres años de antigüedad; identificación con el distintivo de la colectiva seguido, tras el sufijo, de dos o tres letras libres; y potencia no superior al 40 % del máximo de la banda, con tope de 100 W (p.i.r.e.).]])
#pq(3, 2, 26, "c", "C-R8.7", "Obligaciones del gestor de la desatendida (no le corresponde autorizar su funcionamiento)",
  [Entre las obligaciones del gestor de una estación desatendida no se encuentra la de:],
  ([Actualizar periódicamente la información existente.], [Procurar que el mantenimiento técnico de la estación garantice el servicio continuo de la misma.], [Otorgar la autorización y conformidad del inicio del funcionamiento de la estación.], [Verificar que el tráfico de información se realice conforme a lo previsto por la normativa vigente al respecto.],),
  sol: [El gestor cuida la estación: actualiza la información, procura un mantenimiento que dé servicio continuo y verifica que el tráfico cumple la normativa (a, b, d). Lo que no puede hacer es autorizar el inicio del funcionamiento: es un acto de la Administración. La Jefatura Provincial verifica la instalación y expide la licencia que habilita a empezar las emisiones (arts. 20 y 26 de la Orden IET/1311/2013). Régimen anterior: la figura del gestor era del art. 33 de la Orden ITC/1791/2006, derogada; hoy responde la Junta Directiva de la asociación titular (art. 18.6).

    #no-esta[En el reglamento de 2006 (Orden ITC/1791/2006, art. 33, hoy derogada) cada estación desatendida tenía un gestor designado por la asociación titular. Sus tres obligaciones: verificar que el tráfico se ajusta al reglamento, actualizar periódicamente la información existente y procurar un mantenimiento técnico que garantice el servicio continuo. La Orden IET/1311/2013 atribuye la responsabilidad a la Junta Directiva de la asociación (art. 18.6). Regla de examen: el gestor cuida la estación, nunca la autoriza; autorizar corresponde a la Administración.]])
#pq(3, 2, 27, "b", "R8.34", "Acceso a repetidores: necesariamente libre; si hay código, público y facilitado a quien lo pida",
  [El acceso a los repetidores analógicos y digitales será:],
  ([mediante invitación del gestor], [necesariamente libre y, si tuvieran código de acceso, este deberá hacerse público], [restringido a los socios del club propietario], [de pago],),
  sol: [El acceso a los repetidores es necesariamente libre; si llevan código, debe hacerse público.])
#pq(3, 2, 28, "c", "F-R9.12", "Leve: emisión no autorizada, salvo que sea grave o muy grave",
  [La producción de cualquier tipo de emisión radioeléctrica no autorizada es, según la Ley General de Telecomunicaciones, una infracción:],
  ([muy grave en todo caso], [grave en todo caso], [leve, salvo que deba considerarse grave o muy grave], [que solo se sanciona si llega a causar interferencias],),
  sol: [Lo dice el art. 108.1 de la Ley 11/2022: emitir sin autorización es, como regla, infracción leve (multa de hasta 100.000 euros, art. 109.1.d). La salvedad final importa: si la emisión vulnera los planes de utilización del espectro o el Cuadro Nacional de Atribución de Frecuencias es muy grave (art. 106.6), y si produce interferencias puede pasar a grave (art. 107.6) o muy grave (art. 106.7, si son deliberadas). Por eso «grave en todo caso» y «muy grave en todo caso» son falsas. Tampoco hace falta causar interferencias: la emisión no autorizada ya es infracción por sí misma. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador» (tabla de grados de infracción).)]

#_apc3-net[Infracciones leves del art. 108 de la Ley 11/2022 que afectan al radioaficionado: producir cualquier tipo de emisión radioeléctrica no autorizada (108.1), salvo que deba considerarse grave o muy grave; comunicarse con estaciones no autorizadas (108.2); instalar una estación de radioaficionado careciendo de autorización (108.4); incumplir las condiciones autorizadas (108.5); no facilitar datos a la Administración (108.12). Multa de hasta 100.000 euros (art. 109.1.d). Instalar estaciones radioeléctricas sin la autorización necesaria es, en general, infracción grave (art. 107.1).]])
#pq(3, 2, 29, "c", "R9.6", "Prescripción: 3 años muy graves, 2 graves, 1 leves",
  [La sanción impuesta por una infracción grave prescribe a los:],
  ([seis meses], [cinco años], [dos años], [diez años],),
  sol: [La sanción grave prescribe a los dos años (muy graves: tres años; leves: un año).])
#pq(3, 2, 30, "b", "R9.21", "Titular que sabe que interfiere: medidas técnicas razonables a su costa, sin esperar requerimiento",
  [Si el titular de una estación de aficionado tiene constancia de que está causando interferencias, deberá:],
  ([esperar a que la Administración le requiera formalmente], [adoptar a su costa todas las medidas técnicas razonables para evitarlas], [trasladar el problema a su asociación], [continuar emitiendo mientras no haya denuncia],),
  sol: [La obligación nace en cuanto se tiene constancia, sin esperar requerimiento, y el coste corre por cuenta del titular: es él quien explota la estación. El art. 32 de la Orden fija el protocolo: si la SETSI comprueba la interferencia perjudicial, el titular debe cesar las emisiones y adoptar a su costa medidas técnicas razonables, siguiendo sus instrucciones; después lo comunica y puede reiniciar las emisiones sin más trámite, y si la interferencia persiste la SETSI puede imponer restricciones de bandas, potencia u horario.])
#fin-prueba()
#soluciones-simulacro(3)

// ======================================================================
#simulacro(4)
#prueba(4, 1)
#pq(4, 1, 1, "a", "T1.11", "La batería convierte energía química en eléctrica",
  [Una batería eléctrica es un dispositivo que convierte:],
  ([energía química en energía eléctrica], [energía mecánica en energía eléctrica], [energía eléctrica en energía luminosa], [energía térmica en energía química],),
  sol: [La batería convierte energía química en eléctrica (y al cargarla, a la inversa). De ahí que se agote: la reacción química se consume.])
#pq(4, 1, 2, "d", "T1.39", "Valor eficaz: definición por el efecto calorífico; la tensión de red se da en eficaz",
  [Se llama valor eficaz de una corriente alterna:],
  ([el valor máximo que alcanza en cada ciclo], [el valor que marca un osciloscopio entre pico y pico], [la media aritmética de todos sus valores instantáneos], [el de la corriente continua que produciría el mismo efecto calorífico],),
  sol: [El valor eficaz se define por su efecto: es la continua equivalente en producción de calor. Para una senoide vale $V_"máx" slash sqrt(2)$, y es lo que miden los instrumentos y lo que significan los 230 V de la red.])
#pq(4, 1, 3, "c", "T1.44", "En un circuito resistivo, tensión e intensidad están en fase",
  [En un circuito puramente resistivo recorrido por corriente alterna, la tensión y la intensidad:],
  ([están en oposición de fase], [están desfasadas 90°], [están en fase], [tienen frecuencias distintas],),
  sol: [Sin reactancias no hay desfase: la corriente sigue instantáneamente a la tensión y ambas pasan a la vez por cero y por sus máximos. El desfase de 90° aparece con bobinas o condensadores puros.])
#pq(4, 1, 4, "a", "F-T1.14", "Potencia de AM: P_t = P_c (1 + m²/2), reparto entre portadora y bandas",
  [Un transmisor de AM tiene una potencia de portadora de 100 W. Modulado al 100 %, la potencia total de la emisión es de:],
  ([150 W], [200 W], [125 W], [100 W],),
  sol: [Con $m = 1$: $P_t = P_c (1 + m^2/2) = 100 times 1,5 = 150$ W. Se reparten así: 100 W en la portadora y $m^2/4 P_c = 25$ W en cada banda lateral (100 + 25 + 25). Los 200 W suponen que modular duplica la potencia; los 125 W cuentan una sola banda lateral; y los 100 W son solo la portadora, sin las bandas laterales que aparecen al modular. _(Véase tema T1, sección «Señales moduladas».)_])
#pq(4, 1, 5, "a", "F-T1.42", "Teorema de Nyquist: f_s ≥ 2 f_máx",
  [Un conversor A/D muestrea una señal a 8 kHz. La frecuencia máxima de la señal que se puede digitalizar sin aliasing es de:],
  ([4 kHz], [2 kHz], [16 kHz], [8 kHz],),
  sol: [El teorema de Nyquist exige $f_s >= 2 f_"máx"$, luego $f_"máx" <= f_s slash 2 = 8 slash 2 = 4$ kHz. Lo que supere los 4 kHz se plegaría sobre la banda útil (_aliasing_). Los 8 kHz confunden la frecuencia de muestreo con la máxima de la señal; los 16 kHz aplican el factor 2 en sentido contrario (es el muestreo el que debe ser el doble, no la señal); y los 2 kHz dividen entre 2 dos veces. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_])
#pq(4, 1, 6, "c", "T2.59", "Descarga segura de un condensador a través de un elemento exterior",
  [Para descargar con seguridad un condensador se debe:],
  ([esperar a que se descargue solo], [golpearlo suavemente], [conectar sus dos armaduras a través de un elemento exterior], [invertir su polaridad],),
  sol: [Se cortocircuitan las armaduras a través de una resistencia adecuada, con un útil aislado y nunca con la mano. La descarga directa con un destornillador es brusca y puede dañar el condensador — y a quien lo sostiene.])
#pq(4, 1, 7, "d", "T2.60", "El transformador también sirve para adaptar impedancias",
  [Además de elevar o reducir tensiones, los transformadores se emplean para:],
  ([la generación de armónicos], [la rectificación de la corriente alterna], [el almacenamiento de energía en continua], [la adaptación de impedancias entre dos circuitos],),
  sol: [Como la relación de tensiones va con el número de espiras y la de corrientes al revés, la impedancia vista desde el primario queda multiplicada por el cuadrado de la relación de transformación. Es lo que permite acoplar una etapa de salida a una carga de impedancia distinta.])
#pq(4, 1, 8, "d", "T2.23", "Transistor bipolar: terminales emisor, base y colector; tipos NPN y PNP",
  [Los tres terminales de un transistor bipolar son:],
  ([ánodo, cátodo y rejilla], [primario, secundario y núcleo], [puerta, fuente y drenador], [emisor, base y colector],),
  sol: [El BJT tiene emisor, base y colector; puerta, fuente y drenador son del FET.])
#pq(4, 1, 9, "b", "C-T2.22", "Símbolos de resistencia, condensador, bobina y diodo",
  [¿Cuál de los siguientes símbolos es el de la resistencia?],
  ([#box(baseline: 45%, esquema(escala: 0.75, {
      import zap: *
      import cetz.draw: *
      inductor("l1", (-1.1, 0), (1.1, 0))
      line((2.0, 0), (2.4, 0), stroke: 0.8pt)
      rect((2.4, -0.2), (3.6, 0.2), fill: black, stroke: none)
      line((3.6, 0), (4.0, 0), stroke: 0.8pt)
    }))], [#box(baseline: 45%, esquema(escala: 0.75, {
      import zap: *
      import cetz.draw: *
      line((-1.1, 0), (-0.8, 0), (-0.6, 0.35), (-0.2, -0.35), (0.2, 0.35), (0.6, -0.35), (0.8, 0), (1.1, 0), stroke: 0.8pt)
      resistor("r1", (2.0, 0), (4.0, 0))
    }))], [#box(baseline: 45%, esquema(escala: 0.75, {
      import zap: *
      import cetz.draw: *
      capacitor("c1", (-1.1, 0), (1.1, 0))
      pcapacitor("c2", (2.0, 0), (4.2, 0))
      content((3.45, 0.45), text(size: 7pt)[+])
    }))], [#box(baseline: 45%, esquema(escala: 0.75, {
      import zap: *
      import cetz.draw: *
      diode("d1", (-1.2, 0), (1.2, 0))
    }))],),
  sol: [
    La resistencia tiene dos símbolos equivalentes: el zigzag de la norma americana y el rectángulo
    vacío de la europea (IEC); ambos aparecen en la opción b). La a) muestra dos bobinas: el muelle
    de espiras y el rectángulo relleno (las bobinas se dibujan con espiras o con un rectángulo
    macizo, no vacío). La c) son condensadores, dos placas paralelas (la segunda variante, con una
    placa rellena y un signo más, es el electrolítico, con polaridad). La d) es un diodo: un
    triángulo contra una barra. #vease[(Véase tema T2, sección «Resistencias» y «Preguntas sobre
    símbolos».)]
    #no-esta[Símbolos de los componentes pasivos: #strong[resistencia], zigzag (americano) o rectángulo vacío
    (europeo); #strong[condensador], dos placas paralelas (en el electrolítico, una placa rellena y
    un signo + que marca la polaridad); #strong[bobina], varias espiras en forma de muelle o, en la
    norma europea, un rectángulo relleno. El truco: rectángulo vacío, resistencia; rectángulo
    macizo, bobina.]
  ])
#pq(4, 1, 10, "c", "F-T3.40", "Condensador real: por encima de su autorresonancia se comporta como una bobina",
  [Por encima de su frecuencia de autorresonancia, un condensador real se comporta como:],
  ([un condensador ideal de mayor capacidad], [una resistencia pura], [una bobina], [un circuito abierto],),
  sol: [Las patas y las armaduras de un condensador real tienen inductancia en serie. A baja frecuencia domina su reactancia capacitiva $X_C = 1/(2 pi f C)$; al subir, $X_C$ disminuye y $X_L = 2 pi f L$ crece hasta igualarse: es la frecuencia de autorresonancia, donde el componente es casi una resistencia pura y muy pequeña. Por encima manda la inductancia y el condensador se comporta como una bobina, por lo que deja de desacoplar. El circuito abierto (d) es el comportamiento del condensador ideal en continua, no el de uno real por encima de su autorresonancia. _(Véase tema T3, sección «Asociación de componentes y resonancia».)_])
#pq(4, 1, 11, "b", "F-T3.46", "Filtro RC: fc = 1/(2πRC)",
  [La frecuencia de corte de un filtro RC de paso bajo formado por una resistencia de 10 kΩ y un condensador de 10 nF es aproximadamente de:],
  ([160 Hz], [1,6 kHz], [10 kHz], [16 kHz],),
  sol: [Se aplica $f_c = 1/(2 pi R C)$ con $R = 10^4$ Ω y $C = 10^(-8)$ F: $f_c = 1/(2 pi times 10^4 times 10^(-8)) = 1/(6,28 times 10^(-4)) approx 1590$ Hz, es decir, 1,6 kHz. Los 10 kHz salen de olvidar el $2 pi$ ($1 slash R C$). Los 160 Hz y los 16 kHz son errores de una potencia de diez al pasar los nanofaradios a faradios. En $f_c$ la salida cae a −3 dB (el 70,7 % de la tensión) y, por encima, el filtro atenúa 6 dB por octava. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_])
#pq(4, 1, 12, "c", "T3.35", "Número de diodos: media onda 1; onda completa con toma media 2; puente 4",
  [Un rectificador de onda completa en puente necesita como mínimo:],
  ([dos diodos], [un diodo], [cuatro diodos], [seis diodos],),
  sol: [El puente los coloca en rombo, de modo que en cada semiciclo conducen dos en diagonal y la carga recibe siempre la misma polaridad: de ahí los cuatro diodos. Nota: el enunciado dice «en puente». Sin esa precisión, el mínimo de un rectificador de onda completa es de dos diodos (con un transformador de toma media en el secundario); con uno solo se rectifica media onda.])
#pq(4, 1, 13, "a", "F-T3.10", "Fuente conmutada: genera ruido de RF (QRM en HF); exige filtrado y apantallado",
  [En una estación de radioaficionado, el principal riesgo de una fuente conmutada mal filtrada o mal apantallada es que:],
  ([genera ruido e interferencias de radiofrecuencia que se oyen como QRM en HF], [no admite cargas de más de 1 A], [su transformador de alta frecuencia no aísla la salida de la red], [necesita un transformador de 50 Hz mayor que el de una fuente lineal],),
  sol: [La conmutación rápida, con flancos muy abruptos, genera armónicos que llegan a HF y entran al receptor por el cable de red, por los de alimentación o por el aire. Se combate con filtros en la entrada y en la salida, ferritas, apantallado y cables cortos (compatibilidad electromagnética). No hay límite de 1 A: se construyen de decenas de amperios. El transformador de alta frecuencia sí aísla la salida de la red, y es pequeño, no un transformador de 50 Hz. _(Véase tema T3, sección «Fuentes de alimentación y amplificadores» (ruido de conmutación, filtrado y apantallamiento; ver también el tema T9).)_])
#pq(4, 1, 14, "c", "C-T3.18", "Colector común = seguidor de emisor (ganancia de tensión ≈ 1; adaptador de impedancias)",
  [Un circuito con un transistor montado en colector común se denomina también:],
  ([Colector par], [Colector mixto], [Seguidor emisor], [Colector seguidor.],),
  sol: [
    En colector común la señal entra por la base y sale por el emisor, cuya tensión «sigue» a la de
    la base (menos unos 0,6 V): de ahí el nombre de seguidor de emisor. Tiene ganancia de tensión
    próxima a 1, ganancia de corriente alta, impedancia de entrada alta e impedancia de salida baja,
    por lo que se usa como adaptador de impedancias. «Colector mixto», «colector par» y «colector
    seguidor» no son denominaciones reales. #vease[(Véase tema T2, sección «Semiconductores y otros
    componentes».)]
  ])
#pq(4, 1, 15, "d", "T4.30", "La sensibilidad (figura de ruido) la determina la primera etapa de RF (Friis)",
  [La sensibilidad de un receptor viene determinada fundamentalmente por:],
  ([la tensión de alimentación], [el tamaño del altavoz], [la potencia del amplificador de audio], [su primera etapa de radiofrecuencia],),
  sol: [El ruido que añade la primera etapa se amplifica después junto con la señal, así que su figura de ruido condiciona toda la cadena — es lo que expresa la fórmula de Friis. Mejorar etapas posteriores apenas sirve si la primera es ruidosa.])
#pq(4, 1, 16, "b", "T4.21", "RIT: varía la frecuencia de recepción sin tocar la de transmisión",
  [El mando RIT de un transceptor permite:],
  ([ajustar la ganancia de radiofrecuencia], [variar la frecuencia de recepción sin alterar la de transmisión], [reducir el ruido de impulsos], [conmutar entre banda lateral superior e inferior],),
  sol: [Del inglés _receiver incremental tuning_. Permite corregir a la estación corresponsal que llega ligeramente desplazada sin moverse uno de la frecuencia en que transmite, de modo que los demás nos sigan oyendo donde esperan.])
#pq(4, 1, 17, "a", "T5.17", "Compresor: eleva la potencia media sin superar la de pico",
  [El compresor de audio de un transmisor de SSB sirve para:],
  ([elevar la potencia media de la emisión sin superar la potencia de pico], [ensanchar la banda de audio transmitida], [suprimir el ruido de fondo del micrófono], [aumentar la potencia de pico del equipo],),
  sol: [La voz tiene picos altos y valles bajos, y el transmisor está limitado por el pico. El compresor sube los valles sin tocar los picos: sube la potencia media, que es la que se oye al otro lado, con el mismo equipo y sin sobremodular.])
#pq(4, 1, 18, "a", "T5.13", "Anchura de banda necesaria: la justa para la velocidad y calidad requeridas",
  [La anchura de banda necesaria de un transmisor es:],
  ([la suficiente para permitir la transmisión a la velocidad y con la calidad requeridas], [independiente del tipo de emisión], [la mitad de la anchura del canal], [siempre la máxima que permita el equipo],),
  sol: [La anchura de banda necesaria es la justa para transmitir con la velocidad y calidad requeridas: ni más (desperdicia espectro e interfiere) ni menos (degrada la señal).])
#pq(4, 1, 19, "d", "", "Desplazamiento del repetidor en 2 m: entrada 600 kHz por debajo de la salida",
  [En la banda de 2 metros, la frecuencia de entrada de un repetidor (en la que transmiten los usuarios) está, respecto a su frecuencia de salida:],
  ([en la misma frecuencia, porque el repetidor recibe y transmite a la vez], [600 kHz por encima], [6 MHz por debajo], [600 kHz por debajo],),
  sol: [En 2 m el repetidor recibe 600 kHz por debajo de la frecuencia en la que retransmite: por ejemplo, entrada en 145,000 MHz y salida en 145,600 MHz. No puede usar la misma frecuencia, porque su propio transmisor taparía lo que recibe: trabaja en dúplex.])
#pq(4, 1, 20, "b", "T6.37", "Yagi: los elementos parásitos no están alimentados y dan la directividad",
  [En una antena Yagi, los elementos parásitos:],
  ([sirven únicamente de soporte mecánico], [proporcionan directividad a la antena], [sustituyen al elemento radiante], [van conectados a la línea de transmisión],),
  sol: [No están conectados a la línea: reciben energía por inducción del elemento alimentado y la reirradian con una fase distinta, de modo que las ondas se refuerzan hacia delante y se cancelan hacia atrás. De ahí la directividad.])
#pq(4, 1, 21, "c", "C-T6.18", "Antenas de apertura: bocina y reflector parabólico (no las de hilo)",
  [Entre las antenas de apertura están:],
  ([Las yagis.], [Las verticales.], [Las de bocina.], [Los dipolos.],),
  sol: [
    Las antenas de apertura radian a través de una abertura (una boca) por la que sale el campo: la
    bocina, el reflector parabólico con su alimentador, la guía ranurada. Se emplean en microondas,
    donde las dimensiones de la apertura son manejables. Las Yagis, las verticales y los dipolos
    son, en cambio, antenas de hilo, formadas por elementos lineales. #vease[(Véase tema T6, sección
    «El dipolo y otras antenas».)]
  ])
#pq(4, 1, 22, "c", "T6.42", "Factor de velocidad: la onda va más despacio en la línea; FV = 1/√εr < 1",
  [El factor de velocidad de un cable coaxial se relaciona con la constante dieléctrica $epsilon_r$ de su aislante mediante:],
  ([el producto por $epsilon_r$], [una relación independiente del dieléctrico], [la inversa de la raíz cuadrada de $epsilon_r$], [la raíz cuadrada de $epsilon_r$],),
  sol: [$v_f = 1\/sqrt(epsilon_r)$. Un polietileno macizo, con $epsilon_r approx 2,3$, da un factor de velocidad de unos 0,66: la onda viaja al 66 % de la velocidad de la luz.])
#pq(4, 1, 23, "a", "T7.10", "HF: propagación por reflexión ionosférica, la del DX (España–Nueva Zelanda)",
  [Un enlace radioeléctrico entre España y Nueva Zelanda podría establecerse empleando:],
  ([una frecuencia de HF que se refleje en la ionosfera], [exclusivamente la onda de superficie en VHF], [una frecuencia de microondas por conducto troposférico], [una frecuencia de UHF con visión directa],),
  sol: [$tilde 19 000$ km solo son viables por reflexión ionosférica múltiple en HF, con una frecuencia que la ionosfera refleje en ese momento (por debajo de la MUF del trayecto).])
#pq(4, 1, 24, "b", "F-T7.13", "Frecuencia óptima de trabajo ≈ 85 % de la MUF",
  [Si la MUF de un trayecto es de 20 MHz, la frecuencia óptima de trabajo (FOT) es aproximadamente de:],
  ([12 MHz], [17 MHz], [20 MHz], [24 MHz],),
  sol: [La frecuencia óptima de trabajo es aproximadamente el 85 % de la MUF: FOT ≈ 0,85 × 20 = 17 MHz. Se trabaja algo por debajo de la MUF para tolerar las fluctuaciones de la ionosfera, que en un momento dado pueden bajarla y cortar el enlace. 20 MHz sería la propia MUF, sin margen; 24 MHz sale de dividir entre 0,85 en vez de multiplicar, y 12 MHz de aplicar un 60 % que no es el de la regla. #vease[(Véase tema T7, sección «La ionosfera y la onda de espacio».)]])
#pq(4, 1, 25, "b", "F-T7.17", "El conducto troposférico se da en VHF y UHF, con alcances de cientos de kilómetros",
  [La propagación por conducto troposférico se aprovecha sobre todo en:],
  ([HF, con contactos intercontinentales por reflexión en la capa F], [VHF y UHF, con alcances de cientos de kilómetros, muy superiores al horizonte visual], [MF, con un alcance limitado a la onda de superficie], [VHF y UHF, pero solo para comunicaciones locales de pocos kilómetros],),
  sol: [El conducto es una capa de aire en la que la onda queda atrapada y guiada, como en una guía de ondas natural. Funciona con VHF, UHF y frecuencias superiores, y permite contactos de varios cientos de kilómetros, bastante más allá del horizonte visual, aunque de forma esporádica. La HF (a) llega lejos por reflexión en la ionosfera, no en la troposfera; en MF (c) domina la onda de superficie; y el alcance de pocos kilómetros (d) es el normal sin conducto, justo el que este supera. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]])
#pq(4, 1, 26, "d", "F-T8.9", "Influencia de la frecuencia: un polímetro común no sirve para medir tensiones de RF",
  [Un polímetro de uso general no es adecuado para medir tensiones de radiofrecuencia porque:],
  ([solo puede medir corriente continua], [su resistencia interna es tan baja que cortocircuita la señal], [la radiofrecuencia no produce ninguna tensión medible], [su respuesta en frecuencia en alterna es muy limitada (pocos llegan a decenas de kHz) y la lectura deja de ser fiable],),
  sol: [La escala de alterna de un polímetro común está pensada para la red y el audio: su respuesta en frecuencia es limitada y, al subir, la lectura pierde exactitud hasta dejar de tener sentido; pocos llegan siquiera a decenas de kHz. Para RF se usan sondas detectoras o voltímetros de RF específicos. Sí mide alterna (a), la RF produce tensiones perfectamente medibles (c) y su resistencia interna es alta, no baja (b), unos 10 MΩ en el digital. #vease[(Véase tema T8, sección «Técnica de medida».)]])
#pq(4, 1, 27, "b", "C-T8.3", "El dBm y el dBW son unidades de potencia",
  [La unidad dBm corresponde a la magnitud:],
  ([intensidad], [potencia], [tensión], [frecuencia],),
  sol: [
    El dBm es el decibelio referido a 1 mW: $P ("dBm") = 10 log_10 P / (1 "mW")$. Es, pues, una
    unidad de potencia (1 mW = 0 dBm; 1 W = 30 dBm). La frecuencia se mide en hercios y la
    intensidad en amperios; la tensión, si se expresa en decibelios, va en dBV o dBμV, no en dBm.
    #vease[(Véase tema T8, sección «Técnica de medida».)]
  ])
#pq(4, 1, 28, "d", "T9.18", "Una buena tierra reduce la RF en los chasis y las interferencias",
  [Una buena instalación de tierra en la estación contribuye a:],
  ([mejorar la selectividad del receptor], [elevar la potencia de salida del transmisor], [aumentar la ganancia de la antena], [reducir la radiofrecuencia presente en los chasis y las interferencias asociadas],),
  sol: [Una tierra deficiente deja que la RF vuelva por donde puede —los chasis, los cables de alimentación, el micrófono— y desde ahí se acople a todo lo que haya cerca. La tierra le da un camino corto y directo. De paso, es la misma tierra que protege al operador (tema T10).])
#pq(4, 1, 29, "c", "T10.2", "Una antena que transmite no se toca (quemaduras de RF)",
  [Una antena que está transmitiendo:],
  ([puede tocarse si está polarizada verticalmente], [solo puede tocarse con guantes de lana], [no se debe tocar con las manos], [puede tocarse si la potencia es inferior a 100 W],),
  sol: [Una antena en transmisión lleva RF de alta tensión en los extremos: tocarla produce quemaduras por radiofrecuencia.])
#pq(4, 1, 30, "a", "T10.17", "Accidente eléctrico: lo primero es cortar la corriente",
  [Al producirse un accidente por electricidad, la primera medida que debe tomarse es:],
  ([cortar la corriente eléctrica], [practicar la respiración artificial a la víctima], [apartar a la víctima tirando de su ropa], [dar de beber a la víctima],),
  sol: [Mientras haya tensión, quien se acerque se convierte en la segunda víctima. Primero se corta la corriente; solo después se atiende al accidentado.])
#fin-prueba()
#prueba(4, 2)
#pq(4, 2, 1, "a", "R1.10", "Sufijo CID: C Charlie, I India (no «Italia»), D Delta (no «Dog»)",
  [El sufijo `CID` se deletrea:],
  ([Charlie India Delta], [Charlie Italia Delta], [Charlie India Dog], [Cid India Delta],),
  sol: [`CID` = _Charlie India Delta_; «Italia» y «Dog» pertenecen a otros alfabetos.])
#pq(4, 2, 2, "b", "R2.29", "QRM (interferencia de otras estaciones) frente a QRN (parásitos atmosféricos)",
  [Para indicar que se están sufriendo parásitos atmosféricos se emplea el grupo:],
  ([`QRK`], [`QRN`], [`QRM`], [`QSB`],),
  sol: [`QRN` son los parásitos atmosféricos: tormentas, estática. Regla para no confundirlos: la _N_ de _natural_ frente a la _M_ de _man made_.])
#pq(4, 2, 3, "a", "R2.4", "QSY cambie de frecuencia",
  [Para indicar a la estación corresponsal que cambie de frecuencia se emplea el grupo:],
  ([`QSY`], [`QSL`], [`QRX`], [`QRT`],),
  sol: [`QSY`: «cambie de frecuencia»; `QRT` es cesar y `QRX` esperar.])
#pq(4, 2, 4, "b", "R2.23", "QSV transmita una serie de V",
  [El grupo `QSV` se emplea para pedir que se transmita:],
  ([la señal de socorro], [una serie de letras V para ajustar la recepción], [un mensaje de prueba de cinco palabras], [el distintivo de llamada tres veces],),
  sol: [La V en Morse (· · · −) es inconfundible y de ritmo muy marcado, ideal para ajustar la sintonía y el filtro del receptor.])
#pq(4, 2, 5, "a", "R3.33", "ABT aproximadamente y VY muy",
  [La abreviatura `ABT` significa:],
  ([aproximadamente], [abierto], [a bordo], [abandono la transmisión],),
  sol: [Contracción de _about_. Sirve para dar un dato aproximado, como la distancia o la potencia, sin comprometerse con una cifra exacta.])
#pq(4, 2, 6, "c", "C-R3.2", "BUG manipulador semiautomático",
  [Es una abreviatura operacional y significa manipulador semiautomático:],
  ([TXT], [PLUG], [BUG], [CUL],),
  sol: [BUG designa el manipulador semiautomático: una llave telegráfica mecánica que fabrica sola los puntos y deja las rayas a mano del operador. Los distractores no encajan: CUL es «hasta luego» (#emph[see you later]), TXT es «texto» y PLUG (enchufe) no es una abreviatura operacional.

    #no-esta[Un #emph[bug] (la marca clásica es Vibroplex) es un manipulador semiautomático: al empujar la paleta hacia un lado, un mecanismo de péndulo genera automáticamente una serie de puntos, mientras que las rayas se hacen a mano empujando hacia el otro lado. No es el manipulador vertical (la llave simple de subir y bajar) ni el #emph[keyer] electrónico, que genera automáticamente tanto los puntos como las rayas. La abreviatura no figura en las tablas del cuaderno.]])
#pq(4, 2, 7, "c", "C-R3.4", "NR número",
  [Si se utiliza una abreviatura operacional, NR significa:],
  ([Receptor.], [No hay respuesta.], [Número.], [Corte de transmisión.],),
  sol: [NR es la abreviatura de #emph[number]: «número» (de orden, de serie o de mensaje). Los distractores corresponden a otras abreviaturas: «receptor» es RX y «corte de transmisión» es BK; «no hay respuesta» no corresponde a ninguna abreviatura operacional.

    #no-esta[NR (del inglés #emph[number]) significa «número»: se usa, por ejemplo, para dar el número de orden de un mensaje o el número de serie que se intercambia en un concurso. Sigue el mismo patrón de recorte que RX (receptor) y TX (transmisor): las consonantes de la palabra inglesa. No figura en las tablas del cuaderno.]])
#pq(4, 2, 8, "b", "R4.4", "Contenido del mensaje de socorro: identificación, posición, naturaleza del peligro (nunca «Sécurité»)",
  [Un mensaje de socorro NO incluirá:],
  ([la naturaleza del peligro], [la señal de seguridad «Sécurité»], [la posición de la estación en peligro], [la identificación de la estación en peligro],),
  sol: [El mensaje de socorro lleva identificación, posición y naturaleza del peligro; «Sécurité» es de otra categoría (tabla del libro).])
#pq(4, 2, 9, "a", "F-R4.14", "Banda de 23 cm: 1240–1300 MHz",
  [La banda de 23 cm atribuida al Servicio de Aficionados en España comprende:],
  ([1240 a 1300 MHz], [1300 a 1400 MHz], [1200 a 1400 MHz], [1000 a 1240 MHz],),
  sol: [El Anexo I de la Orden (apartado 3.1) recoge la banda de 23 cm como 1240 a 1300 MHz, y el CNAF la atribuye a los aficionados a título secundario. «1200 a 1400» es un rango demasiado ancho: la banda solo mide 60 MHz. «1300 a 1400» empieza donde ella acaba, y «1000 a 1240» termina donde ella empieza: ambas quedan fuera. Como es secundaria, los aficionados no deben causar interferencia a los servicios primarios ni reclamar protección frente a ellos. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]])
#pq(4, 2, 10, "d", "F-R5.7", "Qué es el distintivo: señal de identificación que identifica al titular desde cualquier punto del territorio (no al equipo ni al domicilio)",
  [Conforme al artículo 27 de la Orden IET/1311/2013, el distintivo de llamada asociado a una autorización de radioaficionado identifica:],
  ([al equipo transmisor, con independencia de quién lo utilice], [a la asociación de radioaficionados a la que pertenece el titular], [a su titular solo cuando emite desde el domicilio consignado en la autorización], [a su titular en las emisiones que efectúe desde cualquier punto del territorio nacional],),
  sol: [El primer párrafo del art. 27 dice que cada autorización lleva asociado un distintivo que identifica a su titular en las emisiones que efectúe desde cualquier punto del territorio nacional. No identifica al aparato (a): el distintivo va con la persona, no con el equipo. La asociación (b) no tiene distintivo personal; solo sus estaciones colectivas llevan uno propio. Tampoco está ligado al domicilio (c): es único y no puede modificarse (art. 28), así que no cambia al mudarse de distrito y vale en estación fija, móvil o portable. #vease[(Véase tema R5, sección «Asignación y uso del distintivo».)] #no-esta[El distintivo de llamada va asociado a la autorización y no al equipo: identifica a su titular en las emisiones que efectúe desde cualquier punto del territorio nacional (art. 27). Por eso es único, no cambia al mudarse de distrito (art. 28) y se transmite al comienzo y al final de cada emisión (art. 29.1). Solo las estaciones colectivas llevan un distintivo específico para cada una.]])
#pq(4, 2, 11, "d", "R5.12", "El distintivo tiene como máximo seis caracteres",
  [El distintivo de llamada estará constituido por un grupo alfanumérico de, como máximo:],
  ([diez caracteres], [ocho caracteres], [cuatro caracteres], [seis caracteres],),
  sol: [Grupo alfanumérico de seis caracteres como máximo.])
#pq(4, 2, 12, "b", "R5.36", "Distrito 0: solo para actos inaugurados o visitados por el Rey",
  [En un distintivo de llamada, la cifra 0 podrá autorizarse exclusivamente:],
  ([a las estaciones de las asociaciones], [con motivo de actos inaugurados o visitados por Su Majestad el Rey], [a los titulares con más de veinticinco años de antigüedad], [a las estaciones desatendidas],),
  sol: [Es la única excepción a la numeración geográfica: la cifra 0 no identifica zona alguna, sino la relevancia del acto. De ahí que sea un distintivo excepcional y siempre temporal.])
#pq(4, 2, 13, "d", "C-R5.20", "Distritos peninsulares: asignar provincia a su cifra y leer la cifra de un distintivo",
  [¿A cuál de las siguientes provincias pertenece el distintivo EA5EYR?],
  ([Zaragoza], [Zamora], [Almería], [Valencia],),
  sol: [La cifra del distintivo es el distrito de residencia del titular cuando se le otorgó la autorización. El distrito 5 agrupa Valencia, Alicante, Castellón, Murcia y Albacete (art. 27 de la Orden IET/1311/2013); de las provincias propuestas, solo Valencia está en él. Zaragoza es del distrito 2, Zamora del 1 y Almería del 7. Las letras EYR son el sufijo y no indican provincia. #vease[(Véase tema R5, tabla «Distritos de los distintivos de llamada españoles».)]])
#pq(4, 2, 14, "c", "R6.4", "Los planes parten de las atribuciones del Reglamento de Radiocomunicaciones y hay uno por Región de la UIT",
  [Los planes de banda de la IARU pueden:],
  ([aplicarse solo los fines de semana], [modificarse por cada radio club local], [ser distintos en cada Región de la UIT], [ignorarse en los concursos internacionales],),
  sol: [Cada Región de la UIT tiene su propio plan IARU, porque las atribuciones difieren entre Regiones.])
#pq(4, 2, 15, "b", "F-R6.7", "Convenio de banda lateral: LSB por debajo de 10 MHz, USB por encima; excepción 60 m en USB",
  [El plan de bandas HF de la IARU para la Región 1 recomienda LSB en fonía por debajo de 10 MHz y USB por encima. Como excepción, en la banda de 60 m (5 MHz) recomienda para la fonía:],
  ([LSB], [USB], [AM], [FM],),
  sol: [La regla general del plan es LSB por debajo de 10 MHz (160, 80 y 40 m) y USB por encima (20, 17, 15, 12 y 10 m). La banda de 5 MHz es la excepción expresa: se recomienda USB para la voz, en el segmento 5.354– 5.366 kHz. La a) es lo que daría la regla general y por eso es el error típico. La AM y la FM ocupan más anchura que los 2.700 Hz máximos de ese segmento y no son los modos que recomienda el plan. #vease[(Véase tema T1, sección «Señales moduladas» (banda lateral única); tema R3, abreviaturas LSB y USB.)] #no-esta[Por convenio, en SSB se usa la banda lateral inferior (LSB) por debajo de 10 MHz (160, 80 y 40 m) y la superior (USB) por encima (20, 17, 15, 12 y 10 m). El plan de bandas HF de la IARU para la Región 1 lo recoge como recomendación y señala una excepción: la banda de 60 m (5 MHz, 5.351,5–5.366,5 kHz), donde se recomienda USB para la fonía.]])
#pq(4, 2, 16, "a", "R7.5", "Prohibidos fines comerciales, publicitarios o lucrativos; permitidos mensajes técnicos sobre ensayos",
  [De las siguientes acciones, está permitida en el tráfico entre estaciones de aficionado:],
  ([transmitir mensajes de naturaleza técnica sobre ensayos], [transmitir propaganda electoral], [emitir anuncios de productos con fines lucrativos], [emitir con el distintivo de otro radioaficionado sin su permiso],),
  sol: [Mensajes técnicos sobre ensayos: sí, es el contenido propio del servicio (art. 2.1 de la Orden: instrucción individual, intercomunicación y estudios técnicos, sin fines de lucro). La propaganda electoral es ajena a ese fin (la Orden no la menciona por su nombre); la publicidad con fines lucrativos es causa de revocación (art. 8.1.b); y usar el distintivo de otro sin su permiso incumple el régimen de identificación (art. 27).])
#pq(4, 2, 17, "a", "R8.7", "CNAF = Cuadro Nacional de Atribución de Frecuencias",
  [En el Reglamento de uso del dominio público radioeléctrico por aficionados, la abreviatura CNAF significa:],
  ([Cuadro Nacional de Atribución de Frecuencias], [Certificado Nacional de Aptitud de Frecuencias], [Catálogo Nacional de Antenas Fijas], [Comisión Nacional de Aficionados y Frecuencias],),
  sol: [CNAF: Cuadro Nacional de Atribución de Frecuencias, de obligado cumplimiento.])
#pq(4, 2, 18, "d", "F-R8.99", "Potencia máxima en 23 cm y superiores: 1000 W p.i.r.e.",
  [En el anexo I, la potencia máxima de 1000 W fijada para las bandas de 23 cm y superiores se expresa como:],
  ([potencia de la portadora], [potencia radiada aparente (p.r.a.)], [potencia de cresta de la envolvente (p.c.e.)], [potencia isótropa radiada equivalente (p.i.r.e.)],),
  sol: [En microondas el límite se da en la magnitud que incluye la antena: 1000 W *p.i.r.e.*, es decir, la potencia suministrada a la antena multiplicada por su ganancia respecto a la isótropa, $"p.i.r.e." = P dot G_i$. Con una antena de 20 dBi ($G_i = 100$), la potencia suministrada a ella no podría pasar de 10 W. La p.c.e. (HF, VHF y 70 cm) es la potencia en la línea de la antena y no cuenta su ganancia. La p.r.a. se refiere al dipolo de media onda, y la potencia de la portadora es la que hay sin modular: ninguna es la magnitud de esta fila de la tabla. #_apc3-ver[(Véase tema T6, sección «El dipolo y otras antenas» (definición de p.i.r.e.), y tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[En el anexo I de la Orden IET/1311/2013 (apartado 3.1), desde 23 cm (1240 MHz) hasta 250 GHz — bandas de 23, 13, 6, 3 y 1,5 cm, 6 mm y 75 a 250 GHz — la potencia máxima es de 1000 W p.i.r.e.: la potencia suministrada a la antena multiplicada por su ganancia respecto a la antena isótropa. En HF y de 50 a 440 MHz el límite se da en p.c.e. (1000, 600 y 300 W); en 137 y 475 kHz, en p.i.r.e. (1 W).]])
#pq(4, 2, 19, "a", "F-R8.103", "Bandas con atribución secundaria: potencia ≤ 50 % de la tabla",
  [Si una banda de HF de la tabla del anexo I (1000 W p.c.e.) estuviera atribuida al servicio de radioaficionados con carácter secundario, su potencia máxima sería de:],
  ([500 W p.c.e.], [500 W p.i.r.e.], [250 W p.c.e.], [1000 W p.c.e.],),
  sol: [Se aplica el apartado 3.2 del anexo I: en una banda secundaria la potencia máxima no supera el 50 % de la tabla. Para HF la tabla da 1000 W p.c.e., luego el límite sería $1000 dot 0,5 = 500$ W p.c.e. Los 1000 W p.c.e. olvidan la rebaja; los 250 W la aplican dos veces; y 500 W p.i.r.e. acierta la cifra pero no la magnitud, porque en HF la tabla se expresa en p.c.e. Lo mismo vale para una banda de microondas de 1000 W p.i.r.e.: quedaría en 500 W p.i.r.e. Qué banda es secundaria lo fija el CNAF (art. 16). #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[En las bandas atribuidas con carácter secundario, el apartado 3.2 del anexo I de la Orden IET/1311/2013 limita la potencia máxima al 50 % de la tabla del apartado 3.1. El porcentaje se aplica a la magnitud de la tabla: una banda de HF (1000 W p.c.e.) quedaría en 500 W p.c.e., y una de microondas (1000 W p.i.r.e.) en 500 W p.i.r.e. Qué bandas son secundarias lo determina el CNAF (art. 16).]])
#pq(4, 2, 20, "d", "C-R8.26", "Licencia CEPT: todas las bandas atribuidas al servicio en el país visitado (no las del país de origen)",
  [La licencia CEPT de un radioaficionado español:],
  ([Solamente le permite hacer uso de ella dentro del territorio español.], [No le habilita para utilizar estaciones portables.], [Se la concederá la autoridad competente del país europeo que vaya a visitar.], [Le permite la utilización de todas las bandas atribuidas al Servicio de Aficionados autorizadas en el país donde se va a operar la estación.],),
  sol: [El art. 14.b de la Orden IET/1311/2013 dice que la licencia CEPT permite usar todas las bandas atribuidas al Servicio de Aficionados (y al de aficionados por satélite) que estén autorizadas, y en las condiciones que apliquen, en el país donde se va a operar. Las otras son falsas: a) la licencia CEPT sirve precisamente fuera de España, en los países que hayan adoptado la T/R 61-01; b) sí ampara el uso temporal de estaciones portables y móviles; c) no la concede el país visitado: la expide tu propia Administración y, en España, la autorización de radioaficionado ya tiene la consideración de licencia CEPT (art. 11). #vease[(Véase tema R8, sección «Usos especiales y casos particulares».)]

    #no-esta[Art. 11 de la Orden IET/1311/2013: se llama licencia CEPT a la expedida por un país que haya adoptado la Recomendación T/R 61-01, y la autorización de radioaficionado española tiene a todos los efectos esa consideración. Art. 14.b: con ella se usan las bandas del Servicio de Aficionados (y del de aficionados por satélite) autorizadas, y en las condiciones que apliquen, en el país donde se opera. Consecuencia práctica: si una banda no está permitida en el país visitado, no puedes usarla aunque en España sí lo esté.]])
#pq(4, 2, 21, "c", "R8.85", "Identificación con licencia CEPT: prefijo del país visitado (y opcionalmente distrito) + distintivo propio",
  [Un radioaficionado extranjero que opera temporalmente en España al amparo de la licencia CEPT se identifica:],
  ([sin necesidad de identificarse durante los tres primeros meses], [con un distintivo español que se le asigna al llegar], [anteponiendo a su distintivo el prefijo español y, opcionalmente, el número del distrito], [únicamente con su distintivo de origen],),
  sol: [Se antepone el prefijo del país visitado —EA en España— y, opcionalmente, el número del distrito desde el que se opera (art. 14.e de la Orden), seguido de barra y del distintivo propio: #_r8-cod[EA4/M0ABC] o #_r8-cod[EA/M0ABC]. Así se sabe de dónde emite y quién es. (La Orden de 2006 hacía obligatorio el número de distrito.)])
#pq(4, 2, 22, "d", "F-R8.20", "Recursos contra las resoluciones: reposición en 1 mes o contencioso ante la Audiencia Nacional en 2 meses",
  [Según el artículo 4 de la Orden IET/1311/2013, el recurso potestativo de reposición contra las resoluciones de la SETSI sobre autorizaciones y licencias de radioaficionado debe interponerse en el plazo de:],
  ([quince días desde su notificación], [seis semanas desde la entrada de la solicitud], [dos meses desde el día siguiente a su notificación], [un mes desde el día siguiente a su notificación],),
  sol: [El art. 4 de la Orden dice que estas resoluciones agotan la vía administrativa y que contra ellas cabe recurso potestativo de reposición ante el mismo órgano que las dictó, en el plazo de un mes desde el día siguiente a su notificación. Las seis semanas (b) son el plazo para resolver y notificar, no para recurrir; transcurrido sin resolución expresa, la solicitud se entiende desestimada. Los dos meses (c) son el plazo para acudir directamente a la Audiencia Nacional, y ambos recursos no pueden ser simultáneos. Los quince días (a) no aparecen en el artículo. #_apc3-ver[(Véase tema R8, introducción del tema (tabla de cifras: seis semanas y silencio desestimatorio).)]

#_apc3-net[Según el art. 4 de la Orden IET/1311/2013, la SETSI debe resolver en seis semanas y el silencio es desestimatorio. Las resoluciones agotan la vía administrativa. Contra ellas cabe recurso potestativo de reposición ante el mismo órgano que las dictó, en el plazo de un mes desde el día siguiente a la notificación, o bien recurso directo ante la Sala de lo Contencioso-administrativo de la Audiencia Nacional, en el plazo de dos meses desde el día siguiente a la notificación. Ambos recursos no pueden ser simultáneos.]])
#pq(4, 2, 23, "b", "F-R8.30", "Solicitud de autorización: acompañada del resguardo de la tasa de tramitación",
  [Según el artículo 6 del Reglamento, a la solicitud de autorización de radioaficionado debe acompañarse:],
  ([la memoria técnica de la instalación y el contrato de seguro de antenas], [el resguardo de abono de la tasa de tramitación], [un certificado de pertenencia a una asociación de radioaficionados], [la autorización escrita de la comunidad de propietarios del domicilio],),
  sol: [El art. 6 dice que la solicitud va «acompañada del resguardo de abono de la tasa de tramitación» establecida en la Ley General de Telecomunicaciones, además de la documentación que en cada caso proceda. La memoria técnica y el seguro de antenas (a) se exigen para la licencia de estación fija, no para la autorización. Ser socio de una asociación (c) no es obligatorio para ejercer la actividad. Y la comunidad de propietarios (d) solo interviene en la instalación de antenas, no en esta solicitud. #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Art. 6 de la Orden IET/1311/2013: la solicitud de autorización de radioaficionado debe ir acompañada del resguardo de abono de la tasa de tramitación que establece la Ley General de Telecomunicaciones y de la demás documentación que proceda en cada caso. No se exige ser socio de ninguna asociación. La memoria técnica de la instalación y el justificante del seguro de antenas pertenecen a otro trámite posterior, el de la licencia de estación fija (arts. 19 y 20).]])
#pq(4, 2, 24, "b", "R8.15", "Derecho a instalar la antena en el exterior: legitimación para usar el edificio + autorización administrativa",
  [Un radioaficionado podrá instalar la antena de su estación fija en el exterior de un inmueble:],
  ([siempre, sin ningún trámite], [si está legitimado para usar la totalidad o parte del edificio y ha obtenido la autorización administrativa reglamentaria], [solo si es el propietario de todo el edificio], [nunca, si vive en un piso],),
  sol: [Hacen falta las dos cosas: legitimación para usar el edificio (propiedad, alquiler con permiso…) y la autorización administrativa.])
#pq(4, 2, 25, "c", "F-R8.79", "Estación temporal: concursos, expediciones, demostraciones y eventos",
  [Según el Anexo I de la Orden IET/1311/2013, una «estación temporal de radioaficionado» es la utilizada con carácter temporal para actividades relacionadas con:],
  ([la retransmisión automática de las emisiones recibidas para ampliar el alcance de las comunicaciones], [la emisión automática de señales de identificación para estudios de propagación], [concursos y diplomas, expediciones, demostraciones en colegios, ferias y otros eventos de similar naturaleza], [la estancia temporal en España de un radioaficionado extranjero con licencia CEPT],),
  sol: [El Anexo I define la estación temporal como la utilizada con carácter temporal para actividades relacionadas con concursos y diplomas, expediciones, demostraciones en colegios, ferias y otros eventos de similar naturaleza. No es la estación portable (una fija usada temporalmente en una ubicación distinta de la habitual). Retransmitir automáticamente las emisiones es lo propio del repetidor (a) y emitir señales automáticas de identificación para estudios de propagación, de la radiobaliza (b). La estancia de un extranjero con licencia CEPT (d) no figura en la definición. #_apc3-ver[(Véase tema R8, sección «Tipos de estación» (definiciones del Anexo I, recogidas en la solución de la pregunta complementaria sobre la estación móvil).)]])
#pq(4, 2, 26, "c", "F-R8.48", "Asociación reconocida: por resolución de la SETSI, tras inscribirse en Interior y presentar estatutos",
  [Según el artículo 18.7 de la Orden IET/1311/2013, la condición de asociación de radioaficionados reconocida se obtiene:],
  ([automáticamente, al inscribirse la asociación en el registro del Ministerio del Interior], [por designación de la IARU Región 1 a través de su sociedad miembro en España], [por resolución de la SETSI, una vez constituida legalmente e inscrita en el Ministerio del Interior, previa solicitud acompañada de los estatutos], [por resolución del Ministerio del Interior, previa solicitud acompañada de los estatutos],),
  sol: [El art. 18.7 fija el procedimiento. La asociación ha de estar legalmente constituida y registrada en el Ministerio del Interior, y solicita el reconocimiento con sus estatutos; la condición se obtiene por resolución de la SETSI. La inscripción en el Interior es un requisito previo: no concede el reconocimiento (a) ni lo resuelve ese Ministerio (d). El art. 18.7 no atribuye ningún papel a la IARU en la concesión (b). #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 18.7 de la Orden IET/1311/2013: la condición de asociación de radioaficionados reconocida se obtiene por resolución de la SETSI, una vez que la asociación está legalmente constituida y registrada en el Ministerio del Interior, previa solicitud acompañada de sus estatutos. Solo las asociaciones reconocidas pueden ser autorizadas a instalar estaciones colectivas de radioaficionado (art. 18.6).]])
#pq(4, 2, 27, "d", "F-R8.59", "Tipos de desatendidas (art. 24): repetidores analógicos, digitales, de nodo, finales y radiobalizas",
  [Según el art. 24 de la Orden IET/1311/2013, se consideran estaciones automáticas desatendidas:],
  ([los repetidores analógicos y digitales, sin incluir las radiobalizas], [todas las estaciones colectivas de las asociaciones de radioaficionados], [los repetidores analógicos y digitales y las estaciones temporales de concursos y expediciones], [los repetidores analógicos, los repetidores digitales, los repetidores de portadora o nodo, los repetidores finales y las radiobalizas],),
  sol: [El art. 24 enumera las estaciones automáticas desatendidas: repetidores analógicos, digitales, de portadora o nodo y finales, y radiobalizas, más cualquier otra estación que encaje en la definición del anexo I (estación colectiva que para su funcionamiento habitual no requiere la intervención directa del operador). La a excluye las radiobalizas, que sí figuran. La c omite las radiobalizas y añade las estaciones temporales, que no están en el art. 24. La b confunde los términos: toda desatendida es colectiva, pero no toda colectiva es desatendida. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Clases del art. 24 de la Orden IET/1311/2013: repetidor analógico; repetidor digital; repetidor de portadora o nodo (repetidor digital que enlaza únicamente con otros repetidores digitales); repetidor final (repetidor digital que distribuye el tráfico de otros repetidores digitales a las estaciones de cada radioaficionado); y radiobaliza. Se añade cualquier otra estación que se ajuste a la definición del anexo I: estación colectiva que para su funcionamiento habitual no requiere la intervención directa del operador.]])
#pq(4, 2, 28, "d", "F-R9.9", "Muy grave: uso del espectro no adecuado al CNAF",
  [La utilización del dominio público radioeléctrico, de frecuencias o de canales no adecuada al Cuadro Nacional de Atribución de Frecuencias (CNAF) es, según la Ley 11/2022:],
  ([una infracción leve], [una infracción solo si llega a causar interferencias], [una infracción grave], [una infracción muy grave],),
  sol: [El art. 106.5 incluye entre las infracciones muy graves la utilización del dominio público radioeléctrico, frecuencias o canales no adecuada al plan de utilización del espectro o al CNAF. La ley no exige que cause interferencias: basta con que el uso no se ajuste a la atribución. Otras infracciones próximas tienen menor grado: usar el espectro sin la autorización necesaria es grave (art. 107.5) e incumplir las condiciones de la autorización es leve (art. 108.5). Por eso «grave», «leve» y «solo si interfiere» fallan. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador» (tabla de grados de infracción).)]

#_apc3-net[Art. 106.5 de la Ley 11/2022: es infracción muy grave utilizar el dominio público radioeléctrico, frecuencias o canales radioeléctricos de modo no adecuado al plan de utilización del espectro o al Cuadro Nacional de Atribución de Frecuencias (CNAF). Basta la falta de adecuación; no se exige que haya interferencias. Usar el espectro sin la autorización necesaria es, en cambio, infracción grave (art. 107.5), e incumplir las condiciones de la autorización, leve (art. 108.5).]])
#pq(4, 2, 29, "b", "R9.4", "Leve: comunicarse utilizando estaciones no autorizadas",
  [La Ley General de Telecomunicaciones tipifica como infracción LEVE:],
  ([la obstrucción a la labor inspectora], [el establecimiento de comunicaciones utilizando estaciones no autorizadas], [la mera producción de interferencias a redes o servicios autorizados], [la interceptación de comunicaciones de terceros],),
  sol: [Establecer comunicaciones utilizando estaciones no autorizadas es infracción leve (art. 108.2 de la Ley 11/2022), salvo que deba considerarse grave. La interceptación es muy grave (art. 106.15); la mera producción de interferencias (art. 107.6) y la obstrucción a la inspección (art. 107.36) son graves. Ojo: el banco antiguo decía «con estaciones no autorizadas» (redacción de la Ley 32/2003, donde era grave, art. 54.g) y la versión previa de esta pregunta ofrecía como distractor el «uso de identificaciones falsas», que entonces (Ley 9/2014, art. 77.5) era grave y que la Ley 11/2022 ya no tipifica con esas palabras. La clave del banco no cambia.])
#pq(4, 2, 30, "c", "F-R9.1", "Multa máxima de las leves: 100 000 €",
  [La multa máxima que prevé la Ley 11/2022, General de Telecomunicaciones, por una infracción leve es de:],
  ([50 000 euros], [500 000 euros], [100 000 euros], [2 millones de euros],),
  sol: [El art. 109.1.d fija para las infracciones leves una multa de hasta 100 000 euros. La escala completa es: hasta 20 millones de euros para las muy graves (letra a), hasta 2 millones para las graves (letra c) y hasta 100 000 euros para las leves. Los 50 000 euros eran el tope de las leves en la ley anterior (Ley 9/2014, art. 79.1.d), cifra que todavía figura en preguntas antiguas. Los 2 millones son el tope de las graves, y 500 000 euros no corresponde a ningún grado del art. 109.1. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador» (tabla de grados y multas).)]])
#fin-prueba()
#soluciones-simulacro(4)

// ======================================================================
#simulacro(5)
#prueba(5, 1)
#pq(5, 1, 1, "c", "C-T1.1", "Equivalencias de la ley de Ohm: 1 Ω = 1 V/1 A y 1 V = 1 Ω · 1 A",
  [En la teoría de electricidad, un ohmio equivale a:],
  ([1 amperio × 1 voltio], [1 amperio × 1 segundo], [1 voltio / 1 amperio], [1 amperio / 1 voltio],),
  sol: [
    De la ley de Ohm, $V = I · R$, se despeja $R = V slash I$: un ohmio es la resistencia que deja
    pasar 1 A cuando se le aplica 1 V, es decir, 1 Ω = 1 V/1 A. Las otras opciones son unidades
    distintas: amperio × voltio es un vatio ($P = V · I$), amperio × segundo es un culombio (carga
    eléctrica) y amperio/voltio es la inversa del ohmio, la conductancia (siemens, antes «mho»).
    #vease[(Véase tema T1, sección «Unidades y leyes fundamentales».)]
  ])
#pq(5, 1, 2, "a", "C-T1.24", "Prefijos del SI y conversión entre múltiplos y submúltiplos",
  [Un miliohmio equivale a:],
  ([0,001 Ω], [1000 Ω], [0,001 MΩ], [0,001 kΩ],),
  sol: [
    El prefijo «mili» (m) significa una milésima, $10^(−3)$: 1 mΩ = 0,001 Ω. Las demás opciones son
    múltiplos: 1000 Ω es 1 kΩ (kilo = mil); 0,001 MΩ son $0,001 × 10^6 = 1000$ Ω (mega = millón); y
    0,001 kΩ son 0,001 × 1000 = 1 Ω. #vease[(Véase tema T1, sección «Unidades y leyes
    fundamentales».)]
    #no-esta[El texto usa mA, mV o mW y trata kilo y mega, pero no enumera los prefijos. Los del SI que hay
    que saber: mili (m) $= 10^(−3)$, micro $(μ) = 10^(−6)$, nano (n) $= 10^(−9)$, pico (p)
    $= 10^(−12)$; kilo (k) $= 10^3$, mega (M) $= 10^6$, giga (G) $= 10^9$. Para convertir, se
    multiplica por la potencia de diez del prefijo: 1 kΩ $= 10^3$ Ω equivale a un millón de
    miliohmios. Ojo con las mayúsculas: m = mili, M = mega.]
  ])
#pq(5, 1, 3, "d", "C-T1.31", "Anchuras de banda típicas: CW < SSB (2,7 kHz) < AM (6 kHz) < FM",
  [¿Qué tipo de comunicación ocupa un mayor ancho de banda?],
  ([Amplitud modulada], [Telegrafía], [Banda lateral única], [Frecuencia modulada],),
  sol: [
    Hay que comparar las anchuras típicas: la telegrafía (CW) ocupa, como mucho, unos cientos de
    hercios según la velocidad de manipulación; la banda lateral única (SSB), unos 2,7 kHz; la AM de
    voz, $2f_m ≈ 6$ kHz, el doble que la SSB porque lleva dos bandas laterales; y la FM de banda
    estrecha (la de VHF), unos 12 kHz, según la regla de Carson, $B ≈ 2(Δ f + f_m)$. La FM es, pues,
    la que más ancho ocupa (la FM de radiodifusión llega a unos 200 kHz). #vease[(Véase tema T1,
    sección «Señales moduladas».)]
  ])
#pq(5, 1, 4, "c", "C-T1.8", "El decibelio compara niveles de potencia (escala logarítmica)",
  [El decibelio es una unidad de medida utilizada para:],
  ([medidas de reactancia], [comprobar la disipación de placa de una válvula], [la comparación de niveles de potencia eléctrica], [comparar las frecuencias de dos circuitos],),
  sol: [
    El decibelio expresa, en escala logarítmica, la relación entre dos valores de una misma
    magnitud, sobre todo de potencia: $G ("dB") = 10 log_10 (P_2 slash P_1)$. Sirve para comparar
    niveles de potencia: ganancias, atenuaciones y pérdidas. La reactancia se mide en ohmios, la
    frecuencia en hercios y la disipación de placa de una válvula en vatios; ninguna se mide en
    decibelios. #vease[(Véase tema T1, sección «Potencia, decibelios y DSP».)]
  ])
#pq(5, 1, 5, "d", "C-T2.17", "Código de colores: leer el valor de una resistencia de cuatro bandas (cifras + multiplicador)",
  [El valor y la tolerancia de las resistencias más habituales se indican mediante un código de
colores. Indique el valor de la resistencia cuyos colores son, por este orden: verde, rojo, rojo,
plata:],
  ([52 Ω y 5 % de tolerancia.], [No se puede calcular.], [520 Ω y 0,1 % de tolerancia.], [5,2 kΩ y 10 % de tolerancia.],),
  sol: [
    Se lee de izquierda a derecha: verde = 5, rojo = 2, y el tercer color, rojo, es el multiplicador
    $10^2$; la cuarta banda, plata, es la tolerancia de ±10 %. Así, $R = 52 × 10^2 = 5200$ Ω = 5,2
    kΩ ± 10 %. La opción a y la c usan un multiplicador equivocado (×1 y × 10 en lugar de $×10^2$) y
    una tolerancia que no corresponde a la plata (el 5 % es el oro); la b es falsa: el valor siempre
    se calcula con la tabla. #vease[(Véase tema T2, sección «Resistencias».)]
    #no-esta[La cuarta banda indica la tolerancia: marrón ±1 %, rojo ±2 %, oro ±5 %, plata ±10 %; sin cuarta
    banda, ±20 %. El oro, más valioso, marca la tolerancia más estrecha (5 %) y la plata, menos, la
    más holgada (10 %). La tercera banda es el multiplicador: la cifra del color es el exponente de
    la potencia de diez (rojo, 2, significa $×10^2$).]
  ])
#pq(5, 1, 6, "a", "T2.56", "Una resistencia fija se especifica por valor, potencia de disipación y tolerancia",
  [Una resistencia fija queda determinada por:],
  ([su valor óhmico, la potencia que puede disipar y su tolerancia], [su valor óhmico y su color], [su valor óhmico y la frecuencia de trabajo], [su valor óhmico únicamente],),
  sol: [Con el valor no basta: hay que saber cuánta potencia puede disipar sin quemarse y con qué precisión se cumple el valor nominal. El valor y la tolerancia figuran en el código de colores; la potencia se reconoce por el tamaño del cuerpo.])
#pq(5, 1, 7, "c", "T2.25", "Varicap: capacidad controlada por la tensión inversa (más tensión, menos capacidad)",
  [Un diodo varicap es un diodo que:],
  ([se comporta como un condensador electrolítico], [ajusta su inductancia mediante un núcleo móvil], [varía su capacidad con la tensión inversa aplicada], [varía su resistencia con la luz que recibe],),
  sol: [El varicap se comporta como un condensador cuya capacidad se controla con la tensión inversa: sintonía electrónica en VCO y receptores.])
#pq(5, 1, 8, "a", "T2.34", "FET y MOSFET: terminales puerta, drenador y surtidor; control por tensión de puerta",
  [Los tres terminales de un transistor de efecto de campo (FET) se denominan:],
  ([puerta, drenador y surtidor], [cátodo, rejilla y ánodo], [primario, secundario y masa], [emisor, base y colector],),
  sol: [En el FET la tensión de puerta controla, mediante un campo eléctrico y sin apenas consumir corriente, el paso entre surtidor y drenador. Emisor, base y colector son del bipolar; cátodo, rejilla y ánodo, de la válvula.])
#pq(5, 1, 9, "d", "F-T3.14", "Asociación de bobinas sin acoplo: como las resistencias (serie suman; paralelo producto/suma)",
  [Dos bobinas de 20 μH y 30 μH, sin acoplamiento magnético entre ellas, se conectan en paralelo. La inductancia resultante es de:],
  ([50 μH], [25 μH], [600 μH], [12 μH],),
  sol: [En paralelo las dos bobinas soportan la misma tensión y se combinan como resistencias en paralelo: $L = (L_1 L_2)/(L_1 + L_2) = (20 dot 30)/50 = 12$ μH, menor que la menor de las dos. Los 50 μH son la suma, propia de la asociación en serie. Los 25 μH son la media aritmética, y los 600 μH el producto, que olvida dividir por la suma. _(Véase tema T3, sección «Asociación de componentes y resonancia» (las impedancias en serie se suman; en paralelo, las admitancias), y tema T2, sección «Bobinas».)_

#_apc1-noest[Las bobinas se asocian como las resistencias (si no comparten flujo magnético). En serie las recorre la misma corriente y las tensiones inducidas se suman: $L = L_1 + L_2 + dots.c$. En paralelo soportan la misma tensión y las corrientes se suman: $1 slash L = 1 slash L_1 + 1 slash L_2 + dots.c$, o $L = L_1 L_2 slash (L_1 + L_2)$ para dos, siempre menor que la menor. Si comparten flujo hay que añadir la inductancia mutua $M$: en serie, $L = L_1 + L_2 plus.minus 2 M$.]])
#pq(5, 1, 10, "b", "T3.8", "Cristal de cuarzo: resonador piezoeléctrico de Q altísimo",
  [Un resonador de cuarzo es un dispositivo que:],
  ([rectifica la corriente alterna], [presenta un efecto de resonancia basado en la piezoelectricidad], [amplifica señales de radiofrecuencia], [almacena carga eléctrica en un dieléctrico de cuarzo],),
  sol: [El cuarzo es piezoeléctrico y presenta una resonancia mecánica de altísimo $Q$: osciladores y filtros de gran estabilidad.])
#pq(5, 1, 11, "d", "T3.24", "Clase C: solo para emisiones de amplitud constante (CW, FM), nunca SSB ni AM",
  [Un amplificador de clase C únicamente puede emplearse con emisiones:],
  ([de amplitud modulada], [de cualquier tipo, si se ajusta la polarización], [de banda lateral única], [de amplitud constante, como CW o FM],),
  sol: [En clase C la envolvente se destroza. Si la información viaja en la amplitud — AM, SSB — se pierde y aparecen productos espurios; si la amplitud es constante y la información va en la frecuencia o en la presencia o ausencia de portadora, no hay nada que estropear.])
#pq(5, 1, 12, "a", "T3.17", "Amplificador operacional: ganancia muy alta, impedancia de entrada alta y de salida baja",
  [Un amplificador operacional se caracteriza por tener:],
  ([ganancia muy elevada, impedancia de entrada alta y de salida baja], [ganancia elevada e impedancia de salida elevada], [ganancia unidad y realimentación positiva], [ganancia baja e impedancia de entrada baja],),
  sol: [Las tres cosas a la vez: amplifica muchísimo la diferencia entre sus entradas, apenas carga a lo que mide (entrada de alta impedancia) y entrega corriente sin hundirse (salida de baja impedancia). Es lo que permite encadenarlo con otras etapas sin que se estorben.])
#pq(5, 1, 13, "c", "C-T3.16", "Estabilidad del oscilador: la temperatura hace derivar su frecuencia",
  [Los circuitos osciladores pueden sufrir variaciones apreciables de frecuencia al variar:],
  ([La luz ambiental], [La densidad de electrones libres], [La temperatura], [Las condiciones de propagación],),
  sol: [
    La frecuencia de un oscilador depende de los valores de sus componentes, y estos cambian con la
    temperatura: la bobina se dilata, los condensadores varían su capacidad y los semiconductores
    modifican sus capacidades internas. Es la deriva térmica, principal causa de inestabilidad de un
    oscilador LC, y por eso se recurre al cristal de cuarzo o se estabiliza térmicamente el
    circuito. La luz ambiental no afecta a un circuito normal; las condiciones de propagación y la
    densidad de electrones libres (de la ionosfera) influyen sobre la onda en su recorrido, no sobre
    el oscilador. #vease[(Véase capítulo «La radio por dentro», apartado «El cristal de cuarzo: el
    tanque perfecto»; tema T2, sección «Condensadores».)]
  ])
#pq(5, 1, 14, "b", "T3.13", "Mezclador (heterodinación): a la salida aparecen la suma y la diferencia f1 ± f2",
  [Si a la entrada de un mezclador se aplican dos señales de 14 MHz y 4 MHz, a su salida encontraremos, entre otras, la frecuencia de:],
  ([56 MHz], [10 MHz], [3,5 MHz], [7 MHz],),
  sol: [El mezclador entrega $f_1 + f_2 = 18$ MHz y $f_1 - f_2 = 10$ MHz, entre otras. De las opciones, la única presente es 10 MHz.])
#pq(5, 1, 15, "b", "F-T4.10", "Receptor de FM: tras la FI, limitador y después discriminador (en AM, detector de envolvente)",
  [En el diagrama de bloques de un receptor de FM, tras el amplificador de FI se sitúan, por este orden:],
  ([el detector de producto y el oscilador de batido (BFO)], [el limitador y el discriminador], [el discriminador y el limitador], [el mezclador y el oscilador local],),
  sol: [Tras la FI va primero el limitador, que recorta la amplitud y borra el ruido (en FM la información está en la frecuencia, no en la amplitud), y después el discriminador, que convierte las variaciones de frecuencia en tensión de audio. El orden inverso (c) es incorrecto: sin limitar antes, el discriminador dejaría pasar el ruido de amplitud. El detector de producto y el BFO (a) son de SSB y CW; el mezclador y el oscilador local (d) están antes de la FI. #vease[(Véase tema T4, sección «Características y controles».)]])
#pq(5, 1, 16, "b", "T4.8", "Silenciador (squelch): corta el audio cuando la señal no supera un umbral",
  [El silenciador (_squelch_) de un receptor sirve para:],
  ([proteger el altavoz de sobrecargas], [suprimir la salida de audio cuando la señal recibida no supera un determinado nivel], [atenuar las señales demasiado fuertes], [reducir la deriva de frecuencia],),
  sol: [El squelch corta el audio cuando la señal no supera el umbral: elimina el soplido entre comunicados, imprescindible en FM.])
#pq(5, 1, 17, "d", "T5.18", "Margen de audiofrecuencia para la inteligibilidad: 300 a 3000 Hz",
  [Para una emisión de fonía, la banda de audiofrecuencias que basta transmitir para conservar la inteligibilidad es aproximadamente:],
  ([de 20 a 20 000 Hz], [de 50 a 150 Hz], [de 3 a 30 kHz], [de 300 a 3000 Hz],),
  sol: [Es la banda telefónica clásica: con ella la voz se entiende perfectamente. Transmitir más solo ensancharía la emisión sin mejorar la inteligibilidad — y el espectro que sobra se lo quitamos a los vecinos de frecuencia. Los 20 Hz a 20 kHz son el margen de la alta fidelidad.])
#pq(5, 1, 18, "c", "T5.5", "Rendimiento = potencia entregada al sistema radiante / potencia consumida",
  [El rendimiento de un transmisor es la relación entre:],
  ([la tensión de salida y la tensión de entrada], [la potencia directa y la potencia reflejada], [la potencia entregada al sistema radiante y la potencia consumida], [la frecuencia emitida y la frecuencia moduladora],),
  sol: [Rendimiento = $P_"radiada" slash P_"consumida"$; un final en clase C supera el 70 %, la clase A queda muy por debajo.])
#pq(5, 1, 19, "b", "F-T5.7", "Ubicación de los repetidores: lugares elevados para aumentar el alcance (visibilidad directa)",
  [Los repetidores se instalan preferentemente en lugares elevados (montañas, torres) porque:],
  ([así consumen menos energía de la red eléctrica], [así aumenta su alcance, al ver directamente más terreno], [así la ionosfera refleja mejor sus señales de VHF y UHF], [así se evitan las interferencias de las emisoras de HF y de onda media],),
  sol: [En VHF y UHF la onda viaja por visibilidad directa y su alcance lo marca el horizonte radioeléctrico, que crece con la raíz de la altura de las antenas. Un repetidor en una cumbre «ve» más terreno y llega a más estaciones sin aumentar la potencia. La ionosfera es transparente a esas frecuencias (c), el consumo eléctrico no depende de la altura (a) y la altura tampoco protege de las emisoras de HF o de onda media (d). #vease[(Véase tema T7, sección «La ionosfera y la onda de espacio».)]])
#pq(5, 1, 20, "d", "", "Yagi: el reflector es más largo y va detrás; los directores, más cortos y delante",
  [En una antena Yagi, comparado con el elemento alimentado (radiante), el reflector es:],
  ([algo más corto y está situado delante], [de la misma longitud y está conectado a la línea de transmisión], [algo más largo y está situado delante], [algo más largo y está situado detrás],),
  sol: [El reflector es algo más largo que el resonante (inductivo) y se coloca detrás del radiante; los directores son algo más cortos (capacitivos) y van delante, hacia donde sale el haz. Ninguno está conectado a la línea: son elementos parásitos. La opción a describe un director.])
#pq(5, 1, 21, "a", "", "La impedancia característica depende de la geometría y del dieléctrico, no de la longitud",
  [La impedancia característica $Z_0$ de una línea de transmisión depende de:],
  ([la geometría de los conductores (diámetros y separación) y del dieléctrico], [la impedancia de la antena conectada en su extremo], [su longitud], [la potencia que transporta],),
  sol: [$Z_0 = sqrt(L' slash C')$ depende de la inductancia y la capacidad por metro, y estas las fijan el diámetro y la separación de los conductores y el aislante. No depende de la longitud: un coaxial de 50 Ω tiene 50 Ω con 1 m y con 100 m. La impedancia de la antena decide si hay onda reflejada (la ROE), pero no cambia la $Z_0$ de la línea.])
#pq(5, 1, 22, "b", "T6.33", "Longitud física = longitud eléctrica × FV (la física es menor); cálculo de un tramo",
  [Comparadas entre sí, la longitud física y la longitud eléctrica de un tramo de cable coaxial cumplen que:],
  ([ambas son siempre iguales], [la longitud física es menor que la eléctrica], [la longitud física es mayor que la eléctrica], [su relación depende de la potencia aplicada],),
  sol: [Como la onda va más despacio dentro del cable, la longitud de onda allí es más corta: $L_"fís" = L_"el" times "FV"$, con FV < 1 (0,66 en un coaxial de polietileno). Para conseguir media onda eléctrica basta con menos cable del que haría falta en el aire: la longitud física es menor que la eléctrica. Solo serían iguales en el vacío (FV = 1), y la potencia aplicada no interviene. Ojo: alguna lista publicada da por buena la opción contraria («la física es mayor»); es un error.])
#pq(5, 1, 23, "c", "C-T7.6", "Nomenclatura de las bandas: sigla y nombre por longitud de onda (HF decamétricas, MF hectométricas, VHF métricas, UHF decimétricas, SHF centimétricas)",
  [La abreviatura HF indica la subdivisión métrica correspondiente a ondas:],
  ([kilométricas], [métricas], [decamétricas], [hectométricas],),
  sol: [
    La «subdivisión métrica» es el nombre por longitud de onda que la UIT asigna a cada banda. HF
    (#emph[High Frequency]) va de 3 a 30 MHz, es decir, de 100 a 10 m: decenas de metros, ondas
    decamétricas. Las métricas corresponden a VHF (30–300 MHz), las hectométricas a MF (300 kHz–3
    MHz) y las kilométricas a LF (30–300 kHz). #vease[(Véase tema T7, sección «Cómo se nombran las
    bandas».)]
  ])
#pq(5, 1, 24, "a", "C-T7.11", "Atenuación: toda onda se atenúa al propagarse y al atravesar objetos",
  [Si una onda electromagnética atraviesa un objeto, se produce un efecto de:],
  ([atenuación], [amplificación], [reflexión], [intermodulación],),
  sol: [
    Al atravesar un objeto (un muro, un árbol, una persona), la onda cede parte de su energía y sale
    con menos intensidad: se atenúa. La reflexión ocurre en la superficie y devuelve parte de la
    onda sin atravesarla; la intermodulación es cosa de los elementos no lineales (amplificadores,
    mezcladores), no de un obstáculo pasivo; y un objeto pasivo no aporta energía, así que no puede
    amplificar. #vease[(Véase tema T7, introducción (atenuación de la señal).)]
    #no-esta[Cuando una onda encuentra un obstáculo pueden darse varios efectos: #strong[reflexión] (parte
    rebota en la superficie), #strong[refracción] (cambia de dirección al pasar de un medio a otro),
    #strong[difracción] (se curva al rodear bordes) y #strong[absorción o atenuación] (si lo
    atraviesa, pierde energía en forma de calor). La pérdida es tanto mayor cuanto más grueso o más
    conductor es el obstáculo.]
  ])
#pq(5, 1, 25, "d", "C-T8.5", "Shunt: resistencia en paralelo que amplía la escala del amperímetro y lo protege",
  [Si queremos medir corrientes continuas con un amperímetro cuyo alcance máximo es inferior a las
corrientes a medir, tendremos que:],
  ([no se puede utilizar], [poner una resistencia en serie], [poner un condensador en serie], [poner una resistencia en paralelo],),
  sol: [
    Se pone una resistencia #emph[shunt] en paralelo con el amperímetro: desvía la mayor parte de la
    corriente y deja pasar por el aparato solo una fracción conocida. Ejemplo: un instrumento de 1
    mA y 100 Ω con un shunt de 100/9 ≈ 11,1 Ω mide hasta 10 mA (1 mA por el instrumento y 9 mA por
    el shunt). Una resistencia en serie no amplía nada: toda la corriente sigue pasando por el
    instrumento. Un condensador en serie bloquearía la corriente continua. Y sí puede utilizarse,
    con el shunt. #vease[(Véase tema T8, sección «Técnica de medida».)]
  ])
#pq(5, 1, 26, "c", "T8.21", "S-meter: cada punto S equivale a 6 dB",
  [En la escala de un S-meter, la diferencia entre dos puntos S consecutivos equivale a:],
  ([1 dB], [3 dB], [6 dB], [20 dB],),
  sol: [Por convenio, cada punto S vale 6 dB, es decir, cuadruplicar la potencia o duplicar la tensión de la señal. Por eso pasar de S7 a S9 exige multiplicar la potencia por 16, y de ahí que subir un par de puntos S cueste tanto.])
#pq(5, 1, 27, "b", "T9.21", "Compatibilidad electromagnética: no perturbar el entorno y no verse afectado por él",
  [Se denomina compatibilidad electromagnética a la capacidad de un equipo para:],
  ([soportar descargas atmosféricas directas], [funcionar sin producir perturbaciones a su entorno y sin verse afectado por él], [emitir en varias bandas simultáneamente], [funcionar con cualquier tensión de alimentación],),
  sol: [La definición tiene dos caras y el examen suele dar solo una: _no molestar_ y _no ser molestado_. Un equipo compatible convive con su entorno electromagnético en ambos sentidos.])
#pq(5, 1, 28, "a", "F-T9.1", "Bloqueo o desensibilización: un campo intenso satura la entrada aunque esté sintonizado lejos",
  [Un receptor cercano a un transmisor potente pierde sensibilidad (las señales débiles se hunden) aunque esté sintonizado en otra frecuencia, y no aparecen señales nuevas en ninguna parte del dial. Este efecto se denomina:],
  ([bloqueo o desensibilización], [intermodulación de tercer orden], [detección en circuitos de audio], [recepción por la frecuencia imagen],),
  sol: [Es el bloqueo o desensibilización: el campo intenso del transmisor satura las primeras etapas del receptor, que reduce su ganancia efectiva y deja hundidas a las señales débiles, sin crear señales nuevas. La intermodulación (b) sí las crea: mezcla dos señales intensas en una etapa no lineal y genera productos como $2 f_1 - f_2$. La detección en audio (c) haría oír la voz del transmisor por el altavoz. Y la frecuencia imagen (d) es una emisora que entra por una frecuencia separada del doble de la FI de la sintonizada y se oye como si fuera la deseada. #vease[(Véase tema T9, sección «Causas de interferencia».)]])
#pq(5, 1, 29, "d", "T10.25", "Calibre del fusible: ligeramente superior al consumo máximo del equipo",
  [El valor nominal del fusible que protege un equipo debe ser:],
  ([muy inferior al consumo del equipo, para que salte enseguida], [diez veces el consumo máximo del equipo], [indiferente, mientras encaje en el portafusibles], [ligeramente superior al consumo máximo previsto del equipo],),
  sol: [Debe dejar pasar el consumo normal sin fundirse y cortar en cuanto se supere: un poco por encima del máximo previsto. Muy por debajo saltaría constantemente sin que hubiera avería, y diez veces por encima no protegería de nada.])
#pq(5, 1, 30, "c", "T10.27", "Qué vale como tierra: la del edificio si está en buen estado; nunca el neutro ni tuberías de gas o agua",
  [Como toma de tierra de la estación:],
  ([basta con conectar los chasis al neutro de la red], [basta con conectar los chasis a la tubería del gas], [puede emplearse la de la instalación eléctrica del edificio, si existe y está en buenas condiciones], [debe emplearse siempre una pica propia, nunca la del edificio],),
  sol: [No hace falta duplicar instalaciones: la tierra del edificio sirve si está en condiciones. Lo que nunca vale es el neutro de la red —que es un conductor activo— ni una tubería, y menos la del gas.])
#fin-prueba()
#prueba(5, 2)
#pq(5, 2, 1, "d", "R1.11", "Sufijos TOP y BOJ: T Tango, O Oscar, P Papa (no Pedro, Peter)",
  [El sufijo `TOP` se deletrea:],
  ([Tres Oscar Papa], [Tango Omega Portugal], [Tango Oscar Perú], [Tango Oscar Papa],),
  sol: [`TOP` = _Tango Oscar Papa_.])
#pq(5, 2, 2, "a", "R2.7", "QRO aumente / QRP disminuya la potencia",
  [El grupo `QRP` significa:],
  ([disminuya la potencia], [estación portátil], [aumente la potencia], [transmita más despacio],),
  sol: [`QRP`: «disminuya la potencia»; por extensión, operar con baja potencia. Su opuesto es `QRO`.])
#pq(5, 2, 3, "a", "R2.9", "QRT cese la transmisión frente a QRX espere, volveré a llamar",
  [El grupo del código Q que indica que el operador volverá a llamar más tarde es:],
  ([`QRX`], [`QRK`], [`QRT`], [`QSY`],),
  sol: [`QRX`: «espere, volveré a llamar más tarde»; `QRK` pregunta por la inteligibilidad.])
#pq(5, 2, 4, "c", "R2.20", "QSM repita el último mensaje",
  [El grupo `QSM` se emplea para pedir que:],
  ([se confirme la recepción por tarjeta], [se cambie de frecuencia], [se repita el último mensaje transmitido], [se reduzca la velocidad de transmisión],),
  sol: [Reducir la velocidad es `QRS`, cambiar de frecuencia `QSY` y confirmar por tarjeta `QSL`.])
#pq(5, 2, 5, "d", "R3.7", "AR fin de la transmisión (no del contacto)",
  [En telegrafía, la abreviatura de procedimiento empleada para finalizar una transmisión es:],
  ([`VA73`], [`CQ`], [`SK9`], [`AR`],),
  sol: [`AR` marca el fin de la transmisión; `K` invita a transmitir y `SK` cierra el contacto.])
#pq(5, 2, 6, "a", "R3.10", "YL operadora y XYL esposa",
  [La abreviatura `YL` designa a:],
  ([una operadora], [un enlace de larga distancia], [una licencia provisional], [una estación de baja potencia],),
  sol: [De _young lady_. La baja potencia es `QRP` y la larga distancia, `DX`.])
#pq(5, 2, 7, "b", "", "GN buenas noches",
  [La abreviatura `GN` se emplea para desear al corresponsal:],
  ([buenas tardes], [buenas noches], [buena suerte], [buenos días],),
  sol: [`GN` es _good night_: «buenas noches». Los saludos se forman con la G de _good_ y la inicial de lo que se desea: `GM` (_morning_) buenos días, `GE` (_evening_) buenas tardes y `GL` (_luck_) buena suerte.])
#pq(5, 2, 8, "c", "R4.5", "Urgencia en radiotelegrafía: XXX tres veces",
  [La abreviatura `XXX`, transmitida tres veces consecutivas, constituye la señal de:],
  ([socorro], [alarma], [urgencia], [seguridad],),
  sol: [`XXX` tres veces: urgencia telegráfica, equivalente a #_r4-sc("Pan Pan").])
#pq(5, 2, 9, "d", "R4.14", "Tras emitir un socorro: escuchar en la misma frecuencia",
  [Después de transmitir un mensaje de socorro, la estación debe:],
  ([repetirlo sin pausa hasta obtener respuesta], [apagar el equipo para no interferir], [cambiar inmediatamente de banda], [permanecer a la escucha en esa misma frecuencia],),
  sol: [De nada sirve pedir auxilio si nadie puede contestar. Se transmite y se escucha en la misma frecuencia, dejando huecos suficientes para que quien responda pueda hacerlo.])
#pq(5, 2, 10, "d", "", "Banda de 13 cm: 2300–2450 MHz",
  [La banda de aficionados de 13 cm abarca en España, de extremo a extremo, las frecuencias:],
  ([5650 a 5850 MHz], [2400 a 2450 MHz], [1240 a 1300 MHz], [2300 a 2450 MHz],),
  sol: [Según el Anexo I de la Orden, la banda de 13 cm va de 2300 a 2450 MHz (y necesita autorización especial, salvo la subbanda de 2316 a 2332 MHz). 1240–1300 MHz es la de 23 cm y 5650–5850 MHz la de 6 cm; 2400–2450 MHz es solo el tramo superior, que coincide con una banda ICM.])
#pq(5, 2, 11, "a", "R5.44", "El distintivo se otorga junto con la autorización y lo asigna la Administración (no se elige ni lo da la asociación)",
  [Respecto de la autorización de radioaficionado y el distintivo de llamada:],
  ([al concederse la autorización se otorga a la vez el distintivo], [el distintivo lo asigna la asociación a la que se pertenezca], [el distintivo se elige libremente por el titular], [el distintivo se solicita aparte, un año después],),
  sol: [Van juntos: la autorización no serviría de nada sin un distintivo con el que identificarse, así que se otorgan en el mismo acto. Tampoco se elige libremente — lo asigna la Administración conforme a las series disponibles.])
#pq(5, 2, 12, "b", "F-R5.8", "Prefijos de los países vecinos: Portugal CT, Francia F, Andorra C3",
  [Un radioaficionado cuyo distintivo empieza por el prefijo #_apc2-m[CT] emite con un distintivo de:],
  ([Croacia], [Portugal], [Canadá], [Chile],),
  sol: [El prefijo #_apc2-m[CT] es el de Portugal (T/R 61-01, apéndice II; las Azores usan #_apc2-m[CU]). Las demás opciones son trampas por la inicial: Chile usa #_apc2-m[CE], Canadá #_apc2-m[VE] y Croacia #_apc2-m[9A]. El Reglamento de Radiocomunicaciones de la UIT reparte a cada país series de prefijos y cada Administración compone con ellas los distintivos: por eso el país se reconoce por las primeras letras, como #_apc2-m[EA] en España. #vease[(Véase tema R5, introducción del capítulo (prefijo, distrito y sufijo).)] #no-esta[Un distintivo empieza por un prefijo que identifica el país: la UIT atribuye a cada Estado series de prefijos (Reglamento de Radiocomunicaciones, apéndice 42). Los vecinos de España: Portugal #_apc2-m[CT] (Azores, #_apc2-m[CU]), Francia #_apc2-m[F] y Andorra #_apc2-m[C3]. Un mismo país puede usar varios prefijos: España emplea #_apc2-m[EA], #_apc2-m[EB] y #_apc2-m[EC] en las autorizaciones individuales.]])
#pq(5, 2, 13, "b", "R5.21", "Reasignación de distintivos: agotadas las combinaciones, salvo anterior titular o familiares de primer grado por fallecimiento",
  [Los distintivos de llamada se podrán reasignar:],
  ([a cualquier solicitante, transcurrido un año], [en caso de fallecimiento del titular, a familiares en primer grado], [mediante subasta pública], [únicamente a estaciones colectivas],),
  sol: [En caso de fallecimiento del titular, el distintivo puede reasignarse a familiares en primer grado (salvo que tenga sufijo de una letra). Es una excepción: según el art. 28 (párr. 3.º), los distintivos ya utilizados solo se reasignan una vez agotadas todas las combinaciones posibles; la otra excepción es el anterior titular, si obtiene una nueva autorización tras una revocación. Reasignar a cualquier solicitante transcurrido un año (a), por subasta (c) o solo a las colectivas (d) no figura en la Orden.])
#pq(5, 2, 14, "c", "F-R6.14", "Canal de llamada de FM en 10 m: 29,600 MHz",
  [En la banda de 10 m, el canal de llamada de FM del plan de bandas HF de la IARU para la Región 1 es:],
  ([29,000 MHz], [29,300 MHz], [29,600 MHz], [28,500 MHz],),
  sol: [El plan de 10 m dedica el extremo alto a la FM: entradas de repetidores en 29,520–29,590 MHz (canales RH1 a RH8), salidas en 29,620–29,700 MHz (100 kHz más arriba) y, entre ambos grupos, 29,600 MHz como canal de llamada de FM. Los 29,300 MHz son el comienzo del segmento de enlaces de satélite (29,300– 29,510 MHz), y los 29,000 y 28,500 MHz caen en segmentos de todos los modos (SSB y digitales), sin función de llamada de FM. #no-esta[El plan HF de la IARU para la Región 1 dedica el extremo alto de los 10 m a la FM: 29,100– 29,200 MHz, FM simplex en canales de 10 kHz; 29,520–29,590 MHz, entradas de repetidores (canales RH1 a RH8); 29,600 MHz, canal de llamada de FM; 29,620–29,700 MHz, salidas de repetidores. Entre 29,300 y 29,510 MHz hay enlaces de satélite.]])
#pq(5, 2, 15, "b", "R6.7", "Repetidores de 2 m: entrada 145,000–145,1875 MHz, salida 600 kHz más arriba",
  [Para utilizar un repetidor de VHF, la emisión (entrada del repetidor) se efectúa en el segmento de banda:],
  ([144,000 – 144,100 MHz], [145,000 – 145,1875 MHz], [145,800 – 146,000 MHz], [146,000 – 146,500 MHz],),
  sol: [La entrada de los repetidores de 2 m está en 145,000–145,1875 MHz; la salida, 600 kHz más arriba (145,600–145,7875 MHz). Son los valores clásicos de los bancos; el plan IARU vigente (diciembre de 2020) usa 144,975–145,194 y 145,575–145,7935 MHz.])
#pq(5, 2, 16, "b", "R9.23", "Interferir deliberadamente: nunca está permitido",
  [Interferir deliberadamente las emisiones de otra estación de aficionado:],
  ([se admite en los concursos], [no está permitido en ningún caso], [se admite si la otra estación ocupaba la frecuencia], [se admite si se avisa previamente],),
  sol: [La interferencia deliberada es de las conductas peor consideradas, en lo reglamentario y en lo ético. Ni la competición ni el hecho de que otro «ocupara» la frecuencia la justifican: la respuesta correcta siempre es cambiar de frecuencia.])
#pq(5, 2, 17, "c", "F-R8.14", "Orden IET/1311/2013: entrada en vigor el día siguiente a su publicación",
  [La Orden IET/1311/2013 entró en vigor:],
  ([el mismo día de su publicación en el BOE], [a los veinte días de su publicación en el BOE], [el día siguiente al de su publicación en el BOE], [el 1 de enero de 2014],),
  sol: [La disposición final cuarta dice que la Orden «entrará en vigor el día siguiente al de su publicación» en el BOE. Se publicó el 12 de julio de 2013 (BOE núm. 166), de modo que rige desde el 13 de julio de 2013. Los veinte días son la regla general del art. 2.1 del Código Civil para las leyes, pero solo se aplica si la norma no dispone otra cosa, y aquí sí lo dispone. Entrar en vigor el mismo día de la publicación es más rápido de lo que establece, y el 1 de enero de 2014 no figura en el texto. #_apc3-ver[(Véase tema R8, introducción del tema («tres pisos» normativos).)]

#_apc3-net[La Orden IET/1311/2013, de 9 de julio, se publicó en el BOE núm. 166, de 12 de julio de 2013, y entró en vigor el día siguiente, el 13 de julio de 2013 (disposición final cuarta). Las autorizaciones de uso especial no extinguidas antes de esa fecha conservaron su vigencia y quedaron sometidas al nuevo reglamento (disposición transitoria única). Se dicta al amparo de la competencia exclusiva del Estado en telecomunicaciones, art. 149.1.21.ª de la Constitución (disposición final tercera).]])
#pq(5, 2, 18, "b", "F-R8.64", "Repetidores y radiobalizas: telemando y alimentación ininterrumpida ≥ 6 h",
  [Según el art. 25.g de la Orden IET/1311/2013, las estaciones repetidoras y las radiobalizas deberán disponer de:],
  ([un dispositivo de encendido y apagado por telemando y un sistema de alimentación ininterrumpida de al menos veinticuatro horas], [un dispositivo de encendido y apagado por telemando y un sistema de alimentación ininterrumpida de al menos seis horas], [un operador que las vigile de forma permanente y un sistema de alimentación ininterrumpida de al menos seis horas], [un grupo electrógeno propio y un duplicado completo de sus equipos emisores],),
  sol: [Art. 25.g: repetidores y radiobalizas deben tener un dispositivo de encendido y apagado por telemando (a distancia) y un sistema de alimentación ininterrumpida que las mantenga funcionando como mínimo seis horas si falla la alimentación externa. La a da una cifra errónea (veinticuatro horas). La c exige un operador de guardia, contrario a la idea misma de estación desatendida (anexo I). La d pide un grupo electrógeno y duplicar los equipos, cosas que la norma no contempla. #_apc3-ver[(Véase tema R8, introducción (tabla de cifras: alimentación ininterrumpida de 6 horas).)]

#_apc3-net[Art. 25.g de la Orden IET/1311/2013: las estaciones repetidoras y las radiobalizas deben disponer de un dispositivo de encendido y apagado por telemando, es decir, por mando a distancia, de modo que se puedan conectar o desconectar sin acudir al emplazamiento. Deben tener además un sistema de alimentación ininterrumpida que les permita funcionar, como mínimo, seis horas si falla la alimentación externa.]])
#pq(5, 2, 19, "c", "F-R8.61", "Radiobaliza: distintivo a intervalos ≤ 3 min",
  [Según el art. 25.e de la Orden IET/1311/2013, el intervalo máximo permitido entre dos transmisiones sucesivas del distintivo de una radiobaliza del Servicio de Aficionados es de:],
  ([un minuto], [dos minutos], [tres minutos], [diez minutos],),
  sol: [El art. 25.e dispone que las radiobalizas transmitan su distintivo a intervalos no superiores a tres minutos. El distractor más tentador es el de diez minutos: es el intervalo máximo de los repetidores analógicos (art. 25.d) y el que se exige a toda estación en emisiones de larga duración (art. 29.1). Para una radiobaliza, que funciona emitiendo automáticamente señales de identificación (anexo I), la norma es más estricta. Uno y dos minutos son cifras que la Orden no recoge. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 25.e de la Orden IET/1311/2013: las radiobalizas transmiten su distintivo a intervalos no superiores a tres minutos. Una radiobaliza es una estación automática desatendida destinada a estudios de propagación, cuyo funcionamiento se basa en la emisión automática de señales de identificación. Los repetidores analógicos, en cambio, emiten su distintivo a intervalos no superiores a diez minutos y, en Morse, a una velocidad no superior a diez palabras por minuto (art. 25.d).]])
#pq(5, 2, 20, "d", "F-R8.86", "Interferencia perjudicial: compromete la radionavegación o seguridad, o degrada gravemente o interrumpe un servicio",
  [Según el anexo I de la Orden IET/1311/2013, la «interferencia perjudicial» es la interferencia que:],
  ([produce cualquier degradación de la calidad de la recepción, por ligera que sea, en cualquier servicio], [procede de una estación que supera la potencia máxima autorizada, sea cual sea su efecto], [afecta únicamente a otras estaciones del Servicio de Aficionados o del Servicio de Aficionados por Satélite], [compromete el funcionamiento de un servicio de radionavegación o de otros servicios de seguridad, o degrada gravemente, interrumpe repetidamente o impide el funcionamiento de un servicio de radiocomunicación explotado de acuerdo con el Reglamento de Radiocomunicaciones],),
  sol: [La definición del anexo I atiende al efecto, no al origen ni a la potencia: es perjudicial la interferencia que compromete un servicio de radionavegación u otros de seguridad, o que degrada gravemente, interrumpe repetidamente o impide un servicio de radiocomunicación explotado conforme al Reglamento de Radiocomunicaciones. Una degradación ligera es interferencia, pero no perjudicial (a). La potencia emitida no entra en la definición (b), y se protege a cualquier servicio legítimo, no solo al de aficionados (c). Si la SETSI comprueba que una estación de aficionado la causa, su titular debe cesar las emisiones (artículo 32). #_apc3-ver[(Véase tema T10, introducción del capítulo (dejar de emitir ante una interferencia que afecte a la seguridad).)]

#_apc3-net[Según el anexo I, la interferencia perjudicial es la que compromete el funcionamiento de un servicio de radionavegación o de otros servicios de seguridad, o degrada gravemente, interrumpe repetidamente o impide el funcionamiento de un servicio de radiocomunicación explotado de acuerdo con el Reglamento de Radiocomunicaciones. Si la SETSI comprueba que una estación de radioaficionado la causa a otro servicio autorizado, su titular debe cesar las emisiones y adoptar medidas técnicas razonables (artículo 32 de la Orden).]])
#pq(5, 2, 21, "b", "C-R8.28", "Naturaleza de la autorización: individual, personal e intransferible, revocable",
  [La autorización administrativa de uso del espectro radioeléctrico por radioaficionados:],
  ([Puede ser objeto de transferencia.], [Para su obtención se requerirá haber superado la prueba de capacitación (certificado HAREC).], [Nunca podrá ser objeto de revocación.], [Tiene naturaleza de autorización colectiva.],),
  sol: [Según el art. 5 de la Orden IET/1311/2013, la autorización es individualizada (5.1), requiere haber superado la prueba de capacitación (5.2; quien la supera recibe el certificado HAREC, art. 10.3) y tiene carácter personal y no transferible (5.4). Por eso a y d son falsas. La c también: puede revocarse en los supuestos del art. 8 (por ejemplo, por emisiones con fines comerciales o lucrativos) y se extingue con el fallecimiento del titular. Solo los extranjeros residentes con HAREC extranjero o con convenio de reciprocidad se libran de examinarse (art. 5.2). El enunciado original hablaba del «diploma de operador», figura anterior que hoy equivale al HAREC. #vease[(Véase tema R8, introducción y sección «Uso de la estación y otras cuestiones»; tema R7.)]])
#pq(5, 2, 22, "c", "F-R8.29", "Solicitud de autorización: preferentemente por medios electrónicos, con modelo oficial",
  [Los interesados en obtener la autorización de radioaficionado presentan su solicitud, preferentemente:],
  ([a través de la asociación de radioaficionados de la que sean socios], [en papel y exclusivamente en la Jefatura Provincial de Inspección de Telecomunicaciones], [por medios electrónicos, en la sede electrónica del Ministerio y según el modelo oficial], [mediante escrito libre, sin modelo oficial, enviado por correo electrónico a la SETSI],),
  sol: [El art. 6 admite presentar la solicitud en las Jefaturas Provinciales de Inspección de Telecomunicaciones o en los demás lugares que permite la ley de procedimiento administrativo, pero indica como vía preferente los medios electrónicos de la sede electrónica del Ministerio, según el modelo oficial. No se presenta a través de la asociación (a), el papel en la Jefatura no es la única vía (b) y el escrito libre no sirve: hay modelo oficial (d). La solicitud va acompañada del resguardo de la tasa de tramitación. #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Art. 6 de la Orden IET/1311/2013: la solicitud de autorización de radioaficionado se presenta en las Jefaturas Provinciales de Inspección de Telecomunicaciones, en los demás registros que admite la ley o, preferentemente, por medios electrónicos en la sede electrónica del Ministerio (en 2013, el de Industria, Energía y Turismo), según el modelo oficial publicado en ella. Va acompañada del resguardo de abono de la tasa de tramitación y de la demás documentación que proceda en cada caso. La resuelve la SETSI (art. 7).]])
#pq(5, 2, 23, "d", "C-R8.6", "Contenido de la memoria: toma de tierra, plano, equipos (no el empadronamiento)",
  [En la memoria descriptiva, para la obtención de la licencia de una estación de aficionado, no es preciso incluir:],
  ([Las características y resistencia de la toma de tierra.], [Un plano señalando la ubicación de la estación.], [Marca, modelo y número de serie de los equipos radioeléctricos.], [Certificado de empadronamiento.],),
  sol: [La memoria describe la estación y su instalación para que la Administración compruebe que cumple el Reglamento y es segura (arts. 19 y 20 de la Orden IET/1311/2013). Su contenido clásico es la toma de tierra, el plano de ubicación y la relación de equipos con marca, modelo y número de serie (a, b, c). El empadronamiento no tiene relación con la estación y no se exige; lo que sí debe acreditarse es el derecho a usar el inmueble donde irá la antena (art. 2 del Real Decreto 2623/1986, al que remite el art. 19.c). Régimen anterior: la lista exacta figuraba en el art. 23.1 de la Orden ITC/1791/2006, derogada; la Orden vigente solo habla de «memoria técnica». #vease[(Véase tema R8, sección «Autorización y licencia de estación».)]

    #no-esta[La solicitud de licencia de estación fija (art. 19 de la Orden IET/1311/2013) se acompaña de una memoria técnica descriptiva de la instalación: relación de equipos con marca, modelo y número de serie, antenas y soportes, toma de tierra y plano de ubicación, más lo que acredite el derecho a usar el inmueble. Son datos de la instalación, no del solicitante: por eso un certificado de empadronamiento no forma parte de ella.]])
#pq(5, 2, 24, "a", "C-R8.12", "La licencia se expide terminado el montaje y presentada la documentación",
  [La licencia de estación de radioaficionado se expedirá:],
  ([Finalizado el montaje de la instalación y presentada la documentación requerida en cada caso.], [En el momento de obtener el certificado HAREC (antes llamado diploma de operador).], [La primera semana de cada mes.], [En el momento de presentar la memoria descriptiva de la estación.],),
  sol: [Según el art. 20 de la Orden IET/1311/2013, finalizada la instalación en las condiciones autorizadas, el interesado lo comunica a la Jefatura Provincial en 6 semanas, con la documentación requerida (justificante del seguro y, en su caso, boletín del instalador). La Jefatura dispone de 30 días para verificarla, inspeccionar si procede y expedir la licencia, que habilita a empezar las emisiones. No se expide al obtener el HAREC (b), que solo habilita para pedir la autorización, ni al presentar la memoria (d), que solo permite montar la estación. No hay calendario mensual (c). El banco antiguo decía «diploma de operador» en la b.

    #no-esta[Art. 20 de la Orden IET/1311/2013: la licencia de estación fija se expide al final del proceso, no al principio. Terminada la instalación, el titular lo comunica a la Jefatura Provincial en un plazo de 6 semanas, con el justificante del seguro de antenas y el boletín del instalador. La Jefatura tiene 30 días como máximo para verificar la documentación, inspeccionar si lo estima conveniente y expedir la licencia, que es lo que habilita a comenzar las emisiones.]])
#pq(5, 2, 25, "c", "C-R8.3", "Seguro de responsabilidad civil obligatorio, formalizado antes de expedirse la licencia",
  [El contrato de seguro que cubre la responsabilidad del radioaficionado titular de una licencia de estación:],
  ([Se debe formalizar únicamente si la instalación ha sido autorizada y en un plazo de un mes.], [Sólo debe contratarse si la instalación es técnicamente compleja.], [Debe estar formalizado antes de la expedición de la licencia de estación.], [Debe contratarse cuando se solicita la autorización de radioaficionado.],),
  sol: [El seguro de responsabilidad civil de la antena lo regula el art. 20 del Real Decreto 2623/1986, al que remite el art. 20 de la Orden IET/1311/2013. Su apartado 2 dice que se formaliza una vez autorizado el montaje y, en todo caso, antes de expedirse la licencia de estación: por eso, al terminar la instalación, hay que justificarlo ante la Jefatura Provincial. La a mezcla algo cierto (tras autorizarse el montaje) con un plazo de un mes que la norma no fija. La b es falsa: el seguro es obligatorio siempre. La d también: la autorización de radioaficionado es personal y el seguro va ligado a la estación fija. #vease[(Véase tema R8, sección «Autorización y licencia de estación».)]

    #no-esta[El art. 20 del Real Decreto 2623/1986 obliga a cubrir con un seguro la responsabilidad del titular por daños materiales y personales derivados de la antena (uso, instalación, mantenimiento y desmontaje). Cronología: solicitud; autorización del montaje (art. 19 de la Orden); contrato de seguro, formalizado como muy tarde antes de expedirse la licencia; fin de la instalación, comunicado en 6 semanas con el justificante del seguro (art. 20 de la Orden); licencia. Si deja de mantenerse el seguro, la licencia se cancela automáticamente (art. 21.1.c).]])
#pq(5, 2, 26, "d", "F-R8.3", "Líneas de transmisión a ≥ 10 cm de conductos y canalizaciones del edificio",
  [Según el Reglamento de antenas de aficionado (Real Decreto 2623/1986), la distancia mínima a la que deben situarse las líneas de transmisión y los cables de alimentación respecto de cualquier conducto o canalización de servicios del edificio es de:],
  ([5 cm], [1 m], [50 cm], [10 cm],),
  sol: [El artículo 18.1 fija una distancia mínima de 10 cm entre las líneas de transmisión o los cables de alimentación y cualquier conducto o canalización de servicios del edificio, para impedir su contacto con elementos mecánicos. Además, discurren preferentemente por patinillos de instalaciones o por patios interiores, y no se admite su tendido vertical libre: se fijan a intervalos apropiados (art. 18.2). Con 5 cm no se cumple el mínimo; 50 cm y 1 m son más de lo exigido. #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[Según el artículo 18 del RD 2623/1986, las líneas de transmisión y los cables de alimentación distan al menos 10 cm de cualquier conducto o canalización de servicios del edificio, y discurren preferentemente por patinillos de instalaciones o por patios interiores. No se admite el tendido vertical libre: se fijan a intervalos apropiados. Si van empotrados, se alojan en conductos o canalizaciones de uso exclusivo.]])
#pq(5, 2, 27, "a", "F-R8.57", "Repetidor analógico-digital accedido por red pública: código personal e intransferible + distintivo",
  [Según el art. 23 de la Orden IET/1311/2013, cuando el acceso a un repetidor analógico-digital se realiza a través de una red pública, el repetidor solo será accesible mediante:],
  ([un código personal e intransferible, distinto para cada usuario, y el distintivo de la estación del operador], [solo el distintivo de la estación del operador, sin necesidad de ningún código], [un código personal que cada usuario puede ceder a otros radioaficionados de confianza, junto con el distintivo de su estación], [una clave reservada a los socios de la asociación titular del repetidor],),
  sol: [Art. 23, tercer párrafo: si el acceso se hace a través de una red pública, el repetidor analógico-digital solo es accesible con un código y el distintivo de la estación del operador. El código es personal, intransferible y distinto para cada usuario. Falla la b porque omite el código; la c, porque el código no puede cederse a nadie; y la d, porque el responsable del repetidor está obligado a facilitar la clave a todo radioaficionado que la pida, no solo a los socios. Los enlaces entre repetidores exigen esos mismos códigos. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Un repetidor analógico-digital es una estación repetidora dotada de conversores analógico-digital/digital-analógico. Cuando el acceso a él se hace a través de una red pública, el art. 23 de la Orden IET/1311/2013 exige dos elementos: un código y el distintivo de la estación del operador. El código es personal, intransferible y distinto para cada usuario. La misma exigencia rige si se utilizan enlaces entre repetidores. No confundir con el art. 25.c: el acceso a los repetidores analógicos y digitales finales es libre y, si llevan código, este debe ser públicamente conocido.]])
#pq(5, 2, 28, "a", "C-R9.3", "Ley 11/2022: art. 106 muy graves, 107 graves, 108 leves",
  [De acuerdo con la Ley General de Telecomunicaciones (Ley 11/2022, de 28 de junio), las infracciones se clasifican en:],
  ([Art. 106 muy graves, art. 107 graves, art. 108 leves.], [Art. 105 muy graves, art. 106 graves, art. 107 leves.], [Art. 107 muy graves, art. 108 graves, art. 109 leves.], [Art. 106 graves, art. 107 muy graves, art. 108 leves.],),
  sol: [Según la Ley 11/2022, de 28 de junio (BOE-A-2022-10757), el art. 105 establece la clasificación (muy graves, graves y leves) y los tres artículos siguientes tipifican cada grado por orden de gravedad: art. 106, las muy graves; art. 107, las graves; art. 108, las leves. Las demás opciones desplazan o invierten la numeración: el art. 105 es la clasificación, no una categoría, y el art. 109 trata ya de las sanciones (multas), no de las infracciones. Regla para recordarlo: a mayor gravedad, menor número de artículo (106, 107, 108). #vease[(Véase tema R9, introducción (tabla de grados y conductas típicas con los arts. 106–108).)]])
#pq(5, 2, 29, "c", "R9.1", "Muy grave: interceptar sin autorización telecomunicaciones no destinadas al público",
  [La Ley General de Telecomunicaciones tipifica como infracción MUY GRAVE:],
  ([emitir sin decir «cambio»], [retrasar la aportación de datos requeridos por la Administración], [la interceptación, sin autorización, de telecomunicaciones no destinadas al público en general], [comunicarse con estaciones no autorizadas],),
  sol: [Interceptar sin autorización telecomunicaciones no destinadas al público: infracción muy grave (protege el secreto de las comunicaciones).])
#pq(5, 2, 30, "b", "F-R9.10", "Grave: superar los límites de exposición o no señalizar/vallar",
  [Efectuar emisiones que incumplan los límites de exposición a las emisiones radioeléctricas, o incumplir las medidas de señalización o vallado de las instalaciones radioeléctricas, constituye, según la Ley 11/2022:],
  ([una infracción leve], [una infracción grave], [una recomendación de seguridad, sin consecuencias sancionadoras], [una infracción muy grave],),
  sol: [El art. 107.7 tipifica como infracción grave efectuar emisiones que incumplan los límites de exposición, o incumplir las demás medidas de seguridad, incluidas las obligaciones de señalización o vallado de las instalaciones. También lo es contribuir, con emisiones no autorizadas, a que esos límites se superen. Conecta con el Anexo I, 3.5, de la Orden IET/1311/2013: las potencias máximas no eximen de reducir la potencia emitida, si hace falta, para que la energía radiada quede por debajo del valor que allí se fija en los emplazamientos accesibles o de paso. Sobrepasar los límites ni es una simple recomendación ni una falta leve. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador» (tabla de grados de infracción).)]

#_apc3-net[Art. 107.7 de la Ley 11/2022: es infracción grave efectuar emisiones radioeléctricas que incumplan los límites de exposición fijados en la normativa de desarrollo (niveles de emisión radioeléctrica tolerable) o incumplir las demás medidas de seguridad, incluidas las obligaciones de señalización o vallado de las instalaciones radioeléctricas. También lo es contribuir, mediante emisiones no autorizadas, a que esos límites se incumplan.]])
#fin-prueba()
#soluciones-simulacro(5)

// ======================================================================
#simulacro(6)
#prueba(6, 1)
#pq(6, 1, 1, "b", "T1.6", "Ley de Ohm: hallar V, I o R",
  [Por una resistencia de 1 kΩ circula una corriente continua de 10 mA. La diferencia de potencial entre sus extremos es de:],
  ([1 V], [10 V], [100 V], [0,1 V],),
  sol: [$V = I dot R = 0,01 dot 1000 = 10$ V. Cuidado con los prefijos: 10 mA son 0,01 A.])
#pq(6, 1, 2, "c", "F-T1.50", "Ley de Kirchhoff de las corrientes (nudos)",
  [La ley de Kirchhoff de las corrientes (ley de los nudos) establece que, en un nudo de un circuito:],
  ([la suma de las tensiones de las ramas que concurren en él es cero], [la corriente total es el producto de las corrientes de cada rama], [la suma de las corrientes que entran es igual a la suma de las que salen], [sale siempre menos corriente de la que entra, porque parte se pierde en calor],),
  sol: [Es la conservación de la carga: en un nudo no se acumula carga, luego la corriente total que llega es igual a la que sale (o, con signos, la suma algebraica es cero). En el nudo no hay pérdidas (d). La suma de tensiones igual a cero es la ley de las mallas (a), no la de los nudos. Y las corrientes de las ramas se suman, no se multiplican (b). _(Véase tema T1, sección «Unidades y leyes fundamentales».)_])
#pq(6, 1, 3, "b", "C-T1.15", "Frecuencia: ciclos por segundo (Hz), la característica de la corriente alterna",
  [El número de veces por segundo que una corriente alterna completa un ciclo recibe el nombre de:],
  ([longitud de onda], [frecuencia], [elongación], [período],),
  sol: [
    Es la frecuencia: $f$ ciclos por segundo, medida en hercios (1 Hz = 1 ciclo/s). El período es la
    magnitud inversa, el tiempo que dura un ciclo ($T = 1 slash f$); la longitud de onda es la
    distancia que avanza la onda en un ciclo ($λ = c slash f$), y la elongación es el valor
    instantáneo de la señal en cada momento, su separación respecto del cero. #vease[(Véase tema T1,
    sección «Ondas y señales».)]
  ])
#pq(6, 1, 4, "b", "T1.46", "Objeto de la modulación: que la portadora transporte la información",
  [En una emisión radioeléctrica, la modulación tiene por objeto:],
  ([aumentar la potencia del transmisor], [que la portadora transporte la información], [mejorar el rendimiento de la etapa final], [reducir la longitud de la antena],),
  sol: [La portadora, sola, no dice nada: hay que hacerle variar la amplitud, la frecuencia o la fase al ritmo de la señal que se quiere transmitir. Eso es modular. Ni aumenta la potencia ni acorta la antena.])
#pq(6, 1, 5, "c", "F-T1.37", "Referencias de decibelios: ×2 = +3 dB, ×4 = +6 dB, ×10 = +10 dB, ÷2 = −3 dB",
  [Un transmisor entrega 10 W a un cable coaxial que atenúa 3 dB. La potencia que llega a la antena es aproximadamente de:],
  ([3,3 W], [7 W], [5 W], [2,5 W],),
  sol: [Una pérdida de 3 dB divide la potencia entre 2 (al revés que una ganancia de +3 dB, que la duplica): $P = 10 slash 2 = 5$ W. Con la fórmula, $P_2 = 10 dot 10^(-3 slash 10) approx 5$ W. Los 7 W resultan de restar 3 W a 10 W, cuando los decibelios no se restan de los vatios; los 3,3 W, de dividir entre 3; y los 2,5 W corresponderían a una pérdida de 6 dB. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_])
#pq(6, 1, 6, "d", "T2.50", "C = εS/d: la capacidad depende de la superficie, la separación y el dieléctrico",
  [Reducir el espesor del dieléctrico de un condensador, manteniendo el resto de sus dimensiones, produce:],
  ([la anulación de su capacidad], [un aumento de su tensión máxima de trabajo], [una disminución de su capacidad], [un aumento de su capacidad],),
  sol: [De $C = epsilon S slash d$: la capacidad es inversamente proporcional a la separación entre armaduras. El precio es la tensión de trabajo, que baja al acercarlas — el dieléctrico acaba perforándose.])
#pq(6, 1, 7, "a", "T2.13", "Energía almacenada en un condensador: ½CV² (no confundir con ½LI²)",
  [La energía almacenada en un condensador de capacidad $C$ cargado a una tensión $V$ es:],
  ([$1/2 C V^2$], [$C V$], [$1/2 L I^2$], [$V^2 slash C$],),
  sol: [$E = 1/2 C V^2$. La opción (c) es la energía de la bobina ($1/2 L I^2$): el examen intercambia ambas fórmulas.])
#pq(6, 1, 8, "b", "T2.15", "La bobina almacena energía en el campo magnético (½LI²)",
  [El componente que almacena energía en forma de campo magnético es:],
  ([el diodo], [la bobina], [el condensador], [la resistencia],),
  sol: [La bobina almacena energía en su campo magnético ($E = 1/2 L I^2$); el condensador, en el eléctrico; la resistencia no almacena: disipa.])
#pq(6, 1, 9, "d", "C-T2.16", "Usos del transistor: amplificar, oscilar, mezclar (no rectificar ni hacer de balun)",
  [El transistor se utiliza, entre otras cosas, como:],
  ([Atenuador], [Para sintonizar emisoras de radio], [Rectificador], [Amplificador],),
  sol: [
    La aplicación principal del transistor es amplificar: una pequeña variación en la base (o en la
    puerta del FET) gobierna una corriente o una tensión mucho mayores. Además puede conmutar,
    oscilar y mezclar. Atenuar (a) se consigue con resistencias. Sintonizar emisoras (b) lo hace un
    circuito resonante (bobina y condensador, o varicap); el receptor en su conjunto es quien
    sintoniza, no el transistor. Y rectificar (c) es el trabajo del diodo. #vease[(Véase tema T2,
    sección «Semiconductores y otros componentes».)]
  ])
#pq(6, 1, 10, "b", "F-T3.2", "Resistencia equivalente: serie suma, paralelo menor que la menor (producto/suma; n iguales, R/n); circuitos mixtos",
  [Una resistencia de 10 Ω se conecta en serie con el conjunto en paralelo formado por una de 30 Ω y otra de 60 Ω. La resistencia equivalente es de:],
  ([6,7 Ω], [30 Ω], [100 Ω], [20 Ω],),
  sol: [Primero el paralelo: $30 dot 60 slash (30 + 60) = 1800 slash 90 = 20$ Ω. Ese bloque queda en serie con la resistencia de 10 Ω, luego $R = 10 + 20 = 30$ Ω. Los 100 Ω salen de sumar las tres como si todas estuvieran en serie. Los 20 Ω olvidan la resistencia en serie. Y 6,7 Ω es el resultado de poner las tres en paralelo: $1 slash R = 1/10 + 1/30 + 1/60 = 9/60$. _(Véase tema T1, sección «Unidades y leyes fundamentales».)_])
#pq(6, 1, 11, "d", "F-T3.41", "Bobina real: la capacidad entre espiras la hace autorresonar; por encima se comporta como un condensador",
  [Una bobina real tiene una pequeña capacidad parásita entre sus espiras. A frecuencias elevadas, esa capacidad hace que la bobina:],
  ([siga aumentando su reactancia de forma proporcional a la frecuencia, como la bobina ideal], [deje de tener pérdidas y su factor de calidad se haga infinito], [se comporte como una resistencia pura de valor constante], [resuene consigo misma y, por encima de esa frecuencia, se comporte como un condensador],),
  sol: [La capacidad entre espiras queda en paralelo con la inductancia y forma con ella un circuito resonante: la bobina tiene su propia frecuencia de autorresonancia. Por debajo, la reactancia crece con la frecuencia como en la bobina ideal; en la autorresonancia la impedancia es máxima; por encima domina la capacidad y la bobina se comporta como un condensador. Por eso una bobina de choque de HF puede dejar de «chocar» en VHF. La reactancia no sigue creciendo indefinidamente (a), las pérdidas no desaparecen ni el $Q$ se hace infinito (b), y la bobina no se vuelve resistiva (c). _(Véase tema T3, sección «Asociación de componentes y resonancia».)_])
#pq(6, 1, 12, "a", "T3.37", "Base común: amplifica tensión, pero no corriente",
  [Un amplificador con transistor montado en base común proporciona amplificación:],
  ([de tensión, pero no de corriente], [de corriente, pero no de tensión], [de ninguna de las dos magnitudes], [de corriente y de tensión por igual],),
  sol: [En base común la corriente de salida es prácticamente igual a la de entrada —la ganancia de corriente vale casi 1— pero la impedancia de salida es mucho mayor que la de entrada, y de ahí que la tensión sí se amplifique. Es un montaje habitual en radiofrecuencia por su buen comportamiento en alta frecuencia.])
#pq(6, 1, 13, "c", "T3.11", "Clase AB: combinación de A y B; la de los amplificadores lineales de SSB",
  [De las clases de amplificadores A, B, AB y C, la clase AB:],
  ([es la de mayor rendimiento], [solo se usa en corriente continua], [es una combinación de las clases A y B], [recorta el ciclo completo de la señal],),
  sol: [La clase AB polariza el amplificador entre la A y la B: compromiso entre la linealidad de una y el rendimiento de la otra. Es la habitual en los finales de SSB.])
#pq(6, 1, 14, "c", "T3.40", "VFO: oscilador de frecuencia variable para moverse por la banda",
  [Para poder variar la frecuencia de emisión, los transceptores emplean:],
  ([un multiplicador de frecuencia], [un detector de producto], [un oscilador de frecuencia variable], [un oscilador de cuarzo de frecuencia fija],),
  sol: [El VFO es el que permite moverse por la banda de forma continua. Un cristal fija una sola frecuencia, y por eso los equipos antiguos de canales llevaban un cristal por canal.])
#pq(6, 1, 15, "a", "T4.6", "Sensibilidad: captar y amplificar señales débiles",
  [La sensibilidad de un receptor se define como su capacidad de:],
  ([captar señales débiles y amplificarlas], [funcionar con baterías descargadas], [separar canales adyacentes], [rechazar la frecuencia imagen],),
  sol: [Sensibilidad: captar y amplificar señales débiles; se especifica como la entrada mínima para una relación señal/ruido dada.])
#pq(6, 1, 16, "a", "", "Modulación cruzada: la modulación de una señal fuerte se traslada a la sintonizada (no linealidad)",
  [Se produce modulación cruzada en un receptor cuando:],
  ([la modulación de una señal fuerte no deseada se traslada a la señal que se está escuchando, por falta de linealidad de las primeras etapas], [la señal deseada y su frecuencia imagen se convierten a la misma frecuencia intermedia], [el oscilador local deriva con la temperatura], [el control automático de ganancia reacciona demasiado despacio],),
  sol: [La no linealidad de las primeras etapas «pega» la modulación de una emisora fuerte (por ejemplo, de AM) a la portadora sintonizada: se oye esa emisora de fondo aunque la sintonía esté lejos de ella. La opción b describe la frecuencia imagen, que se resuelve con el preselector, no con mejor linealidad.])
#pq(6, 1, 17, "d", "T5.14", "Emisiones no deseadas = no esenciales + fuera de banda",
  [Se denomina «emisiones no deseadas» al conjunto de:],
  ([las señales recibidas fuera de la banda de aficionados], [las emisiones de los repetidores], [las emisiones con potencia inferior a la autorizada], [las emisiones no esenciales y las emisiones fuera de banda],),
  sol: [Definición reglamentaria: emisiones no deseadas = emisiones no esenciales (espurias) + emisiones fuera de banda.])
#pq(6, 1, 18, "b", "C-T5.18", "Conmutador SEND/REC: pasa de emisión a recepción y viceversa",
  [El conmutador SEND/REC se utiliza para:],
  ([Cambiar de modo de emisión], [Cambiar de emisión a recepción o viceversa], [Encender el transceptor], [Cambiar de banda],),
  sol: [
    SEND/REC (del inglés #emph[send]/#emph[receive], enviar/recibir) es el conmutador que pasa el
    equipo de emisión a recepción y viceversa: activa el relé de transmisión-recepción y los
    circuitos de cada modo. No cambia de banda (eso lo hace el conmutador de bandas), no enciende el
    aparato (interruptor de alimentación) ni cambia la clase de emisión (selector de modo: LSB, USB,
    AM, FM, CW). #vease[(Véase tema T6, sección «La conmutación de antena».)]
    #no-esta[En muchos equipos el mando que pasa de recibir a transmitir se rotula SEND/REC o TX/RX; en los
    transceptores modernos esa misma función la cumple el pulsador PTT (#emph[push to talk]), y el
    VOX la automatiza con la voz. Conviene no confundirlo con el conmutador de bandas (tema T3) ni
    con el selector de modo (tema T4): cada mando hace una sola cosa.]
  ])
#pq(6, 1, 19, "a", "C-T6.11", "Elementos reactivos en serie: la bobina alarga eléctricamente la antena (baja f), el condensador la acorta (sube f)",
  [Para acortar la longitud eléctrica de una antena se puede proceder a:],
  ([Insertar un condensador, en serie, en la base], [Alargar la longitud del hilo de antena], [Aumentar la corriente de antena], [Modular menos profundamente],),
  sol: [
    Un condensador en serie en la base añade reactancia capacitiva y hace que la antena se comporte
    como si tuviera menos hilo: su longitud eléctrica disminuye y resuena más alto. Alargar el hilo
    (b) hace justo lo contrario. La corriente de antena (c) y la profundidad de modulación (d) no
    cambian la longitud de la antena, solo la potencia radiada o la calidad de la señal. Ojo al
    sentido inverso: para que una antena físicamente corta resuene en una frecuencia más baja, lo
    que se añade es una bobina de carga, que la alarga eléctricamente. #vease[(Véase tema T6,
    sección «El dipolo y otras antenas».)]
    #no-esta[Longitud eléctrica de una antena: la que «ve» la señal, que puede diferir de la física al
    intercalar elementos reactivos en serie. Un condensador acorta eléctricamente la antena (sube su
    frecuencia de resonancia) y se usa cuando el hilo es demasiado largo para la banda. Una bobina
    la alarga (baja la frecuencia de resonancia) y se usa, como bobina de carga, cuando el hilo es
    demasiado corto.]
  ])
#pq(6, 1, 20, "d", "T6.38", "Reciprocidad: el mismo diagrama en transmisión y en recepción",
  [En una antena pasiva puede afirmarse que:],
  ([su diagrama cambia con la potencia aplicada], [recibe mejor de lo que radia], [radia mejor de lo que recibe], [su diagrama de radiación en transmisión y en recepción es el mismo],),
  sol: [Es el principio de reciprocidad: una antena se comporta igual emitiendo que recibiendo, con el mismo diagrama y la misma ganancia. Por eso apuntar una directiva sirve tanto para transmitir como para escuchar.])
#pq(6, 1, 21, "a", "F-T6.18", "Transformador de cuarto de onda: Z = √(Zlínea · Zcarga); Zent = Z0²/ZL",
  [Se quiere adaptar una antena de 200 Ω a una línea de 50 Ω con un tramo de cuarto de onda. La impedancia característica de ese tramo debe ser:],
  ([100 Ω], [125 Ω], [12,5 Ω], [150 Ω],),
  sol: [Un cuarto de onda transforma la carga $Z_L$ en $Z_"ent" = Z_0^2 slash Z_L$. Para que la entrada sea de 50 Ω con $Z_L = 200$ Ω: $Z_0 = sqrt(Z_"ent" Z_L) = sqrt(50 dot 200) = sqrt(10 thin 000) = 100$ Ω, la media geométrica. Comprobación: $100^2 slash 200 = 50$ Ω. Los 125 Ω salen de usar la media aritmética, los 150 Ω de restar las impedancias y los 12,5 Ω de invertir la fórmula ($50^2 slash 200$). #vease[(Véase tema T6, sección «Líneas de transmisión y adaptación».)]])
#pq(6, 1, 22, "c", "T6.17", "Orden de conexión: transceptor → (lineal) → medidor de ROE → acoplador → antena",
  [El orden correcto de conexión de los equipos de una estación, desde el equipo hasta la antena, es:],
  ([medidor de ROE, acoplador de antena, transceptor, antena], [acoplador de antena, transceptor, medidor de ROE, antena], [transceptor, medidor de ROE, acoplador de antena, antena], [antena, transceptor, acoplador, medidor de ROE],),
  sol: [Orden canónico: transceptor → medidor de ROE → acoplador → antena (si hay amplificador lineal, va entre el transceptor y el medidor).])
#pq(6, 1, 23, "c", "", "De noche desaparece la capa D y F1 y F2 se funden en una sola capa F",
  [Al caer la noche, en la ionosfera:],
  ([desaparece la capa F y solo queda la capa D], [la capa F se divide en F1 y F2, que de día forman una sola], [desaparece la capa D y las capas F1 y F2 se funden en una sola capa F], [la capa D se refuerza y absorbe más las bandas bajas],),
  sol: [Sin sol, los electrones se recombinan con los iones. En la capa D, donde el aire es relativamente denso, eso ocurre en minutos y la capa desaparece; en la F, muy tenue, tarda horas, así que sobrevive toda la noche con F1 y F2 fundidas en una sola capa. Por eso de noche las bandas bajas (80 y 160 m) dejan de sufrir la absorción de la D y llegan lejos.])
#pq(6, 1, 24, "b", "F-T7.7", "Meteor-scatter: reflexión en las estelas ionizadas de los meteoros",
  [La propagación por meteor-scatter se basa en:],
  ([el guiado de las ondas por conductos de la troposfera], [la reflexión en las estelas ionizadas que dejan los meteoros al entrar en la atmósfera], [la reflexión en nubes de ionización intensa de la capa E], [la reflexión de las ondas en la superficie de la Luna],),
  sol: [Un meteoro que entra en la atmósfera a gran velocidad, hacia los 100 km de altura, deja una estela de gas ionizado que, durante un instante, refleja las ondas de VHF como un pequeño espejo. Eso permite enlaces de unos cientos a dos mil kilómetros en 50 y 144 MHz, sobre todo durante las lluvias de meteoros. La Luna es el reflector del EME, los conductos son cosa de la troposfera y las nubes de la capa E dan la esporádica-E. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]])
#pq(6, 1, 25, "a", "", "Ruido atmosférico (tormentas): domina en las bandas bajas de HF",
  [El ruido atmosférico, producido por las descargas de las tormentas de todo el planeta:],
  ([domina en las bandas bajas de HF, sobre todo en verano], [es el que produce la agitación térmica de los electrones en la entrada del receptor], [solo afecta a UHF y a las frecuencias superiores], [procede sobre todo del centro de la Vía Láctea],),
  sol: [Los rayos de las tormentas producen impulsos de RF que la ionosfera propaga igual que las señales, de modo que se oyen a miles de kilómetros: es el ruido que domina en las bandas bajas de HF y en verano. La agitación de los electrones produce el ruido térmico, y el que llega del centro de la galaxia es el ruido galáctico, que se nota entre unos 20 y 200 MHz.])
#pq(6, 1, 26, "d", "T8.6", "Frecuencímetro: medida precisa de la frecuencia (un voltímetro de RF no la mide)",
  [Para medir con precisión la frecuencia emitida por un transmisor se emplea:],
  ([un vatímetro], [un polímetro], [un medidor de ROE], [un frecuencímetro de radiofrecuencia],),
  sol: [El frecuencímetro cuenta ciclos contra una referencia de cristal: el instrumento de precisión para la frecuencia.])
#pq(6, 1, 27, "c", "C-T8.9", "S-meter: S9 = 50 μV sobre 50 Ω en HF (escala en microvoltios)",
  [Una señal de radio que se recibe con indicación S9 en el S-meter corresponde a un voltaje rms
sobre los 50 Ω del terminal de antena de:],
  ([1 μV], [1 mV], [50 μV], [100 dBμV],),
  sol: [
    El convenio de la IARU para HF fija S9 = 50 μV rms sobre 50 Ω, que equivale a 34 dBμV y a −73
    dBm: $P = (50 · 10^(−6))^2 slash 50 = 5 · 10^(−11)$ W. Cada punto S son 6 dB, es decir, el doble
    o la mitad de tensión. 1 μV queda unos 34 dB por debajo de S9 (algo más de S3); 1 mV es S9 + 26
    dB; y 100 dBμV son 0,1 V, unos 66 dB sobre S9. #vease[(Véase tema T4, sección «Características y
    controles».)]
  ])
#pq(6, 1, 28, "a", "T9.3", "Desadaptación (ROE alta) favorece las interferencias; conviene ROE baja",
  [Una desadaptación de impedancias entre el transmisor y la antena puede producir:],
  ([interferencias], [una reducción de los armónicos], [un aumento de la sensibilidad del receptor], [una mejora del rendimiento],),
  sol: [La desadaptación eleva la ROE y provoca onda reflejada y radiación por la línea, que se acopla a los equipos cercanos; de ahí la recomendación de trabajar siempre con la ROE lo más baja posible.])
#pq(6, 1, 29, "d", "T10.21", "Umbrales de corriente (1 mA se nota, 10–20 mA no se suelta, ~30 mA fibrilación): cuál es más peligrosa",
  [De las siguientes intensidades atravesando el cuerpo humano, la más peligrosa es:],
  ([1 mA], [5 mA], [10 mA], [50 mA],),
  sol: [Hacia 1 mA solo se percibe; en torno a 10–20 mA los músculos dejan de obedecer y no se puede soltar el conductor; desde unos 30 mA acecha la fibrilación ventricular. 50 mA está de lleno en esa zona, y por eso los diferenciales domésticos cortan a 30.])
#pq(6, 1, 30, "d", "T10.9", "Fusible fundido: sustituirlo por otro del mismo calibre (nunca mayor ni un puente)",
  [Cuando se funde el fusible de un equipo, debe sustituirse por:],
  ([cualquiera que quepa en el portafusibles], [un puente de hilo de cobre], [uno de mayor calibre, para que no vuelva a fundirse], [otro del mismo calibre que el original],),
  sol: [Un fusible fundido es un aviso, no una molestia: algo ha consumido más de la cuenta. Poner uno mayor o un puente elimina la protección justo donde ya se sabe que hay un problema, y el siguiente en fundirse será el equipo.])
#fin-prueba()
#prueba(6, 2)
#pq(6, 2, 1, "a", "C-R1.3", "Deletreo de distintivo EA3RCQ: R Romeo, C Charlie, Q Quebec (no «Queen»), 3 Three",
  [El deletreo del distintivo EA3RCQ según el alfabeto fonético internacional:],
  ([Echo, Alfa, Three, Romeo, Charlie, Quebec.], [El deletreo de distintivos no está permitido.], [Echo, Alfa, Tres, Romeo, Charlie, Quebec.], [E, A, Tres, R, C, Q.],),
  sol: [E = Echo, A = Alfa, 3 = Three, R = Romeo, C = Charlie, Q = Quebec. Las opciones a y c solo se distinguen en la cifra: el deletreo internacional da las cifras por su nombre inglés (Three), no en español (Tres). La d se limita a nombrar las letras sin palabras de deletreo, justo lo que el alfabeto fonético pretende evitar, porque una letra suelta se confunde con facilidad. La b es falsa: deletrear el distintivo es práctica habitual y forma parte del temario. #vease[(Véase tema R1, tabla del alfabeto y nota sobre las cifras.)]])
#pq(6, 2, 2, "d", "R2.15", "QRS transmita más despacio / QRQ más deprisa",
  [El grupo del código Q con el que se pide a la estación corresponsal que transmita más de prisa es:],
  ([`QRS`], [`QRV`], [`QRO`], [`QRQ`],),
  sol: [`QRQ` es «más de prisa» y `QRS`, «más despacio»: van en pareja y se confunden con facilidad. `QRO` es subir potencia y `QRV`, estar preparado.])
#pq(6, 2, 3, "d", "C-R2.1", "QRK inteligibilidad, QSA intensidad, QRI tono (las tres valoraciones de la señal)",
  [¿Qué abreviatura del código Q se refiere a la inteligibilidad de las señales?],
  ([QRL], [QRA], [QRM], [QRK],),
  sol: [QRK es el grupo de la inteligibilidad (legibilidad) de las señales: «¿cuál es la inteligibilidad de mis señales?» o, como respuesta, «la inteligibilidad de sus señales es…», en una escala de 1 a 5. Es la «R» del informe RST. No lo confundas con QSA (fuerza de la señal) ni con QRI (tono). Los distractores son otros grupos: QRL (ocupado), QRM (interferencia de otras estaciones) y QRA (nombre de la estación). La pregunta también cae a la inversa: «QRK significa…» se responde «inteligibilidad de las señales». #vease[(Véase tema R2, tabla «Grupos del código Q más frecuentes».)]])
#pq(6, 2, 4, "b", "R2.26", "QTA anule el mensaje",
  [El grupo `QTA` se utiliza para indicar que:],
  ([se transmite en una frecuencia distinta], [se anule el mensaje indicado], [se cambia de antena], [la estación queda a la escucha],),
  sol: [«Anule el mensaje número …». Sirve para retirar un mensaje ya transmitido que ha dejado de ser válido, algo especialmente importante en tráfico de emergencia.])
#pq(6, 2, 5, "b", "R3.13", "K invitación a transmitir («cambio»)",
  [En telegrafía, la abreviatura de procedimiento `K` significa:],
  ([petición de repetición del mensaje], [invitación a transmitir a la estación corresponsal], [fin definitivo de la comunicación], [cierre de la estación],),
  sol: [Es el «cambio» de la telegrafía: he terminado, hable usted. No debe confundirse con `SK`, que cierra el contacto entero, ni con `CL`, que cierra la estación.])
#pq(6, 2, 6, "d", "R3.19", "TNX / TKS y TU: gracias",
  [La abreviatura `TNX` (o `TKS`) significa:],
  ([transmisor en pruebas], [cambio de frecuencia], [transmisión no cifrada], [gracias],),
  sol: [Contracción de _thanks_. El cambio de frecuencia es `QSY`.])
#pq(6, 2, 7, "d", "C-R3.5", "MSG mensaje",
  [En telegrafía, la abreviatura operacional «MSG» significa:],
  ([Gracias], [Amigo], [Señal], [Mensaje],),
  sol: [MSG es la abreviatura de #emph[message]: «mensaje». Las demás respuestas corresponden a otras abreviaturas: «gracias» es TNX o TKS, «amigo» (#emph[old man]) es OM y «señal» es SIG.

    #no-esta[MSG (del inglés #emph[message]) significa «mensaje», el texto que se envía en el tráfico de mensajes. No lo confundas con el grupo Q QTC («tengo mensajes para usted»). Muchas abreviaturas son la palabra inglesa sin vocales: MSG (#emph[message]), SIG (#emph[signal]), PWR (#emph[power]). No figura en las tablas del cuaderno.]])
#pq(6, 2, 8, "a", "R4.3", "Seguridad en radiotelefonía: SÉCURITÉ (tres veces)",
  [La señal de seguridad en radiotelefonía se compone de:],
  ([la palabra «Sécurité» repetida tres veces], [la palabra «Mayday» repetida tres veces], [tres tonos largos de 1000 Hz], [la palabra «Seguridad» seguida del distintivo],),
  sol: [#_r4-sc("Sécurité") tres veces: avisos de seguridad (meteorológicos o a la navegación).])
#pq(6, 2, 9, "b", "F-R4.3", "Centros de actividad de emergencia IARU R1: 14300 kHz (mundial) y 3760 kHz (80 m)",
  [En el plan de bandas de la IARU para la Región 1, la frecuencia de 14300 kHz está señalada como centro de actividad de:],
  ([telefonía en banda lateral única de baja potencia (#_apc2-m[QRP])], [emergencia de ámbito mundial], [imagen (SSTV, fax)], [voz digital],),
  sol: [El plan de bandas de la IARU para la Región 1 señala en 20 m varios centros de actividad: voz digital en 14130 kHz, imagen en 14230 kHz, SSB de baja potencia en 14285 kHz y, en 14300 kHz, el centro de emergencia de ámbito mundial (_Global Emergency Centre of Activity_). Las otras tres opciones son centros reales de la banda, pero de otros modos y en otras frecuencias; por eso hay que asociar cada valor con su uso. Pista: en 15 m, 21360 kHz es también centro de emergencia global. #vease[(Véase tema R6, introducción del capítulo (reparto de cada banda en segmentos por modos, frecuencias de llamada).)] #no-esta[El plan de bandas de la IARU para la Región 1 marca en HF centros de actividad de emergencia: 3760 kHz (80 m), 7110 kHz (40 m), 14300 kHz (20 m), 18160 kHz (17 m) y 21360 kHz (15 m); los de 14300 y 21360 kHz se designan «globales». Son frecuencias de referencia señaladas por el plan para la actividad de emergencia. La Orden (Anexo I, 3.1) remite, como norma general, al plan de la IARU para la Región 1 en cuanto a los anchos de banda.]])
#pq(6, 2, 10, "c", "C-R5.7", "Estaciones automáticas desatendidas: prefijo ED; sufijo con Y (analógica) o Z (digital)",
  [El indicativo de llamada ED3ZHO:],
  ([Pertenece a una estación fija de la provincia de Zaragoza], [Tiene carácter temporal], [Corresponde a una estación automática desatendida], [No se puede adjudicar a estación colectiva alguna],),
  sol: [El distintivo se lee por partes: el prefijo ED es el de las estaciones automáticas desatendidas, el 3 es el distrito (Cataluña) y el sufijo ZHO empieza por Z, letra reservada a las desatendidas digitales (la Y, a las analógicas). La a falla: la Z no es Zaragoza, que es del distrito 2. La b también: ED sirve igualmente en usos temporales, pero entonces conserva el sufijo personal del titular, y un sufijo con Z nunca es personal. La d habla de estaciones colectivas, que llevan sufijos UR, RC o RK. #vease[(Véase tema R5, introducción y sección «Sufijos y usos temporales».)]])
#pq(6, 2, 11, "d", "", "Sufijo de una letra como distintivo permanente: 15 años de práctica internacional",
  [Para que se le asigne un distintivo con sufijo de una sola letra, un radioaficionado con al menos cinco años de autorización española y sin expediente sancionador en los últimos cinco años debe acreditar una práctica en la radioafición internacional de:],
  ([veinticinco años], [diez años], [cinco años], [quince años],),
  sol: [El art. 27 de la Orden pide quince años de práctica internacional para el sufijo de una letra. Los cinco años son los que se exigen para el de dos letras, y por eso son la trampa típica. Ni diez ni veinticinco años son requisito para ningún sufijo.])
#pq(6, 2, 12, "a", "R5.15", "Prefijos temporales ED, EE y EF: eventos ordinarios; mantienen el resto del distintivo",
  [Los prefijos de uso temporal `ED`, `EE` y `EF`, a diferencia de `EG`, `EH`, `AM`, `AN` y `AO`:],
  ([mantienen sin variación el resto del distintivo asignado con carácter permanente al radioaficionado], [obligan a cambiar también el sufijo], [solo pueden usarse en telegrafía], [se asignan exclusivamente a extranjeros],),
  sol: [Con `ED`, `EE` y `EF` solo cambia el prefijo: cifra y sufijo siguen siendo los del distintivo permanente (art. 27.1.a de la Orden; p. ej. `EA4XYZ` emite como `EE4XYZ`). El art. 27.1 no dice lo mismo de `EG`, `EH`, `AM`, `AN` y `AO`, que se asignan con sufijo propio de dos o tres letras. `ED` tiene doble papel: prefijo permanente de las estaciones automáticas desatendidas y también temporal, junto con EE y EF. Ojo: el enunciado del banco público agrupa «EE, EF y EG» como si los tres mantuvieran el resto del distintivo; el art. 27.1.a solo menciona ED, EE y EF, pero si en el examen aparece así, la opción a es la que dan por buena.])
#pq(6, 2, 13, "b", "F-R5.15", "Distintivo temporal: máximo 30 días al año por sufijo y peticionario (excepción: una letra en concursos, hasta 2 años)",
  [Para los distintivos temporales, los períodos autorizados para un mismo sufijo y peticionario no son, como norma general, superiores a:],
  ([10 días al año], [30 días al año], [90 días al año], [un año natural completo],),
  sol: [El último párrafo del art. 28 fija el límite general en 30 días al año por sufijo y peticionario. Las opciones a y c son cifras plausibles, pero no figuran en la Orden. La d recuerda la excepción, que es distinta: los distintivos con sufijo de una letra usados exclusivamente para participar en concursos de alta competitividad pueden autorizarse al mismo titular por períodos de hasta dos años, a partir de la fecha de autorización. Además, cada evento exige una solicitud independiente (art. 28). #vease[(Véase tema R5, sección «Sufijos y usos temporales».)] #no-esta[Los distintivos temporales se piden con una solicitud independiente por cada evento (art. 28). Como norma general, los períodos autorizados para un mismo sufijo y peticionario no superan 30 días al año. Excepción: el sufijo de una letra usado solo en concursos de alta competitividad puede autorizarse al mismo titular hasta dos años, contados desde la fecha de autorización.]])
#pq(6, 2, 14, "b", "C-R6.3", "Naturaleza de los planes: acuerdos voluntarios y guía mundial, pero la Orden obliga a usar el de la Región 1 como norma general en España",
  [Sobre los planes de bandas de la IARU es correcto decir que:],
  ([La IARU no tiene planes de banda para la Región 1.], [Sirven de guía a los radioaficionados de todo el mundo.], [Deben ser tenidos en cuenta únicamente si se opera en Canarias.], [En España se deben aplicar los planes de banda de la IARU para la Región 2.],),
  sol: [Los planes de banda no son normas legales sino recomendaciones de convivencia: reparten cada banda por modos y sirven de guía a los radioaficionados de todo el mundo, cada uno con el plan de su Región. La a) es falsa: la Región 1 tiene el suyo. La c) también: la Orden IET/1311/2013 (art. 2.2) manda usar, como norma general, el plan de la Región 1 en todo el territorio español, y Canarias es una parte más. La d) es falsa: España pertenece a la Región 1 (Europa y África), no a la 2, que es América. #vease[(Véase tema R6, introducción del capítulo y sección «Las tres regiones de la UIT».)]])
#pq(6, 2, 15, "c", "R7.11", "Contenido: temas del servicio y observaciones de carácter personal",
  [Las transmisiones entre estaciones de aficionado deben limitarse a:],
  ([retransmisiones de emisoras de radiodifusión], [mensajes de terceros de carácter comercial], [comunicaciones relacionadas con el servicio de aficionados y observaciones de carácter personal], [cualquier asunto, siempre que no se emplee lenguaje ofensivo],),
  sol: [El servicio no es un medio de comunicación general: las transmisiones se ciñen a asuntos propios de la radioafición, con las observaciones de carácter personal que la cortesía admite. Lo que queda fuera es el tráfico comercial y el de terceros con contenido ajeno al servicio.])
#pq(6, 2, 16, "d", "F-R7.3", "Autorregulación (self-policing): autodisciplina, sin policía propia",
  [Se dice que la comunidad radioaficionada es, en gran medida, «autorregulada» (_self-policing_). Esto significa que:],
  ([las asociaciones de radioaficionados pueden multar a los operadores que incumplan las normas], [la Administración renuncia a inspeccionar las estaciones, porque de eso se ocupan los propios aficionados], [cada operador decide por sí mismo qué bandas, frecuencias y potencias utiliza], [la buena conducta en las bandas descansa en la autodisciplina de cada aficionado, sin que la comunidad tenga una policía propia],),
  sol: [La idea procede del manual de la IARU _Ethics and Operating Procedures for the Radio Amateur_: la autodisciplina de cada uno es la base de la conducta, lo que no implica que la comunidad tenga servicios de policía propios. La inspección y las sanciones siguen siendo de la Administración (Orden IET/1311/2013, arts. 33 y 34), por lo que ni las asociaciones multan (a) ni la Administración renuncia a inspeccionar (b). Y las bandas, frecuencias y potencias las fija la reglamentación, no el operador (c). #vease[(Véase tema R7, sección «Responsabilidad social y procedimientos operativos».)] #no-esta[La radioafición se considera en gran medida autorregulada: las autoridades suelen fijarse solo en que se cumplan las normas legales, y por eso la base de la conducta en las bandas es la autodisciplina de cada aficionado. Eso no significa que la comunidad tenga policía propia: la inspección y las sanciones corresponden a la Administración (Orden IET/1311/2013, arts. 33 y 34). De ahí la importancia de conocer las normas de buena práctica y aplicarlas sin esperar a que nadie nos las exija.]])
#pq(6, 2, 17, "a", "F-R8.11", "RD 123/2017: Reglamento sobre el uso del dominio público radioeléctrico",
  [El Real Decreto 123/2017, de 24 de febrero, aprueba el:],
  ([Reglamento sobre el uso del dominio público radioeléctrico], [Reglamento de instalación de antenas de aficionado en el exterior de los inmuebles], [Reglamento del procedimiento de evaluación de la conformidad de los aparatos de telecomunicaciones], [Reglamento de la actividad de instalación y mantenimiento de equipos y sistemas de telecomunicación],),
  sol: [El Real Decreto 123/2017 aprueba el Reglamento sobre el uso del dominio público radioeléctrico, que derogó el Real Decreto 863/2008 (disposición derogatoria única, a), todavía citado en la exposición de motivos y en el art. 1 de la Orden IET/1311/2013. Es el reglamento general de la Ley General de Telecomunicaciones en esta materia; en él se regulan el uso especial y su autorización individual para radioaficionados (arts. 22 y 25). Las demás opciones son reglamentos que la Orden también cita: el Real Decreto 2623/1986 (antenas, art. 18.2), el 1890/2000 (conformidad de aparatos, art. 5.5) y el 244/2010 (instaladores, art. 19.e). #_apc3-ver[(Véase tema R8, introducción del tema («tres pisos» normativos).)]

#_apc3-net[El Reglamento sobre el uso del dominio público radioeléctrico, aprobado por el Real Decreto 123/2017, de 24 de febrero, desarrolla la Ley General de Telecomunicaciones en lo relativo al espectro y derogó el Real Decreto 863/2008, que es el que todavía cita la Orden IET/1311/2013 (exposición de motivos y art. 1). Distingue los usos común, especial y privativo: el de los radioaficionados es uso especial, con autorización individual (arts. 22 y 25). También prevé el Cuadro Nacional de Atribución de Frecuencias (art. 6).]])
#pq(6, 2, 18, "c", "F-R8.12", "Uso del espectro por radioaficionados: uso especial, con autorización individual; explotación compartida sin exclusión de terceros",
  [El uso del dominio público radioeléctrico por los radioaficionados está clasificado como:],
  ([uso común, que no necesita título habilitante], [uso privativo, mediante concesión administrativa], [uso especial, mediante autorización individual], [uso reservado al Estado],),
  sol: [Es un uso especial: lo dicen la exposición de motivos de la Orden IET/1311/2013 y sus arts. 1.1 y 2.1. Según el art. 88.1 de la Ley 11/2022, el uso especial es el de las bandas habilitadas para su explotación compartida, sin limitación de número de usuarios, y para los radioaficionados se otorga mediante autorización individual (art. 88.5.a). No es uso común, que no necesita título habilitante (aquí hace falta la autorización de radioaficionado, art. 5.1 de la Orden). Tampoco es privativo, que es la explotación en exclusiva o por un número limitado de usuarios. El uso reservado al Estado es otra categoría del CNAF. #_apc3-ver[(Véase tema R8, sección «Uso de la estación y otras cuestiones».)]

#_apc3-net[El uso del dominio público radioeléctrico puede ser común, especial o privativo (art. 88.1 de la Ley 11/2022). El común no precisa título habilitante. El privativo es la explotación en exclusiva o por un número limitado de usuarios. El especial es el de las bandas habilitadas para su explotación compartida, sin limitación de número de usuarios. El de los radioaficionados es uso especial (art. 2.1 de la Orden IET/1311/2013) y se ejerce mediante autorización individual (art. 88.5.a de la Ley 11/2022): la autorización de radioaficionado.]])
#pq(6, 2, 19, "a", "R8.40", "Distintivo de los repetidores analógicos: Morse ≤ 10 palabras/min, cada ≤ 10 min",
  [Los repetidores analógicos deben emitir automáticamente su distintivo de llamada en código Morse a una velocidad no superior a:],
  ([diez palabras por minuto], [cincuenta palabras por minuto], [veinte palabras por minuto], [quince palabras por minuto],),
  sol: [Art. 25.d de la Orden: mientras duren las emisiones, los repetidores analógicos emiten su distintivo de forma automática, en radiotelefonía o en Morse, a una velocidad no superior a diez palabras por minuto y a intervalos no superiores a diez minutos, por modulación de la portadora mediante un tono de audio. El banco público lo formula «a una velocidad de»; con esa redacción, diez es la cifra que dan por buena.])
#pq(6, 2, 20, "b", "F-R8.67", "Interferencia persistente: la SETSI puede restringir bandas, potencia u horario",
  [Si una estación automática desatendida causa interferencia perjudicial a otros servicios legalmente autorizados, el art. 26 de la Orden IET/1311/2013 remite al art. 32. Según este, si tras adoptar las medidas técnicas exigidas la interferencia persiste, la SETSI podrá imponer, excepcionalmente, restricciones en cuanto a:],
  ([el tipo de modulación y el número de operadores autorizados], [las bandas de frecuencias, la potencia o el horario de las emisiones], [el distintivo de llamada y la titularidad de la estación], [la ubicación de la estación y el tipo de antena utilizada],),
  sol: [El art. 26 remite al art. 32, que actúa en tres pasos. Si la SETSI comprueba la interferencia, el titular cesa sus emisiones y adopta a su costa medidas técnicas razonables. Tras comunicar esas medidas a la SETSI puede reiniciar sin más trámite. Si la interferencia persiste, la SETSI puede imponer, con carácter excepcional, restricciones en cuanto a las bandas de frecuencias, la potencia o el horario de las emisiones. Ubicación, antena, modulación, distintivo y titularidad no figuran entre ellas. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 32 de la Orden IET/1311/2013 (interferencia perjudicial a otros servicios autorizados o a la recepción de radiodifusión sonora o de televisión). 1.º Comprobada por la SETSI, el titular cesa las emisiones y, siguiendo sus instrucciones, adopta a su costa medidas técnicas razonables. 2.º Comunica esas medidas a la SETSI de forma fehaciente y puede reiniciar sin más trámite. 3.º Si la interferencia persiste, la SETSI puede imponer, excepcionalmente, restricciones de bandas, potencia u horario.]])
#pq(6, 2, 21, "a", "F-R8.72", "Seguridad: la SETSI no es responsable en ningún caso del incumplimiento de las normas de seguridad",
  [Según el artículo 31 de la Orden IET/1311/2013, cuando una instalación de radioaficionado incumple las normas de seguridad aplicables, la SETSI:],
  ([no es responsable en ningún caso del incumplimiento de tales normas], [responde subsidiariamente de los daños causados a terceros], [comparte la responsabilidad con el titular si concedió la licencia de la estación], [responde solo si la Jefatura Provincial había inspeccionado antes la instalación],),
  sol: [El artículo 31 pone la obligación en el titular de la autorización: cumplir la normativa de seguridad de las Administraciones competentes para evitar accidentes derivados del uso de sus estaciones. Y cierra con una frase tajante: la SETSI no es responsable, en ningún caso, del incumplimiento de tales normas. De ahí que no haya responsabilidad subsidiaria (b), ni compartida por haber concedido la licencia (c), ni condicionada a una inspección previa (d): conceder la autorización no traslada la responsabilidad a la Administración. #_apc3-ver[(Véase tema T10, sección «Fusibles y protecciones» (última pregunta del capítulo: obligación del titular de cumplir la normativa de seguridad).)]

#_apc3-net[Art. 31 de la Orden IET/1311/2013: el titular de la autorización debe cumplir la normativa de seguridad que establezcan las distintas Administraciones Públicas, según sus competencias, para evitar cualquier accidente derivado del uso de sus estaciones. Equipos, antenas y elementos anejos deben mantenerse adecuadamente, y cualquier anomalía que afecte a su seguridad mecánica o eléctrica se subsana de forma inmediata. La SETSI no es responsable, en ningún caso, del incumplimiento de esas normas. Los titulares de licencias de estaciones fijas garantizan además el uso conforme a la legislación, también a través de su interconexión con otras redes o servicios.]])
#pq(6, 2, 22, "a", "R8.10", "RD 2623/1986: reglamento de las instalaciones de antenas de aficionado",
  [El Real Decreto 2623/1986 regula:],
  ([las instalaciones de antenas de las estaciones radioeléctricas de aficionado], [los planes de banda nacionales], [el código de deletreo oficial], [las tasas del examen de radioaficionado],),
  sol: [El RD 2623/1986 regula las instalaciones de antenas, en desarrollo de la Ley 19/1983.])
#pq(6, 2, 23, "b", "R8.31", "Licencia CEPT: sin protección contra interferencias perjudiciales",
  [Un radioaficionado español que utiliza temporalmente su estación en un país que aplica la Recomendación CEPT T/R 61-01:],
  ([puede emitir en cualquier banda sin restricción], [no podrá solicitar protección contra interferencias perjudiciales], [queda exento de identificarse], [tiene prioridad sobre las estaciones locales],),
  sol: [El titular de una licencia CEPT que emite fuera de su territorio nacional no puede solicitar protección contra interferencias perjudiciales (art. 14.f de la Orden). No lo confundas con la categoría de servicio secundario de una atribución, que es otra cosa.])
#pq(6, 2, 24, "c", "C-R8.31", "HAREC: certifica la capacidad para operar; no autoriza a emitir, no caduca, sustituye al diploma de operador",
  [El certificado de examen armonizado de radioaficionado (HAREC), que sustituye al antiguo diploma de operador:],
  ([Lo hay de diversas clases.], [Lleva implícita la autorización para el uso del espectro radioeléctrico.], [Certifica la capacidad de su titular para operar estaciones radioeléctricas del Servicio de Aficionados.], [Habilita para hacer uso común del espectro radioeléctrico.],),
  sol: [El HAREC se expide a quien supera las dos partes de la prueba de capacitación (art. 10.3 de la Orden IET/1311/2013) y certifica su capacidad para operar estaciones del Servicio de Aficionados. Por sí solo no autoriza nada: solo habilita para solicitar la autorización de radioaficionado, previo pago de la tasa. Por eso b es falsa, y d también: el uso del espectro por radioaficionados es un uso especial (art. 2), que exige la autorización, no un uso común. Tampoco hay clases (a): la prueba es única y el certificado también. El antiguo diploma de operador es la figura que el HAREC sustituyó. #vease[(Véase tema R7 y tema R8, sección «Uso de la estación y otras cuestiones».)]])
#pq(6, 2, 25, "d", "R8.82", "HAREC: permite obtener la autorización en otro país que aplique la T/R 61-02 (traslado de residencia)",
  [El certificado HAREC permite a su titular:],
  ([duplicar la potencia autorizada], [emitir sin autorización en cualquier país], [quedar exento del pago de tasas], [obtener autorización de radioaficionado en los países que aplican la Recomendación T/R 61-02],),
  sol: [El HAREC no autoriza a emitir por sí solo: acredita conocimientos. Con él, cualquier país que aplique la Recomendación reconoce la capacitación y puede expedir su propia autorización sin repetir examen.])
#pq(6, 2, 26, "c", "R8.25", "Equipos de construcción propia: sin autorización previa, bajo la responsabilidad del titular (régimen sancionador si interfieren)",
  [Los equipos de radioaficionado de construcción propia:],
  ([están prohibidos], [deben ser revisados anualmente por la Jefatura Provincial], [pueden utilizarse sin autorización previa de la Administración], [requieren homologación individual previa],),
  sol: [Los equipos de construcción propia pueden usarse sin autorización previa: la experimentación es la esencia del servicio (art. 5 del Reglamento).])
#pq(6, 2, 27, "c", "F-R8.4", "Soportes: a la obra civil o con repartidores de carga; nunca a pararrayos ni a conducciones eléctricas",
  [Según el Reglamento de antenas de aficionado (Real Decreto 2623/1986), los soportes de las antenas:],
  ([pueden fijarse a los anclajes del pararrayos del edificio, para aprovechar su toma de tierra], [pueden fijarse a los soportes de las conducciones aéreas de energía eléctrica, para reducir el número de anclajes], [se fijan a la obra civil, directamente en puntos aptos o mediante elementos repartidores de la carga debidamente dimensionados], [deben fijarse siempre mediante elementos repartidores de la carga, nunca directamente a la obra civil],),
  sol: [El artículo 17 prohíbe fijar los soportes de las antenas a soportes o anclajes de pararrayos y de conducciones aéreas de energía eléctrica, por tentador que parezca aprovecharlos (a y b). Los soportes se fijan directamente a la obra civil en puntos aptos para tolerar los esfuerzos, o bien mediante elementos repartidores de la carga debidamente dimensionados: son dos vías igual de válidas, por lo que no hay que usar siempre repartidores (d). #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[El artículo 17 del RD 2623/1986 prohíbe fijar los soportes de las antenas a soportes o anclajes de pararrayos y a los de conducciones aéreas de energía eléctrica. Se fijan directamente a la obra civil, en puntos aptos para tolerar los esfuerzos, o mediante elementos repartidores de la carga debidamente dimensionados. En todo caso, ni soportes ni anclajes pueden deteriorar la resistencia mecánica de los elementos constructivos ni originar vibraciones perturbadoras en los locales habitables.]])
#pq(6, 2, 28, "d", "R9.31", "Los inspectores tienen la consideración de autoridad pública",
  [El personal de la inspección de telecomunicaciones, en el ejercicio de sus funciones, tiene la consideración de:],
  ([técnico contratado por el titular], [perito designado por las partes], [representante de la asociación de radioaficionados], [autoridad pública],),
  sol: [La Ley 11/2022 les da la consideración de autoridad pública: es lo que da fuerza a sus actas y lo que convierte en infracción la negativa u obstrucción a su labor. No actúa como perito de parte ni en representación de nadie: ejerce una potestad pública.])
#pq(6, 2, 29, "c", "R9.14", "Obligación de permitir la inspección; solo el domicilio protegido exige consentimiento o autorización judicial",
  [Ante una actuación de la inspección de telecomunicaciones, el titular de una estación de aficionado está obligado a:],
  ([exigir una orden judicial en todos los casos], [negar el acceso si la estación está en un domicilio particular], [permitir el acceso del personal inspector y facilitar la comprobación de la estación], [desmontar previamente los equipos objeto de inspección],),
  sol: [La negativa o la obstrucción a la inspección constituye por sí misma infracción grave. La autorización de radioaficionado lleva aparejada la sujeción a esa comprobación.])
#pq(6, 2, 30, "c", "R9.20", "Interferencias comprobadas por la inspección: cese de las emisiones hasta corregir la causa",
  [Si la inspección comprueba que una estación de aficionado causa interferencias perjudiciales a otros servicios, puede:],
  ([obligar al titular a cambiar de domicilio], [retirar el distintivo de llamada con carácter definitivo y automático], [ordenar el cese de las emisiones hasta que se corrija la causa], [imponer únicamente una advertencia verbal sin más consecuencias],),
  sol: [La prioridad es que la interferencia se acabe, y para eso basta con detener las emisiones mientras se corrige el problema. La retirada definitiva del distintivo sería una consecuencia del expediente sancionador, no una medida automática.])
#fin-prueba()
#soluciones-simulacro(6)

// ======================================================================
#simulacro(7)
#prueba(7, 1)
#pq(7, 1, 1, "c", "T1.15", "Velocidad de propagación: c = 300.000 km/s, constante y sin depender de la frecuencia",
  [La velocidad de propagación de las ondas electromagnéticas en el vacío es de:],
  ([30.000 km/s], [340 m/s], [300.000 km/s], [3.000.000 km/s],),
  sol: [$c = 3 times 10^8$ m/s = 300.000 km/s, la velocidad de la luz (que es también una onda electromagnética).])
#pq(7, 1, 2, "b", "T1.27", "SSB (J3E): una sola banda lateral, sin portadora",
  [En una emisión de banda lateral única (SSB):],
  ([se transmiten las dos bandas laterales sin portadora], [se transmite una sola banda lateral sin portadora], [se transmite solo la portadora], [se transmite la portadora con las dos bandas laterales],),
  sol: [En SSB se suprime la portadora y una de las dos bandas laterales: toda la potencia se concentra en la banda lateral restante, que es la que lleva la información.])
#pq(7, 1, 3, "a", "F-T1.18", "FM: amplitud constante; varía la frecuencia instantánea",
  [La forma de onda de una portadora modulada en frecuencia se caracteriza porque:],
  ([su amplitud es constante y lo que varía es el espaciado de los ciclos (la frecuencia instantánea)], [su amplitud es la suma de la portadora y de la señal moduladora], [su envolvente reproduce la señal moduladora], [aparecen y desaparecen trenes de portadora al ritmo del mensaje],),
  sol: [En FM la información va en la frecuencia instantánea: los ciclos se juntan y se separan al ritmo de la moduladora, pero la amplitud no cambia y la envolvente es una línea recta. Una envolvente que copia la moduladora es la de la AM. Los trenes de portadora que aparecen y desaparecen son telegrafía (CW). Y sumar moduladora y portadora solo superpone ambas señales, sin modulación alguna. _(Véase tema T1, sección «Señales moduladas».)_])
#pq(7, 1, 4, "c", "F-T1.27", "Bits por símbolo (log₂ M) y velocidad binaria = baudios × bits por símbolo",
  [Una modulación 4PSK transporta 2 bits por símbolo. Si la velocidad de símbolo es de 1200 baudios, la velocidad binaria es de:],
  ([4800 bit/s], [1200 bit/s], [2400 bit/s], [600 bit/s],),
  sol: [El baudio es un símbolo por segundo. La velocidad binaria es la de símbolo por los bits de cada símbolo: 1200 × 2 = 2400 bit/s. Los 1200 bit/s confunden baudios con bit/s, que solo coinciden si cada símbolo lleva 1 bit. Los 600 bit/s salen de dividir en lugar de multiplicar. Los 4800 bit/s multiplican por el número de estados ($M = 4$) en lugar de por los bits por símbolo ($log_2 4 = 2$). _(Véase tema T1, sección «Señales moduladas».)_
#_apc1-noest[Baudio: unidad de velocidad de símbolo, un símbolo por segundo. La velocidad binaria (bit/s) es la velocidad de símbolo (baudios) por los bits de cada símbolo, $log_2 M$. Solo coinciden si cada símbolo lleva 1 bit (2PSK, 2FSK). Ejemplos: 4PSK (2 bits por símbolo) a 1200 baudios da 2400 bit/s; 16-QAM (4 bits por símbolo) a 1200 baudios da 4800 bit/s. La anchura de banda depende de los baudios, no de los bit/s.]])
#pq(7, 1, 5, "a", "T2.14", "Unidad de autoinducción: el henrio",
  [La unidad de medida de la autoinducción de una bobina es:],
  ([el henrio], [el ohmio], [el faradio], [el weber],),
  sol: [La autoinducción se mide en henrios (H). El weber es la unidad del flujo magnético.])
#pq(7, 1, 6, "d", "F-T2.5", "Desfase en reactancias puras: en la bobina la tensión adelanta 90° (en el condensador, la corriente)",
  [En una bobina ideal recorrida por una corriente alterna sinusoidal, la tensión entre sus terminales:],
  ([está en fase con la corriente], [retrasa 90° respecto a la corriente], [está en oposición de fase (180° ) con la corriente], [adelanta 90° a la corriente],),
  sol: [Regla E-L-I: en la bobina (L) la tensión (E) va antes que la corriente (I), es decir, la tensión adelanta 90° a la corriente. Como $v = L (dif i)/(dif t)$, la tensión es máxima cuando la corriente cambia más deprisa, un cuarto de ciclo antes de que la corriente llegue a su máximo. La opción b describe el condensador (I-C-E: ahí es la corriente la que adelanta); la a solo se da en una resistencia pura; la c (180°) no corresponde a ninguna reactancia pura. _(Véase tema T2, sección «Bobinas», y capítulo «Cómo funciona una radio: de los campos a la voz», sección 2 (tabla de reactancias de bobina y condensador).)_])
#pq(7, 1, 7, "b", "", "Tensión de conducción en directa de un diodo de silicio: 0,6–0,7 V",
  [Un diodo de silicio polarizado en directa empieza a conducir de forma apreciable cuando la tensión entre sus terminales alcanza aproximadamente:],
  ([0,06 V], [0,6–0,7 V], [1,8–3 V], [6 V],),
  sol: [En el silicio hace falta vencer la barrera de la unión PN, unos 0,6–0,7 V; por debajo apenas pasa corriente y por encima crece de forma exponencial. Entre 1,8 V y 3 V es la caída de un LED, no la de un diodo de silicio.])
#pq(7, 1, 8, "c", "T2.22", "Diodo zéner: estabiliza tensión trabajando en inversa, en la zona de ruptura",
  [El diodo zéner se utiliza principalmente para:],
  ([sintonizar un circuito resonante], [amplificar señales débiles], [estabilizar una tensión], [emitir luz],),
  sol: [En inversa, el zéner fija una tensión prácticamente constante: referencia y estabilización en fuentes de alimentación.])
#pq(7, 1, 9, "a", "C-T3.10", "Resistencias en serie: la corriente es la misma en todas y la caída de tensión es proporcional a cada R",
  [En varias resistencias de diferente valor, conectadas en serie, la caída de tensión en cada una de
ellas, cuando circula una corriente, es:],
  ([Directamente proporcional al valor de la resistencia], [No hay caída de tensión], [Inversamente proporcional al valor de la resistencia], [Igual en todas],),
  sol: [
    Por todas circula la misma corriente $I$, así que, por la ley de Ohm, la caída en cada una es
    $V = I R$: directamente proporcional a su resistencia. Con $I = 2$ mA, una resistencia de 1 kΩ
    cae 2 V y una de 4,7 kΩ cae 9,4 V. La caída solo sería igual en todas si las resistencias fueran
    iguales, y nunca es nula mientras circula corriente. Este reparto es el principio del divisor de
    tensión. #vease[(Véase tema T1, sección «Unidades y leyes fundamentales».)]
  ])
#pq(7, 1, 10, "b", "T3.52", "Condición de resonancia: XL = XC, las reactancias se cancelan y el circuito es puramente resistivo",
  [A la frecuencia de resonancia, un circuito $L C$ se comporta frente a la corriente como:],
  ([puramente inductivo], [puramente resistivo], [un circuito abierto a cualquier frecuencia], [puramente capacitivo],),
  sol: [En resonancia las reactancias inductiva y capacitiva se igualan y se cancelan, y solo queda la resistencia: tensión y corriente vuelven a estar en fase. Es la propiedad que se aprovecha para adaptar y para seleccionar.])
#pq(7, 1, 11, "d", "C-T3.7", "Neutralización: anula la realimentación parásita para que el amplificador no oscile",
  [La neutralización se utiliza en:],
  ([Los relés para neutralizarlos], [En los circuitos electrónicos para evitar el elemento neutro], [Las baterías para evitar su polarización], [Los amplificadores para evitar que oscilen],),
  sol: [
    En un amplificador de radiofrecuencia una parte de la salida vuelve a la entrada a través de las
    capacidades parásitas del propio dispositivo (rejilla-placa en un tríodo, base-colector en un
    transistor). Si esa realimentación es positiva y suficiente, el amplificador oscila por su
    cuenta. La neutralización aplica a la entrada una muestra de la salida en oposición de fase que
    cancela la realimentación parásita: así se evita que el amplificador oscile. No tiene relación
    con los relés, con la «polarización» de las baterías ni con ningún «elemento neutro».
    #vease[(Véase tema T2, sección «Válvulas termoiónicas».)]
    #no-esta[Neutralizar un amplificador es anular su realimentación parásita. Se toma una pequeña parte de
    la señal de salida, se invierte su fase 180° y se aplica a la entrada a través de un pequeño
    condensador (condensador de neutralización) de valor parecido a la capacidad parásita
    rejilla-placa o base-colector: las dos corrientes se cancelan y el amplificador deja de oscilar.
    Los tetrodos y pentodos, con su rejilla pantalla, apenas la necesitan.]
  ])
#pq(7, 1, 12, "a", "F-T3.17", "Limitador delante del discriminador: recorta las variaciones de amplitud (ruido)",
  [En un receptor de FM, el limitador que precede al discriminador sirve para:],
  ([recortar las variaciones de amplitud, que son ruido y no información], [amplificar el audio hasta el nivel que necesita el altavoz], [reducir la desviación de frecuencia para estrechar la banda], [reinsertar la portadora suprimida por el transmisor],),
  sol: [En FM el mensaje va en la frecuencia y la amplitud es constante. El ruido eléctrico (chispas, motores, tormentas) y muchas interferencias alteran sobre todo la amplitud. El limitador recorta todo lo que sobresale y deja una señal de amplitud uniforme, de modo que el discriminador solo ve variaciones de frecuencia, que sí son información. No amplifica el audio (lo hace el amplificador de audio tras el detector), no reinserta la portadora (tarea del BFO en SSB y CW) y no modifica la desviación de frecuencia, que es el propio mensaje. _(Véase tema T3, sección «Clases de amplificación y detectores».)_])
#pq(7, 1, 13, "c", "F-T3.18", "VCO: su frecuencia varía con una tensión de control, normalmente mediante un varicap",
  [Un oscilador controlado por tensión (VCO) es un oscilador cuya:],
  ([frecuencia queda fijada por un cristal de cuarzo, sin posibilidad de ajuste], [amplitud de salida cambia al variar la tensión de la red eléctrica], [frecuencia de salida cambia al variar una tensión continua de control], [tensión de alimentación se estabiliza mediante un diodo zéner],),
  sol: [VCO son las siglas inglesas de _voltage controlled oscillator_. Una tensión continua aplicada a su entrada de control desplaza la frecuencia de oscilación, normalmente mediante un varicap en el circuito resonante. Es la pieza básica del PLL y del modulador de FM. Lo que se controla es la frecuencia, no la amplitud. Un cristal fija la frecuencia con mucha precisión y deja muy poco margen de ajuste. Y estabilizar la alimentación con un zéner es buena práctica, pero no convierte a un oscilador en controlado por tensión. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_])
#pq(7, 1, 14, "d", "T4.34", "Detector de producto con BFO: imprescindible en SSB y CW (no en AM ni FM)",
  [En un receptor, el oscilador de frecuencia de batido (BFO) resulta imprescindible para recibir emisiones de:],
  ([modulación de frecuencia], [amplitud modulada con portadora], [televisión de aficionado], [telegrafía y banda lateral única],),
  sol: [Ni la telegrafía ni la banda lateral única llevan portadora, así que el receptor tiene que reponerla localmente para que el detector de producto entregue audio. En AM con portadora y en FM el BFO no hace falta.])
#pq(7, 1, 15, "b", "", "Selectividad de canal adyacente: la fijan los faldones del filtro de FI (problema lineal)",
  [La selectividad de canal adyacente de un receptor depende principalmente de:],
  ([la linealidad del primer mezclador], [la forma y los faldones del filtro de frecuencia intermedia], [la figura de ruido de la etapa de RF], [la estabilidad del oscilador de batido],),
  sol: [Es lo que el receptor rechaza una emisión en el canal contiguo, y lo deciden los faldones del filtro de FI: cuanto más abruptos, más se atenúa al vecino. Es un problema lineal; la linealidad del primer mezclador decide la intermodulación y la modulación cruzada, no la selectividad.])
#pq(7, 1, 16, "b", "T4.23", "Noise blanker (NB): suprime el ruido impulsivo",
  [El mando «NB» (_noise blanker_) de un receptor se emplea para:],
  ([estrechar el filtro de audio], [suprimir los ruidos producidos por impulsos], [aumentar la sensibilidad en las bandas altas], [compensar la deriva del oscilador],),
  sol: [Está pensado para el ruido impulsivo —encendido de un motor, una valla eléctrica, ciertos electrodomésticos—, que llega como pulsos muy cortos y de gran amplitud. El circuito los detecta y silencia el receptor durante ese instante.])
#pq(7, 1, 17, "d", "T5.21", "Orden de bloques del emisor: modulador → amplificación y traslación → final → red de acoplo",
  [El orden correcto de los bloques funcionales de un equipo emisor es:],
  ([amplificador final, red de acoplo, modulador y cadena de amplificación], [cadena de amplificación, modulador, red de acoplo y amplificador final], [red de acoplo, amplificador final, modulador y cadena de amplificación], [modulador, cadena de amplificación y traslación de frecuencia, amplificador final y red de acoplo],),
  sol: [Se sigue el camino de la señal: primero se modula a bajo nivel, después se amplifica y se traslada a la frecuencia de trabajo, luego se sube la potencia y por último se adapta a la antena. La red de acoplo es siempre lo último antes de la línea.])
#pq(7, 1, 18, "c", "T5.25", "Etapa separadora: aísla el oscilador de las variaciones de carga",
  [La etapa separadora que se intercala entre el oscilador y el amplificador de un transmisor sirve para:],
  ([modular la señal en amplitud], [elevar la frecuencia del oscilador], [aislar el oscilador de las variaciones de carga de las etapas siguientes], [rectificar la señal del oscilador],),
  sol: [Un oscilador es sensible a lo que tenga colgado: si la carga varía, su frecuencia se mueve. La separadora lo desacopla y le deja ver siempre la misma carga, con lo que la emisión no deriva al variar la potencia.])
#pq(7, 1, 19, "a", "T5.6", "Armónicos: múltiplos enteros de la fundamental",
  [Los armónicos generados por un transmisor son señales cuya frecuencia es:],
  ([un múltiplo entero de la frecuencia fundamental], [independiente de la frecuencia fundamental], [la mitad de la frecuencia fundamental], [siempre inferior a la frecuencia fundamental],),
  sol: [Los armónicos son múltiplos enteros de la fundamental: un transmisor de 7 MHz mal filtrado puede aparecer en 14 y 21 MHz.])
#pq(7, 1, 20, "c", "", "Antena más corta que la resonante: reactancia capacitiva (se compensa con bobina); más larga: inductiva",
  [Una antena algo más corta de lo que pide su frecuencia de trabajo presenta en su punto de alimentación, además de la parte resistiva, una reactancia:],
  ([inductiva, que se compensa con una bobina en serie], [nula, porque la reactancia solo aparece en las antenas más largas], [capacitiva, que se compensa con una bobina en serie], [capacitiva, que se compensa con un condensador en serie],),
  sol: [Cerca de su resonancia la antena se comporta como un circuito RLC en serie: si es demasiado corta manda la reactancia del condensador y es capacitiva; si es demasiado larga, inductiva. La reactancia capacitiva se anula con una bobina en serie (bobina de carga), que alarga eléctricamente la antena. Un condensador en serie la acortaría todavía más.])
#pq(7, 1, 21, "d", "C-T6.1", "Dipolo en V invertida: ≈ 50 Ω, casi omnidireccional y un solo mástil",
  [¿Qué ventajas presenta la antena dipolo en V invertida?],
  ([Un valor de impedancia próximo a 75 Ω y polarización circular.], [Un valor de impedancia próximo a 75 Ω y un diagrama de radiación muy directivo.], [Un valor de impedancia constante y elevada ganancia.], [Un valor de impedancia próximo a 50 Ω y un diagrama de radiación prácticamente omnidireccional.],),
  sol: [
    En la V invertida el centro (el punto de alimentación) va arriba, en el mástil, y los brazos
    caen inclinados hacia el suelo. Al inclinarlos, la impedancia baja desde los ∼73 Ω del dipolo
    horizontal hasta unos 50 Ω (con un ángulo entre brazos de 90 a 120 grados), que es justo la del
    coaxial de los equipos. Además, los brazos inclinados radian también algo de campo vertical y el
    diagrama se vuelve casi omnidireccional en el plano horizontal. No hay polarización circular
    (a), ni un diagrama muy directivo (b: eso es una Yagi), ni ganancia elevada ni impedancia
    «constante» (c): es un dipolo, de unos 2,15 dBi. #vease[(Véase tema T6, sección «El dipolo y
    otras antenas».)]
    #no-esta[Dipolo en V invertida: dipolo de media onda con el centro elevado, sujeto a un solo mástil, y
    los extremos caídos, formando entre los brazos un ángulo de unos 90 a 120 grados. Inclinar los
    brazos hacia el suelo reduce la impedancia del punto de alimentación, de ∼73 Ω a unos 50 Ω, y
    redondea el diagrama: aparece una componente vertical y se atenúan los nulos que el dipolo
    horizontal tiene en la dirección de sus extremos, de modo que se acerca a un diagrama
    omnidireccional en el plano horizontal.]
  ])
#pq(7, 1, 22, "a", "F-T6.6", "Potencia efectiva radiada: p.r.e. = P · G, descontando las pérdidas del cable (en dB)",
  [Un transmisor de 10 W alimenta, mediante un cable que pierde 3 dB, una antena de 6 dBd de ganancia. La potencia efectiva radiada (p.r.e.) es aproximadamente de:],
  ([20 W], [80 W], [40 W], [10 W],),
  sol: [Se suman los decibelios: +6 − 3 = +3 dB netos, que equivale a multiplicar la potencia por 2. La p.r.e. (p.r.a. en la Orden IET/1311/2013, anexo I) es 10 W × 2 = 20 W. Los 40 W aparecen si se olvida el cable (+6 dB ≈ ×4); los 80 W, si se suman ganancia y pérdida (+9 dB ≈ ×8); y los 10 W, si se cree que el cable anula toda la ganancia. #vease[(Véase tema T6, sección «El dipolo y otras antenas» (y tema T1, sección «Potencia, decibelios y DSP»).)]])
#pq(7, 1, 23, "d", "T7.4", "La onda de superficie sigue la curvatura terrestre",
  [La propagación por onda de superficie se caracteriza porque la onda:],
  ([se refleja en la capa F de la ionosfera], [rebota en la superficie lunar], [solo existe con visión directa entre antenas], [se propaga siguiendo la curvatura terrestre],),
  sol: [La onda de superficie viaja pegada al suelo siguiendo la curvatura terrestre, superando el horizonte visual.])
#pq(7, 1, 24, "b", "", "Zona de silencio: entre el final de la onda de superficie y la primera onda reflejada",
  [En HF, la zona de silencio es la región:],
  ([donde la capa D absorbe por completo la señal durante el día], [situada entre el punto donde se agota la onda de superficie y el punto donde cae la primera onda reflejada en la ionosfera], [donde la onda directa y la reflejada llegan en oposición y se anulan], [situada más allá de la distancia máxima de un salto],),
  sol: [En HF la onda de superficie se agota en pocas decenas de kilómetros, y la onda reflejada no cae a tierra hasta la distancia de salto: entre las dos no llega señal. Por eso una estación a 100 km puede no oírte mientras otra a 2000 km te oye bien. Si la frecuencia baja por debajo de la frecuencia crítica, hasta el rayo vertical vuelve y la zona de silencio desaparece.])
#pq(7, 1, 25, "d", "C-T7.2", "Rebote lunar (EME): VHF y superiores, sobre todo 144 MHz (ondas métricas)",
  [Las reflexiones lunares se hacen principalmente en:],
  ([ondas decamétricas], [ondas milimétricas], [ondas decimétricas], [ondas métricas],),
  sol: [
    El rebote lunar (EME) necesita una frecuencia que atraviese la ionosfera, lo que deja fuera en
    la práctica a las decamétricas (HF), y antenas de ganancia elevada pero manejables. La banda de
    EME por excelencia es la de 144 MHz (2 m): ondas métricas. También se usan 432 MHz
    (decimétricas) y las microondas, pero con mucha menos actividad. Las milimétricas (30–300 GHz)
    casi no se emplean: la atmósfera las atenúa mucho y el apuntado es muy crítico. #vease[(Véase
    tema T7, sección «Fenómenos de propagación».)]
    #no-esta[El rebote lunar (EME, #emph[Earth-Moon-Earth]) usa la Luna como reflector pasivo: 770 000 km de
    ida y vuelta y del orden de 250 dB de pérdidas a 144 MHz. La señal debe cruzar la ionosfera, así
    que hacen falta VHF o frecuencias superiores. La banda clásica y más concurrida es 144 MHz (2 m,
    ondas métricas); le siguen 432 y 1296 MHz y algunas microondas.]
  ])
#pq(7, 1, 26, "c", "T8.5", "Medida de potencia de RF con vatímetro",
  [Para medir la potencia de una señal de radiofrecuencia se emplea:],
  ([un óhmetro], [un galvanómetro], [un vatímetro], [un voltímetro de continua],),
  sol: [La potencia se mide con un vatímetro; en RF, direccional (separa directa y reflejada).])
#pq(7, 1, 27, "b", "", "Cálculo de la ROE a partir de la potencia directa y la reflejada; potencia entregada = directa − reflejada",
  [Un vatímetro direccional marca 100 W de potencia directa y 25 W de reflejada. La ROE y la potencia que llega a la antena son, respectivamente:],
  ([3 y 125 W], [3 y 75 W], [1,5 y 75 W], [4 y 125 W],),
  sol: [$rho = sqrt(P_r / P_d) = sqrt(25 / 100) = 0,5$ y $"ROE" = (1 + 0,5) / (1 - 0,5) = 3$. La antena recibe la directa menos la reflejada, 100 − 25 = 75 W; sumar las dos (125 W) es el error típico.])
#pq(7, 1, 28, "a", "C-T9.4", "La emisión de armónicos y espurias implica riesgo de interferencias en cualquier banda",
  [La emisión de señales armónicas y espurias:],
  ([Implica la posible producción de interferencias.], [Disminuye la posible producción de interferencias.], [Solo hay que tenerla en cuenta en las bandas de VHF y superiores.], [Es necesaria en las bandas de HF.],),
  sol: [
    Los armónicos (múltiplos enteros de la fundamental) y las emisiones espurias son energía radiada
    fuera de la anchura de banda necesaria, que no aporta nada a la comunicación y puede caer sobre
    otro servicio. Por ejemplo, el tercer armónico de 29,5 MHz es 88,5 MHz, en plena banda de
    radiodifusión FM. Por eso implican riesgo de interferencia en cualquier banda, HF incluida: no
    son necesarias ni deseables en ninguna y se atenúan siempre con un filtro paso bajo a la salida
    del transmisor. La Orden IET/1311/2013 limita su nivel (anexo I, punto 4.1). #vease[(Véase tema
    T9, sección «Causas de interferencia».)]
  ])
#pq(7, 1, 29, "c", "T10.1", "Interruptor general de la estación",
  [Como medida de protección y seguridad, toda estación radioeléctrica debe disponer de:],
  ([un sistema de alimentación ininterrumpida], [un extintor de espuma junto a cada equipo], [un interruptor general de suministro eléctrico], [un armario ignífugo para los transceptores],),
  sol: [El interruptor general permite cortar de un solo gesto el suministro de toda la estación ante cualquier emergencia.])
#pq(7, 1, 30, "a", "C-T10.5", "Diferencial: actúa cuando la corriente de ida y la de vuelta difieren (derivación a tierra)",
  [Un interruptor diferencial actúa cuando en el circuito que protege:],
  ([Se produce una derivación a tierra.], [Se produce un cortocircuito.], [Se produce una sobremodulación.], [Se aumenta la potencia.],),
  sol: [
    El diferencial compara la corriente que entra por la fase con la que vuelve por el neutro. Si
    hay una derivación a tierra (por un aislamiento defectuoso o a través de una persona), parte de
    la corriente vuelve por tierra y no por el neutro: ida y retorno dejan de ser iguales y el
    aparato corta. En un cortocircuito entre fase y neutro, en cambio, toda la corriente vuelve por
    el neutro, ida y retorno siguen siendo iguales y el diferencial no lo detecta: de eso se encarga
    el magnetotérmico. La sobremodulación es un fenómeno de radiofrecuencia y un aumento de potencia
    no desequilibra ida y retorno. #vease[(Véase tema T10, sección «Fusibles y protecciones».)]
  ])
#fin-prueba()
#prueba(7, 2)
#pq(7, 2, 1, "b", "R1.21", "X X-ray, Y Yankee, Z Zulu (no «Zeta»); grafías Echo y Alfa (no Eco, Alpha)",
  [El distintivo de llamada `EA4XYZ` se deletrea:],
  ([España América Four Equis Yolanda Zaragoza], [Echo Alfa Four X-ray Yankee Zulu], [Echo Alfa Four X-ray Yankee Zeta], [Echo Alpha Four Xilófono Yankee Zeta],),
  sol: [Las letras, con las palabras oficiales del alfabeto internacional —_Echo_, con hache, no «Eco»; _Alfa_, no «Alpha»— y la cifra con su nombre inglés, _Four_, como en todo el deletreo internacional. La opción c acierta hasta el final, pero «Zeta» no es palabra del alfabeto (la Z es _Zulu_); la d mezcla «Alpha», «Xilófono» y «Zeta», y la a usa nombres de letras y ciudades en castellano.])
#pq(7, 2, 2, "c", "C-R2.2", "QRL: estoy ocupado / ¿está ocupada la frecuencia?",
  [¿Qué abreviatura indica que el operador está ocupado?],
  ([QTI], [QRF], [QRL], [QSJ],),
  sol: [QRL significa «estoy ocupado; no interfiera» y, en forma de pregunta (QRL?), «¿está usted ocupado?» o «¿está ocupada la frecuencia?». Los demás grupos no tienen relación: QRF es «¿regresa usted a…?», QTI se refiere a la derrota (rumbo) verdadera y QSJ a la tasa por palabra en el tráfico de telegramas. #vease[(Véase tema R2, tabla «Grupos del código Q más frecuentes» (QRL como «frecuencia ocupada»).)]

    #no-esta[El cuaderno da QRL como «la frecuencia está ocupada», que es su uso habitual antes de llamar: se pregunta «QRL?» y, si alguien contesta, se espera. La definición internacional es más amplia: QRL? es «¿está usted ocupado?» y QRL es «estoy ocupado; ruego no interferir». El examen lo pregunta con cualquiera de los dos matices, y la clave es siempre QRL. Mnemotecnia: QRL = «línea ocupada».]])
#pq(7, 2, 3, "c", "R2.21", "QSN ¿me ha oído / ha oído a… en… kHz?",
  [El grupo `QSN` se utiliza para preguntar:],
  ([cuántos mensajes quedan pendientes], [a qué distancia se encuentra la estación], [si se ha escuchado a una estación en una frecuencia determinada], [cuál es la hora exacta],),
  sol: [«¿Me ha oído usted, o ha oído a …, en … kHz?». Sirve para comprobar si una emisión llega a un punto concreto del que no se recibe respuesta directa.])
#pq(7, 2, 4, "c", "R3.3", "RPT repita y AGN de nuevo",
  [La abreviatura `RPT` significa:],
  ([reporte recibido], [recepción perfecta], [repita], [repetidor activo],),
  sol: [`RPT` (_repeat_): repita.])
#pq(7, 2, 5, "a", "R3.23", "SSB banda lateral única",
  [La abreviatura `SSB` corresponde a:],
  ([la banda lateral única], [un sistema de sintonía automática], [una emisión de doble banda lateral], [una señal de socorro],),
  sol: [De _single side band_. Es el modo de fonía por excelencia en HF, porque suprime la portadora y una banda lateral y concentra toda la potencia en la información.])
#pq(7, 2, 6, "a", "R3.30", "NIL nada, sin novedad",
  [La abreviatura `NIL` significa:],
  ([nada, sin novedad], [no identificado], [nueva llamada], [nivel de señal],),
  sol: [Del latín _nihil_ a través del inglés: nada que transmitir, sin novedad. Se emplea para cerrar un tráfico de mensajes cuando no queda ninguno.])
#pq(7, 2, 7, "c", "R3.31", "CFM confirmo",
  [La abreviatura `CFM` significa:],
  ([cambio de frecuencia], [conforme al manual], [confirmo], [cierro comunicación],),
  sol: [Contracción de _confirm_: doy por buena la información recibida. Es lo que se transmite al aceptar un informe de señal o un dato del corresponsal.])
#pq(7, 2, 8, "d", "R4.1", "Socorro en radiotelefonía: MAYDAY",
  [La señal de socorro en radiotelefonía es:],
  ([Alerta], [Sécurité], [Pan Pan], [Mayday],),
  sol: [#_r4-sc("Mayday") (del francés _m’aider_): socorro en fonía, prioridad absoluta.])
#pq(7, 2, 9, "d", "C-R4.3", "Alerta de socorro GMDSS por DSC en MF: 2187,5 kHz (voz: 2182 kHz)",
  [En el sistema GMDSS, la alerta de socorro inicial en MF/HF se realiza mediante Llamada Selectiva Digital (DSC). ¿En qué frecuencia se transmite esta alerta en banda MF?],
  ([156,525 MHz], [1414 kHz], [2182 kHz], [2187,5 kHz],),
  sol: [En MF, la alerta de socorro del GMDSS por DSC se transmite en 2187,5 kHz. La frecuencia de 2182 kHz es la tradicional de socorro en radiotelefonía (voz), no la de la alerta digital. 156,525 MHz es el canal 70 de VHF, que también es de DSC pero en otra banda (VHF, no MF). 1414 kHz no es frecuencia de socorro. El banco no traía clave para esta pregunta; la respuesta se ha fijado con la norma.

    #no-esta[El GMDSS (Sistema Mundial de Socorro y Seguridad Marítimos) automatiza las alertas con la llamada selectiva digital (DSC): un mensaje digital breve que identifica al buque y su posición. Frecuencias de alerta DSC: MF, 2187,5 kHz; HF, 4207,5, 6312, 8414,5, 12577 y 16804,5 kHz; VHF, canal 70, 156,525 MHz. La voz va aparte: 2182 kHz en MF y canal 16 (156,8 MHz) en VHF. Truco: la de MF es la de voz (2182) más 5,5 kHz.]])
#pq(7, 2, 10, "a", "R5.31", "Prefijos de España: series EA–EH (y AM–AO); habituales EA, EB y EC",
  [Los prefijos de los distintivos de llamada correspondientes a España son, entre otros:],
  ([EA, EB y EC], [AE, BE y CE], [EI, EJ y EK], [AA, BB y CC],),
  sol: [EA es el prefijo clásico, y EB y EC se han ido incorporando al agotarse las series. EI y EJ son de Irlanda y EK, de Armenia. Del resto de la serie española: ED, EE y EF sirven para usos temporales ordinarios (ED es además el prefijo permanente de las desatendidas) y EG y EH se reservan a eventos especialmente relevantes (art. 27).])
#pq(7, 2, 11, "c", "R5.13", "Sufijo: hasta tres letras, por orden alfabético y turno riguroso de expedición",
  [El sufijo del distintivo de llamada de una autorización de radioaficionado estará constituido por:],
  ([las iniciales del titular], [cifras y letras alternadas], [hasta tres letras, asignadas ordenadas alfabéticamente por turno riguroso de expedición], [una combinación libre elegida por el titular],),
  sol: [El sufijo son hasta tres letras, asignadas por orden alfabético según turno riguroso de expedición.])
#pq(7, 2, 12, "a", "R5.48", "Para qué se pide un distintivo temporal: concursos, experimentos, ensayos o conmemoraciones",
  [Puede solicitarse un distintivo de llamada temporal cuando se desee:],
  ([participar en concursos, experimentos, ensayos o conmemoraciones], [ceder la estación a un tercero], [operar con mayor potencia de la autorizada], [evitar ser identificado],),
  sol: [Los distintivos temporales existen para dar visibilidad a actividades concretas y acotadas en el tiempo. Nunca para operar fuera de lo autorizado ni, mucho menos, para ocultar la identidad.])
#pq(7, 2, 13, "d", "R6.8", "España pertenece a la Región 1 de la UIT",
  [A efectos de atribución de frecuencias, España pertenece a la:],
  ([Región 3 de la UIT], [Zona CEPT independiente de las regiones], [Región 2 de la UIT], [Región 1 de la UIT],),
  sol: [La Región 1 abarca Europa, África, Oriente Medio y el norte de Asia. Es la que determina qué bandas tenemos aquí y cuál de los tres planes de banda de la IARU hay que conocer.])
#pq(7, 2, 14, "b", "F-R6.4", "80 m: segmento de CW 3.500–3.570 kHz",
  [En la banda de 80 m, el plan de bandas HF de la IARU para la Región 1 marca como segmento de telegrafía (CW) el comprendido entre:],
  ([3.600–3.800 kHz], [3.500–3.570 kHz], [3.570–3.600 kHz], [3.700–3.800 kHz],),
  sol: [El plan divide los 80 m en tres bloques por modo: 3.500–3.570 kHz, telegrafía (200 Hz de anchura máxima); 3.570–3.600 kHz, modos de banda estrecha y digimodos; 3.600–3.800 kHz, «todos los modos», es decir, la fonía en SSB (LSB). Las opciones a) y d) caen en el bloque de fonía. La c) es el de los modos digitales estrechos: aunque el plan admite QSO en CW en toda la banda (salvo en segmentos de balizas), el tramo marcado como CW es el de 3.500–3.570 kHz. #no-esta[El plan de bandas HF de la IARU para la Región 1 reparte cada banda por modos. En 80 m: 3.500–3.570 kHz, telegrafía (CW); 3.570–3.600 kHz, modos de banda estrecha y digimodos; 3.600–3.800 kHz, todos los modos, con la fonía SSB en LSB. La telegrafía puede usarse en toda la banda, salvo en los segmentos de balizas, pero el plan marca el primer tramo como el propio de CW.]])
#pq(7, 2, 15, "b", "R7.10", "Definición del servicio de aficionados: instrucción individual, intercomunicación y estudios técnicos, sin lucro",
  [De acuerdo con el Reglamento de Radiocomunicaciones, el servicio de aficionados se define como un servicio de:],
  ([radiodifusión de programas de contenido cultural], [instrucción individual, intercomunicación y estudios técnicos], [comunicaciones comerciales de ámbito local], [enlace entre servicios de emergencia],),
  sol: [Es la definición del Reglamento de Radiocomunicaciones de la UIT (número 1.56): un servicio de _instrucción individual, intercomunicación y estudios técnicos_ efectuado por aficionados debidamente autorizados, sin fines de lucro. Todo lo demás del temario se deduce de ahí.])
#pq(7, 2, 16, "c", "R7.17", "Antenas: garantizar el derecho de terceros a no sufrir daños",
  [Al instalar una antena de estación de aficionado debe tenerse en cuenta que:],
  ([la responsabilidad por daños a terceros corresponde al fabricante], [basta con avisar verbalmente a los vecinos], [debe garantizarse el derecho de terceros a no sufrir daños en su propiedad], [no existe obligación alguna si la instalación está autorizada],),
  sol: [La instalación no puede crear un riesgo para los demás. De ahí la exigencia de seguro de responsabilidad civil para las antenas exteriores y el cuidado en anclajes, soportes y distancias, que es también materia del tema T10.])
#pq(7, 2, 17, "a", "F-R8.62", "Radiobaliza: información solo de su posición y condiciones de funcionamiento",
  [Según el art. 25.f de la Orden IET/1311/2013, salvo casos excepcionales debidamente justificados, la información transmitida por una radiobaliza del Servicio de Aficionados se refiere únicamente a:],
  ([su posición y sus condiciones de funcionamiento], [la previsión meteorológica de su zona], [mensajes y boletines de la asociación titular], [el nombre y la dirección del radioaficionado que la mantiene],),
  sol: [Art. 25.f: salvo casos excepcionales debidamente justificados, la información que transmite una radiobaliza se refiere únicamente a su posición y a sus condiciones de funcionamiento. No lleva previsiones meteorológicas, boletines de la asociación ni datos personales de quien la mantiene. Es una estación automática desatendida cuyo funcionamiento se basa en emitir señales de identificación, y su utilidad para los aficionados es que se la pueda oír para estudiar la propagación (anexo I). #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 25.f de la Orden IET/1311/2013: salvo casos excepcionales debidamente justificados, la información transmitida por una radiobaliza se refiere únicamente a su posición y a sus condiciones de funcionamiento, y su sistema radiante será, como norma general, omnidireccional. Junto con el distintivo a intervalos no superiores a tres minutos (art. 25.e), son las condiciones propias de las radiobalizas.]])
#pq(7, 2, 18, "b", "F-R8.68", "Prohibido codificar para ocultar el significado, salvo el mando de estaciones espaciales",
  [Según el art. 30.2 de la Orden IET/1311/2013, las transmisiones entre estaciones y equipos de aficionado no deberán codificarse para ocultar su significado, excepto:],
  ([las comunicaciones de emergencia o desastre realizadas en nombre de terceros], [las señales de control intercambiadas entre estaciones de mando terrestres y estaciones espaciales del Servicio de Aficionados por Satélite], [las transmisiones de concursos entre estaciones de países distintos], [las comunicaciones entre estaciones de una misma asociación de radioaficionados],),
  sol: [Art. 30.2: las transmisiones entre estaciones y equipos de aficionado no deben codificarse para ocultar su significado; la única excepción son las señales de control intercambiadas entre estaciones de mando terrestres y estaciones espaciales del Servicio de Aficionados por Satélite. Es una excepción estrecha, limitada al mando de esas estaciones espaciales. Ni las emergencias (a), ni los concursos (c), ni las comunicaciones internas de una asociación (d) autorizan a cifrar el contenido. El tráfico en nombre de terceros en casos de emergencia o desastre es otra regla distinta (art. 30.3). #_apc3-ver[(Véase tema R7, introducción (se transmite en lenguaje claro y sin codificar el significado).)]

#_apc3-net[Art. 30.2 de la Orden IET/1311/2013: las transmisiones entre estaciones y equipos de aficionado no deberán codificarse para ocultar su significado. La única excepción son las señales de control intercambiadas entre estaciones de mando terrestres y estaciones espaciales del Servicio de Aficionados por Satélite, que utiliza estaciones espaciales situadas en satélites de la Tierra para los mismos fines que el Servicio de Aficionados.]])
#pq(7, 2, 19, "b", "C-T7.3", "Nomenclatura de bandas: números, símbolos (HF, VHF, SHF…), rangos y ondas (métricas, B.m.…)",
  [La gama de frecuencias comprendida entre 300 y 3000 MHz corresponde a las:],
  ([ondas decamétricas], [ondas decimétricas], [ondas milimétricas], [ondas kilométricas],),
  sol: [
    Es la banda UHF. Con $λ = c slash f$: a 300 MHz, $λ = 1$ m, y a 3000 MHz, $λ = 0,1$ m = 10 cm.
    Longitudes de onda de 10 a 100 cm, decenas de centímetros: ondas decimétricas. Las kilométricas
    son 30–300 kHz (LF), las decamétricas 3–30 MHz (HF) y las milimétricas 30–300 GHz (EHF).
    #vease[(Véase tema T7, sección «Cómo se nombran las bandas».)]
  ])
#pq(7, 2, 20, "d", "C-R8.33", "Licencia CEPT: presentarla a petición de las autoridades del país visitado",
  [Para operar estaciones en el país visitado temporalmente, el radioaficionado está obligado a:],
  ([Pedir indicativo en dicho país.], [Presentar copia de su expediente.], [Solicitar permiso de antenas.], [Presentar la autorización de radioaficionado a petición de las autoridades.],),
  sol: [Es una de las condiciones de uso de la licencia CEPT (art. 14.c de la Orden IET/1311/2013): su titular está obligado a presentarla a petición de las autoridades del país visitado. Para un español, su autorización de radioaficionado tiene la consideración de licencia CEPT (art. 11). Las demás opciones no figuran entre las condiciones del art. 14: en el país visitado no se pide un distintivo nuevo, sino que se usa el propio precedido de la designación de ese país (art. 14.e). No hay que confundirlo con otro deber distinto: respetar la reglamentación local (art. 14.d). #vease[(Véase tema R8, sección «Usos especiales y casos particulares» (obligaciones del titular de una licencia CEPT).)]

    #no-esta[Art. 14 de la Orden IET/1311/2013, condiciones de la licencia CEPT: a) en España, sujeta a la Orden; b) vale para todas las bandas del servicio autorizadas en el país visitado; c) hay que presentarla a petición de las autoridades del país visitado; d) se respeta el Reglamento de Radiocomunicaciones y la normativa local; e) se usa el distintivo nacional precedido de la designación del país visitado; f) fuera de tu país no puedes reclamar protección contra interferencias perjudiciales.]])
#pq(7, 2, 21, "d", "C-R8.44", "Vigencia indefinida: no se renueva; suprimida la comunicación quinquenal",
  [Según la normativa vigente (Orden IET/1311/2013), respecto de la autorización de radioaficionado, indique la alternativa incorrecta:],
  ([Conserva su vigencia mientras su titular no manifieste su renuncia o sea revocada.], [Tendrá carácter personal y no transferible.], [Habilita para el uso de cualquier banda de frecuencias del Servicio de Aficionados con determinadas características técnicas y restricciones geográficas.], [Su titular debe comunicar cada cinco años, de forma fehaciente, su intención de seguir utilizando el espectro radioeléctrico.],),
  sol: [La incorrecta es la d: la obligación de comunicar cada cinco años la intención de seguir usando el espectro quedó suprimida (disposición adicional primera de la Orden IET/1311/2013), así que la autorización no se renueva ni caduca por no hacerlo. Las otras tres son ciertas: conserva su vigencia mientras el titular no renuncie o no sea revocada (art. 5.4); es personal y no transferible (art. 5.4); y habilita para cualquiera de las bandas del servicio con las características técnicas del anexo I, sin perjuicio de las limitaciones de los arts. 16 y 17 (art. 5.3). El enunciado original del banco estaba truncado y sin clave, con una opción obsoleta (el «diploma de operador»); por eso se reformula como pregunta de la incorrecta. #vease[(Véase tema R8, introducción (tabla: «Renovación de la autorización: suprimida») y sección «Autorización y licencia de estación».)]])
#pq(7, 2, 22, "a", "F-R8.31", "Extinción automática de la autorización: fallecimiento del titular o extinción de la asociación titular",
  [La autorización de radioaficionado se extingue automáticamente por:],
  ([el fallecimiento de su titular o la extinción de la asociación de radioaficionados titular de la misma], [el transcurso de cinco años sin comunicar a la SETSI la intención de seguir utilizando el espectro], [el traslado de su titular a un distrito distinto del de su distintivo], [la baja de su titular como socio de una asociación de radioaficionados],),
  sol: [El art. 8.2 fija la extinción automática: el fallecimiento del titular o la extinción de la asociación de radioaficionados titular de la autorización. La comunicación quinquenal de continuidad (b) quedó suprimida, con sus efectos de extinción, por la disposición adicional primera. Mudarse de distrito (c) solo obliga a comunicar el nuevo domicilio (art. 7.3). Y no hace falta ser socio de ninguna asociación (d). La renuncia del titular (art. 5.4) y la revocación (art. 8.1) son otras formas de perderla, pero no son extinción automática. #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Art. 8.2 de la Orden IET/1311/2013: la autorización de radioaficionado se extingue automáticamente por el fallecimiento de su titular o por la extinción de la asociación de radioaficionados titular de la misma. No es lo mismo que la revocación, que exige expediente y tiene causas específicas (art. 8.1), ni que la renuncia del titular (art. 5.4). Ya no existe la caducidad por no comunicar cada cinco años la intención de seguir usando el espectro: la disposición adicional primera la suprimió junto con sus efectos.]])
#pq(7, 2, 23, "c", "C-R8.39", "Definición de estación fija: ubicación fija consignada en la licencia",
  [Una estación fija es la:],
  ([Que sólo se puede utilizar sin mover de un vehículo determinado.], [Autorizada para su utilización en una ubicación fija y en un único vehículo.], [Autorizada únicamente para su utilización en una ubicación que es fija y que se consigna en la licencia.], [Que solamente puede instalarse dentro de los límites de una provincia.],),
  sol: [El art. 18.1 de la Orden IET/1311/2013 define la estación fija como el conjunto de equipos, soportes y antenas que permiten emitir y recibir desde una ubicación fija determinada; su instalación y funcionamiento precisan la licencia de estación fija, ligada a esa ubicación (cambiar la antena de sitio obliga a pedirlo como una primera instalación, art. 20). Por eso es correcta la c. La a y la b atan la estación a un vehículo, lo propio de la móvil (la b, además, se contradice: una ubicación fija no puede ser un vehículo); la d inventa un límite provincial que no existe. #vease[(Véase tema R8, secciones «Autorización y licencia de estación» y «Tipos de estación».)]

    #no-esta[Art. 18.1 de la Orden IET/1311/2013: estación fija de radioaficionado es el conjunto de equipos, soportes, antenas, cables de interconexión y demás elementos que permiten emitir y recibir señales desde una ubicación fija determinada. Precisa licencia de estación fija, asociada a la autorización de su titular, y una misma licencia puede amparar varios equipos. Se clasifican en individuales y colectivas (estas, solo de asociaciones reconocidas). Las móviles y portátiles no necesitan licencia de estación.]])
#pq(7, 2, 24, "d", "F-R8.53", "Plazos de fin de instalación: comunicarlo en 6 semanas; la Jefatura verifica y expide en ≤ 30 días",
  [Según el artículo 20 de la Orden IET/1311/2013, terminada la instalación de una estación fija en las condiciones autorizadas, el interesado debe comunicarlo a la Jefatura Provincial, justificando documentalmente que el seguro de responsabilidad civil está cubierto, en un plazo de:],
  ([60 días], [30 días], [15 días], [6 semanas],),
  sol: [Art. 20, primer párrafo: finalizada la instalación, el interesado lo comunica a la Jefatura Provincial en 6 semanas, con justificante fehaciente del seguro de responsabilidad civil y, en su caso, el boletín de la empresa instaladora. No mezcles las cifras del artículo: los 30 días son el plazo máximo de la Jefatura para verificar y expedir la licencia, y los 60 días, el límite de las modificaciones experimentales. Los 15 días son la duración máxima de los usos portables no continuados que no precisan notificación (art. 17.1), otro asunto. #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Art. 20 de la Orden IET/1311/2013 (licencia de estación fija), tres cifras. 1) Terminada la instalación, el interesado lo comunica a la Jefatura Provincial en 6 semanas, con justificante del seguro de responsabilidad civil y, en su caso, el boletín de la empresa instaladora. 2) La Jefatura dispone de 30 días como máximo para verificar, inspeccionar si lo estima conveniente y expedir la licencia. 3) Con la licencia, las modificaciones experimentales pueden durar hasta 60 días.]])
#pq(7, 2, 25, "b", "F-R8.43", "Licencia fija condicionada a no perturbar otros servicios y a cumplir normas de seguridad, servidumbres, medio ambiente",
  [Según el artículo 18.3 de la Orden IET/1311/2013, la licencia de funcionamiento de una estación fija de radioaficionado queda condicionada, en cualquier caso, a:],
  ([la pertenencia del titular a una asociación de radioaficionados reconocida por la SETSI], [la ausencia de perturbaciones a otros servicios radioeléctricos autorizados y el cumplimiento de las normas sobre seguridad nacional, servidumbres, medio ambiente y ordenación del territorio], [el informe favorable de la comunidad de propietarios sobre las antenas de la estación], [una inspección anual de la Jefatura Provincial que confirme que la estación sigue en regla],),
  sol: [El art. 18.3 condiciona la licencia de una estación fija, en cualquier caso, a que no perturbe a otros servicios radioeléctricos autorizados y a que se cumplan las normas vigentes de seguridad nacional, servidumbres radioeléctricas o aeronáuticas, medio ambiente y ordenación del territorio. No se exige ser socio de ninguna asociación (a). La comunidad de propietarios puede alegar sobre la idoneidad del emplazamiento (RD 2623/1986, art. 3), pero no concede ni deniega la licencia (c). Y la Jefatura inspecciona «si lo estima conveniente» al expedirla (art. 20), no cada año (d). #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Art. 18.3 de la Orden IET/1311/2013: la licencia de funcionamiento de una estación fija queda condicionada, en cualquier caso, a la ausencia de perturbaciones a otros servicios radioeléctricos autorizados y al cumplimiento de las disposiciones vigentes en materia de seguridad nacional, servidumbres radioeléctricas o aeronáuticas, medio ambiente, ordenación del territorio y cualquier otra que resulte de aplicación.]])
#pq(7, 2, 26, "d", "C-R8.18", "Condiciones de instalación: sin molestias ni peligro, señalizar anclajes y riostras, materiales resistentes, respetar otras antenas, no dañar la obra",
  [Señale la proposición incorrecta:],
  ([Las antenas y elementos anejos se instalarán de forma que no produzcan molestias, peligro o daño a personas o bienes.], [En los casos en que las antenas se sitúen en azoteas o lugares transitables se señalizarán los anclajes y riostras.], [La instalación de las antenas se hará de modo que se respeten las separaciones entre ellas y los elementos, instalaciones y antenas de otros servicios para que estos no resulten degradados en su funcionamiento.], [Las antenas y elementos anejos, y en particular, soportes, anclajes y riostras deberán ser de materiales endebles y de fácil instalación para facilitar su posterior desmontaje.],),
  sol: [La falsa es la d: el Reglamento de antenas (RD 2623/1986, art. 16) exige lo contrario. Las características mecánicas de antenas y elementos anejos deben responder a las normas de la buena construcción y soportar los esfuerzos de uso, y soportes, anclajes y riostras han de ser de materiales resistentes a la corrosión o tratados convenientemente. Nada de materiales «endebles»: una antena mal sujeta puede caer sobre personas o bienes. Las otras tres afirmaciones son ciertas (arts. 12 y 13 del mismo Reglamento): no causar molestias, peligro ni daño, señalizar anclajes y riostras en azoteas y lugares transitables, y respetar las separaciones con otros servicios. #vease[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

    #no-esta[RD 2623/1986, art. 16: las antenas y elementos anejos deben responder a las normas de la buena construcción y ser capaces de absorber los esfuerzos de uso, teniendo en cuenta las condiciones ambientales del lugar; soportes, anclajes y riostras deben ser de materiales resistentes a la corrosión o tratados convenientemente. Regla práctica en una pregunta de «proposición incorrecta» sobre antenas: si una opción sacrifica la seguridad o la resistencia mecánica por comodidad (materiales débiles, fáciles de desmontar), es la falsa.]])
#pq(7, 2, 27, "a", "C-R8.1", "Autorización especial experimental: pedirla con al menos 1 mes de antelación",
  [¿Con qué anticipación a la fecha prevista para el comienzo de las emisiones se deberá solicitar una autorización especial de uso del espectro radioeléctrico por radioaficionados?],
  ([1 mes.], [2 meses.], [3 meses.], [Ninguno.],),
  sol: [La autorización especial para usos experimentales (art. 17.3 de la Orden IET/1311/2013) se pide a la SETSI, con la memoria técnica, «con al menos un mes de antelación» a la fecha prevista para empezar a emitir. La norma fija un único plazo mínimo: un mes. Por eso fallan «2 meses», «3 meses» y «ninguno». No lo confundas con los 5 días de aviso de las estaciones portables (art. 17.1) ni con los 18 meses de validez máxima inicial de la autorización. #vease[(Véase tema R8, sección «Usos especiales y casos particulares».)]

    #no-esta[La autorización especial (art. 17.2 y 17.3 de la Orden IET/1311/2013) es la que se necesita para emitir con carácter experimental y con características técnicas distintas de las del Reglamento. Se solicita a la SETSI, directamente o a través de la Jefatura Provincial, con una memoria técnica (experimento, bloques del equipo, lugar con coordenadas, periodo, banda, emisión, potencia y antena) y al menos un mes antes del inicio previsto. Es nominativa y dura como máximo 18 meses iniciales.]])
#pq(7, 2, 28, "b", "F-R8.39", "Memoria técnica de la autorización experimental: contenido (experimento, diagrama si es casero, coordenadas, período, banda, emisión, potencia, antena)",
  [¿Cuál de los siguientes datos NO forma parte de la memoria técnica que debe acompañar a la solicitud de una autorización especial experimental (art. 17.2 de la Orden IET/1311/2013)?],
  ([el período de utilización de la banda], [la lista de socios de la asociación del solicitante], [la potencia de salida del transmisor], [el tipo y la ganancia de la antena],),
  sol: [El art. 17.2 enumera el contenido de la memoria técnica: el experimento, el diagrama de bloques (si el equipo es de construcción propia), el lugar con sus coordenadas, el período de utilización, la banda, la denominación de la emisión, la potencia de salida y el tipo y la ganancia de la antena. Por eso el período (a), la potencia (c) y la antena (d) sí figuran. La lista de socios de una asociación (b) no es un dato técnico del experimento y no se pide en la memoria. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Según el art. 17.2 de la Orden IET/1311/2013, la solicitud de autorización especial experimental va acompañada de una memoria técnica que describe: el experimento o prueba; el diagrama de bloques de los equipos, si son de construcción propia; el lugar, con las coordenadas geográficas de la instalación; el período de utilización; la banda; la denominación de la emisión; la potencia de salida del transmisor; y el tipo y la ganancia de la antena.]])
#pq(7, 2, 29, "d", "R9.17", "Sanciones accesorias: cese, ajuste, precintado o incautación de equipos, clausura",
  [Con independencia de la multa que corresponda, la Administración puede acordar, como medida sobre los equipos:],
  ([su traslado a un centro de investigación], [su venta en subasta pública], [su cesión obligatoria a otro radioaficionado], [su precintado o incautación],),
  sol: [Es una sanción accesoria (art. 109.2.c de la Ley 11/2022), independiente de la multa, dirigida a que cese de inmediato la conducta infractora: se sella o se retira el equipo para que no pueda seguir emitiendo.])
#pq(7, 2, 30, "c", "F-R9.4", "Plazo para resolver el procedimiento sancionador: un año",
  [Según el art. 114.2 de la Ley 11/2022, el plazo para resolver el procedimiento sancionador en materia de telecomunicaciones es de:],
  ([dos años], [tres meses], [un año], [seis meses],),
  sol: [El art. 114.2 remite al procedimiento administrativo común de la Ley 39/2015, pero con dos plazos propios: el de resolución es de un año, y el de alegaciones, de al menos quince días hábiles. Ni seis meses ni tres meses ni dos años figuran en ese artículo. No hay que confundirlo con la prescripción (art. 113), que es otra cosa: las infracciones prescriben a los tres años las muy graves, a los dos las graves y al año las leves. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador».)]

#_apc3-net[El procedimiento sancionador en materia de telecomunicaciones se tramita por el procedimiento administrativo común (Ley 39/2015), con dos plazos propios que fija el art. 114.2 de la Ley 11/2022: un año para resolver y, como mínimo, quince días hábiles para presentar alegaciones.]])
#fin-prueba()
#soluciones-simulacro(7)

// ======================================================================
#simulacro(8)
#prueba(8, 1)
#pq(8, 1, 1, "b", "T1.9", "Potencia eléctrica: P = V I = I² R = V² / R",
  [Según las leyes básicas de la electricidad, señale la fórmula incorrecta:],
  ([$E = I dot R$], [$P = E^2 dot R$], [$P = I^2 dot R$], [$P = E dot I$],),
  sol: [Las fórmulas correctas de la potencia son $P = E dot I = I^2 R = E^2 slash R$. La opción (b) multiplica en lugar de dividir: la correcta con tensión es $E^2 slash R$.])
#pq(8, 1, 2, "d", "C-T1.29", "Asociación de pilas: en serie se suman las tensiones; en paralelo, las corrientes (y baja la resistencia interna)",
  [En un circuito con varias baterías conectadas en paralelo:],
  ([La corriente disponible disminuye.], [La tensión del conjunto es cero.], [La tensión total se suma.], [La resistencia interna equivalente del conjunto disminuye.],),
  sol: [
    Con baterías iguales en paralelo la tensión del conjunto es la de una sola (no se suma, lo que
    descarta c; y desde luego no es cero, b), mientras que las corrientes de cada una se suman: la
    corriente disponible aumenta, no disminuye, y así se descarta a). Cada batería tiene una
    resistencia interna $r$ y las de $n$ baterías iguales quedan en paralelo, luego
    $r_("eq") = r slash n$: la resistencia interna equivalente disminuye, y la tensión cae menos al
    pedir corriente. #vease[(Véase tema T1, sección «Fuentes y energía».)]
    #no-esta[Cada batería real es una fuerza electromotriz $ϵ$ en serie con una resistencia interna $r$. Con
    $n$ baterías iguales en paralelo, las fems no se suman (los bornes son comunes) y las
    resistencias internas se asocian en paralelo: $r_("eq") = r slash n$. Ejemplo: 4 baterías de 1,5
    V y 0,5 Ω dan 1,5 V con 0,125 Ω y pueden entregar cuatro veces la corriente con la misma caída
    de tensión interna. En serie ocurre lo contrario: se suman las fems y también las resistencias
    internas.]
  ])
#pq(8, 1, 3, "c", "F-T1.30", "CRC detecta errores; FEC los corrige sin retransmisión a costa de velocidad útil",
  [En una transmisión digital, la diferencia esencial entre el CRC y el FEC es que:],
  ([ambos corrigen errores, pero el FEC no añade bits redundantes a los datos], [el CRC corrige errores sin retransmisión; el FEC solo sirve para detectarlos], [el CRC solo detecta errores; el FEC añade redundancia para corregirlos sin retransmisión], [el CRC se usa en modulación analógica; el FEC, únicamente en modulación digital],),
  sol: [El CRC es un código calculado sobre los datos: el receptor lo recalcula y, si no coincide, sabe que hubo error (no dónde), de modo que hay que pedir la repetición. El FEC (_Forward Error Correction_) añade redundancia suficiente para que el receptor corrija por sí mismo, sin retransmisión, a costa de una menor velocidad útil. Ambos son técnicas digitales y ambos exigen añadir bits. _(Véase tema T1, sección «Señales moduladas».)_
#_apc1-noest[Para combatir los errores de una transmisión digital se añaden bits redundantes. Con CRC (comprobación de redundancia cíclica) el emisor añade un código calculado sobre el bloque; el receptor lo recalcula y, si no coincide, descarta el bloque y puede pedir su repetición. Con FEC (corrección directa de errores) la redundancia es mayor y el receptor corrige sin retransmisión, útil en enlaces con mucho retardo o de un sentido; FT8 combina ambos. La redundancia reduce la velocidad útil.]])
#pq(8, 1, 4, "a", "F-T1.48", "Conversores A/D y D/A: qué convierte cada uno",
  [Un conversor analógico-digital (A/D) convierte:],
  ([una señal analógica en una secuencia de números binarios], [una secuencia de números binarios en una señal analógica], [una señal de RF en una señal de frecuencia intermedia], [una corriente alterna en corriente continua],),
  sol: [El A/D muestrea la señal analógica y cuantifica cada muestra en un código binario de $n$ bits, es decir, en uno de $2^n$ niveles. La operación inversa (b) la hace el conversor D/A. Pasar de RF a FI es tarea de un mezclador (c), y de alterna a continua, de un rectificador (d): ninguno de los dos convierte la señal en números. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_])
#pq(8, 1, 5, "c", "T2.26", "Unidad de capacidad: el faradio (no mide la carga)",
  [De las siguientes parejas unidad de medida/magnitud, señale la _incorrecta_:],
  ([voltio: diferencia de potencial], [amperio: corriente eléctrica], [faradio: cantidad de carga], [hercio: frecuencia],),
  sol: [El faradio mide la capacidad; la cantidad de carga se mide en culombios. Las otras tres parejas son correctas.])
#pq(8, 1, 6, "a", "F-T2.6", "La reactancia inductiva X_L = 2πfL crece con la frecuencia y es nula en continua",
  [Si se duplica la frecuencia de la corriente que recorre una bobina ideal, manteniendo su inductancia, su reactancia inductiva:],
  ([se duplica], [se reduce a la mitad], [se cuadruplica], [no varía],),
  sol: [$X_L = 2 pi f L$ es directamente proporcional a la frecuencia: con $L$ constante, al pasar de $f$ a $2 f$ la reactancia pasa de $X_L$ a $2 X_L$. Reducirse a la mitad (b) es lo que le ocurre a un condensador, cuya $X_C = 1/(2 pi f C)$ es inversamente proporcional a $f$; cuadruplicarse (c) exigiría una dependencia con $f^2$, que no existe; y no variar (d) solo vale para una resistencia pura. Por eso la bobina deja pasar la continua y frena la radiofrecuencia. _(Véase tema T2, sección «Bobinas», y capítulo «Cómo funciona una radio: de los campos a la voz», sección 2 (tabla de reactancias de bobina y condensador).)_])
#pq(8, 1, 7, "d", "C-T2.5", "El transformador son dos bobinas acopladas que transforman una alterna en otra alterna",
  [Un transformador sirve para:],
  ([Transformar un acumulador en un motor], [Transformar una corriente continua en alterna], [Transformar una potencia eléctrica en calor], [Transformar una corriente alterna en otra también alterna],),
  sol: [
    El transformador pasa energía de un devanado a otro mediante un flujo magnético variable, así
    que solo trabaja con corriente alterna y entrega otra corriente alterna de la misma frecuencia,
    con la tensión y la corriente cambiadas (si sube una, baja la otra). Convertir continua en
    alterna (b) es tarea de un oscilador o un inversor. Transformar potencia eléctrica en calor (c)
    lo hace una resistencia. Y transformar un acumulador en un motor (a) no tiene sentido físico.
    #vease[(Véase tema T2, sección «Transformadores», y capítulo «La radio por dentro», apartado «El
    transformador: dos bobinas y un puente de flujo».)]
  ])
#pq(8, 1, 8, "d", "F-T2.12", "Cálculo de la adaptación de impedancias: Z_p = (N_p/N_s)² Z_s (balun 4:1 = espiras 2:1)",
  [Un transformador ideal con una relación de espiras primario/secundario de 3:1 tiene en su secundario una carga de 8 Ω. La impedancia que presenta al generador conectado al primario es de:],
  ([24 Ω], [2,7 Ω], [0,89 Ω], [72 Ω],),
  sol: [$Z_p = (N_p slash N_s)^2 Z_s = 3^2 times 8 = 72$ Ω. La impedancia se multiplica por el cuadrado de la relación de espiras: la tensión del primario es 3 veces la del secundario y su corriente, 3 veces menor, así que $V slash I$ crece $3 times 3 = 9$ veces. Los 24 Ω (a) olvidan elevar al cuadrado; los 2,7 Ω (b) dividen entre 3 en lugar de multiplicar; y los 0,89 Ω (c) dividen entre 9. _(Véase tema T2, sección «Transformadores», y capítulo «La radio por dentro: componente a componente», apartado «El transformador: dos bobinas y un puente de flujo».)_])
#pq(8, 1, 9, "c", "T3.33", "Filtro paso bajo: deja pasar las frecuencias inferiores a la de corte (a la salida del TX, contra armónicos)",
  [Un filtro de paso bajo deja pasar:],
  ([únicamente la frecuencia de corte], [las frecuencias superiores a la de corte], [las frecuencias inferiores a la de corte], [una banda estrecha centrada en la frecuencia de corte],),
  sol: [El nombre lo dice: pasa lo bajo. Es el filtro que se coloca a la salida de un transmisor para atenuar los armónicos, que están por encima de la frecuencia de trabajo.])
#pq(8, 1, 10, "a", "F-T3.47", "Filtros en pi y en T: pi paso bajo = C–L–C; T paso bajo = L–C–L (en paso alto se intercambian)",
  [Un filtro de paso bajo «en pi» está formado por:],
  ([un condensador a masa, una bobina en serie y otro condensador a masa], [dos condensadores en serie con una bobina a masa entre ellos], [dos bobinas en serie con un condensador a masa entre ellas], [una bobina a masa, un condensador en serie y otra bobina a masa],),
  sol: [El nombre viene de la forma del esquema: una rama en serie y dos ramas a masa dibujan la letra griega $pi$. En el paso bajo la bobina, que se opone a las frecuencias altas, va en serie, y los condensadores, que las desvían a masa, van en paralelo: C–L–C. La opción con bobinas a masa y condensador en serie es el pi de paso alto, pues los papeles se intercambian. Las opciones con dos elementos iguales en serie y uno a masa son filtros en T, no en pi. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_])
#pq(8, 1, 11, "c", "C-T3.12", "Emisor común: ganancia de tensión y de corriente, luego de potencia",
  [Un amplificador con transistor conectado con emisor común produce amplificación:],
  ([Solo de corriente], [Solo de tensión], [De potencia], [Depende de que sea del tipo PNP o NPN],),
  sol: [
    El emisor común da ganancia de tensión y de corriente a la vez y, como la potencia es $P = V I$,
    da también ganancia de potencia: es la configuración que más amplifica de las tres (e invierte
    la fase de la señal). Por eso no son correctas «solo de tensión» ni «solo de corriente». Tampoco
    depende del tipo: un PNP funciona igual que un NPN con la polaridad de la alimentación
    invertida, sin cambiar su comportamiento. #vease[(Véase tema T2, sección «Semiconductores y
    otros componentes».)]
  ])
#pq(8, 1, 12, "b", "T3.23", "Linealidad frente a rendimiento: clase A mínima distorsión; clase C mayor rendimiento",
  [De las clases de amplificación A, AB, B y C, la de mayor rendimiento es la:],
  ([clase A], [clase C], [clase B], [clase AB],),
  sol: [El rendimiento crece según se acorta el ángulo de conducción, y la clase C es la que menos conduce. Es también la que peor conserva la forma de la señal: las dos cosas van siempre de la mano.])
#pq(8, 1, 13, "d", "F-T3.15", "Discriminador de FM: convierte variaciones de frecuencia en variaciones de tensión (audio)",
  [El discriminador de un receptor de FM convierte:],
  ([la frecuencia intermedia en una señal de radiofrecuencia], [la señal de audio en una portadora modulada en frecuencia], [las variaciones de amplitud de la señal en variaciones de frecuencia], [las variaciones de frecuencia de la señal en variaciones de tensión, es decir, en audio],),
  sol: [Es el demodulador de FM: la información va en la desviación de frecuencia de la portadora, y el discriminador entrega una tensión proporcional a esa desviación instantánea, o sea, el audio. Va precedido de un limitador que borra las variaciones de amplitud (el ruido). Convertir audio en una portadora modulada es lo que hace el modulador del transmisor; subir la FI a RF lo haría un mezclador; y convertir amplitud en frecuencia no es detectar FM. _(Véase tema T3, sección «Clases de amplificación y detectores».)_])
#pq(8, 1, 14, "a", "C-T4.3", "Pasar de USB a LSB cambia la frecuencia del BFO (batido), no el ancho de banda ni la clase de emisión",
  [Cuando se pasa el modo de recepción de USB a LSB se cambia:],
  ([La frecuencia de batido], [El ancho de banda de la FI], [La sensibilidad del receptor], [De recibir en A3E a recibir en J3E],),
  sol: [
    USB y LSB son la misma clase de emisión, J3E (banda lateral única con portadora suprimida; el
    «A3j» de las denominaciones antiguas): solo cambia cuál de las dos bandas laterales se demodula.
    El filtro de la FI sigue siendo el mismo, de unos 2,4 a 3 kHz, así que no cambian ni el ancho de
    banda ni la sensibilidad. Lo que se modifica es la frecuencia del oscilador de batido (BFO), que
    se sitúa al otro lado de la banda de paso del filtro para reinsertar la portadora por el lado
    que corresponde. #vease[(Véase tema T4, sección «Características y controles» (BFO y detector de
    producto).)]
    #no-esta[En SSB no se transmite la portadora y el receptor la repone con el BFO en el detector de
    producto. La frecuencia de batido se coloca a uno u otro lado de la banda de paso del filtro de
    FI según la banda lateral que se quiera recibir. Al pasar de USB a LSB, o al revés, el equipo
    solo desplaza el BFO unos kilohercios (algunos transceptores invierten en su lugar el oscilador
    local), sin tocar el filtro ni la ganancia.]
  ])
#pq(8, 1, 15, "c", "T4.14", "Estabilidad: mantener la frecuencia sintonizada sin derivar",
  [En un receptor, la capacidad de mantener la frecuencia sintonizada se denomina:],
  ([fidelidad], [sensibilidad], [estabilidad], [selectividad],),
  sol: [Estabilidad: capacidad de mantener la frecuencia sintonizada sin deriva (térmica o mecánica).])
#pq(8, 1, 16, "b", "T5.11", "Multiplicador de frecuencia: eleva la frecuencia del oscilador; en cascada, los factores se multiplican",
  [El multiplicador de frecuencia de un transmisor se emplea para:],
  ([filtrar la señal moduladora], [incrementar la frecuencia generada por un oscilador], [estabilizar la tensión de alimentación], [reducir el consumo del equipo],),
  sol: [El multiplicador toma la salida de un oscilador estable y la multiplica (×2, ×3…) para alcanzar la frecuencia de trabajo, típico en equipos de VHF/UHF.])
#pq(8, 1, 17, "a", "T5.31", "Sobremodulación: índice > 100 %; distorsión y ensanchamiento de la emisión (splatter)",
  [Se dice que un transmisor de amplitud modulada está sobremodulando cuando:],
  ([el índice de modulación supera el 100 %], [la portadora desaparece por completo], [la frecuencia se aparta de la asignada], [la potencia de salida supera la nominal],),
  sol: [Con índice mayor que 1 la envolvente intenta hacerse negativa, la portadora se recorta y aparecen productos de distorsión que ensanchan la emisión. Es el mismo fenómeno que produce el splatter en SSB.])
#pq(8, 1, 18, "c", "T5.1", "Impedancia de salida típica: 50 Ω",
  [La impedancia de salida típica de los transmisores de radioaficionado es de:],
  ([75 Ω], [300 Ω], [50 Ω], [600 Ω],),
  sol: [El estándar es 50 Ω (52 en algunos textos): transmisor, línea y antena se diseñan para esa impedancia común.])
#pq(8, 1, 19, "b", "C-T6.4", "Antena helicoidal: polarización circular, usada en enlaces por satélite",
  [Una antena helicoidal se usa:],
  ([Para poder emplear la misma antena para la banda de 144 y 432 MHz], [Para enlaces por satélites], [Porque permiten orientarlas con más facilidad que las colineales], [Porque son las más efectivas para hacer las ruedas de aficionados],),
  sol: [
    La hélice, en su modo normal de trabajo (modo axial), radia con polarización circular y un
    lóbulo directivo a lo largo de su eje. La polarización circular es la adecuada para los enlaces
    por satélite: el satélite gira y cambia de orientación respecto de la estación y, además, la
    ionosfera rota la polarización de la onda, de modo que una polarización lineal fija se
    desvanecería por momentos. Las otras opciones son falsas: la hélice no está pensada para
    trabajar en dos bandas (a), al ser directiva hay que orientarla, y es más incómoda que una
    colineal omnidireccional (c), y para las ruedas locales bastan una vertical o una Yagi (d).
    #no-esta[Antena helicoidal: hilo arrollado en espiral (hélice) delante de un plano reflector. Trabajando
    en modo axial es directiva en la dirección de su eje y su polarización es circular (el campo
    eléctrico gira); su ganancia crece con el número de espiras. Esa polarización circular es la que
    se emplea en comunicaciones por satélite, porque no depende de cómo quede orientada la antena
    del satélite ni de la rotación de Faraday que introduce la ionosfera.]
  ])
#pq(8, 1, 20, "d", "F-T6.1", "Conversión dBi = dBd + 2,15 (la p.i.r.e. es 2,15 dB mayor que la p.r.e.)",
  [Una antena tiene una ganancia de 7,85 dBi. Referida al dipolo de media onda, su ganancia es de:],
  ([7,85 dBd], [10 dBd], [3,65 dBd], [5,7 dBd],),
  sol: [El dipolo de media onda ya gana 2,15 dB sobre la antena isótropa, así que la cifra en dBd es 2,15 dB _menor_ que en dBi: $G_"dBd" = G_"dBi" - 2,15 = 7,85 - 2,15 = 5,7$ dBd. Los 10 dBd suman en vez de restar; los 7,85 dBd ignoran la conversión y confunden las dos referencias; y los 3,65 dBd salen de dividir entre 2,15, cuando los decibelios se suman y se restan, no se dividen. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]])
#pq(8, 1, 21, "d", "F-T6.10", "Coeficiente de reflexión y ROE a partir de las impedancias (150 Ω en 50 Ω → ROE 3)",
  [Una antena resistiva pura de 150 Ω se conecta a una línea de 50 Ω. La relación de ondas estacionarias (ROE) es de:],
  ([0,5], [1,5], [2], [3],),
  sol: [Coeficiente de reflexión: $rho = (Z_L - Z_0) / (Z_L + Z_0) = (150 - 50) / (150 + 50) = 0,5$. ROE: $(1 + rho) / (1 - rho) = (1,5) / (0,5) = 3$. Con carga resistiva basta dividir la impedancia mayor entre la menor: 150/50 = 3. El 0,5 es el coeficiente $rho$, no la ROE; el 1,5 es solo el numerador $1 + rho$; y el 2 sale de dividir 100 (la diferencia) entre 50. #vease[(Véase tema T6, sección «Líneas de transmisión y adaptación».)]])
#pq(8, 1, 22, "b", "T6.12", "Balun: une el coaxial (asimétrico) con el dipolo (simétrico); sin él la malla radia",
  [El dispositivo que se emplea para conectar un cable coaxial (línea asimétrica) a un dipolo (antena simétrica) es:],
  ([un atenuador], [un balun], [un preamplificador], [un duplexor],),
  sol: [El balun (_balanced–unbalanced_) hace de transición entre el coaxial (asimétrico) y el dipolo (simétrico), evitando corrientes en la malla.])
#pq(8, 1, 23, "b", "C-T7.4", "A mayor frecuencia, menor alcance (144 MHz llega más fuerte que 430 MHz)",
  [En condiciones normales, para una misma potencia radiada, las ondas que llegarían con más
intensidad a un punto alejado serían:],
  ([cualquiera de las superiores a 144 MHz], [las de 144 MHz], [las de 430 MHz], [las superiores a 430 MHz],),
  sol: [
    Con la misma potencia radiada y antenas de igual ganancia, la atenuación crece con la
    frecuencia: $L = 32,4 + 20 log_10 f + 20 log_10 d$. Pasar de 144 a 430 MHz añade
    $20 log_10(430 slash 144) ≈ 9,5$ dB de pérdida, y a frecuencias aún mayores, más. Además la
    lluvia, la vegetación y los obstáculos atenúan más cuanto más alta es la frecuencia. Llega más
    fuerte la señal de menor frecuencia, la de 144 MHz; las otras tres opciones son frecuencias más
    altas. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]
  ])
#pq(8, 1, 24, "a", "T7.21", "Difracción: la onda bordea un obstáculo",
  [La curvatura que experimenta una onda radioeléctrica al encontrar un obstáculo en su trayectoria se denomina:],
  ([difracción], [reflexión], [refracción], [absorción],),
  sol: [La difracción es la capacidad de la onda para bordear un obstáculo y llegar a la zona de sombra geométrica, y es tanto mayor cuanto más larga es la longitud de onda: por eso en HF se salva un monte que en UHF deja sombra. La reflexión rebota, la refracción curva al cambiar de medio y la absorción convierte la energía en calor.])
#pq(8, 1, 25, "c", "T7.8", "La capa D absorbe de día las bandas bajas (3,5 MHz: de día menos alcance que de noche)",
  [En la banda de 3,5 MHz, los alcances por reflexión ionosférica durante el día, frente a los de la noche, son:],
  ([nulos en cualquier caso], [iguales], [menores], [mayores],),
  sol: [De día la capa D absorbe las bandas bajas de HF: alcances menores. Por eso 80 m es una banda nocturna.])
#pq(8, 1, 26, "b", "T8.9", "El polímetro no mide la impedancia de una antena (hace falta puente o analizador de antenas)",
  [Un polímetro (multímetro) NO sirve para medir:],
  ([corrientes alternas], [la impedancia de la antena], [resistencias], [tensiones continuas],),
  sol: [El polímetro mide tensión, corriente y resistencia; la impedancia de una antena en RF exige un puente o analizador de antenas.])
#pq(8, 1, 27, "d", "T9.13", "Emisiones fuera de banda: inmediatamente exteriores a la anchura necesaria, por la modulación",
  [Las emisiones fuera de banda de un transmisor están constituidas por:],
  ([las emisiones realizadas con potencia superior a la autorizada], [las señales que el receptor capta fuera de la banda de aficionados], [exclusivamente los armónicos de la frecuencia fundamental], [las emisiones inmediatamente exteriores a la anchura de banda necesaria, resultantes del proceso de modulación],),
  sol: [Son las «faldas» que quedan a los lados de la emisión por culpa del propio proceso de modulación. Junto con las emisiones no esenciales (espurias, entre ellas los armónicos) forman las emisiones no deseadas.])
#pq(8, 1, 28, "b", "T9.14", "Intermodulación: dos o más señales intensas mezcladas en una etapa no lineal",
  [La intermodulación se produce cuando:],
  ([la antena está perfectamente adaptada a la línea], [dos o más señales intensas se mezclan en una etapa no lineal], [una sola señal muy débil satura el receptor], [se emplea una potencia de transmisión muy reducida],),
  sol: [De esa mezcla salen sumas y diferencias que no estaban en ninguna de las dos señales originales y que pueden caer justo encima de la frecuencia que escuchamos. Ocurre tanto en la etapa final de un transmisor sobreexcitado como en la entrada de un receptor saturado.])
#pq(8, 1, 29, "c", "T10.4", "La tierra debe llegar a cada uno de los chasis metálicos, unidos entre sí",
  [La toma de tierra de la estación debe conectarse:],
  ([solo a los equipos alimentados con corriente alterna], [solo al equipo de mayor potencia], [a cada uno de los chasis metálicos de los distintos equipos], [únicamente al mástil de la antena],),
  sol: [La toma de tierra debe llegar a todos los chasis metálicos interconectados; un equipo sin tierra rompe la protección.])
#pq(8, 1, 30, "a", "T10.22", "La toma de tierra debe tener la menor resistencia posible",
  [La toma de tierra de la instalación de una estación de radioaficionado debe:],
  ([presentar la menor resistencia posible y conectar todos los chasis metálicos], [tener la mayor resistencia posible para limitar la corriente], [conectarse únicamente al neutro de la red], [instalarse solo en las estaciones de más de 100 vatios],),
  sol: [Cuanto menor sea la resistencia, mejor deriva la corriente de fuga y antes actúa el diferencial. Y debe llegar a _todos_ los chasis: uno solo sin conectar rompe la cadena y se convierte en el punto peligroso.])
#fin-prueba()
#prueba(8, 2)
#pq(8, 2, 1, "d", "R1.24", "F Foxtrot y G Golf",
  [La palabra de deletreo «Foxtrot» corresponde a la letra:],
  ([V], [T], [X], [F],),
  sol: [_Foxtrot_ es la F. Conviene fijarse en la palabra entera y no en su primera sílaba, que despista hacia la X.])
#pq(8, 2, 2, "a", "R2.2", "QRM (interferencia de otras estaciones) frente a QRN (parásitos atmosféricos)",
  [El grupo `QRM` indica:],
  ([interferencia producida por otras estaciones], [desvanecimiento de la señal], [emisión con baja potencia], [parásitos atmosféricos],),
  sol: [`QRM`: interferencia de otras estaciones (origen humano); no confundir con `QRN`.])
#pq(8, 2, 3, "a", "R2.31", "QSL acuse de recibo frente a QSO comunicado entre dos estaciones",
  [El contacto establecido entre dos estaciones de aficionado se designa con el grupo:],
  ([`QSO`], [`QTC`], [`QSL`], [`QRV`],),
  sol: [`QSO` designa la comunicación establecida entre dos estaciones. Se usa como sustantivo —«hacer un `QSO`»— con toda naturalidad.])
#pq(8, 2, 4, "b", "F-R2.3", "QSX ¿quiere escuchar a… en… kHz? (frente a QSN, que mira al pasado)",
  [El grupo #_apc2-m[QSX], como pregunta, equivale a:],
  ([¿ha escuchado a… en… kHz?], [¿quiere escuchar a… en… kHz?], [¿debo cambiar de frecuencia?], [¿debo transmitir una serie de letras V?],),
  sol: [#_apc2-m[QSX?] es «¿quiere escuchar a… en… kHz?» y la respuesta, «escucho a… en… kHz». Cuidado con #_apc2-m[QSN], que mira al pasado («¿ha escuchado a…?»): #_apc2-m[QSX] mira al futuro («¿quiere escuchar…?»). Los otros distractores son #_apc2-m[QSV] (transmita una serie de V) y #_apc2-m[QSY] (cambie de frecuencia). #no-esta[Otro grupo Q que no figura en las tablas es #_apc2-m[QSX]: «¿quiere escuchar a… en… kHz?»; se responde «escucho a… en… kHz». Es un grupo de escucha: pide que se atienda a otra estación en una frecuencia. No lo confundas con #_apc2-m[QSN], de las tablas: #_apc2-m[QSN] pregunta si se ha oído (pasado) y #_apc2-m[QSX] si se quiere escuchar (futuro).]])
#pq(8, 2, 5, "d", "R3.9", "OM operador corresponsal (old man)",
  [La abreviatura `OM` se emplea para referirse a:],
  ([una emisión de onda media], [el operador de una estación repetidora], [un equipo de fabricación casera], [el operador de la estación corresponsal],),
  sol: [Del inglés _old man_. Es el tratamiento cordial habitual entre radioaficionados varones, sin relación alguna con la edad. La versión femenina es `YL`.])
#pq(8, 2, 6, "c", "", "CUL hasta luego (see you later)",
  [La abreviatura operacional `CUL` significa:],
  ([llamada general a todas las estaciones], [cierro la estación], [hasta luego], [recibido conforme],),
  sol: [`CUL` viene del inglés _see you later_: «hasta luego», una despedida informal al final de un contacto. La llamada general es `CQ`, el cierre de la estación es `CL` y «recibido» es `R`.])
#pq(8, 2, 7, "d", "C-R3.8", "Locator (QTH locator, Maidenhead): forma breve de dar la ubicación",
  [¿Qué es «locator»?],
  ([Una propagación que te permite escuchar tu propio eco.], [Un radiogoniómetro.], [La forma de indicar la altura de tu antena.], [Una forma muy rápida de indicar la ubicación de una estación.],),
  sol: [El #emph[locator] (localizador Maidenhead o #emph[QTH locator]) es un código de seis caracteres que identifica una cuadrícula del globo y permite dar la ubicación de una estación de forma breve e inequívoca, p. ej. IN80dk (Madrid). Se usa sobre todo en VHF/UHF y en concursos, donde interesa la distancia entre estaciones. No es un tipo de propagación, ni un radiogoniómetro (el aparato que determina la dirección de una señal), ni indica la altura de la antena.

    #no-esta[El sistema Maidenhead divide el globo en 18 × 18 campos (letras A–R; cada uno de 20° de longitud por 10° de latitud), cada campo en 10 × 10 cuadrados (cifras 0–9; 2° por 1°) y cada cuadrado en 24 × 24 subcuadrados (letras a–x; 5 por 2,5 minutos de arco). Se escribe: dos letras, dos cifras y dos letras (p. ej. IM99jn). Con cuatro caracteres se sitúa la estación en un cuadrado de unos 100 a 200 km de lado; con seis, en unos pocos kilómetros.]])
#pq(8, 2, 8, "d", "R4.12", "Al oír un socorro: silencio, escucha y auxilio si es posible",
  [Una estación de aficionado que escucha una llamada de socorro debe:],
  ([continuar su comunicación en la misma frecuencia], [aumentar su potencia para cubrir la zona], [repetir la llamada en todas las bandas que tenga disponibles], [guardar silencio, permanecer a la escucha y prestar auxilio si puede],),
  sol: [Lo primero es no estorbar: la frecuencia queda para quien está en peligro y para quien pueda auxiliarle. Después, si se está en condiciones de ayudar —o de retransmitir el mensaje a quien pueda— se hace: el art. 30.5 de la Orden obliga a hacer lo posible para que la comunicación de socorro llegue cuanto antes a la Dirección General de Protección Civil y Emergencias. Repetirlo a ciegas por todas las bandas solo multiplica la confusión.])
#pq(8, 2, 9, "b", "F-R4.6", "Banda de 40 m en la Región 1: 7000–7200 kHz",
  [En la Región 1 de la UIT, y por tanto en España, la banda de aficionados de 40 m comprende las frecuencias:],
  ([7100 a 7300 kHz], [7000 a 7200 kHz], [6900 a 7100 kHz], [7000 a 7300 kHz],),
  sol: [La UIT reparte el espectro por Regiones y los límites de 40 m no son iguales en todas. En la Región 1, España incluida, la banda de aficionados va de 7000 a 7200 kHz; el CNAF atribuye 7200–7300 kHz a radiodifusión. En la Región 2 (América) llega hasta 7300 kHz: es la opción más tentadora, pero no vale en España. «7100 a 7300» y «6900 a 7100» son la banda real desplazada: empieza en 7000 kHz y acaba en 7200 kHz. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)] #no-esta[Límites exactos de las bandas de HF en España (Cuadro Nacional de Atribución de Frecuencias): 160 m, 1810–1850 kHz; 80 m, 3500–3800 kHz; 40 m, 7000–7200 kHz; 20 m, 14000–14350 kHz; 15 m, 21000–21450 kHz; 10 m, 28–29,7 MHz. Varían por Regiones de la UIT: en la Región 1 los 7200–7300 kHz son de radiodifusión, mientras que en la Región 2 la banda de 40 m llega hasta 7300 kHz.]])
#pq(8, 2, 10, "b", "", "Cuándo identificarse: al comienzo y al final de cada emisión, siempre, y en las largas al menos cada 10 min",
  [En una emisión de larga duración, además de al comienzo y al final, la estación de aficionado debe transmitir su distintivo de llamada, según la Orden IET/1311/2013, al menos cada:],
  ([5 minutos], [10 minutos], [15 minutos], [30 minutos],),
  sol: [El art. 29 de la Orden exige el distintivo al comienzo y al final de cada emisión y, en las de larga duración, al menos cada diez minutos. Así quien sintoniza a mitad de la comunicación sabe quién transmite. No confundas con los 30 días al año de los distintivos temporales.])
#pq(8, 2, 11, "a", "C-R5.21", "QRP no forma parte del distintivo: se anuncia en la llamada (CQ QRP)",
  [¿Cómo debe identificarse correctamente una estación de baja potencia o QRP?],
  ([Añadiendo un espacio o pausa y las letras QRP a la llamada general CQ.], [Añadiendo el sufijo /QRP al distintivo de llamada.], [Añadiendo la potencia con un número y la letra W de vatios.], [Añadiendo el sufijo /P al distintivo de llamada.],),
  sol: [El distintivo no cambia por trabajar con poca potencia: se transmite tal como se asignó. Lo único que la Orden IET/1311/2013 permite añadirle, y de forma opcional, son /M, /MM, /MA o /P en telegrafía (o las palabras móvil, móvil marítima, móvil aeronáutica o portable) para estaciones móviles o portables (art. 29.2). Por eso la baja potencia se anuncia en la llamada, como práctica operativa: «CQ QRP». La b inventa un sufijo inexistente; la c mezcla la potencia con el distintivo; la d es el sufijo de estación portable, que dice desde dónde se emite, no con cuánta potencia. #vease[(Véase tema R2 (significado de QRP) y tema R5, sección «Asignación y uso del distintivo».)]

    #no-esta[QRP es el grupo del código Q que significa «disminuya la potencia» y, como sustantivo, emisión con baja potencia (por convención de los aficionados, no de la norma, hasta unos 5 W). La identificación reglamentaria es solo el distintivo de llamada, al comienzo y al final de la emisión y al menos cada diez minutos en las largas (art. 29.1 de la Orden IET/1311/2013); solo se admiten los añadidos opcionales /M, /MM, /MA y /P (art. 29.2). La condición QRP no forma parte del distintivo: se anuncia en la llamada, p. ej. «CQ QRP».]])
#pq(8, 2, 12, "c", "C-R5.14", "Las series de prefijos las atribuye la UIT (Reglamento de Radiocomunicaciones) y cada país asigna dentro de ellas",
  [Las primeras letras de un distintivo de llamada:],
  ([Las elige cada país según la inicial francesa de su nombre], [Indican el tipo de autorización], [Son elegidas por cada país a partir de las atribuciones internacionales], [Se atribuyen, en la Conferencia Europea de Administraciones postales y de Telecomunicación, a cada país],),
  sol: [Las series de letras con las que empiezan los distintivos las atribuye a cada país la UIT, en el Reglamento de Radiocomunicaciones; después, cada Administración elige sus prefijos dentro de las series que le han tocado (España: EA–EH y AM–AO, art. 27 de la Orden IET/1311/2013). El banco da por buena la d, pero la CEPT es un organismo europeo de coordinación y no atribuye series de prefijos. La a no es ninguna regla, y la b es falsa: el prefijo identifica al país, no el tipo de autorización. #vease[(Véase tema R5, introducción.)]

    #no-esta[Reparto de prefijos: la UIT, en el artículo 19 del Reglamento de Radiocomunicaciones, atribuye a cada país series de caracteres con los que deben empezar los distintivos de sus estaciones. Cada Administración asigna luego los distintivos dentro de sus series. A España le corresponden EAA–EHZ y AMA–AOZ. La CEPT, en cambio, armoniza la licencia CEPT (T/R 61-01), no reparte prefijos.]

    #_apb2-clave[«Se atribuyen, en la Conferencia Europea de Administraciones postales y de Telecomunicación, a cada país». Es la clave que dan las recopilaciones de exámenes reales (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea la técnicamente correcta.]])
#pq(8, 2, 13, "a", "C-R5.2", "Sufijos excluidos: DDD, PAN, SOS, TTT, XXX y la serie QAA–QZZ",
  [¿Cuál de los siguientes sufijos podrá ser asignado a un distintivo de llamada de la autorización de radioaficionado?],
  ([EEE], [QRS], [TTT], [PAN],),
  sol: [EEE es una combinación ordinaria de tres letras y se asigna cuando le toca por orden alfabético. Las otras tres están excluidas por el artículo 27 de la Orden IET/1311/2013: TTT y PAN expresan señales de seguridad y de urgencia, y QRS cae en la serie QAA–QZZ, vedada para que ningún distintivo se confunda con un código Q. #vease[(Véase tema R5, sección «Asignación y uso del distintivo».)]

    #no-esta[El artículo 27 veta, además de SOS, XXX y TTT, otros dos grupos: DDD y PAN (este último, la señal de urgencia en fonía). Tampoco se adjudica ningún sufijo entre QAA y QZZ. Regla de examen: si una opción es un grupo de socorro, urgencia o seguridad, o un código Q, no es asignable; EEE no tiene ninguna reserva.]])
#pq(8, 2, 14, "c", "F-R6.1", "Bandas sin concursos: 60, 30, 17 y 12 m",
  [Según el plan de bandas HF de la IARU para la Región 1, no debe realizarse actividad de concurso en la banda de:],
  ([40 m (7 MHz)], [20 m (14 MHz)], [30 m (10 MHz)], [15 m (21 MHz)],),
  sol: [El plan HF de la Región 1 lo dice sin rodeos: la actividad de concurso no debe tener lugar en las bandas de 5, 10, 18 y 24 MHz, es decir, 60, 30, 17 y 12 m. De las cuatro opciones, solo los 30 m (10 MHz) figuran en esa lista. Las otras tres admiten concursos: en 80, 40 y 20 m el plan incluso marca tramos preferentes para concurso, en CW o en SSB. Además, recomienda a quien no concursa que use las bandas libres de concurso (30, 17 y 12 m) durante los grandes concursos internacionales. #no-esta[El plan de bandas HF de la IARU para la Región 1 (en vigor desde el 16 de octubre de 2020) establece que la actividad de concurso no debe tener lugar en las bandas de 5, 10, 18 y 24 MHz (60, 30, 17 y 12 m). También recomienda que quienes no concursan usen las bandas de 30, 17 y 12 m durante los grandes concursos internacionales. El resto de las bandas HF sí admite concursos; en 80, 40 y 20 m el plan marca incluso tramos preferentes para concurso en CW o en SSB.]])
#pq(8, 2, 15, "b", "R7.12", "Lenguaje claro: sin códigos que oculten el significado (Q y abreviaturas sí)",
  [Las comunicaciones entre estaciones de aficionado deben efectuarse:],
  ([mediante códigos cifrados si se trata de concursos], [en lenguaje claro, sin códigos que oculten su contenido], [exclusivamente en castellano], [en cualquier clave acordada entre las estaciones],),
  sol: [El lenguaje claro es una exigencia reglamentaria: no se pueden emplear códigos que oculten el sentido de la comunicación. El código Q y las abreviaturas no lo contradicen, porque son públicos y su significado está normalizado — abrevian, no cifran.])
#pq(8, 2, 16, "d", "F-R7.5", "Código SINPO: intensidad, interferencias, ruido, propagación y calidad global",
  [El código de informe #_apc2-m[SINPO], usado sobre todo por los radioescuchas, valora cada parámetro en una escala de 1 a 5. Sus cinco letras corresponden a:],
  ([únicamente la legibilidad de la señal, de 1 (ilegible) a 5 (perfectamente legible)], [potencia del transmisor, distancia, frecuencia, modulación y antena utilizada], [legibilidad, intensidad y tono de la señal], [intensidad de la señal, interferencias, ruido, perturbación de la propagación y calidad global],),
  sol: [#_apc2-m[SINPO] es un código de informe de recepción (Recomendación UIT-R SM.1135) cuyas letras son las iniciales, en inglés, de _Signal_ (intensidad de la señal), _Interference_ (interferencias), _Noise_ (ruido), _Propagation_ (perturbación de la propagación, como el desvanecimiento) y _Overall_ (calidad global). Cada una se puntúa de 1 a 5. La legibilidad, la intensidad y el tono forman el informe #_apc2-m[RST], el habitual entre radioaficionados; la legibilidad sola es la R de ese informe. #vease[(Véase tema R3, sección «Abreviaturas».)] #no-esta[El informe #_apc2-m[RST] no es el único código de calidad. #_apc2-m[SINPO] lo emplean sobre todo los radioescuchas en sus informes de recepción. Son cinco letras, cada una de 1 a 5, donde 5 es lo mejor: intensidad de la señal (S), interferencias (I), ruido (N), perturbación de la propagación (P), como el desvanecimiento, y calidad global (O). Entre radioaficionados es más habitual el informe #_apc2-m[RS] en fonía y el #_apc2-m[RST] en telegrafía.]])
#pq(8, 2, 17, "d", "R8.42", "Radiobalizas en las bandas de aficionado (p. ej., 144–146 MHz)",
  [Entre las siguientes, la banda en la que los planes de banda reservan segmentos a radiobalizas de aficionado es la de:],
  ([27–28 MHz], [88–108 MHz], [118–136 MHz], [144–146 MHz],),
  sol: [144–146 MHz es la única banda de aficionado entre las opciones; el plan de bandas de la IARU para la Región 1 reserva en ella un segmento a balizas (144,400–144,491 MHz), y existen también en 28, 50 o 432 MHz. La Orden IET/1311/2013 no enumera las bandas de las radiobalizas (arts. 24 y 25): la lista que repiten los bancos (28–29,7; 50–51; 144–146; 430–440; 1240–1300 MHz) era el art. 31.3 de la Orden ITC/1791/2006, derogada.])
#pq(8, 2, 18, "c", "F-R8.65", "Desatendida: instalarla en 6 meses (si no, caduca la autorización de instalación)",
  [Autorizada la instalación de una estación automática desatendida, la asociación de radioaficionados solicitante dispone de un plazo para finalizarla; su incumplimiento supone la caducidad de la autorización de instalación. Según el art. 26 de la Orden IET/1311/2013, ese plazo es de:],
  ([seis semanas], [tres meses], [seis meses], [dieciocho meses],),
  sol: [Art. 26, primer párrafo: autorizada la instalación, la asociación solicitante dispone de seis meses para finalizarla, y el incumplimiento supone la caducidad de la autorización de instalación. Conviene no mezclar cifras de la Orden: seis semanas es el plazo que tiene la Administración para resolver las solicitudes (art. 4); tres meses, la interrupción de emisiones de una desatendida en funcionamiento que puede abrir actuaciones de cancelación (art. 25.b); dieciocho meses, el plazo máximo inicial de una autorización experimental (art. 17.3). #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 26 de la Orden IET/1311/2013: autorizada la instalación de una estación automática desatendida, la asociación solicitante tiene seis meses para finalizarla. Si no lo hace, caduca la autorización de instalación. Terminada la instalación se aplica el procedimiento del art. 20 (comunicación a la Jefatura Provincial y expedición de la licencia de estación). Si hay interferencia perjudicial a otros servicios legalmente autorizados, se aplica el art. 32.]])
#pq(8, 2, 19, "a", "F-R8.60", "Desatendida: interrupción > 3 meses puede llevar a cancelar su licencia",
  [Según el art. 25.b de la Orden IET/1311/2013, toda interrupción de las emisiones de una estación automática desatendida por un período superior a un cierto plazo, salvo causas de fuerza mayor, puede dar lugar a la apertura de actuaciones para cancelar su licencia y otorgar la autorización a otra asociación interesada. Ese plazo es de:],
  ([tres meses], [un año], [un mes], [seis meses],),
  sol: [El art. 25.b fija en tres meses la interrupción de emisiones, salvo fuerza mayor, a partir de la cual puede abrirse el procedimiento para cancelar la licencia y, en su caso, otorgar la autorización a otra asociación interesada. Se hace para asegurar que estas estaciones funcionen el máximo tiempo posible, dado su interés técnico. No es una cancelación automática: la norma habla de apertura de actuaciones. No hay que confundirlo con los seis meses del art. 26, que son el plazo para terminar una instalación ya autorizada. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 25.b de la Orden IET/1311/2013: para asegurar que las estaciones automáticas desatendidas funcionen el máximo tiempo posible, toda interrupción de emisiones superior a tres meses, salvo causas de fuerza mayor, puede dar lugar a la apertura de actuaciones para cancelar la licencia y, en su caso, para otorgar la autorización a otra asociación interesada. Los seis meses del art. 26 son otro plazo: el que tiene la asociación para terminar una instalación ya autorizada.]])
#pq(8, 2, 20, "a", "F-R8.98", "Potencia máxima en 50, 70 y 144 MHz (600 W p.c.e.) y en 430–440 MHz (300 W p.c.e.)",
  [Según la tabla de potencias máximas del anexo I, en la banda de 430–440 MHz (70 cm) se puede emplear como máximo:],
  ([300 W p.c.e.], [600 W p.c.e.], [1000 W p.c.e.], [1000 W p.i.r.e.],),
  sol: [Para 430–440 MHz (70 cm) la tabla del apartado 3.1 del anexo I fija *300 W p.c.e.*, justo la mitad que en 2 m. Es fácil equivocarse porque las cifras vecinas se parecen: 600 W p.c.e. vale para 50, 70 y 144–146 MHz, 1000 W p.c.e. para HF (1,8 a 28 MHz) y 1000 W p.i.r.e. para 23 cm y superiores. Regla mnemotécnica: 1000, 600 y 300 W p.c.e. al pasar de HF a VHF y a 70 cm, y 1000 W p.i.r.e. desde 23 cm. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[El anexo I de la Orden IET/1311/2013 (apartado 3.1) da en una tabla la potencia máxima por banda. En HF (1,8 a 28 MHz) es de 1000 W p.c.e.; en 50, 70 y 144–146 MHz, de 600 W p.c.e.; en 430–440 MHz (70 cm), de 300 W p.c.e. Desde 23 cm (1240 MHz) el límite se expresa en otra magnitud, 1000 W p.i.r.e., y en 137 y 475 kHz es de 1 W p.i.r.e.]])
#pq(8, 2, 21, "b", "C-R8.38", "La autorización de radioaficionado la otorga la SETSI (hoy SETID)",
  [Para la utilización de estaciones de radioaficionado es imprescindible obtener la previa autorización de:],
  ([La Dirección General de Seguridad y Orden Público.], [La Secretaría de Estado de Telecomunicaciones e Infraestructuras Digitales (la SETSI de la Orden IET/1311/2013).], [El Ministerio de Defensa.], [La Marina Mercante.],),
  sol: [El uso especial del espectro por radioaficionados requiere una autorización administrativa individualizada, la autorización de radioaficionado, que otorga la SETSI (arts. 5.1 y 7.1 de la Orden IET/1311/2013): es el órgano de la Administración competente en telecomunicaciones. La Marina Mercante, Defensa y Seguridad y Orden Público no la otorgan. En el banco original la respuesta era la «Dirección General de Telecomunicaciones», nombre del órgano en el régimen anterior; hoy ese papel corresponde a la Secretaría de Estado de Telecomunicaciones (SETSI en la Orden de 2013). #vease[(Véase tema R8, sección «Autorización y licencia de estación».)]

    #no-esta[Arts. 5.1 y 7.1 de la Orden IET/1311/2013: el uso del espectro por radioaficionados exige una autorización administrativa individualizada previa, la autorización de radioaficionado, otorgada por la SETSI. La SETSI dicta resolución motivada concediéndola junto con el distintivo de llamada, o denegándola. Para obtenerla hay que superar la prueba de capacitación (art. 5.2) y presentar la solicitud con el resguardo de la tasa (art. 6). El órgano se llamaba Secretaría de Estado de Telecomunicaciones y para la Sociedad de la Información; hoy es la Secretaría de Estado de Telecomunicaciones e Infraestructuras Digitales.]])
#pq(8, 2, 22, "c", "C-R8.5", "Requisito previo de la autorización: superar la prueba de capacitación (certificado HAREC)",
  [La obtención de la autorización de radioaficionado requerirá la obtención previa de:],
  ([Un curso de formación impartido por una asociación de radioaficionados.], [Un carnet de operador expedido por un radio club.], [El certificado de examen armonizado (HAREC), que se obtiene al superar la prueba de capacitación.], [La licencia de estación fija.],),
  sol: [Según el art. 5.2 de la Orden IET/1311/2013, la autorización exige superar la prueba de capacitación; quien la supera recibe el certificado HAREC (T/R 61-02) y queda habilitado para solicitar la autorización (art. 10.3). No hay cursos obligatorios ni carnets de radio club (a, b). La licencia de estación fija (d) no es previa, sino posterior: se asocia a la autorización ya concedida (art. 18.1). El banco antiguo decía «diploma de operador»: es el antiguo nombre de este certificado. Si aparece esa redacción, es la respuesta correcta. #vease[(Véase tema R7, equivalencia entre diploma de operador y HAREC; tema R8, preguntas sobre el certificado HAREC.)]

    #no-esta[Secuencia de la Orden IET/1311/2013: prueba de capacitación (art. 10: electricidad y radioelectricidad, y normativa), certificado HAREC al aprobar ambas partes (art. 10.3), y solicitud de la autorización de radioaficionado con pago de tasa (arts. 5.2, 6 y 10.3). El HAREC no autoriza a transmitir por sí mismo: es el requisito previo. Después, si se quiere instalar una estación fija, se pide además la licencia de estación (art. 18).]])
#pq(8, 2, 23, "d", "R8.79", "La comunidad dispone de 2 meses para alegar sobre la idoneidad del emplazamiento",
  [Cuando se pretenden instalar antenas en el exterior de un inmueble en régimen de propiedad horizontal, procede:],
  ([instalarlas y notificarlo después de un año], [prescindir de todo trámite si la autorización está en vigor], [solicitar permiso al ayuntamiento únicamente], [comunicarlo previamente a la comunidad de propietarios, que dispone de dos meses para alegar],),
  sol: [La fachada y la cubierta son elementos comunes: aunque la ley reconozca el derecho a instalar antenas, su ejercicio pasa por informar a la comunidad. La comunicación la hace la Administración una vez aceptada la memoria de instalación (RD 2623/1986, art. 3); la comunidad (o su presidente, cuyo dato debe constar en la solicitud, art. 2.4) dispone de dos meses para alegar sobre la idoneidad del emplazamiento o los perjuicios y, si calla, se entiende que acepta. No autoriza ni prohíbe: la autorización es administrativa.])
#pq(8, 2, 24, "b", "F-R8.76", "Instalación provisional durante las obras: la autoriza la Administración; gastos del titular",
  [Según el Real Decreto 2623/1986, mientras las antenas permanecen desmontadas por razón de obras en el inmueble y siempre que sea posible, puede autorizarse una instalación provisional compatible con las obras. ¿Quién la autoriza y quién corre con sus gastos?],
  ([La comunidad de propietarios la autoriza y el titular de la licencia paga los gastos.], [La Administración de telecomunicaciones la autoriza y los gastos corren por cuenta del titular de la licencia.], [La Administración de telecomunicaciones la autoriza y asume ella los gastos.], [La comunidad de propietarios la autoriza y corre con los gastos, por ser quien causa el desmontaje.],),
  sol: [El art. 8 del Real Decreto 2623/1986 prevé que, mientras las antenas y elementos anejos estén desmontados por las obras y siempre que sea posible, la Administración (entonces, la Dirección General de Telecomunicaciones) pueda autorizar una instalación provisional compatible con ellas, y que sus gastos son de cuenta del titular de la licencia. La autoriza la Administración, no la comunidad, y la paga el radioaficionado: es coherente con la Ley 19/1983 (art. 2), que pone a su cargo los daños y perjuicios de la instalación, la conservación y el desmontaje. #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[Real Decreto 2623/1986, art. 8: mientras las antenas y elementos anejos deban permanecer desmontados por las obras del inmueble, y siempre que ello sea posible, la Administración puede autorizar una instalación provisional compatible con las obras. Los gastos de esa instalación provisional corren por cuenta del titular de la licencia de estación, que tampoco puede exigir indemnización por el desmontaje (art. 6.2).]])
#pq(8, 2, 25, "a", "R8.45", "Uso portable: notificar con 5 días; usos no continuados de hasta 15 días naturales sin notificación",
  [La utilización con carácter temporal de una estación en una ubicación distinta de la habitual (estación portable):],
  ([no precisa autorización, pero debe notificarse a la Jefatura Provincial con al menos cinco días de antelación; los usos no continuados de hasta 15 días naturales no precisan notificación], [está prohibida], [requiere un distintivo temporal en todo caso], [requiere superar un nuevo examen],),
  sol: [Uso portable (ubicación distinta de la habitual, art. 17): notificación a la JPIT con cinco días de antelación; los usos no continuados de hasta 15 días naturales quedan exentos.])
#pq(8, 2, 26, "b", "F-R8.71", "Noveles: potencia ≤ 40 % del máximo de la banda y nunca más de 100 W",
  [Un novel utiliza esporádicamente, con fines de divulgación y bajo supervisión, la estación colectiva de una asociación en la banda de 20 m, cuyo máximo general en la Orden IET/1311/2013 es de 1000 W p.c.e. Según el artículo 30.6.d, la potencia de sus emisiones no superará:],
  ([40 W], [100 W], [400 W], [1000 W],),
  sol: [El artículo 30.6.d impone dos topes a los noveles en estaciones colectivas: el 40 % del máximo de la banda y, en cualquier caso, 100 W (p.i.r.e.). En 20 m el máximo es 1000 W p.c.e. (Anexo I, 3.1) y el 40 % sería $0,40 times 1000 = 400$ W, pero el tope absoluto de 100 W prevalece. Los 400 W olvidan el tope; los 1000 W ignoran los dos límites; los 40 W salen de aplicar el 40 % al tope, y la norma no dice eso. #_apc3-ver[(Véase tema R8, sección «Uso de la estación y otras cuestiones».)]

#_apc3-net[Art. 30.6 de la Orden IET/1311/2013: las estaciones colectivas pueden usarse esporádicamente, con fines de divulgación, por personas noveles en demostraciones en centros de enseñanza, cursos organizados por la asociación titular y eventos similares sin ánimo de lucro y de corta duración. Condiciones: supervisión directa y presencial de un radioaficionado con al menos tres años de antigüedad; identificación con el distintivo de la colectiva seguido, tras el sufijo, de dos o tres letras libres; y potencia no superior al 40 % del máximo de la banda, con tope de 100 W (p.i.r.e.).]])
#pq(8, 2, 27, "c", "C-R8.10", "Número de desatendidas: según las necesidades del servicio (cobertura y canales)",
  [¿Cuántas estaciones automáticas desatendidas podrán autorizarse en una zona?],
  ([No existe límite para estas autorizaciones.], [Exclusivamente dos por provincia.], [Se autorizarán en función de las necesidades del servicio.], [Tres en VHF y dos en UHF.],),
  sol: [No hay un cupo fijo por provincia ni por banda. Según el art. 25.a de la Orden IET/1311/2013, el número de estaciones automáticas desatendidas se autoriza en función de la cobertura del servicio ya existente y de la disponibilidad de canales: es decir, según las necesidades del servicio. Por eso fallan las opciones con cifras fijas (b, d) y también la que dice que no hay límite (a), porque los canales disponibles sí lo limitan.

    #no-esta[El art. 25 de la Orden IET/1311/2013 fija las condiciones de las estaciones desatendidas. El criterio para autorizar su número es la cobertura preexistente y la disponibilidad de canales (25.a). Si interrumpen las emisiones más de tres meses, salvo fuerza mayor, puede abrirse un expediente para cancelar la licencia y dar la autorización a otra asociación (25.b). El acceso a los repetidores analógicos y a los digitales finales es libre (25.c).]])
#pq(8, 2, 28, "c", "R9.2", "Grave: la mera producción de interferencias",
  [La Ley General de Telecomunicaciones tipifica como infracción GRAVE:],
  ([operar en fin de semana sin licencia de estación], [el uso del alfabeto fonético español antiguo], [la mera producción de interferencias a redes o servicios autorizados], [no ser socio de una asociación de radioaficionados],),
  sol: [La mera producción de interferencias a redes o servicios autorizados es infracción grave (art. 107.6 de la Ley 11/2022); si la interferencia es deliberada, pasa a muy grave (art. 106.7). Ojo: los bancos de preguntas antiguos dan como grave la «emisión de señales de identificación falsas o engañosas» (art. 77.5 de la Ley 9/2014 y, antes, art. 54.d de la Ley 32/2003); la Ley 11/2022 no la tipifica con esas palabras. Si en el examen aparece con la opción «grave», es la que dan por buena. La identificación falsa sigue prohibida por el Reglamento de Radiocomunicaciones y por la Constitución de la UIT (art. 47).])
#pq(8, 2, 29, "d", "C-R9.1", "No es infracción comunicar con otra estación de la que se es titular",
  [Efectuar radiocomunicaciones con otra estación de la que se es titular constituye, según la legislación vigente, una infracción:],
  ([Grave], [Leve], [Muy grave], [Ninguna (no es infracción)],),
  sol: [Ninguna norma vigente prohíbe ni tipifica esa conducta: no figura en las infracciones muy graves, graves ni leves de los arts. 106 a 108 de la Ley 11/2022, que es la que tipifica las infracciones de los radioaficionados (Orden IET/1311/2013, art. 34). El servicio de aficionados es de «intercomunicación» (art. 2.1) y nada exige que las dos estaciones tengan titulares distintos. No la confundas con la infracción leve de comunicarse con estaciones #emph[no autorizadas] (art. 108.2): aquí ambas lo están. «Falta» es el término del reglamento antiguo; hoy se dice infracción. #vease[(Véase tema R9, tabla de conductas típicas y pregunta sobre la infracción leve de comunicarse con estaciones no autorizadas.)]

    #no-esta[Rige el principio de tipicidad (art. 27 de la Ley 40/2015): solo es infracción administrativa lo que una ley tipifica expresamente. En telecomunicaciones, las infracciones son las de los arts. 106 (muy graves), 107 (graves) y 108 (leves) de la Ley 11/2022, a las que remite la Orden IET/1311/2013 (art. 34). Si una conducta no figura en esas listas, como comunicar entre dos estaciones propias, no es infracción. Lo que sí es leve (art. 108.2) es establecer comunicaciones utilizando estaciones no autorizadas.]])
#pq(8, 2, 30, "c", "R9.25", "Portadora sin modular: solo para ensayos breves",
  [La emisión de una portadora sin modular por una estación de aficionado:],
  ([puede mantenerse indefinidamente si se identifica], [solo se admite en las bandas de VHF], [se admite a efectos de ensayo y durante un tiempo breve], [está prohibida en cualquier circunstancia],),
  sol: [Una portadora sin modular no transmite información y ocupa frecuencia, así que solo se admite lo justo para ajustar la antena o el acoplador — y siempre identificándose. Hoy no hay una prohibición expresa (era de la Orden de 1986, derogada): se deduce del anexo I, 4.2 y 4.3, de la Orden, que limita la potencia y la duración de las emisiones a lo estrictamente necesario y exige carga artificial en los ensayos sin radiación. Mantenerla es, de hecho, interferir.])
#fin-prueba()
#soluciones-simulacro(8)

// ======================================================================
#simulacro(9)
#prueba(9, 1)
#pq(9, 1, 1, "d", "C-T1.6", "Unidades de intensidad, tensión, resistencia y potencia (A, V, Ω, W)",
  [La unidad de potencia eléctrica es:],
  ([el amperio], [el voltio], [el decibelio], [el vatio],),
  sol: [
    La potencia eléctrica se mide en vatios (W): $P = V · I$, de modo que 1 W = 1 V × 1 A (equivale
    a un julio por segundo). El amperio es la unidad de intensidad y el voltio la de tensión. El
    decibelio no es una unidad de potencia, sino una forma logarítmica de comparar dos valores de
    una misma magnitud (solo con una referencia, dBW o dBm, expresa una potencia). #vease[(Véase
    tema T1, secciones «Unidades y leyes fundamentales» y «Potencia, decibelios y DSP».)]
    #no-esta[La potencia es la energía entregada o consumida por unidad de tiempo. Su unidad es el vatio (W):
    1 W = 1 julio por segundo = 1 voltio × 1 amperio. Múltiplos de uso corriente: el milivatio (mW,
    $10^(−3)$ W) y el kilovatio (kW, $10^3$ W). Resumen de unidades básicas: corriente, amperio (A);
    tensión, voltio (V); resistencia, ohmio (Ω); potencia, vatio (W); frecuencia, hercio (Hz).]
  ])
#pq(9, 1, 2, "b", "F-T1.56", "Fuente real: V = ε − I r y corriente de cortocircuito ε / r",
  [Una batería de 12 V de fuerza electromotriz y 0,5 Ω de resistencia interna entrega 4 A a una carga. La tensión en sus terminales es de:],
  ([8 V], [10 V], [12 V], [14 V],),
  sol: [La resistencia interna provoca una caída $I r = 4 times 0,5 = 2$ V dentro de la propia batería, y en los terminales queda $V = epsilon - I r = 12 - 2 = 10$ V. Los 12 V solo se miden en circuito abierto. Los 14 V suman la caída en lugar de restarla. Los 8 V restan $I = 4$ V olvidando multiplicar por $r$. _(Véase tema T1, sección «Fuentes y energía».)_])
#pq(9, 1, 3, "a", "", "Onda electromagnética: campos E y B perpendiculares entre sí y a la propagación",
  [En una onda electromagnética, el campo eléctrico y el campo magnético son:],
  ([perpendiculares entre sí y perpendiculares a la dirección de propagación], [perpendiculares entre sí y paralelos a la dirección de propagación], [paralelos entre sí y a la dirección de propagación], [paralelos entre sí y perpendiculares a la dirección de propagación],),
  sol: [Los dos campos oscilan en fase, son perpendiculares entre sí y los dos son perpendiculares a la dirección en que avanza la onda. Ninguno apunta en la dirección de propagación. La polarización la da la dirección del campo eléctrico.])
#pq(9, 1, 4, "a", "F-T1.45", "Filtros antisolapamiento (paso bajo antes del A/D) y de reconstrucción (paso bajo tras el D/A)",
  [El filtro antisolapamiento (anti-aliasing) de un sistema de procesado digital de señales se coloca:],
  ([antes del conversor A/D, y es un filtro paso bajo], [después del conversor D/A, y es un filtro paso bajo], [antes del conversor A/D, y es un filtro paso alto], [después del conversor A/D, y es un filtro paso bajo],),
  sol: [Lo que supere $f_s slash 2$ se plegaría sobre la banda útil al muestrear (_aliasing_) y, ya digitalizado, no se puede separar. Hay que eliminarlo antes del muestreo: el filtro antisolapamiento va delante del A/D y es paso bajo, con corte en torno a $f_s slash 2$. Un paso alto dejaría justo lo que hay que quitar. El filtro situado tras el D/A es el de reconstrucción: también paso bajo, pero elimina las réplicas del espectro y suaviza los escalones de la señal de salida. Es otro filtro, con otra función. _(Véase tema T1, sección «Potencia, decibelios y DSP».)_
#_apc1-noest[En un sistema con DSP hay dos filtros paso bajo. El antisolapamiento va justo antes del conversor A/D: elimina lo que supera $f_s slash 2$, que al muestrear se confundiría con frecuencias bajas y no podría separarse después. El de reconstrucción va tras el conversor D/A: suaviza los escalones de la señal reconstruida y elimina las réplicas del espectro por encima de $f_s slash 2$. Ambos cortan en torno a $f_s slash 2$.]])
#pq(9, 1, 5, "b", "F-T2.8", "Efecto pelicular: en RF la corriente va por la superficie y la resistencia efectiva aumenta",
  [El efecto pelicular hace que, en radiofrecuencia, la corriente alterna circule:],
  ([uniformemente por toda la sección del conductor], [principalmente por la superficie del conductor], [principalmente por el centro del conductor, dejando libre la superficie], [alternativamente por el centro y por la superficie, según el semiciclo],),
  sol: [El efecto pelicular (_skin effect_) confina la corriente alterna en una corteza superficial del conductor, cuyo espesor disminuye como $1 slash sqrt(f)$: a 10 MHz es de unas decenas de micras. El interior apenas conduce, por eso un tubo hueco sirve casi igual que una barra maciza y se platea el hilo de las bobinas de RF. La a describe la corriente continua; la c es justo lo contrario del efecto; la d no corresponde a ningún fenómeno real. _(Véase tema T2, sección «Bobinas».)_])
#pq(9, 1, 6, "b", "C-T2.2", "Relación de transformación: cociente de tensiones o de espiras",
  [Una relación de transformación de un transformador es el cociente que resulta de dividir:],
  ([La tensión en el secundario por la intensidad de corriente en el primario.], [La tensión en el secundario por la tensión en el primario.], [El peso de la bobina del primario por el peso de la bobina del secundario.], [La potencia eléctrica que se obtiene en el secundario por la que absorbe el primario.],),
  sol: [
    Aquí la relación de transformación es el cociente de tensiones $V_s slash V_p$, que en el
    transformador ideal coincide con $N_s slash N_p$. La opción a divide una tensión entre una
    corriente: $V slash I$ es una impedancia, no una relación entre devanados. El peso de las
    bobinas (c) no interviene en ninguna ley del transformador. La opción d es el rendimiento
    (potencia de salida entre potencia de entrada), que vale 1 en el caso ideal y algo menos en uno
    real. #vease[(Véase tema T2, sección «Transformadores».)]
    #no-esta[La «relación de transformación» se define con dos convenciones inversas y conviene conocer
    ambas. Como cociente de tensiones (la de esta pregunta) es $V_s slash V_p = N_s slash N_p$:
    mayor que 1 en un elevador, menor que 1 en un reductor. Otros textos la dan al revés, como
    espiras del primario entre espiras del secundario, $N_p slash N_s$, que es la que usa la
    pregunta T2.18 del cuaderno. En el examen fíjate en lo que ofrecen las opciones: nunca será un
    cociente de potencias ni de pesos.]
  ])
#pq(9, 1, 7, "b", "C-T2.11", "Ventaja del FET: impedancia de entrada muy alta",
  [¿Qué ventaja tienen los transistores FET sobre los transistores clásicos?],
  ([Se pueden usar para señales de frecuencias más altas], [Tiene mayor impedancia de entrada], [Pueden amplificar señales a mayor nivel], [Producen mayor ganancia],),
  sol: [
    El FET se gobierna con la tensión de puerta (campo eléctrico) y la puerta apenas toma corriente:
    su impedancia de entrada es altísima, mientras que un bipolar necesita corriente de base y
    presenta una entrada de baja impedancia. Esa es su ventaja característica (b): no carga la
    fuente de señal, y por eso se usa en las primeras etapas de los receptores. Las otras no son
    ventajas generales: el FET no suele dar más ganancia que un bipolar, no maneja señales de mayor
    nivel, y la frecuencia máxima depende del modelo concreto, no de que sea FET o bipolar.
    #vease[(Véase tema T2, sección «Semiconductores y otros componentes», y capítulo «La radio por
    dentro», apartado «Las otras vidas del transistor».)]
  ])
#pq(9, 1, 8, "c", "T2.28", "Emisión termoiónica: el cátodo caliente emite y la válvula conduce solo con la placa positiva",
  [Una válvula conduce corriente:],
  ([únicamente con corriente alterna aplicada a la rejilla], [con cualquier polaridad, siempre que el filamento esté frío], [si se aplica una tensión positiva a la placa y negativa al cátodo], [si se aplica una tensión negativa a la placa y positiva al cátodo],),
  sol: [Los electrones que el cátodo caliente emite son negativos, así que solo cruzan el vacío si la placa está a potencial positivo respecto a él. Con la polaridad invertida no hay corriente, porque la placa está fría y no emite: en eso consiste el efecto rectificador de la válvula.])
#pq(9, 1, 9, "c", "", "Resonancia serie (Z mínima) frente a paralelo o tanque (Z máxima); LC serie en derivación = trampa",
  [En su frecuencia de resonancia, un circuito LC paralelo («tanque») presenta:],
  ([una impedancia mínima, igual a la resistencia de pérdidas], [una impedancia nula, como un cortocircuito], [una impedancia máxima, y la corriente que toma de la línea es mínima], [una reactancia puramente inductiva],),
  sol: [En el tanque, las corrientes de la bobina y del condensador son iguales y opuestas en $f_0$: circulan dentro del circuito y se cancelan a la entrada, de modo que de fuera entra muy poca corriente y la impedancia es máxima (y puramente resistiva). La impedancia mínima, igual a la resistencia de pérdidas, es la del circuito resonante serie: es la confusión típica.])
#pq(9, 1, 10, "a", "F-T3.4", "Filtro digital (DSP): opera con muestras numéricas; cadena A/D → cálculo en el DSP → D/A",
  [Un filtro digital, realizado con un procesador digital de señal (DSP), se caracteriza porque:],
  ([opera con muestras numéricas de la señal y obtiene la salida mediante cálculos matemáticos], [solo puede trabajar con señales de corriente continua], [aprovecha la resonancia piezoeléctrica de un cristal de cuarzo], [está formado por bobinas y condensadores de alta precisión],),
  sol: [En un filtro digital la señal se muestrea y cada muestra es un número. El DSP calcula la salida combinando muestras de entrada (y, en los IIR, también de salida) con unos coeficientes que fijan la respuesta del filtro. Los filtros de bobinas y condensadores o de cristal de cuarzo son analógicos. Y un filtro digital no se limita a la continua: procesa señales de audio o de FI, siempre que el muestreo sea suficiente. _(Véase tema T3, sección «Filtros, osciladores y mezcladores», y tema T1, sección «Potencia, decibelios y DSP».)_])
#pq(9, 1, 11, "d", "F-T3.7", "Frecuencia del rizado: 100 Hz en onda completa y 50 Hz en media onda (red de 50 Hz)",
  [Un rectificador de onda completa, por ejemplo un puente de diodos, se alimenta de la red de 50 Hz. La frecuencia del rizado a su salida es de:],
  ([25 Hz], [200 Hz], [50 Hz], [100 Hz],),
  sol: [Con onda completa se aprovechan los dos semiciclos de la red: hay dos crestas por ciclo, luego el rizado se repite $2 dot 50 = 100$ veces por segundo, es decir, 100 Hz. Los 50 Hz serían el rizado de un rectificador de media onda, con una sola cresta por ciclo. 25 Hz y 200 Hz no los produce ningún rectificador conectado a una red de 50 Hz. La frecuencia doble facilita el filtrado con el mismo condensador. _(Véase tema T3, sección «Fuentes de alimentación y amplificadores».)_])
#pq(9, 1, 12, "a", "T3.12", "El detector de envolvente es asíncrono: no necesita sincronización con el transmisor",
  [Los detectores de envolvente (por ejemplo, un diodo seguido de un filtro) tienen la particularidad de:],
  ([no requerir en el receptor sincronización con el transmisor, por ser asíncronos], [funcionar únicamente con señales de FM], [requerir sincronización exacta con el transmisor], [necesitar alimentación de alta tensión],),
  sol: [El detector de envolvente (un diodo y un filtro $R C$) sigue la envolvente de la señal sin necesitar ninguna referencia del transmisor: es asíncrono. Los detectores síncronos requieren reconstruir la portadora.])
#pq(9, 1, 13, "c", "", "Condición de oscilación (Barkhausen): realimentación positiva, ganancia de lazo que compensa pérdidas y fase de 360°",
  [Para que un amplificador realimentado se convierta en oscilador, la realimentación debe ser:],
  ([nula, porque el oscilador no necesita realimentación], [positiva, pero con una ganancia de lazo muy inferior a la unidad], [positiva, con una ganancia de lazo que compense las pérdidas y una fase total de 360°], [negativa, para estabilizar la ganancia],),
  sol: [Un oscilador es un amplificador que se realimenta a sí mismo: lo devuelto debe llegar en fase (360° en la vuelta completa) y con amplitud suficiente para compensar las pérdidas (condición de Barkhausen). Con ganancia de lazo menor que 1 las oscilaciones se extinguen, y la realimentación negativa estabiliza el amplificador en lugar de hacerlo oscilar.])
#pq(9, 1, 14, "b", "C-T4.12", "Doble conversión: dos FI; la 1.ª alta (aleja la imagen) y la 2.ª baja (selectividad)",
  [En los receptores de doble conversión:],
  ([La primera frecuencia intermedia es menor que la segunda], [La primera frecuencia intermedia es mayor que la segunda], [La segunda frecuencia intermedia es el doble que la primera], [La segunda frecuencia intermedia es la mitad de la primera],),
  sol: [
    En la doble conversión la primera FI es alta (por ejemplo, 45 o 70 MHz) y la segunda, baja (por
    ejemplo, 455 kHz). Una primera FI alta aleja la frecuencia imagen, que está a $2f_("FI")$ de la
    señal, y el filtro preselector la elimina con facilidad; una segunda FI baja permite filtros muy
    estrechos y, por tanto, selectivos. Por eso la primera es mayor que la segunda, y la a está al
    revés. No hay una relación fija del doble o de la mitad: c y d son falsas, pues las FI
    habituales se diferencian en un factor de veinte o mucho más. #vease[(Véase tema T4, sección
    «Arquitectura del receptor».)]
  ])
#pq(9, 1, 15, "d", "F-T4.8", "Intermodulación de tercer orden: productos en 2f1 − f2 y 2f2 − f1, dentro de banda",
  [Dos señales de 7,050 MHz y 7,060 MHz llegan a una etapa no lineal de un receptor. Los productos de intermodulación de tercer orden que caen junto a ellas, dentro de la banda, aparecen en:],
  ([0,010 MHz y 14,110 MHz], [7,020 MHz y 7,090 MHz], [7,030 MHz y 7,080 MHz], [7,040 MHz y 7,070 MHz],),
  sol: [Los productos de tercer orden en banda son $2 f_1 - f_2$ y $2 f_2 - f_1$: $2 times 7,050 - 7,060 = 7,040$ MHz y $2 times 7,060 - 7,050 = 7,070$ MHz. Caen a 10 kHz por fuera de cada señal, dentro de la banda, y por eso no se pueden eliminar con un filtro. La diferencia y la suma (0,010 y 14,110 MHz) son productos de segundo orden; 7,030 y 7,080 MHz ($3 f_1 - 2 f_2$ y $3 f_2 - 2 f_1$) son de quinto orden, y 7,020 y 7,090 MHz, de séptimo: estos suelen ser más débiles. #vease[(Véase tema T9, sección «Causas de interferencia».)]])
#pq(9, 1, 16, "d", "T4.7", "CAG: mantiene constante la salida; lazo desde el detector hacia RF y FI",
  [El control automático de ganancia (CAG) de un receptor tiene como objetivo:],
  ([suprimir los ruidos impulsivos], [aumentar la selectividad del receptor], [silenciar el altavoz en ausencia de señal], [mantener constante la amplitud de la señal de salida],),
  sol: [El CAG ajusta la ganancia según la señal recibida para que la salida se mantenga constante aunque la señal fluctúe (fading).])
#pq(9, 1, 17, "a", "T5.3", "Índice de modulación de FM: m = Δf / f_m",
  [En un transmisor de FM con una desviación máxima de frecuencia de 25 kHz y una frecuencia moduladora de 10 kHz, el índice de modulación vale:],
  ([2,5], [0,4], [250], [35],),
  sol: [$m = Delta f slash f_m = 25 slash 10 = 2,5$, adimensional.])
#pq(9, 1, 18, "d", "F-T5.4", "Radiación por la estructura: RF que escapa por chasis y cables; se reduce apantallando y filtrando",
  [Se denomina radiación por la estructura de un transmisor a:],
  ([los armónicos y espurios que se radian por la antena], [el campo magnético que produce el transformador de la fuente de alimentación], [la potencia que se pierde en forma de calor en el amplificador final], [la radiofrecuencia que escapa por el chasis y los cables del equipo sin pasar por la antena],),
  sol: [La radiación por la estructura es la radiofrecuencia que sale del equipo sin pasar por la antena: el chasis mal apantallado y los cables de alimentación, micrófono o manipulador actúan como antenas involuntarias. No es lo mismo que los armónicos y espurios radiados por la antena (a), que son emisiones no esenciales y salen por la línea de transmisión. Tampoco es el campo del transformador (b) ni el calor del amplificador final (c), que solo resta rendimiento. #vease[(Véase tema T5, sección «Emisiones no deseadas».)]])
#pq(9, 1, 19, "d", "T6.2", "Resonancia: impedancia de alimentación resistiva pura (antena sintonizada a la frecuencia de la señal; equivale a una resistencia pura)",
  [Una antena está en resonancia cuando:],
  ([su longitud es exactamente un múltiplo de la longitud de onda], [su ganancia es máxima en todas las direcciones], [radia por igual en el plano vertical y en el horizontal], [la impedancia en su punto de alimentación es resistiva pura],),
  sol: [En resonancia la reactancia del punto de alimentación se anula: impedancia resistiva pura (la figura del libro).])
#pq(9, 1, 20, "c", "T6.7", "Dipolo con trampas: circuitos LC paralelo en los brazos que permiten trabajar en varias bandas",
  [En un dipolo con trampas, las trampas son:],
  ([resistencias de carga], [contrapesos mecánicos], [circuitos resonantes que permiten trabajar en varias bandas], [condensadores de paso],),
  sol: [Las trampas son circuitos resonantes LC que aíslan el tramo exterior del brazo a su frecuencia: la antena resuena en varias bandas.])
#pq(9, 1, 21, "c", "C-T6.13", "El diagrama de radiación representa la distribución de la energía radiada en el espacio",
  [El diagrama de radiación de una antena nos da:],
  ([La banda de frecuencias que puede radiar en las distintas direcciones], [El alcance de la radiación en función de la dirección], [La distribución de la energía radiada en el espacio], [La distribución de su adaptación en el espacio],),
  sol: [
    El diagrama de radiación es la representación gráfica de cómo se reparte en el espacio la
    energía que radia la antena: muestra la intensidad relativa en cada dirección (lóbulo principal,
    lóbulos secundarios y nulos). Es una propiedad de la dirección, no de la banda de frecuencias
    (a) ni de la adaptación (d), que depende de la impedancia. El alcance (b) depende además de la
    potencia, de la propagación y del receptor; el diagrama solo lo condiciona de forma indirecta.
    #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]
    #no-esta[Diagrama de radiación: gráfica, polar o en tres dimensiones, de la intensidad radiada en cada
    dirección respecto de la antena. El lóbulo principal indica hacia dónde radia más; de él se leen
    el ancho de haz, la relación adelante-atrás y los nulos.]
  ])
#pq(9, 1, 22, "c", "F-T6.13", "Las pérdidas del coaxial (dB) crecen con la frecuencia y con la longitud",
  [Las pérdidas de un cable coaxial, expresadas en decibelios:],
  ([disminuyen al aumentar la frecuencia y aumentan con la longitud], [aumentan con la frecuencia, pero no dependen de la longitud], [aumentan con la frecuencia y con la longitud], [no dependen de la frecuencia, solo de la potencia aplicada],),
  sol: [La atenuación se da en dB por unidad de longitud: es proporcional a la longitud (el doble de cable, el doble de dB) y crece con la frecuencia, por las pérdidas en los conductores y en el dieléctrico. Por eso un mismo coaxial apenas importa en HF y pesa mucho en VHF y UHF. No disminuyen con la frecuencia, no son independientes de la longitud y, en dB, no dependen de la potencia aplicada. #no-esta[Todo cable real atenúa la señal, y la atenuación se da en decibelios por unidad de longitud. Es proporcional a la longitud (si 10 m pierden 1 dB, 30 m pierden 3 dB, o sea, la mitad de la potencia) y crece con la frecuencia: un coaxial que apenas importa en HF puede comerse media potencia en VHF o UHF. A igual frecuencia, el cable grueso pierde menos que el fino, y la línea paralela («de escalera») es la de menores pérdidas.]])
#pq(9, 1, 23, "a", "T7.22", "Orden de las capas de la atmósfera: troposfera, estratosfera e ionosfera",
  [Ordenadas de menor a mayor altura, las capas de la atmósfera son:],
  ([troposfera, estratosfera e ionosfera], [troposfera, ionosfera y estratosfera], [estratosfera, troposfera e ionosfera], [ionosfera, troposfera y estratosfera],),
  sol: [De abajo arriba: troposfera (donde está el tiempo atmosférico y ocurre la propagación troposférica), estratosfera y, por encima, la ionosfera, que es la que refleja las ondas de HF.])
#pq(9, 1, 24, "d", "F-T7.10", "Ciclo solar: más manchas → más ionización, MUF más alta y bandas altas abiertas",
  [Cuando aumenta la actividad solar (más manchas solares), la MUF suele:],
  ([subir, pero solo beneficia a las bandas bajas de 160 y 80 m], [bajar, porque el exceso de ionización deja de reflejar las ondas de HF], [permanecer igual, pues solo depende de la hora del día], [subir, y bandas altas como la de 28 MHz se abren al DX con más frecuencia],),
  sol: [Más manchas solares significan más radiación ultravioleta y X, luego más electrones libres y una frecuencia de plasma más alta ($f_p approx 9 sqrt(N_e)$). Con ello sube la MUF y la ionosfera refleja frecuencias mayores: en los máximos del ciclo de once años se abren con frecuencia 15, 12 y 10 m. No baja (más ionización no impide reflejar), no es independiente del Sol y no favorece a las bandas bajas, que dependen sobre todo de la absorción de la capa D y de la noche. #vease[(Véase tema T7, sección «Cómo se nombran las bandas» (párrafo final sobre la predicción de propagación).)]])
#pq(9, 1, 25, "c", "T7.6", "Frecuencia crítica: la máxima que se refleja en incidencia vertical",
  [Se llama frecuencia crítica a la frecuencia:],
  ([máxima que puede generar el transmisor], [mínima que atraviesa la capa D], [por encima de la cual, en incidencia vertical, no hay reflexión en la ionosfera], [de resonancia de la antena receptora],),
  sol: [La frecuencia crítica es la máxima que, en incidencia vertical, aún se refleja; por encima, la onda atraviesa la ionosfera.])
#pq(9, 1, 26, "b", "F-T8.7", "Error de carga del voltímetro en un divisor de tensión",
  [Un divisor de tensión formado por dos resistencias de 10 kΩ se alimenta con 12 V. Si se mide la tensión de una de ellas con un voltímetro de 10 kΩ de resistencia interna, la lectura será de:],
  ([6 V], [4 V], [3 V], [8 V],),
  sol: [Sin voltímetro, cada resistencia tendría 6 V. El voltímetro se conecta en paralelo: 10 kΩ $parallel$ 10 kΩ = 5 kΩ, así que el total es 15 kΩ y la tensión en esa parte vale 12 × 5/15 = 4 V. Es el error de carga: el instrumento deriva corriente y falsea la medida, por eso un voltímetro debe tener resistencia interna mucho mayor que la del circuito. Los 6 V (a) serían la lectura de un voltímetro ideal; 8 V (d) es la tensión de la otra resistencia. #vease[(Véase tema T8, sección «Técnica de medida».)]])
#pq(9, 1, 27, "b", "F-T8.10", "Potencia en la cresta de la envolvente a partir de la tensión de pico sobre la carga",
  [Con un osciloscopio se mide, en el máximo de la envolvente de una señal de SSB, una tensión de pico de 100 V sobre una carga artificial de 50 Ω. La potencia en la cresta de la envolvente (p.c.e.) es de:],
  ([200 W], [100 W], [141 W], [50 W],),
  sol: [La p.c.e. es la potencia media de un ciclo de RF en el máximo de la envolvente. Con tensión de pico $V_"p" = 100$ V, la eficaz es $V_"p" slash sqrt(2) = 70,7$ V y $P = V_"ef"^2 slash R = 70,7^2 slash 50 = 100$ W; equivale a $V_"p"^2 slash (2 R) = 10 thin 000 slash 100$. Los 200 W (a) resultan de usar el pico como si fuera eficaz ($V_"p"^2 slash R$), los 141 W (c) de mezclar pico y eficaz ($V_"p" dot I_"ef"$) y los 50 W (d) de dividir entre 2 dos veces. #vease[(Véase tema T8, sección «Técnica de medida».)] #no-esta[Para medir la p.c.e. con un osciloscopio se conecta el transmisor a una carga artificial de resistencia $R$ y se lee la tensión de pico $V_"p"$ en el máximo de la envolvente. Como la tensión eficaz de ese ciclo es $V_"p" slash sqrt(2)$, la p.c.e. vale $V_"p"^2 slash (2 R)$. Con la lectura de pico a pico, $V_"pp"^2 slash (8 R)$. Sobre 50 Ω, 100 V de pico son 100 W.]])
#pq(9, 1, 28, "a", "T9.15", "Desacoplo: ferritas y condensadores en los cables del equipo afectado",
  [Para evitar que la radiofrecuencia de una estación se cuele en un amplificador de audio cercano, resulta eficaz:],
  ([colocar núcleos de ferrita y condensadores de desacoplo en sus cables], [aumentar el volumen del amplificador], [alargar los cables de altavoz], [desconectar la toma de tierra del amplificador],),
  sol: [Los cables de altavoz y de red hacen de antena y llevan la RF hasta donde se detecta y se oye. La ferrita añade impedancia a esa corriente parásita y el condensador la deriva a masa, sin afectar al audio. Alargar los cables o quitar la tierra empeora las cosas.])
#pq(9, 1, 29, "c", "T10.18", "Si no se puede cortar: separar a la víctima con un elemento aislante, nunca tocarla directamente",
  [Si la víctima de una descarga no puede desprenderse de la instalación y no es posible cortar la corriente de inmediato, la persona más próxima debe:],
  ([esperar a que llegue el servicio de emergencias sin actuar], [agarrarla de las manos y tirar con fuerza], [separarla empleando un elemento aislante, sin tocarla directamente], [echarle agua para enfriar la zona del contacto],),
  sol: [Una pértiga de madera seca, un mango aislante, una prenda seca: cualquier cosa que impida que la corriente pase también por el que auxilia. Tocarla directamente, o mojar la escena, es multiplicar el accidente.])
#pq(9, 1, 30, "d", "T10.8", "Fusible: en serie, corta las sobreintensidades",
  [Un fusible protege un circuito frente a:],
  ([las descargas atmosféricas sobre la antena], [los contactos indirectos de las personas], [las variaciones de frecuencia de la red], [las sobreintensidades, fundiéndose antes de que se dañe el equipo],),
  sol: [Es un hilo calibrado en serie con el circuito: cuando la corriente supera cierto valor, se funde y abre el paso. Se sacrifica él para que no se queme lo que hay detrás. De las personas se ocupa el diferencial.])
#fin-prueba()
#prueba(9, 2)
#pq(9, 2, 1, "c", "R2.32", "QRT cese la transmisión frente a QRX espere, volveré a llamar",
  [Para pedir a la estación corresponsal que cese la transmisión se emplea el grupo:],
  ([`QRX`], [`QRV`], [`QRT`], [`QSK`],),
  sol: [`QRT` es cesar la transmisión. `QRX` es esperar y volver a llamar, que es distinto: uno cierra, el otro aplaza.])
#pq(9, 2, 2, "a", "R2.13", "QSB desvanecimiento (fading)",
  [El grupo `QSB` indica que la señal tiene:],
  ([desvanecimiento (_fading_)], [exceso de potencia], [interferencias de otras estaciones], [distorsión de audio],),
  sol: [`QSB`: desvanecimiento o _fading_ de la señal.])
#pq(9, 2, 3, "d", "F-R2.2", "QRY ¿cuál es mi turno?",
  [El grupo #_apc2-m[QRY], como pregunta, equivale a:],
  ([¿está ocupada la frecuencia?], [¿a qué distancia nos encontramos?], [¿cuál es mi frecuencia exacta?], [¿cuál es mi turno en el orden de comunicación?],),
  sol: [#_apc2-m[QRY?] significa «¿cuál es mi turno (en el orden de comunicación)?»; la respuesta es «su turno es el número…». No habla de frecuencias ni de distancias, sino de quién comunica antes. Los distractores son otros grupos de las tablas: #_apc2-m[QRG] (frecuencia exacta), #_apc2-m[QRL] (frecuencia ocupada) y #_apc2-m[QRB] (distancia entre estaciones). Mnemotecnia: #_apc2-m[QRY] es «¿cuándo me toca?». #no-esta[Las tablas no recogen todos los grupos Q de la lista internacional (Recomendación UIT-R M.1172). Uno de los que faltan es #_apc2-m[QRY]: «¿cuál es mi turno (en el orden de comunicación)?». Se contesta «su turno es el número…», con la cifra que corresponda. Sirve para saber en qué orden le toca a uno comunicar.]])
#pq(9, 2, 4, "b", "R3.1", "CQ llamada general a todas las estaciones",
  [La abreviatura `CQ` significa:],
  ([confirme la recepción], [llamada general a todas las estaciones], [cambio de frecuencia], [cierre de la estación],),
  sol: [`CQ`: llamada general a cualquier estación que escuche.])
#pq(9, 2, 5, "c", "R3.5", "USB banda lateral superior / LSB inferior",
  [La abreviatura `USB` corresponde a:],
  ([una emisión de urgencia submarina], [la banda lateral inferior], [la banda lateral superior], [la doble banda lateral],),
  sol: [`USB`: banda lateral superior; `LSB`, la inferior. Convenio en HF: LSB por debajo de 10 MHz, USB por encima.])
#pq(9, 2, 6, "d", "R3.36", "HI risa en telegrafía",
  [La abreviatura `HI` se emplea en telegrafía para expresar:],
  ([alta frecuencia], [un saludo inicial], [una petición de repetición], [una risa],),
  sol: [Es la forma de reírse en telegrafía: se transmite tal cual y el corresponsal lo entiende como una risa. Un rasgo de la vieja cultura telegráfica que ha sobrevivido intacto.])
#pq(9, 2, 7, "a", "R4.2", "Urgencia en radiotelefonía: PAN PAN (tres veces)",
  [La señal de urgencia en radiotelefonía consiste en la transmisión, repetida tres veces, de:],
  ([Pan Pan], [SOS], [Sécurité], [Mayday],),
  sol: [#_r4-sc("Pan Pan") tres veces: urgencia, sin peligro inmediato de vidas.])
#pq(9, 2, 8, "c", "F-R4.2", "Colaboración obligatoria en catástrofes a requerimiento de la DG de Protección Civil y Emergencias (art. 30.4)",
  [Según la Orden IET/1311/2013, todo titular de una autorización de radioaficionado está obligado a colaborar con sus medios radioeléctricos en caso de catástrofe cuando se lo requiera:],
  ([la Unión de Radioaficionados Españoles], [la Jefatura Provincial de Inspección de Telecomunicaciones], [la Dirección General de Protección Civil y Emergencias, del Ministerio del Interior], [el ayuntamiento de su localidad],),
  sol: [El art. 30.4 de la Orden obliga a todo titular de una autorización a colaborar, a requerimiento de la Dirección General de Protección Civil y Emergencias, del Ministerio del Interior, con sus medios radioeléctricos y en las bandas atribuidas al servicio de radioaficionados, para atender las comunicaciones de socorro y seguridad en caso de catástrofes. Ni la Unión de Radioaficionados Españoles ni el ayuntamiento figuran en ese artículo, y la Jefatura Provincial de Inspección de Telecomunicaciones es la ventanilla de trámites (art. 17.1, por ejemplo), no quien requiere la colaboración. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]])
#pq(9, 2, 9, "b", "F-R4.9", "Segmento de satélites en 70 cm: 435–438 MHz",
  [En la banda de 70 cm, el segmento que el plan de bandas de la IARU para la Región 1 dedica al servicio de satélite es:],
  ([430 a 432 MHz], [435 a 438 MHz], [438 a 440 MHz], [433 a 435 MHz],),
  sol: [El plan de la IARU para la Región 1 reserva al servicio de satélite 435–438 MHz (435–436 y 436– 438 MHz), y la nota 5.282 del Reglamento de Radiocomunicaciones, recogida en el CNAF, admite ahí el servicio de aficionados por satélite. 430–432 MHz es de uso mixto y repetidores. 433–435 MHz incluye la banda ICM 433,050–434,790 MHz (Anexo I, 3.4, de la Orden) y segmentos de repetidores. 438–440 MHz es de «todos los modos» y salidas de repetidores. #vease[(Véase tema R6, introducción del capítulo (reparto de cada banda en segmentos por modos, frecuencias de llamada).)] #no-esta[El plan de bandas de la IARU para la Región 1 reserva al servicio de satélite: en 2 m, 145,806– 146,000 MHz (exclusivo); en 70 cm, 435–438 MHz; y en 23 cm, 1260–1270 MHz. El Reglamento de Radiocomunicaciones (nota 5.282) admite el servicio de aficionados por satélite en 435–438, 1260–1270 y 2400–2450 MHz, entre otras bandas.]])
#pq(9, 2, 10, "b", "C-R5.9", "Identificación de móviles y portables: /M, /MM, /MA, /P en grafía; palabras («portable») en fonía; no existe /AM",
  [¿Cuándo se añade la mención /P al distintivo de llamada?],
  ([Cuando se opera una estación Fija/Portable], [Cuando se opera en grafía una estación Fija/Portable], [Cuando se opera en fonía una estación Fija/Portable], [Cuando se realizan ensayos o concursos],),
  sol: [La identificación de las estaciones móviles y portables es opcional (art. 29.2 de la Orden IET/1311/2013) y depende del modo: en telegrafía se añaden las abreviaturas /M, /MM, /MA o /P; en fonía se dicen las palabras móvil, móvil marítima, móvil aeronáutica o portable. Por eso /P se añade al operar en grafía una estación portable. La c describe la palabra «portable», no la abreviatura; la a no distingue el modo; y los ensayos y concursos no se marcan con /P, sino con prefijos de uso temporal (art. 27).

    #no-esta[Art. 29.2 de la Orden IET/1311/2013: las estaciones móviles y portables pueden completar su distintivo, de forma opcional, con /M (móvil), /MM (móvil marítima), /MA (móvil aeronáutica) o /P (portable) en telegrafía, o con las palabras correspondientes en fonía. También opcionalmente puede añadirse el número del distrito desde el que se emite, si no coincide con el del distintivo. Regla: abreviatura, grafía; palabra, fonía.]])
#pq(9, 2, 11, "d", "R5.24", "La cifra es la del distrito de residencia del titular al otorgar la autorización",
  [La cifra de distrito que compone el distintivo de llamada de un radioaficionado es:],
  ([la del lugar donde se realizó el examen], [la cifra que estuviera disponible al expedir la autorización], [un número elegido libremente por el titular], [la coincidente con el distrito de residencia del titular],),
  sol: [La cifra de distrito es la del distrito de residencia del titular _en el momento del otorgamiento_ de la autorización (art. 27.2), según la división geográfica reglamentaria.])
#pq(9, 2, 12, "a", "F-R5.1", "Res. 29-07-2026: la práctica para el sufijo de una letra se acredita con 2 QSL por año en 15 de los últimos 20",
  [Según la Resolución de 29 de julio de 2026 de la Secretaría de Estado de Telecomunicaciones e Infraestructuras Digitales, la práctica internacional exigida para obtener un distintivo con sufijo de una letra se acredita con:],
  ([dos #_apc2-m[QSL] por año durante quince de los últimos veinte años], [una #_apc2-m[QSL] por año durante quince años seguidos], [tres #_apc2-m[QSL] por año durante los últimos cinco años], [dos #_apc2-m[QSL] por año durante diez de los últimos quince años],),
  sol: [El apartado segundo de la Resolución (BOE-A-2026-17504, en vigor desde el 19-09-2026) desarrolla el art. 27 de la Orden, que pide quince años de práctica internacional: se acreditan con dos tarjetas #_apc2-m[QSL] por cada año, durante quince de los últimos veinte, incluido el año de la solicitud. «Una por año» y «diez de quince» rebajan la exigencia. «Cinco años» recuerda la antigüedad mínima de la autorización, que es otro requisito distinto de la práctica internacional. #vease[(Véase tema R5, sección «Sufijos y usos temporales».)]])
#pq(9, 2, 13, "b", "F-R5.3", "Res. 29-07-2026: asignación por distritos y orden de presentación, hasta 10 preferencias; el nuevo distintivo sustituye al anterior",
  [En el procedimiento ordinario para asignar distintivos con sufijo de una letra, establecido por la Resolución de 29 de julio de 2026, la asignación se hace:],
  ([por sorteo público anual entre los solicitantes, y el nuevo distintivo se suma al anterior del titular], [por distritos y por estricto orden de presentación de las solicitudes, y el nuevo distintivo sustituye al anterior del titular], [en una lista única nacional, por antigüedad de la autorización, y el nuevo distintivo sustituye al anterior del titular], [por distritos y por orden de presentación, pero el titular conserva también su distintivo anterior],),
  sol: [La Resolución de 29 de julio de 2026 (BOE-A-2026-17504) desarrolla el art. 27 de la Orden, que encarga a la SETSI fijar el procedimiento para los sufijos de una letra. Asigna los distintivos por distritos y por estricto orden de presentación; el solicitante puede indicar hasta diez preferencias, y el nuevo distintivo sustituye al que tuviera asignado (coherente con el art. 28: el distintivo es único). La a habla de sorteo: la asignación es por orden de presentación. La c inventa una lista nacional por antigüedad. La d conserva el distintivo anterior, justo lo contrario de sustituirlo. Deroga la Resolución de 12 de julio de 2019. #vease[(Véase tema R5, sección «Sufijos y usos temporales».)]])
#pq(9, 2, 14, "c", "", "La IARU es la federación de asociaciones nacionales de radioaficionados (URE en España)",
  [La IARU (Unión Internacional de Radioaficionados) es:],
  ([el órgano de la CEPT que expide la licencia CEPT], [la autoridad que inspecciona las estaciones de aficionado en España], [la federación que agrupa a las asociaciones nacionales de radioaficionados, como la URE en España], [el organismo internacional que atribuye las bandas de frecuencias a los distintos servicios],),
  sol: [La IARU agrupa a las asociaciones nacionales de radioaficionados (en España, la URE) y, como la UIT, se organiza en tres Regiones, cada una con su plan de bandas. Quien atribuye las bandas a los servicios es la UIT, no la IARU; por eso sus planes son acuerdos voluntarios y no normas legales. La inspección corresponde al Estado.])
#pq(9, 2, 15, "a", "C-R6.2", "Repetidores de 2 m: entrada 145,000–145,1875 MHz, salida 600 kHz más arriba",
  [En los planes de bandas de la IARU para la Región 1:],
  ([Hay previstas frecuencias para repetidores en la banda 145,594–145,7935 MHz.], [No hay previstas frecuencias para repetidores en UHF.], [Hay previstas frecuencias para repetidores analógicos en la banda 88,5–99,0 MHz.], [No hay planes de banda de la IARU para la Región 1.],),
  sol: [En 2 m el plan reserva 145,000–145,1875 MHz a las entradas de los repetidores y, 600 kHz más arriba, sus salidas: $145,000 + 0,600 = 145,600$ MHz hasta $145,1875 + 0,600 = 145,7875$ MHz, dentro de 145,594–145,7935 MHz. La b) es falsa: en 70 cm hay segmentos de repetidores (433,000–433,375 MHz de entrada y 434,600–434,975 MHz de salida). La c) cita 88,5–99,0 MHz, que es radiodifusión FM y no una banda de aficionados. La d) es falsa: la Región 1 tiene plan propio, el que rige en España. #vease[(Véase tema R6, introducción del capítulo (entrada 145,000–145,1875 MHz y salida 600 kHz más arriba) y pregunta sobre la entrada de los repetidores de VHF.)]])
#pq(9, 2, 16, "d", "", "Balizas en 2 m: segmento 144,400–144,491 MHz",
  [En la banda de 2 m, el plan de bandas de la IARU para la Región 1 dedica el segmento 144,400–144,491 MHz a:],
  ([las comunicaciones por satélite], [la frecuencia de llamada de FM], [la entrada de los repetidores de FM], [las balizas],),
  sol: [Según el plan de bandas de la IARU para la Región 1, el tramo 144,400–144,491 MHz de la banda de 2 m es el de las balizas. La entrada de los repetidores de FM está en otro tramo, 145,000–145,1875 MHz (con la salida 600 kHz más arriba). Ni las comunicaciones por satélite ni la frecuencia de llamada de FM están en el segmento de balizas.])
#pq(9, 2, 17, "b", "R7.14", "Objeto de la prueba de capacitación: evaluar la capacidad para operar",
  [La prueba de capacitación de radioaficionado tiene por objeto:],
  ([acreditar la propiedad de los equipos de la estación], [evaluar la capacidad del aspirante para operar estaciones del servicio de aficionados], [comprobar la aptitud física del aspirante], [validar la instalación de antenas del domicilio],),
  sol: [La prueba acredita conocimientos técnicos y reglamentarios suficientes para operar sin causar perjuicio a otros servicios. No tiene nada que ver con la propiedad de los equipos ni con la instalación concreta, que son trámites distintos.])
#pq(9, 2, 18, "a", "F-R8.13", "Orden IET/1311/2013: derogó la Orden ITC/1791/2006",
  [La Orden IET/1311/2013 derogó expresamente:],
  ([la Orden ITC/1791/2006, de 5 de junio], [la Orden ITC/4096/2006, de 28 de diciembre (banda ciudadana CB-27)], [la Ley 19/1983, de 16 de noviembre], [el Real Decreto 2623/1986, de 21 de noviembre],),
  sol: [La disposición derogatoria única de la Orden IET/1311/2013 deroga expresamente la Orden ITC/1791/2006, de 5 de junio, que aprobaba el reglamento anterior de aficionados, y las normas de igual o inferior rango que se le opongan. La Ley 19/1983 (art. 2.2 del Código Civil: las leyes solo se derogan por otras posteriores) y el Real Decreto 2623/1986 tienen rango superior a una orden, y la propia Orden los cita como aplicables a las estaciones fijas (art. 18.2). La Orden ITC/4096/2006 (CB-27) no se deroga: la disposición final primera solo modifica el apartado 3 de su art. 4. #_apc3-ver[(Véase tema R8, introducción del tema («tres pisos» normativos).)]

#_apc3-net[La Orden IET/1311/2013 deroga expresamente la Orden ITC/1791/2006, de 5 de junio, que aprobaba el reglamento anterior de aficionados, y las disposiciones de igual o inferior rango que se le opongan. No deroga la Ley 19/1983 ni el Real Decreto 2623/1986, sobre antenas, que cita como aplicables a las estaciones fijas (art. 18.2), ni el reglamento de la banda ciudadana CB-27 (Orden ITC/4096/2006), del que solo modifica el apartado 3 del art. 4. Por eso los bancos antiguos que siguen la Orden de 2006 apoyan sus claves en una norma derogada.]])
#pq(9, 2, 19, "d", "F-R8.16", "Radioaficionado: interés por la radiotecnia con carácter exclusivamente personal, sin fines de lucro",
  [Según el Reglamento de uso del dominio público radioeléctrico por radioaficionados, estos son personas debidamente autorizadas que se interesan por la radiotecnia con carácter:],
  ([profesional, con derecho a cobrar por los servicios que presten a terceros], [asociativo, por pertenecer a una asociación de radioaficionados reconocida], [institucional, por encargo de la Administración o de Protección Civil], [exclusivamente personal y sin fines de lucro ni contenido económico],),
  sol: [Lo dice el art. 2.1 de la Orden IET/1311/2013: los radioaficionados son personas debidamente autorizadas que se interesan por la radiotecnia con carácter exclusivamente personal y sin fines de lucro ni contenido económico. De ahí que emitir con fines comerciales, publicitarios o lucrativos pueda llevar a la revocación de la autorización (art. 8.1.b). No es una actividad profesional ni remunerada (a), ni asociativa (b), ni se ejerce por encargo de la Administración (c), aunque el titular deba colaborar con Protección Civil si se le requiere en catástrofes (art. 30.4). #_apc3-ver[(Véase tema R7, introducción del tema (definición del servicio de aficionados, «sin fines de lucro»).)]])
#pq(9, 2, 20, "d", "F-R8.73", "Anomalía de seguridad mecánica o eléctrica: subsanarla de forma inmediata",
  [Según el artículo 31 de la Orden IET/1311/2013, si el titular observa una anomalía que afecta a la seguridad mecánica o eléctrica de los equipos, las antenas o los elementos anejos de su estación, debe:],
  ([esperar a la siguiente inspección de la Jefatura Provincial], [subsanarla en un plazo máximo de un mes], [comunicarla a la SETSI y esperar su autorización antes de repararla], [subsanarla de forma inmediata],),
  sol: [El artículo 31 obliga a mantener adecuadamente equipos, antenas y elementos anejos y a subsanar de forma inmediata cualquier anomalía que afecte a su seguridad, tanto mecánica como eléctrica. No hay plazo de gracia (b), ni se espera a una inspección (a), ni se pide permiso a la SETSI (c): la obligación nace en cuanto el titular observa la anomalía. Piensa en una riostra floja o un cable pelado: se arregla ese día, no el mes que viene. #_apc3-ver[(Véase tema T10, sección «Fusibles y protecciones» (última pregunta del capítulo: obligación del titular de cumplir la normativa de seguridad).)]

#_apc3-net[Art. 31 de la Orden IET/1311/2013: el titular de la autorización debe cumplir la normativa de seguridad que establezcan las distintas Administraciones Públicas, según sus competencias, para evitar cualquier accidente derivado del uso de sus estaciones. Equipos, antenas y elementos anejos deben mantenerse adecuadamente, y cualquier anomalía que afecte a su seguridad mecánica o eléctrica se subsana de forma inmediata. La SETSI no es responsable, en ningún caso, del incumplimiento de esas normas. Los titulares de licencias de estaciones fijas garantizan además el uso conforme a la legislación, también a través de su interconexión con otras redes o servicios.]])
#pq(9, 2, 21, "c", "F-R8.74", "Disposición final 2.ª: la SETSI dicta instrucciones y actualiza los anexos técnicos",
  [Según la disposición final segunda de la Orden IET/1311/2013, la SETSI está facultada para:],
  ([modificar por resolución el articulado del Reglamento cuando lo aconsejen las necesidades del Servicio de Aficionados], [fijar la cuantía de las tasas por el uso del dominio público radioeléctrico], [dictar las instrucciones necesarias para aplicar el Reglamento y revisar el contenido técnico de sus anexos, para actualizarlos conforme al Derecho de la Unión Europea y al Derecho internacional], [ampliar por resolución la vigencia de las autorizaciones de uso especial del dominio público radioeléctrico],),
  sol: [La disposición final segunda faculta a la SETSI, en su apartado 1, para dictar las instrucciones necesarias para aplicar el Reglamento y para revisar el contenido técnico de sus anexos, con el fin de actualizarlos conforme al Derecho de la Unión Europea y al Derecho internacional; y, en el apartado 2, para establecer los modelos de solicitud, que serán públicos y accesibles en la sede electrónica del Ministerio. Nada dice de reescribir los artículos (a), de fijar tasas (b) ni de prorrogar autorizaciones (d): la disposición transitoria única ya conserva la vigencia de las existentes. #_apc3-ver[(Véase tema R8, introducción del capítulo (marco normativo: la Orden IET/1311/2013 como norma de detalle).)]

#_apc3-net[Disposiciones de la Orden IET/1311/2013: la final segunda faculta a la SETSI para dictar las instrucciones necesarias para aplicar el Reglamento, para revisar el contenido técnico de sus anexos y actualizarlos conforme al Derecho de la Unión Europea y al Derecho internacional, y para establecer los modelos de solicitud, que deben ser públicos y accesibles en la sede electrónica del Ministerio. La transitoria única mantiene la vigencia de las autorizaciones existentes y la derogatoria única deroga la Orden ITC/1791/2006.]])
#pq(9, 2, 22, "b", "C-R8.46", "Potencia máxima en HF (1,8–28 MHz): 1000 W p.c.e.",
  [En la banda de frecuencias de 1830–1850 kHz, la potencia de cresta de la envolvente (p.c.e.) de las emisiones no deberá ser superior a:],
  ([50 W], [1000 W], [75 W], [5 W],),
  sol: [La tabla del apartado 3.1 del anexo I de la Orden IET/1311/2013 fija 1000 W (p.c.e.) para las bandas de HF, entre ellas la de 1,8 MHz (160 m). El tramo 1830–1850 kHz se atribuye al servicio de aficionados con carácter primario, por lo que se aplica el valor completo; en las bandas atribuidas con carácter secundario (en el CNAF, 1810–1830 kHz) el límite baja al 50% (apartado 3.2), es decir, 500 W. Las otras cifras no corresponden a esta banda: el 50 W, por ejemplo, es el límite de las estaciones desatendidas en HF. El banco original no traía clave. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe» (1 kW p.c.e. en la mayoría de las bandas de HF).)]

    #no-esta[El anexo I, apartado 3.1, de la Orden IET/1311/2013 da una tabla de potencias máximas por banda: en las de HF, de 160 m (1,8 MHz) a 10 m (28 MHz), 1000 W de potencia de cresta de la envolvente (p.c.e.); en 137 y 475 kHz, 1 W p.i.r.e. El apartado 3.2 añade que en las bandas atribuidas con carácter secundario la potencia máxima no supera el 50% de la tabla. Además, hay que reducirla siempre que sea necesario para no superar 3,5 mW/cm#super[2] en los lugares accesibles a las personas (apartado 3.5).]])
#pq(9, 2, 23, "c", "F-R8.33", "Extranjero de país no T/R 61-01: autorización temporal ≤ 90 días",
  [La SETSI puede autorizar a operar temporalmente en España a un extranjero titular de una licencia en vigor de un país que no ha adoptado la Recomendación T/R 61-01. El período de validez de esa autorización temporal no será superior a:],
  ([15 días], [seis meses], [90 días], [30 días],),
  sol: [El art. 15 permite a la SETSI autorizar a operar mientras esté temporalmente en España al titular de una licencia en vigor de un país que no ha adoptado la T/R 61-01. El período de validez «no será superior a 90 días». Los otros plazos son de otros trámites del Reglamento: 15 días naturales para los usos portables no continuados que no precisan notificación (art. 17.1), 30 días para que la Jefatura verifique la instalación de una estación fija (art. 20) y seis meses para terminar la instalación de una estación desatendida (art. 26). #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Los países que han adoptado la T/R 61-01 se benefician de la licencia CEPT (art. 13). Para el titular de una licencia de un país que no la ha adoptado existe otra vía, el art. 15 de la Orden IET/1311/2013: la SETSI puede concederle una autorización temporal para operar mientras esté en España, previa solicitud con nombre y apellidos, nacionalidad, dirección y copia de la licencia de origen. Sus equipos deben cumplir la normativa española, y la autorización no puede durar más de 90 días.]])
#pq(9, 2, 24, "d", "R8.70", "Uso de una estación ajena: con permiso del titular, identificándose con el distintivo propio",
  [Si un radioaficionado opera una estación de la que no es titular, deberá:],
  ([emplear el distintivo del titular de la estación], [solicitar un distintivo temporal a la Administración], [abstenerse de identificarse], [identificarse con su propio distintivo, contando con la autorización del titular],),
  sol: [El distintivo identifica al _operador_, no al aparato: quien habla se identifica con el suyo (art. 27 de la Orden: el distintivo identifica a su titular). Lo que hace falta es el consentimiento del titular de la estación, que responde de ella. Ojo: la Orden ITC/1791/2006 (art. 37.5, derogada) exigía además anteponer el distintivo del titular de la estación (véase R5.27); la Orden IET/1311/2013 no lo regula expresamente. La clave es la del banco de examen.])
#pq(9, 2, 25, "a", "F-R8.24", "Equipo de segunda mano sin certificado de aceptación: cumplir el anexo I, certificado por laboratorio acreditado",
  [Un equipo de segunda mano comercializado antes de la entrada en vigor del Real Decreto 1890/2000 no dispone del certificado de aceptación radioeléctrica exigido en su día. Para utilizarlo en una estación de radioaficionado debe:],
  ([cumplir las características técnicas del anexo I, certificado por un laboratorio acreditado], [ir acompañado de una declaración de conformidad firmada por su titular], [sustituirse por un equipo con marcado CE, pues no existe otra vía], [presentarse en la Jefatura Provincial para su homologación individual],),
  sol: [El art. 5.5, segundo párrafo, exige a estos equipos de segunda mano el certificado de aceptación radioeléctrica de su época o, en su defecto, que cumplan las características técnicas del anexo I, certificado por un laboratorio acreditado. La vía del laboratorio existe precisamente para los que carecen de certificado, así que no hace falta cambiar el equipo (c). La mera declaración del titular (b) no basta, y la presentación en la Jefatura (d) es una posibilidad optativa de los equipos de construcción propia, no de los comerciales. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Art. 5.5, segundo párrafo, de la Orden IET/1311/2013: los equipos de segunda mano comercializados antes de la entrada en vigor del Real Decreto 1890/2000 (evaluación de la conformidad de aparatos de telecomunicaciones) deben tener el certificado de aceptación radioeléctrica exigido en su día. Si carecen de él, deben cumplir las características técnicas del anexo I, certificado por un laboratorio acreditado. No basta la declaración del titular, y tampoco es preciso sustituir el equipo.]])
#pq(9, 2, 26, "a", "F-R8.55", "Modificaciones experimentales con licencia concedida: hasta 60 días sin afectar a la seguridad",
  [Según el artículo 20 de la Orden IET/1311/2013, una vez obtenida la licencia de una estación fija, su titular puede realizar con carácter experimental cualquier modificación en las instalaciones y equipos de la estación, siempre que no afecte a la seguridad, por un período máximo de:],
  ([60 días], [seis meses], [30 días], [15 días],),
  sol: [Art. 20, tercer párrafo: con la licencia concedida, el titular puede modificar con carácter experimental las instalaciones y equipos durante un máximo de 60 días, siempre que no afecte a la seguridad. Si la modificación se hace permanente, remite a la SETSI la documentación complementaria con los cambios; si cambia la ubicación de la antena, se solicita como una primera instalación. Los 30 días son el plazo de la Jefatura para expedir la licencia, y los 15 días, el de los usos portables sin notificación. Los seis meses no figuran en este artículo. #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Art. 20 de la Orden IET/1311/2013: una vez obtenida la licencia, el titular puede hacer con carácter experimental cualquier modificación en las instalaciones y equipos de la estación durante un máximo de 60 días, siempre que no afecte a la seguridad. Si la modificación es permanente, remite a la SETSI la documentación complementaria, con los cambios incluidos. Si cambia la ubicación de la antena, se solicita a la SETSI como una primera instalación.]])
#pq(9, 2, 27, "a", "R8.75", "Obras: desmontaje temporal sin indemnización; después se reinstala en condiciones similares",
  [Si una antena debidamente autorizada impide la realización de obras necesarias en el inmueble, su titular:],
  ([está obligado a desmontarla temporalmente sin derecho a indemnización], [puede negarse mientras dure su autorización], [tiene derecho a ser indemnizado por el desmontaje], [solo debe desmontarla si lo ordena un juez],),
  sol: [El derecho a instalar antenas no bloquea el mantenimiento del edificio: si la obra lo exige, la antena se desmonta temporalmente y el coste corre por cuenta del titular. Es la contrapartida del derecho que la Ley de Antenas le reconoce.])
#pq(9, 2, 28, "c", "F-R8.42", "Emisiones experimentales: se identifican con el distintivo propio",
  [Las emisiones realizadas al amparo de una autorización especial experimental (art. 17.3 de la Orden IET/1311/2013) se identifican con:],
  ([el número de la autorización especial, sin distintivo de llamada], [el distintivo de la Jefatura Provincial que tramita la solicitud], [el distintivo propio del radioaficionado o de la asociación solicitante], [un distintivo especial de una sola letra, reservado a los experimentos],),
  sol: [El art. 17.3.5.º lo dice sin rodeos: las emisiones se identifican con el distintivo propio del radioaficionado o de la asociación de radioaficionados solicitante (c). La autorización es nominativa, pero no sustituye al distintivo: no se emite con un número de autorización (a) ni con el distintivo de la Jefatura que tramita la solicitud (b). Y los sufijos de una letra (d) no se reservan a los experimentos: el art. 27 los liga a méritos y a la participación en concursos. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[El art. 17.3 de la Orden IET/1311/2013 fija las condiciones de las autorizaciones especiales experimentales: solicitud a la SETSI con al menos un mes de antelación; autorización nominativa, con plazo máximo inicial de 18 meses, ampliable; zonas geográficas excluidas; y suspensión inmediata de las emisiones si interfieren, en especial a la televisión. Las emisiones se identifican con el distintivo propio del radioaficionado o de la asociación de radioaficionados solicitante.]])
#pq(9, 2, 29, "b", "F-R9.11", "Leve: instalar una estación de radioaficionado sin autorización",
  [La instalación de una estación de radioaficionado careciendo de autorización constituye, según la Ley 11/2022:],
  ([una infracción grave], [una infracción leve], [una infracción muy grave], [una infracción solo si la estación llega a emitir],),
  sol: [El art. 108.4 tipifica como infracción leve la instalación de estaciones radioeléctricas de radioaficionado careciendo de autorización: es el tipo propio de nuestro servicio. El art. 107.1, más general, castiga como grave la instalación sin autorización de estaciones radioeléctricas; para las de radioaficionado la ley tiene su tipo leve. La ley castiga la propia instalación, sin exigir que la estación llegue a emitir. La multa máxima de una infracción leve es de 100 000 euros (art. 109.1.d). #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador».)]

#_apc3-net[Infracciones leves que afectan al radioaficionado (art. 108 de la Ley 11/2022): comunicarse utilizando estaciones no autorizadas (108.2), instalar una estación de radioaficionado careciendo de autorización (108.4) e incumplir las condiciones de la autorización (108.5). Multa máxima: 100 000 euros (art. 109.1.d). Instalar sin la autorización necesaria otras estaciones radioeléctricas es, en general, infracción grave (art. 107.1).]])
#pq(9, 2, 30, "c", "R9.28", "No es infracción no llevar libro de registro (no existe la obligación)",
  [Carecer de un libro diario o registro de las comunicaciones efectuadas constituye:],
  ([una infracción muy grave], [una infracción grave], [no constituye infracción, al no existir tal obligación], [una infracción leve],),
  sol: [Es una pregunta trampa clásica: la reglamentación española no impone al radioaficionado llevar libro de guardia ni registro de contactos. Anotarlos es costumbre útil —y necesaria para diplomas y concursos—, pero voluntaria.])
#fin-prueba()
#soluciones-simulacro(9)

// ======================================================================
#simulacro(10)
#prueba(10, 1)
#pq(10, 1, 1, "c", "C-T1.5", "Ley de Ohm: hallar V, I o R",
  [En un circuito eléctrico de corriente continua:],
  ([la intensidad está en razón inversa a la tensión], [la resistencia es variable con la tensión], [la intensidad está en razón directa a la tensión], [la capacidad del circuito disminuye],),
  sol: [
    Por la ley de Ohm, $I = V slash R$: con la resistencia constante, la intensidad es directamente
    proporcional a la tensión (si $V$ se duplica, $I$ se duplica). «Razón directa» significa eso, y
    la opción a dice justo lo contrario. La b es falsa: en un conductor óhmico la resistencia
    depende del material y de sus dimensiones ($R = ρ l slash S$), no de la tensión aplicada. La d
    no guarda relación con la pregunta. #vease[(Véase tema T1, sección «Unidades y leyes
    fundamentales».)]
  ])
#pq(10, 1, 2, "b", "T1.19", "Período: T = 1 / f, tiempo entre dos máximos consecutivos",
  [El período de una señal sinusoidal de 25 Hz de frecuencia es:],
  ([4 ms], [40 ms], [400 ms], [25 ms],),
  sol: [$T = 1 slash f = 1 slash 25 = 0,04$ s = 40 ms.])
#pq(10, 1, 3, "d", "F-T1.53", "Energía = potencia × tiempo (julio = W·s, kWh)",
  [La energía eléctrica consumida por una estufa de 2 kW que funciona durante 3 horas es de:],
  ([1,5 kWh], [5 kWh], [6 kW], [6 kWh],),
  sol: [La energía es potencia por tiempo: $E = P dot t = 2 "kW" times 3 "h" = 6 "kWh"$. Los «6 kW» serían una potencia, no una energía: es el error de unidades. Los 5 kWh suman (2 + 3) en lugar de multiplicar. Los 1,5 kWh dividen (3/2) en lugar de multiplicar. _(Véase tema T1, sección «Unidades y leyes fundamentales».)_

#_apc1-noest[La energía eléctrica es potencia por tiempo: $E = P dot t$. En el Sistema Internacional se mide en julios (1 J = 1 W·s), pero en la práctica se usan el vatio-hora (1 Wh = 3600 J) y el kilovatio-hora (1 kWh = 1000 Wh = 3,6 MJ), que es lo que factura la compañía eléctrica. No hay que confundir el kilovatio (potencia) con el kilovatio-hora (energía).]])
#pq(10, 1, 4, "c", "T1.32", "Teorema de Nyquist: f_s ≥ 2 f_máx",
  [Para digitalizar sin pérdida de información una señal de audio cuya frecuencia máxima es de 3 kHz, la frecuencia de muestreo mínima debe ser de:],
  ([1,5 kHz], [3 kHz], [6 kHz], [12 kHz],),
  sol: [Criterio de Nyquist: $f_s >= 2 f_"máx" = 6$ kHz — hacen falta al menos dos muestras por período para fijar una sinusoide. Muestrear por debajo produce _aliasing_ (una frecuencia alta se confunde con una baja), que evita el filtro antisolapamiento previo al conversor A/D.])
#pq(10, 1, 5, "d", "C-T2.6", "Código de colores: cifra que representa cada color (negro 0 … blanco 9)",
  [En las dos primeras franjas que indican el valor de una resistencia, la cifra cinco está
representada por el color:],
  ([Blanco], [Amarillo], [Azul], [Verde],),
  sol: [
    Las cifras del código de colores son: negro 0, marrón 1, rojo 2, naranja 3, amarillo 4, verde 5,
    azul 6, violeta 7, gris 8 y blanco 9. El cinco es, pues, el verde. Los distractores son cifras
    de la misma tabla: amarillo es el 4, azul el 6 y blanco el 9. Truco: del rojo al violeta, los
    colores siguen el orden del arco iris y las cifras van de 2 a 7 (rojo 2, naranja 3, amarillo 4,
    verde 5, azul 6, violeta 7). #vease[(Véase tema T2, sección «Resistencias».)]
  ])
#pq(10, 1, 6, "b", "T2.41", "El condensador se opone a las variaciones de tensión; la bobina, a las de corriente",
  [Un condensador intercalado en un circuito de corriente alterna tiende a:],
  ([rectificar la corriente], [oponerse a las variaciones de tensión entre sus armaduras], [oponerse a las variaciones de la corriente], [elevar la frecuencia de la señal],),
  sol: [Su tensión no puede cambiar bruscamente, porque hacerlo exigiría una corriente infinita ($i = C dif v slash dif t$). Es el dual de la bobina, que se opone a las variaciones de corriente. De ahí que el condensador alise la tensión en las fuentes de alimentación.])
#pq(10, 1, 7, "b", "F-T2.4", "Cálculo de la reactancia inductiva X_L = 2πfL",
  [La reactancia inductiva de una bobina de 2 μH a 3,5 MHz es aproximadamente de:],
  ([7 Ω], [44 Ω], [440 Ω], [0,023 Ω],),
  sol: [Se aplica $X_L = 2 pi f L$: $X_L = 2 pi times 3,5 dot 10^6 times 2 dot 10^(-6) = 2 pi times 7 approx 44$ Ω. Si se olvida el $2 pi$ sale 7 Ω (a); 440 Ω (c) es un error de una potencia de diez al pasar de μH a H; y 0,023 Ω (d) es la inversa, $1/(2 pi f L)$, que no es la reactancia de una bobina. Recuerda que $X_L$ crece con la frecuencia y con la inductancia. _(Véase tema T2, sección «Bobinas», y capítulo «Cómo funciona una radio: de los campos a la voz», sección 2 (tabla de reactancias de bobina y condensador).)_])
#pq(10, 1, 8, "d", "C-T2.7", "Con continua en el primario no hay corriente en el secundario",
  [Alimentando el primario de un transformador con corriente continua, en el circuito del secundario,
cargado con una resistencia:],
  ([Pasa una corriente mayor que por el primario], [Pasa la misma corriente que por el primario], [La corriente que pasa es ligeramente inferior que la del primario], [No hay paso de corriente],),
  sol: [
    El transformador solo transfiere energía mediante un flujo magnético que varía. Con continua el
    flujo del núcleo es constante y, por la ley de Faraday, no se induce tensión en el secundario
    ($e = −N "d"φ slash "d"t = 0$): por la resistencia de carga no circula corriente. Las otras tres
    opciones describirían un transformador con alterna y dependerían de la relación de espiras
    ($I_s slash I_p = N_p slash N_s$). Solo en el instante de conectar o desconectar, mientras el
    flujo cambia, aparece un breve pulso en el secundario. #vease[(Véase tema T2, sección
    «Transformadores».)]
    #no-esta[El secundario solo recibe tensión cuando el flujo cambia, y la continua no lo hace. Además, con
    continua el primario opone únicamente la resistencia del hilo, que es pequeña (la reactancia
    inductiva vale cero, $X_L = 2π f L = 0$): circula una corriente alta que lo calienta y puede
    quemarlo sin transferir nada al secundario. Por eso un transformador de red nunca se alimenta
    con continua; para subir o bajar una tensión continua hay que convertirla antes en alterna.]
  ])
#pq(10, 1, 9, "d", "T2.24", "Transistor bipolar: terminales emisor, base y colector; tipos NPN y PNP",
  [Un transistor bipolar puede ser de tipo:],
  ([NNP], [PNN], [PPN], [NPN],),
  sol: [Los transistores bipolares son NPN o PNP, según el orden de las capas de semiconductor.])
#pq(10, 1, 10, "c", "T3.44", "Resistencias en paralelo: tensión común; la corriente de cada rama es inversamente proporcional a R y la total es la suma (Kirchhoff)",
  [En un circuito formado por tres resistencias de distinto valor conectadas en paralelo, la corriente que circula por cada una es:],
  ([independiente de su resistencia], [directamente proporcional a su resistencia], [inversamente proporcional a su resistencia], [la misma en todas ellas],),
  sol: [En paralelo todas soportan la misma tensión, así que por la ley de Ohm cada una toma $I = V slash R$: cuanto menor es la resistencia, más corriente pasa por ella. Por la de menor valor circula la mayor parte del total.])
#pq(10, 1, 11, "a", "F-T3.42", "En VHF/UHF, terminales cortos (o SMD): la inductancia de las patas presenta reactancia apreciable",
  [En VHF y UHF los componentes se montan con los terminales lo más cortos posible porque:],
  ([la inductancia de los terminales, que apenas importa en HF, presenta a esas frecuencias una reactancia apreciable], [la capacidad de los terminales crece con la frecuencia y llega a cortocircuitar el componente], [la resistencia óhmica de los terminales es lo único que limita el comportamiento del componente a esas frecuencias], [así disminuye la capacidad parásita entre las espiras de las bobinas],),
  sol: [Un terminal tiene una inductancia del orden de 10 nH por centímetro: inocua en HF, pero su reactancia $X_L = 2 pi f L$ crece con la frecuencia. A 145 MHz, 10 nH dan $2 pi dot 145 times 10^6 dot 10 times 10^(-9) approx 9$ Ω, suficiente para desacoplar mal un condensador o desajustar un circuito. Por eso en VHF y UHF se acortan las patas o se usan componentes de montaje superficial. La capacidad no crece con la frecuencia (b), la resistencia óhmica no es la limitación principal (c), y la capacidad entre espiras es cosa de la bobina, no de las patas (d). _(Véase tema T3, sección «Asociación de componentes y resonancia».)_])
#pq(10, 1, 12, "b", "T3.51", "Condensadores de desacoplo: absorben los transitorios de la alimentación",
  [Los efectos de los transitorios en las líneas de alimentación se evitan generalmente:],
  ([alargando los cables], [con condensadores de desacoplo], [elevando la tensión de alimentación], [suprimiendo la toma de tierra],),
  sol: [Un condensador se opone a las variaciones bruscas de tensión, así que absorbe los picos y valles que viajan por la alimentación. Es la misma función que cumplen los condensadores de desacoplo repartidos por las placas.])
#pq(10, 1, 13, "c", "", "Emisor común: único montaje que invierte la fase 180°",
  [De los tres montajes del transistor bipolar, el que invierte la fase de la señal 180° es el de:],
  ([base común], [colector común], [emisor común], [ninguno: los tres conservan la fase],),
  sol: [En emisor común, cuando la base sube el transistor conduce más, cae más tensión en la resistencia de colector y el colector baja: la salida está invertida 180°. La base común y el colector común (seguidor de emisor) entregan la señal en fase.])
#pq(10, 1, 14, "d", "T3.45", "Oscilador a cristal: frecuencia muy estable (y apenas ajustable)",
  [Los osciladores controlados por un cristal de cuarzo se caracterizan por generar una señal:],
  ([de amplitud muy elevada], [de gran contenido en armónicos], [de frecuencia fácilmente ajustable], [de frecuencia muy estable],),
  sol: [Un cristal de cuarzo tiene un factor de calidad altísimo y una frecuencia propia que apenas deriva con la temperatura. Esa estabilidad es lo que se busca; a cambio, la frecuencia no puede moverse apenas.])
#pq(10, 1, 15, "b", "T4.2", "Superheterodino: la FI es una frecuencia fija, presente a la salida del mezclador (de ahí el nombre)",
  [Se denomina frecuencia intermedia (FI) a:],
  ([la mitad de la frecuencia recibida], [la frecuencia de valor constante empleada en los receptores superheterodinos, presente a la salida del mezclador], [la frecuencia media de la banda de trabajo], [la frecuencia del oscilador local],),
  sol: [La FI es una frecuencia fija a la que el mezclador traslada cualquier señal sintonizada; sus filtros pueden así optimizarse (455 kHz, 9 MHz, 10,7 MHz son valores típicos).])
#pq(10, 1, 16, "a", "C-T4.1", "La etapa detectora demodula (extrae la información)",
  [La etapa de detección de un receptor se emplea para:],
  ([Demodular la señal recibida.], [Limitar la señal recibida.], [Amplificar la señal recibida.], [Mezclar la señal recibida.],),
  sol: [
    Detectar es demodular: el detector recupera la información (voz, datos) que llevaba la
    portadora, es decir, extrae la información de la señal modulada. Mezclar es tarea del mezclador,
    que traslada la señal a la FI con el oscilador local; limitar, del limitador, propio de la FM;
    amplificar, de las etapas de RF, FI y BF. La misma idea se pregunta con otras palabras: «en la
    etapa detectora se efectúa un proceso de demodulación» (no de amplificación, neutralización ni
    alimentación) o «la detección sirve para extraer la información de la señal modulada». Mezclar
    la información con la portadora es lo contrario, modular, y se hace en el transmisor; convertir
    continua en alterna o multiplicar la frecuencia de la portadora son funciones de un inversor y
    de un multiplicador. #vease[(Véase tema T3, sección «Clases de amplificación y detectores»; tema
    T4, sección «Características y controles».)]
  ])
#pq(10, 1, 17, "a", "T5.20", "Excitador: lleva la señal al nivel que necesita el amplificador final",
  [En un transmisor, el excitador tiene la misión de:],
  ([suministrar la potencia necesaria a la etapa amplificadora final], [excitar la etapa osciladora], [alimentar en continua todo el transmisor], [sumar las frecuencias de los dos osciladores],),
  sol: [El excitador es la etapa intermedia que eleva el nivel de la señal hasta lo que el amplificador final necesita a su entrada. Un lineal externo, por ejemplo, se «excita» con los pocos vatios que le entrega el transceptor.])
#pq(10, 1, 18, "c", "T5.30", "PEP: potencia de pico de envolvente",
  [Las siglas PEP, con que se expresa la potencia de un transmisor de SSB, significan:],
  ([potencia entregada permanente], [potencia específica de portadora], [potencia de pico de envolvente], [potencia eficaz promediada],),
  sol: [Del inglés _peak envelope power_. En SSB la potencia varía continuamente con la voz, así que no tiene sentido dar un valor medio: se especifica la potencia en la cresta de la envolvente, que es la que limita el equipo y la que la reglamentación acota.])
#pq(10, 1, 19, "c", "T5.26", "VOX: pasa a transmisión al hablar; en MAN se usa el PTT del micrófono",
  [El dispositivo VOX de un transceptor permite:],
  ([ajustar automáticamente la frecuencia], [variar la desviación de frecuencia en FM], [pasar automáticamente a transmisión al hablar ante el micrófono], [comprimir la señal de audio],),
  sol: [Del inglés _voice operated exchange_: detecta que hay voz en el micrófono y conmuta el equipo a transmisión sin tocar el PTT, volviendo a recepción tras una breve espera al callarse.])
#pq(10, 1, 20, "b", "T6.6", "Dipolo plegado: impedancia unas cuatro veces mayor (≈ 300 Ω)",
  [En resonancia, el dipolo plegado (doblado) presenta, respecto del dipolo simple, una impedancia:],
  ([la mitad], [unas cuatro veces mayor (∼300 Ω)], [nula], [igual],),
  sol: [Los dos conductores del lazo se reparten la corriente; para radiar la misma potencia el generador entrega la mitad de corriente, y si en $P = I^2 R$ la corriente se reduce a la mitad, la resistencia debe cuadruplicarse: $tilde 4 times 73 approx 300$ Ω. De ahí su uso con línea bifilar de 300 Ω y como elemento excitado (alimentado) de muchas Yagi.])
#pq(10, 1, 21, "d", "T6.14", "Diagrama de la vertical: máximo en el plano horizontal y nulo hacia el cénit",
  [El máximo de radiación del diagrama de una antena vertical se produce:],
  ([hacia el suelo], [a 45 grados de elevación], [hacia el cénit], [en el plano horizontal],),
  sol: [Un elemento radiante emite al máximo perpendicularmente a su eje y no a lo largo de él; puesta en vertical, la antena tiene su nulo hacia el cénit y su máximo en el plano horizontal —bajo ángulo—, justo lo que interesa para DX en las bandas bajas.])
#pq(10, 1, 22, "a", "T6.18", "Guía de ondas: no propaga por debajo de su frecuencia de corte",
  [Se conoce como «frecuencia de corte» de una guía de onda a la frecuencia:],
  ([por debajo de la cual no es posible la transmisión en la guía], [de resonancia del último modo], [a la que la atenuación es mínima], [máxima que soporta la guía sin fundirse],),
  sol: [La guía de onda solo propaga por encima de su frecuencia de corte; por debajo, el modo no puede existir y la señal se atenúa exponencialmente.])
#pq(10, 1, 23, "b", "T7.5", "VHF y UHF: onda directa, distancias cortas",
  [La forma más común de propagación en VHF y UHF es por:],
  ([conducto troposférico permanente], [onda directa], [onda de superficie], [reflexión ionosférica en la capa D],),
  sol: [En VHF/UHF la ionosfera ya no refleja: propagación por onda directa, con alcance algo mayor que el horizonte óptico.])
#pq(10, 1, 24, "a", "F-T7.1", "Pérdida en espacio libre y relación señal/ruido: 20 log d y 20 log f (×10 la distancia: −20 dB)",
  [En un enlace en espacio libre, con la misma potencia transmitida y el mismo ruido en el receptor, al multiplicar por 10 la distancia la relación señal/ruido:],
  ([disminuye 20 dB], [disminuye 40 dB], [disminuye 10 dB], [no varía, porque la señal y el ruido se atenúan por igual],),
  sol: [En espacio libre la potencia recibida cae con $1 slash d^2$: la atenuación en decibelios crece como $20 log_10 d$. Al multiplicar la distancia por 10 son $20 log 10 = 20$ dB de señal menos (doblar la distancia son 6 dB). El ruido del receptor no depende de la distancia, así que la relación señal/ruido empeora esos mismos 20 dB. Los 10 dB saldrían de usar $10 log d$; los 40 dB corresponderían a una potencia que cayera como $1 slash d^4$; y el ruido no se atenúa con la señal, pues lo genera el propio receptor y el entorno. #vease[(Véase tema T7, sección «Fenómenos de propagación».)]])
#pq(10, 1, 25, "d", "T7.7", "Desvanecimiento (fading): variación momentánea de la intensidad recibida",
  [La variación momentánea de la intensidad de campo recibida se conoce como:],
  ([efecto pelicular], [intermodulación], [dispersión troposférica], [desvanecimiento o fading],),
  sol: [El fading es la variación momentánea de la intensidad recibida (cambios ionosféricos, multitrayecto); el CAG lo compensa en parte.])
#pq(10, 1, 26, "c", "T8.22", "Dipmeter: frecuencia de resonancia de un circuito sin alimentarlo",
  [El instrumento denominado «dipmeter» o medidor de absorción sirve para:],
  ([medir la intensidad de campo de una antena], [comprobar la continuidad de un cable coaxial], [determinar la frecuencia de resonancia de un circuito sin alimentarlo], [medir la potencia de salida de un transmisor],),
  sol: [Es un oscilador con una bobina exterior: al acercarla a un circuito resonante y barrer la frecuencia, en la resonancia el circuito le roba energía y la lectura cae bruscamente — ese «dip» es el que da nombre al aparato y señala la frecuencia buscada.])
#pq(10, 1, 27, "d", "T8.23", "Carga artificial: ajustar el transmisor sin radiar",
  [La carga artificial (carga fantasma) de una estación se emplea para:],
  ([proteger al receptor durante la transmisión], [aumentar la potencia radiada por la antena], [adaptar la impedancia de la línea de transmisión], [ajustar y probar el transmisor sin radiar señal al exterior],),
  sol: [Es una resistencia no inductiva de la impedancia nominal —50 ohmios casi siempre— capaz de disipar en calor toda la potencia del equipo. Permite hacer ajustes sin ocupar la banda ni molestar a nadie.])
#pq(10, 1, 28, "a", "", "Fuente, camino y víctima: caminos de acoplo por antena, por líneas y por radiación directa",
  [Los caminos por los que la señal de una estación puede acoplarse a un equipo electrónico cercano son:],
  ([la antena del equipo afectado, las líneas que le llegan (red eléctrica, altavoces, cable) y la radiación directa sobre sus circuitos], [solo la antena del equipo afectado], [solo la red eléctrica], [ninguno, si la estación cumple los límites de emisiones no esenciales],),
  sol: [Todo problema de compatibilidad se descompone en fuente, camino y víctima, y los caminos son tres: la antena de la víctima, las líneas que le llegan y la radiación directa sobre sus circuitos y cables. Una estación limpia puede aún bloquear un equipo cercano con su señal fundamental: el problema es entonces de inmunidad del equipo afectado.])
#pq(10, 1, 29, "a", "C-T10.1", "Ante una tormenta: desconectar la antena (y el equipo de la red), nunca la toma de tierra",
  [Es recomendable ante la previsión de una tormenta:],
  ([Desconectar los cables de bajada de antena.], [Proteger los cables con un fusible apropiado.], [Conectar la red eléctrica a la toma de tierra.], [Desconectar las antenas y la toma de tierra.],),
  sol: [
    El mástil y la antena atraen el rayo y la sobretensión puede bajar por el cable hasta el equipo
    y la vivienda. Por eso, ante una tormenta se desconectan las bajadas de antena del transceptor
    (y conviene desenchufar también el equipo de la red). La toma de tierra del mástil y de los
    soportes, en cambio, nunca se desconecta: es la vía por la que debe descargarse el rayo, y esa
    es la trampa de la opción d. Un fusible no protege ante un rayo, y conectar la red eléctrica a
    tierra provocaría un cortocircuito y haría saltar el diferencial. #vease[(Véase tema T10,
    introducción (riesgo atmosférico).)]
  ])
#pq(10, 1, 30, "c", "", "Protección contra el rayo: mástil y malla a tierra por el exterior, descargador y una sola tierra",
  [Para proteger la instalación de antena contra las descargas atmosféricas, es correcto:],
  ([usar para el mástil una toma de tierra independiente, separada de la de los equipos], [llevar el conductor de tierra del mástil por el interior de la vivienda], [unir el mástil y la malla del coaxial a tierra por el exterior, con conductores cortos y directos, y poner un descargador en la entrada del cable], [aislar el mástil de tierra para que el rayo no lo busque],),
  sol: [El rayo busca el camino más corto al suelo, y un conductor grueso por el exterior hasta la pica se lo da sin pasar por la casa. El descargador deriva a tierra las sobretensiones inducidas en el coaxial. Mástil, descargador y chasis van a una sola tierra: con tierras separadas aparecerían miles de voltios entre ellas durante la descarga.])
#fin-prueba()
#prueba(10, 2)
#pq(10, 2, 1, "d", "R1.17", "Las cifras se deletrean con su nombre inglés (Zero…Nine); el 0 es Zero, no Oscar ni «Cero»",
  [En el deletreo internacional, la cifra «0» se identifica con la palabra:],
  ([Oscar], [Nada], [Cero], [Zero],),
  sol: [Las cifras se dicen en inglés: _Zero_. Y no debe confundirse con _Oscar_, que es la letra O — la confusión entre el cero y la o es justamente lo que el deletreo evita.])
#pq(10, 2, 2, "d", "F-R2.1", "QTR hora exacta",
  [El grupo #_apc2-m[QTR] se utiliza para dar o pedir:],
  ([la distancia entre las estaciones], [el nombre de la estación], [la posición de la estación], [la hora exacta],),
  sol: [#_apc2-m[QTR] es la hora exacta: con interrogación (#_apc2-m[QTR?]) se pregunta «¿cuál es la hora exacta?» y, como respuesta, se dice «la hora exacta es…». Los distractores son otros grupos de las tablas: #_apc2-m[QTH] es la posición o localidad de la estación, #_apc2-m[QRA] es el nombre de la estación y #_apc2-m[QRB] es la distancia entre estaciones. Para recordarlo: la R de #_apc2-m[QTR] es de «reloj». #vease[(Véase tema R2, tabla «Grupos del código Q más frecuentes en el Servicio de Aficionados».)]])
#pq(10, 2, 3, "c", "R2.22", "QSD manipulación defectuosa",
  [El grupo `QSD` indica que:],
  ([la estación va a cerrar], [se transmite con potencia reducida], [la manipulación es defectuosa], [existe desvanecimiento en la señal],),
  sol: [Avisa de que los puntos y rayas llegan mal formados — manipulador sucio, velocidad irregular o chasquidos. El desvanecimiento es `QSB`.])
#pq(10, 2, 4, "d", "R3.12", "DE delante del distintivo de quien transmite",
  [En una comunicación, la abreviatura `DE` colocada antes de un distintivo indica:],
  ([que se solicita respuesta inmediata], [que la estación va a cerrar], [el nombre del operador], [que a continuación viene el distintivo de quien transmite],),
  sol: [Es literalmente la preposición «de»: en «`EA4XYZ` de `EA1ABC`», quien llama es la segunda. Marca quién habla, y por eso va siempre delante del propio distintivo.])
#pq(10, 2, 5, "c", "F-R3.3", "Informe RST: R legibilidad 1–5, S intensidad 1–9, T tono 1–9",
  [En el informe #_apc2-m[RST], la segunda cifra (la S) expresa:],
  ([la legibilidad, en una escala de 1 a 5], [el tono, en una escala de 1 a 9], [la intensidad de la señal, en una escala de 1 a 9], [la potencia del transmisor, en una escala de 1 a 9],),
  sol: [El informe #_apc2-m[RST] son tres cifras, en este orden: *R* (_readability_, legibilidad, de 1 a 5), *S* (_strength_, intensidad, de 1 a 9) y *T* (_tone_, tono, de 1 a 9, que se añade en telegrafía). La segunda cifra es, pues, la intensidad. Los distractores reordenan las escalas: la legibilidad es la primera cifra y solo llega a 5; el tono es la tercera. La potencia del transmisor no forma parte del informe. #vease[(Véase tema R3, tabla «Abreviaturas de procedimiento más habituales» (#_apc2-m[RST]).)] #no-esta[El informe #_apc2-m[RST] se da con tres cifras, en este orden: *R* (_readability_, legibilidad) de 1 a 5; *S* (_strength_, intensidad) de 1 a 9; y *T* (_tone_, tono) de 1 a 9, que se añade en telegrafía. En fonía se dan las dos primeras: el «59» es el informe máximo (legibilidad perfecta e intensidad máxima).]])
#pq(10, 2, 6, "b", "R3.20", "WX tiempo meteorológico",
  [En una comunicación, la abreviatura `WX` se refiere a:],
  ([la longitud de onda empleada], [las condiciones meteorológicas], [la potencia de la estación], [el tipo de antena instalada],),
  sol: [De _weather_. Es uno de los asuntos clásicos de conversación en un contacto, junto con el equipo (`RIG`) y el informe de señal.])
#pq(10, 2, 7, "c", "R3.21", "UR su (your)",
  [La abreviatura `UR` corresponde a:],
  ([una estación no identificada], [la banda de UHF], [el posesivo «su», referido al corresponsal], [una emisión de urgencia],),
  sol: [Contracción de _your_, escrita tal como suena. Aparece continuamente en expresiones como «`UR RST` 599».])
#pq(10, 2, 8, "b", "R4.8", "Señal de alarma radiotelefónica: tonos alternos de 2200 y 1300 Hz",
  [La señal de alarma en radiotelefonía consiste en dos tonos aproximadamente sinusoidales transmitidos alternativamente, de frecuencias:],
  ([3000 Hz y 300 Hz], [2200 Hz y 1300 Hz], [440 Hz y 880 Hz], [500 Hz y 1000 Hz],),
  sol: [La señal de alarma alterna tonos de 2200 y 1300 Hz para activar los receptores automáticos de guardia antes de un socorro.])
#pq(10, 2, 9, "d", "F-R4.8", "Límites en HF: 80 m 3500–3800 kHz, 20 m 14000–14350 kHz (¿está dentro de banda?)",
  [De las siguientes frecuencias, la que está dentro de una banda atribuida al Servicio de Aficionados en España es:],
  ([14500 kHz], [3900 kHz], [7300 kHz], [14250 kHz],),
  sol: [En España los límites son: 80 m, 3500–3800 kHz; 40 m, 7000–7200 kHz; 20 m, 14000–14350 kHz. Solo 14250 kHz cae dentro de una banda (20 m). 3900 kHz queda por encima de los 3800 kHz de 80 m: de 3800 a 3900 hay otros servicios (entre ellos fijo y móvil). 7300 kHz supera los 7200 kHz de 40 m (valdría en la Región 2, no en España). 14500 kHz está por encima de 14350 kHz, ya en una atribución de fijo y móvil. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)] #no-esta[Para saber si una frecuencia cae en banda de aficionado en España hay que conocer los límites: 80 m, 3500–3800 kHz; 40 m, 7000–7200 kHz; 20 m, 14000–14350 kHz. Justo fuera hay otros servicios: 3800–3900 kHz son de fijo y móvil; 7200–7300 kHz, de radiodifusión; 14350–14990 kHz, de fijo y móvil. El límite de 7300 kHz de la Región 2 no vale en España.]])
#pq(10, 2, 10, "a", "R5.40", "Añadir opcionalmente el distrito desde el que se emite: EA7/EA4KLM/M",
  [El distintivo `EA7/EA4KLM/M` corresponde a:],
  ([una estación móvil del distrito 4 que opera en el distrito 7], [una estación desatendida del distrito 7], [una estación fija de Andalucía], [un distintivo especial de concurso],),
  sol: [Se lee de fuera hacia dentro: EA7 dice desde dónde se emite (Andalucía), `EA4KLM` es el titular, del distrito 4, y el sufijo final /M indica que opera en móvil. La misma lógica con /P para portable.])
#pq(10, 2, 11, "c", "F-R5.13", "Prefijos de otros países europeos: Alemania DL, Italia I, Reino Unido G/M",
  [Un distintivo de llamada cuyo prefijo es #_apc2-m[M] o #_apc2-m[G] (por ejemplo, #_apc2-m[M0BVM]) corresponde a:],
  ([Mónaco], [Malta], [Reino Unido], [Irlanda],),
  sol: [Las series #_apc2-m[G] y #_apc2-m[M] son del Reino Unido (tabla de series de la UIT). La T/R 61-01, apéndice II, da #_apc2-m[M] para el Reino Unido y prefijos derivados para sus regiones, como #_apc2-m[MM] (Escocia) y #_apc2-m[MW] (Gales). Irlanda usa #_apc2-m[EI], Malta #_apc2-m[9H] y Mónaco #_apc2-m[3A]: la M de Malta y de Mónaco es solo una trampa por la inicial. #vease[(Véase tema R5, introducción del capítulo (prefijo, distrito y sufijo).)] #no-esta[El Reino Unido tiene las series #_apc2-m[G] y #_apc2-m[M] en la tabla de la UIT. Según la T/R 61-01, el visitante de esos países usa #_apc2-m[M], con prefijos propios para sus regiones: #_apc2-m[MM] Escocia, #_apc2-m[MW] Gales, #_apc2-m[MI] Irlanda del Norte. No lo confundas con Irlanda (#_apc2-m[EI]), Malta (#_apc2-m[9H]) ni Mónaco (#_apc2-m[3A]).]])
#pq(10, 2, 12, "b", "C-R5.11", "Prefijos temporales ED, EE y EF: eventos ordinarios; mantienen el resto del distintivo",
  [El prefijo EE delante de un distintivo completo de radioaficionado indica:],
  ([Una estación de servicios especiales.], [Un distintivo de uso temporal (concursos, experimentos, demostraciones y otros eventos locales, regionales, autonómicos o nacionales).], [Un distintivo permanente de estación automática desatendida.], [No puede emplearse en estaciones españolas.],),
  sol: [Según el artículo 27 de la Orden IET/1311/2013, ED, EE y EF se pueden usar, con autorización previa, como prefijos temporales en concursos, experimentos, ensayos, demostraciones y otros eventos locales, regionales, autonómicos o nacionales, y el resto del distintivo del titular no cambia. La c falla: el prefijo permanente de las desatendidas es ED. La d también: EE pertenece a la serie atribuida a España. Nota: el enunciado antiguo hablaba de estaciones «clase B», pero las clases A, B y C del régimen anterior ya no existen; la respuesta se conserva con el significado vigente. #vease[(Véase tema R5, sección «Sufijos y usos temporales».)]])
#pq(10, 2, 13, "d", "", "Prefijos AM y AN: eventos relevantes de ámbito nacional",
  [Los prefijos de uso temporal AM y AN se autorizan para:],
  ([eventos relevantes de ámbito internacional], [concursos, experimentos y demostraciones de ámbito local manteniendo el resto del distintivo], [las estaciones automáticas desatendidas], [eventos relevantes de ámbito nacional],),
  sol: [La Orden IET/1311/2013 escalona los prefijos temporales según el rango del evento: AM y AN, eventos relevantes de ámbito nacional, con sufijo propio. AO es el de los eventos relevantes de ámbito internacional, que es la confusión típica. ED, EE y EF son los de eventos ordinarios y mantienen el resto del distintivo; ED es además el prefijo permanente de las desatendidas.])
#pq(10, 2, 14, "b", "R6.13", "Naturaleza de los planes: acuerdos voluntarios y guía mundial, pero la Orden obliga a usar el de la Región 1 como norma general en España",
  [Los planes de banda de la IARU, en cuanto a su naturaleza jurídica:],
  ([sustituyen al Cuadro Nacional de Atribución de Frecuencias], [son acuerdos voluntarios entre las asociaciones nacionales, no normas legales], [tienen rango de ley en los países de la CEPT], [son obligatorios solo para los titulares de la clase A],),
  sol: [La IARU es una federación de asociaciones, no un legislador: sus planes nacen de un acuerdo voluntario y no tienen rango de ley. Pero la Orden IET/1311/2013 (art. 2.2 y anexo I, apartado 3.1) remite a ellos y obliga a usarlos «como norma general», de modo que todo radioaficionado que opere en España debe tenerlos en cuenta (como dice R6.1). Por encima siguen estando el CNAF y la normativa nacional.])
#pq(10, 2, 15, "a", "R6.6", "Frecuencias de llamada: punto de encuentro de un modo, no de uso exclusivo",
  [Las frecuencias de llamada previstas en los planes de banda permiten:],
  ([contactar con otros operadores que utilizan el mismo modo], [emitir con más potencia de la autorizada], [reservar una frecuencia de uso exclusivo], [transmitir sin identificarse],),
  sol: [Las frecuencias de llamada son puntos de encuentro por modo, antes de desplazarse (#_r6-cod[QSY]) a otra frecuencia.])
#pq(10, 2, 16, "d", "R7.1", "Escuchar antes de transmitir (QRL?)",
  [Comprobar si alguien está utilizando una frecuencia antes de iniciar una transmisión en ella es:],
  ([obligatorio solo en las bandas de VHF], [necesario únicamente en los concursos], [una pérdida de tiempo innecesaria], [una práctica de operación adecuada],),
  sol: [Escuchar antes de transmitir («#_r7-cod[¿QRL?]») es la primera norma de operación.])
#pq(10, 2, 17, "b", "R8.55", "Marco: competencia exclusiva del Estado en telecomunicaciones (art. 149.1.21.ª CE)",
  [El Reglamento de uso del dominio público radioeléctrico por aficionados se dicta al amparo del artículo 149.1.21.ª de la Constitución, que atribuye al Estado competencia exclusiva en materia de:],
  ([defensa], [telecomunicaciones], [medio ambiente], [industria],),
  sol: [El artículo 149.1.21.ª de la Constitución da al Estado la competencia exclusiva en telecomunicaciones: por eso el Reglamento es estatal.])
#pq(10, 2, 18, "c", "R8.38", "Ganancia del sistema radiante de las desatendidas: ≤ 6 dBd",
  [Como norma general, la ganancia del sistema radiante de las estaciones desatendidas en las bandas de VHF y UHF no será superior a:],
  ([3 dB], [20 dB], [6 dBd], [10 dB],),
  sol: [La ganancia del sistema radiante de las desatendidas en VHF/UHF no superará los 6 dBd (art. 25.h de la Orden), unos 8,15 dBi: se mide respecto a un dipolo de media onda, no son «6 dB» sin más.])
#pq(10, 2, 19, "b", "F-R8.80", "Servicio secundario: no causa interferencia al primario ni puede reclamar protección; sí frente a secundarios posteriores",
  [Según el Anexo I de la Orden IET/1311/2013, las estaciones de un servicio con categoría secundaria:],
  ([tienen derecho a protección frente a las interferencias de las estaciones de un servicio primario, pero no deben causarles interferencia], [no deben causar interferencia perjudicial a las estaciones de un servicio primario ni pueden reclamar protección frente a las interferencias perjudiciales que estas les causen], [no deben causar interferencia perjudicial a las estaciones de un servicio primario que ya tengan frecuencias asignadas, pero pueden causarla a las que las reciban después], [pueden causar interferencia a las estaciones de un servicio primario siempre que limiten su potencia al 50 % del valor de la tabla],),
  sol: [La categoría de servicio secundario, definida en el Anexo I, tiene tres reglas: no causar interferencia perjudicial a las estaciones de un servicio primario (tengan ya frecuencias asignadas o puedan recibirlas en el futuro), no poder reclamar protección frente a las interferencias de esas estaciones y sí estar protegida frente a otras secundarias posteriores. La a invierte la segunda regla; la c limita la obligación a las primarias ya asignadas, cuando alcanza también a las futuras; la d confunde con el 50 % de potencia que el Anexo I, 3.2, impone en bandas secundarias: es un límite de potencia, no un permiso para interferir. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]])
#pq(10, 2, 20, "a", "F-R8.88", "p.i.r.e. (referencia isótropa) frente a p.r.a. (referencia dipolo)",
  [La potencia isótropa radiada equivalente (p.i.r.e.) es el producto de la potencia suministrada a la antena por:],
  ([su ganancia con relación a una antena isótropa, en una dirección dada], [su ganancia con relación a un dipolo de media onda, en una dirección dada], [su ganancia con relación a una antena vertical corta, en una dirección dada], [su rendimiento, es decir, la relación entre la potencia radiada y la suministrada a la antena],),
  sol: [Anexo I: la p.i.r.e. es el producto de la potencia suministrada a la antena por su ganancia con relación a una antena isótropa (ganancia isótropa o absoluta) en una dirección dada. Con 10 W y una ganancia de 10 dBi (factor 10), la p.i.r.e. es de 100 W. Con el dipolo como referencia se obtiene la p.r.a. (b) y con la vertical corta, la p.r.a.v. (c). El rendimiento no entra en la definición: la ganancia ya descuenta las pérdidas de la antena. #_apc3-ver[(Véase tema T6, sección «El dipolo y otras antenas».)]])
#pq(10, 2, 21, "c", "R8.2", "T/R 61-01 = licencia CEPT (uso temporal); T/R 61-02 = certificado HAREC",
  [La Recomendación CEPT T/R 61-01 se refiere a:],
  ([las señales de socorro y urgencia], [los planes de banda de la Región 1], [el uso temporal de estaciones de aficionado en otros países], [el certificado de examen armonizado HAREC],),
  sol: [T/R 61-01: licencia CEPT, uso temporal de la estación en los países que la aplican.])
#pq(10, 2, 22, "d", "R8.29", "Menores: sin edad mínima; escrito fehaciente de padres o tutores",
  [Para que un menor de edad pueda examinarse y obtener la autorización de radioaficionado:],
  ([debe haber cumplido 14 años], [debe haber cumplido 16 años], [no es posible hasta la mayoría de edad], [no existe límite de edad; sus padres o tutores deberán asumir por escrito las responsabilidades correspondientes],),
  sol: [No hay edad mínima para examinarse; los padres o tutores asumen por escrito las responsabilidades del menor.])
#pq(10, 2, 23, "b", "R8.54", "No es obligatorio disponer de estación fija",
  [Disponer de una estación fija es, para un radioaficionado:],
  ([obligatorio desde el primer año], [no obligatorio], [requisito para renovar la autorización], [obligatorio solo en las capitales de provincia],),
  sol: [Tampoco es obligatorio disponer de estación fija.])
#pq(10, 2, 24, "a", "R8.86", "La estación debe tener elementos para comprobar que la emisión está en banda y medir la potencia",
  [La estación de aficionado debe estar provista de:],
  ([los elementos adecuados para comprobar que la emisión se ajusta a lo autorizado], [un registro escrito de todas las comunicaciones], [un duplicado de los equipos principales], [una línea telefónica independiente],),
  sol: [Anexo I, 4.5: la estación debe tener elementos para comprobar que la emisión se produce dentro de las bandas autorizadas y para medir de forma indicativa la potencia. No se exige medidor de ondas estacionarias ni, en cambio, llevar libro de registro.])
#pq(10, 2, 25, "a", "F-R8.1", "Potencia y duración de las emisiones limitadas a lo estrictamente necesario",
  [Según el apartado 4.2 del anexo I de la Orden IET/1311/2013, deben limitarse a lo estrictamente necesario:],
  ([la potencia emitida y la duración de las emisiones], [únicamente la potencia emitida, sin restricción alguna para la duración], [únicamente la duración de las emisiones, pues la potencia puede ser siempre la máxima de la banda], [la potencia emitida y la duración de las emisiones, pero solo durante los ensayos de equipos],),
  sol: [El apartado 4.2 del anexo I impone dos límites a la vez: la potencia emitida, siempre dentro de los máximos del apartado 3, y la duración de las emisiones deben limitarse a lo estrictamente necesario. No basta con limitar solo una de las dos (b y c), ni la regla se reduce a los ensayos (d): rige siempre. Para los ensayos que no requieren radiación, el apartado 4.3 añade la carga artificial no radiante. El máximo de la banda es un techo, no el valor que hay que usar. #_apc3-ver[(Véase tema T9, sección «Medidas correctoras».)]

#_apc3-net[El anexo I de la Orden IET/1311/2013 (apartado 4.2) establece que la potencia emitida, dentro de los máximos por banda del apartado 3, y la duración de las emisiones deben limitarse a lo estrictamente necesario. No se transmite con toda la potencia autorizada por sistema, ni se ocupa la frecuencia más tiempo del preciso. En los ensayos que no requieran radiar desde la antena, el apartado 4.3 exige una carga artificial no radiante.]])
#pq(10, 2, 26, "a", "C-R8.11", "Solicitud de licencia de estación fija: con memoria descriptiva de la instalación",
  [Para la obtención de la licencia de estación de radioaficionado es necesario presentar:],
  ([Solicitud adjuntando una memoria descriptiva del conjunto de la instalación.], [Un escrito informando que se ha efectuado la instalación.], [La cédula de habitabilidad del inmueble donde se va a instalar.], [Documento que acredite estar inscrito en una asociación de radioaficionados.],),
  sol: [El trámite de la licencia de estación fija tiene dos pasos (arts. 19 y 20 de la Orden IET/1311/2013). Primero, la solicitud con la documentación y la memoria descriptiva del conjunto de la instalación: si es conforme, se autoriza el montaje. Después, terminada la instalación, se comunica en 6 semanas con el justificante del seguro y, en su caso, el boletín del instalador, y se expide la licencia. Lo que hay que presentar para obtenerla es la solicitud con la memoria (a). La b es solo el aviso del segundo paso y por sí sola no basta. La cédula de habitabilidad (c) no figura entre los requisitos, y ser socio de una asociación (d) tampoco es necesario. #vease[(Véase tema R8, sección «Autorización y licencia de estación» (memoria descriptiva).)]

    #no-esta[Procedimiento de la licencia de estación fija: 1) solicitud a la SETSI (o a través de la Jefatura Provincial) con la documentación y la memoria técnica de la instalación (art. 19); 2) resolución que autoriza el montaje, por un instalador de telecomunicaciones, como norma general; 3) fin de la instalación, comunicado en 6 semanas con justificante del seguro y boletín del instalador (art. 20); 4) la Jefatura dispone de 30 días para verificar y expedir la licencia. Las emisiones no pueden comenzar antes de ese último paso.]])
#pq(10, 2, 27, "c", "F-R8.69", "Noveles en estaciones colectivas: supervisor con ≥ 3 años de antigüedad",
  [Según el artículo 30.6 de la Orden IET/1311/2013, las estaciones colectivas pueden ser utilizadas esporádicamente por personas noveles, con fines de divulgación, bajo la responsabilidad y supervisión directa y presencial de un radioaficionado autorizado con una antigüedad mínima en el ejercicio de la radioafición de:],
  ([un año], [dos años], [tres años], [cinco años],),
  sol: [El artículo 30.6.b exige que el uso por noveles se haga bajo la responsabilidad y la supervisión directa y presencial de un radioaficionado autorizado con al menos tres años de antigüedad en el ejercicio de la radioafición. Uno o dos años se quedan cortos. Cinco años es la antigüedad de autorización española que el artículo 27 pide para un sufijo de dos letras: es otro supuesto, sin relación con la divulgación. Recuerda además que el uso debe ser esporádico, en demostraciones, cursos o eventos sin ánimo de lucro y de corta duración (30.6.a). #_apc3-ver[(Véase tema R8, sección «Uso de la estación y otras cuestiones».)]

#_apc3-net[Art. 30.6 de la Orden IET/1311/2013: las estaciones colectivas pueden usarse esporádicamente, con fines de divulgación, por personas noveles en demostraciones en centros de enseñanza, cursos organizados por la asociación titular y eventos similares sin ánimo de lucro y de corta duración. Condiciones: supervisión directa y presencial de un radioaficionado con al menos tres años de antigüedad; identificación con el distintivo de la colectiva seguido, tras el sufijo, de dos o tres letras libres; y potencia no superior al 40 % del máximo de la banda, con tope de 100 W (p.i.r.e.).]])
#pq(10, 2, 28, "a", "R9.8", "Inspección: el Ministerio competente, mediante la inspección de telecomunicaciones y las Jefaturas Provinciales",
  [La inspección de los equipos y estaciones del servicio de aficionados corresponde a:],
  ([el Ministerio competente en telecomunicaciones, a través de la inspección de telecomunicaciones y sus Jefaturas Provinciales], [las asociaciones de radioaficionados legalmente reconocidas], [los ayuntamientos], [las comunidades de propietarios],),
  sol: [La inspección corresponde al Ministerio competente en telecomunicaciones, con las Jefaturas Provinciales como brazo territorial.])
#pq(10, 2, 29, "d", "R9.16", "Potestad sancionadora: Administración General del Estado (titular de la Secretaría de Estado de Telecomunicaciones)",
  [La potestad sancionadora en materia de radiocomunicaciones corresponde a:],
  ([la comunidad autónoma donde radique la estación], [el ayuntamiento del municipio], [la asociación de radioaficionados a la que pertenezca el titular], [la Administración General del Estado],),
  sol: [El dominio público radioeléctrico es competencia estatal, y con él la inspección y la sanción. Ni comunidades autónomas ni ayuntamientos tienen nada que decir sobre las emisiones.])
#pq(10, 2, 30, "a", "F-R9.5", "Plazo mínimo de alegaciones: quince días hábiles",
  [Según el art. 114.2 de la Ley 11/2022, en el procedimiento sancionador en materia de telecomunicaciones el plazo de alegaciones es, como mínimo, de:],
  ([quince días hábiles], [diez días naturales], [diez días hábiles], [quince días naturales],),
  sol: [El art. 114.2 dice que el plazo de alegaciones será como mínimo de quince días hábiles, y que el procedimiento debe resolverse en un año. «Como mínimo» significa que la Administración puede conceder más tiempo, pero no menos. Las dos opciones de diez días quedan por debajo del mínimo legal, y quince días naturales dan menos tiempo que quince hábiles, de modo que tampoco lo cumplen. #_apc3-ver[(Véase capítulo R9, «Inspección y régimen sancionador».)]

#_apc3-net[En el procedimiento sancionador de telecomunicaciones se aplica el procedimiento administrativo común (Ley 39/2015), con dos plazos propios que fija el art. 114.2 de la Ley 11/2022: las alegaciones disponen como mínimo de quince días hábiles, y el procedimiento debe resolverse en un año.]])
#fin-prueba()
#soluciones-simulacro(10)

// ======================================================================
#simulacro(11)
#prueba(11, 1)
#pq(11, 1, 1, "b", "T1.17", "Longitud de onda: λ = c / f, λ (m) ≈ 300 / f (MHz)",
  [La longitud de onda correspondiente a una frecuencia de 145 MHz es aproximadamente:],
  ([0,5 m], [2 m], [20 m], [70 cm],),
  sol: [$lambda = c slash f = (3 times 10^8) slash (145 times 10^6) approx 2,07$ m: la banda de 2 metros. El distractor de 70 cm corresponde a 430 MHz.])
#pq(11, 1, 2, "d", "C-T1.23", "Valor eficaz: definición por el efecto calorífico; la tensión de red se da en eficaz",
  [La tensión de alimentación suministrada comúnmente es de 220 V, que es el valor:],
  ([Trifásico de la tensión], [Medio de la tensión], [Máximo de la tensión], [Eficaz de la tensión],),
  sol: [
    La tensión de red se da por su valor eficaz: el de la continua que produciría en una resistencia
    el mismo calor. Los voltímetros de alterna miden valor eficaz, y los 220 V de la red doméstica
    lo son. El valor máximo (de pico) es mayor: $220 sqrt(2) ≈ 311$ V. El valor medio de una
    sinusoide completa es cero, porque las dos semiondas se anulan. «Trifásico» no es un valor de la
    tensión, sino un tipo de sistema de distribución con tres fases. #vease[(Véase tema T1, sección
    «Ondas y señales».)]
    #no-esta[El texto define el valor eficaz pero no dice que la red lo use. Toda tensión de red se
    especifica en valor eficaz: la nominal oficial es 230 V (antes 220 V). Como
    $V_("ef") = V_0 slash sqrt(2)$, el pico es $V_0 = V_("ef") sqrt(2)$: unos 311 V para 220 V y 325
    V para 230 V, y la tensión de pico a pico es el doble. Se prefiere el valor eficaz porque así la
    potencia en una resistencia se calcula con las mismas fórmulas que en continua.]
  ])
#pq(11, 1, 3, "a", "T1.35", "Factor de potencia: coseno del desfase entre tensión y corriente",
  [En una instalación de corriente alterna, el llamado «factor de potencia» o $cos phi$ es:],
  ([el coseno del ángulo de desfase entre la tensión y la corriente], [la proporción de armónicos de la señal], [el número de ciclos por segundo de la corriente], [la relación entre la tensión y la corriente (la impedancia)],),
  sol: [En alterna, si hay reactancias la corriente no va al compás de la tensión, y solo la parte en fase produce potencia útil. El factor de potencia es el coseno del ángulo de desfase $phi$ (no el desfase mismo): $cos phi = P slash S$, cociente entre la potencia activa (la que se consume) y la aparente ($V I$). Vale 1 en un circuito resistivo puro y baja según crece la componente reactiva. La relación tensión/corriente es la impedancia.])
#pq(11, 1, 4, "d", "F-T1.21", "Espectro de AM: portadora y dos bandas laterales en f_c ± f_m",
  [Una portadora de 3,700 MHz modulada en AM por un tono de 1 kHz produce un espectro con rayas en:],
  ([3,690, 3,700 y 3,710 MHz], [3,700 y 3,701 MHz], [3,699 y 3,701 MHz solamente], [3,699, 3,700 y 3,701 MHz],),
  sol: [El espectro de una AM tiene tres rayas: la portadora y dos bandas laterales en $f_c plus.minus f_m$. Aquí $f_m = 1$ kHz = 0,001 MHz, luego 3,700 − 0,001 = 3,699 MHz y 3,700 + 0,001 = 3,701 MHz, además de la portadora en 3,700 MHz. Con 3,690 y 3,710 MHz se confunde 1 kHz con 10 kHz. Sin portadora sería doble banda con portadora suprimida, no AM. Portadora más una sola banda se parece a la SSB con portadora, no a la AM. _(Véase tema T1, sección «Señales moduladas».)_])
#pq(11, 1, 5, "a", "T2.38", "Varistor (VDR): su resistencia depende de la tensión aplicada; protege contra sobretensiones",
  [Una resistencia cuyo valor óhmico depende de la tensión aplicada entre sus extremos se denomina:],
  ([varistor], [termistor], [potenciómetro], [reóstato],),
  sol: [El varistor (o VDR) baja bruscamente su resistencia al superarse cierta tensión, y por eso se usa como protector contra sobretensiones. El termistor depende de la temperatura, y el potenciómetro se ajusta a mano.])
#pq(11, 1, 6, "c", "T2.54", "Electrolítico: uso principal en el filtrado de fuentes de alimentación (no en RF)",
  [Los condensadores electrolíticos se emplean principalmente:],
  ([como elemento de acoplo entre etapas de RF], [en los circuitos resonantes de radiofrecuencia], [en el filtrado de las fuentes de alimentación], [en las antenas],),
  sol: [Su gran capacidad los hace idóneos para alisar el rizado tras el rectificador, donde además la polaridad es fija y conocida. En radiofrecuencia no sirven: su comportamiento a alta frecuencia es pésimo.])
#pq(11, 1, 7, "c", "T2.40", "La autoinducción depende de la construcción de la bobina (núcleo, dimensiones, temperatura), no de la señal",
  [Al introducir un núcleo de material ferromagnético en el interior de una bobina, su autoinducción:],
  ([se anula], [no varía], [aumenta], [disminuye],),
  sol: [El núcleo ferromagnético concentra las líneas de campo y multiplica el flujo para la misma corriente, de modo que la autoinducción crece con la permeabilidad del material. Es lo que permite hacer bobinas de gran valor sin un número enorme de espiras.])
#pq(11, 1, 8, "d", "T2.19", "Cálculo de la tensión del secundario: V_s = V_p · N_s/N_p",
  [Un transformador ideal tiene una relación de espiras primario/secundario de 20:1. Si se aplican 230 V al primario, la tensión en el secundario es:],
  ([46 V], [4600 V], [23 V], [11,5 V],),
  sol: [$V_s = V_p dot N_s slash N_p = 230 slash 20 = 11,5$ V. El distractor de 4600 V invierte la relación.])
#pq(11, 1, 9, "a", "C-T3.5", "Acoplo entre circuitos y etapas: las oscilaciones de uno pasan al otro; el acoplamiento deja pasar la señal y separa las polarizaciones",
  [Se dice que dos circuitos están acoplados cuando:],
  ([Las oscilaciones presentes en uno de ellos se transmiten al otro], [Las dimensiones de ambos se adaptan perfectamente], [Tienen la misma frecuencia], [Las oscilaciones de ambos están en resonancia],),
  sol: [
    Dos circuitos están acoplados cuando existe entre ellos un camino por el que la energía de las
    oscilaciones de uno pasa al otro: un campo magnético común (un transformador son dos bobinas
    acopladas), un condensador, una resistencia común o la radiación. No hace falta que tengan la
    misma frecuencia ni que estén en resonancia —aunque la transferencia es más eficaz si lo están—,
    y tampoco que sus dimensiones «se adapten»: lo que define el acoplo es que las oscilaciones de
    uno se transmiten al otro. #vease[(Véase tema T2, sección «Transformadores».)]
    #no-esta[El acoplo es la forma de pasar la señal de un circuito o etapa al siguiente. Puede ser por
    inductancia mutua (dos bobinas que comparten flujo, como en un transformador), capacitivo (un
    condensador en serie, el «condensador de acoplo») o directo (por una resistencia o un hilo).
    Cuanto más fuerte es el acoplo, más energía se transfiere; con acoplo flojo pasa poca y cada
    circuito conserva casi su frecuencia propia. El acoplo no deseado entre circuitos se llama
    acoplo parásito.]
  ])
#pq(11, 1, 10, "d", "T3.41", "Frecuencia de corte: separa banda de paso y de atenuación; se toma a −3 dB",
  [La frecuencia de corte de un filtro es:],
  ([la frecuencia de resonancia de su bobina], [la frecuencia a la que el filtro deja de funcionar], [la frecuencia máxima que soporta sin dañarse], [la frecuencia que delimita la banda de paso de la de atenuación],),
  sol: [Es la frontera del filtro, y por convenio se sitúa donde la respuesta ha caído 3 dB. Por encima o por debajo de ella —según el tipo— la señal empieza a atenuarse de verdad.])
#pq(11, 1, 11, "a", "T3.36", "Función del filtro de la fuente: eliminar la componente alterna (rizado) que queda tras rectificar, no la continua",
  [El filtro que sigue al rectificador en una fuente de alimentación tiene por objeto eliminar:],
  ([la componente alterna que queda tras la rectificación], [la componente continua de la señal], [los armónicos de radiofrecuencia], [la corriente de fuga de los diodos],),
  sol: [A la salida del rectificador hay una tensión pulsante: continua con un fuerte rizado. El condensador sostiene la tensión entre picos y alisa esa componente alterna residual. Lo que no debe tocar es la continua, que es precisamente lo que se busca.])
#pq(11, 1, 12, "c", "T3.26", "Bloques de una fuente lineal y su orden: transformador → rectificador → filtro → regulador (reconocer el esquema)",
  [El orden correcto de las etapas de una fuente de alimentación lineal es:],
  ([regulador, filtro, rectificador y transformador], [filtro, transformador, rectificador y regulador], [transformador, rectificador, filtro y regulador], [rectificador, transformador, regulador y filtro],),
  sol: [Se sigue el camino de la energía: primero se baja la tensión de red, después se rectifica la alterna, luego el condensador alisa el rizado y por último el regulador fija la tensión de salida. Cualquier otro orden no tendría sentido físico — no se puede filtrar el rizado antes de crearlo.])
#pq(11, 1, 13, "c", "F-T3.24", "Bloques del PLL: comparador de fase, filtro de paso bajo (de lazo), VCO y divisor programable",
  [Los bloques básicos de un lazo de enganche de fase (PLL) son:],
  ([un modulador, un amplificador de potencia y una antena], [un rectificador, un filtro de alisado y un regulador de tensión], [un comparador de fase, un filtro de paso bajo y un oscilador controlado por tensión], [un mezclador, un filtro de FI y un detector de envolvente],),
  sol: [El comparador de fase mide la diferencia de fase entre la referencia y la señal del VCO (dividida por $N$ en un sintetizador) y entrega una tensión de error. El filtro de paso bajo la alisa y la convierte en la tensión de control continua con la que el VCO corrige su frecuencia. Cerrado el lazo, el VCO queda «enganchado» a la referencia. Las otras opciones son cadenas de otros circuitos: el receptor superheterodino, una fuente de alimentación y un transmisor. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_
#_apc1-noest[Un PLL es un lazo cerrado de cuatro bloques: el comparador de fase, que compara la referencia con la salida del VCO (dividida por $N$ en un sintetizador) y entrega una tensión de error; el filtro de lazo, de paso bajo, que la alisa; el VCO, que cambia su frecuencia con esa tensión de control; y el divisor programable, que divide la salida del VCO antes del comparador.]])
#pq(11, 1, 14, "d", "T4.31", "La selectividad la fijan las etapas (filtros) de FI; la FI son amplificadores y filtros",
  [La selectividad de un receptor superheterodino depende principalmente de:],
  ([la longitud de la línea de antena], [la impedancia de salida], [la ganancia del amplificador de audio], [las etapas de frecuencia intermedia],),
  sol: [Los filtros de FI son los que deciden qué anchura de banda pasa y con qué pendiente se cortan las señales vecinas. La sintonía de entrada apenas discrimina entre canales próximos.])
#pq(11, 1, 15, "a", "T4.22", "Mando RF GAIN: ganancia de las etapas de RF del receptor (no la potencia del emisor)",
  [Actuando sobre el mando «RF GAIN» de un receptor se modifica:],
  ([la ganancia de las etapas de radiofrecuencia], [el volumen del altavoz], [la anchura del filtro de frecuencia intermedia], [la frecuencia del oscilador local],),
  sol: [Reduce la amplificación de las primeras etapas. Con señales muy fuertes conviene bajarlo para no saturar la entrada y evitar la intermodulación; el volumen, en cambio, actúa al final de la cadena, sobre el audio.])
#pq(11, 1, 16, "b", "C-T5.29", "Funciones mínimas de un transmisor: generar, modular y amplificar",
  [Un transmisor debe realizar al menos las siguientes funciones:],
  ([Generar la señal, demodular y amplificar.], [Generar la señal, modular y amplificar.], [Generar la señal, modular y demodular.], [Entregar una señal útil a partir de la recogida en la antena.],),
  sol: [
    Un transmisor genera la señal de radiofrecuencia (oscilador), la modula con la información (voz,
    datos, manipulación Morse) y la amplifica hasta la potencia que entregará a la antena. Demodular
    es extraer la información de una señal modulada, y eso lo hace el receptor: por eso a) y c) son
    falsas. La opción d) describe justamente al receptor, que entrega una señal útil (audio) a
    partir de la captada por la antena. #vease[(Véase tema T5, sección «Arquitecturas y
    características generales».)]
  ])
#pq(11, 1, 17, "b", "C-T5.31", "Diagrama de bloques del transmisor de BLU (BF, modulador balanceado, filtro, RF)",
  [El esquema de un transmisor básico para banda lateral única se corresponde con la figura:],
  ([#_apb1-tx([etapa\ BF], [modulador\ de fase], [filtro], [amplificador\ RF])], [#_apb1-tx([etapa\ BF], [modulador\ balanceado], [filtro], [amplificador\ RF])], [#_apb1-tx([etapa\ BF], [modulador\ balanceado], [modulador\ de fase], [amplificador\ RF])], [#_apb1-tx([etapa\ RF], [modulador\ balanceado], [filtro], [amplificador\ BF])],),
  sol: [
    Un transmisor de BLU amplifica en BF la voz del micrófono; un modulador balanceado, con el
    oscilador de portadora, suprime la portadora y deja las dos bandas laterales; un filtro elimina
    una de ellas; un mezclador con el oscilador variable traslada la banda restante a la frecuencia
    de trabajo y el amplificador de RF la lleva a la antena. Eso es la figura b. La a usa un
    modulador de fase, propio de la FM. En la c otro modulador de fase ocupa el puesto del filtro y
    las dos bandas siguen presentes. En la d están cambiadas las etapas: RF junto al micrófono y BF
    antes de la antena. #vease[(Véase tema T5, sección «Arquitecturas y características
    generales».)]
  ])
#pq(11, 1, 18, "b", "T5.4", "Filtro de salida (paso bajo) y red de acoplo entre el final y la antena: eliminan armónicos y adaptan",
  [El filtro de salida de un transmisor tiene como misión:],
  ([amplificar la señal moduladora], [eliminar las frecuencias no deseadas], [estabilizar la frecuencia del oscilador], [aumentar la potencia radiada],),
  sol: [El filtro de salida (paso bajo en HF) atenúa armónicos y productos no deseados antes de la antena.])
#pq(11, 1, 19, "b", "T6.1", "Longitud del dipolo de media onda (≈ λ/2: 20 m para la banda de 40 m) y tamaño de la antena en función de la longitud de onda",
  [La longitud total aproximada de un dipolo de media onda para la banda de 40 metros es de:],
  ([10 m], [20 m], [40 m], [80 m],),
  sol: [Las bandas se nombran por su longitud de onda: «40 m» significa $lambda approx 40$ m, luego el dipolo de media onda mide $lambda\/2 approx 20$ m (algo menos por el factor de acortamiento). El distractor de 40 m confunde la longitud de la antena con el nombre de la banda.])
#pq(11, 1, 20, "a", "T6.36", "Impedancia del dipolo de media onda alimentado en el centro: ≈ 73 Ω",
  [La impedancia que presenta en su punto de alimentación un dipolo de media onda en resonancia, situado en el espacio libre, es aproximadamente de:],
  ([73 ohmios], [300 ohmios], [600 ohmios], [50 ohmios],),
  sol: [Ese valor teórico de unos 73 ohmios es lo que hace que el coaxial de 50 o de 75 ohmios sea una elección razonable para alimentarlo. Los 300 ohmios son los del dipolo plegado, y los 600, los de una línea bifilar abierta.])
#pq(11, 1, 21, "c", "F-T6.16", "Media onda alimentada en un extremo: impedancia muy alta (miles de ohmios)",
  [Una antena de media onda alimentada por uno de sus extremos presenta en el punto de alimentación una impedancia:],
  ([de unos 300 Ω, cuatro veces la del centro], [de unos 73 Ω, igual que si se alimentara por el centro], [muy alta, de varios miles de ohmios], [de unos 36 Ω, la mitad que alimentada por el centro],),
  sol: [En los extremos de una antena de media onda la corriente es nula y la tensión máxima. La impedancia es el cociente $Z = V slash I$: mucha tensión y muy poca corriente dan un valor enorme, de miles de ohmios (en el centro ocurre lo contrario y salen $tilde.op$73 Ω). Por eso una media onda alimentada en un extremo no puede conectarse directamente a 50 Ω: necesita un adaptador de impedancias, como un circuito sintonizado o un transformador. Los 36 Ω son los de la vertical de cuarto de onda, y los 300 Ω, los del dipolo plegado. #vease[(Véase tema T6, sección «El dipolo y otras antenas».)]])
#pq(11, 1, 22, "d", "F-T6.20", "El cuarto de onda invierte la impedancia: en cortocircuito se ve como resonante paralelo; abierto, como serie",
  [Una línea de cuarto de onda cortocircuitada en su extremo se comporta, vista desde el otro extremo, como:],
  ([un condensador puro], [una resistencia igual a la impedancia característica], [un circuito resonante serie, de impedancia muy baja], [un circuito resonante paralelo, de impedancia muy alta],),
  sol: [La línea de cuarto de onda invierte la impedancia: $Z_"ent" = Z_0^2 slash Z_L$ y, con $Z_L -> 0$, $Z_"ent" -> infinity$. En el extremo cortocircuitado la tensión es nula y la corriente máxima; al desfasar 90°, en la entrada hay tensión máxima y corriente mínima. Un circuito resonante paralelo presenta justo eso en resonancia: impedancia máxima. Por eso un tramo así actúa como aislante metálico o como filtro. El comportamiento serie (impedancia mínima) es el de la línea abierta. #vease[(Véase tema T6, sección «Líneas de transmisión y adaptación».)]])
#pq(11, 1, 23, "b", "T7.1", "Capas de la ionosfera: D, E, F1 y F2",
  [Las capas ionizadas de la atmósfera se denominan:],
  ([A, B y C], [D, E, F1 y F2], [alfa, beta y gamma], [troposfera y estratosfera],),
  sol: [Capas D, E, F1 y F2 (la figura del libro); de noche la D desaparece y F1 y F2 se funden en una sola capa F.])
#pq(11, 1, 24, "d", "C-T7.10", "Onda espacial (de espacio): la que rebasa el horizonte, sube a la ionosfera y vuelve",
  [La onda que rebasa el horizonte y llega a la atmósfera se denomina:],
  ([onda de horizonte visto], [onda de transmisión directa], [onda especial indirecta], [onda espacial],),
  sol: [
    La onda espacial (en este cuaderno, onda de espacio) sale de la antena hacia arriba, rebasa el
    horizonte, alcanza la ionosfera y regresa a tierra por refracción en ella; es la del DX en HF.
    La onda directa viaja en visión directa y no pasa del horizonte radioeléctrico. «Onda de
    horizonte visto» y «onda especial indirecta» no son tipos de propagación; ojo con «especial»,
    que no es «espacial». #vease[(Véase tema T7, sección «La ionosfera y la onda de espacio».)]
  ])
#pq(11, 1, 25, "c", "F-T7.18", "El conducto troposférico se forma con una inversión térmica (aire cálido sobre aire frío)",
  [Un conducto troposférico se forma cuando en la troposfera existe:],
  ([una capa de aire frío sobre otra de aire cálido, como ocurre habitualmente], [una nube de ionización intensa en la capa E], [una inversión de temperatura: una capa de aire cálido situada sobre aire más frío], [una intensa actividad de manchas solares],),
  sol: [En condiciones normales el aire se enfría con la altura. En una inversión de temperatura, una capa de aire cálido queda sobre aire más frío, y el cambio brusco del índice de refracción curva la onda hacia el suelo una y otra vez: queda atrapada entre la capa y la superficie, como en una guía de ondas. La situación habitual (a) no forma conductos. Las nubes de ionización de la capa E (b) son la esporádica-E, un fenómeno ionosférico, y las manchas solares (d) actúan sobre la ionosfera, no sobre la troposfera. #vease[(Véase tema T7, sección «Fenómenos de propagación».)] #no-esta[Una inversión de temperatura se da cuando, en vez de enfriarse con la altura, el aire se calienta: una capa de aire cálido queda sobre aire más frío, cerca del suelo. El cambio brusco en el índice de refracción del aire curva la onda hacia la Tierra y la mantiene atrapada entre la capa y la superficie, igual que en una guía de ondas. Así nace la propagación por conducto, que lleva las señales de VHF y UHF a cientos de kilómetros.]])
#pq(11, 1, 26, "c", "C-T8.10", "Qué instrumento mide cada magnitud básica (voltímetro: tensión; amperímetro: corriente)",
  [Para medir la tensión (diferencia de potencial) eléctrica se emplea:],
  ([un vatímetro], [un óhmetro], [un voltímetro], [un amperímetro],),
  sol: [
    La tensión o diferencia de potencial se mide en voltios con un voltímetro, conectado en paralelo
    con el elemento. El amperímetro mide corriente (amperios), el óhmetro resistencia (ohmios) y el
    vatímetro potencia (vatios). #vease[(Véase tema T8, sección «Técnica de medida».)]
  ])
#pq(11, 1, 27, "b", "T8.29", "El medidor de ROE es el instrumento más imprescindible de la estación",
  [De los siguientes instrumentos, el más imprescindible en una estación de aficionado es:],
  ([el puente de impedancias de laboratorio], [el medidor de relación de ondas estacionarias], [el generador de barrido], [el analizador de espectro],),
  sol: [Es el instrumento que avisa de que algo va mal entre el equipo y la antena, que es de donde vienen la mayoría de los problemas —y de las averías del final de potencia—. Los demás son de laboratorio: útiles, pero no imprescindibles.])
#pq(11, 1, 28, "a", "T9.17", "Remedio del bloqueo y de la TVI: filtro en la entrada del equipo afectado (problema de inmunidad)",
  [Una interferencia a la recepción de televisión (TVI) provocada por una señal fuerte fuera de su banda se combate eficazmente:],
  ([instalando un filtro de rechazo en la entrada de antena del televisor], [cambiando la polarización de la antena del televisor], [aumentando la potencia del transmisor de aficionado], [sustituyendo el cable de red del televisor],),
  sol: [Si la estación cumple con sus emisiones no deseadas, el problema es de _inmunidad_ del televisor: su entrada admite una señal que no le corresponde. El remedio está en el lado del receptor afectado, con un filtro que rechace la banda del aficionado.])
#pq(11, 1, 29, "a", "T10.20", "Lo que daña es la corriente: intensidad, recorrido y duración",
  [La peligrosidad de una descarga eléctrica sobre el cuerpo humano depende principalmente de:],
  ([la intensidad que lo atraviesa, su recorrido y su duración], [la potencia contratada en la vivienda], [la frecuencia de resonancia del circuito], [el color del aislante del conductor],),
  sol: [Lo que daña es la corriente, no la tensión por sí sola. Y el recorrido importa tanto como el valor: el trayecto mano-mano o mano-pie atraviesa el corazón, que es lo que convierte unas décimas de amperio en un accidente mortal.])
#pq(11, 1, 30, "c", "T10.12", "Magnetotérmico: sobrecargas y cortocircuitos",
  [Un interruptor magnetotérmico protege la instalación frente a:],
  ([las variaciones de la tensión de red], [las interferencias de radiofrecuencia], [las sobrecargas y los cortocircuitos], [las fugas de corriente a tierra],),
  sol: [Su nombre describe los dos mecanismos: el térmico actúa despacio ante una sobrecarga sostenida y el magnético, de forma instantánea, ante un cortocircuito. Hace lo mismo que un fusible, pero se rearma.])
#fin-prueba()
#prueba(11, 2)
#pq(11, 2, 1, "c", "R1.40", "U Uniform y Z Zulu frente a palabras de alfabetos antiguos (Uncle, Zebra, Coca, Dog, Able)",
  [El distintivo `EC9ZUL` se deletrea:],
  ([Echo Coca Nine Zebra Uncle Lima], [España Carmen Nine Zaragoza Ulises Lima], [Echo Charlie Nine Zulu Uniform Lima], [Eco Charlie Nine Zeta Unión Luis],),
  sol: [Letra por letra con el alfabeto internacional y la cifra con su nombre inglés: _Echo Charlie Nine Zulu_ _Uniform Lima_. Las demás mezclan palabras de alfabetos nacionales o antiguos (_Carmen_, _Coca_, _Uncle_, _Zebra_, _Luis_…) o escriben «Eco» y «Zeta».])
#pq(11, 2, 2, "c", "R1.22", "H Hotel y K Kilo",
  [En el alfabeto fonético internacional, la letra «H» se deletrea:],
  ([Hotel Alfa], [Habana], [Hotel], [Historia],),
  sol: [_Hotel_, una sola palabra por letra. Encadenar dos —«Hotel Alfa»— sería deletrear HA, no H.])
#pq(11, 2, 3, "c", "R2.33", "QRV estoy dispuesto frente a QRU no tengo nada para usted",
  [Para indicar que se está dispuesto y preparado para recibir se emplea el grupo:],
  ([`QRU`], [`QRX`], [`QRV`], [`QRQ`],),
  sol: [`QRV` es «estoy dispuesto». `QRU` es «no tengo nada para usted», que se parece en la forma pero significa casi lo contrario.])
#pq(11, 2, 4, "b", "F-R2.4", "QSZ transmita cada palabra o grupo dos veces",
  [El grupo #_apc2-m[QSZ] se emplea para pedir que:],
  ([se anule el mensaje], [cada palabra o grupo se transmita dos veces (o las que se indiquen)], [se repita el último mensaje], [se transmita más despacio],),
  sol: [#_apc2-m[QSZ] pide que cada palabra o grupo se transmita dos veces (o las veces que se indiquen); con interrogación, «¿debo transmitir cada palabra o grupo más de una vez?». Los distractores son otros grupos de las tablas: #_apc2-m[QRS] (transmita más despacio), #_apc2-m[QSM] (repita el último mensaje) y #_apc2-m[QTA] (anule el mensaje). La diferencia con #_apc2-m[QSM]: este repite el mensaje ya enviado y #_apc2-m[QSZ] duplica cada palabra o grupo. #no-esta[Otro grupo Q que no figura en las tablas es #_apc2-m[QSZ]: «¿debo transmitir cada palabra o grupo más de una vez?». Como consigna significa «transmita cada palabra o grupo dos veces (o el número de veces que se indique)». No es #_apc2-m[QSM], que pide repetir el último mensaje ya enviado, ni #_apc2-m[QRS], que pide ir más despacio.]])
#pq(11, 2, 5, "a", "R3.15", "BK interrupción breve (break)",
  [La abreviatura `BK` se emplea para:],
  ([interrumpir brevemente la transmisión del corresponsal], [señalar el comienzo de una llamada general], [indicar que se cambia de banda], [pedir que se repita la última palabra],),
  sol: [Del inglés _break_. Permite cortar sin esperar al final, algo que en telegrafía facilita el `QSK`. El comienzo de una llamada general es `CQ`.])
#pq(11, 2, 6, "d", "F-R3.4", "La T (tono) solo se da en telegrafía: 59 en fonía, 599 en CW",
  [En fonía el informe de señal se da con dos cifras (por ejemplo, «59»); en telegrafía se añade una tercera («599»), que valora:],
  ([la velocidad de manipulación], [la potencia del transmisor], [el desvanecimiento de la señal], [el tono de la señal],),
  sol: [El informe #_apc2-m[RST] tiene tres cifras: legibilidad (R), intensidad (S) y tono (T). El tono solo tiene sentido en telegrafía, donde se escucha una nota que puede llevar zumbido o modulación (el 9 es el tono perfecto); por eso en fonía se dan solo R y S («59») y en telegrafía las tres («599»). La velocidad de manipulación se mide en palabras por minuto y no forma parte del informe; el desvanecimiento es #_apc2-m[QSB]\; y la potencia no la valora el corresponsal. #vease[(Véase tema R3, tabla «Abreviaturas de procedimiento más habituales» (#_apc2-m[RST]).)] #no-esta[Informe #_apc2-m[RST]: *R*, legibilidad (1 a 5); *S*, intensidad (1 a 9); *T*, tono (1 a 9). En fonía solo se dan las dos primeras cifras («59»); en telegrafía se añade el tono («599»), porque solo allí hay una nota que valorar. El 9 de tono significa tono perfecto, sin zumbido ni modulación. «599» es el informe máximo.]])
#pq(11, 2, 7, "b", "R3.18", "PSE por favor",
  [La abreviatura `PSE` corresponde a:],
  ([posición estimada], [por favor], [pausa entre transmisiones], [potencia de salida efectiva],),
  sol: [Contracción del inglés _please_. Es una de las abreviaturas de cortesía que, junto con `TNX`, aparecen constantemente en telegrafía.])
#pq(11, 2, 8, "c", "C-R3.1", "FB buen trabajo, formidable (fine business)",
  [La abreviatura FB significa:],
  ([Oficina.], [Hasta luego.], [Buen trabajo, formidable.], [Frecuencia.],),
  sol: [FB viene del inglés #emph[fine business] y se emplea con el sentido de «buen trabajo», «formidable», «excelente»: se aplica a una señal, a un equipo o a un contacto. «Hasta luego» se abrevia CUL (#emph[see you later]). «Frecuencia» y «oficina» no son significados de FB.

    #no-esta[FB (del inglés #emph[fine business]) es una abreviatura de elogio: «buen trabajo», «formidable», «excelente». Se oye en expresiones como «FB señal» o «FB QSO». No figura en las tablas del cuaderno. Conviene distinguirla de otras abreviaturas de cortesía: CUL (#emph[see you later]) es «hasta luego», TNX es «gracias» y 73 son «saludos cordiales».]])
#pq(11, 2, 9, "d", "R4.7", "Socorro en radiotelegrafía: SOS (no XXX, TTT ni CQD)",
  [La señal de socorro en radiotelegrafía es:],
  ([CQD], [TTT], [XXX], [SOS],),
  sol: [`SOS`: socorro en telegrafía; `CQD` es la señal antigua abandonada a principios del siglo XX.])
#pq(11, 2, 10, "a", "F-R4.5", "Canal 16 de VHF marítima: 156,8 MHz (socorro, seguridad y llamada en voz)",
  [La frecuencia internacional de socorro, seguridad y llamada en radiotelefonía de la VHF marítima (canal 16) es:],
  ([156,8 MHz], [243 MHz], [121,5 MHz], [156,525 MHz],),
  sol: [El canal 16 de la VHF marítima, 156,8 MHz, es la frecuencia internacional de socorro, seguridad y llamada en radiotelefonía (nota 5.226 del Reglamento de Radiocomunicaciones). 156,525 MHz es el canal 70, dedicado a la llamada selectiva digital (DSC), no a la voz. 121,5 MHz es la frecuencia aeronáutica de emergencia (nota 5.200) y 243 MHz se destina a dispositivos de salvamento (nota 5.256). En MF, el equivalente de la voz es 2182 kHz. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)] #no-esta[En el servicio móvil marítimo, las frecuencias internacionales de socorro son: en MF, 2182 kHz para la voz y 2187,5 kHz para la alerta por llamada selectiva digital (DSC); en VHF, el canal 16 (156,8 MHz) para la voz y el canal 70 (156,525 MHz) para la alerta DSC. La aviación usa 121,5 MHz como frecuencia de emergencia y los dispositivos de salvamento, 243 MHz. Ninguna cae dentro de las bandas de aficionados.]])
#pq(11, 2, 11, "d", "F-R4.11", "Aficionados por satélite: solo en las bandas atribuidas al efecto en el CNAF",
  [Según la Orden IET/1311/2013, las emisiones del Servicio de Aficionados por Satélite quedan restringidas a:],
  ([las bandas que requieren autorización especial de la SETSI], [cualquier banda atribuida al Servicio de Aficionados], [las bandas de VHF y UHF únicamente], [las bandas atribuidas al efecto en el CNAF],),
  sol: [El art. 5.3 de la Orden habilita para emitir en las bandas del Servicio de Aficionados y del Servicio de Aficionados por Satélite, pero las emisiones de este último quedan restringidas a las bandas atribuidas al efecto en el CNAF. No toda banda de aficionado admite satélites: 80 m (3500–3800 kHz) no, mientras que 7000–7100 kHz, 14000–14250 kHz o 144–146 MHz sí; por eso «cualquier banda» es falso, y «VHF y UHF únicamente» también, pues el CNAF atribuye a satélite tramos de HF. La autorización especial (art. 16) es otra cosa: bandas secundarias con riesgo de interferencia. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)] #no-esta[Según el art. 5.3 de la Orden IET/1311/2013, la autorización de radioaficionado habilita para emitir en las bandas atribuidas al Servicio de Aficionados y al Servicio de Aficionados por Satélite, pero las emisiones de este último quedan restringidas a las bandas atribuidas al efecto en el CNAF. No toda banda de aficionado admite satélites: 80 m no; 7000–7100 kHz, 14000–14250 kHz y 144–146 MHz sí.]])
#pq(11, 2, 12, "b", "R5.7", "Hay nueve distritos geográficos (1 a 9); el 0 es especial",
  [El número total de distritos en que se dividen los indicativos de llamada españoles es:],
  ([ocho], [nueve], [diez], [siete],),
  sol: [Nueve distritos (1 a 9); el 0 es un caso especial reservado.])
#pq(11, 2, 13, "c", "C-R5.8", "Excepciones de distrito: Albacete es del 5 y La Rioja del 1",
  [Una estación de aficionado ubicada en la provincia de Albacete se identifica por la cifra:],
  ([2], [7], [5], [6],),
  sol: [Albacete pertenece al distrito 5, con Valencia, Alicante, Castellón y Murcia (art. 27 de la Orden IET/1311/2013). Es la excepción de Castilla-La Mancha: el resto de sus provincias son del 4. El 7 es Andalucía, el 6 las Illes Balears y el 2 el País Vasco, Navarra y Aragón. Si la pregunta se formula al revés (¿cuál de Almería, Albacete, Álava y Ávila es del distrito 5?), la respuesta es la misma: Albacete; Almería es del 7, Álava del 2 y Ávila del 1. #vease[(Véase tema R5, tabla «Distritos de los distintivos de llamada españoles».)]])
#pq(11, 2, 14, "a", "R5.20", "Estaciones colectivas: distintivo propio; sufijos UR (asociaciones), RC y RK (radioclubes)",
  [Los sufijos de tres letras que comienzan por `UR`, `RC` o `RK` están reservados para:],
  ([estaciones colectivas de asociaciones de radioaficionados y radio clubes], [concursos internacionales], [estaciones automáticas desatendidas], [estaciones móviles marítimas],),
  sol: [UR, RC y RK inician los sufijos de las estaciones colectivas: UR, los de asociaciones de radioaficionados, y RC y RK, los de radio clubes, «respectivamente» (art. 27.3). No confundir con las desatendidas, que usan Y/Z.])
#pq(11, 2, 15, "b", "C-R6.4", "Qué es un plan de bandas: reparto recomendado de cada banda por modo y anchura de banda; instrumento básico de ordenación",
  [Los planes de banda de la IARU:],
  ([No proporcionan información sobre el modo preferido de utilización.], [Son un instrumento básico para regular el uso de las bandas de frecuencias.], [Son iguales a nivel mundial.], [No tienen en cuenta la atribución de bandas del Reglamento de Radiocomunicaciones de la UIT.],),
  sol: [Los planes ordenan el uso de cada banda repartiéndola en segmentos según el modo y la anchura de banda, y por eso son el instrumento básico para organizar su utilización. «Regular» no significa que tengan rango de ley: son acuerdos voluntarios entre asociaciones, aunque la Orden IET/1311/2013 (art. 2.2) remite a ellos como norma general. La a) es falsa: indican precisamente el modo recomendado. La c) es falsa: hay un plan por Región de la UIT. La d) es falsa: parten de las atribuciones del Reglamento de Radiocomunicaciones. #vease[(Véase tema R6, introducción del capítulo y sección «Las tres regiones de la UIT».)]])
#pq(11, 2, 16, "b", "F-R6.12", "Centros de actividad de SSB: 144,300 MHz (2 m) y 432,200 MHz (70 cm)",
  [El centro de actividad de SSB de la banda de 70 cm, según el plan de bandas de la IARU para la Región 1, está en:],
  ([433,500 MHz], [432,200 MHz], [438,000 MHz], [435,000 MHz],),
  sol: [El plan dedica el tramo 432,000–432,400 MHz a la telegrafía, los modos digitales estrechos y la SSB. En él marca 432,050 MHz como centro de actividad de telegrafía y 432,200 MHz como centro de actividad de SSB. Los 433,500 MHz son la frecuencia de llamada de FM. Los 435 MHz marcan el comienzo del segmento de satélites (435–438 MHz) y los 438 MHz su final. #no-esta[El plan de 70 cm de la IARU para la Región 1 reserva el tramo 432,000–432,400 MHz a telegrafía, modos digitales de banda estrecha y SSB. En él, 432,050 MHz es el centro de actividad de telegrafía y 432,200 MHz el de SSB. La frecuencia de llamada de FM es otra, 433,500 MHz, y el tramo 435–438 MHz se dedica a satélites.]])
#pq(11, 2, 17, "c", "R7.7", "Deletrear con el alfabeto fonético internacional; no inventar palabras",
  [Al deletrear las letras de su indicativo, el radioaficionado debe utilizar:],
  ([nombres de ciudades españolas], [el alfabeto Morse hablado], [el alfabeto fonético internacional (OACI)], [cualquier palabra que empiece por esa letra],),
  sol: [Para deletrear se usa el alfabeto fonético internacional (OACI); inventar palabras dificulta la comprensión.])
#pq(11, 2, 18, "d", "C-R8.4", "Orden IET/1311/2013: documento fundamental de regulación de la radioafición",
  [El Reglamento de uso del dominio público radioeléctrico por aficionados:],
  ([Su vigencia se limita a 4 años.], [Es un documento técnico informativo sin carácter vinculante para los radioaficionados.], [Fija las tasas por derecho a examen.], [Constituye el documento fundamental de regulación de la radioafición.],),
  sol: [La Orden IET/1311/2013 aprueba este Reglamento, que es una norma jurídica obligatoria y la norma específica de la actividad: regula la autorización, la prueba de capacitación, las estaciones fijas, los distintivos, las condiciones de uso y la inspección. No tiene una vigencia de 4 años: es indefinido, y la autorización tampoco se renueva. No es meramente informativo (b). Las tasas no las fija él, sino la Ley General de Telecomunicaciones, a la que remiten sus arts. 6 y 9 (c). #vease[(Véase tema R8, introducción del tema («tres pisos» normativos).)]])
#pq(11, 2, 19, "a", "C-R8.14", "Extranjero residente: autorización sin examen con HAREC de un país T/R 61-02 o por reciprocidad (residencia acreditada)",
  [La obtención de la autorización de radioaficionado por un extranjero residente en España, sin necesidad de superar la prueba de capacitación, precisará:],
  ([Ser titular de un certificado HAREC expedido por cualquier país que aplique la Recomendación CEPT T/R 61-02, o que exista Acuerdo o Convenio de reciprocidad con el país que otorgó su licencia original.], [Que únicamente sea titular de una licencia CEPT T/R 61-01 de su país de origen.], [Que el país de origen del radioaficionado aplique la Recomendación T/R 5000.], [Que se haya examinado en España exclusivamente de la reglamentación nacional.],),
  sol: [El art. 5.2 de la Orden IET/1311/2013 permite a los extranjeros residentes en España, que lo acrediten documentalmente, obtener la autorización sin la prueba de capacitación en dos casos: si tienen un certificado HAREC de un país que haya aplicado la T/R 61-02, o si existe acuerdo o convenio de reciprocidad con el país que otorgó su licencia original. Es la a. La licencia CEPT T/R 61-01 (b) solo vale para extranjeros no residentes, durante estancias temporales (art. 13). Las opciones c y d no son condición alguna de la norma. El banco antiguo decía «diploma de operador expedido en España», el nombre anterior del certificado. #vease[(Véase tema R8, preguntas sobre extranjeros residentes y certificado HAREC.)]

    #no-esta[Art. 5.2, segundo párrafo, de la Orden IET/1311/2013: el extranjero que acredite documentalmente ser residente en España obtiene la autorización, previa solicitud y sin examen, por una de dos vías: (a) certificado HAREC de un país que haya aplicado la T/R 61-02, o (b) acuerdo o convenio de reciprocidad con el país que le dio su licencia. Conviene no mezclarlo con la licencia CEPT (T/R 61-01): equivale a la autorización española solo para no residentes y en estancias temporales (art. 13).]])
#pq(11, 2, 20, "a", "R8.11", "Plazo para resolver la autorización (y la licencia de estación fija): 6 semanas, silencio desestimatorio",
  [El plazo del que dispone la Administración para resolver una solicitud de autorización de radioaficionado es de:],
  ([seis semanas], [un año], [quince días], [seis meses],),
  sol: [Plazo de resolución: seis semanas; el silencio es desestimatorio.])
#pq(11, 2, 21, "d", "R8.57", "Autorización en formato bilingüe si lo pide el interesado (lengua cooficial)",
  [En las comunidades autónomas con lengua cooficial, la autorización de radioaficionado:],
  ([se expide siempre solo en castellano], [se expide solo en la lengua cooficial], [se expide en inglés], [deberá expedirse en formato bilingüe si lo solicita el interesado],),
  sol: [En comunidades con lengua cooficial, la autorización se expide en formato bilingüe si lo solicita el interesado.])
#pq(11, 2, 22, "b", "F-R8.8", "Copia del contrato de seguro a la propiedad o al presidente de la comunidad",
  [Según el Reglamento de antenas de aficionado (Real Decreto 2623/1986), el titular debe entregar una copia del contrato del seguro de responsabilidad civil de su antena, con la cláusula que cita el artículo 2 de la Ley 19/1983:],
  ([únicamente a la Jefatura Provincial de Inspección de Telecomunicaciones, sin dar copia a la propiedad], [a la propiedad del inmueble o al presidente de la comunidad de propietarios], [a la asociación de radioaficionados a la que pertenece], [al ayuntamiento del término municipal donde está la antena],),
  sol: [El artículo 20.3 exige que el contrato incluya una cláusula especial que exprese que cumple el artículo 2 de la Ley 19/1983, y que se entregue copia del contrato (y de sus actualizaciones) a la propiedad del inmueble o, en propiedad horizontal, al presidente de la comunidad de propietarios. Ni la asociación del titular ni el ayuntamiento intervienen. Recuerda además que el seguro se formaliza una vez autorizado el montaje y antes de expedirse la licencia (art. 20.2). #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[Según el artículo 20 del RD 2623/1986, el seguro de responsabilidad civil cubre los daños materiales y corporales, a la propiedad y a terceros, derivados del uso, la instalación, la conservación y el desmontaje de la antena. Se formaliza una vez autorizado el montaje y antes de expedirse la licencia. Incluye una cláusula especial que expresa que cumple el artículo 2 de la Ley 19/1983, y se entrega copia del contrato y de sus actualizaciones a la propiedad del inmueble o al presidente de la comunidad.]])
#pq(11, 2, 23, "b", "F-R8.2", "Altura libre mínima de 3 m sobre el plano de paso",
  [Según el Reglamento de antenas de aficionado (Real Decreto 2623/1986), las antenas, sobre todo las horizontales, deben dejar en las peores condiciones ambientales previsibles una altura libre mínima sobre el plano de paso (la superficie accesible a las personas bajo la antena) de:],
  ([2 m], [3 m], [5 m], [10 m],),
  sol: [El artículo 13.2 exige que, en las peores condiciones ambientales previsibles, las antenas dejen en cualquier caso tres metros libres sobre el plano de paso, y lo subraya para las antenas horizontales, como un hilo largo o un dipolo sobre una azotea. La norma exige 3 m como mínimo: 2 m se queda corto, y 5 m o 10 m no son el mínimo que fija. #_apc3-ver[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

#_apc3-net[El Reglamento de antenas de aficionado (RD 2623/1986) define el plano de paso como el plano o superficie situado bajo la antena y sus elementos anejos, accesible a las personas. Según su artículo 13.2, las antenas, sobre todo las horizontales, deben dejar en cualquier caso una altura libre de 3 m sobre ese plano, en las peores condiciones ambientales previsibles. Además, en azoteas y lugares transitables se señalizan anclajes y riostras (art. 12.2).]])
#pq(11, 2, 24, "a", "C-R8.25", "Definiciones del RD 2623/1986: anclaje, riostra, plano de paso, elemento repartidor de carga",
  [En relación con la instalación en el exterior de un inmueble de una antena de estación de aficionado, el punto o elemento de fijación de las riostras en la obra civil del inmueble, repartiendo los esfuerzos mecánicos, se conoce con el nombre de:],
  ([Anclaje.], [Mástil.], [Soporte.], [Plano de paso.],),
  sol: [Las riostras son los cables o piezas que aseguran la estabilidad mecánica de la antena; el punto o elemento donde se fijan a la obra civil del inmueble, repartiendo los esfuerzos, se llama anclaje (definición del art. 1 del RD 2623/1986). Los demás términos designan otras cosas: el mástil es el poste que sirve de antena o la sostiene, el soporte es el elemento o conjunto de elementos que sustenta la antena, y el plano de paso es la superficie accesible a las personas situada bajo la antena y sus elementos anejos. #vease[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

    #no-esta[Vocabulario del Reglamento de antenas (RD 2623/1986, art. 1): #emph[mástil], poste que sirve de antena o la soporta; #emph[soporte], elemento mecánico que sustenta la antena; #emph[riostra], cable, hilo o pieza que da estabilidad mecánica; #emph[anclaje], punto o elemento de fijación de las riostras a la obra civil del inmueble, repartiendo los esfuerzos; #emph[plano de paso], superficie accesible a personas bajo la antena. Truco: la riostra tira, el anclaje la agarra al edificio.]])
#pq(11, 2, 25, "c", "R8.44", "Estación portátil: antena y fuente de energía incorporadas, utilizable en movimiento",
  [Una estación portátil de aficionado se caracteriza por:],
  ([necesitar un vehículo para su transporte], [emitir únicamente en UHF], [tener antena y fuente de energía incorporadas al propio equipo y poder utilizarse en movimiento], [requerir conexión a la red eléctrica],),
  sol: [La portátil integra antena y fuente de energía en el propio equipo y puede usarse en movimiento (el «walkie»).])
#pq(11, 2, 26, "a", "F-R8.52", "Varias desatendidas en una autorización: misma modulación, titularidad y ubicación",
  [Según el artículo 18.8 de la Orden IET/1311/2013, varias estaciones automáticas desatendidas pueden estar amparadas por una única autorización de radioaficionado cuando tienen:],
  ([el mismo tipo de modulación, la misma titularidad y la misma ubicación], [el mismo tipo de modulación y la misma ubicación, aunque pertenezcan a asociaciones distintas], [la misma titularidad y la misma ubicación, aunque emitan con distinto tipo de modulación], [el mismo tipo de modulación y la misma titularidad, aunque estén en distinta ubicación],),
  sol: [El último inciso del art. 18.8 permite que las estaciones automáticas desatendidas compartan una única autorización de radioaficionado si tienen el mismo tipo de modulación y comparten titularidad y ubicación. Las tres condiciones a la vez. Cada distractor omite una: sin la misma titularidad (b), sin el mismo tipo de modulación (c) o sin la misma ubicación (d) no se cumple el supuesto, y rige la regla general de las colectivas, una autorización individualizada. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 18.8 de la Orden IET/1311/2013: cada estación colectiva precisa su licencia y una autorización de radioaficionado individualizada con su distintivo. Excepción: las estaciones automáticas desatendidas (repetidores, radiobalizas, etc.) que tengan el mismo tipo de modulación y compartan titularidad y ubicación pueden estar amparadas por una única autorización de radioaficionado.]])
#pq(11, 2, 27, "d", "F-R8.77", "Repetidoras digitales: de portadora o nodo (enlaza con repetidoras) frente a final (distribuye a los usuarios)",
  [Según el Anexo I de la Orden IET/1311/2013, una «estación repetidora de portadora o nodo» es una estación repetidora digital destinada a:],
  ([distribuir el tráfico a las estaciones de cada radioaficionado], [convertir señales analógicas en digitales y viceversa], [emitir señales de identificación para estudios de propagación], [enlazar únicamente con otras estaciones repetidoras digitales],),
  sol: [El Anexo I define la estación repetidora de portadora o nodo como una estación repetidora digital destinada a enlazar únicamente con otras estaciones repetidoras digitales: es un eslabón entre repetidoras. Distribuir el tráfico a las estaciones de cada radioaficionado es la función de la repetidora final (a); convertir señales analógicas en digitales y viceversa es lo propio del repetidor analógico-digital (b), y emitir señales automáticas de identificación para estudios de propagación define a la radiobaliza (c). #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Anexo I de la Orden IET/1311/2013: la estación repetidora digital es una repetidora de radioaficionado que retransmite emisiones digitales para ampliar el alcance de las comunicaciones. La estación repetidora de portadora o nodo es la destinada a enlazar únicamente con otras repetidoras digitales; la estación repetidora final procesa o distribuye el tráfico procedente de otras repetidoras digitales a las estaciones de cada radioaficionado y viceversa. El repetidor analógico-digital es el que dispone de conversores analógico-digital y digital-analógico.]])
#pq(11, 2, 28, "d", "R8.67", "Titular de una desatendida: solo asociaciones de radioaficionados legalmente reconocidas",
  [Puede ser titular de una estación automática desatendida:],
  ([cualquier persona física, previa fianza], [cualquier radioaficionado con autorización en vigor], [exclusivamente la Administración], [una asociación de radioaficionados legalmente reconocida],),
  sol: [Repetidores, balizas y demás estaciones que funcionan sin operador presente se autorizan a asociaciones legalmente reconocidas, no a título individual: son infraestructura de uso común y necesitan un responsable estable.])
#pq(11, 2, 29, "a", "R9.7", "Las infracciones se tipifican en la Ley General de Telecomunicaciones",
  [La tipificación de las infracciones en que puede incurrir un radioaficionado se establece en:],
  ([la Ley General de Telecomunicaciones vigente], [el reglamento interno de la URE], [los planes de banda de la IARU], [la Recomendación T/R 61-01],),
  sol: [Las infracciones se tipifican en la Ley General de Telecomunicaciones vigente (hoy, Ley 11/2022).])
#pq(11, 2, 30, "d", "R9.10", "Prescripción: 3 años muy graves, 2 graves, 1 leves",
  [Las infracciones muy graves en materia de telecomunicaciones prescriben a los:],
  ([diez años], [seis meses], [dos años], [tres años],),
  sol: [Los tres plazos van escalonados con la gravedad: tres años las muy graves, dos las graves y uno las leves. Es una de las pocas cifras del tema que conviene memorizar en bloque.])
#fin-prueba()
#soluciones-simulacro(11)

// ======================================================================
#simulacro(12)
#prueba(12, 1)
#pq(12, 1, 1, "a", "F-T1.52", "Ley de Kirchhoff de las tensiones (mallas)",
  [Una batería de 12 V alimenta tres resistencias en serie (resistencia interna despreciable). Si en dos de ellas caen 3 V y 5 V, en la tercera cae:],
  ([4 V], [7 V], [8 V], [20 V],),
  sol: [Ley de las mallas: la suma de las caídas de tensión a lo largo de la malla es igual a la fem de la batería, $12 = 3 + 5 + V_3$. Luego $V_3 = 12 - 8 = 4$ V. Los 8 V son la suma de las dos caídas conocidas. Los 7 V resultan de restar solo una de ellas (12 − 5). Los 20 V suman las tres cantidades (12 + 3 + 5). _(Véase tema T1, sección «Unidades y leyes fundamentales».)_])
#pq(12, 1, 2, "d", "C-T1.11", "Fuerza electromotriz: caracteriza al generador y se mide en voltios",
  [La fuerza electromotriz de un generador se mide en:],
  ([vatios], [ohmios], [kilovatios], [voltios],),
  sol: [
    La fuerza electromotriz (fem) es la energía que el generador da a cada unidad de carga, es
    decir, julios por culombio, que son voltios: se mide en voltios (V), como toda tensión. Aunque
    el nombre lleve la palabra «fuerza», no se mide en newtons. El ohmio es la unidad de
    resistencia; el vatio y el kilovatio (mil vatios) lo son de potencia. #vease[(Véase tema T1,
    secciones «Unidades y leyes fundamentales» y «Fuentes y energía».)]
  ])
#pq(12, 1, 3, "d", "C-T1.4", "Velocidad de propagación: c = 300.000 km/s, constante y sin depender de la frecuencia",
  [La velocidad de propagación de las ondas electromagnéticas:],
  ([en el vacío es menor que a través del aire], [aumenta con la frecuencia], [disminuye con la frecuencia], [es constante en un determinado medio],),
  sol: [
    En un medio dado la velocidad de propagación es fija y, en los medios habituales en radio, no
    depende de la frecuencia: lo que varía al cambiar $f$ es la longitud de onda ($v = λ f$), no la
    velocidad. Por eso fallan b y c. La opción a es falsa porque el vacío es el medio en que las
    ondas van más rápido ($c ≈ 300.000$ km/s); en el aire la velocidad es prácticamente la misma,
    algo menor, nunca mayor. #vease[(Véase tema T1, sección «Ondas y señales»; factor de velocidad
    en tema T6, sección «Líneas de transmisión y adaptación».)]
    #no-esta[La velocidad de una onda electromagnética depende del medio, no de la frecuencia: en el vacío
    vale $c = 3 × 10^8$ m/s y en cualquier material es menor, $v = c slash n$, con $n ≥ 1$ el índice
    de refracción. En el aire $n ≈ 1,0003$, de modo que se toma $c$. En una línea de transmisión el
    cociente $v slash c$ es el factor de velocidad (0,66 en coaxial con polietileno). Con $v$ fija
    en el medio, la longitud de onda sigue a la frecuencia: $λ = v slash f$.]
  ])
#pq(12, 1, 4, "c", "T1.23", "Ruido térmico y ruido blanco: P = k T B, independiente de la frecuencia",
  [En un sistema de radiocomunicación, el llamado «ruido blanco»:],
  ([desaparece de noche], [solo aparece en las bandas bajas], [es independiente de la frecuencia], [aumenta con la frecuencia],),
  sol: [El ruido blanco debe su nombre a la luz blanca: contiene todas las frecuencias con la misma densidad de potencia, es decir, es independiente de la frecuencia.])
#pq(12, 1, 5, "c", "T1.28", "Anchuras de banda típicas: CW < SSB (2,7 kHz) < AM (6 kHz) < FM",
  [La anchura de banda de una emisión de telefonía en banda lateral única con portadora suprimida (J3E) es aproximadamente:],
  ([6 kHz], [500 Hz], [2,7 kHz], [12,5 kHz],),
  sol: [La anchura de banda de J3E es la de la voz útil: $tilde 2,7$ kHz (300–3000 Hz). Los 6 kHz del distractor corresponden a AM completa (A3E).])
#pq(12, 1, 6, "b", "C-T2.12", "En continua los condensadores se cargan al principio y luego bloquean la corriente",
  [En un circuito donde se aplica corriente continua se cargarían los condensadores si los hubiese:],
  ([No porque el condensador presenta una resistencia muy grande a la corriente continua], [Si, todos, al principio], [No, sólo si se aplicase corriente alterna], [Si pero sólo el primero],),
  sol: [
    Al conectar la continua, circula corriente un instante y carga cada condensador a través de las
    resistencias del circuito, con una exponencial de constante de tiempo $τ = R C$ (cargado a
    efectos prácticos en $5τ$). Cuando el condensador alcanza la tensión del punto al que está
    conectado, la corriente cesa y queda como un circuito abierto. Por eso se cargan todos, al
    principio (b). No es que no se carguen por oponer «una resistencia muy grande» (a): se cargan y
    luego bloquean la continua. Cargarse no exige alterna (c), ni es solo el primero (d): todos
    pasan por el transitorio. #vease[(Véase tema T2, sección «Condensadores».)]
  ])
#pq(12, 1, 7, "b", "C-T2.3", "Electrolítico: el dieléctrico es una capa de óxido (con el electrolito como pasta)",
  [El dieléctrico en los condensadores electrolíticos consiste en:],
  ([Aire], [Una capa de óxido en contacto con una pasta química (electrolito)], [Aceite], [Agua ionizada],),
  sol: [
    En el banco oficial la opción b dice solo «Una pasta química» y es la que da por buena: es la
    única que alude a lo propio del electrolítico, mientras que el aire (condensadores variables) y
    el aceite (condensadores de alta tensión) son dieléctricos de otros tipos y el agua ionizada no
    se emplea. Con rigor, el dieléctrico es la finísima capa de óxido formada sobre la armadura
    metálica; la pasta química es el electrolito, que actúa de segunda armadura. Por eso se ha
    reescrito la opción b para que recoja ambas piezas; en el examen marca la que habla de la pasta
    química. #vease[(Véase tema T2, sección «Condensadores».)]
    #no-esta[Un condensador electrolítico tiene una armadura de aluminio (o de tántalo) sobre la que se forma
    electroquímicamente una capa de óxido finísima: ese óxido es el dieléctrico, y su poco espesor
    explica la gran capacidad. Sobre él se pone el electrolito, líquido o en pasta, que hace de
    segunda armadura. El óxido solo se mantiene con el positivo en el aluminio; por eso el
    componente está polarizado y se destruye si se conecta al revés.]
  ])
#pq(12, 1, 8, "d", "T2.11", "Electrolítico: polarizado, hay que respetar la polaridad",
  [Los condensadores electrolíticos:],
  ([pueden conectarse en cualquier posición], [no admiten tensiones superiores a 1 V], [solo funcionan en circuitos de alterna], [deben conectarse respetando siempre la polaridad indicada],),
  sol: [Los electrolíticos son polarizados: conectados al revés se degradan y pueden reventar. Siempre se respeta la marca de polaridad.])
#pq(12, 1, 9, "a", "T2.21", "El diodo deja pasar la corriente en un solo sentido",
  [Se conoce con el nombre genérico de «diodo» a un dispositivo que:],
  ([permite el paso de la corriente eléctrica en un único sentido], [amplifica la corriente eléctrica], [almacena carga eléctrica], [transforma tensiones alternas],),
  sol: [El diodo conduce en un único sentido (de ánodo a cátodo en polarización directa); es la base de la rectificación y la detección.])
#pq(12, 1, 10, "d", "F-T3.36", "Impedancia de un circuito RLC serie: X = XL − XC, Z = √(R² + X²) e I = V/Z",
  [Una resistencia de 60 Ω, una bobina de 150 Ω de reactancia y un condensador de 70 Ω de reactancia se conectan en serie. La impedancia total del conjunto es de:],
  ([280 Ω], [176 Ω], [140 Ω], [100 Ω],),
  sol: [Las reactancias de bobina y condensador se oponen (sus tensiones están en oposición de fase), así que se restan: $X = X_L - X_C = 150 - 70 = 80$ Ω inductivos. Esa reactancia neta está a 90° de la resistencia: $Z = sqrt(R^2 + X^2) = sqrt(60^2 + 80^2) = 100$ Ω. Los 280 Ω suman todo sin más; los 176 Ω combinan las tres magnitudes en cuadratura sin restar las reactancias; y los 140 Ω restan las reactancias, pero suman aritméticamente el resultado con $R$. _(Véase tema T3, sección «Asociación de componentes y resonancia».)_
#_apc1-noest[Con bobina y condensador en serie, las reactancias tienen signo contrario y se restan: $X = X_L - X_C$ (inductiva si es positiva, capacitiva si es negativa). Después se combina con $R$ en cuadratura: $Z = sqrt(R^2 + X^2)$. En resonancia $X = 0$ y $Z = R$, el mínimo posible en un circuito serie.]])
#pq(12, 1, 11, "b", "F-T3.43", "Frecuencia de resonancia f0 = 1/(2π√(LC)): cálculo y dependencia con L y C",
  [La frecuencia de resonancia de un circuito LC formado por una bobina de 10 μH y un condensador de 50 pF es aproximadamente de:],
  ([14,2 MHz], [7,1 MHz], [44,7 MHz], [225 kHz],),
  sol: [Se aplica $f_0 = 1/(2 pi sqrt(L C))$. Con $L = 10 times 10^(-6)$ H y $C = 50 times 10^(-12)$ F: $L C = 5 times 10^(-16)$, $sqrt(L C) approx 2,236 times 10^(-8)$ s y $f_0 = 1 slash (2 pi dot 2,236 times 10^(-8)) approx 7,1 times 10^6$ Hz = 7,1 MHz. Los 44,7 MHz salen de olvidar el $2 pi$; los 14,2 MHz, de poner $pi$ en lugar de $2 pi$ (un factor 2); y los 225 kHz, de confundir las unidades (μH con mH, o pF con nF). _(Véase tema T3, sección «Asociación de componentes y resonancia».)_])
#pq(12, 1, 12, "a", "F-T3.49", "Filtro de cuarzo en la FI: su Q altísimo da selectividad elevada con banda estrecha y estable",
  [En la FI de un receptor de SSB se emplea un filtro de cuarzo porque:],
  ([su factor de calidad $Q$ altísimo da una selectividad muy elevada, con un ancho de banda estrecho y estable], [elimina la frecuencia imagen, que llega ya mezclada con la señal], [amplifica la FI más que un transistor y con menos ruido], [sustituye al oscilador de batido para demodular la SSB],),
  sol: [El cuarzo es un resonador piezoeléctrico con un $Q$ de decenas o centenas de miles, muy superior al de cualquier bobina. Con él se construye un filtro paso banda de flancos abruptos y ancho estable, que deja pasar solo la señal de SSB deseada y recorta las vecinas; y se hace en la FI, donde la frecuencia es fija. No amplifica: es un elemento pasivo con pérdidas. No elimina la imagen, que tras el mezclador ya es indistinguible de la señal y se rechaza antes, con el preselector. Tampoco sustituye al BFO, necesario para reinsertar la portadora. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_])
#pq(12, 1, 13, "b", "T3.18", "Operacional inversor: G = −R2/R1 (no inversor: 1 + R2/R1)",
  [En un amplificador operacional en montaje inversor, con $R_1$ a la entrada y $R_2$ de realimentación, la ganancia vale:],
  ([$R_1 dot R_2$], [$-R_2 slash R_1$], [$1 + R_1 slash R_2$], [$R_1 slash R_2$],),
  sol: [La realimentación negativa hace que la ganancia dependa solo de las dos resistencias, no del operacional. El signo menos recuerda que la salida se mueve en sentido contrario a la entrada. El montaje no inversor sería $1 + R_2 slash R_1$.])
#pq(12, 1, 14, "c", "T3.10", "DDS: se emplea como oscilador variable de gran precisión",
  [Los sintetizadores digitales directos (DDS) se emplean como:],
  ([rectificadores controlados], [filtros de rechazo de banda], [osciladores variables de gran precisión], [amplificadores de potencia],),
  sol: [El DDS genera la forma de onda numéricamente: oscilador variable con precisión y estabilidad de cristal.])
#pq(12, 1, 15, "b", "T4.11", "La imagen se rechaza antes del mezclador, con un filtro (preselector)",
  [En un receptor superheterodino, para rechazar la frecuencia imagen se emplea:],
  ([un limitador], [un filtro], [un atenuador de antena], [un amplificador de audio],),
  sol: [La frecuencia imagen se convierte a la misma FI que la señal deseada, así que una vez mezclada ya no se puede separar: hay que eliminarla antes del mezclador con un filtro (preselector).])
#pq(12, 1, 16, "d", "C-T4.5", "La estabilidad del receptor depende del oscilador local",
  [La estabilidad de un receptor es función:],
  ([De la etapa de radiofrecuencia], [Del mezclador], [Del paso de radiofrecuencia], [Del oscilador local],),
  sol: [
    La estabilidad es la capacidad de mantener la frecuencia sintonizada sin derivar. En un
    superheterodino esa frecuencia la fija el oscilador local ($f_s = f_("OL") ± f_("FI")$, según
    vaya el oscilador por debajo o por encima de la señal): si el oscilador deriva por temperatura,
    tensión o envejecimiento, el receptor se desintoniza la misma cantidad. La etapa de RF es un
    amplificador con filtro preselector y el mezclador solo combina dos señales; ninguno de los dos
    determina la frecuencia sintonizada. Por eso se cuida tanto el oscilador local (cristal,
    sintetizador, compensación de temperatura). #vease[(Véase tema T4, secciones «Características y
    controles» y «Arquitectura del receptor».)]
    #no-esta[Una deriva $Δ f$ del oscilador local desplaza exactamente $Δ f$ la señal que recibe el receptor,
    porque $f_s = f_("OL") ± f_("FI")$ y la FI es fija. Ejemplo: si el oscilador deriva 1 kHz, una
    emisora de SSB suena 1 kHz más aguda o más grave hasta que se retoca la sintonía. Por eso el
    oscilador local es el elemento que más condiciona la estabilidad y se estabiliza con cristal,
    sintetizador PLL o compensación térmica (TCXO).]
  ])
#pq(12, 1, 17, "c", "F-T5.10", "Los multiplicadores multiplican también la desviación de FM",
  [En un transmisor de FM, el oscilador de 12 MHz se desvía 250 Hz. Una cadena multiplicadora ×12 lleva la portadora a 144 MHz. La desviación a la salida es de:],
  ([21 Hz], [250 Hz], [3 kHz], [36 kHz],),
  sol: [La multiplicación de frecuencia multiplica también la desviación (y el índice de modulación $m = Delta f slash f_m$, porque la frecuencia moduladora no cambia): $Delta f = 250$ Hz × 12 = 3000 Hz = 3 kHz. Los 250 Hz (b) suponen que la desviación se conserva; los 21 Hz (a) resultan de dividir por 12 en vez de multiplicar, y los 36 kHz (d) de multiplicar por 144. Por eso el modulador puede trabajar con desviaciones pequeñas y cómodas de generar. #vease[(Véase tema T5, sección «Arquitecturas y características generales».)]])
#pq(12, 1, 18, "a", "C-T5.19", "Clases de emisión UIT: A1A (CW), A3E (AM), J3E (SSB), R3E, F3E (FM)",
  [La clase de emisión A3E (antes designada A3) indica:],
  ([Telefonía de doble banda lateral, portadora completa], [Telegrafía sin modulación], [Telefonía de banda lateral única, portadora suprimida], [Telefonía, dos bandas laterales independientes],),
  sol: [
    La clase A3E se lee letra a letra: A, modulación de amplitud con doble banda lateral y portadora
    completa; 3, un solo canal analógico; E, telefonía. Es la AM clásica. La telefonía de banda
    lateral única con portadora suprimida es J3E (opción c), la telegrafía (CW) es A1A (b) y las
    bandas laterales independientes son la clase B (d). El banco original escribía «A3»; la notación
    vigente añade la tercera letra. #vease[(Véase tema T5, sección «Arquitecturas y características
    generales»; tema T1, sección «Señales moduladas».)]
  ])
#pq(12, 1, 19, "a", "C-T5.9", "Anchura de banda ocupada: fuera de sus límites se radia el 0,5 % por cada lado",
  [Las frecuencias límite para una determinada anchura de banda son aquellas a partir de las cuales
se radia:],
  ([0,5 % de la potencia media total radiada], [2 % de la potencia media total radiada], [4 % de la potencia media total radiada], [5 % de la potencia media total radiada],),
  sol: [
    Es la definición de anchura de banda ocupada de la UIT: la anchura de la banda de frecuencias
    tal que, por debajo de su límite inferior y por encima de su límite superior, se radia en cada
    lado el 0,5 % de la potencia media total de la emisión. Dentro de ella queda, por tanto, el 99 %
    de la potencia. Los demás porcentajes no se corresponden con esa definición. #vease[(Véase tema
    T5, sección «Emisiones no deseadas».)]
    #no-esta[Anchura de banda ocupada (UIT): banda de frecuencias tal que, por debajo de su límite inferior y
    por encima del superior, las potencias medias radiadas son, cada una, el 0,5 % de la potencia
    media total de la emisión; así, el 99 % de la potencia queda dentro. No es lo mismo que la
    anchura de banda necesaria, que es la mínima que permite transmitir con la calidad y la
    velocidad requeridas.]
  ])
#pq(12, 1, 20, "a", "", "Impedancia de la vertical de cuarto de onda (≈ 36 Ω) y radiales inclinados (sube hacia 50 Ω)",
  [Una antena vertical de cuarto de onda con un plano de tierra de radiales horizontales presenta en su base una impedancia de aproximadamente:],
  ([36 Ω], [varios miles de ohmios], [73 Ω], [300 Ω],),
  sol: [La vertical de cuarto de onda es medio dipolo: el plano de tierra aporta la otra mitad por imagen, pero solo radia hacia el hemisferio superior, así que su resistencia de radiación es la mitad de la del dipolo, unos 73/2 ≈ 36 Ω. Los 73 Ω son los del dipolo completo, los 300 Ω los del dipolo plegado y los miles de ohmios, los de una media onda alimentada en un extremo. Si se inclinan los radiales hacia abajo, la impedancia sube hacia 50 Ω.])
#pq(12, 1, 21, "c", "C-T6.15", "Definición de la ROE: Vmáx / Vmín (o Imáx / Imín) de la onda estacionaria",
  [En una línea de transmisión, la relación de onda estacionaria es:],
  ([Potencia del transmisor − atenuación del cable entre transmisor y antena], [Potencia máxima / potencia mínima], [$(|V_"máx"|) / (|V_"mín"|)$], [$(|V_"máx"| + |V_"mín"|) / (|V_"máx"| − |V_"mín"|)$],),
  sol: [
    La onda estacionaria resulta de sumar la onda directa y la reflejada: sus máximos de tensión
    valen $V_d + V_r$ y sus mínimos $V_d − V_r$. La ROE es el cociente entre ambos, ROE
    $= V_"máx" slash V_"mín" = (1 + |ρ|) slash (1 − |ρ|)$, y sale lo mismo con las intensidades. La
    opción d da $2V_d slash 2V_r = 1 slash |ρ|$, que no es la ROE. La relación de potencias
    máxima/mínima (b) sería el cuadrado de la ROE, y la resta de a es simplemente la potencia que
    llega a la antena, sin ninguna onda estacionaria de por medio. #vease[(Véase tema T6, sección
    «Líneas de transmisión y adaptación».)]
  ])
#pq(12, 1, 22, "c", "T6.43", "Máxima transferencia: transmisor, línea y antena de la misma impedancia; si difieren, hace falta adaptador",
  [La máxima transferencia de energía del transmisor a la antena se produce cuando:],
  ([la antena es lo más larga posible], [la línea de transmisión es lo más corta posible], [las impedancias del emisor, de la línea y de la antena coinciden], [se emplea la máxima potencia disponible],),
  sol: [Es el teorema de la máxima transferencia de potencia aplicado a la estación: con las tres impedancias iguales no hay reflexión y toda la potencia disponible llega a la antena. Alargar la antena o subir la potencia no sustituye a la adaptación.])
#pq(12, 1, 23, "b", "T7.3", "La onda de superficie predomina en MF y por debajo (sus pérdidas crecen con la frecuencia)",
  [El modo de propagación por onda de superficie predomina en la banda de:],
  ([VHF], [MF], [UHF], [SHF],),
  sol: [La onda de superficie viaja guiada por el suelo, y el suelo es mal conductor: las pérdidas que induce crecen con la frecuencia. Por eso domina en MF y por debajo; en HF se agota en pocos kilómetros y solo sobrevive la propagación ionosférica.])
#pq(12, 1, 24, "d", "", "MUF ≈ fc / cos θ: mayor que la frecuencia crítica en incidencia oblicua",
  [La frecuencia crítica de la capa F2 es de 7 MHz. Para una onda que llega a la capa formando 60° con la vertical, la máxima frecuencia utilizable (MUF) es aproximadamente de:],
  ([6 MHz], [8,1 MHz], [3,5 MHz], [14 MHz],),
  sol: [$"MUF" approx f_c slash cos theta$, con $theta$ el ángulo respecto de la vertical: $7 slash cos 60° = 7 slash 0,5 = 14$ MHz. En incidencia oblicua la MUF es siempre mayor que la frecuencia crítica. Los 3,5 MHz salen de multiplicar por el coseno en vez de dividir; los 8,1 MHz, de usar el seno; y unos 6 MHz serían el 85 % de la frecuencia crítica.])
#pq(12, 1, 25, "b", "F-T8.5", "Analizador de espectros: dominio de la frecuencia; armónicos y espurias",
  [Un analizador de espectros, a diferencia de un osciloscopio, muestra en pantalla:],
  ([la tensión instantánea de la señal en función del tiempo, es decir, su forma de onda], [el nivel de cada componente de la señal (portadora, bandas laterales, armónicos) en función de su frecuencia], [la ROE de la antena en función de la longitud de la línea], [la resistencia y la capacidad de los componentes conectados a su entrada],),
  sol: [El analizador trabaja en el dominio de la frecuencia: descompone la señal y dibuja el nivel de cada componente (portadora, bandas laterales, armónicos, espurias) en su frecuencia. El osciloscopio trabaja en el dominio del tiempo y muestra la tensión instantánea, la forma de onda (a), que no separa con claridad los armónicos. La ROE (c) la mide un medidor de ROE o un vatímetro direccional, y la resistencia de un componente (d), un óhmetro o un puente. #vease[(Véase tema T8, sección «Instrumentos».)]])
#pq(12, 1, 26, "a", "T8.20", "S-meter: indica la intensidad de la señal recibida (es un instrumento de recepción)",
  [El instrumento comúnmente denominado «S-meter» de un receptor indica:],
  ([la intensidad de la señal recibida], [la relación de ondas estacionarias de la antena], [la potencia entregada por el transmisor], [la frecuencia de la señal sintonizada],),
  sol: [Es el medidor de fuerza de señal, y de él sale el número que se da en el informe de recepción («me llegas 5 y 9»). Trabaja a partir de la tensión del control automático de ganancia.])
#pq(12, 1, 27, "d", "T9.6", "Apantallamiento: caja metálica, eléctricamente estanca y a tierra (jaula de Faraday en los dos sentidos)",
  [Para que un campo electromagnético externo no interfiera a un circuito electrónico, este se puede apantallar en una caja:],
  ([de plástico rígido], [de madera tratada], [de cristal templado], [metálica, eléctricamente estanca y conectada a tierra],),
  sol: [Apantallamiento eficaz: caja metálica, eléctricamente estanca y conectada a tierra.])
#pq(12, 1, 28, "c", "T10.37", "Cuerpo mojado: baja la resistencia y aumenta el riesgo",
  [Si el cuerpo de una persona está mojado, frente a una descarga eléctrica:],
  ([el riesgo no varía], [el riesgo disminuye si el agua es destilada], [el riesgo aumenta, porque disminuye la resistencia del cuerpo], [queda protegido, porque el agua forma una jaula de Faraday],),
  sol: [La piel seca ofrece bastantes miles de ohmios; mojada, esa resistencia se desploma y la misma tensión produce mucha más corriente. Por eso los baños y las zonas húmedas son las de mayor riesgo eléctrico. Lo de la jaula de Faraday es un disparate.])
#pq(12, 1, 29, "a", "T10.5", "Interferencia a servicios de seguridad de la vida humana, al móvil aeronáutico o a la ICT del edificio: dejar de emitir",
  [Cuando una interferencia perjudicial afecta a la seguridad de la vida humana, el radioaficionado debe:],
  ([dejar de emitir hasta que el problema esté resuelto], [reducir la potencia a la mitad], [seguir emitiendo si su estación está autorizada], [cambiar de modo de emisión],),
  sol: [Ante una interferencia que afecte a la seguridad de la vida humana: dejar de emitir hasta resolver el problema.])
#pq(12, 1, 30, "c", "T10.3", "La toma de tierra protege al operador: deriva la fuga y hace actuar al diferencial",
  [El transceptor debe estar conectado a tierra para:],
  ([reducir el consumo eléctrico], [aumentar el alcance de las emisiones], [proteger al operador de descargas eléctricas], [mejorar la modulación],),
  sol: [Si un defecto pone el chasis en tensión, la toma de tierra ofrece un camino de baja resistencia que lo mantiene a ∼0 V y deriva la corriente de fuga; esa corriente dispara el diferencial (sensible a unos 30 mA) antes de que el operador, al tocar el chasis, se convierta en el camino de retorno. Es la protección frente a contactos indirectos.])
#fin-prueba()
#prueba(12, 2)
#pq(12, 2, 1, "d", "R1.23", "Para qué sirve el alfabeto fonético: deletrear letras y cifras sin confusiones (no cifra ni abrevia)",
  [El alfabeto fonético internacional se emplea para:],
  ([abreviar los mensajes y ganar tiempo], [cifrar el contenido de los mensajes], [identificar el país de procedencia de la estación], [deletrear letras y cifras evitando confusiones en condiciones difíciles],),
  sol: [Con ruido, desvanecimiento o acentos distintos, una B y una P suenan igual; _Bravo_ y _Papa_, no. No cifra nada —de hecho es público— ni abrevia: al contrario, alarga.])
#pq(12, 2, 2, "a", "R2.24", "QRK inteligibilidad, QSA intensidad, QRI tono (las tres valoraciones de la señal)",
  [El grupo `QRI` se refiere a:],
  ([el tono de la transmisión], [la intensidad de las señales], [la legibilidad de las señales], [la frecuencia exacta de la emisión],),
  sol: [Los tres grupos de la valoración de una señal en telegrafía se reparten así: `QRK` legibilidad, `QSA` intensidad y `QRI` tono — los mismos conceptos que el informe RST.])
#pq(12, 2, 3, "a", "R2.30", "QSL acuse de recibo frente a QSO comunicado entre dos estaciones",
  [El grupo que se emplea para acusar recibo de una comunicación es:],
  ([`QSL`], [`QRZ`], [`QSO`], [`QSY`],),
  sol: [`QSL` es el acuse de recibo, y de ahí que la tarjeta que confirma un contacto se llame precisamente tarjeta QSL. `QSO` es el contacto en sí.])
#pq(12, 2, 4, "c", "R2.16", "QSP retransmitir gratuitamente a…",
  [El grupo `QSP` significa:],
  ([su señal presenta desvanecimiento], [cambie a la frecuencia indicada], [retransmitir gratuitamente a la estación indicada], [aumente la potencia de emisión],),
  sol: [Es el grupo de la retransmisión de mensajes: «¿quiere retransmitir gratuitamente a …?». La gratuidad no es un detalle menor — el servicio de aficionados no puede tener fines lucrativos.])
#pq(12, 2, 5, "d", "R3.16", "73 saludos cordiales y 88 besos",
  [La abreviatura `73` significa:],
  ([el número de contactos realizados], [la banda de trabajo, en metros], [la potencia empleada, en vatios], [saludos cordiales],),
  sol: [Viene de los antiguos códigos telegráficos numéricos y ha sobrevivido como la despedida universal del radioaficionado. Se dice «73», no «setenta y tres saludos».])
#pq(12, 2, 6, "b", "R3.38", "SRI lo siento",
  [La abreviatura `SRI` se emplea para expresar:],
  ([señal recibida intermitente], [lo siento], [sin respuesta inmediata], [servicio de radio internacional],),
  sol: [Contracción de _sorry_. Se emplea para disculparse, por ejemplo al no poder completar un contacto o al haber interrumpido a otra estación.])
#pq(12, 2, 7, "c", "C-R3.6", "GE buenas tardes",
  [La abreviatura operacional utilizada en telegrafía para decir «buenas tardes» es:],
  ([ES], [BUG], [GE], [BK],),
  sol: [GE procede de #emph[good evening]: buenas tardes (y noches). Los distractores son otras abreviaturas: BK es «corte de transmisión» (#emph[break]), ES es «y» (#emph[and]) y BUG es el manipulador semiautomático.

    #no-esta[GE es la abreviatura de #emph[good evening]: «buenas tardes». Junto a GM (#emph[good morning], buenos días) y GN (#emph[good night], buenas noches) forma el trío de saludos horarios: la G de #emph[good] más la inicial de la parte del día. En el material del examen, GA significa «adelante» (#emph[go ahead]). No figuran en las tablas del cuaderno.]])
#pq(12, 2, 8, "d", "C-R4.1", "Formato de la llamada de socorro: Mayday ×3 + «aquí»/«de» + distintivo ×3",
  [La llamada de socorro en radiotelefonía se compone de:],
  ([«MAYDAY» (una vez), la palabra «AQUÍ» o «DE» y el distintivo de llamada (tres veces).], [«AQUÍ» o «DE», el distintivo de llamada (tres veces) y la palabra «MAYDAY» (tres veces).], [Únicamente «MAYDAY» (tres veces).], [«MAYDAY» (tres veces), la palabra «AQUÍ» o «DE» y el distintivo de llamada (tres veces).],),
  sol: [La llamada de socorro en radiotelefonía lleva tres partes, en este orden: la palabra «Mayday» repetida tres veces, la palabra «aquí» o «de» y el distintivo de la estación en peligro, también tres veces. Por ejemplo: «Mayday, Mayday, Mayday, aquí EA4XYZ, EA4XYZ, EA4XYZ». Falla la opción con el orden invertido (primero debe oírse que es socorro), la que solo dice «Mayday» (incompleta) y la que lo dice una vez. Tampoco vale «help»: la palabra internacional de socorro es solo «Mayday». A la llamada sigue el mensaje de socorro. #vease[(Véase tema R4, tabla «Señales internacionales de socorro, urgencia y seguridad».)]

    #no-esta[El cuaderno da la palabra «Mayday» (tres veces), pero no la estructura completa de la llamada. Según el Reglamento de Radiocomunicaciones de la UIT (Apéndice 13), la llamada de socorro en radiotelefonía consta de: 1) «Mayday» tres veces; 2) «aquí» (en inglés #emph[this is]) o «de»; 3) el distintivo de la estación en peligro, tres veces. Después va el mensaje de socorro: identificación, posición, naturaleza del peligro y ayuda que se necesita. Regla: tres veces la palabra, tres veces el distintivo.]])
#pq(12, 2, 9, "a", "F-R4.13", "Banda de 70 cm: 430–440 MHz",
  [La banda de 70 cm atribuida al Servicio de Aficionados en España es:],
  ([430 a 440 MHz], [440 a 450 MHz], [420 a 450 MHz], [433 a 435 MHz],),
  sol: [El Anexo I de la Orden (apartado 3.1) recoge la banda de 70 cm como 430 a 440 MHz, y el CNAF la atribuye así en España. «420 a 450» es la banda de otros países: la nota 5.270 añade 420–430 y 440–450 MHz, a título secundario, en Australia, Estados Unidos, Jamaica y Filipinas. «440 a 450» queda fuera de la banda. «433 a 435» son solo 2 MHz del interior, donde además está la banda ICM 433,050–434,790 MHz. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]])
#pq(12, 2, 10, "c", "C-R5.15", "Estructura internacional: la parte de nacionalidad tiene hasta tres caracteres, letras o cifras",
  [Las series de distintivos de llamada:],
  ([Empiezan siempre por la inicial en lengua francesa del nombre del país], [Empiezan siempre con una combinación de 2 o 3 letras elegidas de una serie secuencial atribuida a un país], [Empiezan por una combinación de letras o cifras con una longitud máxima de tres], [Empiezan por combinaciones de 2 letras o cifras],),
  sol: [En las series internacionales del Reglamento de Radiocomunicaciones, la parte inicial que identifica la nacionalidad del distintivo puede ser de uno, dos o tres caracteres, y pueden ser letras o cifras (por ejemplo, G, EA o 3DA). Por eso la c es correcta. La a no es ninguna regla. La b falla porque no siempre son letras ni siempre son dos o tres caracteres; la d, porque no siempre son exactamente dos.

    #no-esta[Estructura de los distintivos internacionales (artículo 19 del Reglamento de Radiocomunicaciones de la UIT): la UIT atribuye a cada país bloques de tres caracteres (España: EAA–EHZ y AMA–AOZ). La parte que identifica la nacionalidad tiene uno, dos o, si hace falta, tres caracteres, letras o cifras. En España el prefijo son las dos primeras letras (art. 27 de la Orden IET/1311/2013).]])
#pq(12, 2, 11, "d", "R5.35", "Distritos insulares y ciudades autónomas: 6 Baleares, 8 Canarias, 9 Ceuta y Melilla",
  [Las Islas Baleares y las Islas Canarias corresponden, respectivamente, a las cifras de distrito:],
  ([8 y 6], [9 y 6], [5 y 9], [6 y 8],),
  sol: [Baleares es el 6 y Canarias el 8. La confusión habitual es invertirlos; conviene fijar el 6 con «Baleares, más cerca» y el 8 con «Canarias, más lejos».])
#pq(12, 2, 12, "b", "R5.9", "Estaciones automáticas desatendidas: prefijo ED; sufijo con Y (analógica) o Z (digital)",
  [En los distintivos de las estaciones automáticas desatendidas, los sufijos de tres letras que comienzan por Y o por Z se reservan, respectivamente, para estaciones:],
  ([colectivas y personales], [analógicas y digitales], [experimentales y de concurso], [marítimas y aeronáuticas],),
  sol: [Inicial Y = analógica, Z = digital: `ED1YBD` repetidor analógico, `ED5ZAA` digital.])
#pq(12, 2, 13, "d", "C-R5.4", "Sufijo de dos letras: 5 años de autorización, 5 de práctica internacional y 5 sin expediente sancionador; no reservado a colectivas",
  [Los sufijos de dos letras podrán ser asignados:],
  ([Nunca.], [Siempre y cuando comiencen por la letra Q.], [Únicamente a una agrupación de radioaficionados.], [A cualquier radioaficionado que acredite cinco años de prácticas en la radioafición internacional.],),
  sol: [El artículo 27 de la Orden IET/1311/2013 permite adjudicar sufijos de dos letras a radioaficionados con al menos cinco años de autorización española, que acrediten cinco años de práctica en la radioafición internacional y no hayan sido sancionados en los últimos cinco años. La redacción de la opción d simplifica: como la demanda supera las disponibilidades, la Administración fija además un procedimiento con plazos y méritos. La a es falsa; la c también (las agrupaciones usan sufijos de tres letras que empiezan por UR, RC o RK); y la b inventa una condición: lo que la norma excluye es la serie QAA–QZZ. #vease[(Véase tema R5, sección «Sufijos y usos temporales».)]

    #no-esta[Requisitos del artículo 27 para un sufijo de dos letras: autorización española con antigüedad mínima de cinco años, cinco años de práctica en la radioafición internacional y ningún expediente sancionador en los últimos cinco años. Para el de una letra, quince años de práctica. Como la demanda supera a los sufijos disponibles, la Administración establece un procedimiento con plazos de solicitud y méritos específicos, de forma transparente y no discriminatoria.]])
#pq(12, 2, 14, "d", "C-R6.5", "Convenio de banda lateral: LSB por debajo de 10 MHz, USB por encima; excepción 60 m en USB",
  [En la banda de radioaficionado de 40 metros, el modo de emisión que normalmente se utiliza es:],
  ([USB], [AM], [LSB y AM], [LSB],),
  sol: [Por convenio, en banda lateral única se usa la banda lateral inferior (LSB) por debajo de 10 MHz y la superior (USB) por encima. Los 40 m (7 MHz) están por debajo, así que la fonía habitual es LSB. La a) es el modo de 20 m y de las bandas más altas. La AM, en las opciones b) y c), se oye poco en HF: ocupa el doble de ancho de banda y gasta la mayor parte de la potencia en la portadora, por lo que no es el modo normal de la banda. #vease[(Véase tema T1, sección «Señales moduladas» (banda lateral única); tema R3, abreviaturas LSB y USB.)]

    #no-esta[El cuaderno explica qué son LSB y USB, pero no cuál se usa en cada banda. Es un convenio, no una norma: por debajo de 10 MHz (160, 80 y 40 m) se emplea LSB, y por encima (20, 17, 15, 12 y 10 m) USB. Regla para recordarlo: en las bandas bajas, banda lateral inferior; en las altas, superior. Así, la fonía en SSB a 7 MHz se hace en LSB y a 14 MHz en USB. El plan de bandas de la IARU indica el segmento de cada modo, pero no impone la banda lateral.]])
#pq(12, 2, 15, "c", "F-R6.5", "20 m: 14.070–14.099 kHz para modos digitales de banda estrecha",
  [En la banda de 20 m, el segmento 14.070–14.099 kHz del plan de bandas HF de la IARU para la Región 1 está destinado a:],
  ([fonía SSB], [balizas], [modos digitales de banda estrecha (digimodos)], [telegrafía (CW)],),
  sol: [En 20 m el plan reparte así: 14.000–14.070 kHz, CW; 14.070–14.099 kHz, modos de banda estrecha y digimodos (hasta 500 Hz de anchura; RTTY, PSK, etc.); 14.099–14.101 kHz, balizas en exclusiva; 14.101–14.350 kHz, todos los modos, con la fonía SSB en USB. Por tanto, la telegrafía corresponde al tramo inferior, la fonía al superior y las balizas al estrecho segmento de 2 kHz que sigue al de digimodos. #no-esta[En 20 m el plan HF de la IARU para la Región 1 distribuye la banda así: 14.000–14.070 kHz, telegrafía (CW); 14.070–14.099 kHz, modos de banda estrecha y digimodos (p. ej., RTTY o PSK, hasta 500 Hz de ancho); 14.099–14.101 kHz, balizas exclusivamente; 14.101–14.350 kHz, todos los modos, incluida la fonía en USB.]])
#pq(12, 2, 16, "a", "R9.26", "Emitir música está prohibido: el servicio de aficionados no es radiodifusión",
  [Transmitir música a través de una estación de aficionado:],
  ([está prohibido, porque el de aficionados no es un servicio de radiodifusión], [se admite fuera de las horas punta], [se admite si es de dominio público], [se admite si dura menos de un minuto],),
  sol: [El servicio de aficionados es de instrucción individual, intercomunicación y estudios técnicos (art. 2.1 de la Orden), no de difusión de contenidos a una audiencia. Emitir música lo convertiría en radiodifusión, que es otro servicio con otras autorizaciones.])
#pq(12, 2, 17, "b", "F-R8.17", "CNAF vigente: aprobado por orden ministerial (Orden TDF/732/2026)",
  [El Cuadro Nacional de Atribución de Frecuencias (CNAF) vigente en octubre de 2026 fue aprobado por la:],
  ([Orden IET/1311/2013, de 9 de julio], [Orden TDF/732/2026, de 10 de julio], [Orden ETD/1449/2021, de 16 de diciembre], [Orden ETU/1033/2017, de 25 de octubre],),
  sol: [El Ministerio aprueba el CNAF mediante orden, al amparo del art. 6 del Reglamento sobre el uso del dominio público radioeléctrico. La edición vigente es la de la Orden TDF/732/2026, de 10 de julio (BOE del 17 de julio, en vigor al día siguiente), que deroga y sustituye a la de la Orden ETD/1449/2021, de 16 de diciembre; la Orden ETU/1033/2017 es una edición anterior. La Orden IET/1311/2013 no es un CNAF: es el reglamento de los radioaficionados, y remite al CNAF para saber qué bandas se atribuyen al servicio (art. 2.1). #_apc3-ver[(Véase tema R8, introducción del tema («tres pisos» normativos).)]

#_apc3-net[El CNAF es el plan que atribuye las bandas, subbandas y frecuencias a cada servicio de radiocomunicación y fija sus condiciones técnicas, de acuerdo con la Unión Europea, la CEPT y el Reglamento de Radiocomunicaciones de la UIT (art. 6 del Reglamento sobre el uso del dominio público radioeléctrico). Lo aprueba el Ministerio mediante orden. La edición vigente en octubre de 2026 es la de la Orden TDF/732/2026, de 10 de julio, que sustituyó a la de la Orden ETD/1449/2021, de 16 de diciembre.]])
#pq(12, 2, 18, "b", "F-R8.87", "Interferencia: degradación, falseamiento o pérdida de información por energía no deseada",
  [Según el anexo I, la «interferencia» es el efecto de una energía no deseada sobre la recepción en un sistema de radiocomunicación, que se manifiesta como:],
  ([únicamente la interrupción total del servicio de radiocomunicación afectado], [degradación de la calidad, falseamiento o pérdida de la información que se podría obtener en ausencia de esa energía no deseada], [emisiones situadas inmediatamente fuera de la anchura de banda necesaria, resultado del proceso de modulación], [una desviación de la frecuencia de la emisión respecto de la frecuencia asignada],),
  sol: [El anexo I define la interferencia por su efecto sobre la recepción: energía no deseada que se manifiesta como degradación de la calidad, falseamiento o pérdida de la información que se obtendría sin ella. Basta una degradación; no hace falta que el servicio se interrumpa (a). Las emisiones fuera de banda (c) y la tolerancia de frecuencia (d) son otras definiciones del anexo, sin relación con el efecto sobre la recepción. Cuando la degradación es grave o repetida, o afecta a servicios de seguridad, se habla de interferencia perjudicial.

#_apc3-net[Según el anexo I, la interferencia es el efecto de una energía no deseada, debida a una o varias emisiones, radiaciones, inducciones o sus combinaciones, sobre la recepción en un sistema de radiocomunicación, que se manifiesta como degradación de la calidad, falseamiento o pérdida de la información que se obtendría sin esa energía. Es un concepto más amplio que el de interferencia perjudicial, que exige además que la degradación sea grave o repetida, o que afecte a servicios de seguridad.]])
#pq(12, 2, 19, "a", "C-R8.48", "Banda de 40 m: 7100–7200 kHz, a título primario para aficionados en la Región 1 desde 2009",
  [La banda de 7.100 a 7.200 kHz estuvo atribuida a título primario al servicio de radiodifusión (Regiones 1 y 3) hasta el 29 de marzo de 2009 (antigua nota 5.141C del Reglamento de Radiocomunicaciones, CMR-03). Desde esa fecha, en España (Región 1) está atribuida al servicio de:],
  ([Aficionados, a título primario.], [Radiodifusión, a título primario, sin cambios.], [Aficionados, pero solo a título secundario.], [Fijo y móvil terrestre, a título primario.],),
  sol: [La CMR-03 reasignó 7.100 a 7.200 kHz de la radiodifusión al servicio de aficionados y dejó una transición que terminó el 29 de marzo de 2009. Desde entonces, junto con 7.000 a 7.100 kHz, forma la banda de 40 m de la Región 1 (7.000 a 7.200 kHz), atribuida a los aficionados a título primario: la a. La b ignora el cambio. La c es cierta en otras bandas (p. ej. 30 m), no en esta. En la d, fijo y móvil solo figuran como atribución adicional en unos pocos países concretos (notas 5.141A y 5.141B), no como atribución general de la Región 1. Si el examen plantea la pregunta en su forma original, el banco da por buena: «estaba atribuida a título primario al servicio de radiodifusión hasta el 29 de marzo de 2009». #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe» (banda de 40 m y carácter primario o secundario) y tema R6, sección «Las tres regiones de la UIT» (el caso de los 40 m).)]

    #no-esta[Desde el 29 de marzo de 2009, fin de la transición fijada por la CMR-03, el servicio de aficionados tiene atribuida a título primario la banda de 7.100 a 7.200 kHz en las Regiones 1 y 3; hasta esa fecha era de radiodifusión (antigua nota 5.141C del Reglamento de Radiocomunicaciones de la UIT). Por eso la banda de 40 m llega hoy hasta 7.200 kHz en la Región 1, España incluida, y hasta 7.300 kHz en la Región 2. «Primario» es uso preferente; «secundario», sin causar interferencias al servicio primario ni reclamar protección frente a él.]])
#pq(12, 2, 20, "a", "R8.84", "Licencia CEPT: respetar siempre el RR y la reglamentación del país visitado",
  [El titular de una licencia CEPT que opera en otro país:],
  ([debe respetar el Reglamento de Radiocomunicaciones y la reglamentación del país visitado], [queda sujeto únicamente a la normativa de su país de origen], [puede emplear la potencia máxima de su país de origen], [está exento de identificarse],),
  sol: [La licencia CEPT ahorra el trámite, no las reglas: se opera con las bandas, potencias y condiciones del país en que uno se encuentra, y con sujeción al Reglamento de Radiocomunicaciones.])
#pq(12, 2, 21, "c", "R8.80", "RR art. 25: comunicaciones entre países permitidas salvo oposición de una administración",
  [De acuerdo con el artículo 25 del Reglamento de Radiocomunicaciones de la UIT, las comunicaciones entre estaciones de aficionado de distintos países:],
  ([requieren la presencia de un intérprete oficial], [están prohibidas salvo autorización expresa], [se permiten, salvo que la Administración de alguno de los países afectados haya manifestado su oposición], [solo se permiten dentro de la misma Región],),
  sol: [El criterio del artículo 25 es permisivo: las comunicaciones internacionales entre aficionados están permitidas salvo que una de las Administraciones implicadas haya notificado su oposición. Por eso existen países con los que no se puede contactar.])
#pq(12, 2, 22, "c", "C-R8.36", "Estación construida de acuerdo con el estado de la técnica (no se impone tecnología)",
  [La estación de aficionado debe estar construida:],
  ([Siempre con válvulas.], [Completamente transistorizada.], [De acuerdo con el estado de desarrollo de la técnica radioeléctrica.], [Con arreglo a un modelo común.],),
  sol: [La normativa no impone una tecnología ni un modelo único de equipo: ni válvulas, ni transistores, ni un diseño común. El equipo puede ser comercial (con marcado CE) o de construcción propia (art. 5.5 y 5.6 de la Orden IET/1311/2013); lo que se exige es que cumpla las características técnicas del anexo I (emisiones no esenciales limitadas, filtro paso bajo, medios para comprobar la banda y la potencia). Es decir, debe construirse con buena práctica radioeléctrica, según el estado de la técnica. La fórmula literal de la opción c no figura en la Orden vigente, pero es la única que describe lo que se exige. #vease[(Véase tema R8, sección «Usos especiales y casos particulares» (equipos de construcción propia), y tema T5, sección «Emisiones no deseadas».)]

    #no-esta[El anexo I de la Orden IET/1311/2013 (apartado 4) fija las prescripciones técnicas: las emisiones no esenciales por debajo de 30 MHz deben quedar 40 dB por debajo de la potencia media sin exceder de 50 mW; la estación debe tener elementos para comprobar que emite dentro de la banda y medir de forma indicativa la potencia, y redes adaptadoras de impedancia y filtros paso bajo supresores de armónicos. Eso es construir «según el estado de la técnica»; la norma no prescribe válvulas, transistores ni un modelo.]])
#pq(12, 2, 23, "c", "C-R8.15", "Modificaciones con licencia: permanentes se comunican; cambiar la antena de sitio = primera instalación",
  [El cambio de ubicación de la antena de una estación fija de radioaficionado:],
  ([No es necesario solicitarlo a la Secretaría de Estado de Telecomunicaciones (SETSI).], [Se debe solicitar a la SETSI y seguir un procedimiento distinto al de la primera instalación.], [Se debe solicitar a la SETSI y seguir el mismo procedimiento que si se tratase de la primera instalación.], [Únicamente requiere ser notificado al Ayuntamiento de la localidad.],),
  sol: [Según el último párrafo del art. 20 de la Orden IET/1311/2013, cuando una modificación incluye el cambio de ubicación de la antena, el titular debe solicitarlo a la SETSI con el mismo procedimiento que si fuera la primera instalación: solicitud, autorización de montaje, aviso de fin de obra y verificación para la licencia. La a es falsa, porque sí hay que solicitarlo. La b, porque el procedimiento no es distinto ni abreviado. La d, porque la autorización radioeléctrica no la da el Ayuntamiento. El banco antiguo hablaba de la «Dirección General de Telecomunicaciones»; hoy el órgano es la SETSI.

    #no-esta[Art. 20 de la Orden IET/1311/2013, una vez obtenida la licencia: cualquier modificación de instalaciones y equipos puede hacerse con carácter experimental durante un máximo de 60 días, siempre que no afecte a la seguridad. Si se hace permanente, el titular remite a la SETSI la documentación complementaria, incluidas las modificaciones. Excepción: si la modificación incluye cambiar la ubicación de la antena, se solicita a la SETSI como si fuera la primera instalación.]])
#pq(12, 2, 24, "d", "R8.17", "Cancelación de la licencia fija (p. ej., sin seguro): desmontar todo, antenas incluidas, a costa del titular",
  [Si el titular de una estación fija no dispone de contrato válido de seguro de antenas:],
  ([se le concede un año de prórroga], [no ocurre nada mientras no haya un siniestro], [se le impone una multa leve y puede seguir emitiendo], [la licencia de estación fija se cancela de oficio y las antenas deben permanecer desmontadas],),
  sol: [Sin seguro válido, la licencia de estación fija se cancela automáticamente (art. 21.1.c de la Orden) y, cancelada la licencia, el titular debe desmontar las instalaciones, antenas incluidas, con todos los gastos a su cargo (art. 21.2). La Ley 19/1983 (art. 4) añade que se pierde el derecho a instalar antenas.])
#pq(12, 2, 25, "b", "C-R8.30", "Bandas que requieren autorización especial: 2300–2450 MHz, 5650–5850 MHz y 24,050–24,250 GHz (con excepciones)",
  [Una de las siguientes bandas que se citan a continuación precisa autorización especial de uso. Señálela:],
  ([47,00–47,20 GHz.], [24,050–24,250 GHz.], [14.000–14.250 kHz.], [50,000–51,000 MHz.],),
  sol: [La disposición adicional segunda de la Orden IET/1311/2013 fija las bandas cuyo uso exige autorización especial: 2.300–2.450 MHz (salvo 2.316–2.332 MHz), 5.650–5.850 MHz (salvo 5.700–5.720 y 5.760–5.762 MHz) y 24,050–24,250 GHz. Por eso la respuesta es la b. Las demás no figuran en esa relación: 47 GHz, 14 MHz (la banda de 20 m) y 50 MHz (la de 6 m). Aviso: el banco da como clave, en su versión antigua, «10,00–10,5 GHz»; esa banda figuraba en la relación del reglamento anterior (Orden ITC/1791/2006) y ya no está en la vigente. Si te aparece así en el examen, es la que el banco da por buena. #vease[(Véase tema R8, tabla de cifras y sección «Usos especiales y casos particulares».)]

    #no-esta[Art. 16 y disposición adicional segunda de la Orden IET/1311/2013: cuando en una banda atribuida con carácter secundario hay riesgo de interferir a servicios primarios, su uso requiere autorización especial de la SETSI, a solicitud del interesado. Relación inicial: 2.300–2.450 MHz (salvo 2.316–2.332), 5.650–5.850 MHz (salvo 5.700–5.720 y 5.760–5.762) y 24,050–24,250 GHz. El reglamento anterior incluía también 10,00–10,5 GHz, y es la banda que el banco antiguo da por respuesta.]

    #_apb2-clave[«10,00-10,5 GHz.». Es la clave que dan las recopilaciones de exámenes reales (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea la técnicamente correcta.]])
#pq(12, 2, 26, "d", "R8.69", "Estación portable: la fija usada temporalmente en otra ubicación",
  [Una estación portable de aficionado es:],
  ([una estación instalada permanentemente en un vehículo], [una estación que funciona sin operador], [una estación de potencia inferior a 10 vatios], [una estación fija que puede utilizarse temporalmente en una ubicación distinta de la habitual],),
  sol: [Portable no significa pequeña ni de poca potencia: significa que la estación fija se traslada temporalmente a otro emplazamiento. Distinta de la móvil, que opera en movimiento a bordo de un vehículo.])
#pq(12, 2, 27, "a", "F-R8.49", "Estación colectiva: responsable la Junta Directiva de la asociación",
  [Según el artículo 18.6 de la Orden IET/1311/2013, de la utilización de una estación colectiva de radioaficionado es responsable:],
  ([la Junta Directiva de la asociación titular de la estación], [el operador que transmite en cada momento, de forma exclusiva], [la Jefatura Provincial de Inspección de Telecomunicaciones], [la empresa instaladora que montó la estación],),
  sol: [El art. 18.6 reserva las estaciones colectivas a las asociaciones de radioaficionados reconocidas y hace responsable de su utilización a la Junta Directiva de la asociación. La responsabilidad recae, pues, en el órgano de gobierno de la entidad titular, no exclusivamente en el operador de turno (b). La Jefatura Provincial inspecciona, pero no responde del uso de la estación (c), y la empresa instaladora solo interviene en el montaje (d). #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 18.4 y 18.6 de la Orden IET/1311/2013: las estaciones fijas se clasifican en individuales y colectivas, y las fijas desatendidas se consideran colectivas. Solo las asociaciones de radioaficionados reconocidas pueden ser autorizadas a instalar estaciones colectivas, y de su utilización es responsable la Junta Directiva de la asociación.]])
#pq(12, 2, 28, "b", "F-R8.51", "Colectivas: licencia + autorización individualizada con distintivo propio",
  [Según el artículo 18.8 de la Orden IET/1311/2013, las estaciones colectivas de radioaficionado precisan para su funcionamiento:],
  ([únicamente la licencia de estación fija, sin ninguna autorización de radioaficionado], [la licencia de estación y una autorización de radioaficionado individualizada, a la que se asocia la licencia y que lleva su propio distintivo de llamada], [únicamente la autorización de radioaficionado personal del presidente de la asociación], [una autorización especial de la SETSI por cada banda de frecuencias que utilicen],),
  sol: [El art. 18.8 dice que las estaciones colectivas precisan, además de la licencia de estación, una autorización de radioaficionado individualizada a la que se considera asociada esa licencia, con un distintivo de llamada asignado según los arts. 27 y 28. No basta la licencia sola (a). Tampoco se trata de la autorización personal del presidente (c) ni de autorizaciones por banda (d): las autorizaciones especiales se reservan a casos concretos, como los de los arts. 16 y 17. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 18.8 de la Orden IET/1311/2013: una estación colectiva precisa, además de su licencia de estación, una autorización de radioaficionado individualizada, a la que se considera asociada la licencia y a la que se asigna un distintivo de llamada específico (arts. 27 y 28). Es una autorización propia de la estación, distinta de las de sus socios.]])
#pq(12, 2, 29, "b", "R9.29", "Reiteración: 2 o más sanciones firmes del mismo tipo en 3 años; la leve pasa a grave",
  [La reiteración en la comisión de infracciones leves:],
  ([carece de consecuencias], [puede dar lugar a que se califiquen como graves], [obliga a repetir el examen], [extingue la responsabilidad anterior],),
  sol: [La reiteración es una circunstancia que agrava: repetir conductas leves deja de ser un descuido y pasa a revelar un incumplimiento sostenido. La Ley 11/2022 la trata como infracción grave (art. 107.44): hay reiteración cuando se han impuesto sanciones firmes por dos o más infracciones del mismo tipo en un período de tres años (art. 109.6).])
#pq(12, 2, 30, "a", "R9.24", "Revocación: fines comerciales sí; no tener estación no es causa",
  [De las siguientes, _no_ es causa de revocación de una autorización de radioaficionado:],
  ([no disponer de una estación radioeléctrica], [causar interferencias y no corregirlas], [realizar emisiones con fines comerciales, publicitarios o lucrativos], [obstruir reiteradamente la labor inspectora],),
  sol: [Ser titular de la autorización no obliga a tener equipos: puede haberse aprobado el examen y no haber montado aún la estación, u operar en estaciones ajenas con permiso de sus titulares. Las otras tres sí comprometen la autorización. Las emisiones con fines comerciales, publicitarios o lucrativos son causa expresa de revocación (art. 8.1.b de la Orden IET/1311/2013), que remite además a las causas del reglamento de dominio público radioeléctrico: hoy el incumplimiento de las condiciones y requisitos técnicos o administrativos de uso y el empleo de las frecuencias para fines distintos de los autorizados (RD 123/2017, art. 95.1; Ley 11/2022, art. 95.3).])
#fin-prueba()
#soluciones-simulacro(12)

// ======================================================================
#simulacro(13)
#prueba(13, 1)
#pq(13, 1, 1, "b", "T1.36", "Resistencia de un conductor: R = ρ l / S",
  [La resistencia eléctrica de un conductor es directamente proporcional a:],
  ([su resistividad y su sección], [su resistividad y su longitud], [su sección y su longitud], [la tensión aplicada y la corriente],),
  sol: [$R = rho l slash S$: a doble longitud, doble resistencia, y un material de mayor resistividad la aumenta en la misma proporción. La sección aparece dividiendo, así que con ella la relación es inversa.])
#pq(13, 1, 2, "b", "T1.10", "Ley de Coulomb: proporcional al producto de las cargas e inversa al cuadrado de la distancia",
  [La ley de Coulomb establece que la fuerza entre dos cargas eléctricas es:],
  ([proporcional a la suma de las cargas], [directamente proporcional al producto de las cargas], [inversamente proporcional al producto de las cargas], [independiente de la distancia entre ellas],),
  sol: [Ley de Coulomb: $F = k q_1 q_2 slash d^2$, directamente proporcional al producto de las cargas e inversamente proporcional al cuadrado de la distancia.])
#pq(13, 1, 3, "d", "T1.14", "Las ondas de radio son electromagnéticas",
  [Las ondas de radio son de naturaleza:],
  ([gravitatoria], [mecánica], [acústica], [electromagnética],),
  sol: [Las ondas de radio son ondas electromagnéticas: campos eléctrico y magnético oscilantes que se propagan sin necesidad de medio material.])
#pq(13, 1, 4, "d", "F-T1.5", "Conversión entre valores de pico, pico a pico y eficaz de una sinusoide (V_ef = V_p / √2)",
  [Una señal sinusoidal de 20 V de pico a pico tiene un valor eficaz aproximado de:],
  ([20 V], [10 V], [14,1 V], [7,07 V],),
  sol: [De pico a pico hay el doble que de pico: $V_p = 20 slash 2 = 10$ V. El valor eficaz es $V_"ef" = V_p slash sqrt(2) = 10 slash 1,414 approx 7,07$ V. Los 10 V son el valor de pico, los 20 V el de pico a pico, y los 14,1 V resultan de dividir los 20 V entre $sqrt(2)$ sin partirlos antes por 2, es decir, de tomar el valor de pico a pico como si fuera el de pico. _(Véase tema T1, sección «Ondas y señales».)_])
#pq(13, 1, 5, "a", "F-T2.26", "Disipación máxima de una resistencia: tensión o corriente máximas a partir de P y R",
  [La tensión máxima que puede aplicarse a una resistencia de 100 Ω y 1 W, sin superar su potencia nominal, es de:],
  ([10 V], [1 V], [0,1 V], [100 V],),
  sol: [La disipación viene dada por $P = V^2 slash R$, de donde $V = sqrt(P R) = sqrt(1 times 100) = 10$ V. Comprobación: la corriente sería $I = V slash R = 0,1$ A y $P = V I = 10 times 0,1 = 1$ W. Los 100 V salen de multiplicar $P dot R$ sin extraer la raíz; los 0,1 V son la corriente en amperios tomada por tensión; y 1 V, la potencia en vatios tomada por voltios. Por encima de 10 V la resistencia disiparía más de 1 W y se calentaría hasta quemarse. _(Véase tema T2, sección «Resistencias».)_])
#pq(13, 1, 6, "c", "T2.10", "La reactancia capacitiva disminuye al aumentar la frecuencia",
  [Al aumentar la frecuencia, la reactancia de un condensador:],
  ([aumenta], [no varía], [disminuye], [se hace infinita],),
  sol: [$X_C = 1 slash (2 pi f C)$: al aumentar $f$, la reactancia capacitiva disminuye. En la bobina ocurre lo contrario.])
#pq(13, 1, 7, "a", "C-T2.13", "Aplicación del diodo: detección (y rectificación)",
  [Un diodo semiconductor:],
  ([Se utiliza en la detección], [Sirve para simplificar], [Es la base de los osciladores], [Aumenta la potencia del receptor],),
  sol: [
    Un diodo deja pasar la corriente en un solo sentido, y de esa asimetría vive el detector:
    rectifica la señal modulada y, con un filtro RC, recupera la envolvente, que es la información
    (detección de AM). Por eso la respuesta es a. «Simplificar» no es función de ningún componente
    (y si se leyera «amplificar», tampoco: el diodo no tiene ganancia). Un oscilador necesita un
    elemento activo con ganancia, como un transistor o una válvula, más realimentación, no un diodo
    corriente (c). Y el diodo es pasivo: no aumenta la potencia de nada (d). #vease[(Véase tema T2,
    sección «Semiconductores y otros componentes»; tema T3, sección «Clases de amplificación y
    detectores».)]
  ])
#pq(13, 1, 8, "a", "F-T2.14", "Diodo zéner: estabiliza tensión trabajando en inversa, en la zona de ruptura",
  [Un diodo zéner estabiliza una tensión, la suya nominal, cuando se conecta en serie con una resistencia y polarizado:],
  ([en inversa, con tensión suficiente para trabajar en la zona de ruptura], [en inversa, con una tensión inferior a la zéner, sin llegar a la ruptura], [en directa, como un diodo rectificador ordinario], [en alterna, sin polaridad definida],),
  sol: [El zéner se fabrica para que su ruptura inversa ocurra a una tensión precisa (5,6 V, 12 V, etc.) y la soporte sin daño: polarizado en inversa y en ruptura, su tensión queda casi constante aunque varíe la corriente, y la resistencia en serie limita esa corriente. Con una tensión inversa menor que la zéner (b) el diodo no conduce y no estabiliza nada; en directa (c) se comporta como un diodo normal, con una caída de unos 0,6 V; en alterna (d) no hay una tensión continua que fijar. _(Véase tema T2, sección «Semiconductores y otros componentes», y capítulo «La radio por dentro: componente a componente», sección 5.)_])
#pq(13, 1, 9, "b", "T2.48", "Polarización: en el NPN el colector es positivo; en el PNP, negativo",
  [En un transistor NPN empleado como amplificador, la polarización del colector respecto del emisor es:],
  ([alterna], [positiva], [nula], [negativa],),
  sol: [En un NPN la corriente convencional entra por el colector, que ha de estar a mayor potencial que el emisor. En el PNP todo se invierte, y de ahí que los circuitos con PNP lleven la alimentación negativa.])
#pq(13, 1, 10, "b", "F-T3.45", "Q = X/R en resonancia y ancho de banda B = f0/Q",
  [Un circuito resonante serie sintonizado a 7 MHz presenta, en resonancia, una reactancia inductiva de 300 Ω y una resistencia de pérdidas de 6 Ω. Su ancho de banda a −3 dB es aproximadamente de:],
  ([280 kHz], [140 kHz], [23 kHz], [350 MHz],),
  sol: [En resonancia serie, $Q = X slash R = 300 slash 6 = 50$. El ancho de banda es $B = f_0 slash Q = 7000 "kHz" slash 50 = 140$ kHz. Los 23 kHz resultan de tomar $Q = X = 300$ sin dividir entre $R$; los 280 kHz, de entender $f_0 slash Q$ como la desviación a cada lado de $f_0$ y doblarla; y los 350 MHz, de invertir $Q$ ($R slash X = 0,02$), lo que daría un ancho de banda mayor que la propia frecuencia: absurdo. Con menos pérdidas, $Q$ sube y la curva se estrecha. _(Véase tema T3, sección «Asociación de componentes y resonancia».)_])
#pq(13, 1, 11, "c", "F-T3.29", "Filtros FIR (sin realimentación, respuesta finita) e IIR (realimentan la salida, respuesta infinita)",
  [Un filtro digital FIR (de respuesta finita al impulso) se caracteriza porque:],
  ([solo puede construirse con bobinas y condensadores, nunca mediante un procesador digital], [es un filtro analógico basado en un cristal de cuarzo, de banda muy estrecha], [calcula cada muestra de salida combinando un número finito de muestras de entrada, sin realimentar la salida], [realimenta su propia salida hacia la entrada, por lo que su respuesta a un impulso se prolonga indefinidamente],),
  sol: [FIR son las siglas de _finite impulse response_. Cada muestra de salida es una combinación de un número finito de muestras de entrada, sin volver a usar la salida; por eso un impulso deja de notarse pasado ese número de muestras. La opción que habla de realimentar la salida describe un filtro IIR. Los filtros FIR se calculan en un DSP: no son circuitos analógicos de cristal ni de bobinas y condensadores. _(Véase tema T3, sección «Filtros, osciladores y mezcladores».)_])
#pq(13, 1, 12, "d", "F-T3.8", "Regulador con zéner y resistencia en serie: reparto de corrientes entre zéner y carga",
  [Una fuente de 20 V alimenta, a través de una resistencia en serie de 150 Ω, un zéner de 12 V en paralelo con una carga que consume 30 mA. Con el zéner regulando a 12 V, la corriente que circula por él es aproximadamente de:],
  ([53 mA], [83 mA], [30 mA], [23 mA],),
  sol: [La resistencia en serie soporta 20 − 12 = 8 V y deja pasar $8 slash 150 approx 53$ mA. Esa corriente se reparte entre la carga (30 mA) y el zéner, que absorbe el resto: 53 − 30 ≈ 23 mA. Los 53 mA son la corriente total, no la del zéner; los 30 mA son los de la carga; y 83 mA saldría de sumar en lugar de restar. _(Véase tema T3, sección «Fuentes de alimentación y amplificadores», y capítulo «La radio por dentro», apartado «Sub-circuito 4: el zéner, la ruptura domesticada».)_])
#pq(13, 1, 13, "a", "T3.22", "Ángulo de conducción: A 360°, AB entre 180° y 360°, B 180°, C menos de 180°",
  [Un amplificador que trabaja en clase B conduce durante:],
  ([180° del ciclo de la señal], [90° del ciclo de la señal], [los 360° del ciclo de la señal], [todo el ciclo menos los picos],),
  sol: [Medio ciclo exacto. Por eso la clase B se monta en contrafase: dos dispositivos que se reparten un semiciclo cada uno y entre los dos reconstruyen la onda completa.])
#pq(13, 1, 14, "c", "T3.38", "Detector de envolvente (diodo + RC): detector de AM; reconocer su esquema",
  [El llamado detector de envolvente se emplea en receptores para señales con modulación de:],
  ([frecuencia], [impulsos], [amplitud], [fase],),
  sol: [En AM la información viaja en la envolvente, y un diodo con su filtro $R C$ la sigue directamente. Para FM haría falta un discriminador, y para SSB un detector de producto: el de envolvente no sirve donde no hay portadora.])
#pq(13, 1, 15, "d", "T4.36", "El mezclador necesita el oscilador local: bloque que falta en un diagrama",
  [En el diagrama de bloques de la figura, correspondiente a un receptor superheterodino, el bloque señalado con una interrogación es:
  #circuito[
    #_t4-diagrama(
      spacing: (8mm, 8mm),
      node((0, 0), _t4-t[antena], stroke: none, fill: none),
      node((1, 0), _t4-t[ampl.\ RF], shape: rect),
      node((2, 0), _t4-t[mezclador], shape: rect),
      node((3, 0), _t4-t[FI], shape: rect, width: 13mm),
      node((4, 0), _t4-t[detector], shape: rect),
      node((5, 0), _t4-t[audio], shape: rect, width: 13mm),
      _t4-preg((2, 1)),
      edge((0, 0), (1, 0), "-|>"),
      edge((1, 0), (2, 0), "-|>"),
      edge((2, 0), (3, 0), "-|>"),
      edge((3, 0), (4, 0), "-|>"),
      edge((4, 0), (5, 0), "-|>"),
      edge((2, 1), (2, 0), "-|>"),
    )
  ]],
  ([el silenciador], [el altavoz], [la fuente de alimentación], [el oscilador local],),
  sol: [Lo que alimenta al mezclador junto con la señal de antena es el oscilador local: de su batido sale la frecuencia intermedia. Sin él no hay conversión y el superheterodino no funciona.])
#pq(13, 1, 16, "c", "T4.4", "Relación entre señal, oscilador local y FI: OL por encima f_s = f_OL − f_FI; OL por debajo f_s = f_OL + f_FI",
  [Si se desea sintonizar una señal de 7 MHz en un receptor cuya frecuencia intermedia es de 9 MHz, el oscilador local deberá funcionar a:],
  ([2,5 MHz], [9 MHz], [16 MHz], [63 MHz],),
  sol: [$f_"OL" = f_"señal" + f_"FI" = 7 + 9 = 16$ MHz.])
#pq(13, 1, 17, "c", "C-T5.30", "Excursión máxima de la NBFM: unos ±2,5 a ±5 kHz",
  [En los equipos de radioaficionado, el modo de modulación NBFM (banda estrecha de frecuencia
modulada), ¿qué excursión de frecuencia máxima permite?],
  ([12 kHz], [±75 kHz], [Unos ±2,5 a ±5 kHz], [±25 kHz],),
  sol: [
    La NBFM de las bandas de aficionado (VHF/UHF, con canales de 12,5 o 25 kHz) limita la excursión
    (desviación) a unos ±2,5 a ±5 kHz. Los 12 kHz que da el banco no son una excursión, sino la
    anchura de banda típica de la emisión (pregunta T4.35 del cuaderno): por la regla de Carson,
    $B ≈ 2(Δ f + f_m) = 2(2,5 + 3) ≈ 11$ kHz, es decir, unos 12 kHz. Los ±75 kHz son la excursión de
    la FM de radiodifusión (banda ancha). Se corrige la clave del banco: si en un examen aparece 12
    kHz como respuesta a esta pregunta, se está confundiendo excursión con anchura de banda.
    #vease[(Véase tema T5, sección «Arquitecturas y características generales» (desviación e índice
    de modulación de FM); la anchura de banda de la NBFM, en una pregunta del tema T4.)]
    #no-esta[La excursión o desviación $Δ f$ es lo que se aparta la portadora de su frecuencia central al
    ritmo de la voz: es la magnitud que controla la modulación en FM. En la FM de banda estrecha
    (NBFM) se limita a ±2,5 kHz (canales de 12,5 kHz) o ±5 kHz (canales de 25 kHz), frente a los ±75
    kHz de la FM comercial. No hay que confundirla con la anchura de banda, que estima la regla de
    Carson, $B ≈ 2(Δ f + f_m)$, y en NBFM es del orden de 12 kHz.]
    #_apb1-clave[«12 kHz.». Es la clave que dan las recopilaciones de exámenes reales (2007–2011): conviene
    conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea la
    técnicamente correcta.]
  ])
#pq(13, 1, 18, "b", "T5.32", "Contra la sobremodulación: bajar el nivel de BF aplicado al modulador",
  [Para evitar la sobremodulación de un transmisor hay que actuar sobre:],
  ([la longitud de la línea de transmisión], [el nivel de la señal de baja frecuencia aplicada al modulador], [la frecuencia del oscilador], [la tensión de alimentación de la etapa final],),
  sol: [La sobremodulación es un exceso de audio, no de radiofrecuencia: se corrige bajando la ganancia de micrófono o el nivel de entrada al modulador. Tocar la alimentación de la etapa final cambiaría la potencia, no el índice de modulación.])
#pq(13, 1, 19, "a", "T5.7", "ALC: limita la excitación del final y evita emisiones interferentes alrededor de la frecuencia",
  [El control automático de nivel (ALC) de un transmisor permite:],
  ([evitar emisiones interferentes alrededor de la frecuencia de trabajo], [reducir el consumo del amplificador final], [elevar la potencia de salida por encima de la nominal], [aumentar la profundidad de modulación],),
  sol: [El ALC limita la excitación del final para que no se sobrecargue: evita distorsión y splatter alrededor de la frecuencia.])
#pq(13, 1, 20, "c", "T6.35", "La vertical de cuarto de onda necesita plano de tierra o radiales",
  [Una antena vertical de cuarto de onda necesita, para funcionar correctamente:],
  ([alimentarse siempre por su extremo superior], [una línea de alimentación simétrica], [un plano de tierra o un juego de radiales], [una longitud igual a media longitud de onda],),
  sol: [La vertical es, en el fondo, media antena: el plano de tierra hace de espejo y crea la otra mitad por imagen. Sin él no hay contra qué trabajar y el rendimiento se desploma.])
#pq(13, 1, 21, "b", "T6.4", "La Yagi es una antena directiva (un lóbulo principal dominante)",
  [Las antenas Yagi son antenas:],
  ([omnidireccionales], [directivas], [exclusivamente receptoras], [isótropas],),
  sol: [La Yagi concentra la radiación hacia los directores: la directiva por excelencia.])
#pq(13, 1, 22, "d", "T6.11", "Adaptación perfecta: ROE = 1, coeficiente de reflexión 0, potencia reflejada nula",
  [Con un acoplamiento óptimo entre el transmisor y la antena, el medidor de ondas estacionarias indicará:],
  ([cincuenta], [cero], [infinito], [uno],),
  sol: [Adaptación perfecta $arrow.r.double$ sin onda reflejada $arrow.r.double$ ROE = 1 (1:1).])
#pq(13, 1, 23, "a", "C-T7.9", "Asignar una frecuencia concreta a su banda con λ = 300/f",
  [La frecuencia de 144 MHz está incluida en las ondas:],
  ([métricas], [kilométricas], [milimétricas], [hectométricas],),
  sol: [
    A 144 MHz, $λ = 300 slash 144 ≈ 2,08$ m (la banda de 2 m). Está entre 30 y 300 MHz: VHF, ondas
    métricas (1–10 m). Las milimétricas son EHF (30–300 GHz), las kilométricas LF (30–300 kHz) y las
    hectométricas MF (300 kHz–3 MHz). #vease[(Véase tema T7, sección «Cómo se nombran las bandas».)]
  ])
#pq(13, 1, 24, "b", "F-T7.16", "El horizonte radioeléctrico es algo mayor que el óptico (la troposfera curva el rayo)",
  [En condiciones normales, el horizonte radioeléctrico es:],
  ([muy superior al óptico, porque la ionosfera devuelve la onda a tierra], [algo mayor que el horizonte óptico, porque la troposfera curva el rayo hacia el suelo], [exactamente igual al horizonte óptico, porque la onda viaja en línea recta], [algo menor que el horizonte óptico, porque la troposfera absorbe parte de la señal],),
  sol: [La densidad del aire disminuye con la altura, así que el índice de refracción de la troposfera también decrece y el rayo se curva ligeramente hacia el suelo, siguiendo a la Tierra. Resultado: el horizonte radioeléctrico supera al óptico en torno a un 15 % (la fórmula pasa de $3,57 sqrt(h)$ a $4,12 sqrt(h)$ kilómetros, con $h$ en metros). No es menor ni igual, y en VHF la ionosfera no interviene: es transparente. #vease[(Véase tema T7, sección «La ionosfera y la onda de espacio».)]])
#pq(13, 1, 25, "d", "C-T8.1", "Conexión de los instrumentos: amperímetro en serie, voltímetro en paralelo, óhmetro sobre el componente",
  [En la realización de medidas, usando un polímetro, indique la respuesta correcta:],
  ([para medidas de tensión, se conectan las puntas de prueba en serie con el elemento en el que
deseamos medir la tensión], [para medidas de corriente, se conectan las puntas de prueba en paralelo con el elemento a través
del cual circula la corriente que deseamos medir], [para medidas de resistencia, se conectan las puntas de prueba en serie con la resistencia que
deseamos medir], [ninguna de las respuestas anteriores es correcta],),
  sol: [
    Las tres afirmaciones están al revés. La tensión se mide con las puntas en #emph[paralelo] con
    el elemento. La corriente se mide en #emph[serie]: se abre el circuito y se intercala el
    polímetro (en paralelo sería un cortocircuito casi directo). La resistencia se mide con el
    componente aislado y sin tensión, con las puntas aplicadas a sus terminales, es decir, en
    paralelo con ella y no en serie. Como las tres son falsas, la correcta es «ninguna de las
    anteriores». #vease[(Véase tema T8, sección «Técnica de medida».)]
    #no-esta[En la función de óhmetro, el polímetro inyecta por las puntas una pequeña corriente propia y
    mide la tensión resultante. Por eso las puntas van en los dos extremos de la resistencia (en
    paralelo con ella), con el componente fuera de tensión y, si está en un circuito, con al menos
    un extremo desconectado; si no, circula corriente de otros componentes y la lectura se falsea.
    Resumen: voltímetro en paralelo, amperímetro en serie, óhmetro en paralelo y sin tensión.]
  ])
#pq(13, 1, 26, "c", "", "Potencia media frente a p.c.e. (coinciden con amplitud constante; en SSB la media es mucho menor)",
  [En una emisión de CW con el manipulador apretado (portadora sin modular), la potencia media y la potencia en la cresta de la envolvente (p.c.e.):],
  ([la p.c.e. es el doble que la media], [la media es mayor que la p.c.e.], [coinciden, porque la amplitud es constante], [la p.c.e. es cuatro veces la media],),
  sol: [Con amplitud constante (CW con el manipulador apretado, o FM) no hay picos de envolvente y las dos potencias coinciden. En SSB con voz, en cambio, una p.c.e. de 100 W corresponde a una media de solo 10 a 25 W. El factor 4 aparece en AM modulada al 100 %, entre el pico de la envolvente y la portadora.])
#pq(13, 1, 27, "a", "", "Detección en circuitos de audio: una unión semiconductora rectifica la RF y recupera la envolvente",
  [Mientras transmites en AM, tu voz se oye por los altavoces del equipo de música de un vecino, que no tiene sintonizador de radio. El mecanismo responsable es:],
  ([la detección: una unión semiconductora del amplificador rectifica la RF captada por los cables y recupera la envolvente], [la intermodulación entre tu señal y la red eléctrica], [el bloqueo del amplificador por exceso de ganancia], [la recepción por la frecuencia imagen],),
  sol: [Los cables del equipo hacen de antena y llevan la RF hasta los transistores. La unión base-emisor se comporta como un diodo, rectifica la RF y deja su envolvente, que en AM es tu voz: el amplificador la trata como audio. Es un problema de inmunidad del equipo afectado y se combate con ferritas y condensadores de desacoplo en sus cables.])
#pq(13, 1, 28, "d", "C-T9.3", "Cable blindado para los altavoces",
  [Para evitar interferencias en los altavoces de un equipo de baja frecuencia, se debe:],
  ([Conectar a masa los terminales del altavoz.], [Utilizar para su conexión cable de igual longitud de onda que la señal interferente.], [Conectar un diodo detector entre los terminales del altavoz.], [Utilizar para su conexión cable blindado.],),
  sol: [
    El cable del altavoz se comporta como una antena: capta radiofrecuencia y el amplificador la
    detecta, de modo que la voz del transmisor sale por el altavoz. El remedio es el
    apantallamiento: un cable blindado lleva una malla metálica alrededor de los conductores que
    desvía a masa la RF inducida antes de que llegue a la señal de audio. Un cable de longitud igual
    a la longitud de onda de la interferencia haría lo contrario: sería una antena eficaz para ella.
    Poner a masa los terminales cortocircuitaría la salida de audio, y un diodo detector entre ellos
    distorsionaría la señal. #vease[(Véase tema T9, sección «Medidas correctoras».)]
    #no-esta[Un cable blindado (o apantallado) lleva, alrededor de sus conductores, una malla o cinta
    metálica conectada a masa. Esa pantalla actúa como una jaula de Faraday alargada: la RF exterior
    induce corriente en la malla y se descarga a masa sin alcanzar el conductor interior, y a la
    inversa el cable tampoco radia. Es la misma idea de apantallar una caja, aplicada a los cables.
    Un cable sin pantalla, como el del altavoz, es una antena que recoge la interferencia y la
    introduce en el circuito de audio.]
  ])
#pq(13, 1, 29, "b", "T10.16", "Antes de manipular un equipo: desconectarlo de la red y descargar los condensadores",
  [Antes de manipular el interior de un equipo es imprescindible:],
  ([ponerlo en funcionamiento para localizar la avería], [desconectarlo de la red y descargar los condensadores], [conectar la antena a la carga artificial], [aumentar la ventilación del equipo],),
  sol: [Desenchufar no basta: los condensadores del filtro conservan la carga, y en un equipo valvular esa carga está a cientos o miles de voltios. Hay que descargarlos antes de meter la mano.])
#pq(13, 1, 30, "a", "T10.31", "Antena lejos de las líneas eléctricas aéreas: distancia mayor que la altura total del conjunto",
  [La distancia entre una antena y una línea eléctrica aérea debe ser:],
  ([mayor que la altura total del conjunto de mástil y antena], [de al menos un metro], [la que permita el espacio disponible], [indiferente si la línea está aislada],),
  sol: [El criterio no es una distancia fija sino geométrico: si el conjunto cae, no debe poder alcanzar la línea. Que el conductor parezca aislado no cambia nada — a esas tensiones el aislamiento exterior no es una garantía.])
#fin-prueba()
#prueba(13, 2)
#pq(13, 2, 1, "a", "R1.7", "M Mike y V Victor",
  [En el alfabeto fonético internacional, la letra «M» se identifica con la palabra:],
  ([Mike], [Metro], [Mario], [Madrid],),
  sol: [«M» es _Mike_. Mario, Madrid y Metro pertenecen a alfabetos nacionales antiguos, que no se emplean en el servicio de aficionados.])
#pq(13, 2, 2, "c", "C-R2.3", "QRS transmita más despacio / QRQ más deprisa",
  [¿Qué abreviatura indica que se transmita más lentamente?],
  ([QSJ], [QTR], [QRS], [QTH],),
  sol: [QRS es «transmita más despacio» (o «¿debo transmitir más despacio?»); la S es de #emph[slow]. Su opuesto es QRQ, «transmita más deprisa» (la Q de #emph[quick]). Los distractores son otros grupos: QTR es la hora exacta, QTH la posición o localidad y QSJ la tasa por palabra. La pregunta también cae a la inversa («QRS significa…»), donde otros distractores típicos son QSB (las señales se desvanecen) y QRZ (está siendo llamado por…). #vease[(Véase tema R2, tablas de grupos del código Q (QRS en la primera, QRQ en la segunda).)]])
#pq(13, 2, 3, "b", "F-R2.5", "Escalas de respuesta: QRK y QSA de 1 a 5; QRI de 1 a 3",
  [Las respuestas a #_apc2-m[QRK] (inteligibilidad), #_apc2-m[QSA] (fuerza de la señal) y #_apc2-m[QRI] (tono) son cifras. ¿Con qué escala se expresa cada una?],
  ([#_apc2-m[QRK], #_apc2-m[QSA] y #_apc2-m[QRI]: las tres de 1 a 5], [#_apc2-m[QRK] y #_apc2-m[QSA] de 1 a 5; #_apc2-m[QRI] de 1 a 3], [#_apc2-m[QRK], #_apc2-m[QSA] y #_apc2-m[QRI]: las tres de 1 a 9], [#_apc2-m[QRK] de 1 a 5; #_apc2-m[QSA] y #_apc2-m[QRI] de 1 a 9],),
  sol: [En la lista internacional del código Q, #_apc2-m[QRK] se responde con una cifra de 1 (mala) a 5 (excelente), #_apc2-m[QSA] de 1 (apenas perceptible) a 5 (muy buena) y #_apc2-m[QRI] de 1 a 3, con la escala al revés: 1 buena, 2 variable y 3 mala. Las opciones con 9 traen las escalas del informe #_apc2-m[RST], donde la intensidad y el tono sí llegan a 9, pero ese es otro código; la de las tres de 1 a 5 olvida que #_apc2-m[QRI] solo tiene tres valores. Y ojo con el sentido: en #_apc2-m[QRI] el número más alto es el peor. #vease[(Véase tema R2, tablas de grupos del código Q (#_apc2-m[QRK], #_apc2-m[QSA] y #_apc2-m[QRI]).)] #no-esta[Los grupos de calidad de la señal se contestan con una cifra. #_apc2-m[QRK] (inteligibilidad): de 1 (mala) a 5 (excelente). #_apc2-m[QSA] (fuerza de la señal): de 1 (apenas perceptible) a 5 (muy buena). #_apc2-m[QRI] (tono): de 1 a 3, con la escala al revés: 1 buena, 2 variable, 3 mala. Son escalas distintas de las del informe #_apc2-m[RST], que llega a 9 en intensidad y en tono.]])
#pq(13, 2, 4, "a", "R2.19", "QSK puedo oírle entre mis señales (break-in)",
  [El grupo `QSK` indica que:],
  ([se puede oír al corresponsal entre las propias señales], [la frecuencia está ocupada], [las señales se reciben con interferencias], [se va a cerrar la estación],),
  sol: [Es la escucha entre impulsos de telegrafía, lo que en inglés se llama _full break-in_: permite que el corresponsal interrumpa sin esperar al final de la transmisión. La frecuencia ocupada es `QRL`.])
#pq(13, 2, 5, "c", "R3.6", "CW telegrafía Morse (onda continua)",
  [La abreviatura `CW` se refiere a:],
  ([una llamada de socorro], [la banda ciudadana], [la telegrafía en código Morse (onda continua)], [la telefonía comercial],),
  sol: [`CW` (_continuous wave_): telegrafía en Morse.])
#pq(13, 2, 6, "b", "F-R3.2", "GL buena suerte",
  [La abreviatura #_apc2-m[GL] se emplea para desear al corresponsal:],
  ([buenas tardes], [buena suerte], [buenas noches], [buenos días],),
  sol: [#_apc2-m[GL] es _good luck_: «buena suerte». Los distractores son las otras abreviaturas en «G» de los saludos, todas del inglés: #_apc2-m[GM] (_good morning_, buenos días), #_apc2-m[GN] (_good night_, buenas noches) y #_apc2-m[GE] (_good evening_, buenas tardes). Fíjate en la segunda letra: M de _morning_, N de _night_, E de _evening_ y L de _luck_. #no-esta[Además de las abreviaturas de las tablas hay otras muy habituales. Los saludos se abrevian con la G de _good_ y la inicial de lo que se desea: #_apc2-m[GM] (_morning_, buenos días), #_apc2-m[GE] (_evening_, buenas tardes), #_apc2-m[GN] (_night_, buenas noches) y #_apc2-m[GL] (_luck_, buena suerte).]])
#pq(13, 2, 7, "a", "F-R3.1", "SWL radioescucha (short wave listener)",
  [En el argot de los radioaficionados, un #_apc2-m[SWL] es:],
  ([un radioescucha: una persona aficionada a escuchar emisiones de onda corta], [un medidor de la relación de ondas estacionarias], [una estación que emite en banda lateral única con baja potencia], [la llamada general a todas las estaciones],),
  sol: [#_apc2-m[SWL] viene de _short wave listener_: es el radioescucha, la persona aficionada a escuchar emisiones de onda corta. Los distractores son confusiones típicas: la relación de ondas estacionarias se abrevia _SWR_ (ROE en español), no #_apc2-m[SWL]\; la banda lateral única es #_apc2-m[SSB] y la llamada general a todas las estaciones es #_apc2-m[CQ]. #no-esta[Entre las abreviaturas de uso corriente que no figuran en las tablas está #_apc2-m[SWL], de _short wave listener_: el radioescucha, es decir, la persona aficionada a escuchar emisiones de onda corta. La última letra importa: _SWR_, con R, es la relación de ondas estacionarias, que se mide en la línea de la antena.]])
#pq(13, 2, 8, "a", "R4.11", "Prioridad: seguridad < urgencia < socorro",
  [Entre las tres señales, el orden de prioridad de menor a mayor es:],
  ([seguridad, urgencia y socorro], [socorro, urgencia y seguridad], [las tres tienen la misma prioridad], [urgencia, seguridad y socorro],),
  sol: [De menor a mayor: seguridad (_Sécurité_, avisos de navegación o meteorológicos), urgencia (_Pan Pan_, un problema serio sin peligro inminente) y socorro (_Mayday_, peligro grave e inminente). El socorro tiene prioridad absoluta sobre cualquier otra comunicación.])
#pq(13, 2, 9, "d", "F-R4.12", "Banda de 2 m en la Región 1: 144–146 MHz",
  [La banda de 2 m atribuida al Servicio de Aficionados en España (Región 1) comprende:],
  ([146 a 148 MHz], [140 a 144 MHz], [144 a 148 MHz], [144 a 146 MHz],),
  sol: [El Anexo I de la Orden (apartado 3.1, tabla de potencias) recoge la banda de 2 m como 144 a 146 MHz, y el CNAF la atribuye en España a aficionados y aficionados por satélite. Los 146–148 MHz son de aficionados en las Regiones 2 y 3, pero en la Región 1 son de fijo y móvil: por eso «144 a 148» es el error típico. «146 a 148» no incluye ni un solo megahercio de la banda, y «140 a 144» termina justo donde ella empieza. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]])
#pq(13, 2, 10, "c", "R5.10", "Identificación de móviles y portables: /M, /MM, /MA, /P en grafía; palabras («portable») en fonía; no existe /AM",
  [Una estación de aficionado móvil marítima identificará su emisión añadiendo a su distintivo:],
  ([/AM], [/`QRP`], [/MM], [/P],),
  sol: [/MM = móvil marítima; /P portable, /M móvil. El sufijo aeronáutico reglamentario es /MA (art. 29): el «/AM» del enunciado ni siquiera existe en la Orden.])
#pq(13, 2, 11, "b", "C-R5.5", "Distritos peninsulares: asignar provincia a su cifra y leer la cifra de un distintivo",
  [¿Cuál de las siguientes proposiciones contiene mayor número de provincias adscritas al distrito 4?:],
  ([Málaga, Murcia, Madrid, Vizcaya.], [Cáceres, Cádiz, Cuenca, Ciudad Real.], [Córdoba, Castellón, Cantabria, Burgos.], [Toledo, Teruel, Tarragona, Santa Cruz de Tenerife.],),
  sol: [Se cuentan las provincias del distrito 4 (Madrid, Toledo, Ciudad Real, Cuenca, Guadalajara, Badajoz y Cáceres) en cada opción. a: solo Madrid (Málaga es del 7, Murcia del 5, Vizcaya del 2). b: Cáceres, Cuenca y Ciudad Real, tres (Cádiz es del 7). c: ninguna (Córdoba 7, Castellón 5, Cantabria y Burgos 1). d: solo Toledo (Teruel es del 2, Tarragona del 3 y Santa Cruz de Tenerife del 8). Gana la b con tres. #vease[(Véase tema R5, tabla «Distritos de los distintivos de llamada españoles».)]

    #no-esta[Distrito 4 (art. 27 de la Orden IET/1311/2013): Madrid, Toledo, Ciudad Real, Cuenca, Guadalajara, Badajoz y Cáceres. El cuaderno lo resume como «Madrid, Castilla-La Mancha (parte) y Extremadura»: de Castilla-La Mancha solo queda fuera Albacete, que es del distrito 5. Cádiz, Málaga y Córdoba son del 7 (Andalucía); Murcia y Castellón, del 5.]])
#pq(13, 2, 12, "d", "R5.28", "Sufijo de una letra: reservado también para concursos internacionales de alta competitividad",
  [Los distintivos de llamada con sufijo de una sola letra se reservan para:],
  ([las estaciones instaladas en Ceuta y Melilla], [las estaciones de menor potencia], [los radioaficionados noveles], [la participación en concursos internacionales de alta competitividad],),
  sol: [Un sufijo de una sola letra es lo más corto —y por tanto lo más rápido de transmitir— que puede haber, y ahí está su valor: en concursos, cada carácter ahorrado cuenta. Por eso el art. 27.3 los reserva, asimismo, para la participación en concursos internacionales de alta competitividad. No quedan cerrados a ese uso: el mismo artículo permite asignarlos como distintivo permanente a titulares con cinco años de autorización española, quince de práctica internacional y sin expediente sancionador en los últimos cinco años, y desde el 19-09-2026 hay un procedimiento ordinario para pedirlos (Resolución de 29-07-2026 de la SETID, hoy la SETSI de la Orden; BOE-A-2026-17504, que deroga la de 2019). Ni la potencia, ni la condición de novel, ni la ubicación intervienen.])
#pq(13, 2, 13, "c", "F-R5.14", "Prefijo AO optativo para españoles en zonas no adscritas a soberanías nacionales",
  [Además de en eventos relevantes de ámbito internacional, el prefijo #_apc2-m[AO] puede utilizarse, con carácter optativo, en las emisiones de radioaficionados españoles:],
  ([desde Ceuta y Melilla], [desde las islas Canarias], [desde zonas no adscritas a soberanías nacionales], [en eventos relevantes de ámbito nacional],),
  sol: [El art. 27.1.d asigna #_apc2-m[AO] a eventos relevantes de ámbito internacional y, con carácter optativo, a las emisiones de radioaficionados españoles desde zonas no adscritas a soberanías nacionales. Ceuta, Melilla y Canarias son territorio español y ya se identifican con las cifras de distrito 9 y 8 (#_apc2-m[EA9], #_apc2-m[EA8]); no necesitan prefijo especial. Los eventos relevantes de ámbito nacional corresponden a #_apc2-m[AM] y #_apc2-m[AN] (art. 27.1.c). #vease[(Véase tema R5, sección «Sufijos y usos temporales».)] #no-esta[El prefijo #_apc2-m[AO] tiene dos usos: eventos relevantes de ámbito internacional y, con carácter optativo, las emisiones de radioaficionados españoles desde zonas no adscritas a soberanías nacionales (art. 27.1.d). Para eventos relevantes de ámbito nacional se usan #_apc2-m[AM] y #_apc2-m[AN]. Como el resto de prefijos temporales, requiere autorización previa de la Jefatura Provincial.]])
#pq(13, 2, 14, "b", "F-R6.6", "Balizas en HF: 14.099–14.101 kHz exclusivo del International Beacon Project",
  [El segmento 14.099–14.101 kHz del plan de bandas HF de la IARU para la Región 1 está reservado exclusivamente a:],
  ([comunicaciones de emergencia], [balizas del _International Beacon Project_], [telegrafía de baja potencia (QRP)], [voz digital],),
  sol: [El plan marca 14.099–14.101 kHz, con centro en 14.100 kHz, como «International Beacon Project: beacons exclusively». Solo balizas, y ni siquiera se acepta ahí un QSO en CW. Los otros usos tienen su centro de actividad en otra parte: emergencia mundial en 14.300 kHz, voz digital en 14.130 kHz y telegrafía QRP en 14.060 kHz. Esa exclusividad permite escuchar las balizas, que sirven para estudiar la propagación, sin interferencias. #vease[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)] #no-esta[Una radiobaliza es una estación automática desatendida que emite su identificación para estudiar la propagación. En HF, el plan de la IARU para la Región 1 les reserva en exclusiva segmentos de 2 kHz: 14.099–14.101, 18.109– 18.111, 21.149–21.151 y 24.929–24.931 kHz, además de varios tramos en 28 MHz. En esos segmentos no debe hacerse ningún otro tipo de comunicación, ni siquiera en CW.]])
#pq(13, 2, 15, "d", "F-R6.3", "Las frecuencias del plan HF son las realmente transmitidas, no la del dial",
  [En el plan de bandas HF de la IARU para la Región 1, las frecuencias de los segmentos se entienden como:],
  ([frecuencias del dial, es decir, de la portadora suprimida], [frecuencias de recepción, sin aplicación a la emisión], [frecuencias centrales del canal de 3 kHz de cada emisión], [frecuencias realmente transmitidas (las que ocupa la emisión), no la de la portadora suprimida],),
  sol: [La nota del plan HF es explícita: las frecuencias del plan son «frecuencias transmitidas», no las de la portadora suprimida. Lo que debe quedar dentro del segmento es toda la emisión, no solo el dial. Por eso en LSB, donde la banda lateral cuelga por debajo del dial, el plan fija el ajuste de dial mínimo para fonía: 1.843, 3.603 y 7.053 kHz, tres kilohercios por encima del borde inferior del segmento. En USB ocurre al revés: de 20 a 10 m el dial máximo queda 3 kHz por debajo del borde superior de la banda. La opción a) es justo lo que la nota descarta. #vease[(Véase tema T1, sección «Señales moduladas» (SSB con portadora suprimida).)] #no-esta[En SSB la portadora se suprime: la frecuencia del dial es la de esa portadora y la señal ocupa unos 2,7 kHz a un lado, por debajo en LSB y por encima en USB. El plan HF de la IARU para la Región 1 se refiere a las frecuencias realmente transmitidas, no a la del dial. Por eso indica ajustes de dial límite: en LSB, como mínimo 1.843, 3.603 y 7.053 kHz (3 kHz sobre el borde del segmento); en USB, de 20 a 10 m, como máximo 3 kHz por debajo del borde superior de la banda.]])
#pq(13, 2, 16, "a", "F-R7.2", "Código del Radioaficionado: considerado, leal, progresista, amistoso, equilibrado y patriota",
  [Según el «Código del Radioaficionado» (_Amateur’s Code_), el radioaficionado es considerado, leal, progresista, amistoso, equilibrado y:],
  ([patriota], [disciplinado], [altruista], [competitivo],),
  sol: [El Código del Radioaficionado (_Amateur’s Code_) es una adaptación, recogida en el manual de la IARU _Ethics and Operating Procedures for the Radio Amateur_, del que redactó P. M. Segal en 1928. Describe al radioaficionado como considerado, leal, progresista, amistoso, equilibrado y patriota: tiene su estación y sus conocimientos siempre dispuestos para servir al país y a la comunidad. Disciplinado, competitivo y altruista no figuran entre esos seis rasgos. #vease[(Véase tema R7, sección «Responsabilidad social y procedimientos operativos».)] #no-esta[El Código del Radioaficionado (_Amateur’s Code_, P. M. Segal, 1928) resume la conducta ideal en seis rasgos. Considerado: nunca opera de modo que reste placer a otros. Leal: apoya a los demás aficionados, a los radioclubes y a su asociación nacional. Progresista: estación bien construida y al día, y operación irreprochable. Amistoso: paciente con el principiante y dispuesto a ayudar. Equilibrado: la radio es una afición que no debe quitar tiempo a la familia, al trabajo, a los estudios ni a la comunidad. Patriota: estación y conocimientos siempre al servicio del país y de la comunidad.]])
#pq(13, 2, 17, "a", "R8.41", "Radiobaliza: desatendida para estudios de propagación que emite señales de identificación",
  [Una estación automática desatendida de radioaficionado destinada a realizar estudios de propagación, cuyo funcionamiento se basa en la emisión automática de señales de identificación, recibe el nombre de:],
  ([radiobaliza], [estación de calibración], [radiofaro comercial], [estación piloto],),
  sol: [Radiobaliza (anexo I de la Orden IET/1311/2013): estación automática desatendida de radioaficionado destinada a estudios de propagación, cuyo funcionamiento se basa en la emisión automática de señales de identificación. Transmite su distintivo a intervalos no superiores a tres minutos (art. 25.e) y su información se refiere, salvo casos justificados, a su posición y condiciones de funcionamiento (art. 25.f). La redacción antigua la llamaba «estación colectiva fija» (Orden ITC/1791/2006).])
#pq(13, 2, 18, "d", "F-R8.63", "Radiobaliza: sistema radiante omnidireccional",
  [Según el art. 25.f de la Orden IET/1311/2013, el sistema radiante de una radiobaliza del Servicio de Aficionados será, como norma general:],
  ([directivo, con una antena Yagi de alta ganancia para aumentar el alcance], [de polarización circular, obligatoriamente], [un dipolo horizontal orientado de este a oeste], [omnidireccional],),
  sol: [Art. 25.f: el sistema radiante de una radiobaliza será, como norma general, omnidireccional. La lógica es clara: una baliza sirve para que cualquier estación la oiga, esté en la dirección que esté, y pueda valorar así la propagación. Una Yagi (a) concentra la señal en una dirección y deja sin ella las demás; un dipolo horizontal (c) tiene nulos marcados en la dirección de su eje. La polarización circular (b) no se exige en la norma. #_apc3-ver[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

#_apc3-net[Art. 25.f de la Orden IET/1311/2013: el sistema radiante de una radiobaliza será, como norma general, omnidireccional, es decir, radiará por igual en todas las direcciones del plano horizontal, de modo que cualquier estación pueda oírla sea cual sea su posición. Una antena directiva, como una Yagi, concentra la señal en una dirección y deja sin cobertura las demás, por eso no es lo habitual en una baliza.]])
#pq(13, 2, 19, "c", "R8.1", "Ley 19/1983 («Ley de antenas»): derecho a instalar antenas de aficionado en el exterior de los inmuebles",
  [La Ley 19/1983, conocida como «Ley de Antenas», regula:],
  ([el contenido de las emisiones de aficionado], [las tasas por uso del espectro radioeléctrico], [el derecho a instalar las antenas de aficionado en el exterior de los inmuebles], [la homologación de los transceptores],),
  sol: [La Ley 19/1983 («Ley de Antenas») reconoce el derecho a instalar antenas de aficionado en el exterior de los inmuebles.])
#pq(13, 2, 20, "b", "C-R8.35", "Interconexión con otras redes: permitida con condiciones (fines de radioafición)",
  [¿Está permitido que una estación de aficionado se conecte con otras instalaciones de telecomunicación?],
  ([Sí.], [Sí, cumpliendo ciertas condiciones.], [Sí, limitando la duración del enlace.], [No.],),
  sol: [Sí se puede, pero con condiciones. El art. 23 de la Orden IET/1311/2013 permite interconectar las estaciones a través de otras instalaciones de telecomunicación autorizadas siempre que la interconexión tenga fines relacionados con la radioafición; los dispositivos de conexión a redes públicas no pueden causar daños ni interferencias, y el acceso por red pública a repetidores analógico-digitales exige un código personal y el distintivo del operador. La norma no limita la duración del enlace (c). El banco repite la pregunta con las opciones «No está permitido», «Sí, mediante autorización», «Sí, siempre que se pasen comunicaciones técnicas» y «Sí está permitido»: allí la clave es la última, pues no exige autorización específica ni limita el contenido a comunicaciones técnicas.

    #no-esta[Art. 23 de la Orden IET/1311/2013: las estaciones de radioaficionado pueden interconectarse a través de otras instalaciones de telecomunicación autorizadas si la finalidad está relacionada con la radioafición. Los dispositivos para conectarse a redes públicas deben estar diseñados para no dañar ni interferir esas redes. Si el acceso es por red pública, los repetidores analógico-digitales solo son accesibles con un código personal e intransferible y el distintivo de la estación del operador; el responsable del repetidor debe facilitar el código a todo radioaficionado que lo solicite.]])
#pq(13, 2, 21, "b", "F-R8.100", "Potencia en 137 y 475 kHz: 1 W p.i.r.e. (475 kHz: 5 W a más de 800 km de África)",
  [Con carácter general, la potencia máxima de emisión en las bandas de 137 kHz (2200 m) y 475 kHz (630 m) es, según el anexo I, de:],
  ([1 W p.c.e.], [1 W p.i.r.e.], [1000 W p.c.e.], [10 W p.i.r.e.],),
  sol: [Para las dos bandas más bajas, la tabla del apartado 3.1 del anexo I da solo *1 W p.i.r.e.*, muy por debajo de los 1000 W p.c.e. de HF. En 475 kHz existe una excepción: hasta 5 W p.i.r.e. en zonas distantes más de 800 km de la frontera de países africanos. La opción de 1 W p.c.e. acierta la cifra pero cambia la magnitud: la p.c.e. se mide en la línea de la antena y la p.i.r.e. incluye su ganancia. Los 1000 W p.c.e. son los de HF, y los 10 W p.i.r.e. no figuran en la tabla. #_apc3-ver[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe».)]

#_apc3-net[El anexo I de la Orden IET/1311/2013 (apartado 3.1) autoriza las bandas de 137 kHz (2200 m, LF) y 475 kHz (630 m, MF) con una potencia máxima de 1 W p.i.r.e. En 475 kHz se puede llegar a 5 W p.i.r.e. en las zonas geográficas distantes más de 800 km de la frontera de países africanos. La p.i.r.e. es la potencia suministrada a la antena multiplicada por su ganancia respecto a la isótropa.]])
#pq(13, 2, 22, "d", "R8.60", "La autorización habilita a emitir en las bandas y con las características técnicas del servicio de aficionados",
  [La autorización de radioaficionado habilita a su titular para:],
  ([prestar servicios de comunicación a terceros], [instalar antenas sin condición alguna], [emitir en cualquier banda del espectro radioeléctrico], [efectuar emisiones en las bandas y con las características técnicas establecidas para el servicio de aficionados],),
  sol: [La autorización no es un permiso genérico para radiar: habilita exactamente para lo que el servicio de aficionados tiene atribuido, con sus bandas, potencias y clases de emisión. Fuera de ahí no ampara nada.])
#pq(13, 2, 23, "c", "F-R8.23", "Equipos comerciales: legislación vigente en su comercialización inicial; los ya legalizados, la de su autorización inicial",
  [Los equipos radioeléctricos adquiridos en el mercado que se pretenda utilizar en una estación de radioaficionado deben cumplir la legislación (marcado CE, certificado de aceptación radioeléctrica, etc.) que les fuese de aplicación:],
  ([en el momento de su adquisición por el radioaficionado], [en la fecha en que se presente la solicitud de licencia de estación], [en el momento de su comercialización inicial], [en la fecha de entrada en vigor del Reglamento de radioaficionados],),
  sol: [El art. 5.5 exige a los equipos comprados en el mercado la legislación que les fuese de aplicación «en el momento de su comercialización inicial»: marcado CE, certificado de aceptación radioeléctrica, etc. Cuenta, pues, cuándo salió el equipo al mercado, no cuándo lo compra el aficionado (a), ni la fecha de la solicitud (b), ni la entrada en vigor del Reglamento (d). Los equipos de segunda mano anteriores al RD 1890/2000 y los ya legalizados en una licencia tienen reglas propias, en el mismo artículo. #_apc3-ver[(Véase tema R8, sección «Usos especiales y casos particulares».)]

#_apc3-net[Art. 5.5 de la Orden IET/1311/2013: los equipos radioeléctricos comprados en el mercado y destinados a una estación de radioaficionado deben cumplir la legislación que les fuese de aplicación en el momento de su comercialización inicial (marcado CE, certificado de aceptación radioeléctrica, etc.). Se les exige, por tanto, lo que correspondía cuando el equipo salió al mercado, no lo vigente el día de la compra. Para los equipos de segunda mano anteriores al Real Decreto 1890/2000 y para los ya legalizados en una licencia rigen reglas propias, en el mismo artículo.]])
#pq(13, 2, 24, "c", "C-R8.17", "Montaje por instalador de telecomunicaciones inscrito, salvo instalaciones simples autorizadas por el Jefe Provincial",
  [La instalación, en el exterior de los edificios, del sistema radiante de una estación de radioaficionado, ¿puede ser realizada por el propio radioaficionado?],
  ([Solo puede ser realizada por instalador autorizado.], [Nunca.], [Solo aquellas que por su simplicidad así lo autorice el Jefe Provincial de Inspección de Telecomunicaciones.], [Siempre.],),
  sol: [La regla general es que la instalación la haga un instalador de telecomunicaciones inscrito en el registro de empresas instaladoras. Pero el art. 19.e de la Orden IET/1311/2013 añade una excepción: los Jefes Provinciales de Inspección de Telecomunicaciones pueden autorizar que el radioaficionado la haga por sus propios medios cuando, a la vista de la memoria técnica, la instalación sea tan sencilla que no presente razonablemente riesgos para las personas o los bienes. Por eso «siempre» y «nunca» son absolutas, y «solo instalador» olvida la excepción. #vease[(Véase tema R8, sección «Autorización y licencia de estación».)]

    #no-esta[Art. 19.e de la Orden IET/1311/2013: como norma general, las instalaciones de estaciones fijas las efectúa un instalador de telecomunicaciones inscrito en el registro de empresas instaladoras. Excepción: el Jefe Provincial de Inspección de Telecomunicaciones puede autorizar al radioaficionado a hacerlas por sus propios medios si, vista la memoria técnica, son tan simples que no presentan riesgos razonables para personas o bienes. La resolución que autoriza el montaje fija en cada caso si hace falta instalador o no (art. 19.g).]])
#pq(13, 2, 25, "d", "F-R8.44", "Permisos de servidumbres, medio ambiente, etc.: por cuenta y a cargo del solicitante",
  [Los permisos o autorizaciones en materia de servidumbres aeronáuticas, medio ambiente u ordenación del territorio que exija la instalación de una estación fija de radioaficionado deben ser obtenidos, según el artículo 18.3 de la Orden IET/1311/2013, por:],
  ([la SETSI, de oficio, al tramitar la licencia], [la Jefatura Provincial de Inspección de Telecomunicaciones, al verificar la instalación], [la empresa instaladora, a su cargo, como parte del montaje], [los solicitantes de la licencia, por su cuenta y a su cargo],),
  sol: [El último inciso del art. 18.3 es claro: la obtención de los permisos o autorizaciones en materia de seguridad nacional, servidumbres, medio ambiente u ordenación del territorio es por cuenta y a cargo de los solicitantes de la licencia de la estación. No corresponde a la SETSI (a) ni a la Jefatura Provincial (b), y la empresa instaladora monta la estación, pero el coste no recae en ella (c). La razón es que la licencia depende de que se cumplan esas normas, y de ello responde quien la pide. #_apc3-ver[(Véase tema R8, sección «Autorización y licencia de estación».)]

#_apc3-net[La licencia de una estación fija depende de que se respeten las normas sobre seguridad nacional, servidumbres radioeléctricas o aeronáuticas, medio ambiente y ordenación del territorio (art. 18.3 de la Orden IET/1311/2013). La obtención de los permisos o autorizaciones que esas materias exijan es por cuenta y a cargo de quien solicita la licencia de la estación: no los asume la Administración de telecomunicaciones.]])
#pq(13, 2, 26, "a", "R8.27", "Autorización especial experimental: nominativa, plazo máximo inicial de 18 meses, ampliable",
  [Las autorizaciones especiales para usos experimentales (art. 17 de la Orden):],
  ([son nominativas y se otorgan con un plazo máximo inicial de dieciocho meses, ampliable], [se conceden automáticamente con la autorización ordinaria], [son transferibles a terceros], [tienen validez indefinida],),
  sol: [Las autorizaciones especiales para usos experimentales son nominativas, solo habilitan a su titular y se otorgan por el tiempo necesario para las pruebas, con un plazo máximo inicial de dieciocho meses, ampliable, quedando su validez condicionada a la de la autorización de radioaficionado (art. 17.3.2.º). Ojo: no las confundas con las del art. 16 (bandas con limitaciones, disposición adicional 2.ª), para las que la Orden no fija plazo; un enunciado que hable de «bandas de uso restringido» mezcla ambas, y los dieciocho meses son los de las experimentales.])
#pq(13, 2, 27, "d", "R8.33", "Repetidor: su objetivo es ampliar el alcance de las comunicaciones",
  [El objetivo que se pretende al instalar un repetidor de radioaficionado es:],
  ([evitar el uso del código Q], [aumentar la potencia de las estaciones móviles], [sustituir a las estaciones fijas], [ampliar el alcance de las comunicaciones],),
  sol: [El repetidor amplía el alcance: recibe en una frecuencia y retransmite en otra desde un emplazamiento elevado.])
#pq(13, 2, 28, "b", "R9.22", "Muy grave: no atender el requerimiento de cese de emisiones",
  [No atender el requerimiento de la autoridad competente para el cese de las emisiones constituye una infracción:],
  ([grave], [muy grave], [leve], [exenta de sanción si se subsana después],),
  sol: [Muy grave: así la tipifica el art. 106.8 de la Ley 11/2022. Desatender un requerimiento formal de cese agrava mucho el asunto: ya no se trata solo de la interferencia, sino de desobedecer a la autoridad que vela por el dominio público radioeléctrico. En bancos antiguos (con la ley de 2003) la respuesta era «grave» (art. 54.f de la Ley 32/2003); ya era muy grave en la Ley 9/2014 (art. 76.7) y la Ley 11/2022 lo mantiene.])
#pq(13, 2, 29, "d", "R9.27", "Emitir fuera de las bandas autorizadas es infracción",
  [Emplear bandas de frecuencia distintas de las autorizadas al servicio de aficionados constituye:],
  ([una falta solo si se causa interferencia], [una conducta permitida con baja potencia], [una práctica admitida si la banda está libre], [una infracción],),
  sol: [Las bandas atribuidas al servicio son el límite de la autorización: fuera de ellas hay otros servicios, muchos de seguridad, y emitir ahí es infracción con independencia de la potencia o de que la banda «parezca» libre.])
#pq(13, 2, 30, "a", "R9.5", "Multas máximas: 20 M€ muy graves y 2 M€ graves",
  [Las multas previstas por la Ley General de Telecomunicaciones pueden llegar, para las infracciones muy graves y graves respectivamente, hasta:],
  ([20 millones y 2 millones de euros], [100 millones y 10 millones de euros], [500 000 y 50 000 euros], [1 millón y 100 000 euros],),
  sol: [Topes de multa: hasta 20 millones de euros las muy graves y hasta 2 millones las graves.])
#fin-prueba()
#soluciones-simulacro(13)

#repaso-inicio()
#repaso-tema("T1", "Teoría de la electricidad, el electromagnetismo y la radio")
#rq(1, "C-T1.22", [Al flujo de electrones que circula por un conductor se le llama:], [Corriente eléctrica])
#rq(2, "C-T1.30", [En electricidad, la letra $Z$ corresponde a:], [Impedancia.])
#rq(3, "C-T1.12", [Entre los siguientes materiales, es buen conductor:], [mercurio])
#rq(4, "", [La conductividad de un material es:], [la inversa de su resistividad])
#rq(5, "C-T1.18", [La diferencia entre un acumulador y una pila es:], [Que el acumulador se carga])
#rq(6, "", [Una batería de 12 V y 7 Ah almacena una energía aproximada de:], [84 Wh])
#rq(7, "C-T1.19", [Cuando se habla del colector nos referimos a:], [Una dinamo])
#rq(8, "C-T1.20", [Para que un electroimán almacene energía:], [Basta con pasar una corriente continua])
#rq(9, "C-T1.27", [Cuando dos bobinados tienen sus espiras en la misma dirección:], [Sus inducciones se suman.])
#rq(10, "C-T1.10", [Las reactancias inductiva y capacitiva tienen propiedades:], [opuestas])
#rq(11, "", [Entre dos placas paralelas separadas 2 cm hay una diferencia de potencial de 100 V. El campo eléctrico entre ellas vale:], [5000 V/m])
#rq(12, "F-T1.1", [El campo magnético creado por un conductor rectilíneo largo recorrido por corriente es más intenso cuanto:], [mayor es la corriente y menor es la distancia al conductor])
#rq(13, "F-T1.3", [Para apantallar un campo magnético de baja frecuencia (por ejemplo, el de 50 Hz de un transformador de red) conviene emplear:], [una envolvente de material ferromagnético de alta permeabilidad, como el mu-metal o el hierro dulce])
#rq(14, "T1.21", [Se entiende por «amplitud» de una señal sinusoidal:], [la diferencia entre el valor máximo y el valor medio de la señal])
#rq(15, "F-T1.6", [Una señal sinusoidal de 1 kHz y otra idéntica retrasada 250 μs respecto a ella tienen entre sí un desfase de:], [90°])
#rq(16, "T1.24", [En los sistemas de transmisión analógicos, las señales:], [pueden tomar infinitos valores])
#rq(17, "F-T1.19", [Una emisión de telegrafía manual A1A, vista en un osciloscopio, consiste en:], [trenes de portadora de amplitud constante que aparecen y desaparecen al ritmo de la manipulación])
#rq(18, "F-T1.13", [La envolvente de una emisión de AM oscila entre un máximo de 15 V y un mínimo de 5 V. El índice de modulación es de:], [50 %])
#rq(19, "F-T1.41", [Un transmisor de AM con 25 W de potencia de portadora se modula al 100 %. Su potencia en la cresta de la envolvente (p.c.e.) es de:], [100 W])
#rq(20, "F-T1.23", [El espectro de una emisión de FM con un índice de modulación elevado presenta:], [numerosas bandas laterales separadas entre sí una distancia igual a la frecuencia moduladora])
#rq(21, "", [Dos emisoras de FM transmiten en la misma frecuencia y llegan al receptor con intensidades muy distintas. Lo normal es que:], [el receptor se quede con la más fuerte y suprima casi por completo la más débil])
#rq(22, "C-T1.25", [Di cuál es la sentencia correcta:], [Una modulación digital se obtiene al aplicar una señal digital sobre un modulador digital.])
#rq(23, "F-T1.29", [Al pasar de 2PSK a 4PSK manteniendo la misma velocidad de símbolo:], [se duplica la velocidad binaria sin aumentar la anchura de banda])
#rq(24, "C-T1.28", [Si un usuario tiene contratado un acceso a Internet «ADSL de 2 megas», esto significa que:], [Dispone de un ancho de banda de 2 millones de bits por segundo.])
#rq(25, "T1.33", [Se entiende por «procesador digital de señal» (DSP):], [un sistema con hardware y software optimizados para procesar digitalmente la señal a muy alta velocidad])
#rq(26, "F-T1.44", [Un conversor analógico-digital de 10 bits cuantifica cada muestra en uno de:], [1024 niveles])
#repaso-tema("T2", "Componentes")
#rq(27, "F-T2.2", [Las resistencias de hilo bobinado se emplean, frente a las de carbón, cuando se necesita:], [disipar potencias elevadas con buena estabilidad])
#rq(28, "F-T2.1", [Una resistencia variable de tres terminales, con un cursor móvil entre dos extremos y empleada, por ejemplo, como control de volumen, se denomina:], [potenciómetro])
#rq(29, "F-T2.3", [Una resistencia cuyo valor óhmico depende de la luz que recibe se denomina:], [fotorresistencia (LDR)])
#rq(30, "F-T2.25", [Un componente cuya característica corriente-tensión no es una recta, como el diodo, se dice que es:], [no lineal])
#rq(31, "T2.9", [Un dieléctrico es:], [un aislante])
#rq(32, "F-T2.29", [Los condensadores de mica se caracterizan por:], [su gran estabilidad y sus bajas pérdidas])
#rq(33, "F-T2.30", [Para el desacoplo de radiofrecuencia, es decir, para llevar a masa la RF no deseada en un punto del circuito, se emplean habitualmente condensadores:], [cerámicos])
#rq(34, "F-T2.31", [La corriente de fuga de un condensador es:], [la pequeña corriente continua que atraviesa su dieléctrico por no ser un aislante perfecto])
#rq(35, "F-T2.32", [El coeficiente de temperatura de un condensador indica:], [cómo varía su capacidad cuando cambia la temperatura])
#rq(36, "T2.12", [Las bandas de colores de un condensador indican:], [su capacidad, su tolerancia y su tensión máxima de trabajo])
#rq(37, "", [Un condensador cerámico lleva impreso el código «104». Su capacidad es:], [100 nF])
#rq(38, "", [Si se duplica el número de espiras de una bobina sin cambiar su diámetro ni su longitud, su autoinducción:], [se cuadruplica])
#rq(39, "", [En la alimentación del transistor final de un transmisor se coloca en serie con el colector un choque de RF (una bobina). Su función es:], [dejar pasar la continua de la fuente y frenar la RF para que no se escape hacia la fuente])
#rq(40, "T2.52", [Un electroimán atrae a los objetos de hierro:], [solo mientras circula corriente por su bobina])
#rq(41, "C-T2.4", [Un relevador o relé es un electroimán que se emplea para:], [Abrir y cerrar un circuito eléctrico])
#rq(42, "T2.39", [Un autotransformador es un transformador en el que:], [los devanados primario y secundario tienen una parte común])
#rq(43, "T2.55", [Un transformador con núcleo de aire, comparado con uno de núcleo ferromagnético, presenta:], [un factor de calidad más bajo a baja frecuencia])
#rq(44, "", [El núcleo de hierro de un transformador de red de 50 Hz se construye con chapas delgadas aisladas entre sí para:], [reducir las pérdidas por corrientes de Foucault])
#rq(45, "T2.37", [De los siguientes materiales, es un semiconductor:], [el germanio])
#rq(46, "C-T2.8", [El transistor es:], [Un semiconductor])
#rq(47, "T2.35", [Un semiconductor de tipo P es aquel en el que:], [la cantidad de huecos es mayor que la de electrones libres])
#rq(48, "F-T2.17", [La corriente de fuga de un diodo polarizado en inversa, por debajo de su tensión inversa máxima, es:], [muy pequeña y aumenta con la temperatura])
#rq(49, "F-T2.18", [Si se aplica a un diodo rectificador ordinario una tensión inversa superior a su tensión inversa máxima:], [entra en ruptura, conduce en sentido inverso y puede destruirse])
#rq(50, "F-T2.16", [Un LED cae 2 V cuando por él circulan 20 mA. Para alimentarlo con esa corriente desde una fuente de 9 V, la resistencia en serie debe ser de:], [350 Ω])
#rq(51, "", [En un transistor bipolar, la corriente de emisor es:], [la suma de las corrientes de base y de colector])
#rq(52, "F-T2.20", [La base de un transistor se polariza con un divisor formado por $R_1 = 33$ kΩ (a +12 V) y $R_2 = 12$ kΩ (a masa). Si la base casi no toma corriente, su tensión respecto a masa es de:], [3,2 V])
#rq(53, "T2.42", [Un inconveniente característico de los transistores frente a las válvulas es:], [su sensibilidad al calor])
#rq(54, "T2.51", [Un amplificador puede llegar a oscilar de forma indeseada si:], [existe un acoplamiento excesivo entre su salida y su entrada])
#rq(55, "T2.31", [En una válvula, la rejilla de pantalla se añade principalmente para:], [reducir la capacidad entre la rejilla de control y la placa])
#rq(56, "", [En una válvula pentodo, la rejilla supresora tiene la función de:], [devolver a la placa los electrones secundarios que esta emite])
#rq(57, "T2.44", [Cuando la etapa final de un emisor es de válvulas, antes de poder transmitir es necesario:], [esperar un tiempo de caldeo del filamento])
#rq(58, "T2.58", [De las siguientes siglas referidas a la escala de integración de los circuitos integrados, _no_ corresponde a ninguna escala normalizada:], [CSI])
#rq(59, "", [Una ventaja característica de los circuitos digitales frente a los analógicos es:], [su gran inmunidad al ruido, porque solo tienen que distinguir dos niveles lógicos])
#rq(60, "F-T2.21", [En una puerta lógica AND (Y) de dos entradas, la salida vale 1 solo cuando:], [las dos entradas valen 1])
#rq(61, "F-T2.22", [Una puerta inversora (NOT) se caracteriza porque:], [entrega en su salida el nivel lógico contrario al de su entrada])
#rq(62, "F-T2.23", [El número binario 1010 equivale, en el sistema decimal, a:], [10])
#repaso-tema("T3", "Circuitos")
#rq(63, "F-T3.31", [Un sintetizador digital directo (DDS) tiene un reloj de 50 MHz y un acumulador de fase de 32 bits. El paso mínimo con que puede variar su frecuencia de salida es, aproximadamente, de:], [0,012 Hz])
#rq(64, "", [En los circuitos de VHF se prefieren resistencias de película, cortas y sin bobinar, porque:], [las resistencias bobinadas y de patas largas tienen inductancia y capacidad parásitas que, a esas frecuencias, alteran su comportamiento])
#rq(65, "", [Un circuito resonante serie con un factor de calidad $Q = 50$ se excita, a su frecuencia de resonancia, con un generador de 2 V. La tensión sobre el condensador es aproximadamente de:], [100 V])
#rq(66, "", [Muy por encima de su frecuencia de corte, un filtro paso bajo formado por tres células RC atenúa aproximadamente:], [18 dB por octava])
#rq(67, "T3.53", [Efectuar la sintonización de la etapa final de un emisor a plena potencia puede producir:], [daños en los dispositivos del paso final])
#rq(68, "T3.54", [Al actuar sobre el conmutador de bandas de un transceptor se consigue:], [situar el equipo en el margen de frecuencias deseado])
#rq(69, "", [Comparados con los filtros de cristal de cuarzo, los filtros cerámicos que se usan en las FI de 455 kHz o 10,7 MHz:], [son más baratos y tienen un factor de calidad menor])
#rq(70, "F-T3.5", [Una ventaja de un filtro digital frente a uno analógico de bobinas y condensadores es que:], [su respuesta no deriva con la temperatura ni con el envejecimiento de componentes y puede modificarse cambiando el programa])
#rq(71, "C-T3.4", [Los filtros de las fuentes de alimentación tienen generalmente:], [Condensadores y bobinas])
#rq(72, "", [Una fuente con rectificador de onda completa, conectada a la red de 50 Hz, entrega 2 A a la carga con un condensador de filtro de 10 000 μF. El rizado pico a pico es aproximadamente de:], [2 V])
#rq(73, "C-T3.15", [En un amplificador lineal con triodo en reja común:], [La señal radio entra por cátodo y sale por ánodo.])
#rq(74, "C-T3.13", [Debido a la distorsión:], [La señal de salida no es igual a la de entrada])
#rq(75, "", [El rendimiento máximo teórico de un amplificador en clase B es aproximadamente del:], [78,5 %])
#rq(76, "", [En un amplificador en contrafase de clase B, la distorsión de cruce se corrige:], [dando a los dos transistores una pequeña corriente de reposo, con lo que pasa a trabajar en clase AB])
#rq(77, "", [En un amplificador de clase C, el circuito tanque LC sintonizado del colector:], [reconstruye una sinusoide completa a partir de los pulsos de corriente del transistor (efecto volante)])
#rq(78, "T3.48", [En la etapa final de un transmisor se conectan a veces dos válvulas en paralelo con objeto de:], [obtener mayor potencia de salida])
#rq(79, "T3.19", [Las dos entradas de un amplificador operacional se denominan:], [inversora y no inversora])
#rq(80, "T3.15", [El circuito de la figura podrá emplearse como:
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
    ] <t3-fig-q15>], [receptor de AM a la frecuencia de resonancia del circuito LC])
#rq(81, "F-T3.16", [El detector de pendiente para FM se basa en:], [situar la portadora en el flanco de la curva de un circuito sintonizado, donde la amplitud de salida varía con la frecuencia])
#rq(82, "F-T3.37", [En un receptor definido por software (SDR), tras digitalizar la señal con un conversor A/D, el filtrado y la demodulación se realizan mediante:], [un programa que procesa numéricamente las muestras])
#rq(83, "F-T3.38", [La función de reducción de ruido («NR») de un transceptor con DSP:], [analiza numéricamente la señal y atenúa el ruido de fondo continuo])
#rq(84, "", [En un oscilador Colpitts, la fracción de señal que se devuelve a la entrada se toma de:], [un divisor formado por dos condensadores])
#rq(85, "", [Para obtener con un oscilador a cristal frecuencias por encima de unos 20–30 MHz, lo habitual es:], [hacer vibrar el cristal en un sobretono (tercer o quinto armónico mecánico)])
#rq(86, "F-T3.23", [El ruido de fase del oscilador local de un receptor provoca que:], [una señal intensa cercana aporte ruido al canal deseado y empeore así la selectividad efectiva])
#rq(87, "F-T3.25", [Cuando un PLL está enganchado, las dos señales que llegan al comparador de fase tienen:], [la misma frecuencia y una diferencia de fase constante])
#rq(88, "F-T3.33", [Un sintetizador digital directo (DDS) genera la señal con los siguientes bloques:], [acumulador de fase, tabla de seno, conversor D/A y filtro de paso bajo])
#repaso-tema("T4", "Receptores")
#rq(89, "C-T4.13", [La técnica de superheterodinación se emplea:], [Porque permite poner el CAG])
#rq(90, "C-T4.6", [Si en un transceptor colocamos el mando «MODE» en posición SSB (BLU), ¿podremos recibir una señal
modulada en amplitud (AM)?], [Se recibirá mezclada con un ruido de batido continuo])
#rq(91, "T4.13", [La relación señal/ruido de un receptor:], [es una característica indicativa de su calidad y se expresa en decibelios])
#rq(92, "F-T4.3", [Un receptor de SSB tiene un ancho de banda de 2,7 kHz y una figura de ruido de 10 dB. Sabiendo que el ruido térmico es de −174 dBm en 1 Hz de ancho de banda, su señal mínima discernible (MDS, la que iguala el ruido del propio receptor) es de unos:], [−130 dBm])
#rq(93, "C-T4.2", [Un atenuador para proteger contra sobrecargas la entrada de un receptor estará formado por:], [Resistencias (R).])
#rq(94, "F-T4.9", [Si se sube 3 dB el nivel de las dos señales que producen intermodulación, los productos de tercer orden aumentan:], [9 dB])
#rq(95, "C-T4.8", [El circuito de control automático de ganancia tiene un mando de gobierno que afecta a:], [Su tiempo de respuesta])
#rq(96, "C-T4.14", [¿A cuál de estos circuitos de la parte receptora de un repetidor debe estar conectado el relé que
conecta la parte emisora?], [Al silenciador])
#rq(97, "C-T4.4", [Cuando en un receptor actuamos el conmutador de canales estamos:], [Variando la sintonía])
#rq(98, "C-T4.11", [El dial de presentación digital («#emph[digital display]») nos indica:], [La frecuencia de trabajo])
#rq(99, "T4.24", [Para poder recibir señales de la banda de 2 metros con un receptor de decamétricas es necesario intercalar:], [un conversor])
#rq(100, "T4.27", [El empleo de procesadores digitales de señal (DSP) en un transceptor moderno permite, entre otras cosas:], [optimizar los filtros del equipo por medios digitales])
#repaso-tema("T5", "Transmisores")
#rq(101, "C-T5.23", [Un transmisor:], [Convierte una señal de frecuencia intermedia en otra de radiofrecuencia.])
#rq(102, "", [En un transmisor sin conversión de frecuencia, como los de CW o FM más sencillos, la frecuencia de salida es:], [la del propio oscilador, o un múltiplo suyo obtenido con multiplicadores])
#rq(103, "C-T5.26", [Llamamos unidad transceptora al conjunto formado por:], [Transmisor y receptor.])
#rq(104, "", [En la generación de banda lateral única por el método de fase, la banda lateral no deseada se elimina:], [por cancelación, al sumar las salidas de dos moduladores balanceados que reciben la voz y la portadora desfasadas 90°])
#rq(105, "C-T5.8", [La modulación de banda lateral única:], [Es una variante de la modulación de amplitud])
#rq(106, "C-T5.13", [En un emisor de radio, los amplificadores se emplean para:], [Aumentar la potencia del emisor])
#rq(107, "C-T5.21", [El índice de modulación de amplitud es:], [El porcentaje de la variación de amplitud que experimenta la portadora])
#rq(108, "T5.16", [El preamplificador de micrófono de un transmisor tiene por objeto:], [elevar el bajo nivel de la señal que entrega el micrófono])
#rq(109, "C-T5.14", [La estabilidad de la frecuencia de un emisor de radio proporciona la siguiente ventaja:], [Menor interferencia a otras emisiones de frecuencia próxima])
#rq(110, "C-T5.25", [Son características relevantes en un transmisor:], [Frecuencia de emisión y su estabilidad en frecuencia.])
#rq(111, "T5.23", [Las siglas CAF corresponden a:], [control automático de frecuencia])
#rq(112, "C-T5.24", [Un transmisor suele tener entre sus subsistemas auxiliares:], [Un sistema de refrigeración.])
#rq(113, "", [En un transmisor con conversión de frecuencia, a la salida del mezclador aparecen, además de la señal deseada:], [el otro producto de la mezcla (suma o diferencia) y restos de las dos entradas, que se eliminan con un filtro paso banda tras el mezclador])
#rq(114, "", [Las oscilaciones parásitas de un amplificador de potencia:], [son oscilaciones a frecuencias sin relación con la de trabajo, a menudo en VHF, que se combaten con supresores y ferritas])
#rq(115, "T5.34", [En un transmisor valvular, el mando de control de carga (_load_) sirve para:], [ajustar el acoplo de la etapa final a la antena])
#rq(116, "C-T5.7", [Si se dispone de un amperímetro a la salida del emisor, hacia la antena, en el ajuste óptimo de
emisión (máxima emisión) la lectura será:], [Máxima])
#rq(117, "C-T5.16", [En un emisor de potencia media, la alta tensión de placa del paso final se aplica:], [En dos etapas; en la primera se aplica una tensión media; y después del primer ajuste, se aplica
toda la tensión])
#rq(118, "C-T5.20", [En un transceptor a válvulas, la alta frecuencia del paso final se aplica:], [Al actuar sobre el conmutador emisión/recepción])
#rq(119, "C-T5.15", [Antes del encendido de un emisor hay que prepararlo, pero de los siguientes controles y elementos,
el que no es necesario actuar para dicha preparación previa es:], [El medidor de sensibilidad de la señal])
#rq(120, "C-T5.22", [Los amplificadores a cavidades resonantes se emplean en los transceptores que trabajan en las
bandas de:], [144 MHz y superiores])
#rq(121, "C-T5.28", [¿Válvulas o transistores? Seleccionar la sentencia correcta.], [Los amplificadores a válvulas son los preferidos por los radioaficionados amantes de lo retro en
radio.])
#rq(122, "C-T5.27", [Un modulador digital:], [Convierte niveles discretos de tensión en estados discretos, bien sean de amplitud, fase,
amplitud y fase, frecuencia instantánea, etc., de una señal portadora de radiofrecuencia.])
#rq(123, "C-T5.5", [La misión del conmutador «POWER ON/OFF» en un transceptor es:], [Encender y apagar el equipo])
#rq(124, "", [Muchos repetidores de VHF/UHF solo se activan si la señal que reciben lleva:], [un subtono de baja frecuencia (CTCSS) que actúa de llave de acceso])
#rq(125, "F-T5.8", [Para recibir y transmitir a la vez con una sola antena, un repetidor utiliza:], [un duplexor, conjunto de filtros que separa la frecuencia de entrada de la de salida])
#repaso-tema("T6", "Antenas y líneas de transmisión")
#rq(126, "C-T6.6", [Los elementos variables de que, generalmente, se dispone en serie en la base de una antena para
ajustar a la resonancia son:], [Una bobina y un condensador])
#rq(127, "F-T6.3", [Una antena tiene una resistencia de radiación de 36 Ω y una resistencia de pérdidas de 4 Ω. Su eficiencia (rendimiento) es del:], [90 %])
#rq(128, "F-T6.24", [Respecto del dipolo simple de media onda, el dipolo plegado presenta:], [una impedancia unas cuatro veces mayor y mayor ancho de banda])
#rq(129, "T6.41", [En una antena helicoidal, la ganancia depende fundamentalmente de:], [el número de espiras])
#rq(130, "F-T6.25", [La ganancia de una antena parabólica es tanto mayor cuanto:], [mayor es su diámetro en comparación con la longitud de onda])
#rq(131, "F-T6.27", [En una antena parabólica de foco primario, el elemento alimentador (bocina o dipolo) se sitúa:], [en el foco del reflector, frente al plato])
#rq(132, "", [En un enlace de VHF con visión directa, una estación emite con una antena vertical y la otra recibe con un dipolo horizontal. Lo más probable es que:], [la señal llegue muy atenuada, porque las polarizaciones están cruzadas])
#rq(133, "F-T6.4", [A igual ganancia, el área de captura de una antena receptora es mayor cuanto:], [mayor es la longitud de onda (menor la frecuencia)])
#rq(134, "T6.30", [Se dice que una antena es pasiva cuando:], [no incorpora ningún elemento amplificador])
#rq(135, "C-T6.12", [El cable que une la antena al emisor debe:], [Estar apantallado])
#rq(136, "", [Comparada con el cable coaxial, la línea paralela (bifilar o de escalerilla):], [es simétrica, tiene una impedancia de unos 300 a 600 Ω y pierde menos, pero hay que alejarla de los objetos metálicos])
#rq(137, "C-T6.16", [¿Qué respuesta es cierta para una antena que radie en condiciones ideales de espacio libre?], [La potencia aplicada y la ROE medida no tendrán nada que ver.])
#rq(138, "F-T6.14", [En un cable coaxial real, al aumentar la ROE, las pérdidas totales de la línea:], [aumentan, porque la onda reflejada recorre la línea otra vez y se disipa más potencia])
#rq(139, "F-T6.23", [Un dipolo plegado de unos 300 Ω se alimenta con cable coaxial de 75 Ω. Para adaptar las impedancias y, a la vez, pasar de línea asimétrica a antena simétrica se emplea:], [un balun de relación de impedancias 4:1])
#rq(140, "F-T6.22", [Un tramo de línea cortocircuitada de longitud menor que un cuarto de onda se comporta en su entrada como:], [una bobina (reactancia inductiva)])
#rq(141, "T6.23", [El circuito de la figura, conectado entre el transmisor y la antena, se utiliza como:
    #align(center, esquema({
      import zap: *
      import cetz.draw: content
      node("a", (0, 2), fill: false)
      wire((0, 2), (5.2, 2))
      node("n1", (1.4, 2))
      node("n2", (3.8, 2))
      inductor("l", (2, 2), (3.2, 2))
      capacitor("c1", (1.4, 2), (1.4, 0.4), variable: true)
      capacitor("c2", (3.8, 2), (3.8, 0.4), variable: true)
      earth("g1", (1.4, 0.4))
      earth("g2", (3.8, 0.4))
      node("b", (5.2, 2), fill: false)
      content((-0.15, 2), anchor: "east", text(size: 8pt, fill: col.gris)[del transmisor])
      content((5.35, 2), anchor: "west", text(size: 8pt, fill: col.gris)[a la antena])
    }))
  ], [acoplador de antena (red en pi)])
#rq(142, "T6.24", [El conmutador de antena de una estación permite:], [conectar la antena alternativamente al transmisor o al receptor])
#rq(143, "T6.26", [Un conmutador de antenas de varias posiciones se emplea para:], [elegir, desde un mismo equipo, cuál de las antenas de la estación se usa])
#repaso-tema("T7", "Propagación")
#rq(144, "T7.13", [De los siguientes factores, influyen en una comunicación radioeléctrica:], [todos los anteriores])
#rq(145, "", [Una fulguración solar intensa provoca, en el hemisferio iluminado:], [un aumento brusco de la ionización de la capa D, que absorbe la HF y la deja muda durante minutos u horas])
#rq(146, "C-T7.12", [¿Qué ha pasado probablemente si en la frecuencia en la que llevabas media hora haciendo un QSO
aparecen hablando otras estaciones de otro QSO?], [Ha variado la propagación y la distancia de salto.])
#rq(147, "F-T7.19", [La propagación por conducto troposférico es más probable con:], [tiempo anticiclónico estable, con altas presiones y poco viento])
#rq(148, "T7.11", [Con la dispersión troposférica (troposcatter) en la propagación de ondas se consigue:], [un alcance mayor que el meramente visual entre las antenas])
#rq(149, "F-T7.3", [En un contacto por esporádica-E con un solo salto, las señales de VHF llegan a distancias típicas de:], [1000 a 2000 km])
#rq(150, "F-T7.6", [Las señales que llegan por reflexión auroral se caracterizan por:], [sonar ásperas y distorsionadas, con desvanecimientos rápidos; la telegrafía resulta la más eficaz])
#rq(151, "F-T7.8", [Los contactos por meteor-scatter se caracterizan porque las señales llegan:], [en ráfagas breves, de fracciones de segundo a pocos segundos])
#rq(152, "F-T7.9", [El flujo solar medido a 10,7 cm es:], [un índice de la actividad solar que sirve para estimar la ionización y la MUF])
#rq(153, "F-T7.11", [Un programa de predicción de propagación, como VOACAP, calcula a partir de los índices solares, la fecha y la hora:], [la MUF de cada trayecto y qué bandas tienen probabilidad de estar abiertas])
#rq(154, "T7.27", [En el espectro de la figura, correspondiente a tres emisiones simultáneas, la señal de menor frecuencia es:
    #align(center, cetz.canvas({
      import cetz.draw: *
      ejes(0, 7.2, 0, 2.3, etq-x: $f$)
      content((0, 2.4), anchor: "south", text(size: 7.5pt, fill: col.gris)[amplitud])
      for (x, h, n) in ((1.4, 1.75, "1"), (3.6, 1.1, "2"), (5.6, 1.5, "3")) {
        line((x, 0), (x, h), stroke: 1.3pt + col.acento)
        content((x, h + 0.1), anchor: "south", text(size: 7.5pt, weight: "bold", fill: col.naranja, n))
      }
    }))
  ], [la señal 1])
#repaso-tema("T8", "Medidas")
#rq(155, "F-T8.11", [Un polímetro analógico tiene una sensibilidad de 20 kΩ/V. En la escala de 10 V, su resistencia de entrada es de:], [200 kΩ])
#rq(156, "", [Para que un galvanómetro sirva como voltímetro de mayor alcance se le conecta:], [una resistencia multiplicadora en serie])
#rq(157, "", [Un voltímetro analógico de clase 1,5 se usa en la escala de 100 V. El error máximo que cabe esperar del propio instrumento es de:], [1,5 V en cualquier punto de la escala])
#rq(158, "F-T8.8", [Un polímetro convencional, calibrado para sinusoides y que no es de «verdadero valor eficaz» (_true RMS_), mide una tensión alterna de forma cuadrada. Su lectura:], [puede ser errónea: rectifica, promedia y multiplica por el factor de forma de la sinusoide (1,11), que solo vale para esa forma de onda])
#rq(159, "C-T8.12", [Para medir la potencia disipada en la resistencia del circuito de la figura, se deben seleccionar:
    #circuito(caption: none)[
      #_apb1-pot
    ]], [Los conmutadores en la posición 1.])
#rq(160, "C-T8.7", [El amperímetro de antena es del tipo:], [de radiofrecuencia])
#rq(161, "F-T8.1", [Un frecuencímetro digital cuenta los ciclos de la señal durante un tiempo de puerta de 0,1 s. Su resolución es de:], [10 Hz])
#rq(162, "", [Un frecuencímetro cuya base de tiempos de cristal se desvía 10 partes por millón mide una señal de 145 MHz. El error de la lectura puede llegar a:], [1450 Hz, por muchos dígitos que muestre la pantalla])
#rq(163, "T8.15", [Un generador de señal de radiofrecuencia se utiliza para:], [caracterizar etapas de radiofrecuencia])
#repaso-tema("T9", "Interferencia e inmunidad")
#rq(164, "T9.8", [Si un equipo declara su conformidad con la directiva «EMC», significa que:], [cumple las directivas de la Unión Europea sobre compatibilidad electromagnética])
#rq(165, "F-T9.4", [En espacio libre y lejos de una antena transmisora, al duplicar la distancia a ella la intensidad de campo eléctrico (V/m):], [se reduce a la mitad])
#rq(166, "T9.2", [Las interferencias son más frecuentes si en la estación se emplean:], [amplificadores lineales de potencia])
#rq(167, "T9.9", [El medio de transmisión más inmune a las interferencias radiadas es:], [la fibra óptica])
#rq(168, "", [Ante una queja de interferencias, conectas tu transmisor a una carga artificial y transmites. La interferencia continúa. Lo más probable es que la perturbación llegue al equipo afectado:], [por conducción a través de la red eléctrica o de los cables])
#repaso-tema("T10", "Seguridad")
#rq(169, "T10.35", [De los siguientes efectos, el que _no_ produce una descarga eléctrica sobre el cuerpo humano es:], [la somnolencia])
#rq(170, "C-T10.7", [En relación con las medidas a adoptar en trabajos de instalaciones de equipos y antenas, una de
las siguientes medidas NO es correcta. Señálela:], [El cruzamiento de los conductores de línea de la red eléctrica no debe preocuparnos en absoluto.])
#rq(171, "", [Según la Recomendación 1999/519/CE, recogida en España por el Real Decreto 1066/2001, el nivel de referencia de campo eléctrico para el público entre 10 y 400 MHz es de:], [28 V/m])
#rq(172, "", [En una fuente de alta tensión, la resistencia de descarga (bleeder) conectada en paralelo con el condensador de filtro sirve para:], [descargar el condensador cuando se desconecta el equipo])
#rq(173, "T10.33", [En la atención a una persona accidentada por electricidad, no se le debe:], [dar de beber])
#rq(174, "T10.34", [Si tras liberar de la corriente a un accidentado se comprueba que no respira, procede:], [practicarle la respiración artificial, boca a boca si es posible])
#rq(175, "T10.32", [Ante una quemadura producida por un accidente eléctrico se debe:], [lavar la zona con agua abundante y avisar al servicio médico])
#rq(176, "T10.38", [En relación con la seguridad de la estación, es recomendable que:], [tanto el operador como sus familiares conozcan las prácticas básicas de primeros auxilios])
#rq(177, "T10.40", [A efectos de evitar accidentes derivados del uso de su estación, el titular de una autorización de radioaficionado:], [está obligado a cumplir la normativa vigente en materia de seguridad])
#rq(178, "", [En el cable de alimentación de 13,8 V de un transceptor conectado a una batería, el fusible debe colocarse:], [en el positivo, lo más cerca posible de la batería])
#rq(179, "", [Una fuente de alimentación sin avería funde en cada encendido el fusible rápido (F) que le han puesto. Lo correcto es sustituirlo por:], [un fusible temporizado (T) del mismo calibre])
#rq(180, "C-T10.2", [De los siguientes elementos, indicar cuáles de ellos se consideran como de protección personal:], [Guantes de goma.])
#rq(181, "T10.29", [En los vientos metálicos que sujetan un mástil de antena conviene:], [intercalar aisladores a tramos, para que no resuenen en las bandas de trabajo])
#rq(182, "C-T10.4", [En cuanto a los rotores de las antenas directivas:], [Por su tamaño y esfuerzo, se montan preferentemente en torretas.])
#rq(183, "T10.23", [En los trabajos de instalación de antenas en altura, es incorrecto:], [trabajar en solitario y sin avisar a nadie])
#repaso-tema("R8", "Reglamentación nacional e internacional")
#rq(184, "F-R8.104", [Una estación emite en 144 MHz para un enlace por rebote lunar (EME), en una subbanda recomendada por la IARU y fuera de un casco urbano. La potencia de cresta de la envolvente máxima que le permite el anexo I es de:], [1000 W])
#rq(185, "F-R8.106", [Las estaciones de radioaficionado que funcionan en las bandas destinadas a aplicaciones industriales, científicas y médicas (ICM), según el anexo I:], [deben aceptar la interferencia perjudicial resultante de esas aplicaciones])
#rq(186, "F-R8.108", [¿Cuál de las siguientes bandas es una de las destinadas a aplicaciones ICM en el anexo I?], [2400–2450 MHz])
#rq(187, "F-R8.109", [Las potencias máximas del anexo I no eximen al radioaficionado de adoptar las medidas técnicas necesarias, incluida la reducción de la potencia, para que la energía de radiofrecuencia emitida sea inferior a:], [3,5 mW/cm#super[2]])
#rq(188, "F-R8.111", [Un transmisor de 100 W de potencia media trabaja en la banda de 144 MHz. Según el Anexo I de la Orden IET/1311/2013, la potencia media de cada componente de emisión no esencial que suministra a la línea de la antena no debe rebasar:], [60 dB por debajo de la potencia media, sin exceder de 1 mW])
#rq(189, "F-R8.36", [Según el artículo 11 de la Orden IET/1311/2013, se entiende por licencia de radioaficionado CEPT la expedida por un país:], [perteneciente o no a la CEPT, que haya adoptado la Recomendación T/R 61-01])
#rq(190, "F-R8.34", [La SETSI puede autorizar a un extranjero, titular de una licencia en vigor de un país que no ha adoptado la Recomendación T/R 61-01, a operar temporalmente en España (art. 15 de la Orden IET/1311/2013). En su solicitud se hace constar su nombre y apellidos, su nacionalidad, su dirección y:], [el original o una fotocopia fehaciente de la licencia de su país de origen])
#rq(191, "F-R8.35", [Los equipos que utilice un extranjero con la autorización temporal del artículo 15 de la Orden IET/1311/2013 deben:], [cumplir la normativa española en materia de equipos y aparatos])
#rq(192, "C-R8.45", [¿Puedo realizar transmisiones desde Andorra si tengo la licencia de radioaficionado?], [Sí, según el artículo 6, radioaficionados titulares de una licencia extranjera en vigor en el país en el que residen habitualmente, pueden obtener una licencia temporal para usar su estación en territorio andorrano.])
#rq(193, "R8.83", [En el procedimiento previsto en la Recomendación T/R 61-02 de la CEPT sobre el certificado HAREC pueden participar:], [países pertenezcan o no a la CEPT])
#rq(194, "F-R8.37", [Según el artículo 10.2 de la Orden IET/1311/2013, el programa de la prueba de capacitación para operar estaciones de radioaficionado (anexo II) es acorde con:], [el anexo 6 de la Recomendación T/R 61-02 de la CEPT])
#rq(195, "R8.58", [En relación con los exámenes para obtener el certificado HAREC, señale la opción _incorrecta_:], [es necesario estar en posesión de un certificado HAREC para poder presentarse])
#rq(196, "F-R8.7", [En los diplomas y concursos de radioaficionados se usan zonas numeradas. La España peninsular está en la zona ITU número:], [37])
#rq(197, "R8.6", [Se denomina «radiocomunicación» a:], [toda telecomunicación transmitida por medio de ondas radioeléctricas])
#rq(198, "C-R8.16", [Según el Reglamento de Radiocomunicaciones de la UIT:], [Una estación de aficionado es una estación del Servicio de Aficionados.])
#rq(199, "R8.56", [Conforme al Reglamento de Radiocomunicaciones de la UIT, el servicio de aficionados por satélite utiliza:], [estaciones espaciales situadas en satélites])
#rq(200, "F-R8.5", [Según el artículo 25 del Reglamento de Radiocomunicaciones, las administraciones deben verificar, de toda persona que desee utilizar una estación de aficionado:], [sus cualificaciones operativas y técnicas])
#rq(201, "F-R8.6", [Según el artículo 25 del Reglamento de Radiocomunicaciones, la potencia máxima de las estaciones de aficionado:], [la fijan las administraciones interesadas])

#mapa-inicio()
#mapa-cuerpo[
#mapa-tema("T1", "Teoría de la electricidad, el electromagnetismo y la radio")
#mapa-item("Unidades de intensidad, tensión, resistencia y potencia (A, V, Ω, W)", "9·1·1")
#mapa-item("Equivalencias de la ley de Ohm: 1 Ω = 1 V/1 A y 1 V = 1 Ω · 1 A", "5·1·1")
#mapa-item("Carga y corriente: 1 C = 1 A · 1 s y 1 A = 1 C/s", "1·1·1")
#mapa-item("Definición de corriente eléctrica (movimiento de cargas) y de resistencia (oposición a su paso)", "R1")
#mapa-item("Símbolo de la impedancia: Z", "R2")
#mapa-item("Prefijos del SI y conversión entre múltiplos y submúltiplos", "5·1·2")
#mapa-item("Materiales conductores y aislantes", "R3")
#mapa-item("Conductividad como inversa de la resistividad", "R4")
#mapa-item("Ley de Ohm: hallar V, I o R", "6·1·1, 10·1·1")
#mapa-item("Resistencia de un conductor: R = ρ l / S", "13·1·1")
#mapa-item("Potencia eléctrica: P = V I = I² R = V² / R", "1·1·2, 8·1·1")
#mapa-item("Ley de Kirchhoff de las corrientes (nudos)", "6·1·2")
#mapa-item("Ley de Kirchhoff de las tensiones (mallas)", "12·1·1")
#mapa-item("Ley de Coulomb: proporcional al producto de las cargas e inversa al cuadrado de la distancia", "13·1·2")
#mapa-item("La batería convierte energía química en eléctrica", "4·1·1")
#mapa-item("Diferencia entre pila (no recargable) y acumulador (recargable)", "R5")
#mapa-item("Fuerza electromotriz: caracteriza al generador y se mide en voltios", "12·1·2")
#mapa-item("Fuente real: V = ε − I r y corriente de cortocircuito ε / r", "9·1·2")
#mapa-item("Asociación de pilas: en serie se suman las tensiones; en paralelo, las corrientes (y baja la resistencia interna)", "3·1·1, 8·1·2")
#mapa-item("Capacidad de una batería en amperios-hora: t = C / I", "3·1·2")
#mapa-item("Energía almacenada en una batería: tensión × amperios-hora (Wh)", "R6")
#mapa-item("Dinamo: el colector y las escobillas", "R7")
#mapa-item("Un electroimán almacena energía en su campo magnético con corriente continua", "R8")
#mapa-item("Bobinados acoplados en el mismo sentido: las inducciones se suman", "R9")
#mapa-item("Reactancias inductiva y capacitiva: propiedades opuestas", "R10")
#mapa-item("Campo eléctrico entre placas: E = V / d", "R11")
#mapa-item("Campo magnético de un conductor rectilíneo: circunferencias concéntricas, más intenso con más corriente y menos distancia", "R12")
#mapa-item("Apantallamiento: el campo magnético de baja frecuencia exige material ferromagnético", "R13")
#mapa-item("Las ondas de radio son electromagnéticas", "13·1·3")
#mapa-item("Onda electromagnética: campos E y B perpendiculares entre sí y a la propagación", "9·1·3")
#mapa-item("Velocidad de propagación: c = 300.000 km/s, constante y sin depender de la frecuencia", "7·1·1, 12·1·3")
#mapa-item("Longitud de onda: λ = c / f, λ (m) ≈ 300 / f (MHz)", "11·1·1")
#mapa-item("Frecuencia: ciclos por segundo (Hz), la característica de la corriente alterna", "6·1·3")
#mapa-item("Período: T = 1 / f, tiempo entre dos máximos consecutivos", "10·1·2")
#mapa-item("Amplitud (máximo menos valor medio) y parámetros que caracterizan una señal", "R14")
#mapa-item("Valor eficaz: definición por el efecto calorífico; la tensión de red se da en eficaz", "4·1·2, 11·1·2")
#mapa-item("Conversión entre valores de pico, pico a pico y eficaz de una sinusoide (V_ef = V_p / √2)", "2·1·1, 13·1·4")
#mapa-item("Diferencia de fase expresada como retardo: Δφ = 360° · Δt / T", "R15")
#mapa-item("En un circuito resistivo, tensión e intensidad están en fase", "4·1·3")
#mapa-item("Factor de potencia: coseno del desfase entre tensión y corriente", "11·1·3")
#mapa-item("Señales no sinusoidales: fundamental y armónicos (onda cuadrada: solo impares)", "1·1·3")
#mapa-item("Ruido térmico y ruido blanco: P = k T B, independiente de la frecuencia", "12·1·4")
#mapa-item("Señal analógica: infinitos valores; digital: valores discretos", "R16")
#mapa-item("Objeto de la modulación: que la portadora transporte la información", "6·1·4")
#mapa-item("Parámetro que varía en cada modulación analógica (AM amplitud, FM frecuencia, PM fase)", "3·1·3")
#mapa-item("Telegrafía A1A: trenes de portadora de amplitud constante (todo o nada)", "R17")
#mapa-item("Espectro de AM: portadora y dos bandas laterales en f_c ± f_m", "11·1·4")
#mapa-item("Anchuras de banda típicas: CW < SSB (2,7 kHz) < AM (6 kHz) < FM", "5·1·3, 12·1·5")
#mapa-item("Índice de modulación de AM a partir de la envolvente: m = (A_máx − A_mín) / (A_máx + A_mín)", "R18")
#mapa-item("Potencia de AM: P_t = P_c (1 + m²/2), reparto entre portadora y bandas", "4·1·4")
#mapa-item("Potencia en la cresta de la envolvente en AM al 100 %: cuatro veces la de portadora", "R19")
#mapa-item("SSB (J3E): una sola banda lateral, sin portadora", "7·1·2")
#mapa-item("FM: amplitud constante; varía la frecuencia instantánea", "7·1·3")
#mapa-item("Regla de Carson: B ≈ 2 (Δf + f_m)", "2·1·2")
#mapa-item("Espectro de FM: muchas bandas laterales separadas f_m", "R20")
#mapa-item("Efecto captura en FM", "R21")
#mapa-item("Modulación digital: moduladora digital aplicada a un modulador digital", "R22")
#mapa-item("FSK, PSK y QAM: qué parámetro de la portadora varía cada una", "3·1·4")
#mapa-item("Bits por símbolo (log₂ M) y velocidad binaria = baudios × bits por símbolo", "7·1·4")
#mapa-item("La anchura de banda digital la fija la velocidad de símbolo, no la de bit", "R23")
#mapa-item("CRC detecta errores; FEC los corrige sin retransmisión a costa de velocidad útil", "8·1·3")
#mapa-item("Velocidad binaria comercial: «megas» son Mbit/s (bits, no bytes)", "R24")
#mapa-item("El decibelio compara niveles de potencia (escala logarítmica)", "5·1·4")
#mapa-item("Referencias de decibelios: ×2 = +3 dB, ×4 = +6 dB, ×10 = +10 dB, ÷2 = −3 dB", "1·1·4, 6·1·5")
#mapa-item("En una cadena, las ganancias y pérdidas en dB se suman y restan", "2·1·3")
#mapa-item("Energía = potencia × tiempo (julio = W·s, kWh)", "10·1·3")
#mapa-item("Procesador digital de señal (DSP): hardware y software para procesar señales digitalizadas", "R25")
#mapa-item("Conversores A/D y D/A: qué convierte cada uno", "8·1·4")
#mapa-item("Teorema de Nyquist: f_s ≥ 2 f_máx", "4·1·5, 10·1·4")
#mapa-item("Aliasing: las frecuencias por encima de f_s/2 se confunden con otras más bajas", "2·1·4")
#mapa-item("Filtros antisolapamiento (paso bajo antes del A/D) y de reconstrucción (paso bajo tras el D/A)", "9·1·4")
#mapa-item("Cuantificación: 2^n niveles; cada bit añade unos 6 dB de relación señal/ruido", "R26")
#mapa-tema("T2", "Componentes")
#mapa-item("Código de colores: cifra que representa cada color (negro 0 … blanco 9)", "10·1·5")
#mapa-item("Código de colores: leer el valor de una resistencia de cuatro bandas (cifras + multiplicador)", "5·1·5")
#mapa-item("Código de colores: la cuarta banda es la tolerancia (oro ±5 %, plata ±10 %, marrón ±1 %)", "1·1·5")
#mapa-item("Una resistencia fija se especifica por valor, potencia de disipación y tolerancia", "5·1·6")
#mapa-item("Disipación máxima de una resistencia: tensión o corriente máximas a partir de P y R", "13·1·5")
#mapa-item("Resistencias de hilo bobinado: mucha potencia y estabilidad, pero inductivas (no valen en RF)", "R27")
#mapa-item("Potenciómetro: resistencia variable de tres terminales con cursor", "R28")
#mapa-item("En un conductor metálico la resistencia aumenta con la temperatura", "3·1·5")
#mapa-item("Termistores: PTC sube y NTC baja su resistencia al aumentar la temperatura", "2·1·5")
#mapa-item("Varistor (VDR): su resistencia depende de la tensión aplicada; protege contra sobretensiones", "11·1·5")
#mapa-item("Fotorresistencia (LDR): su resistencia depende de la luz", "R29")
#mapa-item("Componentes lineales (óhmicos, recta I-V por el origen) y no lineales (diodo)", "R30")
#mapa-item("Unidad de capacidad: el faradio (no mide la carga)", "8·1·5")
#mapa-item("Capacidad: C = Q/V; el condensador almacena carga eléctrica", "3·1·6")
#mapa-item("El dieléctrico es un aislante", "R31")
#mapa-item("C = εS/d: la capacidad depende de la superficie, la separación y el dieléctrico", "6·1·6")
#mapa-item("La reactancia capacitiva disminuye al aumentar la frecuencia", "13·1·6")
#mapa-item("Cálculo de la reactancia capacitiva X_C = 1/(2πfC)", "1·1·6")
#mapa-item("Energía almacenada en un condensador: ½CV² (no confundir con ½LI²)", "6·1·7")
#mapa-item("El condensador se opone a las variaciones de tensión; la bobina, a las de corriente", "10·1·6")
#mapa-item("En continua los condensadores se cargan al principio y luego bloquean la corriente", "12·1·6")
#mapa-item("Constante de tiempo τ = RC: 63 % de la carga en un τ, carga completa en unos 5τ", "2·1·6")
#mapa-item("Electrolítico: el dieléctrico es una capa de óxido (con el electrolito como pasta)", "12·1·7")
#mapa-item("Electrolítico: polarizado, hay que respetar la polaridad", "12·1·8")
#mapa-item("Electrolítico: uso principal en el filtrado de fuentes de alimentación (no en RF)", "11·1·6")
#mapa-item("Condensadores de mica: muy estables y de bajas pérdidas", "R32")
#mapa-item("Desacoplo de RF con condensadores cerámicos (poca inductancia propia)", "R33")
#mapa-item("Corriente de fuga de un condensador", "R34")
#mapa-item("Coeficiente de temperatura de un condensador", "R35")
#mapa-item("Marcado de condensadores con bandas de color (capacidad, tolerancia, tensión)", "R36")
#mapa-item("Marcado de condensadores con código de tres cifras en pF (104 = 100 nF)", "R37")
#mapa-item("Descarga segura de un condensador a través de un elemento exterior", "4·1·6")
#mapa-item("Unidad de autoinducción: el henrio", "7·1·5")
#mapa-item("La bobina almacena energía en el campo magnético (½LI²)", "6·1·8")
#mapa-item("La autoinducción depende de la construcción de la bobina (núcleo, dimensiones, temperatura), no de la señal", "11·1·7")
#mapa-item("La autoinducción crece con el cuadrado del número de espiras", "R38")
#mapa-item("La reactancia inductiva X_L = 2πfL crece con la frecuencia y es nula en continua", "1·1·7, 8·1·6")
#mapa-item("Cálculo de la reactancia inductiva X_L = 2πfL", "10·1·7")
#mapa-item("Desfase en reactancias puras: en la bobina la tensión adelanta 90° (en el condensador, la corriente)", "7·1·6")
#mapa-item("Efecto pelicular: en RF la corriente va por la superficie y la resistencia efectiva aumenta", "9·1·5")
#mapa-item("Choque de RF: deja pasar la continua y frena la RF", "R39")
#mapa-item("Electroimán: atrae solo mientras circula corriente", "R40")
#mapa-item("Relé: electroimán que abre y cierra un circuito", "R41")
#mapa-item("El transformador son dos bobinas acopladas que transforman una alterna en otra alterna", "8·1·7")
#mapa-item("Con continua en el primario no hay corriente en el secundario", "10·1·8")
#mapa-item("Relación de transformación: cociente de tensiones o de espiras", "9·1·6")
#mapa-item("Elevador o reductor según el número de espiras de primario y secundario", "1·1·8")
#mapa-item("Cálculo de la tensión del secundario: V_s = V_p · N_s/N_p", "11·1·8")
#mapa-item("Corrientes en el transformador ideal: van en proporción inversa a las tensiones (potencia constante)", "3·1·7")
#mapa-item("El transformador también sirve para adaptar impedancias", "4·1·7")
#mapa-item("Cálculo de la adaptación de impedancias: Z_p = (N_p/N_s)² Z_s (balun 4:1 = espiras 2:1)", "8·1·8")
#mapa-item("Autotransformador: primario y secundario comparten parte del devanado", "R42")
#mapa-item("Núcleo de aire frente a núcleo ferromagnético", "R43")
#mapa-item("Núcleo de chapas aisladas para reducir las corrientes de Foucault", "R44")
#mapa-item("Materiales semiconductores: silicio y germanio", "R45")
#mapa-item("El transistor es un dispositivo semiconductor (de tres terminales)", "R46")
#mapa-item("Semiconductor tipo P (mayoría de huecos) y el hueco como portador de carga positiva", "R47")
#mapa-item("El diodo deja pasar la corriente en un solo sentido", "12·1·9")
#mapa-item("Aplicación del diodo: detección (y rectificación)", "13·1·7")
#mapa-item("Tensión de conducción en directa de un diodo de silicio: 0,6–0,7 V", "7·1·7")
#mapa-item("Corriente de fuga inversa del diodo: muy pequeña y crece con la temperatura", "R48")
#mapa-item("Superar la tensión inversa máxima lleva a la ruptura y puede destruir el diodo", "R49")
#mapa-item("Diodo zéner: estabiliza tensión trabajando en inversa, en la zona de ruptura", "7·1·8, 13·1·8")
#mapa-item("LED: emite luz polarizado en directa", "2·1·7")
#mapa-item("Cálculo de la resistencia limitadora de un LED", "R50")
#mapa-item("Varicap: capacidad controlada por la tensión inversa (más tensión, menos capacidad)", "5·1·7")
#mapa-item("Transistor bipolar: terminales emisor, base y colector; tipos NPN y PNP", "4·1·8, 10·1·9")
#mapa-item("Ganancia de corriente β = I_C/I_B", "3·1·8")
#mapa-item("Corriente de emisor: I_E = I_B + I_C", "R51")
#mapa-item("Polarización: en el NPN el colector es positivo; en el PNP, negativo", "13·1·9")
#mapa-item("Polarización de la base con un divisor de tensión", "R52")
#mapa-item("Usos del transistor: amplificar, oscilar, mezclar (no rectificar ni hacer de balun)", "6·1·9")
#mapa-item("FET y MOSFET: terminales puerta, drenador y surtidor; control por tensión de puerta", "5·1·8")
#mapa-item("Ventaja del FET: impedancia de entrada muy alta", "9·1·7")
#mapa-item("Inconveniente del transistor frente a la válvula: sensibilidad al calor", "R53")
#mapa-item("Oscilación indeseada de un amplificador por acoplamiento entre salida y entrada", "R54")
#mapa-item("Electrodos de la válvula diodo (cátodo y placa) y del tríodo (+ rejilla)", "2·1·8")
#mapa-item("Emisión termoiónica: el cátodo caliente emite y la válvula conduce solo con la placa positiva", "9·1·8")
#mapa-item("El nombre de la válvula cuenta electrodos: pentodo = cátodo, tres rejillas y placa", "1·1·9")
#mapa-item("Rejilla de pantalla: reduce la capacidad rejilla-placa", "R55")
#mapa-item("Rejilla supresora: devuelve a la placa los electrones secundarios", "R56")
#mapa-item("Equipos de válvulas: esperar el caldeo antes de transmitir", "R57")
#mapa-item("Escalas de integración: SSI, MSI, LSI, VLSI («CSI» no existe)", "R58")
#mapa-item("Ventaja de los circuitos digitales: inmunidad al ruido (dos niveles lógicos)", "R59")
#mapa-item("Puertas lógicas Y (AND) y O (OR)", "R60")
#mapa-item("Puerta inversora (NOT)", "R61")
#mapa-item("Sistema binario: conversión a decimal", "R62")
#mapa-item("Símbolos de resistencia, condensador, bobina y diodo", "4·1·9")
#mapa-item("Símbolos de transistores: bipolar frente a FET", "3·1·9")
#mapa-tema("T3", "Circuitos")
#mapa-item("Resistencias en serie: la corriente es la misma en todas y la caída de tensión es proporcional a cada R", "7·1·9")
#mapa-item("Resistencias en paralelo: tensión común; la corriente de cada rama es inversamente proporcional a R y la total es la suma (Kirchhoff)", "10·1·10")
#mapa-item("Resistencia equivalente: serie suma, paralelo menor que la menor (producto/suma; n iguales, R/n); circuitos mixtos", "6·1·10")
#mapa-item("Asociación de condensadores: en paralelo se suman; en serie, por inversas (al revés que las resistencias)", "2·1·9")
#mapa-item("Asociación de bobinas sin acoplo: como las resistencias (serie suman; paralelo producto/suma)", "5·1·9")
#mapa-item("Impedancia de un circuito RLC serie: X = XL − XC, Z = √(R² + X²) e I = V/Z", "12·1·10")
#mapa-item("Condensador en continua, en régimen permanente: circuito abierto (queda el divisor resistivo)", "1·1·10")
#mapa-item("Acoplo entre circuitos y etapas: las oscilaciones de uno pasan al otro; el acoplamiento deja pasar la señal y separa las polarizaciones", "11·1·9")
#mapa-item("Condensador real: por encima de su autorresonancia se comporta como una bobina", "4·1·10")
#mapa-item("Bobina real: la capacidad entre espiras la hace autorresonar; por encima se comporta como un condensador", "6·1·11")
#mapa-item("En VHF/UHF, terminales cortos (o SMD): la inductancia de las patas presenta reactancia apreciable", "10·1·11")
#mapa-item("Resistencia real en AF: inductancia y capacidad parásitas; en RF, resistencias de película sin bobinar", "R64")
#mapa-item("Condición de resonancia: XL = XC, las reactancias se cancelan y el circuito es puramente resistivo", "7·1·10")
#mapa-item("Frecuencia de resonancia f0 = 1/(2π√(LC)): cálculo y dependencia con L y C", "12·1·11")
#mapa-item("Factor de calidad Q: mide la selectividad; Q = f0/B", "1·1·11")
#mapa-item("Q = X/R en resonancia y ancho de banda B = f0/Q", "13·1·10")
#mapa-item("Resonancia serie (Z mínima) frente a paralelo o tanque (Z máxima); LC serie en derivación = trampa", "9·1·9")
#mapa-item("Magnificación por Q en resonancia: en el serie, la tensión sobre L o C es Q veces la aplicada", "R65")
#mapa-item("Filtro paso banda: deja pasar su banda y atenúa por encima y por debajo; es el de la FI", "3·1·10")
#mapa-item("Filtro paso bajo: deja pasar las frecuencias inferiores a la de corte (a la salida del TX, contra armónicos)", "8·1·9")
#mapa-item("Frecuencia de corte: separa banda de paso y de atenuación; se toma a −3 dB", "11·1·10")
#mapa-item("Filtro RC: fc = 1/(2πRC)", "4·1·11")
#mapa-item("Pendiente de un filtro: 6 dB por octava por cada célula (polo)", "R66")
#mapa-item("Filtros en pi y en T: pi paso bajo = C–L–C; T paso bajo = L–C–L (en paso alto se intercambian)", "8·1·10")
#mapa-item("Sintonizar la etapa final a plena potencia puede dañar los dispositivos: se sintoniza a potencia reducida", "R67")
#mapa-item("Conmutador de bandas: sitúa el equipo en el margen de frecuencias deseado", "R68")
#mapa-item("Cristal de cuarzo: resonador piezoeléctrico de Q altísimo", "5·1·10")
#mapa-item("Filtro de cuarzo en la FI: su Q altísimo da selectividad elevada con banda estrecha y estable", "12·1·12")
#mapa-item("Filtros cerámicos: mismo efecto piezoeléctrico, más baratos y con menos Q que los de cuarzo (455 kHz, 10,7 MHz)", "R69")
#mapa-item("Filtro digital (DSP): opera con muestras numéricas; cadena A/D → cálculo en el DSP → D/A", "9·1·10")
#mapa-item("Ventajas e inconvenientes del filtro digital: no deriva y se cambia por programa; añade retardo, limita Nyquist, exige conversores", "R70")
#mapa-item("Filtros FIR (sin realimentación, respuesta finita) e IIR (realimentan la salida, respuesta infinita)", "13·1·11")
#mapa-item("Función del rectificador: convertir la alterna en continua (pulsante)", "1·1·12")
#mapa-item("Media onda frente a onda completa: la completa aprovecha los dos semiciclos, dobla el valor medio y da menos rizado", "2·1·10")
#mapa-item("Número de diodos: media onda 1; onda completa con toma media 2; puente 4", "4·1·12")
#mapa-item("Frecuencia del rizado: 100 Hz en onda completa y 50 Hz en media onda (red de 50 Hz)", "9·1·11")
#mapa-item("Función del filtro de la fuente: eliminar la componente alterna (rizado) que queda tras rectificar, no la continua", "11·1·11")
#mapa-item("Composición del filtro de la fuente: condensadores y bobinas (en L, en pi)", "R71")
#mapa-item("Rizado del condensador de filtro: ΔV ≈ I/(f_r·C); crece con la corriente y baja con f_r y C", "R72")
#mapa-item("Bloques de una fuente lineal y su orden: transformador → rectificador → filtro → regulador (reconocer el esquema)", "11·1·12")
#mapa-item("Regulador: mantiene constante la tensión de salida aunque varíen la carga y la red", "2·1·11")
#mapa-item("Regulador con zéner y resistencia en serie: reparto de corrientes entre zéner y carga", "13·1·12")
#mapa-item("Fuente lineal frente a conmutada: la lineal pesa (transformador de 50 Hz) y rinde poco; la conmutada trabaja a decenas–cientos de kHz, ligera y eficiente", "3·1·11")
#mapa-item("Fuente conmutada: genera ruido de RF (QRM en HF); exige filtrado y apantallado", "4·1·13")
#mapa-item("Condensadores de desacoplo: absorben los transitorios de la alimentación", "10·1·12")
#mapa-item("Emisor común: ganancia de tensión y de corriente, luego de potencia", "8·1·11")
#mapa-item("Emisor común: único montaje que invierte la fase 180°", "10·1·13")
#mapa-item("Base común: amplifica tensión, pero no corriente", "6·1·12")
#mapa-item("Colector común = seguidor de emisor (ganancia de tensión ≈ 1; adaptador de impedancias)", "4·1·14")
#mapa-item("Tríodo en rejilla común: la señal entra por el cátodo y sale por el ánodo", "R73")
#mapa-item("Amplificar sin distorsión: trabajar en la parte lineal de la característica", "2·1·12")
#mapa-item("Distorsión: la señal de salida no es réplica de la de entrada", "R74")
#mapa-item("Ángulo de conducción: A 360°, AB entre 180° y 360°, B 180°, C menos de 180°", "13·1·13")
#mapa-item("Linealidad frente a rendimiento: clase A mínima distorsión; clase C mayor rendimiento", "8·1·12")
#mapa-item("Clase AB: combinación de A y B; la de los amplificadores lineales de SSB", "6·1·13")
#mapa-item("Clase C: solo para emisiones de amplitud constante (CW, FM), nunca SSB ni AM", "5·1·11")
#mapa-item("Rendimientos máximos: clase A 25–50 %; clase B π/4 ≈ 78,5 %", "R75")
#mapa-item("Contrafase en clase B y distorsión de cruce (se corrige con corriente de reposo: clase AB)", "R76")
#mapa-item("Clase C: el tanque LC reconstruye la sinusoide a partir de los pulsos (efecto volante); sintonizado a 2f o 3f, multiplicador", "R77")
#mapa-item("Dispositivos en paralelo en la etapa final: más potencia de salida", "R78")
#mapa-item("Neutralización: anula la realimentación parásita para que el amplificador no oscile", "7·1·11")
#mapa-item("Realimentación: devolver parte de la salida a la entrada; la negativa reduce la ganancia y mejora estabilidad y linealidad, la positiva hace oscilar", "1·1·13")
#mapa-item("Amplificador operacional: ganancia muy alta, impedancia de entrada alta y de salida baja", "5·1·12")
#mapa-item("Entradas del operacional: inversora (−) y no inversora (+)", "R79")
#mapa-item("Operacional inversor: G = −R2/R1 (no inversor: 1 + R2/R1)", "12·1·13")
#mapa-item("Ganancia de tensión en decibelios: 20·log(V2/V1)", "3·1·12")
#mapa-item("Detector de envolvente (diodo + RC): detector de AM; reconocer su esquema", "13·1·14")
#mapa-item("El detector de envolvente es asíncrono: no necesita sincronización con el transmisor", "9·1·12")
#mapa-item("Receptor de galena: LC sintonizado + diodo detector + auricular = receptor de AM", "R80")
#mapa-item("Discriminador de FM: convierte variaciones de frecuencia en variaciones de tensión (audio)", "8·1·13")
#mapa-item("Detector de pendiente: la portadora en el flanco de un circuito sintonizado", "R81")
#mapa-item("Limitador delante del discriminador: recorta las variaciones de amplitud (ruido)", "7·1·12")
#mapa-item("SDR y demodulación por DSP: tras el A/D, filtrado y demodulación son programas; el mismo hardware sirve para todos los modos", "R82")
#mapa-item("Reducción de ruido (NR) por DSP: atenúa el ruido de fondo continuo (no es el NB ni el silenciador)", "R83")
#mapa-item("Oscilador: convierte la corriente continua en alterna", "3·1·13")
#mapa-item("Condición de oscilación (Barkhausen): realimentación positiva, ganancia de lazo que compensa pérdidas y fase de 360°", "9·1·13")
#mapa-item("Osciladores LC clásicos: Colpitts (divisor capacitivo), Hartley (bobina con toma), Pierce (cristal)", "R84")
#mapa-item("Estabilidad del oscilador: la temperatura hace derivar su frecuencia", "5·1·13")
#mapa-item("Oscilador a cristal: frecuencia muy estable (y apenas ajustable)", "10·1·14")
#mapa-item("Cristal en sobretono por encima de unos 20–30 MHz", "R85")
#mapa-item("VFO: oscilador de frecuencia variable para moverse por la banda", "6·1·14")
#mapa-item("VCO: su frecuencia varía con una tensión de control, normalmente mediante un varicap", "7·1·13")
#mapa-item("Ruido de fase: fluctuaciones aleatorias de fase que crean faldones de ruido a ambos lados de la portadora (en TX, molestan a canales vecinos)", "1·1·14")
#mapa-item("Ruido de fase del oscilador local: mezcla recíproca, empeora la selectividad efectiva", "R86")
#mapa-item("Mezclador (heterodinación): a la salida aparecen la suma y la diferencia f1 ± f2", "5·1·14")
#mapa-item("PLL: estabiliza un VCO enganchándolo a una referencia; la tensión de error corrige el VCO", "2·1·13")
#mapa-item("Bloques del PLL: comparador de fase, filtro de paso bajo (de lazo), VCO y divisor programable", "11·1·13")
#mapa-item("PLL enganchado: misma frecuencia en el comparador y diferencia de fase constante", "R87")
#mapa-item("Sintetizador PLL: f_out = N·f_ref; el paso de canal es f_ref", "3·1·14")
#mapa-item("DDS: se emplea como oscilador variable de gran precisión", "12·1·14")
#mapa-item("Funcionamiento del DDS: acumulador de fase, tabla de seno, D/A y paso bajo; la frecuencia se cambia con el incremento de fase", "R88")
#mapa-item("Resolución del DDS: Δf = f_clk/2^n", "R63")
#mapa-tema("T4", "Receptores")
#mapa-item("Superheterodino: la FI es una frecuencia fija, presente a la salida del mezclador (de ahí el nombre)", "10·1·15")
#mapa-item("Ventaja de la superheterodinación según el banco: ganancia y selectividad en FI fija, que permite aplicar el CAG", "R89")
#mapa-item("Orden de etapas del superheterodino: RF → mezclador → FI → detector → BF", "3·1·15")
#mapa-item("El mezclador necesita el oscilador local: bloque que falta en un diagrama", "13·1·15")
#mapa-item("Relación entre señal, oscilador local y FI: OL por encima f_s = f_OL − f_FI; OL por debajo f_s = f_OL + f_FI", "13·1·16")
#mapa-item("Frecuencia imagen: defecto del receptor superheterodino, situada a 2·FI de la sintonizada", "1·1·15")
#mapa-item("La imagen se rechaza antes del mezclador, con un filtro (preselector)", "12·1·15")
#mapa-item("Doble conversión: dos FI; la 1.ª alta (aleja la imagen) y la 2.ª baja (selectividad)", "9·1·14")
#mapa-item("Conversión directa: el OL a la frecuencia de la señal y el mezclador da directamente audio, sin FI", "1·1·16")
#mapa-item("Diagrama de bloques del receptor de BLU (RF, mezclador con OL variable, FI, detector de producto con BFO)", "3·1·16")
#mapa-item("Receptor de FM: tras la FI, limitador y después discriminador (en AM, detector de envolvente)", "5·1·15")
#mapa-item("La etapa detectora demodula (extrae la información)", "10·1·16")
#mapa-item("Detector de producto con BFO: imprescindible en SSB y CW (no en AM ni FM)", "7·1·14")
#mapa-item("Pasar de USB a LSB cambia la frecuencia del BFO (batido), no el ancho de banda ni la clase de emisión", "8·1·14")
#mapa-item("Señal de AM recibida en modo SSB: el BFO bate con la portadora y se oye un pitido", "R90")
#mapa-item("La selectividad la fijan las etapas (filtros) de FI; la FI son amplificadores y filtros", "11·1·14")
#mapa-item("Selectividad: separar señales próximas en frecuencia (curva más estrecha = más selectivo)", "2·1·14")
#mapa-item("Selectividad de canal adyacente: la fijan los faldones del filtro de FI (problema lineal)", "7·1·15")
#mapa-item("Anchura de banda de la NBFM: unos 12 kHz (FM de difusión 200 kHz, SSB 2,4 kHz)", "2·1·15")
#mapa-item("Sensibilidad: captar y amplificar señales débiles", "6·1·15")
#mapa-item("La sensibilidad (figura de ruido) la determina la primera etapa de RF (Friis)", "4·1·15")
#mapa-item("Relación señal/ruido: índice de calidad del receptor, en dB", "R91")
#mapa-item("Señal mínima discernible: MDS = −174 + 10 log B + F (dBm)", "R92")
#mapa-item("Estabilidad: mantener la frecuencia sintonizada sin derivar", "8·1·15")
#mapa-item("La estabilidad del receptor depende del oscilador local", "12·1·16")
#mapa-item("El margen dinámico lo determina el primer mezclador", "2·1·16")
#mapa-item("El atenuador de entrada está formado por resistencias", "R93")
#mapa-item("Intermodulación de tercer orden: productos en 2f1 − f2 y 2f2 − f1, dentro de banda", "9·1·15")
#mapa-item("Los productos de tercer orden suben 3 dB por cada dB que suben las señales", "R94")
#mapa-item("Modulación cruzada: la modulación de una señal fuerte se traslada a la sintonizada (no linealidad)", "6·1·16")
#mapa-item("CAG: mantiene constante la salida; lazo desde el detector hacia RF y FI", "9·1·16")
#mapa-item("El mando del CAG fija su tiempo de respuesta (FAST/SLOW)", "R95")
#mapa-item("Silenciador (squelch): corta el audio cuando la señal no supera un umbral", "5·1·16")
#mapa-item("En un repetidor, el relé que activa el transmisor lo gobierna el silenciador del receptor", "R96")
#mapa-item("Mando RF GAIN: ganancia de las etapas de RF del receptor (no la potencia del emisor)", "11·1·15")
#mapa-item("Noise blanker (NB): suprime el ruido impulsivo", "7·1·16")
#mapa-item("RIT: varía la frecuencia de recepción sin tocar la de transmisión", "4·1·16")
#mapa-item("El conmutador de canales varía la sintonía", "R97")
#mapa-item("El dial digital indica la frecuencia de trabajo", "R98")
#mapa-item("Para oír 2 m con un receptor de HF se intercala un conversor", "R99")
#mapa-item("El DSP permite filtros digitales optimizables", "R100")
#mapa-tema("T5", "Transmisores")
#mapa-item("Funciones mínimas de un transmisor: generar, modular y amplificar", "11·1·16")
#mapa-item("Orden de bloques del emisor: modulador → amplificación y traslación → final → red de acoplo", "7·1·17")
#mapa-item("Transmisor con conversión: la señal se genera en una FI fija y un mezclador con el VFO la lleva a RF", "R101")
#mapa-item("Transmisor sin conversión: la salida es el oscilador o un múltiplo suyo (CW, FM)", "R102")
#mapa-item("Unidad transceptora = transmisor + receptor", "R103")
#mapa-item("Diagrama de bloques del transmisor de BLU (BF, modulador balanceado, filtro, RF)", "11·1·17")
#mapa-item("SSB por filtro: el modulador equilibrado suprime la portadora; el filtro elimina una banda lateral", "3·1·17")
#mapa-item("SSB por el método de fase: la banda indeseada se cancela (dos moduladores con desfase de 90°)", "R104")
#mapa-item("La SSB es una variante de la modulación de amplitud", "R105")
#mapa-item("En un emisor, los amplificadores aumentan la potencia", "R106")
#mapa-item("Excitador: lleva la señal al nivel que necesita el amplificador final", "10·1·17")
#mapa-item("Etapa separadora: aísla el oscilador de las variaciones de carga", "7·1·18")
#mapa-item("Multiplicador de frecuencia: eleva la frecuencia del oscilador; en cascada, los factores se multiplican", "8·1·16")
#mapa-item("Los multiplicadores multiplican también la desviación de FM", "12·1·17")
#mapa-item("FM directa: el audio actúa sobre el oscilador (varicap)", "3·1·18")
#mapa-item("FM indirecta: modulador de fase tras un oscilador a cristal (ventaja: estabilidad)", "1·1·17")
#mapa-item("Índice de modulación de FM: m = Δf / f_m", "9·1·17")
#mapa-item("Excursión máxima de la NBFM: unos ±2,5 a ±5 kHz", "13·1·17")
#mapa-item("Índice de modulación de AM: porcentaje de variación de amplitud de la portadora", "R107")
#mapa-item("Clases de emisión UIT: A1A (CW), A3E (AM), J3E (SSB), R3E, F3E (FM)", "12·1·18")
#mapa-item("Margen de audiofrecuencia para la inteligibilidad: 300 a 3000 Hz", "5·1·17")
#mapa-item("Micrófono (sonido → señal eléctrica) y su preamplificador (eleva su bajo nivel)", "R108")
#mapa-item("Compresor: eleva la potencia media sin superar la de pico", "4·1·17")
#mapa-item("Sobremodulación: índice > 100 %; distorsión y ensanchamiento de la emisión (splatter)", "8·1·17")
#mapa-item("Contra la sobremodulación: bajar el nivel de BF aplicado al modulador", "13·1·18")
#mapa-item("ALC: limita la excitación del final y evita emisiones interferentes alrededor de la frecuencia", "13·1·19")
#mapa-item("La estabilidad de frecuencia del emisor evita interferir a emisiones próximas", "R109")
#mapa-item("Características propias de un transmisor: frecuencia y estabilidad (no sensibilidad ni factor de ruido)", "R110")
#mapa-item("CAF = control automático de frecuencia", "R111")
#mapa-item("Impedancia de salida típica: 50 Ω", "8·1·18")
#mapa-item("Rendimiento = potencia entregada al sistema radiante / potencia consumida", "5·1·18")
#mapa-item("Subsistema auxiliar típico del transmisor: refrigeración", "R112")
#mapa-item("PEP: potencia de pico de envolvente", "10·1·18")
#mapa-item("Potencia de portadora: media durante un ciclo de RF sin modulación", "3·1·19")
#mapa-item("Anchura de banda necesaria: la justa para la velocidad y calidad requeridas", "4·1·18")
#mapa-item("Anchura de banda ocupada: fuera de sus límites se radia el 0,5 % por cada lado", "12·1·19")
#mapa-item("Emisiones no deseadas = no esenciales + fuera de banda", "6·1·17")
#mapa-item("Armónicos: múltiplos enteros de la fundamental", "7·1·19")
#mapa-item("Filtro de salida (paso bajo) y red de acoplo entre el final y la antena: eliminan armónicos y adaptan", "11·1·18")
#mapa-item("Espurias por debajo de 30 MHz: 40 dB bajo la potencia media, sin exceder de 50 mW", "2·1·17")
#mapa-item("Límite de espurias: vale el más restrictivo entre la atenuación y el tope absoluto", "1·1·18")
#mapa-item("Espurias de mezcla: el otro producto y restos del mezclador; filtro paso banda tras él", "R113")
#mapa-item("Manipulación brusca en CW: chasquidos que ensanchan la emisión", "1·1·19")
#mapa-item("Oscilaciones parásitas: frecuencias ajenas a la de trabajo; supresores y ferritas", "R114")
#mapa-item("Radiación por la estructura: RF que escapa por chasis y cables; se reduce apantallando y filtrando", "9·1·18")
#mapa-item("Final valvular: sintonía (mínimo de corriente de placa) y carga (acoplo a la antena)", "R115")
#mapa-item("Amperímetro de RF en la línea de antena: lectura máxima en el ajuste óptimo", "R116")
#mapa-item("Alta tensión de placa del final: se aplica en dos etapas (primero reducida)", "R117")
#mapa-item("En un equipo a válvulas, la RF llega al final al accionar el conmutador emisión/recepción", "R118")
#mapa-item("Preparación previa del emisor: banda, frecuencia y clase de emisión (no el S-meter)", "R119")
#mapa-item("Amplificadores con cavidades resonantes: desde 144 MHz", "R120")
#mapa-item("Válvulas frente a transistores (pregunta de banco)", "R121")
#mapa-item("Modulador digital: niveles discretos de tensión → estados discretos de la portadora", "R122")
#mapa-item("Conmutador SEND/REC: pasa de emisión a recepción y viceversa", "6·1·18")
#mapa-item("Conmutador POWER ON/OFF: encender y apagar el equipo", "R123")
#mapa-item("VOX: pasa a transmisión al hablar; en MAN se usa el PTT del micrófono", "10·1·19")
#mapa-item("Repetidor: recibe en una frecuencia y retransmite a la vez en otra", "2·1·18")
#mapa-item("Desplazamiento del repetidor en 2 m: entrada 600 kHz por debajo de la salida", "4·1·19")
#mapa-item("Acceso a repetidores con subtono CTCSS", "R124")
#mapa-item("Ubicación de los repetidores: lugares elevados para aumentar el alcance (visibilidad directa)", "5·1·19")
#mapa-item("Duplexor: permite al repetidor recibir y transmitir a la vez con una sola antena", "R125")
#mapa-tema("T6", "Antenas y líneas de transmisión")
#mapa-item("Longitud del dipolo de media onda (≈ λ/2: 20 m para la banda de 40 m) y tamaño de la antena en función de la longitud de onda", "11·1·19")
#mapa-item("Resonancia: impedancia de alimentación resistiva pura (antena sintonizada a la frecuencia de la señal; equivale a una resistencia pura)", "9·1·19")
#mapa-item("Para bajar la frecuencia de resonancia hay que alargar la antena (29,9 → 28,5 MHz)", "2·1·19")
#mapa-item("Antena más corta que la resonante: reactancia capacitiva (se compensa con bobina); más larga: inductiva", "7·1·20")
#mapa-item("Elementos reactivos en serie: la bobina alarga eléctricamente la antena (baja f), el condensador la acorta (sube f)", "6·1·19")
#mapa-item("Elementos de sintonía en la base de la antena: bobina y condensador variables (no resistencias)", "R126")
#mapa-item("Impedancia del dipolo de media onda alimentado en el centro: ≈ 73 Ω", "11·1·20")
#mapa-item("Media onda alimentada en un extremo: impedancia muy alta (miles de ohmios)", "11·1·21")
#mapa-item("Dipolo en V invertida: ≈ 50 Ω, casi omnidireccional y un solo mástil", "7·1·21")
#mapa-item("Rendimiento de una antena: η = Rr / (Rr + Rp)", "R127")
#mapa-item("Dipolo plegado: impedancia unas cuatro veces mayor (≈ 300 Ω)", "10·1·20")
#mapa-item("Dipolo plegado: mayor ancho de banda que el simple y la misma ganancia", "R128")
#mapa-item("Dipolo con trampas: circuitos LC paralelo en los brazos que permiten trabajar en varias bandas", "9·1·20")
#mapa-item("La vertical de cuarto de onda necesita plano de tierra o radiales", "13·1·20")
#mapa-item("Impedancia de la vertical de cuarto de onda (≈ 36 Ω) y radiales inclinados (sube hacia 50 Ω)", "12·1·20")
#mapa-item("Diagrama de la vertical: máximo en el plano horizontal y nulo hacia el cénit", "10·1·21")
#mapa-item("La Yagi es una antena directiva (un lóbulo principal dominante)", "13·1·21")
#mapa-item("Yagi: los elementos parásitos no están alimentados y dan la directividad", "4·1·20")
#mapa-item("Yagi: el reflector es más largo y va detrás; los directores, más cortos y delante", "5·1·20")
#mapa-item("Antena helicoidal: polarización circular, usada en enlaces por satélite", "8·1·19")
#mapa-item("Antena helicoidal: la ganancia depende del número de espiras", "R129")
#mapa-item("Antenas de apertura: bocina y reflector parabólico (no las de hilo)", "4·1·21")
#mapa-item("Ganancia de una parabólica: crece con (D/λ)² (duplicar D o f: +6 dB)", "R130")
#mapa-item("Parabólica: el alimentador va en el foco, frente al plato", "R131")
#mapa-item("El diagrama de radiación representa la distribución de la energía radiada en el espacio", "9·1·21")
#mapa-item("Antena omnidireccional: radia igual en todo el plano horizontal (el dipolo, en el plano perpendicular al hilo)", "3·1·20")
#mapa-item("Ancho de haz: entre los puntos de media potencia (−3 dB)", "2·1·20")
#mapa-item("Relación adelante-atrás: dB entre el lóbulo principal y el trasero", "3·1·21")
#mapa-item("Polarización: orientación del campo eléctrico radiado", "3·1·22")
#mapa-item("Polarización cruzada entre emisora y receptora: gran pérdida de señal en visión directa", "R132")
#mapa-item("La ganancia se expresa en dB respecto de una antena de referencia (dBi o dBd)", "1·1·20")
#mapa-item("Conversión dBi = dBd + 2,15 (la p.i.r.e. es 2,15 dB mayor que la p.r.e.)", "8·1·20")
#mapa-item("Potencia efectiva radiada: p.r.e. = P · G, descontando las pérdidas del cable (en dB)", "7·1·22")
#mapa-item("Para aumentar el alcance, lo primero es aumentar la directividad de la antena", "3·1·23")
#mapa-item("Área de captura: Ae = λ²G / 4π (proporcional a la ganancia, mayor a menor frecuencia)", "R133")
#mapa-item("Antena pasiva: no incorpora amplificador", "R134")
#mapa-item("Reciprocidad: el mismo diagrama en transmisión y en recepción", "6·1·20")
#mapa-item("El cable entre el emisor y la antena debe ser apantallado (coaxial)", "R135")
#mapa-item("Línea paralela frente a coaxial: simétrica, 300–600 Ω, menos pérdidas, lejos de metales", "R136")
#mapa-item("La impedancia característica depende de la geometría y del dieléctrico, no de la longitud", "5·1·21")
#mapa-item("Factor de velocidad: la onda va más despacio en la línea; FV = 1/√εr < 1", "4·1·22")
#mapa-item("Longitud física = longitud eléctrica × FV (la física es menor); cálculo de un tramo", "5·1·22")
#mapa-item("Guía de ondas: no propaga por debajo de su frecuencia de corte", "10·1·22")
#mapa-item("La ROE indica el grado de adaptación de impedancias", "1·1·21")
#mapa-item("Definición de la ROE: Vmáx / Vmín (o Imáx / Imín) de la onda estacionaria", "12·1·21")
#mapa-item("Adaptación perfecta: ROE = 1, coeficiente de reflexión 0, potencia reflejada nula", "13·1·22")
#mapa-item("Máxima transferencia: transmisor, línea y antena de la misma impedancia; si difieren, hace falta adaptador", "12·1·22")
#mapa-item("Margen de la ROE: siempre ≥ 1; funcionamiento adecuado entre 1 y 2,5", "2·1·21")
#mapa-item("La ROE no depende de la potencia aplicada", "R137")
#mapa-item("Coeficiente de reflexión y ROE a partir de las impedancias (150 Ω en 50 Ω → ROE 3)", "8·1·21")
#mapa-item("Las pérdidas del coaxial (dB) crecen con la frecuencia y con la longitud", "9·1·22")
#mapa-item("Una ROE alta aumenta las pérdidas totales de la línea", "R138")
#mapa-item("Balun: une el coaxial (asimétrico) con el dipolo (simétrico); sin él la malla radia", "8·1·22")
#mapa-item("Balun 4:1 para alimentar un dipolo plegado de 300 Ω con coaxial de 75 Ω (espiras 2:1)", "R139")
#mapa-item("Transformador de cuarto de onda: Z = √(Zlínea · Zcarga); Zent = Z0²/ZL", "6·1·21")
#mapa-item("El cuarto de onda invierte la impedancia: en cortocircuito se ve como resonante paralelo; abierto, como serie", "11·1·22")
#mapa-item("Tramo de línea en cortocircuito de menos de λ/4: reactancia inductiva", "R140")
#mapa-item("Acoplador de antena: adapta la impedancia del final a la línea y la antena (no mejora la antena)", "2·1·22")
#mapa-item("Red en pi (C–L–C) del acoplador de antena", "R141")
#mapa-item("Orden de conexión: transceptor → (lineal) → medidor de ROE → acoplador → antena", "6·1·22")
#mapa-item("Conmutador de antena: conecta la antena al transmisor o al receptor", "R142")
#mapa-item("Relé T-R: al transmitir desconecta y protege la entrada del receptor", "1·1·22")
#mapa-item("Selector de antenas: elegir qué antena se usa desde un mismo equipo", "R143")
#mapa-tema("T7", "Propagación")
#mapa-item("Nomenclatura de las bandas: sigla y nombre por longitud de onda (HF decamétricas, MF hectométricas, VHF métricas, UHF decimétricas, SHF centimétricas)", "5·1·23")
#mapa-item("Asignar una frecuencia concreta a su banda con λ = 300/f", "13·1·23")
#mapa-item("La onda de superficie predomina en MF y por debajo (sus pérdidas crecen con la frecuencia)", "12·1·23")
#mapa-item("La onda de superficie sigue la curvatura terrestre", "7·1·23")
#mapa-item("HF: propagación por reflexión ionosférica, la del DX (España–Nueva Zelanda)", "4·1·23")
#mapa-item("VHF y UHF: onda directa, distancias cortas", "10·1·23")
#mapa-item("Los satélites de aficionado usan VHF y UHF (hay que atravesar la ionosfera)", "3·1·24")
#mapa-item("A mayor frecuencia, menor alcance (144 MHz llega más fuerte que 430 MHz)", "8·1·23")
#mapa-item("Factores que influyen en un enlace: polarización, potencia, frecuencia y ubicación de las antenas", "R144")
#mapa-item("Horizonte radioeléctrico: d ≈ 4,12 (√h1 + √h2) km", "2·1·23")
#mapa-item("El horizonte radioeléctrico es algo mayor que el óptico (la troposfera curva el rayo)", "13·1·24")
#mapa-item("Atenuación: toda onda se atenúa al propagarse y al atravesar objetos", "5·1·24")
#mapa-item("Pérdida en espacio libre y relación señal/ruido: 20 log d y 20 log f (×10 la distancia: −20 dB)", "10·1·24")
#mapa-item("Difracción: la onda bordea un obstáculo", "8·1·24")
#mapa-item("Capas de la ionosfera: D, E, F1 y F2", "11·1·23")
#mapa-item("Orden de las capas de la atmósfera: troposfera, estratosfera e ionosfera", "9·1·23")
#mapa-item("De noche desaparece la capa D y F1 y F2 se funden en una sola capa F", "6·1·23")
#mapa-item("La capa D absorbe de día las bandas bajas (3,5 MHz: de día menos alcance que de noche)", "8·1·25")
#mapa-item("La ionosfera depende de la actividad solar y de ella dependen las condiciones en HF", "1·1·23")
#mapa-item("Ciclo solar: más manchas → más ionización, MUF más alta y bandas altas abiertas", "9·1·24")
#mapa-item("Fulguración solar: ionización brusca de la capa D y apagón de HF (efecto Dellinger)", "R145")
#mapa-item("Frecuencia crítica: la máxima que se refleja en incidencia vertical", "9·1·25")
#mapa-item("MUF ≈ fc / cos θ: mayor que la frecuencia crítica en incidencia oblicua", "12·1·24")
#mapa-item("Frecuencia óptima de trabajo ≈ 85 % de la MUF", "4·1·24")
#mapa-item("Onda espacial (de espacio): la que rebasa el horizonte, sube a la ionosfera y vuelve", "11·1·24")
#mapa-item("Zona de silencio: entre el final de la onda de superficie y la primera onda reflejada", "7·1·24")
#mapa-item("Ángulo de radiación bajo → distancia de salto más larga", "3·1·25")
#mapa-item("Los cambios de propagación alteran la distancia de salto: aparecen en tu frecuencia estaciones que antes no oías", "R146")
#mapa-item("Desvanecimiento (fading): variación momentánea de la intensidad recibida", "10·1·25")
#mapa-item("El conducto troposférico se forma con una inversión térmica (aire cálido sobre aire frío)", "11·1·25")
#mapa-item("El conducto troposférico se da en VHF y UHF, con alcances de cientos de kilómetros", "4·1·25")
#mapa-item("Los conductos son más probables con tiempo anticiclónico estable", "R147")
#mapa-item("Dispersión troposférica (troposcatter): alcance más allá del horizonte visual con grandes pérdidas", "R148")
#mapa-item("Esporádica-E: nubes de ionización intensa en la capa E que reflejan VHF", "2·1·24")
#mapa-item("Esporádica-E: más frecuente en verano", "1·1·24")
#mapa-item("Esporádica-E: un salto cubre de 1000 a 2000 km", "R149")
#mapa-item("Reflexión auroral: en las cortinas ionizadas de las auroras", "2·1·25")
#mapa-item("Señales aurorales: ásperas y distorsionadas; la telegrafía es lo más eficaz", "R150")
#mapa-item("Meteor-scatter: reflexión en las estelas ionizadas de los meteoros", "6·1·24")
#mapa-item("Meteor-scatter: la señal llega en ráfagas breves", "R151")
#mapa-item("Rebote lunar (EME): VHF y superiores, sobre todo 144 MHz (ondas métricas)", "7·1·25")
#mapa-item("Ruido atmosférico (tormentas): domina en las bandas bajas de HF", "6·1·25")
#mapa-item("Flujo solar de 10,7 cm: índice de actividad solar para estimar la ionización y la MUF", "R152")
#mapa-item("Predicción de propagación (VOACAP): MUF y bandas abiertas a partir de los índices solares", "R153")
#mapa-item("En un espectro la frecuencia crece hacia la derecha: la menor está a la izquierda", "R154")
#mapa-tema("T8", "Medidas")
#mapa-item("Qué instrumento mide cada magnitud básica (voltímetro: tensión; amperímetro: corriente)", "11·1·26")
#mapa-item("Conexión de los instrumentos: amperímetro en serie, voltímetro en paralelo, óhmetro sobre el componente", "13·1·25")
#mapa-item("Resistencia interna ideal: amperímetro nula, voltímetro infinita", "3·1·26")
#mapa-item("Error de carga del voltímetro en un divisor de tensión", "9·1·26")
#mapa-item("Sensibilidad en Ω/V de un polímetro analógico y resistencia de entrada según la escala", "R155")
#mapa-item("Shunt: resistencia en paralelo que amplía la escala del amperímetro y lo protege", "5·1·25")
#mapa-item("Resistencia multiplicadora en serie para ampliar la escala de un voltímetro", "R156")
#mapa-item("Error del instrumento: la clase es un porcentaje del fondo de escala", "R157")
#mapa-item("Influencia de la frecuencia: un polímetro común no sirve para medir tensiones de RF", "4·1·26")
#mapa-item("El polímetro no mide la impedancia de una antena (hace falta puente o analizador de antenas)", "8·1·26")
#mapa-item("Error de forma de onda: polímetro de valor medio frente a verdadero valor eficaz (true RMS)", "R158")
#mapa-item("El dBm y el dBW son unidades de potencia", "4·1·27")
#mapa-item("Conversión entre vatios y dBm (1 mW = 0 dBm; 1 W = 30 dBm)", "2·1·26")
#mapa-item("Potencia en la cresta de la envolvente a partir de la tensión de pico sobre la carga", "9·1·27")
#mapa-item("Potencia media frente a p.c.e. (coinciden con amplitud constante; en SSB la media es mucho menor)", "13·1·26")
#mapa-item("Medida de potencia de RF con vatímetro", "7·1·26")
#mapa-item("Medida de potencia en continua con voltímetro y amperímetro (P = V·I)", "R159")
#mapa-item("El amperímetro de antena es un instrumento de RF (térmico)", "R160")
#mapa-item("Potencia reflejada apreciable en el vatímetro direccional = desadaptación transmisor-antena", "2·1·27")
#mapa-item("Cálculo de la ROE a partir de la potencia directa y la reflejada; potencia entregada = directa − reflejada", "7·1·27")
#mapa-item("El medidor de ROE compara la onda incidente y la reflejada: mide la desadaptación", "1·1·25")
#mapa-item("El medidor de ROE es el instrumento más imprescindible de la estación", "11·1·27")
#mapa-item("Frecuencímetro: medida precisa de la frecuencia (un voltímetro de RF no la mide)", "6·1·26")
#mapa-item("Resolución del frecuencímetro = inverso del tiempo de puerta", "R161")
#mapa-item("Exactitud del frecuencímetro: la fija el cristal de referencia (ppm)", "R162")
#mapa-item("Osciloscopio: representa la forma de onda en el dominio del tiempo (amplitud y período)", "3·1·27")
#mapa-item("Analizador de espectros: dominio de la frecuencia; armónicos y espurias", "12·1·25")
#mapa-item("Generador de señal de RF: caracterizar etapas y receptores", "R163")
#mapa-item("Medidor de campo: intensidad de campo radiado, en V/m", "1·1·26")
#mapa-item("S-meter: indica la intensidad de la señal recibida (es un instrumento de recepción)", "12·1·26")
#mapa-item("S-meter: cada punto S equivale a 6 dB", "5·1·26")
#mapa-item("S-meter: S9 = 50 μV sobre 50 Ω en HF (escala en microvoltios)", "6·1·27")
#mapa-item("Dipmeter: frecuencia de resonancia de un circuito sin alimentarlo", "10·1·26")
#mapa-item("Carga artificial: ajustar el transmisor sin radiar", "10·1·27")
#mapa-tema("T9", "Interferencia e inmunidad")
#mapa-item("Compatibilidad electromagnética: no perturbar el entorno y no verse afectado por él", "5·1·27")
#mapa-item("Conformidad con la directiva EMC (marcado CE)", "R164")
#mapa-item("Fuente, camino y víctima: caminos de acoplo por antena, por líneas y por radiación directa", "10·1·28")
#mapa-item("Intensidad de campo: proporcional a la raíz de la potencia e inversa a la distancia", "R165")
#mapa-item("A más potencia, más riesgo de interferencia: usar la mínima potencia necesaria", "2·1·28")
#mapa-item("La emisión de armónicos y espurias implica riesgo de interferencias en cualquier banda", "7·1·28")
#mapa-item("Emisiones fuera de banda: inmediatamente exteriores a la anchura necesaria, por la modulación", "8·1·27")
#mapa-item("Los amplificadores lineales (sobre todo sobreexcitados) favorecen las interferencias", "R166")
#mapa-item("Desadaptación (ROE alta) favorece las interferencias; conviene ROE baja", "6·1·28")
#mapa-item("Bloqueo o desensibilización: un campo intenso satura la entrada aunque esté sintonizado lejos", "5·1·28")
#mapa-item("Remedio del bloqueo y de la TVI: filtro en la entrada del equipo afectado (problema de inmunidad)", "11·1·28")
#mapa-item("Intermodulación: dos o más señales intensas mezcladas en una etapa no lineal", "8·1·28")
#mapa-item("Detección en circuitos de audio: una unión semiconductora rectifica la RF y recupera la envolvente", "13·1·27")
#mapa-item("Desacoplo: ferritas y condensadores en los cables del equipo afectado", "9·1·28")
#mapa-item("Cable blindado para los altavoces", "13·1·28")
#mapa-item("Apantallamiento: caja metálica, eléctricamente estanca y a tierra (jaula de Faraday en los dos sentidos)", "12·1·27")
#mapa-item("La fibra óptica es el medio más inmune a las interferencias radiadas", "R167")
#mapa-item("Filtro de red (de línea de desacoplo) en la alimentación", "1·1·27")
#mapa-item("Filtro de rechazo de banda (notch) para eliminar una frecuencia concreta", "1·1·28")
#mapa-item("Una buena tierra reduce la RF en los chasis y las interferencias", "4·1·28")
#mapa-item("Ante una queja: comprobar la propia estación y colaborar", "3·1·28")
#mapa-item("Prueba de la carga artificial: si la interferencia sigue, el camino es la conducción por la red o los cables", "R168")
#mapa-tema("T10", "Seguridad")
#mapa-item("Interruptor general de la estación", "7·1·29")
#mapa-item("Lo que daña es la corriente: intensidad, recorrido y duración", "11·1·29")
#mapa-item("Umbrales de corriente (1 mA se nota, 10–20 mA no se suelta, ~30 mA fibrilación): cuál es más peligrosa", "6·1·29")
#mapa-item("Efectos de la descarga: tetanización, fibrilación, quemaduras (no somnolencia)", "R169")
#mapa-item("Cuerpo mojado: baja la resistencia y aumenta el riesgo", "12·1·28")
#mapa-item("Precauciones en los trabajos de instalación (locales húmedos, manos mojadas, cruce de conductores)", "R170")
#mapa-item("Una antena que transmite no se toca (quemaduras de RF)", "4·1·29")
#mapa-item("Exposición a campos de RF: nivel de referencia de 28 V/m entre 10 y 400 MHz", "R171")
#mapa-item("Antes de manipular un equipo: desconectarlo de la red y descargar los condensadores", "13·1·29")
#mapa-item("Resistencia de descarga (bleeder) en paralelo con el condensador de filtro", "R172")
#mapa-item("Accidente eléctrico: lo primero es cortar la corriente", "4·1·30")
#mapa-item("Si no se puede cortar: separar a la víctima con un elemento aislante, nunca tocarla directamente", "9·1·29")
#mapa-item("Primeros auxilios: no dar de beber (sí cubrir, comprobar respiración, avisar)", "R173")
#mapa-item("Si no respira: respiración artificial sin esperar", "R174")
#mapa-item("Quemadura eléctrica: agua abundante y asistencia médica", "R175")
#mapa-item("Incendio en equipo eléctrico: cortar la corriente y extintor de CO2 o polvo, nunca agua ni espuma", "3·1·29")
#mapa-item("Operador y familiares deben conocer los primeros auxilios", "R176")
#mapa-item("El titular responde del cumplimiento de la normativa de seguridad", "R177")
#mapa-item("Interferencia a servicios de seguridad de la vida humana, al móvil aeronáutico o a la ICT del edificio: dejar de emitir", "12·1·29")
#mapa-item("Fusible: en serie, corta las sobreintensidades", "9·1·30")
#mapa-item("Fusible fundido: sustituirlo por otro del mismo calibre (nunca mayor ni un puente)", "6·1·30")
#mapa-item("Calibre del fusible: ligeramente superior al consumo máximo del equipo", "5·1·29")
#mapa-item("Fusible de la alimentación en el positivo, junto a la batería o la fuente", "R178")
#mapa-item("Fusibles rápidos (F) y temporizados (T)", "R179")
#mapa-item("Magnetotérmico: sobrecargas y cortocircuitos", "11·1·30")
#mapa-item("Diferencial: actúa cuando la corriente de ida y la de vuelta difieren (derivación a tierra)", "7·1·30")
#mapa-item("El diferencial protege a las personas frente a contactos indirectos y defectos de aislamiento", "1·1·29")
#mapa-item("Elementos de protección personal: guantes de goma (aislantes)", "R180")
#mapa-item("La toma de tierra protege al operador: deriva la fuga y hace actuar al diferencial", "12·1·30")
#mapa-item("La tierra debe llegar a cada uno de los chasis metálicos, unidos entre sí", "8·1·29")
#mapa-item("La toma de tierra debe tener la menor resistencia posible", "8·1·30")
#mapa-item("El conductor de tierra no lleva fusible ni interruptor", "2·1·29")
#mapa-item("Qué vale como tierra: la del edificio si está en buen estado; nunca el neutro ni tuberías de gas o agua", "5·1·30")
#mapa-item("La pica de tierra se entierra en terreno húmedo, no seco y soleado", "1·1·30")
#mapa-item("Antena lejos de las líneas eléctricas aéreas: distancia mayor que la altura total del conjunto", "13·1·30")
#mapa-item("Vientos del mástil: repartidos alrededor y tensados por igual", "3·1·30")
#mapa-item("Vientos metálicos con aisladores intercalados para que no resuenen", "R181")
#mapa-item("Antena en mástil propio, no en el de la antena colectiva", "2·1·30")
#mapa-item("Rotores: dimensionados para peso y par (en torretas), cableado protegido y separado", "R182")
#mapa-item("Trabajo en altura: arnés, comprobar la estructura, nunca trabajar solo", "R183")
#mapa-item("Ante una tormenta: desconectar la antena (y el equipo de la red), nunca la toma de tierra", "10·1·29")
#mapa-item("Protección contra el rayo: mástil y malla a tierra por el exterior, descargador y una sola tierra", "10·1·30")
#mapa-tema("R1", "Alfabeto fonético internacional")
#mapa-item("Para qué sirve el alfabeto fonético: deletrear letras y cifras sin confusiones (no cifra ni abrevia)", "12·2·1")
#mapa-item("Las cifras se deletrean con su nombre inglés (Zero…Nine); el 0 es Zero, no Oscar ni «Cero»", "10·2·1")
#mapa-item("Deletreo de distintivo EA5SWJ: E Echo, A Alfa, S Sierra, W Whiskey, J Juliett (no «Japón»), cifra en inglés", "1·2·1")
#mapa-item("Deletreo de distintivo AN6BL: N November (no «Noviembre»), B Bravo, L Lima, 6 Six", "2·2·1")
#mapa-item("Deletreo de distintivo EA3RCQ: R Romeo, C Charlie, Q Quebec (no «Queen»), 3 Three", "6·2·1")
#mapa-item("X X-ray, Y Yankee, Z Zulu (no «Zeta»); grafías Echo y Alfa (no Eco, Alpha)", "7·2·1")
#mapa-item("U Uniform y Z Zulu frente a palabras de alfabetos antiguos (Uncle, Zebra, Coca, Dog, Able)", "11·2·1")
#mapa-item("Sufijo CID: C Charlie, I India (no «Italia»), D Delta (no «Dog»)", "4·2·1")
#mapa-item("Sufijos TOP y BOJ: T Tango, O Oscar, P Papa (no Pedro, Peter)", "5·2·1")
#mapa-item("F Foxtrot y G Golf", "8·2·1")
#mapa-item("H Hotel y K Kilo", "11·2·2")
#mapa-item("M Mike y V Victor", "13·2·1")
#mapa-tema("R2", "Código Q")
#mapa-item("QRM (interferencia de otras estaciones) frente a QRN (parásitos atmosféricos)", "4·2·2, 8·2·2")
#mapa-item("QRO aumente / QRP disminuya la potencia", "5·2·2")
#mapa-item("QRS transmita más despacio / QRQ más deprisa", "6·2·2, 13·2·2")
#mapa-item("QRT cese la transmisión frente a QRX espere, volveré a llamar", "5·2·3, 9·2·1")
#mapa-item("QRV estoy dispuesto frente a QRU no tengo nada para usted", "11·2·3")
#mapa-item("QRG frecuencia exacta frente a QRH su frecuencia varía", "1·2·2")
#mapa-item("QRK inteligibilidad, QSA intensidad, QRI tono (las tres valoraciones de la señal)", "6·2·3, 12·2·2")
#mapa-item("Escalas de respuesta: QRK y QSA de 1 a 5; QRI de 1 a 3", "13·2·3")
#mapa-item("QRL: estoy ocupado / ¿está ocupada la frecuencia?", "7·2·2")
#mapa-item("QRZ ¿quién me llama? (la llamada general es CQ, que no es código Q)", "3·2·1")
#mapa-item("QSY cambie de frecuencia", "4·2·3")
#mapa-item("QSB desvanecimiento (fading)", "9·2·2")
#mapa-item("QSL acuse de recibo frente a QSO comunicado entre dos estaciones", "8·2·3, 12·2·3")
#mapa-item("QTH posición o localidad (frente a QTR, QRA, QTC)", "2·2·2")
#mapa-item("QTR hora exacta", "10·2·2")
#mapa-item("QRA nombre de la estación (no la posición)", "2·2·3")
#mapa-item("QRB distancia entre estaciones", "3·2·2")
#mapa-item("QTC tengo mensajes para transmitir", "1·2·3")
#mapa-item("QSP retransmitir gratuitamente a…", "12·2·4")
#mapa-item("QSK puedo oírle entre mis señales (break-in)", "13·2·4")
#mapa-item("QSM repita el último mensaje", "5·2·4")
#mapa-item("QSN ¿me ha oído / ha oído a… en… kHz?", "7·2·3")
#mapa-item("QSX ¿quiere escuchar a… en… kHz? (frente a QSN, que mira al pasado)", "8·2·4")
#mapa-item("QSD manipulación defectuosa", "10·2·3")
#mapa-item("QSV transmita una serie de V", "4·2·4")
#mapa-item("QRW avise a… de que le llamo en… kHz", "1·2·4")
#mapa-item("QTA anule el mensaje", "6·2·4")
#mapa-item("QRY ¿cuál es mi turno?", "9·2·3")
#mapa-item("QSZ transmita cada palabra o grupo dos veces", "11·2·4")
#mapa-tema("R3", "Abreviaturas")
#mapa-item("CQ llamada general a todas las estaciones", "9·2·4")
#mapa-item("K invitación a transmitir («cambio»)", "6·2·5")
#mapa-item("AR fin de la transmisión (no del contacto)", "5·2·5")
#mapa-item("SK fin del contacto", "2·2·4")
#mapa-item("CL cierre de la estación", "2·2·5")
#mapa-item("BK interrupción breve (break)", "11·2·5")
#mapa-item("DE delante del distintivo de quien transmite", "10·2·4")
#mapa-item("R recibido (conforme)", "3·2·3")
#mapa-item("RPT repita y AGN de nuevo", "7·2·4")
#mapa-item("DX contacto de larga distancia", "1·2·5")
#mapa-item("CW telegrafía Morse (onda continua)", "13·2·5")
#mapa-item("USB banda lateral superior / LSB inferior", "9·2·5")
#mapa-item("SSB banda lateral única", "7·2·5")
#mapa-item("Informe RST: R legibilidad 1–5, S intensidad 1–9, T tono 1–9", "10·2·5")
#mapa-item("La T (tono) solo se da en telegrafía: 59 en fonía, 599 en CW", "11·2·6")
#mapa-item("Escala de legibilidad: R5 = perfectamente legible (R1 ilegible…)", "3·2·4")
#mapa-item("OM operador corresponsal (old man)", "8·2·5")
#mapa-item("YL operadora y XYL esposa", "5·2·6")
#mapa-item("73 saludos cordiales y 88 besos", "12·2·5")
#mapa-item("PSE por favor", "11·2·7")
#mapa-item("TNX / TKS y TU: gracias", "6·2·6")
#mapa-item("WX tiempo meteorológico", "10·2·6")
#mapa-item("UR su (your)", "10·2·7")
#mapa-item("RIG equipo, ANT antena, PWR potencia", "1·2·6")
#mapa-item("OP operador", "2·2·6")
#mapa-item("HR aquí y ES y", "2·2·7")
#mapa-item("NIL nada, sin novedad", "7·2·6")
#mapa-item("CFM confirmo", "7·2·7")
#mapa-item("ABT aproximadamente y VY muy", "4·2·5")
#mapa-item("HI risa en telegrafía", "9·2·6")
#mapa-item("SRI lo siento", "12·2·6")
#mapa-item("FB buen trabajo, formidable (fine business)", "11·2·8")
#mapa-item("CUL hasta luego (see you later)", "8·2·6")
#mapa-item("BUG manipulador semiautomático", "4·2·6")
#mapa-item("GM buenos días (GA es «adelante»)", "3·2·5")
#mapa-item("GE buenas tardes", "12·2·7")
#mapa-item("GN buenas noches", "5·2·7")
#mapa-item("GL buena suerte", "13·2·6")
#mapa-item("MSG mensaje", "6·2·7")
#mapa-item("NR número", "4·2·7")
#mapa-item("Trabajar en split: emitir en una frecuencia y recibir en otra", "1·2·7")
#mapa-item("Locator (QTH locator, Maidenhead): forma breve de dar la ubicación", "8·2·7")
#mapa-item("SWL radioescucha (short wave listener)", "13·2·7")
#mapa-tema("R4", "Señales de socorro, urgencia y seguridad")
#mapa-item("Socorro en radiotelefonía: MAYDAY", "7·2·8")
#mapa-item("Urgencia en radiotelefonía: PAN PAN (tres veces)", "9·2·7")
#mapa-item("Seguridad en radiotelefonía: SÉCURITÉ (tres veces)", "6·2·8")
#mapa-item("Formato de la llamada de socorro: Mayday ×3 + «aquí»/«de» + distintivo ×3", "12·2·8")
#mapa-item("Contenido del mensaje de socorro: identificación, posición, naturaleza del peligro (nunca «Sécurité»)", "4·2·8")
#mapa-item("Socorro en radiotelegrafía: SOS (no XXX, TTT ni CQD)", "11·2·9")
#mapa-item("SOS se transmite como un solo signo (sin separar las letras)", "2·2·8")
#mapa-item("Urgencia en radiotelegrafía: XXX tres veces", "5·2·8")
#mapa-item("Seguridad en radiotelegrafía: TTT tres veces", "2·2·9")
#mapa-item("Prioridad: seguridad < urgencia < socorro", "13·2·8")
#mapa-item("Señal de alarma radiotelefónica: tonos alternos de 2200 y 1300 Hz", "10·2·8")
#mapa-item("Alerta de socorro GMDSS por DSC en MF: 2187,5 kHz (voz: 2182 kHz)", "7·2·9")
#mapa-item("Canal 16 de VHF marítima: 156,8 MHz (socorro, seguridad y llamada en voz)", "11·2·10")
#mapa-item("Al oír un socorro: silencio, escucha y auxilio si es posible", "8·2·8")
#mapa-item("Tras emitir un socorro: escuchar en la misma frecuencia", "5·2·9")
#mapa-item("Peligro grave e inminente: se puede usar cualquier medio y frecuencia", "1·2·8")
#mapa-item("Usar SOS o MAYDAY sin peligro real es infracción sancionable", "3·2·6")
#mapa-item("Resolución 640 del RR: bandas de aficionado en socorro por catástrofes naturales", "3·2·7")
#mapa-item("Colaboración obligatoria en catástrofes a requerimiento de la DG de Protección Civil y Emergencias (art. 30.4)", "9·2·8")
#mapa-item("Socorro captado: hacer lo posible para que llegue a la DG de Protección Civil y Emergencias (art. 30.5)", "3·2·8")
#mapa-item("Banda de 40 m en la Región 1: 7000–7200 kHz", "8·2·9")
#mapa-item("Banda de 10 m: 28–29,7 MHz", "2·2·10")
#mapa-item("Límites en HF: 80 m 3500–3800 kHz, 20 m 14000–14350 kHz (¿está dentro de banda?)", "10·2·9")
#mapa-item("Banda de 2 m en la Región 1: 144–146 MHz", "13·2·9")
#mapa-item("Banda de 70 cm: 430–440 MHz", "12·2·9")
#mapa-item("Banda de 23 cm: 1240–1300 MHz", "4·2·9")
#mapa-item("Banda de 13 cm: 2300–2450 MHz", "5·2·10")
#mapa-item("Aficionados por satélite: solo en las bandas atribuidas al efecto en el CNAF", "11·2·11")
#mapa-item("Segmento de satélites en 70 cm: 435–438 MHz", "9·2·9")
#mapa-item("Segmento exclusivo de satélites en 2 m: 145,806–146,000 MHz", "1·2·9")
#mapa-item("Centros de actividad de emergencia IARU R1: 14300 kHz (mundial) y 3760 kHz (80 m)", "6·2·9")
#mapa-tema("R5", "Distintivos de llamada")
#mapa-item("Qué es el distintivo: señal de identificación que identifica al titular desde cualquier punto del territorio (no al equipo ni al domicilio)", "4·2·10")
#mapa-item("El distintivo se otorga junto con la autorización y lo asigna la Administración (no se elige ni lo da la asociación)", "5·2·11")
#mapa-item("Cuándo identificarse: al comienzo y al final de cada emisión, siempre, y en las largas al menos cada 10 min", "1·2·10, 8·2·10")
#mapa-item("Identificación de móviles y portables: /M, /MM, /MA, /P en grafía; palabras («portable») en fonía; no existe /AM", "9·2·10, 13·2·10")
#mapa-item("Añadir opcionalmente el distrito desde el que se emite: EA7/EA4KLM/M", "10·2·10")
#mapa-item("QRP no forma parte del distintivo: se anuncia en la llamada (CQ QRP)", "8·2·11")
#mapa-item("Licencia CEPT en telefonía: entre el prefijo y el distintivo se dice «stroke»", "1·2·11")
#mapa-item("Composición del distintivo: prefijo + distrito + sufijo", "3·2·9")
#mapa-item("El distintivo tiene como máximo seis caracteres", "4·2·11")
#mapa-item("Prefijos de España: series EA–EH (y AM–AO); habituales EA, EB y EC", "7·2·10")
#mapa-item("Las series de prefijos las atribuye la UIT (Reglamento de Radiocomunicaciones) y cada país asigna dentro de ellas", "8·2·12")
#mapa-item("Estructura internacional: la parte de nacionalidad tiene hasta tres caracteres, letras o cifras", "12·2·10")
#mapa-item("Prefijos de los países vecinos: Portugal CT, Francia F, Andorra C3", "5·2·12")
#mapa-item("Prefijos de otros países europeos: Alemania DL, Italia I, Reino Unido G/M", "10·2·11")
#mapa-item("La cifra es la del distrito de residencia del titular al otorgar la autorización", "9·2·11")
#mapa-item("Mudarse de distrito: se conserva el distintivo (único e inmodificable); solo se comunica el domicilio", "1·2·12")
#mapa-item("Hay nueve distritos geográficos (1 a 9); el 0 es especial", "11·2·12")
#mapa-item("Distrito 0: solo para actos inaugurados o visitados por el Rey", "4·2·12")
#mapa-item("Distritos insulares y ciudades autónomas: 6 Baleares, 8 Canarias, 9 Ceuta y Melilla", "3·2·10, 12·2·11")
#mapa-item("Distritos peninsulares: asignar provincia a su cifra y leer la cifra de un distintivo", "4·2·13, 13·2·11")
#mapa-item("Excepciones de distrito: Albacete es del 5 y La Rioja del 1", "11·2·13")
#mapa-item("Sufijo: hasta tres letras, por orden alfabético y turno riguroso de expedición", "7·2·11")
#mapa-item("Sufijos excluidos: DDD, PAN, SOS, TTT, XXX y la serie QAA–QZZ", "1·2·13, 8·2·13")
#mapa-item("Estaciones automáticas desatendidas: prefijo ED; sufijo con Y (analógica) o Z (digital)", "6·2·10, 12·2·12")
#mapa-item("Estaciones colectivas: distintivo propio; sufijos UR (asociaciones), RC y RK (radioclubes)", "11·2·14")
#mapa-item("Sufijo de dos letras: 5 años de autorización, 5 de práctica internacional y 5 sin expediente sancionador; no reservado a colectivas", "12·2·13")
#mapa-item("Sufijo de una letra: reservado también para concursos internacionales de alta competitividad", "13·2·12")
#mapa-item("Sufijo de una letra como distintivo permanente: 15 años de práctica internacional", "6·2·11")
#mapa-item("Res. 29-07-2026: la práctica para el sufijo de una letra se acredita con 2 QSL por año en 15 de los últimos 20", "9·2·12")
#mapa-item("Res. 29-07-2026: asignación por distritos y orden de presentación, hasta 10 preferencias; el nuevo distintivo sustituye al anterior", "9·2·13")
#mapa-item("Sufijos de cuatro o más letras: excepcionales, para usos temporales en eventos de relevancia especial", "2·2·11")
#mapa-item("Más de una cifra en el distintivo: acontecimientos relevantes identificados por sus fechas (aniversarios)", "3·2·11")
#mapa-item("Reasignación de distintivos: agotadas las combinaciones, salvo anterior titular o familiares de primer grado por fallecimiento", "5·2·13")
#mapa-item("Prefijos temporales ED, EE y EF: eventos ordinarios; mantienen el resto del distintivo", "6·2·12, 10·2·12")
#mapa-item("Prefijos EG y EH: concursos, eventos internacionales y eventos relevantes locales, regionales o autonómicos", "2·2·12")
#mapa-item("Prefijos AM y AN: eventos relevantes de ámbito nacional", "10·2·13")
#mapa-item("Prefijo AO: eventos relevantes de ámbito internacional", "2·2·13")
#mapa-item("Prefijo AO optativo para españoles en zonas no adscritas a soberanías nacionales", "13·2·13")
#mapa-item("Para qué se pide un distintivo temporal: concursos, experimentos, ensayos o conmemoraciones", "7·2·12")
#mapa-item("Solicitud de distintivo temporal: una por evento, a la Administración; las asociaciones solo proponen", "3·2·12")
#mapa-item("Distintivo temporal: máximo 30 días al año por sufijo y peticionario (excepción: una letra en concursos, hasta 2 años)", "6·2·13")
#mapa-tema("R6", "Planes de bandas de la IARU")
#mapa-item("Qué es un plan de bandas: reparto recomendado de cada banda por modo y anchura de banda; instrumento básico de ordenación", "3·2·13, 11·2·15")
#mapa-item("Naturaleza de los planes: acuerdos voluntarios y guía mundial, pero la Orden obliga a usar el de la Región 1 como norma general en España", "6·2·14, 10·2·14")
#mapa-item("Los planes parten de las atribuciones del Reglamento de Radiocomunicaciones y hay uno por Región de la UIT", "4·2·14")
#mapa-item("La IARU es la federación de asociaciones nacionales de radioaficionados (URE en España)", "9·2·14")
#mapa-item("España pertenece a la Región 1 de la UIT", "7·2·13")
#mapa-item("Composición de las Regiones: 1 Europa y África; 2 América; 3 resto de Asia y Oceanía", "1·2·14")
#mapa-item("Por qué hay Regiones: atribuir bandas por zonas; por eso las bandas difieren entre España y EE. UU.", "2·2·14")
#mapa-item("Frecuencias de llamada: punto de encuentro de un modo, no de uso exclusivo", "10·2·15")
#mapa-item("Frecuencia de llamada de FM en 2 m: 145,500 MHz", "1·2·15")
#mapa-item("Frecuencia de llamada de FM en 70 cm: 433,500 MHz", "2·2·15")
#mapa-item("Canal de llamada de FM en 10 m: 29,600 MHz", "5·2·14")
#mapa-item("Repetidores de 2 m: entrada 145,000–145,1875 MHz, salida 600 kHz más arriba", "5·2·15, 9·2·15")
#mapa-item("Repetidores de 70 cm: entrada 433,000–433,375 MHz, desplazamiento 1,6 MHz", "3·2·14")
#mapa-item("Centros de actividad de SSB: 144,300 MHz (2 m) y 432,200 MHz (70 cm)", "11·2·16")
#mapa-item("Balizas en 2 m: segmento 144,400–144,491 MHz", "9·2·16")
#mapa-item("Balizas en HF: 14.099–14.101 kHz exclusivo del International Beacon Project", "13·2·14")
#mapa-item("Convenio de banda lateral: LSB por debajo de 10 MHz, USB por encima; excepción 60 m en USB", "4·2·15, 12·2·14")
#mapa-item("80 m: segmento de CW 3.500–3.570 kHz", "7·2·14")
#mapa-item("20 m: 14.070–14.099 kHz para modos digitales de banda estrecha", "12·2·15")
#mapa-item("Las frecuencias del plan HF son las realmente transmitidas, no la del dial", "13·2·15")
#mapa-item("Bandas sin concursos: 60, 30, 17 y 12 m", "8·2·14")
#mapa-tema("R7", "Responsabilidad social y procedimientos operativos")
#mapa-item("Definición del servicio de aficionados: instrucción individual, intercomunicación y estudios técnicos, sin lucro", "7·2·15")
#mapa-item("Contenido: temas del servicio y observaciones de carácter personal", "6·2·15")
#mapa-item("Prohibidos fines comerciales, publicitarios o lucrativos; permitidos mensajes técnicos sobre ensayos", "4·2·16")
#mapa-item("Mensajes de terceros: no permitidos con carácter general (salvo emergencia)", "2·2·16")
#mapa-item("Lenguaje claro: sin códigos que oculten el significado (Q y abreviaturas sí)", "8·2·15")
#mapa-item("Escuchar antes de transmitir (QRL?)", "10·2·16")
#mapa-item("Interferir deliberadamente: nunca está permitido", "5·2·16")
#mapa-item("Decir «cambio» es recomendable, no obligatorio", "1·2·16")
#mapa-item("Deletrear con el alfabeto fonético internacional; no inventar palabras", "11·2·17")
#mapa-item("Código SINPO: intensidad, interferencias, ruido, propagación y calidad global", "8·2·16")
#mapa-item("Código del Radioaficionado: considerado, leal, progresista, amistoso, equilibrado y patriota", "13·2·16")
#mapa-item("Autorregulación (self-policing): autodisciplina, sin policía propia", "6·2·16")
#mapa-item("Antenas: garantizar el derecho de terceros a no sufrir daños", "7·2·16")
#mapa-item("Autorización especial que causa interferencias: suspender de inmediato", "3·2·15")
#mapa-item("Objeto de la prueba de capacitación: evaluar la capacidad para operar", "9·2·17")
#mapa-item("Emitir música está prohibido: el servicio de aficionados no es radiodifusión", "12·2·16")
#mapa-tema("R8", "Reglamentación nacional e internacional")
#mapa-item("Marco: competencia exclusiva del Estado en telecomunicaciones (art. 149.1.21.ª CE)", "10·2·17")
#mapa-item("Ley General de Telecomunicaciones vigente: Ley 11/2022", "3·2·16")
#mapa-item("RD 123/2017: Reglamento sobre el uso del dominio público radioeléctrico", "6·2·17")
#mapa-item("Uso del espectro por radioaficionados: uso especial, con autorización individual; explotación compartida sin exclusión de terceros", "6·2·18")
#mapa-item("Orden IET/1311/2013: documento fundamental de regulación de la radioafición", "11·2·18")
#mapa-item("Orden IET/1311/2013: derogó la Orden ITC/1791/2006", "9·2·18")
#mapa-item("Orden IET/1311/2013: entrada en vigor el día siguiente a su publicación", "5·2·17")
#mapa-item("Radioaficionado: interés por la radiotecnia con carácter exclusivamente personal, sin fines de lucro", "9·2·19")
#mapa-item("CNAF = Cuadro Nacional de Atribución de Frecuencias", "4·2·17")
#mapa-item("CNAF vigente: aprobado por orden ministerial (Orden TDF/732/2026)", "12·2·17")
#mapa-item("Ley 19/1983 («Ley de antenas»): derecho a instalar antenas de aficionado en el exterior de los inmuebles", "13·2·19")
#mapa-item("RD 2623/1986: reglamento de las instalaciones de antenas de aficionado", "6·2·22")
#mapa-item("La autorización de radioaficionado la otorga la SETSI (hoy SETID)", "8·2·21")
#mapa-item("Requisito previo de la autorización: superar la prueba de capacitación (certificado HAREC)", "8·2·22")
#mapa-item("Naturaleza de la autorización: individual, personal e intransferible, revocable", "5·2·21")
#mapa-item("Vigencia indefinida: no se renueva; suprimida la comunicación quinquenal", "7·2·21")
#mapa-item("La autorización habilita a emitir en las bandas y con las características técnicas del servicio de aficionados", "13·2·22")
#mapa-item("Plazo para resolver la autorización (y la licencia de estación fija): 6 semanas, silencio desestimatorio", "11·2·20")
#mapa-item("Recursos contra las resoluciones: reposición en 1 mes o contencioso ante la Audiencia Nacional en 2 meses", "4·2·22")
#mapa-item("Solicitud de autorización: preferentemente por medios electrónicos, con modelo oficial", "5·2·22")
#mapa-item("Solicitud de autorización: acompañada del resguardo de la tasa de tramitación", "4·2·23")
#mapa-item("Menores: sin edad mínima; escrito fehaciente de padres o tutores", "10·2·22")
#mapa-item("Autorización en formato bilingüe si lo pide el interesado (lengua cooficial)", "11·2·21")
#mapa-item("No es obligatorio ser socio de una asociación de radioaficionados", "3·2·19")
#mapa-item("No es obligatorio disponer de estación fija", "10·2·23")
#mapa-item("Se puede tener distintivo (autorización) sin licencia de estación; la licencia solo la necesita la estación fija", "3·2·20")
#mapa-item("Extinción automática de la autorización: fallecimiento del titular o extinción de la asociación titular", "7·2·22")
#mapa-item("Revocación de la autorización: no se puede emitir; se cancelan el distintivo y la licencia de estación fija asociada", "3·2·21")
#mapa-item("Uso de una estación ajena: con permiso del titular, identificándose con el distintivo propio", "9·2·24")
#mapa-item("Ninguna estación tiene derecho preferente sobre una frecuencia", "1·2·21")
#mapa-item("Las estaciones están sometidas siempre a la inspección", "3·2·22")
#mapa-item("Equipos de construcción propia: sin autorización previa, bajo la responsabilidad del titular (régimen sancionador si interfieren)", "6·2·26")
#mapa-item("Equipo de construcción propia: presentación optativa en la Jefatura con memoria (diagrama de bloques, esquemas)", "1·2·22")
#mapa-item("Equipos comerciales: legislación vigente en su comercialización inicial; los ya legalizados, la de su autorización inicial", "13·2·23")
#mapa-item("Equipo de segunda mano sin certificado de aceptación: cumplir el anexo I, certificado por laboratorio acreditado", "9·2·25")
#mapa-item("Estación construida de acuerdo con el estado de la técnica (no se impone tecnología)", "12·2·22")
#mapa-item("La estación debe tener elementos para comprobar que la emisión está en banda y medir la potencia", "10·2·24")
#mapa-item("Potencia y duración de las emisiones limitadas a lo estrictamente necesario", "10·2·25")
#mapa-item("Estación fija: precisa licencia, asociada a la autorización de radioaficionado de su titular", "1·2·23")
#mapa-item("Definición de estación fija: ubicación fija consignada en la licencia", "7·2·23")
#mapa-item("Solicitud de licencia de estación fija: con memoria descriptiva de la instalación", "10·2·26")
#mapa-item("Contenido de la memoria: toma de tierra, plano, equipos (no el empadronamiento)", "5·2·23")
#mapa-item("La licencia se expide terminado el montaje y presentada la documentación", "5·2·24")
#mapa-item("Plazos de fin de instalación: comunicarlo en 6 semanas; la Jefatura verifica y expide en ≤ 30 días", "7·2·24")
#mapa-item("Montaje por instalador de telecomunicaciones inscrito, salvo instalaciones simples autorizadas por el Jefe Provincial", "13·2·24")
#mapa-item("Modificaciones con licencia: permanentes se comunican; cambiar la antena de sitio = primera instalación", "12·2·23")
#mapa-item("Modificaciones experimentales con licencia concedida: hasta 60 días sin afectar a la seguridad", "9·2·26")
#mapa-item("Seguro de responsabilidad civil obligatorio, formalizado antes de expedirse la licencia", "5·2·25")
#mapa-item("Copia del contrato de seguro a la propiedad o al presidente de la comunidad", "11·2·22")
#mapa-item("Cancelación de la licencia fija (p. ej., sin seguro): desmontar todo, antenas incluidas, a costa del titular", "12·2·24")
#mapa-item("Licencia fija condicionada a no perturbar otros servicios y a cumplir normas de seguridad, servidumbres, medio ambiente", "7·2·25")
#mapa-item("Permisos de servidumbres, medio ambiente, etc.: por cuenta y a cargo del solicitante", "13·2·25")
#mapa-item("Derecho a instalar la antena en el exterior: legitimación para usar el edificio + autorización administrativa", "4·2·24")
#mapa-item("Comunidad de propietarios: no autoriza; la solicitud indica la dirección del presidente y la Administración le informa", "2·2·22")
#mapa-item("La comunidad dispone de 2 meses para alegar sobre la idoneidad del emplazamiento", "8·2·23")
#mapa-item("Derechos del predio sirviente (art. 545 CC): la comunidad decide por mayoría simple", "1·2·24")
#mapa-item("Obras en el inmueble: aviso al titular con 1 mes de antelación", "1·2·25")
#mapa-item("Obras: desmontaje temporal sin indemnización; después se reinstala en condiciones similares", "9·2·27")
#mapa-item("Obras de indudable urgencia: desmontaje sin trámites, comunicándolo inmediatamente al titular", "2·2·23")
#mapa-item("Instalación provisional durante las obras: la autoriza la Administración; gastos del titular", "8·2·24")
#mapa-item("Daños: los que causa la antena (instalación, conservación, desmontaje) son del titular; los que causa la propiedad a la antena, de la propiedad", "2·2·24")
#mapa-item("Condiciones de instalación: sin molestias ni peligro, señalizar anclajes y riostras, materiales resistentes, respetar otras antenas, no dañar la obra", "7·2·26")
#mapa-item("Soportes: a la obra civil o con repartidores de carga; nunca a pararrayos ni a conducciones eléctricas", "6·2·27")
#mapa-item("Altura libre mínima de 3 m sobre el plano de paso", "11·2·23")
#mapa-item("Líneas de transmisión a ≥ 10 cm de conductos y canalizaciones del edificio", "5·2·26")
#mapa-item("Definiciones del RD 2623/1986: anclaje, riostra, plano de paso, elemento repartidor de carga", "11·2·24")
#mapa-item("Usos experimentales con características distintas de las generales: requieren autorización especial", "3·2·23")
#mapa-item("Autorización especial experimental: nominativa, plazo máximo inicial de 18 meses, ampliable", "13·2·26")
#mapa-item("Autorización especial experimental: pedirla con al menos 1 mes de antelación", "7·2·27")
#mapa-item("Memoria técnica de la autorización experimental: contenido (experimento, diagrama si es casero, coordenadas, período, banda, emisión, potencia, antena)", "7·2·28")
#mapa-item("Emisiones experimentales: se identifican con el distintivo propio", "9·2·28")
#mapa-item("Bandas que requieren autorización especial: 2300–2450 MHz, 5650–5850 MHz y 24,050–24,250 GHz (con excepciones)", "12·2·25")
#mapa-item("Autorizaciones del art. 16 (bandas secundarias): limitaciones geográficas o técnicas", "2·2·25")
#mapa-item("Estación portable: la fija usada temporalmente en otra ubicación", "12·2·26")
#mapa-item("Uso portable: notificar con 5 días; usos no continuados de hasta 15 días naturales sin notificación", "8·2·25")
#mapa-item("Estación móvil: en movimiento o detenida en puntos no determinados", "2·2·26")
#mapa-item("Estación portátil: antena y fuente de energía incorporadas, utilizable en movimiento", "11·2·25")
#mapa-item("Estación fija remota: accionada a distancia", "3·2·24")
#mapa-item("Estación digital: emite con técnicas digitales", "2·2·27")
#mapa-item("Estación temporal: concursos, expediciones, demostraciones y eventos", "4·2·25")
#mapa-item("Estación colectiva: responsable la Junta Directiva de la asociación", "12·2·27")
#mapa-item("Asociación reconocida: por resolución de la SETSI, tras inscribirse en Interior y presentar estatutos", "4·2·26")
#mapa-item("Estatutos de la asociación reconocida: fines propios de la radioafición y obligación de cumplir el Reglamento", "1·2·26")
#mapa-item("Colectivas: licencia + autorización individualizada con distintivo propio", "12·2·28")
#mapa-item("Varias desatendidas en una autorización: misma modulación, titularidad y ubicación", "11·2·26")
#mapa-item("Noveles en estaciones colectivas: supervisor con ≥ 3 años de antigüedad", "10·2·27")
#mapa-item("Noveles: distintivo de la colectiva + 2 o 3 letras tras el sufijo", "3·2·25")
#mapa-item("Noveles: potencia ≤ 40 % del máximo de la banda y nunca más de 100 W", "8·2·26")
#mapa-item("Estación automática desatendida: estación colectiva que no requiere intervención directa del operador", "1·2·27")
#mapa-item("Tipos de desatendidas (art. 24): repetidores analógicos, digitales, de nodo, finales y radiobalizas", "4·2·27")
#mapa-item("Repetidoras digitales: de portadora o nodo (enlaza con repetidoras) frente a final (distribuye a los usuarios)", "11·2·27")
#mapa-item("Titular de una desatendida: solo asociaciones de radioaficionados legalmente reconocidas", "11·2·28")
#mapa-item("Número de desatendidas: según las necesidades del servicio (cobertura y canales)", "8·2·27")
#mapa-item("Obligaciones del gestor de la desatendida (no le corresponde autorizar su funcionamiento)", "3·2·26")
#mapa-item("Repetidor: su objetivo es ampliar el alcance de las comunicaciones", "13·2·27")
#mapa-item("Acceso a repetidores: necesariamente libre; si hay código, público y facilitado a quien lo pida", "3·2·27")
#mapa-item("Repetidor analógico-digital accedido por red pública: código personal e intransferible + distintivo", "5·2·27")
#mapa-item("Potencia de las desatendidas: VHF/UHF 10 W en casco urbano y 50 W fuera; HF 50 W", "2·2·28")
#mapa-item("Ganancia del sistema radiante de las desatendidas: ≤ 6 dBd", "10·2·18")
#mapa-item("Repetidores y radiobalizas: telemando y alimentación ininterrumpida ≥ 6 h", "5·2·18")
#mapa-item("Distintivo de los repetidores analógicos: Morse ≤ 10 palabras/min, cada ≤ 10 min", "6·2·19")
#mapa-item("Radiobaliza: desatendida para estudios de propagación que emite señales de identificación", "13·2·17")
#mapa-item("Radiobaliza: distintivo a intervalos ≤ 3 min", "5·2·19")
#mapa-item("Radiobaliza: información solo de su posición y condiciones de funcionamiento", "7·2·17")
#mapa-item("Radiobaliza: sistema radiante omnidireccional", "13·2·18")
#mapa-item("Radiobalizas en las bandas de aficionado (p. ej., 144–146 MHz)", "8·2·17")
#mapa-item("Desatendida: instalarla en 6 meses (si no, caduca la autorización de instalación)", "8·2·18")
#mapa-item("Desatendida terminada: se aplica el procedimiento de la licencia de estación fija (art. 20)", "1·2·17")
#mapa-item("Desatendida: interrupción > 3 meses puede llevar a cancelar su licencia", "8·2·19")
#mapa-item("Interferencia persistente: la SETSI puede restringir bandas, potencia u horario", "6·2·20")
#mapa-item("Interconexión con otras redes: permitida con condiciones (fines de radioafición)", "13·2·20")
#mapa-item("Prohibido codificar para ocultar el significado, salvo el mando de estaciones espaciales", "7·2·18")
#mapa-item("Seguridad: la SETSI no es responsable en ningún caso del incumplimiento de las normas de seguridad", "6·2·21")
#mapa-item("Anomalía de seguridad mecánica o eléctrica: subsanarla de forma inmediata", "9·2·20")
#mapa-item("Disposición final 2.ª: la SETSI dicta instrucciones y actualiza los anexos técnicos", "9·2·21")
#mapa-item("Nomenclatura de bandas: números, símbolos (HF, VHF, SHF…), rangos y ondas (métricas, B.m.…)", "3·2·17, 7·2·19")
#mapa-item("Servicio secundario: no causa interferencia al primario ni puede reclamar protección; sí frente a secundarios posteriores", "10·2·19")
#mapa-item("Interferencia perjudicial: compromete la radionavegación o seguridad, o degrada gravemente o interrumpe un servicio", "5·2·20")
#mapa-item("Interferencia: degradación, falseamiento o pérdida de información por energía no deseada", "12·2·18")
#mapa-item("Tolerancia de frecuencia: desviación entre la frecuencia asignada y el centro de la banda ocupada", "1·2·18")
#mapa-item("p.i.r.e. (referencia isótropa) frente a p.r.a. (referencia dipolo)", "10·2·20")
#mapa-item("Modulaciones permitidas: dentro de las bandas y con anchos de banda del plan IARU Región 1", "2·2·17")
#mapa-item("Modulaciones digitales autorizadas: con señales de audio, datos o vídeo", "2·2·18")
#mapa-item("Potencia máxima en HF (1,8–28 MHz): 1000 W p.c.e.", "9·2·22")
#mapa-item("Potencia máxima en 50, 70 y 144 MHz (600 W p.c.e.) y en 430–440 MHz (300 W p.c.e.)", "8·2·20")
#mapa-item("Potencia máxima en 23 cm y superiores: 1000 W p.i.r.e.", "4·2·18")
#mapa-item("Potencia en 137 y 475 kHz: 1 W p.i.r.e. (475 kHz: 5 W a más de 800 km de África)", "13·2·21")
#mapa-item("Bandas con atribución secundaria: potencia ≤ 50 % de la tabla", "4·2·19")
#mapa-item("Banda de 60 m: atribución secundaria y 15 W p.i.r.e.", "2·2·19")
#mapa-item("Banda de 40 m: 7100–7200 kHz, a título primario para aficionados en la Región 1 desde 2009", "12·2·19")
#mapa-item("EME y dispersión meteórica: hasta 1000 W p.c.e. en subbandas IARU y fuera de cascos urbanos", "R184")
#mapa-item("Bandas ICM: el aficionado debe aceptar su interferencia perjudicial", "R185")
#mapa-item("Bandas ICM: 433,05–434,79 MHz, 2400–2450 MHz, 5725–5800 MHz y 24,00–24,25 GHz", "R186")
#mapa-item("Exposición a RF: < 3,5 mW/cm² donde haya o transiten personas", "R187")
#mapa-item("Emisiones no esenciales: límites en dB y en potencia absoluta según banda y potencia (manda el más estricto)", "R188")
#mapa-item("T/R 61-01 = licencia CEPT (uso temporal); T/R 61-02 = certificado HAREC", "2·2·20, 10·2·21")
#mapa-item("Licencia CEPT: habilita temporalmente en los países T/R 61-01; no se concede «a través del HAREC»", "1·2·19")
#mapa-item("Licencia CEPT: la expide un país, sea o no de la CEPT, que haya adoptado la T/R 61-01", "R189")
#mapa-item("Contenido de la licencia CEPT (no consta la asociación ni la fecha del examen)", "2·2·21")
#mapa-item("Licencia CEPT: todas las bandas atribuidas al servicio en el país visitado (no las del país de origen)", "4·2·20")
#mapa-item("Licencia CEPT: presentarla a petición de las autoridades del país visitado", "7·2·20")
#mapa-item("Licencia CEPT: sin protección contra interferencias perjudiciales", "6·2·23")
#mapa-item("Licencia CEPT: respetar siempre el RR y la reglamentación del país visitado", "12·2·20")
#mapa-item("Identificación con licencia CEPT: prefijo del país visitado (y opcionalmente distrito) + distintivo propio", "4·2·21")
#mapa-item("Licencia CEPT de otro país en España: equiparada, solo para no residentes en estancias temporales", "1·2·20")
#mapa-item("Extranjero residente: autorización sin examen con HAREC de un país T/R 61-02 o por reciprocidad (residencia acreditada)", "3·2·18, 11·2·19")
#mapa-item("Extranjero de país no T/R 61-01: autorización temporal ≤ 90 días", "9·2·23")
#mapa-item("Autorización temporal del art. 15: la solicitud incluye la licencia original o copia fehaciente", "R190")
#mapa-item("Autorización temporal del art. 15: equipos conformes a la normativa española", "R191")
#mapa-item("Emitir desde Andorra: licencia temporal andorrana para titulares de licencia extranjera", "R192")
#mapa-item("HAREC: certifica la capacidad para operar; no autoriza a emitir, no caduca, sustituye al diploma de operador", "6·2·24")
#mapa-item("HAREC: permite obtener la autorización en otro país que aplique la T/R 61-02 (traslado de residencia)", "6·2·25")
#mapa-item("T/R 61-02: abierta a países sean o no de la CEPT", "R193")
#mapa-item("Programa de la prueba: acorde al anexo 6 de la T/R 61-02", "R194")
#mapa-item("Examen: no hace falta HAREC para presentarse; tasa previa; convocatoria de la Secretaría de Estado", "R195")
#mapa-item("Zonas ITU: España peninsular en la zona 37 (CQ 14)", "R196")
#mapa-item("Radiocomunicación: telecomunicación por ondas radioeléctricas", "R197")
#mapa-item("Estación de aficionado: estación del servicio de aficionados (RR)", "R198")
#mapa-item("Servicio de aficionados por satélite: usa estaciones espaciales situadas en satélites", "R199")
#mapa-item("RR art. 25: comunicaciones entre países permitidas salvo oposición de una administración", "12·2·21")
#mapa-item("RR art. 25: las administraciones verifican las cualificaciones operativas y técnicas", "R200")
#mapa-item("RR art. 25: la potencia máxima la fijan las administraciones", "R201")
#mapa-tema("R9", "Inspección y régimen sancionador")
#mapa-item("Inspección: el Ministerio competente, mediante la inspección de telecomunicaciones y las Jefaturas Provinciales", "10·2·28")
#mapa-item("Potestad sancionadora: Administración General del Estado (titular de la Secretaría de Estado de Telecomunicaciones)", "10·2·29")
#mapa-item("Los inspectores tienen la consideración de autoridad pública", "6·2·28")
#mapa-item("Obligación de permitir la inspección; solo el domicilio protegido exige consentimiento o autorización judicial", "6·2·29")
#mapa-item("Las infracciones se tipifican en la Ley General de Telecomunicaciones", "11·2·29")
#mapa-item("Ley 11/2022: art. 106 muy graves, 107 graves, 108 leves", "5·2·28")
#mapa-item("Muy grave: interceptar sin autorización telecomunicaciones no destinadas al público", "5·2·29")
#mapa-item("Grave: la mera producción de interferencias", "8·2·28")
#mapa-item("Muy grave: la producción deliberada de interferencias", "1·2·28")
#mapa-item("Muy grave: no atender el requerimiento de cese de emisiones", "13·2·28")
#mapa-item("Muy grave: uso del espectro no adecuado al CNAF", "4·2·28")
#mapa-item("Grave: negativa u obstrucción a la inspección", "1·2·29")
#mapa-item("Grave: superar los límites de exposición o no señalizar/vallar", "5·2·30")
#mapa-item("Leve: comunicarse utilizando estaciones no autorizadas", "4·2·29")
#mapa-item("Leve: no facilitar los datos requeridos o retrasarlos", "2·2·29")
#mapa-item("Leve: instalar una estación de radioaficionado sin autorización", "9·2·29")
#mapa-item("Leve: emisión no autorizada, salvo que sea grave o muy grave", "3·2·28")
#mapa-item("No es infracción comunicar con otra estación de la que se es titular", "8·2·29")
#mapa-item("No es infracción no llevar libro de registro (no existe la obligación)", "9·2·30")
#mapa-item("Emitir fuera de las bandas autorizadas es infracción", "13·2·29")
#mapa-item("Multas máximas: 20 M€ muy graves y 2 M€ graves", "13·2·30")
#mapa-item("Multa máxima de las leves: 100 000 €", "4·2·30")
#mapa-item("Prescripción: 3 años muy graves, 2 graves, 1 leves", "3·2·29, 11·2·30")
#mapa-item("Sanciones accesorias: cese, ajuste, precintado o incautación de equipos, clausura", "7·2·29")
#mapa-item("Reiteración: 2 o más sanciones firmes del mismo tipo en 3 años; la leve pasa a grave", "12·2·29")
#mapa-item("El expediente se tramita por la LGT y el procedimiento administrativo común", "1·2·30")
#mapa-item("Plazo para resolver el procedimiento sancionador: un año", "7·2·30")
#mapa-item("Plazo mínimo de alegaciones: quince días hábiles", "10·2·30")
#mapa-item("Interferencias comprobadas por la inspección: cese de las emisiones hasta corregir la causa", "6·2·30")
#mapa-item("Titular que sabe que interfiere: medidas técnicas razonables a su costa, sin esperar requerimiento", "3·2·30")
#mapa-item("Revocación: fines comerciales sí; no tener estación no es causa", "12·2·30")
#mapa-item("Cancelación de la autorización a petición del titular", "2·2·30")
#mapa-item("Portadora sin modular: solo para ensayos breves", "8·2·30")
]
