PRO ZE_CMFGEN_EVOL_FIND_CLOSEST_MODEL,tstar,lstar,mdot,vinf,habund,heabund,cabund,nabund,oabund,xn_array_sort,tstar_array_sort,lstar_array_sort,mdot_array_sort,vinf_array_sort,r_t_array_sort,tcut=tcut,modelid=modelid,xwidget=xwidget
;routine to automatically find a cmfgen model closest to the values given in the input
;uses Tstar as main diagnostic
;looks into grid_P060z14S0,grid_P060z14S4,grid_P085z14S0
;tut is the percentage cut in Tstar
dir='/Users/jgroh/ze_models/grid_P060z14S0/modsum'
dir2='/Users/jgroh/ze_models/grid_P060z14S4/modsum'
dir3='/Users/jgroh/ze_models/grid_P085z14S0/modsum'
dir4='/Users/jgroh/ze_models/SN_progenitor_grid'
ZE_CMFGEN_PARSE_ALL_MOD_SUM_FROM_DIR,dir,lstar_array,tstar_array,teff_array,rstar_array,rphot_array,mdot_array,vinf_array,xn_array,grid_info_array,habund_array,heabund_array,cabund_array,nabund_array,oabund_array,feabund_array,$
                                      dir2=dir2,dir3=dir3,dir4=dir4

ZE_COMPUTE_R_FROM_T_L,tstar/1e3,lstar,rstar

r_t=rstar*((vinf/2500.)/(mdot/1e-4))^0.6666
r_t_array=rstar_array*((vinf_array/2500.)/(mdot_array/1e-4))^0.6666

diff_tstar=(tstar_array-tstar)
abs_diff_tstar=abs(diff_tstar)

diff_r_t=(r_t_array -r_t)

diff_tstar_sort=diff_tstar(sort(abs_diff_tstar))
grid_info_array_sort=grid_info_array(sort(abs_diff_tstar))
xn_array_sort=xn_array(sort(abs_diff_tstar))
mdot_array_sort=mdot_array(sort(abs_diff_tstar))
vinf_array_sort=vinf_array(sort(abs_diff_tstar))
r_t_array_sort=r_t_array(sort(abs_diff_tstar))
tstar_array_sort=tstar_array(sort(abs_diff_tstar))
lstar_array_sort=lstar_array(sort(abs_diff_tstar))
habund_array_sort=habund_array(sort(abs_diff_tstar))
heabund_array_sort=heabund_array(sort(abs_diff_tstar))
cabund_array_sort=cabund_array(sort(abs_diff_tstar))
nabund_array_sort=nabund_array(sort(abs_diff_tstar))
oabund_array_sort=oabund_array(sort(abs_diff_tstar))
feabund_array_sort=feabund_array(sort(abs_diff_tstar))


IF KEYWORD_SET(TCUT) THEN BEGIN
  diff_tstar_sort_cut=diff_tstar_sort(WHERE(ABS((diff_tstar_sort/tstar)) LT tcut))
  xn_array_sort_cut=xn_array_sort(WHERE(ABS((diff_tstar_sort/tstar)) LT tcut))
  grid_info_array_sort_cut=grid_info_array_sort(WHERE(ABS((diff_tstar_sort/tstar)) LT tcut))
  mdot_array_sort_cut=mdot_array_sort(WHERE(ABS((diff_tstar_sort/tstar)) LT tcut))
  vinf_array_sort_cut=vinf_array_sort(WHERE(ABS((diff_tstar_sort/tstar)) LT tcut))
  r_t_array_sort_cut=r_t_array_sort(WHERE(ABS((diff_tstar_sort/tstar)) LT tcut))
  tstar_array_sort_cut=tstar_array_sort(WHERE(ABS((diff_tstar_sort/tstar)) LT tcut))
  lstar_array_sort_cut=lstar_array_sort(WHERE(ABS((diff_tstar_sort/tstar)) LT tcut))
   habund_array_sort_cut=habund_array_sort(WHERE(ABS((diff_tstar_sort/tstar)) LT tcut)) 
   heabund_array_sort_cut=heabund_array_sort(WHERE(ABS((diff_tstar_sort/tstar)) LT tcut)) 
   cabund_array_sort_cut=cabund_array_sort(WHERE(ABS((diff_tstar_sort/tstar)) LT tcut))
   nabund_array_sort_cut=nabund_array_sort(WHERE(ABS((diff_tstar_sort/tstar)) LT tcut))
   oabund_array_sort_cut=oabund_array_sort(WHERE(ABS((diff_tstar_sort/tstar)) LT tcut))
   feabund_array_sort_cut=feabund_array_sort(WHERE(ABS((diff_tstar_sort/tstar)) LT tcut))   
  
  diff_tstar_sort=diff_tstar_sort_cut
  xn_array_sort=xn_array_sort_cut
  grid_info_array_sort=grid_info_array_sort_cut
  mdot_array_sort=mdot_array_sort_cut
  vinf_array_sort=vinf_array_sort_cut
  r_t_array_sort=r_t_array_sort_cut
  tstar_array_sort=tstar_array_sort_cut
  lstar_array_sort=lstar_array_sort_cut
  habund_array_sort=habund_array_sort_cut
  heabund_array_sort=heabund_array_sort_cut
  cabund_array_sort=cabund_array_sort_cut
  nabund_array_sort=nabund_array_sort_cut
  oabund_array_sort=oabund_array_sort_cut
  feabund_array_sort=feabund_array_sort_cut
  
  
ENDIF   

IF KEYWORD_SET(print_screen) THEN BEGIN
  print,FORMAT='(A-70,2x,A6,2x,A7,2x,A8,2x,A4,2x,A7)','MODEL', '  T*  ', '   L*  ','  Mdot  ','Vinf', '  R_t  ',' X  ',' Y  ','   C   ','   N   ','   O   '
  print,FORMAT='(A-70,2x,I6,2x,I7,2x,E8.2,2x,I4,2x,F7.2,2x,E7.0,2x,F4.2,2x,F4.2,2x,E7.0,2x,E7.0)','Input values',tstar,lstar,mdot,vinf,r_t,habund,yabund,cabund,nabund,oabund
  print,''
ENDIF

output_array=strarr(n_elements(diff_tstar_sort)+3)
output_array[0]=string('MODEL',FORMAT='(A-70)')+'  '+string('  T*  ',FORMAT='(A6)')+'  '+string('   L*  ',FORMAT='(A7)')+'  '+string('  Mdot  ',FORMAT='(A8)')+'  '+string('Vinf',FORMAT='(A4)')+'  '+string('  R_t  ',FORMAT='(A7)')+ $
               '  '+string(' X  ' ,FORMAT='(A4)')+'  '+string(' Y  ',FORMAT='(A4)')+'  '+string('   C   ',FORMAT='(A7)')+'  '+string('   N   ',FORMAT='(A7)')+'  '+string('   O   ',FORMAT='(A7)') 
output_array[1]=string(modelid,FORMAT='(A-70)')+'  '+string(tstar,FORMAT='(I6)')+'  '+string(lstar,FORMAT='(I7)')+'  '+string(mdot,FORMAT='(E8.2)')+'  '+string(vinf,FORMAT='(I4)')+'  '+string(r_t,FORMAT='(F7.2)')+$
                '  '+string(habund,FORMAT='(F4.2)')+'  '+string(heabund,FORMAT='(F4.2)')+'  '+string(cabund,FORMAT='(E7.0)')+'  '+string(nabund,FORMAT='(E7.0)')+'  '+string(oabund,FORMAT='(E7.0)')
output_array[2]=''

for i=0, n_elements(diff_tstar_sort) -1 do begin
  IF KEYWORD_SET(print_screen) THEN print,FORMAT='(A-70,2x,I6,2x,I7,2x,E8.2,2x,I4,2x,F7.2)',grid_info_array_sort[i]+xn_array_sort[i],tstar_array_sort[i],lstar_array_sort[i],mdot_array_sort[i],vinf_array_sort[i],r_t_array_sort[i]
  output_array[i+3]=string(grid_info_array_sort[i] +xn_array_sort[i],FORMAT='(A-70)')+'  '+string(tstar_array_sort[i],FORMAT='(I6)')+'  '+string(lstar_array_sort[i],FORMAT='(I7)')+'  '+string(mdot_array_sort[i],FORMAT='(E8.2)')+'  '+$
                  string(vinf_array_sort[i],FORMAT='(I4)')+'  '+string(r_t_array_sort[i],FORMAT='(F7.2)')+'  '+string(habund_array_sort[i],FORMAT='(F4.2)')+'  '+string(heabund_array_sort[i],FORMAT='(F4.2)') $
                  +'  '+string(cabund_array_sort[i],FORMAT='(E7.0)')+'  '+string(nabund_array_sort[i],FORMAT='(E7.0)')+'  '+string(oabund_array_sort[i],FORMAT='(E7.0)')
endfor


;IF KEYWORD_SET(write) THEN WRT_ASCII,nightarray,dir_out+'log_'+night+'.txt'
if n_elements(modelid) LT 1 THEN modelid='input values'
IF KEYWORD_SET(xwidget) THEN XDISPLAYFILE,'',text=output_array,title='Closest models to '+modelid,/grow_to_screen,WIDTH=170


;print,diff_tstar_sort
;print,tstar_ar
END