;+
; :Author: AHACKETT
;-
PRO ah_track_energy_generation_profiles, model, tracker, AGETRACK=agetrack, $
   XFRACTRACK=xfractrack, YFRACTRACK=yfractrack, CFRACTRACK=cfractrack, TOSAVE=tosave
   
   ;##################screenDims
   ;##FILE I/O STUFF##
   ;##################
   
   savtobeloaded = ah_load_savs(model, /STRUC, /VFILE, /XDRIVE)
   RESTORE, savtobeloaded[0]
   RESTORE, savtobeloaded[1]
   
   IF KEYWORD_SET(agetrack) THEN BEGIN
    wg_age = v_epsData.Keys()
    wg_age = wg_age.TOARRAY()
    input_age = tracker
    set_age = wg_age[FINDEL(input_age, wg_age)]
   ENDIF
   
   IF KEYWORD_SET(xfractrack) THEN BEGIN
    wg_age = v_epsData.KEYS()
    wg_age = wg_age.TOARRAY()
    xfrac = tracker
    wg_xfrac = wg_u15
    set_age = wg_age[FINDEL(xfrac, wg_xfrac)]
   ENDIF
   
   eps_arr = ALOG10(v_epsData[set_age])
   epsy_arr = ALOG10(v_epsyData[set_age])
   epsc_arr = ALOG10(v_epscData[set_age])
   epsnu_arr = ALOG10(v_epsnuData[set_age])
   eps3a_arr = ALOG10(v_eps3aData[set_age])
   epsCO_arr = ALOG10(v_epsCOData[set_age])
   epsON_arr = ALOG10(v_epsONedata[set_age])
   egrav_arr = ALOG10(v_egravData[set_age])
   
   IF KEYWORD_SET(tosave) THEN buffervar = 1 ELSE buffervar = 0
   
   ;Plotting Section
   P = LIST()
   settitle = STRTRIM('Energy Sources for ' + STRING(model) + ' at ' + STRING(set_age) + ' yrs', 2)
   P_WIN = WINDOW(DIMENSIONS = GET_SCREEN_SIZE(), BUFFER = buffervar)
   P.ADD, PLOT([0,0],[0,0], XTITLE = 'Mass Coordinate', YTITLE = 'Log Energy Generation Rate (erg/s/g)', $
    TITLE = settitle, BUFFER = buffervar, /OVERPLOT)
   P.ADD, PLOT(v_xmrData[set_age], eps_arr, /OVERPLOT, NAME = 'Hydrogen Burning', COLOR = 'black', BUFFER = buffervar)
   ;P.ADD, PLOT(v_xmrData[set_age], epsy_arr, /OVERPLOT, NAME = 'Helium Burning', COLOR = 'green')
   ;P.ADD, PLOT(v_xmrData[set_age], epsc_arr, /OVERPLOT, NAME = 'Carbon Burning', COLOR = 'red')
   ;P.ADD, PLOT(v_xmrData[set_age], epsnu_arr, /OVERPLOT, NAME = 'Overall Nuclear Burning', COLOR = 'black')
   P.ADD, PLOT(v_xmrData[set_age], eps3a_arr, /OVERPLOT, NAME = '3a Burning', COLOR = 'green', BUFFER = buffervar)
   P.ADD, PLOT(v_xmrData[set_age], epsCO_arr, /OVERPLOT, NAME = 'CO Burning', COLOR = 'red', BUFFER = buffervar)
   P.ADD, PLOT(v_xmrData[set_age], epsON_arr, /OVERPLOT, NAME = 'ON Burning', COLOR = 'blue', BUFFER = buffervar)
   ;P.ADD, PLOT(v_xmrData[set_age], egrav_arr, /OVERPLOT, NAME = 'Gravitational Energy', COLOR = 'pale goldenrod')
   screenDims = GET_SCREEN_SIZE()
   screenDims = [screenDims[0],ScreenDims[1] - 105]
   leg0 = LEGEND(TARGET = P[1:*], SHADOW = 0, POSITION=screenDims, /DEVICE, /AUTO_TEXT_COLOR)
   
   IF KEYWORD_SET(tosave) THEN BEGIN
     saveImageDir = '/home/AHACKETT_Project/_PopIIIProject/IDL_Plots/XFRAC_Energy_Gen/'
     IF FILE_TEST(saveImageDir, /DIRECTORY) EQ 0 THEN BEGIN
       FILE_MKDIR, saveImageDir
       dircreatemes = STRTRIM('Image Dir ' + STRING(saveImageDir) + ' Created', 2)
       PRINT, dircreatemes
     ENDIF
     imagefilename = STRTRIM(saveImageDir + STRING(model) + '_PRESN_BURNPLOT.pdf')
     imsav = P[-1]
     imsav.SAVE, imagefilename, /BITMAP
     savmess = STRTRIM('Image: ' + imagefilename + ' Saved', 2)
   ENDIF
   
   
  END