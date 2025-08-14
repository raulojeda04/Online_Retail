# Project Background

This analysis focuses on a UK-based e-commerce company that sells unique, all-occasion giftware. The data set, **Online Retail II**, was sourced from the UC Irvine Machine Learning Repository and contails all transcations occuring between December 1, 2009 and December 9, 2011. Online Retail II can be downloaded [here](https://archive.ics.uci.edu/dataset/502/online+retail+ii) 

The data in Online Retail II provides a good opportunity to understand the company's commercial performance in great detail. This project thoroughly cleans, transforms, and analyzes this data to uncover critical insights and generate actionable recommendations to drive future growth.

Insights and recommendations are provided on the following key business areas:

- **Sales Trends Analysis**: Evaluation of historical sales patterns, focusing on monthly and yearly trends in **Revenue**, **Order Volume**, and **Average Order Value (AOV).**
- **Product Performance Insights**: Analysis of the company’s product catalog to identify the best selling items by both revenue and units sold.
- **Regional Comparisons**: Evaluation of sales and order distribution by country to identify core markets and potential growth opportunities.
- **Customer Purchase Behavior**: Assessment of purchasing patterns based on time of day, day of weeks, and seasonality to understand customer habits.

An interactive PowerBI dashboard can be downloaded [here](https://github.com/raulojeda04/Online_Retail/blob/main/retail_final.pbix).

The SQL queries used to clean, organize, and transform data can be found [here](https://github.com/raulojeda04/Online_Retail/blob/main/SQL%20Queries/retail_cleaning_final.sql). 

A `Caveats and Assumptions` section can be found at the end of this report.

---

# Data Structure and Cleaning

The raw version of **Online Retail II** is structured into two tables that is separated by year. The data set has a total of six columns and a total row count of 1,067,371.

![Column Overview](https://github.com/raulojeda04/Online_Retail/blob/main/images/online_retail_columns.png) 

Prior to the start of the analysis, the raw data had a total row count of 1,067,371 records. After cleaning and quality checks, the analysis ready version has a final row count of 1,003,444 records. The SQL queries utilized to clean and perform quality checks can be found [here](https://github.com/raulojeda04/Online_Retail/blob/main/SQL%20Queries/retail_cleaning_final.sql).

---

# Executive Summary

### Overview of Findings

This analysis of the Online Retail II data set reveals that this business thrives in the last two quarters of the year (Q3 & Q4), where it **peaks in November** and then **declines in December**. Key performance indicators (KPIs) have all shown minimal year-over-year (YOY) increases: **order volume by 0.7%**, **revenue by 1%** and **average order value (AOV) by 0.4%**. As mentioned earlier, and important to restate, the **data for 2011 concludes on December 9, 2011**, meaning the full year's performance is slightly understated. Key challenges and opportunities lie in the low AOV KPI of approximately $19.67, an overwhelming reliance on the UK market, and the sharp drop of sales in December. The following report details these trends and provides strategic recommendations to drive growth and operational efficiency.

Below is the Overview Summary page from the PowerBI dashboard, which can be downloaded [here](https://github.com/raulojeda04/Online_Retail/blob/main/retail_final.pbix).

![Overview Summary](https://github.com/raulojeda04/Online_Retail/blob/main/images/overview_summary.png)



### Sales Trends: 

* The company exhibits a repeating seasonal sales pattern, with **revenue consistently building from September onwards and reaching an annual peak in November 2011, which recorded $1.45 million in revenue.**

* While the first half of 2011 had a few months that underperformed compared to 2010, the latter half of the year showed strong YOY revenue growth. 

* While the sales data for **December 2011 is incomplete**, as it only covers the first nine days of the month, it is still important to note that revenue reached **$615K** for the few available days in the data set. Therefore, the lower revenue and order counts for this month are a reflection of data availability, not a drop in business performance.

* **Average order value remained relatively flat and low**, hovering around **$19-$21** throughout the two-year period, indicating that customers are typically making small-value purchases.

![Year-to-Year Trends](https://github.com/raulojeda04/Online_Retail/blob/main/images/yoy_trends.png)
![Historical Sales](https://github.com/raulojeda04/Online_Retail/blob/main/images/historical_sales_performance.png)



### Product Insights:

* A clear distinction exists between top products by revenue and by units sold. The **"REGENCY CAKESTAND 3 TIER" is the top revenue generator**, indicating a high-priced "hero product."

* On the other hand, the top product by units sold is **"WORLD WAR 2 GLIDERS ASSTD DESIGNS,"** which doesn't appear in the top 25 by revenue. This identifies it as a high-volume, low-margin "workhorse" item. 

* The product catalog is heavily weighted towards **low-cost giftware, party supplies, and decorative home items** (e.g. T-LIGHT HOLDERS, JUMBO BAGS, CAKE CASES), which are contributing to the **low AOV.**

![Top Products by Sales](https://github.com/raulojeda04/Online_Retail/blob/main/images/top_products_by_sales.png)
![Top Products by Units Sold](https://github.com/raulojeda04/Online_Retail/blob/main/images/top_products_by_units_sold.png)



### Regional Comparisons:

* The business is **overwhelmingly concentrated in the UK,** which accounts for the majority of total revenue (**$8.0M** in 2011) and order volume (**440K orders**). However, it maintains a consistently low average order Value (AOV) of about **$18.**

* While the **Netherlands, Germany, France, and Australia all demonstrated strong YOY revenue growth in 2011**, other previously promising regions faltered.

* Notably, **Ireland, which was a top-performing international market in 2010, experienced a significant YOY revenue decline in 2011.** This shift was also seen in other European markets like **Sweden and Denmark**, which might be an indication of potential market saturation or competitive pressures.

* The **Netherlands stands out as the premier international market**, not only continuing its strong YOY growth but also sustaining an exceptionally **high AOV of $122**. This highlights the region's strategic importance for high-value, profitable sales.

![Regional Year-to-Year Trends](https://github.com/raulojeda04/Online_Retail/blob/main/images/regional_yoy_trends.png)



### Customer Purchase Behavior:

* The sales-time data reveals a strong seasonal purchasing trend, with **sales building steadily from September and reaching a clear pre-holiday peak in November**, which consistently generates the highest monthly revenue.

* Purchasing is consistent throughout the days of the month, with no significant spikes or dips related to pay cycles, indicating a steady flow of demand. 

* Customer activity is heavy during standard business hours. Sales begin around 8 AM, **ramp up significantly to a peak between 10 AM and 3 PM,** and then taper off after 8 PM.

* The work week is the primary purchasing period. **Sales are highest between Tuesdays and Thursdays and then start to dip on the weekends.** While Sunday is the lowest-performing day, **Saturday sales are negligible and almost non-existent.** This finding is a real head-turner as it shows a significant missed opportunity compared to the rest of the week.

![Customer Behavior](https://github.com/raulojeda04/Online_Retail/blob/main/images/sales_by_time.png)



### Recommendations:

* **Maximize Holiday Revenue & Prevent Early Stockouts**: The data shows a high sales peak in November, which suggests that customers begin holiday shopping very early. To prepare for this crucial season, **a thematic analysis to identify and quantify all holiday-related products** (e.g., items with ‘CHRISTMAS’ in Description) should be performed. This will help reveal if the business has a diversified catalog of holiday items. Then, **analyze the rate of sales (or sales velocity) of these items beginning in September**. This will reveal the true start of the holiday purchasing window and if the peak in November sales and sudden drop in December is because holiday items are selling out too early. This insight will help with accurate inventory planning to ensure product availability throughout the entire Q4 period.

* **Address the Saturday Sales Anomaly**: The near-zero sales on Saturdays represents a major untapped opportunity. **Launching a targeted "Weekend Deals" email marketing campaign for 3-4 consecutive weekends** to test customer engagement will give a broader picture to these low sales. This low-cost experiment will determine if this anomaly is operational or a customer habit that can be influenced.

* **Implement a Tiered International Marketing Strategy**: Instead of a one size fits all approach for all the top performing markets, tailor each strategy in accordance to regional performance. For instance, **investigate the 2011 YOY revenue decline in the top performing countries such as the UK and Ireland**, while also **investigating if new competitors have surfaced** in those regions to diagnose the revenue decline. At the same time, **doubling down on the high-growth, high-AOV markets, such as the Netherlands and Australia**, with marketing focused on **business-to-business (B2B), wholesale, and premium good buyers** might prove an effective strategy to boost future revenue and keep AOV high in those regions.

* **Increase Average Order Value (AOV) with Smart Incentives**: To combat the low AOV of ~$19, introducing a **free shipping threshold at a price point around $30 to $40** could boost AOV. This incentivizes customers to add 1-2 more low-cost items to their cart.

* **Implement a Data-Driven Product Strategy**: Leverage Market Basket Analysis to discover which products are frequently bought together. Use these insights to create a "recommended for you" section on product pages and to inform bundling strategies, would provide upsell opportunities to increase AOV. At the same time, **investigating current gifting trends in social media to find new products** could prove to be another effective strategy.

* **Optimize Marketing for Peak Customer Behavior**: Addressing peak customer engagement hours to the Marketing Department is essential. With these insights, more marketing resources, such as promotions, can be allocated during peak purchasing periods **(10 AM - 3 PM, Tuesday-Thursday)**. As well as to plan major marketing campaigns and product launches to coincide with the seasonal spike from September to November.

* **Forecast to Create Accurate Baselines**: The incomplete December 2011 data hinders accurate year-end assessment. **Developing a time-series forecasting model to estimate sales for the missing 22 days of December will provide a more accurate YOY growth figure and a reliable baseline for future targets**.

* **Perform RFM Customer Segmentation as a Critical Next Step**: While this analysis focused on product and sales trends, the most valuable insights will come from understanding the customers. The next phase of this project should be to perform a detailed **Recency, Frequency, Monetary (RFM) analysis**. This will identify high-value, loyal, and at-risk customer segments, which will lead to effective personalized marketing campaigns to improve customer retention and increase customer lifetime value. 

---

# Caveats and Assumptions

### Caveats

* **Incomplete 2011 Data**: The dataset concludes on **December 9, 2011** and, therefore, any analysis of December 2011 is based on partial. As such, all full-year 2011 metrics like total revenue and order volume are slightly understated. 

* **Missing Customer Data**: A significant portion of the original transactions (about 25%) did not have an associated 'CustomerID'. This is going to limit the scope of any future customer-centric analysis, such as RFM or cohort studies. 

* **Historical Data**: The data covers the time period of late 2009 and late 2011. While the business patterns and analytical techniques are relevant, the specific findings of product trends and market performance may not reflect current market conditions and trends. 



### Assumptions

* **Handling of Non-Product Codes**: Transactions with operational 'StockCodes' (e.g., 'POST' for postage, 'M' for Manual, 'D' for discount) were removed from the final table during the cleaning process. This was done under the assumption that these entries had no tangible sales and would only skew order volume and sales trends. 

* **Outlier Handling**: Statistical outliers identified by the IQR method, based on the `Price` were not automatically removed from the data set. Instead, a percentile-based approach was used to delete only the extreme values.
