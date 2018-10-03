;PRO ZE_EVOL_COMPUTE_AGE_MDOT_TIMESTEP
dir='/Users/jgroh/evol_models/Grids2010/wg/'
model='P060z14S0'
wgfile=dir+model+'.wg' ;assumes model is in wg directory

timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60,logg60,vesc60,vinf60,eta_star60,Bmin60,Jdot60,logg_rphot60,rphot60,beq60,beta60,ekin60,model=model,logtcollapse=logtcollapse60
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
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060,return_valz  ; N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260,return_valz   ; O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660,return_valz   ; Ne center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60,index_varnamex_wgfile,return_valx
;
timestep=[3281,3879,3961,4129,4681,4940,5426,5700,8194,10920,11220,21600]
mass=u260[timestep]
mass=[60.,mass]
age=u160[timestep]
age=[0,age]
diffmass=mass
diffage=age

for i=1, n_elements(mass) -1 do diffmass[i]=mass[i-1]- mass[i]
for i=1, n_elements(mass) -1 do diffage[i]=age[i]- age[i-1]

for i=1, n_elements(mass) -1 do print, diffage[i]/1e6,' &  ',diffage[i]/u160[n_elements(u160)-1]*100.,' &  ',diffmass[i],' &  ',diffmass[i]/(total(diffmass)-u260[0])*100.,FORMAT='(F6.3,A,F6.1,A,F6.2,A,F6.1)'

; print,u160[timestep[i]], ', &, ',u260[timestep[i]]

;print,TOTAL(MASS)
;print,mass/total(mass)


END