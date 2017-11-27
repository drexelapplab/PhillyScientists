//
//  GrassType.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 9/26/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class GrassTypeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let grassTypes = ["Annual Bluegrass",
                      "Kentucky Bluegrass",
                      "Orchard Grass",
                      "Perennial Ryegrass",
                      "Yellow Foxtail",
                      "Green Foxtail",
                      "Timothy",
                      "Cheatgrass",
                      "Barnyard Grass"]
    
    var observation = Observation()
    var initialObservation = true
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var grassTypeTable: UITableView!
    
    override func viewDidLoad() {
        cancelBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        
        if observation.grassKind != "" {
            nextBtn.setTitle("Save", for: .normal)
            initialObservation = false
            let index = grassTypes.startIndex.distance(to: grassTypes.index(of: observation.grassKind)!)
            let indexPath = IndexPath(row: index, section: 0)
            grassTypeTable.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            grassTypeTable.scrollToRow(at: indexPath, at: .middle, animated: true)
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

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return grassTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GrassKindCell", for: indexPath) as! GrassKindTableViewCell
        
        // Configure the cell...
        cell.grassKindLbl.text = grassTypes[indexPath.row]
        cell.grassKindLbl.textColor = UIColor(red:0.965, green:0.737, blue:0.157, alpha:1.0)
        cell.contentView.backgroundColor = UIColor.clear
        
        let blueRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: grassTypeTable.contentSize.width, height: 71))
        blueRoundedView.layer.backgroundColor = UIColor(red: 0.190, green: 0.297, blue: 0.619, alpha: 1.0).cgColor
        
        blueRoundedView.layer.masksToBounds = false
        blueRoundedView.layer.cornerRadius = 10.0
        
        cell.contentView.addSubview(blueRoundedView)
        cell.contentView.sendSubview(toBack: blueRoundedView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if initialObservation {
            observation.grassKind = grassTypes[indexPath.row]
        }
        else {
            let realm = try! Realm()
            try! realm.write {
                observation.grassKind = grassTypes[indexPath.row]
            }
        }
    }
    
    
    @IBAction func didPressNextBtn(_ sender: Any) {
        if initialObservation {
            performSegue(withIdentifier: "howMuchGrassSegue", sender: self)
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
        if segue.identifier == "howMuchGrassSegue" {
            let destination = segue.destination as! HowMuchGrassViewController
            destination.observation = observation
        }
    }
}
