% takes Fisher's iris dataset,
% performs dimensionality-reduction
% then clusters using k-means and plots the results

% load data
load fisheriris
% meas and species

% instantiate the object
cs = CellSorter;

% generate a figure
figure;
C = colormaps.linspecer(3);

for ii = 3:-1:1
  ax(ii) = subplot(1, 3, ii); hold on;
  axis square
end

% perform the dimensionality reduction and clustering
% once for each algorithm
alg = {'UMAP', 'FIt-SNE', 'PCA'};

for ii = 1:length(alg)
  cs.algorithm = alg{ii};
  Y = cs.dimred(meas);
  labels = cs.kcluster(Y);
  plot(ax(ii), Y(labels == 1, 1), Y(labels == 1, 2), 'o', 'Color', C(1, :))
  plot(ax(ii), Y(labels == 2, 1), Y(labels == 2, 2), 'o', 'Color', C(2, :))
  plot(ax(ii), Y(labels == 3, 1), Y(labels == 3, 2), 'o', 'Color', C(3, :))
  title(ax(ii), alg{ii})
end

figlib.pretty('PlotBuffer', 0.1);
