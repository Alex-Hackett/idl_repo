
Angstrom = '!6!sA!r!u!9 %!6!n'

;Augusto's 2003 data
dirin = '/Users/jgroh/papers_groh/2008_Etacar_Damineli_multiwavelenght_variability/AUGUSTO2/'
data930 = READ_FLOAT_DATA(dirin+'03MAY25.DAT',2)
data911 = READ_FLOAT_DATA(dirin+'03JUN24.DAT',2)
data921 = READ_FLOAT_DATA(dirin+'03JUN29.DAT',2)

dirin2 = '/Users/jgroh/data/lna/camiv_spectra/etc_09jan08_10830.fits'
ZE_READ_SPECTRA_FITS,dirin2,lambda09,flux09,header,nrec
airtovac,lambda09

C=299792.458
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!X.THICK=0
!Y.THICK=0
!P.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0

;***********************************************************************************
;                                 MAY 2008
;***********************************************************************************                                 
;ZE_CRIRES_SPEC_COMBINE_V2, '2008may_1087_1','2008may_1090_1',l1,spec1
;ZE_CRIRES_SPEC_COMBINE_V2, '2008may_1087_2','2008may_1090_2',l2,spec2
;ZE_CRIRES_SPEC_COMBINE_V2, '2008may_1087_3','2008may_1090_3',l3,spec3
;ZE_CRIRES_SPEC_COMBINE_V2, '2008may_1087_4','2008may_1090_4',l4,spec4
;
;ZE_1DSPEC_COMBINE_V2, l1,spec1,l2,spec2,lambdacomb_1dspc=l12comb,fluxcomb_1dspc=spec12comb
;ZE_1DSPEC_COMBINE_V2, l3,spec3,l4,spec4,lambdacomb_1dspc=l34comb,fluxcomb_1dspc=spec34comb
;
;ZE_1DSPEC_COMBINE_V2, l12comb,spec12comb,l34comb,spec34comb,lambdacomb_1dspc=lall,fluxcomb_1dspc=fall
;lallmay=lall
;fallmay=fall
;save,/variables,FILENAME='/Users/jgroh/espectros/etc_10830_spec_onstar_may08.sav'


;***********************************************************************************
;                                 DEC 2008
;***********************************************************************************                                 
;ZE_CRIRES_SPEC_COMBINE_V2, '2008dec26_1087_1','2008dec26_1090_1',l1,spec1
;ZE_CRIRES_SPEC_COMBINE_V2, '2008dec26_1087_2','2008dec26_1090_2',l2,spec2
;ZE_CRIRES_SPEC_COMBINE_V2, '2008dec26_1087_3','2008dec26_1090_3',l3,spec3
;ZE_CRIRES_SPEC_COMBINE_V2, '2008dec26_1087_4','2008dec26_1090_4',l4,spec4
;
;ZE_1DSPEC_COMBINE_V2, l1,spec1,l2,spec2,lambdacomb_1dspc=l12comb,fluxcomb_1dspc=spec12comb
;ZE_1DSPEC_COMBINE_V2, l3,spec3,l4,spec4,lambdacomb_1dspc=l34comb,fluxcomb_1dspc=spec34comb
;
;ZE_1DSPEC_COMBINE_V2, l12comb,spec12comb,l34comb,spec34comb,lambdacomb_1dspc=lall,fluxcomb_1dspc=fall
;lalldec=lall
;falldec=fall
;save,/variables,FILENAME='/Users/jgroh/espectros/etc_10830_spec_onstar_dec08.sav'

;***********************************************************************************
;                                 JAN 2009
;***********************************************************************************  
;ZE_CRIRES_SPEC_COMBINE_V2, '1087_1','1090_1',l1,spec1
;ZE_CRIRES_SPEC_COMBINE_V2, '1087_2','1090_2',l2,spec2
;ZE_CRIRES_SPEC_COMBINE_V2, '1087_3','1090_3',l3,spec3
;ZE_CRIRES_SPEC_COMBINE_V2, '1087_4','1090_4',l4,spec4
;
;ZE_1DSPEC_COMBINE_V2, l1,spec1,l2,spec2,lambdacomb_1dspc=l12comb,fluxcomb_1dspc=spec12comb
;ZE_1DSPEC_COMBINE_V2, l3,spec3,l4,spec4,lambdacomb_1dspc=l34comb,fluxcomb_1dspc=spec34comb
;
;ZE_1DSPEC_COMBINE_V2, l12comb,spec12comb,l34comb,spec34comb,lambdacomb_1dspc=lall,fluxcomb_1dspc=fall
;lalljan=lall
;falljan=fall
;save,/variables,FILENAME='/Users/jgroh/espectros/etc_10830_spec_onstar_jan09.sav'
;restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_jan09.sav'
;
;***********************************************************************************
;                                 FEB 2009
;***********************************************************************************  
;ZE_CRIRES_SPEC_COMBINE_V2, '2009feb09_1087_1','2009feb09_1090_1',l1,spec1
;ZE_CRIRES_SPEC_COMBINE_V2, '2009feb09_1087_2','2009feb09_1090_2',l2,spec2
;ZE_CRIRES_SPEC_COMBINE_V2, '2009feb09_1087_3','2009feb09_1090_3',l3,spec3
;ZE_CRIRES_SPEC_COMBINE_V2, '2009feb09_1087_4','2009feb09_1090_4',l4,spec4
;;
;ZE_1DSPEC_COMBINE_V2, l1,spec1,l2,spec2,lambdacomb_1dspc=l12comb,fluxcomb_1dspc=spec12comb
;ZE_1DSPEC_COMBINE_V2, l3,spec3,l4,spec4,lambdacomb_1dspc=l34comb,fluxcomb_1dspc=spec34comb
;;
;ZE_1DSPEC_COMBINE_V2, l12comb,spec12comb,l34comb,spec34comb,lambdacomb_1dspc=lall,fluxcomb_1dspc=fall
;lallfeb=lall
;fallfeb=fall
;save,/variables,FILENAME='/Users/jgroh/espectros/etc_10830_spec_onstar_feb09.sav'

;restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_feb09.sav'
;
;***********************************************************************************
;                                 APR 2009
;***********************************************************************************  
;ZE_CRIRES_SPEC_COMBINE_V2, '2009apr03_1087_1','2009apr03_1090_1',l1,spec1
;ZE_CRIRES_SPEC_COMBINE_V2, '2009apr03_1087_2','2009apr03_1090_2',l2,spec2
;ZE_CRIRES_SPEC_COMBINE_V2, '2009apr03_1087_3','2009apr03_1090_3',l3,spec3
;ZE_CRIRES_SPEC_COMBINE_V2, '2009apr03_1087_4','2009apr03_1090_4',l4,spec4
;;
;ZE_1DSPEC_COMBINE_V2, l1,spec1,l2,spec2,lambdacomb_1dspc=l12comb,fluxcomb_1dspc=spec12comb
;ZE_1DSPEC_COMBINE_V2, l3,spec3,l4,spec4,lambdacomb_1dspc=l34comb,fluxcomb_1dspc=spec34comb
;;
;ZE_1DSPEC_COMBINE_V2, l12comb,spec12comb,l34comb,spec34comb,lambdacomb_1dspc=lall,fluxcomb_1dspc=fall
;lallapr=lall
;fallapr=fall
;save,/variables,FILENAME='/Users/jgroh/espectros/etc_10830_spec_onstar_apr09.sav'
;restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_apr09.sav'

restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_may08.sav'
restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_norm_may08.sav'
line_norm,lallmay,fallmay,fallmayn,normmay,xnodesmay,ynodesmay
;shifting by +24.77 km/s to correct for crude wavecal
fallmayn=ZE_SHIFT_SPECTRA_VEL(lallmay,fallmayn,-11.5)


save,lallmay,fallmayn,normmay,xnodesmay,ynodesmay,FILENAME='/Users/jgroh/espectros/etc_10830_spec_onstar_norm_may08.sav'

restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_dec08.sav'
restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_norm_dec08.sav'
line_norm,lalldec,falldec,falldecn,normdec,xnodesdec,ynodesdec
;shifting by +24.77 km/s to correct for crude wavecal
falldecn=ZE_SHIFT_SPECTRA_VEL(lalldec,falldecn,24.77)
save,lalldec,falldecn,normdec,xnodesdec,ynodesdec,FILENAME='/Users/jgroh/espectros/etc_10830_spec_onstar_norm_dec08.sav'

restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_jan09.sav'
restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_norm_jan09.sav'
line_norm,lalljan,falljan,falljann,normjan,xnodesjan,ynodesjan
save,lalljan,falljann,normjan,xnodesjan,ynodesjan,FILENAME='/Users/jgroh/espectros/etc_10830_spec_onstar_norm_jan09.sav'

restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_feb09.sav'
restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_norm_feb09.sav'
line_norm,lallfeb,fallfeb,fallfebn,normfeb,xnodesfeb,ynodesfeb
save,lallfeb,fallfebn,normfeb,xnodesfeb,ynodesfeb,FILENAME='/Users/jgroh/espectros/etc_10830_spec_onstar_norm_feb09.sav'

restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_apr09.sav'
restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_norm_apr09.sav'
line_norm,lallapr,fallapr,fallaprn,normapr,xnodesapr,ynodesapr
save,lallapr,fallaprn,normapr,xnodesapr,ynodesapr,FILENAME='/Users/jgroh/espectros/etc_10830_spec_onstar_norm_apr09.sav'

restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_norm_jan09.sav'
;lineplot,lalljan,falljann

restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_norm_feb09.sav'
;lineplot,lallfeb,fallfebn

restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_norm_apr09.sav'
nsigma=1.
bw=3.

ZE_SIGMA_FILTER_1D,fallaprn,bw,nsigma,fallaprn
;lineplot,lallapr,fallaprn
save,/variables,FILENAME='/Users/jgroh/espectros/etc_10830_spec_onstar_all.sav'
;lineplot,ZE_LAMBDA_TO_VEL(lallmay,10833.0),fallmayn
;lineplot,ZE_LAMBDA_TO_VEL(lalldec,10833.0),falldecn
;lineplot,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann
;lineplot,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn
;lineplot,ZE_LAMBDA_TO_VEL(lallapr,10833.0),fallaprn

dir='/Users/jgroh/espectros/etacar/'
dirtemp='/Users/jgroh/temp/'
;ZE_WRITE_SPECTRA_COL_VEC,dir+'etc_crires_10830_2009jan_onstar_merge_hel.txt',lalljan,falljann
;ZE_WRITE_SPECTRA_COL_VEC,dir+'etc_crires_10830_2009feb_onstar_merge_hel.txt',lallfeb,fallfebn
;ZE_WRITE_SPECTRA_COL_VEC,dir+'etc_crires_10830_2009apr_onstar_merge_hel.txt',lallapr,fallaprn

xwindowsize=900.*1  ;window size in x
ywindowsize=760.*1  ; window size in y
ticklen = 25.
!x.ticklen = ticklen/ywindowsize
!y.ticklen = ticklen/xwindowsize
;set_plot,'ps'
;LOADCT,0,/SILENT
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;!X.THICK=3.5
;!Y.THICK=3.5
;!P.THICK=3.5
;!P.CHARTHICK=3.5
;!P.CHARSIZE=2.0
;xmin=10756
;xmax=10892
;lambda0=10833.0
;;device,/close
;device,filename=dirtemp+'etc_crires_10830_may_dec_jan_2009.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
;plot,lalljan,falljann,XRANGE=[xmin,xmax],yrange=[0,6.1],XTITLE='Heliocentric vacuum wavelength (Angstrom)', YTITLE='Normalized flux',$
;/nodata,XTICKFORMAT='(F7.1)',xstyle=9,ystyle=1,Position=[0.16, 0.09, 0.95, 0.78*xwindowsize/ywindowsize],XTICKINTERVAL=40.
;plots,lallmay,fallmayn,noclip=0,color=FSC_COLOR('dark green'),linestyle=2
;plots,lalljan,falljann,noclip=0,color=FSC_COLOR('black'),linestyle=0
;plots,lalldec,falldecn,noclip=0,color=FSC_COLOR('purple'),linestyle=3
;AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='heliocentric velocity (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(xmin,lambda0),ZE_LAMBDA_TO_VEL(xmax,lambda0)]
;
;device,/close
;
;LOADCT,0,/SILENT
;!P.Background = fsc_color('white')
;!P.Color = fsc_color('black')
;!X.THICK=3.5
;!Y.THICK=3.5
;!P.THICK=3.5
;!P.CHARTHICK=3.5
;!P.CHARSIZE=2.0
;xmin=10756
;xmax=10892
;lambda0=10833.0
;;device,/close
;device,filename=dirtemp+'etc_crires_10830_jan_feb_apr_2009.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
;plot,lalljan,falljann,XRANGE=[xmin,xmax],yrange=[0,6.1],XTITLE='Heliocentric vacuum wavelength (Angstrom)', YTITLE='Normalized flux',$
;/nodata,XTICKFORMAT='(F7.1)',xstyle=9,ystyle=1,Position=[0.16, 0.09, 0.95, 0.78*xwindowsize/ywindowsize],XTICKINTERVAL=40.
;;plots,lalldec,falldecn,noclip=0,color=FSC_COLOR('dark green'),linestyle=4
;plots,lalljan,falljann,noclip=0,color=FSC_COLOR('black'),linestyle=0
;plots,lallfeb,fallfebn,noclip=0,color=FSC_COLOR('red'),linestyle=2
;plots,lallapr,fallaprn,noclip=0,color=FSC_COLOR('blue'),linestyle=3
;AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='heliocentric velocity (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(xmin,lambda0),ZE_LAMBDA_TO_VEL(xmax,lambda0)]
;
;device,/close
!p.multi=[0, 1, 2, 0, 0]
set_plot,'ps'
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!X.THICK=3.5
!Y.THICK=3.5
!P.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=2.0
!p.multi=[0, 1, 2, 0, 0]
xmin=-2100
xmax=1600
lambda0=10833.0
device,/close
device,filename=dirtemp+'etc_crires_10830_may08_untilapr09_twopanels.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
;bottom panel
plot,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn,XRANGE=[xmin,xmax],yrange=[-0.2,6.1],XTITLE='heliocentric velocity (km/s)', YTITLE='Normalized flux',$
/nodata,XTICKFORMAT='(I5)',xstyle=1,ystyle=1,Position=[0.13, 0.10, 0.95,0.52 ];*xwindowsize/ywindowsize];,XTICKINTERVAL=40.
plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,noclip=0,color=FSC_COLOR('black'),linestyle=0
plots,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn,noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,ZE_LAMBDA_TO_VEL(lallapr,10833.0),fallaprn,noclip=0,color=FSC_COLOR('blue'),linestyle=3
;legends
legxi=-1900
legxf=-1700
legyi=5.
legyf=legyi
legxt=-1630
legyt=4.9
sp=0.5
tsp=0.5
tl=3.5
cl=1.6
plots, [legxi,legxf],[legyi,legyf],color=fsc_color('black'),thick=tl
xyouts,legxt,legyt,'2009 Jan 07',alignment=0,orientation=0,charsize=cl
plots, [legxi,legxf],[legyi-sp,legyf-sp],color=fsc_color('red'),linestyle=2,thick=tl
xyouts,legxt,legyt-1*tsp,'2009 Feb 09',alignment=0,orientation=0,charsize=cl
plots, [legxi,legxf],[legyi-2*sp,legyf-2*sp],color=fsc_color('blue'),linestyle=3,thick=tl
xyouts,legxt,legyt-2*tsp,'2009 Apr 03',alignment=0,orientation=0,charsize=cl



;top panel
plot,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,XRANGE=[xmin,xmax],yrange=[-0.2,6.1],XTITLE='', YTITLE='Normalized flux',$
/nodata,XTICKFORMAT='(A2)',xstyle=1,ystyle=1,Position=[0.13, 0.52, 0.95, 0.94];,XTICKINTERVAL=40.
plots,ZE_LAMBDA_TO_VEL(lallmay,10833.0),fallmayn,noclip=0,color=FSC_COLOR('dark green'),linestyle=2
plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,noclip=0,color=FSC_COLOR('black'),linestyle=0
plots,ZE_LAMBDA_TO_VEL(lalldec,10833.0),falldecn,noclip=0,color=FSC_COLOR('purple'),linestyle=3
;legends

plots, [legxi,legxf],[legyi,legyf],color=fsc_color('dark green'),thick=tl,linestyle=2
xyouts,legxt,legyt,'2008 May 05',alignment=0,orientation=0,charsize=cl
plots, [legxi,legxf],[legyi-sp,legyf-sp],color=fsc_color('purple'),linestyle=3,thick=tl
xyouts,legxt,legyt-1*tsp,'2008 Dec 26',alignment=0,orientation=0,charsize=cl
plots, [legxi,legxf],[legyi-2*sp,legyf-2*sp],color=fsc_color('black'),linestyle=0,thick=tl
xyouts,legxt,legyt-2*tsp,'2009 Jan 07',alignment=0,orientation=0,charsize=cl

device,/close

xmin=-2100
xmax=50

device,filename=dirtemp+'etc_crires_10830_may08_untilapr09_twopanels_zoom_abs.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
;bottom panel
plot,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn,XRANGE=[xmin,xmax],yrange=[-0.00,1.4],XTITLE='heliocentric velocity (km/s)', YTITLE='Normalized flux',$
/nodata,XTICKFORMAT='(I5)',xstyle=1,ystyle=1,Position=[0.13, 0.10, 0.95,0.52 ];*xwindowsize/ywindowsize];,XTICKINTERVAL=40.
plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,noclip=0,color=FSC_COLOR('black'),linestyle=0
plots,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn,noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,ZE_LAMBDA_TO_VEL(lallapr,10833.0),fallaprn,noclip=0,color=FSC_COLOR('blue'),linestyle=3
;legends
legxi=-1900
legxf=-1700
legyi=1.31
legyf=legyi
legxt=-1650
legyt=1.28
sp=0.1
tsp=0.1
tl=3.5
cl=1.6
plots, [legxi,legxf],[legyi,legyf],color=fsc_color('black'),thick=tl
xyouts,legxt,legyt,'2009 Jan 07',alignment=0,orientation=0,charsize=cl
plots, [legxi,legxf],[legyi-sp,legyf-sp],color=fsc_color('red'),linestyle=2,thick=tl
xyouts,legxt,legyt-1*tsp,'2009 Feb 09',alignment=0,orientation=0,charsize=cl
plots, [legxi,legxf],[legyi-2*sp,legyf-2*sp],color=fsc_color('blue'),linestyle=3,thick=tl
xyouts,legxt,legyt-2*tsp,'2009 Apr 03',alignment=0,orientation=0,charsize=cl



;top panel
plot,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,XRANGE=[xmin,xmax],yrange=[-0.00,1.4],XTITLE='', YTITLE='Normalized flux',$
/nodata,XTICKFORMAT='(A2)',xstyle=1,ystyle=1,Position=[0.13, 0.52, 0.95, 0.94];,XTICKINTERVAL=40.
plots,ZE_LAMBDA_TO_VEL(lallmay,10833.0),fallmayn,noclip=0,color=FSC_COLOR('dark green'),linestyle=2
plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,noclip=0,color=FSC_COLOR('black'),linestyle=0
plots,ZE_LAMBDA_TO_VEL(lalldec,10833.0),falldecn,noclip=0,color=FSC_COLOR('purple'),linestyle=3
;legends

plots, [legxi,legxf],[legyi,legyf],color=fsc_color('dark green'),thick=tl,linestyle=2
xyouts,legxt,legyt,'2008 May 05',alignment=0,orientation=0,charsize=cl
plots, [legxi,legxf],[legyi-sp,legyf-sp],color=fsc_color('purple'),linestyle=3,thick=tl
xyouts,legxt,legyt-1*tsp,'2008 Dec 26',alignment=0,orientation=0,charsize=cl
plots, [legxi,legxf],[legyi-2*sp,legyf-2*sp],color=fsc_color('black'),linestyle=0,thick=tl
xyouts,legxt,legyt-2*tsp,'2009 Jan 07',alignment=0,orientation=0,charsize=cl




device,/close
!p.multi=[0, 0, 0, 0, 0]
!X.THICK=6.5
!Y.THICK=6.5
!P.THICK=6.5
!P.CHARTHICK=6.5
!P.CHARSIZE=2.0
!p.multi=0
xmin=-2100
xmax=-150
device,filename=dirtemp+'etc_crires_10830_may08_untilapr09_twopanels_zoom_abs_vtalk.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
;bottom panel
!p.multi=[0, 0, 0, 0, 0]
plot,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn,XRANGE=[xmin,xmax],yrange=[-0.00,1.4],XTITLE='heliocentric velocity (km/s)', YTITLE='Normalized flux',$
/nodata,XTICKFORMAT='(I5)',xstyle=1,ystyle=1,Position=[0.13, 0.10, 0.95,0.52 ];*xwindowsize/ywindowsize];,XTICKINTERVAL=40.
plots,ZE_LAMBDA_TO_VEL(lallmay,10833.0),fallmayn,noclip=0,color=FSC_COLOR('black'),linestyle=0
plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,noclip=0,color=FSC_COLOR('blue'),linestyle=0
;plots,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn,noclip=0,color=FSC_COLOR('orange'),linestyle=0
plots,ZE_LAMBDA_TO_VEL(lallapr,10833.0),fallaprn,noclip=0,color=FSC_COLOR('red'),linestyle=0
;legends
legxi=-1900
legxf=-1700
legyi=1.31
legyf=legyi
legxt=-1650
legyt=1.28
sp=0.1
tsp=0.1
tl=3.5
cl=1.6
;plots, [legxi,legxf],[legyi,legyf],color=fsc_color('black'),thick=tl
;xyouts,legxt,legyt,'2009 Jan 07',alignment=0,orientation=0,charsize=cl
;plots, [legxi,legxf],[legyi-sp,legyf-sp],color=fsc_color('red'),linestyle=2,thick=tl
;xyouts,legxt,legyt-1*tsp,'2009 Feb 09',alignment=0,orientation=0,charsize=cl
;plots, [legxi,legxf],[legyi-2*sp,legyf-2*sp],color=fsc_color('blue'),linestyle=3,thick=tl
;xyouts,legxt,legyt-2*tsp,'2009 Apr 03',alignment=0,orientation=0,charsize=cl



;top panel
;plot,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,XRANGE=[xmin,xmax],yrange=[-0.00,1.4],XTITLE='', YTITLE='Normalized flux',$
;/nodata,XTICKFORMAT='(A2)',xstyle=1,ystyle=1,Position=[0.13, 0.52, 0.95, 0.94];,XTICKINTERVAL=40.
;plots,ZE_LAMBDA_TO_VEL(lallmay,10833.0),fallmayn,noclip=0,color=FSC_COLOR('dark green'),linestyle=2
;plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,noclip=0,color=FSC_COLOR('black'),linestyle=0
;plots,ZE_LAMBDA_TO_VEL(lalldec,10833.0),falldecn,noclip=0,color=FSC_COLOR('purple'),linestyle=3
;;legends
;
;plots, [legxi,legxf],[legyi,legyf],color=fsc_color('black'),thick=tl
;xyouts,legxt,legyt,'2009 Jan 07',alignment=0,orientation=0,charsize=cl
;plots, [legxi,legxf],[legyi-sp,legyf-sp],color=fsc_color('purple'),linestyle=3,thick=tl
;xyouts,legxt,legyt-1*tsp,'2008 Dec 26',alignment=0,orientation=0,charsize=cl
;plots, [legxi,legxf],[legyi-2*sp,legyf-2*sp],color=fsc_color('dark green'),linestyle=2,thick=tl
;xyouts,legxt,legyt-2*tsp,'2008 May 05',alignment=0,orientation=0,charsize=cl


device,/close

lambda_val=10830.
resolving_power=8000.
res=lambda_val/resolving_power

;shifting the model spectrum by the systemic velocity
ZE_SPEC_CNVL,lalljan,falljann,res,lambda_val,fluxcnvl=falljanncnvl

!p.multi=[0, 0, 0, 0, 0]
!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=1.4
!Y.charsize=1.4
!X.charsize=1.4
!P.THICK=11
!X.THiCK=11
!Y.THICK=11
!P.CHARTHICK=8
!P.FONT=-1
!p.multi=0
xmin=-2100
xmax=50
device,filename=dirtemp+'etc_crires_10830_may08_untilapr09_twopanels_zoom_abs_vtalk_compaugusto.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
;bottom panel
!p.multi=[0, 0, 0, 0, 0]
plot,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn,XRANGE=[xmin,xmax],yrange=[-0.00,1.4],XTITLE='heliocentric velocity (km/s)', YTITLE='Normalized flux',$
/nodata,XTICKFORMAT='(I5)',xstyle=1,ystyle=1,Position=[0.13, 0.10, 0.95,0.98 ];*xwindowsize/ywindowsize];,XTICKINTERVAL=40.
;plots,ZE_LAMBDA_TO_VEL(lallmay,10833.0),fallmayn,noclip=0,color=FSC_COLOR('black'),linestyle=0
plots,data911[0,*], data911[1,*],noclip=0,color=FSC_COLOR('red'),linestyle=0
plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljanncnvl,noclip=0,color=FSC_COLOR('blue'),linestyle=0
plots,ZE_LAMBDA_TO_VEL(lambda09,10833.0)+15.78,flux09,noclip=0,color=FSC_COLOR('black'),linestyle=2
;plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),((falljanncnvl-1.)*0.7)+1,noclip=0,color=FSC_COLOR('red'),linestyle=3
;plots,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn,noclip=0,color=FSC_COLOR('orange'),linestyle=0
;plots,ZE_LAMBDA_TO_VEL(lallapr,10833.0),fallaprn,noclip=0,color=FSC_COLOR('red'),linestyle=0

;legends
legxi=-1900
legxf=-1700
legyi=1.31
legyf=legyi
legxt=-1650
legyt=1.295
sp=0.05
tsp=0.05
tl=11
cl=1.6
plots, [legxi,legxf],[legyi,legyf],color=fsc_color('red'),thick=tl,linestyle=0
xyouts,legxt,legyt,'OPD/LNA '+TEXTOIDL('\phi=10.998 (2003 Jun 24)'),alignment=0,orientation=0,charsize=cl,color=fsc_color('red')
plots, [legxi,legxf],[legyi-2*sp,legyf-2*sp],color=fsc_color('blue'),linestyle=0,thick=tl
xyouts,legxt,legyt-2*tsp,'VLT/CRIRES '+TEXTOIDL('\phi=11.998 (2009 Jan 08)'),color=fsc_color('blue'),alignment=0,orientation=0,charsize=cl
plots, [legxi,legxf],[legyi-1*sp,legyf-1*sp],color=fsc_color('black'),linestyle=2,thick=tl
xyouts,legxt,legyt-1*tsp,'OPD/LNA '+TEXTOIDL('\phi=11.998 (2009 Jan 08)'),alignment=0,orientation=0,charsize=cl,color=fsc_color('black')



;top panel
;plot,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,XRANGE=[xmin,xmax],yrange=[-0.00,1.4],XTITLE='', YTITLE='Normalized flux',$
;/nodata,XTICKFORMAT='(A2)',xstyle=1,ystyle=1,Position=[0.13, 0.52, 0.95, 0.94];,XTICKINTERVAL=40.
;plots,ZE_LAMBDA_TO_VEL(lallmay,10833.0),fallmayn,noclip=0,color=FSC_COLOR('dark green'),linestyle=2
;plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,noclip=0,color=FSC_COLOR('black'),linestyle=0
;plots,ZE_LAMBDA_TO_VEL(lalldec,10833.0),falldecn,noclip=0,color=FSC_COLOR('purple'),linestyle=3
;;legends
;
;plots, [legxi,legxf],[legyi,legyf],color=fsc_color('black'),thick=tl
;xyouts,legxt,legyt,'2009 Jan 07',alignment=0,orientation=0,charsize=cl
;plots, [legxi,legxf],[legyi-sp,legyf-sp],color=fsc_color('purple'),linestyle=3,thick=tl
;xyouts,legxt,legyt-1*tsp,'2008 Dec 26',alignment=0,orientation=0,charsize=cl
;plots, [legxi,legxf],[legyi-2*sp,legyf-2*sp],color=fsc_color('dark green'),linestyle=2,thick=tl
;xyouts,legxt,legyt-2*tsp,'2008 May 05',alignment=0,orientation=0,charsize=cl

device,/close

restore,'/Users/jgroh/espectros/etc_2070_spec_onstar_jan09.sav'
!p.multi=0
xmin=-1900
xmax=1600
lambda0=20586.9

device,filename=dirtemp+'etc_crires_2070_jan09_onstar.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
!p.multi=0
;bottom panel
plot,ZE_LAMBDA_TO_VEL(lalljan,20586.9),falljan,XRANGE=[xmin,xmax],yrange=[0.0,1.85],XTITLE='heliocentric velocity (km/s)', YTITLE='Normalized flux',$
/nodata,XTICKFORMAT='(I5)',xstyle=1,ystyle=1,Position=[0.13, 0.10, 0.95,0.92 ];*xwindowsize/ywindowsize];,XTICKINTERVAL=40.
plots,ZE_LAMBDA_TO_VEL(lalljan,20586.9),falljan/3695.,noclip=0,color=FSC_COLOR('black'),linestyle=0
;plots,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn,noclip=0,color=FSC_COLOR('red'),linestyle=2
;plots,ZE_LAMBDA_TO_VEL(lallapr,10833.0),fallaprn,noclip=0,color=FSC_COLOR('blue'),linestyle=3
;legends
legxi=-1800
legxf=-1600
legyi=1.2
legyf=legyi
legxt=-1530
legyt=1.185
sp=0.5
tsp=0.5
tl=3.5
cl=1.6
plots, [legxi,legxf],[legyi,legyf],color=fsc_color('black'),thick=tl
xyouts,legxt,legyt,'2009 Jan 07',alignment=0,orientation=0,charsize=cl
;plots, [legxi,legxf],[legyi-sp,legyf-sp],color=fsc_color('red'),linestyle=2,thick=tl
;xyouts,legxt,legyt-1*tsp,'2009 Feb 09',alignment=0,orientation=0,charsize=cl
;plots, [legxi,legxf],[legyi-2*sp,legyf-2*sp],color=fsc_color('blue'),linestyle=3,thick=tl
;xyouts,legxt,legyt-2*tsp,'2009 Apr 03',alignment=0,orientation=0,charsize=cl

device,/close

!p.multi=0
xmin=-1900
xmax=1600
lambda0=20586.9

device,filename=dirtemp+'etc_crires_1080_2070_jan09_onstar_comp.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
!p.multi=0
;bottom panel
plot,ZE_LAMBDA_TO_VEL(lalljan,20586.9),falljan,XRANGE=[xmin,xmax],yrange=[0.0,2.10],XTITLE='heliocentric velocity (km/s)', YTITLE='Normalized flux',$
/nodata,XTICKFORMAT='(I5)',xstyle=1,ystyle=1,Position=[0.13, 0.10, 0.95,0.98 ];*xwindowsize/ywindowsize];,XTICKINTERVAL=40.
plots,ZE_LAMBDA_TO_VEL(lalljan,20586.9),falljan/3695.,noclip=0,color=FSC_COLOR('black'),linestyle=2
restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_norm_jan09.sav'
plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,noclip=0,color=FSC_COLOR('blue'),linestyle=0
;plots,ZE_LAMBDA_TO_VEL(lallapr,10833.0),fallaprn,noclip=0,color=FSC_COLOR('blue'),linestyle=3
;legends
legxi=-1800
legxf=-1600
legyi=1.7
legyf=legyi
legxt=-1530
legyt=1.685
sp=0.1
tsp=0.1
tl=11
cl=1.6
plots, [legxi,legxf],[legyi,legyf],color=fsc_color('black'),thick=tl,linestyle=2
xyouts,legxt,legyt,'He I 20587 '+TEXTOIDL('\phi=11.998'),alignment=0,orientation=0,charsize=cl
plots, [legxi,legxf],[legyi-sp,legyf-sp],color=fsc_color('blue'),linestyle=0,thick=tl
xyouts,legxt,legyt-1*tsp,'He I 10833 '+TEXTOIDL('\phi=11.998'),alignment=0,orientation=0,charsize=cl
;plots, [legxi,legxf],[legyi-2*sp,legyf-2*sp],color=fsc_color('blue'),linestyle=3,thick=tl
;xyouts,legxt,legyt-2*tsp,'2009 Apr 03',alignment=0,orientation=0,charsize=cl

device,/close

xsize=900.*1  ;window size in x
ysize=250.*1  ; window size in y
width=20
PositionPlot=[0.08, 0.18, 0.95, 0.96]

legypos_rel=0.4e-12
legxpos=-400

xmin=-2250
xmax=200

yi=0
yf=6

scale=1
;making psplots
!p.multi=[0, 1, 2]

!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=1.4
!Y.charsize=1.4
!X.charsize=1.4
!P.THICK=11
!X.THiCK=11
!Y.THICK=11
!P.CHARTHICK=8
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

ticklen = 17.
!x.ticklen = ticklen/ysize
!y.ticklen = ticklen/xsize

;legends
legxi=-1900
legxf=-1700
legyi=0.51
legyf=legyi
legxt=-1650
legyt=0.48
sp=0.1
tsp=0.1
tl=3.5
cl=1.6

device,filename=dirtemp+'etc_crires_10830_may08_untiljan09_onelargepanel_zoom_abs.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
;!P.CHARTHICK=3.5
;!P.CHARSIZE=1.4
;!Y.charsize=2.3
;!X.charsize=2.3
;top panel
plot,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,XRANGE=[xmin,xmax],yrange=[0.00,1.4],XTITLE='Heliocentric velocity (km/s)', YTITLE='Normalized flux',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot;,XTICKINTERVAL=40.
ze_colorfill,low=-2000,high=-750,ymin=cspline(ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,ZE_LAMBDA_TO_VEL(lallmay,10833.0)), ymax=fallmayn,$
x=ZE_LAMBDA_TO_VEL(lallmay,10833.0),yvals=falljann
plots,ZE_LAMBDA_TO_VEL(lallmay,10833.0),fallmayn,noclip=0,color=FSC_COLOR('purple'),linestyle=0
plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,noclip=0,color=FSC_COLOR('black'),linestyle=0
plots,ZE_LAMBDA_TO_VEL(lalldec,10833.0),falldecn,noclip=0,color=FSC_COLOR('orange'),linestyle=0
;legends

plots, [legxi,legxf],[legyi,legyf],color=fsc_color('purple'),linestyle=0
xyouts,legxt,legyt,TEXTOIDL('\phi=11.875 (2008 May 05)'),alignment=0,orientation=0,charsize=cl,color=FSC_COLOR('purple')
plots, [legxi,legxf],[legyi-sp,legyf-sp],color=fsc_color('orange'),linestyle=0
xyouts,legxt,legyt-1*tsp,TEXTOIDL('\phi=11.991 (2008 Dec 26)'),alignment=0,orientation=0,charsize=cl,color=FSC_COLOR('orange')
plots, [legxi,legxf],[legyi-2*sp,legyf-2*sp],color=fsc_color('black'),linestyle=0
xyouts,legxt,legyt-2*tsp,TEXTOIDL('\phi=11.998 (2009 Jan 08)'),alignment=0,orientation=0,charsize=cl,color=FSC_COLOR('black')
device,/close

device,filename=dirtemp+'etc_crires_10830_jan09_untilapr09_onelargepanel_zoom_abs.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn,XRANGE=[xmin,xmax],yrange=[0.0,1.4],XTITLE='Heliocentric velocity (km/s)', YTITLE='Normalized flux',$
/nodata,XTICKFORMAT='(I5)',xstyle=1,ystyle=1,Position=PositionPlot;*xwindowsize/ywindowsize];,XTICKINTERVAL=40.
ze_colorfill,low=-2000,high=-750,ymin=cspline(ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,ZE_LAMBDA_TO_VEL(lallapr,10833.0)), ymax=fallaprn,$
x=ZE_LAMBDA_TO_VEL(lallapr,10833.0),yvals=falljann
plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,noclip=0,color=FSC_COLOR('black'),linestyle=0
plots,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn,noclip=0,color=FSC_COLOR('red'),linestyle=0
plots,ZE_LAMBDA_TO_VEL(lallapr,10833.0),fallaprn,noclip=0,color=FSC_COLOR('blue'),linestyle=0

;legends

plots, [legxi,legxf],[legyi,legyf],color=fsc_color('black')
xyouts,legxt,legyt,TEXTOIDL('\phi=11.998 (2009 Jan 08)'),alignment=0,orientation=0,charsize=cl
plots, [legxi,legxf],[legyi-sp,legyf-sp],color=fsc_color('red'),linestyle=0
xyouts,legxt,legyt-1*tsp,TEXTOIDL('\phi=12.014 (2009 Feb 09)'),alignment=0,orientation=0,charsize=cl,color=FSC_COLOR('red')
plots, [legxi,legxf],[legyi-2*sp,legyf-2*sp],color=fsc_color('blue'),linestyle=0
xyouts,legxt,legyt-2*tsp,TEXTOIDL('\phi=12.041 (2009 Apr 03)'),alignment=0,orientation=0,charsize=cl,color=FSC_COLOR('blue')
device,/close

device,filename=dirtemp+'etc_crires_10830_jan09_comp_hst_stis_onelargepanel_zoom_abs.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,XRANGE=[xmin,xmax],yrange=[0.0,1.4],XTITLE='Heliocentric velocity (km/s)', YTITLE='Normalized flux',$
/nodata,XTICKFORMAT='(I5)',xstyle=1,ystyle=1,Position=PositionPlot;*xwindowsize/ywindowsize];,XTICKINTERVAL=40.
plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),((falljann-1.)*1.3)+1.,noclip=0,color=FSC_COLOR('black'),linestyle=0
;plots,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn,noclip=0,color=FSC_COLOR('red'),linestyle=0
;plots,ZE_LAMBDA_TO_VEL(lallapr,10833.0),fallaprn,noclip=0,color=FSC_COLOR('blue'),linestyle=0
;plots,ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,1393.76),flux_22jun03_e140m/(3.2e-12),color=FSC_COLOR('red'),noclip=0

;legends

plots, [legxi,legxf],[legyi,legyf],color=fsc_color('black')
xyouts,legxt,legyt,'2009 Jan 07',alignment=0,orientation=0,charsize=cl
plots, [legxi,legxf],[legyi-sp,legyf-sp],color=fsc_color('red'),linestyle=0
xyouts,legxt,legyt-1*tsp,'2009 Feb 09',alignment=0,orientation=0,charsize=cl,color=FSC_COLOR('red')
plots, [legxi,legxf],[legyi-2*sp,legyf-2*sp],color=fsc_color('blue'),linestyle=0
xyouts,legxt,legyt-2*tsp,'2009 Apr 03',alignment=0,orientation=0,charsize=cl,color=FSC_COLOR('blue')
device,/close

plotxi=0.08
plotxf=0.96
PositionPlot1=[0.06, 0.18, 0.25, 0.96]
PositionPlot2=[0.31, 0.18, 0.50, 0.96]
PositionPlot3=[0.56, 0.18, 0.75, 0.96]
PositionPlot4=[0.80, 0.18, 0.99, 0.96]

device,filename=dirtemp+'etc_crires_10830_may_dec_jan_feb_09_separate_panels_for_sph_zoom_abs.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
!p.multi=[0, 4, 1, 0, 0]
plot,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,XRANGE=[xmin,xmax],yrange=[0.0,1.4],XTITLE='Heliocentric velocity (km/s)', YTITLE='Normalized flux',$
/nodata,XTICKFORMAT='(I5)',xstyle=1,ystyle=1,Position=PositionPlot1;*xwindowsize/ywindowsize];,XTICKINTERVAL=40.
plots,ZE_LAMBDA_TO_VEL(lallmay,10833.0),fallmayn,noclip=0,color=FSC_COLOR('black'),linestyle=0

plot,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,XRANGE=[xmin,xmax],yrange=[0.0,1.4],XTITLE='Heliocentric velocity (km/s)', YTITLE='',$
/nodata,XTICKFORMAT='(I5)',YTICKFORMAT='(A2)',xstyle=1,ystyle=1,Position=PositionPlot2;*xwindowsize/ywindowsize];,XTICKINTERVAL=40.
plots,ZE_LAMBDA_TO_VEL(lalldec,10833.0),falldecn,noclip=0,color=FSC_COLOR('black'),linestyle=0

plot,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,XRANGE=[xmin,xmax],yrange=[0.0,1.4],XTITLE='Heliocentric velocity (km/s)', YTITLE='',$
/nodata,XTICKFORMAT='(I5)',YTICKFORMAT='(A2)',xstyle=1,ystyle=1,Position=PositionPlot3;*xwindowsize/ywindowsize];,XTICKINTERVAL=40.
plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,noclip=0,color=FSC_COLOR('black'),linestyle=0

plot,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljann,XRANGE=[xmin,xmax],yrange=[0.0,1.4],XTITLE='Heliocentric velocity (km/s)', YTITLE='',$
/nodata,XTICKFORMAT='(I5)',YTICKFORMAT='(A2)',xstyle=1,ystyle=1,Position=PositionPlot4;*xwindowsize/ywindowsize];,XTICKINTERVAL=40.
plots,ZE_LAMBDA_TO_VEL(lallfeb,10833.0),fallfebn,noclip=0,color=FSC_COLOR('black'),linestyle=0


;legends

;plots, [legxi,legxf],[legyi,legyf],color=fsc_color('black')
;xyouts,legxt,legyt,'2009 Jan 07',alignment=0,orientation=0,charsize=cl
;plots, [legxi,legxf],[legyi-sp,legyf-sp],color=fsc_color('red'),linestyle=0
;xyouts,legxt,legyt-1*tsp,'2009 Feb 09',alignment=0,orientation=0,charsize=cl,color=FSC_COLOR('red')
;plots, [legxi,legxf],[legyi-2*sp,legyf-2*sp],color=fsc_color('blue'),linestyle=0
;xyouts,legxt,legyt-2*tsp,'2009 Apr 03',alignment=0,orientation=0,charsize=cl,color=FSC_COLOR('blue')


device,/close

set_plot,'x'
!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0
!Y.charsize=0
!X.charsize=0
!P.THICK=0
!X.THiCK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.MULTI=0
!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0
!P.Background = fsc_color('white')

END