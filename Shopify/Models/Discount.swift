//
//  Discount.swift
//  Shopify
//
//  Created by Salma on 01/03/2023.
//

import Foundation

class Discounts : Decodable
{
    var discount_codes : [Discount]
}

class Discount : Decodable
{
    var code : String
    var usage_count : Int
    var price_rule_id : Int
    var id : Int
}

class price_rule : Decodable
{
    var value_type : String?
    var value : String?
    var usage_limit : Int?
}
