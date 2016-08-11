## Baroclinic eddies

The previous two test cases were only 2D, and therefore couldn't incorporate any rotation. This test case involves a baroclinically unstable temperature front in a periodic channel with rotation. The front has a sinusoidal meridional position, defined as

$$y_w(x) = y_0 - y_A \sin\left(2\pi k \frac{x}{L_x}\right),$$

where $y_A = 40\,\text{km}$ is the amplitude, $y_0 = 250\,\text{km}$ is the centre of the domain, $k = 3$ and $L_x = 160\,\text{km}$ ensure that three wavelengths span the width of the domain. The temperature distribution in the domain is given by

$$\Theta(x,y,z) = \begin{cases}
\Theta_0(z) & y \ge y_w(x) + \Delta y, \\
\Theta_0(z) - \Delta \Theta \left(1 - \frac{y - y_w(x)}{\Delta y}\right) & y_w < y < y_w + \Delta y, \\
\Theta_0(z) - \Delta \Theta & y \le y_w(x),\end{cases}$$

where $\Theta_0(z)$ is a linearly stratified background between 10.1 C and 13.1 C, $\Delta y = 40\,\text{km}$ is the width of the front and $\Delta \Theta = 1.2\,\mathrm{C}$ is the temperature difference across the front. Additionally, a temperature perturbation is added to the crest of one of the waves to promote baroclinic instability. The region over which the perturbation is added is bounded by $x_2 \le x \le x_3$ and $y'_w - \Delta y / 2 \le y \le y'_w + \Delta y / 2$, where

$$y'_w(x) = y_0 - \frac{y_A}{2}\sin\left(\pi \frac{x - x_2}{x_3 - x_2}\right).$$

The perturbation itself is defined by the temperature anomaly

$$\Theta'(x,y) = \Delta\Theta'\left(1 - \frac{y - y'_w(x)}{\Delta y / 2}\right)$$

The domain is 160km wide by 500km long, with a depth of 1000m. Experiments were performed at horizontal resolutions of 1km, 4km and 10km, at a constant uniform vertical resolution of 50m. For each choice of horizontal resolution, the horizontal viscosities were $\nu_h = 1, 5, 10 20, 200$, giving a range of lateral grid Reynolds numbers from $O(1)$ at the highest viscosity, through to $O(1000)$ for the lowest viscosity.

![\label{fig:drpe_10} RPE rate of change at 10km resolution](plots/eddies_drpe_10.png)

Figures \ref{fig:drpe_10}, \ref{fig:drpe_4} and \ref{fig:drpe_1} show the RPE rate of change across all tested models for 10km, 4km and 1km horizontal resolution, respectively. In the 10km experiment, the two available tracer advection schemes were used, PLM shown in magenta circles and the higher-order PPM:H3 scheme in magenta triangles. In the spurious mixing saturation regime of $\mathrm{Re}_\Delta > 10$, MOM6 with the PLM scheme plateaus at a very similar level to MOM and POP. As expected, the PPM:H3 scheme exhibits slightly lower spurious mixing, especially at the lowest grid Reynolds number. However, in the saturation regime the spurious mixing continues to rise slightly with increasing grid Reynolds number, exceeding the PLM scheme.

![\label{fig:drpe_4} RPE rate of change at 4km resolution](plots/eddies_drpe_4.png)

When the horizontal resolution is decreased to 4km, MOM6 exhibits slighly greater spurious mixing than POP across the range of experiments. At this resolution, the PPM:H3 advection scheme consistently provides a small decrease in spurious mixing as compared to the PLM scheme.

![\label{fig:drpe_1} RPE rate of change at 1km resolution](plots/eddies_drpe_1.png)

![\label{fig:split_10} Spurious mixing orientation at 10km resolution](plots/eddies_drpe_split_10.png)

![\label{fig:split_4} Spurious mixing orientation at 4km resolution](plots/eddies_drpe_split_4.png)

![\label{fig:split_1} Spurious mixing orientation at 1km resolution](plots/eddies_drpe_split_1.png)
