from flask import Flask, jsonify, request
from flask_cors import CORS
from mongo import create_user, auth_user

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


@app.route("/submit", methods=["POST"])
def submit_data():
    # Here you can handle data sent from your SwiftUI app
    received_data = request.json
    # Process the received_data as needed
    return jsonify(
        {"message": "Data received successfully.", "received": received_data}
    )


@app.route("/get-best-location", methods=["POST"])
def get_best_location():
    # TODO: Implement the logic to get the best location
    data = request.get_json()

    # Access the addresses and preferences from the JSON data
    addresses = data.get("addresses", [])
    preferences = data.get("preferences", [])
    print(data, addresses, preferences)
    return jsonify({"message": "Best location found."})


@app.route("/signup", methods=["POST"])
def signup():
    data = request.get_json()

    name = data.get("name", [])
    password = data.get("password", [])
    create_user(name, password)
    return jsonify({"message": "User authenticated"})


@app.route("/login", methods=["GET"])
def login():
    data = request.get_json()

    name = data.get("name", [])
    password = data.get("password", [])
    resp = auth_user(name, password)
    if resp:
        resp["password"] = password
        return jsonify({"message": "User authenticated", "user": resp})
    else:
        return jsonify({"message": "Username or Password is incorrect."})


if __name__ == "__main__":
    app.run(debug=True)
