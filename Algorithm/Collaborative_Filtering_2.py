import numpy as np
from sklearn.metrics import mean_squared_error

# method2. matrix의 value가 음수를 갖는 경우가 나타나는 경우를 예외처리한 후, 그 다음으로 오차가 적은 matrix를 도출하도록 하는 방식
# 결국에는 method1.의 확장버전(여러 matrix 결과를 확인하여 비교하는 꼴이 되어버림....)인듯

class CF2:
    def calculate_rmse(self, R, P, Q, non_zeros):                                                           # 실제 R 행렬과 예측 행렬의 오차를 구하는(rmse) 함수
        error = 0                                                                                           # 초기화

        full_pred_matrix = np.dot(P, Q.T)                                                                   # 예측 행렬

        # 여기서 non_zeros는 아래 함수에서 확인할 수 있다. R 행렬에 대하여.
        x_non_zero_ind = [non_zeros[0] for non_zeros in non_zeros]                                          #for / in format.
        y_non_zero_ind = [non_zeros[1] for non_zeros in non_zeros]

        # 원 행렬 R에서 0이 아닌 값들만 추출한다.
        R_non_zeros = R[x_non_zero_ind, y_non_zero_ind]                                                     #non_zero_ind를 행, 열의 위치에 넣으면 해당 행렬에 대한 non_zero 정보를 추출함.

        # 예측 행렬로부터 원 행렬 R에서 0이 아닌 위치의 값들만 추출하여 저장한다.
        full_pred_matrix_non_zeros = full_pred_matrix[x_non_zero_ind, y_non_zero_ind]

        mse = mean_squared_error(R_non_zeros, full_pred_matrix_non_zeros)                                   #mse calc.(자체 함수)
        rmse = np.sqrt(mse)

        return rmse                                                                                         #원행렬의 form과 최대한 작은 오차를 갖는 예측행렬을 calc하기 위함.(잠재요인 반영 P, Q행렬)


    def matrix_factorization(self, R, K, steps=200, learning_rate=0.01, r_lambda=0.01, random_step = 100):
        num_users, num_items = R.shape  # 행, 열


        # R>0인 행 위치, 열 위치, 값을 non_zeros 리스트에 저장한다.(정의)
        non_zeros = [ (i, j, R[i, j]) for i in range(num_users)                                             #3*~행렬 (row 0: i, row 1: j, row 2: R[i,j])
                    for j in range(num_items) if R[i, j] > 0 ]

        best_rmse = 100
        optimized_P = None
        optimized_Q = None 
        iter = 0                                                                                            #임의로 큰 값을 세팅해줌

        for step in range(random_step):                                                                     #여러개의 예측 행렬을 만들고, 각 행렬을 비교해 최적화
            check_error = 0                                                                                 #각 random_step마다 matrix value가 0이 되는지 check 용도 
            iter += 1
            # 정규분포를 따르는 무작위 행렬 생성 (K => 잠재요인의 개수)
            np.random.seed(iter)
            P = np.random.normal(loc = 1, scale=1.0/K, size=(num_users, K))                                 #scale: 정규분포의 scale / size: martix의 shape
            Q = np.random.normal(loc = 1, scale=1.0/K, size=(num_items, K))                                 #Q^T사용할거기때문에 변수 num_items, K로 설정.
            
            # SGD(경사하강법) 기법으로 P, Q 매트릭스를 업데이트 함
            for step in range(steps):                                                                       #행렬 update.
                for i, j, r in non_zeros:
                    # 실제 값-예측 값
                    eij = r - np.dot(P[i, :], Q[j, :].T)                                                    #실제행렬 - 예측행렬
                    P[i, :] = P[i, :] + learning_rate*(eij * Q[j, :])                                       #옮기는 rate는 상관 없음(SGD를 통해 움직이는 것은 동일하니까) ->식의 꼴에 대해서 비율을 무시하고 미분한 결과만을 반영한 format.
                    Q[j, :] = Q[j, :] + learning_rate*(eij * P[i, :])
            
            apprx_R = np.dot(P, Q.T)

            if np.any(apprx_R < 0) or np.any(apprx_R > 5) :
                continue
            else:
                rmse = self.calculate_rmse(R, P, Q, non_zeros)                                              #matrix value가 멀쩡하게 나오는 경우만 오차 비교에 사용.

                if rmse < best_rmse:                                                                        #최적의 matrix 찾기
                    best_rmse = rmse
                    optimized_P = P
                    optimized_Q = Q
                else:
                    continue;    
    
        pred_matrix = np.dot(optimized_P, optimized_Q.T)
        return pred_matrix, best_rmse

    # 메인 코드
    def execute(self, R):
        pred_matrix, rmse = self.matrix_factorization(R, K=3)                                                     #K(잠재요인 수) 값이 좀 작게 설정되긴 함...
        return pred_matrix, rmse
