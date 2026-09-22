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
