//
//  AmountSensedController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit

class AmountSensedViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var segmentBtn: UISegmentedControl!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    var observation = Observation()
    
    override func viewDidLoad() {
        // Do something
        doneBtn.layer.cornerRadius = 10 
        amountField.delegate = self
        segmentBtn.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Montserrat-Regular", size: 38.0)! ], for: .normal)
        
        print(observation)
        
    }
    
    @IBAction func didStartEnteringAmount(_ sender: Any) {
        amountField.text = ""
    }
    
    @IBAction func didPressSegmentBtn(_ sender: Any) {
        observation.howManyIsExact = (segmentBtn.selectedSegmentIndex == 0)
        print(observation)
    }
    
    @IBAction func didChangeHowManyField(_ sender: Any) {
        observation.howManySeen = Int(amountField.text!)!
        print(observation)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! NotesViewController
        destination.observation = self.observation
    }
}
