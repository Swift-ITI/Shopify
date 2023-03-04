//
//  LoginVC.swift
//  Shopify
//
//  Created by Adham Samer on 22/02/2023.
//

import UIKit
class LoginVC: UIViewController {

    @IBOutlet weak var passwordTxtField: UITextField!{
        didSet{
            passwordTxtField.layer.cornerRadius = 10
            passwordTxtField.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
            passwordTxtField.layer.borderWidth = 2
        }
    }
    @IBOutlet weak var emailTxtField: UITextField!{
        didSet{
            emailTxtField.layer.cornerRadius = 10
            emailTxtField.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
            emailTxtField.layer.borderWidth = 2
        }
    }
    @IBOutlet weak var loginImage: UIImageView!{
        didSet{
            loginImage.layer.cornerRadius = 10
            loginImage.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
            loginImage.layer.borderWidth = 2
            loginImage.image = UIImage(named: "Login 1")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func forgotPWBtn(_ sender: Any) {
    }
    @IBAction func registerBtn(_ sender: Any) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    @IBAction func loginBtn(_ sender: Any) {
        performSegue(withIdentifier: "goToHome", sender: self)
    }
}
