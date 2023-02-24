//
//  ProfileVC.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import UIKit

class ProfileVC: UIViewController
{

    @IBOutlet var orders: UILabel!
    @IBOutlet var wishList: UILabel!
    @IBOutlet var wishlistSeeMore: UIButton!
    @IBOutlet var ordersSeeMore: UIButton!
    
    @IBOutlet var wishListTable: UITableView!
    {
        didSet
        {
            wishListTable.delegate = self
            wishListTable.dataSource = self
            wishListTable.layer.borderColor = UIColor(named:"CoffeeColor")?.cgColor
            wishListTable.layer.borderWidth = 1.5
            wishListTable.layer.cornerRadius = 20
            
            let wishListCellNib = UINib(nibName: "WishListsCell", bundle: nil)
            wishListTable.register(wishListCellNib, forCellReuseIdentifier: "wishListCell")
        }
    }
    @IBOutlet var ordersTable: UITableView!
    {
        didSet
        {
            ordersTable.delegate = self
            ordersTable.dataSource = self
            ordersTable.layer.borderColor = UIColor(named:"CoffeeColor")?.cgColor
            ordersTable.layer.borderWidth = 1.5
            ordersTable.layer.cornerRadius = 20
            
            let orderCellNib = UINib(nibName: "OrdersCell", bundle: nil)
            ordersTable.register(orderCellNib, forCellReuseIdentifier: "orderCell")
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.layer.cornerRadius = 30
        orders.layer.masksToBounds = true
        orders.layer.cornerRadius = orders.frame.width/10
        wishList.layer.masksToBounds = true
        wishList.layer.cornerRadius = wishList.frame.width/12
        wishlistSeeMore.layer.masksToBounds = true
        wishlistSeeMore.layer.cornerRadius = wishlistSeeMore.frame.width/8
        ordersSeeMore.layer.masksToBounds = true
        ordersSeeMore.layer.cornerRadius = ordersSeeMore.frame.width/8
    }
    
    @IBAction func cartButton(_ sender: Any)
    {
        print("cart")
    }
    
    @IBAction func settingButton(_ sender: Any)
    {
        print("setting")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileVC : UITableViewDelegate , UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch tableView
        {
        case ordersTable:
            return 2
            
        case wishListTable:
            return 4
        
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch tableView
        {
        case ordersTable:
        let cell : OrdersCell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrdersCell
            cell.priceLabel.text = "1234 $"
            cell.dateLabel.text = "13 - 03 - 2023 12:00 PM"
            return cell
            
        case wishListTable:
            let cell : WishListsCell = tableView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath) as! WishListsCell
                cell.price.text = "1234 $"
                cell.clothType.text = "Sweet Shit"
                return cell
        
        default:
            let cell : WishListsCell = tableView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath) as! WishListsCell
            return cell
        }
    }
}
