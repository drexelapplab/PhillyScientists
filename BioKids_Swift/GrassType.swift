//
//  GrassType.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 9/26/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit

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
    @IBOutlet weak var grassTypeTable: UITableView!
    
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
        
        // Configure the cell...
        cell.grassKindLbl.textColor = UIColor(red:0.965, green:0.737, blue:0.157, alpha:1.0)
        cell.contentView.backgroundColor = UIColor.clear
        
        
        let blueRoundedView : UIView = UIView(frame: CGRect(x: 8, y: 10, width: self.view.frame.size.width-16.0, height: 100))
        blueRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.190, 0.297, 0.619, 1.0])
        blueRoundedView.layer.masksToBounds = false
        blueRoundedView.layer.cornerRadius = 10.0
        
        cell.contentView.addSubview(blueRoundedView)
        cell.contentView.sendSubview(toBack: blueRoundedView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        observation.grassKind = grassTypes[indexPath.row]
    }
    
    @IBAction func didPressCancelBtn(_ sender: Any) {
        self.showMessageToUser(title: "Alert", msg: "You are about to erase this observation. Would you like to delete this observation and return to the Home screen?")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! HowMuchGrassViewController
        destination.observation = observation
    }
}
