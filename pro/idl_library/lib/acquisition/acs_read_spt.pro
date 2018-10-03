;+
; $Id: acs_read_spt.pro,v 1.1 2002/03/12 18:04:04 mccannwj Exp $
;
; NAME:
;     ACS_READ_SPT
;
; PURPOSE:
;     Routine to read the post-launch SPT file and decode the UDL
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     ACS_READ_SPT, file, udl, hudl, heng1, heng2, hspt, no_spt
;
; INPUTS:
;     file - file containing raw data
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;     udl - udl vector
;     hudl - udl header
;     heng1 - engineering snapshot 1
;     heng2 - engineering snapshot 2
;     no_spt - flag set to 1 if no spt file was found
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
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Fri Feb 8 12:52:00 2002, Don Lindler
;
;-
PRO acs_read_spt, file, udl, hudl, heng1, heng2, hspt, no_spt

                    ; read spt file
   fdecomp,file,disk,dir,name,ext
   spt_file = disk+dir+gettok(name,'_')+'_spt.fits'
   list = findfile(spt_file)
   IF list[0] EQ '' THEN BEGIN
      PRINT, 'ACS_READ: SPT file not found'
      no_spt = 1
      udl = 0
      hudl = ['END         ']
      heng1 = hudl
      heng2 = hudl
      hspt = hudl
      return
   ENDIF 
   no_spt = 0
   fits_read,spt_file,udl,hspt
   acs_acquire_setup
   acs_acquire_udl, udl, hudl
   acs_acquire_eds, udl[255:255+349], heng1
   acs_acquire_eds, udl[605:605+349], heng2
END

