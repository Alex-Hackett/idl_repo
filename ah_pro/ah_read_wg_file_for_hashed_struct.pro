PRO ah_read_wg_file_for_hashed_struct, wgfile,data_wgfile,data_wgfile_cut,$
  header_wgfile=header_wgfile,count_Wgfile=count_wgfile,nmodels=nmodels,$
  timestep_ini=timestep_ini,timestep_fin=timestep_fin,$
  reload=reload,compress=compress,binary=binary


modeldir = FILE_DIRNAME(wgfile , /MARK_DIRECTORY)

    ;compress not working properly WORK IN ZE_READ_ASCII.PRO
    IF KEYWORD_SET(COMPRESS) THEN BEGIN
      print,'Reading the following .wg file:  ', wgfile+'.gz'
      data_wgfile=ZE_READ_ASCII(wgfile+'.gz',data_start=0,header=header_wgfile,count=count_wgfile,compress=1)
      print,'Finished reading the following .wg file:  ', wgfile+'.gz'
    ENDIF ELSE BEGIN

      IF FILE_EXIST(wgfile+'.gz') THEN BEGIN
        cd, modeldir
        print,'Gunzipping the following .wg.gz file:  ', wgfile+'.gz'
        spawn,'gunzip '+wgfile+'.gz',result,/sh
        print,'Reading the following .wg file:  ', wgfile
        data_wgfile=ZE_READ_ASCII(wgfile,data_start=0,header=header_wgfile,count=count_wgfile)
        spawn,'gzip '+wgfile,result,/sh
        print,'Finished gzipping the following .wg file:  ', wgfile
      ENDIF ELSE BEGIN
        print,'Reading the following .wg file:  ', wgfile
        data_wgfile=ZE_READ_ASCII(wgfile,data_start=0,header=header_wgfile,count=count_wgfile)
        print,'Finished reading the following .wg file:  ', wgfile
      ENDELSE

      ;print,'Reading the following .wg file:  ', wgfile
      ;data_wgfile=ZE_READ_ASCII(wgfile,data_start=0,header=header_wgfile,count=count_wgfile)
      ; print,'Finished reading the following .wg file:  ', wgfile
    ENDELSE

    ;ZE_EVOL_LOAD_WGFILE_VARIABLE_NAMES, wgfile_variables

    IF KEYWORD_SET(BINARY) THEN col_xcen=28 ELSE col_xcen=21

    i=0
    u1=data_wgfile.field001[1,*]
    u15=data_wgfile.field001[col_xcen,*]
    if (u1[0] EQ 0.0d0) then begin
      xhini = u15[0]
      i=1
      while(u15[i] GT (xhini-0.003d0)) DO BEGIN
        xhmax=u15[i+1]
        tstarth=u1[i+1]
        i=i+1
      endwhile
    endif else begin
      xhmax=u15[0]
      tstarth=u1[0]
    endelse

    zams_timestep=i+1

    IF n_elements(timestep_ini) LT 1 THEN timestep_ini=zams_timestep
    IF N_elements(timestep_fin) LT 1 THEN timestep_fin=n_elements(REFORM(data_wgfile.field001[col_xcen,*])) -1
    data_wgfile_cut=data_wgfile.field001[*,timestep_ini:timestep_fin]
    nmodels=timestep_fin-timestep_ini +1

    print,'Timestep ini = ', timestep_ini, ' Timestep_fin = ', timestep_fin


END