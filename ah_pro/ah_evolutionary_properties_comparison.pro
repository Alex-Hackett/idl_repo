;+
; :Author: Alex
; PROC to produce a HRD and a plot of central conditions and core mass
; as a function of central X abundance for an arbitrary set of GENEC models
; of different masses and convective overshooting parameters
;
;-
PRO ah_evolutionary_properties_comparison, TOSAVE=tosave, __savefile_dir_=__savefile_dir_

  ;##########################
  ;##########################
  ;#####FILE I/O STUFF#######
  ;##########################
  ;##########################

  IF N_ELEMENTS(__savefile_dir_) EQ 0 THEN BEGIN
    __savefile_dir_ = '/home/AHACKETT_Project/_PopIIIProject/geneva_model_data/IDL_genec_struc_saves/'
    defdirmes = STRTRIM('Using Default Sav File Dir: ' + __savefile_dir_ , 2)
    PRINT, defdirmes
  ENDIF

  IF FILE_TEST(__savefile_dir_, /DIRECTORY) EQ 0 THEN BEGIN
    FILE_MKDIR, __savefile_dir_
  ENDIF

  ;Find all the .Sav Files

  _savFileList_ = FILE_SEARCH(__savefile_dir_, '*.sav')

  ;Step up plotting arrays

  TeffArray = []
  LogLsunArray = []
  TcArray = []
  RhoccArray = []
  AgeArray = []
  CentralXArray = []
  CentralYArray = []
  CentralCArray = []
  ConvCoreMassFracArray = []
  EddParArray = []
  LoggArray = []

  IF KEYWORD_SET(tosave) THEN BEGIN
    buffervar = 1
    PRINT, 'Loading Offscreen Buffers and Saving'
  ENDIF ELSE BEGIN
    buffervar = 0
    PRINT, 'Displaying Plots On Screen'
  ENDELSE
  ;Let's use a rainbow CT, lots of distinct colors
  LOADCT, 13

  ;Begin Main Loop
  ;Start generating arrays for plotting
  P0 = LIST()
  P1 = LIST()
  P2 = LIST()
  P3 = LIST()
  P4 = LIST()
  P5 = LIST()
  P0.ADD, WINDOW(BUFFER = buffervar, DIMENSIONS=GET_SCREEN_SIZE(), NAME = 'HRD')
  P1.ADD, WINDOW(BUFFER = buffervar, DIMENSIONS=GET_SCREEN_SIZE(), NAME = 'Central Conditions')
  P2.ADD, WINDOW(BUFFER = buffervar, DIMENSIONS=GET_SCREEN_SIZE(), NAME = 'CoreMass with X Frac')
  P3.ADD, WINDOW(BUFFER = buffervar, DIMENSIONS=GET_SCREEN_SIZE(), NAME = 'CoreMass with Time')
  P4.ADD, WINDOW(BUFFER = buffervar, DIMENSIONS=GET_SCREEN_SIZE(), NAME = 'Eddington Parameter with X Frac')
  P5.ADD, WINDOW(BUFFER = buffervar, DIMENSIONS=GET_SCREEN_SIZE(), NAME = 'Log g with Time')
  
  bgcol = 'white'
;  P0.ADD, PLOT([0,0], [0,0], BUFFER = buffervar, BACKGROUND_COLOR=cgColor(bgcol))
;  P1.ADD, PLOT([0,0], [0,0], BUFFER = buffervar, BACKGROUND_COLOR=cgColor(bgcol))
;  P2.ADD, PLOT([0,0], [0,0], BUFFER = buffervar, BACKGROUND_COLOR=cgColor(bgcol))
;  P3.ADD, PLOT([0,0], [0,0], BUFFER = buffervar, BACKGROUND_COLOR=cgColor(bgcol))
;  P4.ADD, PLOT([0,0], [0,0], BUFFER = buffervar, BACKGROUND_COLOR=cgColor(bgcol))
;  P5.ADD, PLOT([0,0], [0,0], BUFFER = buffervar, BACKGROUND_COLOR=cgColor(bgcol))
; 
  FOREACH _savFileName_, _savFileList_, _index_ DO BEGIN
    cols = ORDEREDHASH(!COLOR)
    colgen = ROUND(RANDOMU(SYSTIME(/UTC, /SECONDS)) * 145)
    colorFactor = (cols.Keys())[colgen]

    modelname = STRMID(_savFileName_, STRPOS(_savFileName_, '_', /REVERSE_SEARCH) + 1, 14)
    ;_savefile_ = STRTRIM(__savefile_dir_ + 'Hashed_StrucData_' + STRING(modelname)+'.sav',2)
    _savefile_ = _savFileName_

    IF FILE_TEST(_savefile_) THEN BEGIN
      savemesg = STRTRIM('==============.sav File ' + _savefile_ + ' Found, Restoring==============', 2)
      PRINT, '======================================================================================='
      PRINT, '======================================================================================='
      PRINT, '======================================================================================='
      PRINT, savemesg
      PRINT, '======================================================================================='
      PRINT, '======================================================================================='
      PRINT, '======================================================================================='
      RESTORE, _savefile_
    ENDIF

    IF FILE_TEST(STRING(_savefile_)) NE 1 THEN BEGIN
      filenot = STRTRIM(STRING(_savefile_) + 'Not Found')
      PRINT, filenot
      ;Bail out of the loop
      PRINT, 'Not a Vaild .sav For Reading, Skipping'
      CONTINUE
    ENDIF

    ;####################
    ;####################
    ;###ArrayGenStuff####
    ;####################
    ;####################



    TeffArray = wg_xte
    LogLsunArray = wg_xl
    TcArray = wg_tc
    RhoccArray = wg_rhoc
    AgeArray = wg_u1
    CentralXArray = wg_u15
    CentralYArray = wg_u17
    CentralCArray = wg_u18
    ConvCoreMassFracArray = wg_qmnc
    EddParArray = wg_eddesm
    LoggArray = wg_logg

    ;Setting up Plots
    ;P0 = HRD
    ;P1 = Central Conditions
    ;P2 = Coremass with X frac
    ;P3 = Coremass with time
    ;P4 = EddPar with X frac
    ;P5 = Logg with Time


    ;###############################################
    ;Plot0, HRD
    HRDTITLE = STRTRIM('HR Diagram', 2)
    HRDName = STRTRIM(STRING(modelname), 2)
    P0.ADD, PLOT(TeffArray, LogLsunArray, XRANGE = [MAX(TeffArray), MIN(TeffArray)], $
      XTITLE = 'Log $T_{eff}$', YTITLE = 'Log L / $L_{\odot}$', TITLE = HRDTITLE, $
      OVERPLOT = P0[-1], NAME = HRDName, COLOR = colorFactor, BUFFER = buffervar, THICK = 1.5)

    ;Plot1, Central Conditions
    CPLOTTITLE = STRTRIM('Plot of Central Conditions', 2)
    CPLOTNAME = STRTRIM(STRING(modelname), 2)
      P1.ADD, PLOT(RhoccArray, TcArray, XTITLE = 'Log $\rho _{c}$ ($g/cm^{3}$)', $
      YTITLE = 'Log $T_{c}$ ($K$)', TITLE = CPLOTTITLE, OVERPLOT = P1[-1], NAME = CPLOTNAME, COLOR = colorFactor, BUFFER = buffervar, THICK = 1.5)

      ;Plot2, Coremass with X frac
      COREXTITLE = STRTRIM('Plot of Convective Core Mass Fraction with Central X Abundance', 2)
    COREXNAME = STRTRIM(STRING(modelname), 2)
    P2.ADD, PLOT(CentralXArray, ConvCoreMassFracArray, XTITLE = 'X Central Mass Fraction', $
      YTITLE = 'Convective Core Mass Fraction', TITLE = COREXTITLE, OVERPLOT = P2[-1], $
      NAME = COREXNAME, COLOR = colorFactor, BUFFER = buffervar, THICK = 1.5, XRANGE = [MAX(CentralXArray), MIN(CentralXArray)])

    ;Plot3, Coremass with Time
    CORETTITLE = STRTRIM('Plot of Convective Core Mass Fraction with Age', 2)
    CORETNAME = STRTRIM(STRING(modelname), 2)
    P3.ADD, PLOT(AgeArray, ConvCoreMassFracArray, XTITLE = 'Age (yrs)', $
      YTITLE = 'Convective Core Mass Fraction', TITLE = CORETTITLE, OVERPLOT = P3[-1], $
      NAME = CORETNAME, COLOR = colorFactor, BUFFER = buffervar, THICK = 1.5)

    ;Plot4, EddPar with X frac
    EDDXTITLE = STRTRIM('Plot of Eddington Parameter at Surface with Central X Abundance', 2)
    EDDXNAME = STRTRIM(STRING(modelname), 2)
    P4.ADD, PLOT(CentralXArray, EddParArray, XTITLE = 'X Central Mass Fraction', $
      YTITLE = 'Surface Eddington Parameter', TITLE = EDDXTITLE, OVERPLOT = P4[-1], $
      NAME = EDDXNAME, COLOR = colorFactor, BUFFER = buffervar, THICK = 1.5, XRANGE = [MAX(CentralXArray), MIN(CentralXArray)])
    ;Plot5, Logg with Time
    LOGGTITLE = STRTRIM('Plot of Log g with Age', 2)
    LOGGNAME = STRTRIM(STRING(modelname), 2)
    P5.ADD, PLOT(AgeArray, LoggArray, XTITLE = 'Age (yrs)', $
      YTITLE = 'Log g ($cm/s^{2}$)', TITLE = LOGGTITLE, OVERPLOT = P5[-1], NAME = LOGGNAME, COLOR = colorFactor, BUFFER = buffervar, THICK = 1.5)

    ;Plotting Completed
  ENDFOREACH

  ;Construct Legends
  screenDims = GET_SCREEN_SIZE()
  screenDims = [screenDims[0],ScreenDims[1] - 75]
  leg0 = LEGEND(TARGET = P0[1:*], SHADOW = 0, POSITION=screenDims, /DEVICE, /AUTO_TEXT_COLOR)
  leg1 = LEGEND(TARGET = P1[1:*], SHADOW = 0, POSITION=screenDims, /DEVICE, /AUTO_TEXT_COLOR)
  leg2 = LEGEND(TARGET = P2[1:*], SHADOW = 0, POSITION=screenDims, /DEVICE, /AUTO_TEXT_COLOR)
  leg3 = LEGEND(TARGET = P3[1:*], SHADOW = 0, POSITION=screenDims, /DEVICE, /AUTO_TEXT_COLOR)
  leg4 = LEGEND(TARGET = P4[1:*], SHADOW = 0, POSITION=screenDims, /DEVICE, /AUTO_TEXT_COLOR)
  leg5 = LEGEND(TARGET = P5[1:*], SHADOW = 0, POSITION=screenDims, /DEVICE, /AUTO_TEXT_COLOR)

  IF KEYWORD_SET(tosave) THEN BEGIN
    saveImageDir = '/home/AHACKETT_Project/_PopIIIProject/IDL_GENERAL_COMPARISON_PLOTS_NEW/'
    IF FILE_TEST(saveImageDir, /DIRECTORY) EQ 0 THEN BEGIN
      FILE_MKDIR, saveImageDir
      dircreatemes = STRTRIM('Image Dir ' + STRING(saveImageDir) + ' Created', 2)
      PRINT, dircreatemes
    ENDIF

    ;Generate Filenames
    PGENFILENAME = STRTRIM(saveImageDir + 'Comparison_Plots.pdf', 2)
    P0fileName = STRTRIM(saveImageDir + 'Comparison' + '_HRD.pdf', 2)
    P1fileName = STRTRIM(saveImageDir + 'Comparison' + '_Central_conds.pdf', 2)
    P2fileName = STRTRIM(saveImageDir + 'Comparison' + '_coremass_x_frac.pdf', 2)
    P3fileName = STRTRIM(saveImageDir + 'Comparison' + '_coremass_time.pdf', 2)
    P4fileName = STRTRIM(saveImageDir + 'Comparison' + '_eddington_x_frac.pdf', 2)
    P5fileName = STRTRIM(saveImageDir + 'Comparison' + '_Logg_age.pdf', 2)

    ;Save the Files (use bitmapping in case there are lots of plots!)

    P0S = P0[-1]
    P1S = P1[-1]
    P2S = P2[-1]
    P3S = P3[-1]
    P4S = P4[-1]
    P5S = P5[-1]

    PRINT, 'SAVING IMAGES'

;    P0S.SAVE, P0fileName, /BITMAP
;    p0smes = STRTRIM('IMAGE SAVED AS ' + STRING(P0fileName), 2)
;    PRINT, p0smes
;    P1S.SAVE, P1fileName, /BITMAP
;    p1smes = STRTRIM('IMAGE SAVED AS ' + STRING(P1fileName), 2)
;    PRINT, p1smes
;    P2S.SAVE, P2fileName, /BITMAP
;    p2smes = STRTRIM('IMAGE SAVED AS ' + STRING(P2fileName), 2)
;    PRINT, p2smes
;    P3S.SAVE, P3fileName, /BITMAP
;    p3smes = STRTRIM('IMAGE SAVED AS ' + STRING(P3fileName), 2)
;    PRINT, p3smes
;    P4S.SAVE, P4fileName, /BITMAP
;    p4smes = STRTRIM('IMAGE SAVED AS ' + STRING(P4fileName), 2)
;    PRINT, p4smes
;    P5S.SAVE, P5fileName, /BITMAP
;    p5smes = STRTRIM('IMAGE SAVED AS ' + STRING(P5fileName), 2)
;    PRINT, p5smes

    P0S.SAVE, PGENFILENAME, /BITMAP, /APPEND
    p0smes = STRTRIM('IMAGE SAVED AS ' + STRING(PGENFILENAME), 2)
    PRINT, p0smes
    P1S.SAVE, PGENFILENAME, /BITMAP, /APPEND
    p1smes = STRTRIM('IMAGE SAVED AS ' + STRING(PGENFILENAME), 2)
    PRINT, p1smes
    P2S.SAVE, PGENFILENAME, /BITMAP, /APPEND
    p2smes = STRTRIM('IMAGE SAVED AS ' + STRING(PGENFILENAME), 2)
    PRINT, p2smes
    P3S.SAVE, PGENFILENAME, /BITMAP, /APPEND
    p3smes = STRTRIM('IMAGE SAVED AS ' + STRING(PGENFILENAME), 2)
    PRINT, p3smes
    P4S.SAVE, PGENFILENAME, /BITMAP, /APPEND
    p4smes = STRTRIM('IMAGE SAVED AS ' + STRING(PGENFILENAME), 2)
    PRINT, p4smes
    P5S.SAVE, PGENFILENAME, /BITMAP, /APPEND, /CLOSE
    p5smes = STRTRIM('IMAGE SAVED AS ' + STRING(PGENFILENAME), 2)
    PRINT, p5smes
  
    PRINT, 'ALL IMAGES SAVED'
  ENDIF ELSE BEGIN
    PRINT, 'IMAGES GENNED!!'
    PRINT, 'SAVE MANUALLY TO RETAIN'
  ENDELSE

RETURN
END
