;PRO ZE_EVOL_COMPARE_ATMOSPHERE_TEMPERATURE_STRUCTURE_ORIGIN2010_CMFGEN
;compares temperature structure from Origin2010 and CMFGEN models

EVOLlogl=4.662
EVOLlogt=[  4.464, 4.464,  4.464,   4.465,  4.465,   4.465,   4.465,   4.465,   4.465,   4.466,   4.466,   4.467,   4.469,   4.472,   4.476,   4.481,   4.487,   4.495,   4.504,   4.514,   4.525,   4.538,   4.553]
EVOLtau=[0.0000,0.0002,0.0004,0.0007,0.0009,0.0014,0.0020,0.0032,0.0044,0.0072,0.0103,0.0174,0.0258,0.0468,0.0747,0.1109,0.1572,0.2161,0.2903,0.3839,0.5017,0.6498,0.8344]
EVOLlogr=EVOLlogt

for i=0, n_elements(EVOLlogr) -1 DO BEGIN
   ZE_COMPUTE_R_FROM_T_L,10^(EVOLlogt[i])/1e3,10^(EVOLlogl),rstartemp
   EVOLlogr[i]=alog10(rstartemp)
endfor   


rvtj='/Users/jgroh/ze_models/ogrid_24jun09/NT35000_logg425/RVTJ'
meanopac='/Users/jgroh/ze_models/ogrid_24jun09/NT35000_logg425/MEANOPAC'
ZE_READ_RVTJ,rvtj,r,v,sigma,ed,t,ross,fluxross,atom,ionden,den,clump,ND,NC,NP,NCF,mdot,lstar,output_format_date,completion_of_model,program_date,was_t_fixed,species_name_con,greyt,heating_rad_decay

l=40000.
tcolor=dblarr(nd)
for i=0, ND -1 DO BEGIN
   ZE_COMPUTE_T_FROM_R_L,r[i],l,tstartemp,/cmfgen
   print,r[i],l,tstartemp
   tcolor[i]=tstartemp
endfor  

readcol,meanopac,r2,i,tauross
!P.Background = fsc_color('white')

;lineplot,tauross,t*1e4/35000.0
;lineplot,tauross,tcolor*1e3/35000.0
;lineplot,evoltau,10^evollogt/10^evollogt[n_elements(evollogt)-2]

data=READ_ASCII('/Users/jgroh/evol_models/Z014/P020z14S0/P020z14S0_501.smatmos',data_start=1,header=header_atmos)


lineplot,REFORM(10^data.field01[3,*]/4.13999e11),REFORM(10^data.field01[17,*]) ;envelope evol
;lineplot,REFORM((10^evollogr)*6.96e10/10^11.617),REFORM(10^evollogt)           ;atmosphere evol
lineplot,REFORM(r/6.96/5.436),REFORM(t*1e4)                                    ;cmfgen
;lineplot,REFORM(r/6.96/5.436),REFORM(tcolor*1e3)                                    ;cmfgen


END