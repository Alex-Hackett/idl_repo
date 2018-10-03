;PRO ZE_CREATE_FIGURES_FORBIDDEN_LINE_PAPER1_TOM_MADURA_NII

;constants

lambda0=5756.19
line='[NII]'
line_filename='NII'

;routine to work with STIS data
dir='/Users/jgroh/data/hst/stis/umn/for_forbidden_line_paper1_tom/n2/'

noffset=17


listfile=dir+'list'

list=strarr(noffset)
k=0
openr,1,listfile
strtemp=''
for k=0, noffset -1 DO BEGIN
readf,1,strtemp
print,strtemp,k
list[k]=strtemp
ENDFOR
close,1

FOR k=0, noffset-1  DO BEGIN
file=list[k] ;for 2002 july 04, phi=0.820, MJD=52459.61, PA=68.65


dataa0=mrdfits(dir+file+'.fits',0,headera0)
flux=mrdfits(dir+file+'.fits',1,headera1)
dq=mrdfits(dir+file+'.fits',2,headera2)
err=mrdfits(dir+file+'.fits',3,headera3)

crval1=fxpar(headera1,'CRVAL1')
crpix1=fxpar(headera1,'CRPIX1')
crpix2=fxpar(headera1,'CRPIX2') ;position of central star
cd1=fxpar(headera1,'CD1_1')
platesc2=fxpar(headera0,'PLATESC')
platesc=fxpar(headera1,'CD2_2')*3600.D
datamin=fxpar(headera1,'DATAMIN')
datamax=fxpar(headera1,'DATAMAX')
sizaxis1=fxpar(headera0,'SIZAXIS1') ;spectral direction
sizaxis2=fxpar(headera0,'SIZAXIS2') ;spatial direction
pa=fxpar(headera1,'PA_APER') ;spatial direction
pa_str=strcompress(string(pa, format='(I04)'))


offset_arc=dblarr(SIZAXIS2)
FOR i=0., sizaxis2-1 DO offset_arc[i]=-(sizaxis2/2.)*platesc + (platesc*(i+1))
star_off=sizaxis2/2.-crpix2

lambda=dblarr(SIZAXIS1)
FOR i=0., sizaxis1-1 DO lambda[i]=(crval1-cd1*CRPIX1)+(cd1*i)
vel=ZE_LAMBDA_TO_VEL(lambda,lambda0)

;re-scaling and subtracting continuum in the inner 2 arcsec
ymin=-1.05       ; in arcsec
ymax=1.05   ; in arcsec
;ymin=-0.9
;ymax=0.9


near3=Min(Abs(offset_arc - ymin), index3)
near4=Min(Abs(offset_arc - ymax), index4)
sizaxis2new=index4-index3
fluxsc1=flux[*,index3:index4] ;cropped vector in spatial direction

;continuum point
colu=1279 ;for cD37_0370
;colu=1069 ;for cd37_0290p 

;normalize each row by the continuum? crudely done
for i=0, sizaxis2new - 1 do begin
fluxsc1[*,i]=fluxsc1[*,i]-fluxsc1[colu,i]
endfor

;divide by a scaled spectrum from the central star? previous option has to be turned off
;fluxsc1(where(fluxsc1 eq 0))=fluxsc1[colu,sizaxis2new/2]   ;setting the edge of the detector to continuum, otherwise we have 0 and the division does not work
;centralstar_norm=fluxsc1[*,sizaxis2new/2]/fluxsc1[colu,sizaxis2new/2]
;for i=0, sizaxis2new - 1 do begin
;fluxsc1[*,i]=fluxsc1[*,i]/(fluxsc1[colu,i]*centralstar_norm)
;endfor

;select range for plotting in image
xmin=-600.    ;in km/s
xmax=600      ;in km/s
near = Min(Abs(vel - xmin), index1)
near2= Min(Abs(vel - xmax), index2)
 
fluxcr=fluxsc1[index1:index2,*] ;cropped vector in spectral and spatial direction 
sizaxis1new=index2-index1
vel_cut=vel[index1:index2]

;mask low velocity emission DON't USE IT HERE -- DOING LATER IN KEYNOTE
;xmin=-100.    ;in km/s
;xmax=20      ;in km/s
;near = Min(Abs(vel_cut - xmin), index5)
;near2= Min(Abs(vel_cut - xmax), index6)
;fluxcr[index5:index6,*]=0.0



;colorbar_min=0.
;colorbar_max=max(fluxcr, /NAN)

;for normalized colorbars starting at 1
;colorbar_min=0.01
;colorbar_min=min(fluxcr, /NAN)
;for normalized colorbars starting at 0
colorbar_min=(.00e-14)
colorbar_max=(max(fluxcr, /NAN))
colorbar_min=(0.20e-14)
colorbar_max=(max(fluxcr, /NAN))/4.0
;colorbar_max=0.5e-13
;using sqrt of F?
;fluxcr=sqrt(fluxcr)
;colorbar_min=min(fluxcr,/NAN)
;colorbar_min=sqrt(datamin)
;colorbar_min=0.
;colorbar_max=max(fluxcr,/NAN)
midticks=3


;or log flux?
;fluxcr=alog10(fluxcr)


;plotting image in window
xwindowsize=900.*1  ;window size in x
ywindowsize=760.*1  ; window size in y

;the issue was how to obtain a true color image to subsequently write to the PS file. Here we plot the image to the screen and use tvrd(/true)
window,2,retain=2,xsize=xwindowsize,ysize=ywindowsize
LOADCT,3
img=bytscl(sqrt(fluxcr),MIN=sqrt(colorbar_min),MAX=sqrt(colorbar_max)); 
tvimage,img,POSITION=[0,0,0.95,0.95],/nointerpolation
pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize,/true)
wdelete,!d.window

;plotting to the screen
window,19,xsize=xwindownsize,ysize=ywindowsize,retain=0,XPOS=30,YPOS=60
ZE_PRINT_STIS_2DSPEC_NORM_VEL,pic2,fluxcr,lambda,vel,offset_arc,star_off,platesc,lambda0,pa,file,line,index1,index2,index3,index4,sqrt(colorbar_min),sqrt(colorbar_max),midticks

;plot to PS file
set_plot,'ps'
xsize=900.*1  ;window size in x
ysize=760.*1  ; window size in y
PositionPlot=[0.25, 0.28, 0.91, 0.94]

device,filename='/Users/jgroh/temp/etacar_stis_'+line_filename+'_forbidden_line_paper1_tom_madura_'+list[k]+'_'+pa_str+'.eps',/encapsulated,/color,bit=8,xsize=10*xsize/ysize,ysize=10,/inches
!P.THICK=12
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.2
!Y.CHARSIZE=1.2
!P.CHARSIZE=2
!P.CHARTHICK=12

   ZE_PRINT_STIS_2DSPEC_NORM_VEL,pic2,fluxcr,lambda,vel,offset_arc,star_off,platesc,lambda0,pa,file,line,index1,index2,index3,index4,sqrt(colorbar_min),sqrt(colorbar_max),midticks
device,/close_file
set_plot,'x'
ENDFOR

;
;;plotting original spectrum for comparison
;LOADCT,0
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;;sptial cuts in arcsec
;cut1=0/0.025
;cut2=0.25/0.025
;cut3=-0.25/0.025
;window,10
;x1=xmin
;x2=xmax
;y1=0
;y2=1.3
;plot,vel,flux[*,sizaxis2/2+cut1]/flux[colu,sizaxis2/2+cut1],xrange=[x1,x2],yrange=[y1,y2],/NODATA,xtitle='velocity (km/s)', ytitle='Normalized flux'
;plots,vel,flux[*,sizaxis2/2+cut1]/flux[colu,sizaxis2/2+cut1],noclip=0,color=fsc_color('black')
;plots,vel,flux[*,sizaxis2/2+cut2]/flux[colu,sizaxis2/2+cut2],noclip=0,color=fsc_color('red')
;plots,vel,flux[*,sizaxis2/2+cut3]/flux[colu,sizaxis2/2+cut3],noclip=0,color=fsc_color('blue')
;
;window,11
;x3=xmin
;x4=xmax
;y3=0
;y4=colorbar_max
;plot,vel[index1:index2],fluxcr[*,sizaxis2new/2+cut1],xrange=[x3,x4],yrange=[y3,y4],/NODATA,xtitle='velocity (km/s)', ytitle='Residual Normalized flux'
;plots,vel[index1:index2],fluxcr[*,sizaxis2new/2+cut1],noclip=0,color=fsc_color('black')
;plots,vel[index1:index2],fluxcr[*,sizaxis2new/2+cut2],noclip=0,color=fsc_color('red')
;plots,vel[index1:index2],fluxcr[*,sizaxis2new/2+cut3],noclip=0,color=fsc_color('blue')
;
;
;
;set_plot,'ps'
;xsize=800.*1  ;window size in x
;ysize=860.*1  ; window size in y
;PositionPlot=[0.25, 0.28, 0.91, 0.94]
;
;device,filename='/Users/jgroh/temp/etacar_stis_2.eps',/encapsulated,/color,bit=8,xsize=10*xsize/ysize,ysize=10,/inches
;plot,vel[index1:index2],fluxcr[*,sizaxis2new/2+cut1],xrange=[x3,x4],yrange=[y3,y4],/NODATA,xtitle='velocity (km/s)', ytitle='Residual Normalized flux'
;plots,vel[index1:index2],fluxcr[*,sizaxis2new/2+cut1],noclip=0,color=fsc_color('black')
;plots,vel[index1:index2],fluxcr[*,sizaxis2new/2+cut2],noclip=0,color=fsc_color('red')
;plots,vel[index1:index2],fluxcr[*,sizaxis2new/2+cut3],noclip=0,color=fsc_color('blue')
;device,/close_file
;set_plot,'x'

;plotting original spectrum for comparison
LOADCT,0
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