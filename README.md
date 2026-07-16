# Walmart End To End Project

<img width="1261" height="549" alt="image" src="https://github.com/user-attachments/assets/85fba39c-f881-4b4d-a30e-771bbc4278a6" />


This ELT project is to demonstrate how to create a data pipeline that is able to upload the files into S3 Cloud storage ingest .csv data using Python then, using n integration with a Snowflake account create the beginning stages of the ingestion process. 

New files are automatically loaded into a staging table once detected then placed in the into a raw/bronze layer schema inside of Snowflake using Snowpipe.

A DBT job can then handle the transformation in the Silver and Gold Layers preparing the data for analysis and visualization using Tableau



## Visualizations

### Weekly Sales With Average CPI And Fuel Price

<img width="1406" height="787" alt="WeeklySalesWithAvgCPIAndFuelPrice" src="https://github.com/user-attachments/assets/f8dadba1-c650-4ced-a339-31f91a904411" />



### Weekly Sales By Temperature

<img width="1666" height="832" alt="WeeklySalesByTemperature" src="https://github.com/user-attachments/assets/b7774e21-de1a-4db8-abbf-ae7ebdae9858" />



### Sales By Store Type AndMonth

<img width="1406" height="832" alt="SalesByStoreTypeAndMonth" src="https://github.com/user-attachments/assets/659cf5c3-75f8-436d-932b-3111c44b7751" />

