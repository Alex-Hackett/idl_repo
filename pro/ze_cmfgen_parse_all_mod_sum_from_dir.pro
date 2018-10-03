PRO ZE_CMFGEN_PARSE_ALL_MOD_SUM_FROM_DIR,dir,lstar_array,tstar_array,teff_array,rstar_array,rphot_array,mdot_array,vinf1_array,xn_array,grid_info_array,habund_array,heabund_array,cabund_array,nabund_array,oabund_array,feabund_array,dir2=dir2,dir3=dir3,dir4=dir4,modelid=modelid,xwidget=xwidget
;dir='/Users/jgroh/ze_models/ze_models_computador_agcar/ze_models/agcar'
;dir='/Volumes/Toshiba/cmfgen_models/agcar'
;dir='/Users/jgroh/ze_models/grid_P060z14S0/modsum'
;dir='/Users/jgroh/ze_models/SN_progenitor_grid'
spawn,'ls '+dir+'/*/MOD_SUM', modsum_file_array,sh 

if n_elements(dir2) GT 0 THEN BEGIN 
  spawn,'ls '+dir2+'/*/MOD_SUM', modsum_file_array2,sh
   modsum_file_array=[modsum_file_array,modsum_file_array2]
ENDIF 
  
 if n_elements(dir3) GT 0 THEN BEGIN 
  spawn,'ls '+dir3+'/*/MOD_SUM', modsum_file_array3,sh
   modsum_file_array=[modsum_file_array,modsum_file_array3]
ENDIF  

 if n_elements(dir4) GT 0 THEN BEGIN 
  spawn,'ls '+dir4+'/*/MOD_SUM', modsum_file_array4,sh
   modsum_file_array=[modsum_file_array,modsum_file_array4]
ENDIF  
   
nmodels=n_elements(modsum_file_array)
lstar_array=dblarr(nmodels) & tstar_array=dblarr(nmodels) & teff_array=dblarr(nmodels) & xn_array=strarr(nmodels) & rstar_array=dblarr(nmodels) & rphot_array=dblarr(nmodels) & mdot_array=dblarr(nmodels)
vinf1_array=dblarr(nmodels) & beta1_array=dblarr(nmodels) & habund_array=beta1_array & heabund_array=beta1_array & cabund_array=beta1_array & nabund_array=beta1_array & oabund_array=beta1_array & feabund_array=beta1_array 
& grid_info_array=strarr(nmodels) & finf_array=dblarr(nmodels) & vstclump_array=dblarr(nmodels)
for i=0, nmodels -1 do BEGIN
    ZE_CMFGEN_PARSE_ALL_QUANTITIES_FROM_MOD_SUM,modsum_file_array[i],lstar,tstar,teff,rstar,rphot,v_tau23,mdot,vinf1,beta1,maxcorr,mu,habund,heabund,cabund,nabund,oabund,feabund,t_tau20,r_tau20,logg_phot,logg_tau20,finf,vstclump
    lstar_array[i]=lstar
    tstar_array[i]=tstar
    teff_array[i]=teff
    rstar_array[i]=rstar  
    rphot_array[i]=rphot
    mdot_array[i]=mdot  
    vinf1_array[i]=vinf1
    beta1_array[i]=beta1
    habund_array[i]=habund
    heabund_array[i]=heabund
    cabund_array[i]=cabund
    nabund_array[i]=nabund
    oabund_array[i]=oabund
    feabund_array[i]=feabund   
    finf_array[i]=finf
    vstclump_array[i]=vstclump
    grid_info_array[i]=strmid(modsum_file_array[i],strpos(modsum_file_array[i],'ze_models')+10,strpos(modsum_file_array[i],'modsum')-strpos(modsum_file_array[i],'ze_models')-10)
    xn_array[i]=strmid(modsum_file_array[i],strpos(modsum_file_array[i],'modsum')+7,strpos(modsum_file_array[i],'/MOD_SUM')-strpos(modsum_file_array[i],'modsum')-7)   
     
  ;  print,modsum_file_array[i],alog10(lstar),alog10(tstar),alog10(teff);,rstar,rphot,v_tau23,mdot,vinf1,beta1
    ;print,lstar, ' & ',tstar, ' & ',teff, ' & ', rstar, ' & ',rphot, ' & ',mdot, ' & ',vinf1, ' & ',beta1,FORMAT='(E7.1,A,I6,A,I6,A,F7.2,A,F7.2,A,E7.1,A,I5,A,F5.1)'
ENDFOR

IF KEYWORD_SET(print_screen) THEN BEGIN
  print,FORMAT='(A-70,2x,A6,2x,A7,2x,A8,2x,A4,2x,A7)','MODEL', '  T*  ', '  Teff  ','   L*  ','  Mdot  ','Vinf',' X  ',' Y  ','   C   ','   N   ','   O   '
  print,FORMAT='(A-70,2x,I6,2x,I7,2x,E8.2,2x,I4,2x,F7.2,2x,E7.0,2x,F4.2,2x,F4.2,2x,E7.0,2x,E7.0)','Input values',tstar,lstar,mdot,vinf1,habund,yabund,cabund,nabund,oabund
  print,''
ENDIF

output_array=strarr(n_elements(lstar_array)+1)
output_array[0]=string('MODEL',FORMAT='(A-70)')+'  '+string('  T*  ',FORMAT='(A6)')+'  '+string('  Teff  ',FORMAT='(A6)')+'  '+string('   L*  ',FORMAT='(A7)')+'  '+string('  Mdot  ',FORMAT='(A8)')+'  '+string('  finf  ',FORMAT='(A4)')+'  '+string('Vinf1',FORMAT='(A4)')+'  '+string('Beta1',FORMAT='(A4)')+ $
               '  '+string(' X  ' ,FORMAT='(A4)')+'  '+string(' Y  ',FORMAT='(A4)')+'  '+string('   C   ',FORMAT='(A7)')+'  '+string('   N   ',FORMAT='(A7)')+'  '+string('   O   ',FORMAT='(A7)') 
;output_array[1]=string(modelid,FORMAT='(A-70)')+'  '+string(tstar,FORMAT='(I6)')+'  '+string(lstar,FORMAT='(I7)')+'  '+string(mdot,FORMAT='(E8.2)')+'  '+string(vinf,FORMAT='(I4)')+'  '+string(r_t,FORMAT='(F7.2)')+$
;                '  '+string(habund,FORMAT='(F4.2)')+'  '+string(heabund,FORMAT='(F4.2)')+'  '+string(cabund,FORMAT='(E7.0)')+'  '+string(nabund,FORMAT='(E7.0)')+'  '+string(oabund,FORMAT='(E7.0)')
output_array[2]=''

for i=0, n_elements(lstar_array) -1 do begin
  IF KEYWORD_SET(print_screen) THEN print,FORMAT='(A-70,2x,I6,2x,I7,2x,E8.2,2x,I4,2x,F7.2)',grid_info_array_sort[i]+xn_array_sort[i],tstar_array_sort[i],lstar_array_sort[i],mdot_array_sort[i],vinf1_array_sort[i]
  output_array[i+1]=string(grid_info_array[i] +xn_array[i],FORMAT='(A-70)')+'  '+string(tstar_array[i],FORMAT='(I6)')+'  '+string(teff_array[i],FORMAT='(I6)')+'  '+string(lstar_array[i],FORMAT='(I7)')+'  '+string(mdot_array[i],FORMAT='(E8.2)')+'  '+string(finf_array[i],FORMAT='(F4.2)')+'  '+$
                  string(vinf1_array[i],FORMAT='(I4)')+'  '+string(beta1_array[i],FORMAT='(F5.1)')+'  '+string(habund_array[i],FORMAT='(F4.2)')+'  '+string(heabund_array[i],FORMAT='(F4.2)') $
                  +'  '+string(cabund_array[i],FORMAT='(E7.0)')+'  '+string(nabund_array[i],FORMAT='(E7.0)')+'  '+string(oabund_array[i],FORMAT='(E7.0)')
endfor


;IF KEYWORD_SET(write) THEN WRT_ASCII,nightarray,dir_out+'log_'+night+'.txt'
if n_elements(modelid) LT 1 THEN modelid='input values'
IF KEYWORD_SET(xwidget) THEN XDISPLAYFILE,'',text=output_array,title='Closest models to '+modelid,/grow_to_screen,WIDTH=170


    
    ;use criteria
    ;lrange=[5.9,6.02]
    ;trange=[4.35,4.45]
    
    ;s=WHERE((alog10(tstar_array) GT trange[0]) AND (alog10(tstar_array) LT trange[1]))
;    print,'Selected models with Tstar in the range ',trange[0],' ', trange[1]
;    for i=0, n_elements(s) -1 do print,modsum_file_array[s[i]],alog10(lstar_array[s[i]]),alog10(tstar_array[s[i]]),alog10(teff_array[s[i]]) 

END