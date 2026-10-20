import json, re, sys
d = json.load(open('/Users/albertogarciaplanes/tmpradio/build/r1r5/qs.json'))

LABELS = {'R1.1': 'r1-cuadro-alfabeto', 'R4.1': 'r4-cuadro-senales', 'R4.2': 'r4-cuadro-bandas', 'R5.1': 'r5-cuadro-distritos'}

def esc(t):
    t = t.replace('\\', '\\\\')
    for ch in '#$@<~':
        t = t.replace(ch, '\\' + ch)
    return t

def lead_guard(t):
    if re.match(r'^([-+=]\s|\d+\.\s)', t):
        return '\\' + t
    return t

SC = {  # R4 solution small caps
    'R4.1': [('Mayday (del', '#_r4-sc("Mayday") (del')],
    'R4.2': [('Pan Pan tres', '#_r4-sc("Pan Pan") tres')],
    'R4.3': [('SÉcuRitÉ tres', '#_r4-sc("Sécurité") tres')],
    'R4.5': [('equivalente a Pan Pan.', 'equivalente a #_r4-sc("Pan Pan").')],
    'R4.6': [('equivalente a SÉcuRitÉ.', 'equivalente a #_r4-sc("Sécurité").')],
}

def fix_sol(qid, s):
    s = esc(s)
    s = s.replace('_power_ :', '_power_:')
    for tid, lab in LABELS.items():
        s = s.replace('tabla ' + tid, 'tabla #ref(<' + lab + '>, supplement: none)')
    if qid == 'R2.17':
        s = s.replace('_𝑛_', '$n$')
    if qid == 'R4.9':
        s = s.replace('_𝜆_ = 20 m ⇒ _𝑓_ ≈ 300/20 = 15 MHz', '$lambda = 20 "m" => f approx 300 slash 20 = 15 "MHz"$')
        s = s.replace('_𝜆_ ≈ 300/_𝑓_', '$lambda approx 300 slash f$')
    for a, b in SC.get(qid, []):
        assert a in s, (qid, a, s)
        s = s.replace(a, b)
    return s

def qblock(qid):
    v = d[qid]
    stem = lead_guard(esc(v['stem']))
    opts = ', '.join('[' + lead_guard(esc(o[1])) + ']' for o in v['opts'])
    sol = fix_sol(qid, v['sol'])
    return (f'#q("{qid}", "{v["ans"]}",\n  [{stem}],\n  ({opts}),\n  sol: [{sol}],\n)\n')

def qrange(g, a, b):
    return '\n'.join(qblock(f'{g}.{i}') for i in range(a, b + 1))

def expand(s):
    def rep(m):
        g, a, b = m.group(1), int(m.group(2)), int(m.group(3))
        return qrange(g, a, b)
    return re.sub(r'@@Q (R\d) (\d+) (\d+)@@', rep, s)

HEAD = '#import "/lib/template.typ": *\n#import "/lib/circuits.typ": *\n\n'

GRUPOS = r'''
// Tabla de pares (código, significado) en n grupos de columnas, ordenada por columnas.
#let _R-grupos(pares, n: 2, cab: ([Grupo], [Significado])) = {
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
'''

DLG = r'''
// Diálogo de un comunicado: filas (indicativo, texto).
#let _R-dlg(..filas) = block(above: 0.8em, below: 0.5em, grid(
  columns: (auto, 1fr),
  column-gutter: 1em,
  row-gutter: 0.9em,
  ..filas.pos().map(f => (text(weight: "bold", raw(f.at(0))), f.at(1))).flatten(),
))
'''

def helpers(k, grupos=True, dlg=True):
    s = ''
    if grupos: s += GRUPOS.replace('_R-', f'_r{k}-')
    if dlg: s += DLG.replace('_R-', f'_r{k}-')
    return s

CHAPTERS = {}

# ---------------------------------------------------------------- R1
CHAPTERS['r01'] = HEAD + r'''
// Pares (letra, palabra) del alfabeto fonético internacional.
#let _r1-letras = (
  ("A", "Alfa"), ("B", "Bravo"), ("C", "Charlie"), ("D", "Delta"), ("E", "Echo"), ("F", "Foxtrot"),
  ("G", "Golf"), ("H", "Hotel"), ("I", "India"), ("J", "Juliett"), ("K", "Kilo"), ("L", "Lima"),
  ("M", "Mike"), ("N", "November"), ("O", "Oscar"), ("P", "Papa"), ("Q", "Quebec"), ("R", "Romeo"),
  ("S", "Sierra"), ("T", "Tango"), ("U", "Uniform"), ("V", "Victor"), ("W", "Whiskey"), ("X", "X-ray"),
  ("Y", "Yankee"), ("Z", "Zulu"),
)

#tema("R1", "Alfabeto fonético internacional", alcance: [Códigos para el deletreo de letras y cifras.])

En radiotelefonía se deletrea con el alfabeto fonético internacional (OACI/UIT). Dominarlo de memoria es imprescindible: cae siempre en el examen y se usa en cada `QSO` para deletrear indicativos.

#figure(
  {
    set text(size: 10pt)
    let cab = ([Letra], [Palabra])
    let celdas = cab * 3
    for r in range(9) {
      for g in range(3) {
        let i = g * 9 + r
        if i < _r1-letras.len() {
          celdas += (strong(_r1-letras.at(i).at(0)), _r1-letras.at(i).at(1))
        } else {
          celdas += ([], [])
        }
      }
    }
    table(
      columns: (auto, 1fr) * 3,
      column-gutter: 0pt,
      align: left + horizon,
      fill: (x, y) => if y == 0 { col.gris-claro } else if calc.odd(calc.div-euclid(x, 2)) { col.acento-claro.lighten(55%) } else { none },
      inset: (x: 8pt, y: 4.5pt),
      ..celdas,
    )
  },
  kind: table,
  supplement: [Cuadro],
  caption: [Alfabeto fonético internacional. Grafías oficiales: _Alfa_ (sin _ph_), _Juliett_ (con doble _t_) y _X-ray_ (con guion).],
) <r1-cuadro-alfabeto>

#nota[Las *cifras* se deletrean con su nombre inglés: _Zero, One, Two, Three, Four, Five, Six, Seven, Eight, Nine_ (el sistema fonético de la UIT usa además las formas compuestas _Nadazero, Unaone…Novenine_, hoy poco usadas). Así se deletrean también en el examen y en el tráfico internacional: `EA5` = «Echo Alfa _Five_». Entre españoles, al hablar, se oye a veces la cifra en castellano («Echo Alfa _cinco_»), pero esa no es la forma que da por buena el banco de preguntas: el deletreo internacional da siempre las cifras en inglés.]

#truco[Las que más se fallan: *J* es _Juliett_ (no «Julio»), *Q* es _Quebec_ (no «Queen»), *S* es _Sierra_ (no «Santiago», que pertenece al alfabeto español antiguo), y *N* es _November_ (no «Nancy»). Los distractores del examen suelen venir justamente de esos otros alfabetos.]

@@Q R1 1 40@@
'''

# ---------------------------------------------------------------- R2
CHAPTERS['r02'] = HEAD + r'''#tema("R2", "Código Q", alcance: [Grupos del código Q más utilizados en el Servicio de Aficionados y en el Servicio de Aficionados por Satélite.])

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

@@Q R2 1 34@@
'''

# ---------------------------------------------------------------- R3
CHAPTERS['r03'] = HEAD + r'''#tema("R3", "Abreviaturas", alcance: [Abreviaturas más usuales en las comunicaciones de radioaficionados.])

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

@@Q R3 1 38@@
'''

# ---------------------------------------------------------------- R4
CHAPTERS['r04'] = HEAD + r'''// Versalitas simuladas (Charter no tiene versalitas): para Mayday, Pan Pan y Sécurité.
#let _r4-sc(t) = {
  for c in t.clusters() {
    if lower(c) == c and upper(c) != c { text(size: 0.8em, upper(c)) } else { c }
  }
}

#tema("R4", "Señales de socorro, urgencia y seguridad", alcance: [Señales radiotelegráficas y radiotelefónicas de alarma, socorro, urgencia y seguridad · empleo internacional de las radiocomunicaciones de aficionado en catástrofes naturales (Resolución 640 del Reglamento de Radiocomunicaciones) · bandas de frecuencias atribuidas al Servicio de Aficionados y al Servicio de Aficionados por Satélite.])

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

@@Q R4 1 8@@

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

@@Q R4 9 16@@
'''

# ---------------------------------------------------------------- R5
CHAPTERS['r05'] = HEAD + r'''
#tema("R5", "Distintivos de llamada", alcance: [Identificación de las estaciones radioeléctricas de aficionado · uso de los distintivos de llamada · composición de los distintivos (prefijo, distrito y sufijo) · prefijos nacionales.])

El distintivo se compone de _prefijo_ + _distrito_ + _sufijo_: en `EA5RCA`, `EA` es el prefijo, el `5` indica el distrito y `RCA` es el sufijo. Los prefijos atribuidos a España son `EA`–`EH` — a los que se añade la serie `AM`–`AO`, empleada en usos especiales —; los habituales para radioaficionados son `EA`, `EB` y `EC`, y las estaciones automáticas desatendidas usan `ED`.

#figure(
  {
    set text(size: 10pt)
    table(
      columns: (auto, auto),
      align: (center + horizon, left + horizon),
      fill: (x, y) => if y == 0 { col.gris-claro } else if x == 0 { col.acento-claro.lighten(55%) } else { none },
      inset: (x: 9pt, y: 4.5pt),
      [Distrito], [Zona geográfica],
      [0], [reservado a actos inaugurados o visitados por S. M. el Rey],
      [1], [Galicia, Asturias, Cantabria, Castilla y León y La Rioja],
      [2], [País Vasco, Navarra y Aragón],
      [3], [Cataluña],
      [4], [Madrid, Castilla-La Mancha (parte) y Extremadura],
      [5], [Comunidad Valenciana, Murcia y Albacete],
      [6], [Islas Baleares],
      [7], [Andalucía],
      [8], [Islas Canarias],
      [9], [Ceuta y Melilla],
    )
  },
  kind: table,
  supplement: [Cuadro],
  caption: [Distritos de los distintivos de llamada españoles.],
) <r5-cuadro-distritos>

#truco[Los insulares y las ciudades autónomas son los que más caen: *EA6* Baleares, *EA8* Canarias, *EA9* Ceuta y Melilla. Para los sufijos de las estaciones desatendidas: *Y* de analógica y *Z* de digital (`ED1YBD` repetidor analógico, `ED5ZAA` repetidor digital).]

@@Q R5 1 12@@

== Sufijos y usos temporales <r5-sec-sufijos>

El artículo 27 de la Orden IET/1311/2013 regula la composición del distintivo y sus variantes temporales. El _sufijo_ consta de una a tres letras, asignadas por riguroso turno de expedición. Los de tres letras son los ordinarios; los de una y dos letras son escasos y pueden adjudicarse a radioaficionados con al menos cinco años de autorización española que acrediten quince (una letra) o cinco (dos letras) años de práctica en la radioafición internacional y no hayan sido sometidos a expediente sancionador en los últimos cinco años. Los de una letra se reservan, además, para la participación en concursos internacionales de alta competitividad. Desde el 19 de septiembre de 2026 rige un procedimiento ordinario para asignar el sufijo de una letra (Resolución de 29 de julio de 2026 de la Secretaría de Estado de Telecomunicaciones e Infraestructuras Digitales, SETID, hoy la SETSI de la Orden; BOE-A-2026-17504, que deroga la de 12 de julio de 2019): solicitud por medios electrónicos, por distrito y por orden de presentación, con hasta diez distintivos preferentes; la práctica internacional se acredita con tarjetas `QSL` (dos por año durante quince de los últimos veinte) y el nuevo distintivo sustituye al anterior del titular. Dentro de los de tres letras hay reservas (art. 27.3): `UR` para las estaciones colectivas de asociaciones de radioaficionados y `RC` o `RK` para las de radioclubes, respectivamente; e `Y` o `Z` para las desatendidas analógicas y digitales, también respectivamente.

Para los usos temporales — concursos, experimentos, ensayos, conmemoraciones — el prefijo habitual se sustituye por otro que refleja el rango del evento, _previa autorización de la Jefatura Provincial_ (art. 27.1). Solo con `ED`, `EE` y `EF` se mantiene sin variación el resto del distintivo permanente (art. 27.1.a); con `EG`, `EH`, `AM`, `AN` y `AO` el distintivo lleva un sufijo propio de dos o tres letras:

#align(center, {
  set text(size: 9.5pt)
  table(
    columns: (auto, auto),
    align: left + horizon,
    fill: (x, y) => if y == 0 { col.gris-claro } else { none },
    inset: (x: 8pt, y: 4.5pt),
    [Prefijo temporal], [Rango del evento],
    [`ED`, `EE`, `EF`], [concursos, experimentos, ensayos, demostraciones y otros eventos de ámbito local, regional, autonómico o nacional],
    [`EG`, `EH`], [concursos, eventos internacionales y otros eventos relevantes de ámbito local, regional o autonómico],
    [`AM`, `AN`], [eventos relevantes de ámbito nacional],
    [`AO`], [eventos relevantes de ámbito internacional y, con carácter optativo, emisiones de radioaficionados españoles en zonas no adscritas a soberanías nacionales],
  )
})

Cada evento exige una solicitud independiente (período de utilización, distintivo pedido, motivo y tipo de estación), y los períodos autorizados para un mismo sufijo y peticionario no pueden superar, como norma general, los *30 días al año* (art. 28). La excepción son los distintivos de una sola letra empleados exclusivamente en concursos de alta competitividad, que pueden autorizarse al mismo titular por hasta *dos años* desde la fecha de autorización.

#ojo[`ED` tiene doble vida: es prefijo de uso temporal (con `EE` y `EF`) y, a la vez, el prefijo _permanente_ de las estaciones automáticas desatendidas.]

@@Q R5 13 20@@

== Asignación y uso del distintivo <r5-sec-asignacion>

El distintivo se otorga junto con la autorización, con la cifra del distrito de residencia del titular _en el momento del otorgamiento_ (art. 27.2). Es único y no puede modificarse (art. 28), salvo por cambio del número de letras del sufijo o por la asignación de distintivos adicionales: mudarse de distrito solo obliga a comunicar el nuevo domicilio a la SETSI (art. 7.3), no a cambiar de distintivo. Un distintivo ya utilizado solo se reasigna cuando se han agotado todas las combinaciones posibles, con dos excepciones: al anterior titular, si obtiene una nueva autorización tras una revocación, y a sus familiares en primer grado, si la baja se produjo por fallecimiento (salvo que el sufijo sea de una letra). Quedan excluidos de cualquier asignación los grupos de letras que expresan las señales de socorro, urgencia y seguridad — `DDD`, `PAN`, `SOS`, `TTT` y `XXX`, «y otras» — y toda la serie `QAA`–`QZZ`, para que ningún sufijo pueda confundirse con un código Q. En el uso diario, la estación transmite su distintivo al comienzo y al final de cada emisión y, si esta es larga, periódicamente a lo largo de ella.

#ojo[Las preguntas de los bancos antiguos sobre el cambio de domicilio («podrá solicitar mantener su sufijo», «no podrá mantener su distintivo si cambia de distrito») siguen la Orden ITC/1791/2006 y sus Instrucciones de 2006, derogadas: la Orden vigente no obliga a cambiar de distintivo al mudarse. Conviene conocer ambas versiones, porque el examen puede seguir usando la antigua.]

@@Q R5 21 49@@
'''

import os
for name, src in CHAPTERS.items():
    body = src[len(HEAD):]
    lines = body.split('\n')
    tema = [l for l in lines if l.startswith('#tema(')][0]
    lines.remove(tema)
    body = '\n'.join(lines)
    k = int(name[-1])
    extra = helpers(k) if name in ('r02', 'r03', 'r04') else ''
    out = expand(HEAD + tema + '\n' + extra + '\n' + body).replace('@@', '')
    out = re.sub(r'\n{3,}', '\n\n', out)
    path = f'/Users/albertogarciaplanes/tmpradio/build/r1r5/out/{name}.typ'
    open(path, 'w').write(out.rstrip() + '\n')
    print(name, len(out))
