;+
; $Id: acs_text_log.pro,v 1.5 2001/08/06 15:48:25 mccannwj Exp $
;
; NAME:
;     ACS_TEXT_LOG
;
; PURPOSE:
;     Simple routine to retrieve information from the database and
;     format in the form of the ACS IDT text logs.
;
; CATEGORY:
;     ACS/Log
;
; CALLING SEQUENCE:
;     ACS_TEXT_LOG, list
; 
; INPUTS:
;     list - vector of database entry numbers
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
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;     27 Sep 2000 McCann - version 1
;
;-
PRO acs_text_log, list, last

   IF N_PARAMS() LT 1 THEN BEGIN
      PRINT, 'Usage: ACS_TEXT_LOG, list [, last]'
      return
   ENDIF 

; This is the template
   PRINT, '                 D'
   PRINT, 'Cal. log    texp E Filters  Exp   Image/Source config              Notes'
   PRINT, 'ID(range)    (s) T          type                      '
   PRINT, '-----|-----|----|-|-------|------|-----------------------|------------------------------------'

   dbopen, 'acs_log'
   IF N_PARAMS() EQ 2 THEN BEGIN
      n_entries = db_info('entries')
      first = LONG(list[0]) > 1
      last = LONG(last[0]) > first < n_entries[0]
      list = INDGEN(last-first+1)+first
   ENDIF
   dbext, list, 'entry,exptime,detector,filter1,filter2,filter3,obstype,sclamp,ccdamp,ccdgain,ccdoff', $
    entry,exptime,detector,filter1,filter2,filter3,obstype,sclamp,ccdamp,ccdgain,ccdoff

   dbext, list, 'subarray,ccdxsiz,ccdysiz,ccdxcor,ccdycor,filename,flshstat,flashcur,flashdur', $
    subarray,ccdxsiz,ccdysiz,ccdxcor,ccdycor,filename,flshstat,flashcur,flashdur

   dbext, list, 'cblksiz,blkslost,fw1off,fw2off,fw3off', $
    cblksiz,blkslost,fw1off,fw2off,fw3off

   dbext, list, 'stimulus,monowave,monogrtg', stimulus, monowave, monogrtg

   obstype = STRTRIM(obstype,2)
   sclamp = STRTRIM(sclamp,2)
   detector = STRTRIM(detector,2)
   stimulus = STRTRIM(stimulus,2)

   FOR i=0l,N_ELEMENTS(list)-1 DO BEGIN
      ft = STRTRIM([filter1[i],filter2[i],filter3[i]],2)
      fo = STRTRIM([fw1off[i],fw2off[i],fw3off[i]],2)
      good = WHERE(ft NE '' AND STRMID(ft,0,3) NE 'CLE',count)
      IF count GT 0 THEN BEGIN
         filter = ft[good]
         filtoff = fo[good]
      ENDIF ELSE begin
         filter='NONE'
         filtoff=0
      ENDELSE 
      same_file = WHERE(STRMID(filename,0,15) EQ STRMID(filename[i],0,15), $
                        same_count)
      on_one_line = 0b
      IF same_count[0] GT 1 THEN BEGIN
         junk = WHERE(exptime[same_file] NE exptime[same_file[0]],exptime_c)
         junk = WHERE(detector[same_file] NE detector[same_file[0]],detector_c)
         junk = WHERE(filter1[same_file] NE filter1[same_file[0]],filter1_c)
         junk = WHERE(filter2[same_file] NE filter2[same_file[0]],filter2_c)
         junk = WHERE(fw1off[same_file] NE fw1off[same_file[0]],fw1off_c)
         junk = WHERE(fw2off[same_file] NE fw2off[same_file[0]],fw2off_c)
         junk = WHERE(obstype[same_file] NE obstype[same_file[0]],obstype_c)
         on_one_line = (exptime_c EQ 0) AND (detector_c EQ 0) AND (filter1_c EQ 0) $
          AND (filter2_c EQ 0) AND (obstype_c EQ 0) $
          AND (fw1off_c EQ 0) AND (fw2off_c EQ 0)
      ENDIF 
      IF on_one_line THEN BEGIN
         entry2_i = MAX(same_file)
         entry1 = entry[i]
         entry2 = entry[entry2_i]
         i=LONG(entry2_i)
         strFormat = '(I5,":",I5,$)'
      ENDIF ELSE BEGIN
         strFormat = '(I5,A6,$)'
         entry1 = entry[i]
         entry2 = ''
      ENDELSE
      PRINT, FORMAT=strFormat, entry1, entry2

      IF obstype[i] EQ 'INTERNAL' THEN BEGIN
         sc_pre = STRMID(sclamp[i],0,4)
         IF sc_pre EQ 'TUNG' THEN obstype[i] = sc_pre + STRMID(sclamp[i],STRLEN(sclamp[i])-1) $
         ELSE obstype[i] = sc_pre
      ENDIF

      IF MAX(ABS(filtoff)) GT 0 THEN BEGIN
                    ; if offsets are non zero then print them
         FOR fi=0,N_ELEMENTS(filter)-1 DO BEGIN
            off_string = (filtoff[fi] GE 0) ? '+'+STRTRIM(filtoff[fi],2) : $
             STRTRIM(filtoff[fi],2)
            f_o = filter[fi] + off_string
            IF fi EQ 0 THEN filter_string = f_o $
            ELSE filter_string = filter_string + '/' + f_o
         ENDFOR
      ENDIF ELSE BEGIN
         IF N_ELEMENTS(filter) GT 1 THEN $
          filter_string = STRJOIN(filter,'/') $
         ELSE filter_string = STRING(FORMAT='(A7)',filter[0])
      ENDELSE 

      IF (exptime[i] MOD 1) NE 0 THEN $
       strFormat = '(1X,F4.1' $
      ELSE strFormat = '(1X,I4'
      strFormat = strFormat + ',1X,A1,1X,A,1X,A6,$)'
      PRINT, FORMAT=strFormat, exptime[i], detector[i], filter_string, obstype[i]

      IF detector[i] NE 'SBC' THEN BEGIN
         IF on_one_line THEN BEGIN
            strFormat = '(1X,A,$)'
            amps = STRJOIN(STRTRIM(ccdamp[same_file],2),',')
         ENDIF ELSE BEGIN
            strFormat = '(1X,A,$)'
            amps = STRTRIM(ccdamp[i],2)
         ENDELSE 
         PRINT, FORMAT=strFormat, amps
         IF STRMID(subarray[i],0,3) EQ 'SUB' THEN $
          strSub = STRTRIM(ccdxsiz[i],2)+'x'+STRTRIM(ccdysiz[i],2)+'@'+STRTRIM(ccdxcor[i],2)+','+STRTRIM(ccdycor[i],2) $
         ELSE strSub = ''
         strFormat = '("@",I1,"/",I1'
         strFormat = strFormat + ',1X,A,$)'
         PRINT, FORMAT=strFormat, ccdgain[i], ccdoff[i], strSub
      ENDIF

      IF STRTRIM(flshstat[i],2) NE 'NONE' THEN BEGIN
         PRINT, FORMAT='(" FLASH",1X,A,1X,A,"s ",$)', STRTRIM(flashcur[i],2), $
          STRTRIM(STRING(F='(F8.2)',flashdur[i]),2)
      ENDIF 

      IF cblksiz[i] GT 0 THEN BEGIN
         PRINT, FORMAT='(" Compression",1X,"w/",1X,A,"data lost",$)', $
          ((blkslost[i] GT 0) ? '' : 'no ')
      ENDIF 

      IF (stimulus[i] EQ 'RASCAL') OR (stimulus[i] EQ 'MONOHOMS') THEN BEGIN
         monowave_string = STRTRIM(STRING(FORMAT='(F8.2)',monowave[i]),2)
         PRINT, FORMAT='(" wl/g=",A,"/",A)', monowave_string,monogrtg[i]
      ENDIF 

      PRINT, ''
   ENDFOR 

END 
