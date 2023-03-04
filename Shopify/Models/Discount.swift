//
//  Discount.swift
//  Shopify
//
//  Created by Salma on 01/03/2023.
//

import Foundation
class Discount : Decodable
{
    var code : String
    var usage_count : Int
    var price_rule_id : Int
    var id : Int
}

class Discounts : Decodable
{
    var discount_codes : [Discount]
}
