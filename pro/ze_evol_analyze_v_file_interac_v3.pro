;v3 return fit parameters and lambda values for all pixels 
;right now can only DELETE lines
;+
;       ze_lamp_fit_wavecal_interac_v3
;       based on line_norm, trying to fit lamp lines interatively
;
; Widget to interactively normalize a spectrum
;
; CALLING SEQUENCE:
;
; ze_lamp_fit_wavecal_interac_v3,index,flux,xnodes,ynodes,xcen,ycen
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
pro ze_evol_analyze_v_file_interac_v3_event,event
  common ze_evol_analyze_v_file_interac_common,info,modelstr,timestepstr,xarray,yarray,xnodes,ynodes,nodes_timestep,rsave,gsave,bsave, j,xmr,p,t,r,lr,Xstruct,Ystruct,C12struct,O16struct,eps,epsy,epsc,$
Nabrad,rho,zensi,epsnu,dkdP,dkdT,dEdP,dEdT,drhodP,delta,psi,eps3a,$
epsCO,epsONe,egrav,Nabad,kappa,beta,Y_3,C13struct,N14struct,$
N15struct,O17struct,O18struct,Ne20struct,Ne22struct,Mg24struct,Mg25struct,Mg26struct,$
mu,omega,Nablamu,Ri,Dconv,Dshear,Deff,Mr,$
dlnOmega_dr,K_ther,U,V,D_circ,HP,g,Dh,Omegp,$
vr,vomegi,Dmago,Dmagx,eta,N2,B_phi,Alfven,$
q_min,mu_e,F19struct,Ne21struct,Na23struct,Al26struct,Al27struct,Si28alustruct,$
C14struct,F18struct,nalu,palu,xbid,Si28struct,S32struct,Ar36struct,Ca40struct,$
Ti44struct,Cr48struct,Fe52struct,Ni56struct,Btotq,xomegafit,xmufit,vmu,xobla,$
x2,y2,x3,y3,x4,y4,x5,y5,$
x6,y6,x7,y7,x8,y8,x9,y9,x10,y10,z1,z2,z3,z4,z5,z6,z7,z8,z9,z_10,rebin,factor,mtot

  widget_control,event.id,get_uvalue=uvalue
  
 ; widget_control,event.top,get_uvalue=info
 ; if event.top eq event.id then return
  ;widget_control,event.id,get_uvalue=uvalue
  ;compute = 0 ;recompute equivalent widget
 ; wset,(*info).plot_id;
  
  case uvalue of
  
;X VARIABLES  
  'xj': begin 
      xarray=j
      IF N_elements(xnodes) gt 0 THEN IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Layer number j')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end  
  'xMass coord': begin 
      xarray=xmr
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle='Mass coordinate (Mr/Mtot)'
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end         
  'xTotMass coord': begin 
      xarray=xmr*mtot
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle='Total Mass coordinate (Msun)'
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end   
  'xr': begin 
     xarray=(10^r) /(6.955e10)
     IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
     info.xtitle='R (Rsun)'
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end                
  'xEps H': begin 
      xarray=eps
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Eps H')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end 
      'xEps He': begin 
      xarray=epsy
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Eps He')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end 
      'xEps C': begin 
      xarray=epsc
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Eps C')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end 
  'xenergy': begin 
      xarray=eps
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Eps')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end                            
  'xstructx': begin 
      xarray=xstruct
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('X')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end   
  'xstructy': begin 
      xarray=ystruct
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Y')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end   
  'xstructc12': begin 
      xarray=c12struct
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('C12')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end   
  'xstructo16': begin 
      xarray=o16struct
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('O16')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end   

  'xp': begin 
      xarray=p
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('log P')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end

  'xlr': begin 
      xarray=lr
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('L/Ltot')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end    

  'xt': begin 
      xarray=t
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Log T')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end

  'xrho': begin 
      xarray=rho
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('log rho')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end

  'xkappa': begin 
      xarray=kappa
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('kappa')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end

  'xzensi': begin 
      xarray=zensi
      IF N_elements(xnodes) gt 0 THEN xnodes=xarray[nodes_timestep]
      info.xreverse = 0
      info.xtitle=TEXTOIDL('Convection factor (<0 rad, >0 conv)')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end


;Y VARIABLES
  'yj': begin 
     yarray=j
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('Layer number j')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end  
  'yMass coord': begin 
     yarray=xmr
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle='Mass coordinate'
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end
  'yr': begin 
     yarray=(10^r)/(6.96e10)
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle='R (Rsun)'
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end      
  'yEps H': begin 
     yarray=eps
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('Eps H')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end 
    
   'yEps He': begin 
      yarray=epsy
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('Eps He')
      ze_vfile_line_plot_unzoom,info,xarray,yarray,z1=z1
    end 
      'yEps C': begin 
      yarray=epsc
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('Eps C')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end 
  'yenergy': begin 
     undefine,z1,x2,y3,x3,y3,x4,y4,x5,y5
     undefine,x10,y10
     yarray=alog10(eps)
     IF max(epsy) GT 100 THEN BEGIN
        y2=alog10(epsy)
        x2=xarray
     ENDIF  
     IF max(epsc) GT 100 THEN BEGIN
        x3=xarray
        y3=alog10(epsc)
     ENDIF
     IF max(epsone) GT 100 THEN BEGIN
        x4=xarray
        y4=alog10(epsone)
     ENDIF
     x10=xarray
     y10=lr*max(alog10([eps,epsy,epsc,epsone]))   
     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('Eps H, He, C, O')
     ze_vfile_line_plot_unzoom,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor
    end                
  'yabund': begin 
     undefine,z1,x2,y3,x3,y3,x4,y4,x5,y5
     undefine,x10,y10
     yarray=alog10(xstruct)
     x2=xarray
     y2=alog10(yStruct)
     x3=xarray
     y3=alog10(c12struct)
     x4=xarray
     y4=alog10(n14struct)
     x5=xarray
     y5=alog10(o16struct)


     IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
     info.ytitle=TEXTOIDL('Mass Fraction')
     
     ze_vfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor,yrange=[-5,0]  
 
    end   
  'ystructx': begin 
      yarray=xstruct
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('X')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end   
  'ystructy': begin 
      yarray=ystruct
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('Y')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end   
  'ystructc12': begin 
      yarray=c12struct
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('C12')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end   
  'ystructo16': begin 
      yarray=o16struct
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('O16')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end   


  'yp': begin 
      yarray=p
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('log P')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end

  'ylr': begin 
      yarray=lr
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('L/Ltot')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end    

  'yt': begin 
      yarray=t
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('Log T')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end

  'yrho': begin 
      yarray=rho
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('log rho')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end

  'ykappa': begin 
      yarray=kappa
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('kappa')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end

  'yzensi': begin 
      yarray=zensi
      index_outliers_min=where(yarray LT -100, count)
      if count GT 0 THEN yarray[index_outliers_min]=-100
      undefine,x2,y2,x3,y3,x4,y4,x5,y5
      undefine,x6,y6,x7,y7,x8,y8,x9,y9,x10,y10
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('Convection factor (<0 rad, >0 conv)')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
    end

  'yomega': begin 
      yarray=omega
      index_outliers_min=where(yarray LT -100, count)
      if count GT 0 THEN yarray[index_outliers_min]=-100
      undefine,x2,y2,x3,y3,x4,y4,x5,y5
      undefine,x6,y6,x7,y7,x8,y8,x9,y9,x10,y10
      IF N_elements(ynodes) gt 0 THEN ynodes=yarray[nodes_timestep]
      info.yreverse = 0
      info.ytitle=TEXTOIDL('Omega')
      ze_vfile_line_plot_unzoom,info,xarray,yarray
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
      set_plot,'x'
      ze_vfile_line_plot,info,xarray,yarray
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
    wset,info.plot2_id
    widget_control,info.xmin_base,set_value = min(xrange)
    widget_control,info.xmax_base,set_value = max(xrange) 
    widget_control,info.ymin_base,set_value = min(yrange)
    widget_control,info.ymax_base,set_value = max(yrange) 
         LOADCT,0,/silent
    !P.BACKGROUND=fsc_color('white')     
    ze_vfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor
    widget_control,info.xmin_base,get_v=x_min
    widget_control,info.xmax_base,get_v=x_max
    end
  'RANGE': begin
    widget_control,info.xmin_base,get_v=x_min
    widget_control,info.xmax_base,get_v=x_max
    ze_vfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor
    end
  'XLOG': begin
    info.xlog = 1 - info.xlog
    if info.xlog eq 1 then v='X Linear' else v='X Log'
    widget_control,info.xbutton,set_value=v
    ze_vfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
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
    ze_vfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor    
    end  
  'YLOG': begin
    info.ylog = 1 - info.ylog
    if info.ylog eq 1 then v='Y Linear' else v='Y Log'
    widget_control,info.ybutton,set_value=v
    ze_vfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor
    end
  'DEGREE': begin
    info.degree = event.value
    wset,info.plot2_id
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
    
  'plot2': begin
    xd = event.x  ;device coordinates
    yd = event.y
    v = convert_coord(xd,yd,/dev,/to_data) ; data coordinates
    wset,info.plot2_id
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
      ze_vfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
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
;  wset,info.plot2_id
 ; device,copy=[0,0,950,450,0,0,info.pixid]
 ; IF N_elements(xnodes) gt 0 THEN oplot,xnodes,ynodes,color=fsc_color('red'),symsize=1,psym=2,thick=2

  ;wset,info.pixid2
 ; device,copy=[0,0,950,450,0,0,info.plot2_id]
 ; wset,info.plot2_id
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
PRO ze_vfile_line_plot_unzoom,info,x,y,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor
     
    xreverse=info.xreverse
    yreverse=info.yreverse
     LOADCT,0,/silent
    !P.BACKGROUND=fsc_color('white')
    ZE_FIND_OPTIMAL_RANGE_MULTIPLE,x,y,xrange,yrange,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                   x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10
    wset,info.plot2_id
    widget_control,info.xmin_base,set_value = min(xrange)
    widget_control,info.xmax_base,set_value = max(xrange) 
    widget_control,info.ymin_base,set_value = min(yrange)
    widget_control,info.ymax_base,set_value = max(yrange) 

 ;  ENDELSE 
    LOADCT,0,/silent
    !P.BACKGROUND=fsc_color('white')
    ze_vfile_line_plot,info,x,y,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
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
pro ze_vfile_line_plot,info,x,y,ps=ps,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10,$
                                z1=z1,z2=z2, z3=z3, z4=z4, z5=z5, z6=z6, z7=z7, z8=z8, z9=z9,z_10=z_10,$
                                rebin=rebin,factor=factor,xrange=xrange,yrange=yrange 
 LOADCT,0,/silent
 !P.BACKGROUND=fsc_color('white')
  if not keyword_set(ps) then begin
    wset,info.plot2_id
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
;wset,info.plot2_id
  
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
    device,copy=[0,0,950,450,0,0,info.plot2_id]
    wset,info.pixid2
    device,copy=[0,0,950,450,0,0,info.plot2_id]
    wset,info.plot2_id
  end
  info.state = 'X/Y'
return
end


;==================================================================== LINE_EDIT
;
; Plot widget main routine  
  
pro ze_evol_analyze_v_file_interac_v3,model_name, timestep, $
  title=title,xtitle=xtitle,ytitle=ytitle, $
  group=group,xrange=xrange,yrange=yrange, $
  min_val=min_val,max_val=max_val, modal=modal,modeldir=modeldir
;
; CALLING SEQUENCE:
; 
  if n_params(0) lt 1 then begin
    print,'CALLING SEQUENCE: line_norm,x,y,ynorm,norm
    print,'KEYWORD INPUTS: title,xtitle,ytitle,xrange,yrange
    return
  end
  
  
  common ze_evol_analyze_v_file_interac_common,info,modelstr,timestepstr,xarray,yarray,xnodes,ynodes,nodes_timestep,rsave,gsave,bsave, j,xmr,p,t,r,lr,Xstruct,Ystruct,C12struct,O16struct,eps,epsy,epsc,$
Nabrad,rho,zensi,epsnu,dkdP,dkdT,dEdP,dEdT,drhodP,delta,psi,eps3a,$
epsCO,epsONe,egrav,Nabad,kappa,beta,Y_3,C13struct,N14struct,$
N15struct,O17struct,O18struct,Ne20struct,Ne22struct,Mg24struct,Mg25struct,Mg26struct,$
mu,omega,Nablamu,Ri,Dconv,Dshear,Deff,Mr,$
dlnOmega_dr,K_ther,U,V,D_circ,HP,g,Dh,Omegp,$
vr,vomegi,Dmago,Dmagx,eta,N2,B_phi,Alfven,$
q_min,mu_e,F19struct,Ne21struct,Na23struct,Al26struct,Al27struct,Si28alustruct,$
C14struct,F18struct,nalu,palu,xbid,Si28struct,S32struct,Ar36struct,Ca40struct,$
Ti44struct,Cr48struct,Fe52struct,Ni56struct,Btotq,xomegafit,xmufit,vmu,xobla,$
x2,y2,x3,y3,x4,y4,x5,y5,$
x6,y6,x7,y7,x8,y8,x9,y9,x10,y10,z1,z2,z3,z4,z5,z6,z7,z8,z9,z_10,rebin,factor,mtot
  

  if n_elements(title) eq 0 then title=''
  if n_elements(xtitle) eq 0 then xtitle=''
  if n_elements(ytitle) eq 0 then ytitle=''
  if n_elements(min_val) eq 0 then min_val=-1e37
  if n_elements(max_val) eq 0 then max_val = 1e37
  
  if n_Elements(modeldir) eq 0 then modeldir='/Users/jgroh/evol_models/Z014/'+model_name

modelstr=model_name
timestepstr=string(timestep)

vfile=modeldir+'/'+model_name+'.v'+strcompress(string(timestep, format='(I07)')) 
print,vfile
ZE_EVOL_READ_V_FILE_FROM_GENEVA_ORIGIN2010,modeldir,model_name,timestep,data_vfile,header_vfile,modnb,age,mtot,nbshell,deltat,/compress

ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'j',data_vfile,j,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'xmr',data_vfile,xmr,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'eps',data_vfile,eps,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'epsy',data_vfile,epsy,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'epsc',data_vfile,epsc,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'epsCO',data_vfile,epsco,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'epsONe',data_vfile,epsone,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'r',data_vfile,r,index_varnamex_vfile1,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'p',data_vfile,p,index_varnamex_vfile1,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'t',data_vfile,t,index_varnamex_vfile1,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'lr',data_vfile,lr,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'X',data_vfile,xstruct,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'Y',data_vfile,ystruct,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'C12',data_vfile,c12struct,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'N14',data_vfile,n14struct,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'O16',data_vfile,o16struct,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'Ne20',data_vfile,ne20struct,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'Si28',data_vfile,si28struct,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'Fe52',data_vfile,fe52struct,index_varnamex_vfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'kappa',data_vfile,kappa,index_varnamex_vfile1,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'zensi',data_vfile,zensi,index_varnamex_vfile1,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'rho',data_vfile,rho,index_varnamex_vfile1,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,'omega',data_vfile,omega,index_varnamex_vfile1,return_valx

xarray=xmr
yarray=eps

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
  main = widget_base(/col,group=group,/tracking,uvalue='MAIN', $
      title='Interior structure from '+modelstr+'.v'+strcompress(string(timestep, format='(I07)')),modal=modal)
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
  button = widget_button(menu,value='DELETE ALL Nodes',uvalue='DELETE_NODE')  
  button = widget_button(menu,value='SAVE NODES',uvalue='SAVE_NODES')
  button = widget_button(menu,value='LOAD NODES',uvalue='LOAD_NODES')  
  button = widget_button(menu,value='SAVE NODES DEFAULT',uvalue='SAVE_NODES_DEFAULT')
  button = widget_button(menu,value='LOAD NODES DEFAULT',uvalue='LOAD_NODES_DEFAULT')  
  button = widget_button(menu,value='LOAD NODES FROM TIMESTEP',uvalue='LOAD_NODES_TIMESTEP')  

  lab = widget_label(main,value='X Axis')
  xvar = widget_base(main,/row,/exclusive,/toolbar)
  buttonxj = widget_button(xvar,value='  j  ',uvalue='xj')
  buttonxmass = widget_button(xvar,value='Mass coord',uvalue='xMass coord') 
  buttonxtotmass = widget_button(xvar,value='Total Mass coord',uvalue='xTotMass coord')
  button2 = widget_button(xvar,value='r',uvalue='xr')
  button2 = widget_button(xvar,value='P',uvalue='xp')
  button2 = widget_button(xvar,value='T',uvalue='xt')
  button2 = widget_button(xvar,value='lr',uvalue='xlr')  
  button = widget_button(xvar,value='Eps H',uvalue='xEps H')
  button= widget_button(xvar,value='Eps He',uvalue='xEps He') 
  button= widget_button(xvar,value='Eps C',uvalue='xEps C') 
  button = widget_button(xvar,value='Energy',uvalue='xenergy')  
  ;button = widget_button(xvar,value='Time coll.',uvalue='xtime_bef_coll')     
  button = widget_button(xvar,value='X',uvalue='xstructx') 
  button = widget_button(xvar,value='Y',uvalue='xstructy')        
  button = widget_button(xvar,value='C12',uvalue='xstructc12')  
  button = widget_button(xvar,value='O16',uvalue='xstructo16') 
  button2 = widget_button(xvar,value='rho',uvalue='xrho') 
  button2 = widget_button(xvar,value='kappa',uvalue='xkappa') 
  button2 = widget_button(xvar,value='zensi',uvalue='xzensi')   
  
  
  

  lab = widget_label(main,value='Y Axis')
  yvar = widget_base(main,/row,/exclusive,/toolbar)
  button1 = widget_button(yvar,value='  j  ',uvalue='yj')
  buttonytotmass = widget_button(yvar,value='Total Mass coord',uvalue='yTotMass coord')
  button2 = widget_button(yvar,value='r',uvalue='yr')
  button2 = widget_button(yvar,value='P',uvalue='yp')
  button2 = widget_button(yvar,value='T',uvalue='yt')
  button2 = widget_button(yvar,value='lr',uvalue='ylr')    
  buttonyeps = widget_button(yvar,value='Eps H',uvalue='yEps H')
  button3= widget_button(yvar,value='Eps He',uvalue='yEps He') 
  button4= widget_button(yvar,value='Eps C',uvalue='yEps C') 
  buttonyenergy = widget_button(yvar,value='Energy',uvalue='yenergy')  
  buttonyabund = widget_button(yvar,value='Abund',uvalue='yabund')    
  button = widget_button(yvar,value='X',uvalue='ystructx') 
  button = widget_button(yvar,value='Y',uvalue='ystructy')        
  button = widget_button(yvar,value='C12',uvalue='ystructc12')  
  button = widget_button(yvar,value='O16',uvalue='ystructo16') 
  button2 = widget_button(yvar,value='rho',uvalue='yrho') 
  button2 = widget_button(yvar,value='kappa',uvalue='ykappa') 
  button2 = widget_button(yvar,value='zensi',uvalue='yzensi')            
  button2 = widget_button(yvar,value='omega',uvalue='yomega')
  message = widget_text(main,xsize=80,value=' ')
;
; draw window
;
 LOADCT,0,/silent
 !P.BACKGROUND=fsc_color('white')
  plot2 = widget_draw(main,uvalue='plot2',retain=2, $
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
  widget_control,plot2,get_value=plot2_id

  info = {message:message,ns:ns,pixid:pixid,pixid2:pixid2,xtitle:xtitle, $
    ytitle:ytitle,title:title,plot2:plot2, $
    main:main,xmin:min(xarray),ymin:min(yarray), $
    xmax:max(xarray),ymax:max(yarray),xlog:0,ylog:0,xmin_base:xmin_base, $
    ymin_base:ymin_base,xmax_base:xmax_base,ymax_base:ymax_base, $
    state:'X/Y',xbutton:xbutton,ybutton:ybutton, $
    x_min:0, y_min:0, node:0, plot2_id:plot2_id,  $
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
  info.xtitle=TEXTOIDL('Mass coordinate')
  info.ytitle=TEXTOIDL('Eps')
  widget_control,info.xmin_base,get_v=x_min
  widget_control,info.xmax_base,get_v=x_max
  widget_control,buttonxmass,set_button=1
  widget_control,buttonyeps,set_button=1  
  ze_vfile_line_plot,info,xarray,yarray,x2=x2,y2=y2,x3=x3,y3=y3,x4=x4,y4=y4,x5=x5,y5=y5,$
                                x6=x6,y6=y6,x7=x7,y7=y7,x8=x8,y8=y8,x9=x9,y9=y9,x10=x10,y10=y10
  
  xmanager,'ze_evol_analyze_v_file_interac_v3',main

  
    
  info=0
  xarray = 0
  yarray = 0
  undefine,x2,y2,x3,y3,x4,y4,x5,y5
  undefine,x6,y6,x7,y7,x8,y8,x9,y9,x10,y10
  return
  end