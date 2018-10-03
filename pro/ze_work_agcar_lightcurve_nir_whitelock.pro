agc_nir='/Users/jgroh/espectros/agcar/agcar_lightcurve_jhkl_whitelock_ed.txt'
data=read_ascii(agc_nir)

nrec=(size(data.field1))[2]
j=dblarr(nrec) & h=j & k=j & l=j & jd=j

jd[*]=data.field1[0,*]
j[*]=data.field1[1,*]
h[*]=data.field1[2,*]
k[*]=data.field1[3,*]
l[*]=data.field1[4,*]

;converting from HJD to year fraction
yr_frac=dblarr(nrec) & month=lonarr(nrec) & day=month & year=day & hour=day & dy=month

for i=0,nrec-1 do begin
caldat,2440000+jd[i],month1,day1,year1,hour1
month[i]=month1
day[i]=day1
year[i]=year1
hour[i]=hour1
dy[i]=ymd2dn(year[i],month[i],day[i])
yr_frac[i]=year[i]+(dy[i]+hour[i]/23.947)/365.25 ;rough
yr_frac[i]=2000.0 + (jd[i] - 11544.5) / 365.25 ;more precise
endfor

;intepolate data
npts=20000.
jdi=indgen(npts,/DOUBLE)*1. 
for i=0., npts-1. do begin
jdi[i]=min(jd)+((jdi[i])*(max(jd)-min(jd))/(npts-1.*1.))
endfor
linterp,jd,j,jdi,ji
linterp,jd,h,jdi,hi
linterp,jd,k,jdi,ki
linterp,jd,l,jdi,li
linterp,jd,yr_frac,jdi,yr_fraci
linterp,jd,year,jdi,yeari
linterp,jd,month,jdi,monthi
linterp,jd,day,jdi,dayi
linterp,jd,hour,jdi,houri
linterp,jd,dy,jdi,dyi


for i=0,npts-1 do begin
caldat,2440000+jdi[i],month1,day1,year1,hour1
monthi[i]=month1
dayi[i]=day1
yeari[i]=year1
houri[i]=hour1
dyi[i]=ymd2dn(yeari[i],monthi[i],dayi[i])
;yr_fraci[i]=yeari[i]+(dyi[i]+houri[i]/23.947)/365.25 ;rough
yr_fraci[i]=2000.0 + (jdi[i] - 11544.5) / 365.25 ;more precise
endfor

;read dates when spectra are available
spec_av='/Users/jgroh/espectros/agcar/spec_dates_avai.txt'
data2=read_ascii(spec_av)
nrec2=(size(data2.field1))[2]
yr_av=dblarr(nrec2) & month_av=yr_av & day_av=yr_av & jd_av=yr_av & j_av=yr_av & h_av=j_av & k_av=j_av & l_av=j_av & yr_frac_av=j_av
yr_av[*]=data2.field1[0,*]
month_av[*]=data2.field1[1,*]
day_av[*]=data2.field1[2,*]
;convert dates when spectra are available to JD - 2440000
FOR i=0, nrec2-1 DO jd_av[i]=JULDAY(month_av[i],day_av[i]-1,yr_av[i]) - 2440000.
;find index o interpolated data corresponding to when spectra were taken
near1=dblarr(nrec2) & index1=near1 & near2=dblarr(nrec2) & index2=near2 & absdeltat=near2
FOR i=0, nrec2-1 DO BEGIN
near11=Min(Abs(jd_av[i] - jdi), index11)
near22=Min(Abs(jd_av[i] - jd), index22)
near1[i]=near11
index1[i]=index11
near2[i]=near22
index2[i]=index22
absdeltat2=jd_av[i] - jd[index22]
absdeltat[i]=absdeltat2
j_av[i]=ji[index11]
h_av[i]=hi[index11]
k_av[i]=ki[index11]
l_av[i]=li[index11]
yr_frac_av[i]=yr_fraci[index11]
ENDFOR

;computing fluxes
zeropointflamj=3.134e-10 ; for 2MASS j ; JHKs should be ok with SAAO within 0.05 mag
zeropointflamh=1.11e-10 ; for 2MASS H
zeropointflamk=4.29e-11 ; for 2MASS Ks
zeropointflaml=6.89e-12 ; for Johnson L
fluxj_av=10^(-1*j_av/2.5)*zeropointflamj
fluxh_av=10^(-1*h_av/2.5)*zeropointflamh
fluxk_av=10^(-1*k_av/2.5)*zeropointflamk
fluxl_av=10^(-1*l_av/2.5)*zeropointflaml

;output original data to archive for checking
output='/Users/jgroh/temp/output_agc_nir_whitelock_mag_year_date_jd.txt'
openw,1,output
for i=0,nrec-1 do begin
printf,1,FORMAT='(F8.2,2x,F9.4,2x,F4.2,2x,F4.2,2x,F4.2,2x,F4.2,2x,I0,2x,I0,2x,I0)',jd[i]+40000.,yr_frac[i],j[i],h[i],k[i],l[i],year[i],month[i],day[i]
endfor
close,1

;output interpolated data to archive for checking
output2='/Users/jgroh/temp/output_agc_nir_whitelock_mag_year_date_jd_interp.txt'
openw,2,output2
for i=0.,npts-1. do begin
printf,2,FORMAT='(F8.2,2x,F9.4,2x,F4.2,2x,F4.2,2x,F4.2,2x,F4.2,2x,I0,2x,I0,2x,I0)',jdi[i]+40000.,yr_fraci[i],ji[i],hi[i],ki[i],li[i],yeari[i],monthi[i],dayi[i]
endfor
close,2

;output JHKL magnitudes interpolated to the epoch of the observations to archive; THAT's WHAT WE WANT FOR THE PAPER
 output3='/Users/jgroh/temp/output_agc_nir_whitelock_mag_year_date_jd_interp_to_spec_dates.txt'
openw,3,output3
for i=0.,nrec2-1. do begin
;printf,3,FORMAT='(F8.2,2x,F9.4,2x,F4.2,2x,F4.2,2x,F4.2,2x,F4.2,2x,I0,2x,I0,2x,I0,2x,F5.2)',jd_av[i]+40000.,yr_frac_av[i],j_av[i],h_av[i],k_av[i],l_av[i],yr_av[i],month_av[i],day_av[i], near2[i]
printf,3,FORMAT='(I0,2x,I0,2x,I0,2x,I5,2x,F4.2,2x,F4.2,2x,F4.2,2x,F4.2,2x,F5.2)',$
yr_av[i],month_av[i],day_av[i],jd_av[i]+40000.,j_av[i],h_av[i],k_av[i],l_av[i], near2[i]

endfor
close,3

;output JHKL magnitudes and fluxes interpolated to the epoch of the observations to archive; THAT's WHAT WE WANT FOR THE PAPER
 output4='/Users/jgroh/temp/output_agc_nir_whitelock_mag_flux_year_date_jd_interp_to_spec_dates.txt'
openw,4,output4
for i=0.,nrec2-1. do begin
;printf,3,FORMAT='(F8.2,2x,F9.4,2x,F4.2,2x,F4.2,2x,F4.2,2x,F4.2,2x,I0,2x,I0,2x,I0,2x,F5.2)',jd_av[i]+40000.,yr_frac_av[i],j_av[i],h_av[i],k_av[i],l_av[i],yr_av[i],month_av[i],day_av[i], near2[i]
printf,4,FORMAT='(I0,2x,I0,2x,I0,2x,I5,2x,F4.2,2x,F4.2,2x,F4.2,2x,F4.2,2x,I0,2x, E16.2,2x, E16.2,2x, E16.2,2x, E16.2)',$
yr_av[i],month_av[i],day_av[i],jd_av[i]+40000.,j_av[i],h_av[i],k_av[i],l_av[i], absdeltat[i],fluxj_av[i],fluxh_av[i],fluxk_av[i],fluxl_av[i]

endfor
close,4


LOADCT,0
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')

ca=3
csize=2.
cp=2.
usymsize=1


window,0
plot,jd+40000.,j,ystyle=1,xstyle=1,/nodata,yrange=[6.8,2.6]
plots,jd+40000.,j,color=fsc_color('black'),noclip=0,psym=2,thick=cp,symsize=usymsize
plots,jd+40000.,h,color=fsc_color('black'),noclip=0,psym=3,thick=cp,symsize=usymsize
plots,jd+40000.,k,color=fsc_color('black'),noclip=0,psym=4,thick=cp,symsize=usymsize
plots,jd+40000.,l,color=fsc_color('black'),noclip=0,psym=5,thick=cp,symsize=usymsize

;eps plots

set_plot,'ps'
device,/close

device,filename='/Users/jgroh/temp/output_agc_jhkl_lightcurve_whitelock.eps',/encapsulated,/color,bit=8,xsize=8.48,ysize=6.48,/inches

!p.multi=[0, 1, 1, 0, 0]
ca=3
csize=2.
cp=3.
usymsize=0.5
!Y.ThICK=3.
!X.thick=3.

;finding correct x axis limits in fractional years
xmin=44500.
xmax=53100.
caldat,2400000+xmin,month1,day1,year1,hour1
caldat,2400000+xmax,month2,day2,year2,hour2
dy1=ymd2dn(year1,month1,day1)
xminyr_frac=year1+(dy1+hour1/24.)/365.
dy2=ymd2dn(year2,month2,day2)
xmaxyr_frac=year2+(dy2+hour2/24.)/365.

plot,jd+40000.,j,ystyle=1,xstyle=9,yrange=[6.8,2.6],charthick=ca,XTICKFORMAT="(I5)",xrange=[xmin,xmax],$
ytitle='mag',xtitle=TEXTOIDL('JD-2400000'),/nodata,charsize=csize,XMARGIN=[4.3,3],YMARGIN=[3.2,1.7];,POSITION=[0.11,0.10,0.959,0.49]
plots,jd+40000.,j,color=fsc_color('black'),noclip=0,psym=2,symsize=usymsize,thick=cp
plots,jd+40000.,j,color=fsc_color('black'),noclip=0,linestyle=0,thick=cp+0.5
plots,jd+40000.,h,color=fsc_color('black'),noclip=0,psym=6,symsize=usymsize,thick=cp
plots,jd+40000.,h,color=fsc_color('black'),noclip=0,linestyle=2,thick=cp
plots,jd+40000.,k,color=fsc_color('black'),noclip=0,psym=4,symsize=usymsize,thick=cp
plots,jd+40000.,k,color=fsc_color('black'),noclip=0,linestyle=3,thick=cp
plots,jd+40000.,l,color=fsc_color('black'),noclip=0,psym=5,symsize=usymsize,thick=cp
plots,jd+40000.,l,color=fsc_color('black'),noclip=0,linestyle=0,thick=cp-1.5
AXIS,XAXIS=1,xrange=[xminyr_frac,xmaxyr_frac],charthick=ca,charsize=csize,xstyle=1

;putting labels
xyouts,53200,4.35,'!8J',color=fsc_color('black'),charthick=cp,charsize=csize
xyouts,53200,3.95,'!8H',color=fsc_color('black'),charthick=cp,charsize=csize
xyouts,53200,3.568,'!8K',color=fsc_color('black'),charthick=cp,charsize=csize
xyouts,53200,3.10,'!8L!3',color=fsc_color('black'),charthick=cp,charsize=csize

device,/close
set_plot,'x'
END
