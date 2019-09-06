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
