
ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,all_lambda[0,0:all_nlambda_read[0]-1],9.0+((all_fluxnorm[0,0:all_nlambda_read[0]-1] - 1.0)*2.0 + 1.0),'Wavelength (Angstrom)', 'Normalized Flux','',$
                          x2=all_lambda[3,0:all_nlambda_read[3]-1],y2=8.0+((all_fluxnorm[3,0:all_nlambda_read[3]-1] - 1.0)*2.0 + 1.0),linestyle2=0,$
                          x3=all_lambda[7,0:all_nlambda_read[7]-1],y3=7.0+((all_fluxnorm[7,0:all_nlambda_read[7]-1] - 1.0)*2.0 + 1.0),linestyle3=0,$
                          x4=all_lambda[12,0:all_nlambda_read[12]-1],y4=6.0+((all_fluxnorm[12,0:all_nlambda_read[12]-1] - 1.0)/12.0 + 1.0),linestyle4=0,$
                          x5=all_lambda[14,0:all_nlambda_read[14]-1],y5=5.0+((all_fluxnorm[14,0:all_nlambda_read[14]-1] - 1.0)/4.0 + 1.0),linestyle5=0,$
                          x6=all_lambda[27,0:all_nlambda_read[27]-1],y6=4.0+((all_fluxnorm[27,0:all_nlambda_read[27]-1] - 1.0)/6.0 + 1.0),linestyle6=0,$
                          x7=all_lambda[36,0:all_nlambda_read[36]-1],y7=3.0+((all_fluxnorm[36,0:all_nlambda_read[36]-1] - 1.0)/5.0 + 1.0),linestyle7=0,$
                          x8=all_lambda[44,0:all_nlambda_read[44]-1],y8=2.0+((all_fluxnorm[44,0:all_nlambda_read[44]-1] - 1.0)/5.0 + 1.0),linestyle8=0,$ 
                          x9=all_lambda[47,0:all_nlambda_read[47]-1],y9=1.0+((all_fluxnorm[47,0:all_nlambda_read[47]-1] - 1.0)/10.0 + 1.0),linestyle9=0,$       
                          x10=all_lambda[51,0:all_nlambda_read[51]-1],y10=0.0+((all_fluxnorm[51,0:all_nlambda_read[51]-1] - 1.0)/3.0 + 1.0),linestyle_10=0,$                                                                         
                          pthick=7,xthick=7,ythick=7,pcharthick=8,pcharsize=1.4,aa=800,bb=500,$
                          xrange=[10000,24000],yrange=[0.4,11],POSITION=[0.08,0.10,0.98,0.98],filename='P060z14S0_selected_NIR_to_cyril',/rebin,factor1=4.0;,id_lambda=lambdac,id_text=id,id_ew=ew,ewmin=0.4,id_ypos=22.0


END