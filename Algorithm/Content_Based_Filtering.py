from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

class CBF:
    # cosine_similarity function
    def cosine_sim(self, features):
        similarity_matrix = cosine_similarity(features, features)
        return similarity_matrix
        
    def execute(self, user_food_ratings, food_features):                                                            # food_features & user_food_ratings : main 파일 위치
        similarity_matrix = self.cosine_sim(food_features)

        # Content-Based Filtering
        user_predict = user_food_ratings
        foods = ["pizza", "burger", "salad", "taco", "spaghetti"]

        for user in range(user_food_ratings.shape[0]):
            for idx in range(len(foods)):
                if np.isnan(user_food_ratings[user][idx]) == True:                                                  # 알고싶은 음식  #isnan: 데이터가 nan(not a number)인지 아닌지를 판별 nan이면 1, 아니면 0
                    # 가중합 구해보자
                    food_list = []
                    similarity_list = []
                    for compare_idx in range(len(foods)):
                        if np.isnan(user_food_ratings[user][compare_idx]) == False:                                 # 이미 아는 음식 (유사도)
                            food_list.append(user_food_ratings[user][compare_idx])
                            similarity_list.append(similarity_matrix[idx][compare_idx])
                    user_predict[user][idx] = np.dot(food_list, similarity_list) / np.array(similarity_list).sum()
                
        return user_predict