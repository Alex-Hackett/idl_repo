PRO ZE_SELECT_STAR_CENTER,dataa2,star=star

    spatindex=1.*indgen((size(dataa2))[2])
    specindex=1.*indgen((size(dataa2))[1])
    xgaussfit,spatindex,dataa2[max(specindex)/2.,*],bcoef,gcoef
    star=gcoef(1)
END