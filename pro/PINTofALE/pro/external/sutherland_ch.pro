;+
;
; PROJECT:  CHIANTI
;
;       CHIANTI is an Atomic Database Package for Spectroscopic Diagnostics of
;       Astrophysical Plasmas. It is a collaborative project involving the Naval
;       Research Laboratory (USA), the University of Florence (Italy), the
;       University of Cambridge and the Rutherford Appleton Laboratory (UK). 
;
; NAME:
;	SUTHERLAND_CH
;
; PURPOSE:
;
;	Calculate the free-free continuum from an hot, low density plasma
;
;       Uses the free-free gaunt factor calculations of Sutherland, 1998, 
;       MNRAS, 300, 321.
;
;       Note that Sutherland's Eq.(15) has units of erg/cm^3/s. Comparing 
;       with Rybicki & Lightman's Eq.5.14(a) (in their book 'Radiative 
;       Processes in Astrophysics'), suggests that Sutherland's units 
;       should be erg/cm^3/s/sr/Hz. We are assuming the latter to be 
;       correct in this routine.
;
;       When using the DEM_INT optional input, FREEFREE expects the 
;       differential emission measure to have been derived from a product 
;       of N_e*N_H rather than N_e*N_e. This can be important when dealing 
;       with a regime (typically T < 10^4.5) where H and He are not fully 
;       ionised.
;
; CALLING SEQUENCE:
;
;       SUTHERLAND_CH,temperature, wavelength, intensity
;
;
; INPUTS:
;
;	T	   Temperature in degrees Kelvin, can be a 1 D array
;       WVL        Wavelength in Angstroms
;
;
; OPTIONAL INPUTS:
;
;	None
;	
; KEYWORD PARAMETERS:
;
;	NO_SETUP:  If the procedure setup_elements has already been called 
;                  then the keyword /no_setup should be set to avoid 
;                  repeating this step.
;
;       MIN_ABUND: If set, calculates the continuum only from those 
;                  elements which have an abundance greater than min_abund.  
;                  This can speed up the calculations. ;
;
;	DEM_INT    The intensity array is multiplied by a DEM number for 
;                  each temperature. DEM_INT needs to be of the same size 
;                  as TEMPERATURE. It is needed for the synthetic spectrum 
;                  routines.
;
;       PHOTONS    The output spectrum is given in photon units rather 
;                  than ergs.
;
;       SUMT       The default is to output the intensity array as an array 
;                  of size (nwvl x nT). Setting this keyword performs a sum 
;                  over the temperatures to yield a vector of same size as 
;                  the input wavelengths, thus producing the complete 
;                  free-free spectrum.
;	
; OUTPUTS:
;
;	RAD        Free-free continuum intensity in units
;                  10^-40 erg cm^3 s^-1 str^-1 angstrom^-1 per unit 
;                  emission measure [ integral (N_e N_H dh) in cm^-5 ]. 
;                  If T is given as a 1-D array, then RAD will be output 
;                  as a 2-D array, with one element for each temperature 
;                  and wavelength (but also see SUMT).
;
;
; PROGRAMMING NOTES
;
;     The gaunt factors from Sutherland (MNRAS 300, 321, 1998) are a 
;     function of uu and gg (see his Eq. 14). uu is a function of both 
;     wavelength and T, while gg is a function of T only.
;
;     The gaunt factor (gff) is tabulated for values of uu and gg at 
;     fixed intervals in log(uu) and log(gg). The log(uu) values go from 
;     -4 to 4 in 0.2 steps; the log(gg) values go from -4 to 4 in 0.1 steps.
;
;     A particular (input) temperature and wavelength give rise to values 
;     uu0 and gg0, the logs of which lie between -4 and 4. To derive the 
;     corresponding gff0 value, I use the IDL routine BILINEAR. 
;
;     BILINEAR requires, not uu and gg values as input, but indices. 
;     E.g., the indices corresponding to the tabulated values of uu are 
;     0 (=-4.0), 1 (=-3.8), 2 (=-3.6), etc. Thus, if log(uu0)=-3.76, then 
;     i_uu0=1.20 is the index of uu0.
;
;     In order to make significant time-savings, I give BILINEAR all of 
;     the wavelengths and temperatures in the same call for a particular 
;     ion. To do this, I make my i_uu and i_gg values 2-D arrays of size 
;     (nwvl x nT), and BILINEAR then produces a (nwvl x nT) array 
;     containing the gff values.
;
;     A problem occurred if nT=1, as BILINEAR will turn the input uu and 
;     gg vectors into 2-D arrays of size (nwvl x nwvl). If there are a 
;     large number of wavelengths, this uses a lot of memory. To solve 
;     this I make a 2 element temperature vector whose values are 
;     identical, and then change this back to a 1 element vector after 
;     BILINEAR has been called. See the parts of the code where I use 
;     'tst1'.
;
;
; COMMON BLOCKS:
;
;	common elements,abund,abund_ref,ioneq,ioneq_t,ioneq_ref
;
; CALLS
;
;       READ_IP, READ_GFFGU, SETUP_ELEMENTS
;
; EXAMPLES:
;
;       IDL> freefree,1.e+6,wvl,int
;       IDL> freefree,1.e+6,wvl,int,min_abund=3.e-5
;       IDL> freefree,1.e+6,wvl,int,/no_setup,min_abund=1.e-6
;
;       IDL> wvl=findgen(5001)/10. + 50.
;       IDL> temp=10.^(findgen(41)/10. +4.)
;       IDL> freefree,temp,wvl,int
;
;
; MODIFICATION HISTORY:
; 	Written by:	Ken Dere
;	March 1999:     Version 2.0
;       September 1999:  Version 3.0
;
;       Ver.3.1, 11-Aug-00, Peter Young
;           Improved call to bilinear, allowing routine to solve for 
;           all temperatures in one go. This makes the routine quicker, 
;           and also lowers the memory usage of the routine when dealing 
;           with many wavelengths.
;
;       Ver.3.2, 16-Aug-00, Peter Young
;           Corrected expression for 'gg', replacing ip with z^2.
;
;       Ver.3.3, 16-Oct-00, Peter Young
;           Now deals with dem_int correctly
;
;       Ver.3.4, 10-Oct-01, Ken Dere
;           Corrected for labelling errors in Sutherland's gffgu.dat file
;           No longer reads ionization potential file
;
;       Ver.3.5, 5-Dec-01, Peter Young
;           Corrected expression for gamma^2
;           Renamed routine sutherland.pro
;           Restructured code to make it run quicker.
;
;       Ver.3.6, 22-May-01, Peter Young
;           Re-instated the MIN_ABUND optional input. 
;           Changed ioneq_t to ioneq_logt (GDZ).
;
;       Ver.3.7, 18-Aug-03, Peter Young
;           Activated /PHOTONS keyword
;
;       Ver.3.8, 5-Nov-03, Peter Young
;           Corrected bug found by Jim McTiernan when multiple temperatures
;           were input. The quantity 'newfactor' was not being calculated
;           correctly due to indexing problems.
;       Ver.Poa, 18-Nov-2005, LiWei Lin 
;           Commented out common block
;           Added keywords,abund, ioneq, ieq_logt, _extra
;           Changed ioneq_logt to ieq_logt
;           Renamed routine sutherland_ch
;-


pro sutherland_ch,t,wvl,rad,no_setup=no_setup,min_abund=min_abund, $
       dem_int=dem_int, photons=photons, sumT=sumT,abund=abund, $ 
       ioneq=ioneq,ieq_logt=ieq_logt,_extra=e

;COMMON elements,abund,abund_ref,ioneq,ioneq_logt,ioneq_ref
;
;
if n_params(0) lt 3 then begin
  print,'   IDL> freefree,temperature,wavelength,intensity  [,/no_setup, min_abund=3.e-5]'
  print,'     use /no_setup when freefree is called inside a self-consistent program'
  print,'     continuum calculations are fairly slow, setting higher min_abund values can help'
  print,'  Allen abundances for some elements'
  print,'     abund(H)  = 1.'
  print,'     abund(He) = 8.5e-2'
  print,'     abund(C)  = 3.3e-4'
  print,'     abund(Si) = 3.3e-5'
  print,'     abund(Fe) = 4.0e-5'
  return
endif


kb=1.38062d-16   ; erg/K
h=6.6262d-27     ; erg s
c=2.997925d+10   ; cm/s
ryd=2.17992d-11  ; erg
factor=5.44436d-39  ; this is f_k of Eq.15 of Sutherland
rescale=1.d+40
;
if not keyword_set(no_setup) then setup_elements

zmax=max(where(abund gt 0.))+1

IF n_elements(min_abund) EQ 0 THEN min_abund=0.

n_ioneq_logt=n_elements(ieq_logt)
dlnt=alog(10.^(ieq_logt(1)-ieq_logt(0)))
;
;  read free-free gaunt factors
;
read_gffgu,g2,u,gff
;

t = double(t)
wvl = double(wvl)

;
; If t and wvl only have 1 element, then need to convert them to arrays
;
IF n_elements(wvl) EQ 1 THEN wvl = [wvl]
IF n_elements(t) EQ 1 THEN t = [t]

nwvl=n_elements(wvl)
nt=n_elements(t)

IF keyword_set(photons) THEN BEGIN
  erg2phot=( wvl # (dblarr(nt) + 1.) ) / 1.9864d-8
ENDIF ELSE BEGIN
  erg2phot= (dblarr(nwvl) + 1. ) # (dblarr(nt) + 1.)
ENDELSE

ident_t = make_array(max([nt,2]),val=1.,/double)
ident_wvl = make_array(nwvl,val=1.,/double)

;
; the isothermal here refers to the keyword used in the routine ch_synthetic
; when it is set, no DEM distribution is read in, and the so the 'demfactor' 
; is not used (see later)
;
IF n_elements(dem_int) EQ 0 THEN BEGIN
   dem_int = make_array(max([nt,2]),val=1.) 
   demfactor = make_array(max([nt,2]),val=1.) 
   isothermal = 1
   tst_dem=1
ENDIF ELSE BEGIN
   dem_int = double(dem_int)
   demfactor=t*0.1/alog10(exp(1))
   isothermal = 0
   tst_dem=0
ENDELSE



IF nt EQ 1 THEN rad = dblarr(nwvl,2) ELSE rad=dblarr(nwvl,nt)

IF n_elements(t) EQ 1 THEN temp=[t,t] ELSE temp=t

uu = h*c*1.d8/kb*(1/wvl)#(1/temp)
i_uu = (ALOG10(uu)+4.d)*10.d

elt_i=where(abund[0:zmax-1] GE min_abund)
nei=n_elements(elt_i)

FOR z=1,30 DO BEGIN
  gg = z^2*ryd/kb* ident_wvl #(1/temp)
  i_gg = (ALOG10(gg)+4.d)*5.d
  big = bilinear(gff,i_gg,i_uu)
  newbig=big*exp(-uu)*z^2*( (1/wvl^2)#ident_t )

  FOR iz=0,nei-1 DO BEGIN
    this_abund=abund[elt_i[iz]]
    this_ioneq=ioneq(*,elt_i[iz],z)
    ti=where(this_ioneq NE 0.)
    IF ti[0] NE -1 THEN BEGIN
      ind=where( (alog10(temp) LE max(ieq_logt[ti])) AND $ 
                 (alog10(temp) GE min(ieq_logt[ti])) )
      IF ind[0] NE -1 THEN BEGIN
        yy=alog10(this_ioneq[ti])
        xx=ieq_logt[ti]
        xi=alog10(temp[ind])
        y2=spl_init(xx,yy)
        yi=10.^spl_interp(xx,yy,y2,xi)

        newfactor=this_abund*yi*factor*c*1d8*rescale/sqrt(temp[ind])* $
             dem_int[ind] * demfactor[ind]

        rad[*,ind]=rad[*,ind]+(ident_wvl#newfactor)*newbig[*,ind]* $
             erg2phot[*,ind]
      ENDIF
    ENDIF
  ENDFOR
ENDFOR

IF n_elements(t) EQ 1 THEN BEGIN
  rad=rad[*,0]
ENDIF ELSE BEGIN
  IF keyword_set(sumt) THEN rad=total(rad,2)
ENDELSE


END
