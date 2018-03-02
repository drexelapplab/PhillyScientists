//
//  AlertControllerTool.swift
//  BioKids_Swift
//
//  Created by Wangqy on 2018/2/11.
//  Copyright © 2018年 App Lab. All rights reserved.
//

import Foundation
import UIKit

class AlertControllerTool {
    
    /**
     alterController Two buttons  handle otherBtn event
     
     - parameter currentVC: Current View Controller
     - parameter meg:       Information Alert
     - parameter cancelBtn: Cancel Button
     - parameter otherBtn:  Other Button
     - parameter handler:   Other Buttons deal with the events
     */
    static func showAlert(currentVC:UIViewController, meg:String, cancelBtn:String, otherBtn:String?, handler:((UIAlertAction) -> Void)?){

        let alertController = UIAlertController(title:nil,
                                                message:meg ,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:cancelBtn, style: .cancel, handler:nil)
        
        alertController.addAction(cancelAction)
        
        if otherBtn != nil{
            let settingsAction = UIAlertAction(title: otherBtn, style: .default, handler: { (action) -> Void in
                handler?(action)
            })
            alertController.addAction(settingsAction)
        }
        currentVC.present(alertController, animated: true, completion: nil)
    }
    
    /**
     alterController: A single button, don't deal with events
     
     - parameter currentVC: Current ViewController
     - parameter meg:       Information Alert
     */
    static func showAlert(currentVC:UIViewController, cancelBtn:String, meg:String){
        showAlert(currentVC: currentVC, meg: meg, cancelBtn: cancelBtn, otherBtn: nil, handler: nil)
    }
    
    /**
     alterController A single button, deal with events
     
     - parameter currentVC: Current View controller
     - parameter meg:       Information Reminder
     - parameter otherBtn:      Other events
     - parameter otherHandler:  Call other events with a button
     */
    
    static func showAlert(currentVC:UIViewController, msg:String, otherBtn:String?, otherHandler:((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title:nil,
                                                message:msg ,
                                                preferredStyle: .alert)
        if otherBtn != nil{
            let settingsAction = UIAlertAction(title: otherBtn, style: .default, handler: { (action) -> Void in
                otherHandler?(action)
            })
            alertController.addAction(settingsAction)
        }
        currentVC.present(alertController, animated: true, completion: nil)
    }

    
    /**
     Two buttons deal with events
     
     - parameter currentVC:     Current View Controller
     - parameter meg:           Information Alert
     - parameter cancelBtn:     Cancel Button
     - parameter otherBtn:      Other Button
     - parameter cencelHandler: Cancel other events button
     - parameter handler:       Call the other events
     */
    static func showAlert(currentVC:UIViewController, meg:String, cancelBtn:String, otherBtn:String?,cencelHandler:((UIAlertAction) -> Void)?, handler:((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title:nil,
                                                message:meg ,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:cancelBtn, style: .cancel, handler:{ (action) -> Void in
            cencelHandler?(action)
        })
        alertController.addAction(cancelAction)
        if otherBtn != nil{
            let settingsAction = UIAlertAction(title: otherBtn, style: .default, handler: { (action) -> Void in
                handler?(action)
            })
            alertController.addAction(settingsAction)
        }
        currentVC.present(alertController, animated: true, completion: nil)
    }

}
