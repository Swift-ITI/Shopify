//
//  CartVC.swift
//  Shopify
//
//  Created by Adham Samer on 22/02/2023.
//

import UIKit
import CoreData
import Reachability

class CartVC: UIViewController {
    
    @IBOutlet weak var cartProducts: UITableView!
    @IBOutlet weak var subTotal: UILabel!
    
    var cartVM : DraftOrderViewModel?
    var draftOrder : SingleDraftOrder?
    let nsDefault = UserDefaults()
    
    var coreDataVm : CoreDataViewModel?
    var coreData : CoreDataManager?
    
    var managedContext : NSManagedObjectContext!
    var lineItemsFromCoreData : Array<NSManagedObject>!
    
    var reachabilty : Reachability!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CartProductCV", bundle: nil)
        cartProducts.register(nib, forCellReuseIdentifier: "cartPorducts")
        
        coreDataVm = CoreDataViewModel()
        coreData = coreDataVm?.getInstance()
        
        cartVM = DraftOrderViewModel()
        cartVM?.getDraftOrders(target: .draftOrder(id:( nsDefault.value(forKey: "draftOrderID") as? Int ?? 0)))
        cartVM?.bindDraftOrderToCartVC = {() in
            DispatchQueue.main.async {
                self.draftOrder = self.cartVM?.draftOrderResults
                self.cartProducts.reloadData()
               // self.cartProducts.reloadData()
//                for lineItem in self.draftOrder?.draft_order?.line_items ?? [] {
//                        self.coreData?.saveToCoreData(lineItem: lineItem)
//                    }
                self.lineItemsFromCoreData = self.coreData?.fetchDraftOrder(draftOrderId: (self.nsDefault.value(forKey: "draftOrderID") as? Int ?? 0))
                self.lineItemsFromCoreData = self.coreData?.fetchFromCoreData()
                self.cartProducts.reloadData()
                }
            }
        }
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.lineItemsFromCoreData = coreData?.fetchFromCoreData()
        cartProducts.reloadData()
        
    }
    
    @IBAction func proceedToCheckout(_ sender: Any) {
        performSegue(withIdentifier: "goToPayment", sender: self)
        print("Proceed to checkout")
    }

}

extension CartVC : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(1)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView : UIView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let alert : UIAlertController = UIAlertController(title: "Delete Item ?", message: "Are you sure that you want to delete this item from your Cart", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {action in
                print("Deleted")
                tableView.deleteSections([indexPath.section], with: .left)
                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
        tableView.reloadData()
    }
}

extension CartVC : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        reachabilty = Reachability.forInternetConnection()
        if reachabilty.isReachable() {
            reachabilty.isReachableViaWiFi()
            print("connected")
        return draftOrder?.draft_order?.line_items?.count ?? 0
        }else {
            return lineItemsFromCoreData.count
        }
            
      
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cartProductscell = tableView.dequeueReusableCell(withIdentifier: "cartPorducts", for: indexPath) as! CartProductCV
        
        cartProductscell.layer.borderWidth = 3
        cartProductscell.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
        cartProductscell.layer.cornerRadius = 20
        
        reachabilty = Reachability.forInternetConnection()
        if reachabilty.isReachable() {
            reachabilty.isReachableViaWiFi()
            print("connected")
                    
            cartProductscell.productName.text = draftOrder?.draft_order?.line_items?[indexPath.section].title
            
            cartProductscell.productPrice.text = draftOrder?.draft_order?.line_items?[indexPath.section].price
                    
            cartProductscell.quantity.text = "1"
            
            
            
        }else {
            print("Not connected")
            cartProductscell.productName.text = lineItemsFromCoreData[indexPath.section].value(forKey: "title") as? String
            
            cartProductscell.productPrice.text = (lineItemsFromCoreData[indexPath.section].value(forKey: "price") as? Int)?.formatted()
            
            cartProductscell.quantity.text = "1"
            
        }
        
//        cartProductscell.productName.text = draftOrder?.draft_order?.line_items?[indexPath.section].title
//
//        cartProductscell.productPrice.text = draftOrder?.draft_order?.line_items?[indexPath.section].price
//
//        cartProductscell.quantity.text = "1"
        
      //  cartProductscell.productName.text = lineItemsFromCoreData[indexPath.section].value(forKey: "title") as? String
        
//        if (Int(cartProductscell.quantity.text ?? "") == draftOrder?.draft_order?.line_items?[indexPath.section].quantity ) {
//            cartProductscell.plusQuantity.isUserInteractionEnabled = false
//           // cartProductscell.
//        }
        
        
        return cartProductscell
    }
    
}
