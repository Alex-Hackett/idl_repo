;+
; $Id: acs_gain.pro,v 1.2 2002/03/12 18:21:48 mccannwj Exp $
;
; NAME:
;     ACS_GAIN
;
; PURPOSE:
;     Multiply ACS data by the CCD gain
;
; CATEGORY:
;     ACS/Image
;
; CALLING SEQUENCE:
;     ACS_GAIN, header, image
; 
; INPUTS:
;     header - FITS header
;     image  - image data (overscan/bias level subtracted)
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;     	The input header and image are modified and returned.
;
; RESTRICTIONS:
; 	The Image must be rotated in the following format with amp A at
;	corner x=0,y=0.
;
;		C D
;		A B
;		
; PROCEDURE:
;	Uses gain tables hardcoded into the routine.
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;     version 1  D. Lindler  Aug 1998
;	update gains RCB 02jan31
;-
;============================================================================

PRO acs_gain, h, image

	VERSION = 1.0

	if n_params(0) eq 0 then begin
		print,'CALLING SEQUENCE: acs_gain, h, image'
		return
	endif
;
; Determine which gain table to use
;
   	detector = STRTRIM(sxpar(h,'detector'))
   	IF detector EQ 'SBC' THEN RETURN
	gain = sxpar(h,'ccdgain')

	case detector+'_'+strtrim(gain,2) of
; 1998	'WFC_1': gains = [1.006, 0.965, 1.006, 1.011]	;WFC build 4
;	'WFC_2': gains = [2.016, 1.921, 1.978, 1.996]
;	'WFC_4': gains = [4.033, 3.970, 4.045, 3.992]
;	'WFC_8': gains = [8.104, 8.056, 8.061, 8.125]
	'WFC_1': gains = [0.9999,0.9721,1.0107,1.0180]	; 2002 Feb-rcb
	'WFC_2': gains = [2.018, 1.960, 2.044, 2.010]
	'WFC_4': gains = [4.005, 3.897, 4.068, 3.990]
	'WFC_8': gains = [7.974, 7.735, 8.023, 8.107]
	'HRC_1': gains = [1.080, 1.081, 1.153, 1.056]	;HRC build 1
	'HRC_2': gains = [2.110, 2.104, 2.216, 1.996]
	'HRC_4': gains = [4.143, 4.146, 4.264, 3.878]
	'HRC_8': gains = [8.372, 8.454, 8.569, 8.115]
	else: begin
		print,'ACS_GAIN: Invalid DETECTOR or CCDGAIN in image header'
		return
	      end
	endcase
;
; Determine which amps were used
;
   	amps = strtrim(sxpar(h,'ccdamp'))
   	if STRPOS(amps,'A') ge 0 then ampa = 1 else ampa = 0
   	if STRPOS(amps,'B') ge 0 then ampb = 1 else ampb = 0
   	if STRPOS(amps,'C') ge 0 then ampc = 1 else ampc = 0
   	if STRPOS(amps,'D') ge 0 then ampd = 1 else ampd = 0
	
   	namps = STRLEN(amps)
   	if (ampa and ampb) or (ampc and ampd) then sdouble = 1 else sdouble = 0
   	ldouble = -1
   	if (ampa or ampb) then ldouble=ldouble+1
   	if (ampc or ampd) then ldouble=ldouble+1
;
; determine size and offsets of the four amps
;
	s = size(image) 
	ns = s(1)
	nl = s(2)
	if sdouble then ns_per_amp = ns/2 else ns_per_amp = ns
	if ldouble then nl_per_amp = nl/2 else nl_per_amp = nl
	s1 = [0,1,0,1] * sdouble * ns_per_amp
	l1 = [0,0,1,1] * ldouble * nl_per_amp
	s2 = s1 + ns_per_amp - 1
	l2 = l1 + nl_per_amp - 1
;
; loop on amps
;
	amp_used = [ampa,ampb,ampc,ampd]
	amps = ['A','B','C','D']
	for i=0,3 do begin 
	    if amp_used(i) then image[s1(i):s2(i),l1(i):l2(i)] = $
				image[s1(i):s2(i),l1(i):l2(i)] * gains(i)
	end
	
;
; update history
;
	hist = strarr(2)
	hist(0) = 'ACS_GAIN Version '+string(version,'(F4.1)') + $
		': CCD Gain correction using gains:'
	hist(1) = '    Amps A:' + string(gains(0),'(F6.3)') + $
		  '    B:' + string(gains(1),'(F6.3)') + $
		  '    C:' + string(gains(2),'(F6.3)') + $
		  '    D:' + string(gains(3),'(F6.3)')
	sxaddhist,hist,h
	if !dump gt 0 then print,hist
return
end

