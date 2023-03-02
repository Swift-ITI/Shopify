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
