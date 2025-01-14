PRO ZE_PRINT_SPECTRA_EPS_OPT_90_91,lambda90jun1,flux90jun1,lambda90jun2,flux90jun2,lambda90jun3,flux90jun3,$
lambda90dec1,flux90dec1,lambda90dec2,flux90dec2,lambda91jan1,flux91jan1,$
l358narv,f358narv,l391narv,f391narv,l392narv,f392narv,l363narv,f363narv,l223narv,f223narv,l367narv,f367narv,ewdata

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
x10l=6420. & x10u=7350.
x11l=9990. & x11u=10080.
x12l=6540. & x12u=6715.
x13l=4670. & x13u=4725.
set_plot,'ps'
device,filename='/aux/pc20072b/jgroh/temp/output_opt_91.eps',/encapsulated,/color,bit=8,xsize=6.48,ysize=8.48,/inches
!X.OMARGIN=[-1,-1]
!Y.OMARGIN=[10.5,-1.]
!p.multi=[0, 1, 4, 0, 0]
!X.THICK=1.7
!Y.THICK=1.7
to=2
tm=2


;1st panel, 
c1=2
charthickv=1.7

lambda_val=4600.
near = Min(Abs(l367narv-lambda_val), index)
dl=l367narv[index]-l367narv[index-1]
resmar89=1.5
;resmar89=0.01

t=cnvlgauss(f367narv,fwhm=resmar89/dl)
ZE_SPEC_CNVL,l392narv,f392narv,1.8,4600.,f392c48
plot,lambda90jun1-0.78,flux90jun1,xstyle=1,ystyle=1,xrange=[x8l,x8u],yrange=[0.5,3.0], $
ytitle='F/F!Ic',/nodata,charsize=2,XMARGIN=[8,3],charthick=charthickv/1.4,POSITION=[0.09,0.80,0.97,0.99]
plots,lambda90jun1-0.78,flux90jun1,color=fsc_color('grey'),noclip=0,clip=[x8l,0,x8u,13],thick=to
;plots,l367narv,t,color=fsc_color('black'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=tm
plots,l392narv,f392c48,color=fsc_color('black'), noclip=0,clip=[x8l,0,x8u,13],linestyle=0,thick=tm
xyouts,4590,2.6,'a) 90jun',alignment=0.0,orientation=0,charthick=charthickv
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
print,!p.multi

;2nd panel

plot,lambda90jun1-1.0,flux90jun1,xstyle=1,ystyle=1,xrange=[x9l,x9u],yrange=[0.8,5.55], $
ytitle='F/F!Ic',$
/nodata,charsize=2,XMARGIN=[5,3],POSITION=[0.08,0.56,0.28,0.75],XTICKINTERVAL=10.,charthick=charthickv
plots,lambda90jun1-1.0,flux90jun1*1.0,color=fsc_color('grey'),noclip=0,clip=[x9l,0,x9u,13],thick=to
plots,l367narv,t,color=fsc_color('black'), noclip=0,clip=[x9l,0,x9u,13],linestyle=0,thick=tm
xyouts,4852,5.00,'b)90jun   '+TEXTOIDL('H\beta'),alignment=0.0,orientation=0,charsize=1.0,charthick=charthickv

;3rd panel, 
;
lambda_val=6500.
near = Min(Abs(l223narv-lambda_val), index)
dl=l367narv[index]-l367narv[index-1]
resjun902=1.8
t=cnvlgauss(f367narv,fwhm=resjun902/dl)
;
plot,lambda90jun2-1.0,flux90jun2,xstyle=1,ystyle=1,xrange=[x10l,x10u],yrange=[0.5,3.55], $
/nodata,charsize=2,XMARGIN=[5,3],POSITION=[0.34,0.56,0.97,0.75],charthick=charthickv
plots,lambda90jun2-1.0,flux90jun2,color=fsc_color('grey'),noclip=0,clip=[x10l,0.5,x10u,3.55],thick=to
plots,l367narv,t,color=fsc_color('black'), noclip=0,clip=[x10l,0.5,x10u,3.55],linestyle=0,thick=tm
xyouts,6802,3.00,'c)90jun',alignment=0.0,orientation=0,charsize=1.0,charthick=charthickv
for l=0, i-1 do begin
if (ewdata.lambda[l] gt x10l+10) and (ewdata.lambda[l] lt x10u) and (abs(ewdata.ew[l]) gt 0.3) then begin
pos=strpos(strtrim(ewdata.sob[l],1),'(')
sobc[l]=strmid(ewdata.sob[l],0,pos)
if ((sobc[l] ne 'NIII') && (sobc[l] ne 'HI')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,ewdata.lambda[l]+3,2.6,'!3'+string(45B)+sobc[l],alignment=0.0,orientation=90,charthick=charthickv
endif
endif
endfor

!p.multi[0]=2

;4th panel
ZE_SPEC_CNVL,l367narv,f367narv,1.,10000.,f367c100
plot,lambda90jun3,flux90jun3,xstyle=1,ystyle=1,xrange=[x11l,x11u],yrange=[0.8,2], xtickinterval=50.,$
ytitle='F/F!Ic',$
/nodata,charsize=2,XMARGIN=[5,3],POSITION=[0.10,0.32,0.28,0.51],charthick=charthickv,YMARGIN=[2,0.5],XTICKFORMAT='(I7.0)'
plots,lambda90jun3,flux90jun3*1.03,color=fsc_color('grey'),noclip=0,clip=[x11l,0.8,x11u,3],thick=to
plots,l367narv,f367c100,color=fsc_color('black'), noclip=0,clip=[x11l,0.8,x11u,3],linestyle=0,thick=tm
xyouts,10000,1.8,'d)90jun',alignment=0.0,orientation=0,charthick=charthickv

;5th panel
plot,lambda90dec1,flux90dec1,xstyle=1,ystyle=1,xrange=[x12l,x12u],yrange=[0,12], $
/nodata,charsize=c1,XMARGIN=[5/c1,3/c1],YMARGIN=[5,3],charthick=charthickv,POSITION=[0.34,0.32,0.97,0.51]
plots,lambda90dec1,flux90dec1,color=fsc_color('grey'),noclip=0,clip=[x12l,0,x12u,12],thick=to
plots,l223narv,f223narv,color=fsc_color('black'), noclip=0,clip=[x12l,0,x12u,12],linestyle=0,thick=tm
xyouts,6565,10.5,TEXTOIDL('H\alpha')+'       e)90dec',alignment=0.0,orientation=0,charthick=charthickv
for l=0, i-1 do begin
if (ewdata.lambda[l] gt x12l+10) and (ewdata.lambda[l] lt x12u) and (abs(ewdata.ew[l]) gt 0.3) then begin
pos=strpos(strtrim(ewdata.sob[l],1),'(')
sobc[l]=strmid(ewdata.sob[l],0,pos)
if ((sobc[l] ne 'NIII') && (sobc[l] ne 'HI')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
xyouts,ewdata.lambda[l]+3,2.9,'!3'+string(45B)+sobc[l],alignment=0.0,orientation=90,charthick=charthickv
endif
endif
endfor

!p.multi[0]=1
ZE_SPEC_CNVL,l223narv,f223narv,1.,10000.,f223c100

;6th panel
plot,lambda90dec2,flux90dec2,xstyle=1,ystyle=1,xrange=[x11l,x11u],yrange=[0.8,2], xtickinterval=50.,$
ytitle='F/F!Ic',xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+' ]',$
/nodata,charsize=2,XMARGIN=[5,3],POSITION=[0.10,0.08,0.28,0.27],charthick=charthickv,YMARGIN=[2,0.5],XTICKFORMAT='(I7.0)'
plots,lambda90dec2,flux90dec2*1.02,color=fsc_color('grey'),noclip=0,clip=[x11l,0.8,x11u,3],thick=to
plots,l223narv,f223c100,color=fsc_color('black'), noclip=0,clip=[x11l,0.8,x11u,3],linestyle=0,thick=tm
xyouts,10000,1.8,'f)90dec',alignment=0.0,orientation=0,charthick=charthickv

!p.multi[0]=1

;7th panel
plot,lambda91jan1,flux91jan1,xstyle=1,ystyle=1,xrange=[x13l,x13u],yrange=[0.8,2.2], xtickinterval=20.,xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+' ]',$
/nodata,charsize=2,XMARGIN=[5,3],POSITION=[0.40,0.08,0.97,0.27],charthick=charthickv,YMARGIN=[2,0.5],XTICKFORMAT='(I7.0)'
plots,lambda91jan1,flux91jan1*1.02,color=fsc_color('grey'),noclip=0,clip=[x13l,0.8,x13u,3],thick=to
plots,l223narv,f223narv,color=fsc_color('black'), noclip=0,clip=[x13l,0.8,x13u,3],linestyle=0,thick=tm
xyouts,4700.,1.8,'g)91jan',alignment=0.0,orientation=0,charthick=charthickv
xyouts,4686,1.4,'!3'+string(45B)+'HeII',alignment=0.0,orientation=90,charthick=charthickv
xyouts,4714,1.8,'!3'+string(45B)+'HeI',alignment=0.0,orientation=90,charthick=charthickv

device,/close
set_plot,'x'
!p.multi=[0, 0, 0, 0, 0]
END
;--------------------------------------------------------------------------------------------------------------------------
