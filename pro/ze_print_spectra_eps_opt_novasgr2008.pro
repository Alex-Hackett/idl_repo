PRO ZE_PRINT_SPECTRA_EPS_OPT_NOVASGR2008,lambda08may08,flux08may08,lambda08may09,flux08may09

Angstrom = '!6!sA!r!u!9 %!6!n'
;set plot range
x1l=4520. & x1u=5020.
;x2l=4820. & x2u=4900.
x2l=-1500. & x2u=1500.

set_plot,'ps'
device,filename='/aux/pc244a/jgroh/temp/output_novasgr_opt.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches
!p.multi=[0, 1, 2, 0, 0]

;1st panel, 

plot,lambda08may08,flux08may08,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0,27],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']',$
ytitle='F/F!Ic',/nodata,charsize=1.5,XMARGIN=[8,3], YMARGIN=[2,1]
plots,lambda08may08,flux08may08,color=fsc_color('black'),noclip=0,clip=[x1l,0,x1u,27],thick=2
plots,lambda08may09,flux08may09,color=fsc_color('red',!d.table_size-10), noclip=0,clip=[x1l,0,x1u,27],linestyle=1,thick=2
;legends
plots, [4550,4590],[21,21],color=fsc_color('black'),thick=2
xyouts,4600,20,'2008 May 08',alignment=0.0,orientation=0,charsize=1.5
plots, [4550,4590],[16,16],color=fsc_color('red'),linestyle=1,thick=2
xyouts,4600,15,'2008 May 09',alignment=0.0,orientation=0,charsize=1.5


;2nd panel

;plot,lambda08may08,flux08may08,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[0,27],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
;ytitle='F/F!Ic',/nodata,charsize=1.5,XMARGIN=[8,3]
;plots,lambda08may08,flux08may08,color=fsc_color('black'),noclip=0,clip=[x2l,0,x2u,27],thick=2
;plots,lambda08may09,flux08may09,color=fsc_color('red',!d.table_size-10), noclip=0,clip=[x2l,0,x2u,27],linestyle=1,thick=2

;2nd panel
lambda2=4861.625
plot,ZE_LAMBDA_TO_VEL(lambda08may08,lambda2),flux08may08,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[0,27],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
ytitle='F/F!Ic',/nodata,charsize=1.5,XMARGIN=[8,3]
plots,ZE_LAMBDA_TO_VEL(lambda08may08,lambda2),flux08may08,color=fsc_color('black'),noclip=0,clip=[x2l,0,x2u,27],thick=2
plots,ZE_LAMBDA_TO_VEL(lambda08may09,lambda2),flux08may09,color=fsc_color('red',!d.table_size-10), noclip=0,clip=[x2l,0,x2u,27],linestyle=1,thick=2

device,/close
END
