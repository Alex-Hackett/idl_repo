PRO ZE_MEASURE_SPEC_RESOLUTION_INTER,lambda,flux,fwhm_ang=fwhm_ang,res=res,gcoef=gcoef

    xgaussfit,lambda,flux,bcoef,gcoef
    fwhm_ang=2*SQRT(2*ALOG(2))*gcoef[2]
    res=gcoef(1)/fwhm_ang
    
END