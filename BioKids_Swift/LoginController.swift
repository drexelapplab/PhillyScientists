//
//  LoginController.swift
//  BioKids_Swift
//
//  Created by Yashwanth Dahanayake on 7/19/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit
import Alamofire

class LoginController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var observationContainer = ObservationContainer.sharedInstance
    @IBOutlet weak var checkInBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var trackerPicker: UIPickerView!
    
    var groupName = ""
    var teacherID = ""
    var groupID = ""
    let trackerNames = ["Select A Tracker", "Alem", "Aren", "Faraji", "Ghele", "Isoke", "Miniya", "Mkali", "Rakanja", "Sanjo", "Zahra"]
    let trackerImgs = ["none", "tracker-alem", "tracker-aren", "tracker-faraji", "tracker-ghele", "tracker-isoke","tracker-miniya", "tracker-mkali", "tracker-rakanja", "tracker-sanjo", "tracker-zahra"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLbl.adjustsFontSizeToFitWidth = true
        checkInBtn.layer.cornerRadius = 10
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
                                          "trackerID": self.trackerNames[chosenTracker]]
            
            ////////////////////
            // Send Text data //
            ////////////////////
            
            let submissionURL = "https://app.phillyscientists.com/verifyGroup.php"
            
            Alamofire.request(submissionURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseString() { response in
                switch response.result {
                case .success:
                    print("Validation Successful...\(String(describing: response.value))")

                    switch response.value {
                    case "error_none"?:
                        self.statusLbl.text = "No matching Group Code."
                        break
                    case "error_tooManyIDs"?:
                        self.statusLbl.text = "Error, please contact developer."
                        break
                    case "error_noGroupIDReceived"?:
                        self.statusLbl.text = "Try Again."
                        break
                    default:
                        let val = response.value?.split(separator: ",")
                        self.groupID = String(val![0])
                        self.groupName = String(val![1])
                        self.teacherID = String(val![2])
                        
                        self.observationContainer.groupID = self.groupID
                        self.observationContainer.groupName = self.groupName
                        self.observationContainer.teacherID = self.teacherID
                        self.observationContainer.trackerID = self.trackerNames[chosenTracker]
                        
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
            pickerLabel.text = trackerNames[row]
            
            pickerView.addSubview(pickerLabel)
            pickerView.addSubview(pickerImgView)
            
            return pickerView
            
        }
        else {
            let pickerView = UILabel(frame: CGRect(x: 0, y:0, width: 150, height: 50))
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
