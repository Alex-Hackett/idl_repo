;PRO ZE_ETACAR_STIS_PLOT_ALL_OFFSETS_WITH_TED
;routine to create the interpolated mapping for the STIS data from Ted
;2010sep24

noffset=21
dir='/Users/jgroh/data/hst/stis/etacar_from_ted/Post_SM4/Dec_2009/results/'

listfile=dir+'list'

list=strarr(75)
k=0
openr,1,listfile
strtemp=''
for k=0, 74 DO BEGIN
readf,1,strtemp
list[k]=strtemp
ENDFOR
close,1

noffset=15
sizelam=1024
sizespat=301

dataa2_all_offsets=dblarr(sizelam,sizespat,noffset)
offset_vector=dblarr(noffset)

FOR j=0, noffset-1  DO BEGIN

file=list[j]

dataa0=mrdfits(dir+file,0,headera0,/silent)
flux=mrdfits(dir+file,1,headera1,/silent)
dq=mrdfits(dir+file,2,headera2,/silent)
err=mrdfits(dir+file,3,headera3,/silent)

crval1=fxpar(headera1,'CRVAL1')
crpix1=fxpar(headera1,'CRPIX1')
crpix2=fxpar(headera1,'CRPIX2') ;position of central star
cd1=fxpar(headera1,'CD1_1')
;platesc=fxpar(headera0,'PLATESC')
platesc=fxpar(headera0,'PLATESC')
datamin=fxpar(headera1,'DATAMIN')
datamax=fxpar(headera1,'DATAMAX')
sizaxis1=fxpar(headera0,'SIZAXIS1') ;spectral direction
sizaxis2=fxpar(headera0,'SIZAXIS2') ;spatial direction
pa=fxpar(headera1,'PA_APER') ;spatial direction
postarg1=fxpar(headera0,'POSTARG1') ;spatial directionPOSTARG1'

offset_arc=dblarr(SIZAXIS2)
FOR i=0., sizaxis2-1 DO offset_arc[i]=-(sizaxis2/2.)*platesc + (platesc*(i+1))
star_off=sizaxis2/2.-crpix2

lambda=dblarr(SIZAXIS1)
lambda0=4702.85
line='[FeIII]'
;lambda0=4815.88
;line='[FeII]'
;lambda0=4714.47
;line='He I'
FOR i=0., sizaxis1-1 DO lambda[i]=(crval1-cd1*CRPIX1)+(cd1*i)
vel=ZE_LAMBDA_TO_VEL(lambda,lambda0)

dataa2_all_offsets[*,*,j]=flux
offset_vector[j]=postarg1
print,file,crval1,j

ENDFOR

dataa2_all_offsets_contsub_crop=dataa2_all_offsets

;re-scaling and subtracting continuum in the inner 2 arcsec
ymin=-3.0       ; in arcsec
ymax=3.0 ; in arcsec
;ymin=-0.9
;ymax=0.9

flux=REFORM(dataa2_all_offsets[*,*,8])

near3=Min(Abs(offset_arc - ymin), index3)
near4=Min(Abs(offset_arc - ymax), index4)
sizaxis2new=index4-index3
fluxsc1=flux[*,index3:index4] ;cropped vector in spatial direction

colu=400 ;for cD37_0370
colu_up=470.
;normalize each row by the continuum? crudely done
for i=0, sizaxis2new - 1 do begin
fluxsc1[*,i]=fluxsc1[*,i]-fluxsc1[colu,i]
endfor

;select range for plotting in image
xmin=-600.    ;in km/s
xmax=600      ;in km/s
near = Min(Abs(vel - xmin), index1)
near2= Min(Abs(vel - xmax), index2)
 
fluxcr=fluxsc1[index1:index2,*] ;cropped vector in spectral and spatial direction 
sizaxis1new=index2-index1

dataa2_all_offsets_contsub_crop=dblarr(index2-index1+1,index4-index3+1,noffset)
FOR j=0, noffset-1  DO BEGIN
;re-scaling and subtracting continuum in the inner 2 arcsec
ymin=-3.0       ; in arcsec
ymax=3.0 ; in arcsec
;ymin=-0.9
;ymax=0.9

flux=REFORM(dataa2_all_offsets[*,*,j])

near3=Min(Abs(offset_arc - ymin), index3)
near4=Min(Abs(offset_arc - ymax), index4)
sizaxis2new=index4-index3
fluxsc1=flux[*,index3:index4] ;cropped vector in spatial direction

colu=400 ;for cD37_0370
colu_up=470.
;normalize each row by the continuum? crudely done
for i=0, sizaxis2new - 1 do begin
fluxsc1[*,i]=fluxsc1[*,i]-fluxsc1[colu,i]
endfor

;select range for plotting in image
xmin=-600.    ;in km/s
xmax=600      ;in km/s
near = Min(Abs(vel - xmin), index1)
near2= Min(Abs(vel - xmax), index2)
 
fluxcr=fluxsc1[index1:index2,*] ;cropped vector in spectral and spatial direction 
sizaxis1new=index2-index1
dataa2_all_offsets_contsub_crop[*,*,j]=fluxcr
ENDFOR

;colorbar_min=0.
;colorbar_max=max(fluxcr, /NAN)


;for normalized colorbars starting at 1
;colorbar_min=1.
colorbar_min=min(fluxcr, /NAN)
;colorbar_min=1.
;for normalized colorbars starting at 0
colorbar_min=0.
colorbar_max=max(fluxcr, /NAN)
;colorbar_max=8.
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
xwindowsize=700.*1  ;window size in x
ywindowsize=600.*1  ; window size in y

;the issue was how to obtain a true color image to subsequently write to the PS file. Here we plot the image to the screen and use tvrd(/true)
window,2,retain=2,xsize=xwindowsize,ysize=ywindowsize
LOADCT,13
img=bytscl(fluxcr,MIN=colorbar_min,MAX=colorbar_max); 
tvimage,img,POSITION=[0,0,0.95,0.95]
pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize,/true)
wdelete,!d.window

;plotting to the screen
window,19,xsize=xwindownsize,ysize=ywindowsize,retain=0,XPOS=30,YPOS=60
ZE_PRINT_STIS_2DSPEC_NORM_VEL,pic2,fluxcr,lambda,vel,offset_arc,star_off,platesc,lambda0,pa,file,line,index1,index2,index3,index4,colorbar_min,colorbar_max,midticks

;plot to PS file
keywords = PSConfig(_Extra=PSWindow())
keywords.ysize=10.
keywords.bits_per_pixel=8.
keywords.xsize=keywords.ysize*xwindowsize/ywindowsize
keywords.ENCAPSULATED=1
keywords.filename='/Users/jgroh/temp/etc_stis_feii4815_stardiv.eps'

set_plot,'ps'
   DEVICE, _EXTRA=keywords
   ZE_PRINT_STIS_2DSPEC_NORM_VEL,pic2,fluxcr,lambda,vel,offset_arc,star_off,platesc,lambda0,pa,file,line,index1,index2,index3,index4,colorbar_min,colorbar_max,midticks
device,/close_file
set_plot,'x'


;lineplot,fluxsc1[*,sizaxis2new/2]
;i=28.
;file_output='/Users/jgroh/temp/etc_stis_'+strcompress(string(i, format='(I08)'), /remove)
;image = TVREAD(FILENAME = file_output, /TIFF, /NODIALOG)

;;generate psf subtracted image
a=0
b=7.0e-14
row=50
sub=0.0
crop=row
star=151
cmi=star-crop
cma=star+crop
lambda0_micron=lambda0*1e-4
lambda_new=lambda[index1:index2]
FOR index_lambda=0, 60 , 10 DO BEGIN
;i=index_lambda
;index_lambda=29
lambda_val=lambda_new[index_lambda]
aa=1300
bb=900
;ZE_ETACAR_CRIRES_CREATE_GENERIC_IMAGE_FROM_DATAA2,REFORM(dataa2_all_offsets_contsub_crop[index_lambda,*,*]),a,b,imgpsfsub,SQRT=1,LOG=0

dataa2_all_offsets_contsub_crop(WHERE(dataa2_all_offsets_contsub_crop) le 0)=0
imgpsfsub=bytscl(REFORM(dataa2_all_offsets_contsub_crop[index_lambda,*,*]),MIN=a,MAX=b)
print,'TESTE',a,b
ZE_ETACAR_CRIRES_PLOT_MONOCHROMATIC_IMAGE_OFFSET_XWINDOW,imgpsfsub,a,b,cmi,cma,star,sub,row,offset_vector,aa,bb,lambda_val,lambda0_micron
imgname='etc_stis'
ZE_ETACAR_CRIRES_PLOT_MONOCHROMATIC_IMAGE_OFFSET_EPS,imgpsfsub,a,b,imgname,cmi,cma,star,sub,row,offset_vector,aa,bb,lambda_val,lambda0_micron
;wset,19
;file_output='/Users/jgroh/temp/'+dir_offset+'_psfsub/etc_crires_offsets_'+strcompress(string(lambda_val*1000, format='(I08)'))
;image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)

ENDFOR




;
;spat_offset_along_slit_vector=dblarr((size(dataa2contdiv_all_offsets_fin))[2])
;
;FOR I=0, n_elements(spat_offset_along_slit_vector) -1 DO spat_offset_along_slit_vector[i]=(cmi-star-sub)*0.086+ 0.086*i
;
;dataa2contdiv_all_offsets_fin=REVERSE(dataa2contdiv_all_offsets_fin,2)
;dataa2contdiv_all_offsets_fin=REVERSE(dataa2contdiv_all_offsets_fin,3)
;
;dataa2psfsub_all_offsets_fin=REVERSE(dataa2psfsub_all_offsets_fin,2)
;dataa2psfsub_all_offsets_fin=REVERSE(dataa2psfsub_all_offsets_fin,3)
;
;;cropping dataa2 in the spatial direction along the slit?
;size_along_slit=(size(dataa2contdiv_all_offsets_fin))[2]
;row=40
;crop=row
;star=FIX(size_along_slit/2.)
;cmi=star-crop
;cma=star+crop
;dataa2contdiv_all_offsets_fin=dataa2contdiv_all_offsets_fin[*,cmi:cma,*]
;dataa2psfsub_all_offsets_fin=dataa2psfsub_all_offsets_fin[*,cmi:cma,*]
;
;
;
;
;;lambda0=1.083330 ;He I 10833.3
;lambda0=1.0865619 ;Fe II 10865
;;lambda0=1.0941091 ; Pa gamma
;
;dir_offset='etc_crires_2009apr03_alloffsets_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_'+strcompress(string(lambda0*1e7, format='(I08)'))
;spawn,'mkdir /Users/jgroh/temp/'+dir_offset+'_contdiv',dummy,/sh
;spawn,'mkdir /Users/jgroh/temp/'+dir_offset+'_psfsub',dummy,/sh
;
;FOR index_lambda=0, 980, 1 DO BEGIN
;i=index_lambda
;;index_lambda=334
;lambda_val=lambda_newcal_vac_hel[index_lambda,row]
;
;gratdetlam='2009apr03_alloffsets_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_'+strcompress(string(lambda_val*1000, format='(I08)'))
;
;
;;generate continuum divided image
;a=1.0
;b=1.7
;ZE_ETACAR_CRIRES_CREATE_GENERIC_IMAGE_FROM_DATAA2,REFORM(dataa2contdiv_all_offsets_fin[index_lambda,*,*]),a,b,imgcontdiv,SQRT=1,LOG=0
;ZE_ETACAR_CRIRES_PLOT_MONOCHROMATIC_IMAGE_OFFSET_XWINDOW,imgcontdiv[*,1:9],a,b,cmi,cma,star,sub,row,offset_vector,aa,bb,lambda_val,lambda0
;imgname='etc_crires'+gratdetlam+'_contdiv'
;;ZE_ETACAR_CRIRES_PLOT_MONOCHROMATIC_IMAGE_OFFSET_EPS,imgcontdiv[*,1:9],a,b,imgname,cmi,cma,star,sub,row,offset_vector,aa,bb,lambda_val,lambda0
;wset,19
;file_output='/Users/jgroh/temp/'+dir_offset+'_contdiv/etc_crires_offsets_'+strcompress(string(lambda_val*1000, format='(I08)'))
;image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)
;
;
;;generate psf subtracted image
;a=8.0
;b=40.0
;ZE_ETACAR_CRIRES_CREATE_GENERIC_IMAGE_FROM_DATAA2,REFORM(dataa2psfsub_all_offsets_fin[index_lambda,*,*]),a,b,imgpsfsub,SQRT=1,LOG=0
;ZE_ETACAR_CRIRES_PLOT_MONOCHROMATIC_IMAGE_OFFSET_XWINDOW,imgpsfsub[*,1:9],a,b,cmi,cma,star,sub,row,offset_vector,aa,bb,lambda_val,lambda0
;imgname='etc_crires'+gratdetlam+'_psfsub'
;;ZE_ETACAR_CRIRES_PLOT_MONOCHROMATIC_IMAGE_OFFSET_EPS,imgpsfsub[*,1:9],a,b,imgname,cmi,cma,star,sub,row,offset_vector,aa,bb,lambda_val,lambda0
;wset,19
;file_output='/Users/jgroh/temp/'+dir_offset+'_psfsub/etc_crires_offsets_'+strcompress(string(lambda_val*1000, format='(I08)'))
;image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)
;
;
;;ZE_ETACAR_WORK_NACO_IMAGES_CHESNEAU,imgpsfsub
;;wset,4
;;
;;;for lambda0 in microns
;;vel_Val=ZE_LAMBDA_TO_VEL(lambda_val,lambda0*10^4)
;;xyouts,0.25,0.75,'v='+number_formatter(vel_val,decimals=0),/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=2.4
;;file_output='/Users/jgroh/temp/etc_crires_offsets2_naco/etc_crires_offsets_naco_'+strcompress(string(lambda_val*1000, format='(I08)'))
;;image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)
;
;ENDFOR


END