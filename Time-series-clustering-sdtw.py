import numpy as np
import matplotlib.pyplot as plt
from tqdm import tqdm
from tslearn.clustering import TimeSeriesKMeans
from tslearn.datasets import CachedDatasets
from tslearn.preprocessing import TimeSeriesScalerMeanVariance, \
    TimeSeriesResampler
from tslearn.utils import to_time_series
from tslearn.utils import to_time_series_dataset
from tslearn.clustering import silhouette_score
import pandas as pd

def read_data(file):
    time_series_data = pd.read_csv(file,sep='\t')
    x = np.array(time_series_data.X.astype(float))
    y = np.array(time_series_data.Y.astype(float))
    formatted_x = to_time_series_dataset(x)
    formatted_y = to_time_series_dataset(y)
    return formatted_x,formatted_y
  
def transform_data(formatted_x,formatted_y):
    
    X_train = formatted_x
    np.random.shuffle(X_train)
    X_train= TimeSeriesScalerMeanVariance().fit_transform(X_train)
# Make time series shorter
    X_train = TimeSeriesResampler(sz=40).fit_transform(X_train)
    sz = X_train.shape[1]
    return X_train, sz
  
def soft_dtw(X_train,seed):
    print("Soft-DTW k-means")
    np.random.seed(seed)
    model_list = []
    silhouette_scores = []
    ys = []
    inertias = []
    for cluster in tqdm(range(2,10),leave=False):
        sdtw_km = TimeSeriesKMeans(n_clusters=cluster,
                            metric="softdtw",
                            metric_params={"gamma": .01},
                            verbose=True,
                            random_state=seed)
        y_pred = sdtw_km.fit_predict(X_train)
        inertia = sdtw_km.inertia_
        model_list.append(sdtw_km)
        silhouette = silhouette_score(X_train, y_pred, metric = 'softdtw')
        silhouette_scores.append(silhouette)
        inertias.append(inertia)
        ys.append(y_pred)
    models = list(zip(model_list,silhouette_scores))
    model_performance = dict((m,s) for m,s in models)
    return model_performance,ys,inertia
  
def save_model_performance_df(model_performance,ys,inertia):
  model_df = pd.DataFrame.from_dict(model_performance)
  model_df['Inertia'] = inertia
  return model_df
 

def main():
  formatted_x, formatted_y = read_data(PATH_TO_FILE)
  X_train, sz = transform_data(formatted_x, formatted_y)
  model_performance, ys, inertia = soft_dtw(X_train, seed = 42)
  model_df = save_model_performance_df(model_performance, ys, inertia)
  model_df.to_csv(PATH_TO_SAVE_RESULT)

if __name__=="__main__":
  main()
