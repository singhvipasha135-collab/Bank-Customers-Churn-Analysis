create database Bank_Churn;
use Bank_Churn;
# DATA CLEANING
#TOTAL ROW CHECK
Select count(*) as total_rows
from churn_modelling;

# DATA TYPE CHECK
DESCRIBE churn_modelling;

# NULL VALUE CHECK
SELECT *FROM churn_modelling
WHERE CustomerId IS NULL
OR Surname IS NULL
OR CreditScore IS NULL
OR Geography IS NULL
OR Gender IS NULL
OR Age IS NULL
OR Tenure IS NULL
OR Balance IS NULL
OR NumOfProducts IS NULL
 OR HasCrCard IS NULL
 OR IsActiveMember IS NULL
OR EstimatedSalary IS NULL
OR Exited IS NULL;
#DUBLICATE VALUE CHRCK
select CustomerId, COUNT(*) as duplicate_count
from churn_modelling
GROUP BY CustomerId
HAVING COUNT(*) > 1;

#SPECIAL CHRACTER CHECK
SELECT *
FROM churn_modelling
WHERE Surname LIKE '%?%';

SELECT COUNT(*) AS Question_Mark_Count
FROM churn_modelling
WHERE Surname LIKE '%?%';

SELECT DISTINCT Surname
FROM churn_modelling
WHERE Surname LIKE '%?%';

#categrical value check
select distinct Geography
from churn_modelling;
select distinct Gender
FROM churn_modelling;

# INVALID VALUE check 
SELECT * FROM churn_modelling
WHERE CreditScore < 300 OR CreditScore > 850
   OR Age < 18 OR Age > 100
   OR Tenure < 0 OR Tenure > 10
   OR Balance < 0
   OR NumOfProducts < 1 OR NumOfProducts > 4
   OR HasCrCard NOT IN (0, 1)
   OR IsActiveMember NOT IN (0, 1)
   OR Exited NOT IN (0, 1);

# NO.OF CUSTOMER COUNT
SELECT Geography, COUNT(*) AS Customer_Count
FROM churn_modelling
GROUP BY Geography;

SELECT Gender, COUNT(*) AS Customer_Count
FROM churn_modelling
GROUP BY Gender;

SELECT Exited, COUNT(*) AS Customer_Count
FROM churn_modelling
GROUP BY Exited;

# outlier check
SELECT 
    MIN(CreditScore) AS MinCreditScore,
    MAX(CreditScore) AS MaxCreditScore,
    
    MIN(Age) AS MinAge,
    MAX(Age) AS MaxAge,
    
    MIN(Balance) AS MinBalance,
    MAX(Balance) AS MaxBalance,

    MIN(EstimatedSalary) AS MinEstimatedSalary,
    MAX(EstimatedSalary) AS MaxEstimatedSalary,
    
    MIN(Tenure) AS MINTenure,
    MAX(Tenure) AS MAXTenure
FROM churn_modelling;

#extra space check
SELECT * FROM churn_modelling
WHERE Geography <> TRIM(Geography);
SELECT * FROM churn_modelling
WHERE Gender <> TRIM(Gender);

# CHANGE COLUMN NAME
ALTER TABLE churn_modelling
CHANGE COLUMN ï»¿RowNumber RowNumber INT;

# DATA VALIDATION
# TOTAL ROW RECHECK
SELECT COUNT(*) AS Total_Rows
FROM churn_modelling;   

# INVALIDE VALUE RECHECK
SELECT * FROM churn_modelling
WHERE CreditScore < 300 OR CreditScore > 850
OR Age < 18 OR Age > 100
OR Tenure < 0 OR Tenure > 10
OR Balance < 0
OR NumOfProducts < 1 OR NumOfProducts > 4
OR HasCrCard NOT IN (0, 1)
OR IsActiveMember NOT IN (0, 1)
OR Exited NOT IN (0, 1)
OR EstimatedSalary < 0;

# DATA  ROW RECHECK
SELECT count(*)
FROM churn_modelling;

# ANALIYSIS
# 1.What is the overall churn rate?
SELECT 
    COUNT(*) AS TotalCustomers,
    SUM(Exited) AS ChurnCustomers,
    ROUND(SUM(Exited) * 100.0 / COUNT(*), 2) AS ChurnRate
FROM churn_modelling; 

#2-Which age groups have the highest churn? 
SELECT 
     CASE 
	WHEN Age < 30 THEN 'Young'
	WHEN Age BETWEEN 30 AND 50 THEN 'Middle-aged'
	ELSE 'Senior'
	END AS AgeGroup,
	COUNT(CustomerId) AS ChurnCustomers
	FROM churn_modelling
	WHERE Exited = 1
	GROUP BY 
	CASE 
	WHEN Age < 30 THEN 'Young'
	WHEN Age BETWEEN 30 AND 50 THEN 'Middle-aged'
	ELSE 'Senior'
	END
	ORDER BY ChurnCustomers DESC;
 
#3.Which balance group has the highest customer churn?
SELECT
    CASE
	WHEN Balance = 0 THEN 'Zero Balance'
	WHEN Balance <= 50000 THEN 'Low Balance'
	WHEN Balance <= 100000 THEN 'Medium Balance'
    ELSE 'High Balance'
    END AS Balance_Group,
  COUNT(CustomerId) AS Churn_Customers
  FROM churn_modelling
 WHERE Exited = 1
 GROUP BY Balance_Group
 ORDER BY Churn_Customers DESC;

#4-Is churn higher in certain geographies (France, Spain, Germany)? 
SELECT Geography,
   SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnCustomers
FROM churn_modelling
GROUP BY Geography
ORDER BY ChurnCustomers DESC;

#5-Do inactive members churn more than active members?  
SELECT 
    CASE 
        WHEN IsActiveMember = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS MemberStatus,
    SUM(Exited) AS ChurnCustomers
FROM churn_modelling
GROUP BY MemberStatus
ORDER BY ChurnCustomers DESC;