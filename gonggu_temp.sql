INSERT INTO region (dong) VALUES ('daechidong');
INSERT INTO region (dong) VALUES ('yeoksamdong');
INSERT INTO region (dong) VALUES ('samjeondong');
SELECT * FROM region;

INSERT INTO customer (region_id, identification, password, name, address, phone) VALUES 
(1, 'GDSC001', 'pw123', 'John', '123 Gangnam-daero', '01012345678');

SELECT * FROM customer;

INSERT INTO product (name) VALUES ('고구마');
INSERT INTO product (name) VALUES ('밀가루');
INSERT INTO product (name) VALUES ('사과');
INSERT INTO product (name) VALUES ('바나나');
INSERT INTO product (name) VALUES ('포도');
INSERT INTO product (name) VALUES ('양파');
INSERT INTO product (name) VALUES ('감자');
INSERT INTO product (name) VALUES ('상추');
INSERT INTO product (name) VALUES ('브로콜리');
INSERT INTO product (name) VALUES ('당근');

SELECT * FROM product;

DELIMITER $$

CREATE PROCEDURE insert_markets()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 30 DO
        SET @market_name = CONCAT('M', i);
        INSERT INTO market (name) VALUES (@market_name);
        SET i = i + 1;
    END WHILE;
END $$

DELIMITER ;

CALL insert_markets();

SELECT * FROM market; # 30개 market 만들기

# CSV로 import -> github의 csv 파일 참고
SELECT * FROM gonggu_product;

INSERT INTO gonggu_group (gonggu_product_id, size) VALUES (1, 30);
SELECT * FROM gonggu_group;

INSERT INTO purchase (customer_id, gonggu_group_id) VALUES (1, 1);
SELECT * FROM purchase;

INSERT INTO product_like (customer_id, gonggu_product_id) VALUES (1, 4);
INSERT INTO product_like (customer_id, gonggu_product_id) VALUES (1, 7);
INSERT INTO product_like (customer_id, gonggu_product_id) VALUES (1, 32);
INSERT INTO product_like (customer_id, gonggu_product_id) VALUES (1, 50);
INSERT INTO product_like (customer_id, gonggu_product_id) VALUES (1, 52);
INSERT INTO product_like (customer_id, gonggu_product_id) VALUES (1, 60);
SELECT * FROM product_like;

INSERT INTO market_like (customer_id, market_id) VALUES (1, 1);
INSERT INTO market_like (customer_id, market_id) VALUES (1, 5);
INSERT INTO market_like (customer_id, market_id) VALUES (1, 8);
SELECT * FROM market_like;

INSERT INTO region_market_link (region_id, market_id) VALUES (1, 1);
SELECT * FROM region_market_link;

INSERT INTO keyword (keyword) VALUES ('신선도보장');
INSERT INTO keyword (keyword) VALUES ('무농약');
INSERT INTO keyword (keyword) VALUES ('유기농');
INSERT INTO keyword (keyword) VALUES ('친환경');
INSERT INTO keyword (keyword) VALUES ('산지직송');
INSERT INTO keyword (keyword) VALUES ('국내산');
INSERT INTO keyword (keyword) VALUES ('품질보증');
INSERT INTO keyword (keyword) VALUES ('로컬푸드');
INSERT INTO keyword (keyword) VALUES ('직접재배');
INSERT INTO keyword (keyword) VALUES ('빠른배송');
SELECT * FROM keyword;

# csv로 import -> github csv 파일 참고
SELECT * FROM keyword_market_link;