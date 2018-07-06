//
//  LoginController.swift
//  BioKids_Swift
//
//  Created by Yashwanth Dahanayake on 7/19/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class LoginController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var observationContainer = ObservationContainer.sharedInstance
    @IBOutlet weak var checkInBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var statusLbl: UITextView!
    @IBOutlet weak var trackerPicker: UIPickerView!
    @IBOutlet weak var trackerPickerLbl: UILabel!
    
    var groupName = ""
    var teacherID = ""
    var groupID = ""
    var teacher = ""
    var locations = [Location]()
    let trackerNames = ["Select A Tracker", "Alem", "Aren", "Faraji", "Ghele", "Isoke", "Miniya", "Mkali", "Rakanja", "Sanjo", "Zahra"]
    let trackerImgs = ["none", "tracker-alem", "tracker-aren", "tracker-faraji", "tracker-ghele", "tracker-isoke","tracker-miniya", "tracker-mkali", "tracker-rakanja", "tracker-sanjo", "tracker-zahra"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        titleLbl.adjustsFontSizeToFitWidth = true
        
        checkInBtn.layer.cornerRadius = 10
        
        titleLbl.textColor = C.Colors.headingText
        groupTextField.textColor = C.Colors.normalText
        trackerPickerLbl.textColor = C.Colors.subheadingText
        checkInBtn.setTitleColor(C.Colors.buttonText, for: .normal)
        checkInBtn.backgroundColor = C.Colors.buttonBg
        
        checkInBtn.setTitleColor(C.Colors.buttonText, for: .normal)
        checkInBtn.backgroundColor = C.Colors.buttonBg
        
    }
    
    @IBAction func didPressCheckInBtn(_ sender: Any) {
        if groupTextField.text == "" {
            statusLbl.text = "Please Enter A Group Code"
        }
            
        else if trackerPicker.selectedRow(inComponent: 0) == 0 {
            statusLbl.text = "Please select a tracker"
        }
            
        else {
            
            statusLbl.text = ""
            
            let groupCode = groupTextField.text!
            let chosenTracker = self.trackerPicker.selectedRow(inComponent: 0)
            
            // Verify that it is a valid group ID
            let parameters: Parameters = ["uniqueCode": groupCode,
                                          "trackerID": self.trackerNames[chosenTracker]
            ]
            
            ////////////////////
            // Send Text data //
            ////////////////////
            
            let submissionURL = "https://app.phillyscientists.com/verifyGroupDev.php"
            
            Alamofire.request(submissionURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseString() {
                response in
                switch response.result {
                case .success:
                    print("Validation Successful...\(String(describing: response.value))")
                    
                    switch response.value {
                    case "error_none":
                        self.statusLbl.text = "No matching Group Code. If you are having trouble, please go to \nhttps://app.phillyscientists.com"
                        break
                    case "error_tooManyIDs":
                        self.statusLbl.text = "Error, please contact developer."
                        break
                    case "error_noGroupIDReceived":
                        self.statusLbl.text = "Try Again."
                        break
                    default:
//
//
//                        let val = response.value?.split(separator: ",")
//                        self.groupID = String(val![0])
//                        self.groupName = String(val![1])
//                        self.teacherID = String(val![2])
//
//                        let locjson = String(val![3])
//
//                        print("=================<JSON RESP>=================");
//                        print(val)
//                        print("=================</JSON RESP/>=================");
//
//                        print("=================<LOCJSON>=================");
//                        print(locjson)
//                        print("=================</LOCJSON/>=================");
                        
                        let json = JSON(response.result.value ?? "error")
                        //let jsonError = json["Error"]
                        print("=================<JSON RESPONSE>=================");
                        print(json)
                        print("=================</JSON RESPONSE/>=================");

                        self.groupID = json["groupID"].stringValue
                        self.groupName = json["groupName"].stringValue
                        self.teacherID = json["teacherID"].stringValue
                        let locjson = json["Locations"].arrayValue


                        print("Entering LocJSON Loop")
                        print("=================<LOCJSON >=================");
                        print("GNAME:" +  self.groupID)
                        print("TID: " + json["teacherID"].stringValue)

                        //print("LocationJSON" + json["Locations"]);
                        print("=================</LOCJSON/>=================");
                        
                        for location in locjson {
                            print("In LocJSON Loop")
                            let locID:Int? = Int(location["locationID"].stringValue);
                            let locName = location["locationName"].stringValue;
                            print(locID, locName);
                            
                            var locationToAdd : Location
                            locationToAdd = Location();
                            locationToAdd.locationID = locID!;
                            locationToAdd.locationName = locName;
                            self.locations.append(locationToAdd);
                        }

//                        for (key, object) in locjson {
//                            print("In LocJSON Loop")
//                            let locationIDVar: Int? = Int(key)
//                            self.locations[locationIDVar!].locationID = locationIDVar!
//                            self.locations[locationIDVar!].locationName = object.stringValue
//                            print(self.locations[locationIDVar!].locationName)
//                            print(object);
//                        }

                        self.observationContainer.groupID = self.groupID
                        self.observationContainer.groupName = self.groupName
                        self.observationContainer.teacherID = self.teacherID
                        self.observationContainer.trackerID = self.trackerNames[chosenTracker]
                        self.observationContainer.locations = self.locations
                        
                        UserDefaults.standard.set(true, forKey: "loggedIn")
                        self.performSegue(withIdentifier: "groupInfoSegue", sender: self)
                        
                        break
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return trackerNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return trackerNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if row != 0 {
            let pickerView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
            
            let pickerImg = UIImage(named: trackerImgs[row])
            let pickerImgView = UIImageView(image: pickerImg)
            pickerImgView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            
            let pickerLabel = UILabel(frame: CGRect(x: 60, y:0, width: 60, height: 50))
            pickerLabel.textColor = C.Colors.tableText
            pickerLabel.text = trackerNames[row]
            
            pickerView.addSubview(pickerLabel)
            pickerView.addSubview(pickerImgView)
            
            return pickerView
            
        }
        else {
            let pickerView = UILabel(frame: CGRect(x: 0, y:0, width: 150, height: 50))
            pickerView.textColor = C.Colors.tableText
            pickerView.text = trackerNames[row]
            pickerView.textAlignment = .center
            return pickerView
        }
    }
    
    // To dismiss keyboard when view is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            groupTextField.resignFirstResponder()
            return false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

