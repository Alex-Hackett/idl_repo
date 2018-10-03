;PRO ZE_WORK_PLANCK_FUNCTION_IR

!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

 wave = 2000 + findgen(25)*1000
 bbflux70 = planck(wave,7000)
 bbflux80 = planck(wave,8000)
 bbflux90 = planck(wave,9000)
 bbflux100 = planck(wave,10000)
 bbflux140 = planck(wave,14000)

;window,0
;plot,wave,bbflux1
lineplot,wave,bbflux70
lineplot,wave,bbflux80
lineplot,wave,bbflux90
lineplot,wave,bbflux100
lineplot,wave,bbflux140


END