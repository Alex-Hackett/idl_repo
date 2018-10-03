pro cglucy_restart, initial_count
;
; initialize common block used in conjugate gradient speedit
; if specified, initial_count tells number of regular iterations to
; do before begining CG acceleration (default is initial_count=0)
;
common cglscom, cgcount, dpsi, dphi

    if n_elements(initial_count) LE 0 then initial_count = 0

    cgcount = initial_count
    dpsi = 0
    dphi = 0
end

