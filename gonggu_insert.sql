INSERT INTO region (dong) VALUES ('daechidong');
INSERT INTO region (dong) VALUES ('yeoksamdong');
INSERT INTO region (dong) VALUES ('samjeondong');
SELECT * FROM region;

INSERT INTO customer (region_id, identification, password, name, address, phone) VALUES 
(1, 'GDSC001', 'pw123', 'John', '123 Gangnam-daero', '01012345678');

SELECT * FROM customer;

INSERT INTO product (name) VALUES ('apple');
INSERT INTO product (name) VALUES ('banana');
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

INSERT INTO gonggu_product (market_id, product_id, price) VALUES (1, 1, 30000);
INSERT INTO gonggu_product (market_id, product_id, price) VALUES (1, 2, 35000);
INSERT INTO gonggu_product (market_id, product_id, price) VALUES (2, 1, 31000);
SELECT * FROM gonggu_product;

INSERT INTO gonggu_group (gonggu_product_id, size) VALUES (1, 30);
SELECT * FROM gonggu_group;

INSERT INTO purchase (customer_id, gonggu_group_id) VALUES (1, 1);
SELECT * FROM purchase;

INSERT INTO product_like (customer_id, product_id) VALUES (1, 1);
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

SELECT * FROM keyword_market_link;