//
//  ObservationViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 10/12/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit

class SingleObservationViewController: UIViewController {
    
    @IBOutlet weak var observationImgView: UIImageView!
    var observationIdx = -1
    let observationContainer = ObservationContainer.sharedInstance
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var observationLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editBtn.layer.cornerRadius = 10.0
        
        if observationIdx > -1 {
            print("loading observation image")
            let observation = observationContainer.observations[observationIdx]
            let photoLocation = observation.photoLocation
            let photoURL = getDocumentsDirectory().appendingPathComponent(photoLocation)
            print(photoURL.path)
            observationImgView.image = UIImage(contentsOfFile: photoURL.path)
            
            let labelText = """
            Date: \(observation.date)\n
            How Sensed: \(observation.howSensed)\n
            What Sensed: \(observation.whatSensed)\n
            Kind of Plant: \(observation.plantKind)\n
            Kind of Grass: \(observation.grassKind)\n
            Plant amount: \(observation.howMuchPlant)\n
            How Many: \(observation.howManySeen)\n
            Animal Group: \(observation.animalGroup)\n
            Animal Type: \(observation.animalType)\n
            Animal Subtype: \(observation.animalSubType)\n
            Notes: \(observation.note)
            """
            
            observationLbl.text = labelText
        }
    }
        
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
