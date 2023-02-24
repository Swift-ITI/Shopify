//
//  OrdersCell.swift
//  Shopify
//
//  Created by Michael Hany on 24/02/2023.
//

import UIKit

class OrdersCell: UITableViewCell
{

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
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
