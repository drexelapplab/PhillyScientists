//
//  AppDelegate.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let observationContainer = ObservationContainer.sharedInstance
    var window: UIWindow?
    
//    var groupName = ""
//    var teacherID = ""
//    var groupID = ""
//    var teacher = ""
//    var locations = [Location]()
//    let trackerNames = ["Select A Tracker", "Alem", "Aren", "Faraji", "Ghele", "Isoke", "Miniya", "Mkali", "Rakanja", "Sanjo", "Zahra"]
//    let trackerImgs = ["none", "tracker-alem", "tracker-aren", "tracker-faraji", "tracker-ghele", "tracker-isoke","tracker-miniya", "tracker-mkali", "tracker-rakanja", "tracker-sanjo", "tracker-zahra"]
//
//
//    func parseJSONData(json : JSON, trackerValuePassed : String){
//        self.groupID = json["groupID"].stringValue
//        self.teacherID = json["teacherID"].stringValue
//        self.groupName = json["groupName"].stringValue
//        self.teacher = json["teacher"].stringValue
//
//
//        let locjson = json["Locations"].arrayValue
//        for location in locjson {
//            let locID = Int(location["locationID"].stringValue)
//            let locName = location["locationName"].stringValue
//            let locationToAdd = Location(LocationName: locName, LocationID: locID!)
//            self.locations.append(locationToAdd)
//            print(locID, locName)
//        }
//
//        self.observationContainer.trackerID = trackerValuePassed
//        self.observationContainer.groupID = self.groupID
//        self.observationContainer.groupName = self.groupName
//        self.observationContainer.teacherID = self.teacherID
//        self.observationContainer.locations = self.locations
//
//    }
//
//    func sendAlamofireRequest(submissionURL: URL, parameters: Parameters, chosenTracker: String){
//        Alamofire.request(submissionURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseString() {
//            response in
//            switch response.result {
//            case .success:
//                print("Validation Successful...\(String(describing: response.value))")
//
//                switch response.value {
//                case "error_none":
//                    print("No matching Group Code. If you are having trouble, please go to \nhttps://app.phillyscientists.com")
//                    break
//                case "error_tooManyIDs":
//                    print("Error, please contact developer.")
//                    break
//                case "error_noGroupIDReceived":
//                    print("Try Again.")
//                    break
//                default:
//
//                    let JSONResponse : JSON = JSON.init(parseJSON: response.result.value!)
//
//                    //uncomment this section for debugging
//                    //                        print("=================<JSON RESP>=================");
//                    //                        print(JSONResponse)
//                    //                        print("=================</JSON RESP/>=================");
//                    //
//                    self.parseJSONData(json: JSONResponse, trackerValuePassed: chosenTracker)
//                    //self.saveJSONDataToUserDefaults()
//                    //self.performSegue(withIdentifier: "groupInfoSegue", sender: self)
//                    break
//                }
//
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Update Realm Schemas if necessary
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    // The enumerateObjects(ofType:_:) method iterates
                    // over every Observation object stored in the Realm file
                    migration.enumerateObjects(ofType: Observation.className()) { oldObject, newObject in
                        // Add new field name
                        newObject!["wasSubmitted"] = false
                    }
                }// ***************Modifications with new added view controller's names; *************** // try to change < 2 to <4
                if (oldSchemaVersion < 2) {
                    // The enumerateObjects(ofType:_:) method iterates
                    // over every Observation object stored in the Realm file
                    migration.enumerateObjects(ofType: Observation.className()) { oldObject, newObject in
                        // Add new field name
                        newObject!["animalType_screen"] = ""
                        newObject!["animalSubType_screen"] = ""
                        // To modify the object passing issue with new added anim
                        //newObject!["animalPosition_screen"] = ""
                        //newObject!["animalAction_screen"] = ""
                        //newObject!["animalAmount_screen"] = " "
                    }
                }
                if (oldSchemaVersion < 3) {
                    // The enumerateObjects(ofType:_:) method iterates
                    // over every Observation object stored in the Realm file
                    migration.enumerateObjects(ofType: Observation.className()) { oldObject, newObject in
                        // Add new field name
                        newObject!["locationID"] = 0
                        // To modify the object passing issue with new added anim
                        //newObject!["animalPosition_screen"] = ""
                        //newObject!["animalAction_screen"] = ""
                        //newObject!["animalAmount_screen"] = " "
                    }
                }
        })
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let realm = try! Realm()
        
        let results = realm.objects(Observation.self)
        for result in results {
            if (result.wasSubmitted == false){
                observationContainer.observations.append(result)
            }
        }
        
        // Change the font size of the Tab Bar Controller
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Montserrat", size: 18)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Montserrat", size: 18)!], for: .selected)
        
        
        
        print("========================UserDefaults Values")
        
        
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }

        print("UserDefaults Values========================")
        

        // Then push that view controller onto the navigation stack
        if UserDefaults.standard.bool(forKey: "loggedIn"){
            print("logged in already!")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if UserDefaults.standard.string(forKey: "groupName") != nil{
                
                if UserDefaults.standard.string(forKey: "trackerID") != nil{
                    observationContainer.trackerID = UserDefaults.standard.string(forKey: "trackerID")!
                    
//                    let submissionURL = URL(string: "https://app.phillyscientists.com/verifyGroupDev.php");
//
//                    let parameters: Parameters = ["uniqueCode": observationContainer.groupID,
//                                                  "trackerID": observationContainer.trackerID
//                    ]
//                    self.sendAlamofireRequest(submissionURL: submissionURL!, parameters: parameters, chosenTracker: observationContainer.trackerID)
                    
                    
                    observationContainer.populateObservationContainerInstance(groupCode: UserDefaults.standard.string(forKey: "groupCode")!, chosenTrackerString: UserDefaults.standard.string(forKey: "trackerID")!)

                }
            }
            let viewController: UITabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        }
        else{
            print("Not logged in currently")
        }
//        else{
//            print("not logged in already!")
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            if UserDefaults.standard.string(forKey: "groupName") != nil{
//                observationContainer.groupID = UserDefaults.standard.string(forKey: "groupID")!
//
//                if UserDefaults.standard.string(forKey: "trackerID") != nil{
//                    observationContainer.trackerID = UserDefaults.standard.string(forKey: "trackerID")!
//                    observationContainer.populateObservationContainerInstance(groupCode: UserDefaults.standard.string(forKey: "groupName")!, chosenTrackerString: UserDefaults.standard.string(forKey: "trackerID")!)
//                }
//            }
//
//
//            let viewController: UITabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
//
//            window?.rootViewController = viewController
//            window?.makeKeyAndVisible()
//        }
        
        
        
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

