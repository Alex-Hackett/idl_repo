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
pro data2moll, data, pol_data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat, $
               planmap, Tmax, Tmin, color_bar, planvec, vector_scale, $
               PXSIZE=pxsize, LOG=log, HIST_EQUAL=hist_equal, MAX=max_set, MIN=min_set, FLIP=flip,$
               NO_DIPOLE=no_dipole, NO_MONOPOLE=no_monopole, UNITS = units, DATA_PLOT = data_plot, $
               GAL_CUT=gal_cut, POLARIZATION=polarization, SILENT=silent, PIXEL_LIST=pixel_list, ASINH=asinh
;+
;==============================================================================================
;     DATA2MOLL
;
;     turns a Healpix or Quad-cube map into in Mollweide egg
;
;     DATA2MOLL,  data, pol_data, pix_type, pix_param, do_conv, do_rot, coord_in,
;                     coord_out, eul_mat
;          planmap, Tmax, Tmin, color_bar, planvec, vector_scale,
;          pxsize=, log=, hist_equal=, max=, min=, flip=, no_dipole=,
;          no_monopole=, units=, data_plot=, gal_cut=, polarization=, silent=,
;          pixel_list=, asinh=
;
; IN :
;      data, pol_data, pix_type, pix_param, do_conv, do_rot, coord_in, coord_out, eul_mat
; OUT :
;      planmap, Tmax, Tmin, color_bar, planvec, vector_scale
; KEYWORDS
;      pxsize, log, hist_equal, max, min, flip, no_dipole, no_monopole, units, polarization
;
;  called by mollview
;
;  HISTORY
; Sep 2007: added /silent
; April 2008: added pixel_list
; July 2008: added asinh
;==============================================================================================
;-

du_dv = 2.    ; aspect ratio
fudge = 1.02  ; spare some space around the Mollweide egg
if keyword_set(flip) then flipconv=1 else flipconv = -1  ; longitude increase leftward by default (astro convention)
if undefined(polarization) then polarization=0
do_polamplitude = (polarization eq 1)
do_poldirection = (polarization eq 2)
do_polvector    = (polarization eq 3)


!P.BACKGROUND = 1               ; white background
!P.COLOR = 0                    ; black foreground

mode_col = keyword_set(hist_equal)
mode_col = mode_col + 2*keyword_set(log) + 4*keyword_set(asinh)

sz = size(data)
obs_npix = sz[1]
bad_data= !healpix.bad_value

if (do_poldirection or do_polvector) then begin
    ; compute new position of pixelisation North Pole in the plot coordinates
    north_pole = [0.,0.,1.]
    if (do_conv) then north_pole = SKYCONV(north_pole, inco= coord_in, outco=coord_out)
    if (do_rot) then north_pole = north_pole # transpose(eul_mat)
endif
;-----------------------------------
; mask out some data
;-----------------------------------
;--------------------------------------
; remove monopole and/or dipole (for temperature, not polarisation)
;----------------------------------------
if not (do_poldirection or do_polamplitude) then begin
    if undefined(gal_cut) then bcut = 0. else bcut = abs(gal_cut)
    if keyword_set(no_dipole) then remove_dipole, data, $
      nside=pix_param, ordering=pix_type, units=units, coord_in = coord_in, coord_out=coord_out, $
      bad_data=bad_data, gal_cut=bcut, pixel=pixel_list
    if keyword_set(no_monopole) then remove_dipole, data, $
      nside=pix_param, ordering=pix_type, units=units, coord_in = coord_in, coord_out=coord_out, $
      bad_data=bad_data, gal_cut=bcut,/only, pixel=pixel_list
endif
; -------------------------------------------------------------
; create the rectangular window
; -------------------------------------------------------------
if DEFINED(pxsize) then xsize= LONG(pxsize>200) else xsize = 800L
ysize = xsize/2L
n_uv = xsize*ysize
indlist = (n_elements(pixel_list) eq obs_npix)
small_file = (n_uv GT obs_npix) 
;small_file = ((n_uv GT npix)  and not do_poldirection)

if (small_file) then begin
    ; file smaller than final map, make costly operation on the file
    ; initial data is destroyed and replaced by color
    if (do_poldirection or do_polvector) then begin
        phi = 0.
        if (do_rot or do_conv) then begin
            ; position of each map pixel after rotation and coordinate changes
            id_pix = lindgen(obs_npix)
            case pix_type of
                'R' : PIX2VEC_RING, pix_param, id_pix, vector ; Healpix ring
                'N' : PIX2VEC_NEST, pix_param, id_pix, vector; Healpix nest
                'Q' : vector = PIX2UV(pix_param, id_pix) ; QuadCube (COBE cgis software)
                else : print,'error on pix_type'
            endcase
            id_pix = 0
            if (do_conv) then vector = SKYCONV(vector, inco= coord_in, outco=coord_out)
            if (do_rot) then vector = vector # transpose(eul_mat)
            ; compute rotation of local coordinates around each vector
            tmp_sin = north_pole[1] * vector[*,0] - north_pole[0] * vector[*,1]
            tmp_cos = north_pole[2] - vector[*,2] * (north_pole[0:2] ## vector)
            if (flipconv lt 0) then tmp_cos = flipconv * tmp_cos
            phi = ATAN(tmp_sin, tmp_cos) ; angle in radians
            tmp_sin = 0. & tmp_cos = 0 & vector = 0.
        endif
        data_plot = data
        if (do_poldirection) then begin
            data = (data - phi + 4*!PI) MOD (2*!PI) ; angle
            min_set = 0. & max_set = 2*!pi
        endif
        if (do_polvector) then begin
            pol_data[*,1] = (pol_data[*,1] - phi + 4*!PI) MOD (2*!PI) ; angle is rotated
        endif
    endif else begin ; temperature only or polarisation amplitude only
        data_plot = data
    endelse
    ; color observed pixels
    mindata = MIN(data[*,0],MAX=maxdata)
    IF( mindata LE (bad_data*.9) or (1-finite(total(data[*,0])))) THEN BEGIN
        Obs    = WHERE( data GT (bad_data*.9) AND finite(data[*,0]), N_Obs )
        mindata = MIN(data[Obs,0],MAX=maxdata)
    ENDIF ELSE begin 
        if defined(Obs) then begin
            Obs = -1.
            junk = temporary(Obs) ; Obs is not defined
        endif
    ENDELSE
    data = COLOR_MAP(data, mindata, maxdata, Obs, $
        color_bar = color_bar, mode=mode_col, minset = min_set, maxset = max_set, silent=silent )
    if (do_polvector) then begin ; rescale polarisation vector in each valid pixel
        pol_data[0,0] = vector_map(pol_data[*,0], Obs, vector_scale = vector_scale)
    endif
    if defined(Obs) then Obs = 0
    Tmin = mindata & Tmax = maxdata
    planmap = MAKE_ARRAY(/BYTE,xsize,ysize, Value = !P.BACKGROUND) ; white
endif else begin ; large file
    planmap = MAKE_ARRAY(/FLOAT,xsize,ysize, Value = bad_data) 
    plan_off = 0L
endelse
if do_polvector then planvec = MAKE_ARRAY(/FLOAT,xsize,ysize, 2, Value = bad_data) 

; -------------------------------------------------
; make the projection
;  we split the projection to avoid dealing with to big an array
; -------------------------------------------------
if (~keyword_set(silent)) then print,'... making the projection ...'
; -------------------------------------------------
; generate the (u,v) position on the mollweide map
; -------------------------------------------------
xll= 0 & xur =  xsize-1
yll= 0 & yur =  ysize-1
xc = 0.5*(xll+xur) & dx = (xur - xc)
yc = 0.5*(yll+yur) & dy = (yur - yc)


yband = LONG(5.e5 / FLOAT(xsize))
for ystart = 0, ysize - 1, yband do begin 
    yend   = (ystart + yband - 1) < (ysize - 1)
    nband = yend - ystart + 1
    u = FINDGEN(xsize)     # REPLICATE(1,nband)
    v = REPLICATE(1,xsize) # (FINDGEN(nband) + ystart)
    u =  du_dv*(u - xc)/(dx/fudge)   ; in [-2,2]*fudge
    v =        (v - yc)/(dy/fudge)   ; in [-1,1] * fudge

    ; -------------------------------------------------------------
    ; for each point on the mollweide map 
    ; looks for the corresponding position vector on the sphere
    ; -------------------------------------------------------------
    ellipse  = WHERE( (u^2/4. + v^2) LE 1. , nellipse)
    if (NOT small_file) then begin
        off_ellipse = WHERE( (u^2/4. + v^2) GT 1. , noff_ell)
        if (noff_ell NE 0) then plan_off = [plan_off, ystart*xsize+off_ellipse]
    endif
    if (nellipse gt 0) then begin
        u1 =  u(ellipse)
        v1 =  v(ellipse)
        u = 0 & v = 0
        s1 =  SQRT( (1-v1)*(1+v1) )
        a1 =  ASIN(v1)

        z = 2./!PI * ( a1 + v1*s1)
        phi = (flipconv *!Pi/2.) * u1/s1 ; lon in [-pi,pi], the minus sign is here to fit astro convention
        sz = SQRT( (1. - z)*(1. + z) )
        vector = [[sz * COS(phi)], [sz * SIN(phi)], [z]]
        u1 = 0 & v1 = 0 & s1 = 0 & a1 = 0 & z = 0 & phi = 0 & sz = 0
        ; --------------------------------
        ; deal with polarisation direction
        ; --------------------------------
        if ((do_poldirection || do_polvector) && ~small_file) then begin
            phi = 0.
            if (do_rot or do_conv) then begin
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
                                ; we go from the final Mollweide map (system coord_out) to
                                ; the original one (system coord_in)
        ; -------------------------------------------------------------
        ; converts the position on the sphere into pixel number
        ; and project the corresponding data value on the map
        ; -------------------------------------------------------------
        case pix_type of
            'R' : VEC2PIX_RING, pix_param, vector, id_pix ; Healpix ring
            'N' : VEC2PIX_NEST, pix_param, vector, id_pix ; Healpix nest
            'Q' : id_pix = UV2PIX(vector, pix_param)    ; QuadCube (COBE cgis software)
            else : print,'error on pix_type'
        endcase
        if (small_file) then begin ; (data and data_pol are already rescaled and color coded)
            if (~ (do_polvector || do_polamplitude || do_poldirection) ) then begin
                planmap[ystart*xsize+ellipse] = sample_sparse_array(data,id_pix,in_pix=pixel_list,default=2B) ; temperature
            endif else begin
                planmap[ystart*xsize+ellipse] = data[id_pix]
            endelse
            if (do_polvector) then begin
                planvec[ystart*xsize+ellipse]         = pol_data[id_pix,0] ; amplitude
                planvec[(ystart*xsize+n_uv)+ellipse]  = pol_data[id_pix,1] ; direction
            endif
        endif else begin ; (large file : do the projection first)
            if (do_poldirection) then begin
                planmap[ystart*xsize+ellipse] = (data[id_pix] - phi + 4*!PI) MOD (2*!PI) ; in 0,2pi
            endif else if (do_polvector) then begin
                planmap[ystart*xsize+ellipse]         = data[id_pix] ; temperature
                planvec[ystart*xsize+ellipse]         = pol_data[id_pix,0] ; amplitude
                planvec[(ystart*xsize+n_uv)+ellipse]  = (pol_data[id_pix,1] - phi + 4*!PI) MOD (2*!PI); angle
            endif else begin ; temperature only or amplitude only
                ;planmap[ystart*xsize+ellipse]         = data[id_pix] ; temperature
                planmap[ystart*xsize+ellipse]         = sample_sparse_array(data,id_pix,in_pix=pixel_list,default=!healpix.bad_value) ; temperature
            endelse
        endelse
    endif
    ellipse = 0 & id_pix = 0
endfor

if (small_file) then begin
    data = 0 & pol_data = 0
endif else begin
; file larger than final map, make
; costly coloring operation on the Mollweide map
    data_plot = temporary(data)
    pol_data = 0
    mindata = MIN(planmap,MAX=maxdata)
    if (mindata LE (bad_data*.9) or (1-finite(total(planmap)))) then begin
        Obs    = WHERE(planmap GT (bad_data*.9) AND finite(planmap), N_Obs )
        if (N_Obs eq 0) then begin
            mindata = -1. & maxdata = 1.
        endif else begin
            mindata = MIN(planmap[Obs],MAX=maxdata)
        endelse
    endif else begin
        if defined(Obs) then begin
            Obs = 0
            junk = temporary(Obs) ; Obs is not defined
        endif
    endelse
    if (do_poldirection) then begin
        min_set = 0.
        max_set = 2*!pi
    endif
    planmap = COLOR_MAP(planmap, mindata, maxdata, Obs, $
            color_bar = color_bar, mode=mode_col, minset = min_set, maxset = max_set, silent=silent)
    planmap(plan_off) = !P.BACKGROUND ; white
    if (do_polvector) then begin ; rescale polarisation vector in each valid pixel
        planvec[*,*,0] = vector_map(planvec[*,*,0], Obs, vector_scale = vector_scale)
        planvec[plan_off] = -1
    endif
    Obs = 0 & plan_off = 0
    Tmin = mindata & Tmax = maxdata
endelse


return
end

