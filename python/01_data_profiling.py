import pandas as pd
from pathlib import Path

# Find the project folder
project_path = Path(__file__).resolve().parent.parent

# Locate the raw data folder
raw_path = project_path / "data" / "raw"


# =========================
# 1. LOAD ORDERS DATA
# =========================

orders = pd.read_csv(raw_path / "olist_orders_dataset.csv")

print("\n========== ORDERS DATASET ==========\n")

print("First 5 rows:")
print(orders.head())

print("\nRows:", orders.shape[0])
print("Columns:", orders.shape[1])


# =========================
# 2. CHECK DATA TYPES
# =========================

print("\n========== DATA TYPES ==========\n")

print(orders.dtypes)


# =========================
# 3. CHECK MISSING VALUES
# =========================

print("\n========== MISSING VALUES ==========\n")

print(orders.isnull().sum())


# =========================
# 4. CHECK DUPLICATES
# =========================

print("\n========== DUPLICATES ==========\n")

print("Duplicate rows:", orders.duplicated().sum())

print("Duplicate order IDs:",
      orders["order_id"].duplicated().sum())


# =========================
# 5. CHECK ORDER STATUS
# =========================

print("\n========== ORDER STATUS ==========\n")

print(orders["order_status"].value_counts())

print("Unique order statuses:",
      orders["order_status"].nunique())


# =========================
# 6. CHECK DATE COLUMNS
# =========================

print("\n========== DATE COLUMNS ==========\n")

print(orders[[
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date"
]].head())


print("\nDate column data types:")

print(orders[[
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date"
]].dtypes)


# =========================
# 7. PURCHASE DATE RANGE
# =========================

purchase_date = pd.to_datetime(
    orders["order_purchase_timestamp"],
    dayfirst=True
)

print("\n========== PURCHASE DATE RANGE ==========\n")

print("Earliest purchase:",
      purchase_date.min())

print("Latest purchase:",
      purchase_date.max())


# =========================
# 8. CHECK MISSING PURCHASE DATES
# =========================

print("\nMissing purchase dates:",
      orders["order_purchase_timestamp"].isnull().sum())


# =========================
# 9. CUSTOMER ANALYSIS
# =========================

print("\n========== CUSTOMER CHECK ==========\n")

print("Unique customers:",
      orders["customer_id"].nunique())

print("Missing customer IDs:",
      orders["customer_id"].isnull().sum())


# =========================
# 10. FINAL SUMMARY
# =========================

print("\n========== PROFILING SUMMARY ==========\n")

print("Total orders:", len(orders))

print("Total columns:", len(orders.columns))

print("Duplicate rows:",
      orders.duplicated().sum())

print("Duplicate order IDs:",
      orders["order_id"].duplicated().sum())

print("Missing order IDs:",
      orders["order_id"].isnull().sum())

print("Missing customer IDs:",
      orders["customer_id"].isnull().sum())

print("Unique order statuses:",
      orders["order_status"].nunique())

print("Earliest order:",
      purchase_date.min())

print("Latest order:",
      purchase_date.max())

print("\n========== PROFILING COMPLETED ==========\n")

# =========================
# 11. PROFILE ALL DATASETS
# =========================

print("\n========== ALL DATASETS ==========\n")

for file in raw_path.glob("*.csv"):

    df = pd.read_csv(file)

    print("\nFile:", file.name)
    print("Rows:", df.shape[0])
    print("Columns:", df.shape[1])
    print("Missing values:", df.isnull().sum().sum())
    print("Duplicate rows:", df.duplicated().sum())