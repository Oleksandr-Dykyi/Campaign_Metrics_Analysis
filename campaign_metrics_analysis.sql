WITH ads_basics AS (
	SELECT
		ad_date,
		url_parameters,
		COALESCE (spend, 0) AS spend,
		COALESCE (impressions, 0) AS impressions,
		COALESCE (reach, 0) AS reach,
		COALESCE (clicks, 0) AS clicks,
		COALESCE (leads, 0) AS leads,
		COALESCE (value, 0) AS value
	FROM
		facebook_ads_basic_daily 
	WHERE 
		ad_date IS NOT NULL 
	UNION
	SELECT
		ad_date,
		url_parameters,
		COALESCE (spend, 0) AS spend,
		COALESCE (impressions, 0) AS impressions,
		COALESCE (reach, 0) AS reach,
		COALESCE (clicks, 0) AS clicks,
		COALESCE (leads, 0) AS leads,
		COALESCE (value, 0) AS value
	FROM
		google_ads_basic_daily
	WHERE 
		ad_date IS NOT NULL 
),

ads_metrics AS (
	SELECT 
		substring(date_trunc('month', ad_date) :: TEXT, 1, 10) :: date AS ad_month,
		CASE
			(lower(substring(url_parameters, 'utm_campaign=([^&#$]+)')))
			WHEN 'nan' THEN NULL 
			ELSE 
				lower(substring(url_parameters, 'utm_campaign=([^&#$]+)'))	
		END AS utm_campaign,
		sum(spend) AS spend,
		sum(impressions) AS impressions,
		sum(clicks) AS clicks,
		sum(value) AS value,
		CASE 
			WHEN sum(impressions) != 0 THEN 100 * sum(clicks) :: NUMERIC / sum(impressions)
		END AS ctr,
		CASE 
			WHEN sum(clicks) != 0 THEN sum(spend) :: NUMERIC / sum(clicks)
		END AS cpc,
		CASE 
			WHEN sum(impressions) != 0 THEN 1000 * sum(spend) :: NUMERIC / sum(impressions)
		END AS cpm,
		CASE 
			WHEN sum(spend) != 0 THEN 100 * ((sum(value) - sum(spend)) / sum(spend) :: NUMERIC )
		END AS romi
	FROM
		ads_basics
	GROUP BY 
		ad_month,
		utm_campaign
	ORDER BY
		2, 1
)

SELECT 
	utm_campaign,
	ad_month,
	spend,
	impressions,
	clicks,
	value,
	ctr,
	100 * (ctr - LAG (ctr, 1) OVER (
		PARTITION BY utm_campaign
		ORDER BY 1
	)) / LAG (ctr, 1) OVER (
		PARTITION BY utm_campaign
		ORDER BY 1
	) AS diff_ctr,
	cpc,
	100 * (cpc - LAG (cpc, 1) OVER (
		PARTITION BY utm_campaign
		ORDER BY 1
	)) / LAG (cpc, 1) OVER (
		PARTITION BY utm_campaign
		ORDER BY 1
	) AS diff_cpc,
	cpm,
	100 * (cpm - LAG (cpm, 1) OVER (
		PARTITION BY utm_campaign
		ORDER BY 1
	)) / LAG (cpm, 1) OVER (
		PARTITION BY utm_campaign
		ORDER BY 1
	) AS diff_cpm,
	romi,
	100 * (romi - LAG (romi, 1) OVER (
		PARTITION BY utm_campaign
		ORDER BY 1
	)) / LAG (romi, 1) OVER (
		PARTITION BY utm_campaign
		ORDER BY 1
	) AS diff_romi
FROM 
	ads_metrics
