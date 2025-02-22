function extractAndPlayChannel(audioFile, channel, saveFile)
%EXTRACTANDPLAYCHANNEL Extracts and plays a specific channel from a multi-channel WAV file.
%
%   extractAndPlayChannel(audioFile, channel)
%   - Extracts and plays the specified channel from the file.
%
%   extractAndPlayChannel(audioFile, channel, saveFile)
%   - Saves the extracted channel as a new WAV file.
%
%   - `audioFile`: Path to the multi-channel audio file (string).
%   - `channel`: Channel number to extract (integer).
%   - `saveFile`: (Optional) Filename to save the extracted channel.

arguments
    audioFile (1,:) char {mustBeFile}
    channel (1,1) double {mustBePositive}
    saveFile (1,:) char = "" % Optional: Save extracted channel
end

%%%% Channel Selection  %%%%
[y, Fs] = audioread(audioFile);
[numSamples, numChannels] = size(y);

%%%% Channel Selection  %%%%
if channel > numChannels
    error("Invalid channel number. This file has only %d channels.", numChannels);
end

%%%% Individual Channel Selection  %%%%
channelData = y(:, channel);

%%%% Data Normalization to Work Around Clipping  %%%%
channelData = channelData / max(abs(channelData));

%%%% Play Selected Channel  %%%%
fprintf("Playing Channel %d from %s...\n", channel, audioFile);
sound(channelData, Fs);

%%%% Optional Case: Save Selected Channel as Separate WAV file  %%%%
if ~isempty(saveFile)
    audiowrite(saveFile, channelData, Fs);
    fprintf("Extracted channel saved as: %s\n", saveFile);
end

% 📌 **7. Plot the Extracted Waveform**
figure("Color", "w", "Position", [100, 100, 900, 300]);
plot((0:numSamples-1)/Fs, channelData, 'k', 'LineWidth', 1.2);
xlabel("Time (s)");
ylabel("Amplitude");
title(sprintf("Extracted Audio Waveform - Channel %d", channel));
grid on;

end