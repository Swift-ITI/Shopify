//
//  OrderVC.swift
//  Shopify
//
//  Created by Adham Samer on 22/02/2023.
//

import UIKit

class OrderVC: UIViewController {

    @IBOutlet weak var orderDetails: UICollectionView!{
        didSet {
            orderDetails.delegate = self
            orderDetails.dataSource = self
            orderDetails.layer.borderWidth = 2
            orderDetails.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
        }
    }
    @IBOutlet weak var adresses: UITableView!{
        didSet{
            adresses.delegate = self
            adresses.dataSource = self
            adresses.layer.borderWidth = 2
            adresses.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
        }
    }
    @IBOutlet weak var coupon: UITextField!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var shippingFees: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var total: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
                //orderDetails.layer.borderWidth = 2
       //adresses.layer.borderWidth = 2
      //scroll.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height + 400)
        let tableViewCellnib = UINib(nibName: "AddressesCell", bundle: nil)
        adresses.register(tableViewCellnib, forCellReuseIdentifier: "addressesCell")
        
        let collectionViwCellnib = UINib(nibName: "OrderDetailsCollectionViewCell", bundle: nil)
        orderDetails.register(collectionViwCellnib, forCellWithReuseIdentifier: "orderdetails")

    }
    
    @IBAction func paymentMethod(_ sender: Any) {
        let paymentView = storyboard?.instantiateViewController(withIdentifier: "paymentVC") as! PaymentVC
        navigationController?.pushViewController(paymentView, animated: true)
    }

    @IBAction func validateCoupon(_ sender: Any) {
    }
    
    @IBAction func placeOrder(_ sender: Any) {
    }
}


//MARK: extension1
extension OrderVC: UICollectionViewDelegate{

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
}

//MARK: extension2
extension OrderVC:  UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let ordercell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderdetails", for: indexPath) as! OrderDetailsCollectionViewCell
        ordercell.orderimage.image = UIImage(named: "coupon")
       
        


        return ordercell
    }
}

//MARK: extension3
extension OrderVC: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: orderDetails.layer.frame.size.width - 5, height: orderDetails.layer.frame.size.height/3 - 5)

    }
}

extension OrderVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
extension OrderVC : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addressesCell : AddressesCell = tableView.dequeueReusableCell(withIdentifier: "addressesCell", for: indexPath) as! AddressesCell
        addressesCell.cityLabel.text = "imbabh"

        return addressesCell
    }
}

