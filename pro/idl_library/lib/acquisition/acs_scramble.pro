;+
; $Id: acs_scramble.pro,v 1.1 2001/12/03 21:39:59 mccannwj Exp $
;
; NAME:
;     ACS_SCRAMBLE
;
; PURPOSE:
;     This function is the reverse of ACS_UNSCRAMBLE.  It takes an
;     array composed as though one were looking at the detector and
;     converts it to the format used to store the images in the
;     ACS calibration FITS files.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     ACS_SCAMBLE, amp_select, image
; 
; INPUTS:
;     amp_select - string amp selection (e.g. 'ABCD')
;     image - image to be scambled
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;     image - scambled image
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;
; PROCEDURE:
;     Data is read from amplifiers in the following pixel orders:
;          A  starts with pixel (0,0) runs increasing Y then increasing X
;          B  starts with pixel (0,N) runs decreasing Y then increasing X
;          C  starts with pixel (N,0) runs increasing Y then decreasing X
;          D  starts with pixel (N,N) runs decreasing Y then decreasing X
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;	version 1  By D. Lindler from algorithm in routine unscramble.pro
;		by S.E.ROSS
;
;-
PRO acs_scramble, amp_select, image
   acs_unscramble, amp_select, image
   return
END
