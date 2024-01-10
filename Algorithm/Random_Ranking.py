import numpy as np
import pandas as pd

class RR:
    def execute(df):
        for i in range(5):
            session_list = df.loc[df['group'] == i, ['session_id', 'rating']]
            random_list = np.random.randint(1, 101, size = len(session_list)) / 100
            
            session_list['rating'] = session_list['rating'] + random_list
            
            session_list.sort_values(by = 'rating', ascending = False, inplace = True)
            
            if i == 0:
                result = session_list               
            else:
                result = pd.concat([result, session_list])
                
        return result['session_id']