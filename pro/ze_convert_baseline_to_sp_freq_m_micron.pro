FUNCTION ZE_CONVERT_BASELINE_TO_SP_FREQ_M_MICRON,baseline, lambda
  ;lambda in angstroms
  sp_freq_m_micron=baseline/(lambda*1e-4)

END