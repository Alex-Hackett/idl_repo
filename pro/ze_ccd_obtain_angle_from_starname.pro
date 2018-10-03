PRO ZE_CCD_OBTAIN_ANGLE_FROM_STARNAME,starname,allowed_angles,angle,star
;routine to obtain angle and star of all observations contained in starname.
;returns a string array

nallowed_angles=n_elements(allowed_angles)
nobs=n_elements(starname)
angle=strarr(nobs)
angle(*)='DNA'
star=strarr(nobs)

angle_match=intarr(nobs,nallowed_angles)
for j=0, nallowed_angles -1 do for i=0, nobs -1 do begin 
    angle_match[i,j]=strmatch(starname[i],'*'+allowed_angles[j]+'*')
    IF  angle_match[i,j] EQ 1 THEN angle[i]=allowed_angles[j]
endfor

for i=0, nobs -1 do begin 
 posangle=strpos(starname[i],angle[i],/REVERSE_SEARCH)
 ;print,posangle
 IF posangle GT 0 THEN BEGIN 
    star[i]=strmid(starname[i],0,posangle)
    if strpos(star[i],'_',/REVERSE_SEARCH) EQ (strlen(star[i]) -1 ) THEN star[i]=strmid(star[i],0,strlen(star[i]) -1)
 ENDIF ELSE star[i]=starname[i]
endfor

END