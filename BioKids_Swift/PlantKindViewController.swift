//
//  PlantKindViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 3/10/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit
import RealmSwift

class PlantKindViewController: UIViewController {
    
    var observation = Observation()
    @IBOutlet weak var grassBtn: UIButton!
    @IBOutlet weak var weedBtn: UIButton!
    @IBOutlet weak var vineBtn: UIButton!
    @IBOutlet weak var shrubBtn: UIButton!
    @IBOutlet weak var treeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var initialObservation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(observation)
        // Do any additional setup after loading the view.
        
        grassBtn.layer.cornerRadius = 10
        weedBtn.layer.cornerRadius = 10
        vineBtn.layer.cornerRadius = 10
        shrubBtn.layer.cornerRadius = 10
        treeBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        
        if observation.plantKind != "" {
            initialObservation = false
            nextBtn.setTitle("Save", for: .normal)
            
            switch observation.whatSensed {
            case "Grass":
                grassBtn.isSelected = true
                break
            case"Weeds, Herbs, or Small Plants":
                weedBtn.isSelected = true
                break
            case "Vine":
                vineBtn.isSelected = true
                break
            case "Shrub/Bush":
                shrubBtn.isSelected = true
                break
            case "Tree":
                treeBtn.isSelected = true
                break
            default:
                break
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressGrassBtn(_ sender: Any) {
        grassBtn.isSelected = true
        weedBtn.isSelected = false
        vineBtn.isSelected = false
        shrubBtn.isSelected = false
        treeBtn.isSelected = false
        
        if !initialObservation {
            let realm = try! Realm()
            try! realm.write {
                observation.plantKind = "Grass"
            }
        }
        else {
            observation.plantKind = "Grass"
        }
    }

    @IBAction func didPressWeedBtn(_ sender: Any) {
        grassBtn.isSelected = false
        weedBtn.isSelected = true
        vineBtn.isSelected = false
        shrubBtn.isSelected = false
        treeBtn.isSelected = false
        
        if !initialObservation {
            let realm = try! Realm()
            try! realm.write {
                observation.plantKind = "Weeds, Herbs, or Small Plants"
            }
        }
        else {
            observation.plantKind = "Weeds, Herbs, or Small Plants"
        }
    }
    
    @IBAction func didPressVineBtn(_ sender: Any) {
        grassBtn.isSelected = false
        weedBtn.isSelected = false
        vineBtn.isSelected = true
        shrubBtn.isSelected = false
        treeBtn.isSelected = false
        
        if !initialObservation {
            
            let realm = try! Realm()
            try! realm.write {
                observation.plantKind = "Vine"
            }
        }
        else {
            observation.plantKind = "Vine"
        }
    }
    
    @IBAction func didPressShrubBtn(_ sender: Any) {
        grassBtn.isSelected = false
        weedBtn.isSelected = false
        vineBtn.isSelected = false
        shrubBtn.isSelected = true
        treeBtn.isSelected = false
        
        if !initialObservation {
            let realm = try! Realm()
            try! realm.write {
                observation.plantKind = "Shrub/Bush"
            }
        }
        else {
            observation.plantKind = "Shrub/Bush"
        }
    }
    
    @IBAction func didPressTree(_ sender: Any) {
        grassBtn.isSelected = false
        weedBtn.isSelected = false
        vineBtn.isSelected = false
        shrubBtn.isSelected = false
        treeBtn.isSelected = true
        
        if !initialObservation {
            let realm = try! Realm()
            try! realm.write {
                observation.plantKind = "Tree"
            }
        }
        else {
            observation.plantKind = "Tree"
        }
    }
    
    @IBAction func didPressNextBtn(_ sender: Any) {
        if initialObservation {
            if grassBtn.isSelected {
                performSegue(withIdentifier: "kindOfGrassSegue", sender: self)
            }
            else {
                performSegue(withIdentifier: "howManySegue", sender: self)
            }
        }
        else {
            self.navigationController?.popViewController(animated: true)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "kindOfGrassSegue" {
            let destination = segue.destination as! GrassTypeViewController
            destination.observation = observation
        }
        else {
            let destination = segue.destination as! AmountSensedViewController
            destination.observation = observation
        }
    }
}
