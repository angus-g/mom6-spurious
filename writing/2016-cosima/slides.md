---
title: Spurious Mixing in MOM6
subtitle: An energetic approach
author: Angus Gibson
date: May 27, 2016
---

# Overview
## Motivation

- Understand the numerical accuracy of different:
    - remapping schemes
    - advection schemes
    - vertical coordinates
- Evaluate MOM6?

## Reference (background) potential energy

- The lowest potential energy state of a fluid
    - Adiabatically resort to a stratified state
- Should be constant in an unforced model with closed boundaries
    - Increased by mixing; centre of mass is raised

$$ \mathrm{RPE} = g \int_\Omega z \rho^*(z)\,\mathrm dV$$

- *Gives no localised information*

## Looking at a timestep

- MOM6 is a generalised vertical coordinate model (ALE)
    - Clear distinction between along- and across-coordinate dynamics
- Take differences in RPE from different parts of a timestep to determine their contribution
    - $\Delta \mathrm{RPE}_\text{adv} = \mathrm{RPE}_\text{post adv} - \mathrm{RPE}_\text{pre adv}$
    - $\Delta \mathrm{RPE}_\text{ale} = \mathrm{RPE}_\text{post ale} - \mathrm{RPE}_\text{pre ale}$

# Experiments
## Overview

- We follow experiments from Ilicak et al. (2012) and Petersen et al. (2015):
    - Lock exchange (dam break)
    - Overflow (downslope flow)
    - Internal gravity waves
    - Baroclinic eddies
- Spurious mixing is investigated as a function of the grid Reynolds number:

$$\mathrm{Re}_\Delta = \frac{U\Delta x}{\nu_h}$$

# Overflow
## Low viscosity

![$z^*$ coordinate at $Re_\Delta = 1.5\times10^5$](images/flow_downslope_KH0.01.png)

## High viscosity

![$z^*$ coordinate at $Re_\Delta = 1.5$](images/flow_downslope_KH1000.png)

## Low viscosity (sigma)

![Sigma coordinate at $Re_\Delta = 1.5\times10^5$](images/flow_downslope_sigma_KH0.01.png)

## High viscosity (sigma)

![Sigma coordinate at $Re_\Delta = 1.5$](images/flow_downslope_sigma_KH1000.png)

* * *

![Model comparison (mean dRPE/dt over entire run)](images/flow_downslope_drpe_dt.png)

# Baroclinic eddies
* * *

![Surface snapshot](images/beddies_snap.png)

* * *

![Solid: MPAS-O, dashed: MOM6](images/beddies_rpenorm.png)

* * *

![Model comparison](images/beddies_drpe_dt.png)

* * *

![Direction split](images/beddies_split.png)

# Internal waves
* * *

![Snapshot](images/waves_snap.png)

* * *

![Effect of coordinates](images/waves_drpe_dt.png)

* * *

![An explanation](images/waves_tilde.png)

## Discussion
- High-order advection schemes?
- The effect of CFL number (edge differencing)
- Coordinate choices

* * *

![](images/waves_split.png)
