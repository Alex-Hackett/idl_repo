PRO ZE_READ_ASAS_PHOTOMETRY_CUT,asas_cut,data

;Restore template file
restore,'/Users/jgroh/espectros/agcar/asas_photometry_cut_template.idl'
data=read_ascii(asas_cut, TEMPLATE=template2,DATA_START=1, MISSING_VALUE=0., header=header)

END
