//
//  FeedTableViewController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/23/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit
import CloudKit
import CoreLocation

class FeedTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    private let refreshViews = UIRefreshControl()
    
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var userLocation = ""
    
    // MARK: - Properties
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNamelabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationLabel.text = ""
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
        setUpViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rides = RideEventController.shared.rideList else { return 0 }
        let currentDate = Date()
        let filteredRides = rides.filter({$0.date > currentDate})
        return filteredRides.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "rideCell", for: indexPath) as? RideTableViewCell else { return RideTableViewCell() }

        guard let rides = RideEventController.shared.rideList else { return RideTableViewCell() }
        
        let currentDate = Date()
        
        let filteredRides = rides.filter({$0.date > currentDate})
        
        let ride = filteredRides[indexPath.row]
        
        cell.rideEvent = ride

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Retrueve the selected ride and the user that created the ride then send it to the detail VC
        
        if segue.identifier == "rideCellToDetailView" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            guard let rideEvents = RideEventController.shared.rideList else { return }
            
            let currentDate = Date()
            let filteredRides = rideEvents.filter({$0.date > currentDate})
            
            let rideEvent = filteredRides[indexPath.row]
            
            guard let user = RideEventController.shared.userDict[rideEvent.userRef.recordID] else { return }
            guard let destinationVC = segue.destination as? RideEventDetailViewController else { return }
            
            destinationVC.rideEvent = rideEvent
            destinationVC.user = user
        }
        
        if segue.identifier == "feedToNewRideEvent" {
            
            guard let destinationVC = segue.destination as? NewRideEventViewController else { return }
            destinationVC.location = self.userLocation
            
        }
        
        if segue.identifier == "feedToProfileSegue" {
            guard let destinatioinVC = segue.destination as? UserProfileViewController else { return }
            destinatioinVC.user = UserController.shared.currentUser
            destinatioinVC.location = self.locationLabel.text
        }
    }
    
    func setUpViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(ridesWereSet), name: RideEventKeys.rideEventFeedWasSetNotification, object: nil)

        tableView.addSubview(refreshViews)
        
        refreshViews.addTarget(self, action: #selector(refreshRideEvents(_:)), for: .valueChanged)
        
        firstNameLabel.text = UserController.shared.currentUser?.firstName
        lastNamelabel.text = UserController.shared.currentUser?.lastName
        profilePictureImageView.image = UserController.shared.currentUser?.photo
        
        profilePictureImageView.layer.cornerRadius = 15.0
        profilePictureImageView.layer.masksToBounds = true
        
        

    }
    
    // MARK: - Private helper funcs
    
    @objc private func refreshRideEvents(_ sender: Any) {
        RideEventController.shared.refreshData { (error) in
            if let error = error {
                NSLog("Error refreshing ride events, \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshViews.endRefreshing()
            }
        }
    }
    
    @objc func ridesWereSet() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if CLLocationManager.locationServicesEnabled() {
            geoCoder.reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks, error) in
                if let error = error {
                    NSLog("error getting geo information from location, \(error.localizedDescription)")
                    return
                }
                guard let placemarks = placemarks else { return }
                let placemark = placemarks[0] as CLPlacemark
                guard let userLocality = placemark.locality else { return }
                
                DispatchQueue.main.async {
                    self.userLocation = userLocality
                    self.locationLabel.text = userLocality
                    manager.stopUpdatingLocation()
                }
                
            })
        }
    }
}














