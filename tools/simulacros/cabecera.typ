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
  heading(level: 2)[#_titulo-prueba.at(str(p)) #h(1fr) #text(size: 9pt, weight: "regular", fill: col.gris)[30 preguntas · 45 min]]
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
