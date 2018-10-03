;PRO ZE_CMFGEN_PLOT_FLUX_FILE
!P.Background = fsc_color('white')
filename_fluxfile_txt='/Users/jgroh/temp/teste_FLUX_FILE.txt'
filename_fluxfile_bin='/Users/jgroh/ze_models/timedep_armagh/14/obsip_halpha_v10/FLUX_FILE'

READCOL,'/Users/jgroh/ze_models/timedep_armagh/14/VM_FILE',r6,v6,sigma14,den14,f14,COMMENT='!',F='D,D'

ND=75.D
NCF=13939.D ;I have to read file using plt_jh.f to know that...cumbersome MODEL 6

NCF=13880.D ;I have to read file using plt_jh.f to know that...cumbersome MODEL 14

FLUXFILE_DIM=ND*NCF
RECL=(ND+1)*3.
arrsize=((ND+1)*NCF)+RECL+ND+1
fluxfile=ZE_CMFGEN_READ_BIN(filename_fluxfile_bin,arrsize)
;ZE_WRITE_IPDATA_TXT,fluxfile,filename_fluxfile_txt

ZE_CMFGEN_READ_FLUXFILE_ND_FREQ,fluxfile,ND,NCF,RECL,depth,freq,lambda,flux

a=0
b=40.0
t1=0
t2=50

lmin=8550
lmax=8920
;lmin=2550
;lmax=9020
fluxdif=flux

For I=0, ND-2 Do Begin
   FOR J=0,NCF -1 DO BEGIN
     fluxdif[i,j]=flux[i,j]-flux[i+1,j]
   ENDFOR
ENDFOR

;depth=REVERSE(depth)
img=bytscl(TRANSPOSE(REVERSE(fluxdif[*,lmin:lmax],1),[1,0]),MIN=a,MAX=b)
;depth=r6/r6[74]
lambdacut=lambda[lmin:lmax]
aa=800
bb=700
ct=13
nointerp=0
ZE_CMFGEN_PLOT_FLUX_ND_NCF_XWINDOW,img,a,b,lambdacut,depth,aa,bb,ct,nointerp
;
;lineprofile=dblarr(lmax-lmin)
;for i=0., lmax-lmin-1 do begin
;        lineprofile[i]=int_tabulated(REVERSE(r6*1e10),flux[*,lmin+i],/DOUBLE) ;r converted to 10^10cm
;endfor


END