;+
; $Id: acs_data.pro,v 1.1 2000/08/03 19:03:49 mccannwj Exp $
;
; NAME:
;     ACS_DATA
;
; PURPOSE:
;     Selective acquisition of ACS data.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     ACS_DATA [, /MULTPLE, /REACQUIRE, NUMBER= ]
; 
; INPUTS:
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     MULTIPLE - allow multiple file selection via DIALOG_PICKFILE()
;     REACQUIRE - reacquire image
;     NUMBER - number of the image within the dump to reacquire.
;     STIMULUS - input stimulus (if not supplied taken from acs_setup.txt in
;		JAUX)
;     ENVIRONMENT - enviroment (if not supplied taken from acs_setup.txt in
;		JAUX)
;     INDIR - directory for incoming data files
;     OUTDIR - directory for output FITS files
;     /PS - generate postscript files
;     /PRINT_PS - print postscript files
;     /EVAL - create evaluation log
;     /PRINT_EVAL - print evaluation log
;     TEXT_BASE - base of text widget to print acquisition info to.
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;     none.
;
; SIDE EFFECTS:
;     calls ACS_ACQUIRE
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;    written by Don Lindler ACC
;
;    Thu Feb 4 22:19:44 1999, William Jon McCann
;	added MULTPLE, REACQUIRE keywords
;
;    Feb 28, 1999, Lindler
;       added enviroment,stimulus,indir,outdir,ps,print_ps,
;		eval,print_eval, and text_base keywords
;
;    Mon Mar 29 17:08:56 1999, William Jon McCann
;         added LAST_FILE keyword		
;-

PRO checkfilesize, file

                    ; return if SHP file.
   FDECOMP, file, disk, dir, name, ext
   IF ext EQ 'SHP' THEN RETURN

                    ; checks file size and returns after 5 seconds of
                    ; no changes in the size.
   newsize = -1
   PRINT, file
   REPEAT BEGIN
      lastsize = newsize		
      OPENR, unit, file, /GET_LUN
      f = FSTAT( unit )
      newsize = f.size
      FREE_LUN, unit
      IF newsize NE lastsize THEN BEGIN
         PRINT, 'size = ', newsize, $
          '  Waiting 5 seconds to see if file is complete'
         WAIT, 5.0
      END ELSE PRINT, 'size = ', newsize
   END UNTIL newsize EQ lastsize

   return
END

; ____________________________________________________________________________

pro acs_products, id, EVAL=eval, PS=ps, PRINT_PS=print_ps, $
                  PRINT_EVAL=print_eval

                    ; generate standard print products

   IF KEYWORD_SET(eval) THEN BEGIN
      eval_doc, id, /FILE
      IF KEYWORD_SET(print_eval) THEN $
       SPAWN, 'lp eval_' + STRTRIM(id,2) + '.txt'
   ENDIF

   IF KEYWORD_SET(ps) THEN BEGIN
      ;;rashoms_ps,id,/histeq
      rashoms_ps, id
      DBOPEN, 'acs_log'
      IF KEYWORD_SET(print_ps) THEN $
       SPAWN, 'lp '+STRTRIM(DBVAL(id,'filename'))+'.ps'
   ENDIF

   return
END

; ____________________________________________________________________________

PRO acs_data, REACQUIRE=reacquire, NUMBER=image_number, $
              MULTIPLE=multiple, STIMULUS=stimulus, ENVIRONMENT=environment, $
              INDIR=indir, OUTDIR=outdir, PS=ps, PRINT_PS=print_ps, $
              EVAL=eval, PRINT_EVAL=print_eval, TEXT_BASE=text_base, $
              LAST_FILE=last_file, SELECTED=selected

   selected = STRARR(1)

   IF N_ELEMENTS(indir) LE 0 THEN $
    indir = '/net/bigdog/usr/home/bigdog1/scidata/images/incoming/'
   IF N_ELEMENTS(outdir) LE 0 THEN $
    outdir = '/acs/data1/jdata/'

                    ; get current date for default data filter
   time_zone = TIMEZONE()
   date = LONG( DATE_CONV( !STIME ) - time_zone/24.0 ) 
                    ; chop down year to two digits (since Y2K
                    ; date_conv update
   date = STRMID( STRTRIM( date, 2 ), 2, 50 )
   file_filter = 'CSIJ' + date + '*.S*'

   !PRIV = 2

   IF N_ELEMENTS( !VERSION.RELEASE ) LE 0 THEN allow_multiple = 0b $
   ELSE BEGIN
      major_version = FLOAT( STRMID( !VERSION.RELEASE, 0, 3 ) )
      IF major_version GE 5.1 THEN allow_multiple = 1b ELSE allow_multiple=0b
   ENDELSE

   FOR i=1, 10000 DO BEGIN
                    ; get next file
      IF allow_multiple EQ 0 THEN BEGIN
         file = DIALOG_PICKFILE( TITLE=lastfile, GET_PATH=new_path, $
                                 PATH=indir, FILTER=file_filter, $
                                 /MUST_EXIST )
      ENDIF ELSE BEGIN
         file = DIALOG_PICKFILE( TITLE=lastfile, GET_PATH=new_path, $
                                 PATH=indir, FILTER=file_filter, $
                                 MULTIPLE_FILES=multiple, /MUST_EXIST )
      ENDELSE

      IF file[0] EQ '' THEN GOTO, DONE
      last_file = file
      sorted_files = file[SORT(file)]

      FOR file_i=0, N_ELEMENTS(sorted_files)-1 DO BEGIN
         
         FDECOMP, sorted_files[ file_i ], disk, dir, name, ext
                    ; check last 500 entries for file already done
         IF (ext EQ 'SDI') AND NOT KEYWORD_SET(reacquire) THEN BEGIN
            dbopen,'acs_log'
            nentry = db_info('entries')
            list = dbfind(/SILENT, $
                          'entry>'+STRTRIM(nentry-500,2)+',filename='+name)
            IF list[0] GT 0 THEN BEGIN
               PRINT, 'File '+name+'.SDI was previously acquired'
               IF N_ELEMENTS(text_base) GT 0 THEN BEGIN
                  IF WIDGET_INFO(text_base,/VALID) THEN BEGIN
                     WIDGET_CONTROL, text_base, /APPEND, $
                      SET_VALUE=name+'.SDI previously acquired'
                  ENDIF
               ENDIF
               GOTO, nextloop
            ENDIF
         ENDIF

                    ; check to see if file is complete
         checkfilesize, sorted_files[file_i]
         PRINT, '======================================'

         lastfile = 'lastfile: ' + name + '.' + ext
         indir = new_path

         IF ext EQ 'SDI' THEN BEGIN
                    ; In case the SHP and SDI file have the same base name
                    ; Process .SHP first if exists
            shp_file = disk + dir + name + '.SHP'
            junk = FINDFILE( shp_file, COUNT = shp_count )
            
            IF shp_count GT 0 THEN BEGIN
               PRINT, 'ACQUIRE SHP: '+shp_file
               acs_acquire, shp_file, $
                OUTDIR=OUTDIR, STIMULUS_IN=stimulus,ENVIRONMENT=environment, $
                REACQUIRE=reacquire, NUMBER=image_number, $
                id1=id1, id2=id2
               PRINT, '======================================'
            ENDIF
         ENDIF

         IF ext EQ 'SHP' THEN BEGIN
                    ; In case the SHP and SDI file have the same base name
                    ; Skip the SHP since we will have done it in combo
                    ; with the SDI
            sdi_file = disk + dir + name + '.SDI'
            junk = FINDFILE(sdi_file, COUNT=sdi_count)
            IF sdi_count GT 0 THEN GOTO, NEXTLOOP
         ENDIF
         
         file_filter = STRMID( name, 0, 9 ) + '*.S*'

         file2log = sorted_files[file_i]
         PRINT, 'ACQUIRE SDI: ' + file2log
                    ; record that this file was logged
         selected = [selected,file2log]
         acs_acquire, file2log, /LOG, $
          OUTDIR=OUTDIR, STIMULUS_IN=stimulus, ENVIRONMENT=environment, $
          REACQUIRE=reacquire, NUMBER=image_number, ID1=id1, ID2=id2
         
         IF ext EQ 'SDI' THEN BEGIN
            FOR id=id1,id2 DO $
             acs_products, id, EVAL=eval, PS=ps, $
             PRINT_PS=print_ps,PRINT_EVAL=print_eval	 
            IF N_ELEMENTS(text_base) GT 0 THEN WIDGET_CONTROL,text_base, $
             SET_VALUE=name+'.SDI'+STRING(id1,'(I7)')+ $
             STRING(id2,'(i7)'),/APPEND
         ENDIF
         IF (ext EQ 'SHP') AND (N_ELEMENTS(text_base) GT 0) THEN $
          WIDGET_CONTROL,text_base,SET_VALUE=name+'.SHP',/APPEND
         PRINT, '======================================'
         
NEXTLOOP:
      ENDFOR
   ENDFOR
DONE:
   n_select = N_ELEMENTS(selected)
   IF n_select GT 1 THEN selected=selected[1:n_select-1]

   return
END
