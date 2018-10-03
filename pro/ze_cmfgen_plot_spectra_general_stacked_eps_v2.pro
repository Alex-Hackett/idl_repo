PRO ZE_CMFGEN_PLOT_SPECTRA_GENERAL_STACKED_EPS_V2,x,y,xtitle,ytitle,label,$
                                z1=z1,labelz=labelz,ct=ct,minz=minz,maxz=maxz,$
                                x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,x11=x11,y11=y11,x12=x12,y12=y12,$
                                z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,z_11=z_11,z_12=z_12,$
                                rebin=rebin,xreverse=xreverse,yreverse=yreverse,_EXTRA=extra,timesteps=timesteps,$
                                pointsx2=pointsx2,pointsy2=pointsy2,psympoints2=psympoints2,symcolorpoints2=symcolorpoints2,symsizepoints2=symsizepoints2,pointsx3=pointsx3,pointsy3=pointsy3,psympoints3=psympoints3,symsizepoints3=symsizepoints3,symcolorpoints3=symcolorpoints3,$
                                pointsx4=pointsx4,pointsy4=pointsy4,psympoints4=psympoints4,symcolorpoints4=symcolorpoints4,symsizepoints4=symsizepoints4,$
                                psym1=psym1,symsize1=symsize1,symcolor1=symcolor1,$
                                psym2=psym2,symsize2=symsize2,symcolor2=symcolor2,psym3=psym3,symsize3=symsize3,symcolor3=symcolor3,psym4=psym4,symsize4=symsize4,symcolor4=symcolor4,psym5=psym5,symsize5=symsize5,symcolor5=symcolor5,$
                                psym6=psym6,symsize6=symsize6,symcolor6=symcolor6,psym7=psym7,symsize7=symsize7,symcolor7=symcolor7,psym8=psym8,symsize8=symsize8,symcolor8=symcolor8,$
                                info=info,color1=color1,color2=color2,color3=color3,color4=color4,color5=color5,color6=color6,color7=color7,color8=color8,color9=color9,color_10=color_10,color_11=color_11,color_12=color_12,$
                                linestyle1=linestyle1,linestyle2=linestyle2,linestyle3=linestyle3,linestyle4=linestyle4,linestyle5=linestyle5,linestyle6=linestyle6,linestyle7=linestyle7,linestyle8=linestyle8,linestyle9=linestyle9,linestyle_10=linestyle_10,linestyle_11=linestyle_11,linestyle_12=linestyle_12,$
                                factor1=factor1,factor2=factor2,factor3=factor3,factor4=factor4,factor5=factor5,factor6=factor6,factor7=factor7,factor8=factor8,factor9=factor9,factor_10=factor_10,factor_11=factor_11,factor_12=factor_12,$
                                plot_last=plot_last,id_lambda=id_lambda,id_text=id_text,id_ew=id_ew,ewmin=ewmin,id_ypos=id_ypos,xrange=xrange,yrange=yrange,id_xoffset=id_xoffset,$
                                filename=filename,bands=bands,aa=aa,bb=bb,size_id_text=size_id_text,xthick=xthick,ythick=ythick,pthick=pthick,pcharthick=pcharthick,$
                                xcharsize=xcharsize,ycharsize=ycharsize,pcharsize=pcharsize,ticklen=ticklen,elem=elem
                                

close,/all
!P.MULTI=0

if n_elements(aa) eq 0 then aa=800
if n_elements(bb) eq 0 then bb=600

if n_elements(xthick) eq 0 then xthick=12
if n_elements(ythick) eq 0 then ythick=12
if n_elements(pthick) eq 0 then pthick=14
if n_elements(pcharthick) eq 0 then pcharthick=12
if n_elements(pcharsize) eq 0 then pcharsize=2
if n_elements(xcharsize) eq 0 then xcharsize=1.4
if n_elements(ycharsize) eq 0 then ycharsize=1.4
if n_elements(ticklen) eq 0 then ticklen=15

IF n_elements(ct) lt 1 THEN ct=0
LOADCT,0,/SILENT
IF n_elements(color1) lt 1 THEN color1='black'
IF n_elements(color2) lt 1 THEN color2='red'
IF n_elements(color3) lt 1 THEN color3='blue'
IF n_elements(color4) lt 1 THEN color4='dark green'
IF n_elements(color5) lt 1 THEN color5='orange'
IF n_elements(color6) lt 1 THEN color6='cyan'
IF n_elements(color7) lt 1 THEN color7='purple'
IF n_elements(color8) lt 1 THEN color8='magenta'
IF n_elements(color9) lt 1 THEN color9='green'
IF n_elements(color_10) lt 1 THEN color_10='dark grey'
IF n_elements(color_11) lt 1 THEN color_11='charcoal'
IF n_elements(color_12) lt 1 THEN color_12='chocolate'
IF n_elements(linestyle1) lt 1 THEN linestyle1=0
IF n_elements(linestyle2) lt 1 THEN linestyle2=0
IF n_elements(linestyle3) lt 1 THEN linestyle3=0
IF n_elements(linestyle4) lt 1 THEN linestyle4=0
IF n_elements(linestyle5) lt 1 THEN linestyle5=0
IF n_elements(linestyle6) lt 1 THEN linestyle6=0
IF n_elements(linestyle7) lt 1 THEN linestyle7=0
IF n_elements(linestyle8) lt 1 THEN linestyle8=0
IF n_elements(linestyle9) lt 1 THEN linestyle9=0
IF n_elements(linestyle_10) lt 1 THEN linestyle_10=0
IF n_elements(linestyle_11) lt 1 THEN linestyle_11=0
IF n_elements(linestyle_12) lt 1 THEN linestyle_12=0
IF n_elements(factor1) lt 1 THEN factor1=10.0
IF n_elements(factor2) lt 1 THEN factor2=factor1
IF n_elements(factor3) lt 1 THEN factor3=factor1
IF n_elements(factor4) lt 1 THEN factor4=factor1
IF n_elements(factor5) lt 1 THEN factor5=factor1
IF n_elements(factor6) lt 1 THEN factor6=factor1
IF n_elements(factor7) lt 1 THEN factor7=factor1
IF n_elements(factor8) lt 1 THEN factor8=factor1
IF n_elements(factor9) lt 1 THEN factor9=factor1
IF n_elements(factor_10) lt 1 THEN factor_10=factor1
IF n_elements(factor_11) lt 1 THEN factor_11=factor1
IF n_elements(factor_12) lt 1 THEN factor_12=factor1


IF KEYWORD_SET(REBIN) THEN BEGIN
    ZE_EVOL_REBIN_XYZ,x,y,xr,yr,z=z1,rebin_z=rebin_z,factor=factor1
    IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x2,y2,x2r,y2r,z=z2,rebin_z=rebin_z2,factor=factor2
    IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x3,y3,x3r,y3r,z=z3,rebin_z=rebin_z3,factor=factor3
    IF ((N_elements(x4) gt 1) AND (N_elements(y4) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x4,y4,x4r,y4r,z=z4,rebin_z=rebin_z4,factor=factor4
    IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x5,y5,x5r,y5r,z=z5,rebin_z=rebin_z5,factor=factor5
    IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x6,y6,x6r,y6r,z=z6,rebin_z=rebin_z6,factor=factor6
    IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x7,y7,x7r,y7r,z=z7,rebin_z=rebin_z7,factor=factor7
    IF ((N_elements(x8) gt 1) AND (N_elements(y8) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x8,y8,x8r,y8r,z=z8,rebin_z=rebin_z8,factor=factor8
    IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x9,y9,x9r,y9r,z=z9,rebin_z=rebin_z9,factor=factor9
    IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x10,y10,x10r,y10r,z=z_10,rebin_z=rebin_z10,factor=factor_10
    IF ((N_elements(x11) GT 1) AND (N_elements(y11) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x11,y11,x11r,y11r,z=z_11,rebin_z=rebin_z11,factor=factor_11    
    IF ((N_elements(x12) GT 1) AND (N_elements(y12) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x12,y12,x12r,y12r,z=z_12,rebin_z=rebin_z12,factor=factor_12        
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

if n_elements(info) GT 0 then xreverse=info.xreverse
if n_elements(info) GT 0 then yreverse=info.yreverse
IF KEYWORD_SET(XREVERSE) THEN XRANGE=REVERSE(XRANGE)
IF KEYWORD_SET(YREVERSE) THEN YRANGE=REVERSE(YRANGE)

;making psplots
set_plot,'ps'

device,/close

ps_ysize=10.
ps_xsize=ps_ysize*aa/bb

if n_elements(label) LT 1 THEN label=''
print,label
if N_elements(rebin_z) lt 1  THEN BEGIN
      filename_prefix='/Users/jgroh/temp/output_evol_'
      filename_sufix=xtitle+'_'+ytitle+'_'+label+'.eps'     
      ZE_REMOVE_SPECIAL_CHARACTERS_FROM_STRING,filename_sufix
      psfilename=filename_prefix+filename_sufix
ENDIF ELSE BEGIN 
     IF n_elements(labelz) LT 1 THEN labelz=''
      filename_prefix='/Users/jgroh/temp/output_evol_'
      filename_sufix=xtitle+'_'+ytitle+'_'+label+'_colorcoded_'+labelz+'.eps'
      ZE_REMOVE_SPECIAL_CHARACTERS_FROM_STRING,filename_sufix
      psfilename=filename_prefix+filename_sufix
ENDELSE

If n_elements(filename) GT 0 THEN psfilename='/Users/jgroh/temp/'+filename+'.eps'

device,filename=psfilename,/encapsulated,/color,bit=8,xsize=ps_xsize,ysize=ps_ysize,/inches,cmyk=0

!X.thick=xthick
!Y.thick=ythick
!P.THICK=pthick
!X.CHARSIZE=xcharsize
!Y.CHARSIZE=ycharsize
!P.CHARSIZE=pcharsize
!P.CHARTHICK=pcharthick
!P.FONT=0
ticklen = ticklen
!x.ticklen = ticklen/bb
!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

loadct,ct,/silent

if N_elements(rebin_z) lt 1  THEN BEGIN ;no Z values to do color-coding
   if keyword_set(rebin) THEN BEGIN;datah as been rebinned
       cgplot,xr,yr,xstyle=1,ystyle=1,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
       /nodata,POSITION=[0.06,0.13,0.97,0.97],_STRICT_EXTRA=extra
       cgplots,xr,yr,color=color1,noclip=0,psym=psym1,symsize=symsize1,symcolor=symcolor1,linestyle=linestyle1
       IF ((N_elements(x2r) GT 1) AND (N_elements(y2r) GT 1)) THEN cgplots,x2r,y2r,color=color2,noclip=0,psym=psym2,symsize=symsize2,symcolor=symcolor2,linestyle=linestyle2
       IF ((N_elements(x3r) GT 1) AND (N_elements(y3r) GT 1)) THEN cgplots,x3r,y3r,color=color3,noclip=0,psym=psym3,symsize=symsize3,symcolor=symcolor3,linestyle=linestyle3
       IF ((N_elements(x4r) GT 1) AND (N_elements(y4r) GT 1)) THEN cgplots,x4r,y4r,color=color4,noclip=0,linestyle=linestyle4
       IF ((N_elements(x5r) GT 1) AND (N_elements(y5r) GT 1)) THEN cgplots,x5r,y5r,color=color5,noclip=0,linestyle=linestyle5
       IF ((N_elements(x6r) GT 1) AND (N_elements(y6r) GT 1)) THEN cgplots,x6r,y6r,color=color6,noclip=0,linestyle=linestyle6
       IF ((N_elements(x7r) GT 1) AND (N_elements(y7r) GT 1)) THEN cgplots,x7r,y7r,color=color7,noclip=0,linestyle=linestyle7
       IF ((N_elements(x8r) GT 1) AND (N_elements(y8r) GT 1)) THEN cgplots,x8r,y8r,color=color8,noclip=0,linestyle=linestyle8
       IF ((N_elements(x9r) GT 1) AND (N_elements(y9r) GT 1)) THEN cgplots,x9r,y9r,color=color9,noclip=0,linestyle=linestyle9
       IF ((N_elements(x10r) GT 1) AND (N_elements(y10r) GT 1)) THEN cgplots,x10r,y10r,color=color_10,noclip=0 ,linestyle=linestyle_10
       IF ((N_elements(x11r) GT 1) AND (N_elements(y11r) GT 1)) THEN cgplots,x11r,y11r,noclip=0,color=color_11,linestyle=linestyle_11    
       IF ((N_elements(x12r) GT 1) AND (N_elements(y12r) GT 1)) THEN cgplots,x12r,y12r,noclip=0,color=color_12,linestyle=linestyle_12                     
       
   ENDIF ELSE BEGIN; data has not been rebinned
       cgplot,x,y,xstyle=1,ystyle=1,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
       /nodata,POSITION=[0.06,0.13,0.97,0.97],_STRICT_EXTRA=extra 
       cgplots,x,y,color=color1,noclip=0,psym=psym1,symsize=symsize1,symcolor=symcolor1,linestyle=linestyle1
       IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN cgplots,x2,y2,color=color2,noclip=0,psym=psym2,symsize=symsize2,symcolor=symcolor2,linestyle=linestyle2
       IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN cgplots,x3,y3,color=color3,noclip=0,psym=psym3,symsize=symsize3,symcolor=symcolor3,linestyle=linestyle3
       IF ((N_elements(x4) GT 1) AND (N_elements(y4) GT 1)) THEN cgplots,x4,y4,color=color4,noclip=0,psym=psym4,symsize=symsize4,symcolor=symcolor4,linestyle=linestyle4
       IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN cgplots,x5,y5,color=color5,noclip=0,psym=psym5,symsize=symsize5,symcolor=symcolor5,linestyle=linestyle5
       IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN cgplots,x6,y6,color=color6,noclip=0,psym=psym6,symsize=symsize6,symcolor=symcolor6,linestyle=linestyle6
       IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN cgplots,x7,y7,color=color7,noclip=0,psym=psym7,symsize=symsize7,symcolor=symcolor7,linestyle=linestyle7
       IF ((N_elements(x8) GT 1) AND (N_elements(y8) GT 1)) THEN cgplots,x8,y8,color=color8,noclip=0,psym=psym8,symsize=symsize8,symcolor=symcolor8,linestyle=linestyle8   
       IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN cgplots,x9,y9,color=color9,noclip=0,linestyle=linestyle9
       IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN cgplots,x10,y10,color=color_10,noclip=0 ,linestyle=linestyle_10
       IF ((N_elements(x11) GT 1) AND (N_elements(y11) GT 1)) THEN cgplots,x11,y11,noclip=0,color=color_11,linestyle=linestyle_11    
       IF ((N_elements(x12) GT 1) AND (N_elements(y12) GT 1)) THEN cgplots,x12,y12,noclip=0,color=color_12,linestyle=linestyle_12                  
   ENDELSE           
ENDIF ELSE BEGIN ;always plot rebinned data
  if n_elements(minz) lt 1 THEN minz=min(rebin_z)
  if n_elements(maxz) lt 1 THEN maxz=max(rebin_z)
  cgplot,x,y,xstyle=1,ystyle=1,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
/nodata,POSITION=[0.06,0.13,0.87,0.95],_STRICT_EXTRA=extra
  cgplots,xr,yr,noclip=0,color=bytscl(rebin_z,MIN=minz,MAX=maxz),linestyle=linestyle1
  IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN cgplots,x2r,y2r,noclip=0,color=bytscl(rebin_z2,MIN=minz,MAX=maxz),linestyle=linestyle2
  IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN cgplots,x3r,y3r,noclip=0,color=bytscl(rebin_z3,MIN=minz,MAX=maxz),linestyle=linestyle3
  IF ((N_elements(x4) GT 1) AND (N_elements(y4) GT 1)) THEN cgplots,x4r,y4r,noclip=0,color=bytscl(rebin_z4,MIN=minz,MAX=maxz),linestyle=linestyle4
  IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN cgplots,x5r,y5r,noclip=0,color=bytscl(rebin_z5,MIN=minz,MAX=maxz),linestyle=linestyle5
  IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN cgplots,x6r,y6r,noclip=0,color=bytscl(rebin_z6,MIN=minz,MAX=maxz),linestyle=linestyle6 
  IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN cgplots,x7r,y7r,noclip=0,color=bytscl(rebin_z7,MIN=minz,MAX=maxz),linestyle=linestyle7  
  IF ((N_elements(x8) GT 1) AND (N_elements(y8) GT 1)) THEN cgplots,x8r,y8r,noclip=0,color=bytscl(rebin_z8,MIN=minz,MAX=maxz),linestyle=linestyle8 
  IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN cgplots,x9r,y9r,noclip=0,color=bytscl(rebin_z9,MIN=minz,MAX=maxz),linestyle=linestyle9
  IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN cgplots,x10r,y10r,noclip=0,color=bytscl(rebin_z10,MIN=minz,MAX=maxz),linestyle=linestyle_10   
  IF ((N_elements(x11) GT 1) AND (N_elements(y11) GT 1)) THEN cgplots,x11r,y11r,noclip=0,color=bytscl(rebin_z11,MIN=minz,MAX=maxz),linestyle=linestyle_11   
  IF ((N_elements(x12) GT 1) AND (N_elements(y12) GT 1)) THEN cgplots,x12r,y12r,noclip=0,color=bytscl(rebin_z12,MIN=minz,MAX=maxz),linestyle=linestyle_12          

  cgcolorbar,/vertical,/right,POSITION=[0.89,0.1,0.93,0.95],RANGE=[minz,maxz];,annotatecolor=
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


IF ((N_elements(pointsx2) GT 1) AND (N_elements(pointsy2) GT 1)) THEN cgplots,pointsx2,pointsy2,psym=psympoints2,symcolor=symcolorpoints2,symsize=symsizepoints2
IF ((N_elements(pointsx3) GT 1) AND (N_elements(pointsy3) GT 1)) THEN cgplots,pointsx3,pointsy3,psym=psympoints3,symcolor=symcolorpoints3,symsize=symsizepoints3
IF ((N_elements(pointsx4) GT 1) AND (N_elements(pointsy4) GT 1)) THEN cgplots,pointsx4,pointsy4,psym=psympoints4,symcolor=symcolorpoints4,symsize=symsizepoints4

If KEYWORD_SET(id_text) THEN BEGIN
  if N_elements(size_id_text) eq 0 then size_id_text=2.2
  found_line_overlap=0
  id_Text_cut=id_text
  for l=1., n_elements(id_lambda)-1. do begin
   index_overlap1=l
   if ((id_lambda[l] gt min(xrange)) && (id_lambda[l] lt max(xrange)) && (abs(id_ew[l]) gt ewmin)) then begin  
    xyouts,2.0,2.0,ALIGN=0.5, 'HII', WIDTH=thisWidth,charsize=size_id_text,charthick=12, /NORMAL,orientation=0
    COORD_CONV,0,0,xlowleg,ylowleg,/NORMAL   
    COORD_CONV,thisWidth,thisWidth,xupleg,yupleg,/NORMAL
    xwidthleg=xupleg[0]-xlowleg[0]
    ywidthleg=yupleg[0]-ylowleg[0] 
    IF KEYword_set(id_xoffset) THEN lv=lv ELSE id_xoffset=0.005
    COORD_CONV,id_lambda[l],id_ypos,xlegold,ylegold
    COORD_CONV,xlegold[1]+id_xoffset,ylegold[1],id_lambdanew,id_yposnew,/NORMAL
    lambda_offset_ang=id_lambdanew-id_lambda[l]    
 
     FOR s=l+1, l+101 DO BEGIN ;will scan next 100 lines for overlapping lines
      IF (abs(id_ew[s]) gt ewmin) and (id_lambda[s] lt id_lambda[l]+xwidthleg) THEN BEGIN
       found_line_overlap=found_line_overlap+1
       index_overlap1=[index_overlap1,s]
       print,index_overlap1       
      ENDIF
     ENDFOR
    print,'found_line_overlap',found_line_overlap

    IF found_line_overlap EQ 2 THEN BEGIN   
      xyouts,id_lambda[index_overlap1[0]]+lambda_offset_ang,id_yposnew[0],'-',alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0
      xyouts,id_lambda[index_overlap1[1]]+lambda_offset_ang,id_yposnew[0],'-',alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0
      xyouts,id_lambda[index_overlap1[2]]+lambda_offset_ang,id_yposnew[0],'-',alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0

      IF (id_text[index_overlap1[0]] EQ id_text[index_overlap1[1]]) AND (id_text[index_overlap1[1]] EQ id_text[index_overlap1[2]]) THEN BEGIN ;all 3 lines from the same ion
       xyouts,(id_lambda[index_overlap1[0]]+id_lambda[index_overlap1[1]]+id_lambda[index_overlap1[2]])/3.+lambda_offset_ang,id_yposnew[0]+ywidthleg,id_text[index_overlap1[0]],alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0
          
      ENDIF ELSE IF (id_text[index_overlap1[0]] EQ id_text[index_overlap1[1]]) AND (id_text[index_overlap1[1]] NE id_text[index_overlap1[2]]) THEN BEGIN; lines 1 and 2 from the same ion, 3 is different
       xyouts,id_lambda[index_overlap1[0]]+lambda_offset_ang,id_yposnew[0]+ywidthleg,id_text[index_overlap1[0]],alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0   
       xyouts,id_lambda[index_overlap1[0]]+lambda_offset_ang+xwidthleg*0.6,id_yposnew[0]+ywidthleg,'  +',alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0 
       xyouts,id_lambda[index_overlap1[0]]+lambda_offset_ang+xwidthleg*1.3,id_yposnew[0]+ywidthleg,id_text[index_overlap1[2]],alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0  
        
      ENDIF ELSE IF (id_text[index_overlap1[0]] NE id_text[index_overlap1[1]]) AND (id_text[index_overlap1[0]] EQ id_text[index_overlap1[2]]) THEN BEGIN; lines 1 and 3 from the same ion, 2 is different
       xyouts,id_lambda[index_overlap1[0]]+lambda_offset_ang,id_yposnew[0]+ywidthleg,id_text[index_overlap1[0]],alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0   
       xyouts,id_lambda[index_overlap1[0]]+lambda_offset_ang+xwidthleg*0.6,id_yposnew[0]+ywidthleg,'  +',alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0 
       xyouts,id_lambda[index_overlap1[0]]+lambda_offset_ang+xwidthleg*1.3,id_yposnew[0]+ywidthleg,id_text[index_overlap1[1]],alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0  
        
      ENDIF ELSE IF (id_text[index_overlap1[0]] NE id_text[index_overlap1[1]]) AND (id_text[index_overlap1[1]] NE id_text[index_overlap1[2]]) THEN BEGIN; lines 1, 2 and  3 from different ions
       xyouts,id_lambda[index_overlap1[0]]+lambda_offset_ang,id_yposnew[0]+ywidthleg,id_text[index_overlap1[0]],alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0   
       xyouts,id_lambda[index_overlap1[0]]+lambda_offset_ang+xwidthleg*0.6,id_yposnew[0]+ywidthleg,'  +',alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0 
       xyouts,id_lambda[index_overlap1[0]]+lambda_offset_ang+xwidthleg*1.3,id_yposnew[0]+ywidthleg,id_text[index_overlap1[1]],alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0 
       xyouts,id_lambda[index_overlap1[0]]+lambda_offset_ang+xwidthleg*1.9,id_yposnew[0]+ywidthleg,'  +',alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0 
       xyouts,id_lambda[index_overlap1[0]]+lambda_offset_ang+xwidthleg*2.2,id_yposnew[0]+ywidthleg,id_text[index_overlap1[2]],alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0     
      ENDIF            
      
                 
    FOR s=l+1, l+101 DO BEGIN ;will scan next 100 lines for overlapping lines
     IF (abs(id_ew[s]) gt ewmin) and (id_lambda[s] lt id_lambda[l]+xwidthleg) THEN BEGIN
      IF id_text[l] EQ id_text[s] THEN BEGIN ;doublet lines of same element
       print,id_lambda[l],' ',id_lambda[s]    
       print,id_text[l],' ',id_text[s]        
    ;   xyouts,id_lambda[l]+lambda_offset_ang,id_yposnew[0],'-',alignment=0.0,orientation=90,charsize=2.2,charthick=12,color=fsc_color('black'),noclip=0
    ;   xyouts,id_lambda[s]+lambda_offset_ang,id_yposnew[0],'-',alignment=0.0,orientation=90,charsize=2.2,charthick=12,color=fsc_color('black'),noclip=0    
    ;   xyouts,(id_lambda[l]+id_lambda[s])/2.+lambda_offset_ang,id_yposnew[0]+ywidthleg,id_text[l],alignment=0.0,orientation=90,charsize=2.2,charthick=12,color=fsc_color('black'),noclip=0     
      ENDIF ELSE BEGIN ;two lines of different elements
       print,id_lambda[l],' ',id_lambda[s]      
       print,id_text[l],' ',id_text[s] 
       print,id_ew[l],' ',id_ew[s]
    ;   xyouts,id_lambda[l]+lambda_offset_ang,id_yposnew[0],'-',alignment=0.0,orientation=90,charsize=2.2,charthick=12,color=fsc_color('black'),noclip=0
    ;   xyouts,id_lambda[s]+lambda_offset_ang,id_yposnew[0],'-',alignment=0.0,orientation=90,charsize=2.2,charthick=12,color=fsc_color('black'),noclip=0    
    ;   xyouts,id_lambda[l]+lambda_offset_ang,id_yposnew[0]+ywidthleg,id_text[l],alignment=0.0,orientation=90,charsize=2.2,charthick=12,color=fsc_color('black'),noclip=0     
   ;    xyouts,id_lambda[l]+lambda_offset_ang+xwidthleg*0.6,id_yposnew[0]+ywidthleg,'  +',alignment=0.0,orientation=90,charsize=2.2,charthick=12,color=fsc_color('black'),noclip=0  
    ;   xyouts,id_lambda[l]+lambda_offset_ang+xwidthleg*1.3,id_yposnew[0]+ywidthleg,id_text[s],alignment=0.0,orientation=90,charsize=2.2,charthick=12,color=fsc_color('black'),noclip=0         
      ENDELSE         
      l=max(index_overlap1)+1   
     ENDIF
    ENDFOR   
    
    ENDIF ELSE IF found_line_overlap EQ 1 THEN BEGIN   
                
    FOR s=l+1, l+101 DO BEGIN ;will scan next 100 lines for overlapping lines
     IF (abs(id_ew[s]) gt ewmin) and (id_lambda[s] lt id_lambda[l]+xwidthleg) THEN BEGIN
      IF id_text[l] EQ id_text[s] THEN BEGIN ;doublet lines of same element
       print,id_lambda[l],' ',id_lambda[s]    
       print,id_text[l],' ',id_text[s]        
       xyouts,id_lambda[l]+lambda_offset_ang,id_yposnew[0],'-',alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0
       xyouts,id_lambda[s]+lambda_offset_ang,id_yposnew[0],'-',alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0    
       xyouts,(id_lambda[l]+id_lambda[s])/2.+lambda_offset_ang,id_yposnew[0]+ywidthleg,id_text[l],alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0     
      ENDIF ELSE BEGIN ;two lines of different elements
       print,id_lambda[l],' ',id_lambda[s]      
       print,id_text[l],' ',id_text[s] 
       print,id_ew[l],' ',id_ew[s]
       xyouts,id_lambda[l]+lambda_offset_ang,id_yposnew[0],'-',alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0
       xyouts,id_lambda[s]+lambda_offset_ang,id_yposnew[0],'-',alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0    
       xyouts,id_lambda[l]+lambda_offset_ang,id_yposnew[0]+ywidthleg,id_text[l],alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0     
       xyouts,id_lambda[l]+lambda_offset_ang+xwidthleg*0.6,id_yposnew[0]+ywidthleg,'  +',alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0  
       xyouts,id_lambda[l]+lambda_offset_ang+xwidthleg*1.3,id_yposnew[0]+ywidthleg,id_text[s],alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0         
      ENDELSE         
      l=max(index_overlap1)+1   
     ENDIF
    ENDFOR   
    
    ENDIF
    
    
    
    
    print,l,id_lambda[l],' ',id_text[l],' ',id_ew[l]   
    IF found_line_overlap EQ 0 THEN xyouts,id_lambdanew[0],id_yposnew[0],'-'+id_text[l],alignment=0.0,orientation=90,charsize=size_id_text,charthick=12,color=fsc_color('black'),noclip=0
    found_line_overlap=0 
 ;  if (id_text_cut[l] eq 'HI') then xyouts,id_lambda[l],id_ypos,'|',alignment=0.5,orientation=0,charsize=2.5,charthick=14,color=fsc_color('green')  ;colocando apenas um traco verde nas transicoes do H I
  ; if (id_text_cut[l] eq 'HeI') then xyouts,id_lambda[l],id_ypos-0.2,'|',alignment=0.5,orientation=0,charsize=2.5,charthick=14,color=fsc_color('purple')  ;colocando apenas um traco verde nas transicoes do He I
   endif
  endfor
endif  


 IF KEYWORD_SET(bands) THEN BEGIN ;we are overplotting observed passbands of filters
  colorbands=['black','magenta','dark grey','brown','dark green','cyan','orange','black','magenta','dark grey','brown','dark green','cyan','orange']
  FOR i=0, n_elements(bands) -1 DO BEGIN
    ZE_READ_CHORIZOS_BANDPASS_ZP,bands[i],lambda,pass,passband,zp
    pass=pass/max(pass) ; normalize pass curve 
    ZE_EVOL_REBIN_XYZ,lambda,pass,lambdar,passr,factor=factor1
    cgplots,lambdar,(passr*10+1)/1e7,color=colorbands[i],noclip=0,linestyle=linestyle1
  ENDFOR
 ENDIF  
  
 
;IF ((N_elements(x2points) GT 1) AND (N_elements(y2points) GT 1)) THEN cgplots,x2points,y2points,color='green',linestyle=2
;oploterror,pa1,vis1,errorvis1,psym=2,color=fsc_color('black'),ERRCOLOR=fsc_color('dark grey'),symsize=2
;plots,pa1,vis1,color=c1,noclip=0,linestyle=0
;plots,pa2,vis2,color=c2,noclip=0,linestyle=2,thick=25
xyouts,0.17,0.17,label,/NORMAL,color=fsc_color('black')
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