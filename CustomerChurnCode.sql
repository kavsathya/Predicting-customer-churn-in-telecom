use customerchurn;

select * from customerchurn;

alter table customerchurn change column `Tenure in months` Tenureinmonths VARCHAR(100);

# 1 Identify the total number of customers and the churn rate

# count of customers
SELECT count(customerID) as distinct_customers
FROM customerchurn;

ALTER TABLE customerchurn add churned int;
UPDATE customerchurn SET churned = CASE 
    when `customerstatus` = 'Churned' then 1
    when `customerstatus` = 'Stayed' then 0
    when `customerstatus` = 'Joined' then 0
END;

# churned rate
SELECT (sum(churned) / count(*)) * 100 as churnrate
FROM customerchurn;

# 2 average age of churned customers
SELECT (sum(age)/count(*)) as average_age
FROM customerchurn;

# 3	Discover the most common contract types among churned customers
SELECT 
    Contract,
    COUNT(*) AS Number_of_Churned_Customers
FROM 
    customerchurn
WHERE 
    Customerstatus = 'Churned'
GROUP BY 
    Contract
ORDER BY 
    Number_of_Churned_Customers desc;

# 4 Analyze the distribution of monthly charges among churned customers

SELECT 
    AVG(monthlycharge) AS average_monthly_charges,
    MIN(monthlycharge) AS minimum_monthly_charges,
    MAX(monthlycharge) AS maximum_monthly_charges,
	SUM(monthlycharge) AS sum_of_monthly_charges,
    STDDEV(monthlycharge) AS stddev_monthly_charges
FROM 
    customerchurn
WHERE 
    churned = 1;
    
# 5 Query to identify the contract types that are most prone to churn

SELECT 
    Contract,
    COUNT(*) AS Total_Customers,
    SUM(CASE WHEN Customerstatus = 'Churned' THEN 1 ELSE 0 END) AS Churned_Customers,
    (SUM(CASE WHEN Customerstatus = 'Churned' THEN 1 ELSE 0 END)/ COUNT(*)) * 100 AS Churn_Rate_Percent
FROM 
    customerchurn
GROUP BY 
    Contract
ORDER BY 
    Churn_Rate_Percent desc;
    
# 6 Identify customers with high total charges who have churned
    
SELECT 
    CustomerID, 
    TotalCharges
FROM 
    Customerchurn
WHERE 
    Customerstatus = 'Churned'
ORDER BY 
    Totalcharges desc;

# 7 The total charges distribution for churned and non-churned customers

SELECT 
    Customerstatus,
    COUNT(*) AS CustomerCount,
    AVG(Totalcharges) AS Avg_Total_Charges,
    MIN(Totalcharges) AS Min_Total_Charges,
    MAX(Totalcharges) AS Max_Total_Charges,
    SUM(Totalcharges) AS Sum_Total_Charges,
    STDDEV(monthlycharge) AS stddev_Total_charges
FROM 
    customerchurn
GROUP BY 
    Customerstatus
ORDER BY 
    Customercount desc;
    
# 8 The average monthly charges for different contract types among churned customers

SELECT 
    Contract AS Contract_type_churned,
    AVG(Monthlycharge) AS Avg_Monthly_Charges
FROM 
    customerchurn
WHERE 
    Customerstatus = 'Churned'
GROUP BY 
    Contract
ORDER BY 
    Avg_Monthly_Charges desc;
    
# 9 Identify customers who have both online security and online backup services and have not churned

    SELECT 
    CustomerID,
    Onlinesecurity,
    Onlinebackup,
    Customerstatus
FROM 
    customerchurn
WHERE 
    Onlinesecurity = 'Yes'
    AND Onlinebackup = 'Yes'
    AND Churned = 0
ORDER BY
    customerstatus;  

# 10  Determine the most common combinations of services among churned customers

SELECT 
    PhoneService,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtectionPlan,
    PremiumTechSupport,
    StreamingTV,
	StreamingMovies,
    StreamingMusic,
    UnlimitedData,
    COUNT(*) AS count
FROM 
    customerchurn
WHERE 
    churned = 1
GROUP BY 
    PhoneService,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtectionPlan,
    PremiumTechSupport,
    StreamingTV,
	StreamingMovies,
    StreamingMusic,
    UnlimitedData
ORDER BY 
    count desc;

# 11 Average total charges for customers grouped by gender and marital status
SELECT 
    gender,
    married,
    AVG(totalcharges) AS average_total_charges
FROM 
    customerchurn
GROUP BY 
    gender,
    married;
    
# 12 The average monthly charges for different age groups among churned customers
    
SELECT 
CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60 and above'
END AS age_group,
AVG(monthlycharge) AS average_monthly_charges
FROM 
    customerchurn
WHERE 
    churned = 1
GROUP BY 
    age_group
ORDER BY 
    age_group;

# 13 The average age and total charges for customers with multiple lines and online backup

SELECT 
    AVG(age) AS average_age,
    SUM(totalcharges) AS total_charges
FROM 
    customerchurn
WHERE 
    multiplelines = 'yes' AND
    onlinebackup = 'yes';
    
# 14 Identify the contract types with the highest churn rate among senior citizens (age 65 and over)

SELECT 
    Contract,
    (sum(churned) / count(*)) * 100 AS churnrate
FROM 
    customerchurn
WHERE 
    age >= 65
GROUP BY 
    Contract
ORDER BY 
    churnrate desc;
    
# 15 The average monthly charges for customers who have multiple lines and streaming TV
    
SELECT 
    AVG(monthlycharge) AS average_monthly_charges
FROM 
    customerchurn
WHERE 
    multiplelines = 'yes' AND 
    streamingtv = 'yes';
    
# 16 The customers who have churned and used the most online services 

SELECT 
    customerid,
    (CASE WHEN OnlineSecurity = 'yes' THEN 1 ELSE 0 END +
     CASE WHEN OnlineBackup = 'yes' THEN 1 ELSE 0 END +
     CASE WHEN StreamingTV = 'yes' THEN 1 ELSE 0 END +
     CASE WHEN StreamingMovies = 'yes' THEN 1 ELSE 0 END +
     CASE WHEN StreamingMusic = 'yes' THEN 1 ELSE 0 END ) AS total_online_services
FROM 
    customerchurn
WHERE 
    churned = 1
ORDER BY 
    total_online_services desc;
    
# 17 The average age and total charges for customers with different combinations of streaming services

SELECT 
    streamingtv,
    streamingmovies,
    streamingmusic,
    AVG(age) AS average_age,
    SUM(totalcharges) AS total_charges
FROM 
    customerchurn
GROUP BY 
    streamingtv,
    streamingmovies,
	streamingmusic
ORDER BY 
    total_charges desc;    
    
# 18 The gender distribution among customers who have churned and are on yearly contracts 

SELECT 
    gender,
    COUNT(*) AS number_of_customers
FROM 
    customerchurn
WHERE 
    churned = 1 and
    contract = 'One year'
GROUP BY 
    gender;

# 19 The average monthly charges and total charges for customers who have churned, grouped by contract type and internet service type

SELECT 
    contract,
    internettype,
    AVG(monthlycharge) AS average_monthly_charges,
    SUM(totalcharges) AS total_charges
FROM 
    customerchurn
WHERE 
    churned = 1
GROUP BY 
    contract,
    internettype
ORDER BY 
    contract,
    internettype;
    
# 20 The customers who have churned and are not using online services, and their average total charges

SELECT 
    AVG(totalcharges) AS average_total_charges
FROM 
    customerchurn
WHERE 
    churned = 1
    and onlinebackup = 'no'
    or onlinebackup = 'null'
    and onlinesecurity = 'no'
    or onlinesecurity = 'null';    
    
# 21 The average monthly charges and total charges for customers who have churned, grouped by the number of dependents

alter table customerchurn change column `Number of Dependents` NumberofDependents VARCHAR(100);

SELECT 
    NumberofDependents,
    AVG(monthlycharge) AS average_monthly_charges,
    SUM(totalcharges) AS total_charges
FROM 
    customerchurn
WHERE 
    churned = 1
GROUP BY 
    NumberofDependents;

# 22 The customers who have churned, and their contract duration in months (for monthly contracts)

SELECT 
    CustomerID,
    TenureinMonths as tenure_in_months
FROM 
    customerchurn
WHERE 
    Churned = 1 AND 
    Contract = 'Month-to-Month'
ORDER BY 
    tenure_in_months desc;

# 23 The average age and total charges for customers who have churned, grouped by internet service and phone service
    
SELECT 
    internetservice,
    phoneservice,
    AVG(age) AS average_age,
    SUM(totalcharges) AS total_charges
FROM 
    customerchurn
WHERE 
    churned = 1
GROUP BY 
    internetservice,
    phoneservice;
