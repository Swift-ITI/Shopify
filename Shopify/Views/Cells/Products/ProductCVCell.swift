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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
        self.layer.cornerRadius = CGFloat(20)
        self.layer.shadowColor = UIColor(named: "AccentColor")?.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
    }
    
    
    @IBAction func clickHeart(_ sender: Any) {
        
    }
    
    

}
