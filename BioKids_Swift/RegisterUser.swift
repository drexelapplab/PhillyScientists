//
//  RegisterUser.swift
//  BioKids_Swift
//
//  Created by Joseph Baran on 10/20/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit

class RegisterUser: UIViewController {
    @IBOutlet weak var GroupName: UIPickerView!
    @IBOutlet weak var GroupPicture: UIPickerView!
    
    //placeholder data
    let pickerData = ["alpha", "bravo", "charlie", "delta"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //GroupName.dataSource = self
        //GroupName.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   

}
