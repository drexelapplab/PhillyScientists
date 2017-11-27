//
//  GroupProfileViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 11/27/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit

class GroupProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{
    

    @IBOutlet weak var groupCodeLbl: UILabel!
    @IBOutlet weak var groupTrackerLbl: UILabel!
    @IBOutlet weak var groupTeacherLbl: UILabel!
    
    @IBOutlet weak var recordsTableView: UITableView!
    @IBOutlet weak var badgesCollectionView: UICollectionView!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        logoutBtn.layer.cornerRadius = 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Need Code Here
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupRecordTableCell") as! GroupRecordTableViewCell
        
        cell.titleLbl.text = "Observation Title"
        cell.recordCountLbl.text = "Record Count #"
        
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
    
    @IBAction func didPressLogoutBtn(_ sender: Any) {
        // Need Code Here
    }
}
