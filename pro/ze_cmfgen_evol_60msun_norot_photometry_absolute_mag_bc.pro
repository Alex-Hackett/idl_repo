;PRO ZE_CMFGEN_EVOL_60MSUN_NOROT_PHOTOMETRY_ABSOLUTE_MAG_BC

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

modelstr='P060z14S0'
;
;ZE_CMFGEN_SPEC_FIND_AVAILABLE_TIMESTEPS,modelstr,timesteps_available,allobsfinfiles,allobscontfiles ;finds which timesteps have spectra computede in  dir 
;
;;
;bands=['U','B','V','R','I','WFPC2_F336W','WFPC2_F450W','WFPC2_F606W','WFPC2_F814W','WFPC2_F170W','WFPC2_F555W','J','H','Ks']
;;mstar_array_norot=dblarr(n_elements(timesteps_available),n_elements(bands))
;lstar_array_60norot=dblarr(n_elements(timesteps_available),n_elements(bands))
;tstar_array_60norot=dblarr(n_elements(timesteps_available),n_elements(bands))
;teff_array_60norot=dblarr(n_elements(timesteps_available),n_elements(bands))
;Mv_array_60norot=dblarr(n_elements(timesteps_available),n_elements(bands))
;Mbol_array_60norot=dblarr(n_elements(timesteps_available),n_elements(bands))
;BC_array_60norot=dblarr(n_elements(timesteps_available),n_elements(bands))
;;
;for i=0, n_elements(timesteps_available) -1 DO begin
; for j=0, n_elements(bands) - 1 do begin 
;  dirmod=strmid(allobsfinfiles[i],0,strpos(allobsfinfiles[i],modelstr)+10)
;  a=strmid(allobsfinfiles[i],strpos(allobsfinfiles[i],modelstr)+9)
;  model_60norot=strmid(a,0,strpos(a,'obs')-1)
;  ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,dirmod,model_60norot,bands[j],Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt
;  ;mstar_array_norot[i,j]=mstart 
;  lstar_array_60norot[i,j]=lstart
;  tstar_array_60norot[i,j]=tstart
;  teff_array_60norot[i,j]=tstart
;  Mv_array_60norot[i,j]=absolute_magt
;  Mbol_array_60norot[i,j]=Mbolt
;  BC_array_60norot[i,j]=BCt    
; endfor 
;endfor  
;
;
;                               
;uminusb_60norot=dblarr(n_elements(timesteps_available)) & bminusv_60norot=dblarr(n_elements(timesteps_available)) & vminusi_60norot=dblarr(n_elements(timesteps_available))
;
;for i=0, n_elements(timesteps_available) -1 DO begin 
;  uminusb_60norot[i]=Mv_array_60norot[i,0]-Mv_array_60norot[i,1]
;  bminusv_60norot[i]=Mv_array_60norot[i,1]-Mv_array_60norot[i,2]
;  vminusi_60norot[i]=Mv_array_60norot[i,2]-Mv_array_60norot[i,4]  
;endfor  
;;
;save, filename='/Users/jgroh/temp/ze_cmfgen_'+modelstr+'_mag_bcs_onlycmfgen.sav',/all
;STOP

restore,'/Users/jgroh/temp/ze_cmfgen_'+modelstr+'_mag_bcs_onlycmfgen.sav'

;;Mv and BCs ARRAY key for non-rot: 
;;(for rot models, add 20 msun model as the first row)
;
;; [ Mu25  Mu32  Mu40 ... Mu120 
;;   Mb25  Mb32  Mb40 ... Mb120 
;;   Mv25  Mv32  Mv40 ... Mv120 
;;    .
;;   Mi25  Mi32  Mi40 ... Mi120] 
;


;;compute number of ionizing photons, takes some time because has to read obs files again since we need F_NU in Jansky
;nphot_hyd_array=dblarr(n_elements(timesteps_available)) & nphot_hei_array=dblarr(n_elements(timesteps_available)) & nphot_he2_array=dblarr(n_elements(timesteps_available))
;for i=0, n_elements(timesteps_available) -1 DO begin
;  a=strmid(allobsfinfiles[i],strpos(allobsfinfiles[i],modelstr)+9)
;  model_60norot=strmid(a,0,strpos(a,'obs')-1) 
;  ZE_CMFGEN_COMPUTE_NUMBER_H_IONIZING_PHOTONS,allobsfinfiles[i],nphot_hyd,nphot_hei,nphot_he2,lum_hyd,lum_hei,lum_he2 
;  nphot_hyd_array[i]=nphot_hyd
;  nphot_hei_array[i]=nphot_hei
;  nphot_he2_array[i]=nphot_he2  
;endfor
;save,filename='/Users/jgroh/temp/ze_cmfgen_'+modelstr+'_number_h_hei_he2_photons.sav',nphot_hyd_array,nphot_hei_array,nphot_he2_array

restore,'/Users/jgroh/temp/ze_cmfgen_'+modelstr+'_number_h_hei_he2_photons.sav'


;sntype_Array_rot=['II-Prot', 'II-Prot', 'II-Prot','II-Prot', 'II-L/brot', 'II-L/brot', 'II-L/brot', 'Ibrot', 'Icrot', 'Icrot', 'Icrot', 'Ibrot', 'Icrot']
;sntype_array_norot=['II-Pnorot', 'II-Pnorot', 'II-Pnorot', 'II-L/bnorot', 'II-L/bnorot', 'II-L/bnorot', 'Ibnorot', 'Ibnorot', 'Ibnorot', 'Icnorot', 'Icnorot','Ibnorot']
;symcolorrot=['red','red','red','red','yellow','green','green','blue','cyan','cyan','cyan','cyan','cyan']
;symcolornorot=['red','red','red','red','red','green','blue','blue','cyan','cyan','cyan','cyan']

!P.Background = fsc_color('white')
;lineplot,tstar_array,Mv_array

;for j=0, n_elements(bands) - 1 do begin 
;
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,mstar_array_rot[*,j],Mv_array_rot[*,j],'Mini (Msun)','M_'+bands[j]+' (mag)','',_EXTRA=extra,psym1=sntype_array_rot,symsize1=4,symcolor1=symcolorrot,/yreverse, $
;                               x2=mstar_array_norot[*,j],y2=Mv_array_norot[*,j],psym2=sntype_array_norot,symsize2=4,symcolor2=symcolornorot,xcharsize=2.5,ycharsize=2.5,$
;                               POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21,/noxaxisvalues
;                             
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V3,mstar_array_rot[*,j],BC_array_rot[*,j],'Mini (Msun)','BC_'+bands[j]+' (mag)','',_EXTRA=extra,psym1=sntype_array_rot,symsize1=4,symcolor1=symcolorrot, $
;                               x2=mstar_array_norot[*,j],y2=BC_array_norot[*,j],psym2=sntype_array_norot,symsize2=4,symcolor2=symcolornorot,xcharsize=2.5,ycharsize=2.5,$
;                               POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[18,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21,/noxaxisvalues                         
;endfor

;recallling that bands=['U','B','V','R','I','WFPC2_F336W','WFPC2_F450W','WFPC2_F606W','WFPC2_F814W','WFPC2_F170W','WFPC2_F555W','J','H','Ks']
;put spectral types so they are also in the table

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

;print table for Johnson-Cousins + JHK filters
print, '% Johnson-Cousins + JHK filters'
for i=0, n_elements(timesteps_available) - 1 do begin
    print, i+1, ' & ' ,burn60norot_array[i],' & ',sptypes60norot_array[i], ' & ', mv_array_60norot[i,0], ' & ', mv_array_60norot[i,1], ' & ', $
          mv_array_60norot[i,2], ' & ', mv_array_60norot[i,3], ' & ',mv_array_60norot[i,4], ' & ',$
          mv_array_60norot[i,10], ' & ',mv_array_60norot[i,11], ' & ',mv_array_60norot[i,12], ' & ',$  
          bc_array_60norot[i,0], ' & ', bc_array_60norot[i,1], ' & ', bc_array_60norot[i,2],' & ', bc_array_60norot[i,3],' & ', bc_array_60norot[i,4],' & ', $
          bc_array_60norot[i,10], ' & ',bc_array_60norot[i,11], ' & ',bc_array_60norot[i,12], ' \\',$
          FORMAT='(I,A,A,A,A,A,F6.2,A,F6.2,A,F6.2,A,F6.2, A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A)'
endfor

;print table for WFPC2 filters
print, '% WFPC2 filters'
for i=0, n_elements(timesteps_available) - 1 do begin
    print, i+1, ' & ' ,burn60norot_array[i],' & ',sptypes60norot_array[i], ' & ', $
          mv_array_60norot[i,9], ' & ', mv_array_60norot[i,5], ' & ', mv_array_60norot[i,6], ' & ', mv_array_60norot[i,10], ' & ',mv_array_60norot[i,7], ' & ',$
          mv_array_60norot[i,8], '& ', $   
          bc_array_60norot[i,9], ' & ', bc_array_60norot[i,5], ' & ', bc_array_60norot[i,6], ' & ', bc_array_60norot[i,10], ' & ',bc_array_60norot[i,7], ' & ',$
          bc_array_60norot[i,8], ' \\',$
          FORMAT='(I,A,A,A,A,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A,F6.2,A)'
endfor

for j=0, n_elements(bands) - 1 do begin 

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[timesteps_available]/1e6,Mv_array_60norot[*,j],'Age (Myr)','M_'+bands[j]+' (mag)','',_EXTRA=extra,psym1=15,symsize1=2,symcolor1='black',/yreverse, $
                                x2=u160[timesteps_available]/1e6,y2=Mv_array_60norot[*,j],color2='black',linestyle2=0,$
                               xcharsize=2.5,ycharsize=2.5,POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21;,/noxaxisvalues
                             
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[timesteps_available]/1e6,BC_array_60norot[*,j],'Age (Myr)','BC_'+bands[j]+' (mag)','',_EXTRA=extra,psym1=15,symsize1=2,symcolor1='black', $
                               x2=u160[timesteps_available]/1e6,y2=BC_array_60norot[*,j],color2='black',linestyle2=0,$
                               xcharsize=2.5,ycharsize=2.5, POSITION=[0.20,0.22,0.97,0.97],XMARGIN=[18,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21;,/noxaxisvalues           
endfor

;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160,u560,color1='black','','','',/ylog,xrange=[-0.3,3.01],yrange=[0.0001,4.5],/nolabel,ystyle=9,$
;                              x2=u160,y2=u760,linestyle2=2,color2='red',POSITION=[0.15,0.15,0.36,0.96],xticks=2,xtickv=[0,1.5,3.0],xminor=5,$
;                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,filename='all_abundsurf1',$
;                              x3=u160,y3=u860,linestyle3=0,color3='magenta',$
;                              x4=u160,y4=u1060,linestyle4=0,color4='green',$
;                              x5=u160,y5=u1260,linestyle5=3,color5='blue',$
;     pointsx2=u160[selected_timestepsnorot60],pointsy2=u560[selected_timestepsnorot60],psympoints2=16,symcolorpoints2='black',symsizepoints2=1.9,labeldatapoints2=selected_timestepsnorot60,$
;     pointsx3=u160[selected_timestepsnorot60],pointsy3=u760[selected_timestepsnorot60],psympoints3=16,symcolorpoints3='red',symsizepoints3=1.9,labeldatapoints3=selected_timestepsnorot60,$
;     pointsx4=u160[selected_timestepsnorot60],pointsy4=u860[selected_timestepsnorot60],psympoints4=16,symcolorpoints4='magenta',symsizepoints4=1.9,labeldatapoints4=selected_timestepsnorot60,$
;     pointsx5=u160[selected_timestepsnorot60],pointsy5=u1060[selected_timestepsnorot60],psympoints5=16,symcolorpoints5='green',symsizepoints5=1.9,labeldatapoints5=selected_timestepsnorot60,$
;     pointsx6=u160[selected_timestepsnorot60],pointsy6=u1260[selected_timestepsnorot60],psympoints6=16,symcolorpoints6='blue',symsizepoints6=1.9,labeldatapoints6=selected_timestepsnorot60
;
;ZE_EVOL_PLOT_XY_2PLOT_NOAXIS_EPS,u160,u560,color1='black','','','',/ylog,xrange=[3.01,4.05],yrange=[0.0001,4.5],/nolabel,YTICKFORMAT='(A2)',$
;                              x2=u160,y2=u760,linestyle2=2,color2='red',POSITION=[0.15,0.15,0.95,0.96],ystyle=5,$
;                              rebin=1,factor=3,xreverse=0,_EXTRA=extra,filename='all_abundsurf2',$
;                              x3=u160,y3=u860,linestyle3=0,color3='magenta',$
;                              x4=u160,y4=u1060,linestyle4=0,color4='green',$
;                              x5=u160,y5=u1260,linestyle5=3,color5='blue',$
;     pointsx2=u160[selected_timestepsnorot60],pointsy2=u560[selected_timestepsnorot60],psympoints2=16,symcolorpoints2='black',symsizepoints2=1.9,labeldatapoints2=selected_timestepsnorot60,$
;     pointsx3=u160[selected_timestepsnorot60],pointsy3=u760[selected_timestepsnorot60],psympoints3=16,symcolorpoints3='red',symsizepoints3=1.9,labeldatapoints3=selected_timestepsnorot60,$
;     pointsx4=u160[selected_timestepsnorot60],pointsy4=u860[selected_timestepsnorot60],psympoints4=16,symcolorpoints4='magenta',symsizepoints4=1.9,labeldatapoints4=selected_timestepsnorot60,$
;     pointsx5=u160[selected_timestepsnorot60],pointsy5=u1060[selected_timestepsnorot60],psympoints5=16,symcolorpoints5='green',symsizepoints5=1.9,labeldatapoints5=selected_timestepsnorot60,$
;     pointsx6=u160[selected_timestepsnorot60],pointsy6=u1260[selected_timestepsnorot60],psympoints6=16,symcolorpoints6='blue',symsizepoints6=1.9,labeldatapoints6=selected_timestepsnorot60


;absolute magnitudes x age, plot 1
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[timesteps_available]/1e6,Mv_array_60norot[*,0],'','','',_EXTRA=extra,psym1=15,symsize1=1.3,symcolor1='purple',/yreverse, filename='output_evol_P060z14S0_mag1_age',$
                                x2=u160[timesteps_available]/1e6,y2=Mv_array_60norot[*,0],color2='purple',linestyle2=0,$
                                x3=u160[timesteps_available]/1e6,y3=Mv_array_60norot[*,1],psym3=15,symsize3=1.3,symcolor3='cyan',$
                                x4=u160[timesteps_available]/1e6,y4=Mv_array_60norot[*,1],color4='cyan',linestyle4=2,$
                                x5=u160[timesteps_available]/1e6,y5=Mv_array_60norot[*,2],psym5=15,symsize5=1.3,symcolor5='blue',$
                                x6=u160[timesteps_available]/1e6,y6=Mv_array_60norot[*,2],color6='blue',linestyle6=2,$
                                x7=u160[timesteps_available]/1e6,y7=Mv_array_60norot[*,3],psym7=15,symsize7=1.3,symcolor7='green',$
                                x8=u160[timesteps_available]/1e6,y8=Mv_array_60norot[*,3],color8='green',linestyle8=2,$
                                x9=u160[timesteps_available]/1e6,y9=Mv_array_60norot[*,4],psym9=15,symsize9=1.3,symcolor9='orange',$
                                x10=u160[timesteps_available]/1e6,y10=Mv_array_60norot[*,4],color_10='orange',linestyle_10=2,$   
                                x11=u160[timesteps_available]/1e6,y11=Mv_array_60norot[*,12],psym_11=15,symsize_11=1.3,symcolor_11='red',$
                                x12=u160[timesteps_available]/1e6,y12=Mv_array_60norot[*,12],color_12='red',linestyle_12=2,$                                                                 
                                xcharsize=2.5,ycharsize=2.5,POSITION=[0.09,0.22,0.37,0.97],XMARGIN=[15,3],YMARGIN=[8,1],xrange=[0,3.5],yrange=[-2.01,-11.8],xtickinterval=1,charthick=10,xthick=10,ythick=10,$
                                psxsize=800,psysize=300,YSTYLE=9,pcharsize=1.4,ticklen=19;,/noxaxisvalues

;absolute magnitudes x age, plot 2
ZE_EVOL_PLOT_XY_2PLOT_NOAXIS_EPS,u160[timesteps_available]/1e6,Mv_array_60norot[*,0],'','','',_EXTRA=extra,psym1=15,symsize1=1.3,symcolor1='purple',/yreverse, YTICKFORMAT='(A2)',ystyle=5,  filename='output_evol_P060z14S0_mag2_age',$$
                                x2=u160[timesteps_available]/1e6,y2=Mv_array_60norot[*,0],color2='purple',linestyle2=0,$
                                x3=u160[timesteps_available]/1e6,y3=Mv_array_60norot[*,1],psym3=15,symsize3=1.3,symcolor3='cyan',$
                                x4=u160[timesteps_available]/1e6,y4=Mv_array_60norot[*,1],color4='cyan',linestyle4=2,$
                                x5=u160[timesteps_available]/1e6,y5=Mv_array_60norot[*,2],psym5=15,symsize5=1.3,symcolor5='blue',$
                                x6=u160[timesteps_available]/1e6,y6=Mv_array_60norot[*,2],color6='blue',linestyle6=3,$
                                x7=u160[timesteps_available]/1e6,y7=Mv_array_60norot[*,3],psym7=15,symsize7=1.3,symcolor7='green',$
                                x8=u160[timesteps_available]/1e6,y8=Mv_array_60norot[*,3],color8='green',linestyle8=0,$
                                x9=u160[timesteps_available]/1e6,y9=Mv_array_60norot[*,4],psym9=15,symsize9=1.3,symcolor9='orange',$
                                x10=u160[timesteps_available]/1e6,y10=Mv_array_60norot[*,4],color_10='orange',linestyle_10=2,$ 
                                x11=u160[timesteps_available]/1e6,y11=Mv_array_60norot[*,12],psym_11=15,symsize_11=1.3,symcolor_11='red',$
                                x12=u160[timesteps_available]/1e6,y12=Mv_array_60norot[*,12],color_12='red',linestyle_12=2,$                                                                     
                                xcharsize=2.5,ycharsize=2.5,POSITION=[0.37,0.22,0.99,0.97],XMARGIN=[15,3],YMARGIN=[8,1],xrange=[3.5,3.99],yrange=[-2.01,-11.8],charthick=10,xthick=10,ythick=10,$
                                psxsize=800,psysize=300,pcharsize=1.4,ticklen=19;,$
;                                pointsx2=u160[timestep60norot_array]/1e6,pointsy2=Mv_array_60norot[*,0], labeldatapoints2=sptypes60norot_array;,/noyaxisvalues


;color B-V, V-K x age, plot 1
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[timesteps_available]/1e6,Mv_array_60norot[*,1] - Mv_array_60norot[*,2],'','','',_EXTRA=extra,psym1=15,symsize1=1.3,symcolor1='black',/yreverse, filename='output_evol_P060z14S0_color1_age',$
                                x2=u160[timesteps_available]/1e6,y2=Mv_array_60norot[*,1] - Mv_array_60norot[*,2],color2='black',linestyle2=0,$
                                x3=u160[timesteps_available]/1e6,y3=Mv_array_60norot[*,2] - Mv_array_60norot[*,13],psym3=15,symsize3=1.3,symcolor3='red',$
                                x4=u160[timesteps_available]/1e6,y4=Mv_array_60norot[*,2] - Mv_array_60norot[*,13],color4='red',linestyle4=2,$                                                              
                                xcharsize=2.5,ycharsize=2.5,POSITION=[0.09,0.22,0.37,0.97],XMARGIN=[15,3],YMARGIN=[8,1],xrange=[0,3.5],yrange=[-1.1,1.5],xtickinterval=1,charthick=10,xthick=10,ythick=10,$
                                psxsize=800,psysize=300,YSTYLE=9,pcharsize=1.4,ticklen=19;,/noxaxisvalues

;color B-V, V-K x age, plot 2
ZE_EVOL_PLOT_XY_2PLOT_NOAXIS_EPS,u160[timesteps_available]/1e6,Mv_array_60norot[*,1] - Mv_array_60norot[*,2],'','','',_EXTRA=extra,psym1=15,symsize1=1.3,symcolor1='black',$
                                /yreverse, YTICKFORMAT='(A2)',ystyle=5,  filename='output_evol_P060z14S0_color2_age',$$
                                x2=u160[timesteps_available]/1e6,y2=Mv_array_60norot[*,1] - Mv_array_60norot[*,2],color2='black',linestyle2=0,$
                                x3=u160[timesteps_available]/1e6,y3=Mv_array_60norot[*,1] - Mv_array_60norot[*,13],psym3=15,symsize3=1.3,symcolor3='red',$
                                x4=u160[timesteps_available]/1e6,y4=Mv_array_60norot[*,1] - Mv_array_60norot[*,13],color4='red',linestyle4=2,$                                                                 
                                xcharsize=2.5,ycharsize=2.5,POSITION=[0.37,0.22,0.99,0.97],XMARGIN=[15,3],YMARGIN=[8,1],xrange=[3.5,3.99],yrange=[-1.1,1.5],charthick=10,xthick=10,ythick=10,$
                                psxsize=800,psysize=300,pcharsize=1.4,ticklen=19;,$
;                                pointsx2=u160[timestep60norot_array]/1e6,pointsy2=Mv_array_60norot[*,0], labeldatapoints2=sptypes60norot_array;,/noyaxisvalues

;number of ionizing photons x age, plot 1
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u160[timesteps_available]/1e6,nphot_hyd_array[*],'','','',_EXTRA=extra,psym1=15,symsize1=1.3,symcolor1='black',/yreverse, filename='output_evol_P060z14S0_ionphot1_age',$
                                x2=u160[timesteps_available]/1e6,y2=nphot_hyd_array[*],color2='black',linestyle2=0,$
                                x3=u160[timesteps_available]/1e6,y3=nphot_hei_array[*],psym3=15,symsize3=1.3,symcolor3='red',$
                                x4=u160[timesteps_available]/1e6,y4=nphot_hei_array[*],color4='red',linestyle4=2,$ 
                                x5=u160[timesteps_available]/1e6,y5=nphot_he2_array[*]+2,psym5=15,symsize5=1.3,symcolor5='blue',$
                                x6=u160[timesteps_available]/1e6,y6=nphot_he2_array[*]+2,color6='blue',linestyle6=2,$                                                                                              
                                xcharsize=2.5,ycharsize=2.5,POSITION=[0.09,0.22,0.37,0.97],XMARGIN=[15,3],YMARGIN=[8,1],xrange=[0,3.5],yrange=[46,51],xtickinterval=1,charthick=10,xthick=10,ythick=10,$
                                psxsize=800,psysize=300,YSTYLE=9,pcharsize=1.4,ticklen=19;,/noxaxisvalues

;number of ionizing photons x age, plot 2
ZE_EVOL_PLOT_XY_2PLOT_NOAXIS_EPS,u160[timesteps_available]/1e6,nphot_hyd_array[*],'','','',_EXTRA=extra,psym1=15,symsize1=1.3,symcolor1='black',$
                                /yreverse, YTICKFORMAT='(A2)',ystyle=5, filename='output_evol_P060z14S0_ionphot2_age',$
                                x2=u160[timesteps_available]/1e6,y2=nphot_hyd_array[*],color2='black',linestyle2=0,$
                                x3=u160[timesteps_available]/1e6,y3=nphot_hei_array[*],psym3=15,symsize3=1.3,symcolor3='red',$
                                x4=u160[timesteps_available]/1e6,y4=nphot_hei_array[*],color4='red',linestyle4=2,$ 
                                x5=u160[timesteps_available]/1e6,y5=nphot_he2_array[*]+2,psym5=15,symsize5=1.3,symcolor5='blue',$
                                x6=u160[timesteps_available]/1e6,y6=nphot_he2_array[*]+2,color6='blue',linestyle6=2,$                                                                    
                                xcharsize=2.5,ycharsize=2.5,POSITION=[0.37,0.22,0.99,0.97],XMARGIN=[15,3],YMARGIN=[8,1],xrange=[3.5,3.99],yrange=[46,51],charthick=10,xthick=10,ythick=10,$
                                psxsize=800,psysize=300,pcharsize=1.4,ticklen=19;,$

;color mag diagram, B-V x V mag
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,Mv_array_60norot[*,1] - Mv_array_60norot[*,2],Mv_array_60norot[*,2],'B-V (mag','V (mag)','',_EXTRA=extra,psym1=15,symsize1=1.3,symcolor1='black',/yreverse, $
                                x2=Mv_array_60norot[*,1] - Mv_array_60norot[*,2],y2=Mv_array_60norot[*,2],color2='black',linestyle2=0,$                                                                 
                                xcharsize=2.5,ycharsize=2.5,POSITION=[0.22,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21;,/DOUBLE_YAXIS;,$
                                ;,/noyaxisvalues

;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,u260[timesteps_available],Mv_array_60norot[*,0],'Age (Myr)','M2 (mag)','',_EXTRA=extra,psym1=15,symsize1=1.3,symcolor1='purple',/yreverse, $
;                                x2=u260[timesteps_available],y2=Mv_array_60norot[*,0],color2='purple',linestyle2=0,$
;                                x3=u260[timesteps_available],y3=Mv_array_60norot[*,1],psym3=15,symsize3=1.3,symcolor3='cyan',$
;                                x4=u260[timesteps_available],y4=Mv_array_60norot[*,1],color4='cyan',linestyle4=2,$
;                                x5=u260[timesteps_available],y5=Mv_array_60norot[*,2],psym5=15,symsize5=1.3,symcolor5='blue',$
;                                x6=u260[timesteps_available],y6=Mv_array_60norot[*,2],color6='blue',linestyle6=2,$
;                                x7=u260[timesteps_available],y7=Mv_array_60norot[*,3],psym7=15,symsize7=1.3,symcolor7='green',$
;                                x8=u260[timesteps_available],y8=Mv_array_60norot[*,3],color8='green',linestyle8=2,$
;                                xcharsize=2.5,ycharsize=2.5,POSITION=[0.17,0.22,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21,/xreverse,$
;                                psxsize=800,psysize=300;,/noyaxisvalues
;                                                                                                                    

END