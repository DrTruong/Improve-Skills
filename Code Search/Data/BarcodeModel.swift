//
//  BarcodeModel.swift
//  Code Search
//
//  Created by HTB95 on 21/05/2021.
//

import CoreData
import UIKit

class BarcodeModel {
    
    var date: Double = 0
    var opened: Bool = false
    var value: String = ""
    
    func compare(_ model: BarcodeModel) -> Bool {
        return self.convertDate().compare(model.convertDate()) == .orderedDescending
    }
    
    func convertDate() -> Date {
        return Date(timeIntervalSince1970: self.date)
    }
    
    static func from(data: NSManagedObject) -> BarcodeModel {
        let model = BarcodeModel()
        model.date = data.value(forKey: "date") as! Double
        model.opened = data.value(forKey: "opened") as! Bool
        model.value = data.value(forKey: "value") as! String
        return model
    }
    
}
