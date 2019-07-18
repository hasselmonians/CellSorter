% performs k-means clustering on a 2-D manifold

% Arguments:
%   Y: the data as an N x 2 matrix
%   k: the number of clusters to make
% Outputs:
%

function labels = kcluster(Y, k)

  sset = statset;
  sset.Display = 'iter';
  sset.MaxIter = 100;
  sset.UseParallel = true;

  % perform k-means clustering into three classes
  labels = kmeans(Y, k, 'Distance', 'sqeuclidean', 'Start', 'plus', 'Replicates', 3, 'EmptyAction', 'error', 'Options', sset);

end % function
