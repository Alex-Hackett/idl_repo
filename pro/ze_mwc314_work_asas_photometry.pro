;PRO ZE_MWC314_WORK_ASAS_PHOTOMETRY

;asas_cut='/Users/jgroh/espectros/agcar/agcar_V_photometry_asas_new_cut2.txt'
asas_cut='/Users/jgroh/espectros/mwc314/mwc314_asas_cut.txt'
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
mag4_sela_err=data.err4

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
remove,t,mag4_sela_err
remove,t,yr_frac
remove,t,year
remove,t,month
remove,t,day
remove,t,hour

;sorting vectors to increasing HJD date
nrec_sela=(size(yr_frac))[1]
hjd_sela2=hjd_sela[SORT(hjd_sela)]
mag4_sela2=mag4_sela[SORT(hjd_sela)]
mag4_sela2_err=mag4_sela_err[SORT(hjd_sela)]
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
ave_days=1.0
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
plot,hjd_sela2,mag4_sela2,xstyle=9,ystyle=1,yrange=[10.0,9.5],psym=2,xrange=[2300,5300]
plots,hjd_sela2,mag4_sela2,color=fsc_color('red')
plots,hjdi,mag4_sela2_med,color=fsc_color('blue')
plots,hjd_sela2,mag4_median_fin,color=fsc_color('green'),psym=1
AXIS,XAXIS=1,XRANGE=[MIN(YR_FRAC),MAX(YR_FRAC)],XSTYLE=1


;output to archive for plotting in XMGRACE
output='/Users/jgroh/temp/output_asas_mag_mwc314.txt'
openw,1,output
for i=0,nrec_sela -1 do begin
printf,1,FORMAT='(F10.4,2x,F10.4,2x,F10.4)',hjd_sela2[i]+50000.-1,mag4_median_fin[i],mag4_sela2_err[i]
endfor
close,1

;output HJD and calendar dates to archive for cheching
output2='/Users/jgroh/temp/output_asas_mag_mwc314_year_hjd.txt'
openw,2,output2
for i=0,nrec_sela -1 do begin
printf,2,hjd_sela2[i]+50000.-1,yr_frac2[i],year2[i],month2[i],day2[i],mag4_median_fin[i]
endfor
close,2

ZE_MWC314_PLOT_LIGHTCURVE,hjd_sela2,yr_frac2,mag4_median_fin,jd_av

;output V magnitudes interpolated to the epoch of the observations to archive; THAT's WHAT WE WANT FOR THE PAPER
 output3='/Users/jgroh/temp/output_mwc314_asas_V_mag_year_date_jd_interp_to_spec_dates.txt'
openw,3,output3
for i=0.,nrec2-1. do begin
printf,3,FORMAT='(F8.2,2x,F9.4,2x,F4.2,2x,I0,2x,I0,2x,I0,2x,I0,2x,E16.2)',jd_av[i]+50000.-1,yr_frac_av[i],v_av[i],yr_av[i],month_av[i],day_av[i], absdeltat[i],fluxv_av[i]
endfor
close,3


set_plot,'x'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!X.THICK=0
!Y.THICK=0
!P.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0

;simple periodogram
power=periodogram(hjd_sela2,mag4_median_fin,per=[3,1000],npts=10000)
;lineplot,power(0,*),power(1,*)

;pdm search for a period based on theta ; TAKES ~2 min to run the task or restore file 
freq1=1.0/3.0
freq2=1.0/500.0
dfreq=1.0/500000.0

;pdm,hjd_sela2,mag4_median_fin,mag4_sela2_err,freq1,freq2,dfreq,freq,period,theta
restore,'/Users/jgroh/espectros/mwc314/mwc314_pdm_variables.sav'

;pdm2 search for a period based on chi2 ; TAKES ~2 min to run the task or restore file 
;freq1=1.0/3.0
;freq2=1.0/100.0
;dfreq=1.0/50000.0
;pdm2,hjd_sela2,mag4_median_fin,mag4_sela2_err,freq1,freq2,dfreq,freq,period,chi2

ZE_MWC314_PLOT_PERIODOGRAM,power

phase_vec=hjd_sela2
phase0=hjd_sela2[0]
phase0=4958.9414 ;from alex lobel
period_opt=60.68      ;from PDM analysis and PDM2 analysis as well
;period_opt=60.45     ;fmor periodogram
phase0=phase0-(period_opt*38.)


phase_vec=(hjd_sela2-phase0)/period_opt

;average from periodogram
mag4_median_average=9.87947

;fitting and removing the long-term trend
result = linfit(phase_vec, mag4_median_fin, sdev=mag4_sela2_err, chisq = chisq, prob = prob, yfit=yfit, sigma=sigma)
mag4_median_fin=mag4_median_fin - yfit + mag4_median_average



;select a given number of orbital cycles to plot the folded lightcurve
print,'min cycle available is :',fix(min(phase_vec))
print,'max cycle available is :',fix(max(phase_vec)+1.0)
cycle_min=0.
cycle_max=38.

phase_vec_cut=phase_vec(WHERE(phase_vec ge cycle_min AND phase_vec le cycle_max))
mag4_median_fin_cut=mag4_median_fin(WHERE(phase_vec ge cycle_min AND phase_vec le cycle_max))
mag4_sela2_err_cut=mag4_sela2_err(WHERE(phase_vec ge cycle_min AND phase_vec le cycle_max))

print,'number of cycles plotted is :', cycle_max -cycle_min

phase_vec_folded=phase_vec_cut-fix(phase_vec_cut)
phase_vec_sort=phase_vec_folded(SORT(phase_vec_folded))
mag4_median_fin_sort=mag4_median_fin_cut(SORT(phase_vec_folded))
mag4_sela2_err_sort=mag4_sela2_err_cut(SORT(phase_vec_folded))
phase_shift=0.0

;plot folded lightcurve for the whole dataset
ZE_MWC314_PLOT_LIGHTCURVE_FOLDED,phase_vec_sort,mag4_median_fin_sort,mag4_sela2_err_sort

;compute average lightcurve


;SELECT AND PLOT LIGHTCURVE FOR MULTIPLE CYCLE INTERVALS ; RIGHT NOW WE DO THAT FOR 4

cycle_min=[0,10,20,30]
cycle_max=[10,20,30,39]

phase_vec_cut1=phase_vec(WHERE(phase_vec ge cycle_min[0] AND phase_vec le cycle_max[0]))
mag4_median_fin_cut1=mag4_median_fin(WHERE(phase_vec ge cycle_min[0] AND phase_vec le cycle_max[0]))
mag4_sela2_err_cut1=mag4_sela2_err(WHERE(phase_vec ge cycle_min[0] AND phase_vec le cycle_max[0]))
phase_vec_folded1=phase_vec_cut1-fix(phase_vec_cut1)
phase_vec_sort1=phase_vec_folded1(SORT(phase_vec_folded1))
mag4_median_fin_sort1=mag4_median_fin_cut1(SORT(phase_vec_folded1))
mag4_sela2_err_sort1=mag4_sela2_err_cut1(SORT(phase_vec_folded1))

phase_vec_cut2=phase_vec(WHERE(phase_vec ge cycle_min[1] AND phase_vec le cycle_max[1]))
mag4_median_fin_cut2=mag4_median_fin(WHERE(phase_vec ge cycle_min[1] AND phase_vec le cycle_max[1]))
mag4_sela2_err_cut2=mag4_sela2_err(WHERE(phase_vec ge cycle_min[1] AND phase_vec le cycle_max[1]))
phase_vec_folded2=phase_vec_cut2-fix(phase_vec_cut2)
phase_vec_sort2=phase_vec_folded2(SORT(phase_vec_folded2))
mag4_median_fin_sort2=mag4_median_fin_cut2(SORT(phase_vec_folded2))
mag4_sela2_err_sort2=mag4_sela2_err_cut2(SORT(phase_vec_folded2))

phase_vec_cut3=phase_vec(WHERE(phase_vec ge cycle_min[2] AND phase_vec le cycle_max[2]))
mag4_median_fin_cut3=mag4_median_fin(WHERE(phase_vec ge cycle_min[2] AND phase_vec le cycle_max[2]))
mag4_sela2_err_cut3=mag4_sela2_err(WHERE(phase_vec ge cycle_min[2] AND phase_vec le cycle_max[2]))
phase_vec_folded3=phase_vec_cut3-fix(phase_vec_cut3)
phase_vec_sort3=phase_vec_folded3(SORT(phase_vec_folded3))
mag4_median_fin_sort3=mag4_median_fin_cut3(SORT(phase_vec_folded3))
mag4_sela2_err_sort3=mag4_sela2_err_cut3(SORT(phase_vec_folded3))

phase_vec_cut4=phase_vec(WHERE(phase_vec ge cycle_min[3] AND phase_vec le cycle_max[3]))
mag4_median_fin_cut4=mag4_median_fin(WHERE(phase_vec ge cycle_min[3] AND phase_vec le cycle_max[3]))
mag4_sela2_err_cut4=mag4_sela2_err(WHERE(phase_vec ge cycle_min[3] AND phase_vec le cycle_max[3]))
phase_vec_folded4=phase_vec_cut4-fix(phase_vec_cut4)
phase_vec_sort4=phase_vec_folded4(SORT(phase_vec_folded4))
mag4_median_fin_sort4=mag4_median_fin_cut4(SORT(phase_vec_folded4))
mag4_sela2_err_sort4=mag4_sela2_err_cut4(SORT(phase_vec_folded4))

;plot folded lightcurve for multiple cycle intervals
ZE_MWC314_PLOT_LIGHTCURVE_FOLDED_MULTIPLE_CYCLE_INTERVALS,phase_vec_sort1,mag4_median_fin_sort1,phase_vec_sort2,mag4_median_fin_sort2,phase_vec_sort3,mag4_median_fin_sort3,phase_vec_sort4,mag4_median_fin_sort4


;find a for a given P, MP, MS
;we assume P=60.7 days
DEG2RAD=!DPI/180D0
RAD2DEG=180D0/!DPI
AU2RSUN=214.943
MP=60.
MS=10.
P=period_opt/365.4 ;period in yers
a=ZE_BINARY_STAR_COMPUTE_A_FROM_MP_MS_P(MP,MS,P)  ;in AU
print,'Semi-major axis', a

;compute fractional radius for using in JKTEBOP as described in Southworth 2008 MNRAS
;we assume RP=60Rsun and RS=10Rsun
RP=60.
RS=10.0
ra=RP/(a*AU2rsun)
rb=RS/(a*AU2rsun)

readcol,'/Users/jgroh/jktebop/mwc314/d/mwc314.out',d,obs,err,phase,model,oc

av = avgbin(phase_vec_sort,mag4_median_fin_sort,binsize=0.02)

ZE_MWC314_PLOT_LIGHTCURVE_FOLDED_MULTIPLE_CYCLE_INTERVALS,phase_vec_sort1,mag4_median_fin_sort1,phase_vec_sort2,mag4_median_fin_sort2,phase_vec_sort3,mag4_median_fin_sort3,phase+0.1,model

ZE_MWC314_PLOT_LIGHTCURVE_FOLDED,av[0,*],av[1,*],av[2,*],phase2=phase[sort(phase)]+0.02,mag2=model[sort(phase)]



set_plot,'x'
!P.Background = fsc_color('white')
!P.Color = fsc_color('black')
!X.THICK=0
!Y.THICK=0
!P.THICK=0
!X.CHARSIZE=0
!Y.CHARSIZE=0
!P.CHARSIZE=0
!P.CHARTHICK=0

END
