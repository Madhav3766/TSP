function [tour, length] = clarke_wright (data)
%Do not run this, it is a function.
%Run clarkeRunner.m
n=size(data,1); 
center = mean(data,1);
hub = knnsearch(data,center,'k',1);%Centre point for starting
distances = calculateDistances(data);
savings = zeros(n);

for i=1:n    
    if i==hub
        continue;
    end
        savings(i,(i+1):n)=distances(i,hub)+distances(hub,(i+1):n)-distances(i,(i+1):n);
end

minParent = 1:n;
[~,si] = sort(savings(:),'descend');
si=si(1:(end/2));

Vh = zeros(1,n);
Vh(hub) = 1;
VhCount = n-1;
degrees = zeros(1,n);

selectedIdx = 1;  % edge to try for insertion

tour = zeros(n,2);
curEdgeCount = 1;

while VhCount>2
    i = mod(si(selectedIdx)-1,n)+1;
    j = floor((si(selectedIdx)-1)/n)+1;

    if Vh(i)==0 && Vh(j)==0 && (minParent(i)~=minParent(j)) && i~=j && i~=hub && j~=hub     % always all degrees are <= 2, so it is not required to check them
%     if (minParent(i)~=minParent(j)) && isempty(find(degrees>2, 1)) && i~=j && i~=hub && j~=hub && Vh(i)==0 && Vh(j)==0
        degrees(i)=degrees(i)+1;
        degrees(j)=degrees(j)+1;
        tour(curEdgeCount,:) = [i,j];

        if minParent(i)<minParent(j)
            minParent(minParent==minParent(j))=minParent(i);
        else
            minParent(minParent==minParent(i))=minParent(j);            
        end


        curEdgeCount = curEdgeCount + 1;

        if degrees(i)==2
            Vh(i) = 1;
            VhCount = VhCount - 1;
        end

        if degrees(j)==2
            Vh(j) = 1;
            VhCount = VhCount - 1;
        end
    end
    selectedIdx = selectedIdx + 1;

end

remain = find(Vh==0);
n1=remain(1);
n2=remain(2);

tour(curEdgeCount,:) = [hub n1];
curEdgeCount = curEdgeCount + 1;

tour(curEdgeCount,:) = [hub n2];

tour = stitchTour(tour);
tour=tour(:,1)';
length=distances(tour(end),tour(1));
for i=1:n-1  % how can I vectorize these lines?
    length=length+distances(tour(i),tour(i+1));
end
end


function tour = stitchTour(t) % uniforms the tour [a b; b c; c d; d e;.... ]

n=size(t,1);

[~,nIdx] = sort(t(:,1));
t=t(nIdx,:);

tour(1,:) = t(1,:);
t(1,:) = -t(1,:);
lastNodeIdx = tour(1,2);

for i=2:n
    nextEdgeIdx = find(t(:,1)==lastNodeIdx,1);
    if ~isempty(nextEdgeIdx)
        tour(i,:) = t(nextEdgeIdx,:);
        t(nextEdgeIdx,:)=-t(nextEdgeIdx,:);
    else
        nextEdgeIdx = find(t(:,2)==lastNodeIdx,1);
        tour(i,:) = t(nextEdgeIdx,[2 1]);
        t(nextEdgeIdx,:)=-t(nextEdgeIdx,:);
    end
    lastNodeIdx = tour(i,2);
end


end
