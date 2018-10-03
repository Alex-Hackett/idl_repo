;PRO ZE_WORK_SBW1_WITH_NATHAN_CMFGEN_PLOTS_FOR_PAPER
;plots for paper

;smoothing cos spectrum to 20 km/s
fcossm=ZE_SPEC_CNVL_VEL(lcos,fcos,5.0)
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lcos,fcossm,'Wavelength (Angstrom)', TEXTOIDL('Flux (erg/s/cm^2/A)'),'',$
                          x2=l6,y2=f6cnvluv*0.9*1e-14,linestyle2=0,$
                          x3=l5p,y3=f5pcnvluv*1.1*1e-14,linestyle3=0,color3='blue',$
                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=8,xthick=7,ythick=7,pcharthick=8,pcharsize=2.4,aa=1200,bb=400,$
                          xrange=[1370,1430],yrange=[0.0,1.5e-14],POSITION=[0.12,0.18,0.98,0.98],filename='sbw1_uv1';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lcos,fcossm,'Wavelength (Angstrom)', TEXTOIDL('Flux (erg/s/cm^2/A)'),'',$
                          x2=l6,y2=f6cnvluv*0.992*1e-14,linestyle2=0,$
                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                           pthick=8,xthick=7,ythick=7,pcharthick=8,pcharsize=2.4,aa=1200,bb=400,$
                           xrange=[1430,1530],yrange=[0.0,1.35e-14],POSITION=[0.12,0.18,0.98,0.98],filename='sbw1_uv2';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lcos,fcossm,'Wavelength (Angstrom)', TEXTOIDL('Flux (erg/s/cm^2/A)'),'',$
                          x2=l6,y2=f6cnvluv*1.0*1e-14,linestyle2=0,$
                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=8,xthick=7,ythick=7,pcharthick=8,pcharsize=2.4,aa=1200,bb=400,$
                          xrange=[1522,1620],yrange=[0.0,1.65e-14],POSITION=[0.12,0.18,0.98,0.98],filename='sbw1_uv3';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem



ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lcos,fcossm,'Wavelength (Angstrom)', TEXTOIDL('Flux (erg/s/cm^2/A)'),'',$
                          x2=l6,y2=f6cnvluv*1.137*1e-14,linestyle2=0,$
                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=8,xthick=7,ythick=7,pcharthick=8,pcharsize=2.4,aa=1200,bb=400,$
                          xrange=[1620,1753],yrange=[0.0,1.85e-14],POSITION=[0.12,0.18,0.98,0.98],filename='sbw1_uv4';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem

ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lcos,fcossm,'Wavelength (Angstrom)', 'Flux [erg/s/cm^2/A]','',/ylog,$
                          x2=liue2,y2=liue*1.07*1e-3,linestyle2=0,$
                        ;  x3=l2,y3=f2cnvl/(dist^2)*scale2,linestyle3=2,$
                     ;     x4=l3,y4=f3cnvl/(dist^2)*scale3,linestyle4=3,color4='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=1000,bb=500,$
                          xrange=[1382,1556],yrange=[1e-16,4e-14],POSITION=[0.10,0.10,0.98,0.98],filename='sbw1_hd13854_uv_comparison';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem

vhalpha=-70.0
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,lha,fha,'Wavelength (Angstrom)', TEXTOIDL('Normalized Flux'),'',$
                          x2=l20,y2=ZE_SHIFT_SPECTRA_VEL(l20,f20,vhalpha),linestyle2=0,$
                          x3=l13,y3=ZE_SHIFT_SPECTRA_VEL(l13,f13,vhalpha),linestyle3=0,$
                          x4=l8,y4=ZE_SHIFT_SPECTRA_VEL(l8,f8,vhalpha),linestyle4=0,color4='green',$
                          x5=l10,y5=ZE_SHIFT_SPECTRA_VEL(l10,f10,vhalpha),linestyle5=0,color5='orange',$
;                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
;                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
;                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/10.0 + 1.0),linestyle7=0,$
;                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/10.0 + 1.0),linestyle8=0,$ 
;                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/25.0 + 1.0),linestyle9=0,$       
;                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/15.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=6,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=400,$
                          xrange=[6550,6575],yrange=[0.0,1.3],POSITION=[0.08,0.10,0.98,0.98],filename='sbw1_halpha';,/rebin,factor1=4.0,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.05,id_ypos=10.5,size_id_text=1.0,elem=elem



distsbw1=7.0  ;in kpc
ebvsbw1=-0.91 ;in kpc
rvsbw1=3.1    ;in kpc
ebvsbw1array=-1d0*((indgen(12))/20. + 0.7);[0:50]
rvsbw1array=[2.8,3.0,3.2,3.4,3.6,3.8,4.0,4.2,4.4,4.6,4.8,5.0]
;ebvsbw1array=[-0.8,-0.9,-1.0,-1.1]
;rvsbw1array=[3.1,3.8,4.4,5.0]
;rvsbw1array=[2.6,2.7,2.8,2.9,3.0,3.1,3.2,3.3,3.4,3.5,3.6,3.7,3.8,3.9,4.0,4.1,4.2,4.3,4.4,4.5,4.6,4.7,4.8,4.9,5.0]
magsbw1=[12.70,12.14,10.55,10.18,9.95] ;V, R from Smith+08, JHKs from 2MASS
cos_obs_synthetic_170=14.617744 ;synthetic magnitude calculated for COS spectrum
obs170minusV=cos_obs_synthetic_170 - magsbw1[0]
obsVminusR=magsbw1[0]-magsbw1[1]
obsRminusJ=magsbw1[1]-magsbw1[2]
obsJminusH=magsbw1[2]-magsbw1[3]
obsHminusKs=magsbw1[3]-magsbw1[4]

model170array=dblarr(n_elements(ebvsbw1array),n_elements(rvsbw1array))
modelVarray=dblarr(n_elements(ebvsbw1array),n_elements(rvsbw1array))
modelRarray=dblarr(n_elements(ebvsbw1array),n_elements(rvsbw1array))
modelJarray=dblarr(n_elements(ebvsbw1array),n_elements(rvsbw1array))
modelHarray=dblarr(n_elements(ebvsbw1array),n_elements(rvsbw1array))
modelKsarray=dblarr(n_elements(ebvsbw1array),n_elements(rvsbw1array))

;;uncomment later after making Halpha fig
;for i=0, n_elements(ebvsbw1array) -1 do begin
;  for j=0, n_elements(rvsbw1array) -1 do begin
;ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,'/Users/jgroh/ze_models/sbw1_with_nathan/','20','WFPC2_F170W',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,dist=distsbw1,ebv=ebvsbw1array[i],RV=rvsbw1array[j],norm_factor=0.25,apparent_mag=apparent_mag170
;ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,'/Users/jgroh/ze_models/sbw1_with_nathan/','20','V',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,dist=distsbw1,ebv=ebvsbw1array[i],RV=rvsbw1array[j],norm_factor=0.25,apparent_mag=apparent_magV
;ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,'/Users/jgroh/ze_models/sbw1_with_nathan/','20','R',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,dist=distsbw1,ebv=ebvsbw1array[i],RV=rvsbw1array[j],norm_factor=0.25,apparent_mag=apparent_magR
;ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,'/Users/jgroh/ze_models/sbw1_with_nathan/','20','J',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,dist=distsbw1,ebv=ebvsbw1array[i],RV=rvsbw1array[j],norm_factor=0.25,apparent_mag=apparent_magJ
;ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,'/Users/jgroh/ze_models/sbw1_with_nathan/','20','H',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,dist=distsbw1,ebv=ebvsbw1array[i],RV=rvsbw1array[j],norm_factor=0.25,apparent_mag=apparent_magH
;ZE_CMFGEN_EVOL_COMPUTE_MAGNITUDES_V2,'/Users/jgroh/ze_models/sbw1_with_nathan/','20','Ks',Mstart,Lstart,tstart,absolute_magt,Mbolt,BCt,dist=distsbw1,ebv=ebvsbw1array[i],RV=rvsbw1array[j],norm_factor=0.25,apparent_mag=apparent_magKs
;  model170array[i,j]=apparent_mag170
;  modelRarray[i,j]=apparent_magR
;  modelJarray[i,j]=apparent_magJ
;  modelHarray[i,j]=apparent_magH
;  modelKsarray[i,j]=apparent_magKs
;  endfor
;endfor
;
;model170minusVarray=model170array-modelVarray
;modelVminusRarray=modelVarray-modelRarray
;modelRminusJarray=modelRarray-modelJarray
;modelJminusHarray=modelJarray-modelHarray
;modelHminusKsarray=modelHarray-modelKsarray
;
;W170minusRarray_res=model170minusVarray-obs170minusV
;VminusRarray_res=modelVminusRarray-obsVminusR
;RminusJarray_res=modelRminusJarray-obsRminusJ
;JminusHarray_res=modelJminusHarray-obsJminusH
;HminusKsarray_res=modelHminusKsarray-obsHminusKs
;
;sqrttotalressq_UV=SQRT(W170minusRarray_res^2+VminusRarray_res^2+RminusJarray_res^2+JminusHarray_res^2+HminusKsarray_res^2)
;ximage,sqrttotalressq_UV,xrange=[min(-1D0*ebvsbw1array),max(-1d0*ebvsbw1array)] ,yrange=[min(rvsbw1array),max(rvsbw1array)]
;
;sqrttotalressq_noUV=SQRT(VminusRarray_res^2+RminusJarray_res^2+JminusHarray_res^2+HminusKsarray_res^2)/min(SQRT(VminusRarray_res^2+RminusJarray_res^2+JminusHarray_res^2+HminusKsarray_res^2))
;ximage,sqrttotalressq_noUV,xrange=[min(-1D0*ebvsbw1array),max(-1d0*ebvsbw1array)] ,yrange=[min(rvsbw1array),max(rvsbw1array)]
;
;sqrttotalressq_UV_noIR=SQRT(W170minusRarray_res^2+VminusRarray_res^2+RminusJarray_res^2)
;ximage,sqrttotalressq_UV_noIR,xrange=[min(-1D0*ebvsbw1array),max(-1d0*ebvsbw1array)] ,yrange=[min(rvsbw1array),max(rvsbw1array)]
;
;sqrttotalressq_VRonly=SQRT(VminusRarray_res^2)/min(SQRT(VminusRarray_res^2))
;ximage,sqrttotalressq_VRonly,xrange=[min(-1D0*ebvsbw1array),max(-1d0*ebvsbw1array)] ,yrange=[min(rvsbw1array),max(rvsbw1array)]
;
;lineplot,lcos,fcos

ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/sbw1_with_nathan/20/obs/obs_fin',l20non,f20non,lmin=50,lmax=500000,/FLAM;,/AIR,/FLAM
fm_unred, l20non,f20non, -0.91, f20non_red, R_V=3.1
dist=7.0 ;kpc
;lineplot,l20non,f20non_red*0.25/dist^2 
END
