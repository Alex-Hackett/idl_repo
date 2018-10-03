FUNCTION ZE_REPLICATE_VECTOR_1D,array,ntimes
 
 nelem=n_elements(array)
 new_array=dblarr(nelem*ntimes)
for i=0, ntimes -1 DO new_array[0+nelem*i:(nelem-1)+(nelem*i)]=array
return,new_array


END