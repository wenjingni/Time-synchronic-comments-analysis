# Time-synchronic-comments-analysis
##### The codes used in the paper 
#### ***"Time -synchronic Comments on Video Streaming Website Reveal Core Structures of Audience Engagement in Movie Viewing:performing_arts:"***


**1. 15topics_content**
  - 15 main topics with highest number of comments among 134 clusters for the 300,000 randomly selected comments, and their corresponding time-synchronic comments.
  

**2. Danmu_Scripts_Data**

  - **Danmu_Cog_cluster_statistics.CSV**
    - Cognition-related word rates (calculated by **Simplified Chinese Linguistic Inquiry and Word Count**) through time of **240** movies' time-synchronic comments
    - and the clustering result.
    
  - **Danmu_Cog_stationized.CSV**
    - Stationized cognition-related word rates through time of **179** movies' time-synchronic comments. 
    - These 179 movies are those **whose screenplays are available online**.
    
  - **Danmu_Emo_cluster_statistics.CSV**
    - Emotion-related word rates through time of **240** movies' time-synchronic comments, and the clustering result.
    
  - **Danmu_Emo_stationized.CSV**
    - Stationized emotion-related word rates through time of **179** movies' time-synchronic comments.
    - These 179 movies are those **whose screenplays are available online**.
    
  - **Scripts_Cog_cluster_statistics.CSV**
    - Cognition-related word rates through time of **179** movies' screenplays, and the clustering result.
    
  - **Scripts_Cog_stationized.CSV**
    - Stationized cognition-related word rates through time of **179** movies' screenplays. 
    
  - **Scripts_Emo_cluster_statistics.CSV**
    - Emotion-related word rates through time of **179** movies' screenplays, and the clustering result.
    
  - **Scripts_Emo_stationized.CSV**
    - Stationized emotion-related word rates through time of **179** movies' screenplays.

**3. Clusters_logistic_regression.R**
  - To build logistic regression models which predict the cognitive or emotional pattern of engagement. 
  
**4. Granger_causality_analysis.ipynb**
  - The code to conduct Granger-causality test between time-series of time-synchronic comments and screenplays (both with cognition and emotion-related words)
  - ADF test should be done first to make sure the time-series is **stationary**

**5. Tencent_video_danmu_crawler.py**
  - The code to crawl down time-synchronic comments from TencentVideo
  
**6. Time-series-clustering-sdtw.py**
  - To do time-series clustering with **soft-dtw**
  - To decide the optimal choice of k with **both elbow method and with calculation of silhouette score**
  
**7. UMAP-HDBSCAN-Topics.ipynb**
  - First vectorize sentences with sBert (Sentence Transformers)
  - Then do HDBSCAN on the selected 300000 comments
  
**8. clustering_result_hdbscan_tuned.pkl**
  - The pickle file for the sentence clustering results
 
**9. granger_causality_results.xlsx**
  - Lags, p-values for granger-causality tests on 179 pairs of movie time-synchronic comments and screenplays


