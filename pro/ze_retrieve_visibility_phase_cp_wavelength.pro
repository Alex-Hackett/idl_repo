;--------------------------------------------------------------------------------------------------------------------------
 
PRO ZE_RETRIEVE_VISIBILITY_PHASE_CP_WAVELENGTH,baseline_x_obs,baseline_y_obs,baseline_xloc_all,baseline_yloc_all,visamp,vis_val,phase=phase, value_phase=value_phase
;finding location of a given baseline coordinate in the model image, and retrieving visibilities and phase values corresponding to that baseline
;difference from routine above (TRIPLET) is that only one baseline is queried at a time, so there is no closure phase returned
;reqriteen using  interpolation to return correct values interpolated (and not the closest values)

x_index_vec=indgen(n_elements(baseline_xloc_all))
linterp,baseline_xloc_all,x_index_vec,baseline_x_obs,index_baseline_x_obs
;print,baseline_x_obs,index_baseline_x_obs

y_indey_vec=indgen(n_elements(baseline_yloc_all))
linterp,baseline_yloc_all,y_indey_vec,baseline_y_obs,indey_baseline_y_obs
;
;indexx1=findel(baseline_x_obs,baseline_xloc_all)
;indexy1=findel(baseline_y_obs,baseline_yloc_all)
;print,indexx1,indexy1
vis_val=interpolate(visamp,index_baseline_x_obs,indey_baseline_y_obs)

if keyword_set(phase) then value_phase=interpolate(phase,index_baseline_x_obs,indey_baseline_y_obs)

END