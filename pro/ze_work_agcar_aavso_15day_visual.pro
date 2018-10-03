dir='/Users/jgroh/espectros/agcar/'
aavso='agc_aavso_visual_15day.txt'
data=read_ascii(dir+aavso)

nrec=(size(data.field1))[2]
jd=dblarr(nrec) & v=jd 

jd[*]=data.field1[0,*]
v[*]=data.field1[1,*]

;converting from HJD to year fraction
yr_frac=dblarr(nrec) & month=lonarr(nrec) & day=month & year=day & hour=day & dy=month

for i=0,nrec-1 do begin
caldat,2400000+jd[i],month1,day1,year1,hour1
month[i]=month1
day[i]=day1
year[i]=year1
hour[i]=hour1
dy[i]=ymd2dn(year[i],month[i],day[i])
yr_frac[i]=year[i]+(dy[i]+hour[i]/23.947)/365.25 ;rough
yr_frac[i]=2000.0 + (jd[i] - 51544.5) / 365.25 ;more precise
endfor

;intepolate data
npts=20000.
jdi=indgen(npts,/DOUBLE)*1. 
for i=0., npts-1. do begin
jdi[i]=min(jd)+((jdi[i])*(max(jd)-min(jd))/(npts-1.*1.))
endfor
linterp,jd,v,jdi,vi
linterp,jd,yr_frac,jdi,yr_fraci
linterp,jd,year,jdi,yeari
linterp,jd,month,jdi,monthi
linterp,jd,day,jdi,dayi
linterp,jd,hour,jdi,houri
linterp,jd,dy,jdi,dyi


for i=0,npts-1 do begin
caldat,2400000+jdi[i],month1,day1,year1,hour1
monthi[i]=month1
dayi[i]=day1
yeari[i]=year1
houri[i]=hour1
dyi[i]=ymd2dn(yeari[i],monthi[i],dayi[i])
;yr_fraci[i]=yeari[i]+(dyi[i]+houri[i]/23.947)/365.25 ;rough
yr_fraci[i]=2000.0 + (jdi[i] - 51544.5) / 365.25 ;more precise
endfor

;read dates when spectra are available
spec_av='/Users/jgroh/espectros/agcar/spec_dates_avai.txt'
data2=read_ascii(spec_av)
nrec2=(size(data2.field1))[2]
yr_av=dblarr(nrec2) & month_av=yr_av & day_av=yr_av & jd_av=yr_av &  v_av=yr_av & yr_frac_av=yr_av
yr_av[*]=data2.field1[0,*]
month_av[*]=data2.field1[1,*]
day_av[*]=data2.field1[2,*]
;convert dates when spectra are available to JD - 2400000
FOR i=0, nrec2-1 DO jd_av[i]=JULDAY(month_av[i],day_av[i]-1,yr_av[i]) - 2400000.
;find index o interpolated data corresponding to when spectra were taken
near1=dblarr(nrec2) & index1=near1 & near2=dblarr(nrec2) & index2=near2
FOR i=0, nrec2-1 DO BEGIN
near11=Min(Abs(jd_av[i] - jdi), index11)
near22=Min(Abs(jd_av[i] - jd), index22)
near1[i]=near11
index1[i]=index11
near2[i]=near22
index2[i]=index22
v_av[i]=vi[index11]
yr_frac_av[i]=yr_fraci[index11]
ENDFOR
zeropointflamv=3.75e-9
fluxvisual_av=10^(-1*v_av/2.5)*zeropointflamv

;output original data to archive for checking
output='/Users/jgroh/temp/output_agc_aavso15_mag_year_date_jd.txt'
openw,1,output
for i=0,nrec-1 do begin
printf,1,FORMAT='(F8.2,2x,F9.4,2x,F4.2,2x,I0,2x,I0,2x,I0)',jd[i]+00000.,yr_frac[i],v[i],year[i],month[i],day[i]
endfor
close,1

;output interpolated data to archive for checking
output2='/Users/jgroh/temp/output_agc_aavso15_mag_year_date_jd_interp.txt'
openw,2,output2
for i=0.,npts-1. do begin
printf,2,FORMAT='(F8.2,2x,F9.4,2x,F4.2,2x,I0,2x,I0,2x,I0)',jdi[i]+00000.,yr_fraci[i],vi[i],yeari[i],monthi[i],dayi[i]
endfor
close,2

;output uvby  magnitudes interpolated to the epoch of the observations to archive; THAT's WHAT WE WANT FOR THE PAPER
 output3='/Users/jgroh/temp/output_agc_aavso15_mag_year_date_jd_interp_to_spec_dates.txt'
openw,3,output3
for i=0.,nrec2-1. do begin
printf,3,FORMAT='(F8.2,2x,F9.4,2x,F4.1,2x,I0,2x,I0,2x,I0,5x,F7.2,2x,E16.2)',jd_av[i]+00000.,yr_frac_av[i],v_av[i],yr_av[i],month_av[i],day_av[i], near2[i],fluxvisual_av[i]
endfor
close,3

END