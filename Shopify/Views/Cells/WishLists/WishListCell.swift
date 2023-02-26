//
//  WishListCell.swift
//  Shopify
//
//  Created by Michael Hany on 26/02/2023.
//

import UIKit

class WishListCell: UICollectionViewCell
{

    @IBOutlet var cartButton: UIButton!
    @IBOutlet var trashButton: UIButton!
    @IBOutlet var productPriceLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productImage: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

}
