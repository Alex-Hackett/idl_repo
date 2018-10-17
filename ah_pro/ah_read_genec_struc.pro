;+
; :Author: Alex
; This Proc Reads in all the structure 
; data file data from a GENEC output into an
; ordered hash structure that is keyed by the age of the model, in years, and 
; the hash values are ordered hashes that contain the data
; The proc also finds and reads in the relevant .wg file in order to plot quantities such as
; the eddington parameter, effective temperature with time and abundances, for example
; 
; Struc vars are named with the key from the strucData file, wg vars are named with the standard
; GENEC .wg convections, with wg_ in front of the var to prevent namespace conflicts
;-
PRO ah_read_genec_struc, modelname, MDDIR = mddir, sampling, OVERWRITE=overwrite

IF N_ELEMENTS(sampling) EQ 0 THEN BEGIN
  sampling = 2000.
  mg = STRTRIM('Defaulting to Sampling ' + STRING(sampling) + ' Files')
  PRINT, mg
ENDIF
IF KEYWORD_SET(mddir) THEN BEGIN
  ;We got passed the whole dir, so
  ;Make the right strucfiles
  strucFiles = FILE_SEARCH(STRTRIM(modelname + '/'), '*Struc*')
  wgFile = FILE_SEARCH(STRTRIM(modelname + '/'), '*.wg')
  ;Pull the model name from the dir str for naming the .sav
  modeldir = STRTRIM(modelname + '/', 2)
  modelname = STRMID(modelname, 13, /REVERSE_OFFSET)
  ;Cheeky goto is a nice lazy way to skip the next bit
  ;without needing an else statment (Take that python!)
  GOTO, nodirmake
ENDIF

modelname = STRING(modelname)
modeldir = STRTRIM('/home/AHACKETT_Project/_PopIIIProject/geneva_models/' + STRING(modelname) + '/', 2)
strucFiles = FILE_SEARCH(modeldir, '*Struc*')
wgFile = FILE_SEARCH(modeldir, '*.wg')

nodirmake:

savfiledir = '/home/AHACKETT_Project/_PopIIIProject/geneva_model_data/IDL_genec_struc_saves/'
IF FILE_TEST(savfiledir, /DIRECTORY) EQ 0 THEN BEGIN
  FILE_MKDIR, savfiledir
ENDIF
savfile = STRTRIM(savfiledir + 'Hashed_StrucData_' + STRING(modelname)+'.sav',2)

;If the .sav file already exists, just skip it
  PRINT, savfile
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
  
  IF (FILE_TEST(STRTRIM(modeldir+'*Struc*',2)) OR FILE_TEST(STRTRIM(modeldir+'*.wg',2)))  EQ 0 THEN BEGIN
    baddir = STRTRIM('==========='+modeldir + ' is a bad Dir' + '==============')
    PRINT, '========================================================================================================='
    PRINT, '========================================================================================================='
    PRINT, baddir
    PRINT, '========================================================================================================='
    PRINT, '========================================================================================================='
    RETURN
  ENDIF
  
  ;###################################################
  ;Set up the ordered hashes for reading eachah_gen_all_vFiles_sav var into
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
  
  ;#################################################################
  
  
  ;#################################################################
  ;Read in the wg data
  IF N_ELEMENTS(wgFile) GT 1 THEN BEGIN
    multimesg = STRTRIM('Multiple .wg Files Found, Using the First One')
    PRINT, multimesg
    wgFile = wgFile[0]
  ENDIF
  wgfilefoundmesg = STRTRIM('Reading in .wg file: ' + wgFile, 2)
  PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
  PRINT, '++++++++++++++++++++++++++++++++++++ah_gen_all_vFiles_sav+++++++++++++++++++++++++++++++++++++++++++++++++++++'
  PRINT, wgfilefoundmesg
  PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
  PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
  ;Read the wg file
  AH_READ_WG_FILE_FOR_HASHED_STRUCT,wgfile,data_wgfile,data_wgfile_cut,reload=reload,binary=binary
  ;read the wg vars
  ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,wg_rstar,wg_logg,wg_vesc,wg_vinf,wg_eta_star,wg_Bmin,wg_Jdot,wg_logg_rphot,wg_rphot,wg_beq,wg_beta,wg_ekin
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,wg_nm,index_varnamex_wgfile,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,wg_u1,index_varnamex_wgfile,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,wg_u2,index_varnamex_wgfile,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,wg_xtt,index_varnamex_wgfile,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,wg_xl,index_varnamey_wgfile,return_valy
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,wg_u5,return_valz    ;X surface
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,wg_u7,return_valz    ;Y surface
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,wg_u8,return_valz    ;C surface
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,wg_u10,return_valz  ; N surface
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,wg_u12,return_valz   ; O surface
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,wg_u6,return_valz   ; Ne surface
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rhoc',data_wgfile_cut,wg_rhoc,return_valz   ;
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'tc',data_wgfile_cut,wg_tc,return_valz   ;
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,wg_u15,return_valz    ;X center
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,wg_u17,return_valz    ;Y center
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,wg_u18,return_valz    ;C center
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,wg_u20,return_valz    ;N center
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,wg_u22,return_valz    ;O center
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,wg_u16,return_valz    ;Ne20 center
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,wg_qmnc,return_valz    ;mass convective core
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'vequa',data_wgfile_cut,wg_vequa,return_valz    ;equatorial velocity

  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,wg_xmdot,return_valz
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,wg_xte,index_varnamex_wgfile,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,wg_eddesm,index_varnamex_wgfile,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapom2',data_wgfile_cut,wg_rapom2,index_varnamex_wgfile,return_valx
  
  ;##############################################################################################
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
    ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'Mint',data_struct_file,Mint,indah_ionizing_counterex_varnamex_struct_file,return_valx
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
    ;loopgood = STRTRIM('StrucData File ' + STRING(elem)  + ' Sucessfully Read', 2)
    ;PRINT, loopgood
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
