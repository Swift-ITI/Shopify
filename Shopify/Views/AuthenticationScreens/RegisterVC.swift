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
    var userVM: UserViewModel?
    var postUserVM: PostUserViewModel?
    var users: [User]?
    var isFound: Bool!
    var nsDefault = UserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        renderTxtFields(txtFields: [firstNameTxtField, lastNameTxtField, emailTxtField, phoneTxtField, passwordTxtField])
        //passwordTxtField.passwordRules = UITextInputPasswordRules(descriptor: "required: upper; required: lower; required: digit; required: [-()/&*!@#$%] {>=1}; minlength: 8;")
        
        userVM = UserViewModel()
        postUserVM = PostUserViewModel()
        userVM?.fetchUsers(target: .allCustomers)
        userVM?.bindDataToVC = { () in
            DispatchQueue.main.async {
                self.users = self.userVM?.users?.customers
                // print(self.users?[0].email ?? "No")
            }
        }
    }

    @IBAction func registerBtn(_ sender: Any) {
        if emailTxtField.text != "" && firstNameTxtField.text != "" && lastNameTxtField.text != "" && phoneTxtField.text != "" && passwordTxtField.text != "" {
                print("Not found")
                let parameters: [String: Any] = [
                    "customer": [
                        "first_name": firstNameTxtField.text,
                        "last_name": lastNameTxtField.text,
                        "email": emailTxtField.text,
                        "phone": phoneTxtField.text,
                        "tags": passwordTxtField.text,
                    ],
                ]
                postUserVM?.postCustomer(target: .allCustomers, parameters: parameters)
                postUserVM?.bindErrorToVC = {
                    DispatchQueue.main.async {
                        switch self.postUserVM?.error?.keys.formatted() {
                            case "customer":
                                let customerDict = self.postUserVM?.error?["customer"] as? [String:Any]
                                self.showAlert(title: "Successful", msg: "Successfully Registered") { action in
                                    self.nsDefault.set(true, forKey: "isRegistered")
                                    self.nsDefault.set(true, forKey: "isLogged")
                                    self.nsDefault.set(customerDict?["id"] as? Int, forKey: "customerID")
                                    self.nsDefault.set(customerDict?["email"] as? String, forKey: "customerEmail")
                                    self.nsDefault.set("first", forKey: "note")
                                    print("id : \(customerDict?["id"] as? Int ?? 0)")
                                    print("email : \(customerDict?["email"] as? String ?? "")")
                                    self.performSegue(withIdentifier: "goToHome", sender: self)
                                }
                                
                            case "errors":
                                var errorMessages = ""

                                if let errors = self.postUserVM?.error?["errors"] as? [String: Any] {
                                    for (field, messages) in errors {
                                        errorMessages += "\(field.capitalized): "
                                        if let messages = messages as? [String] {
                                            for message in messages {
                                                errorMessages += " \(message)\n"
                                            }
                                        }
                                    }
                                }
                                self.showAlert(title: "Error", msg: errorMessages, handler: {_ in } )
                            default:
                                print("done")
                        }
                    }
                   
                }
                
                
                //performSegue(withIdentifier: "goToHome", sender: self)
        } else {
            showAlert(title: "Missing Data", msg: "Fill all the fields", handler: {_ in })
        }
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

    func showAlert(title: String, msg: String,handler:@escaping (UIAlertAction?)->Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            handler(action)
        }))

        present(alert, animated: true, completion: nil)
    }
}
