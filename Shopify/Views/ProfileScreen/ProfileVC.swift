//
//  ProfileVC.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import Reachability
import UIKit

class ProfileVC: UIViewController {
    // MARK: - IBOutlets Part

    @IBOutlet var ordersNumberLabel: UILabel!
    @IBOutlet var usersNameLabel: UILabel!

    @IBOutlet var ordersLabel: UILabel! {
        didSet {
            ordersLabel.layer.masksToBounds = true
            ordersLabel.layer.cornerRadius = ordersLabel.frame.width / 10
        }
    }

    @IBOutlet var wishListLabel: UILabel! {
        didSet {
            wishListLabel.layer.masksToBounds = true
            wishListLabel.layer.cornerRadius = wishListLabel.frame.width / 12
        }
    }

    @IBOutlet var wishListSeeMoreButton: UIButton! {
        didSet {
            wishListSeeMoreButton.layer.masksToBounds = true
            wishListSeeMoreButton.layer.cornerRadius = wishListSeeMoreButton.frame.width / 8
        }
    }

    @IBOutlet var ordersSeeMoreButton: UIButton! {
        didSet {
            ordersSeeMoreButton.layer.masksToBounds = true
            ordersSeeMoreButton.layer.cornerRadius = ordersSeeMoreButton.frame.width / 8
        }
    }

    @IBOutlet var wishListTable: UITableView! {
        didSet {
            // Delegate and DataSource
            wishListTable.delegate = self
            wishListTable.dataSource = self
            // Table Format
            wishListTable.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
            wishListTable.layer.borderWidth = 1.5
            wishListTable.layer.cornerRadius = 20
            // NIB File
            let wishListCellNib = UINib(nibName: "WishListsCell", bundle: nil)
            wishListTable.register(wishListCellNib, forCellReuseIdentifier: "wishListsCell")
        }
    }

    @IBOutlet var ordersTable: UITableView! {
        didSet {
            // Delegate and DataSource
            ordersTable.delegate = self
            ordersTable.dataSource = self
            // Table Format
            ordersTable.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
            ordersTable.layer.borderWidth = 1.5
            ordersTable.layer.cornerRadius = 20
            // NIB File
            let orderCellNib = UINib(nibName: "OrdersCell", bundle: nil)
            ordersTable.register(orderCellNib, forCellReuseIdentifier: "orderCell")
        }
    }

    // MARK: - ProfileVC Part

    var userDetails: Customers?
    var userVM: UserViewModel?

    var orderDetails: OrdersResult?
    var orderVM: OrderViewModel?

    var id: Int?
    var email: String?
    var logged: Bool = true
    var nsDefaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        id = nsDefaults.value(forKey: "customerID") as? Int
        let reachability: Reachability = Reachability.forInternetConnection()
        if reachability.isReachable()
        // if connected to the internet
        {
            if !nsDefaults.bool(forKey: "isLogged") {
                performSegue(withIdentifier: "goToNoUser", sender: self)
            } else {
                userVM = UserViewModel()
                userVM?.fetchUsers(target: .searchCustomerByID(id: id ?? 6810321223958))
                userVM?.bindDataToVC = { () in self.renderProfileView() }

                // Orders Part
                orderVM = OrderViewModel()
                orderVM?.getOrders(target: .orderPerCustomer(id: id ?? 6810321223958))
                orderVM?.bindResultToProfileVC = { () in self.renderOrderView()
                    self.ordersTable.reloadData()
                }
                ordersTable.reloadData()
            }
        } else {
            let alert: UIAlertController = UIAlertController(title: "Connection Error", message: "You are not connected to the Network so please check your Wi-Fi or Mobile Data Again", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    func renderProfileView() {
        DispatchQueue.main.async {
            self.userDetails = self.userVM?.users
            print(self.userDetails?.customers.first?.email ?? "none")
            self.usersNameLabel.text = "\(self.userDetails?.customers.first?.first_name ?? "No") \(self.userDetails?.customers.first?.last_name ?? "User")"
            self.ordersNumberLabel.text = "\(self.userDetails?.customers.first?.orders_count ?? 0)"
            // self.ordersNumberLabel.text = String(self.orderDetails?.orders.count ?? 0)
        }
        print(userDetails?.customers.first?.email ?? "none")
    }

    func renderOrderView() {
        DispatchQueue.main.async {
            self.orderDetails = self.orderVM?.ordersResult
            self.ordersTable.reloadData()
        }
    }

    // MARK: - IBActions Part

    @IBAction func settingActionButton(_ sender: Any) {
        print("setting")
        let settingView = storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! SettingsVC
        settingView.userID = id ?? 6810321223958
        navigationController?.pushViewController(settingView, animated: true)
    }

    @IBAction func cartButton(_ sender: Any) {
        performSegue(withIdentifier: "goToCart", sender: self)
        print("cart")
    }

    @IBAction func ordersSeeMoreActionButton(_ sender: Any) {
        print("orders See More")
        let previousOrderScreen = storyboard?.instantiateViewController(withIdentifier: "previousOrder") as! PreviousOrdersVC
        previousOrderScreen.userID = id
        previousOrderScreen.orders = orderDetails?.orders
        present(previousOrderScreen, animated: true, completion: nil)
    }

    @IBAction func wishListSeeMoreActionButton(_ sender: Any) {
        let wishListView = storyboard?.instantiateViewController(withIdentifier: "wishlistseemoreVC") as! WishListSeeMoreVC
        navigationController?.pushViewController(wishListView, animated: true)
    }
}

// MARK: - Table View Extension

extension ProfileVC: UITableViewDelegate {
}

extension ProfileVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case ordersTable:
            return orderDetails?.orders.count ?? 0

        case wishListTable:
            return 4

        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case ordersTable:
            let cell: OrdersCell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrdersCell
            cell.priceLabel.text = orderDetails?.orders[indexPath.row].current_total_price
            cell.dateLabel.text = orderDetails?.orders[indexPath.row].created_at
            cell.itemsNumberLabel.text = "\(orderDetails?.orders[indexPath.row].line_items?.count ?? 0)"
            return cell

        case wishListTable:
            let cell: WishListsCell = tableView.dequeueReusableCell(withIdentifier: "wishListsCell", for: indexPath) as! WishListsCell
            cell.price.text = "1234 $"
            cell.clothType.text = "Sweet Shit"
            return cell

        default:
            let cell: WishListsCell = tableView.dequeueReusableCell(withIdentifier: "wishListsCell", for: indexPath) as! WishListsCell
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
