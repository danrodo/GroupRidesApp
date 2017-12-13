//
//  RideTableViewCell.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/25/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class RideTableViewCell: UITableViewCell {
    
    var rideEvent: RideEvent? {
        didSet{
            self.updateViews()
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let isAttendingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "isAttendingIcon")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let attendingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "attending: "
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    
    func updateViews() {
        
        self.backgroundColor = UIColor(white: 255.0/255.0, alpha: 0.5)
        guard let rideEvent = rideEvent else { return }
        let location = rideEvent.location
        let date = rideEvent.date
        let userRef = rideEvent.userRef
        
        let users = RideEventController.shared.userDict
        guard let user = users[userRef.recordID] else { return }
        
        self.addSubview(self.profileImageView)
        //
        DispatchQueue.main.async {
            self.profileImageView.image = user.photo
            
            self.addConstraintsWithFormat(format: "H:|-12-[v0(68)]", views: self.profileImageView)
            self.addConstraintsWithFormat(format: "V:|-12-[v0(68)]", views: self.profileImageView)
            
            self.addConstraint(NSLayoutConstraint(item: self.profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        }
    
        var isAttending = false
        
        guard let attendingRideList = UserController.shared.currentUser?.attendingRides.filter({ $0.recordID == rideEvent.cloudKitRecordID }).first else {
            isAttending = false
            DispatchQueue.main.async {
                self.setUpContainerView(user: user, date: date.description, location: location, isAttending: isAttending)
            }
            return
        }
        isAttending = true
        DispatchQueue.main.async {
            self.setUpContainerView(user: user, date: date.description, location: location, isAttending: isAttending)
        }
    }
    
    private func setUpContainerView(user: User, date: String, location: String, isAttending: Bool) {
        
        let containerView = UIView()
//        containerView.backgroundColor = UIColor.red
        
        DispatchQueue.main.async {
            self.addSubview(containerView)
            
            self.addConstraintsWithFormat(format: "H:|-90-[v0]|", views: containerView)
            self.addConstraintsWithFormat(format: "V:[v0(50)]", views: containerView)
            
            self.addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
            
            containerView.addSubview(self.nameLabel)
            containerView.addSubview(self.dateLabel)
            containerView.addSubview(self.locationLabel)
        }
        
        
        
        DateFormatHelper.shared.formatDate(date: date.description, completion: { (success, date) in
            if !success {
                NSLog("error formating date string")
                return
            }
            DispatchQueue.main.async {
                self.dateLabel.text = date
                self.nameLabel.text = "\(user.firstName) \(user.lastName)"
                self.locationLabel.text = location
            }
        })
        
        if isAttending == true {
            DispatchQueue.main.async {
                containerView.addSubview(self.isAttendingImageView)
                containerView.addSubview(self.attendingLabel)
                
                self.attendingLabel.isHidden = false
                self.isAttendingImageView.isHidden = false
                
                containerView.addConstraintsWithFormat(format: "H:|[v0][v1(110)]-12-|", views: self.nameLabel, self.dateLabel)
                containerView.addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: self.nameLabel, self.locationLabel)
                
                containerView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]-8-[v2(20)]-12-|", views: self.locationLabel, self.attendingLabel, self.isAttendingImageView)
                
                containerView.addConstraintsWithFormat(format: "V:|[v0(24)]", views: self.dateLabel)
                containerView.addConstraintsWithFormat(format: "V:[v0(20)]|", views: self.isAttendingImageView)
                containerView.addConstraintsWithFormat(format: "V:[v0(20)]|", views: self.attendingLabel)
            }
            
        
        } else {
            DispatchQueue.main.async {
                self.attendingLabel.isHidden = true
                self.isAttendingImageView.isHidden = true
                containerView.addConstraintsWithFormat(format: "H:|[v0][v1(110)]-12-|", views: self.nameLabel, self.dateLabel)
                containerView.addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: self.nameLabel, self.locationLabel)
                
                containerView.addConstraintsWithFormat(format: "H:|[v0]-12-|", views: self.locationLabel)
                
                containerView.addConstraintsWithFormat(format: "V:|[v0(24)]", views: self.dateLabel)
            }
        }
    }
}
