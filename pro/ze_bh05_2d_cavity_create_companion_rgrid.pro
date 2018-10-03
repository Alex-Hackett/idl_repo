;PRO ZE_BH05_2D_CAVITY_CREATE_COMPANION_RGRID
Angstrom = '!6!sA!r!u!9 %!6!n'
!P.Background = fsc_color('white')
frvsigcomp='/Users/jgroh/ze_models/etacar/eta_companion_r5_interp_rgrid_mod111_try2/RVSIG_COLed'
rvtjprim='/Users/jgroh/ze_models/etacar_john/mod_111/RVTJ'

ZE_READ_RVTJ,rvtjprim,rprim,vprim,sigmaprim,ed,t,chiross,fluxross,atom,ionden,denclump,clump,NDprim,NCprim,NP,NCF,mdot,lstar,output_format_date,$
    completion_of_model,program_date,was_t_fixed,species_name_con
    
ZE_READ_RVSIGCOL_V3,frvsigcomp,rcomp,vcomp,sigmacomp,rvsigcomp
ndcomp=n_elements(rcomp)

RP1=29

rcav=[rprim[0:rp1-3],rcomp+rprim[rp1],rprim[rp1:NDprim-1]]
vcompextrapolatedrev=dblarr(n_elements(vprim[0:rp1-3]))
for i=0, n_elements(vcompextrapolated)-1 DO  vcompextrapolatedrev[i]=vcomp[0]+i*(vcomp[0]-vcomp[1])/(rcomp[0]-rcomp[1])

vcompextrapolated=REVERSE(vcompextrapolatedrev)
vcavreal=[vcompextrapolated,vcomp,vprim[rp1:NDprim-1]]
vcavassumed=[vcompextrapolated,vcomp[0:ndcomp-33],vprim[rp1:NDprim-1]]
ndfin=n_elements(vcavassumed)


vprimcav=cspline(rprim,vprim,rcav) ;interpolate to the same r grid of model 2

ZE_CMFGEN_COMPUTE_SIGMA_CRUDE,rprim,vprim,sigmaprim
ZE_WRITE_RVSIG_COL,rprim,vprim,sigmaprim,ndprim,'/Users/jgroh/temp/RVSIG_COL_SCRATCH_prim'  

ZE_CMFGEN_COMPUTE_SIGMA_CRUDE,rcav,vprimcav,sigmaprimcav
ZE_WRITE_RVSIG_COL,rcav,vprimcav,sigmaprimcav,ndfin,'/Users/jgroh/temp/RVSIG_COL_SCRATCH_primcav'  


END