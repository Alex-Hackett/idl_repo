PRO ZE_PRINT_SPECTRA_EPS_OPT_91_93,lambda91may1,flux91may1,lambda91ago1,flux91ago1,lambda91ago2,flux91ago2,lambda91oct1,flux91oct1,$
l191narv,f191narv,l93narv,f93narv,l198narv,f198narv,ewdata

t=SIZE(ewdata.lambda) & i=t[1]

sobc=strarr(i)

Angstrom = '!6!sA!r!u!9 %!6!n'
;set plot range
x1l=6671. & x1u=6685.
x2l=6553. & x2u=6575.
x3l=3917.3 & x3u=3930.
x4l=1080. & x4u=1180.
x7l=3790. & x7u=4170.
x8l=4300. & x8u=4820.
;x8l=4650. & x8u=4730.
x9l=4850. & x9u=4873.
x10l=6420. & x10u=7350.
x11l=9990. & x11u=10080.
x12l=6540. & x12u=6715.
x13l=4670. & x13u=4725.
x14l=10770. & x14u=10965.
set_plot,'x'
;normalizing interactively
;LOADCT,0
;colors = GetColor(/Load)
;!P.Background = colors.white
;!P.Color = colors.black
;line_norm,lambda91ago2,flux91ago2,norm1,xnodes1,ynodes1

set_plot,'ps'
device,filename='/Users/jgroh/temp/output_opt_9193.eps',/encapsulated,/color,bit=8,xsize=6.48,ysize=8.48,/inches
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

lambda_val=6500.
near = Min(Abs(l191narv-lambda_val), index)
dl=l191narv[index]-l191narv[index-1]
res90aug=1.0

t=cnvlgauss(f191narv,fwhm=res90aug/dl)

plot,lambda91ago1,flux91ago1,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[-0.5,22.0], xtickinterval=10,$
ytitle='F/F!Ic',/nodata,charsize=2,XMARGIN=[8,3],charthick=charthickv/1.4,$
POSITION=[0.09,0.80,0.36,0.99]
plots,lambda91ago1,flux91ago1,color=fsc_color('grey'),noclip=0,clip=[x2l,0,x2u,29],thick=to
plots,l191narv,t,color=fsc_color('black'), noclip=0,clip=[x2l,0,x2u,29],linestyle=0,thick=tm
xyouts,6554,17.5,'a)91aug'+TEXTOIDL('     H\alpha'),alignment=0.0,orientation=0,charthick=charthickv

!p.multi[0]=4

;2nd panel
ZE_SPEC_CNVL,l191narv,f191narv,1.,10000.,f191c100
plot,lambda91ago1,flux91ago1,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.3,2.6],$
/nodata,charsize=2,XTICKINTERVAL=5.,charthick=charthickv,$
POSITION=[0.42,0.80,0.68,0.99]
plots,lambda91ago1,flux91ago1,color=fsc_color('grey'),noclip=0,clip=[x1l,0,x1u,13],thick=to
plots,l191narv,((f191c100-1.0)*1.2)+1.0,color=fsc_color('black',!d.table_size-10), noclip=0,clip=[x1l,0,x1u,13],linestyle=0,thick=tm
xyouts,6672,2.2,'b)91aug  He I 6678',alignment=0.0,orientation=0,charthick=charthickv

!p.multi[0]=4

;3rd panel
plot,lambda91ago2,flux91ago2,xstyle=1,ystyle=1,xrange=[x11l,x11u],yrange=[0.6,3.1],$
/nodata,charsize=2,charthick=charthickv,xtickinterval=50.,XTICKFORMAT='(I7.0)',$
POSITION=[0.74,0.80,0.99,0.99]
plots,lambda91ago2,flux91ago2,color=fsc_color('grey'),noclip=0,clip=[x11l,0,x11u,13],thick=to
plots,l191narv,((f191c100-1.0)*1.1)+1.0,color=fsc_color('black',!d.table_size-10), noclip=0,clip=[x11l,0,x11u,13],linestyle=0,thick=tm
xyouts,10000,2.7,'c)91aug',alignment=0.0,orientation=0,charthick=charthickv

;4th panel
ZE_SPEC_CNVL,l198narv,f198narv,1.,6500.,f198c66
plot,lambda91oct1,flux91oct1,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[-0.5,22.0], xtickinterval=10,$
ytitle='F/F!Ic',/nodata,charsize=2,XMARGIN=[8,3],charthick=charthickv/1.4,$
POSITION=[0.09,0.56,0.36,0.75]
plots,lambda91oct1,flux91oct1,color=fsc_color('grey'),noclip=0,clip=[x2l,0,x2u,29],thick=to
plots,l198narv,f198c66,color=fsc_color('black'), noclip=0,clip=[x2l,0,x2u,29],linestyle=0,thick=tm
xyouts,6554,17.5,'d)91oct'+TEXTOIDL('     H\alpha'),alignment=0.0,orientation=0,charthick=charthickv

!p.multi[0]=3

;5th panel

plot,lambda91oct1,flux91oct1,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0.3,2.6],$
/nodata,charsize=2,XTICKINTERVAL=5.,charthick=charthickv,$
POSITION=[0.42,0.56,0.68,0.75]
plots,lambda91oct1,flux91oct1,color=fsc_color('grey'),noclip=0,clip=[x1l,0,x1u,13],thick=to
plots,l198narv,f198c66,color=fsc_color('black',!d.table_size-10), noclip=0,clip=[x1l,0,x1u,13],linestyle=0,thick=tm
xyouts,6672,2.2,'e)91oct  He I 6678',alignment=0.0,orientation=0,charthick=charthickv

!p.multi[0]=3

;6th panel
 plot,lambda91may1,flux91may1,xstyle=1,ystyle=1,xrange=[x14l,x14u],yrange=[-0.6,11.5],$
/nodata,charsize=2,charthick=charthickv,xtickinterval=50.,XTICKFORMAT='(I7.0)',$
POSITION=[0.74,0.56,0.99,0.75]
plots,lambda91may1,flux91may1,color=fsc_color('grey'),noclip=0,clip=[x14l,0,x14u,13],thick=to
plots,l93narv,f93narv,color=fsc_color('black',!d.table_size-10), noclip=0,clip=[x14l,0,x14u,13],linestyle=0,thick=tm
xyouts,10000,2.7,'f)91may',alignment=0.0,orientation=0,charthick=charthickv




;2nd panel
;
;plot,lambda90jun1-1.0,flux90jun1,xstyle=1,ystyle=1,xrange=[x9l,x9u],yrange=[0.8,5.55], $
;ytitle='F/F!Ic',$
;/nodata,charsize=2,XMARGIN=[5,3],POSITION=[0.08,0.56,0.28,0.75],XTICKINTERVAL=5.,charthick=charthickv
;plots,lambda90jun1-1.0,flux90jun1*1.0,color=fsc_color('grey'),noclip=0,clip=[x9l,0,x9u,13],thick=to
;plots,l191narv,t,color=fsc_color('black'), noclip=0,clip=[x9l,0,x9u,13],linestyle=0,thick=tm
;xyouts,4852,5.00,'b)90jun   '+TEXTOIDL('H\beta'),alignment=0.0,orientation=0,charsize=1.0,charthick=charthickv
;
;;3rd panel, 
;;
;lambda_val=6500.
;near = Min(Abs(l223narv-lambda_val), index)
;dl=l191narv[index]-l191narv[index-1]
;resjun902=1.8
;t=cnvlgauss(f191narv,fwhm=resjun902/dl)
;;
;plot,lambda90jun2-1.0,flux90jun2,xstyle=1,ystyle=1,xrange=[x10l,x10u],yrange=[0.5,3.55], $
;/nodata,charsize=2,XMARGIN=[5,3],POSITION=[0.34,0.56,0.97,0.75],charthick=charthickv
;plots,lambda90jun2-1.0,flux90jun2,color=fsc_color('grey'),noclip=0,clip=[x10l,0.5,x10u,3.55],thick=to
;plots,l191narv,t,color=fsc_color('black'), noclip=0,clip=[x10l,0.5,x10u,3.55],linestyle=0,thick=tm
;xyouts,6802,3.00,'c)90jun',alignment=0.0,orientation=0,charsize=1.0,charthick=charthickv
;for l=0, i-1 do begin
;if (ewdata.lambda[l] gt x10l+10) and (ewdata.lambda[l] lt x10u) and (abs(ewdata.ew[l]) gt 0.3) then begin
;pos=strpos(strtrim(ewdata.sob[l],1),'(')
;sobc[l]=strmid(ewdata.sob[l],0,pos)
;if ((sobc[l] ne 'NIII') && (sobc[l] ne 'HI')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
;xyouts,ewdata.lambda[l]+3,2.6,'!3'+string(45B)+sobc[l],alignment=0.0,orientation=90,charthick=charthickv
;endif
;endif
;endfor
;
;!p.multi[0]=2
;
;;4th panel
;ZE_SPEC_CNVL,l191narv,f191narv,1.,10000.,f191c100
;plot,lambda90jun3,flux90jun3,xstyle=1,ystyle=1,xrange=[x11l,x11u],yrange=[0.8,2], xtickinterval=50.,$
;ytitle='F/F!Ic',$
;/nodata,charsize=2,XMARGIN=[5,3],POSITION=[0.10,0.32,0.28,0.51],charthick=charthickv,YMARGIN=[2,0.5],XTICKFORMAT='(I7.0)'
;plots,lambda90jun3,flux90jun3*1.03,color=fsc_color('grey'),noclip=0,clip=[x11l,0.8,x11u,3],thick=to
;plots,l191narv,f191c100,color=fsc_color('black'), noclip=0,clip=[x11l,0.8,x11u,3],linestyle=0,thick=tm
;xyouts,10000,1.8,'d)90jun',alignment=0.0,orientation=0,charthick=charthickv
;
;;5th panel
;plot,lambda90dec1,flux90dec1,xstyle=1,ystyle=1,xrange=[x12l,x12u],yrange=[0,12], $
;/nodata,charsize=c1,XMARGIN=[5/c1,3/c1],YMARGIN=[5,3],charthick=charthickv,POSITION=[0.34,0.32,0.97,0.51]
;plots,lambda90dec1,flux90dec1,color=fsc_color('grey'),noclip=0,clip=[x12l,0,x12u,12],thick=to
;plots,l223narv,f223narv,color=fsc_color('black'), noclip=0,clip=[x12l,0,x12u,12],linestyle=0,thick=tm
;xyouts,6565,10.5,TEXTOIDL('H\alpha')+'       e)90dec',alignment=0.0,orientation=0,charthick=charthickv
;for l=0, i-1 do begin
;if (ewdata.lambda[l] gt x12l+10) and (ewdata.lambda[l] lt x12u) and (abs(ewdata.ew[l]) gt 0.3) then begin
;pos=strpos(strtrim(ewdata.sob[l],1),'(')
;sobc[l]=strmid(ewdata.sob[l],0,pos)
;if ((sobc[l] ne 'NIII') && (sobc[l] ne 'HI')) then begin ;colocando apenas um traco nas transicoes do FeV,normal para os outros.
;xyouts,ewdata.lambda[l]+3,2.9,'!3'+string(45B)+sobc[l],alignment=0.0,orientation=90,charthick=charthickv
;endif
;endif
;endfor
;
;!p.multi[0]=1
;ZE_SPEC_CNVL,l223narv,f223narv,1.,10000.,f223c100
;
;;6th panel
;plot,lambda90dec2,flux90dec2,xstyle=1,ystyle=1,xrange=[x11l,x11u],yrange=[0.8,2], xtickinterval=50.,$
;ytitle='F/F!Ic',xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+' ]',$
;/nodata,charsize=2,XMARGIN=[5,3],POSITION=[0.10,0.08,0.28,0.27],charthick=charthickv,YMARGIN=[2,0.5],XTICKFORMAT='(I7.0)'
;plots,lambda90dec2,flux90dec2*1.02,color=fsc_color('grey'),noclip=0,clip=[x11l,0.8,x11u,3],thick=to
;plots,l223narv,f223c100,color=fsc_color('black'), noclip=0,clip=[x11l,0.8,x11u,3],linestyle=0,thick=tm
;xyouts,10000,1.8,'f)90dec',alignment=0.0,orientation=0,charthick=charthickv
;
;!p.multi[0]=1
;
;;7th panel
;plot,lambda91jan1,flux91jan1,xstyle=1,ystyle=1,xrange=[x13l,x13u],yrange=[0.8,2.2], xtickinterval=20.,xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+' ]',$
;/nodata,charsize=2,XMARGIN=[5,3],POSITION=[0.40,0.08,0.97,0.27],charthick=charthickv,YMARGIN=[2,0.5],XTICKFORMAT='(I7.0)'
;plots,lambda91jan1,flux91jan1*1.02,color=fsc_color('grey'),noclip=0,clip=[x13l,0.8,x13u,3],thick=to
;plots,l223narv,f223narv,color=fsc_color('black'), noclip=0,clip=[x13l,0.8,x13u,3],linestyle=0,thick=tm
;xyouts,4700.,1.8,'g)91jan',alignment=0.0,orientation=0,charthick=charthickv
;xyouts,4686,1.4,'!3'+string(45B)+'HeII',alignment=0.0,orientation=90,charthick=charthickv
;xyouts,4714,1.8,'!3'+string(45B)+'HeI',alignment=0.0,orientation=90,charthick=charthickv

device,/close
set_plot,'x'
!p.multi=[0, 0, 0, 0, 0]
END
;--------------------------------------------------------------------------------------------------------------------------
