//
//  AddAddressVC.swift
//  Shopify
//
//  Created by Michael Hany on 25/02/2023.
//

import UIKit

class AddAddressVC: UIViewController
{
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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveNewAddressActionButton(_ sender: Any) {
        print("Address Saved")
    }
}

extension AddAddressVC
{
    func renderTxtFields(txtField: UITextField) {
        txtField.layer.borderWidth = 2
        txtField.layer.cornerRadius = 20
        txtField.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
    }
}
