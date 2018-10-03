PRO ZE_READ_PIONIER_DATA,vis2data2012mar06,vis2data2013feb04,vis2data2013feb10,vis2data2013feb20,t3data2012mar06,t3data2013feb04,t3data2013feb10,t3data2013feb20
dirdata='/Users/jgroh/etacar_pionier/'
data2012mar06='2012-03-06_SCI_ETA_CAR_oiDataCalib.fits'
data2013feb04='2013-02-04_SCI_ETA_CAR_oiDataCalib.fits'
data2013feb10='2013-02-10_SCI_ETA_CAR_oiDataCalib.fits'
data2013feb20='2013-02-20_SCI_ETA_CAR_oiDataCalib.fits'

;reads OIfits data
read_oidata,dirdata+data2012mar06, oiarray2012mar06,oitarget2012mar06,oiwavelength2012mar06, oivis2012mar06, oivis22012mar06,oit32012mar06, /inventory 
extract_vis2data, vis2data2012mar06, oivis2= oivis22012mar06,oiwavelength=oiwavelength2012mar06, oitarget=oitarget2012mar06
extract_t3data,  t3data2012mar06, oit3= oit32012mar06,oiwavelength=oiwavelength2012mar06, oitarget=oitarget2012mar06,/status


read_oidata,dirdata+data2013feb04, oiarray2013feb04,oitarget2013feb04,oiwavelength2013feb04, oivis2013feb04, oivis22013feb04,oit32013feb04, /inventory 
extract_vis2data, vis2data2013feb04, oivis2= oivis22013feb04,oiwavelength=oiwavelength2013feb04, oitarget=oitarget2013feb04
extract_t3data,  t3data2013feb04, oit3= oit32013feb04,oiwavelength=oiwavelength2013feb04, oitarget=oitarget2013feb04,/status

read_oidata,dirdata+data2013feb10, oiarray2013feb10,oitarget2013feb10,oiwavelength2013feb10, oivis2013feb10, oivis22013feb10,oit32013feb10, /inventory 
extract_vis2data, vis2data2013feb10, oivis2= oivis22013feb10,oiwavelength=oiwavelength2013feb10, oitarget=oitarget2013feb10
extract_t3data,  t3data2013feb10, oit3= oit32013feb10,oiwavelength=oiwavelength2013feb10, oitarget=oitarget2013feb10

read_oidata,dirdata+data2013feb20, oiarray2013feb20,oitarget2013feb20,oiwavelength2013feb20, oivis2013feb20, oivis22013feb20,oit32013feb20, /inventory 
extract_vis2data, vis2data2013feb20, oivis2= oivis22013feb20,oiwavelength=oiwavelength2013feb20, oitarget=oitarget2013feb20
extract_t3data,  t3data2013feb20, oit3= oit32013feb20,oiwavelength=oiwavelength2013feb20, oitarget=oitarget2013feb20

END