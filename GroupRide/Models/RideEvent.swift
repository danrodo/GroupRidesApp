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
    
    init(location: String, date: Date, description: String, userRef: CKReference) {
        self.location = location
        self.date = date
        self.description = description
        self.userRef = userRef
    }
}

// CloudKit functions

extension RideEvent {
    init?(cloudKitRecord: CKRecord) {
        guard let location = cloudKitRecord[RideEventKeys.locationKey] as? String,
            let date = cloudKitRecord[RideEventKeys.dateKey] as? Date,
            let description = cloudKitRecord[RideEventKeys.descriptionKey] as? String,
            let userRef = cloudKitRecord[RideEventKeys.userRefKey] as? CKReference else { return nil }
        
        self.location = location
        self.date = date
        self.description = description
        self.userRef = userRef
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
    }
}


















