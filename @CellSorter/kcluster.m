% performs k-means clustering on a 2-D manifold

% Arguments:
%   Y: the data as an N x 2 matrix
% Outputs:
%

function labels = kcluster(self, Y)

  % perform k-means clustering into three classes
  labels = kmeans(Y, self.nClusters, 'Distance', 'sqeuclidean', 'Start', 'plus', 'Replicates', 3, 'EmptyAction', 'error', 'Options', self.sset);

end % function
