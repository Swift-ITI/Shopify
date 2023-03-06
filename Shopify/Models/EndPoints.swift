//
//  EndPoints.swift
//  Shopify
//
//  Created by Zeinab on 01/03/2023.
//

import Foundation

var BaseUrl = "https://29f36923749f191f42aa83c96e5786c5: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@ios-q2-new-capital-admin-2022-2023.myshopify.com/admin/api/2023-01"

var arrayofimg2 : [String]? = ["https://www.citypng.com/public/uploads/preview/hd-discount-30-percent-off-sale-red-badge-png-31632100045jywzxxkjkw.png","https://www.citypng.com/public/uploads/preview/30-percent-off-sale-sign-logo-hd-png-116676817578j6ock9fz6.png","https://www.citypng.com/public/uploads/preview/30-off-tag-red-label-sign-logo-hd-png-116682074589jvh3p0irr.png","https://www.citypng.com/public/uploads/preview/discount-30-percent-text-logo-sign-black-png-image-11668096874eu6qfscms5.png","https://www.pngall.com/wp-content/uploads/13/30-Discount-PNG-Image.png","https://pngimage.net/wp-content/uploads/2018/05/discount-logo-png-3.png","https://www.pngitem.com/pimgs/m/685-6852872_grunge-30-percent-label-psd-hd-png-download.png","https://www.citypng.com/public/uploads/preview/free-discount-big-sale-up-to-30-percent-png-11667685843lkrbyewb8h.png","https://images.getpng.net/uploads/preview/sale-discount-icons-special-offer-price-signs-5-10-20-30-40-50-60-70-80-90-percent-off-reduction30-1151634335821ttswcgo3fa.webp","https://mpng.vectorpng.com/20200421/yva/logo-yellow-number-for-discount-tag-5e9eef211bca35.39632767.jpg"]

enum EndPoints {
    case allProducts
    case catigoriesProducts (id : String)
    case shoes (id : String) //"SHOES"
    case accessories (id : String) //"ACCESSORIES"
    case tshirts (id : String) //"T-SHIRTS"
    case brandproducts (id : String)
    case searchCustomer(email : String)
    case orderPerCustomer(id: Int)
    case allCustomers
    case deleteProductByID(id: Int)
    case brand
    case discounts
    
    
    var path: String {
        switch self {
        case .allProducts:
            return "\(BaseUrl)/products.json"
                
        case let .catigoriesProducts(id: id):
            return "\(BaseUrl)/products.json?collection_id=\(id)"

        case let .shoes(id: id):
            return "\(BaseUrl)/products.json?collection_id=\(id)&product_type=SHOES"
                
        case let .accessories(id: id):
            return "\(BaseUrl)/products.json?collection_id=\(id)&product_type=ACCESSORIES"
                
        case let .tshirts(id: id):
            return "\(BaseUrl)/products.json?collection_id=\(id)&product_type=T-SHIRTS"
                
        case let .brandproducts(id: id):
            return "\(BaseUrl)/products.json?collection_id=\(id)"

        case let .searchCustomer(email: email):
            return "\(BaseUrl)/customers/search.json?query=email:\(email)"
                
        case .allCustomers:
            return "\(BaseUrl)/customers.json"

        case let .deleteProductByID(id: id):
            return "\(BaseUrl)/products/\(id).json"
  
        case .orderPerCustomer(id: let id) :
            return "\(BaseUrl)/customers/\(id)/orders.json"

        case .brand:
            return "\(BaseUrl)/smart_collections.json"
            
        case .discounts:
            return "\(BaseUrl)/price_rules/1380100899094/discount_codes.json"
        }
    }
}

enum CatigoryID {
    case homePage
    case kids
    case men
    case sale
    case women

    var id: String {
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
