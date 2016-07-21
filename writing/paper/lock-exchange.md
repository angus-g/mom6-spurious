## Lock Exchange

The lock exchange is a very simple configuration that we can use to measure mixing. It's defined by an initial temperature distribution,

$$\Theta(x) = \begin{cases}
5 & x < 32\text{ km}\\
30 & x \ge 32\text{ km}\end{cases}.$$

This case is equivalent to two adjacent basins, each at constant temperature, with a dam between them removed instantaneously at the beginning of simulation. The warm water from the right basin flows from right-to-left above cold water, and conversely cold water from the left basin flows underneath the warm water from left-to-right. This is simply a gravity current, for which we know the front velocity in a rectangular channel is given by

$$u_f = \frac12 \sqrt{gH (\partial \rho / \rho_0)}$$

![](plots/lock_exchange_rpe_norm.png)

When calculating the grid Reynolds number, the theoretical front velocity is used instead of the actual mean velocity of the domain.

All runs were carried out using a baroclinic timestep that satisfied CFL conditions across the range of horizontal viscosities.

![](plots/lock_exchange_drpe.png)

### Directional split

We can analyse the contribution to RPE by purely horizontal (advective) and purely vertical (remapping) operations. This is very noisy, as we must take the differences in RPE at multiple points along a single timestep -- we're taking small differences and dividing them by a small differential time, which may have poor precision.

For the lock exchange experiment, we consider that the potential for spurious mixing doesn't significantly change as the front progresses towards the walls. The spurious mixing as diagnosed by the RPE change is then simply the mean of the RPE change at each timestep, for each direction, averaged over the entire run length.

We can see that the mixing is predominantly due to horizontal processes. Indeed, for the majority of experiments, the average RPE change due to remapping is actually negative. Physically, this means that the remapping tends to restratify the domain, sharpening density gradients rather than reducing them by mixing.


### Advection order

Another consideration is the order of accuracy of the tracer advection scheme in use by the model. A higher-order advection scheme purports to reduce the spurious mixing in advection, at the cost of runtime performance. Curiously, the advection schemes in MOM6 that are higher order than PCM performs very similarly to one another. This is usually indicative of advection being dominated by a limiter. In order to preserve the pre-existing range of density classes by avoiding the creation of spurious minima or maxima, advection schemes may employ limiters. In the case of MOM6, the limiting scheme reduces to a first-order upstream method. Since the difference in the spurious mixing between the piecewise linear and higher order cases is so minimal, it's likely that any time the advection scheme is contributing to spurious mixing, it's doing so through an operation in which the limiter is active. In other words, advection at the front is dominating.
