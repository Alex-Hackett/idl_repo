
PRO ZE_PRINT_SPECTRA_EPS_OPT_86_87,lambda86jun1,flux86jun1,lambda87jan1,flux87jan1,lambda87jan2,flux87jan2,lambda87jun1,flux87jun1,$
lambda87jun2,flux87jun2,l362narv,f362narv,l223narv,f223narv,ewdata

t=SIZE(ewdata.lambda) & i=t[1]

sobc=strarr(i)

Angstrom = '!6!sA!r!u!9 %!6!n'
;set plot range
x1l=5865. & x1u=5887.
x2l=6550. & x2u=6575.
x3l=3917.3 & x3u=3940.
x4l=1080. & x4u=1180.

set_plot,'ps'
device,filename='/aux/pc244a/jgroh/temp/output_opt.eps',/encapsulated,/color,bit=8,xsize=6.48,ysize=8.48,/inches
!p.multi=[0, 3, 4, 0, 0]

;1st panel, 

plot,lambda86jun1,flux86jun1,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0,5.5],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']',$
ytitle='F/F!Ic',/nodata,charsize=1,XMARGIN=[5,3]
plots,lambda86jun1,flux86jun1,color=fsc_color('black'),noclip=0,clip=[x1l,0,x1u,13]
plots,l362narv,f362narv,color=fsc_color('red',!d.table_size-10), noclip=0,clip=[x1l,0,x1u,13],linestyle=1,thick=3.5
xyouts,5870,4.5,'86jun',alignment=0.0,orientation=0


;2nd panel

plot,lambda86jun1,flux86jun1,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[0,13],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
ytitle='F/F!Ic',/nodata,charsize=1,XMARGIN=[5,3]
plots,lambda86jun1-0.2,flux86jun1,color=fsc_color('black'),noclip=0,clip=[x2l,0,x2u,13]
plots,l362narv,f362narv,color=fsc_color('red'), noclip=0,clip=[x2l,0,x2u,13],linestyle=1,thick=3.5
xyouts,6552,11,'86jun',alignment=0.0,orientation=0

;3rd panel, 

plot,lambda87jan1,flux87jan1,xstyle=1,ystyle=1,xrange=[x1l,x1u],yrange=[0,5.5],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']',$
ytitle='F/F!Ic',/nodata,charsize=1,XMARGIN=[5,3]
plots,lambda87jan1,flux87jan1,color=fsc_color('black'),noclip=0,clip=[x1l,0,x1u,13]
plots,l362narv,f362narv,color=fsc_color('red',!d.table_size-10), noclip=0,clip=[x1l,0,x1u,13],linestyle=1,thick=3.5
xyouts,5870,4.5,'87jan',alignment=0.0,orientation=0

;4th panel

plot,lambda87jan2-0.1,flux87jan2,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[0,13],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
ytitle='F/F!Ic',/nodata,charsize=1,XMARGIN=[5,3]
plots,lambda87jan2-0.1,flux87jan2,color=fsc_color('black'),noclip=0,clip=[x2l,0,x2u,13]
plots,l223narv,f223narv,color=fsc_color('red'), noclip=0,clip=[x2l,0,x2u,13],linestyle=1,thick=3.5
xyouts,6552,11,'87jan',alignment=0.0,orientation=0

;5th panel, 

plot,lambda87jun1,flux87jun1,xstyle=1,ystyle=1,xrange=[x3l,x3u],yrange=[0.1,1.5],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']',$
ytitle='F/F!Ic',/nodata,charsize=1,XMARGIN=[7,3]
plots,lambda87jun1+0.1,flux87jun1,color=fsc_color('black'),noclip=0,clip=[x3l,0,x3u,13]
plots,l362narv,f362narv/1.1,color=fsc_color('red',!d.table_size-10), noclip=0,clip=[x3l,0,x3u,13],linestyle=1,thick=3.5
xyouts,3920,0.5,'87jun',alignment=0.0,orientation=0
for l=0, i-1 do begin
if (ewdata.lambda[l] gt x3l) and (ewdata.lambda[l] lt x3u) and (abs(ewdata.ew[l]) gt 0.1) then begin
pos=strpos(strtrim(ewdata.sob[l],1),'(')
sobc[l]=strmid(ewdata.sob[l],0,pos)
xyouts,ewdata.lambda[l]+0.2,1.2,'!3'+string(45B)+sobc[l],alignment=0.0,orientation=90
endif
endfor
xyouts,3933,1.2,'!3'+string(45B)+'  I.S.',alignment=0.0,orientation=90

;6th panel

plot,lambda87jun2-0.1,flux87jun2,xstyle=1,ystyle=1,xrange=[x2l,x2u],yrange=[0,13],xtitle=TEXTOIDL('\lambda')+' ['+Angstrom+']', $
ytitle='F/F!Ic',/nodata,charsize=1,XMARGIN=[5,3]
plots,lambda87jun2-0.1,flux87jun2,color=fsc_color('black'),noclip=0,clip=[x2l,0,x2u,13]
plots,l223narv,f223narv,color=fsc_color('red'), noclip=0,clip=[x2l,0,x2u,13],linestyle=1,thick=3.5
xyouts,6552,4,'87jun',alignment=0.0,orientation=0

device,/close
END
;--------------------------------------------------------------------------------------------------------------------------
