r = RatCatcher;

r.expID = 'Holger';
r.remotepath = '/projectnb/hasselmogrp/ahoyland/CellSorter/cluster/';
r.localpath = '/mnt/hasselmogrp/ahoyland/CellSorter/cluster/';
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
r = r.validate;
dataTable = r.gather;
save('data/Holger-CellSorter.mat', 'dataTable', 'r')
% dataTable = r.stitch(dataTable);
