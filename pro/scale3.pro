; $Id: scale3.pro,v 1.11 2005/02/01 20:24:36 scottm Exp $
;
; Copyright (c) 1990-2005, Research Systems, Inc.  All rights reserved.
;       Unauthorized reproduction prohibited.

pro scale3,ax=ax, az=az, xrange=xr, yrange=yr, zrange=zr
;+
; NAME:
;	SCALE3
;
; PURPOSE:
;	Set up transformation and scaling for basic 3D viewing.
;
;	This procedure is similar to SURFR and SCALE3D, except that the
;	data ranges must be specified and the scaling does not vary with 
;	rotation.
;
; CATEGORY:
;	Graphics, 3D.
;
; CALLING SEQUENCE:
;	SCALE3, XRANGE = xr, YRANGE = yr, ZRANGE = zr [, AX = ax] [, AZ = az]
;
; INPUTS:
;	No plain parameters.
;
; KEYWORD PARAMETERS:
;	XRANGE:	Two-element vector containing the minimum and maximum X values.
;		If omitted, the X-axis scaling remains unchanged.
;
;	YRANGE:	Two-element vector containing the minimum and maximum Y values.
;		If omitted, the Y-axis scaling remains unchanged.
;
;	ZRANGE:	Two-element vector containing the minimum and maximum Z values.
;		If omitted, the Z-axis scaling remains unchanged.
;
;	AX:	Angle of rotation about the X axis.  The default is 30 degrees.
;
;	AZ:	Angle of rotation about the Z axis.  The default is 30 degrees.
;
; OUTPUTS:
;	No explicit outputs.  Results are stored in the system variables 
;	!P.T, !X.S, !Y.S, and !Z.S.
;
; COMMON BLOCKS:
;	None.
;
; SIDE EFFECTS:
;	The 4 by 4 matrix !P.T (the 3D-transformation system variable), 
;	receives the homogeneous transformation matrix generated by this 
;	procedure.
;
;	The axis scaling variables, !X.S, !Y.S, and !Z.S are set
;	from the data ranges.
;
; RESTRICTIONS:
;	Axonometric projections only.
;
; PROCEDURE:
; 	Set the axis scaling variables from the supplied ranges, then:
;
; 	1) Translate the unit cube so that the center (.5,.5,.5) is moved
;	   to the origin.
;
; 	2) Scale by 1/SQRT(3) so that the corners do not protrude.
;
; 	3) Rotate -90 degrees about the X axis to make the +Z
;	   axis of the data the +Y axis of the display.  The +Y data axis
;	   extends from the front of the display to the rear.
;
; 	4) Rotate about the Y axis AZ degrees.  This rotates the
;	   result counterclockwise as seen from above the page.
;
; 	5) Then it rotates about the X axis AX degrees, tilting the data
;	   towards the viewer.
;
; 	6) Translate back to the (0,1) cube.
;
; 	This procedure may be easily modified to affect different rotations
;	transformations.
;
; EXAMPLE:
;	Set up a 3D transformation where the data range is 0 to 20 for each
;	of the 3 axes and the viewing area is rotated 20 degrees about the
;	X axis and 55 degrees about the Z axis.  Enter:
;
;	SCALE3, XRANGE=[0, 20], YRANGE=[0, 20], ZRANGE=[0, 20], AX=20, AZ=55 
;
; MODIFICATION HISTORY:
;	DMS, June, 1991.
;-
on_error,2                      ;Return to caller if an error occurs
if n_elements(ax) eq 0 then ax=30	;Supply defaults
if n_elements(az) eq 0 then az=30

if n_elements(xr) ge 2 then !x.s = [ -xr[0], 1.]  / (xr[1]-xr[0])
if n_elements(yr) ge 2 then !y.s = [ -yr[0], 1.]  / (yr[1]-yr[0])
if n_elements(zr) ge 2 then !z.s = [ -zr[0], 1.]  / (zr[1]-zr[0])

;Translate to center about origin, then scale down by 1/sqrt(3)
;so that the corners don't stick out.
t3d, /RESET, TRANSLATE=[-.5,-.5,-.5], SCALE=replicate(1./sqrt(3),3)
t3d, ROTATE = [-90,az,0]	;rotate so +Z axis is now +Y
t3d, ROTATE = [ax,0,0]
t3d, TRANSLATE = [.5, .5, .5]	;& back to 0,1 cube
end
