//
//  SettingsVC.swift
//  Shopify
//
//  Created by Michael Hany on 25/02/2023.
//

import UIKit

class SettingsVC: UIViewController
{

    var coreDataVm : CoreDataViewModel?
    var coreDataManeger : CoreDataManager?
// MARK: - IBOutlets Part
    
    @IBOutlet var aboutUsButton: UIButton!
    {
        didSet
        {
            aboutUsButton.layer.masksToBounds = true
            aboutUsButton.layer.cornerRadius = aboutUsButton.frame.width/18
        }
    }
    
    @IBOutlet var contactUsButton: UIButton!
    {
        didSet
        {
            contactUsButton.layer.masksToBounds = true
            contactUsButton.layer.cornerRadius = contactUsButton.frame.width/18
        }
    }
    
    @IBOutlet var addressButton: UIButton!
    {
        didSet
        {
            addressButton.layer.masksToBounds = true
            addressButton.layer.cornerRadius = addressButton.frame.width/18
        }
    }
    
    @IBOutlet var currencyButton: UIButton!
    {
        didSet
        {
            currencyButton.layer.masksToBounds = true
            currencyButton.layer.cornerRadius = currencyButton.frame.width/10
        }
    }
    
    @IBOutlet var currencySegment: UISegmentedControl!
    {
        didSet
        {

        }
    }
    
    @IBOutlet var logOutButton: UIButton!
    {
        didSet
        {
            logOutButton.layer.masksToBounds = true
            logOutButton.layer.cornerRadius = logOutButton.frame.width/8
        }
    }
    

// MARK: - SettingVC Part

    var userID : Int?
    var nsDefaults = UserDefaults()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        coreDataVm = CoreDataViewModel()
        coreDataManeger = coreDataVm?.getInstance()
    }
    
// MARK: - IBActions Part
    
    @IBAction func addressButtonAction()
    {
        print("Address")
        let addressView = storyboard?.instantiateViewController(withIdentifier: "addressVC") as! AddressVC
        addressView.userID = userID ?? 6810321223958
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
        nsDefaults.set(false, forKey: "isLogged")
       // coreDataManeger?.deleteAllLineItems()
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
}
