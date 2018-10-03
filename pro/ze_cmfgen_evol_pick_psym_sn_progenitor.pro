FUNCTION ZE_CMFGEN_EVOL_PICK_PSYM_SN_PROGENITOR,sn_prog_type,stroke=stroke
;returns different symbols for different sn progenitor types
;keyword stroke returns the sopen ymbol with only the stroke (i.e. outline), useful if plotting a symbol color with a black stroke around, for instance. 
  psym=0
  IF KEYWORD_SET(STROKE) EQ 0 THEN BEGIN
  case sn_prog_type of
   'II-Prot': psym=cgSYMCAT(17)
  'II-L/brot': psym=cgSYMCAT(14)
  'Ibrot': psym=cgSYMCAT(15)
  'Icrot': psym=cgSYMCAT(16) 
  
  'II-Pnorot': psym=cgSYMCAT(5)
  'II-L/bnorot': psym=cgSYMCAT(4)
  'Ibnorot': psym=cgSYMCAT(6)
  'Icnorot': psym=cgSYMCAT(9)   
  endcase
 
 ENDIF ELSE BEGIN
   case sn_prog_type of
   'II-Prot': psym=cgSYMCAT(5)
  'II-L/brot': psym=cgSYMCAT(4)
  'Ibrot': psym=cgSYMCAT(6)
  'Icrot': psym=cgSYMCAT(9)   
  endcase
 ENDELSE
  
 return,psym
END