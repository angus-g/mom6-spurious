# Introduction

- audience; don't assume the reader knows more than they do

Spurious diapycnal mixing is undesirable (*weak statement*) in ocean models, due to its modification of density classes, particularly at depth. Weakening the stratification at depth has implications for the overturning circulation and can affect heat and carbon storage (*citation*). One of the considerations in model development and configuration is then to ensure spurious mixing is minimised.

- mixing at depth sets the overturning cells that constitute the MOC (Mashayek et al., 2015)
- spend more time talking about spurious mixing in general
    - we want to use models for ocean heat uptake estimates and overturning circulation predictions -- example studies?
    - these might be biased/wrong if mixing is too large -- *need citations for this*

Minimising spurious diapycnal mixing due to horizontal (along-coordinate) advection has been tackled in many ways. Some argue (*who? I think Andy mentioned this*) that a high-order advection scheme is sufficient to reduce the spurious mixing to acceptable levels (MitGCM 7th order; Daru & Tenaud, 2004). Other advection schemes preserve the sub-gridscale reconstruction of a given field (SOM; Prather, 1986). 

Diagnosing spurious mixing isn't itself a solved problem. Some different approaches include Griffies et al., 2000. *this does something*. An analytical solution has been calculated for the second-order moment scheme (Morales Maqueda & Holloway, 2006). This was then extended by Burchard & Rennau (2008), to a general diagnostic which separates physical and numerical mixing through subgrid scale changes in variance of tracers. A comparative study was done by Ilicak et al. (2012), analysing the role of momentum closure in different models through changes in reference potential energy (RPE; Winters et al., 1995).

- extend to detail methods of diagnosis

Another complication in recent models is ALE (arbitrary Lagrangian-Eulerian, *citation*?), which allows the use of a generalised vertical coordinate. Although schemes have been derived that are accurate in isolation (e.g. White & Adcroft, 2008), they haven't had comparative quantification with horizontal advection within models (*this is worded weirdly, and a hard statement to make*). White et al. (2009) looked at some of the physical implications of ALE employing different vertical coordinates within a model, but didn't look at spurious errors.

- expand this section to a few paragraphs
    - cite Hirt et al., 1974 (as Petersen did)
    - or e.g. entry in Encyclopedia of Computational Mechanics (following White et al., 2009)
    - Margolin & Shashkov, 2003: Second-order sign-preserving conservative interpolation (remapping) on general grids -- this is a good introduction to regridding/remapping
        - different approaches to regridding/remapping so that we can refer to them later

Furthermore, with an open choice of vertical coordinate, it's not clear which is the "best" choice for a given situation (*too informal?*). Some example vertical coordinates are z-tilde (Leclair & Madec, 2011), a modification of the common z-star coordinate (*citation*?) to provide quasi-Lagrangian behaviour (this needs a clearer description); the HyCOM coordinate which adapts different coordinate schemes depending on location (*cite Bleck*); and adaptive terrain-following coordinates (Hofmeister et al., 2010).

To look at the performance of a model with an ALE scheme, Petersen et al. (2015) extended the study of Ilicak et al. The MPAS-Ocean model was added to the suite of results, and the z-tilde coordinate was also used to demonstrate ALE. Based on the performance of MPAS-Ocean with the z-tilde coordinate, Petersen et al. made conclusions about its suitability, but didn't present its impact as a single component, only the overall result (*this sounds somewhat vague, should I just restate the conclusions, but retain the same point*).

- explain Ilicak and Petersen more, perhaps in adjacent paragraphs so they're linked
    - Petersen is a combination of introduction to MPAS-O and evaluation of z-tilde
    - Ilicak is an analysis of momentum closure through the spurious mixing framework, hence the focus on horizontal viscosity and the use of Smagorinsky scheme
    - how they did what they did
    - which tests cases (lock exchange, overflow, internal waves, baroclinic eddies, global spindown)
    - which models they used (MOM, MitGCM, ROMS, POP, MPAS-O)

This paper (*"the present study"?*) has two main aims. Firstly, to verify the behaviour of another ALE model, MOM6 against the models exhibited by Ilicak et al. and Petersen et al. This is done using both the standard configurations, and with a coordinate that is unique to MOM6, continuous isopycnal. Secondly, a method is proposed for using RPE changes to separate the contributions of horizontal and vertical processes (i.e. advection and ALE). This allows for the evaluation of different advection schemes, different orders of interpolation in ALE, and may be one tool in comparing between different vertical coordinates.
