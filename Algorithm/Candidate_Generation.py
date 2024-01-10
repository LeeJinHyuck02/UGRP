import numpy as np
import pandas as pd

from sklearn.preprocessing import MinMaxScaler

from tensorflow import keras
from tensorflow.keras import optimizers
from tensorflow.keras.layers import Dense, Input

class DL:
    def __init__ (self):
        self.model = keras.Sequential()
        self.model.add(Input(shape = (9,))) 
        self.model.add(Dense(20, activation = 'relu'))
        self.model.add(Dense(10, activation = 'relu'))
        self.model.add(Dense(5, activation = 'softmax'))
        
    def preprocessing(self, ID, date, location, df_session, df_history, df_restaurant, df_preference): # 나중에 좀 더 자세하게 바꿔야함.
        self.ID = ID
        self.now_date = date
        self.now_location = location
        self.df_session = df_session
        self.df_history = df_history[df_history['ID'] == ID]
        self.df_restaurant = df_restaurant
        self.df_preference = df_preference.loc[ID]
        
        '''
        Do Preprocessing! -> df_session
            food preference(음식 선호도): scaling(0~1)
            remaining time(남은 시간): normalization(0~1)
            remaining price(남은 가격): normalization(0~1)
            delivery location(배달 위치): normalization(0~1)
        '''
        df_test = df_session.copy()
        
        # food preference(음식 선호도)
        restaurants = self.df_session['restaurant']
        preference = []
        for restaurant in restaurants:
            menus = self.df_restaurant.loc[self.df_restaurant['restaurant'] == restaurant, 'menu']
            preference.append(np.max([self.df_preference[menu] for menu in menus]))
        df_test['preference'] = preference
        
        # remaining time(남은 시간), remaining price(남은 가격), delivery location(배달 위치)
        
        
        # last_order(최근 주문 여부)
        date_diff = []
        for restaurant in restaurants:
            dates = self.df_history.loc[self.df_history['restaurant'] == restaurant, 'date']
            date_diff.append(np.min([(pd.to_datetime(self.now_date) - pd.to_datetime(pre_date)).days for pre_date in dates]))
        df_test['last_order'] = date_diff
        
        # timezone(시간대)
        if pd.to_datetime(self.now_date).hour in [6, 7, 8, 9]:
            df_test['timezone'] = 'morning'
        elif pd.to_datetime(self.now_date).hour in [10, 11, 12, 13, 14, 15]:
            df_test['timezone'] = 'afternoon'
        elif pd.to_datetime(self.now_date).hour in [16, 17, 18, 19, 20, 21]:
            df_test['timezone'] = 'evening'
        elif pd.to_datetime(self.now_date).hour in [22, 23, 0, 1, 2, 3, 4, 5]:
            df_test['timezone'] = 'night'
            
        df = pd.get_dummies(df_test['timezone'])
        df_test = pd.concat([df_test, df], axis=1)
        df_test.drop(labels = 'timezone',axis = 1)
        
        # MinMaxScaler
        scaler = MinMaxScaler()
        scaler.fit(df_test[['time', 'price', 'location', 'last_order']])
        df_test[['time', 'price', 'location', 'last_order']] = scaler.transform(df_test[['time', 'price', 'location', 'last_order']])
        
        # 'preference', 'time', 'price', 'location', 'last_order', 'morning', 'afternoon', 'evening', 'night'
        return df_test

    def fit(self, X_train, y_train):
        self.model.compile(optimizer = 'adam', loss = 'categorical_crossentropy', metrics=['accuracy'])
        self.model.fit(X_train, y_train, epochs = 50, batch_size = 16)
        
    def predict(self, X_test):
        y_pred = self.model.predict(X_test)
        df_result = pd.DataFrame(y_pred)
        df_result.index.name = "session_id"
        df_result = df_result.reset_index()
        df_result['rating'] = df_result[[0,1,2,3,4]].max(axis = 1)
        for i in range(5):
            df_result.loc[df_result[i] == df_result['rating'], 'group'] = i
        df_result = df_result.drop(labels = [0,1,2,3,4],axis = 1)
        
        return df_result