# Future Work

The present stage of my work has focused on the development and implementation of a method for diagnosing the orientation of spurious mixing. By separating the horizontal and vertical contributions, we can pinpoint the source of spurious mixing. Additionally, the interplay and feedbacks between different choices of horizontal and vertical dynamics can be examined, instead of relying only on their contributions to the total measure of spurious mixing. To make use of my spurious mixing diagnostic, I've implemented a suite of standardised test cases in MOM6, namely the lock exchange, overflow, internal waves and baroclinic eddies test cases used by @ilicak12 and @petersen15.

In my work with MOM6, I've separately analysed the impacts of the order of accuracy of tracer advection scheme used, the order of accuracy of the vertical reconstruction scheme, and a variety of different vertical coordinates. The information gathered from these analyses can be used to inform future model configurations, in order to minimise spurious mixing and capture the dynamical processes of interest. At the moment, I am writing up this work for publication in Ocean Modelling.

The next major section of my project will be to implement and evaluate a new vertical coordinate in MOM6. This will likely take part during an extended stay at GFDL, so that I can closely collaborate with the main developers of MOM6, Alistair Adcroft and Robert Hallberg. As such, the exact direction of my work will be strongly influenced by their recommendations and desires about what needs to be implemented in the model. Adcroft and Hallberg are leaders and drivers of the MOM6 project as the model is prepared for use in high-impact scientific settings, such as GFDL's 1/10$^\circ$ coupled climate model and the CMIP6 project.

One possible project direction is the use of spring dynamics to govern the vertical grid. There is precedence for this in the horizontal grid, e.g. @tomita01, using spring dynamics to move grid points to reduce grid-scale noise. When used in the vertical, the stiffness of the springs may be modified by the model state, or prescribed to result in an adaptive vertical grid that is unable to "tangle" up, as grid points are aware of their neighbours.

Another idea is the extension of an adaptive 3D vertical coordinate [@hofmeister10]. This method allows for the combination of different properties to define a grid through diffusion equations. A new component to be added is an equation to optimise for the curvature of density surfaces over distance. This is intended to represent large-scale isopycnal surfaces, while permitting local variation.

- third direction, further future
- more detailed plan with timelines, milestones
  - could be open to change depending on input
- tabulated budget of time


# References
<!-- empty header for citeproc references -->
\small
