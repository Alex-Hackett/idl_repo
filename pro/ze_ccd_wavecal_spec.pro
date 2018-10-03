PRO ZE_CCD_WAVECAL_SPEC,detector,angle,nx,ny,star_center,specastrom,centervals,xnodescen,ynodescen,lamp_trim,lambda_fin,xnodes_lamp_autocentroid,ynodes_lamp_autocentroid
;first guess on lambda

if n_elements(detector) EQ 0 then DETECTOR='WI098'

;this allows the same of angle values for different detectors
CASE DETECTOR OF 
 'WI098': BEGIN 
    CASE angle OF   
    ;CCD098  
    '157': BEGIN      
    ;default value for 157
    CRVAL1  =      3771.2969222967                                                                                                
    CD1_1   =      0.24673367298207   
           END
    
    '198': BEGIN
    CRVAL1  =      4912.5767452979                                                                                              
    CD1_1   =      0.24794835439793
           END   
           
    '242': BEGIN              
    ;default value for 242
    CRVAL1  =     6112.860863967
    CD1_1   =     0.24873652179876 
          END       
    
    '308': BEGIN 
    ;defualt values 308
    CRVAL1 =    7876.03003104165 
    CD1_1  =    0.248027705035844
           END
    
    '310': BEGIN 
    ;defualt values 308
    CRVAL1 =    7956.03003104165 
    CD1_1  =    0.248027705035844
           END
    
    '384': BEGIN 
    ;defualt values 384
    CRVAL1  =      9920.1324895073
    CD1_1   =      0.2492886583437
           END
    ENDCASE
  END
  
  'WI105': BEGIN     
  print,'angle',angle
  ;CCD105
    CASE angle OF
    '149': BEGIN
    ;;default value for 234
    CRVAL1  =     3881.000
    CD1_1   =     0.24465426173911
          END
    
    '168': BEGIN
    ;;default value for 234
    CRVAL1  =     4396.000
    CD1_1   =     0.24465426173911
          END
    
    '205': BEGIN
    ;;default value for 234
    CRVAL1  =     5431.000
    CD1_1   =     0.24465426173911
          END
       
    '234': BEGIN
    ;;default value for 234
    CRVAL1  =     6224.88255236131
    CD1_1   =     0.24465426173911
          END
        
    '255': BEGIN
    ;;default value for 255 for He I 7065
    CRVAL1  =     6798.88255236131
    CD1_1   =     0.24465426173911
          END     
         
    '309': BEGIN
    ;;default value for 234
    CRVAL1  =     8261.0
    CD1_1   =     0.24465426173911
          END
    
    '310': BEGIN
    ;;default value for 234
    CRVAL1  =     8305.0
    CD1_1   =     0.24465426173911
          END
          
    ENDCASE
   END
ENDCASE

guess_lambda=dblarr(ny)
for i=0, ny -1 DO guess_lambda[i]=CRVAL1 + i*CD1_1
index=indgen(ny)*1D0

;for lamp image
Lamp_Rect=dblarr(nx,ny)
ZE_CCD_TRACE_IMAGE_RECTIFIFY, lamp_trim, star_center,specastrom,centervals,xnodescen,ynodescen, lamp_rect,/no_trace ;will have to use the same rectify parameters to extract lamp

center=0
apradius=1
ZE_CCD_EXTRACT_SPECTRUM,lamp_rect,star_center,center,apradius,lampspec

lampfileorig='/Users/jgroh/espectros/thar_from_iraflinelist.txt'  ;this is the original kpno thar file  -- should be used only once for every grating angle to create the line list lampfile below with lna lines only -- done for angles: 242
;lampfileorig='/Users/jgroh/espectros/thar_kpno.txt'  ;this is the original kpno thar file  -- should be used only once for every grating angle to create the line list lampfile below with lna lines only -- done for angles: 242
lampfile='/Users/jgroh/espectros/thar_kpno_sel_for_lna.txt'  ;this is the files with selected lines that are seen in lna lamps --either due to s/n, resolution, etc
lampfilelna='/Users/jgroh/espectros/thar_lna_lines_for_initial_id.txt' ;this is the thar file with the lines that should be used for initial wavecal, based on plots from LNA CCD COUDe Manual Chap 3

;do not change these values -- or template files for wavecal might have to be redone if additional lines fall into the initial ID range
CASE DETECTOR OF 
 'WI098': BEGIN 
    initial_error_wavecal_ang=30. ;error in the initial guess, in Angstrom
    ZE_CCD_READ_LAMPFILE,lampfilelna,min(guess_lambda)+1*initial_error_wavecal_ang,max(guess_lambda)-4*initial_error_wavecal_ang,tharlinescut
  END
  'WI105': BEGIN 
    initial_error_wavecal_ang=15. ;error in the initial guess, in Angstrom
    ZE_CCD_READ_LAMPFILE,lampfilelna,min(guess_lambda)+1*initial_error_wavecal_ang,max(guess_lambda)-1*initial_error_wavecal_ang,tharlinescut
  END 
ENDCASE

;interactive identification should be done only when producing/changing/debugging a template for a given angle ; otherwise set to 0
ID_LAMP_LINES_INTERAC=0
SHOW_LINE_ID_INTERAC=0
IF KEYWORD_SET(ID_LAMP_LINES_INTERAC) THEN BEGIN ;identify lines interactively
  IF FILE_TEST('/Users/jgroh/LNA/idl_reduction_package/lna_wavecal_'+detector+'_'+angle+'.sav') EQ 1 THEN BEGIN
    sObj = OBJ_NEW('IDL_Savefile', '/Users/jgroh/LNA/idl_reduction_package/lna_wavecal_'+detector+'_'+angle+'.sav')  ;-- restore xnodes and ynodes from template file to use them as initial guess -- of course assumes that a template file is available, right now works only for 242
    sObj->Restore, 'xnodes' ;this was saved in lambda
    sObj->Restore, 'ynodes'
  ENDIF
  print,'Lamp lines to be identified interactively:'
  print,tharlinescut
  ze_lamp_line_id,guess_lambda,lampspec,xnodes,ynodes,xcen,ycen
  STOP
  ;save,guess_lambda,lampspec,xnodes,ynodes,xcen,ycen,filename= '/Users/jgroh/LNA/idl_reduction_package/lna_wavecal_'+detector+'_'+angle+'.sav'
ENDIF ELSE BEGIN ;try semi-automatic line ID based on matching with a template for a given angle -- of course assumes that a template file is available
  lampspecnew=lampspec
  sObj = OBJ_NEW('IDL_Savefile', '/Users/jgroh/LNA/idl_reduction_package/lna_wavecal_'+detector+'_'+angle+'.sav')
  sObj->Restore, 'xnodes'  ;this was saved in lambda
  sObj->Restore, 'ynodes'
  sObj->Restore, 'xcen'    ;this was saved in pix
  sObj->Restore, 'ycen'
  sObj->Restore, 'lampspec'
  obj_destroy,sOBj
  xcenorig=xcen
  ycenorig=ycen
  lampspecorig=lampspec
  lampspec=lampspecnew
  ;not obvious at this point which values of identify pix window and epsilon should be used 
  identify_pixwindow=100 ;in pix  -- this has to be at least 100
  centroid_fit_window=8 ;in pix
  epsilon=0.3  ;in pix  
  ZE_LAMP_FIND_SHIFT_CENTROID_ALL_REFERENCE_LINES_AUTO,lampspec,lampspecorig,xcenorig,identify_pixwindow,centroid_fit_window,epsilon,shiftxcenvec
  line_norm,index(xcenorig),shiftxcenvec,shiftxcenvecnorm,xcen_shifts_fin,xnodes_lamp_autocentroid,ynodes_lamp_autocentroid,yrange=[-130,130]
  xcen=xcenorig+xcen_shifts_fin
  ycen=lampspec(xcenorig+xcen_shifts_fin)
  for I=0, n_elements(xcen) -1 do xnodes[i]=guess_lambda(findel(xcen[i],index))
  ynodes=ycen
  IF KEYWORD_SET(SHOW_LINE_ID_INTERAC) THEN ze_lamp_line_id,guess_lambda,lampspec,xnodes,ynodes,xcen,ycen ;in this case, runs ze_lamp_line_id to make sure line ids are correct -- lambda scale will be screwed up though, as it is only approximate and for easy identification
ENDELSE

;initial calibration: do an interactive fitting (preferentiablly order 30 for automatically identifying other weak lamp lines -- fails if the initial fit is bad due to e,g, outliers, so has do it interactively
ze_lamp_fit_wavecal_interac_v2,xcen,tharlinescut,ny,xnodes,ynodes,xcensel,ycensel,yfit,fit,tharlineid1,lambda_ini
yfitold=yfit

;identify weak lamp lines 
ZE_CCD_READ_LAMPFILE,lampfile,min(lambda_ini),max(lambda_ini),tharlines

;for angle='384': peaks that were previously identified with the template are not being found by the ze_peaks routine -- will have to use the results from the first call to lamp_fit_wavecal_interac_v2 and skip the steps below
IF angle EQ '384' THEN BEGIN
  ze_lamp_fit_wavecal_interac_v2,xcensel,tharlineid1,ny,xnodes,ynodes,xcenfin,ycenfin,lambda_fit_params,lambda_fit_values,tharlineid,lambda_fin 
ENDIF ELSE BEGIN
 PRINT,'Starting identification of additional (weak) lines'
 peak_vals = ze_peaks(lampspec,2) ;this is a long integer -- i.e. pixel values of peaks
 lambda_peak_vals=lambda_ini(peak_vals)
 intens_peak_vals=lampspec(peak_vals)

 ZE_CCD_FIND_CLOSEST_LAMP_ID, lambda_peak_vals,tharlines,lambda_closest_id,index_closest_id

 threshold_id=1.8 ;in Angs
 ZE_CCD_REMOVE_OUTLIERS_LAMP_ID,peak_vals,lambda_peak_vals,intens_peak_vals,lambda_closest_id,threshold_id,peak_vals_sel,lambda_peak_vals_sel,intens_peak_vals_sel,lambda_closest_id_sel

 ;very shallow constraints to remove true outliers only
 centroid_fit_window=7 ;in pix
 chisq_threshold=10.  ;in units above the median of chisqvecauto
 sigmafit_threshold= 30. ;in sigma
 centering_threshold=10.5 ;in pix

 ZE_FIND_CENTROID_AUTO,peak_vals_sel,index,lampspec,centroid_fit_window,xcenauto,ycenauto,chisqvecauto,sigmafitvecauto,centeringvecauto,keepauto,chisq_threshold=chisq_threshold,sigmafit_threshold=sigmafit_threshold,centering_threshold=centering_threshold
 lambda_closest_id_sel_auto=lambda_closest_id_sel(keepauto)

 ;now ze_lamp_fit_wavecal_interac_v2 works really well! plans to include automatic sigma clipping in the future
 ze_lamp_fit_wavecal_interac_v2,xcenauto,lambda_closest_id_sel_auto,ny,xnodes,ynodes,xcenfin,ycenfin,lambda_fit_params,lambda_fit_values,tharlineid,lambda_fin
ENDELSE


END