//
//  ProfileVC.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import UIKit
import Reachability

class ProfileVC: UIViewController
{

// MARK: - IBOutlets
    
    @IBOutlet var ordersNumberLabel: UILabel!
    @IBOutlet var usersNameLabel: UILabel!
    
    @IBOutlet var ordersLabel: UILabel!
    {
        didSet
        {
            ordersLabel.layer.masksToBounds = true
            ordersLabel.layer.cornerRadius = ordersLabel.frame.width/10
        }
    }
    
    @IBOutlet var wishListLabel: UILabel!
    {
        didSet
        {
            wishListLabel.layer.masksToBounds = true
            wishListLabel.layer.cornerRadius = wishListLabel.frame.width/12
        }
    }
    
    @IBOutlet var wishListSeeMoreButton: UIButton!
    {
        didSet
        {
            wishListSeeMoreButton.layer.masksToBounds = true
            wishListSeeMoreButton.layer.cornerRadius = wishListSeeMoreButton.frame.width/8
        }
    }
    
    @IBOutlet var ordersSeeMoreButton: UIButton!
    {
        didSet
        {
            ordersSeeMoreButton.layer.masksToBounds = true
            ordersSeeMoreButton.layer.cornerRadius = ordersSeeMoreButton.frame.width/8
        }
    }
    
    @IBOutlet var wishListTable: UITableView!
    {
        didSet
        {
            //Delegate and DataSource
            wishListTable.delegate = self
            wishListTable.dataSource = self
            //Table Format
            wishListTable.layer.borderColor = UIColor(named:"CoffeeColor")?.cgColor
            wishListTable.layer.borderWidth = 1.5
            wishListTable.layer.cornerRadius = 20
            //NIB File
            let wishListCellNib = UINib(nibName: "WishListsCell", bundle: nil)
            wishListTable.register(wishListCellNib, forCellReuseIdentifier: "wishListsCell")
        }
    }
    @IBOutlet var ordersTable: UITableView!
    {
        didSet
        {
            //Delegate and DataSource
            ordersTable.delegate = self
            ordersTable.dataSource = self
            //Table Format
            ordersTable.layer.borderColor = UIColor(named:"CoffeeColor")?.cgColor
            ordersTable.layer.borderWidth = 1.5
            ordersTable.layer.cornerRadius = 20
            //NIB File
            let orderCellNib = UINib(nibName: "OrdersCell", bundle: nil)
            ordersTable.register(orderCellNib, forCellReuseIdentifier: "orderCell")
        }
    }
    
// MARK: - ProfileVC
    
    var userDetails : User?
    var profileView : ProfileView?
    var id : Int?
    var logged : Bool = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let reachability : Reachability = Reachability.forInternetConnection()
        if reachability.isReachable()       // if connected to the internet
        {
            print("there's Network")

// To Check If Logged In or Not
            if logged                       // if logged in to the app
            {
                profileView = ProfileView()
                profileView?.getUser(id: id ?? 6810321649942)
                profileView?.bindResultToProfileVC = { () in self.renderView() }
                usersNameLabel.text = "\(userDetails?.first_name ?? "No") \(userDetails?.last_name ?? "User")"
            }
            else
            {
                let alert : UIAlertController = UIAlertController(title: "Not Sign In", message: "You are not Signed-In so please Sign-In or Register Now", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Log-In", style: .default, handler: {action in
                    let loginView = self.storyboard?.instantiateViewController(withIdentifier: "logInScreen") as! LoginVC
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                //alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true, completion: nil)
            }
// End of Check
            
        }
        else
        {
            let alert : UIAlertController = UIAlertController(title: "Network Error", message: "You are not connected to the Network so please check your Wi-Fi or Mobile Data Again", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in
                let loginView = self.storyboard?.instantiateViewController(withIdentifier: "logInScreen") as! LoginVC
                self.navigationController?.popToRootViewController(animated: true)
            }))
            //alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func renderView()
    {
        DispatchQueue.main.async
        {
            self.userDetails = self.profileView?.userResult!
        }
    }
    
// MARK: - IBActions
        ordersLabel.layer.masksToBounds = true
        ordersLabel.layer.cornerRadius = ordersLabel.frame.width/10
        wishListLabel.layer.masksToBounds = true
        wishListLabel.layer.cornerRadius = wishListLabel.frame.width/12
        wishListSeeMoreButton.layer.masksToBounds = true
        wishListSeeMoreButton.layer.cornerRadius = wishListSeeMoreButton.frame.width/8
        ordersSeeMoreButton.layer.masksToBounds = true
        ordersSeeMoreButton.layer.cornerRadius = ordersSeeMoreButton.frame.width/8
        let ordersScreen = storyboard?.instantiateViewController(withIdentifier: "previousOrder") as! PreviousOrdersVC
        ordersNumberLabel.text = "\(ordersScreen.productsNumber) Orders"
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
    
    @IBAction func ordersSeeMoreActionButton(_ sender: Any)
    {
        print("orders See More")
    }
    
    @IBAction func wishListSeeMoreActionButton(_ sender: Any)
    {
        let wishListView = storyboard?.instantiateViewController(withIdentifier: "wishlistseemoreVC") as! WishListSeeMoreVC
        navigationController?.pushViewController(wishListView, animated: true)
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

// MARK: - Table View Extension

extension ProfileVC : UITableViewDelegate
{
    
}

extension ProfileVC : UITableViewDataSource
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
            return userDetails?.orders_count ?? 2
            
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
            let cell : WishListsCell = tableView.dequeueReusableCell(withIdentifier: "wishListsCell", for: indexPath) as! WishListsCell
                cell.price.text = "1234 $"
                cell.clothType.text = "Sweet Shit"
                return cell
        
        default:
            let cell : WishListsCell = tableView.dequeueReusableCell(withIdentifier: "wishListsCell", for: indexPath) as! WishListsCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
}
