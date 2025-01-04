
# E-commerce Data Warehouse Project

## Overview
This project demonstrates the design and implementation of an e-commerce data warehouse using SQL Server Management Studio (SSMS). The data warehouse enables efficient analysis of sales trends, customer performance, and product category insights.

## Key Features
- **Star Schema Design**:
  - **Fact Table**: Captures sales transactions with metrics like sales amount, quantity sold, and profit.
  - **Dimension Tables**: Descriptive attributes for customers, products, and time enrich the data for better analysis.
- **ETL Process**:
  - Extract raw data into staging tables.
  - Transform data for consistency and quality.
  - Load transformed data into dimension and fact tables.
- **Sample Queries**:
  - Analyze total sales by year.
  - Identify top-performing products.

## Database Structure
### Fact Table
- **FactSales**: Contains transaction-level data with references to dimension tables.

### Dimension Tables
- **DimCustomer**: Details about customers, such as name, email, and location.
- **DimProduct**: Information on products, including name, category, and price.
- **DimDate**: Time attributes such as year, month, and day.

### Staging Tables
- **StagingCustomer**, **StagingProduct**, **StagingSales**: Temporary tables for raw data.

## Tools and Technologies
- **SQL Server Management Studio (SSMS)** for database creation, querying, and management.
- **GitHub** for version control and project sharing.

## Getting Started
### Prerequisites
- SQL Server installed on your system.
- SQL Server Management Studio (SSMS) for executing scripts.

### Setup Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/ashitaatri/ecommerce_data_warehouse.git
   ```
2. Open `ecommerce_data_warehouse.sql` in SSMS.
3. Execute the script to create the database, schemas, tables, and sample data.
4. Run the provided queries to analyze the data.

## Example Queries
### Total Sales by Year
```sql
SELECT Year, SUM(TotalAmount) AS TotalSales
FROM Fact.FactSales FS
JOIN Dimension.DimDate DD ON FS.DateID = DD.DateID
GROUP BY Year;
```

### Best-Selling Products
```sql
SELECT TOP 10 P.ProductName, SUM(FS.QuantitySold) AS TotalQuantity
FROM Fact.FactSales FS
JOIN Dimension.DimProduct P ON FS.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY TotalQuantity DESC;
```

## Deliverables
- `ecommerce_data_warehouse.sql`: Script to create the database, schemas, and tables.
- Sample data for testing and analysis.
- Analytical queries for exploring sales trends and product performance.

## Business Use Cases
- **Sales Analysis**: Identify trends over time to support growth strategies.
- **Customer Insights**: Highlight top-performing customers for loyalty programs.
- **Product Performance**: Determine high-performing product categories to optimize inventory.

## License
This project is open-source and available under the [MIT License](LICENSE).
