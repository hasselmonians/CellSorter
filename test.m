% takes Fisher's iris dataset,
% performs dimensionality-reduction
% then clusters using k-means and plots the results

load fisheriris
X = meas';

% perform dimensionality-reduction with umap
u = umap;
Y = u.fit(X);

% define options for k-means algorithm
sset = statset;
sset.Display = 'iter';
sset.MaxIter = 100;
sset.UseParallel = true;

% perform k-means clustering into three classes
[idx, c, sumd, d] = kmeans(Y, 3, 'Distance', 'sqeuclidean', 'Start', 'plus', 'Replicates', 3, 'EmptyAction', 'error', 'Options', sset);

% visualize the results
figure; hold on;
C = colormaps.linspecer(3);
plot(Y(idx == 1, 1), Y(idx == 1, 2), 'o', 'Color', C(1, :))
plot(Y(idx == 2, 1), Y(idx == 2, 2), 'o', 'Color', C(2, :))
plot(Y(idx == 3, 1), Y(idx == 3, 2), 'o', 'Color', C(3, :))

figlib.pretty('PlotBuffer', 0.2);

% perform dimensionality-reduction with FIt-SNE
Y = fast_tsne(X');

% define options for k-means algorithm
sset = statset;
sset.Display = 'iter';
sset.MaxIter = 100;
sset.UseParallel = true;

% perform k-means clustering into three classes
[idx, c, sumd, d] = kmeans(Y, 3, 'Distance', 'sqeuclidean', 'Start', 'plus', 'Replicates', 3, 'EmptyAction', 'error', 'Options', sset);

% visualize the results
figure; hold on;
C = colormaps.linspecer(3);
plot(Y(idx == 1, 1), Y(idx == 1, 2), 'o', 'Color', C(1, :))
plot(Y(idx == 2, 1), Y(idx == 2, 2), 'o', 'Color', C(2, :))
plot(Y(idx == 3, 1), Y(idx == 3, 2), 'o', 'Color', C(3, :))

figlib.pretty('PlotBuffer', 0.2);

% perform dimensionality-reduction with umap
Y = pca(X);

% define options for k-means algorithm
sset = statset;
sset.Display = 'iter';
sset.MaxIter = 100;
sset.UseParallel = true;

% perform k-means clustering into three classes
[idx, c, sumd, d] = kmeans(Y, 3, 'Distance', 'sqeuclidean', 'Start', 'plus', 'Replicates', 3, 'EmptyAction', 'error', 'Options', sset);

% visualize the results
figure; hold on;
C = colormaps.linspecer(3);
plot(Y(idx == 1, 1), Y(idx == 1, 2), 'o', 'Color', C(1, :))
plot(Y(idx == 2, 1), Y(idx == 2, 2), 'o', 'Color', C(2, :))
plot(Y(idx == 3, 1), Y(idx == 3, 2), 'o', 'Color', C(3, :))

figlib.pretty('PlotBuffer', 0.2);
