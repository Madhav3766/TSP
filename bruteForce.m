function [optimalRoute, minimalDistance] = bruteForce(distanceMatrix)
    n = size(distanceMatrix, 1);
    routes = perms(2:n);
    minimalDistance = inf;
    optimalRoute = [];
    
    for i = 1:size(routes, 1)
        % Route 'i' including return trip to the starting city
        currentRoute = [1, routes(i,:), 1];
        
        % Calculate distance of route 'i'
        currentDistance = 0;
        for j = 1:length(currentRoute)-1
            currentDistance = currentDistance + distanceMatrix(currentRoute(j), currentRoute(j+1));
        end
        
        % Update optimal route if current distance is lower
        if currentDistance < minimalDistance
            minimalDistance = currentDistance;
            optimalRoute = currentRoute;
        end
    end
end
