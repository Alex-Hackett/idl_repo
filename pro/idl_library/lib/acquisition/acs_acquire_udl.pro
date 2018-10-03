;+
; $Id: acs_acquire_udl.pro,v 1.5 2002/03/12 18:07:35 mccannwj Exp $
;
; NAME:
;     ACS_ACQUIRE_UDL
;
; PURPOSE:
;     Subroutine of ACS_ACQUIRE to process internal udl packet.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     ACS_ACQUIRE_UDL, x, h
;
; INPUTS:
;     x - UDL packet
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;     h - FITS header
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
;	Written by D. Lindler   May 1998
;       10 May 2000 - added CCD Flash information
;
;-
PRO acs_acquire_udl, x, h, ERROR=error_flag

                    ; common block defined by acs_acquire_setup.pro
@acs_acquire_common.pro

   error_flag = 0b

   h = ['END     ']
   sxaddpar,h,'FILENAME',' ' ;place holder

   orig = x
   host_to_ieee,orig ;place i*2 back to ieee
;
; Programmatic Information
;
   b = BYTE(orig(8:11),0,8) ;extract bytes of programattic info
   sxaddpar,h,'ROOTNAME','J'+STRING([b(0:2)])+STRING(b(4:5))+ $
    STRING(b(6:7))
;
; Unpacking Information
;
   sxaddpar,h,'JQFSW',strtrim(xbits(x,12,0,7),2)+'.'+ $
    strtrim(xbits(x,12,8,15),2),'fsw version number'
   sxaddpar,h,'JQOBSNUMJ',x(13),'Flight Software Obs. Num.'
   longword = long(orig(14:15),0)
   ieee_to_host,longword
   sxaddpar,h,'JQNUMWDS',longword,'Number of words'
   sxaddpar,h,'JQNUMLNS',x(16),'Number of SDF lines'
;
; Image Definition
;
   n_type = xbits(x,22,0,7)
   CASE n_type OF
      1: im_type = 'memory dump data'
      2: im_type = 'ED diagnostic data'
      3: im_type = 'detector science data'
      ELSE: im_type = ' '
   ENDCASE
   sxaddpar,h,'JQIMGTYP',im_type,'Image Type'
   
   sxaddpar,h,'JQINSTR',xbits(x,22,8,15),'SI Source ID  ACS=Hex BD'
;
; memory dump words
;
   if n_type eq 1 then begin
      CASE x(23) OF
         1: source = 'WFC TSM'
         2: source = 'HRC TSM'
         3: source = 'MIE'
         4: source = 'CS'
         ELSE: source = 'Invalid'
      ENDCASE
      sxaddpar,h,'JQMDSRC',source,'Memory Dump Source'		
      longword = long(orig(24:25),0)
      ieee_to_host,longword
      sxaddpar,h,'JQMDADDR',longword,'Memory Dump Address'
      longword = long(orig(26:27),0)
      ieee_to_host,longword
      sxaddpar,h,'JQMDWDS',longword,'Number of data words dumped'
   ENDIF
;
; Eng. Data Diagnostics
;
   IF n_type EQ 2 THEN BEGIN
      mode = xbits(x,28,14,15)
      CASE mode OF
         0: amode = 'analog'
         1: amode = 'digital'
         2: amode = 'derived'
         ELSE: amode = 'INVALID'
      ENDCASE
      sxaddpar,h,'JQDDMODE',amode,'ED Diagnostic Mode'
      sxaddpar,h,'JQDDERR',xbits(x,28,13,13), $
       'ED Diagnostic Error Indicator'
      longword = long(orig(29:30),0)
      ieee_to_host,longword
      sxaddpar,h,'JQDDSAMP',longword,'Number of Samples to Collect'
      sxaddpar,h,'JQDDPER',x(31), $
       'EDD sample period (10 ms increments)'
      sxaddpar,h,'JQDDREP',x(32),'EDD Repeat Count'
      FOR i=0,15 DO BEGIN
         index1 = i*2+33
         longword = long(orig(index1:index1+1),0)
         ieee_to_host,longword
         sxaddpar,h,'JQDDIT'+strtrim(i+1,2), $
          string(longword,format='(Z8)'), $
          'Item to Collect (HEX)'
      ENDFOR
   ENDIF
;
; science data definition
;
   sxaddpar,h,'JQHDRVER',xbits(x,65,0,7),'Science Header Version Number'
   det = xbits(x,65,14,15)
   sxaddpar,h,'JQDETNO',det,'Detector Number'
   itime = x(66)
   if itime lt 0 then itime = itime + 65536 ;make unsigned
   sxaddpar,h,'JQITIME',itime/10.0,'Exposure Time (Seconds)'

   sc_time = [x(67),x(68),0]
   mie_time = long([orig(69:70)],0)
   ieee_to_host,mie_time
   csoffset = long([orig(71:72)],0)
   ieee_to_host,csoffset
   sxaddpar,h,'JQSTIME',acs_time(sc_time,mie_time,csoffset,zero_time), $
    'Exposure Start Time'

   sc_time = [x(73),x(74),0]
   mie_time = long([orig(75:76)],0)
   ieee_to_host,mie_time
   csoffset = long([orig(77:78)],0)
   ieee_to_host,csoffset
   sxaddpar,h,'JQCTIME',acs_time(sc_time,mie_time,csoffset,zero_time), $
    'Exposure Complete Time'
;
; CCD Exposure Parameters
;
   sxaddpar,h,'JQCCDXSZ',x(79),'Number of Parallel Shifted Rows in Image'
   sxaddpar,h,'JQCCDYSZ',x(80),'Number of Serial SHifted Columns in Image'
   sxaddpar,h,'JQCCDXCN',x(81),'CCD Subarray X Corner'
   sxaddpar,h,'JQCCDYCN',x(82),'CCD Subarray Y Corner'
   sxaddpar,h,'JQCCDAMP',xbits(x,83,12,15),'CCD Amps'
   sxaddpar,h,'JQCCDSEL',xbits(x,83,10,11),'normal/dark/bias select'
   select = ['INVALID','full image setup','subarray image setup', $
             'generic setup']
   sxaddpar,h,'JQCCDIND',xbits(x,83,8,9), $
    'full/subarray/generic exposure indicator'
;
; WFC Data Compression
;
   sxaddpar,h,'JQWCOMBS',x(84),'Compressed Block Size'
   sxaddpar,h,'JQWFCT1',x(85)+(x(85) lt 0)*65536, $
    'Value of T1 compression parameter'
   sxaddpar,h,'JQWFCLST',x(86)+(X(86) lt 0)*65536, $
    'Number of Blocks with Lost Data'
   longword = long(orig(87:88),0)
   ieee_to_host,longword
   sxaddpar,h,'JQWUNWDS',longword,'# of Words in uncompressed readout'
   sxaddpar,h,'JQWPOCMP',xbits(x,83,7,7),'WFC Compress Type'
   sxaddpar,h,'JQWNUMCH',xbits(x,83,4,6),'Num Channels compressed OTF'
;
; HRC Target Acquisition
;
   sxaddpar,h,'JQHCHKSZ',x(89),'Checkbox Size (px)'
   longword = long(orig(90:91),0)
   ieee_to_host,longword
   sxaddpar,h,'JQHBRITE',longword,'Counts in Brightest Checkbox'
   sxaddpar,h,'JQHTGTX',x(92),'Target X position'
   sxaddpar,h,'JQHTGTY',x(93),'Target Y position'
   sxaddpar,h,'JQHDSTX',x(94),'Target Destination X position'
   sxaddpar,h,'JQHDSTY',x(95),'Target Destination Y position'
   sxaddpar,h,'JQSLEWX',x(96)/10.0,'X Slew generated (px)'
   sxaddpar,h,'JQSLEWY',x(97)/10.0,'Y Slew generated (px)'
   CASE xbits(x,98,8,15) OF
      1: val = 'flux-weighted centroid'
      2: val = 'geometric centroid'
      ELSE: val = 'INVALID'
   ENDCASE
   sxaddpar,h,'JQHCENT',val,'Centroid Indicator'
   sxaddpar,h,'JQHDEST',xbits(x,98,0,7),'Target Destination'
   sxaddpar,h,'JQHREST',xbits(x,99,15,15),'CCD Data Resorted Indicator'
   code = xbits(x,99,0,7)
   CASE code OF
      255 : val = 'Target Acquisition Successful'
      0 : val = 'target acquisition did not occur'
      1 : val = 'TDF was down before slew request'
      2 : val = 'magnitude of slew to target is 0'
      3 : val = 'slew request confirmation from NSSC-1 not recieved'
      4 : val = 'TDF did not go down after slew request'
      5 : val = 'TDF did not come back up'
      else: val = 'UNKNOWN'
   ENDCASE
   sxaddpar,h,'JQHTACQ',code,'Target Acq. Success/Fail Code'
   sxaddpar,h,'TACQTEXT',val,'decoded JQHTACQ'
   sxaddpar,h,'JQHOFSTX',x(100),'(pixels) X slew before second TACQ image'
   sxaddpar,h,'JQHOFSTY',x(101),'(pixels) Y slew before second TACQ image'
   sxaddpar,h,'JQDDWCVT',x(102),'Number of WFC Samples from CVT'
   sxaddpar,h,'JQDDHCVT',x(103),'Number of HRC Samples from CVT'
;
; control section information
;
   sxaddpar,h,'JQMEBID',xbits(x,115,15,15),'MEB ID 0=MEB 1  1=MEB 2'
   sxaddpar,h,'JQSWMODE',xbits(x,115,14,14),'FSW Mode Indicator'
   sxaddpar,h,'JQNULIMG',xbits(x,115,13,13),'Null Image Indicator'
   sxaddpar,h,'JQWCSTA',xbits(x,115,12,12),'WFC CEB ED Col. Status for R/O'
   sxaddpar,h,'JQHCSTA',xbits(x,115,11,11),'HRC CEB ED Col. Status for R/O'
;
; CCD Exposure Error Flags
;
   sxaddpar,h,'JQERRETO',xbits(x,116,15,15),'CCD Exposure Timeout'
   sxaddpar,h,'JQERRETM',xbits(x,116,14,14), $
    'CCD Exp. Timing Patt. ID Mismatch'

   sxaddpar,h,'JQERRCLO',xbits(x,116,13,13),'CCD Shutter Not Closed at end'
   sxaddpar,h,'JQERRFFO',xbits(x,116,12,12),'CCD FIFOs Not Available'
   sxaddpar,h,'JQERRRTO',xbits(x,116,11,11),'CCD Readout Timeout'
   sxaddpar,h,'JQERRRTM',xbits(x,116,10,10), $
    'CCD R/O Timing Patt. ID Mismatch'
   sxaddpar,h,'JQERRSHD',xbits(x,116,9,9), $
    'CCD Shutter Motor Disabled (Exp. Start)'
;
; MAMA Exposure Flags
;
   sxaddpar,h,'JQMABOR',xbits(x,117,15,15),'SBC MAMA Exposure Aborted'
   sxaddpar,h,'JQMTO',xbits(x,117,14,14),'SBC MAMA Exposure Timeout'
   sxaddpar,h,'JQDMATO',xbits(x,117,13,13),'MIE DMA Timeout'
   sxaddpar,h,'JQBADMD',xbits(x,117,12,12),'Invalid MIE Software Mode'
   sxaddpar,h,'JQMALEVT',xbits(x,117,10,11), $
    'SBC MAMA Local Event Threshold Exceeded'
   sxaddpar,h,'JQMIEEXC',xbits(x,117,9,9),'MIE Processor Exception'
   sxaddpar,h,'JQMAEXER',xbits(x,117,8,8),'SBC MAMA Exposure Start Error'
   sxaddpar,h,'JQMIEERR',xbits(x,117,7,7),'MIE Commanding Error'

   sxaddpar,h,'JQMFFOV',x(118),'Number of MIE SD FIFO Overflows'
;
; Filter Wheels
;
   sxaddpar,h,'JQFW1ID',x(119),'WFC/HRC FW1 Filter Number'
   sxaddpar,h,'JQFW1OFF',x(120),'WFC/HRC FW1 Offset'
   sxaddpar,h,'JQFW1ABS',x(121),'WFC/HRC FW1 Absolute Steps'
   sxaddpar,h,'JQFW1REL',x(122),'WFC/HRC FW1 Relative Steps'
   sxaddpar,h,'FW1POS',(4320L*10+x(120)+x(121)+x(122)) mod 4320, $
    'FW1 Position JQFW1OFF+JQFW1ABS+JQFW1REL mod 4320'

   sxaddpar,h,'JQFW2ID',x(123),'WFC/HRC FW2 Filter Number'
   sxaddpar,h,'JQFW2OFF',x(124),'WFC/HRC FW2 Offset'
   sxaddpar,h,'JQFW2ABS',x(125),'WFC/HRC FW2 Absolute Steps'
   sxaddpar,h,'JQFW2REL',x(126),'WFC/HRC FW2 Relative Steps'
   sxaddpar,h,'FW2POS',(4320L*10+x(124)+x(125)+x(126)) mod 4320, $
    'FW2 Position JQFW2OFF+JQFW2ABS+JQFW2REL mod 4320'

   sxaddpar,h,'JQFWSID',x(127),'SBC FW Filter Number'
   sxaddpar,h,'JQFWSOFF',x(128),'SBC FW Offset'
   sxaddpar,h,'JQFWSABS',x(129),'SBC FW Absolute Steps'
   sxaddpar,h,'JQFWSREL',x(130),'SBC FW Relative Steps'
   sxaddpar,h,'FW3POS',(4320L*10+x(128)+x(129)+x(130)) mod 4320, $
    'FW3 Position JQFWSOFF+JQFWSABS+JQFWSREL mod 4320'

;
; Other Mechanisms
;
   sxaddpar,h,'JQFOLDPS',xbits(x,131,15,15),'Fold Mechanism Position 0-HRC 1-SBC'
   sxaddpar,h,'JQCALDOR',xbits(x,131,13,14),'Calibration Door Position'
   sxaddpar,h,'JQFW1CCD',xbits(x,131,11,12),'FW1 Target CCD'
   sxaddpar,h,'JQFW2CCD',xbits(x,131,9,10),'FW2 Target CCD'
   sxaddpar,h,'JQFW1ERR',xbits(x,131,8,8),'WFC/HRC FW1 Error'
   sxaddpar,h,'JQFW2ERR',xbits(x,131,7,7),'WFC/HRC FW2 Error'
   sxaddpar,h,'JQFWSERR',xbits(x,131,6,6),'SBC FW Error'

;
; Cal Lamp Info
;
   sxaddpar,h,'JQTLAMP1',xbits(x,132,15,15),'Tungsten Lamp 1 Status 1=on'
   sxaddpar,h,'JQTLAMP2',xbits(x,132,14,14),'Tungsten Lamp 2 Status 1=on'
   sxaddpar,h,'JQTLAMP3',xbits(x,132,13,13),'Tungsten Lamp 3 Status 1=on'
   sxaddpar,h,'JQTLAMP4',xbits(x,132,12,12),'Tungsten Lamp 4 Status 1=on'
   sxaddpar,h,'JQDLAMP',xbits(x,132,11,11),'Deuterium Lamp Status 1=on'
;
; CCD Readout Info
;
   sc_time = [x(133),x(134),0]
   mie_time = long([orig(135:136)],0)
   ieee_to_host,mie_time
   csoffset = long([orig(137:138)],0)
   ieee_to_host,csoffset
   sxaddpar,h,'JQSREAD',acs_time(sc_time,mie_time,csoffset,zero_time), $
    'CCD Readout Start Time'

   sc_time = [x(139),x(140),0]
   mie_time = long([orig(141:142)],0)
   ieee_to_host,mie_time
   csoffset = long([orig(143:144)],0)
   ieee_to_host,csoffset
   sxaddpar,h,'JQCREAD',acs_time(sc_time,mie_time,csoffset,zero_time), $
    'CCD Readout Complete Time'
   
   longword = long(orig(145:146),0)
   ieee_to_host,longword
   sxaddpar,h,'JQFFOWD',longword, $
    '# of Words Remaining to be R/O per Active FIFO'
;
; CCD Gains
;
   sxaddpar,h,'JQWGAIA',xbits(x,147,14,15),'WFC Gain A'
   sxaddpar,h,'JQWGAIB',xbits(x,147,12,13),'WFC Gain B'
   sxaddpar,h,'JQWGAIC',xbits(x,147,10,11),'WFC Gain C'
   sxaddpar,h,'JQWGAID',xbits(x,147,8,9),'WFC Gain D'

   sxaddpar,h,'JQHGAIA',xbits(x,148,14,15),'HRC Gain A'
   sxaddpar,h,'JQHGAIB',xbits(x,148,12,13),'HRC Gain B'
   sxaddpar,h,'JQHGAIC',xbits(x,148,10,11),'HRC Gain C'
   sxaddpar,h,'JQHGAID',xbits(x,148,8,9),'HRC Gain D'
;
; CCD Offsets
;
   sxaddpar,h,'JQWOFFA',xbits(x,149,13,15),'WFC Offset A'
   sxaddpar,h,'JQWOFFB',xbits(x,149,10,12),'WFC Offset B'
   sxaddpar,h,'JQWOFFC',xbits(x,149,7,9),'WFC Offset C'
   sxaddpar,h,'JQWOFFD',xbits(x,149,4,6),'WFC Offset D'

   sxaddpar,h,'JQHOFFA',xbits(x,150,13,15),'HRC Offset A'
   sxaddpar,h,'JQHOFFB',xbits(x,150,10,12),'HRC Offset B'
   sxaddpar,h,'JQHOFFC',xbits(x,150,7,9),'HRC Offset C'
   sxaddpar,h,'JQHOFFD',xbits(x,150,4,6),'HRC Offset D'
;
; CCD Overscan Info
;
   sxaddpar,h,'JQPHOSAC',xbits(x,151,8,15),'Physical Overscan AC'
   sxaddpar,h,'JQPHOSBD',xbits(x,151,0,7),'Physical Overscan BD'
   sxaddpar,h,'JQVOSAMP',xbits(x,152,8,15),'Virtual Overscan Per Amp'
;
; CCD Flash 
;
   sxaddpar,h,'JQCFDURC',x(171)*0.1,'Commanded Flash Duration (Sec)'
   sxaddpar,h,'JQCFDURA',x(172)*0.1,'Actual Flash Duration (Sec)'
   sxaddpar,h,'JQCFLERR',xbits(x,173,0,11), $
    'Error code reported from JCCDFLSH Macro'
   sxaddpar,h,'JQCFABRT',xbits(x,173,12,12),'Flash Abort Indicator'
   index = xbits(x,173,13,14)
   values = ['OFF','LOW','MED','HIGH']
   sxaddpar,h,'JQCFLCUR',values(index),'Flash Current (OFF,LOW,MED,HIGH)'
   sxaddpar,h,'JQCFLSUC',xbits(x,173,15,15),'Flash Success Indicator' 
;
; TDF Log
;
   sxaddpar,h,'JQTDFSTA',xbits(x,174,15,15),'TDF Monitoring Status'
   sxaddpar,h,'JQTDFINI',xbits(x,174,14,14),'Initial TDF State'

   sxaddpar,h,'JQTDFINT',x(175),'Number of TDF Interupts'
   FOR i=0,5 DO BEGIN

      st = strtrim(i+1,2)
      ioff = 175+i*6
      sc_time = [x(ioff),x(ioff+1),0]
      mie_time = long([orig(ioff+2:ioff+3)],0)
      ieee_to_host,mie_time
      csoffset = long([orig(ioff+4:ioff+5)],0)
      ieee_to_host,csoffset
      sxaddpar,h,'JQTDFTD'+st, $
       acs_time(sc_time,mie_time,csoffset,zero_time), $
       'Time of TDF Down #'+st

      ioff = ioff + 6
      sc_time = [x(ioff),x(ioff+1),0]
      mie_time = long([orig(ioff+2:ioff+3)],0)
      ieee_to_host,mie_time
      csoffset = long([orig(ioff+4:ioff+5)],0)
      ieee_to_host,csoffset
      sxaddpar,h,'JQTDFTR'+st, $
       acs_time(sc_time,mie_time,csoffset,zero_time), $
       'Time of TDF Resume #'+st
   ENDFOR

   return
END
