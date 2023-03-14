//
//  MockNetworkFetchTests.swift
//  ShopifyTests
//
//  Created by Michael Hany on 14/03/2023.
//

import XCTest
@testable import Shopify

final class MockNetworkFetchTests: XCTestCase
{
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    func testExample() throws {
    }
    
    func testPerformanceExample() throws {
        self.measure {
        }
    }
    
    func testFetchForProductsAPI ()
    {
        MockNetworkServicesForFetchProductsAPI.fetch(url: "https://29f36923749f191f42aa83c96e5786c5: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@ios-q2-new-capital-admin-2022-2023.myshopify.com/admin/api/2023-01/products.json") { data  in
            guard let products : Products =  data else
            {
                //XCTFail()
                return
            }
            XCTAssertNotEqual(products.products.count, 0, "API Failed")
        }
    }
}
