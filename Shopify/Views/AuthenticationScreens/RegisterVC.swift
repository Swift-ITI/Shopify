//
//  RegisterVC.swift
//  Shopify
//
//  Created by Adham Samer on 22/02/2023.
//

import UIKit

class RegisterVC: UIViewController {
    @IBOutlet var registerImage: UIImageView! {
        didSet {
            registerImage.layer.cornerRadius = 10
            registerImage.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
            registerImage.layer.borderWidth = 2
            registerImage.image = UIImage(named: "Login 1")
        }
    }

    @IBOutlet var firstNameTxtField: UITextField! { didSet { renderTxtFields(txtField: firstNameTxtField) }}
    @IBOutlet var lastNameTxtField: UITextField! { didSet { renderTxtFields(txtField: lastNameTxtField) }}
    @IBOutlet var emailTxtField: UITextField! { didSet { renderTxtFields(txtField: emailTxtField) }}
    @IBOutlet var phoneTxtField: UITextField! { didSet { renderTxtFields(txtField: phoneTxtField) }}
    @IBOutlet var passwordTxtField: UITextField! { didSet { renderTxtFields(txtField: passwordTxtField) }}

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
     }
     */

    @IBAction func registerBtn(_ sender: Any) {
        performSegue(withIdentifier: "goToHome", sender: self)
    }
    @IBAction func loginBtn(_ sender: Any) {
        performSegue(withIdentifier: "goToLogIn", sender: self)
    }
    
}
// MARK: Rendering
extension RegisterVC {
    func renderTxtFields(txtField: UITextField) {
        txtField.layer.cornerRadius = 10
        txtField.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
        txtField.layer.borderWidth = 2
    }
}
