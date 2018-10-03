;---------------------------
;----MAIN EVENT DRIVER------
;---------------------------
PRO AH_HRD_CENTRAL_CONDS_INTERAC_COM_V1_event, EVENT
  COMMON AH_HRD_CENTRAL_CONDS_INTERAC_COM_V1_COMMON, info, xarray,yarray, $
    agearray, teffarray, lstararray, tcenarray, $
    rhocenarray, coremassarray
    
  WIDGET_CONTROL,EVENT.ID,GET_UVALUE=UVALUE
  
  CASE UVALUE OF
  
;XVARS
  'xage': BEGIN
    xarray = agearray
    info.xreverse = 0
    info.xtitle = TEXTOIDL('Age (Yrs)')
    ah_arrayplot, info, xarray, yarray
   END
   
  'xteff': BEGIN
    xarray = teffarray
    info.xreverse = 1
    info.xtitle=TEXTOIDL('log T_* (K)')
    ah_arrayplot, info, xarray, yarray
   END
   
  'xrhoc': BEGIN
    xarray = rhocenarray
    info.xreverse = 0
    info.xtitle = TEXTOIDL('log \rho _{c} (g/cm^{3})')
    ah_arrayplot, info, xarray, yarray
   END
   
;YVARS

  'ylstar': BEGIN
    yarray = lstararray
    info.ytitle = TEXTOIDL('log L/L_{\odot}')
    ah_arrayplot, info, xarray, yarray
   END
   
  'ytcen': BEGIN
    yarray = tcenarray
    info.ytitle = TEXTOIDL('log t_{c} (K)')
    ah_arrayplot, info, xarray, yarray
   END
   
  'ycoremass': BEGIN
    yarray = coremassarray
    info.ytitle = TEXTOIDL('Convective Core Mass Fraction')
    ah_arrayplot, info, xarray, yarray
   END
    

ENDCASE





END

;===================================
;=======ROUTINE FOR PLOTTING========
;===================================
PRO AH_ARRAYPLOT, info, x,y, models

wset,info.plot1_id
set_viewport,0.1,0.9,0.1,0.9
widget_control,info.xmin_base,get_value=xmin
widget_control,info.xmax_base,get_value=xmax
widget_control,info.ymin_base,get_value=ymin
widget_control,info.ymax_base,get_value=ymax
xreverse=info.xreverse
yreverse=info.yreverse
IF xreverse EQ 1 THEN xrange=[xmax,xmin] ELSE xrange=[xmin,xmax]
IF yreverse EQ 1 THEN yrange=[ymax,ymin] ELSE yrange=[ymin,ymax]

cgplot,[xmin,xmax],[ymin,ymax],/nodata,ytitle=info.ytitle, $
  xtitle=info.xtitle,title=info.title,xstyle=1,ystyle=1, $
  color=1,xrange=xrange, $
  yrange=yrange
  oplot,!x.crange,[0,0],line=2,color=1
  good = where((x ge xmin) and (x le xmax),ngood)
  symsize=1.6
  if ngood gt 100 then symsize=0.8
  if ngood gt 200 then symsize=0.5
  if ngood gt 300 then symsize=0.2
  if ngood gt 500 then symsize=0.01
  oplot,x[0],y[0],color=1,symsize=symsize,psym=-4
    wset,info.pixid
    device,copy=[0,0,950,450,0,0,info.plot1_id]
    wset,info.pixid2
    device,copy=[0,0,950,450,0,0,info.plot1_id]
    wset,info.plot1_id
  oplot,x[1],y[1],color=1,symsize=symsize,psym=-4
    wset,info.pixid
    device,copy=[0,0,950,450,0,0,info.plot1_id]
    wset,info.pixid2
    device,copy=[0,0,950,450,0,0,info.plot1_id]
    wset,info.plot1_id

  
  info.state = 'X/Y'
  return

END
;===================================================================
;===================================================================
;===========================MAIN ROUTINE============================
;===================================================================
;===================================================================

PRO AH_HRD_CENTRAL_CONDS_INTERAC_COM_V1, GLOBAL_TEMP_DIR=GLOBAL_TEMP_DIR,xrange=xrange,yrange=yrange, $
  min_val=min_val,max_val=max_val


COMMON AH_HRD_CENTRAL_CONDS_INTERAC_COM_V1_COMMON, info, xarray,yarray, $
    agearray, teffarray, lstararray, tcenarray, $
    rhocenarray, coremassarray
    
    
  IF N_ELEMENTS(TITLE) EQ 0 THEN TITLE=''
  IF N_ELEMENTS(XTITLE) EQ 0 THEN XTITLE=''
  IF N_ELEMENTS(YTITLE) EQ 0 THEN YTITLE=''
  IF N_ELEMENTS(MIN_VAL) EQ 0 THEN MIN_VAL=-1E37
  IF N_ELEMENTS(MAX_VAL) EQ 0 THEN MAX_VAL = 1E37
  

RETURN
END