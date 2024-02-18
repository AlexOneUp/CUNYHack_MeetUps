//
//  WelcomeViewController.swift
//  HangNYC
//
//  Created by Abdul Andha on 2/16/24.
//

import UIKit

class WelcomeViewController: UIViewController {

//    @IBOutlet weak var test: UILabel!
    let testButton = UIButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        // Background Image + Padding to it
        let padding: CGFloat = 20
        let backgroundImage = UIImageView(
            frame:
                CGRect(
                    x: padding,
                    y: 250,
                    width: UIScreen.main.bounds.width - 2 * padding,
                    height: UIScreen.main.bounds.height * 0.25
                )
        )
                backgroundImage.image = UIImage(named: "welcome_bg_img")
                backgroundImage.contentMode = .scaleAspectFill
                
                // Add the image view to the view hierarchy
                view.addSubview(backgroundImage)
        // Makes edges rounder
        backgroundImage.layer.cornerRadius = 20
        backgroundImage.clipsToBounds = true
        
        testTapped()
        view.backgroundColor = .systemBackground
        title = "Welcome"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
//    func buttonBackground() {
//        testTapped()
//        
//        
//    }
//    
    func testTapped() {
        view.addSubview(testButton)
        testButton.configuration = .filled()
        testButton.configuration?.baseBackgroundColor = .systemGreen
        testButton.configuration?.title = "Create Event"
        
        testButton.translatesAutoresizingMaskIntoConstraints = false // must do this for every UI element
        
        testButton.addTarget(self, action: #selector(goToNextScreen), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            testButton.widthAnchor.constraint(equalToConstant: 200),
            testButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let eventSetup = storyBoard.instantiateViewController(withIdentifier: "eventSetup") as! EventSetupViewController
        
//        let navigationController = UINavigationController(rootViewController: eventSetup)
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func goToNextScreen(){
        let nextScreen = EventSetupViewController()
        nextScreen.title = "Event Setup"
        navigationController?.pushViewController(nextScreen, animated: true)
    }
    
}

