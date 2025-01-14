; $Id: mpeg_save.pro,v 1.9 2005/02/01 20:24:30 scottm Exp $
;
; Copyright (c) 1998-2005, Research Systems, Inc.  All rights reserved.
;	Unauthorized reproduction prohibited.
;+
; NAME:
;	MPEG_SAVE
;
; PURPOSE:
;       Encodes and saves the MPEG sequence.
;
; CATEGORY:
;       Input/Output
;
; CALLING SEQUENCE:
;       MPEG_SAVE, mpegID
;
; INPUTS:
;       mpegID: The unique identifier of the MPEG sequence (as returned
;               from MPEG_OPEN) to be stored.
;
; KEYWORD PARAMETERS:
;       FILENAME: Set this keyword to a string representing the name of
;                 the file to which the encoded MPEG sequence is to be
;                 saved.  The default is 'idl.mpg'.
;
; EXAMPLE:
;       MPEG_SAVE, mpegID, FILENAME='myMPEG.mpg'
;
; MODIFICATION HISTORY:
; 	Written by:	Scott J. Lasica, December, 1997
;-

pro MPEG_SAVE, mpegID, FILENAME = filename

    ON_ERROR,2                    ;Return to caller if an error occurs

    ; let user know about demo mode limitation.
    ; mpeg object is disabled in demo mode
    if (LMGR(/DEMO)) then begin
        MESSAGE, 'Feature disabled for demo mode.'
        return
    endif

    if (not OBJ_ISA(mpegID, 'IDLgrMPEG')) then $
      MESSAGE,'Argument must be an IDLgrMPEG object reference.'

    if (N_ELEMENTS(filename) gt 0) then $
      mpegID->Save, FILENAME = filename $
    else $
      mpegID->Save 

end

