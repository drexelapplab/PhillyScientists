//
//  HowMuchGrassViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 3/29/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit

class HowMuchGrassViewController: UIViewController {

    var observation = Observation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressAlmostNone(_ sender: Any) {
        observation.howMuchPlant = "Almost None"
    }
    
    @IBAction func didPressLessHalfBtn(_ sender: Any) {
        observation.howMuchPlant = "Less Than Half"
    }

    @IBAction func didPressAboutHalfBtn(_ sender: Any) {
        observation.howMuchPlant = "About Half"
    }
    
    @IBAction func didPressMoreHalfBtn(_ sender: Any) {
        observation.howMuchPlant = "More Than Half"
    }
    
    @IBAction func didPressAlmostAll(_ sender: Any) {
        observation.howMuchPlant = "Almost All"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! NotesViewController
        destination.observation = self.observation
    }

}
