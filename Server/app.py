from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route('/')
def home():
    return "Hello, this is the Flask backend for your SwiftUI app!"

@app.route('/data', methods=['GET'])
def get_data():
    # Here you can fetch and return data
    data = {"message": "This is some data from the Flask backend."}
    return jsonify(data)


# This route will receive a POST request with a JSON body of Geocoding data
# Algorithm will figure out the mid point of the number of users and return the location
@app.route('/post_location_finder', methods=['POST'])
def post_location_finder():
    data = request.json
    
    # Extracting the 'addresses' and 'preferences' from the JSON payload
    addresses = data.get('addresses', [])
    preferences = data.get('preferences', [])

    # Here you can add processing logic based on the received addresses and preferences
    # Calculate the mid point of the addresses and return the location
    
    
    # Example: just echoing back the received data
    response_data = {
        "message": "Data processed successfully",
        "received_addresses": addresses,
        "received_preferences": preferences
    }
    print(response_data)
    # Returning a JSON response
    return jsonify(response_data), 200

if __name__ == '__main__':
    app.run(debug=True)
