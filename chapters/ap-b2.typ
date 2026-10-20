// Apéndice B (continuación): preguntas complementarias B.11–B.19
// Temas R1–R9 y preguntas heredadas del régimen anterior (C-H).
// Modo FIEL: transcripción de las preguntas del apéndice B y de las
// soluciones razonadas de D.20 (páginas PDF 244–263 y 400–424).
// El apéndice B lo abre ap-b1.typ; este archivo continúa con la sección B.11.
#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// ---- única ayuda local (prefijo _apb2-): párrafo «CLAVE DE LOS BANCOS PÚBLICOS» de D.20
// (#no-esta y #vease vienen de la plantilla)
#let _apb2-clave(cuerpo) = clave-bancos(cuerpo)


== Tema R1. Alfabeto fonético internacional

#q("C-R1.1", "c",
  [El deletreo del distintivo AN6BL según el alfabeto fonético internacional:],
  ([Alfa, Noviembre, Seis, Bravo, Lima.], [A, Ene, Seis, B, Ele.], [Alfa, November, Six, Bravo, Lima.], [El deletreo de distintivos no está permitido.]),
  sol: [Cada letra se deletrea con su palabra internacional (A = Alfa, N = November, B = Bravo, L = Lima) y la cifra con su nombre inglés: 6 = Six. La a pone en español «Noviembre» y «Seis», que no pertenecen al alfabeto internacional; la b usa los nombres españoles de las letras (Ene, Ele) en lugar de palabras de deletreo. La d es falsa: deletrear el distintivo es lo normal, y el propio temario oficial incluye el alfabeto fonético para deletrear letras y cifras. Aunque al hablar se oigan cifras en español, el deletreo internacional las da en inglés. #vease[(Véase tema R1, tabla del alfabeto y nota sobre las cifras.)]],
)

#q("C-R1.2", "b",
  [El deletreo del indicativo EA5SWJ de acuerdo con el alfabeto fonético internacional sería:],
  ([Echo Alfa Cinco Sierra Whiskey Juliet.], [Echo Alfa Five Sierra Whiskey Juliett.], [Echo Alfa Five Sierra Whiskey Japón.], [Echo América Five Sierra Whiskey Juliet.]),
  sol: [E = Echo, A = Alfa, 5 = Five, S = Sierra, W = Whiskey, J = Juliett: la b es la única formada solo por palabras del alfabeto internacional, con la cifra en inglés. La a da la cifra en español (Cinco); la c sustituye Juliett por «Japón», que no pertenece al alfabeto; la d dice «América» para la A, que es Alfa. Recuerda la grafía oficial: Alfa, con f, y Juliett, con doble t. #vease[(Véase tema R1, tabla del alfabeto y nota sobre las cifras.)]],
)

#q("C-R1.3", "a",
  [El deletreo del distintivo EA3RCQ según el alfabeto fonético internacional:],
  ([Echo, Alfa, Three, Romeo, Charlie, Quebec.], [El deletreo de distintivos no está permitido.], [Echo, Alfa, Tres, Romeo, Charlie, Quebec.], [E, A, Tres, R, C, Q.]),
  sol: [E = Echo, A = Alfa, 3 = Three, R = Romeo, C = Charlie, Q = Quebec. Las opciones a y c solo se distinguen en la cifra: el deletreo internacional da las cifras por su nombre inglés (Three), no en español (Tres). La d se limita a nombrar las letras sin palabras de deletreo, justo lo que el alfabeto fonético pretende evitar, porque una letra suelta se confunde con facilidad. La b es falsa: deletrear el distintivo es práctica habitual y forma parte del temario. #vease[(Véase tema R1, tabla del alfabeto y nota sobre las cifras.)]],
)

== Tema R2. Código Q

#q("C-R2.1", "c",
  [¿Qué abreviatura del código Q se refiere a la inteligibilidad de las señales?],
  ([QRL], [QRM], [QRK], [QRA]),
  sol: [QRK es el grupo de la inteligibilidad (legibilidad) de las señales: «¿cuál es la inteligibilidad de mis señales?» o, como respuesta, «la inteligibilidad de sus señales es…», en una escala de 1 a 5. Es la «R» del informe RST. No lo confundas con QSA (fuerza de la señal) ni con QRI (tono). Los distractores son otros grupos: QRL (ocupado), QRM (interferencia de otras estaciones) y QRA (nombre de la estación). La pregunta también cae a la inversa: «QRK significa…» se responde «inteligibilidad de las señales». #vease[(Véase tema R2, tabla «Grupos del código Q más frecuentes».)]],
)

#q("C-R2.2", "c",
  [¿Qué abreviatura indica que el operador está ocupado?],
  ([QRF], [QTI], [QRL], [QSJ]),
  sol: [QRL significa «estoy ocupado; no interfiera» y, en forma de pregunta (QRL?), «¿está usted ocupado?» o «¿está ocupada la frecuencia?». Los demás grupos no tienen relación: QRF es «¿regresa usted a…?», QTI se refiere a la derrota (rumbo) verdadera y QSJ a la tasa por palabra en el tráfico de telegramas. #vease[(Véase tema R2, tabla «Grupos del código Q más frecuentes» (QRL como «frecuencia ocupada»).)]

    #no-esta[El cuaderno da QRL como «la frecuencia está ocupada», que es su uso habitual antes de llamar: se pregunta «QRL?» y, si alguien contesta, se espera. La definición internacional es más amplia: QRL? es «¿está usted ocupado?» y QRL es «estoy ocupado; ruego no interferir». El examen lo pregunta con cualquiera de los dos matices, y la clave es siempre QRL. Mnemotecnia: QRL = «línea ocupada».]],
)

#q("C-R2.3", "d",
  [¿Qué abreviatura indica que se transmita más lentamente?],
  ([QTR], [QTH], [QSJ], [QRS]),
  sol: [QRS es «transmita más despacio» (o «¿debo transmitir más despacio?»); la S es de #emph[slow]. Su opuesto es QRQ, «transmita más deprisa» (la Q de #emph[quick]). Los distractores son otros grupos: QTR es la hora exacta, QTH la posición o localidad y QSJ la tasa por palabra. La pregunta también cae a la inversa («QRS significa…»), donde otros distractores típicos son QSB (las señales se desvanecen) y QRZ (está siendo llamado por…). #vease[(Véase tema R2, tablas de grupos del código Q (QRS en la primera, QRQ en la segunda).)]],
)

#q("C-R2.4", "d",
  [La abreviatura QRA indica:],
  ([¿Qué frecuencia utiliza Vd.?], [¿Está Vd. ocupado?], [¿Transmito más despacio?], [¿Cómo se llama su estación?]),
  sol: [QRA se refiere al nombre de la estación: «¿cómo se llama su estación?» o «el nombre de mi estación es…». No es la posición (eso es QTH). Los distractores son otros grupos en forma de pregunta: la frecuencia es QRG, «¿está ocupado?» es QRL y «¿transmito más despacio?» es QRS. #vease[(Véase tema R2, tabla «Grupos del código Q más frecuentes».)]],
)

#q("C-R2.5", "b",
  [La abreviatura del código Q «QRG» tiene el significado de:],
  ([Cese la transmisión], [Su frecuencia exacta es… kHz], [Aumente la potencia], [Estoy ocupado. No interfiera]),
  sol: [QRG es la frecuencia exacta: «su frecuencia exacta es… kHz» y, con interrogación, «¿cuál es la frecuencia exacta de mi emisión?» (QRG?). Los distractores son otros grupos: «cese la transmisión» es QRT, «aumente la potencia» es QRO y «estoy ocupado, no interfiera» es QRL. Tampoco es QSY (cambie de frecuencia), QSB (las señales se desvanecen) ni QTR (la hora). #vease[(Véase tema R2, tabla «Grupos del código Q más frecuentes».)]],
)

== Tema R3. Abreviaturas

#q("C-R3.1", "d",
  [La abreviatura FB significa:],
  ([Hasta luego.], [Frecuencia.], [Oficina.], [Buen trabajo, formidable.]),
  sol: [FB viene del inglés #emph[fine business] y se emplea con el sentido de «buen trabajo», «formidable», «excelente»: se aplica a una señal, a un equipo o a un contacto. «Hasta luego» se abrevia CUL (#emph[see you later]). «Frecuencia» y «oficina» no son significados de FB.

    #no-esta[FB (del inglés #emph[fine business]) es una abreviatura de elogio: «buen trabajo», «formidable», «excelente». Se oye en expresiones como «FB señal» o «FB QSO». No figura en las tablas del cuaderno. Conviene distinguirla de otras abreviaturas de cortesía: CUL (#emph[see you later]) es «hasta luego», TNX es «gracias» y 73 son «saludos cordiales».]],
)

#q("C-R3.2", "d",
  [Es una abreviatura operacional y significa manipulador semiautomático:],
  ([PLUG], [TXT], [CUL], [BUG]),
  sol: [BUG designa el manipulador semiautomático: una llave telegráfica mecánica que fabrica sola los puntos y deja las rayas a mano del operador. Los distractores no encajan: CUL es «hasta luego» (#emph[see you later]), TXT es «texto» y PLUG (enchufe) no es una abreviatura operacional.

    #no-esta[Un #emph[bug] (la marca clásica es Vibroplex) es un manipulador semiautomático: al empujar la paleta hacia un lado, un mecanismo de péndulo genera automáticamente una serie de puntos, mientras que las rayas se hacen a mano empujando hacia el otro lado. No es el manipulador vertical (la llave simple de subir y bajar) ni el #emph[keyer] electrónico, que genera automáticamente tanto los puntos como las rayas. La abreviatura no figura en las tablas del cuaderno.]],
)

#q("C-R3.3", "d",
  [Significa «buenos días» utilizando una abreviatura operacional:],
  ([GA], [BD], [GD], [GM]),
  sol: [GM viene del inglés #emph[good morning]: buenos días. GA no es un saludo matutino: en el material del examen significa «adelante» (#emph[go ahead]). BD y GD no son abreviaturas operacionales.

    #no-esta[Los saludos horarios se abrevian con las iniciales de la expresión inglesa: GM (#emph[good morning], buenos días), GE (#emph[good evening], buenas tardes) y GN (#emph[good night], buenas noches). La regla es la G de #emph[good] más la inicial de la parte del día. No figuran en las tablas del cuaderno.]],
)

#q("C-R3.4", "c",
  [Si se utiliza una abreviatura operacional, NR significa:],
  ([Receptor.], [No hay respuesta.], [Número.], [Corte de transmisión.]),
  sol: [NR es la abreviatura de #emph[number]: «número» (de orden, de serie o de mensaje). Los distractores corresponden a otras abreviaturas: «receptor» es RX y «corte de transmisión» es BK; «no hay respuesta» no corresponde a ninguna abreviatura operacional.

    #no-esta[NR (del inglés #emph[number]) significa «número»: se usa, por ejemplo, para dar el número de orden de un mensaje o el número de serie que se intercambia en un concurso. Sigue el mismo patrón de recorte que RX (receptor) y TX (transmisor): las consonantes de la palabra inglesa. No figura en las tablas del cuaderno.]],
)

#q("C-R3.5", "b",
  [En telegrafía, la abreviatura operacional «MSG» significa:],
  ([Gracias], [Mensaje], [Amigo], [Señal]),
  sol: [MSG es la abreviatura de #emph[message]: «mensaje». Las demás respuestas corresponden a otras abreviaturas: «gracias» es TNX o TKS, «amigo» (#emph[old man]) es OM y «señal» es SIG.

    #no-esta[MSG (del inglés #emph[message]) significa «mensaje», el texto que se envía en el tráfico de mensajes. No lo confundas con el grupo Q QTC («tengo mensajes para usted»). Muchas abreviaturas son la palabra inglesa sin vocales: MSG (#emph[message]), SIG (#emph[signal]), PWR (#emph[power]). No figura en las tablas del cuaderno.]],
)

#q("C-R3.6", "c",
  [La abreviatura operacional utilizada en telegrafía para decir «buenas tardes» es:],
  ([BK], [ES], [GE], [BUG]),
  sol: [GE procede de #emph[good evening]: buenas tardes (y noches). Los distractores son otras abreviaturas: BK es «corte de transmisión» (#emph[break]), ES es «y» (#emph[and]) y BUG es el manipulador semiautomático.

    #no-esta[GE es la abreviatura de #emph[good evening]: «buenas tardes». Junto a GM (#emph[good morning], buenos días) y GN (#emph[good night], buenas noches) forma el trío de saludos horarios: la G de #emph[good] más la inicial de la parte del día. En el material del examen, GA significa «adelante» (#emph[go ahead]). No figuran en las tablas del cuaderno.]],
)

#q("C-R3.7", "d",
  [¿Qué significa que una estación DX trabaja en «Split»?],
  ([Que está operando en un país lejano y de categoría especial.], [Que utiliza una modalidad digital moderna llamada «Split».], [Que emite en doble banda lateral única.], [Que emite en una frecuencia, pero recibe en otra diferente.]),
  sol: [Trabajar en #emph[split] es transmitir en una frecuencia y escuchar en otra. Lo hace la estación DX cuando tiene una avalancha de llamadas (#emph[pile-up]): si escuchara en su propia frecuencia de emisión, las llamadas se pisarían y no distinguiría a nadie. Anuncia, por ejemplo, «escucho arriba 5 kHz» y cada corresponsal llama en un punto distinto de la banda. Las demás opciones mezclan conceptos ajenos: «#emph[split]» no es un país, ni una modalidad digital, ni una clase de emisión con bandas laterales.

    #no-esta[#emph[Split]: modo de operación con frecuencia de transmisión distinta de la de recepción. Se usa sobre todo en DX y concursos para repartir las llamadas de un #emph[pile-up] (muchas estaciones llamando a la vez a una sola). El DX indica dónde escucha («#emph[up 5]» es 5 kHz por encima de su frecuencia de emisión) y tú ajustas el transceptor con los dos VFO: recibes en la frecuencia del DX y transmites en la de escucha. Es una técnica operativa, no una modalidad de emisión ni una categoría de estación.]],
)

#q("C-R3.8", "a",
  [¿Qué es «locator»?],
  ([Una forma muy rápida de indicar la ubicación de una estación.], [Una propagación que te permite escuchar tu propio eco.], [Un radiogoniómetro.], [La forma de indicar la altura de tu antena.]),
  sol: [El #emph[locator] (localizador Maidenhead o #emph[QTH locator]) es un código de seis caracteres que identifica una cuadrícula del globo y permite dar la ubicación de una estación de forma breve e inequívoca, p. ej. IN80dk (Madrid). Se usa sobre todo en VHF/UHF y en concursos, donde interesa la distancia entre estaciones. No es un tipo de propagación, ni un radiogoniómetro (el aparato que determina la dirección de una señal), ni indica la altura de la antena.

    #no-esta[El sistema Maidenhead divide el globo en 18 × 18 campos (letras A–R; cada uno de 20° de longitud por 10° de latitud), cada campo en 10 × 10 cuadrados (cifras 0–9; 2° por 1°) y cada cuadrado en 24 × 24 subcuadrados (letras a–x; 5 por 2,5 minutos de arco). Se escribe: dos letras, dos cifras y dos letras (p. ej. IM99jn). Con cuatro caracteres se sitúa la estación en un cuadrado de unos 100 a 200 km de lado; con seis, en unos pocos kilómetros.]],
)

== Tema R4. Señales de socorro, urgencia y seguridad

#q("C-R4.1", "a",
  [La llamada de socorro en radiotelefonía se compone de:],
  ([«MAYDAY» (tres veces), la palabra «AQUÍ» o «DE» y el distintivo de llamada (tres veces).], [«AQUÍ» o «DE», el distintivo de llamada (tres veces) y la palabra «MAYDAY» (tres veces).], [Únicamente «MAYDAY» (tres veces).], [«MAYDAY» (una vez), la palabra «AQUÍ» o «DE» y el distintivo de llamada (tres veces).]),
  sol: [La llamada de socorro en radiotelefonía lleva tres partes, en este orden: la palabra «Mayday» repetida tres veces, la palabra «aquí» o «de» y el distintivo de la estación en peligro, también tres veces. Por ejemplo: «Mayday, Mayday, Mayday, aquí EA4XYZ, EA4XYZ, EA4XYZ». Falla la opción con el orden invertido (primero debe oírse que es socorro), la que solo dice «Mayday» (incompleta) y la que lo dice una vez. Tampoco vale «help»: la palabra internacional de socorro es solo «Mayday». A la llamada sigue el mensaje de socorro. #vease[(Véase tema R4, tabla «Señales internacionales de socorro, urgencia y seguridad».)]

    #no-esta[El cuaderno da la palabra «Mayday» (tres veces), pero no la estructura completa de la llamada. Según el Reglamento de Radiocomunicaciones de la UIT (Apéndice 13), la llamada de socorro en radiotelefonía consta de: 1) «Mayday» tres veces; 2) «aquí» (en inglés #emph[this is]) o «de»; 3) el distintivo de la estación en peligro, tres veces. Después va el mensaje de socorro: identificación, posición, naturaleza del peligro y ayuda que se necesita. Regla: tres veces la palabra, tres veces el distintivo.]],
)

#q("C-R4.2", "b",
  [La señal radiotelegráfica de socorro consiste en:],
  ([La palabra «Mayday»], [La abreviatura «SOS» transmitida como un solo signo], [La palabra «HELP»], [La abreviatura «S.O.S.» transmitida separando las tres letras]),
  sol: [La señal radiotelegráfica de socorro es el grupo SOS, que en Morse son tres puntos, tres rayas y tres puntos enviados seguidos, sin pausa entre letras: una sola señal, con las rayas algo alargadas para distinguirlas de los puntos. Por eso es correcta la b. La clave publicada en el banco marca la d, pero separar las tres letras contradice la norma internacional: en ese caso ya no sería el signo de socorro. «Mayday» es la señal radiotelefónica y «help» no es una señal reglamentaria. #vease[(Véase tema R4, tabla «Señales internacionales de socorro, urgencia y seguridad».)]

    #no-esta[El cuaderno dice que la señal de socorro en telegrafía es SOS, pero falta el detalle de cómo se envía. Según el Reglamento de Radiocomunicaciones de la UIT, es un único signo Morse: tres puntos, tres rayas y tres puntos transmitidos seguidos, sin los espacios que separarían las letras S, O y S, y con las rayas ligeramente alargadas para distinguirlas de los puntos. No son las siglas de ninguna frase: es solo una secuencia fácil de reconocer.]

    #_apb2-clave[«La abreviatura S.O.S. transmitida separando las tres letras». Es la clave que dan las recopilaciones de exámenes reales (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea la técnicamente correcta.]],
)

#q("C-R4.3", "d",
  [En el sistema GMDSS, la alerta de socorro inicial en MF/HF se realiza mediante Llamada Selectiva Digital (DSC). ¿En qué frecuencia se transmite esta alerta en banda MF?],
  ([156,525 MHz], [1414 kHz], [2182 kHz], [2187,5 kHz]),
  sol: [En MF, la alerta de socorro del GMDSS por DSC se transmite en 2187,5 kHz. La frecuencia de 2182 kHz es la tradicional de socorro en radiotelefonía (voz), no la de la alerta digital. 156,525 MHz es el canal 70 de VHF, que también es de DSC pero en otra banda (VHF, no MF). 1414 kHz no es frecuencia de socorro. El banco no traía clave para esta pregunta; la respuesta se ha fijado con la norma.

    #no-esta[El GMDSS (Sistema Mundial de Socorro y Seguridad Marítimos) automatiza las alertas con la llamada selectiva digital (DSC): un mensaje digital breve que identifica al buque y su posición. Frecuencias de alerta DSC: MF, 2187,5 kHz; HF, 4207,5, 6312, 8414,5, 12577 y 16804,5 kHz; VHF, canal 70, 156,525 MHz. La voz va aparte: 2182 kHz en MF y canal 16 (156,8 MHz) en VHF. Truco: la de MF es la de voz (2182) más 5,5 kHz.]],
)

== Tema R5. Distintivos de llamada

#q("C-R5.1", "b",
  [¿Qué sufijo puede asignarse a una autorización de radioaficionado?],
  ([DDD], [FFF], [TTT], [XXX]),
  sol: [El sufijo se asigna por orden alfabético y turno riguroso de expedición, pero el artículo 27 de la Orden IET/1311/2013 excluye los grupos de letras que expresan señales de socorro, urgencia y seguridad: DDD, PAN, SOS, TTT y XXX. Por eso DDD, TTT y XXX no pueden asignarse nunca, mientras que FFF es una combinación ordinaria de tres letras que se adjudica cuando le llega el turno. #vease[(Véase tema R5, sección «Asignación y uso del distintivo».)]

    #no-esta[Sufijos vetados por el artículo 27 de la Orden: DDD, PAN, SOS, TTT y XXX (señales de socorro, urgencia y seguridad) y toda la serie QAA–QZZ, para que un distintivo no se confunda con un código Q. El cuaderno enseña SOS, XXX y TTT; añade DDD y PAN. Están además reservados los sufijos que empiezan por Y o Z (desatendidas) y por UR, RC o RK (colectivas). Las demás combinaciones, como FFF, se adjudican por orden alfabético.]],
)

#q("C-R5.2", "a",
  [¿Cuál de los siguientes sufijos podrá ser asignado a un distintivo de llamada de la autorización de radioaficionado?],
  ([EEE], [TTT], [PAN], [QRS]),
  sol: [EEE es una combinación ordinaria de tres letras y se asigna cuando le toca por orden alfabético. Las otras tres están excluidas por el artículo 27 de la Orden IET/1311/2013: TTT y PAN expresan señales de seguridad y de urgencia, y QRS cae en la serie QAA–QZZ, vedada para que ningún distintivo se confunda con un código Q. #vease[(Véase tema R5, sección «Asignación y uso del distintivo».)]

    #no-esta[El artículo 27 veta, además de SOS, XXX y TTT, otros dos grupos: DDD y PAN (este último, la señal de urgencia en fonía). Tampoco se adjudica ningún sufijo entre QAA y QZZ. Regla de examen: si una opción es un grupo de socorro, urgencia o seguridad, o un código Q, no es asignable; EEE no tiene ninguna reserva.]],
)

#q("C-R5.3", "b",
  [La utilización de distintivos temporales requerirá la presentación de una solicitud; señale la proposición errónea:],
  ([Indicando el nombre y distintivo de llamada del solicitante.], [Dirigida a la Asociación o Radio Club de aficionados correspondiente, que será la que autorice.], [Indicando el período de utilización.], [Indicando el distintivo de llamada solicitado.]),
  sol: [Los distintivos temporales los autoriza la Administración, no una asociación. El artículo 28 de la Orden IET/1311/2013 exige una solicitud independiente para cada evento, con el período de utilización, el distintivo solicitado, el nombre y distintivo del solicitante, el motivo y el tipo de estación; por eso las opciones a, c y d son correctas. La b es la errónea: las asociaciones reconocidas solo pueden preparar planes anuales de utilización y proponer asignaciones, que la Administración estudia y aprueba. #vease[(Véase tema R5, sección «Sufijos y usos temporales».)]

    #no-esta[Distintivos temporales (art. 28 de la Orden IET/1311/2013): cada evento necesita su propia solicitud a la Administración, con período, distintivo pedido, nombre y distintivo del solicitante (firmada por su representante si es una asociación o radio club), motivo y tipo de estación. Como norma general, el período no supera 30 días al año por sufijo y peticionario; los sufijos de una letra para concursos de alta competitividad pueden concederse hasta por dos años. Las asociaciones proponen, no autorizan.]],
)

#q("C-R5.4", "d",
  [Los sufijos de dos letras podrán ser asignados:],
  ([Nunca.], [Siempre y cuando comiencen por la letra Q.], [Únicamente a una agrupación de radioaficionados.], [A cualquier radioaficionado que acredite cinco años de prácticas en la radioafición internacional.]),
  sol: [El artículo 27 de la Orden IET/1311/2013 permite adjudicar sufijos de dos letras a radioaficionados con al menos cinco años de autorización española, que acrediten cinco años de práctica en la radioafición internacional y no hayan sido sancionados en los últimos cinco años. La redacción de la opción d simplifica: como la demanda supera las disponibilidades, la Administración fija además un procedimiento con plazos y méritos. La a es falsa; la c también (las agrupaciones usan sufijos de tres letras que empiezan por UR, RC o RK); y la b inventa una condición: lo que la norma excluye es la serie QAA–QZZ. #vease[(Véase tema R5, sección «Sufijos y usos temporales».)]

    #no-esta[Requisitos del artículo 27 para un sufijo de dos letras: autorización española con antigüedad mínima de cinco años, cinco años de práctica en la radioafición internacional y ningún expediente sancionador en los últimos cinco años. Para el de una letra, quince años de práctica. Como la demanda supera a los sufijos disponibles, la Administración establece un procedimiento con plazos de solicitud y méritos específicos, de forma transparente y no discriminatoria.]],
)

#q("C-R5.5", "b",
  [¿Cuál de las siguientes proposiciones contiene mayor número de provincias adscritas al distrito 4?:],
  ([Málaga, Murcia, Madrid, Vizcaya.], [Cáceres, Cádiz, Cuenca, Ciudad Real.], [Córdoba, Castellón, Cantabria, Burgos.], [Toledo, Teruel, Tarragona, Santa Cruz de Tenerife.]),
  sol: [Se cuentan las provincias del distrito 4 (Madrid, Toledo, Ciudad Real, Cuenca, Guadalajara, Badajoz y Cáceres) en cada opción. a: solo Madrid (Málaga es del 7, Murcia del 5, Vizcaya del 2). b: Cáceres, Cuenca y Ciudad Real, tres (Cádiz es del 7). c: ninguna (Córdoba 7, Castellón 5, Cantabria y Burgos 1). d: solo Toledo (Teruel es del 2, Tarragona del 3 y Santa Cruz de Tenerife del 8). Gana la b con tres. #vease[(Véase tema R5, tabla «Distritos de los distintivos de llamada españoles».)]

    #no-esta[Distrito 4 (art. 27 de la Orden IET/1311/2013): Madrid, Toledo, Ciudad Real, Cuenca, Guadalajara, Badajoz y Cáceres. El cuaderno lo resume como «Madrid, Castilla-La Mancha (parte) y Extremadura»: de Castilla-La Mancha solo queda fuera Albacete, que es del distrito 5. Cádiz, Málaga y Córdoba son del 7 (Andalucía); Murcia y Castellón, del 5.]],
)

#q("C-R5.6", "c",
  [En relación con los distintivos de llamada, la provincia de Murcia se identifica por la cifra:],
  ([7], [6], [5], [4]),
  sol: [Murcia pertenece al distrito 5, junto con Valencia, Alicante, Castellón y Albacete (art. 27 de la Orden IET/1311/2013); un distintivo de Murcia es de la forma EA5…. El 7 es Andalucía, el 6 las Illes Balears y el 4 Madrid, Extremadura y Castilla-La Mancha sin Albacete. #vease[(Véase tema R5, tabla «Distritos de los distintivos de llamada españoles».)]],
)

#q("C-R5.7", "c",
  [El indicativo de llamada ED3ZHO:],
  ([Pertenece a una estación fija de la provincia de Zaragoza], [Tiene carácter temporal], [Corresponde a una estación automática desatendida], [No se puede adjudicar a estación colectiva alguna]),
  sol: [El distintivo se lee por partes: el prefijo ED es el de las estaciones automáticas desatendidas, el 3 es el distrito (Cataluña) y el sufijo ZHO empieza por Z, letra reservada a las desatendidas digitales (la Y, a las analógicas). La a falla: la Z no es Zaragoza, que es del distrito 2. La b también: ED sirve igualmente en usos temporales, pero entonces conserva el sufijo personal del titular, y un sufijo con Z nunca es personal. La d habla de estaciones colectivas, que llevan sufijos UR, RC o RK. #vease[(Véase tema R5, introducción y sección «Sufijos y usos temporales».)]],
)

#q("C-R5.8", "d",
  [Una estación de aficionado ubicada en la provincia de Albacete se identifica por la cifra:],
  ([7], [6], [2], [5]),
  sol: [Albacete pertenece al distrito 5, con Valencia, Alicante, Castellón y Murcia (art. 27 de la Orden IET/1311/2013). Es la excepción de Castilla-La Mancha: el resto de sus provincias son del 4. El 7 es Andalucía, el 6 las Illes Balears y el 2 el País Vasco, Navarra y Aragón. Si la pregunta se formula al revés (¿cuál de Almería, Albacete, Álava y Ávila es del distrito 5?), la respuesta es la misma: Albacete; Almería es del 7, Álava del 2 y Ávila del 1. #vease[(Véase tema R5, tabla «Distritos de los distintivos de llamada españoles».)]],
)

#q("C-R5.9", "b",
  [¿Cuándo se añade la mención /P al distintivo de llamada?],
  ([Cuando se opera una estación Fija/Portable], [Cuando se opera en grafía una estación Fija/Portable], [Cuando se opera en fonía una estación Fija/Portable], [Cuando se realizan ensayos o concursos]),
  sol: [La identificación de las estaciones móviles y portables es opcional (art. 29.2 de la Orden IET/1311/2013) y depende del modo: en telegrafía se añaden las abreviaturas /M, /MM, /MA o /P; en fonía se dicen las palabras móvil, móvil marítima, móvil aeronáutica o portable. Por eso /P se añade al operar en grafía una estación portable. La c describe la palabra «portable», no la abreviatura; la a no distingue el modo; y los ensayos y concursos no se marcan con /P, sino con prefijos de uso temporal (art. 27).

    #no-esta[Art. 29.2 de la Orden IET/1311/2013: las estaciones móviles y portables pueden completar su distintivo, de forma opcional, con /M (móvil), /MM (móvil marítima), /MA (móvil aeronáutica) o /P (portable) en telegrafía, o con las palabras correspondientes en fonía. También opcionalmente puede añadirse el número del distrito desde el que se emite, si no coincide con el del distintivo. Regla: abreviatura, grafía; palabra, fonía.]],
)

#q("C-R5.10", "b",
  [La cifra del distintivo de llamada que identifica el distrito, según la distribución geográfica, es, para Valladolid:],
  ([3], [1], [2], [4]),
  sol: [Valladolid es una provincia de Castilla y León, que pertenece íntegramente al distrito 1 (art. 27 de la Orden IET/1311/2013), junto con Galicia, Asturias, Cantabria y La Rioja: un distintivo de Valladolid es de la forma EA1…. El 2 es País Vasco, Navarra y Aragón; el 3, Cataluña; el 4, Madrid, Extremadura y Castilla-La Mancha sin Albacete. #vease[(Véase tema R5, tabla «Distritos de los distintivos de llamada españoles».)]],
)

#q("C-R5.11", "b",
  [El prefijo EE delante de un distintivo completo de radioaficionado indica:],
  ([Una estación de servicios especiales.], [Un distintivo de uso temporal (concursos, experimentos, demostraciones y otros eventos locales, regionales, autonómicos o nacionales).], [Un distintivo permanente de estación automática desatendida.], [No puede emplearse en estaciones españolas.]),
  sol: [Según el artículo 27 de la Orden IET/1311/2013, ED, EE y EF se pueden usar, con autorización previa, como prefijos temporales en concursos, experimentos, ensayos, demostraciones y otros eventos locales, regionales, autonómicos o nacionales, y el resto del distintivo del titular no cambia. La c falla: el prefijo permanente de las desatendidas es ED. La d también: EE pertenece a la serie atribuida a España. Nota: el enunciado antiguo hablaba de estaciones «clase B», pero las clases A, B y C del régimen anterior ya no existen; la respuesta se conserva con el significado vigente. #vease[(Véase tema R5, sección «Sufijos y usos temporales».)]],
)

#q("C-R5.12", "c",
  [¿Cuándo se añade la mención «portable» al indicativo de llamada?],
  ([Cuando se opera una estación Fija/Portable], [Cuando se opera en grafía una estación Fija/Portable], [Cuando se opera en fonía una estación Fija/Portable], [Cuando se realizan ensayos o concursos]),
  sol: [El artículo 29.2 de la Orden IET/1311/2013 distingue el modo: en telegrafía la estación portable añade la abreviatura /P; en fonía dice la palabra «portable». La mención que pregunta el enunciado es la palabra, luego corresponde a la fonía. La b describe la abreviatura /P; la d es falsa, pues ensayos y concursos se identifican con prefijos temporales. El banco da por buena la a, pero esa opción es circular (repite «estación portable» sin decir cómo) y lo que separa las opciones es el modo: la clave coherente con la norma, y con la pregunta paralela sobre /P, es la c.

    #no-esta[Art. 29.2 de la Orden IET/1311/2013: la identificación de las estaciones móviles y portables es opcional. En telegrafía se añade /M, /MM, /MA o /P; en fonía se pronuncian las palabras móvil, móvil marítima, móvil aeronáutica o portable. Por ejemplo, un radioaficionado en portable diría su distintivo seguido de «portable»; en telegrafía enviaría EA4XYZ/P. Puede añadirse también el número del distrito desde el que emite, si no coincide con el de su distintivo.]

    #_apb2-clave[«Cuando se opera una estación Fija/Portable». Es la clave que dan las recopilaciones de exámenes reales (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea la técnicamente correcta.]],
)

#q("C-R5.13", "a",
  [Una estación de radioaficionado instalada en la provincia de Zamora lleva en el distintivo de llamada la cifra:],
  ([1], [3], [7], [10]),
  sol: [Zamora es una provincia de Castilla y León, que pertenece al distrito 1 (art. 27 de la Orden IET/1311/2013): su distintivo es de la forma EA1…. El 3 es Cataluña y el 7 Andalucía. El 10 no existe: los distritos van del 1 al 9, y el 0 está reservado a casos especiales. #vease[(Véase tema R5, tabla «Distritos de los distintivos de llamada españoles».)]],
)

#q("C-R5.14", "c",
  [Las primeras letras de un distintivo de llamada:],
  ([Las elige cada país según la inicial francesa de su nombre], [Indican el tipo de autorización], [Son elegidas por cada país a partir de las atribuciones internacionales], [Se atribuyen, en la Conferencia Europea de Administraciones postales y de Telecomunicación, a cada país]),
  sol: [Las series de letras con las que empiezan los distintivos las atribuye a cada país la UIT, en el Reglamento de Radiocomunicaciones; después, cada Administración elige sus prefijos dentro de las series que le han tocado (España: EA–EH y AM–AO, art. 27 de la Orden IET/1311/2013). El banco da por buena la d, pero la CEPT es un organismo europeo de coordinación y no atribuye series de prefijos. La a no es ninguna regla, y la b es falsa: el prefijo identifica al país, no el tipo de autorización. #vease[(Véase tema R5, introducción.)]

    #no-esta[Reparto de prefijos: la UIT, en el artículo 19 del Reglamento de Radiocomunicaciones, atribuye a cada país series de caracteres con los que deben empezar los distintivos de sus estaciones. Cada Administración asigna luego los distintivos dentro de sus series. A España le corresponden EAA–EHZ y AMA–AOZ. La CEPT, en cambio, armoniza la licencia CEPT (T/R 61-01), no reparte prefijos.]

    #_apb2-clave[«Se atribuyen, en la Conferencia Europea de Administraciones postales y de Telecomunicación, a cada país». Es la clave que dan las recopilaciones de exámenes reales (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea la técnicamente correcta.]],
)

#q("C-R5.15", "c",
  [Las series de distintivos de llamada:],
  ([Empiezan siempre por la inicial en lengua francesa del nombre del país], [Empiezan siempre con una combinación de 2 o 3 letras elegidas de una serie secuencial atribuida a un país], [Empiezan por una combinación de letras o cifras con una longitud máxima de tres], [Empiezan por combinaciones de 2 letras o cifras]),
  sol: [En las series internacionales del Reglamento de Radiocomunicaciones, la parte inicial que identifica la nacionalidad del distintivo puede ser de uno, dos o tres caracteres, y pueden ser letras o cifras (por ejemplo, G, EA o 3DA). Por eso la c es correcta. La a no es ninguna regla. La b falla porque no siempre son letras ni siempre son dos o tres caracteres; la d, porque no siempre son exactamente dos.

    #no-esta[Estructura de los distintivos internacionales (artículo 19 del Reglamento de Radiocomunicaciones de la UIT): la UIT atribuye a cada país bloques de tres caracteres (España: EAA–EHZ y AMA–AOZ). La parte que identifica la nacionalidad tiene uno, dos o, si hace falta, tres caracteres, letras o cifras. En España el prefijo son las dos primeras letras (art. 27 de la Orden IET/1311/2013).]],
)

#q("C-R5.16", "d",
  [Una estación de aficionados ubicada en Alicante es identificada por la cifra:],
  ([2], [3], [9], [5]),
  sol: [Alicante pertenece al distrito 5, junto con Valencia, Castellón, Murcia y Albacete (art. 27 de la Orden IET/1311/2013): su distintivo es de la forma EA5…. El 2 es País Vasco, Navarra y Aragón; el 3, Cataluña; el 9, Ceuta y Melilla. #vease[(Véase tema R5, tabla «Distritos de los distintivos de llamada españoles».)]],
)

#q("C-R5.17", "c",
  [Una estación de radioaficionado situada en la provincia de Cuenca se identifica por el número:],
  ([6], [8], [4], [3]),
  sol: [Cuenca está en Castilla-La Mancha, y todas sus provincias menos Albacete pertenecen al distrito 4 (art. 27 de la Orden IET/1311/2013): su distintivo es de la forma EA4…. El 6 son las Illes Balears, el 8 Canarias y el 3 Cataluña. #vease[(Véase tema R5, tabla «Distritos de los distintivos de llamada españoles».)]

    #no-esta[Distrito 4 (art. 27 de la Orden IET/1311/2013): Madrid, Toledo, Ciudad Real, Cuenca, Guadalajara, Badajoz y Cáceres. El cuaderno lo resume como «Madrid, Castilla-La Mancha (parte) y Extremadura»: de las cinco provincias de Castilla-La Mancha, solo Albacete queda fuera (es del distrito 5). Por eso Cuenca es del 4.]],
)

#q("C-R5.18", "b",
  [Una estación de aficionado ubicada en la provincia de Zaragoza se identifica por la cifra:],
  ([8], [2], [5], [4]),
  sol: [Zaragoza está en Aragón, que junto con el País Vasco y Navarra forma el distrito 2 (art. 27 de la Orden IET/1311/2013): su distintivo es de la forma EA2…. El 8 es Canarias, el 5 la Comunidad Valenciana, Murcia y Albacete, y el 4 Madrid, Extremadura y Castilla-La Mancha sin Albacete. #vease[(Véase tema R5, tabla «Distritos de los distintivos de llamada españoles».)]],
)

#q("C-R5.19", "d",
  [¿Se puede asignar el sufijo PAN a un distintivo de llamada de una estación de aficionado?],
  ([No, solamente a los distintivos de estaciones colectivas], [No, solamente a los distintivos de estaciones automáticas desatendidas], [Se puede asignar a cualquier estación], [No se puede asignar en ningún caso]),
  sol: [El artículo 27 de la Orden IET/1311/2013 excluye de la asignación de sufijos los grupos que expresan señales de socorro, urgencia y seguridad: DDD, PAN, SOS, TTT y XXX. PAN es la señal de urgencia en fonía, así que no se asigna a ningún distintivo, sea de la estación que sea. Nota: el enunciado original hablaba de la «clase A» y ofrecía las clases B y C, propias del régimen anterior; hoy esas clases no existen y la respuesta no cambia.

    #no-esta[Art. 27 de la Orden IET/1311/2013: los sufijos se asignan por orden alfabético, saltándose los grupos que expresan señales de socorro, urgencia y seguridad —DDD, PAN, SOS, TTT y XXX— y toda la serie QAA–QZZ. PAN es la señal de urgencia en fonía («PAN PAN»). Esos grupos no se adjudican a nadie.]],
)

#q("C-R5.20", "b",
  [¿A cuál de las siguientes provincias pertenece el distintivo EA5EYR?],
  ([Zaragoza], [Valencia], [Zamora], [Almería]),
  sol: [La cifra del distintivo es el distrito de residencia del titular cuando se le otorgó la autorización. El distrito 5 agrupa Valencia, Alicante, Castellón, Murcia y Albacete (art. 27 de la Orden IET/1311/2013); de las provincias propuestas, solo Valencia está en él. Zaragoza es del distrito 2, Zamora del 1 y Almería del 7. Las letras EYR son el sufijo y no indican provincia. #vease[(Véase tema R5, tabla «Distritos de los distintivos de llamada españoles».)]],
)

#q("C-R5.21", "a",
  [¿Cómo debe identificarse correctamente una estación de baja potencia o QRP?],
  ([Añadiendo un espacio o pausa y las letras QRP a la llamada general CQ.], [Añadiendo el sufijo /QRP al distintivo de llamada.], [Añadiendo la potencia con un número y la letra W de vatios.], [Añadiendo el sufijo /P al distintivo de llamada.]),
  sol: [El distintivo no cambia por trabajar con poca potencia: se transmite tal como se asignó. Lo único que la Orden IET/1311/2013 permite añadirle, y de forma opcional, son /M, /MM, /MA o /P en telegrafía (o las palabras móvil, móvil marítima, móvil aeronáutica o portable) para estaciones móviles o portables (art. 29.2). Por eso la baja potencia se anuncia en la llamada, como práctica operativa: «CQ QRP». La b inventa un sufijo inexistente; la c mezcla la potencia con el distintivo; la d es el sufijo de estación portable, que dice desde dónde se emite, no con cuánta potencia. #vease[(Véase tema R2 (significado de QRP) y tema R5, sección «Asignación y uso del distintivo».)]

    #no-esta[QRP es el grupo del código Q que significa «disminuya la potencia» y, como sustantivo, emisión con baja potencia (por convención de los aficionados, no de la norma, hasta unos 5 W). La identificación reglamentaria es solo el distintivo de llamada, al comienzo y al final de la emisión y al menos cada diez minutos en las largas (art. 29.1 de la Orden IET/1311/2013); solo se admiten los añadidos opcionales /M, /MM, /MA y /P (art. 29.2). La condición QRP no forma parte del distintivo: se anuncia en la llamada, p. ej. «CQ QRP».]],
)

== Tema R6. Planes de bandas de la IARU

#q("C-R6.1", "b",
  [Los planes de banda de la IARU:],
  ([Tienen previstas frecuencias para repetidores digitales en la banda 91,5–95,0 MHz.], [Tienen previstas frecuencias para repetidores en la banda 433,000–433,375 MHz.], [No tienen previstas frecuencias para comunicaciones por satélite.], [No se aplican en países del Hemisferio Sur.]),
  sol: [En 70 cm, el plan de la IARU para la Región 1 reserva 433,000–433,375 MHz a repetidores de FM y de voz digital. La a) falla porque 91,5–95,0 MHz pertenece a la radiodifusión FM, no a una banda de aficionados. La c) es falsa: el plan prevé segmentos para satélites (145,806–146,000 MHz en 2 m, 435–438 MHz en 70 cm). La d) confunde región con hemisferio: los planes se organizan por Regiones de la UIT, y la Región 1 incluye Europa y toda África, también sus países australes, como Sudáfrica. #vease[(Véase tema R6, introducción del capítulo (qué es un plan de bandas y cómo reparte los segmentos).)]

    #no-esta[El cuaderno cita el segmento de repetidores de 2 m, pero no el de 70 cm (430–440 MHz). En esa banda, el plan de la IARU para la Región 1 dedica 433,000–433,375 MHz a repetidores de FM y de voz digital. Ese segmento es el de #emph[entrada] del repetidor, con canales de 25 kHz y un desplazamiento estándar de 1,6 MHz: la salida queda en 434,600–434,975 MHz. Para el examen basta recordar que los 433 MHz son de repetidores y que los 91,5–95,0 MHz, al ser de radiodifusión, no pueden serlo.]],
)

#q("C-R6.2", "a",
  [En los planes de bandas de la IARU para la Región 1:],
  ([Hay previstas frecuencias para repetidores en la banda 145,594–145,7935 MHz.], [No hay previstas frecuencias para repetidores en UHF.], [Hay previstas frecuencias para repetidores analógicos en la banda 88,5–99,0 MHz.], [No hay planes de banda de la IARU para la Región 1.]),
  sol: [En 2 m el plan reserva 145,000–145,1875 MHz a las entradas de los repetidores y, 600 kHz más arriba, sus salidas: $145,000 + 0,600 = 145,600$ MHz hasta $145,1875 + 0,600 = 145,7875$ MHz, dentro de 145,594–145,7935 MHz. La b) es falsa: en 70 cm hay segmentos de repetidores (433,000–433,375 MHz de entrada y 434,600–434,975 MHz de salida). La c) cita 88,5–99,0 MHz, que es radiodifusión FM y no una banda de aficionados. La d) es falsa: la Región 1 tiene plan propio, el que rige en España. #vease[(Véase tema R6, introducción del capítulo (entrada 145,000–145,1875 MHz y salida 600 kHz más arriba) y pregunta sobre la entrada de los repetidores de VHF.)]],
)

#q("C-R6.3", "b",
  [Sobre los planes de bandas de la IARU es correcto decir que:],
  ([La IARU no tiene planes de banda para la Región 1.], [Sirven de guía a los radioaficionados de todo el mundo.], [Deben ser tenidos en cuenta únicamente si se opera en Canarias.], [En España se deben aplicar los planes de banda de la IARU para la Región 2.]),
  sol: [Los planes de banda no son normas legales sino recomendaciones de convivencia: reparten cada banda por modos y sirven de guía a los radioaficionados de todo el mundo, cada uno con el plan de su Región. La a) es falsa: la Región 1 tiene el suyo. La c) también: la Orden IET/1311/2013 (art. 2.2) manda usar, como norma general, el plan de la Región 1 en todo el territorio español, y Canarias es una parte más. La d) es falsa: España pertenece a la Región 1 (Europa y África), no a la 2, que es América. #vease[(Véase tema R6, introducción del capítulo y sección «Las tres regiones de la UIT».)]],
)

#q("C-R6.4", "b",
  [Los planes de banda de la IARU:],
  ([No proporcionan información sobre el modo preferido de utilización.], [Son un instrumento básico para regular el uso de las bandas de frecuencias.], [Son iguales a nivel mundial.], [No tienen en cuenta la atribución de bandas del Reglamento de Radiocomunicaciones de la UIT.]),
  sol: [Los planes ordenan el uso de cada banda repartiéndola en segmentos según el modo y la anchura de banda, y por eso son el instrumento básico para organizar su utilización. «Regular» no significa que tengan rango de ley: son acuerdos voluntarios entre asociaciones, aunque la Orden IET/1311/2013 (art. 2.2) remite a ellos como norma general. La a) es falsa: indican precisamente el modo recomendado. La c) es falsa: hay un plan por Región de la UIT. La d) es falsa: parten de las atribuciones del Reglamento de Radiocomunicaciones. #vease[(Véase tema R6, introducción del capítulo y sección «Las tres regiones de la UIT».)]],
)

#q("C-R6.5", "d",
  [En la banda de radioaficionado de 40 metros, el modo de emisión que normalmente se utiliza es:],
  ([USB], [AM], [LSB y AM], [LSB]),
  sol: [Por convenio, en banda lateral única se usa la banda lateral inferior (LSB) por debajo de 10 MHz y la superior (USB) por encima. Los 40 m (7 MHz) están por debajo, así que la fonía habitual es LSB. La a) es el modo de 20 m y de las bandas más altas. La AM, en las opciones b) y c), se oye poco en HF: ocupa el doble de ancho de banda y gasta la mayor parte de la potencia en la portadora, por lo que no es el modo normal de la banda. #vease[(Véase tema T1, sección «Señales moduladas» (banda lateral única); tema R3, abreviaturas LSB y USB.)]

    #no-esta[El cuaderno explica qué son LSB y USB, pero no cuál se usa en cada banda. Es un convenio, no una norma: por debajo de 10 MHz (160, 80 y 40 m) se emplea LSB, y por encima (20, 17, 15, 12 y 10 m) USB. Regla para recordarlo: en las bandas bajas, banda lateral inferior; en las altas, superior. Así, la fonía en SSB a 7 MHz se hace en LSB y a 14 MHz en USB. El plan de bandas de la IARU indica el segmento de cada modo, pero no impone la banda lateral.]],
)

== Tema R8. Reglamentación nacional e internacional

#q("C-R8.1", "a",
  [¿Con qué anticipación a la fecha prevista para el comienzo de las emisiones se deberá solicitar una autorización especial de uso del espectro radioeléctrico por radioaficionados?],
  ([1 mes.], [2 meses.], [3 meses.], [Ninguno.]),
  sol: [La autorización especial para usos experimentales (art. 17.3 de la Orden IET/1311/2013) se pide a la SETSI, con la memoria técnica, «con al menos un mes de antelación» a la fecha prevista para empezar a emitir. La norma fija un único plazo mínimo: un mes. Por eso fallan «2 meses», «3 meses» y «ninguno». No lo confundas con los 5 días de aviso de las estaciones portables (art. 17.1) ni con los 18 meses de validez máxima inicial de la autorización. #vease[(Véase tema R8, sección «Usos especiales y casos particulares».)]

    #no-esta[La autorización especial (art. 17.2 y 17.3 de la Orden IET/1311/2013) es la que se necesita para emitir con carácter experimental y con características técnicas distintas de las del Reglamento. Se solicita a la SETSI, directamente o a través de la Jefatura Provincial, con una memoria técnica (experimento, bloques del equipo, lugar con coordenadas, periodo, banda, emisión, potencia y antena) y al menos un mes antes del inicio previsto. Es nominativa y dura como máximo 18 meses iniciales.]],
)

#q("C-R8.2", "c",
  [En la licencia de estación de radioaficionado CEPT habrá de constar necesariamente una determinada información. Indique la respuesta incorrecta:],
  ([Autoridad que expide la licencia.], [Distintivo de llamada.], [Asociación de radioaficionados a la que pertenece.], [Periodo de validez.]),
  sol: [El art. 12 de la Orden IET/1311/2013 enumera lo que debe constar en la licencia CEPT: la declaración que autoriza al titular a usar su estación según la T/R 61-01 en cualquier país que la haya adoptado, nombre y dirección del titular, distintivo de llamada, periodo de validez y autoridad que la expide. La asociación a la que pertenece el titular no figura: ser socio de una asociación no es requisito para ser radioaficionado. Por eso la incorrecta, la que se pide, es la c.

    #no-esta[La licencia CEPT (Recomendación T/R 61-01; arts. 11 y 12 de la Orden IET/1311/2013) permite operar temporalmente en los países que la han adoptado. Debe contener cinco datos: la declaración de que autoriza a usar la estación conforme a la T/R 61-01, nombre y dirección del titular, distintivo de llamada, periodo de validez y autoridad que la expide. Regla práctica: quién eres, cómo te llamas en el aire, hasta cuándo vale y quién lo firma. En España, la autorización de radioaficionado vale a todos los efectos como licencia CEPT.]],
)

#q("C-R8.3", "c",
  [El contrato de seguro que cubre la responsabilidad del radioaficionado titular de una licencia de estación:],
  ([Se debe formalizar únicamente si la instalación ha sido autorizada y en un plazo de un mes.], [Sólo debe contratarse si la instalación es técnicamente compleja.], [Debe estar formalizado antes de la expedición de la licencia de estación.], [Debe contratarse cuando se solicita la autorización de radioaficionado.]),
  sol: [El seguro de responsabilidad civil de la antena lo regula el art. 20 del Real Decreto 2623/1986, al que remite el art. 20 de la Orden IET/1311/2013. Su apartado 2 dice que se formaliza una vez autorizado el montaje y, en todo caso, antes de expedirse la licencia de estación: por eso, al terminar la instalación, hay que justificarlo ante la Jefatura Provincial. La a mezcla algo cierto (tras autorizarse el montaje) con un plazo de un mes que la norma no fija. La b es falsa: el seguro es obligatorio siempre. La d también: la autorización de radioaficionado es personal y el seguro va ligado a la estación fija. #vease[(Véase tema R8, sección «Autorización y licencia de estación».)]

    #no-esta[El art. 20 del Real Decreto 2623/1986 obliga a cubrir con un seguro la responsabilidad del titular por daños materiales y personales derivados de la antena (uso, instalación, mantenimiento y desmontaje). Cronología: solicitud; autorización del montaje (art. 19 de la Orden); contrato de seguro, formalizado como muy tarde antes de expedirse la licencia; fin de la instalación, comunicado en 6 semanas con el justificante del seguro (art. 20 de la Orden); licencia. Si deja de mantenerse el seguro, la licencia se cancela automáticamente (art. 21.1.c).]],
)

#q("C-R8.4", "d",
  [El Reglamento de uso del dominio público radioeléctrico por aficionados:],
  ([Su vigencia se limita a 4 años.], [Es un documento técnico informativo sin carácter vinculante para los radioaficionados.], [Fija las tasas por derecho a examen.], [Constituye el documento fundamental de regulación de la radioafición.]),
  sol: [La Orden IET/1311/2013 aprueba este Reglamento, que es una norma jurídica obligatoria y la norma específica de la actividad: regula la autorización, la prueba de capacitación, las estaciones fijas, los distintivos, las condiciones de uso y la inspección. No tiene una vigencia de 4 años: es indefinido, y la autorización tampoco se renueva. No es meramente informativo (b). Las tasas no las fija él, sino la Ley General de Telecomunicaciones, a la que remiten sus arts. 6 y 9 (c). #vease[(Véase tema R8, introducción del tema («tres pisos» normativos).)]],
)

#q("C-R8.5", "c",
  [La obtención de la autorización de radioaficionado requerirá la obtención previa de:],
  ([Un curso de formación impartido por una asociación de radioaficionados.], [Un carnet de operador expedido por un radio club.], [El certificado de examen armonizado (HAREC), que se obtiene al superar la prueba de capacitación.], [La licencia de estación fija.]),
  sol: [Según el art. 5.2 de la Orden IET/1311/2013, la autorización exige superar la prueba de capacitación; quien la supera recibe el certificado HAREC (T/R 61-02) y queda habilitado para solicitar la autorización (art. 10.3). No hay cursos obligatorios ni carnets de radio club (a, b). La licencia de estación fija (d) no es previa, sino posterior: se asocia a la autorización ya concedida (art. 18.1). El banco antiguo decía «diploma de operador»: es el antiguo nombre de este certificado. Si aparece esa redacción, es la respuesta correcta. #vease[(Véase tema R7, equivalencia entre diploma de operador y HAREC; tema R8, preguntas sobre el certificado HAREC.)]

    #no-esta[Secuencia de la Orden IET/1311/2013: prueba de capacitación (art. 10: electricidad y radioelectricidad, y normativa), certificado HAREC al aprobar ambas partes (art. 10.3), y solicitud de la autorización de radioaficionado con pago de tasa (arts. 5.2, 6 y 10.3). El HAREC no autoriza a transmitir por sí mismo: es el requisito previo. Después, si se quiere instalar una estación fija, se pide además la licencia de estación (art. 18).]],
)

#q("C-R8.6", "d",
  [En la memoria descriptiva, para la obtención de la licencia de una estación de aficionado, no es preciso incluir:],
  ([Las características y resistencia de la toma de tierra.], [Un plano señalando la ubicación de la estación.], [Marca, modelo y número de serie de los equipos radioeléctricos.], [Certificado de empadronamiento.]),
  sol: [La memoria describe la estación y su instalación para que la Administración compruebe que cumple el Reglamento y es segura (arts. 19 y 20 de la Orden IET/1311/2013). Su contenido clásico es la toma de tierra, el plano de ubicación y la relación de equipos con marca, modelo y número de serie (a, b, c). El empadronamiento no tiene relación con la estación y no se exige; lo que sí debe acreditarse es el derecho a usar el inmueble donde irá la antena (art. 2 del Real Decreto 2623/1986, al que remite el art. 19.c). Régimen anterior: la lista exacta figuraba en el art. 23.1 de la Orden ITC/1791/2006, derogada; la Orden vigente solo habla de «memoria técnica». #vease[(Véase tema R8, sección «Autorización y licencia de estación».)]

    #no-esta[La solicitud de licencia de estación fija (art. 19 de la Orden IET/1311/2013) se acompaña de una memoria técnica descriptiva de la instalación: relación de equipos con marca, modelo y número de serie, antenas y soportes, toma de tierra y plano de ubicación, más lo que acredite el derecho a usar el inmueble. Son datos de la instalación, no del solicitante: por eso un certificado de empadronamiento no forma parte de ella.]],
)

#q("C-R8.7", "c",
  [Entre las obligaciones del gestor de una estación desatendida no se encuentra la de:],
  ([Actualizar periódicamente la información existente.], [Procurar que el mantenimiento técnico de la estación garantice el servicio continuo de la misma.], [Otorgar la autorización y conformidad del inicio del funcionamiento de la estación.], [Verificar que el tráfico de información se realice conforme a lo previsto por la normativa vigente al respecto.]),
  sol: [El gestor cuida la estación: actualiza la información, procura un mantenimiento que dé servicio continuo y verifica que el tráfico cumple la normativa (a, b, d). Lo que no puede hacer es autorizar el inicio del funcionamiento: es un acto de la Administración. La Jefatura Provincial verifica la instalación y expide la licencia que habilita a empezar las emisiones (arts. 20 y 26 de la Orden IET/1311/2013). Régimen anterior: la figura del gestor era del art. 33 de la Orden ITC/1791/2006, derogada; hoy responde la Junta Directiva de la asociación titular (art. 18.6).

    #no-esta[En el reglamento de 2006 (Orden ITC/1791/2006, art. 33, hoy derogada) cada estación desatendida tenía un gestor designado por la asociación titular. Sus tres obligaciones: verificar que el tráfico se ajusta al reglamento, actualizar periódicamente la información existente y procurar un mantenimiento técnico que garantice el servicio continuo. La Orden IET/1311/2013 atribuye la responsabilidad a la Junta Directiva de la asociación (art. 18.6). Regla de examen: el gestor cuida la estación, nunca la autoriza; autorizar corresponde a la Administración.]],
)

#q("C-R8.8", "d",
  [En la nomenclatura de las bandas de frecuencia las ondas métricas se relacionan con:],
  ([La gama de frecuencias de 3 a 30 GHz.], [El símbolo MF.], [La banda número 9.], [La abreviatura métrica B.m.]),
  sol: [Según el anexo I.2 de la Orden IET/1311/2013, las ondas métricas son la banda número 8, de símbolo VHF (30 a 300 MHz) y abreviatura métrica B.m. Las demás opciones son de otras bandas: 3 a 30 GHz es la SHF (centimétricas, B.cm); MF es la banda 6, de ondas hectométricas (B.hm); y la banda 9 es la UHF, de ondas decimétricas (B.dm). Solo la d corresponde a las métricas. #vease[(Véase tema T7, sección «Cómo se nombran las bandas».)]

    #no-esta[Anexo I.2 de la Orden: banda 4 VLF, miriamétricas (B.Mam); 5 LF, kilométricas (B.km); 6 MF, hectométricas (B.hm); 7 HF, decamétricas (B.dam); 8 VHF, métricas (B.m); 9 UHF, decimétricas (B.dm); 10 SHF, centimétricas (B.cm); 11 EHF, milimétricas (B.mm). Truco: la banda número $N$ va de #box[$0,3 times 10^N$] a #box[$3 times 10^N$] Hz (la 8: de 30 a 300 MHz). La abreviatura es B más el símbolo del múltiplo del metro que da nombre a la onda.]],
)

#q("C-R8.9", "c",
  [La instalación y funcionamiento de una estación fija de aficionado precisará de una licencia, la cual se considera asociada a:],
  ([Una asociación legalizada de radioaficionados de la provincia correspondiente.], [La estación automática desatendida más cercana.], [La autorización de radioaficionado de su titular.], [Toda la gama de frecuencias que pueda utilizar.]),
  sol: [El art. 18.1 de la Orden IET/1311/2013 dice que la estación fija precisa de una licencia, «la cual se considerará asociada a la autorización de radioaficionado de su titular». No depende de una asociación (a), ni de una desatendida (b), ni de una gama de frecuencias (d). Por eso, si la autorización se revoca o se extingue, la licencia se cancela (art. 21.1.b). En el enunciado se ha añadido «fija»: la licencia solo se exige a las estaciones fijas; las móviles y portátiles funcionan con la autorización (art. 5.3). #vease[(Véase tema R8, sección «Autorización y licencia de estación».)]

    #no-esta[El art. 18.1 de la Orden IET/1311/2013 define la estación fija (equipos, soportes, antenas y cables desde una ubicación determinada) y exige una licencia para instalarla y hacerla funcionar. Esa licencia es accesoria de la autorización de radioaficionado de su titular y una misma licencia puede amparar varios equipos de la estación. Al revocarse o extinguirse la autorización, la licencia se cancela (art. 21.1.b) y hay que desmontar la instalación, antenas incluidas (art. 21.2).]],
)

#q("C-R8.10", "c",
  [¿Cuántas estaciones automáticas desatendidas podrán autorizarse en una zona?],
  ([No existe límite para estas autorizaciones.], [Exclusivamente dos por provincia.], [Se autorizarán en función de las necesidades del servicio.], [Tres en VHF y dos en UHF.]),
  sol: [No hay un cupo fijo por provincia ni por banda. Según el art. 25.a de la Orden IET/1311/2013, el número de estaciones automáticas desatendidas se autoriza en función de la cobertura del servicio ya existente y de la disponibilidad de canales: es decir, según las necesidades del servicio. Por eso fallan las opciones con cifras fijas (b, d) y también la que dice que no hay límite (a), porque los canales disponibles sí lo limitan.

    #no-esta[El art. 25 de la Orden IET/1311/2013 fija las condiciones de las estaciones desatendidas. El criterio para autorizar su número es la cobertura preexistente y la disponibilidad de canales (25.a). Si interrumpen las emisiones más de tres meses, salvo fuerza mayor, puede abrirse un expediente para cancelar la licencia y dar la autorización a otra asociación (25.b). El acceso a los repetidores analógicos y a los digitales finales es libre (25.c).]],
)

#q("C-R8.11", "a",
  [Para la obtención de la licencia de estación de radioaficionado es necesario presentar:],
  ([Solicitud adjuntando una memoria descriptiva del conjunto de la instalación.], [Un escrito informando que se ha efectuado la instalación.], [La cédula de habitabilidad del inmueble donde se va a instalar.], [Documento que acredite estar inscrito en una asociación de radioaficionados.]),
  sol: [El trámite de la licencia de estación fija tiene dos pasos (arts. 19 y 20 de la Orden IET/1311/2013). Primero, la solicitud con la documentación y la memoria descriptiva del conjunto de la instalación: si es conforme, se autoriza el montaje. Después, terminada la instalación, se comunica en 6 semanas con el justificante del seguro y, en su caso, el boletín del instalador, y se expide la licencia. Lo que hay que presentar para obtenerla es la solicitud con la memoria (a). La b es solo el aviso del segundo paso y por sí sola no basta. La cédula de habitabilidad (c) no figura entre los requisitos, y ser socio de una asociación (d) tampoco es necesario. #vease[(Véase tema R8, sección «Autorización y licencia de estación» (memoria descriptiva).)]

    #no-esta[Procedimiento de la licencia de estación fija: 1) solicitud a la SETSI (o a través de la Jefatura Provincial) con la documentación y la memoria técnica de la instalación (art. 19); 2) resolución que autoriza el montaje, por un instalador de telecomunicaciones, como norma general; 3) fin de la instalación, comunicado en 6 semanas con justificante del seguro y boletín del instalador (art. 20); 4) la Jefatura dispone de 30 días para verificar y expedir la licencia. Las emisiones no pueden comenzar antes de ese último paso.]],
)

#q("C-R8.12", "a",
  [La licencia de estación de radioaficionado se expedirá:],
  ([Finalizado el montaje de la instalación y presentada la documentación requerida en cada caso.], [En el momento de obtener el certificado HAREC (antes llamado diploma de operador).], [La primera semana de cada mes.], [En el momento de presentar la memoria descriptiva de la estación.]),
  sol: [Según el art. 20 de la Orden IET/1311/2013, finalizada la instalación en las condiciones autorizadas, el interesado lo comunica a la Jefatura Provincial en 6 semanas, con la documentación requerida (justificante del seguro y, en su caso, boletín del instalador). La Jefatura dispone de 30 días para verificarla, inspeccionar si procede y expedir la licencia, que habilita a empezar las emisiones. No se expide al obtener el HAREC (b), que solo habilita para pedir la autorización, ni al presentar la memoria (d), que solo permite montar la estación. No hay calendario mensual (c). El banco antiguo decía «diploma de operador» en la b.

    #no-esta[Art. 20 de la Orden IET/1311/2013: la licencia de estación fija se expide al final del proceso, no al principio. Terminada la instalación, el titular lo comunica a la Jefatura Provincial en un plazo de 6 semanas, con el justificante del seguro de antenas y el boletín del instalador. La Jefatura tiene 30 días como máximo para verificar la documentación, inspeccionar si lo estima conveniente y expedir la licencia, que es lo que habilita a comenzar las emisiones.]],
)

#q("C-R8.13", "c",
  [¿En qué bandas de frecuencias se permite emitir si se dispone de la licencia CEPT?],
  ([Solamente en la banda 1240-1300 MHz.], [Temporalmente en la banda de 10 a 10,5 GHz.], [En todas las bandas de frecuencias atribuidas al Servicio de Aficionados en el país visitado.], [Exclusivamente, en las bandas atribuidas al servicio por satélite.]),
  sol: [El art. 14.b de la Orden IET/1311/2013 dice que la licencia CEPT permite usar todas las bandas atribuidas al Servicio de Aficionados y al de Aficionados por Satélite que estén autorizadas en el país donde se opera, y en las condiciones que allí apliquen. No se limita a una banda concreta (a), a un uso temporal en una banda (b) ni a las de satélite (d). Las bandas son las del país visitado, no las del de origen, y el titular debe respetar además su reglamentación local (art. 14.d). #vease[(Véase tema R8, sección «Usos especiales y casos particulares» (licencia CEPT).)]

    #no-esta[Condiciones de uso de la licencia CEPT (art. 14 de la Orden IET/1311/2013, T/R 61-01): en España se aplica este Reglamento; se pueden usar todas las bandas del servicio autorizadas en el país visitado; hay que mostrar la licencia si las autoridades lo piden; se respetan el Reglamento de Radiocomunicaciones y la normativa local; se usa el distintivo propio precedido de la designación del país visitado; y no se puede reclamar protección contra interferencias perjudiciales fuera del territorio nacional.]],
)

#q("C-R8.14", "a",
  [La obtención de la autorización de radioaficionado por un extranjero residente en España, sin necesidad de superar la prueba de capacitación, precisará:],
  ([Ser titular de un certificado HAREC expedido por cualquier país que aplique la Recomendación CEPT T/R 61-02, o que exista Acuerdo o Convenio de reciprocidad con el país que otorgó su licencia original.], [Que únicamente sea titular de una licencia CEPT T/R 61-01 de su país de origen.], [Que el país de origen del radioaficionado aplique la Recomendación T/R 5000.], [Que se haya examinado en España exclusivamente de la reglamentación nacional.]),
  sol: [El art. 5.2 de la Orden IET/1311/2013 permite a los extranjeros residentes en España, que lo acrediten documentalmente, obtener la autorización sin la prueba de capacitación en dos casos: si tienen un certificado HAREC de un país que haya aplicado la T/R 61-02, o si existe acuerdo o convenio de reciprocidad con el país que otorgó su licencia original. Es la a. La licencia CEPT T/R 61-01 (b) solo vale para extranjeros no residentes, durante estancias temporales (art. 13). Las opciones c y d no son condición alguna de la norma. El banco antiguo decía «diploma de operador expedido en España», el nombre anterior del certificado. #vease[(Véase tema R8, preguntas sobre extranjeros residentes y certificado HAREC.)]

    #no-esta[Art. 5.2, segundo párrafo, de la Orden IET/1311/2013: el extranjero que acredite documentalmente ser residente en España obtiene la autorización, previa solicitud y sin examen, por una de dos vías: (a) certificado HAREC de un país que haya aplicado la T/R 61-02, o (b) acuerdo o convenio de reciprocidad con el país que le dio su licencia. Conviene no mezclarlo con la licencia CEPT (T/R 61-01): equivale a la autorización española solo para no residentes y en estancias temporales (art. 13).]],
)

#q("C-R8.15", "c",
  [El cambio de ubicación de la antena de una estación fija de radioaficionado:],
  ([No es necesario solicitarlo a la Secretaría de Estado de Telecomunicaciones (SETSI).], [Se debe solicitar a la SETSI y seguir un procedimiento distinto al de la primera instalación.], [Se debe solicitar a la SETSI y seguir el mismo procedimiento que si se tratase de la primera instalación.], [Únicamente requiere ser notificado al Ayuntamiento de la localidad.]),
  sol: [Según el último párrafo del art. 20 de la Orden IET/1311/2013, cuando una modificación incluye el cambio de ubicación de la antena, el titular debe solicitarlo a la SETSI con el mismo procedimiento que si fuera la primera instalación: solicitud, autorización de montaje, aviso de fin de obra y verificación para la licencia. La a es falsa, porque sí hay que solicitarlo. La b, porque el procedimiento no es distinto ni abreviado. La d, porque la autorización radioeléctrica no la da el Ayuntamiento. El banco antiguo hablaba de la «Dirección General de Telecomunicaciones»; hoy el órgano es la SETSI.

    #no-esta[Art. 20 de la Orden IET/1311/2013, una vez obtenida la licencia: cualquier modificación de instalaciones y equipos puede hacerse con carácter experimental durante un máximo de 60 días, siempre que no afecte a la seguridad. Si se hace permanente, el titular remite a la SETSI la documentación complementaria, incluidas las modificaciones. Excepción: si la modificación incluye cambiar la ubicación de la antena, se solicita a la SETSI como si fuera la primera instalación.]],
)

#q("C-R8.16", "d",
  [Según el Reglamento de Radiocomunicaciones de la UIT:],
  ([El Servicio de Aficionados por Satélite no es un servicio de radiocomunicación.], [La banda 144,00–146,00 MHz no está atribuida al Servicio de Aficionados.], [Las estaciones de aficionado nunca pueden ser utilizadas para la transmisión de comunicaciones internacionales en nombre de terceros.], [Una estación de aficionado es una estación del Servicio de Aficionados.]),
  sol: [Es la definición del Reglamento de Radiocomunicaciones (art. 1): una estación de aficionado es una estación del Servicio de Aficionados (la Orden IET/1311/2013, Anexo I, añade la del Servicio de Aficionados por Satélite). Las otras tres son falsas. El Servicio de Aficionados por Satélite sí es un servicio de radiocomunicación: usa estaciones espaciales situadas en satélites con los mismos fines que el Servicio de Aficionados. La banda 144–146 MHz (la de 2 m) sí está atribuida al Servicio de Aficionados. Y «nunca» es demasiado tajante: el tráfico en nombre de terceros se admite en casos de emergencia o desastre (art. 25 del Reglamento de Radiocomunicaciones y art. 30.3 de la Orden). #vease[(Véase tema R8, introducción (marco de la UIT) y sección «Uso de la estación y otras cuestiones».)]

    #no-esta[El Reglamento de Radiocomunicaciones (art. 1) define el #emph[Servicio de Aficionados] como el servicio de radiocomunicación de instrucción individual, intercomunicación y estudios técnicos efectuados por radioaficionados (personas autorizadas que se interesan por la radiotecnia sin fines de lucro); el #emph[Servicio de Aficionados por Satélite] usa estaciones espaciales para los mismos fines, y una #emph[estación de aficionado] es una estación de cualquiera de esos dos servicios. Las comunicaciones en nombre de terceros solo se permiten en emergencias o desastres (art. 30.3 de la Orden).]],
)

#q("C-R8.17", "c",
  [La instalación, en el exterior de los edificios, del sistema radiante de una estación de radioaficionado, ¿puede ser realizada por el propio radioaficionado?],
  ([Siempre.], [Solo puede ser realizada por instalador autorizado.], [Solo aquellas que por su simplicidad así lo autorice el Jefe Provincial de Inspección de Telecomunicaciones.], [Nunca.]),
  sol: [La regla general es que la instalación la haga un instalador de telecomunicaciones inscrito en el registro de empresas instaladoras. Pero el art. 19.e de la Orden IET/1311/2013 añade una excepción: los Jefes Provinciales de Inspección de Telecomunicaciones pueden autorizar que el radioaficionado la haga por sus propios medios cuando, a la vista de la memoria técnica, la instalación sea tan sencilla que no presente razonablemente riesgos para las personas o los bienes. Por eso «siempre» y «nunca» son absolutas, y «solo instalador» olvida la excepción. #vease[(Véase tema R8, sección «Autorización y licencia de estación».)]

    #no-esta[Art. 19.e de la Orden IET/1311/2013: como norma general, las instalaciones de estaciones fijas las efectúa un instalador de telecomunicaciones inscrito en el registro de empresas instaladoras. Excepción: el Jefe Provincial de Inspección de Telecomunicaciones puede autorizar al radioaficionado a hacerlas por sus propios medios si, vista la memoria técnica, son tan simples que no presentan riesgos razonables para personas o bienes. La resolución que autoriza el montaje fija en cada caso si hace falta instalador o no (art. 19.g).]],
)

#q("C-R8.18", "d",
  [Señale la proposición incorrecta:],
  ([Las antenas y elementos anejos se instalarán de forma que no produzcan molestias, peligro o daño a personas o bienes.], [En los casos en que las antenas se sitúen en azoteas o lugares transitables se señalizarán los anclajes y riostras.], [La instalación de las antenas se hará de modo que se respeten las separaciones entre ellas y los elementos, instalaciones y antenas de otros servicios para que estos no resulten degradados en su funcionamiento.], [Las antenas y elementos anejos, y en particular, soportes, anclajes y riostras deberán ser de materiales endebles y de fácil instalación para facilitar su posterior desmontaje.]),
  sol: [La falsa es la d: el Reglamento de antenas (RD 2623/1986, art. 16) exige lo contrario. Las características mecánicas de antenas y elementos anejos deben responder a las normas de la buena construcción y soportar los esfuerzos de uso, y soportes, anclajes y riostras han de ser de materiales resistentes a la corrosión o tratados convenientemente. Nada de materiales «endebles»: una antena mal sujeta puede caer sobre personas o bienes. Las otras tres afirmaciones son ciertas (arts. 12 y 13 del mismo Reglamento): no causar molestias, peligro ni daño, señalizar anclajes y riostras en azoteas y lugares transitables, y respetar las separaciones con otros servicios. #vease[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

    #no-esta[RD 2623/1986, art. 16: las antenas y elementos anejos deben responder a las normas de la buena construcción y ser capaces de absorber los esfuerzos de uso, teniendo en cuenta las condiciones ambientales del lugar; soportes, anclajes y riostras deben ser de materiales resistentes a la corrosión o tratados convenientemente. Regla práctica en una pregunta de «proposición incorrecta» sobre antenas: si una opción sacrifica la seguridad o la resistencia mecánica por comodidad (materiales débiles, fáciles de desmontar), es la falsa.]],
)

#q("C-R8.19", "b",
  [Para la instalación y funcionamiento de una estación fija de radioaficionado es necesario obtener:],
  ([Únicamente la autorización de radioaficionado, sin más trámites.], [La licencia de estación fija, asociada a la autorización de radioaficionado de su titular.], [Nada.], [Solo el certificado HAREC.]),
  sol: [El art. 18.1 de la Orden IET/1311/2013 lo dice literalmente: la instalación y funcionamiento de cualquier estación fija precisa de una licencia, que se considera asociada a la autorización de radioaficionado de su titular. La autorización sola habilita para emitir desde estaciones móviles o portátiles, pero para la estación fija hace falta además la licencia (arts. 19 y 20). El HAREC solo acredita haber aprobado el examen y da derecho a pedir la autorización. «Nada» es absurdo: emitir exige siempre autorización previa. Si el examen pregunta sin acotar («una estación de aficionado») con las opciones antiguas, el banco da por buena la «licencia de estación». #vease[(Véase tema R8, sección «Autorización y licencia de estación».)]

    #no-esta[Autorización y licencia son cosas distintas. La #emph[autorización de radioaficionado] (art. 5) es personal y habilita para emitir desde estaciones móviles o portátiles y desde estaciones fijas que tengan licencia. Para una #emph[estación fija] hace falta además la #emph[licencia de estación] (art. 18.1), asociada a la autorización: se solicita a la SETSI o a la Jefatura Provincial, se monta la instalación autorizada y, terminada, se comunica a la Jefatura en 6 semanas (art. 20), que dispone de 30 días para verificarla y expedir la licencia.]],
)

#q("C-R8.20", "d",
  [Los extranjeros que acrediten la condición de residentes en España podrán ser titulares de autorizaciones de radioaficionado españolas en los siguientes casos, indique la alternativa incorrecta:],
  ([Cuando sean titulares de un certificado HAREC expedido por cualquier país que haya aplicado la Recomendación CEPT T/R 61-02.], [Cuando exista Acuerdo o Convenio de reciprocidad en la materia con el país que otorgó su licencia de radioaficionado original.], [Cuando superen en España la prueba de capacitación para operar estaciones de radioaficionado.], [Siempre que el país de origen del radioaficionado aplique la Recomendación T/R 5000.]),
  sol: [Según el art. 5.2 de la Orden IET/1311/2013, un extranjero residente obtiene la autorización española sin repetir el examen si tiene un certificado HAREC expedido por un país que aplique la T/R 61-02 (opción a) o si hay acuerdo o convenio de reciprocidad con el país que le dio su licencia original (opción b); y, como cualquier aspirante, si supera en España la prueba de capacitación (opción c). La d es la incorrecta: que su país aplique una «Recomendación T/R 5000» no es ningún supuesto del art. 5.2. Las recomendaciones CEPT que cuentan son la T/R 61-01 (licencia CEPT) y la T/R 61-02 (HAREC). El enunciado original citaba el «diploma de operador», figura anterior que hoy equivale al HAREC; la incorrecta es la misma. #vease[(Véase tema R8, sección «Usos especiales y casos particulares».)]

    #no-esta[Art. 5.2 de la Orden IET/1311/2013: el extranjero debe acreditar documentalmente su condición de residente en España. Se le exime de superar la prueba solo en dos casos: a) es titular de un HAREC expedido por un país que haya aplicado la T/R 61-02; b) existe acuerdo o convenio de reciprocidad con el país que otorgó su licencia original. Fuera de esos casos, debe aprobar la prueba de capacitación como cualquier otro aspirante.]],
)

#q("C-R8.21", "c",
  [No es un requisito que habrá de constar necesariamente en la licencia de estación de radioaficionado CEPT:],
  ([Nombre y dirección del titular.], [Distintivo de llamada.], [Fecha de superación del examen.], [Autoridad que expide la licencia.]),
  sol: [El art. 12 de la Orden IET/1311/2013 enumera lo que ha de constar necesariamente en la licencia CEPT: la declaración que autoriza al titular a usar su estación en los términos de la T/R 61-01 en cualquier país que la haya adoptado, su nombre y dirección, el distintivo de llamada, el período de validez y la autoridad que la expide. La fecha en que se superó el examen no figura: el examen lo acredita el certificado HAREC (T/R 61-02), no la licencia. Nombre y dirección, distintivo y autoridad emisora sí son obligatorios.

    #no-esta[Contenido obligatorio de la licencia CEPT (art. 12): 1) declaración de que autoriza al titular a utilizar su estación, en los términos de la Recomendación T/R 61-01, en cualquier país que la haya adoptado; 2) nombre y dirección del titular; 3) distintivo de llamada; 4) período de validez; 5) autoridad que la expide. Regla: identifica al titular y a su indicativo, dice hasta cuándo vale y quién la da; el examen no aparece. En España, la autorización de radioaficionado tiene la consideración de licencia CEPT (art. 11).]],
)

#q("C-R8.22", "c",
  [¿Definiría «Estación automática desatendida» como?:],
  ([Estación de emisiones no deseadas.], [Estación repetidora de poco uso.], [Estación colectiva de aficionado, que para su funcionamiento habitual no requiere la intervención directa del operador.], [Estación de mediciones de potencia.]),
  sol: [Es la definición literal del Anexo I de la Orden IET/1311/2013: estación colectiva de radioaficionado que, para su funcionamiento habitual, no requiere la intervención directa del operador (repetidores, radiobalizas…). Las otras opciones son inventadas: no tiene nada que ver con las emisiones no deseadas ni con medir potencia, y un repetidor sigue siéndolo aunque se use poco: lo que define a la estación es que funciona sin operador, no cuánto se use. Ojo al matiz: toda estación desatendida es colectiva, pero no toda estación colectiva es desatendida. #vease[(Véase tema R8, sección «Estaciones desatendidas, repetidores y radiobalizas».)]

    #no-esta[Anexo I de la Orden IET/1311/2013: #emph[estación colectiva] es la estación de radioaficionado cuya titularidad corresponde a una asociación de radioaficionados reconocida; #emph[estación automática desatendida] es una estación colectiva que para su funcionamiento habitual no requiere la intervención directa del operador. Según el art. 24, son desatendidas los repetidores analógicos y digitales, los repetidores de portadora o nodo, los repetidores finales y las radiobalizas. Solo las asociaciones reconocidas pueden instalarlas (art. 18.6), y por eso se consideran colectivas (art. 18.4).]],
)

#q("C-R8.23", "a",
  [En el Servicio de Aficionados, ¿cuál de las siguientes proposiciones es correcta?],
  ([La revocación de la autorización de radioaficionado lleva aparejada la cancelación de la licencia de la estación fija asociada.], [Todo radioaficionado deberá, como mínimo, esperar cinco años para poder solicitar la cancelación de su autorización.], [La normativa vigente en materia de radioaficionados contempla un límite de edad para poder ser titular de una autorización de radioaficionado.], [El titular de una licencia de estación fija de aficionado siempre precisa autorización previa administrativa para utilizarla como portable.]),
  sol: [Según el art. 21.1.b de la Orden IET/1311/2013, la licencia de estación fija se cancela por revocación o extinción de la autorización de radioaficionado a la que está asociada. Las demás son falsas: la autorización conserva su vigencia mientras el titular no renuncie (art. 5.4), sin plazo mínimo; no hay límite de edad, y el menor solo aporta el escrito fehaciente de sus padres o tutores (art. 19.f); y usar la estación como portable no exige autorización previa, solo notificarlo a la Jefatura Provincial con 5 días de antelación, y ni eso en los usos no continuados de hasta 15 días naturales (art. 17.1). El enunciado original hablaba de «licencias de los equipos»; hoy la licencia es de la estación fija. #vease[(Véase tema R8, secciones «Autorización y licencia de estación» y «Uso de la estación y otras cuestiones».)]

    #no-esta[Art. 21 de la Orden IET/1311/2013: la licencia de estación fija se cancela a) en cualquier momento a petición de su titular; b) por revocación o extinción de la autorización de radioaficionado a la que está asociada; c) automáticamente si no se mantiene vigente el seguro de antenas. Al cancelarse la licencia, el titular debe desmontar la instalación, antenas incluidas, con todos los gastos a su cargo.]],
)

#q("C-R8.24", "d",
  [Entre las condiciones de utilización de la licencia CEPT señaladas en el Reglamento de Aficionados, no se encuentra una de las siguientes. Indíquela:],
  ([Dicha licencia habilita para las utilizaciones de estaciones portables y móviles.], [Su titular viene obligado a presentar la licencia a petición de las autoridades del país visitado.], [El titular no podrá solicitar protección contra las interferencias perjudiciales.], [La licencia permitirá utilizar todas las bandas de frecuencias atribuidas al Servicio de Aficionados, autorizadas en su país, aunque no lo estén en el país donde va a operar la estación.]),
  sol: [La condición que no existe es la d, que invierte el art. 14.b de la Orden IET/1311/2013: la licencia CEPT solo permite usar las bandas que estén autorizadas, y en las condiciones que se apliquen, en el país donde se va a operar, no las de tu país de origen. Las otras son ciertas: presentar la licencia a petición de las autoridades del país visitado (art. 14.c) y no poder solicitar protección contra interferencias perjudiciales al emitir fuera del territorio nacional (art. 14.f). La a describe el uso propio de la licencia CEPT, con estaciones portables y móviles en estancias temporales, y así figuraba en el reglamento anterior; es cierta, y no contradice nada. #vease[(Véase tema R8, sección «Usos especiales y casos particulares».)]

    #no-esta[Condiciones de uso de la licencia CEPT (art. 14 de la Orden IET/1311/2013): a) en España, las estaciones con licencia CEPT siguen el reglamento español; b) se usan las bandas del Servicio de Aficionados autorizadas, y en las condiciones que apliquen, en el país donde se opera; c) se presenta la licencia a petición de las autoridades del país visitado; d) se respeta el Reglamento de Radiocomunicaciones y la normativa local; e) se emite con el distintivo propio precedido del país visitado; f) no se puede pedir protección contra interferencias perjudiciales. Regla: fuera de casa mandan las normas del país visitado.]],
)

#q("C-R8.25", "d",
  [En relación con la instalación en el exterior de un inmueble de una antena de estación de aficionado, el punto o elemento de fijación de las riostras en la obra civil del inmueble, repartiendo los esfuerzos mecánicos, se conoce con el nombre de:],
  ([Mástil.], [Soporte.], [Plano de paso.], [Anclaje.]),
  sol: [Las riostras son los cables o piezas que aseguran la estabilidad mecánica de la antena; el punto o elemento donde se fijan a la obra civil del inmueble, repartiendo los esfuerzos, se llama anclaje (definición del art. 1 del RD 2623/1986). Los demás términos designan otras cosas: el mástil es el poste que sirve de antena o la sostiene, el soporte es el elemento o conjunto de elementos que sustenta la antena, y el plano de paso es la superficie accesible a las personas situada bajo la antena y sus elementos anejos. #vease[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

    #no-esta[Vocabulario del Reglamento de antenas (RD 2623/1986, art. 1): #emph[mástil], poste que sirve de antena o la soporta; #emph[soporte], elemento mecánico que sustenta la antena; #emph[riostra], cable, hilo o pieza que da estabilidad mecánica; #emph[anclaje], punto o elemento de fijación de las riostras a la obra civil del inmueble, repartiendo los esfuerzos; #emph[plano de paso], superficie accesible a personas bajo la antena. Truco: la riostra tira, el anclaje la agarra al edificio.]],
)

#q("C-R8.26", "d",
  [La licencia CEPT de un radioaficionado español:],
  ([Solamente le permite hacer uso de ella dentro del territorio español.], [No le habilita para utilizar estaciones portables.], [Se la concederá la autoridad competente del país europeo que vaya a visitar.], [Le permite la utilización de todas las bandas atribuidas al Servicio de Aficionados autorizadas en el país donde se va a operar la estación.]),
  sol: [El art. 14.b de la Orden IET/1311/2013 dice que la licencia CEPT permite usar todas las bandas atribuidas al Servicio de Aficionados (y al de aficionados por satélite) que estén autorizadas, y en las condiciones que apliquen, en el país donde se va a operar. Las otras son falsas: a) la licencia CEPT sirve precisamente fuera de España, en los países que hayan adoptado la T/R 61-01; b) sí ampara el uso temporal de estaciones portables y móviles; c) no la concede el país visitado: la expide tu propia Administración y, en España, la autorización de radioaficionado ya tiene la consideración de licencia CEPT (art. 11). #vease[(Véase tema R8, sección «Usos especiales y casos particulares».)]

    #no-esta[Art. 11 de la Orden IET/1311/2013: se llama licencia CEPT a la expedida por un país que haya adoptado la Recomendación T/R 61-01, y la autorización de radioaficionado española tiene a todos los efectos esa consideración. Art. 14.b: con ella se usan las bandas del Servicio de Aficionados (y del de aficionados por satélite) autorizadas, y en las condiciones que apliquen, en el país donde se opera. Consecuencia práctica: si una banda no está permitida en el país visitado, no puedes usarla aunque en España sí lo esté.]],
)

#q("C-R8.27", "d",
  [En el país visitado temporalmente, el radioaficionado está obligado a:],
  ([Pedir indicativo de dicho país.], [Presentar copia de su expediente.], [Solicitar permiso de antenas.], [Presentar la autorización de radioaficionado, si las autoridades se lo exigen.]),
  sol: [El art. 14.c de la Orden IET/1311/2013 obliga al titular de una licencia CEPT a presentarla a petición de las autoridades del país visitado; en España la autorización de radioaficionado hace de licencia CEPT (art. 11), de ahí que la opción hable de «autorización». Las otras obligaciones no existen: no hay que pedir indicativo del país visitado, porque se emite con el distintivo propio precedido de la designación de ese país (art. 14.e); no se presenta copia de ningún expediente; y tampoco hay que solicitar permiso de antenas, porque la licencia CEPT ya ampara el uso temporal, sujeto a las condiciones locales. #vease[(Véase tema R8, sección «Usos especiales y casos particulares».)]

    #no-esta[Obligaciones del titular de una licencia CEPT en el país visitado (art. 14 de la Orden IET/1311/2013): presentar la licencia cuando lo pidan las autoridades (14.c); respetar el Reglamento de Radiocomunicaciones y la normativa local, incluidas las diferencias de atribución entre Regiones UIT (14.d); emitir con su distintivo nacional precedido de la designación del país visitado (14.e); y aceptar que no puede reclamar protección contra interferencias perjudiciales (14.f).]],
)

#q("C-R8.28", "b",
  [La autorización administrativa de uso del espectro radioeléctrico por radioaficionados:],
  ([Puede ser objeto de transferencia.], [Para su obtención se requerirá haber superado la prueba de capacitación (certificado HAREC).], [Nunca podrá ser objeto de revocación.], [Tiene naturaleza de autorización colectiva.]),
  sol: [Según el art. 5 de la Orden IET/1311/2013, la autorización es individualizada (5.1), requiere haber superado la prueba de capacitación (5.2; quien la supera recibe el certificado HAREC, art. 10.3) y tiene carácter personal y no transferible (5.4). Por eso a y d son falsas. La c también: puede revocarse en los supuestos del art. 8 (por ejemplo, por emisiones con fines comerciales o lucrativos) y se extingue con el fallecimiento del titular. Solo los extranjeros residentes con HAREC extranjero o con convenio de reciprocidad se libran de examinarse (art. 5.2). El enunciado original hablaba del «diploma de operador», figura anterior que hoy equivale al HAREC. #vease[(Véase tema R8, introducción y sección «Uso de la estación y otras cuestiones»; tema R7.)]],
)

#q("C-R8.29", "b",
  [Para instalar una antena en un edificio en régimen de propiedad horizontal:],
  ([Se necesita autorización expresa de la Comunidad de Propietarios.], [Se comunicará a la Administración la dirección del Presidente de la Comunidad de Propietarios.], [No se precisa contratar un seguro para garantizar posibles responsabilidades.], [No será necesario tener en cuenta las características mecánicas de la misma.]),
  sol: [En la solicitud hay que hacer constar la dirección del presidente de la comunidad de propietarios (RD 2623/1986, art. 2.4): así la Administración, una vez aceptada la memoria de instalación, puede comunicársela para que alegue en dos meses sobre la idoneidad del emplazamiento o los perjuicios (art. 3). Las demás son falsas: la comunidad no concede la autorización, solo puede pronunciarse sobre la idoneidad de la instalación; el seguro de responsabilidad civil es obligatorio (art. 20); y las características mecánicas de la antena y sus elementos anejos deben responder a las normas de la buena construcción (art. 16). #vease[(Véase tema R8, sección «Antenas y comunidad de propietarios».)]

    #no-esta[Procedimiento con comunidad de propietarios (RD 2623/1986, arts. 2.4 y 3): el solicitante hace constar en la solicitud la dirección del presidente; aceptada la memoria, la Administración se lo comunica a la comunidad, que dispone de dos meses para alegar sobre la idoneidad del emplazamiento o los perjuicios a elementos privativos y comunes; si no contesta, se entiende que acepta tácitamente. La comunidad informa, no autoriza ni prohíbe.]],
)

#q("C-R8.30", "b",
  [Una de las siguientes bandas que se citan a continuación precisa autorización especial de uso. Señálela:],
  ([47,00–47,20 GHz.], [24,050–24,250 GHz.], [14.000–14.250 kHz.], [50,000–51,000 MHz.]),
  sol: [La disposición adicional segunda de la Orden IET/1311/2013 fija las bandas cuyo uso exige autorización especial: 2.300–2.450 MHz (salvo 2.316–2.332 MHz), 5.650–5.850 MHz (salvo 5.700–5.720 y 5.760–5.762 MHz) y 24,050–24,250 GHz. Por eso la respuesta es la b. Las demás no figuran en esa relación: 47 GHz, 14 MHz (la banda de 20 m) y 50 MHz (la de 6 m). Aviso: el banco da como clave, en su versión antigua, «10,00–10,5 GHz»; esa banda figuraba en la relación del reglamento anterior (Orden ITC/1791/2006) y ya no está en la vigente. Si te aparece así en el examen, es la que el banco da por buena. #vease[(Véase tema R8, tabla de cifras y sección «Usos especiales y casos particulares».)]

    #no-esta[Art. 16 y disposición adicional segunda de la Orden IET/1311/2013: cuando en una banda atribuida con carácter secundario hay riesgo de interferir a servicios primarios, su uso requiere autorización especial de la SETSI, a solicitud del interesado. Relación inicial: 2.300–2.450 MHz (salvo 2.316–2.332), 5.650–5.850 MHz (salvo 5.700–5.720 y 5.760–5.762) y 24,050–24,250 GHz. El reglamento anterior incluía también 10,00–10,5 GHz, y es la banda que el banco antiguo da por respuesta.]

    #_apb2-clave[«10,00-10,5 GHz.». Es la clave que dan las recopilaciones de exámenes reales (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea la técnicamente correcta.]],
)

#q("C-R8.31", "c",
  [El certificado de examen armonizado de radioaficionado (HAREC), que sustituye al antiguo diploma de operador:],
  ([Lo hay de diversas clases.], [Lleva implícita la autorización para el uso del espectro radioeléctrico.], [Certifica la capacidad de su titular para operar estaciones radioeléctricas del Servicio de Aficionados.], [Habilita para hacer uso común del espectro radioeléctrico.]),
  sol: [El HAREC se expide a quien supera las dos partes de la prueba de capacitación (art. 10.3 de la Orden IET/1311/2013) y certifica su capacidad para operar estaciones del Servicio de Aficionados. Por sí solo no autoriza nada: solo habilita para solicitar la autorización de radioaficionado, previo pago de la tasa. Por eso b es falsa, y d también: el uso del espectro por radioaficionados es un uso especial (art. 2), que exige la autorización, no un uso común. Tampoco hay clases (a): la prueba es única y el certificado también. El antiguo diploma de operador es la figura que el HAREC sustituyó. #vease[(Véase tema R7 y tema R8, sección «Uso de la estación y otras cuestiones».)]],
)

#q("C-R8.32", "c",
  [En relación con la licencia CEPT, señale la alternativa falsa:],
  ([Habilita a su titular a operar su estación de radioaficionado en el territorio de aquellos países que hayan adoptado la Recomendación CEPT T/R 61-01.], [La utilización a que habilita es de forma temporal.], [Se concede a través del certificado HAREC.], [En ella ha de constar, entre otros datos, el distintivo de llamada y su período de validez.]),
  sol: [Se pide la afirmación falsa. La a es el art. 11 de la Orden IET/1311/2013: la licencia CEPT habilita para operar en los países que han adoptado la T/R 61-01. La b es cierta: esa recomendación regula el uso #emph[temporal] de la estación en estancias en otro país (art. 13). La d es el art. 12: deben constar el distintivo de llamada y el período de validez. La falsa es la c: el HAREC es el certificado del #emph[examen] armonizado (T/R 61-02); solo permite solicitar la autorización, y la licencia CEPT la expide la Administración (la autorización española ya tiene esa consideración, art. 11). El banco da por falsa la b, pero contradice el art. 13: se corrige a la c. #vease[(Véase tema R8, introducción (recuadro sobre T/R 61-01 y T/R 61-02) y sección «Usos especiales y casos particulares».)]

    #no-esta[La licencia CEPT es la expedida por un país que ha adoptado la T/R 61-01; las autorizaciones españolas tienen esa consideración (art. 11 de la Orden IET/1311/2013). Según el art. 12 debe constar: la declaración que autoriza a usar la estación en cualquier país que aplique la recomendación, nombre y dirección del titular, distintivo de llamada, período de validez y autoridad que la expide. No se confunde con el HAREC (T/R 61-02): certificado que se obtiene al aprobar el examen y que permite solicitar la autorización (art. 10.3).]

    #_apb2-clave[«La utilización a que habilita es de forma temporal.». Es la clave que dan las recopilaciones de exámenes reales (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea la técnicamente correcta.]],
)

#q("C-R8.33", "d",
  [Para operar estaciones en el país visitado temporalmente, el radioaficionado está obligado a:],
  ([Pedir indicativo en dicho país.], [Presentar copia de su expediente.], [Solicitar permiso de antenas.], [Presentar la autorización de radioaficionado a petición de las autoridades.]),
  sol: [Es una de las condiciones de uso de la licencia CEPT (art. 14.c de la Orden IET/1311/2013): su titular está obligado a presentarla a petición de las autoridades del país visitado. Para un español, su autorización de radioaficionado tiene la consideración de licencia CEPT (art. 11). Las demás opciones no figuran entre las condiciones del art. 14: en el país visitado no se pide un distintivo nuevo, sino que se usa el propio precedido de la designación de ese país (art. 14.e). No hay que confundirlo con otro deber distinto: respetar la reglamentación local (art. 14.d). #vease[(Véase tema R8, sección «Usos especiales y casos particulares» (obligaciones del titular de una licencia CEPT).)]

    #no-esta[Art. 14 de la Orden IET/1311/2013, condiciones de la licencia CEPT: a) en España, sujeta a la Orden; b) vale para todas las bandas del servicio autorizadas en el país visitado; c) hay que presentarla a petición de las autoridades del país visitado; d) se respeta el Reglamento de Radiocomunicaciones y la normativa local; e) se usa el distintivo nacional precedido de la designación del país visitado; f) fuera de tu país no puedes reclamar protección contra interferencias perjudiciales.]],
)

#q("C-R8.34", "d",
  [Una vez obtenida la licencia de una estación fija de radioaficionado, se pueden introducir modificaciones en su sistema radiante:],
  ([Únicamente si las autoriza previamente la SETSI en todos los casos.], [Sí, pero únicamente si el titular lleva más de cinco años con autorización.], [Sí, pero sin cambiar nunca el sistema de sujeción de la antena.], [Sí, con carácter general; las modificaciones permanentes se comunican a la SETSI con la documentación actualizada, y el cambio de ubicación de la antena se solicita como una primera instalación.]),
  sol: [Según el art. 20 de la Orden IET/1311/2013, con la licencia ya concedida el titular puede modificar instalaciones y equipos, con carácter experimental hasta 60 días y siempre que no afecte a la seguridad. Si la modificación es permanente, remite a la SETSI la documentación complementaria actualizada; y si cambia la ubicación de la antena, la solicita como una primera instalación. Por eso fallan la a (no se exige autorización previa en todos los casos), la b (no hay requisito de antigüedad) y la c (no se prohíbe cambiar la sujeción). El banco original hablaba de «licencias de clase A y B» y de la DGTel, régimen anterior ya desaparecido; la pregunta se ha actualizado. #vease[(Véase tema R9, pregunta sobre la comunicación de las modificaciones permanentes de una instalación.)]

    #no-esta[Art. 20 de la Orden IET/1311/2013 (licencia de estación fija). Con la licencia concedida, cualquier modificación de las instalaciones y equipos puede hacerse con carácter experimental durante un máximo de 60 días, siempre que no afecte a la seguridad. Si se hace permanente, el titular remite a la SETSI la documentación complementaria (la del art. 19) con las modificaciones incluidas. Si la modificación cambia la ubicación de la antena, se solicita a la SETSI igual que la primera instalación.]],
)

#q("C-R8.35", "b",
  [¿Está permitido que una estación de aficionado se conecte con otras instalaciones de telecomunicación?],
  ([Sí.], [Sí, cumpliendo ciertas condiciones.], [Sí, limitando la duración del enlace.], [No.]),
  sol: [Sí se puede, pero con condiciones. El art. 23 de la Orden IET/1311/2013 permite interconectar las estaciones a través de otras instalaciones de telecomunicación autorizadas siempre que la interconexión tenga fines relacionados con la radioafición; los dispositivos de conexión a redes públicas no pueden causar daños ni interferencias, y el acceso por red pública a repetidores analógico-digitales exige un código personal y el distintivo del operador. La norma no limita la duración del enlace (c). El banco repite la pregunta con las opciones «No está permitido», «Sí, mediante autorización», «Sí, siempre que se pasen comunicaciones técnicas» y «Sí está permitido»: allí la clave es la última, pues no exige autorización específica ni limita el contenido a comunicaciones técnicas.

    #no-esta[Art. 23 de la Orden IET/1311/2013: las estaciones de radioaficionado pueden interconectarse a través de otras instalaciones de telecomunicación autorizadas si la finalidad está relacionada con la radioafición. Los dispositivos para conectarse a redes públicas deben estar diseñados para no dañar ni interferir esas redes. Si el acceso es por red pública, los repetidores analógico-digitales solo son accesibles con un código personal e intransferible y el distintivo de la estación del operador; el responsable del repetidor debe facilitar el código a todo radioaficionado que lo solicite.]],
)

#q("C-R8.36", "c",
  [La estación de aficionado debe estar construida:],
  ([Siempre con válvulas.], [Completamente transistorizada.], [De acuerdo con el estado de desarrollo de la técnica radioeléctrica.], [Con arreglo a un modelo común.]),
  sol: [La normativa no impone una tecnología ni un modelo único de equipo: ni válvulas, ni transistores, ni un diseño común. El equipo puede ser comercial (con marcado CE) o de construcción propia (art. 5.5 y 5.6 de la Orden IET/1311/2013); lo que se exige es que cumpla las características técnicas del anexo I (emisiones no esenciales limitadas, filtro paso bajo, medios para comprobar la banda y la potencia). Es decir, debe construirse con buena práctica radioeléctrica, según el estado de la técnica. La fórmula literal de la opción c no figura en la Orden vigente, pero es la única que describe lo que se exige. #vease[(Véase tema R8, sección «Usos especiales y casos particulares» (equipos de construcción propia), y tema T5, sección «Emisiones no deseadas».)]

    #no-esta[El anexo I de la Orden IET/1311/2013 (apartado 4) fija las prescripciones técnicas: las emisiones no esenciales por debajo de 30 MHz deben quedar 40 dB por debajo de la potencia media sin exceder de 50 mW; la estación debe tener elementos para comprobar que emite dentro de la banda y medir de forma indicativa la potencia, y redes adaptadoras de impedancia y filtros paso bajo supresores de armónicos. Eso es construir «según el estado de la técnica»; la norma no prescribe válvulas, transistores ni un modelo.]],
)

#q("C-R8.37", "b",
  [Estación móvil de aficionado:],
  ([Estación de aficionado instalada en vehículo o en segundo domicilio.], [Estación que puede ser utilizada en movimiento o mientras está detenida en puntos no determinados.], [Estación que se puede transportar para utilizarla solamente en puntos no determinados.], [Es toda estación de aficionado destinada a ser utilizada en movimiento.]),
  sol: [El anexo I de la Orden IET/1311/2013 define la estación móvil de radioaficionado como la destinada a ser utilizada en movimiento o mientras esté detenida en puntos no determinados: lo que la caracteriza es que carece de ubicación fija, esté o no en marcha. La a confunde la móvil con una estación instalada en un lugar (el segundo domicilio); la c omite el movimiento y añade «solamente»; la d es incompleta, porque también es móvil mientras está detenida en puntos no determinados. La misma definición aparece al revés en el banco: la estación «destinada a ser utilizada en un vehículo en movimiento o mientras está detenido en puntos no determinados» es una estación #emph[móvil], no una temporal, ni una fija, ni una fija/portable. #vease[(Véase tema R8, sección «Tipos de estación» (portátil, portable y fija remota).)]

    #no-esta[Definiciones del anexo I de la Orden IET/1311/2013. #strong[Móvil]: destinada a utilizarse en movimiento o detenida en puntos no determinados. #strong[Portátil]: móvil con antena y fuente de energía incorporadas al propio equipo. #strong[Portable]: fija utilizada con carácter temporal en una ubicación determinada distinta de la habitual. #strong[Fija]: emite y recibe desde una ubicación fija determinada. #strong[Temporal]: la usada en concursos y diplomas, expediciones, demostraciones en colegios, ferias y eventos similares. Regla: móvil = sin ubicación fija; portátil = móvil autosuficiente (antena y batería).]],
)

#q("C-R8.38", "c",
  [Para la utilización de estaciones de radioaficionado es imprescindible obtener la previa autorización de:],
  ([La Marina Mercante.], [El Ministerio de Defensa.], [La Secretaría de Estado de Telecomunicaciones e Infraestructuras Digitales (la SETSI de la Orden IET/1311/2013).], [La Dirección General de Seguridad y Orden Público.]),
  sol: [El uso especial del espectro por radioaficionados requiere una autorización administrativa individualizada, la autorización de radioaficionado, que otorga la SETSI (arts. 5.1 y 7.1 de la Orden IET/1311/2013): es el órgano de la Administración competente en telecomunicaciones. La Marina Mercante, Defensa y Seguridad y Orden Público no la otorgan. En el banco original la respuesta era la «Dirección General de Telecomunicaciones», nombre del órgano en el régimen anterior; hoy ese papel corresponde a la Secretaría de Estado de Telecomunicaciones (SETSI en la Orden de 2013). #vease[(Véase tema R8, sección «Autorización y licencia de estación».)]

    #no-esta[Arts. 5.1 y 7.1 de la Orden IET/1311/2013: el uso del espectro por radioaficionados exige una autorización administrativa individualizada previa, la autorización de radioaficionado, otorgada por la SETSI. La SETSI dicta resolución motivada concediéndola junto con el distintivo de llamada, o denegándola. Para obtenerla hay que superar la prueba de capacitación (art. 5.2) y presentar la solicitud con el resguardo de la tasa (art. 6). El órgano se llamaba Secretaría de Estado de Telecomunicaciones y para la Sociedad de la Información; hoy es la Secretaría de Estado de Telecomunicaciones e Infraestructuras Digitales.]],
)

#q("C-R8.39", "c",
  [Una estación fija es la:],
  ([Que sólo se puede utilizar sin mover de un vehículo determinado.], [Autorizada para su utilización en una ubicación fija y en un único vehículo.], [Autorizada únicamente para su utilización en una ubicación que es fija y que se consigna en la licencia.], [Que solamente puede instalarse dentro de los límites de una provincia.]),
  sol: [El art. 18.1 de la Orden IET/1311/2013 define la estación fija como el conjunto de equipos, soportes y antenas que permiten emitir y recibir desde una ubicación fija determinada; su instalación y funcionamiento precisan la licencia de estación fija, ligada a esa ubicación (cambiar la antena de sitio obliga a pedirlo como una primera instalación, art. 20). Por eso es correcta la c. La a y la b atan la estación a un vehículo, lo propio de la móvil (la b, además, se contradice: una ubicación fija no puede ser un vehículo); la d inventa un límite provincial que no existe. #vease[(Véase tema R8, secciones «Autorización y licencia de estación» y «Tipos de estación».)]

    #no-esta[Art. 18.1 de la Orden IET/1311/2013: estación fija de radioaficionado es el conjunto de equipos, soportes, antenas, cables de interconexión y demás elementos que permiten emitir y recibir señales desde una ubicación fija determinada. Precisa licencia de estación fija, asociada a la autorización de su titular, y una misma licencia puede amparar varios equipos. Se clasifican en individuales y colectivas (estas, solo de asociaciones reconocidas). Las móviles y portátiles no necesitan licencia de estación.]],
)

#q("C-R8.40", "c",
  [Los extranjeros que acrediten la condición de residentes en España podrán ser titulares de autorizaciones de radioaficionado españolas en los siguientes casos, indique la alternativa correcta:],
  ([Cuando sean titulares de un diploma de operador.], [Cuando sean titulares de un certificado expedido por cualquier país.], [Cuando exista Acuerdo o Convenio de reciprocidad en la materia con el país de origen del radioaficionado.], [Siempre que el país de origen del radioaficionado aplique la Recomendación T/R 5000.]),
  sol: [El art. 5.2 de la Orden IET/1311/2013 permite que los extranjeros que acrediten documentalmente su residencia en España obtengan la autorización española, sin superar de nuevo la prueba de capacitación, en dos casos: si poseen un certificado HAREC expedido por un país que aplique la T/R 61-02, o si existe un acuerdo o convenio de reciprocidad con el país que otorgó su licencia original. La c recoge el segundo. La b es falsa porque no vale «cualquier certificado», sino el HAREC; la d cita una recomendación que no es la aplicable (la del examen armonizado es la T/R 61-02); y la a se refiere al antiguo diploma de operador, que ya no figura en el artículo. #vease[(Véase tema R8, sección «Usos especiales y casos particulares» (extranjeros residentes y HAREC).)]

    #no-esta[Regla general (art. 5.2 de la Orden IET/1311/2013): para obtener la autorización hay que superar la prueba de capacitación. Excepción para extranjeros que acrediten documentalmente su residencia en España, que pueden obtenerla sin examen si a) son titulares de un certificado HAREC expedido por cualquier país que haya aplicado la T/R 61-02, o b) existe un Acuerdo o Convenio de reciprocidad con el país que otorgó su licencia original. Resumen: residencia, y además HAREC o reciprocidad.]],
)

#q("C-R8.41", "c",
  [La instalación y funcionamiento de una estación fija de aficionado precisará de una licencia, la cual se considerará asociada a:],
  ([Una asociación legalizada de radioaficionados de la provincia correspondiente.], [La estación automática desatendida más cercana.], [La autorización de radioaficionado de su titular.], [Toda la gama de frecuencias que pueda utilizar.]),
  sol: [Es casi literal el art. 18.1 de la Orden IET/1311/2013: la instalación y el funcionamiento de cualquier estación fija precisan una licencia, que se considera asociada a la autorización de radioaficionado de su titular (y una misma licencia puede amparar varios equipos de la estación). De ahí que la licencia se cancele si la autorización se revoca o se extingue (art. 21). La a es falsa: no hace falta pertenecer a ninguna asociación; la b y la d no tienen sentido, porque la licencia no se liga a un repetidor ni a una gama de frecuencias. Ojo: hoy la licencia de estación solo se exige a las estaciones fijas, no a las móviles o portátiles. #vease[(Véase tema R8, sección «Autorización y licencia de estación».)]

    #no-esta[Art. 18.1 de la Orden IET/1311/2013: la instalación y funcionamiento de cualquier estación fija precisa una licencia, asociada a la autorización de radioaficionado de su titular; una misma licencia puede amparar los diferentes equipos de la estación. Art. 21: la licencia se cancela a petición del titular, por revocación o extinción de la autorización a la que está asociada, o automáticamente si no se mantiene el seguro de antenas; al cancelarla hay que desmontar las instalaciones, antenas incluidas.]],
)

#q("C-R8.42", "c",
  [¿En qué bandas de frecuencias se permite emitir si se dispone de la licencia CEPT?],
  ([Solamente en la banda 1240–1300 MHz.], [Temporalmente en la banda de 10,00 a 10,5 GHz.], [En todas las bandas de frecuencias atribuidas al Servicio de Aficionados en el país visitado.], [Exclusivamente, en las bandas atribuidas al servicio por satélite.]),
  sol: [El art. 14.b de la Orden IET/1311/2013 dice que la licencia CEPT permite utilizar todas las bandas atribuidas al Servicio de Aficionados y al de Aficionados por Satélite que estén autorizadas, y en las condiciones que apliquen, en el país donde se opera. No se limita a una banda concreta (a), a unas microondas (b) ni a los satélites (d). Ojo: «todas» son las del país visitado y con sus condiciones (potencias, categoría primaria o secundaria, etc.), no las del país de origen; por eso hay que conocer la normativa local. #vease[(Véase tema R8, sección «Usos especiales y casos particulares» (licencia CEPT).)]

    #no-esta[Art. 14 de la Orden IET/1311/2013: la licencia CEPT permite utilizar todas las bandas atribuidas al Servicio de Aficionados y al de Aficionados por Satélite que estén autorizadas en el país donde se va a operar y en las condiciones que allí apliquen. Además, el titular debe respetar el Reglamento de Radiocomunicaciones y la reglamentación del país visitado (incluidas las diferencias de atribución entre las tres Regiones UIT), y no puede reclamar protección contra interferencias perjudiciales.]],
)

#q("C-R8.43", "d",
  [La obtención de la autorización de radioaficionado requerirá de:],
  ([Título de operador.], [Permiso de un radio club.], [Carnet de operador.], [Haber superado las pruebas de aptitud.]),
  sol: [El art. 5.2 de la Orden IET/1311/2013 exige superar la prueba de capacitación para operar estaciones de radioaficionado, que consta de dos partes independientes: electricidad y radioelectricidad, y normativa (art. 10). Quien la supera recibe el certificado HAREC y puede solicitar la autorización. El «título» o «carnet» de operador no es un requisito previo, sino (en su antigua forma de diploma) la consecuencia de haber aprobado; y ningún radio club concede permisos: no hace falta ser socio de ninguna asociación. Solo los extranjeros residentes con HAREC o convenio de reciprocidad quedan exentos de la prueba. #vease[(Véase tema R7, pregunta sobre el objeto de la prueba de capacitación y la equivalencia del HAREC, y tema R8, sección «Usos especiales y casos particulares».)]

    #no-esta[Arts. 5.2 y 10 de la Orden IET/1311/2013: la autorización de radioaficionado requiere haber superado la prueba de capacitación, de dos partes independientes: a) electricidad y radioelectricidad para operar una estación; b) normativa reglamentaria (programa en el anexo II, acorde a la T/R 61-02). Quien aprueba ambas recibe el certificado HAREC y queda habilitado para solicitar la autorización, previo pago de la tasa. No hace falta pertenecer a una asociación ni a un radio club.]],
)

#q("C-R8.44", "d",
  [Según la normativa vigente (Orden IET/1311/2013), respecto de la autorización de radioaficionado, indique la alternativa incorrecta:],
  ([Conserva su vigencia mientras su titular no manifieste su renuncia o sea revocada.], [Tendrá carácter personal y no transferible.], [Habilita para el uso de cualquier banda de frecuencias del Servicio de Aficionados con determinadas características técnicas y restricciones geográficas.], [Su titular debe comunicar cada cinco años, de forma fehaciente, su intención de seguir utilizando el espectro radioeléctrico.]),
  sol: [La incorrecta es la d: la obligación de comunicar cada cinco años la intención de seguir usando el espectro quedó suprimida (disposición adicional primera de la Orden IET/1311/2013), así que la autorización no se renueva ni caduca por no hacerlo. Las otras tres son ciertas: conserva su vigencia mientras el titular no renuncie o no sea revocada (art. 5.4); es personal y no transferible (art. 5.4); y habilita para cualquiera de las bandas del servicio con las características técnicas del anexo I, sin perjuicio de las limitaciones de los arts. 16 y 17 (art. 5.3). El enunciado original del banco estaba truncado y sin clave, con una opción obsoleta (el «diploma de operador»); por eso se reformula como pregunta de la incorrecta. #vease[(Véase tema R8, introducción (tabla: «Renovación de la autorización: suprimida») y sección «Autorización y licencia de estación».)]],
)

#q("C-R8.45", "c",
  [¿Puedo realizar transmisiones desde Andorra si tengo la licencia de radioaficionado?],
  ([Sí.], [Solo en caso de emergencia.], [Sí, según el artículo 6, radioaficionados titulares de una licencia extranjera en vigor en el país en el que residen habitualmente, pueden obtener una licencia temporal para usar su estación en territorio andorrano.], [No, en ningún caso.]),
  sol: [Andorra no es territorio español: allí rige su propia normativa de radioafición y el visitante es un radioaficionado extranjero. Por eso no basta con «tener la licencia» (a), ni se limita a emergencias (b), ni está prohibido (d): los titulares de una licencia extranjera en vigor pueden obtener una licencia temporal para usar su estación en territorio andorrano, y eso solo lo dice la c. El número de artículo depende de la versión del reglamento andorrano y no hace falta memorizarlo. El banco original no traía clave; esta se deduce de la normativa andorrana.

    #no-esta[Cada país fija sus condiciones para los visitantes. En España se opera con licencia CEPT (T/R 61-01) o, si el país de origen no la aplica, con autorización temporal de hasta 90 días (arts. 13 a 15 de la Orden IET/1311/2013). En Andorra, según su reglamento de radioafición, los titulares de una licencia extranjera en vigor pueden obtener una licencia para usar una estación temporalmente (la gestiona la Unión de Radioaficionats Andorrans). Andorra no figura entre los países que aplican la T/R 61-01 en la edición de 2024 de la CEPT: la licencia CEPT no vale sin más.]],
)

#q("C-R8.46", "a",
  [En la banda de frecuencias de 1830–1850 kHz, la potencia de cresta de la envolvente (p.c.e.) de las emisiones no deberá ser superior a:],
  ([1000 W], [75 W], [5 W], [50 W]),
  sol: [La tabla del apartado 3.1 del anexo I de la Orden IET/1311/2013 fija 1000 W (p.c.e.) para las bandas de HF, entre ellas la de 1,8 MHz (160 m). El tramo 1830–1850 kHz se atribuye al servicio de aficionados con carácter primario, por lo que se aplica el valor completo; en las bandas atribuidas con carácter secundario (en el CNAF, 1810–1830 kHz) el límite baja al 50% (apartado 3.2), es decir, 500 W. Las otras cifras no corresponden a esta banda: el 50 W, por ejemplo, es el límite de las estaciones desatendidas en HF. El banco original no traía clave. #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe» (1 kW p.c.e. en la mayoría de las bandas de HF).)]

    #no-esta[El anexo I, apartado 3.1, de la Orden IET/1311/2013 da una tabla de potencias máximas por banda: en las de HF, de 160 m (1,8 MHz) a 10 m (28 MHz), 1000 W de potencia de cresta de la envolvente (p.c.e.); en 137 y 475 kHz, 1 W p.i.r.e. El apartado 3.2 añade que en las bandas atribuidas con carácter secundario la potencia máxima no supera el 50% de la tabla. Además, hay que reducirla siempre que sea necesario para no superar 3,5 mW/cm#super[2] en los lugares accesibles a las personas (apartado 3.5).]],
)

#q("C-R8.47", "a",
  [El certificado HAREC (es erróneo afirmar que):],
  ([Permite operar en frecuencias distintas a las autorizadas], [Nunca se expedirá conjuntamente con el diploma de operador], [Permite obtener autorización de radioaficionado en cualquier país que aplique la recomendación CEPT T/R 61-02], [Es internacional]),
  sol: [Se pide la afirmación falsa, y es la a. El HAREC solo acredita que se superó el examen armonizado (T/R 61-02): no autoriza a emitir ni modifica las bandas, frecuencias o potencias permitidas. Para emitir hace falta la autorización de radioaficionado, que se solicita una vez obtenido el certificado (art. 10.3 de la Orden IET/1311/2013), y se usa en las bandas y con las características del Reglamento (art. 5.3). La c es cierta (arts. 5.2.a y 10.3) y la d también: se expide conforme a una recomendación de la CEPT y vale en los países que la aplican. La b no es el error buscado hoy: el HAREC ha sustituido al diploma de operador y ya no hay un diploma con el que expedirlo. #vease[(Véase tema R8, introducción (recuadro sobre T/R 61-01 y T/R 61-02) y sección «Usos especiales y casos particulares».)]

    #no-esta[El HAREC (#emph[Harmonised Amateur Radio Examination Certificate]) es el certificado de examen armonizado que recibe quien supera la prueba de capacitación, conforme a la Recomendación CEPT T/R 61-02 (art. 10.3 de la Orden IET/1311/2013). Solo habilita para solicitar, previo pago de la tasa, la autorización de radioaficionado; por sí mismo no permite emitir. Sustituyó al diploma de operador: con el Reglamento anterior (Orden ITC/1791/2006, derogada) se expedía conjuntamente con él, de modo que la opción b era entonces la falsa. Un banco antiguo que dé b por errónea se apoya en esa norma; con la Orden vigente la respuesta es a.]],
)

#q("C-R8.48", "a",
  [La banda de 7.100 a 7.200 kHz estuvo atribuida a título primario al servicio de radiodifusión (Regiones 1 y 3) hasta el 29 de marzo de 2009 (antigua nota 5.141C del Reglamento de Radiocomunicaciones, CMR-03). Desde esa fecha, en España (Región 1) está atribuida al servicio de:],
  ([Aficionados, a título primario.], [Radiodifusión, a título primario, sin cambios.], [Aficionados, pero solo a título secundario.], [Fijo y móvil terrestre, a título primario.]),
  sol: [La CMR-03 reasignó 7.100 a 7.200 kHz de la radiodifusión al servicio de aficionados y dejó una transición que terminó el 29 de marzo de 2009. Desde entonces, junto con 7.000 a 7.100 kHz, forma la banda de 40 m de la Región 1 (7.000 a 7.200 kHz), atribuida a los aficionados a título primario: la a. La b ignora el cambio. La c es cierta en otras bandas (p. ej. 30 m), no en esta. En la d, fijo y móvil solo figuran como atribución adicional en unos pocos países concretos (notas 5.141A y 5.141B), no como atribución general de la Región 1. Si el examen plantea la pregunta en su forma original, el banco da por buena: «estaba atribuida a título primario al servicio de radiodifusión hasta el 29 de marzo de 2009». #vease[(Véase tema R4, sección «Bandas atribuidas y comunicaciones de catástrofe» (banda de 40 m y carácter primario o secundario) y tema R6, sección «Las tres regiones de la UIT» (el caso de los 40 m).)]

    #no-esta[Desde el 29 de marzo de 2009, fin de la transición fijada por la CMR-03, el servicio de aficionados tiene atribuida a título primario la banda de 7.100 a 7.200 kHz en las Regiones 1 y 3; hasta esa fecha era de radiodifusión (antigua nota 5.141C del Reglamento de Radiocomunicaciones de la UIT). Por eso la banda de 40 m llega hoy hasta 7.200 kHz en la Región 1, España incluida, y hasta 7.300 kHz en la Región 2. «Primario» es uso preferente; «secundario», sin causar interferencias al servicio primario ni reclamar protección frente a él.]],
)

== Tema R9. Inspección y régimen sancionador

#q("C-R9.1", "a",
  [Efectuar radiocomunicaciones con otra estación de la que se es titular constituye, según la legislación vigente, una infracción:],
  ([Ninguna (no es infracción)], [Muy grave], [Leve], [Grave]),
  sol: [Ninguna norma vigente prohíbe ni tipifica esa conducta: no figura en las infracciones muy graves, graves ni leves de los arts. 106 a 108 de la Ley 11/2022, que es la que tipifica las infracciones de los radioaficionados (Orden IET/1311/2013, art. 34). El servicio de aficionados es de «intercomunicación» (art. 2.1) y nada exige que las dos estaciones tengan titulares distintos. No la confundas con la infracción leve de comunicarse con estaciones #emph[no autorizadas] (art. 108.2): aquí ambas lo están. «Falta» es el término del reglamento antiguo; hoy se dice infracción. #vease[(Véase tema R9, tabla de conductas típicas y pregunta sobre la infracción leve de comunicarse con estaciones no autorizadas.)]

    #no-esta[Rige el principio de tipicidad (art. 27 de la Ley 40/2015): solo es infracción administrativa lo que una ley tipifica expresamente. En telecomunicaciones, las infracciones son las de los arts. 106 (muy graves), 107 (graves) y 108 (leves) de la Ley 11/2022, a las que remite la Orden IET/1311/2013 (art. 34). Si una conducta no figura en esas listas, como comunicar entre dos estaciones propias, no es infracción. Lo que sí es leve (art. 108.2) es establecer comunicaciones utilizando estaciones no autorizadas.]],
)

#q("C-R9.2", "a",
  [Emitir distintivos de llamada falsos constituye una infracción:],
  ([Grave], [Muy grave], [Leve], [No es infracción]),
  sol: [Emitir señales de identificación falsas o engañosas se tipificó como infracción #emph[grave] (Ley 32/2003, art. 54.d; Ley 9/2014, art. 77.5). La clave «muy grave» del banco es un error: esa conducta no figura entre las muy graves de ninguna de esas leyes. La Ley 11/2022 vigente ya no la recoge con esas palabras, y las muy graves de su art. 106 son otras, como interceptar comunicaciones ajenas o interferir deliberadamente. Como el distintivo identifica al titular (Orden IET/1311/2013, arts. 27 y 29), usar uno falso sí es infracción, y a efectos de examen la respuesta es «grave», como en R9.2 y R9.15. #vease[(Véase tema R9, tabla de conductas típicas y nota sobre las identificaciones falsas o engañosas.)]

    #_apb2-clave[«Muy grave». Es la clave que dan las recopilaciones de exámenes reales (2007–2011): conviene conocerla por si aparece idéntica en el examen, aunque la respuesta razonada arriba sea la técnicamente correcta.]],
)

#q("C-R9.3", "b",
  [De acuerdo con la Ley General de Telecomunicaciones (Ley 11/2022, de 28 de junio), las infracciones se clasifican en:],
  ([Art. 105 muy graves, art. 106 graves, art. 107 leves.], [Art. 106 muy graves, art. 107 graves, art. 108 leves.], [Art. 106 graves, art. 107 muy graves, art. 108 leves.], [Art. 107 muy graves, art. 108 graves, art. 109 leves.]),
  sol: [Según la Ley 11/2022, de 28 de junio (BOE-A-2022-10757), el art. 105 establece la clasificación (muy graves, graves y leves) y los tres artículos siguientes tipifican cada grado por orden de gravedad: art. 106, las muy graves; art. 107, las graves; art. 108, las leves. Las demás opciones desplazan o invierten la numeración: el art. 105 es la clasificación, no una categoría, y el art. 109 trata ya de las sanciones (multas), no de las infracciones. Regla para recordarlo: a mayor gravedad, menor número de artículo (106, 107, 108). #vease[(Véase tema R9, introducción (tabla de grados y conductas típicas con los arts. 106–108).)]],
)

== Preguntas heredadas del régimen anterior

#ojo[Los bancos de preguntas públicos contienen preguntas cuya clave se apoya en normativa ya derogada (Orden ITC/1791/2006, Ley 32/2003, Ley 9/2014…). Si el Ministerio no las hubiera depurado, podrían aparecer en el examen. Aquí se muestran con la respuesta de los bancos antiguos y con lo que dice la norma vigente. No hay que estudiarlas de memoria: hay que saber #emph[qué] cambió.]

#q("C-H.1", "c",
  [La potencia de un transmisor radioeléctrico de aficionado puede estar definida por:],
  ([El número de vatios que consume el emisor], [La máxima posible de disipación anódica del paso final de salida de radiofrecuencia], [La corriente del paso final multiplicada por la tensión de la red], [La consumida en la etapa intermedia del emisor]),
  sol: [Clave de los bancos antiguos: #strong[c]. #strong[Según la norma vigente:] El anexo I de la Orden IET/1311/2013 define la potencia de la portadora y la potencia de cresta de la envolvente (p.c.e.) como la potencia media suministrada a la línea de alimentación de la antena, y manda medirla, siempre que sea posible, con relación a la potencia de la portadora («Medición de potencia»). Ninguna opción responde a esa definición, porque todas hablan de consumo o de entrada al paso final, y no consta precepto vigente que defina así la potencia de un transmisor. (ninguna opción es correcta hoy). #strong[Consejo:] Ninguna opción es correcta hoy: la potencia se mide en la línea de la antena. Marca c, la clave de los bancos antiguos.],
)

#q("C-H.2", "c",
  [Podrá autorizarse a una o más estaciones de aficionado la utilización temporal de prefijos, manteniendo el resto del distintivo. ¿Cuál será el autorizado para las frecuencias de clase B?],
  ([EB], [ED], [EE], [EF]),
  sol: [Clave de los bancos antiguos: #strong[c]. #strong[Según la norma vigente:] Las «clases» de licencia (A, B y C) ya no existen. El art. 27.1 de la Orden IET/1311/2013 prevé los prefijos temporales ED, EE y EF para concursos, experimentos, ensayos, demostraciones y otros eventos de ámbito local, regional, autonómico o nacional, sin distinguir clases. La correspondencia ED con la clase A, EE con la B y EF con la C era de la Resolución de 13-02-1987, derogada en 2006, así que la premisa de la pregunta carece de sentido hoy. (ninguna opción es correcta hoy). #strong[Consejo:] Sin clave válida hoy. Marca c (EE), la clave de los bancos antiguos: ahora EE es un prefijo temporal más, sin relación con la clase.],
)

#q("C-H.3", "c",
  [Las emisiones en la banda de frecuencias 50,0-51,0 MHz se podrán efectuar:],
  ([Desde cualquier punto del territorio nacional.], [Desde las provincias de Madrid, Toledo y Segovia.], [Desde la provincia de Valencia.], [En todo el territorio nacional si la potencia máxima del equipo es inferior a 50 W.]),
  sol: [Clave de los bancos antiguos: #strong[c]. #strong[Según la norma vigente:] Hoy no hay restricción por provincias: la Orden IET/1311/2013 solo exige autorización especial en 2.300-2.450 MHz, 5.650-5.850 MHz y 24,05-24,25 GHz, con algunas subbandas exceptuadas (disposición adicional segunda), y el CNAF (nota UN-100) permite a los radioaficionados usar 50,0-52,0 MHz en territorio nacional como uso especial, sin causar interferencia perjudicial a la televisión de países vecinos. Las provincias vetadas (Madrid, Toledo, Segovia, etc.) venían de las Instrucciones de la Resolución de 20-09-2006 (apdo. 2), desarrollo de la Orden ITC/1791/2006, derogada. (correcta hoy: #strong[a]). #strong[Consejo:] Marca a: es la correcta con la norma vigente. Los bancos antiguos dan c (Valencia), porque entonces estaban vetadas Madrid, Toledo y Segovia.],
)

#q("C-H.4", "b",
  [¿Con qué potencia máxima de portadora se puede emitir en la banda de frecuencias 50,0-51,0 MHz, de acuerdo con el Reglamento de Radioaficionados?],
  ([50 W.], [100 W.], [150 W.], [200 W.]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] Hoy el límite ya no se da como potencia de portadora: el apartado 3.1 del anexo I de la Orden IET/1311/2013 fija 600 W (p.c.e.) para la banda de 50 MHz, el 50 % si la atribución es secundaria (apdo. 3.2), y el CNAF (nota UN-100) habilita 50,0-52,0 MHz. Los 100 W de portadora eran del anexo I de la Orden ITC/1791/2006, derogada, y de la Resolución de 20-09-2006 (apdo. 2). Ninguna opción (50, 100, 150 o 200 W) es correcta. (ninguna opción es correcta hoy). #strong[Consejo:] Ninguna opción es correcta hoy (600 W p.c.e.). Marca b (100 W), la clave de los bancos antiguos.],
)

#q("C-H.5", "d",
  [Respecto de la autorización de aficionado para uso del espectro radioeléctrico, señale cuál de los siguientes supuestos es erróneo:],
  ([Tendrá carácter personal y no transferible.], [Habilita para el uso de cualquier banda de frecuencias del Servicio de Aficionados con determinadas características técnicas y restricciones geográficas.], [Requerirá disponer previamente del diploma de operador de estación de aficionado.], [El titular no tendrá que comunicar en ningún momento su intención de continuar utilizando el espectro radioeléctrico.]),
  sol: [Clave de los bancos antiguos: #strong[d]. #strong[Según la norma vigente:] La Orden IET/1311/2013 suprimió la obligación de comunicar cada cinco años la intención de seguir usando el espectro (disposición adicional primera): la autorización conserva su vigencia hasta que el titular renuncie o sea revocada (art. 5.4), así que d es hoy cierta, igual que a (art. 5.4) y b (arts. 5.3 y 16.2). La errónea es c, por terminología: ya no hay diploma de operador, sino la prueba de capacitación y el certificado HAREC (arts. 5.2 y 10.3). Los bancos antiguos dan d porque con la Orden ITC/1791/2006 (art. 8.1) sí había que comunicar la continuidad cada cinco años. (correcta hoy: #strong[c]). #strong[Consejo:] Marca c como la errónea hoy (ya no hay diploma de operador, sino prueba de capacitación y HAREC). Los bancos antiguos dan d, que hoy es cierta.],
)

#q("C-H.6", "d",
  [En caso de cancelación de la licencia de estación de aficionado, ¿puede su titular mantener instalado el sistema radiante?],
  ([Nunca.], [Sí, si el sistema es poco voluminoso.], [Siempre que lo autorice la Dirección General de Telecomunicaciones.], [Solo en recepción, previa autorización por escrito de la propiedad del inmueble o, en su caso, de la Comunidad de Propietarios, remitiendo una copia de dicha autorización a la Dirección General de Telecomunicaciones.]),
  sol: [Clave de los bancos antiguos: #strong[d]. #strong[Según la norma vigente:] Cuando se cancela la licencia, cualquiera que sea la causa, el art. 21.2 de la Orden IET/1311/2013 obliga al interesado a desmontar las instalaciones, incluyendo las antenas, con todos los gastos a su cargo, sin excepción alguna. La posibilidad de mantener las antenas solo para recepción, con permiso escrito de la propiedad o de la comunidad de propietarios, era del art. 25 de la Orden ITC/1791/2006, derogada. La opción a es la única coherente con la norma vigente. (correcta hoy: #strong[a]). #strong[Consejo:] Marca a («Nunca»): el art. 21.2 obliga a desmontar las antenas sin excepción. Los bancos antiguos dan d, excepción que hoy no existe.],
)

#q("C-H.7", "a",
  [La utilización con carácter temporal de estaciones fijas, en emplazamientos distintos a los autorizados, no precisará notificación previa a la Jefatura Provincial de Inspección de Telecomunicaciones cuando se efectúe dentro del distrito de residencia del radioaficionado y su duración máxima sea de:],
  ([Tres días naturales consecutivos.], [Cuatro días naturales consecutivos.], [Cinco días naturales consecutivos.], [Seis días naturales consecutivos.]),
  sol: [Clave de los bancos antiguos: #strong[a]. #strong[Según la norma vigente:] Hoy el art. 17.1 de la Orden IET/1311/2013 exige notificar a la Jefatura el uso de estaciones portables con al menos 5 días de antelación, pero no precisan notificación previa los usos temporales no continuados de hasta 15 días naturales consecutivos, sin condición de distrito. Los 3 días dentro del distrito eran del art. 20 de la Orden ITC/1791/2006, derogada. Ninguna opción (de 3 a 6 días) es correcta. (ninguna opción es correcta hoy). #strong[Consejo:] Ninguna opción es correcta hoy (son 15 días, sin límite de distrito). Marca a (tres días), la clave de los bancos antiguos.],
)

#q("C-H.8", "d",
  [Los equipos de radioaficionados de construcción propia:],
  ([No deberán ser presentados en la Jefatura Provincial de Inspección de Telecomunicaciones.], [Solo pueden ser utilizados por radioaficionados con antigüedad mínima de 3 años.], [Se pueden utilizar sin efectuar ningún trámite en la Jefatura Provincial de Inspección de Telecomunicaciones.], [Para ser utilizados deberán ser autorizados por la Jefatura Provincial de Inspección de Telecomunicaciones.]),
  sol: [Clave de los bancos antiguos: #strong[d]. #strong[Según la norma vigente:] El art. 5.6 de la Orden IET/1311/2013 permite usar equipos total o parcialmente de construcción propia sin autorización previa de la SETSI, bajo la responsabilidad del radioaficionado; presentarlos en la Jefatura con una memoria es solo optativo y sirve para obtener una autorización individual acreditativa. Por eso la d ya no es cierta, la c es la más precisa y la a también es compatible con la norma. La presentación obligatoria era del régimen de las Instrucciones de 20-09-2006 (apdo. 8.c), anterior a 2013. (correcta hoy: #strong[c]). #strong[Consejo:] Marca c (vigente; la a también es compatible, porque presentarlos es optativo). Los bancos antiguos dan d, que hoy es falsa.],
)

#q("C-H.9", "a",
  [Conforme a la nota 5.141C del Reglamento de Radiocomunicaciones de la Unión Internacional de Telecomunicaciones:],
  ([La banda 7100 a 7200 kHz está atribuida a título primario al servicio de radiodifusión hasta el 29 de marzo de 2009.], [La banda 144-146 MHz no está atribuida al Servicio de Aficionados.], [La banda 144-146 MHz está atribuida al Servicio de Aficionados hasta el 29 de marzo de 2009.], [La banda 7100-7200 kHz no está atribuida a ningún servicio.]),
  sol: [Clave de los bancos antiguos: #strong[a]. #strong[Según la norma vigente:] La nota 5.141C del Reglamento de Radiocomunicaciones (CMR-03) atribuía 7100-7200 kHz a radiodifusión, a título primario, en las Regiones 1 y 3 solo hasta el 29 de marzo de 2009, y la CMR-12 la suprimió (así consta en el CNAF). Desde entonces esa parte de la banda de 7 MHz es del servicio de aficionados, de modo que la opción a, expresada en presente, ya no es cierta. Las demás tampoco lo eran: los 144-146 MHz nunca han dejado de ser de aficionados. (ninguna opción es correcta hoy). #strong[Consejo:] Ninguna opción es correcta hoy: el plazo venció y la nota se suprimió. Marca a, la clave de los bancos antiguos, que fue cierta hasta 2009.],
)

#q("C-H.10", "b",
  [Como norma general, la potencia máxima de salida de los transmisores de las estaciones desatendidas en las bandas de VHF y UHF, cuando estén instaladas fuera del casco urbano, será:],
  ([Igual que la permitida en la banda de HF.], [25 W.], [Igual que la permitida a las instaladas en el interior del casco urbano.], [35 W.]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] Hoy las estaciones automáticas desatendidas de VHF y UHF pueden emitir hasta 50 W fuera de casco urbano y 10 W dentro (art. 25.h de la Orden IET/1311/2013), y en HF no superan los 50 W (art. 25.i), de modo que la potencia fuera de casco urbano coincide con la de HF (opción a). Los 25 W eran del art. 32.9 de la Orden ITC/1791/2006, derogada, que solo daba 50 W a HF (art. 32.10). En la otra versión del banco, con las opciones 10, 15, 20 y 25 W, ninguna es correcta hoy. (correcta hoy: #strong[a]). #strong[Consejo:] Marca a: 50 W fuera de casco urbano, igual que en HF. Si salen solo 10, 15, 20 y 25 W, ninguna vale hoy: marca 25 W, la clave de los bancos antiguos.],
)

#q("C-H.11", "c",
  [¿Qué edad mínima es necesaria para obtener una licencia de estación de aficionado?],
  ([20 años], [25 años], [15 años], [18 años]),
  sol: [Clave de los bancos antiguos: #strong[c]. #strong[Según la norma vigente:] La Orden IET/1311/2013 no establece una edad mínima: el art. 19.f solo exige a los menores de edad un escrito de autorización, en forma fehaciente, de sus padres o de quienes ostenten su custodia legal, que asumen las responsabilidades del menor titular de la licencia. No consta precepto vigente que fije 15 años ni ninguna otra edad. (ninguna opción es correcta hoy). #strong[Consejo:] Ninguna opción es correcta hoy, porque no hay edad mínima. Marca c (15 años), la clave de los bancos antiguos.],
)

#q("C-H.12", "b",
  [La potencia máxima de emisión, en vatios, permitida al titular de una licencia de aficionado autorizada para trabajar en la banda de 430 a 440 MHz es de:],
  ([30], [50], [25], [100]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] Hoy el apartado 3.1 del anexo I de la Orden IET/1311/2013 fija 300 W (p.c.e.) para 430-440 MHz, reducidos al 50 % en las bandas atribuidas con carácter secundario (apdo. 3.2). Los 50 W eran la potencia de portadora (con 200 W de cresta) del anexo I de la Orden ITC/1791/2006, derogada. Ninguna opción (30, 50, 25 o 100 W) es correcta. (ninguna opción es correcta hoy). #strong[Consejo:] Ninguna opción es correcta hoy. Marca b (50 W), la clave de los bancos antiguos.],
)

#q("C-H.13", "c",
  [¿Cuál es el plazo para que el titular de una licencia de estación móvil notifique a la Dirección General de Telecomunicaciones el traslado de dicha estación a otro vehículo de su propiedad?],
  ([Tres meses], [Un año], [Diez días], [Un mes]),
  sol: [Clave de los bancos antiguos: #strong[c]. #strong[Según la norma vigente:] Hoy no existe licencia de estación móvil ni plazo de notificación por cambiar de vehículo: la licencia solo se exige para las estaciones fijas (art. 18.1 de la Orden IET/1311/2013) y las estaciones móviles o portátiles quedan habilitadas por la propia autorización de radioaficionado (art. 5.3). Los diez días eran del art. 5.8 del Reglamento de Estaciones de Aficionado de 1986, derogado por la Orden ITC/1791/2006. (ninguna opción es correcta hoy). #strong[Consejo:] Ninguna opción es válida hoy. Marca c (diez días), la clave de los bancos antiguos.],
)

#q("C-H.14", "b",
  [¿Se puede utilizar una estación móvil en diferentes vehículos?],
  ([No está permitido], [Sí, cuando las matrículas de los vehículos estén consignadas en la licencia], [Solamente se autoriza para dos vehículos consignando las matrículas], [Se autoriza solamente para concursos]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] Hoy no hay restricción por vehículos: las estaciones móviles o portátiles quedan habilitadas por la propia autorización de radioaficionado (art. 5.3 de la Orden IET/1311/2013) y la licencia se exige solo para las estaciones fijas (art. 18.1), de modo que no se consignan matrículas. Consignarlas en la licencia era una exigencia de la Resolución de 13-02-1987 (apdo. 2), derogada en 2006. Ni la a (prohibido) ni la b (requisito de matrículas) son ciertas hoy. (ninguna opción es correcta hoy). #strong[Consejo:] Ninguna opción es correcta hoy: se puede, y no hay que consignar matrículas. Marca b, la clave de los bancos antiguos.],
)

#q("C-H.15", "b",
  [La comunicación entre distintas estaciones de un mismo titular:],
  ([Está absolutamente prohibido], [Se puede efectuar entre titular y segundo operador], [Se puede efectuar entre titular y otro operador ocasional], [Se autoriza para concursos]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] La figura del «segundo operador» desapareció: sus autorizaciones caducaron, como muy tarde, el 1 de marzo de 1987 (Resolución de 13-02-1987, apdo. 5.2). Ni la Orden IET/1311/2013 (el art. 30 solo contiene normas generales de uso) ni la Ley 11/2022 regulan ni prohíben la comunicación entre estaciones de un mismo titular. No consta precepto vigente que permita elegir entre b, c y d. (ninguna opción es correcta hoy). #strong[Consejo:] Sin respuesta fiable hoy. Marca b, la clave de los bancos antiguos; la a (prohibición absoluta) no tiene apoyo en la norma vigente.],
)

#q("C-H.16", "d",
  [¿Cuál es la potencia máxima de emisión de una estación de radioaficionado en la banda de frecuencias comprendida entre 7.030 y 7.100 kHz?],
  ([25 vatios], [100 vatios], [150 vatios], [250 vatios]),
  sol: [Clave de los bancos antiguos: #strong[d]. #strong[Según la norma vigente:] Hoy el apartado 3.1 del anexo I de la Orden IET/1311/2013 fija 1000 W (p.c.e.) para todas las bandas de HF de 1,8 a 28 MHz, incluidas las de 7 y 14 MHz, y manda medir la potencia, siempre que sea posible, con relación a la portadora. Los 250 W eran la potencia de portadora (con 1000 W de cresta) del anexo I de la Orden ITC/1791/2006, derogada. Ninguna opción es correcta, tampoco en la versión con 14.000-14.350 kHz y las opciones 500 W, 50 W, 2 kW y 250 W. (ninguna opción es correcta hoy). #strong[Consejo:] Ninguna opción es correcta hoy (1000 W p.c.e.). Marca 250 W, la clave de los bancos antiguos, también si la pregunta es de otra banda de HF, como 14.000-14.350 kHz.],
)

#q("C-H.17", "d",
  [La potencia de la radiación perturbadora de los receptores de una estación de aficionado, en las bandas de frecuencia del servicio de radiodifusión sonora, no debe rebasar:],
  ([Dos milivatios], [Un microvatio], [Cuatro voltios], [Cuatro nanovatios]),
  sol: [Clave de los bancos antiguos: #strong[d]. #strong[Según la norma vigente:] La cifra de 4 nW no consta en la Orden IET/1311/2013: el apartado 4.4 de su anexo I solo obliga a las estaciones a cumplir la legislación en vigor sobre perturbaciones radioeléctricas e interferencias. No consta precepto vigente que fije ese límite, y no se ha podido verificar uno equivalente. (ninguna opción es correcta hoy). #strong[Consejo:] Sin cifra vigente con la que contrastarla. Marca d (cuatro nanovatios), la clave de los bancos antiguos; la c es absurda, pues el voltio no es unidad de potencia.],
)

#q("C-H.18", "a",
  [Utilizar como portable una estación fija, ¿constituye infracción?],
  ([No, si precede autorización de la Dirección General], [No, pues puede utilizarse indistintamente sin autorización], [Constituye una falta muy grave], [Constituye una falta grave]),
  sol: [Clave de los bancos antiguos: #strong[a]. #strong[Según la norma vigente:] Hoy no hace falta autorización: el art. 17.1 de la Orden IET/1311/2013 solo exige notificar el uso de una estación portable a la Jefatura con al menos 5 días de antelación, y ni eso en los usos temporales no continuados de hasta 15 días naturales consecutivos. Por eso utilizar como portable una estación fija no es infracción, y la mejor opción es la b (aunque «indistintamente» es impreciso). En la versión del banco «sin autorización de la Dirección General… es falta: grave, leve, muy grave o no es falta», la vigente es «no es falta», porque la Ley 11/2022 no tipifica esa conducta. (correcta hoy: #strong[b]). #strong[Consejo:] Marca b: basta notificar, no autorizar. Si el enunciado es «sin autorización de la Dirección General… es falta: grave, leve, muy grave o no es falta», marca «no es falta». Los bancos antiguos dan a y leve.],
)

#q("C-H.19", "b",
  [El plazo de validez de la autorización para que un radioaficionado proceda al montaje de su estación será, a partir de su notificación, de:],
  ([1 año], [3 meses], [6 meses], [2 años]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] La Orden IET/1311/2013 no fija un plazo de validez para la autorización de montaje: la resolución que la concede establece las condiciones (art. 19.g) y, terminada la instalación, el interesado dispone de 6 semanas para comunicarlo a la Jefatura (art. 20). Los 3 meses eran de la Resolución de 13-02-1987 (apdo. 6.3), derogada en 2006. El plazo de 6 meses del art. 26 es solo para las estaciones automáticas desatendidas. (ninguna opción es correcta hoy). #strong[Consejo:] Ninguna opción consta vigente. Marca b (3 meses), la clave de los bancos antiguos.],
)

#q("C-H.20", "b",
  [Utilizar con carácter temporal una estación fija de aficionado fuera del distrito de residencia:],
  ([Precisa una nueva licencia de estación para cada emplazamiento temporal.], [No precisa autorización, pero es necesario notificarlo a la JPIT correspondiente con al menos cinco días de antelación a las emisiones. En el distrito propio no se notificará.], [No precisa autorización, pero es necesario notificarlo a la JPIT correspondiente con al menos cinco días de antelación, salvo los usos temporales no continuados de hasta quince días naturales consecutivos.], [No precisa autorización ni notificación en ningún caso.]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] Hoy esa utilización es la de una estación portable (anexo I, apdo. 1, de la Orden IET/1311/2013): no requiere autorización, pero el art. 17.1 obliga a notificarla a la Jefatura Provincial de Inspección de Telecomunicaciones (JPIT) con al menos 5 días de antelación al comienzo de las emisiones. Solo quedan exentos de notificación previa los usos temporales no continuados con duración máxima de 15 días naturales consecutivos. La norma ya no distingue entre distrito propio y ajeno. (correcta hoy: #strong[c]). #strong[Consejo:] Marca la opción que dice «en el distrito propio no se notificará»: es la clave del banco. Si esa cláusula no aparece y sí la de los «quince días naturales» no continuados, marca esta última: es la vigente.],
)

#q("C-H.21", "b",
  [Señale qué banda precisará autorización especial de uso:],
  ([144–146 MHz.], [10,00–10,5 GHz.], [7,0–7,2 MHz.], [5.650–5.850 MHz.]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] El art. 16.1 de la Orden IET/1311/2013 exige autorización especial de la SETSI en las bandas secundarias con riesgo de interferencia a servicios primarios, y su disposición adicional segunda las relaciona inicialmente: 2.300–2.450 MHz (salvo 2.316–2.332 MHz), 5.650–5.850 MHz (salvo 5.700–5.720 MHz y 5.760–5.762 MHz) y 24,05–24,25 GHz. La banda de 10–10,5 GHz ya no figura en esa relación; la SETSI puede actualizarla, pero el texto consolidado del BOE no recoge ningún cambio. (correcta hoy: #strong[d]). #strong[Consejo:] Si aparece 10,00–10,5 GHz, márcala: es la clave del banco. Si no aparece y sí 2.300–2.450 MHz, 5.650–5.850 MHz o 24 GHz, marca esa: es una banda de la relación vigente.],
)

#q("C-H.22", "a",
  [En caso de cancelación de la autorización administrativa de radioaficionado, puede su titular mantener instalado el sistema radiante:],
  ([Solo en recepción, previa autorización por escrito de la propiedad del inmueble o, en su caso, de la comunidad de propietarios, remitiendo una copia de dicha autorización a la DGTel.], [No: debe desmontar las instalaciones, incluidas las antenas, con todos los gastos a su cargo.], [Sí, para emisión y recepción, mientras tramita una nueva autorización.], [Solo en recepción, previa comunicación a la Jefatura Provincial de Inspección de Telecomunicaciones, sin más trámites.]),
  sol: [Clave de los bancos antiguos: #strong[a]. #strong[Según la norma vigente:] Hoy no existe esa excepción. La licencia de estación fija se cancela, entre otros casos, por revocación o extinción de la autorización de radioaficionado (art. 21.1.b de la Orden IET/1311/2013), y el art. 21.2 obliga al interesado, cualquiera que sea la causa, a desmontar las instalaciones, incluidas las antenas, con todos los gastos a su cargo. (correcta hoy: #strong[b]). #strong[Consejo:] Marca mantener la antena solo en recepción con permiso escrito de la propiedad: es la clave del banco. Si no aparece, marca la que obliga a desmontar las antenas, que es lo vigente (art. 21.2).],
)

#q("C-H.23", "c",
  [Será causa específica de revocación definitiva de la autorización de radioaficionado:],
  ([No renovar la autorización cada diez años.], [La realización de emisiones con fines comerciales, publicitarios o lucrativos.], [No comunicar fehacientemente a la Administración, cada cinco años, su deseo de continuar utilizando el espectro radioeléctrico.], [Cambiar de distrito de residencia.]),
  sol: [Clave de los bancos antiguos: #strong[c]. #strong[Según la norma vigente:] El art. 8.1 de la Orden IET/1311/2013 solo cita como causas específicas de revocación las del Reglamento de uso del dominio público radioeléctrico y la realización de emisiones con fines comerciales, publicitarios o lucrativos. La disposición adicional primera suprimió la carga de comunicar cada cinco años la intención de seguir usando el espectro y eliminó sus efectos: la autorización conserva su vigencia hasta la renuncia o la revocación (art. 5.4). (correcta hoy: #strong[b]). #strong[Consejo:] Marca no comunicar cada cinco años: es la clave del banco, aunque esa obligación ya no existe. Si no aparece, la causa vigente es emitir con fines comerciales, publicitarios o lucrativos.],
)

#q("C-H.24", "b",
  [La utilización con carácter temporal de estaciones fijas, en emplazamientos distintos a los autorizados, NO precisará notificación previa a la Jefatura Provincial de Inspección de Telecomunicaciones cuando se efectúe dentro del propio distrito de residencia del radioaficionado y su duración máxima sea de:],
  ([Un día natural.], [Tres días naturales consecutivos.], [Siete días naturales consecutivos.], [Quince días naturales consecutivos.]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] El art. 17.1 de la Orden IET/1311/2013 ya no exime por distrito ni por tres días: la utilización de una estación portable se notifica a la JPIT con al menos 5 días de antelación, salvo los usos temporales no continuados de duración máxima de 15 días naturales consecutivos, que no precisan notificación previa. La exención no depende del distrito. (correcta hoy: #strong[d]). #strong[Consejo:] Marca «tres días naturales consecutivos»: es la clave del banco. Si no aparece y sí «quince días naturales», marca esa: es la exención vigente (art. 17.1), válida en cualquier distrito.],
)

#q("C-H.25", "a",
  [La Ley General de Telecomunicaciones tipifica como infracción grave:],
  ([No atender el requerimiento hecho por la autoridad competente para el cese de las emisiones radioeléctricas, en los supuestos de producción de interferencias.], [Efectuar emisiones radioeléctricas que incumplan gravemente los límites de exposición establecidos en la normativa de desarrollo del artículo 44 de esta Ley e incumplir gravemente las demás medidas de seguridad establecidas en dicha normativa, incluidas las obligaciones de señalización o vallado de las instalaciones radioeléctricas.], [La divulgación del contenido, o de simples existencias, de mensajes no destinados al público en general emitidos o recibidos a través de servicios de telecomunicaciones, a los que se acceda mediante la interceptación voluntaria o involuntaria, su publicación o cualquier otro uso de ellos sin la debida autorización.], [El incumplimiento reiterado de los requerimientos de información formulados por el órgano competente de la Administración del Estado en el ejercicio de sus funciones.]),
  sol: [Clave de los bancos antiguos: #strong[a]. #strong[Según la norma vigente:] La Ley 11/2022 tipifica como muy graves no atender el requerimiento de cesación en los supuestos de interferencias (art. 106.8) y la interceptación y divulgación sin autorización (art. 106.15), así que a y c ya no son graves. Es grave incumplir los límites de exposición (art. 107.7), que es la opción b aunque conserve el adverbio «gravemente» de la redacción antigua, y la d podría encajar en el art. 107.34 (no facilitar datos tras el segundo requerimiento), de modo que la pregunta es ambigua hoy. La clave a era del art. 54.f de la Ley 32/2003, derogada. (correcta hoy: #strong[b]). #strong[Consejo:] Marca b (grave hoy, art. 107.7). Los bancos antiguos dan a, que hoy es muy grave (art. 106.8). La d podría encajar en el art. 107.34: pregunta ambigua.],
)

#q("C-H.26", "b",
  [¿Cuál de estas causas será causa específica de revocación de la autorización de radioaficionado?],
  ([Estar sin utilizar el espectro radioeléctrico durante cinco años seguidos.], [No comunicar fehacientemente a la Administración, cada cinco años, su deseo de continuar utilizando el espectro radioeléctrico.], [Cambiarse de domicilio sin comunicárselo fehacientemente a la Administración en un plazo de cinco años.], [Ninguna de ellas, la autorización no se revoca.]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] La Orden IET/1311/2013 suprimió la obligación de comunicar cada cinco años la intención de seguir usando el dominio público radioeléctrico y eliminó sus efectos (disposición adicional primera); la autorización dura hasta que el titular renuncie o sea revocada (art. 5.4). Hoy son causas específicas de revocación las de la normativa general del dominio público radioeléctrico (art. 8.1.a de la Orden; Ley 11/2022, art. 95.3) y las emisiones con fines comerciales, publicitarios o lucrativos (art. 8.1.b); ninguna de a, b y c figura. La coletilla de d es imprecisa, porque la autorización sí puede revocarse por otras causas. (correcta hoy: #strong[d]). #strong[Consejo:] Marca d: ninguna de las tres causas existe hoy (su coletilla es imprecisa). Los bancos antiguos dan b. Si preguntan cada cuántos años hay que comunicar la continuidad, ninguna opción vale: marca cinco años.],
)

#q("C-H.27", "b",
  [Por la comisión de una infracción grave tipificada en la Ley General de Telecomunicaciones se podrá imponer al infractor una multa por importe de hasta el duplo del beneficio bruto obtenido o, en el caso de que no resulte aplicable este criterio, el límite máximo será de:],
  ([5 000 000 euros], [500 000 euros], [1 000 000 euros], [Ninguna de las anteriores.]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] En las infracciones graves en que sanciona la CNMC, la Ley 11/2022 (art. 109.1.c) fija hasta el duplo del beneficio bruto o, si no puede aplicarse ese criterio, el 1 % del volumen de negocios total del infractor en el último ejercicio; para las demás graves el máximo es de 2 000 000 euros. Los 500 000 euros eran del art. 56.1.c de la Ley 32/2003, derogada, y la Ley 9/2014 (art. 79.1.c) ya los había subido a 2 000 000 euros. Ninguna de las cifras de las opciones a, b y c coincide con la norma vigente. (correcta hoy: #strong[d]). #strong[Consejo:] Marca d (ninguna de las anteriores). Los bancos antiguos dan 500 000 euros. Si la versión no ofrece esa opción y salen 50 000, 30 000, 100 000 y 500 000 euros, marca 500 000.],
)

#q("C-H.28", "c",
  [¿Emitir música es una falta o se puede efectuar?],
  ([Leve], [Grave], [Muy grave], [Se puede efectuar]),
  sol: [Clave de los bancos antiguos: #strong[c]. #strong[Según la norma vigente:] La Ley 11/2022 no tipifica expresamente emitir música, y la Orden IET/1311/2013 tampoco la menciona: solo limita el servicio a la instrucción individual, la intercomunicación y los estudios técnicos, sin fines de lucro (art. 2.1), y permite revocar la autorización por emisiones con fines comerciales, publicitarios o lucrativos (art. 8.1.b). Según la lectura, una emisión ajena al servicio podría encajar como emisión no autorizada (art. 108.1, leve) o como uso del espectro no adecuado al CNAF (art. 106.5, muy grave); no consta precepto vigente que fije el grado. La calificación de muy grave era del art. 32.3.f del Reglamento de 1986, derogado. (ninguna opción es correcta hoy). #strong[Consejo:] Sin respuesta fiable hoy. Marca c (muy grave), la clave de los bancos antiguos; la d es la menos defendible, porque el servicio no es de difusión.],
)

#q("C-H.29", "b",
  [¿Utilizar bandas de frecuencias distintas a las autorizadas es una falta o se puede efectuar?],
  ([Leve], [Grave], [Muy grave], [Se puede efectuar]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] La Ley 11/2022 no contiene un tipo que diga literalmente «utilizar bandas distintas a las autorizadas»: según el caso encajaría como uso del espectro no adecuado al CNAF (art. 106.5, muy grave), como uso sin la autorización necesaria (art. 107.5, grave) o como incumplimiento de las condiciones autorizadas o uso sin autorización para el uso especial (arts. 108.5 y 108.3, leves). Era grave en la Ley 32/2003 (art. 54.a) y en el Reglamento de 1986 (art. 32.2.l). No consta precepto vigente que fije un único grado. (ninguna opción es correcta hoy). #strong[Consejo:] Sin respuesta única hoy. Marca b (grave), la clave de los bancos antiguos. Descarta d: utilizar bandas no autorizadas es infracción en todo caso.],
)

#q("C-H.30", "a",
  [No eliminar o reducir a niveles aceptables las interferencias a la recepción de emisiones de radiodifusión o televisión, a requerimiento de la Dirección General de Telecomunicaciones, constituye una falta:],
  ([Grave], [Leve], [Muy grave], [Depende de las circunstancias]),
  sol: [Clave de los bancos antiguos: #strong[a]. #strong[Según la norma vigente:] Hoy, si una estación causa interferencia perjudicial, su titular debe cesar las emisiones y adoptar las medidas que indique la SETSI (art. 32 de la Orden IET/1311/2013), y no atender el requerimiento de cesación en los supuestos de interferencias es infracción muy grave (art. 106.8 de la Ley 11/2022); la mera producción de interferencias es grave (art. 107.6). La calificación de grave era la del art. 32.2.k del Reglamento de 1986, derogado. La asimilación a la muy grave es razonable, pero el texto legal habla de cesación y no de «reducir a niveles aceptables». (correcta hoy: #strong[c]). #strong[Consejo:] Marca c (muy grave, art. 106.8), aunque con dudas. Los bancos antiguos dan a (grave); es la clave heredada si el examen no se ha actualizado.],
)

#q("C-H.31", "a",
  [Emplear las señales de socorro «SOS» o «MAYDAY» es una falta:],
  ([Grave], [Muy grave], [Puede hacerse si está justificado], [Leve]),
  sol: [Clave de los bancos antiguos: #strong[a]. #strong[Según la norma vigente:] La Ley 11/2022 no tipifica expresamente el uso indebido de las señales de socorro (arts. 106 a 108), así que no consta precepto vigente que fije el grado. Sigue prohibido emplearlas en falso (Constitución de la UIT, art. 47) y es sancionable. La calificación de grave era del art. 32.2.n del Reglamento de 1986, derogado. (ninguna opción es correcta hoy). #strong[Consejo:] Sin respuesta fiable hoy. Marca a (grave), la clave de los bancos antiguos.],
)

#q("C-H.32", "a",
  [El operador de estación de aficionado que no emite el distintivo de llamada o lo hace de forma incorrecta al operar su estación incurre en:],
  ([Una falta leve], [Una falta grave], [Una falta muy grave], [No es falta]),
  sol: [Clave de los bancos antiguos: #strong[a]. #strong[Según la norma vigente:] La Orden IET/1311/2013 obliga a transmitir el distintivo al comienzo y al final de cada emisión y, en las de larga duración, al menos cada diez minutos (art. 29.1), pero ninguna norma vigente tipifica expresamente no emitirlo o emitirlo mal. Lo más probable es que encaje como incumplimiento de las condiciones de la autorización, infracción leve (art. 108.5 de la Ley 11/2022), aunque es una inferencia y no un tipo expreso. La calificación de leve era del art. 32.1.c del Reglamento de 1986, derogado. (ninguna opción es correcta hoy). #strong[Consejo:] Marca a (leve): es la clave de los bancos antiguos y la lectura más probable con el art. 108.5. Descarta d: la obligación de identificarse existe (art. 29.1).],
)

#q("C-H.33", "d",
  [De las que se señalan a continuación, ¿qué infracción constituye una falta grave?],
  ([Carecer de libro diario.], [No emitir el distintivo de llamada.], [Utilizar como portable una estación fija sin autorización.], [No abonar los cánones y tasas correspondientes.]),
  sol: [Clave de los bancos antiguos: #strong[d]. #strong[Según la norma vigente:] Hoy ninguna de las cuatro conductas es infracción grave. La Ley 11/2022 no tipifica el impago de tasas: el art. 110.3 solo obliga al infractor a pagarlas, y la falta de pago de la tasa por reserva del dominio público radioeléctrico es causa de extinción del título (art. 95.2.e), no una falta calificada. Tampoco consta que la Orden IET/1311/2013 exija libro diario ni autorización para el uso portable (art. 17.1), y no emitir el distintivo encajaría, a lo sumo, en el art. 108.5 (leve). La clave d era del art. 32.2.m del Reglamento de 1986, derogado. (ninguna opción es correcta hoy). #strong[Consejo:] Ninguna opción es falta grave hoy. Marca d (no abonar cánones y tasas), la clave de los bancos antiguos. Si preguntan el grado de ese impago (leve, grave, muy grave o según los casos), marca grave.],
)

#q("C-H.34", "b",
  [Se puede suspender provisionalmente una licencia de aficionado:],
  ([No se contempla en el Reglamento esta sanción], [Sí, por falta grave], [Sí, por falta muy grave], [Únicamente en caso de enfermedad]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] Hoy la Orden IET/1311/2013 no regula sanciones (su art. 34 remite a la Ley General de Telecomunicaciones), y en la Ley 11/2022 la suspensión provisional de la eficacia del título, por un máximo de seis meses, no es una sanción sino una medida cautelar (art. 112.1.f) que puede acordarse una vez incoado el procedimiento por cualquier infracción de los arts. 106 a 108, no solo por faltas graves. La suspensión temporal de la licencia por falta grave (de uno a tres meses) era del art. 33.2 del Reglamento de 1986, derogado. (ninguna opción es correcta hoy). #strong[Consejo:] Sin respuesta única hoy (la más cercana es a). Marca b, la clave de los bancos antiguos.],
)

#q("C-H.35", "b",
  [De acuerdo con la Ley General de Telecomunicaciones, por infracción «grave» o leve, se puede imponer:],
  ([Multa de 1 millón de euros para las muy graves, 500.000 para las graves y 50.000 para las leves.], [Multa de 20 millones de euros para las muy graves, 2 para las graves y 50.000 euros para las leves.], [Multa de 20 millones de euros para las muy graves, 2 millones para las graves y 100.000 euros para las leves.], [Multa de 100 millones de euros para las muy graves, 10 millones para las graves y 1 millón para las leves.]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] El art. 109.1 de la Ley 11/2022 fija multas de hasta 20 millones de euros para las infracciones muy graves (letra a), de hasta 2 millones para las graves (letra c) y de hasta 100.000 euros para las leves (letra d). Los importes de muy graves y graves no han cambiado; solo el de las leves, que antes era de 50.000 euros. (correcta hoy: #strong[c]). #strong[Consejo:] Marca la opción con 50.000 euros para las leves: es la clave del banco. Si no aparece y sí la de 100.000 euros, marca esa, que es la cifra vigente (art. 109.1.d).],
)

#q("C-H.36", "b",
  [Por la comisión de una infracción grave tipificada en la Ley General de Telecomunicaciones se podrá imponer al infractor una multa por importe de hasta el doble del beneficio bruto obtenido o, en el caso de que no resulte aplicable este criterio, el límite máximo será de:],
  ([100.000 euros.], [500.000 euros.], [1 millón de euros.], [2 millones de euros.]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] El art. 109.1.c de la Ley 11/2022 fija para las infracciones graves una multa de hasta 2 millones de euros. El criterio del duplo del beneficio bruto solo rige hoy cuando sanciona la CNMC, y su tope alternativo es el 1 % del volumen de negocios total de la entidad infractora en el último ejercicio. Las sanciones a radioaficionados corresponden, en general, a la SETID (art. 114.1.c), con el límite de 2 millones. (correcta hoy: #strong[d]). #strong[Consejo:] Marca 500.000 euros: es la clave del banco. Si no aparece y sí 2 millones de euros, marca esta: es el tope vigente para las infracciones graves de un radioaficionado (art. 109.1.c).],
)

#q("C-H.37", "b",
  [De acuerdo con la Ley General de Telecomunicaciones, por comisión de infracciones graves se puede imponer:],
  ([Una multa al infractor de hasta 100.000 euros.], [Una multa al infractor de hasta 500.000 euros.], [Una multa al infractor de hasta 2 millones de euros.], [Una multa al infractor de hasta 20 millones de euros.]),
  sol: [Clave de los bancos antiguos: #strong[b]. #strong[Según la norma vigente:] El art. 109.1.c de la Ley 11/2022 eleva el límite de las multas por infracciones graves a hasta 2 millones de euros: los 500.000 euros de la ley anterior ya no son el tope. Las muy graves siguen en hasta 20 millones (art. 109.1.a) y las leves llegan a 100.000 euros (art. 109.1.d). (correcta hoy: #strong[c]). #strong[Consejo:] Marca hasta 500.000 euros: es la clave del banco. Si no aparece y sí hasta 2 millones, marca esa: es el tope vigente para las infracciones graves (art. 109.1.c).],
)

#q("C-H.38", "c",
  [La Ley General de Telecomunicaciones tipifica como infracción grave:],
  ([El uso, en condiciones diferentes de las autorizadas, del espectro radioeléctrico que provoque alteraciones que impidan la correcta prestación de otros servicios.], [La no colaboración con la Inspección de Telecomunicaciones cuando esta sea requerida.], [El establecimiento de comunicaciones con estaciones no autorizadas.], [La interceptación, sin autorización, de telecomunicaciones no destinadas al público en general.]),
  sol: [Clave de los bancos antiguos: #strong[c]. #strong[Según la norma vigente:] Hoy comunicarse con estaciones no autorizadas es infracción leve (art. 108.2 de la Ley 11/2022, salvo que deba considerarse grave), no grave. Es grave la negativa u obstrucción a la inspección y la no colaboración con ella (art. 107.36); la interceptación sin autorización es muy grave (art. 106.15). La opción a) también encajaría como grave (art. 107.6, mera producción de interferencias), así que la pregunta es ambigua con la ley actual. (correcta hoy: #strong[b]). #strong[Consejo:] Marca c: es la clave del banco, aunque hoy sea infracción leve (art. 108.2). Con la ley actual la grave sería b (art. 107.36), pero a también encaja: la pregunta es ambigua.],
)

#q("C-H.39", "a",
  [La Ley General de Telecomunicaciones tipifica como infracción muy grave:],
  ([La negativa u obstrucción a ser inspeccionado, y la no colaboración con la Inspección de Telecomunicaciones cuando esta sea requerida.], [No facilitar los datos requeridos por la Administración o retrasar injustificadamente su aportación cuando sea exigible según lo previsto en la normativa reguladora de las comunicaciones electrónicas.], [La instalación de estaciones radioeléctricas sin autorización, cuando, de acuerdo con lo dispuesto en la normativa reguladora de las telecomunicaciones, sea necesaria.], [No atender el requerimiento hecho por la autoridad competente para el cese de las emisiones radioeléctricas, en los casos de producción de interferencias.]),
  sol: [Clave de los bancos antiguos: #strong[a]. #strong[Según la norma vigente:] Hoy es muy grave no atender el requerimiento de cesación formulado por la SETID en los supuestos de producción de interferencias (art. 106.8 de la Ley 11/2022), opción d). La negativa u obstrucción a la inspección es grave (art. 107.36); no facilitar datos o retrasar su aportación es leve (art. 108.12); instalar estaciones sin autorización es grave (art. 107.1), o leve si se trata de una estación de radioaficionado (art. 108.4). (correcta hoy: #strong[d]). #strong[Consejo:] Marca a: es la clave del banco, aunque hoy la negativa a la inspección sea grave (art. 107.36). La opción muy grave según la ley vigente es d, el requerimiento de cese por interferencias (art. 106.8).],
)
