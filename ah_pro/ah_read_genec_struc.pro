;+
; :Author: Alex
; This Proc Reads in all the structure 
; data file data from a GENEC output into an
; ordered hash structure that is keyed by the age of the model, in years, and 
; the hash values are ordered hashes that contain the data
;-
PRO ah_read_genec_struc, modelname, MDDIR = mddir, sampling

IF N_ELEMENTS(sampling) EQ 0 THEN BEGIN
  sampling = 1000.
  mg = STRTRIM('Defaulting to Sampling ' + STRING(sampling) + ' Files')
  PRINT, mg
ENDIF
IF KEYWORD_SET(mddir) THEN BEGIN
  ;We got passed the whole dir, so
  ;Make the right strucfiles
  strucFiles = FILE_SEARCH(STRTRIM(modelname + '/'), '*Struc*')
  ;Pull the model name from the dir str for naming the .sav
  modeldir = STRTRIM(modelname + '/', 2)
  modelname = STRMID(modelname, 52)
  ;Cheeky goto is a nice lazy way to skip the next bit
  ;without needing an else statment (Take that python!)
  GOTO, nodirmake
ENDIF

modelname = STRING(modelname)
modeldir = STRTRIM('/home/AHACKETT_Project/_PopIIIProject/geneva_models/' + STRING(modelname) + '/', 2)
strucFiles = FILE_SEARCH(modeldir, '*Struc*')

nodirmake:

savfiledir = '/cphys/ugrad/2015-16/JF/AHACKETT/IDLWorkspace/Default/IDL_saves/new_saves/'
IF FILE_TEST(savfiledir, /DIRECTORY) EQ 0 THEN BEGIN
  FILE_MKDIR, savfiledir
ENDIF
savfile = STRTRIM(savfiledir + 'Hashed_StrucData_' + STRING(modelname)+'.sav',2)

;If the .sav file already exists, just skip it
IF FILE_TEST(STRING(savfile)) EQ 1 THEN BEGIN
  savemesg = STRTRIM('==============.sav File ' + savfile + ' Found, Skipping==============', 2)
  PRINT, '======================================================================================='
  PRINT, '======================================================================================='
  PRINT, '======================================================================================='
  PRINT, savemesg
  PRINT, '======================================================================================='
  PRINT, '======================================================================================='
  PRINT, '======================================================================================='
ENDIF


IF FILE_TEST(savfile) EQ 0 THEN BEGIN

  ;If the dir doesn't actually contain any struc files, it was probably
  ;a typo, so just warn and bail out
  
  IF FILE_TEST(STRTRIM(modeldir+'*Struc*',2)) EQ 0 THEN BEGIN
    baddir = STRTRIM('==========='+modeldir + ' is a bad Dir' + '==============')
    PRINT, '========================================================================================================='
    PRINT, '========================================================================================================='
    PRINT, baddir
    PRINT, '========================================================================================================='
    PRINT, '========================================================================================================='
    RETURN
  ENDIF
  
  ;###################################################
  ;Set up the ordered hashes for reading each var into
  ;###################################################
  shellNumData = ORDEREDHASH()
  logrData = ORDEREDHASH()
  MintData = ORDEREDHASH()
  logTData = ORDEREDHASH()
  logRhoData = ORDEREDHASH()
  logPData = ORDEREDHASH()
  cvData = ORDEREDHASH()
  dlnP_over_dlnrho_TData = ORDEREDHASH()
  nabla_eData = ORDEREDHASH()
  nabla_adData = ORDEREDHASH()
  LradData = ORDEREDHASH()
  LtotData = ORDEREDHASH()
  logkappaData = ORDEREDHASH()
  X_H1Data = ORDEREDHASH()
  X_He4Data = ORDEREDHASH()
  muData = ORDEREDHASH()
  epsilonData = ORDEREDHASH()
  logpradData = ORDEREDHASH()
  logpgasData = ORDEREDHASH()
  prad_over_ptotData = ORDEREDHASH()
  pgas_over_ptotData = ORDEREDHASH()
  logpturbData = ORDEREDHASH()
  leddData = ORDEREDHASH()
  gammafull_radData = ORDEREDHASH()
  gammafull_totData = ORDEREDHASH()
  nablaradData = ORDEREDHASH()
  
  ;###################################################
  
  PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
  PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
  PRINT, 'READING STRUC FILES IN' + modeldir
  PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
  PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
  strucFilesCut = strucFiles[ROUND(cgScaleVector(LINDGEN(ROUND(sampling)),0,N_ELEMENTS(strucFiles) - 1))]
  FOREACH elem, strucFilesCut, index DO BEGIN
    AH_EVOL_READ_STRUCT_FILE_FROM_GENEVA_ORIGIN2010_V2, elem,data_struct_file,header_structfile,modnb,age,mtot,nbshell,deltat,ncolumns,logteff,compress=compress
    
    ;Read vars from struct file
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
    
    ;Compute some extra vars
    ZE_EVOL_COMPUTE_QUANTITIES_FROM_STRUCTFILE,data_struct_file,logprad,logpgas,prad_over_ptot,pgas_over_ptot,logpturb,ledd,gammafull_rad,gammafull_tot,nablarad,ebind=ebind
    ;################################################
    ;Read all the vars into appropriate hashes
    shellNumData = shellNumData + ORDEREDHASH(age, n)
    logrData = logrData + ORDEREDHASH(age, logr)
    MintData = MintData + ORDEREDHASH(age, Mint)
    logTData = logTData + ORDEREDHASH(age, logT)
    logRhoData = logRhoData + ORDEREDHASH(age, logrho)
    logPData = logPData + ORDEREDHASH(age, logp)
    cvData = cvData + ORDEREDHASH(age, cv)
    dlnP_over_dlnrho_TData = dlnP_over_dlnrho_TData + ORDEREDHASH(age, dlnP_over_dlnrho_T)
    nabla_eData = nabla_eData + ORDEREDHASH(age, nabla_e)
    nabla_adData = nabla_adData + ORDEREDHASH(age, nabla_ad)
    LradData = LradData + ORDEREDHASH(age, Lrad)
    LtotData = LtotData + ORDEREDHASH(age, Ltot)
    logkappaData = logkappaData + ORDEREDHASH(age, logkappa)
    X_H1Data = X_H1Data + ORDEREDHASH(age, X_H1)
    X_He4Data = X_He4Data + ORDEREDHASH(age, X_He4)
    muData = muData + ORDEREDHASH(age, mu)
    epsilonData = epsilonData + ORDEREDHASH(age, epsilon)
    logpradData = logpradData + ORDEREDHASH(age, logprad)
    logpgasData = logpgasData + ORDEREDHASH(age, logpgas)
    prad_over_ptotData = prad_over_ptotData + ORDEREDHASH(age, prad_over_ptot)
    pgas_over_ptotData = pgas_over_ptotData + ORDEREDHASH(age, pgas_over_ptot)
    logpturbData = logpturbData + ORDEREDHASH(age, logpturb)
    leddData = leddData + ORDEREDHASH(age, ledd)
    gammafull_radData = gammafull_radData + ORDEREDHASH(age, gammafull_rad)
    gammafull_totData = gammafull_totData + ORDEREDHASH(age, gammafull_tot)
    nablaradData = nablaradData + ORDEREDHASH(age, nablarad)
    loopgood = STRTRIM('StrucData File ' + STRING(elem)  + ' Sucessfully Read', 2)
    PRINT, loopgood
    ;#######################################################
  ENDFOREACH
  
  savemes = STRTRIM('---------------' + 'Saving  Hashes to ' + savfile + '---------------',2)
  PRINT, '-----------------------------------------------'
  PRINT, '-----------------------------------------------'
  PRINT, '-----------------------------------------------'
  PRINT, savemes
  PRINT, '-----------------------------------------------'
  PRINT, '-----------------------------------------------'
  PRINT, '-----------------------------------------------'
  SAVE, /ALL, /COMPRESS, FILENAME = savfile
ENDIF

END
