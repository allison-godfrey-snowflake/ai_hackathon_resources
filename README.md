# Capital One AI Hackathon: Snowflake-Provided Resources
Happy hackathon day! We've preloaded your accounts with some synthetic data and provided some resources for your particular use cases in this repo. You can use the already set-up git integration with this repo to pull notebooks or sql files into your account, or you can pull them in manually as-needed. 

## About the accounts
There are two Snowflake Accounts available to you for the hackathon: both in aws-east-1. These accounts are not associated with the Capital One org, as they are separate Snowflake demo accounts, containing only synthetic data. One account contains the below resources and will be the primary one accessed by hackathon attendees and what your user account logins are a part of. The other account is purely for data sharing use cases if needed. Lakshama has these credentials if needed. 

## Use cases + resources

### Use case #1: Write (better) SQL queries
Primary features used: Snowflake Copilot, Snowflake In-line Copilot

1. Synthetic data: snowflake_sample_data database
- You can use this data to run queries on in workspaces (for in-line copilot) or worksheets/ notebooks (with copilot pop-up) 

2. Accessing the features
- Snowflake Copilot for notebooks and worksheets is enabled in both accounts. Access it via the icon in the upper right. 
- Snowflake In-Line Copilot is enabled in workspaces. Navigate to projects → workspaces, and access it via the icon at the top of the code editor. 
 
### Use case #2: Analyze past queries + identify broader optimization strategies
Primary features used: Cortex Analyst, Cortex Search, Cortex Agents, Snowflake Intelligence

1. Data engineering assistant (folder in github repo): this contains instructions for building a "data engineering assistant" in 10-15 mins. It's a simplified version of #2.
2. Snowflake Housekeeping Agent (folder in github repo): this is a more robust version of #1, involving 10+ tables in account_usage. Ideal if you want o build out a full solution you could take to production. 
3. Synthetic data: In order to build out account_usage views, you'll need to run some queries that you'd like to later optimize. You can run queries against any of the semantic data, but recommend using snowflake_sample_data database. (do this in workspaces to use in-line copilot to help!) 

### Use case #3: Auto Dealer Navigator
Primary features used: AISQL, Cortex Search, Cortex Analyst, Cortex Agent, Snowflake Intelligence

1. auto_dealer_navigator (folder in github repo): README contains general guidance on building this out, but leaves some parts open-ended.
2. Synthetic data: auto_dealer_navigator database
- loan_applications
- dealerships
- dealership_customer_feedback 

### Use case #4: Call center analytics (AISQL)
Primary features used: AISQL, Cortex Analyst, Streamlit in Snowflake

1. aisql_call_center_analytics_guide (in call_center_analytics folder): Contains step-by-step instructions for transcribing and augmenting call center audio files
2. Synthetic data: ai_sql_call_center_analytics database 
- Contains the audio files used in the notebook (AI generated) and the output tables from running the notebook 
- If you run the notebook yourself, edit the database and schema accordingly to your assigned database. 

### Use case #5: Resume text extraction (Document AI) 
Primary features used: Document AI 

1. doc_ai_resumes: README.md contains instructions for using Document AI for this use case.
2. Synthetic data: doc_ai_resumes database 
- Contains pdfs of fake resumes to use for Document AI

### Adhoc Needs 

1. synthetic_data_generation_adhoc: This notebook guides you through the 4 primary methods for synthetic data generation in Snowflake. You can use any of these methods to create your own synthetic data for particular use cases.
2. Synthetic Data: snowflake_sample_data
- Contains sample data about customers, orders, products, etc. We recommend starting with TPCH_SF100 schema.

