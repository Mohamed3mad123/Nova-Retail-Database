# 🛒 Nova Retail Group — Enterprise Database System

An enterprise-grade **Relational Database Management System (RDBMS)** designed and implemented for **Nova Retail Group** using **Microsoft SQL Server**.

The system centralizes multi-branch retail operations, including customer management, multi-supplier products, inventory categorization, order processing, employee hierarchy, and multi-method payment processing.

---

## 📌 Executive Summary & Business Context

Nova Retail Group operates across multiple branches with complex procurement and sales workflows.

The goal of this project is to model and deploy a **normalized relational database** that enforces Entity, Domain, and Referential Integrity while addressing realistic operational requirements.

### Key Business Requirements

- **Multi-Supplier Dynamics:** Products can be supplied by multiple vendors, with agreed purchase prices tracked per supplier through the `supplied` junction table.

- **Recursive Employee Supervision:** Organizational hierarchy is represented through a self-referencing relationship using `Supervisor_ID` within the `employees` table.

- **Historical Order Pricing:** Product selling prices are stored at the time of purchase using `UnitSellingPrice`, preserving historical transaction accuracy even when product prices change later.

- **Flexible Split Payments:** A single order can be paid using multiple transactions and payment methods such as `Cash`, `Card`, `Wallet`, and `Bank Transfer`.

- **Data Quality Readiness:** The database accounts for real-world data quality issues such as trailing spaces, inconsistent capitalization, and missing customer contact records.

---

## 📁 Project Directory Structure

```text
Nova-Retail-Database/
│
├── Data_Exports/
│   └── Nova_Retail_Mapping_And_Data.xlsx
│
├── SQL/
│   └── 01_Nova_Retail_Schema_And_Data.sql
│
├── docs/
│   ├── Business_Requirements.pdf
│   ├── Conceptual_ERD.png
│   ├── Orders_Table_Constraints.png
│   ├── Physical_Database_Diagram.png
│   ├── Relational_Mapping.png
│   └── Tables_List_View.png
│
└── README.md
````

---

## 📎 Project Files

### Business Requirements

The original business requirements and project specifications are available here:

[**📄 View Business Requirements**](./docs/Business_Requirements.pdf)

---

### 📊 Data Dictionary & Mapping

**[📥 Open Nova Retail Mapping & Data](./Data_Exports/Nova_Retail_Mapping_And_Data.xlsx)**

Contains the project's data dictionary, source mapping, and raw data preparation sets.

---

### 🗃️ SQL Database Script

**[📥 Open SQL Schema & Data Script](./SQL/01_Nova_Retail_Schema_And_Data.sql)**

Contains the complete database implementation, including:

* Database creation
* Table definitions
* Primary Keys
* Foreign Keys
* CHECK constraints
* UNIQUE constraints
* Referential integrity rules
* Seed / test data
* Edge-case scenarios

---

# 🖼️ Database Architecture & Documentation

The database design was developed through multiple modeling stages:

**Business Requirements → Conceptual ERD → Relational Mapping → Physical Database Implementation**

---

## 📐 Conceptual ERD

High-level representation of the main business entities and their relationships.

![Conceptual ERD](./docs/Conceptual_ERD.png)

---

## 🔗 Relational Mapping

Transformation of the conceptual model into relational tables, including the resolution of M:N relationships.

![Relational Mapping](./docs/Relational_Mapping.png)

---

## 🏛️ Physical Database Diagram

Complete physical database structure showing tables, Primary Keys, Foreign Keys, and relationships.

![Physical Database Diagram](./docs/Physical_Database_Diagram.png)

---

## ⚙️ Orders Table Constraints

Technical documentation of the `orders` table and its implemented business constraints.

![Orders Table Constraints](./docs/Orders_Table_Constraints.png)

---

## 🗃️ SQL Server Tables

Database schema as implemented and displayed in SQL Server Management Studio (SSMS).

![SSMS Tables List View](./docs/Tables_List_View.png)

---

# 🗂️ Relational Schema & Table Definitions

The system resolves **M:N relationships** into explicit junction tables to support normalization and maintain **3NF compliance**.

| Table Name          | Primary Key (PK)               | Key Foreign Keys (FK)                         | Core Constraints & Business Logic                                                  |
| ------------------- | ------------------------------ | --------------------------------------------- | ---------------------------------------------------------------------------------- |
| **customers**       | `Customer_ID`                  | None                                          | Primary customer records.                                                          |
| **Customer_Phones** | `(Customer_ID, Phone_Number)`  | `Customer_ID`                                 | Resolves multi-valued phone attributes with `CASCADE` delete.                      |
| **Customer_Emails** | `(Customer_ID, Email_Address)` | `Customer_ID`                                 | Resolves multi-valued email attributes with `CASCADE` delete.                      |
| **branches**        | `branch_ID`                    | None                                          | Physical retail store locations. `branch_Name` is UNIQUE.                          |
| **departments**     | `department_ID`                | None                                          | Corporate organizational units. `department_Name` is UNIQUE.                       |
| **categories**      | `CategoryID`                   | None                                          | Product categorization hierarchy. `CategoryName` is UNIQUE.                        |
| **suppliers**       | `Supplier_ID`                  | None                                          | Product vendors and supplier details.                                              |
| **employees**       | `employee_ID`                  | `branch_ID`, `department_ID`, `Supervisor_ID` | Self-referencing FK for supervisor hierarchy.                                      |
| **products**        | `Product_ID`                   | `CategoryID`                                  | Stores default `CurrentUnitPrice >= 0`.                                            |
| **supplied**        | `(Supplier_ID, Product_ID)`    | `Supplier_ID`, `Product_ID`                   | M:N junction; stores `AgreedPurchasePrice >= 0`.                                   |
| **orders**          | `OrderID`                      | `Customer_ID`, `branch_ID`, `employee_ID`     | Status constrained to `Pending`, `Completed`, `Cancelled`, `Returned`.             |
| **Order_Details**   | `(OrderID, ProductID)`         | `OrderID`, `ProductID`                        | M:N junction; enforces `Quantity > 0` and preserves historical `UnitSellingPrice`. |
| **Payment**         | `Payment_ID`                   | `OrderID`                                     | Supports split payments across `Cash`, `Card`, `Wallet`, and `Bank Transfer`.      |

---

# ⚙️ Deployment & Execution Guide

## 1. Clone the Repository

```bash
git clone https://github.com/Mohamed3mad123/Nova-Retail-Database.git
```

Then:

```bash
cd Nova-Retail-Database
```

Alternatively, use the GitHub **Code → Download ZIP** option.

---

## 2. Execute the SQL Script

Open **SQL Server Management Studio (SSMS)** and open:

```text
SQL/01_Nova_Retail_Schema_And_Data.sql
```

Execute the script using:

```text
F5
```

The script will:

1. Create the `Nova_Retail` database.
2. Create all required tables.
3. Define Primary Keys and Foreign Keys.
4. Apply integrity and business-rule constraints.
5. Insert seed/test data.
6. Validate several real-world edge cases.

---

# 📊 Sample Test Data & Edge Cases

The included DML seed script demonstrates several realistic business scenarios.

### ✅ Duplicate Customer Names

Customers can share the same name while remaining uniquely identified by `Customer_ID`.

```text
Mohamed Khalil → Customer_ID 1
Mohamed Khalil → Customer_ID 2
```

---

### ✅ Split Payments

A single order can be distributed across multiple payment methods.

```text
OrderID 10001
├── Cash
└── Card
```

---

### ✅ Unassigned Departments

Departments can exist without currently assigned employees.

```text
Research & Development
```

---

### ✅ Executive Hierarchy

Senior executives can have a `NULL` supervisor because they represent the top level of the organizational hierarchy.

```text
Ahmed Hassan → CEO
Supervisor_ID → NULL
```

---

### ✅ Multi-Vendor Products

A product can be supplied by multiple vendors with different agreed purchase prices.

```text
Wireless Gaming Mouse

Vendor 1 → $25.00
Vendor 2 → $22.50
```

---

# 🧠 Key Database Design Concepts Demonstrated

* Relational Database Design
* ERD Modeling
* Conceptual → Relational → Physical Mapping
* Normalization up to 3NF
* Primary & Foreign Keys
* Composite Primary Keys
* Many-to-Many Relationships
* Junction Tables
* Self-Referencing Relationships
* Referential Integrity
* Entity Integrity
* Domain Integrity
* CHECK Constraints
* UNIQUE Constraints
* CASCADE Delete
* Historical Transaction Data Preservation
* Split Payment Modeling
* SQL Server DDL & DML
* Data Quality & Edge-Case Handling

---

# 🛠️ Technologies

| Technology                       | Purpose                         |
| -------------------------------- | ------------------------------- |
| **Microsoft SQL Server**         | Database Engine                 |
| **SQL Server Management Studio** | Database Development & Testing  |
| **SQL**                          | DDL, DML & Constraints          |
| **Excel**                        | Data Mapping & Data Preparation |
| **ERD Modeling**                 | Database Design                 |

---

# 👤 Author

**Mohamed Emad Hamdy**

Data Analyst | SQL | Power BI | Excel

[GitHub Profile](https://github.com/Mohamed3mad123)
