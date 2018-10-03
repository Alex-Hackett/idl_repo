;+
; $Id: rashoms_log.pro,v 1.1 2001/11/05 20:46:17 mccannwj Exp $
;
; NAME:
;     RASHOMS log print routine
;
; PURPOSE:
;     Create a catalog of images in a specified range.
;
; CATEGORY:
;     ACS/JHU
;
; CALLING SEQUENCE:
;     RASHOMS_LOG, firstid, lastid
;
; INPUTS:
;     firstid - first entry number to print
;     lastid  - last entry number to print
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;-
PRO rashoms_log,first,last
   items = 'entry,filename,date-obs,obstype,detector,ccdamp,' + $
    'filter1,filter2,ccdxcor,ccdycor,naxis1,naxis2,' + $
    'WFOCPOS,WINNPOS,WOUTPOS,HFOCPOS,HINNPOS,HOUTPOS'
   list = lindgen(last-first+1)+first
   dbopen,'acs_log'
   dbprint,list,items,textout=3
   return
END
