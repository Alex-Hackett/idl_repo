PRO ZE_CAMIV_SELECT_STAR_CENTER_V2,image,star_center, auto=auto
    
    spatindex=1.*indgen((size(image))[1])
    specindex=1.*indgen((size(image))[2])
    IF KEYWORD_SET(AUTO) THEN  centerfit=gaussfit(spatindex,image[*,max(specindex)/2],gcoef,nterms=5) ELSE xgaussfit,spatindex,image[*,max(specindex)/2],bcoef,gcoef
    star_center=gcoef(1)

    ;added to account for cases when no good centroid could be found
    IF star_Center LT 4 OR star_center GT ((size(image))[1] -4) THEN BEGIN
       star_center=(size(image))[1]/2
       Print,'Warning: no centroid cound be found'
    ENDIF

END