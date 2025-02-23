from googleapiclient.discovery import build
from google.oauth2 import service_account
import os
from pydrive.drive import GoogleDrive
from pydrive.auth import GoogleAuth
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import storage
from pprint import pprint

cred = credentials.Certificate(
    "collective-sa.json")
app = firebase_admin.initialize_app(cred)
db = firestore.client()


uid = 'b6TiWHHqTL8xgFZD3uVe'
user_doc_ref = db.collection(u'users').document(uid)
user_doc = user_doc_ref.get()
print(user_doc.to_dict())
if user_doc.exists:
    db.collection(u'users').document(user_doc.to_dict()['uid']).set(
        user_doc.to_dict(), merge=True)


### DATA
def view_locations_data():
    for x in db.collection(u'locations').get():
        pprint(x.to_dict())


def create_new_location(name, address, description, glink, website, lat, lon):
    data = {'name': name,
            'address': address,
            'description': description,
            'glink': glink,
            'website': website,
            'lat_lon': [lat, lon],
            'visited': ['',],
            }
    db.collection(u'locations').add(data)


create_new_location(
    "City Climb",
    "30 Hudson Yards, New York, NY 10001",
    "Scale the outside of a skyscraper more than 1,200 feet above the ground, then lean out and look down from the highest outdoor platform in New York City",
    "https://goo.gl/maps/nbh1EJ1s3Xorp2QL7",
    "https://www.edgenyc.com/cityclimb",
    40.75400105083589, -74.00031133226625
)


### PHOTOS
import os
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import storage
from datetime import datetime, timedelta
import pytz
import shutil

# If modifying these SCOPES, delete the file token.json.
SCOPES = ['https://www.googleapis.com/auth/drive.file']
SERVICE_ACCOUNT_FILE = "collective-sa.json"
PHOTOS_SERVICE_ACCOUNT_FILE = "collective-photo-sa.json"
PHOTOS_FOLDER_ID = '1VHRjAyYyW2PGv8OVhVX91laIghzic8ET'

cred = credentials.Certificate(
    "collective-sa.json")
appF = firebase_admin.initialize_app(cred, 
                                    {'storageBucket': 'collective-e06e1.appspot.com',})
db = firestore.client()

photo_cred = service_account.Credentials.from_service_account_file(
    PHOTOS_SERVICE_ACCOUNT_FILE, scopes=SCOPES)
service = build('drive', 'v3', credentials=photo_cred)

def upload_photo(file_path, file_name):
    file_metadata = {'name': file_name, 'parents': [PHOTOS_FOLDER_ID]}
    media = MediaFileUpload(file_path, mimetype='image/jpeg')
    file = service.files().create(body=file_metadata, media_body=media, fields='id').execute()
    print(f"File ID: {file.get('id')}")
    return file.get('id')

def update_photo_url(id, fb_id, index):
    updated = False
    gdrive_url = 'https://drive.usercontent.google.com/download?id='
    doc_ref = db.collection(u'goal_submissions').document(fb_id)
    doc = doc_ref.get()
    if doc.exists:
        images = doc.to_dict().get('images', [])
        if len(images) > index:
            images[index] = gdrive_url + id
        doc_ref.update({u'images': images})
        updated = True
        print(f"Updated document {doc.id} with image ID {id}")
    return updated
    

def move_storage_files_to_gdrive():
    folder_name = 'initiative_photos'
    if os.path.exists(folder_name):
            shutil.rmtree(folder_name)
    bucket = storage.bucket(app=appF)
    blobs = bucket.list_blobs(prefix='initiatives/')
    tz = pytz.utc
    one_week_ago = datetime.now(tz) - timedelta(weeks=1)
    files = [blob for blob in blobs if blob.time_created < one_week_ago and blob.name != 'initiatives/']
    
    if len(files) > 0:
        filename_counts = {}
        for file in files:
            filename = file.name.split('initiatives/', 1)[1]
            file_path = os.path.join(folder_name, filename)
            os.makedirs(os.path.dirname(file_path), exist_ok=True)
            with open(file_path, 'wb') as f:
                file.download_to_file(f)
            print(f"Downloaded {filename}")
            fb_id = filename.split('_', 1)[0]
            if fb_id in filename_counts:
                filename_counts[fb_id] += 1
            else:
                filename_counts[fb_id] = 0

            id = upload_photo(file_path, filename)
            if id:
                update_photo_url(id, fb_id, filename_counts[fb_id])
                file.delete()
                # delete_blob = bucket.blob(file.name)
                # delete_blob.delete()
                print(f"Deleted {file.name} from Google Cloud Storage\n\n")

        if os.path.exists(folder_name):
            shutil.rmtree(folder_name)


move_storage_files_to_gdrive()