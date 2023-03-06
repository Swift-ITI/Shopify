//
//  AddAddressVC.swift
//  Shopify
//
//  Created by Michael Hany on 25/02/2023.
//

import UIKit

class AddAddressVC: UIViewController {
    // MARK: - IBOutlets Part

    @IBOutlet var phoneTextField: UITextField!

    @IBOutlet var addressTextField: UITextField!

    @IBOutlet var cityTextField: UITextField!

    @IBOutlet var countryTextField: UITextField!

    @IBOutlet var saveNewAddressButton: UIButton! {
        didSet {
            // saveNewAddressButton.layer.masksToBounds = true
            saveNewAddressButton.layer.cornerRadius = saveNewAddressButton.frame.width / 18
        }
    }

    // MARK: - AddAddressVc Part

    var userID: Int?
    var addressID: Int?
    var address: Address?
    var addressesData: [String]? // City - Country - Address - Phone
    var postAddressVM: PostAddressViewModel?
    var flag: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        renderTxtFields(txtFields: [cityTextField, countryTextField, addressTextField, phoneTextField])
        postAddressVM = PostAddressViewModel()
        cityTextField.text = address?.city
        countryTextField.text = address?.country
        addressTextField.text = address?.address1
        phoneTextField.text = address?.phone
//        }
    }

    // MARK: - IBAction Part
    @IBAction func saveNewAddressActionButton(_ sender: Any) {
        if cityTextField.text != "" && countryTextField.text != "" && addressTextField.text != "" && phoneTextField.text != ""{
            switch flag {
            // From New
            case 1:
                let alerts: UIAlertController = UIAlertController(title: "Add Address?", message: "Are you sure that you want to add this address!", preferredStyle: .alert)
                alerts.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alerts.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
                    self.postAddressVM?.postAddress(target: .addAddress(id: self.userID ?? 6810321223958), parameters:
                        ["address": [
                            "city": "\(self.cityTextField.text ?? "No City")",
                            "country": "\(self.countryTextField.text ?? "No Country")",
                            "phone": self.phoneTextField.text ?? 0,
                            "address1": "\(self.addressTextField.text ?? "No Address")",
                            "default": false,
                        ],
                        ])
                    self.postAddressVM?.bindErrorsToVC = {
                        DispatchQueue.main.async {
                            switch self.postAddressVM?.errors?.keys.formatted() {
                                case "customer_address":
                                    self.showAlert(title: "Successful", msg: "Successfully") { action in
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    
                                case "errors":
                                    var errorMessages = ""

                                    if let errors = self.postAddressVM?.errors?["errors"] as? [String: Any] {
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
                    print("add address")
                   
                }))
                present(alerts, animated: true, completion: nil)
                    
            // From Edit
            case 2:
                let alerts: UIAlertController = UIAlertController(title: "Edit Address?", message: "Are you sure that you want to Edit this address!", preferredStyle: .alert)
                alerts.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alerts.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
                    self.postAddressVM?.editAddress(target: .editAddress(customerID: self.userID ?? 6810321223958, addressID: self.address?.id ?? 0), parameters:
                        ["address": [
                            "city": "\(self.cityTextField.text ?? "No City")",
                            "country": "\(self.countryTextField.text ?? "No Country")",
                            "phone": self.phoneTextField.text ?? 0,
                            "address1": "\(self.addressTextField.text ?? "No Address")",
                        ],
                        ])
                    self.postAddressVM?.bindErrorsToVC = {
                        DispatchQueue.main.async {
                            switch self.postAddressVM?.errors?.keys.formatted() {
                                case "customer_address":
                                    self.showAlert(title: "Successful", msg: "Successfully") { action in
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    
                                case "errors":
                                    var errorMessages = ""

                                    if let errors = self.postAddressVM?.errors?["errors"] as? [String: Any] {
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
                    print("edit address")
                }))
                present(alerts, animated: true, completion: nil)
            default:
                print("None")
            }
        }else{
            showAlert(title: "Error", msg: "Fill missing data", handler: {_ in })
        }
        
    }
}

extension AddAddressVC {
    func renderTxtFields(txtFields: [UITextField]) {
        for txtField in txtFields {
            txtField.layer.borderWidth = 2
            txtField.layer.cornerRadius = 10
            txtField.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
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
