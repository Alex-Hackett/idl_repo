PRO ZE_COMPUTE_DISTANCE_TRAVELED_DELTAT,deltat,r,v,nd,vs,flowtime,rirev,virev,flowtimerev,dflowtimerev,x,x_r,index_x_r,rev=rev

;computes the distance x traveled by a wind after a time deltat with a monotonic velocity law v(r) as given by the tabulated r,v, vectors.
;also returns x_r, which corresponds to the closest value of r to x 

near_x_deltat=Min(Abs(deltat - flowtimerev), index_x_deltat)
index_x_deltat=index_x_deltat*1.0D
x=rirev[index_x_deltat]


near_x_r=Min(Abs(r- x), index_x_r)
index_x_r=index_x_r*1.0D
x_r=r[index_x_r]
print,near_x_r,index_x_r,r[index_x_r],flowtime[index_x_r]


END