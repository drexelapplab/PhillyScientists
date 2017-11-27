//
//  NotesController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class NotesViewController: UIViewController, UITextViewDelegate{
    
    var observation = Observation()
    var observationContainer = ObservationContainer.sharedInstance
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var cancelBtn: UIButton!
    var initialObservation = true
    var textViewCleared = false
    
    override func viewDidLoad() {
        doneBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        
        noteTextView.delegate = self
        noteTextView.layer.borderColor = UIColor.black.cgColor
        noteTextView.layer.borderWidth = 3.0
        noteTextView.layer.cornerRadius = 10
        
        if observation.note != "" {
            noteTextView.text = observation.note
            doneBtn.setTitle("Save", for: .normal)
            initialObservation = false
        }
    }
    
    // To dismiss keyboard when view is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if !self.textViewCleared {
            textView.text = ""
            self.textViewCleared = true
        }
    }
    
    @IBAction func didPressDoneBtn(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            observation.note = noteTextView.text
            
            if initialObservation {
                observationContainer.addObservation(observation: observation)
                realm.add(observation)
            }
        }
        
        self.tabBarController?.selectedIndex = 1
        self.navigationController?.popToRootViewController(animated: false)
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
    
    @IBAction func didPressCancelBtn(_ sender: Any) {
        self.showMessageToUser(title: "Alert", msg: "You are about to erase this observation. Would you like to delete this observation and return to the Home screen?")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
