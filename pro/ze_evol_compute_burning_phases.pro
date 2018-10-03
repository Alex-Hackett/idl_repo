PRO ZE_EVOL_COMPUTE_BURNING_PHASES,model,dir=dir,tstarth=tstarth,tendh=tendh,modelnumber_starth=modelnumber_starth,modelnumber_endh=modelnumber_endh,tauh=tauh,$
                                    tstart_he=tstart_he,tend_he=tend_he,modelnumber_start_he=modelnumber_start_he,modelnumber_end_he=modelnumber_end_he,tau_he=tau_he,$
                                    tstartc=tstartc,tendc=tendc,modelnumber_startc=modelnumber_startc,modelnumber_endc=modelnumber_endc,tauc=tauc,$
                                    tstarto=tstarto,tendo=tendo,modelnumber_starto=modelnumber_starto,modelnumber_endo=modelnumber_endo,tauo=tauo,$
                                    tstartne=tstartne,tendne=tendne,modelnumber_startne=modelnumber_startne,modelnumber_endne=modelnumber_endne,taune=taune
;adapted from tauCalc.f95
;finish later
;
; initilization 
;
dir='/Users/jgroh/evol_models/Grids2010/wg'
;model='P012z14S4'
wgfile=dir+'/'+model+'.wg' ;assumes model directory name and .wg files have the same name 

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut;,timestep_ini=0,/reload

ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u1,index_varnamex_wgfile,return_valx
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u15',data_wgfile_cut,u15,return_valz    ;X center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u17',data_wgfile_cut,u17,return_valz    ;Y center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u18',data_wgfile_cut,u18,return_valz    ;C center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u20',data_wgfile_cut,u20,return_valz    ;N center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u22',data_wgfile_cut,u22,return_valz    ;O center
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u16',data_wgfile_cut,u16,return_valz    ;Ne20 center

i=0
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
    modelnumber_starth=i+1
    print,'tstarth= ',tstarth,'  X_H(max)= ',xhmax,'  modelnumber= ',modelnumber_starth,FORMAT='(a,e12.6,a,f8.6,a,i7)'
    xhemax=0.0d0
    xcmax=0.0d0
    xnemax=0.0d0
    xomax=0.0d0
    xsimax=0.0d0

   for i=0., n_elements(u1) -2. do begin
 ;H-burning:
     if(u15[0] GT 1.0d-10) then BEGIN
       if((u15[i+1] LT 1.0d-5) AND (u15[i] GE 1.0d-5)) then BEGIN
         if(xhemax EQ 0.0) then BEGIN
           tendh=u1[i]
           xhemax=u17[i]
           modelnumber_endh=i
          print,FORMAT='(a,e12.6,a,f8.6,a,i7)','tendh= ',tendh,' xh= ',u15[i],'   modelnumber= ',i
           print,'X_He(max)= ',xhemax
         endif
       endif 
     endif else begin
       tendh=-99           
       modelnumber_endh=i
       tauh=-99
     endelse
;! He-burning
     if((u15[i] LT 1.0d-5) AND (u17[i] GT 1.0d-10)) then begin
       if ((u17[i+1] LT (xhemax-0.003d0)) AND  (u17[i] GE (xhemax-0.003d0))) then begin
         tstart_he=u1[i]
          modelnumber_start_he=i
         print,FORMAT='(a,e12.6,a,f8.6,a,i7)', 'tstart_he= ',tstart_he,',  xhe= ',u17(i),',   modelnumber= ',modelnumber_start_he
       endif
       if ((u17[i+1] LT 1.0d-5) AND (u17[i] GE 1.0d-5)) then begin
         if(xcmax EQ 0.0d0) then begin
           tend_he=u1[i]
           xcmax=u18[i]
           modelnumber_end_he=i
           print,FORMAT='(a,e12.6,a,f8.6,a,i7)','tend_he= ',tend_he,', xhe= ',u17(i), ',   modelnumber= ',modelnumber_end_he
           print,format='(a,f8.6)','X_C12(max)= ',xcmax
         endif
       endif
     endif 
;! C-burning
     if(u15[i] LT 1.0d-5 AND u17[i] LT 1.0d-5 AND u18[i] GT 1.0d-10) then begin
       if(u18[i+1] LT (xcmax-0.003d0) AND u18[i] GE (xcmax-0.003d0)) then begin 
         tstartc=u1[i]
         modelnumber_startc=i
         print,FORMAT='(a,e12.6,a,f8.6,a,i7)', 'tstartc= ',tstartc,',  xc= ',u18(i),',   modelnumber= ',modelnumber_startc
       endif
       if((u18[i+1] LT 1.0d-5) and (u18(i) GE 1.0d-5)) then begin
         if(xnemax EQ 0.0d0) then begin
           tendc=u1(i)
           xnemax=u16(i)
           modelnumber_endc=i
           print,FORMAT='(a,e12.6,a,f8.6,a,i7)','tendc= ',tendc,', xc= ',u18(i), ',   modelnumber= ',modelnumber_endc
           print,format='(a,f8.6)','X_Ne20(max)= ',xnemax
         endif
       endif
     endif
;! Ne-burning
     if((u15(i)LT 1.0d-5) and (u17(i) LT 1.0d-5) and (u18(i) LT 1.0d-5) and (u16(i) GT 1.0d-10)) then begin
       if((u16(i+1) LT (xnemax-0.003d0)) and (u16(i) GE (xnemax-0.003d0))) then begin
         tstartne=u1(i)
         modelnumber_startne=i
         print,FORMAT='(a,e12.6,a,f8.6,a,i7)', 'tstartne= ',tstartne,',  xne= ',u16(i),',   modelnumber= ',modelnumber_startne
       endif
       if((u16[i+1] LT 1.0d-3) and (u16(i) GE 1.0d-3)) then begin
         if(xomax EQ 0.0d0) then begin
           tendne=u1(i)
           xomax=u22(i)
           modelnumber_endne=i
           print,FORMAT='(a,e12.6,a,f8.6,a,i7)','tendne= ',tendne,', xne= ',u16(i), ',   modelnumber= ',modelnumber_endne
           print,format='(a,f8.6)','X_O16(max)= ',xomax
         endif
       endif
     endif
;! O-burning
     if((u15(i) LT 1.0d-5) and (u17(i) LT 1.0d-5) and (u18(i) LT 1.0d-3) and (u22(i) GT 1.0d-10)) then begin
       if((u22(i+1) LT (xomax-0.003d0)) and (u22(i) GE (xomax-0.003d0))) then begin
         tstarto=u1(i)
         modelnumber_starto=i
         print,FORMAT='(a,e12.6,a,f8.6,a,i7)', 'tstarto= ',tstartne,',  xo= ',u22(i),',   modelnumber= ',modelnumber_starto
       endif
       if((u22(i+1) LT 1.0d-5) and (u22(i) GE 1.0d-5)) then begin
         if(xsimax EQ 0.0d0) then begin
           tendo=u1(i)
           xsimax=u22(i)
           modelnumber_endo=i
           print,FORMAT='(a,e12.6,a,f8.6,a,i7)','tendo= ',tendo,', xo= ',u22(i), ',   modelnumber= ',modelnumber_endo
           print,format='(a,f8.6)','X_Si(max)= ',xsimax
         endif
       endif
     endif          
   endfor 

 
 agetot=u1[n_elements(u1)-1]
 print,agetot 
 
if n_elements(tendh) GT 0 THEN BEGIN
    tauh=tendh-tstarth
    print,'t_H = ', tauh 
END    
    
if (n_elements(tend_he) GT 0 AND n_elements(tstart_he) GT 0) THEN BEGIN
     tau_he=tend_he-tstart_he
     print,'t_He = ', tau_he    
END  
   
if n_elements(tendc) GT 0 THEN  BEGIN 
   tauc=tendc-tstartc
   print,'t_C = ', tauc   
END   

if n_elements(tendne) GT 0 THEN  BEGIN
    taune=tendne-tstartne
    print,'t_Ne = ', taune 
END   

if n_elements(tendo) GT 0 THEN BEGIN
    tauo=tendo-tstarto
    print,'t_O = ', tauo         
END

END
