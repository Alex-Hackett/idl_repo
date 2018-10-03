; $Id: streamline.pro,v 1.11 2005/02/01 20:24:38 scottm Exp $
; Copyright (c) 1991-2005. Research Systems, Inc. All rights reserved.
;	Unauthorized reproduction prohibited.
;+
; NAME:
;	STREAMLINE
;
; PURPOSE:
;
;	This routine serves to generate the visualization graphics from a
;	path. The output is a polygonal ribbon which is tangent to a vector
;	field along its length. The ribbon is generated by placing a line at
;	each vertex in the direction specified by each normal value multiplied
;	by the anisotropy factor.  The input normal array is not normalized
;	before use, making it possible to vary the ribbon width as well.
;
; CATEGORY:
;	3D Toolkit
;
; CALLING SEQUENCE:
;	STREAMLINE, verts, conn, normals, outverts, outconn 
;		[, ANISOTROPY = vector][, SIZE = vector][, PROFILE = array]
;
; INPUTS:
;
; Verts:	Input array of path vertices ([3,N] array).
; Conn:		Input path connectivity array in IDLgrPolyline POLYLINES
;		keyword format.  There is one set of line segments in this
;		array for each streamline.
; Normals:	Normal estimate at each input vertex ([3,N] array).
;
;
; OUTPUTS:
;
; Outverts: 	Output vertices ([3,M] float array).  Useful if the
; 		routine is to be used with Direct Graphics or the user wants to
; 		manipulate the data directly.
; Outconn:	Output polygon connectivity array to match the output vertices.
;
;
; OPTIONAL KEYWORD PARAMETERS:
;
;ANISOTROPY:	Set this input keyword to a three element array
;		describing the distance between grid points in each dimension.
;		The default value is [1.0, 1.0, 1.0]
;SIZE:		Set this keyword to a vector of values (one for each path
;		point). These values are used to specify the width of the 
;		ribbon or the size of profile at each point along its path.  
;		This keyword is generally used to convey additional data 
;		parameters along the streamline.
;PROFILE: 	Set this keyword an array of 2D points which are treated as
;		the cross section of the ribbon instead of a line segment.  
;		If the first and last points in the array are the same, a 
;		closed profile is generated.  The profile is placed at each 
;		path vertex in the plane perpendicular to the line connecting 
;		each path vertex with the vertex normal defining the up 
;		direction.
;
; PROCEDURE/EXAMPLES: 
;
; PARTICLE_TRACE, data, seeds, outverts, outconn, outnormals
;
; STREAMLINE, outverts, outconn, outnormals*width, outverts2,
;     outconn2, PROFILE=[[-1, -1], [-1, 1], [1, 1], [1, -1], [-1,-1]]
;
; oStreamTubes = OBJ_NEW('IDLgrPolygon',outverts2,POLYGONS=outconn2)
;
;
; MODIFICATION HISTORY: 
; 	KB, 	written Feb 1999.  
;-

PRO STREAMLINE,inverts,conn,normals,outverts,outconn, $ 
    ANISOTROPY=anisotropy,PROFILE=profile, SIZE = sizevector

    dims = SIZE(inverts,/DIMENSIONS)
    if((N_ELEMENTS(dims) ne 2) or (dims[0] ne 3)) then $
	MESSAGE,'VERTS must be a 3 x N array.'
    if(not KEYWORD_SET(anisotropy)) then anisotropy=[1.,1.,1.]
    bSize = 0
    if(N_ELEMENTS(sizevector) eq dims[1]) then bSize = 1

    verts = inverts
    verts[0,*] = verts[0,*]*anisotropy[0]
    verts[1,*] = verts[1,*]*anisotropy[1]
    verts[2,*] = verts[2,*]*anisotropy[2]

    nconn = N_ELEMENTS(conn)
    i=0UL
    noutconn=0UL
    nverts=0UL
    np = 0UL
    while((i lt nconn) and (np ge 0)) do begin
	np = conn[i]
	if(np gt 1) then begin
	    nverts = nverts+2*np
	    noutconn = noutconn+np-1
	end
	i = i+np+1
    end

    if(noutconn le 0) then return
    if(not KEYWORD_SET(profile)) then profile = [[0,0],[0,1]]
    pdims = SIZE(profile,/DIMENSIONS)
    npr = pdims[1] ;number of profile faces
    noutconn = noutconn*(npr-1)*8L
    nverts = nverts/2*npr
    outconn = ULONARR(noutconn)
    outverts = FLTARR(3,nverts)

    ;generate ribbon polygons and connectivity

    op=0UL
    i=0UL
    iverts=0UL
    voff=0UL
    prev = FLTARR(3,npr)

    while(i lt nconn) do begin
	np = conn[i]
	i=i+1
        if(bSize) then useprofile = profile*sizevector[conn[i]] $
        else useprofile = profile
	if(np gt 1) then begin
	for p=1UL,np-1 do begin
	    if(p eq 1) then begin
		forward = verts[*,conn[i+1]]-verts[*,conn[i+0]]
		up0 = normals[*,conn[i+0]]
		side0 = -CROSSP(up0,forward)
	    end
	    forward = verts[*,conn[i+p]]-verts[*,conn[i+p-1]]
	    up = normals[*,conn[i+p]]
	    side = -CROSSP(up,forward)
	    for pr=0,npr-2 do begin ;do each profile face
		if(pr eq 0) then begin   
		    if(p eq 1) then begin				
			point0 = verts[*,conn[i+p-1]]+useprofile[0,pr]*side0 $
			    + useprofile[1,pr]*up0 
			outverts[*,0+voff]=point0
			iverts = iverts+1
			prev[*,pr] = point0
		    end else begin 
			point0 = prev[*,pr]
		    end
			point3 = verts[*,conn[i+p]]+useprofile[0,pr]*side $
			    + useprofile[1,pr]*up
			outverts[*,p*npr+voff]=point3
			iverts = iverts+1
			prev[*,pr] = point3
		end else begin 
			point0 = point1
			point3 = point2
		end
		if(p eq 1) then begin
		    point1 = verts[*,conn[i+0]]+useprofile[0,pr+1]*side0 $
			+ useprofile[1,pr+1]*up0
		    outverts[*,pr+1+voff]=point1
		    iverts = iverts+1
		    prev[*,pr+1] = point1
		end else begin 
		    point1 = prev[*,pr+1]
		end
		point2 = verts[*,conn[i+p]]+useprofile[0,pr+1]*side $
		    + useprofile[1,pr+1]*up
		prev[*,pr+1] = point2
		outverts[*,p*npr+pr+1+voff]=point2
		iverts = iverts+1
		up0 = up
		side0 = side
		outconn[op]=3
		;upper left triangle
		outconn[op+1]=(p-1)*npr+pr+voff
		outconn[op+2]=outconn[op+1]+1
		outconn[op+3]=outconn[op+1]+npr
		op = op+4
		;lower right triangle
		outconn[op]=3
		outconn[op+1]=p*npr+pr+voff
		outconn[op+2]=outconn[op+1]-npr+1
		outconn[op+3]=outconn[op+1]+1
		op = op+4
	    end ;profile face
	end ;polyline    
	voff = iverts
	i=i+np
	end else i=i+1
    end ;conn

END




































