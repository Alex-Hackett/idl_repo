;+
; Project     : CHIANTI
;
;       CHIANTI is an atomic database package for the calculation of
;       continuum and emission line spectra from astrophysical plasmas. It is a 
;       collaborative project involving the Naval Research Laboratory
;       (Washington DC, USA), the Arcetri Observatory (Firenze, Italy), and the
;       Cambridge University (United Kingdom).
; 
;                   
; Name        : USE_CHIANTI
;               
; Purpose     : Sets up system variables for use of CHIANTI routines
;               
; Explanation : The  CHIANTI software uses system variables
;               that have to be defined. This routine is called by the 
;               CHIANTI routines if these system variables are not defined.
;
;               ** If one is using the solar-soft package, these should 
;               already be defined*****.
;
;               ** If the CHIANTI package is used as stand-alone, then 
;               this routine can be used for the setup with e.g.:
;
;               use_chianti,'/home/data/chianti/'
;
;               if /home/data/chianti/ points to the actual place where 
;               the CHIANTI top directory is.
;
;               
; Use         : IDL> use_chianti, '/home/data/chianti/', $
;                                 [ioneq= , abund=]
;    
; Inputs      : None
;               
; Opt. Inputs : The full pathname of the CHIANTI top directory.
;               
; Outputs     : None
;               
; Opt. Outputs: None
;               
; Keywords    : IONEQ  - to define the default ionization eq. file to be used.
;               ABUND  -  to define the default abundance file to be used.
;
; Calls       : None
;
; Common      : None
;               
; Restrictions: None
;               
; Side effects: None
;               
; Category    : 
;               
; Prev. Hist. : Based on use_dere_chianti, written by C D Pike, RAL
;
; Written     : Giulio Del Zanna (GDZ)  DAMTP  (University of Cambridge, UK) 
;               
; Modified    : Version 1, GDZ 10-Oct-2000
;               Version 2, GDZ 10-Jan-2001
;               added the definition of the !abund_file
;
;               V. 3, GDZ, 2-May-2002 Modified substantially, adding a new
;               system variable.
;
;               V.4, 10-July-2002 GDZ
;                 Removed the definition of !chianti_top, upon request.
;
;               V.5, 25-July-2002, GDZ 
;                Fixed a problem with IDL versions earlier than 5.3 (the routine
;                would not compile). ALso, introduced the use of concat_dir for
;                cross-platform compatibility.
;                    
;               V.6, 06-Aug-02 GDZ
;                 Changed the use of CHIANTI system variables. Added comments on
;                 the which CHIANTI version is used.
;               V.7 12-Aug-02 GDZ Changed default abundance file. Removed '***'
;               V.8, GDZ 13-Feb-2003
;                   Changed default ioneq  file, to include ALL the elements.
;
; Version     : V.8,  13-Feb-2003
;-            

PRO  use_chianti, XUVTOP, ioneq=ioneq , abund=abund

IF n_params() LT 1 THEN BEGIN
   print,'Use: IDL> use_chianti, "/home/data/chianti/"'
   return
ENDIF


print, ''
print, '---------------------------------------------------------------'
print, '                  Welcome to  CHIANTI'
print, '  For current information see one of the CHIANTI WWW pages'
print, 'e.g: http://www.damtp.cam.ac.uk/user/astro/chianti/chianti.html'
print, 'If you have PROBLEMS please e-mail chianti_help@halcyon.nrl.navy.mil'



IF n_elements(XUVTOP) NE 0 THEN BEGIN 

   IF dir_exist(XUVTOP) THEN BEGIN 
      defsysv,'!xuvtop', XUVTOP
      print, 'CHIANTI system variable !xuvtop set='+XUVTOP
   ENDIF ELSE BEGIN 
      print,'Error, directory '+XUVTOP+' does not exist!'
      print, '-------------------------------------------------------------------'
      return
   END 

ENDIF  ELSE BEGIN 

   IF  getenv('XUVTOP') EQ  '' THEN  BEGIN 
      print,'Error, system  variable XUVTOP must be defined !!'
      print, '-------------------------------------------------------------------'
      return 
   ENDIF ELSE BEGIN 
      IF dir_exist(getenv('XUVTOP')) THEN BEGIN 
         xuvtop = getenv('XUVTOP')
         defsysv,'!xuvtop',getenv('XUVTOP')
         print, 'CHIANTI system variable !XUVTOP set='+getenv('XUVTOP')
      ENDIF ELSE BEGIN 
         print, 'Error, directory '+getenv('XUVTOP')+' does not exist!'
         return 
      END 
   END 
END 

;print, '-------------------------------------------------------------------'

version = ''
ff = findfile(concat_dir(!xuvtop,'VERSION'))
IF  ff(0)  NE ''  THEN BEGIN 
   openr, 1, ff(0)
   readf, 1, version & close, 1
   print,  'You are using the CHIANTI database VERSION ', version
ENDIF ELSE $
  print,  'Please update your CHIANTI database version, which is older than 4.0'


IF n_elements(ioneq) NE 0 THEN BEGIN 
   file = ioneq
   IF file_exist(file) THEN BEGIN 
      defsysv,'!ioneq_file', ioneq
      print, 'CHIANTI system variable !ioneq_file set='+ioneq
   ENDIF ELSE BEGIN 
      print, 'File '+file+' does not exist!'
      ioneq = concat_dir(concat_dir(xuvtop, 'ioneq'), 'mazzotta_etal_ext.ioneq')
      defsysv,'!ioneq_file', ioneq
   ENDELSE 
ENDIF ELSE BEGIN 
   ioneq = concat_dir(concat_dir(xuvtop, 'ioneq'), 'mazzotta_etal_ext.ioneq')
   defsysv,'!ioneq_file', ioneq
ENDELSE 

print, 'CHIANTI system variable !ioneq_file set='+ioneq

IF n_elements(abund) NE 0 THEN BEGIN 
   file = abund
   IF file_exist(file) THEN BEGIN 
      defsysv,'!abund_file', abund
   ENDIF ELSE BEGIN 
      print, 'File '+file+' does not exist!'
      abund = concat_dir(concat_dir(xuvtop, 'abundance'),'sun_photospheric.abund' )
      defsysv,'!abund_file',abund 

   ENDELSE 
ENDIF ELSE BEGIN 
   abund = concat_dir(concat_dir(xuvtop, 'abundance'),'sun_photospheric.abund' )
   IF file_exist(abund) THEN $
     defsysv,'!abund_file',abund ELSE BEGIN 
      print, 'File '+abund+' does not exist!'
      abund = concat_dir(concat_dir(xuvtop, 'abundance'),'allen.abund' )
      IF file_exist(abund) THEN  defsysv,'!abund_file',abund ELSE $
        message, 'Error, check the default abundance file!'
   END  
ENDELSE  

print, 'CHIANTI system variable !abund_file set='+abund

devicelib

print, '-------------------------------------------------------------------'
print, ''

end

