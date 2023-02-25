//
//  ProductCVCell.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import UIKit

class ProductCVCell: UICollectionViewCell {

    @IBOutlet weak var imgOfProduct: UIImageView!
    @IBOutlet weak var nameOfProduct: UILabel!
    @IBOutlet weak var priceOfProduct: UILabel!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var cartBtn: UIButton!
    
    var heartFlag = false
    var cartFlag = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: "CoffeColor")?.cgColor
        self.layer.cornerRadius = CGFloat(20)
        // Initialization code
    }
    
    
    @IBAction func clickHeart(_ sender: Any) {
        
        if heartFlag {
            heartBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            heartFlag = false
        }
        else {
            heartBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            heartFlag = true
            
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
