// =====================================================================
//  Esquemas: zap (componentes IEC sobre CeTZ) + componentes propios
//  Uso:  #import "/lib/circuits.typ": *
//        #zap.circuit({ import zap: *; import comp: *; ... })
// =====================================================================

#import "@preview/zap:0.4.0"
#import "@preview/cetz:0.4.2"

#let comp = (:)

// Atajo: lienzo de esquema con el estilo del libro
#let esquema(cuerpo, escala: 1.0) = zap.circuit({
  zap.set-style(zap: (
    variant: "iec",
    stroke: 0.8pt,
    wires: (stroke: 0.6pt),
    // bobinas en espiras y operacional en triángulo: más legibles para quien empieza
    inductor: (variant: "ieee"),
    opamp: (variant: "ieee"),
  ))
  cetz.draw.scale(escala)
  cuerpo
})

// ---------------------------------------------------------------------
//  Componentes que zap no trae. Todos son de dos terminales (in/out)
//  salvo que se diga lo contrario; se colocan igual que resistor():
//     cristal("x1", (0,0), (2,0), label: [X1])
// ---------------------------------------------------------------------

/// Cristal de cuarzo: placa entre dos electrodos.
#let cristal(name, node, ..params) = {
  import cetz.draw: *
  let style = (width: .62, height: .62)
  let draw(ctx, position, style) = {
    let w = style.width
    let h = style.height
    zap.interface((-w / 2, -h / 2), (w / 2, h / 2), io: position.len() < 2)
    line((-w / 2, -h / 2 * .8), (-w / 2, h / 2 * .8), ..style)
    line((w / 2, -h / 2 * .8), (w / 2, h / 2 * .8), ..style)
    rect((-w / 2 + .12, -h / 2), (w / 2 - .12, h / 2), fill: white, ..style)
  }
  zap.component("cristal", name, node, draw: draw, style: style, ..params)
}

/// Pila o batería (placa larga = +).
#let bateria(name, node, ..params) = {
  import cetz.draw: *
  let style = (width: .3, height: .9)
  let draw(ctx, position, style) = {
    let h = style.height
    zap.interface((-.15, -h / 2), (.15, h / 2), io: position.len() < 2)
    line((-.15, -h / 2), (-.15, h / 2), ..style)
    line((.15, -h / 4), (.15, h / 4), stroke: 2pt)
    content((-.3, h / 2), text(size: 7pt)[+])
  }
  zap.component("bateria", name, node, draw: draw, style: style, ..params)
}

/// Instrumento de medida: círculo con letra (V, A, mA, W…).
#let medidor(name, node, letra: "V", ..params) = {
  import cetz.draw: *
  let style = (radius: .42)
  let draw(ctx, position, style) = {
    zap.interface((-style.radius, -style.radius), (style.radius, style.radius), io: position.len() < 2)
    circle((0, 0), radius: style.radius, fill: white, ..style)
    content((0, 0), text(size: 8pt, weight: "bold", letra))
  }
  zap.component("medidor", name, node, draw: draw, style: style, ..params)
}

/// Lámpara: círculo con aspa.
#let lampara(name, node, ..params) = {
  import cetz.draw: *
  let style = (radius: .38)
  let draw(ctx, position, style) = {
    let r = style.radius
    zap.interface((-r, -r), (r, r), io: position.len() < 2)
    circle((0, 0), radius: r, fill: white, ..style)
    let d = r * calc.cos(45deg)
    line((-d, -d), (d, d), ..style)
    line((-d, d), (d, -d), ..style)
  }
  zap.component("lampara", name, node, draw: draw, style: style, ..params)
}

/// Altavoz (también auricular). Dos terminales verticales a la izquierda.
#let altavoz(name, node, ..params) = {
  import cetz.draw: *
  let style = (width: .3, height: .6)
  let draw(ctx, position, style) = {
    if position.len() < 2 {
      // suelto: cono hacia la derecha
      zap.interface((-.15, -.3), (.15, .3), io: true)
      rect((-.15, -.3), (.15, .3), fill: white, ..style)
      line((.15, .3), (.55, .65), (.55, -.65), (.15, -.3), ..style, fill: white)
    } else {
      // entre dos nodos: el cuerpo sobre el cable y el cono hacia un lado, sin tapar el cable
      zap.interface((-.3, -.15), (.3, .15), io: false)
      rect((-.3, -.15), (.3, .15), fill: white, ..style)
      line((-.3, .15), (-.65, .55), (.65, .55), (.3, .15), close: true, ..style, fill: white)
    }
  }
  zap.component("altavoz", name, node, draw: draw, style: style, ..params)
}

/// Micrófono: círculo con barra lateral.
#let microfono(name, node, ..params) = {
  import cetz.draw: *
  let style = (radius: .38)
  let draw(ctx, position, style) = {
    let r = style.radius
    zap.interface((-r, -r), (r, r), io: position.len() < 2)
    circle((0, 0), radius: r, fill: white, ..style)
    line((-r, -r), (-r, r), stroke: 1.6pt)
  }
  zap.component("microfono", name, node, draw: draw, style: style, ..params)
}

/// Triodo (válvula). Un solo nodo (centro). Anclas: "placa", "rejilla", "catodo".
#let triodo(name, node, ..params) = {
  import cetz.draw: *
  let style = (radius: .75)
  let draw(ctx, position, style) = {
    let r = style.radius
    zap.interface((-r, -r), (r, r))
    circle((0, 0), radius: r, fill: white, ..style)
    // placa
    line((-.35, .4), (.35, .4), stroke: 1.2pt)
    line((0, .4), (0, r))
    anchor("placa", (0, r))
    // rejilla (discontinua)
    line((-.42, 0), (.42, 0), stroke: (dash: "dashed", thickness: .7pt))
    line((-r, 0), (-.42, 0))
    anchor("rejilla", (-r, 0))
    // cátodo
    line((-.3, -.4), (.3, -.4), (.3, -.5), stroke: 1pt)
    line((0, -.4), (0, -r))
    anchor("catodo", (0, -r))
  }
  zap.component("triodo", name, node, draw: draw, style: style, ..params)
}


/// Transformador con devanados visibles. Un solo nodo (centro).
/// Anclas: "p1" (primario arriba), "p2" (primario abajo), "s1" (secundario arriba), "s2".
/// `nucleo: true` dibuja el núcleo de hierro; `espiras: (4, 4)` cambia el número de vueltas.
#let trafo(name, node, nucleo: true, espiras: (4, 4), ..params) = {
  import cetz.draw: *
  let style = (r: .2, sep: .42)
  let draw(ctx, position, style) = {
    let r = style.r
    let (n1, n2) = espiras
    let h1 = 2 * r * n1
    let h2 = 2 * r * n2
    let hmax = calc.max(h1, h2)
    zap.interface((-1, -hmax / 2), (1, hmax / 2))
    // primario: jorobas hacia el núcleo (derecha)
    for i in range(n1) {
      arc((-style.sep, h1 / 2 - 2 * r * i), start: 90deg, stop: -90deg, radius: r, ..style)
    }
    // secundario: jorobas hacia el núcleo (izquierda)
    for i in range(n2) {
      arc((style.sep, h2 / 2 - 2 * r * i), start: 90deg, stop: 270deg, radius: r, ..style)
    }
    if nucleo {
      line((-.07, -hmax / 2), (-.07, hmax / 2), ..style)
      line((.07, -hmax / 2), (.07, hmax / 2), ..style)
    }
    line((-style.sep, h1 / 2), (-1, h1 / 2), ..style.at("wires"))
    line((-style.sep, -h1 / 2), (-1, -h1 / 2), ..style.at("wires"))
    line((style.sep, h2 / 2), (1, h2 / 2), ..style.at("wires"))
    line((style.sep, -h2 / 2), (1, -h2 / 2), ..style.at("wires"))
    anchor("p1", (-1, h1 / 2))
    anchor("p2", (-1, -h1 / 2))
    anchor("s1", (1, h2 / 2))
    anchor("s2", (1, -h2 / 2))
  }
  zap.component("trafo", name, node, draw: draw, style: style, ..params)
}

// ---------------------------------------------------------------------
//  Utilidades de dibujo para gráficas de señales (sin cetz-plot)
// ---------------------------------------------------------------------

/// Polilínea de una función: onda(x => calc.sin(x), 0, 6.28, n: 200)
#let onda(f, x0, x1, n: 160, ..estilo) = {
  let pts = range(n + 1).map(i => {
    let x = x0 + (x1 - x0) * i / n
    (x, f(x))
  })
  cetz.draw.line(..pts, ..estilo)
}

/// Ejes simples con flecha y etiquetas.
#let ejes(x0, x1, y0, y1, etq-x: none, etq-y: none) = {
  import cetz.draw: *
  line((x0, 0), (x1, 0), mark: (end: ">", fill: black), stroke: 0.6pt)
  line((0, y0), (0, y1), mark: (end: ">", fill: black), stroke: 0.6pt)
  if etq-x != none { content((x1, 0), anchor: "north-east", padding: 3pt, text(size: 8pt, etq-x)) }
  if etq-y != none { content((0, y1), anchor: "north-west", padding: 3pt, text(size: 8pt, etq-y)) }
}

#let comp = (
  cristal: cristal,
  bateria: bateria,
  medidor: medidor,
  lampara: lampara,
  altavoz: altavoz,
  microfono: microfono,
  triodo: triodo,
  trafo: trafo,
)
