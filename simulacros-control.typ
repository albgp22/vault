#let modo = "control"
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
  align(center, text(font: fuente-sans, size: 9pt, weight: "semibold", tracking: 0.14em, fill: col.acento, upper(if modo == "control" [Simulacro de control] else [Simulacro de examen])))
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
#let pq(n, p, k, clave, origen, concepto, enunciado, opciones, sol: none, tema: "") = {
  [#metadata((n: n, p: p, k: k, clave: clave, origen: origen, concepto: concepto, sol: sol, tema: tema)) <meta-sim>]
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
      // aciertos por tema: para saber qué repasar
      let temas = ()
      for v in qs {
        if temas.len() == 0 or temas.last().at(0) != v.tema { temas.push((v.tema, (v.k,))) } else { temas.last().at(1).push(v.k) }
      }
      block(below: 0.9em, breakable: false, {
        set text(font: fuente-sans, size: 8pt)
        table(
          columns: (auto,) + (1fr,) * temas.len(),
          align: center + horizon,
          inset: (x: 3pt, y: 3pt),
          stroke: 0.4pt + col.gris.lighten(50%),
          fill: (x, y) => if x == 0 or y == 0 { col.gris-claro },
          table.cell(align: left)[Tema], ..temas.map(t => [*#t.at(0)*]),
          table.cell(align: left)[Preguntas], ..temas.map(t => [#t.at(1).first()–#t.at(1).last()]),
          table.cell(align: left)[Aciertos], ..temas.map(t => [#h(1fr)/#t.at(1).len()]),
        )
      })
      set text(size: 9.5pt)
      for v in qs {
        block(below: 0.8em, breakable: true, [
          #text(font: fuente-sans, weight: "bold", fill: col.acento)[#v.k] #text(weight: "bold")[(#v.clave)]
          #if v.concepto != "" { text(font: fuente-sans, size: 0.85em, fill: col.gris)[#v.concepto #if v.origen != "" [· #v.origen] — ] } else if v.origen != "" { text(font: fuente-sans, size: 0.85em, fill: col.gris)[#v.origen — ] }
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
  place(hide(heading(level: 1, if modo == "control" [Apéndice · Mapa de conceptos] else [Apéndice B · Mapa de conceptos])))
  v(1.2cm)
  align(center, text(font: fuente-sans, size: 9pt, weight: "semibold", tracking: 0.14em, fill: col.acento, upper(if modo == "control" [Apéndice] else [Apéndice B])))
  v(0.2cm)
  align(center, text(font: fuente-sans, size: 20pt, weight: "bold")[Mapa de conceptos])
  v(0.5cm)
  block(width: 100%, {
    set par(justify: false)
    set text(size: 9.5pt)
    if modo == "control" [Todos los conceptos de estos simulacros de control, tema a tema. #text(font: fuente-sans, weight: "bold")[3·1·7 (estudio 5·1·2)] es la pregunta 7 de la prueba 1 del simulacro de control 3; el mismo concepto está en el simulacro de estudio 5, prueba 1, pregunta 2. Úsalo para encontrar todas las preguntas de un tema que has fallado.] else [Todos los conceptos del temario que cubren estos simulacros, tema a tema, y dónde está cada uno. #text(font: fuente-sans, weight: "bold")[3·1·7] es el simulacro 3, prueba 1, pregunta 7; #text(font: fuente-sans, weight: "bold")[R57] es el número 57 del repaso del apéndice A. Úsalo para repasar un tema entero o para comprobar que no te queda nada por ver.]
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

#let datos = (n: 13, preguntas: 780, conceptos: 748, repaso: 0, nuevas: 0, tecnicas: 390)
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

Cada simulacro de control tiene los mismos conceptos que el conjunto de los simulacros de estudio, repartidos de nuevo, y cada pregunta es *nueva*: está escrita para este cuaderno y no aparece ni en el libro ni en los simulacros de estudio. Pregunta el mismo concepto desde otro ángulo: otros datos, el cálculo al revés, el dato en el otro sentido (del significado al código, de la frecuencia a la banda), un caso práctico u otra trampa. Al escribir cada pregunta se ha comprobado la clave, se han rehecho los cálculos y se ha verificado que solo una opción es correcta y que no copia la de estudio. Si encuentras una pregunta dudosa, la solución remite al libro, que manda.

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

// ======================================================================
#simulacro(1)
#prueba(1, 1)
#pq(1, 1, 1, "a", "estúdialo en: simulacros de estudio 5·1·1 · libro: C-T1.1", "Equivalencias de la ley de Ohm: 1 Ω = 1 V/1 A y 1 V = 1 Ω · 1 A",
  [Multiplicar un ohmio por un amperio da como resultado:],
  ([un voltio], [un vatio], [un culombio], [un julio],),
  sol: [De la ley de Ohm, $V = I R$: si por una resistencia de 1 Ω circula 1 A, entre sus extremos hay 1 V, luego 1 Ω × 1 A = 1 V. El vatio es voltio por amperio ($P = V I$), no ohmio por amperio; el culombio es amperio por segundo y el julio, vatio por segundo.], tema: "T1")
#pq(1, 1, 2, "a", "estúdialo en: simulacros de estudio 13·1·2 · libro: T1.10", "Ley de Coulomb: proporcional al producto de las cargas e inversa al cuadrado de la distancia",
  [Si se duplica el valor de una de las dos cargas y también la distancia que las separa, la fuerza eléctrica entre ellas:],
  ([se reduce a la mitad], [se duplica], [se reduce a la cuarta parte], [no varía],),
  sol: [Por la ley de Coulomb, $F = k q_1 q_2 slash d^2$: doblar una carga duplica la fuerza y doblar la distancia la divide entre $2^2 = 4$, de modo que queda multiplicada por $2 slash 4 = 1 slash 2$. Pensar que no varía es tratar la distancia como si dividiera sin elevarla al cuadrado.], tema: "T1")
#pq(1, 1, 3, "d", "estúdialo en: simulacros de estudio 12·1·4 · libro: T1.23", "Ruido térmico y ruido blanco: P = k T B, independiente de la frecuencia",
  [La temperatura absoluta de una resistencia pasa de 290 K a 580 K y, a la vez, el ancho de banda del receptor se reduce a la mitad. La potencia de ruido térmico disponible:],
  ([se cuadruplica], [se reduce a la mitad], [se duplica], [no varía],),
  sol: [La potencia de ruido térmico es $P = k T B$, proporcional a la temperatura absoluta y al ancho de banda. Doblar $T$ duplica el ruido y reducir $B$ a la mitad lo divide entre dos: los dos efectos se compensan. Quien solo tiene en cuenta uno de los dos factores obtiene el doble o la mitad.], tema: "T1")
#pq(1, 1, 4, "b", "estúdialo en: simulacros de estudio 5·1·3, 12·1·5 · libro: C-T1.31, T1.28", "Anchuras de banda típicas: CW < SSB (2,7 kHz) < AM (6 kHz) < FM",
  [Para transmitir la misma voz (300–3000 Hz), una emisión de AM (A3E) ocupa, respecto a una de SSB (J3E):],
  ([la misma anchura, porque transporta la misma información], [aproximadamente el doble, porque lleva las dos bandas laterales], [la mitad, porque no necesita suprimir la portadora], [unas cuatro veces más, por la potencia de la portadora],),
  sol: [La AM lleva la portadora y dos bandas laterales iguales y ocupa unos 6 kHz; la SSB suprime la portadora y una de las bandas y se queda en unos 2,7 kHz. La portadora es una sola raya y no añade anchura: lo que duplica el ancho es la segunda banda lateral.], tema: "T1")
#pq(1, 1, 5, "d", "estúdialo en: simulacros de estudio 7·1·2 · libro: T1.27", "SSB (J3E): una sola banda lateral, sin portadora",
  [Un operador transmite en SSB (J3E) y deja de hablar sin soltar el pulsador del micrófono. Mientras calla, el transmisor emite:],
  ([la portadora sola, a plena potencia], [la portadora a la mitad de su potencia], [las dos bandas laterales sin modular], [prácticamente nada, porque no hay portadora],),
  sol: [En SSB se suprimen la portadora y una de las bandas laterales: solo se emite la banda que lleva la voz. Sin voz no hay banda lateral y, como tampoco hay portadora, no sale nada. Quedarse con la portadora sería propio de la AM.], tema: "T1")
#pq(1, 1, 6, "b", "estúdialo en: simulacros de estudio 2·1·5 · libro: T2.5", "Termistores: PTC sube y NTC baja su resistencia al aumentar la temperatura",
  [Un componente en serie con la alimentación hace de fusible rearmable: si pasa demasiada corriente se calienta, su resistencia se dispara y la corriente cae sola. Se trata de:],
  ([un varistor (VDR)], [un termistor PTC], [una LDR], [un termistor NTC],),
  sol: [El PTC sube su resistencia al aumentar la temperatura; al calentarse por el exceso de corriente, frena esa misma corriente. El NTC hace lo contrario (baja con el calor) y por eso sirve como limitador de arranque, no como fusible. El varistor depende de la tensión y la LDR de la luz.], tema: "T2")
#pq(1, 1, 7, "a", "estúdialo en: simulacros de estudio 1·1·6 · libro: F-T2.27", "Cálculo de la reactancia capacitiva X_C = 1/(2πfC)",
  [¿Qué capacidad debe tener un condensador para presentar una reactancia de unos 160 Ω a 10 MHz?],
  ([unos 100 pF], [unos 625 pF], [unos 10 pF], [unos 1 nF],),
  sol: [Despejando, $C = 1 / (2 pi f X_C) = 1 / (2 pi dot 10^7 dot 160) approx 10^(-10)$ F, unos 100 pF. Si se olvida el $2 pi$ sale el valor de 625 pF. Las otras dos opciones son errores de un factor 10.], tema: "T2")
#pq(1, 1, 8, "c", "estúdialo en: simulacros de estudio 2·1·6", "Constante de tiempo τ = RC: 63 % de la carga en un τ, carga completa en unos 5τ",
  [Un condensador de 47 μF se carga a través de una resistencia de 100 kΩ. ¿Al cabo de cuánto tiempo, aproximadamente, estará prácticamente cargado?],
  ([unos 0,47 s], [unos 2,35 s], [unos 23,5 s], [unos 4,7 s],),
  sol: [La constante de tiempo es $tau = R C = 10^5 dot 47 dot 10^(-6) = 4","7$ s, y la carga es prácticamente completa en unos $5 tau$, es decir, unos 23,5 s. Los 4,7 s son un solo $tau$, cuando el condensador solo ha llegado al 63 %.], tema: "T2")
#pq(1, 1, 9, "d", "estúdialo en: simulacros de estudio 13·1·7 · libro: C-T2.13", "Aplicación del diodo: detección (y rectificación)",
  [¿En cuál de estas etapas de un receptor de AM se emplea típicamente un diodo?],
  ([en el oscilador local, que genera la señal que se mezcla con la de antena], [en el amplificador de frecuencia intermedia, que da la mayor parte de la ganancia], [en el amplificador de audio, que mueve el altavoz], [en el detector, que recupera el audio de la señal modulada],),
  sol: [El diodo rectifica la RF modulada y deja su envolvente, que es el audio: es el detector de AM, el mismo principio del rectificador de la fuente. Oscilar y amplificar son trabajos del transistor, que es capaz de dar ganancia; el diodo no amplifica.], tema: "T2")
#pq(1, 1, 10, "c", "estúdialo en: simulacros de estudio 6·1·11 · libro: F-T3.41", "Bobina real: la capacidad entre espiras la hace autorresonar; por encima se comporta como un condensador",
  [Una bobina de choque diseñada para HF se emplea a una frecuencia muy superior a su frecuencia de autorresonancia. A esa frecuencia la bobina:],
  ([sigue aumentando su reactancia con la frecuencia y bloquea la RF aún mejor], [presenta su impedancia máxima, como un circuito tanque en resonancia], [se comporta como un condensador y su impedancia baja al subir la frecuencia, de modo que deja de bloquear la RF], [se comporta como una resistencia pura igual a la del hilo],),
  sol: [La capacidad entre espiras forma con la inductancia un circuito resonante paralelo: en la autorresonancia la impedancia es máxima y por encima manda la capacidad, de modo que la bobina se comporta como un condensador y su impedancia cae con la frecuencia. Por eso un choque de HF puede dejar de «chocar» en VHF. La impedancia máxima corresponde a la propia autorresonancia, no a frecuencias muy superiores.], tema: "T3")
#pq(1, 1, 11, "a", "estúdialo en: simulacros de estudio 10·1·12 · libro: T3.51", "Condensadores de desacoplo: absorben los transitorios de la alimentación",
  [Para que absorba los transitorios de la línea de alimentación de una etapa, un condensador de desacoplo se conecta:],
  ([entre la línea de alimentación y masa, cerca de la etapa], [entre la entrada y la salida del amplificador], [en serie con la línea de alimentación, para bloquear los picos], [en serie con la antena],),
  sol: [El condensador de desacoplo, conectado entre el raíl de alimentación y masa, se opone a las variaciones bruscas de tensión y ofrece a los picos un camino corto a masa, sin dejar que viajen hacia otras etapas. En serie con la alimentación bloquearía la propia continua y la etapa se quedaría sin alimentar.], tema: "T3")
#pq(1, 1, 12, "c", "estúdialo en: simulacros de estudio 12·1·13 · libro: T3.18", "Operacional inversor: G = −R2/R1 (no inversor: 1 + R2/R1)",
  [En un amplificador operacional en montaje inversor la resistencia de entrada $R_1$ es de 4,7 kΩ. Para obtener una ganancia de −10, la resistencia de realimentación $R_2$ debe ser de:],
  ([470 kΩ], [42,3 kΩ], [47 kΩ], [470 Ω],),
  sol: [En el inversor $G = -R_2 slash R_1$, luego $R_2 = 10 dot 4","7 = 47$ kΩ. Los 470 Ω invierten el cociente; los 42,3 kΩ salen de aplicar la fórmula del no inversor, $1 + R_2 slash R_1 = 10$; y los 470 kΩ son un error de una potencia de diez.], tema: "T3")
#pq(1, 1, 13, "d", "estúdialo en: simulacros de estudio 2·1·13 · libro: C-T3.14", "PLL: estabiliza un VCO enganchándolo a una referencia; la tensión de error corrige el VCO",
  [En un sintetizador PLL, la estabilidad de frecuencia de la señal de salida la determina sobre todo:],
  ([el divisor programable], [el filtro de lazo], [el propio VCO, que es muy estable por sí mismo], [el oscilador de referencia de cristal, cuya estabilidad hereda el VCO],),
  sol: [El PLL compara la fase del VCO con la de una referencia y lo corrige con la tensión de error hasta engancharlo; una vez enganchado, el VCO hereda la estabilidad del cristal de referencia. El VCO por sí solo es un oscilador LC que deriva, y por eso necesita el lazo. El divisor fija el canal y el filtro alisa la tensión de error, pero ninguno aporta estabilidad propia.], tema: "T3")
#pq(1, 1, 14, "b", "estúdialo en: simulacros de estudio 12·1·14 · libro: T3.10", "DDS: se emplea como oscilador variable de gran precisión",
  [Una ventaja del sintetizador digital directo (DDS) como oscilador variable es que:],
  ([su frecuencia la fija un varicap, lo que facilita el ajuste], [permite variar la frecuencia en pasos finísimos, de fracciones de hercio, con precisión de cristal], [genera la señal analógica sin conversor D/A], [no necesita ningún reloj de referencia],),
  sol: [El DDS genera la onda numéricamente con un acumulador de fase y un conversor D/A, a partir de un reloj de cristal: hereda su precisión y, con un acumulador de muchos bits, su paso de sintonía es de fracciones de hercio. Sin el reloj no hay nada que acumular y sin el D/A no hay señal analógica; el varicap es propio del VCO, no del DDS.], tema: "T3")
#pq(1, 1, 15, "a", "estúdialo en: simulacros de estudio 6·1·15 · libro: T4.6", "Sensibilidad: captar y amplificar señales débiles",
  [Un receptor A consigue una relación señal/ruido aceptable con una señal de 0,2 µV en antena, mientras que otro receptor B necesita 1 µV para lo mismo. Se puede afirmar que:],
  ([A es más sensible que B], [A es más selectivo que B], [A es más estable que B], [B es más sensible que A, porque trabaja con más señal],),
  sol: [La sensibilidad es la capacidad de captar y aprovechar señales débiles, y se da como la señal mínima para una relación señal/ruido determinada: cuanto menor, más sensible. A se conforma con cinco veces menos tensión. Necesitar más señal indica justo lo contrario, y la selectividad o la estabilidad no se miden así.], tema: "T4")
#pq(1, 1, 16, "d", "estúdialo en: simulacros de estudio 6·1·16", "Modulación cruzada: la modulación de una señal fuerte se traslada a la sintonizada (no linealidad)",
  [La modulación cruzada se diferencia de la falta de selectividad de canal adyacente en que:],
  ([es un efecto lineal, que se corrige estrechando el filtro de FI], [solo aparece cuando la señal interferente cae en la frecuencia imagen], [la produce la deriva del oscilador local], [es un efecto no lineal de las primeras etapas, que no se corrige estrechando el filtro de FI],),
  sol: [En la modulación cruzada la falta de linealidad de las primeras etapas pega la modulación de una señal fuerte a la portadora que escuchas, aunque la sintonía esté lejos de ella. La selectividad de canal adyacente, en cambio, es un problema lineal que fijan los faldones del filtro de FI. Por eso estrechar el filtro no arregla la modulación cruzada: el daño ya está hecho antes de él.], tema: "T4")
#pq(1, 1, 17, "b", "estúdialo en: simulacros de estudio 9·1·17 · libro: T5.3", "Índice de modulación de FM: m = Δf / f_m",
  [Una emisión de FM tiene un índice de modulación de 2 con una frecuencia moduladora de 2,5 kHz. Su desviación de frecuencia es de:],
  ([4,5 kHz], [5 kHz], [0,8 kHz], [1,25 kHz],),
  sol: [De $m = Delta f slash f_m$ sale $Delta f = m times f_m = 2 times 2","5 = 5$ kHz. Los 1,25 kHz resultan de dividir $2","5 slash 2$, los 0,8 kHz de dividir $2 slash 2","5$ y los 4,5 kHz de sumar los dos datos.], tema: "T5")
#pq(1, 1, 18, "c", "estúdialo en: simulacros de estudio 5·1·18 · libro: T5.5", "Rendimiento = potencia entregada al sistema radiante / potencia consumida",
  [Un transmisor alimentado a 13,8 V consume 12 A y entrega 80 W a la antena. Su rendimiento es aproximadamente:],
  ([86 %], [207 %], [48 %], [52 %],),
  sol: [Potencia consumida: $13","8 times 12 approx 166$ W. Rendimiento: $80 slash 166 approx 0","48$, es decir, un 48 %. El 52 % es la fracción que se pierde en calor, el 207 % sale de invertir el cociente y el 86 % confunde los unos 86 W perdidos con un porcentaje.], tema: "T5")
#pq(1, 1, 19, "d", "estúdialo en: simulacros de estudio 9·1·19 · libro: T6.2", "Resonancia: impedancia de alimentación resistiva pura (antena sintonizada a la frecuencia de la señal; equivale a una resistencia pura)",
  [Se mide la impedancia en el punto de alimentación de una antena a distintas frecuencias. Su frecuencia de resonancia es aquella en la que:],
  ([la impedancia es lo más alta posible, como en un circuito LC en paralelo], [la parte resistiva se anula y solo queda reactancia], [la reactancia inductiva es el doble de la capacitiva], [la parte reactiva se anula y la impedancia es resistiva pura],),
  sol: [Cerca de su resonancia la antena se comporta como un circuito RLC en serie: a la frecuencia de resonancia $X_L = X_C$, las reactancias se anulan y el generador solo ve una resistencia pura, $R_r + R_p$. Lo que se anula es la reactancia, no la resistencia: la resistencia de radiación representa precisamente la potencia que sale como onda.], tema: "T6")
#pq(1, 1, 20, "a", "estúdialo en: simulacros de estudio 2·1·20 · libro: T6.9", "Ancho de haz: entre los puntos de media potencia (−3 dB)",
  [En el lóbulo principal de una antena, la potencia radiada cae 3 dB respecto del máximo a 25° a cada lado del eje, y se anula a 60° a cada lado. Su ancho de haz es de:],
  ([50°], [60°], [120°], [25°],),
  sol: [El ancho de haz es la apertura angular entre los dos puntos de media potencia (−3 dB) del lóbulo principal: de −25° a +25°, es decir, 50°. Los 120° salen de medir entre los nulos, que es justo lo que no hay que hacer, y los 25° o los 60°, de tomar un solo lado.], tema: "T6")
#pq(1, 1, 21, "b", "estúdialo en: simulacros de estudio 1·1·21 · libro: T6.10", "La ROE indica el grado de adaptación de impedancias",
  [Tras ajustar una antena, el medidor de ROE pasa de marcar 2,5 a marcar 1,2. Esto significa que:],
  ([ha empeorado la adaptación, porque la ROE ideal es la más alta posible], [ha mejorado la adaptación de impedancias entre el transmisor, la línea y la antena], [ha aumentado la potencia que entrega el transmisor], [ha aumentado la ganancia de la antena],),
  sol: [La ROE indica el grado de adaptación de impedancias: cuanto más cerca de 1, menos potencia se refleja (con ROE 2,5 vuelve un 18 %; con 1,2, menos del 1 %). No mide la ganancia de la antena ni la potencia del transmisor, y la ROE ideal es 1, la mínima posible.], tema: "T6")
#pq(1, 1, 22, "c", "estúdialo en: simulacros de estudio 9·1·22 · libro: F-T6.13", "Las pérdidas del coaxial (dB) crecen con la frecuencia y con la longitud",
  [Una instalación usa 20 m de coaxial que, en la banda de 2 m (145 MHz), pierden 4 dB. Si esos mismos 20 m se usan en la banda de 70 cm (435 MHz), la pérdida:],
  ([dependerá de la potencia que se aplique], [será menor de 4 dB, porque la longitud de onda es más corta], [será mayor de 4 dB], [seguirá siendo de 4 dB, porque solo depende de la longitud],),
  sol: [La atenuación del coaxial crece con la frecuencia: el efecto pelicular aumenta la resistencia de los conductores y el aislante se calienta más. Un RG-58 que pierde unos 20 dB cada 100 m en 145 MHz pierde unos 36 dB en 435 MHz. La longitud cuenta, porque la pérdida en dB es proporcional a ella, pero no es lo único; y en dB no depende de la potencia.], tema: "T6")
#pq(1, 1, 23, "a", "estúdialo en: simulacros de estudio 12·1·23 · libro: T7.3", "La onda de superficie predomina en MF y por debajo (sus pérdidas crecen con la frecuencia)",
  [La onda de superficie de una emisora de onda media llega de día a cientos de kilómetros, pero en HF se agota en pocas decenas. ¿Por qué?],
  ([porque las pérdidas que la onda induce en el suelo crecen con la frecuencia], [porque en HF la onda de superficie tiene que ir con polarización horizontal], [porque en HF la ionosfera refleja la onda de superficie hacia el espacio], [porque la capa D absorbe de día la onda de superficie de HF],),
  sol: [La onda de superficie induce corrientes en el suelo, que es mal conductor, y esas pérdidas aumentan con la frecuencia: por eso domina en MF y por debajo y en HF dura poco. La capa D absorbe la onda que sube a la ionosfera, no la que viaja pegada al suelo. Y la onda de superficie debe ir con polarización vertical, porque el suelo cortocircuitaría un campo horizontal.], tema: "T7")
#pq(1, 1, 24, "b", "estúdialo en: simulacros de estudio 11·1·23 · libro: T7.1", "Capas de la ionosfera: D, E, F1 y F2",
  [De las capas de la ionosfera, ¿cuál es la más alta y la que actúa como gran espejo de la HF?],
  ([la D], [la F2], [la E], [la F1],),
  sol: [De abajo arriba, las capas son D (60–90 km), E (90–140 km), F1 y F2; la F2 es la más alta y la que refleja la mayor parte de la HF. La D apenas refleja: de día absorbe las bandas bajas. La E es la sede de la esporádica-E, y la F1 solo existe de día, por debajo de la F2.], tema: "T7")
#pq(1, 1, 25, "c", "estúdialo en: simulacros de estudio 9·1·27 · libro: F-T8.10", "Potencia en la cresta de la envolvente a partir de la tensión de pico sobre la carga",
  [Un transmisor de 400 W p.c.e. trabaja sobre una carga de 50 Ω. La tensión de pico en el máximo de la envolvente es de:],
  ([100 V], [283 V], [200 V], [141 V],),
  sol: [Con $P = V_p^2 slash (2 R)$: $V_p = sqrt(2 P R) = sqrt(2 times 400 times 50) = 200$ V. Los 141 V son la tensión eficaz ($sqrt(P R)$); los 283 V multiplican además por $sqrt(2)$, y los 100 V dividen entre 2 donde había que multiplicar.], tema: "T8")
#pq(1, 1, 26, "d", "estúdialo en: simulacros de estudio 12·1·25 · libro: F-T8.5", "Analizador de espectros: dominio de la frecuencia; armónicos y espurias",
  [Un analizador de espectros conectado, a través de un atenuador, a un transmisor de 7 MHz muestra rayas en 7, 14 y 21 MHz. Las de 14 y 21 MHz son:],
  ([la potencia reflejada por la antena], [las bandas laterales de la modulación de voz], [el ruido térmico del atenuador], [armónicos de la emisión, que el filtro de salida debe atenuar],),
  sol: [El analizador muestra cada componente de la señal en su frecuencia. 14 y 21 MHz son múltiplos enteros de 7 MHz: armónicos que genera la etapa final y que deben quedar muy atenuados. Las bandas laterales de la voz estarían a pocos kilohercios de la portadora, y la reflejada se mide con un vatímetro direccional.], tema: "T8")
#pq(1, 1, 27, "b", "estúdialo en: simulacros de estudio 8·1·28 · libro: T9.14", "Intermodulación: dos o más señales intensas mezcladas en una etapa no lineal",
  [Dos emisoras intensas en 145,1 y 145,3 MHz se mezclan en una etapa no lineal. ¿En qué frecuencias aparecen los productos de intermodulación de tercer orden?],
  ([435,3 y 435,9 MHz], [144,9 y 145,5 MHz], [0,2 y 290,4 MHz], [145,2 MHz],),
  sol: [Los productos de tercer orden son $2 f_1 - f_2$ y $2 f_2 - f_1$: 144,9 y 145,5 MHz, a la misma distancia (200 kHz) a cada lado de las dos señales y dentro de la banda. 0,2 y 290,4 MHz son la diferencia y la suma, productos de segundo orden que caen lejos. 435,3 y 435,9 MHz son los terceros armónicos de cada señal.], tema: "T9")
#pq(1, 1, 28, "c", "estúdialo en: simulacros de estudio 9·1·28 · libro: T9.15", "Desacoplo: ferritas y condensadores en los cables del equipo afectado",
  [¿Por qué una ferrita que abraza el cable de un altavoz frena la RF captada sin afectar al audio?],
  ([porque la ferrita es un condensador que deriva a masa la RF de los dos hilos, pero no la del audio], [porque la ferrita rectifica la RF y la convierte en una continua que el altavoz no reproduce], [porque la RF recorre los dos hilos en el mismo sentido y la ferrita actúa sobre ella como una bobina, mientras que los campos del audio, que va y vuelve, se anulan], [porque la ferrita es una pantalla metálica conectada a tierra que refleja el campo exterior],),
  sol: [La RF captada por el cable viaja en modo común: por los dos hilos a la vez y en el mismo sentido, y para ella la ferrita es una impedancia en serie. El audio va por un hilo y vuelve por el otro (modo diferencial): la corriente neta es cero y la ferrita no actúa. Los condensadores de desacoplo completan el remedio derivando la RF a masa.], tema: "T9")
#pq(1, 1, 29, "d", "estúdialo en: simulacros de estudio 6·1·29 · libro: T10.21", "Umbrales de corriente (1 mA se nota, 10–20 mA no se suelta, ~30 mA fibrilación): cuál es más peligrosa",
  [La intensidad a partir de la cual los músculos se contraen y una persona ya no puede soltar el conductor que agarra es del orden de:],
  ([1 A], [0,1 mA], [1 mA], [10 a 20 mA],),
  sol: [Hacia 1 mA la corriente solo se percibe como un hormigueo; en torno a 10–20 mA los músculos dejan de obedecer y no se puede soltar el conductor; desde unos 30 mA aparece el riesgo de fibrilación ventricular. Por debajo de 1 mA no se nota, y 1 A está muy por encima del umbral de fibrilación.], tema: "T10")
#pq(1, 1, 30, "a", "estúdialo en: simulacros de estudio 4·1·30 · libro: T10.17", "Accidente eléctrico: lo primero es cortar la corriente",
  [Encuentras a una persona inconsciente agarrada a un equipo que sigue conectado a la red. Antes de nada debes:],
  ([cortar la corriente con el interruptor general], [darle de beber para reanimarla], [enfriar con agua la zona de contacto con el equipo], [iniciar enseguida las compresiones torácicas, porque cada minuto cuenta],),
  sol: [Mientras haya tensión, quien toque a la víctima entra en el circuito y se convierte en la segunda víctima: lo primero es cortar la corriente. Solo después se avisa al 112, se comprueba si respira y, si no, se inicia la reanimación. Nunca se le da de beber ni se echa agua mientras haya tensión.], tema: "T10")
#fin-prueba()
#prueba(1, 2)
#pq(1, 2, 1, "a", "estúdialo en: simulacros de estudio 11·2·2 · libro: R1.22", "H Hotel y K Kilo",
  [Un corresponsal deletrea: «Echo Alfa Eight Hotel Kilo». ¿Qué distintivo anotas?],
  ([`EA8HK`], [`EA8HQ`], [`EA8HC`], [`EA8JK`],),
  sol: [Hotel es la H y Kilo es la K; la cifra Eight es el 8. Kilo no es ni la Q (Quebec) ni la C (Charlie), aunque suenen parecido en castellano, y Hotel no es la J, que es Juliett.], tema: "R1")
#pq(1, 2, 2, "d", "estúdialo en: simulacros de estudio 5·2·3, 9·2·1 · libro: R2.9, R2.32", "QRT cese la transmisión frente a QRX espere, volveré a llamar",
  [Al despedirse, un corresponsal dice: «Gracias por el QSO; hago `QRT`, 73». Eso significa que:],
  ([te pide que esperes, porque volverá a llamarte en unos minutos], [va a reducir la potencia de su emisión], [se va a otra frecuencia para seguir allí], [deja de transmitir y cierra la estación],),
  sol: [`QRT` es cesar la transmisión: con él se cierra la estación al final del contacto. Esperar y volver a llamar es `QRX`, cambiar de frecuencia es `QSY` y reducir la potencia es `QRP`.], tema: "R2")
#pq(1, 2, 3, "c", "estúdialo en: simulacros de estudio 7·2·2 · libro: C-R2.2", "QRL: estoy ocupado / ¿está ocupada la frecuencia?",
  [Antes de lanzar CQ en CW transmites «`QRL?`» y alguien te contesta «`QRL`». ¿Qué debes hacer?],
  ([lanzar la llamada, porque te han confirmado que la frecuencia está libre], [dar tu distintivo, porque te preguntan quién eres], [no llamar en esa frecuencia y buscar otra libre], [repetir tu último mensaje],),
  sol: [`QRL?` pregunta si la frecuencia está ocupada y la respuesta `QRL` dice que sí lo está: hay que buscar otra. Quien no contesta deja la frecuencia por libre; «¿quién me llama?» es `QRZ` y repetir el último mensaje es `QSM`.], tema: "R2")
#pq(1, 2, 4, "a", "estúdialo en: simulacros de estudio 11·2·4 · libro: F-R2.4", "QSZ transmita cada palabra o grupo dos veces",
  [Con mucho QRN, para no perder ninguna palabra, pides a tu corresponsal que transmita cada palabra o grupo dos veces. Usas:],
  ([`QSZ`], [`QSM`], [`QRS`], [`QSV`],),
  sol: [`QSZ` pide transmitir cada palabra o grupo dos veces (o las que se indiquen). `QSM` repite el último mensaje ya enviado, `QSV` pide una serie de V y `QRS`, transmitir más despacio.], tema: "R2")
#pq(1, 2, 5, "b", "estúdialo en: simulacros de estudio 6·2·5 · libro: R3.13", "K invitación a transmitir («cambio»)",
  [EA1ABC termina su turno con «… EA4XYZ DE EA1ABC K». Con esa `K` final, EA1ABC:],
  ([anuncia que apaga su estación], [te invita a transmitir: ahora es tu turno], [te pide que repitas lo último que enviaste], [da por terminado el contacto],),
  sol: [`K` es el «cambio» de la telegrafía: he terminado, transmita usted. Dar por terminado el contacto sería `SK` y apagar la estación, `CL`; para pedir repetición se usa `RPT` o `AGN`.], tema: "R3")
#pq(1, 2, 6, "d", "estúdialo en: simulacros de estudio 2·2·7 · libro: R3.28", "HR aquí y ES y",
  [En la frase «`WX HR SUNNY ES COLD`», las abreviaturas `HR` y `ES` significan:],
  ([«he recibido» y «eso es»], [«hora» y «España»], [«hora» y la conjunción «y»], [«aquí» y la conjunción «y»],),
  sol: [`HR` (\_here\_) es «aquí» y `ES` es la conjunción «y»: «el tiempo aquí es soleado y frío». Leerlas en castellano («hora», «España») es la trampa típica de estas dos abreviaturas.], tema: "R3")
#pq(1, 2, 7, "c", "estúdialo en: simulacros de estudio 9·2·6 · libro: R3.36", "HI risa en telegrafía",
  [En telegrafía quieres indicar que lo que acabas de decir es una broma, con una risa. ¿Qué transmites?],
  ([`FB`], [`HR`], [`HI`], [`88`],),
  sol: [`HI` es la risa en telegrafía. `HR` empieza por la misma letra, pero significa «aquí»; `FB` es un elogio y `88`, besos.], tema: "R3")
#pq(1, 2, 8, "d", "estúdialo en: simulacros de estudio 2·2·8 · libro: C-R4.2", "SOS se transmite como un solo signo (sin separar las letras)",
  [¿Cómo se transmite en Morse la señal de socorro?],
  ([tres rayas, tres puntos y tres rayas, con la pausa normal entre letras], [tres puntos, tres rayas y tres puntos, con la pausa normal entre letras], [tres rayas, tres puntos y tres rayas seguidos, sin pausa], [tres puntos, tres rayas y tres puntos seguidos, sin pausa entre letras],),
  sol: [`SOS` son tres puntos, tres rayas y tres puntos enviados como un solo signo, sin los espacios que separarían las letras. Separarlas, como en la opción con pausas, es la clave que daban algunas recopilaciones antiguas, pero el libro, siguiendo la norma internacional, la da por incorrecta. Las opciones que empiezan por rayas invierten la S y la O.], tema: "R4")
#pq(1, 2, 9, "b", "estúdialo en: simulacros de estudio 9·2·8 · libro: F-R4.2", "Colaboración obligatoria en catástrofes a requerimiento de la DG de Protección Civil y Emergencias (art. 30.4)",
  [Según el art. 30.4 de la Orden IET/1311/2013, cuando la Dirección General de Protección Civil y Emergencias lo requiere en una catástrofe, el titular de una autorización debe colaborar:],
  ([solo si lo desea, pues la colaboración es voluntaria], [con sus medios radioeléctricos y en las bandas atribuidas al servicio de radioaficionados], [solo si pertenece a una asociación de radioaficionados], [con sus medios radioeléctricos, en la frecuencia que elija],),
  sol: [El art. 30.4 obliga a todo titular a colaborar, cuando lo requiere esa Dirección General, con sus medios radioeléctricos y en las bandas atribuidas al servicio de radioaficionados. No le habilita para usar cualquier frecuencia, no depende de ser socio de nada y, una vez hecho el requerimiento, deja de ser voluntaria.], tema: "R4")
#pq(1, 2, 10, "c", "estúdialo en: simulacros de estudio 11·2·11 · libro: F-R4.11", "Aficionados por satélite: solo en las bandas atribuidas al efecto en el CNAF",
  [Quieres operar a través de un satélite de aficionado en la banda de 80 m. Según la Orden IET/1311/2013:],
  ([puedes hacerlo, pero con autorización especial], [puedes hacerlo, porque toda banda de aficionado admite el servicio por satélite], [no puedes: las emisiones por satélite se restringen a las bandas atribuidas al efecto en el CNAF, y 80 m no lo está], [no puedes: el servicio por satélite solo existe en microondas],),
  sol: [El art. 5.3 de la Orden restringe las emisiones del servicio de aficionados por satélite a las bandas atribuidas al efecto en el CNAF. La banda de 80 m no lo está, aunque sí tramos de HF como 7000–7100 o 14000–14250 kHz, así que tampoco es cosa solo de microondas. La autorización especial es otro asunto.], tema: "R4")
#pq(1, 2, 11, "a", "estúdialo en: simulacros de estudio 7·2·11 · libro: R5.13", "Sufijo: hasta tres letras, por orden alfabético y turno riguroso de expedición",
  [Dos personas obtienen la autorización en el mismo distrito, una detrás de otra. Si a la primera se le asignó el sufijo KLM, a la siguiente se le asignará normalmente:],
  ([KLN], [KLL], [un sufijo elegido por ella entre los que estén libres], [un sufijo formado con sus iniciales],),
  sol: [Los sufijos se asignan por orden alfabético y riguroso turno de expedición, de modo que al siguiente le corresponde la combinación que sigue a KLM. No se eligen ni se forman con las iniciales, y KLL va antes, no después.], tema: "R5")
#pq(1, 2, 12, "c", "estúdialo en: simulacros de estudio 10·2·13", "Prefijos AM y AN: eventos relevantes de ámbito nacional",
  [Escuchas la estación AN4ABC. ¿Qué puedes deducir?],
  ([Que es un radioaficionado español emitiendo desde una zona no adscrita a soberanías nacionales], [Que conserva la cifra y el sufijo de su distintivo permanente, como en los eventos ordinarios], [Que emite con un distintivo temporal por un evento relevante de ámbito nacional], [Que es una estación automática desatendida del distrito 4],),
  sol: [AM y AN son los prefijos temporales de los eventos relevantes de ámbito nacional, y llevan sufijo propio. Las zonas no adscritas a soberanías corresponden a AO; conservar cifra y sufijo es lo propio de ED, EE y EF; y las desatendidas usan ED.], tema: "R5")
#pq(1, 2, 13, "b", "estúdialo en: simulacros de estudio 2·2·13 · libro: R5.38", "Prefijo AO: eventos relevantes de ámbito internacional",
  [Para un congreso mundial celebrado en Valencia, evento relevante de ámbito internacional, el prefijo temporal que corresponde es:],
  ([AM], [AO], [EF], [ED],),
  sol: [AO se reserva a los eventos relevantes de ámbito internacional, en la cúspide de la escala de prefijos temporales. AM es para los relevantes de ámbito nacional, y ED o EF, para los eventos ordinarios.], tema: "R5")
#pq(1, 2, 14, "d", "estúdialo en: simulacros de estudio 10·2·15 · libro: R6.6", "Frecuencias de llamada: punto de encuentro de un modo, no de uso exclusivo",
  [Contactas con otra estación en la frecuencia de llamada de FM de 2 m. Lo correcto es:],
  ([quedarse en ella todo el QSO, porque la ocupasteis primero], [quedarse en ella, porque las frecuencias de llamada son de uso exclusivo de quien llama], [pedir a la Administración que reserve esa frecuencia para vuestros contactos], [pasar a otra frecuencia libre para el QSO y dejar libre la de llamada],),
  sol: [Una frecuencia de llamada es un punto de encuentro de los operadores de un modo, no de uso exclusivo: se llama allí y, al contestar, se pasa (QSY) a otra libre. Ocuparla con el QSO impide que otros la usen para lo que está prevista.], tema: "R6")
#pq(1, 2, 15, "a", "estúdialo en: simulacros de estudio 1·2·15 · libro: F-R6.9", "Frecuencia de llamada de FM en 2 m: 145,500 MHz",
  [En el plan de bandas de la IARU para la Región 1, la frecuencia de 145,500 MHz es:],
  ([la frecuencia de llamada de FM de la banda de 2 m], [la entrada del primer canal de repetidores de 2 m], [el comienzo del segmento de satélites de 2 m], [el centro de actividad de SSB de la banda de 2 m],),
  sol: [El plan de 2 m marca 145,500 MHz como frecuencia de llamada de FM, en el segmento de FM y voz digital. El centro de actividad de SSB está en 144,300 MHz, las entradas de repetidores empiezan en torno a 145,000 MHz y los satélites ocupan el final de la banda.], tema: "R6")
#pq(1, 2, 16, "d", "estúdialo en: simulacros de estudio 4·2·16 · libro: R7.5", "Prohibidos fines comerciales, publicitarios o lucrativos; permitidos mensajes técnicos sobre ensayos",
  [Un radioaficionado que tiene una tienda de equipos aprovecha sus QSO para anunciar ofertas. Esta conducta:],
  ([está permitida, porque solo anuncia material de radio], [está permitida fuera de los concursos], [está permitida si se identifica al comienzo y al final del anuncio], [está prohibida y puede ser causa de revocación de la autorización, por tener fines comerciales o lucrativos],),
  sol: [Las emisiones con fines comerciales, publicitarios o lucrativos están prohibidas y son causa de revocación (art. 8.1.b de la Orden). Que el producto sea de radio no cambia su finalidad lucrativa; lo que sí se admite son los mensajes técnicos sobre ensayos.], tema: "R7")
#pq(1, 2, 17, "b", "estúdialo en: simulacros de estudio 6·2·18 · libro: F-R8.12", "Uso del espectro por radioaficionados: uso especial, con autorización individual; explotación compartida sin exclusión de terceros",
  [Un radioaficionado pide que se le reserve en exclusiva una frecuencia de la banda de 2 m para su red local. No es posible porque el uso del espectro por los radioaficionados es:],
  ([un uso privativo, que solo se concede en exclusiva a las asociaciones de radioaficionados], [un uso especial: bandas de explotación compartida, sin limitación del número de usuarios, ejercido mediante autorización individual], [un uso reservado al Estado, que solo cede frecuencias concretas a Protección Civil], [un uso común, que no necesita ningún título habilitante y, por tanto, no admite reservas],),
  sol: [El uso de los radioaficionados es especial: las bandas se explotan de forma compartida, sin exclusión de terceros, y cada aficionado actúa con una autorización individual. La exclusividad es lo propio del uso privativo, que no es el caso. Tampoco es uso común, porque sí hace falta título habilitante: la autorización de radioaficionado.], tema: "R8")
#pq(1, 2, 18, "a", "estúdialo en: simulacros de estudio 10·2·18 · libro: R8.38", "Ganancia del sistema radiante de las desatendidas: ≤ 6 dBd",
  [La antena de un repetidor de 2 m tiene una ganancia de 9 dBi. ¿Cumple la norma general de ganancia del sistema radiante de las desatendidas de VHF y UHF?],
  ([No: 9 dBi son unos 6,85 dBd, por encima del máximo de 6 dBd], [Sí: el límite de 6 dBd equivale a 9 dBi], [Sí: el límite de ganancia solo se aplica a las desatendidas de HF], [No: el máximo es de 3 dBd],),
  sol: [El límite es de 6 dBd, referido al dipolo de media onda, que equivalen a unos 8,15 dBi. Para comparar, se pasa la ganancia a dBd restando 2,15 dB: 9 − 2,15 = 6,85 dBd, que supera los 6 dBd. El error típico es tratar los 6 dB como si fueran isótropos o sumar una cifra equivocada al convertir.], tema: "R8")
#pq(1, 2, 19, "c", "estúdialo en: simulacros de estudio 6·2·20 · libro: F-R8.67", "Interferencia persistente: la SETSI puede restringir bandas, potencia u horario",
  [Un repetidor sigue causando interferencia perjudicial a otro servicio autorizado a pesar de las medidas técnicas adoptadas. ¿Cuál de estas medidas puede imponer excepcionalmente la SETSI según el artículo 32?],
  ([cambiar el distintivo de llamada del repetidor], [trasladar el repetidor a otro emplazamiento], [limitar el horario de sus emisiones], [obligarle a pasar de modulación analógica a digital],),
  sol: [El art. 32, al que remite el art. 26 para las desatendidas, prevé que, si la interferencia persiste tras las medidas técnicas, la SETSI imponga con carácter excepcional restricciones de bandas de frecuencias, potencia u horario. Limitar el horario es una de ellas. El traslado, el cambio de distintivo o de modulación no figuran entre esas restricciones.], tema: "R8")
#pq(1, 2, 20, "a", "estúdialo en: simulacros de estudio 3·2·17, 7·2·19 · libro: C-R8.8, C-T7.3", "Nomenclatura de bandas: números, símbolos (HF, VHF, SHF…), rangos y ondas (métricas, B.m.…)",
  [La banda de aficionado de 137 kHz (2200 m) se encuentra, según la nomenclatura de bandas, en la de:],
  ([LF, ondas kilométricas (B.km)], [MF, ondas hectométricas (B.hm)], [VLF, ondas miriamétricas (B.Mam)], [HF, ondas decamétricas (B.dam)],),
  sol: [137 kHz está entre 30 y 300 kHz, que es la banda LF (número 5), de ondas kilométricas, con abreviatura B.km: su longitud de onda, unos 2200 m, se mide en kilómetros. La MF (ondas hectométricas) empieza en 300 kHz y la VLF (miriamétricas) acaba en 30 kHz. La HF va de 3 a 30 MHz.], tema: "R8")
#pq(1, 2, 21, "c", "estúdialo en: simulacros de estudio 6·2·22 · libro: R8.10", "RD 2623/1986: reglamento de las instalaciones de antenas de aficionado",
  [¿Qué norma fija las condiciones técnicas concretas de las antenas de aficionado instaladas en el exterior de los inmuebles, como la altura libre sobre el plano de paso o la separación de los cables respecto de otras canalizaciones?],
  ([El anexo I de la Orden IET/1311/2013], [La Ley 19/1983, directamente en su articulado], [El Real Decreto 2623/1986, que desarrolla la Ley 19/1983], [El Real Decreto 123/2017],),
  sol: [Esas reglas (3 m libres sobre el plano de paso, 10 cm de separación de las canalizaciones, soportes, anclajes) son del Real Decreto 2623/1986, el reglamento de las instalaciones de antenas de aficionado. La Ley 19/1983 reconoce el derecho, pero deja el detalle técnico al reglamento. El anexo I de la Orden trata de las características de las emisiones, no de la instalación mecánica de la antena.], tema: "R8")
#pq(1, 2, 22, "b", "estúdialo en: simulacros de estudio 2·2·17 · libro: F-R8.93", "Modulaciones permitidas: dentro de las bandas y con anchos de banda del plan IARU Región 1",
  [Quieres probar en 2 m una modulación digital nueva que el anexo I no cita expresamente. Según su apartado 3.1:],
  ([puedes, siempre que emitas con menos de 10 W], [puedes, si la emisión queda dentro de las bandas autorizadas y con un ancho de banda acorde, como norma general, con el plan de bandas de la IARU Región 1], [necesitas una autorización expresa de la SETSI para cada nuevo modo de emisión], [no puedes: solo se permiten las modulaciones de amplitud, frecuencia y fase],),
  sol: [El apartado 3.1 autoriza la modulación de amplitud, la de frecuencia, la de fase y otras modulaciones digitales, con la condición de que la emisión se ajuste a las bandas autorizadas y tenga un ancho de banda acorde, como norma general, con el plan de bandas de la IARU para la Región 1. No pide autorización por modo ni limita los modos digitales a una lista cerrada. La potencia no forma parte de esa condición.], tema: "R8")
#pq(1, 2, 23, "d", "estúdialo en: simulacros de estudio 2·2·18 · libro: F-R8.94", "Modulaciones digitales autorizadas: con señales de audio, datos o vídeo",
  [Un radioaficionado quiere transmitir televisión digital en una banda de aficionado, respetando la banda y el ancho de banda. Según el apartado 3.1 del anexo I, las modulaciones digitales:],
  ([solo pueden transportar datos], [pueden transportar audio y datos, pero el vídeo ha de ser analógico], [pueden transportar vídeo solo con una autorización especial del artículo 16], [pueden transportar vídeo, igual que audio o datos],),
  sol: [El apartado 3.1 autoriza otros tipos de modulaciones digitales con señales de audio, datos o vídeo, sin distinguir por el contenido. La condición es que la emisión quede dentro de las bandas autorizadas y con el ancho de banda adecuado. Las autorizaciones del art. 16 se refieren a bandas secundarias con riesgo de interferencia, no al tipo de señal.], tema: "R8")
#pq(1, 2, 24, "c", "estúdialo en: simulacros de estudio 1·2·19 · libro: C-R8.32", "Licencia CEPT: habilita temporalmente en los países T/R 61-01; no se concede «a través del HAREC»",
  [Antes de viajar a un país que aplica la T/R 61-01, quieres saber dónde conseguir tu licencia CEPT. ¿Quién la expide?],
  ([la CEPT, directamente, a petición del interesado], [nadie: se obtiene automáticamente con el certificado HAREC, sin necesidad de autorización], [la Administración española: la propia autorización española de radioaficionado tiene la consideración de licencia CEPT], [la Administración del país visitado, a su llegada],),
  sol: [Según el art. 11 de la Orden, la licencia CEPT es la expedida por un país que ha adoptado la T/R 61-01, y la autorización española de radioaficionado tiene esa consideración. No la expide el país visitado ni la CEPT. El HAREC, de la T/R 61-02, solo acredita el examen y permite solicitar la autorización: no es una licencia.], tema: "R8")
#pq(1, 2, 25, "b", "estúdialo en: simulacros de estudio 9·2·24 · libro: R8.70", "Uso de una estación ajena: con permiso del titular, identificándose con el distintivo propio",
  [Juan, titular de la estación EA1XXX, invita a su amiga Ana, titular del distintivo EA4YYY, a operar en su estación fija. Según el criterio del banco de examen, Ana:],
  ([debe pedir antes a la Jefatura Provincial un distintivo temporal], [puede emitir con el permiso de Juan, identificándose con su propio distintivo, EA4YYY], [puede emitir identificándose con el distintivo EA1XXX, porque la estación es de Juan], [no puede emitir: una estación solo puede usarla su titular],),
  sol: [El distintivo identifica a su titular, es decir, al operador, no al equipo: Ana se identifica con el suyo. Lo que necesita es el consentimiento de Juan, que responde de su estación. Usar el distintivo de otro es precisamente lo que no se permite.], tema: "R8")
#pq(1, 2, 26, "b", "estúdialo en: simulacros de estudio 1·2·23 · libro: C-R8.41", "Estación fija: precisa licencia, asociada a la autorización de radioaficionado de su titular",
  [Fallece el titular de una estación fija de aficionado. Como la licencia de estación está asociada a su autorización, esa licencia:],
  ([pasa a sus herederos junto con los equipos], [se cancela, porque la autorización a la que está asociada se extingue con el fallecimiento], [sigue vigente hasta que venza el seguro de antenas], [pasa a la asociación de radioaficionados de la provincia],),
  sol: [La licencia de estación fija se considera asociada a la autorización de radioaficionado de su titular (art. 18.1), y se cancela por revocación o extinción de esa autorización (art. 21.1.b). El fallecimiento extingue automáticamente la autorización, y con ella cae la licencia. Ni la autorización ni la licencia se transmiten a herederos ni a asociaciones.], tema: "R8")
#pq(1, 2, 27, "d", "estúdialo en: simulacros de estudio 7·2·26 · libro: C-R8.18", "Condiciones de instalación: sin molestias ni peligro, señalizar anclajes y riostras, materiales resistentes, respetar otras antenas, no dañar la obra",
  [¿Cuál de estas prácticas de instalación de una antena de aficionado incumple el Real Decreto 2623/1986?],
  ([Emplear riostras de material tratado contra la corrosión], [Dimensionar los soportes para los esfuerzos de viento previsibles en el lugar], [Señalizar los anclajes de las riostras en una azotea transitable], [Situarla tan cerca de la antena colectiva de televisión que degrade su funcionamiento],),
  sol: [La instalación debe respetar las separaciones con los elementos, instalaciones y antenas de otros servicios para que no resulten degradados: perjudicar a la antena colectiva lo incumple. Las otras tres son exigencias del propio Reglamento: señalizar anclajes y riostras en lugares transitables, materiales resistentes a la corrosión o tratados, y elementos capaces de absorber los esfuerzos de uso.], tema: "R8")
#pq(1, 2, 28, "a", "estúdialo en: simulacros de estudio 8·2·26 · libro: F-R8.71", "Noveles: potencia ≤ 40 % del máximo de la banda y nunca más de 100 W",
  [Un grupo de noveles usa, con fines de divulgación y bajo supervisión, la estación colectiva de una asociación en la banda de 137 kHz (2200 m), cuyo máximo en la tabla del anexo I es de 1 W p.i.r.e. Según el artículo 30.6.d, su potencia no podrá superar:],
  ([0,4 W p.i.r.e.], [0,6 W p.i.r.e.], [1 W p.i.r.e.], [100 W p.i.r.e.],),
  sol: [El art. 30.6.d limita a los noveles al 40 % del máximo de la banda y, en todo caso, a 100 W (p.i.r.e.): manda el menor de los dos límites. En 137 kHz, $0","40 times 1 = 0","4$ W p.i.r.e., muy por debajo del tope de 100 W, que aquí no actúa. Los 0,6 W salen de rebajar un 40 % en vez de quedarse en el 40 %, y 1 W olvida la reducción.], tema: "R8")
#pq(1, 2, 29, "c", "estúdialo en: simulacros de estudio 2·2·29 · libro: R9.9", "Leve: no facilitar los datos requeridos o retrasarlos",
  [No facilitar los datos que requiere la Administración es infracción leve. Según la Ley 11/2022, pasa a ser grave cuando:],
  ([el titular se retrasa un solo día sobre el plazo fijado], [el titular tiene más de una estación autorizada], [ha transcurrido un mes desde el fin del plazo del requerimiento o ha finalizado el plazo del segundo requerimiento], [los datos se refieren a la potencia de la estación],),
  sol: [Como regla, no facilitar los datos o retrasar injustificadamente su aportación es leve (art. 108.12). Pasa a grave al exceder los plazos: un mes después del fin del plazo del requerimiento, o al terminar el plazo del segundo requerimiento (art. 107.34). Un simple retraso de un día es justo el caso leve, no el grave.], tema: "R9")
#pq(1, 2, 30, "a", "estúdialo en: simulacros de estudio 3·2·30 · libro: R9.21", "Titular que sabe que interfiere: medidas técnicas razonables a su costa, sin esperar requerimiento",
  [Al revisar tu estación descubres que tu transmisor de HF emite un armónico que cae en la banda de un servicio autorizado y le causa interferencias. Nadie se ha quejado todavía. Debes:],
  ([adoptar ya, a tu costa, las medidas técnicas razonables para eliminarlo, como un filtro paso bajo], [corregirlo, pero a costa del servicio interferido, que es quien se beneficia de la corrección], [seguir emitiendo igual mientras nadie se queje ni la Administración te lo requiera], [dejar de emitir definitivamente y renunciar a la autorización],),
  sol: [La obligación nace en cuanto tienes constancia de que interfieres, sin esperar quejas ni requerimientos, y el coste corre por tu cuenta, porque eres quien explota la estación. Un armónico es una emisión no esencial de tu transmisor, así que el remedio está en tu lado, por ejemplo con un filtro paso bajo a la salida. No hace falta renunciar a la autorización: corregida la causa, puedes seguir emitiendo.], tema: "R9")
#fin-prueba()
#soluciones-simulacro(1)

// ======================================================================
#simulacro(2)
#prueba(2, 1)
#pq(2, 1, 1, "a", "estúdialo en: simulacros de estudio 6·1·1, 10·1·1 · libro: T1.6, C-T1.5", "Ley de Ohm: hallar V, I o R",
  [Se aplican 9 V a una resistencia de 4,5 kΩ. La corriente que circula por ella es de:],
  ([2 mA], [40,5 mA], [0,5 mA], [2 A],),
  sol: [$I = V slash R = 9 slash 4500 = 0","002$ A = 2 mA. Los 2 A olvidan el prefijo kilo; los 0,5 mA dividen la resistencia entre la tensión, y 40,5 resulta de multiplicar en lugar de dividir.], tema: "T1")
#pq(2, 1, 2, "b", "estúdialo en: simulacros de estudio 1·1·2, 8·1·1 · libro: T1.8, T1.9", "Potencia eléctrica: P = V I = I² R = V² / R",
  [Una lámpara de 12 V y 24 W, encendida a su tensión nominal, presenta una resistencia de:],
  ([288 Ω], [6 Ω], [2 Ω], [0,5 Ω],),
  sol: [De $P = V^2 slash R$ se despeja $R = V^2 slash P = 144 slash 24 = 6$ Ω. Comprobación: la corriente es $I = P slash V = 2$ A y $12 slash 2 = 6$ Ω. Los 2 Ω confunden la corriente con la resistencia; 0,5 Ω y 288 Ω salen de dividir o multiplicar sin más la tensión y la potencia.], tema: "T1")
#pq(2, 1, 3, "c", "estúdialo en: simulacros de estudio 12·1·2 · libro: C-T1.11", "Fuerza electromotriz: caracteriza al generador y se mide en voltios",
  [Un voltímetro de resistencia interna muy alta, conectado a los bornes de una batería sin ninguna carga conectada, indica directamente su:],
  ([capacidad en amperios-hora], [corriente de cortocircuito], [fuerza electromotriz], [resistencia interna],),
  sol: [En circuito abierto no circula corriente, no cae tensión en la resistencia interna y en bornes aparece la fem completa, que se mide en voltios como cualquier tensión. La resistencia interna se expresa en ohmios, la corriente de cortocircuito en amperios y la capacidad en amperios-hora: ninguna la da un voltímetro.], tema: "T1")
#pq(2, 1, 4, "a", "estúdialo en: simulacros de estudio 2·1·2 · libro: F-T1.17", "Regla de Carson: B ≈ 2 (Δf + f_m)",
  [Según la regla de Carson, una emisión de FM modulada con un tono de 2 kHz ocupa 12 kHz. Su desviación máxima es de:],
  ([4 kHz], [10 kHz], [6 kHz], [5 kHz],),
  sol: [De $B approx 2 (Delta f + f_m)$: $12 = 2 (Delta f + 2)$, luego $Delta f + 2 = 6$ y $Delta f = 4$ kHz. Los 6 kHz olvidan restar la moduladora; los 10 kHz la restan pero olvidan el factor 2, y los 5 kHz restan la moduladora antes de dividir entre 2.], tema: "T1")
#pq(2, 1, 5, "d", "estúdialo en: simulacros de estudio 11·1·5 · libro: T2.38", "Varistor (VDR): su resistencia depende de la tensión aplicada; protege contra sobretensiones",
  [Para proteger un equipo contra los picos de tensión de la red se emplea un varistor. ¿Cómo se conecta y qué hace ante un pico?],
  ([en serie con la entrada de red; al calentarse su resistencia aumenta y corta la corriente], [en serie con la entrada de red; su resistencia aumenta con la tensión y bloquea el pico], [en paralelo con la entrada de red; al recibir luz pasa a conducir], [en paralelo con la entrada de red; al superar su umbral su resistencia se desploma y recorta el pico],),
  sol: [El varistor (VDR) es casi un aislante a la tensión normal y casi un cortocircuito por encima de su umbral: en paralelo con la entrada, deriva el pico antes de que llegue al equipo. Su resistencia baja con la tensión, no sube. La reacción al calor es propia del termistor y la de la luz, de la LDR.], tema: "T2")
#pq(2, 1, 6, "c", "estúdialo en: simulacros de estudio 10·1·6 · libro: T2.41", "El condensador se opone a las variaciones de tensión; la bobina, a las de corriente",
  [Al cortar bruscamente la corriente que circula por la bobina de un relé aparece entre sus terminales una sobretensión. Se debe a que la bobina:],
  ([rectifica la corriente al interrumpirse], [se opone a las variaciones de la tensión entre sus terminales], [se opone a las variaciones de la corriente que la recorre], [almacena carga eléctrica entre sus espiras],),
  sol: [La bobina responde a los cambios de corriente con una fem opuesta, $e = -L (dif i) / (dif t)$: si la corriente se corta de golpe, la fem es muy grande. Oponerse a las variaciones de tensión es lo propio del condensador, su dual, y almacenar carga también es cosa del condensador.], tema: "T2")
#pq(2, 1, 7, "b", "estúdialo en: simulacros de estudio 7·1·8, 13·1·8 · libro: T2.22, F-T2.14", "Diodo zéner: estabiliza tensión trabajando en inversa, en la zona de ruptura",
  [En un estabilizador con diodo zéner y resistencia en serie, la tensión de entrada sube de 12 V a 14 V. ¿Qué ocurre con la tensión en la carga?],
  ([sube también 2 V, porque el zéner no puede absorber variaciones], [casi no cambia: el exceso cae en la resistencia en serie y el zéner conduce más corriente], [se anula, porque el zéner deja de conducir], [baja, porque el zéner pasa a conducir en directa],),
  sol: [Trabajando en inversa en su zona de ruptura, el zéner conduce tanto como haga falta para no pasar de su tensión nominal. Si la entrada sube, sube la corriente por la resistencia y ese exceso se lo traga el zéner; la salida apenas varía. Esa es precisamente la estabilización.], tema: "T2")
#pq(2, 1, 8, "a", "estúdialo en: simulacros de estudio 4·1·8, 10·1·9 · libro: T2.23, T2.24", "Transistor bipolar: terminales emisor, base y colector; tipos NPN y PNP",
  [En el símbolo de un transistor bipolar, la flecha del emisor apunta hacia fuera. Se trata de un transistor:],
  ([NPN], [FET de canal N], [MOSFET de canal P], [PNP],),
  sol: [La flecha del emisor marca el sentido de la corriente convencional: sale en el NPN y entra en el PNP («PNP: PiNcha»). Un símbolo con flecha en el emisor es siempre de un bipolar; en el FET la flecha está en la puerta o en el canal.], tema: "T2")
#pq(2, 1, 9, "c", "estúdialo en: simulacros de estudio 4·1·9 · libro: C-T2.22", "Símbolos de resistencia, condensador, bobina y diodo",
  [En un esquema, un componente se dibuja como un triángulo apoyado contra una barra transversal. ¿Qué componente es y qué indica la barra?],
  ([un condensador; la barra es la armadura negativa], [un diodo; la barra marca el ánodo], [un diodo; la barra marca el cátodo], [un transistor; la barra es la base],),
  sol: [El triángulo contra una barra es el diodo: el triángulo apunta en el sentido de paso de la corriente, de ánodo a cátodo, y la barra es el cátodo (la franja pintada en el cuerpo). El condensador se dibuja con dos trazos paralelos y el bipolar con una base recta y una flecha en el emisor.], tema: "T2")
#pq(2, 1, 10, "d", "estúdialo en: simulacros de estudio 11·1·9 · libro: C-T3.5", "Acoplo entre circuitos y etapas: las oscilaciones de uno pasan al otro; el acoplamiento deja pasar la señal y separa las polarizaciones",
  [Entre el colector de una etapa amplificadora de transistor y la base de la siguiente hay un condensador de acoplamiento. Si se sustituyera por un hilo directo:],
  ([la señal alterna dejaría de pasar a la segunda etapa], [la segunda etapa solo recibiría la componente continua, sin la señal], [las dos etapas quedarían desacopladas y cada una conservaría su polarización], [la tensión continua del colector de la primera etapa llegaría a la base de la segunda y alteraría su polarización],),
  sol: [El condensador de acoplo deja pasar la señal y bloquea la continua, de modo que cada etapa conserva su propia polarización. Con un hilo directo la señal sigue pasando, pero también la continua del colector, que desplaza el punto de trabajo de la segunda etapa. Lo que se pierde es la independencia de las polarizaciones, no el paso de la señal.], tema: "T3")
#pq(2, 1, 11, "b", "estúdialo en: simulacros de estudio 1·1·11 · libro: C-T3.1", "Factor de calidad Q: mide la selectividad; Q = f0/B",
  [Dos circuitos resonantes sintonizados a la misma frecuencia tienen factores de calidad de 50 y de 200. Comparado con el primero, el segundo:],
  ([tiene el mismo ancho de banda, porque este solo depende de la frecuencia de resonancia], [es más selectivo, porque su ancho de banda es la cuarta parte], [tiene un ancho de banda cuatro veces mayor y por eso rechaza mejor las frecuencias vecinas], [es menos selectivo, porque un $Q$ mayor ensancha la curva de respuesta],),
  sol: [Como $Q = f_0 slash B$, a igual frecuencia un $Q$ cuatro veces mayor implica un ancho de banda cuatro veces menor: curva más estrecha y mejor selección de la frecuencia deseada frente a las demás. Pensar que un $Q$ alto ensancha la curva es invertir la relación; y un ancho de banda mayor nunca rechaza mejor las frecuencias vecinas.], tema: "T3")
#pq(2, 1, 12, "c", "estúdialo en: simulacros de estudio 4·1·13 · libro: F-T3.10", "Fuente conmutada: genera ruido de RF (QRM en HF); exige filtrado y apantallado",
  [Al alimentar el transceptor con una fuente conmutada barata se oyen en HF unos «pajaritos» repartidos por toda la banda, que desaparecen al alimentarlo con una batería. La causa más probable y su remedio son:],
  ([la menor tensión de la batería; se combate subiendo la tensión de la fuente], [la deriva térmica del oscilador del transceptor; se combate dejándolo calentar], [el ruido de conmutación de la fuente; se combate con filtros, ferritas y apantallamiento], [el rizado de 100 Hz de la fuente; se combate con un condensador de filtro mayor],),
  sol: [Los flancos bruscos de la conmutación son ricos en armónicos que caen en HF, y una conmutada mal filtrada se oye como una serie de «pajaritos» repartidos por la banda. Se combate con filtros en la entrada y la salida, ferritas y apantallado. Que desaparezcan con la batería señala a la fuente, y un rizado de 100 Hz se oiría como un zumbido, no como portadoras repartidas por la banda.], tema: "T3")
#pq(2, 1, 13, "b", "estúdialo en: simulacros de estudio 6·1·12 · libro: T3.37", "Base común: amplifica tensión, pero no corriente",
  [En un amplificador de transistor la señal entra por el emisor y sale por el colector, con la base a masa para la señal. La ganancia de corriente de este montaje es:],
  ([elevada, igual a $beta$], [algo menor que la unidad], [nula, porque la base está a masa], [elevada, igual a $beta + 1$],),
  sol: [Es el montaje en base común. La corriente que entra por el emisor sale casi entera por el colector, así que la ganancia de corriente es algo menor que 1: el montaje no amplifica corriente. Sí amplifica tensión, porque la impedancia de salida es mucho mayor que la de entrada. La ganancia $beta$ es la del emisor común y $beta + 1$ la del colector común.], tema: "T3")
#pq(2, 1, 14, "d", "estúdialo en: simulacros de estudio 5·1·11 · libro: T3.24", "Clase C: solo para emisiones de amplitud constante (CW, FM), nunca SSB ni AM",
  [De estas emisiones, la que puede amplificarse con un paso final de clase C sin estropearla es:],
  ([cualquiera, siempre que se reduzca la excitación], [SSB], [AM], [FM],),
  sol: [La clase C destroza la envolvente de la señal: solo sirve para emisiones de amplitud constante, como la FM o la CW, en las que la información no va en la amplitud. En AM y SSB la información viaja en la amplitud y se perdería, sea cual sea la excitación; por eso los lineales de SSB son de clase AB.], tema: "T3")
#pq(2, 1, 15, "a", "estúdialo en: simulacros de estudio 13·1·16 · libro: T4.4", "Relación entre señal, oscilador local y FI: OL por encima f_s = f_OL − f_FI; OL por debajo f_s = f_OL + f_FI",
  [Un receptor con FI de 10,7 MHz y el oscilador local por debajo de la señal está sintonizado en 145,500 MHz. El oscilador local trabaja en:],
  ([134,8 MHz], [124,1 MHz], [156,2 MHz], [166,9 MHz],),
  sol: [Con el oscilador por debajo, $f_s = f_"OL" + f_"FI"$, así que $f_"OL" = 145","5 - 10","7 = 134","8$ MHz. Los 156,2 MHz serían el oscilador por encima ($145","5 + 10","7$). Los 124,1 MHz son la frecuencia imagen en este caso ($134","8 - 10","7$), y los 166,9 MHz, la imagen si el oscilador fuera por encima.], tema: "T4")
#pq(2, 1, 16, "b", "estúdialo en: simulacros de estudio 11·1·15 · libro: T4.22", "Mando RF GAIN: ganancia de las etapas de RF del receptor (no la potencia del emisor)",
  [Durante un concurso, las señales muy fuertes de la banda saturan la entrada de tu receptor. El mando que conviene reducir es:],
  ([AF GAIN (volumen)], [RF GAIN], [el RIT], [la potencia de salida del transmisor],),
  sol: [RF GAIN reduce la ganancia de las primeras etapas, que son las que se saturan con las señales fuertes. El volumen actúa al final de la cadena, cuando la saturación ya se ha producido. La potencia del transmisor no tiene nada que ver con lo que recibes.], tema: "T4")
#pq(2, 1, 17, "a", "estúdialo en: simulacros de estudio 8·1·16 · libro: T5.11", "Multiplicador de frecuencia: eleva la frecuencia del oscilador; en cascada, los factores se multiplican",
  [Quieres obtener 432 MHz a partir de un cristal seguido de un triplicador y dos dobladores en cascada. ¿Qué frecuencia debe tener el cristal?],
  ([36 MHz], [108 MHz], [61,7 MHz], [144 MHz],),
  sol: [En cascada los factores se multiplican: $3 times 2 times 2 = 12$, y $432 slash 12 = 36$ MHz. Los 61,7 MHz salen de sumar los factores ($3 + 2 + 2 = 7$) en vez de multiplicarlos; 144 MHz contaría solo el triplicador y 108 MHz, solo los dos dobladores.], tema: "T5")
#pq(2, 1, 18, "c", "estúdialo en: simulacros de estudio 13·1·18 · libro: T5.32", "Contra la sobremodulación: bajar el nivel de BF aplicado al modulador",
  [Un corresponsal te avisa de que tu emisión de SSB salpica los canales vecinos porque hablas muy cerca del micrófono con mucha ganancia. Lo correcto es:],
  ([poner el compresor al máximo], [pasar de USB a LSB], [bajar la ganancia de micrófono], [subir la potencia de salida del transmisor],),
  sol: [Es sobremodulación, un exceso de audio: se corrige bajando el nivel de BF que llega al modulador, es decir, la ganancia de micrófono. Subir la potencia o comprimir al máximo empuja aún más al transmisor hacia el recorte. Cambiar de banda lateral no reduce el nivel de audio.], tema: "T5")
#pq(2, 1, 19, "d", "estúdialo en: simulacros de estudio 13·1·19 · libro: T5.7", "ALC: limita la excitación del final y evita emisiones interferentes alrededor de la frecuencia",
  [¿Cómo consigue el ALC de un transmisor que el amplificador final no se sobreexcite?],
  ([corrigiendo la deriva de frecuencia del oscilador], [conmutando el equipo a transmisión al detectar voz], [midiendo la señal detectada en el receptor y reduciendo la ganancia de RF y FI], [midiendo la potencia de salida y reduciendo la ganancia de una etapa de bajo nivel cuando se acerca al máximo],),
  sol: [El ALC rectifica una muestra de la salida y, cuando la potencia se acerca al máximo, recorta la excitación en una etapa de poca potencia, de modo que el final no satura ni produce splatter. Medir la señal del receptor y ajustar RF y FI es el CAG; corregir la deriva, el CAF, y pasar a transmisión con la voz, el VOX.], tema: "T5")
#pq(2, 1, 20, "c", "estúdialo en: simulacros de estudio 13·1·20 · libro: T6.35", "La vertical de cuarto de onda necesita plano de tierra o radiales",
  [Se monta una vertical de cuarto de onda en lo alto de un mástil, sin plano de tierra ni radiales. Lo más probable es que:],
  ([su impedancia baje hasta unos 36 Ω], [pase a radiar con polarización horizontal], [falte la mitad de la antena: la impedancia se dispare y el rendimiento se desplome], [funcione igual, porque el plano de tierra solo sirve de soporte mecánico],),
  sol: [El plano de tierra, sea el suelo o un juego de radiales, actúa de espejo y aporta la mitad que falta del dipolo. Sin él no hay espejo: la impedancia se dispara, la corriente vuelve por el exterior de la malla del coaxial y el rendimiento cae. Los 36 Ω son, precisamente, los de la vertical con su plano de tierra.], tema: "T6")
#pq(2, 1, 21, "b", "estúdialo en: simulacros de estudio 4·1·22 · libro: T6.42", "Factor de velocidad: la onda va más despacio en la línea; FV = 1/√εr < 1",
  [El aislante de una línea tiene una constante dieléctrica $epsilon_r = 4$. Su factor de velocidad es:],
  ([4], [0,5], [0,25], [2],),
  sol: [$"FV" = 1 slash sqrt(epsilon_r) = 1 slash sqrt(4) = 0","5$: la onda viaja a la mitad de la velocidad de la luz. El 2 sale de olvidar la inversa y el 0,25 de olvidar la raíz. Un factor de velocidad mayor que 1 es imposible: dentro de una línea la onda va siempre más despacio que en el vacío.], tema: "T6")
#pq(2, 1, 22, "d", "estúdialo en: simulacros de estudio 13·1·22 · libro: T6.11", "Adaptación perfecta: ROE = 1, coeficiente de reflexión 0, potencia reflejada nula",
  [Un vatímetro direccional marca 100 W de potencia directa y 0 W de reflejada. Puede afirmarse que:],
  ([la ROE es 1:1 y el coeficiente de reflexión vale 1], [la ROE es infinita, porque no vuelve nada], [la ROE es 0 y el coeficiente de reflexión vale 1], [la ROE es 1:1 y el coeficiente de reflexión vale 0],),
  sol: [Sin potencia reflejada, $|rho| = sqrt(P_"refl" slash P_"dir") = 0$ y $"ROE" = (1 + 0) slash (1 - 0) = 1$: adaptación perfecta. La trampa es cruzar los números: la ROE vale 1, nunca 0, y el coeficiente de reflexión vale 0. Una ROE infinita corresponde a la reflexión total, con $|rho| = 1$.], tema: "T6")
#pq(2, 1, 23, "d", "estúdialo en: simulacros de estudio 7·1·23 · libro: T7.4", "La onda de superficie sigue la curvatura terrestre",
  [Una emisora de onda media se recibe de día a 200 km, mucho más allá del horizonte. ¿Por qué camino le llega la señal?],
  ([por onda directa, en línea recta entre las dos antenas], [por reflexión en la capa D, que de día es la más ionizada], [por onda de espacio reflejada en la capa F, igual que de noche], [por onda de superficie, que viaja pegada al suelo siguiendo la curvatura terrestre],),
  sol: [En MF, de día, manda la onda de superficie: sigue la curvatura de la Tierra y por eso rebasa el horizonte. La onda directa se queda en el horizonte. La capa D, de día, no devuelve la onda de MF sino que la absorbe, y por eso la reflexión en la capa F solo se aprovecha de noche, cuando la D desaparece.], tema: "T7")
#pq(2, 1, 24, "a", "estúdialo en: simulacros de estudio 5·1·24 · libro: C-T7.11", "Atenuación: toda onda se atenúa al propagarse y al atravesar objetos",
  [En el espacio libre, sin nada que absorba energía, ¿qué le pasa a la densidad de potencia de una onda al doblar la distancia a la antena?],
  ([se reduce a la cuarta parte], [se reduce a la octava parte], [se reduce a la mitad], [no cambia, porque nada la absorbe],),
  sol: [La misma potencia se reparte sobre una esfera cuya superficie crece con $d^2$: al doblar la distancia el área se cuadruplica y la densidad de potencia baja a la cuarta parte. Por eso toda onda se atenúa al propagarse aunque nada la absorba. La mitad sería el campo eléctrico, que cae con $1 / d$, no la potencia.], tema: "T7")
#pq(2, 1, 25, "b", "estúdialo en: simulacros de estudio 6·1·24 · libro: F-T7.7", "Meteor-scatter: reflexión en las estelas ionizadas de los meteoros",
  [Un grupo quiere probar contactos por meteor-scatter en 144 MHz. ¿Cuándo le conviene hacerlo?],
  ([en el máximo del ciclo solar, cuando hay más manchas], [durante una lluvia de meteoros, como las Perseidas de agosto o las Gemínidas de diciembre], [con luna llena, cuando la Luna refleja mejor las señales], [durante una tormenta geomagnética, con las antenas al norte],),
  sol: [El meteor-scatter rebota en las estelas ionizadas que dejan los meteoros, así que funciona mejor cuando más meteoros entran: en las lluvias de meteoros. Las manchas solares afectan a la ionosfera en HF, la tormenta geomagnética trae la reflexión auroral y la Luna es el reflector del EME.], tema: "T7")
#pq(2, 1, 26, "c", "estúdialo en: simulacros de estudio 1·1·25 · libro: T8.27", "El medidor de ROE compara la onda incidente y la reflejada: mide la desadaptación",
  [Al transmitir con la antena conectada, la aguja del medidor de ROE se queda en 1:1. ¿Qué se deduce?],
  ([la antena tiene una ganancia de 0 dB], [la onda reflejada es igual a la directa], [no hay onda reflejada: la impedancia de la antena está adaptada a la de la línea], [el transmisor entrega exactamente su potencia nominal],),
  sol: [El medidor de ROE compara la onda incidente con la reflejada: una ROE de 1 indica que no hay reflejada, es decir, adaptación perfecta. Si la reflejada igualase a la directa, la ROE sería infinita. El medidor no informa de la ganancia de la antena ni de si el transmisor da su potencia nominal.], tema: "T8")
#pq(2, 1, 27, "a", "estúdialo en: simulacros de estudio 3·1·27 · libro: T8.7", "Osciloscopio: representa la forma de onda en el dominio del tiempo (amplitud y período)",
  [¿Qué magnitudes se representan en los ejes horizontal y vertical, respectivamente, de la pantalla de un osciloscopio?],
  ([el tiempo y la tensión], [la tensión y el tiempo], [la frecuencia y la potencia], [la frecuencia y la tensión],),
  sol: [El osciloscopio trabaja en el dominio del tiempo: dibuja la tensión (eje vertical, en voltios por división) en función del tiempo (eje horizontal, la base de tiempos). Frecuencia en horizontal y potencia en vertical es la pantalla del analizador de espectros.], tema: "T8")
#pq(2, 1, 28, "d", "estúdialo en: simulacros de estudio 2·1·28 · libro: T9.19", "A más potencia, más riesgo de interferencia: usar la mínima potencia necesaria",
  [Reduces la potencia de tu transmisor de 100 W a 10 W. ¿Cuánto bajan, aproximadamente, todas sus emisiones no deseadas (armónicos y espurias)?],
  ([unos 20 dB], [unos 3 dB], [nada, porque solo dependen del filtro de salida], [unos 10 dB],),
  sol: [Cada armónico y cada espuria crecen con la potencia: dividirla entre 10 rebaja todas las emisiones no deseadas en 10 dB, y además reduce el campo en el entorno a menos de la tercera parte. Por eso se usa la mínima potencia necesaria. 3 dB correspondería a reducirla solo a la mitad.], tema: "T9")
#pq(2, 1, 29, "c", "estúdialo en: simulacros de estudio 12·1·30 · libro: T10.3", "La toma de tierra protege al operador: deriva la fuga y hace actuar al diferencial",
  [Un defecto de aislamiento pone la fase en contacto con el chasis de un equipo que no está conectado a tierra. Lo más probable es que:],
  ([el diferencial dispare de inmediato, antes de que nadie toque el equipo], [el chasis quede a 0 V, porque la fase pierde su tensión], [el chasis quede en tensión sin que nada lo indique hasta que alguien lo toque], [el fusible del equipo se funda al instante],),
  sol: [Sin toma de tierra el defecto no hace circular corriente: el chasis queda a 230 V en silencio y el diferencial solo actuará cuando alguien lo toque y la corriente atraviese su cuerpo. Con el chasis a tierra, la fuga circula en cuanto aparece y el diferencial corta antes del contacto: eso es lo que protege al operador. El fusible no se entera, porque no hay sobreintensidad.], tema: "T10")
#pq(2, 1, 30, "b", "estúdialo en: simulacros de estudio 3·1·30 · libro: T10.15", "Vientos del mástil: repartidos alrededor y tensados por igual",
  [Para sujetar un mástil con tres vientos lo correcto es:],
  ([tensar más el que mira al viento dominante y dejar flojos los demás], [anclarlos en direcciones repartidas alrededor del mástil y tensarlos por igual], [unirlos a un único punto de anclaje para que tiren en la misma dirección], [anclarlos los tres en el lado de donde suele soplar el viento],),
  sol: [Los vientos trabajan por oposición: repartidos alrededor del mástil y con la misma tensión, lo mantienen vertical venga el viento de donde venga. Si se anclan todos en un mismo lado o tiran en la misma dirección, el mástil queda sin sujeción hacia el lado contrario, y los vientos flojos no sujetan nada.], tema: "T10")
#fin-prueba()
#prueba(2, 2)
#pq(2, 2, 1, "c", "estúdialo en: simulacros de estudio 7·2·1 · libro: R1.21", "X X-ray, Y Yankee, Z Zulu (no «Zeta»); grafías Echo y Alfa (no Eco, Alpha)",
  [¿En cuál de estas series están todas las palabras escritas con la grafía oficial del alfabeto fonético internacional?],
  ([Alfa, Eco, X-ray, Yankee, Zeta], [Alfa, Echo, Equis, Yankee, Zulu], [Alfa, Echo, X-ray, Yankee, Zulu], [Alpha, Echo, X-ray, Yankee, Zulu],),
  sol: [La grafía oficial es Alfa (sin ph), Echo (con hache), X-ray (con guion), Yankee y Zulu. Alpha y Eco son grafías inglesa y castellana que el alfabeto no usa; Zeta y Equis son los nombres de las letras en castellano, no palabras de deletreo.], tema: "R1")
#pq(2, 2, 2, "d", "estúdialo en: simulacros de estudio 5·2·2 · libro: R2.7", "QRO aumente / QRP disminuya la potencia",
  [Tu señal llega débil al corresponsal y quieres preguntarle si debes aumentar la potencia. Transmites:],
  ([`QRP?`], [`QRS?`], [`QRQ?`], [`QRO?`],),
  sol: [`QRO` es «aumente la potencia» y, con interrogación, pregunta si se debe aumentar. `QRP` es su contrario, disminuir la potencia, y `QRQ` y `QRS` se refieren a la velocidad de transmisión, no a la potencia.], tema: "R2")
#pq(2, 2, 3, "c", "estúdialo en: simulacros de estudio 6·2·4 · libro: R2.26", "QTA anule el mensaje",
  [En una red de emergencia transmitiste el mensaje número 5, que ha dejado de ser válido. Para retirarlo transmites:],
  ([`QSP 5`], [`QTC 5`], [`QTA 5`], [`QSM 5`],),
  sol: [`QTA` es «anule el mensaje número…», y sirve justo para retirar un mensaje que ya no vale. `QTC` anuncia mensajes pendientes, `QSM` pide repetir el último mensaje y `QSP` es retransmitirlo gratuitamente.], tema: "R2")
#pq(2, 2, 4, "d", "estúdialo en: simulacros de estudio 9·2·3 · libro: F-R2.2", "QRY ¿cuál es mi turno?",
  [En una red con varias estaciones esperando para transmitir, el director te contesta «`QRY 3`». ¿Qué te está diciendo?],
  ([que esperes 3 minutos y vuelvas a llamar], [que la inteligibilidad de tus señales es 3], [que tiene 3 mensajes para ti], [que tu turno es el número 3],),
  sol: [`QRY?` pregunta «¿cuál es mi turno?» y se contesta «su turno es el número…». La inteligibilidad es `QRK`, esperar es `QRX` y los mensajes pendientes, `QTC`.], tema: "R2")
#pq(2, 2, 5, "b", "estúdialo en: simulacros de estudio 5·2·5 · libro: R3.7", "AR fin de la transmisión (no del contacto)",
  [En respuesta a una llamada, EA1ABC transmite «EA4XYZ DE EA1ABC EA1ABC AR». La `AR` del final indica:],
  ([el fin del contacto entre las dos estaciones], [el fin de esta transmisión, sin cerrar el contacto], [el cierre de la estación], [una petición de repetición],),
  sol: [`AR` cierra un mensaje concreto, pero no el contacto: después seguirá el intercambio. El fin del contacto es `SK`, y el cierre de la estación, `CL`; son las señales de turno que más se confunden.], tema: "R3")
#pq(2, 2, 6, "a", "estúdialo en: simulacros de estudio 10·2·6 · libro: R3.20", "WX tiempo meteorológico",
  [Tu corresponsal te cuenta que en su ciudad hace sol y frío. ¿Con qué abreviatura introduce ese dato?],
  ([`WX`], [`RIG`], [`QTH`], [`HR`],),
  sol: [`WX` es el tiempo meteorológico: «`WX SUNNY ES COLD`». `QTH` da la posición y `HR` significa «aquí»; pueden aparecer en la misma frase, pero no anuncian el tiempo. `RIG` es el equipo.], tema: "R3")
#pq(2, 2, 7, "c", "estúdialo en: simulacros de estudio 2·2·6 · libro: R3.27", "OP operador",
  [Operas desde la estación de un radioclub y quieres decir quién está a los mandos: «… Ana». ¿Qué abreviatura usas?],
  ([`QTH`], [`QRA`], [`OP`], [`OM`],),
  sol: [`OP` es el operador, la persona que está a los mandos y que no siempre coincide con el titular de la estación. `OM` es el tratamiento al corresponsal, `QRA` el nombre de la estación y `QTH` la posición.], tema: "R3")
#pq(2, 2, 8, "b", "estúdialo en: simulacros de estudio 7·2·8 · libro: R4.1", "Socorro en radiotelefonía: MAYDAY",
  [Tu velero tiene una vía de agua y se hunde, con tres personas a bordo. ¿Con qué palabra, repetida tres veces, empiezas la llamada en radiotelefonía?],
  ([Alarma], [Mayday], [Sécurité], [Pan Pan],),
  sol: [Hay vidas en peligro grave e inminente: es socorro, y en fonía la señal es «Mayday». «Pan Pan» es urgencia sin peligro inmediato y «Sécurité» es un aviso a otras estaciones.], tema: "R4")
#pq(2, 2, 9, "d", "estúdialo en: simulacros de estudio 5·2·9 · libro: R4.14", "Tras emitir un socorro: escuchar en la misma frecuencia",
  [Tu mensaje de socorro ha salido en 3700 kHz. Mientras esperas contestación, ¿dónde te quedas escuchando?],
  ([en la frecuencia de llamada de FM de 2 m], [en 14300 kHz, centro de actividad de emergencia], [en otra banda con mejor propagación], [en los mismos 3700 kHz],),
  sol: [Tras emitir un socorro hay que quedarse a la escucha en la misma frecuencia, porque allí te ha oído quien vaya a contestar. Irse a otra frecuencia, aunque sea una de emergencia, hace que se pierda la respuesta.], tema: "R4")
#pq(2, 2, 10, "a", "estúdialo en: simulacros de estudio 4·2·9 · libro: F-R4.14", "Banda de 23 cm: 1240–1300 MHz",
  [¿Cuál de estas frecuencias pertenece a la banda de aficionados de 23 cm?],
  ([1296 MHz], [1350 MHz], [1230 MHz], [1310 MHz],),
  sol: [La banda de 23 cm va de 1240 a 1300 MHz, así que solo 1296 MHz cae dentro. 1230 MHz queda por debajo del límite inferior y 1310 y 1350 MHz, por encima del superior.], tema: "R4")
#pq(2, 2, 11, "d", "estúdialo en: simulacros de estudio 9·2·11 · libro: R5.24", "La cifra es la del distrito de residencia del titular al otorgar la autorización",
  [Una persona que vive en Sevilla se examina en Madrid y obtiene la autorización mientras sigue residiendo en Sevilla. La cifra de su distintivo será:],
  ([la que elija entre la de su residencia y la del lugar del examen], [el 4], [la que quede libre en el momento de expedir la autorización], [el 7],),
  sol: [La cifra es la del distrito de residencia del titular en el momento del otorgamiento (art. 27.2): Sevilla está en Andalucía, distrito 7. El lugar del examen no interviene, así que el 4 de Madrid es la trampa.], tema: "R5")
#pq(2, 2, 12, "b", "estúdialo en: simulacros de estudio 12·2·13 · libro: C-R5.4", "Sufijo de dos letras: 5 años de autorización, 5 de práctica internacional y 5 sin expediente sancionador; no reservado a colectivas",
  [Un radioaficionado tiene autorización española desde hace cuatro años, acredita diez años de práctica en la radioafición internacional y nunca ha sido sancionado. ¿Puede obtener un sufijo de dos letras?],
  ([No, porque los sufijos de dos letras se reservan a las estaciones colectivas], [No, porque se exigen al menos cinco años de autorización española], [No, porque se exigen quince años de práctica internacional], [Sí, porque acredita más de cinco años de práctica internacional],),
  sol: [Para el sufijo de dos letras hay que cumplir las tres condiciones: cinco años de autorización española, cinco de práctica internacional y cinco sin expediente sancionador. Le sobra práctica, pero le falta antigüedad. Los quince años son para el sufijo de una letra, y no hay reserva a colectivas.], tema: "R5")
#pq(2, 2, 13, "a", "estúdialo en: simulacros de estudio 13·2·13 · libro: F-R5.14", "Prefijo AO optativo para españoles en zonas no adscritas a soberanías nacionales",
  [Un radioaficionado español emite desde una zona no adscrita a ninguna soberanía nacional. Con carácter optativo, puede usar el prefijo:],
  ([AO], [EH], [ED], [AN],),
  sol: [El art. 27.1.d asigna AO a los eventos relevantes de ámbito internacional y, de forma optativa, a las emisiones de españoles desde zonas no adscritas a soberanías nacionales. AN es para eventos nacionales, EH para relevantes locales a autonómicos y ED para eventos ordinarios o desatendidas.], tema: "R5")
#pq(2, 2, 14, "c", "estúdialo en: simulacros de estudio 6·2·14, 10·2·14 · libro: C-R6.3, R6.13", "Naturaleza de los planes: acuerdos voluntarios y guía mundial, pero la Orden obliga a usar el de la Región 1 como norma general en España",
  [Un operador emite en fonía dentro del segmento de telegrafía de 80 m y alega que los planes de la IARU «son solo recomendaciones». En España, su postura:],
  ([es correcta: los planes de la IARU no tienen ninguna incidencia en la normativa española], [no es correcta, porque los planes de la IARU tienen rango de ley en los países de la CEPT], [no es correcta: aunque nacen como acuerdos voluntarios, la Orden IET/1311/2013 obliga a seguir el plan de la Región 1 como norma general], [es correcta siempre que emita con baja potencia],),
  sol: [Los planes son voluntarios en origen, pero la Orden (art. 2.2 y anexo I) remite al de la Región 1 y obliga a usarlo como norma general, así que todo radioaficionado en España debe respetarlo. No es que tengan rango de ley en la CEPT: la obligación viene de la norma española.], tema: "R6")
#pq(2, 2, 15, "a", "estúdialo en: simulacros de estudio 3·2·14 · libro: C-R6.1", "Repetidores de 70 cm: entrada 433,000–433,375 MHz, desplazamiento 1,6 MHz",
  [Un repetidor de 70 cm del sistema con entradas en 433,000–433,375 MHz tiene su salida en 434,825 MHz. Su frecuencia de entrada es:],
  ([433,225 MHz], [434,225 MHz], [433,825 MHz], [436,425 MHz],),
  sol: [En ese sistema el desplazamiento es de 1,6 MHz con la salida por encima: 434,825 − 1,600 = 433,225 MHz, dentro del segmento de entradas. Restar 600 kHz (el desplazamiento de 2 m) da 434,225 MHz, y sumar 1,6 MHz, 436,425 MHz.], tema: "R6")
#pq(2, 2, 16, "d", "estúdialo en: simulacros de estudio 2·2·16 · libro: R7.9", "Mensajes de terceros: no permitidos con carácter general (salvo emergencia)",
  [¿En cuál de estos casos se admite cursar un mensaje para una persona ajena al servicio de aficionados?],
  ([Cuando el mensaje se transmite en telegrafía], [Cuando el mensaje es breve y de carácter familiar], [Cuando el destinatario es familiar de un radioaficionado], [En una situación de emergencia o catástrofe],),
  sol: [Con carácter general no se permite cursar mensajes para terceros ajenos al servicio; la excepción son las emergencias y catástrofes (art. 30.3 de la Orden). Que sea breve, familiar o en telegrafía no cambia la regla.], tema: "R7")
#pq(2, 2, 17, "b", "estúdialo en: simulacros de estudio 11·2·18 · libro: C-R8.4", "Orden IET/1311/2013: documento fundamental de regulación de la radioafición",
  [La norma que se considera el documento fundamental de regulación de la radioafición en España es:],
  ([la Recomendación CEPT T/R 61-02, sobre el certificado HAREC], [la Orden IET/1311/2013, que aprueba el Reglamento de uso del dominio público radioeléctrico por aficionados], [la Ley 19/1983, sobre el derecho a instalar antenas en el exterior de los inmuebles], [el Real Decreto 2623/1986, sobre las instalaciones de antenas de aficionado],),
  sol: [La Orden IET/1311/2013 es la norma específica de la actividad: regula la autorización, la prueba, las estaciones, los distintivos y las condiciones de uso. La Ley 19/1983 y el Real Decreto 2623/1986 solo tratan de las antenas, y la T/R 61-02 armoniza el certificado de examen en el ámbito CEPT.], tema: "R8")
#pq(2, 2, 18, "c", "estúdialo en: simulacros de estudio 8·2·19 · libro: F-R8.60", "Desatendida: interrupción > 3 meses puede llevar a cancelar su licencia",
  [Un repetidor lleva cuatro meses sin emitir por desinterés de la asociación titular, sin causa de fuerza mayor. Según el artículo 25.b:],
  ([la asociación debe abonar una tasa por cada mes de interrupción], [no ocurre nada hasta que la interrupción supere los seis meses], [puede abrirse un procedimiento para cancelar su licencia y otorgar la autorización a otra asociación interesada], [su licencia queda cancelada automáticamente al cumplirse el tercer mes],),
  sol: [Toda interrupción de más de tres meses, salvo fuerza mayor, puede dar lugar a la apertura de actuaciones para cancelar la licencia y, en su caso, otorgar la autorización a otra asociación interesada; cuatro meses superan ese plazo. No es una cancelación automática: la norma habla de abrir actuaciones. Los seis meses son el plazo para terminar una instalación (art. 26), no el de la interrupción.], tema: "R8")
#pq(2, 2, 19, "a", "estúdialo en: simulacros de estudio 10·2·19 · libro: F-R8.80", "Servicio secundario: no causa interferencia al primario ni puede reclamar protección; sí frente a secundarios posteriores",
  [Operas en una banda en la que los aficionados son servicio secundario. Una estación de un servicio primario, a la que se asignó frecuencia después de que empezaras a usarla, te causa interferencia perjudicial. Según el anexo I:],
  ([no puedes reclamar protección, aunque a esa estación primaria se le asignara la frecuencia después], [puedes reclamar protección, porque empezaste a usar la frecuencia antes], [puedes reclamar protección si la estación primaria emite con más potencia que tú], [puedes exigirle que cambie de frecuencia, porque el servicio secundario está protegido frente a las asignaciones posteriores],),
  sol: [Las estaciones de un servicio secundario no pueden reclamar protección frente a las interferencias de estaciones de un servicio primario, tengan sus frecuencias asignadas antes o se les asignen en el futuro. La protección frente a asignaciones posteriores solo existe respecto a estaciones del mismo servicio o de otros servicios secundarios. Por eso falla el último distractor, que aplica esa regla a una estación primaria.], tema: "R8")
#pq(2, 2, 20, "c", "estúdialo en: simulacros de estudio 6·2·24 · libro: C-R8.31", "HAREC: certifica la capacidad para operar; no autoriza a emitir, no caduca, sustituye al diploma de operador",
  [Acabas de aprobar el examen y recibes el certificado HAREC. ¿Puedes empezar a emitir ya?],
  ([No: antes debes renovar el HAREC ante la CEPT], [Sí, pero solo en las bandas de VHF y UHF hasta que recibas la autorización], [No: el HAREC certifica tu capacidad para operar, pero necesitas solicitar y obtener la autorización de radioaficionado], [Sí, porque el HAREC lleva implícita la autorización de uso del espectro],),
  sol: [El HAREC certifica la capacidad de su titular para operar estaciones del Servicio de Aficionados, pero por sí solo no autoriza a emitir: habilita para solicitar la autorización. No hay emisión provisional en ninguna banda mientras tanto. Y el HAREC no caduca ni se renueva.], tema: "R8")
#pq(2, 2, 21, "d", "estúdialo en: simulacros de estudio 11·2·20 · libro: R8.11", "Plazo para resolver la autorización (y la licencia de estación fija): 6 semanas, silencio desestimatorio",
  [Un aspirante presentó su solicitud de autorización de radioaficionado hace siete semanas y no ha recibido ninguna resolución. Su solicitud:],
  ([le permite emitir provisionalmente con un distintivo temporal hasta que se resuelva], [se entiende concedida por silencio positivo, y puede empezar a emitir], [sigue en plazo, porque la Administración dispone de seis meses], [se entiende desestimada, porque el plazo para resolver es de seis semanas y el silencio es desestimatorio],),
  sol: [La Administración tiene seis semanas para resolver y notificar, y el silencio es desestimatorio: pasado ese plazo sin resolución, la solicitud se entiende denegada. El silencio nunca le permite emitir, y los seis meses no son el plazo de este procedimiento.], tema: "R8")
#pq(2, 2, 22, "b", "estúdialo en: simulacros de estudio 13·2·23 · libro: F-R8.23", "Equipos comerciales: legislación vigente en su comercialización inicial; los ya legalizados, la de su autorización inicial",
  [Compras de segunda mano un transceptor comercializado por primera vez en 2010, que nunca estuvo legalizado en una licencia de estación. ¿Qué legislación sobre su comercialización (marcado CE, etc.) debe cumplir?],
  ([La vigente hoy, porque al cambiar de dueño se trata como un equipo nuevo], [La que le era aplicable en 2010, cuando se comercializó inicialmente], [Debe certificarse por un laboratorio acreditado el cumplimiento del anexo I], [Ninguna: los equipos de segunda mano están exentos],),
  sol: [El art. 5.5 exige a los equipos comprados en el mercado la legislación que les era aplicable en el momento de su comercialización inicial; cambiar de dueño no cambia esa fecha. La certificación por laboratorio acreditado es la vía de los equipos de segunda mano anteriores al Real Decreto 1890/2000 que carecen de certificado, y este es de 2010. Los ya legalizados en una licencia siguen la norma de su autorización inicial.], tema: "R8")
#pq(2, 2, 23, "a", "estúdialo en: simulacros de estudio 7·2·23 · libro: C-R8.39", "Definición de estación fija: ubicación fija consignada en la licencia",
  [Una estación instalada en una caseta de montaña, con antenas permanentes y que emite siempre desde ese mismo lugar, es una estación:],
  ([fija, que precisa licencia en la que conste esa ubicación], [portátil, porque está alejada de la red eléctrica], [móvil, porque no está instalada en un edificio urbano], [portable, porque no está en el domicilio del titular],),
  sol: [La estación fija es la que emite desde una ubicación fija determinada, que se consigna en su licencia; da igual que no sea el domicilio. Portable es la fija usada temporalmente en otro lugar, móvil la que opera en movimiento o parada en un punto no determinado, y portátil la que lleva antena y fuente de alimentación incorporadas.], tema: "R8")
#pq(2, 2, 24, "b", "estúdialo en: simulacros de estudio 5·2·25 · libro: C-R8.3", "Seguro de responsabilidad civil obligatorio, formalizado antes de expedirse la licencia",
  [Un radioaficionado piensa contratar el seguro de responsabilidad civil de su antena cuando le hayan expedido la licencia de estación fija, para no pagarlo antes de tiempo. ¿Es correcto?],
  ([Sí: el seguro solo se exige una vez concedida la licencia], [No: el seguro debe estar formalizado antes de expedirse la licencia, y se justifica al comunicar el fin de la instalación], [Sí, siempre que lo contrate en el mes siguiente a la expedición de la licencia], [No: debe contratarlo al solicitar la autorización de radioaficionado],),
  sol: [El seguro se formaliza una vez autorizado el montaje y, en todo caso, antes de expedirse la licencia; por eso se presenta su justificante al comunicar el fin de la instalación. No es un trámite de la autorización de radioaficionado, que es personal, sino de la estación fija. Sin seguro vigente, la licencia se cancela.], tema: "R8")
#pq(2, 2, 25, "d", "estúdialo en: simulacros de estudio 11·2·24 · libro: C-R8.25", "Definiciones del RD 2623/1986: anclaje, riostra, plano de paso, elemento repartidor de carga",
  [En una azotea, un mástil sostiene una antena y está sujeto por tres cables tensados que se fijan al pretil con unas argollas atornilladas a la obra. Según la terminología del Real Decreto 2623/1986, los cables y las argollas son, respectivamente:],
  ([riostras y soportes], [anclajes y riostras], [soportes y anclajes], [riostras y anclajes],),
  sol: [La riostra es el cable o pieza que asegura la estabilidad mecánica de la antena y su soporte; el anclaje es el punto o elemento que la fija a la obra civil del inmueble, repartiendo esfuerzos. El soporte es lo que sustenta la antena, aquí el mástil. Truco: la riostra tira y el anclaje la agarra al edificio.], tema: "R8")
#pq(2, 2, 26, "a", "estúdialo en: simulacros de estudio 2·2·25 · libro: F-R8.38", "Autorizaciones del art. 16 (bandas secundarias): limitaciones geográficas o técnicas",
  [Un radioaficionado quiere operar en 24,100 GHz, dentro de la banda de 24,050–24,250 GHz, que la disposición adicional segunda incluye entre las que precisan autorización especial por el riesgo de interferir a servicios primarios. En esa autorización del artículo 16 se fijarán:],
  ([las limitaciones geográficas o técnicas de uso necesarias para asegurar la compatibilidad con los servicios autorizados que puedan verse afectados], [un plazo de validez no superior a 90 días], [el derecho de su estación a reclamar protección frente a las interferencias de los servicios primarios de la banda], [la designación de un gestor de la banda, responsable de verificar el tráfico de todos los usuarios],),
  sol: [El art. 16.2 dispone que en estas autorizaciones especiales se establezcan las limitaciones geográficas o técnicas de uso que aseguren la compatibilidad con los servicios de radiocomunicaciones que puedan verse afectados. Al ser una banda secundaria, la estación de aficionado no puede reclamar protección frente a los servicios primarios: ocurre justo lo contrario. Los 90 días son el máximo de la autorización temporal de un extranjero de un país sin la T/R 61-01 (art. 15), y el art. 16 no fija plazo.], tema: "R8")
#pq(2, 2, 27, "c", "estúdialo en: simulacros de estudio 3·2·25 · libro: F-R8.70", "Noveles: distintivo de la colectiva + 2 o 3 letras tras el sufijo",
  [Cuando personas noveles emiten desde una estación colectiva con fines de divulgación, ¿qué se añade tras el sufijo del distintivo de la colectiva?],
  ([una cifra que indica el distrito desde el que se emite], [el distintivo completo del radioaficionado que las supervisa], [dos o tres letras de libre elección], [la indicación /P de estación portable],),
  sol: [Según el art. 30.6.c, las emisiones se identifican con el distintivo de la estación colectiva seguido, tras el sufijo, de dos o tres letras de libre elección. No se añade el distintivo del supervisor ni una cifra de distrito, que en la identificación opcional va delante y no tras el sufijo. La indicación /P es propia de la estación portable y nada tiene que ver con los noveles.], tema: "R8")
#pq(2, 2, 28, "a", "estúdialo en: simulacros de estudio 13·2·30 · libro: R9.5", "Multas máximas: 20 M€ muy graves y 2 M€ graves",
  [Según la Ley 11/2022, una multa de hasta 2 millones de euros corresponde a una infracción:],
  ([grave], [de cualquier grado: es la cuantía única que fija la ley], [leve], [muy grave],),
  sol: [La escala de multas máximas es: 20 millones de euros las muy graves, 2 millones las graves y 100 000 euros las leves. Los 2 millones son, pues, el tope de las graves. Quien confunde los dos primeros escalones elige «muy grave».], tema: "R9")
#pq(2, 2, 29, "b", "estúdialo en: simulacros de estudio 4·2·30 · libro: F-R9.1", "Multa máxima de las leves: 100 000 €",
  [Un radioaficionado es sancionado por comunicarse utilizando estaciones no autorizadas. Según la Ley 11/2022, la multa máxima que se le puede imponer es de:],
  ([50 000 euros], [100 000 euros], [2 millones de euros], [20 millones de euros],),
  sol: [Comunicarse utilizando estaciones no autorizadas es infracción leve (art. 108.2), y la multa de las leves llega a 100 000 euros (art. 109.1.d). Los 50 000 euros eran el tope de las leves en la ley anterior (Ley 9/2014) y aún aparecen en preguntas antiguas. Los 2 y 20 millones son los topes de las graves y las muy graves.], tema: "R9")
#pq(2, 2, 30, "b", "estúdialo en: simulacros de estudio 8·2·30 · libro: R9.25", "Portadora sin modular: solo para ensayos breves",
  [Para ajustar el acoplador de antena necesitas emitir una portadora sin modular. ¿Cómo debes hacerlo?],
  ([solo con una autorización experimental previa], [durante el tiempo estrictamente necesario e identificándote], [solo después de notificarlo a la Jefatura Provincial con cinco días de antelación], [el tiempo que quieras, si la banda está poco ocupada],),
  sol: [La portadora sin modular solo se admite para ensayos y durante un tiempo breve, siempre identificándose: el Anexo I de la Orden limita la potencia y la duración de las emisiones a lo estrictamente necesario. Mantenerla indefinidamente es, de hecho, interferir. No hace falta notificación previa ni autorización experimental: el aviso de cinco días es el de las estaciones portables.], tema: "R9")
#fin-prueba()
#soluciones-simulacro(2)

// ======================================================================
#simulacro(3)
#prueba(3, 1)
#pq(3, 1, 1, "b", "estúdialo en: simulacros de estudio 1·1·1 · libro: T1.4", "Carga y corriente: 1 C = 1 A · 1 s y 1 A = 1 C/s",
  [Por un conductor circula una corriente constante de 2 A. La carga eléctrica que lo atraviesa en un minuto es de:],
  ([0,033 C], [120 C], [30 C], [2 C],),
  sol: [La carga es corriente por tiempo: $Q = I t = 2 times 60 = 120$ C, porque 1 C = 1 A · 1 s y un minuto son 60 s. Los 2 C serían la carga de un solo segundo; los 30 C y los 0,033 C salen de dividir en lugar de multiplicar.], tema: "T1")
#pq(3, 1, 2, "d", "estúdialo en: simulacros de estudio 5·1·2 · libro: C-T1.24", "Prefijos del SI y conversión entre múltiplos y submúltiplos",
  [Una resistencia de 2,2 MΩ equivale a:],
  ([22 000 Ω], [0,0022 Ω], [2200 Ω], [2 200 000 Ω],),
  sol: [El prefijo mega (M, mayúscula) vale $10^6$: 2,2 MΩ = $2","2 times 10^6$ Ω = 2 200 000 Ω. Los 2200 Ω serían 2,2 kΩ (kilo, $10^3$) y los 0,0022 Ω, 2,2 mΩ: confundir la M de mega con la m de mili es el error típico.], tema: "T1")
#pq(3, 1, 3, "b", "estúdialo en: simulacros de estudio 4·1·2, 11·1·2 · libro: T1.39, C-T1.23", "Valor eficaz: definición por el efecto calorífico; la tensión de red se da en eficaz",
  [Una estufa conectada a la red de 230 V eficaces calienta exactamente igual que si se conectara a una tensión continua de:],
  ([207 V], [230 V], [163 V], [325 V],),
  sol: [El valor eficaz se define precisamente así: es la tensión continua que produce el mismo efecto calorífico en una resistencia, de modo que 230 V eficaces calientan como 230 V de continua. 325 V es el valor de pico de la red, 207 V el valor medio de una semionda y 163 V resulta de dividir otra vez entre $sqrt(2)$.], tema: "T1")
#pq(3, 1, 4, "a", "estúdialo en: simulacros de estudio 11·1·4 · libro: F-T1.21", "Espectro de AM: portadora y dos bandas laterales en f_c ± f_m",
  [En el espectro de una emisión de AM modulada por un tono se ven la portadora en 7,100 MHz y una banda lateral en 7,1025 MHz. La frecuencia del tono y la de la otra banda lateral son:],
  ([2,5 kHz y 7,0975 MHz], [2,5 kHz y 7,105 MHz], [25 kHz y 7,075 MHz], [5 kHz y 7,0975 MHz],),
  sol: [Las bandas laterales están en $f_c plus.minus f_m$: la distancia entre la portadora y una banda es la frecuencia moduladora, $7","1025 - 7","100 = 0","0025$ MHz = 2,5 kHz, y la otra banda está simétrica, en $7","100 - 0","0025 = 7","0975$ MHz. Los 5 kHz son la anchura total de la emisión ($2 f_m$), no el tono; 7,105 MHz duplica la distancia hacia el mismo lado, y 25 kHz es un error de coma.], tema: "T1")
#pq(3, 1, 5, "c", "estúdialo en: simulacros de estudio 3·1·6 · libro: C-T2.14", "Capacidad: C = Q/V; el condensador almacena carga eléctrica",
  [Un condensador de 10 μF se carga a 50 V. ¿Qué carga eléctrica almacena?],
  ([5 mC], [0,2 μC], [500 μC], [12,5 mJ],),
  sol: [De $C = Q / V$ sale $Q = C V = 10 dot 10^(-6) dot 50 = 5 dot 10^(-4)$ C, es decir, 500 μC. Dividir C entre V da 0,2 μC. Los 12,5 mJ son la energía almacenada ($1/2 C V^2$), que es otra magnitud y se mide en julios.], tema: "T2")
#pq(3, 1, 6, "d", "estúdialo en: simulacros de estudio 1·1·7, 8·1·6 · libro: T2.16, F-T2.6", "La reactancia inductiva X_L = 2πfL crece con la frecuencia y es nula en continua",
  [Una bobina presenta una reactancia de 300 Ω a 7 MHz. ¿Cuál será su reactancia a 21 MHz?],
  ([100 Ω], [300 Ω], [2700 Ω], [900 Ω],),
  sol: [$X_L = 2 pi f L$ es directamente proporcional a la frecuencia: al triplicarla, la reactancia se triplica, de 300 a 900 Ω. Dividir entre tres (100 Ω) sería el comportamiento de un condensador, y 2700 Ω supondría una dependencia con el cuadrado de la frecuencia.], tema: "T2")
#pq(3, 1, 7, "d", "estúdialo en: simulacros de estudio 5·1·8 · libro: T2.34", "FET y MOSFET: terminales puerta, drenador y surtidor; control por tensión de puerta",
  [En un FET, la corriente que circula entre drenador y surtidor se controla mediante:],
  ([la tensión aplicada a la rejilla de pantalla], [la corriente que se inyecta en la base], [la corriente que se inyecta en la puerta], [la tensión aplicada a la puerta, que apenas toma corriente],),
  sol: [El FET se gobierna con la tensión de puerta: el campo eléctrico estrecha o ensancha el canal sin que la puerta consuma corriente apreciable. Gobernar con corriente de base es lo propio del bipolar, y la rejilla de pantalla es un electrodo de las válvulas.], tema: "T2")
#pq(3, 1, 8, "b", "estúdialo en: simulacros de estudio 1·1·9 · libro: T2.30", "El nombre de la válvula cuenta electrodos: pentodo = cátodo, tres rejillas y placa",
  [¿Cuántos electrodos tiene una válvula tetrodo?],
  ([cinco: cátodo, tres rejillas y placa], [cuatro: cátodo, rejilla de control, rejilla de pantalla y placa], [tres: cátodo, rejilla de control y placa], [cuatro: dos cátodos y dos placas],),
  sol: [El nombre de la válvula cuenta electrodos: tri-, tetra-, penta-. El tetrodo es el tríodo más una rejilla de pantalla, que reduce la capacidad entre rejilla y placa. Tres electrodos son del tríodo y cinco (con la rejilla supresora) del pentodo.], tema: "T2")
#pq(3, 1, 9, "c", "estúdialo en: simulacros de estudio 4·1·12 · libro: T3.35", "Número de diodos: media onda 1; onda completa con toma media 2; puente 4",
  [Una fuente de alimentación tiene un transformador con un secundario sencillo, sin toma media, y debe aprovechar los dos semiciclos de la red. El número mínimo de diodos del rectificador es:],
  ([uno], [seis], [cuatro], [dos],),
  sol: [Sin toma media, la única forma de aprovechar los dos semiciclos es el puente, que necesita cuatro diodos: en cada semiciclo conducen dos en diagonal. Los dos diodos bastan solo si el secundario tiene toma media, y con un diodo se rectifica únicamente media onda.], tema: "T3")
#pq(3, 1, 10, "a", "estúdialo en: simulacros de estudio 11·1·12 · libro: T3.26", "Bloques de una fuente lineal y su orden: transformador → rectificador → filtro → regulador (reconocer el esquema)",
  [En una fuente de alimentación lineal, la tensión que llega a la entrada del regulador es:],
  ([continua, con un pequeño rizado], [pulsante, tal como sale de los diodos], [alterna reducida, la del secundario del transformador], [alterna de 230 V, la de la red],),
  sol: [El orden de los bloques es transformador, rectificador, filtro y regulador. Al regulador le llega, por tanto, la salida del filtro: una continua con un pequeño rizado, que él se encarga de eliminar y de fijar. La alterna de la red entra al transformador, la del secundario va al rectificador y la tensión pulsante de los diodos va al filtro.], tema: "T3")
#pq(3, 1, 11, "c", "estúdialo en: simulacros de estudio 2·1·11 · libro: T3.32", "Regulador: mantiene constante la tensión de salida aunque varíen la carga y la red",
  [Un transceptor alimentado a 13,8 V pasa de recepción a transmisión y su consumo sube bruscamente de 1 A a 20 A. El bloque de la fuente que impide que la tensión de salida se hunda es:],
  ([el fusible de entrada], [el transformador], [el regulador], [el rectificador],),
  sol: [El regulador mantiene constante la tensión de salida aunque varíen la carga y la red; sin él, la tensión bajaría cada vez que el equipo pasa a transmitir. El transformador solo adapta la tensión de red, el rectificador la convierte en continua pulsante y el fusible protege, pero ninguno estabiliza la salida.], tema: "T3")
#pq(3, 1, 12, "d", "estúdialo en: simulacros de estudio 3·1·12 · libro: F-T3.12", "Ganancia de tensión en decibelios: 20·log(V2/V1)",
  [Un preamplificador tiene una ganancia de tensión de 26 dB, con la misma impedancia a la entrada y a la salida. Si a su entrada hay 5 mV, a la salida habrá aproximadamente:],
  ([130 mV], [2 V], [31 mV], [100 mV],),
  sol: [Con tensiones, $G = 20 log(V_2 slash V_1)$, así que $V_2 slash V_1 = 10^(26 slash 20) approx 20$ y la salida es de unos $5 dot 20 = 100$ mV. Los 2 V salen de aplicar la fórmula de potencias ($10^(2","6) approx 400$). Los 130 mV multiplican por los decibelios como si fueran veces, y los 31 mV suman los decibelios a los milivoltios.], tema: "T3")
#pq(3, 1, 13, "a", "estúdialo en: simulacros de estudio 5·1·13 · libro: C-T3.16", "Estabilidad del oscilador: la temperatura hace derivar su frecuencia",
  [Para reducir la deriva de frecuencia con la temperatura de un oscilador LC, es conveniente emplear en su circuito resonante:],
  ([condensadores cerámicos de tipo NP0 (C0G), que apenas varían con la temperatura], [una bobina de hilo más fino, que se caliente antes], [más potencia de salida, para que el oscilador se estabilice], [condensadores electrolíticos de gran capacidad],),
  sol: [La frecuencia de un oscilador depende de los valores de su bobina y sus condensadores, y estos cambian con la temperatura: es la deriva térmica. Por eso se eligen componentes que apenas varían, como los cerámicos NP0/C0G, o se recurre al cristal. Los electrolíticos tienen fugas y son malos en RF, y ni una bobina que se calienta antes ni más potencia de salida corrigen la deriva.], tema: "T3")
#pq(3, 1, 14, "b", "estúdialo en: simulacros de estudio 8·1·14 · libro: C-T4.3", "Pasar de USB a LSB cambia la frecuencia del BFO (batido), no el ancho de banda ni la clase de emisión",
  [En un receptor de SSB con FI de 9 MHz y filtro de 2,4 kHz, al pasar el selector de USB a LSB el equipo:],
  ([pasa de demodular J3E a demodular A3E], [coloca el BFO al otro lado de la banda de paso del filtro de FI], [desconecta el BFO y usa el detector de envolvente], [sustituye el filtro de FI por otro de doble anchura],),
  sol: [USB y LSB son la misma clase de emisión, J3E, con el mismo filtro de unos 2,4 kHz: solo cambia la banda lateral que se demodula. Para ello se desplaza el oscilador de batido al otro lado de la banda de paso del filtro y la portadora se repone por el lado que corresponde. El ancho de banda no cambia, y sin BFO no se podría demodular ninguna de las dos.], tema: "T4")
#pq(3, 1, 15, "a", "estúdialo en: simulacros de estudio 11·1·14 · libro: T4.31", "La selectividad la fijan las etapas (filtros) de FI; la FI son amplificadores y filtros",
  [Quieres separar mejor dos estaciones de telegrafía muy próximas en frecuencia. La parte del receptor que conviene cambiar es:],
  ([el filtro de FI, por uno más estrecho], [el amplificador de BF, por uno de más potencia], [el oscilador local, por uno más estable], [el amplificador de RF, por uno de menor ruido],),
  sol: [La selectividad la fijan los filtros de la etapa de FI: un filtro más estrecho, como los de 500 Hz para CW, deja fuera la estación vecina. Un amplificador de RF menos ruidoso mejora la sensibilidad, no la separación entre señales próximas, y un oscilador más estable evita la deriva.], tema: "T4")
#pq(3, 1, 16, "b", "estúdialo en: simulacros de estudio 12·1·18 · libro: C-T5.19", "Clases de emisión UIT: A1A (CW), A3E (AM), J3E (SSB), R3E, F3E (FM)",
  [La telefonía en banda lateral única con portadora reducida se designa con la clase de emisión:],
  ([J3E], [R3E], [A1A], [A3E],),
  sol: [La primera letra indica la modulación: R es banda lateral única con portadora reducida y J, con portadora suprimida; A es doble banda lateral. El 3 indica un canal analógico y la E, telefonía. A1A es la telegrafía (CW).], tema: "T5")
#pq(3, 1, 17, "c", "estúdialo en: simulacros de estudio 4·1·17 · libro: T5.17", "Compresor: eleva la potencia media sin superar la de pico",
  [Un equipo de 100 W PEP transmite voz sin procesar con unos 10 W de potencia media. Al activar un compresor bien ajustado:],
  ([la potencia media baja y se reduce el splatter], [la potencia de pico sube por encima de 100 W], [la potencia media sube a unos 20 a 40 W y la de pico sigue en 100 W], [se estrecha la banda de audio transmitida],),
  sol: [El compresor sube las sílabas débiles sin tocar los picos: la potencia media crece de 3 a 6 dB mientras la de pico, que limita el equipo, se mantiene. Superar la potencia de pico es justo lo que no hace. El compresor tampoco cambia la anchura de banda del audio.], tema: "T5")
#pq(3, 1, 18, "d", "estúdialo en: simulacros de estudio 5·1·19 · libro: F-T5.7", "Ubicación de los repetidores: lugares elevados para aumentar el alcance (visibilidad directa)",
  [Para ampliar la zona de cobertura de un repetidor de VHF, la medida más eficaz es:],
  ([aumentar la anchura de banda de su emisión], [instalarlo en un valle, protegido de las interferencias], [bajar su frecuencia para aprovechar la reflexión en la ionosfera], [instalar su antena en un punto más elevado, con visión directa sobre la zona],),
  sol: [En VHF la onda viaja prácticamente en línea recta y el alcance lo marca el horizonte radioeléctrico, que crece con la altura de la antena: por eso los repetidores van en montes y torres. En un valle vería menos terreno. La ionosfera no refleja las frecuencias de VHF y una emisión más ancha no llega más lejos.], tema: "T5")
#pq(3, 1, 19, "b", "estúdialo en: simulacros de estudio 4·1·20 · libro: T6.37", "Yagi: los elementos parásitos no están alimentados y dan la directividad",
  [En una Yagi de cuatro elementos, los elementos conectados a la línea de alimentación son:],
  ([todos, cada uno con su propio cable en fase], [solo uno, el radiante; los demás toman la energía del campo del radiante], [dos: el reflector y el radiante], [los directores, que son los que forman el haz],),
  sol: [Solo el radiante recibe energía del cable. El reflector y los directores son elementos parásitos: el campo del radiante induce en ellos una corriente que reirradian con otra fase, y por interferencia el conjunto concentra la energía en una dirección. No necesitan conexión, y precisamente por eso se llaman parásitos.], tema: "T6")
#pq(3, 1, 20, "c", "estúdialo en: simulacros de estudio 8·1·19 · libro: C-T6.4", "Antena helicoidal: polarización circular, usada en enlaces por satélite",
  [En un enlace con un satélite, que gira y cambia de orientación, se prefiere una antena helicoidal porque:],
  ([radia por igual en todas las direcciones, sin necesidad de orientarla], [su polarización es horizontal, la única que la ionosfera no gira], [radia con polarización circular, que no depende de la orientación del satélite], [su ganancia no depende del número de espiras],),
  sol: [La hélice radia a lo largo de su eje con polarización circular, que gira con la onda y no depende de cómo quede orientado el satélite. Es directiva, de modo que hay que apuntarla, y su ganancia crece precisamente con el número de espiras.], tema: "T6")
#pq(3, 1, 21, "a", "estúdialo en: simulacros de estudio 3·1·21 · libro: T6.16", "Relación adelante-atrás: dB entre el lóbulo principal y el trasero",
  [En el diagrama de una Yagi, el lóbulo principal está a 0 dB y el lóbulo trasero a −18 dB. Su relación adelante-atrás es de:],
  ([18 dB], [3 dB], [9 dB], [36 dB],),
  sol: [La relación adelante-atrás es la diferencia en decibelios entre el lóbulo principal y el trasero: 0 − (−18) = 18 dB, un valor típico de una Yagi de tres elementos (15–20 dB). Los 3 dB recuerdan al criterio del ancho de haz, que es un ángulo y no una diferencia de nivel; dividir o duplicar los decibelios no tiene sentido aquí.], tema: "T6")
#pq(3, 1, 22, "d", "estúdialo en: simulacros de estudio 2·1·22 · libro: T6.15", "Acoplador de antena: adapta la impedancia del final a la línea y la antena (no mejora la antena)",
  [Tras ajustar el acoplador de antena, el medidor de ROE situado junto al transceptor marca 1:1. Puede afirmarse que:],
  ([el acoplador amplifica la señal hasta compensar la desadaptación], [la antena ha quedado resonante y su ganancia ha aumentado], [ya no hay onda estacionaria en ningún tramo de la línea], [el transmisor ve 50 Ω, aunque entre el acoplador y la antena la desadaptación sigue],),
  sol: [El acoplador transforma la impedancia que presentan la línea y la antena en los 50 Ω que pide la etapa final; no mejora la antena ni su ganancia. Entre el acoplador y la antena la desadaptación sigue ahí, con su onda estacionaria y sus pérdidas: el acoplador solo la esconde al transmisor. Tampoco amplifica nada: es una red de bobinas y condensadores.], tema: "T6")
#pq(3, 1, 23, "c", "estúdialo en: simulacros de estudio 8·1·24 · libro: T7.21", "Difracción: la onda bordea un obstáculo",
  [Detrás de un monte, cerca del transmisor, se recibe todavía una señal de HF, mientras que la de UHF del mismo transmisor no llega. ¿Qué fenómeno lo explica?],
  ([la reflexión en la cima del monte, que solo afecta a la HF], [la absorción, que en HF no existe], [la difracción, que es mayor cuanto más larga es la onda], [la refracción en la troposfera, que es mayor cuanto más alta es la frecuencia],),
  sol: [La difracción hace que la onda bordee el obstáculo y entre, debilitada, en la zona de sombra; es tanto mayor cuanto más larga es la onda comparada con el obstáculo. Por eso la HF salva un monte que en UHF deja sombra. La refracción es el cambio de dirección al pasar de un medio a otro, y la absorción existe en todas las bandas.], tema: "T7")
#pq(3, 1, 24, "b", "estúdialo en: simulacros de estudio 9·1·25 · libro: T7.6", "Frecuencia crítica: la máxima que se refleja en incidencia vertical",
  [Una onda de 5 MHz lanzada en vertical vuelve a tierra, y otra de 8 MHz, también en vertical, atraviesa la ionosfera. En ese momento, la frecuencia crítica está:],
  ([por encima de 8 MHz], [entre 5 y 8 MHz], [por debajo de 5 MHz], [sin poder acotarse, porque la frecuencia crítica se define con incidencia oblicua],),
  sol: [La frecuencia crítica es la máxima que se refleja con incidencia vertical: si 5 MHz vuelve, está por encima de 5 MHz, y si 8 MHz se pierde, está por debajo de 8 MHz. La que se define en un trayecto oblicuo es la MUF, no la frecuencia crítica.], tema: "T7")
#pq(3, 1, 25, "a", "estúdialo en: simulacros de estudio 7·1·24", "Zona de silencio: entre el final de la onda de superficie y la primera onda reflejada",
  [Operando en 14 MHz, te oye perfectamente una estación a 2000 km y, en cambio, no te oye otra situada a 100 km. ¿Cuál es la explicación más probable?],
  ([la estación de 100 km está en la zona de silencio, entre el final de la onda de superficie y el punto donde cae la primera onda reflejada], [la estación de 100 km está más allá del último salto de la onda], [la capa D absorbe solo las señales destinadas a distancias cortas], [a 100 km la onda directa y la reflejada llegan siempre en oposición y se anulan],),
  sol: [En HF la onda de superficie se agota en pocas decenas de kilómetros y la onda reflejada no cae a tierra hasta la distancia de salto: entre medias no llega señal, y esa franja es la zona de silencio. La estación de 2000 km está donde aterriza la onda reflejada. La capa D absorbe según la frecuencia, no según la distancia del corresponsal.], tema: "T7")
#pq(3, 1, 26, "d", "estúdialo en: simulacros de estudio 4·1·27 · libro: C-T8.3", "El dBm y el dBW son unidades de potencia",
  [¿Cuál de las siguientes unidades expresa una tensión y no una potencia?],
  ([el dBW], [el milivatio], [el dBm], [el dBμV],),
  sol: [El dBm (referido a 1 mW) y el dBW (referido a 1 W) son niveles de potencia, igual que el milivatio es una unidad de potencia. El dBμV es un nivel de tensión, referido a 1 μV.], tema: "T8")
#pq(3, 1, 27, "c", "estúdialo en: simulacros de estudio 12·1·26 · libro: T8.20", "S-meter: indica la intensidad de la señal recibida (es un instrumento de recepción)",
  [La indicación del S-meter de un receptor se obtiene normalmente a partir de:],
  ([la frecuencia del oscilador local], [la tensión de la fuente de alimentación del equipo], [la tensión del control automático de ganancia (CAG)], [la potencia reflejada en la línea de antena],),
  sol: [El S-meter indica la intensidad de la señal recibida: cuanto más fuerte llega, más reduce el receptor su ganancia, y esa tensión del CAG se traduce en puntos S. Es un instrumento de recepción: no mide la reflejada ni nada de la emisión.], tema: "T8")
#pq(3, 1, 28, "b", "estúdialo en: simulacros de estudio 6·1·28 · libro: T9.3", "Desadaptación (ROE alta) favorece las interferencias; conviene ROE baja",
  [¿Por qué una ROE alta en la línea de la antena aumenta el riesgo de interferencias dentro de la propia casa?],
  ([porque la desadaptación hace que la antena emita en frecuencias distintas de la de trabajo], [porque parte de la energía rebota por la línea, sube la tensión en el coaxial y su malla lleva corriente que hace radiar al propio cable], [porque la línea desadaptada se comporta como un filtro paso alto que deja salir los armónicos], [porque una ROE alta aumenta la sensibilidad de los receptores cercanos a cualquier señal],),
  sol: [Con la antena desadaptada, parte de la energía vuelve por la línea, sube la tensión en el coaxial y la malla lleva corriente de modo común: el cable radia dentro de casa, cerca de los equipos. Con la antena bien adaptada, la potencia se va por donde debe. La ROE no crea armónicos ni cambia la sensibilidad de los receptores vecinos.], tema: "T9")
#pq(3, 1, 29, "a", "estúdialo en: simulacros de estudio 12·1·29 · libro: T10.5", "Interferencia a servicios de seguridad de la vida humana, al móvil aeronáutico o a la ICT del edificio: dejar de emitir",
  [Un radioaficionado comprueba que sus emisiones, hechas dentro de una banda atribuida a la radioafición, interfieren a un servicio de seguridad de la vida humana. Debe:],
  ([dejar de emitir hasta que se resuelva el problema], [seguir emitiendo, porque lo hace en una banda atribuida a los radioaficionados], [reducir la potencia y continuar], [cambiar la polarización de su antena y continuar],),
  sol: [Cuando una interferencia afecta a la seguridad de la vida humana la norma es única e inmediata: dejar de emitir hasta resolver el problema. Que la banda esté atribuida a la radioafición no da derecho a interferir a esos servicios, y bajar la potencia o cambiar la polarización no garantiza que la interferencia desaparezca.], tema: "T10")
#pq(3, 1, 30, "a", "estúdialo en: simulacros de estudio 2·1·30 · libro: T10.30", "Antena en mástil propio, no en el de la antena colectiva",
  [Para ahorrarte un mástil, un vecino te propone fijar tu Yagi al mástil de la antena colectiva de televisión del edificio. Lo correcto es:],
  ([instalarla en un mástil propio, independiente del de la antena colectiva], [aceptarlo si la Yagi pesa poco], [aceptarlo si se pone a tierra el mástil], [aceptarlo si el mástil es de acero y aguanta el peso],),
  sol: [La antena de aficionado va en un mástil propio. Compartir el de la antena colectiva supone manipular una instalación que no es tuya y es fuente de interferencias y conflictos, por mucho que el mástil aguante o esté a tierra.], tema: "T10")
#fin-prueba()
#prueba(3, 2)
#pq(3, 2, 1, "b", "estúdialo en: simulacros de estudio 6·2·1 · libro: C-R1.3", "Deletreo de distintivo EA3RCQ: R Romeo, C Charlie, Q Quebec (no «Queen»), 3 Three",
  [Un operador deletrea su distintivo `EA3QRC` como «Echo Alfa Three Queen Romeo Charlie». ¿Qué palabra ha usado mal?],
  ([Three], [Queen], [Romeo], [Charlie],),
  sol: [La Q es Quebec; Queen es el distractor clásico de un alfabeto británico antiguo. Three es correcto, porque la cifra se dice en inglés, y Romeo y Charlie son las palabras oficiales de la R y la C.], tema: "R1")
#pq(3, 2, 2, "a", "estúdialo en: simulacros de estudio 8·2·3, 12·2·3 · libro: R2.31, R2.30", "QSL acuse de recibo frente a QSO comunicado entre dos estaciones",
  [En la jerga de los radioaficionados, «hicimos un \_\_\_ de media hora» y «te mando la \_\_\_». ¿Qué grupos completan las dos frases, en este orden?],
  ([`QSO` y `QSL`], [`QSL` y `QSO`], [`QSY` y `QSL`], [`QSO` y `QTC`],),
  sol: [Un contacto entre dos estaciones es un `QSO`, y la tarjeta que lo confirma es la `QSL`, del grupo de acuse de recibo. Intercambiarlos es la confusión típica; `QTC` son mensajes pendientes y `QSY`, cambio de frecuencia.], tema: "R2")
#pq(3, 2, 3, "c", "estúdialo en: simulacros de estudio 2·2·2 · libro: R2.27", "QTH posición o localidad (frente a QTR, QRA, QTC)",
  [En un QSO transmites «`QTH?`». ¿Qué le estás preguntando a tu corresponsal?],
  ([¿qué hora es exactamente?], [¿cómo se llama su estación?], [¿cuál es su posición o localidad?], [¿cuántos mensajes tiene para mí?],),
  sol: [`QTH` es la posición: «mi posición es…» y, con interrogación, la pregunta por ella. La hora exacta es `QTR`, el nombre de la estación es `QRA` y los mensajes pendientes, `QTC`: los cuatro se confunden porque todos informan de algo.], tema: "R2")
#pq(3, 2, 4, "a", "estúdialo en: simulacros de estudio 5·2·4 · libro: R2.20", "QSM repita el último mensaje",
  [Un desvanecimiento profundo te ha hecho perder entero el último mensaje. Para pedir que te lo repitan transmites:],
  ([`QSM`], [`QRS`], [`QTA`], [`QSZ`],),
  sol: [`QSM` pide repetir el último mensaje. `QSZ` pide transmitir cada palabra o grupo dos veces, que no recupera lo ya perdido; `QRS` pide ir más despacio y `QTA`, anular el mensaje.], tema: "R2")
#pq(3, 2, 5, "b", "estúdialo en: simulacros de estudio 1·2·5 · libro: R3.4", "DX contacto de larga distancia",
  [Un colega comenta que anoche «hizo DX» en 20 m. Eso quiere decir que:],
  ([estuvo escuchando sin transmitir], [contactó con estaciones muy lejanas], [transmitió en telegrafía], [contactó con estaciones de su misma ciudad],),
  sol: [`DX` es el contacto de larga distancia; «hacer DX» es buscar estaciones lejanas. La telegrafía es `CW`, y escuchar sin transmitir es lo que hace un radioescucha (`SWL`).], tema: "R3")
#pq(3, 2, 6, "c", "estúdialo en: simulacros de estudio 11·2·7 · libro: R3.18", "PSE por favor",
  [Quieres pedir con cortesía al corresponsal que repita su nombre: «… `RPT UR NAME`». ¿Qué abreviatura pones delante?],
  ([`TU`], [`SRI`], [`PSE`], [`TNX`],),
  sol: [`PSE` es «por favor», la fórmula para pedir algo con cortesía. `TNX` y `TU` dan las gracias (después, no antes de pedir) y `SRI` pide disculpas.], tema: "R3")
#pq(3, 2, 7, "b", "estúdialo en: simulacros de estudio 7·2·7 · libro: R3.31", "CFM confirmo",
  [Quieres dar por buena una información del corresponsal diciendo «confirmo». ¿Qué abreviatura usas?],
  ([`RPT`], [`CFM`], [`CUL`], [`QRZ`],),
  sol: [`CFM` (\_confirm\_) es «confirmo», como en «`R CFM JUAN`». `RPT` pide repetición, `CUL` es «hasta luego» y `QRZ`? pregunta quién llama.], tema: "R3")
#pq(3, 2, 8, "d", "estúdialo en: simulacros de estudio 3·2·8 · libro: F-R4.1", "Socorro captado: hacer lo posible para que llegue a la DG de Protección Civil y Emergencias (art. 30.5)",
  [Captas la llamada de socorro de un barco y nadie más parece responder. Según la Orden IET/1311/2013, ¿qué debes procurar?],
  ([anotar los datos y comunicarlos a la Jefatura Provincial en el plazo de un mes], [no intervenir, porque el socorro marítimo no es cosa de los radioaficionados], [retransmitirlo en todas las bandas para que lo oiga el mayor número de estaciones], [hacer lo posible para que llegue cuanto antes a la Dirección General de Protección Civil y Emergencias],),
  sol: [El art. 30.5 de la Orden obliga a quien capta una comunicación de socorro a hacer lo posible para que llegue cuanto antes a la Dirección General de Protección Civil y Emergencias, del Ministerio del Interior. Esperar un mes o desentenderse lo incumple, y repetirlo por todas las bandas solo crea confusión.], tema: "R4")
#pq(3, 2, 9, "a", "estúdialo en: simulacros de estudio 13·2·9 · libro: F-R4.12", "Banda de 2 m en la Región 1: 144–146 MHz",
  [Un transceptor comprado en Estados Unidos permite transmitir en 147,000 MHz. En España, esa frecuencia:],
  ([queda fuera de la banda de 2 m, que en la Región 1 va de 144 a 146 MHz], [requiere autorización especial], [está dentro de la banda de 2 m, que llega hasta 148 MHz], [es de aficionados, pero solo para satélites],),
  sol: [En la Región 1 la banda de 2 m es de 144 a 146 MHz; los 146 a 148 MHz son de aficionados en las Regiones 2 y 3, pero aquí son de fijo y móvil. Por eso un equipo americano puede emitir en frecuencias que en España no están autorizadas.], tema: "R4")
#pq(3, 2, 10, "c", "estúdialo en: simulacros de estudio 1·2·12 · libro: R5.22", "Mudarse de distrito: se conserva el distintivo (único e inmodificable); solo se comunica el domicilio",
  [EA8ABC se traslada de Las Palmas a Granada. Desde su nuevo domicilio emitirá con el distintivo:],
  ([EA7ABC, porque la cifra debe coincidir con el distrito de residencia], [EA7/EA8ABC, obligatoriamente, en todas sus emisiones], [EA8ABC, el mismo, y solo debe comunicar su nuevo domicilio], [uno nuevo de la serie EA7, que se le asignará por turno],),
  sol: [Con la Orden IET/1311/2013 el distintivo es único y no puede modificarse (art. 28); la cifra es la del distrito de residencia al otorgarlo, y mudarse solo obliga a comunicar el nuevo domicilio. Añadir el distrito desde el que se emite es opcional y pensado para móviles y portables. Los bancos antiguos (Orden de 2006, derogada) daban la regla contraria.], tema: "R5")
#pq(3, 2, 11, "a", "estúdialo en: simulacros de estudio 4·2·12 · libro: R5.36", "Distrito 0: solo para actos inaugurados o visitados por el Rey",
  [Una asociación quiere emitir con la cifra 0 en su distintivo con motivo de la inauguración de un museo. Podrá autorizarse si:],
  ([el acto es inaugurado o visitado por S. M. el Rey], [el evento es de relevancia internacional], [el acto lo inaugura el presidente de la comunidad autónoma], [la emisión se hace desde una estación desatendida],),
  sol: [La cifra 0 solo se autoriza con motivo de actos inaugurados o visitados por S. M. el Rey, y únicamente el día del acto. La relevancia internacional se refleja con prefijos temporales como AO, no con la cifra 0.], tema: "R5")
#pq(3, 2, 12, "b", "estúdialo en: simulacros de estudio 1·2·13, 8·2·13 · libro: C-R5.19, C-R5.2", "Sufijos excluidos: DDD, PAN, SOS, TTT, XXX y la serie QAA–QZZ",
  [Los grupos DDD, PAN, SOS, TTT y XXX no se asignan como sufijo de ningún distintivo porque:],
  ([están reservados a las estaciones automáticas desatendidas], [expresan señales de socorro, urgencia y seguridad, y una identificación no debe poder confundirse con ellas], [son grupos del código Q], [se reservan a las estaciones colectivas de los radioclubes],),
  sol: [El art. 27 los excluye por ser las señales de socorro, urgencia y seguridad. La serie Q también está excluida, pero por otro motivo: para no confundirse con el código Q. Las desatendidas y las colectivas tienen sus propias reservas (Y o Z; UR, RC o RK).], tema: "R5")
#pq(3, 2, 13, "d", "estúdialo en: simulacros de estudio 9·2·13 · libro: F-R5.3", "Res. 29-07-2026: asignación por distritos y orden de presentación, hasta 10 preferencias; el nuevo distintivo sustituye al anterior",
  [Dos radioaficionados del distrito 3 que cumplen los requisitos piden como primera preferencia el mismo distintivo con sufijo de una letra. Según la Resolución de 29 de julio de 2026, se le asignará:],
  ([a quien tenga más antigüedad en la autorización, y conservará también su distintivo anterior], [por sorteo entre ambos, y el ganador conservará también su distintivo anterior], [a quien aporte más tarjetas QSL, y el nuevo distintivo sustituirá al que ya tenía], [a quien haya presentado antes su solicitud, y el nuevo distintivo sustituirá al que ya tenía],),
  sol: [La Resolución asigna estos distintivos por distritos y por estricto orden de presentación de las solicitudes; ni la antigüedad, ni un sorteo, ni el número de QSL deciden. Además, el nuevo distintivo sustituye al que tuviera el titular, coherente con que el distintivo sea único.], tema: "R5")
#pq(3, 2, 14, "d", "estúdialo en: simulacros de estudio 3·2·13, 11·2·15 · libro: R6.14, C-R6.4", "Qué es un plan de bandas: reparto recomendado de cada banda por modo y anchura de banda; instrumento básico de ordenación",
  [¿Por qué el plan de bandas separa los segmentos de telegrafía de los de fonía en banda lateral única?],
  ([Para que cada país tenga asignado su propio segmento], [Porque la normativa prohíbe la fonía en los primeros kilohercios de cada banda], [Porque la telegrafía está reservada a los titulares más antiguos], [Para que las emisiones anchas no caigan sobre las estrechas y los distintos modos convivan sin interferirse],),
  sol: [El plan reparte cada banda por modo y anchura de banda: agrupa los modos estrechos por un lado y los anchos por otro para que no se pisen. No asigna segmentos por antigüedad de las estaciones ni por países.], tema: "R6")
#pq(3, 2, 15, "d", "estúdialo en: simulacros de estudio 5·2·15, 9·2·15 · libro: R6.7, C-R6.2", "Repetidores de 2 m: entrada 145,000–145,1875 MHz, salida 600 kHz más arriba",
  [La entrada de un repetidor de 2 m está en 145,0625 MHz. Según el plan de bandas, su salida estará en:],
  ([146,6625 MHz], [144,4625 MHz], [145,1225 MHz], [145,6625 MHz],),
  sol: [La salida de los repetidores de 2 m va 600 kHz más arriba que la entrada: 145,0625 + 0,600 = 145,6625 MHz, dentro de las salidas clásicas (145,600–145,7875 MHz). Restar los 600 kHz o sumar 1,6 MHz, el desplazamiento de 70 cm, son los errores típicos.], tema: "R6")
#pq(3, 2, 16, "d", "estúdialo en: simulacros de estudio 1·2·16 · libro: R7.6", "Decir «cambio» es recomendable, no obligatorio",
  [Al terminar tu turno en un QSO en fonía, olvidas decir «cambio». ¿Has cometido una infracción?],
  ([Sí, una infracción leve del Reglamento de Radiocomunicaciones], [Sí, porque es obligatorio en todas las emisiones en fonía], [Solo si el QSO es con una estación extranjera], [No: decir «cambio» es recomendable como buena práctica, pero no obligatorio],),
  sol: [Decir «cambio» al ceder la palabra es una buena práctica recomendable, no una obligación reglamentaria. Olvidarlo no es infracción; lo que sí es obligatorio es identificarse al comienzo y al final de cada emisión.], tema: "R7")
#pq(3, 2, 17, "c", "estúdialo en: simulacros de estudio 9·2·18 · libro: F-R8.13", "Orden IET/1311/2013: derogó la Orden ITC/1791/2006",
  [Una pregunta de un banco antiguo justifica su respuesta en la Orden ITC/1791/2006. Respecto de esa orden, hoy:],
  ([sigue vigente para las estaciones fijas, junto con el Real Decreto 2623/1986], [solo se aplica a las autorizaciones concedidas antes de julio de 2013], [está derogada expresamente por la Orden IET/1311/2013, que aprueba el reglamento vigente], [la derogó la Ley 11/2022 al aprobar la nueva Ley General de Telecomunicaciones],),
  sol: [La disposición derogatoria única de la Orden IET/1311/2013 deroga expresamente la Orden ITC/1791/2006, que aprobaba el reglamento anterior. Las autorizaciones anteriores no siguen rigiéndose por ella: conservaron su vigencia, pero quedaron sometidas al nuevo reglamento. Lo que la Orden de 2013 mantiene para las estaciones fijas es el Real Decreto 2623/1986, no la orden derogada.], tema: "R8")
#pq(3, 2, 18, "a", "estúdialo en: simulacros de estudio 5·2·17 · libro: F-R8.14", "Orden IET/1311/2013: entrada en vigor el día siguiente a su publicación",
  [El BOE del 12 de julio de 2013 publicó la Orden IET/1311/2013. ¿Desde qué fecha es aplicable el Reglamento que aprueba?],
  ([Desde el 13 de julio de 2013], [Desde el 1 de enero de 2014], [Desde el 12 de julio de 2013], [Desde el 1 de agosto de 2013],),
  sol: [Su disposición final cuarta fija la entrada en vigor el día siguiente al de su publicación: el 13 de julio de 2013. El 1 de agosto saldría de aplicar los veinte días de la regla general del Código Civil, que solo rige cuando la norma no dice otra cosa, y aquí sí lo dice.], tema: "R8")
#pq(3, 2, 19, "b", "estúdialo en: simulacros de estudio 6·2·19 · libro: R8.40", "Distintivo de los repetidores analógicos: Morse ≤ 10 palabras/min, cada ≤ 10 min",
  [Un repetidor analógico está programado para identificarse automáticamente cada doce minutos. Según el artículo 25.d:],
  ([cumple, porque si se identifica en Morse la norma solo limita la velocidad, no el intervalo], [no cumple, porque debe identificarse a intervalos no superiores a diez minutos], [no cumple, porque debe identificarse a intervalos no superiores a tres minutos], [cumple, porque el intervalo máximo es de quince minutos],),
  sol: [El art. 25.d dispone que los repetidores analógicos emitan su distintivo de forma automática, en radiotelefonía o en Morse (a no más de diez palabras por minuto), a intervalos no superiores a diez minutos. Doce minutos superan ese límite, también si la identificación es en Morse. Los tres minutos son el intervalo de las radiobalizas (art. 25.e), y los quince minutos no figuran en la Orden.], tema: "R8")
#pq(3, 2, 20, "d", "estúdialo en: simulacros de estudio 9·2·21 · libro: F-R8.74", "Disposición final 2.ª: la SETSI dicta instrucciones y actualiza los anexos técnicos",
  [Si un cambio del Derecho de la Unión Europea obliga a actualizar el contenido técnico de los anexos de la Orden IET/1311/2013, ¿quién está facultado para revisarlo, según la disposición final segunda?],
  ([solo las Cortes Generales, mediante una ley], [la IARU Región 1, al actualizar su plan de bandas], [la CEPT, cuyas recomendaciones modifican directamente los anexos], [la SETSI, que puede revisar el contenido técnico de los anexos para actualizarlos conforme al Derecho de la Unión Europea y al Derecho internacional],),
  sol: [La disposición final segunda faculta a la SETSI para dictar las instrucciones necesarias para aplicar el Reglamento y para revisar el contenido técnico de sus anexos, con el fin de actualizarlos conforme al Derecho de la Unión Europea y al Derecho internacional. También la faculta para establecer los modelos de solicitud. Ni la CEPT ni la IARU modifican la norma española.], tema: "R8")
#pq(3, 2, 21, "c", "estúdialo en: simulacros de estudio 12·2·20 · libro: R8.84", "Licencia CEPT: respetar siempre el RR y la reglamentación del país visitado",
  [En el país que visitas con licencia CEPT, la potencia máxima de una banda es inferior a la española. ¿Qué potencia puedes usar?],
  ([la máxima española, porque tu licencia es española], [la máxima española reducida al 50 %], [la máxima del país visitado, porque debes respetar su reglamentación y el Reglamento de Radiocomunicaciones], [la mayor de las dos],),
  sol: [La licencia CEPT ahorra el trámite, no las reglas: se opera con las bandas, potencias y condiciones del país en que uno se encuentra y con sujeción al Reglamento de Radiocomunicaciones (art. 14.d). Por eso manda la potencia máxima del país visitado. El 50 % es la rebaja de las bandas secundarias en España, sin relación con esto.], tema: "R8")
#pq(3, 2, 22, "b", "estúdialo en: simulacros de estudio 1·2·20 · libro: F-R8.32", "Licencia CEPT de otro país en España: equiparada, solo para no residentes en estancias temporales",
  [Un radioaficionado de un país que ha adoptado la T/R 61-01 fija su residencia en España. ¿Puede seguir operando aquí solo con la licencia CEPT de su país?],
  ([Sí, si su país pertenece a la Unión Europea], [No: la licencia CEPT extranjera solo surte efectos para no residentes, durante sus estancias temporales], [Sí, sin límite de tiempo, porque está equiparada a la autorización española], [Sí, durante sus primeros 90 días de residencia],),
  sol: [El art. 13 equipara la licencia CEPT de otro país a la autorización española, pero exclusivamente para extranjeros no residentes y durante sus estancias temporales. Quien fija su residencia necesita la autorización española, que puede obtener examinándose o, sin examen, con un HAREC o por convenio de reciprocidad (art. 5.2). Los 90 días son los de la autorización temporal del art. 15, para países sin la T/R 61-01.], tema: "R8")
#pq(3, 2, 23, "c", "estúdialo en: simulacros de estudio 7·2·21 · libro: C-R8.44", "Vigencia indefinida: no se renueva; suprimida la comunicación quinquenal",
  [Una autorización de radioaficionado concedida en 2014, cuyo titular no ha hecho desde entonces ningún trámite, en 2026:],
  ([caducó en 2024, al cumplir diez años sin renovarse], [sigue vigente solo si el titular dispone de licencia de estación fija], [sigue vigente, porque conserva su vigencia mientras el titular no renuncie o sea revocada], [caducó en 2019, al no comunicar en cinco años la intención de seguir usando el espectro],),
  sol: [La autorización tiene vigencia indefinida (art. 5.4): no se renueva, y la antigua comunicación quinquenal quedó suprimida con sus efectos (disposición adicional primera). Por eso no caduca por el paso del tiempo. Tampoco depende de tener estación fija, que no es obligatoria.], tema: "R8")
#pq(3, 2, 24, "c", "estúdialo en: simulacros de estudio 3·2·21 · libro: C-R8.23", "Revocación de la autorización: no se puede emitir; se cancelan el distintivo y la licencia de estación fija asociada",
  [Señala cuál de estas consecuencias NO se deriva de la revocación de la autorización de radioaficionado:],
  ([La cancelación de la licencia de estación fija asociada], [La baja del distintivo de llamada], [La pérdida del certificado HAREC], [La prohibición de emitir hasta obtener una nueva autorización],),
  sol: [Revocada la autorización, no se puede emitir, se da de baja el distintivo asociado y se cancela la licencia de estación fija (art. 21.1.b). El HAREC, en cambio, acredita haber superado un examen y no caduca: no se pierde con la revocación, que afecta a la autorización y a lo que depende de ella.], tema: "R8")
#pq(3, 2, 25, "b", "estúdialo en: simulacros de estudio 6·2·27 · libro: F-R8.4", "Soportes: a la obra civil o con repartidores de carga; nunca a pararrayos ni a conducciones eléctricas",
  [En la azotea hay un mástil de pararrayos muy robusto, un poste de una línea eléctrica aérea y un muro de carga. ¿Dónde puedes fijar el soporte de tu antena?],
  ([Al mástil del pararrayos, por ser el elemento más robusto], [Al muro de carga, directamente en puntos aptos o mediante un elemento repartidor de carga], [Al poste de la línea eléctrica, siempre que se usen aisladores], [A cualquiera de los tres, si un instalador inscrito lo certifica],),
  sol: [El art. 17 prohíbe fijar los soportes de las antenas a soportes o anclajes de pararrayos y de conducciones aéreas de energía eléctrica, por robustos que sean. Se fijan a la obra civil en puntos aptos para los esfuerzos, o con repartidores de carga debidamente dimensionados. Ningún certificado de instalador levanta esa prohibición.], tema: "R8")
#pq(3, 2, 26, "a", "estúdialo en: simulacros de estudio 11·2·26 · libro: F-R8.52", "Varias desatendidas en una autorización: misma modulación, titularidad y ubicación",
  [Una asociación reconocida tiene dos repetidores analógicos de FM de su titularidad, instalados en dos montes distintos. ¿Pueden ampararse en una única autorización de radioaficionado?],
  ([No, porque no comparten ubicación], [Sí, porque tienen el mismo tipo de modulación y la misma titularidad], [Sí, porque todas las desatendidas de una misma asociación caben en una sola autorización], [No, porque cada estación desatendida necesita siempre su propia autorización, sin excepciones],),
  sol: [El art. 18.8 permite amparar varias estaciones automáticas desatendidas en una única autorización solo si se cumplen a la vez tres condiciones: mismo tipo de modulación, misma titularidad y misma ubicación. Aquí falta la tercera, así que rige la regla general de una autorización individualizada por estación. Decir que nunca hay excepción también es falso: con las tres condiciones, sí cabe una sola autorización.], tema: "R8")
#pq(3, 2, 27, "a", "estúdialo en: simulacros de estudio 8·2·27 · libro: C-R8.10", "Número de desatendidas: según las necesidades del servicio (cobertura y canales)",
  [Según el artículo 25.a, ¿qué criterio sigue la Administración para decidir si autoriza un nuevo repetidor en una zona?],
  ([la cobertura del servicio ya existente y la disponibilidad de canales], [un cupo fijo de un repetidor por banda y provincia], [el número de socios de la asociación que lo solicita], [el orden de presentación de las solicitudes, sin otro límite],),
  sol: [El número de estaciones automáticas desatendidas se autoriza en función de la cobertura del servicio preexistente y de la disponibilidad de canales, es decir, según las necesidades del servicio. No hay cupos fijos por provincia o banda, ni cuenta el tamaño de la asociación. Tampoco se autorizan sin límite por orden de llegada: los canales disponibles son limitados.], tema: "R8")
#pq(3, 2, 28, "d", "estúdialo en: simulacros de estudio 6·2·28 · libro: R9.31", "Los inspectores tienen la consideración de autoridad pública",
  [Durante una visita a tu estación coinciden varias personas. ¿Cuál de ellas actúa como autoridad pública?],
  ([el responsable de la sección provincial de una asociación de radioaficionados], [el instalador de telecomunicaciones inscrito que montó la antena], [el presidente de la comunidad de propietarios donde está la antena], [el funcionario de la inspección de telecomunicaciones que comprueba una estación],),
  sol: [La Ley 11/2022 da al personal de la inspección de telecomunicaciones la consideración de autoridad pública: por eso sus actas tienen fuerza y negarse u obstruir su labor es infracción. El instalador inscrito es un profesional privado, aunque su intervención sea obligatoria para montar la estación fija. Ni la comunidad de propietarios ni las asociaciones ejercen potestad pública alguna.], tema: "R9")
#pq(3, 2, 29, "a", "estúdialo en: simulacros de estudio 13·2·28 · libro: R9.22", "Muy grave: no atender el requerimiento de cese de emisiones",
  [La Administración requiere a Luis que cese sus emisiones porque interfieren a otro servicio, pero él sigue emitiendo. Desatender ese requerimiento es, según la Ley 11/2022:],
  ([una infracción muy grave, distinta de la propia interferencia], [una infracción leve, si después corrige la interferencia], [ninguna infracción añadida: solo cuenta la interferencia original], [una infracción grave, la misma que la interferencia que lo motivó],),
  sol: [No atender el requerimiento de cese de emisiones es infracción muy grave por sí misma (art. 106.8), aparte de la interferencia que lo provocó, que si no es deliberada es grave (art. 107.6). Ya no se trata solo de interferir, sino de desobedecer a la autoridad. Corregir después la causa no rebaja el grado de lo ya cometido.], tema: "R9")
#pq(3, 2, 30, "d", "estúdialo en: simulacros de estudio 3·2·29, 11·2·30 · libro: R9.6, R9.10", "Prescripción: 3 años muy graves, 2 graves, 1 leves",
  [Hace 18 meses un radioaficionado cometió una infracción leve que la Administración no ha perseguido. ¿Puede sancionarse todavía?],
  ([Sí, porque las infracciones leves prescriben a los dos años], [Sí, porque las infracciones administrativas no prescriben], [Sí, mientras no pasen tres años, el plazo común a todas], [No, porque las infracciones leves prescriben al año],),
  sol: [Las infracciones prescriben a los tres años las muy graves, a los dos las graves y al año las leves (art. 113 de la Ley 11/2022). Con 18 meses, la leve ya ha prescrito. Dos años es el plazo de las graves y tres el de las muy graves; no hay un plazo único, y ninguna infracción administrativa es imprescriptible.], tema: "R9")
#fin-prueba()
#soluciones-simulacro(3)

// ======================================================================
#simulacro(4)
#prueba(4, 1)
#pq(4, 1, 1, "c", "estúdialo en: simulacros de estudio 2·1·1, 13·1·4 · libro: T1.20, F-T1.5", "Conversión entre valores de pico, pico a pico y eficaz de una sinusoide (V_ef = V_p / √2)",
  [Se comparan dos tensiones sinusoidales: A, de 10 V eficaces, y B, de 24 V de pico a pico. ¿Cuál tiene mayor valor eficaz?],
  ([B, porque 24 V es más del doble de 10 V], [B, porque equivale a unos 17 V eficaces], [A, porque B equivale a unos 8,5 V eficaces], [B, porque equivale a unos 12 V eficaces],),
  sol: [B tiene $24 slash 2 = 12$ V de pico y $12 slash sqrt(2) approx 8","5$ V eficaces, menos que los 10 V de A. Los 17 V salen de dividir el pico a pico directamente entre $sqrt(2)$, y los 12 V toman el valor de pico como si fuera el eficaz.], tema: "T1")
#pq(4, 1, 2, "a", "estúdialo en: simulacros de estudio 1·1·3 · libro: F-T1.7", "Señales no sinusoidales: fundamental y armónicos (onda cuadrada: solo impares)",
  [Una señal periódica no sinusoidal de 1 kHz se descompone en su fundamental y sus armónicos. ¿Cuál de estas frecuencias no puede ser uno de sus armónicos?],
  ([1,5 kHz], [3 kHz], [5 kHz], [2 kHz],),
  sol: [Los armónicos son siempre múltiplos enteros de la fundamental: 2, 3, 4, 5 kHz… Los 1,5 kHz serían 1,5 veces la fundamental, que no es un número entero. En una onda cuadrada simétrica solo habría armónicos impares, pero 2 kHz sí puede ser armónico de una señal no sinusoidal cualquiera.], tema: "T1")
#pq(4, 1, 3, "a", "estúdialo en: simulacros de estudio 4·1·4 · libro: F-T1.14", "Potencia de AM: P_t = P_c (1 + m²/2), reparto entre portadora y bandas",
  [Una portadora de AM de 200 W se modula con un índice $m = 0","5$. La potencia de cada banda lateral es de:],
  ([12,5 W], [225 W], [50 W], [25 W],),
  sol: [Cada banda lateral lleva $(m^2 slash 4) P_c = (0","25 slash 4) times 200 = 12","5$ W, y el total es $P_c (1 + m^2 slash 2) = 225$ W. Los 25 W son la suma de las dos bandas; los 50 W salen de olvidar elevar $m$ al cuadrado, y los 225 W son la potencia total de la emisión.], tema: "T1")
#pq(4, 1, 4, "d", "estúdialo en: simulacros de estudio 1·1·4, 6·1·5 · libro: T1.30, F-T1.37", "Referencias de decibelios: ×2 = +3 dB, ×4 = +6 dB, ×10 = +10 dB, ÷2 = −3 dB",
  [Una línea de transmisión con 10 dB de pérdida recibe 50 W. A la antena llegan:],
  ([25 W], [0,5 W], [40 W], [5 W],),
  sol: [Una pérdida de 10 dB divide la potencia entre 10: $50 slash 10 = 5$ W. Los 40 W restan los decibelios de los vatios; los 0,5 W corresponderían a 20 dB de pérdida y los 25 W, a 3 dB.], tema: "T1")
#pq(4, 1, 5, "c", "estúdialo en: simulacros de estudio 4·1·5, 10·1·4 · libro: F-T1.42, T1.32", "Teorema de Nyquist: f_s ≥ 2 f_máx",
  [Según el teorema de muestreo, para fijar una sinusoide hacen falta, como mínimo:],
  ([cuatro muestras por período], [diez muestras por período], [dos muestras por período], [una muestra por período],),
  sol: [Muestrear a $f_s >= 2 f$ equivale a tomar al menos dos muestras en cada período de la sinusoide. Con menos, los mismos puntos encajan también en otra sinusoide de frecuencia más baja y aparece el aliasing; tomar más muestras es posible, pero no es el mínimo.], tema: "T1")
#pq(4, 1, 6, "b", "estúdialo en: simulacros de estudio 12·1·8 · libro: T2.11", "Electrolítico: polarizado, hay que respetar la polaridad",
  [¿Qué le ocurre a un condensador electrolítico si se conecta con la polaridad invertida?],
  ([funciona igual, porque en continua la polaridad no importa], [se degrada y puede llegar a reventar], [su capacidad aumenta ligeramente], [se comporta como un diodo y rectifica la tensión],),
  sol: [Los electrolíticos son polarizados: la capa de óxido que hace de dieléctrico solo se mantiene con la polaridad correcta, y conectados al revés se degradan y pueden reventar. Por eso siempre se respeta la marca de polaridad. Pensar que la polaridad no importa en continua es justo el error que destruye el componente.], tema: "T2")
#pq(4, 1, 7, "a", "estúdialo en: simulacros de estudio 9·1·5 · libro: F-T2.8", "Efecto pelicular: en RF la corriente va por la superficie y la resistencia efectiva aumenta",
  [En algunos circuitos de RF las bobinas se hacen con tubo de cobre hueco o con hilo plateado. ¿Por qué?],
  ([porque en RF la corriente circula casi solo por la superficie del conductor, de modo que el interior apenas aporta y conviene que la superficie conduzca bien], [porque en RF la corriente se concentra en el centro del conductor, y el tubo la obliga a repartirse por toda la sección], [porque el aire del interior del tubo aumenta la autoinducción de la bobina sin añadir espiras], [porque a frecuencias altas la resistencia del conductor disminuye, y el tubo y la plata la vuelven a subir],),
  sol: [Por el efecto pelicular, la corriente de RF se concentra en una corteza muy fina de la superficie: el interior de una barra maciza no trabaja y un tubo hueco conduce casi igual. Como la corriente va por fuera, platear la superficie mejora la conducción. Por esa misma razón la resistencia efectiva en RF aumenta, no disminuye.], tema: "T2")
#pq(4, 1, 8, "b", "estúdialo en: simulacros de estudio 8·1·7 · libro: C-T2.5", "El transformador son dos bobinas acopladas que transforman una alterna en otra alterna",
  [¿Cómo pasa la energía del primario al secundario de un transformador?],
  ([por la corriente continua que pasa del primario al secundario a través del núcleo], [a través del flujo magnético que comparten las dos bobinas, sin conexión eléctrica entre ellas], [por un condensador interno que une ambos devanados], [por conducción directa a través de las espiras, que están soldadas entre sí],),
  sol: [El transformador son dos bobinas acopladas: la alterna del primario crea un flujo variable que atraviesa el secundario e induce en él otra tensión alterna. No hay unión eléctrica entre devanados, y por eso el transformador también aísla el equipo de la red. Con continua el flujo no cambia y no se transfiere nada.], tema: "T2")
#pq(4, 1, 9, "d", "estúdialo en: simulacros de estudio 10·1·8 · libro: C-T2.7", "Con continua en el primario no hay corriente en el secundario",
  [Por error se conecta el primario de un transformador de 230/12 V a una batería de 12 V. Una vez establecida la corriente, ¿qué tensión aparece en el secundario?],
  ([12 V], [230 V], [unos 0,6 V], [ninguna],),
  sol: [Un transformador solo induce tensión en el secundario si el flujo cambia; con continua el flujo es constante y no se induce nada. Los 0,6 V salen de aplicar la relación de espiras ($12 dot 12 / 230$), que solo vale en alterna.], tema: "T2")
#pq(4, 1, 10, "c", "estúdialo en: simulacros de estudio 13·1·12 · libro: F-T3.8", "Regulador con zéner y resistencia en serie: reparto de corrientes entre zéner y carga",
  [Una fuente de 15 V alimenta, a través de una resistencia en serie de 200 Ω, un zéner de 9 V en paralelo con una carga que consume 20 mA. Si se desconecta la carga, la corriente por el zéner pasa a ser de:],
  ([45 mA], [10 mA], [30 mA], [75 mA],),
  sol: [La resistencia en serie soporta $15 - 9 = 6$ V y deja pasar $6 slash 200 = 30$ mA, mientras el zéner mantenga sus 9 V. Con carga, el zéner absorbe $30 - 20 = 10$ mA; sin ella, absorbe los 30 mA enteros. Los 10 mA son la corriente que tenía antes; 45 mA salen de aplicar 9 V a la resistencia y 75 mA, de aplicarle los 15 V completos.], tema: "T3")
#pq(4, 1, 11, "a", "estúdialo en: simulacros de estudio 3·1·11 · libro: C-T3.19", "Fuente lineal frente a conmutada: la lineal pesa (transformador de 50 Hz) y rinde poco; la conmutada trabaja a decenas–cientos de kHz, ligera y eficiente",
  [El transformador de una fuente conmutada puede ser mucho más pequeño y ligero que el de una fuente lineal de la misma potencia porque:],
  ([trabaja a decenas o cientos de kHz, y a mayor frecuencia hacen falta menos hierro y menos espiras], [no necesita aislar la salida de la red], [trabaja a 100 Hz, el doble de la frecuencia de la red], [el regulador lineal que lleva detrás absorbe la mayor parte de la potencia],),
  sol: [El tamaño de un transformador depende de la frecuencia: a 100 kHz uno muy pequeño maneja lo que a 50 Hz pediría varios kilos. Por eso la conmutada es ligera, mientras que la lineal, con su transformador de 50 Hz, pesa mucho. El transformador de la conmutada sigue aislando la salida de la red, y los 100 Hz son la frecuencia del rizado de un puente, no la de conmutación.], tema: "T3")
#pq(4, 1, 12, "b", "estúdialo en: simulacros de estudio 6·1·13 · libro: T3.11", "Clase AB: combinación de A y B; la de los amplificadores lineales de SSB",
  [En un amplificador en contrafase, para eliminar la distorsión de cruce se da a los transistores una pequeña corriente de reposo. El amplificador trabaja entonces en clase:],
  ([A], [AB], [B], [C],),
  sol: [Con una pequeña corriente de reposo cada transistor conduce algo más de 180°: es la clase AB, una combinación de la A y la B que elimina la distorsión de cruce de la clase B y gasta bastante menos que la A. Sin esa corriente de reposo sería clase B pura, con la distorsión de cruce.], tema: "T3")
#pq(4, 1, 13, "b", "estúdialo en: simulacros de estudio 5·1·14 · libro: T3.13", "Mezclador (heterodinación): a la salida aparecen la suma y la diferencia f1 ± f2",
  [Se quiere mezclar una señal de 21,2 MHz con la de un oscilador local para obtener una frecuencia intermedia de 9 MHz. De las siguientes, la frecuencia del oscilador local que sirve es:],
  ([9 MHz], [12,2 MHz], [2,36 MHz], [190,8 MHz],),
  sol: [El mezclador entrega la suma y la diferencia de sus dos entradas: con 12,2 MHz, $21","2 - 12","2 = 9$ MHz. Los 9 MHz confunden la frecuencia del oscilador con la FI que se quiere obtener; 2,36 MHz es el cociente y 190,8 MHz el producto de las dos frecuencias, que no aparecen como tales a la salida.], tema: "T3")
#pq(4, 1, 14, "c", "estúdialo en: simulacros de estudio 11·1·13 · libro: F-T3.24", "Bloques del PLL: comparador de fase, filtro de paso bajo (de lazo), VCO y divisor programable",
  [En un lazo de enganche de fase (PLL), la función del filtro de lazo, de paso bajo, es:],
  ([eliminar los armónicos de la señal antes de enviarla a la antena], [dividir la frecuencia del VCO por $N$ antes de compararla], [alisar la tensión de error del comparador y convertirla en la tensión continua de control del VCO], [comparar la fase de la referencia con la del VCO],),
  sol: [El comparador de fase entrega una tensión de error; el filtro de lazo, de paso bajo, la alisa y la convierte en la tensión de control continua con la que el VCO corrige su frecuencia. Dividir por $N$ es tarea del divisor programable y comparar las fases, del comparador. Quitar armónicos a la salida de un transmisor es cosa del filtro paso bajo del paso final, no del lazo.], tema: "T3")
#pq(4, 1, 15, "a", "estúdialo en: simulacros de estudio 10·1·16 · libro: C-T4.1", "La etapa detectora demodula (extrae la información)",
  [La etapa de un receptor que recupera la voz o el morse que transportaba la portadora recibe el nombre de:],
  ([detector], [amplificador de frecuencia intermedia], [limitador], [mezclador],),
  sol: [Detectar es demodular: el detector extrae la información de la señal modulada. El mezclador solo traslada la señal a la FI y la sigue entregando modulada; el limitador recorta la amplitud en los receptores de FM, y el amplificador de FI da ganancia y selectividad.], tema: "T4")
#pq(4, 1, 16, "d", "estúdialo en: simulacros de estudio 7·1·14 · libro: T4.34", "Detector de producto con BFO: imprescindible en SSB y CW (no en AM ni FM)",
  [Recibes una emisión de telegrafía (CW) con el receptor en modo AM, con el BFO desconectado. Lo que oyes es:],
  ([un tono limpio que suena y calla al ritmo del morse], [el mismo morse, con un tono algo más grave], [dos tonos superpuestos, uno por cada banda lateral], [apenas un golpe sordo al empezar y acabar cada raya, sin ningún tono],),
  sol: [La CW es una portadora que se conecta y desconecta: un detector de envolvente solo nota cuándo empieza y acaba, y no produce tono alguno. Para oír el tono hace falta el detector de producto con el BFO, que bate con la portadora recibida y da, por ejemplo, 700 Hz. Lo mismo ocurre con la SSB, que sin BFO resulta ininteligible.], tema: "T4")
#pq(4, 1, 17, "d", "estúdialo en: simulacros de estudio 7·1·17 · libro: T5.21", "Orden de bloques del emisor: modulador → amplificación y traslación → final → red de acoplo",
  [En un equipo emisor, el bloque situado inmediatamente antes de la red de acoplo a la antena es:],
  ([la cadena de amplificación y traslación de frecuencia], [el oscilador], [el modulador], [el amplificador final],),
  sol: [El orden es modulador, cadena de amplificación y traslación de frecuencia, amplificador final y red de acoplo. Primero se modula a bajo nivel, luego se amplifica y se lleva a la frecuencia de trabajo, después se sube la potencia y lo último antes de la línea es la adaptación a la antena.], tema: "T5")
#pq(4, 1, 18, "b", "estúdialo en: simulacros de estudio 12·1·17 · libro: F-T5.10", "Los multiplicadores multiplican también la desviación de FM",
  [Para conseguir ±5 kHz de desviación en 144 MHz con un oscilador de 8 MHz seguido de una cadena ×18, ¿cuánto hay que desviar el oscilador?],
  ([±5 kHz], [±278 Hz], [±90 kHz], [±35 Hz],),
  sol: [La cadena multiplica también la desviación, así que en el oscilador basta $5000 slash 18 approx 278$ Hz. Los ±5 kHz suponen que la desviación no cambia; los ±90 kHz salen de multiplicar por 18 en lugar de dividir, y los ±35 Hz, de dividir por 144.], tema: "T5")
#pq(4, 1, 19, "d", "estúdialo en: simulacros de estudio 2·1·17 · libro: T5.9", "Espurias por debajo de 30 MHz: 40 dB bajo la potencia media, sin exceder de 50 mW",
  [El límite de emisiones no esenciales de «40 dB por debajo de la potencia media, sin exceder de 50 mW» se aplica a las frecuencias:],
  ([superiores a 960 MHz], [de 30 a 235 MHz], [de 235 a 960 MHz], [inferiores a 30 MHz],),
  sol: [Según el Anexo I, 4.1.1 de la Orden IET/1311/2013, por debajo de 30 MHz las espurias deben quedar 40 dB por debajo de la potencia media sin superar 50 mW, sea cual sea la potencia. Por encima de 30 MHz los topes son distintos y dependen de la potencia del transmisor: por ejemplo, entre 30 y 235 MHz, 1 mW o 25 µW.], tema: "T5")
#pq(4, 1, 20, "b", "estúdialo en: simulacros de estudio 11·1·19 · libro: T6.1", "Longitud del dipolo de media onda (≈ λ/2: 20 m para la banda de 40 m) y tamaño de la antena en función de la longitud de onda",
  [Un dipolo de media onda de hilo, alimentado en el centro, mide en total unos 10 m. ¿En qué banda resuena?],
  ([En la de 80 m], [En la de 20 m], [En la de 40 m], [En la de 10 m],),
  sol: [El dipolo de media onda mide aproximadamente $lambda slash 2$, así que 10 m de hilo corresponden a $lambda approx 20$ m: la banda de 20 m (a 14,2 MHz, $L approx 143 slash 14","2 approx 10$ m). Responder «10 m» confunde la longitud de la antena con el nombre de la banda, que es la longitud de onda; «40 m» saldría si el hilo midiera un cuarto de onda.], tema: "T6")
#pq(4, 1, 21, "c", "estúdialo en: simulacros de estudio 12·1·20", "Impedancia de la vertical de cuarto de onda (≈ 36 Ω) y radiales inclinados (sube hacia 50 Ω)",
  [La impedancia de una vertical de cuarto de onda con radiales horizontales es, comparada con la de un dipolo de media onda alimentado en el centro:],
  ([aproximadamente el doble], [unas cuatro veces mayor], [aproximadamente la mitad], [prácticamente igual],),
  sol: [La vertical es medio dipolo: el plano de tierra aporta la otra mitad por imagen, pero solo radia hacia el hemisferio superior y, con la misma corriente, entrega la mitad de potencia. Su resistencia de radiación es la mitad, unos 73/2 ≈ 36 Ω. Cuatro veces mayor es el dipolo plegado; inclinar los radiales hacia abajo sube la impedancia hacia 50 Ω, pero sigue por debajo de 73 Ω.], tema: "T6")
#pq(4, 1, 22, "a", "estúdialo en: simulacros de estudio 2·1·21 · libro: C-T6.3", "Margen de la ROE: siempre ≥ 1; funcionamiento adecuado entre 1 y 2,5",
  [Un aficionado anota que su antena presenta una ROE de 0,8. Ese dato:],
  ([no puede ser correcto, porque la ROE vale siempre 1 o más], [indica que se refleja el 80 % de la potencia], [es el valor normal de un dipolo bien ajustado], [indica una adaptación mejor que la perfecta],),
  sol: [La ROE es el cociente entre el máximo y el mínimo de la onda estacionaria, y el máximo nunca es menor que el mínimo: vale como poco 1, que es la adaptación perfecta. Para un funcionamiento adecuado debe quedar entre 1 y 2,5. Una ROE de 0,8 no existe, así que hay un error de medida o de anotación.], tema: "T6")
#pq(4, 1, 23, "d", "estúdialo en: simulacros de estudio 10·1·23 · libro: T7.5", "VHF y UHF: onda directa, distancias cortas",
  [Dos estaciones de 2 m en FM, en condiciones normales, se oyen bien a 30 km pero no a 300 km. ¿Cuál es la razón?],
  ([la capa D absorbe durante el día las señales de VHF], [la onda de superficie, que es la dominante en VHF, se agota antes de los 300 km], [la ionosfera devuelve la señal de VHF y la estación de 300 km queda en la zona de silencio], [en VHF la propagación habitual es la onda directa, limitada por el horizonte radioeléctrico],),
  sol: [En VHF y UHF la ionosfera es transparente y queda la onda directa, con un alcance poco mayor que el horizonte: decenas de kilómetros, de ahí que se use para distancias cortas. La zona de silencio y la absorción de la capa D son fenómenos de HF. La onda de superficie domina en MF y por debajo, no en VHF.], tema: "T7")
#pq(4, 1, 24, "c", "estúdialo en: simulacros de estudio 7·1·25 · libro: C-T7.2", "Rebote lunar (EME): VHF y superiores, sobre todo 144 MHz (ondas métricas)",
  [Un grupo de aficionados prepara su primer intento de rebote lunar (EME). ¿Qué banda y qué medios son los adecuados?],
  ([144 MHz con una antena vertical y 5 W, porque la Luna refleja casi toda la energía], [3,5 MHz de noche, cuando no hay capa D], [144 MHz, con antenas de gran ganancia, bastante potencia y modos digitales robustos], [14 MHz con un dipolo, porque la HF llega más lejos],),
  sol: [La señal tiene que atravesar la ionosfera dos veces, así que hace falta VHF o más, y la banda clásica es la de 2 m (ondas métricas). Las pérdidas son enormes, del orden de 250 dB, y la Luna refleja solo un 7 %: por eso hacen falta antenas de gran ganancia, potencia y modos capaces de decodificar por debajo del ruido. La HF, de día o de noche, se refleja o se absorbe en la ionosfera.], tema: "T7")
#pq(4, 1, 25, "a", "estúdialo en: simulacros de estudio 2·1·27 · libro: T8.25", "Potencia reflejada apreciable en el vatímetro direccional = desadaptación transmisor-antena",
  [Tras cambiar de banda sin reajustar el acoplador de antena, el vatímetro direccional pasa a indicar mucha potencia reflejada. Esto indica que:],
  ([en la nueva frecuencia hay desadaptación entre el transmisor y la antena], [la fuente de alimentación da poca tensión], [el transmisor entrega en la nueva banda más potencia de la nominal], [la antena tiene más ganancia en la nueva banda],),
  sol: [La potencia reflejada es la que la antena no acepta y vuelve hacia el transmisor: si es apreciable, hay desadaptación entre lo que el transmisor espera ver y lo que presenta la antena. La impedancia de la antena depende de la frecuencia de trabajo, y por eso al cambiar de banda hay que reajustar el acoplador. Ni la ganancia de la antena ni un exceso de potencia producen reflejada.], tema: "T8")
#pq(4, 1, 26, "b", "estúdialo en: simulacros de estudio 6·1·26 · libro: T8.6", "Frecuencímetro: medida precisa de la frecuencia (un voltímetro de RF no la mide)",
  [La exactitud de la medida de un frecuencímetro digital depende sobre todo de:],
  ([la resistencia de su entrada], [la estabilidad del oscilador de cristal de su base de tiempos], [el número de dígitos de su pantalla], [el nivel de la señal que se le aplica],),
  sol: [El frecuencímetro cuenta ciclos durante un tiempo que fija su base de tiempos de cristal: si el cristal se desvía, toda la medida se desvía con él, por muchos dígitos que muestre la pantalla. El tiempo de puerta fija la resolución, pero la exactitud la pone el cristal de referencia.], tema: "T8")
#pq(4, 1, 27, "c", "estúdialo en: simulacros de estudio 5·1·27 · libro: T9.21", "Compatibilidad electromagnética: no perturbar el entorno y no verse afectado por él",
  [Un equipo no molesta a nadie, pero deja de funcionar bien cada vez que un vecino transmite cerca. ¿Qué aspecto de la compatibilidad electromagnética le falla?],
  ([sus emisiones: perturba a los equipos de su entorno], [su rendimiento energético], [su inmunidad: no soporta el entorno electromagnético en que trabaja], [su seguridad eléctrica frente a contactos directos],),
  sol: [La compatibilidad electromagnética tiene dos caras: no perturbar el entorno (emisiones) y no verse afectado por él (inmunidad). Este equipo cumple la primera pero no la segunda. La seguridad eléctrica y el rendimiento no forman parte de la definición.], tema: "T9")
#pq(4, 1, 28, "d", "estúdialo en: simulacros de estudio 13·1·28 · libro: C-T9.3", "Cable blindado para los altavoces",
  [Sustituyes el cable de los altavoces de un equipo de música por cable blindado para que no capte la RF de tu estación. ¿Qué debe hacerse con la malla del cable?],
  ([dejarla sin conectar en los dos extremos], [conectarla a la fase de la red eléctrica], [conectarla entre los dos terminales del altavoz, en paralelo con él], [conectarla a masa, para que la RF inducida en ella se derive sin alcanzar los conductores interiores],),
  sol: [Un cable blindado lleva alrededor de sus conductores una malla conectada a masa que actúa como una jaula de Faraday alargada: la RF exterior induce corriente en la malla y se descarga a masa sin llegar al conductor interior. Una malla sin conectar no ofrece ese camino a masa.], tema: "T9")
#pq(4, 1, 29, "c", "estúdialo en: simulacros de estudio 6·1·30 · libro: T10.9", "Fusible fundido: sustituirlo por otro del mismo calibre (nunca mayor ni un puente)",
  [Se funde el fusible de 5 A de una fuente de alimentación y se sustituye por uno de 10 A «para que aguante más». Con ello:],
  ([la protección mejora, porque el fusible durará más], [nada cambia, porque todos los fusibles cortan a la misma corriente], [el equipo queda desprotegido justo donde ya se sabe que hay un problema], [se protege mejor a las personas frente a los contactos indirectos],),
  sol: [Un fusible fundido es un aviso de que algo ha consumido de más, y se sustituye siempre por otro del mismo calibre. Uno de más amperios deja pasar sobreintensidades que el original habría cortado, y lo siguiente en quemarse puede ser el cable o el equipo. De los contactos indirectos protege el diferencial, no el fusible.], tema: "T10")
#pq(4, 1, 30, "d", "estúdialo en: simulacros de estudio 2·1·29 · libro: T10.26", "El conductor de tierra no lleva fusible ni interruptor",
  [Un aficionado instala un interruptor en el cable de tierra de la estación para poder abrirlo cuando no la usa. Esta práctica es:],
  ([obligatoria en las estaciones de más de 100 W], [correcta, siempre que el interruptor sea magnetotérmico], [recomendable, sobre todo ante tormentas], [incorrecta: el conductor de tierra no debe llevar fusible ni interruptor],),
  sol: [El conductor de tierra tiene que estar disponible siempre: un interruptor o un fusible podrían dejarlo abierto justo cuando hace falta, con los chasis en tensión y sin que nada corte. Ante una tormenta se desconecta la antena del equipo, pero la tierra nunca.], tema: "T10")
#fin-prueba()
#prueba(4, 2)
#pq(4, 2, 1, "b", "estúdialo en: simulacros de estudio 1·2·2 · libro: C-R2.5", "QRG frecuencia exacta frente a QRH su frecuencia varía",
  [Durante un QSO, tu corresponsal te transmite «`QRH`». ¿Qué debes revisar en tu estación?],
  ([la manipulación, porque llega mal formada], [la estabilidad de tu frecuencia de emisión, que está variando], [la potencia, porque tu señal se desvanece], [el tono de tu emisión],),
  sol: [`QRH` es «su frecuencia varía»: tu emisión se desplaza y hay que revisar su estabilidad. `QRG`, su pareja, se refiere a la frecuencia exacta. La manipulación defectuosa es `QSD`, el tono es `QRI` y el desvanecimiento, `QSB`.], tema: "R2")
#pq(4, 2, 2, "a", "estúdialo en: simulacros de estudio 6·2·3, 12·2·2 · libro: C-R2.1, R2.24", "QRK inteligibilidad, QSA intensidad, QRI tono (las tres valoraciones de la señal)",
  [En un mensaje recibes «`QRK 4 QSA 3`». ¿De qué te informa tu corresponsal?],
  ([de la inteligibilidad (4) y de la intensidad (3) de tus señales], [del tono (4) y de la inteligibilidad (3) de tus señales], [de la intensidad (4) y del tono (3) de tus señales], [de la distancia (4) y del número de mensajes pendientes (3)],),
  sol: [`QRK` es la inteligibilidad (legibilidad) de las señales y `QSA`, su intensidad o fuerza. El tono es `QRI`, la distancia es `QRB` y los mensajes pendientes, `QTC`.], tema: "R2")
#pq(4, 2, 3, "d", "estúdialo en: simulacros de estudio 1·2·4 · libro: R2.25", "QRW avise a… de que le llamo en… kHz",
  [Tu amigo EA1ABC no te oye, pero EA4XYZ os oye a los dos. Quieres que EA4XYZ avise a EA1ABC de que le estás llamando en 3650 kHz. ¿Qué grupo usas?],
  ([`QTC`], [`QRZ`], [`QSX`], [`QRW`],),
  sol: [`QRW` es «avise a… de que le llamo en… kHz». `QSX` pide a alguien que escuche a otra estación, no que la avise; `QRZ` pregunta quién me llama y `QTC` anuncia mensajes pendientes.], tema: "R2")
#pq(4, 2, 4, "c", "estúdialo en: simulacros de estudio 13·2·5 · libro: R3.6", "CW telegrafía Morse (onda continua)",
  [En el libro de guardia, ¿con qué abreviatura anotas el modo de un contacto hecho en telegrafía Morse?],
  ([`LSB`], [`DX`], [`CW`], [`SSB`],),
  sol: [`CW` (onda continua) designa la telegrafía en código Morse. `SSB` y `LSB` son modos de fonía en banda lateral, y `DX` no es un modo: indica que el contacto es de larga distancia.], tema: "R3")
#pq(4, 2, 5, "a", "estúdialo en: simulacros de estudio 5·2·6 · libro: R3.10", "YL operadora y XYL esposa",
  [Durante un contacto quieres referirte a una operadora que no es tu esposa. ¿Qué abreviatura usas?],
  ([`YL`], [`XYL`], [`OM`], [`OP`],),
  sol: [`YL` (\_young lady\_) es la operadora. `XYL` se reserva para la esposa del radioaficionado, sea o no operadora; `OM` es el tratamiento de los operadores y `OP` significa simplemente «operador».], tema: "R3")
#pq(4, 2, 6, "b", "estúdialo en: simulacros de estudio 10·2·7 · libro: R3.21", "UR su (your)",
  [Quieres decir «su informe de señal es 599». ¿Qué abreviatura de «su» pones delante de `RST`?],
  ([`OP`], [`UR`], [`HR`], [`TU`],),
  sol: [`UR` (\_your\_) es «su, sus»: «`UR RST 599`». `TU` se le parece, pero significa «gracias»; `HR` es «aquí» y `OP`, «operador».], tema: "R3")
#pq(4, 2, 7, "d", "estúdialo en: simulacros de estudio 6·2·7 · libro: C-R3.5", "MSG mensaje",
  [En un tráfico de mensajes, ¿qué abreviatura designa el «mensaje»?],
  ([`NIL`], [`NR`], [`SIG`], [`MSG`],),
  sol: [`MSG` (\_message\_) es «mensaje». `NR` es su número de orden, `SIG` es «señal» y `NIL` se usa cuando no queda nada que transmitir.], tema: "R3")
#pq(4, 2, 8, "a", "estúdialo en: simulacros de estudio 5·2·8 · libro: R4.5", "Urgencia en radiotelegrafía: XXX tres veces",
  [En telegrafía, la señal equivalente a «Pan Pan» se forma con:],
  ([`XXX`, tres veces], [`TTT`, tres veces], [`SOS`], [`CQD`],),
  sol: [«Pan Pan» es la señal de urgencia, y su equivalente telegráfico es `XXX` tres veces. `TTT` es seguridad («Sécurité»), `SOS` es socorro («Mayday») y `CQD` es la antigua señal de socorro, abandonada.], tema: "R4")
#pq(4, 2, 9, "b", "estúdialo en: simulacros de estudio 7·2·9 · libro: C-R4.3", "Alerta de socorro GMDSS por DSC en MF: 2187,5 kHz (voz: 2182 kHz)",
  [En MF, la frecuencia de 2182 kHz se usa para el socorro en voz. ¿En qué frecuencia de esa misma banda se transmite la alerta de socorro digital (DSC) del GMDSS?],
  ([4207,5 kHz], [2187,5 kHz], [2182 kHz], [2177 kHz],),
  sol: [La alerta DSC del GMDSS en MF va en 2187,5 kHz, 5,5 kHz por encima de la frecuencia de voz. 4207,5 kHz también es de alerta DSC, pero en HF, no en MF.], tema: "R4")
#pq(4, 2, 10, "c", "estúdialo en: simulacros de estudio 4·2·11 · libro: R5.12", "El distintivo tiene como máximo seis caracteres",
  [Un distintivo ordinario lleva un prefijo de dos letras y una cifra de distrito. Sabiendo que el distintivo tiene como máximo seis caracteres, su sufijo puede tener como máximo:],
  ([cinco letras], [dos letras], [tres letras], [cuatro letras],),
  sol: [El distintivo es un grupo alfanumérico de seis caracteres como máximo: 2 de prefijo + 1 de distrito dejan 3 para el sufijo, que es justo el límite ordinario (hasta tres letras). Los sufijos de cuatro o más letras son una excepción para usos temporales, no un distintivo ordinario.], tema: "R5")
#pq(4, 2, 11, "c", "estúdialo en: simulacros de estudio 4·2·13, 13·2·11 · libro: C-R5.20, C-R5.5", "Distritos peninsulares: asignar provincia a su cifra y leer la cifra de un distintivo",
  [¿Cuál de estas provincias pertenece al mismo distrito que Navarra?],
  ([Soria], [La Rioja], [Huesca], [Lleida],),
  sol: [Navarra está en el distrito 2, con el País Vasco y Aragón, al que pertenece Huesca. La Rioja, aunque sea vecina, es del distrito 1, como Soria (Castilla y León); Lleida es de Cataluña (3).], tema: "R5")
#pq(4, 2, 12, "a", "estúdialo en: simulacros de estudio 6·2·11", "Sufijo de una letra como distintivo permanente: 15 años de práctica internacional",
  [Comparado con el sufijo de dos letras, para obtener como distintivo permanente un sufijo de una letra se exige:],
  ([lo mismo, salvo que la práctica internacional acreditada debe ser de quince años en lugar de cinco], [quince años de autorización española en lugar de cinco], [el doble de antigüedad en la autorización española: diez años], [haber ganado un concurso internacional de alta competitividad],),
  sol: [Ambos piden cinco años de autorización española y ninguna sanción en los últimos cinco; lo que cambia es la práctica internacional: cinco años para dos letras y quince para una. Confundir los quince años con la antigüedad de la autorización es la trampa típica.], tema: "R5")
#pq(4, 2, 13, "d", "estúdialo en: simulacros de estudio 2·2·11 · libro: F-R5.4", "Sufijos de cuatro o más letras: excepcionales, para usos temporales en eventos de relevancia especial",
  [Escuchas un distintivo español cuyo sufijo tiene cinco letras. Lo más probable es que se trate de:],
  ([una estación colectiva de una asociación], [el distintivo permanente de un titular con más de veinticinco años de antigüedad], [una estación automática desatendida], [un distintivo de uso temporal autorizado excepcionalmente por un evento o conmemoración de relevancia especial],),
  sol: [La regla general son sufijos de hasta tres letras, pero el art. 27.3 permite, con carácter excepcional, sufijos de cuatro o más letras para usos temporales ligados a eventos o conmemoraciones de relevancia especial. Desatendidas y colectivas usan sufijos de tres letras con iniciales reservadas.], tema: "R5")
#pq(4, 2, 14, "b", "estúdialo en: simulacros de estudio 11·2·16 · libro: F-R6.12", "Centros de actividad de SSB: 144,300 MHz (2 m) y 432,200 MHz (70 cm)",
  [Los centros de actividad de SSB de las bandas de 2 m y 70 cm son, respectivamente:],
  ([144,200 y 432,300 MHz], [144,300 y 432,200 MHz], [144,400 y 432,400 MHz], [144,800 y 433,000 MHz],),
  sol: [El plan de la Región 1 sitúa el centro de actividad de SSB en 144,300 MHz en 2 m y en 432,200 MHz en 70 cm. 144,800 MHz es APRS y 433,000 MHz entrada de repetidores; 144,400 y 432,400 MHz son el comienzo de los segmentos de balizas.], tema: "R6")
#pq(4, 2, 15, "b", "estúdialo en: simulacros de estudio 8·2·14 · libro: F-R6.1", "Bandas sin concursos: 60, 30, 17 y 12 m",
  [Durante un gran concurso internacional, un operador que no quiere participar busca una banda de HF libre de concursos. ¿Cuál le recomienda el plan?],
  ([80 m (3,5 MHz)], [17 m (18 MHz)], [20 m (14 MHz)], [40 m (7 MHz)],),
  sol: [El plan HF de la Región 1 excluye la actividad de concurso en 60, 30, 17 y 12 m, y recomienda a quien no concursa usar 30, 17 y 12 m durante los grandes concursos. En 80, 40 y 20 m, en cambio, hay incluso tramos preferentes para concurso.], tema: "R6")
#pq(4, 2, 16, "a", "estúdialo en: simulacros de estudio 3·2·15 · libro: R7.18", "Autorización especial que causa interferencias: suspender de inmediato",
  [Con una autorización especial experimental compruebas que tus emisiones interfieren la televisión de tus vecinos. Faltan dos semanas para que acabe el plazo autorizado. Debes:],
  ([suspender de inmediato las emisiones y no reanudarlas hasta corregir la causa], [esperar a que la Administración te requiera el cese], [terminar las pruebas pendientes cuanto antes y comunicarlo al acabar], [seguir emitiendo, porque la autorización sigue en vigor],),
  sol: [Las autorizaciones especiales no dan prioridad sobre otros servicios: si se comprueba que se interfiere, se suspende de inmediato. Que el plazo siga vigente no ampara la interferencia, y no hay que esperar a un requerimiento.], tema: "R7")
#pq(4, 2, 17, "c", "estúdialo en: simulacros de estudio 5·2·19 · libro: F-R8.61", "Radiobaliza: distintivo a intervalos ≤ 3 min",
  [Una radiobaliza de aficionado transmite su distintivo cada cinco minutos. Según el artículo 25.e:],
  ([cumple, porque el máximo es de diez minutos, como en los repetidores], [cumple, porque basta con que se identifique al principio y al final de sus emisiones], [no cumple, porque debe transmitirlo a intervalos no superiores a tres minutos], [no cumple, porque debe transmitirlo al menos una vez por minuto],),
  sol: [El art. 25.e obliga a las radiobalizas a transmitir su distintivo a intervalos no superiores a tres minutos; cinco minutos lo superan. Los diez minutos son el límite de los repetidores analógicos (art. 25.d) y el de las emisiones largas de cualquier estación. La exigencia de hacerlo cada minuto no figura en la Orden.], tema: "R8")
#pq(4, 2, 18, "c", "estúdialo en: simulacros de estudio 5·2·20 · libro: F-R8.86", "Interferencia perjudicial: compromete la radionavegación o seguridad, o degrada gravemente o interrumpe un servicio",
  [¿Cuál de estas situaciones constituye interferencia perjudicial según el anexo I?],
  ([una emisión que supera la potencia máxima autorizada, aunque no afecte a ningún receptor], [cualquier emisión de aficionado que se reciba en un receptor ajeno], [una emisión que compromete el funcionamiento de un servicio de radionavegación], [un armónico que solo se detecta con un analizador, sin efecto sobre ninguna recepción],),
  sol: [Es perjudicial la interferencia que compromete el funcionamiento de un servicio de radionavegación o de otros servicios de seguridad, o que degrada gravemente, interrumpe repetidamente o impide un servicio de radiocomunicación explotado conforme al Reglamento de Radiocomunicaciones. La definición atiende al efecto: sin efecto sobre la recepción no hay interferencia, por mucha potencia que se emita. Y que una señal se reciba en otro receptor no basta.], tema: "R8")
#pq(4, 2, 19, "d", "estúdialo en: simulacros de estudio 1·2·18 · libro: F-R8.82", "Tolerancia de frecuencia: desviación entre la frecuencia asignada y el centro de la banda ocupada",
  [Un transmisor que emite en 144 MHz tiene una tolerancia de frecuencia de 5 ppm. ¿Cuál es la desviación máxima admisible entre la frecuencia asignada y el centro de la banda ocupada por la emisión?],
  ([7,2 kHz], [72 Hz], [72 kHz], [720 Hz],),
  sol: [La tolerancia de frecuencia es la desviación máxima admisible entre la frecuencia asignada y la del centro de la banda ocupada, y puede expresarse en ppm. Aquí, $144 times 10^6 times 5 times 10^(-6) = 720$ Hz. Las otras cifras salen de correr la coma una o varias posiciones al operar con las potencias de diez.], tema: "R8")
#pq(4, 2, 20, "a", "estúdialo en: simulacros de estudio 2·2·20, 10·2·21 · libro: R8.3, R8.2", "T/R 61-01 = licencia CEPT (uso temporal); T/R 61-02 = certificado HAREC",
  [Un radioaficionado español viaja dos semanas a un país europeo que aplica las recomendaciones CEPT de aficionados y quiere operar allí su equipo. ¿En qué norma se ampara?],
  ([la Recomendación CEPT T/R 61-01], [el artículo 25 del Reglamento de Radiocomunicaciones de la UIT], [la Recomendación CEPT T/R 61-02], [la disposición adicional segunda de la Orden IET/1311/2013],),
  sol: [La T/R 61-01 regula el uso temporal de la estación en otro país, mediante la licencia CEPT; la autorización española tiene esa consideración. La T/R 61-02 es la del certificado HAREC: sirve para obtener autorización al instalarse en otro país, no para una visita. Truco: de visita, 61-01; si te instalas, 61-02.], tema: "R8")
#pq(4, 2, 21, "c", "estúdialo en: simulacros de estudio 4·2·21 · libro: R8.85", "Identificación con licencia CEPT: prefijo del país visitado (y opcionalmente distrito) + distintivo propio",
  [Un radioaficionado checo con distintivo OK2HM opera temporalmente desde Cataluña con su licencia CEPT. ¿Cuál de estas identificaciones es correcta?],
  ([OK2HM/P], [EA3HM, distintivo español que se le asigna al llegar], [EA3/OK2HM], [OK2HM, sin ningún añadido],),
  sol: [Con licencia CEPT se antepone al distintivo propio el prefijo del país visitado, EA en España, y opcionalmente el número de distrito desde el que se opera; Cataluña es el distrito 3. Por eso vale EA3/OK2HM, y también valdría EA/OK2HM. El distintivo de origen solo no basta, no se asigna uno español, y /P indica estación portable, no la operación con licencia CEPT.], tema: "R8")
#pq(4, 2, 22, "b", "estúdialo en: simulacros de estudio 9·2·23 · libro: F-R8.33", "Extranjero de país no T/R 61-01: autorización temporal ≤ 90 días",
  [Un radioaficionado de un país que no ha adoptado la T/R 61-01 pasará cuatro meses en España. Si la SETSI le concede la autorización temporal del artículo 15, esta podrá cubrir como máximo:],
  ([30 días al año], [90 días de su estancia], [los cuatro meses completos, porque se ajusta a la duración de la estancia], [15 días naturales],),
  sol: [El art. 15 permite a la SETSI autorizar a operar mientras esté temporalmente en España al titular de una licencia en vigor de un país que no ha adoptado la T/R 61-01, con un período de validez no superior a 90 días. Una estancia de cuatro meses lo supera, así que la autorización no la cubre entera. Los 15 días naturales son los del uso portable sin notificación, y los 30 días al año, el límite de los distintivos temporales.], tema: "R8")
#pq(4, 2, 23, "d", "estúdialo en: simulacros de estudio 9·2·27 · libro: R8.75", "Obras: desmontaje temporal sin indemnización; después se reinstala en condiciones similares",
  [Unas obras necesarias en la azotea obligan a desmontar tu antena durante tres meses. Terminadas las obras:],
  ([la comunidad debe indemnizarte por los tres meses sin antena], [debes tramitar de nuevo la instalación como si fuera la primera], [solo puedes reinstalarla si la junta lo aprueba por mayoría simple], [puedes reinstalarla en condiciones similares a las anteriores, sin derecho a indemnización por el desmontaje],),
  sol: [Si las obras necesarias lo exigen, el titular soporta el desmontaje temporal sin poder reclamar indemnización. Acabadas las obras, la instalación se repone en condiciones similares a las anteriores, sin empezar el expediente de nuevo ni pedir permiso a la junta.], tema: "R8")
#pq(4, 2, 24, "d", "estúdialo en: simulacros de estudio 9·2·28 · libro: F-R8.42", "Emisiones experimentales: se identifican con el distintivo propio",
  [Un radioaficionado realiza unas pruebas al amparo de una autorización especial experimental. Al emitir, debe:],
  ([indicar las coordenadas geográficas de la instalación en lugar del distintivo], [usar un distintivo temporal que la SETSI asigna para el experimento], [omitir la identificación, por el carácter experimental de las pruebas], [identificarse con su propio distintivo, como en cualquier otra emisión],),
  sol: [El art. 17.3 dispone que estas emisiones se identifican con el distintivo propio del radioaficionado o de la asociación solicitante. El carácter experimental no exime de identificarse, y la autorización especial no lleva un distintivo distinto. Las coordenadas forman parte de la memoria técnica, no de la identificación.], tema: "R8")
#pq(4, 2, 25, "d", "estúdialo en: simulacros de estudio 11·2·25 · libro: R8.44", "Estación portátil: antena y fuente de energía incorporadas, utilizable en movimiento",
  [Según el anexo I, ¿qué distingue a la estación portátil de las demás estaciones móviles?],
  ([estar instalada de forma permanente en un vehículo], [ser una estación fija que se utiliza temporalmente en otro lugar], [poder utilizarse en movimiento], [llevar incorporadas al propio equipo la antena y la fuente de energía],),
  sol: [La portátil es una estación móvil con antena y fuente de energía incorporadas al propio equipo, como un equipo de mano con su batería. Poder usarse en movimiento es común a todas las móviles, así que no la distingue. La estación fija utilizada temporalmente en otro sitio es la portable, que se confunde con la portátil por el nombre.], tema: "R8")
#pq(4, 2, 26, "b", "estúdialo en: simulacros de estudio 2·2·27 · libro: R8.87", "Estación digital: emite con técnicas digitales",
  [Conectas un ordenador a tu transceptor de HF, de mandos totalmente analógicos, para emitir en un modo digital de texto. ¿Es una estación digital según la Orden?],
  ([Solo si el transceptor es de fabricación industrial y no de construcción propia], [Sí, porque está dotada de dispositivos que permiten realizar emisiones con técnicas digitales], [No, porque solo es digital la estación que emite exclusivamente en modos digitales], [No, porque una estación digital debe carecer de mandos analógicos],),
  sol: [La estación digital es la dotada de dispositivos que permiten realizar emisiones con técnicas digitales: la define la técnica de emisión, no el aspecto del equipo. Un transceptor con mandos convencionales y un ordenador conectado cumple la definición. La norma no exige que emita solo en digital ni distingue entre equipos industriales y de construcción propia.], tema: "R8")
#pq(4, 2, 27, "c", "estúdialo en: simulacros de estudio 11·2·27 · libro: F-R8.77", "Repetidoras digitales: de portadora o nodo (enlaza con repetidoras) frente a final (distribuye a los usuarios)",
  [Una estación repetidora digital situada en un monte solo enlaza con otras repetidoras digitales; ningún radioaficionado accede a ella directamente con su equipo. Según el anexo I, es una:],
  ([estación repetidora final], [estación repetidora analógico-digital], [estación repetidora de portadora o nodo], [radiobaliza],),
  sol: [El anexo I define la repetidora de portadora o nodo como la repetidora digital destinada a enlazar únicamente con otras repetidoras digitales: es un eslabón entre repetidoras. La final es la que procesa o distribuye el tráfico de otras repetidoras digitales hacia las estaciones de cada radioaficionado, justo lo que esta no hace. La analógico-digital se caracteriza por sus conversores, y la radiobaliza, por emitir señales de identificación para estudiar la propagación.], tema: "R8")
#pq(4, 2, 28, "a", "estúdialo en: simulacros de estudio 1·2·29 · libro: R9.3", "Grave: negativa u obstrucción a la inspección",
  [Durante una inspección, el titular de una estación se niega a mostrar los equipos al inspector y entorpece a propósito la comprobación. Según la Ley 11/2022, comete:],
  ([una infracción grave], [una infracción muy grave], [ninguna infracción, salvo que el inspector vaya acompañado de un agente de la autoridad], [una infracción leve],),
  sol: [La negativa o la obstrucción a ser inspeccionado, y la falta de colaboración con la inspección, es infracción grave (art. 107.36). El inspector ya es autoridad pública en el ejercicio de sus funciones, así que no necesita ir acompañado para que la obstrucción sea infracción. No es leve ni muy grave: la ley la sitúa entre las graves.], tema: "R9")
#pq(4, 2, 29, "d", "estúdialo en: simulacros de estudio 9·2·30 · libro: R9.28", "No es infracción no llevar libro de registro (no existe la obligación)",
  [Durante una inspección, el inspector pregunta a un radioaficionado por su libro de registro de comunicados y este responde que no lleva ninguno. Según la reglamentación española:],
  ([comete la infracción leve de no facilitar los datos requeridos], [comete infracción solo si ha participado en algún concurso], [comete una infracción grave por no colaborar con la inspección], [no comete infracción, porque no existe la obligación de llevarlo],),
  sol: [La reglamentación española no obliga al radioaficionado a llevar libro de guardia ni registro de contactos, así que no se puede infringir lo que no existe. No hay negativa a facilitar datos ni falta de colaboración: simplemente no tiene ese documento. Anotar los contactos es útil para diplomas y concursos, pero voluntario.], tema: "R9")
#pq(4, 2, 30, "b", "estúdialo en: simulacros de estudio 1·2·30 · libro: R9.19", "El expediente se tramita por la LGT y el procedimiento administrativo común",
  [En un expediente sancionador por interferencias, las garantías de audiencia, prueba y plazos que tiene el radioaficionado proceden:],
  ([de las instrucciones internas de cada Jefatura Provincial], [de la legislación de procedimiento administrativo común, aplicada junto con la Ley General de Telecomunicaciones], [de un procedimiento sancionador propio regulado por la Orden IET/1311/2013], [del Reglamento de Radiocomunicaciones de la UIT],),
  sol: [El expediente se tramita con arreglo a la Ley General de Telecomunicaciones y a la legislación de procedimiento administrativo común (Ley 39/2015). La ley sectorial tipifica y gradúa, y el procedimiento común aporta las garantías. La Orden no tiene un procedimiento sancionador propio: remite a la Ley. El Reglamento de la UIT no es una norma sancionadora española.], tema: "R9")
#fin-prueba()
#soluciones-simulacro(4)

// ======================================================================
#simulacro(5)
#prueba(5, 1)
#pq(5, 1, 1, "b", "estúdialo en: simulacros de estudio 6·1·4 · libro: T1.46", "Objeto de la modulación: que la portadora transporte la información",
  [Una portadora de radiofrecuencia emitida de forma continua y sin modular:],
  ([transporta la información en su longitud de onda], [no transporta información: hay que variar su amplitud, su frecuencia o su fase al ritmo del mensaje], [transporta la información en su frecuencia, que permanece fija], [transporta más información cuanto mayor es su potencia],),
  sol: [Una portadora pura es un tono constante y no dice nada; para que transporte información hay que modularla, haciendo que la señal moduladora altere alguno de sus parámetros. Una frecuencia, una longitud de onda o una potencia fijas no cambian con el mensaje, así que no pueden llevarlo.], tema: "T1")
#pq(5, 1, 2, "a", "estúdialo en: simulacros de estudio 10·1·3 · libro: F-T1.53", "Energía = potencia × tiempo (julio = W·s, kWh)",
  [¿Cuánto tiempo puede funcionar un equipo de 250 W con una energía de 1 kWh?],
  ([4 horas], [40 horas], [0,004 horas], [15 minutos],),
  sol: [La energía es potencia por tiempo, así que $t = E slash P = 1000 "Wh" slash 250 "W" = 4$ h. Los 15 minutos (0,25 h) dividen la potencia entre la energía; las 0,004 horas olvidan que 1 kWh son 1000 Wh, y las 40 horas son un error de un factor 10.], tema: "T1")
#pq(5, 1, 3, "d", "estúdialo en: simulacros de estudio 8·1·4 · libro: F-T1.48", "Conversores A/D y D/A: qué convierte cada uno",
  [Un receptor SDR digitaliza la señal de la antena, la procesa como números y la entrega por el altavoz. Los conversores que atraviesa la señal, en orden, son:],
  ([solo un D/A, a la salida], [primero un D/A y después un A/D], [solo un A/D, a la entrada], [primero un A/D y después un D/A],),
  sol: [El conversor A/D convierte la señal analógica en una secuencia de números para que el procesador pueda tratarla; el D/A hace lo contrario y devuelve una señal analógica, el audio, que puede mover el altavoz. Hace falta uno a cada lado del procesado.], tema: "T1")
#pq(5, 1, 4, "b", "estúdialo en: simulacros de estudio 2·1·4 · libro: F-T1.43", "Aliasing: las frecuencias por encima de f_s/2 se confunden con otras más bajas",
  [Un sistema muestrea a 10 kHz sin filtro antisolapamiento, y a su entrada llega un tono de 7 kHz. Tras el muestreo, ese tono aparece como uno de:],
  ([5 kHz], [3 kHz], [17 kHz], [7 kHz],),
  sol: [El tono de 7 kHz supera $f_s slash 2 = 5$ kHz y se pliega: aparece en $10 - 7 = 3$ kHz, una frecuencia que no existía y que ya no se puede separar de la señal útil. Los 5 kHz son el límite de Nyquist, no la frecuencia del alias, y los 17 kHz no caben en la banda muestreada.], tema: "T1")
#pq(5, 1, 5, "b", "estúdialo en: simulacros de estudio 6·1·8 · libro: T2.15", "La bobina almacena energía en el campo magnético (½LI²)",
  [Una bobina de 20 mH recorrida por una corriente continua de 2 A almacena:],
  ([80 mJ, en su campo magnético], [40 mJ, en su campo magnético], [20 mJ, en su campo eléctrico], [40 mJ, en su campo eléctrico],),
  sol: [La bobina guarda la energía en el campo magnético de su corriente: $E = 1/2 L I^2 = 0","5 dot 0","02 dot 2^2 = 0","04$ J = 40 mJ. Sin el factor 1/2 salen 80 mJ. El campo eléctrico es donde guarda la energía el condensador.], tema: "T2")
#pq(5, 1, 6, "d", "estúdialo en: simulacros de estudio 9·1·6 · libro: C-T2.2", "Relación de transformación: cociente de tensiones o de espiras",
  [Un transformador ideal da 46 V en el secundario cuando se aplican 230 V al primario. ¿Cuál es su relación de espiras primario/secundario?],
  ([25:1], [184:1], [1:5], [5:1],),
  sol: [La relación de espiras coincide con la de tensiones: $N_p / N_s = V_p / V_s = 230 / 46 = 5$. 1:5 corresponde a un elevador, 184 es la diferencia de tensiones y 25 el cuadrado de la relación, que es lo que se aplica a las impedancias.], tema: "T2")
#pq(5, 1, 7, "c", "estúdialo en: simulacros de estudio 11·1·8 · libro: T2.19", "Cálculo de la tensión del secundario: V_s = V_p · N_s/N_p",
  [Un transformador ideal con 500 espiras en el primario debe dar 12 V en el secundario a partir de 230 V. ¿Cuántas espiras necesita el secundario?],
  ([unas 9580], [unas 42], [unas 26], [unas 19],),
  sol: [De $V_s / V_p = N_s / N_p$ sale $N_s = 500 dot 12 / 230 approx 26$ espiras. Invertir la relación da unas 9580, que corresponderían a un elevador. Las otras dos cifras salen de dividir solo 230 o 500 entre 12.], tema: "T2")
#pq(5, 1, 8, "a", "estúdialo en: simulacros de estudio 8·1·8 · libro: F-T2.12", "Cálculo de la adaptación de impedancias: Z_p = (N_p/N_s)² Z_s (balun 4:1 = espiras 2:1)",
  [Se conecta una carga de 800 Ω al secundario de un transformador ideal cuyo secundario tiene cuatro veces más espiras que el primario. ¿Qué impedancia presenta el primario al generador?],
  ([50 Ω], [200 Ω], [3200 Ω], [12 800 Ω],),
  sol: [$Z_p = (N_p / N_s)^2 Z_s = (1/4)^2 dot 800 = 800 / 16 = 50$ Ω. Aplicar la relación sin elevarla al cuadrado da 200 Ω. Las otras dos opciones invierten la relación, con y sin el cuadrado.], tema: "T2")
#pq(5, 1, 9, "a", "estúdialo en: simulacros de estudio 2·1·7 · libro: T2.33", "LED: emite luz polarizado en directa",
  [Montas un LED con su resistencia y no luce. Al darle la vuelta, luce. ¿Qué ocurría?],
  ([estaba polarizado en inversa, y el LED solo emite luz cuando conduce en directa], [la resistencia era demasiado pequeña], [la tensión no alcanzaba la de avalancha del LED], [estaba en directa, y el LED solo emite luz en inversa],),
  sol: [El LED es un diodo: solo conduce en directa, y es al circular esa corriente cuando emite luz. Polarizado en inversa no conduce y no luce. Trabajar en inversa, en la tensión de avalancha, es lo propio del zéner, no del LED.], tema: "T2")
#pq(5, 1, 10, "a", "estúdialo en: simulacros de estudio 7·1·9 · libro: C-T3.10", "Resistencias en serie: la corriente es la misma en todas y la caída de tensión es proporcional a cada R",
  [Dos resistencias están conectadas en serie y las recorre una corriente. En la de 1 kΩ caen 3 V y en la otra caen 12 V. ¿Cuánto vale la otra resistencia?],
  ([4 kΩ], [250 Ω], [12 kΩ], [5 kΩ],),
  sol: [En serie la corriente es la misma en las dos: $I = 3 "V" slash 1 "kΩ" = 3$ mA, luego $R = 12 "V" slash 3 "mA" = 4$ kΩ. La caída es proporcional a la resistencia: cuatro veces más tensión, cuatro veces más resistencia. Los 250 Ω suponen que la caída es inversamente proporcional a $R$, y los 5 kΩ son la resistencia total del conjunto, no la de la segunda.], tema: "T3")
#pq(5, 1, 11, "b", "estúdialo en: simulacros de estudio 13·1·10 · libro: F-T3.45", "Q = X/R en resonancia y ancho de banda B = f0/Q",
  [Un circuito resonante serie sintonizado a 14 MHz tiene un ancho de banda de 200 kHz, y su reactancia inductiva en resonancia es de 350 Ω. Su resistencia de pérdidas es de:],
  ([1,75 Ω], [5 Ω], [24 500 Ω], [0,2 Ω],),
  sol: [Primero el factor de calidad: $Q = f_0 slash B = 14000 "kHz" slash 200 "kHz" = 70$. Como en resonancia $Q = X slash R$, $R = X slash Q = 350 slash 70 = 5$ Ω. Los 0,2 Ω invierten el cociente ($Q slash X$), los 24 500 Ω multiplican $X$ por $Q$ y los 1,75 Ω dividen la reactancia entre el ancho de banda sin pasar por $Q$.], tema: "T3")
#pq(5, 1, 12, "c", "estúdialo en: simulacros de estudio 3·1·10 · libro: T3.7", "Filtro paso banda: deja pasar su banda y atenúa por encima y por debajo; es el de la FI",
  [A la entrada de un receptor se quiere un filtro que deje pasar la banda de 40 m (7,0 a 7,2 MHz) y atenúe a la vez una emisora de onda media de 1 MHz y otra de 14 MHz. El filtro adecuado es:],
  ([un paso alto con corte en 7,0 MHz], [un rechazo de banda centrado en 7,1 MHz], [un paso banda centrado en la banda de 40 m], [un paso bajo con corte en 7,2 MHz],),
  sol: [Hay que atenuar por debajo y por encima de la banda deseada a la vez: eso es un paso banda. El paso bajo atenuaría la emisora de 14 MHz pero dejaría pasar la de 1 MHz, y el paso alto haría lo contrario. El rechazo de banda haría justo lo opuesto de lo que se busca: eliminaría la banda de 40 m.], tema: "T3")
#pq(5, 1, 13, "d", "estúdialo en: simulacros de estudio 11·1·10 · libro: T3.41", "Frecuencia de corte: separa banda de paso y de atenuación; se toma a −3 dB",
  [En la frecuencia de corte de un filtro, la potencia de salida comparada con la que hay en la banda de paso se ha reducido a:],
  ([la cuarta parte], [cero], [el 70,7 %], [la mitad],),
  sol: [La frecuencia de corte se toma, por convenio, donde la respuesta ha caído 3 dB, que en potencia es la mitad: es el punto de media potencia. El 70,7 % es lo que queda de la tensión, no de la potencia, y la cuarta parte de la potencia serían −6 dB. La salida no se anula en el corte: solo empieza a atenuarse de verdad.], tema: "T3")
#pq(5, 1, 14, "b", "estúdialo en: simulacros de estudio 2·1·10 · libro: T3.31", "Media onda frente a onda completa: la completa aprovecha los dos semiciclos, dobla el valor medio y da menos rizado",
  [El secundario de un transformador da 20 V de pico. Sin condensador de filtro, la tensión media a la salida de un rectificador de onda completa es aproximadamente de:],
  ([14,1 V], [12,7 V], [20 V], [6,4 V],),
  sol: [La onda completa aprovecha los dos semiciclos y entrega un valor medio de $2 V_p slash pi approx 0","64 dot 20 approx 12","7$ V, el doble que la media onda ($V_p slash pi approx 6","4$ V), que solo aprovecha uno. Los 20 V son el pico, que solo se alcanzaría con condensador y sin carga, y los 14,1 V son el valor eficaz de la senoide, no el medio de la onda rectificada.], tema: "T3")
#pq(5, 1, 15, "d", "estúdialo en: simulacros de estudio 2·1·15 · libro: T4.35", "Anchura de banda de la NBFM: unos 12 kHz (FM de difusión 200 kHz, SSB 2,4 kHz)",
  [Una emisión que ocupa unos 12 kHz de anchura de banda corresponde típicamente a:],
  ([banda lateral única (J3E) en HF], [FM de radiodifusión], [AM (A3E) con voz de hasta 3 kHz], [FM de banda estrecha (NBFM), como la de VHF],),
  sol: [La NBFM del servicio de aficionados ocupa unos 12 kHz. La FM de radiodifusión necesita unos 200 kHz, la SSB unos 2,4 a 2,7 kHz y la AM con voz de 3 kHz ocupa el doble de la frecuencia de audio más alta, unos 6 kHz.], tema: "T4")
#pq(5, 1, 16, "a", "estúdialo en: simulacros de estudio 5·1·16 · libro: T4.8", "Silenciador (squelch): corta el audio cuando la señal no supera un umbral",
  [En un equipo de FM de 2 m, sin ninguna estación en el canal, el altavoz deja oír un soplido continuo. Para que quede en silencio hasta que llegue una señal, se ajusta:],
  ([el silenciador (squelch)], [el RIT], [el control automático de ganancia], [el noise blanker (NB)],),
  sol: [El silenciador corta el audio mientras la señal no supera un umbral, y lo abre en cuanto llega una estación: elimina el soplido entre comunicados. El noise blanker está pensado para pulsos cortos e intensos, no para un ruido continuo, y el RIT solo mueve la frecuencia de recepción.], tema: "T4")
#pq(5, 1, 17, "c", "estúdialo en: simulacros de estudio 1·1·17 · libro: F-T5.13", "FM indirecta: modulador de fase tras un oscilador a cristal (ventaja: estabilidad)",
  [¿Qué inconveniente tiene generar la FM de forma indirecta, con un modulador de fase detrás de un oscilador a cristal?],
  ([suprime una de las bandas laterales de la emisión], [obliga a usar un amplificador final lineal de clase AB], [el modulador de fase da desviaciones pequeñas y obliga a usar multiplicadores de frecuencia], [la portadora es menos estable que en la FM directa],),
  sol: [En la FM indirecta el cristal no se toca y la estabilidad es excelente, pero el modulador de fase solo consigue desviaciones pequeñas, así que hay que multiplicar la frecuencia para alcanzar la desviación deseada. La estabilidad es precisamente su ventaja, no su defecto. Como toda FM, es de envolvente constante y admite finales de clase C.], tema: "T5")
#pq(5, 1, 18, "c", "estúdialo en: simulacros de estudio 1·1·19 · libro: T5.29", "Manipulación brusca en CW: chasquidos que ensanchan la emisión",
  [¿Cómo se evitan los chasquidos de manipulación en un transmisor de CW?],
  ([se acortan al mínimo los tiempos de subida y bajada de la envolvente], [se manipula directamente el oscilador en lugar de una etapa de bajo nivel], [se redondean la subida y la bajada de la envolvente, con tiempos de unos 3 a 5 ms], [se sustituye el amplificador final de clase C por uno de clase A],),
  sol: [Un escalón brusco de la portadora contiene frecuencias muy altas que ensanchan la emisión: son los chasquidos. Se evitan suavizando los flancos, por ejemplo con una red RC en la línea del manipulador. Acortar aún más los flancos empeora el problema, y manipular el oscilador lo haría piar.], tema: "T5")
#pq(5, 1, 19, "a", "estúdialo en: simulacros de estudio 6·1·18 · libro: C-T5.18", "Conmutador SEND/REC: pasa de emisión a recepción y viceversa",
  [En la posición SEND del conmutador SEND-REC de un transceptor:],
  ([la antena pasa al transmisor y se protege la entrada del receptor], [se activa la conmutación automática por voz], [la antena pasa al receptor y se desconecta el transmisor], [se selecciona la clase de emisión de telegrafía],),
  sol: [SEND-REC gobierna el relé de transmisión-recepción: en SEND conecta la antena al transmisor y protege el receptor; en REC devuelve la antena al receptor. La clase de emisión la elige el selector de modo, y la conmutación por voz es el VOX.], tema: "T5")
#pq(5, 1, 20, "b", "estúdialo en: simulacros de estudio 11·1·21 · libro: F-T6.16", "Media onda alimentada en un extremo: impedancia muy alta (miles de ohmios)",
  [Para alimentar con coaxial de 50 Ω una antena de media onda por uno de sus extremos, hace falta:],
  ([nada, porque en el extremo presenta unos 50 Ω], [un transformador de relación alta (por ejemplo, 49:1) que baje su impedancia de miles de ohmios], [solo un balun 1:1, porque el problema es únicamente de simetría], [un transformador que eleve su impedancia, porque en el extremo es casi nula],),
  sol: [En el extremo de una media onda la corriente es nula y la tensión máxima, así que la impedancia es de varios miles de ohmios (de 2000 a 5000 Ω). Para bajarla a 50 Ω se usa un transformador de relación alta, típicamente 49:1. Quien crea que la impedancia en el extremo es baja confunde el extremo con el centro, donde está el vientre de corriente.], tema: "T6")
#pq(5, 1, 21, "c", "estúdialo en: simulacros de estudio 6·1·20 · libro: T6.38", "Reciprocidad: el mismo diagrama en transmisión y en recepción",
  [Una Yagi tiene 6 dBd de ganancia en transmisión en la dirección de sus directores. Usada para recibir, su ganancia en esa misma dirección es de:],
  ([0 dBd, porque una antena pasiva solo gana al transmitir], [3 dBd, la mitad], [6 dBd], [12 dBd, el doble],),
  sol: [Por el principio de reciprocidad, una antena pasiva tiene el mismo diagrama y la misma ganancia emitiendo que recibiendo; por eso apuntar una directiva sirve igual para transmitir que para escuchar. Ser pasiva solo significa que no añade energía: la ganancia procede de concentrarla, y eso vale en los dos sentidos.], tema: "T6")
#pq(5, 1, 22, "d", "estúdialo en: simulacros de estudio 12·1·22 · libro: T6.43", "Máxima transferencia: transmisor, línea y antena de la misma impedancia; si difieren, hace falta adaptador",
  [Una antena de 200 Ω se va a alimentar desde un transmisor de 50 Ω mediante coaxial de 50 Ω. Para lograr la máxima transferencia de energía:],
  ([basta con subir la potencia del transmisor], [no hace falta nada, porque la diferencia de impedancias no influye], [basta con usar el coaxial más corto posible], [hay que intercalar un adaptador de impedancias, como un balun 4:1 o un acoplador],),
  sol: [La máxima transferencia exige que transmisor, línea y antena presenten la misma impedancia; si no coinciden, parte de la energía se refleja. Con 200 Ω frente a 50 Ω hace falta un adaptador: por ejemplo, un balun transformador 4:1, que baja los 200 Ω a 50 Ω, o un acoplador. Acortar la línea o subir la potencia no corrige la desadaptación.], tema: "T6")
#pq(5, 1, 23, "c", "estúdialo en: simulacros de estudio 6·1·23", "De noche desaparece la capa D y F1 y F2 se funden en una sola capa F",
  [A medianoche, una onda de 7 MHz que sube hacia la ionosfera se encuentra, de abajo arriba, con:],
  ([las capas D, E, F1 y F2, igual que de día], [una capa D reforzada y una capa F], [una capa E residual y una sola capa F], [las capas F1 y F2, separadas, sin capa E],),
  sol: [De noche la capa D desaparece en minutos (el aire denso favorece la recombinación), la E casi se apaga y F1 y F2 se funden en una sola capa F, que aguanta toda la noche. Las cuatro capas solo existen de día, y la D nunca se refuerza de noche: por eso las bandas bajas mejoran al anochecer.], tema: "T7")
#pq(5, 1, 24, "d", "estúdialo en: simulacros de estudio 2·1·25 · libro: F-T7.5", "Reflexión auroral: en las cortinas ionizadas de las auroras",
  [Durante una fuerte tormenta geomagnética, dos estaciones europeas de 144 MHz contactan con las antenas apuntando ambas al norte, y la señal llega con un tono áspero y zumbón. Están usando:],
  ([el meteor-scatter, en las estelas de los meteoros], [la reflexión en la capa F2, reforzada por la tormenta], [un conducto troposférico formado por la tormenta], [la reflexión auroral, en las cortinas ionizadas de la aurora],),
  sol: [Las tormentas geomagnéticas producen auroras, y sus cortinas ionizadas reflejan VHF; como se mueven, ensanchan la señal y le dan ese tono áspero, y hay que apuntar hacia ellas, al norte. La tormenta desorganiza la capa F2 en vez de reforzarla, los meteoros dan ráfagas breves y los conductos dependen de la inversión térmica, no del campo magnético.], tema: "T7")
#pq(5, 1, 25, "b", "estúdialo en: simulacros de estudio 3·1·26 · libro: T8.19", "Resistencia interna ideal: amperímetro nula, voltímetro infinita",
  [Se intercala en un circuito un amperímetro cuya resistencia interna no es despreciable frente a la del circuito. La corriente que indica es:],
  ([exactamente la que circulaba antes de conectarlo], [menor que la que circulaba antes de conectarlo], [mayor que la que circulaba antes de conectarlo], [nula, porque bloquea el paso de la corriente],),
  sol: [El amperímetro va en serie, así que su resistencia interna se suma a la del circuito y la corriente baja: indica menos de lo que había. Por eso el ideal tendría resistencia nula; el voltímetro, que va en paralelo, debería tenerla infinita.], tema: "T8")
#pq(5, 1, 26, "a", "estúdialo en: simulacros de estudio 5·1·25 · libro: C-T8.5", "Shunt: resistencia en paralelo que amplía la escala del amperímetro y lo protege",
  [Un galvanómetro de 1 mA a fondo de escala y 50 Ω de resistencia interna se quiere usar para medir hasta 100 mA. Hay que añadirle:],
  ([una resistencia de unos 0,5 Ω en paralelo], [una resistencia de 4950 Ω en serie], [una resistencia de 50 Ω en paralelo], [una resistencia de unos 0,5 Ω en serie],),
  sol: [Hace falta un shunt en paralelo: $R_s = I_m R_m slash (I - I_m) = 0","001 times 50 slash 0","099 approx 0","5$ Ω, que desvía 99 mA y deja pasar 1 mA por el instrumento. En serie no se desvía nada, y los 4950 Ω en serie lo convertirían en un voltímetro de 5 V. Un shunt de 50 Ω solo duplicaría la escala, hasta 2 mA.], tema: "T8")
#pq(5, 1, 27, "c", "estúdialo en: simulacros de estudio 12·1·27 · libro: T9.6", "Apantallamiento: caja metálica, eléctricamente estanca y a tierra (jaula de Faraday en los dos sentidos)",
  [Un circuito sensible está dentro de una caja metálica conectada a tierra, pero la caja tiene una ranura de ventilación de varios centímetros. Trabajando en 435 MHz:],
  ([la ranura mejora el apantallamiento, porque refrigera el circuito], [la ranura solo importa en HF, donde la longitud de onda es mayor], [la ranura puede dejar pasar la RF, porque las aberturas deben ser pequeñas frente a la longitud de onda], [la ranura no importa, porque la caja es metálica y está a tierra],),
  sol: [Para apantallar, la caja debe ser metálica, estar a tierra y ser eléctricamente estanca: sus aberturas han de ser pequeñas frente a la longitud de onda (regla práctica, menores que λ/20, unos 3,4 cm en 435 MHz). En HF casi cualquier caja cerrada vale, pero en UHF una rejilla de unos centímetros ya deja escapar la señal.], tema: "T9")
#pq(5, 1, 28, "a", "estúdialo en: simulacros de estudio 3·1·29 · libro: T10.39", "Incendio en equipo eléctrico: cortar la corriente y extintor de CO2 o polvo, nunca agua ni espuma",
  [Una vez cortada la corriente, el extintor adecuado para un conato de incendio en un transceptor es el de:],
  ([dióxido de carbono o de polvo], [espuma], [agua], [cualquier tipo, porque sin tensión el agente extintor es indiferente],),
  sol: [Ante fuego en un equipo eléctrico se corta primero la corriente y después se usa un extintor apto para fuego eléctrico, de dióxido de carbono o de polvo. Ni agua ni espuma, que es una disolución acuosa y conduce casi como el agua mientras pueda haber tensión. El agente sigue importando después de cortar, porque en el equipo puede quedar tensión, por ejemplo en sus condensadores.], tema: "T10")
#pq(5, 1, 29, "b", "estúdialo en: simulacros de estudio 8·1·29 · libro: T10.4", "La tierra debe llegar a cada uno de los chasis metálicos, unidos entre sí",
  [En una estación, solo el transceptor está unido a la toma de tierra; la fuente de alimentación y el acoplador no tienen conexión alguna con ella. Esta instalación:],
  ([es correcta: basta con poner a tierra el equipo de más potencia], [es incorrecta: la tierra debe llegar a cada uno de los chasis metálicos, unidos entre sí], [es correcta, porque el acoplador no se alimenta de la red], [es correcta si el mástil de la antena también está a tierra],),
  sol: [La toma de tierra debe conectarse a cada uno de los chasis metálicos de la estación, interconectados entre sí. Un solo equipo sin tierra rompe la cadena de protección y es justo el punto peligroso. Poner a tierra el equipo principal o el mástil no protege los chasis que quedan sin conectar.], tema: "T10")
#pq(5, 1, 30, "d", "estúdialo en: simulacros de estudio 1·1·30 · libro: C-T10.6", "La pica de tierra se entierra en terreno húmedo, no seco y soleado",
  [Para clavar la pica de tierra se puede elegir entre un rincón del jardín sombreado y húmedo y una zona seca y soleada junto a la tapia. Conviene:],
  ([la zona seca, porque el sol evita los efectos de la humedad], [la zona seca, para que la toma no derive demasiada corriente], [cualquiera de los dos: la resistencia de la toma no depende del terreno], [el rincón húmedo, porque la humedad hace más conductor el terreno],),
  sol: [La resistencia de la toma de tierra depende sobre todo del terreno, y la humedad lo hace conductor: las picas se clavan en zonas húmedas y frescas, nunca en terreno seco y soleado. Una toma de tierra no «deriva demasiado»: cuanto menor sea su resistencia, mejor protege.], tema: "T10")
#fin-prueba()
#prueba(5, 2)
#pq(5, 2, 1, "a", "estúdialo en: simulacros de estudio 12·2·1 · libro: R1.23", "Para qué sirve el alfabeto fonético: deletrear letras y cifras sin confusiones (no cifra ni abrevia)",
  [Con mucho ruido, tu corresponsal no distingue si tu sufijo termina en B o en P. ¿Qué debes hacer?],
  ([deletrear la letra con su palabra del alfabeto fonético internacional: Bravo o Papa], [sustituir el sufijo por un grupo del código Q], [decir la letra seguida del nombre de una ciudad española que empiece por ella], [repetir la letra por su nombre en castellano, más despacio: «be» o «pe»],),
  sol: [El alfabeto fonético existe para deletrear letras y cifras sin confusiones: con ruido, «be» y «pe» suenan igual, pero Bravo y Papa no. El código Q abrevia frases, no deletrea, y las ciudades españolas pertenecen a alfabetos nacionales antiguos que no se usan en el servicio de aficionados.], tema: "R1")
#pq(5, 2, 2, "c", "estúdialo en: simulacros de estudio 4·2·2, 8·2·2 · libro: R2.29, R2.2", "QRM (interferencia de otras estaciones) frente a QRN (parásitos atmosféricos)",
  [Tu corresponsal te pasa «aquí mucho `QRN`». ¿Qué está oyendo en su receptor?],
  ([tu señal, cuya frecuencia se va desplazando], [tu señal subiendo y bajando de intensidad], [el crepitar y los chasquidos de las descargas de las tormentas], [una estación cercana que transmite encima del QSO],),
  sol: [`QRN` son los parásitos atmosféricos, el ruido natural de las tormentas. Una estación que transmite encima es `QRM`, la señal que sube y baja es `QSB` y la frecuencia que se desplaza es `QRH`.], tema: "R2")
#pq(5, 2, 3, "d", "estúdialo en: simulacros de estudio 6·2·2, 13·2·2 · libro: R2.15, C-R2.3", "QRS transmita más despacio / QRQ más deprisa",
  [En CW, tu corresponsal manipula tan rápido que no consigues copiarle. Le transmites:],
  ([`QSD`], [`QRX`], [`QRQ`], [`QRS`],),
  sol: [`QRS` pide que transmita más despacio. `QRQ` pediría lo contrario, más deprisa; `QRX` es que espere, y `QSD` avisa de que la manipulación es defectuosa, que no es el problema: el problema es la velocidad.], tema: "R2")
#pq(5, 2, 4, "b", "estúdialo en: simulacros de estudio 12·2·4 · libro: R2.16", "QSP retransmitir gratuitamente a…",
  [No consigues contacto directo con una estación lejana, y otra estación que os oye a las dos acepta hacerle llegar tu mensaje sin cobrar nada. ¿Qué grupo describe ese servicio?],
  ([`QSM`], [`QSP`], [`QTC`], [`QRW`],),
  sol: [`QSP` es retransmitir gratuitamente a la estación indicada. `QRW` solo avisa a otra estación de que se la llama en una frecuencia, sin pasarle mensaje; `QTC` anuncia mensajes pendientes y `QSM` pide repetir el último mensaje.], tema: "R2")
#pq(5, 2, 5, "c", "estúdialo en: simulacros de estudio 11·2·6 · libro: F-R3.4", "La T (tono) solo se da en telegrafía: 59 en fonía, 599 en CW",
  [En un contacto en SSB recibes a tu corresponsal perfectamente legible y con la máxima intensidad. ¿Qué informe le das?],
  ([95], [5], [59], [599],),
  sol: [En fonía el informe lleva solo dos cifras, legibilidad e intensidad: «59». La tercera cifra (tono) solo tiene sentido en telegrafía, así que «599» es el informe de CW. «95» invierte el orden: la legibilidad va primero y solo llega a 5.], tema: "R3")
#pq(5, 2, 6, "b", "estúdialo en: simulacros de estudio 3·2·4 · libro: F-R3.5", "Escala de legibilidad: R5 = perfectamente legible (R1 ilegible…)",
  [Copias a tu corresponsal, pero con considerable dificultad. ¿Qué cifra de legibilidad (R) le das?],
  ([1], [3], [4], [5],),
  sol: [La escala R va de 1 a 5: 1 ilegible, 2 apenas legible, 3 legible con considerable dificultad, 4 legible prácticamente sin dificultad y 5 perfectamente legible. El 4 tienta, pero corresponde a una señal que se copia casi sin esfuerzo.], tema: "R3")
#pq(5, 2, 7, "a", "estúdialo en: simulacros de estudio 1·2·7 · libro: C-R3.7", "Trabajar en split: emitir en una frecuencia y recibir en otra",
  [Una estación DX transmite en una frecuencia y anuncia que escucha 5 kHz más arriba. Para contactarla trabajando en \_split\_, tú:],
  ([recibes en la frecuencia del DX y transmites 5 kHz más arriba], [transmites en la frecuencia del DX y recibes 5 kHz más arriba], [transmites y recibes en la frecuencia del DX], [transmites y recibes 5 kHz más arriba],),
  sol: [En \_split\_ se emite en una frecuencia y se recibe en otra. Escuchas al DX donde él transmite y le llamas donde él escucha, 5 kHz más arriba. Transmitir en su frecuencia es justo lo que el \_split\_ intenta evitar en un \_pile-up\_.], tema: "R3")
#pq(5, 2, 8, "d", "estúdialo en: simulacros de estudio 10·2·8 · libro: R4.8", "Señal de alarma radiotelefónica: tonos alternos de 2200 y 1300 Hz",
  [De la señal de alarma radiotelefónica conoces uno de sus tonos, el de 2200 Hz. ¿De qué frecuencia es el otro, con el que se alterna?],
  ([1750 Hz], [1000 Hz], [2182 Hz], [1300 Hz],),
  sol: [La señal de alarma alterna tonos de 2200 y 1300 Hz y sirve para activar los dispositivos automáticos de escucha antes de un mensaje de socorro. El valor 2182 se confunde con la frecuencia de socorro en voz de MF, que es de 2182 kHz y no un tono de audio.], tema: "R4")
#pq(5, 2, 9, "a", "estúdialo en: simulacros de estudio 9·2·9 · libro: F-R4.9", "Segmento de satélites en 70 cm: 435–438 MHz",
  [Según el plan de bandas de la IARU para la Región 1, la frecuencia de 436,500 MHz está en el segmento de 70 cm dedicado a:],
  ([satélites], [repetidores], [la banda ICM], [uso mixto],),
  sol: [El plan reserva al servicio de satélite el tramo de 435 a 438 MHz, donde cae 436,500 MHz. Los repetidores y el uso mixto ocupan otros tramos de la banda, y la banda ICM es 433,050–434,790 MHz.], tema: "R4")
#pq(5, 2, 10, "b", "estúdialo en: simulacros de estudio 8·2·12 · libro: C-R5.14", "Las series de prefijos las atribuye la UIT (Reglamento de Radiocomunicaciones) y cada país asigna dentro de ellas",
  [Las series de prefijos EA–EH y AM–AO de los distintivos españoles se atribuyen a España:],
  ([por la asociación nacional de radioaficionados, que las reparte entre sus socios], [por la UIT, en el Reglamento de Radiocomunicaciones; después la Administración española asigna los distintivos dentro de ellas], [por la IARU, en sus planes de bandas], [por cada Jefatura Provincial de Inspección, para su provincia],),
  sol: [La UIT atribuye a cada país series de caracteres en el Reglamento de Radiocomunicaciones, y cada Administración compone los distintivos dentro de las suyas. La IARU solo agrupa asociaciones y redacta planes de bandas; no reparte prefijos. Ojo: algunas recopilaciones antiguas dan como clave la CEPT, que tampoco los atribuye.], tema: "R5")
#pq(5, 2, 11, "c", "estúdialo en: simulacros de estudio 11·2·12 · libro: R5.7", "Hay nueve distritos geográficos (1 a 9); el 0 es especial",
  [¿Cuál de estas cifras no corresponde a ninguna zona geográfica en los distintivos españoles?],
  ([1], [9], [0], [6],),
  sol: [Hay nueve distritos geográficos, del 1 al 9 (el 6 es Baleares y el 9 Ceuta y Melilla). El 0 no identifica ninguna zona: se reserva para actos inaugurados o visitados por S. M. el Rey.], tema: "R5")
#pq(5, 2, 12, "a", "estúdialo en: simulacros de estudio 6·2·10, 12·2·12 · libro: C-R5.7, R5.9", "Estaciones automáticas desatendidas: prefijo ED; sufijo con Y (analógica) o Z (digital)",
  [Escuchas un repetidor que se identifica como ED7YAC. ¿Qué puedes deducir?],
  ([Es una estación automática desatendida analógica del distrito 7], [Es una estación automática desatendida digital del distrito 7], [Es un distintivo temporal de un concursante de Andalucía], [Es la estación colectiva de un radioclub andaluz],),
  sol: [ED es el prefijo de las desatendidas y la Y inicial del sufijo indica que es analógica (la Z sería digital). ED también puede ser prefijo temporal, pero entonces conserva el sufijo personal del titular, y un sufijo con Y nunca lo es.], tema: "R5")
#pq(5, 2, 13, "b", "estúdialo en: simulacros de estudio 6·2·12, 10·2·12 · libro: R5.15, C-R5.11", "Prefijos temporales ED, EE y EF: eventos ordinarios; mantienen el resto del distintivo",
  [EA2XYZ obtiene autorización para usar el prefijo temporal EF en un concurso de ámbito nacional. Emitirá como:],
  ([EF0XYZ], [EF2XYZ], [EF2 con un sufijo propio que le asigne la Administración], [EA2XYZ/EF],),
  sol: [Con ED, EE y EF solo cambia el prefijo: la cifra y el sufijo del distintivo permanente se mantienen. El sufijo propio es lo que llevan EG, EH, AM, AN y AO, y la cifra 0 está reservada a actos del Rey.], tema: "R5")
#pq(5, 2, 14, "c", "estúdialo en: simulacros de estudio 5·2·14 · libro: F-R6.14", "Canal de llamada de FM en 10 m: 29,600 MHz",
  [¿Qué función tiene la frecuencia de 29,600 MHz en el plan HF de la IARU para la Región 1?],
  ([comienzo del segmento de satélites], [salida de repetidores de FM], [canal de llamada de FM], [entrada de repetidores de FM],),
  sol: [En el extremo alto de 10 m, 29,600 MHz es el canal de llamada de FM, situado entre las entradas de repetidores (29,520–29,590 MHz) y sus salidas (29,620–29,700 MHz). El segmento de satélites va de 29,300 a 29,510 MHz.], tema: "R6")
#pq(5, 2, 15, "d", "estúdialo en: simulacros de estudio 4·2·15, 12·2·14 · libro: F-R6.7, C-R6.5", "Convenio de banda lateral: LSB por debajo de 10 MHz, USB por encima; excepción 60 m en USB",
  [Un operador pasa de hacer fonía en SSB en 80 m a hacerla en 20 m. Con la banda lateral debe:],
  ([mantener LSB, que es la de todas las bandas de HF], [pasar de USB a LSB], [mantener USB, que es la de todas las bandas de HF], [pasar de LSB a USB],),
  sol: [En 80 m (3,5 MHz), por debajo de 10 MHz, se usa LSB; en 20 m (14 MHz), por encima, USB. Por eso al cambiar de banda hay que cambiar también de banda lateral, y en este sentido: de la inferior a la superior.], tema: "R6")
#pq(5, 2, 16, "d", "estúdialo en: simulacros de estudio 7·2·14 · libro: F-R6.4", "80 m: segmento de CW 3.500–3.570 kHz",
  [¿Cuál de estas frecuencias está en el segmento que el plan HF de la IARU para la Región 1 marca para telegrafía en 80 m?],
  ([3.650 kHz], [3.585 kHz], [3.750 kHz], [3.530 kHz],),
  sol: [El segmento de CW de 80 m va de 3.500 a 3.570 kHz, y 3.530 kHz está dentro. 3.585 kHz cae en el de banda estrecha y digimodos (3.570–3.600 kHz), y 3.650 y 3.750 kHz, en el de todos los modos, donde se hace la fonía.], tema: "R6")
#pq(5, 2, 17, "b", "estúdialo en: simulacros de estudio 13·2·16 · libro: F-R7.2", "Código del Radioaficionado: considerado, leal, progresista, amistoso, equilibrado y patriota",
  [Según el Código del Radioaficionado, ser «equilibrado» significa que:],
  ([se es paciente con el principiante y se está dispuesto a ayudar], [la radio es una afición que no debe quitar tiempo a la familia, al trabajo, a los estudios ni a la comunidad], [la estación debe estar bien construida y al día, y la operación ser irreprochable], [se apoya a los demás aficionados, a los radioclubes y a la asociación nacional],),
  sol: [Cada rasgo del Código tiene su sentido: equilibrado es no dejar que la radio robe tiempo a familia, trabajo, estudios o comunidad. La estación al día corresponde a progresista, el apoyo a la asociación a leal y la paciencia con el principiante a amistoso.], tema: "R7")
#pq(5, 2, 18, "a", "estúdialo en: simulacros de estudio 3·2·16 · libro: F-R8.10", "Ley General de Telecomunicaciones vigente: Ley 11/2022",
  [La Ley 11/2022, de 28 de junio, es:],
  ([la Ley General de Telecomunicaciones vigente, que derogó la Ley 9/2014], [la ley de antenas que sustituyó a la Ley 19/1983], [la ley de procedimiento administrativo que sustituyó a la Ley 30/1992], [la norma que aprueba el Reglamento sobre el uso del dominio público radioeléctrico, en lugar del Real Decreto 863/2008],),
  sol: [La Ley 11/2022 es la Ley General de Telecomunicaciones vigente: derogó la Ley 9/2014, que a su vez había sustituido a la Ley 32/2003 que cita la Orden IET/1311/2013. La Ley 19/1983 (antenas) sigue vigente; la Ley 30/1992 la sustituyó la Ley 39/2015, y el Real Decreto 863/2008, el Real Decreto 123/2017.], tema: "R8")
#pq(5, 2, 19, "d", "estúdialo en: simulacros de estudio 6·2·21 · libro: F-R8.72", "Seguridad: la SETSI no es responsable en ningún caso del incumplimiento de las normas de seguridad",
  [Se cae la antena de una estación que incumplía las normas de seguridad aplicables y causa daños. Según el artículo 31, ¿qué responsabilidad tiene la SETSI?],
  ([responde solidariamente con el titular, por haber expedido la licencia], [responde si la Jefatura Provincial no había inspeccionado la instalación en el último año], [responde de los daños que no cubra el seguro de responsabilidad civil del titular], [ninguna: no es responsable en ningún caso del incumplimiento de esas normas, cuyo cumplimiento corresponde al titular],),
  sol: [El art. 31 obliga al titular de la autorización a cumplir la normativa de seguridad para evitar accidentes derivados del uso de sus estaciones, y añade que la SETSI no es responsable, en ningún caso, del incumplimiento de esas normas. Conceder la licencia no traslada la responsabilidad a la Administración, ni la hace responder de lo que no cubra el seguro. La falta de inspección tampoco la convierte en responsable.], tema: "R8")
#pq(5, 2, 20, "c", "estúdialo en: simulacros de estudio 9·2·20 · libro: F-R8.73", "Anomalía de seguridad mecánica o eléctrica: subsanarla de forma inmediata",
  [Tras un temporal, ves que el cable de alimentación de tu antena tiene el aislamiento dañado. Según el artículo 31, debes:],
  ([dejar de emitir hasta la siguiente revisión periódica de la instalación], [repararlo en el plazo de un mes, el mismo que se da a la comunidad para avisar de obras], [subsanar la anomalía de forma inmediata], [comunicarlo a la Jefatura Provincial y esperar su inspección antes de tocar nada],),
  sol: [El art. 31 obliga a mantener adecuadamente equipos, antenas y elementos anejos y a subsanar de forma inmediata cualquier anomalía que afecte a su seguridad mecánica o eléctrica. Un aislamiento dañado afecta a la seguridad eléctrica, así que no hay plazo de gracia ni se espera a nadie. El mes es el preaviso de la comunidad para obras, otro supuesto.], tema: "R8")
#pq(5, 2, 21, "b", "estúdialo en: simulacros de estudio 6·2·23 · libro: R8.31", "Licencia CEPT: sin protección contra interferencias perjudiciales",
  [Operando en otro país con licencia CEPT, una estación local te causa interferencia perjudicial. Según el artículo 14.f de la Orden:],
  ([tienes prioridad por ser estación visitante], [no puedes solicitar protección contra esa interferencia], [puedes pedir protección a través de la SETSI], [puedes pedir protección a la Administración local, como cualquier estación de ese país],),
  sol: [El titular de una licencia CEPT que emite fuera de su territorio nacional no puede solicitar protección contra interferencias perjudiciales (art. 14.f). Es una condición de la licencia, no de la categoría de la banda, y no cambia porque se acuda a la SETSI. Tampoco hay prioridad alguna para el visitante.], tema: "R8")
#pq(5, 2, 22, "c", "estúdialo en: simulacros de estudio 5·2·21 · libro: C-R8.28", "Naturaleza de la autorización: individual, personal e intransferible, revocable",
  [Un radioaficionado quiere ceder su autorización a su hijo, que no se ha examinado. Esto:],
  ([es posible si el hijo usa el distintivo del padre seguido de una barra], [es posible si el padre lo comunica previamente a la SETSI], [no es posible: la autorización es personal e intransferible, y el hijo necesita la suya propia tras superar la prueba], [es posible si el hijo es menor de edad y el padre asume por escrito su responsabilidad],),
  sol: [La autorización es individual, personal e intransferible: no se cede ni por comunicación ni por parentesco. El escrito de los padres sirve para que un menor obtenga su propia autorización, no para heredar la de otro. Además, puede revocarse y se extingue con el fallecimiento del titular.], tema: "R8")
#pq(5, 2, 23, "a", "estúdialo en: simulacros de estudio 10·2·24 · libro: R8.86", "La estación debe tener elementos para comprobar que la emisión está en banda y medir la potencia",
  [Durante una inspección, ¿qué debes poder comprobar con los medios de tu propia estación, según el anexo I de la Orden?],
  ([Que la emisión se produce dentro de la banda autorizada y, de forma indicativa, qué potencia emites], [Que la ganancia de tu antena no supera los 6 dBd], [Que todos tus equipos llevan marcado CE], [Que la relación de ondas estacionarias de la antena es inferior a 1,5],),
  sol: [El apartado 4.5 del anexo I exige elementos para comprobar que la emisión está dentro de las bandas autorizadas y para medir de forma indicativa la potencia. No se exige medidor de ondas estacionarias. El límite de 6 dBd es de las estaciones desatendidas, y los equipos de construcción propia no llevan marcado CE.], tema: "R8")
#pq(5, 2, 24, "d", "estúdialo en: simulacros de estudio 1·2·25 · libro: R8.74", "Obras en el inmueble: aviso al titular con 1 mes de antelación",
  [La comunidad de propietarios va a rehabilitar la cubierta a partir del 1 de junio y necesita que se desmonte tu antena. Salvo urgencia, ¿cuál es la fecha más tardía en que debe comunicártelo de forma fehaciente?],
  ([El 1 de abril], [El 20 de abril], [El 17 de mayo], [El 1 de mayo],),
  sol: [La propiedad debe avisar al titular con un mes de antelación, para que desmonte él mismo la instalación o lo presencie: para obras que empiezan el 1 de junio, como tarde el 1 de mayo. El 17 de mayo serían quince días, el 20 de abril seis semanas y el 1 de abril dos meses, cifras de otros trámites.], tema: "R8")
#pq(5, 2, 25, "a", "estúdialo en: simulacros de estudio 3·2·23 · libro: R8.26", "Usos experimentales con características distintas de las generales: requieren autorización especial",
  [Un radioaficionado quiere probar durante unos meses, con fines experimentales, una potencia superior a la máxima del anexo I en una banda. Según el Reglamento:],
  ([necesita una autorización especial para usos experimentales], [puede hacerlo sin trámite si avisa a la Jefatura con cinco días de antelación], [puede hacerlo como modificación experimental de su estación fija durante 60 días], [puede hacerlo si el equipo es de construcción propia, que no requiere autorización previa],),
  sol: [Emitir con características técnicas distintas de las generales del Reglamento requiere una autorización especial (art. 17). Los 60 días de modificación experimental de la estación fija no permiten salirse del anexo I, y el aviso de cinco días es del uso portable. Que el equipo sea casero le exime de autorización del equipo, no de respetar las características de las emisiones.], tema: "R8")
#pq(5, 2, 26, "d", "estúdialo en: simulacros de estudio 7·2·27 · libro: C-R8.1", "Autorización especial experimental: pedirla con al menos 1 mes de antelación",
  [Quieres empezar el 15 de septiembre unas emisiones que requieren autorización especial experimental. ¿Cuál es la fecha más tardía para presentar la solicitud?],
  ([El 4 de agosto], [El 10 de septiembre], [El 15 de julio], [El 15 de agosto],),
  sol: [La autorización especial experimental se solicita con al menos un mes de antelación a la fecha prevista para empezar a emitir: para el 15 de septiembre, como tarde el 15 de agosto. El 10 de septiembre aplicaría los cinco días del uso portable, el 4 de agosto seis semanas y el 15 de julio dos meses.], tema: "R8")
#pq(5, 2, 27, "b", "estúdialo en: simulacros de estudio 12·2·27 · libro: F-R8.49", "Estación colectiva: responsable la Junta Directiva de la asociación",
  [Unos amigos radioaficionados, sin formar asociación, quieren montar una estación colectiva y repartirse su uso. ¿Qué establece el artículo 18.6 sobre la titularidad y el uso de estas estaciones?],
  ([Pueden autorizarse a cualquier grupo de radioaficionados, y de su utilización responde el miembro con más antigüedad], [Solo pueden autorizarse a asociaciones de radioaficionados reconocidas, y de su utilización responde la Junta Directiva de la asociación], [Pueden autorizarse a cualquier radioaficionado con autorización en vigor, que responde de su utilización], [Solo pueden autorizarse a asociaciones reconocidas, y de su utilización responde la Jefatura Provincial que expidió la licencia],),
  sol: [El art. 18.6 reserva las estaciones colectivas a las asociaciones de radioaficionados reconocidas y hace responsable de su utilización a la Junta Directiva de la asociación. La Jefatura Provincial expide la licencia e inspecciona, pero no responde del uso de la estación. Un grupo informal o un radioaficionado particular no pueden ser titulares de una colectiva.], tema: "R8")
#pq(5, 2, 28, "c", "estúdialo en: simulacros de estudio 4·2·27 · libro: F-R8.59", "Tipos de desatendidas (art. 24): repetidores analógicos, digitales, de nodo, finales y radiobalizas",
  [¿Cuál de las siguientes estaciones NO figura entre las estaciones automáticas desatendidas que enumera el artículo 24?],
  ([la radiobaliza], [el repetidor de portadora o nodo], [la estación fija remota], [el repetidor final],),
  sol: [El art. 24 enumera como desatendidas los repetidores analógicos, los digitales, los de portadora o nodo y los finales, y las radiobalizas. La fija remota es una estación fija accionada a distancia por su titular, que la opera: no es una estación colectiva sin intervención directa del operador. Los nombres técnicos de nodo y final pueden parecer extraños, pero sí están en la lista.], tema: "R8")
#pq(5, 2, 29, "a", "estúdialo en: simulacros de estudio 6·2·29 · libro: R9.14", "Obligación de permitir la inspección; solo el domicilio protegido exige consentimiento o autorización judicial",
  [La estación de Ana está en su vivienda habitual. Si la inspección de telecomunicaciones necesita entrar en ella y Ana no lo consiente, la inspección:],
  ([necesita autorización judicial para entrar], [puede entrar igualmente, porque la autorización de radioaficionado implica renunciar a la inviolabilidad del domicilio], [debe archivar la actuación sin más trámite], [puede entrar si la acompaña un agente de la policía local],),
  sol: [El art. 103.2 de la Ley 11/2022 obliga a permitir el acceso de la inspección, pero cuando hay que entrar en un domicilio constitucionalmente protegido hace falta el consentimiento del titular o autorización judicial. Sin consentimiento, queda la vía judicial; no se archiva sin más. La autorización de radioaficionado no supone renunciar a la protección del domicilio, y la compañía de un agente no sustituye a la autorización judicial.], tema: "R9")
#pq(5, 2, 30, "d", "estúdialo en: simulacros de estudio 5·2·30 · libro: F-R9.10", "Grave: superar los límites de exposición o no señalizar/vallar",
  [Un radioaficionado emite dentro de la potencia máxima de su autorización, pero en una zona de paso accesible al público se superan los límites de exposición y la instalación carece de la señalización exigida. Según la Ley 11/2022:],
  ([comete una infracción leve, por tratarse de una simple medida de seguridad], [comete una infracción muy grave en todo caso], [no comete infracción, porque no supera la potencia máxima autorizada], [comete una infracción grave, aunque respete la potencia máxima autorizada],),
  sol: [Efectuar emisiones que incumplan los límites de exposición, o no cumplir la señalización o el vallado, es infracción grave (art. 107.7). Respetar la potencia máxima no basta: el Anexo I, 3.5, de la Orden exige reducir la potencia, si hace falta, para que la energía radiada quede por debajo del límite en los lugares accesibles o de paso. Ese es el error que comete quien cree estar cubierto por la potencia autorizada.], tema: "R9")
#fin-prueba()
#soluciones-simulacro(5)

// ======================================================================
#simulacro(6)
#prueba(6, 1)
#pq(6, 1, 1, "c", "estúdialo en: simulacros de estudio 3·1·1, 8·1·2 · libro: T1.42, C-T1.29", "Asociación de pilas: en serie se suman las tensiones; en paralelo, las corrientes (y baja la resistencia interna)",
  [Se conectan en serie seis pilas de 1,5 V, cada una con 0,2 Ω de resistencia interna. El conjunto equivale a una fuente de:],
  ([9 V con 0,033 Ω de resistencia interna], [1,5 V con 1,2 Ω de resistencia interna], [9 V con 1,2 Ω de resistencia interna], [1,5 V con 0,033 Ω de resistencia interna],),
  sol: [En serie se suman las fems, $6 times 1","5 = 9$ V, y también las resistencias internas, $6 times 0","2 = 1","2$ Ω, porque la corriente atraviesa todas las pilas una tras otra. La tensión de una sola pila y los 0,033 Ω ($0","2 slash 6$) corresponden a la asociación en paralelo.], tema: "T1")
#pq(6, 1, 2, "d", "estúdialo en: simulacros de estudio 13·1·3 · libro: T1.14", "Las ondas de radio son electromagnéticas",
  [Una sonda espacial puede comunicarse por radio con la Tierra a través del vacío del espacio porque las ondas de radio:],
  ([son ondas gravitatorias, que atraviesan cualquier medio], [son ondas acústicas que en el vacío viajan a la velocidad de la luz], [son ondas mecánicas de frecuencia mucho más alta que la del sonido], [son ondas electromagnéticas, que no necesitan un medio material para propagarse],),
  sol: [Las ondas de radio son electromagnéticas: campos eléctrico y magnético que se sostienen mutuamente y se propagan sin necesidad de medio material, igual que la luz. Las ondas mecánicas, como el sonido, necesitan un medio que vibre y no atraviesan el vacío.], tema: "T1")
#pq(6, 1, 3, "b", "estúdialo en: simulacros de estudio 7·1·1, 12·1·3 · libro: T1.15, C-T1.4", "Velocidad de propagación: c = 300.000 km/s, constante y sin depender de la frecuencia",
  [Desde la misma antena se emiten a la vez dos señales, una de 3,5 MHz y otra de 430 MHz, hacia una nave en el espacio. Respecto a la de 3,5 MHz, la de 430 MHz llega:],
  ([después, porque su longitud de onda es menor], [al mismo tiempo, porque en el vacío la velocidad no depende de la frecuencia], [antes, porque su longitud de onda es menor], [antes, porque su frecuencia es mayor],),
  sol: [En el vacío todas las ondas electromagnéticas viajan a $c approx 300.000$ km/s sea cual sea su frecuencia. Lo que cambia con la frecuencia es la longitud de onda ($lambda = c slash f$), no la velocidad, así que las dos llegan a la vez.], tema: "T1")
#pq(6, 1, 4, "d", "estúdialo en: simulacros de estudio 2·1·3 · libro: F-T1.38", "En una cadena, las ganancias y pérdidas en dB se suman y restan",
  [Un transmisor de 10 W excita un amplificador lineal de 13 dB de ganancia, y la línea hasta la antena pierde 3 dB. La potencia que llega a la antena es de unos:],
  ([50 W], [200 W], [130 W], [100 W],),
  sol: [Ganancia neta: $13 - 3 = 10$ dB, es decir, ×10, y $10 times 10 = 100$ W. Los 200 W olvidan la pérdida de la línea (13 dB son ×20); los 130 W multiplican los vatios por los decibelios, y los 50 W aplican la pérdida de 3 dB como si dividiera entre 4.], tema: "T1")
#pq(6, 1, 5, "c", "estúdialo en: simulacros de estudio 11·1·7 · libro: T2.40", "La autoinducción depende de la construcción de la bobina (núcleo, dimensiones, temperatura), no de la señal",
  [Se quiere aumentar la autoinducción de una bobina sin cambiar sus dimensiones. ¿Qué medida lo consigue?],
  ([separar las espiras alargando el devanado], [hacerla trabajar a una frecuencia más alta], [devanar el doble de espiras en el mismo espacio, con lo que L se multiplica por cuatro], [hacer circular por ella una corriente mayor],),
  sol: [La autoinducción depende de cómo está construida la bobina: crece como el cuadrado del número de espiras, con el diámetro y con el núcleo, y baja al alargar el devanado. La frecuencia aumenta la reactancia $X_L$, no L, y la corriente que la recorre no cambia la autoinducción.], tema: "T2")
#pq(6, 1, 6, "a", "estúdialo en: simulacros de estudio 10·1·7 · libro: F-T2.4", "Cálculo de la reactancia inductiva X_L = 2πfL",
  [¿Qué autoinducción debe tener una bobina para presentar una reactancia de unos 628 Ω a 10 MHz?],
  ([10 μH], [1 μH], [100 μH], [62,8 μH],),
  sol: [Despejando, $L = X_L / (2 pi f) = 628 / (2 pi dot 10^7) approx 10^(-5)$ H, es decir, 10 μH. Si se olvida el $2 pi$ salen 62,8 μH. Las otras dos opciones son errores de un factor 10.], tema: "T2")
#pq(6, 1, 7, "c", "estúdialo en: simulacros de estudio 4·1·7 · libro: T2.60", "El transformador también sirve para adaptar impedancias",
  [Una válvula de audio necesita ver en su placa una carga de unos 5000 Ω, y el altavoz es de 8 Ω. ¿Qué se intercala entre ambos para adaptarlos sin desperdiciar la potencia en calor?],
  ([un condensador electrolítico], [un diodo zéner], [un transformador], [una resistencia en serie de unos 4992 Ω],),
  sol: [El transformador adapta impedancias: con la relación de espiras adecuada, el altavoz de 8 Ω «parece» desde la válvula una carga de 5000 Ω. Una resistencia en serie sumaría los ohmios que faltan, pero disiparía en calor casi toda la potencia.], tema: "T2")
#pq(6, 1, 8, "b", "estúdialo en: simulacros de estudio 12·1·9 · libro: T2.21", "El diodo deja pasar la corriente en un solo sentido",
  [Un diodo se conecta en serie entre una pila y una bombilla, y la bombilla luce. Si se da la vuelta al diodo, la bombilla:],
  ([luce igual, porque el diodo conduce en los dos sentidos], [se apaga, porque el diodo queda polarizado en inversa y bloquea la corriente], [luce con la mitad de brillo, porque solo pasa media corriente], [luce con más brillo, porque en inversa el diodo no tiene caída de tensión],),
  sol: [El diodo deja pasar la corriente en un solo sentido: en directa conduce, y en inversa su zona de deplexión se ensancha y bloquea, salvo una pequeña corriente de fuga. La idea de la mitad de brillo confunde este caso con un rectificador de media onda en alterna; con una pila no hay semiciclos.], tema: "T2")
#pq(6, 1, 9, "b", "estúdialo en: simulacros de estudio 6·1·10 · libro: F-T3.2", "Resistencia equivalente: serie suma, paralelo menor que la menor (producto/suma; n iguales, R/n); circuitos mixtos",
  [Una resistencia de 100 Ω está en serie con dos resistencias iguales conectadas entre sí en paralelo. Si la resistencia total del conjunto es de 150 Ω, cada una de las dos resistencias iguales vale:],
  ([25 Ω], [100 Ω], [50 Ω], [75 Ω],),
  sol: [El bloque en paralelo debe aportar $150 - 100 = 50$ Ω. Dos resistencias iguales en paralelo equivalen a la mitad de una de ellas, así que cada una vale $2 dot 50 = 100$ Ω. Los 50 Ω olvidan que el paralelo divide por dos, y los 25 Ω tratan las dos iguales como si estuvieran en serie.], tema: "T3")
#pq(6, 1, 10, "a", "estúdialo en: simulacros de estudio 1·1·10 · libro: T3.57", "Condensador en continua, en régimen permanente: circuito abierto (queda el divisor resistivo)",
  [Una pila de 10 V alimenta una resistencia de 4 kΩ en serie con un conjunto formado por una resistencia de 1 kΩ y un condensador conectados en paralelo. Una vez alcanzado el régimen permanente, la corriente que entrega la pila es de:],
  ([2 mA], [2,5 mA], [12,5 mA], [0 mA],),
  sol: [En régimen permanente el condensador ya está cargado y por su rama no circula corriente: es un circuito abierto. Queda la pila con las dos resistencias en serie, $I = 10 slash (4 + 1) = 2$ mA. Los 0 mA olvidan que la corriente sigue pasando por la resistencia de 1 kΩ; los 2,5 mA tratan el condensador como un cortocircuito que puentea esa resistencia; y los 12,5 mA conectan las dos resistencias directamente a la pila, como si estuvieran en paralelo.], tema: "T3")
#pq(6, 1, 11, "d", "estúdialo en: simulacros de estudio 9·1·10 · libro: F-T3.4", "Filtro digital (DSP): opera con muestras numéricas; cadena A/D → cálculo en el DSP → D/A",
  [Un filtro digital procesa el audio analógico que sale del detector de un receptor. El bloque situado justo a la salida del DSP es:],
  ([un conversor A/D, que convierte la señal en números], [un detector de envolvente, que recupera el audio], [un filtro antisolapamiento, que limita la señal antes del muestreo], [un conversor D/A, que convierte en tensión las muestras calculadas],),
  sol: [El DSP solo trabaja con números: a su entrada hace falta un conversor A/D (precedido del filtro antisolapamiento) y a su salida un conversor D/A que devuelva una señal analógica, seguido del filtro de reconstrucción. El A/D y el antisolapamiento van antes del DSP, no después.], tema: "T3")
#pq(6, 1, 12, "d", "estúdialo en: simulacros de estudio 4·1·14 · libro: C-T3.18", "Colector común = seguidor de emisor (ganancia de tensión ≈ 1; adaptador de impedancias)",
  [Para conectar una fuente de señal de impedancia alta a una carga de impedancia baja sin cargar la fuente, se intercala un transistor montado en:],
  ([emisor común con un circuito tanque en el colector], [base común], [emisor común], [colector común],),
  sol: [El colector común o seguidor de emisor tiene impedancia de entrada alta e impedancia de salida muy baja, con ganancia de tensión casi 1: es el adaptador de impedancias o separador. La base común tiene la entrada de impedancia muy baja, justo lo contrario de lo que se necesita, y el emisor común está pensado para amplificar, no para adaptar.], tema: "T3")
#pq(6, 1, 13, "c", "estúdialo en: simulacros de estudio 13·1·14 · libro: T3.38", "Detector de envolvente (diodo + RC): detector de AM; reconocer su esquema",
  [El detector de envolvente de un receptor de AM está formado por:],
  ([un comparador de fase, un filtro de lazo y un VCO], [un mezclador alimentado por un oscilador de batido y un filtro paso bajo], [un diodo seguido de una resistencia y un condensador en paralelo], [dos circuitos sintonizados simétricos, cada uno con su diodo],),
  sol: [El diodo rectifica la señal de FI y el condensador, que se carga en cada pico y se descarga un poco por la resistencia, sigue la envolvente: el audio. El mezclador con BFO es el detector de producto de SSB y CW; los dos circuitos sintonizados simétricos forman el discriminador de FM, y el comparador de fase con VCO es un PLL.], tema: "T3")
#pq(6, 1, 14, "b", "estúdialo en: simulacros de estudio 10·1·15 · libro: T4.2", "Superheterodino: la FI es una frecuencia fija, presente a la salida del mezclador (de ahí el nombre)",
  [Un receptor superheterodino recorre la banda de 40 m, de 7,000 a 7,200 MHz. Mientras giras el mando de sintonía, la frecuencia intermedia:],
  ([baja de 7,200 a 7,000 MHz, en sentido contrario a la señal], [se mantiene fija, porque lo que se desplaza es el oscilador local], [sube de 7,000 a 7,200 MHz, siguiendo a la señal sintonizada], [varía 200 kHz, al mismo ritmo que el oscilador local],),
  sol: [La idea del superheterodino es mover la señal, no los filtros: al sintonizar solo se desplaza el oscilador local, y el mezclador lleva cada señal a la misma FI fija, donde los filtros están optimizados de una vez. Si la FI siguiera a la señal, el receptor volvería a tener los problemas del receptor de RF sintonizada. El oscilador local sí recorre 200 kHz, pero la diferencia entre él y la señal, que es la FI, no cambia.], tema: "T4")
#pq(6, 1, 15, "a", "estúdialo en: simulacros de estudio 13·1·15 · libro: T4.36", "El mezclador necesita el oscilador local: bloque que falta en un diagrama",
  [¿Qué dos señales se aplican al mezclador de un receptor superheterodino?],
  ([la señal de RF procedente de la antena y la del oscilador local], [la señal de FI y la del oscilador de batido (BFO)], [la señal de audio y la del oscilador local], [la señal de RF procedente de la antena y la del limitador],),
  sol: [El mezclador combina la señal de antena con la del oscilador local y de su diferencia sale la FI; sin oscilador no hay conversión y no se oye nada. La pareja FI y BFO es la del detector de producto, en SSB y CW, no la del mezclador. El limitador es de FM y va después de la FI.], tema: "T4")
#pq(6, 1, 16, "b", "estúdialo en: simulacros de estudio 2·1·16 · libro: T4.17", "El margen dinámico lo determina el primer mezclador",
  [El primer mezclador es la etapa que más limita el margen dinámico de un receptor porque:],
  ([es la etapa que fija la anchura de banda del receptor], [recibe las señales fuertes vecinas con todo su nivel, antes del filtro estrecho de FI], [es la etapa que genera la frecuencia imagen], [es la etapa con más ganancia de todo el receptor],),
  sol: [Delante del primer mezclador solo hay un preselector ancho, así que le llegan a la vez la señal débil y las vecinas fuertes, sin filtrar; si no es lineal, fabrica intermodulación. Tras el filtro de FI las vecinas ya no están. Por eso los buenos receptores ponen un filtro estrecho de techo justo detrás de él. La anchura de banda la fija el filtro de FI, no el mezclador.], tema: "T4")
#pq(6, 1, 17, "a", "estúdialo en: simulacros de estudio 7·1·18 · libro: T5.25", "Etapa separadora: aísla el oscilador de las variaciones de carga",
  [En un transmisor de CW sin etapa separadora, la nota pía (chirp) cada vez que se manipula. La causa es que:],
  ([los cambios de carga de las etapas siguientes mueven la frecuencia del oscilador], [el filtro paso bajo deja pasar los armónicos], [la manipulación brusca genera chasquidos que ensanchan la emisión], [el multiplicador multiplica la desviación de frecuencia],),
  sol: [Un oscilador es sensible a la carga que tiene conectada: al manipular cambia la carga y su frecuencia se mueve, y eso es el chirp. La etapa separadora le hace ver siempre la misma carga. Los chasquidos de manipulación son otro defecto distinto, debido a flancos demasiado bruscos.], tema: "T5")
#pq(6, 1, 18, "c", "estúdialo en: simulacros de estudio 4·1·19", "Desplazamiento del repetidor en 2 m: entrada 600 kHz por debajo de la salida",
  [Un repetidor de 2 m tiene su frecuencia de salida en 145,725 MHz. Para trabajar a través de él, tu equipo debe transmitir en:],
  ([145,725 MHz], [146,325 MHz], [145,125 MHz], [139,725 MHz],),
  sol: [En 2 m la entrada del repetidor está 600 kHz por debajo de la salida: $145","725 - 0","600 = 145","125$ MHz. Los 146,325 MHz ponen el desplazamiento al revés, los 139,725 MHz confunden 600 kHz con 6 MHz y transmitir en la propia salida no funciona, porque el repetidor trabaja en dúplex.], tema: "T5")
#pq(6, 1, 19, "d", "estúdialo en: simulacros de estudio 7·1·21 · libro: C-T6.1", "Dipolo en V invertida: ≈ 50 Ω, casi omnidireccional y un solo mástil",
  [Un dipolo horizontal tendido entre dos soportes se vuelve a montar en V invertida, con el centro en un único mástil y los brazos caídos. Su impedancia de alimentación:],
  ([sube de unos 73 Ω a unos 300 Ω], [baja a unos 36 Ω, como la de una vertical de cuarto de onda], [no cambia, porque la longitud del hilo es la misma], [baja de unos 73 Ω a unos 50 Ω],),
  sol: [Al inclinar los brazos hacia abajo la impedancia del dipolo baja a unos 50 Ω, justo la del coaxial; además el diagrama se vuelve casi omnidireccional y basta un solo mástil. Los 300 Ω son los del dipolo plegado y los 36 Ω, los de la vertical de cuarto de onda. Aunque el hilo mida lo mismo, la geometría cambia la impedancia.], tema: "T6")
#pq(6, 1, 20, "c", "estúdialo en: simulacros de estudio 10·1·20 · libro: T6.6", "Dipolo plegado: impedancia unas cuatro veces mayor (≈ 300 Ω)",
  [Se quiere alimentar una antena directamente con línea bifilar de 300 Ω, sin ningún adaptador. De las siguientes, la más adecuada es:],
  ([un dipolo simple de media onda alimentado en el centro], [una vertical de cuarto de onda], [un dipolo plegado], [un dipolo en V invertida],),
  sol: [En el dipolo plegado los dos conductores se reparten la corriente: con la mitad de corriente en los bornes, para radiar la misma potencia la resistencia debe ser cuatro veces mayor, unos $4 times 73 approx 300$ Ω, justo la impedancia de la línea bifilar. El dipolo simple da unos 73 Ω, la V invertida unos 50 Ω y la vertical de cuarto de onda unos 36 Ω.], tema: "T6")
#pq(6, 1, 21, "a", "estúdialo en: simulacros de estudio 12·1·21 · libro: C-T6.15", "Definición de la ROE: Vmáx / Vmín (o Imáx / Imín) de la onda estacionaria",
  [Sobre una línea con onda estacionaria se mide una tensión máxima de 60 V y una mínima de 20 V. La ROE es:],
  ([3], [2], [0,33], [9],),
  sol: [La ROE es el cociente entre el máximo y el mínimo de la onda estacionaria: ROE = 60 / 20 = 3. El 2 sale de dividir la diferencia (40 V) entre el mínimo; el 0,33 es el cociente al revés, imposible porque la ROE nunca baja de 1; y el 9 sería la relación de potencias, el cuadrado de la ROE.], tema: "T6")
#pq(6, 1, 22, "d", "estúdialo en: simulacros de estudio 6·1·22 · libro: T6.17", "Orden de conexión: transceptor → (lineal) → medidor de ROE → acoplador → antena",
  [Se añade un amplificador lineal a una estación formada por transceptor, medidor de ROE, acoplador de antena y antena. El lineal debe conectarse:],
  ([entre el medidor de ROE y el acoplador], [en paralelo con el medidor de ROE], [entre el acoplador y la antena], [entre el transceptor y el medidor de ROE],),
  sol: [El orden canónico es transceptor, amplificador lineal, medidor de ROE, acoplador y antena. El lineal va antes del medidor para que este lea la potencia real que sale hacia la antena y sirva para ajustar el acoplador. Entre el acoplador y la antena solo va la línea de alimentación.], tema: "T6")
#pq(6, 1, 23, "b", "estúdialo en: simulacros de estudio 3·1·24 · libro: T7.24", "Los satélites de aficionado usan VHF y UHF (hay que atravesar la ionosfera)",
  [¿Por qué los satélites de aficionado no usan las bandas de 80 y 40 m?],
  ([porque en HF solo existe propagación por onda de superficie], [porque esas frecuencias se reflejan o se absorben en la ionosfera en lugar de atravesarla], [porque las antenas de HF tienen demasiada ganancia para seguir a un satélite], [porque en HF la pérdida en espacio libre es mucho mayor que en VHF],),
  sol: [El satélite está por encima de la ionosfera, y la señal tiene que cruzarla: hace falta subir a VHF y UHF, que la atraviesan, mientras que la HF se refleja o se absorbe en ella. La pérdida en espacio libre crece con la frecuencia, así que en HF sería menor, no mayor. En HF hay onda de superficie y onda de espacio, no solo la primera.], tema: "T7")
#pq(6, 1, 24, "a", "estúdialo en: simulacros de estudio 8·1·25 · libro: T7.8", "La capa D absorbe de día las bandas bajas (3,5 MHz: de día menos alcance que de noche)",
  [A mediodía, ¿cuál de estas bandas sufrirá más absorción en la capa D?],
  ([160 m (1,8 MHz)], [40 m (7 MHz)], [20 m (14 MHz)], [15 m (21 MHz)],),
  sol: [La absorción de la capa D crece al bajar la frecuencia, aproximadamente con $1 / f^2$: de las cuatro, la más baja, 160 m, es la más castigada, y de día se queda en contactos cercanos. Las bandas de 20 y 15 m atraviesan la D casi sin notarla y llegan a la capa F.], tema: "T7")
#pq(6, 1, 25, "c", "estúdialo en: simulacros de estudio 4·1·25 · libro: F-T7.17", "El conducto troposférico se da en VHF y UHF, con alcances de cientos de kilómetros",
  [¿Cuál de estos contactos es típico de una apertura por conducto troposférico?],
  ([un enlace en 3,5 MHz entre dos estaciones a 300 km, de noche], [un enlace en 144 MHz usando la Luna como reflector], [un enlace en 432 MHz entre dos estaciones costeras separadas por unos 800 km de mar], [un enlace en 1,8 MHz por onda de superficie a 100 km],),
  sol: [El conducto troposférico guía VHF y UHF a cientos de kilómetros, muy por encima del horizonte, y sobre el mar puede pasar de mil. Un enlace nocturno en 3,5 MHz es ionosférico, el de la Luna es rebote lunar (EME) y el de 1,8 MHz por el suelo es onda de superficie en MF.], tema: "T7")
#pq(6, 1, 26, "b", "estúdialo en: simulacros de estudio 7·1·27", "Cálculo de la ROE a partir de la potencia directa y la reflejada; potencia entregada = directa − reflejada",
  [Una antena presenta una ROE de 2 y el vatímetro direccional indica 90 W de potencia directa. ¿Qué potencia se refleja y cuánta recibe la antena?],
  ([se reflejan 45 W y la antena recibe 45 W], [se reflejan 10 W y la antena recibe 80 W], [se reflejan 10 W y la antena recibe 100 W], [se reflejan 30 W y la antena recibe 60 W],),
  sol: [Con ROE 2, $rho = ("ROE" - 1) slash ("ROE" + 1) = 1 slash 3$, y la reflejada es $rho^2 = 1 slash 9$ de la directa (el 11 % de la tabla): $90 slash 9 = 10$ W. La antena recibe la directa menos la reflejada, $90 - 10 = 80$ W. Los 30 W olvidan elevar $rho$ al cuadrado, los 45 W toman la ROE como si fuera el cociente de potencias, y los 100 W suman la reflejada en lugar de restarla.], tema: "T8")
#pq(6, 1, 27, "d", "estúdialo en: simulacros de estudio 1·1·26 · libro: C-T8.4", "Medidor de campo: intensidad de campo radiado, en V/m",
  [Quieres saber qué intensidad de campo eléctrico produce tu antena en la terraza de un vecino. ¿Qué instrumento usarás y en qué unidades obtendrás el resultado?],
  ([un medidor de ROE, en vatios], [un dipmeter, en hercios], [un vatímetro direccional, en dBm], [un medidor de campo, en V/m o dBμV/m],),
  sol: [La intensidad de campo radiado que llega a un lugar se mide con un medidor de campo, un receptor calibrado con su antena de medida, y se expresa en voltios por metro o en sus submúltiplos (μV/m, dBμV/m). El medidor de ROE y el vatímetro miden en la línea, junto al transmisor, y el dipmeter busca la resonancia de un circuito.], tema: "T8")
#pq(6, 1, 28, "a", "estúdialo en: simulacros de estudio 3·1·28 · libro: T9.20", "Ante una queja: comprobar la propia estación y colaborar",
  [Tras una queja de un vecino, conectas tu transmisor a la carga artificial y transmites: la interferencia desaparece. ¿Qué conclusión y qué paso siguiente son correctos?],
  ([el camino era la radiación de tu antena: revisa tus armónicos, la ROE y la potencia, y luego la inmunidad del equipo afectado, en colaboración con el vecino], [tu estación queda descartada y el problema es solo del vecino, que debe resolverlo él], [el camino era la red eléctrica: basta con instalar un filtro de red en tu transceptor], [conviene aumentar la potencia para confirmar el diagnóstico],),
  sol: [Ante una queja, lo primero es comprobar la propia estación. Si con la carga artificial la interferencia desaparece, llega por lo que radia la antena: hay que revisar armónicos, ROE y potencia y, después, la inmunidad del equipo afectado. Si siguiera aun sin radiar, el camino sería la red. Que el equipo del vecino tenga poca inmunidad no exime de colaborar.], tema: "T9")
#pq(6, 1, 29, "d", "estúdialo en: simulacros de estudio 4·1·29 · libro: T10.2", "Una antena que transmite no se toca (quemaduras de RF)",
  [Tocar el extremo de una antena mientras transmite produce sobre todo:],
  ([ningún daño si la potencia es de pocos vatios], [un calambre como el de la red de 50 Hz], [un simple hormigueo, porque la RF no deposita energía en el tejido], [quemaduras profundas por radiofrecuencia, a veces sin dolor inmediato],),
  sol: [A millones de hercios el sistema nervioso no responde y no hay calambre, pero la RF calienta el tejido: entra por un punto pequeño de la piel y quema en profundidad. Los extremos de un dipolo pueden estar a cientos o miles de voltios de RF con solo 100 W, y por eso la antena se respeta aunque «solo» haya unos vatios.], tema: "T10")
#pq(6, 1, 30, "c", "estúdialo en: simulacros de estudio 9·1·29 · libro: T10.18", "Si no se puede cortar: separar a la víctima con un elemento aislante, nunca tocarla directamente",
  [Si no se puede cortar la corriente enseguida, para separar a la víctima de la instalación lo adecuado es usar:],
  ([las manos desnudas, actuando con rapidez], [una barra metálica, para hacer palanca], [un palo de madera seca], [un trapo empapado en agua],),
  sol: [Hay que separarla con un objeto aislante y seco —un palo o una pértiga de madera seca, una silla de madera, una prenda seca— para que la corriente no pase también por quien auxilia. El metal y el agua conducen, y tocarla con las manos desnudas mientras sigue en contacto con la instalación convierte al socorrista en otra víctima.], tema: "T10")
#fin-prueba()
#prueba(6, 2)
#pq(6, 2, 1, "a", "estúdialo en: simulacros de estudio 13·2·1 · libro: R1.7", "M Mike y V Victor",
  [Un operador deletrea el sufijo `MV` como «Madrid Valencia». ¿Cómo debería decirlo?],
  ([Mike Victor], [Metro Vector], [Mike Whiskey], [November Victor],),
  sol: [M es Mike y V es Victor. Madrid y Valencia son de alfabetos nacionales antiguos; Whiskey es la W y November la N, letras que se confunden con la V y la M al oído.], tema: "R1")
#pq(6, 2, 2, "d", "estúdialo en: simulacros de estudio 5·2·3, 9·2·1 · libro: R2.9, R2.32", "QRT cese la transmisión frente a QRX espere, volveré a llamar",
  [En mitad de un QSO suena el teléfono y quieres que tu corresponsal te espere un par de minutos. Le dices:],
  ([`QRV`], [`QRU`], [`QRT`], [`QRX`],),
  sol: [`QRX` es «espere, volveré a llamar»: aplaza el QSO sin cerrarlo. `QRT` es cesar la transmisión, que cerraría la estación; `QRU` es «no tengo nada para usted» y `QRV`, «estoy dispuesto».], tema: "R2")
#pq(6, 2, 3, "d", "estúdialo en: simulacros de estudio 7·2·3 · libro: R2.21", "QSN ¿me ha oído / ha oído a… en… kHz?",
  [Llevas un rato llamando a una estación sin respuesta y preguntas a otra si te ha oído en 14 200 kHz. ¿Qué grupo resume la pregunta?],
  ([`QRG?`], [`QRZ?`], [`QSX?`], [`QSN?`],),
  sol: [`QSN?` pregunta «¿me ha oído usted (o ha oído a…) en… kHz?»: mira al pasado. `QSX?` pregunta si se quiere escuchar a alguien a partir de ahora, `QRZ?` es «¿quién me llama?» y `QRG?` pregunta por la frecuencia exacta.], tema: "R2")
#pq(6, 2, 4, "b", "estúdialo en: simulacros de estudio 10·2·3 · libro: R2.22", "QSD manipulación defectuosa",
  [En CW, los puntos y rayas de tu corresponsal llegan mal formados y con un ritmo irregular. ¿Con qué grupo se lo indicas?],
  ([`QSB`], [`QSD`], [`QRH`], [`QRS`],),
  sol: [`QSD` avisa de que la manipulación es defectuosa. `QSB` es el desvanecimiento de la señal, `QRH` que su frecuencia varía y `QRS` pide ir más despacio, que no corrige unos signos mal formados.], tema: "R2")
#pq(6, 2, 5, "c", "estúdialo en: simulacros de estudio 2·2·5 · libro: R3.2", "CL cierre de la estación",
  [Es tu último contacto del día y, tras el `SK`, vas a apagar el equipo. ¿Qué abreviatura añades para anunciarlo?],
  ([`K`], [`CUL`], [`CL`], [`CQ`],),
  sol: [`CL` anuncia el cierre de la estación, como en «`TU 73 SK EA1ABC CL`». `CUL` es «hasta luego» (una despedida, no el cierre), `CQ` es la llamada general y `K` invita a transmitir, lo contrario de lo que quieres.], tema: "R3")
#pq(6, 2, 6, "a", "estúdialo en: simulacros de estudio 7·2·6 · libro: R3.30", "NIL nada, sin novedad",
  [Tu corresponsal te pregunta si tienes algún mensaje para él y no tienes ninguno. ¿Qué abreviatura le contestas?],
  ([`NIL`], [`NR`], [`CFM`], [`MSG`],),
  sol: [`NIL` es «nada (para usted)»: no hay nada que transmitir. `MSG` es «mensaje», justo lo que no tienes; `NR` es «número» y `CFM`, «confirmo».], tema: "R3")
#pq(6, 2, 7, "a", "estúdialo en: simulacros de estudio 12·2·7 · libro: C-R3.6", "GE buenas tardes",
  [¿De qué expresión inglesa procede `GE` y qué significa?],
  ([de \_good evening\_: «buenas tardes»], [de \_good night\_: «buenas noches»], [de \_good evening\_: «buenos días»], [de \_go ahead\_: «adelante»],),
  sol: [`GE` viene de \_good evening\_ y significa «buenas tardes». \_Go ahead\_ es `GA` («adelante») y \_good night\_ es `GN` («buenas noches»).], tema: "R3")
#pq(6, 2, 8, "c", "estúdialo en: simulacros de estudio 11·2·10 · libro: F-R4.5", "Canal 16 de VHF marítima: 156,8 MHz (socorro, seguridad y llamada en voz)",
  [En la VHF marítima, la frecuencia de 156,8 MHz corresponde a:],
  ([los dispositivos de salvamento], [el canal 70: alerta de socorro por llamada selectiva digital], [el canal 16: socorro, seguridad y llamada en radiotelefonía], [la frecuencia aeronáutica de emergencia],),
  sol: [156,8 MHz es el canal 16, la frecuencia internacional de socorro, seguridad y llamada en voz. El canal 70 (156,525 MHz) es para la alerta digital (DSC); la emergencia aeronáutica va en 121,5 MHz y los dispositivos de salvamento, en 243 MHz.], tema: "R4")
#pq(6, 2, 9, "b", "estúdialo en: simulacros de estudio 8·2·8 · libro: R4.12", "Al oír un socorro: silencio, escucha y auxilio si es posible",
  [Estás en mitad de un QSO en 40 m y oyes un «Mayday» en tu frecuencia. ¿Qué haces primero?],
  ([terminas tu comunicado cuanto antes y luego escuchas], [dejas de transmitir de inmediato, escuchas y anotas la hora, la frecuencia, la posición y el peligro], [subes la potencia y avisas a todas las estaciones de la banda], [cambias de frecuencia para no interferir],),
  sol: [Lo primero es callar y escuchar, sin ocupar la frecuencia, y anotar los datos para poder ayudar o hacer llegar el aviso. Terminar el comunicado ya estorba; subir la potencia o difundirlo por la banda solo crea confusión, y cambiar de frecuencia te deja sin poder ayudar.], tema: "R4")
#pq(6, 2, 10, "d", "estúdialo en: simulacros de estudio 5·2·11 · libro: R5.44", "El distintivo se otorga junto con la autorización y lo asigna la Administración (no se elige ni lo da la asociación)",
  [Un radioaficionado recién autorizado quiere que el sufijo de su distintivo sean sus iniciales. ¿Es posible?],
  ([Sí, si abona una tasa adicional por distintivo personalizado], [Sí, si lo pide en el plazo de un mes desde que aprueba el examen], [Sí, si su asociación de radioaficionados lo propone y lo aprueba], [No: el distintivo lo asigna la Administración al otorgar la autorización, por orden alfabético y turno de expedición],),
  sol: [El distintivo se otorga junto con la autorización y lo asigna la Administración; el sufijo sigue el orden alfabético y el turno riguroso de expedición. Ni se elige ni lo concede la asociación, que no tiene esa competencia.], tema: "R5")
#pq(6, 2, 11, "b", "estúdialo en: simulacros de estudio 1·2·10, 8·2·10 · libro: R7.8", "Cuándo identificarse: al comienzo y al final de cada emisión, siempre, y en las largas al menos cada 10 min",
  [¿Cuál de estas prácticas incumple las normas de identificación de las estaciones de aficionado?],
  ([dar el distintivo al comienzo, a los ocho minutos y al final de una emisión de quince minutos], [dar el distintivo solo al comienzo de una emisión de cinco minutos], [dar el distintivo al comienzo y al final de una emisión de cuatro minutos], [en fonía, dar el distintivo seguido de la palabra «portable» al comienzo y al final de una emisión hecha fuera de casa],),
  sol: [La identificación se exige siempre al comienzo y al final de cada emisión, por corta que sea; darla solo al empezar incumple la segunda parte. Las demás prácticas cumplen: en la de quince minutos nunca pasan más de diez sin identificarse, y añadir «portable» en fonía es un complemento opcional permitido.], tema: "R5")
#pq(6, 2, 12, "b", "estúdialo en: simulacros de estudio 7·2·10 · libro: R5.31", "Prefijos de España: series EA–EH (y AM–AO); habituales EA, EB y EC",
  [A la vista de su prefijo, ¿cuál de estos distintivos no puede pertenecer a una estación española?],
  ([AN7ABC], [EI7ABC], [EC7ABC], [EH7ABC],),
  sol: [A España le corresponden las series EA–EH y AM–AO: EC es de uso habitual y EH y AN se emplean como prefijos temporales. EI, en cambio, es de Irlanda, aunque empiece por E.], tema: "R5")
#pq(6, 2, 13, "c", "estúdialo en: simulacros de estudio 11·2·13 · libro: C-R5.8", "Excepciones de distrito: Albacete es del 5 y La Rioja del 1",
  [Las provincias de Albacete y La Rioja corresponden, respectivamente, a las cifras de distrito:],
  ([4 y 2], [4 y 1], [5 y 1], [5 y 2],),
  sol: [Albacete es la excepción de Castilla-La Mancha y va al distrito 5, con la Comunidad Valenciana y Murcia; La Rioja va al 1, con Castilla y León y el norte. Las opciones con 4 o con 2 son las que da la intuición por comunidad o por vecindad.], tema: "R5")
#pq(6, 2, 14, "d", "estúdialo en: simulacros de estudio 6·2·14, 10·2·14 · libro: C-R6.3, R6.13", "Naturaleza de los planes: acuerdos voluntarios y guía mundial, pero la Orden obliga a usar el de la Región 1 como norma general en España",
  [De las siguientes afirmaciones sobre el carácter de los planes de bandas de la IARU, ¿cuál es falsa?],
  ([Sirven de guía a los radioaficionados de todo el mundo], [Nacen de acuerdos voluntarios entre asociaciones nacionales], [En España, la Orden IET/1311/2013 obliga a seguir como norma general el de la Región 1], [Tienen rango de ley por sí mismos, como el Reglamento de Radiocomunicaciones],),
  sol: [La IARU es una federación de asociaciones, no un legislador: sus planes son acuerdos voluntarios y guía mundial, sin rango de ley propio. En España obligan porque la Orden remite al de la Región 1 como norma general, no por sí mismos.], tema: "R6")
#pq(6, 2, 15, "a", "estúdialo en: simulacros de estudio 7·2·15 · libro: R7.10", "Definición del servicio de aficionados: instrucción individual, intercomunicación y estudios técnicos, sin lucro",
  [¿Cuál de estas actividades encaja en la definición del servicio de aficionados del Reglamento de Radiocomunicaciones?],
  ([Experimentar con una antena construida por uno mismo y comentar los resultados con otros aficionados], [Retransmitir un programa cultural para los vecinos del barrio], [Coordinar los avisos de una empresa de transportes a cambio de una compensación], [Hacer de enlace permanente entre los servicios municipales de emergencia],),
  sol: [El servicio de aficionados es de instrucción individual, intercomunicación y estudios técnicos, sin fines de lucro. Experimentar con una antena y comentarlo es justo eso; difundir programas es radiodifusión, y el servicio con compensación económica tiene fin de lucro.], tema: "R7")
#pq(6, 2, 16, "c", "estúdialo en: simulacros de estudio 8·2·16 · libro: F-R7.5", "Código SINPO: intensidad, interferencias, ruido, propagación y calidad global",
  [En un informe SINPO, la letra N valora:],
  ([las interferencias de otras estaciones], [la intensidad de la señal], [el ruido], [la nitidez de la señal],),
  sol: [SINPO toma las iniciales inglesas de Signal (intensidad), Interference (interferencias), Noise (ruido), Propagation (perturbación de la propagación) y Overall (calidad global). La N es, por tanto, el ruido; leerla como «nitidez» es la trampa de la inicial española.], tema: "R7")
#pq(6, 2, 17, "c", "estúdialo en: simulacros de estudio 7·2·17 · libro: F-R8.62", "Radiobaliza: información solo de su posición y condiciones de funcionamiento",
  [Una asociación quiere que su radiobaliza transmita, además del distintivo, el parte meteorológico local y avisos de sus actividades. Según el artículo 25.f:],
  ([puede, siempre que lo transmita en Morse a no más de diez palabras por minuto], [no puede: la radiobaliza solo puede transmitir su distintivo, sin ninguna otra información], [no puede: salvo casos excepcionales justificados, la información de la radiobaliza se limita a su posición y sus condiciones de funcionamiento], [puede, siempre que la potencia no supere 10 W],),
  sol: [El art. 25.f limita la información de una radiobaliza, salvo casos excepcionales debidamente justificados, a su posición y sus condiciones de funcionamiento. Ni el tiempo ni los avisos de la asociación caben, se transmitan como se transmitan. Pero tampoco es cierto que solo pueda emitir el distintivo: la posición y el estado sí se transmiten.], tema: "R8")
#pq(6, 2, 18, "b", "estúdialo en: simulacros de estudio 12·2·18 · libro: F-R8.87", "Interferencia: degradación, falseamiento o pérdida de información por energía no deseada",
  [Una emisión ajena empeora ligeramente la calidad con la que recibes una señal, sin llegar a interrumpir la comunicación. Según las definiciones del anexo I, ese efecto:],
  ([es siempre una interferencia perjudicial], [es una interferencia, aunque no llegue a ser interferencia perjudicial], [no es una interferencia, porque no interrumpe el servicio], [es una emisión fuera de banda],),
  sol: [La interferencia es el efecto de una energía no deseada sobre la recepción que se manifiesta como degradación de la calidad, falseamiento o pérdida de información: basta una degradación ligera. Para ser perjudicial hace falta más: degradación grave, interrupciones repetidas o afectar a servicios de seguridad. La emisión fuera de banda es otra definición del anexo, referida a la emisión y no a su efecto en la recepción.], tema: "R8")
#pq(6, 2, 19, "d", "estúdialo en: simulacros de estudio 9·2·22 · libro: C-R8.46", "Potencia máxima en HF (1,8–28 MHz): 1000 W p.c.e.",
  [¿En cuál de estas bandas la tabla del anexo I fija una potencia máxima de 1000 W p.c.e.?],
  ([137 kHz (2200 m)], [430–440 MHz (70 cm)], [50 MHz (6 m)], [28 MHz (10 m)],),
  sol: [La tabla del apartado 3.1 fija 1000 W p.c.e. para todas las bandas de HF, de 1,8 a 28 MHz, y 10 m es la última de ellas. En 50 MHz el máximo baja a 600 W p.c.e., en 70 cm a 300 W p.c.e. y en 137 kHz es de solo 1 W p.i.r.e. Es fácil dudar con 6 m por estar al lado de 10 m, pero ya es VHF.], tema: "R8")
#pq(6, 2, 20, "a", "estúdialo en: simulacros de estudio 2·2·21 · libro: C-R8.2", "Contenido de la licencia CEPT (no consta la asociación ni la fecha del examen)",
  [Según el artículo 12 de la Orden IET/1311/2013, ¿cuál de estos datos debe constar en la licencia CEPT?],
  ([el nombre y la dirección del titular], [la relación de equipos del titular], [el número de socio de la asociación a la que pertenece], [la fecha en que el titular superó el examen],),
  sol: [El art. 12 enumera cinco datos: la declaración que autoriza a usar la estación conforme a la T/R 61-01, nombre y dirección del titular, distintivo de llamada, período de validez y autoridad que la expide. La fecha del examen, los equipos o la asociación no figuran. Regla práctica: quién eres, cómo te llamas en el aire, hasta cuándo vale y quién lo firma.], tema: "R8")
#pq(6, 2, 21, "a", "estúdialo en: simulacros de estudio 4·2·22 · libro: F-R8.20", "Recursos contra las resoluciones: reposición en 1 mes o contencioso ante la Audiencia Nacional en 2 meses",
  [Te notifican hoy una resolución de la SETSI que deniega tu autorización de radioaficionado. Según el artículo 4 de la Orden IET/1311/2013, puedes:],
  ([interponer recurso potestativo de reposición en un mes o acudir directamente a la Audiencia Nacional en dos meses, pero no ambos a la vez], [acudir únicamente al Tribunal Superior de Justicia de tu comunidad autónoma, en el plazo de un mes], [interponer obligatoriamente recurso de reposición en dos meses antes de acudir a los tribunales], [interponer recurso de alzada ante el Ministro en el plazo de seis semanas],),
  sol: [Estas resoluciones agotan la vía administrativa: cabe recurso potestativo de reposición ante el mismo órgano en un mes, o recurso contencioso directo ante la Audiencia Nacional en dos meses, contados desde el día siguiente a la notificación, y no simultáneamente. La reposición es potestativa, no obligatoria, y su plazo es de un mes. Las seis semanas son el plazo para resolver, no para recurrir.], tema: "R8")
#pq(6, 2, 22, "c", "estúdialo en: simulacros de estudio 10·2·25 · libro: F-R8.1", "Potencia y duración de las emisiones limitadas a lo estrictamente necesario",
  [Mantienes un comunicado local en 2 m con una estación que te recibe perfectamente con 5 W, y tu equipo puede dar 50 W. Según el anexo I de la Orden IET/1311/2013:],
  ([la limitación a lo estrictamente necesario solo rige en las bandas de HF], [solo debes reducir la potencia si alguien te comunica una interferencia], [debes emitir con la potencia estrictamente necesaria y limitar también la duración de las emisiones], [puedes emitir siempre con la potencia máxima autorizada en la banda],),
  sol: [El apartado 4.2 del anexo I obliga a limitar a lo estrictamente necesario tanto la potencia, dentro de los máximos de cada banda, como la duración de las emisiones. El máximo de la banda es un techo, no el valor de uso. La regla rige siempre y en todas las bandas, sin esperar a que haya una queja.], tema: "R8")
#pq(6, 2, 23, "b", "estúdialo en: simulacros de estudio 9·2·26 · libro: F-R8.55", "Modificaciones experimentales con licencia concedida: hasta 60 días sin afectar a la seguridad",
  [Con la licencia de estación fija concedida, quieres probar durante unas semanas otra antena en el mismo mástil, sin afectar a la seguridad, antes de decidir si la dejas. Según el artículo 20:],
  ([debes tramitarlo como si fuera una primera instalación], [puedes hacerlo con carácter experimental durante un máximo de 60 días; si la dejas, remites la documentación], [necesitas una autorización especial experimental solicitada con un mes de antelación], [puedes mantenerla indefinidamente sin comunicar nada mientras no interfiera],),
  sol: [Con la licencia concedida, cualquier modificación de instalaciones y equipos puede hacerse con carácter experimental hasta 60 días, siempre que no afecte a la seguridad; si se vuelve permanente, se remite la documentación complementaria. La primera instalación solo se exige si cambia la ubicación de la antena, y la autorización especial experimental es para emitir con características distintas de las generales.], tema: "R8")
#pq(6, 2, 24, "d", "estúdialo en: simulacros de estudio 7·2·25 · libro: F-R8.43", "Licencia fija condicionada a no perturbar otros servicios y a cumplir normas de seguridad, servidumbres, medio ambiente",
  [Un radioaficionado sostiene que, una vez expedida la licencia de su estación fija, ya no debe preocuparse por las servidumbres aeronáuticas ni por la normativa medioambiental. ¿Es correcto?],
  ([No, pero solo durante el primer año de vigencia de la licencia], [Sí: la licencia sustituye a cualquier otro permiso], [Sí, salvo que la comunidad de propietarios alegue en el plazo de dos meses], [No: la licencia queda condicionada en todo caso a esas normas y a no perturbar otros servicios autorizados],),
  sol: [El art. 18.3 condiciona la licencia, en cualquier caso, a la ausencia de perturbaciones a otros servicios autorizados y al cumplimiento de las normas de seguridad nacional, servidumbres radioeléctricas o aeronáuticas, medio ambiente y ordenación del territorio. La condición es permanente, no del primer año, y la licencia no sustituye a esos otros permisos. Las alegaciones de la comunidad versan sobre la idoneidad del emplazamiento, no sobre estas materias.], tema: "R8")
#pq(6, 2, 25, "c", "estúdialo en: simulacros de estudio 13·2·26 · libro: R8.27", "Autorización especial experimental: nominativa, plazo máximo inicial de 18 meses, ampliable",
  [Planeas un experimento de unos dos años que requiere autorización especial experimental. ¿Qué debes tener en cuenta?],
  ([Caduca a los 18 meses y no puede ampliarse], [Puede concederse directamente por dos años, porque no tiene plazo máximo], [Se otorga con un plazo máximo inicial de 18 meses, ampliable, y solo te habilita a ti], [Con ella pueden emitir también los miembros de tu radio club],),
  sol: [Las autorizaciones especiales experimentales son nominativas, solo habilitan a su titular y se otorgan por el tiempo necesario, con un plazo máximo inicial de 18 meses, ampliable; su validez depende además de la de la autorización de radioaficionado. Para dos años, se pide la ampliación. No se extienden a otras personas.], tema: "R8")
#pq(6, 2, 26, "d", "estúdialo en: simulacros de estudio 11·2·28 · libro: R8.67", "Titular de una desatendida: solo asociaciones de radioaficionados legalmente reconocidas",
  [Un radioaficionado con autorización en vigor quiere instalar a su nombre un repetidor en una finca de su propiedad. Según la Orden:],
  ([puede, si la asociación local da por escrito su conformidad], [puede, si limita la potencia a 10 W, como en un casco urbano], [puede, si presenta memoria y seguro, como para su estación fija], [no puede: las estaciones automáticas desatendidas solo se autorizan a asociaciones de radioaficionados legalmente reconocidas],),
  sol: [Repetidores, radiobalizas y demás desatendidas se autorizan solo a asociaciones de radioaficionados legalmente reconocidas, nunca a título individual: son infraestructura de uso común y necesitan un responsable estable. Cumplir los trámites de una estación fija o limitar la potencia no cambia quién puede ser titular. Tampoco basta la conformidad de una asociación: la titular tendría que ser la propia asociación.], tema: "R8")
#pq(6, 2, 27, "a", "estúdialo en: simulacros de estudio 2·2·28 · libro: R8.36", "Potencia de las desatendidas: VHF/UHF 10 W en casco urbano y 50 W fuera; HF 50 W",
  [Una asociación instala un repetidor de 70 cm en un monte alejado de cualquier núcleo urbano. Como norma general, la potencia de salida de su transmisor no superará:],
  ([50 W], [300 W], [10 W], [100 W],),
  sol: [Para las desatendidas de VHF y UHF el límite es de 10 W dentro del casco urbano y 50 W fuera; un monte alejado está fuera, luego 50 W. Los 10 W son el límite urbano. Los 300 W p.c.e. son el máximo general de la banda de 430–440 MHz en la tabla del anexo I, que no se aplica a las desatendidas.], tema: "R8")
#pq(6, 2, 28, "b", "estúdialo en: simulacros de estudio 8·2·28 · libro: R9.2", "Grave: la mera producción de interferencias",
  [Tu amplificador lineal, mal ajustado, produce sin que lo pretendas interferencias a un servicio autorizado. Según la Ley 11/2022, esa conducta es:],
  ([ninguna infracción, al no haber intención], [una infracción grave], [una infracción leve], [una infracción muy grave],),
  sol: [La mera producción de interferencias a redes o servicios autorizados es infracción grave (art. 107.6): no hace falta intención. Si fueran deliberadas pasarían a muy graves (art. 106.7), que es el error más habitual. Tampoco es leve: la ley la sitúa en el escalón intermedio.], tema: "R9")
#pq(6, 2, 29, "c", "estúdialo en: simulacros de estudio 13·2·29 · libro: R9.27", "Emitir fuera de las bandas autorizadas es infracción",
  [Un radioaficionado transmite unos minutos, con muy poca potencia y en CW, en una frecuencia situada justo fuera de la banda del servicio, tras comprobar que estaba libre. Su conducta:],
  ([solo es infracción si supera la potencia máxima de su autorización], [no es infracción si se identifica correctamente con su distintivo], [es una infracción, sea cual sea la potencia y aunque la frecuencia esté libre], [no es infracción si no llega a causar interferencias],),
  sol: [La autorización habilita para emitir solo en las bandas del servicio de aficionados; salir de ellas es infracción por sí mismo. Fuera hay otros servicios, muchos de seguridad, y no importa que la frecuencia parezca libre, que la potencia sea baja o que se identifique bien. Que no cause interferencias no la legaliza.], tema: "R9")
#pq(6, 2, 30, "a", "estúdialo en: simulacros de estudio 12·2·30 · libro: R9.24", "Revocación: fines comerciales sí; no tener estación no es causa",
  [Un radioaficionado puede perder su autorización por revocación si:],
  ([emite con fines publicitarios o lucrativos], [deja de ser socio de su asociación de radioaficionados], [no tiene instalada ninguna estación], [no lleva libro de registro de comunicados],),
  sol: [Las emisiones con fines comerciales, publicitarios o lucrativos son causa expresa de revocación (art. 8.1.b de la Orden IET/1311/2013). Las otras tres no lo son, porque la autorización no obliga a tener estación, ni a ser socio, ni a llevar libro de registro.], tema: "R9")
#fin-prueba()
#soluciones-simulacro(6)

// ======================================================================
#simulacro(7)
#prueba(7, 1)
#pq(7, 1, 1, "d", "estúdialo en: simulacros de estudio 1·1·2, 8·1·1 · libro: T1.8, T1.9", "Potencia eléctrica: P = V I = I² R = V² / R",
  [Una resistencia de 8 Ω disipa 32 W. La corriente que la recorre es de:],
  ([0,25 A], [0,5 A], [4 A], [2 A],),
  sol: [De $P = I^2 R$ se despeja $I = sqrt(P slash R) = sqrt(32 slash 8) = sqrt(4) = 2$ A. Los 4 A olvidan la raíz cuadrada, y los 0,25 y 0,5 A invierten el cociente (8/32), sin raíz y con ella.], tema: "T1")
#pq(7, 1, 2, "b", "estúdialo en: simulacros de estudio 9·1·2 · libro: F-T1.56", "Fuente real: V = ε − I r y corriente de cortocircuito ε / r",
  [Una batería marca 13,2 V en vacío y 12,0 V cuando entrega 15 A. Su resistencia interna es de:],
  ([12,5 Ω], [0,08 Ω], [0,8 Ω], [0,88 Ω],),
  sol: [En vacío se mide la fem, $epsilon = 13","2$ V; con carga, $V = epsilon - I r$, así que la caída interna es $13","2 - 12","0 = 1","2$ V y $r = 1","2 slash 15 = 0","08$ Ω. Los 0,88 y 0,8 Ω dividen una tensión total entre la corriente, lo que da la resistencia de todo el circuito o la de la carga, no la interna; 12,5 Ω es el cociente invertido.], tema: "T1")
#pq(7, 1, 3, "d", "estúdialo en: simulacros de estudio 3·1·2 · libro: T1.12", "Capacidad de una batería en amperios-hora: t = C / I",
  [Un equipo portátil consume 250 mA y se quiere que funcione 8 horas seguidas. La capacidad mínima de su batería debe ser de:],
  ([2000 Ah], [0,031 Ah], [32 Ah], [2 Ah],),
  sol: [De $t = C slash I$ se despeja $C = I t = 0","25 times 8 = 2$ Ah, es decir, 2000 mAh. Los 32 Ah resultan de dividir las horas entre la corriente; los 0,031 Ah, de dividir al revés; y los 2000 Ah, de olvidar que eran miliamperios.], tema: "T1")
#pq(7, 1, 4, "c", "estúdialo en: simulacros de estudio 7·1·4 · libro: F-T1.27", "Bits por símbolo (log₂ M) y velocidad binaria = baudios × bits por símbolo",
  [Un enlace con modulación 16-QAM transmite 4800 bit/s. Su velocidad de símbolo es de:],
  ([4800 baudios], [300 baudios], [1200 baudios], [19 200 baudios],),
  sol: [Cada símbolo de 16-QAM lleva $log_2 16 = 4$ bits, así que la velocidad de símbolo es $4800 slash 4 = 1200$ baudios. Los 300 baudios dividen entre el número de estados (16) en lugar de entre los bits por símbolo; 4800 confunde baudios con bit/s, y 19 200 multiplica en lugar de dividir.], tema: "T1")
#pq(7, 1, 5, "b", "estúdialo en: simulacros de estudio 1·1·5 · libro: T2.46", "Código de colores: la cuarta banda es la tolerancia (oro ±5 %, plata ±10 %, marrón ±1 %)",
  [Una resistencia lleva las bandas rojo, rojo, naranja y plata. Su valor real puede estar comprendido entre:],
  ([17,6 kΩ y 26,4 kΩ], [19,8 kΩ y 24,2 kΩ], [21,78 kΩ y 22,22 kΩ], [20,9 kΩ y 23,1 kΩ],),
  sol: [Rojo, rojo y naranja dan 22 y tres ceros: 22 kΩ. La cuarta banda, plata, es la tolerancia de ±10 %, es decir, ±2,2 kΩ: de 19,8 a 24,2 kΩ. El intervalo de 20,9 a 23,1 kΩ corresponde al oro (±5 %) y el de 21,78 a 22,22 kΩ al marrón (±1 %).], tema: "T2")
#pq(7, 1, 6, "d", "estúdialo en: simulacros de estudio 13·1·6 · libro: T2.10", "La reactancia capacitiva disminuye al aumentar la frecuencia",
  [Si la frecuencia de la señal aplicada a un condensador se reduce a la mitad, su reactancia:],
  ([se reduce a la mitad], [no varía], [se reduce a la cuarta parte], [se duplica],),
  sol: [La reactancia capacitiva $X_C = 1 / (2 pi f C)$ es inversamente proporcional a la frecuencia: a menos frecuencia, más reactancia. Con la mitad de frecuencia, el doble de reactancia. Reducirla a la mitad sería el comportamiento de una bobina.], tema: "T2")
#pq(7, 1, 7, "d", "estúdialo en: simulacros de estudio 4·1·6 · libro: T2.59", "Descarga segura de un condensador a través de un elemento exterior",
  [Has apagado y desenchufado un amplificador lineal valvular y vas a abrirlo. Sus condensadores de filtro de alta tensión:],
  ([se descargan invirtiendo la polaridad de la alimentación], [se descargan con seguridad cortocircuitándolos con un destornillador sujeto con la mano], [se descargan solos al instante en cuanto se desenchufa el equipo], [pueden conservar una carga peligrosa: hay que descargarlos uniendo sus armaduras a través de una resistencia, con un útil aislado],),
  sol: [Un condensador puede guardar su carga durante horas, y en un lineal valvular son cientos o miles de voltios. Se descarga uniendo las armaduras a través de una resistencia y con un útil aislado. El destornillador a pelo produce una descarga brusca y expone a quien lo sostiene.], tema: "T2")
#pq(7, 1, 8, "a", "estúdialo en: simulacros de estudio 2·1·8 · libro: C-T2.9", "Electrodos de la válvula diodo (cátodo y placa) y del tríodo (+ rejilla)",
  [¿Qué electrodo hay que añadir a una válvula diodo para obtener un tríodo capaz de amplificar?],
  ([una rejilla, situada entre el cátodo y la placa], [un segundo filamento de caldeo], [una segunda placa, enfrentada a la primera], [una puerta aislada por una capa de óxido],),
  sol: [La válvula diodo tiene cátodo y placa; el tríodo añade una rejilla entre ellos, muy cerca del cátodo, y una pequeña tensión en ella gobierna la corriente de placa: eso es amplificar. El filamento no cuenta como electrodo, y la puerta aislada es propia del MOSFET.], tema: "T2")
#pq(7, 1, 9, "a", "estúdialo en: simulacros de estudio 12·1·11 · libro: F-T3.43", "Frecuencia de resonancia f0 = 1/(2π√(LC)): cálculo y dependencia con L y C",
  [Se quiere que un circuito LC con una bobina de 2 μH resuene en 7 MHz. La capacidad necesaria es aproximadamente de:],
  ([260 pF], [26 pF], [1,6 nF], [10 nF],),
  sol: [Despejando de $f_0 = 1 slash (2 pi sqrt(L C))$: $C = 1 slash ((2 pi f_0)^2 L) = 1 slash ((4","4 times 10^7)^2 dot 2 times 10^(-6)) approx 2","6 times 10^(-10)$ F, unos 260 pF. Los 10 nF salen de olvidar el $(2 pi)^2$; los 1,6 nF, de poner $2 pi$ sin elevarlo al cuadrado; y los 26 pF, de equivocarse en una potencia de diez.], tema: "T3")
#pq(7, 1, 10, "b", "estúdialo en: simulacros de estudio 12·1·12 · libro: F-T3.49", "Filtro de cuarzo en la FI: su Q altísimo da selectividad elevada con banda estrecha y estable",
  [En un receptor superheterodino, el filtro de cuarzo estrecho que fija la selectividad se coloca en la FI y no a la entrada de RF porque:],
  ([el filtro de cuarzo elimina la frecuencia imagen, que solo aparece después del mezclador], [la FI es una frecuencia fija, y un filtro tan estrecho y estable no tiene que volver a sintonizarse al cambiar de emisora], [en la FI la señal es más intensa y el cristal necesita mucha potencia para vibrar], [a la entrada de RF el cristal amplificaría también el ruido de la antena],),
  sol: [El $Q$ altísimo del cuarzo da una banda de paso estrecha y estable, pero su frecuencia apenas puede moverse. Por eso se coloca en la FI, que es fija sea cual sea la emisora sintonizada: el filtro se diseña una sola vez. La imagen no se elimina en la FI, donde ya es indistinguible de la señal, sino antes del mezclador; y el cristal no amplifica nada ni necesita potencia.], tema: "T3")
#pq(7, 1, 11, "a", "estúdialo en: simulacros de estudio 9·1·11 · libro: F-T3.7", "Frecuencia del rizado: 100 Hz en onda completa y 50 Hz en media onda (red de 50 Hz)",
  [Una fuente de alimentación conectada a la red de 50 Hz presenta a su salida un rizado de 50 Hz. Esto indica que su rectificador:],
  ([solo aprovecha uno de los dos semiciclos, como un rectificador de media onda], [es un puente de cuatro diodos que funciona correctamente], [es de onda completa con toma media y funciona correctamente], [es de onda completa, pero con un condensador de filtro demasiado pequeño],),
  sol: [Con onda completa hay dos crestas por ciclo de red y el rizado es de 100 Hz; con media onda solo hay una cresta por ciclo y el rizado es de 50 Hz. Un condensador pequeño aumenta la amplitud del rizado, pero no cambia su frecuencia: seguiría siendo de 100 Hz.], tema: "T3")
#pq(7, 1, 12, "c", "estúdialo en: simulacros de estudio 10·1·13", "Emisor común: único montaje que invierte la fase 180°",
  [En un amplificador en emisor común, la tensión de la base sube ligeramente durante un instante. En ese mismo instante, la tensión del colector:],
  ([sube amplificada], [no cambia], [baja], [sube en la misma proporción],),
  sol: [Al subir la base el transistor conduce más, aumenta la corriente de colector, cae más tensión en la resistencia de colector y el colector baja: la salida está invertida 180°. Que suba, amplificada o no, es lo que ocurre en base común y en colector común, que no invierten la fase.], tema: "T3")
#pq(7, 1, 13, "a", "estúdialo en: simulacros de estudio 6·1·14 · libro: T3.40", "VFO: oscilador de frecuencia variable para moverse por la banda",
  [Un equipo antiguo de canales llevaba un cristal de cuarzo por cada canal. Para poder moverse de forma continua por toda la banda, esos cristales se sustituyeron por:],
  ([un oscilador de frecuencia variable (VFO)], [un filtro de cristal más ancho], [un detector de producto], [un multiplicador de frecuencia],),
  sol: [El VFO es el oscilador cuya frecuencia se varía de forma continua, por ejemplo con un condensador variable en su circuito LC, y permite recorrer la banda. Un cristal fija una sola frecuencia. El multiplicador solo multiplica la frecuencia que ya existe, el detector de producto demodula SSB y CW, y el filtro de cristal no genera ninguna señal.], tema: "T3")
#pq(7, 1, 14, "c", "estúdialo en: simulacros de estudio 3·1·16 · libro: C-T4.15", "Diagrama de bloques del receptor de BLU (RF, mezclador con OL variable, FI, detector de producto con BFO)",
  [Un receptor de banda lateral única necesita dos osciladores. Su papel es:],
  ([uno de batido (BFO), que alimenta al mezclador, y otro variable, que alimenta al detector de producto], [uno para cada banda lateral, ambos conectados al mezclador], [uno variable, que alimenta al mezclador, y otro de batido (BFO), que alimenta al detector de producto], [uno fijo en la etapa de RF y otro variable en el amplificador de BF],),
  sol: [El oscilador variable hace de oscilador local: al moverlo, cualquier señal cae en la FI. Tras la FI, el detector de producto mezcla la señal con el BFO, que repone la portadora que la BLU no lleva, y entrega el audio. Intercambiar los dos osciladores es el error típico: el BFO trabaja a la frecuencia fija de la FI, no en la entrada.], tema: "T4")
#pq(7, 1, 15, "b", "estúdialo en: simulacros de estudio 5·1·15 · libro: F-T4.10", "Receptor de FM: tras la FI, limitador y después discriminador (en AM, detector de envolvente)",
  [En un receptor de FM, el limitador que se coloca tras el amplificador de FI sirve para:],
  ([cortar el audio cuando no llega ninguna señal], [eliminar las variaciones de amplitud, y con ellas buena parte del ruido, antes del discriminador], [limitar la desviación de frecuencia de la señal recibida], [convertir las variaciones de frecuencia en tensión de audio],),
  sol: [En FM la información está en la frecuencia, así que la amplitud solo trae ruido: el limitador la recorta y el discriminador, a continuación, convierte las variaciones de frecuencia en audio. Convertir frecuencia en audio es justo la tarea del discriminador, no del limitador. Cortar el audio sin señal es el silenciador.], tema: "T4")
#pq(7, 1, 16, "d", "estúdialo en: simulacros de estudio 2·1·14 · libro: T4.5", "Selectividad: separar señales próximas en frecuencia (curva más estrecha = más selectivo)",
  [Con tu receptor oyes, mezcladas, la estación sintonizada y otra que está 2 kHz más arriba. Ese receptor tiene poca:],
  ([fidelidad], [sensibilidad], [estabilidad], [selectividad],),
  sol: [Separar señales próximas en frecuencia es la selectividad, y aquí falla porque la curva del filtro deja pasar también a la vecina. La sensibilidad se refiere a las señales débiles y la estabilidad a no derivar de la frecuencia sintonizada; la fidelidad es reproducir la modulación sin deformarla.], tema: "T4")
#pq(7, 1, 17, "a", "estúdialo en: simulacros de estudio 11·1·16 · libro: C-T5.29", "Funciones mínimas de un transmisor: generar, modular y amplificar",
  [En un transmisor de telegrafía (CW), la función de modular la realiza:],
  ([el manipulador, que corta y restablece la portadora al ritmo del morse], [el amplificador final, que da la potencia], [el oscilador, que genera la portadora], [el filtro paso bajo, que elimina los armónicos],),
  sol: [Todo transmisor genera, modula y amplifica. En CW se genera con el oscilador, se modula con el manipulador, que conecta y desconecta la portadora, y se amplifica en las etapas siguientes hasta el final. El oscilador solo genera la frecuencia; el filtro limpia la salida.], tema: "T5")
#pq(7, 1, 18, "b", "estúdialo en: simulacros de estudio 10·1·17 · libro: T5.20", "Excitador: lleva la señal al nivel que necesita el amplificador final",
  [En la cadena oscilador (1 mW), separador, una etapa intermedia y amplificador final (100 W), la etapa que eleva la señal hasta los 5 W que necesita el final se llama:],
  ([multiplicador], [excitador], [separador], [modulador],),
  sol: [El excitador lleva la señal al nivel que el amplificador final necesita en su entrada; en el ejemplo, de 1 mW a 5 W. El separador solo aísla el oscilador sin subir apenas el nivel, y el multiplicador eleva la frecuencia, no la potencia.], tema: "T5")
#pq(7, 1, 19, "c", "estúdialo en: simulacros de estudio 1·1·18", "Límite de espurias: vale el más restrictivo entre la atenuación y el tope absoluto",
  [Con 600 W de potencia media en la banda de 40 m, ¿qué potencia no puede superar ninguna emisión espuria de tu transmisor?],
  ([6 mW], [60 mW], [50 mW], [600 mW],),
  sol: [Por debajo de 30 MHz hay que quedar 40 dB por debajo de la potencia media y sin superar 50 mW, y vale el más restrictivo. 40 dB por debajo de 600 W son $600 times 10^(-4) = 0","06$ W, es decir, 60 mW, que superan el tope: mandan los 50 mW. Los 6 mW corresponderían a 50 dB y los 600 mW, a 30 dB.], tema: "T5")
#pq(7, 1, 20, "a", "estúdialo en: simulacros de estudio 9·1·20 · libro: T6.7", "Dipolo con trampas: circuitos LC paralelo en los brazos que permiten trabajar en varias bandas",
  [En un dipolo con trampas para 7 y 14 MHz, cuando se transmite en 14 MHz cada trampa:],
  ([presenta una impedancia muy alta y aísla el tramo exterior del brazo], [presenta una impedancia casi nula y une los dos tramos del brazo], [disipa en forma de calor la potencia que no debe radiarse], [actúa como un condensador en serie que alarga eléctricamente la antena],),
  sol: [Cada trampa es un circuito LC en paralelo que resuena a 14 MHz, y un LC en paralelo en resonancia presenta una impedancia altísima: para la RF es un interruptor abierto. Así solo trabaja la parte interior, que mide media onda en 14 MHz. En 7 MHz, en cambio, la trampa está por debajo de su resonancia, se comporta como una bobina y deja trabajar el hilo entero.], tema: "T6")
#pq(7, 1, 21, "c", "estúdialo en: simulacros de estudio 8·1·20 · libro: F-T6.1", "Conversión dBi = dBd + 2,15 (la p.i.r.e. es 2,15 dB mayor que la p.r.e.)",
  [La antena A tiene 5 dBd de ganancia y la antena B, 6 dBi. Comparándolas con la misma referencia:],
  ([B gana 1 dB más que A], [las dos tienen la misma ganancia], [A gana unos 1,15 dB más que B], [no se pueden comparar, porque usan referencias distintas],),
  sol: [Hay que pasar las dos a la misma escala: $G_"dBi" = G_"dBd" + 2","15$, así que A tiene 5 + 2,15 = 7,15 dBi, frente a los 6 dBi de B: A gana 1,15 dB más. Comparar las cifras sin convertir lleva a creer que B es mejor; y sí se pueden comparar, porque entre dBi y dBd median siempre 2,15 dB.], tema: "T6")
#pq(7, 1, 22, "c", "estúdialo en: simulacros de estudio 10·1·22 · libro: T6.18", "Guía de ondas: no propaga por debajo de su frecuencia de corte",
  [Una guía de ondas tiene una frecuencia de corte de 6,56 GHz. Una señal de 5 GHz introducida en ella:],
  ([se propaga con menos pérdidas que una de 10 GHz], [se propaga, pero con polarización circular], [no se propaga y se atenúa muy deprisa], [se propaga sin ninguna pérdida, porque la guía no tiene conductor central],),
  sol: [La guía de ondas solo propaga por encima de su frecuencia de corte, $f_c = c slash (2 a)$: por debajo, la onda no cabe en la guía y se atenúa muy deprisa. A 5 GHz la señal está por debajo de los 6,56 GHz de corte, así que no pasa; esta guía (la WR-90) se usa entre 8 y 12 GHz.], tema: "T6")
#pq(7, 1, 23, "d", "estúdialo en: simulacros de estudio 4·1·23 · libro: T7.10", "HF: propagación por reflexión ionosférica, la del DX (España–Nueva Zelanda)",
  [Un mediodía, con 100 W en 14 MHz, se contacta desde España con Australia. ¿Qué mecanismo hace posible ese enlace?],
  ([la onda de superficie, que sigue la curvatura terrestre], [un conducto troposférico formado por una inversión térmica], [la onda directa, gracias al horizonte radioeléctrico], [la reflexión de la onda en la ionosfera, con uno o varios saltos],),
  sol: [14 MHz es HF, y el DX intercontinental en HF se hace por reflexión ionosférica, sobre todo en la capa F2, encadenando saltos. La onda de superficie se agota en HF en pocas decenas de kilómetros, y los conductos troposféricos y la onda directa son mecanismos de VHF y UHF con alcances de, como mucho, cientos de kilómetros.], tema: "T7")
#pq(7, 1, 24, "b", "estúdialo en: simulacros de estudio 11·1·25 · libro: F-T7.18", "El conducto troposférico se forma con una inversión térmica (aire cálido sobre aire frío)",
  [Una mañana tranquila, el aire junto al suelo está a 10 °C y una capa situada a 500 m de altura está a 18 °C. Para la propagación en VHF y UHF, esto supone:],
  ([más absorción en la capa D y menos alcance en VHF], [una inversión térmica, que puede formar un conducto y llevar las señales a cientos de kilómetros], [la situación normal de la troposfera, sin efecto especial sobre la propagación], [una apertura de esporádica-E por calentamiento de la capa E],),
  sol: [Lo normal es que el aire se enfríe con la altura; aquí hay aire cálido sobre aire más frío, es decir, una inversión térmica. En esa frontera el índice de refracción cambia bruscamente, la onda se curva hacia el suelo y queda atrapada en un conducto. La capa D y la esporádica-E son fenómenos ionosféricos, a decenas o cientos de kilómetros de altura, y no dependen de la temperatura del aire cerca del suelo.], tema: "T7")
#pq(7, 1, 25, "a", "estúdialo en: simulacros de estudio 2·1·24 · libro: F-T7.2", "Esporádica-E: nubes de ionización intensa en la capa E que reflejan VHF",
  [Una tarde de julio, en 50 MHz, aparecen de repente señales fuertes y limpias de estaciones a unos 1500 km, que se mantienen media hora y luego desaparecen. El mecanismo más probable es la reflexión en:],
  ([nubes de ionización muy intensa formadas en la capa E (esporádica-E)], [las estelas ionizadas de los meteoros], [las cortinas ionizadas de una aurora], [la superficie de la Luna],),
  sol: [Las nubes de esporádica-E, en la capa E a unos 100 km, reflejan 50 MHz y a veces 144 MHz, con saltos de 1000 a 2000 km, aparecen de repente y son típicas del verano. Los meteoros dan ráfagas de segundos, no media hora de señal continua; la aurora da señales ásperas y desde España solo con tormentas fuertes, y el rebote lunar exige grandes antenas y da señales muy débiles.], tema: "T7")
#pq(7, 1, 26, "b", "estúdialo en: simulacros de estudio 8·1·26 · libro: T8.9", "El polímetro no mide la impedancia de una antena (hace falta puente o analizador de antenas)",
  [Con el óhmetro de un polímetro se miden los terminales de un dipolo simple (no plegado) desconectado de la línea. La lectura es:],
  ([unas decenas de ohmios, su impedancia en resonancia], [prácticamente infinita, porque en continua el dipolo es un circuito abierto], [cero, porque los dos brazos son conductores], [la parte resistiva de su impedancia a la frecuencia de trabajo],),
  sol: [El óhmetro mide con corriente continua, y entre los dos brazos de un dipolo no hay camino para ella: marca infinito. La impedancia de la antena solo existe a la frecuencia de trabajo y se mide con un puente de impedancias o un analizador de antenas.], tema: "T8")
#pq(7, 1, 27, "c", "estúdialo en: simulacros de estudio 5·1·26 · libro: T8.21", "S-meter: cada punto S equivale a 6 dB",
  [Un corresponsal te recibe con S5. Para que te reciba con S6, tendrías que multiplicar tu potencia por:],
  ([2], [1,2], [4], [6],),
  sol: [Cada punto S son 6 dB, y 6 dB equivalen a multiplicar la potencia por 4 (o la tensión por 2). Duplicar la potencia solo da 3 dB, medio punto S; el 6 son los decibelios, no el factor, y 1,2 sale de dividir 6 entre 5 como si la escala fuera lineal.], tema: "T8")
#pq(7, 1, 28, "d", "estúdialo en: simulacros de estudio 10·1·28", "Fuente, camino y víctima: caminos de acoplo por antena, por líneas y por radiación directa",
  [Todo problema de compatibilidad electromagnética se descompone en tres piezas. ¿Cuáles son?],
  ([los armónicos, las espurias y la intermodulación], [el filtrado, el desacoplo y el apantallamiento], [el emisor, la antena y el receptor], [una fuente, un camino de acoplo y una víctima],),
  sol: [Hay una fuente (por ejemplo, la estación), una víctima (cualquier equipo cercano) y un camino de acoplo entre ambas: la antena de la víctima, las líneas que le llegan o la radiación directa. Filtrar, desacoplar y apantallar son los remedios que cortan esos caminos, no las piezas del problema.], tema: "T9")
#pq(7, 1, 29, "b", "estúdialo en: simulacros de estudio 9·1·30 · libro: T10.8", "Fusible: en serie, corta las sobreintensidades",
  [Respecto del circuito que protege, un fusible se conecta:],
  ([entre el chasis y la toma de tierra], [en serie, para que toda la corriente del circuito lo atraviese], [en paralelo con la carga], [en paralelo con la fuente de alimentación],),
  sol: [El fusible es un hilo calibrado en serie con el circuito: toda la corriente pasa por él y, cuando supera cierto valor, se funde y abre el paso. En paralelo no vigilaría la corriente de la carga, y al fundirse no cortaría nada; en el conductor de tierra nunca debe ponerse un fusible.], tema: "T10")
#pq(7, 1, 30, "c", "estúdialo en: simulacros de estudio 7·1·30 · libro: C-T10.5", "Diferencial: actúa cuando la corriente de ida y la de vuelta difieren (derivación a tierra)",
  [Se produce un cortocircuito franco entre la fase y el neutro de un equipo, sin que nada toque tierra. El interruptor diferencial, por sí solo:],
  ([actúa en cuanto la corriente supera los 30 mA], [actúa, porque la tensión cae a cero], [no actúa, porque la corriente de ida y la de vuelta siguen siendo iguales], [actúa, porque la corriente es muy grande],),
  sol: [El diferencial no mira cuánta corriente pasa, sino si la que va por la fase vuelve entera por el neutro. En un cortocircuito entre fase y neutro toda la corriente vuelve por el neutro: no hay desequilibrio y el diferencial no se entera; de ese caso se ocupan el magnetotérmico o el fusible. Los 30 mA son la diferencia entre ida y vuelta que lo hace saltar, no la corriente total.], tema: "T10")
#fin-prueba()
#prueba(7, 2)
#pq(7, 2, 1, "d", "estúdialo en: simulacros de estudio 10·2·1 · libro: R1.17", "Las cifras se deletrean con su nombre inglés (Zero…Nine); el 0 es Zero, no Oscar ni «Cero»",
  [Al deletrear el distintivo `EA1RKM`, la cifra se dice:],
  ([India], [Uniform], [Uno], [One],),
  sol: [En el deletreo internacional las cifras se dicen con su nombre inglés: el 1 es One. Decir «Uno» es la cifra en castellano, que no da por buena el banco de preguntas. India y Uniform son palabras de letras (I y U), no de cifras.], tema: "R1")
#pq(7, 2, 2, "a", "estúdialo en: simulacros de estudio 11·2·3 · libro: R2.33", "QRV estoy dispuesto frente a QRU no tengo nada para usted",
  [Una estación te transmite «`QRU?`». ¿Qué te pregunta?],
  ([¿tiene algo para mí?], [¿debo esperar?], [¿quién me llama?], [¿está usted preparado?],),
  sol: [`QRU` es «no tengo nada para usted» y, con interrogación, «¿tiene algo para mí?». «¿Está usted preparado?» es `QRV?`, que se le parece en la forma; esperar es `QRX` y «¿quién me llama?» es `QRZ`.], tema: "R2")
#pq(7, 2, 3, "d", "estúdialo en: simulacros de estudio 9·2·2 · libro: R2.13", "QSB desvanecimiento (fading)",
  [En HF, la señal de tu corresponsal sube y baja lentamente de intensidad. ¿Con qué grupo se lo indicas?],
  ([`QRM`], [`QRH`], [`QSD`], [`QSB`],),
  sol: [La variación de intensidad de la señal recibida es el desvanecimiento, `QSB`. `QRM` es la interferencia de otras estaciones, `QRH` que su frecuencia varía (no su intensidad) y `QSD`, que la manipulación es defectuosa.], tema: "R2")
#pq(7, 2, 4, "a", "estúdialo en: simulacros de estudio 3·2·3 · libro: R3.22", "R recibido (conforme)",
  [Has copiado sin problemas todo lo que te ha transmitido el corresponsal. ¿Con qué abreviatura empiezas tu respuesta para decírselo?],
  ([`R`], [`RST`], [`K`], [`RPT`],),
  sol: [`R` significa «recibido»: lo que se transmitió llegó bien. `RPT` pide justo lo contrario (que repita), `RST` es el informe de señal y `K` invita a transmitir, no confirma nada.], tema: "R3")
#pq(7, 2, 5, "a", "estúdialo en: simulacros de estudio 8·2·5 · libro: R3.9", "OM operador corresponsal (old man)",
  [En el saludo «`GM OM TNX CALL`», la abreviatura `OM` se refiere a:],
  ([el operador corresponsal, como tratamiento cordial], [la operadora corresponsal], [la onda media], [el operador de más edad de la estación],),
  sol: [`OM` (\_old man\_) es el tratamiento cordial habitual entre radioaficionados, sin relación con la edad, aunque la traducción literal lo sugiera. Para una operadora se usa `YL`.], tema: "R3")
#pq(7, 2, 6, "c", "estúdialo en: simulacros de estudio 1·2·6 · libro: R3.25", "RIG equipo, ANT antena, PWR potencia",
  [El corresponsal describe su estación: «`RIG IC-7300 PWR ABT 100W ANT DIPOLE`». ¿Qué datos te da?],
  ([su equipo, su posición y su antena], [su equipo, su relación de ondas estacionarias y su antena], [su equipo, su potencia aproximada y su antena], [su indicativo, su potencia y su antena],),
  sol: [`RIG` es el equipo de radio, `PWR` la potencia (aquí «`ABT`», aproximadamente, 100 W) y `ANT` la antena. `RIG` no es el indicativo, y `PWR` no es la posición (`QTH`) ni la relación de ondas estacionarias.], tema: "R3")
#pq(7, 2, 7, "d", "estúdialo en: simulacros de estudio 12·2·8 · libro: C-R4.1", "Formato de la llamada de socorro: Mayday ×3 + «aquí»/«de» + distintivo ×3",
  [Una estación en peligro llama así: «Mayday, aquí EA4XYZ, EA4XYZ, EA4XYZ». ¿Qué falla en su llamada?],
  ([que debe decir «Pan Pan» antes de «Mayday»], [que debe empezar por el distintivo y terminar con «Mayday»], [que el distintivo debe decirse una sola vez], [que «Mayday» debe repetirse tres veces],),
  sol: [La llamada de socorro lleva «Mayday» tres veces, la palabra «aquí» (o «de») y el distintivo de la estación en peligro, también tres veces. Aquí el distintivo está bien repetido, pero «Mayday» se dice una sola vez. El orden es el correcto: primero debe oírse que es socorro, y «Pan Pan» es otra categoría.], tema: "R4")
#pq(7, 2, 8, "b", "estúdialo en: simulacros de estudio 11·2·9 · libro: R4.7", "Socorro en radiotelegrafía: SOS (no XXX, TTT ni CQD)",
  [La señal telegráfica `SOS` equivale, en radiotelefonía, a:],
  ([«Sécurité»], [«Mayday»], [la señal de alarma de 2200 y 1300 Hz], [«Pan Pan»],),
  sol: [`SOS` es la señal de socorro en telegrafía y su equivalente en fonía es «Mayday». «Pan Pan» corresponde a `XXX` (urgencia) y «Sécurité», a `TTT` (seguridad). La señal de alarma de dos tonos solo anuncia que sigue un socorro.], tema: "R4")
#pq(7, 2, 9, "b", "estúdialo en: simulacros de estudio 1·2·9 · libro: F-R4.10", "Segmento exclusivo de satélites en 2 m: 145,806–146,000 MHz",
  [Un satélite de aficionado anuncia su enlace en 145,900 MHz. Según el plan de bandas de la IARU para la Región 1, esa frecuencia está:],
  ([fuera de la banda de 2 m], [en el segmento exclusivo de satélites de 2 m], [en el segmento de salidas de repetidores], [en el segmento de balizas],),
  sol: [El plan reserva en exclusiva a los satélites el tramo final de 2 m, de 145,806 a 146,000 MHz, donde cae 145,900 MHz. Las salidas de repetidores terminan en 145,7935 MHz, las balizas están en 144,400–144,490 MHz, y la banda llega hasta 146 MHz.], tema: "R4")
#pq(7, 2, 10, "a", "estúdialo en: simulacros de estudio 9·2·10, 13·2·10 · libro: C-R5.9, R5.10", "Identificación de móviles y portables: /M, /MM, /MA, /P en grafía; palabras («portable») en fonía; no existe /AM",
  [En un registro de telegrafía aparece la identificación EA5XYZ/MA. Indica que la estación es:],
  ([móvil aeronáutica], [móvil terrestre], [portable], [móvil marítima],),
  sol: [La Orden admite, de forma opcional, /M (móvil), /MM (móvil marítima), /MA (móvil aeronáutica) y /P (portable) en telegrafía. /MA es, por tanto, la aeronáutica; no hay que confundirla con /MM, la marítima.], tema: "R5")
#pq(7, 2, 11, "c", "estúdialo en: simulacros de estudio 3·2·10, 12·2·11 · libro: R5.34, R5.35", "Distritos insulares y ciudades autónomas: 6 Baleares, 8 Canarias, 9 Ceuta y Melilla",
  [Escuchas a EA8XYZ. Por su cifra, su titular residía al obtener la autorización en:],
  ([Menorca], [Melilla], [Tenerife], [Cádiz],),
  sol: [El 8 es el distrito de Canarias, al que pertenece Tenerife. Menorca es de Baleares (6), Melilla del 9 y Cádiz de Andalucía (7); confundir el 6 con el 8 es el error más habitual.], tema: "R5")
#pq(7, 2, 12, "d", "estúdialo en: simulacros de estudio 3·2·11 · libro: F-R5.16", "Más de una cifra en el distintivo: acontecimientos relevantes identificados por sus fechas (aniversarios)",
  [Un radioclub quiere celebrar el 75 aniversario de su fundación con un distintivo que incluya la cifra 75. Según el art. 27 de la Orden:],
  ([solo es posible si el acto lo inaugura o visita S. M. el Rey], [solo es posible si el radioclub tiene sufijo de una letra], [no es posible, porque el distintivo lleva siempre una sola cifra, la del distrito], [puede autorizarse, porque se admite más de una cifra para acontecimientos relevantes identificados por sus fechas, como los aniversarios],),
  sol: [El art. 27.2 permite autorizar más de una cifra para acontecimientos relevantes identificados por sus fechas de celebración, como acontecimientos periódicos o aniversarios. La presencia del Rey es la condición de la cifra 0, otra excepción distinta.], tema: "R5")
#pq(7, 2, 13, "c", "estúdialo en: simulacros de estudio 6·2·13 · libro: F-R5.15", "Distintivo temporal: máximo 30 días al año por sufijo y peticionario (excepción: una letra en concursos, hasta 2 años)",
  [Un titular quiere usar un distintivo temporal con sufijo de una letra exclusivamente en concursos de alta competitividad. Puede autorizársele por un período de hasta:],
  ([30 días al año], [15 días naturales], [dos años desde la fecha de autorización], [90 días],),
  sol: [Como norma general, los distintivos temporales no superan 30 días al año por sufijo y peticionario, pero los de una sola letra usados solo en concursos de alta competitividad son la excepción: hasta dos años. Aplicar aquí la regla general es el error típico.], tema: "R5")
#pq(7, 2, 14, "a", "estúdialo en: simulacros de estudio 1·2·14 · libro: R6.11", "Composición de las Regiones: 1 Europa y África; 2 América; 3 resto de Asia y Oceanía",
  [¿Cuál de estas parejas de países pertenece a una misma Región de la UIT?],
  ([Japón y Australia], [España y la India], [Marruecos y Argentina], [Brasil y Sudáfrica],),
  sol: [Japón y Australia están en la Región 3 (Asia meridional y oriental y Oceanía). Brasil y Argentina son de la Región 2 (América), mientras que Sudáfrica y Marruecos, como toda África, y España son de la Región 1; la India es de la Región 3.], tema: "R6")
#pq(7, 2, 15, "b", "estúdialo en: simulacros de estudio 13·2·15 · libro: F-R6.3", "Las frecuencias del plan HF son las realmente transmitidas, no la del dial",
  [Vas a hablar en LSB en 40 m, donde el segmento de todos los modos empieza en 7.050 kHz. Si la señal ocupa unos 3 kHz por debajo del dial, el ajuste de dial mínimo para que toda la emisión quede dentro del segmento es:],
  ([7.050 kHz], [7.053 kHz], [7.056 kHz], [7.047 kHz],),
  sol: [Las frecuencias del plan son las realmente transmitidas, no la del dial: en LSB la señal cuelga por debajo de la portadora suprimida, así que el dial debe quedar 3 kHz por encima del borde, en 7.053 kHz. Con el dial en 7.050 kHz media emisión saldría del segmento; 7.056 kHz también cumple, pero no es el mínimo.], tema: "R6")
#pq(7, 2, 16, "d", "estúdialo en: simulacros de estudio 5·2·16 · libro: R9.23", "Interferir deliberadamente: nunca está permitido",
  [Durante un concurso, otra estación empieza a transmitir en la frecuencia que estabas usando. Lo correcto es:],
  ([transmitir encima de ella hasta que se vaya, porque llegaste antes], [emitir una portadora para recuperar la frecuencia], [aumentar la potencia por encima de la suya para tapar su señal], [cambiar de frecuencia o pedirle cortésmente que se aparte, sin interferirla nunca a propósito],),
  sol: [Nadie es dueño de una frecuencia, ni por llegar antes ni por estar en concurso, y la interferencia deliberada no está permitida en ningún caso. La salida correcta es la cortesía o cambiar de frecuencia.], tema: "R7")
#pq(7, 2, 17, "b", "estúdialo en: simulacros de estudio 10·2·17 · libro: R8.55", "Marco: competencia exclusiva del Estado en telecomunicaciones (art. 149.1.21.ª CE)",
  [La normativa que regula la actividad de los radioaficionados es la misma en toda España y no la dicta cada comunidad autónoma porque:],
  ([la radioafición es una actividad sin ánimo de lucro, excluida de las competencias autonómicas], [la Constitución (art. 149.1.21.ª) atribuye al Estado la competencia exclusiva en materia de telecomunicaciones], [la Recomendación CEPT T/R 61-01 obliga a cada país a tener una única norma de aficionados], [las comunidades autónomas han delegado esa competencia en la Secretaría de Estado mediante convenios],),
  sol: [El art. 149.1.21.ª de la Constitución reserva al Estado, con carácter exclusivo, las telecomunicaciones: por eso el Reglamento de aficionados es estatal, y también la inspección y la sanción corresponden al Estado. No hay delegación autonómica que explique la uniformidad, y la T/R 61-01 regula el uso temporal de estaciones en otros países, no la organización interna de cada Estado.], tema: "R8")
#pq(7, 2, 18, "b", "estúdialo en: simulacros de estudio 9·2·19 · libro: F-R8.16", "Radioaficionado: interés por la radiotecnia con carácter exclusivamente personal, sin fines de lucro",
  [Un radioaficionado cobra a una empresa por difundir sus avisos comerciales a través de su estación. Según el Reglamento, esa conducta:],
  ([es lícita si lo comunica previamente a la Jefatura Provincial de Inspección de Telecomunicaciones], [puede dar lugar a la revocación de la autorización, porque la radioafición se ejerce con carácter exclusivamente personal y sin fines de lucro], [es lícita siempre que emita dentro de las bandas atribuidas al servicio de aficionados], [solo está prohibida si los avisos se difunden a través de un repetidor],),
  sol: [El art. 2.1 define a los radioaficionados como personas que se interesan por la radiotecnia con carácter exclusivamente personal y sin fines de lucro ni contenido económico. Por eso emitir con fines comerciales, publicitarios o lucrativos es causa de revocación (art. 8.1.b). Emitir dentro de banda no lo legaliza: el problema es la finalidad, no la frecuencia.], tema: "R8")
#pq(7, 2, 19, "a", "estúdialo en: simulacros de estudio 8·2·17 · libro: R8.42", "Radiobalizas en las bandas de aficionado (p. ej., 144–146 MHz)",
  [En el plan de bandas de la IARU para la Región 1, ¿qué segmento de la banda de 2 m se reserva a las radiobalizas?],
  ([144,400–144,491 MHz], [145,000–145,1875 MHz], [145,600–145,7875 MHz], [146,000–146,091 MHz],),
  sol: [El plan de bandas de la IARU Región 1 reserva a las balizas el segmento de 144,400–144,491 MHz; la Orden vigente no enumera bandas para las radiobalizas. El tramo de 145,000–145,1875 MHz es la entrada de los repetidores de 2 m, y el de 145,600–145,7875 MHz, su salida, 600 kHz más arriba. 146 MHz ya queda fuera de la banda de 144–146 MHz.], tema: "R8")
#pq(7, 2, 20, "d", "estúdialo en: simulacros de estudio 13·2·20 · libro: C-R8.35", "Interconexión con otras redes: permitida con condiciones (fines de radioafición)",
  [Una asociación quiere enlazar sus repetidores con otros a través de una red pública de telecomunicaciones, para facilitar las comunicaciones entre radioaficionados. Según el artículo 23:],
  ([no puede: las estaciones de aficionado no pueden conectarse a otras redes de telecomunicación], [puede, pero solo mientras dure un concurso], [puede, siempre que la utilice para cursar tráfico de terceros], [puede, porque la interconexión tiene fines relacionados con la radioafición, siempre que los dispositivos de conexión no dañen ni interfieran esa red],),
  sol: [El art. 23 permite interconectar las estaciones a través de otras instalaciones de telecomunicación autorizadas cuando la finalidad está relacionada con la radioafición, y exige que los dispositivos de conexión a redes públicas no causen daños ni interferencias. La norma no limita la interconexión a los concursos. Cursar tráfico de terceros no es un fin de radioafición: solo se admite en emergencias o desastres.], tema: "R8")
#pq(7, 2, 21, "c", "estúdialo en: simulacros de estudio 12·2·19 · libro: C-R8.48", "Banda de 40 m: 7100–7200 kHz, a título primario para aficionados en la Región 1 desde 2009",
  [En España (Región 1), ¿qué tramo de la banda de 40 m está hoy atribuido a los aficionados a título primario?],
  ([7000–7100 kHz solamente], [7000–7300 kHz], [7000–7200 kHz], [7000–7100 kHz, y 7100–7200 kHz solo a título secundario],),
  sol: [Desde el 29 de marzo de 2009, al terminar la transición fijada por la CMR-03, el tramo de 7100 a 7200 kHz pasó de la radiodifusión a los aficionados a título primario; junto con 7000–7100 kHz forma la banda de 40 m de la Región 1. Limitarla a 7100 kHz es la situación anterior a 2009, y llegar a 7300 kHz es propio de la Región 2.], tema: "R8")
#pq(7, 2, 22, "c", "estúdialo en: simulacros de estudio 12·2·21 · libro: R8.80", "RR art. 25: comunicaciones entre países permitidas salvo oposición de una administración",
  [Contactas con un aficionado de otro país cuya Administración ha notificado que se opone a las comunicaciones de aficionado con otros países. Según el artículo 25 del Reglamento de Radiocomunicaciones:],
  ([está permitida, porque basta con que la autorice la Administración española], [está permitida si la hacéis en inglés], [esa comunicación no está permitida], [está permitida si los dos países están en la misma Región de la UIT],),
  sol: [El art. 25 del RR permite las comunicaciones entre aficionados de distintos países salvo que la Administración de alguno de los países afectados haya manifestado su oposición. Basta la oposición de uno, así que el permiso del otro no la levanta. La Región o el idioma no influyen.], tema: "R8")
#pq(7, 2, 23, "c", "estúdialo en: simulacros de estudio 4·2·23 · libro: F-R8.30", "Solicitud de autorización: acompañada del resguardo de la tasa de tramitación",
  [La solicitud de autorización de radioaficionado va acompañada del resguardo de abono de una tasa de tramitación. Esa tasa la establece:],
  ([cada comunidad autónoma para su territorio], [el Real Decreto 2623/1986], [la Ley General de Telecomunicaciones], [el anexo I de la Orden IET/1311/2013],),
  sol: [El art. 6 de la Orden exige acompañar la solicitud del resguardo de la tasa de tramitación «establecida en la Ley General de Telecomunicaciones»: el Reglamento de aficionados no fija tasas, se remite a la ley. El anexo I trata de bandas y características técnicas, y el Real Decreto 2623/1986, de antenas.], tema: "R8")
#pq(7, 2, 24, "b", "estúdialo en: simulacros de estudio 2·2·24 · libro: R8.76", "Daños: los que causa la antena (instalación, conservación, desmontaje) son del titular; los que causa la propiedad a la antena, de la propiedad",
  [Durante unas obras, un operario de la comunidad rompe por descuido el rotor de tu antena; semanas antes, una pieza de tu antena había caído y roto una claraboya del edificio. ¿Quién responde de cada daño?],
  ([De los dos, tú como titular, porque la antena es tuya], [Del rotor, la propiedad del inmueble; de la claraboya, tú como titular], [De los dos, la comunidad, porque ambos ocurren en el edificio], [Del rotor, tú, porque asumes el riesgo durante las obras; de la claraboya, la comunidad],),
  sol: [Depende de quién causa el daño. Los que causa la antena (instalación, conservación, desmontaje) son del titular, y para eso está su seguro de responsabilidad civil; los que causa la propiedad a la antena, su reparación e indemnización, son de la propiedad (art. 22 del Real Decreto 2623/1986).], tema: "R8")
#pq(7, 2, 25, "d", "estúdialo en: simulacros de estudio 12·2·25 · libro: C-R8.30", "Bandas que requieren autorización especial: 2300–2450 MHz, 5650–5850 MHz y 24,050–24,250 GHz (con excepciones)",
  [¿En cuál de estas frecuencias necesita un radioaficionado una autorización especial para emitir?],
  ([2320 MHz], [1296 MHz], [5761 MHz], [2400 MHz],),
  sol: [La disposición adicional segunda exige autorización especial en 2300–2450 MHz, 5650–5850 MHz y 24,050–24,250 GHz, salvo las subbandas 2316–2332, 5700–5720 y 5760–5762 MHz. 2400 MHz está en la primera banda y fuera de su excepción. 2320 y 5761 MHz caen en subbandas exceptuadas, y 1296 MHz no figura en la relación.], tema: "R8")
#pq(7, 2, 26, "c", "estúdialo en: simulacros de estudio 3·2·24 · libro: R8.68", "Estación fija remota: accionada a distancia",
  [Tienes tu estación fija instalada en una casa de campo y la manejas desde tu domicilio en la ciudad, sin nadie presente junto al equipo. Según las definiciones de la Orden, se trata de una estación:],
  ([automática desatendida], [móvil], [fija remota], [portable],),
  sol: [La estación fija remota es una estación fija que puede ser accionada a distancia por su titular, y sigue siendo responsabilidad suya cuanto se emita desde ella. No es una desatendida: estas son estaciones colectivas de asociaciones que funcionan sin intervención directa del operador, mientras que aquí el titular la opera, aunque sea a distancia. Tampoco es portable ni móvil, porque la estación no cambia de sitio.], tema: "R8")
#pq(7, 2, 27, "a", "estúdialo en: simulacros de estudio 3·2·26 · libro: C-R8.7", "Obligaciones del gestor de la desatendida (no le corresponde autorizar su funcionamiento)",
  [¿A quién corresponde autorizar que un repetidor de radioaficionado empiece a funcionar?],
  ([a la Administración: la Jefatura Provincial verifica la instalación y expide la licencia que habilita a emitir], [a la Junta Directiva de la asociación titular], [al gestor designado por la asociación titular], [a la asociación que coordina los repetidores de la zona],),
  sol: [Autorizar el inicio del funcionamiento es un acto de la Administración: la Jefatura Provincial verifica la instalación y expide la licencia (arts. 20 y 26 de la Orden IET/1311/2013). El gestor de la antigua Orden de 2006 cuidaba la estación: verificaba el tráfico, actualizaba la información y procuraba su mantenimiento, pero nunca la autorizaba. La Junta Directiva responde del uso de la estación, que no es lo mismo que autorizarla.], tema: "R8")
#pq(7, 2, 28, "b", "estúdialo en: simulacros de estudio 10·2·28 · libro: R9.8", "Inspección: el Ministerio competente, mediante la inspección de telecomunicaciones y las Jefaturas Provinciales",
  [Un inspector de la Jefatura Provincial de Inspección de Telecomunicaciones se presenta a comprobar tu estación de aficionado. Esa Jefatura actúa como órgano territorial de:],
  ([la diputación provincial], [el Ministerio competente en telecomunicaciones, es decir, la Administración del Estado], [la Unión Internacional de Telecomunicaciones (UIT)], [la consejería de industria de la comunidad autónoma],),
  sol: [La inspección de las estaciones de aficionado es estatal: la ejerce el Ministerio competente en telecomunicaciones a través de su inspección, y las Jefaturas Provinciales son su brazo en cada provincia. La comunidad autónoma es el distractor más tentador, pero el dominio público radioeléctrico es competencia exclusiva del Estado. La UIT fija el Reglamento de Radiocomunicaciones, pero no inspecciona estaciones.], tema: "R9")
#pq(7, 2, 29, "c", "estúdialo en: simulacros de estudio 8·2·29 · libro: C-R9.1", "No es infracción comunicar con otra estación de la que se es titular",
  [Un radioaficionado, titular de dos estaciones autorizadas, establece un comunicado entre ambas para comprobar la cobertura. Según la normativa vigente:],
  ([comete la infracción leve de comunicarse utilizando estaciones no autorizadas], [necesita una autorización experimental previa], [no comete ninguna infracción], [comete una infracción grave por ocupar una frecuencia sin necesidad],),
  sol: [Ninguna norma vigente tipifica esa conducta, y solo es infracción lo que una ley tipifica expresamente. El servicio de aficionados es de intercomunicación y nada exige que las dos estaciones tengan titulares distintos. La leve del art. 108.2 se refiere a estaciones no autorizadas, y aquí ambas lo están.], tema: "R9")
#pq(7, 2, 30, "b", "estúdialo en: simulacros de estudio 7·2·30 · libro: F-R9.4", "Plazo para resolver el procedimiento sancionador: un año",
  [Hace ocho meses se inició un expediente sancionador contra un radioaficionado por interferencias, y todavía no se ha resuelto. Según la Ley 11/2022, ¿sigue la Administración dentro del plazo para resolverlo?],
  ([Sí, y no tiene más límite que la prescripción de la infracción], [Sí, porque el plazo para resolver es de un año], [No, porque el plazo para resolver es de tres meses], [No, porque el plazo para resolver es de seis meses],),
  sol: [El art. 114.2 de la Ley 11/2022 fija en un año el plazo para resolver el procedimiento sancionador, así que a los ocho meses la Administración sigue en plazo. Seis o tres meses no son plazos de ese artículo. La prescripción (art. 113) mide otra cosa, el tiempo para perseguir la infracción, y no sustituye al plazo para resolver un expediente ya abierto.], tema: "R9")
#fin-prueba()
#soluciones-simulacro(7)

// ======================================================================
#simulacro(8)
#prueba(8, 1)
#pq(8, 1, 1, "a", "estúdialo en: simulacros de estudio 9·1·1 · libro: C-T1.6", "Unidades de intensidad, tensión, resistencia y potencia (A, V, Ω, W)",
  [En la placa de características de una fuente de alimentación de estación se lee «13,8 V – 20 A». Esas dos cifras indican, respectivamente:],
  ([la tensión de salida y la intensidad máxima que puede entregar], [la potencia de salida y la resistencia interna], [la intensidad de salida y la potencia máxima], [la tensión de salida y la potencia máxima],),
  sol: [El voltio (V) es la unidad de tensión y el amperio (A) la de intensidad: la fuente da 13,8 V y puede entregar hasta 20 A. La potencia se mide en vatios (W) y la resistencia en ohmios (Ω), así que ninguna de las dos cifras es una potencia; la potencia máxima sería $13","8 times 20 = 276$ W.], tema: "T1")
#pq(8, 1, 2, "d", "estúdialo en: simulacros de estudio 3·1·3 · libro: T1.25", "Parámetro que varía en cada modulación analógica (AM amplitud, FM frecuencia, PM fase)",
  [Indica la asociación correcta entre el tipo de modulación analógica y el parámetro de la portadora que varía con la señal moduladora:],
  ([AM, la fase; FM, la frecuencia; PM, la amplitud], [AM, la amplitud; FM, la fase; PM, la frecuencia], [AM, la frecuencia; FM, la amplitud; PM, la fase], [AM, la amplitud; FM, la frecuencia; PM, la fase],),
  sol: [Cada nombre dice el parámetro que se modula: en AM la amplitud, en FM la frecuencia instantánea y en PM la fase, estas dos últimas con amplitud constante. FM y PM están emparentadas (la fase es la integral de la frecuencia), pero en cada una es un parámetro distinto el que sigue a la moduladora.], tema: "T1")
#pq(8, 1, 3, "b", "estúdialo en: simulacros de estudio 7·1·3 · libro: F-T1.18", "FM: amplitud constante; varía la frecuencia instantánea",
  [Una ventaja de la FM que se deriva de que su amplitud sea constante es que:],
  ([ocupa menos anchura de banda que la AM], [es poco sensible al ruido de amplitud y admite amplificadores no lineales de alto rendimiento], [no necesita portadora], [se puede demodular con un simple detector de envolvente],),
  sol: [Como en FM la información va en la frecuencia y la amplitud no cambia, el receptor puede ignorar las variaciones de amplitud que añade el ruido, y el transmisor puede usar etapas no lineales sin distorsionar el mensaje. La FM ocupa más anchura que la AM, y el detector de envolvente es el de la AM, cuya envolvente sí lleva el mensaje.], tema: "T1")
#pq(8, 1, 4, "d", "estúdialo en: simulacros de estudio 8·1·3 · libro: F-T1.30", "CRC detecta errores; FEC los corrige sin retransmisión a costa de velocidad útil",
  [En un enlace digital de un solo sentido, sin canal de retorno para pedir repeticiones, la forma de recuperar los bloques que llegan con errores es:],
  ([aumentar el número de bits por símbolo de la modulación], [un CRC, que indica qué bits son erróneos para invertirlos], [un CRC seguido de la petición de repetición del bloque], [la corrección directa de errores (FEC), con la que el receptor los corrige por sí mismo],),
  sol: [El CRC solo detecta que el bloque llegó mal, no dónde, y para recuperarlo hay que pedir su repetición, imposible sin canal de retorno. La FEC añade redundancia suficiente para que el receptor corrija sin retransmisión; por eso es útil en enlaces de un solo sentido o con mucho retardo.], tema: "T1")
#pq(8, 1, 5, "b", "estúdialo en: simulacros de estudio 5·1·5 · libro: C-T2.17", "Código de colores: leer el valor de una resistencia de cuatro bandas (cifras + multiplicador)",
  [¿Qué bandas de color, por este orden, identifican una resistencia de 4,7 kΩ con una tolerancia del 10 %?],
  ([amarillo, violeta, naranja, plata], [amarillo, violeta, rojo, plata], [violeta, amarillo, rojo, plata], [amarillo, violeta, rojo, oro],),
  sol: [4,7 kΩ son 4700 Ω: cifras 4 (amarillo) y 7 (violeta) y dos ceros, es decir, multiplicador rojo ($times 10^2$); la plata es el ±10 %. Con naranja como multiplicador saldrían tres ceros, 47 kΩ. El oro indicaría ±5 %, y el orden violeta-amarillo daría 7,4 kΩ.], tema: "T2")
#pq(8, 1, 6, "a", "estúdialo en: simulacros de estudio 8·1·5 · libro: T2.26", "Unidad de capacidad: el faradio (no mide la carga)",
  [En el cuerpo de un condensador se lee «47 μF». ¿Qué magnitud indica ese dato?],
  ([su capacidad], [la carga eléctrica que almacena], [su autoinducción], [su reactancia a 50 Hz],),
  sol: [El faradio y sus submúltiplos (μF, nF, pF) miden la capacidad: la carga que el condensador guarda por cada voltio aplicado. La carga se mide en culombios y depende además de la tensión a la que se cargue ($Q = C V$). La autoinducción se mide en henrios y la reactancia en ohmios.], tema: "T2")
#pq(8, 1, 7, "d", "estúdialo en: simulacros de estudio 1·1·7, 8·1·6 · libro: T2.16, F-T2.6", "La reactancia inductiva X_L = 2πfL crece con la frecuencia y es nula en continua",
  [El choque de RF que alimenta el colector de un transistor final deja llegar los 13,8 V de la fuente y, en cambio, frena la RF. ¿Por qué?],
  ([porque su reactancia es infinita en continua y nula en radiofrecuencia], [porque rectifica la radiofrecuencia y la convierte en continua], [porque su reactancia disminuye al aumentar la frecuencia], [porque su reactancia es nula en continua y muy grande en radiofrecuencia],),
  sol: [Con $X_L = 2 pi f L$, en continua ($f = 0$) la bobina ideal es un cable y el colector recibe la tensión de la fuente; en RF su reactancia es de miles de ohmios y la señal no se escapa hacia la fuente. Una reactancia que baja con la frecuencia es la del condensador.], tema: "T2")
#pq(8, 1, 8, "b", "estúdialo en: simulacros de estudio 6·1·9 · libro: C-T2.16", "Usos del transistor: amplificar, oscilar, mezclar (no rectificar ni hacer de balun)",
  [¿Cuál de estas funciones de un equipo se encarga normalmente a un diodo y no a un transistor?],
  ([mezclar la señal de RF con la del oscilador local], [rectificar la alterna de la red en la fuente de alimentación], [amplificar la señal de frecuencia intermedia], [generar la señal del oscilador local],),
  sol: [El transistor amplifica, oscila (amplificador con realimentación) y mezcla: son sus usos en las etapas de RF, FI y audio. Rectificar es el trabajo del diodo, que deja pasar la corriente en un solo sentido. Mezclar y oscilar sí son usos del transistor, aunque se olvidan con facilidad.], tema: "T2")
#pq(8, 1, 9, "b", "estúdialo en: simulacros de estudio 9·1·8 · libro: T2.28", "Emisión termoiónica: el cátodo caliente emite y la válvula conduce solo con la placa positiva",
  [Una válvula diodo se emplea como rectificador. ¿Por qué no conduce en el semiciclo en que la placa es negativa respecto del cátodo?],
  ([porque la rejilla bloquea los electrones en ese semiciclo], [porque los electrones emitidos por el cátodo son repelidos por la placa, y la placa, fría, no emite], [porque el cátodo deja de calentarse durante ese semiciclo], [porque el vacío solo conduce en un sentido aunque no haya emisión],),
  sol: [Solo el cátodo caliente emite electrones (emisión termoiónica). Con la placa positiva, esos electrones negativos la alcanzan; con la placa negativa son repelidos, y la placa, que está fría, no emite: no hay corriente. Una válvula diodo no tiene rejilla, y el cátodo sigue caliente en los dos semiciclos.], tema: "T2")
#pq(8, 1, 10, "a", "estúdialo en: simulacros de estudio 7·1·10 · libro: T3.52", "Condición de resonancia: XL = XC, las reactancias se cancelan y el circuito es puramente resistivo",
  [En un circuito RLC serie, a cierta frecuencia, la reactancia de la bobina y la del condensador valen ambas 200 Ω, y la resistencia es de 10 Ω. A esa frecuencia el circuito presenta:],
  ([una impedancia de 10 Ω, con la tensión y la corriente en fase], [una impedancia de 410 Ω, con la corriente retrasada 90°], [una impedancia de 10 Ω, con la corriente adelantada 90°], [una impedancia de unos 283 Ω, con la corriente retrasada 45°],),
  sol: [Con $X_L = X_C$ el circuito está en resonancia: las reactancias se cancelan y solo queda la resistencia, de modo que $Z = R = 10$ Ω y el circuito es puramente resistivo, con tensión y corriente en fase. Los 410 Ω suman todo; los 283 Ω combinan las dos reactancias en cuadratura en lugar de restarlas; y un desfase de 90° no puede darse si solo queda la resistencia.], tema: "T3")
#pq(8, 1, 11, "c", "estúdialo en: simulacros de estudio 4·1·11 · libro: F-T3.46", "Filtro RC: fc = 1/(2πRC)",
  [Se quiere un filtro RC de paso bajo con una frecuencia de corte de 3 kHz usando una resistencia de 1 kΩ. El condensador debe ser de unos:],
  ([5,3 nF], [333 nF], [53 nF], [530 nF],),
  sol: [De $f_c = 1 slash (2 pi R C)$ se despeja $C = 1 slash (2 pi R f_c) = 1 slash (6","28 dot 10^3 dot 3 times 10^3) approx 5","3 times 10^(-8)$ F, unos 53 nF. Los 333 nF salen de olvidar el $2 pi$ ($1 slash R f_c$); los 5,3 nF y los 530 nF son errores de una potencia de diez.], tema: "T3")
#pq(8, 1, 12, "d", "estúdialo en: simulacros de estudio 7·1·11 · libro: C-T3.7", "Neutralización: anula la realimentación parásita para que el amplificador no oscile",
  [Para neutralizar un amplificador de RF se aplica a su entrada, a través de un pequeño condensador:],
  ([la señal de un oscilador auxiliar de la misma frecuencia], [una muestra de la salida en fase, que aumenta la ganancia], [una tensión continua que lleva el transistor al corte], [una muestra de la salida en oposición de fase, que cancela la realimentación parásita],),
  sol: [Una parte de la salida vuelve a la entrada por las capacidades parásitas del dispositivo y, si llega en fase, el amplificador oscila. La neutralización aplica a la entrada otra muestra de la salida en oposición de fase que cancela esa realimentación indeseada. Una muestra en fase sería justo realimentación positiva: favorecería la oscilación en lugar de evitarla.], tema: "T3")
#pq(8, 1, 13, "b", "estúdialo en: simulacros de estudio 9·1·12 · libro: T3.12", "El detector de envolvente es asíncrono: no necesita sincronización con el transmisor",
  [Un receptor de AM con detector de envolvente no necesita oscilador de batido ni ninguna referencia sincronizada con el transmisor porque:],
  ([el detector reconstruye la portadora con un PLL interno], [la portadora llega con la señal y el diodo sigue directamente su envolvente: es un detector asíncrono], [en AM la información no viaja en la amplitud de la señal], [el oscilador de batido va integrado dentro del propio diodo],),
  sol: [En AM la portadora se transmite junto con las bandas laterales, y el diodo con su filtro $R C$ sigue la envolvente sin necesitar referencia alguna del transmisor: es asíncrono, y por eso tan simple. En SSB y CW falta la portadora y hace falta el detector de producto con su BFO. En AM la información viaja precisamente en la amplitud.], tema: "T3")
#pq(8, 1, 14, "d", "estúdialo en: simulacros de estudio 3·1·13 · libro: T3.27", "Oscilador: convierte la corriente continua en alterna",
  [La energía de la señal alterna que entrega un oscilador procede:],
  ([del cristal de cuarzo, que la genera por efecto piezoeléctrico], [de una señal alterna que se aplica a su entrada, como en un amplificador], [de la antena a la que está conectado], [de la alimentación de corriente continua del circuito],),
  sol: [Un oscilador se alimenta con continua y entrega una alterna de la frecuencia que fija su circuito resonante: convierte la corriente continua en alterna. No necesita señal de entrada, porque arranca del propio ruido del circuito y se mantiene con su realimentación. El cristal solo fija la frecuencia; no aporta la energía.], tema: "T3")
#pq(8, 1, 15, "c", "estúdialo en: simulacros de estudio 4·1·15 · libro: T4.30", "La sensibilidad (figura de ruido) la determina la primera etapa de RF (Friis)",
  [En una estación de 2 m con un cable coaxial largo, el preamplificador de bajo ruido mejora más la sensibilidad si se instala:],
  ([a la salida de audio del receptor], [junto al receptor, al final del cable], [junto a la antena, delante de las pérdidas del cable], [entre el detector y el amplificador de audio],),
  sol: [Por la fórmula de Friis la figura de ruido la fija casi por completo la primera etapa: lo que viene después entra dividido por la ganancia acumulada. Si el preamplificador va delante del cable, las pérdidas del coaxial ya no empeoran el ruido; en el ejemplo del libro, el mismo aparato pasa de 4,3 a 1,6 dB solo por cambiarlo de sitio. Ganancia de audio no mejora la relación señal/ruido.], tema: "T4")
#pq(8, 1, 16, "a", "estúdialo en: simulacros de estudio 12·1·16 · libro: C-T4.5", "La estabilidad del receptor depende del oscilador local",
  [En un superheterodino, el oscilador local deriva 300 Hz al calentarse. La frecuencia que recibe el receptor:],
  ([se desplaza también 300 Hz], [no cambia, porque la FI es fija], [se desplaza 600 Hz, el doble de la deriva], [no cambia, porque el CAG corrige la deriva],),
  sol: [Como $f_s = f_"OL" plus.minus f_"FI"$ y la FI es fija, cualquier deriva del oscilador local desplaza exactamente lo mismo la frecuencia sintonizada. Que la FI sea fija es precisamente la razón de que el error pase entero a la señal recibida. El CAG controla la ganancia, no la frecuencia.], tema: "T4")
#pq(8, 1, 17, "d", "estúdialo en: simulacros de estudio 11·1·17 · libro: C-T5.31", "Diagrama de bloques del transmisor de BLU (BF, modulador balanceado, filtro, RF)",
  [En un transmisor de BLU por el método del filtro, la señal que sale del filtro de banda lateral pasa a continuación a:],
  ([un discriminador que la convierte en FM], [el modulador balanceado, que suprime la portadora], [el amplificador de BF del micrófono], [un mezclador que, con el VFO, la traslada a la frecuencia de trabajo],),
  sol: [El orden es amplificador de BF, modulador balanceado con el oscilador de portadora, filtro de banda lateral, mezclador con el VFO, amplificador lineal y filtro paso bajo. El filtro solo puede hacerse a una frecuencia fija, así que después hay que trasladar la SSB a la frecuencia de trabajo. El modulador balanceado va antes del filtro, no después.], tema: "T5")
#pq(8, 1, 18, "c", "estúdialo en: simulacros de estudio 7·1·19 · libro: T5.6", "Armónicos: múltiplos enteros de la fundamental",
  [Un transmisor trabaja en 3,6 MHz. Su tercer armónico cae en:],
  ([1,2 MHz], [7,2 MHz], [10,8 MHz], [14,4 MHz],),
  sol: [Los armónicos son múltiplos enteros de la fundamental: el tercero está en $3 times 3","6 = 10","8$ MHz. Los 1,2 MHz resultan de dividir por tres, y los armónicos nunca están por debajo de la fundamental. Los 7,2 MHz son el segundo armónico y los 14,4 MHz, el cuarto.], tema: "T5")
#pq(8, 1, 19, "b", "estúdialo en: simulacros de estudio 9·1·18 · libro: F-T5.4", "Radiación por la estructura: RF que escapa por chasis y cables; se reduce apantallando y filtrando",
  [Tu transmisor está conectado a una carga artificial blindada, sin antena, y aun así un receptor cercano capta claramente su señal. Lo más probable es que se trate de:],
  ([armónicos que salen por la línea hacia la antena], [radiación por la estructura, a través del chasis y de los cables del equipo], [emisiones fuera de banda debidas a la modulación], [la frecuencia imagen del receptor cercano],),
  sol: [Sin antena, la RF que llega al receptor tiene que salir por otro camino: el chasis mal apantallado y los cables de alimentación o micrófono actúan como antenas involuntarias. Los armónicos y las emisiones fuera de banda salen por la línea, que aquí acaba en una carga blindada. Se corrige apantallando la caja y filtrando los cables.], tema: "T5")
#pq(8, 1, 20, "c", "estúdialo en: simulacros de estudio 9·1·21 · libro: C-T6.13", "El diagrama de radiación representa la distribución de la energía radiada en el espacio",
  [En un diagrama de radiación polar, la distancia de la curva al centro en una dirección dada representa:],
  ([la frecuencia a la que la antena radia mejor en esa dirección], [la impedancia que presenta la antena en esa dirección], [la intensidad radiada en esa dirección], [la distancia máxima que alcanza la señal en esa dirección],),
  sol: [El diagrama de radiación es un mapa de cómo se reparte en el espacio la energía radiada: la distancia de la curva al centro mide la intensidad en cada dirección. No da alcances, que dependen además de la potencia y de la propagación, ni impedancias ni frecuencias.], tema: "T6")
#pq(8, 1, 21, "a", "estúdialo en: simulacros de estudio 3·1·22 · libro: T6.8", "Polarización: orientación del campo eléctrico radiado",
  [En un enlace en visión directa en 2 m, una estación usa una antena vertical y la otra una Yagi con los elementos horizontales. Lo más probable es que:],
  ([la señal llegue muy atenuada, 20 dB o más, por la polarización cruzada], [no haya diferencia, porque la polarización solo importa en HF], [la señal mejore, porque se suman las dos polarizaciones], [la onda llegue con polarización circular],),
  sol: [La polarización es la orientación del campo eléctrico, que sigue la del hilo radiante: vertical en una estación y horizontal en la otra. En visión directa, una antena cruzada respecto de la emisora puede perder 20 dB o más. Es en HF donde importa menos, porque la ionosfera gira la polarización por el camino.], tema: "T6")
#pq(8, 1, 22, "a", "estúdialo en: simulacros de estudio 1·1·22 · libro: T6.25", "Relé T-R: al transmitir desconecta y protege la entrada del receptor",
  [Si el relé de transmisión-recepción de un transceptor se avería y deja la entrada del receptor conectada a la antena mientras se transmite:],
  ([la potencia del propio transmisor puede destruir la primera etapa del receptor], [la antena cambia de polarización], [la ROE baja a 1:1], [el receptor gana sensibilidad, porque le llega más señal],),
  sol: [La primera etapa del receptor está diseñada para microvoltios; por eso, al transmitir, el relé T-R la desconecta y normalmente la pone a masa. Si el relé falla, los vatios del transmisor llegan directamente a esa etapa y la destruyen. El relé no tiene nada que ver con la ROE ni con la polarización.], tema: "T6")
#pq(8, 1, 23, "c", "estúdialo en: simulacros de estudio 1·1·23 · libro: T7.23", "La ionosfera depende de la actividad solar y de ella dependen las condiciones en HF",
  [Una fulguración solar lanza un golpe de rayos X hacia la Tierra. ¿Qué efecto tiene, en minutos, sobre la HF en el hemisferio iluminado?],
  ([mejora de golpe la propagación en las bandas altas, que se abren al DX], [ninguno en HF: solo afecta a VHF y UHF, que viajan por la troposfera], [aumenta mucho la ionización de la capa D, la absorción se dispara y la HF enmudece], [forma conductos troposféricos que alargan el alcance de la HF],),
  sol: [La ionosfera depende de la radiación solar, y un golpe de rayos X multiplica la ionización de la capa D: la absorción crece tanto que la HF queda muda durante minutos u horas (desvanecimiento súbito o efecto Dellinger). No abre las bandas altas, y la troposfera, que es lo que afecta a VHF y UHF, no depende de la actividad solar.], tema: "T7")
#pq(8, 1, 24, "a", "estúdialo en: simulacros de estudio 9·1·24 · libro: F-T7.10", "Ciclo solar: más manchas → más ionización, MUF más alta y bandas altas abiertas",
  [En el mínimo del ciclo solar, ¿qué cabe esperar en HF?],
  ([que de día la banda más útil para DX sea la de 20 m y de noche haya que bajar a 40 u 80 m], [que la MUF suba, porque con menos manchas la capa D absorbe menos], [que las condiciones no cambien, porque el ciclo solar solo afecta a VHF], [que las bandas de 10, 12 y 15 m se abran a todo el mundo con pocos vatios],),
  sol: [Con pocas manchas hay menos radiación ultravioleta y X, menos ionización en la F2 y una MUF más baja: las bandas altas se cierran y de día manda 20 m. La apertura generalizada de 10, 12 y 15 m es propia del máximo del ciclo. El ciclo de once años es precisamente lo que gobierna la HF.], tema: "T7")
#pq(8, 1, 25, "c", "estúdialo en: simulacros de estudio 13·1·25 · libro: C-T8.1", "Conexión de los instrumentos: amperímetro en serie, voltímetro en paralelo, óhmetro sobre el componente",
  [¿Qué ocurre si por error se conecta un amperímetro directamente entre los bornes de una batería?],
  ([indica la fuerza electromotriz de la batería], [indica cero, porque no hay ninguna carga en el circuito], [circula por él una corriente muy grande que puede dañarlo, porque es casi un cortocircuito], [indica la capacidad de la batería en amperios-hora],),
  sol: [El amperímetro tiene una resistencia interna casi nula y debe ir en serie con una carga; puesto en paralelo con la batería es prácticamente un cortocircuito, y la corriente solo la limita la resistencia interna de la batería. La fem se mide con un voltímetro en paralelo, que sí tiene una resistencia muy alta.], tema: "T8")
#pq(8, 1, 26, "d", "estúdialo en: simulacros de estudio 6·1·27 · libro: C-T8.9", "S-meter: S9 = 50 μV sobre 50 Ω en HF (escala en microvoltios)",
  [En HF, una señal de 25 μV sobre los 50 Ω de la entrada de antena, en un receptor que sigue el convenio de la IARU, marca aproximadamente:],
  ([S9], [S7], [S6], [S8],),
  sol: [El convenio fija S9 = 50 μV sobre 50 Ω en HF, y cada punto S son 6 dB, es decir, la mitad de tensión. 25 μV es la mitad de 50 μV, luego un punto menos: S8. S7 corresponde a unos 12,5 μV y S6, a unos 6,3 μV.], tema: "T8")
#pq(8, 1, 27, "b", "estúdialo en: simulacros de estudio 8·1·27 · libro: T9.13", "Emisiones fuera de banda: inmediatamente exteriores a la anchura necesaria, por la modulación",
  [Un colega te avisa de que tu emisión de BLU salpica a los canales contiguos al tuyo, pero no se te oye en otras bandas. ¿Qué tipo de emisión no deseada es y cómo se corrige?],
  ([bloqueo del receptor del colega; se corrige con un filtro en su entrada], [una emisión fuera de banda por sobremodulación; se corrige bajando la ganancia del micrófono y la excitación], [intermodulación en una unión oxidada; se corrige reparando la unión], [armónicos; se corrigen con un filtro paso bajo a la salida],),
  sol: [Las emisiones fuera de banda son las inmediatamente exteriores a la anchura de banda necesaria, producidas por el propio proceso de modulación: una BLU con el micrófono demasiado alto se ensancha y salpica a los canales vecinos. Los armónicos caerían en múltiplos de la frecuencia, en otras bandas, y no junto al canal.], tema: "T9")
#pq(8, 1, 28, "b", "estúdialo en: simulacros de estudio 5·1·28 · libro: F-T9.1", "Bloqueo o desensibilización: un campo intenso satura la entrada aunque esté sintonizado lejos",
  [En un caso de bloqueo de un receptor cercano a tu estación, ¿qué parte de tu emisión lo provoca?],
  ([los productos de intermodulación de tu etapa final], [la señal fundamental, por su intensidad, aunque esté limpia], [los armónicos de tu transmisor], [las emisiones fuera de banda de tu modulación],),
  sol: [El bloqueo lo causa la fundamental, la señal que tienes derecho a emitir: su campo intenso satura la primera etapa del receptor aunque esté sintonizado lejos. Por eso un filtro en tu transmisor no lo arregla. Armónicos, emisiones fuera de banda e intermodulación son otros mecanismos, que producen señales en otras frecuencias.], tema: "T9")
#pq(8, 1, 29, "c", "estúdialo en: simulacros de estudio 8·1·30 · libro: T10.22", "La toma de tierra debe tener la menor resistencia posible",
  [Con una misma fuga de 30 mA, una toma de tierra de 1000 Ω deja el chasis de un equipo, frente a una de 100 Ω, a:],
  ([3 V en lugar de 30 V], [la misma tensión, porque la fuga es la misma], [30 V en lugar de 3 V], [0 V en los dos casos, porque el chasis está a tierra],),
  sol: [La tensión del chasis es $V = R_T dot I$: con 100 Ω, 100 · 0,03 = 3 V; con 1000 Ω, 30 V. Cuanto mayor es la resistencia de tierra, más tensión queda en el chasis y peor se deriva la fuga; por eso la toma de tierra debe tener la menor resistencia posible. Estar «a tierra» no garantiza 0 V si la tierra es mala.], tema: "T10")
#pq(8, 1, 30, "c", "estúdialo en: simulacros de estudio 10·1·29 · libro: C-T10.1", "Ante una tormenta: desconectar la antena (y el equipo de la red), nunca la toma de tierra",
  [Ante una tormenta próxima, después de desconectar la antena del transceptor, con la toma de tierra del mástil hay que:],
  ([unirla al neutro de la red], [desconectarla, para que el rayo no busque la instalación], [mantenerla conectada, porque es el camino por el que debe descargarse el rayo], [intercalar en ella un fusible],),
  sol: [Ante una tormenta se desconectan las bajadas de antena del equipo y conviene desenchufar este de la red, pero la toma de tierra del mástil y de los soportes nunca se desconecta: es la vía por la que el rayo debe llegar al suelo sin pasar por la casa. Tampoco puede llevar fusible ni unirse al neutro.], tema: "T10")
#fin-prueba()
#prueba(8, 2)
#pq(8, 2, 1, "d", "estúdialo en: simulacros de estudio 2·2·1 · libro: C-R1.1", "Deletreo de distintivo AN6BL: N November (no «Noviembre»), B Bravo, L Lima, 6 Six",
  [¿Cuál es el deletreo correcto del distintivo `EA6LNB`?],
  ([Echo Alfa Six Luis Nancy Baker], [Echo Alfa Sierra Lima November Bravo], [Echo Alfa Seis Lima Noviembre Bravo], [Echo Alfa Six Lima November Bravo],),
  sol: [L es Lima, N es November y B es Bravo, y la cifra va en inglés: Six. «Seis» y «Noviembre» son traducciones al castellano; Luis, Nancy y Baker pertenecen a alfabetos antiguos, y Sierra es la letra S, no la cifra 6.], tema: "R1")
#pq(8, 2, 2, "c", "estúdialo en: simulacros de estudio 6·2·3, 12·2·2 · libro: C-R2.1, R2.24", "QRK inteligibilidad, QSA intensidad, QRI tono (las tres valoraciones de la señal)",
  [Quieres preguntar en CW por la calidad del tono de tu emisión. ¿Qué grupo usas?],
  ([`QSA?`], [`QRH?`], [`QRI?`], [`QRK?`],),
  sol: [El tono de la emisión es `QRI`. `QRK` es la inteligibilidad y `QSA` la intensidad: son las otras dos valoraciones de la señal. `QRH` se refiere a la variación de la frecuencia, no al tono.], tema: "R2")
#pq(8, 2, 3, "b", "estúdialo en: simulacros de estudio 8·2·3, 12·2·3 · libro: R2.31, R2.30", "QSL acuse de recibo frente a QSO comunicado entre dos estaciones",
  [Al final de un contacto en CW recibes «`TNX QSO QSL VIA BURO`». ¿Qué te dice tu corresponsal?],
  ([gracias por la confirmación; el comunicado se repetirá por el buró], [gracias por el comunicado; la tarjeta que lo confirma irá por el buró], [gracias por cambiar de frecuencia; la tarjeta irá por el buró], [gracias por el acuse de recibo; el próximo comunicado será por el buró],),
  sol: [`QSO` es el comunicado entre dos estaciones y `QSL` el acuse de recibo, de donde viene la tarjeta QSL que confirma el contacto. Las demás intercambian los dos grupos o meten un cambio de frecuencia, que sería `QSY`.], tema: "R2")
#pq(8, 2, 4, "d", "estúdialo en: simulacros de estudio 13·2·4 · libro: R2.19", "QSK puedo oírle entre mis señales (break-in)",
  [En CW trabajas de modo que oyes a tu corresponsal entre tus propias señales y él puede interrumpirte en cualquier momento. ¿Qué grupo lo indica?],
  ([`QRV`], [`QRL`], [`QSV`], [`QSK`],),
  sol: [`QSK` es «puedo oírle entre mis señales», el trabajo en break-in. `QRL` dice que la frecuencia está ocupada, `QRV` que se está dispuesto y `QSV` pide una serie de letras V.], tema: "R2")
#pq(8, 2, 5, "a", "estúdialo en: simulacros de estudio 2·2·4 · libro: R3.14", "SK fin del contacto",
  [Habéis terminado el intercambio y quieres indicar en telegrafía que el contacto queda cerrado, aunque vas a seguir en la frecuencia llamando `CQ`. ¿Qué transmites al final?],
  ([`SK`], [`K`], [`AR`], [`CL`],),
  sol: [`SK` señala el fin del contacto. `CL` añadiría que apagas la estación, y no es el caso porque sigues llamando; `AR` solo cierra la transmisión en curso y `K` invita al otro a transmitir.], tema: "R3")
#pq(8, 2, 6, "c", "estúdialo en: simulacros de estudio 12·2·5 · libro: R3.16", "73 saludos cordiales y 88 besos",
  [Para despedirte de un colega con «saludos cordiales», ¿qué transmites?],
  ([`599`], [`SK`], [`73`], [`88`],),
  sol: [`73` son los saludos cordiales, la despedida universal. `88` (besos) se reserva para despedidas afectuosas; `599` es un informe de señal y `SK` cierra el contacto, pero no saluda.], tema: "R3")
#pq(8, 2, 7, "d", "estúdialo en: simulacros de estudio 8·2·6", "CUL hasta luego (see you later)",
  [Te despides de un colega con quien volverás a hablar pronto y quieres decirle «hasta luego». Transmites:],
  ([`GL`], [`CL`], [`SK`], [`CUL`],),
  sol: [`CUL` (\_see you later\_) es «hasta luego». `CL` se le parece, pero anuncia el cierre de la estación; `GL` es «buena suerte» y `SK` cierra el contacto sin despedirse.], tema: "R3")
#pq(8, 2, 8, "a", "estúdialo en: simulacros de estudio 9·2·7 · libro: R4.2", "Urgencia en radiotelefonía: PAN PAN (tres veces)",
  [Tu embarcación tiene el motor averiado y necesitas remolque, pero nadie corre peligro inmediato. En radiotelefonía, la llamada empieza con:],
  ([«Pan Pan», tres veces], [«Sécurité», tres veces], [`XXX`, tres veces], [«Mayday», tres veces],),
  sol: [Un problema serio sin peligro inminente es urgencia: «Pan Pan» tres veces. «Mayday» se reserva para el peligro grave e inminente. `XXX` también es urgencia, pero es la señal telegráfica, no la de fonía.], tema: "R4")
#pq(8, 2, 9, "c", "estúdialo en: simulacros de estudio 1·2·8 · libro: R4.13", "Peligro grave e inminente: se puede usar cualquier medio y frecuencia",
  [Sufres un accidente grave en la montaña, sin cobertura de teléfono móvil, y solo llevas tu transceptor. ¿Puedes pedir auxilio fuera de las bandas de aficionado?],
  ([Solo en la banda de 2 m], [Solo si antes lo notificas a la Jefatura Provincial], [Sí: ante un peligro grave e inminente puedes usar cualquier medio y frecuencia a tu alcance], [No: solo puedes emitir en las bandas de tu autorización],),
  sol: [Ante un peligro grave e inminente, la vida humana está por encima de los límites de la autorización: se puede usar cualquier medio y frecuencia. Fuera de ese supuesto rige la regla general de emitir solo en las bandas autorizadas, que es la trampa de la primera opción.], tema: "R4")
#pq(8, 2, 10, "b", "estúdialo en: simulacros de estudio 4·2·10 · libro: F-R5.7", "Qué es el distintivo: señal de identificación que identifica al titular desde cualquier punto del territorio (no al equipo ni al domicilio)",
  [EA3XYZ, con domicilio en Barcelona, se va de viaje y emite con su equipo portátil desde Cádiz. Para identificarse debe usar:],
  ([un distintivo nuevo con la cifra 7, que debe solicitar para el viaje], [su propio distintivo, EA3XYZ, que lo identifica como titular en cualquier punto del territorio nacional], [el distintivo que figure en el certificado del equipo, porque el distintivo va asociado al transmisor], [ninguno, porque su distintivo solo es válido en el domicilio que consta en la autorización],),
  sol: [El distintivo va asociado a la autorización y no al equipo ni al domicilio: identifica a su titular en las emisiones que efectúe desde cualquier punto del territorio nacional (art. 27). Por eso no hace falta pedir otro con la cifra 7; como mucho, puede añadir de forma opcional /P o el distrito desde el que emite.], tema: "R5")
#pq(8, 2, 11, "b", "estúdialo en: simulacros de estudio 10·2·11 · libro: F-R5.13", "Prefijos de otros países europeos: Alemania DL, Italia I, Reino Unido G/M",
  [¿Cuál de estas parejas país–prefijo es correcta?],
  ([Malta: M], [Italia: I], [Dinamarca: DL], [Irlanda: I],),
  sol: [La letra I sola es el prefijo de Italia. DL es de Alemania (Dinamarca usa OZ), Irlanda usa EI y Malta 9H: el prefijo no sigue la inicial del nombre del país, y M es del Reino Unido.], tema: "R5")
#pq(8, 2, 12, "b", "estúdialo en: simulacros de estudio 1·2·13, 8·2·13 · libro: C-R5.19, C-R5.2", "Sufijos excluidos: DDD, PAN, SOS, TTT, XXX y la serie QAA–QZZ",
  [¿Cuál de estos distintivos no podría asignarse nunca?],
  ([EA4SOR], [EA4QTH], [EA4DDE], [EA4TTX],),
  sol: [Toda la serie QAA–QZZ está excluida, para que ningún sufijo se confunda con un código Q, y QTH lo es. Los otros sufijos se parecen a DDD, SOS o TTT, pero no coinciden con ellos y se asignan cuando les llega el turno.], tema: "R5")
#pq(8, 2, 13, "a", "estúdialo en: simulacros de estudio 5·2·15, 9·2·15 · libro: R6.7, C-R6.2", "Repetidores de 2 m: entrada 145,000–145,1875 MHz, salida 600 kHz más arriba",
  [Un repetidor de 2 m transmite (salida) en 145,700 MHz. ¿En qué frecuencia debes emitir para acceder a él?],
  ([145,100 MHz], [146,300 MHz], [145,700 MHz], [144,100 MHz],),
  sol: [En 2 m la salida está 600 kHz por encima de la entrada, así que la entrada es 145,700 − 0,600 = 145,100 MHz, dentro del segmento 145,000–145,1875 MHz. Sumar en vez de restar da 146,300 MHz, fuera de la banda, y restar 1,6 MHz (el desplazamiento de 70 cm) da 144,100 MHz.], tema: "R6")
#pq(8, 2, 14, "c", "estúdialo en: simulacros de estudio 9·2·16", "Balizas en 2 m: segmento 144,400–144,491 MHz",
  [Quieres escuchar balizas de 2 m para comprobar si hay propagación. ¿En qué tramo debes buscarlas?],
  ([144,150–144,400 MHz], [145,806–146,000 MHz], [144,400–144,491 MHz], [145,000–145,1875 MHz],),
  sol: [El plan de la IARU para la Región 1 reserva a las balizas de 2 m el tramo 144,400–144,491 MHz, justo encima del de SSB y telegrafía (144,150–144,400 MHz). 145,000–145,1875 MHz son entradas de repetidores y 145,806–146,000 MHz, satélites.], tema: "R6")
#pq(8, 2, 15, "d", "estúdialo en: simulacros de estudio 6·2·15 · libro: R7.11", "Contenido: temas del servicio y observaciones de carácter personal",
  [Durante un QSO, tu corresponsal te cuenta qué tal le ha ido el día y describe la antena que usa. Ese contenido:],
  ([solo se admite en las frecuencias de llamada], [no está permitido, porque solo pueden tratarse temas técnicos], [debe transmitirse codificado, por tratarse de información personal], [es admisible, porque se ajusta a temas del servicio y observaciones de carácter personal],),
  sol: [Las transmisiones se limitan a temas relacionados con el servicio de aficionados y a observaciones de carácter personal, así que hablar del día y de la antena es correcto. No se exige que todo sea técnico, y codificar está prohibido: se transmite en lenguaje claro.], tema: "R7")
#pq(8, 2, 16, "a", "estúdialo en: simulacros de estudio 7·2·16 · libro: R7.17", "Antenas: garantizar el derecho de terceros a no sufrir daños",
  [Para garantizar el derecho de terceros a no sufrir daños por la antena exterior de su estación fija, al titular se le exige:],
  ([un seguro de responsabilidad civil], [la firma de conformidad de todos los vecinos del edificio], [una garantía del fabricante de la antena que cubra los daños], [ser socio de una asociación de radioaficionados],),
  sol: [La instalación no puede crear riesgos para los demás, y por eso se exige un seguro de responsabilidad civil para las antenas; sin él, la licencia de la estación fija puede cancelarse. La responsabilidad es del titular, no del fabricante, y no hace falta ser socio de ninguna asociación.], tema: "R7")
#pq(8, 2, 17, "d", "estúdialo en: simulacros de estudio 13·2·17 · libro: R8.41", "Radiobaliza: desatendida para estudios de propagación que emite señales de identificación",
  [Una asociación de radioaficionados instala una radiobaliza principalmente para:],
  ([servir de referencia de navegación a barcos y aeronaves], [enlazar entre sí repetidoras digitales], [ampliar el alcance de las comunicaciones retransmitiendo las señales que recibe], [facilitar estudios de propagación, mediante la emisión automática de señales de identificación],),
  sol: [El anexo I define la radiobaliza como la estación automática desatendida de radioaficionado destinada a realizar estudios de propagación, cuyo funcionamiento se basa en la emisión automática de señales de identificación. Retransmitir para ampliar el alcance es lo propio del repetidor, y enlazar repetidoras digitales, de la repetidora de portadora o nodo. Las radioayudas a la navegación pertenecen a otros servicios, no al de aficionados.], tema: "R8")
#pq(8, 2, 18, "c", "estúdialo en: simulacros de estudio 7·2·18 · libro: F-R8.68", "Prohibido codificar para ocultar el significado, salvo el mando de estaciones espaciales",
  [¿En cuál de estos casos se permite codificar una transmisión de aficionado para ocultar su significado?],
  ([en el intercambio de números de serie durante un concurso], [en una red de emergencia que transmite datos personales de los afectados], [en las señales de control que una estación de mando terrestre envía a una estación espacial del Servicio de Aficionados por Satélite], [en las comunicaciones internas de un radioclub sobre la gestión de su repetidor],),
  sol: [El art. 30.2 prohíbe codificar las transmisiones de aficionado para ocultar su significado, con una única excepción: las señales de control entre estaciones de mando terrestres y estaciones espaciales del Servicio de Aficionados por Satélite. Ni la emergencia, aunque se trate de datos sensibles, ni los asuntos de un radioclub, ni los concursos autorizan a cifrar. El tráfico de terceros en emergencias es otra regla distinta (art. 30.3).], tema: "R8")
#pq(8, 2, 19, "a", "estúdialo en: simulacros de estudio 4·2·20 · libro: C-R8.26", "Licencia CEPT: todas las bandas atribuidas al servicio en el país visitado (no las del país de origen)",
  [Operas temporalmente con licencia CEPT en un país donde una banda que en España tienes autorizada no está atribuida a los aficionados. ¿Puedes usarla allí?],
  ([No: solo puedes usar las bandas del servicio de aficionados autorizadas en el país donde operas], [Sí, siempre que no causes interferencias], [Sí, porque la licencia CEPT te permite usar las bandas de tu país], [Sí, si reduces la potencia al 50 %],),
  sol: [El art. 14.b permite usar con la licencia CEPT todas las bandas atribuidas al servicio de aficionados que estén autorizadas, y en sus condiciones, en el país donde se opera. Si allí una banda no lo está, no se puede usar aunque en España sí. Rebajar la potencia o no interferir no cambia nada: el 50 % es la regla de las bandas secundarias españolas.], tema: "R8")
#pq(8, 2, 20, "b", "estúdialo en: simulacros de estudio 3·2·20 · libro: R8.51", "Se puede tener distintivo (autorización) sin licencia de estación; la licencia solo la necesita la estación fija",
  [¿Cuál de estas situaciones NO es posible según la reglamentación vigente?],
  ([Tener autorización y distintivo de llamada sin tener licencia de estación], [Tener licencia de estación fija sin ser titular de una autorización de radioaficionado], [Operar una estación móvil sin licencia de estación], [Tener una única licencia de estación fija que ampare varios equipos],),
  sol: [La licencia de estación fija está asociada a la autorización de su titular, así que sin autorización no puede haber licencia. Lo contrario sí es posible: se puede tener distintivo sin licencia, porque la licencia solo la necesita la estación fija. Las móviles y portátiles no requieren licencia, y una misma licencia puede amparar varios equipos.], tema: "R8")
#pq(8, 2, 21, "a", "estúdialo en: simulacros de estudio 1·2·22 · libro: F-R8.26", "Equipo de construcción propia: presentación optativa en la Jefatura con memoria (diagrama de bloques, esquemas)",
  [Un transmisor casero que su autor llevó voluntariamente a la Jefatura Provincial supera allí las pruebas de comprobación del anexo I. ¿Qué recibe?],
  ([Una autorización individual que acredita su correcto funcionamiento], [Una autorización especial experimental de 18 meses], [La licencia de estación fija de tu domicilio], [El marcado CE, que te permite además comercializarlo],),
  sol: [El art. 5.6 permite presentar optativamente el equipo casero en la Jefatura con una memoria (diagrama de bloques, esquemas y descripción del funcionamiento). Si supera las pruebas, recibe una autorización individual acreditativa de su correcto funcionamiento. No equivale al marcado CE ni a la licencia de estación, y nada tiene que ver con las autorizaciones experimentales.], tema: "R8")
#pq(8, 2, 22, "d", "estúdialo en: simulacros de estudio 4·2·24 · libro: R8.15", "Derecho a instalar la antena en el exterior: legitimación para usar el edificio + autorización administrativa",
  [Un radioaficionado vive de alquiler en un piso y quiere instalar su antena en la azotea del edificio. Según la Ley 19/1983, necesita:],
  ([solo su autorización de radioaficionado, que ya le da derecho a instalar antenas], [el acuerdo unánime de la junta de propietarios], [ser propietario de su vivienda: un inquilino no puede instalar antenas], [estar legitimado para usar el edificio, en todo o en parte, y obtener la autorización administrativa reglamentaria],),
  sol: [El derecho a instalar antenas en el exterior exige dos cosas: legitimación para usar el inmueble (propiedad, alquiler con permiso…) y la autorización administrativa. La autorización de radioaficionado no basta por sí sola, la comunidad no autoriza ni prohíbe, y ser inquilino no excluye el derecho.], tema: "R8")
#pq(8, 2, 23, "c", "estúdialo en: simulacros de estudio 2·2·23 · libro: F-R8.75", "Obras de indudable urgencia: desmontaje sin trámites, comunicándolo inmediatamente al titular",
  [Al llegar a casa descubres que la comunidad ha desmontado tu antena por unas obras de indudable urgencia, sin preaviso, y que te lo comunicó en ese mismo momento. Según el Real Decreto 2623/1986, la actuación de la comunidad:],
  ([no es correcta: solo el titular o un instalador inscrito pueden desmontar la antena], [solo es correcta si la junta de propietarios lo había aprobado antes por mayoría simple], [es correcta: en obras de indudable urgencia puede desmontar sin trámites ni plazos, comunicándolo inmediatamente al titular], [no es correcta: incluso en caso de urgencia debía avisarte con un mes de antelación],),
  sol: [En obras ordinarias la propiedad avisa con un mes de antelación; si son de indudable urgencia, puede desmontar sin esos trámites ni plazos, pero debe comunicarlo inmediatamente al titular (art. 7). La comunidad hizo justo eso. La urgencia exime del plazo, no del aviso.], tema: "R8")
#pq(8, 2, 24, "b", "estúdialo en: simulacros de estudio 5·2·26 · libro: F-R8.3", "Líneas de transmisión a ≥ 10 cm de conductos y canalizaciones del edificio",
  [Bajas el cable coaxial de tu antena por un patinillo, junto a una tubería del edificio. Según el Real Decreto 2623/1986, el cable debe:],
  ([guardar al menos 5 cm y sujetarse a la propia tubería con bridas], [guardar al menos 10 cm de separación y fijarse a intervalos apropiados], [guardar al menos 10 cm y colgar libremente en vertical para no rozar], [guardar al menos 3 m, como la altura libre sobre el plano de paso],),
  sol: [Las líneas de transmisión y los cables de alimentación deben distar al menos 10 cm de cualquier conducto o canalización de servicios del edificio (art. 18.1). Además, no se admite su tendido vertical libre: se fijan a intervalos apropiados. Los 3 m son la altura libre sobre el plano de paso, otra regla.], tema: "R8")
#pq(8, 2, 25, "b", "estúdialo en: simulacros de estudio 8·2·25 · libro: R8.45", "Uso portable: notificar con 5 días; usos no continuados de hasta 15 días naturales sin notificación",
  [Vas a utilizar tu estación de forma continuada durante un mes en una casa rural, lejos de tu domicilio habitual. ¿Qué debes hacer?],
  ([nada, porque tu estación fija ya tiene licencia], [notificarlo a la Jefatura Provincial con al menos cinco días de antelación], [notificarlo a la Jefatura Provincial con al menos quince días de antelación], [solicitar a la Jefatura Provincial un distintivo temporal para ese mes],),
  sol: [El uso portable no necesita autorización, pero debe notificarse a la Jefatura Provincial con al menos cinco días de antelación. Solo quedan exentos los usos no continuados de hasta 15 días naturales consecutivos, y un mes seguido no lo es. Los quince días son el límite de esa exención, no el plazo de preaviso, y el uso portable no exige distintivo temporal.], tema: "R8")
#pq(8, 2, 26, "a", "estúdialo en: simulacros de estudio 2·2·26 · libro: C-R8.37", "Estación móvil: en movimiento o detenida en puntos no determinados",
  [Llevas un transceptor instalado en tu coche y emites desde un área de descanso de la autovía, con el vehículo parado. Según el anexo I, esa estación es:],
  ([móvil, porque la estación móvil también lo es mientras está detenida en puntos no determinados], [portable, porque no está en movimiento], [temporal, porque solo emite durante la parada], [fija, mientras el vehículo permanezca detenido],),
  sol: [El anexo I define la estación móvil como la destinada a ser utilizada en movimiento o mientras esté detenida en puntos no determinados: el área de descanso es uno de esos puntos. Pararse no la convierte en portable, que es una estación fija usada temporalmente en una ubicación determinada distinta de la habitual. La temporal se reserva a concursos, expediciones, demostraciones y eventos.], tema: "R8")
#pq(8, 2, 27, "d", "estúdialo en: simulacros de estudio 13·2·27 · libro: R8.33", "Repetidor: su objetivo es ampliar el alcance de las comunicaciones",
  [Un repetidor de radioaficionado amplía el alcance de las comunicaciones porque:],
  ([emite automáticamente señales de identificación para estudiar la propagación], [aumenta la potencia de los equipos de los usuarios que lo utilizan], [sustituye a las estaciones fijas de su zona de cobertura], [recibe las señales en una frecuencia y las retransmite en otra desde un emplazamiento elevado],),
  sol: [El objetivo del repetidor es ampliar el alcance, y lo logra recibiendo en una frecuencia y retransmitiendo en otra desde un lugar elevado, de modo que dos estaciones que no se oyen directamente pueden comunicarse. No toca la potencia de los equipos de los usuarios ni sustituye a sus estaciones. Emitir señales de identificación para estudios de propagación es la función de la radiobaliza.], tema: "R8")
#pq(8, 2, 28, "c", "estúdialo en: simulacros de estudio 5·2·28 · libro: C-R9.3", "Ley 11/2022: art. 106 muy graves, 107 graves, 108 leves",
  [Si una resolución sancionadora cita como precepto infringido el art. 108 de la Ley 11/2022, la infracción es:],
  ([muy grave], [grave], [leve], [ninguna: el art. 108 fija las multas, no las infracciones],),
  sol: [En la Ley 11/2022, el art. 105 clasifica las infracciones y los tres siguientes las tipifican de más a menos grave: 106, muy graves; 107, graves; 108, leves. A mayor gravedad, menor número. Las multas no están en el 108 sino en el 109.], tema: "R9")
#pq(8, 2, 29, "d", "estúdialo en: simulacros de estudio 3·2·28 · libro: F-R9.12", "Leve: emisión no autorizada, salvo que sea grave o muy grave",
  [Producir una emisión radioeléctrica no autorizada es, como regla, infracción leve. ¿En cuál de estos casos pasa a ser muy grave según la Ley 11/2022?],
  ([si la realiza un menor de edad], [si produce interferencias sin pretenderlo], [si se efectúa con un equipo de construcción propia], [si vulnera el Cuadro Nacional de Atribución de Frecuencias],),
  sol: [El art. 108.1 hace leve la emisión no autorizada «salvo que deba considerarse grave o muy grave». Es muy grave si vulnera el CNAF o el plan de utilización del espectro (art. 106.6). Si produce interferencias sin intención, pasa a grave (art. 107.6), no a muy grave; solo las deliberadas son muy graves. El equipo de construcción propia y la edad no cambian el grado.], tema: "R9")
#pq(8, 2, 30, "b", "estúdialo en: simulacros de estudio 12·2·29 · libro: R9.29", "Reiteración: 2 o más sanciones firmes del mismo tipo en 3 años; la leve pasa a grave",
  [Un radioaficionado tiene dos sanciones firmes por infracciones leves del mismo tipo, impuestas en los últimos dos años. Según la Ley 11/2022, ese incumplimiento reiterado:],
  ([pasa directamente a muy grave], [se considera infracción grave], [solo tiene consecuencias si las sanciones se impusieron en el mismo año], [sigue siendo leve: cada infracción se valora por separado],),
  sol: [Hay incumplimiento reiterado cuando se han impuesto sanciones firmes por dos o más infracciones del mismo tipo en un período de tres años (art. 109.6), y la reiteración de leves es infracción grave (art. 107.44). Dos años están dentro de esos tres. Sube un escalón, a grave; no salta a muy grave.], tema: "R9")
#fin-prueba()
#soluciones-simulacro(8)

// ======================================================================
#simulacro(9)
#prueba(9, 1)
#pq(9, 1, 1, "b", "estúdialo en: simulacros de estudio 6·1·2 · libro: F-T1.50", "Ley de Kirchhoff de las corrientes (nudos)",
  [¿En qué principio físico se basa la ley de los nudos de Kirchhoff?],
  ([en la ley de Coulomb entre las cargas que llegan al nudo], [en la conservación de la carga eléctrica, que no se acumula en el nudo], [en la conservación de la energía a lo largo de una malla cerrada], [en la ley de Ohm aplicada a cada una de las ramas],),
  sol: [La carga no se crea, no se destruye y no se acumula en un nudo: toda la que llega por unas ramas tiene que salir por otras, y por eso la suma de las corrientes entrantes iguala a la de las salientes. La conservación de la energía por unidad de carga es el fundamento de la otra ley, la de las tensiones o de las mallas.], tema: "T1")
#pq(9, 1, 2, "a", "estúdialo en: simulacros de estudio 11·1·1 · libro: T1.17", "Longitud de onda: λ = c / f, λ (m) ≈ 300 / f (MHz)",
  [Una emisión con una longitud de onda de 15 m tiene una frecuencia de:],
  ([20 MHz], [200 MHz], [2 MHz], [4500 MHz],),
  sol: [Despejando de $lambda ("m") approx 300 slash f ("MHz")$: $f approx 300 slash 15 = 20$ MHz. Los 4500 MHz salen de multiplicar 300 por 15 en lugar de dividir, y 2 y 200 MHz son errores de un factor 10.], tema: "T1")
#pq(9, 1, 3, "d", "estúdialo en: simulacros de estudio 6·1·3 · libro: C-T1.15", "Frecuencia: ciclos por segundo (Hz), la característica de la corriente alterna",
  [Una corriente alterna completa 3000 ciclos en 0,1 s. Su frecuencia es de:],
  ([300 Hz], [3 kHz], [30 Hz], [30 kHz],),
  sol: [La frecuencia es el número de ciclos por segundo: $3000 slash 0","1 = 30.000$ Hz = 30 kHz. Los 300 Hz resultan de multiplicar por 0,1 en lugar de dividir, y los 3 kHz toman los 3000 ciclos como si se hubieran contado en un segundo.], tema: "T1")
#pq(9, 1, 4, "a", "estúdialo en: simulacros de estudio 4·1·2, 11·1·2 · libro: T1.39, C-T1.23", "Valor eficaz: definición por el efecto calorífico; la tensión de red se da en eficaz",
  [El valor eficaz de una tensión alterna se obtiene matemáticamente:],
  ([elevando al cuadrado sus valores instantáneos, promediándolos en un período y extrayendo la raíz cuadrada], [promediando sus valores instantáneos a lo largo de un período], [dividiendo entre dos su valor de pico a pico], [promediando los valores instantáneos de una sola semionda],),
  sol: [Como la potencia en una resistencia va con $v^2$, el valor que calienta igual es el que tiene el mismo cuadrado medio: $V_"ef" = sqrt("media de" v^2)$, que en una sinusoide vale $V_0 slash sqrt(2)$. La media de todo el período es cero en una sinusoide, la de una semionda es el valor medio ($0","637 V_0$) y la mitad del pico a pico es el valor de pico.], tema: "T1")
#pq(9, 1, 5, "c", "estúdialo en: simulacros de estudio 1·1·4, 6·1·5 · libro: T1.30, F-T1.37", "Referencias de decibelios: ×2 = +3 dB, ×4 = +6 dB, ×10 = +10 dB, ÷2 = −3 dB",
  [Subir la potencia de un transmisor de 25 W a 100 W supone una mejora de:],
  ([3 dB], [12 dB], [6 dB], [4 dB],),
  sol: [Pasar de 25 W a 100 W es multiplicar por 4, y ×4 = ×2 × 2, es decir, 3 + 3 = 6 dB. Los 3 dB corresponden a duplicar; los 4 dB confunden el factor 4 con decibelios, y los 12 dB serían multiplicar por 16.], tema: "T1")
#pq(9, 1, 6, "d", "estúdialo en: simulacros de estudio 5·1·6 · libro: T2.56", "Una resistencia fija se especifica por valor, potencia de disipación y tolerancia",
  [Vas a sustituir una resistencia quemada de un equipo. Además de su valor óhmico, ¿qué dos datos debe respetar la nueva resistencia?],
  ([la capacidad parásita y la tensión de ruptura inversa], [el color del cuerpo y la ganancia de corriente], [la frecuencia de trabajo y la polaridad], [la potencia que puede disipar y su tolerancia],),
  sol: [Una resistencia fija queda definida por su valor, la potencia que puede disipar sin quemarse ($P = I^2 R$) y su tolerancia. Una pieza del mismo valor pero de menos potencia volvería a quemarse. La polaridad, la tensión de ruptura inversa o la ganancia son propias de diodos, electrolíticos y transistores, no de una resistencia.], tema: "T2")
#pq(9, 1, 7, "b", "estúdialo en: simulacros de estudio 6·1·6 · libro: T2.50", "C = εS/d: la capacidad depende de la superficie, la separación y el dieléctrico",
  [En un condensador plano se duplica la superficie de las placas enfrentadas y, a la vez, se duplica la separación entre ellas. Su capacidad:],
  ([se reduce a la mitad], [no varía], [se cuadruplica], [se duplica],),
  sol: [Según $C = epsilon S / d$, duplicar la superficie duplica la capacidad y duplicar la separación la reduce a la mitad: los dos efectos se compensan. Se cuadruplicaría si la separación se redujera a la mitad en vez de duplicarse.], tema: "T2")
#pq(9, 1, 8, "c", "estúdialo en: simulacros de estudio 3·1·8 · libro: T2.32", "Ganancia de corriente β = I_C/I_B",
  [Midiendo un transistor bipolar en funcionamiento obtienes 60 μA de base y 12 mA de colector. ¿Cuánto vale su ganancia de corriente $beta$?],
  ([0,005], [20], [200], [2000],),
  sol: [$beta = I_C / I_B = 12 "mA" / 60 "μA" = 0","012 / 0","00006 = 200$. Dividir al revés da 0,005. Las otras dos cifras son errores al pasar los microamperios a miliamperios.], tema: "T2")
#pq(9, 1, 9, "b", "estúdialo en: simulacros de estudio 3·1·9 · libro: C-T2.21", "Símbolos de transistores: bipolar frente a FET",
  [En un esquema aparece un transistor cuya puerta se dibuja separada del canal por un pequeño hueco, sin tocarlo. Se trata de:],
  ([un bipolar PNP], [un MOSFET, transistor de efecto de campo], [un tríodo de vacío], [un bipolar NPN],),
  sol: [En el MOSFET la puerta está aislada del canal por una capa de óxido y se dibuja separada; es el símbolo de FET que usa el examen. En el bipolar, la base toca emisor y colector y hay una flecha en el emisor; el tríodo se dibuja dentro de una ampolla.], tema: "T2")
#pq(9, 1, 10, "d", "estúdialo en: simulacros de estudio 10·1·10 · libro: T3.44", "Resistencias en paralelo: tensión común; la corriente de cada rama es inversamente proporcional a R y la total es la suma (Kirchhoff)",
  [Una resistencia de 2 kΩ y otra de 6 kΩ están conectadas en paralelo a una fuente. Por la de 2 kΩ circulan 6 mA. ¿Qué corriente entrega la fuente?],
  ([12 mA], [6 mA], [24 mA], [8 mA],),
  sol: [En paralelo la tensión es común: $V = 6 "mA" dot 2 "kΩ" = 12$ V, y por la de 6 kΩ pasan $12 slash 6 = 2$ mA, la tercera parte, porque la corriente de cada rama es inversamente proporcional a su resistencia. La total es la suma (primera ley de Kirchhoff): 8 mA. Los 12 mA suponen la misma corriente en las dos ramas y los 24 mA, una corriente proporcional a $R$ (18 mA por la de 6 kΩ).], tema: "T3")
#pq(9, 1, 11, "c", "estúdialo en: simulacros de estudio 13·1·11 · libro: F-T3.29", "Filtros FIR (sin realimentación, respuesta finita) e IIR (realimentan la salida, respuesta infinita)",
  [Un filtro digital calcula cada muestra de salida como la media de las ocho últimas muestras de entrada, sin utilizar ninguna salida anterior. Se trata de un filtro:],
  ([IIR, porque combina varias muestras de entrada], [FIR, porque realimenta su salida hacia la entrada], [FIR, cuya respuesta a un impulso desaparece al cabo de ocho muestras], [IIR, cuya respuesta a un impulso se prolonga indefinidamente],),
  sol: [Combina un número finito de muestras de entrada sin realimentar la salida: es un FIR (respuesta finita al impulso), y un impulso deja de notarse cuando sale de esas ocho muestras. Que combine varias muestras no lo hace IIR; lo que define a un IIR es la realimentación de sus propias salidas, que este filtro no tiene.], tema: "T3")
#pq(9, 1, 12, "a", "estúdialo en: simulacros de estudio 7·1·12 · libro: F-T3.17", "Limitador delante del discriminador: recorta las variaciones de amplitud (ruido)",
  [En un receptor de FM, la chispa de un motor cercano produce picos de amplitud en la señal de FI. El bloque que impide que esos picos se oigan es:],
  ([el limitador situado antes del discriminador], [el mezclador], [el detector de envolvente], [el oscilador de batido (BFO)],),
  sol: [En FM la información va en la frecuencia, y el ruido eléctrico altera sobre todo la amplitud. El limitador recorta la amplitud a un valor fijo antes del discriminador, de modo que este solo ve variaciones de frecuencia. El BFO sirve para SSB y CW, y el detector de envolvente justamente leería esos picos de amplitud como audio.], tema: "T3")
#pq(9, 1, 13, "d", "estúdialo en: simulacros de estudio 9·1·13", "Condición de oscilación (Barkhausen): realimentación positiva, ganancia de lazo que compensa pérdidas y fase de 360°",
  [En un oscilador cuyo transistor está montado en emisor común, que invierte la fase 180°, la red de realimentación debe aportar un desfase de:],
  ([90°], [360°], [0°], [180°],),
  sol: [La condición de Barkhausen exige que la señal dé la vuelta al lazo con una fase total de 360° y con ganancia suficiente para compensar las pérdidas. Si el amplificador ya invierte 180°, la red debe invertir otros 180°, como hace el divisor capacitivo de un Colpitts. Con 0° el lazo sumaría solo 180°, que sería realimentación negativa, y con 360° el total sería 540°.], tema: "T3")
#pq(9, 1, 14, "c", "estúdialo en: simulacros de estudio 1·1·14 · libro: F-T3.21", "Ruido de fase: fluctuaciones aleatorias de fase que crean faldones de ruido a ambos lados de la portadora (en TX, molestan a canales vecinos)",
  [Observada en un analizador de espectros, la señal de un oscilador con mucho ruido de fase aparece como:],
  ([una raya limpia y estrecha, pero de menor amplitud], [una raya limpia acompañada de otras en el doble y el triple de su frecuencia], [una raya ensanchada por faldones de ruido a ambos lados de la portadora], [una raya limpia que se desplaza lentamente a medida que el equipo se calienta],),
  sol: [El ruido de fase son pequeñas fluctuaciones aleatorias de la fase, y por tanto de la frecuencia, que en el espectro ensanchan la portadora con faldones de ruido a ambos lados. Las rayas en el doble y el triple de la frecuencia son armónicos, y el desplazamiento lento al calentarse es la deriva térmica: dos defectos distintos.], tema: "T3")
#pq(9, 1, 15, "a", "estúdialo en: simulacros de estudio 12·1·15 · libro: T4.11", "La imagen se rechaza antes del mezclador, con un filtro (preselector)",
  [Para que la frecuencia imagen no llegue a la FI de un superheterodino, el filtro que la rechaza tiene que actuar:],
  ([antes del mezclador, en la etapa de RF (preselector)], [a la salida del amplificador de audio], [después del detector, sobre la señal de audio], [después del mezclador, a la entrada del amplificador de FI],),
  sol: [Una vez mezclada, la imagen cae exactamente en la FI, igual que la señal deseada, y ningún filtro posterior puede ya separarlas. Por eso hay que eliminarla antes del mezclador, con el preselector de la etapa de RF. Poner el filtro justo detrás del mezclador es el error tentador: allí la imagen ya es indistinguible de la señal.], tema: "T4")
#pq(9, 1, 16, "b", "estúdialo en: simulacros de estudio 9·1·14 · libro: C-T4.12", "Doble conversión: dos FI; la 1.ª alta (aleja la imagen) y la 2.ª baja (selectividad)",
  [En un receptor de doble conversión con primera FI de 70 MHz y segunda FI de 455 kHz, la primera FI se elige tan alta principalmente para:],
  ([reponer la portadora suprimida de las emisiones de SSB], [alejar la frecuencia imagen, de modo que el preselector la elimine con facilidad], [conseguir la selectividad fina frente al canal adyacente], [reducir la deriva del oscilador local],),
  sol: [La imagen está a dos veces la FI de la señal: con 70 MHz de primera FI se va tan lejos que un filtro sencillo delante del mezclador la aniquila. La selectividad fina es tarea de la segunda FI, baja, donde es fácil construir un filtro estrecho de flancos abruptos. Reponer la portadora es cosa del BFO.], tema: "T4")
#pq(9, 1, 17, "c", "estúdialo en: simulacros de estudio 4·1·18 · libro: T5.13", "Anchura de banda necesaria: la justa para la velocidad y calidad requeridas",
  [A una emisión de fonía en SSB le bastan unos 2,7 kHz para la calidad requerida, pero un equipo mal ajustado la emite con 6 kHz. Esa emisión:],
  ([mejora su inteligibilidad, por lo que esos 6 kHz son la anchura necesaria], [tiene una anchura de banda necesaria de 6 kHz, igual a la que ocupa], [ocupa más que la anchura de banda necesaria, desperdicia espectro e interfiere a los vecinos], [cumple, porque la anchura necesaria es la máxima que permite el equipo],),
  sol: [La anchura de banda necesaria es la justa para transmitir con la velocidad y calidad requeridas; para la voz en SSB, unos 2,7 kHz. Ocupar más no mejora la calidad y quita espectro a los demás. La necesaria la fija lo que se transmite, no lo que el equipo emite ni su máximo.], tema: "T5")
#pq(9, 1, 18, "b", "estúdialo en: simulacros de estudio 11·1·18 · libro: T5.4", "Filtro de salida (paso bajo) y red de acoplo entre el final y la antena: eliminan armónicos y adaptan",
  [¿Por qué el filtro que se intercala entre el amplificador final de HF y la antena es un paso bajo?],
  ([debe atenuar la fundamental y dejar pasar los armónicos], [los armónicos que debe eliminar están por encima de la frecuencia de trabajo], [así aumenta la potencia radiada en la frecuencia de trabajo], [las emisiones indeseadas de un transmisor caen siempre por debajo de la fundamental],),
  sol: [Los armónicos están en $2 f$, $3 f$…, por encima de la fundamental: un paso bajo deja pasar la frecuencia de trabajo y los atenúa. En el filtro en pi los condensadores en paralelo abren a los armónicos un camino a masa y la bobina en serie les pone un muro. Un filtro no añade potencia: como mucho, la conserva.], tema: "T5")
#pq(9, 1, 19, "d", "estúdialo en: simulacros de estudio 10·1·19 · libro: T5.26", "VOX: pasa a transmisión al hablar; en MAN se usa el PTT del micrófono",
  [Operas desde un lugar con mucho ruido ambiente y el transceptor pasa a transmisión solo, sin que hables. Lo adecuado es:],
  ([subir la sensibilidad del VOX], [activar el noise blanker], [abrir el silenciador (squelch)], [poner el conmutador VOX-MAN en MAN y transmitir con el PTT],),
  sol: [En VOX el equipo pasa a transmisión al detectar sonido en el micrófono, y el ruido ambiente puede dispararlo. En MAN la conmutación es manual: el operador transmite con el PTT del micrófono. Subir la sensibilidad del VOX empeoraría el problema; el noise blanker y el squelch son mandos del receptor.], tema: "T5")
#pq(9, 1, 20, "a", "estúdialo en: simulacros de estudio 2·1·19 · libro: T6.3", "Para bajar la frecuencia de resonancia hay que alargar la antena (29,9 → 28,5 MHz)",
  [Una antena resuena en 144,5 MHz y se quiere que resuene en 146 MHz. Para ello hay que:],
  ([acortarla], [alimentarla por un extremo], [intercalar una bobina en serie en su base], [alargarla],),
  sol: [Para subir la frecuencia de resonancia hay que acortar la antena, porque su longitud va en proporción inversa a la frecuencia ($lambda = 300 slash f$). Alargarla, o añadir una bobina en serie, que la alarga eléctricamente, haría justo lo contrario: bajar la frecuencia. Alimentarla por un extremo cambia la impedancia, no la resonancia.], tema: "T6")
#pq(9, 1, 21, "b", "estúdialo en: simulacros de estudio 8·1·21 · libro: F-T6.10", "Coeficiente de reflexión y ROE a partir de las impedancias (150 Ω en 50 Ω → ROE 3)",
  [Una línea de 50 Ω termina en una antena resistiva pura de impedancia menor que 50 Ω, y el medidor marca una ROE de 4. La impedancia de la antena es de:],
  ([25 Ω], [12,5 Ω], [200 Ω], [20 Ω],),
  sol: [Con carga resistiva, la ROE es la impedancia mayor dividida entre la menor; si la antena está por debajo de 50 Ω, ROE = 50 / $Z_L$, luego $Z_L$ = 50 / 4 = 12,5 Ω. Comprobación: $rho = (12","5 - 50) / (12","5 + 50) = -0","6$ y $"ROE" = (1 + 0","6) / (1 - 0","6) = 4$. Los 200 Ω también darían ROE 4, pero son mayores que 50 Ω; los 25 Ω corresponden a ROE 2, y los 20 Ω salen de calcular 50 · (1 − 0,6) olvidando el denominador.], tema: "T6")
#pq(9, 1, 22, "c", "estúdialo en: simulacros de estudio 6·1·21 · libro: F-T6.18", "Transformador de cuarto de onda: Z = √(Zlínea · Zcarga); Zent = Z0²/ZL",
  [Se dispone de un tramo de cuarto de onda de coaxial de 75 Ω. ¿Qué carga resistiva queda adaptada a una línea de 50 Ω al intercalar ese tramo?],
  ([25 Ω], [100 Ω], [112,5 Ω], [33,3 Ω],),
  sol: [El tramo de cuarto de onda adapta cuando su impedancia es la media geométrica de las otras dos: $Z_0^2 = Z_"línea" Z_L$, luego $Z_L = 75^2 slash 50 = 5625 slash 50 = 112","5$ Ω. Comprobación: $75^2 slash 112","5 = 50$ Ω. Los 100 Ω salen de tomar 75 como media aritmética, los 25 Ω de restar y los 33,3 Ω de aplicar la fórmula al revés ($50^2 slash 75$).], tema: "T6")
#pq(9, 1, 23, "a", "estúdialo en: simulacros de estudio 9·1·23 · libro: T7.22", "Orden de las capas de la atmósfera: troposfera, estratosfera e ionosfera",
  [Si se recorren las capas de la atmósfera desde la más alta hasta la más baja, el orden es:],
  ([ionosfera, estratosfera y troposfera], [ionosfera, troposfera y estratosfera], [estratosfera, ionosfera y troposfera], [troposfera, estratosfera e ionosfera],),
  sol: [Desde el suelo hacia arriba están la troposfera, la estratosfera y la ionosfera; de mayor a menor altura, el orden se invierte. La serie que empieza por la troposfera es el orden correcto, pero de menor a mayor altura, que no es lo que se pide.], tema: "T7")
#pq(9, 1, 24, "d", "estúdialo en: simulacros de estudio 3·1·25", "Ángulo de radiación bajo → distancia de salto más larga",
  [Para hacer DX muy lejano en HF, ¿qué ángulo de radiación conviene a la antena?],
  ([da igual, porque la distancia de salto solo depende de la potencia], [alto, casi vertical, para que la onda llegue antes a la capa F], [alto, porque así la MUF del trayecto es mayor], [bajo, cercano al horizonte, porque la onda aterriza más lejos tras cada salto],),
  sol: [Cuanto más rasante sale la onda, más lejos aterriza tras reflejarse, y además el trayecto admite una MUF más alta. Un ángulo alto acorta el salto y baja la MUF, justo lo contrario de lo que se busca. La distancia de salto depende del ángulo y de la ionosfera, no de la potencia.], tema: "T7")
#pq(9, 1, 25, "c", "estúdialo en: simulacros de estudio 6·1·25", "Ruido atmosférico (tormentas): domina en las bandas bajas de HF",
  [Una noche de verano, en 80 m, se oye de fondo un crepitar fuerte y continuo con chasquidos. Ese ruido es, sobre todo:],
  ([ruido de intermodulación producido por el propio receptor], [ruido galáctico, procedente del centro de la Vía Láctea], [ruido atmosférico, producido por las tormentas y propagado por la ionosfera], [ruido térmico, generado en la etapa de entrada del receptor],),
  sol: [Los rayos de las tormentas de todo el planeta generan un ruido que la ionosfera propaga igual que las señales: domina en las bandas bajas de HF y en verano. El ruido galáctico se nota entre unos 20 y 200 MHz, y el térmico del receptor queda en HF muy por debajo del ruido que entra por la antena.], tema: "T7")
#pq(9, 1, 26, "a", "estúdialo en: simulacros de estudio 10·1·27 · libro: T8.23", "Carga artificial: ajustar el transmisor sin radiar",
  [Una carga artificial para ajustar un transmisor de HF de 100 W debe ser:],
  ([una resistencia no inductiva de 50 Ω capaz de disipar al menos 100 W], [un condensador de 50 pF capaz de soportar 100 W], [una resistencia bobinada de 50 Ω y 100 W], [una resistencia no inductiva de 50 Ω y 1 W],),
  sol: [La carga artificial sustituye a la antena: debe presentar 50 Ω, como una antena adaptada, y convertir en calor toda la potencia del transmisor. Una resistencia bobinada tiene inductancia, que en HF añade reactancia y le impide presentar 50 Ω, y una de 1 W se quemaría. Un condensador no es una resistencia y no convierte la potencia en calor.], tema: "T8")
#pq(9, 1, 27, "d", "estúdialo en: simulacros de estudio 11·1·28 · libro: T9.17", "Remedio del bloqueo y de la TVI: filtro en la entrada del equipo afectado (problema de inmunidad)",
  [Tu emisión en 2 m está limpia, pero el televisor del vecino se bloquea cuando transmites. ¿Qué filtro conviene y dónde?],
  ([un filtro paso bajo en la entrada de antena del televisor, que corte por encima de 145 MHz], [un filtro paso bajo a la salida de tu transmisor], [un filtro de red en tu fuente de alimentación], [un filtro paso alto en la entrada de antena del televisor, que deje pasar la televisión y rechace los 145 MHz],),
  sol: [Si la emisión está limpia, el problema es de inmunidad del televisor y el remedio va en su entrada: la televisión digital está muy por encima de 145 MHz, así que un paso alto la deja pasar y rechaza la señal del aficionado. El paso bajo a la salida del transmisor quita armónicos, pero no la fundamental, que es la que bloquea.], tema: "T9")
#pq(9, 1, 28, "b", "estúdialo en: simulacros de estudio 4·1·28 · libro: T9.18", "Una buena tierra reduce la RF en los chasis y las interferencias",
  [Cuando transmites notas RF en el chasis y en el cable del micrófono, y un equipo de música cercano se interfiere. ¿Qué medida ataca la causa?],
  ([aumentar la potencia para mejorar el enlace], [unir los chasis a la toma de tierra con un conductor corto y grueso], [alargar el cable del micrófono], [subir la ganancia del micrófono],),
  sol: [Sin un camino corto a tierra, la RF vuelve por donde puede (los chasis, el cable del micrófono, la alimentación) y desde ahí se acopla a los equipos cercanos. Un conductor corto y grueso hasta la toma de tierra le da ese camino. Alargar cables o subir la potencia empeora el problema.], tema: "T9")
#pq(9, 1, 29, "c", "estúdialo en: simulacros de estudio 7·1·29 · libro: T10.1", "Interruptor general de la estación",
  [En un accidente eléctrico en la estación, conviene que toda la familia sepa dónde está el interruptor general porque:],
  ([al accionarlo se descargan al instante los condensadores de los equipos], [desconecta la toma de tierra, que es por donde llega la descarga], [lo primero es cortar la corriente, y con él se corta toda la estación de un solo gesto], [reduce la potencia del transmisor a un nivel seguro],),
  sol: [El interruptor general corta de un solo gesto el suministro de toda la estación, y cortar la corriente es la primera medida ante un accidente: mientras haya tensión, quien toque a la víctima entra en el circuito. No descarga los condensadores, que conservan la carga aunque el equipo esté desconectado, y la toma de tierra nunca se desconecta.], tema: "T10")
#pq(9, 1, 30, "b", "estúdialo en: simulacros de estudio 13·1·30 · libro: T10.31", "Antena lejos de las líneas eléctricas aéreas: distancia mayor que la altura total del conjunto",
  [Se va a levantar un mástil de 6 m con una antena que sobresale 2 m por encima de él. La distancia a una línea eléctrica aérea próxima debe ser:],
  ([mayor de 6 m], [mayor de 8 m], [indiferente si la línea está aislada], [de al menos 1 m],),
  sol: [El criterio es geométrico: si el conjunto cae, no debe poder alcanzar la línea, así que la distancia ha de ser mayor que la altura total de mástil y antena, 6 + 2 = 8 m. Contar solo el mástil se queda corto, y que la línea parezca aislada no cambia nada.], tema: "T10")
#fin-prueba()
#prueba(9, 2)
#pq(9, 2, 1, "a", "estúdialo en: simulacros de estudio 5·2·1 · libro: R1.11", "Sufijos TOP y BOJ: T Tango, O Oscar, P Papa (no Pedro, Peter)",
  [En un concurso, para dar el sufijo `OPT`, dices:],
  ([Oscar Papa Tango], [Zero Papa Tango], [Oscar Peter Tare], [Oscar Pedro Tango],),
  sol: [O es Oscar, P es Papa y T es Tango. Peter y Tare son del alfabeto de los años cuarenta, Pedro de un alfabeto nacional antiguo, y Zero es la cifra 0, no la letra O: confundirlas es justo lo que el deletreo evita.], tema: "R1")
#pq(9, 2, 2, "d", "estúdialo en: simulacros de estudio 3·2·1 · libro: R2.5", "QRZ ¿quién me llama? (la llamada general es CQ, que no es código Q)",
  [Al terminar tu llamada general oyes a una estación muy débil que te contesta, pero no entiendes su distintivo. Le transmites:],
  ([`CQ`], [`QRL?`], [`QSL?`], [`QRZ?`],),
  sol: [`QRZ?` pregunta «¿quién me llama?», justo lo que necesitas. `CQ` es la llamada general (y no es un grupo Q), `QRL?` pregunta si la frecuencia está ocupada y `QSL?` pide acuse de recibo.], tema: "R2")
#pq(9, 2, 3, "b", "estúdialo en: simulacros de estudio 1·2·3 · libro: R2.17", "QTC tengo mensajes para transmitir",
  [En una red de tráfico, una estación tiene tres mensajes para otra. ¿Cómo se lo anuncia?],
  ([`QSP 3`], [`QTC 3`], [`QTA 3`], [`QRU 3`],),
  sol: [`QTC` indica que se tienen mensajes para transmitir, y la cifra dice cuántos. `QTA` sirve para anular un mensaje, `QSP` es retransmitir gratuitamente a otra estación y `QRU` es «no tengo nada para usted».], tema: "R2")
#pq(9, 2, 4, "d", "estúdialo en: simulacros de estudio 11·2·5 · libro: R3.15", "BK interrupción breve (break)",
  [En pleno intercambio en telegrafía quieres pasar el turno un momento al corresponsal sin repetir todo el ritual de indicativos. ¿Qué abreviatura usas?],
  ([`SK`], [`AR`], [`CL`], [`BK`],),
  sol: [`BK` (\_break\_) es la interrupción breve: pasa el turno sin el ritual completo de indicativos. `SK` y `CL` cierran el contacto y la estación, y `AR` marca el fin de una transmisión dentro del ritual normal.], tema: "R3")
#pq(9, 2, 5, "a", "estúdialo en: simulacros de estudio 9·2·5 · libro: R3.5", "USB banda lateral superior / LSB inferior",
  [Vas a hablar en SSB en la banda de 40 m (7 MHz). Según el convenio habitual en HF, ¿qué banda lateral seleccionas y cómo se abrevia?],
  ([la inferior, `LSB`], [la superior, `USB`], [la inferior, `USB`], [la superior, `LSB`],),
  sol: [`LSB` es la banda lateral inferior y `USB`, la superior. Por convenio se usa la inferior por debajo de 10 MHz (160, 80 y 40 m) y la superior de 20 m hacia arriba. Las opciones cruzadas emparejan la banda lateral con la abreviatura que no le corresponde.], tema: "R3")
#pq(9, 2, 6, "c", "estúdialo en: simulacros de estudio 4·2·5 · libro: R3.33", "ABT aproximadamente y VY muy",
  [En la frase «`PWR ABT 100W ES WX VY COLD`», las abreviaturas `ABT` y `VY` significan:],
  ([«máximo» y «muy»], [«aproximadamente» y «vatios»], [«aproximadamente» y «muy»], [«al menos» y «bastante»],),
  sol: [`ABT` (\_about\_) es «aproximadamente»: unos 100 W. `VY` (\_very\_) es «muy»: hace mucho frío. `ABT` no marca un máximo ni un mínimo, sino una cifra aproximada.], tema: "R3")
#pq(9, 2, 7, "c", "estúdialo en: simulacros de estudio 11·2·8 · libro: C-R3.1", "FB buen trabajo, formidable (fine business)",
  [Tras recibir tu informe, el corresponsal contesta «`TNX FB RPRT`». ¿Qué te dice?],
  ([que necesita que repitas el informe], [que tu informe le parece demasiado bajo], [que te agradece el buen informe], [que tu informe le llegó con interferencias],),
  sol: [`FB` (\_fine business\_) es un elogio: «buen trabajo», «formidable»; con `TNX` delante, «gracias por el buen informe». No expresa queja ni petición de repetición.], tema: "R3")
#pq(9, 2, 8, "a", "estúdialo en: simulacros de estudio 2·2·9 · libro: R4.6", "Seguridad en radiotelegrafía: TTT tres veces",
  [Quieres transmitir en telegrafía un aviso a la navegación, por ejemplo un contenedor a la deriva. ¿Cómo lo encabezas?],
  ([`TTT`, tres veces], [`SOS`], [`XXX`, tres veces], [`CQ`, tres veces],),
  sol: [Un aviso a la navegación es un mensaje de seguridad, que en telegrafía se encabeza con `TTT` tres veces. `XXX` es urgencia y `SOS`, socorro: ambos piden ayuda, y aquí solo se avisa. `CQ` es una llamada general, no una señal de seguridad.], tema: "R4")
#pq(9, 2, 9, "d", "estúdialo en: simulacros de estudio 3·2·6 · libro: R4.16", "Usar SOS o MAYDAY sin peligro real es infracción sancionable",
  [Un radioaficionado transmite «Mayday» para comprobar si su equipo nuevo sale bien, sin que haya ningún peligro. Esa conducta:],
  ([está permitida en las bandas de aficionado, que no son marítimas], [solo es sancionable si se movilizan medios de rescate], [es correcta si antes avisa de que es una prueba], [es una infracción sancionable],),
  sol: [Usar una señal de socorro sin peligro real es una infracción sancionable en cualquier banda, ni siquiera para probar el equipo. Si además se movilizan medios de socorro, puede llegar a ser delito, pero la infracción ya existe aunque no se mueva nadie.], tema: "R4")
#pq(9, 2, 10, "b", "estúdialo en: simulacros de estudio 5·2·10", "Banda de 13 cm: 2300–2450 MHz",
  [La banda de aficionados de 13 cm empieza en 2300 MHz. ¿Dónde termina?],
  ([2400 MHz], [2450 MHz], [2483,5 MHz], [2350 MHz],),
  sol: [La banda de 13 cm va de 2300 a 2450 MHz. El tramo superior, de 2400 a 2450 MHz, coincide con una banda ICM, pero sigue siendo parte de la banda: por eso 2400 MHz no es su final.], tema: "R4")
#pq(9, 2, 11, "c", "estúdialo en: simulacros de estudio 12·2·10 · libro: C-R5.15", "Estructura internacional: la parte de nacionalidad tiene hasta tres caracteres, letras o cifras",
  [Los prefijos G (Reino Unido), C3 (Andorra) y 9A (Croacia) muestran que la parte de un distintivo que identifica la nacionalidad:],
  ([tiene siempre dos letras], [tiene siempre tres caracteres], [puede tener una sola letra o combinar letras y cifras], [empieza siempre por la inicial del nombre del país],),
  sol: [En la estructura internacional, la parte de nacionalidad tiene uno, dos o tres caracteres, que pueden ser letras o cifras: G tiene uno y C3 y 9A combinan letra y cifra. Ninguna regla obliga a usar la inicial del país: Croacia es 9A, no C.], tema: "R5")
#pq(9, 2, 12, "b", "estúdialo en: simulacros de estudio 13·2·12 · libro: R5.28", "Sufijo de una letra: reservado también para concursos internacionales de alta competitividad",
  [Para participar en un concurso internacional de alta competitividad con el distintivo más corto posible, ¿qué tipo de sufijo está reservado a ese uso?],
  ([el de cuatro o más letras], [el de una sola letra], [el de tres letras que empiece por Y o Z], [el de dos letras],),
  sol: [El art. 27.3 reserva los sufijos de una letra, entre otros usos, a la participación en concursos internacionales de alta competitividad: son los más rápidos de transmitir. Los de cuatro o más letras son excepcionales para conmemoraciones, y los que empiezan por Y o Z son de desatendidas.], tema: "R5")
#pq(9, 2, 13, "d", "estúdialo en: simulacros de estudio 3·2·12 · libro: C-R5.3", "Solicitud de distintivo temporal: una por evento, a la Administración; las asociaciones solo proponen",
  [Un radioclub prepara tres eventos este año: un concurso local, una demostración y una conmemoración. Para usar distintivos temporales debe:],
  ([presentar una solicitud solo para el primero; los demás quedan cubiertos durante treinta días], [no pedir nada, porque las estaciones colectivas pueden usarlos libremente], [pedirlos a su asociación nacional, que es la que los autoriza], [presentar ante la Administración una solicitud independiente para cada evento],),
  sol: [El art. 28 exige una solicitud independiente por cada evento, dirigida a la Administración, con período, distintivo pedido, motivo y tipo de estación. Las asociaciones solo pueden proponer; no autorizan. Los treinta días son un límite anual por sufijo, no una cobertura para varios eventos.], tema: "R5")
#pq(9, 2, 14, "c", "estúdialo en: simulacros de estudio 4·2·15, 12·2·14 · libro: F-R6.7, C-R6.5", "Convenio de banda lateral: LSB por debajo de 10 MHz, USB por encima; excepción 60 m en USB",
  [Vas a hacer fonía en banda lateral única en 17 m (18 MHz). Por convenio, la banda lateral que debes usar es:],
  ([la inferior (LSB)], [cualquiera de las dos, porque el plan no recomienda ninguna], [la superior (USB)], [la inferior (LSB), porque 17 m está por debajo de 20 MHz],),
  sol: [El convenio es LSB por debajo de 10 MHz y USB por encima; 18 MHz está por encima, así que se usa USB. El límite está en 10 MHz, no en 20 MHz, y la única excepción por debajo es la banda de 60 m, también en USB.], tema: "R6")
#pq(9, 2, 15, "a", "estúdialo en: simulacros de estudio 8·2·15 · libro: R7.12", "Lenguaje claro: sin códigos que oculten el significado (Q y abreviaturas sí)",
  [¿Cuál de estas prácticas respeta la exigencia de transmitir en lenguaje claro?],
  ([Emplear el código Q y abreviaturas normalizadas como 73], [Usar palabras clave inventadas por un grupo para hablar de sus asuntos], [Cifrar los mensajes con un programa durante los concursos], [Acordar con un amigo un código propio para que nadie más entienda los mensajes],),
  sol: [Lo prohibido es ocultar el significado de la comunicación. El código Q y las abreviaturas son públicos y normalizados: abrevian, pero no cifran, así que no rompen el lenguaje claro. Un código privado, un cifrado o una jerga inventada sí ocultan el sentido.], tema: "R7")
#pq(9, 2, 16, "a", "estúdialo en: simulacros de estudio 6·2·16 · libro: F-R7.3", "Autorregulación (self-policing): autodisciplina, sin policía propia",
  [En una comunidad «autorregulada» (self-policing) como la radioafición, la inspección y las sanciones por incumplir la normativa corresponden a:],
  ([la Administración], [los propios radioaficionados, por votación entre ellos], [la asociación nacional de radioaficionados], [la IARU],),
  sol: [Autorregulación significa que la buena conducta descansa en la autodisciplina de cada aficionado, no que la comunidad tenga policía propia. La inspección y las sanciones siguen siendo de la Administración (arts. 33 y 34 de la Orden); ni la IARU ni las asociaciones sancionan.], tema: "R7")
#pq(9, 2, 17, "b", "estúdialo en: simulacros de estudio 4·2·17 · libro: R8.7", "CNAF = Cuadro Nacional de Atribución de Frecuencias",
  [El documento que atribuye en España las bandas de frecuencias a cada servicio de radiocomunicación, y al que remite el Reglamento de aficionados, se denomina:],
  ([Plan de bandas de la IARU para la Región 1], [Cuadro Nacional de Atribución de Frecuencias (CNAF)], [Registro Nacional de Frecuencias de Aficionado], [Recomendación CEPT T/R 61-01],),
  sol: [El CNAF es el plan nacional que atribuye bandas, subbandas y frecuencias a cada servicio y fija sus condiciones, de obligado cumplimiento. El plan de bandas de la IARU reparte segmentos dentro de las bandas de aficionado (por ejemplo, para radiobalizas), pero no atribuye bandas a los distintos servicios, y la T/R 61-01 trata del uso temporal de estaciones en otros países.], tema: "R8")
#pq(9, 2, 18, "c", "estúdialo en: simulacros de estudio 12·2·17 · libro: F-R8.17", "CNAF vigente: aprobado por orden ministerial (Orden TDF/732/2026)",
  [La Orden ETD/1449/2021, de 16 de diciembre, aprobó una edición del CNAF. En octubre de 2026 esa edición:],
  ([sigue vigente hasta que la UIT apruebe un nuevo Reglamento de Radiocomunicaciones], [ha sido sustituida por la Orden IET/1311/2013], [ha sido sustituida por la aprobada por la Orden TDF/732/2026, de 10 de julio], [sigue vigente, porque el CNAF solo puede modificarse mediante una ley],),
  sol: [El Ministerio aprueba el CNAF mediante orden, y la edición vigente es la de la Orden TDF/732/2026, de 10 de julio, que derogó y sustituyó a la de la Orden ETD/1449/2021. La Orden IET/1311/2013 no es un CNAF, sino el reglamento de los radioaficionados, y además es anterior. No hace falta una ley para cambiar el CNAF: basta una orden ministerial.], tema: "R8")
#pq(9, 2, 19, "d", "estúdialo en: simulacros de estudio 8·2·21 · libro: C-R8.38", "La autorización de radioaficionado la otorga la SETSI (hoy SETID)",
  [La resolución que concede la autorización de radioaficionado, junto con su distintivo de llamada, la dicta:],
  ([el ayuntamiento del domicilio del solicitante], [la asociación de radioaficionados de la provincia del solicitante], [la consejería de la comunidad autónoma de residencia], [la Secretaría de Estado competente en telecomunicaciones (la SETSI de la Orden, hoy SETID)],),
  sol: [La autorización la otorga la SETSI mediante resolución motivada, que la concede junto con el distintivo de llamada o la deniega (arts. 5.1 y 7.1 de la Orden); hoy el órgano se llama SETID. Las asociaciones no conceden nada, y ni las comunidades autónomas ni los ayuntamientos tienen competencia: las telecomunicaciones son competencia exclusiva del Estado.], tema: "R8")
#pq(9, 2, 20, "a", "estúdialo en: simulacros de estudio 3·2·18, 11·2·19 · libro: C-R8.20, C-R8.14", "Extranjero residente: autorización sin examen con HAREC de un país T/R 61-02 o por reciprocidad (residencia acreditada)",
  [Un extranjero residente en España tiene la licencia de radioaficionado de su país, pero no tiene HAREC; España tiene un convenio de reciprocidad en la materia con ese país. Según el artículo 5.2:],
  ([puede obtener la autorización española sin superar la prueba de capacitación], [debe superar la prueba de capacitación, porque no tiene HAREC], [puede operar indefinidamente con su licencia de origen como si fuera una licencia CEPT], [solo puede obtener una autorización temporal de 90 días],),
  sol: [El art. 5.2 ofrece al extranjero residente dos vías sin examen: un HAREC de un país que aplique la T/R 61-02 o un acuerdo o convenio de reciprocidad con el país que le otorgó su licencia original. Basta una de las dos, así que el convenio le exime del examen aunque no tenga HAREC. La autorización temporal de 90 días es para visitantes de países sin la T/R 61-01, no para residentes.], tema: "R8")
#pq(9, 2, 21, "c", "estúdialo en: simulacros de estudio 13·2·22 · libro: R8.60", "La autorización habilita a emitir en las bandas y con las características técnicas del servicio de aficionados",
  [Un radioaficionado con autorización en vigor quiere emitir en una frecuencia que no está atribuida al servicio de aficionados. Su autorización:],
  ([le ampara si se identifica con su distintivo de llamada], [le ampara siempre que no cause interferencias perjudiciales], [no le ampara: solo habilita para las bandas y con las características técnicas establecidas para el servicio de aficionados], [le ampara si lo notifica a la Jefatura Provincial con cinco días de antelación],),
  sol: [La autorización habilita para emitir en las bandas del servicio de aficionados, con las características técnicas del anexo I (art. 5.3); fuera de ellas no ampara nada. No interferir o identificarse son obligaciones adicionales, no permisos para salir de banda. El aviso de cinco días es el del uso portable de la estación, otro asunto.], tema: "R8")
#pq(9, 2, 22, "b", "estúdialo en: simulacros de estudio 12·2·22 · libro: C-R8.36", "Estación construida de acuerdo con el estado de la técnica (no se impone tecnología)",
  [Sobre cómo debe construirse una estación de aficionado, la normativa vigente:],
  ([exige que todos los equipos sean de fabricación industrial con marcado CE], [no impone una tecnología ni un modelo: exige cumplir las características técnicas del anexo I, según el estado de la técnica], [exige que todos los equipos se presenten en la Jefatura para su homologación individual], [exige transceptores capaces de operar en modos digitales],),
  sol: [La estación debe construirse con arreglo al estado de la técnica: el equipo puede ser comercial o casero, de válvulas o de transistores, siempre que cumpla el anexo I (emisiones no esenciales limitadas, filtros, medios para comprobar banda y potencia). Exigir solo equipos industriales contradice la libertad de construcción propia, y la presentación en la Jefatura es optativa.], tema: "R8")
#pq(9, 2, 23, "d", "estúdialo en: simulacros de estudio 5·2·24 · libro: C-R8.12", "La licencia se expide terminado el montaje y presentada la documentación",
  [¿En qué momento puedes empezar a emitir desde tu nueva estación fija?],
  ([En cuanto vence el plazo de dos meses de la comunidad de propietarios para alegar], [En cuanto se autoriza el montaje de la instalación], [En cuanto termina el montaje, aunque aún no lo hayas comunicado], [Cuando la Jefatura expide la licencia, después de que hayas comunicado el fin del montaje con la documentación requerida],),
  sol: [La licencia se expide al final: terminado el montaje, se comunica a la Jefatura con el justificante del seguro y, en su caso, el boletín del instalador, y la Jefatura verifica y expide la licencia, que es lo que habilita para emitir. Autorizar el montaje solo permite instalar, y el plazo de la comunidad es un trámite intermedio.], tema: "R8")
#pq(9, 2, 24, "b", "estúdialo en: simulacros de estudio 13·2·25 · libro: F-R8.44", "Permisos de servidumbres, medio ambiente, etc.: por cuenta y a cargo del solicitante",
  [Para tu estación fija, situada cerca de un aeródromo, hace falta un permiso en materia de servidumbres aeronáuticas. Según el artículo 18.3 de la Orden IET/1311/2013:],
  ([no hace falta: la licencia de estación fija prevalece sobre las servidumbres], [debes obtenerlo tú, como solicitante de la licencia, por tu cuenta y a tu cargo], [lo solicita y lo paga la asociación de radioaficionados de la provincia], [lo obtiene la comunidad de propietarios, como titular de la cubierta del edificio],),
  sol: [La obtención de los permisos en materia de seguridad nacional, servidumbres, medio ambiente u ordenación del territorio es por cuenta y a cargo de los solicitantes de la licencia. La licencia depende de que se cumplan esas normas, así que no prevalece sobre ellas, y de su cumplimiento responde quien la pide, no la comunidad ni una asociación.], tema: "R8")
#pq(9, 2, 25, "b", "estúdialo en: simulacros de estudio 2·2·22 · libro: C-R8.29", "Comunidad de propietarios: no autoriza; la solicitud indica la dirección del presidente y la Administración le informa",
  [En la solicitud para instalar antenas en un edificio en propiedad horizontal, el radioaficionado hace constar la dirección del presidente de la comunidad. ¿Para qué?],
  ([Para que la junta pueda vetar la instalación por mayoría simple], [Para que la Administración, aceptada la memoria, informe a la comunidad y esta pueda alegar sobre la idoneidad de la instalación], [Para que el presidente firme la autorización de la instalación], [Para que la comunidad contrate a su nombre el seguro de antenas],),
  sol: [La comunidad no autoriza ni prohíbe: la autorización es administrativa. La dirección del presidente sirve para que la Administración, una vez aceptada la memoria, le comunique la solicitud y la comunidad pueda alegar sobre la idoneidad del emplazamiento o los perjuicios. El seguro lo contrata el titular, y la mayoría simple sirve para ejercer los derechos del predio sirviente, no para vetar.], tema: "R8")
#pq(9, 2, 26, "d", "estúdialo en: simulacros de estudio 4·2·25 · libro: F-R8.79", "Estación temporal: concursos, expediciones, demostraciones y eventos",
  [¿Cuál de estas actividades encaja en la definición de estación temporal del anexo I?],
  ([la retransmisión automática de emisiones desde un monte para ampliar su alcance], [las emisiones desde un vehículo en marcha], [el uso de la estación fija durante las vacaciones en una segunda residencia], [una demostración de radio para los alumnos de un colegio],),
  sol: [El anexo I define la estación temporal como la utilizada con carácter temporal para concursos y diplomas, expediciones, demostraciones en colegios, ferias y otros eventos de naturaleza similar. Usar la estación fija en una segunda residencia es lo propio de la estación portable, que es el distractor más tentador porque también es temporal. Retransmitir automáticamente es tarea del repetidor, y emitir en marcha, de la estación móvil.], tema: "R8")
#pq(9, 2, 27, "c", "estúdialo en: simulacros de estudio 10·2·27 · libro: F-R8.69", "Noveles en estaciones colectivas: supervisor con ≥ 3 años de antigüedad",
  [Una asociación organiza en un instituto una demostración en la que alumnos sin autorización hablarán por su estación colectiva. Según el artículo 30.6, la actividad debe hacerse bajo la supervisión de:],
  ([cualquier radioaficionado autorizado, aunque acabe de obtener su autorización], [un radioaficionado con al menos tres años de antigüedad, aunque supervise a distancia desde su domicilio], [un radioaficionado autorizado con al menos tres años de antigüedad, de forma directa y presencial], [el profesor responsable del grupo, aunque no sea radioaficionado],),
  sol: [El art. 30.6.b exige que el uso por noveles se haga bajo la responsabilidad y la supervisión directa y presencial de un radioaficionado autorizado con al menos tres años de antigüedad en el ejercicio de la radioafición. Por eso falla quien acierta la antigüedad pero supervisa a distancia: la presencia es parte de la condición. Ni un recién autorizado ni un profesor sin autorización cumplen el requisito.], tema: "R8")
#pq(9, 2, 28, "a", "estúdialo en: simulacros de estudio 3·2·27 · libro: R8.34", "Acceso a repetidores: necesariamente libre; si hay código, público y facilitado a quien lo pida",
  [Una asociación quiere poner un código de acceso a su repetidor analógico para evitar abusos. Según la Orden, ¿puede hacerlo?],
  ([Sí, siempre que el código se haga público, porque el acceso a los repetidores debe ser libre], [No, los repetidores no pueden tener ningún código de acceso], [Sí, siempre que lo comunique a la Jefatura Provincial y lo mantenga en reserva], [Sí, y puede reservar el código a sus socios],),
  sol: [El acceso a los repetidores analógicos y digitales es necesariamente libre; si tienen código de acceso, este debe hacerse público. El código, por tanto, no está prohibido, pero no puede servir para restringir el uso a los socios ni mantenerse en secreto. Comunicarlo a la Jefatura no sustituye a la obligación de publicarlo.], tema: "R8")
#pq(9, 2, 29, "d", "estúdialo en: simulacros de estudio 1·2·28 · libro: F-R9.8", "Muy grave: la producción deliberada de interferencias",
  [Según la Ley 11/2022, ¿qué hace que la producción de interferencias a servicios autorizados pase de infracción grave a muy grave?],
  ([que la interferencia se prolongue durante más de un día], [que la estación emita con más de 100 W], [que el perjudicado sea otro radioaficionado], [que la interferencia sea deliberada],),
  sol: [La diferencia está en la intención: la mera producción de interferencias es grave (art. 107.6) y la producción deliberada, muy grave (art. 106.7). La ley no gradúa por potencia ni por duración, y no importa a quién se interfiera mientras sea una red o servicio autorizado.], tema: "R9")
#pq(9, 2, 30, "b", "estúdialo en: simulacros de estudio 10·2·30 · libro: F-R9.5", "Plazo mínimo de alegaciones: quince días hábiles",
  [En un procedimiento sancionador de telecomunicaciones, ¿cuál de estos plazos de alegaciones cumple lo que exige el art. 114.2 de la Ley 11/2022?],
  ([quince días naturales], [veinte días hábiles], [diez días hábiles], [doce días hábiles],),
  sol: [El art. 114.2 exige un plazo de alegaciones de, como mínimo, quince días hábiles: la Administración puede dar más, pero no menos. Veinte días hábiles lo cumple. Diez o doce días hábiles se quedan cortos, y quince días naturales dan menos tiempo que quince hábiles.], tema: "R9")
#fin-prueba()
#soluciones-simulacro(9)

// ======================================================================
#simulacro(10)
#prueba(10, 1)
#pq(10, 1, 1, "a", "estúdialo en: simulacros de estudio 3·1·1, 8·1·2 · libro: T1.42, C-T1.29", "Asociación de pilas: en serie se suman las tensiones; en paralelo, las corrientes (y baja la resistencia interna)",
  [Un equipo de 12 V pide más corriente de la que puede dar una sola batería de 12 V. Para alimentarlo con varias baterías iguales de 12 V, hay que conectarlas:],
  ([en paralelo: todos los positivos unidos y todos los negativos unidos], [en serie: el positivo de cada una con el negativo de la siguiente], [en serie, con una resistencia que absorba la tensión sobrante], [en paralelo, uniendo el positivo de cada una con el negativo de la otra],),
  sol: [En paralelo la tensión del conjunto es la de una sola batería (12 V) y la corriente total se reparte entre todas, así que el conjunto puede dar más amperios. En serie se sumarían las tensiones, y la corriente disponible seguiría siendo la de una sola batería aunque se intercalara una resistencia. Unir el positivo de una con el negativo de otra en paralelo las pondría en cortocircuito.], tema: "T1")
#pq(10, 1, 2, "d", "estúdialo en: simulacros de estudio 9·1·3", "Onda electromagnética: campos E y B perpendiculares entre sí y a la propagación",
  [Una antena vertical radia una onda que avanza horizontalmente con el campo eléctrico vertical. ¿Cómo es el campo magnético de esa onda?],
  ([vertical, paralelo al campo eléctrico], [nulo, porque la onda tiene polarización vertical], [horizontal y orientado en la misma dirección en que avanza la onda], [horizontal y perpendicular a la dirección de avance],),
  sol: [En una onda electromagnética los campos eléctrico y magnético son perpendiculares entre sí y los dos son perpendiculares a la dirección de propagación. Si el eléctrico es vertical, el magnético tiene que ser horizontal y, además, cruzado respecto al avance: ninguno de los dos apunta en la dirección de propagación. La polarización vertical solo indica hacia dónde apunta el campo eléctrico.], tema: "T1")
#pq(10, 1, 3, "a", "estúdialo en: simulacros de estudio 2·1·1, 13·1·4 · libro: T1.20, F-T1.5", "Conversión entre valores de pico, pico a pico y eficaz de una sinusoide (V_ef = V_p / √2)",
  [¿Qué tensión de pico a pico mide un osciloscopio en una señal sinusoidal de 50 V eficaces?],
  ([141 V], [70,7 V], [100 V], [35,4 V],),
  sol: [El pico es $V_p = V_"ef" sqrt(2) = 50 times 1","414 approx 70","7$ V, y el pico a pico, el doble: unos 141 V. Los 70,7 V son solo el pico; los 100 V duplican el eficaz sin pasar por el pico, y los 35,4 V dividen entre $sqrt(2)$ en lugar de multiplicar.], tema: "T1")
#pq(10, 1, 4, "c", "estúdialo en: simulacros de estudio 11·1·3 · libro: T1.35", "Factor de potencia: coseno del desfase entre tensión y corriente",
  [Una carga alimentada a 230 V eficaces toma 2 A eficaces con un factor de potencia de 0,5. La potencia que consume realmente es de:],
  ([920 W], [460 W], [230 W], [115 W],),
  sol: [La potencia activa es $P = V_"ef" I_"ef" cos phi = 230 times 2 times 0","5 = 230$ W. Los 460 W son la potencia aparente, que ignora el desfase; los 920 W dividen entre el factor de potencia en lugar de multiplicar, y los 115 W lo aplican dos veces.], tema: "T1")
#pq(10, 1, 5, "d", "estúdialo en: simulacros de estudio 12·1·7 · libro: C-T2.3", "Electrolítico: el dieléctrico es una capa de óxido (con el electrolito como pasta)",
  [¿Por qué un condensador electrolítico consigue una capacidad muy grande en poco volumen?],
  ([porque el electrolito almacena la carga por reacción química, como una batería], [porque su dieléctrico es una lámina gruesa de mica, que aguanta mucha tensión], [porque usa aire como dieléctrico, sin pérdidas], [porque su dieléctrico es una capa de óxido finísima, de modo que la separación entre armaduras es minúscula],),
  sol: [En el electrolítico el dieléctrico es una capa de óxido de espesor casi nulo formada sobre el ánodo, en contacto con el electrolito. Como $C = epsilon S / d$ y $d$ es minúsculo, la capacidad resulta enorme. Un dieléctrico grueso, como una lámina de mica, haría justo lo contrario.], tema: "T2")
#pq(10, 1, 6, "c", "estúdialo en: simulacros de estudio 3·1·7 · libro: F-T2.10", "Corrientes en el transformador ideal: van en proporción inversa a las tensiones (potencia constante)",
  [Un transformador ideal reduce 230 V a 23 V. Si el primario toma 0,2 A, ¿qué corriente entrega el secundario?],
  ([0,02 A], [0,2 A], [2 A], [20 A],),
  sol: [En el transformador ideal la potencia se conserva ($V_p I_p = V_s I_s$): si la tensión baja 10 veces, la corriente sube 10 veces, de 0,2 A a 2 A. Bajar la corriente igual que la tensión (0,02 A) violaría la conservación de la potencia, y 20 A supondría aplicar el cuadrado de la relación.], tema: "T2")
#pq(10, 1, 7, "a", "estúdialo en: simulacros de estudio 7·1·8, 13·1·8 · libro: T2.22, F-T2.14", "Diodo zéner: estabiliza tensión trabajando en inversa, en la zona de ruptura",
  [Por error, un zéner de 9,1 V se monta al revés (polarizado en directa) en un estabilizador alimentado con 12 V. ¿Qué tensión aproximada habrá en la carga?],
  ([unos 0,6 V], [9,1 V], [unos 2,9 V], [12 V],),
  sol: [El zéner solo fija su tensión nominal trabajando en inversa, en la zona de ruptura. Polarizado en directa se comporta como un diodo de silicio corriente y conduce a unos 0,6 V, que es lo que queda en la carga. Los 2,9 V salen de restar 9,1 a 12, que es la caída en la resistencia, no la tensión de salida.], tema: "T2")
#pq(10, 1, 8, "a", "estúdialo en: simulacros de estudio 4·1·8, 10·1·9 · libro: T2.23, T2.24", "Transistor bipolar: terminales emisor, base y colector; tipos NPN y PNP",
  [En un transistor bipolar, ¿cómo se llama la capa central, muy fina, que gobierna el paso de portadores entre los otros dos terminales?],
  ([base], [colector], [puerta], [emisor],),
  sol: [El bipolar son dos uniones enfrentadas con una capa central muy fina, la base. El emisor lanza los portadores y el colector los recoge; una pequeña corriente de base gobierna la grande de colector. La puerta es el terminal de control del FET.], tema: "T2")
#pq(10, 1, 9, "c", "estúdialo en: simulacros de estudio 13·1·9 · libro: T2.48", "Polarización: en el NPN el colector es positivo; en el PNP, negativo",
  [Un amplificador de emisor común con un transistor NPN funciona con +12 V en el colector respecto del emisor. Para montar el mismo circuito con un transistor PNP, la tensión del colector respecto del emisor debe ser:],
  ([12 V alternos], [+24 V], [−12 V], [+12 V, igual que en el NPN],),
  sol: [En el NPN el colector es positivo respecto del emisor; en el PNP todo se invierte y el colector trabaja a potencial negativo respecto de la base y del emisor. Por eso los circuitos con PNP llevan la alimentación negativa. Mantener +12 V con un PNP es la forma de destruirlo.], tema: "T2")
#pq(10, 1, 10, "b", "estúdialo en: simulacros de estudio 9·1·9", "Resonancia serie (Z mínima) frente a paralelo o tanque (Z máxima); LC serie en derivación = trampa",
  [Un circuito LC serie, resonante a la frecuencia de trabajo, se intercala en serie en la línea que va del transmisor a la antena. A esa frecuencia:],
  ([bloquea la potencia, porque su impedancia es máxima], [deja pasar prácticamente toda la potencia, porque su impedancia es mínima], [solo deja pasar la potencia de las frecuencias alejadas de la resonancia], [lleva la potencia a masa, como una trampa],),
  sol: [Un LC serie en resonancia presenta su impedancia mínima, solo la pequeña resistencia de pérdidas. Intercalado en serie con la línea, deja pasar esa frecuencia casi sin pérdida; lejos de ella su reactancia crece y la frena. La impedancia máxima es la del tanque paralelo, y el efecto de trampa solo aparece si el LC serie se conecta en derivación, entre la línea y masa.], tema: "T3")
#pq(10, 1, 11, "d", "estúdialo en: simulacros de estudio 1·1·12 · libro: C-T3.9", "Función del rectificador: convertir la alterna en continua (pulsante)",
  [En una fuente de alimentación, el bloque que convierte la tensión alterna del secundario en una tensión de un solo signo, aunque todavía pulsante, es:],
  ([el condensador de filtro], [el transformador], [el regulador], [el rectificador],),
  sol: [El rectificador, con sus diodos, hace que la corriente circule siempre en el mismo sentido: convierte la alterna en continua pulsante. El transformador solo cambia el valor de la alterna; el filtro alisa la tensión ya rectificada y el regulador la fija frente a variaciones de red y de carga.], tema: "T3")
#pq(10, 1, 12, "b", "estúdialo en: simulacros de estudio 1·1·13 · libro: T3.20", "Realimentación: devolver parte de la salida a la entrada; la negativa reduce la ganancia y mejora estabilidad y linealidad, la positiva hace oscilar",
  [Si en un amplificador una parte de la señal de salida vuelve a la entrada en fase y con ganancia suficiente, el circuito:],
  ([amplía su ancho de banda sin otro efecto], [oscila por sí solo], [pierde toda su ganancia], [se estabiliza y reduce su distorsión],),
  sol: [Devolver a la entrada parte de la salida en fase es realimentación positiva: lo devuelto refuerza la entrada y, con ganancia suficiente, el amplificador se convierte en oscilador. Estabilizarse, reducir la distorsión y ampliar el ancho de banda a costa de ganancia son los efectos de la realimentación negativa.], tema: "T3")
#pq(10, 1, 13, "c", "estúdialo en: simulacros de estudio 10·1·14 · libro: T3.45", "Oscilador a cristal: frecuencia muy estable (y apenas ajustable)",
  [Un inconveniente de un oscilador controlado por cristal frente a un VFO es que:],
  ([necesita un varicap para mantener la oscilación], [su frecuencia deriva mucho con la temperatura], [su frecuencia apenas puede moverse, de modo que cada frecuencia exige su propio cristal], [su señal es poco estable a corto plazo],),
  sol: [El cristal fija la frecuencia con una estabilidad excelente, porque la determina la geometría de la lámina, pero por eso mismo apenas puede ajustarse: los equipos antiguos de canales llevaban un cristal por canal. La deriva térmica y la poca estabilidad son justamente los defectos que el cristal evita.], tema: "T3")
#pq(10, 1, 14, "d", "estúdialo en: simulacros de estudio 3·1·14 · libro: F-T3.27", "Sintetizador PLL: f_out = N·f_ref; el paso de canal es f_ref",
  [El VCO de un sintetizador PLL está enganchado en 145,000 MHz con el divisor programable en N = 5 800. La frecuencia de referencia, que es también el paso entre canales, es de:],
  ([250 kHz], [12,5 kHz], [2,5 kHz], [25 kHz],),
  sol: [Como $f_"out" = N dot f_"ref"$, $f_"ref" = 145000 "kHz" slash 5800 = 25$ kHz. Cada unidad que se suma o se resta al divisor mueve la salida una frecuencia de referencia, así que ese es también el paso de canal. Los 12,5 kHz corresponderían a $N = 11600$; 2,5 kHz y 250 kHz son errores de una potencia de diez.], tema: "T3")
#pq(10, 1, 15, "a", "estúdialo en: simulacros de estudio 3·1·15 · libro: T4.1", "Orden de etapas del superheterodino: RF → mezclador → FI → detector → BF",
  [Siguiendo la señal desde la antena hasta el altavoz de un superheterodino, la primera etapa cuya salida es ya de audiofrecuencia es:],
  ([el demodulador (detector)], [el amplificador de RF], [el mezclador], [el amplificador de FI],),
  sol: [El orden es amplificador de RF, mezclador, amplificador de FI, demodulador y amplificador de BF. Hasta el detector la señal sigue siendo de radiofrecuencia: el mezclador solo la traslada a la FI, que es también RF. Es el demodulador el que entrega el audio que luego amplifica la etapa de BF.], tema: "T4")
#pq(10, 1, 16, "c", "estúdialo en: simulacros de estudio 9·1·15 · libro: F-T4.8", "Intermodulación de tercer orden: productos en 2f1 − f2 y 2f2 − f1, dentro de banda",
  [En la banda de 20 m hay dos estaciones muy fuertes en 14,200 y 14,210 MHz, y tu receptor muestra una señal que no existe en el aire en 14,190 MHz. Lo más probable es que sea:],
  ([la frecuencia imagen de la estación de 14,200 MHz], [un producto de intermodulación de segundo orden], [un producto de intermodulación de tercer orden], [el segundo armónico de una de las dos estaciones],),
  sol: [$2 f_1 - f_2 = 2 times 14","200 - 14","210 = 14","190$ MHz: es un producto de tercer orden, que cae junto a las señales, dentro de la banda, y lo fabrica la no linealidad del receptor. Los de segundo orden son la suma y la diferencia (28,410 y 0,010 MHz), lejos de la banda. La imagen está a dos FI de la sintonizada, y un segundo armónico estaría en 28 MHz.], tema: "T4")
#pq(10, 1, 17, "b", "estúdialo en: simulacros de estudio 3·1·18 · libro: F-T5.11", "FM directa: el audio actúa sobre el oscilador (varicap)",
  [En un oscilador modulado en FM mediante un varicap, al aumentar la tensión inversa aplicada al varicap:],
  ([sube su capacidad y sube la frecuencia del oscilador], [baja su capacidad y sube la frecuencia del oscilador], [baja su capacidad y baja la frecuencia del oscilador], [la frecuencia no cambia; solo varía la amplitud de salida],),
  sol: [El varicap polarizado en inversa se comporta como un condensador cuya capacidad baja al subir la tensión. Como $f_0 = 1 slash (2 pi sqrt(L C))$, menos capacidad da más frecuencia: el audio, sumado a la polarización, mueve así la frecuencia del propio oscilador. Variar la amplitud sería AM, no FM.], tema: "T5")
#pq(10, 1, 18, "d", "estúdialo en: simulacros de estudio 8·1·18 · libro: T5.1", "Impedancia de salida típica: 50 Ω",
  [Para que un transmisor de radioaficionado vea una ROE de 1:1, la carga artificial que se conecta en lugar de la antena debe ser una resistencia no inductiva de:],
  ([25 Ω], [75 Ω], [450 Ω], [50 Ω],),
  sol: [La impedancia de salida estándar de los transmisores de aficionado es de 50 Ω, común a línea y antena; una carga artificial de ese valor es para el transmisor una antena perfecta. Los 75 Ω son propios de la televisión y otras impedancias darían una ROE distinta de 1:1.], tema: "T5")
#pq(10, 1, 19, "c", "estúdialo en: simulacros de estudio 4·1·21 · libro: C-T6.18", "Antenas de apertura: bocina y reflector parabólico (no las de hilo)",
  [Las antenas de apertura, como la bocina y el reflector parabólico, se emplean sobre todo:],
  ([en las bandas bajas de HF, por su pequeño tamaño], [en onda media, para la radiodifusión], [en microondas, donde la longitud de onda mide centímetros], [en cualquier banda, porque su ganancia no depende de la longitud de onda],),
  sol: [En microondas la longitud de onda es de centímetros y resulta fácil construir una boca de muchas longitudes de onda de ancho; la ganancia depende del área de esa boca medida en longitudes de onda. La misma parábola en una banda baja tendría una ganancia insignificante. En HF dominan las antenas de hilo: dipolos, verticales y Yagis.], tema: "T6")
#pq(10, 1, 20, "b", "estúdialo en: simulacros de estudio 3·1·20 · libro: C-T6.2", "Antena omnidireccional: radia igual en todo el plano horizontal (el dipolo, en el plano perpendicular al hilo)",
  [Un dipolo de media onda montado horizontalmente, visto desde arriba, radia:],
  ([por igual hacia todos los rumbos del horizonte], [al máximo en las direcciones perpendiculares al hilo y casi nada hacia sus puntas], [al máximo en la dirección de sus puntas], [solo hacia uno de los lados del hilo],),
  sol: [El dipolo radia al máximo perpendicularmente al hilo y nada en su dirección: montado en horizontal, el corte visto desde arriba es un «ocho» con nulos en las puntas. Solo montado en vertical es omnidireccional en el plano horizontal. Radiar hacia un solo lado exige elementos parásitos, como en una Yagi.], tema: "T6")
#pq(10, 1, 21, "b", "estúdialo en: simulacros de estudio 7·1·22 · libro: F-T6.6", "Potencia efectiva radiada: p.r.e. = P · G, descontando las pérdidas del cable (en dB)",
  [Para conseguir 100 W de p.r.e. con una antena de 7 dBd y un cable con 1 dB de pérdidas, ¿qué potencia debe dar el transmisor, aproximadamente?],
  ([16 W], [25 W], [20 W], [400 W],),
  sol: [Ganancia neta: 7 − 1 = 6 dB, que equivale a multiplicar la potencia por 4. Como p.r.e. = P · G, la potencia del transmisor es 100 / 4 = 25 W. Los 20 W salen de olvidar el cable (7 dB ≈ ×5), los 16 W de sumar la pérdida a la ganancia (8 dB ≈ ×6,3) y los 400 W de multiplicar en vez de dividir.], tema: "T6")
#pq(10, 1, 22, "a", "estúdialo en: simulacros de estudio 5·1·22 · libro: T6.33", "Longitud física = longitud eléctrica × FV (la física es menor); cálculo de un tramo",
  [Un tramo de coaxial de 6,6 m de longitud física se comporta como media onda eléctrica a 15 MHz. Su factor de velocidad es:],
  ([0,66], [1,32], [1,5], [0,33],),
  sol: [A 15 MHz, $lambda = 300 slash 15 = 20$ m y la media onda eléctrica mide 10 m. Como $L_"fís" = L_"el" times "FV"$, FV = 6,6 / 10 = 0,66. El 1,5 sale de dividir al revés (un FV mayor que 1 es imposible: la longitud física siempre es menor que la eléctrica), el 0,33 de comparar con la onda completa y el 1,32 de comparar con un cuarto de onda.], tema: "T6")
#pq(10, 1, 23, "c", "estúdialo en: simulacros de estudio 5·1·23 · libro: C-T7.6", "Nomenclatura de las bandas: sigla y nombre por longitud de onda (HF decamétricas, MF hectométricas, VHF métricas, UHF decimétricas, SHF centimétricas)",
  [¿Cuál de estas parejas de sigla y nombre por longitud de onda es correcta?],
  ([VHF: ondas decimétricas], [MF: ondas decamétricas], [SHF: ondas centimétricas], [UHF: ondas métricas],),
  sol: [SHF va de 3 a 30 GHz, es decir, de 10 a 1 cm: ondas centimétricas. Las otras tres desplazan el nombre un escalón: UHF son decimétricas, VHF métricas y MF hectométricas (decamétricas es HF). Basta un ancla, HF = decamétricas, y contar escalones: cada década más de frecuencia es un escalón menos de tamaño.], tema: "T7")
#pq(10, 1, 24, "b", "estúdialo en: simulacros de estudio 10·1·24 · libro: F-T7.1", "Pérdida en espacio libre y relación señal/ruido: 20 log d y 20 log f (×10 la distancia: −20 dB)",
  [En un enlace en espacio libre se doblan a la vez la distancia y la frecuencia. La pérdida de trayecto aumenta aproximadamente:],
  ([6 dB], [12 dB], [24 dB], [nada, porque los dos efectos se compensan],),
  sol: [En $L = 32","4 + 20 log f + 20 log d$, doblar la distancia suma $20 log 2 approx 6$ dB y doblar la frecuencia otros 6 dB: en total, unos 12 dB. Los 6 dB cuentan solo uno de los dos cambios, y los 24 dB salen de usar $40 log$. Los efectos no se compensan: ambos términos suman pérdida.], tema: "T7")
#pq(10, 1, 25, "b", "estúdialo en: simulacros de estudio 1·1·24 · libro: F-T7.4", "Esporádica-E: más frecuente en verano",
  [Desde España, ¿qué combinación de época y hora es la más favorable para encontrar esporádica-E en 50 MHz?],
  ([un mediodía de octubre], [una tarde de junio], [una noche de marzo], [una madrugada de diciembre],),
  sol: [La esporádica-E es típica de finales de primavera y del verano, de día y al atardecer: una tarde de junio reúne la época y la hora. Diciembre es el mes de las Gemínidas, una lluvia de meteoros (otro mecanismo), y ni marzo ni octubre son su temporada.], tema: "T7")
#pq(10, 1, 26, "a", "estúdialo en: simulacros de estudio 7·1·26 · libro: T8.5", "Medida de potencia de RF con vatímetro",
  [Para comprobar sin radiar que un transmisor entrega su potencia nominal de 100 W, a su salida se conecta:],
  ([un vatímetro de RF seguido de una carga artificial de 50 Ω], [un polímetro en la escala de alterna, en paralelo con la antena], [un óhmetro entre el vivo y la malla del conector de antena], [un frecuencímetro seguido de la antena],),
  sol: [La potencia de RF se mide con un vatímetro intercalado en la línea, y la carga artificial ocupa el lugar de la antena, disipando la potencia en calor sin radiarla. El polímetro no sirve en RF, el óhmetro no mide potencia y el frecuencímetro mide frecuencia; además, con la antena conectada se radiaría.], tema: "T8")
#pq(10, 1, 27, "d", "estúdialo en: simulacros de estudio 11·1·27 · libro: T8.29", "El medidor de ROE es el instrumento más imprescindible de la estación",
  [¿Por qué el medidor de ROE no debería faltar nunca en una estación de aficionado?],
  ([porque mide la intensidad de campo radiado por la antena], [porque muestra los armónicos y las emisiones espurias del transmisor], [porque mide con precisión la frecuencia emitida], [porque avisa de la desadaptación entre el equipo y la antena, origen de la mayoría de los problemas y de averías del paso final],),
  sol: [Su función es avisar de que algo va mal entre el equipo y la antena, que es de donde vienen la mayoría de los problemas, y una desadaptación puede averiar el paso final. La frecuencia se mide con el frecuencímetro, los armónicos con el analizador de espectros y el campo radiado con el medidor de campo.], tema: "T8")
#pq(10, 1, 28, "d", "estúdialo en: simulacros de estudio 7·1·28 · libro: C-T9.4", "La emisión de armónicos y espurias implica riesgo de interferencias en cualquier banda",
  [Un transmisor emite en 14,2 MHz. ¿En qué frecuencia cae su tercer armónico?],
  ([17,2 MHz], [28,4 MHz], [4,73 MHz], [42,6 MHz],),
  sol: [Los armónicos caen en múltiplos enteros de la fundamental: el tercero está en $3 dot 14","2 = 42","6$ MHz, fuera de la banda de trabajo y donde puede molestar a otros servicios. 28,4 MHz es el segundo armónico, y nunca aparecen en submúltiplos como 4,73 MHz.], tema: "T9")
#pq(10, 1, 29, "d", "estúdialo en: simulacros de estudio 13·1·29 · libro: T10.16", "Antes de manipular un equipo: desconectarlo de la red y descargar los condensadores",
  [Se desenchufa un amplificador de válvulas y, un minuto después, se va a abrir para repararlo. Lo correcto es:],
  ([abrirlo ya, porque al estar desenchufado no queda tensión], [confiar en la resistencia de descarga, que vacía los condensadores al instante], [volver a enchufarlo para localizar la avería con el equipo en marcha], [descargar los condensadores con una punta de descarga unida a masa y comprobar con el voltímetro que no queda tensión],),
  sol: [Los condensadores de filtro conservan la carga después de desenchufar, y en un equipo valvular pueden estar a miles de voltios. La resistencia de descarga los vacía de forma exponencial, en decenas de segundos, y puede haberse abierto sin que nadie lo sepa. Por eso, además de desenchufar, hay que descargarlos con una punta a masa y medir antes de meter la mano.], tema: "T10")
#pq(10, 1, 30, "b", "estúdialo en: simulacros de estudio 11·1·30 · libro: T10.12", "Magnetotérmico: sobrecargas y cortocircuitos",
  [De los dos mecanismos de un magnetotérmico, el magnético es el que dispara:],
  ([ante las sobretensiones de origen atmosférico], [de forma instantánea ante un cortocircuito], [lentamente ante una sobrecarga mantenida], [cuando parte de la corriente se fuga a tierra],),
  sol: [El magnetotérmico reúne dos mecanismos: una lámina bimetálica (la parte térmica), que dispara despacio ante sobrecargas mantenidas, y una bobina (la parte magnética), que dispara al instante ante un cortocircuito. La fuga a tierra es cosa del diferencial.], tema: "T10")
#fin-prueba()
#prueba(10, 2)
#pq(10, 2, 1, "a", "estúdialo en: simulacros de estudio 1·2·1 · libro: C-R1.2", "Deletreo de distintivo EA5SWJ: E Echo, A Alfa, S Sierra, W Whiskey, J Juliett (no «Japón»), cifra en inglés",
  [Un corresponsal deletrea su distintivo: «Echo Alfa Five Juliett Whiskey Sierra». ¿Qué anotas?],
  ([`EA5JWS`], [`EA5JVS`], [`EA5GWS`], [`EA5JWC`],),
  sol: [Echo es E, Alfa es A, Five es 5, Juliett es J, Whiskey es W y Sierra es S. Whiskey no es la V, que es Victor; Juliett no es la G, que es Golf, y Sierra no es la C, que es Charlie.], tema: "R1")
#pq(10, 2, 2, "d", "estúdialo en: simulacros de estudio 2·2·3 · libro: C-R2.4", "QRA nombre de la estación (no la posición)",
  [Quieres preguntar en CW cómo se llama la estación con la que estás comunicando. Transmites:],
  ([`QTH?`], [`QRK?`], [`QRB?`], [`QRA?`],),
  sol: [`QRA` es el nombre de la estación: «¿cómo se llama su estación?». No es la posición, que es `QTH`; `QRB` es la distancia entre estaciones y `QRK`, la inteligibilidad de las señales.], tema: "R2")
#pq(10, 2, 3, "c", "estúdialo en: simulacros de estudio 4·2·4 · libro: R2.23", "QSV transmita una serie de V",
  [Para ajustar la sintonía y el filtro del receptor sobre la señal de tu corresponsal, le pides que transmita una serie de una misma letra. ¿Qué grupo usas y qué letra transmitirá?],
  ([`QSV`, y transmitirá una serie de letras S], [`QRV`, y transmitirá una serie de letras V], [`QSV`, y transmitirá una serie de letras V], [`QSZ`, y repetirá varias veces la misma letra],),
  sol: [`QSV` pide transmitir una serie de V, cuyo ritmo en Morse es inconfundible y sirve para ajustar la recepción. `QRV` es «estoy dispuesto», aunque termine en V, y `QSZ` pide transmitir cada palabra o grupo dos veces.], tema: "R2")
#pq(10, 2, 4, "b", "estúdialo en: simulacros de estudio 10·2·4 · libro: R3.12", "DE delante del distintivo de quien transmite",
  [En la llamada «EA1ABC DE EA4XYZ K», ¿qué estación está transmitiendo?],
  ([EA1ABC, que llama a EA4XYZ], [EA4XYZ, que llama a EA1ABC], [ninguna en concreto: es una llamada general], [las dos, una tras otra],),
  sol: [`DE` va delante del distintivo de quien transmite: primero se nombra a quien se llama (EA1ABC) y, tras `DE`, quien llama (EA4XYZ). No es una llamada general, que llevaría `CQ`.], tema: "R3")
#pq(10, 2, 5, "b", "estúdialo en: simulacros de estudio 10·2·5 · libro: F-R3.3", "Informe RST: R legibilidad 1–5, S intensidad 1–9, T tono 1–9",
  [Un corresponsal te pasa en telegrafía «`UR RST 479`». ¿Qué te está diciendo?],
  ([legibilidad 4, intensidad 7 y potencia 9], [legibilidad 4 (casi sin dificultad), intensidad 7 y tono 9 (puro)], [intensidad 4, legibilidad 7 y tono 9], [legibilidad 4, tono 7 e intensidad 9],),
  sol: [Las cifras van en el orden R, S, T: legibilidad (1 a 5), intensidad (1 a 9) y tono (1 a 9). Un 4 de legibilidad es «prácticamente sin dificultad», el 7 es una señal bastante fuerte y el 9, un tono puro. Las demás opciones cambian el orden o meten la potencia, que no forma parte del informe.], tema: "R3")
#pq(10, 2, 6, "c", "estúdialo en: simulacros de estudio 12·2·6 · libro: R3.38", "SRI lo siento",
  [Has interrumpido sin querer a otra estación y quieres disculparte. ¿Qué abreviatura usas?],
  ([`BK`], [`TU`], [`SRI`], [`PSE`],),
  sol: [`SRI` (\_sorry\_) es «lo siento». `PSE` es «por favor», `TU` es «gracias» y `BK` sirve para interrumpir, no para disculparse por haberlo hecho.], tema: "R3")
#pq(10, 2, 7, "d", "estúdialo en: simulacros de estudio 4·2·7 · libro: C-R3.4", "NR número",
  [En un concurso intercambias «`UR RST 599 NR 025`». El dato que sigue a `NR` es:],
  ([la distancia, en kilómetros], [la potencia, en vatios], [el modelo de receptor], [el número de serie del contacto],),
  sol: [`NR` (\_number\_) es «número»: en un concurso, el número de serie que se intercambia. No es el receptor (`RX`) ni la potencia (`PWR`).], tema: "R3")
#pq(10, 2, 8, "c", "estúdialo en: simulacros de estudio 8·2·9 · libro: F-R4.6", "Banda de 40 m en la Región 1: 7000–7200 kHz",
  [Estás en España y quieres transmitir en fonía en 7250 kHz. ¿Puedes hacerlo?],
  ([Sí, con la mitad de potencia, porque es un tramo secundario], [Sí, pero solo en telegrafía], [No: en la Región 1 la banda de 40 m termina en 7200 kHz y de 7200 a 7300 kHz es radiodifusión], [Sí: la banda de 40 m llega hasta 7300 kHz],),
  sol: [En la Región 1, España incluida, la banda de 40 m va de 7000 a 7200 kHz, y de 7200 a 7300 kHz es radiodifusión. El límite de 7300 kHz es el de la Región 2 (América) y no vale aquí.], tema: "R4")
#pq(10, 2, 9, "d", "estúdialo en: simulacros de estudio 2·2·10 · libro: F-R4.7", "Banda de 10 m: 28–29,7 MHz",
  [¿Cuál de estas frecuencias queda fuera de la banda de aficionados de 10 m en España?],
  ([28,500 MHz], [28,050 MHz], [29,600 MHz], [29,850 MHz],),
  sol: [La banda de 10 m va de 28 a 29,7 MHz. 29,850 MHz se pasa del límite superior: de 29,7 a 30,005 MHz las atribuciones son de fijo y móvil. Las demás caen dentro, incluida 29,600 MHz, cerca del extremo alto.], tema: "R4")
#pq(10, 2, 10, "b", "estúdialo en: simulacros de estudio 1·2·10, 8·2·10 · libro: R7.8", "Cuándo identificarse: al comienzo y al final de cada emisión, siempre, y en las largas al menos cada 10 min",
  [Llevas diez minutos hablando sin interrupción en una emisión larga y solo diste tu distintivo al comenzar. Según la Orden IET/1311/2013, ahora debes:],
  ([seguir hasta que pasen treinta minutos desde el comienzo y entonces darlo], [volver a transmitir tu distintivo, sin esperar al final de la emisión], [esperar al final de la emisión, que es cuando corresponde volver a darlo], [darlo solo si otra estación te lo pide],),
  sol: [El art. 29 exige el distintivo al comienzo y al final de cada emisión y, en las de larga duración, al menos cada diez minutos. Esperar al final dejaría a quien sintoniza a mitad de la emisión sin saber quién transmite.], tema: "R5")
#pq(10, 2, 11, "b", "estúdialo en: simulacros de estudio 1·2·11 · libro: F-R5.5", "Licencia CEPT en telefonía: entre el prefijo y el distintivo se dice «stroke»",
  [Un radioaficionado francés con distintivo F5ABC opera en España con licencia CEPT y en telegrafía se identifica como EA/F5ABC. En telefonía lo dirá así:],
  ([«Foxtrot Five Alfa Bravo Charlie stroke Echo Alfa»], [«Echo Alfa stroke Foxtrot Five Alfa Bravo Charlie»], [«Foxtrot Five Alfa Bravo Charlie de Echo Alfa»], [«Echo Alfa Foxtrot Five Alfa Bravo Charlie portable»],),
  sol: [Con la licencia CEPT, el prefijo del país visitado va delante del distintivo nacional, separado por «/» en telegrafía y por la palabra stroke en telefonía. Invertir el orden es el error típico: primero dónde se está y después quién se es; «portable» se usa para otra cosa.], tema: "R5")
#pq(10, 2, 12, "d", "estúdialo en: simulacros de estudio 6·2·12, 10·2·12 · libro: R5.15, C-R5.11", "Prefijos temporales ED, EE y EF: eventos ordinarios; mantienen el resto del distintivo",
  [Un radioclub organiza una demostración de radio en un colegio, un evento de ámbito local sin especial relevancia. El prefijo temporal que le corresponde solicitar es:],
  ([EG], [AO], [AN], [EF],),
  sol: [ED, EE y EF son los prefijos de los eventos ordinarios: concursos, experimentos, ensayos, demostraciones y otros de ámbito local a nacional. EG se reserva a concursos, eventos internacionales y eventos relevantes, AN a los relevantes de ámbito nacional y AO a los de ámbito internacional.], tema: "R5")
#pq(10, 2, 13, "c", "estúdialo en: simulacros de estudio 2·2·12 · libro: R5.14", "Prefijos EG y EH: concursos, eventos internacionales y eventos relevantes locales, regionales o autonómicos",
  [Para una conmemoración relevante de ámbito autonómico, el prefijo temporal adecuado es:],
  ([EC], [AO], [EH], [AM],),
  sol: [EG y EH se destinan a concursos, eventos internacionales y eventos relevantes de ámbito local, regional o autonómico. AM es para los relevantes de ámbito nacional, AO para los internacionales y EC es un prefijo habitual, no temporal.], tema: "R5")
#pq(10, 2, 14, "a", "estúdialo en: simulacros de estudio 4·2·14 · libro: R6.4", "Los planes parten de las atribuciones del Reglamento de Radiocomunicaciones y hay uno por Región de la UIT",
  [¿Por qué la IARU no tiene un único plan de bandas para todo el mundo?],
  ([Porque los planes parten de las atribuciones del Reglamento de Radiocomunicaciones, que son distintas en cada Región de la UIT], [Porque solo la Región 1 tiene plan de bandas], [Porque cada asociación nacional redacta su propio plan], [Porque los planes dependen del huso horario de cada zona],),
  sol: [Los planes de la IARU tienen en cuenta la atribución de bandas del Reglamento de Radiocomunicaciones, y como esa atribución se hace región por región, hay un plan por cada Región de la UIT. No hay un plan por país ni depende del huso horario.], tema: "R6")
#pq(10, 2, 15, "d", "estúdialo en: simulacros de estudio 2·2·15 · libro: F-R6.11", "Frecuencia de llamada de FM en 70 cm: 433,500 MHz",
  [Contestas en FM a una estación que llama en 433,500 MHz y os quedáis en esa frecuencia todo el QSO. Según el plan de la IARU para la Región 1, el problema es que estáis ocupando:],
  ([el segmento de balizas de 70 cm], [el centro de actividad de SSB de 70 cm], [la entrada de un repetidor de 70 cm], [la frecuencia de llamada de FM de 70 cm, que debe quedar libre como punto de encuentro],),
  sol: [En 70 cm la frecuencia de llamada de FM es 433,500 MHz: se llama allí y, al contestar, se pasa a otra frecuencia libre. El centro de SSB está en 432,200 MHz, las entradas de repetidores en 433,000–433,375 MHz y las balizas en 432,400–432,490 MHz.], tema: "R6")
#pq(10, 2, 16, "b", "estúdialo en: simulacros de estudio 11·2·17 · libro: R7.7", "Deletrear con el alfabeto fonético internacional; no inventar palabras",
  [Un corresponsal extranjero no entiende la letra Q de tu indicativo. Para deletreársela debes decir:],
  ([Quijote], [Quebec], [Queen], [Quito],),
  sol: [Se deletrea con el alfabeto fonético internacional, cuyas palabras se eligieron para no confundirse entre sí; en él la Q es Quebec. Queen es el error más frecuente, y usar palabras propias como Quito o Quijote obliga al corresponsal a adivinar.], tema: "R7")
#pq(10, 2, 17, "a", "estúdialo en: simulacros de estudio 6·2·17 · libro: F-R8.11", "RD 123/2017: Reglamento sobre el uso del dominio público radioeléctrico",
  [La Orden IET/1311/2013 todavía cita el Real Decreto 863/2008 como reglamento de uso del dominio público radioeléctrico. Hoy esa función la cumple el:],
  ([Real Decreto 123/2017], [Real Decreto 244/2010], [Real Decreto 2623/1986], [Real Decreto 1890/2000],),
  sol: [El Real Decreto 123/2017 aprueba el Reglamento sobre el uso del dominio público radioeléctrico y derogó el Real Decreto 863/2008. Los otros reales decretos también los cita la Orden, pero para otras materias: el 2623/1986 regula las antenas de aficionado, el 1890/2000 la evaluación de la conformidad de los aparatos y el 244/2010 la actividad de los instaladores.], tema: "R8")
#pq(10, 2, 18, "c", "estúdialo en: simulacros de estudio 5·2·18 · libro: F-R8.64", "Repetidores y radiobalizas: telemando y alimentación ininterrumpida ≥ 6 h",
  [Una asociación instala una radiobaliza en una cumbre de difícil acceso. Según el artículo 25.g, ¿cuál de estos elementos es obligatorio?],
  ([un grupo electrógeno con autonomía de veinticuatro horas], [un operador que la atienda mientras emite], [un dispositivo de encendido y apagado por telemando], [una antena directiva orientada hacia la zona más poblada],),
  sol: [El art. 25.g exige a repetidores y radiobalizas un dispositivo de encendido y apagado por telemando, para conectarlas o desconectarlas sin acudir al emplazamiento, y un sistema de alimentación ininterrumpida de al menos seis horas. No pide grupo electrógeno ni veinticuatro horas de autonomía. Un operador de guardia contradice la idea de estación desatendida, y la antena de una radiobaliza es, como norma general, omnidireccional.], tema: "R8")
#pq(10, 2, 19, "a", "estúdialo en: simulacros de estudio 13·2·18 · libro: F-R8.63", "Radiobaliza: sistema radiante omnidireccional",
  [Al diseñar una radiobaliza de 2 m, ¿qué sistema radiante se ajusta a la norma general del artículo 25.f?],
  ([una antena omnidireccional, que radie por igual en todas las direcciones del plano horizontal], [una Yagi de alta ganancia apuntada hacia la zona más poblada], [una antena directiva giratoria que vaya barriendo el horizonte], [una antena de polarización circular, obligatoria en las radiobalizas],),
  sol: [Como norma general, el sistema radiante de una radiobaliza es omnidireccional: así cualquier estación puede oírla, esté en la dirección que esté, y valorar la propagación. Una Yagi fija deja sin señal el resto de direcciones, y una antena giratoria solo cubre cada dirección a ratos. La norma no exige polarización circular.], tema: "R8")
#pq(10, 2, 20, "a", "estúdialo en: simulacros de estudio 3·2·17, 7·2·19 · libro: C-R8.8, C-T7.3", "Nomenclatura de bandas: números, símbolos (HF, VHF, SHF…), rangos y ondas (métricas, B.m.…)",
  [¿Qué símbolo, tipo de onda y rango de frecuencias tiene la banda número 7 de la nomenclatura del anexo I?],
  ([HF, ondas decamétricas, de 3 a 30 MHz], [VHF, ondas métricas, de 30 a 300 MHz], [HF, ondas hectométricas, de 3 a 30 MHz], [MF, ondas hectométricas, de 300 a 3000 kHz],),
  sol: [La banda 7 es la HF, de 3 a 30 MHz, con longitudes de onda de 100 a 10 m: ondas decamétricas (B.dam). Truco: la banda N va de $0","3 times 10^N$ a $3 times 10^N$ Hz, y para N = 7 da de 3 a 30 MHz. La VHF es la banda 8 y la MF, la 6; la última opción acierta símbolo y rango pero cambia el tipo de onda.], tema: "R8")
#pq(10, 2, 21, "b", "estúdialo en: simulacros de estudio 5·2·22 · libro: F-R8.29", "Solicitud de autorización: preferentemente por medios electrónicos, con modelo oficial",
  [Respecto de la presentación de la solicitud de autorización de radioaficionado, es correcto que:],
  ([se presenta en el ayuntamiento del domicilio, que la remite a la SETSI], [puede presentarse en la Jefatura Provincial, aunque la vía preferente es la sede electrónica del Ministerio, con el modelo oficial], [solo se admite por medios electrónicos: la presentada en la Jefatura Provincial se inadmite], [se entrega al tribunal en el mismo acto del examen],),
  sol: [El art. 6 admite presentarla en las Jefaturas Provinciales o en los demás registros que permite la ley, pero señala como preferente la vía electrónica, en la sede del Ministerio y con el modelo oficial. Preferente no significa exclusiva, así que no se inadmite la presentada en papel. Ni el ayuntamiento ni el tribunal de examen intervienen en este trámite.], tema: "R8")
#pq(10, 2, 22, "c", "estúdialo en: simulacros de estudio 6·2·26 · libro: R8.25", "Equipos de construcción propia: sin autorización previa, bajo la responsabilidad del titular (régimen sancionador si interfieren)",
  [Has construido tu propio transmisor para la banda de 40 m. Antes de usarlo en tu estación:],
  ([solo podrás usarlo con una potencia máxima de 10 W], [debes presentarlo en la Jefatura Provincial y esperar a que lo autorice], [no necesitas autorización previa de la Administración, pero respondes de que cumpla las características técnicas del anexo I], [debes obtener su marcado CE mediante un laboratorio acreditado],),
  sol: [Los equipos de construcción propia se usan sin autorización previa, bajo la responsabilidad del radioaficionado, y deben cumplir el anexo I; si interfieren por funcionar mal, el titular queda sometido al régimen sancionador. Presentarlos en la Jefatura es solo optativo. El laboratorio acreditado es la vía de ciertos equipos comerciales de segunda mano, no de los caseros.], tema: "R8")
#pq(10, 2, 23, "d", "estúdialo en: simulacros de estudio 12·2·23 · libro: C-R8.15", "Modificaciones con licencia: permanentes se comunican; cambiar la antena de sitio = primera instalación",
  [Con la licencia de estación fija ya concedida, sustituyes de forma definitiva tu transceptor por otro modelo, sin tocar la antena. ¿Qué debes hacer?],
  ([Solicitarlo a la SETSI como si fuera una primera instalación], [Pedir una autorización especial para usos experimentales], [Nada: los cambios de equipos no se comunican nunca], [Remitir a la SETSI la documentación complementaria que recoja la modificación],),
  sol: [Las modificaciones permanentes de instalaciones y equipos se comunican remitiendo a la SETSI la documentación complementaria con los cambios. Solo el cambio de ubicación de la antena se tramita como una primera instalación, y aquí la antena no se mueve. La autorización especial es para emisiones con características distintas de las del Reglamento, no para cambiar de equipo.], tema: "R8")
#pq(10, 2, 24, "d", "estúdialo en: simulacros de estudio 11·2·22 · libro: F-R8.8", "Copia del contrato de seguro a la propiedad o al presidente de la comunidad",
  [Según el Real Decreto 2623/1986, ¿qué documento debe entregar el titular de una antena de aficionado al presidente de la comunidad de propietarios de su edificio?],
  ([El registro de los comunicados realizados desde la estación], [La memoria técnica completa con los esquemas de sus equipos], [Copia de su certificado HAREC], [Copia del contrato del seguro de responsabilidad civil de la antena y de sus actualizaciones],),
  sol: [El art. 20.3 exige que el contrato de seguro incluya una cláusula que exprese que cumple el art. 2 de la Ley 19/1983 y que se entregue copia de él, y de sus actualizaciones, a la propiedad del inmueble o, en propiedad horizontal, al presidente de la comunidad. Es lo que protege a la comunidad frente a los daños de la antena. Los demás documentos no se entregan a la comunidad.], tema: "R8")
#pq(10, 2, 25, "c", "estúdialo en: simulacros de estudio 8·2·23 · libro: R8.79", "La comunidad dispone de 2 meses para alegar sobre la idoneidad del emplazamiento",
  [La Administración comunica a la comunidad de propietarios una solicitud para instalar antenas de aficionado en el edificio. ¿De cuánto tiempo dispone la comunidad para alegar, y qué ocurre si no contesta?],
  ([Dos meses; si no contesta, se entiende que se opone], [Seis semanas; si no contesta, la solicitud se desestima], [Dos meses; si no contesta, se entiende que acepta], [Un mes; si no contesta, se entiende que acepta],),
  sol: [Aceptada la memoria, la Administración informa a la comunidad, que dispone de dos meses para alegar sobre la idoneidad del emplazamiento o los perjuicios; si no lo hace, se entiende que acepta tácitamente. Las seis semanas con silencio desestimatorio son de la resolución de la autorización, y el mes es el aviso previo a las obras.], tema: "R8")
#pq(10, 2, 26, "b", "estúdialo en: simulacros de estudio 1·2·24 · libro: F-R8.19", "Derechos del predio sirviente (art. 545 CC): la comunidad decide por mayoría simple",
  [Según la Ley 19/1983, la comunidad de propietarios puede ejercer, por mayoría simple, los derechos que el artículo 545 del Código Civil reconoce al dueño del predio sirviente. Esos derechos consisten en:],
  ([obligar al radioaficionado a reducir la potencia de sus emisiones], [variar a su costa el lugar o la forma de la servidumbre cuando le resulte muy incómoda, ofreciendo otro emplazamiento igualmente cómodo], [prohibir de forma definitiva la instalación de la antena], [exigir al radioaficionado un alquiler anual por el uso de la azotea],),
  sol: [Los derechos del predio sirviente permiten variar, a costa de la comunidad, el lugar o la forma de la servidumbre cuando resulte muy incómoda o impida obras importantes, ofreciendo otro igualmente cómodo y sin perjuicio para el titular. Basta para ello la mayoría simple. No permiten prohibir la antena ni regular las emisiones, que son competencia de la Administración.], tema: "R8")
#pq(10, 2, 27, "a", "estúdialo en: simulacros de estudio 4·2·26 · libro: F-R8.48", "Asociación reconocida: por resolución de la SETSI, tras inscribirse en Interior y presentar estatutos",
  [Una asociación de radioaficionados ya legalmente constituida e inscrita en el registro del Ministerio del Interior quiere ser asociación reconocida para poder instalar estaciones colectivas. Según el artículo 18.7, debe:],
  ([solicitarlo acompañando sus estatutos; la condición se obtiene por resolución de la SETSI], [acreditar ante la Jefatura Provincial un número mínimo de socios con autorización], [nada más: la inscripción en el Ministerio del Interior ya le da esa condición], [solicitarlo al Ministerio del Interior, que resuelve tras examinar sus estatutos],),
  sol: [La inscripción en el Ministerio del Interior es un requisito previo, no el reconocimiento. Según el art. 18.7, la asociación solicita el reconocimiento acompañando sus estatutos, y la condición de asociación reconocida se obtiene por resolución de la SETSI. Solo entonces puede ser autorizada a instalar estaciones colectivas (art. 18.6). La norma no exige un número mínimo de socios.], tema: "R8")
#pq(10, 2, 28, "a", "estúdialo en: simulacros de estudio 1·2·27 · libro: C-R8.22", "Estación automática desatendida: estación colectiva que no requiere intervención directa del operador",
  [Según las definiciones del anexo I, la relación entre estación automática desatendida y estación colectiva es:],
  ([toda estación desatendida es colectiva, pero no toda estación colectiva es desatendida], [toda estación colectiva es desatendida, pero no toda desatendida es colectiva], [son lo mismo: las dos expresiones designan a los repetidores], [no guardan relación: la desatendida es una estación individual que su titular acciona a distancia],),
  sol: [El anexo I define la estación automática desatendida como una estación colectiva que, para su funcionamiento habitual, no requiere la intervención directa del operador. Por tanto, toda desatendida es colectiva, pero una colectiva atendida por operadores, como la de un radioclub, no es desatendida. La estación individual accionada a distancia por su titular es la fija remota.], tema: "R8")
#pq(10, 2, 29, "c", "estúdialo en: simulacros de estudio 4·2·28 · libro: F-R9.9", "Muy grave: uso del espectro no adecuado al CNAF",
  [De estas conductas relacionadas con el uso del espectro, ¿cuál es infracción muy grave según la Ley 11/2022?],
  ([utilizar el espectro sin la autorización necesaria], [incumplir las condiciones de la autorización], [utilizar frecuencias o canales de modo no adecuado al Cuadro Nacional de Atribución de Frecuencias], [establecer comunicaciones utilizando estaciones no autorizadas],),
  sol: [El uso no adecuado al CNAF o al plan de utilización del espectro es muy grave (art. 106.5), aunque no cause interferencias. Las otras tres conductas tienen menos grado: usar el espectro sin la autorización necesaria es grave (art. 107.5), y tanto incumplir las condiciones autorizadas (art. 108.5) como comunicarse utilizando estaciones no autorizadas (art. 108.2) son leves.], tema: "R9")
#pq(10, 2, 30, "a", "estúdialo en: simulacros de estudio 6·2·30 · libro: R9.20", "Interferencias comprobadas por la inspección: cese de las emisiones hasta corregir la causa",
  [Te han ordenado detener las emisiones de tu estación porque interferían a otro servicio. ¿Hasta cuándo dura esa orden?],
  ([hasta que se corrija la causa; después, comunicándolo, puedes reanudar las emisiones], [para siempre: el cese equivale a revocar la autorización], [hasta que se resuelva el expediente sancionador, aunque la causa ya esté corregida], [un año, el plazo de prescripción de las infracciones leves],),
  sol: [El fin del cese es que la interferencia acabe, así que dura lo que tarde en corregirse la causa: se adoptan las medidas técnicas, se comunica y se reanudan las emisiones. Si la interferencia persiste, la Administración puede restringir bandas, potencia u horario. No es una revocación ni depende del expediente sancionador, que es otra vía.], tema: "R9")
#fin-prueba()
#soluciones-simulacro(10)

// ======================================================================
#simulacro(11)
#prueba(11, 1)
#pq(11, 1, 1, "b", "estúdialo en: simulacros de estudio 13·1·1 · libro: T1.36", "Resistencia de un conductor: R = ρ l / S",
  [Un hilo de cobre tiene una resistencia de 0,4 Ω. Otro hilo del mismo cobre, de doble longitud y doble sección, tiene una resistencia de:],
  ([1,6 Ω], [0,4 Ω], [0,8 Ω], [0,2 Ω],),
  sol: [Con $R = rho l slash S$, doblar la longitud duplica la resistencia y doblar la sección la reduce a la mitad: los dos efectos se compensan y quedan 0,4 Ω. Los 0,8 Ω solo tienen en cuenta la longitud, los 0,2 Ω solo la sección y los 1,6 Ω tratan la sección como si multiplicara.], tema: "T1")
#pq(11, 1, 2, "a", "estúdialo en: simulacros de estudio 7·1·1, 12·1·3 · libro: T1.15, C-T1.4", "Velocidad de propagación: c = 300.000 km/s, constante y sin depender de la frecuencia",
  [Una señal de radio recorre 3000 km en el vacío. Tarda aproximadamente:],
  ([10 ms], [1 ms], [1 s], [100 ms],),
  sol: [$t = d slash c = 3000 slash 300.000 = 0","01$ s = 10 ms. 1 ms supondría una velocidad de 3.000.000 km/s y 100 ms, de 30.000 km/s: dos errores clásicos en la cifra de $c$. Un segundo correspondería a 300.000 km.], tema: "T1")
#pq(11, 1, 3, "b", "estúdialo en: simulacros de estudio 10·1·2 · libro: T1.19", "Período: T = 1 / f, tiempo entre dos máximos consecutivos",
  [En la pantalla de un osciloscopio, dos máximos consecutivos de una sinusoide están separados 2 μs. ¿Cuál es su frecuencia?],
  ([2 MHz], [500 kHz], [250 kHz], [50 kHz],),
  sol: [El tiempo entre dos máximos consecutivos es el período, $T = 2$ μs, y $f = 1 slash T = 1 slash (2 times 10^(-6)) = 500.000$ Hz = 500 kHz. Los 250 kHz toman ese tiempo como medio período, los 2 MHz leen los microsegundos como megahercios y los 50 kHz son un error de un factor 10.], tema: "T1")
#pq(11, 1, 4, "a", "estúdialo en: simulacros de estudio 9·1·4 · libro: F-T1.45", "Filtros antisolapamiento (paso bajo antes del A/D) y de reconstrucción (paso bajo tras el D/A)",
  [Un sistema de DSP muestrea a 48 kHz. Su filtro antisolapamiento debe ser:],
  ([un paso bajo con corte en torno a 24 kHz, situado antes del A/D], [un paso alto con corte en torno a 24 kHz, situado antes del A/D], [un paso bajo con corte en torno a 48 kHz, situado antes del A/D], [un paso bajo con corte en torno a 24 kHz, situado después del D/A],),
  sol: [El filtro antisolapamiento debe eliminar, antes de muestrear, todo lo que supere $f_s slash 2 = 24$ kHz: es un paso bajo colocado delante del A/D. El paso bajo situado tras el D/A es otro filtro, el de reconstrucción, y un corte en 48 kHz dejaría pasar componentes que se plegarían sobre la banda útil.], tema: "T1")
#pq(11, 1, 5, "d", "estúdialo en: simulacros de estudio 12·1·6 · libro: C-T2.12", "En continua los condensadores se cargan al principio y luego bloquean la corriente",
  [Se conecta un condensador descargado en serie con una resistencia a una pila. ¿Cómo evoluciona la corriente en el circuito?],
  ([es nula desde el primer instante, porque el condensador no deja pasar la continua], [es constante mientras la pila esté conectada], [empieza siendo nula y crece hasta un valor fijo], [es máxima al cerrar el circuito y disminuye hasta anularse cuando el condensador se ha cargado],),
  sol: [Al principio el condensador está descargado y toda la tensión cae en la resistencia: la corriente arranca en V/R. A medida que se carga, su tensión se opone a la de la pila y la corriente se apaga hasta anularse. Decir que no pasa corriente desde el primer instante olvida esa carga inicial.], tema: "T2")
#pq(11, 1, 6, "c", "estúdialo en: simulacros de estudio 7·1·5 · libro: T2.14", "Unidad de autoinducción: el henrio",
  [Una bobina de choque de RF lleva la indicación «2,5 mH». ¿Qué magnitud expresa ese dato?],
  ([el flujo magnético que crea], [su reactancia a la frecuencia de trabajo], [su autoinducción], [su capacidad parásita],),
  sol: [El henrio (H) y sus submúltiplos miden la autoinducción L de una bobina. La capacidad se mide en faradios, el flujo magnético en webers y la reactancia en ohmios.], tema: "T2")
#pq(11, 1, 7, "d", "estúdialo en: simulacros de estudio 5·1·7 · libro: T2.25", "Varicap: capacidad controlada por la tensión inversa (más tensión, menos capacidad)",
  [En un oscilador controlado por tensión (VCO) sintonizado con un varicap, al aumentar la tensión inversa aplicada al varicap, la frecuencia del oscilador:],
  ([disminuye], [no varía], [se reduce a la mitad], [aumenta],),
  sol: [Más tensión inversa ensancha la zona de deplexión, que hace de dieléctrico: la capacidad del varicap baja. Con menos capacidad, la frecuencia de resonancia $f_0 = 1 / (2 pi sqrt(L C))$ sube. Quien cree que la capacidad aumenta con la tensión llega a la respuesta contraria.], tema: "T2")
#pq(11, 1, 8, "c", "estúdialo en: simulacros de estudio 9·1·7 · libro: C-T2.11", "Ventaja del FET: impedancia de entrada muy alta",
  [En la primera etapa de un receptor, donde la señal de la antena es muy débil, se prefiere a menudo un FET en lugar de un bipolar porque:],
  ([su impedancia de entrada es muy baja y se adapta mejor a la antena], [necesita una corriente de puerta grande, que la antena le proporciona], [su puerta apenas toma corriente y no carga la etapa anterior], [no necesita ninguna alimentación],),
  sol: [El FET se gobierna con tensión y su puerta casi no consume corriente: su impedancia de entrada es altísima y no carga la fuente de señal. El bipolar, en cambio, necesita corriente de base, que la etapa anterior tiene que entregar. Decir que la impedancia de entrada es baja es justo lo contrario de su ventaja.], tema: "T2")
#pq(11, 1, 9, "a", "estúdialo en: simulacros de estudio 2·1·9 · libro: T3.28", "Asociación de condensadores: en paralelo se suman; en serie, por inversas (al revés que las resistencias)",
  [Dos condensadores de 300 pF y 600 pF se conectan en serie. La capacidad resultante es de:],
  ([200 pF], [900 pF], [450 pF], [150 pF],),
  sol: [En serie los condensadores se combinan por inversas, como las resistencias en paralelo: $C = (300 dot 600) slash (300 + 600) = 180000 slash 900 = 200$ pF, menos que el menor. Los 900 pF aplican la regla de las resistencias en serie, que en condensadores corresponde al paralelo. Los 450 pF son la media, que no corresponde a ninguna asociación, y los 150 pF la regla de dos condensadores iguales aplicada sin serlo.], tema: "T3")
#pq(11, 1, 10, "b", "estúdialo en: simulacros de estudio 12·1·10 · libro: F-T3.36", "Impedancia de un circuito RLC serie: X = XL − XC, Z = √(R² + X²) e I = V/Z",
  [Una resistencia de 30 Ω, una bobina de 100 Ω de reactancia y un condensador se conectan en serie a un generador de 50 V eficaces. Circula una corriente de 1 A y el conjunto es de carácter inductivo. La reactancia del condensador es de:],
  ([20 Ω], [60 Ω], [40 Ω], [50 Ω],),
  sol: [La impedancia es $Z = V slash I = 50$ Ω. Como $Z = sqrt(R^2 + X^2)$, la reactancia neta vale $X = sqrt(50^2 - 30^2) = 40$ Ω, inductiva, y como $X = X_L - X_C$, $X_C = 100 - 40 = 60$ Ω. Los 40 Ω confunden la reactancia neta con la del condensador; los 50 Ω restan la impedancia directamente de $X_L$; y los 20 Ω restan $Z$ y $R$ aritméticamente, olvidando que $R$ y $X$ se combinan en cuadratura.], tema: "T3")
#pq(11, 1, 11, "d", "estúdialo en: simulacros de estudio 8·1·9 · libro: T3.33", "Filtro paso bajo: deja pasar las frecuencias inferiores a la de corte (a la salida del TX, contra armónicos)",
  [Un transmisor trabaja en 7,1 MHz y su segundo armónico cae en 14,2 MHz. Para atenuar ese armónico se coloca a la salida un filtro paso bajo cuya frecuencia de corte debe ser de unos:],
  ([5 MHz], [14,2 MHz], [16 MHz], [8 MHz],),
  sol: [El paso bajo deja pasar lo que está por debajo de su frecuencia de corte y atenúa lo que está por encima. El corte debe quedar algo por encima de la frecuencia de trabajo y bien por debajo del armónico. Con 5 MHz se atenuaría la propia señal de 7,1 MHz; con 16 MHz el armónico pasaría entero; y con el corte justo en 14,2 MHz el armónico apenas se atenuaría 3 dB.], tema: "T3")
#pq(11, 1, 12, "d", "estúdialo en: simulacros de estudio 8·1·12 · libro: T3.23", "Linealidad frente a rendimiento: clase A mínima distorsión; clase C mayor rendimiento",
  [Ordenadas de menor a mayor rendimiento, las clases de amplificación son:],
  ([C, B, AB y A], [A, B, AB y C], [AB, A, C y B], [A, AB, B y C],),
  sol: [El rendimiento crece a medida que se acorta el ángulo de conducción: clase A (360°), AB (entre 180° y 360°), B (180°) y C (menos de 180°). Al mismo tiempo empeora la linealidad, de modo que la A es la de mínima distorsión y la C la de mayor rendimiento. El orden inverso confunde rendimiento con linealidad, y poner la B antes que la AB olvida que la AB conduce más tiempo.], tema: "T3")
#pq(11, 1, 13, "b", "estúdialo en: simulacros de estudio 5·1·12 · libro: T3.17", "Amplificador operacional: ganancia muy alta, impedancia de entrada alta y de salida baja",
  [Gracias a su impedancia de entrada muy alta, un amplificador operacional conectado a un circuito para medir su tensión:],
  ([le entrega mucha corriente sin que se hunda su tensión], [apenas le toma corriente, de modo que no altera lo que mide], [amplifica la suma de sus dos entradas], [funciona con ganancia unidad sin necesidad de realimentación],),
  sol: [Una impedancia de entrada alta significa que por las entradas apenas entra corriente: el operacional no carga el circuito al que se conecta. Entregar corriente sin hundirse es mérito de su impedancia de salida baja, y lo que amplifica es la diferencia entre sus entradas, no la suma.], tema: "T3")
#pq(11, 1, 14, "c", "estúdialo en: simulacros de estudio 1·1·15 · libro: F-T4.4", "Frecuencia imagen: defecto del receptor superheterodino, situada a 2·FI de la sintonizada",
  [Sintonizas 3,700 MHz con un superheterodino de FI 455 kHz cuyo oscilador local trabaja por debajo de la señal. ¿En qué frecuencia podría colarse una estación como imagen?],
  ([4,610 MHz], [4,155 MHz], [2,790 MHz], [3,245 MHz],),
  sol: [El oscilador está en $3","700 - 0","455 = 3","245$ MHz y la imagen queda al otro lado de él, a una FI: $3","245 - 0","455 = 2","790$ MHz, es decir, dos veces la FI por debajo de la sintonizada. Los 4,610 MHz serían la imagen con el oscilador por encima; 3,245 MHz es el propio oscilador local, y 4,155 MHz está a una sola FI de la señal.], tema: "T4")
#pq(11, 1, 15, "a", "estúdialo en: simulacros de estudio 1·1·16 · libro: T4.3", "Conversión directa: el OL a la frecuencia de la señal y el mezclador da directamente audio, sin FI",
  [¿A qué frecuencia trabaja el oscilador de un receptor de conversión directa?],
  ([prácticamente igual a la de la señal que se quiere recibir], [igual a la de la señal más una FI fija de 455 kHz], [doble de la de la señal que se quiere recibir], [fija, sea cual sea la frecuencia sintonizada],),
  sol: [En la conversión directa el oscilador cae sobre la propia señal y el mezclador entrega directamente su diferencia, que ya es audio: no hay FI. Sumar una FI al oscilador es lo que hace un superheterodino. Por estar el oscilador sobre la señal aparece la imagen de audio: las frecuencias simétricas respecto a él dan el mismo tono.], tema: "T4")
#pq(11, 1, 16, "b", "estúdialo en: simulacros de estudio 7·1·16 · libro: T4.23", "Noise blanker (NB): suprime el ruido impulsivo",
  [Un motor de explosión cercano produce en el receptor un crepitar de pulsos cortos e intensos. El mando pensado para este problema es:],
  ([NOTCH], [NB (noise blanker)], [el silenciador (squelch)], [NR (reducción de ruido)],),
  sol: [El noise blanker detecta los pulsos cortos e intensos y silencia el receptor durante ellos: es el remedio del ruido impulsivo. El NR trabaja sobre el soplido continuo de fondo y el NOTCH elimina un silbido fijo. El silenciador no reduce ningún ruido, solo corta el audio sin señal.], tema: "T4")
#pq(11, 1, 17, "c", "estúdialo en: simulacros de estudio 8·1·17 · libro: T5.31", "Sobremodulación: índice > 100 %; distorsión y ensanchamiento de la emisión (splatter)",
  [En AM, si el índice de modulación supera el 100 %, en los valles de la modulación:],
  ([la frecuencia de la portadora se desplaza respecto a la asignada], [la portadora queda suprimida y la emisión pasa a ser J3E], [la envolvente se anula durante un tiempo, la señal se recorta y la emisión se ensancha], [la emisión se estrecha y mejora la inteligibilidad],),
  sol: [Con índice mayor que 1 la envolvente intenta hacerse negativa: se queda en cero un tiempo y la portadora se recorta. Esa distorsión genera productos que ensanchan la emisión e interfieren a los canales vecinos: es el mismo splatter que en SSB. La frecuencia de la portadora no cambia, y la clase de emisión sigue siendo AM.], tema: "T5")
#pq(11, 1, 18, "d", "estúdialo en: simulacros de estudio 3·1·19 · libro: T5.33", "Potencia de portadora: media durante un ciclo de RF sin modulación",
  [Un transmisor de AM entrega 100 W sin modular y 150 W de media cuando se modula al 100 % con un tono. Su potencia de portadora es:],
  ([125 W], [150 W], [400 W], [100 W],),
  sol: [La potencia de portadora es la media durante un ciclo de RF en ausencia de modulación: los 100 W. Los 150 W son la potencia media con modulación, que incluye las bandas laterales, y los 400 W, la potencia de pico de envolvente al 100 %.], tema: "T5")
#pq(11, 1, 19, "a", "estúdialo en: simulacros de estudio 12·1·19 · libro: C-T5.9", "Anchura de banda ocupada: fuera de sus límites se radia el 0,5 % por cada lado",
  [Dentro de los límites de la anchura de banda ocupada de una emisión queda el siguiente porcentaje de su potencia media total:],
  ([99 %], [95 %], [50 %], [99,5 %],),
  sol: [Por definición, fuera de cada límite se radia el 0,5 % de la potencia media total: un 0,5 % por debajo y otro 0,5 % por encima. Dentro queda, por tanto, el 99 %. El 99,5 % sale de olvidar que el 0,5 % se cuenta a cada lado.], tema: "T5")
#pq(11, 1, 20, "a", "estúdialo en: simulacros de estudio 11·1·20 · libro: T6.36", "Impedancia del dipolo de media onda alimentado en el centro: ≈ 73 Ω",
  [De las siguientes antenas en resonancia, la que presenta en su punto de alimentación una impedancia de unos 73 Ω es:],
  ([el dipolo de media onda alimentado en el centro, en el espacio libre], [la vertical de cuarto de onda con radiales horizontales], [la antena de media onda alimentada por un extremo], [el dipolo plegado],),
  sol: [En el centro del dipolo de media onda la corriente es máxima y la tensión mínima, y el cociente $Z = V slash I$ da unos 73 Ω en el espacio libre. El dipolo plegado multiplica ese valor por cuatro (unos 300 Ω), la vertical de cuarto de onda lo divide por dos (unos 36 Ω) y la media onda alimentada en un extremo presenta miles de ohmios.], tema: "T6")
#pq(11, 1, 21, "c", "estúdialo en: simulacros de estudio 5·1·20", "Yagi: el reflector es más largo y va detrás; los directores, más cortos y delante",
  [En una Yagi, el haz principal sale hacia el lado:],
  ([del reflector, el elemento más largo], [perpendicular al boom, como en un dipolo aislado], [de los directores, los elementos más cortos], [de los dos extremos del boom por igual],),
  sol: [El reflector, algo más largo que el radiante (inductivo), va detrás: refuerza la radiación hacia el radiante y la anula a su espalda. Los directores, algo más cortos (capacitivos), van delante y tiran del haz hacia ellos, así que el haz sale por su lado. Si saliera por igual hacia los dos extremos no habría relación adelante-atrás.], tema: "T6")
#pq(11, 1, 22, "d", "estúdialo en: simulacros de estudio 1·1·20 · libro: T6.34", "La ganancia se expresa en dB respecto de una antena de referencia (dBi o dBd)",
  [Una antena con una ganancia de 0 dBd:],
  ([tiene ganancia nula y no radia], [tiene la misma ganancia que la antena isótropa], [radia una potencia de 0 W], [tiene la misma ganancia que un dipolo de media onda],),
  sol: [La ganancia es una comparación con una antena de referencia: dBd significa respecto del dipolo de media onda, así que 0 dBd es ganar lo mismo que él. Respecto de la isótropa esa antena tendría 2,15 dBi. La ganancia nunca se da en vatios, y 0 dB no significa «nada», sino una relación igual a 1.], tema: "T6")
#pq(11, 1, 23, "b", "estúdialo en: simulacros de estudio 5·1·21", "La impedancia característica depende de la geometría y del dieléctrico, no de la longitud",
  [Dos coaxiales tienen el mismo aislante, pero uno es de 50 Ω y el otro de 75 Ω. El de 75 Ω se distingue porque:],
  ([su conductor central es más grueso en relación con la malla], [su conductor central es más fino en relación con la malla], [se fabrica en tramos más largos, porque $Z_0$ crece con la longitud], [está pensado para más potencia, porque $Z_0$ depende de la potencia transportada],),
  sol: [La impedancia característica depende de la geometría (la relación entre el diámetro de la malla y el del conductor central) y del aislante, que fijan la inductancia y la capacidad por metro. Con el mismo aislante, para pasar de 50 a 75 Ω hay que aumentar $D slash d$ de unos 3,5 a unos 6,7: el conductor central es más fino. Ni la longitud ni la potencia cambian $Z_0$.], tema: "T6")
#pq(11, 1, 24, "c", "estúdialo en: simulacros de estudio 12·1·24", "MUF ≈ fc / cos θ: mayor que la frecuencia crítica en incidencia oblicua",
  [En un trayecto, la onda llega a la capa F2 formando 60° con la vertical y la MUF es de 18 MHz. La frecuencia crítica de la capa es aproximadamente:],
  ([36 MHz], [15,6 MHz], [9 MHz], [18 MHz],),
  sol: [De $"MUF" approx f_c / cos theta$ sale $f_c approx "MUF" dot cos theta = 18 dot cos 60° = 18 dot 0","5 = 9$ MHz. Los 36 MHz salen de dividir entre el coseno en vez de multiplicar, y los 15,6 MHz de usar el seno. La frecuencia crítica es siempre menor que la MUF de un trayecto oblicuo, así que no puede valer 18 MHz.], tema: "T7")
#pq(11, 1, 25, "d", "estúdialo en: simulacros de estudio 10·1·25 · libro: T7.7", "Desvanecimiento (fading): variación momentánea de la intensidad recibida",
  [Un corresponsal te dice que tu señal sube y baja de intensidad cada pocos segundos. ¿Cómo se llama el fenómeno y cuál es una causa típica?],
  ([intermodulación: dos señales se mezclan en un elemento no lineal del receptor], [efecto Dellinger: una fulguración solar apaga la HF durante horas], [zona de silencio: la estación queda entre la onda de superficie y el primer salto], [desvanecimiento (fading): la señal llega por varios caminos que unas veces se suman en fase y otras en oposición],),
  sol: [La variación momentánea de la intensidad recibida es el desvanecimiento o fading, y el multitrayecto es su causa más típica, junto con las fluctuaciones de la propia ionosfera. El efecto Dellinger silencia la HF durante minutos u horas, no la hace oscilar cada pocos segundos, y en la zona de silencio no se recibe nada.], tema: "T7")
#pq(11, 1, 26, "c", "estúdialo en: simulacros de estudio 9·1·26 · libro: F-T8.7", "Error de carga del voltímetro en un divisor de tensión",
  [Para medir con el menor error de carga la tensión en el punto medio de un divisor formado por dos resistencias de 100 kΩ conviene usar:],
  ([un voltímetro analógico de 20 000 Ω/V en la escala de 10 V], [un voltímetro analógico de 1000 Ω/V en la escala de 10 V], [un polímetro digital de 10 MΩ de resistencia de entrada], [un voltímetro de 100 kΩ de resistencia interna],),
  sol: [El voltímetro queda en paralelo con una de las resistencias y le roba corriente; el error es menor cuanto mayor es su resistencia frente a la del circuito (al menos cien veces mayor). Los analógicos de 1000 y 20 000 Ω/V tienen 10 kΩ y 200 kΩ en la escala de 10 V; con uno de 100 kΩ la lectura bajaría un 33 %, mientras que con 10 MΩ el error es de solo un 0,5 %.], tema: "T8")
#pq(11, 1, 27, "b", "estúdialo en: simulacros de estudio 13·1·26", "Potencia media frente a p.c.e. (coinciden con amplitud constante; en SSB la media es mucho menor)",
  [Con voz sin procesar, un transmisor de SSB que da 100 W p.c.e. entrega una potencia media del orden de:],
  ([unos 50 W, la mitad de la p.c.e.], [entre 10 y 25 W], [100 W, igual que la p.c.e.], [unos 70,7 W, la p.c.e. dividida entre $sqrt(2)$],),
  sol: [En SSB no hay portadora y la potencia sube y baja con la voz: la media queda muy por debajo de la p.c.e., de 10 a 25 W para 100 W p.c.e. Solo con amplitud constante (CW con el manipulador apretado o FM) coinciden media y p.c.e., y dividir entre $sqrt(2)$ es pasar de tensión de pico a eficaz, no de p.c.e. a potencia media.], tema: "T8")
#pq(11, 1, 28, "a", "estúdialo en: simulacros de estudio 13·1·27", "Detección en circuitos de audio: una unión semiconductora rectifica la RF y recupera la envolvente",
  [La interferencia por detección en el amplificador de audio de un vecino deja oír tu voz cuando transmites en AM, pero solo produce chasquidos cuando transmites en FM. ¿Por qué?],
  ([porque la unión semiconductora recupera la envolvente de la RF, y en FM la amplitud no varía con la voz], [porque el amplificador solo está sintonizado a las frecuencias de AM], [porque los cables del amplificador no captan las señales de FM], [porque en FM se transmite con menos potencia],),
  sol: [Al rectificar la RF, la unión base-emisor del primer transistor deja su envolvente, que en AM sigue a la voz y cae en la banda de audio. En FM la amplitud es constante, así que solo se oyen chasquidos al empezar y terminar cada transmisión. Un amplificador de audio no está sintonizado a ninguna frecuencia de radio.], tema: "T9")
#pq(11, 1, 29, "d", "estúdialo en: simulacros de estudio 11·1·29 · libro: T10.20", "Lo que daña es la corriente: intensidad, recorrido y duración",
  [Un pájaro posado sobre un único cable de alta tensión no sufre daño porque:],
  ([la resistencia de su cuerpo es prácticamente nula], [sus plumas lo aíslan de la alta tensión], [la tensión alterna no afecta a los animales pequeños], [entre sus patas no hay diferencia de potencial y no circula corriente por su cuerpo],),
  sol: [Lo que daña es la corriente que atraviesa el cuerpo, no la tensión por sí sola. Con las dos patas sobre el mismo cable no hay diferencia de potencial entre ellas, no se cierra ningún circuito y no pasa corriente. Una persona que toca la fase y a la vez el suelo sí cierra el circuito, y su cuerpo es recorrido por una corriente $I = V slash R$.], tema: "T10")
#pq(11, 1, 30, "b", "estúdialo en: simulacros de estudio 5·1·30 · libro: T10.27", "Qué vale como tierra: la del edificio si está en buen estado; nunca el neutro ni tuberías de gas o agua",
  [¿Por qué no sirve el neutro de la red para poner a tierra los chasis de la estación?],
  ([Porque su resistencia es demasiado baja], [Porque es un conductor activo, por el que vuelve la corriente de la instalación], [Porque solo conduce corriente continua], [Porque está aislado de tierra en el transformador de distribución],),
  sol: [El neutro forma parte del circuito: por él vuelve la corriente de la casa, así que no es un camino reservado para las fugas. Está unido a tierra en el transformador de distribución, pero eso no lo convierte en una toma de tierra válida. Lo que sí puede usarse es la tierra del edificio, si existe y está en buen estado; nunca una tubería, y menos la del gas.], tema: "T10")
#fin-prueba()
#prueba(11, 2)
#pq(11, 2, 1, "d", "estúdialo en: simulacros de estudio 8·2·1 · libro: R1.24", "F Foxtrot y G Golf",
  [¿Cómo deletreas, con el alfabeto internacional, las dos letras del sufijo `GF`?],
  ([Golf Fox], [Gustavo Foxtrot], [Gamma Foxtrot], [Golf Foxtrot],),
  sol: [G es Golf y F es Foxtrot. Gustavo pertenece al alfabeto español antiguo, Gamma es una letra griega y Fox, a secas, no es la palabra del alfabeto vigente.], tema: "R1")
#pq(11, 2, 2, "b", "estúdialo en: simulacros de estudio 13·2·3 · libro: F-R2.5", "Escalas de respuesta: QRK y QSA de 1 a 5; QRI de 1 a 3",
  [Tu corresponsal te pasa «`QRI 3`». ¿Cómo es el tono de tu emisión?],
  ([bueno, aunque algo variable], [malo], [excelente, porque 3 es el máximo de su escala], [regular, el punto medio de una escala de 1 a 5],),
  sol: [`QRI` se contesta con una escala de 1 a 3 y al revés que las demás: 1 bueno, 2 variable y 3 malo. Es cierto que 3 es el número más alto, pero en `QRI` el más alto es el peor; la escala de 1 a 5 es la de `QRK` y `QSA`.], tema: "R2")
#pq(11, 2, 3, "b", "estúdialo en: simulacros de estudio 10·2·2 · libro: F-R2.1", "QTR hora exacta",
  [Quieres pedir a tu corresponsal la hora exacta. Transmites:],
  ([`QRG?`], [`QTR?`], [`QTH?`], [`QTA?`],),
  sol: [`QTR` es la hora exacta; con interrogación la pide. `QTH` es la posición, `QRG` la frecuencia exacta (la palabra «exacta» despista) y `QTA` sirve para anular un mensaje.], tema: "R2")
#pq(11, 2, 4, "c", "estúdialo en: simulacros de estudio 7·2·4 · libro: R3.3", "RPT repita y AGN de nuevo",
  [¿Qué dos abreviaturas sirven para pedir al corresponsal que repita lo que ha transmitido?],
  ([`R` y `RPT`], [`RST` y `AGN`], [`RPT` y `AGN`], [`RPT` y `CFM`],),
  sol: [`RPT` es «repita» y `AGN`, «de nuevo»; juntas aparecen en «`PSE RPT UR NAME AGN`». `RST` es el informe de señal, `R` es «recibido» y `CFM`, «confirmo»: las tres se usan cuando no hace falta repetir nada.], tema: "R3")
#pq(11, 2, 5, "a", "estúdialo en: simulacros de estudio 6·2·6 · libro: R3.19", "TNX / TKS y TU: gracias",
  [¿Cuál de estas abreviaturas significa «gracias»?],
  ([`TU`], [`UR`], [`SRI`], [`PSE`],),
  sol: [`TU` (\_thank you\_) es «gracias», igual que `TNX` o `TKS`. `UR` se le parece, pero es el posesivo «su»; `PSE` es «por favor» y `SRI`, «lo siento».], tema: "R3")
#pq(11, 2, 6, "d", "estúdialo en: simulacros de estudio 4·2·6 · libro: C-R3.2", "BUG manipulador semiautomático",
  [Un telegrafista cuenta que manipula con un «`BUG`». Se refiere a:],
  ([un manipulador electrónico que genera automáticamente puntos y rayas], [un manipulador vertical, la llave simple de subir y bajar], [un fallo de su transceptor], [un manipulador semiautomático, que genera solos los puntos],),
  sol: [El `BUG` es el manipulador semiautomático: un mecanismo fabrica solo los puntos y las rayas se hacen a mano. No es la llave vertical, que lo hace todo a mano, ni el manipulador electrónico, que automatiza puntos y rayas.], tema: "R3")
#pq(11, 2, 7, "c", "estúdialo en: simulacros de estudio 6·2·8 · libro: R4.3", "Seguridad en radiotelefonía: SÉCURITÉ (tres veces)",
  [Quieres avisar a todas las estaciones de que se acerca un temporal peligroso para la navegación. En radiotelefonía, ¿con qué señal encabezas el aviso?],
  ([«Mayday», tres veces], [«Pan Pan», tres veces], [«Sécurité», tres veces], [`TTT`, tres veces],),
  sol: [Un aviso meteorológico o a la navegación es un mensaje de seguridad: «Sécurité» tres veces. No se pide ayuda, así que no es urgencia ni socorro. `TTT` es la misma señal de seguridad, pero en telegrafía.], tema: "R4")
#pq(11, 2, 8, "b", "estúdialo en: simulacros de estudio 4·2·8 · libro: R4.4", "Contenido del mensaje de socorro: identificación, posición, naturaleza del peligro (nunca «Sécurité»)",
  [Un mensaje de socorro dice: «Mayday, EA5KLM. Velero Gaviota. Vía de agua, nos hundimos. Necesitamos evacuación inmediata. Tres personas a bordo. Cambio.» ¿Qué dato esencial le falta?],
  ([la señal de seguridad «Sécurité»], [la posición], [la potencia del transmisor], [el informe RST de quien lo escuche],),
  sol: [El mensaje de socorro lleva la identificación, la posición, la naturaleza del peligro y la ayuda que se necesita; aquí falta la posición, sin la cual nadie puede acudir. «Sécurité» es la señal de otra categoría y nunca va en un mensaje de socorro.], tema: "R4")
#pq(11, 2, 9, "a", "estúdialo en: simulacros de estudio 6·2·9 · libro: F-R4.3", "Centros de actividad de emergencia IARU R1: 14300 kHz (mundial) y 3760 kHz (80 m)",
  [Durante una emergencia en Europa, ¿qué frecuencias señala el plan de bandas de la IARU para la Región 1 como centros de actividad de emergencia en 80 m y en 20 m?],
  ([3760 kHz y 14300 kHz], [3690 kHz y 14285 kHz], [3630 kHz y 14130 kHz], [3735 kHz y 14230 kHz],),
  sol: [Los centros de emergencia son 3760 kHz en 80 m y 14300 kHz en 20 m (este último de ámbito mundial). Las demás parejas son centros reales de otros modos: SSB de baja potencia (3690 y 14285 kHz), imagen (3735 y 14230 kHz) y voz digital (3630 y 14130 kHz).], tema: "R4")
#pq(11, 2, 10, "d", "estúdialo en: simulacros de estudio 9·2·10, 13·2·10 · libro: C-R5.9, R5.10", "Identificación de móviles y portables: /M, /MM, /MA, /P en grafía; palabras («portable») en fonía; no existe /AM",
  [Operas en fonía desde un velero, como estación móvil marítima, y quieres indicarlo al identificarte. Añades a tu distintivo:],
  ([las palabras «móvil aeronáutica»], [la palabra «portable»], [las letras /AM, pronunciadas una a una], [las palabras «móvil marítima»],),
  sol: [En fonía se dicen las palabras (móvil, móvil marítima, móvil aeronáutica o portable); las abreviaturas /M, /MM, /MA y /P son para la telegrafía (art. 29.2). /AM no existe en la Orden, y «portable» o «móvil aeronáutica» describen otro tipo de estación.], tema: "R5")
#pq(11, 2, 11, "c", "estúdialo en: simulacros de estudio 5·2·12 · libro: F-R5.8", "Prefijos de los países vecinos: Portugal CT, Francia F, Andorra C3",
  [Desde Badajoz contactas con una estación del país vecino situado al oeste de España. Su distintivo empezará por:],
  ([F], [C3], [CT], [CE],),
  sol: [El vecino del oeste es Portugal, cuyo prefijo es CT. CE es de Chile (trampa por la inicial), F de Francia y C3 de Andorra, los otros dos vecinos de España.], tema: "R5")
#pq(11, 2, 12, "a", "estúdialo en: simulacros de estudio 3·2·10, 12·2·11 · libro: R5.34, R5.35", "Distritos insulares y ciudades autónomas: 6 Baleares, 8 Canarias, 9 Ceuta y Melilla",
  [Un radioaficionado que reside en Ibiza obtiene su autorización. Su distintivo será de la forma:],
  ([EA6…], [EA5…], [EA9…], [EA8…],),
  sol: [Ibiza es una de las Islas Baleares, distrito 6. El 8 es Canarias y el 9 Ceuta y Melilla; el 5 (Comunidad Valenciana) tienta por la cercanía, pero las islas tienen distrito propio.], tema: "R5")
#pq(11, 2, 13, "b", "estúdialo en: simulacros de estudio 5·2·13 · libro: R5.21", "Reasignación de distintivos: agotadas las combinaciones, salvo anterior titular o familiares de primer grado por fallecimiento",
  [El distintivo de un titular cuya autorización ha sido revocada puede asignarse a otra persona:],
  ([al cabo de un año desde la revocación], [solo cuando se hayan agotado todas las combinaciones posibles], [inmediatamente, al siguiente solicitante del distrito], [a cualquier familiar del antiguo titular que lo pida],),
  sol: [Los distintivos ya utilizados solo se reasignan agotadas todas las combinaciones (art. 28). Las excepciones son el propio anterior titular, si obtiene una nueva autorización, y sus familiares en primer grado solo si la baja se debió a fallecimiento, no a revocación.], tema: "R5")
#pq(11, 2, 14, "b", "estúdialo en: simulacros de estudio 3·2·13, 11·2·15 · libro: R6.14, C-R6.4", "Qué es un plan de bandas: reparto recomendado de cada banda por modo y anchura de banda; instrumento básico de ordenación",
  [Un operador quiere probar un modo digital de banda estrecha en 20 m. Para saber en qué tramo de la banda hacerlo, debe consultar:],
  ([el CNAF, que asigna una frecuencia a cada estación], [el plan de bandas de la IARU para la Región 1], [el Reglamento de Radiocomunicaciones, que reparte cada banda por modos], [la licencia de su estación fija],),
  sol: [El plan de bandas es el instrumento que reparte cada banda de aficionado en segmentos por modo (telegrafía, banda estrecha, fonía, balizas…). El Reglamento de Radiocomunicaciones y el CNAF atribuyen bandas a servicios, pero no detallan el uso por modos.], tema: "R6")
#pq(11, 2, 15, "d", "estúdialo en: simulacros de estudio 9·2·14", "La IARU es la federación de asociaciones nacionales de radioaficionados (URE en España)",
  [La URE, en relación con la IARU, es:],
  ([el órgano de la Administración que expide las autorizaciones], [el organismo de la UIT que atribuye las bandas en España], [una de las tres Regiones en que se organiza la IARU], [la asociación nacional española integrada en la IARU],),
  sol: [La IARU es la federación que agrupa a las asociaciones nacionales de radioaficionados, y en España esa asociación es la URE. Ni la IARU ni la URE atribuyen bandas (eso es la UIT) ni expiden autorizaciones (eso es la Administración).], tema: "R6")
#pq(11, 2, 16, "d", "estúdialo en: simulacros de estudio 10·2·16 · libro: R7.1", "Escuchar antes de transmitir (QRL?)",
  [Antes de llamar CQ en telegrafía en una frecuencia que parece libre, lo correcto es transmitir:],
  ([QRT], [QRZ?], [QSY], [QRL?],),
  sol: [QRL? pregunta si la frecuencia está ocupada: puede haber una estación que no oímos, y por eso se escucha y se pregunta antes de transmitir. QRZ? pregunta quién nos llama, QSY indica cambio de frecuencia y QRT, cese de la transmisión.], tema: "R7")
#pq(11, 2, 17, "b", "estúdialo en: simulacros de estudio 1·2·17 · libro: F-R8.66", "Desatendida terminada: se aplica el procedimiento de la licencia de estación fija (art. 20)",
  [Una asociación termina de instalar un repetidor ya autorizado. ¿Qué trámite sigue?],
  ([puede empezar a emitir de inmediato, sin más trámite], [comunicar a la Jefatura Provincial, en seis semanas, que ha terminado, justificando el seguro; la Jefatura verifica la instalación y expide la licencia], [debe pedir a la SETSI una autorización especial de uso experimental], [debe realizar seis meses de pruebas antes de pedir la licencia],),
  sol: [El art. 26 remite al procedimiento del art. 20, el de la licencia de estación fija: el interesado comunica a la Jefatura Provincial, en seis semanas, la finalización, justificando que la responsabilidad está cubierta con el seguro. La Jefatura dispone de 30 días como máximo para verificar la idoneidad y expedir la licencia, que es la que habilita a emitir. No hace falta autorización experimental, y los seis meses son el plazo para terminar la instalación.], tema: "R8")
#pq(11, 2, 18, "a", "estúdialo en: simulacros de estudio 13·2·19 · libro: R8.1", "Ley 19/1983 («Ley de antenas»): derecho a instalar antenas de aficionado en el exterior de los inmuebles",
  [Un radioaficionado que vive en un bloque de pisos quiere apoyarse en la norma con rango de ley que le reconoce el derecho a instalar su antena en el exterior del inmueble. Esa norma es:],
  ([la Ley 19/1983], [la Ley 11/2022], [la Orden IET/1311/2013], [el Real Decreto 2623/1986],),
  sol: [La Ley 19/1983, la «Ley de antenas», es la que reconoce el derecho a instalar antenas de aficionado en el exterior de los inmuebles. El Real Decreto 2623/1986 la desarrolla como reglamento, pero no tiene rango de ley; la Ley 11/2022 es la Ley General de Telecomunicaciones, y la Orden IET/1311/2013 es el reglamento de la actividad.], tema: "R8")
#pq(11, 2, 19, "c", "estúdialo en: simulacros de estudio 10·2·20 · libro: F-R8.88", "p.i.r.e. (referencia isótropa) frente a p.r.a. (referencia dipolo)",
  [Suministras 50 W a una antena de 10 dBd de ganancia. ¿Cuál es, aproximadamente, la p.i.r.e.?],
  ([1640 W], [50 W], [820 W], [500 W],),
  sol: [La p.i.r.e. usa la ganancia respecto a la antena isótropa: 10 dBd son 12,15 dBi, un factor de unos 16,4, y $50 times 16","4 approx 820$ W. Los 500 W son la p.r.a., que toma como referencia el dipolo de media onda (factor 10). Los 1640 W corresponderían a 100 W, no a 50.], tema: "R8")
#pq(11, 2, 20, "d", "estúdialo en: simulacros de estudio 13·2·21 · libro: F-R8.100", "Potencia en 137 y 475 kHz: 1 W p.i.r.e. (475 kHz: 5 W a más de 800 km de África)",
  [Las bandas de la tabla del anexo I cuyo límite general es de solo 1 W p.i.r.e. son:],
  ([1,8 MHz (160 m) y 3,5 MHz (80 m)], [5 MHz (60 m) y 10 MHz (30 m)], [50 MHz (6 m) y 70 MHz (4 m)], [137 kHz (2200 m) y 475 kHz (630 m)],),
  sol: [La tabla del apartado 3.1 da 1 W p.i.r.e. para las dos bandas más bajas, 137 y 475 kHz; en 475 kHz se puede llegar a 5 W p.i.r.e. a más de 800 km de la frontera de países africanos. 160 y 80 m son de HF, con 1000 W p.c.e.; 6 y 4 m tienen 600 W p.c.e. La banda de 60 m tiene un límite propio de 15 W p.i.r.e. y no está en la tabla.], tema: "R8")
#pq(11, 2, 21, "a", "estúdialo en: simulacros de estudio 4·2·19 · libro: F-R8.103", "Bandas con atribución secundaria: potencia ≤ 50 % de la tabla",
  [La tabla del anexo I da 300 W p.c.e. para 70 cm. Si un tramo de esa banda fuera de atribución secundaria, ¿qué potencia máxima tendría ese tramo?],
  ([150 W p.c.e.], [150 W p.i.r.e.], [300 W p.c.e.], [120 W p.c.e.],),
  sol: [El apartado 3.2 limita las bandas secundarias al 50 % de la tabla, y el porcentaje se aplica sobre la misma magnitud. Para 70 cm la tabla da 300 W p.c.e., así que $300 times 0","5 = 150$ W p.c.e. Los 300 W olvidan la rebaja; 150 W p.i.r.e. cambia la magnitud; y 120 W aplica el 40 % que corresponde a los noveles en estaciones colectivas.], tema: "R8")
#pq(11, 2, 22, "a", "estúdialo en: simulacros de estudio 7·2·20 · libro: C-R8.33", "Licencia CEPT: presentarla a petición de las autoridades del país visitado",
  [Mientras operas temporalmente en otro país con tu licencia CEPT, un funcionario de su Administración te pide que acredites que puedes emitir. ¿Qué debes hacer?],
  ([presentarle tu licencia CEPT, que en tu caso es tu autorización española de radioaficionado], [nada, porque la licencia CEPT no obliga a mostrarla fuera de tu país], [remitirle a la Jefatura Provincial española, que responde por ti], [solicitar en ese momento un distintivo de ese país],),
  sol: [Una de las condiciones del art. 14 es presentar la licencia CEPT a petición de las autoridades del país visitado (14.c). Para un español, la autorización de radioaficionado tiene la consideración de licencia CEPT (art. 11). No se pide distintivo local: se usa el propio precedido de la designación del país visitado.], tema: "R8")
#pq(11, 2, 23, "c", "estúdialo en: simulacros de estudio 3·2·19 · libro: R8.61", "No es obligatorio ser socio de una asociación de radioaficionados",
  [Un radioaficionado se da de baja en la asociación a la que pertenecía. ¿Qué efecto tiene sobre su autorización?],
  ([La autorización se extingue automáticamente], [La autorización queda suspendida hasta que ingrese en otra asociación reconocida], [Ninguno: pertenecer a una asociación de radioaficionados es voluntario], [Conserva la autorización, pero pierde el acceso a los repetidores, reservados a los socios],),
  sol: [No existe obligación de pertenecer a ninguna asociación, así que la baja no afecta a la autorización. La extinción automática es por fallecimiento del titular o por extinción de la asociación titular de la autorización, no por dejar de ser socio. Y el acceso a los repetidores es libre.], tema: "R8")
#pq(11, 2, 24, "b", "estúdialo en: simulacros de estudio 7·2·22 · libro: F-R8.31", "Extinción automática de la autorización: fallecimiento del titular o extinción de la asociación titular",
  [Un radio club, asociación titular de una autorización de radioaficionado, se disuelve y se extingue. ¿Qué ocurre con esa autorización?],
  ([Pasa al presidente del club como autorización personal], [Se extingue automáticamente], [Sigue vigente hasta que la SETSI tramite un expediente de revocación], [Se mantiene mientras siga en vigor el seguro de antenas de la estación],),
  sol: [El art. 8.2 prevé dos casos de extinción automática: el fallecimiento del titular y la extinción de la asociación titular de la autorización. No hace falta expediente, que es lo propio de la revocación (art. 8.1). La autorización es intransferible, así que no pasa a ningún miembro.], tema: "R8")
#pq(11, 2, 25, "c", "estúdialo en: simulacros de estudio 12·2·24 · libro: R8.17", "Cancelación de la licencia fija (p. ej., sin seguro): desmontar todo, antenas incluidas, a costa del titular",
  [Un radioaficionado pide voluntariamente la cancelación de la licencia de su estación fija porque solo va a operar en móvil. ¿Qué debe hacer con las antenas del tejado?],
  ([Puede dejarlas instaladas mientras mantenga el seguro de responsabilidad civil], [Debe desmontarlas la comunidad de propietarios, a su costa], [Desmontarlas, con todos los gastos a su cargo], [Puede dejarlas si la Jefatura lo autoriza en el plazo de 30 días],),
  sol: [La licencia se cancela a petición del titular, por revocación o extinción de la autorización o por falta de seguro; cancelada por cualquier causa, el titular debe desmontar las instalaciones, antenas incluidas, con todos los gastos a su cargo (art. 21.2). Mantener el seguro no le da derecho a conservar la antena sin licencia. Los bancos antiguos daban como clave mantener el sistema solo para recepción con permiso de la propiedad: era la orden derogada.], tema: "R8")
#pq(11, 2, 26, "d", "estúdialo en: simulacros de estudio 8·2·24 · libro: F-R8.76", "Instalación provisional durante las obras: la autoriza la Administración; gastos del titular",
  [Mientras duran unas obras largas en el edificio, quieres seguir emitiendo con una antena provisional compatible con ellas. Según el Real Decreto 2623/1986:],
  ([puede autorizarla la Administración, pero solo si la comunidad paga la instalación], [no cabe: mientras la antena esté desmontada no puedes emitir desde ese inmueble], [puedes instalarla sin autorización, siempre que la retires al acabar las obras], [puede autorizarla la Administración, si es posible, y sus gastos corren de tu cuenta],),
  sol: [El art. 8 prevé que, mientras las antenas estén desmontadas por las obras y siempre que sea posible, la Administración autorice una instalación provisional compatible con ellas. Los gastos son del titular de la licencia, coherente con que el desmontaje tampoco da derecho a indemnización. Hace falta esa autorización, y la comunidad no paga.], tema: "R8")
#pq(11, 2, 27, "c", "estúdialo en: simulacros de estudio 1·2·26 · libro: F-R8.50", "Estatutos de la asociación reconocida: fines propios de la radioafición y obligación de cumplir el Reglamento",
  [Para obtener el reconocimiento como asociación de radioaficionados, ¿cuál de estas condiciones NO exige el artículo 18.7?],
  ([que sus estatutos contemplen como finalidades específicas las propias de los radioaficionados], [que sus estatutos recojan la obligación de cumplir lo dispuesto en el Reglamento], [que sus estatutos la obliguen a integrarse en la IARU], [que esté legalmente constituida y registrada en el Ministerio del Interior],),
  sol: [El art. 18.7 pide que la asociación esté legalmente constituida y registrada en el Ministerio del Interior, y que sus estatutos contemplen como finalidades específicas las propias de los radioaficionados y recojan la obligación de cumplir el Reglamento. No atribuye ningún papel a la IARU ni exige pertenecer a ella. Las otras tres son, precisamente, los requisitos de la norma.], tema: "R8")
#pq(11, 2, 28, "a", "estúdialo en: simulacros de estudio 10·2·29 · libro: R9.16", "Potestad sancionadora: Administración General del Estado (titular de la Secretaría de Estado de Telecomunicaciones)",
  [La Jefatura Provincial comprueba que tu estación produce interferencias y levanta acta. Si se abre expediente, la multa la impone, según el art. 114.1 de la Ley 11/2022:],
  ([la persona titular de la Secretaría de Estado de Telecomunicaciones e Infraestructuras Digitales], [la propia Jefatura Provincial, en el acta de inspección], [la Agencia Española de Protección de Datos], [el juzgado de lo contencioso-administrativo de la provincia],),
  sol: [La Ley 11/2022 separa inspección y sanción: inspeccionan la inspección de telecomunicaciones y sus Jefaturas, pero sanciona la persona titular de la Secretaría de Estado en todos los casos que el art. 114.1 no reserva a otros órganos, y emitir sin autorización o interferir no están reservados. El acta de la Jefatura no es la sanción. La Agencia de Protección de Datos solo sanciona sus casos propios, y el juzgado interviene para autorizar la entrada en un domicilio, no para multar.], tema: "R9")
#pq(11, 2, 29, "d", "estúdialo en: simulacros de estudio 4·2·29 · libro: R9.4", "Leve: comunicarse utilizando estaciones no autorizadas",
  [Un radioaficionado mantiene comunicados habituales con una estación que emite sin ninguna autorización. Según la Ley 11/2022, su conducta es:],
  ([una infracción muy grave, porque equivale a interceptar comunicaciones], [ninguna infracción: solo responde quien emite sin autorización], [una infracción grave en todo caso], [una infracción leve, salvo que deba considerarse grave],),
  sol: [Establecer comunicaciones utilizando estaciones no autorizadas es infracción leve (art. 108.2), salvo que deba considerarse grave. Responde también quien se comunica con ella, no solo quien emite sin autorización. No es interceptación, porque las comunicaciones van dirigidas a él. El «grave en todo caso» viene de la Ley 32/2003, ya derogada.], tema: "R9")
#pq(11, 2, 30, "a", "estúdialo en: simulacros de estudio 3·2·29, 11·2·30 · libro: R9.6, R9.10", "Prescripción: 3 años muy graves, 2 graves, 1 leves",
  [Una interferencia deliberada a un servicio autorizado se cometió hace 30 meses y la Administración no ha actuado aún. Esa infracción:],
  ([no ha prescrito, porque las muy graves prescriben a los tres años], [ha prescrito, porque las muy graves prescriben a los dos años], [ha prescrito, porque todas las infracciones prescriben al año], [no prescribe nunca, por ser muy grave],),
  sol: [La interferencia deliberada es muy grave (art. 106.7), y las muy graves prescriben a los tres años (art. 113). Con 30 meses aún no se ha cumplido el plazo. Dos años es el de las graves y uno el de las leves; tampoco las muy graves son imprescriptibles.], tema: "R9")
#fin-prueba()
#soluciones-simulacro(11)

// ======================================================================
#simulacro(12)
#prueba(12, 1)
#pq(12, 1, 1, "d", "estúdialo en: simulacros de estudio 12·1·1 · libro: F-T1.52", "Ley de Kirchhoff de las tensiones (mallas)",
  [Una batería de resistencia interna despreciable alimenta dos resistencias en serie. Un voltímetro marca 7,5 V en una de ellas y 4,5 V en la otra. La fuerza electromotriz de la batería es de:],
  ([7,5 V], [6 V], [3 V], [12 V],),
  sol: [Por la ley de las mallas, la suma de las caídas de tensión a lo largo de la malla es igual a la fem: $7","5 + 4","5 = 12$ V. Los 3 V son la diferencia entre las dos lecturas, 6 V su media y 7,5 V solo la mayor de ellas.], tema: "T1")
#pq(12, 1, 2, "a", "estúdialo en: simulacros de estudio 4·1·1 · libro: T1.11", "La batería convierte energía química en eléctrica",
  [Mientras se recarga una batería de plomo con un cargador, la transformación de energía que tiene lugar en ella es de:],
  ([energía eléctrica en energía química], [energía química en energía eléctrica], [energía luminosa en energía química], [energía mecánica en energía eléctrica],),
  sol: [Al descargarse, la batería convierte energía química en eléctrica; al cargarla, el proceso va a la inversa y la energía eléctrica del cargador queda almacenada en forma química. La conversión de química en eléctrica es la de la descarga, y la de mecánica en eléctrica es propia de una dinamo.], tema: "T1")
#pq(12, 1, 3, "a", "estúdialo en: simulacros de estudio 3·1·4 · libro: F-T1.24", "FSK, PSK y QAM: qué parámetro de la portadora varía cada una",
  [De estas modulaciones digitales, ¿en cuál la amplitud de la portadora no es constante?],
  ([QAM], [4PSK], [FSK], [2PSK],),
  sol: [FSK salta entre frecuencias y PSK (2PSK, 4PSK) entre fases, ambas con amplitud constante. La QAM combina cambios de amplitud y de fase, así que su amplitud varía de un símbolo a otro.], tema: "T1")
#pq(12, 1, 4, "d", "estúdialo en: simulacros de estudio 4·1·5, 10·1·4 · libro: F-T1.42, T1.32", "Teorema de Nyquist: f_s ≥ 2 f_máx",
  [Una señal llega hasta 12 kHz. ¿Cuál es la menor de estas frecuencias de muestreo con la que puede digitalizarse sin aliasing?],
  ([6 kHz], [48 kHz], [16 kHz], [24 kHz],),
  sol: [Nyquist exige $f_s >= 2 f_"máx" = 2 times 12 = 24$ kHz. Las de 6 y 16 kHz quedan por debajo y producirían aliasing; la de 48 kHz también cumple, pero no es la menor.], tema: "T1")
#pq(12, 1, 5, "c", "estúdialo en: simulacros de estudio 10·1·5 · libro: C-T2.6", "Código de colores: cifra que representa cada color (negro 0 … blanco 9)",
  [En la primera banda de color de una resistencia aparece el gris. ¿Qué cifra indica?],
  ([0], [7], [8], [9],),
  sol: [Las cifras van del negro (0) al blanco (9): negro, marrón, rojo, naranja, amarillo, verde, azul, violeta, gris y blanco. El gris es, pues, el 8, justo antes del blanco. El 7 es el violeta y el 9 el blanco; el 0 corresponde al negro, no al gris, aunque ambos sean colores «sin color».], tema: "T2")
#pq(12, 1, 6, "c", "estúdialo en: simulacros de estudio 13·1·5 · libro: F-T2.26", "Disipación máxima de una resistencia: tensión o corriente máximas a partir de P y R",
  [Una resistencia de 400 Ω está marcada como de 1/4 W. ¿Cuál es la mayor corriente que puede soportar de forma continuada sin quemarse?],
  ([10 A], [0,625 mA], [25 mA], [250 mA],),
  sol: [De $P = I^2 R$ sale $I = sqrt(P / R) = sqrt(0","25 / 400) = 0","025$ A, es decir, 25 mA. Dividir P entre R sin hacer la raíz da 0,625 mA. El 10 de la última opción es $sqrt(P R)$, que es la tensión máxima (10 V), no la corriente.], tema: "T2")
#pq(12, 1, 7, "d", "estúdialo en: simulacros de estudio 3·1·5 · libro: T2.3", "En un conductor metálico la resistencia aumenta con la temperatura",
  [La bobina de un equipo, devanada con hilo de cobre, presenta 2 Ω medida en frío. Tras un rato de funcionamiento el hilo se ha calentado. Su resistencia será:],
  ([exactamente 2 Ω, porque el cobre no varía con la temperatura], [prácticamente nula], [algo menor de 2 Ω, porque el calor libera portadores], [algo mayor de 2 Ω],),
  sol: [En los metales la resistividad aumenta con la temperatura, porque las vibraciones de la red dispersan a los electrones: todo conductor metálico se comporta como un PTC suave. Que el calor libere portadores y baje la resistencia es lo que ocurre en los semiconductores (el NTC), no en el cobre.], tema: "T2")
#pq(12, 1, 8, "b", "estúdialo en: simulacros de estudio 7·1·6 · libro: F-T2.5", "Desfase en reactancias puras: en la bobina la tensión adelanta 90° (en el condensador, la corriente)",
  [Se aplica una tensión alterna sinusoidal a un condensador ideal. ¿Qué relación de fase hay entre la corriente y la tensión?],
  ([la corriente retrasa 90° respecto a la tensión], [la corriente adelanta 90° a la tensión], [están en oposición de fase (180°)], [están en fase],),
  sol: [En el condensador, de $i = C (dif v) / (dif t)$ resulta que la corriente adelanta 90° a la tensión. Es el caso dual de la bobina, donde es la tensión la que adelanta 90° a la corriente; confundir ambos da la opción del retraso. En fase solo están en una resistencia.], tema: "T2")
#pq(12, 1, 9, "a", "estúdialo en: simulacros de estudio 5·1·9 · libro: F-T3.14", "Asociación de bobinas sin acoplo: como las resistencias (serie suman; paralelo producto/suma)",
  [Una bobina de 60 μH se conecta en paralelo con otra, sin acoplamiento magnético entre ellas, y el conjunto presenta 20 μH. La otra bobina es de:],
  ([30 μH], [1200 μH], [40 μH], [80 μH],),
  sol: [Las bobinas sin acoplo en paralelo se combinan como resistencias en paralelo: $1 slash L_2 = 1 slash 20 - 1 slash 60 = 2 slash 60$, luego $L_2 = 30$ μH. Comprobación: $(60 dot 30) slash (60 + 30) = 20$ μH. Los 40 μH restan las inductancias como si la asociación fuera en serie; los 80 μH las suman y los 1200 μH son el producto sin dividir.], tema: "T3")
#pq(12, 1, 10, "c", "estúdialo en: simulacros de estudio 4·1·10 · libro: F-T3.40", "Condensador real: por encima de su autorresonancia se comporta como una bobina",
  [Un condensador real de desacoplo trabaja ya por encima de su frecuencia de autorresonancia. Si la frecuencia sigue subiendo, su impedancia:],
  ([se mantiene constante e igual a su resistencia de pérdidas], [disminuye, como la de un condensador ideal], [aumenta, como la de una bobina], [se hace infinita, como un circuito abierto],),
  sol: [Un condensador real es su capacidad en serie con la inductancia de las patas. Por encima de la autorresonancia manda esa inductancia, cuya reactancia $X_L = 2 pi f L_s$ crece con la frecuencia: el componente se comporta como una bobina y desacopla cada vez peor. Que la impedancia baje al subir la frecuencia es lo propio del condensador por debajo de su autorresonancia; la impedancia igual a la resistencia de pérdidas se da justo en la autorresonancia.], tema: "T3")
#pq(12, 1, 11, "b", "estúdialo en: simulacros de estudio 8·1·11 · libro: C-T3.12", "Emisor común: ganancia de tensión y de corriente, luego de potencia",
  [De los tres montajes del transistor bipolar, el único que proporciona a la vez una ganancia de tensión y una ganancia de corriente elevadas es el de:],
  ([base común], [emisor común], [base común con transformador de salida], [colector común],),
  sol: [En emisor común una pequeña corriente de base produce una corriente de colector $beta$ veces mayor, y esa corriente da en la resistencia de colector una gran variación de tensión: gana tensión y corriente, y por tanto potencia. La base común gana tensión pero no corriente, y el colector común gana corriente pero no tensión.], tema: "T3")
#pq(12, 1, 12, "b", "estúdialo en: simulacros de estudio 13·1·13 · libro: T3.22", "Ángulo de conducción: A 360°, AB entre 180° y 360°, B 180°, C menos de 180°",
  [Un amplificador cuyo dispositivo conduce durante unos 120° de cada ciclo de la señal trabaja en clase:],
  ([A], [C], [AB], [B],),
  sol: [La clase la fija el ángulo de conducción: 360° en clase A, entre 180° y 360° en clase AB, 180° justos en clase B y menos de 180° en clase C. Con 120° conduce menos de medio ciclo, luego es clase C. Confundir con la clase B es el error típico, pero la B conduce exactamente medio ciclo.], tema: "T3")
#pq(12, 1, 13, "a", "estúdialo en: simulacros de estudio 8·1·13 · libro: F-T3.15", "Discriminador de FM: convierte variaciones de frecuencia en variaciones de tensión (audio)",
  [En un receptor de FM, la frecuencia de la señal de FI sube y baja 3 kHz al ritmo de un tono de 1 kHz. A la salida del discriminador aparece:],
  ([una tensión que varía al ritmo de 1 kHz: el tono de audio], [un tono de 3 kHz, igual a la desviación de frecuencia], [una señal de FI cuya amplitud varía 3 kHz], [una tensión continua constante, proporcional a la amplitud de la portadora],),
  sol: [El discriminador convierte las variaciones de frecuencia en variaciones de tensión: su salida sube y baja tantas veces por segundo como la frecuencia de la FI, es decir, 1000 veces, y reproduce el tono. La desviación (3 kHz) fija cuánto varía la tensión, no a qué ritmo; confundirla con la frecuencia del audio es el error típico.], tema: "T3")
#pq(12, 1, 14, "d", "estúdialo en: simulacros de estudio 9·1·16 · libro: T4.7", "CAG: mantiene constante la salida; lazo desde el detector hacia RF y FI",
  [Por efecto del fading, una estación pasa de S5 a S9 + 20 dB en pocos segundos y, sin embargo, el volumen del altavoz apenas cambia. El responsable es:],
  ([el silenciador, que corta el audio cuando la señal es fuerte], [el control automático de nivel (ALC), que limita la excitación], [el noise blanker, que suprime los picos de la señal], [el control automático de ganancia, que reduce la ganancia de RF y FI cuando la señal sube],),
  sol: [El CAG mide el nivel tras el detector y realimenta las etapas de RF y FI: más señal, menos ganancia, y la salida se mantiene casi constante. El ALC es un lazo parecido, pero del transmisor, y limita la excitación del final. El silenciador y el noise blanker no mantienen el nivel de salida.], tema: "T4")
#pq(12, 1, 15, "a", "estúdialo en: simulacros de estudio 4·1·16 · libro: T4.21", "RIT: varía la frecuencia de recepción sin tocar la de transmisión",
  [Una estación te contesta unos 150 Hz por encima de tu frecuencia. Quieres oírla bien sin cambiar la frecuencia en la que transmites. Para ello usas:],
  ([el RIT], [el mando RF GAIN], [el selector de banda lateral (USB/LSB)], [el XIT],),
  sol: [El RIT mueve solo la frecuencia de recepción y deja quieta la de transmisión, de modo que los demás te siguen oyendo donde esperan. El XIT hace lo contrario: mueve la transmisión y deja la recepción. Cambiar de banda lateral no corrige un pequeño desplazamiento.], tema: "T4")
#pq(12, 1, 16, "c", "estúdialo en: simulacros de estudio 5·1·17 · libro: T5.18", "Margen de audiofrecuencia para la inteligibilidad: 300 a 3000 Hz",
  [Si un transmisor de SSB dejara pasar audio hasta 10 kHz en lugar de limitarlo a 3 kHz, el resultado sería:],
  ([una voz mucho más inteligible para el corresponsal], [una emisión más estrecha y con menos interferencias], [una emisión más ancha, sin mejora apreciable de la inteligibilidad], [una potencia de pico (PEP) más alta con el mismo equipo],),
  sol: [Para entender la voz basta la banda de 300 a 3000 Hz; lo que queda por encima es solo brillo. En SSB la emisión ocupa tanto como la frecuencia de audio más alta, así que el resultado sería más espectro robado a los vecinos sin ganar inteligibilidad. La PEP la limita el equipo, no la anchura del audio.], tema: "T5")
#pq(12, 1, 17, "d", "estúdialo en: simulacros de estudio 6·1·17 · libro: T5.14", "Emisiones no deseadas = no esenciales + fuera de banda",
  [Las emisiones situadas justo al lado del canal y producidas por el propio proceso de modulación se denominan:],
  ([emisiones no esenciales], [radiación por la estructura], [armónicos], [emisiones fuera de banda],),
  sol: [El vocabulario oficial distingue las emisiones fuera de banda, pegadas al canal y fruto de la modulación, de las no esenciales, lejos de él, como los armónicos y productos parásitos. Juntas forman las emisiones no deseadas. La radiación por la estructura es la que escapa por el chasis y los cables.], tema: "T5")
#pq(12, 1, 18, "b", "estúdialo en: simulacros de estudio 2·1·18 · libro: F-T5.6", "Repetidor: recibe en una frecuencia y retransmite a la vez en otra",
  [Dos estaciones portátiles de VHF separadas por una colina no se oyen directamente, pero sí a través de un repetidor situado en la cumbre. Lo que hace el repetidor es:],
  ([convertir la emisión de FM en SSB para que llegue más lejos], [recibir lo que transmite una y retransmitirlo a la vez en otra frecuencia], [reflejar la señal en la misma frecuencia, como un espejo pasivo], [grabar el mensaje completo y emitirlo cuando la estación deja de hablar],),
  sol: [Un repetidor recibe en una frecuencia y retransmite simultáneamente en otra, desde un punto alto que ve a las dos estaciones. No puede usar la misma frecuencia, porque su transmisor taparía lo que recibe, y retransmite a la vez, no después. No cambia la clase de emisión.], tema: "T5")
#pq(12, 1, 19, "c", "estúdialo en: simulacros de estudio 7·1·20", "Antena más corta que la resonante: reactancia capacitiva (se compensa con bobina); más larga: inductiva",
  [Un medidor de impedancias indica que un dipolo, a la frecuencia a la que se quiere usar, presenta reactancia inductiva además de su resistencia. Eso significa que el dipolo:],
  ([es algo más corto que el resonante y conviene alargarlo], [está exactamente en resonancia], [es algo más largo que el resonante y conviene acortarlo], [es algo más corto que el resonante y necesita una bobina en serie],),
  sol: [Cerca de su resonancia el dipolo equivale a un RLC en serie: por encima de su frecuencia de resonancia manda $X_L$ y la antena es inductiva, es decir, demasiado larga para esa frecuencia. Acortarla sube su resonancia hasta la frecuencia de trabajo. Una antena demasiado corta sería capacitiva, y en resonancia no habría reactancia alguna.], tema: "T6")
#pq(12, 1, 20, "a", "estúdialo en: simulacros de estudio 6·1·19 · libro: C-T6.11", "Elementos reactivos en serie: la bobina alarga eléctricamente la antena (baja f), el condensador la acorta (sube f)",
  [Un látigo de móvil con bobina de carga resuena en la banda de 40 m. Comparada con la de una vertical de cuarto de onda sin bobina para esa misma banda, su longitud física es:],
  ([mucho menor, porque la bobina lo alarga eléctricamente], [mayor, porque la bobina lo acorta eléctricamente], [igual, porque la bobina solo cambia la impedancia y no la resonancia], [mayor, porque la bobina sube su frecuencia de resonancia],),
  sol: [Una bobina en serie añade la reactancia inductiva que le falta a una antena corta (capacitiva) y la hace resonar a una frecuencia más baja de la que correspondería a su longitud física: la alarga eléctricamente. Por eso un látigo de pocos metros resuena en 40 m, donde un cuarto de onda mediría unos 10 m. Quien acorta eléctricamente la antena, y sube su frecuencia, es el condensador en serie.], tema: "T6")
#pq(12, 1, 21, "c", "estúdialo en: simulacros de estudio 8·1·22 · libro: T6.12", "Balun: une el coaxial (asimétrico) con el dipolo (simétrico); sin él la malla radia",
  [En una estación con un dipolo alimentado directamente con coaxial, el micrófono «pica» y la ROE cambia al tocar el cable. La causa más probable y su remedio son:],
  ([una impedancia de antena demasiado alta; se corrige alargando el coaxial], [una avería del relé de transmisión-recepción; se corrige sustituyéndolo], [corrientes de RF por el exterior de la malla; se corrigen con un balun en el punto de alimentación], [la polarización cruzada; se corrige girando el dipolo 90 grados],),
  sol: [El coaxial es asimétrico y el dipolo simétrico: sin balun, parte de la corriente de la malla escapa por su cara exterior, el cable se convierte en parte de la antena, radia, deforma el diagrama, mete RF en el cuarto de radio y hace que la ROE cambie al tocarlo. El balun de corriente (ferritas o unas vueltas del propio coaxial) frena esa corriente exterior y equilibra los dos brazos.], tema: "T6")
#pq(12, 1, 22, "b", "estúdialo en: simulacros de estudio 11·1·22 · libro: F-T6.20", "El cuarto de onda invierte la impedancia: en cortocircuito se ve como resonante paralelo; abierto, como serie",
  [Un tramo de cuarto de onda en cortocircuito se conecta en paralelo con la línea de alimentación. Su efecto es que:],
  ([convierte la línea en simétrica, como un balun], [no carga la línea a la frecuencia fundamental y cortocircuita el segundo armónico], [cortocircuita la frecuencia fundamental y deja pasar el segundo armónico], [eleva la ROE a la frecuencia fundamental],),
  sol: [A la fundamental el tramo mide $lambda slash 4$ e invierte la impedancia: el cortocircuito del final se ve en la entrada como un circuito abierto, igual que un LC en paralelo resonante, y no carga la línea. A la frecuencia doble mide $lambda slash 2$, repite el cortocircuito y deriva el segundo armónico: es un filtro sencillo y robusto.], tema: "T6")
#pq(12, 1, 23, "d", "estúdialo en: simulacros de estudio 13·1·23 · libro: C-T7.9", "Asignar una frecuencia concreta a su banda con λ = 300/f",
  [La banda de aficionado de 160 m, en torno a 1,9 MHz, se clasifica como:],
  ([decamétricas (HF)], [kilométricas (LF)], [métricas (VHF)], [hectométricas (MF)],),
  sol: [Con $lambda = 300 / f$ resulta $lambda = 300 / 1","9 approx 158$ m, entre 100 y 1000 m: ondas hectométricas, banda MF (300 kHz a 3 MHz). La trampa es pensar que toda la onda corta de aficionado es HF: la banda de 160 m queda por debajo de la frontera de 3 MHz. Las kilométricas (LF) empiezan por debajo de 300 kHz.], tema: "T7")
#pq(12, 1, 24, "d", "estúdialo en: simulacros de estudio 2·1·23 · libro: F-T7.14", "Horizonte radioeléctrico: d ≈ 4,12 (√h1 + √h2) km",
  [Una estación de VHF tiene la antena a 4 m de altura sobre terreno llano y quiere llegar por onda directa a un repetidor situado a 41,2 km. ¿A qué altura mínima aproximada debe estar la antena del repetidor?],
  ([96 m], [8 m], [100 m], [64 m],),
  sol: [Con $d approx 4","12 (sqrt(h_1) + sqrt(h_2))$: $41","2 / 4","12 = 10 = sqrt(4) + sqrt(h_2)$, luego $sqrt(h_2) = 8$ y $h_2 = 64$ m. Los 8 m salen de olvidar elevar la raíz al cuadrado; los 100 m, de no contar la antena propia, y los 96 m, de restar alturas en vez de raíces ($10^2 - 4$).], tema: "T7")
#pq(12, 1, 25, "b", "estúdialo en: simulacros de estudio 11·1·24 · libro: C-T7.10", "Onda espacial (de espacio): la que rebasa el horizonte, sube a la ionosfera y vuelve",
  [En la propagación en HF, la llamada onda de espacio (onda espacial) es la que:],
  ([viaja pegada al suelo siguiendo la curvatura terrestre], [sube hasta la ionosfera, se refleja en ella y vuelve a tierra más allá del horizonte], [solo existe mientras hay visión directa entre las antenas], [se dispersa en las irregularidades de la troposfera],),
  sol: [La onda de espacio rebasa el horizonte, llega a la ionosfera y regresa a tierra a la distancia de salto: es la del DX en HF. La que sigue la curvatura del suelo es la onda de superficie, la dispersión en la troposfera es el troposcatter y la de visión directa es la onda directa de VHF y UHF.], tema: "T7")
#pq(12, 1, 26, "c", "estúdialo en: simulacros de estudio 11·1·26 · libro: C-T8.10", "Qué instrumento mide cada magnitud básica (voltímetro: tensión; amperímetro: corriente)",
  [Para conocer la potencia que consume un equipo de corriente continua dispones de un voltímetro y de un amperímetro. Debes:],
  ([dividir la tensión medida entre la corriente medida], [medir la resistencia del equipo con el voltímetro], [medir la tensión de alimentación y la corriente que toma, y multiplicarlas], [medir solo la tensión, porque el voltímetro ya indica la potencia],),
  sol: [El voltímetro mide tensión y el amperímetro, corriente; la potencia en continua es su producto, $P = V I$. Dividir tensión entre corriente da la resistencia, no la potencia, y ninguno de los dos instrumentos mide potencia ni resistencia por sí solo.], tema: "T8")
#pq(12, 1, 27, "a", "estúdialo en: simulacros de estudio 4·1·26 · libro: F-T8.9", "Influencia de la frecuencia: un polímetro común no sirve para medir tensiones de RF",
  [Quieres conocer la tensión de RF en la salida de un transmisor de 14 MHz. El instrumento adecuado es:],
  ([una sonda con diodo detector o un voltímetro de RF], [la escala de continua de un polímetro, sin sonda], [un óhmetro conectado a la salida], [la escala de alterna de un polímetro convencional],),
  sol: [Los circuitos de alterna de un polímetro corriente están pensados para los 50 Hz de la red: a unos kHz empiezan a fallar y en RF la lectura no sirve. Para RF se usan sondas con diodo detector, vatímetros u osciloscopios. La escala de continua sin sonda no ve la RF, y un óhmetro no mide tensiones.], tema: "T8")
#pq(12, 1, 28, "b", "estúdialo en: simulacros de estudio 1·1·27 · libro: T9.7", "Filtro de red (de línea de desacoplo) en la alimentación",
  [El filtro de red (de línea de desacoplo) de un transceptor actúa en los dos sentidos. ¿Qué significa?],
  ([que deja pasar la RF hacia la red y bloquea los 50 Hz], [que impide que la RF del transceptor salga a la red y que el ruido de RF de la red entre en el equipo], [que eleva la tensión de red en un sentido y la reduce en el otro], [que rectifica los dos semiciclos de la corriente de red],),
  sol: [El filtro de red frena la RF que viaja por los conductores de alimentación y deja pasar los 50 Hz sin pérdida. Funciona en ambos sentidos: ni la RF del transceptor sale a la instalación eléctrica, ni la que llega por la red entra en el equipo. Bloquear los 50 Hz dejaría el equipo sin alimentación.], tema: "T9")
#pq(12, 1, 29, "a", "estúdialo en: simulacros de estudio 12·1·28 · libro: T10.37", "Cuerpo mojado: baja la resistencia y aumenta el riesgo",
  [Una persona toca 230 V. Con la piel seca, la resistencia del camino mano-pies es de unos 10 kΩ; con las manos mojadas y descalza, de unos 1 kΩ. Al estar mojada, la corriente que la atraviesa pasa de unos:],
  ([23 mA a 230 mA], [23 mA a 2,3 mA], [23 mA a los mismos 23 mA, porque la tensión no cambia], [230 mA a 23 mA],),
  sol: [Por la ley de Ohm, $I = V slash R$: en seco, 230 / 10 000 = 23 mA; mojada, 230 / 1000 = 230 mA, diez veces más y muy por encima del umbral de fibrilación. Mojarse baja la resistencia del cuerpo y aumenta la corriente, que es lo que daña.], tema: "T10")
#pq(12, 1, 30, "c", "estúdialo en: simulacros de estudio 1·1·29 · libro: T10.11", "El diferencial protege a las personas frente a contactos indirectos y defectos de aislamiento",
  [La sensibilidad de 30 mA de los interruptores diferenciales domésticos se elige porque:],
  ([es la corriente máxima que consume un transceptor], [es la corriente de un cortocircuito en la red doméstica], [coincide con el umbral de fibrilación: están pensados para proteger a las personas], [es la corriente a partir de la cual se queman los cables de la instalación],),
  sol: [Unos 30 mA atravesando el cuerpo bastan para provocar la fibrilación del corazón. El diferencial salta con una fuga de ese orden: está pensado para salvar personas frente a contactos indirectos y defectos de aislamiento, no equipos. Los cables y los cortocircuitos manejan corrientes de amperios, que vigilan el fusible y el magnetotérmico.], tema: "T10")
#fin-prueba()
#prueba(12, 2)
#pq(12, 2, 1, "d", "estúdialo en: simulacros de estudio 4·2·1 · libro: R1.10", "Sufijo CID: C Charlie, I India (no «Italia»), D Delta (no «Dog»)",
  [Tienes que deletrear en fonía el distintivo `EC7DIA`. Lo correcto es:],
  ([Echo Charlie Siete Delta India Alfa], [Echo Charlie Seven Dog Italia Alfa], [Echo Coca Seven Delta India Able], [Echo Charlie Seven Delta India Alfa],),
  sol: [C es Charlie, D es Delta, I es India y A es Alfa, con la cifra en inglés: Seven. Dog, Coca y Able son de alfabetos antiguos, Italia no es palabra del alfabeto, y «Siete» es la cifra en castellano.], tema: "R1")
#pq(12, 2, 2, "b", "estúdialo en: simulacros de estudio 4·2·2, 8·2·2 · libro: R2.29, R2.2", "QRM (interferencia de otras estaciones) frente a QRN (parásitos atmosféricos)",
  [En un QSO en 40 m, tu corresponsal te dice: «Te copio con dificultad: hay una estación muy cerca de nuestra frecuencia que me tapa». ¿Qué grupo resume su problema?],
  ([`QRN`], [`QRM`], [`QSB`], [`QRL`],),
  sol: [La interferencia de otra estación es `QRM`, de origen humano. `QRN` serían los parásitos atmosféricos de una tormenta y `QSB` el desvanecimiento de la señal; `QRL` indica que la frecuencia está ocupada, pero no describe la interferencia.], tema: "R2")
#pq(12, 2, 3, "a", "estúdialo en: simulacros de estudio 6·2·2, 13·2·2 · libro: R2.15, C-R2.3", "QRS transmita más despacio / QRQ más deprisa",
  [Al final de un QSO lento en CW, tu corresponsal te transmite «`QRQ?`». Te está preguntando:],
  ([si debe transmitir más deprisa], [si debe transmitir más despacio], [si la frecuencia está ocupada], [si debe aumentar la potencia],),
  sol: [`QRQ` es «transmita más deprisa», y con interrogación pregunta si debe hacerlo. Más despacio es `QRS`, la pareja con la que se confunde; aumentar la potencia es `QRO` y la frecuencia ocupada, `QRL`.], tema: "R2")
#pq(12, 2, 4, "b", "estúdialo en: simulacros de estudio 8·2·4 · libro: F-R2.3", "QSX ¿quiere escuchar a… en… kHz? (frente a QSN, que mira al pasado)",
  [Una estación de la red te transmite «`QSX EA8YYY 7050 kHz`». Te está diciendo que:],
  ([ha oído antes a EA8YYY en 7050 kHz], [está escuchando a EA8YYY en 7050 kHz], [avise a EA8YYY de que le llama en 7050 kHz], [EA8YYY se ha cambiado a 7050 kHz],),
  sol: [`QSX` como pregunta es «¿quiere escuchar a… en… kHz?» y como respuesta, «escucho a… en… kHz»: habla de una escucha presente o futura. Haberle oído antes es `QSN`, que mira al pasado; avisar de que se le llama es `QRW` y el cambio de frecuencia es `QSY`.], tema: "R2")
#pq(12, 2, 5, "d", "estúdialo en: simulacros de estudio 7·2·5 · libro: R3.23", "SSB banda lateral única",
  [`USB` y `LSB` son las dos variantes de una misma modalidad de fonía, que se abrevia:],
  ([`RST`], [`CW`], [`SWL`], [`SSB`],),
  sol: [`SSB` es la banda lateral única, que puede ser la superior (`USB`) o la inferior (`LSB`). `SWL` se parece en las letras, pero es el radioescucha; `CW` es la telegrafía y `RST`, el informe de señal.], tema: "R3")
#pq(12, 2, 6, "a", "estúdialo en: simulacros de estudio 3·2·5 · libro: C-R3.3", "GM buenos días (GA es «adelante»)",
  [¿Qué significan, respectivamente, las abreviaturas `GM` y `GA`?],
  ([«buenos días» y «adelante»], [«buen mensaje» y «de nuevo»], [«buenos días» y «buenas tardes»], [«buenas noches» y «buenas tardes»],),
  sol: [`GM` (\_good morning\_) es «buenos días»; `GA` (\_go ahead\_) no es un saludo, sino «adelante». Las buenas tardes son `GE` y las buenas noches, `GN`.], tema: "R3")
#pq(12, 2, 7, "b", "estúdialo en: simulacros de estudio 5·2·7", "GN buenas noches",
  [Acabas un contacto pasada la medianoche y quieres desear al corresponsal «buenas noches». Transmites:],
  ([`GL`], [`GN`], [`GM`], [`GE`],),
  sol: [`GN` (\_good night\_) es «buenas noches». `GE` es «buenas tardes», `GM` «buenos días» y `GL` «buena suerte»: la segunda letra dice qué se desea.], tema: "R3")
#pq(12, 2, 8, "d", "estúdialo en: simulacros de estudio 13·2·8 · libro: R4.11", "Prioridad: seguridad < urgencia < socorro",
  [Ordena de mayor a menor prioridad las señales telegráficas `TTT`, `SOS` y `XXX`:],
  ([`TTT`, `XXX`, `SOS`], [`SOS`, `TTT`, `XXX`], [`XXX`, `SOS`, `TTT`], [`SOS`, `XXX`, `TTT`],),
  sol: [`SOS` es socorro, `XXX` urgencia y `TTT` seguridad, así que de mayor a menor prioridad el orden es `SOS`, `XXX`, `TTT`. La primera opción es el mismo orden, pero de menor a mayor.], tema: "R4")
#pq(12, 2, 9, "a", "estúdialo en: simulacros de estudio 12·2·9 · libro: F-R4.13", "Banda de 70 cm: 430–440 MHz",
  [Programas las memorias de un equipo de 70 cm. ¿Cuál de estas frecuencias puedes usar para transmitir en España?],
  ([438,500 MHz], [446,000 MHz], [445,000 MHz], [425,000 MHz],),
  sol: [La banda de 70 cm va de 430 a 440 MHz, así que solo 438,500 MHz cae dentro. 425 y 445 MHz están en los tramos 420–430 y 440–450 MHz, que solo se atribuyen a aficionados en algunos países de fuera de Europa.], tema: "R4")
#pq(12, 2, 10, "c", "estúdialo en: simulacros de estudio 10·2·10 · libro: R5.40", "Añadir opcionalmente el distrito desde el que se emite: EA7/EA4KLM/M",
  [EA2ABC, del distrito 2, opera en telegrafía como estación portable desde Mallorca. Si quiere indicar también, de forma opcional, el distrito desde el que emite, se identificará como:],
  ([EA8/EA2ABC/P], [EA6ABC/P], [EA6/EA2ABC/P], [EA2/EA6ABC/P],),
  sol: [Se antepone el distrito desde el que se emite (EA6, Baleares) al distintivo propio, que no cambia, y al final va /P. Cambiar la cifra del propio distintivo es el error típico: el distintivo es único y no se modifica por emitir desde otro distrito; EA8 sería Canarias.], tema: "R5")
#pq(12, 2, 11, "d", "estúdialo en: simulacros de estudio 3·2·9 · libro: R5.1", "Composición del distintivo: prefijo + distrito + sufijo",
  [Sobre el distintivo EC5ABD, es correcto afirmar que:],
  ([ABD es el prefijo, 5 el distrito y EC el sufijo], [E es el prefijo, C5 el distrito y ABD el sufijo], [EC5 es el prefijo y ABD el distrito], [EC es el prefijo, 5 el distrito y ABD el sufijo],),
  sol: [El distintivo se compone, por este orden, de prefijo + distrito + sufijo: EC es el prefijo (una de las series españolas), la cifra 5 es el distrito y ABD es el sufijo. La cifra nunca forma parte del prefijo en los distintivos españoles.], tema: "R5")
#pq(12, 2, 12, "b", "estúdialo en: simulacros de estudio 4·2·13, 13·2·11 · libro: C-R5.20, C-R5.5", "Distritos peninsulares: asignar provincia a su cifra y leer la cifra de un distintivo",
  [El distintivo EB4QTR indica, por su cifra, que su titular residía al obtenerlo en la provincia de:],
  ([Albacete], [Badajoz], [Teruel], [Jaén],),
  sol: [El distrito 4 agrupa Madrid, Castilla-La Mancha salvo Albacete y Extremadura, a la que pertenece Badajoz. Albacete es del 5, Jaén del 7 (Andalucía) y Teruel del 2 (Aragón).], tema: "R5")
#pq(12, 2, 13, "d", "estúdialo en: simulacros de estudio 7·2·12 · libro: R5.48", "Para qué se pide un distintivo temporal: concursos, experimentos, ensayos o conmemoraciones",
  [¿Cuál de estas situaciones justifica solicitar un distintivo de uso temporal?],
  ([Operar la estación de un amigo con su permiso], [Emitir desde la segunda residencia durante el verano], [Haber cambiado de distrito de residencia], [Una emisión especial para conmemorar el centenario de un faro],),
  sol: [Los distintivos temporales se piden para concursos, experimentos, ensayos o conmemoraciones. Emitir desde otro lugar es uso portable, que no requiere distintivo temporal, y mudarse no cambia el distintivo.], tema: "R5")
#pq(12, 2, 14, "c", "estúdialo en: simulacros de estudio 7·2·13 · libro: R6.8", "España pertenece a la Región 1 de la UIT",
  [Un radioaficionado español consulta el plan de bandas de la IARU para la Región 2. ¿Le sirve para operar en España?],
  ([Sí: los planes de las tres Regiones son idénticos], [Sí: España pertenece a la Región 2], [No: España pertenece a la Región 1, cuyo plan es el que rige aquí], [Solo en VHF y UHF, donde todas las Regiones coinciden],),
  sol: [España está en la Región 1 de la UIT (Europa, África, Oriente Medio y norte de Asia), y es el plan de esa Región el que se aplica aquí. La Región 2 es América, y los planes difieren entre Regiones porque las atribuciones también lo hacen.], tema: "R6")
#pq(12, 2, 15, "c", "estúdialo en: simulacros de estudio 12·2·15 · libro: F-R6.5", "20 m: 14.070–14.099 kHz para modos digitales de banda estrecha",
  [Quieres operar en RTTY o PSK en 20 m. Según el plan de bandas, la frecuencia adecuada es:],
  ([14.030 kHz], [14.200 kHz], [14.080 kHz], [14.100 kHz],),
  sol: [Los modos digitales de banda estrecha tienen en 20 m el segmento 14.070–14.099 kHz, donde está 14.080 kHz. 14.030 kHz cae en el de telegrafía, 14.100 kHz en el exclusivo de balizas y 14.200 kHz en el de todos los modos (fonía).], tema: "R6")
#pq(12, 2, 16, "b", "estúdialo en: simulacros de estudio 12·2·16 · libro: R9.26", "Emitir música está prohibido: el servicio de aficionados no es radiodifusión",
  [Para comprobar tu modulación, un corresponsal te pide que pongas una canción delante del micrófono. ¿Qué haces?],
  ([La emito, pero solo en las frecuencias de llamada], [No la emito: transmitir música no se admite, porque el de aficionados no es un servicio de radiodifusión], [La emito en FM, pero no en SSB], [La emito, porque es un ensayo técnico y estos están permitidos],),
  sol: [El servicio de aficionados es de instrucción individual, intercomunicación y estudios técnicos; emitir música lo convertiría en radiodifusión, que es otro servicio. Aunque el motivo sea técnico, emitir música sigue siendo un contenido propio de la radiodifusión.], tema: "R7")
#pq(12, 2, 17, "a", "estúdialo en: simulacros de estudio 4·2·18 · libro: F-R8.99", "Potencia máxima en 23 cm y superiores: 1000 W p.i.r.e.",
  [En la banda de 23 cm usas una antena de 13 dBi de ganancia (un factor de unos 20). Para no superar el máximo de la tabla del anexo I, ¿qué potencia puedes suministrar como mucho a la antena?],
  ([50 W], [77 W], [500 W], [1000 W],),
  sol: [Desde 23 cm el límite es de 1000 W p.i.r.e., es decir, potencia suministrada a la antena por su ganancia isótropa. Con $G_i approx 20$, la potencia máxima es $1000 / 20 = 50$ W. Los 1000 W tratan el límite como si fuera p.c.e.; 77 W sale de dividir entre los 13 dB en vez de entre el factor; 500 W aplica un 50 % que solo rige en bandas secundarias.], tema: "R8")
#pq(12, 2, 18, "c", "estúdialo en: simulacros de estudio 2·2·19 · libro: F-R8.18", "Banda de 60 m: atribución secundaria y 15 W p.i.r.e.",
  [La banda de aficionado atribuida en España con carácter secundario y con una potencia radiada máxima de 15 W p.i.r.e. es la de:],
  ([1810–1830 kHz (160 m)], [475 kHz (630 m)], [5351,5–5366,5 kHz (60 m)], [7100–7200 kHz (40 m)],),
  sol: [La banda de 60 m, de 5351,5 a 5366,5 kHz, está atribuida con carácter secundario y su potencia radiada se limita a 15 W p.i.r.e. (nota 5.133B del RR, recogida en el CNAF); no figura en la tabla del anexo I. El tramo de 1810–1830 kHz también es secundario, pero se rige por la tabla de HF rebajada al 50 %. 7100–7200 kHz es primario desde 2009, y 630 m tiene 1 W p.i.r.e. (5 W en zonas alejadas de África).], tema: "R8")
#pq(12, 2, 19, "d", "estúdialo en: simulacros de estudio 8·2·22 · libro: C-R8.5", "Requisito previo de la autorización: superar la prueba de capacitación (certificado HAREC)",
  [¿Cuál es el orden correcto de los pasos para llegar a emitir desde una estación fija propia?],
  ([Obtener una autorización provisional, superar la prueba de capacitación y obtener la licencia de estación fija], [Superar la prueba de capacitación, obtener la licencia de estación fija y obtener después la autorización], [Obtener la licencia de estación fija, superar la prueba de capacitación y obtener la autorización], [Superar la prueba de capacitación (HAREC), obtener la autorización con su distintivo y obtener la licencia de estación fija],),
  sol: [Superar la prueba es el requisito previo: da el certificado HAREC, que habilita para solicitar la autorización. La licencia de estación fija viene después, porque se asocia a una autorización ya concedida. Ponerla antes de la autorización es el error típico.], tema: "R8")
#pq(12, 2, 20, "a", "estúdialo en: simulacros de estudio 10·2·22 · libro: R8.29", "Menores: sin edad mínima; escrito fehaciente de padres o tutores",
  [Una niña de 11 años supera la prueba de capacitación. Para que obtenga su autorización de radioaficionado:],
  ([basta con que sus padres o tutores aporten un escrito fehaciente asumiendo las responsabilidades], [solo podrá emitir bajo el distintivo de un radioaficionado adulto], [debe esperar a cumplir 14 años, edad mínima para ser titular], [la autorización se expide a nombre de uno de sus padres hasta su mayoría de edad],),
  sol: [No hay edad mínima ni para examinarse ni para ser titular: el menor obtiene su propia autorización si sus padres o tutores lo autorizan de forma fehaciente y asumen las responsabilidades. La autorización es suya, con su propio distintivo, no de sus padres. Los 14 o 16 años son un error típico.], tema: "R8")
#pq(12, 2, 21, "b", "estúdialo en: simulacros de estudio 10·2·23 · libro: R8.54", "No es obligatorio disponer de estación fija",
  [Un radioaficionado solo opera con un equipo portátil y con una estación móvil en el coche: no tiene estación fija. ¿Cumple la normativa?],
  ([Solo si sus equipos figuran en la licencia de una estación fija de otro titular], [Sí: disponer de estación fija no es obligatorio], [No: no tener estación fija es causa de revocación de la autorización], [No: debe instalar una estación fija en el año siguiente a obtener la autorización],),
  sol: [No hay obligación de tener estación fija, y no tenerla no es causa de revocación (las causas son, por ejemplo, los fines comerciales o lucrativos). La licencia de estación solo la necesita la estación fija; las móviles y portátiles no la requieren.], tema: "R8")
#pq(12, 2, 22, "a", "estúdialo en: simulacros de estudio 1·2·21 · libro: R8.73", "Ninguna estación tiene derecho preferente sobre una frecuencia",
  [Llevas un rato en una frecuencia y llega otra estación que también quiere usarla. ¿Qué establece la normativa?],
  ([Ninguna de las dos tiene derecho preferente sobre esa frecuencia: el uso es compartido y se resuelve con cortesía], [Tiene prioridad la estación que emita con mayor potencia], [Tiene prioridad la estación de una asociación sobre la de un particular], [Tiene prioridad la estación cuyo distintivo tenga el sufijo más corto],),
  sol: [Ninguna estación de aficionado tiene derecho preferente sobre una frecuencia: el espectro es dominio público y su uso, compartido. Ni la potencia, ni la titularidad colectiva, ni el tipo de distintivo dan prioridad. La única regla practicable es la cortesía: preguntar si está ocupada y apartarse si lo está.], tema: "R8")
#pq(12, 2, 23, "c", "estúdialo en: simulacros de estudio 9·2·25 · libro: F-R8.24", "Equipo de segunda mano sin certificado de aceptación: cumplir el anexo I, certificado por laboratorio acreditado",
  [La vía de acreditar el cumplimiento de las características técnicas del anexo I mediante un laboratorio acreditado está prevista para:],
  ([todos los equipos de construcción propia, antes de su primer uso], [los equipos comerciales nuevos con marcado CE, al incluirlos en la licencia], [los equipos de segunda mano comercializados antes del Real Decreto 1890/2000 que carecen del certificado de aceptación radioeléctrica], [los equipos de las estaciones automáticas desatendidas],),
  sol: [El segundo párrafo del art. 5.5 exige a esos equipos de segunda mano el certificado de aceptación de su época o, si no lo tienen, el cumplimiento del anexo I certificado por un laboratorio acreditado. Los equipos caseros se usan sin autorización previa, con presentación optativa en la Jefatura, y los nuevos con marcado CE ya cumplen la legislación de su comercialización.], tema: "R8")
#pq(12, 2, 24, "c", "estúdialo en: simulacros de estudio 10·2·26 · libro: C-R8.11", "Solicitud de licencia de estación fija: con memoria descriptiva de la instalación",
  [Presentas la solicitud de licencia de estación fija con la memoria descriptiva de la instalación y la Administración la encuentra conforme. ¿Qué te permite eso?],
  ([Empezar a emitir con carácter provisional desde la estación], [Instalar la antena sin que se informe a la comunidad de propietarios], [Montar la instalación; la licencia se expedirá después, cuando comuniques el fin del montaje], [Considerar concedida la licencia de estación fija],),
  sol: [La memoria descriptiva se presenta con la solicitud para su aprobación: si es conforme, se autoriza el montaje. La licencia llega al final, tras comunicar el fin de la instalación con la documentación, y solo entonces se puede emitir. Además, aceptada la memoria, la Administración informa a la comunidad de propietarios.], tema: "R8")
#pq(12, 2, 25, "b", "estúdialo en: simulacros de estudio 7·2·24 · libro: F-R8.53", "Plazos de fin de instalación: comunicarlo en 6 semanas; la Jefatura verifica y expide en ≤ 30 días",
  [Según el artículo 20 de la Orden IET/1311/2013, ¿qué plazo tienes para comunicar a la Jefatura que has terminado la instalación de tu estación fija, y de cuánto dispone después la Jefatura para expedir la licencia?],
  ([15 días para comunicarlo; la Jefatura, como máximo 30 días], [6 semanas para comunicarlo; la Jefatura, como máximo 30 días], [30 días para comunicarlo; la Jefatura, como máximo 6 semanas], [6 semanas para comunicarlo; la Jefatura, como máximo 60 días],),
  sol: [El titular comunica el fin de la instalación en 6 semanas, con el justificante del seguro y, en su caso, el boletín del instalador; la Jefatura tiene después 30 días como máximo para verificar, inspeccionar si lo estima conveniente y expedir la licencia. Los 60 días son el límite de las modificaciones experimentales y los 15 días, el de los usos portables sin notificación.], tema: "R8")
#pq(12, 2, 26, "a", "estúdialo en: simulacros de estudio 11·2·23 · libro: F-R8.2", "Altura libre mínima de 3 m sobre el plano de paso",
  [Un dipolo horizontal sobre una azotea transitable queda, en las peores condiciones previsibles (con el hilo combado), a 2,6 m sobre el suelo de la azotea. Según el Real Decreto 2623/1986:],
  ([no cumple: debe dejar al menos 3 m libres sobre el plano de paso], [cumple, porque la altura se mide en condiciones normales, no en las peores], [cumple, porque el mínimo es de 2 m], [cumple, porque el mínimo de 3 m solo se aplica a las antenas verticales],),
  sol: [El art. 13.2 exige que, en las peores condiciones ambientales previsibles, la antena deje en todo caso 3 m libres sobre el plano de paso, y lo subraya para las horizontales. Con 2,6 m no se llega. La medida se toma en las peores condiciones, no en las normales.], tema: "R8")
#pq(12, 2, 27, "d", "estúdialo en: simulacros de estudio 12·2·28 · libro: F-R8.51", "Colectivas: licencia + autorización individualizada con distintivo propio",
  [Según el artículo 18.8, la autorización de radioaficionado individualizada que necesita una estación colectiva:],
  ([solo se exige a los repetidores y radiobalizas, no a las colectivas atendidas por operador], [es la autorización personal del presidente de la asociación, a la que se añade la licencia de la estación], [no es necesaria si la estación ya tiene licencia, porque la licencia lleva su propio distintivo], [es una autorización propia de la estación, a la que se asocia su licencia y que tiene asignado su propio distintivo de llamada],),
  sol: [El art. 18.8 exige a las estaciones colectivas, además de la licencia de estación, una autorización de radioaficionado individualizada a la que se considera asociada esa licencia y a la que se asigna un distintivo específico (arts. 27 y 28). Es distinta de las autorizaciones personales de los socios, incluida la del presidente. Y la licencia sola no basta: el distintivo va unido a la autorización.], tema: "R8")
#pq(12, 2, 28, "d", "estúdialo en: simulacros de estudio 5·2·29 · libro: R9.1", "Muy grave: interceptar sin autorización telecomunicaciones no destinadas al público",
  [Un aficionado capta con su receptor las comunicaciones de una red privada, no destinadas al público en general, y publica su contenido en internet. Según la Ley 11/2022, comete:],
  ([una infracción grave], [ninguna infracción, porque recibir no requiere autorización], [una infracción leve, porque no ha emitido nada], [una infracción muy grave],),
  sol: [Interceptar sin autorización telecomunicaciones no destinadas al público y divulgar su contenido es infracción muy grave (art. 106.15), porque ataca el secreto de las comunicaciones. Da igual no haber emitido: la conducta castigada es la interceptación, no la emisión.], tema: "R9")
#pq(12, 2, 29, "a", "estúdialo en: simulacros de estudio 7·2·29 · libro: R9.17", "Sanciones accesorias: cese, ajuste, precintado o incautación de equipos, clausura",
  [Un radioaficionado es sancionado por emitir con parámetros distintos de los autorizados. Junto con la multa, la Ley 11/2022 permite imponerle como sanción accesoria:],
  ([el ajuste de sus emisiones a los parámetros autorizados], [la repetición del examen de aptitud], [la obligación de inscribirse en una asociación de radioaficionados], [la retirada definitiva de su certificado HAREC],),
  sol: [El art. 109.2 enumera como sanciones accesorias el cese inmediato de las emisiones no autorizadas, el ajuste de las emisiones a los parámetros autorizados, el precintado o la incautación de los equipos y la clausura de las instalaciones. Repetir el examen, perder el HAREC o hacerse socio de una asociación no figuran en esa lista.], tema: "R9")
#pq(12, 2, 30, "c", "estúdialo en: simulacros de estudio 2·2·30 · libro: R9.32", "Cancelación de la autorización a petición del titular",
  [Una radioaficionada decide abandonar la actividad y quiere dar de baja su autorización. ¿Qué puede hacer?],
  ([esperar a que caduque, porque la autorización no puede cancelarse antes], [cederla a otro radioaficionado que la necesite], [pedir la cancelación en cualquier momento], [solicitar que se abra un expediente de revocación contra ella],),
  sol: [La autorización dura hasta que su titular renuncia o se revoca, y se cancela en cualquier momento a petición del titular. No caduca ni se renueva, y como es personal e intransferible no puede cederse. La revocación es la respuesta a un incumplimiento, no una forma de darse de baja voluntariamente.], tema: "R9")
#fin-prueba()
#soluciones-simulacro(12)

// ======================================================================
#simulacro(13)
#prueba(13, 1)
#pq(13, 1, 1, "d", "estúdialo en: simulacros de estudio 6·1·1, 10·1·1 · libro: T1.6, C-T1.5", "Ley de Ohm: hallar V, I o R",
  [En un circuito de corriente continua se duplica la resistencia sin variar la tensión aplicada. La corriente:],
  ([no varía, porque la tensión es la misma], [se reduce a la cuarta parte], [se duplica], [se reduce a la mitad],),
  sol: [Por la ley de Ohm, $I = V slash R$: con $V$ fija, la corriente es inversamente proporcional a la resistencia, así que al doble de resistencia le corresponde la mitad de corriente. La cuarta parte saldría si la resistencia entrara al cuadrado, como ocurre con la corriente en la potencia ($P = I^2 R$), no en la ley de Ohm.], tema: "T1")
#pq(13, 1, 2, "c", "estúdialo en: simulacros de estudio 4·1·3 · libro: T1.44", "En un circuito resistivo, tensión e intensidad están en fase",
  [En una resistencia alimentada con corriente alterna, en el instante en que la tensión alcanza su máximo, la corriente:],
  ([alcanzará su máximo un cuarto de período después], [alcanza su máximo negativo], [alcanza también su máximo], [pasa por cero],),
  sol: [En un circuito resistivo la corriente sigue a la tensión sin retraso ($i = v slash R$ en cada instante): están en fase y pasan a la vez por cero y por sus máximos. El retraso de un cuarto de período (90°) es propio de una bobina o un condensador ideales, y el máximo negativo correspondería a la oposición de fase.], tema: "T1")
#pq(13, 1, 3, "d", "estúdialo en: simulacros de estudio 5·1·3, 12·1·5 · libro: C-T1.31, T1.28", "Anchuras de banda típicas: CW < SSB (2,7 kHz) < AM (6 kHz) < FM",
  [Ordenadas de menor a mayor anchura de banda típica, las emisiones de radioaficionado quedan así:],
  ([SSB, CW, AM, FM de banda estrecha], [CW, AM, SSB, FM de banda estrecha], [CW, SSB, FM de banda estrecha, AM], [CW, SSB, AM, FM de banda estrecha],),
  sol: [La CW ocupa del orden de 100 Hz; la SSB, unos 2,7 kHz; la AM, unos 6 kHz, el doble que la SSB por llevar dos bandas laterales; y la FM de banda estrecha, de 11 a 16 kHz. La SSB es la emisión de voz más estrecha, pero la CW lo es aún más.], tema: "T1")
#pq(13, 1, 4, "b", "estúdialo en: simulacros de estudio 5·1·4 · libro: C-T1.8", "El decibelio compara niveles de potencia (escala logarítmica)",
  [Decir que una señal está «20 dB por encima» de otra significa que su potencia es:],
  ([20 W mayor], [100 veces mayor], [2 veces mayor], [20 veces mayor],),
  sol: [El decibelio compara dos potencias en escala logarítmica: $10 log_10 (P_2 slash P_1) = 20$ dB da $P_2 slash P_1 = 10^2 = 100$. No es una diferencia en vatios ni una relación lineal: cada 10 dB multiplican la potencia por 10, y duplicarla solo son 3 dB.], tema: "T1")
#pq(13, 1, 5, "c", "estúdialo en: simulacros de estudio 6·1·7 · libro: T2.13", "Energía almacenada en un condensador: ½CV² (no confundir con ½LI²)",
  [Un condensador de 100 μF cargado a 400 V almacena una energía de:],
  ([0,02 J], [0,04 J], [8 J], [16 J],),
  sol: [$E = 1/2 C V^2 = 0","5 dot 10^(-4) dot 400^2 = 8$ J. Si se olvida el factor 1/2 salen 16 J. Los 0,04 corresponden a $C V$, que es la carga en culombios y no una energía.], tema: "T2")
#pq(13, 1, 6, "d", "estúdialo en: simulacros de estudio 11·1·6 · libro: T2.54", "Electrolítico: uso principal en el filtrado de fuentes de alimentación (no en RF)",
  [¿En cuál de estos puntos de un transceptor sería un error emplear un condensador electrolítico?],
  ([en el filtro que sigue al rectificador de la fuente de alimentación], [en el filtrado de la alimentación del amplificador de audio], [en el acoplo entre dos etapas de audio], [en el circuito resonante del oscilador de 14 MHz],),
  sol: [El electrolítico ofrece mucha capacidad en poco volumen, pero tiene fugas, es polarizado y se comporta mal en RF: su sitio es el filtro de la fuente y los circuitos de audio. En un circuito resonante de radiofrecuencia se usan condensadores de mica, cerámica o aire.], tema: "T2")
#pq(13, 1, 7, "a", "estúdialo en: simulacros de estudio 1·1·8 · libro: C-T2.10", "Elevador o reductor según el número de espiras de primario y secundario",
  [Con 1200 espiras en el primario y 60 en el secundario, ¿qué hace este transformador con la tensión?],
  ([la reduce 20 veces: es un reductor], [no la cambia, porque la tensión no depende de las espiras], [la reduce 400 veces: es un reductor], [la eleva 20 veces: es un elevador],),
  sol: [Con menos espiras en el secundario que en el primario, el transformador es reductor, y la tensión baja en la misma proporción que las espiras: 1200/60 = 20. El factor 400 es el cuadrado de la relación, que corresponde a las impedancias, no a las tensiones.], tema: "T2")
#pq(13, 1, 8, "b", "estúdialo en: simulacros de estudio 7·1·7", "Tensión de conducción en directa de un diodo de silicio: 0,6–0,7 V",
  [En un rectificador de media onda con un diodo de silicio, el semiciclo positivo llega con una tensión de pico de 10 V. ¿Qué tensión de pico llega, aproximadamente, a la carga?],
  ([unos 9,94 V, porque el diodo de silicio cae unos 0,06 V], [unos 9,4 V], [10 V, porque el diodo no tiene caída en directa], [unos 8 V, porque el diodo de silicio cae unos 2 V],),
  sol: [Un diodo de silicio en directa necesita unos 0,6–0,7 V para conducir, y esa tensión se pierde en él: 10 − 0,6 ≈ 9,4 V. Una caída de unos 2 V es propia de un LED rojo, y 0,06 V es diez veces menos de lo real.], tema: "T2")
#pq(13, 1, 9, "d", "estúdialo en: simulacros de estudio 10·1·11 · libro: F-T3.42", "En VHF/UHF, terminales cortos (o SMD): la inductancia de las patas presenta reactancia apreciable",
  [Un centímetro de terminal de un componente tiene una inductancia de unos 10 nH. A 435 MHz, esa inductancia presenta una reactancia aproximada de:],
  ([270 Ω], [4,4 Ω], [2,7 Ω], [27 Ω],),
  sol: [$X_L = 2 pi f L = 2 pi dot 435 times 10^6 dot 10 times 10^(-9) approx 27$ Ω: nada despreciable en un circuito de 50 Ω, y por eso en VHF y UHF se acortan los terminales o se usan componentes de montaje superficial. Los 4,4 Ω salen de olvidar el $2 pi$, y 2,7 Ω o 270 Ω son errores de una potencia de diez al pasar los nanohenrios a henrios.], tema: "T3")
#pq(13, 1, 10, "a", "estúdialo en: simulacros de estudio 8·1·10 · libro: F-T3.47", "Filtros en pi y en T: pi paso bajo = C–L–C; T paso bajo = L–C–L (en paso alto se intercambian)",
  [La red en T formada por dos condensadores en serie con una bobina a masa entre ellos, base de muchos acopladores de antena, se comporta como un filtro:],
  ([paso alto], [paso banda], [rechazo de banda], [paso bajo],),
  sol: [Los condensadores en serie frenan las frecuencias bajas y la bobina a masa se las lleva, mientras que las altas pasan por los condensadores sin oposición: es un paso alto. La T de paso bajo es la contraria, con dos bobinas en serie y un condensador a masa (L–C–L). En las redes en pi y en T, intercambiar bobinas y condensadores convierte el paso bajo en paso alto.], tema: "T3")
#pq(13, 1, 11, "b", "estúdialo en: simulacros de estudio 5·1·10 · libro: T3.8", "Cristal de cuarzo: resonador piezoeléctrico de Q altísimo",
  [Comparado con un circuito resonante de bobina y condensador, un cristal de cuarzo empleado como resonador tiene un factor de calidad:],
  ([parecido, porque ambos son circuitos resonantes], [mucho mayor: de decenas de miles, frente a unos 200 o 300 de una bobina], [menor, por las pérdidas de su vibración mecánica], [infinito, porque el cuarzo no tiene ninguna pérdida],),
  sol: [El cuarzo es piezoeléctrico y su vibración mecánica equivale a un circuito resonante con una inductancia enorme y una resistencia de pérdidas muy pequeña, de modo que su $Q$ llega a decenas de miles; una bobina real rara vez pasa de 200–300. Las pérdidas del cristal son pequeñas, pero no nulas: su $Q$ es muy alto, no infinito.], tema: "T3")
#pq(13, 1, 12, "c", "estúdialo en: simulacros de estudio 11·1·11 · libro: T3.36", "Función del filtro de la fuente: eliminar la componente alterna (rizado) que queda tras rectificar, no la continua",
  [Si en una fuente lineal se suprime el condensador de filtro, a la salida del rectificador queda:],
  ([una tensión continua perfectamente constante], [una tensión alterna pura, igual a la del secundario], [una tensión de un solo signo, pero pulsante, con una fuerte componente alterna], [ninguna tensión, porque es el condensador el que deja pasar la continua],),
  sol: [El rectificador entrega una tensión pulsante: tiene valor medio (la continua que se busca) y una gran componente alterna, el rizado. La misión del filtro es eliminar esa componente alterna, no la continua; sin él la continua sigue ahí, pero acompañada de todo el rizado. Tampoco vuelve a ser alterna: el signo ya lo fijan los diodos.], tema: "T3")
#pq(13, 1, 13, "d", "estúdialo en: simulacros de estudio 2·1·12 · libro: C-T3.8", "Amplificar sin distorsión: trabajar en la parte lineal de la característica",
  [Un amplificador de transistor está polarizado muy cerca del corte y recibe una señal de gran amplitud. A la salida:],
  ([aparece una copia fiel de la entrada, solo que con menos ganancia], [aparece la señal invertida de fase, sin ninguna otra alteración], [aparece una copia fiel de la entrada, porque cerca del corte el transistor es más lineal], [se recorta parte de cada ciclo y la señal se distorsiona],),
  sol: [Para no distorsionar, el punto de trabajo debe estar en el centro de la parte lineal de la característica y la señal no debe abandonarla. Cerca del corte, en los semiciclos que llevan al transistor por debajo del codo deja de conducir y la salida se recorta: ya no es una copia de la entrada y aparecen armónicos. La zona próxima al corte es precisamente la menos lineal.], tema: "T3")
#pq(13, 1, 14, "a", "estúdialo en: simulacros de estudio 7·1·13 · libro: F-T3.18", "VCO: su frecuencia varía con una tensión de control, normalmente mediante un varicap",
  [En un VCO sintonizado con un diodo varicap, al aumentar la tensión inversa de control:],
  ([la capacidad del varicap disminuye y la frecuencia de oscilación sube], [la capacidad del varicap aumenta y la frecuencia de oscilación baja], [la capacidad del varicap disminuye y la frecuencia de oscilación baja], [la capacidad no cambia y lo que varía es la amplitud de salida],),
  sol: [Al subir la tensión inversa se ensancha la zona de deplexión, como si se separaran las placas, y la capacidad del varicap baja. Con menos capacidad, $f_0 = 1 slash (2 pi sqrt(L C))$ sube. Que la frecuencia baje al bajar la capacidad contradice esa fórmula, y lo que el VCO controla es la frecuencia, no la amplitud.], tema: "T3")
#pq(13, 1, 15, "a", "estúdialo en: simulacros de estudio 7·1·15", "Selectividad de canal adyacente: la fijan los faldones del filtro de FI (problema lineal)",
  [Dos filtros de FI de SSB miden 2,4 kHz de anchura a −6 dB. El primero mide 5 kHz a −60 dB y el segundo, 8 kHz a −60 dB. Frente a una emisión en el canal adyacente:],
  ([rechaza mejor el primero, porque sus faldones son más abruptos], [rechazan igual, porque tienen la misma anchura a −6 dB], [no depende del filtro, sino de la linealidad del primer mezclador], [rechaza mejor el segundo, porque deja pasar más señal],),
  sol: [La selectividad de canal adyacente la fijan los faldones del filtro de FI: la anchura a −6 dB dice qué deja pasar y la anchura a −60 dB, qué rechaza de verdad. El primero tiene un factor de forma de unos 2 y el segundo de más de 3, así que el vecino cae antes en la zona atenuada. La linealidad del mezclador afecta a la intermodulación, no a este problema lineal.], tema: "T4")
#pq(13, 1, 16, "b", "estúdialo en: simulacros de estudio 8·1·15 · libro: T4.14", "Estabilidad: mantener la frecuencia sintonizada sin derivar",
  [Un receptor de SSB, bien sintonizado al encenderlo, hace que al cabo de media hora la voz del corresponsal suene cada vez más aguda sin que hayas tocado el dial. El receptor tiene un problema de:],
  ([margen dinámico], [estabilidad], [selectividad], [sensibilidad],),
  sol: [La estabilidad es la capacidad de mantener la frecuencia sintonizada sin derivar con el tiempo o la temperatura. En SSB una deriva de unas decenas de hercios ya cambia el timbre de la voz. Ni la sensibilidad (señales débiles) ni la selectividad (señales próximas) explican un corrimiento progresivo del tono.], tema: "T4")
#pq(13, 1, 17, "a", "estúdialo en: simulacros de estudio 3·1·17 · libro: T5.27", "SSB por filtro: el modulador equilibrado suprime la portadora; el filtro elimina una banda lateral",
  [Un transmisor de SSB usa una portadora de 9,000 MHz y voz de 300 a 3000 Hz. A la salida del modulador equilibrado, antes del filtro, se encuentra:],
  ([las dos bandas laterales, de 8,997 a 8,9997 MHz y de 9,0003 a 9,003 MHz, sin portadora], [solo la banda lateral superior, de 9,0003 a 9,003 MHz], [la portadora de 9,000 MHz y las dos bandas laterales], [solo la portadora de 9,000 MHz],),
  sol: [El modulador equilibrado cancela la portadora por su simetría y deja las dos bandas laterales, a ambos lados de 9 MHz. Quedarse con una sola, por ejemplo la superior, es tarea del filtro de banda lateral que viene después. Con la portadora presente se tendría AM, no la entrada de un transmisor de SSB.], tema: "T5")
#pq(13, 1, 18, "c", "estúdialo en: simulacros de estudio 13·1·17 · libro: C-T5.30", "Excursión máxima de la NBFM: unos ±2,5 a ±5 kHz",
  [En un canal de NBFM de 12,5 kHz, la desviación de frecuencia máxima habitual es de:],
  ([±75 kHz], [±6,25 kHz], [±2,5 kHz], [±12,5 kHz],),
  sol: [La NBFM se limita a ±2,5 kHz en canales de 12,5 kHz y a ±5 kHz en canales de 25 kHz. Los ±75 kHz son la desviación de la FM de radiodifusión. Ni la anchura del canal ni su mitad son la desviación: la emisión ocupa, por la regla de Carson, bastante más que el doble de la desviación.], tema: "T5")
#pq(13, 1, 19, "a", "estúdialo en: simulacros de estudio 10·1·18 · libro: T5.30", "PEP: potencia de pico de envolvente",
  [Una portadora de AM de 50 W se modula al 100 % con un tono. Su potencia de pico de envolvente (PEP) es de:],
  ([200 W], [50 W], [75 W], [100 W],),
  sol: [Al 100 % la envolvente dobla su amplitud en la cresta y la potencia va con el cuadrado: $P_"PEP" = 2^2 times 50 = 200$ W. Los 75 W son la potencia media, $50 times 1","5$; los 100 W salen de doblar la potencia en vez de la amplitud.], tema: "T5")
#pq(13, 1, 20, "b", "estúdialo en: simulacros de estudio 10·1·21 · libro: T6.14", "Diagrama de la vertical: máximo en el plano horizontal y nulo hacia el cénit",
  [Una antena vertical sobre un buen plano de tierra radia:],
  ([con su máximo hacia el cénit y poco hacia el horizonte], [con su máximo hacia el horizonte y prácticamente nada hacia el cénit], [por igual en todas las direcciones del espacio, como la antena isótropa], [solo en la dirección hacia la que apunta uno de sus radiales],),
  sol: [Un elemento radiante emite al máximo perpendicularmente a su eje y nada a lo largo de él. Puesta en vertical, su eje apunta al cénit: allí está el nulo, y el máximo queda en el plano horizontal, a bajo ángulo. Es omnidireccional en azimut, pero no en elevación: no es una isótropa.], tema: "T6")
#pq(13, 1, 21, "d", "estúdialo en: simulacros de estudio 13·1·21 · libro: T6.4", "La Yagi es una antena directiva (un lóbulo principal dominante)",
  [Para comunicar con una estación situada en un rumbo concreto y rechazar a la vez las señales que llegan de otros rumbos, la antena más adecuada es:],
  ([una vertical de cuarto de onda], [un dipolo en V invertida], [una antena colineal omnidireccional], [una Yagi],),
  sol: [La Yagi es la antena directiva por excelencia: concentra la energía en un lóbulo principal dominante, hacia los directores, y recibe poco por los demás rumbos. La vertical y la colineal son omnidireccionales en el plano horizontal, y la V invertida tiene también un diagrama casi omnidireccional.], tema: "T6")
#pq(13, 1, 22, "c", "estúdialo en: simulacros de estudio 3·1·23 · libro: C-T6.8", "Para aumentar el alcance, lo primero es aumentar la directividad de la antena",
  [Un aficionado quiere mejorar sus comunicaciones con un corresponsal lejano situado siempre en el mismo rumbo. Si es factible, lo primero que conviene hacer es:],
  ([subir la tensión de alimentación del paso final], [instalar un amplificador que duplique la potencia del transmisor], [sustituir su antena omnidireccional por una directiva orientada hacia él], [aumentar la anchura de banda de su emisión],),
  sol: [Una antena directiva concentra la energía en la dirección del corresponsal y, por reciprocidad, también recibe mejor sus señales: una de 10 dBd multiplica por 10 la potencia efectiva radiada. Duplicar la potencia solo aporta 3 dB, exige un amplificador y no mejora la recepción. La anchura de banda no da alcance, y subir la tensión del paso final es otra forma de subir potencia.], tema: "T6")
#pq(13, 1, 23, "b", "estúdialo en: simulacros de estudio 8·1·23 · libro: C-T7.4", "A mayor frecuencia, menor alcance (144 MHz llega más fuerte que 430 MHz)",
  [Con la misma potencia, las mismas antenas y el mismo trayecto terrestre, ¿en qué banda cabe esperar el menor alcance?],
  ([la de 2 m (144 MHz)], [la de 23 cm (1,3 GHz)], [la de 70 cm (430 MHz)], [la de 6 m (50 MHz)],),
  sol: [En igualdad de condiciones, a mayor frecuencia, menor alcance: crecen las pérdidas de propagación y la onda difracta peor, así que cualquier obstáculo hace sombra. De las cuatro, la de 23 cm es la de frecuencia más alta y la de menor alcance; la de 6 m sería la de mayor alcance.], tema: "T7")
#pq(13, 1, 24, "c", "estúdialo en: simulacros de estudio 13·1·24 · libro: F-T7.16", "El horizonte radioeléctrico es algo mayor que el óptico (la troposfera curva el rayo)",
  [La fórmula del horizonte radioeléctrico usa el factor 4,12 en lugar del 3,57 del horizonte óptico. ¿A qué se debe?],
  ([a que la onda de superficie se suma a la directa y alarga el alcance], [a que las antenas de VHF suelen tener ganancia], [a que la troposfera, más densa abajo que arriba, curva ligeramente el rayo hacia el suelo], [a que la ionosfera devuelve a tierra parte de la onda directa],),
  sol: [El índice de refracción de la troposfera disminuye con la altura y el rayo se tuerce un poco hacia el suelo: equivale a una Tierra de radio 4/3 del real, y el factor sube de 3,57 a 4,12, unos 15 % más de alcance. En VHF la ionosfera es transparente y no interviene. La ganancia de las antenas mejora la señal, pero no mueve el horizonte geométrico.], tema: "T7")
#pq(13, 1, 25, "b", "estúdialo en: simulacros de estudio 4·1·24 · libro: F-T7.13", "Frecuencia óptima de trabajo ≈ 85 % de la MUF",
  [Quieres que 21 MHz sea la frecuencia óptima de trabajo de un trayecto. ¿Qué MUF necesita el trayecto, aproximadamente?],
  ([21 MHz], [unos 25 MHz], [unos 18 MHz], [unos 35 MHz],),
  sol: [La frecuencia óptima de trabajo es en torno al 85 % de la MUF, así que la MUF debe ser $21 / 0","85 approx 24","7$ MHz, unos 25 MHz. Los 18 MHz salen de multiplicar por 0,85 en vez de dividir; 21 MHz supondría trabajar en la propia MUF, sin margen, y 35 MHz corresponde a un 60 %.], tema: "T7")
#pq(13, 1, 26, "a", "estúdialo en: simulacros de estudio 2·1·26 · libro: T8.3", "Conversión entre vatios y dBm (1 mW = 0 dBm; 1 W = 30 dBm)",
  [Un transmisor entrega una potencia de 47 dBm. Expresada en vatios, es de unos:],
  ([50 W], [47 W], [100 W], [5 W],),
  sol: [47 dBm = 50 dBm − 3 dB: 50 dBm son 100 W y restar 3 dB es dividir entre 2, luego unos 50 W. Los 47 W leen los dBm como si fueran vatios; los 5 W corresponderían a 37 dBm, y los 100 W, a 50 dBm.], tema: "T8")
#pq(13, 1, 27, "d", "estúdialo en: simulacros de estudio 10·1·26 · libro: T8.22", "Dipmeter: frecuencia de resonancia de un circuito sin alimentarlo",
  [Has construido una trampa LC para una antena y quieres saber a qué frecuencia resuena sin alimentarla ni conectarle nada. Usarás:],
  ([un medidor de ROE intercalado en la línea de la antena], [un óhmetro conectado a los terminales de la trampa], [un frecuencímetro conectado a los terminales de la trampa], [un dipmeter, acercando su bobina sonda a la bobina de la trampa],),
  sol: [El dipmeter es un oscilador con una bobina exterior: acercada al circuito y barriendo la frecuencia, en la resonancia el circuito le absorbe energía y la lectura cae bruscamente. No necesita alimentar el circuito ni conectarse a él. El frecuencímetro solo mide una señal que ya existe, y la trampa, sin alimentar, no genera ninguna.], tema: "T8")
#pq(13, 1, 28, "c", "estúdialo en: simulacros de estudio 1·1·28 · libro: T9.16", "Filtro de rechazo de banda (notch) para eliminar una frecuencia concreta",
  [Una trampa formada por una bobina y un condensador en serie, conectada entre la línea y masa y sintonizada a 145 MHz, se comporta como:],
  ([un filtro paso banda: a 145 MHz es un circuito abierto y solo deja pasar esa frecuencia], [un filtro paso bajo para todas las frecuencias por encima de 145 MHz], [un filtro de rechazo: a 145 MHz es casi un cortocircuito y desvía esa señal a masa], [un amplificador selectivo de la señal de 145 MHz],),
  sol: [En resonancia, las reactancias de la bobina y del condensador en serie se anulan y la rama es casi un cortocircuito: la señal de 145 MHz se va a masa y las demás pasan. Es un filtro de rechazo de banda (notch), lo contrario de un paso banda. Un circuito pasivo no amplifica.], tema: "T9")
#pq(13, 1, 29, "c", "estúdialo en: simulacros de estudio 5·1·29 · libro: T10.25", "Calibre del fusible: ligeramente superior al consumo máximo del equipo",
  [Un transceptor de 13,8 V consume como máximo unos 20 A. El fusible más adecuado para su cable de alimentación es de:],
  ([200 A], [15 A], [25 A], [2 A],),
  sol: [El calibre debe ser ligeramente superior al consumo máximo: con 20 A de consumo, 25 A. Uno de 15 A saltaría en funcionamiento normal sin avería alguna, y uno de 200 A no protegería nada: el cable se quemaría antes de que el fusible se enterase.], tema: "T10")
#pq(13, 1, 30, "a", "estúdialo en: simulacros de estudio 10·1·30", "Protección contra el rayo: mástil y malla a tierra por el exterior, descargador y una sola tierra",
  [El descargador que se coloca en la entrada del coaxial a la vivienda:],
  ([no conduce con la tensión normal de RF y, ante una sobretensión, la deriva a tierra], [filtra los armónicos del transmisor], [adapta la impedancia de la antena a la del coaxial], [une permanentemente a tierra el conductor central del coaxial],),
  sol: [Una tormenta cercana induce sobretensiones en el coaxial aunque no caiga un rayo directo. El descargador, de gas o de chispa, no conduce a la tensión normal de la RF, pero ante una sobretensión se ceba y la deriva a tierra antes de que entre en la casa. Va unido a la misma tierra que el mástil y los chasis.], tema: "T10")
#fin-prueba()
#prueba(13, 2)
#pq(13, 2, 1, "d", "estúdialo en: simulacros de estudio 11·2·1 · libro: R1.40", "U Uniform y Z Zulu frente a palabras de alfabetos antiguos (Uncle, Zebra, Coca, Dog, Able)",
  [Un operador veterano deletrea su sufijo como «Uncle Zebra Able». Con el alfabeto vigente debería decir:],
  ([Uniform Zulu Alpha], [Uniform Zeta Alfa], [Ulises Zaragoza Antonio], [Uniform Zulu Alfa],),
  sol: [Uncle, Zebra y Able pertenecen a alfabetos anglosajones antiguos; las palabras vigentes son Uniform, Zulu y Alfa. Zeta es el nombre castellano de la letra, Ulises, Zaragoza y Antonio son del alfabeto español antiguo, y Alpha no es la grafía oficial.], tema: "R1")
#pq(13, 2, 2, "a", "estúdialo en: simulacros de estudio 4·2·3 · libro: R2.4", "QSY cambie de frecuencia",
  [Tu corresponsal dice: «Aquí hay mucho QRM; ¿hacemos `QSY` a 7,120?». Te está proponiendo:],
  ([pasar los dos a 7,120 MHz para seguir el QSO allí], [esperar unos minutos en la misma frecuencia], [subir la potencia para tapar la interferencia], [terminar el QSO y cerrar la estación],),
  sol: [`QSY` es «cambie de frecuencia»: ante la interferencia, propone continuar en 7,120. Esperar es `QRX`, subir la potencia es `QRO` y cerrar la estación es `QRT`.], tema: "R2")
#pq(13, 2, 3, "b", "estúdialo en: simulacros de estudio 3·2·2 · libro: R2.18", "QRB distancia entre estaciones",
  [En el registro de un concurso de VHF anotas que el `QRB` de un contacto es 450. Ese número indica:],
  ([la frecuencia exacta del contacto, en kHz], [la distancia, en kilómetros, entre las dos estaciones], [el número de mensajes pendientes], [la hora del contacto],),
  sol: [`QRB` se refiere a la distancia entre estaciones; en concursos y en VHF se habla del QRB de un contacto para indicar los kilómetros cubiertos. La frecuencia exacta es `QRG`, los mensajes pendientes `QTC` y la hora, `QTR`.], tema: "R2")
#pq(13, 2, 4, "b", "estúdialo en: simulacros de estudio 9·2·4 · libro: R3.1", "CQ llamada general a todas las estaciones",
  [Quieres lanzar una llamada para que te conteste cualquier estación que esté escuchando. ¿Qué abreviatura repites al principio de la llamada?],
  ([`CL`], [`CQ`], [`QRZ`], [`QSO`],),
  sol: [`CQ` es la llamada general a todas las estaciones: por eso se repite al empezar («`CQ CQ CQ DE`…»). `QRZ`? es otra cosa: pregunta «¿quién me llama?» cuando alguien ya te ha llamado y no lo has identificado. `QSO` es el comunicado ya establecido y `CL`, el cierre de la estación.], tema: "R3")
#pq(13, 2, 5, "c", "estúdialo en: simulacros de estudio 13·2·6 · libro: F-R3.2", "GL buena suerte",
  [Al final de un contacto recibes «`73 ES GL`». ¿Qué te desea el corresponsal?],
  ([saludos y hasta luego], [saludos y buenos días], [saludos y buena suerte], [saludos y buenas noches],),
  sol: [`73` son saludos, `ES` es «y» y `GL` (\_good luck\_), «buena suerte». Buenas noches sería `GN`, hasta luego `CUL` y buenos días `GM`.], tema: "R3")
#pq(13, 2, 6, "d", "estúdialo en: simulacros de estudio 8·2·7 · libro: C-R3.8", "Locator (QTH locator, Maidenhead): forma breve de dar la ubicación",
  [¿Cuál de estos es un \_locator\_ (localizador Maidenhead) bien escrito?],
  ([`EA4XYZ`], [`80INdk`], [`IN8dk0`], [`IN80dk`],),
  sol: [El \_locator\_ se escribe con dos letras, dos cifras y dos letras, como IN80dk (Madrid), y da la ubicación de forma breve. `EA4XYZ` es un distintivo de llamada, y las otras dos opciones descolocan las letras y las cifras.], tema: "R3")
#pq(13, 2, 7, "c", "estúdialo en: simulacros de estudio 13·2·7 · libro: F-R3.1", "SWL radioescucha (short wave listener)",
  [¿Qué designan, respectivamente, `SWL` y \_SWR\_?],
  ([la banda lateral única y la relación de ondas estacionarias], [el radioescucha y la banda lateral única], [el radioescucha y la relación de ondas estacionarias], [la relación de ondas estacionarias y el radioescucha],),
  sol: [`SWL` (\_short wave listener\_) es el radioescucha; \_SWR\_, con R, es la relación de ondas estacionarias (ROE). La banda lateral única es `SSB`. La primera opción cambia el orden de las dos.], tema: "R3")
#pq(13, 2, 8, "b", "estúdialo en: simulacros de estudio 3·2·7 · libro: R4.10", "Resolución 640 del RR: bandas de aficionado en socorro por catástrofes naturales",
  [Un terremoto deja sin servicio las redes de telefonía de una región. ¿Qué texto internacional, citado en el temario, invitaba a prever el uso de las bandas de aficionado en las comunicaciones de socorro en esa situación?],
  ([el plan de bandas de la IARU para la Región 1], [la Resolución 640 del Reglamento de Radiocomunicaciones], [el art. 47 de la Constitución de la UIT], [la nota 5.282 del Reglamento de Radiocomunicaciones],),
  sol: [La Resolución 640 invitaba a las administraciones a prever el empleo de las bandas de aficionado en las comunicaciones de socorro por catástrofes naturales; aunque se suprimió, el temario la sigue citando. El art. 47 de la Constitución de la UIT trata del uso falso de las señales de socorro y la nota 5.282, del servicio por satélite.], tema: "R4")
#pq(13, 2, 9, "d", "estúdialo en: simulacros de estudio 10·2·9 · libro: F-R4.8", "Límites en HF: 80 m 3500–3800 kHz, 20 m 14000–14350 kHz (¿está dentro de banda?)",
  [En España, los límites superiores de las bandas de 80 m y de 20 m son, respectivamente:],
  ([3800 kHz y 14500 kHz], [4000 kHz y 14350 kHz], [3900 kHz y 14350 kHz], [3800 kHz y 14350 kHz],),
  sol: [La banda de 80 m va de 3500 a 3800 kHz y la de 20 m, de 14000 a 14350 kHz. De 3800 a 3900 kHz hay servicios fijo y móvil, y 14500 kHz ya queda en una atribución de fijo y móvil.], tema: "R4")
#pq(13, 2, 10, "b", "estúdialo en: simulacros de estudio 8·2·11 · libro: C-R5.21", "QRP no forma parte del distintivo: se anuncia en la llamada (CQ QRP)",
  [Una estación portable que trabaja con 2 W quiere identificarse en telegrafía. ¿Cuál de estas identificaciones se ajusta a la Orden IET/1311/2013?],
  ([QRP/EA4XYZ/P], [EA4XYZ/P], [EA4XYZ/P/QRP], [EA4XYZ/QRP],),
  sol: [Al distintivo solo pueden añadirse, de forma opcional, /M, /MM, /MA o /P (art. 29.2); la baja potencia no forma parte del distintivo. Si se quiere avisar de ella, se hace en la llamada («CQ QRP»), no pegando QRP al indicativo.], tema: "R5")
#pq(13, 2, 11, "a", "estúdialo en: simulacros de estudio 6·2·10, 12·2·12 · libro: C-R5.7, R5.9", "Estaciones automáticas desatendidas: prefijo ED; sufijo con Y (analógica) o Z (digital)",
  [Una asociación del distrito 1 obtiene autorización para un repetidor digital desatendido. Su distintivo podría ser:],
  ([ED1ZAB], [EA1ZAB], [ED1URA], [ED1YAB],),
  sol: [Las estaciones automáticas desatendidas usan el prefijo ED, y su sufijo empieza por Z si son digitales (Y si son analógicas). EA no es el prefijo de las desatendidas, y UR inicia los sufijos de las estaciones colectivas de asociaciones.], tema: "R5")
#pq(13, 2, 12, "c", "estúdialo en: simulacros de estudio 11·2·14 · libro: R5.20", "Estaciones colectivas: distintivo propio; sufijos UR (asociaciones), RC y RK (radioclubes)",
  [Un radioclub obtiene autorización para su estación colectiva en el distrito 3. ¿Cuál de estos distintivos tiene un sufijo de los reservados a ese tipo de estación?],
  ([EA3ZRB], [EA3YRB], [EA3RKB], [EA3QRB],),
  sol: [Cada estación colectiva lleva su propio distintivo, y los sufijos que empiezan por RC o RK se reservan a los radioclubes (UR, a las asociaciones). Los que empiezan por Z o Y son de desatendidas, y QRB pertenece a la serie Q, que no se asigna.], tema: "R5")
#pq(13, 2, 13, "d", "estúdialo en: simulacros de estudio 9·2·12 · libro: F-R5.1", "Res. 29-07-2026: la práctica para el sufijo de una letra se acredita con 2 QSL por año en 15 de los últimos 20",
  [Según la Resolución de 29 de julio de 2026, ¿cuántas tarjetas QSL debe aportar como mínimo, en total, quien acredite la práctica internacional para un sufijo de una letra?],
  ([40], [15], [20], [30],),
  sol: [La práctica se acredita con dos QSL por año durante quince de los últimos veinte años: 2 × 15 = 30 tarjetas como mínimo. Cuarenta saldría de exigir los veinte años, y quince, de una sola tarjeta por año.], tema: "R5")
#pq(13, 2, 14, "a", "estúdialo en: simulacros de estudio 2·2·14 · libro: R6.12", "Por qué hay Regiones: atribuir bandas por zonas; por eso las bandas difieren entre España y EE. UU.",
  [Como España y Estados Unidos están en Regiones distintas de la UIT:],
  ([una misma banda de aficionado puede tener límites diferentes en uno y otro país], [deben usar husos horarios de referencia distintos en sus contactos], [los radioaficionados de ambos países no pueden comunicar entre sí], [sus distintivos tienen que llevar prefijos de la misma serie],),
  sol: [La UIT divide el mundo en Regiones para atribuir las bandas por zonas geográficas, de modo que una banda puede tener extensión distinta en la Región 1 (España) y en la 2 (EE. UU.); el caso más citado es el de 40 m. Eso no impide comunicar entre Regiones ni tiene que ver con prefijos u horarios.], tema: "R6")
#pq(13, 2, 15, "b", "estúdialo en: simulacros de estudio 13·2·14 · libro: F-R6.6", "Balizas en HF: 14.099–14.101 kHz exclusivo del International Beacon Project",
  [Operas en telegrafía en 20 m y oyes que 14.100 kHz parece libre. ¿Puedes llamar CQ allí?],
  ([Sí, porque la telegrafía puede usarse en toda la banda], [No: el tramo 14.099–14.101 kHz está reservado en exclusiva a las balizas del International Beacon Project], [Solo en caso de emergencia, porque es la frecuencia de emergencia de 20 m], [Sí, si emites con baja potencia (QRP)],),
  sol: [El plan reserva 14.099–14.101 kHz solo a las balizas del International Beacon Project, y ahí no se admite ningún QSO, ni siquiera en CW. Es cierto que la telegrafía puede usarse en casi toda la banda, pero precisamente se exceptúan los segmentos de balizas; la emergencia de 20 m está en 14.300 kHz.], tema: "R6")
#pq(13, 2, 16, "c", "estúdialo en: simulacros de estudio 9·2·17 · libro: R7.14", "Objeto de la prueba de capacitación: evaluar la capacidad para operar",
  [Una persona que ya tiene una emisora instalada en casa y sabe manejarla pregunta si necesita presentarse a la prueba de capacitación. ¿Qué le respondes?],
  ([No: basta con acreditar que es propietaria del equipo], [Solo si quiere emitir en las bandas de HF], [Sí: la prueba evalúa su capacidad para operar estaciones del servicio de aficionados y es requisito para la autorización], [No: basta con que un instalador certifique la estación],),
  sol: [La autorización exige aprobar la prueba, cuyo objeto es evaluar los conocimientos técnicos y reglamentarios para operar sin perjudicar a otros servicios. Tener el equipo o una instalación certificada son cuestiones distintas que no la sustituyen.], tema: "R7")
#pq(13, 2, 17, "c", "estúdialo en: simulacros de estudio 8·2·18 · libro: F-R8.65", "Desatendida: instalarla en 6 meses (si no, caduca la autorización de instalación)",
  [Una asociación obtuvo en marzo la autorización para instalar un repetidor y en noviembre aún no lo ha terminado. Según el artículo 26:],
  ([está en plazo, porque dispone de dieciocho meses], [se abre el procedimiento por interrupción de las emisiones durante más de tres meses], [ha superado el plazo de seis meses para finalizar la instalación, lo que supone la caducidad de la autorización de instalación], [la Jefatura Provincial le concede de oficio una prórroga de seis semanas],),
  sol: [Autorizada la instalación, la asociación tiene seis meses para finalizarla; de marzo a noviembre han pasado ocho, y el incumplimiento supone la caducidad de la autorización de instalación. Los dieciocho meses son los de las autorizaciones experimentales (art. 17). Los tres meses de interrupción (art. 25.b) se refieren a una estación que ya emite, no a una que aún no se ha instalado.], tema: "R8")
#pq(13, 2, 18, "d", "estúdialo en: simulacros de estudio 8·2·20 · libro: F-R8.98", "Potencia máxima en 50, 70 y 144 MHz (600 W p.c.e.) y en 430–440 MHz (300 W p.c.e.)",
  [Pasas de emitir en 2 m con la potencia máxima de la tabla del anexo I a emitir en 70 cm. ¿Cómo cambia la potencia máxima permitida?],
  ([sube a 1000 W p.i.r.e.], [se mantiene en 600 W p.c.e.], [baja de 1000 W a 600 W p.c.e.], [baja de 600 W a 300 W p.c.e.],),
  sol: [En 144–146 MHz la tabla fija 600 W p.c.e., y en 430–440 MHz, 300 W p.c.e.: la mitad. Bajar de 1000 a 600 W es lo que ocurre al pasar de HF a VHF, no de 2 m a 70 cm. Los 1000 W p.i.r.e. empiezan en 23 cm.], tema: "R8")
#pq(13, 2, 19, "d", "estúdialo en: simulacros de estudio 2·2·20, 10·2·21 · libro: R8.3, R8.2", "T/R 61-01 = licencia CEPT (uso temporal); T/R 61-02 = certificado HAREC",
  [El certificado HAREC que obtienes al aprobar el examen se basa en:],
  ([la Recomendación CEPT T/R 61-01], [el artículo 25 del Reglamento de Radiocomunicaciones de la UIT], [el artículo 11 de la Orden IET/1311/2013], [la Recomendación CEPT T/R 61-02],),
  sol: [El HAREC es el certificado de examen armonizado de la Recomendación CEPT T/R 61-02. La T/R 61-01 es la de la licencia CEPT para el uso temporal en otros países, y el art. 11 de la Orden es el que da a la autorización española la consideración de licencia CEPT. El art. 25 del RR trata del servicio de aficionados, no del certificado.], tema: "R8")
#pq(13, 2, 20, "c", "estúdialo en: simulacros de estudio 3·2·18, 11·2·19 · libro: C-R8.20, C-R8.14", "Extranjero residente: autorización sin examen con HAREC de un país T/R 61-02 o por reciprocidad (residencia acreditada)",
  [Una radioaficionada residente en España procede de un país que no es miembro de la CEPT pero aplica la Recomendación T/R 61-02, y tiene el HAREC de ese país. Para obtener la autorización española:],
  ([debe examinarse de nuevo, porque su país no es miembro de la CEPT], [debe residir antes diez años en España], [debe acreditar documentalmente su residencia en España y solicitarla, sin repetir el examen], [debe examinarse solo de la parte de reglamentación],),
  sol: [El art. 5.2 permite al extranjero residente obtener la autorización sin examen si tiene un HAREC expedido por un país que haya aplicado la T/R 61-02, sea o no miembro de la CEPT: el procedimiento de esa recomendación está abierto a países de fuera. Lo imprescindible es acreditar documentalmente la residencia. No hay examen parcial ni plazo mínimo de residencia.], tema: "R8")
#pq(13, 2, 21, "a", "estúdialo en: simulacros de estudio 6·2·25 · libro: R8.82", "HAREC: permite obtener la autorización en otro país que aplique la T/R 61-02 (traslado de residencia)",
  [En otro país que aplica la Recomendación T/R 61-02, el HAREC que obtuviste en España:],
  ([le sirve a ese país para expedirte su propia autorización sin que repitas el examen], [pierde su validez a los cinco años de su expedición], [te permite emitir allí directamente con tu distintivo español, sin más trámite], [solo se reconoce si ese país es miembro de la Unión Europea],),
  sol: [El HAREC acredita conocimientos, no autoriza a emitir: cualquier país que aplique la T/R 61-02 reconoce esa capacitación y puede expedir su propia autorización sin repetir el examen. La recomendación no se limita a la Unión Europea; incluso países de fuera de la CEPT pueden participar en ella. Y el HAREC no caduca.], tema: "R8")
#pq(13, 2, 22, "b", "estúdialo en: simulacros de estudio 11·2·21 · libro: R8.57", "Autorización en formato bilingüe si lo pide el interesado (lengua cooficial)",
  [Un radioaficionado de Galicia quiere que su autorización figure en castellano y en gallego. ¿Qué debe hacer?],
  ([Nada: en las comunidades con lengua cooficial se expide siempre en formato bilingüe], [Solicitarlo: la autorización se expide en formato bilingüe cuando lo pide el interesado], [Pedir a la comunidad autónoma una traducción oficial, que sustituye a la autorización], [Nada, porque no es posible: la autorización se expide solo en castellano],),
  sol: [En las comunidades con lengua cooficial, la autorización se expide en formato bilingüe si el interesado lo solicita. No es automático, así que hay que pedirlo; y tampoco está prohibido. Una traducción autonómica no sustituye a la autorización, que la expide la Administración del Estado.], tema: "R8")
#pq(13, 2, 23, "c", "estúdialo en: simulacros de estudio 3·2·22 · libro: R8.59", "Las estaciones están sometidas siempre a la inspección",
  [Un inspector de la Jefatura Provincial se presenta para comprobar una estación de aficionado sin que exista ninguna denuncia, y el titular se niega a dejarle pasar. Esa negativa:],
  ([es una infracción leve, porque no ha causado interferencias], [no es infracción: la inspección solo alcanza a las estaciones fijas con licencia], [es una infracción grave, porque las estaciones están sometidas siempre a la inspección], [es una infracción muy grave, castigada con multa de hasta 20 millones de euros],),
  sol: [La sujeción a la inspección es permanente y forma parte de las condiciones de la autorización, con o sin denuncia. Negarse a la inspección u obstruirla es infracción grave (art. 107 de la Ley 11/2022). Las muy graves son, por ejemplo, interferir deliberadamente o no atender el requerimiento de cese.], tema: "R8")
#pq(13, 2, 24, "d", "estúdialo en: simulacros de estudio 5·2·23 · libro: C-R8.6", "Contenido de la memoria: toma de tierra, plano, equipos (no el empadronamiento)",
  [¿Cuál de estos datos forma parte de la memoria técnica que acompaña a la solicitud de licencia de estación fija?],
  ([El certificado de empadronamiento del solicitante], [El original del certificado HAREC del solicitante], [El acta de la junta de propietarios que aprueba la instalación], [La relación de equipos radioeléctricos con su marca, modelo y número de serie],),
  sol: [La memoria describe la instalación: relación de equipos con marca, modelo y número de serie, antenas y soportes, toma de tierra y plano de ubicación. Son datos de la estación, no del solicitante, por eso no incluye el empadronamiento ni el HAREC. La comunidad no aprueba la instalación: solo puede alegar.], tema: "R8")
#pq(13, 2, 25, "b", "estúdialo en: simulacros de estudio 13·2·24 · libro: C-R8.17", "Montaje por instalador de telecomunicaciones inscrito, salvo instalaciones simples autorizadas por el Jefe Provincial",
  [¿Quién puede autorizar que el propio radioaficionado monte el sistema radiante de su estación fija, sin instalador?],
  ([La junta de la comunidad de propietarios, por mayoría simple], [El Jefe Provincial de Inspección de Telecomunicaciones, a la vista de la memoria, si la instalación es tan sencilla que no presenta riesgos], [La empresa instaladora, delegando el montaje por escrito], [El propio radioaficionado decide, si tiene el certificado HAREC],),
  sol: [La regla general es el montaje por un instalador de telecomunicaciones inscrito en el registro. La excepción la concede el Jefe Provincial cuando, vista la memoria técnica, la instalación es tan simple que no presenta razonablemente riesgos para personas o bienes (art. 19.e). Ni la comunidad ni el instalador pueden concederla, y el HAREC no habilita para montar instalaciones.], tema: "R8")
#pq(13, 2, 26, "a", "estúdialo en: simulacros de estudio 7·2·28 · libro: F-R8.39", "Memoria técnica de la autorización experimental: contenido (experimento, diagrama si es casero, coordenadas, período, banda, emisión, potencia, antena)",
  [Vas a solicitar una autorización especial experimental utilizando un transceptor comercial. ¿Qué dato NO tienes que incluir en la memoria técnica?],
  ([El diagrama de bloques del equipo], [El tipo y la ganancia de la antena], [La denominación de la emisión], [Las coordenadas geográficas de la instalación],),
  sol: [La memoria del art. 17.2 describe el experimento, el lugar con sus coordenadas, el período, la banda, la denominación de la emisión, la potencia de salida y el tipo y la ganancia de la antena. El diagrama de bloques solo se exige si el equipo es de construcción propia; con un transceptor comercial no hace falta.], tema: "R8")
#pq(13, 2, 27, "b", "estúdialo en: simulacros de estudio 12·2·26 · libro: R8.69", "Estación portable: la fija usada temporalmente en otra ubicación",
  [Durante el verano trasladas tu estación fija desde tu domicilio a tu apartamento de la playa y la utilizas allí unas semanas. Según las definiciones de la Orden IET/1311/2013, en ese apartamento funciona como una estación:],
  ([temporal], [portable], [portátil], [móvil],),
  sol: [La estación portable es la estación fija utilizada con carácter temporal en una ubicación determinada distinta de la habitual: justo el caso del apartamento. No es móvil, porque no se usa en movimiento ni detenida en puntos no determinados; tampoco portátil, que es la móvil con antena y fuente de energía incorporadas. La temporal es la de concursos, expediciones, demostraciones o ferias, no la de unas vacaciones.], tema: "R8")
#pq(13, 2, 28, "a", "estúdialo en: simulacros de estudio 5·2·27 · libro: F-R8.57", "Repetidor analógico-digital accedido por red pública: código personal e intransferible + distintivo",
  [Un radioaficionado quiere prestar a un amigo, también radioaficionado, el código con el que accede a través de una red pública a un repetidor analógico-digital. Según el artículo 23:],
  ([no puede: el código es personal e intransferible, y su amigo debe pedir el suyo al responsable del repetidor, que está obligado a facilitárselo], [puede, siempre que su amigo se identifique con el distintivo del titular del código], [puede, porque el acceso a los repetidores es libre], [no puede, porque solo los socios de la asociación titular pueden tener código],),
  sol: [Si el acceso a un repetidor analógico-digital se hace por una red pública, solo es posible con un código personal, intransferible y distinto para cada usuario, más el distintivo de la estación del operador. Por eso el código no se presta. El responsable del repetidor debe facilitar el código a todo radioaficionado que lo pida, no solo a los socios. El acceso libre de los repetidores analógicos y digitales finales es otra regla (art. 25.c), y no autoriza a ceder un código personal.], tema: "R8")
#pq(13, 2, 29, "d", "estúdialo en: simulacros de estudio 11·2·29 · libro: R9.7", "Las infracciones se tipifican en la Ley General de Telecomunicaciones",
  [Las infracciones en que puede incurrir hoy un radioaficionado están tipificadas en la Ley General de Telecomunicaciones vigente, que es la:],
  ([Orden IET/1311/2013], [Ley 9/2014], [Ley 32/2003], [Ley 11/2022],),
  sol: [La Ley General de Telecomunicaciones vigente es la Ley 11/2022, que tipifica las infracciones en sus arts. 106 a 108. Las Leyes 9/2014 y 32/2003 son las anteriores, de ahí que algunas preguntas antiguas den otros grados. La Orden IET/1311/2013 regula el servicio de aficionados, pero no tipifica las infracciones: remite a la Ley.], tema: "R9")
#pq(13, 2, 30, "a", "estúdialo en: simulacros de estudio 9·2·29 · libro: F-R9.11", "Leve: instalar una estación de radioaficionado sin autorización",
  [Una persona sin autorización de radioaficionado monta en casa una estación completa de aficionado, aunque todavía no ha emitido. Según la Ley 11/2022:],
  ([comete una infracción leve, con multa de hasta 100 000 euros], [no comete infracción mientras no emita], [comete una infracción grave, con multa de hasta 2 millones de euros], [comete una infracción muy grave, con multa de hasta 20 millones de euros],),
  sol: [El art. 108.4 tipifica como leve la instalación de estaciones de radioaficionado careciendo de autorización, y la multa de las leves llega a 100 000 euros (art. 109.1.d). La ley castiga la propia instalación, sin exigir que la estación emita. El grave del art. 107.1 se refiere en general a otras estaciones radioeléctricas; para las de aficionado existe el tipo leve propio.], tema: "R9")
#fin-prueba()
#soluciones-simulacro(13)

#mapa-inicio()
#mapa-cuerpo[
#mapa-tema("T1", "Teoría de la electricidad, el electromagnetismo y la radio")
#mapa-item("Unidades de intensidad, tensión, resistencia y potencia (A, V, Ω, W)", "8·1·1 (estudio 9·1·1)")
#mapa-item("Equivalencias de la ley de Ohm: 1 Ω = 1 V/1 A y 1 V = 1 Ω · 1 A", "1·1·1 (estudio 5·1·1)")
#mapa-item("Carga y corriente: 1 C = 1 A · 1 s y 1 A = 1 C/s", "3·1·1 (estudio 1·1·1)")
#mapa-item("Prefijos del SI y conversión entre múltiplos y submúltiplos", "3·1·2 (estudio 5·1·2)")
#mapa-item("Ley de Ohm: hallar V, I o R", "2·1·1 (estudio 6·1·1), 13·1·1 (estudio 10·1·1)")
#mapa-item("Resistencia de un conductor: R = ρ l / S", "11·1·1 (estudio 13·1·1)")
#mapa-item("Potencia eléctrica: P = V I = I² R = V² / R", "2·1·2 (estudio 8·1·1), 7·1·1 (estudio 1·1·2)")
#mapa-item("Ley de Kirchhoff de las corrientes (nudos)", "9·1·1 (estudio 6·1·2)")
#mapa-item("Ley de Kirchhoff de las tensiones (mallas)", "12·1·1 (estudio 12·1·1)")
#mapa-item("Ley de Coulomb: proporcional al producto de las cargas e inversa al cuadrado de la distancia", "1·1·2 (estudio 13·1·2)")
#mapa-item("La batería convierte energía química en eléctrica", "12·1·2 (estudio 4·1·1)")
#mapa-item("Fuerza electromotriz: caracteriza al generador y se mide en voltios", "2·1·3 (estudio 12·1·2)")
#mapa-item("Fuente real: V = ε − I r y corriente de cortocircuito ε / r", "7·1·2 (estudio 9·1·2)")
#mapa-item("Asociación de pilas: en serie se suman las tensiones; en paralelo, las corrientes (y baja la resistencia interna)", "6·1·1 (estudio 3·1·1), 10·1·1 (estudio 8·1·2)")
#mapa-item("Capacidad de una batería en amperios-hora: t = C / I", "7·1·3 (estudio 3·1·2)")
#mapa-item("Las ondas de radio son electromagnéticas", "6·1·2 (estudio 13·1·3)")
#mapa-item("Onda electromagnética: campos E y B perpendiculares entre sí y a la propagación", "10·1·2 (estudio 9·1·3)")
#mapa-item("Velocidad de propagación: c = 300.000 km/s, constante y sin depender de la frecuencia", "6·1·3 (estudio 12·1·3), 11·1·2 (estudio 7·1·1)")
#mapa-item("Longitud de onda: λ = c / f, λ (m) ≈ 300 / f (MHz)", "9·1·2 (estudio 11·1·1)")
#mapa-item("Frecuencia: ciclos por segundo (Hz), la característica de la corriente alterna", "9·1·3 (estudio 6·1·3)")
#mapa-item("Período: T = 1 / f, tiempo entre dos máximos consecutivos", "11·1·3 (estudio 10·1·2)")
#mapa-item("Valor eficaz: definición por el efecto calorífico; la tensión de red se da en eficaz", "3·1·3 (estudio 4·1·2), 9·1·4 (estudio 11·1·2)")
#mapa-item("Conversión entre valores de pico, pico a pico y eficaz de una sinusoide (V_ef = V_p / √2)", "4·1·1 (estudio 13·1·4), 10·1·3 (estudio 2·1·1)")
#mapa-item("En un circuito resistivo, tensión e intensidad están en fase", "13·1·2 (estudio 4·1·3)")
#mapa-item("Factor de potencia: coseno del desfase entre tensión y corriente", "10·1·4 (estudio 11·1·3)")
#mapa-item("Señales no sinusoidales: fundamental y armónicos (onda cuadrada: solo impares)", "4·1·2 (estudio 1·1·3)")
#mapa-item("Ruido térmico y ruido blanco: P = k T B, independiente de la frecuencia", "1·1·3 (estudio 12·1·4)")
#mapa-item("Objeto de la modulación: que la portadora transporte la información", "5·1·1 (estudio 6·1·4)")
#mapa-item("Parámetro que varía en cada modulación analógica (AM amplitud, FM frecuencia, PM fase)", "8·1·2 (estudio 3·1·3)")
#mapa-item("Espectro de AM: portadora y dos bandas laterales en f_c ± f_m", "3·1·4 (estudio 11·1·4)")
#mapa-item("Anchuras de banda típicas: CW < SSB (2,7 kHz) < AM (6 kHz) < FM", "1·1·4 (estudio 12·1·5), 13·1·3 (estudio 5·1·3)")
#mapa-item("Potencia de AM: P_t = P_c (1 + m²/2), reparto entre portadora y bandas", "4·1·3 (estudio 4·1·4)")
#mapa-item("SSB (J3E): una sola banda lateral, sin portadora", "1·1·5 (estudio 7·1·2)")
#mapa-item("FM: amplitud constante; varía la frecuencia instantánea", "8·1·3 (estudio 7·1·3)")
#mapa-item("Regla de Carson: B ≈ 2 (Δf + f_m)", "2·1·4 (estudio 2·1·2)")
#mapa-item("FSK, PSK y QAM: qué parámetro de la portadora varía cada una", "12·1·3 (estudio 3·1·4)")
#mapa-item("Bits por símbolo (log₂ M) y velocidad binaria = baudios × bits por símbolo", "7·1·4 (estudio 7·1·4)")
#mapa-item("CRC detecta errores; FEC los corrige sin retransmisión a costa de velocidad útil", "8·1·4 (estudio 8·1·3)")
#mapa-item("El decibelio compara niveles de potencia (escala logarítmica)", "13·1·4 (estudio 5·1·4)")
#mapa-item("Referencias de decibelios: ×2 = +3 dB, ×4 = +6 dB, ×10 = +10 dB, ÷2 = −3 dB", "4·1·4 (estudio 1·1·4), 9·1·5 (estudio 6·1·5)")
#mapa-item("En una cadena, las ganancias y pérdidas en dB se suman y restan", "6·1·4 (estudio 2·1·3)")
#mapa-item("Energía = potencia × tiempo (julio = W·s, kWh)", "5·1·2 (estudio 10·1·3)")
#mapa-item("Conversores A/D y D/A: qué convierte cada uno", "5·1·3 (estudio 8·1·4)")
#mapa-item("Teorema de Nyquist: f_s ≥ 2 f_máx", "4·1·5 (estudio 10·1·4), 12·1·4 (estudio 4·1·5)")
#mapa-item("Aliasing: las frecuencias por encima de f_s/2 se confunden con otras más bajas", "5·1·4 (estudio 2·1·4)")
#mapa-item("Filtros antisolapamiento (paso bajo antes del A/D) y de reconstrucción (paso bajo tras el D/A)", "11·1·4 (estudio 9·1·4)")
#mapa-tema("T2", "Componentes")
#mapa-item("Código de colores: cifra que representa cada color (negro 0 … blanco 9)", "12·1·5 (estudio 10·1·5)")
#mapa-item("Código de colores: leer el valor de una resistencia de cuatro bandas (cifras + multiplicador)", "8·1·5 (estudio 5·1·5)")
#mapa-item("Código de colores: la cuarta banda es la tolerancia (oro ±5 %, plata ±10 %, marrón ±1 %)", "7·1·5 (estudio 1·1·5)")
#mapa-item("Una resistencia fija se especifica por valor, potencia de disipación y tolerancia", "9·1·6 (estudio 5·1·6)")
#mapa-item("Disipación máxima de una resistencia: tensión o corriente máximas a partir de P y R", "12·1·6 (estudio 13·1·5)")
#mapa-item("En un conductor metálico la resistencia aumenta con la temperatura", "12·1·7 (estudio 3·1·5)")
#mapa-item("Termistores: PTC sube y NTC baja su resistencia al aumentar la temperatura", "1·1·6 (estudio 2·1·5)")
#mapa-item("Varistor (VDR): su resistencia depende de la tensión aplicada; protege contra sobretensiones", "2·1·5 (estudio 11·1·5)")
#mapa-item("Unidad de capacidad: el faradio (no mide la carga)", "8·1·6 (estudio 8·1·5)")
#mapa-item("Capacidad: C = Q/V; el condensador almacena carga eléctrica", "3·1·5 (estudio 3·1·6)")
#mapa-item("C = εS/d: la capacidad depende de la superficie, la separación y el dieléctrico", "9·1·7 (estudio 6·1·6)")
#mapa-item("La reactancia capacitiva disminuye al aumentar la frecuencia", "7·1·6 (estudio 13·1·6)")
#mapa-item("Cálculo de la reactancia capacitiva X_C = 1/(2πfC)", "1·1·7 (estudio 1·1·6)")
#mapa-item("Energía almacenada en un condensador: ½CV² (no confundir con ½LI²)", "13·1·5 (estudio 6·1·7)")
#mapa-item("El condensador se opone a las variaciones de tensión; la bobina, a las de corriente", "2·1·6 (estudio 10·1·6)")
#mapa-item("En continua los condensadores se cargan al principio y luego bloquean la corriente", "11·1·5 (estudio 12·1·6)")
#mapa-item("Constante de tiempo τ = RC: 63 % de la carga en un τ, carga completa en unos 5τ", "1·1·8 (estudio 2·1·6)")
#mapa-item("Electrolítico: el dieléctrico es una capa de óxido (con el electrolito como pasta)", "10·1·5 (estudio 12·1·7)")
#mapa-item("Electrolítico: polarizado, hay que respetar la polaridad", "4·1·6 (estudio 12·1·8)")
#mapa-item("Electrolítico: uso principal en el filtrado de fuentes de alimentación (no en RF)", "13·1·6 (estudio 11·1·6)")
#mapa-item("Descarga segura de un condensador a través de un elemento exterior", "7·1·7 (estudio 4·1·6)")
#mapa-item("Unidad de autoinducción: el henrio", "11·1·6 (estudio 7·1·5)")
#mapa-item("La bobina almacena energía en el campo magnético (½LI²)", "5·1·5 (estudio 6·1·8)")
#mapa-item("La autoinducción depende de la construcción de la bobina (núcleo, dimensiones, temperatura), no de la señal", "6·1·5 (estudio 11·1·7)")
#mapa-item("La reactancia inductiva X_L = 2πfL crece con la frecuencia y es nula en continua", "3·1·6 (estudio 1·1·7), 8·1·7 (estudio 8·1·6)")
#mapa-item("Cálculo de la reactancia inductiva X_L = 2πfL", "6·1·6 (estudio 10·1·7)")
#mapa-item("Desfase en reactancias puras: en la bobina la tensión adelanta 90° (en el condensador, la corriente)", "12·1·8 (estudio 7·1·6)")
#mapa-item("Efecto pelicular: en RF la corriente va por la superficie y la resistencia efectiva aumenta", "4·1·7 (estudio 9·1·5)")
#mapa-item("El transformador son dos bobinas acopladas que transforman una alterna en otra alterna", "4·1·8 (estudio 8·1·7)")
#mapa-item("Con continua en el primario no hay corriente en el secundario", "4·1·9 (estudio 10·1·8)")
#mapa-item("Relación de transformación: cociente de tensiones o de espiras", "5·1·6 (estudio 9·1·6)")
#mapa-item("Elevador o reductor según el número de espiras de primario y secundario", "13·1·7 (estudio 1·1·8)")
#mapa-item("Cálculo de la tensión del secundario: V_s = V_p · N_s/N_p", "5·1·7 (estudio 11·1·8)")
#mapa-item("Corrientes en el transformador ideal: van en proporción inversa a las tensiones (potencia constante)", "10·1·6 (estudio 3·1·7)")
#mapa-item("El transformador también sirve para adaptar impedancias", "6·1·7 (estudio 4·1·7)")
#mapa-item("Cálculo de la adaptación de impedancias: Z_p = (N_p/N_s)² Z_s (balun 4:1 = espiras 2:1)", "5·1·8 (estudio 8·1·8)")
#mapa-item("El diodo deja pasar la corriente en un solo sentido", "6·1·8 (estudio 12·1·9)")
#mapa-item("Aplicación del diodo: detección (y rectificación)", "1·1·9 (estudio 13·1·7)")
#mapa-item("Tensión de conducción en directa de un diodo de silicio: 0,6–0,7 V", "13·1·8 (estudio 7·1·7)")
#mapa-item("Diodo zéner: estabiliza tensión trabajando en inversa, en la zona de ruptura", "2·1·7 (estudio 7·1·8), 10·1·7 (estudio 13·1·8)")
#mapa-item("LED: emite luz polarizado en directa", "5·1·9 (estudio 2·1·7)")
#mapa-item("Varicap: capacidad controlada por la tensión inversa (más tensión, menos capacidad)", "11·1·7 (estudio 5·1·7)")
#mapa-item("Transistor bipolar: terminales emisor, base y colector; tipos NPN y PNP", "2·1·8 (estudio 10·1·9), 10·1·8 (estudio 4·1·8)")
#mapa-item("Ganancia de corriente β = I_C/I_B", "9·1·8 (estudio 3·1·8)")
#mapa-item("Polarización: en el NPN el colector es positivo; en el PNP, negativo", "10·1·9 (estudio 13·1·9)")
#mapa-item("Usos del transistor: amplificar, oscilar, mezclar (no rectificar ni hacer de balun)", "8·1·8 (estudio 6·1·9)")
#mapa-item("FET y MOSFET: terminales puerta, drenador y surtidor; control por tensión de puerta", "3·1·7 (estudio 5·1·8)")
#mapa-item("Ventaja del FET: impedancia de entrada muy alta", "11·1·8 (estudio 9·1·7)")
#mapa-item("Electrodos de la válvula diodo (cátodo y placa) y del tríodo (+ rejilla)", "7·1·8 (estudio 2·1·8)")
#mapa-item("Emisión termoiónica: el cátodo caliente emite y la válvula conduce solo con la placa positiva", "8·1·9 (estudio 9·1·8)")
#mapa-item("El nombre de la válvula cuenta electrodos: pentodo = cátodo, tres rejillas y placa", "3·1·8 (estudio 1·1·9)")
#mapa-item("Símbolos de resistencia, condensador, bobina y diodo", "2·1·9 (estudio 4·1·9)")
#mapa-item("Símbolos de transistores: bipolar frente a FET", "9·1·9 (estudio 3·1·9)")
#mapa-tema("T3", "Circuitos")
#mapa-item("Resistencias en serie: la corriente es la misma en todas y la caída de tensión es proporcional a cada R", "5·1·10 (estudio 7·1·9)")
#mapa-item("Resistencias en paralelo: tensión común; la corriente de cada rama es inversamente proporcional a R y la total es la suma (Kirchhoff)", "9·1·10 (estudio 10·1·10)")
#mapa-item("Resistencia equivalente: serie suma, paralelo menor que la menor (producto/suma; n iguales, R/n); circuitos mixtos", "6·1·9 (estudio 6·1·10)")
#mapa-item("Asociación de condensadores: en paralelo se suman; en serie, por inversas (al revés que las resistencias)", "11·1·9 (estudio 2·1·9)")
#mapa-item("Asociación de bobinas sin acoplo: como las resistencias (serie suman; paralelo producto/suma)", "12·1·9 (estudio 5·1·9)")
#mapa-item("Impedancia de un circuito RLC serie: X = XL − XC, Z = √(R² + X²) e I = V/Z", "11·1·10 (estudio 12·1·10)")
#mapa-item("Condensador en continua, en régimen permanente: circuito abierto (queda el divisor resistivo)", "6·1·10 (estudio 1·1·10)")
#mapa-item("Acoplo entre circuitos y etapas: las oscilaciones de uno pasan al otro; el acoplamiento deja pasar la señal y separa las polarizaciones", "2·1·10 (estudio 11·1·9)")
#mapa-item("Condensador real: por encima de su autorresonancia se comporta como una bobina", "12·1·10 (estudio 4·1·10)")
#mapa-item("Bobina real: la capacidad entre espiras la hace autorresonar; por encima se comporta como un condensador", "1·1·10 (estudio 6·1·11)")
#mapa-item("En VHF/UHF, terminales cortos (o SMD): la inductancia de las patas presenta reactancia apreciable", "13·1·9 (estudio 10·1·11)")
#mapa-item("Condición de resonancia: XL = XC, las reactancias se cancelan y el circuito es puramente resistivo", "8·1·10 (estudio 7·1·10)")
#mapa-item("Frecuencia de resonancia f0 = 1/(2π√(LC)): cálculo y dependencia con L y C", "7·1·9 (estudio 12·1·11)")
#mapa-item("Factor de calidad Q: mide la selectividad; Q = f0/B", "2·1·11 (estudio 1·1·11)")
#mapa-item("Q = X/R en resonancia y ancho de banda B = f0/Q", "5·1·11 (estudio 13·1·10)")
#mapa-item("Resonancia serie (Z mínima) frente a paralelo o tanque (Z máxima); LC serie en derivación = trampa", "10·1·10 (estudio 9·1·9)")
#mapa-item("Filtro paso banda: deja pasar su banda y atenúa por encima y por debajo; es el de la FI", "5·1·12 (estudio 3·1·10)")
#mapa-item("Filtro paso bajo: deja pasar las frecuencias inferiores a la de corte (a la salida del TX, contra armónicos)", "11·1·11 (estudio 8·1·9)")
#mapa-item("Frecuencia de corte: separa banda de paso y de atenuación; se toma a −3 dB", "5·1·13 (estudio 11·1·10)")
#mapa-item("Filtro RC: fc = 1/(2πRC)", "8·1·11 (estudio 4·1·11)")
#mapa-item("Filtros en pi y en T: pi paso bajo = C–L–C; T paso bajo = L–C–L (en paso alto se intercambian)", "13·1·10 (estudio 8·1·10)")
#mapa-item("Cristal de cuarzo: resonador piezoeléctrico de Q altísimo", "13·1·11 (estudio 5·1·10)")
#mapa-item("Filtro de cuarzo en la FI: su Q altísimo da selectividad elevada con banda estrecha y estable", "7·1·10 (estudio 12·1·12)")
#mapa-item("Filtro digital (DSP): opera con muestras numéricas; cadena A/D → cálculo en el DSP → D/A", "6·1·11 (estudio 9·1·10)")
#mapa-item("Filtros FIR (sin realimentación, respuesta finita) e IIR (realimentan la salida, respuesta infinita)", "9·1·11 (estudio 13·1·11)")
#mapa-item("Función del rectificador: convertir la alterna en continua (pulsante)", "10·1·11 (estudio 1·1·12)")
#mapa-item("Media onda frente a onda completa: la completa aprovecha los dos semiciclos, dobla el valor medio y da menos rizado", "5·1·14 (estudio 2·1·10)")
#mapa-item("Número de diodos: media onda 1; onda completa con toma media 2; puente 4", "3·1·9 (estudio 4·1·12)")
#mapa-item("Frecuencia del rizado: 100 Hz en onda completa y 50 Hz en media onda (red de 50 Hz)", "7·1·11 (estudio 9·1·11)")
#mapa-item("Función del filtro de la fuente: eliminar la componente alterna (rizado) que queda tras rectificar, no la continua", "13·1·12 (estudio 11·1·11)")
#mapa-item("Bloques de una fuente lineal y su orden: transformador → rectificador → filtro → regulador (reconocer el esquema)", "3·1·10 (estudio 11·1·12)")
#mapa-item("Regulador: mantiene constante la tensión de salida aunque varíen la carga y la red", "3·1·11 (estudio 2·1·11)")
#mapa-item("Regulador con zéner y resistencia en serie: reparto de corrientes entre zéner y carga", "4·1·10 (estudio 13·1·12)")
#mapa-item("Fuente lineal frente a conmutada: la lineal pesa (transformador de 50 Hz) y rinde poco; la conmutada trabaja a decenas–cientos de kHz, ligera y eficiente", "4·1·11 (estudio 3·1·11)")
#mapa-item("Fuente conmutada: genera ruido de RF (QRM en HF); exige filtrado y apantallado", "2·1·12 (estudio 4·1·13)")
#mapa-item("Condensadores de desacoplo: absorben los transitorios de la alimentación", "1·1·11 (estudio 10·1·12)")
#mapa-item("Emisor común: ganancia de tensión y de corriente, luego de potencia", "12·1·11 (estudio 8·1·11)")
#mapa-item("Emisor común: único montaje que invierte la fase 180°", "7·1·12 (estudio 10·1·13)")
#mapa-item("Base común: amplifica tensión, pero no corriente", "2·1·13 (estudio 6·1·12)")
#mapa-item("Colector común = seguidor de emisor (ganancia de tensión ≈ 1; adaptador de impedancias)", "6·1·12 (estudio 4·1·14)")
#mapa-item("Amplificar sin distorsión: trabajar en la parte lineal de la característica", "13·1·13 (estudio 2·1·12)")
#mapa-item("Ángulo de conducción: A 360°, AB entre 180° y 360°, B 180°, C menos de 180°", "12·1·12 (estudio 13·1·13)")
#mapa-item("Linealidad frente a rendimiento: clase A mínima distorsión; clase C mayor rendimiento", "11·1·12 (estudio 8·1·12)")
#mapa-item("Clase AB: combinación de A y B; la de los amplificadores lineales de SSB", "4·1·12 (estudio 6·1·13)")
#mapa-item("Clase C: solo para emisiones de amplitud constante (CW, FM), nunca SSB ni AM", "2·1·14 (estudio 5·1·11)")
#mapa-item("Neutralización: anula la realimentación parásita para que el amplificador no oscile", "8·1·12 (estudio 7·1·11)")
#mapa-item("Realimentación: devolver parte de la salida a la entrada; la negativa reduce la ganancia y mejora estabilidad y linealidad, la positiva hace oscilar", "10·1·12 (estudio 1·1·13)")
#mapa-item("Amplificador operacional: ganancia muy alta, impedancia de entrada alta y de salida baja", "11·1·13 (estudio 5·1·12)")
#mapa-item("Operacional inversor: G = −R2/R1 (no inversor: 1 + R2/R1)", "1·1·12 (estudio 12·1·13)")
#mapa-item("Ganancia de tensión en decibelios: 20·log(V2/V1)", "3·1·12 (estudio 3·1·12)")
#mapa-item("Detector de envolvente (diodo + RC): detector de AM; reconocer su esquema", "6·1·13 (estudio 13·1·14)")
#mapa-item("El detector de envolvente es asíncrono: no necesita sincronización con el transmisor", "8·1·13 (estudio 9·1·12)")
#mapa-item("Discriminador de FM: convierte variaciones de frecuencia en variaciones de tensión (audio)", "12·1·13 (estudio 8·1·13)")
#mapa-item("Limitador delante del discriminador: recorta las variaciones de amplitud (ruido)", "9·1·12 (estudio 7·1·12)")
#mapa-item("Oscilador: convierte la corriente continua en alterna", "8·1·14 (estudio 3·1·13)")
#mapa-item("Condición de oscilación (Barkhausen): realimentación positiva, ganancia de lazo que compensa pérdidas y fase de 360°", "9·1·13 (estudio 9·1·13)")
#mapa-item("Estabilidad del oscilador: la temperatura hace derivar su frecuencia", "3·1·13 (estudio 5·1·13)")
#mapa-item("Oscilador a cristal: frecuencia muy estable (y apenas ajustable)", "10·1·13 (estudio 10·1·14)")
#mapa-item("VFO: oscilador de frecuencia variable para moverse por la banda", "7·1·13 (estudio 6·1·14)")
#mapa-item("VCO: su frecuencia varía con una tensión de control, normalmente mediante un varicap", "13·1·14 (estudio 7·1·13)")
#mapa-item("Ruido de fase: fluctuaciones aleatorias de fase que crean faldones de ruido a ambos lados de la portadora (en TX, molestan a canales vecinos)", "9·1·14 (estudio 1·1·14)")
#mapa-item("Mezclador (heterodinación): a la salida aparecen la suma y la diferencia f1 ± f2", "4·1·13 (estudio 5·1·14)")
#mapa-item("PLL: estabiliza un VCO enganchándolo a una referencia; la tensión de error corrige el VCO", "1·1·13 (estudio 2·1·13)")
#mapa-item("Bloques del PLL: comparador de fase, filtro de paso bajo (de lazo), VCO y divisor programable", "4·1·14 (estudio 11·1·13)")
#mapa-item("Sintetizador PLL: f_out = N·f_ref; el paso de canal es f_ref", "10·1·14 (estudio 3·1·14)")
#mapa-item("DDS: se emplea como oscilador variable de gran precisión", "1·1·14 (estudio 12·1·14)")
#mapa-tema("T4", "Receptores")
#mapa-item("Superheterodino: la FI es una frecuencia fija, presente a la salida del mezclador (de ahí el nombre)", "6·1·14 (estudio 10·1·15)")
#mapa-item("Orden de etapas del superheterodino: RF → mezclador → FI → detector → BF", "10·1·15 (estudio 3·1·15)")
#mapa-item("El mezclador necesita el oscilador local: bloque que falta en un diagrama", "6·1·15 (estudio 13·1·15)")
#mapa-item("Relación entre señal, oscilador local y FI: OL por encima f_s = f_OL − f_FI; OL por debajo f_s = f_OL + f_FI", "2·1·15 (estudio 13·1·16)")
#mapa-item("Frecuencia imagen: defecto del receptor superheterodino, situada a 2·FI de la sintonizada", "11·1·14 (estudio 1·1·15)")
#mapa-item("La imagen se rechaza antes del mezclador, con un filtro (preselector)", "9·1·15 (estudio 12·1·15)")
#mapa-item("Doble conversión: dos FI; la 1.ª alta (aleja la imagen) y la 2.ª baja (selectividad)", "9·1·16 (estudio 9·1·14)")
#mapa-item("Conversión directa: el OL a la frecuencia de la señal y el mezclador da directamente audio, sin FI", "11·1·15 (estudio 1·1·16)")
#mapa-item("Diagrama de bloques del receptor de BLU (RF, mezclador con OL variable, FI, detector de producto con BFO)", "7·1·14 (estudio 3·1·16)")
#mapa-item("Receptor de FM: tras la FI, limitador y después discriminador (en AM, detector de envolvente)", "7·1·15 (estudio 5·1·15)")
#mapa-item("La etapa detectora demodula (extrae la información)", "4·1·15 (estudio 10·1·16)")
#mapa-item("Detector de producto con BFO: imprescindible en SSB y CW (no en AM ni FM)", "4·1·16 (estudio 7·1·14)")
#mapa-item("Pasar de USB a LSB cambia la frecuencia del BFO (batido), no el ancho de banda ni la clase de emisión", "3·1·14 (estudio 8·1·14)")
#mapa-item("La selectividad la fijan las etapas (filtros) de FI; la FI son amplificadores y filtros", "3·1·15 (estudio 11·1·14)")
#mapa-item("Selectividad: separar señales próximas en frecuencia (curva más estrecha = más selectivo)", "7·1·16 (estudio 2·1·14)")
#mapa-item("Selectividad de canal adyacente: la fijan los faldones del filtro de FI (problema lineal)", "13·1·15 (estudio 7·1·15)")
#mapa-item("Anchura de banda de la NBFM: unos 12 kHz (FM de difusión 200 kHz, SSB 2,4 kHz)", "5·1·15 (estudio 2·1·15)")
#mapa-item("Sensibilidad: captar y amplificar señales débiles", "1·1·15 (estudio 6·1·15)")
#mapa-item("La sensibilidad (figura de ruido) la determina la primera etapa de RF (Friis)", "8·1·15 (estudio 4·1·15)")
#mapa-item("Estabilidad: mantener la frecuencia sintonizada sin derivar", "13·1·16 (estudio 8·1·15)")
#mapa-item("La estabilidad del receptor depende del oscilador local", "8·1·16 (estudio 12·1·16)")
#mapa-item("El margen dinámico lo determina el primer mezclador", "6·1·16 (estudio 2·1·16)")
#mapa-item("Intermodulación de tercer orden: productos en 2f1 − f2 y 2f2 − f1, dentro de banda", "10·1·16 (estudio 9·1·15)")
#mapa-item("Modulación cruzada: la modulación de una señal fuerte se traslada a la sintonizada (no linealidad)", "1·1·16 (estudio 6·1·16)")
#mapa-item("CAG: mantiene constante la salida; lazo desde el detector hacia RF y FI", "12·1·14 (estudio 9·1·16)")
#mapa-item("Silenciador (squelch): corta el audio cuando la señal no supera un umbral", "5·1·16 (estudio 5·1·16)")
#mapa-item("Mando RF GAIN: ganancia de las etapas de RF del receptor (no la potencia del emisor)", "2·1·16 (estudio 11·1·15)")
#mapa-item("Noise blanker (NB): suprime el ruido impulsivo", "11·1·16 (estudio 7·1·16)")
#mapa-item("RIT: varía la frecuencia de recepción sin tocar la de transmisión", "12·1·15 (estudio 4·1·16)")
#mapa-tema("T5", "Transmisores")
#mapa-item("Funciones mínimas de un transmisor: generar, modular y amplificar", "7·1·17 (estudio 11·1·16)")
#mapa-item("Orden de bloques del emisor: modulador → amplificación y traslación → final → red de acoplo", "4·1·17 (estudio 7·1·17)")
#mapa-item("Diagrama de bloques del transmisor de BLU (BF, modulador balanceado, filtro, RF)", "8·1·17 (estudio 11·1·17)")
#mapa-item("SSB por filtro: el modulador equilibrado suprime la portadora; el filtro elimina una banda lateral", "13·1·17 (estudio 3·1·17)")
#mapa-item("Excitador: lleva la señal al nivel que necesita el amplificador final", "7·1·18 (estudio 10·1·17)")
#mapa-item("Etapa separadora: aísla el oscilador de las variaciones de carga", "6·1·17 (estudio 7·1·18)")
#mapa-item("Multiplicador de frecuencia: eleva la frecuencia del oscilador; en cascada, los factores se multiplican", "2·1·17 (estudio 8·1·16)")
#mapa-item("Los multiplicadores multiplican también la desviación de FM", "4·1·18 (estudio 12·1·17)")
#mapa-item("FM directa: el audio actúa sobre el oscilador (varicap)", "10·1·17 (estudio 3·1·18)")
#mapa-item("FM indirecta: modulador de fase tras un oscilador a cristal (ventaja: estabilidad)", "5·1·17 (estudio 1·1·17)")
#mapa-item("Índice de modulación de FM: m = Δf / f_m", "1·1·17 (estudio 9·1·17)")
#mapa-item("Excursión máxima de la NBFM: unos ±2,5 a ±5 kHz", "13·1·18 (estudio 13·1·17)")
#mapa-item("Clases de emisión UIT: A1A (CW), A3E (AM), J3E (SSB), R3E, F3E (FM)", "3·1·16 (estudio 12·1·18)")
#mapa-item("Margen de audiofrecuencia para la inteligibilidad: 300 a 3000 Hz", "12·1·16 (estudio 5·1·17)")
#mapa-item("Compresor: eleva la potencia media sin superar la de pico", "3·1·17 (estudio 4·1·17)")
#mapa-item("Sobremodulación: índice > 100 %; distorsión y ensanchamiento de la emisión (splatter)", "11·1·17 (estudio 8·1·17)")
#mapa-item("Contra la sobremodulación: bajar el nivel de BF aplicado al modulador", "2·1·18 (estudio 13·1·18)")
#mapa-item("ALC: limita la excitación del final y evita emisiones interferentes alrededor de la frecuencia", "2·1·19 (estudio 13·1·19)")
#mapa-item("Impedancia de salida típica: 50 Ω", "10·1·18 (estudio 8·1·18)")
#mapa-item("Rendimiento = potencia entregada al sistema radiante / potencia consumida", "1·1·18 (estudio 5·1·18)")
#mapa-item("PEP: potencia de pico de envolvente", "13·1·19 (estudio 10·1·18)")
#mapa-item("Potencia de portadora: media durante un ciclo de RF sin modulación", "11·1·18 (estudio 3·1·19)")
#mapa-item("Anchura de banda necesaria: la justa para la velocidad y calidad requeridas", "9·1·17 (estudio 4·1·18)")
#mapa-item("Anchura de banda ocupada: fuera de sus límites se radia el 0,5 % por cada lado", "11·1·19 (estudio 12·1·19)")
#mapa-item("Emisiones no deseadas = no esenciales + fuera de banda", "12·1·17 (estudio 6·1·17)")
#mapa-item("Armónicos: múltiplos enteros de la fundamental", "8·1·18 (estudio 7·1·19)")
#mapa-item("Filtro de salida (paso bajo) y red de acoplo entre el final y la antena: eliminan armónicos y adaptan", "9·1·18 (estudio 11·1·18)")
#mapa-item("Espurias por debajo de 30 MHz: 40 dB bajo la potencia media, sin exceder de 50 mW", "4·1·19 (estudio 2·1·17)")
#mapa-item("Límite de espurias: vale el más restrictivo entre la atenuación y el tope absoluto", "7·1·19 (estudio 1·1·18)")
#mapa-item("Manipulación brusca en CW: chasquidos que ensanchan la emisión", "5·1·18 (estudio 1·1·19)")
#mapa-item("Radiación por la estructura: RF que escapa por chasis y cables; se reduce apantallando y filtrando", "8·1·19 (estudio 9·1·18)")
#mapa-item("Conmutador SEND/REC: pasa de emisión a recepción y viceversa", "5·1·19 (estudio 6·1·18)")
#mapa-item("VOX: pasa a transmisión al hablar; en MAN se usa el PTT del micrófono", "9·1·19 (estudio 10·1·19)")
#mapa-item("Repetidor: recibe en una frecuencia y retransmite a la vez en otra", "12·1·18 (estudio 2·1·18)")
#mapa-item("Desplazamiento del repetidor en 2 m: entrada 600 kHz por debajo de la salida", "6·1·18 (estudio 4·1·19)")
#mapa-item("Ubicación de los repetidores: lugares elevados para aumentar el alcance (visibilidad directa)", "3·1·18 (estudio 5·1·19)")
#mapa-tema("T6", "Antenas y líneas de transmisión")
#mapa-item("Longitud del dipolo de media onda (≈ λ/2: 20 m para la banda de 40 m) y tamaño de la antena en función de la longitud de onda", "4·1·20 (estudio 11·1·19)")
#mapa-item("Resonancia: impedancia de alimentación resistiva pura (antena sintonizada a la frecuencia de la señal; equivale a una resistencia pura)", "1·1·19 (estudio 9·1·19)")
#mapa-item("Para bajar la frecuencia de resonancia hay que alargar la antena (29,9 → 28,5 MHz)", "9·1·20 (estudio 2·1·19)")
#mapa-item("Antena más corta que la resonante: reactancia capacitiva (se compensa con bobina); más larga: inductiva", "12·1·19 (estudio 7·1·20)")
#mapa-item("Elementos reactivos en serie: la bobina alarga eléctricamente la antena (baja f), el condensador la acorta (sube f)", "12·1·20 (estudio 6·1·19)")
#mapa-item("Impedancia del dipolo de media onda alimentado en el centro: ≈ 73 Ω", "11·1·20 (estudio 11·1·20)")
#mapa-item("Media onda alimentada en un extremo: impedancia muy alta (miles de ohmios)", "5·1·20 (estudio 11·1·21)")
#mapa-item("Dipolo en V invertida: ≈ 50 Ω, casi omnidireccional y un solo mástil", "6·1·19 (estudio 7·1·21)")
#mapa-item("Dipolo plegado: impedancia unas cuatro veces mayor (≈ 300 Ω)", "6·1·20 (estudio 10·1·20)")
#mapa-item("Dipolo con trampas: circuitos LC paralelo en los brazos que permiten trabajar en varias bandas", "7·1·20 (estudio 9·1·20)")
#mapa-item("La vertical de cuarto de onda necesita plano de tierra o radiales", "2·1·20 (estudio 13·1·20)")
#mapa-item("Impedancia de la vertical de cuarto de onda (≈ 36 Ω) y radiales inclinados (sube hacia 50 Ω)", "4·1·21 (estudio 12·1·20)")
#mapa-item("Diagrama de la vertical: máximo en el plano horizontal y nulo hacia el cénit", "13·1·20 (estudio 10·1·21)")
#mapa-item("La Yagi es una antena directiva (un lóbulo principal dominante)", "13·1·21 (estudio 13·1·21)")
#mapa-item("Yagi: los elementos parásitos no están alimentados y dan la directividad", "3·1·19 (estudio 4·1·20)")
#mapa-item("Yagi: el reflector es más largo y va detrás; los directores, más cortos y delante", "11·1·21 (estudio 5·1·20)")
#mapa-item("Antena helicoidal: polarización circular, usada en enlaces por satélite", "3·1·20 (estudio 8·1·19)")
#mapa-item("Antenas de apertura: bocina y reflector parabólico (no las de hilo)", "10·1·19 (estudio 4·1·21)")
#mapa-item("El diagrama de radiación representa la distribución de la energía radiada en el espacio", "8·1·20 (estudio 9·1·21)")
#mapa-item("Antena omnidireccional: radia igual en todo el plano horizontal (el dipolo, en el plano perpendicular al hilo)", "10·1·20 (estudio 3·1·20)")
#mapa-item("Ancho de haz: entre los puntos de media potencia (−3 dB)", "1·1·20 (estudio 2·1·20)")
#mapa-item("Relación adelante-atrás: dB entre el lóbulo principal y el trasero", "3·1·21 (estudio 3·1·21)")
#mapa-item("Polarización: orientación del campo eléctrico radiado", "8·1·21 (estudio 3·1·22)")
#mapa-item("La ganancia se expresa en dB respecto de una antena de referencia (dBi o dBd)", "11·1·22 (estudio 1·1·20)")
#mapa-item("Conversión dBi = dBd + 2,15 (la p.i.r.e. es 2,15 dB mayor que la p.r.e.)", "7·1·21 (estudio 8·1·20)")
#mapa-item("Potencia efectiva radiada: p.r.e. = P · G, descontando las pérdidas del cable (en dB)", "10·1·21 (estudio 7·1·22)")
#mapa-item("Para aumentar el alcance, lo primero es aumentar la directividad de la antena", "13·1·22 (estudio 3·1·23)")
#mapa-item("Reciprocidad: el mismo diagrama en transmisión y en recepción", "5·1·21 (estudio 6·1·20)")
#mapa-item("La impedancia característica depende de la geometría y del dieléctrico, no de la longitud", "11·1·23 (estudio 5·1·21)")
#mapa-item("Factor de velocidad: la onda va más despacio en la línea; FV = 1/√εr < 1", "2·1·21 (estudio 4·1·22)")
#mapa-item("Longitud física = longitud eléctrica × FV (la física es menor); cálculo de un tramo", "10·1·22 (estudio 5·1·22)")
#mapa-item("Guía de ondas: no propaga por debajo de su frecuencia de corte", "7·1·22 (estudio 10·1·22)")
#mapa-item("La ROE indica el grado de adaptación de impedancias", "1·1·21 (estudio 1·1·21)")
#mapa-item("Definición de la ROE: Vmáx / Vmín (o Imáx / Imín) de la onda estacionaria", "6·1·21 (estudio 12·1·21)")
#mapa-item("Adaptación perfecta: ROE = 1, coeficiente de reflexión 0, potencia reflejada nula", "2·1·22 (estudio 13·1·22)")
#mapa-item("Máxima transferencia: transmisor, línea y antena de la misma impedancia; si difieren, hace falta adaptador", "5·1·22 (estudio 12·1·22)")
#mapa-item("Margen de la ROE: siempre ≥ 1; funcionamiento adecuado entre 1 y 2,5", "4·1·22 (estudio 2·1·21)")
#mapa-item("Coeficiente de reflexión y ROE a partir de las impedancias (150 Ω en 50 Ω → ROE 3)", "9·1·21 (estudio 8·1·21)")
#mapa-item("Las pérdidas del coaxial (dB) crecen con la frecuencia y con la longitud", "1·1·22 (estudio 9·1·22)")
#mapa-item("Balun: une el coaxial (asimétrico) con el dipolo (simétrico); sin él la malla radia", "12·1·21 (estudio 8·1·22)")
#mapa-item("Transformador de cuarto de onda: Z = √(Zlínea · Zcarga); Zent = Z0²/ZL", "9·1·22 (estudio 6·1·21)")
#mapa-item("El cuarto de onda invierte la impedancia: en cortocircuito se ve como resonante paralelo; abierto, como serie", "12·1·22 (estudio 11·1·22)")
#mapa-item("Acoplador de antena: adapta la impedancia del final a la línea y la antena (no mejora la antena)", "3·1·22 (estudio 2·1·22)")
#mapa-item("Orden de conexión: transceptor → (lineal) → medidor de ROE → acoplador → antena", "6·1·22 (estudio 6·1·22)")
#mapa-item("Relé T-R: al transmitir desconecta y protege la entrada del receptor", "8·1·22 (estudio 1·1·22)")
#mapa-tema("T7", "Propagación")
#mapa-item("Nomenclatura de las bandas: sigla y nombre por longitud de onda (HF decamétricas, MF hectométricas, VHF métricas, UHF decimétricas, SHF centimétricas)", "10·1·23 (estudio 5·1·23)")
#mapa-item("Asignar una frecuencia concreta a su banda con λ = 300/f", "12·1·23 (estudio 13·1·23)")
#mapa-item("La onda de superficie predomina en MF y por debajo (sus pérdidas crecen con la frecuencia)", "1·1·23 (estudio 12·1·23)")
#mapa-item("La onda de superficie sigue la curvatura terrestre", "2·1·23 (estudio 7·1·23)")
#mapa-item("HF: propagación por reflexión ionosférica, la del DX (España–Nueva Zelanda)", "7·1·23 (estudio 4·1·23)")
#mapa-item("VHF y UHF: onda directa, distancias cortas", "4·1·23 (estudio 10·1·23)")
#mapa-item("Los satélites de aficionado usan VHF y UHF (hay que atravesar la ionosfera)", "6·1·23 (estudio 3·1·24)")
#mapa-item("A mayor frecuencia, menor alcance (144 MHz llega más fuerte que 430 MHz)", "13·1·23 (estudio 8·1·23)")
#mapa-item("Horizonte radioeléctrico: d ≈ 4,12 (√h1 + √h2) km", "12·1·24 (estudio 2·1·23)")
#mapa-item("El horizonte radioeléctrico es algo mayor que el óptico (la troposfera curva el rayo)", "13·1·24 (estudio 13·1·24)")
#mapa-item("Atenuación: toda onda se atenúa al propagarse y al atravesar objetos", "2·1·24 (estudio 5·1·24)")
#mapa-item("Pérdida en espacio libre y relación señal/ruido: 20 log d y 20 log f (×10 la distancia: −20 dB)", "10·1·24 (estudio 10·1·24)")
#mapa-item("Difracción: la onda bordea un obstáculo", "3·1·23 (estudio 8·1·24)")
#mapa-item("Capas de la ionosfera: D, E, F1 y F2", "1·1·24 (estudio 11·1·23)")
#mapa-item("Orden de las capas de la atmósfera: troposfera, estratosfera e ionosfera", "9·1·23 (estudio 9·1·23)")
#mapa-item("De noche desaparece la capa D y F1 y F2 se funden en una sola capa F", "5·1·23 (estudio 6·1·23)")
#mapa-item("La capa D absorbe de día las bandas bajas (3,5 MHz: de día menos alcance que de noche)", "6·1·24 (estudio 8·1·25)")
#mapa-item("La ionosfera depende de la actividad solar y de ella dependen las condiciones en HF", "8·1·23 (estudio 1·1·23)")
#mapa-item("Ciclo solar: más manchas → más ionización, MUF más alta y bandas altas abiertas", "8·1·24 (estudio 9·1·24)")
#mapa-item("Frecuencia crítica: la máxima que se refleja en incidencia vertical", "3·1·24 (estudio 9·1·25)")
#mapa-item("MUF ≈ fc / cos θ: mayor que la frecuencia crítica en incidencia oblicua", "11·1·24 (estudio 12·1·24)")
#mapa-item("Frecuencia óptima de trabajo ≈ 85 % de la MUF", "13·1·25 (estudio 4·1·24)")
#mapa-item("Onda espacial (de espacio): la que rebasa el horizonte, sube a la ionosfera y vuelve", "12·1·25 (estudio 11·1·24)")
#mapa-item("Zona de silencio: entre el final de la onda de superficie y la primera onda reflejada", "3·1·25 (estudio 7·1·24)")
#mapa-item("Ángulo de radiación bajo → distancia de salto más larga", "9·1·24 (estudio 3·1·25)")
#mapa-item("Desvanecimiento (fading): variación momentánea de la intensidad recibida", "11·1·25 (estudio 10·1·25)")
#mapa-item("El conducto troposférico se forma con una inversión térmica (aire cálido sobre aire frío)", "7·1·24 (estudio 11·1·25)")
#mapa-item("El conducto troposférico se da en VHF y UHF, con alcances de cientos de kilómetros", "6·1·25 (estudio 4·1·25)")
#mapa-item("Esporádica-E: nubes de ionización intensa en la capa E que reflejan VHF", "7·1·25 (estudio 2·1·24)")
#mapa-item("Esporádica-E: más frecuente en verano", "10·1·25 (estudio 1·1·24)")
#mapa-item("Reflexión auroral: en las cortinas ionizadas de las auroras", "5·1·24 (estudio 2·1·25)")
#mapa-item("Meteor-scatter: reflexión en las estelas ionizadas de los meteoros", "2·1·25 (estudio 6·1·24)")
#mapa-item("Rebote lunar (EME): VHF y superiores, sobre todo 144 MHz (ondas métricas)", "4·1·24 (estudio 7·1·25)")
#mapa-item("Ruido atmosférico (tormentas): domina en las bandas bajas de HF", "9·1·25 (estudio 6·1·25)")
#mapa-tema("T8", "Medidas")
#mapa-item("Qué instrumento mide cada magnitud básica (voltímetro: tensión; amperímetro: corriente)", "12·1·26 (estudio 11·1·26)")
#mapa-item("Conexión de los instrumentos: amperímetro en serie, voltímetro en paralelo, óhmetro sobre el componente", "8·1·25 (estudio 13·1·25)")
#mapa-item("Resistencia interna ideal: amperímetro nula, voltímetro infinita", "5·1·25 (estudio 3·1·26)")
#mapa-item("Error de carga del voltímetro en un divisor de tensión", "11·1·26 (estudio 9·1·26)")
#mapa-item("Shunt: resistencia en paralelo que amplía la escala del amperímetro y lo protege", "5·1·26 (estudio 5·1·25)")
#mapa-item("Influencia de la frecuencia: un polímetro común no sirve para medir tensiones de RF", "12·1·27 (estudio 4·1·26)")
#mapa-item("El polímetro no mide la impedancia de una antena (hace falta puente o analizador de antenas)", "7·1·26 (estudio 8·1·26)")
#mapa-item("El dBm y el dBW son unidades de potencia", "3·1·26 (estudio 4·1·27)")
#mapa-item("Conversión entre vatios y dBm (1 mW = 0 dBm; 1 W = 30 dBm)", "13·1·26 (estudio 2·1·26)")
#mapa-item("Potencia en la cresta de la envolvente a partir de la tensión de pico sobre la carga", "1·1·25 (estudio 9·1·27)")
#mapa-item("Potencia media frente a p.c.e. (coinciden con amplitud constante; en SSB la media es mucho menor)", "11·1·27 (estudio 13·1·26)")
#mapa-item("Medida de potencia de RF con vatímetro", "10·1·26 (estudio 7·1·26)")
#mapa-item("Potencia reflejada apreciable en el vatímetro direccional = desadaptación transmisor-antena", "4·1·25 (estudio 2·1·27)")
#mapa-item("Cálculo de la ROE a partir de la potencia directa y la reflejada; potencia entregada = directa − reflejada", "6·1·26 (estudio 7·1·27)")
#mapa-item("El medidor de ROE compara la onda incidente y la reflejada: mide la desadaptación", "2·1·26 (estudio 1·1·25)")
#mapa-item("El medidor de ROE es el instrumento más imprescindible de la estación", "10·1·27 (estudio 11·1·27)")
#mapa-item("Frecuencímetro: medida precisa de la frecuencia (un voltímetro de RF no la mide)", "4·1·26 (estudio 6·1·26)")
#mapa-item("Osciloscopio: representa la forma de onda en el dominio del tiempo (amplitud y período)", "2·1·27 (estudio 3·1·27)")
#mapa-item("Analizador de espectros: dominio de la frecuencia; armónicos y espurias", "1·1·26 (estudio 12·1·25)")
#mapa-item("Medidor de campo: intensidad de campo radiado, en V/m", "6·1·27 (estudio 1·1·26)")
#mapa-item("S-meter: indica la intensidad de la señal recibida (es un instrumento de recepción)", "3·1·27 (estudio 12·1·26)")
#mapa-item("S-meter: cada punto S equivale a 6 dB", "7·1·27 (estudio 5·1·26)")
#mapa-item("S-meter: S9 = 50 μV sobre 50 Ω en HF (escala en microvoltios)", "8·1·26 (estudio 6·1·27)")
#mapa-item("Dipmeter: frecuencia de resonancia de un circuito sin alimentarlo", "13·1·27 (estudio 10·1·26)")
#mapa-item("Carga artificial: ajustar el transmisor sin radiar", "9·1·26 (estudio 10·1·27)")
#mapa-tema("T9", "Interferencia e inmunidad")
#mapa-item("Compatibilidad electromagnética: no perturbar el entorno y no verse afectado por él", "4·1·27 (estudio 5·1·27)")
#mapa-item("Fuente, camino y víctima: caminos de acoplo por antena, por líneas y por radiación directa", "7·1·28 (estudio 10·1·28)")
#mapa-item("A más potencia, más riesgo de interferencia: usar la mínima potencia necesaria", "2·1·28 (estudio 2·1·28)")
#mapa-item("La emisión de armónicos y espurias implica riesgo de interferencias en cualquier banda", "10·1·28 (estudio 7·1·28)")
#mapa-item("Emisiones fuera de banda: inmediatamente exteriores a la anchura necesaria, por la modulación", "8·1·27 (estudio 8·1·27)")
#mapa-item("Desadaptación (ROE alta) favorece las interferencias; conviene ROE baja", "3·1·28 (estudio 6·1·28)")
#mapa-item("Bloqueo o desensibilización: un campo intenso satura la entrada aunque esté sintonizado lejos", "8·1·28 (estudio 5·1·28)")
#mapa-item("Remedio del bloqueo y de la TVI: filtro en la entrada del equipo afectado (problema de inmunidad)", "9·1·27 (estudio 11·1·28)")
#mapa-item("Intermodulación: dos o más señales intensas mezcladas en una etapa no lineal", "1·1·27 (estudio 8·1·28)")
#mapa-item("Detección en circuitos de audio: una unión semiconductora rectifica la RF y recupera la envolvente", "11·1·28 (estudio 13·1·27)")
#mapa-item("Desacoplo: ferritas y condensadores en los cables del equipo afectado", "1·1·28 (estudio 9·1·28)")
#mapa-item("Cable blindado para los altavoces", "4·1·28 (estudio 13·1·28)")
#mapa-item("Apantallamiento: caja metálica, eléctricamente estanca y a tierra (jaula de Faraday en los dos sentidos)", "5·1·27 (estudio 12·1·27)")
#mapa-item("Filtro de red (de línea de desacoplo) en la alimentación", "12·1·28 (estudio 1·1·27)")
#mapa-item("Filtro de rechazo de banda (notch) para eliminar una frecuencia concreta", "13·1·28 (estudio 1·1·28)")
#mapa-item("Una buena tierra reduce la RF en los chasis y las interferencias", "9·1·28 (estudio 4·1·28)")
#mapa-item("Ante una queja: comprobar la propia estación y colaborar", "6·1·28 (estudio 3·1·28)")
#mapa-tema("T10", "Seguridad")
#mapa-item("Interruptor general de la estación", "9·1·29 (estudio 7·1·29)")
#mapa-item("Lo que daña es la corriente: intensidad, recorrido y duración", "11·1·29 (estudio 11·1·29)")
#mapa-item("Umbrales de corriente (1 mA se nota, 10–20 mA no se suelta, ~30 mA fibrilación): cuál es más peligrosa", "1·1·29 (estudio 6·1·29)")
#mapa-item("Cuerpo mojado: baja la resistencia y aumenta el riesgo", "12·1·29 (estudio 12·1·28)")
#mapa-item("Una antena que transmite no se toca (quemaduras de RF)", "6·1·29 (estudio 4·1·29)")
#mapa-item("Antes de manipular un equipo: desconectarlo de la red y descargar los condensadores", "10·1·29 (estudio 13·1·29)")
#mapa-item("Accidente eléctrico: lo primero es cortar la corriente", "1·1·30 (estudio 4·1·30)")
#mapa-item("Si no se puede cortar: separar a la víctima con un elemento aislante, nunca tocarla directamente", "6·1·30 (estudio 9·1·29)")
#mapa-item("Incendio en equipo eléctrico: cortar la corriente y extintor de CO2 o polvo, nunca agua ni espuma", "5·1·28 (estudio 3·1·29)")
#mapa-item("Interferencia a servicios de seguridad de la vida humana, al móvil aeronáutico o a la ICT del edificio: dejar de emitir", "3·1·29 (estudio 12·1·29)")
#mapa-item("Fusible: en serie, corta las sobreintensidades", "7·1·29 (estudio 9·1·30)")
#mapa-item("Fusible fundido: sustituirlo por otro del mismo calibre (nunca mayor ni un puente)", "4·1·29 (estudio 6·1·30)")
#mapa-item("Calibre del fusible: ligeramente superior al consumo máximo del equipo", "13·1·29 (estudio 5·1·29)")
#mapa-item("Magnetotérmico: sobrecargas y cortocircuitos", "10·1·30 (estudio 11·1·30)")
#mapa-item("Diferencial: actúa cuando la corriente de ida y la de vuelta difieren (derivación a tierra)", "7·1·30 (estudio 7·1·30)")
#mapa-item("El diferencial protege a las personas frente a contactos indirectos y defectos de aislamiento", "12·1·30 (estudio 1·1·29)")
#mapa-item("La toma de tierra protege al operador: deriva la fuga y hace actuar al diferencial", "2·1·29 (estudio 12·1·30)")
#mapa-item("La tierra debe llegar a cada uno de los chasis metálicos, unidos entre sí", "5·1·29 (estudio 8·1·29)")
#mapa-item("La toma de tierra debe tener la menor resistencia posible", "8·1·29 (estudio 8·1·30)")
#mapa-item("El conductor de tierra no lleva fusible ni interruptor", "4·1·30 (estudio 2·1·29)")
#mapa-item("Qué vale como tierra: la del edificio si está en buen estado; nunca el neutro ni tuberías de gas o agua", "11·1·30 (estudio 5·1·30)")
#mapa-item("La pica de tierra se entierra en terreno húmedo, no seco y soleado", "5·1·30 (estudio 1·1·30)")
#mapa-item("Antena lejos de las líneas eléctricas aéreas: distancia mayor que la altura total del conjunto", "9·1·30 (estudio 13·1·30)")
#mapa-item("Vientos del mástil: repartidos alrededor y tensados por igual", "2·1·30 (estudio 3·1·30)")
#mapa-item("Antena en mástil propio, no en el de la antena colectiva", "3·1·30 (estudio 2·1·30)")
#mapa-item("Ante una tormenta: desconectar la antena (y el equipo de la red), nunca la toma de tierra", "8·1·30 (estudio 10·1·29)")
#mapa-item("Protección contra el rayo: mástil y malla a tierra por el exterior, descargador y una sola tierra", "13·1·30 (estudio 10·1·30)")
#mapa-tema("R1", "Alfabeto fonético internacional")
#mapa-item("Para qué sirve el alfabeto fonético: deletrear letras y cifras sin confusiones (no cifra ni abrevia)", "5·2·1 (estudio 12·2·1)")
#mapa-item("Las cifras se deletrean con su nombre inglés (Zero…Nine); el 0 es Zero, no Oscar ni «Cero»", "7·2·1 (estudio 10·2·1)")
#mapa-item("Deletreo de distintivo EA5SWJ: E Echo, A Alfa, S Sierra, W Whiskey, J Juliett (no «Japón»), cifra en inglés", "10·2·1 (estudio 1·2·1)")
#mapa-item("Deletreo de distintivo AN6BL: N November (no «Noviembre»), B Bravo, L Lima, 6 Six", "8·2·1 (estudio 2·2·1)")
#mapa-item("Deletreo de distintivo EA3RCQ: R Romeo, C Charlie, Q Quebec (no «Queen»), 3 Three", "3·2·1 (estudio 6·2·1)")
#mapa-item("X X-ray, Y Yankee, Z Zulu (no «Zeta»); grafías Echo y Alfa (no Eco, Alpha)", "2·2·1 (estudio 7·2·1)")
#mapa-item("U Uniform y Z Zulu frente a palabras de alfabetos antiguos (Uncle, Zebra, Coca, Dog, Able)", "13·2·1 (estudio 11·2·1)")
#mapa-item("Sufijo CID: C Charlie, I India (no «Italia»), D Delta (no «Dog»)", "12·2·1 (estudio 4·2·1)")
#mapa-item("Sufijos TOP y BOJ: T Tango, O Oscar, P Papa (no Pedro, Peter)", "9·2·1 (estudio 5·2·1)")
#mapa-item("F Foxtrot y G Golf", "11·2·1 (estudio 8·2·1)")
#mapa-item("H Hotel y K Kilo", "1·2·1 (estudio 11·2·2)")
#mapa-item("M Mike y V Victor", "6·2·1 (estudio 13·2·1)")
#mapa-tema("R2", "Código Q")
#mapa-item("QRM (interferencia de otras estaciones) frente a QRN (parásitos atmosféricos)", "5·2·2 (estudio 8·2·2), 12·2·2 (estudio 4·2·2)")
#mapa-item("QRO aumente / QRP disminuya la potencia", "2·2·2 (estudio 5·2·2)")
#mapa-item("QRS transmita más despacio / QRQ más deprisa", "5·2·3 (estudio 6·2·2), 12·2·3 (estudio 13·2·2)")
#mapa-item("QRT cese la transmisión frente a QRX espere, volveré a llamar", "1·2·2 (estudio 9·2·1), 6·2·2 (estudio 5·2·3)")
#mapa-item("QRV estoy dispuesto frente a QRU no tengo nada para usted", "7·2·2 (estudio 11·2·3)")
#mapa-item("QRG frecuencia exacta frente a QRH su frecuencia varía", "4·2·1 (estudio 1·2·2)")
#mapa-item("QRK inteligibilidad, QSA intensidad, QRI tono (las tres valoraciones de la señal)", "4·2·2 (estudio 6·2·3), 8·2·2 (estudio 12·2·2)")
#mapa-item("Escalas de respuesta: QRK y QSA de 1 a 5; QRI de 1 a 3", "11·2·2 (estudio 13·2·3)")
#mapa-item("QRL: estoy ocupado / ¿está ocupada la frecuencia?", "1·2·3 (estudio 7·2·2)")
#mapa-item("QRZ ¿quién me llama? (la llamada general es CQ, que no es código Q)", "9·2·2 (estudio 3·2·1)")
#mapa-item("QSY cambie de frecuencia", "13·2·2 (estudio 4·2·3)")
#mapa-item("QSB desvanecimiento (fading)", "7·2·3 (estudio 9·2·2)")
#mapa-item("QSL acuse de recibo frente a QSO comunicado entre dos estaciones", "3·2·2 (estudio 12·2·3), 8·2·3 (estudio 8·2·3)")
#mapa-item("QTH posición o localidad (frente a QTR, QRA, QTC)", "3·2·3 (estudio 2·2·2)")
#mapa-item("QTR hora exacta", "11·2·3 (estudio 10·2·2)")
#mapa-item("QRA nombre de la estación (no la posición)", "10·2·2 (estudio 2·2·3)")
#mapa-item("QRB distancia entre estaciones", "13·2·3 (estudio 3·2·2)")
#mapa-item("QTC tengo mensajes para transmitir", "9·2·3 (estudio 1·2·3)")
#mapa-item("QSP retransmitir gratuitamente a…", "5·2·4 (estudio 12·2·4)")
#mapa-item("QSK puedo oírle entre mis señales (break-in)", "8·2·4 (estudio 13·2·4)")
#mapa-item("QSM repita el último mensaje", "3·2·4 (estudio 5·2·4)")
#mapa-item("QSN ¿me ha oído / ha oído a… en… kHz?", "6·2·3 (estudio 7·2·3)")
#mapa-item("QSX ¿quiere escuchar a… en… kHz? (frente a QSN, que mira al pasado)", "12·2·4 (estudio 8·2·4)")
#mapa-item("QSD manipulación defectuosa", "6·2·4 (estudio 10·2·3)")
#mapa-item("QSV transmita una serie de V", "10·2·3 (estudio 4·2·4)")
#mapa-item("QRW avise a… de que le llamo en… kHz", "4·2·3 (estudio 1·2·4)")
#mapa-item("QTA anule el mensaje", "2·2·3 (estudio 6·2·4)")
#mapa-item("QRY ¿cuál es mi turno?", "2·2·4 (estudio 9·2·3)")
#mapa-item("QSZ transmita cada palabra o grupo dos veces", "1·2·4 (estudio 11·2·4)")
#mapa-tema("R3", "Abreviaturas")
#mapa-item("CQ llamada general a todas las estaciones", "13·2·4 (estudio 9·2·4)")
#mapa-item("K invitación a transmitir («cambio»)", "1·2·5 (estudio 6·2·5)")
#mapa-item("AR fin de la transmisión (no del contacto)", "2·2·5 (estudio 5·2·5)")
#mapa-item("SK fin del contacto", "8·2·5 (estudio 2·2·4)")
#mapa-item("CL cierre de la estación", "6·2·5 (estudio 2·2·5)")
#mapa-item("BK interrupción breve (break)", "9·2·4 (estudio 11·2·5)")
#mapa-item("DE delante del distintivo de quien transmite", "10·2·4 (estudio 10·2·4)")
#mapa-item("R recibido (conforme)", "7·2·4 (estudio 3·2·3)")
#mapa-item("RPT repita y AGN de nuevo", "11·2·4 (estudio 7·2·4)")
#mapa-item("DX contacto de larga distancia", "3·2·5 (estudio 1·2·5)")
#mapa-item("CW telegrafía Morse (onda continua)", "4·2·4 (estudio 13·2·5)")
#mapa-item("USB banda lateral superior / LSB inferior", "9·2·5 (estudio 9·2·5)")
#mapa-item("SSB banda lateral única", "12·2·5 (estudio 7·2·5)")
#mapa-item("Informe RST: R legibilidad 1–5, S intensidad 1–9, T tono 1–9", "10·2·5 (estudio 10·2·5)")
#mapa-item("La T (tono) solo se da en telegrafía: 59 en fonía, 599 en CW", "5·2·5 (estudio 11·2·6)")
#mapa-item("Escala de legibilidad: R5 = perfectamente legible (R1 ilegible…)", "5·2·6 (estudio 3·2·4)")
#mapa-item("OM operador corresponsal (old man)", "7·2·5 (estudio 8·2·5)")
#mapa-item("YL operadora y XYL esposa", "4·2·5 (estudio 5·2·6)")
#mapa-item("73 saludos cordiales y 88 besos", "8·2·6 (estudio 12·2·5)")
#mapa-item("PSE por favor", "3·2·6 (estudio 11·2·7)")
#mapa-item("TNX / TKS y TU: gracias", "11·2·5 (estudio 6·2·6)")
#mapa-item("WX tiempo meteorológico", "2·2·6 (estudio 10·2·6)")
#mapa-item("UR su (your)", "4·2·6 (estudio 10·2·7)")
#mapa-item("RIG equipo, ANT antena, PWR potencia", "7·2·6 (estudio 1·2·6)")
#mapa-item("OP operador", "2·2·7 (estudio 2·2·6)")
#mapa-item("HR aquí y ES y", "1·2·6 (estudio 2·2·7)")
#mapa-item("NIL nada, sin novedad", "6·2·6 (estudio 7·2·6)")
#mapa-item("CFM confirmo", "3·2·7 (estudio 7·2·7)")
#mapa-item("ABT aproximadamente y VY muy", "9·2·6 (estudio 4·2·5)")
#mapa-item("HI risa en telegrafía", "1·2·7 (estudio 9·2·6)")
#mapa-item("SRI lo siento", "10·2·6 (estudio 12·2·6)")
#mapa-item("FB buen trabajo, formidable (fine business)", "9·2·7 (estudio 11·2·8)")
#mapa-item("CUL hasta luego (see you later)", "8·2·7 (estudio 8·2·6)")
#mapa-item("BUG manipulador semiautomático", "11·2·6 (estudio 4·2·6)")
#mapa-item("GM buenos días (GA es «adelante»)", "12·2·6 (estudio 3·2·5)")
#mapa-item("GE buenas tardes", "6·2·7 (estudio 12·2·7)")
#mapa-item("GN buenas noches", "12·2·7 (estudio 5·2·7)")
#mapa-item("GL buena suerte", "13·2·5 (estudio 13·2·6)")
#mapa-item("MSG mensaje", "4·2·7 (estudio 6·2·7)")
#mapa-item("NR número", "10·2·7 (estudio 4·2·7)")
#mapa-item("Trabajar en split: emitir en una frecuencia y recibir en otra", "5·2·7 (estudio 1·2·7)")
#mapa-item("Locator (QTH locator, Maidenhead): forma breve de dar la ubicación", "13·2·6 (estudio 8·2·7)")
#mapa-item("SWL radioescucha (short wave listener)", "13·2·7 (estudio 13·2·7)")
#mapa-tema("R4", "Señales de socorro, urgencia y seguridad")
#mapa-item("Socorro en radiotelefonía: MAYDAY", "2·2·8 (estudio 7·2·8)")
#mapa-item("Urgencia en radiotelefonía: PAN PAN (tres veces)", "8·2·8 (estudio 9·2·7)")
#mapa-item("Seguridad en radiotelefonía: SÉCURITÉ (tres veces)", "11·2·7 (estudio 6·2·8)")
#mapa-item("Formato de la llamada de socorro: Mayday ×3 + «aquí»/«de» + distintivo ×3", "7·2·7 (estudio 12·2·8)")
#mapa-item("Contenido del mensaje de socorro: identificación, posición, naturaleza del peligro (nunca «Sécurité»)", "11·2·8 (estudio 4·2·8)")
#mapa-item("Socorro en radiotelegrafía: SOS (no XXX, TTT ni CQD)", "7·2·8 (estudio 11·2·9)")
#mapa-item("SOS se transmite como un solo signo (sin separar las letras)", "1·2·8 (estudio 2·2·8)")
#mapa-item("Urgencia en radiotelegrafía: XXX tres veces", "4·2·8 (estudio 5·2·8)")
#mapa-item("Seguridad en radiotelegrafía: TTT tres veces", "9·2·8 (estudio 2·2·9)")
#mapa-item("Prioridad: seguridad < urgencia < socorro", "12·2·8 (estudio 13·2·8)")
#mapa-item("Señal de alarma radiotelefónica: tonos alternos de 2200 y 1300 Hz", "5·2·8 (estudio 10·2·8)")
#mapa-item("Alerta de socorro GMDSS por DSC en MF: 2187,5 kHz (voz: 2182 kHz)", "4·2·9 (estudio 7·2·9)")
#mapa-item("Canal 16 de VHF marítima: 156,8 MHz (socorro, seguridad y llamada en voz)", "6·2·8 (estudio 11·2·10)")
#mapa-item("Al oír un socorro: silencio, escucha y auxilio si es posible", "6·2·9 (estudio 8·2·8)")
#mapa-item("Tras emitir un socorro: escuchar en la misma frecuencia", "2·2·9 (estudio 5·2·9)")
#mapa-item("Peligro grave e inminente: se puede usar cualquier medio y frecuencia", "8·2·9 (estudio 1·2·8)")
#mapa-item("Usar SOS o MAYDAY sin peligro real es infracción sancionable", "9·2·9 (estudio 3·2·6)")
#mapa-item("Resolución 640 del RR: bandas de aficionado en socorro por catástrofes naturales", "13·2·8 (estudio 3·2·7)")
#mapa-item("Colaboración obligatoria en catástrofes a requerimiento de la DG de Protección Civil y Emergencias (art. 30.4)", "1·2·9 (estudio 9·2·8)")
#mapa-item("Socorro captado: hacer lo posible para que llegue a la DG de Protección Civil y Emergencias (art. 30.5)", "3·2·8 (estudio 3·2·8)")
#mapa-item("Banda de 40 m en la Región 1: 7000–7200 kHz", "10·2·8 (estudio 8·2·9)")
#mapa-item("Banda de 10 m: 28–29,7 MHz", "10·2·9 (estudio 2·2·10)")
#mapa-item("Límites en HF: 80 m 3500–3800 kHz, 20 m 14000–14350 kHz (¿está dentro de banda?)", "13·2·9 (estudio 10·2·9)")
#mapa-item("Banda de 2 m en la Región 1: 144–146 MHz", "3·2·9 (estudio 13·2·9)")
#mapa-item("Banda de 70 cm: 430–440 MHz", "12·2·9 (estudio 12·2·9)")
#mapa-item("Banda de 23 cm: 1240–1300 MHz", "2·2·10 (estudio 4·2·9)")
#mapa-item("Banda de 13 cm: 2300–2450 MHz", "9·2·10 (estudio 5·2·10)")
#mapa-item("Aficionados por satélite: solo en las bandas atribuidas al efecto en el CNAF", "1·2·10 (estudio 11·2·11)")
#mapa-item("Segmento de satélites en 70 cm: 435–438 MHz", "5·2·9 (estudio 9·2·9)")
#mapa-item("Segmento exclusivo de satélites en 2 m: 145,806–146,000 MHz", "7·2·9 (estudio 1·2·9)")
#mapa-item("Centros de actividad de emergencia IARU R1: 14300 kHz (mundial) y 3760 kHz (80 m)", "11·2·9 (estudio 6·2·9)")
#mapa-tema("R5", "Distintivos de llamada")
#mapa-item("Qué es el distintivo: señal de identificación que identifica al titular desde cualquier punto del territorio (no al equipo ni al domicilio)", "8·2·10 (estudio 4·2·10)")
#mapa-item("El distintivo se otorga junto con la autorización y lo asigna la Administración (no se elige ni lo da la asociación)", "6·2·10 (estudio 5·2·11)")
#mapa-item("Cuándo identificarse: al comienzo y al final de cada emisión, siempre, y en las largas al menos cada 10 min", "6·2·11 (estudio 8·2·10), 10·2·10 (estudio 1·2·10)")
#mapa-item("Identificación de móviles y portables: /M, /MM, /MA, /P en grafía; palabras («portable») en fonía; no existe /AM", "7·2·10 (estudio 13·2·10), 11·2·10 (estudio 9·2·10)")
#mapa-item("Añadir opcionalmente el distrito desde el que se emite: EA7/EA4KLM/M", "12·2·10 (estudio 10·2·10)")
#mapa-item("QRP no forma parte del distintivo: se anuncia en la llamada (CQ QRP)", "13·2·10 (estudio 8·2·11)")
#mapa-item("Licencia CEPT en telefonía: entre el prefijo y el distintivo se dice «stroke»", "10·2·11 (estudio 1·2·11)")
#mapa-item("Composición del distintivo: prefijo + distrito + sufijo", "12·2·11 (estudio 3·2·9)")
#mapa-item("El distintivo tiene como máximo seis caracteres", "4·2·10 (estudio 4·2·11)")
#mapa-item("Prefijos de España: series EA–EH (y AM–AO); habituales EA, EB y EC", "6·2·12 (estudio 7·2·10)")
#mapa-item("Las series de prefijos las atribuye la UIT (Reglamento de Radiocomunicaciones) y cada país asigna dentro de ellas", "5·2·10 (estudio 8·2·12)")
#mapa-item("Estructura internacional: la parte de nacionalidad tiene hasta tres caracteres, letras o cifras", "9·2·11 (estudio 12·2·10)")
#mapa-item("Prefijos de los países vecinos: Portugal CT, Francia F, Andorra C3", "11·2·11 (estudio 5·2·12)")
#mapa-item("Prefijos de otros países europeos: Alemania DL, Italia I, Reino Unido G/M", "8·2·11 (estudio 10·2·11)")
#mapa-item("La cifra es la del distrito de residencia del titular al otorgar la autorización", "2·2·11 (estudio 9·2·11)")
#mapa-item("Mudarse de distrito: se conserva el distintivo (único e inmodificable); solo se comunica el domicilio", "3·2·10 (estudio 1·2·12)")
#mapa-item("Hay nueve distritos geográficos (1 a 9); el 0 es especial", "5·2·11 (estudio 11·2·12)")
#mapa-item("Distrito 0: solo para actos inaugurados o visitados por el Rey", "3·2·11 (estudio 4·2·12)")
#mapa-item("Distritos insulares y ciudades autónomas: 6 Baleares, 8 Canarias, 9 Ceuta y Melilla", "7·2·11 (estudio 3·2·10), 11·2·12 (estudio 12·2·11)")
#mapa-item("Distritos peninsulares: asignar provincia a su cifra y leer la cifra de un distintivo", "4·2·11 (estudio 4·2·13), 12·2·12 (estudio 13·2·11)")
#mapa-item("Excepciones de distrito: Albacete es del 5 y La Rioja del 1", "6·2·13 (estudio 11·2·13)")
#mapa-item("Sufijo: hasta tres letras, por orden alfabético y turno riguroso de expedición", "1·2·11 (estudio 7·2·11)")
#mapa-item("Sufijos excluidos: DDD, PAN, SOS, TTT, XXX y la serie QAA–QZZ", "3·2·12 (estudio 8·2·13), 8·2·12 (estudio 1·2·13)")
#mapa-item("Estaciones automáticas desatendidas: prefijo ED; sufijo con Y (analógica) o Z (digital)", "5·2·12 (estudio 12·2·12), 13·2·11 (estudio 6·2·10)")
#mapa-item("Estaciones colectivas: distintivo propio; sufijos UR (asociaciones), RC y RK (radioclubes)", "13·2·12 (estudio 11·2·14)")
#mapa-item("Sufijo de dos letras: 5 años de autorización, 5 de práctica internacional y 5 sin expediente sancionador; no reservado a colectivas", "2·2·12 (estudio 12·2·13)")
#mapa-item("Sufijo de una letra: reservado también para concursos internacionales de alta competitividad", "9·2·12 (estudio 13·2·12)")
#mapa-item("Sufijo de una letra como distintivo permanente: 15 años de práctica internacional", "4·2·12 (estudio 6·2·11)")
#mapa-item("Res. 29-07-2026: la práctica para el sufijo de una letra se acredita con 2 QSL por año en 15 de los últimos 20", "13·2·13 (estudio 9·2·12)")
#mapa-item("Res. 29-07-2026: asignación por distritos y orden de presentación, hasta 10 preferencias; el nuevo distintivo sustituye al anterior", "3·2·13 (estudio 9·2·13)")
#mapa-item("Sufijos de cuatro o más letras: excepcionales, para usos temporales en eventos de relevancia especial", "4·2·13 (estudio 2·2·11)")
#mapa-item("Más de una cifra en el distintivo: acontecimientos relevantes identificados por sus fechas (aniversarios)", "7·2·12 (estudio 3·2·11)")
#mapa-item("Reasignación de distintivos: agotadas las combinaciones, salvo anterior titular o familiares de primer grado por fallecimiento", "11·2·13 (estudio 5·2·13)")
#mapa-item("Prefijos temporales ED, EE y EF: eventos ordinarios; mantienen el resto del distintivo", "5·2·13 (estudio 6·2·12), 10·2·12 (estudio 10·2·12)")
#mapa-item("Prefijos EG y EH: concursos, eventos internacionales y eventos relevantes locales, regionales o autonómicos", "10·2·13 (estudio 2·2·12)")
#mapa-item("Prefijos AM y AN: eventos relevantes de ámbito nacional", "1·2·12 (estudio 10·2·13)")
#mapa-item("Prefijo AO: eventos relevantes de ámbito internacional", "1·2·13 (estudio 2·2·13)")
#mapa-item("Prefijo AO optativo para españoles en zonas no adscritas a soberanías nacionales", "2·2·13 (estudio 13·2·13)")
#mapa-item("Para qué se pide un distintivo temporal: concursos, experimentos, ensayos o conmemoraciones", "12·2·13 (estudio 7·2·12)")
#mapa-item("Solicitud de distintivo temporal: una por evento, a la Administración; las asociaciones solo proponen", "9·2·13 (estudio 3·2·12)")
#mapa-item("Distintivo temporal: máximo 30 días al año por sufijo y peticionario (excepción: una letra en concursos, hasta 2 años)", "7·2·13 (estudio 6·2·13)")
#mapa-tema("R6", "Planes de bandas de la IARU")
#mapa-item("Qué es un plan de bandas: reparto recomendado de cada banda por modo y anchura de banda; instrumento básico de ordenación", "3·2·14 (estudio 3·2·13), 11·2·14 (estudio 11·2·15)")
#mapa-item("Naturaleza de los planes: acuerdos voluntarios y guía mundial, pero la Orden obliga a usar el de la Región 1 como norma general en España", "2·2·14 (estudio 10·2·14), 6·2·14 (estudio 6·2·14)")
#mapa-item("Los planes parten de las atribuciones del Reglamento de Radiocomunicaciones y hay uno por Región de la UIT", "10·2·14 (estudio 4·2·14)")
#mapa-item("La IARU es la federación de asociaciones nacionales de radioaficionados (URE en España)", "11·2·15 (estudio 9·2·14)")
#mapa-item("España pertenece a la Región 1 de la UIT", "12·2·14 (estudio 7·2·13)")
#mapa-item("Composición de las Regiones: 1 Europa y África; 2 América; 3 resto de Asia y Oceanía", "7·2·14 (estudio 1·2·14)")
#mapa-item("Por qué hay Regiones: atribuir bandas por zonas; por eso las bandas difieren entre España y EE. UU.", "13·2·14 (estudio 2·2·14)")
#mapa-item("Frecuencias de llamada: punto de encuentro de un modo, no de uso exclusivo", "1·2·14 (estudio 10·2·15)")
#mapa-item("Frecuencia de llamada de FM en 2 m: 145,500 MHz", "1·2·15 (estudio 1·2·15)")
#mapa-item("Frecuencia de llamada de FM en 70 cm: 433,500 MHz", "10·2·15 (estudio 2·2·15)")
#mapa-item("Canal de llamada de FM en 10 m: 29,600 MHz", "5·2·14 (estudio 5·2·14)")
#mapa-item("Repetidores de 2 m: entrada 145,000–145,1875 MHz, salida 600 kHz más arriba", "3·2·15 (estudio 9·2·15), 8·2·13 (estudio 5·2·15)")
#mapa-item("Repetidores de 70 cm: entrada 433,000–433,375 MHz, desplazamiento 1,6 MHz", "2·2·15 (estudio 3·2·14)")
#mapa-item("Centros de actividad de SSB: 144,300 MHz (2 m) y 432,200 MHz (70 cm)", "4·2·14 (estudio 11·2·16)")
#mapa-item("Balizas en 2 m: segmento 144,400–144,491 MHz", "8·2·14 (estudio 9·2·16)")
#mapa-item("Balizas en HF: 14.099–14.101 kHz exclusivo del International Beacon Project", "13·2·15 (estudio 13·2·14)")
#mapa-item("Convenio de banda lateral: LSB por debajo de 10 MHz, USB por encima; excepción 60 m en USB", "5·2·15 (estudio 12·2·14), 9·2·14 (estudio 4·2·15)")
#mapa-item("80 m: segmento de CW 3.500–3.570 kHz", "5·2·16 (estudio 7·2·14)")
#mapa-item("20 m: 14.070–14.099 kHz para modos digitales de banda estrecha", "12·2·15 (estudio 12·2·15)")
#mapa-item("Las frecuencias del plan HF son las realmente transmitidas, no la del dial", "7·2·15 (estudio 13·2·15)")
#mapa-item("Bandas sin concursos: 60, 30, 17 y 12 m", "4·2·15 (estudio 8·2·14)")
#mapa-tema("R7", "Responsabilidad social y procedimientos operativos")
#mapa-item("Definición del servicio de aficionados: instrucción individual, intercomunicación y estudios técnicos, sin lucro", "6·2·15 (estudio 7·2·15)")
#mapa-item("Contenido: temas del servicio y observaciones de carácter personal", "8·2·15 (estudio 6·2·15)")
#mapa-item("Prohibidos fines comerciales, publicitarios o lucrativos; permitidos mensajes técnicos sobre ensayos", "1·2·16 (estudio 4·2·16)")
#mapa-item("Mensajes de terceros: no permitidos con carácter general (salvo emergencia)", "2·2·16 (estudio 2·2·16)")
#mapa-item("Lenguaje claro: sin códigos que oculten el significado (Q y abreviaturas sí)", "9·2·15 (estudio 8·2·15)")
#mapa-item("Escuchar antes de transmitir (QRL?)", "11·2·16 (estudio 10·2·16)")
#mapa-item("Interferir deliberadamente: nunca está permitido", "7·2·16 (estudio 5·2·16)")
#mapa-item("Decir «cambio» es recomendable, no obligatorio", "3·2·16 (estudio 1·2·16)")
#mapa-item("Deletrear con el alfabeto fonético internacional; no inventar palabras", "10·2·16 (estudio 11·2·17)")
#mapa-item("Código SINPO: intensidad, interferencias, ruido, propagación y calidad global", "6·2·16 (estudio 8·2·16)")
#mapa-item("Código del Radioaficionado: considerado, leal, progresista, amistoso, equilibrado y patriota", "5·2·17 (estudio 13·2·16)")
#mapa-item("Autorregulación (self-policing): autodisciplina, sin policía propia", "9·2·16 (estudio 6·2·16)")
#mapa-item("Antenas: garantizar el derecho de terceros a no sufrir daños", "8·2·16 (estudio 7·2·16)")
#mapa-item("Autorización especial que causa interferencias: suspender de inmediato", "4·2·16 (estudio 3·2·15)")
#mapa-item("Objeto de la prueba de capacitación: evaluar la capacidad para operar", "13·2·16 (estudio 9·2·17)")
#mapa-item("Emitir música está prohibido: el servicio de aficionados no es radiodifusión", "12·2·16 (estudio 12·2·16)")
#mapa-tema("R8", "Reglamentación nacional e internacional")
#mapa-item("Marco: competencia exclusiva del Estado en telecomunicaciones (art. 149.1.21.ª CE)", "7·2·17 (estudio 10·2·17)")
#mapa-item("Ley General de Telecomunicaciones vigente: Ley 11/2022", "5·2·18 (estudio 3·2·16)")
#mapa-item("RD 123/2017: Reglamento sobre el uso del dominio público radioeléctrico", "10·2·17 (estudio 6·2·17)")
#mapa-item("Uso del espectro por radioaficionados: uso especial, con autorización individual; explotación compartida sin exclusión de terceros", "1·2·17 (estudio 6·2·18)")
#mapa-item("Orden IET/1311/2013: documento fundamental de regulación de la radioafición", "2·2·17 (estudio 11·2·18)")
#mapa-item("Orden IET/1311/2013: derogó la Orden ITC/1791/2006", "3·2·17 (estudio 9·2·18)")
#mapa-item("Orden IET/1311/2013: entrada en vigor el día siguiente a su publicación", "3·2·18 (estudio 5·2·17)")
#mapa-item("Radioaficionado: interés por la radiotecnia con carácter exclusivamente personal, sin fines de lucro", "7·2·18 (estudio 9·2·19)")
#mapa-item("CNAF = Cuadro Nacional de Atribución de Frecuencias", "9·2·17 (estudio 4·2·17)")
#mapa-item("CNAF vigente: aprobado por orden ministerial (Orden TDF/732/2026)", "9·2·18 (estudio 12·2·17)")
#mapa-item("Ley 19/1983 («Ley de antenas»): derecho a instalar antenas de aficionado en el exterior de los inmuebles", "11·2·18 (estudio 13·2·19)")
#mapa-item("RD 2623/1986: reglamento de las instalaciones de antenas de aficionado", "1·2·21 (estudio 6·2·22)")
#mapa-item("La autorización de radioaficionado la otorga la SETSI (hoy SETID)", "9·2·19 (estudio 8·2·21)")
#mapa-item("Requisito previo de la autorización: superar la prueba de capacitación (certificado HAREC)", "12·2·19 (estudio 8·2·22)")
#mapa-item("Naturaleza de la autorización: individual, personal e intransferible, revocable", "5·2·22 (estudio 5·2·21)")
#mapa-item("Vigencia indefinida: no se renueva; suprimida la comunicación quinquenal", "3·2·23 (estudio 7·2·21)")
#mapa-item("La autorización habilita a emitir en las bandas y con las características técnicas del servicio de aficionados", "9·2·21 (estudio 13·2·22)")
#mapa-item("Plazo para resolver la autorización (y la licencia de estación fija): 6 semanas, silencio desestimatorio", "2·2·21 (estudio 11·2·20)")
#mapa-item("Recursos contra las resoluciones: reposición en 1 mes o contencioso ante la Audiencia Nacional en 2 meses", "6·2·21 (estudio 4·2·22)")
#mapa-item("Solicitud de autorización: preferentemente por medios electrónicos, con modelo oficial", "10·2·21 (estudio 5·2·22)")
#mapa-item("Solicitud de autorización: acompañada del resguardo de la tasa de tramitación", "7·2·23 (estudio 4·2·23)")
#mapa-item("Menores: sin edad mínima; escrito fehaciente de padres o tutores", "12·2·20 (estudio 10·2·22)")
#mapa-item("Autorización en formato bilingüe si lo pide el interesado (lengua cooficial)", "13·2·22 (estudio 11·2·21)")
#mapa-item("No es obligatorio ser socio de una asociación de radioaficionados", "11·2·23 (estudio 3·2·19)")
#mapa-item("No es obligatorio disponer de estación fija", "12·2·21 (estudio 10·2·23)")
#mapa-item("Se puede tener distintivo (autorización) sin licencia de estación; la licencia solo la necesita la estación fija", "8·2·20 (estudio 3·2·20)")
#mapa-item("Extinción automática de la autorización: fallecimiento del titular o extinción de la asociación titular", "11·2·24 (estudio 7·2·22)")
#mapa-item("Revocación de la autorización: no se puede emitir; se cancelan el distintivo y la licencia de estación fija asociada", "3·2·24 (estudio 3·2·21)")
#mapa-item("Uso de una estación ajena: con permiso del titular, identificándose con el distintivo propio", "1·2·25 (estudio 9·2·24)")
#mapa-item("Ninguna estación tiene derecho preferente sobre una frecuencia", "12·2·22 (estudio 1·2·21)")
#mapa-item("Las estaciones están sometidas siempre a la inspección", "13·2·23 (estudio 3·2·22)")
#mapa-item("Equipos de construcción propia: sin autorización previa, bajo la responsabilidad del titular (régimen sancionador si interfieren)", "10·2·22 (estudio 6·2·26)")
#mapa-item("Equipo de construcción propia: presentación optativa en la Jefatura con memoria (diagrama de bloques, esquemas)", "8·2·21 (estudio 1·2·22)")
#mapa-item("Equipos comerciales: legislación vigente en su comercialización inicial; los ya legalizados, la de su autorización inicial", "2·2·22 (estudio 13·2·23)")
#mapa-item("Equipo de segunda mano sin certificado de aceptación: cumplir el anexo I, certificado por laboratorio acreditado", "12·2·23 (estudio 9·2·25)")
#mapa-item("Estación construida de acuerdo con el estado de la técnica (no se impone tecnología)", "9·2·22 (estudio 12·2·22)")
#mapa-item("La estación debe tener elementos para comprobar que la emisión está en banda y medir la potencia", "5·2·23 (estudio 10·2·24)")
#mapa-item("Potencia y duración de las emisiones limitadas a lo estrictamente necesario", "6·2·22 (estudio 10·2·25)")
#mapa-item("Estación fija: precisa licencia, asociada a la autorización de radioaficionado de su titular", "1·2·26 (estudio 1·2·23)")
#mapa-item("Definición de estación fija: ubicación fija consignada en la licencia", "2·2·23 (estudio 7·2·23)")
#mapa-item("Solicitud de licencia de estación fija: con memoria descriptiva de la instalación", "12·2·24 (estudio 10·2·26)")
#mapa-item("Contenido de la memoria: toma de tierra, plano, equipos (no el empadronamiento)", "13·2·24 (estudio 5·2·23)")
#mapa-item("La licencia se expide terminado el montaje y presentada la documentación", "9·2·23 (estudio 5·2·24)")
#mapa-item("Plazos de fin de instalación: comunicarlo en 6 semanas; la Jefatura verifica y expide en ≤ 30 días", "12·2·25 (estudio 7·2·24)")
#mapa-item("Montaje por instalador de telecomunicaciones inscrito, salvo instalaciones simples autorizadas por el Jefe Provincial", "13·2·25 (estudio 13·2·24)")
#mapa-item("Modificaciones con licencia: permanentes se comunican; cambiar la antena de sitio = primera instalación", "10·2·23 (estudio 12·2·23)")
#mapa-item("Modificaciones experimentales con licencia concedida: hasta 60 días sin afectar a la seguridad", "6·2·23 (estudio 9·2·26)")
#mapa-item("Seguro de responsabilidad civil obligatorio, formalizado antes de expedirse la licencia", "2·2·24 (estudio 5·2·25)")
#mapa-item("Copia del contrato de seguro a la propiedad o al presidente de la comunidad", "10·2·24 (estudio 11·2·22)")
#mapa-item("Cancelación de la licencia fija (p. ej., sin seguro): desmontar todo, antenas incluidas, a costa del titular", "11·2·25 (estudio 12·2·24)")
#mapa-item("Licencia fija condicionada a no perturbar otros servicios y a cumplir normas de seguridad, servidumbres, medio ambiente", "6·2·24 (estudio 7·2·25)")
#mapa-item("Permisos de servidumbres, medio ambiente, etc.: por cuenta y a cargo del solicitante", "9·2·24 (estudio 13·2·25)")
#mapa-item("Derecho a instalar la antena en el exterior: legitimación para usar el edificio + autorización administrativa", "8·2·22 (estudio 4·2·24)")
#mapa-item("Comunidad de propietarios: no autoriza; la solicitud indica la dirección del presidente y la Administración le informa", "9·2·25 (estudio 2·2·22)")
#mapa-item("La comunidad dispone de 2 meses para alegar sobre la idoneidad del emplazamiento", "10·2·25 (estudio 8·2·23)")
#mapa-item("Derechos del predio sirviente (art. 545 CC): la comunidad decide por mayoría simple", "10·2·26 (estudio 1·2·24)")
#mapa-item("Obras en el inmueble: aviso al titular con 1 mes de antelación", "5·2·24 (estudio 1·2·25)")
#mapa-item("Obras: desmontaje temporal sin indemnización; después se reinstala en condiciones similares", "4·2·23 (estudio 9·2·27)")
#mapa-item("Obras de indudable urgencia: desmontaje sin trámites, comunicándolo inmediatamente al titular", "8·2·23 (estudio 2·2·23)")
#mapa-item("Instalación provisional durante las obras: la autoriza la Administración; gastos del titular", "11·2·26 (estudio 8·2·24)")
#mapa-item("Daños: los que causa la antena (instalación, conservación, desmontaje) son del titular; los que causa la propiedad a la antena, de la propiedad", "7·2·24 (estudio 2·2·24)")
#mapa-item("Condiciones de instalación: sin molestias ni peligro, señalizar anclajes y riostras, materiales resistentes, respetar otras antenas, no dañar la obra", "1·2·27 (estudio 7·2·26)")
#mapa-item("Soportes: a la obra civil o con repartidores de carga; nunca a pararrayos ni a conducciones eléctricas", "3·2·25 (estudio 6·2·27)")
#mapa-item("Altura libre mínima de 3 m sobre el plano de paso", "12·2·26 (estudio 11·2·23)")
#mapa-item("Líneas de transmisión a ≥ 10 cm de conductos y canalizaciones del edificio", "8·2·24 (estudio 5·2·26)")
#mapa-item("Definiciones del RD 2623/1986: anclaje, riostra, plano de paso, elemento repartidor de carga", "2·2·25 (estudio 11·2·24)")
#mapa-item("Usos experimentales con características distintas de las generales: requieren autorización especial", "5·2·25 (estudio 3·2·23)")
#mapa-item("Autorización especial experimental: nominativa, plazo máximo inicial de 18 meses, ampliable", "6·2·25 (estudio 13·2·26)")
#mapa-item("Autorización especial experimental: pedirla con al menos 1 mes de antelación", "5·2·26 (estudio 7·2·27)")
#mapa-item("Memoria técnica de la autorización experimental: contenido (experimento, diagrama si es casero, coordenadas, período, banda, emisión, potencia, antena)", "13·2·26 (estudio 7·2·28)")
#mapa-item("Emisiones experimentales: se identifican con el distintivo propio", "4·2·24 (estudio 9·2·28)")
#mapa-item("Bandas que requieren autorización especial: 2300–2450 MHz, 5650–5850 MHz y 24,050–24,250 GHz (con excepciones)", "7·2·25 (estudio 12·2·25)")
#mapa-item("Autorizaciones del art. 16 (bandas secundarias): limitaciones geográficas o técnicas", "2·2·26 (estudio 2·2·25)")
#mapa-item("Estación portable: la fija usada temporalmente en otra ubicación", "13·2·27 (estudio 12·2·26)")
#mapa-item("Uso portable: notificar con 5 días; usos no continuados de hasta 15 días naturales sin notificación", "8·2·25 (estudio 8·2·25)")
#mapa-item("Estación móvil: en movimiento o detenida en puntos no determinados", "8·2·26 (estudio 2·2·26)")
#mapa-item("Estación portátil: antena y fuente de energía incorporadas, utilizable en movimiento", "4·2·25 (estudio 11·2·25)")
#mapa-item("Estación fija remota: accionada a distancia", "7·2·26 (estudio 3·2·24)")
#mapa-item("Estación digital: emite con técnicas digitales", "4·2·26 (estudio 2·2·27)")
#mapa-item("Estación temporal: concursos, expediciones, demostraciones y eventos", "9·2·26 (estudio 4·2·25)")
#mapa-item("Estación colectiva: responsable la Junta Directiva de la asociación", "5·2·27 (estudio 12·2·27)")
#mapa-item("Asociación reconocida: por resolución de la SETSI, tras inscribirse en Interior y presentar estatutos", "10·2·27 (estudio 4·2·26)")
#mapa-item("Estatutos de la asociación reconocida: fines propios de la radioafición y obligación de cumplir el Reglamento", "11·2·27 (estudio 1·2·26)")
#mapa-item("Colectivas: licencia + autorización individualizada con distintivo propio", "12·2·27 (estudio 12·2·28)")
#mapa-item("Varias desatendidas en una autorización: misma modulación, titularidad y ubicación", "3·2·26 (estudio 11·2·26)")
#mapa-item("Noveles en estaciones colectivas: supervisor con ≥ 3 años de antigüedad", "9·2·27 (estudio 10·2·27)")
#mapa-item("Noveles: distintivo de la colectiva + 2 o 3 letras tras el sufijo", "2·2·27 (estudio 3·2·25)")
#mapa-item("Noveles: potencia ≤ 40 % del máximo de la banda y nunca más de 100 W", "1·2·28 (estudio 8·2·26)")
#mapa-item("Estación automática desatendida: estación colectiva que no requiere intervención directa del operador", "10·2·28 (estudio 1·2·27)")
#mapa-item("Tipos de desatendidas (art. 24): repetidores analógicos, digitales, de nodo, finales y radiobalizas", "5·2·28 (estudio 4·2·27)")
#mapa-item("Repetidoras digitales: de portadora o nodo (enlaza con repetidoras) frente a final (distribuye a los usuarios)", "4·2·27 (estudio 11·2·27)")
#mapa-item("Titular de una desatendida: solo asociaciones de radioaficionados legalmente reconocidas", "6·2·26 (estudio 11·2·28)")
#mapa-item("Número de desatendidas: según las necesidades del servicio (cobertura y canales)", "3·2·27 (estudio 8·2·27)")
#mapa-item("Obligaciones del gestor de la desatendida (no le corresponde autorizar su funcionamiento)", "7·2·27 (estudio 3·2·26)")
#mapa-item("Repetidor: su objetivo es ampliar el alcance de las comunicaciones", "8·2·27 (estudio 13·2·27)")
#mapa-item("Acceso a repetidores: necesariamente libre; si hay código, público y facilitado a quien lo pida", "9·2·28 (estudio 3·2·27)")
#mapa-item("Repetidor analógico-digital accedido por red pública: código personal e intransferible + distintivo", "13·2·28 (estudio 5·2·27)")
#mapa-item("Potencia de las desatendidas: VHF/UHF 10 W en casco urbano y 50 W fuera; HF 50 W", "6·2·27 (estudio 2·2·28)")
#mapa-item("Ganancia del sistema radiante de las desatendidas: ≤ 6 dBd", "1·2·18 (estudio 10·2·18)")
#mapa-item("Repetidores y radiobalizas: telemando y alimentación ininterrumpida ≥ 6 h", "10·2·18 (estudio 5·2·18)")
#mapa-item("Distintivo de los repetidores analógicos: Morse ≤ 10 palabras/min, cada ≤ 10 min", "3·2·19 (estudio 6·2·19)")
#mapa-item("Radiobaliza: desatendida para estudios de propagación que emite señales de identificación", "8·2·17 (estudio 13·2·17)")
#mapa-item("Radiobaliza: distintivo a intervalos ≤ 3 min", "4·2·17 (estudio 5·2·19)")
#mapa-item("Radiobaliza: información solo de su posición y condiciones de funcionamiento", "6·2·17 (estudio 7·2·17)")
#mapa-item("Radiobaliza: sistema radiante omnidireccional", "10·2·19 (estudio 13·2·18)")
#mapa-item("Radiobalizas en las bandas de aficionado (p. ej., 144–146 MHz)", "7·2·19 (estudio 8·2·17)")
#mapa-item("Desatendida: instalarla en 6 meses (si no, caduca la autorización de instalación)", "13·2·17 (estudio 8·2·18)")
#mapa-item("Desatendida terminada: se aplica el procedimiento de la licencia de estación fija (art. 20)", "11·2·17 (estudio 1·2·17)")
#mapa-item("Desatendida: interrupción > 3 meses puede llevar a cancelar su licencia", "2·2·18 (estudio 8·2·19)")
#mapa-item("Interferencia persistente: la SETSI puede restringir bandas, potencia u horario", "1·2·19 (estudio 6·2·20)")
#mapa-item("Interconexión con otras redes: permitida con condiciones (fines de radioafición)", "7·2·20 (estudio 13·2·20)")
#mapa-item("Prohibido codificar para ocultar el significado, salvo el mando de estaciones espaciales", "8·2·18 (estudio 7·2·18)")
#mapa-item("Seguridad: la SETSI no es responsable en ningún caso del incumplimiento de las normas de seguridad", "5·2·19 (estudio 6·2·21)")
#mapa-item("Anomalía de seguridad mecánica o eléctrica: subsanarla de forma inmediata", "5·2·20 (estudio 9·2·20)")
#mapa-item("Disposición final 2.ª: la SETSI dicta instrucciones y actualiza los anexos técnicos", "3·2·20 (estudio 9·2·21)")
#mapa-item("Nomenclatura de bandas: números, símbolos (HF, VHF, SHF…), rangos y ondas (métricas, B.m.…)", "1·2·20 (estudio 7·2·19), 10·2·20 (estudio 3·2·17)")
#mapa-item("Servicio secundario: no causa interferencia al primario ni puede reclamar protección; sí frente a secundarios posteriores", "2·2·19 (estudio 10·2·19)")
#mapa-item("Interferencia perjudicial: compromete la radionavegación o seguridad, o degrada gravemente o interrumpe un servicio", "4·2·18 (estudio 5·2·20)")
#mapa-item("Interferencia: degradación, falseamiento o pérdida de información por energía no deseada", "6·2·18 (estudio 12·2·18)")
#mapa-item("Tolerancia de frecuencia: desviación entre la frecuencia asignada y el centro de la banda ocupada", "4·2·19 (estudio 1·2·18)")
#mapa-item("p.i.r.e. (referencia isótropa) frente a p.r.a. (referencia dipolo)", "11·2·19 (estudio 10·2·20)")
#mapa-item("Modulaciones permitidas: dentro de las bandas y con anchos de banda del plan IARU Región 1", "1·2·22 (estudio 2·2·17)")
#mapa-item("Modulaciones digitales autorizadas: con señales de audio, datos o vídeo", "1·2·23 (estudio 2·2·18)")
#mapa-item("Potencia máxima en HF (1,8–28 MHz): 1000 W p.c.e.", "6·2·19 (estudio 9·2·22)")
#mapa-item("Potencia máxima en 50, 70 y 144 MHz (600 W p.c.e.) y en 430–440 MHz (300 W p.c.e.)", "13·2·18 (estudio 8·2·20)")
#mapa-item("Potencia máxima en 23 cm y superiores: 1000 W p.i.r.e.", "12·2·17 (estudio 4·2·18)")
#mapa-item("Potencia en 137 y 475 kHz: 1 W p.i.r.e. (475 kHz: 5 W a más de 800 km de África)", "11·2·20 (estudio 13·2·21)")
#mapa-item("Bandas con atribución secundaria: potencia ≤ 50 % de la tabla", "11·2·21 (estudio 4·2·19)")
#mapa-item("Banda de 60 m: atribución secundaria y 15 W p.i.r.e.", "12·2·18 (estudio 2·2·19)")
#mapa-item("Banda de 40 m: 7100–7200 kHz, a título primario para aficionados en la Región 1 desde 2009", "7·2·21 (estudio 12·2·19)")
#mapa-item("T/R 61-01 = licencia CEPT (uso temporal); T/R 61-02 = certificado HAREC", "4·2·20 (estudio 2·2·20), 13·2·19 (estudio 10·2·21)")
#mapa-item("Licencia CEPT: habilita temporalmente en los países T/R 61-01; no se concede «a través del HAREC»", "1·2·24 (estudio 1·2·19)")
#mapa-item("Contenido de la licencia CEPT (no consta la asociación ni la fecha del examen)", "6·2·20 (estudio 2·2·21)")
#mapa-item("Licencia CEPT: todas las bandas atribuidas al servicio en el país visitado (no las del país de origen)", "8·2·19 (estudio 4·2·20)")
#mapa-item("Licencia CEPT: presentarla a petición de las autoridades del país visitado", "11·2·22 (estudio 7·2·20)")
#mapa-item("Licencia CEPT: sin protección contra interferencias perjudiciales", "5·2·21 (estudio 6·2·23)")
#mapa-item("Licencia CEPT: respetar siempre el RR y la reglamentación del país visitado", "3·2·21 (estudio 12·2·20)")
#mapa-item("Identificación con licencia CEPT: prefijo del país visitado (y opcionalmente distrito) + distintivo propio", "4·2·21 (estudio 4·2·21)")
#mapa-item("Licencia CEPT de otro país en España: equiparada, solo para no residentes en estancias temporales", "3·2·22 (estudio 1·2·20)")
#mapa-item("Extranjero residente: autorización sin examen con HAREC de un país T/R 61-02 o por reciprocidad (residencia acreditada)", "9·2·20 (estudio 11·2·19), 13·2·20 (estudio 3·2·18)")
#mapa-item("Extranjero de país no T/R 61-01: autorización temporal ≤ 90 días", "4·2·22 (estudio 9·2·23)")
#mapa-item("HAREC: certifica la capacidad para operar; no autoriza a emitir, no caduca, sustituye al diploma de operador", "2·2·20 (estudio 6·2·24)")
#mapa-item("HAREC: permite obtener la autorización en otro país que aplique la T/R 61-02 (traslado de residencia)", "13·2·21 (estudio 6·2·25)")
#mapa-item("RR art. 25: comunicaciones entre países permitidas salvo oposición de una administración", "7·2·22 (estudio 12·2·21)")
#mapa-tema("R9", "Inspección y régimen sancionador")
#mapa-item("Inspección: el Ministerio competente, mediante la inspección de telecomunicaciones y las Jefaturas Provinciales", "7·2·28 (estudio 10·2·28)")
#mapa-item("Potestad sancionadora: Administración General del Estado (titular de la Secretaría de Estado de Telecomunicaciones)", "11·2·28 (estudio 10·2·29)")
#mapa-item("Los inspectores tienen la consideración de autoridad pública", "3·2·28 (estudio 6·2·28)")
#mapa-item("Obligación de permitir la inspección; solo el domicilio protegido exige consentimiento o autorización judicial", "5·2·29 (estudio 6·2·29)")
#mapa-item("Las infracciones se tipifican en la Ley General de Telecomunicaciones", "13·2·29 (estudio 11·2·29)")
#mapa-item("Ley 11/2022: art. 106 muy graves, 107 graves, 108 leves", "8·2·28 (estudio 5·2·28)")
#mapa-item("Muy grave: interceptar sin autorización telecomunicaciones no destinadas al público", "12·2·28 (estudio 5·2·29)")
#mapa-item("Grave: la mera producción de interferencias", "6·2·28 (estudio 8·2·28)")
#mapa-item("Muy grave: la producción deliberada de interferencias", "9·2·29 (estudio 1·2·28)")
#mapa-item("Muy grave: no atender el requerimiento de cese de emisiones", "3·2·29 (estudio 13·2·28)")
#mapa-item("Muy grave: uso del espectro no adecuado al CNAF", "10·2·29 (estudio 4·2·28)")
#mapa-item("Grave: negativa u obstrucción a la inspección", "4·2·28 (estudio 1·2·29)")
#mapa-item("Grave: superar los límites de exposición o no señalizar/vallar", "5·2·30 (estudio 5·2·30)")
#mapa-item("Leve: comunicarse utilizando estaciones no autorizadas", "11·2·29 (estudio 4·2·29)")
#mapa-item("Leve: no facilitar los datos requeridos o retrasarlos", "1·2·29 (estudio 2·2·29)")
#mapa-item("Leve: instalar una estación de radioaficionado sin autorización", "13·2·30 (estudio 9·2·29)")
#mapa-item("Leve: emisión no autorizada, salvo que sea grave o muy grave", "8·2·29 (estudio 3·2·28)")
#mapa-item("No es infracción comunicar con otra estación de la que se es titular", "7·2·29 (estudio 8·2·29)")
#mapa-item("No es infracción no llevar libro de registro (no existe la obligación)", "4·2·29 (estudio 9·2·30)")
#mapa-item("Emitir fuera de las bandas autorizadas es infracción", "6·2·29 (estudio 13·2·29)")
#mapa-item("Multas máximas: 20 M€ muy graves y 2 M€ graves", "2·2·28 (estudio 13·2·30)")
#mapa-item("Multa máxima de las leves: 100 000 €", "2·2·29 (estudio 4·2·30)")
#mapa-item("Prescripción: 3 años muy graves, 2 graves, 1 leves", "3·2·30 (estudio 3·2·29), 11·2·30 (estudio 11·2·30)")
#mapa-item("Sanciones accesorias: cese, ajuste, precintado o incautación de equipos, clausura", "12·2·29 (estudio 7·2·29)")
#mapa-item("Reiteración: 2 o más sanciones firmes del mismo tipo en 3 años; la leve pasa a grave", "8·2·30 (estudio 12·2·29)")
#mapa-item("El expediente se tramita por la LGT y el procedimiento administrativo común", "4·2·30 (estudio 1·2·30)")
#mapa-item("Plazo para resolver el procedimiento sancionador: un año", "7·2·30 (estudio 7·2·30)")
#mapa-item("Plazo mínimo de alegaciones: quince días hábiles", "9·2·30 (estudio 10·2·30)")
#mapa-item("Interferencias comprobadas por la inspección: cese de las emisiones hasta corregir la causa", "10·2·30 (estudio 6·2·30)")
#mapa-item("Titular que sabe que interfiere: medidas técnicas razonables a su costa, sin esperar requerimiento", "1·2·30 (estudio 3·2·30)")
#mapa-item("Revocación: fines comerciales sí; no tener estación no es causa", "6·2·30 (estudio 12·2·30)")
#mapa-item("Cancelación de la autorización a petición del titular", "12·2·30 (estudio 2·2·30)")
#mapa-item("Portadora sin modular: solo para ensayos breves", "2·2·30 (estudio 8·2·30)")
]
