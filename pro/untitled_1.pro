modelstr='P060z14S0'

ZE_CMFGEN_SPEC_FIND_AVAILABLE_TIMESTEPS,modelstr,timesteps_available,allobsfinfiles,allobscontfiles ;finds which timesteps have spectra computede in  dir 

bands=['U','B','V','R','I','WFPC2_F336W','WFPC2_F450W','WFPC2_F606W','WFPC2_F814W','WFPC2_F170W','WFPC2_F555W','J','H','Ks']
;
;mstar_array_norot=dblarr(n_elements(timesteps_available),n_elements(bands))
lstar_array_60norot=dblarr(n_elements(timesteps_available),n_elements(bands))
tstar_array_60norot=dblarr(n_elements(timesteps_available),n_elements(bands))
teff_array_60norot=dblarr(n_elements(timesteps_available),n_elements(bands))
Mv_array_60norot=dblarr(n_elements(timesteps_available),n_elements(bands))
Mbol_array_60norot=dblarr(n_elements(timesteps_available),n_elements(bands))
BC_array_60norot=dblarr(n_elements(timesteps_available),n_elements(bands))
;
for i=1, 1 DO begin
 for j=0, n_elements(bands) - 1 do begin 
  dirmod=strmid(allobsfinfiles[i],0,strpos(allobsfinfiles[i],modelstr)+10)
  a=strmid(allobsfinfiles[i],strpos(allobsfinfiles[i],modelstr)+9)
  model_60norot=strmid(a,0,strpos(a,'obs')-1)
  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_60norot,bands[j],Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt
  ;mstar_array_norot[i,j]=mstart 
  lstar_array_60norot[i,j]=lstart
  tstar_array_60norot[i,j]=tstart
  teff_array_60norot[i,j]=tstart
  Mv_array_60norot[i,j]=absolute_magt
  Mbol_array_60norot[i,j]=Mbolt
  BC_array_60norot[i,j]=BCt    
 endfor 
endfor  

END