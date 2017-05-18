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
        
        print(observation)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! NotesViewController
        destination.observation = self.observation
    }

}
