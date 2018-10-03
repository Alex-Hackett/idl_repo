PRO ZE_EVOL_RUN_EVOSOLL,modeldir,model_name,timestep,b_file_number,clean=clean

;run evosolL
cd,modeldir
spawn,'/Users/jgroh/evolMac_2013may10/evosolL < '+model_name+'.input'



IF KEYWORD_SET(CLEAN) THEN BEGIN ;will delete most files, and leave only .v file, .l file, .b, and Struct file; GOOD FOR MODELS ALREADY RUN and BEING RESTARTED
;delete .a, , .g, .s, .x,.y,.z,input_changes.log,P060z14S4.input, mominertenv.dat
spawn,'rm '+model_name+'.a'+strcompress(string(timestep, format='(I07)')) 
spawn,'rm '+model_name+'.g'+strcompress(string(timestep, format='(I07)'))
spawn,'rm '+model_name+'.s'+strcompress(string(timestep, format='(I07)'))
spawn,'rm '+model_name+'.x'+strcompress(string(timestep, format='(I07)'))
spawn,'rm '+model_name+'.y'+strcompress(string(timestep, format='(I07)'))
spawn,'rm '+model_name+'.z'+strcompress(string(timestep, format='(I07)'))
spawn,'rm mominertenv.dat'

;keep .v file, .l file, .b, and Struct file, and compress them
spawn,'gzip -f '+model_name+'.b'+strcompress(string(b_file_number, format='(I05)')) ;gzip the b file used to run the model
spawn,'gzip -f '+model_name+'.b'+strcompress(string(b_file_number+1, format='(I05)')) ;gzip the b file created by the model
spawn,'gzip -f '+model_name+'.l'+strcompress(string(timestep, format='(I07)'))
spawn,'gzip -f '+model_name+'.v'+strcompress(string(timestep, format='(I07)'))
spawn,'gzip -f '+model_name+'_StrucData_'+strcompress(string(timestep, format='(I07)'))+'.dat'
ENDIF

END