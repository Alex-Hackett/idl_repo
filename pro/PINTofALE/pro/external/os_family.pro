function OS_FAMILY,LOWER=LOWER
;+
; Project     :	SOHO - CDS
;
; Name        :	OS_FAMILY()
;
; Purpose     :	Return current operating system as in !VERSION.OS_FAMILY
;
; Category    :	Utilities, Operating_system
;
; Explanation :	Return the current operating system as in !VERSION.OS_FAMILY
;
;	OS_FAMILY is assumed to be 'unix' if !VERSION.OS is not 'windows',
;		'MacOS' or 'vms'
;
;	To make procedures from IDL V4.0 and later compatibile with earlier
;	versions of IDL, replace calls to !VERSION.OS_FAMILY with OS_FAMILY().
;
;	Can also be used to replace calls to !VERSION.OS if care is taken with
;	the change of case between 'Windows', which is what this routine
;	returns, and 'windows' which is what !VERSION.OS returned in versions
;	of IDL prior to 4.0.
;
; Syntax      :	Result = OS_FAMILY()
;
; Examples    :	IF OS_FAMILY() EQ 'vms' THEN ...
;
; Inputs      :	None.
;
; Opt. Inputs :	None.
;
; Outputs     :	The result of the function is a scalar string containing one of
;		the four values 'Windows','MacOS','vms' or 'unix'
;
; Opt. Outputs:	None.
;
; Keywords    :	LOWER - set to return lowercase strings
;
; Calls       :	TAG_EXISTS
;
; Common      :	None.
;
; Restrictions:	None.
;
; Side effects:	None.
;
; Prev. Hist. :	Written,  W. Landsman
;
; History     :	Version 1, 29-Aug-1995, William Thompson, GSFC
;			Incorporated into CDS library
;               Version 2, 15 May 2000, Zarro (SM&A/GSFC) - added /LOWER
;
; Contact     :	WTHOMPSON
;-
;

 if tag_exist(!VERSION, 'OS_FAMILY') then begin
  os=!VERSION.OS_FAMILY
  if keyword_set(lower) then os=strlowcase(os)
  return,os
 endif

 case !VERSION.OS of

'windows': os= 'Windows'
  'MacOS': os= 'MacOS'
    'vms': os= 'vms'
     else: os= 'unix'
 endcase

 if keyword_set(lower) then os=strlowcase(os)
 return,os
 end
