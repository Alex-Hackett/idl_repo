;PRO ZE_WORK_ETACAR_INTERFEROMETRY_PIONIER

dirdata='/Users/jgroh/etacar_pionier/'
data2012mar06='2012-03-06_SCI_ETA_CAR_oiDataCalib.fits'
data2013feb04='2013-02-04_SCI_ETA_CAR_oiDataCalib.fits'
data2013feb10='2013-02-10_SCI_ETA_CAR_oiDataCalib.fits'
data2013feb20='2013-02-20_SCI_ETA_CAR_oiDataCalib.fits'

;reads OIfits data
read_oidata,dirdata+data2012mar06, oiarray2012mar06,oitarget2012mar06,oiwavelength2012mar06, oivis2012mar06, oivis22012mar06,oit32012mar06, /inventory 
extract_vis2data, vis2data2012mar06, oivis2= oivis22012mar06,oiwavelength=oiwavelength2012mar06, oitarget=oitarget2012mar06

!P.BACKGROUND=fsc_color('white')
;lineplot,vis2data2012mar06.baseline / (vis2data2012mar06.eff_wave *1e6), vis2data2012mar06.vis2data


;reads OIfits data
read_oidata,dirdata+data2013feb04, oiarray2013feb04,oitarget2013feb04,oiwavelength2013feb04, oivis2013feb04, oivis22013feb04,oit32013feb04, /inventory 
extract_vis2data, vis2data2013feb04, oivis2= oivis22013feb04,oiwavelength=oiwavelength2013feb04, oitarget=oitarget2013feb04

!P.BACKGROUND=fsc_color('white')
;lineplot,vis2data2013feb04.baseline / (vis2data2013feb04.eff_wave *1e6), vis2data2013feb04.vis2data

;reads OIfits data
read_oidata,dirdata+data2013feb10, oiarray2013feb10,oitarget2013feb10,oiwavelength2013feb10, oivis2013feb10, oivis22013feb10,oit32013feb10, /inventory 
extract_vis2data, vis2data2013feb10, oivis2= oivis22013feb10,oiwavelength=oiwavelength2013feb10, oitarget=oitarget2013feb10

!P.BACKGROUND=fsc_color('white')
;lineplot,vis2data2013feb10.baseline / (vis2data2013feb10.eff_wave *1e6), vis2data2013feb10.vis2data

;reads OIfits data
read_oidata,dirdata+data2013feb20, oiarray2013feb20,oitarget2013feb20,oiwavelength2013feb20, oivis2013feb20, oivis22013feb20,oit32013feb20, /inventory 
extract_vis2data, vis2data2013feb20, oivis2= oivis22013feb20,oiwavelength=oiwavelength2013feb20, oitarget=oitarget2013feb20

!P.BACKGROUND=fsc_color('white')
;lineplot,vis2data2013feb20.baseline / (vis2data2013feb20.eff_wave *1e6), vis2data2013feb20.vis2data

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,vis2data2012mar06.baseline / (vis2data2012mar06.eff_wave *1e6),vis2data2012mar06.vis2data,'Spatial frequency (m/micron)','Squared Visibility',$
                               _EXTRA=extra,psym1=4,symsize1=1,symcolor1='cyan', $
                               x2=vis2data2013feb04.baseline / (vis2data2013feb04.eff_wave *1e6), y2=vis2data2013feb04.vis2data,psym2=4,symsize2=1.0,symcolor2='blue',$
                               x3=vis2data2013feb10.baseline / (vis2data2013feb10.eff_wave *1e6), y3=vis2data2013feb10.vis2data,psym3=4,symsize3=1.0,symcolor3='red',$
                               x4=vis2data2013feb20.baseline / (vis2data2013feb20.eff_wave *1e6), y4=vis2data2013feb20.vis2data,psym4=4,symsize4=1.0,symcolor4='green',$
                               x5=ftxaxis,y5=(ftransfnorm_lambda^2)*0.875,linestyle5=0,color5='black',$ 
          ;                     x6=ftxaxis15,y6=(ftransfnorm_lambda15^2)*0.875,linestyle6=0,color6='pink',$ 
                               xcharsize=1.5,ycharsize=1.5,POSITION=[0.15,0.16,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21,ct=0,/ylog,$
                               xrange=[0,100],yrange=[0.007,1.0];,$
 
bands2012mar06=[1.5585800e-06,  1.5994200e-06,   1.6402500e-06,   1.6810800e-06,   1.7219199e-06,   1.7627500e-06,   1.8035799e-06]
bands2013feb04=[1.5842799e-06,   1.6703682e-06,   1.7559073e-06]
bands2013feb10=[1.5346493e-06,   1.5725359e-06,   1.6245700e-06,   1.6769684e-06,   1.7285458e-06,   1.7810362e-06,   1.8167652e-06]
bands2013feb20=[1.5296423e-06,    1.5665147e-06,   1.6174893e-06,   1.6697153e-06,   1.7211727e-06,   1.7741932e-06,   1.8120795e-06]

                       
band2012mar06_1=where(vis2data2012mar06.eff_wave eq bands2012mar06[0])

ZE_EVOL_PLOT_XY_GENERAL_EPS_V2,vis2data2012mar06[band2012mar06_1].baseline / (vis2data2012mar06[band2012mar06_1].eff_wave *1e6),vis2data2012mar06[band2012mar06_1].vis2data,'Spatial frequency (m/micron)','Squared Visibility sel',$
                               _EXTRA=extra,psym1=4,symsize1=1,symcolor1='cyan', $
                        ;       x2=vis2data2013feb04.baseline / (vis2data2013feb04.eff_wave *1e6), y2=vis2data2013feb04.vis2data,psym2=4,symsize2=1.0,symcolor2='blue',$
                        ;       x3=vis2data2013feb10.baseline / (vis2data2013feb10.eff_wave *1e6), y3=vis2data2013feb10.vis2data,psym3=4,symsize3=1.0,symcolor3='red',$
                        ;      x4=vis2data2013feb20.baseline / (vis2data2013feb20.eff_wave *1e6), y4=vis2data2013feb20.vis2data,psym4=4,symsize4=1.0,symcolor4='green',$
                               x5=ftxaxis,y5=(ftransfnorm_lambda^2)*0.925,linestyle5=0,color5='black',$ 
                             ;  x6=ftxaxis15,y6=(ftransfnorm_lambda15^2)*0.875,linestyle6=0,color6='pink',$ 
                               xcharsize=1.5,ycharsize=1.5,POSITION=[0.15,0.16,0.97,0.97],XMARGIN=[15,3],YMARGIN=[8,1],charthick=21,xthick=21,ythick=21,ct=0,/ylog,$
                               xrange=[0,100],yrange=[0.007,1.0];,$


END