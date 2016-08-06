# Introduction

Spurious diapycnal mixing is undesirable (weak statement) in ocean models, due to its modification of density classes, particularly at depth. Weakening the stratification at depth has implications for the overturning circulation and can affect heat and carbon storage (*citation*). One of the considerations in model development and configuration is then to ensure spurious mixing is minimised.

Minimising spurious diapycnal mixing due to horizontal (along-coordinate) advection has been tackled in many ways. Some argue (who? I think Andy mentioned this) that a high-order advection scheme is sufficient to reduce the spurious mixing to acceptable levels (MitGCM 7th order - Daru & Tenaud, 2004). Other advection schemes preserve the sub-gridscale reconstruction of a given field (SOM/Praether). 

Diagnosing spurious mixing isn't itself a solved problem. Some different approaches include Griffies et al., 2000. *this does something*. Another idea is that of Burchard & Rennau (2008), which separates physical and numerical mixing through subgrid scale changes in variance of tracers. A comparative study was done by Ilicak et al. (2012), analysing the role of momentum closure in different models through changes in reference potential energy (RPE, Winters et al., 1995).

Another complication in recent models is ALE (arbitrary Lagrangian-Eulerian, *citation*?), which allows the use of a generalised vertical coordinate. While ALE is intended to be as accurate as possible in isolation (e.g. White & Adcroft, 2008), it hasn't been quantified in conjunction with horizontal advection. There have been qualitative analyses (White et al., 2009), or physical studies. Furthermore, with an open choice of vertical coordinate, it's not clear which is the "best" choice for a given situation. Some example vertical coordinates are z-tilde (Leclair & Madec, 2011), a modification of the common z-star coordinate (*citation*?) to provide quasi-Lagrangian behaviour (this needs a clearer description); the HyCOM coordinate which adapts different coordinate schemes depending on location; and adaptive terrain-following coordinates (Hofmeister et al., 2010).

To look at the performance of a model with an ALE scheme, Petersen et al. (2015) extended the study of Ilicak et al. The MPAS-Ocean model was added to the suite of results, and the z-tilde coordinate was also used to demonstrate ALE. Based on the performance of MPAS-Ocean with the z-tilde coordinate, Petersen et al. made conclusions about its suitability, but didn't present its impact as a single component, only the overall result (**reword**!).

This paper has two main aims. Firstly, to verify the behaviour of another ALE model, MOM6 against the models exhibited by Ilicak et al. and Petersen et al. This is done using both the standard configurations, and with a coordinate that is unique to MOM6, continuous isopycnal. Secondly, a method is proposed for using RPE changes to separate the contributions of horizontal and vertical processes (i.e. advection and ALE). This allows for the evaluation of different advection schemes, different orders of interpolation in ALE, and may be one tool in comparing between different vertical coordinates.

Literature review:
    - Griffies et al., 2000 (spurious diapycnal mixing associated with advection)
    - Ilicak et al., 2012 (spurious dianuetral mixing and the role of momentum closure)
    - Leclair and Madec, 2011 (z-tilde coordinate)
    - Mashayek et al., 2015 (influence of enhanced abyssal diapycnal mixing)
    - Petersen et al., 2015 (evaluation of ALE in MPAS-O)
    - White et al., 2009 (boundary extrapolation, internal waves and overflow tests)
    - White and Adcroft, 2008 (PQM remapping)
    - Burchard and Rennau, 2008 (another comparison of physical/numerical mixing)
