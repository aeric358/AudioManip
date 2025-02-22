function helperPlotMultiChannelAudio(audioFile, channels, timeRange)
%HELPERPLOTMULTICHANNELAUDIO Visualizes specific channels of an audio file.
%
%   helperPlotMultiChannelAudio(audioFile) loads and plots **all** channels.
%
%   helperPlotMultiChannelAudio(audioFile, channels) selects specific channels.
%
%   helperPlotMultiChannelAudio(audioFile, channels, timeRange) limits the time range.
%
%   - `audioFile`: Path to the audio file (string).
%   - `channels`: Vector of channel numbers (e.g., `[1, 3, 5]`).
%   - `timeRange`: [start_time, end_time] in seconds.

arguments
    audioFile (1,:) char {mustBeFile}
    channels (1,:) double {mustBePositive} = [] % Default: all channels
    timeRange (1,2) double {mustBeNonnegative} = [0, inf] % Default: full length
end

%%%% Load Audio Files  %%%%
[y, Fs] = audioread(audioFile);
[numSamples, numChannels] = size(y);
t = (0:numSamples-1) / Fs; % Time vector

%%%% Channel Selection  %%%%
if isempty(channels)
    channels = 1:numChannels; % Default: all channels
else
    channels = channels(channels <= numChannels); % Remove invalid channels
    if isempty(channels)
        error("None of the selected channels exist. Max available: %d", numChannels);
    end
end

%%%% Time Range Selection  %%%%
if timeRange(2) > max(t)
    timeRange(2) = max(t);
end
idx = (t >= timeRange(1)) & (t <= timeRange(2));
y = y(idx, channels); % Select specific time range & channels
t = t(idx);

%%%% Plot Waveform in the Time-Domain  %%%%
figure("Color", "w", "Position", [100, 100, 900, 600]);
tiledlayout(length(channels) + 1, 1);

for i = 1:length(channels)
    chIdx = channels(i);
    nexttile;
    plot(t, y(:, i), 'LineWidth', 1.2);
    xlabel("Time (s)");
    ylabel("Amplitude");
    title(sprintf("Waveform: Channel %d", chIdx));
    grid on;
end

%%%% Display Spectrogram of Selected Channel  %%%%
nexttile;
win = hamming(1024);
noverlap = 512;
nfft = 2048;
[s, f, t_s, p] = spectrogram(y(:, 1), win, noverlap, nfft, Fs, 'yaxis');

imagesc(t_s, f, 10*log10(abs(p)));
axis xy;
colorbar;
xlabel("Time (s)");
ylabel("Frequency (Hz)");
title(sprintf("Spectrogram (Channel %d)", channels(1)));

sgtitle(sprintf("Multi-Channel Audio Visualization (%s)", audioFile), "Interpreter", "none");

end
