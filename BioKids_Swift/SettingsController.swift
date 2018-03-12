//
//  SettingsController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 1/9/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class SettingsController: UIViewController, UITextFieldDelegate {
    
    //Defined a constant that holds the URL for our web service
    
    
    //View variables
    
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cancelBtn.layer.cornerRadius = 10
        registerBtn.layer.cornerRadius = 10
    }
    
    @IBAction func didPressRegisterBtn(_ sender: UIButton) {
        
        //creating parameters for the post request
        let parameters: Parameters=[
            "username":textFieldUsername.text!,
            "password":textFieldPassword.text!,
            "name":textFieldName.text!,
            "email":textFieldEmail.text!,
            "phone":textFieldPhone.text!
        ]
        
        //Sending http post request
        
        let URL_USER_REGISTER = "https://app.phillyscientists.com/SimplifiediOS/v1/register.php"
        
        Alamofire.request(URL_USER_REGISTER, method: .post, parameters: parameters).responseJSON {
            response in
            //printing response
            print(response)
            
            //getting the json value from the server
            if let result = response.result.value {
                
                //converting it as NSDictionary
                let jsonData = result as! NSDictionary
                
                //displaying the message in label
                self.labelMessage.text = jsonData.value(forKey: "message") as! String?
                
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
    }
    
    // To dismiss keyboard when view is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            textFieldUsername.resignFirstResponder()
            textFieldPassword.resignFirstResponder()
            textFieldName.resignFirstResponder()
            textFieldEmail.resignFirstResponder()
            textFieldPhone.resignFirstResponder()
            return false
        }
        return true
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
