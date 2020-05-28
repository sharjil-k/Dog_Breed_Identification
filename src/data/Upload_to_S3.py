import os
import boto3
from botocore import UNSIGNED
from botocore.client import Config

s3_resource = boto3.resource("s3", region_name="us-east-1", config=Config(signature_version=UNSIGNED))

def upload_objects():
    try:
        bucket_name = "dogimagesfromstanford" #s3 bucket name
        root_path = r"C:/Users/shkhan2/Downloads/images/" # local folder for upload
        my_bucket = s3_resource.Bucket(bucket_name)

        for path, subdirs, files in os.walk(root_path):
               path = path.replace("\\","/")
               directory_name = path.replace(root_path,"")
               for file in files:
                  print(directory_name)
                  print("      {}".format(file))
                  my_bucket.upload_file(os.path.join(path, file), directory_name+'/'+file)

    except Exception as err:
        print(err)

if __name__ == '__main__':
    upload_objects()