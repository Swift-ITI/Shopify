//
//  MockNetworkServiceForFetchTest.swift
//  ShopifyTests
//
//  Created by Michael Hany on 14/03/2023.
//

import Foundation
import XCTest
@testable import Shopify

func testFetchForProductsAPI ()
{
    MockNetworkServicesForFetchProductsAPI.fetch(url: "https://29f36923749f191f42aa83c96e5786c5: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@ios-q2-new-capital-admin-2022-2023.myshopify.com/admin/api/2023-01/products.json", compiletionHandler: { data  in
        guard let products : Products =  data else
        {
            XCTFail()
            return
        }
        XCTAssertNotEqual(products.products.count, 0, "API Failed")
    })
}
