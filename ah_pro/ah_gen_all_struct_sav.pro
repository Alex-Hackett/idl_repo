;+
; :Author: Alex
; This proc reads all the struct files in all the GENEC model dirs
; into hashes, then .savs the hashes into model named .sav files
; 
; WARNING, THIS WILL TAKE A VERY LONG TIME TO RUN!!
;-
PRO ah_gen_all_struct_sav, modelsdir

defaultdir = '/home/AHACKETT_Project/_PopIIIProject/groh_hard_drive/AHACKETT/GENEC_MODELS/'
IF N_ELEMENTS(modelsdir) EQ 0 THEN BEGIN
  PRINT, STRTRIM('No GENEC Models Dir Specified, Defaulting to ' + defaultdir, 2)
  modelsdir = defaultdir
ENDIF
all_models = FIND_ALL_DIR(STRING(modelsdir))
IF N_ELEMENTS(all_models) LE 1 THEN BEGIN
  warnmes = STRTRIM('No Valid Model Dirs Found in ' + modelsdir, 2)
  PRINT, warnmes
  RETURN
ENDIF
FOREACH model, all_models DO BEGIN
  TIC
  
  ;Set the /MDDIR keyword since we're
  ;passing the full dir to ah_read_genec_struc
  ;When it would usually expect just a model name (e.g. P015z000S0d010)
  ah_read_genec_struc, model, /MDDIR
  
  TOC
ENDFOREACH
END