//
//  CartVC.swift
//  Shopify
//
//  Created by Adham Samer on 22/02/2023.
//

import CoreData
import Reachability
import UIKit

class CartVC: UIViewController {
    @IBOutlet var cartProducts: UITableView!
    @IBOutlet var subTotal: UILabel!

    var cartVM: DraftOrderViewModel?
    var draftOrder: SingleDraftOrder?
    var arrProducts: [Product] = [] 

    var productt: CatigoriesViewModel?
    var Oneproduct: Products?
    
    let nsDefault = UserDefaults()

    var coreDataVm: CoreDataViewModel?
    var coreData: CoreDataManager?

    var managedContext: NSManagedObjectContext!
    var lineItemsFromCoreData: Array<NSManagedObject>!

    var reachabilty: Reachability!
    var flag: Bool = false

    var arrayofdict: [[String: Any]] = []
    var refresh = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(ref), for: .valueChanged)
        cartProducts.addSubview(refresh)
        let nib = UINib(nibName: "CartProductCV", bundle: nil)
        cartProducts.register(nib, forCellReuseIdentifier: "cartPorducts")

        reachabilty = Reachability.forInternetConnection()

        if reachabilty.isReachable() {
            reachabilty.isReachableViaWiFi()
            print("connected via WIFI")
            flag = true
            productt = CatigoriesViewModel()
            cartVM = DraftOrderViewModel()
            cartVM?.getProduct(target: .allProducts)

            productt?.getProducts(target: .allProducts)
            productt?.bindResultOfCatigoriesToCatigorieViewController = { // () in
                DispatchQueue.main.async { [self] in
                    //  self.Oneproduct = self.productt?.DataOfProducts
                    self.arrProducts = self.productt?.DataOfProducts.products ?? []
                    print("salma\(self.arrProducts.count)")
                    self.cartProducts.reloadData()
                    print(self.nsDefault.value(forKey: "draftOrderID") as? Int ?? 0)
                }
            }

            cartVM?.getDraftOrders(target: .draftOrder(id: nsDefault.value(forKey: "draftOrderID") as? Int ?? 0))
            cartVM?.bindDraftOrderToCartVC = { () in
                DispatchQueue.main.async {
                    self.draftOrder = self.cartVM?.draftOrderResults
                    self.subTotal.text = "Sub Total: \(CurrencyExchanger.changeCurrency(cash: self.draftOrder?.draft_order?.subtotal_price ?? "0"))"
                    self.cartProducts.reloadData()
                }
            }
        
        } else {
            print("Not conneted")
            flag = false

            coreDataVm = CoreDataViewModel()
            coreData = coreDataVm?.getInstance()
            lineItemsFromCoreData = coreData?.fetchDraftOrder(draftOrderId: nsDefault.value(forKey: "draftOrderID") as? Int ?? 0)
            lineItemsFromCoreData = coreData?.fetchFromCoreData()
            cartProducts.reloadData()
        }
    }
    @objc func ref() {
        self.render()
        self.refresh.endRefreshing()
    }
    func showAlert(title: String, msg: String, handler: @escaping (UIAlertAction?) -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in handler(action) }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
            ()
        }))
        present(alert, animated: true, completion: nil)
    }

    @IBAction func proceedToCheckout(_ sender: Any) {
        let orderDetailsVC = UIStoryboard(name: "Payment&OrderSB", bundle: nil).instantiateViewController(withIdentifier: "orderVC") as! OrderVC
        orderDetailsVC.OrderDetailsResponse = draftOrder
        orderDetailsVC.arrofpro = arrProducts
       
        navigationController?.pushViewController(orderDetailsVC, animated: true)
        print("Proceed to checkout")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let orderVC = segue.destination as? OrderVC
        orderVC?.OrderDetailsResponse = draftOrder
        orderVC?.arrofpro = arrProducts
        
         }
}

extension CartVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(1)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
            let alert: UIAlertController = UIAlertController(title: "Delete Item ?", message: "Are you sure you want to delete this item from your Cart", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
                print("Deleted")
                self.draftOrder?.draft_order?.line_items?.remove(at: indexPath.section)
                if self.draftOrder?.draft_order?.line_items?.count == 0 {
                    self.cartVM?.deleteDraftOrder(target: .draftOrder(id: self.nsDefault.value(forKey: "draftOrderID") as? Int ?? 0))
                    self.nsDefault.set("first", forKey: "note")
                } else {
                    self.arrayofdict = self.converttodic(arrofline: self.draftOrder?.draft_order?.line_items ?? [])
                    let params = [
                        "draft_order": [
                            "line_items": self.arrayofdict,
                        ],
                    ]
                    self.cartVM?.editDraftOrder(target: .draftOrder(id: self.nsDefault.value(forKey: "draftOrderID") as? Int ?? 0), params: params)
                }
                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true, completion: nil)
        }
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let SecondStoryBoardObj = UIStoryboard(name: "HomeSB", bundle: nil)
        let ProductDetailsobj = SecondStoryBoardObj.instantiateViewController(withIdentifier: "productdetails") as! ProductDetailsVC
        for producctt in arrProducts
        {
            if draftOrder?.draft_order?.line_items?[indexPath.row].product_id == producctt.id
            {
                ProductDetailsobj.detailedProduct = producctt
            }
        }
        self.navigationController?.pushViewController(ProductDetailsobj, animated: true)
        
        
        
        
    }

    func converttodic(arrofline: [LineItem]) -> [[String: Any]] {
        var arrofdict: [[String: Any]] = []
        for item in arrofline {
            let dict: [String: Any] = [
                "variant_id": item.variant_id ?? 0,
                "product_id": item.product_id ?? 0,
                "title": item.title ?? "",
                "vendor": item.vendor ?? "",
                "quantity": item.quantity ?? 0,
                "price": item.price ?? "",
            ]
            arrofdict.append(dict)
        }
        return arrofdict
    }
}

extension CartVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if flag {
            return draftOrder?.draft_order?.line_items?.count ?? 0
        } else {
            return lineItemsFromCoreData.count
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cartProductscell = tableView.dequeueReusableCell(withIdentifier: "cartPorducts", for: indexPath) as! CartProductCV

        cartProductscell.layer.borderWidth = 3
        cartProductscell.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        cartProductscell.layer.cornerRadius = 20

        if flag {
            for iteem in arrProducts {
                if draftOrder?.draft_order?.line_items?[indexPath.section].product_id == iteem.id {
                    cartProductscell.productImg.kf.setImage(with: URL(string: iteem.image?.src ?? ""))
                }
            }
            cartProductscell.productName.text = draftOrder?.draft_order?.line_items?[indexPath.section].title

            cartProductscell.productPrice.text = CurrencyExchanger.changeCurrency(cash: draftOrder?.draft_order?.line_items?[indexPath.section].price ?? "")

            cartProductscell.quantity.text = draftOrder?.draft_order?.line_items?[indexPath.section].quantity?.formatted()
            cartProductscell.plusQuantity.tag = indexPath.section
            cartProductscell.plusQuantity.addTarget(self, action: #selector(plus), for: .touchUpInside)
            cartProductscell.deleteProduct.tag = indexPath.section
            cartProductscell.deleteProduct.addTarget(self, action: #selector(deleteLineItem), for: .touchUpInside)
            cartProductscell.minusQuantity.tag = indexPath.section
            cartProductscell.minusQuantity.addTarget(self, action: #selector(minus), for: .touchUpInside)

        } else {
            cartProductscell.productName.text = lineItemsFromCoreData[indexPath.section].value(forKey: "title") as? String

            cartProductscell.productPrice.text = CurrencyExchanger.changeCurrency(cash: (lineItemsFromCoreData[indexPath.section].value(forKey: "price") as? Int)?.formatted() ?? "")

            cartProductscell.quantity.text = "1"

            cartProductscell.plusQuantity.addTarget(self, action: #selector(actionAlert), for: .touchUpInside)
            cartProductscell.deleteProduct.addTarget(self, action: #selector(actionAlert), for: .touchUpInside)
            cartProductscell.minusQuantity.addTarget(self, action: #selector(actionAlert), for: .touchUpInside)
        }
        return cartProductscell
    }

    @objc
    func actionAlert() {
        let alert = UIAlertController(title: "No internet", message: "Please Cheack your internet connection", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in }))
        present(alert, animated: true, completion: nil)
    }

    @objc func plus(sender: UIButton) {
        
        if draftOrder?.draft_order?.line_items?[sender.tag].quantity == 3 {
            showAlert(title: "Sorry", msg: "Exceeded Number", handler: { action in
                self.render()
            })
        }
        else{
            draftOrder?.draft_order?.line_items?[sender.tag].quantity! += 1
            
        }
      
        let params = [
            "draft_order": [
                "line_items": converttodic(arrofline: draftOrder?.draft_order?.line_items ?? []),
            ],
        ]
        cartVM?.editDraftOrder(target: .draftOrder(id: nsDefault.value(forKey: "draftOrderID") as? Int ?? 0), params: params)
        cartProducts.reloadData()
    }
    
    @objc func minus(sender: UIButton) {
        if draftOrder?.draft_order?.line_items?[sender.tag].quantity == 1 {
            showAlert(title: "Sorry", msg: "Can't decrease", handler: { action in
                self.render()
            })
        }
        else{
            draftOrder?.draft_order?.line_items?[sender.tag].quantity! -= 1
            
        }
        let params = [
            "draft_order": [
                "line_items": converttodic(arrofline: draftOrder?.draft_order?.line_items ?? []),
            ],
        ]
        cartVM?.editDraftOrder(target: .draftOrder(id: nsDefault.value(forKey: "draftOrderID") as? Int ?? 0), params: params)
        cartProducts.reloadData()
    }

    @objc func deleteLineItem(sender: UIButton) {
        let alert: UIAlertController = UIAlertController(title: "Delete Item ?", message: "Are you sure you want to delete this item from your Cart", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
            print("Deleted")
            self.coreData?.deleteFromCoreData(lineItemId: self.draftOrder?.draft_order?.line_items?[sender.tag].id ?? 0)
            self.draftOrder?.draft_order?.line_items?.remove(at: sender.tag)
            if self.draftOrder?.draft_order?.line_items?.count == 0 {
                self.cartVM?.deleteDraftOrder(target: .draftOrder(id: self.nsDefault.value(forKey: "draftOrderID") as? Int ?? 0))
                self.nsDefault.set("first", forKey: "note")
            } else {
                self.arrayofdict = self.converttodic(arrofline: self.draftOrder?.draft_order?.line_items ?? [])
                let params = [
                    "draft_order": [
                        "line_items": self.arrayofdict,
                    ],
                ]
                self.cartVM?.editDraftOrder(target: .draftOrder(id: self.nsDefault.value(forKey: "draftOrderID") as? Int ?? 0), params: params)
            }

            self.cartProducts.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}

extension CartVC {
    func render(){
        self.cartVM?.getDraftOrders(target: .draftOrder(id: self.nsDefault.value(forKey: "draftOrderID") as? Int ?? 0))
        self.cartVM?.bindDraftOrderToCartVC = { () in
            DispatchQueue.main.async {
                self.draftOrder = self.cartVM?.draftOrderResults
                self.subTotal.text = "Sub Total: \(CurrencyExchanger.changeCurrency(cash: self.draftOrder?.draft_order?.subtotal_price ?? "0"))"
                self.cartProducts.reloadData()
            }
        }
    }
}
