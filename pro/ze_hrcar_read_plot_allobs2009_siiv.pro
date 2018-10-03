;PRO ZE_HRCAR_READ_PLOT_ALLOBS2009_SIIV
set_plot,'x'
LOADCT,0, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
dir='/Users/jgroh/espectros/'
restore,dir+'hrcar/hrcar_norm_val.sav'
dir='/Users/jgroh/espectros/'
ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/hrcar_gamen_casleo_2009jan13n.txt',l09jan13,f09jan13
ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/hrCar_4850.641.txt',l09jan18,f09jan18
ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/hrCar_4851.655.txt',l09jan19,f09jan19
ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/HR_Car_4855.txt',l09jan23,f09jan23
ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/hrc_09apr18_40_hel.txt',l09apr18,f09apr18


;ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/hrcar_2009may27.txt',l09may27,f09may27


line_norm,l09jan18,f09jan18,f09jan18n,f09jan18_norm,xnodes_fjan18,ynodes_jan18
line_norm,l09jan19,f09jan19,f09jan19n,f09jan19_norm,xnodes_fjan19,ynodes_jan19
line_norm,l09jan23,f09jan23,f09jan23n,f09jan23_norm,xnodes_fjan23,ynodes_jan23
line_norm,l09apr18,f09apr18,f09apr18n,f09apr18_norm,xnodes_fapr18,ynodes_apr18
;lineplot,lhrc,fhrcn
fhrcns=ZE_SHIfT_SPECTRA_VEL(lhrc,fhrcn,113.)
;lineplot,ZE_LAMBDA_TO_VEL(lhrc,4088.862),fhrcns


restore,FILENAME='/Users/jgroh/espectros/hrcar/hrcar_work_2drot.sav' 
restore,FILENAME='/Users/jgroh/espectros/hrcar/hrcar_siiv2009_all.sav' 
line_norm,lhrc,fhrcns,fhrcnsn,fhrcnsn_norm,xnodes_fhrcnsn,ynodes_fhrcnsn
lineplot,ZE_LAMBDA_TO_VEL(lhrc,4088.862),fhrcnsn



restore,dir+'hrcar_norm_val.sav'
lhrcmay3=lhrc
fhrcmay3=fhrcnsn

save,/variables,FILENAME='/Users/jgroh/espectros/hrcar/hrcar_siiv2009_all.sav' 

xsize=560.*1  ;window size in x
ysize=800.*1  ; window size in y
PositionPlot=[0.13, 0.18, 0.90, 0.92]
PositionPlot1=[0.13, 0.08, 0.50, 0.97]
PositionPlot2=[0.50, 0.08, 0.87, 0.97]
set_plot,'ps'
;making psplots
!p.multi=[0, 1, 2]

c=1.5
!X.THICK=3.5/c
!Y.THICK=3.5/c
!P.CHARTHICK=3.5/c
!P.CHARSIZE=1.0
!Y.charsize=1.4
!X.charsize=1.4
!P.THICK=6/c
!X.THiCK=6/c
!Y.THICK=6/c
!P.CHARTHICK=6.5/c
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
;******************************************************
;     SPHERICAL MODELS (DIFF MDOT) X OBS
;******************************************************
plotsym,1,3
offset=0.12
device,filename='/Users/jgroh/temp/hrcar_siiv_2009all.eps',/encapsulated,/color,bit=8,xsize=10*xsize/ysize,ysize=10,/inches
plot,l09jan13,f09jan13,xrange=[4084,4094],yrange=[0.88,1.9],XTITLE='', YTITLE='Normalized flux + constant',$
/nodata,XTICKFORMAT='(I6)',xstyle=1,ystyle=1,Position=PositionPlot1,XTICKINTERVAL=4
plots,l09jan13,f09jan13,color=FSC_COLOR('black'),noclip=0
plots,l09jan18,f09jan18n+offset,color=FSC_COLOR('black'),noclip=0
plots,l09jan19,f09jan19n+2*offset,color=FSC_COLOR('black'),noclip=0, linestyle=2
plots,l09jan23,f09jan23n+3*offset,color=FSC_COLOR('black'),noclip=0
plots,l09apr18,f09apr18n+4*offset,color=FSC_COLOR('black'),noclip=0
plots,lhrcmay3,fhrcmay3+5*offset,color=FSC_COLOR('black'),noclip=0
plots,l09may27,f09may27+6*offset,color=FSC_COLOR('black'),noclip=0
xyouts,4085.,1.83,'a) Si IV 4088.862',charsize=1.4

print,!p.multi
plot,l09jan13,f09jan13,xrange=[4110,4121],yrange=[0.88,1.9],XTITLE='', YTITLE='',$
/nodata,XTICKFORMAT='(I6)',YTICKFORMAT='(A2)',xstyle=1,ystyle=1,Position=PositionPlot2,XTICKINTERVAL=4
plots,l09jan13,f09jan13,color=FSC_COLOR('black'),noclip=0
plots,l09jan18,f09jan18n+offset,color=FSC_COLOR('black'),noclip=0
plots,l09jan19,f09jan19n+2*offset,color=FSC_COLOR('black'),noclip=0
plots,l09jan23,f09jan23n+3*offset,color=FSC_COLOR('black'),noclip=0
plots,l09apr18,f09apr18n+4*offset,color=FSC_COLOR('black'),noclip=0
plots,lhrcmay3,fhrcmay3+5*offset,color=FSC_COLOR('black'),noclip=0
plots,l09may27,f09may27+6*offset,color=FSC_COLOR('black'),noclip=0
xyouts,4111.5,1.83,'b) Si IV 4116.104',charsize=1.4

xyouts,0.5,0.02,'Heliocentric Air Wavelength (Angstrom)',/NORMAL,charsize=1.4,align=0.5

posx=4121.3
xyouts,posx,1.0,'Jan13',charsize=1.2,align=0.0
xyouts,posx,1.0+offset,'Jan18',charsize=1.2,align=0.0
xyouts,posx,1.0+2*offset,'Jan19',charsize=1.2,align=0.0
xyouts,posx,1.0+3*offset,'Jan23',charsize=1.2,align=0.0
xyouts,posx,1.0+4*offset,'Apr18',charsize=1.2,align=0.0
xyouts,posx,1.0+5*offset,'May03',charsize=1.2,align=0.0
xyouts,posx,1.0+6*offset,'May27',charsize=1.2,align=0.0
xyouts,posx,1.0+6.2*offset,'2009',charsize=1.2,align=0.0
;for i=0, t-1 DO BEGIN 
;xyouts,hjd_av[i],7.5,'!3'+string(45B),alignment=0.5,orientation=90,charthick=3.5
;plots,hjd_av[i],7.5,psym=8,symsize=3
;ENDFOR

device,/close

set_plot,'x'
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

END