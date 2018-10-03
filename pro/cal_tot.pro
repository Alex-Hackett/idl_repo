 PRO cal_tot, Z, Teff, logL, Mass, vinf

; Mass-loss recipe for massive stars including a metallicity dependence.
; Written by Jorick S. Vink
;
;   The IDL routine is based on the following three papers:
;
;   1. "Mass-loss predictions for O and B stars as a function of metallicity"
;       Jorick S. Vink, A. de Koter, and H.J.G.L.M. Lamers, 2001, A&A 369, 574
;
;   2. "New theoretical mass-loss rates of O and B stars"
;       Jorick S. Vink, A. de Koter, and H.J.G.L.M. Lamers, 2000, A&A 362, 295
;
;   3. "On the nature of the bi-stability jump in the winds of early-type supergiants"
;       Jorick S. Vink, A. de Koter, and H.J.G.L.M. Lamers, 1999, A&A 350, 181  
;
; ------------------------------------------------------------
if n_params(0) eq 0 then begin
   print,'cal_tot, Z, Teff, logL, Mass, vinf'
   print,''
   print,'input:'
   print,'   Z         - Metallicity Z compared to the Galactic value of Z=0.02
   print,'               E.g. for Z = 0.002 insert: 0.1 
   print,' '
   print,'   Teff      - effective temperature in Kelvin'
   print,' '   
   print,'   logL      - log of Luminosity (in solar units)'
   print,' '
   print,'   Mass      - Stellar Mass (in solar units)'
   print,' '
   print,'   vinf      - Terminal Velocity (in km/s), if unknown, please insert: -1'
   print,' '
   print,'output:'
   print,' '
   print,'   Mdot      - Predicted mass-loss rate'
   return
endif
;
; ------------------------------------------------------------
;
Msun      = 1.989D33
Lsun      = 3.827D33
pi        = 3.1415
stefb     = 5.670D-5
Grav      = 6.670D-8

Lum       = 10^logL
Mstar     = Mass*Msun
sigmae    = 0.325   
Gamma     = 7.66 * 1.d-5 * sigmae * Lum/Mass 
Meff      = Mass*(1.0 - Gamma) 
Lumi      = Lum*Lsun
Rstar     = sqrt(lumi/(4. * pi * stefb * (Teff^4.)))
vesc      = sqrt(2.0 * Grav * Meff * Msun/Rstar)
vesc      = vesc * 1.d-5
ratio     = vinf/vesc

if (Z le 0) then begin
 print,'Z value needs to be higher than 0!'
 goto, Mistake
endif

logZ      = alog10(Z)
charrho   = -14.94 + (3.1857 * Gamma) + (0.85 * logZ) ; Eq. (23) from Vink et al. (2001) 

Teffjump1 = 61.2 + (2.59 * charrho)                   ; Eq. (15) from Vink et al. (2001)
Teffjump1 = Teffjump1 * 1000.
Teffjump2 = 100. + (6.0 * charrho)                    ; Eq. (6)  from Vink et al. (2000)
Teffjump2 = Teffjump2 * 1000.

if (Teffjump1 le Teffjump2) then begin
  print,'These stellar parameters are unrealistic', $ 
         + 'No Mass loss rate can be provided'
  goto, Mistake
endif

; Which formula to use with respect to the bi-stability jumps ?

if (Teff lt Teffjump1) then begin
  print,'The star is located below the first jump '
  if (Teff lt Teffjump2) then begin 
     print,'The star is located below the second jump '
     if (vinf eq -1) then begin        
        ratio = 0.7            
     endif  
     logMdot = (-5.99) $
                + (2.210 * alog10(Lum/(10^5.)))$
                - (1.339 * alog10(Mass/30.)) $ 
                - (1.601 * alog10(ratio/2.)) $
                + (1.07  * alog10(Teff/20000.)) $
                +  0.85  * logZ
   endif else begin
     print,'The star is located between the two bi-stability jumps'
     if (vinf eq -1) then begin        
        ratio = 1.3                   
     endif  
     logMdot = (-  6.688) $
                + (2.210  * alog10(Lum/(10^5.)))$
                - (1.339  * alog10(Mass/30.)) $ 
                - (1.601  * alog10(ratio/2.)) $
                + (1.07   * alog10(Teff/20000.)) $
                +  0.85   * logZ
   endelse
endif
if (Teff gt Teffjump1) then begin
    print,'The star is located above the first jump '
    if (vinf eq -1) then begin        
        ratio = 2.6                   
    endif 
    logmdot = (-6.697) $ 
               + (2.194 *  alog10(Lum/10^5.)) $
               -  1.313 *  alog10(Mass/30.) $
               - (1.226 *  alog10(ratio/2.)) $
               +  0.933 *  alog10(Teff/40000.) $
               - (10.92 * (alog10(Teff/40000.)^2.)) $
               +  0.85  *  logZ
endif

if (Teff eq Teffjump1) then begin
    print,'The star is AT the first jump '
    print,'No Mass-loss rate can be provided'
    logmdot = 9.999
endif
if (Teff eq Teffjump2) then begin
    print,'The star is AT the second jump '
    print,'No Mass-loss rate can be provided'
    logmdot = 9.999
endif
print,'The predicted mass loss rate is: log(Mdot) = ',logMdot

Mistake:
return
End


