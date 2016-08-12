# Introduction

One of the myriad uses of ocean models is in developing ocean heat uptake estimates and overturning circulation predictions. Additionally, the overturning circulation itself affects the wider climate, which manifests when ocean models are used as a component of coupled climate simulations. The problems of ocean heat uptake and overturning circulation are both strongly defined by the density structure of the ocean, which is modified by mixing. For example, mixing at depth controls the abyssal overturning cell that constitutes part of the meridional overturning circulation (Mashayek et al., 2015).

- expand point, since without mixing there is no abyssal overturning
- mention heat + CO2 uptake associated with overturning, and the crucial role of mixing

Models are unable to accurately constrain the abyssal overturning as the magnitude of spurious diapycnal mixing cannot be completely controlled.

Numerical ocean models are governed by approximations of the incompressible Navier-Stokes equations for momentum, also known as the primitive equations. In these models, the vertical balance is hydrostatic, where the vertical pressure gradient force is balanced by the gravitational force. The mixing of momentum by the unresolved eddy field is parameterised by an explicit eddy viscosity term. Potential density of water parcels is controlled by salinity and potential density through an equation of state. These tracers are advected by the explicitly resolved eddy field, and mixed by the unresolved eddy field through a parameterised eddy diffusion term.

To solve the primitive equations, ocean models implement some kind of discretisation, such as the finite volume method. This involves representing the computational domain as a series of grid cells in three-dimensional space, where each grid cell has associated mean velocities and tracer concentrations. Tracer advection schemes are discretisations of the advection equation that create higher-order reconstructions of the tracer field using information from neighbouring grid cells. Often, tracer advection schemes are coupled with a flux limiter, which prevents the creation of spurious minima or maxima in tracer concentration.

## Spurious mixing
Mixing processes create fluxes of tracer between grid cells. In ocean models, mixing has two main causes, physical and numerical. A small fraction of physical mixing comes from molecular diffusion. The rest comes advection by numerically unresolved eddies, which is parameterised as a diffusive process. On the other hand, numerical mixing arises from the discretisations and algorithms used by the ocean model in implementing the governing equations. Numerical mixing is also known as spurious mixing and doesn't have any physical basis. For example, first-order upwind advection has numerical diffusion as the leading error term.

- typical estimates, how significant is the mixing?

Spurious mixing is undesirable in ocean models, due to its unphysical nature, and because it may add to the imposed and parameterised mixing to an unknown extent. This affects numerical experiments whose results are contingent on the density structure of the ocean. Ocean heat uptake or overturning circulation strength may be biased or incorrect. One of the considerations in model development and configuration is thus to ensure spurious mixing is minimised.

## Advection schemes
The magnitude of spurious mixing is strongly controlled by the choice of tracer advection scheme. Much of the focus in reducing spurious mixing has therefore been on horizontal tracer advection, through improving numerical accuracy or the model's subgrid scale representations. Some argue that a high-order advection scheme is sufficient to reduce the spurious mixing to acceptable levels (Daru & Tenaud, 2004). This is simply a matter of using a sufficiently high-order polynomial reconstruction to try to capture the overall structure. Other advection schemes attempt to preserve the subgrid scale representation of a given field (Prather, 1986). By carrying information about both first and second-order moments, the model is able to exactly reconstruct a field to second order. The second-order moment scheme must often be used in conjunction with a flux limiter to ensure against the creation of spurious minima and maxima, which in essence reduces back to a first-order advection scheme. A further view is that the tracer advection scheme only needs sufficient accuracy before grid-scale noise in velocity becomes the dominant source of spurious mixing (Ilicak et al., 2012).

## ALE, the choice of vertical coordinate
Furthermore, with an open choice of vertical coordinate, it's not clear which is the ideal choice for a specific class of modelling. The terrain-following sigma coordinate is often used for coastal modelling, but may present issues with pressure gradient calculation due to strongly sloping coordinate surfaces. To keep the advantages of a terrain-following coordinate, but reduce pressure gradient errors and spurious mixing, Hofmeister et al. (2010) formulated an adaptive terrain-following grid. Vertical layer positions are modified through a vertical diffusion proportional to shear, stratification and distance from boundaries, whereas the grid is smoothed in the horizontal. Another adaptive vertical grid is z-tilde (Leclair & Madec, 2011), which has Lagrangian behaviour to motions on short timescales, but relaxes to a target grid over long timescales to prevent the grid from drifting. This is good for allowing the propagation of internal gravity waves. A final example in the grid used by the HyCOM model (Bleck, 2002), which adapts to different coordinates depending on location, such as terrain-following near boundaries, or isopycnal at depth. In isolation, these coordinates aren't sufficient for ocean modelling, but the combination attempts to preserve the strengths of each.

To allow generalised vertical coordinates, models often make use of an arbitrary Lagrangian-Eulerian (ALE) scheme. There are two general implementations of ALE in ocean models, depending on the reference frame of the model (Margolin & Shashkov, 2003; Leclair & Madec, 2011). In quasi-Eulerian models, the vertical grid is unable to move during the dynamics phase, when the equations of motion are solved. When a new vertical grid is computed, its motion relative to the old vertical grid is calculated as a vertical velocity, which is then used in a vertical advection equation to move coordinate surfaces (Kasahara, 1974). There is a spurious mixing component associated with the use of an advection scheme in this implementation.

The quasi-Lagrangian algorithm (Hirt et al., 1974) is for models which are implemented in a Lagrangian frame of reference. Here, the vertical grid moves during the dynamics phase. During the regridding phase, the new vertical grid is calculated. Finally, there is the remapping phase, during which the model state is mapped onto the new grid, often with an algorithm that conserves total tracers.

- mention that we're working with quasi-Lagrangian aka regridding/remapping
- mention the mechanism by which remapping can spuriously mix -- good link to next paragraph

White & Adcroft (2008) demonstrated the development and implementation of an accurate reconstruction scheme for the remapping stage of ALE, with their piecewise quartic method (PQM). The impacts of different regridding and remapping schemes were considered by White et al. (2009), comparing their spurious diffusion in terms of the change of volume distributions across density classes.

- expand, mention how we can contribute

## Evaluating/diagnosing spurious mixing
In attempting to evaluate the performance of numerical schemes with regard to spurious mixing, there is no consensus on the diagnostic technique to use. Griffies et al. (2000) used an effective diapycnal diffusivity, which allows for direct comparison between the spurious mixing and expected oceanic values. However, because it uses a reference density profile compiled from the entire domain, the effective diffusivity is only a single idealised vertical profile, and can't be mapped back to real space in any meaningful manner.

An alternative to diagnosing spurious mixing from the model state is to calculate an analytical solution from the advection operator itself. Morales Maqueda & Holloway (2006) did this with upstream based schemes, such as the second-order moment method of Prather, calculating a closed form expression for the implicit numerical diffusivity.

Substituting the second-order moment scheme for an arbitrary choice of horizontal advection scheme, Burchard & Rennau (2008) showed that by considering the destruction of variance of a tracer by horizontal advection, the impact on subgrid scale structure can be inferred. This leads to a general diagnostic which gives a comparison of physical and numerical mixing through subgrid scale changes. Tracer variance can be calculated for every model gridpoint, and thus the variance destruction gives information about the relative impact of physical and numerical mixing through full space, given a statistically significant integration period.

## Ilicak
A simpler diagnostic of spurious mixing is simply to observe its effects on the reference potential energy (RPE; Winters et al., 1995). This gives only timeseries data (no localised information), but allows for ready comparison across models for the same physical configuration. Ilicak et al. (2012) used the rate of change of RPE in analysing the role of momentum closure between different models (GOLD, MITGCM, MOM and ROMS). Comparisons were performed across a suite of test cases intended to stress different physical phenomena; a lock exchange, downslope flow, internal gravity waves, baroclinic eddies, and a global spindown.

The lateral grid Reynolds number is defined as 

$$\mathrm{Re}_\Delta = \frac{U\Delta x}{\nu_h},$$

where $U$ is the characteristic velocity scale, $\Delta x$ is the horizontal grid spacing and $\nu_h$ is the horizontal viscosity coefficient. For the dissipation of spurious grid-scale noise in the velocity field, the lateral grid Reynolds number should be less than 2 (Griffies, 2004). By varying the horizontal viscosity, spurious mixing was shown to increase with the lateral grid Reynolds number up until saturation at approximately $\mathrm{Re}_\Delta = 10$. This demonstrates that the momentum closure must be chosen such that it reduces spurious grid-scale noise, which causes a saturation in the spurious mixing.

## Petersen
To look at the performance of a model with an ALE scheme, Petersen et al. (2015) extended the study of Ilicak et al. In addition to the z-star and isopycnal coordinates, three additional vertical coordinates were used to demonstrate the ALE in the MPAS-Ocean model; the terrain-following sigma coordinate, z-level, and z-tilde (Leclair & Madec, 2011). To compare to another model with a z-level vertical coordinate, POP was also added to the suite of models.

As MPAS-O is a quasi-Eulerian model, there is a resolved transport across vertical layer interfaces during tracer advection. Use of z-tilde leads to a reduction in this transport, and therefore a reduction in spurious diapycnal mixing associated with the choice of vertical coordinate.

## Section conclusion, tie to rest of report
This paper has two main aims. Firstly, to evaluate the performance of another ALE model, MOM6 against the models exhibited by Ilicak et al. and Petersen et al. The comparison is made using both the standard configurations, and with a coordinate that is unique to MOM6, continuous isopycnal. Secondly, a method is proposed for using RPE changes to separate the contributions of horizontal and vertical processes (i.e. advection and ALE). This method allows for the evaluation of different advection schemes, and different orders of interpolation in ALE, and is proposed as a useful tool in comparing between different vertical coordinates.

- highlight holes in current research, and where my contributes fit in
