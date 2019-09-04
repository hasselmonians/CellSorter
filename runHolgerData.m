r = RatCatcher;

r.expID = 'Holger';
r.remotepath = '/projectnb/hasselmogrp/hoyland/CellSorter/cluster/';
r.localpath = '/mnt/hasselmogrp/hoyland/CellSorter/cluster/';
r.protocol = 'CellSorter';
r.project = 'hasselmogrp';
r.verbose = true;

return

% batch files
r = r.batchify;

% NOTE: run the 'qsub' command on the cluster now (see output in MATLAB command prompt)

return

% NOTE: once the cluster finishes, run the following commands

% gather files
r.validate;
dataTable = r.gather;
save('Holger-CellSorter.mat', 'dataTable', 'r')
% dataTable = r.stitch(dataTable);

return

% perform clustering

X = NaN(height(dataTable), numel(dataTable.waveforms{1}));
for ii = 1:height(dataTable)
  X(ii, :) = dataTable.waveforms{ii}(:);
end

cs = CellSorter;
cs.nClusters = 2;
cs.nDims = 2;

Y = cs.dimred(dataTable.waveforms);
labels = cs.kcluster(Y);


figure; hold on;
scatter(Y(labels == 1), 1), Y(labels == 1, 2);
scatter(Y(labels == 2), 1), Y(labels == 2, 2);
