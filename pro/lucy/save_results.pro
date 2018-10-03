pro selbase_event, event 

COMMON seldat, selection

 selection = event.value
 Widget_Control, event.top, /Destroy

end

pro selectval, leader, title, items, value

COMMON seldat, selection

  selbase = widget_base(Title=title, /Column, xsize=480, $
	    xoffset=500, yoffset=500, Group_Leader=leader, /Modal)
  selButton = CW_BGroup(selbase, items, row=1, uvalue='selbutton', $ 
  	      exclusive=1, /no_release)
  Widget_Control, selbase, /Realize
  XManager, 'selectval', selbase, Event_Handler='selbase_event'
  if n_elements(selection) gt 0 then value=selection else value=-1
end

pro save_res_ev, event

COMMON imageblk,  result, res_hdr, result_true, fname, ORDER, RETAIN, $
		  RAW_WINDOW, PLOT_WINDOW, RESULT_WINDOW, deconstr, dampstr
COMMON param2blk, chimin, speed, noise, adu, niter, B, imscale, $
		  damp, ndamp, threshold, nsigma, oxsize, oysize, $
		  chisq, piter
COMMON imstruct,  raw_image, rname, rxsize, rysize, raw_true, raw_hdr, $
		  psf, pname, pxsize, pysize, psf_true, $
		  model, mname, mxsize, mysize, model_true, $
		  mask, kname, kxsize, kysize, mask_true, $
		  weight, wname, wxsize, wysize, weight_true, $
		  background, bname, bxsize, bysize, background_true
COMMON chars,   log_unit

  Widget_Control, event.top, Get_UValue=saveiminfo

  case event.id of

    saveiminfo.selectfile: begin
      ; The user hit return after typing in a file name, get it.
      Widget_Control, saveiminfo.selectfile, Get_Value = filename
      filename = strcompress(filename[0], /remove_all)
      ua_decompose, filename, disk, path, name, extn, version
      if strlen(extn) eq 0 then begin
	filename = filename + '.fits'
	Widget_Control, saveiminfo.selectfile, Set_Value = filename
      endif
      ; check if file already exists, if so query if wish to overwrite
      temp = findfile (filename, Count = fcount)
      if fcount gt 0 then begin
	selectval, event.top, 'Do you wish to overwrite existing file?',$
	   ['no','yes'], val
        if val eq 0 then return
      endif
      ; check if path is valid
      openw, lun, filename, error=err, /get_lun
      close, lun
      free_lun, lun
      if err ne 0 then return
      ; Write out the result.
      if result_true eq 1 then begin
	sxaddpar, res_hdr, 'HISTORY', 'Raw image: ' + rname
	sxaddpar, res_hdr, 'HISTORY', 'PSF image: ' + pname
	if model_true eq 1 then sxaddpar, res_hdr, 'HISTORY', $
	    'Model image: ' + mname
        if mask_true eq 1 then sxaddpar, res_hdr, 'HISTORY', $
	    'Mask image: ' + kname
        if weight_true eq 1 then sxaddpar, res_hdr, 'HISTORY', $
	    'Weight image: ' + wname
        if background_true eq 1 then sxaddpar, res_hdr, 'HISTORY', $
	    'Background image: ' + bname
	sxaddpar, res_hdr, 'HISTORY', deconstr[speed]
	sxaddpar, res_hdr, 'HISTORY', dampstr[damp]
	sxaddpar, res_hdr, 'HISTORY', 'Read noise(electrons): ' + string(noise)
	sxaddpar, res_hdr, 'HISTORY', 'Electrons per DN: ' + string(adu)
        sxaddpar, res_hdr, 'HISTORY', 'Number of iterations requested: ' + $
	    string(niter)
        sxaddpar, res_hdr, 'HISTORY', 'Number of iterations performed: ' + $
	    string(piter)
        sxaddpar, res_hdr, 'HISTORY', 'Chi-squared limit: ' + string(chimin)
        sxaddpar, res_hdr, 'HISTORY', 'Chi-squared achieved: ' + string(chisq)
        ua_fits_write,filename,result, res_hdr
        str = 'writing file: ' + filename
        print, str
        printf, log_unit, str
      endif
      Widget_Control, event.top, /Destroy
      end

   saveiminfo.browseButton: begin
      Pathvalue = Dialog_Pickfile(Title='Please select output file path')
      ua_decompose, Pathvalue, disk, path, file, extn, version
      opath = disk + path
      Widget_Control, saveiminfo.selectfile, Set_Value=opath
      end

   saveiminfo.saveButton: begin
      Widget_Control, saveiminfo.selectfile, Get_Value = filename
      filename = strcompress(filename[0], /remove_all)
      ua_decompose, filename, disk, path, name, extn, version
      if strlen(extn) eq 0 then filename = filename + '.fits'
      ; check if file already exists, if so query if wish to overwrite
      temp = findfile (filename, Count = fcount)
      if fcount gt 0 then begin
	selectval, event.top, 'Do you wish to overwrite existing file?',$
	   ['no','yes'], val
        if val eq 0 then return
      endif
      ; check if path is valid
      openw, lun, filename, error=err, /get_lun
      close, lun
      free_lun, lun
      if err ne 0 then return
      if result_true eq 1 then begin
	sxaddpar, res_hdr, 'HISTORY', 'Raw image: ' + rname
	sxaddpar, res_hdr, 'HISTORY', 'PSF image: ' + pname
	if model_true eq 1 then sxaddpar, res_hdr, 'HISTORY', $
	    'Model image: ' + mname
        if mask_true eq 1 then sxaddpar, res_hdr, 'HISTORY', $
	    'Mask image: ' + kname
        if weight_true eq 1 then sxaddpar, res_hdr, 'HISTORY', $
	    'Weight image: ' + wname
        if background_true eq 1 then sxaddpar, res_hdr, 'HISTORY', $
	    'Background image: ' + bname
        sxaddpar, res_hdr, 'HISTORY', 'Chi-squared limit: ' + string(chimin)
	sxaddpar, res_hdr, 'HISTORY', 'Read noise(electrons): ' + string(noise)
	sxaddpar, res_hdr, 'HISTORY', 'Electrons per DN: ', string(adu)
        sxaddpar, res_hdr, 'HISTORY', 'Number of iterations: ', string(niter)
	sxaddpar, res_hdr, 'HISTORY', deconstr[speed]
	sxaddpar, res_hdr, 'HISTORY', dampstr[damp]
        ua_fits_write,filename,result, res_hdr
        str = 'writing file: ' + filename
        print, str
        printf, log_unit, str
      endif
      Widget_Control, event.top, /Destroy
      end

   saveiminfo.cancelButton: begin
     Widget_Control, event.top, /Destroy
     end
  endcase
end

pro save_results

COMMON imageblk,  result, res_hdr, result_true, fname, ORDER, RETAIN, $
		  RAW_WINDOW, PLOT_WINDOW, RESULT_WINDOW, deconstr, dampstr
		  
COMMON chars,   log_unit

  if(XRegistered("save_results")) then return

  title      = 'Save Deconvolution Image'
  savebase   = Widget_Base (Title = title, /Column, xoffset=300, yoffset=300)
  save1base  = Widget_Base (savebase, /Row)
  label      = Widget_Label (savebase, Value='Output file name:') 
  selectfile = Widget_Text  (savebase, Value = ' ', XSize = 80, /Edit)
  save2base  = Widget_Base(savebase, /Row)
  label2     = Widget_Label (save2base, Value='                             ')
  browseButton = Widget_Button(save2base, Value = ' Browse ')
  label3     = Widget_Label (save2base, Value = '     ')
  saveButton = Widget_Button(save2base, Value = ' Save ')
  label4     = Widget_Label (save2base, Value = '     ')
  cancelButton = Widget_Button(save2base, Value = ' Cancel ')

  saveiminfo = {selectfile    :     selectfile,  $
		browseButton  :     browseButton,$
		saveButton    :     saveButton,  $
		cancelButton  :     cancelButton }

  Widget_Control, savebase, set_uvalue = saveiminfo
  Widget_Control, savebase, /Realize

  XManager, "save_results", savebase, Event_Handler = "save_res_ev", $
    group_leader=group
end
