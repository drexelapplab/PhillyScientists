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
    @IBOutlet weak var observationTableView: UITableView!
    
    var displayStrings = [String]()
    var propertyNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observationTableView.setEditing(false, animated: false)
        
        if observationIdx > -1 {
            observation = observationContainer.observations[observationIdx]
            let photoLocation = observation?.photoLocation
            let photoURL = getDocumentsDirectory().appendingPathComponent(photoLocation!)
            observationImgView.image = UIImage(contentsOfFile: photoURL.path)

            // TODO: Change this be returned by a function in the observation container
            
            propertyNames = observationContainer.observations[observationIdx].getPropertyNames()            
            displayStrings = (observation?.getDisplayStrings())!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        observationTableView.setEditing(false, animated: false)
        displayStrings = (observation?.getDisplayStrings())!
        self.observationTableView.reloadData()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! ObservationEntryCell
        
        cell.entryLbl.text = displayStrings[indexPath.row]
        
        return cell
    }
    //****modified*****
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in

            let property = self.propertyNames[editActionsForRowAt.row]
            // Codes needs to be modified here; add new kinds of cases to demo the viewcontroller!!
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
            // Codes modified here; for animal position and animal action;** Variable name undetermined;
            case "animalPosition":
                self.performSegue(withIdentifier: "animalPositionSegue", sender: self)
                break
            // Codes modified here; for animal action and animal action;** Variable name undetermined;
            case "animalAction":
                self.performSegue(withIdentifier: "animalActionSegue", sender: self)
                break
            case "note":
                self.performSegue(withIdentifier: "noteSegue", sender: self)
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
    //****modified*****
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segueType = segue.identifier {
            // Codes needs to be modified here; add new kinds of cases to demo the viewcontroller!!
            switch segueType {
            case "howSensedSegue":
                let destination = segue.destination as! SensedHowViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "whatSensedSegue":
                let destination = segue.destination as! SensedWhatViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "plantKindSegue":
                let destination = segue.destination as! PlantKindViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "grassKindSegue":
                let destination = segue.destination as! GrassTypeViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "howMuchPlantSegue":
                let destination = segue.destination as! HowMuchGrassViewController
                destination.observation = self.observation!
                 destination.editMode = true
                break
            case "howManySeenSegue":
                let destination = segue.destination as! AmountSensedViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "animalGroupSegue":
                let destination = segue.destination as! AnimalGroupViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "animalTypeSegue":
                let destination = segue.destination as! AnimalTypeViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "animalSubTypeSegue":
                let destination = segue.destination as! AnimalSubtypeViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            // AnimalPositionTableViewController is added here;
            case "animalPositionSegue":
                let destination = segue.destination as! AnimalPositionViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            // AnimalActionTableViewController is added here;
            case "animalActionSegue":
                let destination = segue.destination as! AnimalActionViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            case "noteSegue":
                let destination = segue.destination as! NotesViewController
                destination.observation = self.observation!
                destination.editMode = true
                break
            default:
                break
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.popToRootViewController(animated: false)
    }
}
