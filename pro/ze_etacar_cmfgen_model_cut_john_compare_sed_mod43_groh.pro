;PRO ZE_ETACAR_CMFGEN_MODEL_CUT_JOHN_COMPARE_SED_MOD43_GROH
;TO BE DONE: COMPARE UV FLUX FROM CMFGEN MODELS WITH Impact parameter only up to 0.1 arcsec, consistent WITH STIS OBS
;*******************************************************************************************************



close,/all
Angstrom = '!6!sA!r!u!9 %!6!n!6'
!P.Background = fsc_color('white')
;RESTORE,'/Users/jgroh/temp/ze_etacar_cmfgen_model_obs_optical_full_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+'.sav'


ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/etacar/mod43_groh/obs/obs_fin',lmfull,fmfull,/FLAM
ZE_CMFGEN_READ_OBS,'/Users/jgroh/ze_models/etacar/mod43_groh/obs/obs_fin',lmfull,fmfull,/FLAM

dir1='/Users/jgroh/ze_models/2D_models/etacar/mod43_groh/'
model1='cut_v4_vstream'   ;b,c,o,r,t,u,v don't cover the UV range
sufix1='c'
filename1='OBSFRAME1'
ZE_CMFGEN_READ_OBS_2D,filename1,dir1+model1+'/'+sufix1+'/',lmopt,fmopt,nm1,/FLAM
ZE_BH05_CAVITY_GET_INC_FROM_OBS_INP,dir1,model1,sufix1,filename1,inc1,inc_str1

sufix1='d'
ZE_CMFGEN_READ_OBS_2D,filename1,dir1+model1+'/'+sufix1+'/',lmuv2,fmuv2,nm1,/FLAM

;starting here we computed the flux for 3 angles, (OBSFRAME1=pole,OBSFRAME2=41deg,OBSFRAME3=equator)
filename1='OBSFRAME1'
sufix1='e'
ZE_CMFGEN_READ_OBS_2D,filename1,dir1+model1+'/'+sufix1+'/',lmuv,fmuv,nm1,/FLAM

sufix1='g'
ZE_CMFGEN_READ_OBS_2D,filename1,dir1+model1+'/'+sufix1+'/',lmmir,fmmir,nm1,/FLAM
;has a Nan values above 8e5 angs, corresponding to index 20000. shrinking vector
lmmir=lmmir[0:20000]
fmmir=fmmir[0:20000]

sufix1='f'
ZE_CMFGEN_READ_OBS_2D,filename1,dir1+model1+'/'+sufix1+'/',lmir,fmir,nm1,/FLAM


;;testing model with scaling=T, do_as_2d=F
filename1='OBSFRAME2'
sufix1='p'
ZE_CMFGEN_READ_OBS_2D,filename1,dir1+model1+'/'+sufix1+'/',luvsc,fuvsc,nm1,/FLAM

;reads in companion spectrum
modelc='/Users/jgroh/ze_models/etacar/eta_companion_r5/obs/obs_fin'
ZE_CMFGEN_READ_OBS,modelc,lc1,fc1,num_rec1,/FLAM

modelc2='/Users/jgroh/ze_models/ogrid_24jun09/NT35000_logg400/obs/obs_fin_10'
ZE_CMFGEN_READ_OBS,modelc2,lc2,fc2,num_rec1,/FLAM

resolving_power=100.
lambda_val=1000
res=lambda_val/resolving_power
ZE_SPEC_CNVL,lmfull,fmfull,res,lambda_val,fluxcnvl=fmfullconv
ZE_SPEC_CNVL,lmuv,fmuv,res,lambda_val,fluxcnvl=fmuvconv
ZE_SPEC_CNVL,lmuv2,fmuv2,res,lambda_val,fluxcnvl=fmuv2conv
ZE_SPEC_CNVL,lmopt,fmopt,res,lambda_val,fluxcnvl=fmoptconv
ZE_SPEC_CNVL,lmir,fmir,res,lambda_val,fluxcnvl=fmirconv
ZE_SPEC_CNVL,lmmir,fmmir,res,lambda_val,fluxcnvl=fmmirconv
ZE_SPEC_CNVL,lc1,fc1,res,lambda_val,fluxcnvl=fc1conv


;interpolate cavity model into spherical model lambda grid and compute flux ratio

lmcav=[lmuv,lmuv2,lmopt,lmir,lmmir]
fmcav=[fmuv,fmuv2,fmopt,fmir,fmmir]
fmcavconv=[fmuvconv,fmuv2conv,fmoptconv,fmirconv,fmmirconv]

fmcavi=cspline(lmcav,fmcav,lmfull)
fmcavconvi=cspline(lmcav,fmcavconv,lmfull)
fluxratio=fmcavi/fmfull
fluxratioconv=fmcavconvi/fmfullconv

;distance
dist=2.3

;;observations
;
;filename_17apr01='/Users/jgroh/data/hst/stis/etacar_from_john/star_17apr01'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_17apr01,lambda_17apr01,flux_17apr01,mask_17apr01
;
;filename_23mar00_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_23mar00_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_23mar00_e140m,lambda_23mar00_e140m,flux_23mar00_e140m,mask_23mar00_e140m
;
;
;
;;de redenning
;ebv=1.0 ;best fit with ca 2 mag of grey extinction?
;;minusebv=-1.7 ;from Davidson et al
;;minusebv=-1.2
;a=4.2
;
;;from OBSFRAME
;scale=380.
;scale=8.
;fm_unred, lambda_23mar00_e140m,flux_23mar00_e140m*scale, ebv, flux_23mar00_e140mderedden, R_V = a
;fm_unred, lambda_17apr01,flux_17apr01*scale, ebv, flux_17apr01deredden, R_V = a
;;convolve
;ZE_SPEC_CNVL,lambda_23mar00_e140m,flux_23mar00_e140mderedden,res,lambda_val,fluxcnvl=flux_23mar00_e140mdereddencnvl
;ZE_SPEC_CNVL,lambda_17apr01,flux_17apr01deredden,res,lambda_val,fluxcnvl=flux_17apr01dereddencnvl
;
;;cuts lambda < 1280 angs
;lambda_23mar00_e140m=lambda_23mar00_e140m[10000:n_elements(lambda_23mar00_e140m)-1]
;flux_23mar00_e140mdereddencnvl=flux_23mar00_e140mdereddencnvl[10000:n_elements(flux_23mar00_e140mdereddencnvl)-1]

;set plot range
x1l=900. & x1u=3000.
x2l=3000. & x2u=11000.
x1l=800 & x1u=51000.
x3l=11000. & x3u=51000.
x4l=1750. & x4u=1952.
x5l=2500. & x5u=2820.
x6l=2850. & x6u=3120.


;making psplots
set_plot,'ps'

device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_sed_full_purplehaze_letter_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches
!X.thick=3.7
!Y.thick=3.7
!p.charthick=3.5
!Y.OMARGIN=[2.5,0.5]
!p.multi=[0, 0, 0, 0, 0]
!p.charthick=3.5
!Y.MARGIN=[3.5,0.5]
;setting color of each model
coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')
a=4.0 ;line thick obs
b=3.5 ;line thick model
b=0
;coloro=fsc_color('black')
;colorm=fsc_color('red')
;colorm2=fsc_color('blue')
;colorm3=fsc_color('orange')
;x1l=6530
;x1u=6590

;plot,lmfull,fmfull,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],yrange=[0,2.5e-7],xcharsize=2.0,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
;/nodata,POSITION=[0.08,0.77,0.97,0.99]
;plots,lmfull,fmfullconv,color=coloro,linestyle=0,noclip=0,clip=[x1l,1e-13,x1u,1e-7],thick=b+3.5
;plots,lmuv,fmuvconv,color=colorm1,linestyle=0,noclip=0,clip=[x1l,0,x1u,10],thick=b+3.5
;plots,lmuv2,fmuv2conv,color=colorm1,linestyle=0,noclip=0,clip=[x1l,0,x1u,10],thick=b+3.5
;xyouts,400,3000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE

;labels
;xyouts,2700,7500,model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+extra_label1 ,charthick=3.5,color=fsc_color('red'),orientation=0,/DEVICE
;xyouts,2700,7000,model2+'_'+sufix2+'_'+filename2+'_i'+inc_str2+extra_label2 ,charthick=3.5,color=fsc_color('blue'),orientation=0,/DEVICE
;xyouts,2700,6500,model3+'_'+sufix3+'_'+filename3+'_i'+inc_str3+extra_label3 ,charthick=3.5,color=fsc_color('orange'),orientation=0,/DEVICE

;plot,lmfull,fmfull,xstyle=1,ystyle=1,xrange=[x2l-2,x2u+2],yrange=[0.0,5e-7],xcharsize=2.0,ytickinterval=10,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
;/nodata,POSITION=[0.08,0.45,0.97,0.67]
;plots,lmfull,fmfullconv,color=colormo,linestyle=1,noclip=0,clip=[x2l,0,x2u,35],thick=b+3.5
;plots,lmopt,fmoptconv,color=colorm1,linestyle=1,noclip=0,clip=[x2l,0,x2u,35],thick=b+3.5
;
s=1e-8
ymin=2e-11
plot,lmfull,fmfull/dist^2/s,xstyle=1,ystyle=1,xrange=[1800.,2600.],yrange=[4e-10/dist^2/s,1.5e-7/dist^2/s],xcharsize=1.8,ycharsize=1.8,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata,POSITION=[0.15,0.15,0.94,0.99],xtitle='Wavelength ['+Angstrom+']'
;plots,lambda_23mar00_e140m,flux_23mar00_e140mdereddencnvl,linestyle=0,noclip=0,thick=b+3.5,color=coloro
;plots,lambda_17apr01,flux_17apr01dereddencnvl,linestyle=0,noclip=0,thick=b+3.5,color=coloro
plots,lmfull,fmfullconv/dist^2/s,color=colorm2,linestyle=0,noclip=0,thick=b+3.5
;plots,lmuv,fmuvconv/dist^2,color=colorm1,linestyle=0,noclip=0,clip=[x1l,ymin,x1u,10],thick=b+3.5
plots,lmuv,fmuvconv/dist^2/s,color=colorm1,linestyle=0,noclip=0,thick=b+3.5
plots,lmuv2,fmuv2conv/dist^2/s,color=colorm1,linestyle=0,noclip=0,thick=b+3.5
;plots,lmuv3,fmuv3conv/dist^2,color=colorm1,linestyle=0,noclip=0,clip=[x1l,ymin,x1u,10],thick=b+3.5
;plots,lmopt,fmoptconv/dist^2,color=colorm1,linestyle=0,noclip=0,clip=[x1l,ymin,x1u,35],thick=b+3.5
;plots,lmir,fmirconv/dist^2,color=colorm1,linestyle=0,noclip=0,clip=[x1l,ymin,x1u,35],thick=b+3.5
plots,lc1,fc1conv/dist^2/s,color=colorm4,linestyle=0,noclip=0,thick=b+3.5
xyouts,700,5000,TEXTOIDL('Flux [10^-12 erg/s/cm^2/')+angstrom+']',charthick=3.5,orientation=90,/DEVICE,charsize=1.8



!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_sed_full_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches
!X.thick=3.7
!Y.thick=3.7
!p.charthick=3.5
!Y.OMARGIN=[2.5,0.5]
!p.multi=[0, 0, 0, 0, 0]
!p.charthick=3.5
!Y.MARGIN=[3.5,0.5]
;setting color of each model
coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')
a=4.0 ;line thick obs
b=3.5 ;line thick model
b=0
;coloro=fsc_color('black')
;colorm=fsc_color('red')
;colorm2=fsc_color('blue')
;colorm3=fsc_color('orange')
;x1l=6530
;x1u=6590

;plot,lmfull,fmfull,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],yrange=[0,2.5e-7],xcharsize=2.0,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
;/nodata,POSITION=[0.08,0.77,0.97,0.99]
;plots,lmfull,fmfullconv,color=coloro,linestyle=0,noclip=0,clip=[x1l,1e-13,x1u,1e-7],thick=b+3.5
;plots,lmuv,fmuvconv,color=colorm1,linestyle=0,noclip=0,clip=[x1l,0,x1u,10],thick=b+3.5
;plots,lmuv2,fmuv2conv,color=colorm1,linestyle=0,noclip=0,clip=[x1l,0,x1u,10],thick=b+3.5
;xyouts,400,3000,'Normalized Flux',charthick=3.5,orientation=90,/DEVICE

;labels
;xyouts,2700,7500,model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+extra_label1 ,charthick=3.5,color=fsc_color('red'),orientation=0,/DEVICE
;xyouts,2700,7000,model2+'_'+sufix2+'_'+filename2+'_i'+inc_str2+extra_label2 ,charthick=3.5,color=fsc_color('blue'),orientation=0,/DEVICE
;xyouts,2700,6500,model3+'_'+sufix3+'_'+filename3+'_i'+inc_str3+extra_label3 ,charthick=3.5,color=fsc_color('orange'),orientation=0,/DEVICE

;plot,lmfull,fmfull,xstyle=1,ystyle=1,xrange=[x2l-2,x2u+2],yrange=[0.0,5e-7],xcharsize=2.0,ytickinterval=10,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
;/nodata,POSITION=[0.08,0.45,0.97,0.67]
;plots,lmfull,fmfullconv,color=colormo,linestyle=1,noclip=0,clip=[x2l,0,x2u,35],thick=b+3.5
;plots,lmopt,fmoptconv,color=colorm1,linestyle=1,noclip=0,clip=[x2l,0,x2u,35],thick=b+3.5
;

ymin=2e-13
plot,lmfull,fmfull/dist^2,xstyle=1,ystyle=1,xrange=[x1l-2,16800],yrange=[ymin,1.5e-7/dist^2],/ylog,/xlog,xcharsize=2.0,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata,POSITION=[0.18,0.15,0.97,0.99],xtitle='Wavelength ['+Angstrom+']',ytitle='Flux [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]'
;plots,lambda_23mar00_e140m,flux_23mar00_e140mdereddencnvl,linestyle=0,noclip=0,thick=b+3.5,color=coloro
;plots,lambda_17apr01,flux_17apr01dereddencnvl,linestyle=0,noclip=0,thick=b+3.5,color=coloro
plots,lmfull,fmfullconv/dist^2,color=colorm2,linestyle=0,noclip=0,thick=b+3.5
plots,lmuv,fmuvconv/dist^2,color=colorm1,linestyle=0,noclip=0,thick=b+3.5
plots,lmuv2,fmuv2conv/dist^2,color=colorm1,linestyle=0,noclip=0,thick=b+3.5
plots,lmopt,fmoptconv/dist^2,color=colorm1,linestyle=0,noclip=0,thick=b+3.5
plots,lmir,fmirconv/dist^2,color=colorm1,linestyle=0,noclip=0,thick=b+3.5
plots,lmmir,fmmirconv/dist^2,color=colorm1,linestyle=0,noclip=0,thick=b+3.5
plots,lc1,fc1conv/dist^2,color=colorm4,linestyle=0,noclip=0,thick=b+3.5
xyouts,0.9,0.9,'(b)',orientation=0,/NORMAL,charsize=2.0

!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_sed_fluxratio_2d_to_1d_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches
!X.thick=3.7
!Y.thick=3.7
!P.thick=3.7
!p.charthick=3.5
!Y.OMARGIN=[2.5,0.5]
!p.multi=[0, 0, 0, 0, 0]
!p.charthick=3.5
!Y.MARGIN=[3.5,0.5]
;setting color of each model
coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')
a=4.0 ;line thick obs
b=3.5 ;line thick model
b=0

plot,lmfull,fluxratio,xstyle=1,ystyle=1,xrange=[x1l-2,x1u+2],yrange=[0.8,1700],/xlog,/ylog,xcharsize=2.0,ycharsize=2.0,$
/nodata,POSITION=[0.18,0.15,0.97,0.99],xtitle='Wavelength ['+Angstrom+']',ytitle='Flux ratio 2dcav/1Dcmfgen'
;plots,lambda_23mar00_e140m,flux_23mar00_e140mdereddencnvl,linestyle=0,noclip=0,thick=b+3.5,color=coloro
;plots,lambda_17apr01,flux_17apr01dereddencnvl,linestyle=0,noclip=0,thick=b+3.5,color=coloro
plots,lmfull,fluxratio,color=coloro,linestyle=0,noclip=0,thick=1.0
plots,[920,3000],[1.28,1.00],color=colorm1,linestyle=0,noclip=0,thick=b+7.5
xyouts,0.9,0.9,'(c)',orientation=0,/NORMAL,charsize=2.0

!p.multi=[0, 0, 0, 0, 0]
device,/close

device,filename='/Users/jgroh/temp/etc_cmfgen_mod111_plus_cavity_compare_models_sed_FUV_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+'.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches
!X.thick=3.7
!Y.thick=3.7
!p.charthick=3.5
!Y.OMARGIN=[2.5,0.5]
!p.multi=[0, 0, 0, 0, 0]
!p.charthick=3.5
!Y.MARGIN=[3.5,0.5]
;setting color of each model
coloro=fsc_color('black')
colorm1=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('brown')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')
a=4.0 ;line thick obs
b=3.5 ;line thick model
b=0
ymin=1e-35
plot,lmfull,fmfull/dist^2,xstyle=1,ystyle=1,xrange=[200,900],yrange=[1e-35/dist^2,1e-7/dist^2],/ylog,xcharsize=2.0,ycharsize=2.0,thick=3.5,xthick=3.5,ythick=3.5,$
/nodata,xtitle='Wavelength ['+Angstrom+']',ytitle='Flux [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]',POSITION=[0.18,0.15,0.97,0.99]
;plots,lambda_23mar00_e140m,flux_23mar00_e140mdereddencnvl,linestyle=0,noclip=0,thick=b+3.5,color=coloro
;plots,lambda_17apr01,flux_17apr01dereddencnvl,linestyle=0,noclip=0,thick=b+3.5,color=coloro
plots,lmfull,fmfull/dist^2,color=colorm2,linestyle=0,noclip=0,thick=b+3.5
plots,lmuv,fmuv/dist^2,color=colorm1,linestyle=0,noclip=0,thick=b+3.5
plots,lc1,fc1/dist^2,color=colorm4,linestyle=0,noclip=0,thick=b+3.5

xyouts,0.9,0.2,'(a)',orientation=0,/NORMAL,charsize=2.0

!p.multi=[0, 0, 0, 0, 0]
device,/close

set_plot,'x'
!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0
!Y.charsize=0
!X.charsize=0
!P.THICK=0
!X.THiCK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.MULTI=0
!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0
!P.Background = fsc_color('white')
;save,/variables,FILENAME='/Users/jgroh/temp/ze_etacar_cmfgen_model_obs_optical_full_'+model1+'_'+sufix1+'_'+filename1+'_i'+inc_str1+'.sav'
;vprimcav=cspline(rprim,vprim,rcav)

;lineplot,lmfull,fluxratio
;lineplot,lmfull,fmuv2convi/fmfullconv


END