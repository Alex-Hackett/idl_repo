;+
; $Id: acs_fpr.pro,v 1.1 2001/11/05 20:57:35 mccannwj Exp $
;
; NAME:
;     ACS_FPR
;
; PURPOSE:
;     Analyze ACS FPR test
;
; CATEGORY:
;     ACS
;
; CALLING SEQUENCE:
; 
; INPUTS:
;
; OPTIONAL INPUTS:
;      
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;
; RESTRICTIONS:
;     This code needs to be rewritten.
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;     Originally written by Mike Jones for ACS.
;-
PRO ACS_FPR, entry
   print,' '
   read,gain,PROMPT='Enter the system gain (electrons/DN):'
   
; Enter the system gain uncertainty in units of
   print,' '
   read,sigma_gain,PROMPT='Enter the 1 sigma system gain uncertainty (electrons/DN):'
; Enter the number of leading extended serial pixels here
   extended_pixels=25
   
; Set system variables for histogram style plot
   !P.LINESTYLE=0
   !P.PSYM=10
;
;********************LOAD THE FPR IMAGE********************
;
; Use the PICKFILE widget to select the FPR FITS file
;
   root_dir=' '
   fpr_file=pickfile(TITLE='Select the FPR FITS file', $
                     GET_PATH=root_dir)
;
; Read the FITS image
; Procedure FITSREAD is a PC compatible version
; of the GSFC AstroLib procedure FITS_READ
; FITSREAD and a number of supporting procedures
; have been hacked by the author to conform to
; the (archaic!) DOS 8.3 file name convention
;
   fitsread,fpr_file,im
;
;********************OUTPUT FILE********************
;
   output_file_name='ser_cte.out'
;
; Fully justified output file name
;
   output_file=root_dir + output_file_name
   openw,u,output_file,/GET_LUN
;
; Comment lines for the output file
;
   printf,u,'FPR serial CTE'
   printf,u,'WFC CCD 6084MBR17-01'
   printf,u,'Readout through amp-B'
   printf,u,'Test date: 7/23/98'
;
; Record the system gain
;
   printf,u,'System gain (electrons/DN): ',gain
   printf,u,'1 sigma system gain uncertainty (electrons/DN): ',sigma_gain
;
;********************BIAS REMOVAL********************
;
; Subtract the bias
;
; Define the physical leading and trailing
; overscan regions here
;
   first_bias_col1=1-1
   last_bias_col1=28-1
   first_bias_col2=4125-1
   last_bias_col2=4146-1
;
; Sample the 100 columns immediately preceding
; the leading edge of the FPR image to determine
; the bias
;
   sample_col1=1976
   sample_col2=2075
;
   samplebias=im(sample_col1:sample_col2,*)
   sigma=stdev(samplebias,bias)
   samplebias=0
   print,' '
   print,'Mean bias (DN): ',bias
   print,'Sigma bias (DN): ',sigma
   printf,u,'Mean bias (DN): ',bias
   printf,u,'Sigma bias (DN): ',sigma
;
; Trim the overscan pixels from the corrected image
;
   im_trim=im(last_bias_col1+1:first_bias_col2-1,*)-bias
   im=0
;
   nrows=n_elements(im_trim(1,*))
   ncols=n_elements(im_trim(*,1))
   print,' '
   print,'Rows in trimmed image: ',nrows
   print,'Columns in trimmed image: ',ncols
   printf,u,'Rows in trimmed image: ',nrows
   printf,u,'Columns in trimmed image: ',ncols
;
;********************IMAGE DISPLAY********************
;
; Display the image
; Use the GSFC AstroLib SIGRANGE function to
; sample the unflushed half of the image
; the upper and lower values of the range returned
; by SIGRANGE will be used as the ceiling and
; floor for the grayscale color table
; Use the SLIDE_IMAGE widget for 'pan-and-scan'
; style display
;
   disp_title='6084MBR17-01, B-AMP, FPR IMAGE, TEST DATE: 7/23/98'
;
   im_temp=sigrange(im_trim(ncols/2:ncols-1,*),FRACTION=0.997,RANGE=z)
   im_temp=0
   low_z=z(0)
   high_z=z(1)
;
   slide_image,bytscl(im_trim, MIN=low_z, MAX=high_z, TOP=!D.TABLE_SIZE), $
    /REGISTER, CONGRID=0, TITLE=disp_title,XVISIBLE=350
;
;********************ROW AVERAGING********************
;
   fpr=total(im_trim,2,/DOUBLE)/double(nrows)
   fpr=temporary(fpr)*gain
;
;********************LEADING EDGE PLOT********************
;
; Set the x-axis limits here
;
   pix1=2040
   pix2=2100
   !X.STYLE=1
   !X.RANGE=[pix1,pix2]
;
; Define the x-axis array
;
   npix=pix2-pix1+1
   pix=make_array(npix,/INT,/INDEX)+pix1
;
; Set the y-axis for autoscale
;
   !Y.RANGE=0
;
; Plot title here
;
   !Y.MARGIN=[4,4]
   ptitle1='6084MBR17-01, B-AMP, FPR LEADING EDGE PLOT!CTEST DATE: 7/23/98'
   !P.TITLE=ptitle1
;
   !X.TITLE='Serial Pixel Number'
   !Y.TITLE='Signal in Electrons'
;
   plot,pix,fpr(pix1-1:pix2-1)
   pix=0
;
;********************REFERENCE SIGNAL********************
;
; Fit a polynomial (typically first degree) to the
; plateau pixels following the leading edge pixel
;
   print,' '
   print,'Click on the first (leftmost) pixel'
   print,'that you wish to use for the reference'
   print,'signal fit'
   cursor,x1,y1,3
   x1=ceil(x1)
   print,'First pixel for fit: ',x1
;
   print,' '
   print,'Click on the last (rightmost) pixel'
   print,'that you wish to use for the reference'
   print,'signal fit'
   cursor,x2,y2,3
   x2=ceil(x2)
   print,'Last pixel for fit: ',x2
;
   if(x2 LT x1) then begin
      xtemp=x1
      x1=x2
      x2=xtemp
   endif
   if(x1 LT ncols/2+2) then x1=ncols/2+2
;
; Select the polynomial order
;
   order=0
   o_prompt='Enter the order of the polynomial fit (linear=order 1):'
   print,' '
   read,order,PROMPT=o_prompt
;
   print,' '
   print,'Fitting polynomial order: ',order
   printf,u,'Fitting polynomial order: ',order
   print,'First plateau pixel in fit: ',x1
   printf,u,'First plateau pixel in fit: ',x1
   print,'Last plateau pixel in fit: ',x2
   printf,u,'Last plateau pixel in fit: ',x2
;
   npix=x2-x1+1
   y=fpr(x1-1:x2-1)
   x=make_array(npix,/DOUBLE,/INDEX)+double(x1)
   coeff=svdfit(x,y,order+1)
   case order of
      1: begin
         B=coeff(0) & M=coeff(1)
      end
      2: begin
         C0=coeff(0) & C1=coeff(1) & C2=coeff(2)
      end
   endcase
   x=0
   y=0
;
;********************OVERPLOT THE FIT********************
;
   pix1=2040
   pix2=2060
   !X.RANGE=[pix1,pix2]
   npix=pix2-pix1+1
   pix=make_array(npix,/INT,/INDEX)+pix1
   ymax=max(fpr(ncols/2+1:pix2))*double(1.05)
   ymin=fpr(ncols/2)*double(0.80)
   !Y.RANGE=[ymin,ymax]
;
   ptitle2='6084MBR17-01, A-AMP, FPR PLATEAU FIT!CTEST DATE: 7/23/98'
   !P.TITLE=ptitle2
   erase
   plot,pix,fpr(pix1-1:pix2-1)
   pix=0
;
; Set system variables for a 'connect-the-dots'
; line plot with a dashed line style
;
   !P.PSYM=0
   !P.LINESTYLE=2
   npix=x2-(ncols/2+1)+1
   pix=make_array(npix,/INT,/INDEX)+ncols/2+1
   case order of
      1: begin
         yfit=M*double(pix)+B
      end
      2: begin
         yfit=C2*double(pix)^2+C1*double(pix)+C0
      end
   endcase
   oplot,pix,yfit
   pix=0
;
;********************SERIAL CTE********************
;
; Extrapolate the plateau fit to determine the
; reference signal S0 for the leading pixel
;
   S0=yfit(0)
   yfit=0
   print,' '
   print,'Reference signal level (electrons): ',S0
   printf,u,'Reference signal level (electrons): ',S0
;
   leading_pix=ncols/2
   Sn=fpr(leading_pix)
   transfers=ncols/2+extended_pixels+1
   cte=(Sn/S0)^(double(1.0)/double(transfers))
   print,' '
   print,'Serial CTE (per pixel): ',cte
   printf,u,'Serial CTE (per pixel): ',cte
;
;********************UNCERTAINTY ESTIMATES********************
;
; Experimented with various mathematically rigorous
; methods of error analysis, all of which yielded
; unreasonable results
;
; what follows is intuitive rather than rigorous
; the resulting error estimates are, however, reasonable
; when compared to the actual data ... MRJ
;
; Estimate the uncertainty in the measurement of the
; reference signal level S0
;
; S0 was determined by extrapolation of a curve fit to the
; column averaged 'plateau', the intention being to account
; for any global variation in the flat-field illumination
;
; To estimate the uncertainty in S0, assume that it is the same
; as the uncertainty in the signal in the 'plateau' column
; (column ncols/2+2) immediately following the
; lead column (column ncols/2+1)
;
   sigma_S0_DN=stdev(double(im_trim(ncols/2+2-1,*))) ; sigma_S0_DN in DN
   S0_DN=S0/gain    ; S0_DN in DN
;
; Propagate the uncertainty in the system gain
;
   sigma_S0=S0_DN*gain*sqrt((sigma_S0_DN/S0_DN)^2+ $ ; sigma_S0 in electrons 
                            (sigma_gain/gain)^2)
;
   print,' '
   print,'1 sigma uncertainty in the reference signal level (electrons): ',sigma_S0
   printf,u,'1 sigma uncertainty in the reference signal level (electrons): ',sigma_S0
;
; Estimate the uncertainty in CTE
;
; First estimate the uncertainty in the signal level
; measurement Sn for the leading column
;
   sigma_Sn_DN=stdev(double(im_trim(leading_pix,*)),Sn_DN) ; Sn_DN and sigma_Sn_DN in DN
   sigma_Sn=Sn_DN*gain*sqrt((sigma_Sn_DN/Sn_DN)^2+ $ ; include gain uncertainty
                            (sigma_gain/gain)^2) ; sigma_Sn in electrons 
   im_trim=0
;
; sig_Sn_S0 is the 1 sigma uncertainty in the measured
; ratio Sn/S0
;
   sigma_Sn_S0=(Sn/S0)*sqrt((sigma_Sn/Sn)^2+(sigma_S0/S0)^2)
   sigma_cte=sigma_Sn_S0/(double(transfers)*cte^(transfers-1))
;
   print,' '
   print,'1 sigma uncertainty in per pixel serial CTE: ',sigma_cte
   printf,u,'1 sigma uncertainty in per pixel serial CTE: ',sigma_cte
;
; Close the output file
;
   free_lun,u
END

