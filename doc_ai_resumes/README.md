# Document AI: Resume Extraction

### Part 1: Document AI Training
#### setup
- Go to AI/ML -> Document AI
- Select + Build
- Enter build name “DOCUMENT_AI_RESUME_ANALYSIS_[YOUR_NAME]”
- Select "DOC_AI_RESUMES" for the database, "PUBLIC" for the schema
- Add description like “Capital One AI Hackathon with Document AI”
- Select Create

#### train
- Upload the 13 .pdf resumes available in the resumes folder to train the zero-shot model
- See question optimization documentation for extracting information with Document AI
1. Use plain English
2. Know the expected answers beforehand
3. Be specific with questions, especially for documents with multiple similar fields
4. Ask for single values in each question
5. Avoid expecting the model to make assumptions or use domain knowledge. 
- Select Define Values to enter specific values for your model. Document AI values consist of a value name and a question you want to ask the model. If the documents are loaded and the option to select “Define Values” does not appear, refresh your browser.
- Use the following information to create entities:  

| Entity Name        | Entity Value                                                       | Example                                          |
|--------------|--------------------------------------------------------------------|--------------------------------------------------|
| `name`       | What is the name of the candidate?                                                            | `Joe Smith`         |
| `location`       | Where is the candidate located?                           | `Austin, TX`                              |
| `ui_ux`       | Does the candidate have UI/UX design skills?                                                            | `yes`         |
| `front_end`       | Does the candidate have HTML, CSS, and/or JavaScript skills?                           | `no`                              |
| `graphic`       | Does the candidate have experience with graphic design tools like Adobe Photoshop, Illustrator, or Sketch?                                                            | `yes`         |
| `ecommerce`       | Does the candidate have e-commerce integration skills?                           | `no`                              |
| `education`       | Does the candidate have at least a bachelor degree?                                                             | `yes`         |
| `what_education`       | What is the highest level of education?                             | `Masters in Data Science`                              |
| `work`       | What is the name of the most recent place of work?                                                             | `Snowflake Inc.`         |
| `email`       | What is the candidates email address?                              | `allison.godfrey@snowflake.com`                              |


- Once you have reviewed all 13 resumes and selected “Accept all and review next”, select the < to the left of the Documents review, then select “Publish” button.

### Part 2: Fine Tune Document AI LLM
- Select each resume and review the Document AI zero-shot results
- Correct Document AI answers as appropriate  
- Once you have reviewed all 13 resumes and selected “Accept all and review next”, select the < to the left of the Documents review, then select “Publish” button. 

To assist, refer to this file for the correct answers. 

Note: You don't need to spend a lot of time on this part for the purpose of seeing the capabilities of the feature. Every answer doesn't need to be validated. 

### Part 3: Assess Document AI Results
- Go to the Build Details tab of the DOCUMENT_AI_RESUME_ANALYSIS project
- Use the model accuracy score below to evaluate the model. 
- In order to improve the model quality, you can add more documents to the dataset, review and correct answers, and continue training until you get the desired quality. You will need to create new resumes if you wish to further improve the model.

Note: In production, you would want to load and review at least 50 documents.

### Part 4: Use Document AI extracting query to create text extraction

- After "Training" and “Fine-Tuning” the Document AI project, you need to run the PREDICT function. This will extract information from documents on a stage, and will provide answers in a JSON object for each document on the stage.
- Use your recently published “DOCUMENT_AI_RESUME_ANALYSIS_[YOUR_NAME]” model
- Use the PREDICT function on the 13 resumes loaded the Snowflake Managed Stage SSE called RESUMES. (code below)
- Use LATERAL FLATTEN to flattent he json results to a structured table. (code below)

```-- Save results from Document AI PREDICT function into DOCAI_RESUMES table
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
    ecommerce;```






