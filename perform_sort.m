%% Performs the cell sorting


%% Pre-processing

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
channels = zeros(height(dataTable), 1);
for ii = 1:height(dataTable)
  % X(ii, :) = corelib.vectorise(dataTable.waveforms{ii});
  channels(ii) = findStrongestChannel(dataTable.waveforms{ii});
  X(ii, :) = dataTable.waveforms{ii}(:, channels(ii));
end

%% Perform the cell sorting procedure

% instantiate the CellSorter object
cs = CellSorter;
cs.algorithm = 'umap';

%% Update the data table and visualize results

% perform dimensionality reduction and clustering
Y = cs.dimred(X);
labels = cs.kcluster(Y);

% add the strongest channel to the data table
dataTable.channels = channels;

% add the labels to the data table
dataTable.labels = labels;

% visualize the results
figure; hold on
scatter(Y(labels == 1, 1), Y(labels == 1, 2))
scatter(Y(labels == 2, 1), Y(labels == 2, 2))
title('Holger-CellSorter UMAP dim-red / k-means clustering')
xlabel('dimension 1 (a.u.)')
ylabel('dimension 2 (a.u.)')
figlib.pretty()

return
% save the results by overwriting the existing .mat file
save('Holger-CellSorter.mat', 'dataTable', 'r', 'failing')
