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
    [Estos conceptos de la prueba técnica son de peso menor: caen poco, pero caen. No ocupan sitio en los simulacros para no alargarlos; aquí están en formato rápido, pregunta y respuesta correcta, con el número de la pregunta del libro donde está el razonamiento. Léelos cuando domines los simulacros: cada uno se aprende en segundos.]
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
