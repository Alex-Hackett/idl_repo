;+
; $Id: acs_read_hmod.pro,v 1.1 2002/03/12 18:04:28 mccannwj Exp $
;
; NAME:
;     ACS_READ_HMOD
;
; PURPOSE:
;     Routine add some keywords to the primary header if post-launch
;     data.
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     ACS_READ_HMOD, h, hudl, heng1, heng2
;
; INPUTS:
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
;       Fri Feb 8 12:52:00 2002, Don Lindler
;
;-
PRO acs_read_hmod,h,hudl,heng1,heng2

   IF (N_ELEMENTS(hudl) LE 1) THEN return
;
; Mechanisms
;
   foldpos = ['HRC','SBC']
   sxaddpar,h,'FOLDPOS',foldpos(sxpar(hudl,'jqfoldps')), $
    'Fold Mechanism Position'
   caldor = ['RETRACT','DEPLOY','CORONAGRAPH','INVALID']
   sxaddpar,h,'CALDOOR',caldor(sxpar(hudl,'jqcaldor')), $
    'Cal Door Position Select'
;
; Resolver Positions
;
   keyin = ['JWRESPOS','JHRESPOS','JWFCSPOS','JWINNPOS','JWOUTPOS', $
            'JHFCSPOS','JHINNPOS','JHOUTPOS']
   keyout = ['WSHUTPOS','HSHUTPOS','WFOCPOS','WINNPOS','WOUTPOS', $
             'HFOCPOS','HINNPOS','HOUTPOS']
   FOR i=0,N_ELEMENTS(keyin)-1 DO BEGIN
      val = sxpar(heng1,keyin(i),comment=comment)
      sxaddpar,h,keyout(i),val,comment
   ENDFOR
;
; CCD Overscan
;
   keyin = ['JQPHOSAC','JQPHOSBD','JQVOSAMP']
   keyout = ['OVER_AC','OVER_BD','OVER_V']
   FOR i=0,N_ELEMENTS(keyin)-1 DO BEGIN
      val = sxpar(hudl,keyin(i),comment=comment)
      sxaddpar,h,keyout(i),val,comment
   ENDFOR
;
; Subarrays
;
   jqccdind = sxpar(h,'jqccdind')
   IF jqccdind EQ 2 THEN BEGIN
      keyin = ['JQCCDXSZ','JQCCDYSZ','JQCCDXCN','JQCCDYCN']
      keyout = ['CCDXSIZ','CCDYSIZ','CCDXCOR','CCDYCOR']
      FOR i=0,3 DO BEGIN
         val = sxpar(hudl,keyin(i),comment=comment)
         sxaddpar,h,keyout(i),val,comment
      ENDFOR
   ENDIF
;
; FLASH Information
;
   sxaddpar,h,'FLASHDUR',sxpar(hudl,'JQCFDURA'), $
    'Flash Duration actual (sec)'
   sxaddpar,h,'FLASHCUR',sxpar(hudl,'JQCFLCUR'), $
    'Flash Current (OFF,LOW,MED,HIGH)'
   CASE 1 OF 
      sxpar(h,'JQCFDURC') eq 0: value = 'NONE'
      sxpar(h,'JQCFABRT') eq 1: value = 'ABORTED'
      sxpar(h,'JQCFLSUC') eq 0: value = 'OKAY'
      ELSE: value = 'UNKNOWN'
   ENDCASE
   sxaddpar,hout,'FLSHSTAT',value,'Flash Status (NONE,ABORTED,OKAY)'
;
; MAMA junk
;
   sxaddpar,h,'MCPVOLT',sxpar(heng1,'JMMCPV'),'SBC MAMA MCP VOLTAGE'
   sxaddpar,h,'FIELDVLT',sxpar(heng1,'JMFIELDV'),'SBC MAMA FIELD VOLTAGE'
   sxaddpar,h,'MFIFOVR',sxpar(hudl,'jqmffov'), $
    'Number of SBC MAMA Overflow Events'
END
