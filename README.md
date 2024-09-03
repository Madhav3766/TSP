# tsp
Simulations of various approaches to the Travelling Salesman Problem

1. Brute Force Method
2. Nearest Neighbour Method
3. Linear programming
4. Clarke-Wright Savings Algorithm

For the Clarke-Wright Savings Algorithm, run clarkeRunner.m
For the Linear Programming Implementation, run martixGeneratorP.m BEFORE running solve_tsp_lpp.m.
Make sure both of them are in the same environment.

Nearest Neighbour and Brute Force also import the distances CSV. To generate a different set of diatcnes or for a different number of cities, compile and run matrixGenerator.m
When running NearestNeighbour.m, make sure nthLowestIndex.m is also in the same workspace/directory.
