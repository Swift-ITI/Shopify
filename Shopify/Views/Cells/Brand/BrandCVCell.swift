//
//  BrandCVCell.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import UIKit

class BrandCVCell: UICollectionViewCell {

    @IBOutlet weak var offerbrandimg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.layer.borderColor = UIColor(named: "BeigeColor")?.cgColor
        self.layer.borderWidth = 2
        // Initialization code
    }

}
