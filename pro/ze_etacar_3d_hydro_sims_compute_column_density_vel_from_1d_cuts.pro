PRO ZE_ETACAR_3D_HYDRO_SIMS_COMPUTE_COLUMN_DENSITY_VEL_FROM_1D_CUTS,l_over_a_for_den,rho_los,vel_los,epoch,vmin,vmax,column_density

index_keep=WHERE(vel_los[*,epoch] gt vmin AND vel_los[*,epoch] lt vmax,COMPLEMENT=index_cut)
rho_los_comp_column_density=rho_los
rho_los_comp_column_density[index_cut,epoch]=-28 ;REMEMBER WE ARE DEALING WITH LOG 
column_density=int_tabulated(l_over_a_for_den[*,epoch]*15.*1.496e13,10^(rho_los_comp_column_density[*,epoch] + 23.78),/DOUBLE,SORT=1) ; in cm ^ 2

print,'epoch: ',epoch,'  vmin= ',vmin,'  vmax= ',vmax,' column density', column_density
END