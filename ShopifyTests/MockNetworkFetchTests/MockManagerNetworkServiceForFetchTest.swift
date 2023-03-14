//
//  MockNetworkServiceForFetchTest.swift
//  ShopifyTests
//
//  Created by Michael Hany on 14/03/2023.
//

import Foundation
@testable import Shopify

class MockNetworkServicesForFetchProductsAPI
{
    static let mockItemsJsonResponseFromProducts: String = "{\"products\":[{\"id\":8122990625046,\"title\":\"ADIDAS | CLASSIC BACKPACK\",\"body_html\":\"This women's backpack has a glam look, thanks to a faux-leather build with an allover fur print. The front zip pocket keeps small things within reach, while an interior divider reins in potential chaos.\",\"vendor\":\"ADIDAS\",\"product_type\":\"ACCESSORIES\",\"handle\":\"adidas-classic-backpack\",\"status\":\"active\",\"variants\":[{\"id\":44182967943446,\"product_id\":8122990625046,\"price\":\"70.00\",\"sku\":\"AD-03-black-OSee\"}]}]}"
}

extension MockNetworkServicesForFetchProductsAPI : FETCH_DATA
{
    static func fetch<T: Decodable>(url: String?, compiletionHandler: @escaping (T?) -> Void) where T : Decodable
    {
        let data = Data(mockItemsJsonResponseFromProducts.utf8)
        do {
            let response = try JSONDecoder().decode(T.self, from: data)
            
            compiletionHandler(response)
        }catch _ {
            compiletionHandler(nil)
        }
    }
}
