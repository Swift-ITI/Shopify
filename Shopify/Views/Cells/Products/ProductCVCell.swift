//
//  ProductCVCell.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import UIKit

class ProductCVCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: "CoffeColor")?.cgColor
        self.layer.cornerRadius = CGFloat(20)
        // Initialization code
    }

}
