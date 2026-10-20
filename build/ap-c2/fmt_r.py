# ap-c2: typographic details of the R groups (mono = Q codes/prefixes, italic = foreign words, bold) read from the PDF fonts.
def M(s): return '#_apc2-m[%s]' % s
def I(s): return '_%s_' % s
def B(s): return '*%s*' % s

FMT = {}
QF = {}   # question stems/options: (id, 's' | 0..3) -> pairs
QOVR = {} # question stems/options replaced whole: (id, 's' | 0..3) -> text (valid Typst)

# ---- R3
FMT['F-R3.1:0'] = [('short wave listener', I('short wave listener')), ('SWR (ROE', I('SWR') + ' (ROE')]
FMT['F-R3.1:1'] = [('short wave listener', I('short wave listener')), ('SWR,', I('SWR') + ',')]
FMT['F-R3.2:0'] = [('good luck', I('good luck')), ('good morning', I('good morning')), ('good night', I('good night')),
                   ('good evening', I('good evening')), ('M de morning', 'M de ' + I('morning')), ('N de night', 'N de ' + I('night')),
                   ('E de evening', 'E de ' + I('evening')), ('L de luck', 'L de ' + I('luck'))]
FMT['F-R3.2:1'] = [('G de good', 'G de ' + I('good')), ('(morning,', '(' + I('morning') + ','), ('(evening,', '(' + I('evening') + ','),
                   ('(night,', '(' + I('night') + ','), ('(luck,', '(' + I('luck') + ',')]
_rst = [('R (readability,', B('R') + ' (' + I('readability') + ','), ('S (strength,', B('S') + ' (' + I('strength') + ','),
        ('T (tone,', B('T') + ' (' + I('tone') + ',')]
FMT['F-R3.3:0'] = list(_rst)
FMT['F-R3.3:1'] = list(_rst)
FMT['F-R3.4:1'] = [('R, legibilidad', B('R') + ', legibilidad'), ('S, intensidad', B('S') + ', intensidad'), ('T, tono', B('T') + ', tono')]

# ---- R4
FMT['F-R4.1:0'] = [('deberá hacer lo posible', B('deberá hacer lo posible'))]
FMT['F-R4.3:0'] = [('Global Emergency Centre of Activity', I('Global Emergency Centre of Activity'))]
FMT['F-R4.4:0'] = [('(QRP)', '(' + M('QRP') + ')'), ('R1 Emergency Centre of Activity', I('R1 Emergency Centre of Activity'))]

# ---- R5
FMT['F-R5.1:0'] = [('QSL', M('QSL'))]
FMT['F-R5.5:0'] = [('stroke', I('stroke')), ('EA/M0BVM', M('EA/M0BVM'))]
FMT['F-R5.5:1'] = [('España, EA y,', 'España, ' + M('EA') + ' y,'), ('(EA/M0BVM)', '(' + M('EA/M0BVM') + ')'), ('stroke', I('stroke'))]
FMT['F-R5.6:0'] = [('como UR, RC y RK', 'como ' + M('UR') + ', ' + M('RC') + ' y ' + M('RK'))]
FMT['F-R5.6:1'] = [('por UR (asociaciones) y por RC o RK (radio clubes)', 'por ' + M('UR') + ' (asociaciones) y por ' + M('RC') + ' o ' + M('RK') + ' (radio clubes)')]
FMT['F-R5.8:0'] = [('El prefijo CT es', 'El prefijo ' + M('CT') + ' es'), ('usan CU)', 'usan ' + M('CU') + ')'),
                   ('Chile usa CE, Canadá VE y Croacia 9A', 'Chile usa ' + M('CE') + ', Canadá ' + M('VE') + ' y Croacia ' + M('9A')),
                   ('como EA en España', 'como ' + M('EA') + ' en España')]
FMT['F-R5.8:1'] = [('Portugal CT (Azores, CU), Francia F y Andorra C3', 'Portugal ' + M('CT') + ' (Azores, ' + M('CU') + '), Francia ' + M('F') + ' y Andorra ' + M('C3')),
                   ('España emplea EA, EB y EC', 'España emplea ' + M('EA') + ', ' + M('EB') + ' y ' + M('EC'))]
FMT['F-R5.9:0'] = [('El prefijo F es', 'El prefijo ' + M('F') + ' es'), ('como TK o FG', 'como ' + M('TK') + ' o ' + M('FG')),
                   ('Finlandia usa OH, Alemania DL y Bélgica ON', 'Finlandia usa ' + M('OH') + ', Alemania ' + M('DL') + ' y Bélgica ' + M('ON')),
                   ('Francia F, Portugal CT y Andorra C3', 'Francia ' + M('F') + ', Portugal ' + M('CT') + ' y Andorra ' + M('C3'))]
FMT['F-R5.9:1'] = [('Francia usa F,', 'Francia usa ' + M('F') + ','), ('(TK)', '(' + M('TK') + ')'),
                   ('por ejemplo, FG en', 'por ejemplo, ' + M('FG') + ' en'), ('Portugal, CT; Andorra, C3.', 'Portugal, ' + M('CT') + '; Andorra, ' + M('C3') + '.')]
FMT['F-R5.10:0'] = [('C3 es la serie', M('C3') + ' es la serie'),
                    ('Camerún usa TJ, Canadá VE y Cuba CM o CO', 'Camerún usa ' + M('TJ') + ', Canadá ' + M('VE') + ' y Cuba ' + M('CM') + ' o ' + M('CO')),
                    ('(C3, 9A, 3A)', '(' + M('C3') + ', ' + M('9A') + ', ' + M('3A') + ')')]
FMT['F-R5.10:1'] = [('Francia F, Portugal CT y Andorra C3', 'Francia ' + M('F') + ', Portugal ' + M('CT') + ' y Andorra ' + M('C3')),
                    ('(C3 de Andorra, 9A de Croacia, 3A de Mónaco)', '(' + M('C3') + ' de Andorra, ' + M('9A') + ' de Croacia, ' + M('3A') + ' de Mónaco)')]
FMT['F-R5.11:0'] = [('DL es un prefijo', M('DL') + ' es un prefijo'), ('que usa OZ', 'que usa ' + M('OZ')),
                    ('usan PA y Letonia YL', 'usan ' + M('PA') + ' y Letonia ' + M('YL'))]
FMT['F-R5.11:1'] = [('Alemania DL, Italia I, Bélgica ON, Países Bajos PA, Dinamarca OZ, Finlandia OH, Irlanda EI y Reino Unido G o M.',
                     'Alemania ' + M('DL') + ', Italia ' + M('I') + ', Bélgica ' + M('ON') + ', Países Bajos ' + M('PA') + ', Dinamarca ' + M('OZ') +
                     ', Finlandia ' + M('OH') + ', Irlanda ' + M('EI') + ' y Reino Unido ' + M('G') + ' o ' + M('M') + '.')]
FMT['F-R5.12:0'] = [('La letra I es', 'La letra ' + M('I') + ' es'),
                    ('Irlanda EI, India VU (dentro de la serie VT a VW) e Islandia TF',
                     'Irlanda ' + M('EI') + ', India ' + M('VU') + ' (dentro de la serie VT a VW) e Islandia ' + M('TF'))]
FMT['F-R5.12:1'] = [('letra I sola', 'letra ' + M('I') + ' sola'),
                    ('Alemania DL, Bélgica ON, Países Bajos PA, Irlanda EI, Islandia TF y Reino Unido G o M',
                     'Alemania ' + M('DL') + ', Bélgica ' + M('ON') + ', Países Bajos ' + M('PA') + ', Irlanda ' + M('EI') + ', Islandia ' + M('TF') +
                     ' y Reino Unido ' + M('G') + ' o ' + M('M'))]
FMT['F-R5.13:0'] = [('Las series G y M son', 'Las series ' + M('G') + ' y ' + M('M') + ' son'), ('da M para', 'da ' + M('M') + ' para'),
                    ('como MM (Escocia) y MW (Gales)', 'como ' + M('MM') + ' (Escocia) y ' + M('MW') + ' (Gales)'),
                    ('Irlanda usa EI, Malta 9H y Mónaco 3A', 'Irlanda usa ' + M('EI') + ', Malta ' + M('9H') + ' y Mónaco ' + M('3A'))]
FMT['F-R5.13:1'] = [('las series G y M en', 'las series ' + M('G') + ' y ' + M('M') + ' en'), ('usa M, con', 'usa ' + M('M') + ', con'),
                    ('MM Escocia, MW Gales, MI Irlanda del Norte', M('MM') + ' Escocia, ' + M('MW') + ' Gales, ' + M('MI') + ' Irlanda del Norte'),
                    ('(EI), Malta (9H) ni Mónaco (3A)', '(' + M('EI') + '), Malta (' + M('9H') + ') ni Mónaco (' + M('3A') + ')')]
FMT['F-R5.14:0'] = [('asigna AO a', 'asigna ' + M('AO') + ' a'), ('(EA9, EA8)', '(' + M('EA9') + ', ' + M('EA8') + ')'),
                    ('corresponden a AM y AN', 'corresponden a ' + M('AM') + ' y ' + M('AN'))]
FMT['F-R5.14:1'] = [('El prefijo AO tiene', 'El prefijo ' + M('AO') + ' tiene'), ('se usan AM y AN', 'se usan ' + M('AM') + ' y ' + M('AN'))]
FMT['F-R5.16:0'] = [('prefijo ED y', 'prefijo ' + M('ED') + ' y')]

# ---- R6 / R7
FMT['F-R6.9:1'] = [('(CQ)', '(' + M('CQ') + ')')]
FMT['F-R7.2:0'] = [('(Amateur’s Code)', '(' + I('Amateur’s Code') + ')'),
                   ('Ethics and Operating Procedures for the Radio Amateur', I('Ethics and Operating Procedures for the Radio Amateur'))]
FMT['F-R7.2:1'] = [('(Amateur’s Code,', '(' + I('Amateur’s Code') + ',')]
FMT['F-R7.3:0'] = [('Ethics and Operating Procedures for the Radio Amateur', I('Ethics and Operating Procedures for the Radio Amateur'))]
FMT['F-R7.4:0'] = [('(en inglés, from)', '(en inglés, ' + I('from') + ')'),
                   ('«EA4ABC de EA5XYZ»', '«' + M('EA4ABC') + ' de ' + M('EA5XYZ') + '»'),
                   ('CQ es la', M('CQ') + ' es la'), ('Y QRZ pregunta', 'Y ' + M('QRZ') + ' pregunta')]
FMT['F-R7.4:1'] = [('«CQ de EA5XYZ»', '«' + M('CQ') + ' de ' + M('EA5XYZ') + '»'), ('con QRZ (que', 'con ' + M('QRZ') + ' (que'),
                   ('(73)', '(' + M('73') + ')')]
FMT['F-R7.5:0'] = [('SINPO es', M('SINPO') + ' es'), ('de Signal (', 'de ' + I('Signal') + ' ('), ('Interference (', I('Interference') + ' ('),
                   ('Noise (', I('Noise') + ' ('), ('Propagation (', I('Propagation') + ' ('), ('y Overall (', 'y ' + I('Overall') + ' ('),
                   ('el informe RST,', 'el informe ' + M('RST') + ',')]
FMT['F-R7.5:1'] = [('El informe RST no', 'El informe ' + M('RST') + ' no'), ('SINPO lo', M('SINPO') + ' lo'),
                   ('el informe RS en fonía y el RST en telegrafía', 'el informe ' + M('RS') + ' en fonía y el ' + M('RST') + ' en telegrafía')]

# ---- questions
QF[('F-T8.8', 's')] = [('true RMS', I('true RMS'))]
QF[('F-R4.3', 3)] = [('(QRP)', '(' + M('QRP') + ')')]
for _i in range(4): QF[('F-R5.1', _i)] = [('QSL', M('QSL'))]
QF[('F-R5.5', 0)] = [('stroke', I('stroke'))]
QF[('F-R5.8', 's')] = [('prefijo CT', 'prefijo ' + M('CT'))]
QF[('F-R5.9', 's')] = [('letra F', 'letra ' + M('F'))]
QF[('F-R5.10', 's')] = [('prefijo C3', 'prefijo ' + M('C3'))]
QF[('F-R5.11', 's')] = [('prefijo DL', 'prefijo ' + M('DL'))]
QF[('F-R5.12', 's')] = [('letra I', 'letra ' + M('I'))]
QF[('F-R5.13', 's')] = [('es M o G (por ejemplo, M0BVM)', 'es ' + M('M') + ' o ' + M('G') + ' (por ejemplo, ' + M('M0BVM') + ')')]
QF[('F-R5.14', 's')] = [('prefijo AO', 'prefijo ' + M('AO'))]
QF[('F-R6.6', 2)] = [('International Beacon Project', I('International Beacon Project'))]
QF[('F-R6.10', 's')] = [('(shift)', '(' + I('shift') + ')')]
QF[('F-R7.2', 's')] = [('(Amateur’s Code)', '(' + I('Amateur’s Code') + ')')]
QF[('F-R7.3', 's')] = [('(self-policing)', '(' + I('self-policing') + ')')]
QF[('F-R7.4', 2)] = [('«CQ»', '«' + M('CQ') + '»')]
QF[('F-R7.4', 3)] = [('«QRZ»', '«' + M('QRZ') + '»')]
QF[('F-R7.5', 's')] = [('SINPO', M('SINPO'))]

QOVR[('F-T9.4', 1)] = 'se reduce a la cuarta parte'
QOVR[('F-T9.4', 2)] = 'se reduce a $1 slash sqrt(2)$ de su valor'
QOVR[('F-T9.5', 2)] = 'duplica'
QOVR[('F-T9.5', 3)] = 'multiplica por $sqrt(2)$'
