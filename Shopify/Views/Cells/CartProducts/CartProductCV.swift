//
//  CartProductCV.swift
//  Shopify
//
//  Created by Zeinab on 23/02/2023.
//

import UIKit

class CartProductCV: UITableViewCell {

    
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productImg: UIImageView!
    
    @IBOutlet weak var quantity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
