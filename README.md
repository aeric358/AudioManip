
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





![reconstruct](https://github.com/user-attachments/assets/59d125e0-6a50-4ba3-9a70-b66abe7893f6)


[reconexample3.pdf](https://github.com/user-attachments/files/19016989/reconexample3.pdf)
[reconexample1.pdf](https://github.com/user-attachments/files/19016988/reconexample1.pdf)
[reconexample2.pdf](https://github.com/user-attachments/files/19016986/reconexample2.pdf)
