#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

#tema("R2", "Código Q", alcance: [Grupos del código Q más utilizados en el Servicio de Aficionados y en el Servicio de Aficionados por Satélite.])

// Tabla de pares (código, significado) en n grupos de columnas, ordenada por columnas.
#let _r2-grupos(pares, n: 2, cab: ([Grupo], [Significado])) = {
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
#let _r2-dlg(..filas) = block(above: 0.8em, below: 0.5em, grid(
  columns: (auto, 1fr),
  column-gutter: 1em,
  row-gutter: 0.9em,
  ..filas.pos().map(f => (text(weight: "bold", raw(f.at(0))), f.at(1))).flatten(),
))

El código Q nació en la telegrafía para abreviar frases completas en tres letras. Cada grupo funciona como pregunta (con interrogación) o como afirmación. La tabla #ref(<r2-cuadro-grupos>, supplement: none) recoge los grupos que exige expresamente el temario; el banco de preguntas, sin embargo, echa mano de bastantes más, reunidos aparte en la tabla #ref(<r2-cuadro-otros>, supplement: none):

#figure(
  _r2-grupos((
    ("QRA", [nombre de la estación]),
    ("QRG", [frecuencia exacta]),
    ("QRH", [su frecuencia varía]),
    ("QRK", [inteligibilidad (legibilidad) de sus señales]),
    ("QRL", [la frecuencia está ocupada]),
    ("QRM", [interferencia producida por otras estaciones]),
    ("QRN", [parásitos atmosféricos]),
    ("QRO", [aumente la potencia]),
    ("QRP", [disminuya la potencia; emisión con baja potencia]),
    ("QRS", [transmita más despacio]),
    ("QRT", [cese la transmisión]),
    ("QRU", [no tengo nada para usted]),
    ("QRV", [estoy dispuesto (a la escucha)]),
    ("QRX", [espere; volveré a llamar más tarde]),
    ("QRZ", [¿quién me llama?]),
    ("QSB", [desvanecimiento de la señal (_fading_)]),
    ("QSL", [acuse de recibo]),
    ("QSO", [comunicado entre dos estaciones]),
    ("QSY", [cambie de frecuencia]),
    ("QTH", [mi posición es…]),
    ("QTR", [la hora exacta es…]),
  )),
  kind: table,
  supplement: [Cuadro],
  caption: [Grupos del código Q más frecuentes en el Servicio de Aficionados.],
) <r2-cuadro-grupos>

#truco[Parejas que el examen adora confundir: `QRM` es interferencia _humana_ (la M de _man-made_) y `QRN` es ruido de la _naturaleza_ (tormentas); `QRO` es potencia grande y `QRP` potencia _pequeña_ (la P de «poquito»); `QSL` confirma («recibido»), `QSO` es el contacto en sí.]

#figure(
  _r2-grupos((
    ("QSA", [fuerza (intensidad) de la señal]),
    ("QRQ", [transmita más deprisa]),
    ("QSP", [retransmitir gratuitamente a…]),
    ("QTC", [tengo mensajes para…]),
    ("QRB", [distancia entre estaciones]),
    ("QSK", [le oigo entre mis señales; trabajo en _break-in_]),
    ("QSM", [repita el último mensaje]),
    ("QSN", [le escuché en … kHz]),
    ("QSD", [su manipulación es defectuosa]),
    ("QSV", [transmita una serie de V]),
    ("QRI", [tono de su emisión]),
    ("QRW", [avise a … de que le llamo en …]),
    ("QTA", [anule el mensaje …]),
  )),
  kind: table,
  supplement: [Cuadro],
  caption: [Otros grupos que caen en el examen.],
) <r2-cuadro-otros>

== El código Q en contexto <r2-sec-contexto>

Memorizar la tabla es más fácil si se ve cómo suenan los grupos en un comunicado real. Los indicativos de estos ejemplos son ficticios. Fíjate en la doble forma de cada grupo: seguido de interrogación pregunta (`QRL?` = «¿está ocupada la frecuencia?») y sin ella afirma o responde (`QRL` = «está ocupada»).

#ejemplo(titulo: [Antes de llamar, en telegrafía (CW).])[
  Nunca se lanza una llamada sin comprobar que la frecuencia está libre.
  #_r2-dlg(
    ("EA4XYZ", [`QRL?`]),
    ("(otro)", [`QRL` _(ocupada: hay un_ `QSO` _en curso)_]),
    ("EA4XYZ", [_(sube unos kHz y vuelve a preguntar)_ `QRL?`]),
    ("EA4XYZ", [_(silencio: libre)_ `CQ CQ CQ DE EA4XYZ EA4XYZ K`]),
  )
]

#ejemplo(titulo: [Un comunicado completo en CW.])[
  Es el intercambio mínimo típico: señal, posición, nombre, confirmación y despedida.
  #_r2-dlg(
    ("EA1ABC", [`EA4XYZ DE EA1ABC`]),
    ("EA4XYZ", [`EA1ABC DE EA4XYZ GM UR RST 579 QTH MADRID NAME ANA HW? EA1ABC DE EA4XYZ K`]),
    ("EA1ABC", [`EA4XYZ DE EA1ABC QSL ANA UR RST 559 QSB QTH LEON NAME JUAN PSE QRS K`]),
    ("EA4XYZ", [`QSL JUAN TNX QSO QSL VIA BURO 73 EA1ABC DE EA4XYZ SK`]),
  )
  Lectura: Ana le pasa a Juan su control de señal, su `QTH` (Madrid) y su nombre. Juan acusa recibo (`QSL`), avisa de que la señal de Ana sufre desvanecimiento (`QSB`) y le pide que manipule más despacio (`QRS`). Ana se despide confirmando que enviará la tarjeta `QSL` por el buró.
]

#ejemplo(titulo: [En fonía (SSB), con problemas.])[
  En voz los grupos Q se dicen tal cual, mezclados con el español.
  #_r2-dlg(
    ("EA4XYZ", [«CQ, CQ, aquí EA4XYZ llamando y escuchando.»]),
    ("EA8YYY", [«EA4XYZ, aquí EA8YYY.»]),
    ("EA4XYZ", [«`QRZ`? Le copio muy débil, ¿quién me llama?»]),
    ("EA8YYY", [«EA8YYY, Eco Alfa Ocho Yankee Yankee Yankee, desde Tenerife.»]),
    ("EA4XYZ", [«`QSL`, Tenerife. Tengo mucho `QRM` de una estación cercana; ¿podemos hacer `QSY` a 7,120?»]),
    ("EA8YYY", [«`QSL`, `QSY` a 7,120. Nos vemos allí.»]),
  )
  Aquí `QRZ` se usa como pregunta («¿quién me llama?»), `QRM` es la interferencia de _otra estación_ (si fuese una tormenta sería `QRN`) y `QSY` propone el cambio de frecuencia.
]

#ejemplo(titulo: [Potencia, esperas y cierre.])[
  #_r2-dlg(
    ("EA1ABC", [«Le recibo con dificultad; ¿puede hacer `QRO`?»]),
    ("EA4XYZ", [«Lo siento, estoy en `QRP`, solo 5 vatios. Un momento, `QRX`, que llaman a la puerta…»]),
    ("EA4XYZ", [«Ya estoy. Se me hace tarde: le doy las gracias por el `QSO` y hago `QRT`. 73.»]),
  )
  `QRO` pide más potencia y `QRP` indica que se trabaja con baja potencia. `QRX` pide que la otra estación espere y `QRT` anuncia que se cesa de transmitir.
]

#nota[En la jerga de aficionado algunos grupos se han convertido en sustantivos: «mi `QTH`» (mi ubicación), «hicimos un `QSO`» (un comunicado), «te mando la `QSL`» (la tarjeta que confirma el contacto). El examen pregunta por el significado oficial, pero reconocer este uso ayuda a recordarlo.]

#q("R2.1", "a",
  [El grupo `QTH` significa:],
  ([mi posición es…], [¿quién me llama?], [cambie de frecuencia], [acuse de recibo]),
  sol: [`QTH`: «mi posición es…».],
)

#q("R2.2", "b",
  [El grupo `QRM` indica:],
  ([parásitos atmosféricos], [interferencia producida por otras estaciones], [desvanecimiento de la señal], [emisión con baja potencia]),
  sol: [`QRM`: interferencia de otras estaciones (origen humano); no confundir con `QRN`.],
)

#q("R2.3", "a",
  [El grupo `QRN` indica:],
  ([parásitos atmosféricos], [interferencia producida por otras estaciones], [ruido interno del receptor], [aumento de potencia]),
  sol: [`QRN`: parásitos atmosféricos, ruido natural (tormentas). La pareja QRM/QRN es de lo más preguntado.],
)

#q("R2.4", "c",
  [Para indicar a la estación corresponsal que cambie de frecuencia se emplea el grupo:],
  ([`QRT`], [`QRX`], [`QSY`], [`QSL`]),
  sol: [`QSY`: «cambie de frecuencia»; `QRT` es cesar y `QRX` esperar.],
)

#q("R2.5", "b",
  [El grupo `QRZ` significa:],
  ([llamada general a todas las estaciones], [¿quién me llama?], [mi nombre es…], [la frecuencia está ocupada]),
  sol: [`QRZ`: «¿quién me llama?»; la llamada general es `CQ`, que no es un grupo Q.],
)

#q("R2.6", "c",
  [El grupo `QSL` significa:],
  ([señal fuerte y clara], [espere], [acuse de recibo], [fin de la transmisión]),
  sol: [`QSL`: acuse de recibo — de ahí las tarjetas QSL.],
)

#q("R2.7", "b",
  [El grupo `QRP` significa:],
  ([aumente la potencia], [disminuya la potencia], [estación portátil], [transmita más despacio]),
  sol: [`QRP`: «disminuya la potencia»; por extensión, operar con baja potencia. Su opuesto es `QRO`.],
)

#q("R2.8", "d",
  [El grupo `QSO` designa:],
  ([el acuse de recibo de una tarjeta], [una interferencia intermitente], [un cambio de operador en la estación], [un comunicado entre dos estaciones]),
  sol: [`QSO`: comunicado entre dos estaciones.],
)

#q("R2.9", "a",
  [El grupo del código Q que indica que el operador volverá a llamar más tarde es:],
  ([`QRX`], [`QRT`], [`QSY`], [`QRK`]),
  sol: [`QRX`: «espere, volveré a llamar más tarde»; `QRK` pregunta por la inteligibilidad.],
)

#q("R2.10", "b",
  [El grupo del código Q que indica que debe aumentar la potencia es:],
  ([`QRP`], [`QRO`], [`QRM`], [`QSB`]),
  sol: [`QRO`: «aumente la potencia» (la pareja de `QRP`).],
)

#q("R2.11", "d",
  [El grupo `QRT` significa:],
  ([transmita más rápido], [espere un momento], [aumente la potencia], [cese la transmisión]),
  sol: [`QRT`: «cese la transmisión».],
)

#q("R2.12", "a",
  [El grupo del código Q que indica «su frecuencia varía» es:],
  ([`QRH`], [`QRG`], [`QSY`], [`QTR`]),
  sol: [`QRH`: «su frecuencia varía» (deriva). `QRG` pregunta por la frecuencia exacta: no confundirlas.],
)

#q("R2.13", "c",
  [El grupo `QSB` indica que la señal tiene:],
  ([interferencias de otras estaciones], [exceso de potencia], [desvanecimiento (_fading_)], [distorsión de audio]),
  sol: [`QSB`: desvanecimiento o _fading_ de la señal.],
)

#q("R2.14", "c",
  [El grupo `QSA` se refiere a:],
  ([la distancia que separa a las dos estaciones], [el tono de la señal recibida], [la intensidad con que se reciben las señales], [la hora exacta]),
  sol: [`QSA` se responde con una cifra de 1 a 5, de apenas perceptible a muy buena. Es la _intensidad_; la legibilidad es `QRK` y el tono, `QRI`.],
)

#q("R2.15", "a",
  [El grupo del código Q con el que se pide a la estación corresponsal que transmita más de prisa es:],
  ([`QRQ`], [`QRS`], [`QRO`], [`QRV`]),
  sol: [`QRQ` es «más de prisa» y `QRS`, «más despacio»: van en pareja y se confunden con facilidad. `QRO` es subir potencia y `QRV`, estar preparado.],
)

#q("R2.16", "d",
  [El grupo `QSP` significa:],
  ([aumente la potencia de emisión], [cambie a la frecuencia indicada], [su señal presenta desvanecimiento], [retransmitir gratuitamente a la estación indicada]),
  sol: [Es el grupo de la retransmisión de mensajes: «¿quiere retransmitir gratuitamente a …?». La gratuidad no es un detalle menor — el servicio de aficionados no puede tener fines lucrativos.],
)

#q("R2.17", "b",
  [El grupo `QTC` se emplea para indicar:],
  ([la potencia con que se transmite], [que se tienen mensajes para transmitir], [que se cesa la transmisión], [el emplazamiento de la estación]),
  sol: [«¿Cuántos mensajes tiene para transmitir?» o «tengo $n$ mensajes». Cesar la transmisión es `QRT` y el emplazamiento, `QTH`.],
)

#q("R2.18", "c",
  [El grupo `QRB` se refiere a:],
  ([el número de mensajes pendientes], [la banda de frecuencias empleada], [la distancia que separa a las dos estaciones], [la calidad del tono de la emisión]),
  sol: [«¿A qué distancia se encuentra de mi estación?». De ahí que en concursos y en VHF se hable del _QRB_ de un contacto para referirse a los kilómetros cubiertos.],
)

#q("R2.19", "a",
  [El grupo `QSK` indica que:],
  ([se puede oír al corresponsal entre las propias señales], [la frecuencia está ocupada], [se va a cerrar la estación], [las señales se reciben con interferencias]),
  sol: [Es la escucha entre impulsos de telegrafía, lo que en inglés se llama _full break-in_: permite que el corresponsal interrumpa sin esperar al final de la transmisión. La frecuencia ocupada es `QRL`.],
)

#q("R2.20", "d",
  [El grupo `QSM` se emplea para pedir que:],
  ([se reduzca la velocidad de transmisión], [se cambie de frecuencia], [se confirme la recepción por tarjeta], [se repita el último mensaje transmitido]),
  sol: [Reducir la velocidad es `QRS`, cambiar de frecuencia `QSY` y confirmar por tarjeta `QSL`.],
)

#q("R2.21", "b",
  [El grupo `QSN` se utiliza para preguntar:],
  ([cuántos mensajes quedan pendientes], [si se ha escuchado a una estación en una frecuencia determinada], [cuál es la hora exacta], [a qué distancia se encuentra la estación]),
  sol: [«¿Me ha oído usted, o ha oído a …, en … kHz?». Sirve para comprobar si una emisión llega a un punto concreto del que no se recibe respuesta directa.],
)

#q("R2.22", "c",
  [El grupo `QSD` indica que:],
  ([la estación va a cerrar], [se transmite con potencia reducida], [la manipulación es defectuosa], [existe desvanecimiento en la señal]),
  sol: [Avisa de que los puntos y rayas llegan mal formados — manipulador sucio, velocidad irregular o chasquidos. El desvanecimiento es `QSB`.],
)

#q("R2.23", "a",
  [El grupo `QSV` se emplea para pedir que se transmita:],
  ([una serie de letras V para ajustar la recepción], [el distintivo de llamada tres veces], [un mensaje de prueba de cinco palabras], [la señal de socorro]),
  sol: [La V en Morse (· · · −) es inconfundible y de ritmo muy marcado, ideal para ajustar la sintonía y el filtro del receptor.],
)

#q("R2.24", "d",
  [El grupo `QRI` se refiere a:],
  ([la intensidad de las señales], [la legibilidad de las señales], [la frecuencia exacta de la emisión], [el tono de la transmisión]),
  sol: [Los tres grupos de la valoración de una señal en telegrafía se reparten así: `QRK` legibilidad, `QSA` intensidad y `QRI` tono — los mismos conceptos que el informe RST.],
)

#q("R2.25", "b",
  [El grupo `QRW` se emplea para:],
  ([pedir que se aumente la velocidad de manipulación], [avisar a una tercera estación de que se la llama en una frecuencia], [preguntar por la posición de la estación], [indicar que se va a permanecer a la escucha]),
  sol: [«¿Quiere avisar a … de que le llamo en … kHz?». Se usa cuando no se consigue contacto directo y hay una estación intermedia que sí oye a las dos.],
)

#q("R2.26", "c",
  [El grupo `QTA` se utiliza para indicar que:],
  ([se cambia de antena], [se transmite en una frecuencia distinta], [se anule el mensaje indicado], [la estación queda a la escucha]),
  sol: [«Anule el mensaje número …». Sirve para retirar un mensaje ya transmitido que ha dejado de ser válido, algo especialmente importante en tráfico de emergencia.],
)

#q("R2.27", "b",
  [El grupo del código Q con el que una estación comunica su posición o localidad es:],
  ([`QTR`], [`QTH`], [`QRA`], [`QTC`]),
  sol: [`QTH` es el emplazamiento. `QTR` es la hora, `QRA` el nombre de la estación y `QTC` los mensajes pendientes: los cuatro se confunden con facilidad porque todos «informan» de algo.],
)

#q("R2.28", "d",
  [Para indicar que se están sufriendo interferencias producidas por otras estaciones se emplea el grupo:],
  ([`QRN`], [`QSB`], [`QRL`], [`QRM`]),
  sol: [`QRM` es la interferencia de origen humano — otras estaciones, equipos eléctricos—. La pareja con `QRN`, que es ruido natural, es de lo más preguntado del tema.],
)

#q("R2.29", "a",
  [Para indicar que se están sufriendo parásitos atmosféricos se emplea el grupo:],
  ([`QRN`], [`QRM`], [`QSB`], [`QRK`]),
  sol: [`QRN` son los parásitos atmosféricos: tormentas, estática. Regla para no confundirlos: la _N_ de _natural_ frente a la _M_ de _man made_.],
)

#q("R2.30", "c",
  [El grupo que se emplea para acusar recibo de una comunicación es:],
  ([`QSO`], [`QSY`], [`QSL`], [`QRZ`]),
  sol: [`QSL` es el acuse de recibo, y de ahí que la tarjeta que confirma un contacto se llame precisamente tarjeta QSL. `QSO` es el contacto en sí.],
)

#q("R2.31", "b",
  [El contacto establecido entre dos estaciones de aficionado se designa con el grupo:],
  ([`QSL`], [`QSO`], [`QTC`], [`QRV`]),
  sol: [`QSO` designa la comunicación establecida entre dos estaciones. Se usa como sustantivo —«hacer un `QSO`»— con toda naturalidad.],
)

#q("R2.32", "d",
  [Para pedir a la estación corresponsal que cese la transmisión se emplea el grupo:],
  ([`QRX`], [`QRV`], [`QSK`], [`QRT`]),
  sol: [`QRT` es cesar la transmisión. `QRX` es esperar y volver a llamar, que es distinto: uno cierra, el otro aplaza.],
)

#q("R2.33", "a",
  [Para indicar que se está dispuesto y preparado para recibir se emplea el grupo:],
  ([`QRV`], [`QRU`], [`QRX`], [`QRQ`]),
  sol: [`QRV` es «estoy dispuesto». `QRU` es «no tengo nada para usted», que se parece en la forma pero significa casi lo contrario.],
)

#q("R2.34", "c",
  [Para preguntar si la frecuencia está ocupada se emplea el grupo:],
  ([`QRG`], [`QSY`], [`QRL`], [`QRZ`]),
  sol: [`QRL?` es la pregunta obligada antes de ponerse a llamar en una frecuencia: puede estar ocupada por una estación que no oímos. `QRG` pregunta por la frecuencia exacta.],
)
