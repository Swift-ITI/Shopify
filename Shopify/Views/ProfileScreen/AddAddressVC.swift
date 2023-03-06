//
//  AddAddressVC.swift
//  Shopify
//
//  Created by Michael Hany on 25/02/2023.
//

import UIKit

class AddAddressVC: UIViewController
{
    
// MARK: - IBOutlets Part
    
    @IBOutlet var phoneTextField: UITextField! { didSet { renderTxtFields(txtField: phoneTextField) }}

    @IBOutlet var addressTextField: UITextField! { didSet { renderTxtFields(txtField: addressTextField) }}

    @IBOutlet var cityTextField: UITextField! { didSet { renderTxtFields(txtField: cityTextField) }}

    @IBOutlet var countryTextField: UITextField! { didSet { renderTxtFields(txtField: countryTextField) }}

    @IBOutlet var saveNewAddressButton: UIButton! {
        didSet {
            // saveNewAddressButton.layer.masksToBounds = true
            saveNewAddressButton.layer.cornerRadius = saveNewAddressButton.frame.width / 18
        }
    }

// MARK: - AddAddressVc Part
    
    var userID : Int?
    var addressesData : [String]?  // City - Country - Address - Phone
    var addVM : AddressesFunctions?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        if addressesData != nil
        {
            cityTextField.text = addressesData?[0] ?? ""
            countryTextField.text = addressesData?[1] ?? ""
            addressTextField.text = addressesData?[2] ?? ""
            phoneTextField.text = addressesData?[3] ?? ""
        }
        addVM = AddressesFunctions()
    }

// MARK: - IBAction Part
    
    @IBAction func saveNewAddressActionButton(_ sender: Any)
    {
        print("Address")
        if addressesData != nil
        {
            // should edit the data on the API
        }
        else if addressesData == nil && cityTextField.text == "" && countryTextField.text == "" && addressTextField.text == "" && phoneTextField.text == ""
        {
            print("cancel")
        }
        
        else if addressesData == nil
        {
            // should add the data to the API
            let alerts : UIAlertController = UIAlertController(title: "Add Address ?", message: "Are you sure that you want to add this address !", preferredStyle: .alert)
            alerts.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alerts.addAction(UIAlertAction(title: "Add", style: .default, handler: {action in
                self.addVM?.postCode(target: .addAddress(id: self.userID ?? 6810321223958), parameters:
                                        ["address" : [
                                            "city":"\(self.cityTextField.text ?? "No City")",
                                            "country":"\(self.countryTextField.text ?? "No Country")",
                                            "phone":self.phoneTextField.text ?? 0,
                                            "address1":"\(self.addressTextField.text ?? "No Address")",
                                            "default":false
                                        ]
                ])
                print("add address")
                let addressView = self.storyboard?.instantiateViewController(withIdentifier: "addressVC") as! AddressVC
                addressView.userID = self.userID ?? 6810321223958
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alerts, animated: true, completion: nil)
        }
        print("Address Saved or Edited or Cancel")
//        let addressView = storyboard?.instantiateViewController(withIdentifier: "addressVC") as! AddressVC
//        addressView.userID = userID ?? 6810321223958
//        dismiss(animated: true, completion: nil)
        //navigationController?.popViewController(animated: true)
    }
}

extension AddAddressVC
{
    func renderTxtFields(txtField: UITextField)
    {
        txtField.layer.borderWidth = 2
        txtField.layer.cornerRadius = 10
        txtField.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
    }
}
