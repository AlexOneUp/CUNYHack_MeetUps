from flask import jsonify
from dotenv import load_dotenv
import googlemaps
import json
import requests
import os

# Google Maps API Key
gmaps = googlemaps.Client(key=os.getenv('googlemapsAPIKey'))


# This route will receive a POST request with a JSON body of Geocoding data
# Returns an array of geocoded addresses (Objects with lat and lng keys)
geocoded_addresses = []

def find_user_geocodes(data):
    addresses = data.get('addresses', [])
    if not addresses:
        return jsonify({"error": "No addresses provided"}), 400

    # geocoded_addresses = []

    for address in addresses:
        # Geocoding an address
        geocode_result = gmaps.geocode(address)
        if geocode_result:
            geocoded_addresses.append(geocode_result[0]['geometry']['location'])
        else:
            geocoded_addresses.append({"error": "Unable to geocode address", "address": address})
    
    # This will throw errors because of url
    # response = requests.post(url, json=data)

    return geocoded_addresses

    # Extracting the 'addresses' and 'preferences' from the JSON payload
    # addresses = data.get('addresses', [])
    # preferences = data.get('preferences', [])
    # if not addresses:
    #     return jsonify({"error": "No addresses provided"}), 400
    # if not preferences:
    #     return jsonify({"error": "No preferences provided"}), 400

    # # Geocoding an address
    # geocode_result = gmaps.geocode(addresses[0])
    # if geocode_result:
    #     return jsonify(geocode_result[0]['geometry']['location']), 200
    # else:
    #     return jsonify({"error": "Unable to geocode address", "address": addresses[0]}), 400
    # return jsonify({"error": "An error occurred"}), 500
    # return jsonify(geocoded_addresses), 200

def find_midpoint(geocoded_addresses):
    # Extracting the 'lat' and 'lng' from the geocoded addresses
    latitudes = [address['lat'] for address in geocoded_addresses]
    longitudes = [address['lng'] for address in geocoded_addresses]

    # Calculating the midpoint
    midpoint = {
        "lat": sum(latitudes) / len(latitudes),
        "lng": sum(longitudes) / len(longitudes)
    }
    return midpoint