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
    
    let stackView = UIStackView()
    
    var jsonString: String = ""
    
    let colors: [UIColor] = [.red, .green, .blue, .yellow, .orange]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
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
        
//        let business1 = UILabel()
        
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
        
        configureStackView(map: mapView)
    }
    
    func configureStackView(map: UIView){
        view.addSubview(stackView)
        setStackViewConstraintsTwo(map: map)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.backgroundColor = .white
        stackView.layoutMargins = .init(top: 8, left: 8, bottom: 4, right: 8)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        for business in businessArray {
            makeBusinessRowSubView(title: business.name, address: business.address, rating: business.rating)
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
    
    func makeBusinessRowSubView(title: String, address: String, rating: Double){
        let businessStackView = UIStackView()
        businessStackView.axis = .horizontal
        businessStackView.spacing = 10
        businessStackView.distribution = .fillProportionally
        businessStackView.layoutMargins = .init(top: 10, left: 16, bottom: 10, right: 16)
        businessStackView.isLayoutMarginsRelativeArrangement = true
        businessStackView.backgroundColor = .systemGray4
        businessStackView.cornerRadius = 10
        
        let iconStackView = UIStackView()
        iconStackView.axis = .horizontal
        iconStackView.spacing = 2
//        let markerIcon = UIImage(systemName: "mappin.circle.fill")
////        markerIcon. = .init(width: 10, height: 10)
//        let markerImageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 10, height: 10)))
//        markerImageView.image = markerIcon
        let markerText = UILabel()
        markerText.text = title
        markerText.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        markerText.textColor = .black
//        iconStackView.addArrangedSubview(markerImageView)
        iconStackView.addArrangedSubview(markerText)
        
        businessStackView.addArrangedSubview(iconStackView)
        
        let addressUIView = UILabel()
        addressUIView.text = address
        addressUIView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        addressUIView.textColor = .systemGray
        
        businessStackView.addArrangedSubview(addressUIView)
        
        stackView.addArrangedSubview(businessStackView)
        setBusinessRowConstraints(view: businessStackView)
    }
    
    func setBusinessRowConstraints(view: UIView){
        view.translatesAutoresizingMaskIntoConstraints = false // must do this for every UI element

        view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 10).isActive = true
        view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -10).isActive = true
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setStackViewConstraintsTwo(map: UIView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false // must do this for every UI element
        stackView.topAnchor.constraint(equalTo: map.bottomAnchor, constant: 0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
//        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    func setMapConstraints(mapView: UIView) {
        mapView.translatesAutoresizingMaskIntoConstraints = false // must do this for every UI element
//        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        mapView.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
