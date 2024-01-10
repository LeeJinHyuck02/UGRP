import numpy as np
from sklearn.metrics import mean_squared_error

# method1. 애초에 예측행렬의 element에 대하여 범위 조건을 적용한 뒤 MF를 진행하는 방식

# np.random.normal을 수행할 때 loc, scale은 바꿀 수 있음. 대신, scale 값이 너무 크면 오류 발생.
# 마찬가지로 K의 값도 바꿀 수 있음.(잠재 요인의 개수)

# K의 값이 큰 경우 np.dot의 값을 생각하면, random으로 생성되는 matrix의 값이 작도록 정규분포를 설정해야하거나, 계산한 matrix에 대하여 일정한 값을 나누어주어야 할듯.

class CF1:
    def matrix_factorization(self, R, K, steps=50, learning_rate=0.01):
        num_users, num_items = R.shape                                                  # 행, 열

        P = np.random.normal(loc = 1, scale=1.0/K, size=(num_users, K))                 # 왜 scale이 1.0/K인가?
        Q = np.random.normal(loc = 1, scale=1.0/K, size=(num_items, K))
        
        # 정규분포를 따르는 무작위 행렬 생성 (K => 잠재요인의 개수)
        P = np.random.normal(loc = 1, scale=1.0/K, size=(num_users, K))                 # 왜 scale이 1.0/K인가?
        Q = np.random.normal(loc = 1, scale=1.0/K, size=(num_items, K))                 # Q^T사용할거기때문에 변수 num_items, K로 설정.

        non_zeros = [(i, j, R[i, j]) for i in range(num_users)                          # 3*~행렬 (row 0: i, row 1: j, row 2: R[i,j])
                    for j in range(num_items) if R[i, j] > 0 ]

        # SGD(경사하강법) 기법으로 P, Q 매트릭스를 업데이트 함
        for step in range(steps):
            for i, j, r in non_zeros:
                eij = r - np.dot(P[i, :], Q[j, :].T)                                    # 실제행렬 - 예측행렬
                # Regulation을 반영한 SGD 업데이터 적용
                P[i, :] = P[i, :] + learning_rate*(eij * Q[j, :])                       # 옮기는 rate는 상관 없음(SGD를 통해 움직이는 것은 동일하니까) ->식의 꼴에 대해서 비율을 무시하고 미분한 결과만을 반영한 format.
                Q[j, :] = Q[j, :] + learning_rate*(eij * P[i, :])

        pred_matrix = np.dot(P, Q.T)
                    
        return pred_matrix

    # 메인 코드
    def execute(self, R):
        pred_matrix = self.matrix_factorization(R, K=5)
        return pred_matrix



