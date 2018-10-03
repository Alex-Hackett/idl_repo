; $Id: vert_t3d.pro,v 1.14 2005/02/01 20:24:40 scottm Exp $
;
; Copyright (c) 1994-2005, Research Systems, Inc.  All rights reserved.
;       Unauthorized reproduction prohibited.
;+
; NAME:
;       VERT_T3D
;
; PURPOSE:
;       This function tranforms 3-D points by a 4x4 transformation matrix.
;       The 3-D points are typically an array of polygon vertices that were
;       generated by SHADE_VOLUME or MESH_OBJ.
;
; CATEGORY:
;       Graphics.
;
; CALLING SEQUENCE:
;       result = VERT_T3D(vertex_list)
;
; INPUTS:
;       Vertex_List:
;               A 3 x n array of 3D coordinates to transform.
;
; KEYWORD PARAMETERS:
;
;	Double:
;		Set this keyword to a nonzero value to indicate that the
;		returned coordinates should be double precision.  If this
;		keyword is not set, the default is to return single
;		precision coordinates (unless double precision coordinates
;		are input, in which case the DOUBLE keyword is implied to
;		be non-zero).
;
;       Matrix:
;               The 4x4 transformation matrix to use. The default is to use
;               the system viewing matrix (!P.T). (See the "T3D" procedure). 
;
;       No_Copy:
;               Normally, a COPY of Vertex_List is transformed and the
;               original vertex_list is preserved. If No_Copy is set, however,
;               then the original Vertex_List will be undefined AFTER the call
;               to VERT_T3D. Using the No_Copy mode will require less memory.
;
;       No_Divide:
;               Normally, when a [x, y, z, 1] vector is transformed by a 4x4
;               matrix, the final homogeneous coordinates are obtained by
;               dividing the x, y, and z components of the result vector by
;               the fourth element in the result vector. Setting the No_Divide
;               keyword will prevent VERT_T3D from performing this division.
;               In some cases (usually when a perspective transformation is
;               involved) the fourth element in the result vector can be very
;               close to (or equal to) zero.
;
;       Save_Divide:
;               Set this keyword to a named variable to receive the fourth
;               element of the transformed vector(s). If Vertex_List is a
;               vector then Save_Divide is a scalar. If Vertex_List is a
;               [3, n] array then Save_Divide is an array of n elements.
;               This keyword only has effect when the No_Divide keyword is set.
;
; OUTPUTS:
;       This function returns the transformed coordinate(s). The returned
;       array has the same size and dimensions as Vertex_List.
;
; PROCEDURE:
;       Before performing the transformation, the [3, n] Vertex_List is padded
;       to produce a [4, n] array with 1's in the last column. After the
;       transformation, the first three columns of the array are divided by
;       the fourth column (unless the No_Divide keyword is set). The fourth
;       column is then stripped off (or saved in the Save_Divide keyword)
;       before returning.
;
; EXAMPLE:
;       Transform four points representing a square in the x-y plane by first
;       translating +2.0 in the positive X direction, and then rotating 60.0
;       degrees about the Y axis.
;
;               points = [[0.0, 0.0, 0.0], [1.0, 0.0, 0.0], $
;                         [1.0, 1.0, 0.0], [0.0, 1.0, 0.0]]
;               T3d, /Reset
;               T3d, Translate=[2.0, 0.0, 0.0]
;               T3d, Rotate=[0.0, 60.0, 0.0]
;               points = VERT_T3D(points)
;
; MODIFICATION HISTORY:
;       Written by:     Daniel Carr, Thu Mar 31 15:58:07 MST 1994
;	DLD, April, 2000.  Update for double precision; add DOUBLE keyword.
;-

FUNCTION VERT_T3D, vertex_list, Double=do_double, $
                   Matrix=in_matrix, No_Copy=no_copy, $
                   No_Divide=no_divide, Save_Divide=save_divide

sz_vertex = Size(vertex_list)
n_verts = sz_vertex[2]

bDouble = KEYWORD_SET(do_double)
if (Size(vertex_list,/type) eq 5) then bDouble = 1

IF (N_Elements(in_matrix) LE 0L) THEN $
   matrix = !P.T $
ELSE $
   matrix=DOUBLE(in_matrix) 

IF (Keyword_Set(no_copy)) THEN BEGIN
   ret_list = Transpose( $
      Transpose([Temporary(vertex_list), Replicate(1.0, 1L, n_verts)]) # matrix)
ENDIF ELSE BEGIN
   ret_list = $
      Transpose(Transpose([vertex_list, Replicate(1.0, 1L, n_verts)]) # matrix)
ENDELSE

IF (Keyword_Set(no_divide)) THEN BEGIN
   save_divide = ret_list[3, *]
   IF (bDouble eq 0) THEN $
       RETURN, FLOAT([ret_list[0, *], ret_list[1, *], ret_list[2, *]]) $
   ELSE $
       RETURN, [ret_list[0, *], ret_list[1, *], ret_list[2, *]]
ENDIF ELSE BEGIN
   IF (bDouble eq 0) THEN $
       RETURN, FLOAT([(ret_list[0, *] / ret_list[3, *]), $
                      (ret_list[1, *] / ret_list[3, *]), $
                      (ret_list[2, *] / ret_list[3, *])])    $
   ELSE $
       RETURN, [(ret_list[0, *] / ret_list[3, *]), $
                (ret_list[1, *] / ret_list[3, *]), $
                (ret_list[2, *] / ret_list[3, *])]
ENDELSE

END
