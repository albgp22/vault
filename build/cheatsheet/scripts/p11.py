PAIRS = [
(r'''FM: de pendiente, discriminador, detector de relación o PLL (siempre tras un limitador).''', r'''FM: de pendiente, discriminador, detector de relación o PLL (normalmente tras un limitador, que borra el ruido de amplitud).'''),
(r'''#fig(fig-tx-blu, cap: [Transmisor de BLU. El modulador equilibrado quita la portadora; el filtro, una banda; el mezclador la sube a la frecuencia de trabajo.])''', r'''#fig(fig-tx-blu, cap: [Transmisor de BLU. El modulador equilibrado quita la portadora; el filtro, una banda; el mezclador la sube a la frecuencia de trabajo. El ALC limita la excitación y evita el _splatter_.])'''),
(r''' Modulador de fase tras un cristal = FM *indirecta*. // FALSTAD-CUSTOM: modulacion-fm''', r''' Modulador de fase tras un cristal = FM *indirecta*.'''),
(r'''#sub[Modulación]
#fig(fig-espectros,''', r'''#sub[Modulación]
// FALSTAD-CUSTOM: modulacion-am
// FALSTAD-CUSTOM: modulacion-fm
#fig(fig-espectros,'''),
(r'''// FALSTAD-CUSTOM: resonancia-serie
#fig(fig-resonancia,''', r'''// FALSTAD-CUSTOM: resonancia-serie
// FALSTAD-CUSTOM: tanque-paralelo
#fig(fig-resonancia,'''),
(r'''#sub[Fuente de alimentación]
#fig(fig-fuente, cap: [Fuente lineal: forma de onda a la salida de cada bloque.], sim: ("fullrectf.txt", "zenerref.txt"))
// FALSTAD-CUSTOM: fuente-completa''', r'''#sub[Fuente de alimentación]
// FALSTAD-CUSTOM: fuente-completa
#fig(fig-fuente, cap: [Fuente lineal: forma de onda a la salida de cada bloque.], sim: ("fullrectf.txt", "zenerref.txt"))'''),
]
