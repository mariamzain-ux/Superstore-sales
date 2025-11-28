Select * 
From [super store sales and quantity , profit ];

---Product Profitability

SELECT
    "Sub_Category",
    SUM("Profit") AS Total_Profit,
    SUM("Sales") AS Total_Sales
FROM
    [super store sales and quantity , profit ]
GROUP BY
    "Sub_Category"
ORDER BY
    Total_Profit DESC;

 ---Peak Sales Seasonality

SELECT
  YEAR([Order_Date]) AS Order_Year,
  DATEPART(QUARTER, [Order_Date]) AS Order_Quarter,
  SUM([Sales]) AS Total_Sales,
  SUM([Profit]) AS Total_Profit,
  AVG([Discount]) AS Average_Discount
FROM
  [super store sales and quantity , profit ]
GROUP BY
  YEAR([Order_Date]),
  DATEPART(QUARTER, [Order_Date])
ORDER BY
  Order_Year, Order_Quarter;

  ---Geographical Performance
  SELECT
    "State",
    SUM("Sales") AS Total_Sales,
    SUM("Profit") AS Total_Profit
FROM
    [super store sales and quantity , profit ]
GROUP BY
    "State"
ORDER BY
    Total_Profit DESC;

---Discount Impact

SELECT
    "Discount",
    AVG("Profit") AS Average_Profit,
    COUNT("Order_ID") AS Number_of_Orders
FROM
    [super store sales and quantity , profit ]
GROUP BY
    "Discount"
ORDER BY
    "Discount" ASC;
    
    import pandas as pd
import sqlite3

df = pd.read_csv("/content/Superstore Sales Project.csv")

conn = sqlite3.connect(":memory:")
df.to_sql("Superstore", conn, index=False, if_exists="replace")

# --- QUERY 1: Sales by Ship Mode ---
query1 = """
SELECT
    "Ship Mode",
    SUM("Quantity") AS Total_Quantity_Sold,
    AVG("Sales") AS Average_Sale_Amount,
    COUNT("Order ID") AS Number_of_Orders
FROM
    Superstore
GROUP BY
    "Ship Mode"
ORDER BY
    Number_of_Orders DESC;
"""
print("=== Sales by Ship Mode ===")
display(pd.read_sql_query(query1, conn))

# --- QUERY 2: Profit Margin by Category ---
query2 = """
SELECT
    "Category",
    SUM("Sales") AS Total_Sales,
    SUM("Profit") AS Total_Profit,
    (SUM("Profit") * 100.0 / SUM("Sales")) AS Profit_Margin_Percentage
FROM
    Superstore
GROUP BY
    "Category"
ORDER BY
    Profit_Margin_Percentage DESC;
"""
print("=== Profit Margin by Category ===")
display(pd.read_sql_query(query2, conn))

# --- QUERY 3: Yearly Sales and Profit ---
query3 = """
SELECT
    CAST(strftime('%Y', "Order Date") AS INTEGER) AS Order_Year,
    SUM("Sales") AS Total_Sales,
    SUM("Profit") AS Total_Profit
FROM
    Superstore
GROUP BY
    Order_Year
ORDER BY
    Order_Year ASC;
"""
print("=== Yearly Sales and Profit ===")
display(pd.read_sql_query(query3, conn))

conn.close()

