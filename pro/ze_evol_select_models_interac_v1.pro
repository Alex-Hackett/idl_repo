
;right now can only DELETE lines
;+
;       ze_lamp_fit_wavecal_interac_v2
;       based on line_norm, trying to fit lamp lines interatively
;
; Widget to interactively normalize a spectrum
;
; CALLING SEQUENCE:
;
; ze_lamp_fit_wavecal_interac_v2,index,flux,xnodes,ynodes,xcen,ycen
;
; INPUTS
; index - input x vector with indices of lambda values 
; y - input y vector with flux
;
; OUTPUTS:
; xcen - array of centroid x positions
; ycen - array of centroid y positions
; OPTIONAL INPUT PARAMETERS
; ptitle - main plot title
; title - title of the plot or overplot vectors
; xtitle - title for the xaxis
; ytitle - title for the yaxis
; xrange - initial xrange for the plot
; yrange - initial yrange for the plot
; group - group id of calling widget
; modal - modal (set to make modal widget)
; 
; OPTIONAL INPUT/OUTPUTS
; xnodes - xnode positions of the spline
; ynodes - ynode positions of the spline
;
; INTERACTIVE INPUTS:
; In addition to the widget parameters controlled by buttons and
; text field inputs:
; 1) Use the left mouse button to move/drag a control point
; 2) Use the right button to add a new control point
; 3) Use center button to zoom.  (Select one corner, hold down and
;   drag to opposite corner of region to be zoomed)
;
;
; HISTORY:
; version 1  D. Lindler  Sept 1999
; Mar 2001, modified to work if wavelength vector is in descending
;   order
;-
;----------------------------------------------------------------------------  

;====================================================== line_norm_EVENT
;
; Main event driver for line_edit
;
pro ze_evol_select_models_interac_v1_event,event
  common ze_evol_select_models_common,info,modelstr,xarray,yarray,xnodes,ynodes,nodes_timestep,rsave,gsave,bsave,nm60,u160,u260,xtt60,xl60,u560,u760,u860,u1060,u1260,u660,xmdot60,xte60,eddesm60,rstar60,$
         logg60,vesc60,vinf60,eta_star60,Bmin60,Jdot60,logg_rphot60,rphot60,rapom260,rhoc60,tc60,u1560,u1760,u1860,u2060,u2260,u1660,beta60
  widget_control,event.id,get_uvalue=uvalue
  case uvalue of
  
;X VARIABLES  
  'xtstar': begin 
      xarray=xte60
      IF N_elements(xnodes) gt 0 THEN IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 1
      info.xtitle=TEXTOIDL('log T_* (K)')
      ze_line_plot_unzoom,info,xarray,yarray
    end  
  'xteffevol': begin 
      xarray=xtt60
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 1
      info.xtitle='log Teff (from evol)'
      ze_line_plot_unzoom,info,xarray,yarray
    end  
  'xlstar': begin 
      xarray=xl60
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('log (L_*/Lsun)')
      ze_line_plot_unzoom,info,xarray,yarray
    end 
  'xage': begin 
      xarray=u160
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Age (yr)')
      ze_line_plot_unzoom,info,xarray,yarray
    end 
   'xtime_bef_coll': begin 
      xarray=alog10(u160[n_elements(u160)-1]-u160)
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Age (yr)')
      ze_line_plot_unzoom,info,xarray,yarray
    end      
     'xtime_spent': begin 
      ;WORK HERE
      xarray=alog10(u160[n_elements(u160)-1]-u160)
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Age (yr)')
      ze_line_plot_unzoom,info,xarray,yarray
    end                            
  'xmass': begin 
      xarray=u260
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 1
      info.xtitle=TEXTOIDL('Mass (Msun)')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'xhydsurf': begin 
      xarray=u560
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('X_{surface}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'xhesurf': begin 
      xarray=u760
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Y_{surface}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'xcsurf': begin 
      xarray=u860
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('C_{surface}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'xnsurf': begin 
      xarray=u1060
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('N_{surface}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'xosurf': begin 
      xarray=u1260
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('O_{surface}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'xmdot': begin 
      xarray=xmdot60
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('\dot M (Msun/yr)')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'xvinf': begin 
      xarray=vinf60
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('V_\infty (km/s)')
      ze_line_plot_unzoom,info,xarray,yarray
    end       
  'xvesc': begin 
      xarray=vesc60
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('V_{esc} (km/s)')
      ze_line_plot_unzoom,info,xarray,yarray
    end       
  'xlogg*': begin 
      xarray=logg60
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('log g_* (cm^2/s)')
      ze_line_plot_unzoom,info,xarray,yarray
    end         
  'xgamma': begin 
      xarray=eddesm60
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('\Gamma')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'xrstar': begin 
      xarray=rstar60
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('R_* (Rsun)')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'xvrotvcrit': begin 
      xarray=rapom260
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('V_{rot}/V_{crit}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
   'xrhoc': begin 
      xarray=rhoc60
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Log \rho_{center} (g/cm^3)')
      ze_line_plot_unzoom,info,xarray,yarray
    end                               
  'xtc': begin 
      xarray=tc60
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Log T_{center} (K)')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'xhydcen': begin 
      xarray=u1560
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 1
      info.xtitle=TEXTOIDL('X_{center}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'xhecen': begin 
      xarray=u1760
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 1
      info.xtitle=TEXTOIDL('Y_{center}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'xccen': begin 
      xarray=u1860
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 1
      info.xtitle=TEXTOIDL('C_{center}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'xncen': begin 
      xarray=u2060
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 1
      info.xtitle=TEXTOIDL('N_{center}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'xocen': begin 
      xarray=u2260
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 1
      info.xtitle=TEXTOIDL('O_{center}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
;Y VARIABLES
  'ytstar': begin 
     yarray=xte60
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('log T_* (K)')
      ze_line_plot_unzoom,info,xarray,yarray
    end  
  'yteffevol': begin 
     yarray=xtt60
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle='log Teff (from evol)'
      ze_line_plot_unzoom,info,xarray,yarray
    end  
  'ylstar': begin 
     yarray=xl60
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('log L_*/Lsun')
      ze_line_plot_unzoom,info,xarray,yarray
    end 
  'yage': begin 
     yarray=u160
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('Age (yr)')
      ze_line_plot_unzoom,info,xarray,yarray
    end                
  'ymass': begin 
     yarray=u260
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('Mass (Msun)')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'yhydsurf': begin 
     yarray=u560
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('X_{surface}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'yhesurf': begin 
     yarray=u760
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('Y_{surface}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'ycsurf': begin 
     yarray=u860
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
        info.ytitle=TEXTOIDL('C_{surface}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'ynsurf': begin 
     yarray=u1060
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('N_{surface}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'yosurf': begin 
     yarray=u1260
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.ytitle=TEXTOIDL('O_{surface}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'ymdot': begin 
     yarray=xmdot60
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('\dot M (Msun/yr)')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'yvinf': begin 
     yarray=vinf60
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('V_\infty (km/s)')
      ze_line_plot_unzoom,info,xarray,yarray
    end       
  'yvesc': begin 
     yarray=vesc60
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('V_{esc} (km/s)')
      ze_line_plot_unzoom,info,xarray,yarray
    end       
  'ylogg*': begin 
     yarray=logg60
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('log g_* (cm^2/s)')
      ze_line_plot_unzoom,info,xarray,yarray
    end         
  'ygamma': begin 
     yarray=eddesm60
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('\Gamma')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'yrstar': begin 
     yarray=rstar60
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('R_* (Rsun)')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'yvrotvcrit': begin 
     yarray=rapom260
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('V_{rot}/V_{crit}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
   'yrhoc': begin 
      yarray=rhoc60
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('Log \rho_{center} (g/cm^3)')
      ze_line_plot_unzoom,info,xarray,yarray
    end                               
  'ytc': begin 
      yarray=tc60
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('Log T_{center} (K)')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'yhydcen': begin 
      yarray=u1560
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('X_{center}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'yhecen': begin 
      yarray=u1760
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('Y_{center}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'yccen': begin 
      yarray=u1860
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('C_{center}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'yncen': begin 
      yarray=u2060
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('N_{center}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
  'yocen': begin 
      yarray=u2260
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('O_{center}')
      ze_line_plot_unzoom,info,xarray,yarray
    end   
        
  'EXIT': begin
    wdelete,info.pixid
    wdelete,info.pixid2
    tvlct,rsave,gsave,bsave
    widget_control,event.top,/destroy
    return
    end
  'WRITE': begin
    case event.value of
    'Write.Postscript File': begin
      ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,xarray,yarray,info.xtitle,info.ytitle,modelstr,info=info
;      file = dialog_pickfile(file='idl.eps',path='/Users/jgroh/temp/',filter='*.eps',   /write)
;      if file eq '' then return ;no file selected
;      orig_device = !d.name
;      set_plot,'ps'
;      device,/port,bits=8,/color,/encapsulated,file=file
;      !p.font = 0
;      set_viewport,0.1,0.9,0.1,0.9
;      ze_line_plot,info,xarray,yarray,/ps
;      IF n_elements(xnodes) GT 0 THEN oplot,xnodes,ynodes,color=fsc_color('red'),symsize=1,psym=2,thick=2
;      device,/close
      set_plot,'x'
      ze_line_plot,info,xarray,yarray
      !p.font = -1
      end
    'Write.VADAT': begin

     
     for i=0, n_elements(xnodes) -1 do begin
        distance=SQRT((xnodes[i]-xarray)^2 + (ynodes[i]-yarray)^2)
        min_distance=min(distance,j)
        evol_vadat_file='/Users/jgroh/temp/EVOL_VADAT_grid_'+modelstr+'_model'+strtrim(string(j,FORMAT='(I6.6)'),2)+'_T'+strtrim(string(10^xte60[j],FORMAT='(I6.6)'),2)+'_L'+$
               strtrim(string(10^xl60[j],FORMAT='(I7.7)'),2)+'_logg'+strtrim(string(logg60[j],FORMAT='(F5.3)'),2)     
        ZE_EVOL_WRITE_INPUT_TO_CMFGEN_VADAT_FORMAT,j,u160[j],u260[j],xte60[j],xtt60[j],xl60[j],rstar60[j],logg60[j],xmdot60[j],vinf60[j],beta60[i],$
                                           u560[j],u760[j],u860[j],u1060[j],u1260[j],u660[j],evol_vadat_file,modelstr,popscl=1 
      endfor
      end
    'Write.DIRNAMES': begin
      for i=0, n_elements(xnodes) -1 do begin
        distance=SQRT((xnodes[i]-xarray)^2 + (ynodes[i]-yarray)^2)
        min_distance=min(distance,j)        
        print,'mkdir model'+strtrim(string(j,FORMAT='(I6.6)'),2)+'_T'+strtrim(string(10^xte60[j],FORMAT='(I6.6)'),2)+'_L'+$
               strtrim(string(10^xl60[j],FORMAT='(I7.7)'),2)+'_logg'+strtrim(string(logg60[j],FORMAT='(F5.3)'),2)
      endfor         
     end          
    endcase
    end
  'MAIN': 
  'ZOOM': begin
    widget_control,info.message,set_v= $
      'Place Cursor on first corner and push left mouse button'
    info.state = 'ZOOM1'
    end
  'UNZOOM': begin
    widget_control,info.xmin_base,set_value = min(xarray)
    widget_control,info.xmax_base,set_value = max(xarray) 
    widget_control,info.ymin_base,set_value = min(yarray)
    widget_control,info.ymax_base,set_value = max(yarray)
    ze_line_plot,info,xarray,yarray
    widget_control,info.xmin_base,get_v=x1
    widget_control,info.xmax_base,get_v=x2
    end
  'RANGE': begin
    widget_control,info.xmin_base,get_v=x1
    widget_control,info.xmax_base,get_v=x2
    ze_line_plot,info,xarray,yarray
    end
  'XLOG': begin
    info.xlog = 1 - info.xlog
    if info.xlog eq 1 then v='X Linear' else v='X Log'
    widget_control,info.xbutton,set_value=v
    ze_line_plot,info,xarray,yarray
    end
  'SAVE_NODES': begin
     file = dialog_pickfile(file='/Users/jgroh/temp/nodes_temp_'+modelstr+'.txt',filter='*timestep*.txt',   /write)
     if file eq '' then return ;no file selected
     IF n_elements(xnodes) gt 0 THEN ZE_WRITE_SPECTRA_COL_VEC,file,xnodes,ynodes
    end  
  'LOAD_NODES': begin
     file = dialog_pickfile(file='/Users/jgroh/temp/nodes_temp_'+modelstr+'.txt',filter='*.txt',   /read)
     ZE_READ_SPECTRA_COL_VEC,file,xnodes,ynodes
    end 
  'SAVE_NODES_DEFAULT': begin  
     IF n_elements(xnodes) gt 0 THEN  ZE_WRITE_SPECTRA_COL_VEC,'/Users/jgroh/temp/nodes_'+modelstr+'.txt',xnodes,ynodes
    end  
  'LOAD_NODES_DEFAULT': begin
     ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/nodes_'+modelstr+'.txt',xnodes,ynodes
     ze_find_closest_value_to_node,xnodes,ynodes,xarray,yarray,nodes_timestep
    end     
  'LOAD_NODES_TIMESTEP': begin
    file = dialog_pickfile(file='',path='/Users/jgroh/temp/',filter='*.txt',   /read)
    readcol,file,timesteps_read
    xnodes=xarray[timesteps_read]
    ynodes=yarray[timesteps_read]
    nodes_timestep=timesteps_read
    end         
   'DELETE_ALL_NODES': begin
    undefine,xnodes,ynodes,nodes_timestep
    ze_line_plot,info,xarray,yarray       
    end  
   'ANALYZE_VFILE': begin
     
    info.state = 'V_FILE'  
    widget_control,info.message,set_v= $
    'Position at node and'+ $
    ' push left mouse button'    

    end   
    'PLOT_SPECTRUM': begin
     
    info.state = 'PLTSPEC'  
    widget_control,info.message,set_v= $
    'Position at node and'+ $
    ' push left mouse button'    
    
    end   
        'FIND_MODEL': begin
     
    info.state = 'FINDMODEL'  
    end
    'OTHER_TRACK': begin
     
    info.state = 'OTHERTRACK'  
    ze_evol_select_models_interac_v1,'P060z14S0',group=event.top,/MODAL   
     
    end 
  'YLOG': begin
    info.ylog = 1 - info.ylog
    if info.ylog eq 1 then v='Y Linear' else v='Y Log'
    widget_control,info.ybutton,set_value=v
    ze_line_plot,info,xarray,yarray
    end
  'DEGREE': begin
    info.degree = event.value
    wset,info.plot1_id
    device,copy=[0,0,950,450,0,0,info.pixid]
    end
  'ADD_NODE': Begin
    info.state = 'ADD'    
    widget_control,info.message,set_v= $
        'Position at node and'+ $
        ' push left mouse button'
    end
  'DELETE_NODE': Begin
    widget_control,info.message,set_v= $
        'Position at node and'+ $
        ' push left mouse button'
    info.state = 'DELETE'
    end
    
  'PLOT1': begin
    xd = event.x  ;device coordinates
    yd = event.y
    v = convert_coord(xd,yd,/dev,/to_data) ; data coordinates
    wset,info.plot1_id
    device,copy=[0,0,950,450,0,0,info.pixid2]
    if (info.state eq 'X/Y') then begin
        plots,[xd,xd],[0,450],color=1,/dev
        plots,[0,950],[yd,yd],color=1,/dev
        widget_control,info.message,set_value= $
      'X = '+strtrim(v(0),2)+'    Y = '+strtrim(v(1),2)
        if event.press eq 2 then begin
        info.x1 = xd
        info.y1 = yd
        info.state = 'ZOOM2'
        return
        endif
        if event.press eq 1 then info.state = 'DRAG'        
        if (info.state eq 'X/Y') and (event.press ne 4) then return
    end
;
;click to show properties
       if (event.press eq 4) then begin
       distance=SQRT((v(0)-xarray)^2 + (v(1)-yarray)^2)
       min_distance=min(distance,indexmin)      
        widget_control,info.message,set_value= $
        'N= '+strtrim(indexmin,2)+ ' T*= '+strtrim(string(10^xte60[indexmin],format='(I7)'),2) + ' L*= '+strtrim(string(10^xl60[indexmin],format='(I7)'),2) + $  
        ' logg*= '+ strtrim(string(logg60[indexmin],format='(F6.3)'),2) + ' R*= '+strtrim(string(rstar60[indexmin],format='(F7.2)'),2) + ' R*(cmfgen)= '+strtrim(string(rstar60[indexmin]*6.955,format='(F7.2)'),2) + $
         ' Mdot= '+strtrim(string(10^xmdot60[indexmin],format='(E7.1)'),2) +$
        ' vinf= '+strtrim(string(vinf60[indexmin],format='(I5)'),2)+ ' X= '+strtrim(string(u560[indexmin],format='(F7.2)'),2) + ' Y= '+strtrim(string(u760[indexmin],format='(F7.2)'),2) +$
        ' C= '+strtrim(string(u860[indexmin],format='(E7.0)'),2) + ' N= '+strtrim(string(u1060[indexmin],format='(E7.0)'),2) + ' O= '+strtrim(string(u1260[indexmin],format='(E7.0)'),2) +$  
        ' Age= ' + strtrim(string(u160[indexmin],format='(E13.7)'),2) + ' Mass= '+strtrim(string(u260[indexmin],format='(F7.2)'),2) + $
        ' R_t= ' +strtrim(string(rstar60[indexmin]*((vinf60[indexmin]/2500.)/(10^xmdot60[indexmin]/1e-4))^0.6666,format='(F7.2)'),2) + ' beta ='+strtrim(string(beta60[indexmin],format='(F4.1)'),2)

      info.state = 'X/Y'
      goto,replot_spline
    end

; Add Node
;
    if ((event.press eq 1) and (info.state eq 'ADD')) then begin
      distance=SQRT((v(0)-xarray)^2 + (v(1)-yarray)^2)
      min_distance=min(distance,indexmin)

      if n_elements(xnodes) lt 1 THEN begin
        xnodes=xarray[indexmin]
        ynodes=yarray[indexmin]
        nodes_timestep=nm60[indexmin]
      endif else begin 
        xnodes = [xnodes,xarray[indexmin]]
        ynodes = [ynodes,yarray[indexmin]]
        nodes_timestep=[nodes_timestep,nm60[indexmin]]
      endelse  
      sub = sort(nodes_timestep)
      xnodes = xnodes(sub)
      ynodes = ynodes(sub)
      nodes_timestep=nodes_timestep(sub)
      info.state = 'X/Y'
      widget_control,info.message,set_value=' '
      goto,replot_spline
    end
;
; Delete Node
;
 ;   if (event.press eq 4) or $
   if  ((event.press eq 1) and (info.state eq 'DELETE')) then begin
     if n_elements(xnodes) lt 1 THEN begin
        r1 = dialog_message('There are no nodes to delete', /error,dialog_parent=event.top)
        return
     endif   
      diff = abs(xnodes-v(0))
      good = where(diff ne min(diff),ngood)
      if ngood lt 1 then begin
          r = dialog_message('There are no nodes to delete 2', $
              /error,dialog_parent=event.top)
          end else begin
        xnodes = xnodes(good)       
        ynodes = ynodes(good)
        nodes_timestep=nodes_timestep(good)
      end
      info.state = 'X/Y' 
      widget_control,info.message,set_value=' '
      goto,replot_spline
    end     
;
; Drag Node
;
    if (info.state eq 'DRAG') then begin
      if n_elements(xnodes) gt 0 then begin
        distance=SQRT((v(0)-xarray)^2 + (v(1)-yarray)^2)
        min_distance=min(distance,indexmin)
        diff = sqrt((xnodes-xarray[indexmin])^2+(ynodes-yarray[indexmin])^2)
        good = where(diff eq min(diff))
        info.node = good(0)
        xnodes(info.node) = xarray[indexmin]
        ynodes(info.node) = yarray[indexmin]
        nodes_timestep(info.node)=nm60[indexmin]
      endif
      if (event.release gt 0) then info.state = 'X/Y' 
      goto,replot_spline      
    end

; Analyze v file

    if ((event.press eq 1) AND (info.state eq 'V_FILE')) then begin
        distance=SQRT((v(0)-xarray)^2 + (v(1)-yarray)^2)
        min_distance=min(distance,indexmin)
        vfile_timestep=round(nm60[indexmin]/10.)*10 + 1        
     ze_evol_analyze_v_file_interac_v3,modelstr, vfile_timestep,group=event.top,/MODAL
     info.state = 'X/Y' 
     widget_control,info.message,set_value=' '
     ze_line_plot,info,xarray,yarray
    endif

;find closest model
   if ((event.press eq 1) and (info.state eq 'FINDMODEL')) then begin
     distance=SQRT((v(0)-xarray)^2 + (v(1)-yarray)^2)
     min_distance=min(distance,indexmin)
    modelid=string(indexmin,format='(I6)')
    ZE_CMFGEN_EVOL_FIND_CLOSEST_MODEL,10^xte60[indexmin],10^xl60[indexmin],10^xmdot60[indexmin],vinf60[indexmin],u560[indexmin],u760[indexmin],$
                                      u860[indexmin],u1060[indexmin],u1260[indexmin],xn_array_sort,tstar_array_sort,lstar_array_sort,mdot_array_sort,vinf_array_sort,r_t_array_sort,tcut=0.3,/xwidget,modelid=modelid
    
 endif
 ; Plot spectrum

    if ((event.press eq 1) AND (info.state eq 'PLTSPEC')) then begin
        distance=SQRT((v(0)-xnodes)^2 + (v(1)-ynodes)^2)
        min_distance=min(distance,spec_timestep)      
     ze_evol_plot_spectrum_interac_v1,modelstr, vfile_timestep,group=event.top,/MODAL
     info.state = 'X/Y' 
     widget_control,info.message,set_value=' '
     ze_line_plot,info,xarray,yarray
    endif
    
;
; First Zoom Corner
;
    if (info.state eq 'ZOOM1') and  $
       (event.press eq 1) then begin
            plots,[xd,xd],[0,450],color=1,/dev
          plots,[0,950],[yd,yd],color=1,/dev
        info.x1 = xd
      info.y1 = yd
      widget_control,info.message,set_v= $
        'Position at second corner and'+ $
        ' push left mouse button'
      info.state = 'ZOOM2'
      return
    endif
;
; Second Zoom Corner
;
    if (info.state eq 'ZOOM2') then begin
        x = [info.x1,xd]
        y = [info.y1,yd]
        plots,[x(0),x(1),x(1),x(0),x(0)], $
        [y(0),y(0),y(1),y(1),y(0)],/dev,color=1
        
        if (event.release eq 2) or (event.press eq 1) then begin
      v = convert_coord(x,y,/dev,/to_data)
      x = v(0,*)
      y = v(1,*)        
          widget_control,info.xmin_base,set_value = min(x)
      widget_control,info.xmax_base,set_value = max(x)
      widget_control,info.ymin_base,set_value = min(y)
      widget_control,info.ymax_base,set_value = max(y)
      ze_line_plot,info,xarray,yarray
      widget_control,info.xmin_base,get_v=x1
      widget_control,info.xmax_base,get_v=x2

      goto,replot_spline
        end else return
    end     
      
    end
  else:
  endcase
replot_spline:
  wset,info.plot1_id
  device,copy=[0,0,950,450,0,0,info.pixid]
  IF N_elements(xnodes) gt 0 THEN oplot,xnodes,ynodes,color=fsc_color('red'),symsize=1,psym=2,thick=2

  wset,info.pixid2
  device,copy=[0,0,950,450,0,0,info.plot1_id]
  wset,info.plot1_id
  return
  end


;;============================================================ ZE_LINE_PLOT_UNZOOM
PRO ze_find_closest_value_to_node,xpoint,ypoint,xvector,yvector,indexvector
  IF N_elements(xpoint) gt 0 THEN BEGIN
    indexvector=dblarr(n_elements(xpoint))
    for i=0, n_elements(xpoint) -1 do begin
      distancenodes=SQRT((xpoint[i]-xvector)^2 + (ypoint[i]-yvector)^2)
      min_distancenodes=min(distancenodes,indexval) 
      indexvector[i]=indexval
    endfor
  ENDIF
    print,indexvector
END  
;============================================================ ZE_LINE_PLOT_UNZOOM
PRO ze_line_plot_unzoom,info,x,y
    ;WORK HERE TO IMPLEMENT REVERSE
    xreverse=info.xreverse
    yreverse=info.yreverse

    widget_control,info.xmin_base,set_value = min(x)
    widget_control,info.xmax_base,set_value = max(x)
    widget_control,info.ymin_base,set_value = min(y)
    widget_control,info.ymax_base,set_value = max(y)
 ;  ENDELSE 
    ze_line_plot,info,x,y
    widget_control,info.xmin_base,get_v=x1
    widget_control,info.xmax_base,get_v=x2
    end
    
;============================================================ LINE_NORM_PLOT
;
; Routine to generate the normalized plot ; we don't need that in ze_lamp_line_id, but eventullay will want to adapt it 
;
pro ze_line_plot,info,x,y,ps=ps
   
  if not keyword_set(ps) then begin
    wset,info.plot1_id
    set_viewport,0.1,0.9,0.1,0.9
  end
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
    xlog=info.xlog,ylog=info.ylog,color=1,xrange=xrange, $
    yrange=yrange
  if info.ylog ne 1 then oplot,!x.crange,[0,0],line=2,color=1
  good = where((x ge xmin) and (x le xmax),ngood)
  symsize=1.6
  if ngood gt 100 then symsize=0.8
  if ngood gt 200 then symsize=0.5
  if ngood gt 300 then symsize=0.2
  if ngood gt 500 then symsize=0.01
  oplot,x,y,color=1,symsize=symsize,psym=-4
  if not keyword_set(ps) then begin
    wset,info.pixid
    device,copy=[0,0,950,450,0,0,info.plot1_id]
    wset,info.pixid2
    device,copy=[0,0,950,450,0,0,info.plot1_id]
    wset,info.plot1_id
  end
  info.state = 'X/Y'
return
end


;==================================================================== LINE_EDIT
;
; Plot widget main routine  
  
pro ze_evol_select_models_interac_v1,model, $
  title=title,xtitle=xtitle,ytitle=ytitle, $
  group=group,xrange=xrange,yrange=yrange, $
  min_val=min_val,max_val=max_val, modal=modal
;
; CALLING SEQUENCE:
; 
  if n_params(0) lt 1 then begin
    print,'CALLING SEQUENCE: line_norm,x,y,ynorm,norm
    print,'KEYWORD INPUTS: title,xtitle,ytitle,xrange,yrange
    return
  end
  
  
  common ze_evol_select_models_common,info,modelstr,xarray,yarray,xnodes,ynodes,nodes_timestep,rsave,gsave,bsave,nm60,u160,u260,xtt60,xl60,u560,u760,u860,u1060,u1260,u660,xmdot60,xte60,eddesm60,$
          rstar60,logg60,vesc60,vinf60,eta_star60,Bmin60,Jdot60,logg_rphot60,rphot60,rapom260,rhoc60,tc60,u1560,u1760,u1860,u2060,u2260,u1660,beta60
  if n_elements(title) eq 0 then title=''
  if n_elements(xtitle) eq 0 then xtitle=''
  if n_elements(ytitle) eq 0 then ytitle=''
  if n_elements(min_val) eq 0 then min_val=-1e37
  if n_elements(max_val) eq 0 then max_val = 1e37
 
 modelstr=model
;
; initilization 
;
dir='/Users/jgroh/evol_models/Grids2010/wg'
wgfile=dir+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut

ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar60,logg60,vesc60,vinf60,eta_star60,Bmin60,Jdot60,logg_rphot60,rphot60,beq60,beta60
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm60,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u160,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u260,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt60,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl60,index_varnamey_wgfile,return_valy
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u560,return_valz    ;X surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u7',data_wgfile_cut,u760,return_valz    ;Y surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u8',data_wgfile_cut,u860,return_valz    ;C surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u1060,return_valz  ; N surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u12',data_wgfile_cut,u1260,return_valz   ; O surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u6',data_wgfile_cut,u660,return_valz   ; Ne surface
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rhoc',data_wgfile_cut,rhoc60,return_valz   ; 
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'tc',data_wgfile_cut,tc60,return_valz   ; 
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u1560,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u1760,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u1860,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u2060,return_valz    ;N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u2260,return_valz    ;O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u1660,return_valz    ;Ne20 center


ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xmdot',data_wgfile_cut,xmdot60,return_valz  
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xte',data_wgfile_cut,xte60,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'eddesm',data_wgfile_cut,eddesm60,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'rapom2',data_wgfile_cut,rapom260,index_varnamex_wgfile,return_valx


xarray=xte60
yarray=xl60

ns = n_elements(xarray)
 
  tvlct,r,g,b,/get
  rsave = r
  gsave = g
  bsave = b
  r(0) = [255,0,255, 0]
  g(0) = [255,0,  0, 255]
  b(0) = [255,0,  0, 0]
  tvlct,r,g,b
  set_xy
  set_viewport 

;;  widget_control,default_font  = $
;;     '-adobe-helvetica-bold-r-normal--14-140-75-75-p-82-iso8859-1'
  main = widget_base(/col,group=group,/tracking,uvalue='MAIN', $
      title='Visualization of Evolutionary Track',modal=modal)
  menu = widget_base(main,/row,/frame)
  exit = widget_button(menu,value='EXIT',uvalue='EXIT')
  desc = ['1\Write','0\Postscript File','0\VADAT','2\DIRNAMES']
  button = cw_pdmenu(menu,desc,uvalue='WRITE',/return_full_name)
  zoom = widget_button(menu,uvalue='ZOOM',value='Zoom')
  unzoom = widget_button(menu,uvalue='UNZOOM',value='UnZoom')
  xbutton = widget_button(menu,uvalue='XLOG',value='X Log     ')
  ybutton = widget_button(menu,uvalue='YLOG',value='Y Log     ')
  button = widget_button(menu,value='ADD Node',uvalue='ADD_NODE')
  button = widget_button(menu,value='DELETE Node',uvalue='DELETE_NODE')
  button = widget_button(menu,value='DELETE ALL Nodes',uvalue='DELETE_ALL_NODES')  
  button = widget_button(menu,value='SAVE NODES',uvalue='SAVE_NODES')
  button = widget_button(menu,value='LOAD NODES',uvalue='LOAD_NODES')  
  button = widget_button(menu,value='SAVE NODES DEFAULT',uvalue='SAVE_NODES_DEFAULT')
  button = widget_button(menu,value='LOAD NODES DEFAULT',uvalue='LOAD_NODES_DEFAULT')  
  button = widget_button(menu,value='LOAD NODES FROM TIMESTEP',uvalue='LOAD_NODES_TIMESTEP') 
  button = widget_button(menu,value='ANALYZE V FILE',uvalue='ANALYZE_VFILE')  
  button = widget_button(menu,value='PLOT SPECTRUM',uvalue='PLOT_SPECTRUM')  
  button = widget_button(menu,value='FIND CLOSEST MODEL',uvalue='FIND_MODEL')  
   button = widget_button(menu,value='INSPECT OTHER TRACK',uvalue='OTHER_TRACK')    

  lab = widget_label(main,value='X Axis')
  xvar = widget_base(main,/row,/exclusive,/toolbar)
  buttonxtstar = widget_button(xvar,value='Tstar',uvalue='xtstar')
  button = widget_button(xvar,value='Lstar',uvalue='xlstar') 
  button = widget_button(xvar,value='Teff evol',uvalue='xteffevol')
  button = widget_button(xvar,value='Age',uvalue='xage')  
  button = widget_button(xvar,value='Time coll.',uvalue='xtime_bef_coll')  
  button = widget_button(xvar,value='Time spent',uvalue='xtime_spent')       
  button = widget_button(xvar,value='Mass',uvalue='xmass') 
  button = widget_button(xvar,value='X_surf',uvalue='xhydsurf') 
  button = widget_button(xvar,value='Y_surf',uvalue='xhesurf')        
  button = widget_button(xvar,value='C_surf',uvalue='xcsurf')  
  button = widget_button(xvar,value='N_surf',uvalue='xnsurf') 
  button = widget_button(xvar,value='O_surf',uvalue='xosurf') 
  button = widget_button(xvar,value='Mdot',uvalue='xmdot')   
  button = widget_button(xvar,value='Vinf',uvalue='xvinf')     
  button = widget_button(xvar,value='Vesc',uvalue='xvesc')   
  button = widget_button(xvar,value='Vrot/Vcrit',uvalue='xvrotvcrit')     
  button = widget_button(xvar,value='log g*',uvalue='xlogg*')     
  button = widget_button(xvar,value='Gamma',uvalue='xgamma') 
  button = widget_button(xvar,value='Rstar',uvalue='xrstar') 
   button = widget_button(xvar,value='rho cen',uvalue='xrhoc')     
  button = widget_button(xvar,value='T cen',uvalue='xtc') 
  button = widget_button(xvar,value='X_cen',uvalue='xhydcen') 
  button = widget_button(xvar,value='Y_cen',uvalue='xhecen')        
  button = widget_button(xvar,value='C_cen',uvalue='xccen')  
  button = widget_button(xvar,value='N_cen',uvalue='xncen') 
  button = widget_button(xvar,value='O_cen',uvalue='xocen')  
  
  
    
 
  lab = widget_label(main,value='Y Axis')
  yvar = widget_base(main,/row,/exclusive,/toolbar)
  button = widget_button(yvar,value='Tstar',uvalue='ytstar')
  buttonylstar = widget_button(yvar,value='Lstar',uvalue='ylstar') 
  button = widget_button(yvar,value='Teff evol',uvalue='yteffevol')
  button = widget_button(yvar,value='Age',uvalue='yage')   
  button = widget_button(yvar,value='Mass',uvalue='ymass') 
  button = widget_button(yvar,value='X_surf',uvalue='yhydsurf') 
  button = widget_button(yvar,value='Y_surf',uvalue='yhesurf')        
  button = widget_button(yvar,value='C_surf',uvalue='ycsurf')  
  button = widget_button(yvar,value='N_surf',uvalue='ynsurf') 
  button = widget_button(yvar,value='O_surf',uvalue='yosurf') 
  button = widget_button(yvar,value='Mdot',uvalue='ymdot')   
  button = widget_button(yvar,value='Vinf',uvalue='yvinf')     
  button = widget_button(yvar,value='Vesc',uvalue='yvesc')   
  button = widget_button(yvar,value='Vrot/Vcrit',uvalue='yvrotvcrit')     
  button = widget_button(yvar,value='log g*',uvalue='ylogg*')     
  button = widget_button(yvar,value='Gamma',uvalue='ygamma') 
  button = widget_button(yvar,value='Rstar',uvalue='yrstar')   
    button = widget_button(yvar,value='rho cen',uvalue='yrhoc')     
  button = widget_button(yvar,value='T cen',uvalue='ytc') 
  button = widget_button(yvar,value='X_cen',uvalue='yhydcen') 
  button = widget_button(yvar,value='Y_cen',uvalue='yhecen')        
  button = widget_button(yvar,value='C_cen',uvalue='yccen')  
  button = widget_button(yvar,value='N_cen',uvalue='yncen') 
  button = widget_button(yvar,value='O_cen',uvalue='yocen')  
          
  message = widget_text(main,xsize=80,value=' ')
;
; draw window
;
  plot1 = widget_draw(main,uvalue='PLOT1',retain=2, $
        xsize=950,ysize=450,/button_events,/motion)

  basex = widget_base(main,/row,/frame) 
        xmin_base = cw_field(basex,/row,uvalue='RANGE',value=min(xarray), $
                title='X Min: ',xsize=13,/return_events,/float)
        xmax_base = cw_field(basex,/row,uvalue='RANGE',value=max(xarray), $
                title='X Max: ',xsize=13,/return_events,/float)
        ymin_base = cw_field(basex,/row,uvalue='RANGE',value=min(yarray), $
                title='Y Min: ',xsize=13,/return_events,/float)
        ymax_base = cw_field(basex,/row,uvalue='RANGE',value=max(yarray), $
                title='Y Max: ',xsize=13,/return_events,/float)

; create two pixmaps
;
  window,xs=950,ys=450,/pixmap,/free
  pixid = !d.window
  window,xs=950,ys=450,/pixmap,/free
  pixid2 = !d.window
;
; save widget info in structure
;
  widget_control,main,/realize
  widget_control,plot1,get_value=plot1_id

  info = {message:message,ns:ns,pixid:pixid,pixid2:pixid2,xtitle:xtitle, $
    ytitle:ytitle,title:modelstr,plot1:plot1, $
    main:main,xmin:min(xarray),ymin:min(yarray), $
    xmax:max(xarray),ymax:max(yarray),xlog:0,ylog:0,xmin_base:xmin_base, $
    ymin_base:ymin_base,xmax_base:xmax_base,ymax_base:ymax_base, $
    state:'X/Y',xbutton:xbutton,ybutton:ybutton, $
    x1:0, y1:0, node:0, plot1_id:plot1_id,  $
    min_val:min_val,max_val:max_val,xreverse:1,yreverse:0}
;
; set initial range
; 
  if n_elements(xrange) gt 0 then begin
    widget_control,info.xmin_base,set_v=xrange(0)
    widget_control,info.xmax_base,set_v=xrange(1)
  end
  if n_elements(yrange) gt 0 then begin
    widget_control,info.ymin_base,set_v=yrange(0)
    widget_control,info.ymax_base,set_v=yrange(1)
  end
;
; set initial control points
;
       x1 = min(xarray)
       x2 = max(xarray)

;
; create initial plot, HR diagram T* x L*
;
  info.xtitle=TEXTOIDL('log T_* (K)')
  info.ytitle=TEXTOIDL('log L_*/Lsun')
  widget_control,info.xmin_base,get_v=x1
  widget_control,info.xmax_base,get_v=x2
  widget_control,buttonxtstar,set_button=1
  widget_control,buttonylstar,set_button=1  
  ze_line_plot,info,xarray,yarray
  
  xmanager,'ze_evol_select_models_interac_v1',main

  
    
  info = 0
  xarray = 0
  yarray = 0
  
  return
  end