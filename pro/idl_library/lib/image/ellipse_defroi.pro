;+
; $Id: ellipse_defroi.pro,v 1.1 2001/11/05 21:31:29 mccannwj Exp $
;
; NAME:
;     ELLIPSE_DEFROI
;
; PURPOSE:
;     Routine to define region of interest within an ellipse.
;
; CATEGORY:
;
; CALLING SEQUENCE:
;	indices = ELLIPSE_DEFROI(image,xc,yc,a,e,angle)
;			or
;	indices = ELLIPSE_DEFROI(image,ellipse)
; 
; INPUTS:
;	image - image to define region in
;	xc,yc - center of ellipse
;	a - length of semimajor axis in pixels
;	e - ellipticitiy (1-b/a)
;	angle - position angle of the ellipse
;
;	ellipse - structure with tags xc,yc,a,e,angle
;
; OPTIONAL INPUTS:
;	annulus - if supplied, the output is the indices between ellipses
;		with a semi-major axes A and A+annulus.
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;	indices - vector of indices is returned as the function result
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
;
;	version 1, D. Lindler, Aug, 1998
;-
function ellipse_defroi,image,xc,yc,a,e,angle,annulus=annulus
;
; decompose structure
;
   if datatype(xc) eq 'STC' then begin
      xcent = xc.xc
      yc = xc.yc
      a = xc.a
      e = xc.e
      angle = xc.angle
   end else xcent = xc	
;
; get image size
;
   s = size(image) & ns = s(1) & nl = s(2)
   x = lindgen(ns,nl) mod ns - xcent
   y = lindgen(ns,nl)/ns - yc
;
; compute ellipse
;
   b = (1-e)*a
   t = -angle/!radeg
   xrot = x*cos(t) - y*sin(t)
   yrot = x*sin(t) + y*cos(t)
   r2 = xrot*xrot/(a*a) + yrot*yrot/(b*b)
   if n_elements(annulus) gt 0 then $
    index = where((r2 gt 1) and (r2 le ((a+annulus)/a)^2)) $
   else index = where(r2 lt 1)

   return,index		
end
