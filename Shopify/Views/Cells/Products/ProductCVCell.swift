//
//  ProductCVCell.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import UIKit
import CoreData

class ProductCVCell: UICollectionViewCell {

    @IBOutlet weak var imgOfProduct: UIImageView!
    @IBOutlet weak var nameOfProduct: UILabel!
    @IBOutlet weak var priceOfProduct: UILabel!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var cartBtn: UIButton!
    
    var heartFlag = false
    var cartFlag = false
    
    var idd : Int?
    var vieww : UIViewController?
    
    var favVMobj : FavCoreDataViewModel?
    var favobj : FavCoreDataManager?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if ((favobj?.isFav(lineItemId: idd ?? 0)) != nil){
         
            heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            print("exist")
           
        } else {
         
            heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
           print("Not")
        }
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
        self.layer.cornerRadius = CGFloat(20)
        // Initialization code
        favVMobj = FavCoreDataViewModel()
        favobj = favVMobj?.getfavInstance()
    }
    
    
    @IBAction func clickHeart(_ sender: Any) {
        
        if (favobj?.isFav(lineItemId: idd ?? 0))! {
            favobj?.DeleteFromFav(lineitemID: idd ?? 0)
            heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        else {
            heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            favobj?.SaveFavtoCoreData(draftOrderID: 0, productID: idd ?? 0, title: nameOfProduct.text ?? "", price: priceOfProduct.text ?? "", quantity: 1)
        }
    }
    
    
    @IBAction func clickCart(_ sender: Any) {
        
        if cartFlag {
            cartBtn.setImage(UIImage(systemName: "cart"), for: .normal)
            cartFlag = false
        }
        else {
            cartBtn.setImage(UIImage(systemName: "cart.fill"), for: .normal)
            cartFlag = true
            
        }
    }
    
}
