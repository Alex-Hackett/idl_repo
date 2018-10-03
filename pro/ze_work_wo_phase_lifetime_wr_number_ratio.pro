;PRO ZE_WORK_WO_PHASE_LIFETIME_WR_NUMBER_RATIO
;compute the expected number ratio of galactic WO compared to the total number of WR stars
tauwr_120norot=3.97e5
tauwr_120rot=1.22e6

tauwr_85norot=3.52e5
tauwr_85rot=1.19e6

tauwr_60norot=3.97e5
tauwr_60rot=9.05e5

tauwr_40norot=7.46e4
tauwr_40rot=4.1e5

tauwr_32norot=6.49e3
tauwr_32rot=4.54e5

tauwo=1e4

print,tauwo/tauwr_32rot
print,tauwo/tauwr_120rot
END


