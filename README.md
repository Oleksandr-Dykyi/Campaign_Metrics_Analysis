## Campaign_Metrics_Analysis

#### Technology Stack:
PostgreSQL (CTE, union, data aggregation, operators, regular expressions, window functions)

#### Project Description:
In this project, I utilized PostgreSQL to analyze advertising campaign data. The focus was on consolidating and deriving meaningful metrics from two primary tables: facebook_ads_basic_daily and google_ads_basic_daily.

In a Common Table Expression (CTE) query, I amalgamated data from the mentioned tables to extract crucial campaign metrics such as ad_date (display date of ads on Google and Facebook), url_parameters (part of the URL from the campaign link, including UTM parameters), spend, impressions, reach, clicks, leads, and value for each relevant day. I ensured that any missing metric values were set to zero.

Further utilizing a nested CTE, I crafted a sample dataset with enriched information. This dataset included ad_month (the month number derived from the ad_date), utm_campaign (value of utm_campaign parameter from utm_parameters), and aggregated values such as total expenses, number of impressions, number of clicks, and total conversion value for each corresponding date and campaign. Additionally, I calculated CTR, CPC, CPM, and ROMI, carefully handling division by zero errors using the CASE operator.

The resulting sample comprised essential fields: ad_month, utm_campaign, total cost, impressions, clicks, conversion value, CTR, CPC, CPM, and ROMI. To enhance analysis, I introduced a 'difference in CTR, CPC, CPM, and ROMI' field for each utm_campaign in every month, comparing values to the previous month in terms of percentage change.

#### Skills:
SQL, PostgreSQL, DBeaver
