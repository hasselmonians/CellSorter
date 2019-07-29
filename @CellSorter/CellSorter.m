classdef CellSorter

properties

sset      % contains a statset structure
nClusters % how many clusters do you want?
nDims = 2 % how many dimensions do you want?
verbosity = true;
algorithm = 'umap';

end % properties

properties (SetAccess = Protected)

end % properties setaccess protected

methods

  function self = CellSorter()
    self.sset = statset;
    self.sset.Display = 'iter';
    self.sset.MaxIter = 100;
    self.sset.UseParallel = true;
  end % constructor

  function set.nClusters(self, value)
    assert(isinteger(value), 'nClusters must be an integer')
    assert(isscalar(value), 'nClusters must be a scalar')
    assert(value > 0, 'nClusters must be positive')
    self.nClusters = value;
  end

  function set.nDims(self, value)
    assert(isinteger(value), 'nDims must be an integer')
    assert(isscalar(value), 'nDims must be a scalar')
    assert(value > 0, 'nDims must be positive')
    self.nDims = value;
  end

end % methods

methods (Static)

end % static methods

end % classdef
