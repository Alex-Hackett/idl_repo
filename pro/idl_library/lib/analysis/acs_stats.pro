;+
; $Id: acs_stats.pro,v 1.1 2001/11/05 20:58:59 mccannwj Exp $
;
; NAME:
;     ACS_STATS
;
; PURPOSE:
;     Routine to compute CCD signal and noise levels for darks and biases.
;
; CATEGORY:
;     ACS/Analysis
;
; CALLING SEQUENCE:
;     ACS_STATS, id, header
; 
; INPUTS:
;     id - observation id or filename
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;	h - image header
;	results - structure containing the results
;		undefined values are flagged with a -9999
;
;		results.average - average in the boxes 10x9 array
;		results.rms - rms for each box, 10x9 array
;		results.nbad - number of sigma clipped pixels in each box
;				10x9 array
;		
;		for each 10x9 array
;			array(0,0:7) - the leading overscan.
;			array(9,0:7) - the trailing overscan.
;			array(1:8,8) - the parallel overscan
;			array(1:8,0:7) - the image without the overscan
;
;		results.median_image - median of averages for image without
;				the overscan
;		results.median_leading - median of leading overscan boxes
;		results.median_trailing - median of trailing overscan boxes
;		results.median_parallel - median of parallel overscan boxes
;		results.rms_image - median of rms of the image boxes
;		results.rms_leading - median of the rms of the leading overscan
;			boxes.
;		results.rms_trailing - median of the rms of the trailing
;			overscan boxes.
;		results.rms_parallel - median of the rms of the parallel 
; 			overscan boxes.
; TEXT OUTPUT:
;	Printed text will be displayed or placed into a file as controlled
;	by !textout.
;         textout=0       Nowhere
;	  textout=1	  if a TTY then TERMINAL using /more option
;				    otherwise standard (Unit=-1) output
;	  textout=2	  if a TTY then TERMINAL without /more option
;				    otherwise standard (Unit=-1) output
;	  textout=3	  to file 'acs_stats.prt'
;	  textout=4	  laser.tmp
;	  textout=5	  user must open file
;	  textout=7	  same as 3 but text is appended to the existing
;			  acs_stats.prt if it already exists.
;
; 	For example to send the output to the file acs_stats.prt use:
;		!textout=3
;		acs_stats,id
;
;	To append the results to acs_stats.prt use:
;		!textout=7
;		acs_stats,id
;
; 	To write the results to my file use:
;		openw,15,'junk.prt'
;		!textout = 5 & !textunit = 15
;		acs_stats,id
;		close,15 & !textout = 1
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;     requires readout of full CCD or MAMA 
;
; PROCEDURE:
;	The routine divides the CCD into boxes of size M x M for the
;	image, M x N for the parallel overscan, and N x M for the serial
;	overscan.  Where N is chosen so as to ignore the first and last
;	two rows or columns of the overscan region and M is 256 for the WFC
;	and 128 for the HRC.
;	The mean and standard deviation is computed for each box
;	after deleting anomolous points (points > 5 sigma for the box median)
;	If the box sigma is less than 1 , 1 is used.
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;	version 1  D. Lindler   Dec. 7, 1998
;	Dec 15, 1998 - added SBC support with increased # of digits,
;			added MAMA global count rate
;-

PRO ACS_STATS_PRINT, h, detector, data, samp1, samp2, $
                     line1, line2, unit, results
;+
;				acs_stats_print
;
; Routine to compute CCD signal and noise levels for darks and biases.
;
; INPUTS:
;	h - fits header
;	detector - detector
;	data - image array in unrotated image coorinates
;	samp1,samp2,line1,line - non-overscan region of the image
;	unit - output unit to write the results
;
; OUTPUTS:
;	results - structure containing the results
;
; HISTORY:
;	version 1  D. Lindler   Dec. 7, 1998, created from the STIS
;		CCD_NOISE routine
;	Feb 28, 1999 Lindler, Modified to work with two amp WFC images
;-
;__________________________________________________________________________

;
;
   s = size(data) & ns = s(1) & nl = s(2)
   if ns gt 1100 then boxsize_s=256 else boxsize_s=128
   if ns gt 2100 then boxsize_s=512
   if nl gt 1100 then boxsize_l=256 else boxsize_l=128
;
; arrays to hold the results
;
   ave = fltarr(10,9)-9999
   sig = fltarr(10,9)-9999
   bad = lonarr(10,9)-9999

   for i = 0,8 do begin
;
; set line positions of box
;
      if i lt 8 then begin
         L1 = i*boxsize_l
         L2 = L1+boxsize_l-1
      end else begin
         L1 = line2+2 ;trailing parallel
         L2 = nl-2
      end
      
      for j = 0,9 do begin
;
; set sample positions of the box
;
         case 1 of
            j eq 0: begin ;leading serial
               S1 = 2
               S2 = samp1-2
            end
            j eq 9: begin ;trailing parallel
               S1 = samp2+2
               S2 = ns-2
            end
            else: 	begin
               S1 = (j-1)*boxsize_s + samp1
               S2 = S1 + boxsize_s - 1
            end
         endcase
         
;
; extract box
;
         if (s1 ge s2) or (l1 ge l2) then goto,nextbox
         box = data(S1:S2,L1:L2)
;
; determine median and filter bad data (>5 sigma from median)
;
         med = median(box)
         n = n_elements(box)
         diff = box - med

         good = where(diff le 0,ngood) ;use points less than median
                    ; to determine RMS

         rms = (sqrt(total(diff(good)^2)/ngood))>1

         good = where(abs(diff) le 5*rms,ngood)
         bad(j,i) = n-ngood
;
; determine mean and stdev of box
;
         sig(j,i) = stdev(box(good),mean)
         ave(j,i) = mean
nextbox:
      end           ; for j
   end              ; for i
;
; print results
;
   good = where(ave ne -9999)
   minave = min(ave(good))
   printf,unit,'Average Signal minus ', $
    strtrim(string(minave,'(F10.1)'))
   printf,unit,' '
   form = '(F7.1)'
   if (detector eq 'SBC') and (max(ave) lt 100) then form= '(F7.2)'
   for i=8,0,-1 do begin
      st = ''
      for j=0,9 do begin
         if ave(j,i) eq -9999 then st = st + '       ' $
         else st = st + string(ave(j,i)-minave,form)
         if (j eq 0) or (j eq 8) then st = st + '   '
      end
      printf,unit,st
      if i eq 8 then printf,unit,' '
   end

   printf,unit,' '
   printf,unit,'RMS noise'
   printf,unit,' '
   for i=8,0,-1 do begin
      st = ''
      for j=0,9 do begin
         if sig(j,i) eq -9999 then st = st + '       ' $
         else st = st + string(sig(j,i),form)
         if (j eq 0) or (j eq 8) then st = st + '   '
      end
      printf,unit,st
      if i eq 8 then printf,unit,' '
   end


   printf,unit,' '
   printf,unit,'Number of Points deleted from analysis'
   printf,unit,' '
   for i=8,0,-1 do begin
      st = ''
      for j=0,9 do begin
         if bad(j,i) eq -9999 then st = st + '       ' $
         else st = st + string(bad(j,i),'(I7)')
         if (j eq 0) or (j eq 8) then st = st + '   '
      end
      printf,unit,st
      if i eq 8 then printf,unit,' '
   end
;
   format = '(A40,F8.1)'
   if (detector eq 'SBC') and (max(ave) lt 100) then format= '(A40,F8.2)'
   if (detector eq 'SBC') and (max(ave) lt 10) then format= '(A40,F8.3)'
   for i=1,2 do printf,unit,' '
   printf,unit,'	Median signal values'
   median_leading = median(ave(0,0:7))
   if median_leading ne -9999 then $
    printf,unit,f=format,'     Leading Serial Overscan:', $
    median_leading
   median_trailing = median(ave(9,0:7))
   if median_trailing ne -9999 then $
    printf,unit,f=format,'    Trailing Serial Overscan:', $
    median_trailing

   median_parallel = median(ave(1:8,8))
   if median_parallel ne -9999 then $
    printf,unit,f=format,'  Trailing Parallel Overscan:', $
    median_parallel
   median_image = median(ave(1:8,0:7))
   if median_image ne -9999 then $
    printf,unit,f=format,'                       Image:', $
    median_image

   if median_leading ne -9999 then $
    printf,unit,f=format,'      Image - Leading Serial:', $
    median_image - median_leading

   if median_trailing ne -9999 then $
    printf,unit,f=format,'     Image - Trailing Serial:', $
    median_image - median_trailing

   if median_parallel ne -9999 then $
    printf,unit,f=format,'   Image - Trailing Parallel:', $
    median_image - median_parallel

   printf,unit,'	Median RMS values'
   
   if median_leading ne -9999 then begin
      rms_leading = median(sig(0,0:7))
      printf,unit,f=format,'     Leading Serial Overscan:', $
       rms_leading
   end else rms_leading = -9999.0

   if median_trailing ne -9999 then begin
      rms_trailing = median(sig(9,0:7))
      printf,unit,f=format,'    Trailing Serial Overscan:', $
       rms_trailing
   end else rms_trailing = -9999.0

   if median_parallel ne -9999 then begin
      rms_parallel = median(sig(1:8,8))
      printf,unit,f=format,'  Trailing Parallel Overscan:', $
       rms_parallel
   end else rms_parallel = -9999.0
   
   rms_image = median(sig(1:8,0:7))
   printf,unit,f=format,'                       Image:', $
    rms_image
;
; print mama global count rate
;
   if detector eq 'SBC' then begin
      mglobal = total(data)/sxpar(h,'exptime')
      printf,!textunit,' '
      printf,!textunit,'	MAMA GLOBAL COUNT RATE = ', $
       string(mglobal,'(F10.1)')
   end else mglobal = -9999
;
; put results in output structure
;				
   results = { average:ave, $
               rms:sig, $
               nbad:bad, $
               median_image:median_image, $
               median_leading:median_leading, $
               median_trailing:median_trailing, $
               median_parallel:median_parallel, $
               rms_image:rms_image, $
               rms_leading:rms_leading, $
               rms_trailing:rms_trailing, $
               rms_parallel:rms_parallel, $
               mglobal:mglobal }
END

pro acs_stats,id,h,results
                    ; read image in raw data coordinates
   acs_read,id,h,data,/raw
   detector = strtrim(sxpar(h,'detector'))
   s = size(data) & ns = s(1) & nl = s(2)
   amps = strtrim(sxpar(h,'ccdamp'))
   if detector eq 'SBC' then namps = 1 else namps = strlen(amps)
   if (detector eq 'WFC') and (namps lt 2) then begin
      print,'ACS_STATS: ERROR - Only 2 or 4 amp readout of WFC supported'
      retall
   endif
   if (detector eq 'HRC') and (namps gt 1) then begin
      print,'ACS_STATS: ERROR - Only single amp readout of HRC supported'
      retall
   endif
;
; open output file
;

   textopen,'acs_stats'
;
; loop on amps
;
   for i=0,namps-1 do begin
      amp = strmid(amps,i,1)
;
; page eject if not first amp
;
      if (i gt 0) or (!textout eq 7) then printf,!textunit,string(12b)
;
; print header information
;
      title = ''
      if datatype(id) ne 'STR' then title='Entry '+strtrim(id,2)+'  '
      title = title + strtrim(sxpar(h,'filename'))
      title = title + '    '+strtrim(sxpar(h,'detector'))
      title = title+'    '+sxpar(h,'date-obs')+' '+sxpar(h,'time-obs')
      printf,!textunit,title
      printf,!textunit,' '
      if detector ne 'SBC' then $
       printf,!textunit,'CCDAMP = '+strmid(amps,i,1)+ $
       '   CCDGAIN = '+strtrim(sxpar(h,'ccdgain'))+ $
       '   CCDOFF = '+strtrim(sxpar(h,'ccdoff'))
      printf,!textunit,'OBSTYPE = '+strtrim(sxpar(h,'obstype'))+'   '+ $
       '    EXPTIME = '+strtrim(sxpar(h,'exptime'),2)
      printf,!textunit,' '	
;
; print statistics
;
      if (detector ne 'WFC') then begin
         d = temporary(data)
      end else begin
         if namps eq 4 then begin
            case amp of 
               'A': d = data(0:ns/2-1,0:nl/2-1)
               'B': d = data(ns/2:*,0:nl/2-1)
               'C': d = data(0:ns/2-1,nl/2:*)
               'D': d = data(ns/2:*,nl/2:*)
            endcase
         end
         if namps eq 2 then begin
            case amp of 
               'A': d = data(*,0:nl/2-1)
               'B': d = data(*,0:nl/2-1)
               'C': d = data(*,nl/2:*)
               'D': d = data(*,nl/2:*)
            endcase
         end

      end
;
; determine non-overscan region
;
      region = [0,0,0,0]
      if (detector eq 'WFC') and (namps eq 4) then begin
         if (ns eq 4146) and (nl eq 4136) then region=[24,2071,0,2048]
         if (ns eq 4144) and (nl eq 4136) then region=[24,2071,0,2048]
      end
      if (detector eq 'WFC') and (namps eq 2) then begin
         if (ns eq 4146) and (nl eq 4136) then region=[24,4119,0,2048]
         if (ns eq 4144) and (nl eq 4136) then region=[24,4119,0,2048]
      end
      if detector eq 'HRC' then begin
         if (ns eq 1064) and (nl eq 1044) then region=[19,1043,0,1024]
         if (ns eq 1062) and (nl eq 1044) then region=[19,1043,0,1024]
      end
      if detector eq 'SBC' then begin
         if (ns eq 1024) and (nl eq 1024) then region=[0,1023,0,1023]
      end
      
      if max(region) eq 0 then begin
         print,'ACS_STATS - Error: Detector/Image size not supported'
         retall
      endif
;
; print statistics
;
      acs_stats_print,h,detector,d,region(0),region(1),region(2), $
       region(3),!textunit,results
   end
   textclose
   return
end
			
