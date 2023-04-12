//
//  CoreDataViewModel.swift
//  Shopify
//
//  Created by Zeinab on 07/03/2023.
//

import Foundation
import CoreData

class  CoreDataViewModel {
    
    func getInstance () -> CoreDataManager {
        
        return CoreDataManager.getInstance()

    }
    
}

class FavCoreDataViewModel
{
    var bindResultOfFavProductToProductDetails: (() -> Void) = {}
    var productFromFav: SingleProduct! {
        didSet{
            bindResultOfFavProductToProductDetails()
        }
    }
    func getfavInstance () -> FavCoreDataManager
    {
        return FavCoreDataManager.getFavInstance()
    }
    func getProduct(target: EndPoints)
    {
        NetworkServices.fetch(url: target.path) { result in
            self.productFromFav = result
        }
    }
}
