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

@app.route('/submit', methods=['POST'])
def submit_data():
    # Here you can handle data sent from your SwiftUI app
    received_data = request.json
    # Process the received_data as needed
    return jsonify({"message": "Data received successfully.", "received": received_data})

if __name__ == '__main__':
    app.run(debug=True)
