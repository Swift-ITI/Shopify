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
    var radioBtn: SSRadioButtonsController? {
        didSet {
            radioBtn?.delegate = self
             radioBtn?.shouldLetDeSelect = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        radioBtn = SSRadioButtonsController(buttons: payPalBtn, codBtn)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func proceedOrderBtn(_ sender: Any) {
        let orderObj = self.storyboard?.instantiateViewController(withIdentifier: "orderVC") as! OrderVC
        
        self.navigationController?.pushViewController(orderObj, animated: true)
    }
    
}

extension PaymentVC: SSRadioButtonControllerDelegate {
    func didSelectButton(selectedButton: UIButton?) {
        
        switch selectedButton {
        case codBtn:
            print("CoD")
        case payPalBtn:
            print("PayPal")
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
