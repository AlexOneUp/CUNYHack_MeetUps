from flask import jsonify
from dotenv import load_dotenv
import googlemaps
import json
import requests
import os

# Google Maps API Key
gmaps = googlemaps.Client(key=os.getenv("googlemapsAPIKey"))


# This route will receive a POST request with a JSON body of Geocoding data
# Returns an array of geocoded addresses (Objects with lat and lng keys)
geocoded_addresses = []


def find_user_geocodes(addresses):
    geocoded_addresses = []
    for address in addresses:
        # Geocoding an address
        geocode_result = gmaps.geocode(address)
        if geocode_result:
            geocoded_addresses.append(geocode_result[0]["geometry"]["location"])
        else:
            geocoded_addresses.append(
                {"error": "Unable to geocode address", "address": address}
            )
    return geocoded_addresses
