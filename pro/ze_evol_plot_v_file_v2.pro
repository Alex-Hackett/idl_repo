PRO ZE_EVOL_PLOT_V_FILE_V2,vfile,data_vfile,xstr,ystr,xtitle,ytitle,$
                         label=label, zstr=zstr,labelz=labelz,ct=ct,minz=minz,maxz=maxz,rebin=rebin,$
                         xreverse=xreverse,wgfile_loaded=wgfile_loaded,xext=xext,yext=yext,zext=zext,_EXTRA=extra                         
;routine to produce multi-vector XY plots of the .wg files from the Geneva Stellar Evolution code Origin2010 
;if z is specified, curve will be color coded acording to the z values (only linear scaling supported so far)

;will read a .wg file if data_wgfile_cut has not been provided
;should_we_read_wgfile=''
;IF (n_elements(data_wgfile_cut) LT 1) THEN BEGIN
;        READ,should_we_read_wgfile,prompt='Wgfile not loaded, will quit if you do not read one. Would you like to read a .wg file? (y/n)'
;        IF should_we_read_wgfile EQ 'n' THEN RETURN
;        IF should_we_read_wgfile EQ 'y' THEN BEGIN
;          dir='' & model=''
;          READ,dir,prompt='directory (up to Zxxx): '
;          READ,model,prompt='model dir name: '   
;          wgfile=dir+'/'+model+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 
;          ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
;        ENDIF ELSE BEGIN
;          print,'Please type y or n next time. Exitting.'
;          RETURN
;        ENDELSE
;ENDIF

If N_elements(label) LT 1 THEN label=STRMID(vfile,strpos(vfile,'/',/REVERSE_SEARCH) +1 , strpos(vfile,'.v',/REVERSE_SEARCH) - strpos(vfile,'/',/REVERSE_SEARCH) -1 )

;;compute variables not output in the .wg file
;ZE_EVOL_COMPUTE_QUANTITIES_FROM_WGFILE,data_wgfile_cut,rstar,logg,vesc,vinf,eta_star,Bmin,Jdot


ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,xstr,data_vfile,x,index_varnamex_vfile,return_valx

ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,ystr,data_vfile,y,index_varnamey_vfile,return_valy

If n_elements(zstr) gt 0 THEN BEGIN 
    ZE_EVOL_OBTAIN_VARIABLE_FROM_V_FILE,zstr,data_vfile,z,return_valz
    IF (return_valz EQ -1 ) THEN BEGIN
      print,'Variable '+zstr+' not found in the .wg file. Assuming it has been passed as zext.'
      z=zext 
    ENDIF
ENDIF    
        
IF (return_valx EQ -1 ) THEN BEGIN
    print,'Variable '+xstr+' not found in the .wg file. Assuming it has been passed as xext.'
    x=xext 
ENDIF    
    
IF (return_valy EQ -1 ) THEN BEGIN
    print,'Variable '+ystr+' not found in the .wg file. Assuming it has been passed as yext.' 
    y=yext
ENDIF    

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,x,y,xstr,ystr,label,z1=z,labelz=zstr,rebin=rebin,xreverse=xreverse,_EXTRA=extra    
;ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,x,y,xstr,ystr,label,z=z,labelz=zstr,x2=x,y2=eta_star,rebin=rebin,xreverse=xreverse,_EXTRA=extra

END