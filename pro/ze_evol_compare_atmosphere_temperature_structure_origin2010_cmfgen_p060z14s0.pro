;PRO ZE_EVOL_COMPARE_ATMOSPHERE_TEMPERATURE_STRUCTURE_ORIGIN2010_CMFGEN_P060z14S0
;compares temperature structure from Origin2010 and CMFGEN models

modeldir='/Users/jgroh/evol_models/Grids2010/P060z14S0'
model_name='P060z14S0'
timestep=101
timestep=551
;timestep=1051
timestep=3841
;timestep=5871
timestep=6301
timestep=6501
timestep=19001

ZE_EVOL_READ_E_FILE_FROM_GENEVA_ORIGIN2010,modeldir,model_name,timestep,data_efile,header_efile,num_model=0
evollogr=REFORM(data_efile[3,*])
evollogt=REFORM(data_efile[10,*])
evollogk=REFORM(data_efile[7,*])
evollogden=REFORM(data_efile[2,*])
evolgammaed=REFORM(data_efile[28,*])

cmfgen_mod='/Users/jgroh/ze_models/grid_P060z14S0/ZAMS_model57_T48386_L507016_logg_4d2015_Fe_OK/'
;cmfgen_mod='/Users/jgroh/ze_models/grid_P060z14S0/model1000_T45796_L555083_logg_4d0519_Fe_OK/'
cmfgen_mod='/Users/jgroh/ze_models/grid_P060z14S0/model3800_T27864_L743098_logg3d01_Fe_OK/'
cmfgen_mod='/Users/jgroh/ze_models/grid_P060z14S0/model3800_T27864_L743098_logg3d01/'
;cmfgen_mod='/Users/jgroh/ze_models/grid_P060z14S0/model5500_T30783_L941860_logg2d78/'
;cmfgen_mod='/Users/jgroh/ze_models/grid_P060z14S0/model5820_T45243_L916947_logg3d4654/'
;cmfgen_mod='/Users/jgroh/ze_models/grid_P060z14S0/model5820_T45243_L916947_logg3d4654_Fe_OK/'
cmfgen_mod='/Users/jgroh/ze_models/grid_P060z14S0/model6250_T56420_L897212_logg_2d913_tauref20/'
cmfgen_mod='/Users/jgroh/ze_models/grid_P060z14S0/model18950_T140543_L350244_logg_5d580/'
cmfgen_mod='/Users/jgroh/ze_models/grid_P060z14S0/model18950_T140543_L350244_logg_5d580_hydro/'

rvtj=cmfgen_mod+'RVTJ'
meanopac=cmfgen_mod+'MEANOPAC'
hydro=cmfgen_mod+'HYDRO'
ZE_READ_RVTJ,rvtj,r,v,sigma,ed,t,ross,fluxross,atom,ionden,den,clump,ND,NC,NP,NCF,mdot,lstar,output_format_date,completion_of_model,program_date,was_t_fixed,species_name_con,greyt,heating_rad_decay
readcol,meanopac,r2,i,tauross,deltatauross,rat_ross,chi_ross,chi_ross,chi_flux,chi_es,tau_flux,tau_es,rat_flux,rat_es,kappa
readcol,hydro,r,v,error,vdvdr,dpdr_on_rho,gtot,grad,gelec,gamma,depth,skipline=1,numline=80

;readcol,'/Users/jgroh/ze_models/grid_P060z14S0/model3800_T27864_L743098_logg3d01_Fe_OK_2/MEANOPAC',r2rev,irev,taurossrev
;readcol,'/Users/jgroh/ze_models/grid_P060z14S0/model3800_T27864_L743098_logg3d01_Fe_OK_2/T_OUT',depthrev,trev,skipline=2

;readcol,'/Users/jgroh/ze_models/grid_P060z14S0/model5820_T45243_L916947_logg3d4654_Fe_OK/MEANOPAC',r2rev,irev,taurossrev
;readcol,'/Users/jgroh/ze_models/grid_P060z14S0/model5820_T45243_L916947_logg3d4654_Fe_OK/T_OUT',depthrev,trev,skipline=2

;readcol,'/Users/jgroh/ze_models/grid_P060z14S0/temp/MEANOPAC',r2rev,irev,taurossrev
;readcol,'/Users/jgroh/ze_models/grid_P060z14S0/temp/T_OUT',depthrev,trev,skipline=2

;readcol,'/Users/jgroh/ze_models/grid_P060z14S0/model6250_T56420_L897212_logg_2d913_tauref20/MEANOPAC',r2rev,irev,taurossrev
;readcol,'/Users/jgroh/ze_models/grid_P060z14S0/model6250_T56420_L897212_logg_2d913_tauref20/T_OUT',depthrev,trev,skipline=2

;readcol,'/Users/jgroh/ze_models/grid_P060z14S0/model6851_T69550_L870531_logg_4d230_tauref10/FIN_CAL_GRID',irev,rrev,taurossrev,vrev,trev,narev,ne_on_narev,chirossrev,chiross_on_chies_rev,gamrev

;readcol,'/Users/jgroh/ze_models/grid_P060z14S0/model6551_T63351_L883519_logg_4d062/FIN_CAL_GRID',irev,rrev,taurossrev,vrev,trev,narev,ne_on_narev,chirossrev,chiross_on_chies_rev,gamrev

readcol,'/Users/jgroh/ze_models/grid_P060z14S0/model18950_T140543_L350244_logg_5d580/MEANOPAC_OLD',r2rev,irev,taurossrev
readcol,'/Users/jgroh/ze_models/grid_P060z14S0/model18950_T140543_L350244_logg_5d580/T_OUT',depthrev,trev,skipline=2
readcol,'/Users/jgroh/ze_models/grid_P060z14S0/model18950_T140543_L350244_logg_5d580_hydro/FIN_CAL_GRID',irev,rrev,taurossrev,vrev,trev,narev,ne_on_narev,chirossrev,chiross_on_chies_rev,gamrev

;lineplot,REFORM(rrev*1e10),REFORM(trev*1e4) 
!P.Background = fsc_color('white')

evoltau=indgen(100)*1D0
evoltgrey=dblarr(100)
for i=0, 99 do evoltgrey[i]=(43000.^4 * 0.75D0*(evoltau[i]+0.66D0))^0.25

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,REFORM(r*1e10),REFORM(t*1e4),'r','lt','',z1=alog10(v),labelz='v',$
                               minz=-2.5,maxz=1.0,rebin=0,xreverse=0,xrange=[8.1e11,8.25e11],_EXTRA=extra

;;temperature structure versus r
lineplot,10^evollogr,10^evollogt ;envelope evol
lineplot,REFORM(r2rev*1e10),REFORM(t*1e4)                                    ;cmfgen

;;density structure versus r
;lineplot,10^evollogr,10^evollogden ;envelope evol
;lineplot,REFORM(r*1e10),REFORM(den)                                    ;cmfgen

;opacity versus r
;lineplot,evollogr,evollogk
;lineplot,alog10(REFORM(r*1e10)),REFORM(alog10(kappa)) 

;;gammaed
;lineplot,evollogr,evolgammaed
;lineplot,alog10(REFORM(r*1e10)),REFORM(gamma) 

;t x tau
;lineplot,evoltau,evoltgrey
;lineplot,tauross,t*1e4

END