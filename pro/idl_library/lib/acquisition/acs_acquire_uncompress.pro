;+
; $Id: acs_acquire_uncompress.pro,v 1.5 2000/09/27 23:10:49 mccannwj Exp $
;
; NAME:
;     ACS_ACQUIRE_UNCOMPRESS
;
; PURPOSE:
;     Subroutine of ACS_ACQUIRE used to uncompress WFC data compressed
;     onboard.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
; 
; INPUTS:
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
;
; RESTRICTIONS:
;     Calls C executable written by R. White.  The executable should
;      be in IDL_PATH.
;
;     Writes temporary files to IDL_TMPDIR.  Requires UNIX shell.
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;	Version 1  D. Lindler  Nov 27, 1998
;       Version 1.1 McCann 25 Sep 2000 - added ERROR keyword
;-
;----------------------------------------------------------------------
PRO acs_acquire_uncompress, h, hudl, d, ERROR=error_code

   error_code = 0b
                    ; get header info
   amps = STRTRIM(sxpar(h,'ccdamp'))
   namps = STRLEN(amps)
   blocksize = sxpar(hudl,'JQWCOMBS') ; compressed blocksize
   t1 = sxpar(hudl,'JQWFCT1')
   if t1 ne 224 then begin
      PRINT, 'ACS_ACQUIRE_UNCOMPRESS: ERROR - only a value of '+ $
       'JQWFCT1 = 224 is supported'
      error_code = 1b
      return
   end
   nl = LONG(sxpar(hudl,'JQCCDXSZ'))
   ns = LONG(sxpar(hudl,'JQCCDYSZ'))
;
; create output buffer to hold the data
;
   nwords = nl*ns   ;uncompressed image
                    ;words
   nwords_per_amp = nwords/namps
   nblocks = LONG((nwords_per_amp+2047)/2048) ;number of 2048 word
                    ;compressed blocks
   out = INTARR(nwords)
;
; Find C executable
;
   executable = find_with_def('pdecomp','IDL_PATH')
   IF executable[0] EQ '' THEN BEGIN
      MESSAGE, 'Cannot find decompression tool', /CONTINUE
      error_code = 1b
      return
   ENDIF 
;
; determine number of amps to uncompress
;
   if sxpar(hudl,'JQWPOCMP') eq 1 then namps_c = sxpar(hudl,'JQWNUMCH') $
   else namps_c = namps

   if namps_c eq 0 then namps_c = namps		
;
; uncompress each amp
;
   ipos = 0L

                    ; get a PID
   SPAWN, 'echo $$', pid, /SH
   IF N_ELEMENTS(pid) LE 0 THEN pid='2020'
   IF pid[0] EQ '' THEN pid='2020'
   temp_dir = GETENV('IDL_TMPDIR')
   temp_in_filename  = temp_dir+'acs_compress-'+STRTRIM(pid[0],2)+'.in'
   temp_out_filename = temp_dir+'acs_compress-'+STRTRIM(pid[0],2)+'.out'

   FOR i=0,namps_c-1 DO BEGIN
;
; write input data set for C program
;
      OPENW, unit, temp_in_filename, /GET_LUN, ERROR=open_error
      IF (open_error NE 0) THEN BEGIN
         PRINTF, -2, !ERR_STRING
         error_code = 1b
         return
      ENDIF

      WRITEU, unit, STRING([254b,239b]) ; a secret code
      WRITEU, unit, blocksize*2L, nblocks, 2048L
      ipos = i*(blocksize*nblocks + 16)	;16 word pad between
                    ; blocks
      dd = d[ipos:ipos+nblocks*blocksize-1]
      BYTEORDER, dd ;swap bytes
      WRITEU, unit, dd
      FREE_LUN, unit
;
; run C executable
;
      strExec = executable+' -v -o fits < '+temp_in_filename+$
       ' > '+temp_out_filename
      SPAWN, strExec
;
; read results and put into output buffer
;
      fits_read, temp_out_filename, c, /NO_ABORT, MESSAGE=message
      SPAWN, '/usr/bin/rm -f '+temp_out_filename
      SPAWN, '/usr/bin/rm -f '+temp_in_filename
      IF !ERR LT 0 THEN BEGIN
         IF N_ELEMENTS(message) GT 0 THEN MESSAGE, message, /CONTINUE
         error_flag = 1b
         return
      ENDIF
      out[i*nwords_per_amp] = c[0:nwords_per_amp-1]
   ENDFOR
;
; copy over remaining data already uncompressed
;
   if namps_c lt namps then out[namps_c*nwords_per_amp] = $
    d[namps_c*(blocksize*nblocks + 16)+16:*]
;
; reform image to proper size and clean up
;
   d = REFORM(out,ns,nl,/OVERWRITE)

   return
END
