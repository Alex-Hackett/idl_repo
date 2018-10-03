;PRO ZE_IRC10420_CREATE_PLOTS_PAPER
Angstrom = '!6!sA!r!u!9 %!6!n!r'
;RESTORING SPHERICAL MODELS
restore,'/Users/jgroh/espectros/irc10420/irc10420_2d_variables_15c_d35pa61.sav'
lambda_vector_15c=lambda_vector
vis_triplet_wavelength_cnvl_15c=vis_triplet_wavelength_cnvl
restore,'/Users/jgroh/espectros/irc10420/irc10420_2d_variables_17c_cnv_d35pa61.sav'
lambda_vector_17c=lambda_vector
vis_triplet_wavelength_cnvl_17c=vis_triplet_wavelength_cnvl
restore,'/Users/jgroh/espectros/irc10420/irc10420_2d_variables_22c_cnv_d35pa61.sav'
lambda_vector_22c=lambda_vector
vis_triplet_wavelength_cnvl_22c=vis_triplet_wavelength_cnvl

restore,'/Users/jgroh/espectros/irc10420/irc10420_variables_spec_19a_cnvsub_d50.sav'
lambda_vector_19asub=lambda_vector
totalfluxfimsysn_19asub=totalfluxfimsysn

restore,'/Users/jgroh/espectros/irc10420/irc10420_variables_spec_19a_cnv_d50.sav'
lambda_vector_19a=lambda_vector
totalfluxfimsysn_19a=totalfluxfimsysn

restore,'/Users/jgroh/espectros/irc10420/irc10420_2d_variables_19a_cnv_d35pa61.sav'
lambda_vector_19a=lambda_vector
vis_triplet_wavelength_cnvl_19a=vis_triplet_wavelength_cnvl
phase_triplet_wavelength_cnvl_19a=phase_triplet_wavelength_cnvl
cp_triplet_wavelength_cnvl_19a=cp_triplet_wavelength_cnvl_sys

restore,'/Users/jgroh/espectros/irc10420/irc10420_2d_variables_19a_cnvsub_d35pa61.sav'
!P.Background = fsc_color('white')
;lineplot,lambda_vector,cp_triplet_wavelength_cnvl_sys
lambda_vector_19asub=lambda_vector
vis_triplet_wavelength_cnvl_19asub=vis_triplet_wavelength_cnvl
phase_triplet_wavelength_cnvl_19asub=phase_triplet_wavelength_cnvl
cp_triplet_wavelength_cnvl_19asub=cp_triplet_wavelength_cnvl_sys
;lineplot,lambda_vector_19asub,cp_triplet_wavelength_cnvl_19asub

;restore,'/Users/jgroh/espectros/irc10420/irc10420_variables_vis_19a_cnvsub_d50.sav'
;lambda_vector_19asub50=lambda_vector
;phase_triplet_wavelength_cnvl_19asub50=phase_triplet_wavelength_cnvl

ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/irc10420/irc10420_mod17_kband_vacn.txt',lmod17,fmod17
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/irc10420/irc10420_mod15_kband_vacn.txt',lmod15,fmod15
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/espectros/irc10420/irc10420_mod22_kband_vacn.txt',lmod22,fmod22

fmod15sys=ZE_SHIfT_SPECTRA_VEL(lmod15,fmod15,vsys)
fmod17sys=ZE_SHIfT_SPECTRA_VEL(lmod17,fmod17,vsys)
fmod22sys=ZE_SHIfT_SPECTRA_VEL(lmod22,fmod22,vsys)

xwindowsize=900.*1  ;window size in x
ywindowsize=760.*1  ; window size in y
PositionPlot=[0.22, 0.17, 0.97, (0.73*xsize/ysize)]
xtitlePlot=TEXTOIDL('Helioc. vacuum wavelength ('+Angstrom+')')
xtitlePlot='Helioc. vacuum wavelength (!3' + STRING(197B) + '!X)'
set_plot,'ps'
!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=2.7
!Y.charsize=1.4
!X.charsize=1.4
!P.THICK=6
!X.THiCK=6
!Y.THICK=6
!P.CHARTHICK=6.5
!P.FONT=-1
device,/close


;******************************************************
;     SPHERICAL MODELS (DIFF MDOT) X OBS
;******************************************************

device,filename='/Users/jgroh/temp/vis_wavelength_comp_b12.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,vis_triplet_wavelength_cnvl[0,*],yrange=[0,1.1],XTITLE=xtitlePlot, YTITLE='Visibility',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=PositionPlot
plots,vis12_ut.field1[2,*]*10000.,vis12_ut.field1[3,*],color=FSC_COLOR('black'),noclip=0
plots,lambda_vector_22c,vis_triplet_wavelength_cnvl_22c[0,*],noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,lambda_vector_17c,vis_triplet_wavelength_cnvl_17c[0,*],noclip=0,color=FSC_COLOR('blue'),linestyle=3
xyouts,0.3,0.3,TEXTOIDL('B_{12}=54.30m, PA=36.0')+'!Eo!N',/NORMAL
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0)-vsys,ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)-vsys]
device,/close

device,filename='/Users/jgroh/temp/vis_wavelength_comp_b23.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,vis_triplet_wavelength_cnvl[0,*],yrange=[0,1.1],XTITLE=xtitlePlot, YTITLE='Visibility',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=PositionPlot
plots,vis23_ut.field1[2,*]*10000.,vis23_ut.field1[3,*],color=FSC_COLOR('black'),noclip=0
plots,lambda_vector_22c,vis_triplet_wavelength_cnvl_22c[1,*],noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,lambda_vector_17c,vis_triplet_wavelength_cnvl_17c[1,*],noclip=0,color=FSC_COLOR('blue'),linestyle=3
xyouts,0.3,0.3,TEXTOIDL('B_{23}=82.75m, PA=76.5')+'!Eo!N',/NORMAL
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0)-vsys,ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)-vsys]
device,/close

device,filename='/Users/jgroh/temp/vis_wavelength_comp_b31.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,vis_triplet_wavelength_cnvl[0,*],yrange=[0,1.1],XTITLE=xtitlePlot, YTITLE='Visibility',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=PositionPlot
plots,vis31_ut.field1[2,*]*10000.,vis31_ut.field1[3,*],color=FSC_COLOR('black'),noclip=0
plots,lambda_vector_22c,vis_triplet_wavelength_cnvl_22c[2,*],noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,lambda_vector_17c,vis_triplet_wavelength_cnvl_17c[2,*],noclip=0,color=FSC_COLOR('blue'),linestyle=3
xyouts,0.3,0.8,TEXTOIDL('B_{31}=128.95m, PA=60.6')+'!Eo!N',/NORMAL
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0)-vsys,ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)-vsys]
device,/close

device,filename='/Users/jgroh/temp/spec_wavelength_comp.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,totalfluxfimsysn,yrange=[0,5.2],XTITLE=xtitlePlot, YTITLE='F/Fc',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=PositionPlot,xrange=[21645,21685]
plots,lobs,fobsheln,color=FSC_COLOR('black'),noclip=0
plots,lmod22,fmod22sys,noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,lmod17,fmod17sys,noclip=0,color=FSC_COLOR('blue'),linestyle=3
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(21645,lambda0)-vsys,ZE_LAMBDA_TO_VEL(21685,lambda0)-vsys]

device,/close

;******************************************************
;     2D MODEL X OBS
;******************************************************

a=-90
b=90
device,filename='/Users/jgroh/temp/vis_wavelength_comp_b12_19.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,vis_triplet_wavelength_cnvl[0,*],yrange=[0,1.1],XTITLE=xtitlePlot, YTITLE='Visibility',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=PositionPlot
plots,vis12_ut.field1[2,*]*10000.,vis12_ut.field1[3,*],color=FSC_COLOR('black'),noclip=0
plots,lambda_vector_19asub,vis_triplet_wavelength_cnvl_19asub[0,*],noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,lambda_vector_19a,vis_triplet_wavelength_cnvl_19a[0,*],noclip=0,color=FSC_COLOR('blue'),linestyle=3
xyouts,0.3,0.3,TEXTOIDL('B_{12}=54.30m, PA=36.0')+'!Eo!N',/NORMAL
;plots,lambda_vector_17c,vis_triplet_wavelength_cnvl_17c[0,*],noclip=0,color=FSC_COLOR('blue'),linestyle=3
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0)-vsys,ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)-vsys]
device,/close

device,filename='/Users/jgroh/temp/vis_wavelength_comp_b23_19.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,vis_triplet_wavelength_cnvl[0,*],yrange=[0,1.1],XTITLE=xtitlePlot, YTITLE='Visibility',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=PositionPlot
plots,vis23_ut.field1[2,*]*10000.,vis23_ut.field1[3,*],color=FSC_COLOR('black'),noclip=0
plots,lambda_vector_19asub,vis_triplet_wavelength_cnvl_19asub[1,*],noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,lambda_vector_19a,vis_triplet_wavelength_cnvl_19a[1,*],noclip=0,color=FSC_COLOR('blue'),linestyle=3
xyouts,0.3,0.3,TEXTOIDL('B_{23}=82.75m, PA=76.5')+'!Eo!N',/NORMAL
;plots,lambda_vector_17c,vis_triplet_wavelength_cnvl_17c[1,*],noclip=0,color=FSC_COLOR('blue'),linestyle=3
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0)-vsys,ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)-vsys]
device,/close

device,filename='/Users/jgroh/temp/vis_wavelength_comp_b31_19.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,vis_triplet_wavelength_cnvl[0,*],yrange=[0,1.1],XTITLE=xtitlePlot, YTITLE='Visibility',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=PositionPlot
plots,vis31_ut.field1[2,*]*10000.,vis31_ut.field1[3,*],color=FSC_COLOR('black'),noclip=0
plots,lambda_vector_19asub,vis_triplet_wavelength_cnvl_19asub[2,*],noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,lambda_vector_19a,vis_triplet_wavelength_cnvl_19a[2,*],noclip=0,color=FSC_COLOR('blue'),linestyle=3
xyouts,0.3,0.8,TEXTOIDL('B_{31}=128.95m, PA=60.6')+'!Eo!N',/NORMAL
;plots,lambda_vector_17c,vis_triplet_wavelength_cnvl_17c[2,*],noclip=0,color=FSC_COLOR('blue'),linestyle=3
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0)-vsys,ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)-vsys]
device,/close

device,filename='/Users/jgroh/temp/phase_wavelength_comp_b12_19.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,phase_triplet_wavelength_cnvl_19asub[0,*],yrange=[a,b],XTITLE=xtitlePlot, YTITLE='Differential phase (deg)',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=PositionPlot
;plots,phase12_ut.field1[2,*]*10000.,phase12_ut.field1[3,*],color=FSC_COLOR('black'),noclip=0
plots,[21645,21684],[0,0],color=FSC_COLOR('red'),noclip=0,linestyle=2
;plots,lambda_vector_19asub,phase_triplet_wavelength_cnvl_19asub[0,*]+4.22,noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,lambda_vector_19a,phase_triplet_wavelength_cnvl_19a[0,*]-2.22,noclip=0,color=FSC_COLOR('blue'),linestyle=3
xyouts,0.3,0.8,TEXTOIDL('B_{12}=54.30m, PA=36.0')+'!Eo!N',/NORMAL
;plots,lambda_vector_17c,vis_triplet_wavelength_cnvl_17c[0,*],noclip=0,color=FSC_COLOR('blue'),linestyle=3
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0)-vsys,ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)-vsys]
device,/close

device,filename='/Users/jgroh/temp/phase_wavelength_comp_b23_19.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,phase_triplet_wavelength_cnvl[0,*],yrange=[a,b],XTITLE=xtitlePlot, YTITLE='Differential phase (deg)',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=PositionPlot
;plots,phase23_ut.field1[2,*]*10000.,phase23_ut.field1[3,*],color=FSC_COLOR('black'),noclip=0
;plots,lambda_vector_19asub,phase_triplet_wavelength_cnvl_19asub[1,*]+6.54,noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,[21645,21684],[0,0],color=FSC_COLOR('red'),noclip=0,linestyle=2
plots,lambda_vector_19a,phase_triplet_wavelength_cnvl_19a[1,*]-1.96,noclip=0,color=FSC_COLOR('blue'),linestyle=3
xyouts,0.3,0.8,TEXTOIDL('B_{23}=82.75m, PA=76.5')+'!Eo!N',/NORMAL
;plots,lambda_vector_17c,phase_triplet_wavelength_cnvl_17c[1,*],noclip=0,color=FSC_COLOR('blue'),linestyle=3
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0)-vsys,ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)-vsys]
device,/close

device,filename='/Users/jgroh/temp/phase_wavelength_comp_b31_19.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,phase_triplet_wavelength_cnvl[0,*],yrange=[a,b],XTITLE=xtitlePlot, YTITLE='Differential phase (deg)',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=PositionPlot
;plots,phase31_ut.field1[2,*]*10000.,phase31_ut.field1[3,*],color=FSC_COLOR('black'),noclip=0
;plots,lambda_vector_19asub,phase_triplet_wavelength_cnvl_19asub[2,*]+7.87,noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,[21645,21684],[0,0],color=FSC_COLOR('red'),noclip=0,linestyle=2
plots,lambda_vector_19a,phase_triplet_wavelength_cnvl_19a[2,*]-3.83,noclip=0,color=FSC_COLOR('blue'),linestyle=3
xyouts,0.3,0.8,TEXTOIDL('B_{31}=128.95m, PA=60.6')+'!Eo!N',/NORMAL
;plots,lambda_vector_17c,phase_triplet_wavelength_cnvl_17c[2,*],noclip=0,color=FSC_COLOR('blue'),linestyle=3
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0)-vsys,ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)-vsys]
device,/close

device,filename='/Users/jgroh/temp/cp_wavelength_comp_19.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,cp_ut.field1[2,*]*10000.,cp_ut.field1[3,*],yrange=[-190,190],XRANGE=[21645,21685],XTITLE=xtitlePlot, YTITLE='Closure phase (deg)',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=PositionPlot
;plots,cp_ut.field1[2,*]*10000.,cp_ut.field1[3,*],color=FSC_COLOR('black'),noclip=0
;plots,lambda_vector_19asub,cp_triplet_wavelength_cnvl_19asub,noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,[21645,21684],[0,0],color=FSC_COLOR('red'),noclip=0,linestyle=2
plots,lambda_vector_19a,cp_triplet_wavelength_cnvl_19a,noclip=0,color=FSC_COLOR('blue'),linestyle=3
;plots,lambda_vector_17c,phase_triplet_wavelength_cnvl_17c[2,*],noclip=0,color=FSC_COLOR('blue'),linestyle=3
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0)-vsys,ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)-vsys]
device,/close

device,filename='/Users/jgroh/temp/spec_wavelength_19asub.eps',/encapsulated,/color,bit=8,xsize=10*xwindowsize/ywindowsize,ysize=10,/inches
plot,lambda_vector,totalfluxfimsysn,yrange=[0,3.7],xtitle=xtitlePlot, YTITLE='F/Fc',$
/nodata,XTICKFORMAT='(I6)',xstyle=9,ystyle=1,Position=PositionPlot
;plots,lambda_vector,totalfluxfimsysn_19asub,noclip=0,color=FSC_COLOR('red'),linestyle=2
plots,lambda_vector,totalfluxfimsysn_19a,noclip=0,color=FSC_COLOR('blue'),linestyle=3
plots,lobs,fobsheln,color=FSC_COLOR('black'),noclip=0
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='v - vsys (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_vector),lambda0)-vsys,ZE_LAMBDA_TO_VEL(max(lambda_vector),lambda0)-vsys]

device,/close
set_plot,'x'
END