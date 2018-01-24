//
//  AnimalTypeViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 10/23/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AnimalTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    var animalType = String()
    var animalTypes = Array<String>()
    var animalSpecies = Array<String?>()
    var observation = Observation()
    
    var editMode = false
    
    override func viewDidLoad() {
        print("Here2:\(observation)")
        
        super.viewDidLoad()
        
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.setTitleColor(C.Colors.buttonText, for: .normal)
        cancelBtn.backgroundColor = C.Colors.buttonBg
        
        nextBtn.layer.cornerRadius = 10
        nextBtn.setTitleColor(C.Colors.buttonText, for: .normal)
        nextBtn.backgroundColor = C.Colors.buttonBg
        
        self.tableView.rowHeight = 120.0
        
        if let path = Bundle.main.path(forResource: "sequencePhilly", ofType: "plist") {
            
            animalType = observation.animalType_screen
            
            //Treat root as dictionary
            if let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
                if let screens = dict["screens"] as? [String: Any] {
                    if let animalTypesDict = screens[animalType] as? [String:Any] {
                        if let items = animalTypesDict["items"] as? Array<[String: Any]> {
                            for item in items {
                                animalTypes.append(item["label"]! as! String)
                                // ***What is this if doing here?!***
                                if let next = item["next"] {
                                    animalSpecies.append(next as? String)
                                }
                                else {
                                    animalSpecies.append(nil)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if editMode {
            nextBtn.setTitle("Save", for: .normal)
            if let animalTypeIndex = animalTypes.index(of: observation.animalType) {//Group绑定group; type绑定type
                let index = animalTypes.startIndex.distance(to: animalTypeIndex)
                let indexPath = IndexPath(row: index, section: 0)
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)//What is "scrollposition"!
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
        return animalTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalGroupCell", for: indexPath) as! AnimalGroupTableViewCell
        
        // Configure the cell...
        cell.AnimalGroupLbl.text = animalTypes[indexPath.row].capitalized
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
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !editMode{
            if animalSpecies[indexPath.row] != nil {
                observation.animalType = animalTypes[indexPath.row]
                observation.animalSubType_screen = animalSpecies[indexPath.row]!
            }
            else {
                observation.animalType = animalTypes[indexPath.row]
            }
        }
        else {
            let realm = try! Realm()
            try! realm.write {
                if animalSpecies[indexPath.row] != nil {
                    observation.animalType = animalTypes[indexPath.row]
                    observation.animalSubType_screen = animalSpecies[indexPath.row]!
                }
                else {
                    observation.animalType = animalTypes[indexPath.row]
                }
            }
        }
    }
    
    func showMessageToUser(title: String, msg: String)  {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            // Return
            print("pressed yes")
            
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
            if observation.animalSubType_screen != "" {
                performSegue(withIdentifier: "animalSpeciesSegue", sender: self)
            }
            else {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "animalSpeciesSegue" {
            let nextScene =  segue.destination as! AnimalSubtypeViewController
            
            // Pass the selected object to the new view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if animalSpecies[indexPath.row] != nil {
                    nextScene.observation = observation
                }
            }
        }
        if segue.identifier == "animalPositionSegue" {
            let nextScene = segue.destination as! AnimalPositionViewController
            nextScene.observation = observation

        }
    }
}
