;PRO ZE_ETACAR_CRIRES_PLOT_SCOM_2009FEB09_V2,scoma,swmpa,cal2070

;reseting main program variables
UNDEFINE,star,norm_sect
grat_angle=1087
det=4
xnodes=0
ynodes=0
xnodes_spec_Ext=0
ynodes_spec_ext=0
gratdet='2009feb09_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))
gratdetold='2009apr09_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)')) ;used for retrieving data from other epochs, e.g. for wavecal
dircriresrun='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043B_2009Feb09/'

saved_file='/Users/jgroh/espectros/etc_'+gratdet+'_allvar.sav'
if (FILE_EXIST(saved_file) eq 0) then begin
  print,'Saved file not found. No saved file was restored.'
endif else begin
restore,saved_file
print, 'File restored,', gratdet
endelse
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

;NOTE: Calibrator was observed only for 2070 and 2076 grat_angles

CASE grat_angle of

 2070: BEGIN
dirsci=dircriresrun+'352642/sci_proc/'
dircal=dircriresrun+'352641/cal_proc/'
scoma=dirsci+'CR_SCOM_352642_2009-02-09T07_34_01.072_DIT1_2070.4nm.fits'
swmpa=scoma
strreplace,swmpa,'SCOM','SWMA' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090208A_DIT30_2070.4nm.fits'
lambda0=2.05869
    END
    
 2076: BEGIN
dirsci=dircriresrun+'352642/sci_proc/'
dircal=dircriresrun+'352641/cal_proc/'
scoma=dirsci+'CR_SCOM_352642_2009-02-09T07_46_56.501_DIT1_2076.6nm.fits'
swmpa=scoma
strreplace,swmpa,'SCOM','SWMA' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090208A_DIT30_2076.6nm.fits'
lambda0=2.05869
    END
    
 1087: BEGIN
 ;using calibrator from 2009 April run
dirsci=dircriresrun+'352647/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/383D-0240A_2009Apr03/361942/cal_proc/'
scoma=dirsci+'CR_SCOM_352647_2009-02-09T06_12_38.858_DIT1_1087.3nm.fits'
swmpa=scoma
strreplace,swmpa,'SCOM','SWMA' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090402A_DIT30_1087.3nm.fits'
flatfile=dirgencalib+'/proc/FLAT/CR_PFLT_090208A_1087.3nm.fits'
lambda0=1.08333
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_lamp_2d.sav'
    END
    
 1090: BEGIN
 ;using calibrator from 2009 January run
dirsci=dircriresrun+'352647/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182815/cal_proc/'
scoma=dirsci+'CR_SCOM_352647_2009-02-09T06_32_42.488_DIT1_1090.4nm.fits'
swmpa=scoma
strreplace,swmpa,'SCOM','SWMA' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_1090.4nm.fits'
lambda0=1.08333
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_lamp_2d.sav'
    END

 2150: BEGIN
;using calibrator from 2009 January run
dirsci=dircriresrun+'352645/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182811/cal_proc/'
scoma=dirsci+'CR_SCOM_352645_2009-02-09T07_06_35.831_DIT1_2150.0nm.fits'
swmpa=scoma
strreplace,swmpa,'SCOM','SWMA' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2150.0nm.fits'
lambda0=2.16612
    END
    
 2156: BEGIN
 ;no 2156 file from pipeline processing!
dirsci=dircriresrun+'352645/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182811/cal_proc/'
scoma=dirsci+'no_file'
swmpa=scoma
strreplace,swmpa,'SCOM','SWMA' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2156.5nm.fits'
lambda0=2.16612
    END

ENDCASE

;ftab_help,scoma

ftab_ext,cal2070,'Wavelength,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

;correcting for the 0 value in the last pixel, very crudely, for further interpolation

w2ca[1023]=w2ca[1020]+3.*(w2ca[1018]-w2ca[1017])

w2ca=w2ca[0:1022]
f2ca=f2ca[0:1022]

dataa0=mrdfits(scoma,0,headera0)
dataa1=mrdfits(scoma,1,headera1)
dataa2=mrdfits(scoma,2,headera2)
dataa3=mrdfits(scoma,3,headera3)
dataa4=mrdfits(scoma,4,headera4)

swmpa0=mrdfits(swmpa,0,headerswmp0)
swmpa1=mrdfits(swmpa,1,headerswmp1)
swmpa2=mrdfits(swmpa,2,headerswmp2)
swmpa3=mrdfits(swmpa,3,headerswmp3)
swmpa4=mrdfits(swmpa,4,headerswmp4)


;selecting which extension to use
CASE det of

 1: BEGIN
    dataa2=dataa1
    swmpa2=swmpa1
    f2ca=f1ca
    w2ca=w1ca 
    END
    
 2: BEGIN
    dataa2=dataa2
    swmpa2=swmpa2
    f2ca=f2ca
    w2ca=w2ca 
    END
    
 3: BEGIN
    dataa2=dataa3
    swmpa2=swmpa3
    f2ca=f3ca
    w2ca=w3ca 
    END
    
 4: BEGIN
    dataa2=dataa4
    swmpa2=swmpa4
    f2ca=f4ca
    w2ca=w4ca 
    END

ENDCASE

if (n_elements(star) eq 0) THEN ZE_SELECT_STAR_CENTER,dataa2,star=star

sub=-0.5
row=14
crop=row
cmi=star-crop
cma=star+crop
swmpa2=swmpa2[*,cmi:cma]
dataa2=dataa2[*,cmi:cma]
help,dataa2
help,LAMVALUES_ALLPIX
lamvalues_Allpix=lamvalues_Allpix[*,cmi:cma]

dataa2=shift_sub(dataa2,0,sub)
lamvalues_Allpix=shift_sub(lamvalues_Allpix,0,sub)

ra_obs=[10,45,03.00]
dec_obs=[-59,41,03.0]
date_obs=[2009,2,9,07]
ZE_COMPUTE_HELIOCENTRIC_VEL,date_obs,ra_obs,dec_obs,vhelio=vhelio
print,'Heliocentric velocity: ',vhelio

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

;trying another approach to obtain telluric spectrum when only a few lines are present
;line_norm,w2ca,f2ca,telbase,norm2,xnodes2,ynodes2
;norm2=norm2/max(norm2)
;f2canorm=norm2

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
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
  window,8
  plot,center , yrange=[row-2,row+8]
  oplot,yfit2,color=fsc_color('blue'),noclip=0,linestyle=1,thick=1.9 
  oplot,centervals,color=fsc_color('green')

  ;shifting each column by the offset (i.e. shifting in spatial direction)  ; shifting also the lambda IMAGE for consistency (JHG 09 April 09, 12 21 pm)
  prel=dblarr((size(dataa2))[2])  
  prel2=prel
  for i=0, (size(dataa2))[1] - 1 do begin
  prel[*]=dataa2[i,*]
  prel=shiftf(prel,-1.*spatoffset[i])
  dataa2[i,*]=prel
  
  prel2[*]=lamvalues_Allpix[i,*]
  prel2=shiftf(prel2,-1.*spatoffset[i])
  lamvalues_Allpix[i,*]=prel2
  endfor
   

index=1.*indgen(sizelam)
indexspat=1.*indgen(sizespat)

;selecting region for normalization interactively
IF n_elements(norm_sect) eq 0 THEN ZE_SELECT_NORM_SECTION,index,dataa2,row,norm_sect=norm_sect

;finds normalization value; DO NOT normalize it here!
norm_line_vector=dblarr(sizespat)
line=dblarr(norm_sect[1]-norm_sect[0])
for i=0, (size(dataa2))[2] - 1 do begin
line=dataa2[norm_sect[0]:norm_sect[1],i]
norm_line_val=(MOMENT(line))[0]
norm_line_vector[i]=norm_line_val
endfor

polycal_master=dblarr(sizespat,3)
lambda_newcal_vac=dblarr(sizelam,sizespat)
lambda_newcal_vac_hel=dblarr(sizelam,sizespat)
fluxteli_2d=dblarr(sizelam,sizespat)

minrow=0
numberrows=29

CASE grat_angle of

 2070: BEGIN
 ZE_WAVECAL_1D_SPEC_V7,index,swmpa2,dataa2,f2canorm,row,gratdet,minrow,numberrows,lkpno,fkpno,read_kpno=0,build_tel_list=0, create_ident_plot=0,build_templ=0,$
                      calib_sci=0,calib_cal=0
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_tel.sav'
    END
    
 2076: BEGIN
 ZE_WAVECAL_1D_SPEC_V7,index,swmpa2,dataa2,f2canorm,row,gratdet,minrow,numberrows,lkpno,fkpno,read_kpno=0,build_tel_list=0, create_ident_plot=0,build_templ=0,$
                      calib_sci=0,calib_cal=0
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_tel.sav'
    END
    
 1087: BEGIN
;restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_lamp.sav'
    END
    
 1090: BEGIN
;restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_lamp.sav'
;lambda_lamp=yfit[0]+yfit[1]*index+yfit[2]*index*index
;swmpa2[*,row]=lambda_lamp/10.
;ZE_WAVECAL_1D_SPEC_V6,index,swmpa2,dataa2,f2canorm,row,grat_angle,det,minrow,numberrows,lkpno,fkpno,read_kpno=1,build_tel_list=1, create_ident_plot=1,build_templ=0,$
;                      build_calonly_templ=1,calib_sci=0,calib_cal=1
;restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_lamp.sav'         
    END

 2150: BEGIN
 ZE_WAVECAL_1D_SPEC_V7,index,swmpa2,dataa2,f2canorm,row,gratdet,minrow,numberrows,lkpno,fkpno,read_kpno=0,build_tel_list=0, create_ident_plot=0,build_templ=0,$
                      calib_sci=0,calib_cal=0
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_tel.sav'
    END
    
 2156: BEGIN
 ZE_WAVECAL_1D_SPEC_V7,index,swmpa2,dataa2,f2canorm,row,gratdet,minrow,numberrows,lkpno,fkpno,read_kpno=0,build_tel_list=0, create_ident_plot=0,build_templ=0,$
                      calib_sci=0,calib_cal=0
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_tel.sav'
    END

ENDCASE

center_ext=0
apradius=0
ZE_EXTRACT_CRIRES_SPEC_V1,dataa2,sizelam,row,center_ext,apradius,spec_ext=spec_ext_raw

;normalize extracted spectrum
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
line_norm,index,spec_ext_raw,spec_ext_rawn,norm_spec_raw_ext,xnodes_rawspec_ext,ynodes_rawspec_ext
tel_from_sci=spec_ext_raw/norm_spec_raw_ext
norm_spec_raw_extn=norm_spec_raw_ext/norm_line_vector[row]

IF grat_angle eq 1087 THEN GOTO,USE_OLD_CAL_TEL
IF grat_angle eq 1090 THEN GOTO,USE_OLD_CAL_TEL


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
GOTO,SCALE_TEL_FWHM

USE_OLD_CAL_TEL:
lambda_newcalt=dblarr(sizelam)
for i=0., sizespat - 1 do begin
lambda_newcal_vac[*,i]=lamvalues_Allpix[*,i]
lambda_newcalt[*]=lamvalues_Allpix[*,i]
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdetold+'_line_auto_lamp_2d.sav'
lambdatel=yfit[0]+yfit[1]*index+yfit[2]*index*index
tel_thre=0.013
where_thre=WHERE(ABS(f2canorm-1.0) lt tel_thre, countt)
IF countt NE 0 THEN f2canorm(where_thre)=1.0
fluxteli=cspline(lambdatel,f2canorm,lambda_newcalt)
fluxteli_2d[*,i]=fluxteli
endfor

;selecting region for removal using linear interpolation, e.g. due to telluric lines residual.
;selecting region for normalization interactively
;undefine,rem_sect
IF n_elements(rem_sect) eq 0 THEN ZE_SELECT_NORM_SECTION,index,dataa2,row,norm_sect=rem_sect
rem_sect=[99,110]
for i=0,sizespat-1 do begin
LINTERP,[rem_sect[0],rem_sect[1]], [dataa2[rem_sect[0],i], dataa2[rem_sect[1],i]],index[rem_sect[0]:rem_sect[1]],yint
dataa2[rem_sect[0]:rem_sect[1],i]=yint
fluxteli_2d[rem_sect[0]:rem_sect[1],i]=1.0
endfor


GOTO,SCALE_TEL_FWHM

SCALE_TEL_FWHM:
;automatically calculates the best scaling AND fwhm between teluric and science spectrum line per line 
scl_min=0.6
scl_max=1.0
scl_step=0.1
scl_size=(scl_max-scl_min)/scl_step + 1.
scl_vector=fltarr(scl_size)
scl_optimum=dblarr(sizespat)

fwhm_min=0.
fwhm_max=15.
fwhm_step=0.5
fwhm_size=(fwhm_max-fwhm_min)/fwhm_step + 1.
fwhm_vector=fltarr(fwhm_size)
fwhm_optimum=dblarr(sizespat)

FOR I=0., scl_size -1 DO scl_vector[i]=scl_min+ (scl_step*i)
FOR I=0, fwhm_size -1 DO fwhm_vector[i]=fwhm_min+(fwhm_step*i)

resid_master=dblarr(scl_size,fwhm_size,sizespat)
min_resid_vector=lonarr(sizespat)
 
FOR j=0, sizespat - 1 DO BEGIN 
  i=0.
  resid=0.
  k=0.
  
  FOR fwhm_val=fwhm_min, fwhm_max, fwhm_step DO BEGIN

    i=0.
    resid=0.
    ftel=fluxteli_2d[*,j]
    ftel_fwhm=cnvlgauss(ftel,fwhm=fwhm_val)   
      FOR scl=scl_min, scl_max, scl_step DO BEGIN
      resid=0.
      ftel_scl=(((ftel_fwhm-1.)*scl)+1.)*norm_spec_raw_extn
      resid=TOTAL(SQRT(ABS((dataa2[*,j]/norm_line_vector[j])-ftel_scl)^2.))
 ;     print,i,k,j,scl,fwhm_val,resid
      resid_master[i,k,j]=resid
      i=i+1
      ENDFOR
    k=k+1
  ENDFOR
  maxloc,1/resid_master[*,*,j],xpos,ypos
  scl_optimum[j]= scl_vector[xpos]
  fwhm_optimum[j]=fwhm_vector[ypos]
  ftel=fluxteli_2d[*,j]
  ftel_fwhm=cnvlgauss(ftel,fwhm=fwhm_optimum[j])  
  fluxteli_2d[*,j]=((ftel_fwhm-1.)*scl_optimum[j]) + 1.
  dataa2[*,j]=dataa2[*,j]/fluxteli_2d[*,j]
  Print, 'Finished spat ',j
ENDFOR


;perform heliocentric correction, always AFTER dividing by the telluric spectrum
for i=0,sizespat-1 do lambda_newcal_vac_hel[*,i]=lambda_newcal_vac[*,i]*(1.+ (vhelio/C))

center_ext=0
apradius=1
ZE_EXTRACT_CRIRES_SPEC_V1,dataa2,sizelam,row,center_ext,apradius,spec_ext=spec_ext

;normalize extracted spectrum
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
line_norm,lambda_newcal_vac_hel[*,row],spec_ext,spec_extn,norm_spec_ext,xnodes_spec_Ext,ynodes_spec_ext

;subtract or divide by the continuum value?
;
;FOR I=0, sizespat -1 DO dataa2[*,i]=dataa2[*,i]/norm_line_vector[i]
;FOR I=0, sizespat -1 DO dataa2[*,i]=dataa2[*,i]-norm_line_vector[i]

;subtracting by the central star spectrum (1 row) using the continuum PSF as reference (i.e. assuming extended continuum emission is due to the PSF wings)
dataa2sub=dataa2
FOR I=0, sizespat -1 DO dataa2sub[*,i]=dataa2[*,i]-(norm_line_vector[i]*spec_extn)

dataa2(WHERE(dataa2) le 0)=0.0001
;using  log
;dataa2=alog10(dataa2)

;using  sqrt
dataa2=SQRT(dataa2)

;plotting image
a=min(dataa2,/NAN)
a=2.0
b=max(dataa2,/NAN)
;b=3.0
print,a,b
img=bytscl(dataa2,MIN=a,MAX=b)
;img=BytScl(data2, TOP=150, MIN=, MAX=105) + 50B
; byte scaling the image for display purposes with tvimage
imginv=255b-img ;invert img
imginv=img
;plotting in window
aa=1300.
bb=400.
window,19,xsize=aa,ysize=bb,retain=0,XPOS=30,YPOS=60
ticklen = 15.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
plot, lambda_newcal_vac_hel[*,row], [(cmi-star-sub)*0.086,(cma-star-sub)*0.086], XTICKFORMAT='(I6)',xstyle=1,ystyle=1, xtitle='Heliocentric vacuum wavelength (Angstrom)', ytitle='offset (arcsec)',$
/NODATA, Position=[0.07, 0.17, 0.94, 0.87],ycharsize=2,xcharsize=2,charthick=1.2,XRANGE=[min(lambda_newcal_vac_hel(*,row)),max(lambda_newcal_vac_hel(*,row))]
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
POSITION=[0.95, 0.17, 0.97, 0.87]
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='Heliocentric velocity (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_newcal_vac_hel[*,row]),lambda0*10^4),ZE_LAMBDA_TO_VEL(max(lambda_newcal_vac_hel[*,row]),lambda0*10^4)],xcharsize=2,charthick=1.2
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_newcal_vac_hel[*,row]),lambda0*10^4),ZE_LAMBDA_TO_VEL(max(lambda_newcal_vac_hel[*,row]),lambda0*10^4)],xcharsize=0

AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[min(lambda_newcal_vac_hel(*,row)),max(lambda_newcal_vac_hel(*,row))],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=0,YRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
;AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[(cmi-star-sub),(cma-star-sub)],ytickv=4,YTICKFORMAT='(I7.0)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
xyouts,1230,360,TEXTOIDL('F/Fmax'),/DEVICE,color=fsc_color('black')
;xyouts,420,870,TEXTOIDL('PA=325^o'),/DEVICE,color=fsc_color('black'),charsize=3
cut1=-4
cut2=4
cut3=0
d1=cut1*0.086
d2=cut2*0.086
d3=cut3*0.086
;xyouts,min(swmpa2[*,row]*10.)-1.,d1,'-->',color=fsc_color('black'),charsize=1,charthick=3
;xyouts,min(swmpa2[*,row]*10.)-1.,d2,'-->',color=fsc_color('orange'),charsize=1,charthick=3

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


LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
;checking wavelength difference between science star and telluric calibrator star for row corresponding to central star
window,12,xsize=900,ysize=400,retain=2
plot,lambda_newcal_vac_hel[*,row],dataa2[*,row],xstyle=1,ystyle=1, xtitle='velocity [km/s]',ytitle='F/Fc',$
yrange=[ymin,ymax],charsize=2,charthick=1.5, /NODATA,POSITION=[0.08,0.2,0.9,0.98]
plots,lambda_newcal_vac_hel[*,row],dataa2[*,row+cut1],noclip=0
plots,lambda_newcal_vac_hel[*,row],dataa2[*,row+cut2],color=fsc_color('orange'),noclip=0,linestyle=2
;flux_sum=dataa2[*,row+cut3]+dataa2[*,row+cut3+1]+dataa2[*,row+cut3-1]
plots,lambda_newcal_vac_hel[*,row],dataa2[*,row+cut3],color=fsc_color('blue'),noclip=0,linestyle=0
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
plots,lambda_newcal_vac_hel[*,row],dataa2[*,row]
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

;capturing TRUE COLOR image of the 2D spectrum to pic2
window,retain=2,xsize=aa,ysize=bb
LOADCT,13 
tvimage,imginv,POSITION=[0,0,0.95,0.95]
pic2=tvrd(0,0,0.95*aa,0.95*bb,/true)
wdelete,!d.window

;plotting to PS file

ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/etc_crires'+gratdet+'.eps'
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
plot, lambda_newcal_vac_hel[*,row], [(cmi-star-sub)*0.086,(cma-star-sub)*0.086], XTICKFORMAT='(I6)',xstyle=1,ystyle=1, xtitle='Heliocentric vacuum wavelength (Angstrom)', ytitle='offset (arcsec)',$
/NODATA, Position=[0.08, 0.18, 0.945, 0.86],XRANGE=[min(lambda_newcal_vac_hel(*,row)),max(lambda_newcal_vac_hel(*,row))]
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

nd=1
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
LOADCT,13
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,CHARSIZE=1.3,$
POSITION=[0.95, 0.18, 0.97, 0.86]

LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='Heliocentric velocity (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_newcal_vac_hel[*,row]),lambda0*10^4),ZE_LAMBDA_TO_VEL(max(lambda_newcal_vac_hel[*,row]),lambda0*10^4)]
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_newcal_vac_hel[*,row]),lambda0*10^4),ZE_LAMBDA_TO_VEL(max(lambda_newcal_vac_hel[*,row]),lambda0*10^4)],xcharsize=0

AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[min(lambda_newcal_vac_hel(*,row)),max(lambda_newcal_vac_hel(*,row))]
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=0,YRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
;AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[(cmi-star-sub),(cma-star-sub)],ytickv=4,YTICKFORMAT='(I7.0)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
xyouts,0.95,0.90,TEXTOIDL('F/Fmax'),/NORMAL,color=fsc_color('black')


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
save,/variables,FILENAME='/Users/jgroh/espectros/etc_'+gratdet+'_allvar.sav'
END
