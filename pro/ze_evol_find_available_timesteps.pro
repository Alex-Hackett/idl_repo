PRO ZE_EVOL_FIND_AVAILABLE_TIMESTEPS,modelstr,type_file,timesteps_available,dirmod=dirmod
;valid type files: '.v','.g', '.a', '.b','.z'
IF n_elements(dirmod) EQ 0 THEN dirmod='/Users/jgroh/evol_models/Z014/'+modelstr

;spawn, 'ls '+dirmod+'/*'+type_file+'[0123456789]* ',result,/sh ; DOES NOT WORK IF NUMBER OF TIMESTEPS IS TOO LARGE > 32000
spawn, 'ls '+dirmod+'| grep  '+type_file,result,sh

timesteps_available=dblarr(n_elements(result))

for i=0, n_elements(result) - 1 DO BEGIN
  timesteps_available[i]=long(strmid(result[i],strpos(result[i],type_file)+strlen(type_file),7)) ;assumes Origin2010 filename convention with timesteps having 7 algarisms,works only for filetypes of length 2 (like .l, .b )  
endfor

;removes last element if it is a 0 ; that's because a wrong file extension (e.g. XXXXX.burn) was parsed instead of a .b
;not working
;if timesteps_available[n_elements(timesteps_available)-1] EQ 0 THEN remove,n_elements(timesteps_available)-1,timesteps_available
END