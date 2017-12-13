//
//  AttendingUsersTableViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/27/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class AttendingUsersTableViewController: UITableViewController {
    
    var users: [User]? = [] {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var rideEvent: RideEvent? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let rideEvent = rideEvent else { return }
        UserController.shared.fetchUsersAttending(rideEvent: rideEvent) { [weak self] (users, success) in
            if success {
                self?.users = users
            } else {
                NSLog("Error fetching users attending this event")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.users = nil
    }


    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let users = users else { return 0 }
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendingUserCell", for: indexPath)

        guard let tempUsers = users else { return UITableViewCell() }
        let user = tempUsers[indexPath.row]
        
        cell.imageView?.image = ImageHelper.shared.flipImage(image: user.photo ?? UIImage())

        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"

        return cell
    }
}
