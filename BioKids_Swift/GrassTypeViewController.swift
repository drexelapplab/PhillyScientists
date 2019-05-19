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
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var grassTypeTable: UITableView!
    
    var editMode = false
    
    override func viewDidLoad() {
        cancelBtn.layer.cornerRadius = 10
        nextBtn.layer.cornerRadius = 10
        
        nextBtn.isEnabled = false
        
        self.grassTypeTable.rowHeight = 120.0
        
        if editMode {
            nextBtn.setTitle("Save", for: .normal)
            nextBtn.isEnabled = true
            if let grassTypeIndex = grassTypes.index(of: observation.grassKind) {
                let index = grassTypes.startIndex.distance(to: grassTypeIndex)
                let indexPath = IndexPath(row: index, section: 0)
                grassTypeTable.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                grassTypeTable.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        }
    }
    
    func showMessageToUser(title: String, msg: String)  {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) { (result : UIAlertAction) -> Void in
            // Return
            print("pressed yes")
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
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
        
        let blueRoundedView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: grassTypeTable.contentSize.width, height: 100))
        blueRoundedView.layer.backgroundColor = UIColor(red: 0.190, green: 0.297, blue: 0.619, alpha: 1.0).cgColor
        

        blueRoundedView.layer.masksToBounds = false
        blueRoundedView.layer.cornerRadius = 10.0
        
        cell.contentView.addSubview(blueRoundedView)
        cell.contentView.sendSubview(toBack: blueRoundedView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !grassTypes[indexPath.row].isEmpty {
            nextBtn.isEnabled = true
        }
        
        if !editMode {
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
        if !editMode {
            performSegue(withIdentifier: "howMuchGrassSegue", sender: self)
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
        if segue.identifier == "howMuchGrassSegue" {
            let destination = segue.destination as! HowMuchGrassViewController
            destination.observation = observation
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        editMode = false
    }
}
