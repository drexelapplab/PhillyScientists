//
//  GroupRecordTableViewCell.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 11/27/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit

class GroupRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var recordCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
