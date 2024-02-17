//
//  WelcomeViewController.swift
//  HangNYC
//
//  Created by Abdul Andha on 2/16/24.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var test: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        test.text = "hello world"
    }

    @IBAction func testTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let eventSetup = storyBoard.instantiateViewController(withIdentifier: "eventSetup") as! EventSetupViewController
        
        let navigationController = UINavigationController(rootViewController: eventSetup)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
}

