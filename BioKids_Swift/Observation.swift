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
    dynamic var howMuchPlant = ""
    dynamic var howManySeen = 0
    dynamic var animalGroup = ""
    dynamic var animalType = ""
    dynamic var animalSubType = ""
    dynamic var note = ""
    dynamic var howManyIsExact = false
    
}

