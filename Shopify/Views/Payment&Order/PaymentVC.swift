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
    
    var shouldPay : Int = 0
    var approved : Int = 0
    var paymentMethod : String?
    var currencyDefault = UserDefaults()
    var paymentMethodUserDefault = UserDefaults()
    var cashType: String?

    /*@IBOutlet weak var addressTable: UITableView!{
        didSet{
            //addressTable.delegate = self
            //addressTable.dataSource = self
            let nib = UINib(nibName: "AddressesCell", bundle: nil)
            addressTable.register(nib, forCellReuseIdentifier: "addressesCell")
            addressTable.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
            addressTable.layer.borderWidth = 1.5
            addressTable.layer.cornerRadius = 20
        }
    }*/
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
            processText.text = "Total Cost = \(shouldPay) \nYou will Pay by your PayPal Account"
            
        case "Denied":
            processText.text = "Total Cost = \(shouldPay) \nSorry but your order is too expensive to be Cash On Delivery"
            
        case "Cash on Delivery":
            processText.text = "Total Cost = \(shouldPay) \nYou will pay in Cash when order is delivered"
            
        default:
            print("Error")
        }
        return type
    }
    
// check if approved or not (exceed the max number)
    func checkAprrovedProcces(maxNumber: Int)
    {
        if shouldPay < maxNumber
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
            //let orderObj = self.storyboard?.instantiateViewController(withIdentifier: "orderVC") as! OrderVC
            //orderObj.paymentMethodText = paymentMethod
            paymentMethodUserDefault.set("\(paymentMethod)", forKey: "PaymentType")
            paymentMethodUserDefault.set(true, forKey: "PaymentFlag")
            //orderObj.paymentMethodSetFlag = true
            //orderObj.shouldPay = shouldPay ?? 0
            self.navigationController?.popViewController(animated: true)
            //self.navigationController?.pushViewController(orderObj, animated: true)
            
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
                checkAprrovedProcces(maxNumber: 500)
                
            case "EGP":
                checkAprrovedProcces(maxNumber: 5000)
                
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
/*extension PaymentVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressesCell", for: indexPath) as! AddressesCell
        return cell
    }
}*/
