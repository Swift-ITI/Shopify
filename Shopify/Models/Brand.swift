//
//  Brand.swift
//  Shopify
//
//  Created by Salma on 28/02/2023.
//

import Foundation
class Brand : Decodable
{
    var id : Int
    var handle : String?
    var title : String
    var body_html : String?
    var image : Image
}

class Brands : Decodable
{
    var smart_collections : [Brand]
}

class Image : Decodable
{
    var id : Int?
    var product_id : Int?
    var position : Int?
    var src : String
}
