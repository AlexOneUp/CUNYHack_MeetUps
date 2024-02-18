from flask import Flask, jsonify, request

from dotenv import load_dotenv

import json
import requests
import os
from flask_cors import CORS
from mongo import create_user, auth_user

from helpers.geocode_converter import find_user_geocodes
from helpers.midpoint import getBestMidpoint
from helpers.getBusinesses import getBusinesses


app = Flask(__name__)
CORS(app)


@app.route("/")
def home():
    return "Hello, this is the Flask backend for your SwiftUI app!"


@app.route("/data", methods=["GET"])
def get_data():
    # Here you can fetch and return data
    data = {"message": "This is some data from the Flask backend."}
    return jsonify(data)


# Here you can add processing logic based on the received addresses and preferences
# Algorithm will figure out the mid point of the number of users and return the location
@app.route("/get_best_location", methods=["POST"])
def get_best_location():
    # TODO: Implement the logic to get the best location

    data = request.json
    addresses = data.get("addresses", [])
    modes = data.get("modes", [])
    modes = [mode.lower() for mode in data.get("modes", [])]

    if not addresses:
        return jsonify({"error": "No addresses provided"}), 400

    geocoded_addresses = find_user_geocodes(addresses)
    best_midpoint = getBestMidpoint(geocoded_addresses, modes)
    businesses = getBusinesses(geocoded_addresses, best_midpoint, modes)

    return jsonify({"midpoint": best_midpoint, "businesses": businesses})


@app.route("/signup", methods=["POST"])
def signup():
    data = request.get_json()

    username = data.get("username", [])
    password = data.get("password", [])
    create_user(username, password)
    return jsonify({"message": "User created successfully"})


@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()

    username = data.get("username", [])
    password = data.get("password", [])
    resp = auth_user(username, password)

    if resp:
        resp["password"] = password
        return jsonify({"message": "User authenticated", "user": resp})
    else:
        return jsonify({"message": "Username or Password is incorrect."})


if __name__ == "__main__":
    app.run(debug=True)
