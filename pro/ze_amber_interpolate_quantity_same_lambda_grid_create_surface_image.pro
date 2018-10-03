PRO ZE_AMBER_INTERPOLATE_QUANTITY_SAME_LAMBDA_GRID_CREATE_SURFACE_IMAGE, z_array,x_array,y_array,npix,nspec,column,reference_dataset_line,x1,x2,y1,y2,a,b,x_array_out,z_array_out,image_surface

z_Array_out=z_array
x_array_out=x_array

FOR I=0, nspec -1 DO BEGIN

temp_vari=cspline(REFORM(x_array[*,i]),REFORM(z_array[*,i]),REFORM(x_array[*,0]))
;ZE_SIGMA_FILTER_1D,temp_vari,1,10,temp_vari
z_array_out[*,i]=temp_vari
x_array_out[*,i]=x_array[*,0]
ENDFOR
x_array_ref=REFORM(x_array_out[*,0])
shade_surf,z_array_out,x_array_ref,y_array,shades=BYTSCL((z_Array_out),MIN=a,MAX=b),zaxis=-1,az=0,ax=90,Xrange=[x1,x2],yrange=[y1,y2],charsize=2,ycharsize=1,xcharsize=1,$
xstyle=1,ystyle=1, xtitle='Wavelength', $
ytitle='Phase', Position=[0,0,1,1],PIXELS=10000,image=image_surface;, title=title


END