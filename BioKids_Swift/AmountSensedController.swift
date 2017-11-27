//
//  AmountSensedController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AmountSensedViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var segmentBtn: UISegmentedControl!
    @IBOutlet weak var amountField: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var observation = Observation()
    var initialObservation = true
    
    
    
    override func viewDidLoad() {
        // Do something
        nextBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        
        amountField.delegate = self
        segmentBtn.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 48.0)! ], for: .normal)
        
        print(observation)
        
        if observation.howManySeen != 0 {
            initialObservation = false
            nextBtn.setTitle("Save", for: .normal)
        
            amountField.text = "\(observation.howManySeen)"
            segmentBtn.selectedSegmentIndex = observation.howManyIsExact ? 1 : 0
        }
    }
    
    @IBAction func didStartEnteringAmount(_ sender: Any) {
        amountField.text = ""
    }
    
    @IBAction func didPressSegmentBtn(_ sender: Any) {
        if initialObservation {
            observation.howManyIsExact = (segmentBtn.selectedSegmentIndex == 0)
        }
        else {
            let realm = try! Realm()
            try! realm.write{
                observation.howManyIsExact = (segmentBtn.selectedSegmentIndex == 0)
            }
        }
    }
    
    @IBAction func didChangeHowManyField(_ sender: Any) {
        if initialObservation {
            observation.howManySeen = Int(amountField.text!)!
        }
        else {
            let realm = try! Realm()
            try! realm.write{
                observation.howManySeen = Int(amountField.text!)!
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
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
        if initialObservation {
            performSegue(withIdentifier: "notesSegue", sender: self)
        }
        else {
            self.navigationController?.popViewController(animated: true)
        }
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
        if segue.identifier == "notesSegue" {
            let destination = segue.destination as! NotesViewController
            destination.observation = self.observation
        }
    }
}
