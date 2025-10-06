CREATE TABLE [YOUR_ASSIGNED_DATABASE].PUBLIC.DOCAI_RESUMES (src variant) AS (
SELECT * FROM (SELECT DOC_AI_RESUMES.PUBLIC.DOCUMENT_AI_RESUME_ANALYSIS_TEST!PREDICT(
  GET_PRESIGNED_URL(@DOC_AI_RESUMES.PUBLIC.RESUMES, RELATIVE_PATH), 1) as JSON
FROM DIRECTORY(@DOC_AI_RESUMES.PUBLIC.RESUMES)
));

-- create a structured table from the json output
CREATE OR REPLACE TABLE RESUMES_ABT AS
SELECT
    REPLACE(name, '"', '') AS name,
    REPLACE(location, '"', '') AS location,
    REPLACE(email, '"', '') AS email,
    REPLACE(work, '"', '') AS work,
    REPLACE(education, '"', '') AS education,
    REPLACE(what_education, '"', '') AS what_education,
    REPLACE(ui_ux, '"', '') AS ui_ux,
    REPLACE(front_end, '"', '') AS front_end,
    REPLACE(graphic, '"', '') AS graphic,
    REPLACE(ecommerce, '"', '') AS ecommerce, 
FROM (    
    SELECT
        src:name[0].value AS name,
        src:location[0].value AS location,
        src:email[0].value AS email,
        src:work[0].value AS work,
        src:education[0].value AS education,
        src:what_education[0].value AS what_education,
        src:ui_ux[0].value AS ui_ux,
        src:front_end[0].value AS front_end,
        src:graphic[0].value AS graphic,
        src:ecommerce[0].value AS ecommerce, 
    FROM DOCAI_RESUMES_TEST,
        LATERAL FLATTEN (input => src) AS src
) AS flattened_data
GROUP BY
    name,
    location,
    email,
    work,
    education,
    what_education,
    ui_ux,
    front_end,
    graphic,
    ecommerce;


