;PRO ZE_WORK_SN_PROGENITOR_IBC_IPTF13BVN

extinction_bands=[1.532,1.324,1.0,0.748,0.50,1.0,1.025,0.875,0.575,0.282,0.190,0.114,1.35,1.05,0.61] ;U,B,V,R,I,F300w,f555w,f606W,f814W, J, H, K,acsF435,f555,f814; assuming WFPC extinctions from Girardi, and UBVRI from Fitzpatrick 

;SN Ib progenitors from Cao+13
;1) 435W
mf435wiptf13bvn=26.7 ;Cao+13
error_mf435wiptf13bvn=0.2
diptf13bvn=22.49 *1e3 ;in kpc 
sigmadiptf13bvn=3.73*1e3 ;
rviptf13bvn=3.1
ebviptf13bvn=0.0437+0.02878
a435wiptf13bvn=ebviptf13bvn*3.1*extinction_bands[12]
absmagf435wiptf13bvn=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf435wiptf13bvn,diptf13bvn,a435wiptf13bvn,/a_band,/errcalc,error_absmag=error_absmag435wiptf13bvn,$
                                                        error_apparent_mag=error_mf435wiptf13bvn,error_d=sigmadiptf13bvn,error_aband=0.00)

print,absmagf435wiptf13bvn

;2) 555W
mf555wiptf13bvn=26.5 ;Cao+13
error_mf555wiptf13bvn=0.2
diptf13bvn=22.49 *1e3 ;in kpc 
sigmadiptf13bvn=3.73*1e3 ;
rviptf13bvn=3.1
ebviptf13bvn=0.0437+0.02878
a555wiptf13bvn=ebviptf13bvn*3.1*extinction_bands[13]
absmagf555wiptf13bvn=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf555wiptf13bvn,diptf13bvn,a555wiptf13bvn,/a_band,/errcalc,error_absmag=error_absmag555wiptf13bvn,$
                                                        error_apparent_mag=error_mf555wiptf13bvn,error_d=sigmadiptf13bvn,error_aband=0.00)
print,absmagf555wiptf13bvn

;3) 814W
mf814wiptf13bvn=26.4 ;Cao+13
error_mf814wiptf13bvn=0.2
diptf13bvn=22.49 *1e3 ;in kpc 
sigmadiptf13bvn=3.73*1e3 ;
rviptf13bvn=3.1
ebviptf13bvn=0.0437+0.02878
a814wiptf13bvn=ebviptf13bvn*3.1*extinction_bands[14]
absmagf814wiptf13bvn=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814wiptf13bvn,diptf13bvn,a814wiptf13bvn,/a_band,/errcalc,error_absmag=error_absmag814wiptf13bvn,$
                                                        error_apparent_mag=error_mf814wiptf13bvn,error_d=sigmadiptf13bvn,error_aband=0.00)
print,absmagf814wiptf13bvn


;SN Ib progenitor from Eldridge+14
;F435W = 25.80±0.12, F555W = 25.80±0.11, F814W = 25.88±0.24.
;1) 435W
mf435wiptf13bvn=25.80 ;E14
error_mf435wiptf13bvn=0.12
diptf13bvn=22.49 *1e3 ;in kpc 
sigmadiptf13bvn=3.73*1e3 ;
rviptf13bvn=3.1
ebviptf13bvn=0.0437+0.02878
ebviptf13bvn=0.17+0.02878
a435wiptf13bvn=ebviptf13bvn*3.1*extinction_bands[12]
absmagf435wiptf13bvn=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf435wiptf13bvn,diptf13bvn,a435wiptf13bvn,/a_band,/errcalc,error_absmag=error_absmag435wiptf13bvn,$
                                                        error_apparent_mag=error_mf435wiptf13bvn,error_d=sigmadiptf13bvn,error_aband=0.00)

print,'E14 ',absmagf435wiptf13bvn

;2) 555W
mf555wiptf13bvn=25.80 ;Cao+13
error_mf555wiptf13bvn=0.11
diptf13bvn=22.49 *1e3 ;in kpc 
sigmadiptf13bvn=3.73*1e3 ;
rviptf13bvn=3.1
ebviptf13bvn=0.0437+0.02878
ebviptf13bvn=0.17+0.02878
a555wiptf13bvn=ebviptf13bvn*3.1*extinction_bands[13]
absmagf555wiptf13bvn=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf555wiptf13bvn,diptf13bvn,a555wiptf13bvn,/a_band,/errcalc,error_absmag=error_absmag555wiptf13bvn,$
                                                        error_apparent_mag=error_mf555wiptf13bvn,error_d=sigmadiptf13bvn,error_aband=0.00)
print,'E14 ',absmagf555wiptf13bvn

;3) 814W
mf814wiptf13bvn=25.88 ;Cao+13
error_mf814wiptf13bvn=0.24
diptf13bvn=22.49 *1e3 ;in kpc 
sigmadiptf13bvn=3.73*1e3 ;
rviptf13bvn=3.1
ebviptf13bvn=0.0437+0.02878
ebviptf13bvn=0.17+0.02878
a814wiptf13bvn=ebviptf13bvn*3.1*extinction_bands[14]
absmagf814wiptf13bvn=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814wiptf13bvn,diptf13bvn,a814wiptf13bvn,/a_band,/errcalc,error_absmag=error_absmag814wiptf13bvn,$
                                                        error_apparent_mag=error_mf814wiptf13bvn,error_d=sigmadiptf13bvn,error_aband=0.00)
print,'E14 ',absmagf814wiptf13bvn





;testing WO models that are SN Ib progenitors in the 435W band, try and error by changing apparent m until abs mag from G13 is matched; below we have the results:
;50 Msun WO model has MB=-3.15 => m=28.90
;120 Msun WO model has MB=-4.62 => m=27.45
mf435wiptf13bvn=28.90 ;
error_mf435wiptf13bvn=0.0
diptf13bvn=22.49 *1e3 ;in kpc 
sigmadiptf13bvn=3.73*1e3 ;
rviptf13bvn=3.1
ebviptf13bvn=0.0437+0.02878
a435wiptf13bvn=ebviptf13bvn*3.1*extinction_bands[1]
absmagf435wiptf13bvn=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf435wiptf13bvn,diptf13bvn,a435wiptf13bvn,/a_band,/errcalc,error_absmag=error_absmag435wiptf13bvn,$
                                                        error_apparent_mag=error_mf435wiptf13bvn,error_d=sigmadiptf13bvn,error_aband=0.00)
print,'model ',absmagf435wiptf13bvn

;testing WO models in the 555W band, try and error by changing apparent m until abs mag from G13 is matched; below we have the results:
;50 Msun WO model has MV=-3.07 => m=28.90
;120 Msun WO model has MV=-4.15 => m=27.85
mf555wiptf13bvn=27.85
error_mf555wiptf13bvn=0.0
diptf13bvn=22.49 *1e3 ;in kpc 
sigmadiptf13bvn=3.73*1e3 ;
rviptf13bvn=3.1
ebviptf13bvn=0.0437+0.02878
a555wiptf13bvn=ebviptf13bvn*3.1*extinction_bands[2]
absmagf555wiptf13bvn=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf555wiptf13bvn,diptf13bvn,a555wiptf13bvn,/a_band,/errcalc,error_absmag=error_absmag555wiptf13bvn,$
                                                        error_apparent_mag=error_mf555wiptf13bvn,error_d=sigmadiptf13bvn,error_aband=0.00)
print,'model ',absmagf555wiptf13bvn

;testing WO models in the 814W band, try and error by changing apparent m until abs mag from G13 is matched; below we have the results:
;50 Msun WO model has MI=-3.19 => m=28.70
;120 Msun WO model has MI=-4.20 => m=27.70
mf814wiptf13bvn=27.7
error_mf814wiptf13bvn=0.2
diptf13bvn=22.49 *1e3 ;in kpc 
sigmadiptf13bvn=3.73*1e3 ;
rviptf13bvn=3.1
ebviptf13bvn=0.0437+0.02878
a814wiptf13bvn=ebviptf13bvn*3.1*extinction_bands[4]
absmagf814wiptf13bvn=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf814wiptf13bvn,diptf13bvn,a814wiptf13bvn,/a_band,/errcalc,error_absmag=error_absmag814wiptf13bvn,$
                                                        error_apparent_mag=error_mf814wiptf13bvn,error_d=sigmadiptf13bvn,error_aband=0.00)
print,'model ',absmagf814wiptf13bvn


;estimate maximum distance that SN Ic prog could be detected in B 
;maximum MB is 85 rot model => M_B=-3.2 mag
mf435wiptf13bvn=26.70 ;
error_mf435wiptf13bvn=0.0
diptf13bvn=8.4 *1e3 ;in kpc 
sigmadiptf13bvn=3.73*1e3 ;
rviptf13bvn=3.1
ebviptf13bvn=0.0437+0.02878
a435wiptf13bvn=ebviptf13bvn*3.1*extinction_bands[1]
absmagf435wiptf13bvn=ZE_COMPUTE_ABSMAG_FROM_MAG_DIST_RED(mf435wiptf13bvn,diptf13bvn,a435wiptf13bvn,/a_band,/errcalc,error_absmag=error_absmag435wiptf13bvn,$
                                                        error_apparent_mag=error_mf435wiptf13bvn,error_d=sigmadiptf13bvn,error_aband=0.00)
print,'model dist Ic ',absmagf435wiptf13bvn
END