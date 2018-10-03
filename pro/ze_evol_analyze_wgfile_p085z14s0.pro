;PRO ZE_EVOL_ANALYZE_WGFILE_P085z14S0
;general routine for loading, plotting and analyzing a .wg file from the Geneva Stellar Evolution Code Origin2010 

;initilization of variables


;dir='/Users/jgroh/evol_models/Z014/'
;model='P010z14S4'
;model='P010z14S4nomagbreaking'
;model='P010z14S4magbreaking200G'
;model='P010z14S4_1G_RSG'

dir='/Users/jgroh/evol_models/Grids2010/wg'
model='P085z14S0'
wgfile=dir+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;print,'wg file for this model should be: ', wgfile

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload

;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'xtt','xl',zstr='xmdot',/rebin,/xreverse
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60,logg60,vesc60,vinf60,eta_star60,Bmin60,Jdot60,logg_rphot60,rphot60
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
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60,index_varnamex_wgfile,return_valx

timespent60=1d0*(u160-shift(u160,1))
timespent60[0]=1e-2
;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'rhoc','tc',zstr='u15',/rebin
;
;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'u1','eta_star',zstr='Bmin',/rebin,yext=eta_star,zext=Bmin
;
;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'rhoc','tc',zstr='u15',/rebin

;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'u1','xjspe1',zstr='u15',/rebin,/ylog

;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'u1','xjspe2',zstr='u15',/rebin,/ylog

;ZE_EVOL_PLOT_WG_FILE,wgfile,data_wgfile_cut,'u1','xjspe2',/rebin


;eta_star_array=[0,0.01,0.1,0.5,0.7,0.9,1.0,1.2,1.5,2,5,10,20,50,100,200,500,1000]
;Jdot_as_a_function_eta_Star=(0.29+(eta_star_array+0.25)^0.25)^2

;ZE_EVOL_PLOT_XY_GENERAL_EPS,eta_star_array,Jdot_as_a_function_eta_Star,SCOPE_VARNAME(eta_star_array),SCOPE_VARNAME(Jdot_as_a_function_eta_Star),'',XRANGE=[1e-2,1e3],/xlog

;WARNING: IF LOOKING AT A WG FILE, HAVE TO ADD 50 to the timesteps shown below to take into account the fact that the pre-ZAMS evolution (in this case, 50 timesteps) 
;has been cut from the wg file when reading into the IDL matrix
timesteps=[0,750,1500,2250,3000,3500,3800,4150,4700,5000,5100,5350,5820,6250,6551,6870,7201,8201,10131,11201,12551,14951,18950.,21950.,22251,22271,23950,24500]
timesteps_completed=[56,500,1000,1750,2500,3500,3800,4301,4379,4501,4701,4717,4723,4729,5404,5500,5820,6250,6551,7201,8201,11201,12551,14951,18950.,21950,22271,23950,24500]
;i=3800 ;timestep
for i=0, n_elements(timesteps) -1 do begin
  print,'Timestep: ',timesteps[i]
  print,u160[timesteps[i]],u260[timesteps[i]],10^xte60[timesteps[i]],10^xtt60[timesteps[i]],10^xl60[timesteps[i]],rstar60[timesteps[i]],logg_rphot60[timesteps[i]],10^xmdot60[timesteps[i]],vinf60[timesteps[i]]
  print,'surface mass fractions'
  print,u560[timesteps[i]],u760[timesteps[i]],u860[timesteps[i]],u1060[timesteps[i]],u1260[timesteps[i]],u660[timesteps[i]]
  print,'log g at tauross=100'
  print,logg60[timesteps[i]]
endfor

label=model
;HR diagram for non rotating model 60 Msun, color coded with xmdot
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xtt60,xl60,'xtt','xl',label,z1=xmdot60,labelz='xmdot',$
;                              minz=-5.5,maxz=-2.8,rebin=1,xreverse=1,_EXTRA=extra
;
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xtt60,xl60,'xtt','xl',label,z1=eddesm60,labelz='eddesm',$
;                              minz=0.2,maxz=1.0,rebin=1,xreverse=1,_EXTRA=extra
;
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xtt60,xl60,'xtt','xl',label,z1=u760,labelz='u7 Y surf',$
;                              minz=0.0,maxz=1.0,rebin=1,xreverse=1,_EXTRA=extra
;
;;HR diagram for non rotating model 60 Msun, color coded with xmdot
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte60,xl60,'xte','xl',label,z1=xmdot60,labelz='xmdot',$
;                              minz=-5.5,maxz=-2.8,rebin=1,xreverse=1,_EXTRA=extra

;HR diagram for non rotating model 60 Msun, color coded with age
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte60,xl60,'xte','xl',label,z1=alog10(u160),labelz='u1',$
;                              minz=5.5,maxz=6.6,rebin=1,xreverse=1,_EXTRA=extra
tstar_Array=[1,1]
teff_Array=[1,1]
lstar_Array=[1,1]                              
;HR diagram for non rotating model 60 Msun, color coded with age
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte60,xl60,'xte','xl',label,z1=xmdot60,x2points=alog10(tstar_array),y2points=alog10(lstar_array),labelz='xmdot',$
                              minz=-6,maxz=-3,rebin=1,xreverse=1,_EXTRA=extra,timesteps=timesteps,YRANGE=[5.7,6.4],xrange=[5.45,3.75]                              

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,10^xte60,10^xl60,'lin xte','lin xl',label,z1=xmdot60,x2points=tstar_array,y2points=lstar_array,labelz='xmdot',$
                              minz=-6,maxz=-3,rebin=1,xreverse=1,_EXTRA=extra,timesteps=timesteps,YRANGE=[10^5.7,10^6.4],xrange=[100000,8000]  

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xtt60,xl60,'xtt','xl',label,z1=xmdot60,x2points=alog10(teff_array),y2points=alog10(lstar_array),labelz='xmdot',$
                              minz=-6,maxz=-3,rebin=1,xreverse=1,_EXTRA=extra,timesteps=timesteps,YRANGE=[5.7,6.4] ,xrange=[5.45,3.75]   

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte60,xl60,'xte','xl',label,xreverse=1,_EXTRA=extra,YRANGE=[5.4,6.2],xrange=[5.45,3.75]      

j=0
beta=0.8 
evol_vadat_file='/Users/jgroh/temp/EVOL_VADAT_model_'+strtrim(string(j,FORMAT='(I6)'),2)+'.txt'     
ZE_EVOL_WRITE_INPUT_TO_CMFGEN_VADAT_FORMAT,j,u160[j],u260[j],xte60[j],xtt60[j],xl60[j],rstar60[j],logg60[j],xmdot60[j],vinf60[j],beta,$
                                           u560[j],u760[j],u860[j],u1060[j],u1260[j],u660[j],evol_vadat_file,popscl=0               


j=24500
beta=1.0  
evol_vadat_file='/Users/jgroh/temp/EVOL_VADAT_model_'+strtrim(string(j,FORMAT='(I6)'),2)+'.txt'     
ZE_EVOL_WRITE_INPUT_TO_CMFGEN_VADAT_FORMAT,j,u160[j],u260[j],xte60[j],xtt60[j],xl60[j],rstar60[j],logg60[j],xmdot60[j],vinf60[j],beta,$
                                           u560[j],u760[j],u860[j],u1060[j],u1260[j],u660[j],evol_vadat_file,popscl=1               


j=4700
beta=0.8 
evol_vadat_file='/Users/jgroh/temp/EVOL_VADAT_model_'+strtrim(string(j,FORMAT='(I6)'),2)+'.txt'     
ZE_EVOL_WRITE_INPUT_TO_CMFGEN_VADAT_FORMAT,j,u160[j],u260[j],xte60[j],xtt60[j],xl60[j],rstar60[j],logg60[j],xmdot60[j],vinf60[j],beta,$
                                           u560[j],u760[j],u860[j],u1060[j],u1260[j],u660[j],evol_vadat_file ,popscl=1               

j=5000
beta=0.8  
evol_vadat_file='/Users/jgroh/temp/EVOL_VADAT_model_'+strtrim(string(j,FORMAT='(I6)'),2)+'.txt'     
ZE_EVOL_WRITE_INPUT_TO_CMFGEN_VADAT_FORMAT,j,u160[j],u260[j],xte60[j],xtt60[j],xl60[j],rstar60[j],logg60[j],xmdot60[j],vinf60[j],beta,$
                                           u560[j],u760[j],u860[j],u1060[j],u1260[j],u660[j],evol_vadat_file,popscl=1                


print,'model                              
;!P.Background = fsc_color('white')
;lineplot,u1,xmdot 
;lineplot,xt,xl
;lineplot,xmr,alog10(j) 

for i=0, n_elements(timesteps) -1 do begin
  print,'model'+strtrim(string(timesteps[i],FORMAT='(I6.6)'),2)+'_T'+strtrim(string(10^xte60[timesteps[i]],FORMAT='(I6.6)'),2)+'_L'+$
               strtrim(string(10^xl60[timesteps[i]],FORMAT='(I7.7)'),2)+'_logg'+strtrim(string(logg60[timesteps[i]],FORMAT='(F5.3)'),2)

end
END