//
//  SignUpViewController.swift
//  HangNYC
//
//  Created by Abdul Andha on 2/17/24.
//


import UIKit

class SignUpViewController: UIViewController {

//    @IBOutlet weak var test: UILabel!
    
    let signUpTitle = UILabel()
    let usernameField = UITextField()
    let passwordField = UITextField()
    let signUpButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        placeElements()
    }
    
    func placeElements() {
        // signUpTitle Title
        view.addSubview(signUpTitle)
        signUpTitle.translatesAutoresizingMaskIntoConstraints = false
        signUpTitle.text = "Sign Up"
        signUpTitle.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        NSLayoutConstraint.activate([
            signUpTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 300)
        ])
        
        // Input fields
        view.addSubview(usernameField)
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        usernameField.placeholder = "Username"
        usernameField.font = UIFont.systemFont(ofSize: 16, weight: .light)
        usernameField.backgroundColor = UIColor(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)
        usernameField.layer.borderWidth = 1.0
        usernameField.layer.borderColor = UIColor.black.cgColor
        usernameField.setLeftPaddingPoints(10)
        usernameField.autocapitalizationType = .none
        
        
        view.addSubview(passwordField)
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.placeholder = "Password"
        passwordField.font = UIFont.systemFont(ofSize: 16, weight: .light)
        passwordField.backgroundColor = UIColor(red: 236/255.0, green: 236/255.0, blue: 236/255.0, alpha: 1.0)
        passwordField.layer.borderWidth = 1.0
        passwordField.layer.borderColor = UIColor.black.cgColor
        passwordField.setLeftPaddingPoints(10)
        passwordField.autocapitalizationType = .none
        passwordField.isSecureTextEntry = true
        
        
        NSLayoutConstraint.activate([
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.topAnchor.constraint(equalTo: signUpTitle.bottomAnchor, constant: 20),
            usernameField.widthAnchor.constraint(equalToConstant: 340),
            usernameField.heightAnchor.constraint(equalToConstant: 35),
            
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10),
            passwordField.widthAnchor.constraint(equalToConstant: 340),
            passwordField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        
        // signUp button
        view.addSubview(signUpButton)
        signUpButton.configuration = .filled()
        signUpButton.configuration?.baseBackgroundColor = .systemGreen
        signUpButton.configuration?.title = "Sign Up"
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false // must do this for every UI element
        
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            signUpButton.widthAnchor.constraint(equalToConstant: 340),
            signUpButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        

    }
    
    @objc func signUpTapped() {
        guard let username = usernameField.text, !username.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            return
        }

        let signUpURL = URL(string: "http://127.0.0.1:5000/signup")!
        var request = URLRequest(url: signUpURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = ["username": username, "password": password]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error creating request body: \(error)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let responseDict = json as? [String: Any], let message = responseDict["message"] as? String, message == "User created successfully" {
                    DispatchQueue.main.async {
                        let nextScreen = WelcomeViewController()
                        nextScreen.title = "Welcome"
                        self.navigationItem.hidesBackButton = true
                        self.navigationItem.backBarButtonItem = nil
                        self.navigationItem.leftBarButtonItems = []
                        self.navigationController?.pushViewController(nextScreen, animated: true)
                    }
                } else {
                    self.showAlert(message: "Signup failed. Please try again.")
                }
            } catch {
                print("Error parsing server response: \(error)")
            }
        }.resume()
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    
}



