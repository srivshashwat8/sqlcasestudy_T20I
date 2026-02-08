# sqlcasestudy_T20I

**T20I Cricket Data Analysis (2024 Case Study) 🏏**

**Project Overview**
This project involves a comprehensive analysis of T20 International (T20I) cricket match data using MySQL. The goal was to transform raw, string-based match results into actionable insights, such as team performance metrics, head-to-head records, and ground-specific success rates.

**Key Technical Skills Demonstrated**
Data Cleaning: Used SUBSTRING_INDEX and CAST to extract numeric values from string columns (e.g., converting "50 runs" into an integer).

Window Functions: Applied RANK() and DENSE_RANK() with PARTITION BY to identify top performers across various categories.

CTEs & Subqueries: Used Common Table Expressions and Subqueries to perform multi-stage calculations like win percentages and comparing individual matches against global averages.

Variable Usage: Implemented MySQL session variables (SET @Variable) to create reusable, parameter-driven queries.

**Case Study Questions & Solutions**
1. Data Transformation (Winning Margins)
One of the primary challenges was the Margin column, which contained mixed text like "106 runs" or "8 wickets." I used explicit casting to enable mathematical analysis.

SQL

-- Calculating average winning margin in runs
SELECT Winner, AVG(CAST(SUBSTRING_INDEX(Margin, ' ', 1) AS UNSIGNED)) AS Avg_Margin
FROM T20I
WHERE Margin LIKE '%runs'
GROUP BY Winner;
2. Team Performance & Win Percentages
To calculate a true win percentage, I had to account for teams appearing as either Team1 or Team2. I used a UNION ALL within a CTE to normalize the team appearances.

3. Venue Analysis
I identified the most successful team at every stadium using RANK() partitioned by ground. This handles ties gracefully if multiple teams share the highest win count at a specific venue.

How to Use
Database Setup: Ensure you have a schema named sqlcasestudies.

Table Structure: The queries expect a table named t20i with columns: MatchDate, Team1, Team2, Winner, Margin, and Ground.

Running Queries: The script is optimized for MySQL Workbench.

Insights Derived
Seasonality: Identified peak match months (e.g., June 2024) using date-parsing functions.

Chasing Dominance: Isolated teams with the highest success rate when winning by wickets (chasing).

Head-to-Head: Created a flexible script to compare any two international sides instantly.

Future Enhancements
Adding a "Home vs Away" analysis by mapping grounds to team nationalities.

Visualizing these SQL results using Power BI or Python (Matplotlib).
