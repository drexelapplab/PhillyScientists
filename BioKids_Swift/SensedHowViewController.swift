//
//  SensedHowViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17.
//  Edited by Shiv on 8/31/18
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class SensedHowViewController: UIViewController {
    
    @IBOutlet weak var seeBtn: UIButton!
    @IBOutlet weak var hearBtn: UIButton!
    @IBOutlet weak var smellBtn: UIButton!
    @IBOutlet weak var feelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var chosenSegue:String?
    var observation = Observation()
    var sensedHowArray = [String]()
    let observationContainer = ObservationContainer.sharedInstance
    var editMode = false
    
    override func viewDidLoad() {
        print(chosenSegue)
        print("In sensedHowViewController,", observation)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        seeBtn.layer.cornerRadius = 10
        hearBtn.layer.cornerRadius = 10
        smellBtn.layer.cornerRadius = 10
        feelBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        
        nextBtn.isEnabled = false
        
        //***This line of codes fixes the second time add object flash out problem!!*****
        //observation = Observation()           //this line reinstantiates the object -_- meaning that the information saved until here is lost -_-
        
        if editMode {
            nextBtn.setTitle("Save", for: .normal)
            nextBtn.isEnabled = true
            
            let values = observation.howSensed.split(separator: ",")
            
            for val in values{
                switch val {
                case "see":
                    seeBtn.isSelected = true
                    sensedHowArray.append("see")
                case"hear":
                    hearBtn.isSelected = true
                    sensedHowArray.append("hear")
                case "smell":
                    smellBtn.isSelected = true
                    sensedHowArray.append("smell")
                case "feel":
                    feelBtn.isSelected = true
                    sensedHowArray.append("feel")
                default:
                    break
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didPressSeeBtn(_ sender: Any) {
        if let index = sensedHowArray.index(of: "see") {
            sensedHowArray.remove(at: index)
            seeBtn.isSelected = false
        }
        else {
            sensedHowArray.append("see")
            seeBtn.isSelected = true
        }
        toggleNextBtn(sensed: sensedHowArray)
        
    }
    
    @IBAction func didPressHearBtn(_ sender: Any) {
        if let index = sensedHowArray.index(of: "hear") {
            sensedHowArray.remove(at: index)
            hearBtn.isSelected = false
        }
        else {
            sensedHowArray.append("hear")
            hearBtn.isSelected = true
        }
        
        toggleNextBtn(sensed: sensedHowArray)
    }
    
    @IBAction func didPressSmellBtn(_ sender: Any) {
        if let index = sensedHowArray.index(of: "smell") {
            sensedHowArray.remove(at: index)
            smellBtn.isSelected = false
        }
        else {
            sensedHowArray.append("smell")
            smellBtn.isSelected = true
        }
        toggleNextBtn(sensed: sensedHowArray)
    }
    
    @IBAction func didPressFeelBtn(_ sender: Any) {
        if let index = sensedHowArray.index(of: "feel") {
            sensedHowArray.remove(at: index)
            feelBtn.isSelected = false
        }
        else {
            sensedHowArray.append("feel")
            feelBtn.isSelected = true
        }
        toggleNextBtn(sensed: sensedHowArray)
    }
    
    func toggleNextBtn(sensed:[String]) {
        if sensed.isEmpty {
            nextBtn.isEnabled = false
        }
        else {
            nextBtn.isEnabled = true
        }
    }
    
    func showMessageToUser(title: String, msg: String)  {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) { (result : UIAlertAction) -> Void in
            // Return
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            print("pressed no")
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressCancelBtn(_ sender: Any) {
        
        if !editMode {
            self.showMessageToUser(title: "Alert", msg: C.Strings.observationCancel)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func didPressNextBtn(_ sender: Any) {
        if !editMode {
            if chosenSegue == "kindOfPlantSegue"{
                performSegue(withIdentifier: "kindOfPlantSegue", sender: self)
                print("testing: Inside didPresNextButton of sensedHowViewController", self.observation)
            }
            else
            {
                performSegue(withIdentifier: "kindOfAnimalSegue", sender: self)
            }
            
        } else {
            let realm = try! Realm()
            try! realm.write {
                observation.howSensed = sensedHowArray.joined(separator: ",")
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if !editMode {
            if segue.identifier == "kindOfPlantSegue"{
                observation.howSensed = sensedHowArray.joined(separator: ",")
                let destination = segue.destination as! PlantKindViewController
                destination.observation = self.observation
            }
                
            else {
                observation.howSensed = sensedHowArray.joined(separator: ",")
                let destination = segue.destination as! AnimalGroupViewController
                destination.observation = self.observation
            }
        }
        else {
            editMode = false
        }
    }
}
