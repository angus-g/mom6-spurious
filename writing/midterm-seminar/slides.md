---
title: The Orientation of Spurious Mixing
author: Angus Gibson
date: August 18, 2016
header-includes:
- \usepackage[font=small, labelfont=bf]{caption}
- \usepackage{siunitx}
- \newcommand{\columnsbegin}{\begin{columns}}
- \newcommand{\columnsend}{\end{columns}}
---

# Overview
## Motivation

- Mixing at depth controls the abyssal overturning cell [@mashayek15]
- Spurious mixing

## How models work

- MOM6 is a quasi-Lagrangian model (defined by @leclair11)
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

- @ilicak12
- @petersen15

## Reference potential energy

$$\mathrm{RPE} = g\int_\Omega \rho^* z \,\mathrm{d}V$$

# Experiments
## Overview

- Stuff

# Lock Exchange
## Overview

<!--
- intro
- snapshots
- drpe
- split
-->

Stuff

* * *

![Lock exchange at 6 hours (top) and 17 hours (bottom) at $\nu_h = \SI{0.01}{\square\metre\per\second}$](../paper/plots/lock_exchange_snapshot_0.01.pdf){width=75%}

* * *

![Instantaneous rate of RPE change at 17 hours.](../paper/plots/lock_exchange_drpe.pdf){width=75%}

* * *

![Spurious mixing orientation](../paper/plots/lock_exchange_drpe_split.pdf){width=75%}

# Internal Waves
## Overview

Stuff

<!-- intro -->

* * *

![Internal waves initial condition and 100 day snapshot.](../paper/plots/internal_waves_snapshot_0.01.pdf){width=75%}

* * *

![Averaged rate of RPE change from 10-100 days.](../paper/plots/internal_waves_drpe.pdf){width=75%}

* * *

![Spurious mixing orientation](../paper/plots/internal_waves_drpe_split.pdf){width=75%}

# Baroclinic Eddies
## Overview

Something

<!-- intro -->

* * *

![Baroclinic eddies initial condition](../paper/plots/eddies_snapshot_dx1_initial.pdf){width=75%}

* * *

![Comparison of surface temperature at different horizontal viscosity](../paper/plots/eddies_snapshot_dx1.pdf){width=75%}

* * *

![Spurious mixing orientation](../paper/plots/eddies_drpe_split.pdf){width=75%}

# Future work

* * *
<!-- ~ 5 mins -->

## References {.allowframebreaks}
\footnotesize
