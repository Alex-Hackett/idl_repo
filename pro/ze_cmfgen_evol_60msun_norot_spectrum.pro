;PRO ZE_CMFGEN_EVOL_60MSUN_NOROT_SPECTRUM

;dir='/Users/jgroh/evol_models/Grids2010/wg/'
;model='P060z14S0'
;wgfile=dir+model+'.wg' ;assumes model is in wg directory
;
;timestep_ini=49
;ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60,logg60,vesc60,vinf60,eta_star60,Bmin60,Jdot60,logg_rphot60,rphot60,beq60,beta60,ekin60,model=model,logtcollapse=logtcollapse60
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60,index_varnamey_wgfile,return_valy
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560,return_valz    ;X surface
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760,return_valz    ;Y surface
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860,return_valz    ;C surface
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060,return_valz  ; N surface
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260,return_valz   ; O surface
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660,return_valz   ; Ne surface
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560,return_valz    ;X center
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760,return_valz    ;Y center
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860,return_valz    ;C center
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060,return_valz  ; N center
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260,return_valz   ; O center
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660,return_valz   ; Ne center
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60,return_valz  
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60,index_varnamex_wgfile,return_valx
;ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'qmnc',data_wgfile_cut,qmnc60,index_varnamex_wgfile,return_valx
;
;modelstr='P060z14S0'
;ZE_CMFGEN_SPEC_FIND_AVAILABLE_TIMESTEPS,modelstr,timesteps_available,allobsfinfiles,allobscontfiles ;finds which timesteps have spectra computede in  dir 
;LMIN=900.0
;LMAX=50000.0
;nlambda=400000d0
;all_lambda=dblarr(n_elements(timesteps_available),nlambda)
;all_fluxnorm=dblarr(n_elements(timesteps_available),nlambda)
;all_nlambda_read=dblarr(n_elements(timesteps_available))
;for i=0, n_elements(timesteps_available) -1 do begin
; ZE_CMFGEN_CREATE_OBSNORM,allobsfinfiles[i],allobscontfiles[i],lnorm,fnorm,LMIN=lmin,LMAX=lmax,cnvl=50.0
; all_nlambda_read[i]=n_elements(lnorm)
; print,i,' ',all_nlambda_read[i]
; all_lambda[i,0:all_nlambda_read[i]-1]=lnorm
; all_fluxnorm[i,0:all_nlambda_read[i]-1]=fnorm 
;endfor
;save,filename='/Users/jgroh/temp/P060z14S0_cmfgen_evol_spectra_norm_cnvl50.sav',/all
;;save,filename='/Users/jgroh/temp/P060z14S0_cmfgen_evol_spectra_norm.sav',/all
;STOP

;choose if you want to restore fnorm without convulutoin wor with
restore,'/Users/jgroh/temp/P060z14S0_cmfgen_evol_spectra_norm.sav'
;restore,'/Users/jgroh/temp/P060z14S0_cmfgen_evol_spectra_norm_cnvl50.sav'
!P.Background = fsc_color('white')

;put spectral types so they are also in the table

READCOL,'/Users/jgroh/temp/FIN_NODES_P060z14S0.txt',F='A,F,F,F,A',xtefinnorot60,xlfinnorot60

;finds timestep corresponding to completed FIN_NODES
timestep60norot_array=xtefinnorot60
for i=0, n_elements(xtefinnorot60)-1 do timestep60norot_array[i]=ZE_EVOL_FIND_CLOSEST_TIMESTEP(xtefinnorot60[i],xlfinnorot60[i],xte60,xl60)

timestep60norot_array_wg=timestep60norot_array+timestep_ini
;results of spectral classification using IDL tool:
;ms_sptypes_noclump=['O3III','O3III','O3III','O4III','O5III','O6III','O7.5I','O9I','B0.2--0.5 Ia$^+$','hot LBV','hot LBV','cool LBV','hot LBV','hot LBV']
ms_sptypes=['O3I','O3I','O3I','O4I','O5I','O6I','O7.5I','O9I','B0.2 Ia','B0.5 Ia$^+$','hot LBV','hot LBV','cool LBV','hot LBV','hot LBV']
ms_timesteps=[57,500,1000,1750,2500,3000,3500,3800,3970,4050,4200,4301,4379,4501,4701]
ms_burn=replicate('H-c',n_elements(ms_sptypes))
hshell_sptypes=['hot LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV']
hshell_timesteps=[4717,4723,4729,4730,4731,4732,4734,4737,4738,4739,4741,4744]
hshell_burn=replicate('H-sh',n_elements(hshell_sptypes))
beg_he_burn_sptypes=['cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','WN11h']
beg_he_burn_timesteps=[5215,5328,5344,5375,5404,5425,5460]
beg_he_burn_burn=replicate('He-c, H-sh',n_elements(beg_he_burn_sptypes))
wn_sptypes=['WN8h','WN7h','WN5h','WN2h','WN5h','WN5h','WN5h','WN5h','WN5h','WN5','WN5']
wn_timesteps=[5500,5601,5820,6250,6551,6870,7027,7201,7577,8201,10131]
wn_burn=[replicate('He-c, H-sh',n_elements(wn_timesteps)-1),'He-c']
wcwo_sptypes=['WO4','WC4','WC4','WC4','WO4','WO1','WO1','WO1']
wcwo_timesteps=[11201,12551,14951,18950,21950,22251,22271,23950]
wcwo_burn=['He-c','He-c','He-c','He-c','He-c','He-c','He-sh','end C-c']
Heburn_sptypes=['']
heshell_sptypes=['']
cburn_sptypes=['']
sptypes60norot_array=[ms_sptypes,hshell_sptypes,beg_He_burn_sptypes,wn_sptypes,wcwo_sptypes]
burn60norot_array=[ms_burn,hshell_burn,beg_He_burn_burn,wn_burn,wcwo_burn]

;SELECTED MODELS for broad evolution, Fig. 1 CHANGE NUMBER HERE LATER WHEN OBS FROM MODELS 4731,4732,4744 ARE COMPUTED
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[0,0:all_nlambda_read[0]-1],9.0+all_fluxnorm[0,0:all_nlambda_read[0]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[3,0:all_nlambda_read[3]-1],y2=8.0+all_fluxnorm[3,0:all_nlambda_read[3]-1],linestyle2=0,$
                          x3=all_lambda[7,0:all_nlambda_read[7]-1],y3=7.0+all_fluxnorm[7,0:all_nlambda_read[7]-1],linestyle3=0,$
                          x4=all_lambda[12,0:all_nlambda_read[12]-1],y4=6.0+((all_fluxnorm[12,0:all_nlambda_read[12]-1] - 1.0)/12.0 + 1.0),linestyle4=0,$
                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=7,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=730,bb=800,$
                          xrange=[3700,4920],yrange=[0.4,11],POSITION=[0.11,0.10,0.98,0.98],filename='P060z14S0_selected_1',/rebin,factor1=4.0;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[0,0:all_nlambda_read[0]-1],9.0+all_fluxnorm[0,0:all_nlambda_read[0]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[3,0:all_nlambda_read[3]-1],y2=8.0+all_fluxnorm[3,0:all_nlambda_read[3]-1],linestyle2=0,$
                          x3=all_lambda[7,0:all_nlambda_read[7]-1],y3=7.0+all_fluxnorm[7,0:all_nlambda_read[7]-1],linestyle3=0,$
                          x4=all_lambda[12,0:all_nlambda_read[12]-1],y4=6.0+((all_fluxnorm[12,0:all_nlambda_read[12]-1] - 1.0)/12.0 + 1.0),linestyle4=0,$
                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=7,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
                          xrange=[3700,6800],yrange=[0.4,11],POSITION=[0.08,0.10,0.98,0.98],filename='P060z14S0_selected_2',/rebin,factor1=4.0;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[0,0:all_nlambda_read[0]-1],9.0+all_fluxnorm[0,0:all_nlambda_read[0]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[3,0:all_nlambda_read[3]-1],y2=8.0+all_fluxnorm[3,0:all_nlambda_read[3]-1],linestyle2=0,$
                          x3=all_lambda[7,0:all_nlambda_read[7]-1],y3=7.0+all_fluxnorm[7,0:all_nlambda_read[7]-1],linestyle3=0,$
                          x4=all_lambda[12,0:all_nlambda_read[12]-1],y4=6.0+((all_fluxnorm[12,0:all_nlambda_read[12]-1] - 1.0)/12.0 + 1.0),linestyle4=0,$
                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=7,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
                          xrange=[10000,24000],yrange=[0.4,11],POSITION=[0.08,0.10,0.98,0.98],filename='P060z14S0_selected_NIR_to_cyril',/rebin,factor1=4.0;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0


ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[0,0:all_nlambda_read[0]-1],11.0+all_fluxnorm[0,0:all_nlambda_read[0]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[3,0:all_nlambda_read[3]-1],y2=10.0+all_fluxnorm[3,0:all_nlambda_read[3]-1],linestyle2=0,$
                          x3=all_lambda[7,0:all_nlambda_read[7]-1],y3=9.0+all_fluxnorm[7,0:all_nlambda_read[7]-1],linestyle3=0,$
                          x4=all_lambda[12,0:all_nlambda_read[12]-1],y4=8.0+((all_fluxnorm[12,0:all_nlambda_read[12]-1] - 1.0)/1.0 + 1.0),linestyle4=0,$
                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=6.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/1.0 + 1.0),linestyle5=0,$
                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=5.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/1.0 + 1.0),linestyle6=0,$
                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/20.0 + 1.0),linestyle8=0,$ 
                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=7,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
                          xrange=[1216,2450],yrange=[0.4,13.5],POSITION=[0.08,0.10,0.98,0.98],filename='P060z14S0_selected_3',/rebin,factor1=20.0;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0


;Main Sequence up to model 3800, optical
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[0,0:all_nlambda_read[0]-1],3.5+all_fluxnorm[0,0:all_nlambda_read[0]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[1,0:all_nlambda_read[1]-1],y2=3.0+all_fluxnorm[1,0:all_nlambda_read[1]-1],linestyle2=0,$
                          x3=all_lambda[2,0:all_nlambda_read[2]-1],y3=2.5+all_fluxnorm[2,0:all_nlambda_read[2]-1],linestyle3=0,$
                          x4=all_lambda[3,0:all_nlambda_read[3]-1],y4=2.0+all_fluxnorm[3,0:all_nlambda_read[3]-1],linestyle4=0,$
                          x5=all_lambda[4,0:all_nlambda_read[4]-1],y5=1.5+all_fluxnorm[4,0:all_nlambda_read[4]-1],linestyle5=0,$
                          x6=all_lambda[5,0:all_nlambda_read[5]-1],y6=1.0+all_fluxnorm[5,0:all_nlambda_read[5]-1],linestyle6=0,$
                          x7=all_lambda[6,0:all_nlambda_read[6]-1],y7=0.5+all_fluxnorm[6,0:all_nlambda_read[6]-1],linestyle7=0,$
                          x8=all_lambda[7,0:all_nlambda_read[7]-1],y8=0.0+all_fluxnorm[7,0:all_nlambda_read[7]-1],linestyle8=0,$                          
                          xrange=[4030,4920],yrange=[0.4,5],filename='P060z14S0_ms_spec_1',/rebin,factor1=4.0,aa=800,bb=300;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0

;Main Sequence up to model 4701, optical
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[8,0:all_nlambda_read[8]-1],17.0+all_fluxnorm[8,0:all_nlambda_read[8]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[9,0:all_nlambda_read[9]-1],y2=15.0+all_fluxnorm[9,0:all_nlambda_read[9]-1],linestyle2=0,$
                          x3=all_lambda[10,0:all_nlambda_read[10]-1],y3=13.0+all_fluxnorm[10,0:all_nlambda_read[10]-1],linestyle3=0,$
                          x4=all_lambda[11,0:all_nlambda_read[11]-1],y4=10.0+all_fluxnorm[11,0:all_nlambda_read[11]-1],linestyle4=0,$
                          x5=all_lambda[12,0:all_nlambda_read[12]-1],y5=6.0+all_fluxnorm[12,0:all_nlambda_read[12]-1],linestyle5=0,$
                          x6=all_lambda[13,0:all_nlambda_read[13]-1],y6=3.0+all_fluxnorm[13,0:all_nlambda_read[13]-1],linestyle6=0,$ 
                          x7=all_lambda[14,0:all_nlambda_read[14]-1],y7=0.0+all_fluxnorm[14,0:all_nlambda_read[14]-1],linestyle7=0,$                                                 
                          xrange=[4030,4920],yrange=[0,20],filename='P060z14S0_ms_spec_2',/rebin,factor1=4.0,aa=800,bb=300;,filename='P060z14S0_ms_spec_1';,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0


;Hshell burning up to model 4741, optical + Halpha
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[15,0:all_nlambda_read[15]-1],21.0+all_fluxnorm[15,0:all_nlambda_read[15]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[16,0:all_nlambda_read[16]-1],y2=18.0+all_fluxnorm[16,0:all_nlambda_read[16]-1],linestyle2=0,$
                          x3=all_lambda[17,0:all_nlambda_read[17]-1],y3=15.0+all_fluxnorm[17,0:all_nlambda_read[17]-1],linestyle3=0,$
                          x4=all_lambda[18,0:all_nlambda_read[18]-1],y4=12.0+all_fluxnorm[18,0:all_nlambda_read[18]-1],linestyle4=0,$
                          x5=all_lambda[19,0:all_nlambda_read[19]-1],y5=9.0+all_fluxnorm[19,0:all_nlambda_read[19]-1],linestyle5=0,$
                          x6=all_lambda[22,0:all_nlambda_read[22]-1],y6=6.0+all_fluxnorm[22,0:all_nlambda_read[22]-1],linestyle6=0,$    
                          x7=all_lambda[23,0:all_nlambda_read[23]-1],y7=3.0+all_fluxnorm[23,0:all_nlambda_read[23]-1],linestyle7=0,$
                          x8=all_lambda[26,0:all_nlambda_read[26]-1],y8=0.0+all_fluxnorm[26,0:all_nlambda_read[26]-1],linestyle8=0,$                      
                          xrange=[4030,6720],yrange=[0,25],filename='P060z14S0_hshell_spec_1',/rebin,factor1=20.0,aa=800,bb=300;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0

;He-core burning models 5215 through 5500 (i.e. 1/3)
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[27,0:all_nlambda_read[27]-1],27.0+all_fluxnorm[27,0:all_nlambda_read[27]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[28,0:all_nlambda_read[28]-1],y2=23.0+all_fluxnorm[28,0:all_nlambda_read[28]-1],linestyle2=0,$
                          x3=all_lambda[29,0:all_nlambda_read[29]-1],y3=19.0+all_fluxnorm[29,0:all_nlambda_read[29]-1],linestyle3=0,$
                          x4=all_lambda[30,0:all_nlambda_read[30]-1],y4=15.0+all_fluxnorm[30,0:all_nlambda_read[30]-1],linestyle4=0,$
                          x5=all_lambda[31,0:all_nlambda_read[31]-1],y5=11.0+all_fluxnorm[31,0:all_nlambda_read[31]-1],linestyle5=0,$
                          x6=all_lambda[32,0:all_nlambda_read[32]-1],y6=7.0+all_fluxnorm[32,0:all_nlambda_read[32]-1],linestyle6=0,$    
                          x7=all_lambda[33,0:all_nlambda_read[33]-1],y7=3.0+all_fluxnorm[33,0:all_nlambda_read[33]-1],linestyle7=0,$
                          x8=all_lambda[34,0:all_nlambda_read[34]-1],y8=0.0+all_fluxnorm[34,0:all_nlambda_read[34]-1],linestyle8=0,$                      
                          xrange=[3700,6050],yrange=[0,33],filename='P060z14S0_heburn_spec_1',/rebin,factor1=20.0,aa=800,bb=300;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0

;He-core burning models 5601 through 7577 (2/3)
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[35,0:all_nlambda_read[35]-1],27.0+all_fluxnorm[35,0:all_nlambda_read[35]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[36,0:all_nlambda_read[36]-1],y2=23.0+all_fluxnorm[36,0:all_nlambda_read[36]-1],linestyle2=0,$
                          x3=all_lambda[37,0:all_nlambda_read[37]-1],y3=19.0+all_fluxnorm[37,0:all_nlambda_read[37]-1],linestyle3=0,$
                          x4=all_lambda[38,0:all_nlambda_read[38]-1],y4=15.0+all_fluxnorm[38,0:all_nlambda_read[38]-1],linestyle4=0,$
                          x5=all_lambda[39,0:all_nlambda_read[39]-1],y5=11.0+all_fluxnorm[39,0:all_nlambda_read[39]-1],linestyle5=0,$
                          x6=all_lambda[40,0:all_nlambda_read[40]-1],y6=7.0+all_fluxnorm[40,0:all_nlambda_read[40]-1],linestyle6=0,$    
                          x7=all_lambda[41,0:all_nlambda_read[41]-1],y7=3.0+all_fluxnorm[41,0:all_nlambda_read[41]-1],linestyle7=0,$
                          x8=all_lambda[42,0:all_nlambda_read[42]-1],y8=0.0+all_fluxnorm[42,0:all_nlambda_read[42]-1],linestyle8=0,$                      
                          xrange=[3700,6050],yrange=[0,33],filename='P060z14S0_heburn_spec_2',/rebin,factor1=10.0,aa=800,bb=300;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0

;He-core burning models 8201 through advanced stage 23950  (3/3)
;allfluxnorm being modified here to log scale
all_fluxnorm=alog10(all_fluxnorm)
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[43,0:all_nlambda_read[43]-1],19.0+all_fluxnorm[43,0:all_nlambda_read[43]-1],'Wavelength (Angstrom)', 'Log Normalized Flux','',$
                          x2=all_lambda[44,0:all_nlambda_read[44]-1],y2=17.0+all_fluxnorm[44,0:all_nlambda_read[44]-1],linestyle2=0,$
                          x3=all_lambda[45,0:all_nlambda_read[45]-1],y3=15.0+all_fluxnorm[45,0:all_nlambda_read[45]-1],linestyle3=0,$
                          x4=all_lambda[46,0:all_nlambda_read[46]-1],y4=13.0+all_fluxnorm[46,0:all_nlambda_read[46]-1],linestyle4=0,$
                          x5=all_lambda[47,0:all_nlambda_read[47]-1],y5=11.0+all_fluxnorm[47,0:all_nlambda_read[47]-1],linestyle5=0,$
                          x6=all_lambda[48,0:all_nlambda_read[48]-1],y6=9.0+all_fluxnorm[48,0:all_nlambda_read[48]-1],linestyle6=0,$    
                          x7=all_lambda[49,0:all_nlambda_read[49]-1],y7=7.0+all_fluxnorm[49,0:all_nlambda_read[49]-1],linestyle7=0,$
                          x8=all_lambda[50,0:all_nlambda_read[50]-1],y8=5.0+all_fluxnorm[50,0:all_nlambda_read[50]-1],linestyle8=0,$  
                          x9=all_lambda[51,0:all_nlambda_read[51]-1],y9=3.0+all_fluxnorm[51,0:all_nlambda_read[51]-1],linestyle9=0,$ 
                          x10=all_lambda[52,0:all_nlambda_read[52]-1],y10=1.0+all_fluxnorm[52,0:all_nlambda_read[52]-1],linestyle_10=0,$                                              
                          xrange=[3700,6050],yrange=[0,22],filename='P060z14S0_heburn_spec_3',/rebin,factor1=10.0,aa=800,bb=300;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0

;back to linaer scaling
all_fluxnorm=10^(all_fluxnorm)

;Advanced stages models 22271 and 23950 (22251 is still missing)

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[45,0:all_nlambda_read[45]-1],10.0+all_fluxnorm[45,0:all_nlambda_read[45]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[46,0:all_nlambda_read[46]-1],y2=0.0+all_fluxnorm[46,0:all_nlambda_read[46]-1],linestyle2=0,$                
                          xrange=[3700,6050],yrange=[0,25],filename='P060z14S0_advstage_spec_1',/rebin,factor1=10.0,aa=800,bb=300;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0

;WITH LINE IDS
cmfgendir='/Users/jgroh/ze_models/grid_P060z14S0/'

ewdata=cmfgendir+'auxiliary/clump0d1/model2500_T39375_L645563_logg_3d6925_Fe_OK_f0d1/obscont/ewdata_fin_ed.txt'  
ZE_CMFGEN_READ_EWDATA,ewdata,lambdac,cont,ew,sob,id
;Main Sequence up to model 3800, optical

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[0,0:all_nlambda_read[0]-1],7.0+all_fluxnorm[0,0:all_nlambda_read[0]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[1,0:all_nlambda_read[1]-1],y2=6.0+all_fluxnorm[1,0:all_nlambda_read[1]-1],linestyle2=0,$
                          x3=all_lambda[2,0:all_nlambda_read[2]-1],y3=5.0+all_fluxnorm[2,0:all_nlambda_read[2]-1],linestyle3=0,$
                          x4=all_lambda[3,0:all_nlambda_read[3]-1],y4=4.0+all_fluxnorm[3,0:all_nlambda_read[3]-1],linestyle4=0,$
                          x5=all_lambda[4,0:all_nlambda_read[4]-1],y5=3.0+all_fluxnorm[4,0:all_nlambda_read[4]-1],linestyle5=0,$
                          x6=all_lambda[5,0:all_nlambda_read[5]-1],y6=2.0+all_fluxnorm[5,0:all_nlambda_read[5]-1],linestyle6=0,$
                          x7=all_lambda[6,0:all_nlambda_read[6]-1],y7=1.0+all_fluxnorm[6,0:all_nlambda_read[6]-1],linestyle7=0,$
                          x8=all_lambda[7,0:all_nlambda_read[7]-1],y8=0.0+all_fluxnorm[7,0:all_nlambda_read[7]-1],linestyle8=0,$                          
                          xrange=[1200,1750],yrange=[0.4,10.5],filename='P060z14S0_ms_spec_1_id0',/rebin,factor1=4.0,pthick=4.0,aa=800,bb=300,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=1.01,id_ypos=9.2

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[0,0:all_nlambda_read[0]-1],7.0+all_fluxnorm[0,0:all_nlambda_read[0]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[1,0:all_nlambda_read[1]-1],y2=6.0+all_fluxnorm[1,0:all_nlambda_read[1]-1],linestyle2=0,$
                          x3=all_lambda[2,0:all_nlambda_read[2]-1],y3=5.0+all_fluxnorm[2,0:all_nlambda_read[2]-1],linestyle3=0,$
                          x4=all_lambda[3,0:all_nlambda_read[3]-1],y4=4.0+all_fluxnorm[3,0:all_nlambda_read[3]-1],linestyle4=0,$
                          x5=all_lambda[4,0:all_nlambda_read[4]-1],y5=3.0+all_fluxnorm[4,0:all_nlambda_read[4]-1],linestyle5=0,$
                          x6=all_lambda[5,0:all_nlambda_read[5]-1],y6=2.0+all_fluxnorm[5,0:all_nlambda_read[5]-1],linestyle6=0,$
                          x7=all_lambda[6,0:all_nlambda_read[6]-1],y7=1.0+all_fluxnorm[6,0:all_nlambda_read[6]-1],linestyle7=0,$
                          x8=all_lambda[7,0:all_nlambda_read[7]-1],y8=0.0+all_fluxnorm[7,0:all_nlambda_read[7]-1],linestyle8=0,$                          
                          xrange=[900,1200],yrange=[0.4,10.5],filename='P060z14S0_ms_spec_1_id01',/rebin,factor1=4.0,pthick=4.0,aa=800,bb=300,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=1.01,id_ypos=9.2

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[0,0:all_nlambda_read[0]-1],7.0+all_fluxnorm[0,0:all_nlambda_read[0]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[1,0:all_nlambda_read[1]-1],y2=6.0+all_fluxnorm[1,0:all_nlambda_read[1]-1],linestyle2=0,$
                          x3=all_lambda[2,0:all_nlambda_read[2]-1],y3=5.0+all_fluxnorm[2,0:all_nlambda_read[2]-1],linestyle3=0,$
                          x4=all_lambda[3,0:all_nlambda_read[3]-1],y4=4.0+all_fluxnorm[3,0:all_nlambda_read[3]-1],linestyle4=0,$
                          x5=all_lambda[4,0:all_nlambda_read[4]-1],y5=3.0+all_fluxnorm[4,0:all_nlambda_read[4]-1],linestyle5=0,$
                          x6=all_lambda[5,0:all_nlambda_read[5]-1],y6=2.0+all_fluxnorm[5,0:all_nlambda_read[5]-1],linestyle6=0,$
                          x7=all_lambda[6,0:all_nlambda_read[6]-1],y7=1.0+all_fluxnorm[6,0:all_nlambda_read[6]-1],linestyle7=0,$
                          x8=all_lambda[7,0:all_nlambda_read[7]-1],y8=0.0+all_fluxnorm[7,0:all_nlambda_read[7]-1],linestyle8=0,$                          
                          xrange=[3000,4000],yrange=[0.4,10.5],filename='P060z14S0_ms_spec_1_id3000',/rebin,factor1=4.0,pthick=4.0,aa=800,bb=300,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=1.01,id_ypos=9.2


ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[0,0:all_nlambda_read[0]-1],3.5+all_fluxnorm[0,0:all_nlambda_read[0]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[1,0:all_nlambda_read[1]-1],y2=3.0+all_fluxnorm[1,0:all_nlambda_read[1]-1],linestyle2=0,$
                          x3=all_lambda[2,0:all_nlambda_read[2]-1],y3=2.5+all_fluxnorm[2,0:all_nlambda_read[2]-1],linestyle3=0,$
                          x4=all_lambda[3,0:all_nlambda_read[3]-1],y4=2.0+all_fluxnorm[3,0:all_nlambda_read[3]-1],linestyle4=0,$
                          x5=all_lambda[4,0:all_nlambda_read[4]-1],y5=1.5+all_fluxnorm[4,0:all_nlambda_read[4]-1],linestyle5=0,$
                          x6=all_lambda[5,0:all_nlambda_read[5]-1],y6=1.0+all_fluxnorm[5,0:all_nlambda_read[5]-1],linestyle6=0,$
                          x7=all_lambda[6,0:all_nlambda_read[6]-1],y7=0.5+all_fluxnorm[6,0:all_nlambda_read[6]-1],linestyle7=0,$
                          x8=all_lambda[7,0:all_nlambda_read[7]-1],y8=0.0+all_fluxnorm[7,0:all_nlambda_read[7]-1],linestyle8=0,$                          
                          xrange=[4030,4400],yrange=[0.4,6],filename='P060z14S0_ms_spec_1_id4000',/rebin,factor1=4.0,pthick=8.0,aa=800,bb=300,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.01,id_ypos=5.2

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[0,0:all_nlambda_read[0]-1],3.5+all_fluxnorm[0,0:all_nlambda_read[0]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[1,0:all_nlambda_read[1]-1],y2=3.0+all_fluxnorm[1,0:all_nlambda_read[1]-1],linestyle2=0,$
                          x3=all_lambda[2,0:all_nlambda_read[2]-1],y3=2.5+all_fluxnorm[2,0:all_nlambda_read[2]-1],linestyle3=0,$
                          x4=all_lambda[3,0:all_nlambda_read[3]-1],y4=2.0+all_fluxnorm[3,0:all_nlambda_read[3]-1],linestyle4=0,$
                          x5=all_lambda[4,0:all_nlambda_read[4]-1],y5=1.5+all_fluxnorm[4,0:all_nlambda_read[4]-1],linestyle5=0,$
                          x6=all_lambda[5,0:all_nlambda_read[5]-1],y6=1.0+all_fluxnorm[5,0:all_nlambda_read[5]-1],linestyle6=0,$
                          x7=all_lambda[6,0:all_nlambda_read[6]-1],y7=0.5+all_fluxnorm[6,0:all_nlambda_read[6]-1],linestyle7=0,$
                          x8=all_lambda[7,0:all_nlambda_read[7]-1],y8=0.0+all_fluxnorm[7,0:all_nlambda_read[7]-1],linestyle8=0,$                          
                          xrange=[4400,4900],yrange=[0.4,6],filename='P060z14S0_ms_spec_1_id4400',/rebin,factor1=4.0,pthick=8.0,aa=800,bb=300,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.01,id_ypos=5.2

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[0,0:all_nlambda_read[0]-1],7.0+all_fluxnorm[0,0:all_nlambda_read[0]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[1,0:all_nlambda_read[1]-1],y2=6.0+all_fluxnorm[1,0:all_nlambda_read[1]-1],linestyle2=0,$
                          x3=all_lambda[2,0:all_nlambda_read[2]-1],y3=5.0+all_fluxnorm[2,0:all_nlambda_read[2]-1],linestyle3=0,$
                          x4=all_lambda[3,0:all_nlambda_read[3]-1],y4=4.0+all_fluxnorm[3,0:all_nlambda_read[3]-1],linestyle4=0,$
                          x5=all_lambda[4,0:all_nlambda_read[4]-1],y5=3.0+all_fluxnorm[4,0:all_nlambda_read[4]-1],linestyle5=0,$
                          x6=all_lambda[5,0:all_nlambda_read[5]-1],y6=2.0+all_fluxnorm[5,0:all_nlambda_read[5]-1],linestyle6=0,$
                          x7=all_lambda[6,0:all_nlambda_read[6]-1],y7=1.0+all_fluxnorm[6,0:all_nlambda_read[6]-1],linestyle7=0,$
                          x8=all_lambda[7,0:all_nlambda_read[7]-1],y8=0.0+all_fluxnorm[7,0:all_nlambda_read[7]-1],linestyle8=0,$                          
                          xrange=[4900,6000],yrange=[0.4,10.5],filename='P060z14S0_ms_spec_1_id0',/rebin,factor1=4.0,pthick=4.0,aa=800,bb=300,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=1.01,id_ypos=9.2

ewdata=cmfgendir+'auxiliary/clump0d1/model2500_T39375_L645563_logg_3d6925_Fe_OK_f0d1/obscont/ewdata_fin_ed.txt'  
ZE_CMFGEN_READ_EWDATA,ewdata,lambdac,cont,ew,sob,id
elem='He2'
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[0,0:all_nlambda_read[0]-1],9.0+all_fluxnorm[0,0:all_nlambda_read[0]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[3,0:all_nlambda_read[3]-1],y2=8.0+all_fluxnorm[3,0:all_nlambda_read[3]-1],linestyle2=0,$
                          x3=all_lambda[7,0:all_nlambda_read[7]-1],y3=7.0+all_fluxnorm[7,0:all_nlambda_read[7]-1],linestyle3=0,$
                          x4=all_lambda[12,0:all_nlambda_read[12]-1],y4=6.0+((all_fluxnorm[12,0:all_nlambda_read[12]-1] - 1.0)/12.0 + 1.0),linestyle4=0,$
                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=7,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
                          xrange=[3700,6800],yrange=[0.4,11.5],POSITION=[0.08,0.10,0.98,0.98],filename='P060z14S0_selected_2id';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem

ewdata=cmfgendir+'auxiliary/clump0d1/model2500_T39375_L645563_logg_3d6925_Fe_OK_f0d1/obscont/ewdata_fin_ed.txt'  
ewdata=cmfgendir+'auxiliary/clump0d1/model004050_T024443_L0759715_logg2.769/obscont/ewdata_fin'
ewdata=cmfgendir+'model8201_T122874_L682455_logg5d294/obscont/ewdata_fin' ;WN
;ewdata=cmfgendir+'model14951_T136008_L434538_logg5d51_hydro/obscont/ewdata_fin';WC
;ewdata=cmfgendir+'model022271_T182276_L0390822_logg5.940/obscont/ewdata_fin' ;WO
ZE_CMFGEN_READ_EWDATA,ewdata,lambdac,cont,ew,sob,id
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[0,0:all_nlambda_read[0]-1],11.0+all_fluxnorm[0,0:all_nlambda_read[0]-1],'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[3,0:all_nlambda_read[3]-1],y2=10.0+all_fluxnorm[3,0:all_nlambda_read[3]-1],linestyle2=0,$
                          x3=all_lambda[7,0:all_nlambda_read[7]-1],y3=9.0+all_fluxnorm[7,0:all_nlambda_read[7]-1],linestyle3=0,$
                          x4=all_lambda[12,0:all_nlambda_read[12]-1],y4=8.0+((all_fluxnorm[12,0:all_nlambda_read[12]-1] - 1.0)/1.0 + 1.0),linestyle4=0,$
                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=6.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/5.0 + 1.0),linestyle5=0,$
                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=5.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/5.0 + 1.0),linestyle6=0,$
                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/20.0 + 1.0),linestyle8=0,$ 
                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=7,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
                          xrange=[1216,2450],yrange=[0.4,13.5],POSITION=[0.08,0.10,0.98,0.98],filename='P060z14S0_selected_3id';,/rebin,factor1=20.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=20.91,id_ypos=12.5,size_id_text=1.0,elem=elem


;;reads WN11h AG CAr obs from Jan 89 (Stahl+2001, make sure with him)
;ZE_READ_SPECTRA_FITS,'/Users/jgroh/espectros/agcar_stahl/caspec/rjan89.fits',lagcar89,fagcar89
;
;;read ewdata
;ewdata='/Users/jgroh/ze_models/SN_progenitor_grid/P025z14S0_model030888_T027115_L0239316_logg2.663/obscont/ewdata_ew'  
;ZE_CMFGEN_READ_EWDATA,ewdata,lambdac,cont,ew,sob,id
;;add He II 4686
;;ew=[ew,2] & lambdac=[lambdac,4686.5] & id=[id,'HeII']
;
; 
;;;only non-rotating with 25 Msun (WN11h)
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,l12,f12,'Wavelength (Angstrom)', 'Normalized Flux',x2=lagcar89,y2=fagcar89+2,$
;                          xrange=[4000,4900],yrange=[0,9],/rebin,factor1=5,factor2=4.0,linestyle2=2,$
;                          id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.1 ,id_ypos=7.3,filename='25_nonrot_wn11h',id_xoffset=-0.000
;
;;read observed spectrum WN 7-8
;file='WR123.3320-4810'
;ZE_READ_SPECTRA_WN_ATLAS_HAMANN,file,lwr123blue,fwr123blue
;file='WR123.4550-6050'
;ZE_READ_SPECTRA_WN_ATLAS_HAMANN,file,lwr123red,fwr123red
;file='WR120.3320-4810'
;ZE_READ_SPECTRA_WN_ATLAS_HAMANN,file,lwr120blue,fwr120blue
;file='WR120.4550-6050'
;ZE_READ_SPECTRA_WN_ATLAS_HAMANN,file,lwr120red,fwr120red
;file='WR091.3770-9055'
;ZE_READ_SPECTRA_WN_ATLAS_HAMANN,file,lwr91,fwr91
;
;;merge obs files
;dummy=min(abs(lwr123blue - 4732.0),countblue)
;dummy=min(abs(lwr123red - 4732.0),countred)
;lwr123=[lwr123blue[0:countblue],lwr123red[countred+1:n_elements(lwr123red)-1]]
;fwr123=[fwr123blue[0:countblue],fwr123red[countred+1:n_elements(fwr123red)-1]]
;dummy=min(abs(lwr120blue - 4732.0),countblue)
;dummy=min(abs(lwr120red - 4732.0),countred)
;lwr120=[lwr120blue[0:countblue],lwr120red[countred+1:n_elements(lwr120red)-1]]
;fwr120=[fwr120blue[0:countblue],fwr120red[countred+1:n_elements(fwr120red)-1]]
;
;;read ewdata
;ewdata='/Users/jgroh/ze_models/SN_progenitor_grid/P032z14S0_model029922_T045794_L0367647_logg3.507/obscont/ewdata_fin'  
;ZE_CMFGEN_READ_EWDATA,ewdata,lambdac,cont,ew,sob,id
;
;;only non-rotating between 32 and  40 Msun (i.e. WN)
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,l8,f8,'Wavelength (Angstrom)', 'Normalized Flux',x2=l10,y2=f10+4,$
;                          x3=lwr120,y3=fwr120+8,x4=lwr123,y4=fwr123+12,xrange=[3700,6030],yrange=[0,19],/rebin,factor1=25,factor3=1.0,factor4=1.0,linestyle3=2,linestyle4=2,$
;                          id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=5.0 ,id_ypos=16.3,filename='32_40_nonrot_wn'
;
;ZE_READ_SPECTRA_FITS,'/Users/jgroh/espectros/wo/wo_cutn.fits',lwo93b,fwo93b
;
;ewdata='/Users/jgroh/ze_models/SN_progenitor_grid/P032z14S4_model075198_T181508_L0337150_logg5.904/obscont/ewdata_fin'
;ZE_CMFGEN_READ_EWDATA,ewdata,lambdac,cont,ew,sob,id
;
;;only non-rotating between 60 and 120 Msun (i.e. WO)
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,l2,f2,'Wavelength (Angstrom)', 'Normalized Flux','',x2=l4,y2=f4+15,$
;                          x3=l6,y3=f6+18,x4=lwo93b,y4=fwo93b+26,x5=l15,y5=f15+18,x6=l16,y6=f16+21,linestyle4=2,linestyle5=3,xrange=[3500,8000],yrange=[0,46],$
;                          /rebin,factor1=10,factor4=2.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=50.0,id_ypos=39.5,filename='50_120_nonrot_wo'
;
;ewdata='/Users/jgroh/ze_models/SN_progenitor_grid/P020z14S4_model049869_T020358_L0191044_logg2.200/obscont/ewdata_fin_ed'  
;ZE_CMFGEN_READ_EWDATA,ewdata,lambdac,cont,ew,sob,id
;
;;obs AG CAr
;obsdir='/Users/jgroh/espectros/agcar/'
;;ZE_READ_SPECTRA_COL_VEC,obsdir+'agc01apr12_35a90.txt',l01apr,f01apr,nrec
;;ZE_READ_SPECTRA_COL_VEC,obsdir+'agc02jul04_36a92n.txt',l02jul,f02jul,nrec
;;ZE_READ_SPECTRA_COL_VEC,obsdir+'agc02mar17.txt',l02mar,f02mar,nrec
;;ze_evol_rebin_xyz,l02jul,f02jul,l02jul r,f02julr,factor=20.0
;restore,'/Users/jgroh/espectros/agcar/agc02jul03_36a92n.sav'
;
;;only rotating between 20 and 25 Msun (LBVs)
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,l11,f11,'Wavelength (Angstrom)', 'Normalized Flux','',x2=l13,y2=f13+7,x3=l02jul,y3=f02jul+14,linestyle3=2,$
;                          xrange=[4000,6750],yrange=[0,25],/rebin,factor1=20.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0,filename='20_25_rot_lbv'
;
;
;;reads WN11h AG CAr obs from Jan 89 (Stahl+2001, make sure with him)
;ZE_READ_SPECTRA_FITS,'/Users/jgroh/espectros/agcar_stahl/caspec/rjan89.fits',lagcar89,fagcar89
;
;;read ewdata
;ewdata='/Users/jgroh/ze_models/SN_progenitor_grid/P025z14S0_model030888_T027115_L0239316_logg2.663/obscont/ewdata_ew' 
;ZE_CMFGEN_READ_EWDATA,ewdata,lambdac,cont,ew,sob,id
;;add He II 4686
;;ew=[ew,2] & lambdac=[lambdac,4686.5] & id=[id,'HeII']
;
; 
;;;only rotating with 27 Msun (WN11h)
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,l17,f17,'Wavelength (Angstrom)', 'Normalized Flux',x2=lagcar89,y2=fagcar89+2,$
;                          xrange=[4000,4900],yrange=[0,9],/rebin,factor1=5,factor2=4.0,linestyle2=2,$
;                          id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.1 ,id_ypos=7.3,filename='28_rot_wn11h',id_xoffset=-0.000
;
;
;
;ewdata='/Users/jgroh/ze_models/SN_progenitor_grid/P032z14S4_model075198_T181508_L0337150_logg5.904/obscont/ewdata_fin'
;ZE_CMFGEN_READ_EWDATA,ewdata,lambdac,cont,ew,sob,id
;
;;only rotating between 32 and 120 Msun (i.e. WO)
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,l1,f1,'Wavelength (Angstrom)', 'Normalized Flux','',x2=l3,y2=f3+4,linestyle6=2,$
;                          x3=l5,y3=f5+8,x4=l7,y4=f7+12,x5=l9,y5=f9+16,x6=lwo93b,y6=fwo93b+26,xrange=[3500,8000],yrange=[0,46],$
;                          /rebin,factor1=10,factor4=2.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=50.0,id_ypos=39.5,filename='32_120_rot_wo'   
;
;;doing other wavelength for Appendix
;
;;only rotating between 20 and 25 Msun (LBVs)
;ewdata='/Users/jgroh/ze_models/SN_progenitor_grid/P020z14S4_model049869_T020358_L0191044_logg2.200/obscont/ewdata_fin_ed'  
;ZE_CMFGEN_READ_EWDATA,ewdata,lambdac,cont,ew,sob,id
;ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,l11,f11,'Wavelength (Angstrom)', 'Normalized Flux','',x2=l13,y2=f13+2,$
;                          xrange=[6750,9000],yrange=[-1,7],/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.6,id_ypos=5.0,filename='20_25_rot_lbv_fuv'
;




END