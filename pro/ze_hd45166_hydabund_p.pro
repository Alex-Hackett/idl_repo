ibeta=5.3469
i4541=1.7713
i5411=4.6444
p=(ibeta)/(i4541*i5411)^0.5
ibetacorr=17.0679
i5411corr=9.5353
i4541corr=3.4459
pcorr=(ibetacorr)/(i4541corr*i5411corr)^0.5
print,p,pcorr

nhnhe2plus_thin=p-1.;
nhnhe2plus_thin_corr=p2-1.

print,nhnhe2plus_thin,nhnhe2plus_thin_corr

nhnhe2plus_thick=p^1.5-1.;
nhnhe2plus_thick_corr=p2^1.5-1.

print,nhnhe2plus_thick,nhnhe2plus_thick_corr

END
