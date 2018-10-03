;PRO ZE_EVOL_COMPARE_ATMOSPHERE_TEMPERATURE_STRUCTURE_ORIGIN2010_CMFGEN_P060z14S0_V2
;compares temperature structure from Origin2010 and CMFGEN models

modeldir='/Users/jgroh/ze_models/grid_P060z14S0/rvtj/'
model_name='P060z14S0'
spawn,'ls '+modeldir+'/*/RVTJ', rvtj_file_array,sh
rvtj_name_array=strarr(n_elements(rvtj_file_array))
for i=0, n_elements(rvtj_file_Array) -1 do  rvtj_name_array[i]=strmid(rvtj_file_array[i],strpos(rvtj_file_array[i],'rvtj')+6,strpos(rvtj_file_array[i],'/RVTJ')-strpos(rvtj_file_array[i],'rvtj')-6)   
timestep_cmfgen=fltarr(n_elements(rvtj_name_array))
for i=0, n_elements(timestep_cmfgen) -1 do  timestep_cmfgen[i]=float(strmid(rvtj_name_array[i],strpos(rvtj_name_array[i],'model')+5,strpos(rvtj_name_array[i],'_T')-strpos(rvtj_name_array[i],'model')-5))
rvtj_file_array=rvtj_file_array(sort(timestep_cmfgen))
rvtj_name_array=rvtj_name_array(sort(timestep_cmfgen))
  

ZE_READ_RVTJ,rvtj_file_array[2],r,v,sigma,ed,t,ross,fluxross,atom,ionden,den,clump,ND,NC,NP,NCF,mdot,lstar,output_format_date,completion_of_model,program_date,was_t_fixed,species_name_con,greyt,heating_rad_decay

readcol,'/Users/jgroh/temp/EVOL_OUTPUT_XYdata_P060z14S0_1041.0000_RRsunlogTK.txt',revol1041,logtevol1041
readcol,'/Users/jgroh/temp/EVOL_OUTPUT_XYdata_P060z14S0_1041.0000_RRsunlogrho.txt',revol1041,logrhoevol1041

readcol,'/Users/jgroh/temp/EVOL_OUTPUT_XYdata_P060z14S0_12601.000_RRsunlogTK.txt',revol12601,logtevol12601
readcol,'/Users/jgroh/temp/EVOL_OUTPUT_XYdata_P060z14S0_12601.000_RRsunlogrho.txt',revol12601,logrhoevol12601

;lineplot,REFORM(rrev*1e10),REFORM(trev*1e4) 
!P.Background = fsc_color('white')

;evoltau=indgen(100)*1D0
;evoltgrey=dblarr(100)
;for i=0, 99 do evoltgrey[i]=(43000.^4 * 0.75D0*(evoltau[i]+0.66D0))^0.25
;
ZE_READ_RVTJ,rvtj_file_array[2],r,v,sigma,ed,t,ross,fluxross,atom,ionden,den,clump,ND,NC,NP,NCF,mdot,lstar,output_format_date,completion_of_model,program_date,was_t_fixed,species_name_con,greyt,heating_rad_decay

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,REFORM(revol1041),REFORM(10^logtevol1041),'Radius (Rsun)','Temperature (K)','',$
                                x2=REFORM(r/6.96/1.01),y2=REFORM(t*1e4),color2='blue',linestyle2=2,filename='logt_logr_1041.eps',$
                                x3=REFORM(r/6.96/0.998),y3=REFORM(t*1e4),color3='red',linestyle3=0,$
                                xrange=[1,1000],yrange=[1e4,2e7],xreverse=0,_EXTRA=extra,rebin=1,factor=1.0,/xlog,/ylog,POSITION=[0.135,0.115,0.96,0.96],pcharsize=2.0
                                
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,REFORM(revol1041),REFORM(10^logrhoevol1041),'Radius (Rsun)','Density (g/cm^3)','',$
                                x2=REFORM(r/6.96/1.01),y2=REFORM(den),color2='blue',linestyle2=2,filename='logrho_logr_1041.eps',$  
                                x3=REFORM(r/6.96/0.998),y3=REFORM(den),color3='red',linestyle3=0,$                             
                                xrange=[1,1000],yrange=[1e-18,1e2],xreverse=0,_EXTRA=extra,rebin=1,factor=1.0,/xlog,/ylog,POSITION=[0.135,0.115,0.96,0.96],pcharsize=2.0
                                
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,REFORM(revol1041),REFORM(10^logtevol1041),'','','',$
                                x2=REFORM(r/6.96/1.01),y2=REFORM(t*1e4),color2='blue',linestyle2=2,$
                                x3=REFORM(r/6.96/0.998),y3=REFORM(t*1e4),color3='red',linestyle3=0,$
                                xrange=[11,12.5],yrange=[3e4,3e5],xreverse=0,_EXTRA=extra,rebin=1,factor=1.0,/ylog,$
                                POSITION=[0.12,0.11,0.93,0.96],filename='logt_logr_1041_zoom.eps',xcharsize=2.9,ycharsize=2.9,xtickinterval=0.5
                                
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,REFORM(revol1041),REFORM(10^logrhoevol1041),'','','',$
                                x2=REFORM(r/6.96/1.01),y2=REFORM(den),color2='blue',linestyle2=2,$
                                x3=REFORM(r/6.96/0.998),y3=REFORM(den),color3='red',linestyle3=0,$
                                xrange=[11,12.5],yrange=[1e-12,2e-7],xreverse=0,_EXTRA=extra,rebin=1,factor=1.0,/ylog,$
                                POSITION=[0.14,0.11,0.93,0.96],filename='logrho_logr_1041_zoom.eps',xcharsize=2.9,ycharsize=2.9,xtickinterval=0.5
                          
                                                                                                                   

ZE_READ_RVTJ,rvtj_file_array[47],r,v,sigma,ed,t,ross,fluxross,atom,ionden,den,clump,ND,NC,NP,NCF,mdot,lstar,output_format_date,completion_of_model,program_date,was_t_fixed,species_name_con,greyt,heating_rad_decay                                
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,REFORM(revol12601),REFORM(10^logtevol12601),'Radius (Rsun)','Temperature (K)','',$
                                x2=REFORM(r/6.96),y2=REFORM(t*1e4),color2='blue',linestyle2=2,filename='logt_logr_12601.eps',$
                                x3=REFORM(r/6.96/1.02),y3=REFORM(t*1e4),color3='red',linestyle3=0,$
                                xrange=[0.1,100],yrange=[1e4,4e8],xreverse=0,_EXTRA=extra,rebin=1,factor=1.0,/xlog,/ylog,POSITION=[0.135,0.115,0.96,0.96],pcharsize=2.0
                                
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,REFORM(revol12601),REFORM(10^logrhoevol12601),'Radius (Rsun)','Density (g/cm^3)','',$
                                x2=REFORM(r/6.96),y2=REFORM(den),color2='blue',linestyle2=2,filename='logrho_logr_12601.eps',$  
                                x3=REFORM(r/6.96/1.02),y3=REFORM(den),color3='red',linestyle3=0,$                             
                                xrange=[0.1,100],yrange=[1e-13,1e4],xreverse=0,_EXTRA=extra,rebin=1,factor=1.0,/xlog,/ylog,POSITION=[0.135,0.115,0.96,0.96],pcharsize=2.0
                                
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,REFORM(revol12601),REFORM(10^logtevol12601),'','','',$
                                x2=REFORM(r/6.96),y2=REFORM(t*1e4),color2='blue',linestyle2=2,$
                                x3=REFORM(r/6.96/1.02),y3=REFORM(t*1e4),color3='red',linestyle3=0,$
                                xrange=[1.2,1.4],yrange=[7e4,7e6],xreverse=0,_EXTRA=extra,rebin=1,factor=1.0,/ylog,$
                                POSITION=[0.12,0.11,0.96,0.96],filename='logt_logr_12601_zoom.eps',xcharsize=2.9,ycharsize=2.9
                                
ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,REFORM(revol12601),REFORM(10^logrhoevol12601),'','','',$
                                x2=REFORM(r/6.96),y2=REFORM(den),color2='blue',linestyle2=2,$
                                x3=REFORM(r/6.96/1.02),y3=REFORM(den),color3='red',linestyle3=0,$
                                xrange=[1,2],yrange=[1e-10,1e-5],xreverse=0,_EXTRA=extra,rebin=1,factor=1.0,/ylog,$
                                POSITION=[0.14,0.11,0.95,0.96],filename='logrho_logr_12601_zoom.eps',xcharsize=2.9,ycharsize=2.9
                                                                                                

;;;temperature structure versus r
;lineplot,REFORM(revol1041),REFORM(10^logtevol1041) ;envelope evol
;lineplot,REFORM(r/6.96),REFORM(t*1e4)                                    ;cmfgen
;;;
;;;density structure versus r
;lineplot,REFORM(revol),REFORM(10^logtevol) ;envelope evol
;lineplot,REFORM(r/6.96),REFORM(den)                                    ;cmfgen
;
END