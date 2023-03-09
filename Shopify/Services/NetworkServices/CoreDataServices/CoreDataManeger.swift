//
//  CoreDataManeger.swift
//  Shopify
//
//  Created by Zeinab on 07/03/2023.
//

import Foundation
import UIKit
import CoreData

protocol CoreDataOpe {
    func saveToCoreData(lineItem : LineItem)
    
    func SaveToCoreData(draftOrderId : Int, productId: Int , title: String , price: String , quantity : Int)
    
    func deleteFromCoreData(lineItemId : Int)
    
    func deleteAllLineItems()
    
    func fetchFromCoreData() -> [NSManagedObject]
    
    func fetchDraftOrder(draftOrderId : Int) -> [NSManagedObject]
    
    func isInCart(lineItemId : Int) -> Bool
}
    
protocol FavCoreData
{
    func SaveFavtoCoreData(draftOrderID : Int, productID: Int, title: String, price: String, quantity: Int)
    
    func FetchFavFromCoreData(draftOrderID : Int) -> [NSManagedObject]
    
    func FetchFav() -> [NSManagedObject]

    func DeleteFromFav(lineitemID : Int)
    
    func isFav(lineItemId : Int) -> Bool
}

class CoreDataManager : CoreDataOpe{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext : NSManagedObjectContext!
    let entity : NSEntityDescription!
    
    private static var sharedInstance : CoreDataManager?
    
    public static func getInstance()->CoreDataManager{
        
        if sharedInstance == nil {
            sharedInstance = CoreDataManager()
        }
        
        return sharedInstance!
            
    }
    
    private init(){
        managedContext = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "CartOrder", in: self.managedContext)
    }
    
    func saveToCoreData(lineItem : LineItem){
        
        let draftOrders = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        draftOrders.setValue(lineItem.id, forKey: "id")
        draftOrders.setValue(lineItem.title, forKey: "title")
        draftOrders.setValue(lineItem.price, forKey: "price")
        draftOrders.setValue(lineItem.quantity, forKey: "qunatity")
        
        do{
            try managedContext.save()
        }catch let error {
            print (error)
        }
    }
    func SaveToCoreData(draftOrderId : Int,productId: Int, title: String, price: String, quantity: Int) {
    
        let draftOrders = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        draftOrders.setValue(draftOrderId, forKey: "draft_orderID")
        draftOrders.setValue(productId, forKey: "id")
        draftOrders.setValue(title, forKey: "title")
        draftOrders.setValue(price, forKey: "price")
        draftOrders.setValue(quantity, forKey: "qunatity")
        
        do{
            try managedContext.save()
        }catch let error {
            print (error)
        }
    }
    
    func deleteFromCoreData(lineItemId : Int) {
        let fetchLineItems = fetchFromCoreData()
        
        for item in fetchLineItems {
            if item.value(forKey: "id") as! Int == lineItemId {
                managedContext.delete(item)
            }
        }
        do {
            try managedContext.save()
        } catch let error {
            print (error)
        }
    }
    
    func fetchFromCoreData() -> [NSManagedObject] {
        
        var lineItemFromCoreData : [NSManagedObject]!
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CartOrder")
        
        do{
            lineItemFromCoreData = try self.managedContext.fetch(fetchRequest)
           
        } catch let error {
            print (error)
        }
        
        return lineItemFromCoreData
    }
    
    func fetchDraftOrder(draftOrderId: Int) -> [NSManagedObject] {
        
        var lineItemFromCoreData : [NSManagedObject]!
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CartOrder")
        
        let predicate = NSPredicate(format: "draft_orderID == %i", draftOrderId)
        
        fetchRequest.predicate = predicate
        
        do{
            lineItemFromCoreData = try self.managedContext.fetch(fetchRequest)
           
        } catch let error {
            print (error)
        }
        
        return lineItemFromCoreData
    }
    
 
    func deleteAllLineItems() {
        let fetchLineItems = fetchFromCoreData()
        for item in fetchLineItems {
                managedContext.delete(item)
        }
        do {
            try managedContext.save()
        } catch let error {
            print (error)
        }
    }
    func isInCart(lineItemId : Int) -> Bool {
        let fetchLineItems = self.fetchFromCoreData()
        for item in fetchLineItems {
            if item.value(forKey: "id") as! Int == lineItemId {
                return true
            }
        }
        return false
    }
    
//    func isFavourite(leagueKey : Int) -> Bool {
//
//        let fetchLeagues = fetchFromCoreData()
//
//        for item in fetchLeagues {
//            if item.value(forKey: "league_key") as! Int == leagueKey {
//               return true
//            }
//        }
//        return false
//    }
    
}
class FavCoreDataManager : FavCoreData
{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext : NSManagedObjectContext!
    let entity : NSEntityDescription!
    
    private static var FavsharedInstance : FavCoreDataManager?
    
    public static func getFavInstance()-> FavCoreDataManager{
        
        if FavsharedInstance == nil {
            FavsharedInstance = FavCoreDataManager()
        }
        
        return FavsharedInstance!
            
    }
    
    private init(){
        managedContext = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "WishList", in: self.managedContext)
    }
    
    func SaveFavtoCoreData(draftOrderID: Int, productID: Int, title: String, price: String, quantity: Int) {
        let WishList = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        WishList.setValue(draftOrderID, forKey: "draft_orderID")
        WishList.setValue(productID, forKey: "id")
        WishList.setValue(title, forKey: "title")
        WishList.setValue(price, forKey: "price")
        WishList.setValue(quantity, forKey: "quantity")
        
        do{
            try managedContext.save()
        }catch let error {
            print (error)
        }
    }
    
    func FetchFavFromCoreData(draftOrderID: Int) -> [NSManagedObject] {
        
        var FavlineItemFromCoreData : [NSManagedObject]!
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CartOrder")
        
        let predicate = NSPredicate(format: "draft_orderID == %i", draftOrderID)
        
        fetchRequest.predicate = predicate
        
        do{
            FavlineItemFromCoreData = try self.managedContext.fetch(fetchRequest)
            
        } catch let error {
            print (error)
        }
        
        return FavlineItemFromCoreData
    }
    
    func FetchFav() -> [NSManagedObject] {
        var FavlineItemFromCoreData : [NSManagedObject]!
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "WishList")
        
        do{
            FavlineItemFromCoreData = try self.managedContext.fetch(fetchRequest)
           
        } catch let error {
            print (error)
        }
        
        return FavlineItemFromCoreData
    }
    
    func DeleteFromFav(lineitemID: Int)  {
        
        let fetchLineItems = FetchFav()
        
        for item in fetchLineItems {
            if item.value(forKey: "id") as! Int == lineitemID {
                managedContext.delete(item)
            }
        }
        do {
            try managedContext.save()
        } catch let error {
            print (error)
        }
    }
    
    func isFav(lineItemId: Int) -> Bool {
        let fetchfavLineItems = self.FetchFav()
        for item in fetchfavLineItems {
            if item.value(forKey: "id") as! Int == lineItemId {
                return true
            }
        }
        return false
    }
}
