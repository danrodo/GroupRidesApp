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
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        cell.imageView?.image = user.photo
        cell.textLabel?.text = "\(user.firstName) \(user.lastName)"

        return cell
    }




}
