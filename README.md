# PhyDyn simulations

This repository is for simulation experiments to evaluate performance of the [PhyDyn](https://github.com/mrc-ide/PhyDyn) BEAST2 package. 
We simulate a SIRS infectious disease epidemic such that transmission rates vary over the course of infection and between risk groups. 
Simulations are individual-based, stochastic, and continuos time using a Gillespie exact algorithm implemented in Python. 
A genealogy of the transmission history is reconstructed by subsampling lineages over time. 
PhyDyn is then used to re-estimate parameters. 
For a description of the model including equations, see the manuscript: [https://www.biorxiv.org/content/early/2018/04/10/268052](https://www.biorxiv.org/content/early/2018/04/10/268052)

Note the following

* This simulation test is based on genealogies, not on simulated sequences
* BEAST is _not_ used to simulate data, only to re-estimated parameters. We simulate epidemics using a python script and use an R script to sample genealogies. 

Simulation sets are included: 

1. 2000 initial susceptible individuals and sampling 250 lineages over a long period of time. 
2. 5000 initial susceptible, sampling 500 over a short period of time. 

In both cases, sampling is heterochronous following epidemic peak.
