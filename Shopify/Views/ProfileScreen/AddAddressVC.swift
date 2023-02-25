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
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var countryTextField: UITextField!
    @IBOutlet var saveNewAddressButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        saveNewAddressButton.layer.masksToBounds = true
        saveNewAddressButton.layer.cornerRadius = saveNewAddressButton.frame.width/18
    }

    
    @IBAction func saveNewAddressActionButton(_ sender: Any)
    {
        print("Address Saved")
    }
}
