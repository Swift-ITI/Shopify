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
    
    var singleProduct: SingleProduct?

    
    @IBOutlet var productCollection: UITableView!
    {
        didSet
        {
            productCollection.delegate = self
            productCollection.dataSource = self
            let wishListCellNib = UINib(nibName: "WishListTableCell", bundle: nil)
            productCollection.register(wishListCellNib, forCellReuseIdentifier: "wishListTableCell")
            
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
        cell.layer.borderColor = UIColor(named:"AccentColor")?.cgColor
        cell.layer.cornerRadius = CGFloat(20)
        cell.layer.shadowColor = UIColor(named: "AccentColor")?.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 3
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false

        cell.productNameLabel.adjustsFontSizeToFitWidth = true
        cell.productPriceLabel.adjustsFontSizeToFitWidth = true
        cell.productImage.kf.setImage(with: URL(string: favFromCoreData[indexPath.row].value(forKey: "img") as? String ?? "loading"))
        
        cell.productNameLabel.text = favFromCoreData[indexPath.row].value(forKey: "title") as? String ?? ""
        cell.productPriceLabel.text = CurrencyExchanger.changeCurrency(cash: favFromCoreData[indexPath.row].value(forKey: "price") as? String ?? "")
        
        cell.trashButton.tag = indexPath.row
        cell.trashButton.addTarget(self, action: #selector(deleteProducts(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func deleteProducts(_ sender : UIButton){
        let alert : UIAlertController = UIAlertController(title: "Delete Item ?", message: "Are you sure that you want to delete this item from your Wishlist", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
            print("Deleted")
            self.favcoredataobj?.managedContext.delete(self.self.favFromCoreData[sender.tag])
            self.favFromCoreData.remove(at: sender.tag)
            try! self.favcoredataobj?.managedContext.save()
            self.productCollection.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
        self.productCollection.reloadData()
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
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {action in
                print("Deleted")
                self.favcoredataobj?.managedContext.delete(self.self.favFromCoreData[indexPath.row])
                self.favFromCoreData.remove(at: indexPath.row)
                try! self.favcoredataobj?.managedContext.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "HomeSB", bundle: nil)
        let productDetailsObj: ProductDetailsVC = storyBoard.instantiateViewController(withIdentifier: "productdetails") as! ProductDetailsVC
        
        coredatavm?.getProduct(target: .deleteProductByID(id: favFromCoreData[indexPath.row].value(forKey: "id") as? Int ?? 0))
        coredatavm?.bindResultOfFavProductToProductDetails = {() in
            DispatchQueue.main.async {
                self.singleProduct = self.coredatavm?.productFromFav
                productDetailsObj.detailedProduct = self.singleProduct?.product
                
                self.navigationController?.pushViewController(productDetailsObj, animated: true)
                
                
            }
        }
        
//        productDetailsObj.detailedProduct = singleProduct?.product
//        
//        self.navigationController?.pushViewController(productDetailsObj, animated: true)
    }
}
