%% Performs the cell sorting

% load the data from a local .mat file
load('Holger-CellSorter.mat')

% pre-process the data by removing failed data
failing = false(height(dataTable), 1);
for ii = 1:height(dataTable)
  failing(ii) = any(any(isnan(dataTable.waveforms{ii})));
end
dataTable  = dataTable(~failing, :);

% stack the waveforms and impute the data matrix
% X = zeros(height(dataTable), numel(dataTable.waveforms{1}));
for ii = 1:height(dataTable)
  % X(ii, :) = corelib.vectorise(dataTable.waveforms{ii});
  X(ii, :) = dataTable.waveforms{ii}(:, findStrongestChannel(dataTable.waveforms{ii}));
end

% instantiate the CellSorter object
cs = CellSorter;
cs.algorithm = 'umap';

% perform dimensionality reduction and clustering
Y = cs.dimred(X);
labels = cs.kcluster(Y);

% visualize the results
figure; hold on
scatter(Y(labels == 1, 1), Y(labels == 1, 2))
scatter(Y(labels == 2, 1), Y(labels == 2, 2))
title('Holger-CellSorter UMAP dim-red / k-means clustering')
xlabel('dimension 1 (a.u.)')
ylabel('dimension 2 (a.u.)')
figlib.pretty()

% add the labels to the data table
dataTable.labels = labels;

% save the results by overwriting the existing .mat file
save('Holger-CellSorter.mat', 'dataTable', 'r', 'failing')
