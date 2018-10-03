;PRO ZE_WORK_ETACAR_INTERFEROMETRY_PIONIER_V2
;works for a single model at a time only
;v2 computes visibilities and CP using fourier transform, and can handle 2D models
;


jd_min=2452216.0D
jd_max=2452900.0D
base_min=17.0D
base_max=26.0D

npix=1027

ZE_READ_PIONIER_DATA,vis2data2012mar06,vis2data2013feb04,vis2data2013feb10,vis2data2013feb20,t3data2012mar06,t3data2013feb04,t3data2013feb10,t3data2013feb20

;error_tot_vis=errortotvt
;df=n_elements(vis_vb)-2
;errortotvt=errortotvt*1.0/vis_vb ;should alway use relative error if using chisq procedure below
;weight=1./errortotvt^2

dir='/Users/jgroh/ze_models/2D_models/etacar/'
model='mod111_john' ;Mdot=1e-3
;model='mod106_john' ;Mdot=5e-4
;model='mod2_groh'   ;Mdot=8e-4
;model='mod3_groh'   ;Mdot=1e-3 but different rstar
model='mod44_groh'
;model='mod_111_copy_groh_finer_rgrid'   ;Mdot=1e-3 but different rstar
;model2d='latidep'
;model2d='tilted_owocki_grid2'
;sufix='a'       ;latidep a (PROL) and d (OBL) provide a good fit
;model2d='c'
;sufix=''
;model2d='cut_v4'
;sufix='m12' ;AMBER wall falpha=10; f4cd
;model2d='cavity'
;sufix='m10' ;AMBER wall falpha=10
;model2d='cut_v5'
;sufix='t1'
;sufix='m7'       ;
;model2d='tilted'
;sufix='c'       ;
;model2d='tests'
;model2d='tilted_owocki_prol_grid_coarse_noscale_doas2d'
;model2d='tilted_owocki_obl'
;sufix='72_75' ;f1
;sufix='75_75' ;f1
;sufix='85_80' ;f1ef
;sufix='98_41' ;f1hi
;sufix='70_85' ;f2bc
;model2d='cut_v4_vstream'
;sufix='16569'
model2d='latidep'
sufix='a'


dist=2.3 ;in kpc
dstr=strcompress(string(dist*10., format='(I03)')) ;for 'a' models
;dstr=strcompress(string(dist*10., format='(I02)')) ;for other models
pa=170.          ;position angle in degrees; by definition PA=0 towards N, and increase eastwards. USE PA significantly different than 0 (e.g.50) for spherical models
pa=130.0
pa_str=strcompress(string(pa, format='(I03)'))
bcg=0.065 ;flux ratio of fully resolved background
decrease_factor=1.0 ; scale factor to decrease ( > 1) or increase (<1) image size

;PIONIER BANDS
bands2012mar06=[1.5585800e-06,  1.5994200e-06,   1.6402500e-06,   1.6810800e-06,   1.7219199e-06,   1.7627500e-06,   1.8035799e-06]
bands2013feb04=[1.5842799e-06,   1.6703682e-06,   1.7559073e-06]
bands2013feb10=[1.5346493e-06,   1.5725359e-06,   1.6245700e-06,   1.6769684e-06,   1.7285458e-06,   1.7810362e-06,   1.8167652e-06]
bands2013feb20=[1.5296423e-06,    1.5665147e-06,   1.6174893e-06,   1.6697153e-06,   1.7211727e-06,   1.7741932e-06,   1.8120795e-06]

                       
band2012mar06_0=where(vis2data2012mar06.eff_wave eq bands2012mar06[0]) ;selects only data from a given band
band2012mar06_1=where(vis2data2012mar06.eff_wave eq bands2012mar06[1]) ;selects only data from a given band
band2012mar06_2=where(vis2data2012mar06.eff_wave eq bands2012mar06[2]) ;selects only data from a given band
band2012mar06_3=where(vis2data2012mar06.eff_wave eq bands2012mar06[3]) ;selects only data from a given band
band2012mar06_4=where(vis2data2012mar06.eff_wave eq bands2012mar06[4]) ;selects only data from a given band
band2012mar06_5=where(vis2data2012mar06.eff_wave eq bands2012mar06[5]) ;selects only data from a given band
band2012mar06_6=where(vis2data2012mar06.eff_wave eq bands2012mar06[6]) ;selects only data from a given band


;model lambda to compute image
lambda0=bands2012mar06[5]*1e10
lambda_ini=bands2012mar06[5]*1e10  ;initial lambda to do calculations 
lambda_fin=bands2012mar06[5]*1e10 
lambda_sampling=2.6     ;sampling in Angstrom;

lambda_continuum=[15650.0,16000.,16500.,16950.,17200.,17627.,18100.]

;compute vis, cp_kband
ZE_READ_OBS_DELTA_IP_ETACAR_V4_PIONIER,dir,model,model2d,sufix,pa,decrease_factor,lambda_ini, lambda_fin, lambda_sampling,lambda0,cp_kband,base_min,base_max,jd_min,jd_max,compute_image=1,visamp=visamp,phase=phase,baseline_xloc_all=baseline_xloc_all,baseline_yloc_all=baseline_yloc_all

vis_array_model_interp_to_obsuvcoords=dblarr(n_elements(vis2data2012mar06.baseline))
phase_array_model_interp_to_obsuvcoords=dblarr(n_elements(vis2data2012mar06.baseline))
spfreq_array_model_interp_to_obsuvcoords=dblarr(n_elements(vis2data2012mar06.baseline))
baseline_array_model_interp_to_obsuvcoords=dblarr(n_elements(vis2data2012mar06.baseline))

for i=0, n_elements(vis2data2012mar06.baseline)-1 do begin
  ZE_RETRIEVE_VISIBILITY_PHASE_CP_WAVELENGTH,vis2data2012mar06[i].ucoord,vis2data2012mar06[i].vcoord,baseline_xloc_all,baseline_yloc_all,visamp,vis_val;,phase=phase,value_phase=value_phase  
  vis_array_model_interp_to_obsuvcoords[i]=vis_val
  spfreq_array_model_interp_to_obsuvcoords[i]=SQRT((vis2data2012mar06[i].ucoord)^2+(vis2data2012mar06[i].vcoord)^2)/ (vis2data2012mar06[i].eff_wave *1e6)
  baseline_array_model_interp_to_obsuvcoords[i]=SQRT((vis2data2012mar06[i].ucoord)^2+(vis2data2012mar06[i].vcoord)^2)
 ; print,i, ' ',vis2data2012mar06[i].ucoord, ' ', vis2data2012mar06[i].vcoord, ' ', baseline_array_model_interp_to_obsuvcoords[i], ' ', spfreq_array_model_interp_to_obsuvcoords[i], ' ', (vis_array_model_interp_to_obsuvcoords[i])^2
 ; phase_array_model_interp_to_obsuvcoords[i]=value_phase
endfor

spfreq=[0.,5.,10.,15.,20.,25,30.,35,40,45,50,55,60,65,70,75,80]
baseline_vals=spfreq*lambda0*1D-4

vis_Array_test=dblarr(n_elements(baseline_vals))
for i=0, n_elements(baseline_vals)-1 do begin
  ZE_RETRIEVE_VISIBILITY_PHASE_CP_WAVELENGTH,baseline_vals[i],0.0,baseline_xloc_all,baseline_yloc_all,visamp,vis_val
  vis_Array_test[i]=vis_val
  ;phase_array_model_interp_to_obsuvcoords[i]=phase_val
endfor


nchannels12mar06=n_elements(bands2012mar06)
vis_model_array_lambda=dblarr(n_elements(baseline_vals),nchannels12mar06) & phase_model_array_lambda=vis_model_array_lambda
baseline_xloc_all_lambda=dblarr(npix,nchannels12mar06) &  baseline_yloc_all_lambda=baseline_xloc_all_lambda
visamp_array_lambda=dblarr(npix,npix,nchannels12mar06) & phaseamp_array_lambda=dblarr(npix,npix,nchannels12mar06)

for i=0, nchannels12mar06 -1 DO BEGIN
    lambda_sampling=2.6     ;sampling in Angstrom;
 ;   ZE_READ_OBS_DELTA_IP_ETACAR_V4_PIONIER,dir,model,model2d,sufix,pa,1.0,bands2012mar06[i]*1e10, bands2012mar06[i]*1e10, lambda_sampling,bands2012mar06[i]*1e10,cp_kband,base_min,base_max,jd_min,jd_max,compute_image=1,visamp=visamp,phase=phase,baseline_xloc_all=baseline_xloc_all,baseline_yloc_all=baseline_yloc_all
    ZE_READ_OBS_DELTA_IP_ETACAR_V4_PIONIER,dir,model,model2d,sufix,pa,1.0,lambda_continuum[i], lambda_continuum[i], lambda_sampling,lambda_continuum[i],cp_kband,base_min,base_max,jd_min,jd_max,compute_image=1,visamp=visamp,phase=phase,baseline_xloc_all=baseline_xloc_all,baseline_yloc_all=baseline_yloc_all 
    visamp_array_lambda[*,*,i]=visamp
    phaseamp_array_lambda[*,*,i]=phase
    baseline_xloc_all_lambda[*,i]=baseline_xloc_all
    baseline_yloc_all_lambda[*,i]=baseline_yloc_all
    for j=0, n_elements(baseline_vals)-1 do begin
      ZE_RETRIEVE_VISIBILITY_PHASE_CP_WAVELENGTH,baseline_vals[j],0.0,baseline_xloc_all,baseline_yloc_all,visamp,vis_val,phase=phase,value_phase=value_phase ; onyl works for a 1-D model !!!
      vis_model_array_lambda[j,i]=vis_val
   ;   phase_model_array_lambda[i]=value_phase
    endfor
endfor
;STOP

;retrieve closure phases
cp_triplet_array_model_interp_to_obsuvcoords_2012mar06=dblarr(n_elements(t3data2012mar06.t3phi))
spfreq_array_model_interp_to_obsuvcoords_2012mar06=dblarr(n_elements(t3data2012mar06.t3phi))
for i=0, n_elements(t3data2012mar06.t3phi)-1 do begin
  ZE_RETRIEVE_CLOSURE_PHASE_PIONIER_FOR_PIONIER,t3data2012mar06[i].u1coord,t3data2012mar06[i].v1coord,t3data2012mar06[i].u2coord,t3data2012mar06[i].v2coord,t3data2012mar06[i].u3coord,t3data2012mar06[i].v3coord,baseline_xloc_all,baseline_yloc_all,phase,cp_triplet  
  cp_triplet_array_model_interp_to_obsuvcoords_2012mar06[i]=cp_triplet
  spfreq_array_model_interp_to_obsuvcoords_2012mar06[i]=SQRT((t3data2012mar06[i].u1coord)^2+(t3data2012mar06[i].v1coord)^2)/ (t3data2012mar06[i].eff_wave *1e6)
  ;baseline_array_model_interp_to_obsuvcoords_2012mar06[i]=SQRT((vis2data2012mar06[i].ucoord)^2+(vis2data2012mar06[i].vcoord)^2)
 ; print,i, ' ',vis2data2012mar06[i].ucoord, ' ', vis2data2012mar06[i].vcoord, ' ', baseline_array_model_interp_to_obsuvcoords[i], ' ', spfreq_array_model_interp_to_obsuvcoords[i], ' ', (vis_array_model_interp_to_obsuvcoords[i])^2
 ; phase_array_model_interp_to_obsuvcoords[i]=value_phase
endfor






!p.background=fsc_color('white')
;lineplot,vis2data2012mar06.baseline / (vis2data2012mar06.eff_wave *1e6), vis2data2012mar06.vis2data,psym1=2
;lineplot,vis2data2012mar06.baseline / (vis2data2012mar06.eff_wave *1e6), vis_array_model_interp_to_obsuvcoords^2,psym1=4


pa_val_band=(vis2data2012mar06[band2012mar06_1].pa)
pa_val_band(where(pa_val_band ge 180.0))=pa_val_band(where(pa_val_band ge 180.0)) - 180.0

;all data plus models
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,vis2data2012mar06.baseline / (vis2data2012mar06.eff_wave *1e6), vis2data2012mar06.vis2data,psym1=1,yerr1=vis2data2012mar06.vis2err,color1='cyan',$
      'Spatial frequency (m/micron)','Visibility squared','',_EXTRA=extra,/ylog,yrange=[0.003,1.0],xrange=[0,100],$
      x2=vis2data2013feb04.baseline / (vis2data2013feb04.eff_wave *1e6),y2= vis2data2013feb04.vis2data,psym2=1,yerr2=vis2data2013feb04.vis2err,color2='blue',$
      x3=vis2data2013feb10.baseline / (vis2data2013feb10.eff_wave *1e6),y3= vis2data2013feb10.vis2data,psym4=1,yerr3=vis2data2013feb10.vis2err,color3='red',$      
      x4=vis2data2013feb20.baseline / (vis2data2013feb20.eff_wave *1e6),y4= vis2data2013feb20.vis2data,psym3=1,yerr4=vis2data2013feb20.vis2err,color4='green',$
      x11=spfreq,y11=(vis_model_array_lambda[*,5]^2)*(1-bcg)^2, color_11='black';,x12=spfreq,y12=(vis_model_array_lambda[*,5]^2)*(1-0)^2, color_12='dark grey',linestyle_12=2;,x9=ftxaxis,y9=ftransfnorm_lambda^2*(1-bcg)^2,color9='pink',linestyle9=3
     

;data for each night color coded with lambda
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,vis2data2012mar06.baseline / (vis2data2012mar06.eff_wave *1e6), vis2data2012mar06.vis2data,psym1=2,$
      'Spatial frequency (m/micron)','Visibility squared','12mar06',z1=(vis2data2012mar06.eff_wave *1e6),labelz='lambda',_EXTRA=extra,/ylog,yrange=[0.003,1.0],xrange=[0,100];, yerr1=vis2data2012mar06.vis2err
      
;data for each night color coded with lambda
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,vis2data2013feb04.baseline / (vis2data2013feb04.eff_wave *1e6), vis2data2013feb04.vis2data,psym1=2,$
      'Spatial frequency (m/micron)','Visibility squared','13feb04',z1=(vis2data2013feb04.eff_wave *1e6),labelz='lambda',_EXTRA=extra,/ylog,yrange=[0.003,1.0],xrange=[0,100];,yerr1=vis2data2013feb04.vis2err
      
       
;data for each night color coded with lambda
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,vis2data2013feb10.baseline / (vis2data2013feb10.eff_wave *1e6), vis2data2013feb10.vis2data,psym1=2,$
      'Spatial frequency (m/micron)','Visibility squared','13feb10',z1=(vis2data2013feb10.eff_wave *1e6),labelz='lambda',_EXTRA=extra,/ylog,yrange=[0.1,1.0],xrange=[0,30];, yerr1=vis2data2013feb10.vis2err
            
;data for each night color coded with lambda
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,vis2data2013feb20.baseline / (vis2data2013feb20.eff_wave *1e6), vis2data2013feb20.vis2data,psym1=2,$
      'Spatial frequency (m/micron)','Visibility squared','13feb20',z1=(vis2data2013feb20.eff_wave *1e6),labelz='lambda',_EXTRA=extra,/ylog,yrange=[0.03,0.6],xrange=[10,60];, yerr1=vis2data2013feb20.vis2err   
         
;only models at different wavelength            
;data for each night color coded with lambda
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,spfreq,(vis_model_array_lambda[*,0]^2)*(1-bcg)^2,$
      'Spatial frequency (m/micron)','Visibility squared','lambda',z1=replicate(bands2012mar06[0]*1e6,n_elements(spfreq)),minz=1.56, maxz=1.80,labelz='lambda',_EXTRA=extra,rebin=0,/ylog,yrange=[0.003,1.0],xrange=[0,100],$
      x6=spfreq,y6=(vis_model_array_lambda[*,0]^2)*(1-bcg)^2,x7=spfreq,y7=(vis_model_array_lambda[*,1]^2)*(1-bcg)^2,x8=spfreq,y8=(vis_model_array_lambda[*,2]^2)*(1-bcg)^2,$
      x9=spfreq,y9=(vis_model_array_lambda[*,3]^2)*(1-bcg)^2,x10=spfreq,y10=(vis_model_array_lambda[*,4]^2)*(1-bcg)^2,$
      x4=spfreq,y4=(vis_model_array_lambda[*,5]^2)*(1-bcg)^2,x5=spfreq,y5=(vis_model_array_lambda[*,6]^2*(1-bcg)^2),$
      z6=replicate(bands2012mar06[0]*1e6,n_elements(spfreq)),z7=replicate(bands2012mar06[1]*1e6,n_elements(spfreq)),z8=replicate(bands2012mar06[3]*1e6,n_elements(spfreq)),$
      z9=replicate(bands2012mar06[3]*1e6,n_elements(spfreq)),z_10=replicate(bands2012mar06[4]*1e6,n_elements(spfreq)), $
      z4=replicate(bands2012mar06[5]*1e6,n_elements(spfreq)),z5=replicate(bands2012mar06[6]*1e6,n_elements(spfreq))    ;, yerr1=vis2data2012mar06.vis2err
 
;only 6th band in 2012 mar 06 compared with the model      
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,vis2data2012mar06[band2012mar06_5].baseline / (vis2data2012mar06[band2012mar06_5].eff_wave *1e6),$
      vis2data2012mar06[band2012mar06_5].vis2data,psym1=2,color1='red','Spatial frequency (m/micron)','Visibility squared','',_EXTRA=extra,/ylog,yrange=[0.003,1.0],xrange=[0,100],$
      x2=vis2data2012mar06[band2012mar06_5].baseline / (vis2data2012mar06[band2012mar06_5].eff_wave *1e6),y2=(vis_array_model_interp_to_obsuvcoords[band2012mar06_5])^2 * (1-bcg)^2,$
      color2='blue',psym2=4,symsize2=2, z1=pa_val_band,labelz='PA',z2=pa_val_band,factor=1.0;, x11=spfreq,y11=(vis_model_array_lambda[*,5]^2)*(1-0)^2*(1-bcg)^2, color_11='black'

;only 6th band in 2012 mar 06 compared with the model      
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,vis2data2012mar06[band2012mar06_5].baseline / (vis2data2012mar06[band2012mar06_5].eff_wave *1e6),$
      vis2data2012mar06[band2012mar06_5].vis2data,psym1=2,color1='red','Spatial frequency (m/micron)','Visibility squared','PA '+pa_str,_EXTRA=extra,/ylog,yrange=[0.03,0.5],xrange=[0,50.],$
      x2=vis2data2012mar06[band2012mar06_5].baseline / (vis2data2012mar06[band2012mar06_5].eff_wave *1e6),y2=(vis_array_model_interp_to_obsuvcoords[band2012mar06_5])^2 * (1-bcg)^2,$
      color2='blue',psym2=4,symsize2=2, z1=pa_val_band,labelz='PA',z2=pa_val_band,factor=1.0;, x11=spfreq,y11=(vis_model_array_lambda[*,5]^2)*(1-0)^2*(1-bcg)^2, color_11='black'

;CLOSURE PHASE: only 6th band in 2012 mar 06 compared with the model      
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,spfreq_array_model_interp_to_obsuvcoords_2012mar06[where(t3data2012mar06.eff_wave EQ bands2012mar06[5])],$
      t3data2012mar06[where(t3data2012mar06.eff_wave EQ bands2012mar06[5])].t3phi,psym1=2,color1='red','Spatial frequency (m/micron)','T3PHI','PA '+pa_str,_EXTRA=extra,yrange=[-20.0,20.0],xrange=[0,90.],$
      x2=spfreq_array_model_interp_to_obsuvcoords_2012mar06[where(t3data2012mar06.eff_wave EQ bands2012mar06[5])],y2=cp_triplet_array_model_interp_to_obsuvcoords_2012mar06[where(t3data2012mar06.eff_wave EQ bands2012mar06[5])],$
      color2='blue',psym2=4,symsize2=2,factor=1;, z1=pa_val_band,labelz='PA',z2=pa_val_band,factor=1.0;, x11=spfreq,y11=(vis_model_array_lambda[*,5]^2)*(1-0)^2*(1-bcg)^2, color_11='black'



;difference between baselines derived from spatial frequency and form those derived from baseline is that using only one image, thus effective wavelength will be diff than
; that in the image except for one band


END