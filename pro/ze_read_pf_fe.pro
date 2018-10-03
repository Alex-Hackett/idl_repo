PRO ZE_READ_PF_FE,pffe1p,pffe2p,pffe3p,pffe4p

fpfe1p='/Users/jgroh/ze_models/agcar/FE02.DAT'
fpfe2p='/Users/jgroh/ze_models/agcar/FE03.DAT'
fpfe3p='/Users/jgroh/ze_models/agcar/FE04.DAT'
fpfe4p='/Users/jgroh/ze_models/agcar/FE05.DAT'

pffe1p=read_ascii(fpfe1p, DATA_START=6, MISSING_VALUE=0.)
pffe2p=read_ascii(fpfe2p, DATA_START=6, MISSING_VALUE=0.)
pffe3p=read_ascii(fpfe3p, DATA_START=6, MISSING_VALUE=0.)
pffe4p=read_ascii(fpfe4p, DATA_START=6, MISSING_VALUE=0.)


END