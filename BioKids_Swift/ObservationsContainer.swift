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

class ObservationContainer {
    static let sharedInstance = ObservationContainer()
    //Modifications needed;
    var observations: [Observation] = []
    var groupID: String = ""
    var groupName: String = ""
    var teacherID: String = ""
    var trackerID: String = ""
    var locations: [Location] = []
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
    
    func clearContainer() {
        groupID = ""
        groupName = ""
        teacherID = ""
        trackerID = ""
        observations = []
        locations = []
    }
}
