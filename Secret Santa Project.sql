-----------------------------------------------
-- AUTOMATED SECRET SANTA PAIRING SYSTEM
-----------------------------------------------


-- 1. Create the Database:
CREATE DATABASE secret_santa;


-- 2. Create the employee_salary Table: Create the table to store participant details:
CREATE TABLE employee_salary (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);


-- 3. Insert Sample Data: Insert some sample participants (employees) into the table:
INSERT INTO employee_salary (first_name, last_name)
VALUES 
    ('Alice', 'Smith'),
    ('Bob', 'Johnson'),
    ('Charlie', 'Davis'),
    ('David', 'Martinez'),
    ('Eva', 'Lopez'),
    ('Frank', 'Garcia'),
    ('Grace', 'Miller'),
    ('Henry', 'Wilson'),
    ('Ivy', 'Taylor'),
    ('Jack', 'Anderson');


-- 4. To generate the Secret Santa pairings, execute the following SQL query:
WITH EmployeeRanks AS (
    SELECT 
        employee_id,
        first_name,
        last_name,
        ROW_NUMBER() OVER (ORDER BY RAND()) AS row_num
    FROM employee_salary
)
SELECT 
    CONCAT(giver.first_name, ' ', giver.last_name) AS giver_name,
    CONCAT(receiver.first_name, ' ', receiver.last_name) AS receiver_name
FROM EmployeeRanks giver
JOIN EmployeeRanks receiver
    ON giver.row_num = (receiver.row_num % (SELECT COUNT(*) FROM employee_salary)) + 1
WHERE giver.row_num != receiver.row_num;

-- This query will return a table of participants with their giver and receiver names, ensuring no one is paired with themselves, and that the pairings are circular.
