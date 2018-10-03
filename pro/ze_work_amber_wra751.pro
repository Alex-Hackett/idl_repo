;PRO ZE_WORK_AMBER_WRA751
!P.Background = fsc_color('white')
dir1='/Users/jgroh/data/eso/amber/lbvs_p85/28apr10/28apr10_PRODUCT/FLUX_100_percent_PISTON_100_percent_SNR_100_percent/ASCII_6000ms/'
dir2='/Users/jgroh/data/eso/amber/lbvs_p85/28apr10/28apr10_PRODUCT/FLUX_100_percent_PISTON_100_percent_SNR_20_percent/ASCII_6000ms/'

filesp='AMBER.2010-04-28T03:05:14.860_AMBER.2010-04-28T02:42:45.076_CALPHOT.ASCII'
datasp=read_ascii(dir1+filesp) 
lsp=REFORM(datasp.field1[0,*])*1e6 ;in microns
lineplot,l,REFORM(datasp.field1[1,*]),yrange=[0,1.2]
;lineplot,lsp,REFORM(datasp.field1[1,*])
;lineplot,l,REFORM(data.field01[5,*])


fileint='hrcar-2-5_AVG_CALIB_K.fits.ASCII'
;wlen(j,1),sqVis(1,j,1), sqVisErr(1,j,1), sqVis(2,j,1), sqVisErr(2,j,1), sqVis(3,j,1), sqVisErr(3,j,1), diffVisPhase(1,j,1), diffVisPhaseErr(1,j,1), diffVisPhase(2,j,1), diffVisPhaseErr(2,j,1),diffVisPhase(3,j,1),diffVisPhaseErr(3,j,1), diffVisAmp(1,j,1),diffVisAmpErr(1,j,1), diffVisAmp(2,j,1),diffVisAmpErr(2,j,1),diffVisAmp(3,j,1), diffVisAmpErr(3,j,1),vis3Phase(1,j,1),vis3PhaseErr(1,j,1), spectrum(1,j), spectrumErr(1,j), spectrum(2,j),spectrumErr(2,j), spectrum(3,j), spectrumErr(3,j)
;  0          1             2                3                4                5            6                7                    8                        9                      10                  11                  12                      13                    14                  15                  16                17                    18                  19              20                    21        22                    23            24              25                  26 
dataint=read_ascii(dir2+fileint) 
l=REFORM(dataint.field01[0,*])*1e15 ;in microns
;lineplot,l,REFORM(data.field01[1,*])
lineplot,l,REFORM(dataint.field01[1,*])
;lineplot,l,REFORM(data.field01[5,*])




END