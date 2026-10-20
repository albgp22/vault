// Portada y páginas preliminares (integrador)
#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---------------------------------------------------------------- portada
#page(header: none, footer: none, margin: (x: 2.2cm, y: 2.4cm))[
  #set align(center)
  #v(1.2cm)
  #text(font: fuente-sans, size: 10pt, weight: "bold", tracking: 0.25em, fill: col.naranja)[EXAMEN DE RADIOAFICIONADO]
  #v(0.2cm)
  #text(font: fuente-sans, size: 8pt, tracking: 0.12em, fill: col.gris)[PRUEBA DE CAPACITACIÓN · ORDEN IET/1311/2013 · CERTIFICADO HAREC]
  #v(0.9cm)
  #cetz.canvas(length: 1cm, {
    import cetz.draw: *
    // suelo
    line((-0.6, 0), (10.8, 0), stroke: (paint: col.gris.lighten(40%), thickness: 0.6pt, dash: "dotted"))
    // mástil y yagi
    line((1.6, 0), (1.6, 2.6), stroke: 1.4pt + col.tinta)
    line((0, 2.6), (3.2, 2.6), stroke: 1.2pt + col.tinta)
    for (x, h) in ((0.3, 0.75), (1.2, 0.62), (2.1, 0.55), (2.9, 0.5)) {
      line((x, 2.6 - h), (x, 2.6 + h), stroke: 1.3pt + col.naranja)
    }
    // frentes de onda
    for (i, r) in ((0, 0.45), (1, 0.8), (2, 1.15)) {
      arc((3.4 + r * calc.cos(40deg), 2.6 + r * calc.sin(40deg)), start: 40deg, stop: -40deg, radius: r,
        stroke: (paint: col.acento.lighten(i * 25%), thickness: 1.2pt))
    }
    // onda modulada en AM con su envolvente
    translate((4.8, 2.6))
    let env = x => 0.55 + 0.35 * calc.sin(x * 1.1)
    onda(x => env(x) * calc.sin(x * 10), 0, 5.8, n: 520, stroke: 1pt + col.acento)
    onda(env, 0, 5.8, stroke: (paint: col.naranja, thickness: 0.7pt, dash: "dashed"))
    onda(x => -env(x), 0, 5.8, stroke: (paint: col.naranja, thickness: 0.7pt, dash: "dashed"))
  })
  #v(1.6cm)
  #text(font: fuente-sans, size: 30pt, weight: "bold", fill: col.tinta)[Examen de Radioaficionado]
  #v(0.25cm)
  #text(size: 13pt)[Banco de preguntas razonado, tema a tema]
  #v(0.35cm)
  #text(size: 11pt, style: "italic", fill: col.acento)[Las dos pruebas de la capacitación, en espejo del temario oficial: \ electricidad y radioelectricidad · normativa reglamentaria]
  #v(0.9cm)
  #line(length: 45%, stroke: 0.6pt + col.gris.lighten(30%))
  #v(0.9cm)
  #block(width: 80%, align(left, {
    set text(size: 10pt)
    set par(justify: false, leading: 0.6em)
    set list(marker: text(fill: col.acento)[•], spacing: 0.75em, body-indent: 0.6em)
    [
      - Preguntas tipo test con cuatro opciones, como en el examen real.
      - Organizadas según el Anexo II de la Orden IET/1311/2013 (temas #box[T1–T10] y #box[R1–R9]).
      - Soluciones razonadas y clave de corrección rápida en el apéndice D.
      - #text(fill: col.verde, weight: "bold")[Edición ampliada:] cada circuito explicado pieza a pieza, con su simulación en Falstad.
    ]
  }))
  #v(1fr)
  #text(font: fuente-sans, size: 9pt, tracking: 0.2em, fill: col.gris)[JULIO 2026 · EDICIÓN AMPLIADA, OCTUBRE 2026]
]

#page(header: none, footer: none)[]

// ---------------------------------------------------------------- preliminares
#counter(page).update(3)
#estilo-paginas.update("i")

#place(hide(heading(level: 1, numbering: none)[El examen y este cuaderno]))
#v(1.4cm)
#align(center, text(font: fuente-sans, size: 19pt, weight: "bold")[El examen y este cuaderno])
#v(0.7cm)

La condición de radioaficionado se obtiene en España superando la prueba de capacitación para operar estaciones de radioaficionado, regulada por la Orden IET/1311/2013 (artículo 10 y Anexo II) y, en su procedimiento, por la Resolución de 3 de junio de 2014 de la Secretaría de Estado de Telecomunicaciones. El programa está alineado con la Recomendación T/R 61-02 de la CEPT, de modo que el certificado obtenido es el armonizado europeo HAREC.

#align(center, block(width: 88%, table(
  columns: (auto, 1fr),
  stroke: none,
  row-gutter: 2pt,
  inset: (x: 8pt, y: 5pt),
  fill: (x, y) => if x == 0 { col.acento-claro } else { none },
  table.cell(align: right, text(font: fuente-sans, weight: "semibold", fill: col.acento)[Formato]), [60 preguntas tipo test con 4 opciones (30 + 30)],
  table.cell(align: right, text(font: fuente-sans, weight: "semibold", fill: col.acento)[Partes]), [Prueba 1.ª: electricidad y radioelectricidad · Prueba 2.ª: reglamentación],
  table.cell(align: right, text(font: fuente-sans, weight: "semibold", fill: col.acento)[Duración]), [45 minutos por parte (90 en total)],
  table.cell(align: right, text(font: fuente-sans, weight: "semibold", fill: col.acento)[Aprobado]), [15 aciertos de 30 en cada parte, por separado],
  table.cell(align: right, text(font: fuente-sans, weight: "semibold", fill: col.acento)[Modalidad]), [Por ordenador, en la Jefatura Provincial de Inspección de Telecomunicaciones],
)))

=== Cómo está organizado

Los temas siguen exactamente el temario oficial del Anexo II: la prueba primera son los temas T1–T10 y la segunda los temas R1–R9. Cada tema abre con una ficha que reproduce su alcance oficial, de modo que siempre se sepa qué puede caer; sigue un desarrollo teórico del contenido — con las derivaciones y la física detrás de cada fórmula, no solo el resultado — y, entretejidas con la teoría, las preguntas numeradas (T1.7 es la pregunta 7 del tema T1). Las soluciones no están junto a las preguntas: cada tema tiene en el apéndice su clave de corrección rápida y sus soluciones razonadas, con el porqué de la respuesta y, cuando procede, el cálculo completo.

=== Cómo usarlo

El Ministerio no publica el banco de preguntas. Lo que sí se conoce son las diez convocatorias de papel de 2007 a 2011, que circulan recopiladas en los bancos públicos (URE, FEDI-EA, clubes): cada convocatoria repetía solo entre el 4 % y el 10 % de las preguntas de las anteriores, de modo que no era un banco cerrado y pequeño sino un fondo de miles de preguntas del que el Tribunal elaboraba cada cuestionario. Los candidatos de los últimos años cuentan que la parte de normativa se parece mucho a esos tests y que la parte técnica se parece poco. Memorizar letras rinde, por tanto, poco: lo que funciona es dominar cada punto del temario con el tipo de pregunta del examen.

Las preguntas de los temas son de elaboración propia, calibradas con ese estilo y contrastadas una por una con las recopilaciones públicas. El apéndice de preguntas complementarias recoge, además, las preguntas públicas que los temas no cubrían de forma obvia, con su solución razonada. Un PDF aparte, _Diez simulacros de examen_, reproduce el formato real (30 + 30 preguntas, 45 minutos por prueba) con corrección razonada. Y una hoja de repaso resume los conceptos que conviene recordar.

La estrategia que funciona: estudiar un tema, responder sus preguntas sin mirar, corregir con la clave y leer las soluciones razonadas de todas las preguntas, también las acertadas. Conviene no presentarse hasta responder con soltura 25 o más de cada 30, aunque el aprobado esté en 15: ese margen absorbe las preguntas nuevas que el examen incorpora.

=== Qué trae esta edición ampliada

La primera parte —los dos capítulos de introducción y los temas T1 a T10— se ha reescrito alrededor de una pregunta: _¿qué problema resuelve esto?_ Cada componente y cada circuito aparece primero como la solución a un problema concreto de una radio, y solo después como fórmula. Los recuadros siguen siempre el mismo código:

#grid(
  columns: (1fr, 1fr),
  column-gutter: 10pt,
  row-gutter: 6pt,
  motivacion[El problema que resuelve lo que viene a continuación.],
  analogia[Una imagen mecánica o hidráulica para fijar la idea.],
  porque[Tras cada esquema: qué hace cada pieza y qué fallaría sin ella.],
  idea[Lo que hay que llevarse de la sección.],
  ejemplo[Un cálculo con valores reales de una estación.],
  ojo[La trampa que el examen pone en los distractores, o un peligro real.],
)

Junto a muchos esquemas aparece el botón #falstad("lrc.txt", texto: [Simúlalo en Falstad]): abre en el navegador el circuito equivalente en el simulador gratuito de Paul Falstad, donde se ven las corrientes moverse y se puede cambiar cualquier valor. Es la forma más rápida de convencerse de que un circuito hace lo que el texto dice.

#pagebreak(weak: true)

// ---------------------------------------------------------------- índice
#{
  set par(justify: false)
  show heading.where(level: 1): it => {
    v(1.4cm)
    align(center, text(font: fuente-sans, size: 19pt, weight: "bold", it.body))
    v(0.7cm)
  }
  // número de página con el estilo de su zona (romano en preliminares)
  let pagina(it) = {
    let loc = it.element.location()
    numbering(estilo-paginas.at(loc), ..counter(page).at(loc))
  }
  show outline.entry.where(level: 1): it => {
    v(1.1em, weak: true)
    link(it.element.location(), text(font: fuente-sans, weight: "bold", size: 10.5pt,
      it.indented(it.prefix(), [#it.body() #h(1fr) #pagina(it)])))
  }
  show outline.entry.where(level: 2): it => {
    set text(size: 9.5pt)
    v(0.45em, weak: true)
    link(it.element.location(), it.indented(it.prefix(), [#it.body() #box(width: 1fr, repeat(gap: 0.35em, text(fill: col.gris.lighten(40%))[.])) #text(fill: col.gris, pagina(it))]))
  }
  outline(title: [Índice general], depth: 2, indent: 1.4em)
}
