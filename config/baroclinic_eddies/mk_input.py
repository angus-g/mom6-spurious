import numpy as np
import xarray as xr

# grid spacing
dx = 4e3
# total grid size
xl = 160e3
yl = 500e3
dz = 50
zl = 1000

t_bot = 10.1
t_top = 13.1
z_bot = 975
dt = 1.2
dy = 40e3
dtp = 0.3

y0 = 250e3
ya = 40e3
k = 3
Lx = 160e3
x2 = 110e3
x3 = 130e3

ds = xr.Dataset(coords={'x': np.arange(dx / 2, xl, dx),
                        'y': np.arange(dx / 2, yl, dx),
                        'z': np.arange(dz / 2, zl, dz)})

# temperature in northern portion
t0 = t_bot + (t_top - t_bot)*(z_bot - ds.z) / z_bot
# front location
yw = y0 - ya*np.sin(2*np.pi*k*ds.x / Lx)

# background in north
ds['temp'] = t0 + 0*ds.y + 0*ds.x
# subtract dt in south -- should we use sel for this?
ds['temp'] -= dt * (ds.y <= yw)
# linear between the two
ds['temp'] -= dt * (1 - (ds.y - yw) / dy) * ((yw < ds.y) & (ds.y < yw + dy))

# add perturbation
ywp = y0 - ya/2 * np.sin(np.pi * (ds.x - x2) / (x3 - x2))
tp = dtp * (1 - (ds.y - ywp) / (dy / 2))
ds['temp'] += tp * ((x2 <= ds.x) & (ds.x <= x3) & (ywp - dy/2 <= ds.y) & (ds.y <= ywp + dy/2))

ds['salt'] = 35 + 0*ds.z + 0*ds.y + 0*ds.x

ds.to_netcdf('input.nc')
