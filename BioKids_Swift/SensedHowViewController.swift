//
//  SensedHowViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17.
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
    
    var observation = Observation()
    var sensedHowArray = [String]()
    let realm = try! Realm()
    let observationContainer = ObservationContainer.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(observation)
        // Do any additional setup after loading the view, typically from a nib.
        
        seeBtn.layer.cornerRadius = 10
        hearBtn.layer.cornerRadius = 10
        smellBtn.layer.cornerRadius = 10
        feelBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        
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
    }
    
    @IBAction func didPressNextBtn(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "whatSensedSegue"{
            observation.howSensed = sensedHowArray.joined(separator: ",")
            let destination = segue.destination as! SensedWhatViewController
            destination.observation = self.observation
        }
    }
    
}
