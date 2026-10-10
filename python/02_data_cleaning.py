import pandas as pd
from pathlib import Path


# Find the project folder
project_path = Path(__file__).resolve().parent.parent

# Data folders
raw_path = project_path / "data" / "raw"
cleaned_path = project_path / "data" / "cleaned"

# Create cleaned folder if it does not exist
cleaned_path.mkdir(exist_ok=True)


# =========================================================
# 1. ORDERS DATA
# =========================================================

orders = pd.read_csv(
    raw_path / "olist_orders_dataset.csv"
)

# Convert date columns
order_date_columns = [
    "order_purchase_timestamp",
    "order_approved_at",
    "order_delivered_carrier_date",
    "order_delivered_customer_date",
    "order_estimated_delivery_date"
]

for column in order_date_columns:
    orders[column] = pd.to_datetime(
        orders[column],
        dayfirst=True,
        errors="coerce"
    )

# Remove exact duplicate rows
orders = orders.drop_duplicates()

orders.to_csv(
    cleaned_path / "olist_orders_cleaned.csv",
    index=False
)

print("Orders cleaned:", orders.shape)


# =========================================================
# 2. CUSTOMERS DATA
# =========================================================

customers = pd.read_csv(
    raw_path / "olist_customers_dataset.csv"
)

# Remove exact duplicate rows
customers = customers.drop_duplicates()

customers.to_csv(
    cleaned_path / "olist_customers_cleaned.csv",
    index=False
)

print("Customers cleaned:", customers.shape)


# =========================================================
# 3. ORDER ITEMS DATA
# =========================================================

order_items = pd.read_csv(
    raw_path / "olist_order_items_dataset.csv"
)

# Convert numeric columns
order_items["price"] = pd.to_numeric(
    order_items["price"],
    errors="coerce"
)

order_items["freight_value"] = pd.to_numeric(
    order_items["freight_value"],
    errors="coerce"
)

# Convert shipping limit date
order_items["shipping_limit_date"] = pd.to_datetime(
    order_items["shipping_limit_date"],
    dayfirst=True,
    errors="coerce"
)

# Remove exact duplicate rows
order_items = order_items.drop_duplicates()

order_items.to_csv(
    cleaned_path / "olist_order_items_cleaned.csv",
    index=False
)

print("Order Items cleaned:", order_items.shape)


# =========================================================
# 4. PAYMENTS DATA
# =========================================================

payments = pd.read_csv(
    raw_path / "olist_order_payments_dataset.csv"
)

# Convert numeric columns
payments["payment_value"] = pd.to_numeric(
    payments["payment_value"],
    errors="coerce"
)

payments["payment_installments"] = pd.to_numeric(
    payments["payment_installments"],
    errors="coerce"
)

# Remove exact duplicate rows
payments = payments.drop_duplicates()

payments.to_csv(
    cleaned_path / "olist_order_payments_cleaned.csv",
    index=False
)

print("Payments cleaned:", payments.shape)


# =========================================================
# 5. REVIEWS DATA
# =========================================================

reviews = pd.read_csv(
    raw_path / "olist_order_reviews_dataset.csv"
)

# Convert review score to numeric
reviews["review_score"] = pd.to_numeric(
    reviews["review_score"],
    errors="coerce"
)

# Convert review creation and answer dates
reviews["review_creation_date"] = pd.to_datetime(
    reviews["review_creation_date"],
    dayfirst=True,
    errors="coerce"
)

reviews["review_answer_timestamp"] = pd.to_datetime(
    reviews["review_answer_timestamp"],
    dayfirst=True,
    errors="coerce"
)

# Remove exact duplicate rows
reviews = reviews.drop_duplicates()

reviews.to_csv(
    cleaned_path / "olist_order_reviews_cleaned.csv",
    index=False
)

print("Reviews cleaned:", reviews.shape)


# =========================================================
# 6. PRODUCTS DATA
# =========================================================

products = pd.read_csv(
    raw_path / "olist_products_dataset.csv"
)

# Convert product measurements to numeric
product_numeric_columns = [
    "product_name_lenght",
    "product_description_lenght",
    "product_photos_qty",
    "product_weight_g",
    "product_length_cm",
    "product_height_cm",
    "product_width_cm"
]

for column in product_numeric_columns:
    products[column] = pd.to_numeric(
        products[column],
        errors="coerce"
    )

# Remove exact duplicate rows
products = products.drop_duplicates()

products.to_csv(
    cleaned_path / "olist_products_cleaned.csv",
    index=False
)

print("Products cleaned:", products.shape)


# =========================================================
# 7. SELLERS DATA
# =========================================================

sellers = pd.read_csv(
    raw_path / "olist_sellers_dataset.csv"
)

# Remove exact duplicate rows
sellers = sellers.drop_duplicates()

sellers.to_csv(
    cleaned_path / "olist_sellers_cleaned.csv",
    index=False
)

print("Sellers cleaned:", sellers.shape)


# =========================================================
# 8. GEOLOCATION DATA
# =========================================================

geolocation = pd.read_csv(
    raw_path / "olist_geolocation_dataset.csv"
)

# Convert geographic values to numeric
geolocation["geolocation_lat"] = pd.to_numeric(
    geolocation["geolocation_lat"],
    errors="coerce"
)

geolocation["geolocation_lng"] = pd.to_numeric(
    geolocation["geolocation_lng"],
    errors="coerce"
)

# Remove exact duplicate rows
geolocation = geolocation.drop_duplicates()

geolocation.to_csv(
    cleaned_path / "olist_geolocation_cleaned.csv",
    index=False
)

print("Geolocation cleaned:", geolocation.shape)


# =========================================================
# 9. CATEGORY TRANSLATION DATA
# =========================================================

category_translation = pd.read_csv(
    raw_path / "product_category_name_translation.csv"
)

# Remove exact duplicate rows
category_translation = category_translation.drop_duplicates()

category_translation.to_csv(
    cleaned_path / "product_category_name_translation_cleaned.csv",
    index=False
)

print("Category translation cleaned:", category_translation.shape)


# =========================================================
# FINAL SUMMARY
# =========================================================

print("\n====================================")
print("ALL DATASETS CLEANED SUCCESSFULLY")
print("====================================")

print("\nCleaned files saved in:")
print(cleaned_path)

print("\nTotal cleaned files:", len(list(cleaned_path.glob("*.csv"))))