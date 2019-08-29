% load the data from a local .mat file
load('Holger-CellSorter.mat')

% pre-process the data by removing failed data
failing = false(height(dataTable), 1);
for ii = 1:height(dataTable)
  failing(ii) = any(any(isnan(dataTable.waveforms{ii})));
end
dataTable  = dataTable(~failing, :); % results in a smaller data table

% stack the waveforms and impute the data matrix
% use the waveform with the highest spike height out of each channel
channels = zeros(height(dataTable), 1);
for ii = height(dataTable):-1:1
  % X(ii, :) = corelib.vectorise(dataTable.waveforms{ii});
  channels(ii) = findStrongestChannel(dataTable.waveforms{ii});
  X(ii, :) = dataTable.waveforms{ii}(:, channels(ii));
end

% compute the spike width and the firing rate
spike_width = NaN(height(dataTable), 1);

for ii = 1:height(dataTable)
  [peak, peak_index] = max(dataTable.waveform{ii}(:, dataTable.channels(ii)));
  [minimum, min_index] = min(dataTable.waveform{ii}(:, dataTable.channels(ii)));
  spike_width(ii) = min_index - peak_index;
  spike_width(ii) = spike_width(ii)./48; %convert time to msec
end

% compute the firing rate
firing_rate = NaN(height(dataTable), 1);

for ii = 1:height(dataTable)
  corelib.textbar(ii, height(dataTable))
  load(strrep(dataTable.filenames{ii}, 'projectnb', 'mnt'));
  root.cel = dataTable.filecodes(ii, :);
  firing_rate(ii) = length(CMBHOME.Utils.ContinuizeEpochs(root.cel_ts)) / (root.ts(end) - root.ts(1)) * root.fs_video;
end

dataTable.spike_width = spike_width;
dataTable.firing_rate = firing_rate;

save('Holger-CellSorter-processed-no-dimred.mat', 'dataTable', 'r', 'failing');
