//
//  Observation.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 3/29/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import RealmSwift

class Observation: Object {
    
    // MARK: Properties
    @objc dynamic var date = Date()
    @objc dynamic var photoLocation = ""
    @objc dynamic var howSensed = ""
    @objc dynamic var whatSensed = ""
    @objc dynamic var plantKind = ""
    @objc dynamic var grassKind = ""
    @objc dynamic var howMuchPlant = ""
    @objc dynamic var howManySeen = 0
    @objc dynamic var animalGroup = ""
    @objc dynamic var animalType = ""
    @objc dynamic var animalSubType = ""
    @objc dynamic var animalPosition = "" //New added; the value passing issue needs to be resolved
    @objc dynamic var animalAction = ""// New added; the value passing issue needs to be resolved
    @objc dynamic var note = ""
    @objc dynamic var howManyIsExact = false
    @objc dynamic var wasSubmitted = false
    @objc dynamic var animalType_screen = ""
    @objc dynamic var animalSubType_screen = ""
    // To modify the newly added objects and comform with the AppDelegte.swift;
    @objc dynamic var animalPosition_screen = ""
    @objc dynamic var animalAction_screen = ""
    @objc dynamic var animalAmount_screen = ""
    @objc dynamic var locationID = 0 //// New added by Shiv
    
    func getDisplayStrings() -> [String] {
        var displayStrings = [String]()
        let df = DateFormatter()
        df.dateFormat = "MM-dd-yyyy"
        displayStrings.append("Date: \(df.string(from: date))")
        displayStrings.append("How it was sensed: \(howSensed.capitalized)")
        displayStrings.append("What was sensed: \(whatSensed.capitalized)")
        displayStrings.append("What kind of plant: \(plantKind.capitalized)")
        displayStrings.append("What kind of grass: \(grassKind.capitalized)")
        displayStrings.append("Amount of grass: \(howMuchPlant)")
        displayStrings.append("Animal group: \(animalGroup.capitalized)")
        displayStrings.append("Animal type: \(animalType.capitalized)")
        displayStrings.append("Animal subtype: \(animalSubType.capitalized)")
        displayStrings.append("Animal position: \(animalPosition.capitalized)") //New added; make it consistant with above variables
        displayStrings.append("Animal action: \(animalAction.capitalized)") //New added; make it consistant with above variables
        
        if howManySeen > 0 {
            if howManyIsExact {
                displayStrings.append("How many were seen: \(howManySeen) (Exact)")
            }
            else {
                displayStrings.append("How many were seen: \(howManySeen) (Estimate)")
            }
        }
        else {
            displayStrings.append("How many were seen: ")
        }
        
        displayStrings.append("Location: \(locationID)")
        displayStrings.append("Note: \(note)")

        return displayStrings
    }
    
    func getPropertyNames() -> [String] {
        let propertyNames = ["date",
                             "howSensed",
                             "whatSensed",
                             "plantKind",
                             "grassKind",
                             "howMuchPlant",
                             "animalGroup",
                             "animalType",
                             "animalSubType",
                             "animalPosition", //New added;
                             "animalAction", //New added
                             "howManySeen",
                             "location", //new added Shiv
                             "notes"]
        
        return propertyNames
    }
}
