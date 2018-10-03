!P.Background = fsc_color('white')
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/agcar_uves_2003jan11.dat',l03jan,f03jan
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/agcar_feros_2002mar17.dat',l02mar,f02mar
ZE_READ_SPECTRA_COL_VEC,'/Users/jgroh/temp/agcar_feros_2001apr12.dat',l01apr,f01apr

lineplot,l01apr,f01apr
lineplot,l02mar,f02mar
lineplot,l03jan,f03jan
END