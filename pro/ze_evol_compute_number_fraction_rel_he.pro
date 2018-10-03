FUNCTION ZE_EVOL_COMPUTE_NUMBER_FRACTION_REL_HE,mass_frac,he_mass_frac,element,numfrac,Hyd=hyd

he_atom_wei=4.002602

CASE element OF
'H': atomwei= 1.008
'He': atomwei=  4.002602
'C':  atomwei=  12.011
'N':  atomwei=14.007
'O':  atomwei=15.999
'Fe': atomwei=55.845
ENDCASE

if KEYWORD_SET(hyD) then he_atom_wei=1.008
numfrac=mass_frac/he_mass_frac/atomwei*he_atom_wei

return,numfrac
;
;At No     Symbol      Name  Atomic Wt Notes
;1 H Hydrogen  1.008 3, 6
;2 He  Helium  4.002602(2) 1, 2
;3 Li  Lithium 6.94  3, 6
;4 Be  Beryllium 9.012182(3)
;5 B Boron 10.81 3, 6
;6 C Carbon  12.011  6
;7 N Nitrogen  14.007  6
;8 O Oxygen  15.999  6
;9 F Fluorine  18.9984032(5)
;10  Ne  Neon  20.1797(6)  1, 3
;11  Na  Sodium  22.98976928(2)    
;12  Mg  Magnesium 24.3050(6)
;13  Al  Aluminium 26.9815386(8)
;14  Si  Silicon 28.085  6
;15  P Phosphorus  30.973762(2)
;16  S Sulfur  32.06 6
;17  Cl  Chlorine  35.45 3, 6
;18  Ar  Argon 39.948(1) 1, 2
;19  K Potassium 39.0983(1)  
;20  Ca  Calcium 40.078(4) 
;21  Sc  Scandium  44.955912(6)
;22  Ti  Titanium  47.867(1)
;23  V Vanadium  50.9415(1)
;24  Cr  Chromium  51.9961(6)
;25  Mn  Manganese 54.938045(5)
;26  Fe  Iron  55.845(2)


END