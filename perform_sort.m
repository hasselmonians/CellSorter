%% Performs the cell sorting

% load the data from a local .mat file
load('Holger-CellSorter.mat')

% pre-process the data by removing failed data
dataTable  = dataTable(~failing, :);

% stack the waveforms and impute the data matrix
X = zeros(height(dataTable), numel(dataTable.waveforms{1}));
for ii = 1:height(dataTable)
  X(ii, :) = corelib.vectorise(dataTable.waveforms{ii});
end

% instantiate the CellSorter object
cs = CellSorter;
cs.algorithm = 'tsne';

Y = cs.dimred(X);
labels = cs.kcluster(Y);
