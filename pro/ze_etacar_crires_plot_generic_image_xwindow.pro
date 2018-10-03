PRO ZE_ETACAR_CRIRES_PLOT_GENERIC_IMAGE_XWINDOW,img,a,b,lambda_newcal_vac_hel,cmi,cma,star,sub,row,aa,bb,pos,cumoffsetx,signcumoffsetx,lambda0

;choosing the correct direction for the x slit offset
IF signcumoffsetx eq -1 THEN direction='NE' ELSE  direction='SW'
IF signcumoffsetx eq -1 THEN cumoffsetx_plot=-1.*cumoffsetx ELSE  cumoffsetx_plot=cumoffsetx

;plotting in window
set_plot,'x'
window,19,xsize=aa,ysize=bb,retain=0,XPOS=30,YPOS=90
ticklen = 15.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
plot, lambda_newcal_vac_hel[*,row], [(cmi-star-sub)*0.086,(cma-star-sub)*0.086], XTICKFORMAT='(I6)',xstyle=1,ystyle=1, xtitle='Heliocentric vacuum wavelength (Angstrom)', ytitle='offset (arcsec)',$
/NODATA, Position=[0.07, 0.17, 0.94, 0.87],ycharsize=2,xcharsize=2,charthick=1.2,XRANGE=[min(lambda_newcal_vac_hel(*,row)),max(lambda_newcal_vac_hel(*,row))]
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
LOADCT, 13
;LOADCT,0
tvimage,img, /Overplot
;linear colorbar
nd=2
colorbar_ticknames_str = [number_formatter((b-a)*.0+a ,decimals=nd), number_formatter((b-a)*.2+a ,decimals=nd), number_formatter((b-a)*.4+a ,decimals=nd),$
number_formatter((b-a)*.6+a ,decimals=nd), number_formatter((b-a)*.8+a ,decimals=nd),number_formatter((b-a) +a ,decimals=nd)]
colorbar, COLOR=fsc_color('black'),DIVISIONS=5,TICKNAMES=colorbar_ticknames_str, /VERTICAL, /RIGHT,$
POSITION=[0.95, 0.17, 0.97, 0.87]
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
AXIS,XAXIS=1,XTICKFORMAT='(I5)',XSTYLE=1,COLOR=fsc_color('black'),XTITLE='Heliocentric velocity (km/s)',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_newcal_vac_hel[*,row]),lambda0*10^4),ZE_LAMBDA_TO_VEL(max(lambda_newcal_vac_hel[*,row]),lambda0*10^4)],xcharsize=2,charthick=1.2
AXIS,XAXIS=1,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[ZE_LAMBDA_TO_VEL(min(lambda_newcal_vac_hel[*,row]),lambda0*10^4),ZE_LAMBDA_TO_VEL(max(lambda_newcal_vac_hel[*,row]),lambda0*10^4)],xcharsize=0
AXIS,XAXIS=0,XTICKFORMAT='(A2)',XSTYLE=1,COLOR=fsc_color('white'),XTITLE='',XRANGE=[min(lambda_newcal_vac_hel(*,row)),max(lambda_newcal_vac_hel(*,row))],xcharsize=2
AXIS,YAXIS=0,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=0,YRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
AXIS,YAXIS=1,YSTYLE=1,COLOR=fsc_color('white'),ycharsize=2,YRANGE=[(cmi-star-sub)*0.086,(cma-star-sub)*0.086],ytickv=4,YTICKFORMAT='(A2)'
xyouts,1230,360,TEXTOIDL('F/Fmax'),/DEVICE,color=fsc_color('black')
xyouts,0.25,0.80,'Pos'+strcompress(STRING(FIX(pos)))+', '+number_formatter(cumoffsetx_plot*0.085,decimals=2)+' '+direction+' '+TEXTOIDL('PA=325^o'),/NORMAL,color=fsc_color('white')






END