PRO ZE_CMFGEN_FIND_AVAILABLE_SPEC_IN_DIR,dirmod,timestep_available_obs_fin_sort_match,allobsfinfiles_sort_match,allobscontfiles_sort_match
;find timesteps for which spectra have been computed
;returns timestep and full path of both obs_fin and obs_cont files
;only return timesteps for which obs_fin and obs_cont have been computed
;assume grid strucure such as P060z14S0 is in grid_P060z14S0 -- have to specify dirmod if this is not the case (e.g. for SN progenitor grid)
;DOES NOT WORK

IF n_elements(dirmod) EQ 0 THEN dirmod='/Users/jgroh/ze_models/grid_'+modelstr



;grep all models that have an obs_fin* computed
spawn, 'ls '+dirmod+'/*/obs/obs_fin*' ,allobsfinfiles,/sh
timestep_available_obs_fin=lonarr(n_elements(allobsfinfiles))
for i=0, n_elements(allobsfinfiles) -1 do timestep_available_obs_fin[i]=long(strmid(allobsfinfiles[i],strpos(allobsfinfiles[i],'/',/REVERSE_)+1,6))

;grep all models that have an obs_cont computed -- note that some have been computed as /obs_cont/obs_fin
spawn, 'ls '+dirmod+'/*/obs*con*/obs*' ,allobscontfiles,/sh
timestep_available_obs_cont=lonarr(n_elements(allobscontfiles))
for i=0, n_elements(allobscontfiles) -1 do timestep_available_obs_cont[i]=long(strmid(allobscontfiles[i],strpos(allobscontfiles[i],'/',/REVERSE)+1,6))

;first sort values for use of value_locate later on
timestep_available_obs_fin_sort=timestep_available_obs_fin(sort(timestep_available_obs_fin))
allobsfinfiles_sort=allobsfinfiles(sort(timestep_available_obs_fin))
timestep_available_obs_cont_sort=timestep_available_obs_cont(sort(timestep_available_obs_cont))
allobscontfiles_sort=allobscontfiles(sort(timestep_available_obs_cont))

;will return only models that have both obs_fin and obs_cont; this is found computing:
match_index=value_locate(timestep_available_obs_fin_sort,timestep_available_obs_cont_sort)
timestep_available_obs_fin_sort_match=timestep_available_obs_fin_sort[match_index]
allobsfinfiles_sort_match=allobsfinfiles_sort[match_index]
allobscontfiles_sort_match=allobscontfiles_sort ;check this

;print,'CMFGEN available timesteps '
;print,timestep_available_obs_fin_sort_match

END