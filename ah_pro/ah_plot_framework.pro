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

PRO ah_plot_framework, themodel, timeskip, savefiledir=savefiledir, TOSAVE = tosave
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

  oldtime = 0
  p = list()
  ;KTITLE = STRTRIM('Kippenhahn Diagram for '+string(modelname), 2)
  ;KTITLE = STRTRIM('Plot of Energy Generation as a Function of Mass for ' + STRING(modelname), 2)
  KTITLE = STRTRIM('Plot of Radiation Pressure over Total Pressure as Function of Mass Coordinate for ' + STRING(modelname), 2)
  collapseAge = (MintData.Keys())[-1]

  FOREACH masslist, MintData, time DO BEGIN

    ;Check if the timesteps is as big as desired
    IF (ALOG10(collapseAge - time) LE 1d10) AND (ABS(ALOG10(collapseAge - time) - ALOG10(collapseAge - oldtime)) GT timeskip) THEN BEGIN
    
      ;Are we done here?
      IF ALOG10(collapseAge - time) LE 0 THEN GOTO, donePlot
      ;Work out the actual convective zones
      ;czs = masslist[WHERE((nablaradData[time] - nabla_adData[time]) GT 0)] / 2d33
      prad = prad_over_ptotData[time]
      ;energy_gen = epsilonData[time]
      ;cvs = cvData[time]
      ;p.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(czs), VALUE = ALOG10(collapseAge - time)), [czs], /OVERPLOT, /SYM_FILLED, $
      ;  XTITLE = 'Log Time to Collapse', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = KTITLE, XRANGE = [ALOG10(collapseAge - (MintData.Keys())[0]),0],$
      ;  NAME = 'Unstable Against Convection', LAYOUT = [1,2,1], SYMBOL = 'o', SYM_SIZE = 0.4)
      p.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(masslist), VALUE = ALOG10(collapseAge - time)), [masslist] / 2d33, /OVERPLOT, /SYM_FILLED, $
        XTITLE = 'Log Time to Collapse', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = KTITLE, SYM_COLOR='red',$
        MAGNITUDE = prad, RGB_TABLE = 11, XRANGE = [ALOG10(collapseAge - (MintData.Keys())[0]),0], LAYOUT = [1,2,1], SYMBOL = 'o', SYM_SIZE = 0.4)
      ;p.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(masslist[WHERE(energy_gen GT 1d5)]), VALUE = ALOG10(collapseAge - time)), [masslist[WHERE(energy_gen GT 1d5)]] / 2d33, /OVERPLOT, /SYM_FILLED, $
      ;  XTITLE = 'Log Time to Collapse', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = KTITLE, SYM_COLOR='red',$
      ;   MAGNITUDE = energy_gen, RGB_TABLE = 3, XRANGE = [ALOG10(collapseAge - (MintData.Keys())[0]),0], LAYOUT = [1,2,1], SYMBOL = 'o', SYM_SIZE = 0.4)
      oldtime = time
    ENDIF

  ENDFOREACH
  donePlot:
  ;c = COLORBAR(TARGET = p[-1], TITLE = 'Log Intensity of Nuclear Energy Generation (erg/g/s)')
  c = COLORBAR(TARGET = p[-1], TITLE = 'Eddington Parameter')
    p2 = PLOT(ALOG10(collapseAge - wg_u1), wg_eddesm, COLOR = 'black', /CURRENT, LAYOUT = [1,2,2], TITLE = 'Eddington Parameter as a Function of Age', $
    XTITLE = 'Log Time to Collapse', YTITLE = 'Eddington Parameter', XRANGE = [ALOG10(collapseAge - (MintData.Keys())[0]),0])


  IF KEYWORD_SET(tosave) THEN BEGIN
    imagedir = '/home/AHACKETT_Project/_PopIIIProject/IDL_Plots/gaspresplot/'
    plotname = STRTRIM(imagedir + STRING(modelname) + 'gasplot.pdf')
    IF FILE_TEST(imagedir, /DIRECTORY) EQ 0 THEN BEGIN
      FILE_MKDIR, imagedir
      imagedirmes = STRTRIM('New Plot Dir ' + imagedir + 'Created', 2)
      PRINT, imagedirmes
    ENDIF
    sucess_mesg = STRTRIM('GRAPHIC GENNED!' + ' Saving as: ' + plotname,2)
    PRINT, sucess_mesg
    p[-1].Save, plotname, /BITMAP
    PRINT, 'GRAPHIC SAVED!!'
    WINDOWDELETEALL
  ENDIF ELSE PRINT, 'GRAPHIC GENNED!!'
  RETURN
END
