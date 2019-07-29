% takes Fisher's iris dataset,
% performs dimensionality-reduction
% then clusters using k-means and plots the results

% load data
load fisheriris
% meas and species

% generate a figure
figure;
C = colormaps.linspecer(3);

for ii = 3:-1:1
  subplot(1, 3, ii);
  axis square
end

% perform the dimensionality reduction and clustering
% once for each algorithm
alg = {'UMAP', 'FIt-SNE', 'PCA'};

for ii = 1:length(alg)
  labels = kcluster(dimred(meas, 'Algorithm', alg{ii}), 2);
  plot(ax(ii), Y(idx == 1, 1), Y(idx == 1, 2), 'o', 'Color', C(1, :))
  plot(ax(ii), Y(idx == 2, 1), Y(idx == 2, 2), 'o', 'Color', C(2, :))
  plot(ax(ii), Y(idx == 3, 1), Y(idx == 3, 2), 'o', 'Color', C(3, :))
  title(ax(ii), alg{ii})
end

figlib.pretty('PlotBuffer', 0.1);
