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
    }

// MARK: - IBAction Part
    
    @IBAction func saveNewAddressActionButton(_ sender: Any)
    {
        print("Address Saved or Edited")
        if addressesData != nil
        {
            // should edit the data on the API
        }
        else if addressesData == nil
        {
            // should add the data to the API
        }
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
