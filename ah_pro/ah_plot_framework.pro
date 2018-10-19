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

  IF KEYWORD_SET(tosave) THEN BEGIN
    buffervar = 1
    PRINT, 'Sending to Offscreen Buffer'
  ENDIF ELSE BEGIN
    buffervar = 0
    PRINT, 'Sending to Screen'
  ENDELSE
  
  IF N_ELEMENTS(timeskip) EQ 0 THEN BEGIN
    timeskip = 0.1
    timeskipstr = STRTRIM('No Timeskip Supplied, Defaulting to ' + STRING(timeskip) + ' yrs', 2)
  ENDIF
  themodel = STRING(themodel)
  modelname = themodel

  IF N_ELEMENTS(savefiledir) EQ 0 THEN BEGIN
    savefiledir = '/home/AHACKETT_Project/_PopIIIProject/groh_hard_drive/AHACKETT/IDL_genec_struc_saves/'
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
  p0 = LIST()
  p1 = LIST()
  p2 = LIST()
  p3 = LIST()
  p4 = LIST()
  collapseAge = (MintData.Keys())[-1]
  czsTitle = STRTRIM('Classic Kippenhahn Diagram for ' + STRING(modelname), 2)
  eddMassTitle = STRTRIM('Eddington Factor with Mass for ' + STRING(modelname), 2)
  pradTitle = STRTRIM('Radiation Pressure / Total Pressure for ' + STRING(modelname), 2)
  enGenTitle = STRTRIM('Nuclear Energy Generation Rates for ' + STRING(modelname), 2)
  
  pradLims = [!VALUES.D_INFINITY, 0]
  energy_genLims = [!VALUES.D_INFINITY, 0]
  eddFacLims = [!VALUES.D_INFINITY, 0]
  windows = WINDOW(WINDOW_TITLE="Structure Plots", $
    DIMENSIONS=GET_SCREEN_SIZE(), BUFFER = buffervar)
  FOREACH masslist, MintData, time DO BEGIN

    ;Check if the timesteps is as big as desired
    IF (ALOG10(collapseAge - time) LE 1d10) AND (ABS(ALOG10(collapseAge - time) - ALOG10(collapseAge - oldtime)) GT timeskip) THEN BEGIN
    
      ;Are we done here?
      IF ALOG10(collapseAge - time) LE 0 THEN GOTO, donePlot
      
      ;Work out the actual convective zones
      czs = masslist[WHERE((nablaradData[time] - nabla_adData[time]) GT 0)] / 2d33
      prad = prad_over_ptotData[time]
      energy_gen = epsilonData[time]
      eddFac = LradData[time] / LtotData[time]
      
      IF MIN(prad) LT pradLims[0] THEN pradLims[0] = MIN(prad)
      IF MAX(prad) GT pradLims[1] THEN pradLims[1] = MAX(prad)

      IF MIN(energy_gen) LT energy_genLims[0] THEN energy_genLims[0] = MIN(energy_gen)
      IF MAX(energy_gen) GT energy_genLims[1] THEN energy_genLims[1] = MAX(energy_gen)

      IF MIN(eddFac) LT eddFacLims[0] THEN eddFacLims[0] = MIN(eddFac)
      IF MAX(eddFac) GT eddFacLims[1] THEN eddFacLims[1] = MAX(eddFac)
      
      IF (N_ELEMENTS(p0) AND N_ELEMENTS(p1) AND N_ELEMENTS(p2) AND N_ELEMENTS(p3)) NE 0 THEN BEGIN
      p0.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(czs), VALUE = ALOG10(collapseAge - time)), [czs], /SYM_FILLED, $
        XTITLE = 'Log Time to Collapse', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = czsTitle, XRANGE = [ALOG10(collapseAge - (MintData.Keys())[0]),0],$
        NAME = 'Unstable Against Convection', LAYOUT = [1,5,1], SYMBOL = 'o', SYM_SIZE = 0.4, /CURRENT, OVERPLOT = p0[-1], BUFFER = buffervar)
        
      p1.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(masslist), VALUE = ALOG10(collapseAge - time)), [masslist] / 2d33, /SYM_FILLED, $
        XTITLE = 'Log Time to Collapse', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = eddMassTitle, XRANGE = [ALOG10(collapseAge - (MintData.Keys())[0]),0],$
        LAYOUT = [1,5,2], SYMBOL = 'o', SYM_SIZE = 0.4, MAGNITUDE = eddFac, RGB_TABLE = 11, /CURRENT, OVERPLOT = p1[-1], BUFFER = buffervar)
        
      p2.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(masslist), VALUE = ALOG10(collapseAge - time)), [masslist] / 2d33, /SYM_FILLED, $
        XTITLE = 'Log Time to Collapse', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = pradTitle, SYM_COLOR='red',$
        MAGNITUDE = prad, RGB_TABLE = 11, XRANGE = [ALOG10(collapseAge - (MintData.Keys())[0]),0], LAYOUT = [1,5,3], SYMBOL = 'o', SYM_SIZE = 0.4,$
           /CURRENT, OVERPLOT = p2[-1], BUFFER = buffervar)
        
      p3.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(masslist), VALUE = ALOG10(collapseAge - time)), [masslist] / 2d33, /SYM_FILLED, $
        XTITLE = 'Log Time to Collapse', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = enGenTitle, SYM_COLOR='red',$
         MAGNITUDE = energy_gen, RGB_TABLE = 3, XRANGE = [ALOG10(collapseAge - (MintData.Keys())[0]),0], LAYOUT = [1,5,4],$
           SYMBOL = 'o', SYM_SIZE = 0.4, /CURRENT, OVERPLOT = p3[-1], BUFFER = buffervar)
      ENDIF ELSE BEGIN
        p0.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(czs), VALUE = ALOG10(collapseAge - time)), [czs], /SYM_FILLED, $
          XTITLE = 'Log Time to Collapse', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = czsTitle, XRANGE = [ALOG10(collapseAge - (MintData.Keys())[0]),0],$
          NAME = 'Unstable Against Convection', LAYOUT = [1,5,1], SYMBOL = 'o', SYM_SIZE = 0.4, /CURRENT, BUFFER = buffervar)

        p1.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(masslist), VALUE = ALOG10(collapseAge - time)), [masslist] / 2d33, /SYM_FILLED, $
          XTITLE = 'Log Time to Collapse', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = eddMassTitle, XRANGE = [ALOG10(collapseAge - (MintData.Keys())[0]),0],$
          LAYOUT = [1,5,2], SYMBOL = 'o', SYM_SIZE = 0.4, MAGNITUDE = eddFac, RGB_TABLE = 11, /CURRENT, BUFFER = buffervar)

        p2.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(masslist), VALUE = ALOG10(collapseAge - time)), [masslist] / 2d33, /SYM_FILLED, $
          XTITLE = 'Log Time to Collapse', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = pradTitle, SYM_COLOR='red',$
          MAGNITUDE = prad, RGB_TABLE = 11, XRANGE = [ALOG10(collapseAge - (MintData.Keys())[0]),0], LAYOUT = [1,5,3], SYMBOL = 'o', SYM_SIZE = 0.4,$
          /CURRENT, BUFFER = buffervar)

        p3.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(masslist), VALUE = ALOG10(collapseAge - time)), [masslist] / 2d33, /SYM_FILLED, $
          XTITLE = 'Log Time to Collapse', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = enGenTitle, SYM_COLOR='red',$
          MAGNITUDE = energy_gen, RGB_TABLE = 3, XRANGE = [ALOG10(collapseAge - (MintData.Keys())[0]),0], LAYOUT = [1,5,4],$
          SYMBOL = 'o', SYM_SIZE = 0.4, /CURRENT, BUFFER = buffervar)
      ENDELSE
      
      
      oldtime = time
    ENDIF

  ENDFOREACH
  donePlot:
  c1 = COLORBAR(TARGET = p1[-1], TITLE = 'Eddington Parameter with Mass', /BORDER)
  c1.RANGE = eddFacLims
  c2 = COLORBAR(TARGET = p2[-1], TITLE = 'Radiation Pressure / Total Pressure', /BORDER)
  c2.RANGE = pradLims
  c3 = COLORBAR(TARGET = p3[-1], TITLE = 'Nuclear Energy Generation (erg/g/s)', /BORDER)
  c3.RANGE = energy_genLims
  
  
    p4 = PLOT(ALOG10(collapseAge - wg_u1), wg_eddesm, COLOR = 'black', /CURRENT, LAYOUT = [1,5,5], TITLE = 'Eddington Parameter as a Function of Age', $
    XTITLE = 'Log Time to Collapse', YTITLE = 'Eddington Parameter', XRANGE = [ALOG10(collapseAge - (MintData.Keys())[0]),0], BUFFER = buffervar)


  IF KEYWORD_SET(tosave) THEN BEGIN
    imagedir = '/home/AHACKETT_Project/_PopIIIProject/IDL_Plots/TESTStructure_Plots/'
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
