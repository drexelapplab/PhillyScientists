//
//  GroupProfileViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 11/27/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit

class GroupProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{
    

    var observationContainer = ObservationContainer.sharedInstance
    
    @IBOutlet weak var groupCodeLbl: UILabel!
    @IBOutlet weak var groupTrackerLbl: UILabel!
    @IBOutlet weak var groupTeacherLbl: UILabel!
    @IBOutlet weak var viewHeadingLbl: UILabel!
//    @IBOutlet weak var recordsTableHeadingLbl: UILabel!
//    @IBOutlet weak var countsTableHeadingLbl: UILabel!
//    @IBOutlet weak var badgesTableHeadingLbl: UILabel!
    
//    @IBOutlet weak var recordsTableView: UITableView!
//    @IBOutlet weak var badgesCollectionView: UICollectionView!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let object = UserDefaults.standard.string(forKey: "groupID") {
            print(object);
            groupCodeLbl.text = "Group Code: \(String(object) ?? "Group Code not found!")"
        }

        if let object = UserDefaults.standard.string(forKey: "trackerID") {
            print(object);
            groupTrackerLbl.text = "Group Tracker:\(String(object) ?? "Teacher not found!")"
        }

        if let object = UserDefaults.standard.string(forKey: "teacherID") {
            print(object);
            groupTeacherLbl.text = "Teacher ID: \(String(object) ?? "TeacherID not found!")"
        }
        
//        groupCodeLbl.text = "Group Code: \(observationContainer.groupID)"
//        groupTrackerLbl.text = "Group Tracker: \(observationContainer.trackerID)"
//        groupTeacherLbl.text = "Teacher ID: \(observationContainer.teacherID)"
//        
        viewHeadingLbl.textColor = C.Colors.headingText
        groupCodeLbl.textColor = C.Colors.subheadingText
        groupTrackerLbl.textColor = C.Colors.subheadingText
        groupTeacherLbl.textColor = C.Colors.subheadingText
//        recordsTableHeadingLbl.textColor = C.Colors.subheadingText
//        countsTableHeadingLbl.textColor = C.Colors.subheadingText
//        badgesTableHeadingLbl.textColor = C.Colors.subheadingText
        
        logoutBtn.setTitleColor(C.Colors.buttonText, for: .normal)
        logoutBtn.backgroundColor = C.Colors.buttonBg
        
        logoutBtn.layer.cornerRadius = 10
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Need Code Here
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupRecordTableCell") as! GroupRecordTableViewCell
        
        cell.titleLbl.text = "Observation Title"
        cell.titleLbl.textColor = C.Colors.tableText
        cell.recordCountLbl.text = "Record Count #"
        cell.recordCountLbl.textColor = C.Colors.tableText
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Need Code Here
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupBadgeCell", for: indexPath) as! GroupBadgesCollectionViewCell
        return cell
    }
    
    
    func showMessageToUser(title: String, msg: String)  {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            // Return
            print("pressed yes")
            
            self.observationContainer.clearContainer()
            let domain = Bundle.main.bundleIdentifier!
            (forName: domain)
            UserDefaults.standard.synchronize()
            self.performSegue(withIdentifier: "loginSegue", sender: self)
            
        }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("pressed no")
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func didPressLogoutBtn(_ sender: Any) {
        
        if observationContainer.howManyNeedSubmitting() > 0 {
            showMessageToUser(title: "Logging Out", msg: "You have unsubmitted observations. If you logout, they will be deleted. Would you like to continue logging out?")
        }
        else {
            showMessageToUser(title: "Logging Out", msg: "You are about to logout. Do you wish to continue?")
        }
        
        
    }
}
