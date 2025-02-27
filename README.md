
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
![reconex2](https://github.com/user-attachments/assets/785a15a3-19e4-48de-ae40-3b1d1521817d)
![reconex3](https://github.com/user-attachments/assets/e2eb4745-18aa-4027-a410-360e3bb20da0)
