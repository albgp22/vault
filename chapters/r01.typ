#import "/lib/template.typ": *
#import "/lib/circuits.typ": *

#tema("R1", "Alfabeto fonético internacional", alcance: [Códigos para el deletreo de letras y cifras.])

// Pares (letra, palabra) del alfabeto fonético internacional.
#let _r1-letras = (
  ("A", "Alfa"), ("B", "Bravo"), ("C", "Charlie"), ("D", "Delta"), ("E", "Echo"), ("F", "Foxtrot"),
  ("G", "Golf"), ("H", "Hotel"), ("I", "India"), ("J", "Juliett"), ("K", "Kilo"), ("L", "Lima"),
  ("M", "Mike"), ("N", "November"), ("O", "Oscar"), ("P", "Papa"), ("Q", "Quebec"), ("R", "Romeo"),
  ("S", "Sierra"), ("T", "Tango"), ("U", "Uniform"), ("V", "Victor"), ("W", "Whiskey"), ("X", "X-ray"),
  ("Y", "Yankee"), ("Z", "Zulu"),
)

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

#q("R1.1", "b",
  [En el alfabeto fonético internacional, la letra «S» se deletrea:],
  ([Santiago], [Sierra], [Sugar], [Sábado]),
  sol: [«S» es _Sierra_. «Santiago» es del alfabeto español antiguo y «Sugar» del militar anglosajón de los años 40.],
)

#q("R1.2", "c",
  [En el alfabeto fonético internacional, la letra «Q» se deletrea:],
  ([Quintal], [Queen], [Quebec], [Quito]),
  sol: [«Q» es _Quebec_; «Queen» es el distractor clásico del alfabeto británico antiguo.],
)

#q("R1.3", "b",
  [La palabra de deletreo «Whiskey» corresponde a la letra:],
  ([V], [W], [X], [K]),
  sol: [_Whiskey_ deletrea la W; la V es _Victor_ y la X, _X-ray_.],
)

#q("R1.4", "c",
  [El prefijo `EA` de un distintivo de llamada español se deletrea:],
  ([Eco Antena], [España América], [Echo Alfa], [Echo Able]),
  sol: [`EA` = _Echo Alfa_ (tabla #ref(<r1-cuadro-alfabeto>, supplement: none)); grafías oficiales sin hache final ni _ph_.],
)

#q("R1.5", "d",
  [En el alfabeto fonético internacional, la letra «L» se deletrea:],
  ([Londres], [Libra], [Luis], [Lima]),
  sol: [«L» es _Lima_; «Luis» es del alfabeto español antiguo.],
)

#q("R1.6", "a",
  [El sufijo `BOJ` de un distintivo de llamada se deletrea:],
  ([Bravo Oscar Juliett], [Baker Oboe Jig], [Bravo Omega Julio], [Beta Oscar Java]),
  sol: [`BOJ` = _Bravo Oscar Juliett_; «Baker» y «Oboe» son del alfabeto de 1943.],
)

#q("R1.7", "c",
  [En el alfabeto fonético internacional, la letra «M» se identifica con la palabra:],
  ([Mario], [Madrid], [Mike], [Metro]),
  sol: [«M» es _Mike_. Mario, Madrid y Metro pertenecen a alfabetos nacionales antiguos, que no se emplean en el servicio de aficionados.],
)

#q("R1.8", "a",
  [En el alfabeto fonético internacional, la letra «V» se corresponde con la palabra:],
  ([Victor], [Valencia], [Vasco], [Vector]),
  sol: [«V» es _Victor_, sin tilde y pronunciado a la inglesa. Es además la letra que se transmite repetida para ajustar la recepción (`QSV`), por su ritmo inconfundible en Morse.],
)

#q("R1.9", "b",
  [En el deletreo internacional, la cifra «9» se identifica con la palabra:],
  ([Nono], [Nine], [Novem], [Ene]),
  sol: [En el deletreo del banco oficial, el 9 es _Nine_ (en la práctica aeronáutica se pronuncia «niner» para no confundirlo con el alemán _nein_).],
)

#q("R1.10", "d",
  [El sufijo `CID` se deletrea:],
  ([Charlie Italia Delta], [Cid India Delta], [Charlie India Dog], [Charlie India Delta]),
  sol: [`CID` = _Charlie India Delta_; «Italia» y «Dog» pertenecen a otros alfabetos.],
)

#q("R1.11", "a",
  [El sufijo `TOP` se deletrea:],
  ([Tango Oscar Papa], [Tango Omega Portugal], [Tres Oscar Papa], [Tango Oscar Perú]),
  sol: [`TOP` = _Tango Oscar Papa_.],
)

#q("R1.12", "c",
  [El distintivo `ED5ZAA` se deletrea:],
  ([Eco Delta Five Zeta Alfa Alfa], [España Delta Five Zulu Alfa Alfa], [Echo Delta Five Zulu Alfa Alfa], [Echo Dog Five Zebra Able Able]),
  sol: [`ED5ZAA` = _Echo Delta Five Zulu Alfa Alfa_: las letras con el alfabeto internacional y la cifra con su nombre inglés (_Five_). La a dice «Eco» y «Zeta», que no son palabras del alfabeto; la b pone «España» por la E; la d mezcla palabras del alfabeto antiguo (_Dog_, _Able_, _Zebra_).],
)

#q("R1.13", "b",
  [En el alfabeto fonético internacional, la letra «J» se deletrea:],
  ([Jupiter], [Juliett], [Jamaica], [Jaguar]),
  sol: [Se escribe con doble t final, _Juliett_, precisamente para que los francófonos no la pronuncien muda. Las otras tres no pertenecen al alfabeto de la OACI.],
)

#q("R1.14", "d",
  [En el alfabeto fonético internacional, la letra «G» se deletrea:],
  ([Gamma], [Granada], [Gustavo], [Golf]),
  sol: [_Golf_. Gustavo pertenece al antiguo alfabeto español, que ya no se emplea en el servicio de aficionados.],
)

#q("R1.15", "a",
  [En el alfabeto fonético internacional, la letra «Y» se deletrea:],
  ([Yankee], [Yolanda], [Yucatán], [Yeso]),
  sol: [_Yankee_. Aparece a menudo en los sufijos españoles, así que conviene tenerla automatizada.],
)

#q("R1.16", "c",
  [La palabra de deletreo «Kilo» corresponde a la letra:],
  ([C], [Q], [K], [G]),
  sol: [_Kilo_ es la K. Ojo con el reflejo de asociarla al prefijo de las unidades: aquí es simplemente una palabra elegida por sonar distinta de todas las demás.],
)

#q("R1.17", "b",
  [En el deletreo internacional, la cifra «0» se identifica con la palabra:],
  ([Nada], [Zero], [Cero], [Oscar]),
  sol: [Las cifras se dicen en inglés: _Zero_. Y no debe confundirse con _Oscar_, que es la letra O — la confusión entre el cero y la o es justamente lo que el deletreo evita.],
)

#q("R1.18", "d",
  [En el deletreo internacional, la cifra «5» se identifica con la palabra:],
  ([Cinco], [Fife], [Penta], [Five]),
  sol: [_Five_. La variante _Fife_ pertenece a la fonética aeronáutica, pensada para radios muy ruidosas, pero no es la del servicio de aficionados.],
)

#q("R1.19", "a",
  [En el alfabeto fonético internacional, la letra «X» se deletrea:],
  ([X-ray], [Xilófono], [Extra], [Xenón]),
  sol: [_X-ray_, y se pronuncia «ecs-rey». Es de las que más se atragantan al principio porque no se parece en nada a la letra en castellano.],
)

#q("R1.20", "c",
  [En el alfabeto fonético internacional, la letra «P» se deletrea:],
  ([Pedro], [Peter], [Papa], [Portugal]),
  sol: [_Papa_, con acento en la última sílaba a la francesa («pa-PÁ»). Pedro y Peter pertenecen a alfabetos nacionales antiguos.],
)

#q("R1.21", "b",
  [El distintivo de llamada `EA4XYZ` se deletrea:],
  ([España América Four Equis Yolanda Zaragoza], [Echo Alfa Four X-ray Yankee Zulu], [Echo Alfa Four X-ray Yankee Zeta], [Echo Alpha Four Xilófono Yankee Zeta]),
  sol: [Las letras, con las palabras oficiales del alfabeto internacional —_Echo_, con hache, no «Eco»; _Alfa_, no «Alpha»— y la cifra con su nombre inglés, _Four_, como en todo el deletreo internacional. La opción c acierta hasta el final, pero «Zeta» no es palabra del alfabeto (la Z es _Zulu_); la d mezcla «Alpha», «Xilófono» y «Zeta», y la a usa nombres de letras y ciudades en castellano.],
)

#q("R1.22", "d",
  [En el alfabeto fonético internacional, la letra «H» se deletrea:],
  ([Habana], [Hotel Alfa], [Historia], [Hotel]),
  sol: [_Hotel_, una sola palabra por letra. Encadenar dos —«Hotel Alfa»— sería deletrear HA, no H.],
)

#q("R1.23", "a",
  [El alfabeto fonético internacional se emplea para:],
  ([deletrear letras y cifras evitando confusiones en condiciones difíciles], [cifrar el contenido de los mensajes], [abreviar los mensajes y ganar tiempo], [identificar el país de procedencia de la estación]),
  sol: [Con ruido, desvanecimiento o acentos distintos, una B y una P suenan igual; _Bravo_ y _Papa_, no. No cifra nada —de hecho es público— ni abrevia: al contrario, alarga.],
)

#q("R1.24", "c",
  [La palabra de deletreo «Foxtrot» corresponde a la letra:],
  ([T], [X], [F], [V]),
  sol: [_Foxtrot_ es la F. Conviene fijarse en la palabra entera y no en su primera sílaba, que despista hacia la X.],
)

#q("R1.25", "c",
  [En el alfabeto fonético internacional, la letra «A» se deletrea:],
  ([Antonio], [Able], [Alfa], [América]),
  sol: [_Alfa_, escrito así y no «Alpha»: la grafía oficial evita el grupo _ph_, que no todos los idiomas pronuncian igual. _Able_ es del alfabeto anglosajón de los años cuarenta.],
)

#q("R1.26", "b",
  [En el alfabeto fonético internacional, la letra «B» se deletrea:],
  ([Barcelona], [Bravo], [Baker], [Bilbao]),
  sol: [_Bravo_. _Baker_ pertenece al alfabeto de 1943 y aún se oye en películas antiguas, pero no es el vigente.],
)

#q("R1.27", "d",
  [En el alfabeto fonético internacional, la letra «C» se deletrea:],
  ([Carmen], [Canadá], [Coca], [Charlie]),
  sol: [_Charlie_. _Coca_ pertenece al alfabeto aeronáutico de 1951, sustituido en 1956 por el actual y hoy en desuso; el alfabeto de la OACI adoptado por el servicio de aficionados usa Charlie.],
)

#q("R1.28", "a",
  [En el alfabeto fonético internacional, la letra «D» se deletrea:],
  ([Delta], [Dolores], [Dog], [Dinamarca]),
  sol: [_Delta_, una de las más fáciles de recordar por coincidir con la letra griega. _Dog_ es del alfabeto anglosajón antiguo.],
)

#q("R1.29", "c",
  [En el alfabeto fonético internacional, la letra «E» se deletrea:],
  ([Enrique], [Easy], [Echo], [España]),
  sol: [_Echo_, con hache intercalada. Ojo con confundirla con _Eco_ a la española: la grafía oficial es la inglesa.],
)

#q("R1.30", "b",
  [En el alfabeto fonético internacional, la letra «I» se deletrea:],
  ([Italia], [India], [Inés], [Item]),
  sol: [_India_. Es de las pocas que coinciden con una palabra castellana reconocible, lo que la hace cómoda pero también fácil de sustituir por «Italia» sin darse cuenta.],
)

#q("R1.31", "d",
  [En el alfabeto fonético internacional, la letra «N» se deletrea:],
  ([Navarra], [Nancy], [Nueva York], [November]),
  sol: [_November_. Junto con _Mike_, es de las que más se atragantan porque no se parecen a nada en castellano.],
)

#q("R1.32", "b",
  [En el alfabeto fonético internacional, la letra «O» se deletrea:],
  ([Oviedo], [Oscar], [Oboe], [Ontario]),
  sol: [_Oscar_. Es además la letra que se confunde con el cero, y por eso el deletreo insiste: la letra es _Oscar_ y la cifra, _Zero_.],
)

#q("R1.33", "c",
  [En el alfabeto fonético internacional, la letra «R» se deletrea:],
  ([Ramón], [Roger], [Romeo], [Roma]),
  sol: [_Romeo_. _Roger_, que también empieza por R, significa «recibido» en fonía: son cosas distintas y conviene no mezclarlas.],
)

#q("R1.34", "a",
  [En el alfabeto fonético internacional, la letra «T» se deletrea:],
  ([Tango], [Tarragona], [Toledo], [Tare]),
  sol: [_Tango_. Aparece con frecuencia en los sufijos españoles, así que conviene tenerla automatizada.],
)

#q("R1.35", "c",
  [En el alfabeto fonético internacional, la letra «U» se deletrea:],
  ([Ulises], [Unión], [Uniform], [Uncle]),
  sol: [_Uniform_, sin la e final del castellano. _Uncle_ es del alfabeto anglosajón antiguo.],
)

#q("R1.36", "d",
  [En el alfabeto fonético internacional, la letra «Z» se deletrea:],
  ([Zaragoza], [Zebra], [Zeta], [Zulu]),
  sol: [_Zulú_. _Zebra_ pertenece al alfabeto de 1943; conviene recordar que la Z cierra el alfabeto y da nombre al huso horario de referencia, la hora _zulú_ o UTC.],
)

#q("R1.37", "b",
  [En el deletreo internacional, la cifra «7» se identifica con la palabra:],
  ([Siete], [Seven], [Sierra], [Severo]),
  sol: [_Seven_. Las cifras se dicen en inglés; _Sierra_ es la letra S y _Severo_ no pertenece a ningún alfabeto normalizado.],
)

#q("R1.38", "c",
  [En el deletreo internacional, la cifra «3» se identifica con la palabra:],
  ([Tres], [Tango], [Three], [Trío]),
  sol: [_Three_. El distractor _Tango_ juega con que la palabra empieza por T, pero esa es una letra, no una cifra.],
)

#q("R1.39", "d",
  [En el deletreo internacional, la cifra «8» se identifica con la palabra:],
  ([Ocho], [Octavo], [Oscar], [Eight]),
  sol: [_Eight_. El distractor _Oscar_ aprovecha el parecido entre «ocho» y la letra O en castellano.],
)

#q("R1.40", "b",
  [El distintivo `EC9ZUL` se deletrea:],
  ([España Carmen Nine Zaragoza Ulises Lima], [Echo Charlie Nine Zulu Uniform Lima], [Echo Coca Nine Zebra Uncle Lima], [Eco Charlie Nine Zeta Unión Luis]),
  sol: [Letra por letra con el alfabeto internacional y la cifra con su nombre inglés: _Echo Charlie Nine Zulu_ _Uniform Lima_. Las demás mezclan palabras de alfabetos nacionales o antiguos (_Carmen_, _Coca_, _Uncle_, _Zebra_, _Luis_…) o escriben «Eco» y «Zeta».],
)
