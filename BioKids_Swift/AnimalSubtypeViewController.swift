//
//  AnimalSubtypeViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 10/23/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AnimalSubtypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var animalSubType = String()
    var animalSubTypes = Array<String>()
    var animalPosition = Array<String>()//New addded, next pointer;
    var observation = Observation()
    
    var editMode = false
    
    override func viewDidLoad() {
        print("AnimalSubTypeView:\(observation)")

        super.viewDidLoad()
        //print("AnimalSubTypeView:\(observation)")
        
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.setTitleColor(C.Colors.buttonText, for: .normal)
        cancelBtn.backgroundColor = C.Colors.buttonBg
        
        nextBtn.layer.cornerRadius = 10
        nextBtn.setTitleColor(C.Colors.buttonText, for: .normal)
        nextBtn.backgroundColor = C.Colors.buttonBg
        nextBtn.isEnabled = false
        
        self.tableView.rowHeight = 120.0
        
        if let path = Bundle.main.path(forResource: "sequencePhilly", ofType: "plist") {
            
            animalSubType = observation.animalSubType_screen
            
            //Treat root as dictionary
            if let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
                if let screens = dict["screens"] as? [String: Any] {
                    if let animalSpeciesDict = screens[animalSubType] as? [String:Any] {
                        if let items = animalSpeciesDict["items"] as? Array<[String: Any]> {
                            for item in items {
                                animalSubTypes.append(item["label"]! as! String)
                            }
                        }
                    }
                }
            }
        }
        
        if editMode {
            nextBtn.setTitle("Save", for: .normal)
            nextBtn.isEnabled = true
            
            if let animalSubTypeIndex = animalSubTypes.index(of: observation.animalSubType) {
                let index = animalSubTypes.startIndex.distance(to: animalSubTypeIndex)
                let indexPath = IndexPath(row: index, section: 0)
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return animalSubTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalGroupCell", for: indexPath) as! AnimalGroupTableViewCell
        
        // Configure the cell...
        cell.AnimalGroupLbl.text = animalSubTypes[indexPath.row].capitalized
        cell.AnimalGroupLbl.textColor = C.Colors.buttonText
        cell.contentView.backgroundColor = UIColor.clear
        
        
        let cellBg : UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.contentSize.width, height: 100))
        cellBg.layer.backgroundColor = C.Colors.buttonBg.cgColor
        cellBg.layer.masksToBounds = false
        cellBg.layer.cornerRadius = 10.0
        
        cell.contentView.addSubview(cellBg)
        cell.contentView.sendSubview(toBack: cellBg)
        
        return cell
    }
    
    func showMessageToUser(title: String, msg: String)  {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in

        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !editMode{
            
            if !animalSubTypes[indexPath.row].isEmpty {
                nextBtn.isEnabled = true
            }
            
            if !animalSubTypes[indexPath.row].isEmpty {
                observation.animalSubType = animalSubTypes[indexPath.row]
                observation.animalPosition_screen = animalSubTypes[indexPath.row]
            }
            else {
                observation.animalSubType = animalSubTypes[indexPath.row]
            }
            
        }
        else {
            let realm = try! Realm()
            try! realm.write {
                if !animalSubTypes[indexPath.row].isEmpty {
                    observation.animalSubType = animalSubTypes[indexPath.row]
                    observation.animalPosition_screen = animalSubTypes[indexPath.row]
                }
                else {
                    observation.animalSubType = animalSubTypes[indexPath.row]
                }
            }
        }
    }
    
    @IBAction func didPressNextBtn(_ sender: Any) {
        if !editMode {
            if observation.animalSubType != "" {
                performSegue(withIdentifier: "animalPositionSegue", sender: self)
            }
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
    //Codes modified here;
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "animalPositionSegue" {
            let nextScene = segue.destination as! AnimalPositionViewController
            nextScene.observation = observation
        }
    }
}
