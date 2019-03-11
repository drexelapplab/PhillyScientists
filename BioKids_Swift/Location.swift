//
//  Location.swift
//  BioKids_Swift
//
//  Created by Shivansh Suhane on 6/5/18.
//  Copyright © 2018 App Lab. All rights reserved.
//

import Foundation

class Location{
    var locationName: String?
    var locationID: Int?
    
    init(LocationName: String, LocationID:Int){
        self.locationID=LocationID
        self.locationName=LocationName
    }
    
}
