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
    var editMode = false
    
    override func viewDidLoad() {
        // Do something
       // nextBtn.isEnabled = false
        nextBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        
        amountField.delegate = self
        
        segmentBtn.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 48.0)! ], for: .normal)
        
        if editMode {
            nextBtn.setTitle("Save", for: .normal)
        
            amountField.text = "\(observation.howManySeen)"
            segmentBtn.selectedSegmentIndex = observation.howManyIsExact ? 1 : 0
        }
    }
    
    @IBAction func didStartEnteringAmount(_ sender: Any) {
        amountField.text = ""
    }
    
    @IBAction func didPressSegmentBtn(_ sender: Any) {
        if !editMode {
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
        if !editMode {
            if amountField.text != nil {
                observation.howManySeen = Int(amountField.text!)!
            }
        }
        else {
            let realm = try! Realm()
            try! realm.write{
                observation.howManySeen = Int(amountField.text!)!
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let inverseSet = NSCharacterSet(charactersIn:".0123456789").inverted
        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        
        if let _ = Int(string) {
            nextBtn.isEnabled = true
        }
        return string == filtered && true
        
        //return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        //or
        //self.view.endEditing(true)
        return true
    }
    
    func showMessageToUser(title: String, msg: String)  {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) { (result : UIAlertAction) -> Void in
            // Return
            print("pressed yes")
            
            self.observation = Observation()
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            print("pressed no")
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressNextBtn(_ sender: Any) {
        if !editMode {
            performSegue(withIdentifier: "locationSegue", sender: self)
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
        if segue.identifier == "locationSegue" {
            let destination = segue.destination as! SensedWhereViewController
            destination.observation = self.observation
        }
    }
    
}
