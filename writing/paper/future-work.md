## Future Work

The present stage of my work has focused on the development and implementation of a method for diagnosing the orientation of spurious mixing. By separating the horizontal and vertical contributions, we can pinpoint which is significantly affecting spurious mixing. Additionally, the interplay and feedbacks between different choices of horizontal and vertical dynamics can be examined, instead of relying only on their contributions to the total measure of spurious mixing. To make use of my spurious mixing diagnostic, I've implemented a suite of standardised test cases in MOM6, namely the lock exchange, overflow, internal waves and baroclinic eddies test cases used by Ilicak et al. (2012) and Petersen et al. (2015).

In my work with MOM6, I've separately analysed the impacts of the order of accuracy of tracer advection scheme used, the order of accuracy of the vertical reconstruction scheme, and a variety of different vertical coordinates. The information gathered from these analyses can be used to inform future model configurations, in order to minimise spurious mixing and capture the dynamical processes of interest.

The next major section of my project will be to implement and evaluate a new vertical coordinate in MOM6.

- use of spring dynamics to govern the grid
- a coordinate that optimises for the curvature of density surfaces in the far field
