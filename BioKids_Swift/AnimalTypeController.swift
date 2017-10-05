//
//  AnimalTypeController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit

class AnimalTypeTableViewController: UITableViewController {
    
    var animalType = String()
    var animalTypes = Array<String>()
    var animalSpecies = Array<String?>()
    var observation = Observation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(observation)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.rowHeight = 120.0
        
        if let path = Bundle.main.path(forResource: "sequencePhilly", ofType: "plist") {
            
            //Treat root as dictionary
            if let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
                if let screens = dict["screens"] as? [String: Any] {
                    if let animalTypesDict = screens[animalType] as? [String:Any] {
                        if let items = animalTypesDict["items"] as? Array<[String: Any]> {
                            for item in items {
                                animalTypes.append(item["label"]! as! String)
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
        print(animalTypes)
        print(animalSpecies)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return animalTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalGroupCell", for: indexPath) as! AnimalGroupTableViewCell
        
        // Configure the cell...
        cell.AnimalGroupLbl.text = animalTypes[indexPath.row]
        cell.AnimalGroupLbl.textColor = Constants.Colors.buttonTextColor
        cell.contentView.backgroundColor = UIColor.clear
        
        
        let blueRoundedView : UIView = UIView(frame: CGRect(x: 8, y: 10, width: self.view.frame.size.width-16.0, height: 100))
        blueRoundedView.layer.backgroundColor = Constants.Colors.buttonBGColor.cgColor
        blueRoundedView.layer.masksToBounds = false
        blueRoundedView.layer.cornerRadius = 10.0
        
        cell.contentView.addSubview(blueRoundedView)
        cell.contentView.sendSubview(toBack: blueRoundedView)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if animalSpecies[indexPath.row] != nil {
            performSegue(withIdentifier: "animalSpeciesSegue", sender: nil)
        }
        else {
            performSegue(withIdentifier: "howManySegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "animalSpeciesSegue" {
            let nextScene =  segue.destination as! AnimalSpeciesTableViewController
            
            // Pass the selected object to the new view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if animalSpecies[indexPath.row] != nil {
                    observation.animalType = animalTypes[indexPath.row]
                    nextScene.animalSpecies = animalSpecies[indexPath.row]!
                    nextScene.observation = observation
                    
                }
            }
        }
        else {
            let nextScene = segue.destination as! AmountSensedViewController
            if let indexPath = self.tableView.indexPathForSelectedRow{
                observation.animalType = animalTypes[indexPath.row]
                nextScene.observation = observation
            }
        }
    }
}
