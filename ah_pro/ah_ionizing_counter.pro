;+
; :Author: Alex
; This Proc Produces the classic Kippenhahn
; Diagram of convective instability regions as a function
; of model age and mass coordinate, based on the hash sav files
;
; In the future, this is to be extended to additionally plot the
; regions where the temperature is sufficently high to allow the various
; buring processes to occur (WIP)
;
;-

;PRO ah_ionizing_counter, themodel, timeskip, savefiledir=savefiledir, TOSAVE = tosave
themodel = 'P015z000S0d010'
  IF N_ELEMENTS(timeskip) EQ 0 THEN BEGIN
    timeskip = 0.01
    timeskipstr = STRTRIM('No Timeskip Supplied, Defaulting to ' + STRING(timeskip) + ' yrs', 2)
  ENDIF
  themodel = STRING(themodel)
  modelname = themodel

  IF N_ELEMENTS(savefiledir) EQ 0 THEN BEGIN
    savefiledir = '/home/AHACKETT_Project/_PopIIIProject/geneva_model_data/IDL_genec_struc_saves/'
    defdirmes = STRTRIM('Using Default Sav File Dir: ' + savefiledir , 2)
  ENDIF

  IF FILE_TEST(savefiledir, /DIRECTORY) EQ 0 THEN BEGIN
    FILE_MKDIR, savefiledir
  ENDIF
  savefile = STRTRIM(savefiledir + 'Hashed_StrucData_' + STRING(modelname)+'.sav',2)

  ;If the .sav file already exists, just read it in
  IF FILE_TEST(STRING(savefile)) EQ 1 THEN BEGIN
    savemesg = STRTRIM('==============.sav File ' + savefile + ' Found, Restoring==============', 2)
    PRINT, '======================================================================================='
    PRINT, '======================================================================================='
    PRINT, '======================================================================================='
    PRINT, savemesg
    PRINT, '======================================================================================='
    PRINT, '======================================================================================='
    PRINT, '======================================================================================='
    RESTORE, savefile
  ENDIF

  IF FILE_TEST(STRING(savefile)) NE 1 THEN BEGIN
    filenot = STRTRIM(STRING(savefile) + 'Not Found, Generate a new one? [WARNING, TAKES A WHILE] (y/n)')
    READ, filenot, to_read
    IF STRING(to_read) EQ 'y' THEN BEGIN
      ah_read_genec_struc, themodel, 1000
    ENDIF ELSE BEGIN
      ;Bail out
      PRINT, 'Quitting'
      RETURN
      STOP
    ENDELSE
  ENDIF

  ;##############################################################
  ;################ BEGIN PLOTTING PART  ########################
  ;##############################################################
  
  ;Make a bb spectrum
  
  ;Get the effective temperature
  bbteff = 10.^(wg_xte[WHERE(wg_u1 EQ VALUE_LOCATE(wg_u1, 2d6))])
  bbwave = FINDGEN(7d5, START = 0, INCREMENT = 1d-2) * 10d-10
  flux = ah_BLACKBODY(bbteff, bbwave, /WAVE)
  
  

  
  IF KEYWORD_SET(tosave) THEN BEGIN
    imagedir = '/home/AHACKETT_Project/_PopIIIProject/IDL_Plots/full_frame_plots/'
    plotname = STRTRIM(imagedir + STRING(modelname) + 'frame_plot.pdf')
    IF FILE_TEST(imagedir, /DIRECTORY) EQ 0 THEN BEGIN
      FILE_MKDIR, imagedir
      imagedirmes = STRTRIM('New Plot Dir ' + imagedir + 'Created', 2)
      PRINT, imagedirmes
    ENDIF
    sucess_mesg = STRTRIM('GRAPHIC GENNED!' + ' Saving as: ' + plotname,2)
    PRINT, sucess_mesg
    windows.Save, plotname, /BITMAP
    PRINT, 'GRAPHIC SAVED!!'
    WINDOWDELETEALL
  ENDIF ELSE PRINT, 'GRAPHIC GENNED!!'
  RETURN
END
