!EXCEPT=0
; =================================================================================================
;                         mairan_dia_imren.pro
;
; PROPOSITO: Dado um conjunto de imagens, renomea-las de acordo com a data em que foram observadas.
;
; INPUT: A lista com o nome das imagens selecionadas pelo programa mairan_dia_image_selector.pro.
;
; OUTPUT: As imagens listadas no arquivo de entrada renomeadas pela data Juliana reduzida (JDR).
;        Este programa ainda acrescenta no cabecalho o nome da imagen original e o valor de JDR.
; =================================================================================================

dirin = '/mnt/hdd/work3/mairan/CLUSTERS/WD1/PHOTOMETRY/ESO/SOFI/NB/'
dirout = dirin
filesin = dirin+'files.in'

; **************************************
; LEITURA DO NOME DOS ARQUIVOS
; **************************************

nlines = FILE_LINES(filesin)
file = STRARR(nlines)
OPENU, lun, filesin, /GET_LUN
READF, lun, file
CLOSE, lun & FREE_LUN, lun

teste = MRDFITS(dirin+file[0], 0, /FSCALE, /SILENT)
st = SIZE(teste)

; RENOMEAR AS IMAGENS DE ACORDO COM A DATA DE OBSERVACAO:
PRINT, '************************************************************************'

FOR j=0, nlines-1 DO BEGIN

;     PRINT, STRCOMPRESS(STRING(file[j]),/REMOVE_ALL)
    image_in = MRDFITS(dirin+file[j], 0, header, /FSCALE, /SILENT)

    par1 = FXPAR(header, 'OBJECT')
    par2 = FXPAR(header, 'EXPTIME')
    par3 = FXPAR(header, 'FILTER1')
    par4 = FXPAR(header, 'FILTER2')
    par5 = FXPAR(header, 'ARCFILE')

    MWRFITS, image_in, dirout+STRCOMPRESS(STRING(par1),/REMOVE)+'_'+$
         STRCOMPRESS(STRING(par2,FORMAT='(F6.1)'),/REMOVE)+'_'+$
         STRCOMPRESS(STRING(par3),/REMOVE)+'_'+$
         STRCOMPRESS(STRING(par4),/REMOVE)+'_'+$
         STRCOMPRESS(STRING(par5),/REMOVE), header

    PRINT, STRCOMPRESS(STRING(file[j]),/REMOVE)+' -> '+STRCOMPRESS(STRING(par1),/REMOVE)+'_'+$
         STRCOMPRESS(STRING(par2,FORMAT='(F6.1)'),/REMOVE)+'_'+$
         STRCOMPRESS(STRING(par3),/REMOVE)+'_'+$
         STRCOMPRESS(STRING(par4),/REMOVE)+'_'+$
         STRCOMPRESS(STRING(par5),/REMOVE)

;     IF j EQ 4 THEN GOTO, skip

ENDFOR

;skip:

PRINT, '*************************** FINISHED ***************************'

END
