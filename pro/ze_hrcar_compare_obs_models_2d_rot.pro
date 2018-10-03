;PRO ZE_HRCAR_COMPARE_OBS_MODELS_2D_ROT
LOADCT,13, /SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
dir='/Users/jgroh/espectros/'
restore,dir+'hrcar/hrcar_norm_val.sav'
dir='/Users/jgroh/espectros/'
ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/hrcar_gamen_casleo_2009jan13n.txt',l09jan13,f09jan13
restore,FILENAME='/Users/jgroh/espectros/hrcar/hrcar_work_2drot.sav' 
;ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/hrc_1_optn.txt',l1,f1,nrec1
;ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/hrc_2_optn.txt',l2,f2,nrec2
;ZE_READ_SPECTRA_COL_VEC,dir+'hrcar/hrc_7_optn.txt',l7,f7,nrec7
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'6'+'/obsopt/obs_fin',dirhrcmod+'6'+'/obscont/obs_fin',l6,f6,/AIR
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'7'+'/obsopt/obs_fin',dirhrcmod+'7'+'/obscont/obs_fin',l7,f7,/AIR
ZE_CMFGEN_CREATE_OBSNORM,dirhrcmod+'8'+'/obsopt/obs_fin',dirhrcmod+'8'+'/obscont/obs_fin',l8,f8,/AIR
;lineplot,lhrc,fhrcn
fhrcns=ZE_SHIfT_SPECTRA_VEL(lhrc,fhrcn,113.)
;lineplot,ZE_LAMBDA_TO_VEL(lhrc,4088.862),fhrcns
;lineplot,ZE_LAMBDA_TO_VEL(l09jan13,4088.862),f09jan13
vsys=-10.4 ;consistent with Weis et al. 1997
;lineplot,ZE_LAMBDA_TO_VEL(l2,4088.862)-vsys,f2
;lineplot,ZE_LAMBDA_TO_VEL(l2,4088.862)-vsys,((f2-1.)*1.8)+1
scl=1.82
;lineplot,ZE_LAMBDA_TO_VEL(l4,4088.862)-vsys,((f4-1.)*scl)+1
;f2sys=ZE_SHIFT_SPECTRA_VEL(l2,f2,-vsys)

;lineplot,lhrc,fhrcns
;lineplot,l09jan13,f09jan13
;ZE_SPEC_CNVL,l4,f4sys,0.5,4088.8,fluxcnvl=f4syscnvl
;lineplot,l4,f4syscnvl
;lineplot,l4,f4sys
f7sys=ZE_SHIFT_SPECTRA_VEL(l7,f7,-vsys)
line_norm,lhrc,fhrcns,fhrcnsn,fhrcnsn_norm,xnodes_fhrcnsn,ynodes_fhrcnsn
;lineplot,ZE_LAMBDA_TO_VEL(lhrc,4088.862),fhrcnsn

root_dir='/Users/jgroh/ze_models/2D_models/hrcar/'
modeldir=[root_dir+'2/',root_dir+'4/',root_dir+'40_30degrees/', root_dir+'6/', root_dir+'7/', root_dir+'8/' ]
;               0             1                  2                    3             4               5

;ZE_CMFGEN_READ_OBS_2D,'OBSFRAME1', modeldir[2]+'50/',lvac50,f50,num_rec50
;lair50=lvac50
;VACTOAIR,lair50
;if n_elements(f50n) eq 0. THEN line_norm,lair50,f50,f50n,f50_norm,xnodes_f50,ynodes_f50
;lineplot,ZE_LAMBDA_TO_VEL(lair50,4088.862)-vsys,((f50n-1.)*scl)+1

ZE_CMFGEN_READ_OBS_2D,'OBSFRAME1', modeldir[4]+'75/',lvac7_75,f7_75,num_rec7_75
lair7_75=lvac7_75
VACTOAIR,lair7_75
if n_elements(f7_75n) eq 0. THEN line_norm,lair7_75,f7_75,f7_75n,f7_75_norm,xnodes_f7_75,ynodes_f7_75
;lineplot,ZE_LAMBDA_TO_VEL(lair7_75,4088.862)-vsys,((f7_75n-1.)*scl)+1

ZE_CMFGEN_READ_OBS_2D,'OBSFRAME1', modeldir[4]+'100/',lvac7_100,f7_100,num_rec7_100
lair7_100=lvac7_100
VACTOAIR,lair7_100
xnodes_f7_100=xnodes_f7_75
f7_100i=cspline(lair7_100,f7_100,xnodes_f7_100)
ynodes_f7_100=f7_100i
undefine,f7_100n
if n_elements(f7_100n) eq 0. THEN line_norm,lair7_100,f7_100,f7_100n,f7_100_norm,xnodes_f7_100,ynodes_f7_100
;lineplot,ZE_LAMBDA_TO_VEL(lair7_100,4088.862)-vsys,((f7_100n-1.)*scl)+1

ZE_CMFGEN_READ_OBS_2D,'OBSFRAME1', modeldir[4]+'125/',lvac7_125,f7_125,num_rec7_125
lair7_125=lvac7_125
VACTOAIR,lair7_125
xnodes_f7_125=xnodes_f7_75
f7_125i=cspline(lair7_125,f7_125,xnodes_f7_125)
ynodes_f7_125=f7_125i
undefine,f7_125n
if n_elements(f7_125n) eq 0. THEN line_norm,lair7_125,f7_125,f7_125n,f7_125_norm,xnodes_f7_125,ynodes_f7_125
;lineplot,ZE_LAMBDA_TO_VEL(lair7_125,4088.862)-vsys,((f7_125n-1.)*scl)+1


ZE_CMFGEN_READ_OBS_2D,'OBSFRAME1', modeldir[4]+'150/',lvac7_150,f7_150,num_rec7_150
lair7_150=lvac7_150
VACTOAIR,lair7_150
xnodes_f7_150=xnodes_f7_75
f7_150i=cspline(lair7_150,f7_150,xnodes_f7_150)
ynodes_f7_150=f7_150i
undefine,f7_150n
if n_elements(f7_150n) eq 0. THEN line_norm,lair7_150,f7_150,f7_150n,f7_150_norm,xnodes_f7_150,ynodes_f7_150
;lineplot,ZE_LAMBDA_TO_VEL(lair7_150,4088.862)-vsys,((f7_150n-1.)*scl)+1

ZE_CMFGEN_READ_OBS_2D,'OBSFRAME1', modeldir[4]+'175/',lvac7_175,f7_175,num_rec7_175
lair7_175=lvac7_175
VACTOAIR,lair7_175
xnodes_f7_175=xnodes_f7_75
f7_175i=cspline(lair7_175,f7_175,xnodes_f7_175)
ynodes_f7_175=f7_175i
undefine,f7_175n
if n_elements(f7_175n) eq 0. THEN line_norm,lair7_175,f7_175,f7_175n,f7_175_norm,xnodes_f7_175,ynodes_f7_175
;lineplot,ZE_LAMBDA_TO_VEL(lair7_175,4088.862)-vsys,((f7_175n-1.)*scl)+1



save,/variables,FILENAME='/Users/jgroh/espectros/hrcar/hrcar_work_2drot.sav' 

xsize=900.*1  ;window size in x
ysize=560.*1  ; window size in y
PositionPlot=[0.13, 0.18, 0.90, 0.92]
PositionPlot1=[0.16, 0.14, 0.54, 0.92]
PositionPlot2=[0.54, 0.14, 0.90, 0.92]
set_plot,'ps'
;making psplots
!p.multi=[0, 1, 2]

!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=1.4
!Y.charsize=1.4
!X.charsize=1.4
!P.THICK=6
!X.THiCK=6
!Y.THICK=6
!P.CHARTHICK=6.5
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
;******************************************************
;     SPHERICAL MODELS (DIFF MDOT) X OBS
;******************************************************
plotsym,1,3
offset=0.12
device,filename='/Users/jgroh/temp/hrcar_siiv_2009_comp_model_rot.eps',/encapsulated,/color,bit=8,xsize=10*xsize/ysize,ysize=10,/inches
plot,ZE_LAMBDA_TO_VEL(lhrc,4088.862),fhrcnsn,xrange=[-200,199],yrange=[0.80,1.06],XTITLE='Heliocentric velocity (km/s)', YTITLE='Normalized flux',$
/nodata,XTICKFORMAT='(I6)',xstyle=1,ystyle=1,Position=PositionPlot1,XTICKINTERVAL=100
plots,ZE_LAMBDA_TO_VEL(lhrc,4088.862),fhrcnsn,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(l7,4088.862)-vsys,((f7-1.)*scl)+1,color=FSC_COLOR('dark green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lair7_75,4088.862)-vsys,((f7_75n-1.)*scl)+1,color=FSC_COLOR('red'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lair7_150,4088.862)-vsys,((f7_150n-1.)*scl)+1,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lair7_175,4088.862)-vsys,((f7_175n-1.)*scl)+1,color=FSC_COLOR('purple'),noclip=0
xyouts,-150,1.03,'a) Si IV 4088.862',charsize=2.0

;plots,l09jan19,f09jan19n+2*offset,color=FSC_COLOR('black'),noclip=0
;plots,l09jan23,f09jan23n+3*offset,color=FSC_COLOR('black'),noclip=0
;plots,l09apr18,f09apr18n+4*offset,color=FSC_COLOR('black'),noclip=0
;plots,lhrcmay3,fhrcmay3+5*offset,color=FSC_COLOR('black'),noclip=0
;plots,l09may27,f09may27+6*offset,color=FSC_COLOR('black'),noclip=0


plot,ZE_LAMBDA_TO_VEL(lhrc,4116.104),fhrcnsn,xrange=[-200,200],yrange=[0.80,1.06],XTITLE='Heliocentric velocity (km/s)', YTITLE='',$
/nodata,XTICKFORMAT='(I6)',YTICKFORMAT='(A2)',xstyle=1,ystyle=1,Position=PositionPlot2,XTICKINTERVAL=100
plots,ZE_LAMBDA_TO_VEL(lhrc,4116.104),fhrcnsn,color=FSC_COLOR('black'),noclip=0
plots,ZE_LAMBDA_TO_VEL(l7,4116.104)-vsys,((f7-1.)*scl)+1,color=FSC_COLOR('dark green'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lair7_75,4116.104)-vsys,((f7_75n-1.)*scl)+1,color=FSC_COLOR('red'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lair7_150,4116.104)-vsys,((f7_150n-1.)*scl)+1,color=FSC_COLOR('blue'),noclip=0
plots,ZE_LAMBDA_TO_VEL(lair7_175,4116.104)-vsys,((f7_175n-1.)*scl)+1,color=FSC_COLOR('purple'),noclip=0
xyouts,-150,1.03,'b) Si IV 4116.104',charsize=2.0


;plots,l09jan18,f09jan18n+offset,color=FSC_COLOR('black'),noclip=0
;plots,l09jan19,f09jan19n+2*offset,color=FSC_COLOR('black'),noclip=0
;plots,l09jan23,f09jan23n+3*offset,color=FSC_COLOR('black'),noclip=0
;plots,l09apr18,f09apr18n+4*offset,color=FSC_COLOR('black'),noclip=0
;plots,lhrcmay3,fhrcmay3+5*offset,color=FSC_COLOR('black'),noclip=0
;plots,l09may27,f09may27+6*offset,color=FSC_COLOR('black'),noclip=0



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
