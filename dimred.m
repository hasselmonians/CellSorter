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

  % does user just want to know what options are available?
  if nargout && ~nargin
  	varargout{1} = options;
      return
  end

  % parse options
  corelib.parseNameValueArguments(options, varargin{:});

  % behavior is determined by which algorithm is chosen
  switch lower(options.Algorithm)

  case 'umap'
    u = umap;
    Y = u.fit(X);

  case 'FIt-SNE'
    Y = fast_tsne(X);

  case 'pca'
    Y = pca(X);

  otherwise
    error('unknown algorithm')
  end

end % function
