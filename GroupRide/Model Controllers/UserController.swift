//
//  UserController.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/23/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class UserController {
    
    static let shared = UserController()
    
    let cloudKitManager: CloudKitManager = {
        return CloudKitManager()
    }()
    
    var currentUser: User? {
        didSet{
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: UserKeys.currentUserWasSetNotification, object: nil)
            }
        }
    }
    
    // MARK: - Create User with custom properties
    
    func createUser(firstName: String, lastName: String, photoData: Data?, attendingRides: [CKReference], completion: @escaping (_ success: Bool) -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUsersRecordID, error) in
            guard let appleUsersRecordID = appleUsersRecordID else { return }
            
            let appleUserRef = CKReference(recordID: appleUsersRecordID, action: .deleteSelf)
            let user = User(firstName: firstName, lastName: lastName, appleUserRef: appleUserRef, photoData: photoData, attendingRides: attendingRides)
            
            let userRecord = CKRecord(user: user)
            
            CKContainer.default().publicCloudDatabase.save(userRecord, completionHandler: { (record, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let record = record, let currentUser = User(cloudKitRecord: record) else {
                    completion(false)
                    return
                }
                self.currentUser = currentUser
                completion(true)
            })
        }
    }
    
    // MARK: - Fetch the current user
    
    func fetchCurrentUser(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let appleUserRecordID = appleUserRecordID else {
                completion(false)
                return
            }
            
            let appleUserReference = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            
            let predicate = NSPredicate(format: "appleUserReference == %@", appleUserReference)
            
            self.cloudKitManager.fetchRecordsWithType(UserKeys.recordTypeKey, predicate: predicate, recordFetchedBlock: nil, completion: { [weak self] (records, error) in
                if let error = error {
                    completion(false)
                    print(error.localizedDescription)
                }
                guard let currentUserRecord = records?.first else {
                    completion(false)
                    return
                }
                let currentUser = User(cloudKitRecord: currentUserRecord)
                self?.currentUser = currentUser
                print("Found current User")
                completion(true)
            })
        }
    }
    
    // MARK: - Fetch all users attending a specified ride
    
    func fetchUsersAttending(rideEvent: RideEvent, completion: @escaping (_ attendingUsers: [User]?, _ success: Bool) -> Void = { _, _ in }) {
        
        guard let rideEventRecordID = rideEvent.cloudKitRecordID else { return }
        
        let predicate = NSPredicate(format: "%K CONTAINS %@", UserKeys.attendingRidesKey, rideEventRecordID)
        
        self.cloudKitManager.fetchRecordsWithType(UserKeys.recordTypeKey, predicate: predicate, recordFetchedBlock: nil) { (records, error) in
            if let error = error {
                NSLog("error fetching users associated with the ride event, \(error.localizedDescription)")
                completion(nil, false)
            }
            guard let records = records else {
                return completion(nil, false)
            }
            
            let users: [User] = records.flatMap { User(cloudKitRecord: $0) }
            completion(users, true)
        }
    }
    
    // Check to see if a given ride event is being attended by the current user
    
    
    
    func join(rideEvent: RideEvent, completion: @escaping ((_ success: Bool) -> Void) = { _ in }) {
        
        let rideRecord = CKRecord(rideEvent: rideEvent)
        
        let rideReference = CKReference(record: rideRecord, action: .none)
        UserController.shared.currentUser?.attendingRides.append(rideReference)
        let userRecord = CKRecord(user: UserController.shared.currentUser!)
        
        cloudKitManager.modifyRecords([userRecord], perRecordCompletion: nil) { (record, error) in
            if let error = error {
                NSLog("error joining ride when creating it, from ride even controller \(error.localizedDescription)")
                return completion(false)
            }
            LocalNotifScheduler.shared.scheduleNotification(event: rideEvent)
            completion(true)
        }
    }
    
    func leave(rideEvent: RideEvent, completion: @escaping ((_ success: Bool) -> Void) = { _ in }) {
        
        guard let updatedAttendingRides = UserController.shared.currentUser?.attendingRides.filter({ $0.recordID != rideEvent.cloudKitRecordID }) else { return }
        
        UserController.shared.currentUser?.attendingRides = updatedAttendingRides
        let updatedUserRecord = CKRecord(user: UserController.shared.currentUser!)
        
        cloudKitManager.modifyRecords([updatedUserRecord], perRecordCompletion: nil) { (_, error) in
            if let error = error {
                NSLog("Error leaving ride event \(error.localizedDescription)")
                return completion(false)
            }
            LocalNotifScheduler.shared.cancelLocalNotifications(for: rideEvent)
            completion(true)
        }
        
    }
}




































