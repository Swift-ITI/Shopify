//
//  WishListTableCell.swift
//  Shopify
//
//  Created by Michael Hany on 01/03/2023.
//

import UIKit

class WishListTableCell: UITableViewCell
{

    @IBOutlet var trashButton: UIButton!
    @IBOutlet var productPriceLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productImage: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
