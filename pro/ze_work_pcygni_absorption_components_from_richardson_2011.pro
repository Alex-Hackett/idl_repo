;PRO ZE_WORK_PCYGNI_ABSORPTION_COMPONENTS_FROM_RICHARDSON_2011
!P.Background = fsc_color('white')
noffset=165
dir='/Users/jgroh/espectros/pcygni_richardson_2011/'

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


sizelam=1125
flux_all_offsets=dblarr(sizelam,noffset)
lambda_all_offsets=dblarr(sizelam,noffset)

FOR j=0, noffset-1  DO BEGIN
ZE_READ_SPECTRA_FITS,dir+list[j],lambdat,fluxt,htnt
flux_all_offsets[*,j]=fluxt
lambda_all_offsets[*,j]=lambdat
ENDFOR

lambda0=6562.8
lambda=REFORM(lambda_all_offsets[*,50]) ;arbitrary
vel=ZE_LAMBDA_TO_VEL(lambda,lambda0)


;divide by a scaled spectrum from the central star? previous option has to be turned off
;fluxsc1(where(fluxsc1 eq 0))=fluxsc1[colu,sizaxis2new/2]   ;setting the edge of the detector to continuum, otherwise we have 0 and the division does not work
;centralstar_norm=fluxsc1[*,sizaxis2new/2]/fluxsc1[colu,sizaxis2new/2]
;for i=0, sizaxis2new - 1 do begin
;fluxsc1[*,i]=fluxsc1[*,i]/(fluxsc1[colu,i]*centralstar_norm)
;endfor

;select range for plotting in image
xmin=-500.    ;in km/s
xmax=0      ;in km/s
near = Min(Abs(vel - xmin), index1)
near2= Min(Abs(vel - xmax), index2)
 
fluxcr=flux_all_offsets[index1:index2,*] ;cropped vector in spectral and spatial direction 
sizaxis1new=index2-index1
vel_cut=vel[index1:index2]

;mask low velocity emission
;xmin=-100.    ;in km/s
;xmax=20      ;in km/s
;near = Min(Abs(vel_cut - xmin), index5)
;near2= Min(Abs(vel_cut - xmax), index6)
; 
;fluxcr[index5:index6,*]=0.0



;colorbar_min=0.
;colorbar_max=max(fluxcr, /NAN)

;for normalized colorbars starting at 1
colorbar_min=0.001
;colorbar_min=min(fluxcr, /NAN)
;for normalized colorbars starting at 0
;colorbar_min=(0.3e-14)
colorbar_max=(max(fluxcr, /NAN))
colorbar_max=2
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
LOADCT,13
img=bytscl((fluxcr),MIN=colorbar_min,MAX=colorbar_max); 
tvimage,img,POSITION=[0,0,0.95,0.95],/nointerpolation
pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize,/true)
;wdelete,!d.window

;plotting to the screen
window,19,xsize=xwindownsize,ysize=ywindowsize,retain=0,XPOS=30,YPOS=60
;ZE_PRINT_STIS_2DSPEC_NORM_VEL,pic2,fluxcr,lambda,vel,offset_arc,star_off,platesc,lambda0,pa,file,line,index1,index2,index3,index4,colorbar_min,colorbar_max,midticks


END