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
    
//    var heartFlag = false

//
//    var idd : Int?
//    var vieww : UIViewController?
    
//    var favVMobj : FavCoreDataViewModel?
//    var favobj : FavCoreDataManager?
//    
//    var img : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        if ((favobj?.isFav(lineItemId: idd ?? 0)) != nil){
//         
//            heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//            print("exist")
//           
//        } else {
//         
//            heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
//           print("Not")
//        }
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: "CoffeeColor")?.cgColor
        self.layer.cornerRadius = CGFloat(20)
        // Initialization code
//        favVMobj = FavCoreDataViewModel()
//        favobj = favVMobj?.getfavInstance()
    }
    
    
    @IBAction func clickHeart(_ sender: Any) {
        
//        if (favobj?.isFav(lineItemId: idd ?? 0))! {
//            favobj?.DeleteFromFav(lineitemID: idd ?? 0)
//            heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
//        }
//        else {
//            heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//            favobj?.SaveFavtoCoreData(draftOrderID: 0, productID: idd ?? 0, title: nameOfProduct.text ?? "", price: priceOfProduct.text ?? "", quantity: 1, img: "img")
//        }
    }
    
    

}
