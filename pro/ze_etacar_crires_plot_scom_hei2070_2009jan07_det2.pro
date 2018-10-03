grat_angle=2070
det=2
gratdet=strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))
restore,'/Users/jgroh/espectros/etc_'+gratdet+'_allvar.sav'
Angstrom = '!6!sA!r!u!9 %!6!n'
C=299792.458
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!X.THICK=0
!Y.THICK=0
!P.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182823/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182830/cal_proc/'

scoma=dirsci+'CR_SCOM_200182823_2009-01-08T08_01_36.385_DIT1_2070.4nm.fits'
 
;swmpa=dirscigroh+'crires_spec_jitter_wlmap_0002.fits'
swmpa=dirsci+'CR_SWMA_200182823_2009-01-08T08_01_36.385_DIT1_2070.4nm.fits' ;SWMA files look better

cal2070=dircal+'CR_PEXT_090107A_DIT30_2070.4nm.fits'


;ftab_help,scoma

ftab_ext,cal2070,'Wavelength_model,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength_model,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength_model,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength_model,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

;correcting for the 0 value in the last pixel, very crudely, for further interpolation

w2ca[1023]=w2ca[1020]+3.*(w2ca[1018]-w2ca[1017])

w2ca=w2ca[0:1022]
f2ca=f2ca[0:1022]

;displaying image

dataa0=mrdfits(scoma,0,headera0)
dataa1=mrdfits(scoma,1,headera1)
dataa2=mrdfits(scoma,2,headera2)
dataa3=mrdfits(scoma,3,headera3)
dataa4=mrdfits(scoma,4,headera4)
;
;dataca0=mrdfits(scomca,0,headera0)
;dataca1=mrdfits(scomca,1,headera1)
;dataca2=mrdfits(scomca,2,headera2)
;dataca3=mrdfits(scomca,3,headera3)
;dataca4=mrdfits(scomca,4,headera4)

;swmaa0=mrdfits(swmaa,0,headerswma0)
;swmaa1=mrdfits(swmaa,1,headerswma1)
;swmaa2=mrdfits(swmaa,2,headerswma2)
;swmaa3=mrdfits(swmaa,3,headerswma3)
;swmaa4=mrdfits(swmaa,4,headerswma4)

swmpa0=mrdfits(swmpa,0,headerswmp0)
swmpa1=mrdfits(swmpa,1,headerswmp1)
swmpa2=mrdfits(swmpa,2,headerswmp2)
swmpa3=mrdfits(swmpa,3,headerswmp3)
swmpa4=mrdfits(swmpa,4,headerswmp4)


;using other extensions?
dataa2=dataa2
swmpa2=swmpa2
f2ca=f2ca
w2ca=w2ca

;cropping data in the spatial direction around science spectrum 
;star=249 ;(for HeI at 2070 img)
star=257  ;(for HeI  2070 detector 1,2
;star=247 ; detector 3
;star=242  ;(for HeI  1087 detector 4 

sub=-0.5
row=14
crop=row
cmi=star-crop
cma=star+crop
swmpa2=swmpa2[*,cmi:cma]
dataa2=dataa2[*,cmi:cma]
dataa2=shift_sub(dataa2,0,sub)


heliovel=19.9 ;for 2009 jan 07 from ESO website; has to be added to the measured velocities
;shifting velocity scale by -heliovel;
w2ca=w2ca*(1.+heliovel/C)
swmpa2=swmpa2*(1.+heliovel/C)

lambda0=2.0587
;lambda0=2.16612
;lambda0=1.08333
;lambda0=1.6769


;crop data in spectral direction to remove last zero
dataa2=dataa2[0:1022,*]
swmpa2=swmpa2[0:1022,*]

;additional cropping in spectral direction?
cmin=40
dataa2=dataa2[cmin:1020,*]
swmpa2=swmpa2[cmin:1020,*]

f2ca=f2ca[cmin:1020]
w2ca=w2ca[cmin:1020]

sizelam=(size(dataa2))[1]
sizespat=(size(dataa2))[2]

;normalizing telluric spectrum interactively using FUSE routine LINE_NORM
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
line_norm,w2ca,f2ca,f2canorm,norm,xnodes,ynodes

norm_sect=[880,894]
norm_sect=[940,950]

;shifting each column in the spatial direction 
	;1st finding centroids using gaussians
	l=(size(dataa2))[1]
	s=(size(dataa2))[2]
	y=findgen(s)
	center=dblarr(l)
	fwhm_spat=dblarr(l)	
	;
	;xgaussfit,y,dataa2[row,*]
	for i=0., l-1 do begin
	fit=gaussfit(y,dataa2[i,*],A)
	center[i]=A[1]
	fwhm_spat[i]=2*SQRT(2*ALOG(2))*A[2]*0.085
	endfor

	;2nd sigma clipping centroids around mean value in order to remove spikes
	meanclip,center,mean_val,sigma_val
	print,sigma_val
	for i=0., l-1 do begin
	if center[i] lt (mean_val - 3*sigma_val) then begin
	center[i]=mean_val
	endif
	if center[i] gt (mean_val + 3*sigma_val) then begin
	center[i]=mean_val
	endif
	endfor
	
	;3rd manually replacing the first 7 pixels by crude linear interpolation in order to remove the influence of the teluric line
        ;
	for i=0, 6 do begin
	center[i]=center[7]+ ((7-i)*(center[8]-center[7]))
	endfor
	
	; 3rd fitting centroids
	x=indgen(l)
	yfit2 = poly_fit2(x, center, 2)  ;LINEAR FIT
	line_norm,x,center,centernorm,centervals,xnodescen,ynodescen ;SPLINE FIT INTERACTIVE, BETTER CHOICE
        
	; 4th finding offsets which can be relative to a given  line (arbitrary) 410 (i.e. 411) or to the mean centroid value
	;
	image_center=fix((size(dataa2))[2]/2.)
	spatoffset=centervals-image_center
 
	;
	;plotting line centroid for debugging
	LOADCT,0
	window,8
	plot,center , yrange=[row-2,row+8]
	oplot,yfit2,color=fsc_color('blue'),noclip=0,linestyle=1,thick=1.9 
	oplot,centervals,color=fsc_color('green')

	;shifting each column by the offset (i.e. shifting in spatial direction) 
	prel=dblarr((size(dataa2))[2])	
	for i=0, (size(dataa2))[1] - 1 do begin
	prel[*]=dataa2[i,*]
	prel=shiftf(prel,-1.*spatoffset[i])
	dataa2[i,*]=prel
	endfor

;finds normalization value; DO NOT normalize it here!
norm_line_vector=dblarr(sizespat)
line=dblarr(norm_sect[1]-norm_sect[0])
for i=0, (size(dataa2))[2] - 1 do begin
line=dataa2[norm_sect[0]:norm_sect[1],i]
norm_line_val=(MOMENT(line))[0]
norm_line_vector[i]=norm_line_val
endfor

index=1.*indgen(sizelam)
polycal_master=dblarr(sizespat,3)
lambda_newcal_vac=dblarr(sizelam,sizespat)
fluxteli_2d=dblarr(sizelam,sizespat)

restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_tel.sav'
polycal_tel=dblarr(3)
polycal_tel[0]=yfit[0]
polycal_tel[1]=yfit[1]
polycal_tel[2]=yfit[2]
for i=0., sizespat - 1 do begin
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_'+strcompress(string(i, format='(I02)'))+'.sav'
polycal_master[i,0]=yfit[0]
polycal_master[i,1]=yfit[1]
polycal_master[i,2]=yfit[2]
lambda_newcalt=yfit[0]+yfit[1]*index+yfit[2]*index*index
AIRTOVAC,lambda_newcalt
lambda_newcal_vac[*,i]=lambda_newcalt
lambdatel=polycal_tel[0]+polycal_tel[1]*index+polycal_tel[2]*index*index
AIRTOVAC,lambdatel
fluxteli=cspline(lambdatel,f2canorm,lambda_newcalt)

fwhm=ABS(6.017 -0.4298*i)
;fwhm=ABS(11.437 -0.1769*i)
fluxteli=cnvlgauss(fluxteli,fwhm=fwhm)
fluxteli_2d[*,i]=fluxteli
endfor


;automatically calculates the best scaling between teluric and science spectrum line per line
scl_min=0.6
scl_max=1.2
scl_step=0.01
scl_size=(scl_max-scl_min)/scl_step + 1
scl_vector=fltarr(scl_size)
scl_optimum=dblarr(sizespat)
FOR I=0., scl_size -1 DO scl_vector[i]=scl_min+ (scl_step*i)
resid_master=dblarr(scl_size,sizespat)
min_resid_vector=lonarr(sizespat)
FOR j=0, sizespat - 1 DO BEGIN 
  i=0.
  resid=0.
  FOR scl=scl_min, scl_max, scl_step DO BEGIN
    resid=0.
    scidiv=dataa2[*,j]/(((fluxteli_2d[*,j]-1.)*scl)+1)
    resid=TOTAL(SQRT(ABS(norm_line_vector[j]-scidiv)^2))
    ;print,scl,resid
    resid_master[i,j]=resid
    i=i+1
  ENDFOR
  scl_temp=MIN( resid_master[*,j], scl_min_index)
  min_resid_vector[j]=scl_min_index
  scl_optimum[j]= scl_vector[scl_min_index]
  print,scl_optimum[j]
  fluxteli_2d[*,j]=((fluxteli_2d[*,j]-1.)*scl_optimum[j]) + 1
  dataa2[*,j]=dataa2[*,j]/fluxteli_2d[*,j]
ENDFOR

;subtract or divide by the continuum value?
;FOR I=0, sizespat -1 DO dataa2[*,i]=dataa2[*,i]/norm_line_vector[i]
;FOR I=0, sizespat -1 DO dataa2[*,i]=dataa2[*,i]-norm_line_vector[i]

;
;plot,index,(polycal_master[8,0]+polycal_master[8,1]*index+polycal_master[8,2]*index*index) - (polycal_master[0,0]+polycal_master[0,1]*index+polycal_master[0,2]*index*index) ,color=fsc_color('red')
;for i=0, 8 do begin
;plots,index,(polycal_master[i,0]+polycal_master[i,1]*index+polycal_master[i,2]*index*index) - (polycal_master[0,0]+polycal_master[0,1]*index+polycal_master[0,2]*index*index) ,color=fsc_color('red')
;endfor

;dataa2(WHERE(dataa2) le 0)=0.0001
;using  log
;dataa2=alog10(dataa2)

;using  sqrt
dataa2=SQRT(dataa2)

;plotting image
a=min(dataa2,/NAN)
;a=0.9
b=max(dataa2,/NAN)
;b=1.0
img=bytscl(dataa2,MIN=a,MAX=b)
;img=BytScl(data2, TOP=150, MIN=, MAX=105) + 50B
; byte scaling the image for display purposes with tvimage
imginv=255b-img ;invert img
imginv=img
;plotting in window
aa=1300.
bb=300.
window,19,xsize=aa,ysize=bb,retain=0,XPOS=30,YPOS=60
ticklen = 15.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
plot, lambda_newcal_vac[*,row], [(cmi-star-sub)*0.086,(cma-star-sub)*0.086], XTICKFORMAT='(I6)',xstyle=1,ystyle=1, xtitle='Wavelength (Angstrom)', ytitle='offset (arcsec)',$
/NODATA, Position=[0.07, 0.22, 0.94, 0.98],ycharsize=2,xcharsize=2,charthick=1.2;,XRANGE=[ZE_LAMBDA_TO_VEL(min(swmpa2[*,2]*10.),lambda0*10^4),ZE_LAMBDA_TO_VEL(max(swmpa2[*,5]*10.),lambda0*10^4)]
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
LOADCT, 13
;LOADCT,0
tvimage,imginv, /Overplot
;linear colorbar
x=[0,10]
xfin=[0,2,4,6,8,10]
y=[a,b]
LINTERP,x,y,xfin,yfin
colorbarv = yfin/max(yfin)

nd=2
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.95, 0.24, 0.97, 0.90]


;colorbar, COLOR=fsc_color('black'),TICKNAMES=['0.0','0.2','0.4','0.6','0.8','1.0'], FORMAT='(F5.1)', DIVISIONS=5, /VERTICAL, /RIGHT,$
;POSITION=[0.95, 0.24, 0.97, 0.90]
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[ZE_LAMBDA_TO_VEL(min(swmpa2[*,2]*10.),lambda0*10^4),ZE_LAMBDA_TO_VEL(max(swmpa2[*,5]*10.),lambda0*10^4)],xcharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[min(swmpa2[*,2]*10.),max(swmpa2[*,5]*10.)],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=0,YRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
;AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[(cmi-star-sub),(cma-star-sub)],ytickv=4,YTICKFORMAT='(I7.0)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
xyouts,1230,280,TEXTOIDL('F/Fmax'),/DEVICE,color=fsc_color('black')
xyouts,420,870,TEXTOIDL('PA=325^o'),/DEVICE,color=fsc_color('black'),charsize=3
cut1=-4
cut2=4
cut3=0
d1=cut1*0.086
d2=cut2*0.086
d3=cut3*0.086
xyouts,min(swmpa2[*,row]*10.)-1.,d1,'-->',color=fsc_color('black'),charsize=1,charthick=3
xyouts,min(swmpa2[*,row]*10.)-1.,d2,'-->',color=fsc_color('orange'),charsize=1,charthick=3

;back to linear scale
;dataa2=10.^(dataa2)
dataa2=(dataa2)^2.
;plots,swmpa2[*,row+cut1]*10.,dataa2[*,row+cut1]/max(dataa2[*,row+cut1])/2. + 0.6 ,color=fsc_color('white')
;plots,swmpa2[*,row+cut2]*10.,dataa2[*,row+cut2]/max(dataa2[*,row+cut2])*2.,color=fsc_color('green'),noclip=0,linestyle=0,thick=1
;plots,swmpa2[*,row]*10.,dataa2[*,row]/max(dataa2[*,row])*1.,color=125

LOADCT,13
;image = TVREAD(FILENAME = file_output, /JPEG, /NODIALOG)

ymin=0.8
ymax=2


;sum flux from lmin to lmax lines centered at center
center=0
apradius=1
flux_sum=0.
for i=0, 2*apradius do begin
flux_sum=dataa2[*,row+center-apradius+i]+flux_sum
print,row+center-apradius+i
endfor
print,'Spectral aperture extraction of '+number_formatter(((apradius*2)+1)*0.086,decimals=2)+'x 0.20 arcsec'
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
;checking wavelength difference between science star and telluric calibrator star for row corresponding to central star
window,12,xsize=900,ysize=400,retain=2
plot,lambda_newcal_vac[*,row],dataa2[*,row],xstyle=1,ystyle=1, xtitle='velocity [km/s]',ytitle='F/Fc',$
yrange=[ymin,ymax],charsize=2,charthick=1.5, /NODATA,POSITION=[0.08,0.2,0.9,0.98]
plots,lambda_newcal_vac[*,row],dataa2[*,row+cut1],noclip=0
plots,lambda_newcal_vac[*,row],dataa2[*,row+cut2],color=fsc_color('orange'),noclip=0,linestyle=2
;flux_sum=dataa2[*,row+cut3]+dataa2[*,row+cut3+1]+dataa2[*,row+cut3-1]
plots,lambda_newcal_vac[*,row],dataa2[*,row+cut3],color=fsc_color('blue'),noclip=0,linestyle=0
;plots,ZE_LAMBDA_TO_VEL(swmpa2[*,row+cut3]*10.,lambda0*10000.),flux_sum/flux_sum[norm_col],color=fsc_color('green'),noclip=0,linestyle=0,thick=3

xyouts,850,70,number_formatter(d1,decimals=2),/DEVICE,color=fsc_color('black'),charsize=1,alignment=1.0
xyouts,850,120,number_formatter(d2,decimals=2),/DEVICE,color=fsc_color('orange'),charsize=1,alignment=1.0
xyouts,850,95,number_formatter(d3,decimals=2),/DEVICE,color=fsc_color('blue'),charsize=1,alignment=1.0
;plots,w2ca,f2canorm,color=fsc_color('green'),noclip=0
;plots,swmpa2[*,row+cut1]*10,f2cainormv,color=fsc_color('red'),noclip=0,linestyle=1
;plots,swmpa2[*,row],ZE_SHIFT_SPECTRA_VEL(swmpa2[*,row],f2cainormv,30)
;plots,swmpa2[*,row],dataa2[*,row]/max(dataa2[*,row])*2.92/f2cainormv,color=fsc_color('orange'),noclip=0,linestyle=0
;plots,swmpa2[*,row],dataa2[*,row]/max(dataa2[*,row+2])*1.,color=125
;plots,w2a,f2cai*70.,color=fsc_color('red'),noclip=0
;plots,w2a,f2cain*70.,color=fsc_color('green'),noclip=0

;ZE_WRITE_SPECTRA_COL_VEC,'/Users/jgroh/espectros/etacar/10830/etc_crires_onstar_'+gratdet+'_2009jan07_vel.txt',ZE_LAMBDA_TO_VEL(lambda_newcal,lambda0*10000.)+heliovel,dataa2[*,row+cut3]/dataa2[norm_col,row+cut3]

;;plotting science spectrum on the star and telluric lines
;fnormdiv=dataa2[*,row+cut1]/dataa2[1000,row+cut1]/t ; use this if 2d image is NOT divided by t
fnormdiv=dataa2[*,row+cut3]/dataa2[940,row+cut3]; use this if 2d image is already divided by t
fnormdiv2=dataa2[*,row+cut3]/dataa2[940,row+cut3]

window,11,xsize=900,ysize=400,retain=0
plot,swmpa2[*,row+cut1]/1000.,dataa2[*,row+cut1]/dataa2[800,row+cut1],title=TEXTOIDL('CRIRES observations of Eta Car at Br\gamma 2.16 \mum'),$
POSITION=[0.09, 0.18, 0.96, 0.88],xtitle=TEXTOIDL('Wavelength [\mum]'), ytitle='Normalized flux',$
xstyle=1,ystyle=1,xrange=[(lambda0-0.008)*10000.,(lambda0+0.004)*10000.], yrange=[0.0,2],/NODATA,charsize=2
;plots,swmpa2[*,row]*10.,fnormdiv,noclip=0
;plots,lambda_newcal,fnormdiv2,color=fsc_color('blue'),noclip=0,linestyle=0,thick=1.9
;plots,lambdatel,fluxtel,color=fsc_color('red'),noclip=0,linestyle=0,thick=1.9
plots,lambda_newcal_vac[*,14],fnormdiv2/(((fluxteli-1.)*1.0)+1)
;plots,swmpa2[*,row]/1000.,f2cainormv+2.5,color=fsc_color('red'),noclip=0,linestyle=0,thick=1.9
;xyouts,2.052,3.6,TEXTOIDL('telluric spectrum from calibrator + offset'),color=fsc_color('red'),charsize=1.5
;xyouts,2.052,1.2,TEXTOIDL('Eta Car divided by telluric'),color=fsc_color('blue'),charsize=1.5
;
;
;window,14
;plot,ZE_LAMBDA_TO_VEL(swmpa2[*,row+cut1]/1000.,lambda0),fnormdiv,title=TEXTOIDL('CRIRES observations of Eta Car at Br\gamma 2.16 \mum'),$
;POSITION=[0.09, 0.18, 0.96, 0.88],xtitle=TEXTOIDL('Wavelength [\mum]'), ytitle='Normalized flux',$
;xstyle=1,ystyle=1,xrange=[-1300.,300.], yrange=[0.0,5],/NODATA,charsize=2
;;;plots,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8*f2cainormv,color=fsc_color('black'),noclip=0,linestyle=2,thick=1.9
;plots,ZE_LAMBDA_TO_VEL(swmpa2[*,row+cut1]/1000.,lambda0),fnormdiv,noclip=0
;plots,ZE_LAMBDA_TO_VEL(swmpa2[*,row+cut2]/1000.,lambda0),fnormdiv2,noclip=0
;plots,ZE_LAMBDA_TO_VEL(swmpa2[*,row+cut3]/1000.,lambda0),fnormdiv2,noclip=0
;plots,(ZE_LAMBDA_TO_VEL(lambda_newcal/10000.,lambda0)+20),fnormdiv2/fluxteli,noclip=0,color=fsc_color('blue')
;;set_plot,'ps'
;device,filename='/Users/jgroh/temp/output_etc_2070.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=3.76,/inches
;plot,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8,title=TEXTOIDL('CRIRES observations of Eta Car at He I 2.058 \mum'),$
;POSITION=[0.09, 0.18, 0.96, 0.88],xtitle=TEXTOIDL('Wavelength [\mum]'), ytitle='Normalized flux',$
;xstyle=1,ystyle=1,xrange=[2051.6/1000.,2062.0/1000.], yrange=[-0.2,4],/NODATA,charsize=1.5,charthick=3
;plots,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8*f2cainormv,color=fsc_color('black'),noclip=0,linestyle=1,thick=1.9
;plots,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8,color=fsc_color('blue'),noclip=0,linestyle=0,thick=1.9
;plots,swmpa2[*,row]/1000.,f2cainormv+2.5,color=fsc_color('red'),noclip=0,linestyle=0,thick=1.9
;xyouts,2.052,3.65,TEXTOIDL('telluric spectrum from calibrator + offset'),color=fsc_color('red'),charsize=1.2,charthick=3
;xyouts,2.052,1.2,TEXTOIDL('Eta Car divided by telluric'),color=fsc_color('blue'),charsize=1.2,charthick=3
;xyouts,2.052,1.5,TEXTOIDL('Eta Car raw'),color=fsc_color('black'),charsize=1.2,charthick=3
;device,/close
;set_plot,'x'


;set_plot,'ps'
;device,filename='/Users/jgroh/temp/output_etc_2150.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=5.76,/inches
;plot,swmpa2[*,row+cut1]/1000.,fnormdiv,title=TEXTOIDL('CRIRES observations of Eta Car at Br\gamma 2.16 \mum'),$
;POSITION=[0.10, 0.18, 0.93, 0.88],xtitle=TEXTOIDL('Wavelength [\mum]'), ytitle='Normalized flux',charthick=2.,$
;xstyle=1,ystyle=1,xrange=[2159.6/1000.,2168.4/1000.], yrange=[0.0,5.],charsize=1.5, /NODATA
;plots,swmpa2[*,row+cut1]/1000.,fnormdiv,thick=2.,noclip=0,clip=[2159.6/1000.,0,2168.4/1000.,5]
;;plots,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8*f2cainormv,color=fsc_color('black'),noclip=0,linestyle=2,thick=1.9
;plots,swmpa2[*,row+cut1]/1000.,dataa2[*,row+cut1]/dataa2[100,row+cut1]/f2cainormv,color=fsc_color('black'),noclip=0

;plot,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8,title=TEXTOIDL('CRIRES observations of Eta Car at He I 2.058 \mum'),$
;POSITION=[0.09, 0.18, 0.96, 0.88],xtitle=TEXTOIDL('Wavelength [\mum]'), ytitle='Normalized flux',$
;xstyle=1,ystyle=1,xrange=[2051.6/1000.,2062.0/1000.], yrange=[-0.2,4],/NODATA,charsize=1.5,charthick=3
;plots,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8*f2cainormv,color=fsc_color('black'),noclip=0,linestyle=1,thick=1.9
;plots,swmpa2[*,row]/1000.,dataa2[*,row]/max(dataa2[*,row])*5.8,color=fsc_color('blue'),noclip=0,linestyle=0,thick=1.9
;plots,swmpa2[*,row]/1000.,f2cainormv+2.5,color=fsc_color('red'),noclip=0,linestyle=0,thick=1.9
;xyouts,2.052,3.65,TEXTOIDL('telluric spectrum from calibrator + offset'),color=fsc_color('red'),charsize=1.2,charthick=3
;xyouts,2.052,1.2,TEXTOIDL('Eta Car divided by telluric'),color=fsc_color('blue'),charsize=1.2,charthick=3
;xyouts,2.052,1.5,TEXTOIDL('Eta Car raw'),color=fsc_color('black'),charsize=1.2,charthick=3
;device,/close
set_plot,'x'

;output=dirsci+'tel_2150_norm.txt'
;openw,1,output
;for f=0, 1000. do begin
;printf,1, swmpa2[f,row+cut1]*10,t[f]
;endfor
;close,1 
;
;
;output=dirsci+'etc_2150_norm_div_row0.txt'
;openw,1,output
;for f=0, 1020. do begin
;printf,1, swmpa2[f,row+cut1]*10,fnormdiv[f]
;endfor
;close,1 

;plot spatial profile and fit a gaussian interactively
;LOADCT,0
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;  s=(size(dataa2))[2]
;  y=findgen(s)
;  y=y+(cmi-star-sub)
;  xgaussfit,y,dataa2[911,*]

lambda_spec=swmpa2[*,row]*10.
VACTOAIR,LAMBDA_SPEC
;ZE_WRITE_SPECTRA_COL_VEC,'/Users/jgroh/espectros/etacar/10830/etc_crires_onstar_'+gratdet+'_2009jan07.txt',lambda_spec,fonstar_norm

;capturing TRUE COLOR image of the 2D spectrum to pic2
window,22,retain=2,xsize=aa,ysize=bb
LOADCT,13 
tvimage,imginv,POSITION=[0,0,0.95,0.95]
pic2=tvrd(0,0,0.95*aa,0.95*bb,/true)
wdelete,!d.window

;plotting to PS file
;keywords = PSConfig(_Extra=PSWindow())
keywords.ysize=10.
keywords.bits_per_pixel=8.
keywords.xsize=keywords.ysize*aa/bb
keywords.ENCAPSULATED=1
keywords.filename='/Users/jgroh/temp/etc_criresdiv'+gratdet+'.eps'

set_plot,'ps'
   DEVICE, _EXTRA=keywords
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
plot, lambda_newcal_vac[*,row], [(cmi-star-sub)*0.086,(cma-star-sub)*0.086], XTICKFORMAT='(I6)',xstyle=1,ystyle=1, xtitle='Wavelength (Angstrom)', ytitle='offset (arcsec)',$
/NODATA, Position=[0.07, 0.22, 0.94, 0.98];,XRANGE=[ZE_LAMBDA_TO_VEL(min(swmpa2[*,2]*10.),lambda0*10^4),ZE_LAMBDA_TO_VEL(max(swmpa2[*,5]*10.),lambda0*10^4)]
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
LOADCT, 13
;LOADCT,0
tvimage,pic2, /Overplot
;linear colorbar
x=[0,10]
xfin=[0,2,4,6,8,10]
y=[a,b]
LINTERP,x,y,xfin,yfin
colorbarv = yfin/max(yfin)
LOADCT,13
colorbar, COLOR=fsc_color('black'),TICKNAMES=['0.0','0.2','0.4','0.6','0.8','1.0'], FORMAT='(F5.1)', DIVISIONS=5, /VERTICAL, /RIGHT,CHARSIZE=1.3,$
POSITION=[0.95, 0.24, 0.97, 0.90]
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[ZE_LAMBDA_TO_VEL(min(swmpa2[*,2]*10.),lambda0*10^4),ZE_LAMBDA_TO_VEL(max(swmpa2[*,5]*10.),lambda0*10^4)],xcharsize=0
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[min(swmpa2[*,2]*10.),max(swmpa2[*,5]*10.)]
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=0,YRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
;AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[(cmi-star-sub),(cma-star-sub)],ytickv=4,YTICKFORMAT='(I7.0)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
xyouts,1230/aa,280/bb,TEXTOIDL('F/Fmax'),/NORMAL,color=fsc_color('black')
;xyouts,420/aa,870/bb,TEXTOIDL('PA=325^o'),/NORMAL,color=fsc_color('black')


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

;xgaussfit,swmpa2[*,row],f2cainorm
;xgaussfit,swmpa2[*,row],fnormdiv

;image_rect=MRDFITS('/Users/jgroh/espectros/hei2070_dit1_ext2_crop_rect.fits',0,header3)
;crval1=fxpar(header3,'CRVAL1')
;cdelt1=fxpar(header3,'CDELT1')
;s=(size(image_rect))
;nrec=s[1]
;lambda=dblarr(nrec) & fluxd=lambda & lambda2=lambda
;for k=0., nrec-1 do begin
;lambda[k]=crval1 + (k*cdelt1)
;endfor
;airtovac,lambda
;
;fluxteli=cspline(lambdatel,fluxtel,lambda)
;
;for i=0, s[2] - 1 do begin
;
;image_rect[*,i]=image_rect[*,i]/fluxteli
;
;endfor
;
;image_rect=SQRT(image_rect)
;
;;plotting image
;a=min(image_rect,/NAN)
;;a=1.0
;b=max(image_rect,/NAN)
;;b=3.44
;img2=bytscl(image_Rect,MIN=a,MAX=b); byte scaling the image for display purposes with tvimage
;imginv2=255b-img2 ;invert img
;imginv2=img2


;window,22
;ticklen = 15.
;!x.ticklen = ticklen/bb
;!y.ticklen = ticklen/aa
;LOADCT,0
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;plot, lambda/10., [(cmi-star-sub)*0.086,(cma-star-sub)*0.086], XTICKFORMAT='(I6)',xstyle=1,ystyle=1, xtitle='Wavelength (Angstrom)', ytitle='offset (arcsec)',$
;/NODATA, Position=[0.07, 0.22, 0.94, 0.98];,XRANGE=[ZE_LAMBDA_TO_VEL(min(swmpa2[*,2]*10.),lambda0*10^4),ZE_LAMBDA_TO_VEL(max(swmpa2[*,5]*10.),lambda0*10^4)]
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;LOADCT, 13
;;LOADCT,0
;tvimage,imginv2, /Overplot
;;linear colorbar
;x=[0,10]
;xfin=[0,2,4,6,8,10]
;y=[a,b]
;LINTERP,x,y,xfin,yfin
;colorbarv = yfin/max(yfin)
;LOADCT,13
;colorbar, COLOR=fsc_color('black'),TICKNAMES=['0.0','0.2','0.4','0.6','0.8','1.0'], FORMAT='(F5.1)', DIVISIONS=5, /VERTICAL, /RIGHT,CHARSIZE=1.3,$
;POSITION=[0.95, 0.24, 0.97, 0.90]
;LOADCT,0
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[ZE_LAMBDA_TO_VEL(min(swmpa2[*,2]*10.),lambda0*10^4),ZE_LAMBDA_TO_VEL(max(swmpa2[*,5]*10.),lambda0*10^4)],xcharsize=0
;AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[min(swmpa2[*,2]*10.),max(swmpa2[*,5]*10.)]
;AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=0,YRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
;;AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[(cmi-star-sub),(cma-star-sub)],ytickv=4,YTICKFORMAT='(I7.0)'
;AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),YRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
;xyouts,1230/aa,280/bb,TEXTOIDL('F/Fmax'),/NORMAL,color=fsc_color('black')
;xyouts,420/aa,870/bb,TEXTOIDL('PA=325^o'),/NORMAL,color=fsc_color('black')
;
;save,/variables,FILENAME='/Users/jgroh/espectros/etc_'+gratdet+'_allvar.sav'
END
