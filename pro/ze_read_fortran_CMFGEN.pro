
;data = DBLARR(72, 4000)  

;size of array is ((NP+1)*NCF)+RECL*2+(NP+1)
NP=72.
NCF=3952.
RECL=146.
arrsize=((NP+1)*NCF)+RECL*2+(NP+1)
data=DBLARR(1, arrsize)

OPENR, lun, '/home/groh/IP_DATA', /GET_LUN
OPENW,2,'/home/groh/teste_IP.txt'

;Read data.  
READU, lun, data 
  
;write to file
PRINTF,2,data

;define 1D arrays
p=dblarr(NP-1)
freq=dblarr(NCF)
IPDYM=(NP-1)*NCF
ip=dblarr(IPDYM)

;create the p vector
for i=0, NP-2 do p[i]=data[i + (RECL*2) + 1]

;create the frequency vector
startfreq=RECL*2+2*(NP+1) - 1
n=0.
for i=0, NCF-1 do begin
	freq[i]=data[n + startfreq]
	n=n+NP+1
endfor

;create the I(p,nu) vector, working now!
startip=RECL*2.+(NP+1)
m=1.
t=-1.
for i=0., IPDYM-1 do begin
	if (i eq m*(NP-1)) then begin
	t=t+3
	m=m+1

	endif else begin
	t=t+1	
        endelse
   ip[i]=data[startip + t]	 
endfor


;Close the file.  
FREE_LUN, lun  
CLOSE,2

END
