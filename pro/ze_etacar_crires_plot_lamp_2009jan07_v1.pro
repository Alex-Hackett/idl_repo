;PRO ZE_ETACAR_CRIRES_PLOT_LAMP_2009JAN07_V1,scoma,swmpa,cal2070

grat_angle=1087
det=1
xnodes=0
ynodes=0

gratdet=strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))

;restore,'/Users/jgroh/espectros/etc_lamp_'+gratdet+'_allvar.sav'

dirgencalib='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/GEN_CALIB/' ;for all grats and dets
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
    END
    
 2076: BEGIN
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182823/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182830/cal_proc/'
scoma=dirsci+'CR_SCOM_200182823_2009-01-08T08_17_22.077_DIT1_2076.6nm.fits'
swmpa=dirsci+'CR_SWMA_200182823_2009-01-08T08_17_22.077_DIT1_2076.6nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2076.6nm.fits'
    END
    
 1087: BEGIN
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182818/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182815/cal_proc/'
scoma=dirgencalib+'raw/ARC/CRIRE.2009-01-08T06_31_19.699.fits'
swmpa=dirsci+'CR_SWMA_200182818_2009-01-08T06_42_37.035_DIT1_1087.3nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_1087.3nm.fits'
    END
    
 1090: BEGIN
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182818/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182815/cal_proc/'
scoma=dirgencalib+'raw/ARC/CRIRE.2009-01-08T07_46_01.294.fits'
swmpa=dirsci+'CR_SWMA_200182818_2009-01-08T07_20_38.529_DIT1_1090.4nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_1087.3nm.fits'
    END

 2150: BEGIN
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182813/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182811/cal_proc/'
scoma=dirgencalib+'raw/ARC/CRIRE.2009-01-08T05_27_46.918.fits'
swmpa=dirsci+'CR_SWMA_200182813_2009-01-08T05_39_02.428_DIT1_2150.0nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2150.0nm.fits'
    END
   
 2156: BEGIN
dirsci='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182813/sci_proc/'
dircal='/Users/jgroh/data/eso_vlt/crires/Etacar/282D-5043A_2009Jan07/200182830/cal_proc/'
scoma=dirgencalib+'raw/ARC/CRIRE.2009-01-08T05_51_03.337.fits'
swmpa=dirsci+'CR_SCOM_200182813_2009-01-08T05_43_31.459_DIT1_2156.5nm.fits' ;SWMA files look better
cal2070=dircal+'CR_PEXT_090107A_DIT30_2156.5nm.fits'
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
 ;   ZE_ETACAR_CRIRES_READ_DETECTOR, bpm_file, 1, bpma2, headerbpma2 
    END
    
 2: BEGIN
    dataa2=dataa2
    swmpa2=swmpa2
    f2ca=f2ca
    w2ca=w2ca 
    ZE_ETACAR_CRIRES_READ_DETECTOR, bpm_file, 2, bpma2, headerbpma2
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

;removing bad pixels
dataa2(WHERE(bpma2 eq 1))=0

sizespat=(size(dataa2))[2]

star=sizespat/2.

sub=-0.5
row=200
crop=row
cmi=star-crop
cma=star+crop
swmpa2=swmpa2[*,cmi:cma]
dataa2=dataa2[*,cmi:cma]
dataa2=shift_sub(dataa2,0,sub)


heliovel=19.9 ;for 2009 jan 07 from ESO website; has to be added to the measured velocities
ra_obs=[10,45,03.00]
dec_obs=[-59,45,41.0]
date_obs=[2009,1,7,08]
ZE_COMPUTE_HELIOCENTRIC_VEL,date_obs,ra_obs,dec_obs,vhelio=vhelio
print,'Heliocentric velocity: ',vhelio

lambda0=2.05869
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
lampfile='/Users/jgroh/espectros/thar_kerber_cut_vac.txt'
center_ext=ypos_vec[2]-row   ; offset relative to the central row
ZE_EXTRACT_CRIRES_SPEC_V1,dataa2,sizelam,row,center_ext,apradius,spec_ext=spec_ext
spec_ext=spec_ext+1
ZE_ETACAR_CRIRES_WAVECAL_LAMP_V1,grat_angle,det,lampfile,index,spec_ext,center_ext+row,swmpa2,tharlinescut

window
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
plot,swmpa2[*,row]*10.,spec_ext,xstyle=1,/ylog,yrange=[1,max(spec_ext)]
for i=0, n_elements(tharlinescut)-1 DO XYOUTS,tharlinescut[i],6100,'|'

;;sum flux from lmin to lmax lines centered at center
;center=ypos_vec[0]-row
;apradius=15
;flux_sum=0.
;for i=0, 2*apradius do begin
;flux_sum=dataa2[*,row+center-apradius+i]+flux_sum
;print,row+center-apradius+i
;endfor 
;print,'Spectral aperture extraction of '+number_formatter(((apradius*2)+1)*0.086,decimals=2)+'x 0.20 arcsec'


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
;save,/variables,FILENAME='/Users/jgroh/espectros/etc_lamp_'+gratdet+'_allvar.sav'
END
