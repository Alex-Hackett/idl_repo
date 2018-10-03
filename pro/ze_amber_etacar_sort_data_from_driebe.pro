PRO ZE_AMBER_ETACAR_SORT_DATA_FROM_DRIEBE,line_epoch,filenames_to_read,b12,b23,b13,pa12,pa23,pa13,nspec,remove_similar_pa=remove_similar_pa

;cause problems in the interpolation when having two position angles similar or equal

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
filename='AMBER.2008-03-26T01:47:52.183_2008-03-26T01:47:52.183_2008-03-26T02:45:57.279_2008-03-26T02:45:57.279CALIB.SPEC'
ZE_READ_AMBER_DATA_FROM_DRIEBE,dir+filename,data=data_spec

file='OVERVIEW_GROH.TAB'
;pa_vector=[57.,66.,72.,79.,92.,108.,138.]
template=ASCII_TEMPLATE(dir+file)
data_filenames=read_ascii(dir+file,COUNT=nspec_all,TEMPLATE=template)
npix=500.

;mjd_array=DBLARR(nspec)
;phase_array=DBLARR(nspec)
;header_array=STRARR(nspec)
hei_brg_flag=dblarr(nspec_all)  

;FOR i=0, nspec -1 DO BEGIN
;ZE_READ_AMBER_DATA_FROM_DRIEBE,dir+data_filenames.field1[i],data=data
;lambda_temp=REFORM(data.field01[0,0:npix-1])*1e10
; IF lambda_temp[0] gt 21200 THEN hei_brg_flag[i]=0 ELSE  hei_brg_flag[i]=1
;ENDFOR

dateobstr=STRMID(data_filenames.field1,6,7)


CASE line_epoch of

 'brg_pre': BEGIN
 loc=WHERE((data_filenames.field8 eq 0 AND dateobstr eq '2008-03') OR (data_filenames.field8 eq 0 AND dateobstr eq '2008-04'),nspec)
    END

 'brg_dur': BEGIN
 loc=WHERE(data_filenames.field8 eq 0 AND dateobstr eq '2009-01',nspec) 
    END
    
 'brg_pos': BEGIN
 loc=WHERE(data_filenames.field8 eq 0 AND dateobstr eq '2009-03',nspec) 
    END
    
  'hei_pre': BEGIN
 loc=WHERE((data_filenames.field8 eq 1 AND dateobstr eq '2008-03') OR (data_filenames.field8 eq 1 AND dateobstr eq '2008-04'),nspec)
    END

 'hei_dur': BEGIN
 loc=WHERE(data_filenames.field8 eq 1 AND dateobstr eq '2009-01',nspec) 
    END
    
 'hei_pos': BEGIN
 loc=WHERE(data_filenames.field8 eq 1 AND dateobstr eq '2009-03',nspec) 
    END   
    
ENDCASE

filenames_to_read=data_filenames.field1[loc]
b12=data_filenames.field2[loc]
b23=data_filenames.field4[loc]
b13=data_filenames.field6[loc]
pa12=data_filenames.field3[loc]
pa23=data_filenames.field5[loc]
pa13=data_filenames.field7[loc]

;sort by pa12

filenames_to_read=filenames_to_read(sort(pa12))
b12=b12(sort(pa12))
b23=b23(sort(pa12))
b13=b13(sort(pa12))
pa12=pa12(sort(pa12))
pa23=pa23(sort(pa12))
pa13=pa13(sort(pa12))


;removing data with PA less than PA_thre, very simple algorithm=remove the second measurement. Something more sophisticated (average?) should be done in the future. 
IF KEYWORD_SET(remove_similar_pa) THEN BEGIN
PA_thre=1
pa12_diff=dblarr(nspec)
pa12_diff[0]=180. ;set to a large value to always use the first PA
FOR I=1, nspec - 1 DO pa12_diff[i]=pa12[i] - pa12[i-1]
index_for_removal=WHERE(pa12_diff lt PA_thre,countrem)
IF countrem gt 0 THEN BEGIN 
remove,index_for_removal,filenames_to_read,b12,b23,b13,pa12,pa23,pa13
nspec=nspec - n_elements(index_for_removal)
ENDIF
print,pa12_diff
ENDIF

END