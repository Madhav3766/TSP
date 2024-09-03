nStops = 12;
stopsLon = zeros(nStops,1); 
stopsLat = zeros(nStops,1); 
n = 1;
while (n <= nStops)
    xp = rand*1.5;
    yp = rand;
    stopsLon(n) = xp;
    stopsLat(n) = yp;
    n = n+1;
end

idxs = nchoosek(1:nStops,2);
dist = hypot(stopsLat(idxs(:,1)) - stopsLat(idxs(:,2)), stopsLon(idxs(:,1)) - stopsLon(idxs(:,2)));
lendist = length(dist);
matrix = zeros(nStops,nStops);
for i=1:lendist
    matrix(idxs(i,1),idxs(i,2)) = dist(i)*1000;
    matrix(idxs(i,2),idxs(i,1)) = dist(i)*1000;
end
writematrix(matrix, 'matrixDistances.csv');
