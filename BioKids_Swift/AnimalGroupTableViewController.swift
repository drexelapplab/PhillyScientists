//
//  AnimalGroupTableViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 3/10/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit

class AnimalGroupTableViewController: UITableViewController {

    var animalGroups = Array<String>()
    var animalTypes = Array<String>()
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
                    if let animalGroupsDict = screens["animal-group"] as? [String:Any] {
                        if let items = animalGroupsDict["items"] as? Array<[String: Any]> {
                            for item in items {
                                animalGroups.append(item["label"]! as! String)
                                animalTypes.append(item["next"]! as! String)
                            }
                        }
                    }
                }
            }
        }
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
        return animalGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalGroupCell", for: indexPath) as! AnimalGroupTableViewCell
        
        // Configure the cell...
        cell.AnimalGroupLbl.text = animalGroups[indexPath.row]
        cell.AnimalGroupLbl.textColor = UIColor(red:0.965, green:0.737, blue:0.157, alpha:1.0)
        cell.contentView.backgroundColor = UIColor.clear
        
        
        let blueRoundedView : UIView = UIView(frame: CGRect(x: 8, y: 10, width: self.view.frame.size.width-16.0, height: 100))
        blueRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.190, 0.297, 0.619, 1.0])
        blueRoundedView.layer.masksToBounds = false
        blueRoundedView.layer.cornerRadius = 10.0
        
        cell.contentView.addSubview(blueRoundedView)
        cell.contentView.sendSubview(toBack: blueRoundedView)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextScene =  segue.destination as! AnimalTypeTableViewController
        
        // Pass the selected object to the new view controller.
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let animalType = animalTypes[indexPath.row]
            observation.animalGroup = animalType
            nextScene.animalType = animalType
            nextScene.observation = observation
        }
    }
}
