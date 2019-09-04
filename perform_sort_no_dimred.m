%% Performs the cell sorting
% does not use the waveform


%% Pre-processing

if exist('Holger-CellSorter-processed.mat', 'file')
  load('Holger-CellSorter-processed.mat')
else

  % load the data from a local .mat file
  load('Holger-CellSorter.mat')

  % pre-process the data by removing failed data
  % failed data is anything including NaNs in the waveforms
  failing = false(height(dataTable), 1);
  for ii = 1:height(dataTable)
    failing(ii) = any(any(isnan(dataTable.waveforms{ii})));
  end

  % remove failing data
  dataTable  = dataTable(~failing, :);
  % add the filenames and filecodes
  r.filenames = r.filenames(~failing);
  r.filecodes = r.filecodes(~failing);
  dataTable  = r.stitch(dataTable);

  % stack the waveforms and impute the data matrix
  % use the waveform with the highest spike height out of each channel
  channels = zeros(height(dataTable), 1);
  for ii = height(dataTable):-1:1
    channels(ii) = findStrongestChannel(dataTable.waveforms{ii});
  end

  %% Perform the cell sorting procedure

  % instantiate the CellSorter object
  cs = CellSorter;
  cs.algorithm = 'umap';

  %% Update the data table and visualize results

  % perform dimensionality reduction and clustering
  Y = [dataTable.spike_width, dataTable.firing_rate];
  labels = cs.kcluster(Y);

  % add the strongest channel to the data table
  dataTable.channels = channels;

  % add the labels to the data table
  dataTable.labels = labels;

  % save the results by overwriting the existing .mat file
  save('Holger-CellSorter-processed.mat', 'dataTable', 'r', 'Y')
end

% plot the reduced data, colored by cluster
figure; hold on
scatter(Y(dataTable.labels == 1, 1), Y(dataTable.labels == 1, 2))
scatter(Y(dataTable.labels == 2, 1), Y(dataTable.labels == 2, 2))
title('Holger-CellSorter UMAP dim-red / k-means clustering')
xlabel('dimension 1 (a.u.)')
ylabel('dimension 2 (a.u.)')
figlib.pretty()

% plot the waveforms, grouped by cluster
figure;
time_points = (1/50) * 1:length(dataTable.waveforms{1}); % s
for qq = 1:2
  ax(qq) = subplot(1, 2, qq); hold on;
  indices = find(dataTable.labels == qq);
  for ii = 1:length(indices)
    plot(time_points, dataTable.waveforms{indices(ii)}(:, dataTable.channels(indices(ii))));
  end
  xlabel('time (s)')
  ylabel('voltage deflection (a.u.)')
  title(['class ' num2str(qq) ' waveforms'])
end

linkaxes(ax, 'xy')
figlib.pretty('LineWidth', 1, 'PlotBuffer', 0.1);


return
