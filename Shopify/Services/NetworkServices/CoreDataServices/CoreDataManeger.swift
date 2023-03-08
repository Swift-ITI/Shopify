//
//  CoreDataManeger.swift
//  Shopify
//
//  Created by Zeinab on 07/03/2023.
//

import Foundation
import Foundation
import UIKit
import CoreData

protocol CoreDataOpe {
    func saveToCoreData(lineItem : LineItem)
    func deleteFromCoreData(lineItemId : Int)
    func deleteAllLineItems()
    func fetchFromCoreData() -> [NSManagedObject]
    func isInCart(lineItemId : Int) -> Bool
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
        let fetchLineItems = fetchFromCoreData()
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
