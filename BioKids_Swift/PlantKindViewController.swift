//
//  PlantKindViewController.swift
//  BioKids_Swift
//
//  Created by Brandon Morton on 3/10/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit

class PlantKindViewController: UIViewController {

    var observation = Observation()
    @IBOutlet weak var grassBtn: UIButton!
    @IBOutlet weak var weedBtn: UIButton!
    @IBOutlet weak var vineBtn: UIButton!
    @IBOutlet weak var shrubBtn: UIButton!
    @IBOutlet weak var treeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(observation)
        // Do any additional setup after loading the view.
        
        grassBtn.layer.cornerRadius = 10
        weedBtn.layer.cornerRadius = 10
        vineBtn.layer.cornerRadius = 10
        shrubBtn.layer.cornerRadius = 10
        treeBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMessageToUser(title: String, msg: String)  {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            // Return
            print("pressed yes")
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("pressed no")
        }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressCancelBtn(_ sender: Any) {
        self.showMessageToUser(title: "Alert", msg: "You are about to erase this observation. Would you like to delete this observation and return to the Home screen?")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "kindOfGrassSegue" {
            let destination = segue.destination as! GrassTypeViewController
            destination.observation = observation
        }
        else {
            let destination = segue.destination as! AmountSensedViewController
            destination.observation = observation
        }
    }
}
