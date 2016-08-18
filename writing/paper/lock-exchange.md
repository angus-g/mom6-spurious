## Lock Exchange

The lock exchange test case is a simple configuration that shows the creation of intermediate densities by spurious mixing. This is a replication of one of the test cases presented by @ilicak12. The test case takes place in a two-dimensional domain of 64km width and 20m depth. Only the highest resolution test cases are chosen, with horizontal and vertical grid spacings of $\Delta x = \SI{500}{\metre}$ and $\Delta z = \SI{1}{\metre}$, respectively. The lock exchange is defined by an initial temperature distribution comprised of one density class on each side of the domain,

![\label{fig:snapshot} Snapshots of lock exchange at 6 hours (top) and 17 hours (bottom) at $\nu_h = \SI{0.01}{\square\metre\per\second}$. Temperature (\si{\celsius}) is shown in colours. Spurious mixing at the front can be seen by the presence of intermediate temperatures.](plots/lock_exchange_snapshot_0.01.pdf)

$$\Theta(x) = \begin{cases}
\SI{5}{\celsius} & x < \SI{32}{\kilo\metre}\\
\SI{30}{\celsius} & x \ge \SI{32}{\kilo\metre}\end{cases}.$$

This case is equivalent to two adjacent basins, each at constant temperature, with a dam between them that is removed at $T=0$. The warm water from the right basin flows from right-to-left above cold water, while conversely cold water from the left basin flows underneath the warm water from left-to-right. This is simply a gravity current, for which we have a theoretical prediction for the front velocity in a rectangular channel, given by

$$u_f = \frac12 \sqrt{gH \rho'},$$

where $\rho'$ is the density difference across the front. When calculating the grid Reynolds number, the theoretical front velocity is used instead of the actual mean velocity over the domain. All runs were carried out for 17 hours using a baroclinic timestep that satisfied CFL conditions across the range of horizontal viscosities (\SIlist{0.01;0.1;1;10;100;200}{\square\metre\per\second}).

![\label{fig:rpenorm} Normalised RPE evolution for $\nu_h = \SI{0.01}{\square\metre\per\second}$. MPAS-O, MITGCM and MOM results come from @petersen15 and @ilicak12. MOM6 exhibits a larger increase in RPE due to spurious mixing.](plots/lock_exchange_rpe_norm.pdf)

![\label{fig:drpe} Instantaneous rate of RPE change at 17h. MPAS-O and MITGCM results come from @petersen15 and @ilicak12.](plots/lock_exchange_drpe.pdf)

The time series of normalised RPE in \cref{fig:rpenorm} shows MOM6 having a similar shape to MitGCM and MOM5. However, the curve steepens with time, suggesting that more spurious mixing is occurring in MOM6.

Above a grid Reynolds number of 10, MOM6 performs similarly to the other models shown in \cref{fig:drpe}. At this point, the models are running above the threshold for saturation of spurious mixing. However, in the regime where spurious mixing isn't saturated, MOM6 exhibits a higher rate of RPE change. This result suggests that spurious mixing in MOM6 is due to tracer advection, as viscosity in the unsaturated regime is sufficient to damp grid-scale noise in the velocity field.

### Advection order

One aspect of model configuration that may significantly affect spurious mixing is the order of accuracy of the tracer advection scheme. A higher-order advection scheme purports to reduce the spurious mixing in advection, at the cost of runtime performance. Curiously, the two advection schemes in MOM6, PLM (piecewise linear) and PPM:H3 (Huynh third order piecewise parabolic), exhibit nearly identical spurious mixing. In order to preserve the pre-existing range of density classes by avoiding the creation of spurious minima or maxima, advection schemes may employ limiters. In MOM6, the limiting scheme reduces to a first-order upstream method. The minimal difference in spurious mixing despite an improved advection scheme implies that advection may be dominated by a limiter at the front, where spurious mixing is most vigorous.

### Directional split

![\label{fig:rpesplit} Horizontal and vertical contributions to RPE change](plots/lock_exchange_drpe_split.pdf)

\Cref{fig:rpesplit} shows that the mixing is predominantly due to horizontal processes. Indeed, for all of the experiments, the average RPE change due to regridding/remapping is actually negative. Physically, this means that regridding/remapping tends to slightly lower the centre of mass of the domain, counteracting some of the centre of mass increase due to mixing by the advection scheme. The magnitude of this compensation by regridding/remapping is negligible, so the spurious mixing is still set by the tracer advection scheme.
