//
//  AnimalPositionViewController.swift
//  BioKids_Swift
//
//  Created by keyspot on 1/10/18.
//  Copyright © 2018 App Lab. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AnimalPositionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var positionTableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    // Pay attention to the conversion from String to Array<String>
    var animalPosition = Array<String>()
    var animalPositionsArray = Array<String>()
    var observation = Observation()
    
    var editMode = false

    override func viewDidLoad() {
        print("AnimalPositionView:\(observation)")

        super.viewDidLoad()
        //print ("AnimalPositionView: \(observation)")
        
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.setTitleColor(C.Colors.buttonText, for: .normal)
        cancelBtn.backgroundColor = C.Colors.buttonBg
        
        nextBtn.layer.cornerRadius = 10
        nextBtn.setTitleColor(C.Colors.buttonText, for: .normal)
        nextBtn.backgroundColor = C.Colors.buttonBg
        nextBtn.isEnabled = false
        
        self.positionTableView.rowHeight = 120.0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let path = Bundle.main.path(forResource: "sequencePhilly", ofType: "plist") {
            //animalPosition = observation.animalPosition_screen
            
            //Treat root as dictionary
            if let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
                if let screens = dict["screens"] as? [String: Any] {
                    if let animalPositionsDict = screens["where-is-it"] as? [String:Any] {
                        if let items = animalPositionsDict["items"] as? Array<[String: Any]> {
                            for item in items {
                                animalPositionsArray.append(item["label"]! as! String)
                                //animalPosition.append(item["next"]! as! String)
                            }
                        }
                    }
                }
            }
        }
        
        // Modifications needed;
        if editMode {
            nextBtn.setTitle("Save", for: .normal)
            nextBtn.isEnabled = true
            
            if let animalPositionIndex = animalPositionsArray.index(of: observation.animalPosition) {
                let index = animalPositionsArray.startIndex.distance(to: animalPositionIndex)
                let indexPath = IndexPath(row: index, section: 0)
                positionTableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
                positionTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animalPositionsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalGroupCell", for: indexPath)
            as! AnimalGroupTableViewCell
        // Configure the cell...
        cell.AnimalGroupLbl.text = animalPositionsArray[indexPath.row].capitalized
        cell.AnimalGroupLbl.textColor = C.Colors.buttonText
        cell.contentView.backgroundColor = UIColor.clear
        
        
        let cellBg : UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.positionTableView.contentSize.width, height: 100))
        cellBg.layer.backgroundColor = C.Colors.buttonBg.cgColor
        cellBg.layer.masksToBounds = false
        cellBg.layer.cornerRadius = 10.0
        
        
        cell.contentView.addSubview(cellBg)
        cell.contentView.sendSubview(toBack: cellBg)
        
        return cell
    }
    
    func showMessageToUser(title: String, msg: String)  {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) { (result : UIAlertAction) -> Void in
            // Return
            print("pressed yes")
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !animalPositionsArray[indexPath.row].isEmpty {
            nextBtn.isEnabled = true
        }
        
        if !editMode{
            observation.animalPosition = animalPositionsArray[indexPath.row]
           // observation.animalPosition_screen = animalPosition[indexPath.row]
        }
        else {
            let realm = try! Realm()
            try! realm.write {
                observation.animalPosition = animalPositionsArray[indexPath.row]
            // observation.animalPosition_screen = animalPosition[indexPath.row]
            }
        }
    }
    
    // *** Problem needs to be resolved here;
    @IBAction func didPressNextBtn(_ sender: Any) {
        if !editMode {
            if observation.animalPosition != "" {
                performSegue(withIdentifier:"animalActionSegue", sender:self)
            }
        }else {
            self.navigationController?.popViewController(animated:true)
        }
    }
    
    @IBAction func didPressCancelBtn(_ sender: Any) {
        if !editMode {
            self.showMessageToUser(title: "Alert", msg: C.Strings.observationCancel)
        }else{
            self.navigationController?.popViewController(animated:true)
        }
    }
    
    // *** Problem needs to be resolved here;
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "animalActionSegue" {
            let nextScene = segue.destination as! AnimalActionViewController
            nextScene.observation = observation
            //Pass the selected object to the new view controller**
            //  if let indexPath = self.tableView.indexPathForSelectedRow {
            //  }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
