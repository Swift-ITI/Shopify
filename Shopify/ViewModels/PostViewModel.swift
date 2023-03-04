//
//  PostViewModel.swift
//  Shopify
//
//  Created by Adham Samer on 03/03/2023.
//

import Foundation

// MARK: User & Addresses Part

class User : Decodable
{
    var id : Int?
    var first_name : String?
    var last_name : String?
    var email : String?
    var addresses : [Address]?
    var default_address : Address?
    var orders_count : Int?
    var currency : String?
}

class Address:Decodable
{
    var id : Int?                  // Address id
    var customer_id : Int?
    var address1 : String?
    var city : String?
    var country : String?
    var zip : String?
    var phone : String?
}

class UserResult : Decodable
{
    var customers : [User]
}

// MARK: Orders & Items Part

class Orders : Decodable
{
    var id : Int?
    var current_total_price : String?
    var created_at : String?
    var line_items : [LineItems]?
}

class LineItems : Decodable
{
    var id : Int?
    var price : String?
    var quantity : Int?
    var title : String?
}

class OrderResult : Decodable
{
    var orders : [Orders]
}
