//
//  RideEvent.swift
//  GroupRide
//
//  Created by Daniel Rodosky on 10/22/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

struct RideEvent {
    var location: String
    var date: Date
    var description: String
    
    var cloudKitRecordID: CKRecordID?
    var userRef: CKReference
    
    var blockedUsers: Data?
    
    var blockedUsersArray: [String]? {
        guard let blockedUsers = blockedUsers else { return [] }
        guard let ret = (try? JSONSerialization.jsonObject(with: blockedUsers as Data, options: .allowFragments)) as? [String] else { return [] }
        return ret
    }
    
    init(location: String, date: Date, description: String, userRef: CKReference, blockedUsers: [BlockedUser]) {
        
        let blockedUserIDs: [String] = blockedUsers.flatMap({ $0.userRecordIDString })
        
        self.location = location
        self.date = date
        self.description = description
        self.userRef = userRef
        
        self.blockedUsers = try! JSONSerialization.data(withJSONObject: blockedUserIDs, options: .prettyPrinted) as Data
    }
}

// CloudKit functions

extension RideEvent {
    init?(cloudKitRecord: CKRecord) {
        guard let location = cloudKitRecord[RideEventKeys.locationKey] as? String,
            let date = cloudKitRecord[RideEventKeys.dateKey] as? Date,
            let description = cloudKitRecord[RideEventKeys.descriptionKey] as? String,
            let userRef = cloudKitRecord[RideEventKeys.userRefKey] as? CKReference,
            let blockedUsers = cloudKitRecord[RideEventKeys.blockedUsersKey] as? Data else { return nil }
        
        self.location = location
        self.date = date
        self.description = description
        self.userRef = userRef
        self.blockedUsers = blockedUsers
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
}

extension CKRecord {
    convenience init(rideEvent: RideEvent) {
        
        let recordID = rideEvent.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: RideEventKeys.recordTypeKey, recordID: recordID)
        
        self.setValue(rideEvent.location, forKey: RideEventKeys.locationKey)
        self.setValue(rideEvent.date, forKey: RideEventKeys.dateKey)
        self.setValue(rideEvent.description, forKey: RideEventKeys.descriptionKey)
        self.setValue(rideEvent.userRef, forKey: RideEventKeys.userRefKey)
        self.setValue(rideEvent.blockedUsers, forKey: RideEventKeys.blockedUsersKey)
    }
}


















