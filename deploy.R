chooseCRANmirror(ind = 1)
options("repos")

rsconnect::setAccountInfo(name='cs4500-joel',
              token='5BB42D3B337244CD87D9F02216DB8464',
              secret='nV9E1Sa1qC9NMhCCebQBdT4O6BVPcKdyTynD+hHW')
rsconnect::deployApp()
