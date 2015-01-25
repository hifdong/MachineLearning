function [idx, Center_return, totsumD, iter] = kmodes_classical(X, k)
 %matlab version:7.13.0.564
%程序说明：k-modes聚类算法主程序
%Input:  'X' - dataset, 'k' -cluster number .
%Output: 'idx' -class index , 'Center_return' -class center , 
%        'totsumD' -total distance,'iter' -iteration times .

global m;     %number of objects in each class
global maxit; %max iteration times
maxit = 1000;

[n, p] = size(X);              %n:rows of dataset, p:columns of dataset
totsumDBest = Inf;
Center = InitStand(X, k);      %get init class center
D = distfun2(X, Center);
 
[d, idx] = min(D, [], 2);           
m = accumarray(idx,1,[k,1]);  %number of objects in each class
w = zeros(n, k);              %partition matrix
index = sub2ind(size(w), [1:size(w, 1)], idx');
w(index) = 1;
[idx, w, converged, iter] = batchUpdate(X, k, idx, w, Center);     
                  
if ~converged
  warning('FailedToConverge');
end
        
% Calculate cluster-wise sums of distances
nonempties = find(m>0);
D(:,nonempties) = distfun2(X, Center(nonempties,:));

d = D((idx-1)*n + (1:n)');
sumD = accumarray(idx,d,[k,1]);
totsumD = sum(sumD);
 
% Save the best solution so far
if totsumD < totsumDBest
  totsumDBest = totsumD;
  idxBest = idx;
  Centerbest = Center;
  sumDBest = sumD;
  if nargout > 3
    Dbest = D;
  end
end

% Return the best solution
idx = idxBest;
Center_return = Centerbest;
sumD = sumDBest;
if nargout > 3
    D = Dbest;
end

end
%------------------------------------------------------------------
function [idx, w, converged, iter] = batchUpdate(X, k, idx, w, Center)
%Input: dataset X,cluster number k, class index idx, partition matrix w,
%class center Center;
%Output: class index idx, partition matrix w, converged flag converged,
%iteration number iter
global m;
global maxit;
[n, p] = size(X); 
% Every point moved, every cluster will need an update
%  moValueed = 1:n; 
changed = 1:k;
prew = zeros(n, k);
previdx = zeros(n,1);
prevtotsumD = Inf;
iter = 0;
converged = false;
while true
      iter = iter + 1;
      % Calculate the new cluster centroids and counts, and update the
      % distance from every point to those new cluster centroids
      [Center(changed,:), m(changed)] = GmodesSKM(X, idx, changed);
      D(:, changed) = distfun2(X, Center(changed,:));       
      % Deal with clusters that have just lost all their members
      empties = changed(m(changed) == 0);
      if ~isempty(empties)
          warning('EmptyCluster');                     
          for i = empties
              d = D((idx-1)*n + (1:n)'); % use newly updated distances
              % Find the point furthest away from its current cluster.
              % Take that point out of its cluster and use it to create
              % a new singleton cluster to replace the empty one.
              [~, lonely] = max(d);
              from = idx(lonely); % taking from this cluster
              if m(from) < 2
                 % In the very unusual event that the cluster had only
                 % one member, pick any other non-singleton point.
                 from = find(m>1,1,'first');
                 lonely = find(idx==from,1,'first');
              end
              Center(i,:) = X(lonely,:);
               m(i) = 1;
               idx(lonely) = i;
               w(lonely) = i;
               w(lonely, i) = 1;
               D(:,i) = distfun2(X, Center(i,:));
               % Update clusters from which points are taken
               [Center(from,:), m(from)] = GmodesSKM(X, idx, from);
               D(:,from) = distfun2(X, Center(from,:));
               changed = unique([changed from]);
          end
     end    
     % Compute the total sum of distances for the current configuration.
     totsumD = sum(D((idx-1)*n + (1:n)'));   
     % Test for a cycle: if objective is not decreased, back out
     % the last step and move on to the single update phase
     if prevtotsumD <= totsumD
         idx = previdx;
         w = prew;
         [Center(changed,:), m(changed)] = GmodesSKM(X, idx, changed);
         iter = iter - 1;
          break;
      end
           
      if iter >= maxit
           break;
      end
            
      % Determine closest cluster for each point and reassign points to clusters
      previdx = idx;
      prew = w;
      prevtotsumD = totsumD;
      [d, nidx] = min(D, [], 2);
      index = sub2ind(size(w), [1:size(w, 1)], nidx');
      wx = zeros(n, k);
      wx(index) = 1;
      % Determine which points moved
      moved = find(nidx ~= previdx);
      if ~isempty(moved)
           % Resolve ties in favor of not moving
            moved = moved(D((previdx(moved)-1)*n + moved) > d(moved));  
      end
      if isempty(moved)
          converged = true;
           break;
      end
      w(moved, :) = zeros(size(moved, 1), k);
      w(moved, :)= wx(moved, :);
      idx(moved) = nidx(moved);   
      % Find clusters that gained or lost members
      changed = unique([idx(moved); previdx(moved)])';     
   end 
end 


 