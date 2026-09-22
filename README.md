# 🛒 Nova Retail Group — Enterprise Database System

[![SQL Server](https://img.shields.io/badge/Database-SQL_Server_2022-red?style=flat&logo=microsoftsqlserver)](#-deployment--execution-guide)
[![Data Modeling](https://img.shields.io/badge/Design-Relational_Schema_%26_ERD-blue)](#%EF%B8%8F-relational-schema--table-definitions)
[![Data Integrity](https://img.shields.io/badge/Integrity-Strict_Constraints-green)](#-sample-test-data--edge-cases-supported)

An enterprise-grade Relational Database Management System (RDBMS) designed and implemented for **Nova Retail Group** using **Microsoft SQL Server**. This system centralizes multi-branch retail operations, handling customer interactions, multi-supplier products, inventory categorization, order processing, and multi-method payment splits.

---

## 📌 Executive Summary & Business Context

Nova Retail Group operates across multiple branches with complex procurement and sales workflows. The goal of this project is to model and deploy a normalized database schema that enforces **Entity, Domain, and Referential Integrity** while solving key operational constraints:

* **Multi-Supplier Dynamics:** Products can be supplied by multiple vendors, with contractually agreed purchase prices tracked per supplier (`supplied` junction table).
* **Recursive Employee Supervision:** Organizational hierarchy is mapped via self-referencing relationships (`Supervisor_ID` within `employees`).
* **Order Line-Item Integrity:** Product selling prices are locked at the time of purchase (`UnitSellingPrice`) to preserve historical accuracy against future product price edits.
* **Flexible Split Payments:** Single orders can be paid across multiple transactions and payment methods (`Cash`, `Card`, `Wallet`, `Bank Transfer`).
* **Data Cleansing Readiness:** Designed to handle real-world legacy data edge cases (trailing spaces, inconsistent case sensitivity, missing contact records).

---

## 📁 Project Directory Structure

```text
Nova-Retail-Database/
│
├── Data_Exports/
│   └── Nova_Retail_Mapping_And_Data.xlsx   # Comprehensive Data Dictionary & Raw Mapping Sets
│
├── SQL/
│   └── 01_Nova_Retail_Schema_And_Data.sql  # Full DDL (Schema) + DML (Seed Data & Edge Cases)
│
├── docs/
│   ├── Business_Requirements.pdf           # Project specifications & scope definition
│   ├── Conceptual_ERD.png                  # High-level entity diagram
│   ├── Orders_Table_Constraints.png        # Technical constraint documentation
│   ├── Physical_Database_Diagram.png       # Complete physical ERD with FK mappings
│   ├── Relational_Mapping.png              # Logical relational model mapping
│   └── Tables_List_View.png                # SSMS database schema view
│
└── README.md                               # Project documentation & deployment guide
```

---

## 🖼️ Architecture & Database Diagrams

### 📐 Conceptual ERD (`Conceptual_ERD.png`)

---

### 🔗 Relational Mapping (`Relational_Mapping.png`)

---

### 🏛️ Physical Database Diagram (`Physical_Database_Diagram.png`)

---

### ⚙️ Orders Table Constraints & Schema Details (`Orders_Table_Constraints.png`)

---

### 🗃️ SSMS Tables List View (`Tables_List_View.png`)

---

## 🗂️ Relational Schema & Table Definitions

The system resolves M:N relationships into explicit junction tables to ensure 3NF compliance:

| Table Name | Primary Key (PK) | Key Foreign Keys (FK) | Core Constraints & Business Logic |
| --- | --- | --- | --- |
| **customers** | `Customer_ID` | *None* | Primary customer records. |
| **Customer_Phones** | `(Customer_ID, Phone_Number)` | `Customer_ID` | Resolves multi-valued phone attributes with `CASCADE` delete. |
| **Customer_Emails** | `(Customer_ID, Email_Address)` | `Customer_ID` | Resolves multi-valued email attributes with `CASCADE` delete. |
| **branches** | `branch_ID` | *None* | Physical retail store locations (`branch_Name` UNIQUE). |
| **departments** | `department_ID` | *None* | Corporate organizational units (`department_Name` UNIQUE). |
| **categories** | `CategoryID` | *None* | Product categorization hierarchy (`CategoryName` UNIQUE). |
| **suppliers** | `Supplier_ID` | *None* | Product vendors and supplier details. |
| **employees** | `employee_ID` | `branch_ID`, `department_ID`, `Supervisor_ID` | Self-referencing FK for supervisor hierarchy. |
| **products** | `Product_ID` | `CategoryID` | Stores default `CurrentUnitPrice >= 0`. |
| **supplied** | `(Supplier_ID, Product_ID)` | `Supplier_ID`, `Product_ID` | M:N Junction; stores distinct `AgreedPurchasePrice >= 0`. |
| **orders** | `OrderID` | `Customer_ID`, `branch_ID`, `employee_ID` | Status constrained to `Pending`, `Completed`, `Cancelled`, `Returned`. |
| **Order_Details** | `(OrderID, ProductID)` | `OrderID`, `ProductID` | M:N Junction; locks `Quantity > 0` & historical `UnitSellingPrice`. |
| **Payment** | `Payment_ID` | `OrderID` | Payment split logic; Method constrained to `Cash`, `Card`, `Wallet`, `Bank Transfer`. |

---

## ⚙️ Deployment & Execution Guide

To deploy this database locally on Microsoft SQL Server:

1. **Get the Repository Files:**
* **Option A (Via Git):** Run `git clone https://github.com/Mohamed3mad123/Nova-Retail-Database.git` in your terminal.
* **Option B (Direct Download):** Click the green **`<Code>`** button at the top of this repository page and select **Download ZIP**.


2. **Execute SQL Script:**
* Open **SQL Server Management Studio (SSMS)**.
* Open `SQL/01_Nova_Retail_Schema_And_Data.sql`.
* Execute the script (`F5`) to automatically create the `Nova_Retail` database, define tables/constraints, and seed verification data.



---

## 📊 Sample Test Data & Edge Cases Supported

The included DML seed script natively accommodates and validates the following operational business scenarios:

* ✅ **Duplicate Customer Names:** Tracked independently via unique `Customer_ID` values (`Mohamed Khalil` present with ID `1` and ID `2`).
* ✅ **Split Payments:** Orders distributed across multiple payment methods for a single order (`OrderID 10001` split into `Cash` + `Card`).
* ✅ **Unassigned Departments:** Departments initialized with zero assigned employees (`Research & Development`).
* ✅ **Executive Hierarchy:** Senior executives configured with `NULL` supervisors (`Ahmed Hassan` as CEO).
* ✅ **Multi-Vendor Products:** Products mapped to multiple vendors with distinct `AgreedPurchasePrice` rates (`Wireless Gaming Mouse` sourced from 2 different vendors at $25.00 and $22.50).

```

---
💡 **ملاحظة سريعة:** إذا قمت بحفظ هذا الملف ولسبب ما لم يظهر الشكل المرئي للصورة، ستكون مسألة أن جيت هب محتاج المسار المباشر الكامل المباشر المأخوذ من رابط الصورة على المستودع (RAW URL)، ويمكنك سحب الصور وإفلاتها (Drag & Drop) في نافذة التعديل بالماوس وسيقوم جيت هب بتوليد رابط مباشر لها تلقائياً.

```
