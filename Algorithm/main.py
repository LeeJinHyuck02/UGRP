import numpy as np
from Collaborative_Filtering_1 import CF1
from Collaborative_Filtering_2 import CF2
from Content_Based_Filtering import CBF
from Candidate_Generation import DL
from Random_Ranking import RR

# four users & five foods
user_x_food = np.array([[3, np.NaN, np.NaN, 5, np.NaN], # user1
                        [np.NaN, 2, np.NaN, 2, 4],      # user2
                        [np.NaN, np.NaN, 3, 2, 1],      # ....
                        [5, 5, 4, 5, np.NaN]])

# [meat, vegan, spicy]
food_features = np.array([[1, 0, 0],
                          [1, 1, 1],  
                          [0, 1, 0],
                          [1, 0, 1], 
                          [1, 0, 0]])

'''
Input
1. user_x_food: 특정 유저의 특정 음식 선호도를 나타내는 행렬
2. ID: user의 id
3. date: 현재 날짜  ex.2023/11/17(금) 14:19
4. location: 현재 위치  ex.(위도, 경도) 튜플 형태로
5. df_session: 적어도 있어야 할 column -> ['time', 'price', 'location'] # 남은 시간(분), 남은 금액, 위치(4와 동일하게 튜플 형태로)
6. df_history: column -> ['user_id', 'date', 'preference', 'time', 'price', 'location', 'last_order', 'morning', 'afternoon', 'evening', 'night', 'Label']
    - 테스트 데이터이자
    - 최근 주문 여부 'last_order' 확인을 위한 df
    - 사용자가 세션을 참여하면 할수록 늘어남
7. df_restaurant: 음식점과 그 곳의 음식들을 알 수 있는 것들
    - 기존의 menuDB 느낌
    - 메뉴명 이외에도 짜장면, 치킨과 같이 음식 종류를 명확히 할 수 있는 column이 있으면 편할듯 (보배짜장면x, 황올x)
'''

if __name__ == "__main__":
    # CFvsCBF
    cf1_matrix = CF1().execute(user_x_food)
    cf2_matrix = CF2().execute(user_x_food)
    cbf_matrix = CBF().execute(user_x_food, food_features)
    
    '''
    print(cf1_matrix)
    print(cf2_matrix)
    print(cbf_matrix)
    '''
    
    # DL
    DL_model = DL() # 미완
    X_test = DL_model.preprocessing(ID, date, location, df_session, df_history, df_restaurant, cf2_matrix)
    DL_model.fit(X_train, y_train)
    df_result = DL_model.predict(X_test)
    
    # RR
    session_list = RR().execute(df_result)
    return session_list
    
    
    
    
    


    