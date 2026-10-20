PAIRS = [
(r'''    let badges = if sim == none { none } else if type(sim) == array {
      sim.map(s => falstad(s, texto: [#s.replace(".txt", "")])).join(h(2pt))
    } else { falstad(sim, texto: [Simúlalo]) }''', r'''    // sim: "archivo.txt", o lista de pares ("archivo.txt", [texto del botón])
    let badges = if sim == none { none } else if type(sim) == array {
      sim.map(((s, t)) => falstad(s, texto: t)).join(h(2pt))
    } else { falstad(sim, texto: [Simúlalo]) }'''),
(r'''sim: ("fullrectf.txt", "zenerref.txt"))''', r'''sim: (("fullrectf.txt", [puente + filtro]), ("zenerref.txt", [zéner])))'''),
(r'''sim: ("pushpullxover.txt", "pushpull.txt"))''', r'''sim: (("pushpullxover.txt", [clase B]), ("pushpull.txt", [clase AB])))'''),
(r'''#fig(fig-redes, cap: [El nombre sale de la forma del dibujo: la L, la letra griega π y la T.], sim: "tlmatch1.txt")''', r'''#fig(fig-redes, cap: [El nombre sale de la forma del dibujo: la L, la letra griega π y la T.], sim: (("tlmatch1.txt", [red L de adaptación]),))'''),
]
