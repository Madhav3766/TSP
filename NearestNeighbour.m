distanceMatrix = csvread('matrixDistances.csv');
% distances from city to city
startingCity = 1;
currentCity = startingCity;
[nCities,~] = size(distanceMatrix); 
i=1;%Counter variable for counting number of cities visited.
distances=[];
order=[1];
visited = zeros(1, nCities);
visited(startingCity) = 1;
totalDistance=0;
count=2;
if startingCity > nCities
    disp("ERROR: Invalid starting city.")
else
    while i<nCities
        distances = distanceMatrix(startingCity,:);
        nextCity = nthLowestIndex(distances, count);
        if visited(nextCity) == 0
            totalDistance = totalDistance + distanceMatrix(currentCity,nextCity);
            currentCity=nextCity;
            order(end+1)=currentCity;
            visited(currentCity) = 1;
            i = i+1;
            count=3;
        else
            count=count+1;
        end
    end
    totalDistance = totalDistance + distanceMatrix(currentCity,startingCity);
end
order(end+1)=1;
disp('Order of cities visited: ')
disp(order)
fprintf("Shortest distance found via Nearest Neighbour algorithm: "+num2str(totalDistance)+"\n")
