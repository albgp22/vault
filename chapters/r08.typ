#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

// Código en tipografía monoespaciada (QSL, EA4/M0ABC…), como en el original.
#let _r8-cod(t) = text(font: fuente-mono, size: 0.88em, fill: col.acento, t)

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

#q("R8.1", "c",
  [La Ley 19/1983, conocida como «Ley de Antenas», regula:],
  ([las tasas por uso del espectro radioeléctrico], [el contenido de las emisiones de aficionado], [el derecho a instalar las antenas de aficionado en el exterior de los inmuebles], [la homologación de los transceptores]),
  sol: [La Ley 19/1983 («Ley de Antenas») reconoce el derecho a instalar antenas de aficionado en el exterior de los inmuebles.],
)

#q("R8.2", "a",
  [La Recomendación CEPT T/R 61-01 se refiere a:],
  ([el uso temporal de estaciones de aficionado en otros países], [el certificado de examen armonizado HAREC], [los planes de banda de la Región 1], [las señales de socorro y urgencia]),
  sol: [T/R 61-01: licencia CEPT, uso temporal de la estación en los países que la aplican.],
)

#q("R8.3", "b",
  [La Recomendación CEPT T/R 61-02 se refiere a:],
  ([las emisiones por satélite], [el certificado de examen armonizado HAREC], [el uso de repetidores transfronterizos], [la potencia máxima en HF]),
  sol: [T/R 61-02: certificado de examen armonizado HAREC.],
)

#q("R8.4", "d",
  [Un extranjero residente en España titular de un certificado HAREC expedido por un país que aplique la Recomendación T/R 61-02:],
  ([deberá superar de nuevo el examen español completo], [solo podrá operar como oyente], [deberá examinarse únicamente de reglamentación], [podrá obtener la autorización española de radioaficionado sin examinarse de nuevo]),
  sol: [Con HAREC de un país adherido, el residente extranjero obtiene la autorización española sin repetir examen.],
)

#q("R8.5", "a",
  [De acuerdo con la división del mundo de la UIT, España se encuentra en la:],
  ([Región 1], [Región 2], [Región 3], [Zona 4]),
  sol: [España está en la Región 1 de la UIT (Europa, África, Oriente Medio y norte de Asia).],
)

#q("R8.6", "b",
  [Se denomina «radiocomunicación» a:],
  ([cualquier comunicación entre dos radioaficionados], [toda telecomunicación transmitida por medio de ondas radioeléctricas], [la comunicación exclusivamente en fonía], [la comunicación entre estaciones fijas]),
  sol: [Radiocomunicación: toda telecomunicación transmitida por ondas radioeléctricas.],
)

#q("R8.7", "c",
  [En el Reglamento de uso del dominio público radioeléctrico por aficionados, la abreviatura CNAF significa:],
  ([Comisión Nacional de Aficionados y Frecuencias], [Catálogo Nacional de Antenas Fijas], [Cuadro Nacional de Atribución de Frecuencias], [Certificado Nacional de Aptitud de Frecuencias]),
  sol: [CNAF: Cuadro Nacional de Atribución de Frecuencias, de obligado cumplimiento.],
)

#q("R8.8", "a",
  [La autorización de radioaficionado tiene carácter:],
  ([personal e intransferible], [familiar], [transferible mediante compraventa], [colectivo]),
  sol: [La autorización es personal e intransferible.],
)

#q("R8.9", "d",
  [El radioaficionado que emite temporalmente desde otro país CEPT está obligado a respetar la reglamentación del país visitado:],
  ([solo si emite más de quince días], [solo en las bandas de HF], [únicamente si se lo requiere la autoridad local], [siempre]),
  sol: [En el país visitado se respeta siempre su reglamentación, además del Reglamento de Radiocomunicaciones.],
)

#q("R8.10", "b",
  [El Real Decreto 2623/1986 regula:],
  ([las tasas del examen de radioaficionado], [las instalaciones de antenas de las estaciones radioeléctricas de aficionado], [los planes de banda nacionales], [el código de deletreo oficial]),
  sol: [El RD 2623/1986 regula las instalaciones de antenas, en desarrollo de la Ley 19/1983.],
)

== Autorización y licencia de estación <r8-sec-autorizacion>

#q("R8.11", "b",
  [El plazo del que dispone la Administración para resolver una solicitud de autorización de radioaficionado es de:],
  ([quince días], [seis semanas], [seis meses], [un año]),
  sol: [Plazo de resolución: seis semanas; el silencio es desestimatorio.],
)

#q("R8.12", "d",
  [En cuanto a la renovación de las autorizaciones de radioaficionado:],
  ([deben renovarse cada año], [deben renovarse cada cinco años], [deben renovarse cada diez años], [no es necesario renovarlas: la renovación quinquenal quedó suprimida]),
  sol: [La carga de comunicar cada cinco años la intención de seguir utilizando el dominio público radioeléctrico quedó suprimida (disposición adicional 1.ª de la Orden): la autorización no caduca por falta de renovación y conserva su vigencia mientras su titular no renuncie o sea revocada (art. 5.4).],
)

#q("R8.13", "a",
  [Para la instalación de una estación fija de radioaficionado es necesario:],
  ([presentar, para su aprobación, una memoria descriptiva del conjunto de la estación en la Jefatura Provincial de Inspección de Telecomunicaciones], [únicamente comunicarlo al ayuntamiento], [el permiso de la asociación de radioaficionados local], [una licencia municipal de obras mayores]),
  sol: [La estación fija exige presentar una memoria descriptiva de la instalación en la Jefatura Provincial (JPIT) para su aprobación: la exige el RD 2623/1986 (art. 2.2–2.3), al que remite la Orden IET/1311/2013 (arts. 18.2 y 19). Ojo: la expresión «del conjunto de la estación» es de la Orden de 2006; el fondo sigue vigente.],
)

#q("R8.14", "c",
  [Como norma general, el montaje del sistema radiante de una estación fija será realizado por:],
  ([el propio radioaficionado, en todos los casos], [cualquier electricista], [un instalador de telecomunicaciones autorizado, inscrito en el registro de empresas instaladoras], [personal de la Jefatura Provincial]),
  sol: [Como norma general, el montaje del sistema radiante lo realiza un instalador de telecomunicaciones inscrito en el registro; solo las instalaciones simples pueden autorizarse al propio interesado.],
)

#q("R8.15", "b",
  [Un radioaficionado podrá instalar la antena de su estación fija en el exterior de un inmueble:],
  ([nunca, si vive en un piso], [si está legitimado para usar la totalidad o parte del edificio y ha obtenido la autorización administrativa reglamentaria], [siempre, sin ningún trámite], [solo si es el propietario de todo el edificio]),
  sol: [Hacen falta las dos cosas: legitimación para usar el edificio (propiedad, alquiler con permiso…) y la autorización administrativa.],
)

#q("R8.16", "a",
  [Para la instalación de antenas de radioaficionado es obligatorio disponer de un seguro que cubra:],
  ([la responsabilidad civil del titular], [el robo de los equipos], [los daños por rayo en el propio equipo], [el lucro cesante de la comunidad]),
  sol: [El seguro obligatorio cubre la responsabilidad civil del titular por la instalación de antenas.],
)

#q("R8.17", "d",
  [Si el titular de una estación fija no dispone de contrato válido de seguro de antenas:],
  ([no ocurre nada mientras no haya un siniestro], [se le impone una multa leve y puede seguir emitiendo], [se le concede un año de prórroga], [la licencia de estación fija se cancela de oficio y las antenas deben permanecer desmontadas]),
  sol: [Sin seguro válido, la licencia de estación fija se cancela automáticamente (art. 21.1.c de la Orden) y, cancelada la licencia, el titular debe desmontar las instalaciones, antenas incluidas, con todos los gastos a su cargo (art. 21.2). La Ley 19/1983 (art. 4) añade que se pierde el derecho a instalar antenas.],
)

== Antenas y comunidad de propietarios <r8-sec-antenas>

#q("R8.18", "c",
  [Ante la instalación de antenas de radioaficionado, una comunidad de propietarios:],
  ([es quien concede la autorización], [puede prohibirla libremente], [no puede autorizarla: solo pronunciarse sobre la idoneidad de la instalación], [debe pagar el seguro de antenas]),
  sol: [La comunidad no autoriza: se pronuncia sobre la idoneidad de la instalación (la autorización es de la Administración de telecomunicaciones).],
)

#q("R8.19", "a",
  [La Administración de telecomunicaciones debe informar al presidente de la comunidad de propietarios afectada siempre que:],
  ([se le haya solicitado autorización para instalar antenas de radioaficionado en el exterior del inmueble], [un vecino presente una queja por ruido], [el radioaficionado cambie de equipo], [se renueve el seguro de antenas]),
  sol: [La Administración informa al presidente de la comunidad (o a la propiedad) una vez aceptada la memoria de instalación que presenta el solicitante (RD 2623/1986, art. 3): la comunidad dispone entonces de dos meses para alegar sobre la idoneidad del emplazamiento o los perjuicios y, si calla, se entiende que acepta.],
)

#q("R8.20", "b",
  [Si para realizar obras en el edificio fuera necesario desmontar la antena, la comunidad de propietarios deberá:],
  ([desmontarla sin previo aviso], [informar al titular de la licencia con una antelación mínima de un mes], [indemnizar al titular con el valor de la antena], [pedir permiso a la Jefatura Provincial]),
  sol: [Si las obras exigen desmontar la antena, la comunidad debe avisar al titular con al menos un mes de antelación.],
)

#q("R8.21", "d",
  [Terminadas las obras de la comunidad que obligaron a desmontar la instalación de antenas:],
  ([el titular pierde el derecho a la instalación], [hay que iniciar el expediente de autorización desde cero], [la antena solo podrá reinstalarse en el interior], [podrán instalarse nuevamente en condiciones similares a las anteriores]),
  sol: [Acabadas las obras, la instalación puede reponerse en condiciones similares a las anteriores.],
)

#q("R8.22", "a",
  [Los daños y perjuicios originados por la conservación o el desmontaje de una antena de radioaficionado corren por cuenta de:],
  ([el radioaficionado titular de la licencia], [la comunidad de propietarios], [la Administración de telecomunicaciones], [la empresa aseguradora del edificio]),
  sol: [Los daños de conservación y desmontaje corren por cuenta del titular de la licencia (para eso está el seguro de responsabilidad civil).],
)

#q("R8.23", "c",
  [Cuando las antenas se sitúen en azoteas o lugares transitables:],
  ([deben pintarse de colores llamativos], [no pueden superar el metro de altura], [se señalizarán los anclajes y riostras], [deben vallarse por completo]),
  sol: [En azoteas y lugares transitables se señalizan anclajes y riostras; los materiales deben ser resistentes, no endebles.],
)

#q("R8.24", "b",
  [Cancelada la licencia de una estación fija, cualquiera que sea la causa, su titular deberá:],
  ([obtener un permiso especial de la UIT], [desmontar las instalaciones, incluidas las antenas, con todos los gastos a su cargo], [solicitar una nueva licencia de estación], [mantener el sistema radiante solo para recepción, con autorización por escrito de la propiedad del inmueble o de la comunidad de propietarios]),
  sol: [Art. 21.2 de la Orden IET/1311/2013: al cancelarse la licencia, cualquiera que sea la causa, el interesado debe desmontar las instalaciones, incluidas las antenas, con todos los gastos a su cargo. Es coherente con R8.17 y con la Ley 19/1983 (art. 4: la cancelación de la licencia implica la pérdida del derecho a instalar antenas). Los bancos de preguntas antiguos dan como correcta la opción d (mantener el sistema radiante solo para recepción con autorización escrita de la propiedad o de la comunidad): es el art. 25 de la Orden ITC/1791/2006, derogada. Si en el examen aparece la pregunta antigua, esa es la que dan por buena.],
)

== Usos especiales y casos particulares <r8-sec-usos-especiales>

#q("R8.25", "d",
  [Los equipos de radioaficionado de construcción propia:],
  ([están prohibidos], [requieren homologación individual previa], [deben ser revisados anualmente por la Jefatura Provincial], [pueden utilizarse sin autorización previa de la Administración]),
  sol: [Los equipos de construcción propia pueden usarse sin autorización previa: la experimentación es la esencia del servicio (art. 5 del Reglamento).],
)

#q("R8.26", "a",
  [Las utilizaciones de carácter experimental con características técnicas distintas de las especificadas en el Reglamento:],
  ([requieren una autorización especial], [están permitidas sin trámite alguno], [están prohibidas en todo caso], [solo se permiten a las estaciones colectivas]),
  sol: [Los usos experimentales con características distintas de las reglamentarias requieren autorización especial.],
)

#q("R8.27", "c",
  [Las autorizaciones especiales para usos experimentales (art. 17 de la Orden):],
  ([son transferibles a terceros], [tienen validez indefinida], [son nominativas y se otorgan con un plazo máximo inicial de dieciocho meses, ampliable], [se conceden automáticamente con la autorización ordinaria]),
  sol: [Las autorizaciones especiales para usos experimentales son nominativas, solo habilitan a su titular y se otorgan por el tiempo necesario para las pruebas, con un plazo máximo inicial de dieciocho meses, ampliable, quedando su validez condicionada a la de la autorización de radioaficionado (art. 17.3.2.º). Ojo: no las confundas con las del art. 16 (bandas con limitaciones, disposición adicional 2.ª), para las que la Orden no fija plazo; un enunciado que hable de «bandas de uso restringido» mezcla ambas, y los dieciocho meses son los de las experimentales.],
)

#q("R8.28", "b",
  [El uso por radioaficionados de ciertas bandas de microondas requiere una autorización especial. Entre esas bandas se encuentra la de:],
  ([144–146 MHz], [5650–5850 MHz], [432–438 MHz], [50–52 MHz]),
  sol: [Las bandas 2.300–2.450 MHz, 5.650–5.850 MHz y 24,050–24,250 GHz precisan autorización especial (disposición adicional segunda de la Orden IET/1311/2013), con tres excepciones: las subbandas 2.316–2.332 MHz, 5.700–5.720 MHz y 5.760–5.762 MHz no la precisan. El resto de opciones son bandas de aficionado de uso ordinario.],
)

#q("R8.29", "a",
  [Para que un menor de edad pueda examinarse y obtener la autorización de radioaficionado:],
  ([no existe límite de edad; sus padres o tutores deberán asumir por escrito las responsabilidades correspondientes], [debe haber cumplido 14 años], [debe haber cumplido 16 años], [no es posible hasta la mayoría de edad]),
  sol: [No hay edad mínima para examinarse; los padres o tutores asumen por escrito las responsabilidades del menor.],
)

#q("R8.30", "d",
  [Una condición imprescindible para que a un extranjero se le otorgue una autorización española de radioaficionado es que:],
  ([tenga nacionalidad de un país de la Unión Europea], [hable castellano], [lleve más de diez años en España], [acredite documentalmente su condición de residente en España]),
  sol: [El extranjero debe acreditar documentalmente su residencia en España.],
)

#q("R8.31", "c",
  [Un radioaficionado español que utiliza temporalmente su estación en un país que aplica la Recomendación CEPT T/R 61-01:],
  ([tiene prioridad sobre las estaciones locales], [queda exento de identificarse], [no podrá solicitar protección contra interferencias perjudiciales], [puede emitir en cualquier banda sin restricción]),
  sol: [El titular de una licencia CEPT que emite fuera de su territorio nacional no puede solicitar protección contra interferencias perjudiciales (art. 14.f de la Orden). No lo confundas con la categoría de servicio secundario de una atribución, que es otra cosa.],
)

#q("R8.32", "a",
  [La licencia CEPT expedida por una Administración que adopta la Recomendación T/R 61-01:],
  ([goza de equiparación a la autorización de aficionado nacional, en los términos del Reglamento], [carece de validez en España], [requiere convalidación mediante examen], [solo es válida en telegrafía]),
  sol: [La licencia CEPT se equipara a la autorización nacional en los términos del Reglamento español.],
)

== Estaciones desatendidas, repetidores y radiobalizas <r8-sec-desatendidas>

#q("R8.33", "b",
  [El objetivo que se pretende al instalar un repetidor de radioaficionado es:],
  ([sustituir a las estaciones fijas], [ampliar el alcance de las comunicaciones], [aumentar la potencia de las estaciones móviles], [evitar el uso del código Q]),
  sol: [El repetidor amplía el alcance: recibe en una frecuencia y retransmite en otra desde un emplazamiento elevado.],
)

#q("R8.34", "d",
  [El acceso a los repetidores analógicos y digitales será:],
  ([restringido a los socios del club propietario], [de pago], [mediante invitación del gestor], [necesariamente libre y, si tuvieran código de acceso, este deberá hacerse público]),
  sol: [El acceso a los repetidores es necesariamente libre; si llevan código, debe hacerse público.],
)

#q("R8.35", "a",
  [La instalación de una estación automática desatendida podrá autorizarse a:],
  ([cualquier asociación de aficionados legalmente reconocida], [cualquier radioaficionado individual], [las comunidades de propietarios], [los ayuntamientos]),
  sol: [Las desatendidas se autorizan a asociaciones legalmente reconocidas, no a titulares individuales.],
)

#q("R8.36", "c",
  [Como norma general, la potencia máxima de salida de los transmisores de las estaciones desatendidas en las bandas de VHF y UHF es de:],
  ([100 W en cualquier ubicación], [25 W dentro y fuera del casco urbano], [10 W en núcleos urbanos y 50 W fuera de ellos], [5 W en todos los casos]),
  sol: [Desatendidas en VHF/UHF: 10 W dentro del casco urbano, 50 W fuera.],
)

#q("R8.37", "b",
  [Las estaciones automáticas desatendidas en las bandas de HF tendrán una potencia de salida máxima de:],
  ([10 vatios], [50 vatios], [100 vatios], [1000 vatios]),
  sol: [En HF, las desatendidas se limitan a 50 W de salida.],
)

#q("R8.38", "d",
  [Como norma general, la ganancia del sistema radiante de las estaciones desatendidas en las bandas de VHF y UHF no será superior a:],
  ([3 dB], [10 dB], [20 dB], [6 dBd]),
  sol: [La ganancia del sistema radiante de las desatendidas en VHF/UHF no superará los 6 dBd (art. 25.h de la Orden), unos 8,15 dBi: se mide respecto a un dipolo de media onda, no son «6 dB» sin más.],
)

#q("R8.39", "a",
  [Las estaciones repetidoras y radiobalizas deberán disponer de un sistema de alimentación ininterrumpida que les permita seguir funcionando, en caso de fallo del suministro, durante un período mínimo de:],
  ([seis horas], [una hora], [veinticuatro horas], [una semana]),
  sol: [Repetidores y radiobalizas deben aguantar al menos seis horas con alimentación ininterrumpida.],
)

#q("R8.40", "c",
  [Los repetidores analógicos deben emitir automáticamente su distintivo de llamada en código Morse a una velocidad no superior a:],
  ([quince palabras por minuto], [veinte palabras por minuto], [diez palabras por minuto], [cincuenta palabras por minuto]),
  sol: [Art. 25.d de la Orden: mientras duren las emisiones, los repetidores analógicos emiten su distintivo de forma automática, en radiotelefonía o en Morse, a una velocidad no superior a diez palabras por minuto y a intervalos no superiores a diez minutos, por modulación de la portadora mediante un tono de audio. El banco público lo formula «a una velocidad de»; con esa redacción, diez es la cifra que dan por buena.],
)

#q("R8.41", "b",
  [Una estación automática desatendida de radioaficionado destinada a realizar estudios de propagación, cuyo funcionamiento se basa en la emisión automática de señales de identificación, recibe el nombre de:],
  ([estación piloto], [radiobaliza], [radiofaro comercial], [estación de calibración]),
  sol: [Radiobaliza (anexo I de la Orden IET/1311/2013): estación automática desatendida de radioaficionado destinada a estudios de propagación, cuyo funcionamiento se basa en la emisión automática de señales de identificación. Transmite su distintivo a intervalos no superiores a tres minutos (art. 25.e) y su información se refiere, salvo casos justificados, a su posición y condiciones de funcionamiento (art. 25.f). La redacción antigua la llamaba «estación colectiva fija» (Orden ITC/1791/2006).],
)

#q("R8.42", "d",
  [Entre las siguientes, la banda en la que los planes de banda reservan segmentos a radiobalizas de aficionado es la de:],
  ([27–28 MHz], [88–108 MHz], [118–136 MHz], [144–146 MHz]),
  sol: [144–146 MHz es la única banda de aficionado entre las opciones; el plan de bandas de la IARU para la Región 1 reserva en ella un segmento a balizas (144,400–144,491 MHz), y existen también en 28, 50 o 432 MHz. La Orden IET/1311/2013 no enumera las bandas de las radiobalizas (arts. 24 y 25): la lista que repiten los bancos (28–29,7; 50–51; 144–146; 430–440; 1240–1300 MHz) era el art. 31.3 de la Orden ITC/1791/2006, derogada.],
)

== Tipos de estación <r8-sec-tipos>

#q("R8.43", "a",
  [Se define «estación fija remota de aficionado» como la estación fija que:],
  ([puede ser accionada a distancia], [carece de antena exterior], [emite solo en frecuencias remotas], [funciona sin licencia]),
  sol: [Estación fija remota: estación fija accionada a distancia.],
)

#q("R8.44", "c",
  [Una estación portátil de aficionado se caracteriza por:],
  ([necesitar un vehículo para su transporte], [requerir conexión a la red eléctrica], [tener antena y fuente de energía incorporadas al propio equipo y poder utilizarse en movimiento], [emitir únicamente en UHF]),
  sol: [La portátil integra antena y fuente de energía en el propio equipo y puede usarse en movimiento (el «walkie»).],
)

#q("R8.45", "b",
  [La utilización con carácter temporal de una estación en una ubicación distinta de la habitual (estación portable):],
  ([está prohibida], [no precisa autorización, pero debe notificarse a la Jefatura Provincial con al menos cinco días de antelación; los usos no continuados de hasta 15 días naturales no precisan notificación], [requiere un distintivo temporal en todo caso], [requiere superar un nuevo examen]),
  sol: [Uso portable (ubicación distinta de la habitual, art. 17): notificación a la JPIT con cinco días de antelación; los usos no continuados de hasta 15 días naturales quedan exentos.],
)

== Nomenclatura de bandas y definiciones <r8-sec-nomenclatura>

#q("R8.46", "a",
  [En la nomenclatura de las bandas de frecuencia, las ondas métricas se corresponden con la banda:],
  ([VHF], [HF], [UHF], [MF]),
  sol: [Ondas métricas ($lambda$ de 10 a 1 m) = VHF, 30–300 MHz.],
)

#q("R8.47", "c",
  [La banda de HF comprende las frecuencias entre:],
  ([300 kHz y 3 MHz], [30 y 300 MHz], [3 y 30 MHz], [300 MHz y 3 GHz]),
  sol: [HF: 3–30 MHz (ondas decamétricas).],
)

#q("R8.48", "d",
  [La banda SHF corresponde a las frecuencias comprendidas entre:],
  ([30 y 300 MHz], [300 MHz y 3 GHz], [30 y 300 GHz], [3 y 30 GHz]),
  sol: [SHF: 3–30 GHz (ondas centimétricas). La serie completa: HF 3–30 MHz, VHF 30–300 MHz, UHF 300 MHz–3 GHz, SHF 3–30 GHz.],
)

== Uso de la estación y otras cuestiones <r8-sec-uso>

#q("R8.49", "b",
  [Con autorización de su titular, podrá hacer uso de una estación de aficionado:],
  ([cualquier persona, sea o no radioaficionado], [cualquier otro titular de autorización de radioaficionado], [solo los familiares del titular], [nadie: el uso es estrictamente personal]),
  sol: [Con permiso del titular, puede usar la estación cualquier otro titular de autorización de radioaficionado. Ojo: es una regla de la Orden ITC/1791/2006 (art. 37.5, derogada), que añadía que se identificaba con su propio distintivo precedido del del titular; la Orden IET/1311/2013 no la recoge expresamente. Se mantiene como clave porque es la única opción razonable y la que da el banco.],
)

#q("R8.50", "a",
  [Tras la revocación de la autorización de radioaficionado, el interesado:],
  ([no podrá ejercer la actividad hasta obtener una nueva autorización], [puede seguir emitiendo con potencia reducida], [puede emitir solo en fines de semana], [conserva el uso del repetidor local]),
  sol: [Revocada la autorización, no se puede ejercer la actividad hasta obtener una nueva.],
)

#q("R8.51", "c",
  [La reglamentación vigente permite:],
  ([emitir sin distintivo de llamada], [usar el distintivo de otro titular sin su permiso], [disponer de distintivo de llamada sin tener licencia de estación], [tener licencia de estación sin autorización de radioaficionado]),
  sol: [Se puede tener distintivo (autorización) sin licencia de estación: la licencia solo hace falta para la estación fija con antenas.],
)

#q("R8.52", "d",
  [No puede considerarse una estación automática desatendida:],
  ([un repetidor analógico], [una radiobaliza], [un repetidor digital], [una estación colectiva de aficionado]),
  sol: [«Colectiva» alude a la titularidad —la estación de una asociación reconocida—, no a cómo se opera: de hecho, el Anexo I define la desatendida como una estación colectiva que funciona sin intervención directa del operador. Las otras tres opciones son desatendidas por definición; una colectiva, en general, no lo es necesariamente.],
)

#q("R8.53", "b",
  [Para ejercer la actividad, un radioaficionado está obligado a ser socio de una asociación de radioaficionados:],
  ([sí, de la URE], [no], [sí, de cualquier asociación reconocida], [solo si opera en HF]),
  sol: [Asociarse es voluntario: no existe obligación de pertenecer a ninguna asociación.],
)

#q("R8.54", "a",
  [Disponer de una estación fija es, para un radioaficionado:],
  ([no obligatorio], [obligatorio desde el primer año], [obligatorio solo en las capitales de provincia], [requisito para renovar la autorización]),
  sol: [Tampoco es obligatorio disponer de estación fija.],
)

#q("R8.55", "c",
  [El Reglamento de uso del dominio público radioeléctrico por aficionados se dicta al amparo del artículo 149.1.21.ª de la Constitución, que atribuye al Estado competencia exclusiva en materia de:],
  ([industria], [medio ambiente], [telecomunicaciones], [defensa]),
  sol: [El artículo 149.1.21.ª de la Constitución da al Estado la competencia exclusiva en telecomunicaciones: por eso el Reglamento es estatal.],
)

#q("R8.56", "d",
  [Conforme al Reglamento de Radiocomunicaciones de la UIT, el servicio de aficionados por satélite utiliza:],
  ([globos estratosféricos], [aeronaves comerciales], [repetidores terrestres de gran altura], [estaciones espaciales situadas en satélites]),
  sol: [Definición UIT: el servicio de aficionados por satélite utiliza estaciones espaciales situadas en satélites de la Tierra.],
)

#q("R8.57", "b",
  [En las comunidades autónomas con lengua cooficial, la autorización de radioaficionado:],
  ([se expide siempre solo en castellano], [deberá expedirse en formato bilingüe si lo solicita el interesado], [se expide solo en la lengua cooficial], [se expide en inglés]),
  sol: [En comunidades con lengua cooficial, la autorización se expide en formato bilingüe si lo solicita el interesado.],
)

#q("R8.58", "a",
  [En relación con los exámenes para obtener el certificado HAREC, señale la opción _incorrecta_:],
  ([es necesario estar en posesión de un certificado HAREC para poder presentarse], [hay que abonar previamente la tasa por presentación a las pruebas], [entre las materias figura la normativa reglamentaria de las estaciones de aficionado], [se convocan por resolución de la Secretaría de Estado competente en telecomunicaciones]),
  sol: [Para presentarse al examen no hace falta ningún certificado previo — el HAREC es justamente lo que se obtiene al aprobar. Las otras tres afirmaciones son ciertas.],
)

#q("R8.59", "c",
  [Las estaciones de aficionado quedan sometidas a la inspección de telecomunicaciones:],
  ([solo si media denuncia de un tercero], [solo durante el primer año desde su autorización], [siempre], [únicamente si superan los 100 vatios]),
  sol: [La sujeción a inspección es permanente y no depende de que haya denuncia, de la antigüedad ni de la potencia: forma parte de las condiciones de la autorización. Negarse u obstruirla constituye infracción grave.],
)

#q("R8.60", "a",
  [La autorización de radioaficionado habilita a su titular para:],
  ([efectuar emisiones en las bandas y con las características técnicas establecidas para el servicio de aficionados], [emitir en cualquier banda del espectro radioeléctrico], [prestar servicios de comunicación a terceros], [instalar antenas sin condición alguna]),
  sol: [La autorización no es un permiso genérico para radiar: habilita exactamente para lo que el servicio de aficionados tiene atribuido, con sus bandas, potencias y clases de emisión. Fuera de ahí no ampara nada.],
)

#q("R8.61", "b",
  [Un radioaficionado no está obligado a:],
  ([identificarse con su distintivo de llamada], [ser socio de una asociación de radioaficionados], [respetar las bandas atribuidas al servicio], [permitir la inspección de su estación]),
  sol: [Las asociaciones prestan servicios muy útiles —tramitación, #_r8-cod[QSL], repetidores— pero pertenecer a ellas es voluntario. Identificarse, respetar las bandas y permitir la inspección sí son obligaciones.],
)

#q("R8.62", "d",
  [El certificado HAREC:],
  ([caduca a los cinco años y debe renovarse], [solo tiene validez en España], [autoriza por sí mismo a transmitir, sin más trámites], [acredita haber superado un examen de operador conforme a la Recomendación T/R 61-02 de la CEPT]),
  sol: [HAREC es el certificado armonizado de operador de la Recomendación T/R 61-02 de la CEPT: acredita haber superado un examen con el programa armonizado (el de este cuaderno). No caduca, vale en todos los países que aplican la Recomendación y no sustituye a la autorización: esta hay que solicitarla.],
)

#q("R8.63", "c",
  [Para que un menor de edad pueda ser titular de una autorización de radioaficionado es necesario:],
  ([que haya cumplido los dieciséis años], [que la estación esté a nombre de un adulto], [aportar autorización fehaciente de sus padres o tutores], [superar una prueba adicional]),
  sol: [No hay edad mínima para presentarse ni para ser titular: lo que se exige es el consentimiento acreditado de quienes ejercen la patria potestad o la tutela, porque la autorización conlleva responsabilidades.],
)

#q("R8.64", "b",
  [Un ciudadano extranjero podrá obtener autorización de radioaficionado en España siempre que:],
  ([resida en un país de la Unión Europea], [acredite documentalmente su condición de residente en España y posea el certificado HAREC], [haya nacido en un país de la CEPT], [disponga de una estación fija en España]),
  sol: [Se piden dos cosas a la vez: residencia acreditada en España y acreditación de conocimientos mediante el certificado HAREC — obtenido aquí o en cualquier país que aplique la Recomendación T/R 61-02. (La otra vía para el residente extranjero es un convenio de reciprocidad con su país de origen, art. 5.2.b.)],
)

#q("R8.65", "a",
  [Las autorizaciones especiales de uso del espectro por aficionados:],
  ([son nominativas y solo habilitan a su titular], [son transmisibles a otro radioaficionado], [habilitan a todos los socios de la asociación solicitante], [no requieren distintivo de llamada]),
  sol: [Se conceden a una persona concreta y para una finalidad concreta, y no pueden cederse ni ampararse en ellas terceros. Es lo propio de una autorización excepcional sobre un bien de dominio público.],
)

#q("R8.66", "a",
  [Las utilizaciones de carácter experimental con características técnicas distintas de las autorizadas con carácter general:],
  ([requieren una autorización especial], [pueden realizarse libremente si no se causan interferencias], [están prohibidas en todo caso], [solo pueden efectuarlas las asociaciones]),
  sol: [Salirse de las características generales —potencias, bandas o modos distintos de los atribuidos— exige un permiso específico, porque el riesgo de interferir a otros servicios ya no está acotado por la norma general.],
)

#q("R8.67", "c",
  [Puede ser titular de una estación automática desatendida:],
  ([cualquier radioaficionado con autorización en vigor], [cualquier persona física, previa fianza], [una asociación de radioaficionados legalmente reconocida], [exclusivamente la Administración]),
  sol: [Repetidores, balizas y demás estaciones que funcionan sin operador presente se autorizan a asociaciones legalmente reconocidas, no a título individual: son infraestructura de uso común y necesitan un responsable estable.],
)

#q("R8.68", "d",
  [Se entiende por estación fija remota de aficionado aquella que:],
  ([funciona sin necesidad de autorización], [carece de antena exterior], [se instala en un vehículo], [puede ser accionada a distancia por su titular]),
  sol: [Es una estación fija normal salvo en un detalle: su titular la gobierna a distancia. Sigue siendo su responsabilidad cuanto se emita desde ella.],
)

#q("R8.69", "a",
  [Una estación portable de aficionado es:],
  ([una estación fija que puede utilizarse temporalmente en una ubicación distinta de la habitual], [una estación instalada permanentemente en un vehículo], [una estación que funciona sin operador], [una estación de potencia inferior a 10 vatios]),
  sol: [Portable no significa pequeña ni de poca potencia: significa que la estación fija se traslada temporalmente a otro emplazamiento. Distinta de la móvil, que opera en movimiento a bordo de un vehículo.],
)

#q("R8.70", "c",
  [Si un radioaficionado opera una estación de la que no es titular, deberá:],
  ([emplear el distintivo del titular de la estación], [abstenerse de identificarse], [identificarse con su propio distintivo, contando con la autorización del titular], [solicitar un distintivo temporal a la Administración]),
  sol: [El distintivo identifica al _operador_, no al aparato: quien habla se identifica con el suyo (art. 27 de la Orden: el distintivo identifica a su titular). Lo que hace falta es el consentimiento del titular de la estación, que responde de ella. Ojo: la Orden ITC/1791/2006 (art. 37.5, derogada) exigía además anteponer el distintivo del titular de la estación (véase R5.27); la Orden IET/1311/2013 no lo regula expresamente. La clave es la del banco de examen.],
)

#q("R8.71", "a",
  [La revocación de la autorización de radioaficionado lleva aparejada:],
  ([la cancelación del distintivo de llamada], [la pérdida del certificado HAREC], [la incautación automática de todos los equipos], [la prohibición de presentarse de nuevo al examen]),
  sol: [El distintivo es un accesorio de la autorización (art. 27: cada autorización lleva asociado un distintivo): si esta se revoca, aquel deja de tener soporte y se da de baja. A otra persona solo se reasigna una vez agotadas todas las combinaciones posibles; sí puede devolverse al anterior titular, si obtiene una nueva autorización, o a sus familiares en primer grado, en caso de fallecimiento (art. 28).],
)

#q("R8.72", "b",
  [Un distintivo de llamada que ya ha estado en uso podrá volver a asignarse:],
  ([nunca], [una vez cancelada la autorización y agotadas todas las combinaciones posibles (con excepciones)], [transcurrido un mes desde su último uso], [únicamente a familiares del anterior titular]),
  sol: [Art. 28 (párr. 3.º): los distintivos ya utilizados solo se reasignan una vez agotadas todas las combinaciones posibles. Excepciones: al anterior titular, si obtiene una nueva autorización tras una revocación, y a sus familiares en primer grado, si la baja fue por fallecimiento (no si el sufijo es de una letra). Cancelar la autorización es condición necesaria, pero no suficiente: el distintivo no queda disponible de inmediato ni de forma automática. El banco público da como clave «cuando se cancele la autorización correspondiente»; si en el examen aparece así, es la que dan por buena.],
)

#q("R8.73", "d",
  [Ninguna estación de aficionado puede reclamar el uso exclusivo de una frecuencia. Ello significa que:],
  ([quien llega primero conserva la frecuencia todo el día], [las frecuencias se reservan por escrito ante la Administración], [los concursos tienen prioridad sobre el resto del tráfico], [ninguna estación tiene derecho preferente sobre una frecuencia concreta]),
  sol: [El espectro es dominio público y su uso, compartido: nadie «posee» una frecuencia, ni por llegar antes ni por estar en concurso. De ahí que la única regla practicable sea la cortesía — preguntar si está ocupada y apartarse si lo está.],
)

#q("R8.74", "c",
  [Salvo casos de urgencia, la propiedad del inmueble que necesite el desmontaje de una antena autorizada para ejecutar obras debe requerirlo al titular con una antelación mínima de:],
  ([una semana], [quince días], [un mes], [seis meses]),
  sol: [Un mes de preaviso, salvo urgencia. El plazo existe para que el titular pueda organizar el desmontaje sin que la obra quede paralizada ni la instalación se retire de cualquier manera.],
)

#q("R8.75", "a",
  [Si una antena debidamente autorizada impide la realización de obras necesarias en el inmueble, su titular:],
  ([está obligado a desmontarla temporalmente sin derecho a indemnización], [puede negarse mientras dure su autorización], [tiene derecho a ser indemnizado por el desmontaje], [solo debe desmontarla si lo ordena un juez]),
  sol: [El derecho a instalar antenas no bloquea el mantenimiento del edificio: si la obra lo exige, la antena se desmonta temporalmente y el coste corre por cuenta del titular. Es la contrapartida del derecho que la Ley de Antenas le reconoce.],
)

#q("R8.76", "d",
  [Los daños y perjuicios que ocasione la antena de una estación de aficionado corren a cargo:],
  ([de la comunidad de propietarios], [del fabricante de la antena], [del seguro obligatorio de la vivienda], [del titular de la estación, incluidos los de instalación, mantenimiento y desmontaje]),
  sol: [La responsabilidad es del titular de la estación y abarca todo el ciclo de vida de la instalación: montarla, mantenerla y desmontarla. De ahí la exigencia de un seguro que cubra la responsabilidad civil.],
)

#q("R8.77", "b",
  [Los soportes y anclajes de una antena de aficionado:],
  ([pueden fijarse a cualquier elemento del edificio], [no deberán deteriorar la resistencia mecánica de los elementos constructivos a los que se fijen], [deben ser siempre de material aislante], [quedan bajo la responsabilidad del instalador]),
  sol: [No se puede comprometer la integridad del edificio para sujetar una antena. Anclajes, riostras y soportes deben repartir esfuerzos sin dañar los elementos constructivos ni su impermeabilización.],
)

#q("R8.78", "d",
  [Al instalar una antena de aficionado en el exterior de un inmueble es necesario:],
  ([retirar previamente las antenas de otros servicios], [situarla siempre por encima de las demás], [obtener la conformidad de todos los vecinos por unanimidad], [tener en cuenta las instalaciones y antenas de otros servicios existentes]),
  sol: [En una azotea suele haber antenas colectivas de televisión, pararrayos y otras instalaciones. La de aficionado debe convivir con ellas —en separación, en altura y en acoplo— y no puede retirarlas ni estorbarlas.],
)

#q("R8.79", "a",
  [Cuando se pretenden instalar antenas en el exterior de un inmueble en régimen de propiedad horizontal, procede:],
  ([comunicarlo previamente a la comunidad de propietarios, que dispone de dos meses para alegar], [prescindir de todo trámite si la autorización está en vigor], [solicitar permiso al ayuntamiento únicamente], [instalarlas y notificarlo después de un año]),
  sol: [La fachada y la cubierta son elementos comunes: aunque la ley reconozca el derecho a instalar antenas, su ejercicio pasa por informar a la comunidad. La comunicación la hace la Administración una vez aceptada la memoria de instalación (RD 2623/1986, art. 3); la comunidad (o su presidente, cuyo dato debe constar en la solicitud, art. 2.4) dispone de dos meses para alegar sobre la idoneidad del emplazamiento o los perjuicios y, si calla, se entiende que acepta. No autoriza ni prohíbe: la autorización es administrativa.],
)

#q("R8.80", "d",
  [De acuerdo con el artículo 25 del Reglamento de Radiocomunicaciones de la UIT, las comunicaciones entre estaciones de aficionado de distintos países:],
  ([están prohibidas salvo autorización expresa], [solo se permiten dentro de la misma Región], [requieren la presencia de un intérprete oficial], [se permiten, salvo que la Administración de alguno de los países afectados haya manifestado su oposición]),
  sol: [El criterio del artículo 25 es permisivo: las comunicaciones internacionales entre aficionados están permitidas salvo que una de las Administraciones implicadas haya notificado su oposición. Por eso existen países con los que no se puede contactar.],
)

#q("R8.81", "c",
  [Según el Apéndice 1 del Reglamento de Radiocomunicaciones, la clase de emisión F3E corresponde a:],
  ([telegrafía por manipulación de portadora], [televisión de aficionado], [telefonía con un solo canal], [transmisión de datos multicanal]),
  sol: [En la designación de tres símbolos, F es modulación de frecuencia, 3 es un único canal con información analógica y E es telefonía. Es la clase de las emisiones de FM en 2 metros.],
)

#q("R8.82", "b",
  [El certificado HAREC permite a su titular:],
  ([emitir sin autorización en cualquier país], [obtener autorización de radioaficionado en los países que aplican la Recomendación T/R 61-02], [duplicar la potencia autorizada], [quedar exento del pago de tasas]),
  sol: [El HAREC no autoriza a emitir por sí solo: acredita conocimientos. Con él, cualquier país que aplique la Recomendación reconoce la capacitación y puede expedir su propia autorización sin repetir examen.],
)

#q("R8.83", "a",
  [En el procedimiento previsto en la Recomendación T/R 61-02 de la CEPT sobre el certificado HAREC pueden participar:],
  ([países pertenezcan o no a la CEPT], [únicamente los países miembros de la CEPT], [exclusivamente los países de la Unión Europea], [solamente los países de la Región 1]),
  sol: [La T/R 61-02 nació en el ámbito de la CEPT, pero su procedimiento está abierto a Administraciones de fuera, y son bastantes las que se han adherido. De ahí que el HAREC tenga alcance más amplio que la propia CEPT.],
)

#q("R8.84", "c",
  [El titular de una licencia CEPT que opera en otro país:],
  ([queda sujeto únicamente a la normativa de su país de origen], [puede emplear la potencia máxima de su país de origen], [debe respetar el Reglamento de Radiocomunicaciones y la reglamentación del país visitado], [está exento de identificarse]),
  sol: [La licencia CEPT ahorra el trámite, no las reglas: se opera con las bandas, potencias y condiciones del país en que uno se encuentra, y con sujeción al Reglamento de Radiocomunicaciones.],
)

#q("R8.85", "c",
  [Un radioaficionado extranjero que opera temporalmente en España al amparo de la licencia CEPT se identifica:],
  ([únicamente con su distintivo de origen], [con un distintivo español que se le asigna al llegar], [anteponiendo a su distintivo el prefijo español y, opcionalmente, el número del distrito], [sin necesidad de identificarse durante los tres primeros meses]),
  sol: [Se antepone el prefijo del país visitado —EA en España— y, opcionalmente, el número del distrito desde el que se opera (art. 14.e de la Orden), seguido de barra y del distintivo propio: #_r8-cod[EA4/M0ABC] o #_r8-cod[EA/M0ABC]. Así se sabe de dónde emite y quién es. (La Orden de 2006 hacía obligatorio el número de distrito.)],
)

#q("R8.86", "a",
  [La estación de aficionado debe estar provista de:],
  ([los elementos adecuados para comprobar que la emisión se ajusta a lo autorizado], [un registro escrito de todas las comunicaciones], [un duplicado de los equipos principales], [una línea telefónica independiente]),
  sol: [Anexo I, 4.5: la estación debe tener elementos para comprobar que la emisión se produce dentro de las bandas autorizadas y para medir de forma indicativa la potencia. No se exige medidor de ondas estacionarias ni, en cambio, llevar libro de registro.],
)

#q("R8.87", "d",
  [Se entiende por estación digital de aficionado aquella:],
  ([que solo puede emplear telegrafía], [cuyos equipos son de fabricación industrial], [que carece de mandos analógicos], [dotada de dispositivos que permiten realizar emisiones con técnicas digitales]),
  sol: [Lo que la define es la técnica de emisión, no el aspecto del equipo: transmisión de datos, modos digitales de fonía o de texto. Un transceptor con mandos convencionales puede operar perfectamente en digital.],
)

#q("R8.88", "d",
  [Un radioaficionado español que traslada su residencia a un país que aplica la Recomendación T/R 61-02 podrá obtener allí autorización porque:],
  ([su distintivo español es válido en todo el mundo], [la CEPT expide autorizaciones directamente], [basta con acreditar la propiedad de los equipos], [dispone del certificado HAREC]),
  sol: [Lo que viaja con el radioaficionado es la acreditación de conocimientos, no la autorización: el país de destino expide la suya reconociendo el HAREC. El distintivo español, en cambio, no vale allí.],
)
