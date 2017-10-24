//
//  ObservationViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 10/12/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit

class SingleObservationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var observationImgView: UIImageView!
    var observationIdx = -1
    let observationContainer = ObservationContainer.sharedInstance
    
    var propertyNames = Array<String>()
    
    @IBOutlet weak var editBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editBtn.layer.cornerRadius = 10.0
        
        if observationIdx > -1 {
            print("loading observation image")
            let observation = observationContainer.observations[observationIdx]
            let photoLocation = observation.photoLocation
            let photoURL = getDocumentsDirectory().appendingPathComponent(photoLocation)
            observationImgView.image = UIImage(contentsOfFile: photoURL.path)
            
//            let labelText = """
//            Date: \(observation.date)\n
//            How Sensed: \(observation.howSensed)\n
//            What Sensed: \(observation.whatSensed)\n
//            Kind of Plant: \(observation.plantKind)\n
//            Kind of Grass: \(observation.grassKind)\n
//            Plant amount: \(observation.howMuchPlant)\n
//            How Many: \(observation.howManySeen)\n
//            Animal Group: \(observation.animalGroup)\n
//            Animal Type: \(observation.animalType)\n
//            Animal Subtype: \(observation.animalSubType)\n
//            Notes: \(observation.note)
//            """

            propertyNames = observationContainer.observations[observationIdx].propertyNames()
        }
    }
        
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return propertyNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! ObservationEntryCell
        
        cell.entryLbl.text = propertyNames[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("edit button tapped")
            
            
            let property = self.propertyNames[(tableView.indexPathForSelectedRow?.row)!]
            
            switch property {
            case "howSensed":
                break
            case "whatSensed":
                break
            case "plantKind":
                break
            case "grassKind":
                break
            case "howMuchPlant":
                break
            case "howManySeen":
                break
            case "animalGroup":
                break
            case "animalType":
                break
            case "animalSubType":
                break
            default:
                self.performSegue(withIdentifier: "editingSegue", sender: self)
            }
            
        }
        edit.backgroundColor = .red
        
        return [edit]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editingSegue"{
            let destination = segue.destination as! SensedHowViewController
            destination.observation = self.observationContainer.observations[observationIdx]
        }
    }
}
