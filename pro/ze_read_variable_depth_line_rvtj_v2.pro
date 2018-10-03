PRO ZE_READ_VARIABLE_DEPTH_LINE_RVTJ_V2,ND,r
desc1=''
readf,2,desc1 ;first line is variable name, do not store that

;read values of a given variable as a function of depth in RVTJ
l=ND
full_lines=ND/8
val_last_line= ND MOD 8

for j=0, full_lines -1 do begin
readf,2,FORMAT='(4x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13)',r2t,r3t,r4t,r5t,r6t,r7t,r8t,r9t
r[ND-l]=r2t
r[ND-l+1]=r3t
r[ND-l+2]=r4t
r[ND-l+3]=r5t
r[ND-l+4]=r6t
r[ND-l+5]=r7t
r[ND-l+6]=r8t
r[ND-l+7]=r9t
l=l-8
endfor

;read last line according to the number of elements

if val_last_line eq 1 then begin
readf,2,FORMAT='(4x,E15.13)',r2t & r[ND-l]=r2t
endif

if val_last_line eq 2 then begin
readf,2,FORMAT='(4x,E15.13,3x,E15.13)',r2t,r3t & r[ND-l]=r2t & r[ND-l+1]=r3t
endif

if val_last_line eq 3 then begin
readf,2,FORMAT='(4x,E15.13,3x,E15.13,3x,E15.13)',r2t,r3t,r4t & r[ND-l]=r2t & r[ND-l+1]=r3t & r[ND-l+2]=r4t
endif

if val_last_line eq 4 then begin
readf,2,FORMAT='(4x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13)',r2t,r3t,r4t,r5t & r[ND-l]=r2t & r[ND-l+1]=r3t & r[ND-l+2]=r4t & r[ND-l+3]=r5t
endif

if val_last_line eq 5 then begin
readf,2,FORMAT='(4x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13)',r2t,r3t,r4t,r5t & r[ND-l]=r2t & r[ND-l+1]=r3t & r[ND-l+2]=r4t & r[ND-l+3]=r5t & r[ND-l+4]=r6t
endif

if val_last_line eq 6 then begin
readf,2,FORMAT='(4x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13)',r2t,r3t,r4t,r5t,r6t & r[ND-l]=r2t & r[ND-l+1]=r3t & r[ND-l+2]=r4t & r[ND-l+3]=r5t & r[ND-l+4]=r6t & r[ND-l+5]=r7t 
endif

if val_last_line eq 7 then begin
readf,2,FORMAT='(4x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13,3x,E15.13)',r2t,r3t,r4t,r5t,r6t,r7t,r8t & r[ND-l]=r2t & r[ND-l+1]=r3t & r[ND-l+2]=r4t & r[ND-l+3]=r5t & r[ND-l+4]=r6t & r[ND-l+5]=r7t & r[ND-l+6]=r8t 
endif

END