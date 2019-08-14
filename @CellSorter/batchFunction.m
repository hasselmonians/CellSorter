% batch function for use with RatCatcher
% collects the mean spike waveforms from a root object
% for a specified filename/filecode

function batchFunction(index, location, batchname, outfile, test)

  if ~test
    addpath(genpath('/projectnb/hasselmogrp/hoyland/RatCatcher'))
    addpath(genpath('/projectnb/hasselmogrp/hoyland/srinivas.gs_mtools'))
    addpath(genpath('/projectnb/hasselmogrp/hoyland/CMBHOME'))
    addpath(genpath('/projectnb/hasselmogrp/hoyland/CellSorter'))
  end

  % acquire the filename and filecode
  % the filecode should be the "cell number" as a 1x2 vector
  [filename, filecode] = RatCatcher.read(index, location, batchname);

  % load the data
  % expect a 1x1 Session object named "root"
  load(filename);

  % acquire the waveform, which should be a 50x4 matrix in millivolts
  % the first index is over time steps, the second over channels in the tetrode
  waveform = [root.user_def.waveform(filecode(1), :).mean];

  % save these data as a .csv file
  csvwrite(outfile, waveform);

end % function
