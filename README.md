# Automated Secret Santa Pairing System
![Automated Secret Santa Project cover](https://github.com/pbisht2105/Automated-Secret-Santa-Pairing-System/blob/main/Secret%20Santa%20cover.png)

## Overview

The **Automated Secret Santa Pairing System** is an automated solution for pairing participants in a Secret Santa gift exchange. This project uses **MySQL** to generate randomized, circular pairings based on the list of employees. The system ensures fair, random pairings, ensuring that no one is paired with themselves and that the pairing is circular (i.e., the last person is paired with the first).

This system demonstrates how to use SQL window functions (`ROW_NUMBER()`) and randomization (`RAND()`) to create fair and fun Secret Santa pairings.

## Features
- **Randomized Pairings**: Randomly pairs participants using `ROW_NUMBER()` and `RAND()`.
- **Circular Pairing**: Ensures that the last participant is paired with the first, completing a circle of exchanges.
- **No Self-Pairing**: Guarantees no participant is paired with themselves.
- **Scalable**: Can handle any number of participants, making it adaptable to different group sizes.
- **User-friendly Output**: Outputs the names of the Secret Santa pairs in an easy-to-read format.

## Technologies Used
- **MySQL**: For database management and SQL query writing.

## Getting Started

To run the Secret Santa Pairing System, follow the instructions below to set up the database and execute the pairing logic.

### Prerequisites

Make sure you have the following tools installed:
- **MySQL** (version 8.0 or later).
- A MySQL client (e.g., MySQL Workbench, or command-line MySQL).

### Setting Up the Database

#### 1. Create the Database**:
```sql
  -- First, create the database for the project:
   
   CREATE DATABASE secret_santa;
```
#### 2. Create the employee_salary Table: Create the table to store participant details:

```sql
CREATE TABLE employee_salary (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);
```

#### 3. Insert Sample Data: Insert some sample participants (employees) into the table:
```sql
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
```
#### 4. To generate the Secret Santa pairings, execute the following SQL query:
```sql
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
```
This query will return a table of participants with their giver and receiver names, ensuring no one is paired with themselves, and that the pairings are circular.

#### Sample Output
[Query Result Screenshot](https://github.com/pbisht2105/Automated-Secret-Santa-Pairing-System/blob/main/Secret%20Santa%20Query%20Output.png)

#### How the Query Works
EmployeeRanks CTE: The EmployeeRanks Common Table Expression (CTE) assigns a random rank (row number) to each participant using ROW_NUMBER() and orders them randomly with RAND().

#### Pairing Logic: The query uses a JOIN to match each participant (giver) with another (receiver) using the calculated row_num values.

The receiver.row_num % (SELECT COUNT(*) FROM employee_salary) + 1 ensures the pairing is circular (i.e., the last participant is paired with the first).
The WHERE giver.row_num != receiver.row_num condition ensures that no participant is paired with themselves.

#### Challenges Faced
**Circular Pairing**: Ensuring that the last person is paired with the first was a key challenge. The modulo operation in the SQL query resolves this.
Ensuring Randomness: Ensuring fair and random pairings while maintaining no self-pairing required careful use of ROW_NUMBER() and RAND().
Scalability: Ensuring the system can scale for larger groups was important, as the logic must adapt to any number of participants.
