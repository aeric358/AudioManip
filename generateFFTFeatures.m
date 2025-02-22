function featureTable = generateFFTFeatures(audioFile, channels, fftSize)
%GENERATEFFTFEATURES Extracts FFT-based features from audio signals.
%
%   featureTable = generateFFTFeatures(audioFile, channels, fftSize)
%   - `audioFile`: Path to the multi-channel audio file.
%   - `channels`: Vector specifying which channels to extract FFT from.
%   - `fftSize`: Number of FFT points (default: 1024).
%
%   Returns a table where each row corresponds to a selected channel.

arguments
    audioFile (1,:) char {mustBeFile}
    channels (1,:) double {mustBePositive} = [] % Default: all channels
    fftSize (1,1) double {mustBePositive} = 1024 % Default FFT size
end

%%%% Load Audio Files  %%%%
[y, Fs] = audioread(audioFile);
[numSamples, numChannels] = size(y);

%%%% Channel Selection  %%%%
if isempty(channels)
    channels = 1:numChannels; % Default: all channels
end

%%%% Data Storage Initialization  %%%%
featureData = [];
labels = {};

%%%% FFT for Audio File's Channels %%%%
for ch = channels
    if ch > numChannels
        warning("Channel %d does not exist in the file. Skipping...", ch);
        continue;
    end
    
    % Select channel data
    audioSegment = y(:, ch);
    
    % Compute FFT
    Y = abs(fft(audioSegment, fftSize)); % Get magnitude spectrum
    Y = Y(1:fftSize/2); % Keep only positive frequencies

    % Extract key frequency-domain features
    maxFreqMag = max(Y); % Peak magnitude in FFT spectrum
    meanFreqMag = mean(Y); % Mean magnitude across frequencies
    medianFreqMag = median(Y); % Median of frequency magnitude
    dominantFreqIndex = find(Y == maxFreqMag, 1); % Index of peak frequency
    dominantFreq = (dominantFreqIndex - 1) * (Fs / fftSize); % Convert to Hz

    % Combine features into a single vector
    featureVector = [maxFreqMag, meanFreqMag, medianFreqMag, dominantFreq];

    % Append to feature data
    featureData = [featureData; featureVector];
    
    % Store optional channel labels
    labels{end+1} = sprintf("Channel%d", ch);
end

%%%% No File Channels Detected Case  %%%%
if isempty(featureData)
    error("No valid audio channels were processed. Check the channel selection.");
end

%%%% Features From FFT Calculation  %%%%
featureNames = ["MaxFreqMag", "MeanFreqMag", "MedianFreqMag", "DominantFreq"];

%%%% Array to Table Transformation  %%%%
featureTable = array2table(featureData, 'VariableNames', featureNames);

end