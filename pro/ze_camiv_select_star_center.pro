PRO ZE_CAMIV_SELECT_STAR_CENTER,image,star_center

    spatindex=1.*indgen((size(image))[1])
    specindex=1.*indgen((size(image))[2])
    xgaussfit,spatindex,image[*,max(specindex)/2],bcoef,gcoef
    star_center=gcoef(1)
END