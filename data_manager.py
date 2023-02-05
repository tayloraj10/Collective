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
    "Prospect Park Dog Beach",
    "95 Prospect Park West, Brooklyn, NY 11215",
    "Fenced area for dogs to swim & splash at a lakeside beach, with off-leash sessions at certain times.",
    "https://goo.gl/maps/dvg8uZ2ff76Nrp3DA",
    "https://www.prospectpark.org/news-events/news/dog-beach-reopens-after-renovation/",
    40.66253452472573, -73.97190731055537
)


