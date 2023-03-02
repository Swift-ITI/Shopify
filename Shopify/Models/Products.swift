//
//  Product.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import Foundation

class Products : Decodable
{
    var products : [Product]
}

class Product : Decodable {
    var id : Int
    var title : String
    var body_html : String?
    var vendor : String
    var product_type : String
    var handle : String
    var status : String
    var variants : [Variant]?
    var options : [Option]?
    var images : [Image]?
    var image : Image?
}
class Variant : Decodable {
    var id : Int
    var product_id : Int
    var title : String
    var price : String
    var sku : String
    var position : Int?
    var fulfillment_service : String?
    var option1 : String?
    var option2 : String?
    var option3 : String?
    var taxable : Bool
    var inventory_quantity : Int
}

class Option : Decodable {
    var id : Int
    var product_id : Int
    var name : String
    var position : Int?
    var values : [String]?
}



