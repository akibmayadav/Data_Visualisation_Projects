SELECT
 hour(Checkout) As Hour,
 date(CheckOut) AS Date, 
 COUNT(date(CheckOut)) AS TotalCheckouts
FROM
 spl3.x_transactionsExcludeNullCheckIns
GROUP BY date
ORDER BY date,hour
