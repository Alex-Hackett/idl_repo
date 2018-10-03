;PRO ZE_CMFGEN_MERGE_DC,dcmerge,ndmerge
dir1='/Users/jgroh/ze_models/timedep_armagh/14/'
dir2='/Users/jgroh/ze_models/timedep_armagh/14/'

ion1='HI'
sufix1='OUT'

depth_merge=14 ;uses dc1 for depth < depth_merge and dc2 for depth >= depth_merge

ZE_CMFGEN_READ_DC, dir1, ion1,sufix1,dc1,ns1,nd1

ion2=ion1
sufix2=sufix1
ZE_CMFGEN_READ_DC, dir2, ion2,sufix2,dc2,ns2,nd2

ndmerge=nd2 + (nd2-nd1)

dcmerge=dblarr(ns1,ndmerge) ;assumes ns1,ns2 are the same, i.e. same model atom and number of super levels and that nd1,nd2 are the same

dcmerge[*,0:depth_merge-2]=dc1[*,0:depth_merge-2]
dcmerge[*,depth_merge-1:nd2-1]=dc2[*,depth_merge-1:nd2-1]

END