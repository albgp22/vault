// =====================================================================
//  Examen de Radioaficionado — plantilla común del libro
//  Todos los capítulos importan este archivo:  #import "/lib/template.typ": *
// =====================================================================

#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

// ---------------------------------------------------------------------
//  Paleta y tipografía
// ---------------------------------------------------------------------
#let col = (
  acento: rgb("#1d5a85"),
  acento-claro: rgb("#e9f1f8"),
  naranja: rgb("#b4532a"),
  naranja-claro: rgb("#fcefe7"),
  verde: rgb("#2c6e49"),
  verde-claro: rgb("#e8f4ec"),
  violeta: rgb("#5e3d99"),
  violeta-claro: rgb("#f1ecf9"),
  ambar: rgb("#8a6400"),
  ambar-claro: rgb("#fdf5dd"),
  gris: rgb("#5b6472"),
  gris-claro: rgb("#f3f4f6"),
  tinta: rgb("#1b1f24"),
  pizarra: rgb("#46597a"),
  pizarra-claro: rgb("#edf0f6"),
  turquesa: rgb("#1d7270"),
  turquesa-claro: rgb("#e6f4f3"),
  // colores para señales en gráficas
  senal1: rgb("#1d5a85"),
  senal2: rgb("#c0392b"),
  senal3: rgb("#2c6e49"),
  senal4: rgb("#8a6400"),
)

// Fuentes libres (OFL) incluidas en fonts/: compila con --font-path fonts.
// Charis SIL es el diseño de Charter; así el PDF sale igual en cualquier máquina.
#let fuente-texto = ("Charis SIL", "Libertinus Serif")
#let fuente-sans = ("Source Sans 3", "Libertinus Serif")
#let fuente-mate = ("STIX Two Math", "New Computer Modern Math")
#let fuente-mono = ("DejaVu Sans Mono",)

// Marca de fin de capítulo: la página en blanco que deja pagebreak(to: "odd")
// queda entre esta marca y la apertura del capítulo siguiente (sin cabecera).
#let _fin-capitulo() = [#metadata("fin") <fin-capitulo>]
#let _salto-capitulo() = { _fin-capitulo(); pagebreak(to: "odd", weak: true) }

// ---------------------------------------------------------------------
//  Numeración de capítulos: temas T1–T10, R1–R9 y apéndices A–D
// ---------------------------------------------------------------------
#let ids-capitulos = (
  range(1, 11).map(n => "T" + str(n)) + range(1, 10).map(n => "R" + str(n)) + ("A", "B", "C", "D")
)

#let numerar-titulo(..nums) = {
  let n = nums.pos()
  let cap = if n.first() == 0 { none } else { ids-capitulos.at(n.first() - 1) }
  if n.len() == 1 { cap } else if cap == none { str(n.at(1)) + "." } else {
    cap + "." + str(n.at(1)) + "."
  }
}

#let numerar-figura(n) = {
  let h = counter(heading).get().first()
  if h == 0 { str(n) } else { ids-capitulos.at(h - 1) + "." + str(n) }
}

// Estilo de numeración de páginas ("i" en preliminares, "1" en el cuerpo)
#let estilo-paginas = state("estilo-paginas", "1")

// Clave del capítulo actual (para ejercicios y preguntas)
#let capitulo-actual = state("capitulo-actual", none)

#let reiniciar-contadores() = {
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(math.equation).update(0)
  counter("ejercicio").update(0)
}

// ---------------------------------------------------------------------
//  Cabeceras de capítulo
// ---------------------------------------------------------------------
#let _rotulo(texto) = text(font: fuente-sans, size: 9pt, weight: "semibold", tracking: 0.14em, fill: col.acento, upper(texto))

#let _cabecera-capitulo(rotulo, titulo, subtitulo: none) = {
  set par(justify: false)
  v(2.2cm)
  align(center, _rotulo(rotulo))
  v(0.35cm)
  align(center, text(font: fuente-sans, size: 21pt, weight: "bold", fill: col.tinta, hyphenate: false, titulo))
  if subtitulo != none {
    v(0.15cm)
    align(center, text(size: 11.5pt, style: "italic", fill: col.gris, subtitulo))
  }
  v(0.35cm)
  align(center, line(length: 30%, stroke: 1.2pt + col.acento))
  v(0.8cm)
}

/// Capítulo de introducción (sin número de tema). Las secciones (==) se numeran 1., 2., …
#let capitulo(clave, titulo, subtitulo: none) = {
  _salto-capitulo()
  capitulo-actual.update(clave)
  reiniciar-contadores()
  counter(heading).update(0)
  _cabecera-capitulo("Para empezar", titulo, subtitulo: subtitulo)
  place(hide(heading(level: 1, numbering: none, titulo)))
}

/// Tema del temario oficial (T1–T10, R1–R9). `alcance` reproduce la ficha oficial.
#let tema(id, titulo, alcance: none) = {
  _salto-capitulo()
  let idx = ids-capitulos.position(x => x == id)
  assert(idx != none, message: "id de tema desconocido: " + id)
  capitulo-actual.update(id)
  reiniciar-contadores()
  [#metadata((id: id, titulo: titulo)) <meta-tema>]
  // Encabezado numerado invisible: da el número al índice y a las secciones
  counter(heading).update(idx)
  place(hide(heading(level: 1, titulo)))
  _cabecera-capitulo("Tema " + id, titulo)
  if alcance != none {
    block(
      width: 100%,
      fill: col.acento-claro,
      stroke: (left: 3pt + col.acento),
      inset: (x: 12pt, y: 10pt),
      radius: (right: 3pt),
      {
        text(font: fuente-sans, size: 8.5pt, weight: "bold", tracking: 0.1em, fill: col.acento)[ALCANCE OFICIAL DEL TEMA]
        h(0.5em)
        text(size: 8.5pt, style: "italic", fill: col.gris)[(Anexo II, Orden IET/1311/2013)]
        v(0.3em)
        set text(size: 9.5pt)
        alcance
      },
    )
    v(0.4cm)
  }
}

/// Apéndice A–D.
#let apendice(letra, titulo) = {
  _salto-capitulo()
  let idx = ids-capitulos.position(x => x == letra)
  capitulo-actual.update("ap-" + letra)
  reiniciar-contadores()
  counter(heading).update(idx)
  place(hide(heading(level: 1, titulo)))
  _cabecera-capitulo("Apéndice " + letra, titulo)
}

/// Portadilla de parte (I, II).
#let parte(numero, titulo, descripcion: none) = {
  _salto-capitulo()
  set par(justify: false)
  v(1fr)
  align(center, text(font: fuente-sans, size: 11pt, weight: "semibold", tracking: 0.2em, fill: col.acento, upper("Parte " + numero)))
  v(0.4cm)
  align(center, text(font: fuente-sans, size: 26pt, weight: "bold", hyphenate: false, titulo))
  if descripcion != none {
    v(0.5cm)
    align(center, block(width: 75%, text(size: 11pt, fill: col.gris, descripcion)))
  }
  v(1fr)
  place(hide(heading(level: 1, numbering: none, supplement: [Parte], [Parte #numero · #titulo])))
}

// ---------------------------------------------------------------------
//  Cajas didácticas
// ---------------------------------------------------------------------
#let _caja(etiqueta, color, fondo, cuerpo, titulo: none) = block(
  width: 100%,
  fill: fondo,
  stroke: (left: 2.5pt + color),
  inset: (x: 12pt, y: 9pt),
  radius: (right: 3pt),
  breakable: true,
  above: 1.3em,
  below: 1.3em,
  {
    // texto en bandera: en una caja estrecha la justificación abre huecos
    set par(justify: false)
    block(below: 0.6em, sticky: true, {
      text(font: fuente-sans, size: 8pt, weight: "bold", tracking: 0.09em, fill: color, upper(etiqueta))
      if titulo != none { h(0.6em); text(font: fuente-sans, size: 9.5pt, weight: "semibold", fill: color, titulo) }
    })
    cuerpo
  },
)

/// Idea central de una sección: lo que hay que llevarse.
#let idea(cuerpo, titulo: none) = _caja("Idea clave", col.acento, col.acento-claro, cuerpo, titulo: titulo)
/// Explicación de POR QUÉ funciona un circuito. Obligatoria tras cada esquema.
#let porque(cuerpo, titulo: none) = _caja("Por qué funciona", col.verde, col.verde-claro, cuerpo, titulo: titulo)
/// Advertencia: trampa típica del examen o peligro real (recuadro ¡OJO! del original).
#let ojo(cuerpo, titulo: none) = _caja("¡Ojo!", col.naranja, col.naranja-claro, cuerpo, titulo: titulo)
/// Motivación: el problema que resuelve lo que viene a continuación.
#let motivacion(cuerpo, titulo: none) = _caja("El problema", col.violeta, col.violeta-claro, cuerpo, titulo: titulo)
/// Analogía mecánica o hidráulica.
#let analogia(cuerpo, titulo: none) = _caja("Imagen mental", col.ambar, col.ambar-claro, cuerpo, titulo: titulo)
/// Nota aclaratoria (recuadro NOTA del original).
#let nota(cuerpo, titulo: none) = _caja("Nota", col.pizarra, col.pizarra-claro, cuerpo, titulo: titulo)
/// Truco práctico o regla mnemotécnica (recuadro TRUCO del original).
#let truco(cuerpo, titulo: none) = _caja("Truco", col.turquesa, col.turquesa-claro, cuerpo, titulo: titulo)
/// Recuadro «No está en el texto» de las soluciones de refuerzo (apéndices B–D).
#let no-esta(cuerpo) = block(above: 0.7em, below: 0.3em, {
  set text(size: 0.92em)
  text(font: fuente-sans, size: 0.78em, weight: "bold", tracking: 0.06em, fill: col.naranja, upper[no está en el texto])
  h(0.55em)
  cuerpo
})
/// Recuadro «Clave de los bancos públicos» (cuando la clave pública difiere de la razonada).
#let clave-bancos(cuerpo) = block(above: 0.7em, below: 0.3em, {
  set text(size: 0.92em)
  text(font: fuente-sans, size: 0.78em, weight: "bold", tracking: 0.06em, fill: col.senal2, upper[clave de los bancos públicos])
  h(0.55em)
  cuerpo
})
/// Nota «(Véase tema …)» al final de una solución.
#let vease(cuerpo) = text(size: 0.92em, style: "italic", fill: col.gris, cuerpo)
/// Ejemplo numérico resuelto.
#let ejemplo(cuerpo, titulo: none) = _caja("Ejemplo resuelto", col.gris, col.gris-claro, cuerpo, titulo: titulo)

/// Título de párrafo en línea («La idea de Maxwell.»)
#let ptitulo(t) = text(font: fuente-sans, weight: "bold", size: 0.95em, fill: col.tinta, t + [.]) + h(0.4em)

/// Fórmula destacada en recuadro.
#let destacada(f, nota: none) = align(center, block(
  fill: col.acento-claro,
  stroke: 0.6pt + col.acento,
  radius: 3pt,
  inset: (x: 14pt, y: 8pt),
  {
    f
    if nota != none { linebreak(); text(size: 8.5pt, fill: col.gris, nota) }
  },
))

/// Referencia cruzada legible a una SECCIÓN con etiqueta: #ver(<sec-transistor>)
/// → «El transistor: el grifo que amplifica», p. 22.  Para figuras usa @etiqueta.
#let ver(etiqueta) = context {
  let els = query(etiqueta)
  if els.len() == 0 { text(fill: red)[[?? #str(etiqueta)]] } else {
    let el = els.first()
    if el.func() == figure { ref(etiqueta) } else {
      let pag = counter(page).at(el.location()).first()
      let txt = if el.func() == heading { [«#el.body»] } else { [aquí] }
      link(el.location(), [#txt, p. #pag])
    }
  }
}

// ---------------------------------------------------------------------
//  Ejercicios con solución al final del capítulo
// ---------------------------------------------------------------------
#let ejercicio(cuerpo, sol: none) = {
  counter("ejercicio").step()
  context {
    let n = counter("ejercicio").get().first()
    [#metadata((cap: capitulo-actual.get(), n: n, sol: sol)) <meta-ejercicio>]
    block(
      width: 100%,
      fill: col.verde-claro.lighten(30%),
      stroke: 0.5pt + col.verde.lighten(40%),
      inset: (x: 11pt, y: 8pt),
      radius: 3pt,
      breakable: false,
      [#text(font: fuente-sans, size: 8.5pt, weight: "bold", tracking: 0.08em, fill: col.verde)[EJERCICIO #n] #h(0.4em) #cuerpo],
    )
  }
}

#let soluciones-ejercicios() = context {
  let cap = capitulo-actual.get()
  let ejs = query(<meta-ejercicio>).map(m => m.value).filter(v => v.cap == cap and v.sol != none)
  if ejs.len() > 0 {
    v(0.6cm)
    block(below: 0.6em, text(font: fuente-sans, size: 12pt, weight: "bold", fill: col.verde)[Soluciones de los ejercicios])
    set text(size: 9.5pt)
    for e in ejs {
      block(below: 0.7em, [#text(font: fuente-sans, weight: "bold", fill: col.verde)[#e.n.] #e.sol])
    }
  }
}

// ---------------------------------------------------------------------
//  Preguntas tipo test. La solución se escribe JUNTO a la pregunta y el
//  apéndice D la recoge con #soluciones("T1").
// ---------------------------------------------------------------------
#let _letras = ("a", "b", "c", "d", "e", "f")

/// #q("T1.7", "a", [Enunciado], ([op a], [op b], [op c], [op d]), sol: [razonamiento])
#let q(id, ans, enunciado, opciones, sol: none) = {
  let partes = id.split(".")
  let grupo = partes.slice(0, -1).join(".")
  [#metadata((id: id, grupo: grupo, num: partes.last(), ans: ans, sol: sol)) <meta-pregunta>]
  block(
    width: 100%,
    breakable: false,
    above: 1.1em,
    below: 1.1em,
    {
      text(font: fuente-sans, weight: "bold", fill: col.acento, id)
      h(0.5em)
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
        pad(left: 1.2em, grid(columns: (1fr,) * cols, column-gutter: 1em, row-gutter: 0.55em, ..items))
      })
    },
  )
}

/// Clave rápida: tabla Pregunta/Respuesta en filas de `por-fila`. Todas las filas
/// tienen el mismo ancho de columna; la última se rellena con celdas vacías.
#let clave-rapida(pares, por-fila: 20) = {
  let filas = pares.chunks(por-fila)
  let n = calc.min(por-fila, pares.len())
  set text(font: fuente-sans, size: 8.5pt)
  show table.cell.where(y: 0): set text(weight: "regular", size: 1em / 0.92)
  let celdas = ()
  for (i, f) in filas.enumerate() {
    let vacias = n - f.len()
    celdas += (table.cell(fill: col.gris-claro, text(fill: col.gris)[Pregunta]),)
    celdas += f.map(p => table.cell(fill: col.gris-claro, text(fill: col.gris, p.first())))
    celdas += ((table.cell(fill: col.gris-claro)[]),) * vacias
    celdas += ([*Respuesta*],)
    celdas += f.map(p => text(weight: "bold", fill: col.acento, p.last()))
    celdas += ([],) * vacias
  }
  block(breakable: false, below: 0.8em, table(
    columns: (auto,) + (1fr,) * n,
    align: (x, y) => if x == 0 { left + horizon } else { center + horizon },
    stroke: (x, y) => if calc.odd(y) { (bottom: 0.5pt + col.gris.lighten(45%)) } else { none },
    inset: (x: 4pt, y: 3.5pt),
    row-gutter: (0pt, 5pt) * filas.len(),
    ..celdas,
  ))
}

/// Clave + soluciones razonadas de un grupo ("T1", "C-T1", "F-R8", …)
#let soluciones(grupo) = context {
  let qs = query(<meta-pregunta>).map(m => m.value).filter(v => v.grupo == grupo)
  if qs.len() == 0 {
    text(fill: red)[[No hay preguntas del grupo #grupo]]
  } else {
    clave-rapida(qs.map(v => (v.num, v.ans)))
    v(0.4em)
    for v in qs {
      block(below: 0.85em, breakable: true, [
        #text(font: fuente-sans, weight: "bold", fill: col.acento, v.id)
        #text(weight: "bold")[(#v.ans)]
        #if v.sol != none { v.sol } else { text(fill: red)[[falta la solución]] }
      ])
    }
  }
}

// ---------------------------------------------------------------------
//  Figuras de circuitos, enlaces a Falstad
// ---------------------------------------------------------------------
#let falstad-base = "https://www.falstad.com/circuit/circuitjs.html?startCircuit="

/// Enlace «Simúlalo en Falstad». Acepta el nombre de un ejemplo de Falstad
/// (p. ej. "lrc.txt") o una URL completa.
#let falstad(destino, texto: [Simúlalo en Falstad]) = {
  let url = if destino.starts-with("http") { destino } else { falstad-base + destino }
  // Interfaz en español y resistencias IEC (rectángulo), como en el libro
  if url.contains("falstad.com/circuit") and not url.contains("lang=") {
    url = url + "&lang=es&euroResistors=true"
  }
  link(url, box(
    fill: col.violeta-claro,
    stroke: 0.5pt + col.violeta,
    radius: 2pt,
    inset: (x: 4pt, y: 2pt),
    baseline: 20%,
    text(font: fuente-sans, size: 7.5pt, weight: "semibold", fill: col.violeta)[▶ #texto],
  ))
}

/// Figura con esquema o gráfica. `sim:` añade el enlace a Falstad al pie.
/// Uso:  #circuito(caption: [...], sim: "lrc.txt")[ #zap.circuit({ ... }) ] <t3-fig-lrc>
#let circuito(cuerpo, caption: none, sim: none) = figure(
  cuerpo,
  kind: image,
  caption: if sim == none { caption } else { [#caption #h(0.3em) #falstad(sim)] },
)

// ---------------------------------------------------------------------
//  Plantilla del documento
// ---------------------------------------------------------------------
/// Página que solo existe para que el capítulo siguiente empiece en impar.
#let _pagina-en-blanco(pag) = {
  query(<fin-capitulo>).any(m => m.location().page() == pag - 1) and not query(heading.where(level: 1)).any(h => h.location().page() == pag)
}

// ---------------------------------------------------------------------
// ---------------------------------------------------------------------
#let libro(cuerpo) = {
  set document(title: "Examen de Radioaficionado — Banco de preguntas razonado", author: "")
  set text(font: fuente-texto, size: 10.5pt, lang: "es", region: "es", hyphenate: true, fill: col.tinta)
  set par(justify: true, leading: 0.64em, spacing: 0.95em)
  show math.equation: set text(font: fuente-mate)
  show math.equation: it => { show ",": math.class("normal", ","); it }
  set math.equation(numbering: none)
  set list(indent: 0.6em, marker: ([•], [–]))
  set enum(indent: 0.6em)

  set heading(numbering: numerar-titulo)
  show heading.where(level: 3): set heading(numbering: none)
  show heading.where(level: 4): set heading(numbering: none)
  show heading.where(level: 2): it => {
    v(1.1em)
    block(below: 0.8em, sticky: true, text(font: fuente-sans, size: 13pt, weight: "bold", fill: col.acento, {
      if it.numbering != none {
        counter(heading).display(it.numbering)
        h(0.6em)
      }
      it.body
    }))
  }
  show heading.where(level: 3): it => block(above: 1.1em, below: 0.6em, sticky: true, text(font: fuente-sans, size: 11pt, weight: "bold", fill: col.tinta, it.body))
  show heading.where(level: 4): it => block(above: 0.9em, below: 0.5em, sticky: true, text(font: fuente-sans, size: 10pt, weight: "semibold", style: "italic", fill: col.gris, it.body))

  set figure(numbering: numerar-figura, gap: 0.7em)
  show figure: set block(breakable: false, above: 1.2em, below: 1.2em)
  // una tabla larga puede partirse: así no deja media página vacía delante
  show figure.where(kind: table): set block(breakable: true)
  show figure.caption: it => {
    set text(size: 9pt)
    set par(justify: true)
    block(width: 92%, align(left, [#text(font: fuente-sans, weight: "bold", fill: col.acento)[#it.supplement #context it.counter.display(it.numbering):] #it.body]))
  }

  set table(stroke: 0.4pt + col.gris.lighten(40%), inset: (x: 5pt, y: 4pt),
    fill: (x, y) => if y == 0 { col.gris-claro })
  show table.cell: set par(justify: false)
  show table.cell.where(y: 0): set text(font: fuente-sans, weight: "semibold", size: 0.92em)

  show link: it => if type(it.dest) == str { text(fill: col.violeta, it) } else { it }

  set page(
    paper: "a4",
    margin: (inside: 2.3cm, outside: 2.1cm, top: 2.4cm, bottom: 2.3cm),
    header: context {
      let pag = here().page()
      // sin cabecera en páginas que abren capítulo ni en las páginas en blanco
      let abre = query(heading.where(level: 1)).any(h => h.location().page() == pag)
      if abre or _pagina-en-blanco(pag) { return }
      let previos = query(heading.where(level: 1).before(here()))
      let cap = if previos.len() > 0 { previos.last().body } else { [] }
      // sección: la primera que empieza en esta página; si no, la última anterior del mismo capítulo
      let en-pag = query(heading.where(level: 2)).filter(h => h.location().page() == pag)
      let secs = query(heading.where(level: 2).before(here()))
      let sec = if en-pag.len() > 0 { en-pag.first().body } else if secs.len() > 0 and previos.len() > 0 and secs.last().location().page() >= previos.last().location().page() { secs.last().body } else { cap }
      set text(font: fuente-sans, size: 8.5pt, fill: col.gris, hyphenate: false)
      set par(justify: false)
      if calc.even(pag) { cap } else { h(1fr); sec }
      v(-0.45em)
      line(length: 100%, stroke: 0.4pt + col.gris.lighten(55%))
    },
    footer: context {
      if _pagina-en-blanco(here().page()) { return }
      set text(font: fuente-sans, size: 9pt, fill: col.gris)
      let n = counter(page).display(estilo-paginas.get())
      if calc.even(here().page()) { n } else { h(1fr); n }
    },
  )

  cuerpo
}
