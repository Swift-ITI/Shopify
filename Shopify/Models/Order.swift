//
//  Order.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import Foundation

class Order : Decodable
{
    var id : Int?
    var created_at : String?
    var current_total_price : String?
    var line_items : [LineItems]?
}

class LineItems : Decodable
{
    var id : Int?
    var price : String?
    var quantity : Int?
    var title : String?
}

class OrdersResult : Decodable
{
    var orders : [Order]
}
