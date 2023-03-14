//
//  NetworkServiceFetchTest.swift
//  ShopifyTests
//
//  Created by Michael Hany on 14/03/2023.
//

import XCTest
@testable import Shopify

final class NetworkServicesForFootballTests: XCTestCase
{
    override func setUpWithError() throws {
    }
    
    override func tearDownWithError() throws {
    }
    
    
    func testPerformanceExample() throws {
        self.measure {
        }
    }
    
    func testFetchForOrdersAPI ()
    {
        let expectation = expectation(description: "Waiting for API")
        NetworkServices.fetch(url: "https://29f36923749f191f42aa83c96e5786c5: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@ios-q2-new-capital-admin-2022-2023.myshopify.com/admin/api/2023-01/orders.json")
        { result in
            guard let apiOrder : OrdersResult = result else
            {
                XCTFail()
                expectation.fulfill()
                return
            }
            XCTAssertNotEqual(apiOrder.orders.count, 0, "API Failed")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchForProductsAPI ()
    {
        let expectation = expectation(description: "Waiting for API")
        NetworkServices.fetch(url: "https://29f36923749f191f42aa83c96e5786c5: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@ios-q2-new-capital-admin-2022-2023.myshopify.com/admin/api/2023-01/products.json")
        { result in
            guard let apiProducts : Products = result else
            {
                XCTFail()
                expectation.fulfill()
                return
            }
            XCTAssertNotEqual(apiProducts.products.count, 0, "API Failed")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
