🏏 IPL Data Analysis Project

📌 Overview

This project is an end-to-end data analysis of the Indian Premier League (IPL) dataset. It covers the complete data pipeline—from data cleaning and transformation to SQL-based analysis and interactive dashboard visualization.

The goal of this project is to extract meaningful insights about player performance, team strategies, and match outcomes using real-world cricket data.

🛠️ Tech Stack
Python (Pandas, NumPy) → Data cleaning & preprocessing
MySQL → Data storage & analytical queries
Power BI → Interactive dashboard & visualization
📂 Dataset
Source: Kaggle IPL Dataset
Files used:
matches.csv → Match-level data
deliveries.csv → Ball-by-ball data
🔄 Project Workflow

1️⃣ Data Cleaning (Python)
Handled missing values (winner, city, etc.)
Standardized team names across seasons
Removed duplicates and inconsistent records
Converted data types for accurate analysis

2️⃣ Feature Engineering
Created new metrics such as:
Strike Rate
Boundary %
Match Year
Phase of play (Powerplay, Middle, Death overs)

3️⃣ Data Storage (MySQL)
Designed relational database schema
Imported cleaned datasets into MySQL
Created indexes for optimized query performance

4️⃣ SQL Analysis
Performed advanced analytical queries such as:

Top run scorers and wicket takers
Best strike rates (with minimum ball criteria)
Team win percentages
Toss impact on match outcomes
Player and team performance trends

5️⃣ Power BI Dashboard

Built an interactive dashboard with:

📊 Overview
Total matches, runs, and players
Matches per season
🏏 Batting Analysis
Top batsmen
Strike rate vs total runs
Boundary analysis
🎯 Bowling Analysis
Top bowlers
Economy rate
Wickets by match phase
🏆 Team Insights
Win percentage
Toss impact
Venue-based performance

🔍 Key Insights
Teams winning the toss have a slight advantage in match outcomes
Certain venues consistently produce high-scoring matches
Top-order batsmen dominate scoring in powerplay overs
Death-over specialists significantly impact match results

🚀 How to Run This Project
1. Clone Repository
git clone https://github.com/your-username/ipl-data-analysis.git
2. Python Setup
pip install pandas numpy mysql-connector-python
3. Load Data
Place dataset files in project directory
Run Python scripts for cleaning
4. MySQL Setup
Create database
Import cleaned data
Run SQL queries
5. Power BI
Connect to MySQL database
Load tables and build dashboard
📌 Project Highlights
End-to-end data pipeline
Real-world sports analytics use case
Strong combination of Python + SQL + BI tools
Interactive and business-oriented insights
📎 Future Improvements
Build machine learning model for match prediction
Player performance forecasting
Real-time dashboard using live data APIs
👨‍💻 Author

Karan Patel

⭐ If you like this project

Give it a star ⭐ on GitHub!
