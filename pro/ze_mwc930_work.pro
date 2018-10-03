;PRO ZE_MWC930_WORK
dir='/Users/jgroh/espectros/MWC930/'
file='Hermes_MWC930.asc'
data=READ_ASCII(dir+file,DATA_START=1)
!P.Background = fsc_color('white')
lineplot,data.field1[0,*],data.field1[1,*]
END