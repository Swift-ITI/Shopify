//
//  WishListVC.swift
//  Shopify
//
//  Created by Michael Hany on 26/02/2023.
//

import UIKit
import CoreData

class WishListSeeMoreVC: UIViewController
{
    var managedContext : NSManagedObjectContext!
    
    var favFromCoreData : Array<NSManagedObject>!
    
    var coredatavm : FavCoreDataViewModel?
    var favcoredataobj : FavCoreDataManager?

    
    @IBOutlet var productCollection: UITableView!
    {
        didSet
        {
            productCollection.delegate = self
            productCollection.dataSource = self
            let wishListCellNib = UINib(nibName: "WishListTableCell", bundle: nil)
            productCollection.register(wishListCellNib, forCellReuseIdentifier: "wishListTableCell")
            /*productCollection.layer.borderWidth = 3
            productCollection.layer.borderColor = UIColor(named:"CoffeeColor")?.cgColor
            productCollection.layer.cornerRadius = CGFloat(20)*/
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        coredatavm = FavCoreDataViewModel()
        favcoredataobj = coredatavm?.getfavInstance()
        
        favFromCoreData = favcoredataobj?.FetchFav()
        
        self.productCollection.reloadData()
        

        // Do any additional setup after loading the view.
    }
    
//    @IBAction func cartButton(_ sender: Any)
//    {
//        performSegue(withIdentifier: "goToCart", sender: self)
//        print("cart")
//    }
//
}

// MARK: - Table View Extension

extension WishListSeeMoreVC: UITableViewDelegate
{
    
}

extension WishListSeeMoreVC: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return favFromCoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : WishListTableCell = tableView.dequeueReusableCell(withIdentifier: "wishListTableCell", for: indexPath) as! WishListTableCell
        cell.layer.borderWidth = 1.5
        cell.layer.borderColor = UIColor(named:"CoffeeColor")?.cgColor
        cell.layer.cornerRadius = CGFloat(20)
        cell.productNameLabel.adjustsFontSizeToFitWidth = true
        cell.productPriceLabel.adjustsFontSizeToFitWidth = true
        
        cell.productNameLabel.text = favFromCoreData[indexPath.row].value(forKey: "title") as? String ?? ""
        cell.productPriceLabel.text = favFromCoreData[indexPath.row].value(forKey: "price") as? String ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let alert : UIAlertController = UIAlertController(title: "Delete Item ?", message: "Are you sure that you want to delete this item from your Wishlist", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {action in
                print("Deleted")
                tableView.deleteRows(at: [indexPath], with: .left)
                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
        tableView.reloadData()
    }
}
