;
; Main event driver for line_edit
;
pro ze_evol_analyze_struct_file_interac_v1_event,event
  
  common ze_evol_analyze_struct_file_interac_common,info,modelstr,timestepstr,xarray,yarray,xnodes,ynodes,nodes_timestep,rsave,gsave,bsave, $
            n,logr,Mint,logT,logrho,logP,Cv,dlnP_over_dlnrho_T , $
            dlnP_over_dlnT_rho,nabla_e,nabla_ad,Lrad,Ltot,logkappa,dlnk_over_dlnrho_T ,$
            dlnk_over_dlnT_rho,epsilon ,  dlnE_over_dlnrho_T ,  dlnE_over_dlnT_rho,X_H1,X_He4,mu,mu0,Omega,$
            logprad,logpgas,prad_over_ptot,pgas_over_ptot,logpturb,ledd,gammafull_rad,gammafull_tot,nablarad,ebind,logteff

  widget_control,event.id,get_uvalue=uvalue
  
 ; widget_control,event.top,get_uvalue=info
 ; if event.top eq event.id then return
  ;widget_control,event.id,get_uvalue=uvalue
  ;compute = 0 ;recompute equivalent widget
 ; wset,(*info).plot_id;
  
  case uvalue of
  
;X VARIABLES  
  'xn': begin 
      xarray=n
      IF N_elements(xnodes) gt 0 THEN IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Layer number n')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end  
  'xlogr': begin 
      xarray=logr
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle='log R (cm)'
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end         
  'xMint': begin 
      xarray=Mint/1.9891e33
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle='Mass coordinate (Msun)'
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end
  'xMintnorm': begin 
      xarray=Mint/Mint[n_elements(Mint)-1]
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle='Mass coordinate normalized'
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end 
  'xMext': begin 
      xarray=alog10((Mint[n_elements(Mint)-1]-Mint)/1.9891e33)
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle='External mass coordinate (Msun)'
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end                 
  'xr': begin 
     xarray=(10^logr) /(6.955e10)
     IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
     info.xtitle='R (Rsun)'
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end                
  'xlogt': begin 
      xarray=logt
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('log T (K)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end 
      'xlogrho': begin 
      xarray=logrho
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('log rho')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end 
      'xlogp': begin 
      xarray=logp
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('log P')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end 
  'xlogkappa': begin 
      xarray=logkappa
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('log kappa')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end                            
  'xlrad': begin 
      xarray=lrad
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('X')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end   
  'xltot': begin 
      xarray=ltot
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Y')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end   
   'xtau': begin 
      xarray=alog10(4D0/3D0 * (10^logt/10^logteff)^4 - 2d0/3D0)
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=textoidl('Log Tau (erg)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray   
    end  

;Y VARIABLES
   'yn': begin 
      yarray=n
      IF N_elements(ynodes) gt 0 THEN IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('Layer number n')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end  
  'ylogr': begin 
      yarray=logr
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle='log R (cm)'
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end         
  'yMint': begin 
      yarray=Mint/1.9891e33
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle='Mass coordinate (Msun)'
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end
  'yMintnorm': begin 
      yarray=Mint/Mint[n_elements(Mint)-1]
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle='Mass coordinate normalized'
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end   
   'yMext': begin 
      yarray=alog10((Mint[n_elements(Mint)-1]-Mint)/1.9891e33)
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle='External mass coordinate (Msun)'
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end        
  'yr': begin 
     yarray=(10^logr) /(6.955e10)
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle='R (Rsun)'
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end                
  'ylogt': begin 
      yarray=logt
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('log T (K)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end 
      'ylogrho': begin 
      yarray=logrho
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('log rho')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end 
      'ylogp': begin 
      yarray=logp
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('log P')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end 
      'ylogprad': begin 
      yarray=alog10((7.5657e-15/3D0)*(10^logt)^4)   ;Prad=(a/3)T^4
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('log P')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end 
      'ylogpgas': begin 
      yarray=alog10(8.3144621e7*10^logrho*10^logT/mu)   ;Prad=(a/3)T^4
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('log P')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end
   'ylogpturb': begin 
      yarray=pgas_over_ptot
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('Ltot (Lsun)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end              
   'yprad_over_ptot': begin 
      yarray=(7.5657e-15/3D0)*(10^logt)^4/10^logp
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('Ltot (Lsun)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end   
   'ypgas_over_ptot': begin 
      yarray=pgas_over_ptot
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('Ltot (Lsun)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end              
  'ylogkappa': begin 
      yarray=10^logkappa
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('log kappa')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end                            
  'ylrad': begin 
      yarray=lrad/3.839e33
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('Lrad (Lsun)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end   
  'yltot': begin 
      yarray=ltot/3.839e33
      yarray=16.d0*!pi*7.5657e-15*29979245800.0*6.67e-8/3.d0 *Mint*10.d0^(4.d0*logT-logkappa-logP) * nabla_e/3.839e33
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('Ltot (Lsun)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end   
  'yledd': begin 
      yarray=(4d0*!PI*29979245800*6.67e-8*Mint/10^logkappa)/3.839e33
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('Ltot (Lsun)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end  
   'ylrad_over_ltot': begin 
      yarray=lrad/ltot
      yarray[0]=0.0 ;definition, since we have Lrad and Ltot=0
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('Ltot (Lsun)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end      
  'ygammafull': begin 
      yarray=1D0*lrad*10^logkappa/(4d0*!PI*29979245800*6.67e-8*Mint)
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('Ltot (Lsun)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end  
  'ynablae': begin 
      yarray=nabla_e
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('Ltot (Lsun)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end        
  'ynablaad': begin 
      yarray=nabla_ad
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('Ltot (Lsun)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end   
  'ynablarad': begin 
      yarray=(3D0*(10^logkappa)*ltot*10^logp)/(16D0*!PI*7.5657e-15*2997925800.0*6.67e-8*mint*(10^logt^4))
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('Ltot (Lsun)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end   
   'yh1': begin 
      yarray=X_H1
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('H fraction')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end    
   'yhe4': begin 
      yarray=X_He4
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('He4 fraction')
      ze_structfile_line_plot_unzoom,info,xarray,yarray
    end                      
   'yebind': begin 
      yarray=alog10(ebind)
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('Log Ebinding (erg)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray,ymin=40,ymax=53   
    end   
   'ytau': begin 
      yarray=alog10(4D0/3D0 * (10^logt/10^logteff)^4 - 2d0/3D0)
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=textoidl('Log Tau (erg)')
      ze_structfile_line_plot_unzoom,info,xarray,yarray   
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
      ZE_EVOL_PLOT_XY_GENERAL_EPS_v2,xarray,yarray,info.xtitle,info.ytitle,modelstr,info=info
;      file = dialog_pickfile(file='idl.eps',path='/Users/jgroh/temp/',filter='*.eps',   /write)
;      if file eq '' then return ;no file selected
;      orig_device = !d.name
;      set_plot,'ps'
;      device,/port,bits=8,/color,/encapsulated,file=file
;      !p.font = 0
;      set_viewport,0.1,0.9,0.1,0.9
;      ze_vfile_line_plot,info,xarray,yarray,/ps
;      IF n_elements(xnodes) GT 0 THEN oplot,xnodes,ynodes,color=fsc_color('red'),symsize=1,psym=2,thick=2
;      device,/close
      set_plot,'ps'
      ze_structfile_line_plot,info,xarray,yarray
      !p.font = -1
      end
    'Write.VADAT': begin

     beta=1.0
     for i=0, n_elements(xnodes) -1 do begin
        distance=SQRT((xnodes[i]-xarray)^2 + (ynodes[i]-yarray)^2)
        min_distance=min(distance,j)
        evol_vadat_file='/Users/jgroh/temp/EVOL_VADAT_model_'+modelstr+'_timestep_'+strtrim(string(j,FORMAT='(I6)'),2)+'.txt'     
        ZE_EVOL_WRITE_INPUT_TO_CMFGEN_VADAT_FORMAT,j,u160[j],u260[j],xte60[j],xtt60[j],xl60[j],rstar60[j],logg60[j],xmdot60[j],vinf60[j],beta,$
                                           u560[j],u760[j],u860[j],u1060[j],u1260[j],u660[j],evol_vadat_file,modelstr,popscl=1 
      endfor
      end
    'Write.DIRNAMES': begin
      for i=0, n_elements(xnodes) -1 do begin
        distance=SQRT((xnodes[i]-xarray)^2 + (ynodes[i]-yarray)^2)
        min_distance=min(distance,j)        
        print,'model'+strtrim(string(j,FORMAT='(I6.6)'),2)+'_T'+strtrim(string(10^xte60[j],FORMAT='(I6.6)'),2)+'_L'+$
               strtrim(string(10^xl60[j],FORMAT='(I7.7)'),2)+'_logg'+strtrim(string(logg60[j],FORMAT='(F5.3)'),2)
      endfor         
     end
    'Write.XY data': begin
       filename_sufix=modelstr+'_'+timestepstr+'_'+info.xtitle+info.ytitle   
       ZE_REMOVE_SPECIAL_CHARACTERS_FROM_STRING,filename_sufix
       ZE_WRITE_COL_ASCII,'/Users/jgroh/temp/EVOL_OUTPUT_XYdata_'+filename_sufix+'.txt',xarray,yarray         
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
    ZE_FIND_OPTIMAL_RANGE_MULTIPLE,xarray,yarray,xrange,yrange,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                   x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10
    wset,info.plot3_id
    widget_control,info.xmin_base,set_value = min(xrange)
    widget_control,info.xmax_base,set_value = max(xrange) 
    widget_control,info.ymin_base,set_value = min(yrange)
    widget_control,info.ymax_base,set_value = max(yrange) 
         LOADCT,0,/silent
    !P.BACKGROUND=fsc_color('white')     
    ze_structfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor
    widget_control,info.xmin_base,get_v=x_min
    widget_control,info.xmax_base,get_v=x_max
    end
  'RANGE': begin
    widget_control,info.xmin_base,get_v=x_min
    widget_control,info.xmax_base,get_v=x_max
    ze_structfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor
    end
  'XLOG': begin
    info.xlog = 1 - info.xlog
    if info.xlog eq 1 then v='X Linear' else v='X Log'
    widget_control,info.xbutton,set_value=v
    ze_structfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor
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
    ze_structfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor    
    end  
  'YLOG': begin
    info.ylog = 1 - info.ylog
    if info.ylog eq 1 then v='Y Linear' else v='Y Log'
    widget_control,info.ybutton,set_value=v
    ze_structfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor
    end
  'DEGREE': begin
    info.degree = event.value
    wset,info.plot3_id
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
    
  'plot3': begin
    xd = event.x  ;device coordinates
    yd = event.y
    v = convert_coord(xd,yd,/dev,/to_data) ; data coordinates
    wset,info.plot3_id
    device,copy=[0,0,950,450,0,0,info.pixid2]
    if (info.state eq 'X/Y') then begin
        plots,[xd,xd],[0,450],color=1,/dev
        plots,[0,950],[yd,yd],color=1,/dev
        widget_control,info.message,set_value= $
      'X = '+strtrim(v(0),2)+'    Y = '+strtrim(v(1),2)
        if event.press eq 2 then begin
        info.x_min = xd
        info.y_min = yd
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
        ' Age= ' + strtrim(string(u160[indexmin],format='(E9.3)'),2) + ' Mass= '+strtrim(string(u260[indexmin],format='(F7.2)'),2) 

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
    
;
; First Zoom Corner
;
    if (info.state eq 'ZOOM1') and  $
       (event.press eq 1) then begin
            plots,[xd,xd],[0,450],color=1,/dev
          plots,[0,950],[yd,yd],color=1,/dev
        info.x_min = xd
      info.y_min = yd
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
        x = [info.x_min,xd]
        y = [info.y_min,yd]
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
      ze_structfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor
      widget_control,info.xmin_base,get_v=x_min
      widget_control,info.xmax_base,get_v=x_max

      goto,replot_spline
        end else return
    end     
      
    end
  else:
  endcase
replot_spline:
;  wset,info.plot3_id
 ; device,copy=[0,0,950,450,0,0,info.pixid]
 ; IF N_elements(xnodes) gt 0 THEN oplot,xnodes,ynodes,color=fsc_color('red'),symsize=1,psym=2,thick=2

  ;wset,info.pixid2
 ; device,copy=[0,0,950,450,0,0,info.plot3_id]
 ; wset,info.plot3_id
  return
  end


;;============================================================ ze_vfile_line_plot_UNZOOM
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
;============================================================ ze_vfile_line_plot_UNZOOM
PRO ze_structfile_line_plot_unzoom,info,x,y,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor,ymin=ymin,ymax=ymax,xmin=xmin,xmax=xmax
     
    xreverse=info.xreverse
    yreverse=info.yreverse
     LOADCT,0,/silent
    !P.BACKGROUND=fsc_color('white')
    ZE_FIND_OPTIMAL_RANGE_MULTIPLE,x,y,xrange,yrange,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                   x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10
    wset,info.plot3_id
    IF KEYWORD_SET(xmin) THEN widget_control,info.xmin_base,set_value = xmin ELSE widget_control,info.xmin_base,set_value = min(xrange)
    IF KEYWORD_SET(xmax) THEN widget_control,info.xmax_base,set_value = xmax ELSE widget_control,info.xmax_base,set_value = max(xrange) 
    IF KEYWORD_SET(ymin) THEN widget_control,info.ymin_base,set_value = ymin ELSE widget_control,info.ymin_base,set_value = min(yrange)
    IF KEYWORD_SET(ymax) THEN widget_control,info.ymax_base,set_value = ymax ELSE widget_control,info.ymax_base,set_value = max(yrange) 

 ;  ENDELSE 
    LOADCT,0,/silent
    !P.BACKGROUND=fsc_color('white')
    ze_structfile_line_plot,info,x,y,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor
    widget_control,info.xmin_base,get_v=x_max
    widget_control,info.xmax_base,get_v=x_max
    end
    
;============================================================ LINE_NORM_PLOT
;
; Routine to generate the normalized plot ; we don't need that in ze_lamp_line_id, but eventullay will want to adapt it 
;
pro ze_structfile_line_plot,info,x,y,ps=ps,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor,xrange=xrange,yrange=yrange 
 LOADCT,0,/silent
 !P.BACKGROUND=fsc_color('white')
  if not keyword_set(ps) then begin
    wset,info.plot3_id
    set_viewport,0.1,0.9,0.1,0.9
  end
  widget_control,info.xmin_base,get_value=xmin
  widget_control,info.xmax_base,get_value=xmax
  widget_control,info.ymin_base,get_value=ymin
  widget_control,info.ymax_base,get_value=ymax
  
  IF n_elements(ct) lt 1 THEN ct=0

IF KEYWORD_SET(REBIN) THEN BEGIN
    ZE_EVOL_REBIN_XYZ,x,y,xr,yr,z=z1,rebin_z=rebin_z,factor=factor
    IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x2,y2,x2r,y2r,z=z2,rebin_z=rebin_z2,factor=factor
    IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x3,y3,x3r,y3r,z=z3,rebin_z=rebin_z3,factor=factor
    IF ((N_elements(x4) gt 1) AND (N_elements(y4) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x4,y4,x4r,y4r,z=z4,rebin_z=rebin_z4,factor=factor
    IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x5,y5,x5r,y5r,z=z5,rebin_z=rebin_z5,factor=factor
    IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x6,y6,x6r,y6r,z=z6,rebin_z=rebin_z6,factor=factor
    IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x7,y7,x7r,y7r,z=z7,rebin_z=rebin_z7,factor=factor
    IF ((N_elements(x8) gt 1) AND (N_elements(y8) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x8,y8,x8r,y8r,z=z8,rebin_z=rebin_z8,factor=factor
    IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x9,y9,x9r,y9r,z=z9,rebin_z=rebin_z9,factor=factor
    IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN ZE_EVOL_REBIN_XYZ,x10,y10,x10r,y10r,z=z_10,rebin_z=rebin_z10,factor=factor
ENDIF ELSE BEGIN 
    xr=x
    yr=y
    IF N_elements(z1) GT 1 THEN rebin_z=z1
ENDELSE

  widget_control,info.xmin_base,get_value=xmin
  widget_control,info.xmax_base,get_value=xmax
  widget_control,info.ymin_base,get_value=ymin
  widget_control,info.ymax_base,get_value=ymax 

  if n_elements(xrange) LT 2 THEN xrange=[xmin,xmax]
  if n_elements(yrange) LT 2 THEN yrange=[ymin,ymax]
  
   
;ZE_FIND_OPTIMAL_RANGE_MULTIPLE,x,y,xrange,yrange,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
;                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10
;
;wset,info.plot3_id
  
  xreverse=info.xreverse
  yreverse=info.yreverse
   IF xreverse EQ 1 THEN xrange=REVERSE(xrange)
   IF yreverse EQ 1 THEN yrange=REVERSE(yrange)
   
!P.THICK=1.9
!X.THICK=1.7
!Y.THICK=1.7
;!X.CHARSIZE=1.1
;!Y.CHARSIZE=1.1
;!P.CHARSIZE=1.1
;!P.CHARTHICK=1.1
;ticklen = 25.
;!x.ticklen = ticklen/bb
;!y.ticklen = ticklen/aa
LOADCT,0,/SILENT
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

loadct,ct,/silent
   
 !p.background=fsc_color('white')  
  cgplot,[xmin,xmax],[ymin,ymax],/nodata,ytitle=info.ytitle, $
    xtitle=info.xtitle,title=info.title,xstyle=1,ystyle=1, $
    xlog=info.xlog,ylog=info.ylog,color=1,xrange=xrange, $
    yrange=yrange,background='white'
  if info.ylog ne 1 then oplot,!x.crange,[0,0],line=2,color=fsc_color('black')
  good = where((x ge xmin) and (x le xmax),ngood)
  symsize=1.6
  if ngood gt 100 then symsize=0.8
  if ngood gt 200 then symsize=0.5
  if ngood gt 300 then symsize=0.2
  if ngood gt 500 then symsize=0.01

if N_elements(z1) lt 1  THEN BEGIN ;no Z values to do color-coding
   if keyword_set(rebin) THEN BEGIN;datah as been rebinned
       cgplot,xr,yr,xstyle=1,ystyle=1,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
       /nodata,POSITION=[0.12,0.12,0.97,0.97],_STRICT_EXTRA=extra,background='white'
       cgplots,xr,yr,color='black',noclip=0,psym=psym1,symsize=symsize1,symcolor=symcolor1
       IF ((N_elements(x2r) GT 1) AND (N_elements(y2r) GT 1)) THEN cgplots,x2r,y2r,color='green',noclip=0,psym=psym2,symsize=symsize2,symcolor=symcolor2
       IF ((N_elements(x3r) GT 1) AND (N_elements(y3r) GT 1)) THEN cgplots,x3r,y3r,color='red',noclip=0,psym=psym3,symsize=symsize3,symcolor=symcolor3
       IF ((N_elements(x4r) GT 1) AND (N_elements(y4r) GT 1)) THEN cgplots,x4r,y4r,color='magenta',noclip=0
       IF ((N_elements(x5r) GT 1) AND (N_elements(y5r) GT 1)) THEN cgplots,x5r,y5r,color='blue',noclip=0
       IF ((N_elements(x6r) GT 1) AND (N_elements(y6r) GT 1)) THEN cgplots,x6r,y6r,color='cyan',noclip=0
       IF ((N_elements(x7r) GT 1) AND (N_elements(y7r) GT 1)) THEN cgplots,x7r,y7r,color='orange',noclip=0
       IF ((N_elements(x8r) GT 1) AND (N_elements(y8r) GT 1)) THEN cgplots,x8r,y8r,color='purple',noclip=0    
       IF ((N_elements(x9r) GT 1) AND (N_elements(y9r) GT 1)) THEN cgplots,x9r,y9r,color='dark green',noclip=0
       IF ((N_elements(x10r) GT 1) AND (N_elements(y10r) GT 1)) THEN cgplots,x10r,y10r,color='brown',noclip=0 
   ENDIF ELSE BEGIN; data has not been rebinned
       cgplot,x,y,xstyle=1,ystyle=1,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
       /nodata,POSITION=[0.12,0.12,0.97,0.97],_STRICT_EXTRA=extra,background='white'
       cgplots,x,y,color='black',noclip=0,psym=psym1,symsize=symsize1,symcolor=symcolor1
       IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN cgplots,x2,y2,color='green',noclip=0,psym=psym2,symsize=symsize2,symcolor=symcolor2
       IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN cgplots,x3,y3,color='red',noclip=0,psym=psym3,symsize=symsize3,symcolor=symcolor3
       IF ((N_elements(x4) GT 1) AND (N_elements(y4) GT 1)) THEN cgplots,x4,y4,color='magenta',noclip=0
       IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN cgplots,x5,y5,color='blue',noclip=0
       IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN cgplots,x6,y6,color='cyan',noclip=0
       IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN cgplots,x7,y7,color='orange',noclip=0
       IF ((N_elements(x8) GT 1) AND (N_elements(y8) GT 1)) THEN cgplots,x8,y8,color='purple',noclip=0    
       IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN cgplots,x9,y9,color='dark green',noclip=0
       IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN cgplots,x10,y10,color='brown',noclip=0 
   ENDELSE           
ENDIF ELSE BEGIN ;always plot rebinned data
  if n_elements(minz) lt 1 THEN minz=min(rebin_z)
  if n_elements(maxz) lt 1 THEN maxz=max(rebin_z)
  cgplot,x,y,xstyle=1,ystyle=1,XRANGE=xrange,YRANGE=yrange, xtitle=xtitle,ytitle=ytitle,$
/nodata,POSITION=[0.12,0.1,0.87,0.95],_STRICT_EXTRA=extra,background='white'
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
If n_elements(labelz) GT 0 THEN  xyouts,0.89,0.96,labelz,/NORMAL,color=fsc_color('black')
ENDELSE
IF ((N_elements(x2points) GT 1) AND (N_elements(y2points) GT 1)) THEN cgplots,x2points,y2points,color='green',psym=4,symsize=3. 
IF N_elements(label) GT 0 THEN xyouts,0.17,0.15,label,/NORMAL,color=fsc_color('black')
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

;  cgplots,x,y,color='black',noclip=0,psym=psym1,symsize=symsize1,symcolor=symcolor1
;       IF ((N_elements(x2) GT 1) AND (N_elements(y2) GT 1)) THEN cgplots,x2,y2,color='red',noclip=0,psym=psym2,symsize=symsize2,symcolor=symcolor2
;       IF ((N_elements(x3) GT 1) AND (N_elements(y3) GT 1)) THEN cgplots,x3,y3,color='blue',noclip=0,psym=psym3,symsize=symsize3,symcolor=symcolor3
;       IF ((N_elements(x4) GT 1) AND (N_elements(y4) GT 1)) THEN cgplots,x4,y4,color='dark green',noclip=0
;       IF ((N_elements(x5) GT 1) AND (N_elements(y5) GT 1)) THEN cgplots,x5,y5,color='orange',noclip=0
;       IF ((N_elements(x6) GT 1) AND (N_elements(y6) GT 1)) THEN cgplots,x6,y6,color='cyan',noclip=0
;       IF ((N_elements(x7) GT 1) AND (N_elements(y7) GT 1)) THEN cgplots,x7,y7,color='purple',noclip=0
;       IF ((N_elements(x8) GT 1) AND (N_elements(y8) GT 1)) THEN cgplots,x8,y8,color='purple',noclip=0    
;       IF ((N_elements(x9) GT 1) AND (N_elements(y9) GT 1)) THEN cgplots,x9,y9,color='purple',noclip=0
;       IF ((N_elements(x10) GT 1) AND (N_elements(y10) GT 1)) THEN cgplots,x10,y10,color='purple',noclip=0 
;  
  if not keyword_set(ps) then begin
    wset,info.pixid
    device,copy=[0,0,950,450,0,0,info.plot3_id]
    wset,info.pixid2
    device,copy=[0,0,950,450,0,0,info.plot3_id]
    wset,info.plot3_id
  end
  info.state = 'X/Y'
return
end


;==================================================================== LINE_EDIT
;
; Plot widget main routine  
  
pro ze_evol_analyze_struct_file_interac_v1,model_name, timestep, $
  title=title,xtitle=xtitle,ytitle=ytitle, $
  group=group,xrange=xrange,yrange=yrange, $
  min_val=min_val,max_val=max_val, modal=modal,modeldir=modeldir
;
; CALLING SEQUENCE:
; 
  if n_params(0) lt 1 then begin
    print,'CALLING SEQUENCE: ze_evol_analyze_struct_file_interac_v1,model_name, timestep
    print,'KEYWORD INPUTS: title,xtitle,ytitle,xrange,yrange
    return
  end
  
  
  common ze_evol_analyze_struct_file_interac_common,info,modelstr,timestepstr,xarray,yarray,xnodes,ynodes,nodes_timestep,rsave,gsave,bsave, $
            n,logr,Mint,logT,logrho,logP,Cv,dlnP_over_dlnrho_T , $
            dlnP_over_dlnT_rho,nabla_e,nabla_ad,Lrad,Ltot,logkappa,dlnk_over_dlnrho_T ,$
            dlnk_over_dlnT_rho,epsilon ,  dlnE_over_dlnrho_T ,  dlnE_over_dlnT_rho,X_H1,X_He4,mu,mu0,Omega,$
            logprad,logpgas,prad_over_ptot,pgas_over_ptot,logpturb,ledd,gammafull_rad,gammafull_tot,nablarad,ebind,logteff
  

  if n_elements(title) eq 0 then title=''
  if n_elements(xtitle) eq 0 then xtitle=''
  if n_elements(ytitle) eq 0 then ytitle=''
  if n_elements(min_val) eq 0 then min_val=-1e37
  if n_elements(max_val) eq 0 then max_val = 1e37
 
  if n_Elements(modeldir) eq 0 then modeldir='/Users/jgroh/evol_models/Z014/'+model_name

modelstr=string(model_name,format='(A9)')
timestepstr=string(timestep)

struct_file=modeldir+'/'+modelstr+'_StrucData_'+strcompress(string(timestep, format='(I07)'))+'.dat'
print,struct_file
ZE_EVOL_READ_STRUCT_FILE_FROM_GENEVA_ORIGIN2010,modeldir,modelstr,timestep,data_struct_file,header_struct_file,modnb,age,mtot,nbshell,deltat,ncolumns,logteff,/compress
print,logteff
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'n',data_struct_file,n,index_varnamex_struct_file,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logr',data_struct_file,logr,index_varnamex_struct_file,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'Mint',data_struct_file,Mint,index_varnamex_struct_file,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logT',data_struct_file,logT,index_varnamex_struct_file,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logrho',data_struct_file,logrho,index_varnamex_struct_file,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logP',data_struct_file,logp,index_varnamex_struct_file,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'Cv',data_struct_file,cv,index_varnamex_struct_file,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'dlnP_over_dlnrho_T',data_struct_file,dlnP_over_dlnrho_T,index_varnamex_struct_file1,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'nabla_e',data_struct_file,nabla_e,index_varnamex_struct_file1,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'nabla_ad',data_struct_file,nabla_ad,index_varnamex_struct_file1,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'Lrad',data_struct_file,Lrad,index_varnamex_struct_file,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'Ltot',data_struct_file,Ltot,index_varnamex_struct_file,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'logkappa',data_struct_file,logkappa,index_varnamex_struct_file,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'X_H1',data_struct_file,X_H1,index_varnamex_struct_file,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'X_He4',data_struct_file,X_He4,index_varnamex_struct_file,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'mu',data_struct_file,mu,index_varnamex_struct_file,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_STRUCT_FILE,'epsilon',data_struct_file,epsilon,index_varnamex_struct_file,return_valx

ZE_EVOL_COMPUTE_QUANTITIES_FROM_STRUCTFILE,data_struct_file,logprad,logpgas,prad_over_ptot,pgas_over_ptot,logpturb,ledd,gammafull_rad,gammafull_tot,nablarad,ebind=ebind

xarray=(10^logr) /(6.955e10)
yarray=logrho

ns = n_elements(xarray)
 
  tvlct,red,green,blue,/get
  rsave = red
  gsave = green
  bsave = blue
  red(0) = [255,0,255, 0]
  green(0) = [255,0,  0, 255]
  blue(0) = [255,0,  0, 0]
  tvlct,red,green,blue
  set_xy
  set_viewport 

;;  widget_control,default_font  = $
;;     '-adobe-helvetica-bold-r-normal--14-140-75-75-p-82-iso8859-1'
  mainze_structfile_line_plot_unzoom = widget_base(/col,group=group,/tracking,uvalue='MAIN', $
      title='Complete structure from '+modelstr+'_StrucData_'+strcompress(string(timestep, format='(I07)'))+'.dat',modal=modal)
      main =mainze_structfile_line_plot_unzoom
  menu = widget_base(main,/row,/frame)
  exit = widget_button(menu,value='EXIT',uvalue='EXIT')
  desc = ['1\Write','0\Postscript File','0\XY data','0\VADAT','2\DIRNAMES']
  button = cw_pdmenu(menu,desc,uvalue='WRITE',/return_full_name)
  zoom = widget_button(menu,uvalue='ZOOM',value='Zoom')
  unzoom = widget_button(menu,uvalue='UNZOOM',value='UnZoom')
  xbutton = widget_button(menu,uvalue='XLOG',value='X Log     ')
  ybutton = widget_button(menu,uvalue='YLOG',value='Y Log     ')
  button = widget_button(menu,value='ADD Node',uvalue='ADD_NODE')
  button = widget_button(menu,value='DELETE Node',uvalue='DELETE_NODE')
  button = widget_button(menu,value='DELETE ALL Nodes',uvalue='DELETE_NODE')  
  button = widget_button(menu,value='SAVE NODES',uvalue='SAVE_NODES')
  button = widget_button(menu,value='LOAD NODES',uvalue='LOAD_NODES')  
  button = widget_button(menu,value='SAVE NODES DEFAULT',uvalue='SAVE_NODES_DEFAULT')
  button = widget_button(menu,value='LOAD NODES DEFAULT',uvalue='LOAD_NODES_DEFAULT')  
  button = widget_button(menu,value='LOAD NODES FROM TIMESTEP',uvalue='LOAD_NODES_TIMESTEP')  
  
  lab = widget_label(main,value='X Axis')
  xvar = widget_base(main,/row,/exclusive,/toolbar)
  buttonxj = widget_button(xvar,value='  n  ',uvalue='xn')
 buttonxlogr = widget_button(xvar,value='logR',uvalue='xlogr') 
  buttonxr = widget_button(xvar,value='R',uvalue='xr') 
  buttonxmass = widget_button(xvar,value='Mint',uvalue='xMint') 
  buttonxmasstot = widget_button(xvar,value='Mintnorm',uvalue='xMintnorm') 
  buttonxextmass = widget_button(xvar,value='Mext',uvalue='xMext')   
  buttonxlogt = widget_button(xvar,value='logT',uvalue='xlogt')
  button2 = widget_button(xvar,value='logRho',uvalue='xlogrho')
  button2 = widget_button(xvar,value='logP',uvalue='xlogp')
  button2 = widget_button(xvar,value='Lrad',uvalue='xlrad')
  button2 = widget_button(xvar,value='Ltot',uvalue='xltot')
  button = widget_button(xvar,value='log kappa',uvalue='xlogkappa')
  button = widget_button(xvar,value='tau',uvalue='xtau')

  lab = widget_label(main,value='Y Axis')
  yvar = widget_base(main,/row,/exclusive,/toolbar)
  buttonyj = widget_button(yvar,value='  n  ',uvalue='yn')
  buttonyr = widget_button(yvar,value='R',uvalue='yr')
  buttonylogr = widget_button(yvar,value='logR',uvalue='ylogr') 
  buttonymasstot = widget_button(yvar,value='Mintnorm',uvalue='yMintnorm') 
  buttonymass = widget_button(yvar,value='Mint',uvalue='yMint')
  buttonyextmass = widget_button(yvar,value='Mext',uvalue='yMext') 
  buttonylogt = widget_button(yvar,value='logT',uvalue='ylogt')
  buttonylogrho = widget_button(yvar,value='logRho',uvalue='ylogrho')
  button2 = widget_button(yvar,value='logP',uvalue='ylogp')
  button2 = widget_button(yvar,value='logPrad',uvalue='ylogprad')
  button2 = widget_button(yvar,value='logPgas',uvalue='ylogpgas')      
  button2 = widget_button(yvar,value='Prad/Ptot',uvalue='yprad_over_ptot')
  button2 = widget_button(yvar,value='Pgas/Ptot',uvalue='ypgas_over_ptot')  
  button2 = widget_button(yvar,value='Lrad',uvalue='ylrad')
  button2 = widget_button(yvar,value='Ltot',uvalue='yltot')  
  button2 = widget_button(yvar,value='Ledd',uvalue='yledd')  
  button2 = widget_button(yvar,value='Lrad/Ltot',uvalue='ylrad_over_ltot')   
  button2 = widget_button(yvar,value='Gammafull',uvalue='ygammafull')  
  button = widget_button(yvar,value='log kappa',uvalue='ylogkappa') 
  button = widget_button(yvar,value='nabla_e',uvalue='ynablae')
  button = widget_button(yvar,value='nabla_ad',uvalue='ynablaad')
  button = widget_button(yvar,value='nabla_rad',uvalue='ynablarad')
  button = widget_button(yvar,value='h1',uvalue='yh1') 
  button = widget_button(yvar,value='he4',uvalue='yhe4')
  button = widget_button(yvar,value='ebind',uvalue='yebind')
  button = widget_button(yvar,value='tau',uvalue='ytau')       
  message = widget_text(main,xsize=80,value=' ')
;
; draw window
;
 LOADCT,0,/silent
 !P.BACKGROUND=fsc_color('white')
  plot3 = widget_draw(main,uvalue='plot3',retain=2, $
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
  widget_control,plot3,get_value=plot3_id

  info = {message:message,ns:ns,pixid:pixid,pixid2:pixid2,xtitle:xtitle, $
    ytitle:ytitle,title:title,plot3:plot3, $
    main:main,xmin:min(xarray),ymin:min(yarray), $
    xmax:max(xarray),ymax:max(yarray),xlog:0,ylog:0,xmin_base:xmin_base, $
    ymin_base:ymin_base,xmax_base:xmax_base,ymax_base:ymax_base, $
    state:'X/Y',xbutton:xbutton,ybutton:ybutton, $
    x_min:0, y_min:0, node:0, plot3_id:plot3_id,  $
    min_val:min_val,max_val:max_val,xreverse:0,yreverse:0}
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
       x_min = min(xarray)
       x_max = max(xarray)

;
; create initial plot, HR diagram T* x L*
;
  info.xtitle=TEXTOIDL('R (Rsun)')
  info.ytitle=TEXTOIDL('log rho')
  widget_control,info.xmin_base,get_v=x_min
  widget_control,info.xmax_base,get_v=x_max
  widget_control,buttonxr,set_button=1
  widget_control,buttonylogrho,set_button=1  
  ze_structfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10
  
  xmanager,'ze_evol_analyze_struct_file_interac_v1',main

  
    
  info=0
  xarray = 0
  yarray = 0
  undefine,x2,y2,x3,y3,x4,y4,x5,y5
  undefine,x6,y6,x7,y7,x8,y8,x9,y9,x10,y10
  return
  end