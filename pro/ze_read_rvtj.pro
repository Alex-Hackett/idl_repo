PRO ZE_READ_VARIABLE_DEPTH_LINE_RVTJ,ND,r
desc1=''
readf,2,desc1 ;first line is variable name, do not store that

;read values of a given variable as a function of depth in RVTJ
l=ND
full_lines=ND/8
val_last_line= ND MOD 8

for j=0, full_lines -1 do begin
readf,2,FORMAT='(4x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11)',r2t,r3t,r4t,r5t,r6t,r7t,r8t,r9t
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
readf,2,FORMAT='(4x,E13.11)',r2t & r[ND-l]=r2t
endif

if val_last_line eq 2 then begin
readf,2,FORMAT='(4x,E13.11,3x,E13.11)',r2t,r3t & r[ND-l]=r2t & r[ND-l+1]=r3t
endif

if val_last_line eq 3 then begin
readf,2,FORMAT='(4x,E13.11,3x,E13.11,3x,E13.11)',r2t,r3t,r4t & r[ND-l]=r2t & r[ND-l+1]=r3t & r[ND-l+2]=r4t
endif

if val_last_line eq 4 then begin
readf,2,FORMAT='(4x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11)',r2t,r3t,r4t,r5t & r[ND-l]=r2t & r[ND-l+1]=r3t & r[ND-l+2]=r4t & r[ND-l+3]=r5t
endif

if val_last_line eq 5 then begin
readf,2,FORMAT='(4x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11)',r2t,r3t,r4t,r5t & r[ND-l]=r2t & r[ND-l+1]=r3t & r[ND-l+2]=r4t & r[ND-l+3]=r5t & r[ND-l+4]=r6t
endif

if val_last_line eq 6 then begin
readf,2,FORMAT='(4x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11)',r2t,r3t,r4t,r5t,r6t & r[ND-l]=r2t & r[ND-l+1]=r3t & r[ND-l+2]=r4t & r[ND-l+3]=r5t & r[ND-l+4]=r6t & r[ND-l+5]=r7t 
endif

if val_last_line eq 7 then begin
readf,2,FORMAT='(4x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11,3x,E13.11)',r2t,r3t,r4t,r5t,r6t,r7t,r8t & r[ND-l]=r2t & r[ND-l+1]=r3t & r[ND-l+2]=r4t & r[ND-l+3]=r5t & r[ND-l+4]=r6t & r[ND-l+5]=r7t & r[ND-l+6]=r8t 
endif

END
;******************************************************************************************************************************

PRO ZE_READ_RVTJ,rvtj,r,v,sigma,ed,t,chiross,fluxross,atom,ionden,den,clump,ND,NC,NP,NCF,mdot,lstar,output_format_date,$
		completion_of_model,program_date,was_t_fixed,species_name_con,greyt,heating_rad_decay

IF FILE_EXIST(rvtj) THEN print,rvtj ELSE BEGIN
   print,'File ',rvtj,' not found. Stopping.'
   STOP
ENDELSE   
openu,2,rvtj     ; open file without writing 
;set text string variables (scratch)
desc1=''
desc2=''
output_format_date='' & completion_of_model='' & program_date='' & was_t_fixed='' & species_name_con=''

;reading standard RVTJ header, and finding the values of ND,NC,NP,NCF,Mdot,L etc
readf,2,FORMAT='(1x,A19,9x,A0)',desc1,output_format_date
output_format_date=strtrim(output_format_date)
readf,2,FORMAT='(1x,A20,8x,A0)',desc1,completion_of_model
readf,2,FORMAT='(1x,A13,15x,A0)',desc1,program_date
readf,2,FORMAT='(1x,A3,25x,I0)',desc1,ND ;ONLY WOKRING FOR ND < 100
readf,2,FORMAT='(1x,A3,25x,I0)',desc1,NC
readf,2,FORMAT='(1x,A3,25x,I0)',desc1,NP  ; ONLY WORKING FOR NP < 100
readf,2,FORMAT='(1x,A4,25x,F0)',desc1,NCF ; ONLY WORKING FOR NCF IN THE RANGE 10000--100000
readf,2,FORMAT='(1x,A14,15x,F0)',desc1,mdot
print,desc1
readf,2,FORMAT='(1x,A8,21x,F0)',desc1,lstar
readf,2,desc1
readf,2,FORMAT='(1x,A13,15x,A0)',desc1,was_t_fixed
readf,2,FORMAT='(1x,A25,3x,A0)',desc1,species_name_con

;set vector sizes as ND
r=dblarr(ND) & v=r & sigma=r & ed=r & t=r & chiross=r & fluxross=r & atom=r & ionden=r & den=r & clump=r & greyt=r & heating_rad_decay=r

;As long as the value of ND is known, we can read out the rest of the file.
;Current format only valid for ND=57 , will have to adjust the way to read RVTJ
;        for other values of ND.

;reading each variable; 
IF output_format_date EQ '10-Nov-2009' THEN ZE_READ_VARIABLE_DEPTH_LINE_RVTJ_v2,ND,r ELSE ZE_READ_VARIABLE_DEPTH_LINE_RVTJ,ND,r 
IF output_format_date EQ '10-Nov-2009' THEN ZE_READ_VARIABLE_DEPTH_LINE_RVTJ_v2,ND,v ELSE ZE_READ_VARIABLE_DEPTH_LINE_RVTJ,ND,v
ZE_READ_VARIABLE_DEPTH_LINE_RVTJ,ND,sigma
ZE_READ_VARIABLE_DEPTH_LINE_RVTJ,ND,ed
ZE_READ_VARIABLE_DEPTH_LINE_RVTJ,ND,t
IF output_format_date EQ '10-Nov-2009' THEN ZE_READ_VARIABLE_DEPTH_LINE_RVTJ,ND,greyt
IF output_format_date EQ '10-Nov-2009' THEN ZE_READ_VARIABLE_DEPTH_LINE_RVTJ,ND,heating_rad_decay
ZE_READ_VARIABLE_DEPTH_LINE_RVTJ,ND,chiross
ZE_READ_VARIABLE_DEPTH_LINE_RVTJ,ND,fluxross
ZE_READ_VARIABLE_DEPTH_LINE_RVTJ,ND,atom
ZE_READ_VARIABLE_DEPTH_LINE_RVTJ,ND,ionden
ZE_READ_VARIABLE_DEPTH_LINE_RVTJ,ND,den
ZE_READ_VARIABLE_DEPTH_LINE_RVTJ,ND,clump

close,2
end
