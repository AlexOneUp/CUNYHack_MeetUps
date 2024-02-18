//
//  LoginViewController.swift
//  HangNYC
//
//  Created by Abdul Andha on 2/17/24.
//


import UIKit

class LoginViewController: UIViewController {

//    @IBOutlet weak var test: UILabel!
    
    let loginTitle = UILabel()
    let usernameField = UITextField()
    let passwordField = UITextField()
    let loginButton = UIButton()
    let forgotPass = UILabel()
    let signUpText = UILabel()
    let signUpButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        testTapped()
        view.backgroundColor = .systemBackground
        placeElements()
    }
    
    func placeElements() {
        // Login Title
        view.addSubview(loginTitle)
        loginTitle.translatesAutoresizingMaskIntoConstraints = false
        loginTitle.text = "Login"
        loginTitle.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        NSLayoutConstraint.activate([
            loginTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 300)
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
            usernameField.topAnchor.constraint(equalTo: loginTitle.bottomAnchor, constant: 20),
            usernameField.widthAnchor.constraint(equalToConstant: 340),
            usernameField.heightAnchor.constraint(equalToConstant: 35),
            
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10),
            passwordField.widthAnchor.constraint(equalToConstant: 340),
            passwordField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        
        // Login button
        view.addSubview(loginButton)
        loginButton.configuration = .filled()
        loginButton.configuration?.baseBackgroundColor = .systemGreen
        loginButton.configuration?.title = "Login"
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false // must do this for every UI element
        
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 340),
            loginButton.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        
        // Forgot pass
        view.addSubview(forgotPass)
        forgotPass.translatesAutoresizingMaskIntoConstraints = false
        forgotPass.text = "Forgot Password?"
        forgotPass.textColor = .systemBlue
        
        NSLayoutConstraint.activate([
            forgotPass.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forgotPass.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5),
        ])
        
        
        // Signup text and button
        view.addSubview(signUpText)
        signUpText.translatesAutoresizingMaskIntoConstraints = false
        signUpText.text = "New to HangNYC?"
        signUpText.textColor = .gray
        
        view.addSubview(signUpButton)
        signUpButton.configuration = .plain()
        signUpButton.configuration?.title = "Signup"
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        // StackView
        let stackView = UIStackView(arrangedSubviews: [signUpText, signUpButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
        ])

    }

    func testTapped() {
        
    }
    
    @objc func loginTapped(){
        guard let username = usernameField.text, !username.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            // Handle empty fields or other validation as needed
            return
        }
        
        let loginURL = URL(string: "http://127.0.0.1:5000/login")!
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(username, password)
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
                if let responseDict = json as? [String: Any], let message = responseDict["message"] as? String, message == "User authenticated" {
                    DispatchQueue.main.async {
                        let nextScreen = WelcomeViewController()
                        nextScreen.title = "Welcome"
                        self.navigationItem.hidesBackButton = true
                        self.navigationItem.backBarButtonItem = nil
                        self.navigationItem.leftBarButtonItems = []
                        self.navigationController?.pushViewController(nextScreen, animated: true)
                    }
                } else {
                    self.showAlert(message: "Login failed. Please check your username and password.")
                }
            } catch {
                print("Error parsing server response: \(error)")
            }
        }.resume()
        
    }
    
    @objc func signUpTapped(){
        let nextScreen = SignUpViewController()
        nextScreen.title = "Signup"
        navigationController?.pushViewController(nextScreen, animated: true)
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


