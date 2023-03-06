//
//  EndPoints.swift
//  Shopify
//
//  Created by Zeinab on 01/03/2023.
//

import Foundation

var BaseUrl = "https://29f36923749f191f42aa83c96e5786c5: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@ios-q2-new-capital-admin-2022-2023.myshopify.com/admin/api/2023-01"

enum EndPoints {
    
    case allProducts
    case catigoriesProducts (id : String)
//    case womenProducts (id : String)
//    case kidsProducts
//    case saleProducts
//    case menProducts
    case shoes (id : String) //"SHOES"
    case accessories (id : String) //"ACCESSORIES"
    case tshirts (id : String) //"T-SHIRTS"
    case brandproducts (id : String)
    case searchCustomer(email : String)
    case searchCustomerByID(id : Int)
    case orderPerCustomer(id: Int)
    case allCustomers
    case deleteAddress(customerID: Int, addressID: Int)
    case addAddress(id : Int)
    var path : String {
        switch self{
        case .allProducts:
            return "\(BaseUrl)/products.json"
        case .catigoriesProducts (id : let id) :
            return "\(BaseUrl)/products.json?collection_id=\(id)"
            //        case .womenProducts (id : let id):
            //            return "\(BaseUrl)/products.json?collection_id=\(id)"
            //        case .kidsProducts:
            //            return "\(BaseUrl)/products.json?collection_id=436751368470"
            //        case .saleProducts:
            //            return "\(BaseUrl)/products.json?collection_id=436751401238"
            //        case .menProducts:
            //            return "\(BaseUrl)/products.json?collection_id=436751270166"
        case .shoes (id : let id):
            return "\(BaseUrl)/products.json?collection_id=\(id)&product_type=SHOES"
            
        case .accessories (id : let id):
            return "\(BaseUrl)/products.json?collection_id=\(id)&product_type=ACCESSORIES"
            
        case .tshirts (id : let id):
            return "\(BaseUrl)/products.json?collection_id=\(id)&product_type=T-SHIRTS"
            
        case .brandproducts(id : let id):
            return "\(BaseUrl)/products.json?collection_id=\(id)"
            
        case .searchCustomer(email: let email) :
            return "\(BaseUrl)/customers/search.json?query=email:\(email)"
            
        case .searchCustomerByID(id: let id) :
            return "\(BaseUrl)/customers/search.json?query=id:\(id)"
            
        case .allCustomers :
            return "\(BaseUrl)/customers.json"
            
        case .orderPerCustomer(id: let id) :
            return "\(BaseUrl)/customers/\(id)/orders.json"
            
        case .deleteAddress(customerID: let cusID, addressID: let addID) :
            return "\(BaseUrl)/customers/\(cusID)/addresses/\(addID).json"
            
        case .addAddress(id: let id) :
            return "\(BaseUrl)/customers/\(id)/addresses.json"
        }
    }
    
}

enum CatigoryID {
    case homePage
    case kids
    case men
    case sale
    case women
    
    var id : String {
        switch self {
        case .homePage:
            return "436748681494"
        case .kids:
            return "436751368470"
        case .men:
            return "436751270166"
        case .sale:
            return "436751401238"
        case .women:
            return "436751335702"
        }
    }
}


