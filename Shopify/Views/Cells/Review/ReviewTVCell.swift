//
//  ReviewTVCell.swift
//  Shopify
//
//  Created by Adham Samer on 02/03/2023.
//

import UIKit

class ReviewTVCell: UITableViewCell {

    @IBOutlet weak var ratingText: UILabel!
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var reviewText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
