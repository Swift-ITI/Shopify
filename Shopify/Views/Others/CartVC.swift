//
//  CartVC.swift
//  Shopify
//
//  Created by Adham Samer on 22/02/2023.
//

import UIKit

class CartVC: UIViewController {
    
    @IBOutlet weak var cartProducts: UITableView!
    
    @IBOutlet weak var subTotal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CartProductCV", bundle: nil)
        cartProducts.register(nib, forCellReuseIdentifier: "cartPorducts")

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
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cartProductscell = tableView.dequeueReusableCell(withIdentifier: "cartPorducts", for: indexPath) as! CartProductCV
        
        cartProductscell.layer.borderWidth = 3
        cartProductscell.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
        cartProductscell.layer.cornerRadius = 20
        if (Int(cartProductscell.quantity.text ?? "") == 12) {
            cartProductscell.plusQuantity.isUserInteractionEnabled = false
           // cartProductscell.
        }
        
        
        return cartProductscell
    }
    
}
