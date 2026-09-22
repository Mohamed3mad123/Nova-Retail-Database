
USE Nova_Retail;


-- 1. الكيانات الأساسية (Parent Tables)
CREATE TABLE customers(
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL
)

CREATE TABLE Customer_Phones(
    Customer_ID INT FOREIGN KEY REFERENCES customers(Customer_ID) ON DELETE CASCADE,
    Phone_Number VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Customer_Phones PRIMARY KEY (Customer_ID, Phone_Number)
)

CREATE TABLE Customer_Emails(
    Customer_ID INT FOREIGN KEY REFERENCES customers(Customer_ID) ON DELETE CASCADE,
    Email_Address VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Customer_Emails PRIMARY KEY (Customer_ID, Email_Address)
)

CREATE TABLE branches(
    branch_ID INT PRIMARY KEY,
    branch_Name VARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE departments(
    department_ID INT PRIMARY KEY,
    department_Name VARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE categories(
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
)

CREATE TABLE suppliers(
    Supplier_ID INT PRIMARY KEY,
    Supplier_Name VARCHAR(100) NOT NULL,
    Contact_Number VARCHAR(20) NOT NULL
)

-- 2. الكيانات التابعة للكيانات الأساسية
CREATE TABLE employees(
    employee_ID INT PRIMARY KEY,
    employee_Name VARCHAR(100) NOT NULL,
    branch_ID INT NOT NULL FOREIGN KEY REFERENCES branches(branch_ID),
    department_ID INT NOT NULL FOREIGN KEY REFERENCES departments(department_ID),    
    Supervisor_ID INT NULL FOREIGN KEY REFERENCES employees(employee_ID)
)
CREATE TABLE products(
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    CurrentUnitPrice DECIMAL(10,2) NOT NULL CHECK (CurrentUnitPrice >= 0),
    CategoryID INT NOT NULL FOREIGN KEY REFERENCES categories(CategoryID)
)

-- 3. الجداول الوسيطة والطلبات والمدفوعات
CREATE TABLE supplied(
    Supplier_ID INT FOREIGN KEY REFERENCES suppliers(Supplier_ID),
    Product_ID INT FOREIGN KEY REFERENCES products(Product_ID),
    AgreedPurchasePrice DECIMAL(10,2) NOT NULL CHECK (AgreedPurchasePrice >= 0),
    CONSTRAINT PK_Supplied PRIMARY KEY (Supplier_ID, Product_ID)
)

CREATE TABLE orders(
    OrderID INT PRIMARY KEY,
    Order_Date DATE NOT NULL CHECK (Order_Date >= '2000-01-01'),
    Order_status VARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (Order_status IN ('Pending', 'Completed', 'Cancelled', 'Returned')),
    Customer_ID INT NOT NULL FOREIGN KEY REFERENCES customers(Customer_ID),
    branch_ID INT NOT NULL FOREIGN KEY REFERENCES branches(branch_ID),
    employee_ID INT NOT NULL FOREIGN KEY REFERENCES employees(employee_ID)
)

CREATE TABLE Payment(
    Payment_ID INT PRIMARY KEY,
    Payment_Date DATETIME NOT NULL DEFAULT GETDATE() CHECK (Payment_Date >= '2000-01-01'),
    Payment_Method VARCHAR(20) NOT NULL CHECK (Payment_Method IN ('Cash', 'Card', 'Wallet', 'Bank Transfer')),
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    OrderID INT NOT NULL FOREIGN KEY REFERENCES orders(OrderID)
)

CREATE TABLE Order_Details(
    OrderID INT FOREIGN KEY REFERENCES orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES products(Product_ID),
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitSellingPrice DECIMAL(10,2) NOT NULL CHECK (UnitSellingPrice >= 0),
    CONSTRAINT PK_Order_Details PRIMARY KEY (OrderID, ProductID)
)