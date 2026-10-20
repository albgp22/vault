#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

#tema("R3", "Abreviaturas", alcance: [Abreviaturas más usuales en las comunicaciones de radioaficionados.])

// Tabla de pares (código, significado) en n grupos de columnas, ordenada por columnas.
#let _r3-grupos(pares, n: 2, cab: ([Grupo], [Significado])) = {
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
#let _r3-dlg(..filas) = block(above: 0.8em, below: 0.5em, grid(
  columns: (auto, 1fr),
  column-gutter: 1em,
  row-gutter: 0.9em,
  ..filas.pos().map(f => (text(weight: "bold", raw(f.at(0))), f.at(1))).flatten(),
))

Las abreviaturas de procedimiento son formas condensadas de palabras y frases de uso constante en los comunicados. Nacieron en la telegrafía, donde cada letra ahorrada es manipulación ahorrada en CW, pero hoy salpican también la fonía y hasta la conversación escrita entre radioaficionados.

#figure(
  _r3-grupos((
    ("CQ", [llamada general a todas las estaciones]),
    ("CL", [cierre de la estación]),
    ("CW", [onda continua; telegrafía en código Morse]),
    ("DX", [contacto de larga distancia]),
    ("RPT", [repita]),
    ("RST", [informe de señal: legibilidad, intensidad y tono]),
    ("SSB", [banda lateral única]),
    ("LSB", [banda lateral inferior]),
    ("USB", [banda lateral superior]),
    ("AR", [fin de la transmisión (telegrafía)]),
    ("SK", [fin del contacto (telegrafía)]),
    ("K", [invitación a transmitir («cambio»)]),
    ("BK", [interrupción breve (_break_)]),
    ("73", [saludos cordiales]),
    ("88", [besos (despedida afectuosa)]),
    ("OM", [_old man_: tratamiento entre radioaficionados]),
    ("YL", [_young lady_: operadora]),
    ("XYL", [esposa del radioaficionado]),
    ("RIG", [equipo de radio]),
  ), cab: ([Abrev.], [Significado])),
  kind: table,
  supplement: [Cuadro],
  caption: [Abreviaturas de procedimiento más habituales.],
) <r3-cuadro-proc>

#figure(
  _r3-grupos((
    ("DE", [de (indica quién llama)]),
    ("PSE", [por favor]),
    ("TNX/TKS", [gracias]),
    ("WX", [tiempo meteorológico]),
    ("UR", [su, sus]),
    ("R", [recibido]),
    ("ANT", [antena]),
    ("OP", [operador]),
    ("HR", [aquí]),
    ("ES", [y]),
    ("NIL", [nada para usted]),
    ("CFM", [confirmo]),
    ("AGN", [de nuevo]),
    ("ABT", [aproximadamente]),
    ("VY", [muy]),
    ("TU", [gracias]),
    ("HI", [risa (en CW)]),
    ("PWR", [potencia]),
    ("SRI", [lo siento]),
  ), cab: ([Abrev.], [Significado])),
  kind: table,
  supplement: [Cuadro],
  caption: [Otras abreviaturas frecuentes en el examen.],
) <r3-cuadro-otras>

== Las abreviaturas en contexto <r3-sec-contexto>

Un comunicado en telegrafía es, casi por entero, una cadena de abreviaturas y grupos Q (tema R2). Los ejemplos siguientes, con indicativos ficticios, muestran cada turno tal como se manipula y debajo su lectura en claro.

#ejemplo(titulo: [Llamada general y respuesta.])[
  #_r3-dlg(
    ("EA4XYZ", [`CQ CQ CQ DE EA4XYZ EA4XYZ PSE K` \ _Llamada general a todas las estaciones, de EA4XYZ; por favor, transmitan._]),
    ("EA1ABC", [`EA4XYZ DE EA1ABC EA1ABC AR` \ _A EA4XYZ, de EA1ABC. Fin de mi transmisión._]),
  )
  `DE` separa a quién se llama de quién llama. `K` invita a cualquiera a transmitir. `AR` cierra un mensaje concreto, pero no el contacto.
]

#ejemplo(titulo: [El intercambio de datos.])[
  #_r3-dlg(
    ("EA4XYZ", [`EA1ABC DE EA4XYZ GM OM TNX CALL UR RST 599 599 HR QTH MADRID OP ANA HW? AR EA1ABC DE EA4XYZ K` \ _Buenos días, compañero, gracias por la llamada. Su informe de señal es 599. Aquí, mi posición es Madrid y la operadora es Ana. ¿Qué tal me copia?_]),
    ("EA1ABC", [`R R ANA TNX FB RPRT UR RST 579 QTH LEON OP JUAN RIG IC-7300 PWR ABT 100W ANT DIPOLE WX SUNNY ES COLD HI EA4XYZ DE EA1ABC K` \ _Recibido, Ana, gracias por el buen informe. El suyo es 579, estoy en León y me llamo Juan. Mi equipo es un IC-7300 con unos 100 W y la antena es un dipolo. El tiempo es soleado y frío (risas)._]),
  )
  `UR` es «su», `HR` es «aquí», `ES` es «y», `ABT` es «aproximadamente» y `HI` es la risa en CW. En el `RST`, _579_ quiere decir legibilidad perfecta (5), señal bastante fuerte (7) y tono puro (9).
]

#ejemplo(titulo: [Repeticiones, interrupciones y despedida.])[
  #_r3-dlg(
    ("EA4XYZ", [`SRI JUAN QRM PSE RPT UR NAME AGN BK` \ _Lo siento, Juan, tengo interferencias. Por favor, repita su nombre otra vez. (Le paso el turno un momento.)_]),
    ("EA1ABC", [`BK NAME JUAN JUAN BK` \ _Nombre: Juan, Juan._]),
    ("EA4XYZ", [`R CFM JUAN VY TNX QSO 73 ES DX GL EA1ABC DE EA4XYZ SK` \ _Recibido, confirmo Juan. Muchas gracias por el comunicado; saludos y buena suerte con el DX._]),
    ("EA1ABC", [`TU 73 SK EA1ABC CL` \ _Gracias, saludos. Fin del contacto; cierro la estación._]),
  )
  `RPT` y `AGN` piden repetición. `BK` pasa el turno sin el ritual completo de indicativos. `SK` cierra el contacto y `CL` anuncia que la estación se apaga.
]

#ojo[Las tres «señales de turno» se confunden con facilidad. `K`: «adelante, transmita». `AR`: «fin de _esta_ transmisión». `SK`: «fin del _contacto_». Y no confundas `TU` («gracias») con `UR` («su»).]

#nota[Muchas abreviaturas se usan también en fonía y en la vida diaria del radioaficionado: «un 73» para despedirse, «la XYL» para la esposa, «hacer DX» para los contactos lejanos o «el rig» para el equipo. `88` (besos) se reserva para despedidas afectuosas, normalmente con una YL.]

#q("R3.1", "b",
  [La abreviatura `CQ` significa:],
  ([confirme la recepción], [llamada general a todas las estaciones], [cambio de frecuencia], [cierre de la estación]),
  sol: [`CQ`: llamada general a cualquier estación que escuche.],
)

#q("R3.2", "d",
  [Entre las abreviaturas más usuales se encuentra `CL`, que significa:],
  ([llamada local], [canal libre], [cambio de banda lateral], [cierre de la estación]),
  sol: [`CL` (_closing_): cierre de la estación.],
)

#q("R3.3", "a",
  [La abreviatura `RPT` significa:],
  ([repita], [reporte recibido], [repetidor activo], [recepción perfecta]),
  sol: [`RPT` (_repeat_): repita.],
)

#q("R3.4", "c",
  [La abreviatura `DX` designa:],
  ([una emisión digital experimental], [un duplexor de antena], [un contacto de larga distancia], [una estación desatendida]),
  sol: [`DX`: contacto de larga distancia.],
)

#q("R3.5", "b",
  [La abreviatura `USB` corresponde a:],
  ([una emisión de urgencia submarina], [la banda lateral superior], [la banda lateral inferior], [la doble banda lateral]),
  sol: [`USB`: banda lateral superior; `LSB`, la inferior. Convenio en HF: LSB por debajo de 10 MHz, USB por encima.],
)

#q("R3.6", "a",
  [La abreviatura `CW` se refiere a:],
  ([la telegrafía en código Morse (onda continua)], [la telefonía comercial], [una llamada de socorro], [la banda ciudadana]),
  sol: [`CW` (_continuous wave_): telegrafía en Morse.],
)

#q("R3.7", "d",
  [En telegrafía, la abreviatura de procedimiento empleada para finalizar una transmisión es:],
  ([`CQ`], [`SK9`], [`VA73`], [`AR`]),
  sol: [`AR` marca el fin de la transmisión; `K` invita a transmitir y `SK` cierra el contacto.],
)

#q("R3.8", "c",
  [El código RST se utiliza para:],
  ([solicitar un cambio de frecuencia], [identificar el distrito de la estación], [informar sobre la señal recibida (legibilidad, intensidad y tono)], [anunciar el cierre de la estación]),
  sol: [RST: legibilidad (1–5), intensidad (1–9) y tono (1–9, solo telegrafía); el «59» es el informe estándar de fonía.],
)

#q("R3.9", "a",
  [La abreviatura `OM` se emplea para referirse a:],
  ([el operador de la estación corresponsal], [un equipo de fabricación casera], [una emisión de onda media], [el operador de una estación repetidora]),
  sol: [Del inglés _old man_. Es el tratamiento cordial habitual entre radioaficionados varones, sin relación alguna con la edad. La versión femenina es `YL`.],
)

#q("R3.10", "c",
  [La abreviatura `YL` designa a:],
  ([una estación de baja potencia], [un enlace de larga distancia], [una operadora], [una licencia provisional]),
  sol: [De _young lady_. La baja potencia es `QRP` y la larga distancia, `DX`.],
)

#q("R3.11", "b",
  [La abreviatura `XYL` se refiere a:],
  ([una estación experimental], [la esposa del radioaficionado], [un distintivo caducado], [una antena de doble polarización]),
  sol: [De _ex-young lady_, con el humor de la vieja jerga radioeléctrica. Se emplea para la esposa, sea o no radioaficionada.],
)

#q("R3.12", "d",
  [En una comunicación, la abreviatura `DE` colocada antes de un distintivo indica:],
  ([que se solicita respuesta inmediata], [que la estación va a cerrar], [el nombre del operador], [que a continuación viene el distintivo de quien transmite]),
  sol: [Es literalmente la preposición «de»: en «`EA4XYZ` de `EA1ABC`», quien llama es la segunda. Marca quién habla, y por eso va siempre delante del propio distintivo.],
)

#q("R3.13", "a",
  [En telegrafía, la abreviatura de procedimiento `K` significa:],
  ([invitación a transmitir a la estación corresponsal], [fin definitivo de la comunicación], [petición de repetición del mensaje], [cierre de la estación]),
  sol: [Es el «cambio» de la telegrafía: he terminado, hable usted. No debe confundirse con `SK`, que cierra el contacto entero, ni con `CL`, que cierra la estación.],
)

#q("R3.14", "c",
  [La abreviatura de procedimiento `SK` indica:],
  ([que se transmite en banda lateral], [que se solicita una tarjeta de confirmación], [el final del contacto entre las dos estaciones], [que la señal se recibe con interferencias]),
  sol: [Cierra la comunicación: ya no se espera respuesta. Si además se apaga la estación, se añade `CL`.],
)

#q("R3.15", "b",
  [La abreviatura `BK` se emplea para:],
  ([indicar que se cambia de banda], [interrumpir brevemente la transmisión del corresponsal], [pedir que se repita la última palabra], [señalar el comienzo de una llamada general]),
  sol: [Del inglés _break_. Permite cortar sin esperar al final, algo que en telegrafía facilita el `QSK`. El comienzo de una llamada general es `CQ`.],
)

#q("R3.16", "d",
  [La abreviatura `73` significa:],
  ([el número de contactos realizados], [la potencia empleada, en vatios], [la banda de trabajo, en metros], [saludos cordiales]),
  sol: [Viene de los antiguos códigos telegráficos numéricos y ha sobrevivido como la despedida universal del radioaficionado. Se dice «73», no «setenta y tres saludos».],
)

#q("R3.17", "a",
  [La abreviatura `88` se emplea para expresar:],
  ([besos, en despedidas de cortesía], [una señal muy intensa], [la petición de repetir el mensaje], [una comunicación de emergencia]),
  sol: [Del mismo origen numérico que el `73`, y con el mismo tono cordial. Por costumbre se reserva para despedidas entre personas con cierta confianza.],
)

#q("R3.18", "c",
  [La abreviatura `PSE` corresponde a:],
  ([potencia de salida efectiva], [pausa entre transmisiones], [por favor], [posición estimada]),
  sol: [Contracción del inglés _please_. Es una de las abreviaturas de cortesía que, junto con `TNX`, aparecen constantemente en telegrafía.],
)

#q("R3.19", "b",
  [La abreviatura `TNX` (o `TKS`) significa:],
  ([transmisión no cifrada], [gracias], [cambio de frecuencia], [transmisor en pruebas]),
  sol: [Contracción de _thanks_. El cambio de frecuencia es `QSY`.],
)

#q("R3.20", "d",
  [En una comunicación, la abreviatura `WX` se refiere a:],
  ([la potencia de la estación], [la longitud de onda empleada], [el tipo de antena instalada], [las condiciones meteorológicas]),
  sol: [De _weather_. Es uno de los asuntos clásicos de conversación en un contacto, junto con el equipo (`RIG`) y el informe de señal.],
)

#q("R3.21", "a",
  [La abreviatura `UR` corresponde a:],
  ([el posesivo «su», referido al corresponsal], [una emisión de urgencia], [una estación no identificada], [la banda de UHF]),
  sol: [Contracción de _your_, escrita tal como suena. Aparece continuamente en expresiones como «`UR RST` 599».],
)

#q("R3.22", "c",
  [En telegrafía, la abreviatura `R` transmitida como respuesta significa:],
  ([repita el mensaje], [reduzca la potencia], [recibido conforme], [la estación está en reparación]),
  sol: [Del inglés _roger_: he recibido y entendido lo transmitido. Pedir repetición es `RPT` y reducir potencia, `QRP`.],
)

#q("R3.23", "c",
  [La abreviatura `SSB` corresponde a:],
  ([una emisión de doble banda lateral], [una señal de socorro], [la banda lateral única], [un sistema de sintonía automática]),
  sol: [De _single side band_. Es el modo de fonía por excelencia en HF, porque suprime la portadora y una banda lateral y concentra toda la potencia en la información.],
)

#q("R3.24", "a",
  [La abreviatura `LSB` designa:],
  ([la banda lateral inferior], [la banda lateral superior], [un limitador de señal], [una emisión de baja potencia]),
  sol: [De _lower side band_. Se emplea por costumbre en 160, 80 y 40 metros; de 20 metros hacia arriba se usa `USB`. Es una convención, no una obligación técnica.],
)

#q("R3.25", "d",
  [La abreviatura `RIG` se refiere a:],
  ([la relación de ondas estacionarias], [el indicativo de la estación], [la ganancia de la antena], [el equipo de radio de la estación]),
  sol: [Es la jerga habitual para el transceptor y, por extensión, para el conjunto de la estación: «mi `RIG` es un…» es de las frases más repetidas en un contacto.],
)

#q("R3.26", "b",
  [La abreviatura `ANT` significa:],
  ([anterior], [antena], [antes del mediodía], [anotación]),
  sol: [Contracción de _antenna_. Junto con `RIG` y `PWR` forma el trío con que se describe la estación al corresponsal.],
)

#q("R3.27", "c",
  [La abreviatura `OP` se refiere a:],
  ([la potencia de salida], [la frecuencia de operación], [el operador de la estación], [la opción de modo]),
  sol: [De _operator_: la persona que está a los mandos, que no siempre coincide con el titular de la estación. Se usa para presentarse: «`OP` Alberto».],
)

#q("R3.28", "a",
  [La abreviatura `HR` significa:],
  ([aquí], [hora], [horizontal], [he recibido]),
  sol: [Contracción de _here_: «aquí», referido al lugar desde donde se transmite. Aparece constantemente en expresiones como «`WX HR VY GUD`».],
)

#q("R3.29", "d",
  [La abreviatura `ES` se emplea con el significado de:],
  ([España], [estación], [eso es], [y]),
  sol: [Es la conjunción «y», tomada del signo telegráfico correspondiente. Ahorra caracteres en telegrafía, que es de lo que se trata.],
)

#q("R3.30", "b",
  [La abreviatura `NIL` significa:],
  ([nivel de señal], [nada, sin novedad], [nueva llamada], [no identificado]),
  sol: [Del latín _nihil_ a través del inglés: nada que transmitir, sin novedad. Se emplea para cerrar un tráfico de mensajes cuando no queda ninguno.],
)

#q("R3.31", "c",
  [La abreviatura `CFM` significa:],
  ([cambio de frecuencia], [conforme al manual], [confirmo], [cierro comunicación]),
  sol: [Contracción de _confirm_: doy por buena la información recibida. Es lo que se transmite al aceptar un informe de señal o un dato del corresponsal.],
)

#q("R3.32", "a",
  [La abreviatura `AGN` significa:],
  ([de nuevo, otra vez], [agenda de contactos], [antena general], [a la ganancia máxima]),
  sol: [Contracción de _again_. Se usa para pedir repetición de forma abreviada, sola o junto a `PSE`: «`PSE AGN`».],
)

#q("R3.33", "d",
  [La abreviatura `ABT` significa:],
  ([abierto], [a bordo], [abandono la transmisión], [aproximadamente]),
  sol: [Contracción de _about_. Sirve para dar un dato aproximado, como la distancia o la potencia, sin comprometerse con una cifra exacta.],
)

#q("R3.34", "b",
  [La abreviatura `VY` se emplea con el significado de:],
  ([vertical], [muy], [voy], [visibilidad]),
  sol: [Contracción de _very_. Casi siempre va delante de un adjetivo: «`VY GUD`», muy bien; «`VY` 73», saludos muy cordiales.],
)

#q("R3.35", "c",
  [La abreviatura `TU` se emplea para expresar:],
  ([turno de palabra], [transmisión urgente], [gracias], [tono uniforme]),
  sol: [De _thank you_. Es la forma más corta de dar las gracias, aún más breve que `TNX`, y se emplea mucho al cerrar un contacto rápido de concurso.],
)

#q("R3.36", "a",
  [La abreviatura `HI` se emplea en telegrafía para expresar:],
  ([una risa], [un saludo inicial], [alta frecuencia], [una petición de repetición]),
  sol: [Es la forma de reírse en telegrafía: se transmite tal cual y el corresponsal lo entiende como una risa. Un rasgo de la vieja cultura telegráfica que ha sobrevivido intacto.],
)

#q("R3.37", "d",
  [La abreviatura `PWR` se refiere a:],
  ([la propagación], [el prefijo del distintivo], [el periodo de la señal], [la potencia]),
  sol: [Contracción de _power_: la potencia con que se transmite, dato habitual al describir la estación junto con el equipo y la antena.],
)

#q("R3.38", "b",
  [La abreviatura `SRI` se emplea para expresar:],
  ([señal recibida intermitente], [lo siento], [servicio de radio internacional], [sin respuesta inmediata]),
  sol: [Contracción de _sorry_. Se emplea para disculparse, por ejemplo al no poder completar un contacto o al haber interrumpido a otra estación.],
)
