-- ===============================================================================
-- Database Initialization & Schema Creation (DDL)
-- تهيئة قاعدة البيانات وإنشاء الهيكل الأساسي للجداول
-- ===============================================================================

USE [Nova_Retail];


-- -------------------------------------------------------------------------------
-- 1. Parent Tables (الكيانات الأساسية)
-- -------------------------------------------------------------------------------

-- Primary customer records / جدول بيانات العملاء 
CREATE TABLE customers(
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL
);

-- Handles multi-valued phone numbers per customer / معالجة خاصية أرقام الهواتف المتعددة للعميل
CREATE TABLE Customer_Phones(
    Customer_ID INT FOREIGN KEY REFERENCES customers(Customer_ID) ON DELETE CASCADE,
    Phone_Number VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Customer_Phones PRIMARY KEY (Customer_ID, Phone_Number)
);

-- Handles multi-valued email addresses per customer / معالجة خاصية البريد الإلكتروني المتعدد للعميل
CREATE TABLE Customer_Emails(
    Customer_ID INT FOREIGN KEY REFERENCES customers(Customer_ID) ON DELETE CASCADE,
    Email_Address VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Customer_Emails PRIMARY KEY (Customer_ID, Email_Address)
);

-- Physical retail store locations / جدول الفروع  
CREATE TABLE branches(
    branch_ID INT PRIMARY KEY,
    branch_Name VARCHAR(100) NOT NULL UNIQUE
);

-- Corporate organizational departments / جدول  الأقسام 
CREATE TABLE departments(
    department_ID INT PRIMARY KEY,
    department_Name VARCHAR(100) NOT NULL UNIQUE
);

-- Product categorization system / جدول تصنيفات المنتجات
CREATE TABLE categories(
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);

-- Vendor & supplier registry / جدول الموردين وبيانات الاتصال بهم
CREATE TABLE suppliers(
    Supplier_ID INT PRIMARY KEY,
    Supplier_Name VARCHAR(100) NOT NULL,
    Contact_Number VARCHAR(20) NOT NULL
);


-- -------------------------------------------------------------------------------
-- 2. Dependent Entities (الكيانات التابعة)
-- -------------------------------------------------------------------------------

-- Staff members with self-referencing supervisor mapping / جدول الموظفين مع هيكل الإشراف 
CREATE TABLE employees(
    employee_ID INT PRIMARY KEY,
    employee_Name VARCHAR(100) NOT NULL,
    branch_ID INT NOT NULL FOREIGN KEY REFERENCES branches(branch_ID),
    department_ID INT NOT NULL FOREIGN KEY REFERENCES departments(department_ID),    
    Supervisor_ID INT NULL FOREIGN KEY REFERENCES employees(employee_ID)
);

-- Product catalog with price validation / جدول المنتجات مع تحديد أسعار البيع الحالية
CREATE TABLE products(
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    CurrentUnitPrice DECIMAL(10,2) NOT NULL CHECK (CurrentUnitPrice >= 0),
    CategoryID INT NOT NULL FOREIGN KEY REFERENCES categories(CategoryID)
);


-- -------------------------------------------------------------------------------
-- 3. Junction Tables, Orders & Financial Transactions (الجداول الوسيطة والطلبات)
-- -------------------------------------------------------------------------------

-- M:N Junction: Resolves suppliers-to-products mapping with agreed cost rates / جدول وسيط لربط الموردين بالمنتجات وأسعار التوريد
CREATE TABLE supplied(
    Supplier_ID INT FOREIGN KEY REFERENCES suppliers(Supplier_ID),
    Product_ID INT FOREIGN KEY REFERENCES products(Product_ID),
    AgreedPurchasePrice DECIMAL(10,2) NOT NULL CHECK (AgreedPurchasePrice >= 0),
    CONSTRAINT PK_Supplied PRIMARY KEY (Supplier_ID, Product_ID)
);

-- Sales order headers / جدول طلبات المبيعات الرئيسية
CREATE TABLE orders(
    OrderID INT PRIMARY KEY,
    Order_Date DATE NOT NULL CHECK (Order_Date >= '2000-01-01'),
    Order_status VARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (Order_status IN ('Pending', 'Completed', 'Cancelled', 'Returned')),
    Customer_ID INT NOT NULL FOREIGN KEY REFERENCES customers(Customer_ID),
    branch_ID INT NOT NULL FOREIGN KEY REFERENCES branches(branch_ID),
    employee_ID INT NOT NULL FOREIGN KEY REFERENCES employees(employee_ID)
);

-- Multi-payment transaction split tracker / جدول تسديد المدفوعات ودعم الدفع المجزأ
CREATE TABLE Payment(
    Payment_ID INT PRIMARY KEY,
    Payment_Date DATETIME NOT NULL DEFAULT GETDATE() CHECK (Payment_Date >= '2000-01-01'),
    Payment_Method VARCHAR(20) NOT NULL CHECK (Payment_Method IN ('Cash', 'Card', 'Wallet', 'Bank Transfer')),
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    OrderID INT NOT NULL FOREIGN KEY REFERENCES orders(OrderID)
);

-- M:N Junction: Order line-items with locked transaction price / جدول تفاصيل الطلبات وتثبيت سعر البيع التاريخي
CREATE TABLE Order_Details(
    OrderID INT FOREIGN KEY REFERENCES orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES products(Product_ID),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitSellingPrice DECIMAL(10,2) NOT NULL CHECK (UnitSellingPrice >= 0),
    CONSTRAINT PK_Order_Details PRIMARY KEY (OrderID, ProductID)
);



-- ===============================================================================
-- Data Population Script (DML Seed Data)
-- ضخ بيانات الاختبار وتأكيد القيود والحالات الخاصة
-- ===============================================================================


-- 1. Customers Seed / إدخال أسماء العملاء (يتضمن حالة تكرار الاسم)
INSERT INTO customers (Customer_ID, Customer_Name) VALUES
    (1, 'Mohamed Khalil'),
    (2, 'Mohamed Khalil'), -- Duplicate customer name with unique ID / اسم مكرر لمعرف مختلف
    (3, 'Eman Youssef');

-- 2. Customer Phone Numbers / أرقام هواتف العملاء
INSERT INTO Customer_Phones (Customer_ID, Phone_Number) VALUES
    (1, '+201001234567'),
    (2, '+201119876543');

-- 3. Customer Email Addresses / البريد الإلكتروني للعملاء
INSERT INTO Customer_Emails (Customer_ID, Email_Address) VALUES
    (1, 'm.khalil1@email.com'),
    (2, 'm.khalil2@email.com');

-- 4. Branch Locations / فروع الشركة
INSERT INTO branches (branch_ID, branch_Name) VALUES
    (101, 'Cairo Main Branch'),
    (102, 'Giza Hub');

-- 5. Departments Seed / الإدارات (يتضمن قسماً بدون موظفين)
INSERT INTO departments (department_ID, department_Name) VALUES
    (1, 'Executive Management'),
    (2, 'Retail Operations'),
    (3, 'Inventory & Logistics'),
    (4, 'Research & Development'); -- Zero employees assigned / قسم بدون موظفين

-- 6. Product Categories / تصنيفات المنتجات
INSERT INTO categories (CategoryID, CategoryName) VALUES
    (10, 'Electronics'),
    (20, 'Home Appliances');

-- 7. Supplier Registry / الموردين
INSERT INTO suppliers (Supplier_ID, Supplier_Name, Contact_Number) VALUES
    (1, 'TechSource Ltd', '+201200001111'),
    (2, 'Global Components Inc', '+201200002222');

-- 8. Employees / الموظفين (يتضمن مديراً بدون مشرف)
INSERT INTO employees (employee_ID, employee_Name, branch_ID, department_ID, Supervisor_ID) VALUES
    (1001, 'Ahmed Hassan', 101, 1, NULL),       -- Executive with NULL supervisor / رئيس بدون مشرف
    (1002, 'Sarah Mansour', 101, 2, 1001),     -- Supervised by Ahmed Hassan / مرؤوس برقم 1001
    (1003, 'Omar Ali', 102, 3, 1001);

-- 9. Product Catalog / المنتجات
INSERT INTO products (Product_ID, Product_Name, CurrentUnitPrice, CategoryID) VALUES
    (501, 'Wireless Gaming Mouse', 45.00, 10),
    (502, 'Mechanical Keyboard', 85.00, 10),
    (503, 'Electric Kettle', 30.00, 20);

-- 10. Multi-Supplier Rates / توريد المنتج من أكثر من مورد بأسعار مختلفة
INSERT INTO supplied (Supplier_ID, Product_ID, AgreedPurchasePrice) VALUES
    (1, 501, 25.00), -- TechSource price / سعر المورد الأول
    (2, 501, 22.50), -- Global Components price for same product / سعر المورد الثاني لنفس المنتج
    (1, 502, 50.00);

-- 11. Orders Seed / الطلبات
INSERT INTO orders (OrderID, Order_Date, Order_status, Customer_ID, branch_ID, employee_ID) VALUES
    (10001, '2026-03-01', 'Completed', 1, 101, 1002),
    (10002, '2026-03-02', 'Completed', 2, 102, 1003);

-- 12. Order Details / تفاصيل كل طلب
INSERT INTO Order_Details (OrderID, ProductID, Quantity, UnitSellingPrice) VALUES
    (10001, 501, 2, 45.00),
    (10002, 502, 1, 85.00);

-- 13. Split Payments / المدفوعات (يتضمن حالة الدفع المجزأ لطلب واحد)
INSERT INTO Payment (Payment_ID, Payment_Date, Payment_Method, Amount, OrderID) VALUES
    (9001, GETDATE(), 'Cash', 50.00, 10001), -- Cash split / جزء كاش
    (9002, GETDATE(), 'Card', 40.00, 10001), -- Card split for same order / جزء بطاقة لنفس الطلب
    (9003, GETDATE(), 'Card', 85.00, 10002);
