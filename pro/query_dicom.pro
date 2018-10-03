; $Id: query_dicom.pro,v 1.19.2.1 2005/05/19 15:34:55 ehaskell Exp $
;
; Copyright (c) 1993-2005, Research Systems, Inc.  All rights reserved.
;       Unauthorized reproduction prohibited.

;
; Return the first datum reference in iref before the reference imgid.
;
FUNCTION QueryDicomGetFirstBefore, oDicom, iref, imgid
  COMPILE_OPT hidden

  iIndex = iref[0]

  parent = oDicom->GetParent(imgid)
  par_iref = oDicom->GetParent(iref)
  v = WHERE(par_iref EQ parent)
  IF (v[0] NE -1) THEN BEGIN
   v_iref = iref[v]
   w = WHERE(v_iref LT imgid)
   IF (w[0] NE -1) THEN BEGIN
     iIndex = v_iref[w[N_ELEMENTS(w)-1]]
   END
  END

  p = oDicom->GetValue(REFERENCE=iIndex,/NO_COPY)

  RETURN, p[0]
END

FUNCTION QUERY_DICOM, file, info, IMAGE_INDEX = iIndex, DICOMEX=useDicomex
;+
; NAME:
; QUERY_DICOM
;
; PURPOSE:
;   This function queries image information from a DICOM format file using
; the IDLffDICOM object interface.
;
; CATEGORY:
;     Input/Output
;
; CALLING SEQUENCE:
;     Result = QUERY_DICOM(File[, info])
;
; INPUTS:
;   File: The full path name of the file to read.
;
; OPTIONAL KEYWORDS:
;       IMAGE_INDEX - Set this keyword to the index of the image to
;                     read from the file.
;
; OUTPUTS:
; This function returns 1 if the file can be read as a DICOM file
; and 0 otherwise
;
; OPTIONAL OUTPUTS:
;   Info:   An anonymous structure containing information about the image.
;       This structure is valid only when the return value of the function
;       is 1.  The Info structure has the following fields:
;
;           Field       IDL data type   Description
;           -----       -------------   -----------
;           CHANNELS    Long            Number of samples per pixel
;           DIMENSIONS  2-D long array  Size of the image in pixels
;           HAS_PALETTE Integer         True if a palette is present
;           NUM_IMAGES  Long            Number of images in the file
;           IMAGE_INDEX Long            Image number for this struct
;           PIXEL_TYPE  Integer         IDL basic type code for a pixel sample
;           TYPE        String          String identifying the file format
;
; KEYWORDS:
;   IMAGE_INDEX:  For files containing multiple images this
;       keyword can be used to specify for which image in a multi-image
;       file the information should be returned.
;
; SIDE EFFECTS:
;   IO is performed.
;
; RESTRICTIONS:
; Only uncompressed data format is supported (as per current DICOM obj).
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;   RJF, RSI.   Sep, 1998. Original version.
;   RJF, RSI.   Jan, 1999. Filter searches by sequence value.
;   CT, RSI, September 2002: Better check for interleave dimension.
;   AGEH, RSI, February, 2005: Use IDLffDicomEx object if licensed.
;-

; Set up error handling
  CATCH, errorStatus
  IF (errorStatus NE 0) THEN BEGIN
    CATCH,/CANCEL
    IF (OBJ_VALID(oDicom)) THEN OBJ_DESTROY, oDicom
    RETURN, 0L
  ENDIF

  ;; verify that the file exists
  IF ~file_test(file) THEN BEGIN
    message, 'The system cannot find the file specified'
    return, 0l
  ENDIF

  IF (n_elements(useDicomex) EQ 1) THEN $
    useDicomex = keyword_set(useDicomex) $
  ELSE $
    useDicomex = 1
  
  IF (N_ELEMENTS(iIndex) EQ 0) THEN iIndex=0
  IF (iIndex LT 0) THEN iIndex = 0

  dicomex = lmgr('idl_dicomex_rw') OR lmgr('idl_dicomex_rw_rt')

  ;; be sure to destroy before return
  oDicom = (dicomex && useDicomex && obj_class('IDLffDICOMEx')) ? $
    obj_new('idlffDicomEx', file, /NO_PIXEL_DATA) : OBJ_NEW('IDLffDICOM')

  IF (NOT OBJ_VALID(oDicom)) THEN BEGIN
    ;; if dicomex fails try again with ffdicom
    IF dicomex THEN oDicom = obj_new('IDLffDicom')
    IF ~obj_valid(oDicom) THEN BEGIN
      MESSAGE,'IDL DICOM object not supported on this platform.'
      RETURN, 0L
    ENDIF
  ENDIF

  ;; DICOM has a fatal error in accessing zero-length files
  ;; Avoid the problem by checking in advance

  OPENR, unit, file, /get_lun
  stat = FSTAT(unit)
  FREE_LUN, unit
  IF (stat.size EQ 0) THEN BEGIN
    OBJ_DESTROY, oDicom
    RETURN, 0L
  ENDIF

  IF obj_isa(oDicom, 'IDLffDicom') THEN BEGIN
    ;; using IDLffDicom object
    IF (oDicom->Read(file) NE 1) THEN BEGIN
      OBJ_DESTROY, oDicom
      RETURN, 0L
    ENDIF

    ;; Get a list of the images
    ref = oDicom->GetReference('7FE0'x,'0010'x)
    IF (SIZE(ref,/N_DIMENSIONS) EQ 0) THEN BEGIN
      OBJ_DESTROY, oDicom
      RETURN, 0L
    ENDIF
    iNum = N_ELEMENTS(ref)
    IF (iIndex GE iNum) THEN BEGIN
      OBJ_DESTROY, oDicom
      RETURN, 0L
    ENDIF

    ;; Get the image in question
    img = oDicom->GetValue(REFERENCE=ref[iIndex],/NO_COPY)
    iType = SIZE(*(img[0]),/TYPE)
    iDims = SIZE(*(img[0]),/DIMENSIONS)

    ;; Get additional image info
    iSamp = 1
    iref = oDicom->GetReference('0028'x,'0002'x)
    IF (SIZE(iref,/N_DIMENSIONS) NE 0) THEN BEGIN
      p = QueryDicomGetFirstBefore(oDicom,iref,ref[iIndex])
      IF (PTR_VALID(p)) THEN iSamp = *p
    ENDIF

    iPalette = 0
    iref = oDicom->GetReference('0028'x,'0004'x)
    IF (SIZE(iref,/N_DIMENSIONS) NE 0) THEN BEGIN
      p = QueryDicomGetFirstBefore(oDicom,iref,ref[iIndex])
      IF ((PTR_VALID(p)) AND (STRPOS(*p,"PALETTE COLOR") NE -1)) THEN BEGIN
        iPalette = 1
      END
    ENDIF

  ENDIF ELSE BEGIN
    ;; using IDLffDicomEX object
    ;; defaults
    iNum = 1
    iSamp = 0
    photo = ''
    iType = 0
    iDims = [0,0]

    IF (oDicom->QueryValue('NUMBER_OF_FRAMES') EQ 2) THEN $
      oDicom->GetProperty, NUMBER_OF_FRAMES=iNum
    IF (oDicom->QueryValue('SAMPLES_PER_PIXEL') EQ 2) THEN $
      oDicom->GetProperty, SAMPLES_PER_PIXEL=iSamp
    IF (oDicom->QueryValue('PHOTOMETRIC_INTERPRETATION') EQ 2) THEN $
      oDicom->GetProperty, PHOTOMETRIC_INTERPRETATION=photo
    IF (oDicom->QueryValue('BITS_ALLOCATED') EQ 2) THEN $
      oDicom->GetProperty, BITS_ALLOCATED=bitSize
    IF (oDicom->QueryValue('PIXEL_REPRESENTATION') EQ 2) THEN $
      oDicom->GetProperty, PIXEL_REPRESENTATION=bitSign
    IF (oDicom->QueryValue('ROWS') EQ 2) THEN $
      oDicom->GetProperty, ROWS=rows
    IF (oDicom->QueryValue('COLUMNS') EQ 2) THEN $
      oDicom->GetProperty, COLUMNS=cols

    IF (n_elements(bitSize) NE 0) THEN BEGIN
      CASE bitSize OF 
        8 : iType = 1
        16 : iType = ((n_elements(bitSign) NE 0) && bitSign) ? 2 : 12
        ELSE :
      ENDCASE
    ENDIF

    IF ((n_elements(rows) NE 0) && (n_elements(cols) NE 0)) THEN $
      iDims = [cols, rows]

    iPalette = photo EQ 'PALETTE COLOR'
  ENDELSE

    OBJ_DESTROY, oDicom

    ;; Define the info structure after error returns so that
    ;; info argument stays undefined in error cases.
    info = {CHANNELS:       0L, $
            DIMENSIONS:     [0L,0L],$
            HAS_PALETTE:    0,  $
            NUM_IMAGES:     0L,   $
            IMAGE_INDEX:    0L,   $
            PIXEL_TYPE:     0,  $
            TYPE:           ''  $
           }

    ;;   Fill in the info structure
    info.CHANNELS =     iSamp

    ;; Either indexed color, or pixel, scanline, or planar interleaved.
    ;; Note: To determine the interleave dimension, we assume that the
    ;; image is at least 5 pixels x 5 pixels. We use 4 for RGBA.
    info.DIMENSIONS = (iSamp le 1) ? [iDims[0], iDims[1]] : $
                      (iDims[0] le 4) ? [iDims[1], iDims[2]] : $
                      (iDims[1] le 4) ? [iDims[0], iDims[2]] : $
                      [iDims[0], iDims[1]]

    info.HAS_PALETTE =  iPalette
    info.NUM_IMAGES =   iNum
    info.IMAGE_INDEX =  iIndex
    info.PIXEL_TYPE =   iType
    info.TYPE=          'DICOM'

    RETURN, 1L

END
