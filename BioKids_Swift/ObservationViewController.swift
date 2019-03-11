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
        
        if let object = UserDefaults.standard.string(forKey: "groupName") {
            print(object);
            groupNameLbl.text = "Group Name: \(String(object) ?? "Group Name not found!")"
        }
        else{
            print("ObservationViewController.swift: GroupName not found in userDefaults.standard")
        }
        
        if let object = UserDefaults.standard.string(forKey: "teacherName") {
            print(object);
            teacherProgramLbl.text = "Teacher Name: \(String(object) ?? "Teacher's name not found!")"
        }
        else{
            print("ObservationViewController.swift: teacherName not found in userDefaults.standard")
        }
//        else{
//            teacherProgramLbl.text = "Teacher/Program: Teacher not found!"
//
//        }
        
        let origImage = UIImage(named: "checked");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        submitBtn.setImage(tintedImage, for: [])
        submitBtn.contentMode = .center
        submitBtn.imageView?.contentMode = .scaleAspectFit
        //tintedImage.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 100.0)
        submitBtn.tintColor = UIColor.init(red: (245/255), green: (187/255), blue: (50/255), alpha: 1.0)
        submitBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
        //rgb(245, 187, 50)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        observationTable.reloadData()
        print ("Need to submit \(observationContainer.howManyNeedSubmitting()) observations")
        
        if let object = UserDefaults.standard.string(forKey: "groupName") {
            print(object);
            groupNameLbl.text = "Group Name: \(String(object) ?? "Group Name not found!")"
        }
        else{
            print("ObservationViewController.swift: GroupName not found in userDefaults.standard")
        }
        
        if let object = UserDefaults.standard.string(forKey: "teacherName") {
            print(object);
            teacherProgramLbl.text = "Teacher Name: \(String(object) ?? "Teacher's name not found!")"
        }
        else{
            print("ObservationViewController.swift: teacherName not found in userDefaults.standard")
        }
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
            if !observationContainer.isConnected() {
                AlertControllerTool.showAlert(currentVC: self, cancelBtn: "OK", meg: "You must be connected to the Internet to submit data.")
            }
            else {
                AlertControllerTool.showAlert(currentVC: self, meg: "You can't edit anything once you submit data!", cancelBtn: "cancel", otherBtn: "submit", handler: { (action) in
                 self.sumbitData()
                })
            }
        }
    }
    
    func sumbitData() {
        //PRODUCTION
        let submissionURL = "https://app.phillyscientists.com/addObservation.php"
        
        //TEST
        //let submissionURL = "https://app.phillyscientists.com/addObservationDev.php"
        
        for observation in observationContainer.observations {
            
            if observation.wasSubmitted == false {
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "EST")
                dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
                // ***********groups of data needs to be added here;!!!!!!****
                var parameters: Parameters = ["date": dateFormatter.string(from: observation.date),
                                              "photoLocation":observation.photoLocation,
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
                    "locationID": observation.locationID,
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
                    //let image = UIImage(contentsOfFile: imgFileURL.path)
                    //let data = UIImagePNGRepresentation(image!)
                    
                    Alamofire.upload(
                        multipartFormData: { multipartFormData in
                            
                            // On the PHP side you can retrive the image using $_FILES["image"]["tmp_name"]
                            
                            multipartFormData.append(imgFileURL, withName: "photo", fileName: imgFileName, mimeType: "image/png")
                            print("imagePath:")
                            print(imgFileURL)
                            multipartFormData.append(imgFileURL, withName: "photo")
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
                else {
                    print("observation.photoLocation is blank or doesn't exist -_-")
                }
                
                print(observation)
                observationContainer.removeAllObservations();
                

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
