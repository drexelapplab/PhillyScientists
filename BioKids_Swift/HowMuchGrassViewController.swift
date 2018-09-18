//
//  HowMuchGrassViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 3/29/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit
import RealmSwift

class HowMuchGrassViewController: UIViewController {
    
    var observation = Observation()
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var almostNoneBtn: UIButton!
    @IBOutlet weak var lessThanHalfBtn: UIButton!
    @IBOutlet weak var aboutHalfBtn: UIButton!
    @IBOutlet weak var moreThanHalfBtn: UIButton!
    @IBOutlet weak var almostAllBtn: UIButton!
    
    var editMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(observation)
        
        // Do any additional setup after loading the view.
        cancelBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        almostNoneBtn.layer.cornerRadius = 10
        lessThanHalfBtn.layer.cornerRadius = 10
        aboutHalfBtn.layer.cornerRadius = 10
        moreThanHalfBtn.layer.cornerRadius = 10
        almostAllBtn.layer.cornerRadius = 10
        
        if editMode {
            nextBtn.setTitle("Save", for: .normal)
            
            switch observation.whatSensed {
            case "Almost None":
                almostNoneBtn.isSelected = true
                break
            case"Less Than Half":
                lessThanHalfBtn.isSelected = true
                break
            case "About Half":
                aboutHalfBtn.isSelected = true
                break
            case "More Than Half":
                moreThanHalfBtn.isSelected = true
                break
            case "Almost All":
                almostAllBtn.isSelected = true
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
    
    func showMessageToUser(title: String, msg: String)  {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            // Return
            print("pressed yes")
            
            self.observation = Observation()
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("pressed no")
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func didPressAlmostNoneBtn(_ sender: Any) {
        
        almostNoneBtn.isSelected = true
        lessThanHalfBtn.isSelected = false
        aboutHalfBtn.isSelected = false
        moreThanHalfBtn.isSelected = false
        almostAllBtn.isSelected = false
        
        if !editMode{
            observation.howMuchPlant = "Almost None"
        }
        else {
            let realm = try! Realm()
            try! realm.write {
                observation.howMuchPlant = "Almost None"
            }   
        }
    }
    
    @IBAction func didPressLessThanHalfBtn(_ sender: Any) {
        almostNoneBtn.isSelected = false
        lessThanHalfBtn.isSelected = true
        aboutHalfBtn.isSelected = false
        moreThanHalfBtn.isSelected = false
        almostAllBtn.isSelected = false
        
        if !editMode{
            observation.howMuchPlant = "Less Than Half"
        }
        else {
            let realm = try! Realm()
            try! realm.write {
                observation.howMuchPlant = "Less Than Half"
            }
        }
    }
    
    @IBAction func didPressAboutHalfBtn(_ sender: Any) {
        almostNoneBtn.isSelected = false
        lessThanHalfBtn.isSelected = false
        aboutHalfBtn.isSelected = true
        moreThanHalfBtn.isSelected = false
        almostAllBtn.isSelected = false
        
        if !editMode{
            observation.howMuchPlant = "About Half"
        }
        else {
            let realm = try! Realm()
            try! realm.write {
                observation.howMuchPlant = "About Half"
            }
        }
    }
    
    @IBAction func didPressMoreThanHalfBtn(_ sender: Any) {
        almostNoneBtn.isSelected = false
        lessThanHalfBtn.isSelected = false
        aboutHalfBtn.isSelected = false
        moreThanHalfBtn.isSelected = true
        almostAllBtn.isSelected = false
        
        if !editMode{
            observation.howMuchPlant = "More Than Half"
        }
        else {
            let realm = try! Realm()
            try! realm.write {
                observation.howMuchPlant = "More Than Half"
            }
        }
    }
    
    @IBAction func didPressAlmostAllBtn(_ sender: Any) {
        almostNoneBtn.isSelected = false
        lessThanHalfBtn.isSelected = false
        aboutHalfBtn.isSelected = false
        moreThanHalfBtn.isSelected = false
        almostAllBtn.isSelected = true
        
        if !editMode{
            observation.howMuchPlant = "Almost All"
        }
        else {
            let realm = try! Realm()
            try! realm.write {
                observation.howMuchPlant = "Almost All"
            }
        }
    }
    
    @IBAction func didPressNextBtn(_ sender: Any) {
        if !editMode{
            performSegue(withIdentifier: "locationsSegue", sender: self)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didPressCancelBtn(_ sender: Any) {
        if !editMode {
            self.showMessageToUser(title: "Alert", msg: C.Strings.observationCancel)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !editMode {
            if segue.identifier == "locationsSegue" {
                let destination = segue.destination as! SensedWhereViewController
                destination.observation = self.observation
            }
        }
    }
}
