//
//  DraftOrders.swift
//  Shopify
//
//  Created by Zeinab on 05/03/2023.
//

import Foundation
class DraftOrderResult : Decodable {
    var draft_orders : [DraftOrder]?
}

class SingleDraftOrder : Decodable {
    var draft_order : DraftOrder?
}

class DraftOrder : Decodable {
    var id : Int?
    var name : String?
    var customer : User?
    var note : String?
    var email : String?
    var currency : String?
    var line_items : [LineItem]?
    var texable : Bool?
    var total_price: String?
    var subtotal_price: String?
    var total_tax: String?
}

class LineItem : Decodable {
//    var fulfillable_quantity : Int
//    var fulfillment_service : String
    var id : Int?
    var price : String?//
    var product_id : Int?
    var quantity : Int?//
    var requires_shipping : Bool?
  //  var sku : String?
    var title : String?//
    var variant_id : Int?
    var vendor : String?
  //  var name : String?

   
   
}
