;+
; NAME:
;   stats
; PURPOSE: (one line)
;   Compute and print statistics plus plot histogram of data.
; DESCRIPTION:
;   This computes basic statistical information regarding the input data and
;   prints it to the screen.  It is intended for purely interactive work,
;   use MOMENT if you want to save the results to a variable.
; CATEGORY:
;   Numerical
; CALLING SEQUENCE:
;   stats,data
; INPUTS:
;   data - Input data (any rank, or type).
; OPTIONAL INPUT PARAMETERS:
; KEYWORD INPUT PARAMETERS:
;  NBINS  - number of bins for histogram (default = 750)
;  ROBO   - If set, compute robust statistics.
;  SILENT - If set, supresses printed output to the screen
;  TITLE  - Title for plot (default is blank)
;  XTITLE - X-axis title for plot (default is 'Data Numbers')
; OUTPUTS:
; KEYWORD OUTPUT PARAMETERS:
;  MEAN   - Optional return on mean of sample.
; COMMON BLOCKS:
; SIDE EFFECTS:
; RESTRICTIONS:
; PROCEDURE:
; MODIFICATION HISTORY:
;    Written by Marc W. Buie, Lowell Observatory, 1993/5/14
;    MWB, 1993/9/23, Added ROBO keyword
;    MWB, 1995/1/12, Added SILENT keyword
;    MWB, 1995/3/29, Augment plot to include mean and sigma annotation.
;    MWB, 1996/7/15, Added MEAN keyword
;    MWB, 2004/7/08, Added NaN exclusion for non-robust statistics
;    MWB, 2008/04/09, added CHARSIZE keyword pass through to plot
;-
pro stats,data,ROBO=robo,SILENT=silent,TITLE=title,NBINS=nbins,XTITLE=xtitle, $
            MEAN=avg,charsize=charsize

   if badpar(data,[1,2,3,4,5,12,13,14,15],[1,2,3,4,5,6,7,8], $
                caller='STATS: (data) ',type=datatype) then return
   if badpar(nbins,[0,2,3,4,5],0,CALLER="STATS: (nbins) ",DEFAULT=750) then return
   if badpar(title,[0,7],0,CALLER="STATS: (title) ",DEFAULT='') then return
   if badpar(xtitle,[0,7],0,CALLER="STATS: (xtitle) ",DEFAULT='Data Numbers') then return
   if badpar(charsize,[0,2,3,4,5],0,CALLER="STATS: (CHARSIZE) ",DEFAULT=1.0) then return

   if keyword_set(robo) then begin
      robomean,data,3.0,0.5,avg,avgdev,stddev,var,skew,kurt,nfinal,new
      min_data = min(new)
      max_data = max(new)
   endif else begin
      moment4,data,avg,avgdev,stddev,var,skew,kurt
      min_data = min(data,/nan)
      max_data = max(data,/nan)
      nfinal = n_elements(data)
   endelse

   if not keyword_set(silent) then begin
      print,'Input data contained ',nfinal,' values.'
      print,'Minimum in data             = ',min_data
      print,'Maximum in data             = ',max_data
      print,'Average                     = ',avg
      print,'Average deviation (scatter) = ',avgdev
      print,'Standard deviation          = ',stddev
      print,'Standard deviation from mean= ',stddev/sqrt(nfinal-1.0)
      print,'Variance                    = ',var
      print,'Skew                        = ',skew
      print,'Kurtosis                    = ',kurt
   endif

   binsz = (max_data-min_data)/float(nbins)
   if binsz eq 0 then begin
      print,'Min and max are the same, unable to plot histogram.'
      return
   endif

   if datatype le 3 then begin
      binsz = long(binsz + 0.5)
      if binsz eq 0 then binsz=1
   endif

   if keyword_set(robo) then $
      hist = histogram(new,binsize=binsz,min=min_data,max=max_data) $
   else $
      hist = histogram(data,binsize=binsz,min=min_data,max=max_data)

   idx = findgen(n_elements(hist))*binsz+min_data

   yr=minmax(hist)
   plot,idx,hist,psym=10,yr=yr,title=title,xtitle=xtitle, $
      ytitle='Number of points in bin',charsize=charsize
   xyouts,0.1*nbins*binsz+min_data,yr[0]+0.9*(yr[1]-yr[0]), $
      'Mean '+string(avg),/data,align=0.0
   xyouts,0.1*nbins*binsz+min_data,yr[0]+0.8*(yr[1]-yr[0]), $
      'sigma '+string(stddev),/data,align=0.0

end
