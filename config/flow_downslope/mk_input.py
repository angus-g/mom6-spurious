import numpy as np
import xarray as xr

# grid spacing
dx = 1e3
# total grid size
xl = 200e3
NJ = 4
dz = 20
zl = 2e3

d1 = 500
d2 = 2e3
x0 = 40e3
sigma = 7e3

ds = xr.Dataset(coords={'x': np.arange(dx / 2, xl, dx),
                        'y': range(NJ),
                        'z': np.arange(dz / 2, zl, dz)})

# force broadcasting into the y dimension
ds['depth'] = 0*ds.y + d1 + 0.5*(d2 - d1)*(1 + np.tanh((ds.x - x0) / sigma))
ds['temp'] = 0*ds.z + 0*ds.y + 10.0 + 10*(ds.x >= 20e3)
ds['salt'] = 35 + 0*ds.z + 0*ds.y + 0*ds.x

ds.to_netcdf('input.nc')
