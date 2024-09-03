function distances = calculateDistances(data)
    n = size(data, 1);
    distances = zeros(n, n);

    for i = 1:n
        for j = 1:n
            distances(i, j) = sqrt((data(i, 1) - data(j, 1))^2 + (data(i, 2) - data(j, 2))^2);
        end
    end
end
