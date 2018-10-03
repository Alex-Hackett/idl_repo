PRO ZE_COMPUTE_DIFFTIME_VECTOR,time,reference_index,difftime
;routine to compute difference in time between elements in an array
;reference index= index to which diff will be referring to

difftime=dblarr(n_elements(time))

for i=0, n_elements(time) -1 DO difftime[i]=time[i]-time[reference_index]

END