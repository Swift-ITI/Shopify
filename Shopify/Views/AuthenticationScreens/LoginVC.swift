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
    var userVM: UserViewModel?
    var nsDefault = UserDefaults()
    
    var draftOrders: [DraftOrder] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        userVM = UserViewModel()
        // Do any additional setup after loading the view.
    }

    @IBAction func forgotPWBtn(_ sender: Any) {
    }
    @IBAction func registerBtn(_ sender: Any) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    @IBAction func loginBtn(_ sender: Any) {
        if emailTxtField.text != "" && passwordTxtField.text != ""{
            userVM?.fetchUsers(target: .checkUser(email: emailTxtField.text ?? "", pw: passwordTxtField.text ?? ""))
            userVM?.bindDataToVC = {
                DispatchQueue.main.async {
                    if self.userVM?.users?.customers.first?.email == self.emailTxtField.text && self.userVM?.users?.customers.first?.tags == self.passwordTxtField.text {
                        self.showAlert(title: "Done", msg: "Successfully Logged") { action in
                            
                            self.nsDefault.set(true, forKey: "isLogged")
                            self.nsDefault.set(self.userVM?.users?.customers.first?.id, forKey: "customerID")
                            let search : Int = self.searchForDraftOrder(emaill: self.userVM?.users?.customers.first?.email ?? "")
                            if(search) != 0 {
                                self.nsDefault.set(search, forKey: "draftOrderID")
                                self.nsDefault.set("created", forKey: "note")
                            } else {
                                self.nsDefault.set("first", forKey: "note")
                            }
                            self.performSegue(withIdentifier: "goToHome", sender: self)
                        }
                    }else{
                        self.showAlert(title: "Wrong Credentials", msg: "Check ur data", handler: {_ in })
                    }
                }
            }
        }else{
            showAlert(title: "Missing Data", msg: "Fill missing data", handler: {_ in })
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

extension LoginVC {
    func searchForDraftOrder (emaill : String) -> Int {
        var id : Int = 0
        userVM?.fetchAllDraftOrders(target: .alldraftOrders)
        userVM?.bindDraftOrderToVC = { () in
            DispatchQueue.main.async {
                self.draftOrders = self.userVM?.draftOrder?.draft_orders ?? []
                
                for draft in self.draftOrders{
                    if draft.email == emaill{
                        id = draft.id ?? 0
                    }
                }
            }
        }
        return id
    }
}
