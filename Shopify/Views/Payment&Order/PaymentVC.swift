//
//  PaymentVC.swift
//  Shopify
//
//  Created by Adham Samer on 22/02/2023.
//

import UIKit
class PaymentVC: UIViewController
{
    @IBOutlet var codBtn: UIButton!
    @IBOutlet var payPalBtn: UIButton!
    @IBOutlet var processImage: UIImageView!
    @IBOutlet var processText: UILabel!
    
    var shouldPay : Float?
    var approved : Int = 0
    var paymentMethod : String?
    var currencyDefault = UserDefaults()
    var paymentDefault = UserDefaults()
    var cashType: String?

    var radioBtn: SSRadioButtonsController?
    {
        didSet
        {
            radioBtn?.delegate = self
            radioBtn?.shouldLetDeSelect = true
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        radioBtn = SSRadioButtonsController(buttons: payPalBtn, codBtn)
        cashType = currencyDefault.value(forKey: "CashType") as? String
    }

    override func viewWillAppear(_ animated: Bool)
    {
        cashType = currencyDefault.value(forKey: "CashType") as? String
        approved = 0
    }
    
// image and label changer
    func payMethods(type: String, approve: Int) -> String
    {
        print("\(type)")
        processImage.image = UIImage(named: "\(type)")
        approved = approve
        switch type
        {
        case "PayPal":
            processText.text = "Total Cost = \(shouldPay ?? 0.0) \nYou will Pay by your PayPal Account"
            
        case "Denied":
            processText.text = "Total Cost = \(shouldPay ?? 0.0) \nSorry but your order is too expensive to be Cash On Delivery"
            
        case "Cash on Delivery":
            processText.text = "Total Cost = \(shouldPay ?? 0.0) \nYou will pay in Cash when order is delivered"
            
        default:
            print("Error")
        }
        return type
    }
    
// check if approved or not (exceed the max number)
    func checkAprrovedProcces(maxNumber: Float)
    {
        if shouldPay ?? 0 < maxNumber
        {
            print("Approved")
            paymentMethod = payMethods(type: "Cash on Delivery", approve: 1)
        }
        else
        {
            print("Denied")
            paymentMethod = payMethods(type: "Denied", approve: 2)
        }
    }
    
    @IBAction func proceedOrderBtn(_ sender: Any)
    {
        switch approved
        {
        case 1:
            let orderObj = self.storyboard?.instantiateViewController(withIdentifier: "orderVC") as! OrderVC

            paymentDefault.set("\(paymentMethod ?? "")", forKey: "PaymentMethod")
          
            self.navigationController?.popViewController(animated: true)
            
            
        case 2:
            let alert = UIAlertController(title: "", message: "Sorry you can't choose this payment Type", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true, completion: nil)
        
        default:
            let alert = UIAlertController(title: "", message: "Sorry you have to choose payment method first", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true, completion: nil)
        }
    }
}

extension PaymentVC: SSRadioButtonControllerDelegate
{
    func didSelectButton(selectedButton: UIButton?)
    {
        switch selectedButton
        {
        case codBtn:
            print("CoD")
            switch cashType
            {
            case "USD":
                checkAprrovedProcces(maxNumber: 500.0)
                
            case "EGP":
                checkAprrovedProcces(maxNumber: 15000.0)
                
            default:
                print("Error")
            }
        case payPalBtn:
            paymentMethod = payMethods(type: "PayPal", approve: 1)
            
        default:
            print("NoBtn")
        }
    }
}
