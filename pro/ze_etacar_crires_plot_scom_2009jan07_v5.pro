;PRO ZE_ETACAR_CRIRES_PLOT_SCOM_2009JAN07_V5,det,pos
;implementing different positions for long exposures
grat_angle=1087
det=2
pos=2
xnodes=0
ynodes=0
xnodes_spec_Ext=0
ynodes_spec_ext=0
gratdet='2009jan07_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_offset'+strcompress(string(pos, format='(I01)'))
gratdet_orig=gratdet ;in order to keep info of the original gratdet, to write the files correctly.
gratdetonstar=strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))

saved_file='/Users/jgroh/espectros/etc_'+gratdet+'_allvar.sav'
if (FILE_EXIST(saved_file) eq 0) then begin
  print,'Saved file not found. No saved file was restored.'
endif else begin
restore,saved_file
endelse

saved_file='/Users/jgroh/espectros/etc_'+gratdetonstar+'_allvar.sav'
if (FILE_EXIST(saved_file) eq 0) then begin
  print,'Saved file not found. No saved file was restored.'
endif else begin
restore,saved_file
endelse
print,'star',star
dirrun='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/'
dirgencalib=dirrun+'GEN_CALIB/' ;for all grats and dets
bpm_file=dirgencalib+'proc/FLAT/CR_PBPM_090107A_3218.6nm.fits'

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
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182823/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182830/cal_proc/'
scoma=dirsci+'CR_SCOM_200182823_2009-01-08T08_01_36.385_DIT1_2070.4nm.fits'
swmpa=dirsci+'CR_SWMA_200182823_2009-01-08T08_01_36.385_DIT1_2070.4nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2070.4nm.fits'
lambda0=2.05869
    END
    
 2076: BEGIN
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182823/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182830/cal_proc/'
scoma=dirsci+'CR_SCOM_200182823_2009-01-08T08_17_22.077_DIT1_2076.6nm.fits'
swmpa=dirsci+'CR_SWMA_200182823_2009-01-08T08_17_22.077_DIT1_2076.6nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2076.6nm.fits'
lambda0=2.05869
    END
    
 1087: BEGIN
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182818/sci_proc/'
dirsciraw='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182818/sci_raw/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182815/cal_proc/'
cal2070=dircal+'CR_PEXT_090107A_DIT30_1087.3nm.fits'
flatfile=dirgencalib+'/proc/FLAT/CR_PFLT_090107A_1087.3nm.fits'
lambda0=1.08333
lambda0=1.0865619
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdetonstar+'_line_auto_lamp_2d.sav'
skyima=dirsciraw+'CRIRE.2009-01-08T07_15_24.521.fits'
;skyima=dirsciraw+'CRIRE.2009-01-08T06_43_37.625.fits'
CASE pos OF 
1:  scoma=dirsciraw+'CRIRE.2009-01-08T06_55_33.586.fits'
2:  scoma=dirsciraw+'CRIRE.2009-01-08T06_59_14.029.fits'  
3:  scoma=dirsciraw+'CRIRE.2009-01-08T07_02_27.748.fits'  
4:  scoma=dirsciraw+'CRIRE.2009-01-08T07_05_42.484.fits'  
5:  scoma=dirsciraw+'CRIRE.2009-01-08T07_08_56.113.fits'  
6:  scoma=dirsciraw+'CRIRE.2009-01-08T07_12_10.890.fits'  
7:  scoma=dirsciraw+'CRIRE.2009-01-08T07_15_24.521.fits' ;sky
8:  scoma=dirsciraw+'CRIRE.2009-01-08T06_43_37.625.fits' ;last exposure on star, to measure y offset
9:  scoma=dirsciraw+'CRIRE.2009-01-08T06_42_37.035.fits' ;first exposure on star, to measure y offset
ENDCASE 
    END
    
 1090: BEGIN
 ;calib was observed with a slightly different angle, before the 1087 OB -- have to apply a shift in v
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182818/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182815/cal_proc/'
dirsciraw='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182818/sci_raw/'
;scoma=dirsci+'CR_SCOM_200182818_2009-01-08T07_20_38.529_DIT1_1090.4nm.fits'
;scoma='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182818/sci_raw/CRIRE.2009-01-08T07_20_38.529.fits'
;scoma='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182815/cal_raw/CRIRE.2009-01-08T06_16_10.580.fits'
swmpa=dirsci+'CR_SWMA_200182818_2009-01-08T07_20_38.529_DIT1_1090.4nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_1090.4nm.fits'
lambda0=1.08333
flatfile=dirgencalib+'/proc/FLAT/CR_PFLT_090107B_1090.4nm.fits'
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdetonstar+'_line_auto_lamp_2d.sav'
skyima=dirsciraw+'CRIRE.2009-01-08T07_42_07.890.fits'
CASE pos OF 
1:  scoma=dirsciraw+'CRIRE.2009-01-08T07_26_38.125.fits'
2:  scoma=dirsciraw+'CRIRE.2009-01-08T07_29_23.168.fits'  
3:  scoma=dirsciraw+'CRIRE.2009-01-08T07_31_54.222.fits'  
4:  scoma=dirsciraw+'CRIRE.2009-01-08T07_34_28.596.fits'  
5:  scoma=dirsciraw+'CRIRE.2009-01-08T07_37_02.619.fits'  
6:  scoma=dirsciraw+'CRIRE.2009-01-08T07_39_34.116.fits'  
7:  scoma=dirsciraw+'CRIRE.2009-01-08T07_42_07.890.fits'
   
ENDCASE
    END

 2150: BEGIN
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182813/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182811/cal_proc/'
scoma=dirsci+'CR_SCOM_200182813_2009-01-08T05_39_02.428_DIT1_2150.0nm.fits'
swmpa=dirsci+'CR_SWMA_200182813_2009-01-08T05_39_02.428_DIT1_2150.0nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2150.0nm.fits'
lambda0=2.16612
    END
    
 2156: BEGIN
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182813/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182811/cal_proc/'
scoma=dirsci+'CR_SCOM_200182813_2009-01-08T05_43_31.459_DIT1_2156.5nm.fits'
swmpa=dirsci+'CR_SWMA_200182813_2009-01-08T05_43_31.459_DIT1_2156.5nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2156.5nm.fits'
lambda0=2.16612
    END

ENDCASE

;ftab_help,scoma

ftab_ext,cal2070,'Wavelength_model,Extracted_OPT',w1ca,f1ca,EXTEN_NO=1
ftab_ext,cal2070,'Wavelength_model,Extracted_OPT',w2ca,f2ca,EXTEN_NO=2
ftab_ext,cal2070,'Wavelength_model,Extracted_OPT',w3ca,f3ca,EXTEN_NO=3
ftab_ext,cal2070,'Wavelength_model,Extracted_OPT',w4ca,f4ca,EXTEN_NO=4

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
    ZE_ETACAR_CRIRES_READ_DETECTOR, bpm_file, 1, bpma2, headerbpma2
    ZE_ETACAR_CRIRES_READ_DETECTOR, flatfile, 1, flata2, headerflata2
    ZE_ETACAR_CRIRES_READ_DETECTOR, skyima, 1, skyima2, headerskyima2
    END
    
 2: BEGIN
    dataa2=dataa2
    swmpa2=swmpa2
    f2ca=f2ca
    w2ca=w2ca 
    ZE_ETACAR_CRIRES_READ_DETECTOR, bpm_file, 2, bpma2, headerbpma2
    ZE_ETACAR_CRIRES_READ_DETECTOR, flatfile, 2, flata2, headerflata2
    ZE_ETACAR_CRIRES_READ_DETECTOR, skyima, 2, skyima2, headerskyima2
    lambda0=1.08333
    END
    
 3: BEGIN
    dataa2=dataa3
    swmpa2=swmpa3
    f2ca=f3ca
    w2ca=w3ca 
    ZE_ETACAR_CRIRES_READ_DETECTOR, bpm_file, 3, bpma2, headerbpma2
    ZE_ETACAR_CRIRES_READ_DETECTOR, flatfile, 3, flata2, headerflata2
    ZE_ETACAR_CRIRES_READ_DETECTOR, skyima, 3, skyima2, headerskyima2
    lambda0=1.0865619
    END
    
 4: BEGIN
    dataa2=dataa4
    swmpa2=swmpa4
    f2ca=f4ca
    w2ca=w4ca 
    ZE_ETACAR_CRIRES_READ_DETECTOR, bpm_file, 4, bpma2, headerbpma2
    ZE_ETACAR_CRIRES_READ_DETECTOR, flatfile, 4, flata2, headerflata2
    ZE_ETACAR_CRIRES_READ_DETECTOR, skyima, 4, skyima2, headerskyima2
    END

ENDCASE
keyword='SEQ CUMOFFSETX'
ZE_ESO_FITS_HIERARCHY_RETURN_KEYWORD,headera0,keyword,cumoffsetx
print,'Offset x [arcsec]', cumoffsetx*0.085

keyword='SEQ CUMOFFSETY'
ZE_ESO_FITS_HIERARCHY_RETURN_KEYWORD,headera0,keyword,cumoffsety
print,'Offset y [arcsec]', cumoffsety*0.085

;keyword='DET DIT'
;ZE_ESO_FITS_HIERARCHY_RETURN_KEYWORD,headera0,keyword,dit
;
;keyword='DET NDIT'
;ZE_ESO_FITS_HIERARCHY_RETURN_KEYWORD,headera0,keyword,ndit

;removing bad pixels
dataa2(WHERE(bpma2 eq 1))=0

dataa2=dataa2 - skyima2

;dividing by flat field
dataa2=dataa2/flata2

sizespat=(size(dataa2))[2]

offset_center=256-221.884
star=sizespat/2.-offset_center
print,'star2',star
sub=-0.5
row=sizespat/2.
row=30
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
date_obs=[2009,1,7,07]
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
;line_norm,w2ca,f2ca,f2canorm,norm,xnodes,ynodes

  ;

  ;shifting each column by the offset (i.e. shifting in spatial direction)  ; shifting also the lambda IMAGE for consistency (JHG 09 April 09, 12 21 pm)
  prel=dblarr((size(dataa2))[2])  
  prel2=prel
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
undefine,norm_sect
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
lambda_lamp=yfit[0]+yfit[1]*index+yfit[2]*index*index
swmpa2[*,row]=lambda_lamp/10.
;uncomment the line below if you want to do wavelength calibration of the teluric star; needed for Jan 2009 data 1090 
;ZE_WAVECAL_1D_SPEC_V6,index,swmpa2,dataa2,f2canorm,row,grat_angle,det,minrow,numberrows,lkpno,fkpno,read_kpno=1,build_tel_list=1, create_ident_plot=1,build_templ=0,$
;                      build_calonly_templ=1,calib_sci=0,calib_cal=1
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_tel.sav'         
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


IF grat_angle eq 1087 THEN GOTO,USE_OLD_CAL_TEL
;IF grat_angle eq 1090 THEN GOTO,USE_OLD_CAL_TEL


polycal_tel=dblarr(3)
polycal_tel[0]=yfit[0]
polycal_tel[1]=yfit[1]
polycal_tel[2]=yfit[2]

for i=0., sizespat - 1 do begin
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_tel.sav'  
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
;fwhm=0
;fwhm=ABS(11.437 -0.1769*i)
fluxteli=cnvlgauss(fluxteli,fwhm=fwhm)
fluxteli_2d[*,i]=fluxteli
endfor
GOTO,SCALE_TEL_FWHM

USE_OLD_CAL_TEL:
lambda_newcalt=dblarr(sizelam)
lambda_newcal_vac=lamvalues_Allpix
lambda_newcalt[*]=lamvalues_Allpix[*,row]
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdetonstar+'_line_auto_lamp_2d.sav'
lambdatel=yfit[0]+yfit[1]*index+yfit[2]*index*index
lambdatel=lambda_newcalt


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

SCALE_TEL_FWHM:

;calculate the best velocity shift between telluric and science calibrations, WHEN different lamps were used. WORKING FINE
;velshift_min=0.21
;velshift_max=0.26
;velshift_step=0.01
;velshift_size=(velshift_max-velshift_min)/velshift_step + 1
;velshift_vector=fltarr(velshift_size)
;velshift_optimum=dblarr(sizespat)
;temp1=dblarr(sizelam)
;ftemp1=temp1
;FOR I=0., velshift_size -1 DO velshift_vector[i]=velshift_min+ (velshift_step*i)
;vel_resid_master=dblarr(velshift_size,sizespat)
;vel_min_resid_vector=lonarr(sizespat)
;FOR j=0, sizespat - 1 DO BEGIN 
;  i=0.
;  resid=0.
;  FOR velshift=velshift_min, velshift_max, velshift_step DO BEGIN
;    resid=0.
;    temp1[*]=lambda_newcal_vac[*,j]
;    ftemp1[*]=fluxteli_2d[*,j]
;    ftel_velshift=ZE_SHIFT_SPECTRA_VEL(temp1,ftemp1,velshift)*norm_spec_raw_extn
;    vel_resid=TOTAL(SQRT(ABS((dataa2[*,j]/norm_line_vector[j])-ftel_velshift)^2.))
;    vel_resid_master[i,j]=vel_resid
;    i=i+1
;  ENDFOR
;  velshift_temp=MIN(vel_resid_master[*,j], velshift_min_index)
;  vel_min_resid_vector[j]=velshift_min_index
;  velshift_optimum[j]= velshift_vector[velshift_min_index]
;  ftel_shift_t=ZE_SHIFT_SPECTRA_VEL(temp1,ftemp1,velshift_optimum[j])
;  fluxteli_2d[*,j]=ftel_shift_t
;  
;ENDFOR
;
;
;
;
;;automatically calculates the best scaling AND fwhm between teluric and science spectrum line per line 
;scl_min=0.6
;scl_max=1.2
;scl_step=0.05
;scl_size=(scl_max-scl_min)/scl_step +1.
;scl_vector=fltarr(scl_size)
;scl_optimum=dblarr(sizespat)
;
;fwhm_min=0.
;fwhm_max=0.2
;fwhm_step=0.01
;fwhm_size=(fwhm_max-fwhm_min)/fwhm_step +1.
;fwhm_vector=fltarr(fwhm_size)
;fwhm_optimum=dblarr(sizespat)
;
;FOR I=0., scl_size -1 DO scl_vector[i]=scl_min+ (scl_step*i)
;FOR I=0, fwhm_size -1 DO fwhm_vector[i]=fwhm_min+(fwhm_step*i)
;
;resid_master=dblarr(scl_size,fwhm_size,sizespat)
;min_resid_vector=lonarr(sizespat)
; 
;FOR j=0, sizespat - 1 DO BEGIN 
;  i=0.
;  resid=0.
;  k=0.
;  
;  FOR fwhm_val=fwhm_min, fwhm_max, fwhm_step DO BEGIN
;
;    i=0.
;    resid=0.
;    ftel=fluxteli_2d[*,j]
;    ftel_fwhm=cnvlgauss(ftel,fwhm=fwhm_val)   
;      FOR scl=scl_min, scl_max, scl_step DO BEGIN
;      resid=0.
;      ftel_scl=(((ftel_fwhm-1.)*scl)+1.)*norm_spec_raw_extn
;      resid=TOTAL(SQRT(ABS((dataa2[*,j]/norm_line_vector[j])-ftel_scl)^2.))
;      print,i,k,j,scl,fwhm_val,resid
;      resid_master[i,k,j]=resid
;      i=i+1
;      ENDFOR
;    k=k+1
;  ENDFOR
;  resid_zero=WHERE(resid_master eq 0., count)
;  if count gt 0. THEN resid_master(resid_zero)=10000000.
;  maxloc,1/resid_master[*,*,j],xpos,ypos
;  scl_optimum[j]= scl_vector[xpos]
;  fwhm_optimum[j]=fwhm_vector[ypos]
;  ftel=fluxteli_2d[*,j]
;  ftel_fwhm=cnvlgauss(ftel,fwhm=fwhm_optimum[j])  
;  fluxteli_2d[*,j]=((ftel_fwhm-1.)*scl_optimum[j]) + 1.
;  dataa2[*,j]=dataa2[*,j]/fluxteli_2d[*,j] ;/norm
;  Print, 'Finished spat ',j
;ENDFOR


;perform heliocentric correction, always AFTER dividing by the telluric spectrum
for i=0,sizespat-1 do lambda_newcal_vac_hel[*,i]=lambda_newcal_vac[*,i]*(1.+ (vhelio/C))


;normalize extracted spectrum
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
;line_norm,lambda_newcal_vac_hel[*,row],spec_ext,spec_extn,norm_spec_ext,xnodes_spec_Ext,ynodes_spec_ext
dataa2psfsub=dataa2
dataa2contdiv=dataa2
dataa2contsub=dataa2

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

min_val=2.0
;dataa2(WHERE(dataa2) le min_val)=0.0001
dataa2(WHERE(dataa2) le 0)=0.0001
;using  log
;dataa2=alog10(dataa2)
;using  sqrt
dataa2=SQRT(dataa2)

;plotting image
a=min(dataa2,/NAN)
a=1.0
;a=alog10(a)
b=max(dataa2,/NAN)
b=24.0
print,a,b
img=bytscl(dataa2,MIN=a,MAX=b)
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
xyouts,0.25,0.80,'Pos'+strcompress(STRING(FIX(pos)))+', '+number_formatter(cumoffsetx*0.085,decimals=2)+' NW '+TEXTOIDL('PA=325^o'),/NORMAL,color=fsc_color('white')
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


LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

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
ps_filename='/Users/jgroh/temp/etc_crires'+gratdet_orig+'.eps'
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
xyouts,0.25,0.75,'Pos'+strcompress(STRING(FIX(pos)))+', '+number_formatter(cumoffsetx*0.085,decimals=2)+' NW '+TEXTOIDL('PA=325^o'),/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=8



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
undefine,gratdet1,gratdet2,gratdet_orig,gratdet,gratdet_onstar
;save,/variables,FILENAME='/Users/jgroh/espectros/etc_'+gratdet+'_allvar.sav'
;ZE_CRIRES_PLOT_SPATPROFILE,indexspat,dataa2,100,200,400,prof1,prof2,prof3



END