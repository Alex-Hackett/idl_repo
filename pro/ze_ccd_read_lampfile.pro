PRO ZE_CCD_READ_LAMPFILE,lampfile,lmin,lmax,lamplinelistcut

READCOL,lampfile,lamplinelist,FORMAT='D'
nearmin=Min(Abs(lamplinelist - lmin), indexmin)
nearmax = Min(Abs(lamplinelist - lmax), indexmax)

;restricting lines to the given range lmin,lmax
IF lamplinelist(indexmax) gt lmax THEN indexmax=indexmax-1
IF lamplinelist(indexmin) lt lmin THEN indexmin=indexmin+1
lamplinelistcut=lamplinelist[indexmin:indexmax]

END