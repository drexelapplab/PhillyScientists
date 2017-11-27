//
//  SensedWhatController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SensedWhatViewController: UIViewController {
    
    @IBOutlet weak var plantBtn: UIButton!
    @IBOutlet weak var animalBtn: UIButton!
    @IBOutlet weak var tracksBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var observation = Observation()
    var initialObservation = true
    
    override func viewDidLoad() {
        
        print(observation)
        
        plantBtn.layer.cornerRadius = 10
        animalBtn.layer.cornerRadius = 10
        tracksBtn.layer.cornerRadius = 10
        otherBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        
        if observation.whatSensed != "" {
            
            initialObservation = false
            cancelBtn.setTitle("Save", for: .normal)
            
            switch observation.whatSensed {
            case "Live Animal":
                animalBtn.isSelected = true
                break
            case"Plant":
                plantBtn.isSelected = true
                break
            case "Tracks":
                tracksBtn.isSelected = true
                break
            case "Other Signs":
                otherBtn.isSelected = true
                break
            default:
                break
            }
        }
        
    }
    
    @IBAction func didPressPlantBtn(_ sender: Any) {
        
        plantBtn.isSelected = true
        animalBtn.isSelected = false
        tracksBtn.isSelected = false
        otherBtn.isSelected = false
        
        if !initialObservation {
            let realm = try! Realm()
            try! realm.write {
                observation.whatSensed = "Plant"
            }
        }
        else {
            observation.whatSensed = "Plant"
        }
    }
    
    @IBAction func didPressLiveAnimalBtn(_ sender: Any) {
        plantBtn.isSelected = false
        animalBtn.isSelected = true
        tracksBtn.isSelected = false
        otherBtn.isSelected = false
        
        if !initialObservation {
            let realm = try! Realm()
            try! realm.write {
                observation.whatSensed = "Live Animal"
            }
        }
        else {
            observation.whatSensed = "Live Animal"
        }
    }
    
    @IBAction func didPressTracksBtn(_ sender: Any) {
        
        plantBtn.isSelected = false
        animalBtn.isSelected = false
        tracksBtn.isSelected = true
        otherBtn.isSelected = false
        
        if !initialObservation {
            let realm = try! Realm()
            try! realm.write {
                observation.whatSensed = "Tracks"
            }
        }
        else {
            observation.whatSensed = "Tracks"
        }
    }
    
    @IBAction func didPressOtherSignsBtn(_ sender: Any) {
        
        plantBtn.isSelected = false
        animalBtn.isSelected = false
        tracksBtn.isSelected = false
        otherBtn.isSelected = true
        
        if !initialObservation {
            let realm = try! Realm()
            try! realm.write {
                observation.whatSensed = "Other Sign"
            }
        }
        else {
            observation.whatSensed = "Other Sign"
        }
    }
    
    func showMessageToUser(title: String, msg: String)  {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            // Return
            print("pressed yes")
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("pressed no")
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressCancelBtn(_ sender: Any) {
        if initialObservation {
            self.showMessageToUser(title: "Alert", msg: "You are about to erase this observation. Would you like to delete this observation and return to the Home screen?")
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func didPressNextBtn(_ sender: Any) {
        if initialObservation {
            if plantBtn.isSelected {
                performSegue(withIdentifier: "kindOfPlantSegue", sender: self)
            }
            else {
                performSegue(withIdentifier: "kindOfAnimalSegue", sender: self)
            }
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "kindOfPlantSegue"{
            let destination = segue.destination as! PlantKindViewController
            destination.observation = self.observation
        }
            
        else {
            let destination = segue.destination as! AnimalGroupViewController
            destination.observation = self.observation
        }
    }
}
