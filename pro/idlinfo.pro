; $Id: idlinfo.pro,v 1.9 2005/02/01 20:24:25 scottm Exp $
;
; Copyright (c) 1997-2005, Research Systems, Inc.  All rights reserved.
;	Unauthorized reproduction prohibited.
;

;+NODOCUMENT
; NAME:
;       IDLINFO
;
; PURPOSE:
;	Print contact information for Research Systems and offer other
;	basic information on using or demoing IDL.
;
; CALLING SEQUENCE:
;
;	IDLINFO
;
; INPUTS:
;	None.
;
; KEYWORDS:
;	None.
;
; OUTPUT:
;	Basic information is printed.
;
; COMMON BLOCKS:
;       NONE.
;
; SIDE EFFECTS:
;       None.
;
; RESTRICTIONS:
;	None.
;
; MODIFICATION HISTORY:
;       Written, DMS, RSI, 17 April 1997
;           
;-

pro IDLInfo
  FileName = filepath('idlinfo.txt', SUBDIR=['help','motd'])
  openr, Lun, Filename, Error=err, /GET_LUN
  if err lt 0 then return
 
  line = ''
  while not eof(Lun) do begin
    readf, lun, line
    print, line
  endwhile
  free_lun, lun
end
