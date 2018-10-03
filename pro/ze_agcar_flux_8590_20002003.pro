Angstrom = '!6!sA!r!u!9 % !6!n'
sun = '!D!9n!3!N'
close,/all
obsdir='/Users/jgroh/espectros/agcar/'
readcol,obsdir+'agc_minimum_ubvyVjhkl_flux_allepochs.txt',jd_av,yr_frac_av,u_av,v_av,b_av,y_av,yr_av,$
month_av,day_av, near2,flux_uav, flux_vav, flux_bav, flux_yav, flux_vbandav,flux_visualav, flux_jav, flux_hav, flux_kav, fluxl_av

readcol,obsdir+'agc_uv_flux_continuum_89dec.txt',lambdauv89d,fluxuv89d

lambda=[3491,4111 ,4662 ,5456,5500,5500,12500,16000,22200,35400]
lambda1=lambda ;lambda vector where the asas v values are crappy, and have to be removed further
lambda2=lambda ;lambda vector where the uvby values are crappy, and have to be removed further
lambda3=lambda ;lambda vector where the uvby and asas v values are crappy, and have to be removed further

model93car=obsdir+'93_car6_ebv65r35.txt'
model191car=obsdir+'191_car_ebv65r35.txt'
model198car=obsdir+'198_car_ebv65r35.txt'
model220car=obsdir+'220_car_ebv65r35.txt'
model222car=obsdir+'222_car_ebv65r35.txt'
model223car=obsdir+'223_car6_ebv65r35.txt'
model234car=obsdir+'234_car6_ebv65r35.txt'
model251car=obsdir+'251_car6_ebv65r35.txt'
model254car=obsdir+'254_car6_ebv65r35.txt'
model256car=obsdir+'256_car6_ebv65r35.txt'
model258car=obsdir+'258_car6_ebv65r35.txt'
model264car=obsdir+'264_car6_ebv65r35.txt'
model270car=obsdir+'270_car6_ebv65r35.txt'
model271car=obsdir+'271_car6_ebv65r35.txt'
model371car=obsdir+'371_car6_ebv65r35.txt'
model373car=obsdir+'373_car6_ebv65r35.txt'
model378car=obsdir+'378_car6_ebv65r35.txt'
model381car=obsdir+'381_car6_ebv65r35.txt'
model382car=obsdir+'382_car_ebv65r35.txt'
model394car='/Users/jgroh/espectros/agcar/394_car_ebv65r35.txt'
model389car='/Users/jgroh/espectros/agcar/389_car_ebv65r35.txt'
model395car='/Users/jgroh/espectros/agcar/395_car_ebv65r35.txt'
model400car='/Users/jgroh/espectros/agcar/400_car6_ebv65r35.txt'
model405car='/Users/jgroh/espectros/agcar/405_car6_ebv65r35.txt'
model408car='/Users/jgroh/espectros/agcar/408_car6_ebv65r35.txt'
model409car='/Users/jgroh/espectros/agcar/409_car6_ebv65r35.txt'
model410car='/Users/jgroh/espectros/agcar/410_car6_ebv65r35.txt'
model411car='/Users/jgroh/espectros/agcar/411_car6_ebv65r35.txt'
model413car='/Users/jgroh/espectros/agcar/413_car_ebv65r35.txt'
model414car='/Users/jgroh/espectros/agcar/414_car_ebv65r35.txt'
model416car='/Users/jgroh/espectros/agcar/416_car6_ebv65r35.txt'
model417car='/Users/jgroh/espectros/agcar/417_car6_ebv65r35.txt'
model418car='/Users/jgroh/espectros/agcar/418_car6_ebv65r35.txt'
model420car='/Users/jgroh/espectros/agcar/420_car_ebv65r35.txt'
model421car='/Users/jgroh/espectros/agcar/421_car_ebv65r35.txt'
model427car='/Users/jgroh/espectros/agcar/427_car6_ebv65r35.txt'
model431car='/Users/jgroh/espectros/agcar/431_car6_ebv65r35.txt'
model432car='/Users/jgroh/espectros/agcar/432_car6_ebv65r35.txt'
model433car='/Users/jgroh/espectros/agcar/433_car6_ebv65r35.txt'
model435car='/Users/jgroh/espectros/agcar/435_car6_ebv65r35.txt'
model436car='/Users/jgroh/espectros/agcar/436_car6_ebv65r35.txt'
model437car='/Users/jgroh/espectros/agcar/437_car6_ebv65r35.txt'
model191varmdot8=obsdir+'var_191_regrid_223_mdot8_car_ebv65r35.txt'

;ZE_READ_SPECTRA_COL_VEC,model389car,l389car,f389car
;ZE_READ_SPECTRA_COL_VEC,model395car,l395car,f395car
;ZE_READ_SPECTRA_COL_VEC,model191car,l191car,f191car
;ZE_READ_SPECTRA_COL_VEC,model198car,l198car,f198car
;ZE_READ_SPECTRA_COL_VEC,model220car,l220car,f220car
ZE_READ_SPECTRA_COL_VEC,model223car,l223car,f223car
;ZE_READ_SPECTRA_COL_VEC,model222car,l222car,f222car
ZE_READ_SPECTRA_COL_VEC,model234car,l234car,f234car
ZE_READ_SPECTRA_COL_VEC,model251car,l251car,f251car ;02 november
ZE_READ_SPECTRA_COL_VEC,model254car,l254car,f254car ;03 jan Teff=13060
ZE_READ_SPECTRA_COL_VEC,model256car,l256car,f256car;03 Jan Teff=13750
ZE_READ_SPECTRA_COL_VEC,model258car,l258car,f258car ;03 Jan Teff=13870
;ZE_READ_SPECTRA_COL_VEC,model264car,l264car,f264car ;01apr does not exist ?
;ZE_READ_SPECTRA_COL_VEC,model191varmdot8,l191carv8,f191carv8
ZE_READ_SPECTRA_COL_VEC,model270car,l270car,f270car
ZE_READ_SPECTRA_COL_VEC,model271car,l271car,f271car
ZE_READ_SPECTRA_COL_VEC,model371car,l371car,f371car
ZE_READ_SPECTRA_COL_VEC,model373car,l373car,f373car
ZE_READ_SPECTRA_COL_VEC,model378car,l378car,f378car
ZE_READ_SPECTRA_COL_VEC,model381car,l381car,f381car   ;03jan 1E6
ZE_READ_SPECTRA_COL_VEC,model382car,l382car,f382car   ;02 Mar 1E6
ZE_READ_SPECTRA_COL_VEC,model400car,l400car,f400car
ZE_READ_SPECTRA_COL_VEC,model410car,l410car,f410car
ZE_READ_SPECTRA_COL_VEC,model405car,l405car,f405car
ZE_READ_SPECTRA_COL_VEC,model408car,l408car,f408car
ZE_READ_SPECTRA_COL_VEC,model409car,l409car,f409car
ZE_READ_SPECTRA_COL_VEC,model411car,l411car,f411car
;ZE_READ_SPECTRA_COL_VEC,model413car,l413car,f413car
;ZE_READ_SPECTRA_COL_VEC,model414car,l414car,f414car
;ZE_READ_SPECTRA_COL_VEC,model416car,l416car,f416car
;ZE_READ_SPECTRA_COL_VEC,model417car,l417car,f417car
;ZE_READ_SPECTRA_COL_VEC,model418car,l418car,f418car
ZE_READ_SPECTRA_COL_VEC,model420car,l420car,f420car   ;02 March 1.5 E6
ZE_READ_SPECTRA_COL_VEC,model421car,l421car,f421car   ;03 January 1.5 E6
;ZE_READ_SPECTRA_COL_VEC,model427car,l427car,f427car
ZE_READ_SPECTRA_COL_VEC,model431car,l431car,f431car   ;02 Mar 0.7E6
ZE_READ_SPECTRA_COL_VEC,model432car,l432car,f432car   ;89 mar L1.5 f=0.05
ZE_READ_SPECTRA_COL_VEC,model433car,l433car,f433car   ;89 mar L1.5 f=0.25
ZE_READ_SPECTRA_COL_VEC,model435car,l435car,f435car   ;01 Apr 2.2E6
ZE_READ_SPECTRA_COL_VEC,model436car,l436car,f436car   ;01 Apr 2.2E6
ZE_READ_SPECTRA_COL_VEC,model437car,l437car,f437car   ;01 Apr 2.2E6

l409car=l270car
f409car=f270car

f86jun=[flux_uav[2], flux_vav[2], flux_bav[2], flux_yav[2], flux_vbandav[2],flux_visualav[2], flux_jav[2], flux_hav[2], flux_kav[2], fluxl_av[2]]
f89mar=[flux_uav[7], flux_vav[7], flux_bav[7], flux_yav[7], flux_vbandav[7],flux_visualav[7], flux_jav[7], flux_hav[7], flux_kav[7], fluxl_av[7]]
f89dec=[flux_uav[8], flux_vav[8], flux_bav[8], flux_yav[8], flux_vbandav[8],flux_visualav[8], flux_jav[8], flux_hav[8], flux_kav[8], fluxl_av[8]]
f90jun=[flux_uav[10], flux_vav[10], flux_bav[10], flux_yav[10], flux_vbandav[10],flux_visualav[10], flux_jav[10], flux_hav[10], flux_kav[10], fluxl_av[10]]
f90dec=[flux_uav[14], flux_vav[14], flux_bav[14], flux_yav[14], flux_vbandav[14],flux_visualav[14], flux_jav[14], flux_hav[14], flux_kav[14], fluxl_av[14]]

f00jul=[flux_uav[19], flux_vav[19], flux_bav[19], flux_yav[19], flux_vbandav[19],flux_visualav[19], flux_jav[19], flux_hav[19], flux_kav[19], fluxl_av[19]]

f00dec=[flux_uav[20], flux_vav[20], flux_bav[20], flux_yav[20], flux_vbandav[20],flux_visualav[20], flux_jav[20], flux_hav[20], flux_kav[20], fluxl_av[20]]
f01jan=[flux_uav[21], flux_vav[21], flux_bav[21], flux_yav[21], flux_vbandav[21],flux_visualav[21], flux_jav[21], flux_hav[21], flux_kav[21], fluxl_av[21]]
f01apr=[flux_uav[22], flux_vav[22], flux_bav[22], flux_yav[22], flux_vbandav[22],flux_visualav[22], flux_jav[22], flux_hav[22], flux_kav[22], fluxl_av[22]]
f01may=[flux_uav[23], flux_vav[23], flux_bav[23], flux_yav[23], flux_vbandav[23],flux_visualav[23], flux_jav[23], flux_hav[23], flux_kav[23], fluxl_av[23]]
f01jun=[flux_uav[24], flux_vav[24], flux_bav[24], flux_yav[24], flux_vbandav[24],flux_visualav[24], flux_jav[24], flux_hav[24], flux_kav[24], fluxl_av[24]]
f02mar=[flux_uav[26], flux_vav[26], flux_bav[26], flux_yav[26], flux_vbandav[26],flux_visualav[26], flux_jav[26], flux_hav[26], flux_kav[26], fluxl_av[26]]
f02apr=[flux_uav[27], flux_vav[27], flux_bav[27], flux_yav[27], flux_vbandav[27],flux_visualav[27], flux_jav[27], flux_hav[27], flux_kav[27], fluxl_av[27]]
f02jul=[flux_uav[28], flux_vav[28], flux_bav[28], flux_yav[28], flux_vbandav[28],flux_visualav[28], flux_jav[28], flux_hav[28], flux_kav[28], fluxl_av[28]]
f02nov=[flux_uav[30], flux_vav[30], flux_bav[30], flux_yav[30], flux_vbandav[30],flux_visualav[30], flux_jav[30], flux_hav[30], flux_kav[30], fluxl_av[30]]
f03jan=[flux_uav[31], flux_vav[31], flux_bav[31], flux_yav[31], flux_vbandav[31],flux_visualav[31], flux_jav[31], flux_hav[31], flux_kav[31], fluxl_av[31]]

f01mayfuv=[1.94e-12]
l01mayfuv=[1178]

remove,[4,5],f86jun,f89mar,f89dec,f90jun,f90dec
remove,[4,5],lambda1

remove,[0,1,2,3,5],f00dec,f01jan,f01apr,f01may,f01jun,f02mar
remove,[0,1,2,3,5],f02apr,f02jul,f02nov,f03jan
remove,[0,1,2,3,5],lambda2

lambda_vis=lambda[5]
f00jul_vis=f00jul[5]
remove,[0,1,2,3,4,5],lambda3,f00jul

;LOADCT,0
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;window,1,xsize=1200,ysize=900

set_plot,'ps'
device,filename='/Users/jgroh/temp/output_flux_paper_lum_minimum_all.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches

!p.multi=[0,4,4]
!x.omargin=[5,10]
!y.omargin=[3,4]
xm1=8
xm2=-8 

ym1=3
ym2=-3

x1=1000
x2=38000
y1=2E-14
y2=2E-11
pos_leg=4e-12
pos_legx=10000
p1=!p.multi[1]
p2=!p.multi[2]
i=1

cax=1.7
cs=1.
posleg=1.0e-14


min_factor=0.5
max_factor=1.1

err=0.1 ;relative error in luminosity i.e. 10 %
lum_factor89min=err*3
lum_factor89max=err*3
symtype=2
ss=0.5 ;symsize
symthick=3.7
;lum_factor89max=1

f435i=cspline(l435car,f435car,l409car)
f435iesc=f409car+(f435i-f409car)*lum_factor89max

plot,lambda1,f86jun,/xlog,/ylog,xstyle=1,ystyle=1,/NOERASE,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],XTICKFORMAT='(A1)'
ze_colorfill,low=x1,high=38000,ymin=f409car - (f409car-cspline(l223car,f223car,l409car))*lum_factor89min, ymax=f435iesc,$
x=l409car,yvals=f409car
plot,lambda1,f86jun,/xlog,/ylog,xstyle=1,/NOERASE,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
ytitle='',/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],XTICKFORMAT='(A1)'
plots,lambda1,f86jun,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,lambdauv89d,fluxuv89d,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l409car,f409car,color=fsc_color('black'), noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 89 mar, L=1.5E6
plots,l223car,f223car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89 mar, L=1E6
;plots,l436car,f436car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89Mar, L=2.2E6
plots,l435car,f435car,color=fsc_color('dark green'), noclip=0,clip=[x1,0,x2,13],linestyle=4,thick=1.7 ;for 89Mar, L=2.2E6
xyouts,pos_legx,pos_leg,'86 Jun',color=fsc_color('black')
!p.multi[0]=(p1*p2)-i
i=i+1

plot,lambda1,f89mar,/xlog,/ylog,xstyle=1,ystyle=1,/NOERASE,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)'
ze_colorfill,low=x1,high=38000,ymin=f409car - (f409car-cspline(l223car,f223car,l409car))*lum_factor89min, ymax=f435iesc,$
x=l409car,yvals=f409car
plot,lambda1,f89mar,/xlog,/ylog,xstyle=1,/NOERASE,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)'
plots,lambda1,f89mar,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,lambdauv89d,fluxuv89d,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l409car,f409car,color=fsc_color('black'), noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 89 mar L=1.5E6
plots,l223car,f223car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89 mar, L=1E6
plots,l435car,f435car,color=fsc_color('dark green'), noclip=0,clip=[x1,0,x2,13],linestyle=4,thick=1.7 ;for 89Mar, L=2.2E6
;plots,l432car,f432car,color=fsc_color('orange'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89Mar, L=1.5E6 f=0.05
;plots,l433car,f433car,color=fsc_color('purple'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89Mar, L=1.5E6 f=0.25
xyouts,pos_legx,pos_leg,'89 Mar',color=fsc_color('black')
;plots,l408car,f408car,color=fsc_color('black'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89
!p.multi[0]=(p1*p2)-i
i=i+1

plot,lambda1,f89dec,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
ze_colorfill,low=x1,high=38000,ymin=f409car - (f409car-cspline(l223car,f223car,l409car))*lum_factor89min, ymax=f435iesc,$
x=l409car,yvals=f409car
plot,lambda1,f89dec,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
plots,lambda1,f89dec,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,lambdauv89d,fluxuv89d,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l409car,f409car,color=fsc_color('black'), noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 89
plots,l223car,f223car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89 mar, L=1E6
plots,l435car,f435car,color=fsc_color('dark green'), noclip=0,clip=[x1,0,x2,13],linestyle=4,thick=1.7 ;for 89Mar, L=2.2E6
xyouts,pos_legx,pos_leg,'89 Dec',color=fsc_color('black')
!p.multi[0]=(p1*p2)-i
i=i+1

plot,lambda1,f90jun,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
ze_colorfill,low=x1,high=38000,ymin=f409car - (f409car-cspline(l223car,f223car,l409car))*lum_factor89min, ymax=f435iesc,$
x=l409car,yvals=f409car
plot,lambda1,f90jun,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
plots,lambda1,f90jun,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,lambdauv89d,fluxuv89d,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l409car,f409car,color=fsc_color('black'), noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 89
plots,l223car,f223car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89 mar, L=1E6
plots,l435car,f435car,color=fsc_color('dark green'), noclip=0,clip=[x1,0,x2,13],linestyle=4,thick=1.7 ;for 89Mar, L=2.2E6
xyouts,pos_legx,pos_leg,'90 Jun',color=fsc_color('black')
!p.multi[0]=(p1*p2)-i
i=i+1

plot,lambda1,f90dec,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
ytitle='',/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],XTICKFORMAT='(A1)',/NOERASE
ze_colorfill,low=x1,high=38000,ymin=f405car*1.1 - (f405car*1.1-cspline(l223car,f223car*1.2,l405car))*lum_factor89min, ymax=f405car*1.1*1.1,$
x=l405car,yvals=f405car*1.1
plot,lambda1,f90dec,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
ytitle=TEXTOIDL('Flux [erg s^{-1} cm^{-2} ')+Angstrom+'!E-1!N]',/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],XTICKFORMAT='(A1)',/NOERASE
plots,lambda1,f90dec,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,lambdauv89d,fluxuv89d,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l405car,f405car*1.1,color=fsc_color('black'), noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 89
plots,l223car,f223car*1.2,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89 mar, L=1E6
plots,l405car,f405car*1.5,color=fsc_color('dark green'), noclip=0,clip=[x1,0,x2,13],linestyle=4,thick=1.7 ;for 89
xyouts,pos_legx,pos_leg,'90 Dec',color=fsc_color('black')
!p.multi[0]=(p1*p2)-i
i=i+1

lum_factor01apr=0.4
f373i=cspline(l373car,f373car,l378car)
f373iesc=f378car+(f373i-f378car)*lum_factor01apr
f271i=cspline(l271car,f271car,l378car)
f271iesc=f378car-(f378car-f271i)*lum_factor01apr

plot,lambda3,f00jul,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
ze_colorfill,low=x1,high=38000,ymin=f271iesc, ymax=f373iesc, x=l378car,yvals=f378car
plot,lambda3,f00jul,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
plots,lambda3,f00jul,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,lambda_vis,f00jul_vis,color=fsc_color('red'),noclip=0,psym=4,thick=1.7,symsize=ss
;oploterror,lambda_vis,f00jul_vis,[0,0],[0.40e-12,0.45e-12],psym=2,color=fsc_color('red'),ERRCOLOR=fsc_color('red'),thick=1.7
plots,l271car,f271car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89
plots,l373car,f373car,color=fsc_color('dark green'), noclip=0,clip=[x1,0,x2,13],linestyle=4,thick=1.7 ;for 89 mar, L=1E6
plots,l378car,f378car,color=fsc_color('black'), noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 89 mar, L=1E6
xyouts,pos_legx,pos_leg,'00 Jul',color=fsc_color('black')
!p.multi[0]=(p1*p2)-i
i=i+1

plot,lambda2,f00dec,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
ze_colorfill,low=x1,high=38000,ymin=f271iesc, ymax=f373iesc, x=l378car,yvals=f378car
plot,lambda2,f00dec,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
plots,lambda2,f00dec,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l271car,f271car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89
plots,l373car,f373car,color=fsc_color('dark green'), noclip=0,clip=[x1,0,x2,13],linestyle=4,thick=1.7 ;for 89 mar, L=1E6
plots,l378car,f378car,color=fsc_color('black'), noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 89 mar, L=1E6
xyouts,pos_legx,pos_leg,'00 Dec',color=fsc_color('black')
!p.multi[0]=(p1*p2)-i
i=i+1

plot,lambda2,f01jan,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
ze_colorfill,low=x1,high=38000,ymin=f271iesc, ymax=f373iesc, x=l378car,yvals=f378car
plot,lambda2,f01jan,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
plots,lambda2,f01jan,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l271car,f271car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89
plots,l373car,f373car,color=fsc_color('dark green'), noclip=0,clip=[x1,0,x2,13],linestyle=4,thick=1.7 ;for 89 mar, L=1E6
plots,l378car,f378car,color=fsc_color('black'), noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 89 mar, L=1E6
;plots,l234car,f234car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89 mar, L=1E6
xyouts,pos_legx,pos_leg,'01 Jan',color=fsc_color('black')
!p.multi[0]=(p1*p2)-i
i=i+1

plot,lambda2,f01apr,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
ytitle='',/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],XTICKFORMAT='(A1)',/NOERASE
ze_colorfill,low=x1,high=38000,ymin=f271iesc, ymax=f373iesc, x=l378car,yvals=f378car
plot,lambda2,f01apr,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
ytitle='',/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],XTICKFORMAT='(A1)',/NOERASE
plots,lambda2,f01apr,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l271car,f271car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89
plots,l373car,f373car,color=fsc_color('dark green'), noclip=0,clip=[x1,0,x2,13],linestyle=4,thick=1.7 ;for 89 mar, L=1E6
plots,l378car,f378car,color=fsc_color('black'), noclip=0,clip=[x1,0,x2,13],linestyle=4,thick=1.7 ;for 89 mar, L=1E6
xyouts,pos_legx,pos_leg,'01 Apr',color=fsc_color('black')
!p.multi[0]=(p1*p2)-i
i=i+1

plot,lambda2,f01may,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
ze_colorfill,low=x1,high=38000,ymin=f271iesc, ymax=f373iesc, x=l378car,yvals=f378car
plot,lambda2,f01may,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
plots,lambda2,f01may,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l01mayfuv,f01mayfuv,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l271car,f271car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89
plots,l373car,f373car,color=fsc_color('dark green'), noclip=0,clip=[x1,0,x2,13],linestyle=4,thick=1.7 ;for 89 mar, L=1E6
plots,l378car,f378car,color=fsc_color('black'), noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 89 mar, L=1E6
xyouts,pos_legx,pos_leg,'01 May',color=fsc_color('black')
!p.multi[0]=(p1*p2)-i
i=i+1

plot,lambda2,f01jun,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
ze_colorfill,low=x1,high=38000,ymin=f271iesc, ymax=f373iesc, x=l378car,yvals=f378car
plot,lambda2,f01jun,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
plots,lambda2,f01jun,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l271car,f271car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 89
plots,l373car,f373car,color=fsc_color('dark green'), noclip=0,clip=[x1,0,x2,13],linestyle=4,thick=1.7 ;for 89 mar, L=1E6
plots,l378car,f378car,color=fsc_color('black'), noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 89 mar, L=1E6
xyouts,pos_legx,pos_leg,'01 Jun',color=fsc_color('black')
!p.multi[0]=(p1*p2)-i
i=i+1

lum_factor02mar=0.3
f420i=cspline(l420car,f420car,l382car)
f420iesc=f382car+(f420i-f382car)*lum_factor02mar

color07=fsc_color('purple')
color10=fsc_color('blue')
color15=fsc_color('black')

plot,lambda2,f02mar,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
ze_colorfill,low=x1,high=38000,ymin=f382car - (f382car-cspline(l431car,f431car,l382car))*lum_factor02mar, ymax=f420iesc,$
x=l382car,yvals=f382car
plot,lambda2,f02mar,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle='', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
plots,lambda2,f02mar,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l382car,f382car,color=color10, noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 02mar, L=1e6
plots,l431car,f431car,color=color07, noclip=0,clip=[x1,0,x2,13],linestyle=2,thick=1.7 ;for 02 mar, L=0.7E6
plots,l420car,f420car,color=color15, noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 02 mar, L=1.5E6
xyouts,pos_legx,pos_leg,'02 Mar',color=fsc_color('black')
!p.multi[0]=(p1*p2)-i
i=i+1

plot,lambda2,f02apr,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle=TEXTOIDL('Wavelength')+' ['+Angstrom+']', $
ytitle='',/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],XTICKFORMAT='(A1)',/NOERASE
ze_colorfill,low=x1,high=38000,ymin=f382car - (f382car-cspline(l431car,f431car,l382car))*lum_factor02mar, ymax=f420iesc,$
x=l382car,yvals=f382car
plot,lambda2,f02apr,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle=TEXTOIDL('Wavelength')+' ['+Angstrom+']', $
ytitle='',/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],XTICKFORMAT='(A1)',/NOERASE
plots,lambda2,f02apr,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l382car,f382car,color=color10, noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 02mar, L=1e6
plots,l431car,f431car,color=color07, noclip=0,clip=[x1,0,x2,13],linestyle=2,thick=1.7 ;for 02 mar, L=0.7E6
plots,l420car,f420car,color=color15, noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 02 mar, L=1.5E6
xyouts,pos_legx,pos_leg,'02 Apr',color=fsc_color('black')
xyouts,1000,posleg,'1000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
xyouts,3000,posleg,'3000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
;xyouts,5000,posleg,'5000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
xyouts,10000,posleg,'10000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
;xyouts,20000,posleg,'20000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
!p.multi[0]=(p1*p2)-i
i=i+1

plot,lambda2,f02jul,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle=TEXTOIDL('Wavelength')+' ['+Angstrom+']', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
ze_colorfill,low=x1,high=38000,ymin=f382car - (f382car-cspline(l431car,f431car,l382car))*lum_factor02mar, ymax=f420iesc,$
x=l382car,yvals=f382car
plot,lambda2,f02jul,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle=TEXTOIDL('Wavelength')+' ['+Angstrom+']', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
plots,lambda2,f02jul,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l382car,f382car,color=color10, noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 02mar, L=1e6
plots,l431car,f431car,color=color07, noclip=0,clip=[x1,0,x2,13],linestyle=2,thick=1.7 ;for 02 mar, L=0.7E6
plots,l420car,f420car,color=color15, noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 02 mar, L=1.5E6
xyouts,pos_legx,pos_leg,'02 Jul',color=fsc_color('black')
xyouts,1000,posleg,'1000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
xyouts,3000,posleg,'3000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
;xyouts,5000,posleg,'5000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
xyouts,10000,posleg,'10000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
;xyouts,20000,posleg,'20000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
!p.multi[0]=(p1*p2)-i
i=i+1

lum_factor03jan=0.2
f420i=cspline(l420car,f420car,l382car)
f420iesc=f382car+(f420i-f382car)*lum_factor02mar

plot,lambda2,f02nov,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle=TEXTOIDL('Wavelength')+' ['+Angstrom+']', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
ze_colorfill,low=x1,high=38000,ymin=f258car*0.98, ymax=f258car*1.3, x=l258car,yvals=f258car*1.1
plot,lambda2,f02nov,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle=TEXTOIDL('Wavelength')+' ['+Angstrom+']', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
plots,lambda2,f02nov,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l258car,f258car*0.8,color=color07, noclip=0,clip=[x1,0,x2,13],linestyle=2,thick=1.7 ;for 02mar, L=1e6
plots,l258car,f258car*1.1,color=color10, noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 02mar, L=1e6
;plots,l431car,f431car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 02 mar, L=0.7E6
plots,l421car,f421car*1.2,color=color15, noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 02 mar, L=0.7E6
xyouts,pos_legx+2000,pos_leg,'02 Nov',color=fsc_color('black')
xyouts,1000,posleg,'1000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
xyouts,3000,posleg,'3000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
;xyouts,5000,posleg,'5000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
xyouts,10000,posleg,'10000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
;xyouts,20000,posleg,'20000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
!p.multi[0]=(p1*p2)-i
i=i+1

plot,lambda2,f03jan,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle=TEXTOIDL('Wavelength')+' ['+Angstrom+']', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
ze_colorfill,low=x1,high=38000,ymin=f258car*1.2, ymax=f258car*1.6, x=l258car,yvals=f258car*1.4
plot,lambda2,f03jan,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],xtitle=TEXTOIDL('Wavelength')+' ['+Angstrom+']', $
/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],YTICKFORMAT='(A1)',XTICKFORMAT='(A1)',/NOERASE
plots,lambda2,f03jan,color=fsc_color('red'),noclip=0,psym=symtype,thick=symtick,symsize=ss
plots,l258car,f258car*1.0,color=color07, noclip=0,clip=[x1,0,x2,13],linestyle=2,thick=1.7 ;for 03jan, L=1e6
plots,l258car,f258car*1.4,color=fsc_color('green'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 03jan, L=1e6
plots,l258car,f258car*2.0,color=color15, noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=1.7 ;for 03jan, L=1e6
;plots,l256car,f256car*1.1,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 02 mar, L=0.7E6
;plots,l421car,f421car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=1.7 ;for 03 jan, L=1.5E6
xyouts,pos_legx+2500,pos_leg,'03 Jan',color=fsc_color('black')
xyouts,1000,posleg,'1000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
xyouts,3000,posleg,'3000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
;xyouts,5000,posleg,'5000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
xyouts,10000,posleg,'10000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
;xyouts,20000,posleg,'20000',color=fsc_color('black'),charsize=cs,align=0.5,charthick=cax
!p.multi[0]=(p1*p2)-i
i=i+1

device,/close

device,filename='/Users/jgroh/temp/output_for_talk_lbol_der90j.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches
!X.THICK=2.5
!Y.THICK=2.5
!Y.OMARGIN=[1,0]
!p.multi=0
xm1=5
xm2=-9
ym1=3
ym2=1
ymin=5.0
ymax=7.0
x1l=4.7
x1u=3.5
m1=3. ; total length is m1 + m2
t=3
tb=2.5
a=0.77 ;scale factor
x1=1000
x2=38000
y1=2E-14
y2=1E-11

plot,lambda1,f90jun,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2], $
ytitle=TEXTOIDL('Flux [erg s^{-1} cm^{-2} ')+Angstrom+'!E-1!N]',/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],XTICKFORMAT='(A2)',xtitle=TEXTOIDL('Wavelength')+' ['+Angstrom+']', /NOERASE
ze_colorfill,low=1000,high=38000,ymin=f409car - (f409car-cspline(l223car,f223car,l409car))*lum_factor89min, ymax=f435iesc,$
x=l409car,yvals=f409car1
plot,lambda1,f90jun,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],$
ytitle=TEXTOIDL('Flux [erg s^{-1} cm^{-2} ')+Angstrom+'!E-1!N]',/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],XTICKFORMAT='(A2)',xtitle=TEXTOIDL('Wavelength')+' ['+Angstrom+']', /NOERASE
plots,lambdauv89d,fluxuv89d,color=fsc_color('red'),noclip=0,psym=symtype,thick=2.7
plots,lambda1,f90jun,color=fsc_color('red'),noclip=0,psym=symtype,thick=2.7
plots,l409car,f409car,color=fsc_color('black'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=2.7 ;for 89
plots,l223car,f223car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=2,thick=2.7 ;for 89 mar, L=1E6
plots,l435car,f435car,color=fsc_color('dark green'), noclip=0,clip=[x1,0,x2,13],linestyle=4,thick=2.7 ;for 89Mar, L=2.2E6
xyouts,9000,pos_leg+2.5e-12,'obs 1990 June',color=fsc_color('black'),charsize=2.0,charthick=2.5

plots,8000,pos_leg+3.0e-12,psym=symtype,thick=2.7,color=fsc_color('red')
xyouts,9000,pos_leg-0e-12,TEXTOIDL('L=1.5\times10^6 L')+sun+' ,',color=fsc_color('black'),charsize=2.0,charthick=2.5
xyouts,9000,pos_leg-1.3e-12,TEXTOIDL('E(B-V)=0.65,R_V=3.5'),color=fsc_color('black'),charsize=1.5,charthick=3.5
xyouts,1000,1.5e-14,'1000',color=fsc_color('black'),charsize=1.7,align=0.5,charthick=4.5
xyouts,2000,1.5e-14,'2000',color=fsc_color('black'),charsize=1.7,align=0.5,charthick=4.5
xyouts,5000,1.5e-14,'5000',color=fsc_color('black'),charsize=1.7,align=0.5,charthick=4.5
xyouts,10000,1.5e-14,'10000',color=fsc_color('black'),charsize=1.7,align=0.5,charthick=4.5
xyouts,20000,1.5e-14,'20000',color=fsc_color('black'),charsize=1.7,align=0.5,charthick=4.5
device,/close

device,filename='/Users/jgroh/temp/output_for_talk_lbol_der02m.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches
!X.THICK=2.0
!Y.THICK=2.0
!P.CHARTHICK=2.0
!Y.OMARGIN=[1,0]
!p.multi=0
xm1=5
xm2=-9
ym1=3
ym2=1
ymin=5.0
ymax=7.0
x1l=4.7
x1u=3.5
m1=3. ; total length is m1 + m2
t=3
tb=2.5
a=0.77 ;scale factor
x1=3000
x2=38000
y1=2E-14
y2=1E-11

plot,lambda2,f02mar,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2], $
ytitle='',/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],XTICKFORMAT='(A2)',xtitle='', /NOERASE
ze_colorfill,low=3000,high=38000,ymin=f382car - (f382car-cspline(l431car,f431car,l382car))*lum_factor02mar, ymax=f420iesc,$
x=l382car,yvals=f382car
plot,lambda2,f02mar,/xlog,/ylog,xstyle=1,ystyle=1,xrange=[x1,x2],yrange=[y1,y2],$
ytitle=TEXTOIDL('Flux [erg s^{-1} cm^{-2} ')+Angstrom+'!E-1!N]',/nodata,charsize=2,XMARGIN=[xm1,xm2],YMARGIN=[ym1,ym2],XTICKFORMAT='(A2)',xtitle=TEXTOIDL('Wavelength')+' ['+Angstrom+']', /NOERASE

plots,lambda2,f02mar,color=fsc_color('red'),noclip=0,psym=symtype,thick=2.7
plots,l382car,f382car,color=fsc_color('blue'), noclip=0,clip=[x1,0,x2,13],linestyle=2,thick=2.7 ;for 02mar, L=1e6
plots,l431car,f431car,color=fsc_color('purple'), noclip=0,clip=[x1,0,x2,13],linestyle=3,thick=2.7 ;for 02 mar, L=0.7E6
plots,l420car,f420car,color=fsc_color('black'), noclip=0,clip=[x1,0,x2,13],linestyle=0,thick=2.7 ;for 02 mar, L=1.5E6

pos_leg=4e-12
pos_legx=10000
p1=!p.multi[1]
p2=!p.multi[2]
i=1

cax=1.7
cs=1.
posleg=1.0e-14

xyouts,14000,pos_leg+2.5e-12,'obs 2002 Mar',color=fsc_color('black'),charsize=2.0,charthick=2.5

plots,13000,pos_leg+3e-12,psym=symtype,thick=2.7,color=fsc_color('red')
xyouts,14000,pos_leg-0e-12,TEXTOIDL('L=1.0\times10^6 L')+sun+' ,',color=fsc_color('black'),charsize=2.0,charthick=2.5
xyouts,14000,pos_leg-1.3e-12,TEXTOIDL('E(B-V)=0.65,R_V=3.5'),color=fsc_color('black'),charsize=1.5,charthick=3.5
;xyouts,1000,1.5e-14,'1000',color=fsc_color('black'),charsize=1.7,align=0.5,charthick=3.5
;xyouts,2000,1.5e-14,'2000',color=fsc_color('black'),charsize=1.7,align=0.5,charthick=3.5
xyouts,5000,1.5e-14,'5000',color=fsc_color('black'),charsize=1.7,align=0.5,charthick=3.5
xyouts,10000,1.5e-14,'10000',color=fsc_color('black'),charsize=1.7,align=0.5,charthick=3.5
xyouts,20000,1.5e-14,'20000',color=fsc_color('black'),charsize=1.7,align=0.5,charthick=3.5



;
;;bbflux=planck(l198car,2000)
device,/close
set_plot,'x'
END
