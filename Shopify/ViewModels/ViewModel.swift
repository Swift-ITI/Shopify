//
//  ViewModel.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import Foundation
class BrandViewModel
{
    var bindResultToHomeViewController : ( ()->() ) = {}
    
    var DataofBrands : Brands!
    {
        didSet
        {
            bindResultToHomeViewController()
        }
    }
    func getdata (url : String)
    {
        NetworkServices.fetch(url: url) { result in
            self.DataofBrands = result
        }
    }
}


class OfferViewModel
{
    var bindResultToHomeViewController : ( ()->() ) = {}
    
    var DataofOffers : Discounts!
    {
        didSet
        {
            bindResultToHomeViewController
        }
    }
    
    func getoffer (url : String)
    {
        NetworkServices.fetch(url: url) { result in
            self.DataofOffers = result
        }
    }
}
