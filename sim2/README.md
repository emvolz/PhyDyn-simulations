# Simulation set 2

These simulations describe an SIRS epidemic with two risk groups and two stages of infection for a total of four demes. The transmission rate varies between all demes.
For a description of the model, see the manuscript: [https://www.biorxiv.org/content/early/2018/04/10/268052](https://www.biorxiv.org/content/early/2018/04/10/268052)

Twenty five simulations are carried out with 5000 initial susceptible and sampling 500 lineages for a short period following epidemic peak. 

Four parameters are estimated using BEAST2 PhyDyn
* Transmission rate for SIR dynamics
	- True value = .25 
* Transmission risk ratio for 1st stage of infection ('acute')
	- True value varied bwetween simulations from 1 to 9
* Transmission risk ratio for the high risk group 
	- True value varied bwetween simulations from 1 to 9
And a 'nuisance' parameter
* Initial number infected 

Estimates make use of different approximate structured coalescent models, and estimates obtained with different models are compared in the analysis script. See the ms. for more information on the different coalescent models available in BEAST2. 


## Reproducing results 
1) Simulate the epidemics and sample genealogies.
This will use multiple CPU's on your computer to do all of the simulations, so first check that the script is calling appropriate resources. 
```
python sim0.py 
```

2) Generate XML's to define BEAST2 analyses 
```
Rscript genxml2.0.R
```

3) Run BEAST2 analyses. 
These can be run individually our using multiple CPU's using the `batchbeast0.py` script

4) Analyse results 
```
Rscript a0.beast.R
``` 
Note that there is a variable at the top of this file which can be changed to generate results for different coalescent models (PL1, PL2, or QL)

