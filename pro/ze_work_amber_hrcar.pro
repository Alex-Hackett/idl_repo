;PRO ZE_WORK_AMBER_HRCAR
dir='/Users/jgroh/data/eso/amber/lbvs_p85/from_alex/JOSETEST/JOSETEST_PRODUCT/FLUX_100_percent_PISTON_100_percent_SNR_100_percent/ASCII_6000ms/'
file='AMBER.2010-04-25T00:30:15.506_AMBER.2010-04-25T00:08:21.872_CALPHOT.ASCII'
!P.Background = fsc_color('white')
;wlen(j,1),sqVis(1,j,1), sqVisErr(1,j,1), sqVis(2,j,1), sqVisErr(2,j,1), sqVis(3,j,1), sqVisErr(3,j,1), diffVisPhase(1,j,1), diffVisPhaseErr(1,j,1), diffVisPhase(2,j,1), diffVisPhaseErr(2,j,1),diffVisPhase(3,j,1),diffVisPhaseErr(3,j,1), diffVisAmp(1,j,1),diffVisAmpErr(1,j,1), diffVisAmp(2,j,1),diffVisAmpErr(2,j,1),diffVisAmp(3,j,1), diffVisAmpErr(3,j,1),vis3Phase(1,j,1),vis3PhaseErr(1,j,1), spectrum(1,j), spectrumErr(1,j), spectrum(2,j),spectrumErr(2,j), spectrum(3,j), spectrumErr(3,j)
;  0          1             2                3                4                5            6                7                    8                        9                      10                  11                  12                      13                    14                  15                  16                17                    18                  19              20                    21        22                    23            24              25                  26 
data=read_ascii(dir+file) 
l=REFORM(data.field1[0,*])*1e15 ;in microns
;lineplot,l,REFORM(data.field01[1,*])
lineplot,l,REFORM(data.field1[1,*])
;lineplot,l,REFORM(data.field01[5,*])

dirdet='/Users/jgroh/data/eso/amber/detector/'
ffmnov09='AM_GFFM_091104A_ENGINEERING_8.fits'
ffmsep08='FFM_080914.fits'
bpmnov09='AM_GFFM_091104A_ENGINEERING_8.fits'
bpmsep08='FFM_080914.fits'

a = mrdfits(dirdet+ffmsep08, 0, header)
b = mrdfits(dirdet+ffmnov09, 0, header)

c = mrdfits(dirdet+bpmsep08, 0, header)
d = mrdfits(dirdet+bpmnov09, 0, header)

ximage,a
ximage,b
END