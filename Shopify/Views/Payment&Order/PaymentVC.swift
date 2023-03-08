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
    
    var shouldPay : Int?
    var approved : Bool = true
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
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool)
    {
    }
    
    @IBAction func proceedOrderBtn(_ sender: Any)
    {
        if approved
        {
            let orderObj = self.storyboard?.instantiateViewController(withIdentifier: "orderVC") as! OrderVC
            
            self.navigationController?.pushViewController(orderObj, animated: true)
        }
        else
        {
            let alert = UIAlertController(title: "", message: "Sorry you can't choose this payment Type", preferredStyle: UIAlertController.Style.alert)
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
            if shouldPay! <= 10000
            {
                print("Approved")
                processImage.image = UIImage(named: "money")
                processText.text = "You will Pay by Cash"
                approved = true

            }
            else
            {
                print("Denied")
                processImage.image = UIImage(named: "cross")
                processText.text = "We are sorry but the order is too huge to be paid in cash"
                approved = false
            }
            
        case payPalBtn:
            print("PayPal")
            processImage.image = UIImage(named: "paypal")
            processText.text = "You will Pay by your PayPal Account"
            approved = true

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
