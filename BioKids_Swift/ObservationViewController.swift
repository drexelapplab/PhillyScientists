//
//  ViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class ObservationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var teacherProgramLbl: UILabel!
    @IBOutlet weak var observationTable: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var statusLbl: UILabel!
    
    var observationContainer = ObservationContainer.sharedInstance
    var observationIdx = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.layer.cornerRadius = 10
        
        groupNameLbl.text = "Group Name: \(observationContainer.groupName)"
        teacherProgramLbl.text = "Teacher/Program: \(observationContainer.teacherID)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        observationTable.reloadData()
        print ("Need to submit \(observationContainer.howManyNeedSubmitting()) observations")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observationContainer.observations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ObservationCell", for: indexPath) as! ObservationTableViewCell
        
        // Configure the cell...
        // ***********groups of data needs to be added here;!!!!!!****
        var labelText = ""
        
        if observationContainer.observations[indexPath.row].grassKind != "" {
            labelText = observationContainer.observations[indexPath.row].grassKind
        }
        else if observationContainer.observations[indexPath.row].plantKind != ""{
           labelText = observationContainer.observations[indexPath.row].plantKind
        }
        else if observationContainer.observations[indexPath.row].animalSubType != "" {
           labelText = observationContainer.observations[indexPath.row].animalSubType
        }
        else if observationContainer.observations[indexPath.row].animalType != "" {
           labelText = observationContainer.observations[indexPath.row].animalType
        } // Codes modification for consistency with newly added data; this is for Position;
        else if observationContainer.observations[indexPath.row].animalPosition != ""{
            labelText = observationContainer.observations[indexPath.row].animalPosition
        }// Codes modification for consistency with newly added data; this is for Action;
        else if observationContainer.observations[indexPath.row].animalAction != ""{
            labelText = observationContainer.observations[indexPath.row].animalAction
        }
        else {
            labelText = observationContainer.observations[indexPath.row].animalGroup
        }
        
        if !observationContainer.observations[indexPath.row].wasSubmitted {
            labelText = labelText + " *"
        }
        
        cell.observationLabel.text = labelText
        
        return cell
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func didPressSubmitBtn(_ sender: Any) {
        
        
        let numSubmitting = observationContainer.howManyNeedSubmitting()
        print(numSubmitting)
        
        if numSubmitting < 1 {
            statusLbl.text = "No new observations to submit."
        } else {
// Submit button
//            AlertControllerTool.showAlert(currentVC: self, msg: "You can't edit anything once you submit data! ", otherBtn: "submit", otherHandler: { (action) in
//                // Submit data to server;
//                self.sumbitData()
//            })
            // Two buttons, deal with one event
            AlertControllerTool.showAlert(currentVC: self, meg: "You can't edit anything once you submit data!", cancelBtn: "cancel", otherBtn: "submit", handler: { (action) in
                 self.sumbitData()
            })
        }
    }
    
    func sumbitData() {
        let submissionURL = "https://app.phillyscientists.com/addObservation.php"
        
        for observation in observationContainer.observations {
            
            if observation.wasSubmitted == false {
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "EST")
                dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
                // ***********groups of data needs to be added here;!!!!!!****
                var parameters: Parameters = ["date": dateFormatter.string(from: observation.date),
                                              "howSensed": observation.howSensed,
                                              "whatSensed": observation.whatSensed,
                                              "plantKind": observation.plantKind,
                                              "grassKind": observation.grassKind,
                                              "howMuchPlant": observation.howMuchPlant,
                                              "howManySeen": observation.howManySeen,
                                              "animalGroup":observation.animalGroup,
                                              "animalType": observation.animalType,
                                              "animalSubType": observation.animalSubType,
                                              "animalPosition": observation.animalPosition,//Codes modification for consistency;
                    "animalAction": observation.animalAction,//Codes modification for consistency
                    "note": observation.note,
                    "howManyIsExact": observation.howManyIsExact ? 1 : 0]
                
                if observationContainer.groupID != "" {
                    parameters["groupID"] = observationContainer.groupID
                }
                
                ////////////////////
                // Send Text data //
                ////////////////////
                
                Alamofire.request(submissionURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseString() { response in
                    switch response.result {
                    case .success:
                        print("Validation Successful...\(String(describing: response.value))")
                        
                        let realm = try! Realm()
                        try! realm.write {
                            observation.wasSubmitted = true
                            self.observationTable.reloadData()
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                
                ////////////////
                // Send Photo //
                ////////////////
                
                if observation.photoLocation != "" {
                    let imgFileName = observation.photoLocation
                    let imgFileURL = getDocumentsDirectory().appendingPathComponent(imgFileName)
                    
                    Alamofire.upload(
                        multipartFormData: { multipartFormData in
                            
                            // On the PHP side you can retrive the image using $_FILES["image"]["tmp_name"]
                            
                            multipartFormData.append(imgFileURL, withName: "photo", fileName: imgFileName, mimeType: "image/png")
                    },
                        
                        to: submissionURL,
                        encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseString {response in
                                    print(response)
                                    
                                }
                            case .failure(let encodingError):
                                print("Failure...")
                                print(encodingError)
                            }
                    }
                    )
                    
                    print("Photo Uploaded")
                }
                
                for observation in observationContainer.observations{
                    var count = 0;
                    if(observation.wasSubmitted == true&&count<observationContainer.observations.count){
                        observationContainer.removeObservation(index: count)
                        count += 1
                        print ("Removed observation");
                    }
                }

            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        statusLbl.text = ""
    }
    //********* Very important for segue jumping!!!!!***********
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextScene = segue.destination as! SingleObservationViewController
        
        if let indexPath = self.observationTable.indexPathForSelectedRow{
            observationIdx = indexPath.row
            nextScene.observationIdx = observationIdx
        }
    }
}
