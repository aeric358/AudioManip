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

![tsne2and3pos](https://github.com/user-attachments/assets/c85ef479-62e0-4b9d-83db-eba8cc332149)
![tsne1and3pos](https://github.com/user-attachments/assets/907265ca-43b2-4c3b-a367-4db1a372b6f6)
![tsne1and2pos](https://github.com/user-attachments/assets/b95045c0-0f8c-4406-8c3b-942de30bcc8d)
![tsneauxpos](https://github.com/user-attachments/assets/263d299a-e491-400a-92ba-1e1b69dafc0a)
![AEStructfinal](https://github.com/user-attachments/assets/7c8c81ba-e0ee-4088-8565-65c922f64643)
![AEperformancefinal](https://github.com/user-attachments/assets/20c2d5d6-fa3a-45f0-b6b8-646eba65e39d)


https://github.com/user-attachments/assets/942bf3e8-d030-41bf-89ac-f37e4095f610




![handcraftedfullwave](https://github.com/user-attachments/assets/f10cd2b8-d96e-4588-b825-b54f729c53d7)
https://github.com/user-attachments/assets/ec9cffd4-ea42-4310-ae52-65eaa0f91efd

![handcraftedsvmperformancefeatures](https://github.com/user-attachments/assets/f8c5cef3-c270-4ab6-b719-c46b5b24dbac)
https://github.com/user-attachments/assets/b76ce7c0-771c-4e4a-a721-fdf2dce047fb


