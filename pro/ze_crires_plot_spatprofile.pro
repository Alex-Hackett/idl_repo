PRO ZE_CRIRES_PLOT_SPATPROFILE,indexspat,dataa2,pos1,pos2,pos3,prof1,prof2,prof3

prof1=dblarr(n_elements(indexspat)) & prof2=prof1 & prof3=prof1

prof1[*]=dataa2[pos1,*]
prof2[*]=dataa2[pos2,*]
prof3[*]=dataa2[pos3,*]

lineplot,indexspat,prof1/max(prof1), title=strcompress(string(pos1, format='(I04)'))
lineplot,indexspat,prof2/max(prof2), title=strcompress(string(pos2, format='(I04)'))
lineplot,indexspat,prof3/max(prof3), title=strcompress(string(pos3, format='(I04)'))
END