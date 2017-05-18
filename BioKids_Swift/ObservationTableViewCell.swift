//
//  ObservationTableViewCell.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 4/11/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit

class ObservationTableViewCell: UITableViewCell {

    @IBOutlet weak var observationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
