# Theory

## Resting/reference/background potential energy

A physically relatable measurement of spurious mixing comes from the reference potential energy (RPE; Winters et al., 1995). This is the lowest attainable potential energy of a given fluid, with no energy available for motion. To obtain this state, the fluid is adiabatically resorted to a stable stratification, where every fluid parcel is spread laterally across the entire domain. Mathematically, the RPE is expressed as

$$\mathrm{RPE} = g \int_\Omega z \rho^*(z)\,\mathrm dV,$$

where $\rho^*$ is the adiabatically resorted density profile. The RPE is well-defined when a linear equation of state is used. With a nonlinear equation of state, a fluid parcel's density depends on its depth (more precisely, it's hydrostatic pressure), which changes when the domain is resorted.

While it's possible to exactly calculate the reference density profile for a non-linear equation of state, it's very expensive (appendix of Ilicak et al., 2012). Using an approximation, such as calculating the density using a reference pressure, significantly decreases the cost of the calculation, at the expense of incurring an error in the RPE. An alternative is to construct a volume frequency distribution of fluid parcels as a function of temperature and salinity (Saenz et al., 2015). This has a lower computational cost than adiabatic sorting, but again doesn't capture compressibility effects, which are argued to be minor. However, for simplicity of calculation we will use a linear equation of state. This eliminates the consequences of a nonlinear equation of state such as cabbeling and thermobaricity, as well as the effect of compressibility on the reference profile. Using a linear equation of state thus reduces sources of error in the calculation of density and the reference profile.

In a numerical model that exhibits identically zero mixing, with no buoyancy forcing, every fluid parcel must necessarily maintain its density. In this case, the adiabatic resorting of the fluid is constant, regardless of the actual depth or location of the parcels. When the reference profile defined by the adiabatic resorting, and the densities of the parcels themselves are constant, the RPE is also constant. Thus, when all parameterised mixing (e.g. vertical diffusion) is disabled, and there is no buoyancy forcing, a model with zero spurious mixing will have constant RPE.

However, spurious mixing changes this story (*weak statement*). Assuming a limited advection scheme, one which is unable to create denser or lighter densities than already exist, spurious mixing will create (or add to) some intermediate density class between two pre-existing densities. With the further assumption that any given fluid state is statically stable, mixing has the effect of raising the centre of mass of the fluid. This manifests as in increase in the RPE. Conversely, RPE can only be decreased by lowering the centre of mass of the fluid. (*link to the next section*?)

## Splitting up contributions (*better subsection heading*)

- "which is the new bit"
- explain how horizontal vs. vertical might be important (stratification vs. nonlinear EOS, for example?)

In many models, there's a distinction between the horizontal (along-coordinate) and vertical dynamics. This is particularly the case in models with a generalised vertical coordinate, such as those employing the ALE algorithm. Taking advantage of this distinction, we can diagnose the RPE at multiple points during a single timestep. In combination with knowledge about the structure of the timestep itself, this allows us to attribute an increase in RPE to a specific section of code, concerning either horizontal or vertical dynamics.

The RPE contributions must be carefully calculated so that they include only information from relevant portions of a single timestep. This means that the increases in RPE may be small, from slight changes in density or fluid parcel volume. Diagnosing an instantaneous rate of change of RPE within a timestep may then involve dividing a small change in RPE by a short delta time, an operation that may be imprecise in floating-point arithmetic. We must ensure that sufficient samples are taken to give a significant result.
