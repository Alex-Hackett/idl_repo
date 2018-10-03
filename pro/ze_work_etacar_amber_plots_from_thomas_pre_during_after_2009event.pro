;PRO ZE_WORK_ETACAR_AMBER_PLOTS_FROM_THOMAS_PRE_DURING_AFTER_2009EVENT

;In the .SPEC files, please use columns 0 (wavelength) and 6 (averaged
;flux, arbitrary units). 
;
;In the .ASCII files, please find the relevant
;quantities in the following table columns:
;
;quantity           column #
;-----------------------------------
;wavelength           0
;visib_122            1
;visib_122,err        2
;visib_232            3
;visib_232 ,err       4
;visib_132            5
;visib_132,err        6
;DP_12                7
;DP_12,err            8
;DP_23                9
;DP_23,err            10
;DP_13                11
;DP_13,err            12
;CP                   19
;CP,err               20

dir='/Users/jgroh/data/amber/Etacar_pre_during_after_2009event_from_driebe/'
filename_Spec='AMBER.2008-03-26T01:47:52.183_2008-03-26T01:47:52.183_2008-03-26T02:45:57.279_2008-03-26T02:45:57.279CALIB.SPEC'
ZE_READ_AMBER_DATA_FROM_DRIEBE,dir+filename_spec,data=data_spec

npix=500.

;decide between hei or brg
line='hei'      ; brg or hei

;decide between pre, during, or post-event
epoch='pos'     ;0=pre, 1=during, 2=post-event
line_epoch=line+'_'+epoch

ZE_AMBER_ETACAR_SORT_DATA_FROM_DRIEBE,line_epoch,filenames_to_read,b12,b23,b13,pa12,pa23,pa13,nspec,remove_similar_pa=1
pa_vector=pa12
cp_array=DBLARR(npix,nspec)
vis12_array=DBLARR(npix,nspec)
vis23_array=DBLARR(npix,nspec)
vis13_array=DBLARR(npix,nspec)
dp12_array=DBLARR(npix,nspec)
dp23_array=DBLARR(npix,nspec)
dp13_array=DBLARR(npix,nspec)
lambda_array=DBLARR(npix,nspec)
dvis12_array=DBLARR(npix,nspec)
dvis23_array=DBLARR(npix,nspec)
dvis13_array=DBLARR(npix,nspec)
;mjd_array=DBLARR(nspec)
;phase_array=DBLARR(nspec)
;header_array=STRARR(nspec)


FOR i=0, nspec -1 DO BEGIN
ZE_READ_AMBER_DATA_FROM_DRIEBE,dir+filenames_to_read[i],data=data
;help,data,/struct
lambda_array[*,i]=REFORM(data.field01[0,0:npix-1])*1e10
vis12_array[*,i]=REFORM(data.field01[1,0:npix-1])
vis23_array[*,i]=REFORM(data.field01[3,0:npix-1])
vis13_array[*,i]=REFORM(data.field01[5,0:npix-1])
dp12_array[*,i]=REFORM(data.field01[7,0:npix-1])*180./!PI
dp23_array[*,i]=REFORM(data.field01[9,0:npix-1])*180./!PI
dp13_array[*,i]=REFORM(data.field01[11,0:npix-1])*180./!PI
cp_array[*,i]=REFORM(data.field01[19,0:npix-1])*180./!PI
;flux=mrdfits(obsdir+data.field1[i],0,header)
;flux_array[*,i]=flux
;dateobs=fxpar(header,'DATE-OBS')
;dateobstr=STRTRIM(dateobs,2)
;mjd=date_conv(dateobstr,'MODIFIED') 
;mjd_array[i]=mjd
;header_array[i]=header
ENDFOR

;compute differential phases 
norm_sect=[30,100]
norm_vec=dblarr(norm_sect[1]-norm_sect[0])

FOR I=0,nspec -1 DO BEGIN
norm_vec=vis12_array[norm_sect[0]:norm_sect[1],i]
norm_line_val=(MOMENT(norm_vec))[0]
print,norm_line_val
dvis12_array[*,i]=vis12_array[*,i]/norm_line_val

norm_vec=vis23_array[norm_sect[0]:norm_sect[1],i]
norm_line_val=(MOMENT(norm_vec))[0]
dvis23_array[*,i]=vis23_array[*,i]/norm_line_val
print,norm_line_val

norm_vec=vis13_array[norm_sect[0]:norm_sect[1],i]
norm_line_val=(MOMENT(norm_vec))[0]
dvis13_array[*,i]=vis13_array[*,i]/norm_line_val
print,norm_line_val
ENDFOR

;interpolate all quantities to the same lambda grid

column=0
reference_dataset_line=0
;ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_FROM_DATA_STRUCT, lambda_array,cp_array,npix,nspec,column,reference_dataset_line,lambda_array_out,cp_array_out
;ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_FROM_DATA_STRUCT, lambda_array,dp12_array,npix,nspec,column,reference_dataset_line,lambda_array_out,dp12_array_out
;ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_FROM_DATA_STRUCT, lambda_array,dp23_array,npix,nspec,column,reference_dataset_line,lambda_array_out,dp23_array_out
;ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_FROM_DATA_STRUCT, lambda_array,dp13_array,npix,nspec,column,reference_dataset_line,lambda_array_out,dp13_array_out
;ZE_AMBER_INTERPOLATE_ALL_QUANTITIES_SAME_LAMBDA_GRID_FROM_DATA_STRUCT, lambda_array,dp13_array,npix,nspec,columns,reference_dataset_line,lambda_array_out,dp13_array_out


xtitle='Wavelength'

IF line eq 'brg' THEN BEGIN
x1=21600
x2=21720
lambda0=21661.2
ENDIF ELSE BEGIN
x1=20520
x2=20660
lambda0=20587.0
ENDELSE

ytitle='Position Angle'
y1=min(pa_vector)-5
y2=max(pa_vector)+5

mincp=-130
maxcp=90

minvis12=0.
maxvis12=0.8

minvis23=0.
maxvis23=0.8

minvis13=0.
maxvis13=0.8

mindvis12=0.
maxdvis12=1.0

mindvis23=0.
maxdvis23=1.0

mindvis13=0.
maxdvis13=1.0


mindp12=-70
maxdp12=70

mindp23=-70
maxdp23=70

mindp13=-70
maxdp13=70

ndphase=0.
ndvis=1.

ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_CREATE_SURFACE_IMAGE, cp_array,lambda_array,pa_vector,npix,nspec,column,reference_dataset_line,x1,x2,y1,y2,mincp,maxcp,lambda_array_out,cp_array_out,cp_lambda_pa_surface
lambda=REFORM(lambda_array_out[*,0])
ZE_AMBER_PLOT_INTERPOLATED_QUANTITIES_2D_SURFACE,lambda,pa_vector,'CP',data_spec,x1,x2,y1,y2,cp_lambda_pa_surface,mincp,maxcp,xtitle,ytitle,lambda0,ndphase,line_epoch

ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_CREATE_SURFACE_IMAGE, vis12_array,lambda_array,pa_vector,npix,nspec,column,reference_dataset_line,x1,x2,y1,y2,minvis12,maxvis12,lambda_array_out,vis12_array_out,vis12_lambda_pa_surface
ZE_AMBER_PLOT_INTERPOLATED_QUANTITIES_2D_SURFACE,lambda,pa_vector,'Vis12',data_spec,x1,x2,y1,y2,vis12_lambda_pa_surface,minvis12,maxvis12,xtitle,ytitle,lambda0,ndvis,line_epoch

ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_CREATE_SURFACE_IMAGE, vis23_array,lambda_array,pa_vector,npix,nspec,column,reference_dataset_line,x1,x2,y1,y2,minvis23,maxvis23,lambda_array_out,vis23_array_out,vis23_lambda_pa_surface
ZE_AMBER_PLOT_INTERPOLATED_QUANTITIES_2D_SURFACE,lambda,pa_vector,'Vis23',data_spec,x1,x2,y1,y2,vis23_lambda_pa_surface,minvis23,maxvis23,xtitle,ytitle,lambda0,ndvis,line_epoch

ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_CREATE_SURFACE_IMAGE, vis13_array,lambda_array,pa_vector,npix,nspec,column,reference_dataset_line,x1,x2,y1,y2,minvis13,maxvis13,lambda_array_out,vis13_array_out,vis13_lambda_pa_surface
ZE_AMBER_PLOT_INTERPOLATED_QUANTITIES_2D_SURFACE,lambda,pa_vector,'Vis13',data_spec,x1,x2,y1,y2,vis13_lambda_pa_surface,minvis13,maxvis13,xtitle,ytitle,lambda0,ndvis,line_epoch

ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_CREATE_SURFACE_IMAGE, dp12_array,lambda_array,pa_vector,npix,nspec,column,reference_dataset_line,x1,x2,y1,y2,mindp12,maxdp12,lambda_array_out,dp12_array_out,dp12_lambda_pa_surface
ZE_AMBER_PLOT_INTERPOLATED_QUANTITIES_2D_SURFACE,lambda,pa_vector,'DP12',data_spec,x1,x2,y1,y2,dp12_lambda_pa_surface,mindp12,maxdp12,xtitle,ytitle,lambda0,ndphase,line_epoch

ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_CREATE_SURFACE_IMAGE, dp23_array,lambda_array,pa_vector,npix,nspec,column,reference_dataset_line,x1,x2,y1,y2,mindp23,maxdp23,lambda_array_out,dp23_array_out,dp23_lambda_pa_surface
ZE_AMBER_PLOT_INTERPOLATED_QUANTITIES_2D_SURFACE,lambda,pa_vector,'DP23',data_spec,x1,x2,y1,y2,dp23_lambda_pa_surface,mindp23,maxdp23,xtitle,ytitle,lambda0,ndphase,line_epoch

ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_CREATE_SURFACE_IMAGE, dp13_array,lambda_array,pa_vector,npix,nspec,column,reference_dataset_line,x1,x2,y1,y2,mindp13,maxdp13,lambda_array_out,dp13_array_out,dp13_lambda_pa_surface
ZE_AMBER_PLOT_INTERPOLATED_QUANTITIES_2D_SURFACE,lambda,pa_vector,'DP13',data_spec,x1,x2,y1,y2,dp13_lambda_pa_surface,mindp13,maxdp13,xtitle,ytitle,lambda0,ndphase,line_epoch

ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_CREATE_SURFACE_IMAGE, dvis12_array,lambda_array,pa_vector,npix,nspec,column,reference_dataset_line,x1,x2,y1,y2,mindvis12,maxdvis12,lambda_array_out,dvis12_array_out,dvis12_lambda_pa_surface
ZE_AMBER_PLOT_INTERPOLATED_QUANTITIES_2D_SURFACE,lambda,pa_vector,'dVis12',data_spec,x1,x2,y1,y2,dvis12_lambda_pa_surface,mindvis12,maxdvis12,xtitle,ytitle,lambda0,nddvis,line_epoch

ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_CREATE_SURFACE_IMAGE, dvis23_array,lambda_array,pa_vector,npix,nspec,column,reference_dataset_line,x1,x2,y1,y2,mindvis23,maxdvis23,lambda_array_out,dvis23_array_out,dvis23_lambda_pa_surface
ZE_AMBER_PLOT_INTERPOLATED_QUANTITIES_2D_SURFACE,lambda,pa_vector,'dVis23',data_spec,x1,x2,y1,y2,dvis23_lambda_pa_surface,mindvis23,maxdvis23,xtitle,ytitle,lambda0,nddvis,line_epoch

ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_CREATE_SURFACE_IMAGE, dvis13_array,lambda_array,pa_vector,npix,nspec,column,reference_dataset_line,x1,x2,y1,y2,mindvis13,maxdvis13,lambda_array_out,dvis13_array_out,dvis13_lambda_pa_surface
ZE_AMBER_PLOT_INTERPOLATED_QUANTITIES_2D_SURFACE,lambda,pa_vector,'dVis13',data_spec,x1,x2,y1,y2,dvis13_lambda_pa_surface,mindvis13,maxdvis13,xtitle,ytitle,lambda0,nddvis,line_epoch

set_plot,'x'
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