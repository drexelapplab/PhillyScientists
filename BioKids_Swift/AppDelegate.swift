//
//  AppDelegate.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let observationContainer = ObservationContainer.sharedInstance
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Update Realm Schemas if necessary
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    // The enumerateObjects(ofType:_:) method iterates
                    // over every Observation object stored in the Realm file
                    migration.enumerateObjects(ofType: Observation.className()) { oldObject, newObject in
                        // Add new field name
                        newObject!["wasSubmitted"] = false
                    }
                }
                if (oldSchemaVersion < 2) {
                    // The enumerateObjects(ofType:_:) method iterates
                    // over every Observation object stored in the Realm file
                    migration.enumerateObjects(ofType: Observation.className()) { oldObject, newObject in
                        // Add new field name
                        newObject!["animalType_screen"] = ""
                        newObject!["animalSubType_screen"] = ""
                    }
                }
        })
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let realm = try! Realm()
        
        let results = realm.objects(Observation.self)
        for result in results {
            observationContainer.observations.append(result)
        }
        
        // Change the font size of the Tab Bar Controller
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Montserrat", size: 18)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Montserrat", size: 18)!], for: .selected)
        
        // Then push that view controller onto the navigation stack
        if UserDefaults.standard.bool(forKey: "loggedIn"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController: UITabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

