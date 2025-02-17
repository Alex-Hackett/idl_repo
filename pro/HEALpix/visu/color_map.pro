; -----------------------------------------------------------------------------
;
;  Copyright (C) 1997-2008  Krzysztof M. Gorski, Eric Hivon, Anthony J. Banday
;
;
;
;
;
;  This file is part of HEALPix.
;
;  HEALPix is free software; you can redistribute it and/or modify
;  it under the terms of the GNU General Public License as published by
;  the Free Software Foundation; either version 2 of the License, or
;  (at your option) any later version.
;
;  HEALPix is distributed in the hope that it will be useful,
;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;  GNU General Public License for more details.
;
;  You should have received a copy of the GNU General Public License
;  along with HEALPix; if not, write to the Free Software
;  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
;
;  For more information about HEALPix see http://healpix.jpl.nasa.gov
;
; -----------------------------------------------------------------------------
function color_map, data, mindata, maxdata, Obs, $
                    color_bar = color_bar, mode = mode, minset = min_set, maxset = max_set, silent = silent
;+
; color_map
;
; color = color_map( data, mindata, maxdata, Obs=obs, color_bar =
; color_bar, mode = mode)
;
;
; INPUT
;    data : input data
;    mindata : min (can be changed by the routine)
;    maxdata : maxdata (can be changed by the routine)
;
;  Obs : list of valid pixels
;  if Obs is not defined, all pixels are assumed valid
;
; mode    0: nothing
;         1: histogram equalized
;         2: log
;         4: asinh
; asin can not be used together with log nor hist_eq
;
;
;
; Sep 2007: added /silent
; July 2008: added Asinh mode
; Oct 2008: make sure that MIN and MAX are properly taken into account in Asinh mode
;-

if undefined (mode) then mode = 0
do_hist  = (mode and 1)
do_log   = (mode and 2)/2
do_asinh = (mode and 4)/4
if (do_asinh && (do_log || do_hist)) then begin
    message,'Asinh mode can be used together with Log or Hist mode'
endif

N_Color = !D.n_colors < 256

sz = size(data)
npix = n_elements(data)
Color = MAKE_ARRAY(/BYTE, npix, Value = 2B)
color_bar = [2B]
if (sz(0) eq 2) then Color = reform(color,/over,sz(1),sz(2))
if defined(Obs) then begin
    if Obs[0] eq -1 then return, color
    N_obs = n_elements(Obs)
    N_no_Obs = npix - N_obs
endif else begin
    ;Obs = lindgen(npix)
    N_obs = npix
    N_no_obs = 0
endelse

; -------------------------------------------------------------
; sets MIN and MAX
; -------------------------------------------------------------
if (~keyword_set(silent)) then print,'plotted area original MIN and MAX: ',mindata, maxdata
IF DEFINED(min_set) THEN BEGIN
    if (min_set gt mindata) then begin
        IF (N_No_Obs eq 0) THEN data = data > min_set ELSE data(Obs)=data(Obs) > min_set
    endif
    mindata = min_set
    if (~keyword_set(silent)) then print,'new MIN : ',mindata
ENDIF

IF DEFINED(max_set) THEN BEGIN
    if (max_set lt maxdata) then begin
        IF (N_No_Obs eq 0) THEN data = data < max_set ELSE data(Obs)=data(Obs) < max_set
    endif
    maxdata = max_set
    if (~keyword_set(silent)) then print,'new MAX : ',maxdata
ENDIF

IF (do_log) THEN BEGIN
;   log
    if (N_No_Obs eq 0) then begin
;         data      = ALOG10(data + (0.0001 -mindata))
        data = Alog10(data > 1.e-6*abs(maxdata))
        mindata = MIN(data,MAX=maxdata)
    endif else begin 
;         data[Obs] = ALOG10(data[Obs] + (0.0001 -mindata))
        data[Obs] = ALOG10(data[Obs] > 1.e-6*abs(maxdata))
        mindata = MIN(data[Obs],MAX=maxdata)
    endelse
ENDIF

; IF (do_asinh) THEN BEGIN
; ;   Asinh
;     if (N_No_Obs eq 0) then begin
;         data = asinh(data)
;         mindata = MIN(data,MAX=maxdata)
;     endif else begin 
;         data[Obs] = asinh(data[Obs])
;         mindata = MIN(data[Obs],MAX=maxdata)
;     endelse
; ENDIF


; turn data into colors (in the range [3,N_color-1])
col_scl = FINDGEN(N_Color-3)/(N_Color-4)

if (do_hist) then begin
;   histogram equalised scaling
    Tmax = maxdata & Tmin = mindata
    Bs = (Tmax-Tmin)/5000. ;MIN( [(Tmax-Tmin)/5000.,2.] )
    if (N_No_Obs eq 0) then begin
        Phist = HISTOGRAM( data, Min=Tmin, Max=Tmax, Bin = Bs )
        Phist = total(Phist,/cumul)
        Phist[0] = 0.
        Junk = INTERPOLATE( FLOAT(Phist), (data-Tmin)/Bs )
        Color = 3B + BYTSCL( Junk, Top=N_Color-4 )
    endif else begin 
        Phist = HISTOGRAM( data[Obs], Min=Tmin, Max=Tmax, Bin = Bs )
        Phist = total(Phist,/cumul)
        Phist[0] = 0.
        Junk = INTERPOLATE( FLOAT(Phist), (data[Obs]-Tmin)/Bs )
        Color[Obs] = 3B + BYTSCL( Junk, Top=N_Color-4 )
    endelse

    junk2= INTERPOLATE( FLOAT(Phist), col_scl*(Tmax-Tmin)/bs )
    color_bar = (3B + BYTSCL( junk2, TOP = N_Color-4 ))

endif else begin
;   linear scaling or Asinh mapping
    if (do_asinh) then begin
        Tmax = maxdata*1.0 & Tmin = mindata*1.0
        if (N_No_Obs eq 0) then begin
;             Color = 3B + BYTSCL( asinh(data), Top=N_Color-4 )
            Color = 3B + BYTSCL( asinh(data), MIN=asinh(Tmin), MAX=asinh(Tmax), Top=N_Color-4 )
        endif else begin 
;             Color[Obs] = 3B + BYTSCL( asinh(data[Obs]), Top=N_Color-4 )
            Color[Obs] = 3B + BYTSCL( asinh(data[Obs]), MIN=asinh(Tmin), MAX=asinh(Tmax), Top=N_Color-4 )
        endelse
        
        bs = 5 * N_color
        junk2= asinh(  dindgen(bs)/(bs-1)*(Tmax-Tmin) + Tmin  )
        color_bar = (3B + BYTSCL( junk2, TOP = N_Color-4 ))

    endif else begin
        if (ABS((maxdata+mindata)/FLOAT(maxdata-mindata)) lt 5.e-2) then begin
;       if Min and Max are symmetric
;       put data=0 at the center of the color scale
            Tmax = MAX(ABS([mindata,maxdata]))
            Tmin = -Tmax
        endif else begin 
            Tmax = maxdata & Tmin=mindata
        endelse
        if (N_No_Obs eq 0) then begin 
            color = 3B + BYTSCL(data, MIN=Tmin, MAX=Tmax, Top=N_Color-4 )
        endif else begin
            color[Obs] = 3B + BYTSCL(data[Obs], MIN=Tmin, MAX=Tmax, Top=N_Color-4 )
        endelse
        color_bar = (3B + BYTSCL( col_scl, TOP = N_Color-4 ))
    endelse
endelse

mindata = Tmin
maxdata = Tmax

return, color
end

