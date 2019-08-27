function channel_index = findStrongestChannel(x)
  % x is a 50x4 matrix, where the first index is the timeseries and the second is the channel number

  [~, channel_index] = max(max(x));

end % function
