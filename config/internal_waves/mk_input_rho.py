import numpy as np
from netCDF4 import Dataset

# horizontal grid spacing
dx = 5e3

# zonal domain size
xl = 250e3
# meridional domain size (irrelevant)
yl = 20e3
# domain depth
zl = 500
# thickness of each level
dz = 25
# 5x enhanced resolution for calculating
# the z-space profile to be interpolated
# back into temperature space
dzc = 5

# minimum density layer thickness
min_thick = 0.001

# surface temperature
t_top = 20.1
# bottom temperature
t_bot = 10.1

# width of perturbation region
L = 50e3
# centre of perturbation region
x0 = xl / 2
# amplitude of temperature anomaly
A = 2

xc = np.arange(dx / 2, xl, dx).reshape(1,-1)
yc = np.arange(dx / 2, yl, dx).reshape(-1,1)
# final grid in depth coordinates
zc = np.arange(dz / 2, zl, dz)

# computational grid (calculate on interfaces)
# because we're using np.searchsorted below, which assumes that the
# array you're searching is sorted in ascending order, we actually
# generate these interface positions from the bottom upward
zcc = np.arange(0, zl + 1, dzc)[::-1].reshape(-1,1)
# calculate on layers (we don't want to do this)
#zcc = np.arange(dzc / 2, zl, dzc)

# temperature-space coordinates
intc = np.linspace(t_top, t_bot, zc.size + 1)
layc = (intc[:-1] + intc[1:]) / 2

# first, generate the 2d profile of the internal waves
# in the enhanced-resolution depth-space coordinates
t = t_bot + (t_top - t_bot) * (zl - zcc) / zl \
  - A * np.cos((xc - x0) * np.pi / (2 * L)) \
      * np.sin(np.pi * zcc / zl) \
      * ((x0 - L < xc) & (xc < x0 + L))

# now calculate the thickness profile in density space
thickness = np.zeros((layc.size, xc.size)) + min_thick

for i in range(xc.size):
    # loop over columns
    col = t[:,i]

    # calculate the indices into the column with searchsorted
    ind = np.searchsorted(col, intc)

    # current z-space position (starting at the top)
    top = 0

    for k in range(1, layc.size):
        j = ind[k]

        # loop over layers within a given column
        bot = zcc[j] + dzc * (col[j] - intc[k]) / (col[j] - col[j-1])

        thickness[k-1,i] = bot - top

        # move the top of the next layer to the bottom of this layer
        top = bot

    # we'll be left with one last layer, which is the difference between top and the bottom of the column
    thickness[-1,i] = zl - top

# output to a netCDF dataset
d = Dataset('input_rho.nc', 'w')
d.createDimension('x', xc.size)
d.createDimension('y', yc.size)
d.createDimension('lay', layc.size)
d.createDimension('int', intc.size)

d.createVariable('lay',  'f8', ('lay',))[:] = layc
d.createVariable('int',  'f8', ('int',))[:] = intc
d.createVariable('temp', 'f8', ('lay', 'y', 'x'))[:] = np.tile(layc.reshape(-1,1,1), (1, yc.size, xc.size))
d.createVariable('salt', 'f8', ('lay', 'y', 'x'))[:] = 35
d.createVariable('h',    'f8', ('lay', 'y', 'x'))[:] = np.tile(thickness.reshape(thickness.shape[0], 1, -1), (1, yc.size, 1))

d.close()
