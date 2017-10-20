//
//  HomeViewController.swift
//  BioKids_Swift
//
//  Created by Joseph Baran on 10/20/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        HomeLink.addTarget(self, action: "didTapHome", for: .touchUpInside)
    }
    @IBOutlet weak var HomeLink: UIButton!
    //temporarily loads to stackoverflow
    //todo: replace ph link with actual phillyscientists link
    @IBAction func didTapHome(sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "http://www.stackoverflow.com")!)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
