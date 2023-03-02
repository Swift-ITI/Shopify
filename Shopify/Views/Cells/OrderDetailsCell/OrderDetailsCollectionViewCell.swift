//
//  OrderDetailsCollectionViewCell.swift
//  Shopify
//
//  Created by Salma on 27/02/2023.
//

import UIKit

class OrderDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ordername: UILabel!
    @IBOutlet weak var orderprice: UILabel!
    @IBOutlet weak var orderimage: UIImageView!
    
    @IBOutlet weak var orderquantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    @IBAction func plusbtn(_ sender: Any) {
    }
    
    
    @IBAction func minusbtn(_ sender: Any) {
    }
    
}
