# Introduction

Spurious diapycnal mixing is undesirable (weak statement) in ocean models, due to its modification of density classes, particularly at depth. This has implications for the overturning circulation and can affect heat and carbon storage. (*citation*)

Minimising spurious diapycnal mixing due to horizontal (along-coordinate) advection has been tackled in many ways. Some argue that a high-order advection scheme is sufficient to reduce the spurious mixing to acceptable levels (MitGCM 7th order - Daru & Tenaud, 2004). Other advection schemes preserve the sub-gridscale reconstruction of a given field (SOM/Praether).

Diagnosing spurious mixing isn't a solved problem. Some different approaches include Griffies et al., 2000. *this does something*. Another idea is that of Burchard & Rennau (2008), which separates physical and numerical mixing through subgrid scale changes in variance of tracers. A comparative study was done by Ilicak et al. (2012), analysing the role of momentum closure in different models through changes in reference potential energy (RPE, Winters et al., 1995).

Another complication in recent models is ALE (arbitrary Lagrangian-Eulerian), which allows the use of a generalised vertical coordinate. While ALE is intended to be as accurate as possible in isolation (e.g. White & Adcroft, 2008), it hasn't been quantified in conjunction with horizontal advection. There have been qualitative analyses (White et al., 2009)

To look at the performance of a model with an ALE scheme, Petersen et al. (2015) extended the study of Ilicak et al. The MPAS-Ocean model was added to the suite of results, and one example of a generalised vertical coordinate, z-tilde (Leclair & Madec, 2011) was tested.

This paper has two main aims. Firstly, to verify the behaviour of another ALE model, MOM6 against the models exhibited by Ilicak et al. and Petersen et al. This is done using both the standard configurations, and with a coordinate that is unique to MOM6, continuous isopycnal. Secondly, a method is proposed for using RPE changes to separate the contributions of horizontal and vertical processes (i.e. advection and ALE). This allows for the evaluation of different advection schemes, and different orders of interpolation in ALE.

- The choice of vertical coordinate is also important
	- An ideal hybrid coordinate has a geopotential mixed layer, with an isopycnal interior, and possibly again a terrain-following benthic boundary layer
	- It's possible to evaluate the performance of generalised coordinates in terms of the numerical accuracy of the ALE algorithm
	- It's possible to test the overall performance of a hybrid coordinate according to some physical metric (e.g. overturning transport)
	- It's less clear how the choice of vertical coordinate feeds back with the horizontal transport scheme

Literature review:
    - Griffies et al., 2000 (spurious diapycnal mixing associated with advection)
    - Ilicak et al., 2012 (spurious dianuetral mixing and the role of momentum closure)
    - Leclair and Madec, 2011 (z-tilde coordinate)
    - Mashayek et al., 2015 (influence of enhanced abyssal diapycnal mixing)
    - Petersen et al., 2015 (evaluation of ALE in MPAS-O)
    - White et al., 2009 (boundary extrapolation, internal waves and overflow tests)
    - White and Adcroft, 2008 (PQM remapping)
    - Burchard and Rennau, 2008 (another comparison of physical/numerical mixing)
