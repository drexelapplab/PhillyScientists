//
//  SensedWhatController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit

class SensedWhatViewController: UIViewController {
    
    @IBOutlet weak var plantBtn: UIButton!
    @IBOutlet weak var animalBtn: UIButton!
    @IBOutlet weak var tracksBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    
    var observation = Observation()

    override func viewDidLoad() {        
        plantBtn.layer.cornerRadius = 10
        animalBtn.layer.cornerRadius = 10
        tracksBtn.layer.cornerRadius = 10
        otherBtn.layer.cornerRadius = 10
    }

    @IBAction func didPressPlantBtn(_ sender: Any) {
        observation.whatSensed = "Plant"
        
    }
    
    @IBAction func didPressLiveAnimalBtn(_ sender: Any) {
        observation.whatSensed = "Live Animal"
    }
    
    @IBAction func didPressTracksBtn(_ sender: Any) {
        observation.whatSensed = "Tracks"
    }
    
    @IBAction func didPressOtherSignsBtn(_ sender: Any) {
        observation.whatSensed = "Other Sign"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kindOfPlantSegue"{
            let destination = segue.destination as! PlantKindViewController
            destination.observation = self.observation
        }
        
        else {
            let destination = segue.destination as! AnimalGroupTableViewController
            destination.observation = self.observation
        }
    }
}
