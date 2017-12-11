//
//  UserProfileViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 12/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit
import MessageUI

class UserProfileViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var user: User? = nil
    
    
    var location: String?
    
    @IBOutlet weak var blockedUsersButton: UIButton!
    @IBOutlet weak var blockUserButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var profilePictureImageView: UIImageView!

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBAction func blockUserButtonTapped(_ sender: Any) {
        blockUserButton.isEnabled = false
        guard let user = user else { return }
        print("BLOCKING USER \(user.firstName) \(user.lastName)")
        BlockedUserController.shared.blockUser(userRecordIDString: user.recordIDString)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
    }
    
    func setUpViews() {
        infoButton.layer.cornerRadius = infoButton.layer.frame.height / 2
        infoButton.tintColor = UIColor.black
        
        if user?.cloudKitRecordID != UserController.shared.currentUser?.cloudKitRecordID {
            // Not current user
            infoButton.isHidden = true
            blockedUsersButton.isHidden = true
        } else {
            //current user 
            blockUserButton.isHidden = true
        }
        
        self.firstNameLabel.text = user?.firstName
        self.lastNameLabel.text = user?.lastName
        self.locationLabel.text = self.location
        
        profilePictureImageView.image = user?.photo
        profilePictureImageView.layer.cornerRadius = 15.0
        profilePictureImageView.layer.masksToBounds = true
    }
    
    func configureMailController() -> MFMailComposeViewController {
        if let user = user {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients(["groupridesapp@gmail.com"])
            let name = "\(user.firstName) \(user.lastName)"
            mailComposerVC.setSubject("\(String(describing: name)) is reporting a user for inapropriate conduct")
            
            return mailComposerVC
        }
        return MFMailComposeViewController()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}







