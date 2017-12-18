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
    dynamic var date = Date()
    dynamic var photoLocation = ""
    dynamic var howSensed = ""
    dynamic var whatSensed = ""
    dynamic var plantKind = ""
    dynamic var grassKind = ""
    dynamic var howMuchPlant = ""
    dynamic var howManySeen = 0
    dynamic var animalGroup = ""
    dynamic var animalType = ""
    dynamic var animalSubType = ""
    dynamic var note = ""
    dynamic var howManyIsExact = false
    dynamic var wasSubmitted = false
    dynamic var animalType_screen = ""
    dynamic var animalSubType_screen = ""
    
    func getDisplayStrings() -> [String] {
        var displayStrings = [String]()
        
        displayStrings.append("Date: \(date)")
        displayStrings.append("How it was sensed: \(howSensed.capitalized)")
        displayStrings.append("What was sensed: \(whatSensed.capitalized)")
        displayStrings.append("What kind of plant: \(plantKind.capitalized)")
        displayStrings.append("What kind of grass: \(grassKind.capitalized)")
        displayStrings.append("Amount of grass: \(howMuchPlant)")
        displayStrings.append("Animal group: \(animalGroup.capitalized)")
        displayStrings.append("Animal type: \(animalType.capitalized)")
        displayStrings.append("Animal subtype: \(animalSubType.capitalized)")
        
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
                             "howManySeen",
                             "notes"]
        
        return propertyNames
    }
}
