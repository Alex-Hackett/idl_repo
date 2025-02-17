
PRO ZE_PRINT_SPECTRA_EPS_OPT_86_90,lambda86jun1,flux86jun1,lambda87jan1,flux87jan1,lambda87jan2,flux87jan2,lambda87jun1,flux87jun1,$
lambda87jun2,flux87jun2,lambda89mar1,flux89mar1,l358narv,f358narv,l391narv,f391narv,l392narv,f392narv,l363narv,f363narv,$
l223narv,f223narv,l367narv,f367narv,ewdata
t=SIZE(ewdata.lambda) & i=t[1]

sobc=strarr(i)

Angstrom = '!6!sA!r!u!9 %!6!n'
;set plot range
x1l=5865. & x1u=5887.
x2l=6550. & x2u=6575.
x3l=3917.3 & x3u=3930.
x4l=1080. & x4u=1180.
x7l=3790. & x7u=4170.
x8l=4300. & x8u=4820.
;x8l=4650. & x8u=4730
x9l=4850. & x9u=4873.

set_plot,'ps'
device,filename='/aux/pc20072b/jgroh/temp/output_opt.eps',/encapsulated,/color,bit=8,xsize=6.48,ysize=8.48,/inches
!X.OMARGIN=[4.5,0.5]
!Y.OMARGIN=[0.5,0.5]
!p.multi=[0, 3, 4, 0, 0]
!X.THICK=1.7
!Y.THICK=1.7
to=2
tm=2


;1st panel, 
c1=2
charthickv=1.7
plot,lambda86jun1,flux86jun1,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0,5.5],$
ytitle='F/F!Ic',/nodata,charsize=c1,XMARGIN=[5/c1,3/c1],YMARGIN=[5/c1,3/c1],XTICKINTERVAL=10.,charthick=charthickv
plots,lambda86jun1,flux86jun1,color=fsc_color('grey'),noclip=0,clip=[x1l,0,x1u,13],thick=to
plots,l223narv,f223narv,color=fsc_color('black',!d.table_size-10), noclip=0,clip=[x1l,0,x1u,13],linestyle=0,thick=tm
xyouts,5866,4.5,'a)86jun  He I 5876',alignment=0.0,orientation=0,charthick=charthickv


;2nd panel

plot,lambda86jun1,flux86jun1,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[0,14], $
/nodata,charsize=c1,XMARGIN=[5/c1,3/c1],YMARGIN=[5/c1,3/c1],XTICKINTERVAL=10.,charthick=charthickv
plots,lambda86jun1-0.2,flux86jun1,color=fsc_color('grey'),noclip=0,clip=[x2l,0,x2u,14],thick=to
plots,l358narv,f358narv,color=fsc_color('black'), noclip=0,clip=[x2l,0,x2u,14],linestyle=0,thick=tm
xyouts,6552,11,'b)86jun       '+TEXTOIDL('H\alpha'),alignment=0.0,orientation=0,charthick=charthickv

;3rd panel, 

plot,lambda87jan1,flux87jan1,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0,5.5],$
/nodata,charsize=c1,XMARGIN=[5/c1,3/c1],YMARGIN=[5/c1,3/c1],XTICKINTERVAL=10.,charthick=charthickv
plots,lambda87jan1,flux87jan1,color=fsc_color('grey'),noclip=0,clip=[x1l,0,x1u,13],thick=to
plots,l223narv,f223narv,color=fsc_color('black',!d.table_size-10), noclip=0,clip=[x1l,0,x1u,13],linestyle=0,thick=tm

xyouts,5866,4.5,'c)87jan  He I 5876',alignment=0.0,orientation=0,charthick=charthickv

;4th panel

plot,lambda87jan2-0.1,flux87jan2,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[0,13],$
ytitle='F/F!Ic',/nodata,charsize=c1,XMARGIN=[5/c1,3/c1],YMARGIN=[5/c1,3/c1],XTICKINTERVAL=10.,charthick=charthickv
plots,lambda87jan2-0.1,flux87jan2,color=fsc_color('grey'),noclip=0,clip=[x2l,0,x2u,13],thick=to
plots,l223narv,f223narv,color=fsc_color('black',!d.table_size-10), noclip=0,clip=[x2l,0,x2u,13],linestyle=0,thick=tm
xyouts,6552,11,'d)87jan       '+TEXTOIDL('H\alpha'),alignment=0.0,orientation=0,charthick=charthickv

;5th panel, 

plot,lambda87jun1,flux87jun1,xstyle=1,ystyle=1,xrange=[x3l,x3u],yrange=[0.75,1.4],$
/nodata,charsize=c1,XMARGIN=[7/c1,3/c1],YMARGIN=[5/c1,3/c1],XTICKINTERVAL=4.,charthick=charthickv
plots,lambda87jun1+0.1,flux87jun1,color=fsc_color('grey'),noclip=0,clip=[x3l,0.75,x3u,1.4],thick=to
plots,l367narv,f367narv/1.05,color=fsc_color('black',!d.table_size-10), noclip=0,clip=[x3l,0.75,x3u,1.4],linestyle=0,thick=tm
xyouts,3920,1.3,'e)87jun',alignment=0.0,orientation=0,charthick=charthickv
for l=0, i-1 do begin
if (ewdata.lambda[l] gt x3l) and (ewdata.lambda[l] lt x3u) and (abs(ewdata.ew[l]) gt 0.1) then begin
pos=strpos(strtrim(ewdata.sob[l],1),'(')
sobc[l]=strmid(ewdata.sob[l],0,pos)
xyouts,ewdata.lambda[l]+0.2,1.25,'!3'+string(45B)+sobc[l],alignment=0.0,orientation=90,charthick=charthickv
endif
endfor
;xyouts,3933,1.2,'!3'+string(45B)+'  I.S.',alignment=0.0,orientation=90

;6th panel

plot,lambda87jun2-0.1,flux87jun2,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[0,13], $
/nodata,charsize=c1,XMARGIN=[5/c1,3/c1],YMARGIN=[5/c1,3/c1],XTICKINTERVAL=10.,charthick=charthickv
plots,lambda87jun2-0.1,flux87jun2,color=fsc_color('grey'),noclip=0,clip=[x2l,0,x2u,13],thick=to
plots,l223narv,f223narv,color=fsc_color('black'), noclip=0,clip=[x2l,0,x2u,13],linestyle=0,thick=tm
xyouts,6552,11,'f)87jun        '+TEXTOIDL('H\alpha'),alignment=0.0,orientation=0,charthick=charthickv

;7th panel
l367narv=l223narv
f367narv=f223narv
lambda_val=4600.
near = Min(Abs(l367narv-lambda_val), index)
dl=l367narv[index]-l367narv[index-1]
resmar89=1.5
;resmar89=0.01

t=cnvlgauss(f367narv,fwhm=resmar89/dl)

plot,lambda89mar1-0.15,flux89mar1,xstyle=1,ystyle=1,xrange=[x7l,x7u],yrange=[0.5,2.7], $
ytitle='F/F!Ic',/nodata,charsize=2,XMARGIN=[8,3],POSITION=[0.09,0.27,0.985,0.49],charthick=charthickv
plots,lambda89mar1-0.15,flux89mar1,color=fsc_color('grey'),noclip=0,clip=[x7l,0,x7u,13],thick=to
plots,l367narv,t/1.00,color=fsc_color('black'), noclip=0,clip=[x7l,0,x7u,13],linestyle=0,thick=tm
xyouts,3940,2.45,'g)89mar',alignment=0.0,orientation=0,charthick=charthickv
for l=0, i-1 do begin
if (ewdata.lambda[l] gt x7l+10) and (ewdata.lambda[l] lt x7u) and (abs(ewdata.ew[l]) gt 0.3) then begin
pos=strpos(strtrim(ewdata.sob[l],1),'(')
sobc[l]=strmid(ewdata.sob[l],0,pos)
if ((sobc[l] ne 'HeI') && (sobc[l] ne 'FeVI')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,ewdata.lambda[l]+3,2.0,'!3'+string(45B)+sobc[l],alignment=0.0,orientation=90,charthick=charthickv
endif
if (sobc[l] eq 'HeI') then begin
xyouts,ewdata.lambda[l]+3,1.6,'!3'+string(45B)+sobc[l],alignment=0.0,orientation=90,charthick=charthickv
endif
endif
endfor
xyouts,3934,1.1,'!3'+string(45B)+' I.S.',alignment=0.0,orientation=90,charthick=charthickv
xyouts,3903,1.8,'HeI+HI',alignment=0.0,orientation=90,charthick=charthickv
xyouts,3896.5,1.6,'!3'+string(45B),alignment=0.0,orientation=60,charthick=charthickv


;8th panel
plot,lambda89mar1-0.15,flux89mar1,xstyle=1,ystyle=1,xrange=[x8l,x8u],yrange=[0.5,3.0],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+' ]', $
;plot,lambda89mar1-0.15,flux89mar1,xstyle=1,ystyle=1,xrange=[x8l,x8u],yrange=[0.5,1.5],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
ytitle='F/F!Ic',/nodata,charsize=2,XMARGIN=[8,3],POSITION=[0.09,0.05,0.72,0.24],charthick=charthickv
plots,lambda89mar1-0.15,flux89mar1,color=fsc_color('grey'),noclip=0,clip=[x8l,0,x8u,13],thick=to
plots,l367narv,t,color=fsc_color('black'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=tm
xyouts,4570,2.7,'h) 89mar',alignment=0.0,orientation=0,charthick=charthickv
for l=0, i-1 do begin
if (ewdata.lambda[l] gt x8l+10) and (ewdata.lambda[l] lt x8u) and (abs(ewdata.ew[l]) gt 0.3) then begin
pos=strpos(strtrim(ewdata.sob[l],1),'(')
sobc[l]=strmid(ewdata.sob[l],0,pos)
if ((sobc[l] ne 'NIII') && (sobc[l] ne 'NII'))then begin ;
xyouts,ewdata.lambda[l]+3,2.1,'!3'+string(45B)+sobc[l],alignment=0.0,orientation=90,charthick=charthickv
endif
if ((ewdata.lambda[l] lt 4600) && (sobc[l] eq 'NII')) then begin
xyouts,ewdata.lambda[l]+3,1.6,'!3'+string(45B)+sobc[l],alignment=0.0,orientation=90,charthick=charthickv
endif
if ((ewdata.lambda[l] gt 4670) && (sobc[l] eq 'NII')) then begin
xyouts,ewdata.lambda[l]+3,1.6,'!3'+string(45B)+sobc[l],alignment=0.0,orientation=90,charthick=charthickv
endif
endif
endfor
xyouts,4357,2.0,'HI',alignment=0.0,orientation=90,charthick=charthickv
xyouts,4349.5,1.8,'!3'+string(45B),alignment=0.0,orientation=60,charthick=charthickv


;9th panel
plot,lambda89mar1-0.5,flux89mar1,xstyle=1,ystyle=1,xrange=[x9l,x9u],yrange=[0.8,5.55],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+' ]', $
;ytitle='F/F!Ic',$
/nodata,charsize=2,XMARGIN=[5,3],POSITION=[0.78,0.05,0.98,0.24],XTICKINTERVAL=10.,charthick=charthickv
plots,lambda89mar1-0.5,flux89mar1,color=fsc_color('grey'),noclip=0,clip=[x9l,0,x9u,13],thick=to
plots,l367narv,t,color=fsc_color('black'), noclip=0,clip=[x9l,0,x9u,13],linestyle=0,thick=tm
xyouts,4852,5.00,'i)89mar   '+TEXTOIDL('H\beta'),alignment=0.0,orientation=0,charsize=1.0,charthick=charthickv

device,/close
set_plot,'x'
!p.multi=[0, 0, 0, 0, 0]
END
;--------------------------------------------------------------------------------------------------------------------------
