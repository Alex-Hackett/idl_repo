;+
; Project     : HESSI
;                  
; Name        : IS_DIR
;               
; Purpose     : platform/OS independent check if input name is a 
;               valid directory.
;                             
; Category    : system utility
;               
; Explanation : uses 'cd' and 'catch'
;               
; Syntax      : IDL> a=is_dir(name)
;
; Inputs      : NAME = directory name to check
;               
; Outputs     : 1/0 if success/failure
;               
; Keywords    : OUT = full name of directory
;             : COUNT = # of valid directories
;             
; Restrictions: Needs IDL version .ge. 4. Probably works in Windows
;               
; Side effects: None
;               
; History     : Written, 6-June-1999, Zarro (SM&A/GSFC)
;               Modified, 2-Dec-1999, Zarro - add check for NFS /tmp_mnt
;               Modified, 3-Jan-2002, Zarro - added check for input
;                directory as environment variable
;                  
;
; Contact     : dzarro@solar.stanford.edu
;-    

;-- utility for removing /tmp from NFS mount point names 

pro rem_tmp,name,tname

if (exist(name)) then tname=name

if datatype(name) ne 'STR' then return

if (strlowcase(os_family(/lower)) ne 'unix') then return
                                             
item='/tmp_mnt/'
tmp=strpos(name,item)
if tmp eq 0 then begin
 tname=strmid(name,strlen(item)-1,strlen(name))
endif

return & end

;-----------------------------------------------------------------------------

function is_dir,name,out=out,count=count

count=0
if exist(name) then out=name

if datatype(name) ne 'STR' then begin
 out=''
 return,0b
endif

np=n_elements(name)

;-- use recursion for vector inputs

if np gt 1 then begin
 bool=bytarr(np)
 out=strarr(np)
 for i=0,np-1 do begin
  bool(i)=is_dir(name(i),out=tout)
  out(i)=tout
 endfor
 if np eq 1 then bool=bool(0)
 chk=where(bool,count)
 return,bool
endif

no_delim=strpos(name[0],get_delim()) eq -1

cname=name[0]
if no_delim then begin
 cname=chklog(name)
 if strtrim(cname,2) eq '' then begin
  out=''
  return,0b
 endif
endif

;-- use the old system dependent "chk_dir" for pre-version 4

if not idl_release(lower=4,/inc) then begin
 status=chk_dir(cname,out)
 if not status then out=''
 return,status
endif

;-- save current directory

cd,curr=curr

error=0
catch,error
if error ne 0 then begin
 catch,/cancel
 cd,curr
 out=''
 return,0b
endif


;-- patch for UNIX NFS mounts with /tmp_mnt

rem_tmp,cname,tname
 
;-- try to 'cd' to 'name' and catch error 

cd,tname
cd,curr,curr=tout
rem_tmp,tout,out


;-- 'cd' succeeded so 'name' is a valid directory

count=1
return,1b

end
