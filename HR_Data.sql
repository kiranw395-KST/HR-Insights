

create database HRDataset

use HRDataset

select * from HRData

-- attrition count by department
SELECT 
    (COUNT(CASE WHEN EmploymentStatus <> 'Active' THEN 1 END) * 100.0 / COUNT(*)) AS Attrition_Percentage
FROM HRData

select * from HRData

SELECT Department,
       COUNT(*) AS Total_Employees,
       SUM(CASE WHEN EmploymentStatus <> 'Active' THEN 1 ELSE 0 END) AS Attrition_Count,
       (SUM(CASE WHEN EmploymentStatus <> 'Active' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Attrition_Percentage
FROM HRData
GROUP BY Department
ORDER BY Attrition_Percentage DESC;

SELECT TermReason, COUNT(*) AS Count
FROM HRData
WHERE EmploymentStatus <> 'Active'
GROUP BY TermReason
ORDER BY Count DESC;

--Avg tenure at company
select 
     AVG(datediff(YEAR,DateofHire, ISNULL(dateoftermination, GETDATE()))) as AVG_Tenure
from HRData;

--Avg salary 
select Department, AVG(Salary) as AVG_Salary
from HRData
Group by Department
order by AVG_Salary desc;

--Salry distribution by poistion
select Position, MIN(Salary) as MIN_Salary, MAX(Salary) as MAX_Salary, AVG(Salary) as Avg_Salary
from HRData
Group by Position
order by Avg_Salary desc;

--gender ratio in company
select Department, SEX, COUNT(*) as Sex_ratio
from HRData
group by Department, Sex
order by Sex_ratio desc;

-- Age bands
SELECT 
    CASE 
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) < 30 THEN 'Under 30'
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 30 AND 40 THEN '30-40'
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'
    END AS Age_Band,
    COUNT(*) AS Employee_Count
FROM HRData
GROUP BY 
    CASE 
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) < 30 THEN 'Under 30'
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 30 AND 40 THEN '30-40'
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'
    END;

    -- Performance score distribution
SELECT PerformanceScore, COUNT(*) AS Employee_Count
FROM HRData
GROUP BY PerformanceScore;

-- Average engagement survey score by department
SELECT Department, AVG(EngagementSurvey) AS Avg_Engagement
FROM HRData
GROUP BY Department
ORDER BY Avg_Engagement DESC;

-- Employee satisfaction by manager
SELECT ManagerName, AVG(EmpSatisfaction) AS Avg_Satisfaction
FROM HRData
GROUP BY ManagerName
ORDER BY Avg_Satisfaction DESC;

-- Absences by department
SELECT Department, AVG(Absences) AS Avg_Absences
FROM HRData
GROUP BY Department
ORDER BY Avg_Absences DESC;

-- Average tenure by department
SELECT Department, AVG(DATEDIFF(YEAR, DateofHire, ISNULL(DateofTermination, GETDATE()))) AS Avg_Tenure
FROM HRData
GROUP BY Department
ORDER BY Avg_Tenure DESC;

-- Employees still active vs terminated
SELECT EmploymentStatus, COUNT(*) AS Employee_Count
FROM HRData
GROUP BY EmploymentStatus;

-- Create staging table for attrition by department
SELECT Department,
       COUNT(*) AS Total_Employees,
       SUM(CASE WHEN EmploymentStatus <> 'Active' THEN 1 ELSE 0 END) AS Attrition_Count,
       (SUM(CASE WHEN EmploymentStatus <> 'Active' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS Attrition_Percentage
INTO HR_Attrition_ByDept_Stage
FROM HRData
GROUP BY Department;
--salary staging table
SELECT Department,
       Position,
       AVG(Salary) AS Avg_Salary,
       MIN(Salary) AS Min_Salary,
       MAX(Salary) AS Max_Salary
INTO HR_Salary_Stage
FROM HRData
GROUP BY Department, Position;
--demographic table
SELECT Department,
       Sex,     
       COUNT(*) AS Employee_Count
INTO HR_Demographics_Stage
FROM HRData
GROUP BY Department, Sex;

--performance table
SELECT Department,
       ManagerName,
       PerformanceScore,
       AVG(EngagementSurvey) AS Avg_Engagement,
       AVG(EmpSatisfaction) AS Avg_Satisfaction
INTO HR_Performance_Stage
FROM HRData
GROUP BY Department, ManagerName, PerformanceScore;

--tenure staging table
SELECT Department,
       AVG(DATEDIFF(YEAR, DateofHire, ISNULL(DateofTermination, GETDATE()))) AS Avg_Tenure,
       MIN(DATEDIFF(YEAR, DateofHire, ISNULL(DateofTermination, GETDATE()))) AS Min_Tenure,
       MAX(DATEDIFF(YEAR, DateofHire, ISNULL(DateofTermination, GETDATE()))) AS Max_Tenure
INTO HR_Tenure_Stage
FROM HRData
GROUP BY Department;

--attendance staging table
SELECT Department,
       AVG(Absences) AS Avg_Absences,
       AVG(DaysLateLast30) AS Avg_DaysLate
INTO HR_Attendance_Stage
FROM HRData
GROUP BY Department;

-- Total employees check
SELECT COUNT(*) AS Total_Employees FROM HRData;

-- Compare with staging table totals
SELECT SUM(Total_Employees) AS Total_Employees
FROM HR_Attrition_ByDept_Stage;

--validaion step
SELECT COUNT(*) FROM HRData;
SELECT SUM(Employee_Count)
FROM HR_Demographics_Stage;

-- In SSMS, right‑click staging table → Tasks → Export Data
-- Choose CSV as destination


SELECT * FROM HR_Salary_Stage;






