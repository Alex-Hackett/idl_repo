;PRO ZE_GENERATE_KINETIC_ENERGY_TO_GEORGES
dir='/Users/jgroh/evol_models/Grids2010/wg'
models=['P020z14S0','P025z14S0','P032z14S0','P040z14S0_new','P060z14S0','P085z14S0','P120z14S0','P020z14S4','P025z14S4','P032z14S4','P040z14S4','P060z14S4','P085z14S4','P120z14S4']
models=['P025z14S0','P025z14S4']
for i=0, n_elements(models) -1 DO BEGIN

  wgfile=dir+'/'+models[i]+'.wg' ;assumes model directory name and .wg files have the same name 
  ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut,timestep_ini=0,/reload
  ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar,logg,vesc,vinf,eta_star,Bmin,Jdot,logg_rphot,rphot,beq,beta,ekin
  ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm,index_varnamex_wgfile,return_valx
  writecol,'/Users/jgroh/temp/ekin_'+models[i]+'.dat',nm, vinf,ekin,FMT='(I6,1x,F9.3,1x,E15.4)'
endfor
END