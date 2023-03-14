//
//  ProfileVC.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import Reachability
import UIKit
import CoreData
import Kingfisher

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
    
    var managedContext : NSManagedObjectContext!
    var wishListItems : [NSManagedObject] = []
    var coredatavm : FavCoreDataViewModel?
    var favcoredataobj : FavCoreDataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        //fetchCoreData()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        fetchData()
        //fetchCoreData()
    }
    
    func fetchData()
    {
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
                coredatavm = FavCoreDataViewModel()
                favcoredataobj = coredatavm?.getfavInstance()
                wishListItems = favcoredataobj?.FetchFav() ?? []
                self.wishListTable.reloadData()
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
            if orderDetails?.orders.count ?? 0 > 2
            {
                return 2
            }
            else
            {
                return orderDetails?.orders.count ?? 0
            }

        case wishListTable:
            if wishListItems.count > 4 ?? 0
            {
                return 4
            }
            else
            {
                return wishListItems.count
            }

        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
// Orders Table
        case ordersTable:
            let cell: OrdersCell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrdersCell
            cell.priceLabel.text = CurrencyExchanger.changeCurrency(cash: orderDetails?.orders[indexPath.row].current_total_price ?? "")
            cell.dateLabel.text = orderDetails?.orders[indexPath.row].created_at
            //cell.dateLabel.adjustsFontSizeToFitWidth = true
            cell.itemsNumberLabel.text = "\(orderDetails?.orders[indexPath.row].line_items?.count ?? 0)"
            return cell

// Wish List Table
        case wishListTable:
            let cell: WishListsCell = tableView.dequeueReusableCell(withIdentifier: "wishListsCell", for: indexPath) as! WishListsCell
            cell.price.text = CurrencyExchanger.changeCurrency(cash: wishListItems[indexPath.row].value(forKey: "price") as? String ?? "")
            cell.clothType.text = wishListItems[indexPath.row].value(forKey: "title") as? String
            cell.clothType.adjustsFontSizeToFitWidth = true
            let imageURL = URL(string: wishListItems[indexPath.row].value(forKey: "img") as? String ?? "https://img.freepik.com/premium-vector/system-software-update-upgrade-concept-loading-process-screen-vector-illustration_175838-2182.jpg?w=826")
            cell.clothImage.kf.setImage(with: imageURL)
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

/*// MARK: - Core Data Extension Part

extension ProfileVC
{
    func fetchCoreData ()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WishList")
        do
        {
            wishListItems = try managedContext.fetch(fetchRequest)
            wishListTable.reloadData()
        } catch let error
        {
            print(error.localizedDescription)
        }
    }
}*/
