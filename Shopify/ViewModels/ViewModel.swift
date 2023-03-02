//
//  ViewModel.swift
//  Shopify
//
//  Created by Adham Samer on 21/02/2023.
//

import Foundation
class BrandViewModel
{
    var bindResultOfBrandsToHomeViewController : ( ()->() ) = {}
    
    var DataOfBrands : Brands!
    {
        didSet
        {
            bindResultOfBrandsToHomeViewController()
        }
    }
    func getdata (url : String)
    {
        NetworkServices.fetch(url: url) { result in
            self.DataOfBrands = result
        }
    }
}


class OfferViewModel
{
    var bindResultOfOffersToHomeViewController : ( ()->() ) = {}
    
    var DataOfOffers : Discounts!
    {
        didSet
        {
            bindResultOfOffersToHomeViewController()
        }
    }
    
    func getoffer (url : String)
    {
        NetworkServices.fetch(url: url) { result in
            self.DataOfOffers = result
        }
    }
}

class CatigoriesViewModel
{
    var bindResultOfCatigoriesToCatigorieViewController : ( ()->() ) = {}
    
    var DataOfProducts : Products!
    {
        didSet
        {
            bindResultOfCatigoriesToCatigorieViewController()
        }
    }
    
    func getProducts (target : EndPoints)
    {
        NetworkServices.fetch(url: target.path) { result in
            self.DataOfProducts = result
        }
    }
}
