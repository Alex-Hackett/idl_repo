PRO ZE_EVOL_LOAD_ALL_VARIABLES_WGFILE_CUT,nm,u1,u2,xl,xtt,u5,u7,b33,u8,u9,u10,u12,u13,u14,u6,u11,$
              qmnc,xte,xmdot,rhoc,tc,u15,u17,b33m,u18,u19,u20,u22,u23,u24,$
              u16,u21,ybe7m,yb8m,flube7,flub8,snube7,snub8,rapcrj,rot1,rotm,xobla,$
              u27,u33,alpro6,lcnom,xmcno,scno,xjspe1,xjspe2,vcri1m,vcri2m,vequam,rapomm,$
              eddesm,vcrit1,vcrit2,vequa,rapom2,eddesc,dmneed,xmdotneed,dlelex,bmomit,btot,$
              ekrote,epote,ekine,erade,uudrawc1,uudrawc2,uudrawc3,uudrawc4,uudrawc5,uudrawc6,uudrawc7,$
              uudrawc8,uudrawc9,uudrawc10,uudrawc11,uudrawc12,uudrawc13,uudrawc14,uudrawc15,uudrawc16,uudrawc17,uudrawc18,uudrawc19,$
              uudrawc20,uudrawc21,uudrawc22,uudrawc23,uudrawc24,uudrawc25,uudrawc26,uudrawc27,uudrawc28,uudrawc29,uudrawc30,uudrawc31,$
              uudrawc32,uudrawc33,uudrawc34,uudrawc35,uudrawc36,uudrawc37,uudrawc38,uudrawc39,uudrawc40,btotatm

;NEEDS WORK

ZE_EVOL_READ_WG_FILE_FROM_GENEVA_ORIGIN2010_V2,wgfile,data_wgfile,data_wgfile_cut
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'nm',data_wgfile_cut,nm
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u1',data_wgfile_cut,u1
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u2',data_wgfile_cut,u2
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xl',data_wgfile_cut,xl
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'xtt',data_wgfile_cut,xtt
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u5',data_wgfile_cut,u5
ZE_EVOL_OBTAIN_VARIABLE_FROM_WGFILE_CUT,'u10',data_wgfile_cut,u10


END