;+
; $Id: rashoms_ps.pro,v 1.1 2001/11/05 21:48:04 mccannwj Exp $
;
; NAME:
;     RASHOMS_PS
;
; PURPOSE:
;     ACS_PS Driver routine for RASHOMS spots and darks
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     RASHOMS_PS, id [, /PRINT]
; 
; INPUTS:
;     id - ACS_LOG database entry number
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
;     /PRINT - use lp to send output to printer
;
; OUTPUTS:
;     Writes postscript output to disk.
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;     none explicitly
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;     Read data and determine median and maximum.
;
; EXAMPLE:
;     FOR i=1255,1299 DO RASHOMS_PS, i
;
;
; MODIFICATION HISTORY:
;
;    written by Don Lindler (ACC)
;
;    Mon Feb 15 15:15:52 1999, William Jon McCann
;    <mccannwj@acs13.+hst.nasa.gov>
;    added: info header
;    Mar 4, 1999, Lindler, added histeq option
;    Mar 11, 1999, Lindler, added udl header in call to acs_ps
;    Apr 23, 2002, Lindler, Changed linear scaling alogrithm
;-

PRO rashoms_ps, id, PRINT=print, HISTEQ=histeq

; ACS_PS Driver routine for RASHOMS spots and darks
; read data and determine median and maximum
   
   acs_read, id, h, d, hudl, /ROT
   med = MEDIAN(d)
   image_sz = SIZE(d)
                    ; Added two dimensional check - McCann 1998/12/08
   IF image_sz[0] EQ 2 THEN BEGIN
      num_x = image_sz[1]
      num_y = image_sz[2]
      
      imax = MAX(d[1:num_x-2,1:num_y-2]) ;(take maximum,ignoring edges)
      imin = MIN(d[1:num_x-2,1:num_y-2]) ;(take minimum,ignoring edges)
      PRINT, FORMAT='("Min:",I,"  Med:",I,"  Max:",I)', imin, med, imax

; If dark use linear scale from median-800 to median+5000
; otherwise use log scale from median to maximum

      IF KEYWORD_SET(histeq) THEN BEGIN
         acs_ps, id, DATA=d, HEADER=h, HUDL=hudl, /HISTEQ
      ENDIF ELSE BEGIN
         flash_status = STRUPCASE(STRTRIM(SXPAR(h,'FLSHSTAT'),2))
         obstype = STRUPCASE(STRTRIM(SXPAR(h,'obstype'),2))
         IF (obstype EQ 'DARK') AND (flash_status EQ 'NONE') THEN BEGIN
            acs_ps, id, DATA=d, HEADER=h, hudl=hudl, IMAX=med+5000, $
             IMIN=(med-800)>0
         ENDIF ELSE BEGIN
            SKY, d, skymode, skysig, /SILENT
            reasonable_bias = 4000
            IF skymode GT reasonable_bias THEN BEGIN
	       hist = histogram(d,min=0,max=65535)
	       for i=1L,65535 do hist(i) = hist(i)+hist(i-1)
	       n = n_elements(d)
	       tabinv,hist,n*[0.03,0.97],range
	       print,'Rashoms_ps linear range ',range
               acs_ps, id, DATA=d, HEADER=h, hudl=hudl, IMAX=range(1), $
                IMIN=range(0), /LINEAR, /REVERSE
            ENDIF ELSE BEGIN
               acs_ps, id, DATA=d, HEADER=h, hudl=hudl, IMAX=imax, $
                IMIN=med, /LOG
            ENDELSE
         ENDELSE 
      ENDELSE
      IF KEYWORD_SET(print) THEN BEGIN
         dbopen, 'acs_log'
         ps_filename = STRTRIM( DBVAL( id, 'filename' ), 2 ) + '.ps'
         psfiles = FINDFILE( ps_filename, COUNT=pscount )
         dbclose
         IF pscount GT 0 THEN BEGIN
            PRINT, 'Sent file to printer.'
            strCommand = 'lp '+ps_filename
            SPAWN, strCommand
         ENDIF
      ENDIF
   ENDIF ELSE PRINT, 'Skipping '+STRTRIM(id,2)+': not a two dimensional image'
   return
END
