% dimensionally reduces X into Y
% TODO: allow umap parameters to be changed from this function

% Arguments:
%   X: an M x N matrix
%     M is the number of observations
%     N is the number of features

function Y = dimred(self, X)

  % behavior is determined by which algorithm is chosen
  switch lower(self.algorithm)

  case 'umap'
    corelib.verb(self.verbosity, 'INFO', ['using ' 'UMAP' ' algorithm'])
    u = umap;
    Y = u.fit(X);

  case 'fit-sne'
    corelib.verb(self.verbosity, 'INFO', ['using ' 'FIt-SNE' ' algorithm'])
    Y = fast_tsne(X);

  case 'pca'
    corelib.verb(self.verbosity, 'INFO', ['using ' 'PCA' ' algorithm'])
    Y = pca(X');

  case 'tsne'
    corelib.verb(self.verbosity, 'INFO', ['using ' 't-SNE' 'algorithm'])
    Y = tsne(X);

  otherwise
    error('unknown algorithm')
  end

end % function
