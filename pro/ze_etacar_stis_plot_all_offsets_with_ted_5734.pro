;PRO ZE_ETACAR_STIS_PLOT_ALL_OFFSETS_WITH_TED_5734
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

file=list[j+0]
file=list[j+30] ;for N II

dataa0=mrdfits(dir+file,0,headera0,/silent)
flux=mrdfits(dir+file,1,headera1,/silent)
dq=mrdfits(dir+file,2,headera2,/silent)
err=mrdfits(dir+file,3,headera3,/silent)

crval1=fxpar(headera1,'CRVAL1')
crpix1=fxpar(headera1,'CRPIX1')
crpix2=fxpar(headera1,'CRPIX2') ;position of central star
cd1=fxpar(headera1,'CD1_1')
platesc=fxpar(headera1,'CD2_2')*3600.D
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
;lambda0=4702.85
;lambda0=4659.35
line='[FeIII]'
;lambda0=4815.88
;line='[FeII]'
;lambda0=4714.47
;line='He I'
lambda0=5318.0944 ;for Fe II 5318, DOES NOT FALL IN THE DETECTOR
lambda0=5897.558 ;
;lambda0=5756.19
;line='[NII]'
;lambda0=5877.25
;line='He I'
;lambda0=5877.25
;line='He I'
pos_i=strpos(line,'[')
pos_f=strpos(line,']')
IF (pos_i NE -1) AND (pos_f NE -1) THEN line_for_filename=strmid(line,pos_i+1,pos_f-1) ELSE line_for_filename=line
;sobc[l]=strmid(sob[l],4,pos)
lambda0str=strcompress(string(lambda0, format='(I04)'))
FOR i=0., sizaxis1-1 DO lambda[i]=(crval1-cd1*CRPIX1)+(cd1*i)
vel=ZE_LAMBDA_TO_VEL(lambda,lambda0)

dataa2_all_offsets[*,*,j]=flux
offset_vector[j]=postarg1
print,file,crval1,j,postarg1

ENDFOR

dataa2_all_offsets_contsub_crop=dataa2_all_offsets

;selecting spatial range
ymin=-1.0       ; in arcsec
ymax=1.0 ; in arcsec
;ymin=-0.9
;ymax=0.9

flux=REFORM(dataa2_all_offsets[*,*,8])
near3=Min(Abs(offset_arc - ymin), index3)
near4=Min(Abs(offset_arc - ymax), index4)
sizaxis2new=index4-index3
fluxsc1=flux[*,index3:index4] ;cropped vector in spatial direction
offset_along_slit_arc_cut=offset_arc[index3:index4]

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
vel_cut=vel[index1:index2]

dataa2_all_offsets_contsub_crop=dblarr(index2-index1+1,index4-index3+1,noffset)

FOR j=0, noffset-1  DO BEGIN
flux=REFORM(dataa2_all_offsets[*,*,j])
sizaxis2new=index4-index3
fluxsc1=flux[*,index3:index4] ;cropped vector in spatial direction

colu=400 ;for cD37_0370
colu_up=470.
;normalize each row by the continuum? crudely done
for i=0, sizaxis2new - 1 do fluxsc1[*,i]=fluxsc1[*,i]-fluxsc1[colu,i]

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
;window,2,retain=2,xsize=xwindowsize,ysize=ywindowsize
;LOADCT,13
;img=bytscl(fluxcr,MIN=colorbar_min,MAX=colorbar_max); 
;tvimage,img,POSITION=[0,0,0.95,0.95],/nointerpolation
;pic2=tvrd(0,0,0.95*xwindowsize,0.95*ywindowsize,/true)
;wdelete,!d.window
;
;;plotting to the screen
;window,19,xsize=xwindownsize,ysize=ywindowsize,retain=0,XPOS=30,YPOS=60
;ZE_PRINT_STIS_2DSPEC_NORM_VEL,pic2,fluxcr,lambda,vel,offset_arc,star_off,platesc,lambda0,pa,file,line,index1,index2,index3,index4,colorbar_min,colorbar_max,midticks

;;generate mapping images
a=0
b=1e-13
lambda0_micron=lambda0*1e-4
lambda_new=lambda[index1:index2]

FOR index_lambda=0, index2-index1 , 1 DO BEGIN
;i=index_lambda
;index_lambda=29
lambda_val=lambda_new[index_lambda]
vel_val=ZE_LAMBDA_TO_VEL(lambda_val,lambda0)
vel_valstr=strcompress(string(vel_val, format='(I04)'))
aa=900
bb=aa/(max(offset_along_slit_arc_cut)/max(offset_vector))
;ZE_ETACAR_CRIRES_CREATE_GENERIC_IMAGE_FROM_DATAA2,REFORM(dataa2_all_offsets_contsub_crop[index_lambda,*,*]),a,b,imgpsfsub,SQRT=1,LOG=0

dataa2_all_offsets_contsub_crop(WHERE(dataa2_all_offsets_contsub_crop) le 0)=0
imgpsfsub=bytscl(REFORM(dataa2_all_offsets_contsub_crop[index_lambda,*,*]),MIN=a,MAX=b)
print,'TESTE',a,b
ct=3
nointerp=1
ZE_HST_STIS_MAPPING_PLOT_MONOCHROMATIC_IMAGE_XWINDOW,imgpsfsub,a,b,offset_along_slit_arc_cut,offset_vector,aa,bb,lambda_val,lambda0_micron,ct,nointerp

imgname='etc_stis'
;ZE_ETACAR_CRIRES_PLOT_MONOCHROMATIC_IMAGE_OFFSET_EPS,imgpsfsub,a,b,imgname,cmi,cma,star,sub,row,offset_vector,aa,bb,lambda_val,lambda0_micron
;wset,19
file_output='/Users/jgroh/temp/etc_stis_mapping_'+lambda0str+'_'+strcompress(string(lambda_val*1000, format='(I08)'))
;sequential file numbering has to be used to propely create animated GIFs using convert
file_output='/Users/jgroh/temp/etc_stis_mapping_'+line_for_filename+'_'+strcompress(string(index_lambda, format='(I04)'))
;image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)
ENDFOR


;create animated GIF using convert
dir_movie='/Users/jgroh/temp/'
sufix_gif='etc_stis_mapping_'+line_for_filename+'_'
movie_output_gif='etc_stis_mapping_'+line_for_filename+'.gif'
movie_output_mov='etc_stis_mapping_'+line_for_filename+'.mov'
digits=4
init_image=0
end_image=index2-index1
delay_time='30'
convert_mov=0 ; set to 0 to not convert; converting to quicktime .mov will only work in Mac OSX with QTAmateur installed;
;ZE_GIF_ANIMATE_USING_CONVERT,dir_movie,sufix_gif,digits,init_image,end_image,delay_time,movie_output_gif,CONVERT_MOV=convert_mov

;command line to close QTAmateur application
;osascript -e 'tell application "QTAmateur" to quit'

;rename 'teste' to the correct filename; has to be run after this procedure is finished and the QTAmateur conversion is done
;spawn,'mv /Users/jgroh/Documents/teste '+dir_movie+movie_output_mov

;plot images integrated over a certain velocity range
vel_min=-500.    ;in km/s
vel_max=-250      ;in km/s
near = Min(Abs(vel_cut - vel_min), index7)
near2= Min(Abs(vel_cut - vel_max), index8)
a=0.0
b=max(TOTAL(dataa2_all_offsets_contsub_crop[index7:index8,*,*],1))
img_m500_m250_contsub=bytscl(TOTAL(dataa2_all_offsets_contsub_crop[index7:index8,*,*],1),MIN=a,MAX=5e-13)
ZE_HST_STIS_MAPPING_PLOT_MONOCHROMATIC_IMAGE_XWINDOW,img_m500_m250_contsub,a,b,offset_along_slit_arc_cut,offset_vector,aa,bb,lambda_val,lambda0_micron,ct,nointerp


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