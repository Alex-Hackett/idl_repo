;+
; $Id: anamorph.pro,v 1.1 2001/11/05 21:24:04 mccannwj Exp $
;
; NAME:
;     ANAMORPH
;
; PURPOSE:
;     Corrects for anamorphic projection.
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
;     ANAMORPH, image, xmag, ymag, angle
;
; INPUTS:
;     xmag - x magnification
;     ymag - y magnification
;     angle - rotation angle
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;     nxout, nyout - size of the output image (if not supplied it will be
;          the same as the input image)
;     xcenter, ycenter - position in the input image which will become the
;          center in the output image (default is the center of the 
;          input image)
;     missing - value to set points in the output image that are outside
;          of the input image (If not supplied, image values will be 
;          will be extrapolated)
;     /interp - Use bilinear interpolation (default = nearest neighbor)
;     /cubic - use cubic interpolation
;
; OUTPUTS:
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
;     The projection is equivalent to rotating the image the specified
;     angle (counter clockwise), expanding in the x and y direction by the 
;     specified magnification factors, and then rotating back by the 
;     specified angle (clockwise).  A single image interpolation includes all
;     of the transformations.
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;	version 1  D. Lindler  Aug, 1998
;-
PRO anamorph,image,xmag,ymag,angle,nxout=nxout,nyout=nyout,xcenter=xcenter, $
             ycenter=ycenter, missing=missing,interp=interp,cubic = cubic
   if n_params(0) eq 0 then begin
      print,'CALLING SEQUENCE: anamorph,image,xmag,ymag,angle'
      print,'KEYWORD INPUTS: nxout, nyout, xcenter, ycenter, '+ $
       'missing, /interp, /cubic'
      return
   end
;
; set defaults
;
   s = size(image) & nx = s(1) & ny = s(2)
   if n_elements(nxout) eq 0 then nxout = nx
   if n_elements(nyout) eq 0 then nyout = ny
   if n_elements(xcenter) eq 0 then xcenter = (nx-1)/2.0
   if n_elements(ycenter) eq 0 then ycenter = (ny-1)/2.0
   if n_elements(angle) eq 0 then angle = 0.0
;
; compute transformation matrices
;	
   t = angle/!radeg ;convert to radians

   mag  = [[1.0/xmag  ,0      ], $
           [0,	   1.0/ymag]]

   rot1 = [[cos(t),   sin(t)  ], $
           [-sin(t),  cos(t)  ]] ;rotation by theta

   rot2 = [[cos(-t),  sin(-t) ], $
           [-sin(-t), cos(-t) ]] ;rotation by -theta

   center_in = [xcenter,ycenter]
   center_out = [(nxout-1)/2.0,(nyout-1)/2.0]
;
; compute matrix for a rotation following by a magnification followed by
; the reverse rotation
;
   A = rot2#mag#rot1
;
; compute constant term of the transformation
;
   c = center_in - A#center_out
;
; create transformation vectors for poly_2d
;
   p = [c(0),A(0,1),A(0,0),0]
   q = [c(1),A(1,1),A(1,0),0]
;
; transform image
;
   i = 0
   if keyword_set(interp) then i=1
   if keyword_set(cubic) then i=2
   image = poly_2d(image,p,q,i,nxout,nyout,missing=missing)
   return
end
