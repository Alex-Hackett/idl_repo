;+
; $Id: acs_cmfscan_mp.pro,v 1.1 2001/11/05 20:49:31 mccannwj Exp $
;
; NAME:
;     ACS_CMFSCAN_MP
;
; PURPOSE:
;     Reduce multi-field-point focus scan data obtained by moving the
;     corrector focus mechanism
;
; CATEGORY:
;     ACS/Analysis
;
; CALLING SEQUENCE:
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
;-
PRO ACS_CMFSCAN_MP, first_entry, num_files_per_position, $
                    TITLE=title, HARDCOPY=hardcopy, VERBOSE=verbose

   IF N_ELEMENTS(title) LE 0 THEN BEGIN
      ;;tit='ID 13376:13519  9 Jul 99  WFC  RAS/HOMS'
      ;;tit='ID 16149:16292  16 Jun 00  WFCb3  RAS/HOMS'
      ;;tit='ID 24210:24353   8 Dec 00  WFCb4  RAS/HOMS'
      title = 'ID 24455:24598   16 Dec 00  WFCb4  RAS/HOMS'
   ENDIF
   IF N_ELEMENTS(num_files_per_position) LE 0 THEN num_files_per_position=2

   field_point_ids = STRUPCASE(['a1','n6','n2','n5','n9','a3','a4','a7','a8'])
   ;;xctri = [90,94,89,89,88,89,92,95,89]
   ;;yctri = [40,95,44,89,38,42,90,95,39]
   nfld = N_ELEMENTS(field_point_ids) ; number of field points

   output_rootname = 'cmfscan_mp_'+STRTRIM(first_entry,2)
   focoff = FLTARR(nfld)
   focoffm = FLTARR(nfld)
   fopts = STRARR(nfld)
   mctr = FLTARR(2,nfld)
   cfm = FLTARR(3,nfld)
   
   num_focus_positions = 8
   FOR k=0,nfld-1 DO BEGIN
      output_name = output_rootname+'_'+field_point_ids[k]
      IF KEYWORD_SET(verbose) THEN $
       PRINT, 'Processing field point '+field_point_ids[k]
      n_skip = (nfld-1) * num_files_per_position
      first_focus_entry = first_entry + num_files_per_position*k
      ACS_CMFSCAN, first_focus_entry, num_focus_positions, $
       num_files_per_position, SKIP=n_skip, $
       OPTIMAL_FOCUS=optimal_focus, EE=ee, FOCUS=focus, $
       TITLE='Field point '+field_point_ids[k], $
       HARDCOPY=hardcopy, /WRITE, OUTPUT_FILENAME=output_name, $
       VERBOSE=verbose

   ENDFOR
END
