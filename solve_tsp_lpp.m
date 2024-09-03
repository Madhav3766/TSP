% IMPORTANT: Run the file matirxGenerator_forLPP.m file before running this.
matrixData = csvread('matrixDistances.csv');
[x1,lent] = size(matrixData);
dist1=zeros(lent);
idxs = nchoosek(1:lent,2);
for i=1:lent
    dist1(i) = matrixData(idxs(i,1),idxs(i,2));
end

G = graph(idxs(:,1),idxs(:,2));
figure;
hGraph = plot(G,'XData',stopsLon,'YData',stopsLat,'LineStyle','none','NodeLabel',{});
set(gca,'xtick',[]);
set(gca,'ytick',[])

%Constraints
Aeq = spalloc(nStops,length(idxs),nStops*(nStops-1)); % Using spalloc to save space
for ii = 1:nStops
    whichIdxs = (idxs == ii); % Find the trips that include stop ii
    whichIdxs = sparse(sum(whichIdxs,2)); % Include trips where ii is at either end
    Aeq(ii,:) = whichIdxs'; % Include in the constraint matrix
end
beq = 2*ones(nStops,1);

%Binary bounds
intcon = 1:lendist;
lowerB = zeros(lendist,1);
upperB = ones(lendist,1);

opts = optimoptions('intlinprog','Display','off');
[x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,[],[],Aeq,beq,lowerB,upperB,opts);
%intlinprog used as a solver of lpps.

x_tsp = logical(round(x_tsp));
Gsol = graph(idxs(x_tsp,1),idxs(x_tsp,2),[],numnodes(G));
% Gsol = graph(idxs(x_tsp,1),idxs(x_tsp,2)); % Also works in most cases

tourIdxs = conncomp(Gsol);
numtours = max(tourIdxs); % number of subtours


%Removing subtours by adding more constraints
A = spalloc(0,lendist,0); 
b = [];
while numtours > 1
    % Add the subtour constraints
    b = [b;zeros(numtours,1)]; % allocate b
    A = [A;spalloc(numtours,lendist,nStops)];
    for ii = 1:numtours
        rowIdx = size(A,1) + 1; % Counter for indexing
        subTourIdx = find(tourIdxs == ii); % Extract the current subtour

        variations = nchoosek(1:length(subTourIdx),2);
        for jj = 1:length(variations)
            whichVar = (sum(idxs==subTourIdx(variations(jj,1)),2)) & (sum(idxs==subTourIdx(variations(jj,2)),2));
            A(rowIdx,whichVar) = 1;
        end
        b(rowIdx) = length(subTourIdx) - 1; % One less trip than subtour stops
    end

    hGraph.LineStyle = 'none'; % Remove the previous highlighted path
    highlight(hGraph,Gsol,'LineStyle','-')
    drawnow

    % Try to optimize again
    [x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,A,b,Aeq,beq,lowerB,upperB,opts);
    x_tsp = logical(round(x_tsp));
    Gsol = graph(idxs(x_tsp,1),idxs(x_tsp,2),[],numnodes(G));
    
    % Visualize result
    tourIdxs = conncomp(Gsol);
    numtours = max(tourIdxs); % number of subtours
end

hGraph.LineStyle = 'none'; % Remove the previous highlighted path
highlight(hGraph,Gsol,'LineStyle','-')
drawnow
title('Optimised path through the locations');
hold off