;PRO ZE_WORK_ETACAR_IMAGES_TO_BOREHOLE_TOM

model2d='4314'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_043150.txt', r1,i1
model2d='5506'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_055060.txt', r2,i2
model2d='6737'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_067370.txt', r3,i3
model2d='7936'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_079380.txt', r4,i4
model2d='12617'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_126200.txt', r5,i5
model2d='16569'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_165700.txt', r6,i6
model2d='21029'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_210400.txt', r7,i7
model2d='35556'
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/etc_intens_mas_mod111_john'+model2d+'_d23_PA130__PAprof_36_355500.txt', r8,i8

!P.THICK=12
!X.THiCK=25
!Y.THICK=25
!P.CHARTHICK=2.5
!P.FONT=-1
;!P.CHARSIZE=3.5
;!X.CHARSIZE=3.5
;!Y.CHARSIZE=3.5

!P.Background = fsc_color('white')
LOADCT,0
xwindowsize=900.*1  ;window size in x
ywindowsize=360.*1  ; window size in y

set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/etc_mod111_john_I_p_lambda_mas.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
!X.THICK=12
!Y.THICK=12
!P.CHARTHICK=10
 LOADCT, 0

colorm1=fsc_color('black')
colorm2=fsc_color('red')
colorm3=fsc_color('blue')
colorm4=fsc_color('green')
colorm5=fsc_color('orange')
colorm6=fsc_color('purple')
colorm7=fsc_color('cyan')
colorm8=fsc_color('dark green')

plot, r1,i1, charsize=2.7,ycharsize=1.4,xcharsize=1.4,YTICKFORMAT='(F8.1)',XTICKFORMAT='(F8.1)', $
xrange=[-10,10], $
xstyle=1,ystyle=1, ytitle='Intensity (normalized)', $
xtitle='Impact parameter (AU)', /NODATA, Position=[0.12, 0.17, 0.92, 0.97], title=title
plots,r1*2.3,i1,noclip=0,color=colorm1
plots,r2*2.3,i2,noclip=0,color=colorm2
plots,r3*2.3,i3,noclip=0,color=colorm3
plots,r4*2.3,i4,noclip=0,color=colorm4
plots,r5*2.3,i5,noclip=0,color=colorm5
plots,r6*2.3,i6,noclip=0,color=colorm6
plots,r7*2.3,i7,noclip=0,color=colorm7
plots,r8*2.3,i8,noclip=0,color=colorm8
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