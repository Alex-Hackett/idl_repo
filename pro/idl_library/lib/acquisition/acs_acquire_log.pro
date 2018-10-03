;+
; $Id: acs_acquire_log.pro,v 1.2 2000/09/26 13:47:41 mccannwj Exp $
;
; NAME:
;     ACS_ACQUIRE_LOG
;
; PURPOSE:
;     Subroutine of ACS_ACQUIRE to add an observation to the acs_log
;     catalog.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     ACS_ACQUIRE_LOG, header, hudl, data, entry
; INPUTS:
;     header - FITS header
;     hudl   - UDL header
;     data   - data array
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;     entry - data base entry vector
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
;	version 1  D. Lindler  July, 1998
;	15 Dec 1998, D. Lindler, added STUFF info
;       10 May 2000, McCann, added Flash info
;
;-
PRO acs_acquire_log, h, hudl, d, entry, ERROR=error_flag

   error_flag = 0b

                    ; list of header keywords to extract
   list1 = ['FILENAME','ROOTNAME','OBSTYPE','DATE-OBS','TIME-OBS', $
            'EXPSTART','EXPEND','EXPTIME','STIMULUS','ENVIRON','SCLAMP', $
            'DETECTOR','DETECTID','OVER_AC','OVER_BD','OVER_V', $
            'CCDAMP','CCDGAIN','CCDOFF', 'FILTER1','FW1POS', $
            'FW1OFF','FILTER2','FW2POS','FW2OFF','FILTER3','FW3POS', $
            'FW3OFF','FOLDPOS','CALDOOR','WSHUTPOS','HSHUTPOS','WFOCPOS', $
            'WINNPOS','WOUTPOS','HFOCPOS','HINNPOS','HOUTPOS','SUBARRAY', $
            'CCDXSIZ','CCDYSIZ','CCDXCOR','CCDYCOR','MCPVOLT','FIELDVLT', $
            'CCDTEMPC','CCDTEMP1','CCDTEMP2','SBCTEMP', $
            'MFIFOVR','TASTATUS','CHKBXSIZ','MAXCOUNT']
   list2 = ['TARGETX','TARGETY','APERTURE','APERX','APERY','SLEWX', $
            'SLEWY','DOFFX ','DOFFY','CBLKSIZ','WFCT1','BLKSLOST', $
            'UNCWRDS','MEBID','FSW_VER','ACQ_VER','RCFILE', $
            'RASCCHNL','RASCAPER', $
            'RASCFOC','TM2TIP','TM2TILT','RADMETER','RADSIGNL','LAMP', $
            'LAMP_I','FILTERA','FILTERB','FILTERC','FILTERD','FILTERE', $
            'FILTERF','FILTERX','POLANGLE','MONOWAVE','MONOGRTG', $
            'MONONSLT','MONOXSLT','SHPTIME','SHPFILE']
   list3 = ['STFFILE','STFTIME1','STFTIME2','STFMODE','STFTARG', $
            'STFATTEN','RADSGNL1','RADSGNL2','RADTIME1','RADTIME2', $
            'RAD_I1','RAD_I2','RAD_V1','RAD_V2','RAD_HV1','RAD_HV2', $
            'LAMP_I1','LAMP_I2','LAMP_V1','LAMP_V2']
   list4 = ['FLASHDUR','FLASHCUR','FLSHSTAT']
   list = [list1,list2,list3,list4]
   
   FOR i=0,N_ELEMENTS(list)-1 DO BEGIN
      val = sxpar(h,list(i))
      IF datatype(val) EQ 'STR' THEN BEGIN 
         val = STRTRIM(val)
         IF val EQ '/' THEN val = ''
      ENDIF
      IF !ERR GE 0 THEN dbput,list[i],val,entry
   ENDFOR

   dbput,'naxis1',N_ELEMENTS(d[*,0]),entry
   dbput,'naxis2',N_ELEMENTS(d[0,*]),entry

   IF STRTRIM(sxpar(h,'detector')) EQ 'SBC' THEN BEGIN
      expo = sxpar(h,'exptime')
      IF expo GT 0 THEN dbput,'mglobal',TOTAL(d)/expo,entry
   ENDIF

   return
END
