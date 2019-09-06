%% Load the data

load('data/Holger-CellSorter-processed.mat');

%% Plot the reduced data, colored by cluster

figure; hold on
scatter(Y(dataTable.labels == 1, 1), Y(dataTable.labels == 1, 2))
scatter(Y(dataTable.labels == 2, 1), Y(dataTable.labels == 2, 2))
title('Holger-CellSorter UMAP dim-red / k-means clustering')
xlabel('dimension 1 (a.u.)')
ylabel('dimension 2 (a.u.)')
figlib.pretty()

%% Plot the waveforms, grouped by cluster

% cell array containing matrices of variable size
best_waveforms = cell(2,1);
for qq = 1:2
  % find linear indices to cells classified into qq
  indices = find(dataTable.labels == qq);
  % collect the best-channel waveforms into a large matrix
  % the first dimension of the matrix is the number of cells classified into that class
  % the second dimension is the length of the waveforms
  best_waveforms{qq} = NaN(length(indices), size(dataTable.waveforms{1}, 1));
  for ii = 1:length(indices)
    best_waveforms{qq}(ii, :) = dataTable.waveforms{indices(ii)}(:, dataTable.channels(indices(ii)));
  end
end

figure;
time_points = 1:length(dataTable.waveforms{1}); % a.u.
for qq = 1:2
  ax(qq) = subplot(1, 2, qq); hold on;
  cmap = colormaps.linspecer(size(best_waveforms{qq}, 1));
  for ii = 1:size(best_waveforms{qq}, 1)
    plot(ax(qq), time_points, best_waveforms{qq}(ii, :), 'Color', cmap(ii, :));
  end
  xlabel('time (s)')
  ylabel('voltage deflection (a.u.)')
  title(['class ' num2str(qq) ' waveforms'])
end

linkaxes(ax, 'xy')
figlib.pretty('LineWidth', 1, 'PlotBuffer', 0.1);

%% Plot the waveforms, grouped by cluster
% shaded by standard deviation

figure;
time_points = 1:length(dataTable.waveforms{1}); % a.u.
for qq = 1:2
  ax(qq) = subplot(1, 2, qq); hold on;
  plotlib.errorShade(time_points, mean(best_waveforms{qq}), std(best_waveforms{qq}));
  xlabel('time (s)')
  ylabel('voltage deflection (a.u.)')
  title(['class ' num2str(qq) ' waveforms'])
end

linkaxes(ax, 'xy')
figlib.pretty('LineWidth', 1, 'PlotBuffer', 0.1);
