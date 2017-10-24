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
    var observation: Observation?
    
    var propertyNames = Array<String>()
    
    @IBOutlet weak var editBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editBtn.layer.cornerRadius = 10.0
        
        if observationIdx > -1 {
            print("loading observation image")
            observation = observationContainer.observations[observationIdx]
            let photoLocation = observation?.photoLocation
            let photoURL = getDocumentsDirectory().appendingPathComponent(photoLocation!)
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
            propertyNames.remove(at: propertyNames.index(where: {$0 == "photoLocation"})!)
            propertyNames.remove(at: propertyNames.index(where: {$0 == "howManyIsExact"})!)
            propertyNames.remove(at: propertyNames.index(where: {$0 == "wasSubmitted"})!)}
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
        
        let propertyName = propertyNames[indexPath.row]
        
        switch propertyName {
            case "howSensed":
                cell.entryLbl.text = propertyName + ": \(observation!.howSensed)"
                break
            case "whatSensed":
                cell.entryLbl.text = propertyName + ": \(observation!.whatSensed)"
                break
            case "plantKind":
                cell.entryLbl.text = propertyName + ": \(observation!.plantKind)"
                break
            case "grassKind":
                cell.entryLbl.text = propertyName + ": \(observation!.grassKind)"
                break
            case "howMuchPlant":
                cell.entryLbl.text = propertyName + ": \(observation!.howMuchPlant)"
                break
            case "howManySeen":
                cell.entryLbl.text = propertyName + ": \(observation!.howManySeen)"
                break
            case "animalGroup":
                cell.entryLbl.text = propertyName + ": \(observation!.animalGroup)"
                break
            case "animalType":
                cell.entryLbl.text = propertyName + ": \(observation!.animalType)"
                break
            case "animalSubType":
                cell.entryLbl.text = propertyName + ": \(observation!.animalSubType)"
                break
            case "date":
                cell.entryLbl.text = propertyName + ": \(observation!.date)"
                break
            default:
                break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("edit button tapped")

            let property = self.propertyNames[editActionsForRowAt.row]
            
            switch property {
            case "howSensed":
                self.performSegue(withIdentifier: "howSensedSegue", sender: self)
                break
            case "whatSensed":
                self.performSegue(withIdentifier: "whatSensedSegue", sender: self)
                break
            case "plantKind":
                self.performSegue(withIdentifier: "plantKindSegue", sender: self)
                break
            case "grassKind":
                self.performSegue(withIdentifier: "grassKindSegue", sender: self)
                break
            case "howMuchPlant":
                self.performSegue(withIdentifier: "howMuchPlantSegue", sender: self)
                break
            case "howManySeen":
                self.performSegue(withIdentifier: "howManySeenSegue", sender: self)
                break
            case "animalGroup":
                self.performSegue(withIdentifier: "animalGroupSegue", sender: self)
                break
            case "animalType":
                self.performSegue(withIdentifier: "animalTypeSegue", sender: self)
                break
            case "animalSubType":
                self.performSegue(withIdentifier: "animalSubTypeSegue", sender: self)
                break
            default:
                break
            }
            
        }
        edit.backgroundColor = .red
        
        return [edit]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueType = segue.identifier {
            switch segueType {
            case "howSensedSegue":
                let destination = segue.destination as! SensedHowViewController
                destination.observation = self.observation!
                break
            case "whatSensesSegue":
                let destination = segue.destination as! SensedWhatViewController
                destination.observation = self.observation!
                break
            case "plantKindSegue":
                let destination = segue.destination as! PlantKindViewController
                destination.observation = self.observation!
                break
            case "grassKindSegue":
                let destination = segue.destination as! GrassTypeViewController
                destination.observation = self.observation!
                break
            case "howMuchPlantSegue":
                let destination = segue.destination as! HowMuchGrassViewController
                destination.observation = self.observation!
                break
            case "howManySeenSegue":
                let destination = segue.destination as! AmountSensedViewController
                destination.observation = self.observation!
                break
            case "animalGroupSegue":
                let destination = segue.destination as! AnimalGroupViewController
                destination.observation = self.observation!
                break
            case "animalTypeSegue":
                let destination = segue.destination as! AnimalTypeViewController
                destination.observation = self.observation!
                break
            case "animalSubTypeSegue":
                let destination = segue.destination as! AnimalSpeciesViewController
                destination.observation = self.observation!
                break
            default:
                break
            }
        }
    }
}
