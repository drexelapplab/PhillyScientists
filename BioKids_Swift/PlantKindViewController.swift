//
//  PlantKindViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 3/10/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit

class PlantKindViewController: UIViewController {

    var observation = Observation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressGrassBtn(_ sender: Any) {
        observation.plantKind = "Grass"
    }
    
    @IBAction func didPressWeedsBtn(_ sender: Any) {
        observation.plantKind = "Weeds, Herbs, or Small Plants"
    }
    
    @IBAction func didPressVineBtn(_ sender: Any) {
        observation.plantKind = "Vine"
    }
    
    @IBAction func didPressShrubBtn(_ sender: Any) {
        observation.plantKind = "Shrub/Bush"
    }
    
    @IBAction func didPressTreeBtn(_ sender: Any) {
        observation.plantKind = "Tree"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "howMuchGrassSegue" {
            let destination = segue.destination as! HowMuchGrassViewController
            destination.observation = observation
        }
        else {
            let destination = segue.destination as! AmountSensedViewController
            destination.observation = observation
        }
    }
}
