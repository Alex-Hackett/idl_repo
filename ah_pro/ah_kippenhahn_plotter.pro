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

PRO ah_kippenhahn_plotter, themodel, timeskip, TOSAVE = tosave
IF N_ELEMENTS(timeskip) EQ 0 THEN BEGIN
  timeskip = 1d4
  timeskipstr = STRTRIM('No Timeskip Supplied, Defaulting to ' + STRING(timeskip) + ' yrs', 2)
ENDIF
themodel = STRING(themodel)
modelname = themodel

savfiledir = '/cphys/ugrad/2015-16/JF/AHACKETT/IDLWorkspace/Default/IDL_saves/new_saves/'

IF FILE_TEST(savfiledir, /DIRECTORY) EQ 0 THEN BEGIN
  FILE_MKDIR, savfiledir
ENDIF
savfile = STRTRIM(savfiledir + 'Hashed_StrucData_' + STRING(modelname)+'.sav',2)

;If the .sav file already exists, just read it in
IF FILE_TEST(STRING(savfile)) EQ 1 THEN BEGIN
  savemesg = STRTRIM('==============.sav File ' + savfile + ' Found, Restoring==============', 2)
  PRINT, '======================================================================================='
  PRINT, '======================================================================================='
  PRINT, '======================================================================================='
  PRINT, savemesg
  PRINT, '======================================================================================='
  PRINT, '======================================================================================='
  PRINT, '======================================================================================='
  RESTORE, savfile
ENDIF

IF FILE_TEST(STRING(savfile)) NE 1 THEN BEGIN
  filenot = STRTRIM(STRING(savefile) + 'Not Found, Generate a new one? [WARNING, TAKES A WHILE] (y/n)')
  READ, filenot, to_read
  IF STRING(to_read) EQ 'y' THEN BEGIN
    ah_read_genec_struc, themodel
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
KTITLE = STRTRIM('Kippenhahn Diagram for '+string(modelname), 2)
;KTITLE = STRTRIM('Plot of Energy Generation as a Function of Mass for ' + STRING(modelname), 2)
collapseAge = (MintData.Keys())[-1]
FOREACH masslist, MintData, time DO BEGIN
  
  ;Check if the timesteps is as big as desired
  IF ALOG10(collapseAge - time) LE 0 THEN BEGIN
    ;Work out the actual convective zones
    czs = masslist[WHERE((nablaradData[time] - nabla_adData[time]) GT 0)] / 2d33
    
    energy_gen = epsilonData[time]
    p.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(czs), VALUE = ALOG10(collapseAge - time)), [czs], /OVERPLOT, /SYM_FILLED, $
      XTITLE = 'Log Time to Collapse', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = KTITLE, XRANGE = [0, -4])
    p.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(masslist[WHERE(energy_gen GT 1d5)]), VALUE = ALOG10(collapseAge - time)), [masslist[WHERE(energy_gen GT 1d5)]] / 2d33, /OVERPLOT, /SYM_FILLED, $
      XTITLE = 'Log Time to Collapse', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = KTITLE, SYM_COLOR='red', MAGNITUDE = energy_gen, RGB_TABLE = 3, XRANGE = [0, -4])
      oldtime = time
  ENDIF
ENDFOREACH

c = COLORBAR(TARGET = p[-1], TITLE = 'Intensity of Nuclear Energy Generation')

IF KEYWORD_SET(tosave) THEN BEGIN
plotname = STRTRIM('/home/AHACKETT_Project/_PopIIIProject/IDL_Plots/Kippenhahn_Plots/newframeworkplots/'+STRING(modelname) + 'Kippenhahn_Plot.pdf')
sucess_mesg = STRTRIM('GRAPHIC GENNED!' + ' Saving as: ' + plotname,2)
PRINT, sucess_mesg
p[-1].Save, plotname, /BITMAP
PRINT, 'GRAPHIC SAVED!!'
WINDOWDELETEALL
ENDIF ELSE PRINT, 'GRAPHIC GENNED!!'
RETURN
END
