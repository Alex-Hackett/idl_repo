;PRO ZE_MWC297_WORK_LNA_TO_ESO_CONF

file09apr='/Users/jgroh/data/lna/camiv_spectra/09abr21/mwc297_204_m_heln.fits'
ZE_READ_SPECTRA_FITS,file09apr,l09apr,f09apr
!P.Background = fsc_color('white')
file09jun='/Users/jgroh/data/lna/camiv_spectra/09jun06/mwc297204m_copy_scratch.fits'
ZE_READ_SPECTRA_FITS,file09jun,l09jun,f09jun
f09jun=REVERSE(f09jun)
l09jun=l09apr
l09jun=l09jun-1.13
IF N_elements(f09junn) LT 0 THEN line_norm, l09jun,f09jun,f09junn
!P.Background = fsc_color('white')
airtovac,l09jun
airtovac,l09apr
lambda0=10833.3
resolving_power=7500.
res=lambda0/resolving_power
ZE_SPEC_CNVL,l09apr,f09apr,res,lambda0,fluxcnvl=f09aprc
ZE_SPEC_CNVL,l09jun,f09junn,res,lambda0,fluxcnvl=f09junnc
set_plot,'ps'
;making psplots
!X.OMARGIN=[10,3]
!Y.OMARGIN=[3,0]
!Y.MARGIN=[5,5]
!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=1.4
!Y.charsize=2.0
!X.charsize=2.0
!P.THICK=6
!X.THiCK=6
!Y.THICK=6
!P.CHARTHICK=6.5
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

PositionPlot=[0.16, 0.17, 0.94, 0.87]

width=12
xsize=900.*1  ;window size in x
ysize=560.*1  ; window size in y
device,filename='/Users/jgroh/temp/mwc297_lna_1.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches

plot,l09jun,f09junn,xrange=[10380,11000],yrange=[0.5,2.5],/NODATA ,COLOR=FSC_COLOR('blue'), $
xstyle=1,ystyle=1, XTICKINTERVAL=200, XTICKFORMAT='(I5)', XTITLE='Wavelength (Angstroms)', YTITLE='Normalized Flux', Position=PositionPlot;,YTICKINTERVAL=100
;, title=title
plots,l09jun,f09junn,color=fsc_color('blue'),noclip=0

device,/close

!P.Color = fsc_color('black')
device,filename='/Users/jgroh/temp/mwc297_lna_2.eps',/encapsulated,/color,bit=8,xsize=width,ysize=width*ysize/xsize,/inches
l1=10800.
l2=10870.

plot,l09jun,f09junn,xrange=[l1,l2],yrange=[0.3,2.0],/NODATA ,COLOR=FSC_COLOR('black'), $
xstyle=9,ystyle=1, XTICKFORMAT='(I5)', XTITLE='Vacuum wavelength (Angstroms)', YTITLE='Normalized Flux', Position=PositionPlot,XTICKINTERVAL=20
;, title=title
plots,l09jun,f09junn,color=fsc_color('blue'),noclip=0
plots,l09apr,f09aprc,color=fsc_color('red'),noclip=0
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='Heliocentric velocity (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(l1,lambda0),ZE_LAMBDA_TO_VEL(l2,lambda0)]

device,/close






set_plot,'x'
!X.THICK=0
!Y.THICK=0
!P.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0
!P.Background = fsc_color('white')

END