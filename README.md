The new additions to the updated scripts have gone through the 
full process of data retrieval, preparation, training, and testing.

Visuals provided use 200 samples of audio files with 
160000 points, a sampling rate (Hz) of 16000 Hz, 7 Channel Audio,
and a total time length of 10 seconds.

Past tests consisted of 1 second chunks and smaller for the sake
of run time and seeing how the system performs with
chunks of data.

Shown tests take on the full 10 seconds of each sound sample,
providing more accurate classification and more distinct
learned patterns/hidden features that the Auto Encoder learned.

My personal conclusion from various testing cases and analyzing 
hyperparameters, learned parameters, encoded/decoded spaces,
the latent space of the Auto Encoder, the weights and performance of the SVM's,
and playing around with different data formats, is as follows:

- Data time frame doesn't matter, what matters is that the provided 
time frame holds the right features in the right places
(i.e., healthy data looks relatively uniform, 
anomalous data has distinct peaks in time frame)

- The method of passing raw data through the Auto Encoder
and providing the learned features to an SVM has consistently
outperformed the initial process of just 
Data Processing -> SVM Classification. These were the 
hypothesized results and the hypothesis has been confirmed
true.

- If you were to prepare your own array of features from 
your sound samples and conduct the same tests with:
Data Prep -> Auto Encoder Analysis -> SVM
Data Prep -> SVM
Performance between both methods is similar, with 
the Auto Encoder route still outperforming the
initial SVM method by ~=1%.


![autoencfeatures](https://github.com/user-attachments/assets/a102215f-9b19-4fd0-9e07-fa73d1533e83)
![neuronsauto](https://github.com/user-attachments/assets/33a8a05c-4ceb-4722-9510-28743c82a4c1)
![autoencperformance](https://github.com/user-attachments/assets/f4f7a564-c3f4-4b3b-8005-1fd7d2b9442b)
![Performsvmauto](https://github.com/user-attachments/assets/9e56b479-39e1-471d-a80a-ce640047c7ba)

https://github.com/user-attachments/assets/4f59c09e-97a0-4e19-bded-891eafb6af45


![handcraftedfullwave](https://github.com/user-attachments/assets/f10cd2b8-d96e-4588-b825-b54f729c53d7)

https://github.com/user-attachments/assets/ec9cffd4-ea42-4310-ae52-65eaa0f91efd

