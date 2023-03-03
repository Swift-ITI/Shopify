//
//  OrdersViewModel.swift
//  Shopify
//
//  Created by Michael Hany on 04/03/2023.
//

import Foundation

class OrderView
{
    var bindResultToProfileVC : (()->()) = {}
    var orderResult : [Orders]?
    {
        didSet
        {
            bindResultToProfileVC()
        }
    }
    
    func getOrders (id : Int)
    {
        FetchOrdersData.fetchURLOrders(compeletionHandeler: {result in self.orderResult = result?.orders}, id: id)
    }
}
