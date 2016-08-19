---
title: The Orientation of Spurious Mixing
author: Angus Gibson
date: August 18, 2016
header-includes:
- \usepackage[font=footnotesize,labelfont=bf]{caption}
- \usepackage[list-units=single]{siunitx}
- \newcommand{\columnsbegin}{\begin{columns}}
- \newcommand{\columnsend}{\end{columns}}
---

# Overview
## Motivation

- Ocean models can be used for heat uptake estimates and overturning predictions [@armour16]
- Mixing at depth controls the abyssal overturning cell [@mashayek15]
- Spurious mixing occurs due to discretisation and numerical algorithms
    - May bias results

## How models work

- MOM6 is a quasi-Lagrangian ALE (arbitrary Lagrangian-Eulerian) model (defined by @leclair11)
- During each timestep:
    - Solve the primitive equations, advect tracers (**horizontal**)
    - Calculate a new vertical grid based on the current model state (*regridding*)
    - New grid is applied (*remapping*, **vertical**)

## Regridding/remapping

\columnsbegin
\column{0.5\textwidth}

- (Conservative) sub-cell reconstructions of velocity and tracers
- Integrated between interfaces, mixed between cells

\column{0.5\textwidth}

![](../paper/plots/schematic.pdf)

\columnsend

## Previous work

- @ilicak12 -- the role of momentum on spurious mixing
    - require lateral grid Reynolds number, $\mathrm{Re}_\Delta = U\Delta x / \nu_h < 2$
    - spurious mixing saturated at $\mathrm{Re}_\Delta \approx 10$

- @petersen15 -- performance of an ALE model
    - z-tilde coordinate reduces cross-interface vertical transport
    - not suitable for large, transient flows

## Reference potential energy

$$\mathrm{RPE} = g\int_\Omega z \rho^*(z) \,\mathrm{d}V$$

- Lowest potential energy state of fluid by adiabatic processes
- Increases with spurious mixing
- Calculate the orientation of spurious mixing with RPE at three points:
    - $\mathrm{RPE}_i$ at start of timestep
    - $\mathrm{RPE}_h$ after horizontal
    - $\mathrm{RPE}_v$ after vertical
- Change due to **horizontal** only: $\mathrm{RPE}_h - \mathrm{RPE}_i$
- Change due to **vertical** only: $\mathrm{RPE}_v - \mathrm{RPE}_h$

# Experiments
## Overview

- Run a suite of three idealised test cases in MOM6
- Compare to models evaluated by @ilicak12 and @petersen15
- Diagnose the orientation of spurious mixing in MOM6

# Lock Exchange
## Overview

- \SI{64}{\kilo\metre} long, \SI{20}{\metre} deep two-dimensional domain
- $\Delta x = \SI{500}{\metre}$, $\Delta z = \SI{1}{\metre}$

$$\Theta(x) = \begin{cases} \SI{5}{\celsius}, & x < \SI{32}{\kilo\metre} \\ \SI{30}{\celsius}, & x \ge \SI{32}{\kilo\metre} \end{cases}$$

- Range of horizontal viscosities $\nu_h$: \SIlist{0.01;0.1;1;10;100;200}{\square\metre\per\second}
- Run for 17 hours

* * *

![Lock exchange at 6 hours (top) and 17 hours (bottom) at $\nu_h = \SI{0.01}{\square\metre\per\second}$](../paper/plots/lock_exchange_snapshot_0.01.pdf){width=75%}

* * *

![Instantaneous rate of RPE change at 17 hours.](../paper/plots/lock_exchange_drpe.pdf){width=75%}

* * *

![Spurious mixing orientation](../paper/plots/lock_exchange_drpe_split.pdf){width=75%}

# Internal Waves
## Overview

- Raised isopycnals in the centre of a linearly stratified domain
    - Sets up internal waves with period of approximately 1 day
- \SI{250}{\kilo\metre} wide, \SI{500}{\metre} deep two-dimensional domain
- $\Delta x = \SI{5}{\kilo\metre}$, $\Delta z = \SI{25}{\metre}$
- z-star, z-tilde and continuous isopycnal coordinates
- Range of horizontal viscosities $\nu_h$: \SIlist{0.01;1;15;150}{\square\metre\per\second}
- Run for 100 days

* * *

![Internal waves initial condition and 100 day snapshot.](../paper/plots/internal_waves_snapshot_0.01.pdf){width=75%}

* * *

![Averaged rate of RPE change from 10-100 days.](../paper/plots/internal_waves_drpe.pdf){width=75%}

* * *

![z-tilde snapshot after 8 days at $\nu_h = \SI{150}{\square\metre\per\second}$](internal_waves_snapshot_tilde_150.pdf)

* * *

![Spurious mixing orientation](../paper/plots/internal_waves_drpe_split.pdf){width=75%}

# Baroclinic Eddies
## Overview

\columnsbegin
\column{0.5\textwidth}

- Three-dimensional, periodic channel \SI{160}{\kilo\metre} wide, \SI{500}{\kilo\metre} long and \SI{1000}{\metre} deep
- Sinusoidal temperature front with an added perturbation to promote instability, quadratic bottom drag with $C_D = 0.01$
- Horizontal viscosities $\nu_h$: \SIlist{1;5;10;20;200}{\square\metre\per\second}
- Horizontal resolutions $\Delta x$: \SIlist{1;4;10}{\kilo\metre}, $\Delta z = \SI{50}{\metre}$

\column{0.5\textwidth}

![Baroclinic eddies initial surface temperature. Temperature is linearly stratified with depth](../paper/plots/eddies_snapshot_dx1_initial.pdf)

\columnsend

* * *

![Comparison of surface temperature at low and high horizontal viscosity, \SI{1}{\kilo\metre} horizontal resolution](../paper/plots/eddies_snapshot_dx1.pdf){width=75%}

* * *

![Spurious mixing orientation](../paper/plots/eddies_drpe_split.pdf){width=75%}

# Future work

* * *
<!-- ~ 5 mins -->

## References {.allowframebreaks}
\footnotesize
