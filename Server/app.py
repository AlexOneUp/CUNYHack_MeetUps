from flask import Flask, jsonify, request
from dotenv import load_dotenv
import googlemaps
import json
import requests
import os

app = Flask(__name__)

# Google Maps API Key
gmaps = googlemaps.Client(key=os.getenv('googlemapsAPIKey'))

@app.route('/')
def home():
    return "Hello, this is the Flask backend for your SwiftUI app!"

@app.route('/data', methods=['GET'])
def get_data():
    # Here you can fetch and return data
    data = {
        "message": "This is some data from the Flask backend."
        }
    return jsonify(data)


# This route will receive a POST request with a JSON body of Geocoding data
# Algorithm will figure out the mid point of the number of users and return the location

@app.route('/post_find_user_geocodes', methods=['POST'])
def post_find_user_geocodes():
    data = request.json

    addresses = data.get('addresses', [])
    if not addresses:
        return jsonify({"error": "No addresses provided"}), 400

    geocoded_addresses = []

    for address in addresses:
        # Geocoding an address
        geocode_result = gmaps.geocode(address)
        if geocode_result:
            geocoded_addresses.append(geocode_result[0]['geometry']['location'])
        else:
            geocoded_addresses.append({"error": "Unable to geocode address", "address": address})
    response = requests.post(url, json=data)
    return jsonify(geocoded_addresses), 200

    # Extracting the 'addresses' and 'preferences' from the JSON payload


    # Here you can add processing logic based on the received addresses and preferences
    # Calculate the mid point of the addresses and return the location
    
    

if __name__ == '__main__':
    app.run(debug=True)
