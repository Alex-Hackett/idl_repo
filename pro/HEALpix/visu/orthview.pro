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
pro orthview, file_in, select_in, $
ASINH=asinh, CHARSIZE=charsize, COLT = colt, COORD = coord, CROP = crop, $
EXECUTE=execute, $
FACTOR=factor, FLIP=flip, $
GAL_CUT=gal_cut, GIF = gif, GLSIZE = glsize, GRATICULE = graticule, $
HALF_SKY = half_sky, HBOUND = hbound, HELP = help, $
HIST_EQUAL = hist_equal, HXSIZE = hxsize, $
IGLSIZE = iglsize, IGRATICULE=igraticule, $
LOG = log, $
MAX = max_set, MIN = min_set, $
NESTED = nested_online, NOBAR = nobar, NOLABELS = nolabels, NO_DIPOLE=no_dipole, NO_MONOPOLE=no_monopole, $
OFFSET=offset, ONLINE = online, OUTLINE=outline, $
PNG=png, POLARIZATION=polarization, PREVIEW = preview, PS = ps, PXSIZE = pxsize, $
QUADCUBE = quadcube, $
ROT = rot, $
SAVE = save, SILENT = silent, SUBTITLE = subtitle, $
TITLEPLOT = titleplot, $
UNITS = units, WINDOW = window, XPOS = xpos, YPOS = ypos

;+
; for extended description see mollview or the paper documentation
;-


defsysv, '!healpix', exists = exists
if (exists ne 1) then init_healpix

@viewcom ; define common
data_plot = 0 ; empty common array
; record original color table and PLOTS settings
record_original_settings, original_settings

loadsky                         ; cgis package routine, define rotation matrices
projection = 'ORTHOGRAPHIC'
routine = 'orthview'

uroutine = strupcase(routine)
if keyword_set(help) then begin
    doc_library,'mollview'
    return
endif

if keyword_set(gif) then begin
    message_gif, code=routine, error=error_gif
    if (error_gif) then return
endif

if (n_params() lt 1 or n_params() gt 2) then begin
    PRINT, 'Wrong number of arguments in '+uroutine
    print,'Syntax : '
    print, uroutine+', File, [Select, ]'
    print,'              [ASINH=, CHARSIZE=, COLT=, COORD=, CROP=, '
    print,'              EXECUTE=, FACTOR=, FLIP=, GAL_CUT=, GIF=, GLSIZE=, GRATICULE=, '
    print,'              HALF_SKY=, HBOUND =,     HELP=, '
    print,'              HIST_EQUAL=, HXSIZE=,  '
    print,'              IGLSIZE=, IGRATICULE=,'
    print,'              LOG=, '
    print,'              MAX=, MIN=, NESTED=, NOBAR=, NOLABELS=, '
    print,'              OFFSET=, ONLINE=, OUTLINE=,'
    print,'              PNG=,'
    print,'              POLARIZATION=polarization, PREVIEW=, '
    print,'              PS=, PXSIZE=, PYSIZE=, QUADCUBE= ,'
    print,'              ROT=, SAVE=, SILENT=, '
    print,'              SUBTITLE=, TITLEPLOT=, '
    print,'              UNITS=, WINDOW=, XPOS=, YPOS=]'
    print
    print,' Type '+uroutine+', /help '
    print,'   for an extended help'
    return
endif

IF (undefined(file_in)) then begin
    print,routine+': Undefined variable as 1st argument'
    return
endif
do_flip = keyword_set(flip)

if (!D.n_colors lt 4) then begin
    print,' : Sorry ... not enough colors ('+strtrim(string(!d.n_colors),2)+') available'
    return
endif

if (keyword_set(no_monopole) and keyword_set(no_dipole)) then begin
    print,routine+': choose either NO_MONOPOLE or NO_DIPOLE'
    print,'    (removal of best fit monopole only or best fit monopole+dipole)'
    return
endif

polar_type = 0
if keyword_set(polarization) then polar_type = polarization

do_fullsky = 1 - keyword_set(half_sky)

loaddata_healpix, $
  file_in, select_in,$
  data, pol_data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat, title_display, sunits, $
  SAVE=save, ONLINE=online, NESTED=nested_online, UNITS=units, COORD=coord, FLIP=flip, $
  ROT=rot, QUADCUBE=quadcube, LOG=log, ERROR=error, $
  POLARIZATION=polarization, FACTOR=factor, OFFSET=offset, SILENT=silent, COMPRESS=1, PIXEL_LIST=pixel_list
if error NE 0 then return

data2orth, $
  data, pol_data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat, $
  planmap, Tmax, Tmin, color_bar, planvec, vector_scale, $
  PXSIZE=pxsize, LOG=log, HIST_EQUAL=hist_equal, MAX=max_set, MIN=min_set, FLIP=flip,  $
  NO_DIPOLE=no_dipole, NO_MONOPOLE=no_monopole, UNITS=sunits, DATA_plot = data_plot, GAL_CUT=gal_cut, $
  POLARIZATION=polarization, HALF_SKY=half_sky, SILENT=silent, PIXEL_LIST=pixel_list, ASINH=asinh

proj2out, $
  planmap, Tmax, Tmin, color_bar, 0., title_display, $
  sunits, coord_out, do_rot, eul_mat, planvec, vector_scale, $
  CHARSIZE=charsize, COLT=colt, CROP=crop, GIF = gif, GRATICULE = graticule, $
  HXSIZE=hxsize, NOBAR = nobar, NOLABELS = nolabels, PNG = png, PREVIEW = preview, PS=ps, PXSIZE=pxsize, $
  SUBTITLE = subtitle, TITLEPLOT = titleplot, XPOS = xpos, YPOS = ypos, $
  POLARIZATION=polarization, OUTLINE=outline, /ORTH, FLIP=flip, HALF_SKY=half_sky, COORD_IN=coord_in, $
  IGRATICULE=igraticule, HBOUND = hbound, WINDOW = window, SILENT=silent, GLSIZE=glsize, IGLSIZE=iglsize

w_num = !d.window
; restore original color table and PLOTS settings
record_original_settings, original_settings, /restore

return
end

