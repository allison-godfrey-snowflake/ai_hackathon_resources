# Data Engineering Agent

This is a guide to building a data engineering assistant in 10-15 mins. If you'd like to build a more robust version of this, see "Snowflake Housekeeping Agent" instructions. 

### Set the context 
```
USE DATABASE [YOUR_ASSIGNED_DATABASE];
CREATE SCHEMA IF NOT EXISTS SEMANTIC_VIEWS;
```


### Step 1: Connect to Snowflake Knowledge Base
Note: If the Snowflake Documentation CKE has already been added to your account, you only need to validate that you see it and can access it. However, it is helpful to navigate to the Marketplace to see how you would get it if you needed to. 
- Navigate to Data Products > Marketplace
- Search: "Snowflake Documentation"
- Add the Cortex Knowledge Extension for real-time best practice recommendations (if it's already added, you're good to go. But helpful to see how you would get it from the marketplace either way!)
- Validate access to SNOWFLAKE_DOCUMATION.SHARED database/schema
- Validate access to search service CKE_SNOWFLAKE_DOCS_SERVICE 
- Grant access to PUBLIC role

### Step 2: Create Your Performance Analytics Foundation
- Navigate to AI & ML > Cortex Analyst
- Using the Cortex Analyst Guide UI, select Create new Semantic View
- Provide Name: SNOWFLAKE_USAGE_ASSISTANT
- Select Location: [YOUR_ASSIGNED_DATABASE].SEMANTIC_VIEWS
- Provide Semantic View Description: "Unlock hidden performance insights from your query history to drive measurable cost savings and performance improvements."
- Select SNOWFLAKE.ACCOUNT_USAGE views
- Select QUERY_ATTRIBUTION_HISTORY and QUERY_HISTORY tables. Optionally add any others (e.g. QUERY_INSIGHTS, WAREHOUSE_LOAD_HISTORY, WAREHOUSE_METERING_HISTORY, SCHEMATA, ROLES, , TABLES, USERS, VIEWS, TAGS, ROW_ACCESS_POLICIES, DATABASES)
- Select all columns (85 columns) from the QUERY_ATTRIBUTION_HISTORY and QUERY_HISTORY tables
- Create a Cortex Search Service on columns DATABASE_NAME, USER_NAME, WAREHOUSE_NAME, WAREHOUSE_SIZE, WAREHOUSE_TYPE. Keep the default options, but suggest changing the target lag to 1 day. 

Then you can explore your SNOWFLAKE_USAGE_ASSISTANT Semantic View. 
You could ask something like “What was the longest running query in the past week?” in the Enter prompt.

Note: An example of a fully-developed semantic model for this use case is in the semantic model stage in data_engineer_assistant.public schema. Check it out if you'd like to see what it can become! 

### Step 3: Deploy Your AI Assistant
- Navigate to AI & ML > Agents
- Select Create agent with pre-configured optimization intelligence (schema SNOWFLAKE_INTELLIGENCE.AGENTS)
- Provide Name: DATA_ENGINEER_ASSISTANT_[YOUR_NAME]
- Provide Display Name: Data Engineer Assistant [your name]
- Select the created agent and select Edit
- On the About tab, provide Agent Description: I'm your Snowflake Data Engineer Assistant, designed to help you optimize query performance and resolve data engineering challenges. I analyze your actual query history to provide personalized, actionable recommendations for your Snowflake environment.
- Select Save
- On the Instructions tab, provide Response instructions and Sample Questions   

Recommended Response Instructions:

You are a Snowflake Data Engineer Assistant. Always provide:   
• **Specific recommendations** with clear next steps   
• **Actual metrics** from query history data     
• **Prioritized solutions** (high-impact first)   
• **Snowflake best practices** (Gen 2 warehouses, clustering, modern SQL)   

Recommended Sample Questions (Add these questions one by one using "Add a question"):   
- Based on my top 10 slowest queries, can you provide ways to optimize them?
- What was the query that's causing performance issues?
- How can I optimize this specific query?
- Which warehouses should be upgraded to Gen 2?
- Show me queries with compilation errors and how to fix them
- What queries are scanning the most data and how can I reduce that?
- Which time series SQL functions should I use for temporal analysis?
- What are the most common query patterns causing issues?
- How can I improve query compilation times?
- What Snowflake features am I not using that could help performance?
- Would my query benefit from Query Acceleration or Search Optimization Service? 


Select Save

### Provide tools for your agent

#### Cortex analyst tool 

- On the Tools tab, connect your Semantic View and Cortex Search Services
- For Cortex Analyst option, select + Add
- Select Semantic View and navigate to [YOUR_ASSIGNED_DATABASE].SEMANTIC_VIEWS
- Link to your SNOWFLAKE_USAGE_ASSISTANT
- Provide a Name: Data_Engineer_Assistant_Semantic_View
- Provide Description: 

"Use this tool to analyze Snowflake query performance and identify optimization opportunities. This semantic view provides access to query history data, including execution times, compilation times, bytes scanned, warehouse usage, and error information. 
Use this tool when users ask about:
- Slowest running queries and performance bottlenecks
- Query optimization recommendations 
- Warehouse utilization and sizing recommendations
- Compilation errors and troubleshooting
- Data scanning patterns and efficiency analysis
- Historical query trends and usage patterns

The tool returns structured data about query performance metrics that can be used to provide specific, actionable optimization recommendations."


- Use the User’s default for warehouse   
- Suggest using 100 for the Query timeout
- Select Add


#### Cortex search tool 

- For Cortex Search Services option, select + Add
- Provide a Name:  Cortex_Knowledge_Extension_Snowflake_Documentation_[your_name]
- Provide Description: Search Snowflake Documentation via Snowflake Marketplace Knowledge Extension. 
- Select SNOWFLAKE_DOCUMATION.SHARED for database/schema
- Link to search service CKE_SNOWFLAKE_DOCS_SERVICE 
- Select SOURCE_URL for ID column
- Select DOCUMENT_TITLE for Title column
- Select Add


Save your agent

### Add orchestration instructions

- On the Orchestration tab, select the model and provide Planning Instructions
- Keep the Orchestration model as auto
- Provide Planning Instructions

"For query performance analysis requests:
1. First, query the semantic view to identify relevant queries, performance metrics, and patterns
2. Analyze execution times, compilation times, bytes scanned, and warehouse usage
3. Prioritize findings by impact (slowest queries, highest resource usage, most frequent errors)
4. Use Snowflake documentation search to reference best practices and specific features
5. Provide specific, actionable recommendations with clear next steps


For optimization questions:
1. Start with the query history data to understand current performance
2. Identify bottlenecks and inefficiencies in the data
3. Reference Snowflake documentation for feature recommendations (Gen 2 warehouses, clustering, etc.)
4. Provide concrete optimization steps with expected improvements


For troubleshooting:
1. Analyze error patterns and compilation issues from query history
2. Search documentation for specific error resolution guidance  
3. Provide step-by-step fixes and prevention strategies


Always ground recommendations in actual data from the user's query history."

On the access tab, recommend adding "public" role to usage. 

### Access agent via Snowflake Intelligence
- Navigate to Snowflake Intelligence - recommend opening in a new tab for testing
- The PUBLIC role should have access, but if not, you may need to switch your role to one that does.
- Select the Data Engineer Assistant and keep Sources: Auto
- Test some of the clickable questions

Optional flow (keep in mind the responses here are based on queries run in this particular account, which is scarce. You can run more queries in a separate worksheet to add them to query_history and then ask about them here.): 
- Based on my top 10 slowest queries, what specific optimizations would have the biggest impact on performance?
- Which warehouses should be upgraded to Gen 2 and what would be my estimated cost savings?
- Show me queries with compilation errors and provide step-by-step fixes.
- What Snowflake features am I not using that could help performance?

### Opportunities for Expansion
This demo account does not have access to do these things, but here are some things you could do in production to make this more integrated and useful in your workflows. 

- Add additional account usage views to analyze spend 
- Create a semantic view on top of Snowflake events table for triaging errors, connect your internal documentation (Confluence) and code (Github repository) to debug pipelines faster 
- Connect Agents API directly to your IDE (Cursor / VSCode ) 
