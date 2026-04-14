# IPL Data Engineering Pipeline (Spark + Databricks + S3)


## Overview
* This project implements a **production-style ETL (Extract, Transform, Load) pipeline** using Apache Spark on Databricks.
* The pipeline ingests ball by ball, player and match data from multiple sources, performs data cleaning, joins datasets, computes aggregated metrics.
* Processed ball-by-ball IPL data spanning multiple seasons (~100K+ records)
* Implemented notebook-based orchestration using dbutils to simulate DAG execution.


## Project Highlights
- Designed and implemented an end-to-end ETL pipeline using Apache Spark
- Processed multi-source IPL datasets into structured Bronze, Silver, and Gold layers
- Performed complex transformations using Spark SQL (joins, aggregations, window functions)
- Built notebook-based orchestration to simulate production DAG workflows
- Optimized data storage using Parquet with partitioning


## Problem Statement
Given raw IPL cricket data (2008–2017) from multiple sources stored in S3, design and build a scalable ETL pipeline to ingest, clean, transform, and model the data into analytics-ready datasets for downstream consumption.

The pipeline enables insights such as:
* Batsmen Performance
* Bowler Performance
* Match Summary
* Top batsman per season
* Powerplay Bowler Efficiency
* Toss impact on the match


## Pipeline Structure

```text
ipl-data-engineering-pipeline/

│── notebooks/
│     ├── 00_ipl_pipeline_runner.ipynb
│     ├── 01_ipl_bronze_ingestion.ipynb
│     ├── 02_ipl_silver_transformation.ipynb
│     └── 03_ipl_gold_aggregation.ipynb

│── sql/
│     └── gold_queries.sql

│── screenshots/
│     └── batsmen_performance.png
│     └── bowler_performance.png
│     └── match_summary.png
│     └── top_batsman_per_season.png
│     └── bowlers_powerplay_efficiency.png
│     └── toss_impact.png

│── README.md
│── requirements.txt
```


## Architecture
```text
+-------------------+
|   S3 Raw Data     |
+-------------------+
         ↓
+-------------------+
|   Bronze Layer    |
|   (Ingestion)     |
+-------------------+
         ↓
+-------------------+
|   Silver Layer    |
| (Cleaning + Joins)|
+-------------------+
         ↓
+-------------------+
|   Gold Layer      |
|   (Analytics)     |
+-------------------+
         ↓
+-------------------+
|  S3 Curated Data  |
+-------------------+
```

## Tech Stack
- Apache Spark (PySpark)
- Databricks (Notebook-based execution)
- Amazon S3 (Data Lake storage)
- SQL (Spark SQL for transformations)
- Python (Pipeline orchestration & transformations)


## Data Pipeline
### Bronze:
- Ingested raw CSV data from Amazon S3
- Read the data and applied explicit schema enforcement
- Standardized inconsistent date formats
- Partitioned and stored the files in Parquet format and written back to S3

### Silver:
- Fetched the raw, schema enforced, bronze level data and performed Data Cleaning.
- Derived additional columns that would contribute to gold level analytical aggregations
- Enriched data by joining player, team, and match datasets
- Prepared a unified dataset optimized for aggregation and analytics

### Gold:
Applied aggregation logic to generate analytics-ready datasets including:
* Batsmen Performance
* Bowler Performance
* Match Analysis
* Top batsmen per Season
* Bowlers Efficiency in Powerplay overs
* Impact on the match result based on the toss


## Sample Outputs

### Batsman Performance
Shows total runs, strike rate, and balls faced per batsman.

### Bowler Performance
Displays economy rate, wickets, and overs bowled.

### Match Summary
Aggregated match-level insights including total runs and teams.

(Screenshots available in /screenshots folder)


## How to Run
1. Upload the raw IPL dataset to Amazon S3 under the specified input path.
2. Open the project in Databricks and attach a cluster.
3. Execute the notebooks in the following order:
   - 01_ipl_bronze_ingestion
   - 02_ipl_silver_transformation
   - 03_ipl_gold_aggregation
4. Alternatively, run the orchestration notebook:
   - 00_ipl_pipeline_runner
5. Verify the output data in S3 under Bronze, Silver, and Gold directories.

Note: The pipeline is designed to run on Databricks with access to Amazon S3.