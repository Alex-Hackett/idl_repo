Angstrom = '!6!sA!r!u!9 %!6!n'
close,/all

;defining observations
obs86jun1='/Users/jgroh/espectros/agcar/agc86jun18_all.txt'
obs87jan1='/Users/jgroh/espectros/agcar/agc87jan00_58.txt'
obs87jan2='/Users/jgroh/espectros/agcar/agc87jan05_66_new_es.txt'
obs87jun1='/Users/jgroh/espectros/agcar/agc87jun10_39.txt'
obs87jun2='/Users/jgroh/espectros/agcar/agc87jun10_66_new_es.txt'
;obs87jun2='/Users/jgroh/espectros/agcar/agc90dec28_66_new_es.txt'
obs89mar1='/Users/jgroh/espectros/agcar/agc_89mar26_38a49_OBzoo.txt'
;obs89mar1='/Users/jgroh/espectros/agcar/ag_car_21jan91.txt'
obs01apr='/Users/jgroh/espectros/agcar/agc01apr12_35a90.txt'

ZE_READ_SPECTRA_COL_VEC,obs87jan1,lambda87jan1,flux87jan1
ZE_READ_SPECTRA_COL_VEC,obs87jun2,lambda87jun2,flux87jun2
ZE_READ_SPECTRA_COL_VEC,obs89mar1,lambda89mar1,flux89mar1
;ZE_READ_SPECTRA_COL_VEC,obs01apr,lambda01apr,flux01apr

lambda_val=4696.
near = Min(Abs(lambda01apr-lambda_val), index)
dl=lambda01apr[index]-lambda01apr[index-1]
resmar89=1.5

t=cnvlgauss(flux01apr,fwhm=resmar89/dl)


;set plot range
x2l=5865. & x2u=5887.
x3l=6545. & x3u=6580.
x1l=4650. & x1u=4700.

a=8.48
b=6.48

set_plot,'ps'
device,filename='/Users/jgroh/temp/output_min_comp.eps',/encapsulated,/color,bit=8,xsize=a,ysize=b,/inches
!p.multi=[0, 1, 3, 0, 0]

ticklen = 0.15
yticklen = ticklen/a
xticklen = ticklen/b*3.

tc=8
ta=2.
to=4.
ca=2.3
!X.OMARGIN=[4,1]
!Y.OMARGIN=[2.3,-0.3]

!X.THICK=3.5
!Y.THICK=3.5
!P.CHARTHICK=3.5
!P.CHARSIZE=1.4
!Y.charsize=1.6
!X.charsize=1.6
!P.THICK=10
!X.THiCK=10
!Y.THICK=10
!P.CHARTHICK=8
!P.FONT=-1
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
;1st panel, 

plot,lambda89mar1,flux89mar1,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.9,1.78], $
ytitle='F/F!dcont',/nodata,charsize=ca,XMARGIN=[8,3],YMARGIN=[3,1],charthick=tc, ytickinterval=0.2,xticklen=xticklen, yticklen=yticklen
plots,lambda89mar1,flux89mar1,color=fsc_color('black'),noclip=0,clip=[x1l,0,x1u,2.5]
plots,lambda01apr,t,color=fsc_color('red'), noclip=0,clip=[x1l,0,x1u,2],linestyle=2
xyouts,4670,1.45,'2001 Apr',alignment=0.0,orientation=0
plots,[4666,4669],[1.48,1.48],color=fsc_color('red'),linestyle=2
xyouts,4670,1.6,'1989 Mar',alignment=0.0,orientation=0
plots,[4666,4669],[1.62,1.62],color=fsc_color('black'),linestyle=0

xyouts,4686,1.35,'!3'+string(45B)+'HeII',alignment=0.0,orientation=90,charthick=tc-2,charsize=1.2
xyouts,4659,1.32,'!3'+string(45B)+'[FeIII]',alignment=0.0,orientation=90,charthick=tc-2,charsize=1.2

;2nd panel
plot,lambda87jan1,flux87jan1,charthick=tc,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[0.0,8.5],ytickinterval=4.0,ytickformat='(F5.1)',$
ytitle='F/F!dcont',/nodata,charsize=ca,XMARGIN=[8,3],YMARGIN=[3,1],xticklen=xticklen, yticklen=yticklen
plots,lambda87jan1,flux87jan1,color=fsc_color('black'),noclip=0,clip=[x2l,0,x2u,13]
plots,lambda01apr,flux01apr,color=fsc_color('red',!d.table_size-10), noclip=0,clip=[x2l,0,x2u,13],linestyle=2
xyouts,5869.5,5.0,'2001 Apr',alignment=0.0,orientation=0
plots,[5867.5,5869],[5.38,5.38],color=fsc_color('red'),linestyle=2
xyouts,5869.5,6.3,'1987 Jan',alignment=0.0,orientation=0
plots,[5867.5,5869],[6.58,6.58],color=fsc_color('black'),linestyle=0
xyouts,5880,5.35,'He I 5876',alignment=0.0,orientation=0,charthick=tc,charsize=2


;3rd panel, 
plot,lambda87jun2-0.2,flux87jun2,/ylog,xstyle=1,ystyle=1,xrange=[x3l,x3u],yrange=[0.1,100],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+' ]', $
ytitle='F/F!dcont',/nodata,charsize=ca,XMARGIN=[9,3],YMARGIN=[3,1],charthick=tc,xtickinterval=10.0,xticklen=xticklen, yticklen=yticklen
plots,lambda87jun2-0.2,flux87jun2,color=fsc_color('black'),noclip=0,clip=[x3l,0.1,x3u,100]
plots,lambda01apr,flux01apr,color=fsc_color('red'),noclip=0,clip=[x3l,0.1,x3u,100],linestyle=2

xyouts,6553,8,'2001 Apr',alignment=0.0,orientation=0
plots,[6550.0,6552.5],[10,10],color=fsc_color('red'),linestyle=2
xyouts,6553,27,'1987 Jan',alignment=0.0,orientation=0
plots,[6550.0,6552.5],[30,30],color=fsc_color('black'),linestyle=0
xyouts,6570,20.35,TEXTOIDL('H\alpha'),alignment=0.0,orientation=0,charthick=tc,charsize=2

device,/close
set_plot,'x'
!p.multi=[0, 0, 0, 0, 0]


END
