;+
;
; PROJECT:  CHIANTI
;
;       CHIANTI is an atomic database package for the calculation of
;       continuum and emission line spectra from astrophysical plasmas. It is a 
;       collaborative project involving the Naval Research Laboratory
;       (Washington DC, USA), the Arcetri Observatory (Firenze, Italy), and the
;       Cambridge University (United Kingdom).
;
;
; NAME:
;	DESCALE_UPS_VK
;	(used to be) DESCALE_UPS
;
; PURPOSE:
;
;	convert from Burgess-Tully scaling spline fits to Upsilons
;
; CATEGORY:
;
;	science.
;
; CALLING SEQUENCE:
;
;       DESCALE_UPS,Index,Jndex,xt,upsilion, T_TYPE,C_UPS,SPLUPS
;
; INPUTS:
;
;	Index:	index of lower energy level (lowest level is 1)
;	Jndex:	index of upper energy level (lowest level is 1)
;	xt:  scaled temperature
;
;	T_TYPE: 2 dimensional array contain values of the transition type
;	C_UPS: 2 dimensional array containing values of the Burgess and Tully
;		scaling parameter c
;	SPLUPS: spline fits to the scaled Upsilons
;
; OPTIONAL INPUTS:
;
;	None:
;	
; KEYWORD PARAMETERS:
;
;	None:	
;
; OUTPUTS:
;
;	Upsilon:  the Maxwellian averaged collision strength
;
;
;
; COMMON BLOCKS:
;
;	NONE:
;
;	;common elvlc,l1a,term,conf,ss,ll,jj,ecm,eryd,ecmth,erydth,eref
;       ;common wgfa, wvl,gf,a_value
;       ;common upsilon,t_type,c_ups,splups
;
;
; PROCEDURE:
;
;	see Burgess and Tully, 1992, Astron and Astrophys, 254, 436.
;
; EXAMPLE:
;
;             ;
; MODIFICATION HISTORY:
; 	Written by:	Ken Dere
;	March 1996:     Version 2.0
;       December 1998:  Include transition type 5   (kpd)
;
;	September 2000: Add parameters T_TYPE,C_UPS,SPLUPS and comment out
;		all common blocks (Vinay Kashyap)
;	THIS ROUTINE IS OBSOLETE FOR CHIANTIv4+ (VK; Jun02)
;
;-
pro descale_ups_vk,indx,jndx,xt,ups, T_TYPE,C_UPS,SPLUPS
;
;   to scale the energies and upsilons
;   (thermal collision strengths)
;
;  xt=kt/de
;
;
; VK	common elvlc,l1a,term,conf,ss,ll,jj,ecm,eryd,ecmth,erydth,eref
; VK	common wgfa, wvl,gf,a_value
; VK	common upsilon,t_type,deu,c_ups,splups
;
;

message,'OBSOLETE: called from POPSOL3(), not required after CHIANTIv4',/info

c=c_ups(indx,jndx)
spl=reform(splups(indx,jndx,*))
;
CASE t_type(indx,jndx) OF

1:  begin
      st=1.-alog(c)/alog(xt+c)
      xs=0.25*findgen(5)
      y2=nr_spline(xs,spl)
      sups=nr_splint(xs,spl,y2,st)
      ups=sups*alog(xt+exp(1.))
    end
;
2:  begin
      st=xt/(xt+c)
      xs=0.25*findgen(5)
      y2=nr_spline(xs,spl)
      sups=nr_splint(xs,spl,y2,st)
      ups=sups
    end
;
3:  begin
      st=xt/(xt+c)
      xs=0.25*findgen(5)
      y2=nr_spline(xs,spl)
      sups=nr_splint(xs,spl,y2,st)
      ups=sups/(xt+1.)
;
    end
;
4:  begin
      st=1.-alog(c)/alog(xt+c)
      xs=0.25*findgen(5)
      y2=nr_spline(xs,spl)
      sups=nr_splint(xs,spl,y2,st)
      ups=sups*alog(xt+c)
   end
;
5:  begin
      st=xt/(xt+c)
      xs=findgen(5)*0.25
      y2=nr_spline(xs,spl)
      sups=nr_splint(xs,spl,y2,st)
      ups=sups/(xt+0.)
;
    end
;
;
else:  print,' t_type ne 1,2,3,4,5=',t_type(indx,jndx),indx,jndx
;
ENDCASE
;
ups=ups>0.
;
if((st gt 1.) or (st lt 0.)) then print,indx,jndx,xt,st,' st outside 0>1'
return
end
;
