PRO ZE_CRIRES_SPEC_COMBINE, gratdet1,gratdet2,lambdacomb,fluxcomb

Angstrom = '!6!sA!r!u!9 %!6!n'
C=299792.458
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!P.THICK=0
!X.THICK=0
!Y.THICK=0
!P.MULTI=0

saved_file='/Users/jgroh/espectros/etc_'+gratdet1+'_allvar.sav'
restore,saved_file
print,'File restored: ',saved_file

l1c=lambda_newcal_vac_hel[*,row]
f1c=spec_ext

undefine,lambda_newcal_vac_hel,spec_ext
saved_file='/Users/jgroh/espectros/etc_'+gratdet2+'_allvar.sav'
restore,saved_file
print,'File restored: ',saved_file

l2c=lambda_newcal_vac_hel[*,row]
f2c=spec_ext

sizelam1=n_elements(l1c)
sizelam2=n_elements(l2c)
index1=1.*indgen(n_elements(l1c))
index2=1.*indgen(n_elements(l2c))

print,sizelam1,sizelam2
ZE_SELECT_NORM_SECTION_V2,index1,f1c,norm_sect=norm_sect1
norm_line_val1=(MOMENT(f1c[norm_sect1[0]:norm_sect1[1]]))[0]

ZE_SELECT_NORM_SECTION_V2,index2,f2c,norm_sect=norm_sect2
norm_line_val2=(MOMENT(f2c[norm_sect2[0]:norm_sect2[1]]))[0]

;scale spec 2 to macht spec 1 
f2scl=f2c*norm_line_val1/norm_line_val2

lmerge=dblarr(sizelam1,2)
fmerge=dblarr(sizelam1,2)

lmerge[*,0]=l1c
lmerge[*,1]=l2c

fmerge[*,0]=f1c
fmerge[*,1]=f2scl

hrs_merge,lmerge,fmerge,0,0,lambdacomb,fluxcomb

END