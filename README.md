
**MAIN SCRIPTS: testaudiomachine.mlx; fastftaudio.mlx; audiosimilarity.mlx; testdataprep; encplayground.mlx; reconenc.mlx**

**FUNCTION SCRIPTS: generateFFTFeatures.m; generateAudioFeatures.m; extractAndPlayChannel.m; helperPlotMultiChannelAudio.m**

**Step 1: Check/Prepare Audio Files (testaudiomachine.mlx)>[if you want to manually choose features]>(audiosimilarity.mlx)/(fastftaudio.mlx)**

This step is meant to provide some visual aid and starting features to play around with and understand what differentiates an audio clip from another. This step can be used to provide a competitor to the autoencoder to be used down the line, as it will be producing its own features/patterns to distinguishing different waveforms.

**Step 2a (Unsupervised Learning):(audiosimilarity.mlx)+(testdataprep.mlx)->(encplayground.mlx)->(reconenc.mlx)**
To start the autoencoder training, split your audio files into two separate groups with equal number of rows and columns, the training data set(audiosimilarity.mlx) and the the testing data set(testdataprep.mlx). 

**NOTE: Make sure the test and training sets are of equal sizes. I ran into an issue where if the data sets are of differing sizes(one is 15x16000 and the other is 25x16000), the predict(),encode(),decode(), and other functions utilizing the test set will not work.**

Run the encplayground.mlx script to begin training the autoencoder of your choice.

After training, run the reconenc.mlx script to use the predict() function to see how accurately the "autoenc2" network reconstructs "testwaveformData" based on what it has learned from the training data set. 

** (shown graphs and images are my own hyper-params and performance from most recent run)
**




%  Autoencoder structure
hiddenSize2 = 32;
autoenc2 = trainAutoencoder(waveformData, hiddenSize2, ...
    'MaxEpochs', 100,...
    'EncoderTransferFunction','satlin',...
     'DecoderTransferFunction','purelin',...
    'L2WeightRegularization', 0.0001, ...
    'SparsityRegularization', 1, ...
    'SparsityProportion', 0.1, ...
    'ScaleData', true);




![reconstruct](https://github.com/user-attachments/assets/59d125e0-6a50-4ba3-9a70-b66abe7893f6)
![reconex1](https://github.com/user-attachments/assets/6cbfd895-a8e6-4d03-9818-ec504e59d3cf)
![reconex2](https://github.com/user-attachments/assets/73d72e94-dae0-4e5a-b785-f61af1ca1e5f)
![reconex3](https://github.com/user-attachments/assets/e2eb4745-18aa-4027-a410-360e3bb20da0)


hiddenSize5 = 50; 
autoenc5 = trainAutoencoder(waveformData, hiddenSize5, ...
    'MaxEpochs', maxep,...
    'EncoderTransferFunction','satlin',...
     'DecoderTransferFunction','purelin',...
    'L2WeightRegularization', l2reg, ...
    'SparsityRegularization', sparsreg, ...
    'SparsityProportion', sparsport, ...
    'ScaleData', true, ...
    'ShowProgressWindow',true);

    %%%% Load Pretrained Autoencoder Weights & Biases %%%%
we = autoenc5.EncoderWeights;  
be = autoenc5.EncoderBiases;  
%%%% Define BILSTM Network with Pretrained Weights %%%%
outPut_Size = size(we, 1);  % Should match encoded feature size (latent space)
inputSize = size(we, 2);    % Original waveform feature size

layer = fullyConnectedLayer(outPut_Size, ...
    'Weights', we, ...
    'Bias', be);

% Define LSTM-based Architecture
layers = [
    sequenceInputLayer(inputSize)
    layer
    lstmLayer(30, 'OutputMode', 'sequence')
    fullyConnectedLayer(inputSize)
    regressionLayer];

%%%% Training Options %%%%
options = trainingOptions('adam', ...
   'Plots', 'training-progress', ...
   'MiniBatchSize', 500, ...
   'MaxEpochs', 500, ...
   'SequencePaddingDirection','left',...
   'Shuffle', 'every-epoch', ...
   'GradientThreshold', 1, ...
   'Verbose', true, ...
   'ExecutionEnvironment', 'auto');

%%%% Reshape Data for LSTM %%%%
testwaveformDataSeq = permute(testwaveformData, [2, 1]); % Ensure correct format for LSTM

%%%% Train the Model %%%%
net = trainNetwork(testwaveformDataSeq', testwaveformDataSeq', layers, options);



![finalautoencstruct](https://github.com/user-attachments/assets/a094434b-2b0f-4825-af86-b30be56ff2ec)
![autoencperform](https://github.com/user-attachments/assets/2380af98-91c2-45dd-b3e3-f6928ef97bb8)
![simtest2](https://github.com/user-attachments/assets/36e4a10c-f50b-4723-af0a-212e8a393e84)
![finalencperf](https://github.com/user-attachments/assets/0a6ccdad-b16d-467d-8e4a-fdf30f14714a)
![svmperform](https://github.com/user-attachments/assets/ab19c193-d16a-4ddb-92d8-1c531ba782eb)
