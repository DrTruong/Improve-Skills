//
//  AppDelegate.swift
//  Code Search
//
//  Created by Kis User on 4/26/21.
//

import CoreData
import UIKit

@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BarcodeCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("AppDelegate: Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    // MARK: Functions
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainstoryboard.instantiateViewController(withIdentifier: "MainViewController")
        window.rootViewController = viewController
        return true
    }

}

