# Introduction

- define basic concepts and arrange them in a clear progression of ideas
    - start by stating that the governing equations for most ocean models are based on approximations of the incompressible Navier-Stokes equations for momentum
    - vertical balance is hydrostatic, mixing of momentum by unresolved eddy advection parameterised by an explicit eddy viscosity
    - potential density controlled by salinity and potential temperature through an equation of state
    - tracers (salinity, temperature), are advected by the explicitly resolved velocity field
    - mixing of tracer by unresolved eddies parameterised by eddy diffusion
    - can then lay out how components are represented numerically and how truncation errors can create spurious tracer mixing, and its impacts on ocean circulation

One of the myriad uses of ocean models is in developing ocean heat uptake estimates and overturning circulation predictions. Additionally, the overturning circulation itself affects the wider climate, which manifests when ocean models are used as a component of coupled climate simulations. The problems of ocean heat uptake and overturning circulation are both strongly defined by the density structure of the ocean, which is modified by mixing. For example, mixing at depth controls the abyssal overturning cell that constitutes part of the meridional overturning circulation (Mashayek et al., 2015).

- expand point, since without mixing there is no abyssal overturning

Models are unable to accurately constrain the abyssal overturning as the magnitude of spurious diapycnal mixing cannot be completely controlled.

- focus on overturning and its implications for climate
    - mention heat + CO2 uptake associated with overturning, and the crucial role of mixing

## Spurious mixing

Mixing is a flux acting to flatten tracer gradients. In ocean models, mixing has two main causes, physical and numerical. Physical mixing is the diffusion of tracers, with a diffusivity that may be determined by various parameterisations. On the other hand, numerical mixing arises from the discretisations and algorithms used by the ocean model in implementing the governing equations. Numerical mixing is also known as spurious mixing and doesn't have any physical basis.

- perhaps specific parameterised/numerical mixing examples?
    - simple diagram
    - 1st order upwind advection, leading error term is numerical diffusion
- typical estimates, how significant is the mixing?
- explain that there is genuine (molecular) diffusion, and advection by numerically unresolved eddies, which is parameterised as a diffusive process

Spurious mixing is undesirable in ocean models, due to its unphysical nature, and because it may add to the imposed and parameterised mixing to an unknown extent. This affects numerical experiments whose results are contingent on the density structure of the ocean. Ocean heat uptake or overturning circulation strength may be biased or incorrect.

- references that mention magnitude of spurious mixing in overturning circulation experiments
    - should make the case that spurious mixing must be minimised

One of the considerations in model development and configuration is then to ensure spurious mixing is minimised.

## Advection schemes

The magnitude of spurious mixing is strongly controlled by the choice of trace advection scheme.

- define advection scheme, flux limiter

Much of the focus in reducing spurious mixing has therefore been on horizontal advection, through improving numerical accuracy or the model's subgrid scale representations. Some argue that a high-order advection scheme is sufficient to reduce the spurious mixing to acceptable levels (MitGCM 7th order; Daru & Tenaud, 2004). This is simply a matter of using a sufficiently high-order polynomial reconstruction to try to capture the overall structure. Other advection schemes attempt to preserve the subgrid scale representation of a given field (SOM; Prather, 1986). By carrying information about both first and second-order moments, the model is able to exactly reconstruct a field to second order. The second-order moment scheme has the issue that it must often be used in conjunction with a flux limiter to ensure against the creation of spurious minima and maxima, which in essence reduces back to a first-order advection scheme. Ilicak et al. (2012) suggest that the tracer advection scheme only needs sufficient accuracy before grid-scale noise in velocity becomes the dominant source of spurious mixing.

## ALE, the choice of vertical coordinate
Furthermore, with an open choice of vertical coordinate, it's not clear which is the ideal choice for a specific class of modelling. The terrain-following sigma coordinate is often used for coastal modelling, but may present issues with pressure gradient calculation due to strongly sloping coordinate surfaces. To keep the advantages of a terrain-following coordinate, but reduce pressure gradient errors and spurious mixing, Hofmeister et al. (2010) formulated an adaptive terrain-following grid. Vertical layer positions are modified through a vertical diffusion proportional to shear, stratification and distance from boundaries, whereas the grid is smoothed in the horizontal. Another adaptive vertical grid is z-tilde (Leclair & Madec, 2011), which has Lagrangian behaviour to motions on short timescales, but relaxes to a target grid over long timescales to prevent the grid from drifting. This is good for allowing the propagation of internal gravity waves. A final example in the grid used by the HyCOM model (Bleck, 2002), which adapts to different coordinates depending on location, such as terrain-following near boundaries, or isopycnal at depth. In isolation, these coordinates aren't sufficient for ocean modelling, but the combination attempts to preserve the strengths of each.

- decide on "grid" vs. "coordinate"

Another gridding method in recent models is ALE (arbitrary Lagrangian-Eulerian, *citation*?), which allows the use of a generalised vertical coordinate.

- expand this section to a few paragraphs
    - cite Hirt et al., 1974 (as Petersen did)
    - or e.g. entry in Encyclopedia of Computational Mechanics (following White et al., 2009)
    - Margolin & Shashkov, 2003: Second-order sign-preserving conservative interpolation (remapping) on general grids -- this is a good introduction to regridding/remapping
        - different approaches to regridding/remapping so that we can refer to them later

White & Adcroft (2008) demonstrated the development and implementation of an accurate reconstruction scheme for the remapping stage of ALE, with their piecewise quartic method (PQM). The impacts of different regridding and remapping schemes were considered by White et al. (2009), comparing their spurious diffusion in terms of the change of volume distributions across density classes.

## Evaluating/diagnosing spurious mixing
In attempting to evaluate the performance of numerical schemes with regard to spurious mixing, there is no consensus on the diagnostic technique to use. Griffies et al. (2000) used an effective diapycnal diffusivity, which allows for direct comparison between the spurious mixing and expected oceanic values. However, because it uses a reference density profile compiled from the entire domain, the effective diffusivity is only a single idealised vertical profile, and can't be mapped back to real space in any meaningful manner.

An alternative to diagnosing spurious mixing from the model state is to calculate an analytical solution from the advection operator itself. Morales Maqueda & Holloway (2006) did this with upstream based schemes, such as the second-order moment method of Prather, calculating a closed form expression for the implicit numerical diffusivity.

- one paragraph per diagnostic scheme

Substituting the second-order moment scheme for an arbitrary choice of horizontal advection scheme, Burchard & Rennau (2008) showed that by considering the destruction of variance of a tracer by horizontal advection, the impact on subgrid scale structure can be inferred. This leads to a general diagnostic which gives a comparison of physical and numerical mixing through subgrid scale changes. Tracer variance can be calculated for every model gridpoint, and thus the variance destruction gives information about the relative impact of physical and numerical mixing through full space, given a statistically significant integration period.

## Ilicak
A simpler diagnostic of spurious mixing is simply to observe its effects on the reference potential energy (RPE; Winters et al., 1995). This gives only timeseries data (no localised information), but allows for ready comparison across models for the same physical configuration. Ilicak et al. (2012) used the rate of change of RPE in analysing the role of momentum closure between different models (GOLD, MITgcm, MOM and ROMS). Comparisons were performed across a suite of test cases intended to stress different physical phenomena; a lock exchange, downslope flow, internal gravity waves, baroclinic eddies, and a global spindown. By varying the horizontal viscosity, spurious mixing was shown to be increase with the lateral grid Reynolds number up until saturation, demonstrating the importance of momentum transport.

- define grid Re
- explain/expand "the importance of momentum transport"

## Petersen
To look at the performance of a model with an ALE scheme, Petersen et al. (2015) extended the study of Ilicak et al. The terrain-following sigma coordinate, isopycnal, and Leclair & Madec's z-tilde coordinate were used to demonstrate the ALE in the MPAS-Ocean model.

- POP was also added to the suite of results, because of its z-level coordinate
- z-tilde leads to a reduction in vertical transport across layer interfaces, and a reduction in spurious diapycnal mixing
- we'll extend this by showing a coordinate's impact to spurious mixing in isolation, as well as its overall effect

## Section conclusion, tie to rest of report
This paper has two main aims. Firstly, to evaluate the performance of another ALE model, MOM6 against the models exhibited by Ilicak et al. and Petersen et al. The comparison is made using both the standard configurations, and with a coordinate that is unique to MOM6, continuous isopycnal. Secondly, a method is proposed for using RPE changes to separate the contributions of horizontal and vertical processes (i.e. advection and ALE). This method allows for the evaluation of different advection schemes, and different orders of interpolation in ALE, and is proposed as a useful tool in comparing between different vertical coordinates.
