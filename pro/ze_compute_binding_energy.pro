FUNCTION ZE_COMPUTE_BINDING_ENERGY,r,Mr
;binding enervy following the formula from Dessart et al. 2010, Fig.3
;ebinding=integral(r,rmax){G Mr /r - Eint}dMr
;works well but does not take into account internal energy
G=6.67e-8
Eint=0.
ebinding=G*int_tabulated(r,(Mr/r - Eint),/DOUBLE,SORT=1) ; in cm ^ 2


return,ebinding


END
