import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from pprint import pprint

cred = credentials.Certificate(r"C:\Users\taylo\Downloads\collective-e06e1-firebase-adminsdk-2iy4z-ffbbbb44b6.json")
app = firebase_admin.initialize_app(cred)
db = firestore.client()



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


