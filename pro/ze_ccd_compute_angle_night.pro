PRO ZE_CCD_COMPUTE_ANGLE_NIGHT,starname,allowed_angles,angle
;routine to obtain angle of all observations contained in starname.
;returns a string array

nallowed_angles=n_elements(allowed_angles)
nobs=n_elements(starname)
angle=strarr(nobs)

angle_match=intarr(nobs,nallowed_angles)
for j=0, nallowed_angles -1 do for i=0, nobs -1 do begin 
    angle_match[i,j]=strmatch(starname[i],'*'+allowed_angles[j]+'*')
    IF  angle_match[i,j] EQ 1 THEN angle[i]=allowed_angles[j]
endfor



END