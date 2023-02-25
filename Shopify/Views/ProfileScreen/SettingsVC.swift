//
//  SettingsVC.swift
//  Shopify
//
//  Created by Michael Hany on 25/02/2023.
//

import UIKit

class SettingsVC: UIViewController
{

    @IBOutlet var aboutUsButton: UIButton!
    @IBOutlet var contactUsButton: UIButton!
    @IBOutlet var addressButton: UIButton!
    @IBOutlet var currencyButton: UIButton!
    @IBOutlet var currencySegment: UISegmentedControl!
    @IBOutlet var logOutButton: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        logOutButton.layer.masksToBounds = true
        logOutButton.layer.cornerRadius = logOutButton.frame.width/8
        currencyButton.layer.masksToBounds = true
        currencyButton.layer.cornerRadius = currencyButton.frame.width/10
        addressButton.layer.masksToBounds = true
        addressButton.layer.cornerRadius = addressButton.frame.width/18
        contactUsButton.layer.masksToBounds = true
        contactUsButton.layer.cornerRadius = contactUsButton.frame.width/18
        aboutUsButton.layer.masksToBounds = true
        aboutUsButton.layer.cornerRadius = aboutUsButton.frame.width/18
    }
    
    @IBAction func addressButtonAction()
    {
        print("Address")
        let addressView = storyboard?.instantiateViewController(withIdentifier: "addressVC") as! AddressVC
        navigationController?.pushViewController(addressView, animated: true)
    }
    
    @IBAction func currencyButtonAction
    (_ sender: Any)
    {
        print("Currency")

    }
    
    @IBAction func contactUsButtonAction(_ sender: Any)
    {
        print("Contact Us")
        let contactUsView = storyboard?.instantiateViewController(withIdentifier: "contactusVC") as! ContactUsVC
        self.present(contactUsView, animated: true, completion: nil)
    }
   
    @IBAction func aboutUsButtonAction(_ sender: Any)
    {
        print("About Us")
        let aboutUsView = storyboard?.instantiateViewController(withIdentifier: "aboutusVC") as! AboutUsVC
        self.present(aboutUsView, animated: true, completion: nil)
    }
    
    @IBAction func logOutButtonAction(_ sender: Any)
    {
        print("Log Out")
    }
    
}
