PRO ZE_CMFGEN_READ_DC, dir, ion,sufix,dc,ns,nd

openR,lun,dir+ion+sufix,/GET_LUN     ; open file without writing

;set text string variables (scratch)
desc1=''
format_date=''

readf,lun,FORMAT='(A23)',desc1
readf,lun,FORMAT='(A23)',format_date
readf,lun,FORMAT='(A23)',desc1
readf,lun,rstar,lstar,ns,nd
readf,lun,FORMAT='(A23)',desc1

dc=dblarr(ns,nd)
temp=dblarr(ns)
r=dblarr(nd) & hden=r & ed=r & t=r & brubs=r & v=r & clump=r & index=clump

for i=0, nd -1 DO begin
readf,lun,rt,hdent,edt,tt,brubst,vt,clumpt,indext
r[i]=rt & hden[i]=hdent & ed[i]=edt & t[i]=tt & brubs[i]=brubst & v[i]=vt & clump[i]=clumpt  & index[i]=indext
readf,lun,temp
dc[*,i]=temp
endfor
FREE_LUN, lun  

END