Create database if not exists bank_loan_analysis;
Use bank_loan_analysis;
Drop Table if exists bank_loan;
CREATE TABLE bank_loan (
    age DOUBLE,
    gender VARCHAR(20),
    education VARCHAR(50),
    income DOUBLE,
    employment_experience INT,
    home_ownership VARCHAR(30),
    loan_amount DOUBLE,
    loan_purpose VARCHAR(50),
    interest_rate DOUBLE,
    loan_to_income_ratio DOUBLE,
    credit_history_years INT,
    credit_score INT,
    previous_defaults VARCHAR(10),
    loan_status INT,
    loan_status_label VARCHAR(20)
);
DESCRIBE bank_loan;
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

Select Count(*) As total_rows
From bank_loan;

USE bank_loan_analysis;
LOAD DATA LOCAL INFILE
'C:/Users/HP/Desktop/Projects For Data Analyst Profile/Bank_Loan_Risk_Analytics/02_Clean_data/bank_loan_cleaned_final.csv'
INTO TABLE bank_loan
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

Select count(*) As total_rows
from bank_loan;

Select * 
From bank_loan
Limit 5;

Select count(*) As total_loan_records
from bank_loan;

Select
Round(Sum(loan_amount),2) As total_loan_amount
from bank_loan;

Select
Round(Avg(loan_amount),2) As average_loan_amount
from bank_loan;

Select
count(*) As total_loans,
Sum(case when loan_status = 1 Then 1 Else 0 End) As defaulted_loans,
Round(
100.0 * Sum(Case When loan_status = 1 Then 1 Else 0 End)
/ Count(*),
2
)
As default_rate_percentage
from bank_loan;

SELECT
    loan_status_label,
    COUNT(*) AS number_of_loans,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_of_total
FROM bank_loan
GROUP BY loan_status_label
ORDER BY number_of_loans DESC;

SELECT
    loan_purpose,
    COUNT(*) AS total_applications,
    ROUND(SUM(loan_amount), 2) AS total_loan_amount,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM bank_loan
GROUP BY loan_purpose
ORDER BY total_applications DESC;

Select
loan_purpose,
count(*) As total_loans,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS defaulted_loans,
Round(
100.0 * Sum(Case When loan_status = 1 Then 1 Else 0 End)
/Count(*),
2
) As default_rate_percentage
From bank_loan
group by loan_purpose
Order by Default_rate_percentage Desc;

Select
home_ownership,
Count(*) As total_borrowers,
Sum(Case when loan_status = 1 Then 1 Else 0 End) As defaulted_borrowers,
Round(
100.0 * Sum(Case When loan_status = 1 Then 1 Else 0 End)
/ Count(*),
2
) As default_rate_percentage
from bank_loan
group by home_ownership
order by default_rate_percentage Desc;

Select 
Loan_Status_label,
Round(Avg(age),2) As average_age,
ROUND(AVG(income), 2) AS average_income,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount,
    ROUND(AVG(interest_rate), 2) AS average_interest_rate,
    ROUND(AVG(credit_score), 2) AS average_credit_score,
    ROUND(AVG(loan_to_income_ratio), 2) AS average_loan_to_income_ratio
FROM bank_loan
GROUP BY loan_status_label;

SELECT
    previous_defaults,
    COUNT(*) AS total_borrowers,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS current_defaults,
    ROUND(
        100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS current_default_rate_percentage
FROM bank_loan
GROUP BY previous_defaults
ORDER BY current_default_rate_percentage DESC;

Select 
education,
Count(*) As total_borrowers,
Sum(Case When loan_status = 1 Then 1 Else 0 End) As defaulted_borrowers,
Round(
100.0 * Sum(Case When loan_status = 1 Then 1 Else 0 End)/ Count(*),
2
)
As default_rate_percentage
from bank_loan 
Group By education
Order by default_rate_percentage Desc;

Select 
gender,
Count(*) As total_borrowers,
Sum(Case When Loan_status = 1 Then 1 Else 0 End) As defaulted_borrowers,
Round( 
100.0 * Sum(Case When loan_status = 1 Then 1 Else 0 End)/ Count(*),
2
) As default_rate_percentage
From bank_loan 
Group by gender
Order by default_rate_percentage Desc;

SELECT
    CASE
        WHEN credit_score < 580 THEN 'Poor'
        WHEN credit_score BETWEEN 580 AND 669 THEN 'Fair'
        WHEN credit_score BETWEEN 670 AND 739 THEN 'Good'
        WHEN credit_score BETWEEN 740 AND 799 THEN 'Very Good'
        ELSE 'Excellent'
    END AS credit_score_band,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(credit_score), 2) AS average_credit_score
FROM bank_loan
GROUP BY credit_score_band
ORDER BY MIN(credit_score);

SELECT
    CASE
        WHEN credit_score < 580 THEN 'Poor'
        WHEN credit_score BETWEEN 580 AND 669 THEN 'Fair'
        WHEN credit_score BETWEEN 670 AND 739 THEN 'Good'
        WHEN credit_score BETWEEN 740 AND 799 THEN 'Very Good'
        ELSE 'Excellent'
    END AS credit_score_band,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS defaulted_loans,
    ROUND(
        100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS default_rate_percentage
FROM bank_loan
GROUP BY credit_score_band
ORDER BY default_rate_percentage DESC;

Select 
Case
When income < 30000 Then 'Low Income'
When income Between 30000 And 59999 Then 'Lower-Middle Income'
WHEN income BETWEEN 60000 AND 99999 THEN 'Middle Income'
WHEN income BETWEEN 100000 AND 149999 THEN 'Upper-Middle Income'
Else 'High Income'
End as income_segment,
Count(*) As total_borrowers,
Round(Avg(Income),2) As average_income,
Round(
100.0 * Sum(Case When loan_status = 1 Then 1 Else 0 End) / Count(*),
2
)
As default_rate_percentage
from bank_loan 
Group By income_segment
Order by average_income;

SELECT
    CASE
        WHEN loan_amount < 5000 THEN 'Small Loan'
        WHEN loan_amount BETWEEN 5000 AND 14999 THEN 'Medium Loan'
        WHEN loan_amount BETWEEN 15000 AND 24999 THEN 'Large Loan'
        ELSE 'Very Large Loan'
    END AS loan_size_segment,
    COUNT(*) AS total_loans,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount,
    ROUND(
        100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS default_rate_percentage
FROM bank_loan
GROUP BY loan_size_segment
ORDER BY average_loan_amount;

Select 
Case
When interest_rate < 8 Then 'Low Rate'
When interest_rate Between 8 and 12 Then 'Moderate Rate'
When interest_rate Between 12.01 And 16 Then 'High Rate'
Else 'Very High Rate'
End as interest_rate_band,
Count(*) As total_loans,
Round(Avg(interest_rate),2) As average_interest_rate,
Round(
100.0 * Sum(Case When loan_status = 1 Then 1 Else 0 End) / Count(*),
2
)
As default_rate_percentage
From bank_loan
Group By interest_rate_band
Order by average_interest_rate;

SELECT
    CASE
        WHEN loan_to_income_ratio < 0.10 THEN 'Very Low'
        WHEN loan_to_income_ratio BETWEEN 0.10 AND 0.20 THEN 'Low'
        WHEN loan_to_income_ratio BETWEEN 0.21 AND 0.35 THEN 'Moderate'
        WHEN loan_to_income_ratio BETWEEN 0.36 AND 0.50 THEN 'High'
        ELSE 'Very High'
    END AS lti_risk_band,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(loan_to_income_ratio), 2) AS average_ratio,
    ROUND(
        100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS default_rate_percentage
FROM bank_loan
GROUP BY lti_risk_band
ORDER BY average_ratio;

SELECT
    CASE
        WHEN age < 25 THEN 'Under 25'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55 and Above'
    END AS age_group,
    COUNT(*) AS total_borrowers,
    ROUND(AVG(age), 2) AS average_age,
    ROUND(
        100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS default_rate_percentage
FROM bank_loan
GROUP BY age_group
ORDER BY MIN(age);

SELECT
    age,
    gender,
    income,
    loan_amount,
    loan_purpose,
    interest_rate,
    loan_to_income_ratio,
    credit_score,
    previous_defaults,
    loan_status_label
FROM bank_loan
WHERE credit_score < 600
  AND loan_to_income_ratio > 0.35
  AND interest_rate > 12
ORDER BY loan_to_income_ratio DESC, interest_rate DESC
LIMIT 50;

WITH purpose_risk AS (
    SELECT
        loan_purpose,
        COUNT(*) AS total_loans,
        SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS defaulted_loans,
        ROUND(
            100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END)
            / COUNT(*),
            2
        ) AS default_rate_percentage
    FROM bank_loan
    GROUP BY loan_purpose
)
SELECT
    loan_purpose,
    total_loans,
    defaulted_loans,
    default_rate_percentage,
    DENSE_RANK() OVER (
        ORDER BY default_rate_percentage DESC
    ) AS risk_rank
FROM purpose_risk
ORDER BY risk_rank;

WITH ownership_risk AS (
    SELECT
        home_ownership,
        COUNT(*) AS total_borrowers,
        ROUND(
            100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END)
            / COUNT(*),
            2
        ) AS default_rate_percentage
    FROM bank_loan
    GROUP BY home_ownership
)
SELECT
    home_ownership,
    total_borrowers,
    default_rate_percentage,
    DENSE_RANK() OVER (
        ORDER BY default_rate_percentage DESC
    ) AS risk_rank
FROM ownership_risk
ORDER BY risk_rank;

With ranked_loans As(
Select
loan_purpose,
age,
gender,
income,
loan_amount,
interest_rate,
credit_score,
loan_status_label,
Row_Number() Over (
Partition By loan_purpose
Order by loan_amount Desc
)
As loan_rank
From bank_loan
)
Select *
From ranked_loans
Where loan_rank <= 5
Order by loan_purpose, loan_rank;

SELECT
    loan_purpose,
    loan_amount,
    ROUND(
        AVG(loan_amount) OVER (
            PARTITION BY loan_purpose
        ),
        2
    ) AS purpose_average_loan,
    ROUND(
        loan_amount -
        AVG(loan_amount) OVER (
            PARTITION BY loan_purpose
        ),
        2
    ) AS difference_from_average
FROM bank_loan
ORDER BY loan_purpose, loan_amount DESC
LIMIT 100;

Select
loan_amount,
loan_purpose,
loan_status_label,
Round(
Sum(loan_amount) Over(
Order by loan_amount
Rows Between UNBOUNDED PRECEDING AND CURRENT ROW
),
2
)
As running_total_loan_amount
From bank_loan 
order by loan_amount
Limit 100;

SELECT
    age,
    income,
    loan_amount,
    interest_rate,
    loan_to_income_ratio,
    credit_score,
    previous_defaults,
    loan_status_label,
    (
        CASE WHEN credit_score < 600 THEN 2 ELSE 0 END
        + CASE WHEN loan_to_income_ratio > 0.35 THEN 2 ELSE 0 END
        + CASE WHEN interest_rate > 12 THEN 1 ELSE 0 END
        + CASE WHEN income < 30000 THEN 1 ELSE 0 END
        + CASE WHEN previous_defaults = 'Yes' THEN 2 ELSE 0 END
    ) AS risk_score,
    CASE
        WHEN (
            CASE WHEN credit_score < 600 THEN 2 ELSE 0 END
            + CASE WHEN loan_to_income_ratio > 0.35 THEN 2 ELSE 0 END
            + CASE WHEN interest_rate > 12 THEN 1 ELSE 0 END
            + CASE WHEN income < 30000 THEN 1 ELSE 0 END
            + CASE WHEN previous_defaults = 'Yes' THEN 2 ELSE 0 END
        ) >= 5 THEN 'High Risk'

        WHEN (
            CASE WHEN credit_score < 600 THEN 2 ELSE 0 END
            + CASE WHEN loan_to_income_ratio > 0.35 THEN 2 ELSE 0 END
            + CASE WHEN interest_rate > 12 THEN 1 ELSE 0 END
            + CASE WHEN income < 30000 THEN 1 ELSE 0 END
            + CASE WHEN previous_defaults = 'Yes' THEN 2 ELSE 0 END
        ) BETWEEN 3 AND 4 THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS risk_category
FROM bank_loan
ORDER BY risk_score DESC
Limit 100;

WITH borrower_risk AS (
    SELECT
        loan_status,
        (
            CASE WHEN credit_score < 600 THEN 2 ELSE 0 END
            + CASE WHEN loan_to_income_ratio > 0.35 THEN 2 ELSE 0 END
            + CASE WHEN interest_rate > 12 THEN 1 ELSE 0 END
            + CASE WHEN income < 30000 THEN 1 ELSE 0 END
            + CASE WHEN previous_defaults = 'Yes' THEN 2 ELSE 0 END
        ) AS risk_score
    FROM bank_loan
),

risk_labels AS (
    SELECT
        loan_status,
        CASE
            WHEN risk_score >= 5 THEN 'High Risk'
            WHEN risk_score BETWEEN 3 AND 4 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS risk_category
    FROM borrower_risk
)

SELECT
    risk_category,
    COUNT(*) AS total_borrowers,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS defaulted_borrowers,
    ROUND(
        100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS default_rate_percentage
FROM risk_labels
GROUP BY risk_category
ORDER BY default_rate_percentage DESC;  


WITH purpose_portfolio AS (
    SELECT
        loan_purpose,
        SUM(loan_amount) AS purpose_loan_amount
    FROM bank_loan
    GROUP BY loan_purpose
)
SELECT
    loan_purpose,
    ROUND(purpose_loan_amount, 2) AS purpose_loan_amount,
    ROUND(
        100.0 * purpose_loan_amount
        / SUM(purpose_loan_amount) OVER (),
        2
    ) AS portfolio_share_percentage
FROM purpose_portfolio
ORDER BY portfolio_share_percentage DESC;     


Select 
loan_purpose,
loan_amount,
income,
credit_score,
loan_status_label,
Round( 
Percent_Rank() Over(
Order By loan_amount
) * 100,
2
) As loan_amount_percentile
From bank_loan
Order by loan_amount Desc
Limit 100;   

SELECT
    COUNT(*) AS total_loans,
    ROUND(SUM(loan_amount), 2) AS total_portfolio_value,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount,
    ROUND(AVG(interest_rate), 2) AS average_interest_rate,
    ROUND(AVG(credit_score), 2) AS average_credit_score,
    SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END) AS total_defaults,
    ROUND(
        100.0 * SUM(CASE WHEN loan_status = 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS overall_default_rate,
    SUM(
        CASE
            WHEN credit_score < 600
             AND loan_to_income_ratio > 0.35
             AND interest_rate > 12
            THEN 1
            ELSE 0
        END
    ) AS high_risk_borrowers,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN credit_score < 600
                 AND loan_to_income_ratio > 0.35
                 AND interest_rate > 12
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS high_risk_borrower_percentage
FROM bank_loan;