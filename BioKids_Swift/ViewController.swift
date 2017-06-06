//
//  ViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var teacherProgramLbl: UILabel!
    @IBOutlet weak var collectDataBtn: UIButton!
    @IBOutlet weak var observationTable: UITableView!
    
    var observationContainer = ObservationContainer.sharedInstance
    var observation = Observation()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let results = try! Realm().objects(Observation.self)
        
        observationContainer.observations.removeAll()
        
        for result in results {
            observationContainer.observations.append(result)
        }
        
        collectDataBtn.layer.cornerRadius = 10
    }

    override func viewWillAppear(_ animated: Bool) {
        observationTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observationContainer.observations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObservationCell", for: indexPath) as! ObservationTableViewCell
        
        // Configure the cell...
        if observationContainer.observations[indexPath.row].animalSubType != "" {
            cell.observationLabel.text = observationContainer.observations[indexPath.row].animalSubType
        }
        else {
            cell.observationLabel.text = observationContainer.observations[indexPath.row].animalType
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        observation = self.observationContainer.observations[indexPath.row]
        performSegue(withIdentifier: "ObservationSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ObservationSegue"{
            let destination = segue.destination as! ObservationViewController
            destination.observation = observation
        }
    }
}

