function featureTable = generateAudioFeatures(audioFile, channels)
%GENERATEAUDIOFEATURES Extracts time and frequency domain features from audio.
%
%   featureTable = generateAudioFeatures(audioFile, channels)
%   - `audioFile`: Path to the multi-channel audio file.
%   - `channels`: Vector specifying which channels to extract features from.
%
%   Returns a table where each row is a feature vector from a selected channel.

arguments
    audioFile (1,:) char {mustBeFile}
    channels (1,:) double {mustBePositive} = [] % Default: all channels
end

%%%% Load Audio Files  %%%%
[y, Fs] = audioread(audioFile);
[numSamples, numChannels] = size(y);

%%%% Channel Selection  %%%%
if isempty(channels)
    channels = 1:numChannels; % Default: all channels
end

%%%% Data Storage Initialization  %%%%
featureData = []; % Empty array for features
numMFCC = 13; % Expected number of MFCC coefficients

%%%% Feature Extraction Via RMS, Zero-Cross Rate, MFCC, %%%%
%%%% Spectral Centroid/Spectrogram.                     %%%%

for ch = channels
    if ch > numChannels
        warning("Channel %d does not exist in the file. Skipping...", ch);
        continue;
    end
    
    % Extract relevant features
    audioSegment = y(:, ch); % Select one channel at a time
    
    % Time-domain features
    rmsValue = rms(audioSegment); % Root Mean Square Energy
    zeroCrossRate = sum(abs(diff(audioSegment > 0))) / length(audioSegment); % Zero-crossing rate
    
    % Spectral features
    try
        [~, specFreq, ~, P] = spectrogram(audioSegment, hamming(1024), 512, 2048, Fs, 'yaxis');
        spectralCentroid = sum(specFreq .* mean(P, 2)) / sum(mean(P, 2)); % Spectral centroid
    catch
        warning("Spectrogram failed for channel %d. Setting to NaN.", ch);
        spectralCentroid = NaN;
    end

    % MFCCs (Mel-Frequency Cepstral Coefficients)
    try
        mfccs = mfcc(audioSegment, Fs, 'NumCoeffs', numMFCC); % Extract MFCCs
        if size(mfccs, 1) > 1
            mfccMean = mean(mfccs, 1); % Take mean of MFCCs over time
        else
            mfccMean = NaN(1, numMFCC); % Handle case where MFCC computation fails
        end
    catch
        warning("MFCC computation failed for channel %d. Setting to NaN.", ch);
        mfccMean = NaN(1, numMFCC);
    end

    % Combine features into a single vector
    featureVector = [rmsValue, zeroCrossRate, spectralCentroid, mfccMean];

    % Append to feature data
    featureData = [featureData; featureVector];
end

%%%% Case Where No Channels Exist %%%%
if isempty(featureData)
    error("No valid audio channels were processed. Check the channel selection.");
end

%%%% Array Construction w/ Labels for Each Feature  %%%%
numExtractedFeatures = size(featureData, 2);
mfccNames = arrayfun(@(x) sprintf("MFCC%d", x), 1:(numExtractedFeatures - 3), 'UniformOutput', false);
featureNames = ["RMS", "ZeroCrossRate", "SpectralCentroid", mfccNames];

%%%% Detect Any Mismatches of Numbers & Names  %%%%
if numel(featureNames) ~= numExtractedFeatures
    error("Mismatch: Extracted %d features but only %d names generated.", numExtractedFeatures, numel(featureNames));
end

%%%% Array-to-Table Conversion  %%%%
featureTable = array2table(featureData, 'VariableNames', featureNames);

end
