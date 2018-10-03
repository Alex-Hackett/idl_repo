PRO ZE_READ_LAMPFILE_v2,lampfile,lmin,lmax,imin,intenscut,lamplinelistcut

READCOL,lampfile,intens,lamplinelist
lamplinelist=lamplinelist*10.
nearmin=Min(Abs(lamplinelist - lmin), indexmin)
nearmax = Min(Abs(lamplinelist - lmax), indexmax)

;restricting lines to the given range lmin,lmax
IF lamplinelist(indexmax) gt lmax THEN indexmax=indexmax+1
IF lamplinelist(indexmin) lt lmin THEN indexmin=indexmin-1
lamplinelistcut=lamplinelist[indexmax:indexmin]
lamplinelistcut=REVERSE(lamplinelistcut)
intenscut=intens[indexmax:indexmin]
intenscut=REVERSE(intenscut)
print,intenscut

t=WHERE(intenscut gt imin , count)
print,count
if count ne 0 THEN lamplinelistcut2=lamplinelistcut[t]
if count ne 0 THEN intenscut2=intenscut[t]

lamplinelistcut=lamplinelistcut2
intenscut=intenscut2
VACTOAIR,lamplinelistcut
;print,lamplinelistcut2,intenscut2
END