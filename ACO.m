numAnts = 500;
numIterations = 100;
evaporationRate = 0.5;
%Pheromone evaporating over time to avoid convergence at a suboptimal tour
alpha = 1; % Weightage of pheromone
beta = 5; % Weightage assigned to inverse of distance
Q = 100; % Constant of pheromone deposit

distanceMatrix = csvread('matrixDistances.csv');
[nCities,~] = size(distanceMatrix);
distanceMatrix(distanceMatrix == 0) = Inf;
lPheromone = ones(nCities, nCities);

bestTourLength = inf;
bestTour = [];
startingCity=1;

for i = 1:numIterations
    tours = zeros(numAnts, nCities);
    
    for ant = 1:numAnts
        startCity = startingCity;
        tour = startCity;
        for step = 1:nCities-1
            currentCity = tour(end);
            probabilities = (lPheromone(currentCity, :) .^ alpha) .* (1 ./ distanceMatrix(currentCity, :) .^ beta);
            probabilities(tour) = 0; % Exclude visited cities
            probabilities = probabilities / sum(probabilities);%Normalize
            nextCity = randsample(nCities, 1, true, probabilities);
            tour = [tour, nextCity];
        end
        tours(ant, :) = tour;
        tour(end+1)=1;
        tourLength = sum(arrayfun(@(i) distanceMatrix(tour(i), tour(mod(i, nCities) + 1)), 1:nCities));
        
        if tourLength < bestTourLength
            bestTourLength = tourLength;
            bestTour = tour;
        end
    end

    dPheromone = zeros(nCities, nCities);
    for ant = 1:numAnts
        tour = tours(ant, :);
        for k = 1:nCities
            j = mod(k, nCities) + 1;
            dPheromone(tour(k), tour(k)) = dPheromone(tour(k), tour(j)) + Q / tourLength;
        end
    end
    lPheromone = (1-evaporationRate)*lPheromone+dPheromone;
end

disp('Best Tour:');
disp(bestTour);
disp('Length of Best Tour:');
disp(bestTourLength);
