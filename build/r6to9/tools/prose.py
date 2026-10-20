HEADER={}
MID={'R6':{},'R7':{},'R8':{},'R9':{}}

HEADER['R6']=r'''
#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// Código en tipografía monoespaciada (QSY, QRL…), como en el original.
#let _r6-cod(t) = text(font: ("Menlo", "DejaVu Sans Mono", "Courier"), size: 0.88em, fill: col.acento, t)

#tema("R6", "Planes de bandas de la IARU", alcance: [Planes de bandas de la IARU · objetivos que se persiguen en dichos planes.])

La IARU (Unión Internacional de Radioaficionados) agrupa a las asociaciones nacionales — la URE en España — y divide el mundo, como la UIT, en tres Regiones: la 1 (Europa, África, Oriente Medio y norte de Asia, la nuestra), la 2 (América) y la 3 (resto de Asia y Oceanía). Como las atribuciones de frecuencias difieren entre Regiones, cada una tiene su propio *plan de bandas*: un reparto _recomendado_ de cada banda de aficionados en segmentos por modos — telegrafía, banda estrecha, fonía, modos digitales, balizas, entradas y salidas de repetidores, satélites — con sus *frecuencias de llamada*. No es una norma con rango legal, sino el acuerdo de convivencia que evita que un modo pise a otro; la reglamentación española remite a él y todo radioaficionado que opere en España debe tenerlo en cuenta. Un ejemplo que cae en el examen: en la banda de 2 m, la entrada de los repetidores ocupa 145,000–145,1875 MHz y su salida va 600 kHz más arriba. (El plan vigente, de diciembre de 2020, amplía esos segmentos a 144,975–145,194 MHz para las entradas y 145,575–145,7935 MHz para las salidas, con el mismo desplazamiento de 600 kHz; las preguntas del banco usan los valores clásicos.)
'''

MID['R6']['h:R6.1']=r'''
El espectro no se reparte igual en todo el planeta. Para poder atribuir bandas a cada servicio sin que un país estorbe a su vecino, la UIT divide el mundo en tres *Regiones* (figura #ref(<r6-fig-regiones>, supplement: none)), y el Cuadro de atribuciones asigna las bandas región por región. Por eso una banda de aficionado puede tener límites distintos según dónde se esté — el caso más citado es el de 40 metros — y por eso los planes de banda de la IARU también se redactan por regiones.

*España está en la Región 1*, que abarca Europa, África, Oriente Medio y el norte de Asia. La *Región 2* es América entera, y la *Región 3*, Asia meridional y oriental junto con Oceanía. La IARU se organiza en tres divisiones que calcan esas regiones, de modo que el plan de banda que hay que conocer para el examen es el de la Región 1.

// Cada Región es una celda del cuadro: título, descripción y, si procede, una marca.
#let _r6-reg(titulo, detalle, pie: none) = align(center + top, {
  text(font: fuente-sans, size: 10pt, weight: "bold", fill: col.tinta, titulo)
  parbreak()
  text(font: fuente-sans, size: 7.5pt, fill: col.gris, detalle)
  if pie != none {
    parbreak()
    v(0.5em)
    text(font: fuente-sans, size: 8pt, weight: "bold", fill: col.naranja, pie)
  }
})

#circuito(caption: [Las tres Regiones en que la UIT divide el mundo para atribuir el espectro. España pertenece a la Región 1, y es su plan de banda de la IARU el que rige aquí.])[
  #block(width: 80%, grid(
    columns: (1fr, 1fr, 1fr),
    rows: 3.2cm,
    inset: (x: 6pt, y: 9pt),
    fill: (x, y) => (col.naranja-claro, col.acento-claro, col.verde-claro).at(x),
    stroke: (x, y) => (
      top: 0.6pt + col.gris,
      bottom: 0.6pt + col.gris,
      left: if x == 0 { 0.6pt + col.gris } else { (paint: col.gris, thickness: 0.6pt, dash: "dashed") },
      right: if x == 2 { 0.6pt + col.gris },
    ),
    _r6-reg([Región 2], [América \ (norte, centro y sur)]),
    _r6-reg([Región 1], [Europa, África, \ Oriente Medio \ y norte de Asia], pie: [España]),
    _r6-reg([Región 3], [Asia meridional \ y oriental, Oceanía]),
  ))
] <r6-fig-regiones>
'''

MID['R6']['post']=r'''
#nota[La restricción (Instrucciones de 2006, apartado 2) prohibía emitir en 6 metros desde Ávila, Guadalajara, Madrid, Segovia, Soria, Toledo y Valladolid, con límites parciales en otras provincias del centro, para proteger la recepción de la televisión analógica. Con el apagón analógico (2010) desapareció — en la Orden vigente la banda de 50 MHz ya no tiene condición geográfica, aunque el CNAF (nota UN-100) mantiene que es un uso especial que no puede causar interferencia perjudicial a la televisión de países vecinos —, pero la pregunta sigue apareciendo en los bancos con su redacción histórica (en el banco original: «señale la provincia desde la que se podrán efectuar emisiones», con Almería como respuesta).]
'''

HEADER['R7']=r'''
#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// Código en tipografía monoespaciada (QRL, QSL…), como en el original.
#let _r7-cod(t) = text(font: ("Menlo", "DejaVu Sans Mono", "Courier"), size: 0.88em, fill: col.acento, t)

#tema("R7", "Responsabilidad social y procedimientos operativos", alcance: [Responsabilidad social del radioaficionado · procedimientos operativos.])

El Reglamento de Radiocomunicaciones define el servicio de aficionados como un servicio de _instrucción individual, intercomunicación y estudios técnicos_ efectuado por personas autorizadas que se interesan en la radiotecnia _sin fines de lucro_. De esa definición cuelga toda la deontología operativa que examina este tema: se escucha antes de transmitir («#_r7-cod[¿QRL?]»), se transmite en lenguaje claro y sin codificar el significado, el contenido se ciñe al servicio y a observaciones personales — nada de fines comerciales, publicitarios o lucrativos (causa de revocación, art. 8.1.b de la Orden) ni tráfico para terceros, salvo en emergencia o desastre (art. 30.3) —, jamás se interfiere deliberadamente, se deletrea con el alfabeto internacional y la estación se identifica con su distintivo al comienzo y al final de cada emisión — y, si es larga, a intervalos cortos: al menos cada diez minutos, fija el art. 29 de la Orden IET/1311/2013 —. El «cambio» al ceder la palabra y la tarjeta #_r7-cod[QSL] que confirma el contacto completan la liturgia del buen operador.
'''

HEADER['R8']=r'''
#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// Código en tipografía monoespaciada (QSL, EA4/M0ABC…), como en el original.
#let _r8-cod(t) = text(font: ("Menlo", "DejaVu Sans Mono", "Courier"), size: 0.88em, fill: col.acento, t)

#tema("R8", "Reglamentación nacional e internacional", alcance: [Nacional: Ley 19/1983 (derecho a instalar antenas en el exterior de los inmuebles), Real Decreto 2623/1986 (instalaciones de antenas), Ley General de Telecomunicaciones, reglamentos de uso del dominio público radioeléctrico · CEPT: Recomendación T/R 61-01 (uso temporal de estaciones en otros países) y Recomendación T/R 61-02 (certificado armonizado HAREC) · UIT: definiciones de los servicios de aficionados, Reglamento de Radiocomunicaciones, regiones y zonas.])

#truco[Las dos recomendaciones CEPT se confunden constantemente: la *T/R 61-01* regula el _uso temporal_ de tu estación cuando visitas otro país (la licencia CEPT), y la *T/R 61-02*, el certificado de examen armonizado *HAREC*. Como gancho, son dos pasos: de _visita_ basta la licencia CEPT (61-0#strong[1], paso uno); si te _instalas_ en el país, el paso dos es convalidar tu examen con el HAREC (61-0#strong[2]).]

El marco normativo se organiza en tres pisos. Arriba, la *UIT* y su Reglamento de Radiocomunicaciones: atribuye las bandas, divide el mundo en tres Regiones (España, Región 1), define los servicios de aficionados y de aficionados por satélite y exige identificarse a intervalos cortos (art. 25). En medio, la *CEPT*, cuyas dos recomendaciones armonizan Europa: la T/R 61-01 (la licencia CEPT que permite operar temporalmente en otros países) y la T/R 61-02 (el certificado de examen HAREC). Abajo, el derecho *español*: la Ley General de Telecomunicaciones (Ley 11/2022) como marco, el Reglamento de uso del dominio público radioeléctrico por aficionados (Orden IET/1311/2013) como norma de detalle, y la pareja histórica de las antenas — Ley 19/1983 y RD 2623/1986 — que garantiza el derecho a instalarlas en el exterior de los inmuebles. La competencia es exclusiva del Estado (art. 149.1.21.ª de la Constitución).

#nota[La Orden IET/1311/2013 remite a normas que hoy están sustituidas: la Ley 32/2003 (después la Ley 9/2014 y hoy la Ley 11/2022), el Real Decreto 863/2008 (hoy el RD 123/2017) y la Ley 30/1992 (hoy la Ley 39/2015); y llama SETSI al órgano que hoy es la SETID. Los bancos de preguntas repiten esos nombres antiguos: aquí se cita el artículo de la Orden y, cuando hace falta, la norma vigente.]

Del articulado, lo que el examen pregunta son sobre todo _números_. Esta tabla reúne los que caen una y otra vez:

// Tabla de cifras (sin fila de títulos, como en el original). La plantilla da estilo de
// cabecera a la primera fila; se anula con texto explícito en sus dos celdas.
#let _r8-c(t) = text(font: fuente-texto, weight: "regular", size: 10.5pt, t)
#{
  set par(justify: false)
  block(breakable: false, table(
    columns: (auto, 1fr),
    align: left + top,
    stroke: (x, y) => (
      top: if y == 0 { 0.8pt + col.tinta } else { 0.3pt + col.gris.lighten(55%) },
      bottom: if y == 11 { 0.8pt + col.tinta },
    ),
    inset: (x: 6pt, y: 4.5pt),
    _r8-c[Resolución de la solicitud de autorización], _r8-c[6 semanas (silencio desestimatorio)],
    [Renovación de la autorización], [no hay: vigencia indefinida (art. 5.4); suprimida la comunicación quinquenal (DA 1.ª)],
    [Aviso de la comunidad para obras], [1 mes de antelación],
    [Autorización especial experimental (art. 17)], [nominativa; plazo máximo inicial de 18 meses, ampliable],
    [Uso portable (fuera de la ubicación habitual)], [notificar con 5 días; los usos no continuados de hasta 15 días naturales consecutivos no precisan notificación],
    [Desatendidas VHF/UHF], [10 W en casco urbano, 50 W fuera],
    [Desatendidas HF], [50 W],
    [Ganancia del sistema radiante (desatendidas)], [≤6 dBd],
    [Alimentación ininterrumpida (repetidores/balizas)], [6 horas],
    [Distintivo en Morse de los repetidores], [velocidad ≤10 palabras por minuto, a intervalos ≤10 minutos (art. 25.d)],
    [Radiobalizas de aficionado], [segmentos del plan de bandas IARU R1 (p. ej. 144,400–144,491 MHz); la Orden vigente no enumera bandas],
    [Bandas con autorización especial], [2300–2450 MHz (salvo 2316–2332), 5650–5850 MHz (salvo 5700–5720 y 5760–5762) y 24,050–24,250 GHz (DA 2.ª)],
  ))
}
'''

HEADER['R9']=r'''
#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

#tema("R9", "Inspección y régimen sancionador", alcance: [Órganos competentes en materia de inspección de equipos y estaciones del servicio de aficionados · infracciones y régimen sancionador en materia de radioaficionados.])

La potestad de inspección y sanción corresponde al Estado: el Ministerio competente en telecomunicaciones, a través de su inspección y de las Jefaturas Provinciales de Inspección de Telecomunicaciones. Las infracciones se tipifican en la Ley General de Telecomunicaciones vigente (Ley 11/2022) en tres grados, y del grado dependen la multa y los plazos de prescripción. El banco de preguntas se concentra en unas pocas conductas y en dos cifras:

#block(breakable: false, {
  set par(justify: false)
  table(
  columns: (auto, 1fr, auto),
  align: left + top,
  stroke: (x, y) => (
    top: if y == 0 { 0.8pt + col.tinta } else if y == 1 { 0.5pt + col.tinta } else { 0.3pt + col.gris.lighten(55%) },
    bottom: if y == 3 { 0.8pt + col.tinta },
  ),
  inset: (x: 6pt, y: 4.5pt),
  [Grado], [Conducta típica del examen], [Multa hasta],
  [Muy grave], [interceptar telecomunicaciones ajenas al público (art. 106.15); no atender el requerimiento de cese de emisiones por interferencias (art. 106.8)], [20 millones €],
  [Grave], [la mera producción de interferencias a servicios autorizados (art. 107.6); obstruir la inspección (art. 107.36)], [2 millones €],
  [Leve], [comunicarse utilizando estaciones no autorizadas (art. 108.2); no facilitar datos (art. 108.12)], [100.000 €],
)})

#nota[Un matiz sobre las «identificaciones falsas o engañosas». Los enunciados antiguos del banco la dan como infracción _grave_: así la tipificaba la Ley 9/2014 (art. 77.5) y antes la Ley 32/2003 (art. 54.d). La vigente Ley 11/2022 (arts. 106–108) ya no la recoge con esas palabras: hoy la conducta encajaría, como mucho, en la infracción leve de incumplir las condiciones de la autorización (art. 108.5), y sigue prohibida por el Reglamento de Radiocomunicaciones y por la Constitución de la UIT (art. 47). Por eso las preguntas de este cuaderno usan conductas graves que la ley vigente sí contempla (la mera producción de interferencias, art. 107.6, o la obstrucción a la inspección, art. 107.36). Si en el examen aparece la identificación falsa con la opción «grave», es la que dan por buena.]

Las infracciones prescriben a los tres años (muy graves), dos años (graves) y un año (leves) (art. 113).
'''
