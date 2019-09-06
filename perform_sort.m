%% Performs the cell sorting


%% Pre-processing

if exist('data/Holger-CellSorter-processed.mat', 'file')
  load('data/Holger-CellSorter-processed.mat')
else

  % load the data from a local .mat file
  load('data/Holger-CellSorter.mat')

  % pre-process the data by removing failed data
  failing = false(height(dataTable), 1);
  for ii = 1:height(dataTable)
    failing(ii) = any(any(isnan(dataTable.waveforms{ii})));
  end
  dataTable  = dataTable(~failing, :);
  % add the filenames and filecodes
  r.filenames = r.filenames(~failing);
  r.filecodes = r.filecodes(~failing, :);
  dataTable  = r.stitch(dataTable);

  % stack the waveforms and impute the data matrix
  % use the waveform with the highest spike height out of each channel
  channels = zeros(height(dataTable), 1);
  for ii = height(dataTable):-1:1
    % X(ii, :) = corelib.vectorise(dataTable.waveforms{ii});
    channels(ii) = findStrongestChannel(dataTable.waveforms{ii});
    X(ii, :) = dataTable.waveforms{ii}(:, channels(ii));
  end

  % rescale within each time-series, to within the box [-1, 1]
  for ii = 1:size(X, 1)
    X(ii, :) = rescale(X(ii, :), -1, 1);
  end

  % add the firing rate as a feature
  % X = [X dataTable.firing_rate];

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

  % save the results by overwriting the existing .mat file
  save('data/Holger-CellSorter-processed.mat', 'dataTable', 'r', 'Y')
end

return
