
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
