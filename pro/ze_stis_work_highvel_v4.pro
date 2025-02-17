;PRO ZE_STIS_WORK_HIGHVEL_V4
;v3 didn't use krister data;
;v4 uses krister data

;
;filename_04jul02='/Users/jgroh/data/hst/stis/etacar_from_john/star_04jul02'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_04jul02,lambda_04jul02,flux_04jul02,mask_04jul02
;
;
;filename_04jul02_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_04jul02_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_04jul02_e140m,lambda_04jul02_e140m,flux_04jul02_e140m,mask_04jul02_e140m
;
;filename_13feb03='/Users/jgroh/data/hst/stis/etacar_from_john/star_13feb03'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_13feb03,lambda_13feb03,flux_13feb03,mask_13feb03
;
;filename_13feb03_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_13feb03_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_13feb03_e140m,lambda_13feb03_e140m,flux_13feb03_e140m,mask_13feb03_e140m
;
;filename_26may03_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_26may03_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_26may03_e140m,lambda_26may03_e140m,flux_26may03_e140m,mask_26may03_e140m
;
;filename_01jun03_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_01jun03_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_01jun03_e140m,lambda_01jun03_e140m,flux_01jun03_e140m,mask_01jun03_e140m
;
;filename_01jun03='/Users/jgroh/data/hst/stis/etacar_from_john/star_01jun03'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_01jun03,lambda_01jun03,flux_01jun03,mask_01jun03
;
;filename_22jun03_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_22jun03_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_22jun03_e140m,lambda_22jun03_e140m,flux_22jun03_e140m,mask_22jun03_e140m
;
;filename_22jun03='/Users/jgroh/data/hst/stis/etacar_from_john/star_22jun03'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_22jun03,lambda_22jun03,flux_22jun03,mask_22jun03
;
;filename_05jul03_e140m='/Users/jgroh/data/hst/stis/etacar_from_john/kirst_hst/E140m/E140M_05jul03_OK.dat'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_05jul03_e140m,lambda_05jul03_e140m,flux_05jul03_e140m,mask_05jul03_e140m
;
;filename_05jul03='/Users/jgroh/data/hst/stis/etacar_from_john/star_05jul03'
;ZE_READ_STIS_DATA_FROM_JOHN,filename_05jul03,lambda_05jul03,flux_05jul03,mask_05jul03

restore,'/Users/jgroh/papers_groh/2010_etacar_highvel_aa/from_krister/E140M_04jul02_7p.var',/VERBOSE
lambda_04jul02_e140m_k=w
flux_04jul02_e140m_k=f

restore,'/Users/jgroh/papers_groh/2010_etacar_highvel_aa/from_krister/E140M_13feb03_7p.var',/VERBOSE
lambda_13feb03_e140m_k=w
flux_13feb03_e140m_k=f

restore,'/Users/jgroh/papers_groh/2010_etacar_highvel_aa/from_krister/E140M_01jun03_7p.var',/VERBOSE
lambda_01jun03_e140m_k=w
flux_01jun03_e140m_k=f

restore,'/Users/jgroh/papers_groh/2010_etacar_highvel_aa/from_krister/E140M_22jun03_7p.var',/VERBOSE
lambda_22jun03_e140m_k=w
flux_22jun03_e140m_k=f

restore,'/Users/jgroh/papers_groh/2010_etacar_highvel_aa/from_krister/E140M_29jul03_7p.var',/VERBOSE
lambda_29jul03_e140m_k=w
flux_29jul03_e140m_k=f

lambda_04jul02_e140m=lambda_04jul02_e140m_k
lambda_13feb03_e140m=lambda_13feb03_e140m_k
lambda_01jun03_e140m=lambda_01jun03_e140m_k
lambda_22jun03_e140m=lambda_22jun03_e140m_k
lambda_29jul03_e140m=lambda_29jul03_e140m_k

flux_04jul02_e140m=flux_04jul02_e140m_k
flux_13feb03_e140m=flux_13feb03_e140m_k
flux_01jun03_e140m=flux_01jun03_e140m_k
flux_22jun03_e140m=flux_22jun03_e140m_k
flux_29jul03_e140m=flux_29jul03_e140m_k

;RESCALING 04jul02 FLUX FROM KRISTER
flux_04jul02_e140m=flux_04jul02_e140m/1.27


lambda0=1334.5323

;lineplot,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m

flux_22jun03_e140mi=cspline(lambda_22jun03_e140m,flux_22jun03_e140m,lambda_01jun03_e140m)

xsize=900.*1  ;window size in x
ysize=560.*1  ; window size in y
PositionPlot=[0.13, 0.18, 0.95, 0.92]
PositionPlot1=[0.16, 0.53, 0.95, 0.92]
PositionPlot2=[0.16, 0.14, 0.95, 0.53]
set_plot,'ps'
;making psplots
!p.multi=[0, 1, 2]


!P.CHARSIZE=2.15
!Y.charsize=1.4
!X.charsize=1.4
!P.THICK=8
!X.THiCK=12
!Y.THICK=12
!P.CHARTHICK=10
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

;******************************************************
;     C II 1334-1335 HST/STIS MAMA spectrum, comparing no continuum-scaled and scaled data from 2003jun01 and 2003jun22
;******************************************************
lambda0=1334.5323
legxpos=1300
legoffset=0.4e-12
plotsym,1,3
offset=0.12
device,filename='/Users/jgroh/temp/etacar_hst_e140m_CII_1334_highvel_noscale_scale_comp.eps',/encapsulated,/color,bit=8,xsize=10*xsize/ysize,ysize=10,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m,xrange=[-2800,2600],yrange=[0,4.8e-12],XTITLE='', YTITLE='Normalized flux',$
/nodata,XTICKFORMAT='(A2)',xstyle=1,ystyle=1,Position=PositionPlot1,XTICKINTERVAL=2000
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,color=FSC_COLOR('red'),noclip=0
xyouts,-2650,4.4e-12,'a) C II 1334-1335 no scaling',charsize=2.0
xyouts,legxpos,4.4e-12,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,4.4e-12-legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')

plot,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m,xrange=[-2800,2600],yrange=[0,4.8e-12],XTITLE='Heliocentric velocity (km/s)', YTITLE='Normalized flux',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot2,XTICKINTERVAL=1000
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m*1.12,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,color=FSC_COLOR('red'),noclip=0
xyouts,-2650,4.4e-12,'b) C II 1334-1335 scaled',charsize=2.0
xyouts,legxpos,4.4e-12,'2003jun01 * 1.12',charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,4.4e-12-legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
device,/close

;******************************************************
;     C II 1334-1335 HST/STIS MAMA spectrum, comparing 2003jun01 and 2003jun22 data with a better zoom 
;******************************************************

xsize=900.*1  ;window size in x
ysize=250.*1  ; window size in y
width=20
PositionPlot=[0.14, 0.20, 0.978, 0.94]

!p.multi=0


!P.CHARSIZE=2.15
!Y.charsize=1.4
!X.charsize=1.4
!P.THICK=11
!X.THiCK=20
!Y.THICK=20
!P.CHARTHICK=10
!P.FONT=-1

ticklen=22.
!x.ticklen = ticklen/ysize
!y.ticklen = ticklen/(xsize)

legypos_rel=0.8e-12
legxpos=-400
labelxpos=-2850

ytickinterval_val=2e-12

xi=-3250
xf=600

yi=0
yf=3.1e-12
lambda0=1264.73
scale=1
device,filename='/Users/jgroh/temp/etacar_hst_e140m_SiII_1264_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)', YTITLE='Flux (erg/s/cm^2/A)',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m*scale,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,color=FSC_COLOR('red'),noclip=0
xyouts,labelxpos,yf-legypos_rel,'Si II 1264.73 scaled',charsize=2.7
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
device,/close

yi=0
yf=4.8e-12

lambda0=1334.5323
scale=1.12
scale04jul02=1.5
scale13feb03=1.08
scale05jul03=1.7
scale29jul03=2.0
device,filename='/Users/jgroh/temp/etacar_hst_e140m_CII_1334_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)', YTITLE=TEXTOIDL('Flux (erg/s/cm^2/A)'),$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000,title='Low-ionization UV resonance lines',YMINOR=3
ze_colorfill,low=-900,high=-580,ymin=cspline(ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0)), ymax=flux_04jul02_e140m*scale04jul02,$
x=ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),yvals=flux_22jun03_e140m
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),flux_04jul02_e140m*scale04jul02,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03_e140m,lambda0),flux_13feb03_e140m*scale13feb03,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m*scale,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,color=FSC_COLOR('red'),noclip=0
;plots,ZE_LAMBDA_TO_VEL(lambda_29jul03_e140m_k,lambda0),flux_29jul03_e140m_k*scale29jul03,color=FSC_COLOR('dark grey'),noclip=0
xyouts,labelxpos,yf-legypos_rel,'e) C II 1334, 1335 scaled',charsize=2.7
;xyouts,labelxpos,yf-legypos_rel,'Low-ionization UV resonance lines',charsize=3.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')

device,/close


yi=0
yf=7.0e-12
lambda0=1526.72
scale=1.12
scale04jul02=1.3
scale13feb03=1.08
scale05jul03=1.7
device,filename='/Users/jgroh/temp/etacar_hst_e140m_SiII_1526_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)',YTITLE=TEXTOIDL('Flux (erg/s/cm^2/A)'),$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000,YTICKINTERVAL=ytickinterval_val
ze_colorfill,low=-1000,high=-580,ymin=cspline(ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0)), ymax=flux_04jul02_e140m*scale04jul02,$
x=ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),yvals=flux_22jun03_e140m
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),flux_04jul02_e140m*scale04jul02,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03_e140m,lambda0),flux_13feb03_e140m*scale13feb03,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m*scale,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,color=FSC_COLOR('red'),noclip=0
;plots,ZE_LAMBDA_TO_VEL(lambda_05jul03_e140m,lambda0),flux_05jul03_e140m*scale05jul03,color=FSC_COLOR('dark grey'),noclip=0
xyouts,labelxpos,yf-legypos_rel,'f) Si II 1526.72 scaled',charsize=2.7
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
device,/close

yi=0
yf=7.0e-12
lambda0=1533.45
scale=1.12
scale04jul02=1.3
scale13feb03=1.08
scale05jul03=1.0
device,filename='/Users/jgroh/temp/etacar_hst_e140m_SiII_1533_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)', YTITLE=TEXTOIDL('Flux (erg/s/cm^2/A)'),$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000,YTICKINTERVAL=ytickinterval_val
ze_colorfill,low=-1000,high=-580,ymin=cspline(ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0)), ymax=flux_04jul02_e140m*scale04jul02,$
x=ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),yvals=flux_22jun03_e140m
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),flux_04jul02_e140m*scale04jul02,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03_e140m,lambda0),flux_13feb03_e140m*scale13feb03,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m*scale,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,color=FSC_COLOR('red'),noclip=0
;plots,ZE_LAMBDA_TO_VEL(lambda_05jul03_e140m,lambda0),flux_05jul03_e140m*scale05jul03,color=FSC_COLOR('dark grey'),noclip=0
xyouts,labelxpos,yf-legypos_rel,'g) Si II 1533.45 scaled',charsize=2.7
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
device,/close


yi=0
yf=6.1e-12
lambda0=1393.76
scale=1.06
scale04jul02=1.4
scale13feb03=1.0
scale05jul03=1.5
scale29jul03=2.0
device,filename='/Users/jgroh/temp/etacar_hst_e140m_SiIV_1393_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)', YTITLE=TEXTOIDL('Flux (erg/s/cm^2/A)'),$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000,title='High-ionization UV resonance lines',YTICKINTERVAL=ytickinterval_val
ze_colorfill,low=-2100,high=-580,ymin=cspline(ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0)), ymax=flux_04jul02_e140m*scale04jul02,$
x=ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),yvals=flux_22jun03_e140m
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),flux_04jul02_e140m*scale04jul02,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03_e140m,lambda0),flux_13feb03_e140m*scale13feb03,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m*scale,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,color=FSC_COLOR('red'),noclip=0
;plots,ZE_LAMBDA_TO_VEL(lambda_29jul03_e140m_k,lambda0),flux_29jul03_e140m_k*scale29jul03,color=FSC_COLOR('dark grey'),noclip=0
;plots,ZE_LAMBDA_TO_VEL(lambda_05jul03_e140m,lambda0),flux_05jul03_e140m*scale05jul03,color=FSC_COLOR('dark grey'),noclip=0
xyouts,labelxpos,yf-legypos_rel,'a) Si IV 1393.76 scaled',charsize=2.7
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
device,/close

yi=0
yf=6.1e-12
lambda0=1483.0
scale=1.06
scale04jul02=1.4
scale13feb03=1.0
scale05jul03=1.5
scale29jul03=2.0
device,filename='/Users/jgroh/temp/etacar_hst_e140m_control_SiIV_1393_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)',YTITLE=TEXTOIDL('Flux (erg/s/cm^2/A)'),$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000,YTICKINTERVAL=ytickinterval_val
;ze_colorfill,low=-2100,high=-580,ymin=cspline(ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0)), ymax=flux_04jul02_e140m*scale04jul02,$
;x=ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),yvals=flux_22jun03_e140m
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),flux_04jul02_e140m*scale04jul02,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03_e140m,lambda0),flux_13feb03_e140m*scale13feb03,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m*scale,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,color=FSC_COLOR('red'),noclip=0
;plots,ZE_LAMBDA_TO_VEL(lambda_29jul03_e140m_k,lambda0),flux_29jul03_e140m_k*scale29jul03,color=FSC_COLOR('dark grey'),noclip=0
;plots,ZE_LAMBDA_TO_VEL(lambda_05jul03_e140m,lambda0),flux_05jul03_e140m*scale05jul03,color=FSC_COLOR('dark grey'),noclip=0
xyouts,labelxpos,yf-legypos_rel,TEXTOIDL('d) Control region \lambda1483.0 scaled'),charsize=2.7
xyouts,legxpos-200,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos-200,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos-200,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos-200,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
device,/close


yi=0
yf=6.1e-12
lambda0=1402.77
scale=1.06
scale04jul02=1.4
scale13feb03=1.0
device,filename='/Users/jgroh/temp/etacar_hst_e140m_SiIV_1402_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)', YTITLE=TEXTOIDL('Flux (erg/s/cm^2/A)'),$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000,YTICKINTERVAL=ytickinterval_val
ze_colorfill,low=-2100,high=-580,ymin=cspline(ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0)), ymax=flux_04jul02_e140m*scale04jul02,$
x=ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),yvals=flux_22jun03_e140m
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),flux_04jul02_e140m*scale04jul02,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03_e140m,lambda0),flux_13feb03_e140m*scale13feb03,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m*scale,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,color=FSC_COLOR('red'),noclip=0
;plots,ZE_LAMBDA_TO_VEL(lambda_05jul03_e140m,lambda0),flux_05jul03_e140m*scale05jul03,color=FSC_COLOR('dark grey'),noclip=0
xyouts,labelxpos,yf-legypos_rel,'b) Si IV 1402.77 scaled',charsize=2.7
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
device,/close

yi=0
yf=6.1e-12
lambda0=1548.202
scale=1.12
scale04jul02=1.25
scale13feb03=1.00
device,filename='/Users/jgroh/temp/etacar_hst_e140m_CIV_1548_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)',YTITLE=TEXTOIDL('Flux (erg/s/cm^2/A)'),$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000,YTICKINTERVAL=ytickinterval_val
ze_colorfill,low=-1300,high=-580,ymin=cspline(ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0)), ymax=flux_04jul02_e140m*scale04jul02,$
x=ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),yvals=flux_22jun03_e140m
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),flux_04jul02_e140m*scale04jul02,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03_e140m,lambda0),flux_13feb03_e140m*scale13feb03,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m*scale,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,color=FSC_COLOR('red'),noclip=0
xyouts,labelxpos,yf-legypos_rel,'c) C IV 1548.20 scaled',charsize=2.7
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
device,/close

yi=0
yf=6.1e-12
lambda0=1550.777
scale=1.12
scale04jul02=1.25
scale13feb03=1.00
device,filename='/Users/jgroh/temp/etacar_hst_e140m_CIV_1551_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)', YTITLE=TEXTOIDL('Flux (erg/s/cm^2/A)'),$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000,YTICKINTERVAL=ytickinterval_val
ze_colorfill,low=-1750,high=-700,ymin=cspline(ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0)), ymax=flux_04jul02_e140m*scale04jul02,$
x=ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),yvals=flux_22jun03_e140m
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),flux_04jul02_e140m*scale04jul02,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03_e140m,lambda0),flux_13feb03_e140m*scale13feb03,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m*scale,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,color=FSC_COLOR('red'),noclip=0
xyouts,labelxpos,yf-legypos_rel,'d) C IV 1550.78 scaled',charsize=2.7
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
device,/close

yi=0
yf=6.1e-12
lambda0=1670.79
scale=1.12
scale04jul02=1.25
scale13feb03=1.00
device,filename='/Users/jgroh/temp/etacar_hst_e140m_AlII_1670_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)', YTITLE='Flux (erg/s/cm^2/A)',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000,YTICKINTERVAL=ytickinterval_val
ze_colorfill,low=-1000,high=-580,ymin=cspline(ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0)), ymax=flux_04jul02_e140m*scale04jul02,$
x=ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),yvals=flux_22jun03_e140m
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02_e140m,lambda0),flux_04jul02_e140m*scale04jul02,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03_e140m,lambda0),flux_13feb03_e140m*scale13feb03,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03_e140m,lambda0),flux_01jun03_e140m*scale,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03_e140m,lambda0),flux_22jun03_e140m,color=FSC_COLOR('red'),noclip=0
xyouts,labelxpos,yf-legypos_rel,'h) Al II 1670.79 scaled',charsize=2.7
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
device,/close

yi=0
yf=3.1e-12
lambda0=1854.72
scale=1.12
scale04jul02=1.25
scale13feb03=1.00
device,filename='/Users/jgroh/temp/etacar_hst_AlIII_1854_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)', YTITLE='Flux (erg/s/cm^2/A)',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02,lambda0),flux_04jul02*scale04jul02,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03,lambda0),flux_13feb03*scale13feb03,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03*scale,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03,lambda0),flux_22jun03,color=FSC_COLOR('red'),noclip=0
xyouts,labelxpos,yf-legypos_rel,'Al III 1854.72 scaled',charsize=2.7
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
device,/close

yi=0
yf=3.1e-12
lambda0=1862.79
scale=1.12
scale04jul02=1.25
scale13feb03=1.00
device,filename='/Users/jgroh/temp/etacar_hst_AlIII_1863_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)', YTITLE='Flux (erg/s/cm^2/A)',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02,lambda0),flux_04jul02*scale04jul02,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03,lambda0),flux_13feb03*scale13feb03,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03*scale,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03,lambda0),flux_22jun03,color=FSC_COLOR('red'),noclip=0
xyouts,labelxpos,yf-legypos_rel,'Al III 1862.79 scaled',charsize=2.7
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
;xyouts,labelxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.820,\phi=10.930,\phi=10.984,\phi=10.995,\phi=11.001')charsize=2.0,color=FSC_COLOR('blue')
device,/close

!P.THICK=15

;FOR OPTICAL HE I LINES< NORMALIZED PLOTS
PositionPlot=[0.10, 0.20, 0.978, 0.94]
lambda0=3889.74
norm_val=2.8e-12
xi=-2000
legypos_rel=0.1e-11/norm_val
legoffset=0.06e-11/norm_val
legxpos=-1200
yi=0
yf=5.1e-12/norm_val
scale04jul02=1.09
scale13feb03=1.15
scale01jun03=1.08
scale05jul03=0.93
device,filename='/Users/jgroh/temp/etacar_hst_HeI_3888_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)', YTITLE='Normalized Flux',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02,lambda0),flux_04jul02*scale04jul02/norm_val,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03,lambda0),flux_13feb03*scale13feb03/norm_val,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03*scale01jun03/norm_val,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03,lambda0),flux_22jun03/norm_val,color=FSC_COLOR('red'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_05jul03,lambda0),flux_05jul03*scale05jul03/norm_val,color=FSC_COLOR('purple'),noclip=0
xyouts,-1850,yf-legypos_rel,'a) He I 3888',charsize=2.7
legypos_rel=0.26e-11/norm_val
legxpos=-1850
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
xyouts,legxpos,yf-legypos_rel-3.82*legoffset,TEXTOIDL('\phi=11.001'),charsize=2.0,color=FSC_COLOR('purple')
device,/close

lambda0=5877.24
norm_val=6.02e-12
yi=4e-12/norm_val
yf=1.1e-11/norm_val
legypos_rel=0.1e-11/norm_val
legoffset=0.06e-11/norm_val
scale04jul02=1.25
scale13feb03=1.31
scale01jun03=1.10
scale05jul03=0.95
device,filename='/Users/jgroh/temp/etacar_hst_HeI_5877_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)', YTITLE='Normalized Flux',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02,lambda0),flux_04jul02*scale04jul02/norm_val,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03,lambda0),flux_13feb03*scale13feb03/norm_val,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03*scale01jun03/norm_val,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03,lambda0),flux_22jun03/norm_val,color=FSC_COLOR('red'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_05jul03,lambda0),flux_05jul03*scale05jul03/norm_val,color=FSC_COLOR('purple'),noclip=0
xyouts,-1850,yf-legypos_rel,'c) He I 5877',charsize=2.7
legypos_rel=0.21e-11/norm_val
legxpos=-1850
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
xyouts,legxpos,yf-legypos_rel-4.*legoffset,TEXTOIDL('\phi=11.001'),charsize=2.0,color=FSC_COLOR('purple')
device,/close

lambda0=4472.73
norm_val=3.36e-12
yi=2e-12/norm_val
yf=1.1e-11/norm_val
scale04jul02=1.25
scale13feb03=1.31
scale01jun03=1.10
scale05jul03=0.95
device,filename='/Users/jgroh/temp/etacar_hst_HeI_4473_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)', YTITLE='Normalized Flux',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000,YTICKINTERVAL=0.2
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02,lambda0),flux_04jul02*scale04jul02/norm_val,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03,lambda0),flux_13feb03*scale13feb03/norm_val,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03*scale01jun03/norm_val,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03,lambda0),flux_22jun03/norm_val,color=FSC_COLOR('red'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_05jul03,lambda0),flux_05jul03*scale05jul03/norm_val,color=FSC_COLOR('purple'),noclip=0
xyouts,-1850,yf-legypos_rel,'b) He I 4473',charsize=2.7
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
xyouts,legxpos,yf-legypos_rel-4.*legoffset,TEXTOIDL('\phi=11.001'),charsize=2.0,color=FSC_COLOR('purple')
device,/close

lambda0=4714.46
norm_val=3.66e-12
yi=2.5e-12/norm_val
yf=4.4e-12/norm_val
legypos_rel=0.25
legoffset=0.06
scale04jul02=1./0.81
scale13feb03=1/0.81
scale01jun03=1/0.90
scale05jul03=1/1.04
device,filename='/Users/jgroh/temp/etacar_hst_HeI_4714_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)', YTITLE='Normalized Flux',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000,YTICKINTERVAL=0.2
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02,lambda0),flux_04jul02*scale04jul02/norm_val,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03,lambda0),flux_13feb03*scale13feb03/norm_val,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03*scale01jun03/norm_val,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03,lambda0),flux_22jun03/norm_val,color=FSC_COLOR('red'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_05jul03,lambda0),flux_05jul03*scale05jul03/norm_val,color=FSC_COLOR('purple'),noclip=0
xyouts,-1850,1.15,'b) He I 4714',charsize=2.7
xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
xyouts,legxpos,yf-legypos_rel-4.*legoffset,TEXTOIDL('\phi=11.001'),charsize=2.0,color=FSC_COLOR('purple')
device,/close

lambda0=6679.99
norm_val=7.61e-12
yi=5.8e-12/norm_val
yf=1.1e-11/norm_val
legypos_rel=0.05
legoffset=0.09
legxpos=-1850
scale04jul02=1.25
scale13feb03=1.31
scale01jun03=1.13
scale05jul03=1.02
device,filename='/Users/jgroh/temp/etacar_hst_HeI_6680_highvel_scaled.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03,xrange=[xi,xf],yrange=[yi,yf],XTITLE='Heliocentric velocity (km/s)', YTITLE='Normalized Flux',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000,YTICKINTERVAL=0.2
legypos_rel=0.21e-11/norm_val
legxpos=-1850
plots,ZE_LAMBDA_TO_VEL(lambda_04jul02,lambda0),flux_04jul02*scale04jul02/norm_val,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_13feb03,lambda0),flux_13feb03*scale13feb03/norm_val,color=FSC_COLOR('green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03*scale01jun03/norm_val,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03,lambda0),flux_22jun03/norm_val,color=FSC_COLOR('red'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lambda_05jul03,lambda0),flux_05jul03*scale05jul03/norm_val,color=FSC_COLOR('purple'),noclip=0
xyouts,-1850,1.34,'d) He I 6680 scaled',charsize=2.7

xyouts,legxpos,yf-legypos_rel,TEXTOIDL('\phi=10.820'),charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-legoffset,TEXTOIDL('\phi=10.930'),charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,TEXTOIDL('\phi=10.984'),charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,TEXTOIDL('\phi=10.995'),charsize=2.0,color=FSC_COLOR('red')
xyouts,legxpos,yf-legypos_rel-4.*legoffset,TEXTOIDL('\phi=11.001'),charsize=2.0,color=FSC_COLOR('purple')
device,/close

device,filename='/Users/jgroh/temp/etacar_hst_22jun03_HeI_alllines_highvel_scaled_comp_hei10830_crires.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
plot,ZE_LAMBDA_TO_VEL(lambda_01jun03,lambda0),flux_01jun03,xrange=[xi,xf],yrange=[0,1.5],XTITLE='Heliocentric velocity (km/s)', YTITLE='Normalized Flux',$
/nodata,xstyle=1,ystyle=1,Position=PositionPlot,XTICKINTERVAL=1000, YTICKINTERVAL=0.5

lambda0=6679.99
norm_val=7.61e-12
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03,lambda0),flux_22jun03/norm_val,color=FSC_COLOR('black'),noclip=0

lambda0=5877.24
norm_val=6.02e-12
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03,lambda0),flux_22jun03/norm_val,color=FSC_COLOR('blue'),noclip=0

lambda0=4714.46
norm_val=3.66e-12
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03,lambda0),flux_22jun03/norm_val/1.05,color=FSC_COLOR('green'),noclip=0

lambda0=3889.74
norm_val=2.8e-12
plots,ZE_LAMBDA_TO_VEL(lambda_22jun03,lambda0),flux_22jun03/norm_val,color=FSC_COLOR('purple'),noclip=0

restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_norm_jan09.sav'
lambda_val=10830.
resolving_power=8000.
res=lambda_val/resolving_power

;convolving to the same resolution as STIS
ZE_SPEC_CNVL,lalljan,falljann,res,lambda_val,fluxcnvl=falljanncnvl
plots,ZE_LAMBDA_TO_VEL(lalljan,10833.0),falljanncnvl,noclip=0,color=FSC_COLOR('red'),linestyle=0

legypos_rel=0.8
legoffset=0.13
legxpos=-1850

xyouts,-1950,1.25,TEXTOIDL('He I lines at \phi=10.995 (STIS), \phi=11.998 (CRIRES)'),charsize=2.7
xyouts,legxpos,yf-legypos_rel,'He I 3889',charsize=2.0,color=FSC_COLOR('purple')
xyouts,legxpos,yf-legypos_rel-legoffset,'He I 4714',charsize=2.0,color=FSC_COLOR('green')
xyouts,legxpos,yf-legypos_rel-2.*legoffset,'He I 5877',charsize=2.0,color=FSC_COLOR('blue')
xyouts,legxpos,yf-legypos_rel-3.*legoffset,'He I 6678',charsize=2.0,color=FSC_COLOR('black')
xyouts,legxpos,yf-legypos_rel-4.*legoffset,'He I 10833',charsize=2.0,color=FSC_COLOR('red')
device,/close


!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!P.THICK=0
!X.THICK=0
!Y.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0
set_plot,'x'
!P.Background = fsc_color('white')
END