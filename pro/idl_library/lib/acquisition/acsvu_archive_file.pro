;+
; $Id: acsvu_archive_file.pro,v 1.2 2000/08/03 19:06:54 mccannwj Exp $
;
; NAME:
;     ACSVU_ARCHIVE_FILE
;
; PURPOSE:
;     Log an ACS science image into the ACSVU database.
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     Result = ACSVU_ARCHIVE_FILE( filepath [, COMMENT=, CHIP= ] )
; 
; INPUTS:
;     filepath - full path to the science data
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     COMMENT - (STRING) optional comment
;     CHIP    - (STRING) optional chip specification (ACSVU specific mnemonic)
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;     none.
;
; SIDE EFFECTS:
;     May rename SHP file in incoming directory.
;     Copies 1 SDI, and 1 SHP file to the staging directory.
;     Removes 1 SDI, and 1 SHP file from the incoming directory.
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;    Mon Mar 29 15:08:46 1999, William Jon McCann
;    <mccannwj@acs13.+hst.nasa.gov>
;
;		written.
;
;-

FUNCTION acsvu_archive_file, filepath, COMMENTS=comments, $
                             CHIP=chip

   IF N_ELEMENTS( filepath ) LE 0 THEN BEGIN
      MESSAGE, 'filename not specified', /CONTINUE
      return, -1
   ENDIF

   IF N_ELEMENTS( comments ) LE 0 THEN comments = 'Science Image'
   IF N_ELEMENTS( chip ) LE 0 THEN chip = 'NONE'

   junk = FINDFILE( filepath, COUNT = f_count )
   IF f_count LE 0 THEN BEGIN
      MESSAGE, 'file not found: ' + filename, /CONTINUE
      return, -1
   ENDIF

   FDECOMP, filepath, disk, dir, name, qual, version
   
   filename = name+'.'+qual

   uc_qual = STRUPCASE( qual )
   IF (uc_qual NE 'SDI') AND (uc_qual NE 'EFS') AND (uc_qual NE 'EDD') $
    THEN BEGIN
      MESSAGE, filename + " does not have an extension of SDI, EFS or EDD", $
       /CONTINUE
      return, -1
   ENDIF ELSE BEGIN
      
      incoming_file = filepath
      IF STRTRIM(dir,2) EQ '' THEN $
       incoming_dir = GETENV( 'ACSVU_INCOMING_PATH' ) $
      ELSE incoming_dir = dir

      raw_dir = GETENV( 'ACSVU_SDI_PATH' )
      archive_dir = GETENV( 'ACSVU_ARCH_PATH' )

      kbytes_needed = get_filesize( incoming_file )
      answer = is_space( raw_dir, kbytes_needed )
      answer2 = is_space( archive_dir, kbytes_needed )

      IF answer2 EQ 0 THEN BEGIN
         msg = 'Insufficient disk space on '+archive_dir+' to archive image'
         MESSAGE, msg, /CONTINUE
         return, -1
      ENDIF ELSE IF answer EQ 0 THEN BEGIN
         msg = 'Insufficient disk space on '+raw_dir+' to copy image'
         MESSAGE, msg, /CONTINUE
         return, -1
      ENDIF
      
      shp_filename = incoming_dir+'/'+name+'.SHP'
      junk = FINDFILE( shp_filename, COUNT = f_count )

      IF f_count LE 0 THEN BEGIN
                    ; File not found

         strBaseName = STRMID( name, 0, 9 )
         file_filter = strBaseName + '*.SHP'

         incoming_list = FINDFILE( incoming_dir + '/' + file_filter )

                    ; Since our filenames always increase
                    ; numerically, we can use a 'less-than' comparison.
         dot_pos = RSTRPOS( incoming_list[0], '.' )
         IF dot_pos EQ -1 THEN dot_pos = STRLEN( incoming_list[0] ) - 4
         chunked_list = STRMID( incoming_list, dot_pos-15, 15 )
         found = WHERE( chunked_list LT name, nfound )
         IF nfound GT 0 THEN file_i = MAX( found ) ELSE BEGIN
            MESSAGE, "can't find SHP file", /CONT
            return, -1
         ENDELSE

         full_shp_filename = incoming_list[ file_i ]

         MESSAGE, 'warning: SHP not found, using ' + full_shp_filename, $
          /INFO, /NONAME

         IF STRTRIM( full_shp_filename ) NE '' THEN BEGIN
            strSpawnCmd = '/usr/bin/mv '+full_shp_filename+' '+shp_filename
            PRINT, 'SPAWN, '+strSpawnCmd
            SPAWN, strSpawnCmd
         ENDIF

      ENDIF
      
      strSpawnCmd = '/usr/bin/cp '+shp_filename+' '+ raw_dir
      PRINT, 'SPAWN, '+strSpawnCmd
      SPAWN, strSpawnCmd
      strSpawnCmd = '/usr/bin/cp '+incoming_file+' '+ raw_dir
      PRINT, 'SPAWN, '+strSpawnCmd
      SPAWN, strSpawnCmd

      instrument = STRMID( filename, 3, 1 )
      IF instrument NE 'O' AND instrument NE 'J' AND $
       instrument NE 'N' THEN instrument = 'J'

      num_images = 0L
      byte_swapping = 0L
      num_images = load_raw_data_file( raw_dir, filename, byte_swapping )

      IF num_images EQ 0 THEN BEGIN
         MESSAGE, 'Invalid raw data file: '+filename, /CONTINUE
         return, -1
      ENDIF

      total_num_lines = 0
      
                    ; First figure out total size in packets of file
      FOR seq_num=1,num_images DO BEGIN
         tmp_header = INTARR(965)
         status = get_seq_header( seq_num, instrument, byte_swapping, $
                                  tmp_header, /NOACK )
         status = get_img_sz( byte_swapping, tmp_header, instrument, xsize,$
                              ysize, image_size, /TOTAL_ONLY )
         num_lines = image_size/965L
         IF (image_size - num_lines*965) GT 0 THEN num_lines = num_lines + 1
         num_lines = num_lines + 1 ; add one line for header
         total_num_lines = total_num_lines + FIX(num_lines)
      ENDFOR

      FOR seq_num=1,num_images DO BEGIN
         header = INTARR(965)
         data_words = INTARR(8)

         status = get_seq_header( seq_num, instrument, byte_swapping, $
                                  header, /NOACK )
         bldraw_ccdstrct, header, byte_swapping, ccdstrct, benchstrct, $
          instrument

         status = get_img_sz( byte_swapping, header, instrument, xsize, $
                              ysize, image_size )

                    ; Bench
         benchlist=['SI','CCD','CEB','OPS','SW']
         tlm_mnem = 'JQBENCH '
         num = 0
         ccdstrct.bench = benchlist(num)

                    ; Lot Wafer
         DBOPEN, 'lotindex'
         DBEXT, -1, 'lot_num', lotwaferlist
         lotwaferlist = STRTRIM( lotwaferlist, 2 )
         lotwaferlist = [ lotwaferlist, 'New Wafer' ]
         DBCLOSE

         num = WHERE( STRTRIM(chip,2) EQ lotwaferlist, n_found )

         IF n_found LE 0 THEN lot_name = 'NONE' ELSE $
          lot_name = lotwaferlist(num[0])

         index = getlot_index( lot_name[0] )
         data_words(0) = FIX( index(0) )
         ccdstrct.lot_num = lot_name
         tlm_mnem = 'JQSERIDX'
         

         DBOPEN, 'ccddbase'
         filename_no_ext = STRMID( filename, 0, 15 )

         IF num_images GT 1 THEN BEGIN
            STRPUT, filename_no_ext, STRING( FORMAT='(Z1.1)', seq_num ), 1
         ENDIF

         entry = DBFIND( 'filename='+filename_no_ext, /SILENT )
         DBEXT, entry, 'archive, cds_gain ', archive, cds_gain
         strSpawnCmd = [ 'test -d "' + archive + '" -a -x "' + $
                         archive + '" ; echo $?' ]
         SPAWN, strSpawnCmd, result, /SH
         IF result(0) NE 0 THEN archive = GETENV( "ACSVU_ARCH_PATH" )
         DBCLOSE

         acslog, ccdstrct, filename_no_ext, archive, comments(0), benchstrct

      ENDFOR

      ;;PRINT, '*** archiving '+filename
      acsarchive, raw_dir, archive, filename

      strSpawnCmd = '/usr/bin/rm '+incoming_dir+'/'+filename
      PRINT, 'SPAWN, ' + strSpawnCmd
      SPAWN, strSpawnCmd

      filename_no_ext = STRMID( filename, 0, 15 )
      strSpawnCmd = '/usr/bin/rm '+incoming_dir+'/'+filename_no_ext+'.SHP '
      PRINT, 'SPAWN, ' + strSpawnCmd
      SPAWN, strSpawnCmd
      
   ENDELSE 
   status = 0
   status = free_raw_data()

                    ; This is necessary to clean up after DBOPEN
   IF !ERR_STRING EQ 'OPENR: Error opening file: ccddbase.dbx.' THEN !ERROR=0

   return, 1
END
