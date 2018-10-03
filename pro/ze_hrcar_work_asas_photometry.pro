;asas_cut='/Users/jgroh/espectros/agcar/agcar_V_photometry_asas_new_cut2.txt'
asas_cut='/Users/jgroh/espectros/hrcar/hrcar_V_photometry_asas_2009jul17.txt'
ze_read_asas_photometry_cut,asas_cut,data
set_plot,'x'
;note on ASAS apertures: mag0=2pix, max1=3 pix, 4 pix, 5 pix, and mag4=6pix. Plate scale is 15 arcsec/pix.
;ASAS magnitude should be used only for V>7.
;best aperture for AG car is 6pix = 90 arcsec (!)

;select only grade A data
nrec=(size(data.grade))[1]
t=fltarr(nrec)
for i=0, nrec-1 do begin
if data.grade[i] ne 'A' then begin
t[i]=i
endif else begin
;t[i]=0
endelse
endfor
t=where(t ne 0)

hjd_sela=data.hjd
mag4_sela=data.mag4
mag3_sela=data.mag3

;converting from HJD to year fraction
yr_frac=dblarr(nrec) & month=lonarr(nrec) & day=month & year=day & hour=day & dy=month

for i=0,nrec-1 do begin
caldat,2450000+data.hjd[i],month1,day1,year1,hour1
month[i]=month1
day[i]=day1
year[i]=year1
hour[i]=hour1
dy[i]=ymd2dn(year[i],month[i],day[i])
;yr_frac[i]=year[i]+(dy[i]+hour[i]/23.947)/365.25 ;rough
yr_frac[i]=2000.0 + (data.hjd[i] - 1544.5) / 365.25 ;more precise
endfor


remove,t,hjd_sela
remove,t,mag3_sela
remove,t,mag4_sela
remove,t,yr_frac
remove,t,year
remove,t,month
remove,t,day
remove,t,hour

;sorting vectors to increasing HJD date
nrec_sela=(size(yr_frac))[1]
hjd_sela2=hjd_sela[SORT(hjd_sela)]
mag4_sela2=mag4_sela[SORT(hjd_sela)]
mag3_sela2=mag3_sela[SORT(hjd_sela)]
yr_frac2=yr_frac[SORT(hjd_sela)]
year2=year[SORT(hjd_sela)]
month2=month[SORT(hjd_sela)]
day2=day[SORT(hjd_sela)]
hour2=hour[SORT(hjd_sela)]

;computing average for a given number of days
npts=50000.
hjdi=indgen(npts,/DOUBLE)*1. 
for i=0., npts-1. do begin
hjdi[i]=min(hjd_sela2)+((hjdi[i])*(max(hjd_sela2)-min(hjd_sela2))/(npts-1.*1.))
endfor
linterp,hjd_sela2,mag4_sela2,hjdi,mag4i
linterp,hjd_sela2,yr_frac2,hjdi,yr_frac2i

sampling_days=hjdi[999]-hjdi[998]
ave_days=15.
avepts=ave_days/sampling_days
mag4_sela2_med=median(mag4i,avepts)
linterp,hjdi,mag4_sela2_med,hjd_sela2,mag4_median_fin

;read dates when spectra are available
spec_av='/Users/jgroh/espectros/hrcar/spec_dates_avai.txt'
data2=read_ascii(spec_av)
nrec2=(size(data2.field1))[2]
yr_av=dblarr(nrec2) & month_av=yr_av & day_av=yr_av & jd_av=yr_av & v_av=yr_av  & yr_frac_av=yr_av
yr_av[*]=data2.field1[0,*]
month_av[*]=data2.field1[1,*]
day_av[*]=data2.field1[2,*]
;convert dates when spectra are available to JD - 2450000
FOR i=0, nrec2-1 DO jd_av[i]=JULDAY(month_av[i],day_av[i],yr_av[i]) - 2450000.
;find index o interpolated data corresponding to when spectra were taken
near1=dblarr(nrec2) & index1=near1 & near2=dblarr(nrec2) & index2=near2 & absdeltat=near2
FOR i=0, nrec2-1 DO BEGIN
near11=Min(Abs(jd_av[i] - hjdi), index11)
near22=Min(Abs(jd_av[i] - hjd_sela2), index22)
near1[i]=near11
index1[i]=index11
near2[i]=near22
index2[i]=index22
absdeltat2=jd_av[i] - hjd_sela2[index22]
absdeltat[i]=absdeltat2
v_av[i]=mag4_sela2_med[index11]
yr_frac_av[i]=yr_frac2i[index11]
ENDFOR
zeropointflamv=3.75e-9
fluxv_av=10^(-1*v_av/2.5)*zeropointflamv

;plotting
window,1
plot,hjd_sela2,mag4_sela2,xstyle=9,ystyle=1,yrange=[8.5,5.],psym=2,xrange=[1800,2300]
plots,hjd_sela2,mag4_sela2,color=fsc_color('white')
plots,hjdi,mag4_sela2_med,color=fsc_color('blue')
plots,hjd_sela2,mag4_median_fin,color=fsc_color('green'),psym=1
AXIS,XAXIS=1,XRANGE=[MIN(YR_FRAC),MAX(YR_FRAC)],XSTYLE=1


;output to archive for plotting in XMGRACE
output='/Users/jgroh/temp/output_asas_mag_hrc.txt'
openw,1,output
for i=0,nrec_sela -1 do begin
printf,1,hjd_sela2[i]+50000.-1,mag4_median_fin[i]
endfor
close,1

;output HJD and calendar dates to archive for cheching
output2='/Users/jgroh/temp/output_asas_mag_hrc_year_hjd.txt'
openw,2,output2
for i=0,nrec_sela -1 do begin
printf,2,hjd_sela2[i]+50000.-1,yr_frac2[i],year2[i],month2[i],day2[i],mag4_median_fin[i]
endfor
close,2

ZE_HRCAR_PLOT_LIGHTCURVE,hjd_sela2,yr_frac2,mag4_median_fin,jd_av

;output V magnitudes interpolated to the epoch of the observations to archive; THAT's WHAT WE WANT FOR THE PAPER
 output3='/Users/jgroh/temp/output_hrc_asas_V_mag_year_date_jd_interp_to_spec_dates.txt'
openw,3,output3
for i=0.,nrec2-1. do begin
printf,3,FORMAT='(F8.2,2x,F9.4,2x,F4.2,2x,I0,2x,I0,2x,I0,2x,I0,2x,E16.2)',jd_av[i]+50000.-1,yr_frac_av[i],v_av[i],yr_av[i],month_av[i],day_av[i], absdeltat[i],fluxv_av[i]
endfor
close,3

END
