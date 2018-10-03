PRO ZE_CCD_FIND_CLOSEST_LAMP_ID, lambda_peak_vals,tharlines,lambda_closest_id,index_closest_id
;for a given sample of lambda of peak values (corresponding to spectral lines), find the closest match in a list of lamp line IDS 

index_closest_id=dblarr(n_elements(lambda_peak_vals))
lambda_closest_id=dblarr(n_elements(lambda_peak_vals))
for i=0, n_elements(lambda_peak_vals)-1 do index_closest_id[i]= FINDEL(lambda_peak_vals[i],tharlines)
lambda_closest_id=tharlines(index_closest_id)

END