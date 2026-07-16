-- S3 ingestion pipeline for Walmart department data into Snowflake

--Set theole warehouse database and schema

USE ROLE ACCOUNTADMIN;

USE WAREHOUSE COMPUTE_WH;

CREATE OR REPLACE DATABASE WALMART_DB;
USE DATABASE WALMART_DB;

CREATE OR REPLACE SCHEMA WALMART_DB.RAW;
USE SCHEMA WALMART_DB.RAW;



CREATE STORAGE INTEGRATION IF NOT EXISTS WMART_DEPARTMENT_INT
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = 'S3'
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::*************:role/wm-e2e-snowflake-role'
STORAGE_ALLOWED_LOCATIONS = ('s3://walmart-end-to-end-project/wm-department/')

DESC INTEGRATION WM_DEPARTMENT_INT;


-- --Create a File Format to be used during upload (basically upload settings)
CREATE OR REPLACE FILE FORMAT WM_CSV_FORMAT
TYPE = 'CSV'
FIELD_DELIMITER = ','
RECORD_DELIMITER = '\n'
SKIP_HEADER = 1
DATE_FORMAT = 'AUTO'
NULL_IF = ('NA', ''); 

-- --Create an external S3 stage table to hold data for transfer into snowflake
CREATE STAGE IF NOT EXISTS WM_DEPARTMENT_S3_STAGE
STORAGE_INTEGRATION = WM_DEPARTMENT_INT
URL = 's3://walmart-end-to-end-project/wm-department/'
FILE_FORMAT = WM_CSV_FORMAT;

--show integration is working
LIST @WALLMART_DB.RAW.WM_DEPARTMENT_S3_STAGE;

--carete bronze/raw layer table that will be written to by snowpipe ingestion
CREATE OR REPLACE TABLE DEPARTMENT
(
Store INT,
Dept INT,
Date DATE,
Weekly_Sales NUMBER(15, 2),
Is_Holiday BOOLEAN,
Loaded_At TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

--create snowpipe to automatically ingest
CREATE OR REPLACE PIPE WALMART_DB.RAW.STAGING_TO_RAW
AUTO_INGEST = TRUE
AS 
COPY INTO WALMART_DB.RAW.DEPARTMENT (
    Store,
    Dept,
    Date,
    Weekly_Sales,
    Is_Holiday,
    Loaded_At 
)
FROM (
    SELECT
        $1::INT,
        $2::INT,
        $3::DATE,
        $4::NUMBER(15,2),
        $5::BOOLEAN,
        CURRENT_TIMESTAMP()
    FROM @WALMART_DB.RAW.WM_DEPARTMENT_S3_STAGE
)
FILE_FORMAT = (FORMAT_NAME = WALMART_DB.RAW.WM_CSV_FORMAT);


SHOW PIPES;


SELECT * FROM WALMART_DB.RAW.DEPARTMENT
