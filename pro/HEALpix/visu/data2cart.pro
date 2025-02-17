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
pro data2cart, data, pol_data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat, $
               color, Tmax, Tmin, color_bar, dx, planvec, vector_scale, $
               PXSIZE=pxsize, PYSIZE=pysize, ROT=rot_ang, LOG=log, HIST_EQUAL=hist_equal, $
               MAX=max_set, MIN=min_set, $
               RESO_ARCMIN=reso_arcmin, FITS = fits, $
               FLIP=flip, DATA_plot = data_plot, $
               POLARIZATION=polarization, SILENT=silent, PIXEL_LIST=pixel_list, ASINH=asinh

;+
;==============================================================================================
;     DATA2CART
;
;     	turns a Healpix or Quad-cube tessellation of the sphere 
;	into a rectangular map in cartesian coordinates
;
;     DATA2CART, data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat,
;          color, Tmax, Tmin, color_bar, dx, planvec, vector_scale,
;          pxsize=, pysize=, rot=, log=, hist_equal=, max=, min=,
;          reso_arcmin=, fits=, flip=, data_plot=, POLARIZATION=, SILENT=, PIXEL_LIST=
;
; IN :
;      data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat
; OUT :
;      color, Tmax, Tmin, color_bar, dx, planvec, vector_scale
; KEYWORDS
;      Pxsize, Pysize, Rot, Log, Hist_equal, Max, Min, Reso_arcmin,
;      Fits, flip, data_plot, polarization, silent, pixel_list, asinh
;
;  called by cartview
;
;  HISTORY
;  2002-06:
;    Hacked by E.H from G. Giardino's data2pol
; Sep 2007: added /silent
; April 2008: added pixel_list
; July 2008: added asinh
;==============================================================================================
;-

;help,data
proj_small = 'cartesian'
du_dv = 1.    ; aspect ratio
fudge = 1.00  ; 
if keyword_set(flip) then flipconv=1 else flipconv = -1  ; longitude increase leftward by default (astro convention)
if undefined(polarization) then polarization=0
do_polamplitude = (polarization eq 1)
do_poldirection = (polarization eq 2)
do_polvector    = (polarization eq 3)

!P.BACKGROUND = 1               ; white background
!P.COLOR = 0                    ; black foreground

mode_col = keyword_set(hist_equal)
mode_col = mode_col + 2*keyword_set(log) + 4*keyword_set(asinh)

obs_npix = N_ELEMENTS(data)
npix_full = (pix_type eq 'Q') ? 6*(4L)^(pix_param-1) : nside2npix(pix_param)

bad_data= !healpix.bad_value

if (do_poldirection or do_polvector) then begin
    ; compute new position of pixelisation North Pole in the plot coordinates
    north_pole = [0.,0.,1.]
    if (do_conv) then north_pole = SKYCONV(north_pole, inco= coord_in, outco=coord_out)
    if (do_rot) then north_pole = north_pole # transpose(eul_mat)
endif
; -------------------------------------------------------------
; create the rectangular window
; -------------------------------------------------------------
if defined(pxsize) then xsize = pxsize*1L else xsize = 500L
if defined(pysize) then ysize = pysize*1L else ysize = xsize
if defined(reso_arcmin) then resgrid = reso_arcmin/60. else resgrid = 1.5/60.
dx      = resgrid * !DtoR
N_uv = xsize*ysize
indlist = (n_elements(pixel_list) eq n_elements(data[*,0]))

if (~keyword_set(silent)) then begin
    print,'Input map  :  ',3600.*6./sqrt(!dpi*npix_full),' arcmin / pixel ',form='(a,f8.3,a)'
    print,'Cartesian map :',resgrid*60.,' arcmin / pixel ',xsize,'*',ysize,form='(a,f8.3,a,i4,a,i4)'
endif

grid = FLTARR(xsize,ysize)
;; grid = MAKE_ARRAY(/FLOAT,xsize,ysize, Value = bad_data) 
if do_polvector then planvec = MAKE_ARRAY(/FLOAT,xsize,ysize, 2, Value = bad_data) 
; -------------------------------------------------------------
; makes the projection around the chosen contact point
; -------------------------------------------------------------
; position on the planar grid  (1,u,v)
x0 = +1.
xll= 0 & xur =  xsize-1
yll= 0 & yur =  ysize-1
xc = 0.5*(xll+xur) 
yc = 0.5*(yll+yur) 

yband = LONG(5.e5 / FLOAT(xsize))
for ystart = 0, ysize - 1, yband do begin 
    yend   = (ystart + yband - 1) < (ysize - 1)
    nband = yend - ystart + 1
    npb = xsize * nband
    u = flipconv*(FINDGEN(xsize) - xc)# REPLICATE(dx,nband)   ; minus sign = astro convention
    v =           REPLICATE(dx,xsize) # (FINDGEN(nband) + ystart - yc)
    off_mask = WHERE( abs(u) gt !pi or abs(v) gt !pi/2., noff_mask)
    if (noff_mask gt 0) then begin
        if (undefined(plan_off)) then begin
            plan_off = ystart*xsize+off_mask
        endif else begin
            plan_off = [plan_off, ystart*xsize+off_mask]
        endelse
    endif
    x =  cos(reform(v,npb)) * cos(reform(u,npb))
    y =  cos(reform(v,npb)) * sin(reform(u,npb))
    z =  sin(reform(v, npb))
    vector = [[x],[y],[z]] ; normalised vector
    ; --------------------------------
    ; deal with polarisation direction
    ; --------------------------------
    if (do_poldirection or do_polvector) then begin
        phi = 0.
        if (do_rot or do_conv) then begin
            vector = vector / (sqrt(total(vector^2, 2))#replicate(1,3)) ; normalize vector
            ; compute rotation of local coordinates around each vector
            tmp_sin = north_pole[1] * vector[*,0] - north_pole[0] * vector[*,1]
            tmp_cos = north_pole[2] - vector[*,2] * (north_pole[0:2] ## vector)
            if (flipconv lt 0) then tmp_cos = flipconv * tmp_cos
            phi = ATAN(tmp_sin, tmp_cos) ; angle in radians
            tmp_sin = 0. & tmp_cos = 0
        endif
    endif
    ; ---------
    ; rotation
    ; ---------
    if (do_rot) then vector = vector # eul_mat
    if (do_conv) then vector = SKYCONV(vector, inco = coord_out, outco =  coord_in)
          ; we go from the final cartesian map (system coord_out) to
          ; the original one (system coord_in)
    ; ----------------x---------------------------------------------
    ; converts the position on the sphere into pixel number
    ; and project the corresponding data value on the map
    ; -------------------------------------------------------------
    case pix_type of
        'R' : VEC2PIX_RING, pix_param, vector, id_pix ; Healpix ring
        'N' : VEC2PIX_NEST, pix_param, vector, id_pix ; Healpix nest
        'Q' : id_pix = UV2PIX(vector, pix_param) ; QuadCube (COBE cgis software)
        else : print,'error on pix_type'
    endcase
    if (do_poldirection) then begin
        grid[ystart*xsize] = (data[id_pix] - phi + 4*!PI) MOD (2*!PI) ; in 0,2pi
    endif else if (do_polvector) then begin
        grid[ystart*xsize]         = data[id_pix]
        planvec[ystart*xsize]      = pol_data[id_pix,0]
        planvec[ystart*xsize+n_uv] = (pol_data[id_pix,1] - phi + 4*!PI) MOD (2*!PI); angle
    endif else begin
        ;grid[ystart*xsize] = data[id_pix]
        grid[ystart*xsize] = sample_sparse_array(data,id_pix,in_pix=pixel_list,default=!healpix.bad_value)
    endelse
endfor
u = 0 & v = 0 & x = 0 & vector = 0

; -------------------------------------------------------------
; Test for unobserved pixels
; -------------------------------------------------------------
data_plot = temporary(data)
pol_data = 0
mindata = MIN(grid,MAX=maxdata)
if (mindata le (bad_data*.9) or (1 - finite(total(grid)))) then begin
    Obs    = where( grid gt (bad_data*.9) and finite(grid), N_Obs )
    if (N_Obs gt 0) then mindata = MIN(grid[Obs],max=maxdata)
endif else begin 
    if defined(Obs) then begin
        Obs = 0
        junk = temporary(Obs)   ; Obs is not defined
    endif
endelse

;-----------------------------------
; export in fits the original cartesian map before alteration
;----------------------------------------------
; ***** cart2fits is not implented yet *****
;-----------------------------------------------
;
;if keyword_set(fits) then begin 
;    if (rot_ang(2) NE 0.) then begin 
;        print,'can NOT export cart FITS file'
;        print,'set Rot = [lon0, lat0, 0.0]'
;        goto,skip_fits
;    endif
;    if (DATATYPE(fits) ne 'STR') then file_fits = 'plot_'+proj_small+'.fits' else file_fits = fits
;    cart2fits, grid, file_fits, rot = rot_ang, coord=coord_out, reso = resgrid*60., unit = sunits, min=mindata, max = maxdata
;    print,'FITS file is in '+file_fits
;    skip_fits:
;endif

; -------------------------------------------------------------
; set min and max and computes the color scaling
; -------------------------------------------------------------
if (do_poldirection) then begin
    min_set = 0.
    max_set = 2*!pi
endif
color = COLOR_MAP(grid, mindata, maxdata, Obs, $
         color_bar = color_bar, mode=mode_col, minset = min_set, maxset = max_set, silent=silent)
if (defined(plan_off)) then color[plan_off]  = !P.BACKGROUND ; white
if (do_polvector) then begin    ; rescale polarisation vector in each valid pixel
    planvec[*,*,0] = vector_map(planvec[*,*,0], Obs, vector_scale = vector_scale)
endif
Obs = 0
grid = 0
Tmin = mindata & Tmax = maxdata

return
end

