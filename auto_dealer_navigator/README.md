# Auto Dealer Navigator
Use case: Capital One auto dealerships want to be able to "chat with their data" in lieu of BI dashboards (i.e. AI for BI). As an example, they want to be able to ask real-time questions of their loan application and customer feedback data in natural language. 
The synthetic data you can use for this use case is contained in the database AUTO_DEALER_NAVIGATOR. This document provides some general advice + broad steps to enable the use case, but is not as specific as the other guides and leaves many decisions up to you (on purpose)! 

Note: This does not include the actual setup of dealer accounts only having access to their subset of data, since that would imply creating many SF accounts. In production, there are many different ways to set up these row-access policies that you can talk to our Snowflake team about on OH if you're interested!

## High-level guidance
- Augment the structured data as you see fit. Some code examples are below for categorizing text or adding sentiment score. Create a new table that you'd like to use in your semantic view. 
- Create a semantic view for your 3 augmented (or the originals if you choose not to augment) structured tables. 
- Strengthen your semantic view (e.g. edit the lists of synonyms for fields, ensure the correct categorizations of dimensions and facts, add custom instructions, add join relationships, add verified queries, etc.)
- Since the feedback column is free-form text, it could benefit from a search service. This notebook contains the code to create the search service if you want to create a new one, or can use the one we've already created. Then, add the search service to the column in the semantic view by going to the customer_feedback dimension --> add search service and selecting it.
- Create a Cortex Agent that has the Cortex Analyst semantic view as a tool. 
- Access your agent through snowflake intelligence & chat with it! Give it feedback on its responses by clicking the thumbs up / down. 
- Check out the "monitoring" tab of the agent to see user feedback and traces. 

Note: there is an example semantic view and agent in the account already, in case you want to use that instead of making your own. However, highly encouraged you try out making your own. 

```
-- look at the loan application data
select * 
from loan_applications
limit 100;

-- and the feedback table
select * 
from dealership_customer_feedback
limit 100;
```
### Augment the data
Feel free to use any AISQL or Cortex function, or any other methods, to augment the data before creating a semantic view over it. Some examples of using AISQL are below. 

It looks like there is already a column for "feedback category". However, if we didn't have that and we instead wanted to categorize the feedback using AI, we could do that with AISQL! Example below. 

#### AI_CLASSIFY
```
select 
    feedback_id,
    feedback_text,
    ai_classify(feedback_text, 
        ['service_experience'
        , 'sales_experience'
        , 'overall_experience'
        , 'pricing_value'
        , 'facility_cleanliness'
        , 'finance_experience'
        , 'communication'])
from dealership_customer_feedback
limit 100;
```
#### SNOWFLAKE.CORTEX.SENTIMENT
Maybe we also want to extract the overall sentiment from the feedback text.
```
select 
    feedback_id,
    feedback_text,
    snowflake.cortex.sentiment(feedback_text) as feedback_sentiment_score,
    case 
        when feedback_sentiment_score < -0.1 then 'negative'
        when feedback_sentiment_score > 0.1 then 'positive'
        else 'neutral'
    end as feedback_sentiment_cat
from dealership_customer_feedback
limit 100;
```
#### create search service over feedback column 
```
CREATE OR REPLACE CORTEX SEARCH SERVICE customer_feedback_search_service
ON feedback_text
ATTRIBUTES feedback_id, customer_id
WAREHOUSE = default_wh
TARGET_LAG = '1 day'
EMBEDDING_MODEL = 'snowflake-arctic-embed-l-v2.0'
AS SELECT * FROM auto_dealer_navigator.public.dealership_customer_feedback;
```

