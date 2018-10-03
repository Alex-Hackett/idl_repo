;PRO ZE_PLOT_LBVS_HR_DIAGRAM_FOR_MWC314_PAPER_LOBEL
;;only LBV progenitors
;observed LBVs compiled by Groh 2013; same as Clark+09, plus HR Car with parameters from Groh+2009 ApjL, Tstar values have +1000K degree added to Teff when Tstar was not given
;read  data
READCOL,'/Users/jgroh/temp/lbv_observed_parameters.txt',F='A,F,F,F,A',idobslbv,tstarobslbv,teffobslbv,lstarobslbv,reflbv
;remove duplicate stars; we are only plotting maximum and minimum teff
remove,[2,5,10,11,12,13,14],idobslbv,tstarobslbv,teffobslbv,lstarobslbv,reflbv
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,alog10(1e3*tstarobslbv),alog10(lstarobslbv),psym1=15,symsize1=1.5,symcolor1='red','Log Temperature (K)','Log Luminosity (Lsun)','',$
                                xrange=[5.0,3.40],yrange=[5.0,6.95],xreverse=0,_EXTRA=extra,rebin=0,labeldata=idobslbv
                              
END