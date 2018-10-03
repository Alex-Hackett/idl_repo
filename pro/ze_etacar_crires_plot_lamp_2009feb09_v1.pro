;PRO ZE_ETACAR_CRIRES_PLOT_LAMP_2009FEB09_V1,scoma,swmpa,cal2070

grat_angle=1090
det=3
xnodes=0
ynodes=0

gratdet='2009feb09_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))


saved_file='/Users/jgroh/espectros/etc_lamp_'+gratdet+'_allvar.sav'
if (FILE_EXIST(saved_file) eq 0) then begin
  print,'Saved file not found. No saved file was restored.'
endif else begin
restore,saved_file
endelse

dirgencalib='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043B_2009Feb09/GEN_CALIB/' ;for all grats and dets
bpm_file=dirgencalib+'proc/FLAT/CR_PBPM_090208A_3218.6nm.fits'

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
    END
    
 2076: BEGIN
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182823/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182830/cal_proc/'
scoma=dirsci+'CR_SCOM_200182823_2009-01-08T08_17_22.077_DIT1_2076.6nm.fits'
swmpa=dirsci+'CR_SWMA_200182823_2009-01-08T08_17_22.077_DIT1_2076.6nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2076.6nm.fits'
    END

 1087: BEGIN
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043B_2009Feb09/352647/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182815/cal_proc/' ;no cal obs were done!
scoma=dirgencalib+'raw/ARC/CRIRE.2009-02-09T06_26_04.186.fits'
swmpa=dirsci+'CR_SWMA_352647_2009-02-09T06_12_38.858_DIT1_1087.3nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_1087.3nm.fits'
lampfile='/Users/jgroh/espectros/thar_kerber_cut_vac.txt'
flatfile=dirgencalib+'/proc/FLAT/CR_PFLT_090208A_1087.3nm.fits'
row=200
    END
    
 1090: BEGIN
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043B_2009Feb09/352647/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182815/cal_proc/' ;no cal obs were done!
scoma=dirgencalib+'raw/ARC/CRIRE.2009-02-09T06_56_52.375.fits'
swmpa=dirsci+'CR_SWMA_352647_2009-02-09T06_32_42.488_DIT1_1090.4nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_1087.3nm.fits'
lampfile='/Users/jgroh/espectros/thar_kerber_cut_vac.txt'
flatfile=dirgencalib+'/proc/FLAT/CR_PFLT_090208B_1090.4nm.fits'
row=200
    END

 2150: BEGIN
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182813/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182811/cal_proc/'
scoma=dirgencalib+'raw/ARC/CRIRE.2009-01-08T05_27_46.918.fits'
swmpa=dirsci+'CR_SWMA_200182813_2009-01-08T05_39_02.428_DIT1_2150.0nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2150.0nm.fits'
lampfile='/Users/jgroh/espectros/thar_kerber_cut_vac.txt'
row=14
flatfile=dirgencalib+'/proc/FLAT/CR_PFLT_090107A_2150.0nm.fits'
    END
   
 2156: BEGIN
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182813/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182811/cal_proc/'
scoma=dirgencalib+'raw/ARC/CRIRE.2009-01-08T05_51_03.337.fits'
swmpa=dirsci+'CR_SWMA_200182813_2009-01-08T05_43_31.459_DIT1_2156.5nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2156.5nm.fits'
lampfile='/Users/jgroh/espectros/thar_kerber_cut_vac.txt'
row=14
flatfile=dirgencalib+'/proc/FLAT/CR_PFLT_090107A_2156.5nm.fits'
    END

ENDCASE


;ftab_help,scoma
;read extracted telluric spectrum 
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
    END
    
 2: BEGIN
    dataa2=dataa2
    swmpa2=swmpa2
    f2ca=f2ca
    w2ca=w2ca 
    ZE_ETACAR_CRIRES_READ_DETECTOR, bpm_file, 2, bpma2, headerbpma2
    ZE_ETACAR_CRIRES_READ_DETECTOR, flatfile, 2, flata2, headerflata2
    END
    
 3: BEGIN
    dataa2=dataa3
    swmpa2=swmpa3
    f2ca=f3ca
    w2ca=w3ca 
    ZE_ETACAR_CRIRES_READ_DETECTOR, bpm_file, 3, bpma2, headerbpma2
    ZE_ETACAR_CRIRES_READ_DETECTOR, flatfile, 3, flata2, headerflata2
    END
    
 4: BEGIN
    dataa2=dataa4
    swmpa2=swmpa4
    f2ca=f4ca
    w2ca=w4ca 
    ZE_ETACAR_CRIRES_READ_DETECTOR, bpm_file, 4, bpma2, headerbpma2
    ZE_ETACAR_CRIRES_READ_DETECTOR, flatfile, 4, flata2, headerflata2
    END

ENDCASE

;removing bad pixels
dataa2(WHERE(bpma2 eq 1))=0

;dividing by flat field
dataa2=dataa2/flata2

sizespat=(size(dataa2))[2]

star=sizespat/2.

sub=-0.5
crop=row
cmi=star-crop
cma=star+crop
swmpa2=swmpa2[*,cmi:cma]
dataa2=dataa2[*,cmi:cma]
dataa2=shift_sub(dataa2,0,sub)

lambda0=2.05869
;lambda0=2.16612
;lambda0=1.08333


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

index=1.*indgen(sizelam)
polycal_master=dblarr(sizespat,3)
lambda_newcal_vac=dblarr(sizelam,sizespat)


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
plot, swmpa2[*,row]*10., [(cmi-cmi),(cma-cmi)], XTICKFORMAT='(I6)',xstyle=1,ystyle=1, xtitle='Wavelength (Angstrom)', ytitle='offset (arcsec)',$
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

;extracting lamp spectrum at positions picked interactively by the user
!MOUSE.BUTTON = 1
pos_filename='/Users/jgroh/espectros/etc_'+gratdet+'_pos_ext_lamp.txt'

    wset,19
    wshow,19
    
    OPENW,3,pos_filename
       next=0
        WHILE !MOUSE.BUTTON NE 4 DO BEGIN 
          CURSOR, xa, ya, /DATA, /DOWN
          PLOTS, xa, ya, PSYM=1, SYMSIZE=1.5, COLOR=FSC_COLOR("BLUE", !D.TABLE_SIZE-0)
          next=next+ 1
          PRINTF,3,xa,ya
        ENDWHILE
         IF !MOUSE.BUTTON EQ 4 THEN GOTO,ENDLINE

ENDLINE:  
CLOSE,3
next=next-1
ZE_READ_SPECTRA_COL_VEC,pos_filename,lambda_pos,ypos_vec
;removing the last point which is due to the right mouse click
lambda_pos=lambda_pos[0:next-1]
ypos_vec=ypos_vec[0:next-1]

apradius=3
center_ext=ypos_vec[2]-row   ; offset relative to the central row
ZE_EXTRACT_CRIRES_SPEC_V1,dataa2,sizelam,row,center_ext,apradius,spec_ext=spec_ext


CASE grat_angle of

 1087: BEGIN
        spec_ext=spec_ext+1
        ZE_ETACAR_CRIRES_WAVECAL_LAMP_V1,gratdet,lampfile,index,spec_ext,center_ext+row,swmpa2,tharlinescut
       END
       
 1090: BEGIN
        spec_ext=spec_ext+1
        ZE_ETACAR_CRIRES_WAVECAL_LAMP_V1,gratdet,lampfile,index,spec_ext,center_ext+row,swmpa2,tharlinescut
       END    
          
 2150: BEGIN
         ;normalizing N2O spectrum interactively using FUSE routine LINE_NORM
         LOADCT,0
         !P.Background = fsc_color('white')
         !P.Color = fsc_color('black')
         line_norm,index,dataa2[*,row],n2o_obs_norm,norm_obsn2o,xnodes_obsn2o,ynodes_obsn2o
         minrow=0
         numberrows=29
         ZE_ETACAR_CRIRES_WAVECAL_N2O_V1,index,swmpa2,dataa2,n2o_obs_norm,row,grat_angle,det,minrow,numberrows,wn2o,fn2o
        END
      
 2156: BEGIN
         ;normalizing N2O spectrum interactively using FUSE routine LINE_NORM
         LOADCT,0
         !P.Background = fsc_color('white')
         !P.Color = fsc_color('black')
         line_norm,index,dataa2[*,row],n2o_obs_norm,norm_obsn2o,xnodes_obsn2o,ynodes_obsn2o
         minrow=0
         numberrows=29
         ZE_ETACAR_CRIRES_WAVECAL_N2O_V1,index,swmpa2,dataa2,n2o_obs_norm,row,grat_angle,det,minrow,numberrows,wn2o,fn2o
        END
ENDCASE



window
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
plot,swmpa2[*,row]*10.,spec_ext,xstyle=1,/ylog,yrange=[1,max(spec_ext)]
for i=0, n_elements(tharlinescut)-1 DO XYOUTS,tharlinescut[i],6100,'|'

;capturing TRUE COLOR image of the 2D spectrum to pic2
window,retain=2,xsize=aa,ysize=bb
LOADCT,13 
tvimage,imginv,POSITION=[0,0,0.95,0.95]
pic2=tvrd(0,0,0.95*aa,0.95*bb,/true)
wdelete,!d.window

;plotting to PS file

ps_ysize=10.
ps_xsize=ps_ysize*aa/bb
ps_filename='/Users/jgroh/temp/etc_crires_lamp'+gratdet+'.eps'
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
;
save,/variables,FILENAME='/Users/jgroh/espectros/etc_lamp_'+gratdet+'_allvar.sav'
END
