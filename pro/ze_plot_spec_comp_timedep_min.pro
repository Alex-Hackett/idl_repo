Angstrom = '!6!sA!r!u!9 %!6!n'
close,/all

;defining observations
obs86jun1='/aux/pc20072b/jgroh/espectros/agcar/agc86jun18_all.txt'
obs87jan1='/aux/pc20072b/jgroh/espectros/agcar/agc87jan00_58.txt'
obs87jan2='/aux/pc20072b/jgroh/espectros/agcar/agc87jan05_66_new_es.txt'
obs87jun1='/aux/pc20072b/jgroh/espectros/agcar/agc87jun10_39.txt'
obs87jun2='/aux/pc20072b/jgroh/espectros/agcar/agc87jun10_66_new_es.txt'
;obs87jun2='/aux/pc20072b/jgroh/espectros/agcar/agc90dec28_66_new_es.txt'
obs89mar1='/aux/pc20072b/jgroh/espectros/agcar/agc_89mar26_38a49_OBzoo.txt'
;obs89mar1='/aux/pc20072b/jgroh/espectros/agcar/ag_car_21jan91.txt'
;obs01apr='/aux/pc20072b/jgroh/espectros/agcar/agc01apr12_35a90.txt'

obs89mar1='/aux/pc20072b/jgroh/espectros/agcar/397_optn.txt'
obs87jan1='/aux/pc20072b/jgroh/espectros/agcar/397_optn.txt'
obs87jun2='/aux/pc20072b/jgroh/espectros/agcar/397_optn.txt'

obs89mar1='/aux/pc20072b/jgroh/espectros/agcar/1_red_mmd.txt'
obs87jan1='/aux/pc20072b/jgroh/espectros/agcar/1_red_mmd.txt'
obs87jun2='/aux/pc20072b/jgroh/espectros/agcar/1_red_mmd.txt'

;obs01apr='/aux/pc20072b/jgroh/espectros/agcar/agc_var_min_1_optn.txt'

obs01apr='/aux/pc20072b/jgroh/espectros/agcar/397_optn.txt'

ZE_READ_SPECTRA_COL_VEC,obs87jan1,lambda87jan1,flux87jan1
ZE_READ_SPECTRA_COL_VEC,obs87jun2,lambda87jun2,flux87jun2
ZE_READ_SPECTRA_COL_VEC,obs89mar1,lambda89mar1,flux89mar1
ZE_READ_SPECTRA_COL_VEC,obs01apr,lambda01apr,flux01apr

lambda_val=4696.
near = Min(Abs(lambda01apr-lambda_val), index)
dl=lambda01apr[index]-lambda01apr[index-1]
resmar89=1.5

;t=cnvlgauss(flux01apr,fwhm=resmar89/dl)
t=flux01apr

;set plot range
x2l=5865. & x2u=5887.
x3l=6546. & x3u=6580.
x1l=4650. & x1u=4700.

set_plot,'ps'
device,filename='/aux/pc20072b/jgroh/temp/output_spec_timedep_min_comp.eps',/encapsulated,/color,bit=8,xsize=6.48,ysize=6.48,/inches
!p.multi=[0, 1, 3, 0, 0]

;1st panel, 

plot,lambda89mar1,flux89mar1,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.9,1.78],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
ytitle='F/F!Ic',/nodata,charsize=2,XMARGIN=[8,3],YMARGIN=[3,1];,POSITION=[0.05,0.05,0.72,0.24]
plots,lambda89mar1,flux89mar1,color=fsc_color('black'),noclip=0,clip=[x1l,0,x1u,2.5],thick=2
plots,lambda01apr,t,color=fsc_color('grey'), noclip=0,clip=[x1l,0,x1u,2],linestyle=0,thick=3
xyouts,4655,1.45,'1 timedep mdotx2 +60d',alignment=0.0,orientation=0
plots,[4651,4654],[1.48,1.48],color=fsc_color('grey'),linestyle=0,thick=3
xyouts,4655,1.6,'397 no timedep',alignment=0.0,orientation=0
plots,[4651,4654],[1.62,1.62],color=fsc_color('black'),linestyle=0,thick=2

;xyouts,4686,1.35,'!3'+string(45B)+' HeII',alignment=0.0,orientation=90
;xyouts,4659,1.35,'!3'+string(45B)+' [FeIII]',alignment=0.0,orientation=90

;2nd panel
plot,lambda87jan1,flux87jan1,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[0,5.5],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']',$
ytitle='F/F!Ic',/nodata,charsize=2,XMARGIN=[8,3],YMARGIN=[3,1]
plots,lambda87jan1,flux87jan1,color=fsc_color('black'),noclip=0,clip=[x2l,0,x2u,13],thick=2
plots,lambda01apr,flux01apr,color=fsc_color('grey',!d.table_size-10), noclip=0,clip=[x2l,0,x2u,13],linestyle=0,thick=3

;xyouts,5869.5,5.0,'2001apr',alignment=0.0,orientation=0
;plots,[5867.5,5869],[5.38,5.38],color=fsc_color('grey'),linestyle=0,thick=3
;xyouts,5869.5,6.3,'1987jan',alignment=0.0,orientation=0
;plots,[5867.5,5869],[6.58,6.58],color=fsc_color('black'),linestyle=0,thick=2



;3rd panel, 
plot,lambda87jun2-0.2,flux87jun2,xstyle=1,ystyle=1,xrange=[x3l,x3u],yrange=[0.5,15],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
ytitle='F/F!Ic',/nodata,charsize=2,XMARGIN=[9,3],YMARGIN=[3,1]
plots,lambda87jun2-0.2,flux87jun2,color=fsc_color('black'),noclip=0,thick=2
plots,lambda01apr,flux01apr,color=fsc_color('grey'),noclip=0,linestyle=0,thick=3

;xyouts,6553,8,'2001apr',alignment=0.0,orientation=0
;plots,[6550.0,6552.5],[10,10],color=fsc_color('grey'),linestyle=0,thick=3
;xyouts,6553,27,'1987jan',alignment=0.0,orientation=0
;plots,[6550.0,6552.5],[30,30],color=fsc_color('black'),linestyle=0,thick=2

device,/close
set_plot,'x'
!p.multi=[0, 0, 0, 0, 0]


END
