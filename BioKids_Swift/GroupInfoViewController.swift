//
//  GroupInfoViewController.swift
//  
//
//  Created by Brandon Morton on 11/2/17.
//

import Foundation
import UIKit

class GroupInfoViewController: UIViewController {
    
    var groupID = ""
    var groupName = ""
    var teacherID = ""
    
    @IBOutlet weak var groupCodeLbl: UILabel!
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var teacherIDLbl: UILabel!
    
    override func viewDidLoad() {
        groupCodeLbl.text = "Group ID: \(groupID)"
        groupNameLbl.text = "Group Name: \(groupName)"
        teacherIDLbl.text = "Teacher ID: \(teacherID)"
    }
}
