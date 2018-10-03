PRO ZE_AMBER_INTERPOLATE_ALL_QUANTITIES_SAME_LAMBDA_GRID_FROM_DATA_STRUCT, data,npix,nspec,columns,reference_dataset_line,lambda_array_out,dp12_array_out,dp23_array_out,dp13_array_out,cp_array_out

y_Array_out=y_array
x_array_out=x_array

FOR I=0, nspec -1 DO BEGIN

temp_vari=cspline(REFORM(x_array[*,i]),REFORM(y_array[*,i]),REFORM(x_array[*,0]))
;ZE_SIGMA_FILTER_1D,temp_vari,1,10,temp_vari
y_array_out[*,i]=temp_vari
x_array_out[*,i]=x_array[*,0]
ENDFOR



END