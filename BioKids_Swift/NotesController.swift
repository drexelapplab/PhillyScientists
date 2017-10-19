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
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        doneBtn.layer.cornerRadius = 10
        noteTextView.delegate = self
    }
    
    @IBAction func didPressDoneBtn(_ sender: Any) {
        observation.note = noteTextView.text
        observationContainer.addObservation(observation: observation)
        
        try! realm.write {
            realm.add(observation)
        }
     
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
