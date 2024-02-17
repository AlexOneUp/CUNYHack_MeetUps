from flask import Flask, jsonify, request

from dotenv import load_dotenv

import json
import requests
import os
from flask_cors import CORS

from helpers.geocode_converter import find_user_geocodes


app = Flask(__name__)
CORS(app)

@app.route('/')
def home():
    return "Hello, this is the Flask backend for your SwiftUI app!"


@app.route("/data", methods=["GET"])
def get_data():
    # Here you can fetch and return data
    data = {
        "message": "This is some data from the Flask backend."
        }
    return jsonify(data)




# Here you can add processing logic based on the received addresses and preferences
# Algorithm will figure out the mid point of the number of users and return the location
@app.route("/get_best_location", methods=["POST"])
def get_best_location():
    # TODO: Implement the logic to get the best location

    data = request.json

    # Extracting the 'addresses' from the JSON payload
    # Put into helper function to find the geocodes of users addresses
    geocoded_addresses = find_user_geocodes(data)

    # Access the addresses and preferences from the JSON data
    print(data, geocoded_addresses)
    return jsonify({"message": "Best location found."})


if __name__ == "__main__":
    app.run(debug=True)
