;+
; $Id: acs_acquire_sci.pro,v 1.8 2001/04/30 17:28:07 mccannwj Exp $
;
; NAME:
;     ACS_ACQUIRE_SCI
;
; PURPOSE:
;     Subroutine of ACS_ACQUIRE to read science data packets and
;     create a data array.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     ACS_ACQUIRE_SCI, unit, swap, header, line_count_udl, data
; 
; INPUTS:
;     unit - unit the file is opened to
;     swap - set to 1 to swap bytes in input data set before processing,
;             0 otherwise
;     hudl - science line header
;     header - science image header
;     line_count_udl - line_count of the UDL for this observations
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     ERROR - exit status (non-zero if an error occurred)
;
; OUTPUTS:
;     data - data array
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
;     Written by D. Lindler   May 1998
;     Nov 27, 1998 D. Lindler, added data uncompression, and no longer
;          addes 32768 to target acq data.
;     Jan 7, 1999 D. Lindler added prompting for missing image size
;       20 May 2000 McCann - added detector defaults for missing image size
;       25 Sep 2000 McCann - added ERROR keyword
;       08 Dec 2000 McCann - fixed scidata byteorder
;-
PRO acs_acquire_sci, unit, swap, hudl, h, line_count_udl, data, $
                     ERROR=error_code

   error_code = 0b
                    ; extract header info
   im_type = sxpar(hudl,'JQIMGTYP')

                    ; determine amount of data to read
   nwords = sxpar(hudl,'JQNUMWDS') ;number of words dumped
   nlines = sxpar(hudl,'JQNUMLNS') ;number of lines dumped
   IF (nwords + 964)/965 NE nlines THEN BEGIN
      print,'Number or words/number of lines mismatch'
   ENDIF
                    ; take internal UDL from the count
   nwords = nwords - 965

                    ; if no data then just return
   IF nwords EQ 0 THEN BEGIN
      MESSAGE, 'Data size is zero', /CONTINUE
      data = 0
      error_code = 1b
      return
   ENDIF
                    ; determine type of dump
                    ; ______________________

   compressed = 0   ;flag if data is compressed
   CASE im_type OF

                    ; memory dump
      'memory dump data' : BEGIN
         ndump = sxpar(h,'JQMDWDS') ;size of memory dump
         IF ndump NE nwords THEN BEGIN
            MESSAGE, 'NDUMP/NWORDS mismatch', /CONTINUE
            error_code = 1b
            return
         ENDIF
         PRINT, im_type, ':', ndump, ' words'
         data = INTARR(ndump)
      END

                    ; DIAG
      'ED diagnostic data' : BEGIN
         data = INTARR(nwords)
         PRINT, im_type, ':', nwords, ' words'
      END

                    ; Science Data
      'detector science data' : BEGIN
         detector = STRTRIM(sxpar(h,'detector'))
         nl = sxpar(hudl,'JQCCDXSZ')
         ns = sxpar(hudl,'JQCCDYSZ')
         IF detector EQ 'SBC' THEN BEGIN
            ns = 1024 & nl = 1024
         ENDIF

                    ; check to see if ns/nl needs to be user supplied.
         numwords = sxpar(hudl,'JQWUNWDS')
         
         IF (ns EQ 0) OR (nl EQ 0) THEN BEGIN

            CASE STRUPCASE(STRTRIM(detector,2)) OF
               'HRC': BEGIN
                  IF numwords EQ 1108728 THEN BEGIN
                     ns = 1062 ; HRC generic
                     nl = 1044
                  ENDIF ELSE IF numwords EQ 1228682 THEN BEGIN
                     ns = 1118 ; HRC CTE pattern generic
                     nl = 1099
                  ENDIF
               END
               'WFC': BEGIN
                  IF numwords EQ 17139584 THEN BEGIN
                     ns = 4144 ; WFC generic
                     nl = 4136                               
                  ENDIF ELSE IF numwords EQ 17811970 THEN BEGIN
                     ns = 4195 ; WFC CTE pattern generic
                     nl = 4246
                  ENDIF 
               END
               ELSE: 
            ENDCASE 

            IF (ns EQ 0) OR (nl EQ 0) THEN BEGIN
               REPEAT BEGIN
                  PRINT, STRING(7b) ;beep
                  PRINT, '------------------------------'
                  READ, 'Enter Image Size (NS,NL): ', ns, nl
                  IF LONG(ns)*nl NE numwords THEN BEGIN
                     PRINT, 'Image size does not match JQWUNWDS'
                     PRINT, 'NS x NL should equal '+ $
                      STRTRIM(numwords,2)
                  ENDIF
               ENDREP UNTIL LONG(ns)*nl EQ numwords
            ENDIF ELSE BEGIN
               PRINT, STRTRIM(detector,2)+' GENERIC using '+ $
                STRTRIM(ns,2) + ' x ' + STRTRIM(nl,2)
            ENDELSE 

                    ; update the sizes in the udl header
            sxaddpar, hudl, 'JQCCDXSZ', nl
            sxaddpar, hudl, 'JQCCDYSZ', ns

         ENDIF

         blocksize = sxpar(hudl,'JQWCOMBS')
         IF (detector EQ 'WFC') AND (blocksize GT 0) $
          THEN compressed = 1

         IF compressed THEN BEGIN
            
                    ; nwords = sxpar(hudl,'JQNUMWDS') - 965 ;number of
                    ; words dumped
                    ; numwords = sxpar(hudl,'JQWUNWDS')
            comp_type = sxpar(hudl,'JQWPOCMP')
            PRINT, (comp_type EQ 1 ? "PARTIAL":"FULL"), " compression"
            n_uncomp_words = (3 * comp_type / 4.0) * nwords
            n_comp_words = nwords - n_uncomp_words
            comp_factor = 2048/FLOAT(blocksize)
            comp_words_ratio = numwords / ( (comp_factor*n_comp_words) + n_uncomp_words)
            ;;HELP, comp_factor, n_comp_words, n_uncomp_words, comp_words_ratio
            comp_ratio_limit = 0.05
            IF ABS(comp_words_ratio - 1) GT comp_ratio_limit THEN BEGIN
               strMessage = 'Number of uncompressed words expected and number of words available disagree by more than '+STRTRIM(FIX(comp_ratio_limit*100),2)+' percent.'
               MESSAGE, strMessage, /CONTINUE
               error_code = 1b
               return
            ENDIF 
            data = INTARR(nwords)
         ENDIF ELSE data = INTARR(ns,nl)
         PRINT, im_type, ' ', detector, ns, ' X ', STRTRIM(nl,2)
      END
      ELSE: BEGIN
         MESSAGE, 'Unknown data type: '+STRTRIM(im_type,2), /CONTINUE
         error_code = 0b
         return
      END 
   ENDCASE
   nlines = (nwords+964)/965 ;number of science lines expected

                    ; index array to pull out the science data
   index = INDGEN(64,16) ;indices for 16 segments (64 words)
   index = REFORM(index[3:63,*]) ;indices with sync words removed
   index = INDEX[11:975] ;indices with packet header removed
   packet = INTARR(1024) ;read buffer

                    ; loop on packets
   last_line_count = line_count_udl ;last line counter
   end_line_count = last_line_count + nlines

start:
                    ; read the data
   READU, unit, packet
   IF swap THEN BYTEORDER, packet
   packet_header = packet[0:10]
   BYTEORDER, packet_header, /NTOHS

                    ; determine where to insert it
   line_count = packet_header[7]
   IF line_count GT end_line_count THEN BEGIN
      PRINT, line_count, nlines
      st = 'Invalid packet Line Count = '+STRTRIM(line_count,2)
      PRINT,'                           Packet Ignored'
      PRINT,st
      sxaddhist,st,h
      GOTO, start
   ENDIF

                    ; missing packets at end of data dump
   IF line_count LE last_line_count THEN BEGIN
      st = 'Data Missing for Line count = '+ $
       STRTRIM(last_line_count+1,2)+ $
       ' to '+STRTRIM(nlines,2)
      PRINT, st
      sxaddhist,st,h
      POINT_LUN, -unit, pointer
      POINT_LUN, unit, pointer-2048 ;reset file position
      GOTO, done
   ENDIF

                    ; check to see if missing packets in the middle of
                    ; the data .
   IF (last_line_count+1) NE line_count THEN BEGIN
      st = 'Data Missing for line count '+ $
       STRTRIM(last_line_count+1,2)+' to '+ $
       STRTRIM(line_count-1,2)
      PRINT, st
      sxaddhist,st,h
   ENDIF

                    ; insert the data into the array
   ipos = (line_count-1-line_count_udl)*965L
   n = (nwords-ipos) < 965
   IF n LT 965 THEN sci_data = packet[index[0:n-1]] $
   ELSE sci_data = packet[index]
   BYTEORDER, sci_data, /NTOHS
   data[ipos] = TEMPORARY(sci_data)

                    ; check if done
   last_line_count = line_count
   IF line_count EQ end_line_count THEN GOTO, done
   IF EOF(unit) THEN BEGIN
      st = 'Data Missing for line count '+ $
       STRTRIM(last_line_count+1,2)+' to '+ $
       STRTRIM(nlines,2)
      PRINT, st
      sxaddhist,st,h
      GOTO, done
   ENDIF
   GOTO, start

                    ; done reading packets
done:
                    ; uncompress compressed data
   IF compressed THEN BEGIN
      PRINT, 'UNCOMPRESSING WFC Data'
      acs_acquire_uncompress, h, hudl, data, ERROR=error_code
      IF error_code[0] NE 0 THEN return
   ENDIF

                    ; add 32768 to non-Targ ACQ CCD images
   IF im_type EQ 'detector science data' THEN BEGIN
      obstype = STRTRIM(sxpar(h,'obstype'))
      IF ((detector EQ 'HRC') OR (detector EQ 'WFC')) AND $
       (obstype NE 'TARG_ACQ') THEN data = FIX(data+32768)
   ENDIF

   return
END
