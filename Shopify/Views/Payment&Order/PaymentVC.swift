//
//  PaymentVC.swift
//  Shopify
//
//  Created by Adham Samer on 22/02/2023.
//

import UIKit
class PaymentVC: UIViewController {
    @IBOutlet var codBtn: UIButton!
    @IBOutlet var applePayBtn: UIButton!
    @IBOutlet var visaBtn: UIButton!

    var radioBtn: SSRadioButtonsController? {
        didSet {
            radioBtn?.delegate = self
            // radioBtn?.shouldLetDeSelect = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        radioBtn = SSRadioButtonsController(buttons: visaBtn, applePayBtn, codBtn)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
    }
}

extension PaymentVC: SSRadioButtonControllerDelegate {
    func didSelectButton(selectedButton: UIButton?) {
        
        switch selectedButton {
        case visaBtn:
            print("Visa")
        case codBtn:
            print("CoD")
        case applePayBtn:
            print("Apple")
        default:
            print("NoBtn")
        }

    }
}
