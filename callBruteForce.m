matrixData = csvread('matrixDistances.csv');
[optimalRoute, minimalDistance] = bruteForce(matrixData);
disp('Optimal Route:');
disp(optimalRoute);
disp('Minimal Distance:');
disp(minimalDistance);