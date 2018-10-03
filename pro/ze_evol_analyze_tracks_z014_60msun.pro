;PRO ZE_EVOL_ANALYZE_TRACKS_Z014_60Msun
;analyze and plot tracks for metalicity Z=0.014 60 Msun for paper 
sun='!D!9n!3!N'

dir='/Users/jgroh/evol_models/Grids2010/wg/'

model='P060z14S0'
wgfile=dir+model+'.wg' ;assumes model is in wg directory

timestep_ini=49
ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,/reload,timestep_ini=timestep_ini
ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60,logg60,vesc60,vinf60,eta_star60,Bmin60,Jdot60,logg_rphot60,rphot60,beq60,beta60,ekin60,teffjump160,teffjump260,model=model,logtcollapse=logtcollapse60
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

ZE_EVOL_COMPUTE_BURNING_PHASES,model,tstarth=tstarth,tendh=tendh,modelnumber_starth=modelnumber_starth,modelnumber_endh=modelnumber_endh,tauh=tauh,$
                                    tstart_he=tstart_he,tend_he=tend_he,modelnumber_start_he=modelnumber_start_he,modelnumber_end_he=modelnumber_end_he,tau_he=tau_he,$
                                    tstartc=tstartc,tendc=tendc,modelnumber_startc=modelnumber_startc,modelnumber_endc=modelnumber_endc,tauc=tauc,$
                                    tstarto=tstarto,tendo=tendo,modelnumber_starto=modelnumber_starto,modelnumber_endo=modelnumber_endo,tauo=tauo,$
                                    tstartne=tstartne,tendne=tendne,modelnumber_startne=modelnumber_startne,modelnumber_endne=modelnumber_endne,taune=taune


;modelnumber_starth=modelnumber_starth+timestep_ini
;modelnumber_endh=modelnumber_endh+timestep_ini
;modelnumber_start_he=modelnumber_start_he+timestep_ini
;modelnumber_end_he=modelnumber_end_he+timestep_ini
;modelnumber_startc=modelnumber_startc+timestep_ini
;modelnumber_endc=modelnumber_endc+timestep_ini
;modelnumber_starto=modelnumber_starto+timestep_ini
;modelnumber_endo=modelnumber_endo+timestep_ini
;modelnumber_startne=modelnumber_startne+timestep_ini
;modelnumber_endne=modelnumber_endne+timestep_ini


READCOL,'/Users/jgroh/temp/FIN_NODES_P060z14S0.txt',F='A,F,F,F,A',xtefinnorot60,xlfinnorot60

;finds timestep corresponding to completed FIN_NODES
timestep60norot_array=xtefinnorot60
for i=0, n_elements(xtefinnorot60)-1 do timestep60norot_array[i]=ZE_EVOL_FIND_CLOSEST_TIMESTEP(xtefinnorot60[i],xlfinnorot60[i],xte60,xl60)

;run evosolL to recompute StrucData, .l, and .v files for all FIN NODES 
; OK ALREADY DONE, TAKES 7 min to run for all timesteps; readoing because have to add timestep_ini to timestep, to match computed timesteps and modelled timesteps
;for i=0, n_elements(timestep60norot_array)-1 DO ZE_EVOL_RESTART_MODEL,'P060z14S0',timestep60norot_array[i]+timestep_ini,/keep_only_timestep

timestep60norot_array_wg=timestep60norot_array+timestep_ini
;results of spectral classification using IDL tool:
;ms_sptypes_noclump=['O3III','O3III','O3III','O4III','O5III','O6III','O7.5I','O9I','B0.2--0.5 Ia$^+$','hot LBV','hot LBV','cool LBV','hot LBV','hot LBV']
;ms_sptypes=['O3I','O3I','O3I','O4I','O5I','O6I','O7.5I','O9I','B0.2 Ia','B0.5 Ia$^+$','hot LBV','hot LBV','cool LBV','hot LBV','hot LBV']
ms_sptypes=['O3If$^*$c','O3If$^*$c','O3If$^*$c','O4If$^*$c','O5Ifc','O6Iafc','O7.5Iafc','O9Iab','B0.2 Ia','B0.5 Ia$^+$','hot LBV','hot LBV','cool LBV','hot LBV','hot LBV']
ms_timesteps=[57,500,1000,1750,2500,3000,3500,3800,3970,4050,4200,4301,4379,4501,4701]
ms_burn=replicate('H-c',n_elements(ms_sptypes))
hshell_sptypes=['hot LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV']
hshell_timesteps=[4717,4723,4729,4730,4731,4732,4734,4737,4738,4739,4741,4744]
hshell_burn=replicate('H-sh',n_elements(hshell_sptypes))
beg_he_burn_sptypes=['cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','cool LBV','WN11(h)']
beg_he_burn_timesteps=[5215,5328,5344,5375,5404,5425,5460]
beg_he_burn_burn=replicate('He-c+H-sh',n_elements(beg_he_burn_sptypes))
wn_sptypes=['WN8(h)','WN7(h)','WN5(h)','WN2(h)','WN5(h)','WN5(h)','WN5(h)','WN5(h)','WN5(h)','WN5','WN5']
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

end_stages_ms_time=[0,1.44,2.10,2.57,2.89,3.11,3.25] ;done up to O9 I
duration_stages_ms_time=dblarr(n_elements(end_stages_ms_time))
for i=0, n_elements(end_stages_ms_time) -2 do duration_stages_ms_time[i]=end_stages_ms_time[i+1]-end_stages_ms_time[i]
;tim=[ms_timesteps,hshell_timesteps,beg_He_burn_timesteps,wn_timesteps,wcwo_timesteps]
;Model_P060z14S0_timestep_5500 WN8
;Model_P060z14S0_timestep_5601 WN7
;Model_P060z14S0_timestep_5820 WN5
;Model_P060z14S0_timestep_6250 WN2
;Model_P060z14S0_timestep_6551 WN5
;Model_P060z14S0_timestep_6870 WN5
;Model_P060z14S0_timestep_7027 WN5
;Model_P060z14S0_timestep_7201 WN5
;Model_P060z14S0_timestep_7577 WN5
;Model_P060z14S0_timestep_8201 WN5
;Model_P060z14S0_timestep_10131 WN5
;Model_P060z14S0_timestep_11201: WO1 2nd_crit WO4
;Model_P060z14S0_timestep_12551: WC4 2nd_crit WC5
;Model_P060z14S0_timestep_14951: WC4 2nd_crit WC4
;Model_P060z14S0_timestep_18950: WC4 2nd_crit WC4
;Model_P060z14S0_timestep_21950: WO4 2nd_crit WO4
;Model_P060z14S0_timestep_22271: WO3 2nd_crit WO3
;Model_P060z14S0_timestep_23950: WO1 2nd_crit WO1-2

;selected timesteps to discuss in BROAD EVOLUTION part of the PAPER
selected_timestepsnorot60=[0,1750,3800,4379,4701,5215,5820,10141,14454,22271,22337,24073]

;HR diagram for non rotating 60 Msun model
label='60 Msun, Z=0.014'    
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte60,xl60,'Log Temperature (K)','Log Luminosity (Lsun)',label+', vrot/vcrit=0.0',$
                                xrange=[5.5,3.70],yrange=[5.4,6.1],xreverse=0,_EXTRA=extra,rebin=1,factor=3.0, pointsx2=xtefinnorot60,pointsy2=xlfinnorot60,$
                                psympoints2=4,symcolorpoints2='red',symsizepoints2=3,labeldatapoints2=timestep60norot_array

;Age for non rotating 60 Msun model
label='60 Msun, Z=0.014'    
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160,xte60,'Age (years)','Log Temperature (K)',label+', vrot/vcrit=0.00',$
                                xreverse=0,_EXTRA=extra,rebin=1,factor=3.0, pointsx2=u160[timestep60norot_array],pointsy2=xte60[timestep60norot_array],$
                                psympoints2=4,symcolorpoints2='red',symsizepoints2=3,labeldatapoints2=timestep60norot_array


;obtain all quantities from MOD_SUM FILE and sort according to increasing timestep; at the moment sorting only lstar, tstar,teff,and xn
dir='/Users/jgroh/ze_models/grid_P060z14S0/modsum'
ZE_CMFGEN_PARSE_ALL_MOD_SUM_FROM_DIR,dir,lstar_array,tstar_array,teff_array,rstar_array,rphot_array,mdot_array,vinf1_array,xn_array,grid_info_array,habund_array,heabund_array,cabund_array,nabund_array,oabund_array,feabund_array
timestep_cmfgen=fltarr(n_elements(lstar_array))
for i=0, n_elements(timestep_cmfgen) -1 do  timestep_cmfgen[i]=float(strmid(xn_array[i],strpos(xn_array[i],'model')+5,strpos(xn_array[i],'_T')-strpos(xn_array[i],'model')-5))
xn_array=xn_array(sort(timestep_cmfgen))
lstar_array=lstar_array(sort(timestep_cmfgen))
tstar_array=tstar_array(sort(timestep_cmfgen))
teff_array=teff_array(sort(timestep_cmfgen))
timestep_cmfgen_sort=timestep_cmfgen(sort(timestep_cmfgen))
;fix lstar at 0 since it is slightly offset from actual evol value
lstar_array[0]=10^xl60[timestep60norot_array[0]]
age_array=u160[timestep60norot_array]
mdot_array=10^xmdot60[timestep60norot_array]


;;print table with model properties including Teff, L89
;for i=0, n_elements(timestep60norot_array) - 1 do begin
;    ;FOR paper HAVE TO USE wg timestep
;    print, i+1, ' & ',burn60norot_array[i],' & ',sptypes60norot_array[i], ' & ', u160[timestep60norot_array[i]], ' & ',u260[timestep60norot_array[i]], ' & ', 10^xl60[timestep60norot_array[i]],$
;           ' & ',10^xte60[timestep60norot_array[i]], ' & ',10^xtt60[timestep60norot_array[i]], ' & ',teff_array[i], ' & ', rstar60[timestep60norot_array[i]], ' & ',10^xmdot60[timestep60norot_array[i]], ' & ',$
;           vinf60[timestep60norot_array[i]], ' & ',beta60[timestep60norot_array[i]], ' & ',$
;           u560[timestep60norot_array[i]], ' & ', u760[timestep60norot_array[i]], ' & ', $
;          u860[timestep60norot_array[i]], ' & ', u1060[timestep60norot_array[i]], ' & ',u1260[timestep60norot_array[i]], ' & ',u1560[timestep60norot_array[i]], $
;          ' & ', u1760[timestep60norot_array[i]], ' & ', u1860[timestep60norot_array[i]], ' & ', u2060[timestep60norot_array[i]], ' & ',u2260[timestep60norot_array[i]],$
;          ' \\',$
;          FORMAT='(I,A,A,A,A,A,I,A,F5.2,A,I7,A,I6,A,I6,A,I6,A,F7.2,A,E10.2,A,I7,A,F5.1,A,F5.2,A,F5.2,A,E10.2,A,E10.2,A,E10.2,A,F5.2,A,F5.2,A,E10.2,A,E10.2,A,E10.2,A)'
;endfor

;print table with model properties NOT including Teff, L89 (for paper)
for i=0, n_elements(timestep60norot_array) - 1 do begin
    ;FOR paper HAVE TO USE wg timestep
    print, i+1, ' & ',burn60norot_array[i],' & ',sptypes60norot_array[i], ' & ', u160[timestep60norot_array[i]], ' & ',u260[timestep60norot_array[i]], ' & ', 10^xl60[timestep60norot_array[i]],$
           ' & ',10^xte60[timestep60norot_array[i]], ' & ',teff_array[i], ' & ', rstar60[timestep60norot_array[i]], ' & ',10^xmdot60[timestep60norot_array[i]], ' & ',$
           vinf60[timestep60norot_array[i]], ' & ',beta60[timestep60norot_array[i]], ' & ',$
           u560[timestep60norot_array[i]], ' & ', u760[timestep60norot_array[i]], ' & ', $
          u860[timestep60norot_array[i]], ' & ', u1060[timestep60norot_array[i]], ' & ',u1260[timestep60norot_array[i]], ' & ',u1560[timestep60norot_array[i]], $
          ' & ', u1760[timestep60norot_array[i]], ' & ', u1860[timestep60norot_array[i]], ' & ', u2060[timestep60norot_array[i]], ' & ',u2260[timestep60norot_array[i]],$
          ' \\',$
          FORMAT='(I,A,A,A,A,A,I,A,F5.2,A,I7,A,I6,A,I6,A,F7.2,A,E10.2,A,I7,A,F5.1,A,F5.2,A,F5.2,A,E10.2,A,E10.2,A,E10.2,A,F5.2,A,F5.2,A,E10.2,A,E10.2,A,E10.2,A)'
endfor

;PLOTS FOR PAPER
;divide ages by 1e6
u160=u160/1e6
age_array=age_array/1e6

;HR diagram, color indicates burning phases
colorhydburning='blue'
colorheburning='orange'
colorcburning='dark green'
colorinterm='grey'
colormain='red'
colorneutral='black'
;PLOTS TSTAR and TEFF FOR ALL TIMESTEPS TO ILLUSTRATE EFFECTS OF THE WIND 
;splits TEFF array in two since we do not cover the very low teff region, so we actually plot tstar values instead
index_split=where(tstar_array eq min(tstar_array))
;;this does not work, I don't know why, putting by hand timesteps
;index_tstar_evol_min=ZE_EVOL_FIND_CLOSEST_TIMESTEP(alog10(tstar_array[index_split]),alog10(lstar_array[index_split]),xte60,xl60)
;index_tstar_evol_max=ZE_EVOL_FIND_CLOSEST_TIMESTEP(alog10(tstar_array[index_split+1]),alog10(lstar_array[index_split+1]),xte60,xl60)
index_tstar_evol_min=4744
index_tstar_evol_max=modelnumber_start_he;5183
 
 
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xtt60,xl60,color1='blue','Log Temperature (K)','Log Luminosity (Lsun)','',xrange=[5.5,3.70],yrange=[5.4,6.1],$
                              POSITION=[0.15,0.15,0.96,0.96],/nolabel,$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,$
;                              x2=xte60[modelnumber_endh:modelnumber_start_he],y2=xl60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorneutral,$
;                              x3=xte60[modelnumber_starth:modelnumber_endh],y3=xl60[modelnumber_starth:modelnumber_endh],linestyle3=0,color3=colorneutral,$
;                              x4=xte60[modelnumber_start_he:modelnumber_end_he],y4=xl60[modelnumber_start_he:modelnumber_end_he],linestyle4=0,color4=colorneutral,$
;                              x5=xte60[modelnumber_startc:modelnumber_endc],y5=xl60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorneutral,$
                              pointsx2=xtt60[timestep60norot_array],pointsy2=xl60[timestep60norot_array],$
                              psympoints2=16,symcolorpoints2='blue',symsizepoints2=1.3,labeldatapoints2=timestep60norot_array,filename='all_hrdiagram_teff_comp',$
                              pointsx4=xte60[timestep60norot_array],pointsy4=xl60[timestep60norot_array],$
                              psympoints4=16,symcolorpoints4=colorneutral,symsizepoints4=1.3,labeldatapoints4=timestep60norot_array,$                                                          
                              x9=alog10(teff_array[0:index_split]),y9=alog10(lstar_array[0:index_split]),linestyle9=0,color9=colormain,$
                              x8=alog10(teff_array[index_split+1:n_elements(teff_array)-1]),y8=alog10(lstar_array[index_split+1:n_elements(teff_array)-1]),linestyle8=0,color8=colormain,$                             
                              x7=xte60[index_tstar_evol_min:index_tstar_evol_max],y7=xl60[index_tstar_evol_min:index_tstar_evol_max],linestyle7=2,color7=colormain,$
                              x6=xte60,y6=xl60,color6='black',linestyle6=2,$
                    ;          x9=alog10(tstar_array),y9=alog10(lstar_array),linestyle9=0,color9='cyan',$
                              pointsx3=alog10(teff_array),pointsy3=alog10(lstar_array),psympoints3=16,symcolorpoints3=colormain,symsizepoints3=1.3

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,alog10(teff_array[0:13]),alog10(lstar_array[0:13]),color1=colorhydburning,'Log Teff (K)','Log L (Lsun)','',xrange=[5.5,3.70],yrange=[5.4,6.1],$
                              POSITION=[0.15,0.15,0.96,0.96],/nolabel,$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,$
;                              x2=xte60[modelnumber_endh:modelnumber_start_he],y2=xl60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorneutral,$
;                              x3=xte60[modelnumber_starth:modelnumber_endh],y3=xl60[modelnumber_starth:modelnumber_endh],linestyle3=0,color3=colorneutral,$
;                              x4=xte60[modelnumber_start_he:modelnumber_end_he],y4=xl60[modelnumber_start_he:modelnumber_end_he],linestyle4=0,color4=colorneutral,$
;                              x5=xte60[modelnumber_startc:modelnumber_endc],y5=xl60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorneutral,$
                              filename='all_hrdiagram_teffcmf_burningphases',$                                                        
                              x9=alog10(teff_array[13:index_split]),y9=alog10(lstar_array[13:index_split]),linestyle9=0,color9=colorinterm,$
                              x8=alog10(teff_array[index_split+1:n_elements(teff_array)-3]),y8=alog10(lstar_array[index_split+1:n_elements(teff_array)-3]),linestyle8=0,color8=colorheburning,$                             
                              x7=xte60[index_tstar_evol_min:index_tstar_evol_max],y7=xl60[index_tstar_evol_min:index_tstar_evol_max],linestyle7=0,color7=colorinterm,$
                              x6=xte60[modelnumber_start_he:5183],y6=xl60[modelnumber_start_he:5183],linestyle6=0,color6=colorheburning,$
                              x5=alog10(teff_array[n_elements(teff_array)-3:n_elements(teff_array)-1]),y5=alog10(lstar_array[n_elements(teff_array)-3:n_elements(teff_array)-1]),linestyle5=0,color5=colorinterm,$
                             ; x6=xte60,y6=xl60,color6='black',linestyle6=2,$
                    ;          x9=alog10(tstar_array),y9=alog10(lstar_array),linestyle9=0,color9='cyan',$
                               pointsx2=alog10(teff_array[0:13]),pointsy2=alog10(lstar_array[0:13]),psympoints2=16,symcolorpoints2=colorhydburning,symsizepoints2=1.3,$
                               pointsx6=alog10(teff_array[n_elements(teff_array)-1]),pointsy6=alog10(lstar_array[n_elements(teff_array)-1]),psympoints6=16,symcolorpoints6=colorcburning,symsizepoints6=1.3,$
                               pointsx5=alog10(teff_array[n_elements(teff_array)-2:n_elements(teff_array)-1]),pointsy5=alog10(lstar_array[n_elements(teff_array)-2:n_elements(teff_array)-1]),psympoints5=16,symcolorpoints5=colorinterm,symsizepoints5=1.3,$
                               pointsx4=alog10(teff_array[index_split+1:n_elements(teff_array)-3]),pointsy4=alog10(lstar_array[index_split+1:n_elements(teff_array)-3]),psympoints4=16,symcolorpoints4=colorheburning,symsizepoints4=1.3,$
                               pointsx3=alog10(teff_array[14:index_split]),pointsy3=alog10(lstar_array[14:index_split]),psympoints3=16,symcolorpoints3=colorinterm,symsizepoints3=1.3

speco_start=0
speco_end=7
speclbv_start=10
speclbv_end=32
specwnl_start=33
specwnl_end=35
;specwneh_start=36
;specwneh_end=42
specwne_start=36;43 if plotting wneh
specwne_end=44
specwc_start=46
specwc_end=48
specwo_start=49
specwo_end=52
coloro='black'
colorlbv='red'
colorwnl='purple'
colorwneh='green'
colorwne='cyan'
colorwc='magenta'
colorwo='brown'

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,alog10(teff_array[speco_start:speco_end]),alog10(lstar_array[speco_start:speco_end]),color1=coloro,'Log Teff (K)','Log L (Lsun)','',xrange=[5.5,3.70],yrange=[5.4,6.1],$
                              POSITION=[0.15,0.15,0.96,0.96],/nolabel,$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,$
;                              x2=xte60[modelnumber_endh:modelnumber_start_he],y2=xl60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorneutral,$
                              x3=alog10(teff_array[specwo_start:specwo_end]),y3=alog10(lstar_array[specwo_start:specwo_end]),linestyle3=0,color3=colorwo,$
                              x4=alog10(teff_array[specwc_start:specwc_end]),y4=alog10(lstar_array[specwc_start:specwc_end]),linestyle4=0,color4=colorwc,$
;                              x5=xte60[modelnumber_startc:modelnumber_endc],y5=xl60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorneutral,$
                              filename='all_hrdiagram_teffcmf_specphases',$                                                        
                              x9=alog10(teff_array[speclbv_start:index_split]),y9=alog10(lstar_array[speclbv_start:index_split]),linestyle9=0,color9=colorlbv,$
                              x8=alog10(teff_array[index_split+1:speclbv_end]),y8=alog10(lstar_array[index_split+1:speclbv_end]),linestyle8=0,color8=colorlbv,$                             
                              x7=xte60[index_tstar_evol_min:5183],y7=xl60[index_tstar_evol_min:5183],linestyle7=0,color7=colorlbv,$
                              x6=alog10(teff_array[specwnl_start:specwnl_end]),y6=alog10(lstar_array[specwnl_start:specwnl_end]),linestyle6=0,color6=colorwnl,$
                              x5=alog10(teff_array[specwne_start:specwne_end]),y5=alog10(lstar_array[specwne_start:specwne_end]),linestyle5=0,color5=colorwne,$
                               pointsx2=alog10(teff_array[speco_start:speco_end+2]),pointsy2=alog10(lstar_array[speco_start:speco_end+2]),psympoints2=16,symcolorpoints2=coloro,symsizepoints2=1.3,$
                               pointsx6=alog10(teff_array[speclbv_start:speclbv_end]),pointsy6=alog10(lstar_array[speclbv_start:speclbv_end]),psympoints6=16,symcolorpoints6=colorlbv,symsizepoints6=1.3,$
                               pointsx5=alog10(teff_array[specwnl_start:specwnl_end]),pointsy5=alog10(lstar_array[specwnl_start:specwnl_end]),psympoints5=16,symcolorpoints5=colorwnl,symsizepoints5=1.3,$
                               pointsx4=alog10(teff_array[specwne_start:specwne_end]),pointsy4=alog10(lstar_array[specwne_start:specwne_end]),psympoints4=16,symcolorpoints4=colorwne,symsizepoints4=1.3,$
                               pointsx3=alog10(teff_array[specwc_start-1:specwc_end]),pointsy3=alog10(lstar_array[specwc_start-1:specwc_end]),psympoints3=16,symcolorpoints3=colorwc,symsizepoints3=1.3,$
                               pointsx7=alog10(teff_array[specwo_start:specwo_end]),pointsy7=alog10(lstar_array[specwo_start:specwo_end]),psympoints7=16,symcolorpoints7=colorwo,symsizepoints7=1.3



ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xte60,xl60,color1=colorinterm,'Log Surface Temperature (K)','Log Luminosity (Lsun)','',xrange=[5.5,3.70],yrange=[5.4,6.1],$
                              POSITION=[0.15,0.15,0.96,0.96],/nolabel,$
                              x2=xte60[modelnumber_endh:modelnumber_start_he],y2=xl60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorinterm,$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=xte60[modelnumber_starth:modelnumber_endh],y3=xl60[modelnumber_starth:modelnumber_endh],linestyle3=0,color3=colorhydburning,$
                              x4=xte60[modelnumber_start_he:modelnumber_end_he],y4=xl60[modelnumber_start_he:modelnumber_end_he],linestyle4=0,color4=colorheburning,$
                              x5=xte60[modelnumber_startc:modelnumber_endc],y5=xl60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorcburning,$
                              pointsx2=xte60[timestep60norot_array],pointsy2=xl60[timestep60norot_array],$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=timestep60norot_array,filename='all_hrdiagram_teffgva'


;surface temperature as a function of age, color indicates burning phases
;ALL TIMESTEPS
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160,xte60,color1=colorinterm,'Age (years)','','',xrange=[-0.3,3.1],$
                              POSITION=[0.15,0.15,0.36,0.96],xticks=2,xtickv=[0,1.5,3.0],xminor=5,$
                              x2=u160[modelnumber_endh:modelnumber_start_he],y2=xte60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorinterm,$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160[modelnumber_starth:modelnumber_endh],y3=xte60[modelnumber_starth:modelnumber_endh],linestyle3=0,color3=colorhydburning,$
                              x4=u160[modelnumber_start_he:modelnumber_end_he],y4=xte60[modelnumber_start_he:modelnumber_end_he],linestyle4=0,color4=colorheburning,$
                              x5=u160[modelnumber_startc:modelnumber_endc],y5=xte60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorcburning,$
                              x6=age_array,y6=teff_Array,linestyle6=2,color6=grey,$
                              pointsx2=u160[timestep60norot_array],pointsy2=xte60[timestep60norot_array],$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=timestep60norot_array,filename='all_temp1_alltimesteps'
                           
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160,xte60,color1=colorinterm,'','Log Surface Temperature (K)','',xrange=[3.1,4.05],POSITION=[0.15,0.15,0.95,0.96],$
                              x2=u160[modelnumber_endh:modelnumber_start_he],y2=xte60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorinterm,$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160[modelnumber_starth:modelnumber_endh],y3=xte60[modelnumber_starth:modelnumber_endh],linestyle3=0,color3=colorhydburning,$
                              x4=u160[modelnumber_start_he:modelnumber_end_he],y4=xte60[modelnumber_start_he:modelnumber_end_he],linestyle4=0,color4=colorheburning,$
                              x5=u160[modelnumber_startc:modelnumber_endc],y5=xte60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorcburning,$
                              x6=age_array,y6=teff_Array,linestyle6=2,color6=grey,$                              
                              pointsx2=u160[timestep60norot_array],pointsy2=xte60[timestep60norot_array],$
                              pointsx3=age_Array,pointsy3=teff_Array,$,psympoints3=9,symcolorpoints3='grey',symsizepoints3=1.5,$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=timestep60norot_array,filename='all_temp2_alltimesteps'

 
;ONLY SELECTED TIMESTEPS                                 
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160,10^xte60,color1=colorinterm,'','','',xrange=[-0.3,3.01],yrange=[5000,300000],/nolabel,filename='all_temp1',/ylog,$
                              POSITION=[0.15,0.15,0.36,0.96],xticks=2,xtickv=[0,1.5,3.0],xminor=5,ystyle=9,$
                              x2=u160[modelnumber_endh:modelnumber_start_he],y2=10^xte60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorinterm,$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160[modelnumber_starth:modelnumber_endh],y3=10^xte60[modelnumber_starth:modelnumber_endh],linestyle3=0,color3=colorhydburning,$
                              x4=u160[modelnumber_start_he:modelnumber_end_he],y4=10^xte60[modelnumber_start_he:modelnumber_end_he],linestyle4=0,color4=colorheburning,$
                              x5=u160[modelnumber_startc:modelnumber_endc],y5=10^xte60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorcburning,$
                              x6=[age_array[0:26],3.562635,3.564546,3.566554,age_array[27:n_elements(age_array)-1]],$
                              y6=[teff_Array[0:26],7181.,6762.,6746.,teff_array[27:n_elements(age_array)-1]],linestyle6=2,color6='red',fact6=1,$
                              pointsx2=u160[selected_timestepsnorot60],pointsy2=10^xte60[selected_timestepsnorot60],$
                          ;    pointsx3=age_Array,pointsy3=teff_Array,psympoints3=9,symcolorpoints3='grey',symsizepoints3=1.5,$
                              psympoints2=9,symcolorpoints2='black',symsizepoints2=1.5,labeldatapoints2=selected_timestepsnorot60
                              
ZE_EVOL_PLOT_XY_2PLOT_NOAXIS_EPS,u160,10^xte60,color1=colorinterm,'','','',xrange=[3.01,4.05],yrange=[5000,300000],POSITION=[0.15,0.15,0.95,0.96],/nolabel,YTICKFORMAT='(A2)',ylog=1,$
                              x2=u160[modelnumber_endh:modelnumber_start_he],y2=10^xte60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorinterm,$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,filename='all_temp2',YSTYLE=5,$
                              x3=u160[modelnumber_starth:modelnumber_endh],y3=10^xte60[modelnumber_starth:modelnumber_endh],linestyle3=0,color3=colorhydburning,$
                              x4=u160[modelnumber_start_he:modelnumber_end_he],y4=10^xte60[modelnumber_start_he:modelnumber_end_he],linestyle4=0,color4=colorheburning,$
                              x5=u160[modelnumber_startc:modelnumber_endc],y5=10^xte60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorcburning,$
                              x6=[age_array[0:26],3.562635,3.564546,3.566554,age_array[27:n_elements(age_array)-1]],$
                              y6=[teff_Array[0:26],7181.,6762.,6746.,teff_array[27:n_elements(age_array)-1]],linestyle6=2,color6='red',fact6=1,$
                              pointsx2=u160[selected_timestepsnorot60],pointsy2=10^xte60[selected_timestepsnorot60],$
                             ; pointsx3=age_Array,pointsy3=teff_Array,psympoints3=9,symcolorpoints3='grey',symsizepoints3=1.5,$                              
                              psympoints2=9,symcolorpoints2='black',symsizepoints2=1.5,labeldatapoints2=selected_timestepsnorot60

;ONLY SELECTED TIMESTEPS ONLY TEFF CMFGEN       
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,age_array[0:13],teff_array[0:13],color1=colorhydburning,'','','',xrange=[-0.3,3.01],yrange=[5000,300000],/nolabel,filename='all_tempcmf1',/ylog,$
                              POSITION=[0.15,0.15,0.36,0.96],xticks=2,xtickv=[0,1.5,3.0],xminor=5,ystyle=9,$
                            ;  x2=age_array[13:index_split],y2=teff_array[13:index_split],linestyle2=2,color2=colorinterm,$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,$
                              x3=age_array[index_split+1:n_elements(teff_array)-3],y3=teff_array[index_split+1:n_elements(teff_array)-3],linestyle3=0,color3=colorheburning,$
                              x4=u160[index_tstar_evol_min:index_tstar_evol_max],y4=10^xte60[index_tstar_evol_min:index_tstar_evol_max],linestyle4=0,color4=colorinterm,$
                              x5=u160[modelnumber_start_he:5183],y5=10^xte60[modelnumber_start_he:5183],linestyle5=0,color5=colorheburning,$
                              x6=age_array[n_elements(teff_array)-3:n_elements(teff_array)-1],y6=teff_Array[n_elements(teff_array)-3:n_elements(teff_array)-1],linestyle6=2,color6=corlorinterm,fact6=1,$
                              pointsx2=age_array[0:13],pointsy2=teff_array[0:13],$
                          ;    pointsx3=age_Array,pointsy3=teff_Array,psympoints3=9,symcolorpoints3='grey',symsizepoints3=1.5,$
                              psympoints2=16,symcolorpoints2=colorhydburning,symsizepoints2=1.3,labeldatapoints2=selected_timestepsnorot60
                              
ZE_EVOL_PLOT_XY_2PLOT_NOAXIS_EPS,age_array[0:13],teff_array[0:13],color1=colorhydburning,'','','',xrange=[3.01,4.05],yrange=[5000,300000],POSITION=[0.15,0.15,0.95,0.96],/nolabel,YTICKFORMAT='(A2)',ylog=1,$
                      ;        x2=u160[modelnumber_endh:modelnumber_start_he],y2=10^xte60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorinterm,$
                              x2=age_array[13:index_split],y2=teff_array[13:index_split],linestyle2=0,color2=colorinterm,$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,filename='all_tempcmf2',$
                              x3=age_array[index_split+1:n_elements(teff_array)-3],y3=teff_array[index_split+1:n_elements(teff_array)-3],linestyle3=0,color3=colorheburning,$
                              x4=u160[index_tstar_evol_min:index_tstar_evol_max],y4=10^xte60[index_tstar_evol_min:index_tstar_evol_max],linestyle4=0,color4=colorinterm,$
                              x5=u160[modelnumber_start_he:5183],y5=10^xte60[modelnumber_start_he:5183],linestyle5=0,color5=colorheburning,$
                              x6=age_array[n_elements(teff_array)-3:n_elements(teff_array)-1],y6=teff_Array[n_elements(teff_array)-3:n_elements(teff_array)-1],linestyle6=0,color6=colorinterm,fact6=1,$
                              pointsx2=age_array[0:13],pointsy2=teff_array[0:13],psympoints2=16,symcolorpoints2=colorhydburning,symsizepoints2=1.3,labeldatapoints2=selected_timestepsnorot60,$
                              pointsx3=age_array[14:index_split],pointsy3=teff_array[14:index_split],psympoints3=16,symcolorpoints3=colorinterm,symsizepoints3=1.3,labeldatapoints3=selected_timestepsnorot60,$                              
                              pointsx5=age_array[n_elements(teff_array)-2:n_elements(teff_array)-1],pointsy5=teff_array[n_elements(teff_array)-2:n_elements(teff_array)-1],psympoints5=16,symcolorpoints5=colorinterm,symsizepoints5=1.3,labeldatapoints5=selected_timestepsnorot60,$
                              pointsx4=age_array[index_split+1:n_elements(teff_array)-3],pointsy4=teff_array[index_split+1:n_elements(teff_array)-3],psympoints4=16,symcolorpoints4=colorheburning,symsizepoints4=1.3,labeldatapoints4=selected_timestepsnorot60 


ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,age_array[0:13],teff_array[0:13],color1=colorhydburning,'','','',xrange=[-0.3,3.01],yrange=[5000,300000],/nolabel,filename='all_tempcmf1sel',/ylog,$
                              POSITION=[0.15,0.15,0.36,0.96],xticks=2,xtickv=[0,1.5,3.0],xminor=5,ystyle=9,$
                            ;  x2=age_array[13:index_split],y2=teff_array[13:index_split],linestyle2=2,color2=colorinterm,$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,$
                              x3=age_array[index_split+1:n_elements(teff_array)-3],y3=teff_array[index_split+1:n_elements(teff_array)-3],linestyle3=0,color3=colorheburning,$
                              x4=u160[index_tstar_evol_min:index_tstar_evol_max],y4=10^xte60[index_tstar_evol_min:index_tstar_evol_max],linestyle4=0,color4=colorinterm,$
                              x5=u160[modelnumber_start_he:5183],y5=10^xte60[modelnumber_start_he:5183],linestyle5=0,color5=colorheburning,$
                              x6=age_array[n_elements(teff_array)-3:n_elements(teff_array)-1],y6=teff_Array[n_elements(teff_array)-3:n_elements(teff_array)-1],linestyle6=2,color6=corlorinterm,fact6=1,$
                              pointsx2=[age_array[0],age_array[3]],pointsy2=[teff_array[0],teff_array[3]],$
                          ;    pointsx3=age_Array,pointsy3=teff_Array,psympoints3=9,symcolorpoints3='grey',symsizepoints3=1.5,$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=selected_timestepsnorot60
                              
ZE_EVOL_PLOT_XY_2PLOT_NOAXIS_EPS,age_array[0:13],teff_array[0:13],color1=colorhydburning,'','','',xrange=[3.01,4.05],yrange=[5000,300000],POSITION=[0.15,0.15,0.95,0.96],/nolabel,YTICKFORMAT='(A2)',ylog=1,$
                      ;        x2=u160[modelnumber_endh:modelnumber_start_he],y2=10^xte60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorinterm,$
                              x2=age_array[13:index_split],y2=teff_array[13:index_split],linestyle2=0,color2=colorinterm,$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,filename='all_tempcmf2sel',YSTYLE=5,$$
                              x3=age_array[index_split+1:n_elements(teff_array)-3],y3=teff_array[index_split+1:n_elements(teff_array)-3],linestyle3=0,color3=colorheburning,$
                              x4=u160[index_tstar_evol_min:index_tstar_evol_max],y4=10^xte60[index_tstar_evol_min:index_tstar_evol_max],linestyle4=0,color4=colorinterm,$
                              x5=u160[modelnumber_start_he:5183],y5=10^xte60[modelnumber_start_he:5183],linestyle5=0,color5=colorheburning,$
                              x6=age_array[n_elements(teff_array)-3:n_elements(teff_array)-1],y6=teff_Array[n_elements(teff_array)-3:n_elements(teff_array)-1],linestyle6=0,color6=colorinterm,fact6=1,$
                              pointsx2=[age_array[7],age_array[12]],pointsy2=[teff_array[7],teff_array[12]],psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=selected_timestepsnorot60,$
                              pointsx3=[age_array[14],age_array[14]],pointsy3=[teff_array[14],teff_array[14]],psympoints3=9,symcolorpoints3='red',symsizepoints3=1.5,labeldatapoints3=selected_timestepsnorot60,$                              
                              pointsx5=age_array[n_elements(teff_array)-2:n_elements(teff_array)-1],pointsy5=teff_array[n_elements(teff_array)-2:n_elements(teff_array)-1],psympoints5=9,symcolorpoints5='red',symsizepoints5=1.5,labeldatapoints5=selected_timestepsnorot60,$
                              pointsx4=[age_array[27],age_array[36],age_array[44],age_array[47],age_array[50]],pointsy4=[teff_array[27],teff_array[36],teff_array[44],teff_array[47],teff_array[50]],psympoints4=9,symcolorpoints4='red',symsizepoints4=1.5,labeldatapoints4=selected_timestepsnorot60 

;surface abundances as a function of age for SELECTED TIMESTEPS

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160,u560,color1='black','','','',/ylog,xrange=[-0.3,3.01],yrange=[0.0001,4.5],/nolabel,ystyle=9,$
                              x2=u160,y2=u760,linestyle2=2,color2='red',POSITION=[0.15,0.15,0.36,0.96],xticks=2,xtickv=[0,1.5,3.0],xminor=5,$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,filename='all_abundsurf1',$
                              x3=u160,y3=u860,linestyle3=0,color3='magenta',$
                              x4=u160,y4=u1060,linestyle4=0,color4='green',$
                              x5=u160,y5=u1260,linestyle5=3,color5='blue',$
     pointsx2=u160[selected_timestepsnorot60],pointsy2=u560[selected_timestepsnorot60],psympoints2=16,symcolorpoints2='black',symsizepoints2=1.9,labeldatapoints2=selected_timestepsnorot60,$
     pointsx3=u160[selected_timestepsnorot60],pointsy3=u760[selected_timestepsnorot60],psympoints3=16,symcolorpoints3='red',symsizepoints3=1.9,labeldatapoints3=selected_timestepsnorot60,$
     pointsx4=u160[selected_timestepsnorot60],pointsy4=u860[selected_timestepsnorot60],psympoints4=16,symcolorpoints4='magenta',symsizepoints4=1.9,labeldatapoints4=selected_timestepsnorot60,$
     pointsx5=u160[selected_timestepsnorot60],pointsy5=u1060[selected_timestepsnorot60],psympoints5=16,symcolorpoints5='green',symsizepoints5=1.9,labeldatapoints5=selected_timestepsnorot60,$
     pointsx6=u160[selected_timestepsnorot60],pointsy6=u1260[selected_timestepsnorot60],psympoints6=16,symcolorpoints6='blue',symsizepoints6=1.9,labeldatapoints6=selected_timestepsnorot60

ZE_EVOL_PLOT_XY_2PLOT_NOAXIS_EPS,u160,u560,color1='black','','','',/ylog,xrange=[3.01,4.05],yrange=[0.0001,4.5],/nolabel,YTICKFORMAT='(A2)',$
                              x2=u160,y2=u760,linestyle2=2,color2='red',POSITION=[0.15,0.15,0.95,0.96],ystyle=5,$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,filename='all_abundsurf2',$
                              x3=u160,y3=u860,linestyle3=0,color3='magenta',$
                              x4=u160,y4=u1060,linestyle4=0,color4='green',$
                              x5=u160,y5=u1260,linestyle5=3,color5='blue',$
     pointsx2=u160[selected_timestepsnorot60],pointsy2=u560[selected_timestepsnorot60],psympoints2=16,symcolorpoints2='black',symsizepoints2=1.9,labeldatapoints2=selected_timestepsnorot60,$
     pointsx3=u160[selected_timestepsnorot60],pointsy3=u760[selected_timestepsnorot60],psympoints3=16,symcolorpoints3='red',symsizepoints3=1.9,labeldatapoints3=selected_timestepsnorot60,$
     pointsx4=u160[selected_timestepsnorot60],pointsy4=u860[selected_timestepsnorot60],psympoints4=16,symcolorpoints4='magenta',symsizepoints4=1.9,labeldatapoints4=selected_timestepsnorot60,$
     pointsx5=u160[selected_timestepsnorot60],pointsy5=u1060[selected_timestepsnorot60],psympoints5=16,symcolorpoints5='green',symsizepoints5=1.9,labeldatapoints5=selected_timestepsnorot60,$
     pointsx6=u160[selected_timestepsnorot60],pointsy6=u1260[selected_timestepsnorot60],psympoints6=16,symcolorpoints6='blue',symsizepoints6=1.9,labeldatapoints6=selected_timestepsnorot60


;central abundances as a function of age for SELECTED TIMESTEPS
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160,u1560,color1='black','','','',/ylog,xrange=[-0.3,3.01],yrange=[0.00003,4.5],/nolabel,ystyle=9,$
                              x2=u160,y2=u1760,linestyle2=2,color2='red',POSITION=[0.15,0.15,0.36,0.96],xticks=2,xtickv=[0,1.5,3.0],xminor=5,$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,filename='all_abundcen1',$
                              x3=u160,y3=u1860,linestyle3=0,color3='magenta',$
                              x4=u160,y4=u2060,linestyle4=0,color4='green',$
                              x5=u160,y5=u2260,linestyle5=3,color5='blue',$
     pointsx2=u160[selected_timestepsnorot60],pointsy2=u1560[selected_timestepsnorot60],psympoints2=16,symcolorpoints2='black',symsizepoints2=1.9,labeldatapoints2=selected_timestepsnorot60,$
     pointsx3=u160[selected_timestepsnorot60],pointsy3=u1760[selected_timestepsnorot60],psympoints3=16,symcolorpoints3='red',symsizepoints3=1.9,labeldatapoints3=selected_timestepsnorot60,$
     pointsx4=u160[selected_timestepsnorot60],pointsy4=u1860[selected_timestepsnorot60],psympoints4=16,symcolorpoints4='magenta',symsizepoints4=1.9,labeldatapoints4=selected_timestepsnorot60,$
     pointsx5=u160[selected_timestepsnorot60],pointsy5=u2060[selected_timestepsnorot60],psympoints5=16,symcolorpoints5='green',symsizepoints5=1.9,labeldatapoints5=selected_timestepsnorot60,$
     pointsx6=u160[selected_timestepsnorot60],pointsy6=u2260[selected_timestepsnorot60],psympoints6=16,symcolorpoints6='blue',symsizepoints6=1.9,labeldatapoints6=selected_timestepsnorot60

ZE_EVOL_PLOT_XY_2PLOT_NOAXIS_EPS,u160,u1560,color1='black','','','',/ylog,xrange=[3.01,4.05],yrange=[0.00003,4.5],/nolabel,YTICKFORMAT='(A2)',ystyle=5,$
                              x2=u160,y2=u1760,linestyle2=2,color2='red',POSITION=[0.15,0.15,0.95,0.96],filename='all_abundcen2',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160,y3=u1860,linestyle3=0,color3='magenta',$
                              x4=u160,y4=u2060,linestyle4=0,color4='green',$
                              x5=u160,y5=u2260,linestyle5=3,color5='blue',$
     pointsx2=u160[selected_timestepsnorot60],pointsy2=u1560[selected_timestepsnorot60],psympoints2=16,symcolorpoints2='black',symsizepoints2=1.9,labeldatapoints2=selected_timestepsnorot60,$
     pointsx3=u160[selected_timestepsnorot60],pointsy3=u1760[selected_timestepsnorot60],psympoints3=16,symcolorpoints3='red',symsizepoints3=1.9,labeldatapoints3=selected_timestepsnorot60,$
     pointsx4=u160[selected_timestepsnorot60],pointsy4=u1860[selected_timestepsnorot60],psympoints4=16,symcolorpoints4='magenta',symsizepoints4=1.9,labeldatapoints4=selected_timestepsnorot60,$
     pointsx5=u160[selected_timestepsnorot60],pointsy5=u2060[selected_timestepsnorot60],psympoints5=16,symcolorpoints5='green',symsizepoints5=1.9,labeldatapoints5=selected_timestepsnorot60,$
     pointsx6=u160[selected_timestepsnorot60],pointsy6=u2260[selected_timestepsnorot60],psympoints6=16,symcolorpoints6='blue',symsizepoints6=1.9,labeldatapoints6=selected_timestepsnorot60

;total mass and mass-loss rate SELECTED TIMESTEPS
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160,10^xmdot60,color1=colorinterm,'','','',xrange=[-0.3,3.01],yrange=[1e-6,3e-3],/nolabel,filename='all_mass1',/ylog,ystyle=9,$
                              POSITION=[0.15,0.15,0.36,0.96],xticks=2,xtickv=[0,1.5,3.0],xminor=5,$
                              x2=u160[modelnumber_endh:modelnumber_start_he],y2=10^xmdot60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorinterm,$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160[modelnumber_starth:modelnumber_endh],y3=10^xmdot60[modelnumber_starth:modelnumber_endh],linestyle3=0,color3=colorhydburning,$
                              x4=u160[modelnumber_start_he:modelnumber_end_he],y4=10^xmdot60[modelnumber_start_he:modelnumber_end_he],linestyle4=0,color4=colorheburning,$
                              x5=u160[modelnumber_startc:modelnumber_endc],y5=10^xmdot60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorcburning,$
                              pointsx2=u160[selected_timestepsnorot60],pointsy2=10^xmdot60[selected_timestepsnorot60],$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=selected_timestepsnorot60,$
                              /DOUBLE_YAXIS,alty_min=min(u260)-2,alty_max=max(u260)+2,$
                              alt_x2=u160[modelnumber_endh:modelnumber_start_he],alt_y2=u260[modelnumber_endh:modelnumber_start_he],alt_linestyle2=2,alt_color2=colorinterm,$
                              alt_x3=u160[modelnumber_starth:modelnumber_endh],alt_y3=u260[modelnumber_starth:modelnumber_endh],alt_linestyle3=2,alt_color3=colorhydburning,$
                              alt_x4=u160[modelnumber_start_he:modelnumber_end_he],alt_y4=u260[modelnumber_start_he:modelnumber_end_he],alt_linestyle4=2,alt_color4=colorheburning,$
                              alt_x5=u160[modelnumber_startc:modelnumber_endc],alt_y5=u260[modelnumber_startc:modelnumber_endc],alt_linestyle5=2,alt_color5=colorcburning,$
                              alt_pointsx2=u160[selected_timestepsnorot60],alt_pointsy2=u260[selected_timestepsnorot60],$
                              alt_psympoints2=9,alt_symcolorpoints2='red',alt_symsizepoints2=1.5,alt_labeldatapoints2=selected_timestepsnorot60,$
                              ALT_YTITLE=''
                              
ZE_EVOL_PLOT_XY_2PLOT_NOAXIS_EPS,u160,10^xmdot60,color1=colorinterm,'','','',xrange=[3.01,4.05],yrange=[1e-6,3e-3],/nolabel,filename='all_mass2',/ylog,YTICKFORMAT='(A2)',$
                              POSITION=[0.15,0.15,0.95,0.96],ystyle=5,$
                              x2=u160[modelnumber_endh:modelnumber_start_he],y2=10^xmdot60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorinterm,$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160[modelnumber_starth:modelnumber_endh],y3=10^xmdot60[modelnumber_starth:modelnumber_endh],linestyle3=0,color3=colorhydburning,$
                              x4=u160[modelnumber_start_he:modelnumber_end_he],y4=10^xmdot60[modelnumber_start_he:modelnumber_end_he],linestyle4=0,color4=colorheburning,$
                              x5=u160[modelnumber_startc:modelnumber_endc],y5=10^xmdot60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorcburning,$
                              pointsx2=[age_array[7],age_array[12]],pointsy2=[mdot_array[7],mdot_array[12]],psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=selected_timestepsnorot60,$
                              pointsx3=[age_array[14],age_array[14]],pointsy3=[mdot_array[14],mdot_array[14]],psympoints3=9,symcolorpoints3='red',symsizepoints3=1.5,labeldatapoints3=selected_timestepsnorot60,$                              
                              pointsx5=age_array[n_elements(age_array)-2:n_elements(age_array)-1],pointsy5=mdot_array[n_elements(age_Array)-2:n_elements(10^age_array)-1],psympoints5=9,symcolorpoints5='red',symsizepoints5=1.5,labeldatapoints5=selected_timestepsnorot60,$
                              pointsx4=[age_array[27],age_array[36],age_array[44],age_array[47],age_array[50]],pointsy4=[mdot_array[27],mdot_array[36],mdot_array[44],mdot_array[47],mdot_array[50]],psympoints4=9,symcolorpoints4='red',symsizepoints4=1.5,labeldatapoints4=selected_timestepsnorot60,$                             
                              /DOUBLE_YAXIS,alty_min=min(u260)-2,alty_max=max(u260)+2,$
                              alt_x2=u160[modelnumber_endh:modelnumber_start_he],alt_y2=u260[modelnumber_endh:modelnumber_start_he],alt_linestyle2=2,alt_color2=colorinterm,$
                              alt_x3=u160[modelnumber_starth:modelnumber_endh],alt_y3=u260[modelnumber_starth:modelnumber_endh],alt_linestyle3=2,alt_color3=colorhydburning,$
                              alt_x4=u160[modelnumber_start_he:modelnumber_end_he],alt_y4=u260[modelnumber_start_he:modelnumber_end_he],alt_linestyle4=2,alt_color4=colorheburning,$
                              alt_x5=u160[modelnumber_startc:modelnumber_endc],alt_y5=u260[modelnumber_startc:modelnumber_endc],alt_linestyle5=2,alt_color5=colorcburning,$
                              alt_pointsx2=u160[selected_timestepsnorot60],alt_pointsy2=u260[selected_timestepsnorot60],$
                              alt_psympoints2=9,alt_symcolorpoints2='red',alt_symsizepoints2=1.5,alt_labeldatapoints2=selected_timestepsnorot60,$
                              ALT_YTITLE=''


;ONLY FOR MAIN SEQUENCE
;modelnumber_endh=4702 ;changed to include actual computation point
ms_timestep60norot_array=timestep60norot_array(where(timestep60norot_array lt modelnumber_endh))

;HR diagram
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,alog10(teff_array[0:13]),alog10(lstar_array[0:13]),color1=colorhydburning,'Log Teff (K)','Log L (Lsun)','',xrange=[4.75,3.90],yrange=[5.68,5.94],$
                              POSITION=[0.15,0.15,0.92,0.96],/nolabel,$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,$
;                              x2=xte60[modelnumber_endh:modelnumber_start_he],y2=xl60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorneutral,$
;                              x3=xte60[modelnumber_starth:modelnumber_endh],y3=xl60[modelnumber_starth:modelnumber_endh],linestyle3=0,color3=colorneutral,$
;                              x4=xte60[modelnumber_start_he:modelnumber_end_he],y4=xl60[modelnumber_start_he:modelnumber_end_he],linestyle4=0,color4=colorneutral,$
;                              x5=xte60[modelnumber_startc:modelnumber_endc],y5=xl60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorneutral,$
                              filename='ms_hrdiagram',$                                                        
                              x9=alog10(teff_array[13:index_split]),y9=alog10(lstar_array[13:index_split]),linestyle9=0,color9=colorinterm,$
                          ;    x8=alog10(teff_array[index_split+1:n_elements(teff_array)-3]),y8=alog10(lstar_array[index_split+1:n_elements(teff_array)-3]),linestyle8=0,color8=colorheburning,$                             
                          ;    x7=xte60[index_tstar_evol_min:index_tstar_evol_max],y7=xl60[index_tstar_evol_min:index_tstar_evol_max],linestyle7=0,color7=colorinterm,$
                          ;    x6=xte60[modelnumber_start_he:5183],y6=xl60[modelnumber_start_he:5183],linestyle6=0,color6=colorheburning,$
                              x5=alog10(teff_array[n_elements(teff_array)-3:n_elements(teff_array)-1]),y5=alog10(lstar_array[n_elements(teff_array)-3:n_elements(teff_array)-1]),linestyle5=0,color5=colorinterm,$
                             ; x6=xte60,y6=xl60,color6='black',linestyle6=2,$
                    ;          x9=alog10(tstar_array),y9=alog10(lstar_array),linestyle9=0,color9='cyan',$
                               pointsx2=alog10(teff_array[0:13]),pointsy2=alog10(lstar_array[0:13]),psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,$
                               pointsx6=alog10(teff_array[n_elements(teff_array)-1]),pointsy6=alog10(lstar_array[n_elements(teff_array)-1]),psympoints6=9,symcolorpoints6='red',symsizepoints6=1.5,$
                               pointsx5=alog10(teff_array[n_elements(teff_array)-2:n_elements(teff_array)-1]),pointsy5=alog10(lstar_array[n_elements(teff_array)-2:n_elements(teff_array)-1]),psympoints5=9,symcolorpoints5='red',symsizepoints5=1.5,$
                              ; pointsx4=alog10(teff_array[index_split+1:n_elements(teff_array)-3]),pointsy4=alog10(lstar_array[index_split+1:n_elements(teff_array)-3]),psympoints4=16,symcolorpoints4=colorheburning,symsizepoints4=1.3,$
                               pointsx3=alog10(teff_array[14:index_split]),pointsy3=alog10(lstar_array[14:index_split]),psympoints3=9,symcolorpoints3='red',symsizepoints3=1.5


;surface temperature
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,age_array[0:14],teff_array[0:14],/nolabel,$
                              color1='blue','Age (Myr)','Teff (K)','',xrange=[-0.15,3.7],POSITION=[0.15,0.15,0.92,0.96],$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,clip=[0,3.7],yrange=[7000,55000],$
                              pointsx2=age_array[0:13],pointsy2=teff_array[0:13],$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=selected_timestepsnorot60,filename='ms_temp_age'

;surface abundances
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_starth:modelnumber_endh],u560[modelnumber_starth:modelnumber_endh],color1='black','Age (Myr)','Mass fraction at the surface','',/ylog,xrange=[-0.15,3.7],yrange=[0.00003,4.5],/nolabel,$
                              x2=u160[modelnumber_starth:modelnumber_endh],y2=u760[modelnumber_starth:modelnumber_endh],linestyle2=2,color2='red',POSITION=[0.15,0.15,0.92,0.96],filename='ms_surfabund_age',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160[modelnumber_starth:modelnumber_endh],y3=u860[modelnumber_starth:modelnumber_endh],linestyle3=0,color3='magenta',$
                              x4=u160[modelnumber_starth:modelnumber_endh],y4=u1060[modelnumber_starth:modelnumber_endh],linestyle4=0,color4='green',$
                              x5=u160[modelnumber_starth:modelnumber_endh],y5=u1260[modelnumber_starth:modelnumber_endh],linestyle5=3,color5='blue',$
     pointsx2=u160[ms_timestep60norot_array],pointsy2=u560[ms_timestep60norot_array],psympoints2=16,symcolorpoints2='black',symsizepoints2=1.9,labeldatapoints2=ms_timestep60norot_array,$
     pointsx3=u160[ms_timestep60norot_array],pointsy3=u760[ms_timestep60norot_array],psympoints3=16,symcolorpoints3='red',symsizepoints3=1.9,labeldatapoints3=ms_timestep60norot_array,$
     pointsx4=u160[ms_timestep60norot_array],pointsy4=u860[ms_timestep60norot_array],psympoints4=16,symcolorpoints4='magenta',symsizepoints4=1.9,labeldatapoints4=ms_timestep60norot_array,$
     pointsx5=u160[ms_timestep60norot_array],pointsy5=u1060[ms_timestep60norot_array],psympoints5=16,symcolorpoints5='green',symsizepoints5=1.9,labeldatapoints5=ms_timestep60norot_array,$
     pointsx6=u160[ms_timestep60norot_array],pointsy6=u1260[ms_timestep60norot_array],psympoints6=16,symcolorpoints6='blue',symsizepoints6=1.9,labeldatapoints6=ms_timestep60norot_array

                              
;central abundances
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_starth:modelnumber_endh],u1560[modelnumber_starth:modelnumber_endh],color1='black','Age (Myr)','Mass fraction at the center','',/ylog,xrange=[-0.15,3.7],yrange=[0.00003,4.5],/nolabel,$
                              x2=u160[modelnumber_starth:modelnumber_endh],y2=u1760[modelnumber_starth:modelnumber_endh],linestyle2=2,color2='red',POSITION=[0.15,0.15,0.92,0.96],filename='ms_centralabund_age',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160[modelnumber_starth:modelnumber_endh],y3=u1860[modelnumber_starth:modelnumber_endh],linestyle3=0,color3='magenta',$
                              x4=u160[modelnumber_starth:modelnumber_endh],y4=u2060[modelnumber_starth:modelnumber_endh],linestyle4=0,color4='green',$
                              x5=u160[modelnumber_starth:modelnumber_endh],y5=u2260[modelnumber_starth:modelnumber_endh],linestyle5=3,color5='blue',$
     pointsx2=u160[ms_timestep60norot_array],pointsy2=u1560[ms_timestep60norot_array],psympoints2=16,symcolorpoints2='black',symsizepoints2=1.9,labeldatapoints2=ms_timestep60norot_array,$
     pointsx3=u160[ms_timestep60norot_array],pointsy3=u1760[ms_timestep60norot_array],psympoints3=16,symcolorpoints3='red',symsizepoints3=1.9,labeldatapoints3=ms_timestep60norot_array,$
     pointsx4=u160[ms_timestep60norot_array],pointsy4=u1860[ms_timestep60norot_array],psympoints4=16,symcolorpoints4='magenta',symsizepoints4=1.9,labeldatapoints4=ms_timestep60norot_array,$
     pointsx5=u160[ms_timestep60norot_array],pointsy5=u2060[ms_timestep60norot_array],psympoints5=16,symcolorpoints5='green',symsizepoints5=1.9,labeldatapoints5=ms_timestep60norot_array,$
     pointsx6=u160[ms_timestep60norot_array],pointsy6=u2260[ms_timestep60norot_array],psympoints6=16,symcolorpoints6='blue',symsizepoints6=1.9,labeldatapoints6=ms_timestep60norot_array

;mass-loss rate, vinf
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_starth:modelnumber_endh],10^xmdot60[modelnumber_starth:modelnumber_endh],/ylog,/nolabel,$
                              color1='blue','Age (Myr)','Mass-loss rate (Msun/yr)','',xrange=[-0.15,3.7],POSITION=[0.15,0.15,0.92,0.96],$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,clip=[0,3.7],yrange=[1e-6,1e-3],$
                              pointsx2=u160[ms_timestep60norot_array],pointsy2=10^xmdot60[ms_timestep60norot_array],$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=ms_timestep60norot_array,filename='ms_mdot_age',$
                              /DOUBLE_YAXIS,alty_min=min(u260[modelnumber_starth:modelnumber_endh])-2,alty_max=max(u260[modelnumber_starth:modelnumber_endh])+2,$
                              alt_x2=u160[modelnumber_starth:modelnumber_endh],alt_y2=u260[modelnumber_starth:modelnumber_endh],alt_color2='blue',$
                              alt_pointsx2=u160[ms_timestep60norot_array],alt_pointsy2=u260[ms_timestep60norot_array],$
                              alt_psympoints2=9,alt_symcolorpoints2='red',alt_symsizepoints2=1.5,alt_labeldatapoints2=selected_timestepsnorot60,$
                              ALT_YTITLE='Mass (Msun)',alt_linestyle2=2

;eddington parameter
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_starth:modelnumber_endh],eddesm60[modelnumber_starth:modelnumber_endh],/nolabel,$
                              color1='blue','Age (Myr)','Gamma (elec. scat.)','',xrange=[-0.15,3.7],POSITION=[0.15,0.15,0.92,0.96],$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,clip=[0,3.7],yrange=[0,1],$
                              pointsx2=u160[ms_timestep60norot_array],pointsy2=eddesm60[ms_timestep60norot_array],$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=ms_timestep60norot_array,filename='ms_gamma_age'


;total mass
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_starth:modelnumber_endh],u260[modelnumber_starth:modelnumber_endh],/nolabel,$
                              color1='black','Age (Myr)','Mass (Msun)','',xrange=[-0.15,3.7],POSITION=[0.15,0.15,0.92,0.96],$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,clip=[0,3.7],$
                              pointsx2=u160[ms_timestep60norot_array],pointsy2=u260[ms_timestep60norot_array],$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=ms_timestep60norot_array,filename='ms_total_mass_age'

;log g at photosphere
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_starth:modelnumber_endh],logg_rphot60[modelnumber_starth:modelnumber_endh],/nolabel,$
                              color1='black','Age (Myr)','log g (cm^2/s)','',xrange=[-0.15,3.7],POSITION=[0.15,0.15,0.92,0.96],$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,clip=[0,3.7],$
                              pointsx2=u160[ms_timestep60norot_array],pointsy2=logg_rphot60[ms_timestep60norot_array],$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=ms_timestep60norot_array,filename='ms_logg_age'

;ONLY FOR SHELL H burning
hshell_timestep60norot_array=timestep60norot_array(where((timestep60norot_array gt modelnumber_endh) AND (timestep60norot_array lt modelnumber_start_he)))

;HR diagram
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,alog10(teff_array[0:13]),alog10(lstar_array[0:13]),color1=colorhydburning,'Log Teff (K)','Log L (Lsun)','',xrange=[4.45,3.80],yrange=[5.84,6.04],$
                              POSITION=[0.15,0.15,0.92,0.96],/nolabel,$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,$
;                              x2=xte60[modelnumber_endh:modelnumber_start_he],y2=xl60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorneutral,$
;                              x3=xte60[modelnumber_starth:modelnumber_endh],y3=xl60[modelnumber_starth:modelnumber_endh],linestyle3=0,color3=colorneutral,$
;                              x4=xte60[modelnumber_start_he:modelnumber_end_he],y4=xl60[modelnumber_start_he:modelnumber_end_he],linestyle4=0,color4=colorneutral,$
;                              x5=xte60[modelnumber_startc:modelnumber_endc],y5=xl60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorneutral,$
                              filename='hshell_hrdiagram',$                                                        
                              x9=alog10(teff_array[13:index_split]),y9=alog10(lstar_array[13:index_split]),linestyle9=0,color9=colorinterm,$
                              x8=alog10(teff_array[index_split+1:n_elements(teff_array)-3]),y8=alog10(lstar_array[index_split+1:n_elements(teff_array)-3]),linestyle8=0,color8=colorheburning,$                             
                              x7=xte60[index_tstar_evol_min:index_tstar_evol_max],y7=xl60[index_tstar_evol_min:index_tstar_evol_max],linestyle7=0,color7=colorinterm,$
                              x6=xte60[modelnumber_start_he:5183],y6=xl60[modelnumber_start_he:5183],linestyle6=0,color6=colorheburning,$
                              x5=alog10(teff_array[n_elements(teff_array)-3:n_elements(teff_array)-1]),y5=alog10(lstar_array[n_elements(teff_array)-3:n_elements(teff_array)-1]),linestyle5=0,color5=colorinterm,$
                               ;pointsx2=alog10(teff_array[0:13]),pointsy2=alog10(lstar_array[0:13]),psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,$
                               ;pointsx6=alog10(teff_array[n_elements(teff_array)-1]),pointsy6=alog10(lstar_array[n_elements(teff_array)-1]),psympoints6=9,symcolorpoints6='red',symsizepoints6=1.5,$
                               ;pointsx5=alog10(teff_array[n_elements(teff_array)-2:n_elements(teff_array)-1]),pointsy5=alog10(lstar_array[n_elements(teff_array)-2:n_elements(teff_array)-1]),psympoints5=9,symcolorpoints5='red',symsizepoints5=1.5,$
                               ;pointsx4=alog10(teff_array[index_split+1:n_elements(teff_array)-3]),pointsy4=alog10(lstar_array[index_split+1:n_elements(teff_array)-3]),psympoints4=9,symcolorpoints4='red',symsizepoints4=1.5,$
                               pointsx3=alog10(teff_array[14:index_split]),pointsy3=alog10(lstar_array[14:index_split]),psympoints3=9,symcolorpoints3='red',symsizepoints3=1.5
                              
                              

;surface temperature
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,age_array[0:13],teff_array[0:13],color1=colorhydburning,'Age (Myr)','Teff (K)','',xrange=[3.5596,3.5665],POSITION=[0.15,0.15,0.92,0.96],/nolabel,$
                      ;        x2=u160[modelnumber_endh:modelnumber_start_he],y2=10^xte60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorinterm,$
                              x2=age_array[13:index_split],y2=teff_array[13:index_split],linestyle2=0,color2=colorinterm,$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,filename='hshell_temp_age',yrange=[5000,25000],$
                              x3=age_array[index_split+1:n_elements(teff_array)-3],y3=teff_array[index_split+1:n_elements(teff_array)-3],linestyle3=0,color3=colorheburning,$
                              x4=u160[index_tstar_evol_min:index_tstar_evol_max],y4=10^xte60[index_tstar_evol_min:index_tstar_evol_max],linestyle4=0,color4=colorinterm,$
                              x5=u160[modelnumber_start_he:5183],y5=10^xte60[modelnumber_start_he:5183],linestyle5=0,color5=colorheburning,$
                              x6=age_array[n_elements(teff_array)-3:n_elements(teff_array)-1],y6=teff_Array[n_elements(teff_array)-3:n_elements(teff_array)-1],linestyle6=0,color6=colorinterm,fact6=1,$
                              pointsx2=age_array[0:13],pointsy2=teff_array[0:13],psympoints2=16,symcolorpoints2=colorhydburning,symsizepoints2=1.3,labeldatapoints2=selected_timestepsnorot60,$
                              pointsx3=age_array[14:index_split],pointsy3=teff_array[14:index_split],psympoints3=9,symcolorpoints3='red',symsizepoints3=1.5,labeldatapoints3=selected_timestepsnorot60,$                              
                              pointsx5=age_array[n_elements(age_array)-2:n_elements(age_array)-1],pointsy5=teff_array[n_elements(teff_array)-2:n_elements(teff_array)-1],psympoints5=16,symcolorpoints5=colorinterm,symsizepoints5=1.3,labeldatapoints5=selected_timestepsnorot60,$
                              pointsx4=age_array[index_split+1:n_elements(teff_array)-3],pointsy4=teff_array[index_split+1:n_elements(teff_array)-3],psympoints4=16,symcolorpoints4=colorheburning,symsizepoints4=1.3,labeldatapoints4=selected_timestepsnorot60 

;surface abundances
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_endh:modelnumber_start_he],u560[modelnumber_endh:modelnumber_start_he],color1='black','Age (Myr)','Mass fraction at the surface','',/ylog,xrange=[3.5596,3.5665],yrange=[0.00003,4.5],/nolabel,$
                              x2=u160[modelnumber_endh:modelnumber_start_he],y2=u760[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2='red',POSITION=[0.15,0.15,0.92,0.96],filename='hshell_surfabund_age',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160[modelnumber_endh:modelnumber_start_he],y3=u860[modelnumber_endh:modelnumber_start_he],linestyle3=0,color3='magenta',$
                              x4=u160[modelnumber_endh:modelnumber_start_he],y4=u1060[modelnumber_endh:modelnumber_start_he],linestyle4=0,color4='green',$
                              x5=u160[modelnumber_endh:modelnumber_start_he],y5=u1260[modelnumber_endh:modelnumber_start_he],linestyle5=3,color5='blue',$
     pointsx2=u160[hshell_timestep60norot_array],pointsy2=u560[hshell_timestep60norot_array],psympoints2=16,symcolorpoints2='black',symsizepoints2=1.9,labeldatapoints2=hshell_timestep60norot_array,$
     pointsx3=u160[hshell_timestep60norot_array],pointsy3=u760[hshell_timestep60norot_array],psympoints3=16,symcolorpoints3='red',symsizepoints3=1.9,labeldatapoints3=hshell_timestep60norot_array,$
     pointsx4=u160[hshell_timestep60norot_array],pointsy4=u860[hshell_timestep60norot_array],psympoints4=16,symcolorpoints4='magenta',symsizepoints4=1.9,labeldatapoints4=hshell_timestep60norot_array,$
     pointsx5=u160[hshell_timestep60norot_array],pointsy5=u1060[hshell_timestep60norot_array],psympoints5=16,symcolorpoints5='green',symsizepoints5=1.9,labeldatapoints5=hshell_timestep60norot_array,$
     pointsx6=u160[hshell_timestep60norot_array],pointsy6=u1260[hshell_timestep60norot_array],psympoints6=16,symcolorpoints6='blue',symsizepoints6=1.9,labeldatapoints6=hshell_timestep60norot_array

                              
;central abundances
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_endh:modelnumber_start_he],u1560[modelnumber_endh:modelnumber_start_he],color1='black','Age (years)','Mass fraction at the center','',/ylog,xrange=[3.5596,3.5665],yrange=[0.00003,4.5],/nolabel,$
                              x2=u160[modelnumber_endh:modelnumber_start_he],y2=u1760[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2='red',POSITION=[0.15,0.15,0.92,0.96],filename='hshell_centralabund_age',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160[modelnumber_endh:modelnumber_start_he],y3=u1860[modelnumber_endh:modelnumber_start_he],linestyle3=0,color3='magenta',$
                              x4=u160[modelnumber_endh:modelnumber_start_he],y4=u2060[modelnumber_endh:modelnumber_start_he],linestyle4=0,color4='green',$
                              x5=u160[modelnumber_endh:modelnumber_start_he],y5=u2260[modelnumber_endh:modelnumber_start_he],linestyle5=3,color5='blue',$
     pointsx2=u160[hshell_timestep60norot_array],pointsy2=u1560[hshell_timestep60norot_array],psympoints2=16,symcolorpoints2='black',symsizepoints2=1.9,labeldatapoints2=hshell_timestep60norot_array,$
     pointsx3=u160[hshell_timestep60norot_array],pointsy3=u1760[hshell_timestep60norot_array],psympoints3=16,symcolorpoints3='red',symsizepoints3=1.9,labeldatapoints3=hshell_timestep60norot_array,$
     pointsx4=u160[hshell_timestep60norot_array],pointsy4=u1860[hshell_timestep60norot_array],psympoints4=16,symcolorpoints4='magenta',symsizepoints4=1.9,labeldatapoints4=hshell_timestep60norot_array,$
     pointsx5=u160[hshell_timestep60norot_array],pointsy5=u2060[hshell_timestep60norot_array],psympoints5=16,symcolorpoints5='green',symsizepoints5=1.9,labeldatapoints5=hshell_timestep60norot_array,$
     pointsx6=u160[hshell_timestep60norot_array],pointsy6=u2260[hshell_timestep60norot_array],psympoints6=16,symcolorpoints6='blue',symsizepoints6=1.9,labeldatapoints6=hshell_timestep60norot_array


;mass-loss rate, vinf
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_endh:modelnumber_start_he],10^xmdot60[modelnumber_endh:modelnumber_start_he],/ylog,/nolabel,$
                              color1='grey','Age (Myr)','Mass-loss rate (Msun/yr)','',xrange=[3.5596,3.5665],POSITION=[0.15,0.15,0.92,0.96],$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,clip=[0,3.7],yrange=[1e-5,2e-3],$
                              pointsx2=u160[hshell_timestep60norot_array],pointsy2=10^xmdot60[hshell_timestep60norot_array],$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=ms_timestep60norot_array,filename='hshell_mdot_age',$
                              /DOUBLE_YAXIS,alty_min=min(u260[modelnumber_endh:modelnumber_start_he])-2,alty_max=max(u260[modelnumber_endh:modelnumber_start_he])+2,$
                              alt_x2=u160[modelnumber_endh:modelnumber_start_he],alt_y2=u260[modelnumber_endh:modelnumber_start_he],alt_color2='grey',$
                              alt_pointsx2=u160[hshell_timestep60norot_array],alt_pointsy2=u260[hshell_timestep60norot_array],$
                              alt_psympoints2=9,alt_symcolorpoints2='red',alt_symsizepoints2=1.5,alt_labeldatapoints2=selected_timestepsnorot60,$
                              ALT_YTITLE='Mass (Msun)',alt_linestyle2=2

;eddington parameter
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_endh:modelnumber_start_he],eddesm60[modelnumber_endh:modelnumber_start_he],/nolabel,$
                              color1='grey','Age (Myr)','Gamma (elec. scat.)','',xrange=[3.5596,3.5665],POSITION=[0.15,0.15,0.92,0.96],$
                              rebin=1,factor=2,xreverse=0,_EXTRA=extra,clip=[0,3.7],yrange=[0.4,0.8],$
                              pointsx2=u160[hshell_timestep60norot_array],pointsy2=eddesm60[hshell_timestep60norot_array],$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=ms_timestep60norot_array,filename='hshell_gamma_age'


;total mass
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_endh:modelnumber_start_he],u260[modelnumber_endh:modelnumber_start_he],/nolabel,$
                              color1='black','Age (Myr)','Mass (Msun)','',xrange=[3.5596,3.5665],POSITION=[0.15,0.15,0.92,0.96],$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,clip=[0,3.7],$
                              pointsx2=u160[hshell_timestep60norot_array],pointsy2=u260[hshell_timestep60norot_array],$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=ms_timestep60norot_array,filename='hshell_total_mass_age'

;ONLY FOR He burning
hecoreburn_timestep60norot_array=timestep60norot_array(where((timestep60norot_array gt modelnumber_start_he) AND (timestep60norot_array lt modelnumber_end_he)))
;edditing hecoreburn timesteps to include ADVANCED STAGES
hecoreburn_timestep60norot_array=timestep60norot_array(where((timestep60norot_array gt modelnumber_start_he) AND (timestep60norot_array lt modelnumber_endc)))
;HR diagram
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,alog10(teff_array[0:13]),alog10(lstar_array[0:13]),color1=colorhydburning,'Log Teff (K)','Log L (Lsun)','',xrange=[5.5,3.70],yrange=[5.4,6.1],$
                              POSITION=[0.15,0.15,0.92,0.96],/nolabel,$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,$
;                              x2=xte60[modelnumber_endh:modelnumber_start_he],y2=xl60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorneutral,$
;                              x3=xte60[modelnumber_starth:modelnumber_endh],y3=xl60[modelnumber_starth:modelnumber_endh],linestyle3=0,color3=colorneutral,$
;                              x4=xte60[modelnumber_start_he:modelnumber_end_he],y4=xl60[modelnumber_start_he:modelnumber_end_he],linestyle4=0,color4=colorneutral,$
;                              x5=xte60[modelnumber_startc:modelnumber_endc],y5=xl60[modelnumber_startc:modelnumber_endc],linestyle5=0,color5=colorneutral,$
                              filename='he_hrdiagram',$                                                        
                              x9=alog10(teff_array[13:index_split]),y9=alog10(lstar_array[13:index_split]),linestyle9=0,color9=colorinterm,$
                              x8=alog10(teff_array[index_split+1:n_elements(teff_array)-3]),y8=alog10(lstar_array[index_split+1:n_elements(teff_array)-3]),linestyle8=0,color8=colorheburning,$                             
                              x7=xte60[index_tstar_evol_min:index_tstar_evol_max],y7=xl60[index_tstar_evol_min:index_tstar_evol_max],linestyle7=0,color7=colorinterm,$
                              x6=xte60[modelnumber_start_he:5183],y6=xl60[modelnumber_start_he:5183],linestyle6=0,color6=colorheburning,$
                              x5=alog10(teff_array[n_elements(teff_array)-3:n_elements(teff_array)-1]),y5=alog10(lstar_array[n_elements(teff_array)-3:n_elements(teff_array)-1]),linestyle5=0,color5=colorinterm,$
                             ; x6=xte60,y6=xl60,color6='black',linestyle6=2,$
                    ;          x9=alog10(tstar_array),y9=alog10(lstar_array),linestyle9=0,color9='cyan',$
                         ;      pointsx2=alog10(teff_array[0:13]),pointsy2=alog10(lstar_array[0:13]),psympoints2=16,symcolorpoints2=colorhydburning,symsizepoints2=1.3,$
                         ;      pointsx6=alog10(teff_array[n_elements(teff_array)-1]),pointsy6=alog10(lstar_array[n_elements(teff_array)-1]),psympoints6=16,symcolorpoints6=colorcburning,symsizepoints6=1.3,$
                           ;    pointsx5=alog10(teff_array[n_elements(teff_array)-2:n_elements(teff_array)-1]),pointsy5=alog10(lstar_array[n_elements(teff_array)-2:n_elements(teff_array)-1]),psympoints5=16,symcolorpoints5=colorinterm,symsizepoints5=1.3,$
                               pointsx4=alog10(teff_array[index_split+1:n_elements(teff_array)-1]),pointsy4=alog10(lstar_array[index_split+1:n_elements(teff_array)-1]),psympoints4=9,symcolorpoints4='red',symsizepoints4=1.5
                               ;pointsx3=alog10(teff_array[14:index_split]),pointsy3=alog10(lstar_array[14:index_split]),psympoints3=9,symcolorpoints3='red',symsizepoints3=1.5

;surface temperature
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,age_array[0:13],teff_array[0:13],color1=colorhydburning,'Age (Myr)','Teff (K)','',xrange=[3.55,3.992],yrange=[0000,200000],POSITION=[0.15,0.15,0.92,0.96],/nolabel,$
                     ;        x2=u160[modelnumber_endh:modelnumber_start_he],y2=10^xte60[modelnumber_endh:modelnumber_start_he],linestyle2=2,color2=colorinterm,$
                              x2=age_array[13:index_split],y2=teff_array[13:index_split],linestyle2=0,color2=colorinterm,$
                              rebin=1,factor=1,xreverse=0,_EXTRA=extra,filename='he_temp_age',$
                              x3=age_array[index_split+1:n_elements(teff_array)-3],y3=teff_array[index_split+1:n_elements(teff_array)-3],linestyle3=0,color3=colorheburning,$
                              x4=u160[index_tstar_evol_min:index_tstar_evol_max],y4=10^xte60[index_tstar_evol_min:index_tstar_evol_max],linestyle4=0,color4=colorinterm,$
                              x5=u160[modelnumber_start_he:5183],y5=10^xte60[modelnumber_start_he:5183],linestyle5=0,color5=colorheburning,$
                              x6=age_array[n_elements(teff_array)-3:n_elements(teff_array)-1],y6=teff_Array[n_elements(teff_array)-3:n_elements(teff_array)-1],linestyle6=0,color6=colorinterm,fact6=1,$
                     ;        pointsx2=age_array[0:13],pointsy2=teff_array[0:13],psympoints2=16,symcolorpoints2=colorhydburning,symsizepoints2=1.3,labeldatapoints2=selected_timestepsnorot60,$
                     ;        pointsx3=age_array[14:index_split],pointsy3=teff_array[14:index_split],psympoints3=9,symcolorpoints3='red',symsizepoints3=1.5,labeldatapoints3=selected_timestepsnorot60,$                              
                     ;        pointsx5=age_array[n_elements(age_array)-2:n_elements(age_array)-1],pointsy5=teff_array[n_elements(teff_array)-2:n_elements(teff_array)-1],psympoints5=16,symcolorpoints5=colorinterm,symsizepoints5=1.3,labeldatapoints5=selected_timestepsnorot60,$
                              pointsx4=age_array[index_split+1:n_elements(teff_array)-1],pointsy4=teff_array[index_split+1:n_elements(teff_array)-1],psympoints4=9,symcolorpoints4='red',symsizepoints4=1.5,labeldatapoints4=selected_timestepsnorot60 


;surface abundances
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_start_he:modelnumber_end_he],u560[modelnumber_start_he:modelnumber_end_he],color1='black','Age (Myr)','Mass fraction at the surface','',/ylog,xrange=[3.55,3.992],yrange=[0.00003,4.5],/nolabel,$
                              x2=u160[modelnumber_start_he:modelnumber_end_he],y2=u760[modelnumber_start_he:modelnumber_end_he],linestyle2=2,color2='red',POSITION=[0.15,0.15,0.92,0.96],filename='he_surfabund_age',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160[modelnumber_start_he:modelnumber_end_he],y3=u860[modelnumber_start_he:modelnumber_end_he],linestyle3=0,color3='magenta',$
                              x4=u160[modelnumber_start_he:modelnumber_end_he],y4=u1060[modelnumber_start_he:modelnumber_end_he],linestyle4=0,color4='green',$
                              x5=u160[modelnumber_start_he:modelnumber_end_he],y5=u1260[modelnumber_start_he:modelnumber_end_he],linestyle5=3,color5='blue',$
     pointsx2=u160[hecoreburn_timestep60norot_array],pointsy2=u560[hecoreburn_timestep60norot_array],psympoints2=16,symcolorpoints2='black',symsizepoints2=1.9,labeldatapoints2=hecoreburn_timestep60norot_array,$
     pointsx3=u160[hecoreburn_timestep60norot_array],pointsy3=u760[hecoreburn_timestep60norot_array],psympoints3=16,symcolorpoints3='red',symsizepoints3=1.9,labeldatapoints3=hecoreburn_timestep60norot_array,$
     pointsx4=u160[hecoreburn_timestep60norot_array],pointsy4=u860[hecoreburn_timestep60norot_array],psympoints4=16,symcolorpoints4='magenta',symsizepoints4=1.9,labeldatapoints4=hecoreburn_timestep60norot_array,$
     pointsx5=u160[hecoreburn_timestep60norot_array],pointsy5=u1060[hecoreburn_timestep60norot_array],psympoints5=16,symcolorpoints5='green',symsizepoints5=1.9,labeldatapoints5=hecoreburn_timestep60norot_array,$
     pointsx6=u160[hecoreburn_timestep60norot_array],pointsy6=u1260[hecoreburn_timestep60norot_array],psympoints6=16,symcolorpoints6='blue',symsizepoints6=1.9,labeldatapoints6=hecoreburn_timestep60norot_array

                              
;central abundances
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_start_he:modelnumber_end_he],u1560[modelnumber_start_he:modelnumber_end_he],color1='black','Age (Myr)','Mass fraction at the center','',/ylog,xrange=[3.55,3.992],yrange=[0.00003,4.5],/nolabel,$
                              x2=u160[modelnumber_start_he:modelnumber_end_he],y2=u1760[modelnumber_start_he:modelnumber_end_he],linestyle2=2,color2='red',POSITION=[0.15,0.15,0.92,0.96],filename='he_centralabund_age',$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
                              x3=u160[modelnumber_start_he:modelnumber_end_he],y3=u1860[modelnumber_start_he:modelnumber_end_he],linestyle3=0,color3='magenta',$
                              x4=u160[modelnumber_start_he:modelnumber_end_he],y4=u2060[modelnumber_start_he:modelnumber_end_he],linestyle4=0,color4='green',$
                              x5=u160[modelnumber_start_he:modelnumber_end_he],y5=u2260[modelnumber_start_he:modelnumber_end_he],linestyle5=3,color5='blue',$
     pointsx2=u160[hecoreburn_timestep60norot_array],pointsy2=u1560[hecoreburn_timestep60norot_array],psympoints2=16,symcolorpoints2='black',symsizepoints2=1.9,labeldatapoints2=hecoreburn_timestep60norot_array,$
     pointsx3=u160[hecoreburn_timestep60norot_array],pointsy3=u1760[hecoreburn_timestep60norot_array],psympoints3=16,symcolorpoints3='red',symsizepoints3=1.9,labeldatapoints3=hecoreburn_timestep60norot_array,$
     pointsx4=u160[hecoreburn_timestep60norot_array],pointsy4=u1860[hecoreburn_timestep60norot_array],psympoints4=16,symcolorpoints4='magenta',symsizepoints4=1.9,labeldatapoints4=hecoreburn_timestep60norot_array,$
     pointsx5=u160[hecoreburn_timestep60norot_array],pointsy5=u2060[hecoreburn_timestep60norot_array],psympoints5=16,symcolorpoints5='green',symsizepoints5=1.9,labeldatapoints5=hecoreburn_timestep60norot_array,$
     pointsx6=u160[hecoreburn_timestep60norot_array],pointsy6=u2260[hecoreburn_timestep60norot_array],psympoints6=16,symcolorpoints6='blue',symsizepoints6=1.9,labeldatapoints6=hecoreburn_timestep60norot_array


;mass-loss rate, vinf
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_start_he:modelnumber_end_he],10^xmdot60[modelnumber_start_he:modelnumber_end_he],/ylog,/nolabel,$
                              color1='orange','Age (Myr)','Mass-loss rate (Msun/yr)','',xrange=[3.55,3.992],POSITION=[0.15,0.15,0.92,0.96],$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,clip=[0,3.7],yrange=[0.5e-5,2e-3],$
                              x2=u160[modelnumber_end_he:modelnumber_startc],y2=10^xmdot60[modelnumber_end_he:modelnumber_startc],color2=colorinterm,linestyle2=0,$
                              x3=u160[modelnumber_startc:modelnumber_endc],y3=10^xmdot60[modelnumber_startc:modelnumber_endc],linestyle3=0,color3=colorcburning,$
                              pointsx2=u160[hecoreburn_timestep60norot_array],pointsy2=10^xmdot60[hecoreburn_timestep60norot_array],$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=ms_timestep60norot_array,filename='he_mdot_age',$
                              /DOUBLE_YAXIS,alty_min=min(u260[modelnumber_start_he:modelnumber_end_he])-3,alty_max=max(u260[modelnumber_start_he:modelnumber_end_he])+6,$
                              alt_x2=u160[modelnumber_start_he:modelnumber_end_he],alt_y2=u260[modelnumber_start_he:modelnumber_end_he],alt_color2='orange',alt_linestyle2=2,$
                              alt_x4=u160[modelnumber_end_he:modelnumber_startc],alt_y4=u260[modelnumber_end_he:modelnumber_startc],alt_color4=colorinterm,alt_linestyle4=2,$
                              alt_x3=u160[modelnumber_startc:modelnumber_endc],alt_y3=u260[modelnumber_startc:modelnumber_endc],alt_linestyle3=2,alt_color3=colorcburning,$
                              alt_pointsx2=u160[hecoreburn_timestep60norot_array],alt_pointsy2=u260[hecoreburn_timestep60norot_array],$
                              alt_psympoints2=9,alt_symcolorpoints2='red',alt_symsizepoints2=1.5,alt_labeldatapoints2=ms_timestep60norot_array,$
                              ALT_YTITLE='Mass (Msun)'

;eddington parameter
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_start_he:modelnumber_end_he],eddesm60[modelnumber_start_he:modelnumber_end_he],/nolabel,$
                              color1='orange','Age (Myr)','Gamma (elec. scat.)','',xrange=[3.55,3.992],POSITION=[0.15,0.15,0.92,0.96],$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,clip=[0,3.7],yrange=[0.3,0.8],$
                              x2=u160[modelnumber_end_he:modelnumber_startc],y2=eddesm60[modelnumber_end_he:modelnumber_startc],color2=colorinterm,linestyle2=0,$
                              x3=u160[modelnumber_startc:modelnumber_endc],y3=eddesm60[modelnumber_startc:modelnumber_endc],linestyle3=0,color3=colorcburning,$
                              pointsx2=u160[hecoreburn_timestep60norot_array],pointsy2=eddesm60[hecoreburn_timestep60norot_array],$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=ms_timestep60norot_array,filename='he_gamma_age'


;total mass
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[modelnumber_start_he:modelnumber_end_he],u260[modelnumber_start_he:modelnumber_end_he],/nolabel,$
                              color1='black','Age (Myr)','Mass (Msun)','',xrange=[3.55,3.992],POSITION=[0.15,0.15,0.92,0.96],$
                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,clip=[0,3.7],$
                              pointsx2=u160[hecoreburn_timestep60norot_array],pointsy2=u260[hecoreburn_timestep60norot_array],$
                              psympoints2=9,symcolorpoints2='red',symsizepoints2=1.5,labeldatapoints2=ms_timestep60norot_array,filename='he_total_mass_age'




;;'log time to collpase
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,10^logtcollapse60,u560,color1='black','Time to collapse (years)','Mass fraction',label+', vrot/vcrit=0.0',/xlog,/ylog,xrange=[6,1e1],yrange=[0.0001,4.5],/nolabel,$
;                              x2=10^logtcollapse60,y2=u760,linestyle2=2,color2='red',$
;                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,$
;                              x3=10^logtcollapse60,y3=u860,linestyle3=0,color3='green',$
;                              x4=10^logtcollapse60,y4=u1060,linestyle4=0,color4='magenta',$
;                              x5=10^logtcollapse60,y5=u1260,linestyle5=3,color5='blue',$
;     pointsx2=10^logtcollapse60[selected_timestepsnorot60],pointsy2=u560[selected_timestepsnorot60],psympoints2=16,symcolorpoints2='black',symsizepoints2=1.9,labeldatapoints2=selected_timestepsnorot60,$
;     pointsx3=10^logtcollapse60[selected_timestepsnorot60],pointsy3=u760[selected_timestepsnorot60],psympoints3=16,symcolorpoints3='red',symsizepoints3=1.9,labeldatapoints3=selected_timestepsnorot60,$
;     pointsx4=10^logtcollapse60[selected_timestepsnorot60],pointsy4=u860[selected_timestepsnorot60],psympoints4=16,symcolorpoints4='green',symsizepoints4=1.9,labeldatapoints4=selected_timestepsnorot60,$
;     pointsx5=10^logtcollapse60[selected_timestepsnorot60],pointsy5=u1060[selected_timestepsnorot60],psympoints5=16,symcolorpoints5='magenta',symsizepoints5=1.9,labeldatapoints5=selected_timestepsnorot60,$
;     pointsx6=10^logtcollapse60[selected_timestepsnorot60],pointsy6=u1260[selected_timestepsnorot60],psympoints6=16,symcolorpoints6='blue',symsizepoints6=1.9,labeldatapoints6=selected_timestepsnorot60
;                      

END