//
//  ObservationViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 5/23/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit

class ObservationViewController: UIViewController {
    var observation = Observation()
    
    @IBOutlet weak var howSensedLbl: UILabel!
    @IBOutlet weak var whatSensedLbl: UILabel!
    @IBOutlet weak var plantKindLbl: UILabel!
    @IBOutlet weak var howManyLbl: UILabel!
    @IBOutlet weak var notesLbl: UILabel!
    @IBOutlet weak var observationImageView: UIImageView!
    @IBOutlet weak var animalGroupLbl: UILabel!
    @IBOutlet weak var animalTypeLbl: UILabel!
    
    override func viewDidLoad() {
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(observation.photoLocation)
            let image    = UIImage(contentsOfFile: imageURL.path)
            
            observationImageView.image = image
            observationImageView.contentMode = UIViewContentMode.scaleAspectFit
        }
        
        whatSensedLbl.text = "What Sensed: \(observation.whatSensed.capitalized)"
        howSensedLbl.text = "How Sensed: \(observation.howSensed.capitalized)"
        
        if observation.plantKind == "Grass" {
            plantKindLbl.text = "What kind of plant: \(observation.plantKind.capitalized) (\(observation.howMuchPlant))"
        }
        else {
            plantKindLbl.text = "What kind of plant: \(observation.plantKind.capitalized)"
        }
        
        animalGroupLbl.text = "Which animal group: \(observation.animalGroup.capitalized)"
        
        if observation.animalSubType != "" {
            animalTypeLbl.text = "Which animal type: \(observation.animalSubType.capitalized)"
        }
        else {
            animalTypeLbl.text = "Which animal type: \(observation.animalType.capitalized)"
        }
        
        if observation.howManyIsExact {
            howManyLbl.text = "How Many: \(observation.howManySeen) (Exact)"
        }
        else {
            howManyLbl.text = "How Many: \(observation.howManySeen) (Estimate)"
        }
        
        notesLbl.text = "Notes: \(observation.note)"
    }
}
