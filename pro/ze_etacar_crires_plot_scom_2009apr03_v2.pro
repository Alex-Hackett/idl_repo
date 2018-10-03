;PRO ZE_ETACAR_CRIRES_PLOT_SCOM_2009APR03_V2,scoma,swmpa,cal2070

;reseting main program variables
UNDEFINE,star,norm_sect
grat_angle=1090
det=3
xnodes=0
ynodes=0
xnodes_spec_Ext=0
ynodes_spec_ext=0
gratdet='2009apr03_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))
gratdet_orig=gratdet
gratdetold=strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)')) ;used for retrieving data from other epochs, e.g. for wavecal
dircriresrun='/Users/jgroh/data/eso_vlt/crires/Etacar/383D-0240A_2009Apr03/'

dirgencalib=dircriresrun+'GEN_CALIB/' ;for all grats and dets
bpm_file=dirgencalib+'proc/FLAT/CR_PBPM_090402A_3218.6nm.fits'


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


CASE grat_angle of

 2070: BEGIN
dirsci=dircriresrun+'361950/sci_proc/'
dircal=dircriresrun+'361952/cal_proc/'
scoma=dirsci+'CR_SCOM_200182823_2009-01-08T08_01_36.385_DIT1_2070.4nm.fits'
swmpa=scoma
strreplace,swmpa,'SCOM','SWMA' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2070.4nm.fits'
lambda0=2.05869
    END
    
 2076: BEGIN
dirsci=dircriresrun+'361950/sci_proc/'
dircal=dircriresrun+'361952/cal_proc/'
scoma=dirsci+'CR_SCOM_200182823_2009-01-08T08_17_22.077_DIT1_2076.6nm.fits'
swmpa=scoma
strreplace,swmpa,'SCOM','SWMA' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2076.6nm.fits'
lambda0=2.05869
    END

 1087: BEGIN
dirsci=dircriresrun+'361944/sci_proc/'
dircal=dircriresrun+'361942/cal_proc/'
scoma=dirsci+'CR_SCOM_361944_2009-04-03T01_27_00.321_DIT1_1087.3nm.fits'
swmpa=scoma
strreplace,swmpa,'SCOM','SWMA' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090402A_DIT30_1087.3nm.fits'
lampfile='/Users/jgroh/espectros/thar_kerber_cut_vac.txt'
flatfile=dirgencalib+'/proc/FLAT/CR_PFLT_090402A_1087.3nm.fits'
row=255
lambda0=1.08333
restore,'/Users/jgroh/espectros/etc_poly_wavecal_2009apr03_1086_'+strcompress(string(det, format='(I01)'))+'_line_auto_lamp_2d.sav'
lamvalues_Allpix_tel=lamvalues_Allpix
undefine,lamvalues_Allpix
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_lamp_2d.sav'
    END
    
 1090: BEGIN
dirsci=dircriresrun+'361944/sci_proc/'
dircal=dircriresrun+'361942/cal_proc/' ;no cal obs were done!
scoma=dirsci+'CR_SCOM_361944_2009-04-03T01_55_45.352_DIT1_1090.4nm.fits'
swmpa=scoma
strreplace,swmpa,'SCOM','SWMA' ;SWMA files look better
;scoma=dircriresrun+'361944/sci_raw/CRIRE.2009-04-03T01_55_45.352.fits'
;scoma=dircriresrun+'361942/cal_raw/CRIRE.2009-04-03T02_34_26.568.fits'
cal2070=dircal+'CR_PEXT_090402B_DIT30_1090.4nm.fits'
lampfile='/Users/jgroh/espectros/thar_kerber_cut_vac.txt'
flatfile=dirgencalib+'/proc/FLAT/CR_PFLT_090402B_1090.4nm.fits'
row=255
lambda0=1.08333
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_lamp_2d.sav'
    END

 2150: BEGIN
dirsci=dircriresrun+'361947/sci_proc/'
dircal=dircriresrun+'361940/cal_proc/'
scoma=dirgencalib+'raw/ARC/CRIRE.2009-01-08T05_27_46.918.fits'
swmpa=scoma
strreplace,swmpa,'SCOM','SWMA' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2150.0nm.fits'
lampfile='/Users/jgroh/espectros/thar_kerber_cut_vac.txt'
row=14
flatfile=dirgencalib+'/proc/FLAT/CR_PFLT_090402A_2150.0nm.fits'
lambda0=2.16612
    END
   
 2156: BEGIN
dirsci=dircriresrun+'361947/sci_proc/'
dircal=dircriresrun+'361940/cal_proc/'
scoma=dirgencalib+'raw/ARC/CRIRE.2009-01-08T05_51_03.337.fits'
swmpa=scoma
strreplace,swmpa,'SCOM','SWMA' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2156.5nm.fits'
lampfile='/Users/jgroh/espectros/thar_kerber_cut_vac.txt'
row=14
flatfile=dirgencalib+'/proc/FLAT/CR_PFLT_090402A_2156.5nm.fits'
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

;slit centered on the central star, thus offset is always zero. Needed to plot the images later.
pos=0.0
cumoffsetx=0.0
signcumoffsetx=SIGN(cumoffsetx)

sub=-0.5
row=120 ;original for offset montage
row=15
crop=row
cmi=star-crop
cma=star+crop-1
swmpa2=swmpa2[*,cmi:cma]
dataa2=dataa2[*,cmi:cma]
IF n_elements(lamvalues_Allpix) NE 0 THEN lamvalues_Allpix=lamvalues_Allpix[*,cmi:cma]
IF n_elements(lamvalues_Allpix_tel) NE 0 THEN lamvalues_Allpix_tel=lamvalues_Allpix_tel[*,cmi:cma]

dataa2=shift_sub(dataa2,0,sub)
IF n_elements(lamvalues_Allpix) NE 0 THEN lamvalues_Allpix=shift_sub(lamvalues_Allpix,0,sub)
IF n_elements(lamvalues_Allpix_tel) NE 0 THEN lamvalues_Allpix_tel=shift_sub(lamvalues_Allpix_tel,0,sub)

ra_obs=[10,45,03.00]
dec_obs=[-59,41,03.0]
date_obs=[2009,4,3,07]
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
  prel3=prel
  for i=0, (size(dataa2))[1] - 1 do begin
  prel[*]=dataa2[i,*]
  prel=shiftf(prel,-1.*spatoffset[i])
  dataa2[i,*]=prel
  
  IF n_elements(lamvalues_Allpix) NE 0 THEN BEGIN
  prel2[*]=lamvalues_Allpix[i,*]
  prel2=shiftf(prel2,-1.*spatoffset[i])
  lamvalues_Allpix[i,*]=prel2
  ENDIF
  
  IF n_elements(lamvalues_Allpix_tel) NE 0 THEN BEGIN 
  prel3[*]=lamvalues_Allpix_tel[i,*]
  prel3=shiftf(prel3,-1.*spatoffset[i])
  lamvalues_Allpix_tel[i,*]=prel3
  ENDIF
  
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
lambda_newcal_tel=dblarr(sizelam,sizespat)
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

IF grat_angle eq 1087 THEN GOTO,USE_ALT_CAL_TEL
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

fwhm=0
;fwhm=ABS(11.437 -0.1769*i)
fluxteli=cnvlgauss(fluxteli,fwhm=fwhm)
fluxteli_2d[*,i]=fluxteli
endfor
GOTO,SCALE_TEL_FWHM

USE_OLD_CAL_TEL:
lambda_newcalt=dblarr(sizelam)
spawn,'cp /Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'pos02_line_auto_lamp.sav /Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_lamp.sav'
for i=0., sizespat - 1 do begin
lambda_newcal_vac[*,i]=lamvalues_Allpix[*,i]
lambda_newcalt[*]=lamvalues_Allpix[*,i]
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_lamp.sav'
lambdatel=yfit[0]+yfit[1]*index+yfit[2]*index*index
tel_thre=0.00
where_thre=WHERE(ABS(f2canorm-1.0) lt tel_thre, countt)
IF countt NE 0 THEN f2canorm(where_thre)=1.0
fluxteli=cspline(lambdatel,f2canorm,lambda_newcalt)
fluxteli_2d[*,i]=fluxteli
endfor

;selecting region for removal using linear interpolation, e.g. due to telluric lines residual.
;selecting region for normalization interactively
;undefine,rem_sect
;IF n_elements(rem_sect) eq 0 THEN ZE_SELECT_NORM_SECTION,index,dataa2,row,norm_sect=rem_sect
;rem_sect=[99,110]
;for i=0,sizespat-1 do begin
;LINTERP,[rem_sect[0],rem_sect[1]], [dataa2[rem_sect[0],i], dataa2[rem_sect[1],i]],index[rem_sect[0]:rem_sect[1]],yint
;dataa2[rem_sect[0]:rem_sect[1],i]=yint
;fluxteli_2d[rem_sect[0]:rem_sect[1],i]=1.0
;endfor
GOTO,SCALE_TEL_FWHM

USE_ALT_CAL_TEL:
lambda_newcalt=dblarr(sizelam)
lambda_newcalt_tel=dblarr(sizelam)
for i=0., sizespat - 1 do begin
lambda_newcal_vac[*,i]=lamvalues_Allpix[*,i]
lambda_newcalt[*]=lamvalues_Allpix[*,i]
lambda_newcal_tel[*,i]=lamvalues_Allpix_tel[*,i]
lambda_newcalt_tel[*]=lamvalues_Allpix_tel[*,i]
tel_thre=0.013
where_thre=WHERE(ABS(f2canorm-1.0) lt tel_thre, countt)
IF countt NE 0 THEN f2canorm(where_thre)=1.0
fluxteli=cspline(lambda_newcalt_tel,f2canorm,lambda_newcalt)
fluxteli_2d[*,i]=fluxteli
endfor

;calculate the best velocity shift between telluric and science calibrations, WHEN different lamps were used. WORKING FINE
velshift_min=-0.7
velshift_max=-0.3
velshift_step=0.01
velshift_size=(velshift_max-velshift_min)/velshift_step + 1
velshift_vector=fltarr(velshift_size)
velshift_optimum=dblarr(sizespat)
temp1=dblarr(sizelam)
ftemp1=temp1
FOR I=0., velshift_size -1 DO velshift_vector[i]=velshift_min+ (velshift_step*i)
vel_resid_master=dblarr(velshift_size,sizespat)
vel_min_resid_vector=lonarr(sizespat)
FOR j=0, sizespat - 1 DO BEGIN 
  i=0.
  resid=0.
  FOR velshift=velshift_min, velshift_max, velshift_step DO BEGIN
    resid=0.
    temp1[*]=lambda_newcal_tel[*,j]
    ftemp1[*]=fluxteli_2d[*,j]
    ftel_velshift=ZE_SHIFT_SPECTRA_VEL(temp1,ftemp1,velshift)*norm_spec_raw_extn
    vel_resid=TOTAL(SQRT(ABS((dataa2[*,j]/norm_line_vector[j])-ftel_velshift)^2.))
    vel_resid_master[i,j]=vel_resid
    i=i+1
  ENDFOR
  velshift_temp=MIN(vel_resid_master[*,j], velshift_min_index)
  vel_min_resid_vector[j]=velshift_min_index
  velshift_optimum[j]= velshift_vector[velshift_min_index]
  ftel_shift_t=ZE_SHIFT_SPECTRA_VEL(temp1,ftemp1,velshift_optimum[j])
  fluxteli_2d[*,j]=ftel_shift_t
  
ENDFOR

GOTO,SCALE_TEL_FWHM

SCALE_TEL_FWHM:
;automatically calculates the best scaling AND fwhm between teluric and science spectrum line per line 
scl_min=0.9
scl_max=1.4
scl_step=0.05
scl_size=(scl_max-scl_min)/scl_step + 1.
scl_vector=fltarr(scl_size)
scl_optimum=dblarr(sizespat)

fwhm_min=0.
fwhm_max=5.
fwhm_step=0.2
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
  resid_zero=WHERE(resid_master eq 0., count)
  if count gt 0. THEN resid_master(resid_zero)=10000000.
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
line_norm,lambda_newcal_vac_hel[*,row],norm_spec_ext,norm_spec_extn,level_norm_spec_ext,xnodes_level,ynodes_level


dataa2psfsub=dataa2
dataa2contdiv=dataa2
dataa2contsub=dataa2


;subtracting the central star spectrum (from pos 8+9, 1 row) using the continuum PSF as reference (i.e. assuming extended continuum emission is due to the PSF wings)
FOR I=0, sizespat -1 DO BEGIN
norm_line_val=(MOMENT(dataa2[800:968,i]))[0]
dataa2psfsub[*,i]=dataa2[*,i]-(norm_line_vector[i]*spec_extn)
ENDFOR

;subtract or divide by the continuum value?
FOR I=0, sizespat -1 DO dataa2contdiv[*,i]=dataa2[*,i]/norm_line_vector[i]
FOR I=0, sizespat -1 DO dataa2contsub[*,i]=dataa2[*,i]-norm_line_vector[i]
;
;dataa2=dataa2psfsub
;dataa2=dataa2contdiv
;dataa2=dataa2contsub

aa=1300.
bb=400.

a=1.
b=50.
ZE_ETACAR_CRIRES_CREATE_GENERIC_IMAGE_FROM_DATAA2,dataa2,a,b,img,SQRT=1,LOG=0
ZE_ETACAR_CRIRES_PLOT_GENERIC_IMAGE_XWINDOW,img,a,b,lambda_newcal_vac_hel,cmi,cma,star,sub,row,aa,bb,pos,cumoffsetx,signcumoffsetx,lambda0
imgname='etc_crires'+gratdet_orig
ZE_ETACAR_CRIRES_PLOT_GENERIC_IMAGE_EPS,img,a,b,imgname,lambda_newcal_vac_hel,cmi,cma,star,sub,row,aa,bb,pos,cumoffsetx,signcumoffsetx,lambda0
;;
a=1.
b=50.
ZE_ETACAR_CRIRES_CREATE_GENERIC_IMAGE_FROM_DATAA2,dataa2contsub,a,b,imgcontsub,SQRT=1,LOG=0
ZE_ETACAR_CRIRES_PLOT_GENERIC_IMAGE_XWINDOW,imgcontsub,a,b,lambda_newcal_vac_hel,cmi,cma,star,sub,row,aa,bb,pos,cumoffsetx,signcumoffsetx,lambda0
imgname='etc_crires'+gratdet_orig+'_contsub'
ZE_ETACAR_CRIRES_PLOT_GENERIC_IMAGE_EPS,imgcontsub,a,b,imgname,lambda_newcal_vac_hel,cmi,cma,star,sub,row,aa,bb,pos,cumoffsetx,signcumoffsetx,lambda0
;
a=0.6
b=1.8
ZE_ETACAR_CRIRES_CREATE_GENERIC_IMAGE_FROM_DATAA2,dataa2contdiv,a,b,imgcontdiv,SQRT=1,LOG=0
ZE_ETACAR_CRIRES_PLOT_GENERIC_IMAGE_XWINDOW,imgcontdiv,a,b,lambda_newcal_vac_hel,cmi,cma,star,sub,row,aa,bb,pos,cumoffsetx,signcumoffsetx,lambda0
imgname='etc_crires'+gratdet_orig+'_contdiv'
ZE_ETACAR_CRIRES_PLOT_GENERIC_IMAGE_EPS,imgcontdiv,a,b,imgname,lambda_newcal_vac_hel,cmi,cma,star,sub,row,aa,bb,pos,cumoffsetx,signcumoffsetx,lambda0
;
a=0.
b=30.
ZE_ETACAR_CRIRES_CREATE_GENERIC_IMAGE_FROM_DATAA2,dataa2psfsub,a,b,imgpsfsub,SQRT=1,LOG=0
ZE_ETACAR_CRIRES_PLOT_GENERIC_IMAGE_XWINDOW,imgpsfsub,a,b,lambda_newcal_vac_hel,cmi,cma,star,sub,row,aa,bb,pos,cumoffsetx,signcumoffsetx,lambda0
imgname='etc_crires'+gratdet_orig+'_psfsub'
ZE_ETACAR_CRIRES_PLOT_GENERIC_IMAGE_EPS,imgpsfsub,a,b,imgname,lambda_newcal_vac_hel,cmi,cma,star,sub,row,aa,bb,pos,cumoffsetx,signcumoffsetx,lambda0

set_plot,'x'

!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0
undefine,gratdet1,gratdet2,gratdet,gratdet_onstar
;save,/variables,FILENAME='/Users/jgroh/espectros/etc_'+gratdet_orig+'_allvar.sav'
;ZE_CRIRES_PLOT_SPATPROFILE,indexspat,dataa2,100,200,400,prof1,prof2,prof3
center_ext=0
apradius=1
;ZE_EXTRACT_CRIRES_SPEC_V1,dataa2,sizelam,row,center_ext,apradius,spec_ext=spec_ext
END