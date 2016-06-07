from netCDF4 import Dataset
import numpy as np
import sys

# horizontal grid spacing
if len(sys.argv) < 3:
  dx = 4e3
else:
  dx = 1e3 * int(sys.argv[2])

# zonal domain size
xl = 160e3
# meridional domain size
yl = 500e3
# domain depth
zl = 1000
# thickness of each level
dz = 50

# temperature of surface layer
t_top = 13.1
# temperature of bottom-most layer
t_bot = 10.1
# temperature difference across front
dt = 1.2

# width of front
dy = 40e3

# temperature anomaly difference
dtp = 0.3
# meridional centre of domain
y0 = yl / 2
# amplitude of front
ya = 40e3
# wavenumber of front
k = 3
# zonal boundaries of anomaly region
x2 = 110e3
x3 = 130e3

# minimum density layer thickness
min_thick = 0.001

# coordinate variables
# spatial coordinates
xc = np.arange(dx / 2, xl, dx).reshape(1,-1)
yc = np.arange(dx / 2, yl, dx).reshape(-1,1)
zc = np.arange(dz / 2, zl, dz)
# temperature-space coordinates
intc = np.linspace(t_top, t_bot - dt, zc.size + 1)
layc = (intc[:-1] + intc[1:]) / 2

# calculate the temperature profile as thicknesses in density space
# we know that the sum of thickness everywhere must be the domain thickness
# and there are no non-linearities
# where the density difference from top to bottom is t_top - t_bot
# we just:
# - calculate the surface temperature profile
# - convert this to a thickness in some top-most cell
# - fill the rest downwards

# calculate the domain thickness in density space
# interface below which there's a fraction of a layer filled
lmax = np.where(t_bot < intc)[0][-1]
lmax += (intc[lmax] - t_bot) / (intc[lmax] - intc[lmax + 1])

print('domain is {} density layers thick'.format(lmax))

# we have lmax layers spanning the depth of our domain
# calculate the thickness of each density layer
lay_thick = zl / lmax

print('density layer thickness:', lay_thick)

# front location
yw = y0 - ya*np.sin(2*np.pi*k*xc / xl)

# calculate surface temperature profile
t_surf  = t_top + 0*yc + 0*xc # maximum in the north
t_surf -= dt * (yc <= yw)       # subtract dt in south
t_surf -= dt * (1 - (yc - yw) / dy) \
             * ((yw < yc) & (yc < yw + dy))

# add perturbation
ywp = y0 - ya/2 * np.sin(np.pi * (xc - x2) / (x3 - x2))
tp = dtp * (1 - (yc - ywp) / (dy / 2))
t_surf_p = t_surf + tp * ((x2 <= xc) & (xc <= x3) & (ywp - dy/2 <= yc) & (yc <= ywp + dy/2))

thickness = np.zeros((layc.size, yc.size, xc.size)) + min_thick

for j in range(yc.size):
  for i in range(xc.size):
    # find starting layer; this is the layer below the lowest interface
    # greater than the surface temperature
    l_top = np.where(t_surf_p[j,i] <= intc)[0][-1]

    # find fraction of layer which should be filled
    f_top = 1 - (intc[l_top] - t_surf_p[j,i]) / (intc[l_top] - intc[l_top+1])

    # fractionally fill this layer
    t = f_top * lay_thick
    thickness[l_top,j,i] = t
    # remaining column thickness to distribute
    # account for the minimum thickness of the layers we won't fill
    rem = zl - (layc.size - lmax) * min_thick
    rem -= t
    # step downwards
    l_top += 1

    # distribute the rest of the thickness down the column
    while rem > 0:
      # we can't fill a layer any more than lay_thick
      t = min(rem, lay_thick)

      try:
        thickness[l_top,j,i] = t
      except IndexError:
        print('ran out of thickness at ({}, {}); {} remaining'.format(j, i, rem))

      rem -= t
      l_top += 1

d = Dataset('input_rho.nc', 'w')
d.createDimension('x', xc.size)
d.createDimension('y', yc.size)
d.createDimension('lay', layc.size)

d.createVariable('lay', 'f8', ('lay',))[:] = layc
d.createVariable('temp', 'f8', ('lay', 'y', 'x'))[:] = np.tile(layc.reshape(-1,1,1), (1, yc.size, xc.size))
d.createVariable('salt', 'f4', ('lay', 'y', 'x'))[:] = 35
d.createVariable('h', 'f8', ('lay', 'y', 'x'))[:] = thickness
d.createVariable('t_surf', 'f8', ('y', 'x'))[:] = t_surf

d.close()
