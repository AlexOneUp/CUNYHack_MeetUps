//
//  EventSuggestionsViewController.swift
//  HangNYC
//
//  Created by Johan Delao on 2/18/24.
//

import UIKit
import GoogleMaps

struct Business: Codable {
    let address: String
    let commuteTimes: [Int]
    let location: Location
    let name: String
    let priceLevel: PriceLevel
    let rating: Double

    enum CodingKeys: String, CodingKey {
        case address, commuteTimes, location, name, rating
        case priceLevel = "price_level"
    }
}

struct Location: Codable {
    var lat: Double
    var lng: Double
    
    init() {
            self.lat = 0.0
            self.lng = 0.0
    }
}

enum PriceLevel: Codable {
    case level(Int)
    case notAvailable

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let level = try? container.decode(Int.self) {
            self = .level(level)
            return
        }
        self = .notAvailable
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .level(let level):
            try container.encode(level)
        case .notAvailable:
            try container.encode("N/A")
        }
    }
}

struct BusinessInfo: Codable {
    let businesses: [Business]
    let midpoint: Location
}


class EventSuggestionsViewController: UIViewController {
    
    var midpoint = Location()
    var businessArray: [Business] = []
    
    let colors: [UIColor] = [.red, .green, .blue, .yellow, .orange]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        Below goes the JSON data
                let jsonString = """
        {
            "businesses": [
                {
                    "address": "201 E 45th St, New York",
                    "commuteTimes": [3103, 3034, 1921],
                    "location": {"lat": 40.7526741, "lng": -73.9726943},
                    "name": "NY Express Halal Food",
                    "price_level": "N/A",
                    "rating": 4.9
                },
                {
                    "address": "235 E 53rd St, Manhattan",
                    "commuteTimes": [3063, 2580, 2119],
                    "location": {"lat": 40.7573049, "lng": -73.9679238},
                    "name": "Café Luce Italian Restaurant",
                    "price_level": 2,
                    "rating": 4.7
                },
                {
                    "address": "89 E 42nd St Grand Central Station Lower Level Dining Concourse, New York",
                    "commuteTimes": [3217, 2547, 1621],
                    "location": {"lat": 40.7523458, "lng": -73.9773368},
                    "name": "Tartinery Café - Bar | Grand Central",
                    "price_level": 2,
                    "rating": 4.7
                },
                {
                    "address": "211 E 46th St, New York",
                    "commuteTimes": [3064, 2996, 1792],
                    "location": {"lat": 40.7532168, "lng": -73.9718218},
                    "name": "Barnea Bistro",
                    "price_level": "N/A",
                    "rating": 4.7
                },
                {
                    "address": "212 E 52nd St 2nd fl, New York",
                    "commuteTimes": [2929, 2602, 1947],
                    "location": {"lat": 40.7566056, "lng": -73.9693108},
                    "name": "Bar Orai",
                    "price_level": "N/A",
                    "rating": 4.6
                }
            ],
            "midpoint": {"lat": 40.75446268550891, "lng": -73.97245366411904}
        }
        """
        
        // Convert JSON string to data
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Failed to convert JSON string to data")
        }
        
        // Decode JSON data
        do {
            let businessInfo = try JSONDecoder().decode(BusinessInfo.self, from: jsonData)
//            put business in global variable
            for business in businessInfo.businesses {
                businessArray.append(business)
            }
//            put midpoint in global variable
            midpoint.lat = businessInfo.midpoint.lat
            midpoint.lng = businessInfo.midpoint.lng
            print(businessArray)
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
        GMSServices.provideAPIKey("AIzaSyD_b2UiBUVRLGzsguJv5V1FDs9PEjsCaO8")
        view.backgroundColor = .systemBackground
        
        let options = GMSMapViewOptions()
        options.camera = GMSCameraPosition.camera(withLatitude: midpoint.lat, longitude: midpoint.lng, zoom: 14.0)
        options.frame = view.bounds
        
        let mapView = GMSMapView(options: options)
        view.addSubview(mapView)
        setMapConstraints(mapView: mapView)
        
//        Create radius
        let circleCenter : CLLocationCoordinate2D  = CLLocationCoordinate2DMake(midpoint.lat, midpoint.lng);
        let circ = GMSCircle(position: circleCenter, radius: 0.56 * 1609.34)
        circ.fillColor = UIColor(red: 0.0, green: 0.7, blue: 0, alpha: 0.1)
        circ.strokeColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.5)
        circ.strokeWidth = 2.5;
        circ.map = mapView;
        
        var counter = 0
//        Go through all businesses and make a marker for each
        for business in businessArray {
            setUpMarker(title: business.name, address: business.address, lat: business.location.lat, lng: business.location.lng, rating: business.rating, map: mapView, colorIndex: counter)
            counter += 1
        }
    }
    
    func setUpMarker(title: String, address: String, lat: Double, lng: Double, rating: Double, map: GMSMapView, colorIndex: Int){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        marker.title = title
        marker.snippet = "Address: \(address)\nRating: \(rating)"
        marker.icon = GMSMarker.markerImage(with: colors[colorIndex])
        marker.map = map
    }
    
    func setMapConstraints(mapView: UIView) {
        mapView.translatesAutoresizingMaskIntoConstraints = false // must do this for every UI element
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        mapView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
