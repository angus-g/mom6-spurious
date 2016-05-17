import numpy as np
import xarray as xr

# grid spacing
dx = 0.5e3
# total grid size
xl = 64e3
NJ = 4
dz = 1
zl = 20


ds = xr.Dataset(coords={'x': np.arange(dx / 2, xl, dx),
                        'y': range(NJ),
                        'z': np.arange(dz / 2, zl, dz)})

# force broadcasting into the y dimension
ds['temp'] = 0*ds.z + 0*ds.y + 5.0 + 25*(ds.x >= 32e3)
ds['salt'] = 35 + 0*ds.z + 0*ds.y + 0*ds.x

ds.to_netcdf('input.nc')
