CREATE table last_year_trx(
    merchant_id varchar(10), live_date date, last_trx_date date
);

CREATE table this_year_trx(
    trx_id int, trx_date date, merchant_id varchar(10), trx_status varchar(10), total_items int, total_revenue int, total_revenue_after_discount int

);

BULK INSERT this_year_trx
   FROM '/var/opt/mssql/backup/this_year_trx.csv'
   WITH
      (
        FORMAT='CSV'
        , FIRSTROW=2
      );

--OVERALL--
SELECT DISTINCT merchant_id, COUNT(trx_status)
FROM this_year_trx
WHERE (merchant_id NOT IN 
   (SELECT DISTINCT merchant_id 
    FROM last_year_trx)) AND (trx_status = 'Successful') 
GROUP BY merchant_id; 

--PER KOTA--
--A01--
SELECT DISTINCT merchant_id, COUNT(trx_status)
FROM this_year_trx
WHERE (merchant_id NOT IN 
   (SELECT DISTINCT merchant_id 
    FROM last_year_trx)) AND (trx_status = 'Successful') AND merchant_id LIKE 'A01%'
GROUP BY merchant_id; 

--A02--
SELECT DISTINCT merchant_id, COUNT(trx_status)
FROM this_year_trx
WHERE (merchant_id NOT IN 
   (SELECT DISTINCT merchant_id 
    FROM last_year_trx)) AND (trx_status = 'Successful') AND merchant_id LIKE 'A02%'
GROUP BY merchant_id; 

--A03--
SELECT DISTINCT merchant_id, COUNT(trx_status)
FROM this_year_trx
WHERE (merchant_id NOT IN 
   (SELECT DISTINCT merchant_id 
    FROM last_year_trx)) AND (trx_status = 'Successful') AND merchant_id LIKE 'A03%'
GROUP BY merchant_id; 

--PER BULAN--
--bulan pertama--
SELECT DISTINCT merchant_id, COUNT(trx_status)
FROM this_year_trx
WHERE (merchant_id NOT IN 
   (SELECT DISTINCT merchant_id 
    FROM last_year_trx)) AND (trx_status = 'Successful') AND trx_date >= '2020-01-01' AND trx_date <= '2020-01-31'
GROUP BY merchant_id; 

--bulan kedua--
SELECT DISTINCT merchant_id, COUNT(trx_status)
FROM this_year_trx
WHERE (merchant_id NOT IN 
   (SELECT DISTINCT merchant_id 
    FROM last_year_trx)) AND (trx_status = 'Successful') AND trx_date >= '2020-02-01' AND trx_date <= '2020-02-31'
GROUP BY merchant_id; 

--Churn--
SELECT DISTINCT ly.merchant_id
FROM last_year_trx ly 
WHERE ly.merchant_id NOT IN (SELECT DISTINCT merchant_id 
    FROM this_year_trx WHERE trx_status = 'Successful') 

SELECT DISTINCT merchant_id
FROM last_year_trx

SELECT ly.merchant_id, COUNT(*)
FROM last_year_trx ly
WHERE ly.merchant_id IN
(
    SELECT ty.merchant_id
    FROM this_year_trx ty
    WHERE ty.trx_status='Successful'
    )
GROUP BY merchant_id
ORDER BY merchant_id

--kota 01ct--
SELECT ly.merchant_id, COUNT(*)
FROM last_year_trx ly
WHERE (ly.merchant_id IN
(
    SELECT ty.merchant_id
    FROM this_year_trx ty
    WHERE ty.trx_status='Successful'
    )) AND merchant_id LIKE '%01CT%'
GROUP BY merchant_id
ORDER BY merchant_id

--kota 02ct--
SELECT ly.merchant_id, COUNT(*)
FROM last_year_trx ly
WHERE (ly.merchant_id IN
(
    SELECT ty.merchant_id
    FROM this_year_trx ty
    WHERE ty.trx_status='Successful'
    )) AND merchant_id LIKE '%02CT%'
GROUP BY merchant_id
ORDER BY merchant_id

--kota 03ct--
SELECT ly.merchant_id, COUNT(*)
FROM last_year_trx ly
WHERE (ly.merchant_id IN
(
    SELECT ty.merchant_id
    FROM this_year_trx ty
    WHERE ty.trx_status='Successful'
    )) AND merchant_id LIKE '%03CT%'
GROUP BY merchant_id
ORDER BY merchant_id

--Discount--
--overall--
SELECT COUNT(*)
FROM
(SELECT DISTINCT merchant_id
FROM this_year_trx) AS Total

SELECT COUNT(*)
FROM
(SELECT DISTINCT merchant_id 
FROM  this_year_trx 
WHERE total_revenue_after_discount < total_revenue) AS Diskon

--kota 01ct--
SELECT COUNT(*)
FROM
(SELECT DISTINCT merchant_id 
FROM  this_year_trx 
WHERE total_revenue_after_discount < total_revenue AND merchant_id LIKE '%01CT%') AS Diskon

--kota 02ct--
SELECT COUNT(*)
FROM
(SELECT DISTINCT merchant_id 
FROM  this_year_trx 
WHERE total_revenue_after_discount < total_revenue AND merchant_id LIKE '%02CT%') AS Diskon

--kota 03ct--
SELECT COUNT(*)
FROM
(SELECT DISTINCT merchant_id 
FROM  this_year_trx 
WHERE total_revenue_after_discount < total_revenue AND merchant_id LIKE '%03CT%') AS Diskon





