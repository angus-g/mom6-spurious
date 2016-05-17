import numpy as np
import xarray as xr

# grid spacing
dx = 5e3
# total grid size
xl = 250e3
NJ = 4
dz = 25
zl = 500

t_bot = 10.1
t_top = 20.1
z_bot = 487.5
L = 50e3
x0 = 125e3
A = 2

ds = xr.Dataset(coords={'x': np.arange(dx / 2, xl, dx),
                        'y': range(NJ),
                        'z': np.arange(dz / 2, zl, dz)})

# force broadcasting into the y dimension
ds['temp'] = t_bot + (t_top - t_bot)*(z_bot - ds.z) / z_bot + 0*ds.y - A*np.cos(np.pi / (2*L) * (ds.x - x0))*np.sin(np.pi*(ds.z + dz/2)/(z_bot + dz/2))
ds['salt'] = 35 + 0*ds.z + 0*ds.y + 0*ds.x

ds.to_netcdf('input.nc')
