;PRO ZE_WORK_STIS_MAPPING_TED
xpixel=[0,1,2,3,4]
ypixel=xpixel
ns=n_elements(xpixel)
ncoadds=dblarr(ns,ns)
images=dblarr(ns,ns)
images[*,*]=40D0
    for j=0,n_elements(xpixel)-1 do begin
      if (xpixel[j] ge 0) and (xpixel[j] lt ns) and $
         (ypixel[j] ge 0) and (ypixel[j] lt ns) then begin
           ncoadds(xpixel[j],ypixel[j]) = $
                ncoadds(xpixel[j],ypixel[j]) + 1
      end
    end 
    images = images/(ncoadds>2)
END