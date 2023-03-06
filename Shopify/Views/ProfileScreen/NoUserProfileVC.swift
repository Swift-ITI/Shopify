//
//  NoUserProfileVC.swift
//  Shopify
//
//  Created by Michael Hany on 06/03/2023.
//

import UIKit

class NoUserProfileVC: UIViewController
{

// MARK: - IBOutlets Part
    
    @IBOutlet var signupButton: UIButton!
    {
        didSet
        {
            signupButton.layer.masksToBounds = true
            signupButton.layer.cornerRadius = signupButton.frame.width/18
        }
    }
    
    @IBOutlet var loginButton: UIButton!
    {
        didSet
        {
            loginButton.layer.masksToBounds = true
            loginButton.layer.cornerRadius = loginButton.frame.width/18
        }
    }
    
// MARK: - NoUserProfileVC Part
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
// MARK: - IBActions Part

    @IBAction func loginActionButton(_ sender: Any)
    {
        performSegue(withIdentifier: "login", sender: self)
    }
    
    @IBAction func signupActionButton(_ sender: Any)
    {
        performSegue(withIdentifier: "signup", sender: self)
    }
}
