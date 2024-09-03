function thirdLowestIndex = nthLowestIndex(arr, n)
    sortedArr = sort(arr); % Sort unique values

    % Find the index of the third lowest value
    thirdLowestValue = sortedArr(n);
    thirdLowestIndex = find(arr == thirdLowestValue, 1);
end
