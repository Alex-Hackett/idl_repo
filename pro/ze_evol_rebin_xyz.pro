PRO ZE_EVOL_REBIN_XYZ,x,y,xr,yr,z=z,rebin_z=rebin_z,factor=factor
;rebin x,y (and z if specfied) using congrid. factor is the the dowgrading factor (i.e num_points_fin=num_points/factor)

if n_elements(factor) LT 1 THEN factor=10.0
print,'Rebinning data with factor= ',1D0/factor
xr=congrid(reform(x),FLOOR(n_elements(x)/factor))
yr=congrid(reform(y),FLOOR(n_elements(y)/factor))
IF N_elements(z) GT 0 THEN rebin_z=congrid(z,FLOOR(n_elements(z)/factor))
 

END