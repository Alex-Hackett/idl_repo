;+
; $Id: acs_acquire_header.pro,v 1.4 2001/03/01 03:53:02 mccannwj Exp $
;
; NAME:
;     ACS_ACQUIRE_HEADER
;
; PURPOSE:
;     Subroutine of ACS_ACQUIRE to create the science data header.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     ACS_ACQUIRE_HEADER, h, h1, h2, hout
; 
; INPUTS:
;     h - science header line header from acs_acquire_udl
;     h1 - first eng. snapshot header
;     h2 - second eng. snapshot header
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     ERROR - returns exit status of routine
;
; OUTPUTS:
;     hout - output science header
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
;     Mar 5, 1999, added obstype = DARK for SBC images.
;     May 10, 2000 - added FLASH information
;     Feb 28, 2001 - fixed filter offset naming error  
;
;-
PRO acs_acquire_header, h, h1, h2, hout, ERROR=error_flag

@acs_acquire_common.pro

   error_flag = 0b

   hout = ['END      ']
   sxaddpar,hout,'instrume','ACS','HST Instrument'
   sxaddpar,hout,'rootname',sxpar(h,'rootname')
   sxaddpar,hout,'filename',sxpar(h,'filename'),'File Identification'
   sxaddpar,hout,'instrume','ACS','Science Instrument'
   im_type = sxpar(h,'jqimgtyp')
;
; memory dump -------------------------------------------------------------
;
   IF im_type EQ 'memory dump data' THEN BEGIN
      sxaddpar,hout,'OBSTYPE','MEMDUMP','Memory Dump'
      keywords =['JQIMGTYP','JQIMGTYP','JQMDSRC','JQMDADDR','JQMDWDS']
      FOR i=0,N_ELEMENTS(keywords)-1 DO BEGIN
         val = sxpar(h,keywords(i),COMMENT=comment)
         sxaddpar,hout,keywords(i),val,comment
      ENDFOR
      GOTO, done
   ENDIF
;
; Eng. Data Diag. ---------------------------------------------------------
;
   IF im_type EQ 'ED diagnostic data' THEN BEGIN
      sxaddpar,hout,'obstype','ENGDIAG','Eng. Data Diagnostic'
      keywords = ['JQDDMODE','JQDDERR','JQDDSAMP','JQDDPER','JQDDREP']
      FOR i=0,N_ELEMENTS(keywords)-1 DO BEGIN
         val = sxpar(h,keywords(i),comment=comment)
         sxaddpar,hout,keywords(i),val,comment
      ENDFOR
      FOR i=1,16 DO BEGIN
         keyword = 'JQDDIT'+STRTRIM(i,2)	
         val = sxpar(h,keyword,comment=comment)
         sxaddpar,hout,keyword,val,comment
      ENDFOR
      GOTO, done
   ENDIF
;
; Science Data -----------------------------------------------------------
;
;
; decode obstype
;
   jqccdsel = sxpar(h,'jqccdsel')
   jqcaldor = sxpar(h,'jqcaldor')
   jqhdest = sxpar(h,'jqhdest')
   CASE jqccdsel OF
      1: obstype = 'DARK'
      2: obstype = 'BIAS'
      ELSE: BEGIN
         CASE jqcaldor OF
            1: obstype = 'INTERNAL'
            2: obstype = 'CORON'
            0: IF jqhdest EQ 0 THEN obstype='EXTERNAL' $
            ELSE obstype='TARG_ACQ'
            ELSE: obstype = 'UNKNOWN'
         ENDCASE
      END
   ENDCASE
   IF (sxpar(h,'jqdetno') EQ 3) AND  $
    (sxpar(h,'jqfoldps') EQ 0) THEN obstype = 'DARK'
   sxaddpar,hout,'OBSTYPE',obstype

   sxaddpar,hout,'stimulus','        ','Calibration Source Select'
   sxaddpar,hout,'environ','        ','Calibration Location Select'
;
; sclamp
;
   keywords = ['jqdlamp','jqtlamp1','jqtlamp2','jqtlamp3','jqtlamp4']
   lamps = ['DEUTERIUM','TUNGSTEN-1','TUNGSTEN-2','TUNGSTEN-3', $
            'TUNGSTEN-4']
   sclamp = 'NONE'
   FOR i=0,4 DO IF sxpar(h,keywords(i)) GT 0 THEN sclamp=lamps(i)
   sxaddpar,hout,'SCLAMP',sclamp,'Internal Calibration Lamp Select'
;
; detector
;
   jqdetno = sxpar(h,'jqdetno')
   detectors = ['NONE','WFC','HRC','SBC']
   detector = detectors(jqdetno)
   sxaddpar,hout,'detector',detector
   sxaddpar,hout,'detectid','      ','Detector Build identification'
;
; filters
;
   keyin = ['FW1POS','FW1POS','JQFW1OFF', $
            'FW2POS','FW2POS','JQFW2OFF', $
            'FW3POS','FW3POS','JQFWSOFF']
   keyout = ['FILTER1','FW1POS','FW1OFF', $
             'FILTER2','FW2POS','FW2OFF', $
             'FILTER3','FW3POS','FW3OFF']
   FOR i=0,N_ELEMENTS(keyin)-1 DO BEGIN
      wheel = i/3+1
      IF (i MOD 3) EQ 0 THEN BEGIN
         filter_pos = sxpar(h,keyin(i))
         val = '        '
         comment = 'Filter Wheel '+STRTRIM(wheel,2)+' Filter Select'
         IF jqdetno GT 0 THEN BEGIN
            good = WHERE((filter_wheel eq wheel))
            positions = filter_wheel_pos(good,jqdetno-1)
            IF positions(0) NE -1 THEN BEGIN
               offkey = keyin[i+2]
               offset = sxpar(h,offkey)
               diff = positions - filter_pos + offset
               diff = diff + (diff LT -3000)*4320 -(diff gt 3000)*4320
               diff = ABS(diff)
               best = WHERE(diff EQ MIN(diff))
               val = filter_name(good[best[0]])
            ENDIF
         ENDIF
      ENDIF ELSE BEGIN
         val = sxpar(h,keyin(i),comment=comment)
      ENDELSE
      sxaddpar,hout,keyout(i),val,comment
   ENDFOR 
;
; Mechanisms
;
   foldpos = ['HRC','SBC']
   sxaddpar,hout,'FOLDPOS',foldpos(sxpar(h,'jqfoldps')), $
    'Fold Mechanism Position'
   caldor = ['RETRACT','DEPLOY','CORONAGRAPH','INVALID']
   sxaddpar,hout,'CALDOOR',caldor(sxpar(h,'jqcaldor')), $
    'Cal Door Position Select'
;
; Resolver Positions
;
   keyin = ['JWRESPOS','JHRESPOS','JWFCSPOS','JWINNPOS','JWOUTPOS', $
            'JHFCSPOS','JHINNPOS','JHOUTPOS']
   keyout = ['WSHUTPOS','HSHUTPOS','WFOCPOS','WINNPOS','WOUTPOS', $
             'HFOCPOS','HINNPOS','HOUTPOS']
   FOR i=0,N_ELEMENTS(keyin)-1 DO BEGIN
      val = sxpar(h1,keyin(i),comment=comment)
      sxaddpar,hout,keyout(i),val,comment
   ENDFOR
;
; CCD amp
;
   jqccdamp = sxpar(h,'jqccdamp')
   CASE jqccdamp OF
      1: amp = 'A'
      2: amp = 'B'
      4: amp = 'C'
      8: amp = 'D'
      5: amp = 'AC'
      9: amp = 'AD'
      6: amp = 'BC'
      10: amp = 'BD'
      15: amp = 'ABCD'
      ELSE: amp = 'INVALID'
   ENDCASE
   sxaddpar,hout,'CCDAMP',amp,'CCD Amplifier Readout Select'
;
; CCD gains
;	
   comment = 'CCD Gain'
   if detector eq 'WFC' then st = 'JQWGAI' else st='JQHGAI'
   gain = 2^sxpar(h,st+STRMID(amp,0,1),comment=comment)
   sxaddpar,hout,'ccdgain',gain,comment

; CCD offsets
;
   comment = 'CCD Offset'
   IF detector EQ 'WFC' THEN st = 'JQWOFF' ELSE st='JQHOFF'
   off = sxpar(h,st+STRMID(amp,0,1),comment=comment)
   sxaddpar,hout,'ccdoff',off,comment
;
; CCD Temperature
;
   IF detector EQ 'WFC' THEN key='JWTECTCT' ELSE key='JHTECTCT'
   val = sxpar(h1,key,comment=comment)
   sxaddpar,hout,'CCDTEMPC',val,'TEC Temp Ctrl Temp. (dgC)'
   key = ['CCDTEMP1','CCDTEMP2','CCDTEMP1','CCDTEMP2','SBCTEMP']
   comments = ['HRC Detector temperature 1', $
               'HRC Detector temperature 2', $
               'WFC Detector temperature 1', $
               'WFC Detector temperature 2']
   IF detector EQ 'WFC' THEN $
    FOR i=2,3 DO sxaddpar,hout,key(i),shpvals(i),comments(i) $
   ELSE FOR i=0,1 DO sxaddpar,hout,key(i),shpvals(i),comments(i)
;
; CCD Overscan
;
   keyin = ['JQPHOSAC','JQPHOSBD','JQVOSAMP']
   keyout = ['OVER_AC','OVER_BD','OVER_V']
   FOR i=0,N_ELEMENTS(keyin)-1 DO BEGIN
      val = sxpar(h,keyin(i),comment=comment)
      sxaddpar,hout,keyout(i),val,comment
   ENDFOR

;
; Subarrays
;
   vals = ['FULL','FULL','SUBARRAY','GENERIC']
   jqccdind = sxpar(h,'jqccdind')
   sxaddpar,hout,'SUBARRAY',vals(jqccdind), $
    'Full/Subarray/Generic Exposure Ind.'
   IF jqccdind EQ 2 THEN BEGIN
      keyin = ['JQCCDXSZ','JQCCDYSZ','JQCCDXCN','JQCCDYCN']
      keyout = ['CCDXSIZ','CCDYSIZ','CCDXCOR','CCDYCOR']
      FOR i=0,3 DO BEGIN
         val = sxpar(h,keyin(i),comment=comment)
         sxaddpar,hout,keyout(i),val,comment
      ENDFOR
   ENDIF
;
; FLASH Information
;
   sxaddpar,hout,'FLASHDUR',sxpar(h,'JQCFDURA'), $
    'Flash Duration actual (sec)'
   sxaddpar,hout,'FLASHCUR',sxpar(h,'JQCFLCUR'), $
    'Flash Current (OFF,LOW,MED,HIGH)'
   CASE 1 OF 
      sxpar(h,'JQCFDURC') eq 0: value = 'NONE'
      sxpar(h,'JQCFABRT') eq 1: value = 'ABORTED'
      sxpar(h,'JQCFLSUC') eq 0: value = 'OKAY'
      ELSE: value = 'UNKNOWN'
   ENDCASE
   sxaddpar,hout,'FLSHSTAT',value,'Flash Status (NONE,ABORTED,OKAY)'
;
; MAMA junk
;
   sxaddpar,hout,'SBCTEMP',shpvals(4),'MAMA Tube Temperature'
   sxaddpar,hout,'MCPVOLT',sxpar(h1,'JMMCPV'),'SBC MAMA MCP VOLTAGE'
   sxaddpar,hout,'FIELDVLT',sxpar(h1,'JMFIELDV'),'SBC MAMA FIELD VOLTAGE'
   sxaddpar,hout,'MFIFOVR',sxpar(h,'jqmffov'), $
    'Number of SBC MAMA Overflow Events'
;
; Time
;
   time = sxpar(h,'jqstime')
   date = STRMID(time,0,11)
   dd = STRMID(date,0,2)
   mon = STRMID(date,3,3)
   yy = STRMID(date,9,2)
   CASE mon OF 
      'JAN':  mm = '01'
      'FEB':  mm = '02'
      'MAR':  mm = '03'
      'APR':  mm = '04'
      'MAY':  mm = '05'
      'JUN':  mm = '06'
      'JUL':  mm = '07'
      'AUG':  mm = '08'
      'SEP':  mm = '09'
      'OCT':  mm = '10'
      'NOV':  mm = '11'
      'DEC':  mm = '12'
      ELSE: BEGIN
         PRINT, 'ACS_ACQUIRE: ERROR - Unknown date format'
         error_flag = 1b
         return
      END 
   ENDCASE

   date = dd + '/' + mm + '/' + yy
   sxaddpar,hout,'date-obs',date, $
    'Date of start of the observation (DD/MM/YY)'
   sxaddpar,hout,'time-obs',STRMID(time,12,11),'Time of start of observation'
   sxaddpar,hout,'fpkttime',sxpar(h,'fpkttime'),'Time of first packet'
   sxaddpar,hout,'exptime',sxpar(h,'jqitime'),'Exposure time (seconds)'
   IF STRTRIM(time) EQ '' THEN mjd = 0 ELSE mjd = jul_date(time)-0.5
   sxaddpar,hout,'expstart',mjd,'Exposure Start Time (MJD)',format='F15.7'
   t = sxpar(h,'jqctime')
   IF STRTRIM(t) EQ '' THEN mjd = 0 ELSE mjd = jul_date(time)-0.5
   sxaddpar,hout,'expend',t,'Exposure End Time (MJD)',format='F15.7'
;
; Target Acq Parameters
;
   istat = sxpar(h,'jqhtacq')
   CASE istat OF
      0: val = 'Offset Not Computed'
      1: val = 'TDF Down'
      2: val = 'Null offset computed'
      3: val = 'Slew not acknowledged'
      4: val = 'No TDF response'
      5: val = 'No TDF response'
      255: val = 'SUCCESSFUL'
      ELSE: val = STRTRIM(i,2)
   ENDCASE
   IF obstype ne 'TARG_ACQ' THEN val = 'N/A'

   sxaddpar,hout,'TASTATUS',val,'Target Acquisition Status'
   keyin = ['JQHCHKSZ','JQHBRITE','JQHTGTX','JQHTGTY']
   keyout= ['CHKBXSIZ','MAXCOUNT','TARGETX','TARGETY']
   FOR i=0,N_ELEMENTS(keyin)-1 DO BEGIN
      val = sxpar(h,keyin(i),COMMENT=comment)
      sxaddpar,hout,keyout(i),val,comment
   ENDFOR

   jqhdest = sxpar(h,'jqhdest')
   vals = [' ','HRC-CORON0.8','HRC-CORON1.8','HRC-CORON3.0']
   sxaddpar,hout,'aperture',vals(jqhdest),'Target Destination Spot Select'

   keyin = ['JQHDSTX','JQHDSTY','JQSLEWX','JQSLEWY','JQHOFSTX','JQHOFSTY']
   keyout = ['APERX','APERY','SLEWX','SLEWY','DOFFX','DOFFY']
   FOR i=0,N_ELEMENTS(keyin)-1 DO BEGIN
      val = sxpar(h,keyin(i),comment=comment)
      sxaddpar,hout,keyout(i),val,comment
   ENDFOR
;
; Compression
;
   keyin = ['JQWCOMBS','JQWFCT1','JQWFCLST','JQWUNWDS']
   keyout = ['CBLKSIZ','WFCT1','BLKSLOST','UNCWRDS']
   FOR i=0,N_ELEMENTS(keyin)-1 DO BEGIN
      val = sxpar(h,keyin(i),comment=comment)
      sxaddpar,hout,keyout(i),val,comment
   ENDFOR
;
; meb
;
   i = sxpar(h,'jqmebid')
   sxaddpar,hout,'mebid',i+1,'Identification of MEB in use'
;
; SHP temperatures
;
done:
   sxaddpar,hout,'SHPFILE',shpfile,'SHP file name'
   sxaddpar,hout,'SHPTIME',shptime,'SHP Dump Packet Time'
   sxaddpar,hout,'FSW_VER',sxpar(h,'JQFSW'),'FSW Build'
   sxaddpar,hout,'ACQ_VER',sxpar(h,'ACQ_VER'),'ACS_ACQUIRE version number'
   return
END
