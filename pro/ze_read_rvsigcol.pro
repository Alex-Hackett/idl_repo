close,/all
;defines file RVSIG_COL
rvsig1='/aux/pc20117a/jgroh/cmfgen_models/agcar/349_monotonic/RVSIG_COL'  
;rvsig1='/aux/pc20117a/jgroh/cmfgen_models/agcar/349_monotonic/RVSIG_COLe'
;rvsig1='/aux/pc20117a/jgroh/cmfgen_models/agcar/348_copy_newversion9pr08/RVSIG_COLe'
rvsigout='/aux/pc20117a/jgroh/cmfgen_models/agcar/348_copy_newversion9pr08/RVSIG_COLout' 
openu,1,rvsig1     ; open file without writing

ND=57 

;declares the arrays
r1=dblarr(ND) & r2=r1 & rout=r1 & v1=r1 & v2=r1 & vout=r1 & den1=r1 & &den1regrid=r1 & den2=r1 
denout=r1 & mdot1=r1 
mdot2=r1 & mdotout=r1 & vinf=r1 & rstart=r1 & flowtime=r1 & sigma1=r1 & sigma2=r1 & sigmaout=r1 
clump1=r1 & clump2=r1 & clumpout=r1
r3=r1 & v3=r1 & sigma3=r1 & den3=r1 & clump3=r1
vinf2=r1


linha='' & i=-1.
while not eof(1) do begin
	readf,1,linha
	i=i+1.
	inp=strpos(linha,'!')
	if inp gt 0 then begin
		ND=strtrim(linha,2) & ND=strmid(ND,0,4) & ND=strtrim(ND,2)
		goto,skip1
	endif

	skip1:
	;assuming RVSIG_COL has 2 commented lines between ND and first set of r,v,sig values
	inp=strpos(linha,'!')
	
        for k=0,ND-1 do begin
		
		readf,1,r1t,v1t,sigma1t,den1t,clump1t
		r1[k]=r1t & v1[k]=v1t & sigma1[k]=sigma1t & den1[k]=den1t & clump1[k]=clump1t
	endfor
	goto,skip2
	
endwhile
skip2:
close,1

i=ND
for k=0,i-1 do begin
readf,1,r1t,v1t,sigma1t,den1t,clump1t
r1[k]=r1t & v1[k]=v1t & sigma1[k]=sigma1t & den1[k]=den1t & clump1[k]=clump1t
endfor

rout=r1 & vout=v1 

; Evaluates sigma doing  (r deltav)/(v delta r) -1      (very crude!)
sigmaout[0]=-0.9999
for k=1, i-1 do begin
sigmaoutt=((rout[k]+rout[k-1])/2.)*(vout[k-1]-vout[k])/(((vout[k]+vout[k-1])/2.)*(rout[k-1]-rout[k]))-1.
sigmaout[k]=sigmaoutt
endfor


;ZE_WRITE_RVSIG_COL,rout,vout,sigmaout,i,rvsigout

END
