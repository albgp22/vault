// =====================================================================
//  Portada, instrucciones e índice de los simulacros de CONTROL
// =====================================================================
#page(header: none, footer: none, margin: (x: 2.2cm, y: 2.4cm))[
  #set align(center)
  #set par(justify: false)
  #v(2.2cm)
  #text(font: fuente-sans, size: 10pt, weight: "bold", tracking: 0.25em, fill: col.naranja)[EXAMEN DE RADIOAFICIONADO]
  #v(0.2cm)
  #text(font: fuente-sans, size: 8pt, tracking: 0.12em, fill: col.gris)[PRUEBA DE CAPACITACIÓN · ORDEN IET/1311/2013 · CERTIFICADO HAREC]
  #v(2.4cm)
  #text(font: fuente-sans, size: 34pt, weight: "bold", fill: col.tinta)[Simulacros de control]
  #v(0.3cm)
  #text(size: 14pt)[#datos.n simulacros con preguntas nuevas para medir tu nivel]
  #v(0.5cm)
  #line(length: 40%, stroke: 0.8pt + col.acento)
  #v(0.6cm)
  #block(width: 78%, align(left, {
    set text(size: 10.5pt)
    set list(marker: text(fill: col.acento)[•], spacing: 0.8em, body-indent: 0.6em)
    [
      - #datos.n simulacros con el formato real: 30 preguntas de electricidad y radioelectricidad y 30 de normativa, 45 minutos cada prueba.
      - #datos.preguntas preguntas escritas para este cuaderno: no están en el libro ni en los simulacros de estudio.
      - Los mismos #datos.conceptos conceptos que los simulacros de estudio, preguntados de otra manera.
      - Cada solución dice dónde estudiar el concepto si fallas: la pregunta de los simulacros de estudio y la del libro.
    ]
  }))
  #v(1fr)
  #text(font: fuente-sans, size: 9pt, tracking: 0.2em, fill: col.gris)[COMPAÑERO DE «SIMULACROS DE EXAMEN» · OCTUBRE 2026]
]

#page(header: none, footer: none)[]

#counter(page).update(3)
#estilo-paginas.update("i")
#place(hide(heading(level: 1)[Cómo usar estos simulacros de control]))
#v(1.2cm)
#align(center, text(font: fuente-sans, size: 19pt, weight: "bold")[Cómo usar estos simulacros de control])
#v(0.6cm)

=== Para qué sirven

Los _Simulacros de examen_ son para estudiar: cada concepto del temario sale una vez, con su solución razonada, y se trabajan hasta entenderlos. Pero una pregunta que ya has visto se acierta también de memoria. Estos _Simulacros de control_ miden lo otro: si dominas el concepto cuando te lo preguntan de una forma que no conoces, que es lo que pasará en el examen.

Cada simulacro de control tiene los mismos conceptos que el conjunto de los simulacros de estudio, repartidos de nuevo, y cada pregunta es *nueva*: está escrita para este cuaderno y no aparece ni en el libro ni en los simulacros de estudio. Pregunta el mismo concepto desde otro ángulo: otros datos, el cálculo al revés, el dato en el otro sentido (del significado al código, de la frecuencia a la banda), un caso práctico u otra trampa. Cada pregunta se ha revisado por separado: la clave, que solo una opción sea correcta y que no sea una copia de la de estudio.

=== Cómo usarlos

+ *Primero estudia.* Trabaja los simulacros de estudio y el libro. Estos no son para aprender: si los usas para estudiar, dejan de medir.
+ *Haz cada simulacro de control una sola vez*, en condiciones de examen: 45 minutos por prueba, sin libro ni apuntes. Puedes intercalarlos con el estudio (por ejemplo, uno cada semana) o guardar varios para las últimas semanas.
+ *Corrige con la clave* y apunta los aciertos por tema en la tabla que hay bajo cada clave.
+ *Por cada fallo*, la solución te dice dónde está el concepto: _simulacros de estudio 3·1·7_ es el simulacro 3, prueba 1, pregunta 7 del otro cuaderno, y _libro: T3.14_ es la pregunta del libro con su explicación. Vuelve allí, no a esta pregunta.

=== Cómo leer el resultado

El aprobado es 15 de 30 en cada prueba por separado, pero estos simulacros son tu termómetro: con *25 o más* de forma constante estás preparado, porque ese margen absorbe las preguntas del examen que nadie ha visto. Si un tema baja de la mitad en la tabla de aciertos por tema, repasa ese tema entero en el libro y en los simulacros de estudio antes del siguiente control. Un fallo suelto en un tema que dominas es un despiste; dos fallos en el mismo concepto son una laguna.

#nota[Los números como *3·1·7 (estudio 5·1·2)* del mapa del final significan: simulacro de control 3, prueba 1, pregunta 7; el mismo concepto está en el simulacro de estudio 5, prueba 1, pregunta 2.]

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
