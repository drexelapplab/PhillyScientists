//
//  ObservationsContainer.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 3/29/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift
import SwiftyJSON
import SystemConfiguration

class ObservationContainer {
    static let sharedInstance = ObservationContainer()
    //Modifications needed;
    var observations: [Observation] = []
    var groupID: String = ""
    var groupName: String = ""
    var teacherID: String = ""
    var trackerID: String = ""
    var locations: [Location] = []
    
    let trackerNames = ["Select A Tracker", "Alem", "Aren", "Faraji", "Ghele", "Isoke", "Miniya", "Mkali", "Rakanja", "Sanjo", "Zahra"]
    let trackerImgs = ["none", "tracker-alem", "tracker-aren", "tracker-faraji", "tracker-ghele", "tracker-isoke","tracker-miniya", "tracker-mkali", "tracker-rakanja", "tracker-sanjo", "tracker-zahra"]
    // MARK: Initializer
    private init () {
        
    }
    
    // MARK: Methods
    func addObservation(observation: Observation){
        self.observations.append(observation)
    }
    
    func removeObservation(index: Int){
        self.observations.remove(at: index)
    }
    
    func removeAllObservations(){
        self.observations.removeAll()
    }
    
    func howManyNeedSubmitting() -> Int {
        var count = 0
        for observation in observations {
            if observation.wasSubmitted == false{
                count += 1
            }
        }
        return count
    }
    
    func populateObservationContainerInstance(groupCode: String, chosenTrackerString: String)->String{
        var outputMessage = ""
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available! Downloading and loading data from the server...")
            //loading json Data from Server Response
            let submissionURL = URL(string: "https://app.phillyscientists.com/verifyGroupDev.php")
            let parameters: Parameters = ["uniqueCode": groupCode, "trackerID": chosenTrackerString]
            sendAlamofireRequest(submissionURL: submissionURL!, parameters: parameters, chosenTracker: chosenTrackerString)
        }else{
            print("Internet Connection not Available! Loading data from Local Storage...")
            //loading data from UserDefaults (i.e. local storage)
            let jsonFromLocalStorage = loadJSON()
            parseJSONFromStorage(json: jsonFromLocalStorage)
            outputMessage = "Logged In. Welcome :) "
        }
        return outputMessage
    }
    
    func clearContainer() {
        groupID = ""
        groupName = ""
        teacherID = ""
        trackerID = ""
        observations = []
        locations = []
    }
    
    
    
    
    //changes by Shiv: Functionalities to login/logout from anywhere
    
   
    func parseJSONFromStorage(json : JSON) -> Void {
        self.groupID = json["groupID"].stringValue
        self.teacherID = json["teacherID"].stringValue
        self.groupName = json["groupName"].stringValue
        self.trackerID = json["trackerID"].stringValue
        //let teacher = json["teacher"].stringValue
        
        let locjson = json["Locations"].arrayValue
        for location in locjson {
            let locID = Int(location["locationID"].stringValue)
            let locName = location["locationName"].stringValue
            let locationToAdd = Location(LocationName: locName, LocationID: locID!)
            self.locations.append(locationToAdd)
            print(locID!, locName)
        }
    }
    
    func sendAlamofireRequest(submissionURL: URL, parameters: Parameters, chosenTracker: String) {
        
        Alamofire.request(submissionURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseString() { (response) in
            
            let outputResponseJSON : JSON = JSON.init(parseJSON: response.result.value!)
            let outputResponseText = JSON(outputResponseJSON)["Error"].stringValue
            
            switch response.result {
            case .success:
                print("Validation Successful...\(String(describing: response.value))")
                
                print("response value: \(String(describing: String(outputResponseText)))")
                switch outputResponseText {
                case "error_none":
                    print("No matching Group Code. If you are having trouble, please go to \nhttps://app.phillyscientists.com")
                    break
                case "error_tooManyIDs":
                    print("Error, please contact developer.")
                    break
                case "error_noGroupIDReceived":
                    print("Try Again.")
                    break
                default:
                    
                    let JSONResponse : JSON = JSON.init(parseJSON: response.result.value!)
                    
                    //uncomment this section for debugging
                    //                        print("=================<JSON RESP>=================");
                    //                        print(JSONResponse)
                    //                        print("=================</JSON RESP/>=================");
                    //
                    let teacherNameGot = self.parseJSONData(json: JSONResponse, trackerValuePassed: chosenTracker)
                    self.saveJSONDataToUserDefaults(teacher: teacherNameGot)
                    
                    print("Logged In Successfully!")
                    
                    break
                }
                
            case .failure(let error):
                print("Failure case. Maybe internet connection is not available")
            }
        }
    }
    
    func parseJSONData(json : JSON, trackerValuePassed : String) -> String {
        self.groupID = json["groupID"].stringValue
        self.teacherID = json["teacherID"].stringValue
        self.groupName = json["groupName"].stringValue
        self.trackerID = trackerValuePassed
        let teacher = json["teacher"].stringValue
        
        let locjson = json["Locations"].arrayValue
        for location in locjson {
            let locID = Int(location["locationID"].stringValue)
            let locName = location["locationName"].stringValue
            let locationToAdd = Location(LocationName: locName, LocationID: locID!)
            self.locations.append(locationToAdd)
            print(locID!, locName)
        }
        
        saveJSON(j: json)
        return teacher
    }
    
    func saveJSONDataToUserDefaults(teacher: String){
        let defaults = UserDefaults.standard
        
        defaults.set(true, forKey: "loggedIn")
        defaults.set(teacher, forKey: "teacherName")
        defaults.set(self.groupName, forKey: "groupName")
        defaults.set(self.trackerID, forKey: "trackerID")
        //defaults.set(self.groupID, forKey: "groupID")
        //defaults.set(self.trackerID, forKey: "chosenTracker")
        //defaults.set(self.teacherID, forKey: "teacherID")
    }
    
    public func loadJSON() -> JSON {
        let defaults = UserDefaults.standard
        let returnJSON = JSON.init(parseJSON: defaults.value(forKey: "serverJson") as! String)
        print(returnJSON)
        return returnJSON
        // JSON from string must be initialized using .parse()
    }

    public func saveJSON(j: JSON) {
        print("Just saved the json data to userDefaults")
        let defaults = UserDefaults.standard
        defaults.setValue(j.rawString()!, forKey: "serverJson")
        // here I save my JSON as a string
    }


    
    
    
    //this is the internet connection check function
    public class Reachability {
        
        class func isConnectedToNetwork() -> Bool {
            
            var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            
            var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
            if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
                return false
            }
            
            /* Only Working for WIFI
             let isReachable = flags == .reachable
             let needsConnection = flags == .connectionRequired
             
             return isReachable && !needsConnection
             */
            
            // Working for Cellular and WIFI
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            let ret = (isReachable && !needsConnection)
            
            return ret
            
        }
    }
}
