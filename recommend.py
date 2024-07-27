import mysql.connector
import pandas as pd
from surprise import Dataset, Reader, SVD
from surprise.model_selection import train_test_split
from surprise import accuracy

try:
    # MySQL 데이터베이스에 연결
    db_connection = mysql.connector.connect(
        host="127.0.0.1",
        user="root",
        password="ghkdwlqls1!",
        database="myDatabase",
        port=3306 
    )

    cursor = db_connection.cursor()

    print("Database connection successful!")

except mysql.connector.Error as err:
    print(f"Error: {err}")

cursor = db_connection.cursor()

# 사용자가 찜한 마켓 정보 가져오기
cursor.execute("""
    SELECT customer_id, market_id 
    FROM market_like
""")
market_likes = cursor.fetchall()

# 사용자가 찜한 공동구매 상품 정보 가져오기
cursor.execute("""
    SELECT customer_id, gonggu_product_id 
    FROM product_like
""")
product_likes = cursor.fetchall()

# 공동구매 상품과 실제 상품 연결 정보 가져오기
cursor.execute("""
    SELECT id, product_id, market_id 
    FROM gonggu_product
""")
gonggu_products = cursor.fetchall()

# 마켓 키워드 정보 가져오기
cursor.execute("""
    SELECT kml.market_id, k.keyword 
    FROM keyword_market_link kml
    JOIN keyword k ON kml.keyword_id = k.id
""")
market_keywords = cursor.fetchall()

# 데이터프레임으로 변환
market_likes_df = pd.DataFrame(market_likes, columns=['customer_id', 'market_id'])
product_likes_df = pd.DataFrame(product_likes, columns=['customer_id', 'gonggu_product_id'])
gonggu_products_df = pd.DataFrame(gonggu_products, columns=['gonggu_product_id', 'product_id', 'market_id'])
market_keywords_df = pd.DataFrame(market_keywords, columns=['market_id', 'keyword'])

# surprise용 데이터셋 생성
reader = Reader(rating_scale=(1, 1))  # binary like (0 or 1)
data = Dataset.load_from_df(product_likes_df[['customer_id', 'gonggu_product_id']], reader)

# 데이터셋 분리
trainset, testset = train_test_split(data, test_size=0.25)

# SVD 알고리즘 사용
algo = SVD()
algo.fit(trainset)

# 모델 평가
predictions = algo.test(testset)
accuracy.rmse(predictions)


def get_user_preferred_keywords(customer_id):
    liked_markets = market_likes_df[market_likes_df['customer_id'] == customer_id]['market_id']
    preferred_keywords = market_keywords_df[market_keywords_df['market_id'].isin(liked_markets)]['keyword']
    keyword_weights = preferred_keywords.value_counts().to_dict()
    return keyword_weights

def get_user_preferred_products(customer_id):
    liked_gonggu_products = product_likes_df[product_likes_df['customer_id'] == customer_id]['gonggu_product_id']
    preferred_products = gonggu_products_df[gonggu_products_df['gonggu_product_id'].isin(liked_gonggu_products)]['product_id']
    product_weights = preferred_products.value_counts().to_dict()
    return product_weights

# 예시: 사용자 1의 선호 키워드와 상품
user_id = 1
preferred_keywords = get_user_preferred_keywords(user_id)
preferred_products = get_user_preferred_products(user_id)
print(preferred_keywords)
print(preferred_products)

def recommend_gonggu_products_ml(user_id, n=5):
    # 모든 공동구매 상품 ID 가져오기
    all_gonggu_product_ids = gonggu_products_df['gonggu_product_id'].unique()
    
    # 사용자에 대해 모든 공동구매 상품에 대한 예상 평점 계산
    predictions = [algo.predict(user_id, gp_id) for gp_id in all_gonggu_product_ids]
    
    # 예상 평점 기준으로 상위 N개의 공동구매 상품 추천
    top_n_predictions = sorted(predictions, key=lambda x: x.est, reverse=True)[:n]
    recommended_gonggu_product_ids = [pred.iid for pred in top_n_predictions]
    
    return recommended_gonggu_product_ids

# 예시: 사용자 1에게 추천할 공동구매 상품
user_id = 1
recommended_gonggu_products = recommend_gonggu_products_ml(user_id)
print(recommended_gonggu_products)
