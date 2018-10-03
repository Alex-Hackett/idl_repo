Angstrom = '!6!sA!r!u!9 %!6!n'
C=299792.458
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

restore,'/Users/jgroh/espectros/etc_10830_spec_onstar_jan09_feb09.sav'

grat_angle=1087
det=2
lambda0=1.08333
gratdet=strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))

saved_file='/Users/jgroh/espectros/etc_'+gratdet+'_allvar.sav'
restore,saved_file

l09jan_1087_2=lambda_newcal_vac_hel[*,row]
v09jan_hel_1087_2=ZE_LAMBDA_TO_VEL(lambda_newcal_vac_hel[*,row],lambda0*10^4)
f09jan_onstar_1087_2=spec_ext

grat_angle=1090
det=2
lambda0=1.08333
gratdet=strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))

saved_file='/Users/jgroh/espectros/etc_'+gratdet+'_allvar.sav'
restore,saved_file

l09jan_1090_2=lambda_newcal_vac_hel[*,row]
v09jan_hel_1090_2=ZE_LAMBDA_TO_VEL(lambda_newcal_vac_hel[*,row],lambda0*10^4)
f09jan_onstar_1090_2=spec_ext

grat_angle=1090
det=1
lambda0=1.08333
gratdet=strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))

saved_file='/Users/jgroh/espectros/etc_'+gratdet+'_allvar.sav'
restore,saved_file

l09jan_1090_1=lambda_newcal_vac_hel[*,row]
v09jan_hel_1090_1=ZE_LAMBDA_TO_VEL(lambda_newcal_vac_hel[*,row],lambda0*10^4)
f09jan_onstar_1090_1=spec_ext

;*******************************************************************************************

grat_angle=1087
det=2
lambda0=1.08333
gratdet='2009feb09_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))

saved_file='/Users/jgroh/espectros/etc_'+gratdet+'_allvar.sav'
restore,saved_file

l09feb_1087_2=lambda_newcal_vac_hel[*,row]
v09feb_hel_1087_2=ZE_LAMBDA_TO_VEL(lambda_newcal_vac_hel[*,row],lambda0*10^4)
f09feb_onstar_1087_2=spec_ext

grat_angle=1090
det=2
lambda0=1.08333
gratdet='2009feb09_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))

saved_file='/Users/jgroh/espectros/etc_'+gratdet+'_allvar.sav'
restore,saved_file

l09feb_1090_2=lambda_newcal_vac_hel[*,row]
v09feb_hel_1090_2=ZE_LAMBDA_TO_VEL(lambda_newcal_vac_hel[*,row],lambda0*10^4)
f09feb_onstar_1090_2=spec_ext

grat_angle=1090
det=1
lambda0=1.08333
gratdet='2009feb09_'+strcompress(string(grat_angle, format='(I04)'))+'_'+strcompress(string(det, format='(I01)'))

saved_file='/Users/jgroh/espectros/etc_'+gratdet+'_allvar.sav'
restore,saved_file

l09feb_1090_1=lambda_newcal_vac_hel[*,row]
v09feb_hel_1090_1=ZE_LAMBDA_TO_VEL(lambda_newcal_vac_hel[*,row],lambda0*10^4)
f09feb_onstar_1090_1=spec_ext

window,1
plot,v09jan_hel_1090_1,f09jan_onstar_1090_1,xstyle=1,ystyle=1,xrange=[-2900,1300],yrange=[0,4000],/nodata
plots,v09jan_hel_1087_2,f09jan_onstar_1087_2,color=fsc_color('black')
plots,v09jan_hel_1090_1,f09jan_onstar_1090_1,color=fsc_color('red')
plots,v09jan_hel_1090_2,f09jan_onstar_1090_2,color=fsc_color('blue')

index=1.*indgen(n_elements(v09jan_hel_1087_2))

;ZE_SELECT_NORM_SECTION_V2,index,f09jan_onstar_1087_2,norm_sect=norm_sect_09jan_1087_2a
norm_line_val_1087_2a=(MOMENT(f09jan_onstar_1087_2[norm_sect_09jan_1087_2a[0]:norm_sect_09jan_1087_2a[1]]))[0]
;ZE_SELECT_NORM_SECTION_V2,index,f09jan_onstar_1090_1,norm_sect=norm_sect_09jan_1090_1
norm_line_val_1090_1=(MOMENT(f09jan_onstar_1090_1[norm_sect_09jan_1090_1[0]:norm_sect_09jan_1090_1[1]]))[0]

;scale detector 1090_1 to match detector 1087_2
f09jan_onstar_1090_1_scl=f09jan_onstar_1090_1*norm_line_val_1087_2a/norm_line_val_1090_1

;ZE_SELECT_NORM_SECTION_V2,index,f09jan_onstar_1087_2,norm_sect=norm_sect_09jan_1087_2b
norm_line_val_1087_2b=(MOMENT(f09jan_onstar_1087_2[norm_sect_09jan_1087_2b[0]:norm_sect_09jan_1087_2b[1]]))[0]
;ZE_SELECT_NORM_SECTION_V2,index,f09jan_onstar_1090_2,norm_sect=norm_sect_09jan_1090_2
norm_line_val_1090_2=(MOMENT(f09jan_onstar_1090_2[norm_sect_09jan_1090_2[0]:norm_sect_09jan_1090_2[1]]))[0]

;scale detector 1090_2 to match detector 1087_2
f09jan_onstar_1090_2_scl=f09jan_onstar_1090_2*norm_line_val_1087_2b/norm_line_val_1090_2

window,2
plot,v09jan_hel_1090_1,f09jan_onstar_1090_1_scl,xstyle=1,ystyle=1,xrange=[-2900,1300],yrange=[0,4000],/nodata
plots,v09jan_hel_1087_2,f09jan_onstar_1087_2,color=fsc_color('black')
plots,v09jan_hel_1090_1,f09jan_onstar_1090_1_scl,color=fsc_color('red')
plots,v09jan_hel_1090_2,f09jan_onstar_1090_2_scl,color=fsc_color('blue')

;****************************************************************************************
window,3
plot,v09feb_hel_1090_1,f09feb_onstar_1090_1,xstyle=1,ystyle=1,xrange=[-2900,1300],yrange=[0,4000],/nodata
plots,v09feb_hel_1087_2,f09feb_onstar_1087_2,color=fsc_color('black')
plots,v09feb_hel_1090_1,f09feb_onstar_1090_1,color=fsc_color('red')
plots,v09feb_hel_1090_2,f09feb_onstar_1090_2,color=fsc_color('blue')

index=1.*indgen(n_elements(v09feb_hel_1087_2))

;ZE_SELECT_NORM_SECTION_V2,index,f09feb_onstar_1087_2,norm_sect=norm_sect_09feb_1087_2a
norm_line_val_1087_2a=(MOMENT(f09feb_onstar_1087_2[norm_sect_09feb_1087_2a[0]:norm_sect_09feb_1087_2a[1]]))[0]
;ZE_SELECT_NORM_SECTION_V2,index,f09feb_onstar_1090_1,norm_sect=norm_sect_09feb_1090_1
norm_line_val_1090_1=(MOMENT(f09feb_onstar_1090_1[norm_sect_09feb_1090_1[0]:norm_sect_09feb_1090_1[1]]))[0]

;scale detector 1090_1 to match detector 1087_2
f09feb_onstar_1090_1_scl=f09feb_onstar_1090_1*norm_line_val_1087_2a/norm_line_val_1090_1

;ZE_SELECT_NORM_SECTION_V2,index,f09feb_onstar_1087_2,norm_sect=norm_sect_09feb_1087_2b
norm_line_val_1087_2b=(MOMENT(f09feb_onstar_1087_2[norm_sect_09feb_1087_2b[0]:norm_sect_09feb_1087_2b[1]]))[0]
;ZE_SELECT_NORM_SECTION_V2,index,f09feb_onstar_1090_2,norm_sect=norm_sect_09feb_1090_2
norm_line_val_1090_2=(MOMENT(f09feb_onstar_1090_2[norm_sect_09feb_1090_2[0]:norm_sect_09feb_1090_2[1]]))[0]

;scale detector 1090_2 to match detector 1087_2
f09feb_onstar_1090_2_scl=f09feb_onstar_1090_2*norm_line_val_1087_2b/norm_line_val_1090_2

window,4
plot,v09feb_hel_1090_1,f09feb_onstar_1090_1_scl,xstyle=1,ystyle=1,xrange=[-2900,1300],yrange=[0,4000],/nodata
plots,v09feb_hel_1087_2,f09feb_onstar_1087_2,color=fsc_color('black')
plots,v09feb_hel_1090_1,f09feb_onstar_1090_1_scl,color=fsc_color('red')
plots,v09feb_hel_1090_2,f09feb_onstar_1090_2_scl,color=fsc_color('blue')



l_vector_09jan=dblarr(981,3)
f_vector_09jan=dblarr(981,3)

l_vector_09jan[*,0]=l09jan_1090_1
l_vector_09jan[*,1]=l09jan_1087_2
l_vector_09jan[*,2]=l09jan_1090_2

f_vector_09jan[*,0]=f09jan_onstar_1090_1_scl
f_vector_09jan[*,1]=f09jan_onstar_1087_2
f_vector_09jan[*,2]=f09jan_onstar_1090_2_scl

l_vector_09feb=dblarr(981,3)
f_vector_09feb=dblarr(981,3)

l_vector_09feb[*,0]=l09feb_1090_1
l_vector_09feb[*,1]=l09feb_1087_2
l_vector_09feb[*,2]=l09feb_1090_2

f_vector_09feb[*,0]=f09feb_onstar_1090_1_scl
f_vector_09feb[*,1]=f09feb_onstar_1087_2
f_vector_09feb[*,2]=f09feb_onstar_1090_2_scl

hrs_merge,l_vector_09feb,f_vector_09feb,0,0,l09feball,f09feball
hrs_merge,l_vector_09jan,f_vector_09jan,0,0,l09janall,f09janall

v09feball=ZE_LAMBDA_TO_VEL(l09feball,lambda0*10^4)

v09janall=ZE_LAMBDA_TO_VEL(l09janall,lambda0*10^4)

;save,/variables,FILENAME='/Users/jgroh/espectros/etc_10830_spec_onstar_jan09_feb09.sav'
END