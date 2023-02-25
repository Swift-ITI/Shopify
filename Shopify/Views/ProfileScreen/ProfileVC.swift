//
//  ProfileVC.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import UIKit

class ProfileVC: UIViewController
{

    @IBOutlet var usersNameLabel: UILabel!
    @IBOutlet var ordersLabel: UILabel!
    @IBOutlet var wishListLabel: UILabel!
    @IBOutlet var wishListSeeMoreButton: UIButton!
    @IBOutlet var ordersSeeMoreButton: UIButton!
    
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
        ordersLabel.layer.masksToBounds = true
        ordersLabel.layer.cornerRadius = ordersLabel.frame.width/10
        wishListLabel.layer.masksToBounds = true
        wishListLabel.layer.cornerRadius = wishListLabel.frame.width/12
        wishListSeeMoreButton.layer.masksToBounds = true
        wishListSeeMoreButton.layer.cornerRadius = wishListSeeMoreButton.frame.width/8
        ordersSeeMoreButton.layer.masksToBounds = true
        ordersSeeMoreButton.layer.cornerRadius = ordersSeeMoreButton.frame.width/8
    }
    
    @IBAction func cartButton(_ sender: Any)
    {
        performSegue(withIdentifier: "goToCart", sender: self)
        print("cart")
    }
    
    @IBAction func settingButton(_ sender: Any)
    {
        print("setting")
        let settingView = storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! SettingsVC
        navigationController?.pushViewController(settingView, animated: true)
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
