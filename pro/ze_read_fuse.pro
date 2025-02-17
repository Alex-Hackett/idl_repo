;**********************Segment 1A SiC ***********************************************************
a001 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010011asic4ttagfcal.fit',1)
a001hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010011asic4ttagfcal.fit',0,hd1)
wave001=a001.wave
flux001=a001.flux
exp1=fxpar(hd1,'EXPTIME')

a002 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010021asic4ttagfcal.fit',1)
a002hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010021asic4ttagfcal.fit',0,hd2)
wave002=a002.wave
flux002=a002.flux
exp2=fxpar(hd2,'EXPTIME')

a003 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010031asic4ttagfcal.fit',1)
a003hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010031asic4ttagfcal.fit',0,hd3)
wave003=a003.wave
flux003=a003.flux
exp3=fxpar(hd3,'EXPTIME')

a004 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010041asic4ttagfcal.fit',1)
a004hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010041asic4ttagfcal.fit',0,hd4)
wave004=a004.wave
flux004=a004.flux
exp4=fxpar(hd4,'EXPTIME')

;print,exp1,exp2,exp3,exp4 ;exptime are almost the same, therefore will be neglected
wave1asic_ave=(wave001+wave002+wave003+wave004)/4.
flux1asic_ave=(flux001+flux002+flux003+flux004)/4.

x1l=1000.
x1u=1100.
waveshift=0.
window,1
plot,wave001,flux001,xstyle=1,ystyle=1,xrange=[x1l,x1u],/nodata
;oplot,wave004+waveshift,flux004,color=fsc_color('red')
oplot,wave1asic_ave,flux1asic_ave,color=fsc_color('red')

;**********************Segment 1B SiC ***********************************************************
a001 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010011bsic4ttagfcal.fit',1)
a001hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010011bsic4ttagfcal.fit',0,hd1)
wave001=a001.wave
flux001=a001.flux
exp1=fxpar(hd1,'EXPTIME')

a002 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010021bsic4ttagfcal.fit',1)
a002hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010021bsic4ttagfcal.fit',0,hd2)
wave002=a002.wave
flux002=a002.flux
exp2=fxpar(hd2,'EXPTIME')

a003 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010031bsic4ttagfcal.fit',1)
a003hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010031bsic4ttagfcal.fit',0,hd3)
wave003=a003.wave
flux003=a003.flux
exp3=fxpar(hd3,'EXPTIME')

a004 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010041bsic4ttagfcal.fit',1)
a004hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010041bsic4ttagfcal.fit',0,hd4)
wave004=a004.wave
flux004=a004.flux
exp4=fxpar(hd4,'EXPTIME')

;print,exp1,exp2,exp3,exp4 ;exptime are almost the same, therefore will be neglected
wave1bsic_ave=(wave001+wave002+wave003+wave004)/4.
flux1bsic_ave=(flux001+flux002+flux003+flux004)/4.

x1l=900.
x1u=1000.
waveshift=0.
window,2
plot,wave001,flux001,xstyle=1,ystyle=1,xrange=[x1l,x1u],/nodata
;oplot,wave004+waveshift,flux004,color=fsc_color('red')
oplot,wave1bsic_ave,flux1bsic_ave,color=fsc_color('red')

;**********************Segment 2A SiC ***********************************************************
a001 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010012asic4ttagfcal.fit',1)
a001hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010012asic4ttagfcal.fit',0,hd1)
wave001=a001.wave
flux001=a001.flux
exp1=fxpar(hd1,'EXPTIME')

a002 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010022asic4ttagfcal.fit',1)
a002hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010022asic4ttagfcal.fit',0,hd2)
wave002=a002.wave
flux002=a002.flux
exp2=fxpar(hd2,'EXPTIME')

a003 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010032asic4ttagfcal.fit',1)
a003hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010032asic4ttagfcal.fit',0,hd3)
wave003=a003.wave
flux003=a003.flux
exp3=fxpar(hd3,'EXPTIME')

a004 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010042asic4ttagfcal.fit',1)
a004hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010042asic4ttagfcal.fit',0,hd4)
wave004=a004.wave
flux004=a004.flux
exp4=fxpar(hd4,'EXPTIME')

;print,exp1,exp2,exp3,exp4 ;exptime are almost the same, therefore will be neglected
wave2asic_ave=(wave001+wave002+wave003+wave004)/4.
flux2asic_ave=(flux001+flux002+flux003+flux004)/4.

x1l=900.
x1u=1000.
waveshift=0.
window,3
plot,wave001,flux001,xstyle=1,ystyle=1,xrange=[x1l,x1u],/nodata
;oplot,wave004+waveshift,flux004,color=fsc_color('red')
oplot,wave2asic_ave,flux2asic_ave,color=fsc_color('red')

;**********************Segment 2B SiC ***********************************************************
a001 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010012bsic4ttagfcal.fit',1)
a001hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010012bsic4ttagfcal.fit',0,hd1)
wave001=a001.wave
flux001=a001.flux
exp1=fxpar(hd1,'EXPTIME')

a002 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010022bsic4ttagfcal.fit',1)
a002hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010022bsic4ttagfcal.fit',0,hd2)
wave002=a002.wave
flux002=a002.flux
exp2=fxpar(hd2,'EXPTIME')

a003 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010032bsic4ttagfcal.fit',1)
a003hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010032bsic4ttagfcal.fit',0,hd3)
wave003=a003.wave
flux003=a003.flux
exp3=fxpar(hd3,'EXPTIME')

a004 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010042bsic4ttagfcal.fit',1)
a004hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010042bsic4ttagfcal.fit',0,hd4)
wave004=a004.wave
flux004=a004.flux
exp4=fxpar(hd4,'EXPTIME')

;print,exp1,exp2,exp3,exp4 ;exptime are almost the same, therefore will be neglected
wave2bsic_ave=(wave001+wave002+wave003+wave004)/4.
flux2bsic_ave=(flux001+flux002+flux003+flux004)/4.

x1l=1000.
x1u=1110.
waveshift=0.
window,4
plot,wave001,flux001,xstyle=1,ystyle=1,xrange=[x1l,x1u],/nodata
;oplot,wave004+waveshift,flux004,color=fsc_color('red')
oplot,wave2bsic_ave,flux2bsic_ave,color=fsc_color('red')

;**********************Segment 1A Lif ***********************************************************
a001 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010011alif4ttagfcal.fit',1)
a001hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010011alif4ttagfcal.fit',0,hd1)
wave001=a001.wave
flux001=a001.flux
exp1=fxpar(hd1,'EXPTIME')

a002 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010021alif4ttagfcal.fit',1)
a002hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010021alif4ttagfcal.fit',0,hd2)
wave002=a002.wave
flux002=a002.flux
exp2=fxpar(hd2,'EXPTIME')

a003 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010031alif4ttagfcal.fit',1)
a003hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010031alif4ttagfcal.fit',0,hd3)
wave003=a003.wave
flux003=a003.flux
exp3=fxpar(hd3,'EXPTIME')

a004 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010041alif4ttagfcal.fit',1)
a004hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010041alif4ttagfcal.fit',0,hd4)
wave004=a004.wave
flux004=a004.flux
exp4=fxpar(hd4,'EXPTIME')

;print,exp1,exp2,exp3,exp4 ;exptime are almost the same, therefore will be neglected
wave1alif_ave=(wave001+wave002+wave003+wave004)/4.
flux1alif_ave=(flux001+flux002+flux003+flux004)/4.

x1l=900.
x1u=1100.
waveshift=0.
window,5
plot,wave001,flux001,xstyle=1,ystyle=1,xrange=[x1l,x1u],/nodata
;oplot,wave004+waveshift,flux004,color=fsc_color('red')
oplot,wave1alif_ave,flux1alif_ave,color=fsc_color('red')

;**********************Segment 1B Lif ***********************************************************
a001 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010011blif4ttagfcal.fit',1)
a001hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010011blif4ttagfcal.fit',0,hd1)
wave001=a001.wave
flux001=a001.flux
exp1=fxpar(hd1,'EXPTIME')

a002 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010021blif4ttagfcal.fit',1)
a002hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010021blif4ttagfcal.fit',0,hd2)
wave002=a002.wave
flux002=a002.flux
exp2=fxpar(hd2,'EXPTIME')

a003 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010031blif4ttagfcal.fit',1)
a003hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010031blif4ttagfcal.fit',0,hd3)
wave003=a003.wave
flux003=a003.flux
exp3=fxpar(hd3,'EXPTIME')

a004 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010041blif4ttagfcal.fit',1)
a004hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010041blif4ttagfcal.fit',0,hd4)
wave004=a004.wave
flux004=a004.flux
exp4=fxpar(hd4,'EXPTIME')

;print,exp1,exp2,exp3,exp4 ;exptime are almost the same, therefore will be neglected
wave1blif_ave=(wave001+wave002+wave003+wave004)/4.
flux1blif_ave=(flux001+flux002+flux003+flux004)/4.

x1l=900.
x1u=1200.
waveshift=0.
window,6
plot,wave001,flux001,xstyle=1,ystyle=1,xrange=[x1l,x1u],/nodata
;oplot,wave004+waveshift,flux004,color=fsc_color('red')
oplot,wave1blif_ave,flux1blif_ave,color=fsc_color('red')

;**********************Segment 2A LiF ***********************************************************
a001 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010012alif4ttagfcal.fit',1)
a001hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010012alif4ttagfcal.fit',0,hd1)
wave001=a001.wave
flux001=a001.flux
exp1=fxpar(hd1,'EXPTIME')

a002 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010022alif4ttagfcal.fit',1)
a002hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010022alif4ttagfcal.fit',0,hd2)
wave002=a002.wave
flux002=a002.flux
exp2=fxpar(hd2,'EXPTIME')

a003 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010032alif4ttagfcal.fit',1)
a003hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010032alif4ttagfcal.fit',0,hd3)
wave003=a003.wave
flux003=a003.flux
exp3=fxpar(hd3,'EXPTIME')

a004 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010042alif4ttagfcal.fit',1)
a004hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010042alif4ttagfcal.fit',0,hd4)
wave004=a004.wave
flux004=a004.flux
exp4=fxpar(hd4,'EXPTIME')

;print,exp1,exp2,exp3,exp4 ;exptime are almost the same, therefore will be neglected
wave2alif_ave=(wave001+wave002+wave003+wave004)/4.
flux2alif_ave=(flux001+flux002+flux003+flux004)/4.

x1l=900.
x1u=1200.
waveshift=0.
window,7
plot,wave001,flux001,xstyle=1,ystyle=1,xrange=[x1l,x1u],/nodata
;oplot,wave004+waveshift,flux004,color=fsc_color('red')
oplot,wave2alif_ave,flux2alif_ave,color=fsc_color('red')

;**********************Segment 2B LiF ***********************************************************
a001 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010012blif4ttagfcal.fit',1)
a001hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010012blif4ttagfcal.fit',0,hd1)
wave001=a001.wave
flux001=a001.flux
exp1=fxpar(hd1,'EXPTIME')

a002 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010022blif4ttagfcal.fit',1)
a002hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010022blif4ttagfcal.fit',0,hd2)
wave002=a002.wave
flux002=a002.flux
exp2=fxpar(hd2,'EXPTIME')

a003 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010032blif4ttagfcal.fit',1)
a003hd=mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010032blif4ttagfcal.fit',0,hd3)
wave003=a003.wave
flux003=a003.flux
exp3=fxpar(hd3,'EXPTIME')

a004 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010042blif4ttagfcal.fit',1)
a004hd = mrdfits('/home/groh/data/fuse/agcar_2001may27/P22205010042blif4ttagfcal.fit',0,hd4)
wave004=a004.wave
flux004=a004.flux
exp4=fxpar(hd4,'EXPTIME')

;print,exp1,exp2,exp3,exp4 ;exptime are almost the same, therefore will be neglected
wave2blif_ave=(wave001+wave002+wave003+wave004)/4.
flux2blif_ave=(flux001+flux002+flux003+flux004)/4.

x1l=900.
x1u=1110.
waveshift=0.
window,8
plot,wave001,flux001,xstyle=1,ystyle=1,xrange=[x1l,x1u],/nodata
;oplot,wave004+waveshift,flux004,color=fsc_color('red')
oplot,wave2blif_ave,flux2blif_ave,color=fsc_color('red')

;***********************************************************************************8888
;
;window,9
;plot,wave1blif_ave,flux1blif_ave,xstyle=1,ystyle=1,xrange=[1080,1190]
;oplot,wave2alif_ave,flux2alif_ave,color=fsc_color('red')
;
;linterp,wave1blif_ave,flux1blif_ave,wave2alif_ave,flux1blif_ave_interp
;flux_1blif2alif_ave=(flux2alif_ave+flux1blif_ave_interp)/2
;window,10
;plot,wave2alif_ave,flux1blif_ave_interp,xstyle=1,ystyle=1,xrange=[1080,1190]
;oplot,wave2alif_ave,flux_1blif2alif_ave,color=fsc_color('red')

;********************************1st extension of the *all* FITS files, 920-1010 Angstrom
all001 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P222050100100all4ttagfcal.fit',1)
waveall001=all001.wave
fluxall001=all001.flux
window,12
plot,waveall001,fluxall001,xstyle=1,ystyle=1,xrange=[920,1010]

all002 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P222050100200all4ttagfcal.fit',1)
waveall002=all002.wave
fluxall002=all002.flux
oplot,waveall002,fluxall002

all003 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P222050100300all4ttagfcal.fit',1)
waveall003=all003.wave
fluxall003=all003.flux
oplot,waveall003,fluxall003

all004 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P222050100400all4ttagfcal.fit',1)
waveall004=all004.wave
fluxall004=all004.flux
oplot,waveall004,fluxall004

flux920_101=(fluxall001+fluxall002+fluxall003+fluxall004)/4.
wave920_101=(waveall001+waveall002+waveall003+waveall004)/4.
oplot,wave920_101,flux920_101,color=fsc_color('red')

;********************************2nd extension of the *all* FITS files, 990-1085 Angstrom
all001 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P222050100100all4ttagfcal.fit',2)
waveall001=all001.wave
fluxall001=all001.flux
window,13
plot,waveall001,fluxall001,xstyle=1,ystyle=1,xrange=[990,1085]

all002 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P222050100200all4ttagfcal.fit',2)
waveall002=all002.wave
fluxall002=all002.flux
oplot,waveall002,fluxall002

all003 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P222050100300all4ttagfcal.fit',2)
waveall003=all003.wave
fluxall003=all003.flux
oplot,waveall003,fluxall003

all004 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P222050100400all4ttagfcal.fit',2)
waveall004=all004.wave
fluxall004=all004.flux
oplot,waveall004,fluxall004

flux990_108=(fluxall001+fluxall002+fluxall003+fluxall004)/4.
wave990_108=(waveall001+waveall002+waveall003+waveall004)/4.
oplot,wave990_108,flux990_108,color=fsc_color('red')

;********************************3rd extension of the *all* FITS files, 1080-1185  Angstrom
all001 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P222050100100all4ttagfcal.fit',3)
waveall001=all001.wave
fluxall001=all001.flux
window,14
plot,waveall001,fluxall001,xstyle=1,ystyle=1,xrange=[1080,1185]

all002 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P222050100200all4ttagfcal.fit',3)
waveall002=all002.wave
fluxall002=all002.flux
oplot,waveall002,fluxall002

all003 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P222050100300all4ttagfcal.fit',3)
waveall003=all003.wave
fluxall003=all003.flux
oplot,waveall003,fluxall003

all004 = mrdfits('/home/groh/data/fuse/agcar_2001may27/P222050100400all4ttagfcal.fit',3)
waveall004=all004.wave
fluxall004=all004.flux
oplot,waveall004,fluxall004

flux108_118=(fluxall001+fluxall002+fluxall003+fluxall004)/4.
wave108_118=(waveall001+waveall002+waveall003+waveall004)/4.
oplot,wave108_118,flux108_118,color=fsc_color('red')

;defines output spectrum file ;
sp1='/home/groh/espectros/agcar/agc_fuse_920_101idl.txt'
openw,5,sp1     ; open file to write
for i=0., 7692. do begin
printf,5,wave920_101[i],flux920_101[i]
endfor
close,5

sp2='/home/groh/espectros/agcar/agc_fuse_990_108idl.txt'
openw,6,sp2     ; open file to write
for i=0., 7692. do begin
printf,6,wave990_108[i],flux990_108[i]
endfor
close,6

sp3='/home/groh/espectros/agcar/agc_fuse_108_118idl.txt'
openw,7,sp3     ; open file to write
for i=0., 7692. do begin
printf,7,wave108_118[i],flux108_118[i]
endfor
close,7

END
