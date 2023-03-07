//
//  profile.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import Foundation

class Customers: Decodable {
    var customers: [User]
}

class User: Decodable {
    var id: Int?
    var email: String?
    var first_name: String?
    var last_name: String?
    var orders_count: Int?
    //var state: String?
    //var total_spent: String?
    //var last_order_id: Int?
    //var note: String?
    //var verified_email: Bool?
    //var tax_exempt: Bool?
    var tags: String?
    //var last_order_name: String?
    var currency: String?
    var phone: String?
    var addresses: [Address]?
    var default_address: Address?

}
class AddressesResult:Decodable{
    var addresses: [Address]?
}
class Address: Decodable {
    var id: Int?
    var customer_id: Int?
    var first_name: String?
    var last_name: String?
    var company: String?
    var address1: String?
    var address2: String?
    var city: String?
    var province: String?
    var country: String?
    var zip: String?
    var phone: String?
    var name: String?
    var province_code: String?
    var country_code: String?
    var country_name: String?
    var `default`: Bool?
}
