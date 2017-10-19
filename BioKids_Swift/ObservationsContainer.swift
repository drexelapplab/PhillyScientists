//
//  ObservationsContainer.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 3/29/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation


class ObservationContainer {
    static let sharedInstance = ObservationContainer()
    
    var observations: [Observation] = []
    
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
}
