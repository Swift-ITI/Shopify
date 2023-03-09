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
    func getfavInstance () -> FavCoreDataManager
    {
        return FavCoreDataManager.getFavInstance()
    }
}
