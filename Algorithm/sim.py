import simpy
import random
import numpy as np
import pandas as pd

from sklearn.decomposition import PCA
from sklearn.metrics.pairwise import cosine_similarity
from Collaborative_Filtering_1 import CF1
from Collaborative_Filtering_2 import CF2
from Content_Based_Filtering import CBF
from Candidate_Generation import DL
from Random_Ranking import RR

import matplotlib.pyplot as plt
from sklearn.metrics import mean_squared_error

'''
Our Own Algorithm!!!!!!!!!!
'''

# 우림 파트 (메뉴 40개)
menu_list = ["김치찜", "부대찌개", "대패삼겹살", "비빔면", "짜장면" ,"짬뽕", "볶음밥", "탕수육", "비빔밥", "돈까스", 
             "찜닭", "떡볶이", "치킨", "김치", "곱창", "대창", "염통", "우삼겹", "족발", "보쌈", 
             "인절미", "아이스크림", "스시", "까르보나라", "필라프", "샐러드", "냉모밀", "냉우동", "파스타", "마라탕", 
             "마라샹궈", "꿔바로우", "쌀국수", "분짜", "팟타이", "그래놀라", "요거트", "샤인머스켓", "빙수", "치즈"]

# [매콤, 짭짤, 고소, 담백, 상큼, 달콤, 쫄깃, 부드러움, 차가움, 신선, 고기, 채소, 유제품, 과일]
food_feature = np.array([[1,1,0,0,0,0,0,0,0,0,1,1,0,0], [1,1,0,0,0,0,0,0,0,0,1,1,0,0], [0,1,1,1,0,0,0,0,0,0,1,0,0,0], [1,0,0,0,1,0,1,0,0,0,0,1,0,0],
                         [0,1,0,0,0,1,1,0,0,0,1,1,0,0], [1,1,0,0,0,0,1,0,0,0,1,1,0,0], [0,1,1,0,0,0,0,0,0,0,1,1,0,0], [0,0,0,0,1,1,1,0,0,0,1,1,0,0],
                         [1,0,1,0,0,0,0,0,0,0,1,1,0,0], [0,0,1,0,0,0,0,0,0,0,1,0,0,0], [0,1,0,0,0,1,0,0,0,0,1,1,0,0], [1,0,0,0,0,1,1,0,0,0,0,1,0,0],
                         [0,1,1,0,0,0,0,0,0,0,1,0,0,0], [1,0,0,0,1,0,0,0,0,0,0,1,0,0], [0,1,1,0,0,0,1,0,0,0,1,0,0,0], [0,1,1,0,0,0,1,0,0,0,1,0,0,0],
                         [1,1,1,0,0,0,1,0,0,0,1,0,0,0], [0,1,1,0,0,0,1,1,0,0,1,0,0,0], [0,1,0,0,0,0,1,0,0,0,1,0,0,0], [0,1,1,0,0,0,1,1,0,0,1,0,0,0],
                         [0,1,1,0,0,0,1,0,0,0,0,0,0,0], [0,0,0,0,0,1,0,1,1,0,0,0,1,0], [0,0,0,1,0,0,1,0,0,1,1,0,0,0], [0,0,1,1,0,0,1,1,0,0,1,1,1,0],
                         [0,0,1,1,0,0,0,0,0,0,1,1,1,0], [0,0,0,0,1,0,0,0,0,1,0,1,1,1], [0,0,0,1,0,0,1,0,1,1,0,1,0,0], [0,1,0,1,0,0,1,1,1,0,0,1,0,0],
                         [0,1,1,0,0,0,1,1,0,1,1,0,0,0], [1,1,1,1,0,0,1,0,0,0,1,1,0,0], [1,1,1,1,0,0,0,0,0,0,1,1,0,0], [0,0,0,0,0,1,1,0,0,0,1,0,0,0],
                         [0,1,1,1,0,0,1,0,0,0,1,1,0,0], [1,1,1,1,1,1,1,0,0,0,1,1,0,0], [0,1,1,0,1,1,1,1,0,0,0,1,0,0], [0,0,1,0,0,1,0,0,0,1,0,0,1,1],
                         [0,0,0,0,1,1,0,1,1,1,0,0,1,1], [0,0,0,0,1,1,1,1,1,1,0,0,0,1], [0,0,0,0,1,1,0,1,1,1,0,0,1,1], [0,1,1,1,0,0,1,1,0,1,0,0,1,0]])


''' ACCURACY & EVALUATION '''
hit_accuracy = np.empty((0, 5))

# Hit & Miss
day = 1
hit = 0
miss = 0

menu_timezone_list = [[0, 1, 1, 0], [0, 1, 1, 0], [0, 0, 1, 0], [0, 1, 1, 1], [0, 1, 1, 0],
                      [0, 1, 1, 0], [0, 1, 1, 0], [0, 1, 1, 0], [0, 1, 1, 0], [0, 1, 1, 0],
                      [0, 1, 1, 1], [0, 1, 1, 1], [0, 1, 1, 1], [1, 1, 1, 0], [0, 0, 1, 1],
                      [0, 0, 1, 1], [0, 0, 1, 1], [0, 0, 1, 1], [0, 0, 1, 1], [0, 0, 1, 1],
                      [1, 1, 0, 1], [1, 1, 1, 1], [0, 1, 1, 0], [0, 1, 1, 1], [0, 1, 1, 1],
                      [1, 1, 0, 0], [0, 1, 1, 0], [0, 1, 1, 0], [0, 1, 1, 0], [0, 1, 1, 1],
                      [0, 1, 1, 1], [0, 1, 1, 1], [0, 1, 1, 0], [0, 1, 1, 0], [0, 1, 1, 0],
                      [1, 1, 0, 1], [1, 1, 0, 1], [1, 1, 0, 1], [1, 1, 0, 1], [0, 1, 1, 1]]

'''
Class Customer -> 고객 클래스
0. __init__(self, env, idx):            -> 고객 특성 부여
1. action(self, session_list, file):    -> "MAIN"
2. calc_preference(self, hist):         -> 답지
3. foodlist_pred(self):                 -> 각 음식에 대한 선호도 답지 생성 = 고객의 특성
4. food_choose(self):                   -> 주문할 음식 선정
'''
class Customer:
    # history: ['ID', 'menu', 'date', 'preference', 'time', 'price', 'location', 'last_order', 'morning', 'afternoon', 'evening', 'night', 'target']
    history = pd.DataFrame([[-1, -1, -1, 5.0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [-1, -1, -1, 3.8, 0, 0, 0, 0, 0, 0, 0, 0, 1],
                            [-1, -1, -1, 3.0, 0, 0, 0, 0, 0, 0, 0, 0, 2],
                            [-1, -1, -1, 2.2, 0, 0, 0, 0, 0, 0, 0, 0, 3],
                            [-1, -1, -1, 1.0, 0, 0, 0, 0, 0, 0, 0, 0, 4],
                            [-1, -1, -1, 0.0, 0, 0, 0, 0, 0, 0, 0, 0, 4]], columns = ['ID', 'menu', 'date', 'preference', 'time', 'price', 'location', 'last_order', 'morning', 'afternoon', 'evening', 'night', 'target'])
    ratings = np.empty((0, 40))  # user_x_item
    cf_matrix = []
        
    def __init__(self, env, idx):
        self.env = env
        self.idx = idx                                  # 고객 번호
        self.foodlist_pred()                            # 음식에 대한 선호도 리스트
        
        ''' EVALUATION '''
        self.cut_time  = random.randrange(15, 60) / 60
        self.cut_price = random.randrange(3, 11) / 10
        self.cut_location = random.random()
        
        self.rate_time  = random.randrange(0, 31)
        self.rate_price = random.randrange(0, 31 - self.rate_time)
        self.rate_location = random.randrange(0, 31 - (self.rate_time + self.rate_price))
        self.rate_last_order = random.randrange(0, 31 - (self.rate_time + self.rate_price + self.rate_location))
        self.rate_timezone = 30 - (self.rate_time + self.rate_price + self.rate_location + self.rate_last_order)

    def action(self, session_list, file):
        global hit_accuracy, hit, miss, day
        
        # 주문할 음식
        self.chosen_food = self.food_choose() 
        
        ''' DL '''
        # X_train, y_train 분리
        X_train = Customer.history[['preference', 'time', 'price', 'location', 'last_order', 'morning', 'afternoon', 'evening', 'night']]
        y_train = Customer.history[['target']]
        y_train = y_train.astype(str)
        y_train = pd.get_dummies(y_train)
        
        # Test Data Preprocessing
        X_test = pd.DataFrame(session_list, columns = ['menu', 'time', 'start', 'price', 'location', 'morning', 'afternoon', 'evening', 'night'])
        X_test['preference'] = Customer.cf_matrix[self.idx][X_test['menu']]
        X_test['last_order'] = 0 
        for hidx, row in Customer.history.iterrows():
            if (row.loc['ID'] == self.idx) and (row.loc['menu'] == self.chosen_food) and (row.loc['date'] > self.env.now - 24 * 7):
                X_test['last_order'] = 1   
                break
        X_test_ = X_test[['preference', 'time', 'price', 'location', 'last_order', 'morning', 'afternoon', 'evening', 'night']].copy()
        
        # Fit & Predict
        DL_model = DL()
        DL_model.fit(X_train, y_train)
        df_result = DL_model.predict(X_test_)
        df_result_sorted = df_result.sort_values(by='group')
        
        ''' TEST '''
        for sidx, row in df_result_sorted.iterrows():
            # 일치하는 것이 있는지
            if self.chosen_food == session_list[sidx][0]:
                # history에 추가
                hist = X_test.iloc[sidx, :].to_frame().transpose()
                hist['ID'] = self.idx
                hist['menu'] = session_list[sidx][0]
                hist['date'] = self.env.now
                hist['target'] = self.calc_preference(hist)
                cols = ['ID', 'menu', 'date', 'preference', 'time', 'price', 'location', 'last_order', 'morning', 'afternoon', 'evening', 'night', 'target']
                Customer.history = pd.concat([Customer.history, hist[cols]], axis = 0, ignore_index = True)
                
                # Hit or Miss(하루의 데이터 축적 시간을 둠)
                if row.loc['group'] == hist['target'].values[0]:
                    # hit++
                    hit += 1
                    file.write(f"Customer {self.idx}: hit!  #hit rate: {hit/float(hit+miss):.4f}\n\n")
                    hit_accuracy = np.append(hit_accuracy, np.array([[self.env.now, 1, hit, miss, day]]), axis=0)
                else:
                    # miss++
                    miss += 1
                    file.write(f"Customer {self.idx}: miss! #hit rate: {hit/float(hit+miss):.4f}\n\n")
                    hit_accuracy = np.append(hit_accuracy, np.array([[self.env.now, 0, hit, miss, day]]), axis=0)
                
                file.write(f"{hist} // {df_result_sorted.loc[sidx, 'group']}\n\n")
                
                # 적중한 session 제거(남은 시간을 0으로)
                session_list[sidx][1] = 0
                return
            
    def calc_preference(self, hist):
        # ['ID', 'menu', 'date', 'preference', 'time', 'price', 'location', 'last_order', 'morning', 'afternoon', 'evening', 'night']
        rating_num = Customer.cf_matrix[self.idx][self.chosen_food]
        rate_total = 0
        
        if hist['time'].values[0] > self.cut_time:                              # time
            rate_total += self.rate_time
            
        if hist['price'].values[0] > self.cut_price:                            # price
            rate_total += self.rate_price
            
        if hist['location'].values[0] > self.cut_location:                      # location
            rate_total += self.rate_location
            
        if hist['last_order'].values[0] == 1:                                   # last_order
            rate_total += self.rate_last_order
            
        if 11 <= self.env.now % 24 < 14:                                        # morning
            if menu_timezone_list[hist['menu'].values[0]][0] == 0:
                rate_total += self.rate_timezone
        elif 14 <= self.env.now % 24 < 17 + 20/60:                              # afternoon
            if menu_timezone_list[hist['menu'].values[0]][1] == 0:
                rate_total += self.rate_timezone
        elif 17 + 40/60 <= self.env.now % 24 < 22:                              # evening
            if menu_timezone_list[hist['menu'].values[0]][2] == 0:
                rate_total += self.rate_timezone
        elif (22 <= self.env.now % 24 < 24) | (0 <= self.env.now % 24 < 2):     # night
            if menu_timezone_list[hist['menu'].values[0]][3] == 0:
                rate_total += self.rate_timezone
                
        rating_num *= (100 - rate_total) / 100
        
        if rating_num < 1.8:
            group_num = 4
        elif 1.8 <= rating_num < 2.6:
            group_num = 3
        elif 2.6 <= rating_num < 3.4:
            group_num = 2
        elif 3.4 <= rating_num < 4.2:
            group_num = 1
        elif 4.2 <= rating_num:
            group_num = 0
        
        return group_num
            
    # 현민 파트
    def foodlist_pred(self): #food_feature : 음식 X feature
        #랜덤으로 설정한 두 음식 각각에 대한 유사도를 같은 열에 배정, 같은 방식으로 모든 음식에 대해 행 별로 정렬
        similarity_list = [[0 for col in range(2)] for row in range(len(food_feature))]

        #0으로 초기화된 음식(item)개수만큼의 list 생성.
        preference_list = [0 for i in range(len(food_feature))]       #cf)len(food_feature) = 행(음식)의 길이     #preference_list : user X 음식

        #user 1명에 대한 item들의 배열(음식 선호 리스트)에 대해 처리함. 이 함수 내에서 아예 한 명의 user에 대한 참 음식 선호 리스트를 계산하고 그거를 외부의 list에 연속적으로 추가하는 방식이 좋을듯
        #음식 선호 리스트 중 두개를 선택하여 5점의 선호도 부여함.
        random_num = random.sample(range(len(food_feature)), 2)
        preference_list[random_num[0]] = 5
        preference_list[random_num[1]] = 5

        #food feature을 받아와 음식들 사이의 유사성을 활용. food feature을 바탕으로 음식 사이의 유사도를 판별하는데 있어 cosine similarity 사용함.
        #random으로 선택한 두 음식과의 유사도 각각 계산 후 동일한 열의 다른 행에 저장. 이후 두 유사도의 크기를 비교. 더 큰 유사도를 가진 음식의 선호도와 해당 유사도를 곱하여 참값 선호도 반환
        for index in range(len(food_feature)):         
            similarity_list[index][0] = cosine_similarity([food_feature[index]], [food_feature[random_num[0]]])
            similarity_list[index][1] = cosine_similarity([food_feature[index]], [food_feature[random_num[1]]])
            if similarity_list[index][0][0][0] > similarity_list[index][1][0][0]:
                preference_list[index] = preference_list[random_num[0]] * similarity_list[index][0][0][0]
            else:
                preference_list[index] = preference_list[random_num[1]] * similarity_list[index][1][0][0]
                
        
        #preference_list에서 임의로 5개를 골라 ratings에 대입
        _list = [0 for i in range(len(food_feature))]
        nums = random.sample(range(len(food_feature)), 40)
        for index in nums:
            _list[index] = preference_list[index]
        Customer.ratings = np.append(Customer.ratings, np.array([_list]), axis=0)
    
    def food_choose(self):
        #preference_list 상에서 음식 하나를 고르게 됨. 음식을 고르는데 있어서 선호도를 가중치로 주어 선택하게끔 설계.
        #우선 각 food에 번호를 지정해주어 목록 생성.

        #0부터 번호를 지정해주어 음식 수만큼 길이의 음식 리스트 생성.
        preference_list = Customer.cf_matrix[self.idx]
        food = list(range(len(preference_list)))

        #random.choice 속 weight매개변수를 통해 preference_list 속의 각 음식에 대한 선호도를 각 음식 종류에 대한 가중치로 삼아 음식의 종류 하나 선택. 
        chosen_food = random.choices(food, weights = preference_list, k=1)

        return chosen_food[0]
    
            
'''
Class Session -> 세션 단일 객체
'''         
class Session:
    # 세션의 기본 설정
    def __init__(self, env):
        # ['menu', 'time', 'start', 'price', 'location', 'morning', 'afternoon', 'evening', 'night']
        self.list = []
        self.list.append(random.randrange(len(menu_list)))  # menu
        self.list.append(random.randrange(15, 60) / 60)     # time(15분~60분)
        self.list.append(env.now)                           # start
        self.list.append(random.randrange(3, 11) / 10)      # price(15000원~50000원)
        self.list.append(random.random())                   # location(0~1)
        if 11 <= env.now % 24 < 14:                         # morning, afternoon, evening, night
            self.list.extend([1, 0, 0, 0])
        elif 14 <= env.now % 24 < 17 + 20/60:
            self.list.extend([0, 1, 0, 0])
        elif 17 + 40/60 <= env.now % 24 < 22:
            self.list.extend([0, 0, 1, 0])
        elif (22 <= env.now % 24 < 24) | (0 <= env.now % 24 < 2):
            self.list.extend([0, 0, 0, 1])
        else:
            self.list.extend([0, 0, 0, 0])
          
            
'''
Class Setting -> 시뮬레이터의 배경 설정
0. __init__(self, file):        -> 기본 세팅
1. customer_generate(self):     -> 우리 가게에 올 고객들의 정보를 생성한다.(self.customer_list에 저장)  **한번만 호출**
2. session_generate(self):      -> 새로이 세션을 생성한다.(self.session_list에 저장)
3. session_delete(self):        -> 만료된 세션을 삭제한다.(self.session_list에서 삭제)
4. sim(self):                   -> 돌아갈 시뮬레이터 함수
5. save(self, i):               -> 그래프 이미지 저장
'''
class Setting:
    def __init__(self, file):     
        self.phase = 0
        self.file = file                    # 시뮬레이터 로그를 저장할 파일
        self.customer_list = []             # 고객 객체가 저장될 리스트(일정 숫자(100)의 고객들 중에서 무작위로 방문함.)
        self.session_list = []              # 현재 존재하는 세션 정보가 저장될 리스트(지속적으로 추가와 삭제가 반복됨.)
        self.env = simpy.Environment()         
        self.env.process(self.sim())
        self.env.run(until=72)
        
    def customer_generate(self):
        for i in range(100):    # 100명의 고객이 무작위로 방문할 예정이다.
            self.customer_list.append(Customer(self.env, i))
            
    def session_generate(self):
        iter = 30   # iter개의 세션을 새로 생성한다.
        
        # 시간대의 따라 생성되는 세션의 수 조절
        if (11 <= self.env.now % 24 < 14) | (17 + 40/60 <= self.env.now % 24 < 22):
            iter *= 1
        elif 14 <= self.env.now % 24 < 17 + 20/60:
            iter *= 0.4
        elif (22 <= self.env.now % 24 < 24) | (0 <= self.env.now % 24 < 2):
            iter *= 0.6               
        else:
            iter = 0
            
        for i in range(int(iter)):  
            self.session_list.append(Session(self.env).list)  
            
    def session_delete(self):
        # ['menu', 'time', 'start', 'price', 'location', 'morning', 'afternoon', 'evening', 'night']
        for session in self.session_list:
            if self.env.now >= session[1] + session[2]:     # 만료된 세션 제거
                self.session_list.remove(session)                                             
        
    def sim(self):
        global hit_accuracy, day
        
        ''' CF '''
        self.customer_generate()      
        Customer.cf_matrix = CF1().execute(Customer.ratings)                                                              # 초기 고객 정보 생성
        
        while True:                                                                
            self.session_generate()                                                                 # 새로 세션 정보 생성(20분마다 반복)
            for i in range(10):                                                                     # 고객 무리 방문(2분마다 반복)
                if len(self.session_list) != 0:                                                     # 세션이 존재하지 않는 경우에는 고객 방문도 없음.(있어도 의미없이 때문)
                    customer_num = random.randrange(1, 5)                                           # 한번의 고객 무리는 1~5명의 고객으로 이루어짐.
                    if (11 <= self.env.now % 24 < 14) | (17 + 40/60 <= self.env.now % 24 < 22):     # 시간대의 따라 방문하는 고객의 수 조절
                        customer_num *= 1
                    elif 14 <= self.env.now % 24 < 17 + 20/60:
                        customer_num *= 0.4
                    elif (22 <= self.env.now % 24 < 24) | (0 <= self.env.now % 24 < 2):
                        customer_num *= 0.6               
                    else:
                        customer_num = 0
                        
                    customer_visit = random.sample(range(100), k = int(customer_num))               # 방문한 고객의 정보를 정한다.
                    for idx in customer_visit:
                        if len(self.session_list) != 0:                                             # 세션이 존재하지 않는 경우에는 고객 방문도 없음.(있어도 의미없이 때문)
                            self.customer_list[idx].action(self.session_list, self.file)            # 고객 방문
                            self.session_delete()                                                   # 만약 만료된 세션이 있다면, 해당 세션 제거
                        
                self.phase += 1
                if self.phase % 720 == 0:
                    day += 1
                
                print(self.env.now)
                print(self.env.now)
                print(self.env.now)
                print(self.env.now)
                print(self.env.now)
                print(self.env.now)
                
                yield self.env.timeout(2/60)
            
    def save(self):
        global hit_accuracy
        
        hit_accuracy = pd.DataFrame(hit_accuracy, columns = ['time', 'hit', 'tot_hit', 'tot_miss', 'day'])
        hit_accuracy['hit_rate'] = hit_accuracy['tot_hit'] / (hit_accuracy['tot_hit'] + hit_accuracy['tot_miss'])
        
        # 그래프
        plt.figure(figsize=(15,5))
        x = np.arange(1, len(hit_accuracy) + 1)
        y = hit_accuracy['hit_rate']
        plt.plot(x, y)
        plt.xlabel('order')
        plt.ylabel('hit rate')
        plt.title('Hit Rate of Order - Day 1~3')
        
        print(hit_accuracy.iloc[200:, 5].max)
        print(len(hit_accuracy))
        print(len(hit_accuracy[hit_accuracy['day'] == 1]))
        print(len(hit_accuracy[hit_accuracy['day'] == 2]))
        print(len(hit_accuracy[hit_accuracy['day'] == 3]))
        
        '''
        for i in [1,2,3,4,5]:
            list = hit_accuracy[hit_accuracy['day'] == i].copy()
            list = list.reset_index(drop=True)
            list['tot_hit'] = list['tot_hit'] - list.loc[0, 'tot_hit'] + list.loc[0, 'hit']
            list['tot_miss'] = list['tot_miss'] - list.loc[0, 'tot_miss'] + (1 - list.loc[0, 'hit'])
            list['hit_rate'] = list['tot_hit'] / (list['tot_hit'] + list['tot_miss'])
            
            x = np.arange(1, len(list) + 1)
            y = list['hit_rate']
            plt.plot(x, y, label = f'DAY{i}')
            plt.xlabel('order')
            plt.ylabel('hit rate')
            plt.title(f'Hit Rate of Order')
            plt.legend(loc='upper left')
        '''
        plt.savefig('result.png')

        
''' MAIN CODE '''
if __name__ == "__main__":
    print('UGRP_algo_test01')       # print title
    file = open("log.txt", 'w')     # open file               
    simulator = Setting(file)       # start simulator
    simulator.save()                # save image
    file.close()                    # close file