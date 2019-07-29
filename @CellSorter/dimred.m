% dimensionally reduces X into Y
% TODO: allow umap parameters to be changed from this function

% Arguments:
%   X: an M x N matrix
%     M is the number of observations
%     N is the number of features
%   varargin: optional arguments which take the form of Name-Value pairs

function Y = dimred(X, varargin)

  % default options
  options.Algorithm = 'umap';
  options.verbosity = true;

  % does user just want to know what options are available?
  if nargout && ~nargin
  	varargout{1} = options;
      return
  end

  % parse options
  options = corelib.parseNameValueArguments(options, varargin{:});

  % behavior is determined by which algorithm is chosen
  switch lower(options.Algorithm)

  case 'umap'
    corelib.verb(options.verbosity, 'INFO', ['using ' 'UMAP' ' algorithm'])
    u = umap;
    Y = u.fit(X);

  case 'fit-sne'
    corelib.verb(options.verbosity, 'INFO', ['using ' 'FIt-SNE' ' algorithm'])
    Y = fast_tsne(X);

  case 'pca'
    corelib.verb(options.verbosity, 'INFO', ['using ' 'PCA' ' algorithm'])
    Y = pca(X');

  otherwise
    error('unknown algorithm')
  end

end % function
