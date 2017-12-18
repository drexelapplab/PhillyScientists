//
//  Constants.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 11/29/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import Foundation
import UIKit

struct C {
    struct Colors {
        
        static let primaryColor = UIColor(red: 49.0/255.0,    // For primary color (blue)
                                          green: 76.0/255.0,
                                          blue: 158.0/255.0,
                                          alpha: 1.0)
        
        static let secondaryColor = UIColor(red: 93.0/255.0,       // For secondary color (green)
                                            green: 182.0/255.0,
                                            blue: 76.0/255.0,
                                            alpha: 1.0)
        
        static let accentColor = UIColor(red: 245.0/255.0,       // For accent color (yellow)
                                         green: 187.0/255.0,
                                         blue: 50.0/255.0,
                                         alpha: 1.0)
        
        static let headingText = primaryColor
        static let subheadingText = secondaryColor
        static let normalText = primaryColor
        static let tableText = primaryColor
        static let buttonBg = primaryColor
        static let buttonText = accentColor
    }
    
    struct Strings {
        static let observationCancel = "You are about to erase this observation. Would you like to delete this observation and return to the Home screen?"
        
    }
}
