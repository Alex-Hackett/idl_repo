;PRO ZE_ETACAR_CRIRES_PLOT_SCOM_2008MAY05_OFFSET_V1,scoma,swmpa,cal2070
;v5 implementing different positions for long exposures
;v6 implements EPS plot routines in different procedures
grat_angle=1087
det=2
pos=1
xnodes=0
ynodes=0
xnodes_spec_Ext=0
ynodes_spec_ext=0

gratdet='2008may_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_offset'+strcompress(string(pos, format='(I01)'))
gratdet_orig=gratdet ;in order to keep info of the original gratdet, to write the files correctly.
gratdetonstar='2008may_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))
gratdetold=strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)')) ;used for retrieving data from other epochs, e.g. for wavecal
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
help,swmpa2
print,'star',star
fluxtel=fluxteli_2d[*,row]

dircriresrun='/Users/jgroh/data/eso_vlt/crires/Etacar/381D-0262A_C01/'
dirgencalib=dircriresrun+'GEN_CALIB/' ;for all grats and dets
bpm_file=dirgencalib+'proc/FLAT/CR_PBPM_080504A_3218.6nm.fits'

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
dirsci=dircriresrun+'310723/sci_proc/'
dircal=dircriresrun+'310711/cal_proc/'
dirsciraw=dircriresrun+'310723/sci_raw/'
cal2070=dircal+'CR_PEXT_080504A_DIT30_1087.3nm.fits'
flatfile=dirgencalib+'/proc/FLAT/CR_PFLT_080504A_1087.3nm.fits'
lambda0=1.08333

restore,'/Users/jgroh/espectros/etc_poly_wavecal_2009apr03_1086_'+strcompress(string(det, format='(I01)'))+'_line_auto_lamp_2d.sav'
lamvalues_Allpix_tel=lamvalues_Allpix
undefine,lamvalues_Allpix
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdetold+'_line_auto_lamp_2d.sav' 


skyima=dirsciraw+'CRIRE.2008-05-05T00:48:10.420.fits' ;no sky image, just putting anything for test
skyima=dirgencalib+'/raw/DET/CRIRE.2008-05-02T17:35:05.774.fits'
astrometry_ref_image=dirsciraw+'CRIRE.2008-05-05T00:48:10.420.fits' ;last exposure on star, to measure y offset
;skyima=dirsciraw+'CRIRE.2009-01-08T06_43_37.625.fits'
;temporal order does not follow the pos convention of jan, thus reversing it
CASE pos OF 
1:  scoma=dirsciraw+'CRIRE.2008-05-05T00:50:23.751.fits'
5:  scoma=dirsciraw+'CRIRE.2008-05-05T00:51:40.736.fits'  
6:  scoma=dirsciraw+'CRIRE.2008-05-05T00:53:40.728.fits' 
3:  scoma=dirsciraw+'CRIRE.2008-05-05T00:55:38.027.fits'  
2:  scoma=dirsciraw+'CRIRE.2009-04-03T01_35_07.967.fits'  
1:  scoma=dirsciraw+'CRIRE.2009-04-03T01_36_30.245.fits'  
7:  scoma=dirsciraw+'CRIRE.2009-04-03T01_37_52.229.fits' ;sky
8:  scoma=dirsciraw+'CRIRE.2008-05-05T00_48_10.420.fits' ;last exposure on star, to measure y offset
9:  scoma=dirsciraw+'CRIRE.2008-05-05T00_46_49.941.fits' ;first exposure on star, to measure y offset
ENDCASE 
    END
    
 1090: BEGIN
dirsci=dircriresrun+'361944/sci_proc/'
dircal=dircriresrun+'361942/cal_proc/'
dirsciraw=dircriresrun+'361944/sci_raw/'
;scoma=dirsci+'CR_SCOM_352647_2009-02-09T06_12_38.858_DIT1_1087.3nm.fits'
;swmpa=scoma
;strreplace,swmpa,'SCOM','SWMA' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090402B_DIT30_1090.4nm.fits'
flatfile=dirgencalib+'/proc/FLAT/CR_PFLT_090402B_1090.4nm.fits'
lambda0=1.08333
restore,'/Users/jgroh/espectros/etc_poly_wavecal_2009apr03_1086_'+strcompress(string(det, format='(I01)'))+'_line_auto_lamp_2d.sav'
lamvalues_Allpix_tel=lamvalues_Allpix
undefine,lamvalues_Allpix
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_lamp_2d.sav' 


skyima=dirsciraw+'CRIRE.2009-04-03T01_37_52.229.fits'
astrometry_ref_image=dirsciraw+'CRIRE.2009-04-03T01_57_03.727.fits' ;last exposure on star, to measure y offset
;skyima=dirsciraw+'CRIRE.2009-01-08T06_43_37.625.fits'
;temporal order does not follow the pos convention of jan, thus reversing it
CASE pos OF 
4:  scoma=dirsciraw+'CRIRE.2009-04-03T01_58_35.929.fits'
5:  scoma=dirsciraw+'CRIRE.2009-04-03T01_59_55.164.fits'  
6:  scoma=dirsciraw+'CRIRE.2009-04-03T02_01_14.784.fits' 
3:  scoma=dirsciraw+'CRIRE.2009-04-03T02_02_32.709.fits'  
2:  scoma=dirsciraw+'CRIRE.2009-04-03T02_04_12.569.fits'  
1:  scoma=dirsciraw+'CRIRE.2009-04-03T02_05_31.869.fits'  
7:  scoma=dirsciraw+'CRIRE.2009-04-03T01_37_52.229.fits' ;sky
8:  scoma=dirsciraw+'CRIRE.2009-04-03T01_57_03.727.fits' ;last exposure on star, to measure y offset
9:  scoma=dirsciraw+'CRIRE.2009-04-03T01_55_45.352.fits' ;first exposure on star, to measure y offset
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
    ZE_ETACAR_CRIRES_READ_DETECTOR, astrometry_ref_image, 0, astrometry_ref_image0, headerastrometry_ref_image0
    ZE_ETACAR_CRIRES_READ_DETECTOR, astrometry_ref_image, 1, astrometry_ref_image2, headerastrometry_ref_image2
    END
    
 2: BEGIN
    dataa2=dataa2
    swmpa2=swmpa2
    f2ca=f2ca
    w2ca=w2ca 
    ZE_ETACAR_CRIRES_READ_DETECTOR, bpm_file, 2, bpma2, headerbpma2
    ZE_ETACAR_CRIRES_READ_DETECTOR, flatfile, 2, flata2, headerflata2
    ZE_ETACAR_CRIRES_READ_DETECTOR, skyima, 2, skyima2, headerskyima2
    ZE_ETACAR_CRIRES_READ_DETECTOR, astrometry_ref_image, 0, astrometry_ref_image0, headerastrometry_ref_image0
    ZE_ETACAR_CRIRES_READ_DETECTOR, astrometry_ref_image, 2, astrometry_ref_image2, headerastrometry_ref_image2
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
    ZE_ETACAR_CRIRES_READ_DETECTOR, astrometry_ref_image, 0, astrometry_ref_image0, headerastrometry_ref_image0
    ZE_ETACAR_CRIRES_READ_DETECTOR, astrometry_ref_image, 3, astrometry_ref_image2, headerastrometry_ref_image2
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
    ZE_ETACAR_CRIRES_READ_DETECTOR, astrometry_ref_image, 0, astrometry_ref_image0, headerastrometry_ref_image0
    ZE_ETACAR_CRIRES_READ_DETECTOR, astrometry_ref_image, 4, astrometry_ref_image2, headerastrometry_ref_image2
    lambda0=1.0941091
    END

ENDCASE
keyword='SEQ CUMOFFSETX'
ZE_ESO_FITS_HIERARCHY_RETURN_KEYWORD,headera0,keyword,cumoffsetx
print,'Offset x [arcsec]', cumoffsetx*0.085
signcumoffsetx=SIGN(cumoffsetx)

keyword='SEQ CUMOFFSETY'
ZE_ESO_FITS_HIERARCHY_RETURN_KEYWORD,headera0,keyword,cumoffsety
print,'Offset y [arcsec]', cumoffsety*0.085

keyword='SEQ CUMOFFSETY'
ZE_ESO_FITS_HIERARCHY_RETURN_KEYWORD,headerastrometry_ref_image0,keyword,cumoffsety_ref
print,'Offset y reference [arcsec]', cumoffsety_ref*0.085

;keyword='DET DIT'
;ZE_ESO_FITS_HIERARCHY_RETURN_KEYWORD,headera0,keyword,dit
;
;keyword='DET NDIT'
;ZE_ESO_FITS_HIERARCHY_RETURN_KEYWORD,headera0,keyword,ndit

;removing bad pixels
dataa2(WHERE(bpma2 eq 1))=0
;dataa2=sigma_filter(dataa2,5)

dataa2=dataa2 - skyima2

;dividing by flat field
dataa2=dataa2/flata2

sizespat=(size(dataa2))[2]
;print,sizespat
;offset_center=256-221.884 ;valid ONLY for 1087 detector 2; trying to automatize below

if (n_elements(star_center_calib) eq 0) THEN BEGIN 
ZE_SELECT_STAR_CENTER,astrometry_ref_image2,star=star
star_center_calib=star
ENDIF

offset_center=255.5-(star_center_calib+cumoffsety_ref)
print,offset_center
star=sizespat/2.-offset_center
print,'star2',star
sub=-0.5
row=sizespat/2.
;row=30 ;DEFAULT
row=120
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
;lambda_lamp=yfit[0]+yfit[1]*index+yfit[2]*index*index
;swmpa2[*,row]=lambda_lamp/10.
;uncomment the line below if you want to do wavelength calibration of the teluric star; needed for Jan 2009 data 1090 
;ZE_WAVECAL_1D_SPEC_V6,index,swmpa2,dataa2,f2canorm,row,grat_angle,det,minrow,numberrows,lkpno,fkpno,read_kpno=1,build_tel_list=1, create_ident_plot=1,build_templ=0,$
;                      build_calonly_templ=1,calib_sci=0,calib_cal=1
;restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdet+'_line_auto_tel.sav'         
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
;uncommenting following line as a test
IF grat_angle eq 1090 THEN GOTO,USE_OLD_CAL_TEL


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
restore,'/Users/jgroh/espectros/etc_poly_wavecal_'+gratdetold+'_line_auto_lamp_2d.sav'
;lambdatel=yfit[0]+yfit[1]*index+yfit[2]*index*index
lambdatel=lambda_newcalt



;for i=0, n_elements(dataa2)[2]
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

;;calculate the best velocity shift between telluric and science calibrations, WHEN different lamps were used. WORKING FINE
;velshift_min=-1.3
;velshift_max=-0.3
;velshift_step=0.1
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
;scl_min=1.9
;scl_max=2.9
;scl_step=0.1
;scl_size=(scl_max-scl_min)/scl_step +1.
;scl_vector=fltarr(scl_size)
;scl_optimum=dblarr(sizespat)
;
;fwhm_min=0.
;fwhm_max=1.
;fwhm_step=0.1
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
; ; dataa2[*,j]=dataa2[*,j]/fluxteli_2d[*,j] ;/norm
;  Print, 'Finished spat ',j
;ENDFOR
lambdatel=dblarr(sizelam)
lambdatel[*]=lambda_newcal_vac[*,row]
;fluxtel=ZE_SHIFT_SPECTRA_VEL(lambdatel,fluxtel,-1.)
CASE det of
1: scl_val=1.0
2: scl_val=1.0
3: scl_val=0.7
4: scl_val=1.0
ENDCASE
for i=0, sizespat-1 DO  dataa2[*,i]=dataa2[*,i]/(((fluxtel-1.)*scl_val)+1.)

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

;finds continuum normalization value; DO NOT normalize it here!
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
a=0
b=2
ZE_ETACAR_CRIRES_CREATE_GENERIC_IMAGE_FROM_DATAA2,dataa2contdiv,a,b,imgcontdiv,SQRT=1,LOG=0
ZE_ETACAR_CRIRES_PLOT_GENERIC_IMAGE_XWINDOW,imgcontdiv,a,b,lambda_newcal_vac_hel,cmi,cma,star,sub,row,aa,bb,pos,cumoffsetx,signcumoffsetx,lambda0
imgname='etc_crires'+gratdet_orig+'_contdiv'
ZE_ETACAR_CRIRES_PLOT_GENERIC_IMAGE_EPS,imgcontdiv,a,b,imgname,lambda_newcal_vac_hel,cmi,cma,star,sub,row,aa,bb,pos,cumoffsetx,signcumoffsetx,lambda0
;
a=1.
b=50.
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

;save,/variables,FILENAME='/Users/jgroh/espectros/etc_'+gratdet+'_allvar.sav'
;ZE_CRIRES_PLOT_SPATPROFILE,indexspat,dataa2,100,200,400,prof1,prof2,prof3
center_ext=49
apradius=1
ZE_EXTRACT_CRIRES_SPEC_V1,dataa2,sizelam,row,center_ext,apradius,spec_ext=spec_ext
save,lambda_newcal_vac_hel,spec_ext,FILENAME='/Users/jgroh/espectros/etacar/etacar_'+gratdet+'fos4.sav'
undefine,gratdet1,gratdet2,gratdet_orig,gratdet,gratdet_onstar
END