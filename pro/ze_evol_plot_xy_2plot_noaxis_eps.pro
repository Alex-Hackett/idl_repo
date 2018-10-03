PRO ZE_EVOL_PLOT_XY_2PLOT_NOAXIS_EPS,x,y,xtitle,ytitle,label,$
                                z1=z1,labelz=labelz,ct=ct,minz=minz,maxz=maxz,$
                                x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,x11=x11,y11=y11,x12=x12,y12=y12,$
                                z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,z_11=z_11,z_12=z_12,$
                                rebin=rebin,xreverse=xreverse,yreverse=yreverse,_EXTRA=extra,timesteps=timesteps,$
                                pointsx2=pointsx2,pointsy2=pointsy2,psympoints2=psympoints2,symcolorpoints2=symcolorpoints2,symsizepoints2=symsizepoints2,pointsx3=pointsx3,pointsy3=pointsy3,psympoints3=psympoints3,symsizepoints3=symsizepoints3,symcolorpoints3=symcolorpoints3,$
                                pointsx4=pointsx4,pointsy4=pointsy4,psympoints4=psympoints4,symcolorpoints4=symcolorpoints4,symsizepoints4=symsizepoints4,$
                                pointsx5=pointsx5,pointsy5=pointsy5,psympoints5=psympoints5,symcolorpoints5=symcolorpoints5,symsizepoints5=symsizepoints5,$
                                pointsx6=pointsx6,pointsy6=pointsy6,psympoints6=psympoints6,symcolorpoints6=symcolorpoints6,symsizepoints6=symsizepoints6,$
                                psym1=psym1,symsize1=symsize1,symcolor1=symcolor1,$
                                psym2=psym2,symsize2=symsize2,symcolor2=symcolor2,psym3=psym3,symsize3=symsize3,symcolor3=symcolor3,psym4=psym4,symsize4=symsize4,symcolor4=symcolor4,psym5=psym5,symsize5=symsize5,symcolor5=symcolor5,$
                                psym6=psym6,symsize6=symsize6,symcolor6=symcolor6,psym7=psym7,symsize7=symsize7,symcolor7=symcolor7,psym8=psym8,symsize8=symsize8,symcolor8=symcolor8,$
                                psym9=psym9,symsize9=symsize9,symcolor9=symcolor9,psym_10=psym_10,symsize_10=symsize_10,symcolor_10=symcolor_10,psym_11=psym_11,symsize_11=symsize_11,symcolor_11=symcolor_11,psym_12=psym_12,symsize_12=symsize_12,symcolor_12=symcolor_12,$
                                info=info,color1=color1,color2=color2,color3=color3,color4=color4,color5=color5,color6=color6,color7=color7,color8=color8,color9=color9,color_10=color_10,color_11=color_11,color_12=color_12,$
                                linestyle1=linestyle1,linestyle2=linestyle2,linestyle3=linestyle3,linestyle4=linestyle4,linestyle5=linestyle5,linestyle6=linestyle6,linestyle7=linestyle7,linestyle8=linestyle8,linestyle9=linestyle9,linestyle_10=linestyle_10,linestyle_11=linestyle_11,linestyle_12=linestyle_12,$
                                factor=factor,plot_last=plot_last ,$
                                fact2=fact2,fact3=fact3,fact4=fact4,fact5=fact5,fact6=fact6,fact7=fact7,fact8=fact8,fact9=fact9,fact_10=fact_10,fact_11=fact_11,$
                                yerr1=yerr1,yerr2=yerr2,yerr3=yerr3,yerr4=yerr4,$
                                labeldata1=labeldata1,$
                                labeldatapoints2=labeldatapoints2,labeldatapoints3=labeldatapoints3,labeldatapoints4=labeldatapoints4,labeldatapoints5=labeldatapoints5,$
                                labeldatapoints6=labeldatapoints6,$                          
                                alt_x2=alt_x2,alt_y2=alt_y2,alt_x3=alt_x3,alt_y3=alt_y3,alt_x4=alt_x4,alt_y4=alt_y4,alt_x5=alt_x5,alt_y5=alt_y5,$
                                alt_x6=alt_x6,alt_y6=alt_y6,alt_x7=alt_x7,alt_y7=alt_y7,alt_x8=alt_x8,alt_y8=alt_y8,alt_x9=alt_x9,alt_y9=alt_y9,alt_x10=alt_x10,alt_y10=alt_y10,alt_x11=alt_x11,alt_y11=alt_y11,alt_x12=alt_x12,alt_y12=alt_y12,$
                                alt_z2=alt_z2,alt_z3=alt_z3,alt_z4=alt_z4,alt_z5=alt_z5,alt_z6=alt_z6,alt_z7=alt_z7,alt_z8=alt_z8,alt_z9=alt_z9,alt_z_10=alt_z_10,alt_z_11=alt_z_11,alt_z_12=alt_z_12,$
                                alt_rebin=alt_rebin,alt_xreverse=alt_xreverse,alt_yreverse=alt_yreverse,alt__EXTRA=alt_extra,alt_timesteps=alt_timesteps,$
                                alt_pointsx2=alt_pointsx2,alt_pointsy2=alt_pointsy2,alt_psympoints2=alt_psympoints2,alt_symcolorpoints2=alt_symcolorpoints2,alt_symsizepoints2=alt_symsizepoints2,alt_pointsx3=alt_pointsx3,alt_pointsy3=alt_pointsy3,alt_psympoints3=alt_psympoints3,alt_symsizepoints3=alt_symsizepoints3,alt_symcolorpoints3=alt_symcolorpoints3,$
                                alt_pointsx4=alt_pointsx4,alt_pointsy4=alt_pointsy4,alt_psympoints4=alt_psympoints4,alt_symcolorpoints4=alt_symcolorpoints4,alt_symsizepoints4=alt_symsizepoints4,$
                                alt_pointsx5=alt_pointsx5,alt_pointsy5=alt_pointsy5,alt_psympoints5=alt_psympoints5,alt_symcolorpoints5=alt_symcolorpoints5,alt_symsizepoints5=alt_symsizepoints5,$
                                alt_pointsx6=alt_pointsx6,alt_pointsy6=alt_pointsy6,alt_psympoints6=alt_psympoints6,alt_symcolorpoints6=alt_symcolorpoints6,alt_symsizepoints6=alt_symsizepoints6,$
                                alt_psym1=alt_psym1,alt_symsize1=alt_symsize1,alt_symcolor1=alt_symcolor1,$
                                alt_psym2=alt_psym2,alt_symsize2=alt_symsize2,alt_symcolor2=alt_symcolor2,alt_psym3=alt_psym3,alt_symsize3=alt_symsize3,alt_symcolor3=alt_symcolor3,alt_psym4=alt_psym4,alt_symsize4=alt_symsize4,alt_symcolor4=alt_symcolor4,alt_psym5=alt_psym5,alt_symsize5=alt_symsize5,alt_symcolor5=alt_symcolor5,$
                                alt_psym6=alt_psym6,alt_symsize6=alt_symsize6,alt_symcolor6=alt_symcolor6,alt_psym7=alt_psym7,alt_symsize7=alt_symsize7,alt_symcolor7=alt_symcolor7,alt_psym8=alt_psym8,alt_symsize8=alt_symsize8,alt_symcolor8=alt_symcolor8,$
                                alt_psym9=alt_psym9,alt_symsize9=alt_symsize9,alt_symcolor9=alt_symcolor9,alt_psym_10=alt_psym_10,alt_symsize_10=alt_symsize_10,alt_symcolor_10=alt_symcolor_10,alt_psym_11=alt_psym_11,alt_symsize_11=alt_symsize_11,alt_symcolor_11=alt_symcolor_11,alt_psym_12=alt_psym_12,alt_symsize_12=alt_symsize_12,alt_symcolor_12=alt_symcolor_12,$
                                alt_info=alt_info,alt_color1=alt_color1,alt_color2=alt_color2,alt_color3=alt_color3,alt_color4=alt_color4,alt_color5=alt_color5,alt_color6=alt_color6,alt_color7=alt_color7,alt_color8=alt_color8,alt_color9=alt_color9,alt_color_10=alt_color_10,alt_color_11=alt_color_11,alt_color_12=alt_color_12,$
                                alt_linestyle1=alt_linestyle1,alt_linestyle2=alt_linestyle2,alt_linestyle3=alt_linestyle3,alt_linestyle4=alt_linestyle4,alt_linestyle5=alt_linestyle5,alt_linestyle6=alt_linestyle6,alt_linestyle7=alt_linestyle7,alt_linestyle8=alt_linestyle8,alt_linestyle9=alt_linestyle9,alt_linestyle_10=alt_linestyle_10,alt_linestyle_11=alt_linestyle_11,alt_linestyle_12=alt_linestyle_12,$
                                alt_factor=alt_factor,alt_plot_last=alt_plot_last ,$
                                alt_yerr1=alt_yerr1,alt_yerr2=alt_yerr2,alt_yerr3=alt_yerr3,alt_yerr4=alt_yerr4,$
                                alt_labeldata1=alt_labeldata1,$
                                alt_labeldatapoints2=alt_labeldatapoints2,alt_labeldatapoints3=alt_labeldatapoints3,alt_labeldatapoints4=alt_labeldatapoints4,alt_labeldatapoints5=alt_labeldatapoints5,$
                                alt_labeldatapoints6=alt_labeldatapoints6,ALT_YTITLE=ALT_YTITLE,ALT_XTITLE=ALT_XTITLE,$                                              
                                nolabel=nolabel,filename=filename,psxsize=psxsize,psysize=psysize,$
                                DOUBLE_YAXIS=DOUBLE_YAXIS,DOUBLE_XAXIS=DOUBLE_XAXIS,alty_min=alty_min,alty_max=alty_max,xthick=xthick,ythick=ythick,pthick=pthick,pcharthick=pcharthick,$
                                xcharsize=xcharsize,ycharsize=ycharsize,pcharsize=pcharsize,ticklen=ticklen
;for Fig 1 of 60 Msun norot paper
;2plots joinined, no axis in between.

close,/all
!P.MULTI=0

if n_elements(xthick) eq 0 then xthick=12
if n_elements(ythick) eq 0 then ythick=12
if n_elements(pthick) eq 0 then pthick=14
if n_elements(pcharthick) eq 0 then pcharthick=12
if n_elements(pcharsize) eq 0 then pcharsize=2
if n_elements(xcharsize) eq 0 then xcharsize=1.4
if n_elements(ycharsize) eq 0 then ycharsize=1.4
if n_elements(ticklen) eq 0 then ticklen=15

IF n_elements(ct) lt 1 THEN ct=33
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
IF n_elements(factor) lt 1 THEN factor=10.0
IF n_elements(fact2) lt 1 THEN fact2=factor
IF n_elements(fact3) lt 1 THEN fact3=factor
IF n_elements(fact4) lt 1 THEN fact4=factor
IF n_elements(fact5) lt 1 THEN fact5=factor
IF n_elements(fact6) lt 1 THEN fact6=factor
IF n_elements(fact7) lt 1 THEN fact7=factor
IF n_elements(fact8) lt 1 THEN fact8=factor
IF n_elements(fact9) lt 1 THEN fact9=factor
IF n_elements(fact_10) lt 1 THEN fact_10=factor
IF n_elements(fact_11) lt 1 THEN fact_11=factor
IF n_elements(fact_12) lt 1 THEN fact_12=factor
IF n_elements(alt_color1) lt 1 THEN alt_color1='black'
IF n_elements(alt_color2) lt 1 THEN alt_color2='red'
IF n_elements(alt_color3) lt 1 THEN alt_color3='blue'
IF n_elements(alt_color4) lt 1 THEN alt_color4='dark green'
IF n_elements(alt_color5) lt 1 THEN alt_color5='orange'
IF n_elements(alt_color6) lt 1 THEN alt_color6='cyan'
IF n_elements(alt_color7) lt 1 THEN alt_color7='purple'
IF n_elements(alt_color8) lt 1 THEN alt_color8='magenta'
IF n_elements(alt_color9) lt 1 THEN alt_color9='green'
IF n_elements(alt_color_10) lt 1 THEN alt_color_10='dark grey'
IF n_elements(alt_color_11) lt 1 THEN alt_color_11='charcoal'
IF n_elements(alt_color_12) lt 1 THEN alt_color_12='chocolate'
IF n_elements(alt_linestyle1) lt 1 THEN alt_linestyle1=0
IF n_elements(alt_linestyle2) lt 1 THEN alt_linestyle2=0
IF n_elements(alt_linestyle3) lt 1 THEN alt_linestyle3=0
IF n_elements(alt_linestyle4) lt 1 THEN alt_linestyle4=0
IF n_elements(alt_linestyle5) lt 1 THEN alt_linestyle5=0
IF n_elements(alt_linestyle6) lt 1 THEN alt_linestyle6=0
IF n_elements(alt_linestyle7) lt 1 THEN alt_linestyle7=0
IF n_elements(alt_linestyle8) lt 1 THEN alt_linestyle8=0
IF n_elements(alt_linestyle9) lt 1 THEN alt_linestyle9=0
IF n_elements(alt_linestyle_10) lt 1 THEN alt_linestyle_10=0
IF n_elements(alt_linestyle_11) lt 1 THEN alt_linestyle_11=0
IF n_elements(alt_linestyle_12) lt 1 THEN alt_linestyle_12=0
IF n_elements(alt_factor) lt 1 THEN alt_factor=10.0
IF n_elements(alt_factor2) lt 1 THEN alt_factor2=factor
IF n_elements(alt_factor3) lt 1 THEN alt_factor3=factor
IF n_elements(alt_factor4) lt 1 THEN alt_factor4=factor
IF n_elements(alt_factor5) lt 1 THEN alt_factor5=factor
IF n_elements(alt_factor6) lt 1 THEN alt_factor6=factor
IF n_elements(alt_factor7) lt 1 THEN alt_factor7=factor
IF n_elements(alt_factor8) lt 1 THEN alt_factor8=factor
IF n_elements(alt_factor9) lt 1 THEN alt_factor9=factor
IF n_elements(alt_factor_10) lt 1 THEN alt_factor_10=factor
IF n_elements(alt_factor_11) lt 1 THEN alt_factor_11=factor
IF n_elements(alt_factor_12) lt 1 THEN alt_factor_12=factor

IF KEYWORD_SET(REBIN) THEN BEGIN
    ZE_EVOL_REBIN_XYZ,x,y,xr,yr,z=z1,rebin_z=rebin_z,factor=factor
    IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x2,y2,x2r,y2r,z=z2,rebin_z=rebin_z2,factor=fact2
    IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x3,y3,x3r,y3r,z=z3,rebin_z=rebin_z3,factor=fact3
    IF ((N_elements(x4) gt 1) AND (N_elements(y4) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x4,y4,x4r,y4r,z=z4,rebin_z=rebin_z4,factor=fact4
    IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x5,y5,x5r,y5r,z=z5,rebin_z=rebin_z5,factor=fact5
    IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x6,y6,x6r,y6r,z=z6,rebin_z=rebin_z6,factor=fact6
    IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x7,y7,x7r,y7r,z=z7,rebin_z=rebin_z7,factor=fact7
    IF ((N_elements(x8) gt 1) AND (N_elements(y8) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x8,y8,x8r,y8r,z=z8,rebin_z=rebin_z8,factor=fact8
    IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x9,y9,x9r,y9r,z=z9,rebin_z=rebin_z9,factor=fact9
    IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x10,y10,x10r,y10r,z=z_10,rebin_z=rebin_z10,factor=fact_10
    IF ((N_elements(x11) GT 1) AND (N_elements(y11) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x11,y11,x11r,y11r,z=z_11,rebin_z=rebin_z11,factor=fact_11    
    IF ((N_elements(x12) GT 1) AND (N_elements(y12) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x12,y12,x12r,y12r,z=z_12,rebin_z=rebin_z12,factor=fact_12   
    IF KEYWORD_SET(DOUBLE_YAXIS) THEN BEGIN
         IF ((N_elements(alt_x2) GT 1) AND (N_elements(alt_y2) GT 1)) THEN ZE_EVOL_REBIN_XYZ,alt_x2,alt_y2,alt_x2r,alt_y2r,z=alt_z2,rebin_z=alt_rebin_z2,factor=alt_factor2
         IF ((N_elements(alt_x3) GT 1) AND (N_elements(alt_y3) GT 1)) THEN ZE_EVOL_REBIN_XYZ,alt_x3,alt_y3,alt_x3r,alt_y3r,z=alt_z3,rebin_z=alt_rebin_z3,factor=alt_factor3
         IF ((N_elements(alt_x4) gt 1) AND (N_elements(alt_y4) GT 1)) THEN ZE_EVOL_REBIN_XYZ,alt_x4,alt_y4,alt_x4r,alt_y4r,z=alt_z4,rebin_z=alt_rebin_z4,factor=alt_factor4
         IF ((N_elements(alt_x5) GT 1) AND (N_elements(alt_y5) GT 1)) THEN ZE_EVOL_REBIN_XYZ,alt_x5,alt_y5,alt_x5r,alt_y5r,z=alt_z5,rebin_z=alt_rebin_z5,factor=alt_factor5
         IF ((N_elements(alt_x6) GT 1) AND (N_elements(alt_y6) GT 1)) THEN ZE_EVOL_REBIN_XYZ,alt_x6,alt_y6,alt_x6r,alt_y6r,z=alt_z6,rebin_z=alt_rebin_z6,factor=alt_factor6
         IF ((N_elements(alt_x7) GT 1) AND (N_elements(alt_y7) GT 1)) THEN ZE_EVOL_REBIN_XYZ,alt_x7,alt_y7,alt_x7r,alt_y7r,z=alt_z7,rebin_z=alt_rebin_z7,factor=alt_factor7
         IF ((N_elements(alt_x8) gt 1) AND (N_elements(alt_y8) GT 1)) THEN ZE_EVOL_REBIN_XYZ,alt_x8,alt_y8,alt_x8r,alt_y8r,z=alt_z8,rebin_z=alt_rebin_z8,factor=alt_factor8
         IF ((N_elements(alt_x9) GT 1) AND (N_elements(alt_y9) GT 1)) THEN ZE_EVOL_REBIN_XYZ,alt_x9,alt_y9,alt_x9r,alt_y9r,z=alt_z9,rebin_z=alt_rebin_z9,factor=alt_factor9
         IF ((N_elements(alt_x10) GT 1) AND (N_elements(alt_y10) GT 1)) THEN ZE_EVOL_REBIN_XYZ,alt_x10,alt_y10,alt_x10r,alt_y10r,z=alt_z_10,rebin_z=alt_rebin_z10,factor=alt_factor_10
         IF ((N_elements(alt_x11) GT 1) AND (N_elements(alt_y11) GT 1)) THEN ZE_EVOL_REBIN_XYZ,alt_x11,alt_y11,alt_x11r,alt_y11r,z=alt_z_11,rebin_z=alt_rebin_z11,factor=alt_factor_11    
         IF ((N_elements(alt_x12) GT 1) AND (N_elements(alt_y12) GT 1)) THEN ZE_EVOL_REBIN_XYZ,alt_alt_x12,alt_alt_y12,alt_alt_x12r,alt_alt_y12r,z=alt_z_12,alt_rebin_z=alt_rebin_z12,factor=alt_factor_12    
    ENDIF   
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

if n_elements(psxsize) eq 0 then psxsize=800
if n_elements(psysize) eq 0 then psysize=600
ps_ysize=10.
ps_xsize=ps_ysize*psxsize/psysize

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
!x.ticklen = ticklen/psysize
!y.ticklen = ticklen/psxsize

LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
a=2.0 ;line thick obs
b=3.5 ;line thick model
lm=2
lm2=1

if KEYWORD_SET(DOUBLE_XAXIS) THEN xstyle_type=9 ELSE xstyle_Type=1
xstyle=xstyle_type

if KEYWORD_SET(DOUBLE_YAXIS) THEN ystyle_type=9 ELSE ystyle_Type=1
ystyle=ystyle_type

loadct,ct,/silent

if N_elements(z1) lt 1  THEN BEGIN ;no Z values to do color-coding
   if keyword_set(rebin) THEN BEGIN;datah as been rebinned
       cgplot,xr,yr,xstyle=xstyle_type,ystyle=ystyle_type,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
       /nodata,POSITION=[0.12,0.12,0.97,0.97],_STRICT_EXTRA=extra
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
       IF KEYWORD_SET(DOUBLE_YAXIS) THEN cgAXIS,YAXIS=1,YSTYLE=1,ylog=0,YRANGE=[alty_min,alty_max],/noerase,color=fsc_color('black'),_REF_EXTRA=extra ELSE cgAXIS,YAXIS=1,YSTYLE=1,/noerase,color=fsc_color('black'),YTICKFORMAT='(A2)',_REF_EXTRA=extra 
     
   ENDIF ELSE BEGIN; data has not been rebinned
       cgplot,x,y,xstyle=xstyle_type,ystyle=ystyle_type,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
       /nodata,POSITION=[0.12,0.12,0.97,0.97],_STRICT_EXTRA=extra 
       cgplots,x,y,color=color1,noclip=0,psym=psym1,symsize=symsize1,symcolor=symcolor1,linestyle=linestyle1
       IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN cgplots,x2,y2,color=color2,noclip=0,psym=psym2,symsize=symsize2,symcolor=symcolor2,linestyle=linestyle2
       IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN cgplots,x3,y3,color=color3,noclip=0,psym=psym3,symsize=symsize3,symcolor=symcolor3,linestyle=linestyle3
       IF ((N_elements(x4) GT 1) AND (N_elements(y4) GT 1)) THEN cgplots,x4,y4,color=color4,noclip=0,psym=psym4,symsize=symsize4,symcolor=symcolor4,linestyle=linestyle4
       IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN cgplots,x5,y5,color=color5,noclip=0,psym=psym5,symsize=symsize5,symcolor=symcolor5,linestyle=linestyle5
       IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN cgplots,x6,y6,color=color6,noclip=0,psym=psym6,symsize=symsize6,symcolor=symcolor6,linestyle=linestyle6
       IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN cgplots,x7,y7,color=color7,noclip=0,psym=psym7,symsize=symsize7,symcolor=symcolor7,linestyle=linestyle7
       IF ((N_elements(x8) GT 1) AND (N_elements(y8) GT 1)) THEN cgplots,x8,y8,color=color8,noclip=0,psym=psym8,symsize=symsize8,symcolor=symcolor8,linestyle=linestyle8 
       IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN cgplots,x9,y9,color=color9,noclip=0,linestyle=linestyle9,psym=psym9,symsize=symsize9,symcolor=symcolor9  
       IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN cgplots,x10,y10,color=color_10,noclip=0 ,linestyle=linestyle_10,psym=psym_10,symsize=symsize_10,symcolor=symcolor_10
       IF ((N_elements(x11) GT 1) AND (N_elements(y11) GT 1)) THEN cgplots,x11,y11,noclip=0,color=color_11,linestyle=linestyle_11,psym=psym_11,symsize=symsize_11,symcolor=symcolor_11    
       IF ((N_elements(x12) GT 1) AND (N_elements(y12) GT 1)) THEN cgplots,x12,y12,noclip=0,color=color_12,linestyle=linestyle_12,psym=psym_12,symsize=symsize_12,symcolor=symcolor_12                  
              
       IF KEYWORD_SET(DOUBLE_YAXIS) THEN cgAXIS,YAXIS=1,YSTYLE=1,ylog=0,YRANGE=[alty_min,alty_max],/noerase,color=fsc_color('black'),_REF_EXTRA=extra ELSE cgAXIS,YAXIS=1,YSTYLE=1,/noerase,color=fsc_color('black'),YTICKFORMAT='(A2)',_REF_EXTRA=extra 
 
   ENDELSE           
ENDIF ELSE BEGIN ;doing color coding, but has to do to all of them
    IF keyword_set(rebin) THEN BEGIN;datah as been rebinned
      if n_elements(minz) lt 1 THEN minz=min(rebin_z)
      if n_elements(maxz) lt 1 THEN maxz=max(rebin_z)
      cgplot,xr,yr,xstyle=xstyle_type,ystyle=ystyle_type,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
    /nodata,POSITION=[0.12,0.11,0.87,0.95],_STRICT_EXTRA=extra
      cgplots,xr,yr,noclip=0,color=bytscl(rebin_z,MIN=minz,MAX=maxz),linestyle=linestyle1,psym=psym1,symsize=symsize1
      IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN cgplots,x2r,y2r,noclip=0,color=bytscl(rebin_z2,MIN=minz,MAX=maxz),linestyle=linestyle2,psym=psym2,symsize=symsize2
      IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN cgplots,x3r,y3r,noclip=0,color=bytscl(rebin_z3,MIN=minz,MAX=maxz),linestyle=linestyle3,psym=psym3,symsize=symsize3
      IF ((N_elements(x4) GT 1) AND (N_elements(y4) GT 1)) THEN cgplots,x4r,y4r,noclip=0,color=bytscl(rebin_z4,MIN=minz,MAX=maxz),linestyle=linestyle4,psym=psym4,symsize=symsize4
      IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN cgplots,x5r,y5r,noclip=0,color=bytscl(rebin_z5,MIN=minz,MAX=maxz),linestyle=linestyle5,psym=psym5,symsize=symsize5
      IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN cgplots,x6r,y6r,noclip=0,color=bytscl(rebin_z6,MIN=minz,MAX=maxz),linestyle=linestyle6 ,psym=psym6,symsize=symsize6
      IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN cgplots,x7r,y7r,noclip=0,color=bytscl(rebin_z7,MIN=minz,MAX=maxz),linestyle=linestyle7  ,psym=psym7,symsize=symsize7
      IF ((N_elements(x8) GT 1) AND (N_elements(y8) GT 1)) THEN cgplots,x8r,y8r,noclip=0,color=bytscl(rebin_z8,MIN=minz,MAX=maxz),linestyle=linestyle8 ,psym=psym8,symsize=symsize8
      IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN cgplots,x9r,y9r,noclip=0,color=bytscl(rebin_z9,MIN=minz,MAX=maxz),linestyle=linestyle9,psym=psym9,symsize=symsize9
      IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN cgplots,x10r,y10r,noclip=0,color=bytscl(rebin_z10,MIN=minz,MAX=maxz),linestyle=linestyle_10 ,psym=psym_10 ,symsize=symsize_10 
      IF ((N_elements(x11) GT 1) AND (N_elements(y11) GT 1)) THEN cgplots,x11r,y11r,noclip=0,color=bytscl(rebin_z11,MIN=minz,MAX=maxz),linestyle=linestyle_11,psym=psym_11   ,symsize=symsize_11
      IF ((N_elements(x12) GT 1) AND (N_elements(y12) GT 1)) THEN cgplots,x12r,y12r,noclip=0,color=bytscl(rebin_z12,MIN=minz,MAX=maxz),linestyle=linestyle_12,psym=psym_12  ,symsize=symsize_12     
    
      cgcolorbar,/vertical,/right,POSITION=[0.89,0.1,0.93,0.95],RANGE=[minz,maxz];,annotatecolor=
      xyouts,0.89,0.96,labelz,/NORMAL,color=fsc_color('black')
    ENDIF else begin ;data has not been rebinned
      if n_elements(minz) lt 1 THEN minz=min(z1)
      if n_elements(maxz) lt 1 THEN maxz=max(z1)
      cgplot,x,y,xstyle=xstyle_type,ystyle=ystyle_type,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
    /nodata,POSITION=[0.12,0.11,0.87,0.95],_STRICT_EXTRA=extra
      cgplots,xr,yr,noclip=0,color=bytscl(z1,MIN=minz,MAX=maxz),linestyle=linestyle1,psym=psym1,symsize=symsize1
      IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN cgplots,x2,y2,noclip=0,color=bytscl(z2,MIN=minz,MAX=maxz),linestyle=linestyle2,psym=psym2,symsize=symsize2
      IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN cgplots,x3,y3,noclip=0,color=bytscl(z3,MIN=minz,MAX=maxz),linestyle=linestyle3,psym=psym3,symsize=symsize3
      IF ((N_elements(x4) GT 1) AND (N_elements(y4) GT 1)) THEN cgplots,x4,y4,noclip=0,color=bytscl(z4,MIN=minz,MAX=maxz),linestyle=linestyle4,psym=psym4,symsize=symsize4
      IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN cgplots,x5,y5,noclip=0,color=bytscl(z5,MIN=minz,MAX=maxz),linestyle=linestyle5,psym=psym5,symsize=symsize5
      IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN cgplots,x6,y6,noclip=0,color=bytscl(z6,MIN=minz,MAX=maxz),linestyle=linestyle6 ,psym=psym6,symsize=symsize6
      IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN cgplots,x7,y7,noclip=0,color=bytscl(z7,MIN=minz,MAX=maxz),linestyle=linestyle7  ,psym=psym7,symsize=symsize7
      IF ((N_elements(x8) GT 1) AND (N_elements(y8) GT 1)) THEN cgplots,x8,y8,noclip=0,color=bytscl(z8,MIN=minz,MAX=maxz),linestyle=linestyle8 ,psym=psym8,symsize=symsize8
      IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN cgplots,x9,y9,noclip=0,color=bytscl(z9,MIN=minz,MAX=maxz),linestyle=linestyle9,psym=psym9,symsize=symsize9
      IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN cgplots,x10,y10,noclip=0,color=bytscl(z_10,MIN=minz,MAX=maxz),linestyle=linestyle_10 ,psym=psym_10 ,symsize=symsize_10 
      IF ((N_elements(x11) GT 1) AND (N_elements(y11) GT 1)) THEN cgplots,x11,y11,noclip=0,color=color_11,linestyle=linestyle_11,psym=psym_11   ,symsize=symsize_11
      IF ((N_elements(x12) GT 1) AND (N_elements(y12) GT 1)) THEN cgplots,x12,y12,noclip=0,color=color_12,linestyle=linestyle_12,psym=psym_12  ,symsize=symsize_12     
    
      cgcolorbar,/vertical,/right,POSITION=[0.89,0.1,0.93,0.95],RANGE=[minz,maxz];,annotatecolor=
      xyouts,0.89,0.96,labelz,/NORMAL,color=fsc_color('black') 
    ENDELSE 
ENDELSE
;tmodel=[48386.4 ,  47031.9   ,  45796.1 , 39375.6  , 31088.6   ,  27864.3 ,   30783.7, 45243.1 , 56420.0  ,63351.2, 69550.6, 92369. ,140543.,136008.,133655. ,126228. ]
;
;lmodel=[507016. ,  528381.   ,  555083. , 645563.  , 719179.   ,  743098. ,   941860., 916947. , 897212.  ,883519.,  870531.,791920.,  350244., 434538.,507200.,545449.]
;timesteps=[56,500,1000,2500,3500,3800,5500,5820,6250,6551,6851,7201,11201,12551,14951,18950.]
if n_elements(timesteps) GT 0 THEN BEGIN
  cgplots,x[timesteps],y[timesteps],psym=4,symsize=3.
  for i=0, n_elements(timesteps) -1 DO xyouts,x[timesteps[i]],y[timesteps[i]],string(timesteps[i],format='(I5)'),/DATA,color=fsc_color('black'),charsize=1.5
endif

;plot errobars?
    IF n_elements(yerr1) gt 0 then cgErrPlot, x, y-yerr1, y+yerr1,color=color1, thick=1
    IF n_elements(yerr2) gt 0 then cgErrPlot, x2, y2-yerr2, y2+yerr2,color=color2, thick=1
    IF n_elements(yerr3) gt 0 then cgErrPlot, x3, y3-yerr3, y3+yerr3,color=color3, thick=1
    IF n_elements(yerr4) gt 0 then cgErrPlot, x4, y4-yerr4, y4+yerr4,color=color4, thick=1
     
;plot other points?
IF ((N_elements(pointsx2) GT 1) AND (N_elements(pointsy2) GT 1)) THEN cgplots,pointsx2,pointsy2,psym=psympoints2,symcolor=symcolorpoints2,symsize=symsizepoints2,noclip=0
IF ((N_elements(pointsx3) GT 1) AND (N_elements(pointsy3) GT 1)) THEN cgplots,pointsx3,pointsy3,psym=psympoints3,symcolor=symcolorpoints3,symsize=symsizepoints3,noclip=0
IF ((N_elements(pointsx4) GT 1) AND (N_elements(pointsy4) GT 1)) THEN cgplots,pointsx4,pointsy4,psym=psympoints4,symcolor=symcolorpoints4,symsize=symsizepoints4,noclip=0
IF ((N_elements(pointsx5) GT 1) AND (N_elements(pointsy5) GT 1)) THEN cgplots,pointsx5,pointsy5,psym=psympoints5,symcolor=symcolorpoints5,symsize=symsizepoints5,noclip=0
IF ((N_elements(pointsx6) GT 1) AND (N_elements(pointsy6) GT 1)) THEN cgplots,pointsx6,pointsy6,psym=psympoints6,symcolor=symcolorpoints6,symsize=symsizepoints6,noclip=0

IF KEYWORD_SET(NOLABEL) THEN print,'Not putting labels on variables' ELSE BEGIN 

  IF (N_elements(labeldata1) GT 1) THEN FOR i=0, n_elements(labeldata1)-1 DO xyouts,x[i],y[i],strcompress(STRING(labeldata1[i])),/DATA,noclip=0
  IF (N_elements(labeldatapoints2) GT 1) THEN FOR i=0, n_elements(labeldatapoints2)-1 DO xyouts,pointsx2[i],pointsy2[i],strcompress(STRING(labeldatapoints2[i])),charsize=1.5,color=fsc_color('black'),/DATA,noclip=0
  IF (N_elements(labeldatapoints2) GT 1) THEN FOR i=0, n_elements(labeldatapoints3)-1 DO xyouts,pointsx3[i],pointsy3[i],strcompress(STRING(labeldatapoints3[i])),charsize=1.5,color=fsc_color('black'),/DATA,noclip=0
  IF (N_elements(labeldatapoints2) GT 1) THEN FOR i=0, n_elements(labeldatapoints4)-1 DO xyouts,pointsx4[i],pointsy4[i],strcompress(STRING(labeldatapoints4[i])),charsize=1.5,color=fsc_color('black'),/DATA,noclip=0
  IF (N_elements(labeldatapoints2) GT 1) THEN FOR i=0, n_elements(labeldatapoints5)-1 DO xyouts,pointsx5[i],pointsy5[i],strcompress(STRING(labeldatapoints5[i])),charsize=1.5,color=fsc_color('black'),/DATA,noclip=0
  IF (N_elements(labeldatapoints2) GT 1) THEN FOR i=0, n_elements(labeldatapoints6)-1 DO xyouts,pointsx6[i],pointsy6[i],strcompress(STRING(labeldatapoints6[i])),charsize=1.5,color=fsc_color('black'),/DATA,noclip=0 
ENDelse

;assumes alt data has been rebinned, no color coding with z values HAVE TO WORK HERE TO BE MORE GENERAL
       IF KEYWORD_SET(DOUBLE_YAXIS) THEN BEGIN
       ;   cgAXIS,YAXIS=1,YLOG=0,YRANGE=[alty_min,alty_max],YSTYLE=2,YTITLE='',/SAVE,color='black'
         print,'alty_min,alty_max ',alty_min,alty_max 
          cgAXIS,YAXIS=1,YRANGE=[alty_min,alty_max],YSTYLE=1,YTITLE=ALT_YTITLE,/SAVE,color='black',ylog=0        
              IF ((N_elements(alt_x2r) GT 1) AND (N_elements(alt_y2r) GT 1)) THEN cgplots,alt_x2r,alt_y2r,color=alt_color2,noclip=0,psym=alt_psym2,symsize=alt_symsize2,symcolor=alt_symcolor2,linestyle=alt_linestyle2
              IF ((N_elements(alt_x3r) GT 1) AND (N_elements(alt_y3r) GT 1)) THEN cgplots,alt_x3r,alt_y3r,color=alt_color3,noclip=0,psym=alt_psym3,symsize=alt_symsize3,symcolor=alt_symcolor3,linestyle=alt_linestyle3
              IF ((N_elements(alt_x4r) GT 1) AND (N_elements(alt_y4r) GT 1)) THEN cgplots,alt_x4r,alt_y4r,color=alt_color4,noclip=0,linestyle=alt_linestyle4
              IF ((N_elements(alt_x5r) GT 1) AND (N_elements(alt_y5r) GT 1)) THEN cgplots,alt_x5r,alt_y5r,color=alt_color5,noclip=0,linestyle=alt_linestyle5
              IF ((N_elements(alt_x6r) GT 1) AND (N_elements(alt_y6r) GT 1)) THEN cgplots,alt_x6r,alt_y6r,color=alt_color6,noclip=0,linestyle=alt_linestyle6
              IF ((N_elements(alt_x7r) GT 1) AND (N_elements(alt_y7r) GT 1)) THEN cgplots,alt_x7r,alt_y7r,color=alt_color7,noclip=0,linestyle=alt_linestyle7
              IF ((N_elements(alt_x8r) GT 1) AND (N_elements(alt_y8r) GT 1)) THEN cgplots,alt_x8r,alt_y8r,color=alt_color8,noclip=0,linestyle=alt_linestyle8
              IF ((N_elements(alt_x9r) GT 1) AND (N_elements(alt_y9r) GT 1)) THEN cgplots,alt_x9r,alt_y9r,color=alt_color9,noclip=0,linestyle=alt_linestyle9
              IF ((N_elements(alt_x10r) GT 1) AND (N_elements(alt_y10r) GT 1)) THEN cgplots,alt_x10r,alt_y10r,color=alt_color_10,noclip=0 ,linestyle=alt_linestyle_10
              IF ((N_elements(alt_x11r) GT 1) AND (N_elements(alt_y11r) GT 1)) THEN cgplots,alt_x11r,alt_y11r,noclip=0,color=alt_color_11,linestyle=alt_linestyle_11    
              IF ((N_elements(alt_x12r) GT 1) AND (N_elements(alt_y12r) GT 1)) THEN cgplots,alt_x12r,alt_y12r,noclip=0,color=alt_color_12,linestyle=alt_linestyle_12  
         
          ;plot errobars?
              IF n_elements(alt_yerr2) gt 0 then cgErrPlot, alt_x2, alt_y2-alt_yerr2, alt_y2+alt_yerr2,color=alt_color2, thick=1
              IF n_elements(alt_yerr3) gt 0 then cgErrPlot, alt_x3, alt_y3-alt_yerr3, alt_y3+alt_yerr3,color=alt_color3, thick=1
              IF n_elements(alt_yerr4) gt 0 then cgErrPlot, alt_x4, alt_y4-alt_yerr4, alt_y4+alt_yerr4,color=alt_color4, thick=1
     
              ;plot other points?
              IF ((N_elements(alt_pointsx2) GT 1) AND (N_elements(alt_pointsy2) GT 1)) THEN cgplots,alt_pointsx2,alt_pointsy2,psym=alt_psympoints2,symcolor=alt_symcolorpoints2,symsize=alt_symsizepoints2,noclip=0
              IF ((N_elements(alt_pointsx3) GT 1) AND (N_elements(alt_pointsy3) GT 1)) THEN cgplots,alt_pointsx3,alt_pointsy3,psym=alt_psympoints3,symcolor=alt_symcolorpoints3,symsize=alt_symsizepoints3,noclip=0
              IF ((N_elements(alt_pointsx4) GT 1) AND (N_elements(alt_pointsy4) GT 1)) THEN cgplots,alt_pointsx4,alt_pointsy4,psym=alt_psympoints4,symcolor=alt_symcolorpoints4,symsize=alt_symsizepoints4,noclip=0
              IF ((N_elements(alt_pointsx5) GT 1) AND (N_elements(alt_pointsy5) GT 1)) THEN cgplots,alt_pointsx5,alt_pointsy5,psym=alt_psympoints5,symcolor=alt_symcolorpoints5,symsize=alt_symsizepoints5,noclip=0
              IF ((N_elements(alt_pointsx6) GT 1) AND (N_elements(alt_pointsy6) GT 1)) THEN cgplots,alt_pointsx6,alt_pointsy6,psym=alt_psympoints6,symcolor=alt_symcolorpoints6,symsize=alt_symsizepoints6,noclip=0

              IF KEYWORD_SET(NOLABEL) THEN print,'Not putting labels on variables' ELSE BEGIN 
                 IF (N_elements(labeldata1) GT 1) THEN FOR i=0, n_elements(labeldata1)-1 DO xyouts,x[i],y[i],strcompress(STRING(labeldata1[i])),/DATA,noclip=0
                 IF (N_elements(labeldatapoints2) GT 1) THEN FOR i=0, n_elements(alt_labeldatapoints2)-1 DO xyouts,alt_pointsx2[i],alt_pointsy2[i],strcompress(STRING(alt_labeldatapoints2[i])),charsize=1.5,color=fsc_color('black'),/DATA,noclip=0
                 IF (N_elements(labeldatapoints2) GT 1) THEN FOR i=0, n_elements(alt_labeldatapoints3)-1 DO xyouts,alt_pointsx3[i],alt_pointsy3[i],strcompress(STRING(alt_labeldatapoints3[i])),charsize=1.5,color=fsc_color('black'),/DATA,noclip=0
                 IF (N_elements(labeldatapoints2) GT 1) THEN FOR i=0, n_elements(alt_labeldatapoints4)-1 DO xyouts,alt_pointsx4[i],alt_pointsy4[i],strcompress(STRING(alt_labeldatapoints4[i])),charsize=1.5,color=fsc_color('black'),/DATA,noclip=0
                 IF (N_elements(labeldatapoints2) GT 1) THEN FOR i=0, n_elements(alt_labeldatapoints5)-1 DO xyouts,alt_pointsx5[i],alt_pointsy5[i],strcompress(STRING(alt_labeldatapoints5[i])),charsize=1.5,color=fsc_color('black'),/DATA,noclip=0
                 IF (N_elements(labeldatapoints2) GT 1) THEN FOR i=0, n_elements(alt_labeldatapoints6)-1 DO xyouts,alt_pointsx6[i],alt_pointsy6[i],strcompress(STRING(alt_labeldatapoints6[i])),charsize=1.5,color=fsc_color('black'),/DATA,noclip=0 
              ENDelse              
       ENDIF     
 
;plot label?
xyouts,0.17,0.17,label,/NORMAL,color=fsc_color('black')


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