//
//  LaunchScreenCopyViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/23/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit
import CoreLocation

class LaunchScreenCopyViewController: UIViewController {
    
    let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = myStoryboard.instantiateViewController(withIdentifier: "InitialViewController")
        let feedTableViewController = myStoryboard.instantiateViewController(withIdentifier: "FeedTableViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        cloudKitManager.checkCloudKitAvailability { (success) in
            if !success {
                NSLog("iCloud not available on this device")
                return
            } else {
                UserController.shared.fetchCurrentUser(completion: { (success) in
                    if !success {
                        DispatchQueue.main.async {
                            appDelegate.window?.rootViewController = initialViewController
                        }
                    } else {
                        RideEventController.shared.refreshData()
                        DispatchQueue.main.async {
                            appDelegate.window?.rootViewController = feedTableViewController
                        }
                    }
                })
            }
        }
    }
}














