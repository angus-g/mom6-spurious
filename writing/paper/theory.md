# Theory

## Resting/reference/background potential energy

A physically relatable measurement of spurious mixing comes from the reference potential energy (RPE). This is the lowest attainable potential energy of a given fluid, with no energy available for motion. To obtain this state, the fluid is adiabatically resorted to a stable stratification, where every fluid parcel is spread laterally across the entire domain. Mathematically, the RPE is expressed as

$$\mathrm{RPE} = g \int_\Omega z \rho^*(z)\,\mathrm dV,$$

where $\rho^*$ is the adiabatically resorted density profile. The RPE is well-defined when a linear equation of state is used. With a nonlinear equation of state, a fluid parcel's density depends on its depth (more precisely, it's hydrostatic pressure), which changes when the domain is resorted.

While it's possible to exactly calculate the reference density profile for a non-linear equation of state, it's very expensive. Using an approximation, such as calculating the density using a reference pressure, significantly decreases the cost of the calculation, at the expense of incurring an error in the RPE. For simplicity of calculation, and to focus only on spurious dianeutral mixing regardless of depth, we will only consider the linear equation of state from here on.

In a numerical model that exhibits identically zero spurious mixing, absent of any parameterised mixing or buoyancy forcing, every fluid parcel must necessarily maintain its density. In this case, the adiabatic resorting of the fluid is constant, regardless of the location of the parcels. Then the RPE must also remain constant.

However, spurious mixing changes this story. Assuming a limited advection scheme (that's unable to create spurious minima or maxima), spurious mixing will create (or add to) some intermediate density class between two pre-existing classes. With the assumption that any given fluid state is statically stable, mixing has the effect of increasing the centre of mass of the fluid. This manifests as in increase in the RPE. Indeed, only antidiffusive effects can decrease the RPE, by increasing density gradients and thus just restratifying a fluid column -- essentially the inverse of the spurious mixing process.

## Splitting up contributions

In many models, there's a distinction between the horizontal (along-coordinate) and vertical dynamics. This is particularly the case in models with a generalised vertical coordinate, such as those employing the ALE algorithm. Taking advantage of this distinction, we can diagnose the RPE at multiple points during a single timestep. In combination with knowledge about the structure of the timestep itself, this allows us to attribute an increase in RPE to a specific section of code, concerning either horizontal or vertical dynamics.

However, performing this split places restrictions on when the RPE is calculated, so as not to taint the results. For example, if we calculated the RPE every second timestep, one of the split components would contain three contributions, and the other split would contain one. This has the effect of appearing to inflate the contribution of one component.

Therefore, the RPE contributions must be carefully calculated so that they include only information from a single timestep. This means that the increases in RPE are small, and calculating a derivative takes place over a short delta time, which may reduce the precision of the calculated result.