;PRO ZE_WORK_BOLOMETRIC_CORRECTION_LBVS_COMPARE_B_SUPERGIANTS

;calibration BC x Teff from Crowther et al 2006, valid for the range  15500K<Teff<29000K
;BC = 20.15 − 5.13 alog10(Teff)
tcmin=13.
tcmax=30. 
Teff_crowther=tcmin + (1.*indgen(100)*(tcmax-tcmin)/99.)
BC_crowther=20.15 - (5.13 * alog10(Teff_crowther*1000.))

;;calibration BC x Teff from Humphreys and Mcelroy 1984
teff_hum = [29900,28.600,26.300,23.100,21.200,20.260,19.400,18.000,16.300,15.600,13.700]
bc_hum   = [-2.8,  -2.7,  -2.4,  -2.0,  -1.8,  -1.7,  -1.55, -1.35, -1.15, -1.05, -0.82]

;from bessel 1998 table 3 , which comes from kurucz 1993 models
readcol,'/Users/jgroh/espectros/bessel_table3_selec.txt',reckr,teff_kr,logg_kr,bck_kr,bc_kr
teff_kr=teff_kr/1000.


;from tlusty models, Lanz & Hubeny 2007, lowest log g, vturb=10 km/s
teff_tl = [  30.,  29.,  28.,  27.,  26.,  25.,  24.,  23.,  22.,  21.,  20.,  19.,  18.,  17.,  16.,  15.]
bc_tl   = [-2.92,-2.79,-2.67,-2.57,-2.53,-2.40,-2.29,-2.18,-2.10,-1.97,-1.92,-1.76,-1.62,-1.53,-1.38,-1.29]
 
;AG Teff, Tstar, and BC from Groh et al 2009 Paper I
Teff_agc  = [22.800 ,22.800 ,21.500 ,17.000 ,16.400 ,14.000 ,14.300] 
Tstar_agc = [26.450,26.200,24.640,21.900,18.700,16.650, 17.420]
BC_agc    = [-2.50,-2.52,-2.23,-2.15,-1.68,-1.28,-1.22]  

diff_BCagc_BCc=dblarr(n_elements(teff_agc))
for i=0, n_elements(teff_agc)-1 DO BEGIN
nearmin=MIN(ABS(teff_agc[i]-teff_crowther),indexmin)
diff_BCagc_BCc[i]=bc_agc[i]-bc_crowther(indexmin)
ENDFOR

window,0
plot, Teff_crowther,BC_crowther,xstyle=1,ystyle=1,xrange=[13.000,30.000],yrange=[-0.8,-3.2],/NODATA,xtitle='Effective Temperature [kK]',ytitle='BC V-band [mag]' 
plots,Teff_crowther,BC_crowther
plots,Teff_agc,BC_agc,psym=1,color=fsc_color('red')
;plots,Tstar_agc,BC_agc,psym=2,color=fsc_color('red')
;plots,teff_hum,bc_hum,color=fsc_color('blue'),psym=1,noclip=0
plots,teff_hum,bc_hum,color=fsc_color('blue'),linestyle=1,noclip=0
;plots,teff_tl,bc_tl,color=fsc_color('dark green'),psym=1,noclip=0
plots,teff_tl,bc_tl,color=fsc_color('dark green'),linestyle=2,noclip=0
;plots,teff_kr,bc_kr,color=fsc_color('purple'),psym=1,noclip=0
plots,teff_kr,bc_kr,color=fsc_color('purple'),linestyle=3,noclip=0
END