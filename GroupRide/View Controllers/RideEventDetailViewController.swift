//
//  RideEventDetailViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/25/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class RideEventDetailViewController: UIViewController {
    
    var rideEvent: RideEvent?
    var user: User?
    
    // MARK: - Properties
    
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var joinRideButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func userProfileButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "rideEventDetailToUserProfile", sender: self)
        
    }
    
    @IBAction func joinRideButtonTapped(_ sender: Any) {
        
        guard let rideEvent = rideEvent else { return }
        UserController.shared.join(rideEvent: rideEvent) { (success) in
            if !success {
                // handle error
                return
            } else {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    self.joinRideButton.isEnabled = true
                }
            }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "attendingUsersSegue" {
            
            guard let destinationVC = segue.destination as? AttendingUsersTableViewController else { return }
            destinationVC.rideEvent = self.rideEvent
        }
        
        if segue.identifier == "rideEventDetailToUserProfile" {
            
            guard let user = user, let destinationVC = segue.destination as? UserProfileViewController else { return }
            destinationVC.user = user
            
        }
    }
    
    // MARK: - initial view setup
    
    func updateViews() {
        
        guard let rideEvent = rideEvent else { return }
        
        if let attendingRideList = UserController.shared.currentUser?.attendingRides.filter({ $0.recordID == rideEvent.cloudKitRecordID }).first  {
            DispatchQueue.main.async {
                self.joinRideButton.isEnabled = false
                self.joinRideButton.backgroundColor = UIColor.red
            }
        } else {
            DispatchQueue.main.async {
                // turn on join ride button
                self.joinRideButton.isEnabled = true
            }
        }
        
        let userRef = rideEvent.userRef
        let users = RideEventController.shared.userDict
        guard let user = users[userRef.recordID] else { return }
        
        profilePictureImageView.image = user.photo
        firstNameLabel.text = user.firstName
        lastNameLabel.text = user.lastName
        locationLabel.text = rideEvent.location
        
        descriptionLabel.text = rideEvent.description
        
        DateFormatHelper.shared.formatDate(date: rideEvent.date.description) { (success, newDate) in
            if !success {
                return
            }
            DispatchQueue.main.async {
                self.dateLabel.text = newDate
            }
        }
        
    }
}
