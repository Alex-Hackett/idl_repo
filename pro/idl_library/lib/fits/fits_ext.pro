;+
; $Id: fits_ext.pro,v 1.1 2001/11/05 21:10:06 mccannwj Exp $
;
; NAME:
;     FITS_EXT
;
; PURPOSE:
;     Get the names of the extensions in a FITS format file
;
; CATEGORY:
;     ACS/Fits
;
; CALLING SEQUENCE:
;     result = FITS_EXT( filename [, BITPIX=, DIMENSIONS=, LIST=, $
;                        NAXIS=,  TYPES=, ERROR=, /PRINT, /VERBOSE] )
; 
; INPUTS:
;     filename - (STRING) name of FITS file to read
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     BITPIX     - (OUTPUT) get a list of the bitpix values for each
;                   extension.
;     DIMENSIONS - (OUTPUT) get a list of the dimensions of each
;                   extension.
;     LIST       - (OUTPUT) get a string list of the name, type,
;                   bitpix, dimension for each extension.
;     NAXIS      - (OUTPUT) get a list of the naxis values for each
;                   extension.
;     TYPES      - (OUTPUT) get a list of the extensions types
;     ERROR      - (OUTPUT) get the value of the error flag
;
; OUTPUTS:
;     result - A list of the names for each extension
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;     Uses FITS_OPEN, FITS_CLOSE
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;       Thu Jun 15 21:12:32 2000, William Jon McCann
;       <mccannwj@acs13.+ball.com>
;-
FUNCTION fits_ext, filename, TYPES=aTypes, DIMENSIONS=aDimensions, $
                   PRINT=print, LIST=aList, BITPIX=aBitpix, NAXIS=aNaxis, $
                   ERROR=error_flag, VERBOSE=verbose
   COMPILE_OPT IDL2

   IF N_ELEMENTS( filename ) LE 0 THEN BEGIN 
      MESSAGE, 'filename not specified.', /CONTINUE
      error_flag = 1b
      return, ''
   ENDIF

   error_flag = 0b

   FITS_OPEN, filename, fcb
   FITS_CLOSE, fcb
   IF KEYWORD_SET( verbose ) THEN HELP, /STR, fcb

   n_extensions = fcb.nextend
   has_data = 0b
   primary_naxis = fcb.naxis[0]

   IF MAX(fcb.naxis) GT 0 THEN has_data = 1b

   aTypes = MAKE_ARRAY( n_extensions + 1, /STRING )
   aNames = aTypes
   aBitpix = aTypes
   aDimensions = aTypes
   aNaxis = aTypes
   aList = aTypes
   FOR i=0,n_extensions DO BEGIN
      ext_bitpix = STRTRIM( fcb.bitpix[i], 2 )
      ext_type   = STRTRIM( fcb.xtension[i], 2 )
      IF ext_type EQ '0' THEN ext_type = 'PRIMARY'
      ext_name   = STRTRIM( fcb.extname[i], 2 )
      IF ext_name EQ '' THEN ext_name = 'PRIMARY'
      ext_naxis  = STRTRIM( fcb.naxis[i], 2 )
      ext_axis   = STRTRIM( fcb.axis[*,i], 2 )

      aTypes[i]  = ext_type
      aNames[i]  = ext_name
      aBitpix[i] = ext_bitpix
      aNaxis[i]  = ext_naxis

      IF fcb.naxis[i] GT 0 THEN $
       strAxis = '['+STRJOIN( ext_axis[0:fcb.naxis[i]-1], ',' )+']' $
      ELSE strAxis = '[0,0]'
      aDimensions[i] = strAxis

      strOut = STRING( FORMAT='(I3,2X,A8,2X,A15,2X,A6,2X,A)', $
                       i, ext_type, ext_name, $
                       ext_bitpix, strAxis )
      aList[i] = strOut

      IF KEYWORD_SET( print ) THEN PRINT, strOut

   ENDFOR

   IF has_data LE 0 THEN BEGIN
      MESSAGE, 'File has no data.', /INFO
      error_flag = 1b
   ENDIF

   return, aNames
END 
