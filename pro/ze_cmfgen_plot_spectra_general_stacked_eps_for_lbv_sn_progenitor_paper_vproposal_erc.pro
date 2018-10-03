PRO ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_FOR_LBV_SN_PROGENITOR_PAPER_VPROPOSAL_ERC,x,y,xtitle,ytitle,label,$
                                z1=z1,labelz=labelz,ct=ct,minz=minz,maxz=maxz,$
                                x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,xreverse=xreverse,yreverse=yreverse,_EXTRA=extra,timesteps=timesteps,$
                                pointsx2=pointsx2,pointsy2=pointsy2,id_lambda=id_lambda,id_text=id_text,id_ew=id_ew
;working on supporting multiple vectors on the same plot. right now for vector with the same number of points.
;working OK for x2,y2
    
close,/all
!P.MULTI=0

IF n_elements(ct) lt 1 THEN ct=33

IF KEYWORD_SET(REBIN) THEN BEGIN
    ZE_EVOL_REBIN_XYZ,x,y,xr,yr,z=z1,rebin_z=rebin_z
    IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x2,y2,x2r,y2r,z=z2,rebin_z=rebin_z2
    IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x3,y3,x3r,y3r,z=z3,rebin_z=rebin_z3
    IF ((N_elements(x4) gt 1) AND (N_elements(y4) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x4,y4,x4r,y4r,z=z4,rebin_z=rebin_z4
    IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x5,y5,x5r,y5r,z=z5,rebin_z=rebin_z5
    IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x6,y6,x6r,y6r,z=z6,rebin_z=rebin_z6
    IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x7,y7,x7r,y7r,z=z7,rebin_z=rebin_z7
    IF ((N_elements(x8) gt 1) AND (N_elements(y8) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x8,y8,x8r,y8r,z=z8,rebin_z=rebin_z8
    IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x9,y9,x9r,y9r,z=z9,rebin_z=rebin_z9
    IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x10,y10,x10r,y10r,z=z_10,rebin_z=rebin_z10
ENDIF ELSE BEGIN 
    xr=x
    yr=y
    IF N_elements(z1) GT 1 THEN rebin_z=z1
ENDELSE
posminx=0.12
posmaxx=0.87
posminy=0.1
posmaxy=0.95

IF (n_elements(xrange) LT 1) OR (n_elements(yrange) LT 1) THEN BEGIN 
  ZE_FIND_OPTIMAL_XYPLOT_RANGE,x,y,position,xrange,yrange

  IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN BEGIN 
    ZE_FIND_OPTIMAL_XYPLOT_RANGE,x2,y2,position,xrange2,yrange2
    xrange=[min([xrange[0],xrange2[0]]),max([xrange[1],xrange2[1]])]
    yrange=[min([yrange[0],yrange2[0]]),max([yrange[1],yrange2[1]])]
    ENDIF

  IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN BEGIN 
    ZE_FIND_OPTIMAL_XYPLOT_RANGE,x3,y3,position,xrange3,yrange3
    xrange=[min([xrange[0],xrange3[0]]),max([xrange[1],xrange3[1]])]
    yrange=[min([yrange[0],yrange3[0]]),max([yrange[1],yrange3[1]])]
    ENDIF

  IF ((N_elements(x4) GT 1) AND (N_elements(y4) GT 1)) THEN BEGIN 
    ZE_FIND_OPTIMAL_XYPLOT_RANGE,x4,y4,position,xrange4,yrange4
    xrange=[min([xrange[0],xrange4[0]]),max([xrange[1],xrange4[1]])]
    yrange=[min([yrange[0],yrange4[0]]),max([yrange[1],yrange4[1]])]
    ENDIF

  IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN BEGIN 
    ZE_FIND_OPTIMAL_XYPLOT_RANGE,x5,y5,position,xrange5,yrange5
    xrange=[min([xrange[0],xrange5[0]]),max([xrange[1],xrange5[1]])]
    yrange=[min([yrange[0],yrange5[0]]),max([yrange[1],yrange5[1]])]
    ENDIF

  IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN BEGIN 
    ZE_FIND_OPTIMAL_XYPLOT_RANGE,x6,y6,position,xrange6,yrange6
    xrange=[min([xrange[0],xrange6[0]]),max([xrange[1],xrange6[1]])]
    yrange=[min([yrange[0],yrange6[0]]),max([yrange[1],yrange6[1]])]
    ENDIF

  IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN BEGIN 
    ZE_FIND_OPTIMAL_XYPLOT_RANGE,x7,y7,position,xrange7,yrange7
    xrange=[min([xrange[0],xrange7[0]]),max([xrange[1],xrange7[1]])]
    yrange=[min([yrange[0],yrange7[0]]),max([yrange[1],yrange7[1]])]
    ENDIF

  IF ((N_elements(x8) GT 1) AND (N_elements(y8) GT 1)) THEN BEGIN 
    ZE_FIND_OPTIMAL_XYPLOT_RANGE,x8,y8,position,xrange8,yrange8
    xrange=[min([xrange[0],xrange8[0]]),max([xrange[1],xrange8[1]])]
    yrange=[min([yrange[0],yrange8[0]]),max([yrange[1],yrange8[1]])]
    ENDIF

  IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN BEGIN 
    ZE_FIND_OPTIMAL_XYPLOT_RANGE,x9,y9,position,xrange9,yrange9
    xrange=[min([xrange[0],xrange9[0]]),max([xrange[1],xrange9[1]])]
    yrange=[min([yrange[0],yrange9[0]]),max([yrange[1],yrange9[1]])]
    ENDIF

  IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN BEGIN 
    ZE_FIND_OPTIMAL_XYPLOT_RANGE,x10,y10,position,xrange10,yrange10
    xrange=[min([xrange[0],xrange10[0]]),max([xrange[1],xrange10[1]])]
    yrange=[min([yrange[0],yrange10[0]]),max([yrange[1],yrange10[1]])]
    ENDIF

ENDIF
IF KEYWORD_SET(XREVERSE) THEN XRANGE=REVERSE(XRANGE)
IF KEYWORD_SET(YREVERSE) THEN YRANGE=REVERSE(YRANGE)

;making psplots
set_plot,'ps'

device,/close

aa=700
bb=600
ps_ysize=10.
ps_xsize=ps_ysize*aa/bb

print,label
if N_elements(rebin_z) lt 1  THEN BEGIN
      psfilename='/Users/jgroh/temp/output_evol_'+xtitle+'_'+ytitle+'_'+label+'.eps'
ENDIF ELSE BEGIN 
     IF n_elements(labelz) LT 1 THEN labelz=''
      psfilename='/Users/jgroh/temp/output_evol_'+xtitle+'_'+ytitle+'_'+label+'_colorcoded_'+labelz+'.eps'
ENDELSE

device,filename=psfilename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches,/cmyk

!P.FONT=0
!X.thick=8
!Y.thick=8
!P.THICK=14
!X.THICK=12
!Y.THICK=12
!X.CHARSIZE=1.4
!Y.CHARSIZE=1.4
!P.CHARSIZE=2
!P.CHARTHICK=14
ticklen = 12.
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
a=2.0 ;line thick obs
b=3.5 ;line thick model
lm=2
lm2=1
coloro=fsc_color('black')
colorm=fsc_color('red')
colorm2=fsc_color('blue')
colorm3=fsc_color('green')

loadct,ct,/silent
if N_elements(rebin_z) lt 1  THEN BEGIN
  cgplot,x,y,xstyle=1,ystyle=1,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
/nodata,POSITION=[0.12,0.13,0.97,0.97],_STRICT_EXTRA=extra
  cgplots,x,y,color='blue',noclip=0
  IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN cgplots,x2,y2+1,color='red',noclip=0
  IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN cgplots,x3,y3+2,color='blue',noclip=0
  IF ((N_elements(x4) GT 1) AND (N_elements(y4) GT 1)) THEN cgplots,x4,y4+4,color='black',noclip=0
  IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN cgplots,x5,y5+6,color='magenta',noclip=0
  IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN cgplots,x6,y6+8,color='cyan',noclip=0
  IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN cgplots,x7,y7+10,color='orange',noclip=0
  IF ((N_elements(x8) GT 1) AND (N_elements(y8) GT 1)) THEN cgplots,x8,y8+12,color='purple',noclip=0    
  IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN cgplots,x9,y9+14,color='purple',noclip=0
  IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN cgplots,x10,y10+16,color='purple',noclip=0 
              
ENDIF ELSE BEGIN
  if n_elements(minz) lt 1 THEN minz=min(rebin_z)
  if n_elements(maxz) lt 1 THEN maxz=max(rebin_z)
  cgplot,x,y,xstyle=1,ystyle=1,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
/nodata,POSITION=[0.15,0.1,0.87,0.95],_STRICT_EXTRA=extra
  cgplots,xr,yr,noclip=0,color=bytscl(rebin_z,MIN=minz,MAX=maxz)
  IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN cgplots,x2r,y2r,noclip=0,color=bytscl(rebin_z2,MIN=minz,MAX=maxz)
  IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN cgplots,x3r,y3r,noclip=0,color=bytscl(rebin_z3,MIN=minz,MAX=maxz),linestyle=2
  IF ((N_elements(x4) GT 1) AND (N_elements(y4) GT 1)) THEN cgplots,x4r,y4r,noclip=0,color=bytscl(rebin_z4,MIN=minz,MAX=maxz),linestyle=2
  IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN cgplots,x5r,y5r,noclip=0,color=bytscl(rebin_z5,MIN=minz,MAX=maxz)
  IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN cgplots,x6r,y6r,noclip=0,color=bytscl(rebin_z6,MIN=minz,MAX=maxz)  
  IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN cgplots,x7r,y7r,noclip=0,color=bytscl(rebin_z7,MIN=minz,MAX=maxz)  
  IF ((N_elements(x8) GT 1) AND (N_elements(y8) GT 1)) THEN cgplots,x8r,y8r,noclip=0,color=bytscl(rebin_z8,MIN=minz,MAX=maxz) 
  IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN cgplots,x9r,y9r,noclip=0,color=bytscl(rebin_z9,MIN=minz,MAX=maxz)
  IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN cgplots,x10r,y10r,noclip=0,color=bytscl(rebin_z10,MIN=minz,MAX=maxz)   

  cgcolorbar,/vertical,/right,POSITION=[0.89,0.1,0.93,0.95],RANGE=[minz,maxz]
  xyouts,0.89,0.96,labelz,/NORMAL,color=fsc_color('black')
ENDELSE
;tmodel=[48386.4 ,  47031.9   ,  45796.1 , 39375.6  , 31088.6   ,  27864.3 ,   30783.7, 45243.1 , 56420.0  ,63351.2, 69550.6, 92369. ,140543.,136008.,133655. ,126228. ]
;
;lmodel=[507016. ,  528381.   ,  555083. , 645563.  , 719179.   ,  743098. ,   941860., 916947. , 897212.  ,883519.,  870531.,791920.,  350244., 434538.,507200.,545449.]
;timesteps=[56,500,1000,2500,3500,3800,5500,5820,6250,6551,6851,7201,11201,12551,14951,18950.]
if n_elements(timesteps) GT 0 THEN BEGIN
  cgplots,x[timesteps],y[timesteps],psym=4,symsize=3.
  for i=0, n_elements(timesteps) -1 DO xyouts,x[timesteps[i]],y[timesteps[i]],string(timesteps[i],format='(I5)'),/DATA,color=fsc_color('black'),charsize=1.5
endif

IF ((N_elements(x2points) GT 1) AND (N_elements(y2points) GT 1)) THEN cgplots,x2points,y2points,color='green',psym=4,symsize=3. 
;IF ((N_elements(x2points) GT 1) AND (N_elements(y2points) GT 1)) THEN cgplots,x2points,y2points,color='green',linestyle=2
;oploterror,pa1,vis1,errorvis1,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('dark grey'),symsize=2
;plots,pa1,vis1,color=c1,noclip=0,linestyle=0
;plots,pa2,vis2,color=c2,noclip=0,linestyle=2,thick=25
xyouts,0.17,0.15,label,/NORMAL,color=fsc_color('black')
;xyouts,5100,2.5,'AG Car observations 2002-Jul-04',/DATA,color=fsc_color('black'),charsize=2.5
;xyouts,5100,8.0,'pre-SN 20 Msun rot. model',/DATA,color=fsc_color('blue'),charsize=2.5
;xyouts,5100,12.0,'pre-SN 25 Msun rot. model',/DATA,color=fsc_color('blue'),charsize=2.5

id_Text_cut=id_text
for l=1., n_elements(id_lambda)-1. do begin
if (id_lambda[l] gt 4200) and (id_lambda[l] lt 6000) and (abs(id_ew[l]) gt 0.9) then begin
pos=strpos(strtrim(id_text[l],1),'(')
id_text_cut[l]=strmid(id_text[l],4,pos)
  if ((id_text_cut[l] EQ 'HeI') && (id_lambda[l] GT 5800.0)) then begin
     xyouts,id_lambda[l]-85,11.3,id_text_cut[l]+'!3'+string(45B),alignment=0.5,orientation=315,charsize=2.8,charthick=12,color=fsc_color('black')
  endif else if (id_text_cut[l] NE 'SiII') THEN xyouts,id_lambda[l]+15,11.3,'!3'+string(45B)+id_text_cut[l],alignment=0.5,orientation=90,charsize=2.8,charthick=12,color=fsc_color('black')

 ; if (id_text_cut[l] eq 'HI') then xyouts,id_lambda[l]+5,16,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('green')  ;colocando apenas um traco verde nas transicoes do H I
  ;if (id_text_cut[l] eq 'FeII') then xyouts,id_lambda[l]+5,16,'!3'+string(45B),alignment=0.5,orientation=90,charsize=charsize,charthick=charthick,color=fsc_color('purple')  ;colocando apenas um traco verde nas transicoes do H I
endif
endfor
;plots,lambdamod2,fluxmod2d23r/s/scale_full,color=colorm2,linestyle=lm2, noclip=0,clip=[x1l,0,x1u,1.9e-11/s],thick=b+1.5
;plots,lmcav,fmcavd23r/s/scale,color=colorm,linestyle=lm,noclip=0,clip=[1270.0,0,x1u,1.9e-11/s],thick=b+1.5

;putting labels on the first panel
;plots, [1270,1275],[0.41e-11/s,0.41e-11/s],color=coloro,thick=b+1.5
;xyouts,1277,0.40e-11/s,TEXTOIDL('obs \phi_{orb}=10.410 '),alignment=0,orientation=0,charsize=0.8
;plots, [1270,1275],[0.33e-11/s,0.33e-11/s],color=colorm2,thick=b+1.5,linestyle=lm
;xyouts,1277,0.32e-11/s,TEXTOIDL('1D CMFGEN model'),alignment=0,orientation=0,color=colorm2,charsize=0.8
;plots, [1270,1275],[0.25e-11/s,0.25e-11/s],color=colorm,thick=b+1.5
;xyouts,1277,0.24e-11/s,TEXTOIDL('2D cavity model'),alignment=0,orientation=0,color=colorm,charsize=0.8


;xyouts,400,2000,'Flux [10!E-12!N erg/s/cm!E2!N/'+Angstrom+' ]',charthick=3.5,orientation=90,/DEVICE

!p.multi=[0, 0, 0, 0, 0]
device,/close
set_plot,'x'
!P.FONT=-1
!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0
!Y.charsize=0
!X.charsize=0
!P.THICK=0
!X.THiCK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.MULTI=0
!X.THICK=0
!Y.THICK=0
!P.CHARTHICK=0
!P.CHARSIZE=0
!P.Background = fsc_color('white')
!Y.Type = 0
!X.Type = 0

END