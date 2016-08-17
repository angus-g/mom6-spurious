# Future Work

The present stage of my work has focused on the development and implementation of a method for diagnosing the orientation of spurious mixing. By separating the horizontal and vertical contributions, we can pinpoint the source of spurious mixing. Additionally, the interplay and feedbacks between different choices of horizontal and vertical dynamics can be examined, instead of relying only on their contributions to the total measure of spurious mixing. To make use of my spurious mixing diagnostic, I've implemented a suite of standardised test cases in MOM6, namely the lock exchange, overflow, internal waves and baroclinic eddies test cases used by @ilicak12 and @petersen15.

In my work with MOM6, I've separately analysed the impacts of the order of accuracy of tracer advection scheme used, the order of accuracy of the vertical reconstruction scheme, and a variety of different vertical coordinates. The information gathered from these analyses can be used to inform future model configurations, in order to minimise spurious mixing and capture the dynamical processes of interest. At the moment, I am writing up this work for publication in Ocean Modelling.

The next major section of my project will be to implement and evaluate a new vertical coordinate in MOM6. This will likely take part during an extended stay at GFDL, so that I can closely collaborate with the main developers of MOM6, Alistair Adcroft and Robert Hallberg. As such, the exact direction of my work will be strongly influenced by their recommendations and desires about what needs to be implemented in the model. Adcroft and Hallberg are leaders and drivers of the MOM6 project as the model is prepared for use in high-impact scientific settings, such as GFDL's 1/10$^\circ$ coupled climate model and the CMIP6 project. Adcroft is mainly responsible for numerical developments in MOM6, therefore he would co-author a paper produced from my stay at GFDL.

Current plans will focus on investigating one of two possible strategies. The first is the use of spring dynamics to govern the vertical grid. There is precedence for using spring dynamics to control horizontal grids, e.g. @tomita01. This approach uses spring dynamics to move grid points to reduce grid-scale noise. When used in the vertical, the stiffness of the springs may be modified by the model state, or prescribed to result in an adaptive vertical grid that is unable to "tangle" up, as grid points are aware of their neighbours.

The second strategy is the extension of an adaptive 3D vertical coordinate [@hofmeister10]. This method defines a grid through diffusion equations, incorporating different elements of model state, such as stratification and shear. By filtering horizontally, the vertical coordinate can be coupled between neighbouring water columns. A new component to be added to this formulation is an equation to minimise the curvature of density surfaces over distance. This is intended to represent large-scale isopycnal surfaces, while permitting local variations in density structure.

The final direction of my project is less certain, as it depends on input from Adcroft and Hallberg.

- some kind of physical link, or evaluation of coordinate choice

## Timeline

Currently, I'm writing up my work on diagnosing the orientation of spurious mixing for publication. I hope to submit this within the next few months; it would be a refinement of the current report. There are a few additional experiments to run, particularly baroclinic eddies with a continuous isopycnal vertical coordinate. I am also awaiting input from Alistair Adcroft regarding his thoughts on current results and any further suggestions for experiments/analyses. This work forms the motivation for the next stage of my project, by showing that at low viscosities, or particularly at high horizontal resolutions, the vertical coordinate scheme has a significant impact. I think an ideal time to work at GFDL would be early next year, as the first phase of my project is wrapping up. By doing this, I'd aim to have publishable work within the first half of next year.

- final part of timeline

# References
<!-- empty header for citeproc references -->
\small
