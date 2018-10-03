;+
; $Id: acs_acquire_common.pro,v 1.2 2000/09/26 15:20:50 mccannwj Exp $
;
; NAME:
;     ACS_ACQUIRE_COMMON
;
; PURPOSE:
;     Include file that defines the ACS_ACQUIRE common block definition.
;
; CATEGORY:
;     ACS/Acquisition
;
; CALLING SEQUENCE:
;     @ACS_ACQUIRE_COMMON
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
;     xx_acs_acquire
;              position - position of each telemetry item in the eng.
;                     data snapshot
;              ename - 8 character name for each item
;              ecomments - description of each item
;              bit1 - first bit of each item
;              nbits - number of bits of each item
;              convpos - position in conversion table for each
;                   item
;              conversion - conversion tables.  It contains
;                   a variable number of elements for each
;                   item.  The first position in CONVERSION
;                   for each item is in CONVPOS.
;              zero_time - spacecraft zero time (seconds
;                   since Nov. 14, 1858 00:00
;              filter_wheel - vector of filter wheel numbers
;              filter_number - vector of filter numbers
;              filter_name - vector of filter names
;              filter_wheel_pos - vector of filter positions
;                   (*,0) = wfc
;                   (*,1) = hrc
;                   (*,2) = sbc
;              shpvals - values extracted from shp
;                   (0) - jhdetmp1
;                   (1) - jhdetmp2
;                   (2) - jwdetmp1
;                   (3) - jwdetmp2
;                   (4) - jmtubet
;              shptime - dump time of the SHP
;              shpfile - shp file name
;
; SIDE EFFECTS:
;     Defines a common block.
;
; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;
;-
COMMON xx_acs_acquire, position, ename, ecomments, bit1, nbits, $
 convpos, conversion, zero_time, filter_wheel, filter_number, filter_name, $
 filter_wheel_pos, shpvals, shptime, shpfile
