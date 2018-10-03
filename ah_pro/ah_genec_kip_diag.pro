;+
; :Author: AHACKETT
; This Routine Produces a Classic Kippenhan Diagram of Regions of 
; convective instability as a function of mass coordinate and age
;-
PRO ah_genec_kip_diag, modelname
TIC
;modelname = 'P100z000S0d040'
;Build up the model directory string
modeldir = STRTRIM('/home/AHACKETT_Project/_PopIIIProject/geneva_models/' + STRING(modelname) + '/', 2)
strucFiles = FILE_SEARCH(modeldir, '*Struc*')
IF N_ELEMENTS(strucFiles) EQ 0 THEN BEGIN
baddir = STRTRIM('==========='+modeldir + ' Is a Bad Dir' + '==============')
PRINT, '======================================'
PRINT, '======================================'
PRINT, baddir
PRINT, '======================================'
PRINT, '======================================'
STOP
ENDIF

savfile = STRTRIM(modeldir + 'genData' + STRING(modelname)+'.sav',2)
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
IF FILE_TEST(savfile) EQ 0 THEN BEGIN
genData = ORDEREDHASH()
PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
PRINT, 'READING STRUC FILES IN' + modeldir
PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
FOREACH elem, strucFiles, index DO BEGIN
  AH_EVOL_READ_STRUCT_FILE_FROM_GENEVA_ORIGIN2010_V2, elem,data_struct_file,header_structfile,modnb,age,mtot,nbshell,deltat,ncolumns,logteff,compress=compress
  
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'n',data_struct_file,n,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logr',data_struct_file,logr,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'Mint',data_struct_file,Mint,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logT',data_struct_file,logT,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logrho',data_struct_file,logrho,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logP',data_struct_file,logp,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'Cv',data_struct_file,cv,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'dlnP_over_dlnrho_T',data_struct_file,dlnP_over_dlnrho_T,index_varnamex_struct_file1,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'nabla_e',data_struct_file,nabla_e,index_varnamex_struct_file1,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'nabla_ad',data_struct_file,nabla_ad,index_varnamex_struct_file1,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'Lrad',data_struct_file,Lrad,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'Ltot',data_struct_file,Ltot,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logkappa',data_struct_file,logkappa,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'X_H1',data_struct_file,X_H1,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'X_He4',data_struct_file,X_He4,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'mu',data_struct_file,mu,index_varnamex_struct_file,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'epsilon',data_struct_file,epsilon,index_varnamex_struct_file,return_valx

  ZE_EVOL_COMPUTE_QUANTITIES_FROM_STRUCTFILE,data_struct_file,logprad,logpgas,prad_over_ptot,pgas_over_ptot,logpturb,ledd,gammafull_rad,gammafull_tot,nablarad,ebind=ebind
  
  convectiveParam = nablarad - nabla_ad
  unstablemass = Mint[WHERE(convectiveParam GT 0)] / 2d33
  genData = genData + ORDEREDHASH(age, unstablemass)

  HELP, genData

ENDFOREACH
savemes = STRTRIM('---------------' + 'Saving Convective Param Hash to ' + savfile + '---------------',2)
PRINT, '-----------------------------------------------'
PRINT, '-----------------------------------------------'
PRINT, '-----------------------------------------------'
PRINT, savemes
PRINT, '-----------------------------------------------'
PRINT, '-----------------------------------------------'
PRINT, '-----------------------------------------------'
SAVE, genData, FILENAME = savfile
ENDIF


oldtime = 0
p = list()
KTITLE = STRTRIM('Kippenhahn Diagram for '+string(modelname), 2)
FOREACH elem, genData, time DO BEGIN
  
  IF (time - oldtime) GT 1d4 THEN BEGIN
    p.add, SCATTERPLOT(MAKE_ARRAY(N_ELEMENTS(elem), VALUE = time), [elem], /OVERPLOT, /SYM_FILLED, $
      XTITLE = 'Age (Yrs)', YTITLE = 'Mass Coordinate ($M_{\odot}$)', TITLE = KTITLE)
      oldtime = time
  ENDIF
  
ENDFOREACH
;fig1 = SCATTERPLOT(x / 1d6, y / 2d33, TITLE = KTITLE, XTITLE = 'Age (Myrs)', YTITLE = 'Mass Coordinate ($M_{\odot}$)')
plotname = STRTRIM('/home/AHACKETT_Project/_PopIIIProject/IDL_Plots/Kippenhahn_Plots/'+STRING(modelname) + 'Kippenhahn_Plot.pdf')
sucess_mesg = STRTRIM('GRAPHIC GENNED!' + ' Saving as: ' + plotname,2)
PRINT, sucess_mesg
p[-1].Save, plotname, /BITMAP
PRINT, 'GRAPHIC SAVED!!'
windowdeleteall
TOC
END

