pro ah_model_overplot,model, $
  title=title,xtitle=xtitle,ytitle=ytitle, $
  group=group,xrange=xrange,yrange=yrange, $
  min_val=min_val,max_val=max_val, modal=modal,dir=dir,reload=reload,binary=binary,tempdir=tempdir,verbose=verbose
  ;
  ; CALLING SEQUENCE:
  ;
  if n_params(0) lt 1 then begin
    print,'CALLING SEQUENCE: line_norm,x,y,ynorm,norm
    print,'KEYWORD INPUTS: title,xtitle,ytitle,xrange,yrange
    return
  end


  common ze_evol_select_models_common_v2,info,modelstr,xarray,yarray,xnodes,ynodes,nodes_timestep,rsave,gsave,bsave,nm60,u160,u260,xtt60,xl60,u560,u760,u860,u1060,u1260,u660,xmdot60,xte60,eddesm60,$
    rstar60,logg60,vesc60,vinf60,ekin60,eta_star60,Bmin60,Jdot60,logg_rphot60,rphot60,rapom260,rhoc60,tc60,u1560,u1760,u1860,u2060,u2260,u1660,beta60,qmnc60,xfin_nodes,yfin_nodes,fin_nodes_timestep,$
    xrun_nodes,yrun_nodes,run_nodes_timestep,modeldir,vequa60,outputtempdir
  if n_elements(title) eq 0 then title=''
  if n_elements(xtitle) eq 0 then xtitle=''
  if n_elements(ytitle) eq 0 then ytitle=''
  if n_elements(min_val) eq 0 then min_val=-1e37
  if n_elements(max_val) eq 0 then max_val = 1e37

  modelstr=model

  IF KEYWORD_SET(VERBOSE) THEN PRINT, modelstr
  ;
  ; initilization
  ;
  if n_elements(binary) EQ 0 THEN binary=0
  if n_elements(dir) EQ 0 THEN modeldir='/Users/jgroh/evol_models/Grids2010/wg' eLSE modeldir=dir
  if n_elements(tempdir) EQ 0 THEN tempdir='/Users/jgroh/temp' eLSE tempdir=tempdir
  outputtempdir=tempdir
  wgfile=modeldir+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name
  print,wgfile
  ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut,reload=reload,binary=binary,modeldir=modeldir,tempdir=tempdir

  ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60,logg60,vesc60,vinf60,eta_star60,Bmin60,Jdot60,logg_rphot60,rphot60,beq60,beta60,ekin60
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60,index_varnamex_wgfile,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160,index_varnamex_wgfile,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260,index_varnamex_wgfile,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60,index_varnamex_wgfile,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60,index_varnamey_wgfile,return_valy
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560,return_valz    ;X surface
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760,return_valz    ;Y surface
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860,return_valz    ;C surface
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060,return_valz  ; N surface
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260,return_valz   ; O surface
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660,return_valz   ; Ne surface
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rhoc',data_wgfile_cut,rhoc60,return_valz   ;
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'tc',data_wgfile_cut,tc60,return_valz   ;
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560,return_valz    ;X center
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760,return_valz    ;Y center
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860,return_valz    ;C center
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060,return_valz    ;N center
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260,return_valz    ;O center
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660,return_valz    ;Ne20 center
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60,return_valz    ;mass convective core
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'vequa',data_wgfile_cut,vequa60,return_valz    ;equatorial velocity

  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60,return_valz
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60,index_varnamex_wgfile,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60,index_varnamex_wgfile,return_valx
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapom2',data_wgfile_cut,rapom260,index_varnamex_wgfile,return_valx


  xarray=xte60
  yarray=xl60
  
  END