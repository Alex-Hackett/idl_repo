close,/all
obsdir='/Users/jgroh/espectros/etacar/10830/'
file='in_alld03hel_only03'
file='teste'
;file='in_10830_all_redisp_again'

template=ASCII_TEMPLATE(obsdir+file)


npix=1251. ;for Augusto's data
;npix=445   ; for mairan's data


data=read_ascii(obsdir+file,COUNT=nspec,TEMPLATE=template,comment_symbol='#')
flux_array=DBLARR(npix,nspec)
lambda_array=DBLARR(npix,nspec)
mjd_array=DBLARR(nspec)
phase_array=DBLARR(nspec)
header_array=STRARR(nspec)


FOR i=0, nspec -1 DO BEGIN
flux=mrdfits(obsdir+data.field1[i],0,header)
flux_array[*,i]=flux
dateobs=fxpar(header,'DATE-OBS')
dateobstr=STRTRIM(dateobs,2)
mjd=date_conv(dateobstr,'MODIFIED') 
mjd_array[i]=mjd
;header_array[i]=header
ENDFOR

help,flux_array

crval1=fxpar(header,'CRVAL1')
cdelt1=fxpar(header,'CDELT1')
s=size(flux)
lambda=dblarr(s[1]) 
for k=0., s[1]-1 do begin
lambda[k]=crval1 + (k*cdelt1)
endfor

FOR i=0, nspec -1 DO BEGIN
lambda_array[*,i]=lambda
ENDFOR

mjd_SORT=mjd_array(SORT(mjd_array))
flux_SORT=flux_array(*,SORT(mjd_array))

shift=10.0
mjd_sort=1+(mjd_sort-52819.8-0.5)/2022.7+shift


lambda0=10830.3
vel=ZE_LAMBDA_TO_VEL(lambda,lambda0)

;shift spectra to refine wavelength calibration, based on the feature at -1059 km/s.
shift_val=dblarr(nspec)
shift_val=[-11.,   -27.,         -23. ,    0.,       -13.     , -10.    ,-17. ,    -19.,         -30.,       -27.,    -29.,    -43.,   -34.,  -15,       0.      ]
;         01jun12  02feb18      02apr30   02jul20    02nov04   02dec20  03mar15  03may12-13-15  03may25   03jun22   03jun28   03jul03 03jul09 03aug13  03dec14 
;SN?                                                             low                                                                             low
;coude?                                                                  y          y                       y          y        y        y          y
lambda_correct=lambda
lambda=vel
fwhm_ang=1.35
lambda_val=10830.3
FOr I=0, nspec -1 DO BEGIN
flux_temp=REFORM(flux_sort[*,i])
flux_temp_shift=ZE_SHIFT_SPECTRA_VEL(lambda_correct,flux_temp,shift_val[i])
  if (i eq 3) OR (i eq 5) OR (i eq 6) OR (i eq 7) OR (i gt 8) THEN ZE_SPEC_CNVL,lambda_correct,flux_temp_shift,fwhm_ang,lambda_val,fluxcnvl=flux_temp_shift_cnvl ELSE flux_temp_shift_cnvl=flux_temp_shift 
  ;if i eq 6 THEN ZE_SPEC_CNVL,lambda_correct,flux_temp_shift,fwhm_ang,lambda_val,fluxcnvl=flux_temp_shift_cnvl ELSE flux_temp_shift_cnvl=flux_temp_shift 
  ;if i eq 7 THEN ZE_SPEC_CNVL,lambda_correct,flux_temp_shift,fwhm_ang,lambda_val,fluxcnvl=flux_temp_shift_cnvl ELSE flux_temp_shift_cnvl=flux_temp_shift 

flux_sort[*,i]=flux_temp_shift_cnvl
ENDFOR
;
;
;flux_array2d=DBLARR(nspec*s[1])
;FOR i=0,nspec-1 DO BEGIN
;  flux_array2d[i]=flux_array[1
;
;
;for i-0,s
mjd_sorti=1.*indgen(1251)/2000.+0.62+shift
nphasei=n_elements(mjd_sorti)
fluxiarray=DBLARR(npix,nphasei)
fluxp=DBLARR(nphasei)

FOR i=0,s[1]-1 DO BEGIN
fluxp=flux_sort[i,*]
fluxi=cspline(mjd_sort,fluxp,mjd_sorti)
flux=flux_sort[i,*]
;linterp,mjd_sort,flux,mjd_sorti,fluxi
fluxiarray[i,*]=fluxi
ENDFOR
;result=interp2d(flux_sort,mjd_sort,lambda,mjd_arrayi,lambda,/GRID)
;xsize=900
;ysize=760
window,0

x1=-2000
x2=500
y1=0.70+shift
y2=1.09+shift

a=0.16
b=0.09
c=0.85
d=0.78

minc=0
a=minc
maxc=1.
b=maxc

LOADCT,13
shade_surf,flux_sort,lambda,mjd_sort,shades=BYTSCL((flux_sort),MIN=minc,MAX=maxc),zaxis=-1,az=0,ax=90,Xrange=[x1,x2],yrange=[y1,y2],charsize=2,ycharsize=1,xcharsize=1,$
xstyle=1,ystyle=1, xtitle='Wavelength', $
ytitle='Phase', Position=[0,0,1,1],PIXELS=10000,image=surface;, title=title
LOADCT,13
;shade_surf_irr,flux_sort,lambda,mjd_sort,shades=BYTSCL(flux_sort,MIN=0,MAX=2),az=0,ax=90
;LOADCT,0
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;plot, lambda, mjd_sort, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(F9.1)',XTICKFORMAT='(F9.1)',/NODATA , $
;xrange=[x1,x2], $
;yrange=[y1,y2],xstyle=1,ystyle=1, xtitle='Wavelength',ytitle='Phase', Position=[a,b,c,d],/NOERASE


;;creating image
x=lambda
y=mjd_sorti
flux2d=DBLARR(nphasei*npix)
j=0.
l=0.
m=1.
for i=0.,(nphasei*(npix-1))-1. DO BEGIN
;for i=0.,2000. DO BEGIN
flux2d[i]=fluxiarray[l,j]
if i gt (npix-1.)*m THEN BEGIN 
j=j+1.
l=0
m=m+1
ENDIF
ENDFOR

;interpolate the data. One has to use TOLERANCE in order to avoid co-linear points
;TRIANGULATE, x, y, circtriangles, circboundaryPts,TOLERANCE=1e-10
;factor=1.5   ;factor to zoom out of the image
;pix=500.
circ_gridSpace = [10.,0.2] ; space in x and y directions [in rsun], it is the optimum value obtained from tests
;;circ_griddedData = TRIGRID(x, y, intens2d_lambda, circtriangles, circ_gridSpace,[MIN(x), MIN(y), MAX(x), max(y)], XGrid=circxvector, YGrid=circyvector)
;circ_griddedData = TRIGRID(x, y, flux2d, circtriangles, circ_gridSpace,[x1,y1,x2, y2], XGrid=circxvector, YGrid=circyvector)
;
;img=bytscl(circ_griddedData,MAX=max(circ_griddedData)); byte scaling the image for display purposes with tvimage
;surface=bytscl(surface,MIN=0,MAX=25); byte scaling the image for display purposes with tvimage
;;img=bytscl(circ_griddedData,MAX=1.0); byte scaling the image for display purposes with tvimage
;;log
;;img=bytscl(circ_griddedData,MAX=max(circ_griddedData)); byte scaling the image for display purposes with tvimage
;;imginv=255b-img ;invert img
;imginv=img
;;writing interpolated data to a FITS file
;;mwrfits,circ_griddedData,'/Users/jgroh/temp/circ_griddedData.fits'
;;plotting in window
xsize=900
ysize=760
window,10,xsize=xsize,ysize=ysize,retain=2,XPOS=30,YPOS=200
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
title='He I 10830 (OPD/LNA ground based)'
;;IF KEYWORD_SET(vel) THEN BEGIN
;title='Image at velocity '+vel_str+' km s!E-1!N, i=41!Eo!N, PA='+pa_str+'!Eo '
;ENDIF ELSE BEGIN
;title='Image at wavelength '+lambda_str+' Angstrom, i=41!Eo!N, PA='+pa_str+'!Eo '
;ENDELSE
;
plot, lambda, mjd_sort, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(F9.2)',XTICKFORMAT='(F9.2)',/NODATA , $
xrange=[x1,x2], $
yrange=[y1,y2],xstyle=1,ystyle=1, xtitle='Wavelength', $
ytitle='Phase', Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize];, title=title
LOADCT, 13
tvimage,surface, /Overplot
plot, lambda, mjd_sort, charsize=2,ycharsize=1,xcharsize=1,YTICKFORMAT='(F9.2)',XTICKFORMAT='(F9.2)',/NODATA ,/NOERASE, $
xrange=[x1,x2], $
yrange=[y1,y2],xstyle=1,ystyle=1, xtitle='Wavelength', $
ytitle='Phase', Position=[0.16, 0.09, 0.85, 0.78*xsize/ysize], title=title
FOR I=0, n_elements(mjd_sort)-1 DO BEGIN
plots,[350,400],[mjd_sort[i],mjd_sort[i]]
xyouts,100,mjd_sort[i],STRING(i)
ENDFOR

xsize=900.*1  ;window size in x
ysize=560.*1  ; window size in y


ticklen = 22.
!x.ticklen = ticklen/ywindowsize
!y.ticklen = ticklen/xwindowsize
set_plot,'ps'
;making psplots
!p.multi=[0, 1, 2]

!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=1.9
!Y.charsize=1.6
!X.charsize=1.6
!P.THICK=15
!X.THiCK=15
!Y.THICK=15
!P.CHARTHICK=13
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')




width=20
PositionPlot=[0.11, 0.14, 0.92, 0.96]

device,filename='/Users/jgroh/temp/etacar_opd_hei10830_intens_phase_2D_2003.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot, lambda, mjd_sort,YTICKFORMAT='(F9.2)',XTICKFORMAT='(F9.2)',/NODATA , $
xrange=[x1,x2], $
yrange=[y1,y2],xstyle=1,ystyle=1, XTITLE='Heliocentric velocity (km/s)', YTITLE='Phase of the spectroscopic cycle', Position=PositionPlot,XTICKINTERVAL=500
;, title=title
LOADCT, 13,/SILENT
tvimage,surface, /Overplot
LOADCT, 0,/SILENT
plot, lambda, mjd_sort,YTICKFORMAT='(A2)',XTICKFORMAT='(A2)',/NODATA , $
xrange=[x1,x2], $
yrange=[y1,y2],xstyle=1,ystyle=1, XTITLE='', YTITLE='', Position=PositionPlot,XTICKINTERVAL=500,color=fsc_color('black')

LOADCT, 13,/SILENT
nd=1
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),'>'+number_formatter((b-a) +a ,decimals=0)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.93, 0.14, 0.94, 0.96]

xyouts,0.93,0.98,TEXTOIDL('F/Fcont'),/NORMAL,color=fsc_color('black')

date_obs=['2001jun12 ', '2002feb18 ',  '2002apr30','2002jul20',    '2002nov04',   '2002dec20',  '2003mar15 ', '2003may13',  '2003may25',   '2003jun22',  '2003jun28',   '2003jul03', '2003jul09 ','2003aug13', '2003dec14' ]
FOR I=0, n_elements(mjd_sort)-1 DO BEGIN
if i gt 0 THEN plots,[-1900,-1800],[mjd_sort[i],mjd_sort[i]]
;if i gt 0 THEN xyouts,100,mjd_sort[i]-0.003,date_obs[i]
ENDFOR

xyouts,0,1.05+shift,'2003.5 event',charsize=3.

device,/close
set_plot,'x'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!P.THICK=0
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0


END