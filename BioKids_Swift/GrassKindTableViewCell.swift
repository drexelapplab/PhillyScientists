//
//  GrassKindTableViewCell.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 9/26/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit

class GrassKindTableViewCell: UITableViewCell {
    
    @IBOutlet weak var grassKindLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
