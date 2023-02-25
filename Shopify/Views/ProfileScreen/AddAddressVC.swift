//
//  AddAddressVC.swift
//  Shopify
//
//  Created by Michael Hany on 25/02/2023.
//

import UIKit

class AddAddressVC: UIViewController
{

    @IBOutlet var phoneTextField: UITextField!
    {
        didSet
        {
            phoneTextField.layer.borderWidth = 2
            phoneTextField.layer.cornerRadius = 20
            //phoneTextField.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
        }
    }
    @IBOutlet var addressTextField: UITextField!
    {
        didSet
        {
            addressTextField.layer.borderWidth = 2
            addressTextField.layer.cornerRadius = 20
            //addressTextField.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
        }
    }
    @IBOutlet var cityTextField: UITextField!
    {
        didSet
        {
            cityTextField.layer.borderWidth = 2
            cityTextField.layer.cornerRadius = 20
            //cityTextField.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
        }
    }
    @IBOutlet var countryTextField: UITextField!
    {
        didSet
        {
            countryTextField.layer.borderWidth = 2
            countryTextField.layer.cornerRadius = 20
            //countryTextField.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
        }
    }
    @IBOutlet var saveNewAddressButton: UIButton!
    {
        didSet
        {
            //saveNewAddressButton.layer.masksToBounds = true
            saveNewAddressButton.layer.cornerRadius = saveNewAddressButton.frame.width/18
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    
    @IBAction func saveNewAddressActionButton(_ sender: Any)
    {
        print("Address Saved")
    }
}
