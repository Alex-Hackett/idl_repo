
PRO itoh_ch, temp, wvl, int, no_setup=no_setup, sumt=sumt, dem_int=dem_int, $
          photons=photons, min_abund=min_abund, abund=abund, $ 
          ioneq=ioneq,ieq_logt=ieq_logt,_extra=e

;+
; PROJECT:  CHIANTI
;
;       CHIANTI is an Atomic Database Package for Spectroscopic Diagnostics of
;       Astrophysical Plasmas. It is a collaborative project involving the Naval
;       Research Laboratory (USA), the University of Florence (Italy), the
;       University of Cambridge and the Rutherford Appleton Laboratory (UK). 
;
; NAME
;
;    ITOH_CH
;
; EXPLANATION
;
;    Calculates the relativistic free-free continuum using the fitting 
;    formula of Itoh et al. (ApJS 128, 125, 2000).
;
; INPUTS
;
;    TEMP    Temperature (in K).
;
;    WVL     Wavelengths in angstroms. Can be a scalar or vector.
;
; OUTPUTS
;
;    INT     Free-free continuum emissivity in units of 
;            10^-40 erg cm^3 / s / sr / Angstrom per unit emission 
;            measure [ integral(N_e N_H dh) in cm^-5 ]. If T is given as 
;            a 1-D array, then RAD will be output as a 2-D array, 
;            with one element for each temperature and wavelength 
;            (but also see SUMT).
;
; OPTIONAL INPUTS
;
;    DEM_INT An array of same length as TEMP which contains the 
;            differential emission measure values at each temperature. 
;            The emissivity at each temperature is multiplied by the 
;            DEM value and the d(logT) value.
;
;    MIN_ABUND This keyword allows the specification of a minimum abundance, 
;              such that any elements with an abundance (relative to 
;              hydrogen) less than MIN_ABUND will not be included in the 
;              calculation. E.g., MIN_ABUND=1e-5.
;
; KEYWORDS
;
;    NO_SETUP By default the routine asks the user which ion balance 
;             and abundance files to use via pop-up widgets. If 
;             /no_setup is used then this data is taken from the common 
;             block.
;
;    SUMT     The default is to output the intensity array as an array 
;             of size (nwvl x nT). Setting this keyword performs a sum 
;             over the temperatures to yield a vector of same size as 
;             the input wavelengths, thus producing the complete 
;             free-free spectrum.
;
;    PHOTONS  Gives output emissivity in photon units rather than ergs.
;
; CALLS
;
;    Chianti:  SETUP_ELEMENTS
;
; PROGRAMMING NOTES
;
;    In the Itoh et al. paper they state that their fitting formula is 
;    valid for ion charges (Z_j) of 1-28. The data-file they provide 
;    actually goes up to Z_j=30, and so you will see that the loop over 
;    z (see below) goes up to 30.
;
;    There is no restriction on the elements for which the fitting 
;    formula is valid, and so all elements are allowed to be included 
;    (subject to their abundances being non-zero).
;
; HISTORY
;
;    Ver.1, 3-Dec-2001, Peter Young
;
;    Ver.2, 22-May-2002, Peter Young
;            Added MIN_ABUND optional input.
;
;    Ver.3, 28-May-2002, Peter Young
;            Corrected way in which DEM is handled.
;    ver.PoA 18-Feb-2005, LiWei Lin 
;            Commented out common block 
;            Added abund, ioneq, ioneq_logt keywords
;            Replaced variable ioneq_t with ieq_logt, _extra             
;            Renamed routine itoh_ch
;-

;COMMON elements,abund,abund_ref,ioneq,ioneq_t,ioneq_ref

temp=double(temp)
wvl=double(wvl)

nt=n_elements(temp)
nw=n_elements(wvl)

cc=2.997825d18    ; ang/s
hkt=4.1356692d-15 / 8.61735d-5 / temp

dem_tst=0
IF n_elements(dem_int) NE 0 THEN BEGIN
  IF n_elements(dem_int) NE nt THEN BEGIN
    print,'%ITOH_CH: Warning, number of elements of DEM_INT must match the'
    print,'  number of temperatures. DEM_INT will not be included.'
    dem_arr=(dblarr(nt) + 1.) # (dblarr(nw) + 1. )
  ENDIF ELSE BEGIN
;    IF nt EQ 1 THEN demfactor=1d0 ELSE demfactor=temp*0.1/alog10(exp(1))
    demfactor=temp*0.1/alog10(exp(1))
    dem_arr= (dem_int*demfactor) # (dblarr(nw) + 1. )
  ENDELSE
ENDIF ELSE BEGIN
  dem_tst=1
  dem_arr=(dblarr(nt) + 1.) # (dblarr(nw) + 1. )
ENDELSE


;
; chk is used to flag locations where the temperature and wavelength 
; are outside of the range of validity of the Itoh fitting formula
;
chk=bytarr(n_elements(temp),nw)

t=(alog10(temp)-7.25)/1.25d0 # (dblarr(nw) +1.)
ind=where( (t LT -1.0) OR (t GT 1.0) )
IF ind[0] NE -1 THEN chk[ind]=1

little_u=hkt # (cc/wvl)
u=(alog10(little_u)+1.5)/2.5d0    ; this is the big-U of Itoh et al.
ind=where( (u LT -1.0) OR (u GT 1.0) )
IF ind[0] NE -1 THEN chk[ind]=1

IF keyword_set(photons) THEN BEGIN
  erg2phot=( (dblarr(nt) + 1.) # wvl ) / 1.9864d-8
ENDIF ELSE BEGIN
  erg2phot=(dblarr(nt) + 1.) # (dblarr(nw) + 1. )
ENDELSE

hkt=hkt # (dblarr(nw) +1.)

IF NOT keyword_set(no_setup) THEN setup_elements

openr,lun,!xuvtop+'/continuum/itoh.dat',/get_lun
data=dblarr(121,30)    ; 30 is the number of elements (H to Zn)
readf,lun,data
free_lun,lun

int=dblarr(nt,nw)

zmax=max(where(abund gt 0.))+1
;
IF n_elements(min_abund) EQ 0. THEN min_abund=0.
elt_i=where(abund[0:zmax-1] GE min_abund)
nei=n_elements(elt_i)

FOR z=1,30 DO BEGIN
  a=data[*,z-1]
  a=[0d0,a]
  gf= A(1) +A(2)*U +A(3)*U^2 +A(4)*U^3 +A(5)*U^4  $
       +A(6)*U^5+A(7)*U^6 +A(8)*U^7 +A(9)*U^8   $
       +A(10)*U^9 +A(11)*U^10   $
       +( A(12)+A(13)*U+A(14)*U^2+A(15)*U^3+A(16)*U^4  $
          +A(17)*U^5+A(18)*U^6+A(19)*U^7 +A(20)*U^8   $
          +A(21)*U^9 +A(22)*U^10 )*T  $
       +( A(23)+A(24)*U+A(25)*U^2+A(26)*U^3+A(27)*U^4   $
          +A(28)*U^5+A(29)*U^6+A(30)*U^7 +A(31)*U^8   $
          +A(32)*U^9 +A(33)*U^10 )*T^2  $
       +( A(34)+A(35)*U+A(36)*U^2+A(37)*U^3+A(38)*U^4  $
          +A(39)*U^5+A(40)*U^6+A(41)*U^7 +A(42)*U^8   $
          +A(43)*U^9 +A(44)*U^10 )*T^3  $
       +( A(45)+A(46)*U+A(47)*U^2+A(48)*U^3+A(49)*U^4  $
          +A(50)*U^5+A(51)*U^6+A(52)*U^7 +A(53)*U^8   $
          +A(54)*U^9 +A(55)*U^10 )*T^4  $
       +( A(56)+A(57)*U+A(58)*U^2+A(59)*U^3+A(60)*U^4  $
          +A(61)*U^5+A(62)*U^6+A(63)*U^7 +A(64)*U^8   $
          +A(65)*U^9 +A(66)*U^10 )*T^5  $
       +( A(67)+A(68)*U+A(69)*U^2+A(70)*U^3+A(71)*U^4  $
          +A(72)*U^5+A(73)*U^6+A(74)*U^7 +A(75)*U^8   $
          +A(76)*U^9 +A(77)*U^10 )*T^6  $
       +( A(78)+A(79)*U+A(80)*U^2+A(81)*U^3+A(82)*U^4  $
          +A(83)*U^5+A(84)*U^6+A(85)*U^7 +A(86)*U^8   $
          +A(87)*U^9 +A(88)*U^10 )*T^7  $
       +( A(89)+A(90)*U+A(91)*U^2+A(92)*U^3+A(93)*U^4  $
          +A(94)*U^5+A(95)*U^6+A(96)*U^7 +A(97)*U^8   $
          +A(98)*U^9 +A(99)*U^10 )*T^8  $
       +( A(100)+A(101)*U+A(102)*U^2+A(103)*U^3+A(104)*U^4  $
          +A(105)*U^5+A(106)*U^6+A(107)*U^7+A(108)*U^8  $
          +A(109)*U^9+A(110)*U^10)*T^9  $
       +( A(111)+A(112)*U+A(113)*U^2+A(114)*U^3+A(115)*U^4  $
          +A(116)*U^5+A(117)*U^6+A(118)*U^7+A(119)*U^8  $
          +A(120)*U^9+A(121)*U^10)*T^10

  FOR j=0,nei-1 DO BEGIN

    ii=ioneq[*,elt_i[j],z]

    ti=where(ii NE 0.)

    IF ti[0] NE -1 THEN BEGIN

      ind=where( (alog10(temp) LE max(ieq_logt[ti])) AND $ 
                 (alog10(temp) GE min(ieq_logt[ti])) )

      IF ind[0] NE -1 THEN BEGIN
        yy=ii[ti]
        xx=ieq_logt[ti]
        xi=alog10(temp[ind])
        y2=spl_init(xx,yy)
        yi=spl_interp(xx,yy,y2,xi)
        
        contrib=gf[ind,*]*z^2*1.426d-27*abund[elt_i[j]]* $
             (yi # (dblarr(nw) + 1.)) * $
             (sqrt(temp[ind]) # (dblarr(nw) + 1.)) * $
             exp(-little_u[ind,*])*hkt[ind,*]*cc/ $
             ((dblarr(n_elements(yi)) + 1.) # wvl)^2 * $
             erg2phot[ind,*] * dem_arr[ind,*]

        int[ind,*]=int[ind,*]+contrib

      ENDIF

    ENDIF

  ENDFOR
ENDFOR

ind=where(chk NE 0)
IF ind[0] NE -1 THEN int[ind]=0d0

int=transpose(int)*1d40/4d0/!pi

siz=size(int)

IF keyword_set(sumt) AND (siz[0] GT 1) THEN int=total(int,2)

IF dem_tst EQ 1 THEN junk=temporary(dem_tst)

END
