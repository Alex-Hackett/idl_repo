;PRO ZE_WAVECAL_AMBER_SPEC

grat_angle=2160
det=1
gratdet=strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))
restore,'/Users/jgroh/espectros/mwc297_'+gratdet+'_allvar.sav'


dir_amber='/Users/jgroh/data/eso/amber/ETACARMWC297_SPECTRA/'
filename_amber=dir_amber+'AMBER.2008-04-06T08:16:30.795_2008-04-06T08:57:20.276_MERGERAWSPEC.TAB'
ZE_READ_AMBER_DATA_FROM_DRIEBE,filename_amber,data=data1
;meaning of each column
;0) wavelength/micron
;1) photometry #1
;2) photometry #2
;3) photometry #3
;4) interferometric signal
;5) unnormalized average
;
sizelam=(size(data1.field1))[2]
sizespat=1
index=1.*indgen(sizelam)
wl=dblarr(sizelam) & pho1=wl & pho2=wl & pho3=wl & ifflux=wl & un_ave=wl
;reversing the vectors to avoid problems with putative further interp etc. Note that dim=2 should be used, given that they are all column vectors. 
wl[*]=10000.*REVERSE(data1.field1[0,*],2)
pho1[*]=REVERSE(data1.field1[1,*],2)
pho2[*]=REVERSE(data1.field1[2,*],2)
pho3[*]=REVERSE(data1.field1[3,*],2)
ifflux[*]=REVERSE(data1.field1[4,*],2)
un_ave[*]=REVERSE(data1.field1[5,*],2)


Angstrom = '!6!sA!r!u!9 %!6!n'
C=299792.458
lambda_val=21661.0

!EXCEPT = 0
swmpa2_air=wl
print,swmpa2_air
VACTOAIR,swmpa2_air
print,swmpa2_air
guess_lambda=swmpa2_air

;normalizing spectrum interactively using FUSE routine LINE_NORM
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
line_norm,guess_lambda,ifflux,iffluxn,norm,xnodes,ynodes

;ZE_READ_TELKPNO_AIR,lambdacut=lkpno,fluxcut=fkpno,min(guess_lambda),max(guess_lambda)
;ZE_MEASURE_SPEC_RESOLUTION_INTER,guess_lambda,iffluxn,fwhm_ang=fwhm_ang,res=res,gcoef=gcoef
print,'Actual data resolution:  ', res
;ZE_SPEC_CNVL,lkpno,fkpno,fwhm_ang,lambda_val,fluxcnvl=fkpnocnvl
ZE_BUILD_TELURIC_LINELIST_V3, guess_lambda,iffluxn,lkpno,fkpnocnvl,grat_angle,det
linelist_file='/Users/jgroh/espectros/telluriclines_air_list_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_sel.txt'
template_file='/Users/jgroh/espectros/etc_poly_wavecal_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_template.sav'
;ZE_CREATE_IDENT_PLOT_TELURIC,guess_lambda,iffluxn,grat_angle,det,linelist_file
;ZE_WAVECAL_BUILD_TEMPLATE,index,iffluxn,grat_angle,det,linelist_file
ZE_WAVECAL_CALIB_LAMBDA_CAL_V3,index,guess_lambda,iffluxn,1,1,gratdet,linelist_file,template_file

restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_tel.sav'
polycal_tel=dblarr(3)
polycal_tel[0]=yfit[0]
polycal_tel[1]=yfit[1]
polycal_tel[2]=yfit[2]
lambdatel=polycal_tel[0]+polycal_tel[1]*index+polycal_tel[2]*index*index
AIRTOVAC,lambdatel

ra_obs=[18,27,40.00]
dec_obs=[-03,49,52.0]
date_obs=[2008,4,6,08]
ZE_COMPUTE_HELIOCENTRIC_VEL,date_obs,ra_obs,dec_obs,vhelio=vhelio
print,'Heliocentric velocity: ',vhelio
;adding heliocentric velocity to the measured values;
lambdatel_hel=lambdatel*(1.+ (vhelio/C))
veltel_hel=ZE_LAMBDA_TO_VEL(lambdatel_hel,lambda_val)

ra_decimal=convang(ra_obs,/ra)
dec_decimal=convang(dec_obs)
HELIO2LSR, vhelio, vlsr,ra=ra_decimal, dec=dec_decimal
print,'LSR velocity: ',vlsr
lambdatel_lsr=lambdatel*(1.+(vlsr/C))
veltel_lsr=ZE_LAMBDA_TO_VEL(lambdatel_lsr,lambda_val)

reftel_cal_vac=21686.807
print,reftel_cal_vac
reftel_cal_air=reftel_cal_vac
VACTOAIR,reftel_cal_air
reftel_kpno_air=21680.9688
veldiff=((reftel_kpno_air-reftel_cal_air)/reftel_kpno_air) *C
print,veldiff 

;lineplot,veltel_hel,iffluxn

;checking line asymmetry
;lineplot,REVERSE(veltel_hel)-1329.02,iffluxn
;producing ps plots
aa=600
bb=400
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/mwc_'+gratdet+'_hel.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches

!X.THICK=5.5
!Y.THICK=5.5
!X.CHARSIZE=2
!Y.CHARSIZE=2
!P.CHARSIZE=2
!P.CHARTHICK=5.5
ticklen = 15.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

plot,veltel_hel,iffluxn,xstyle=1,ystyle=1,POSITION=[0.15,0.18,0.95,0.95],/NODATA,XRANGE=[-100,100],YRANGE=[1,4.7],xtitle='Heliocentric velocity [km/s]',ytitle='Normalized flux'
plots,veltel_hel,iffluxn,noclip=0
plots,REVERSE(veltel_hel)-1329.02,iffluxn,color=fsc_color('red'),noclip=0,linestyle=2
xyouts,0,1.3,'FWHM (gauss)= 60 +- 2 km/s',align=0.5
xyouts,0,1.5,'Center (gauss)= -1 +- 2 km/s',align=0.5
xyouts,0,1.7,'Center (flux)= -2 +- 2 km/s',align=0.5

device,/close_file
aa=600
bb=400
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/mwc_'+gratdet+'_lsr.eps'
set_plot,'ps'
device,filename=ps_filename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches

!X.THICK=5.5
!Y.THICK=5.5
!X.CHARSIZE=2
!Y.CHARSIZE=2
!P.CHARSIZE=2
!P.CHARTHICK=5.5
ticklen = 15.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

plot,veltel_lsr,iffluxn,xstyle=1,ystyle=1,POSITION=[0.15,0.18,0.95,0.95],/NODATA,XRANGE=[-90,120],YRANGE=[1,4.7],xtitle='LSR velocity [km/s]',ytitle='Normalized flux'
plots,veltel_lsr,iffluxn,noclip=0
plots,REVERSE(veltel_lsr)-1329.02,iffluxn,color=fsc_color('red'),noclip=0,linestyle=2
xyouts,17,1.3,'FWHM (gauss)= 60 +- 2 km/s',align=0.5
xyouts,17,1.5,'Center (gauss)= 15.4 +- 2 km/s',align=0.5
xyouts,17,1.7,'Center (flux)= 13.8 +- 2 km/s',align=0.5
device,/close_file
set_plot,'x'

!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0
;
;save,/variables,FILENAME='/Users/jgroh/espectros/mwc297_'+gratdet+'_allvar.sav'
END