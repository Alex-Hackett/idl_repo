;+
; :Author: Alex
; This Proc Produces the classic Kippenhahn
; Diagram of convective instability regions as a function
; of model age and mass coordinate, based on the hash sav files
;-

PRO ah_kippenhahn_plotter, themodel, timeskip, TOSAVE = tosave
IF N_ELEMENTS(timeskip) EQ 0 THEN BEGIN
  timeskip = 1d4
  timeskipstr = STRTRIM('No Timeskip Supplied, Defaulting to ' + STRING(timeskip) + ' yrs', 2)
ENDIF
themodel = STRING(themodel)
modelname = themodel
IF KEYWORD_SET(tosave) AND NOT KEYWORD_SET(toplot) THEN BEGIN
  PRINT, 'Can''t Save Without Plotting, So, Will Plot'
  toplot = 1
ENDIF

savfiledir = '/cphys/ugrad/2015-16/JF/AHACKETT/IDLWorkspace/Default/IDL_saves/new_saves/'

IF FILE_TEST(savfiledir, /DIRECTORY) EQ 0 THEN BEGIN
  FILE_MKDIR, savfiledir
ENDIF
savfile = STRTRIM(savfildir + 'Hashed_StrucData_' + STRING(modelname)+'.sav',2)

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

FOREACH masslist, MintData, time DO BEGIN
  
  ;Check if the timesteps is as big as desired
  IF (time - oldtime) GT timeskip THEN BEGIN
    ;Work out the actual convective zones
    
    czs = masslist[WHERE((nablaradData[time] - nabla_adData[time]) GT 0)] / 2d33
    
    p.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(czs), VALUE = time), [czs], /OVERPLOT, /SYM_FILLED, $
      XTITLE = 'Age (Yrs)', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = KTITLE)
      oldtime = time
      
  ENDIF
ENDFOREACH



IF KEYWORD_SET(tosave) THEN BEGIN
plotname = STRTRIM('/home/AHACKETT_Project/_PopIIIProject/IDL_Plots/Kippenhahn_Plots/'+STRING(modelname) + 'Kippenhahn_Plot.pdf')
sucess_mesg = STRTRIM('GRAPHIC GENNED!' + ' Saving as: ' + plotname,2)
PRINT, sucess_mesg
p[-1].Save, plotname, /BITMAP
PRINT, 'GRAPHIC SAVED!!'
WINDOWDELETEALL
ENDIF ELSE PRINT, 'GRAPHIC GENNED!!'
RETURN
END
