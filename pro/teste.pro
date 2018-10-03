      nx = 100
      ny = 400
      data = synthspec(traceout = traceout, nx = nx, ny = ny)
      shift = traceout[0:ny-1] - nx/2  ; adjust output for sampleshift
      level = 5
      bigdata = sampleshift(data, level, -shift)
      erase & tvscl,  bigdata   ; large data
      redata = sampleshift(bigdata, 1./level, shift*level)
      erase & tvscl, redata     ; smaller remade data

END
