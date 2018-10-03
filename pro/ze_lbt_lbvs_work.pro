;PRO ZE_LBT_LBVS_WORK
dir='/Users/jgroh/data/LBT/LUCIFER/'

DARK='luci.20101110.Dark.0001.fits'
FLAT='luci.20101110.0732.fits'
acq1='luci.20101112.0093.fits'
acq2='luci.20101112.0094.fits'

ZE_LBT_LUCIFER_READ_DETECTOR, dir+DARK, 0, dark, headerdark
ZE_LBT_LUCIFER_READ_DETECTOR, dir+FLAT, 0, flat, headerflat
ZE_LBT_LUCIFER_READ_DETECTOR, dir+acq1, 0, acq1, headeracq1
ZE_LBT_LUCIFER_READ_DETECTOR, dir+acq2, 0, acq2, headeracq2


dark10=dark*5. ;since dark image has ITIME=2s
dark30=dark*15. ;since dark image has ITIME=2s

;correcting for flat field vignetting
flat(where(flat lt 5000.))=7083.
median=7083. ;from atv statistics

flatn=((flat-dark10)/median)

acq1p=(acq1-dark30)/flatn
acq1pf=filter_image(acq1p,smooth=3)

acq2p=(acq2-dark30)/flatn
acq2pf=filter_image(acq2,smooth=3)
;atv,acq1,header=headeracq1
atv,acq2pf,header=headeracq2

;on ATV, to ALIGNE WCS LBT image has to be 1) rotated by 90 deg ; 2) invert y



;atv,dark,header=headerdark
;a=300
;b=500
;img=bytscl(dataa2,MIN=a,MAX=b)


;SNR
objectcounts=5571.45
Robject=objectcounts/30. ;counts/s
Psky=350./30. ;counts/s/pixel
t=30.
raper=5.

SNR=Robject*t/SQRT(Robject*t + (Psky*t*!PI*raper^2))
print,'SNR =',SNR


END