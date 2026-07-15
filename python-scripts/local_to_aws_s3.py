import boto3
import sys
from pathlib import Path
from boto3.exceptions import S3UploadFailedError
from botocore.exceptions import ClientError
from datetime import datetime


'''
Creating Class to be used by script
'''

class S3UploadDM:
    def __init__(self, local_file_name , relative_path_folder, s3Folder):
        self.local_file_name = local_file_name
        self.relative_path_folder = relative_path_folder
        self.s3Folder = s3Folder


'''
Script Logic and Definitions
'''


CURRENT_DIR = Path(__file__).resolve().parent

PROJECT_ROOT = CURRENT_DIR.parent

sys.path.append(str(PROJECT_ROOT))

now = datetime.now()

formatted_datetime= now.strftime("%d-%m-%Y:%H:%M:%S")



fact_upload_dm = S3UploadDM("fact.csv",  "data", "wm-fact")
wm_department_upload_dm = S3UploadDM("department.csv", "data", "wm-department")
wm_stores_upload_dm = S3UploadDM("stores.csv", "data", "wm-stores")


uploadList = [fact_upload_dm, wm_department_upload_dm, wm_stores_upload_dm]

# Connecting to AWS S3
def s3_upload(file_path:str, file_name:str, s3_folder:str, bkt:str) -> bool:
  s3_resource = boto3.resource('s3', 'us-east-1') 
  s3_bucket = s3_resource.Bucket(name=bkt)

  try:
    s3_bucket.upload_file(
      Filename = file_path,
      Key = s3_folder + '/' + file_name + "@" + formatted_datetime
    )

  except S3UploadFailedError as e:
    print(f"Error uploading file {file_name} to S3: {e}")
    return False
  
  except ClientError as e:
    print(f"Client error occurred while uploading file {file_name} to S3: {e}")
    return False
  
  except Exception as e:
    print(f"An unexpected error occurred while uploading file {file_name} to S3: {e}")
    return False
  
  return True
    
#Can be run as a lambda function but should run locally
#You wnat this filder list to come from the local file directory and then upload to S3.
def add_local_files_to_s3(local_file_list: list[S3UploadDM], bkt: str) -> None:

  BASE_DIR = Path(__file__).resolve().parent.parent

  
  for item in local_file_list:

    
    file_path = BASE_DIR / item.relative_path_folder / item.local_file_name
    
    status = s3_upload(str(file_path), item.local_file_name, item.s3Folder, bkt)

    if (status):
      print(f'Data is saved for {item.local_file_name} in S3 bucket {bkt} under folder {item.s3Folder} ')
    else:
      print(f'Error while loading data for {item.local_file_name}')

  return status



bucket  = "walmart-end-to-end-project"

add_local_files_to_s3(uploadList, bucket)


  
