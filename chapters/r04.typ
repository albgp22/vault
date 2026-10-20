#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

#tema("R4", "Señales de socorro, urgencia y seguridad", alcance: [Señales radiotelegráficas y radiotelefónicas de alarma, socorro, urgencia y seguridad · empleo internacional de las radiocomunicaciones de aficionado en catástrofes naturales (Resolución 640 del Reglamento de Radiocomunicaciones) · bandas de frecuencias atribuidas al Servicio de Aficionados y al Servicio de Aficionados por Satélite.])

// Tabla de pares (código, significado) en n grupos de columnas, ordenada por columnas.
#let _r4-grupos(pares, n: 2, cab: ([Grupo], [Significado])) = {
  let filas = calc.ceil(pares.len() / n)
  let celdas = ()
  for g in range(n) { celdas += cab }
  for r in range(filas) {
    for g in range(n) {
      let i = g * filas + r
      if i < pares.len() {
        let p = pares.at(i)
        celdas += (if type(p.at(0)) == str { raw(p.at(0)) } else { p.at(0) }, p.at(1))
      } else {
        celdas += ([], [])
      }
    }
  }
  set text(size: 9.5pt)
  table(
    columns: range(n).map(_ => (auto, 1fr)).flatten(),
    align: left + horizon,
    fill: (x, y) => if y == 0 { col.gris-claro } else if calc.odd(calc.div-euclid(x, 2)) { col.acento-claro.lighten(55%) } else { none },
    ..celdas,
  )
}

// Diálogo de un comunicado: filas (indicativo, texto).
#let _r4-dlg(..filas) = block(above: 0.8em, below: 0.5em, grid(
  columns: (auto, 1fr),
  column-gutter: 1em,
  row-gutter: 0.9em,
  ..filas.pos().map(f => (text(weight: "bold", raw(f.at(0))), f.at(1))).flatten(),
))

// Versalitas simuladas (Charter no tiene versalitas): para Mayday, Pan Pan y Sécurité.
#let _r4-sc(t) = {
  for c in t.clusters() {
    if lower(c) == c and upper(c) != c { text(size: 0.8em, upper(c)) } else { c }
  }
}

#figure(
  {
    set text(size: 10pt)
    table(
      columns: 3,
      align: left + horizon,
      fill: (x, y) => if y == 0 { col.gris-claro } else if x == 0 { col.acento-claro.lighten(55%) } else { none },
      inset: (x: 9pt, y: 5pt),
      [], [Radiotelefonía], [Radiotelegrafía],
      [*Socorro*], [#_r4-sc("Mayday") (tres veces)], [`SOS`],
      [*Urgencia*], [#_r4-sc("Pan Pan") (tres veces)], [`XXX` (tres veces)],
      [*Seguridad*], [#_r4-sc("Sécurité") (tres veces)], [`TTT` (tres veces)],
    )
  },
  kind: table,
  supplement: [Cuadro],
  caption: [Señales internacionales de socorro, urgencia y seguridad. La señal de socorro tiene prioridad absoluta sobre cualquier otro tráfico.],
) <r4-cuadro-senales>

#truco[Jerarquía de mayor a menor prioridad: #_r4-sc("Mayday") (peligro grave e inminente para vidas o embarcación) > #_r4-sc("Pan Pan") (urgencia sobre la seguridad, sin peligro inmediato) > #_r4-sc("Sécurité") (aviso a la navegación o meteorológico). El examen pregunta tanto las palabras como sus equivalentes telegráficos.]

Junto a las anteriores existe la *señal de alarma radiotelefónica*: dos tonos aproximadamente sinusoidales de 2200 y 1300 Hz transmitidos alternativamente, concebida para activar los dispositivos automáticos de escucha y anunciar que a continuación sigue un mensaje de socorro.

== Las señales en contexto <r4-sec-contexto>

Las tres señales encabezan siempre el mensaje y se repiten tres veces para que no puedan pasar inadvertidas. Los ejemplos siguientes siguen el formato habitual en radiotelefonía. Los indicativos y las situaciones son ficticios.

#ejemplo(titulo: [Socorro (#_r4-sc("Mayday")): peligro grave e inminente.])[
  #_r4-dlg(
    ("EA5KLM", [«#_r4-sc("Mayday"), #_r4-sc("Mayday"), #_r4-sc("Mayday"). Aquí EA5KLM, EA5KLM, EA5KLM. \ #_r4-sc("Mayday"), EA5KLM. Velero _Gaviota_, posición diez millas al este del cabo de la Nao. Vía de agua, nos hundimos. Necesitamos evacuación inmediata. Tres personas a bordo. Cambio.»]),
  )
  El mensaje lleva, por este orden, la señal de socorro (tres veces), la identificación, la _posición_, la _naturaleza del peligro_, la ayuda que se necesita y otros datos útiles. Después la estación queda a la escucha _en la misma frecuencia_.
]

#ejemplo(titulo: [Qué hace el radioaficionado que lo oye.])[
  EA4XYZ está en un `QSO` y escucha el #_r4-sc("Mayday") anterior.
  #_r4-dlg(
    ("EA4XYZ", [_(deja de transmitir de inmediato, se queda a la escucha y anota la hora, la frecuencia, la posición y el peligro)_]),
    ("EA4XYZ", [«#_r4-sc("Mayday") EA5KLM, aquí EA4XYZ. Recibido #_r4-sc("Mayday"). Aviso a emergencias. Cambio.»]),
    ("EA4XYZ", [_(llama al 112 o a Salvamento Marítimo, transmite los datos y sigue a la escucha sin ocupar la frecuencia)_]),
  )
  La conducta correcta es guardar silencio, escuchar y hacer lo posible para que el mensaje llegue a las autoridades (art. 30.5 de la Orden). Lo que _no_ debe hacer es seguir con su comunicado, aumentar la potencia ni repetir el #_r4-sc("Mayday") por todas las bandas.
]

#ejemplo(titulo: [Urgencia (#_r4-sc("Pan Pan")): situación seria sin peligro inminente.])[
  #_r4-dlg(
    ("EA7MNO", [«#_r4-sc("Pan Pan"), #_r4-sc("Pan Pan"), #_r4-sc("Pan Pan"). A todas las estaciones, aquí EA7MNO. Motor averiado a dos millas de la bocana de Almería. Sin peligro inmediato; solicitamos remolque. Cambio.»]),
  )
  No hay vidas en peligro inminente, pero hay un problema que afecta a la seguridad. En telegrafía el equivalente sería `XXX XXX XXX`.
]

#ejemplo(titulo: [Seguridad (#_r4-sc("Sécurité")): aviso a la navegación o meteorológico.])[
  #_r4-dlg(
    ("EA1DEF", [«#_r4-sc("Sécurité"), #_r4-sc("Sécurité"), #_r4-sc("Sécurité"). A todas las estaciones, aquí EA1DEF. Contenedor a la deriva a tres millas al norte de Cabo Peñas; peligro para la navegación. Fin.»]),
  )
  Se trata de un aviso para los demás, no de una petición de ayuda. En telegrafía es `TTT TTT TTT`.
]

#ojo[Ante la duda, pregúntate quién está en peligro y cuándo. Hay vidas en riesgo _ahora_: #_r4-sc("Mayday")/`SOS`. Hay un problema serio, pero no inmediato: #_r4-sc("Pan Pan")/`XXX`. Se avisa a otros de un riesgo: #_r4-sc("Sécurité")/`TTT`. Usar cualquiera de ellas sin motivo real es una infracción sancionable.]

#q("R4.1", "c",
  [La señal de socorro en radiotelefonía es:],
  ([Sécurité], [Pan Pan], [Mayday], [Alerta]),
  sol: [#_r4-sc("Mayday") (del francés _m’aider_): socorro en fonía, prioridad absoluta.],
)

#q("R4.2", "a",
  [La señal de urgencia en radiotelefonía consiste en la transmisión, repetida tres veces, de:],
  ([Pan Pan], [Mayday], [Sécurité], [SOS]),
  sol: [#_r4-sc("Pan Pan") tres veces: urgencia, sin peligro inmediato de vidas.],
)

#q("R4.3", "b",
  [La señal de seguridad en radiotelefonía se compone de:],
  ([la palabra «Mayday» repetida tres veces], [la palabra «Sécurité» repetida tres veces], [tres tonos largos de 1000 Hz], [la palabra «Seguridad» seguida del distintivo]),
  sol: [#_r4-sc("Sécurité") tres veces: avisos de seguridad (meteorológicos o a la navegación).],
)

#q("R4.4", "d",
  [Un mensaje de socorro NO incluirá:],
  ([la identificación de la estación en peligro], [la posición de la estación en peligro], [la naturaleza del peligro], [la señal de seguridad «Sécurité»]),
  sol: [El mensaje de socorro lleva identificación, posición y naturaleza del peligro; «Sécurité» es de otra categoría (tabla #ref(<r4-cuadro-senales>, supplement: none)).],
)

#q("R4.5", "b",
  [La abreviatura `XXX`, transmitida tres veces consecutivas, constituye la señal de:],
  ([socorro], [urgencia], [seguridad], [alarma]),
  sol: [`XXX` tres veces: urgencia telegráfica, equivalente a #_r4-sc("Pan Pan").],
)

#q("R4.6", "d",
  [La abreviatura `TTT`, transmitida tres veces consecutivas, constituye la señal de:],
  ([socorro], [urgencia], [alarma], [seguridad]),
  sol: [`TTT` tres veces: seguridad telegráfica, equivalente a #_r4-sc("Sécurité").],
)

#q("R4.7", "a",
  [La señal de socorro en radiotelegrafía es:],
  ([SOS], [XXX], [TTT], [CQD]),
  sol: [`SOS`: socorro en telegrafía; `CQD` es la señal antigua abandonada a principios del siglo XX.],
)

#q("R4.8", "c",
  [La señal de alarma en radiotelefonía consiste en dos tonos aproximadamente sinusoidales transmitidos alternativamente, de frecuencias:],
  ([500 Hz y 1000 Hz], [440 Hz y 880 Hz], [2200 Hz y 1300 Hz], [3000 Hz y 300 Hz]),
  sol: [La señal de alarma alterna tonos de 2200 y 1300 Hz para activar los receptores automáticos de guardia antes de un socorro.],
)

== Bandas atribuidas y comunicaciones de catástrofe <r4-sec-bandas>

El temario cierra con dos contenidos que el banco también evalúa. El primero, las *bandas atribuidas* al Servicio de Aficionados en España: van desde los 160 m en onda media-corta hasta las microondas (tabla #ref(<r4-cuadro-bandas>, supplement: none)). Unas se atribuyen con carácter _primario_ (uso preferente) y otras _secundario_ (sin causar interferencia a los servicios primarios ni reclamar protección frente a ellos). Las potencias máximas de cada banda están en la tabla #ref(<r4-cuadro-potencias>, supplement: none).

#figure(
  _r4-grupos((
    ([160 m], [1,8 MHz]),
    ([80 m], [3,5 MHz]),
    ([40 m], [7 MHz]),
    ([30 m], [10 MHz]),
    ([20 m], [14 MHz]),
    ([17 m], [18 MHz]),
    ([15 m], [21 MHz]),
    ([12 m], [24 MHz]),
    ([10 m], [28 MHz]),
    ([6 m], [50 MHz]),
    ([2 m], [144–146 MHz]),
    ([70 cm], [430–440 MHz]),
    ([23 cm], [1240–1300 MHz]),
    ([13 cm], [2300–2450 MHz]),
    ([6 cm], [5650–5850 MHz]),
  ), cab: ([Banda], [Frecuencia])),
  kind: table,
  supplement: [Cuadro],
  caption: [Principales bandas atribuidas al Servicio de Aficionados en España (Anexo I de la Orden IET/1311/2013). En HF suele darse la frecuencia nominal de la banda; los márgenes exactos los fija el CNAF. En 2300–2450 MHz, 5650–5850 MHz y 24,050–24,250 GHz se necesita autorización especial para _toda_ la banda, salvo las subbandas excluidas (2316–2332 MHz; 5700–5720 y 5760–5762 MHz; disposición adicional 2.ª).],
) <r4-cuadro-bandas>

Las *potencias máximas* de las emisiones (Anexo I, 3.1) se expresan en p.c.e. (potencia de cresta de la envolvente) hasta 440 MHz y en p.i.r.e. (potencia isótropa radiada equivalente: la entregada a la antena por su ganancia respecto a la isótropa) en 137 y 475 kHz y desde 23 cm:

#figure(
  {
    set text(size: 9.5pt)
    table(
      columns: (auto, auto),
      align: left + horizon,
      fill: (x, y) => if y == 0 { col.gris-claro } else { none },
      inset: (x: 8pt, y: 4.5pt),
      [Bandas], [Potencia máxima],
      [137 kHz (2200 m)], [1 W p.i.r.e.],
      [475 kHz (630 m)], [1 W p.i.r.e.; hasta 5 W a más de 800 km de la frontera de países africanos],
      [1,8 a 28 MHz (160, 80, 40, 30, 20, 17, 15, 12 y 10 m)], [1000 W p.c.e.],
      [50, 70 y 144–146 MHz (6, 4 y 2 m)], [600 W p.c.e.],
      [430–440 MHz (70 cm)], [300 W p.c.e.],
      [23 cm (1240–1300 MHz) y todas las superiores: 13 cm, 6 cm, 3 cm (10 GHz), 1,5 cm (24 GHz), 6 mm (47 GHz) y 75 a 250 GHz], [1000 W p.i.r.e.],
    )
  },
  kind: table,
  supplement: [Cuadro],
  caption: [Potencias máximas por banda (Anexo I, 3.1 de la Orden IET/1311/2013).],
) <r4-cuadro-potencias>

Tres reglas completan la tabla. En las bandas atribuidas con carácter _secundario_ la potencia máxima no supera el *50~%* de la indicada (3.2): así, 500 W p.c.e. en la de 30 m. Para enlaces por *rebote lunar (EME)* o por *dispersión meteórica (MS)*, dentro de las subbandas recomendadas por la IARU y siempre fuera de los cascos urbanos, se admiten hasta 1000 W p.c.e. (3.3). Y ninguna de estas potencias exime de reducirla cuanto haga falta para que la energía de radiofrecuencia sea inferior a 3,5 mW/cm#super[2] en los lugares a los que tengan acceso o por los que puedan transitar personas (3.5; es el valor literal de la Orden, que no debe confundirse con los niveles de referencia de exposición del RD 1066/2001).

El segundo es la *Resolución 640* del Reglamento de Radiocomunicaciones, que invitaba a las administraciones a prever el empleo de las bandas de aficionado en las comunicaciones de socorro cuando una *catástrofe natural* deja fuera de servicio las redes habituales. En esas circunstancias excepcionales los radioaficionados colaboran con la población afectada, y el tráfico en nombre de terceros —prohibido en condiciones ordinarias— se admite en caso de emergencia o desastre (art. 30.3 de la Orden IET/1311/2013; RR 25.3). Además, todo titular de una autorización está obligado a colaborar con sus medios radioeléctricos cuando lo requiera la Dirección General de Protección Civil y Emergencias (art. 30.4 de la Orden).

#nota[La Resolución 640 fue adoptada por la CAMR-79 y suprimida por la CMR-97; hoy la materia está en los números 25.3 y 25.9A del Reglamento de Radiocomunicaciones (este último, añadido por la CMR-03). Sobrevive, sin embargo, en el temario —el anexo II de la Orden la cita expresamente— y en los bancos de preguntas como pregunta histórica: conviene conocerla y responder como si siguiera en vigor.]

#q("R4.9", "b",
  [La banda de aficionado conocida como «banda de 20 metros» corresponde a una frecuencia próxima a:],
  ([3,5 MHz], [14 MHz], [50 MHz], [144 MHz]),
  sol: [$lambda = 20 "m" => f approx 300 slash 20 = 15 "MHz"$, y la banda se sitúa en 14 MHz (tabla #ref(<r4-cuadro-bandas>, supplement: none)). La regla $lambda approx 300 slash f$ del tema T1 resuelve estas equivalencias.],
)

#q("R4.10", "b",
  [La Resolución 640 del Reglamento de Radiocomunicaciones se refiere al empleo de las bandas de aficionado:],
  ([para radiodifusión comercial], [en comunicaciones de socorro en caso de catástrofes naturales], [exclusivamente en telegrafía], [para enlaces con satélites meteorológicos]),
  sol: [La Res. 640 (CAMR-79, suprimida por la CMR-97) invitaba a las administraciones a prever el uso de las bandas de aficionado en las comunicaciones de socorro cuando una catástrofe natural inutiliza las redes normales. Hoy lo recogen el número 25.9A del Reglamento de Radiocomunicaciones y, para el tráfico de terceros en emergencia o desastre, el 25.3 y el art. 30.3 de la Orden IET/1311/2013. Sigue figurando en el temario (anexo II, parte segunda, punto 4).],
)

#q("R4.11", "b",
  [Entre las tres señales, el orden de prioridad de menor a mayor es:],
  ([socorro, urgencia y seguridad], [seguridad, urgencia y socorro], [urgencia, seguridad y socorro], [las tres tienen la misma prioridad]),
  sol: [De menor a mayor: seguridad (_Sécurité_, avisos de navegación o meteorológicos), urgencia (_Pan Pan_, un problema serio sin peligro inminente) y socorro (_Mayday_, peligro grave e inminente). El socorro tiene prioridad absoluta sobre cualquier otra comunicación.],
)

#q("R4.12", "d",
  [Una estación de aficionado que escucha una llamada de socorro debe:],
  ([continuar su comunicación en la misma frecuencia], [aumentar su potencia para cubrir la zona], [repetir la llamada en todas las bandas que tenga disponibles], [guardar silencio, permanecer a la escucha y prestar auxilio si puede]),
  sol: [Lo primero es no estorbar: la frecuencia queda para quien está en peligro y para quien pueda auxiliarle. Después, si se está en condiciones de ayudar —o de retransmitir el mensaje a quien pueda— se hace: el art. 30.5 de la Orden obliga a hacer lo posible para que la comunicación de socorro llegue cuanto antes a la Dirección General de Protección Civil y Emergencias. Repetirlo a ciegas por todas las bandas solo multiplica la confusión.],
)

#q("R4.13", "a",
  [En caso de peligro grave e inminente, una estación de aficionado:],
  ([puede emplear cualquier medio y frecuencia a su alcance para pedir auxilio], [solo puede emitir en las frecuencias de su autorización], [debe esperar autorización expresa de la Administración], [debe limitarse a la banda de 20 metros]),
  sol: [Es una excepción reconocida por el Reglamento de Radiocomunicaciones: ante un peligro grave e inminente, la vida humana está por encima de los límites de la autorización. Fuera de ese supuesto, las frecuencias asignadas son las que son.],
)

#q("R4.14", "c",
  [Después de transmitir un mensaje de socorro, la estación debe:],
  ([apagar el equipo para no interferir], [cambiar inmediatamente de banda], [permanecer a la escucha en esa misma frecuencia], [repetirlo sin pausa hasta obtener respuesta]),
  sol: [De nada sirve pedir auxilio si nadie puede contestar. Se transmite y se escucha en la misma frecuencia, dejando huecos suficientes para que quien responda pueda hacerlo.],
)

#q("R4.15", "b",
  [La colaboración de los radioaficionados con los servicios de emergencia en caso de catástrofe:],
  ([es siempre voluntaria y no puede exigirse], [es obligatoria cuando la requiere la autoridad competente], [está prohibida salvo autorización previa por escrito], [solo se admite en la banda de 2 metros]),
  sol: [Una cosa es el espíritu de colaboración, que es voluntario, y otra el requerimiento formal de la autoridad competente en una emergencia: entonces la colaboración es exigible (art. 30.4 de la Orden: a requerimiento de la Dirección General de Protección Civil y Emergencias). Es una de las razones de ser del servicio de aficionados y de que se le reserve espectro.],
)

#q("R4.16", "b",
  [Emplear las señales de socorro «SOS» o «MAYDAY» sin que exista una situación de peligro constituye:],
  ([una práctica desaconsejada, pero sin consecuencias], [una infracción sancionable], [una conducta permitida a efectos de prueba], [una falta únicamente si se repite]),
  sol: [Las señales de socorro movilizan medios y silencian frecuencias: usarlas en falso está prohibido por la Constitución de la UIT (art. 47) y por el Reglamento de Radiocomunicaciones, es sancionable (la Ley 11/2022 no tiene un tipo específico para ello) y, si moviliza medios de socorro, puede llegar a ser delito (Código Penal, art. 561), además de gravemente irresponsable. Ni siquiera cabe «para probar el equipo».],
)
