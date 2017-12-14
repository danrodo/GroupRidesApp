//
//  BlockedUserTableViewCell.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 12/11/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit
import CloudKit

class BlockedUserTableViewCell: UITableViewCell {

    var userIDString: String? {
        didSet {
            getBlockedUser()
        }
    }
    
    let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setUpViews(user: User?) {
        
        guard let user = user else { return }
        
        profilePictureImageView.layer.cornerRadius = 34
        profilePictureImageView.layer.masksToBounds = true

        profilePictureImageView.image = user.photo
//        profilePictureImageView.image = ImageHelper.shared.flipImage(image: user.photo ?? UIImage())

        nameLabel.text = "\(user.firstName) \(user.lastName)"
        
    }
    
    func getBlockedUser() {
        
        guard let userIDString = userIDString else { return }
        
        let recordID = CKRecordID(recordName: userIDString)
        
        cloudKitManager.fetchRecord(withID: recordID) { (record, error) in
            if let error = error {
                NSLog("Error fetching user associated with the block user ID string \(error)")
                return
            }
            guard let record = record else { return }
            let user = User(cloudKitRecord: record)
            DispatchQueue.main.async {
                self.setUpViews(user: user)
            }
        }
    }
}




















