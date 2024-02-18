//
//  EventSetupViewController.swift
//  HangNYC
//
//  Created by Abdul Andha on 2/16/24.
//

import UIKit

class EventSetupViewController: UIViewController {
    
//    @IBOutlet weak var getBestLocationBtn: UIButton!
    let testButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        testTapped()
        view.backgroundColor = .systemBackground
    }
    
    func testTapped(){
        view.addSubview(testButton)
        testButton.configuration = .filled()
        testButton.configuration?.baseBackgroundColor = .systemGreen
        testButton.configuration?.title = "Test Button"
        
        testButton.translatesAutoresizingMaskIntoConstraints = false // must do this for every UI element
        
        testButton.addTarget(self, action: #selector(getBestLocationTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testButton.widthAnchor.constraint(equalToConstant: 200),
            testButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @IBAction func getBestLocationTapped() {
        let addresses = ["address1", "address2", "address3"]
        let preferences = [String]()

        makePostRequest(addresses: addresses, preferences: preferences)
    }
    
    func makePostRequest(addresses: [String], preferences: [String]) {
        guard let url = URL(string: "http://127.0.0.1:5000/get_best_location") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let postData: [String: Any] = [
            "addresses": addresses,
            "preferences": preferences
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options: [])
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            print("Error encoding JSON: \(error.localizedDescription)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }

            if httpResponse.statusCode == 200 {
                if let data = data {
                    // Handle the response data
                    print("Response: \(String(data: data, encoding: .utf8) ?? "")")
                }
            } else {
                print("HTTP Response Code: \(httpResponse.statusCode)")
            }
        }

        task.resume()
    }
    
}

