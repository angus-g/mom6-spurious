from netCDF4 import Dataset
import numpy as np

# reference density
rho_0 = 1001.0
# density change with salinity
drho_ds = 0.8
# reference salinity
s_0 = 35.0
# density change with temperature
drho_dt = -0.2

def calc_rpe(d, suffix='postale', step=None, var=None):
  """
  Calculate the RPE in dataset d. If var is None, the variables
  containing temperature and thickness data are given by 'T_' + suffix
  and 'h_' + suffix, respectively, where suffix defaults to 'postale'.
  Alternatively, the variable names can be specified in keys 't' and 'h'
  in the dictionary var. If step is None, the RPE is calculated at every
  timestep present in the dataset, otherwise it will be calculated at
  the specified frequency.
  """

  # assume a uniform grid-spacing and calculate the size
  # in each direction
  dx = d.variables['xh'][1] - d.variables['xh'][0]
  dy = d.variables['yh'][1] - d.variables['yh'][0]

  # calculate the area of a single cell and the entire basin
  cell_area = dx * dy * 1e3**2
  basin_area = cell_area * d.variables['xh'].size * d.variables['yh'].size

  if var is None:
    t_all = d.variables['T_' + suffix]
    h_all = d.variables['h_' + suffix]
  else:
    t_all = d.variables[var['t']]
    h_all = d.variables[var['h']]

  # total number of timesteps
  nt = t_all.shape[0]

  if step is None:
    rpe = np.zeros(nt)
    r = range(nt)
    step = 1
  else:
    rpe = np.zeros(int(nt / step))
    r = range(0, nt, step)

  # process RPE for each timestep that we want
  for k in r:
    t = t_all[k,...].ravel()
    h = h_all[k,...].ravel()

    indices = np.argsort(t, None)
    # reference interface positions
    z_ref = np.insert(np.cumsum(h[indices] * cell_area / basin_area), 0, 0)
    # convert to layer positions
    z_lay = (z_ref[1:] + z_ref[:-1]) / 2.0

    rho = rho_0 + drho_dt * t[indices]

    # scale by basin area
    rpe[int(k / step)] = 9.8 * np.sum(rho * h[indices] * cell_area * z_lay) / basin_area

  return rpe

def diff2(u, x):
  """
  Calculate the second-order first derivative of u
  on the grid specified by x (assumed to be uniform)
  """

  # grid spacing
  dx = x[1] - x[0]

  du = np.zeros_like(u)
  # handle left edge
  du[0]    = (-3*u[0]  + 4*u[1]  - u[2])  / (2*dx)
  # handle right edge
  du[-1]   = ( 3*u[-1] - 4*u[-2] + u[-3]) / (2*dx)
  # interior points are just centred difference
  du[1:-1] = (u[2:] - u[:-2]) / (2*dx)

  return du

def drpe_dt(f):
  """
  Calculate the time rate of change for total
  RPE for a given netCDF file specified by f.
  """

  d = Dataset(f, 'r')

  # calculate RPE every timestep
  rpe = calc_rpe(d)
  tv = d.variables['Time']
  time = tv[:]
  if 'minutes' in tv.units:
    time *= 60
  elif 'hours' in tv.units:
    time *= 3600
  elif 'days' in tv.units:
    time *= 24 * 3600

  d.close()

  return diff2(rpe, time)

def drpe_dt_split(f):
  """
  Calculate the horizontal and vertical contributions to RPE
  from netCDF file f containing variables {T,h}_{pre,post}ale.
  Differencing is only first-order here
  """

  d = Dataset(f, 'r')

  rpe_pre = calc_rpe(d, 'preale')
  rpe_post = calc_rpe(d, 'postale')
  tv = d.variables['Time']
  time = tv[:]
  if 'minutes' in tv.units:
    time *= 60
  elif 'hours' in tv.units:
    time *= 3600
  elif 'days' in tv.units:
    time *= 24 * 3600

  # nominal diagnostic timestep
  dt = time[1] - time[0]

  # we can only really calculate a backward difference
  # to get an estimate of the rpe split
  drpe_horiz = (rpe_pre[1:] - rpe_post[:-1]) / dt
  drpe_vert  = (rpe_post - rpe_pre) / dt

  d.close()

  return drpe_horiz, drpe_vert

def rpe_norm(f, step=100, split=True):
  """
  Calculate the normalised RPE evolution of the form rpenorm = (rpe -
  rpe(0)) / rpe(0) If split is True, we assume the split state variables
  'T_postale' and 'h_preale' exist, otherwise they are taken as 'temp'
  and 'h'. By default, every 100th timestep is used.
  """

  d = Dataset(f, 'r')

  if not split:
    v = {'t': 'temp', 'h': 'h'}
  else:
    v = None

  rpe = calc_rpe(d, step=step, var=v)
  rpe = (rpe - rpe[0]) / rpe[0]
  time = d.variables['Time'][::step]
  d.close()

  return time, rpe

def vel_scale(f):
  """
  Calculate a crude velocity scale from the mean of layerwise
  kinetic energy and mass from an ocean.stats.nc file.
  """

  d = Dataset(f, 'r')

  ke = d.variables['KE'][:]
  ma = d.variables['Mass_lay'][:]

  d.close()

  return np.sqrt(2.0 * np.mean(ke / ma, 1))
