% batch function for use with RatCatcher
% collects the mean spike waveforms from a root object
% for a specified filename/filecode

function batchFunction(index, location, batchname, outfile, test)

  if ~test
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/RatCatcher'))
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/srinivas.gs_mtools'))
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/CMBHOME'))
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/CellSorter'))
  end

  % acquire the filename and filecode
  % the filecode should be the "cell number" as a 1x2 vector
  [filename, filecode] = RatCatcher.read(index, location, batchname);

  % load the data
  % expect a 1x1 Session object named "root"
  load(filename);
  root.cel = filecode;

  % initialize outputs
  waveform = NaN(50, 4);

  % acquire the waveform, which should be a 50x4 matrix in millivolts
  % the first index is over time steps, the second over channels in the tetrode
  try
    indx_cel = ismember(root.cells,root.cel,'rows'); %identify index of root.cel (filecode) in root.cells vector
    waveform = [root.user_def.waveform(indx_cel,1).mean;root.user_def.waveform(indx_cel,2).mean;root.user_def.waveform(indx_cel,3).mean;root.user_def.waveform(indx_cel,4).mean];
  catch
    % acquiring the waveform has failed
    % save NaNs instead
    output = [waveform NaN(size(waveform, 1), 1)];
    % save these data as a .csv file
    csvwrite(outfile, output);
    return
  end

  % channel with the strongest signal
  channel = findStrongestChannel(waveform);

  % compute the spike width
  % spike width is defined as difference
  % between the first maximum in the signal and the following minimum
  [~, peak_index] = max(waveform(:, channel));
  [~, spike_width] = min(waveform(peak_index:end, channel));
  spike_width = spike_width; % units of time-steps

  % compute the firing rate
  firing_rate = length(CMBHOME.Utils.ContinuizeEpochs(root.cel_ts)) / (root.ts(end) - root.ts(1));

  % create a combined output matrix
  % the first 50x4 block comprises the waveforms
  % the last column is NaN except for the first two elements
  % which are the spike width in ms and the firing rate in Hz
  output = [waveform NaN(size(waveform, 1), 1)];
  output(1, end) = spike_width;
  output(2, end) = firing_rate;
  output(3, end) = channel;

  % save these data as a .csv file
  csvwrite(outfile, output);

end % function
