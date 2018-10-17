;+
; :Author: AHACKETT
; This Proc reads in a set of v core structure files for a model across all of the timesteps, 
; and saves this into an ordered hash, for later visualizing and processing!
;-

PRO ah_generate_vfile_hash, modelname, MDDIR = mddir, sampling

  IF N_ELEMENTS(sampling) EQ 0 THEN BEGIN
    sampling = 2000.
    mg = STRTRIM('Defaulting to Sampling ' + STRING(sampling) + ' Files')
    PRINT, mg
  ENDIF
  IF KEYWORD_SET(mddir) THEN BEGIN
    ;We got passed the whole dir, so
    ;Make the right strucfiles
    vFiles = FILE_SEARCH(STRTRIM(modelname + '/'), '*.v*')
    ;wgFile = FILE_SEARCH(STRTRIM(modelname + '/'), '*.wg')
    ;Pull the model name from the dir str for naming the .sav
    modeldir = STRTRIM(modelname + '/', 2)
    modelname = STRMID(modelname, 13, /REVERSE_OFFSET)
    ;Cheeky goto is a nice lazy way to skip the next bit
    ;without needing an else statment (Take that python!)
    GOTO, nodirmake
  ENDIF
  defaultvfiledir = '/home/AHACKETT_Project/_PopIIIProject/groh_hard_drive/AHACKETT/GENEC_MODELS/'
  modelname = STRING(modelname)
  modeldir = STRTRIM(defaultvfiledir + STRING(modelname) + '/', 2)
  vFiles = FILE_SEARCH(modeldir, '*.v*')

  nodirmake:

  savfiledir = '/home/AHACKETT_Project/_PopIIIProject/geneva_model_data/IDL_genec_vfile_saves/'
  IF FILE_TEST(savfiledir, /DIRECTORY) EQ 0 THEN BEGIN
    FILE_MKDIR, savfiledir
  ENDIF
  savfile = STRTRIM(savfiledir + 'Hashed_vFileData_' + STRING(modelname)+'.sav',2)
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

    ;If the dir doesn't actually contain any vfiles files, it was probably
    ;a typo, so just warn and bail out

    IF FILE_TEST(STRTRIM(modeldir+'*.v*',2)) EQ 0 THEN BEGIN
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
    
    v_jData = ORDEREDHASH()
    v_xmrData = ORDEREDHASH()
    v_pData = ORDEREDHASH()
    v_tData = ORDEREDHASH()
    v_rData = ORDEREDHASH()
    v_lrData = ORDEREDHASH()
    v_XData = ORDEREDHASH()
    v_YData = ORDEREDHASH()
    v_C12Data = ORDEREDHASH()
    v_O16Data = ORDEREDHASH()
    v_epsData = ORDEREDHASH()
    v_epsyData = ORDEREDHASH()
    v_epscData = ORDEREDHASH()
    v_epsnuData = ORDEREDHASH()
    v_eps3aData = ORDEREDHASH()
    v_epsCOData = ORDEREDHASH()
    v_epsONedata = ORDEREDHASH()
    v_egravData = ORDEREDHASH()
    v_Ne20Data = ORDEREDHASH()
    v_Ne22Data = ORDEREDHASH()
    v_HPData = ORDEREDHASH()
    v_gData = ORDEREDHASH()
    v_Si28Data = ORDEREDHASH()
    v_Fe52Data = ORDEREDHASH()
    v_Ni56Data = ORDEREDHASH()
    
    
    ;##############################################################################################
    PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
    PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
    PRINT, 'READING .V FILES IN' + modeldir
    PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
    PRINT, '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
    vFilesCut = vFiles[ROUND(cgScaleVector(LINDGEN(ROUND(sampling)),0,N_ELEMENTS(vFiles) - 1))]
    FOREACH element, vFilesCut, index DO BEGIN
      AH_EVOL_READ_V_FILE_FROM_GENEVA, element, data_vfile,header_vfile,modnb,v_age,mtot,nbshell,deltat
      
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'j',data_vfile,v_j,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'xmr',data_vfile,v_xmr,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'p',data_vfile,v_p,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'t',data_vfile,v_t,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'r',data_vfile,v_r,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'lr',data_vfile,v_lr,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'X',data_vfile,v_X,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'Y',data_vfile,v_Y,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'C12',data_vfile,v_C12,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'O16',data_vfile,v_O16,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'eps',data_vfile,v_eps,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'epsy',data_vfile,v_epsy,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'epsc',data_vfile,v_epsc,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'epsnu',data_vfile,v_epsnu,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'eps3a',data_vfile,v_eps3a,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'epsCO',data_vfile,v_epsCO,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'epsONe',data_vfile,v_epsONe,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'egrav',data_vfile,v_egrav,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'Ne20',data_vfile,v_Ne20,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'Ne22',data_vfile,v_Ne22,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'HP',data_vfile,v_HP,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'g',data_vfile,v_g,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'Si28',data_vfile,v_Si28,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'Fe52',data_vfile,v_Fe52,index_varnamex_vfile,return_valx
      ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'Ni56',data_vfile,v_Ni56,index_varnamex_vfile,return_valx
      
      ;################################################
      ;Read all the vars into appropriate hashes
      
      v_jData = v_jData + ORDEREDHASH(v_age, v_j)
      v_xmrData = v_xmrData + ORDEREDHASH(v_age, v_xmr)
      v_pData = v_pData + ORDEREDHASH(v_age, v_p)
      v_tData = v_tData + ORDEREDHASH(v_age, v_t)
      v_rData = v_rData + ORDEREDHASH(v_age, v_r)
      v_lrData = v_lrData + ORDEREDHASH(v_age, v_lr)
      v_XData = v_XData + ORDEREDHASH(v_age, v_X)
      v_YData = v_YData + ORDEREDHASH(v_age, v_Y)
      v_C12Data = v_C12Data + ORDEREDHASH(v_age, v_C12)
      v_O16Data = v_O16Data + ORDEREDHASH(v_age, v_O16)
      v_epsData = v_epsData + ORDEREDHASH(v_age, v_eps)
      v_epsyData = v_epsyData + ORDEREDHASH(v_age, v_epsy)
      v_epscData = v_epscData + ORDEREDHASH(v_age, v_epsc)
      v_epsnuData = v_epsnuData + ORDEREDHASH(v_age, v_epsnu)
      v_eps3aData = v_eps3aData + ORDEREDHASH(v_age, v_eps3a)
      v_epsCOData = v_epsCOData + ORDEREDHASH(v_age, v_epsCO)
      v_epsONedata = v_epsONedata + ORDEREDHASH(v_age, v_epsONe)
      v_egravData = v_egravData + ORDEREDHASH(v_age, v_egrav)
      v_Ne20Data = v_Ne20Data + ORDEREDHASH(v_age, v_Ne20)
      v_Ne22Data = v_Ne22Data + ORDEREDHASH(v_age, v_Ne22)
      v_HPData = v_HPData + ORDEREDHASH(v_age, v_HP)
      v_gData = v_gData + ORDEREDHASH(v_age, v_g)
      v_Si28Data = v_Si28Data + ORDEREDHASH(v_age, v_Si28)
      v_Fe52Data = v_Fe52Data + ORDEREDHASH(v_age, v_Fe52)
      v_Ni56Data = v_Ni56Data + ORDEREDHASH(v_age, v_Ni56)
      loopgood = STRTRIM('.v File ' + STRING(element)  + ' Sucessfully Read', 2)
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


