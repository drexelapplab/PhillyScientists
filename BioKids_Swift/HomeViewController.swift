//
//  HomeViewController.swift
//  BioKids_Swift
//
//  Created by Joseph Baran on 10/20/17.
//  Copyright © 2017 App Lab. All rights reserved.
//

import UIKit
import SystemConfiguration
//func to check if connected to internet(taken from SO)

class HomeViewController: UIViewController {

    var connected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        //hides/shows registration button depending on internet connectivity
        if(!connected){
            RegButton.isHidden=true;
        }
        else{
            RegButton.isHidden=false;
        }
        
        // Do any additional setup after loading the view.
        HomeLink.addTarget(self, action: "didTapHome", for: .touchUpInside)
 */
        connected = isInternetAvailable()
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    //@IBOutlet weak var HomeLink: UIButton!
    
    //temporarily loads to stackoverflow
    //todo: replace ph link with actual phillyscientists link
    //@IBOutlet weak var RegButton: UIButton!
    /*@IBAction func didTapHome(sender: AnyObject) {
        UIApplication.shared.openURL(URL(string: "http://www.stackoverflow.com")!)
    }

    */
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
