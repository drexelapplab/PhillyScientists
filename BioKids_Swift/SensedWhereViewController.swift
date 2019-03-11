//
//  SensedWhereViewController.swift
//  BioKids_Swift
//
//  Created by Shivansh Suhane on 6/21/18.
//  Copyright © 2018 App Lab. All rights reserved.
//

import UIKit

class SensedWhereViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var observationContainer = ObservationContainer.sharedInstance
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var locationPicker: UIPickerView!
    
    var observation = Observation()
    var editMode = false

    override func viewDidLoad() {
        
        print("Here at SensedWhereViewController: ",observation)
        
        
        cancelBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        
        
        locationPicker.dataSource = self //(observationContainer.locations[0].locationID as! UIPickerViewDataSource)
        locationPicker.delegate = self
        
        if editMode {
            nextBtn.setTitle("Save", for: .normal)
            
            locationPicker.dataSource = self //(observationContainer.locations as! UIPickerViewDataSource)             //THROWING ERRORRORROR
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return observationContainer.locations[row].locationName
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return observationContainer.locations.count;
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print("The chosen location is: ")
        print(observationContainer.locations[row].locationName!)
        print("The location ID is: ")
        observation.locationID = observationContainer.locations[row].locationID!
        print(observation.locationID)
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
    
    @IBAction func didPressNextBtn(_ sender: Any) {
        if !editMode {
            if observation.locationID < 1 {
                observation.locationID = observationContainer.locations[0].locationID!
            }
            performSegue(withIdentifier: "notesSegue", sender: self)
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
        if segue.identifier == "notesSegue"{
            
            let destination = segue.destination as! NotesViewController
            destination.observation = self.observation
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
