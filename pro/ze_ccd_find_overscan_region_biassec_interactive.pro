PRO ZE_CCD_FIND_OVERSCAN_REGION_BIASSEC_INTERACTIVE,image,nx,ny,biassecu,biassecl,trimsecu,trimsecl,RETURN_TRIMSEC=RETURN_TRIMSEC
;procedure to interactively find overscan region using flat field data, and output biassecu and biassec l
;optionally, can also be used to find trim sec and output it
;written by Jose Groh

!P.Background = fsc_color('white')
line_norm,INDGEN(ny),image[nx/2,*]

read,biassecu,prompt='Initial index value (i.e pixel -1 ) for bias section (biassecu):  '
read,biassecl,prompt='Final index value (i.e pixel -1 ) for bias section (biassecu):  '

IF KEYWORD_SET(trimsec) THEN BEGIN

 read,trimsecu,prompt='Initial index value (i.e pixel -1 ) for bias section (biassecu):  '
 read,trimsecl,prompt='Final index value (i.e pixel -1 ) for bias section (biassecu):  '
ENDIF



END
