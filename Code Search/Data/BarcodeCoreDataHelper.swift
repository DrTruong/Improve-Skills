//
//  BarcodeCoreDataHelper.swift
//  Code Search
//
//  Created by HTB95 on 21/05/2021.
//

import CoreData
import UIKit

class BarcodeCoreDataHelper {

    var barcodeObjectList: [NSManagedObject] = []
    var barcodeValueList: [String] = []
    
    static let shared = BarcodeCoreDataHelper()
    static let ENTITY_NAME = "Barcode"

    // MARK: Constructor
    private init() {}
    
    // MARK: Private functions
    func getEntity(context: NSManagedObjectContext) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: BarcodeCoreDataHelper.ENTITY_NAME, in: context)!
    }
    
    func getManagedContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }
    
    func getTimestamp() -> Int {
        return Int(NSDate().timeIntervalSince1970)
    }
    
    func loadObjectListIfNeeded(force: Bool = false) {
        if force || (self.barcodeObjectList.isEmpty || self.barcodeValueList.isEmpty) {
            if let managedContext = getManagedContext() {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: BarcodeCoreDataHelper.ENTITY_NAME)
                do {
                    let _result = try managedContext.fetch(fetchRequest)
                    self.barcodeObjectList.removeAll()
                    self.barcodeObjectList.append(contentsOf: _result)
                    self.barcodeValueList.removeAll()
                    for object in self.barcodeObjectList {
                        self.barcodeValueList.append(object.value(forKey: "value") as! String)
                    }
                } catch let error as NSError {
                  print("BarcodeCoreDataHelper could not fetch. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    // MARK: Static functions
    static func create(opened: Bool, value: String) {
        if let managedContext = shared.getManagedContext() {
            let entity = shared.getEntity(context: managedContext)
            let barcode = NSManagedObject(entity: entity, insertInto: managedContext)
            barcode.setValue(opened, forKeyPath: "opened")
            barcode.setValue(value, forKeyPath: "value")
            barcode.setValue(shared.getTimestamp(), forKeyPath: "date")
            do {
                try managedContext.save()
                shared.barcodeObjectList.append(barcode)
                shared.barcodeValueList.append(value)
                print("BarcodeCoreDataHelper save success!!!")
            } catch let error as NSError {
                print("BarcodeCoreDataHelper could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    static func createIfNotExist(opened: Bool, value: String) {
        shared.loadObjectListIfNeeded()
        if !shared.barcodeValueList.contains(value) {
            create(opened: opened, value: value)
        } else {
            update(opened: false, updateDate: true, value: value)
        }
    }
    
    static func delete(value: String) {
        if let managedContext = shared.getManagedContext() {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: BarcodeCoreDataHelper.ENTITY_NAME)
            do {
                let _result = try managedContext.fetch(fetchRequest)
                for object in _result {
                    let rawCode = object.value(forKey: "value") as! String
                    if rawCode == value {
                        managedContext.delete(object)
                        print("BarcodeCoreDataHelper object deleting")
                        break
                    }
                }
                try managedContext.save()
                print("BarcodeCoreDataHelper delete success!!!")
            } catch let error as NSError {
              print("BarcodeCoreDataHelper could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    static func deleteAll() {
        if let managedContext = shared.getManagedContext() {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: BarcodeCoreDataHelper.ENTITY_NAME)
            do {
                let _result = try managedContext.fetch(fetchRequest)
                for object in _result {
                    managedContext.delete(object)
                }
                try managedContext.save()
                print("BarcodeCoreDataHelper delete all success!!!")
            } catch let error as NSError {
              print("BarcodeCoreDataHelper could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    static func readCodeList() -> [BarcodeModel] {
        shared.loadObjectListIfNeeded(force: true)
        var result: [BarcodeModel] = []
        for data in shared.barcodeObjectList {
            print("Test => \(data.value(forKey: "opened") as! Bool)")
            result.append(BarcodeModel.from(data: data))
        }
        return result
    }
    
    static func update(opened: Bool, updateDate: Bool, value: String) {
        if let managedContext = shared.getManagedContext() {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: BarcodeCoreDataHelper.ENTITY_NAME)
            do {
                let _result = try managedContext.fetch(fetchRequest)
                for object in _result {
                    let rawCode = object.value(forKey: "value") as! String
                    if rawCode == value {
                        object.setValue(opened, forKey: "opened")
                        if updateDate {
                            object.setValue(shared.getTimestamp(), forKeyPath: "date")
                        }
                        print("BarcodeCoreDataHelper object updating")
                        break
                    }
                }
                try managedContext.save()
                print("BarcodeCoreDataHelper update success!!!")
            } catch let error as NSError {
              print("BarcodeCoreDataHelper could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
}
