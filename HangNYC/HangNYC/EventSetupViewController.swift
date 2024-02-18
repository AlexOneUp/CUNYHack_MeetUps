//
//  EventSetupViewController.swift
//  HangNYC
//
//  Created by Abdul Andha on 2/16/24.
//

import UIKit

class EventSetupViewController: UIViewController {
//    @IBOutlet weak var getBestLocationBtn: UIButton!
    let testButton = UIButton();
    let stackView = UIStackView();
    let submitButton = UIButton()
    
    let inputName = UITextField()
    let inputLocation = UITextField()
    let inputTransport = UITextField()
    
    let memberNameStackView = UIStackView()
    let memberLocationStackView = UIStackView()
    let memberTransportStackView = UIStackView()
    
    class Member {
        let name: String
        let location: String
        let transport: String

        init(name: String, location: String, transport: String) {
            self.name = name
            self.location = location
            self.transport = transport
        }
    }
    
    var members: [Member] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        testTapped()
        configureStackView()
        configureSubmitButton()
        view.backgroundColor = .systemBackground
    }
    
    func configureSubmitButton(){
        view.addSubview(submitButton)
        submitButton.configuration = .filled()
        submitButton.configuration?.title = "Add Member +"
        submitButton.configuration?.baseBackgroundColor = .systemGreen
        setSubmitButtonConstraints();
        submitButton.addTarget(self, action: #selector(submitButtonClicked), for: .touchUpInside)
    }
    
    @objc func submitButtonClicked(){
        guard let name = inputName.text, !name.isEmpty,
              let location = inputLocation.text, !location.isEmpty, let transport = inputTransport.text, !transport.isEmpty else {
                   return
               }
        let member = Member(name: name, location: location, transport: transport)
        members.append(member)
        depopulateMemberViews()
        populateMemberViews()
        emptyInputs()
        if(members.count >= 4) {
            submitButton.removeFromSuperview()
        }
    }
    
    func emptyInputs(){
        inputName.text = "";
        inputLocation.text = "";
        inputTransport.text = "";
    }
    
    func printMembers(){
        for person in members {
            print("Name: \(person.name), Location: \(person.location), Transport: \(person.transport)")
        }
    }
    
    func setSubmitButtonConstraints(){
        submitButton.translatesAutoresizingMaskIntoConstraints = false // must do this for every UI element
        submitButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 175).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        submitButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func configureStackView(){
        view.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .top
        stackView.spacing = 20
        
        setStackViewConstraints()
        getMembers()
    }
    
    func getMembers(){
        memberNameStackView.alignment = .top
        memberLocationStackView.alignment = .top
        memberTransportStackView.alignment = .top
        
        memberNameStackView.translatesAutoresizingMaskIntoConstraints = false // must do this for every UI element
        memberLocationStackView.translatesAutoresizingMaskIntoConstraints = false // must do this for every UI element
        memberTransportStackView.translatesAutoresizingMaskIntoConstraints = false
        
        populateMemberViews()
    }
    
    func depopulateMemberViews(){
        stackView.removeFullyAllArrangedSubviews()
        memberNameStackView.removeFullyAllArrangedSubviews()
        memberLocationStackView.removeFullyAllArrangedSubviews()
        memberTransportStackView.removeFullyAllArrangedSubviews()
    }
    
    func populateMemberViews(){
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        memberNameStackView.axis = .vertical
        memberNameStackView.distribution = .fillEqually
        memberNameStackView.spacing = 5
        memberNameStackView.addArrangedSubview(nameLabel)
        
        let locationLabel = UILabel()
        locationLabel.text = "Address"
        locationLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        memberLocationStackView.axis = .vertical
        memberLocationStackView.distribution = .fillEqually
        memberLocationStackView.spacing = 5
        memberLocationStackView.addArrangedSubview(locationLabel)
        
        let transportLabel = UILabel()
        transportLabel.text = "Transport Mode"
        transportLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        memberTransportStackView.axis = .vertical
        memberTransportStackView.distribution = .fillEqually
        memberTransportStackView.spacing = 5
        memberTransportStackView.addArrangedSubview(transportLabel)
        
        for person in members {
            let tempNameLabel = UILabel()
            tempNameLabel.text = person.name
            memberNameStackView.addArrangedSubview(tempNameLabel)
            
            let tempLocationLabel = UILabel()
            tempLocationLabel.text = person.location
            memberLocationStackView.addArrangedSubview(tempLocationLabel)
            
            let tempTransportLabel = UILabel()
            tempTransportLabel.text = person.transport
            memberTransportStackView.addArrangedSubview(tempTransportLabel)
        }
        
        if(members.count < 4){
            printMembers()
            
            inputName.placeholder = "Name"
            inputName.layer.borderWidth = 1.0
            inputName.layer.borderColor = UIColor.gray.cgColor
            inputName.setLeftPaddingPoints(10)
            setInputsContraints(input: inputName)
            
            memberNameStackView.addArrangedSubview(inputName)
            
            inputLocation.placeholder = "Address"
            inputLocation.layer.borderWidth = 1.0
            inputLocation.layer.borderColor = UIColor.gray.cgColor
            inputLocation.setLeftPaddingPoints(10)
            memberLocationStackView.addArrangedSubview(inputLocation)
            setInputsContraints(input: inputLocation)
            
            inputTransport.layer.borderWidth = 1.0
            inputTransport.layer.borderColor = UIColor.gray.cgColor
            inputTransport.placeholder = "Transport Mode"
            inputTransport.setLeftPaddingPoints(10)
            memberTransportStackView.addArrangedSubview(inputTransport)
            setInputsContraints(input: inputTransport)
        }
        
        stackView.addArrangedSubview(memberNameStackView)
        stackView.addArrangedSubview(memberLocationStackView)
        stackView.addArrangedSubview(memberTransportStackView)
    }
    
    func setInputsContraints(input: UITextField){
        input.translatesAutoresizingMaskIntoConstraints = false
        input.widthAnchor.constraint(equalToConstant: 100).isActive = true
        input.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setStackViewConstraints(){
        stackView.translatesAutoresizingMaskIntoConstraints = false // must do this for every UI element
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func testTapped(){
        view.addSubview(testButton)
        testButton.configuration = .filled()
        testButton.configuration?.baseBackgroundColor = .systemGreen
        testButton.configuration?.title = "Calculate Best Location"
        testButton.translatesAutoresizingMaskIntoConstraints = false // must do this for every UI element
        
        testButton.addTarget(self, action: #selector(getBestLocationTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            testButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
//            testButton.widthAnchor.constraint(equalToConstant: 200),
            testButton.heightAnchor.constraint(equalToConstant: 50),
//            testButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20)
        ])
    }
    
    @objc func goToNextScreen(data: String){
        DispatchQueue.main.async {
            let nextScreen = EventSuggestionsViewController()
            nextScreen.title = "Event Suggestions"
            nextScreen.jsonString = data
            self.navigationController?.pushViewController(nextScreen, animated: true)
        }
    }
    
    @IBAction func getBestLocationTapped() {
        if members.count < 3 {
            return
        }
        
        var addresses: [String] = []
        var transportation_modes: [String] = []
        
        for person in members {
            addresses.append(person.location)
            transportation_modes.append(person.transport)
        }

        makePostRequest(addresses: addresses, modes: transportation_modes)
    }
    
    func makePostRequest(addresses: [String], modes: [String]) {
        guard let url = URL(string: "http://127.0.0.1:5000/get_best_location") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let postData: [String: Any] = [
            "addresses": addresses,
            "modes": modes
        ]
        
        print(postData)

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
                    self.goToNextScreen(data: String(data: data, encoding: .utf8) ?? "")
                }
            } else {
                print("HTTP Response Code: \(httpResponse.statusCode)")
            }
        }
        
        
        task.resume()
    }
    
}

