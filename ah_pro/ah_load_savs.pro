;+
; :Author: AHACKETT
; This proc reads in .sav files corresponding to vfile, strucfile and .wg file hashed .sav files
; It's much easier to do this in one proc rather than doing the file IO stuff in every
; proc seperately
; 
; INPUTS: model: model name, i.e. P015z000S0d010, 
; STRUC, set this flag to read in the struc files .sav
; VFILE, set this flag to read in the .vfile sav
; SAVEFILEDIR, set this to a directory that contains both the .sav file dirs
; Leave empty to use the default directory on this PC
; 
; CALLING ORDER: ah_load_savs, model, STRUC, VFILE, SAVEFILEDIR
; 
; OUTPUTS:
; Passes out the filename/names that must be loaded in to
; get the vars, easiest to do this this way to avoid having to
; pass a huge list of vars through the proc call, or to have
; to set up a common block *shudders*
;-
FUNCTION ah_load_savs, model, STRUC=struc, VFILE=vfile, XDRIVE=xdrive
  
  ;Find the 'overdir', the dir that holds the savefile dirs
  IF KEYWORD_SET(xdrive) EQ 0 THEN BEGIN
    savefileoverdir = '/home/AHACKETT_Project/_PopIIIProject/geneva_model_data/'
  ENDIF ELSE savefileoverdir = '/home/AHACKETT_Project/_PopIIIProject/groh_hard_drive/AHACKETT/'
  
  ;Find the individual savefile dirs
  IF KEYWORD_SET(struc) THEN BEGIN
    strucfiledir = STRTRIM(savefileoverdir + 'IDL_genec_struc_saves' + '/', 2)
    strucfilesav = STRTRIM(strucfiledir + 'Hashed_StrucData_' + STRING(model)+'.sav', 2)
    savtobeloaded = strucfilesav
    PRINT, 'StrucFile Hash Sav Loaded into Output'
  ENDIF
  
  IF KEYWORD_SET(vfile) THEN BEGIN
    vfiledir = STRTRIM(savefileoverdir + 'IDL_genec_vfile_saves' + '/', 2)
    vfilesav = STRTRIM(vfiledir + 'Hashed_vFileData_' + STRING(model) + '.sav', 2)
    savtobeloaded = vfilesav
    PRINT, 'VFile Hash Sav Loaded into Output'
  ENDIF
  
  IF KEYWORD_SET(struc) AND KEYWORD_SET(vfile) THEN BEGIN
    savtobeloaded = []
    savtobeloaded = [strucfilesav, vfilesav]
    PRINT, 'Both struc and vfile names loaded into output array'
  ENDIF
  RETURN, savtobeloaded
  END
  
  
  
  
  
  


