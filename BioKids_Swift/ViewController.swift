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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var teacherProgramLbl: UILabel!
    @IBOutlet weak var observationTable: UITableView!
    @IBOutlet weak var submitBtn: UIButton!
    
    var observationContainer = ObservationContainer.sharedInstance
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.layer.cornerRadius = 10
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
        if observationContainer.observations[indexPath.row].animalSubType != "" {
            cell.observationLabel.text = observationContainer.observations[indexPath.row].animalSubType
        }
        else {
            cell.observationLabel.text = observationContainer.observations[indexPath.row].animalType
        }
        return cell
    }
    
    @IBAction func didPressSubmitBtn(_ sender: Any) {
        
        let submissionURL = "https://biokids.soe.drexel.edu/addObservation.php"
        
        for observation in observationContainer.observations {
            
            if observation.wasSubmitted == false {
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "EST")
                dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
                
                let parameters: Parameters = ["date": dateFormatter.string(from: observation.date),
                                              "howSensed": observation.howSensed,
                                              "whatSensed": observation.whatSensed,
                                              "plantKind": observation.plantKind,
                                              "grassKind": observation.grassKind,
                                              "howMuchPlant": observation.howMuchPlant,
                                              "howManySeen": observation.howManySeen,
                                              "animalGroup":observation.animalGroup,
                                              "animalType": observation.animalType,
                                              "animalSubType": observation.animalSubType,
                                              "note": observation.note,
                                              "howManyIsExact": observation.howManyIsExact]
                
                ////////////////////
                // Send Text data //
                ////////////////////
                
                Alamofire.request(submissionURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseString() { response in
                    switch response.result {
                    case .success:
                        print("Validation Successful...\(String(describing: response.value))")
                        
                        //                        try! realm.write {
                        //                            observation.wasSubmitted = true
                        //                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }
                
                ////////////////
                // Send Photo //
                ////////////////
                
                let imageToUpload = URL(fileURLWithPath: observation.photoLocation)
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        
                        // On the PHP side you can retrive the image using $_FILES["image"]["tmp_name"]
                        multipartFormData.append(imageToUpload, withName: observation.photoLocation)
                        for (key, val) in parameters {
                            multipartFormData.append((val as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                        }
                },
                    
                    to: submissionURL,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                if let jsonResponse = response.result.value as? [String: Any] {
                                    print(jsonResponse)
                                }
                            }
                        case .failure(let encodingError):
                            print(encodingError)
                        }
                }
                )
            }
        }
    }
}

