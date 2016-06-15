# Introduction

Spurious diapycnal mixing is undesirable in ocean models, due to its modification of density classes, particularly at depth. This has implications for the overturning circulation and can affect heat and carbon storage.

Minimising spurious diapycnal mixing due to horizontal (along-coordinate) advection has been tackled in many ways. Some argue that a high-order advection scheme is sufficient to reduce the spurious mixing to acceptable levels (MitGCM 7th order). Other advection schemes preserve the sub-gridscale reconstruction of a given field (SOM/Praether).

- The choice of vertical coordinate is also important
	- An ideal hybrid coordinate has a geopotential mixed layer, with an isopycnal interior, and possibly again a terrain-following benthic boundary layer
	- It's possible to evaluate the performance of generalised coordinates in terms of the numerical accuracy of the ALE algorithm
	- It's possible to test the overall performance of a hybrid coordinate according to some physical metric (e.g. overturning transport)
	- It's less clear how the choice of vertical coordinate feeds back with the horizontal transport scheme
	
Purposes/aims of the paper:
	- verify the behaviour of MOM6
		- is it suitable to use a very high-order ALE remapping scheme but only use a moderate horizontal advection scheme?
	- test further the split between horizontal and vertical contributions to spurious mixing in an ALE model