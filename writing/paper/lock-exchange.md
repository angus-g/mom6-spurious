---
classoption: twocolumn
...

## Lock Exchange

The lock exchange is a simple experiment that shows the creation of intermediate densities by spurious mixing. It's defined by an initial temperature distribution, providing one density class on each side of the domain,

$$\Theta(x) = \begin{cases}
5 & x < 32\text{ km}\\
30 & x \ge 32\text{ km}\end{cases}.$$

This case is equivalent to two adjacent basins, each at constant temperature, with a dam between them removed instantaneously at $T=0$. The warm water from the right basin flows from right-to-left above cold water, while conversely cold water from the left basin flows underneath the warm water from left-to-right. This is simply a gravity current, for which we know the front velocity in a rectangular channel is given by

$$u_f = \frac12 \sqrt{gH (\partial \rho / \rho_0)}$$

When calculating the grid Reynolds number, the theoretical front velocity is used instead of the actual mean velocity of the domain. All runs were carried out using a baroclinic timestep that satisfied CFL conditions across the range of horizontal viscosities ($\nu_h = 0.01, 0.1, 1, 10, 100, 200$).

![\label{fig:rpenorm} Normalised RPE evolution](plots/lock_exchange_rpe_norm.png)

![\label{fig:drpe} Average rate of RPE change](plots/lock_exchange_drpe.png)

The normalised RPE time series in Figure \ref{fig:rpenorm} shows MOM6 having a similar evolution to MitGCM and MOM5. However, the average rate of change of RPE shown in Figure \ref{fig:drpe} is slightly lower (i.e. smaller spurious component) in MOM6 than the other models.

### Advection order

One aspect of model configuration that may significantly affect spurious mixing is the order of accuracy of the tracer advection scheme in. A higher-order advection scheme purports to reduce the spurious mixing in advection, at the cost of runtime performance. Curiously, the two advection schemes in MOM6, PLM (piecewise linear) and PPM:H3 (Huynh third order piecewise parabolic), exhibit nearly identical spurious mixing. In order to preserve the pre-existing range of density classes by avoiding the creation of spurious minima or maxima, advection schemes may employ limiters. The minimal difference in spurious mixing despite an improved advection scheme may be indicative of advection being dominated by a limiter where spurious mixing is most vigorous; at the front. In the case of MOM6, the limiting scheme reduces to a first-order upstream method.

### Directional split

We can analyse the contribution to RPE by purely horizontal (advective) and purely vertical (regridding/remapping) operations. This is very noisy, as we must take the differences in RPE at multiple points along a single timestep -- we're taking small differences and dividing them by a small differential time, which may have poor precision.

For the lock exchange experiment, we consider that the potential for spurious mixing doesn't significantly change as the front progresses towards the walls. The spurious mixing as diagnosed by the RPE change is then simply the mean of the RPE change at each timestep, for each direction, averaged over the entire run length.

We can see that the mixing is predominantly due to horizontal processes. Indeed, for all of the experiments, the average RPE change due to regridding/remapping is actually negative. Physically, this means that regridding/remapping tends to slightly lower the centre of mass of the domain, counteracting some of the mixing due to the advection scheme.

![\label{fig:rpesplit} Horizontal and vertical contributions to RPE change](plots/lock_exchange_drpe_split.png)

### Negative RPE Schematic

As a physical diagnostic, we expect RPE to be an increasing quantity. However, Figure \ref{fig:rpesplit} shows that the vertical process of regridding/remapping always causes RPE to decrease. We illustrate a simple example that demonstrates the combination of regridding/remapping causing a decrease in total potential energy. For a single column case, this is equivalent to the RPE, assuming no density inversions.

![Placeholder schematic](plots/schematic.png)

The solid rectangles show the grid cells after advection, where the column bottom is at $z = 0$. Regridding moves the interface between the cells to the dashed line, and remapping mixes the quantity $u'$ from the right cell to the left cell. With the condition that $u_1 > u_2$ (stable stratification), it is possible for $PE_f - PE_i < 0$ when the remapping is higher order than piecewise constant (PCM). PCM is the lowest order reconstruction, and gives $u' = u_1 \Delta h$, thus $PE_f - PE_i \ge 0$.
