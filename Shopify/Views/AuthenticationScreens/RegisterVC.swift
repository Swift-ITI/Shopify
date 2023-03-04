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

    @IBOutlet var firstNameTxtField: UITextField!
    @IBOutlet var lastNameTxtField: UITextField!
    @IBOutlet var emailTxtField: UITextField!
    @IBOutlet var phoneTxtField: UITextField!
    @IBOutlet var passwordTxtField: UITextField!
    var userVM : UserViewModel?
    var users:[User]?
    var isFound:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        renderTxtFields(txtFields: [firstNameTxtField, lastNameTxtField, emailTxtField, phoneTxtField, passwordTxtField])
        
        userVM = UserViewModel()
        userVM?.fetchUsers(target: .allCustomers)
        userVM?.bindDataToVC = {() in
            DispatchQueue.main.async {
                self.users = self.userVM?.users?.customers
               // print(self.users?[0].email ?? "No")
            }
        }
    }

    @IBAction func registerBtn(_ sender: Any) {
 
        isFound = searchForUser(email: emailTxtField.text ?? "")
        if  isFound {
            print ("found")
            showAlert()
        } else {
            print ("Not found")
            performSegue(withIdentifier: "goToHome", sender: self)
        }
        
}
    func searchForUser(email : String) -> Bool {
        var flag = false
        
        for user in users! {
            if user.email == email {
                flag = true
            }
        }
        return flag
    }

    @IBAction func loginBtn(_ sender: Any) {

    }
  
}

// MARK: Rendering
extension RegisterVC {
    func renderTxtFields(txtFields: [UITextField]) {
        for txtField in txtFields {
            txtField.layer.cornerRadius = 10
            txtField.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
            txtField.layer.borderWidth = 2
        }
    }

    func showAlert() {
        let alert = UIAlertController(title: "Missing Data!", message: "Please, Check ur data", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}

