// =====================================================================
//  Examen de Radioaficionado — banco de preguntas razonado (edición ampliada)
//  Compilar:  typst compile --root . main.typ build/examen-radioaficionado.pdf
// =====================================================================
#import "/lib/template.typ": *
#show: libro

#include "/chapters/front.typ"

// ------------------------------------------------ cuerpo: introducción
#_salto-capitulo()
#counter(page).update(1)
#estilo-paginas.update("1")

#capitulo("intro-1", "Cómo funciona una radio: de los campos a la voz")
#include "/chapters/intro-1.typ"

#capitulo("intro-2", "La radio por dentro: componente a componente")
#include "/chapters/intro-2a.typ"
#include "/chapters/intro-2b.typ"
#include "/chapters/intro-2c.typ"
#soluciones-ejercicios()

// ------------------------------------------------ parte I
#parte("I", "Prueba primera. Electricidad y radioelectricidad")
#include "/chapters/t01.typ"
#include "/chapters/t02.typ"
#include "/chapters/t03.typ"
#include "/chapters/t04.typ"
#include "/chapters/t05.typ"
#include "/chapters/t06.typ"
#include "/chapters/t07.typ"
#include "/chapters/t08.typ"
#include "/chapters/t09.typ"
#include "/chapters/t10.typ"

// ------------------------------------------------ parte II
#parte("II", "Prueba segunda. Normativa reglamentaria")
#include "/chapters/r01.typ"
#include "/chapters/r02.typ"
#include "/chapters/r03.typ"
#include "/chapters/r04.typ"
#include "/chapters/r05.typ"
#include "/chapters/r06.typ"
#include "/chapters/r07.typ"
#include "/chapters/r08.typ"
#include "/chapters/r09.typ"

// ------------------------------------------------ apéndices
#include "/chapters/ap-a.typ"
#include "/chapters/ap-b1.typ"
#include "/chapters/ap-b2.typ"
#include "/chapters/ap-c1.typ"
#include "/chapters/ap-c2.typ"
#include "/chapters/ap-c3.typ"
#include "/chapters/ap-d.typ"
