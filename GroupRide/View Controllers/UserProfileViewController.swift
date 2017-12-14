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
    
    var user: User?
    
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
        
        let title = "Are you sure?"
        let message = "You will wont be able to see any rides \(user.firstName) posts if you block them. But if you change your mind, you can always unblock them from your profile"
        
        presentAlertWith(title: title, message: message)
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
        
//        profilePictureImageView.image = ImageHelper.shared.flipImage(image: user?.photo ?? UIImage())
    }
    
    func presentAlertWith(title: String, message: String, color: UIColor = UIColor.white) {
        
        guard let user = user else { return }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = color
        alertContentView.layer.cornerRadius = 10.0
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        let continueAction = UIAlertAction(title: "Continue", style: .default) { (action) in
            BlockedUserController.shared.blockUser(userRecordIDString: user.recordIDString)
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(continueAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }

}







