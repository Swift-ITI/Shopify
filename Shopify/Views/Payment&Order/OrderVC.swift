
//
//  OrderVC.swift
//  Shopify
//
//  Created by Adham Samer on 22/02/2023.
//

import UIKit
import Kingfisher
import Braintree

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
    
    var arrofpro : [Product]?
    
    let dispatchgroup = DispatchGroup()
    
    var checkcode = true
    
    var NsBoolDefault = UserDefaults()
    var paymentDefault = UserDefaults()
    var postOrderVM : PostOrderViewModel?
    var braintreeClient: BTAPIClient?
    var shouldPay : Int = 1
    var addressExist : Bool = false
    @IBOutlet weak var orderDetails: UICollectionView!{
        didSet {
            orderDetails.delegate = self
            orderDetails.dataSource = self
            orderDetails.layer.borderWidth = 2
            orderDetails.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
        }
    }
    
    @IBOutlet var payMethodOutletButton: UIButton!
    
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
        
        orderDetails.layer.borderWidth = 2
        orderDetails.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
        
        adresses.layer.borderWidth = 2
        adresses.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
        
        adresses.reloadData()
        paymentDefault.set("Pay Method", forKey: "PaymentMethod")
        self.braintreeClient = BTAPIClient(authorization: "sandbox_q7ftqr99_7h4b4rgjq3fptm87")
        
        NsBoolDefault.set(false, forKey: "coupon")
                
        Offerviewmodel = OfferViewModel()
        
        postOrderVM = PostOrderViewModel()
        
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
       // Orderdetialsviewmodel = OrderDetailsViewModel()
        
//        Orderdetialsviewmodel?.getDataOfOrderDetails(target: .draftOrder(id: NsDefault?.integer(forKey: "draftOrderID") ?? 0))
//        print(NsDefault?.integer(forKey: "draftOrderID") ?? 0)
//        Orderdetialsviewmodel?.bindResultOfCartToOrderDetailsViewController = { () in
//            DispatchQueue.main.async {
//                self.OrderDetailsResponse = self.Orderdetialsviewmodel?.DataOfOrderDetails
//                self.subTotal.text = CurrencyExchanger.changeCurrency(cash: self.OrderDetailsResponse?.draft_order?.subtotal_price ?? "")
//                self.shippingFees.text = CurrencyExchanger.changeCurrency(cash: self.OrderDetailsResponse?.draft_order?.total_tax ?? "")
//                self.discount.text = "0"
//                self.total.text = CurrencyExchanger.changeCurrency(cash: self.OrderDetailsResponse?.draft_order?.total_price ?? "")
//                self.orderDetails.reloadData()
//            }
//        }
        print(OrderDetailsResponse)
        priceruleviewmodel = PriceRuleViewModel()
        priceruleviewmodel?.getpricerule(target: .price_rulee(id:1380100899094))
        
        let tableViewCellnib = UINib(nibName: "AddressesCell", bundle: nil)
        adresses.register(tableViewCellnib, forCellReuseIdentifier: "addressesCell")
        
        let collectionViwCellnib = UINib(nibName: "OrderDetailsCollectionViewCell", bundle: nil)
        orderDetails.register(collectionViwCellnib, forCellWithReuseIdentifier: "orderdetails")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        adresses.reloadData()
        self.braintreeClient = BTAPIClient(authorization: "sandbox_q7ftqr99_7h4b4rgjq3fptm87")

        payMethodOutletButton.setTitle("\(paymentDefault.value(forKey: "PaymentMethod") ?? "")", for: .normal)
        customerviewmodel = UserViewModel()
        customerviewmodel?.fetchUsers(target: .searchCustomerByID(id: NsDefault?.integer(forKey: "customerID") ?? 0))
        customerviewmodel?.bindDataToVC = { () in
            DispatchQueue.main.async {
                self.customerResponse = self.customerviewmodel?.users
                self.defaultAddress = self.customerviewmodel?.users?.customers.first?.default_address
                self.adresses.reloadData()
            }
        }
    }
    
    func convertToDict(arryOfLineItem: [LineItem]) -> [[String : Any]]
    {
        var arryOfDict : [[String : Any]] = []
        for item in arryOfLineItem
        {
            let temp : [String : Any] = [
                "price" : item.price ?? "",
                "quantity" : item.quantity ?? 0,
                "title" : item.title ?? ""
            ]
            arryOfDict.append(temp)
        }
        return arryOfDict
    }
    
    func calcTotal() -> Float
    {
        let subtotal : Float = Float(self.OrderDetailsResponse?.draft_order?.subtotal_price ?? "") ?? 0.0
        let shipping : Float = (Float(self.OrderDetailsResponse?.draft_order?.subtotal_price ?? "") ?? 0.0) * 0.14
        let dicounts : Float = (subtotal + shipping) * 0.3
        var totalMoney : Float = 1.1
        
        switch self.NsBoolDefault.value(forKey: "coupon") as? Bool
        {
        case true:
            totalMoney = subtotal + shipping - dicounts
            
        case false:
            totalMoney = subtotal + shipping
            
        default:
            break
        }
        return totalMoney
    }
    
    func postToOrders(id: Int)
    {
    let shopifyLink : String = "https://29f36923749f191f42aa83c96e5786c5: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@ios-q2-new-capital-admin-2022-2023.myshopify.com/admin/api/2023-01/orders.json"
            
        print(shopifyLink)
        let orderData: [String: Any] = [
           "order": [
            "confirmed" : true,
            "contact_email" : "\(NsDefault?.value(forKey: "customerEmail") ?? "")",
            "email" : "\(NsDefault?.value(forKey: "customerEmail") ?? "")",
            "currency" : "EGP",
            "number" : self.OrderDetailsResponse?.draft_order?.line_items?.count ?? 0,
            "order_status_url" : "",
            "current_subtotal_price" : "\(self.OrderDetailsResponse?.draft_order?.subtotal_price ?? "")",
            "current_total_price" : "\(calcTotal())",
            "line_items": convertToDict(arryOfLineItem: self.OrderDetailsResponse?.draft_order?.line_items ?? [])
           ]
        ]
        guard let addressEndpointUrl = URL(string: shopifyLink) else {
            return
        }
        let jsonEncoder = JSONEncoder()
        var addressRequest = URLRequest(url: addressEndpointUrl)
        addressRequest.httpShouldHandleCookies = false
        addressRequest.httpMethod = "POST"
        addressRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        addressRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            
            addressRequest.httpBody = try JSONSerialization.data(withJSONObject: orderData , options: .prettyPrinted)
            
        } catch let error {
            print(error.localizedDescription)
        }
        let session = URLSession.shared
        let task = session.dataTask(with: addressRequest) { (data, response, error) in
            // Handle the response from the Shopify API
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
            }
            if let data = data {
            }
        }
        task.resume()
    }
    
    @IBAction func paymentMethod(_ sender: Any) {
        let paymentView = storyboard?.instantiateViewController(withIdentifier: "paymentVC") as! PaymentVC
        print(Float(self.OrderDetailsResponse?.draft_order?.total_price ?? "") ?? 0.0)
        paymentView.shouldPay = Float(CurrencyExchanger.changeCurrency(cash: String(calcTotal())))
        paymentView.modalPresentationStyle = .fullScreen
        //self.present(paymentView, animated: true, completion: nil)
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
        { [self] in
            if self.coupon.text == ""
            {
                let alert = UIAlertController(title: "No Coupon", message: "Missing Coupon", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                if !(searchh(coupon: coupon.text ?? "") && (NsBoolDefault.bool(forKey: "coupon")))
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
                   //

            }
            }
        }
    func searchh (coupon : String)-> Bool
    {
        for couponn in self.OfferCollectionviewresponse?.discount_codes ?? []
        {
            if coupon == couponn.code
            {
                return true
            }
        }
        return false
    }
    
    @IBAction func placeOrder(_ sender: Any)
    {
        if defaultAddress.self != nil
        {
            addressExist = true
        }
        else
        {
            addressExist = false
        }
        switch addressExist
        {
        case true:
            switch paymentDefault.value(forKey: "PaymentMethod")
            {
            case "PayPal" as String:
                print("start paypal")
                shouldPay = Int(CurrencyExchanger.changeCurrency(cash: self.OrderDetailsResponse?.draft_order?.subtotal_price ?? "")) ?? 1
                let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
                payPalDriver.viewControllerPresentingDelegate = self
                payPalDriver.appSwitchDelegate = self
                
                let request = BTPayPalRequest(amount: "\(shouldPay)")
                request.currencyCode = "USD"
                
                payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
                    if let tokenizedPayPalAccount = tokenizedPayPalAccount
                    {
                        print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                        let email = tokenizedPayPalAccount.email
                        let firstName = tokenizedPayPalAccount.firstName
                        let lastName = tokenizedPayPalAccount.lastName
                        let phone = tokenizedPayPalAccount.phone
                        let billingAddress = tokenizedPayPalAccount.billingAddress
                        let shippingAddress = tokenizedPayPalAccount.shippingAddress
                        
                        self.postToOrders(id: self.NsDefault?.integer(forKey: "customerID") ?? 0)
                        let alert = UIAlertController(title: "Order Procced", message: "your order has been proceed succefully", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {action in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else if let error = error {
                        print(error.localizedDescription)
                    } else {
                        // Buyer canceled payment approval
                        print("Cancel")
                        let alert = UIAlertController(title: "Payment Failed", message: "You have canceled the payment process", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                print("end paypal")
                
            case "Cash on Delivery" as String:
                print("Cash On Delivery")
                self.postToOrders(id: NsDefault?.integer(forKey: "customerID") ?? 0)
                let alert = UIAlertController(title: "Order Procced", message: "your order has been proceed succefully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {action in
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                
            default:
                print("Error")
                let alert = UIAlertController(title: "Payment Error", message: "Please choose a payment method to proceed with it", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                present(alert, animated: true, completion: nil)
            }
        case false:
            let alert = UIAlertController(title: "Address Error", message: "Please choose an address to proceed", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true, completion: nil)
        }
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

           
        
            
            for iteem in arrofpro ?? []
            {
                print("saloma\(arrofpro?.count)")
                if OrderDetailsResponse?.draft_order?.line_items?[indexPath.section].product_id == iteem.id
                {
                    print("salmaaa\(arrofpro?.count)")
                    ordercell.orderimage.kf.setImage(with: URL(string: iteem.image?.src ?? ""))
                   
                }
            }
            ordercell.orderprice.text = CurrencyExchanger.changeCurrency(cash: OrderDetailsResponse?.draft_order?.line_items?[indexPath.section].price ?? "")
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
            addressesCell.cityLabel.text = "\(defaultAddress?.city ?? ""), \(defaultAddress?.address1 ?? "")"
            addressesCell.phoneNumberLabel.text = defaultAddress?.phone
            addressesCell.checkMarkImage.image = UIImage(systemName: "checkmark.circle.fill")
            return addressesCell
        }
    }

    //MARK: Braintree Extensions

extension OrderVC : BTViewControllerPresentingDelegate
{
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
    }
}

extension OrderVC : BTAppSwitchDelegate
{
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
    }
}
