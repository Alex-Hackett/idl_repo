;PRO ZE_ETACAR_CRIRES_PLOT_SCOM_ALL_OFFSETS_WITH_MAIRAN

noffset=6

for pos=1, 1 DO BEGIN

grat_angle=1087
det=3
;pos=2
xnodes=0
ynodes=0
xnodes_spec_Ext=0
ynodes_spec_ext=0
gratdet_orig='2009apr03_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_offset'+strcompress(string(pos, format='(I01)'))
saved_file='/Users/jgroh/espectros/etc_'+gratdet_orig+'_allvar.sav'

if (FILE_EXIST(saved_file) eq 0) then begin
  print,'Saved file not found. No saved file was restored.'
endif else begin
restore,saved_file
endelse

endfor

dataa2_all_offsets=dblarr(sizelam,sizespat,noffset)
dataa2contdiv_all_offsets=dataa2_all_offsets
dataa2contsub_all_offsets=dataa2_all_offsets
dataa2psfsub_all_offsets=dataa2_all_offsets

for pos=1, noffset DO BEGIN

ynodes_spec_ext=0
gratdet_orig='2009apr03_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_offset'+strcompress(string(pos, format='(I01)'))
saved_file='/Users/jgroh/espectros/etc_'+gratdet_orig+'_allvar.sav'

if (FILE_EXIST(saved_file) eq 0) then begin
  print,'Saved file not found. No saved file was restored.'
endif else begin
restore,saved_file
endelse

dataa2_all_offsets[*,*,pos-1]=dataa2
dataa2contdiv_all_offsets[*,*,pos-1]=dataa2contdiv
dataa2contsub_all_offsets[*,*,pos-1]=dataa2contsub
dataa2psfsub_all_offsets[*,*,pos-1]=dataa2psfsub
endfor


;including offset centered on the star
dataa2_Star=dblarr(sizelam,sizespat)
dataa2_null=dblarr(sizelam,sizespat)

;load 2d spectrum from the central star
gratdet='2009apr03_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))
saved_file='/Users/jgroh/espectros/etc_'+gratdet+'_allvar.sav'
if (FILE_EXIST(saved_file) eq 0) then begin
  print,'Saved file not found. No saved file was restored.'
endif else begin
restore,saved_file
dataa2_star_contdiv=dataa2contdiv
dataa2_star_psfsub=dataa2psfsub*35.0
endelse


dataa2_star_contsub=dataa2_Star
dataa2_null[*,*]=0.0
dataa2_all_offsets_fin=[[[dataa2_all_offsets[*,*,0:2]]],[[dataa2_star[*,*]]],[[dataa2_all_offsets[*,*,3:5]]]]
;dataa2contdiv_all_offsets_fin=[[[dataa2contdiv_all_offsets[*,*,0:2]]],[[dataa2_star_contdiv[*,*]]],[[dataa2contdiv_all_offsets[*,*,3:5]]]]
dataa2contsub_all_offsets_fin=[[[dataa2contsub_all_offsets[*,*,0:2]]],[[dataa2_star_contsub[*,*]]],[[dataa2contsub_all_offsets[*,*,3:5]]]]


dataa2contdiv_all_offsets_fin=[[[dataa2_null[*,*]]],[[dataa2contdiv_all_offsets[*,*,0]]],[[(dataa2contdiv_all_offsets[*,*,0]+dataa2contdiv_all_offsets[*,*,1])/2.0]],[[dataa2contdiv_all_offsets[*,*,1:2]]],[[dataa2_star_contdiv[*,*]]],[[dataa2contdiv_all_offsets[*,*,3:4]]],[[(dataa2contdiv_all_offsets[*,*,4]+dataa2contdiv_all_offsets[*,*,5])/2.0]],[[dataa2contdiv_all_offsets[*,*,5]]],[[dataa2_null[*,*]]]]

dataa2psfsub_all_offsets_fin=[[[dataa2_null[*,*]]],[[dataa2psfsub_all_offsets[*,*,0]]],[[(dataa2psfsub_all_offsets[*,*,0]+dataa2psfsub_all_offsets[*,*,1])/2.0]],[[dataa2psfsub_all_offsets[*,*,1:2]]],[[dataa2_star_psfsub[*,*]]],[[dataa2psfsub_all_offsets[*,*,3:4]]],[[(dataa2psfsub_all_offsets[*,*,4]+dataa2psfsub_all_offsets[*,*,5])/2.0]],[[dataa2psfsub_all_offsets[*,*,5]]],[[dataa2_null[*,*]]]]


offset_vector=[-1.1,-0.9,-0.5,-0.3,-0.1, 0.3, 0.5, 0.9, 1.1]+0.1

spat_offset_along_slit_vector=dblarr((size(dataa2contdiv_all_offsets_fin))[2])

FOR I=0, n_elements(spat_offset_along_slit_vector) -1 DO spat_offset_along_slit_vector[i]=(cmi-star-sub)*0.086+ 0.086*i

dataa2contdiv_all_offsets_fin=REVERSE(dataa2contdiv_all_offsets_fin,2)
dataa2contdiv_all_offsets_fin=REVERSE(dataa2contdiv_all_offsets_fin,3)

dataa2psfsub_all_offsets_fin=REVERSE(dataa2psfsub_all_offsets_fin,2)
dataa2psfsub_all_offsets_fin=REVERSE(dataa2psfsub_all_offsets_fin,3)

;cropping dataa2 in the spatial direction along the slit?
size_along_slit=(size(dataa2contdiv_all_offsets_fin))[2]
row=40
crop=row
star=FIX(size_along_slit/2.)
cmi=star-crop
cma=star+crop
dataa2contdiv_all_offsets_fin=dataa2contdiv_all_offsets_fin[*,cmi:cma,*]
dataa2psfsub_all_offsets_fin=dataa2psfsub_all_offsets_fin[*,cmi:cma,*]




;lambda0=1.083330 ;He I 10833.3
lambda0=1.0865619 ;Fe II 10865
;lambda0=1.0941091 ; Pa gamma

dir_offset='etc_crires_2009apr03_alloffsets_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_'+strcompress(string(lambda0*1e7, format='(I08)'))
spawn,'mkdir /Users/jgroh/temp/'+dir_offset+'_contdiv',dummy,/sh
spawn,'mkdir /Users/jgroh/temp/'+dir_offset+'_psfsub',dummy,/sh

FOR index_lambda=0, 980, 1 DO BEGIN
i=index_lambda
;index_lambda=334
lambda_val=lambda_newcal_vac_hel[index_lambda,row]

gratdetlam='2009apr03_alloffsets_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))+'_'+strcompress(string(lambda_val*1000, format='(I08)'))


;generate continuum divided image
a=1.0
b=1.7
ZE_ETACAR_CRIRES_CREATE_GENERIC_IMAGE_FROM_DATAA2,REFORM(dataa2contdiv_all_offsets_fin[index_lambda,*,*]),a,b,imgcontdiv,SQRT=1,LOG=0
ZE_ETACAR_CRIRES_PLOT_MONOCHROMATIC_IMAGE_OFFSET_XWINDOW,imgcontdiv[*,1:9],a,b,cmi,cma,star,sub,row,offset_vector,aa,bb,lambda_val,lambda0
imgname='etc_crires'+gratdetlam+'_contdiv'
;ZE_ETACAR_CRIRES_PLOT_MONOCHROMATIC_IMAGE_OFFSET_EPS,imgcontdiv[*,1:9],a,b,imgname,cmi,cma,star,sub,row,offset_vector,aa,bb,lambda_val,lambda0
wset,19
file_output='/Users/jgroh/temp/'+dir_offset+'_contdiv/etc_crires_offsets_'+strcompress(string(lambda_val*1000, format='(I08)'))
image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)


;generate psf subtracted image
a=8.0
b=40.0
ZE_ETACAR_CRIRES_CREATE_GENERIC_IMAGE_FROM_DATAA2,REFORM(dataa2psfsub_all_offsets_fin[index_lambda,*,*]),a,b,imgpsfsub,SQRT=1,LOG=0
ZE_ETACAR_CRIRES_PLOT_MONOCHROMATIC_IMAGE_OFFSET_XWINDOW,imgpsfsub[*,1:9],a,b,cmi,cma,star,sub,row,offset_vector,aa,bb,lambda_val,lambda0
imgname='etc_crires'+gratdetlam+'_psfsub'
;ZE_ETACAR_CRIRES_PLOT_MONOCHROMATIC_IMAGE_OFFSET_EPS,imgpsfsub[*,1:9],a,b,imgname,cmi,cma,star,sub,row,offset_vector,aa,bb,lambda_val,lambda0
wset,19
file_output='/Users/jgroh/temp/'+dir_offset+'_psfsub/etc_crires_offsets_'+strcompress(string(lambda_val*1000, format='(I08)'))
image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)


;ZE_ETACAR_WORK_NACO_IMAGES_CHESNEAU,imgpsfsub
;wset,4
;
;;for lambda0 in microns
;vel_Val=ZE_LAMBDA_TO_VEL(lambda_val,lambda0*10^4)
;xyouts,0.25,0.75,'v='+number_formatter(vel_val,decimals=0),/NORMAL,color=fsc_color('white'),charsize=3.5,charthick=2.4
;file_output='/Users/jgroh/temp/etc_crires_offsets2_naco/etc_crires_offsets_naco_'+strcompress(string(lambda_val*1000, format='(I08)'))
;image = TVREAD(FILENAME = file_output, /GIF, /NODIALOG)

ENDFOR


END