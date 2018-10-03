PRO ZE_EVOL_RESTART_MODEL,model_name,timestep,modeldir=modeldir,keep_only_timestep=keep_only_timestep
;restart an evol model from a given timestep
;useful for creating StructData file , .l file. .v file, and other purposes

;initialization of needed variables
nrun=0
adj_timestep=0
if n_elements(modeldir) EQ 0 THEN modeldir='/Users/jgroh/evol_models/Z014/'+model_name

;HAVE TO DO THIS OTHERWISE THERE IS NO B FILE TO RESTART IF VERY CLOSE TO ZAMS
if timestep LT 100. THEN timestep=101

;;replaces last digit of timestep by 1, otherwise will not be able to find it in WS file
 input_timestep=long(timestep) ;convert to LONG so we can do the proper replament of characters, spaces later on
 timestep=long(strmid(string(input_timestep),0,11)+'1')
 print,'Timestep replaced from '+ string(input_timestep)+' to '+string(timestep) 

;reads ws file to check if corresponding b file exists (MOST LIKELY NO, AND TIMESTEP WILL HAVE TO BE REVISED LATER)
ZE_EVOL_READ_WS_FILE_FROM_GENEVA_ORIGIN2010,modeldir,model_name,timestep,data_wsfile,s_timestep,b_file_number,nzmod=nzmod

WHILE (adj_timestep NE timestep) DO BEGIN

;finds b files available in dir for restart, pick the closest one before
 ZE_EVOL_FIND_AVAILABLE_TIMESTEPS,model_name,'.b',bfile_available
 closest_bfile_before_index=max(where((b_file_number-bfile_available) GE 0))
 closest_bfile_before_number=bfile_available[closest_bfile_before_index]
 closest_bfile_before=model_name+'.b'+strcompress(string(closest_bfile_before_number, format='(I05)'))
  
;adjust timestep to corresponding .b available  
 adj_timestep=LONG(timestep-(b_file_number-closest_bfile_before_number)*nzmod) 
 
;gunzip b file if not yet gunzipped
 IF FILE_EXIST(modeldir+'/'+closest_bfile_before+'.gz') THEN spawn,'gunzip '+modeldir+'/'+closest_bfile_before+'.gz' ELSE print,'b file already gunzipped'
 
;reads ws file to find info about actual restart timestep and write input file
 ZE_EVOL_READ_WS_FILE_FROM_GENEVA_ORIGIN2010,modeldir,model_name,adj_timestep,data_wsfile,adj_s_timestep,adj_b_file_number,nzmod=nzmod,/write_input,/pgplot;,/plot_to_screen

 ZE_EVOL_RUN_EVOSOLL,modeldir,model_name,adj_timestep,adj_b_file_number,/clean
 
;if this keyword is set, we keep only the files from the desired timestep, and delete  .v, .l. StrucData, for all timesteps computed to get there. REMEMBER THEY ARE GZIPPED
 IF (KEYWORD_SET(keep_only_timestep) AND (adj_timestep NE timestep)) THEN BEGIN
  cd,modeldir
 ;spawn,'rm '+model_name+'.b'+strcompress(string(adj_b_file_number+1, format='(I05)'))
  spawn,'rm '+model_name+'.l'+strcompress(string(adj_timestep, format='(I07)'))+'.gz'
  spawn,'rm '+model_name+'.v'+strcompress(string(adj_timestep, format='(I07)'))+'.gz'
  spawn,'rm '+model_name+'_StrucData_'+strcompress(string(adj_timestep, format='(I07)'))+'.dat.gz'  
 ENDIF

 nrun=nrun+1   
ENDWHILE

IF (KEYWORD_SET(keep_only_timestep)) THEN FOR i=0,nrun -1 DO spawn,'rm '+model_name+'.b'+strcompress(string(adj_b_file_number+1-i, format='(I05)'))+'.gz'

END