import numpy as np
import xarray as xr

# grid spacing
dx = 5
# total grid size
xl = 250
yl = 20
dz = 25
zl = 500

t_bot = 10.1
t_top = 20.1
z_bot = 487.5
L = 50
x0 = 125
A = 2

ds = xr.Dataset(coords={'x': np.arange(dx / 2, xl, dx),
                        'y': np.arange(dx / 2, yl, dx),
                        'z': np.arange(dz / 2, zl, dz)})

# force broadcasting into the y and x dimensions
ds['temp'] = t_bot + (t_top - t_bot)*(z_bot - ds.z) / z_bot + 0*ds.y + 0*ds.x
# add anomaly in the region x0-L < x < x0+L
ds['temp'] -= A*np.cos(np.pi / (2*L) * (ds.x - x0))*np.sin(np.pi*(ds.z + dz/2)/(z_bot + dz/2)) * ((x0 - L < ds.x) & (ds.x < x0 + L))

# constant salinity
ds['salt'] = 35 + 0*ds.z + 0*ds.y + 0*ds.x

ds.to_netcdf('input.nc')
