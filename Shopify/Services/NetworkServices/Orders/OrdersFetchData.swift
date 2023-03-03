//
//  OrdersFetchData.swift
//  Shopify
//
//  Created by Michael Hany on 04/03/2023.
//

import Foundation
import Alamofire

class FetchOrdersData : FetchOrdersProtocol
{
    static func fetchURLOrders(compeletionHandeler: @escaping (OrderResult?) -> Void, id: Int)
    {
        AF.request("https://29f36923749f191f42aa83c96e5786c5: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@ios-q2-new-capital-admin-2022-2023.myshopify.com/admin/api/2023-01/customers/\(id)orders.json")
            .validate()
            .responseDecodable(of: OrderResult.self) { (data) in
                guard let data = data.value else {return}
                compeletionHandeler(data)
            }
    }
}
