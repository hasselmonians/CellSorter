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
  root.cel = filecode;

  % acquire the waveform, which should be a 50x4 matrix in millivolts
  % the first index is over time steps, the second over channels in the tetrode
  try
    waveform = [root.user_def.waveform(filecode(1), :).mean];
  catch
    waveform = NaN(50, 4);
    % save these data as a .csv file
    csvwrite(outfile, [spike_width firing_rate]);
    return
  end

  % channel with the strongest signal
  channel = findStrongestChannel(waveform);

  % compute the spike width
  [peak, peak_index] = max(waveform(:, channel));
  [minimum, min_index] = min(waveform(:, channel));
  spike_width = min_index - peak_index;
  spike_width = spike_width./ root.fs_video; %convert time to msec

  % compute the firing rate
  firing_rate = length(CMBHOME.Utils.ContinuizeEpochs(root.cel_ts)) / (root.ts(end) - root.ts(1)) * root.fs_video;

  % create a combined output matrix
  % the first 50x4 block comprises the waveforms
  % the last column is NaN except for the first two elements
  % which are the spike width in ms and the firing rate in Hz
  output = [waveform NaN(size(waveform, 1), 1)];
  output(1, end) = spike_width;
  output(2, end) = firing_rate;

  % save these data as a .csv file
  csvwrite(outfile, output);

end % function
