#! /bin/csh -f
#
# =================================
# For HEALPix internal usage only
# =================================
#
# updated 2007-May 15 to deal with 2008Mar07 version
# 2008-03-18: compare files 
#
# directory with new routines
# set dir = /home/soft/idl/external_contributions/astron-aug00/pro/
# set dir = /home/soft/rsi/external_contributions/astron-may2002/pro/
# set dir = /home/soft/rsi/external_contributions/astron_2004Dec17/pro
# set dir = /home/soft/rsi/external_contributions/astron_2007Apr14/pro/
set dir = /home/soft/rsi/external_contributions/astron_2008Mar07/pro/

# list of routines in current directory
set list = `ls -x *.pro`

set CP = '/bin/cp -p'
# set CP = 'echo'

set DIFF = '/usr/bin/diff -q'

set nf = 0
set gf = 0
set df = 0
set nf_list = ()
set df_list = ()

# update routines in current directory
foreach file ($list)
	echo $file
	set fullname = `find $dir -name $file -print`
	if ($fullname == '') then
	   echo $file' NOT FOUND !'
	   @ nf++
	   set nf_list = ($nf_list $file)
	else
	  echo $fullname
	  #$DIFF $file $fullname
	  set notsame = `$DIFF $file $fullname | wc -l`
	  if ($notsame == 1) then
	     echo 'Files are different!'
	     @ df++
	     set df_list = ($df_list $file)
	  endif
	  $CP $fullname .
	   @ gf++
	endif	  
end
echo
echo
echo 'updated current directory with files from '${dir}
echo
date
echo 'Updated successfully   ' $gf ' files,'
echo 'out of which ' $df ' are different:'
echo $df_list
echo '(beware that some new dependencies may not be satisfied).'
echo 'Not found: ' $nf ' files :'
echo $nf_list

exit

