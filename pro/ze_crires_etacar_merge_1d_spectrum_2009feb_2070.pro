PRO ZE_CRIRES_ETACAR_MERGE_1D_SPECTRUM_2009FEB_2070
Angstrom = '!6!sA!r!u!9 %!6!n'
C=299792.458
LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

ZE_CRIRES_SPEC_COMBINE_V2, '2009feb_2070_1','2009feb_2076_1',l1,spec1
ZE_CRIRES_SPEC_COMBINE_V2, '2009feb_2070_2','2009feb_2076_2',l2,spec2
ZE_CRIRES_SPEC_COMBINE_V2, '2009feb_2070_3','2009feb_2076_3',l3,spec3
ZE_CRIRES_SPEC_COMBINE_V2, '2009feb_2070_4','2009feb_2076_4',l4,spec4

ZE_1DSPEC_COMBINE_V2, l1,spec1,l2,spec2,lambdacomb_1dspc=l12comb,fluxcomb_1dspc=spec12comb
ZE_1DSPEC_COMBINE_V2, l3,spec3,l4,spec4,lambdacomb_1dspc=l34comb,fluxcomb_1dspc=spec34comb

ZE_1DSPEC_COMBINE_V2, l12comb,spec12comb,l34comb,spec34comb,lambdacomb_1dspc=lall,fluxcomb_1dspc=fall
lalljan=lall
falljan=fall
save,/variables,FILENAME='/Users/jgroh/espectros/etc_2070_spec_onstar_feb09.sav'
restore,'/Users/jgroh/espectros/etc_2070_spec_onstar_feb09.sav'

END