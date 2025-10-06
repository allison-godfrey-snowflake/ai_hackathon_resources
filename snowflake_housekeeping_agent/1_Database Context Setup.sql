-- USE ROLE ACCOUNTADMIN;

-- 1. Use your assigned database, or create a new database called PLATFORM_ANALYTICS_[YOUR_ROLE_NAME]
USE DATABASE [YOUR_ASSIGNED_DATABASE];

-- 2. Create a schema within the new database to hold semantic models
CREATE SCHEMA IF NOT EXISTS [YOUR_ASSIGNED_DATABASE].SEMANTIC_MODELS
  COMMENT = 'Schema to store semantic models and related views for Cortex Analyst.';

-- 3. Create a stage for the YAML specification files with a directory enabled
CREATE STAGE IF NOT EXISTS [YOUR_ASSIGNED_DATABASE].SEMANTIC_MODELS.SEMANTIC_MODEL_SPECS
  DIRECTORY = ( ENABLE = true )
  COMMENT = 'Stage for storing semantic model YAML specification files.';


