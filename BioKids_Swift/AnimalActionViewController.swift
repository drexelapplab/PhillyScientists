//
//  AnimalActionViewController.swift
//  BioKids_Swift
//
//  Created by keyspot on 1/10/18.
//  Copyright © 2018 App Lab. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class AnimalActionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var actionTableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    //var animalAction = String()
    var animalAction = [String]()
    var animalActions = Array<String>()
    var observation = Observation()
    
    var editMode = false
    
    
    override func viewDidLoad() {
        //print("Here5:\(observation)")

        super.viewDidLoad()
        print("Here5:\(observation)")

        cancelBtn.layer.cornerRadius = 10
        cancelBtn.setTitleColor(C.Colors.buttonText, for: .normal)
        cancelBtn.backgroundColor = C.Colors.buttonBg
        
        nextBtn.layer.cornerRadius = 10
        nextBtn.setTitleColor(C.Colors.buttonText, for: .normal)
        nextBtn.backgroundColor = C.Colors.buttonBg
        nextBtn.isEnabled = false
        
        self.actionTableView.rowHeight = 120.0
        
        if let path = Bundle.main.path(forResource: "sequencePhilly", ofType: "plist") {
            
            //Treat root as dictionary
            if let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
                if let screens = dict["screens"] as? [String: Any] {
                    if let animalSpeciesDict = screens["what-is-it-doing"] as? [String:Any] {
                        if let items = animalSpeciesDict["items"] as? Array<[String: Any]> {
                            for item in items {
                                animalActions.append(item["label"]! as! String)
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
            
            let values = observation.animalAction.split(separator: ",")
            
            for val in values{
                if let animalActionIndex = animalActions.index(of: String(val)) {
                    let index = animalActions.startIndex.distance(to: animalActionIndex)
                    let indexPath = IndexPath(row: index, section: 0)
                    actionTableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
                    actionTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                }
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
        return animalActions.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimalGroupCell", for: indexPath) as! AnimalGroupTableViewCell
        
        // Configure the cell...
        cell.AnimalGroupLbl.text = animalActions[indexPath.row].capitalized
        cell.AnimalGroupLbl.textColor = C.Colors.buttonText
        cell.contentView.backgroundColor = UIColor.clear
        
        let cellBg : UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.actionTableView.contentSize.width, height: 100))
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
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    // Problems needs to be addressed here;
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let index = animalAction.index(of: animalActions[indexPath.row]){
            animalAction.remove(at: index)
        }
        else {
            animalAction.append(animalActions[indexPath.row])
        }
        
        if animalAction.isEmpty {
            nextBtn.isEnabled = false
        }
        else {
            nextBtn.isEnabled = true
        }
//        if !animalActions[indexPath.row].isEmpty{
//            nextBtn.isEnabled = true
//        }
        
//        if !editMode{
//           observation.animalAction = animalActions[indexPath.row]
//        }else {
//            let realm = try! Realm()
//           try! realm.write {
//               observation.animalAction = animalActions[indexPath.row]
//            }
//        }
    }
    
    // Issues needs to be addressed; Segue jump issues;
    @IBAction func didPressNextBtn(_ sender: Any) {
        if !editMode {
            observation.animalAction = animalAction.joined(separator: ",")
                performSegue(withIdentifier: "amountSensedSegue4", sender: self)
        }else {
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
    
    // *** Problem needs to be resolved here;
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "amountSensedSegue4"{
            let destination = segue.destination as! AmountSensedViewController
            destination.observation = observation
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
