//
//  OrderVC.swift
//  Shopify
//
//  Created by Adham Samer on 22/02/2023.
//

import UIKit
import Kingfisher

class OrderVC: UIViewController {
    
    
    var Orderdetialsviewmodel : OrderDetailsViewModel?
    var OrderDetailsResponse : SingleDraftOrder?
    var defaultAddress : Address?
    
    var customerviewmodel : UserViewModel?
    var customerResponse : Customers?
    
    var NsDefault : UserDefaults?
    
    var OfferCollectionviewresponse : Discounts?
    var Offerviewmodel : OfferViewModel?
    
    var Putcustomerviewmodel : PutCustomerViewModel?
    var putcustomerResponse : [String : Any]?
    
    var priceruleviewmodel : PriceRuleViewModel?
    var priceruleResponse : price_rule?
    
    var arrofdiscount : [Discount]?
    
    let dispatchgroup = DispatchGroup()
    
    var checkcode = true
    
    var NsBoolDefault = UserDefaults()
    
    @IBOutlet weak var orderDetails: UICollectionView!{
        didSet {
            orderDetails.delegate = self
            orderDetails.dataSource = self
            orderDetails.layer.borderWidth = 2
            orderDetails.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
        }
    }
    @IBOutlet weak var adresses: UITableView!{
        didSet{
            adresses.delegate = self
            adresses.dataSource = self
            adresses.layer.borderWidth = 2
            adresses.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
        }
    }
    @IBOutlet weak var coupon: UITextField!
    @IBOutlet weak var subTotal: UILabel!
    @IBOutlet weak var shippingFees: UILabel!
    @IBOutlet weak var discount: UILabel!
    @IBOutlet weak var total: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        NsBoolDefault.set(false, forKey: "coupon")
                
        Offerviewmodel = OfferViewModel()
        
        NsDefault = UserDefaults()
        
        customerviewmodel = UserViewModel()
        
        customerviewmodel?.fetchUsers(target: .searchCustomerByID(id: NsDefault?.integer(forKey: "customerID") ?? 0))
        customerviewmodel?.bindDataToVC = { () in
            DispatchQueue.main.async {
                self.customerResponse = self.customerviewmodel?.users
                self.defaultAddress = self.customerviewmodel?.users?.customers.first?.default_address
                self.adresses.reloadData()
            }
        }
        Orderdetialsviewmodel = OrderDetailsViewModel()
        
        Orderdetialsviewmodel?.getDataOfOrderDetails(target: .draftOrder(id: NsDefault?.integer(forKey: "draftOrderID") ?? 0))
        print(NsDefault?.integer(forKey: "draftOrderID") ?? 0)
        Orderdetialsviewmodel?.bindResultOfCartToOrderDetailsViewController = { () in
            DispatchQueue.main.async {
                self.OrderDetailsResponse = self.Orderdetialsviewmodel?.DataOfOrderDetails
                self.subTotal.text = self.OrderDetailsResponse?.draft_order?.subtotal_price
                self.shippingFees.text = self.OrderDetailsResponse?.draft_order?.total_tax
                self.discount.text = "0"
                self.total.text = self.OrderDetailsResponse?.draft_order?.total_price
                self.orderDetails.reloadData()
            }
        }
        print(OrderDetailsResponse)
        priceruleviewmodel = PriceRuleViewModel()
        priceruleviewmodel?.getpricerule(target: .price_rulee(id:1380100899094))
        
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
        dispatchgroup.enter()
        Offerviewmodel?.getoffer(target: .discounts)
        
        Offerviewmodel?.bindResultOfOffersToHomeViewController = { () in
            self.OfferCollectionviewresponse = self.Offerviewmodel?.DataOfOffers
            self.dispatchgroup.leave()
        }
        dispatchgroup.notify(queue: .main)
        {
            
            if !(self.NsBoolDefault.value(forKey: "coupon") as! Bool)
            {
                self.NsBoolDefault.set(true, forKey: "coupon")
                
                if var cost = Double(self.total.text!)
                {
                    let temp = cost/100*30
                    cost = cost - temp
                    self.total.text = String(cost)
                    self.coupon.text = ""
                    self.discount.text = String(temp)
                }
            }
                
            else
            {
                let alert = UIAlertController(title: "Expired Coupon", message: "You've used this coupon before", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
                
            }
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
            return OrderDetailsResponse?.draft_order?.line_items?.count ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let ordercell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderdetails", for: indexPath) as! OrderDetailsCollectionViewCell
            ordercell.orderimage.kf.setImage(with: URL(string: OrderDetailsResponse?.draft_order?.line_items?[indexPath.section].title ?? "" ),placeholder: UIImage(named: "loading.png"))
            ordercell.orderprice.text = OrderDetailsResponse?.draft_order?.line_items?[indexPath.section].price
            ordercell.ordername.text = OrderDetailsResponse?.draft_order?.line_items?[indexPath.section].title
            ordercell.orderquantity.text = String(OrderDetailsResponse?.draft_order?.line_items?[indexPath.section].quantity ?? 0)
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
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let addressobj = UIStoryboard(name: "ProfileSB", bundle: nil).instantiateViewController(withIdentifier: "addressVC") as! AddressVC
            addressobj.userID = NsDefault?.integer(forKey: "customerID")
            self.navigationController?.pushViewController(addressobj, animated: true)
            
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
            addressesCell.countryLabel.text = defaultAddress?.country
            addressesCell.cityLabel.text = defaultAddress?.city
            addressesCell.phoneNumberLabel.text = defaultAddress?.phone
            addressesCell.checkMarkImage.image = UIImage(systemName: "checkmark.circle.fill")
            
            return addressesCell
        }
    }
